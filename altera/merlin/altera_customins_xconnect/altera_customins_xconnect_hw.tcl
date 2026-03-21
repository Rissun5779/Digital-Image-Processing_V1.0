# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# +-----------------------------------
# | Custom instruction interconnect
# +-----------------------------------

package require -exact altera_terp 1.0
package require -exact sopc 11.0

# +-----------------------------------
# | 
set_module_property NAME altera_customins_xconnect
set_module_property VERSION 18.1
set_module_property AUTHOR "Altera Corporation"
set_module_property GROUP "Processors and Peripherals/Co-Processors/Nios II Custom Instructions"
set_module_property DISPLAY_NAME "Custom Instruction Interconnect"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ELABORATION_CALLBACK elaborate
add_fileset synth   QUARTUS_SYNTH generate
add_fileset sim     SIM_VERILOG   generate
add_fileset simvhdl SIM_VHDL      generate
set_module_property HIDE_FROM_SOPC true
set_module_property ANALYZE_HDL FALSE
set_module_property HIDE_FROM_QUARTUS true
# | 
# +-----------------------------------


# +-----------------------------------
# | Parameters
# |

add_parameter MASTER_INDEX INTEGER_LIST 
set_parameter_property MASTER_INDEX DISPLAY_NAME "Master"
set_parameter_property MASTER_INDEX AFFECTS_ELABORATION true

add_parameter OPCODE_L INTEGER_LIST 
set_parameter_property OPCODE_L DISPLAY_NAME "Opcode (low)"
set_parameter_property OPCODE_L AFFECTS_ELABORATION true

add_parameter OPCODE_H INTEGER_LIST 
set_parameter_property OPCODE_H DISPLAY_NAME "Opcode (high)"
set_parameter_property OPCODE_H AFFECTS_ELABORATION true

add_parameter ENABLE_MULTICYCLE INTEGER 0
set_parameter_property ENABLE_MULTICYCLE DISPLAY_NAME "Enable multicycle logic"
set_parameter_property ENABLE_MULTICYCLE AFFECTS_ELABORATION true
set_parameter_property ENABLE_MULTICYCLE ALLOWED_RANGES "0:1"
set_parameter_property ENABLE_MULTICYCLE DISPLAY_HINT "boolean"

add_display_item "" "Opcode Map" GROUP TABLE
add_display_item "Opcode Map" MASTER_INDEX PARAMETER
add_display_item "Opcode Map" OPCODE_L PARAMETER
add_display_item "Opcode Map" OPCODE_H PARAMETER
# | 
# +-----------------------------------

add_interface ci_slave nios_custom_instruction slave
add_interface_port ci_slave ci_slave_dataa dataa Input 32
add_interface_port ci_slave ci_slave_datab datab Input 32
add_interface_port ci_slave ci_slave_result result Output 32
add_interface_port ci_slave ci_slave_n n Input 8
add_interface_port ci_slave ci_slave_readra readra Input 1
add_interface_port ci_slave ci_slave_readrb readrb Input 1
add_interface_port ci_slave ci_slave_writerc writerc Input 1
add_interface_port ci_slave ci_slave_a a Input 5
add_interface_port ci_slave ci_slave_b b Input 5
add_interface_port ci_slave ci_slave_c c Input 5
add_interface_port ci_slave ci_slave_ipending ipending Input 32
add_interface_port ci_slave ci_slave_estatus estatus Input 1

proc elaborate { } {

    set indices [ get_parameter_value MASTER_INDEX ]
    set num_outputs [ llength $indices ]
    set multicycle [ get_parameter_value ENABLE_MULTICYCLE ]

    if { $multicycle } {
        add_interface_port ci_slave ci_slave_clk   clk    Input 1
        add_interface_port ci_slave ci_slave_reset reset  Input 1
        add_interface_port ci_slave ci_slave_clken clk_en Input 1
        add_interface_port ci_slave ci_slave_reset_req reset_req Input 1
        add_interface_port ci_slave ci_slave_start start  Input 1
        add_interface_port ci_slave ci_slave_done  done   Output 1
    }

    for { set i 0 } { $i < $num_outputs } { incr i } {
        add_interface ci_master${i} nios_custom_instruction master
        add_interface_port ci_master${i} ci_master${i}_dataa dataa Output 32
        add_interface_port ci_master${i} ci_master${i}_datab datab Output 32
        add_interface_port ci_master${i} ci_master${i}_result result Input 32
        add_interface_port ci_master${i} ci_master${i}_n n Output 8
        add_interface_port ci_master${i} ci_master${i}_readra readra Output 1
        add_interface_port ci_master${i} ci_master${i}_readrb readrb Output 1
        add_interface_port ci_master${i} ci_master${i}_writerc writerc Output 1
        add_interface_port ci_master${i} ci_master${i}_a a Output 5
        add_interface_port ci_master${i} ci_master${i}_b b Output 5
        add_interface_port ci_master${i} ci_master${i}_c c Output 5
        add_interface_port ci_master${i} ci_master${i}_ipending ipending Output 32
        add_interface_port ci_master${i} ci_master${i}_estatus estatus Output 1

        if { $multicycle } {
            add_interface_port ci_master${i} ci_master${i}_clk   clk    Output 1
            add_interface_port ci_master${i} ci_master${i}_reset reset  Output 1
            add_interface_port ci_master${i} ci_master${i}_clken clk_en Output 1
            add_interface_port ci_master${i} ci_master${i}_reset_req reset_req Output 1
            add_interface_port ci_master${i} ci_master${i}_start start  Output 1
            add_interface_port ci_master${i} ci_master${i}_done  done   Input 1
        }
    }
}


proc generate { output_name } {

    set template_file "altera_customins_xconnect.sv.terp"


    set template    [ read [ open $template_file r ] ]

    set params(master_index)    [ get_parameter_value MASTER_INDEX ]
    set params(opcode_l)        [ get_parameter_value OPCODE_L ]
    set params(opcode_h)        [ get_parameter_value OPCODE_H ]
    set params(multicycle)      [ get_parameter_value ENABLE_MULTICYCLE ]

    set params(output_name) $output_name

    set result          [ altera_terp $template params ]

    add_fileset_file ${output_name}.sv SYSTEM_VERILOG TEXT $result

}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_nios2_custom_instruction.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
