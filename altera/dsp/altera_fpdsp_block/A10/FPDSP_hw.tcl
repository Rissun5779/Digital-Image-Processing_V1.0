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


package require -exact qsys 14.0
package require altera_terp


source "../../lib/tcl/avalon_streaming_util.tcl"
source "../../lib/tcl/dspip_common.tcl"
load_strings FPDSP.properties

# |
# +-----------------------------------

# +-----------------------------------
# | module altera_cic
# |
set_module_property NAME altera_fpdsp_block
set_module_property AUTHOR [get_string AUTHOR]
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP [get_string GROUP]
set_module_property DISPLAY_NAME "Native Floating Point DSP Intel Arria 10 FPGA IP"
set_module_property DESCRIPTION [get_string DESCRIPTION]

set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ELABORATION_CALLBACK elab
set_module_property VALIDATION_CALLBACK validate
set_module_property SUPPORTED_DEVICE_FAMILIES {
    {ARRIA 10}

}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/eis1410764818924/eis1410936966508 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408

add_fileset ALTFP_DSP_QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth_callback
add_fileset ALTFP_DSP_QUARTUS_SYNTH SIM_VERILOG generate_sim_verilog
add_fileset ALTFP_DSP_QUARTUS_SYNTH SIM_VHDL generate_sim_vhdl
# set_module_property HELPER_JAR com.altera.dsp.fpdsp.ui.jar




    add_parameter OPERATION string "sp_mult"
    set_parameter_property OPERATION DISPLAY_NAME "DSP Template"
    set_parameter_property OPERATION UNITS None
    set_parameter_property OPERATION DESCRIPTION "Set the mode that the DSP operates, the modes are demonstrated in the diagram below"
    set_parameter_property OPERATION ALLOWED_RANGES [list "sp_mult:Multiply" "sp_add:Add" "sp_mult_add:Multiply Add" "sp_mult_acc:Multiply Accumulate" "sp_vector1:Vector Mode 1" "sp_vector2:Vector Mode 2"]
    set_parameter_property OPERATION AFFECTS_GENERATION true

    add_parameter VIEW string "Register Enables"
    set_parameter_property VIEW DISPLAY_NAME "View"
    set_parameter_property VIEW UNITS None
    set_parameter_property VIEW DESCRIPTION "Set the view on the diagram below, whether to show the clock/clock enable domains or the reset domains"
    set_parameter_property VIEW ALLOWED_RANGES [list "Register Enables" "Register Clears"]
    set_parameter_property VIEW AFFECTS_GENERATION true

    add_parameter single_clear boolean false
    set_parameter_property single_clear VISIBLE true
    set_parameter_property single_clear DISPLAY_NAME "Use Single Clear"
    set_parameter_property single_clear DESCRIPTION "Choose whether to clear all registers on 1 signal, or to have separate clears for the input registers"


add_display_item "DSP Block View" widget_group group tab
add_display_item widget_group arria_widget parameter
set jar_path [file join $env(QUARTUS_ROOTDIR) .. ip altera dsp altera_fpdsp_block A10 com.altera.dsp.fpdsp.ui.jar]
set widget_name "arria_dsp"
set_display_item_property widget_group WIDGET [list $jar_path $widget_name]





###################### Parameters 

proc get_clocks {} {
    return  [list ax_clock ay_clock az_clock output_clock accumulate_clock ax_chainin_pl_clock accum_pipeline_clock mult_pipeline_clock adder_input_clock  adder_input_2_clock accum_adder_clock]
}
#Set of clocks that actually show up in the HDL
proc get_hdl_clocks {} {
    return  [list ax_clock ay_clock az_clock output_clock accumulate_clock ax_chainin_pl_clock accum_pipeline_clock mult_pipeline_clock adder_input_clock  accum_adder_clock]
}

proc get_used_clocks {} {

   if { [string equal [get_parameter_value OPERATION] "sp_mult"] } {
        return  [list ay_clock az_clock output_clock mult_pipeline_clock]
   } elseif  { [string equal [get_parameter_value OPERATION] "sp_add"] } {
        return  [list ax_clock ay_clock output_clock ax_chainin_pl_clock adder_input_clock  adder_input_2_clock]
   } elseif  { [string equal [get_parameter_value OPERATION] "sp_mult_add"] } {
        if { [get_parameter_value chain_mux] } {
            return [list ay_clock az_clock output_clock ax_chainin_pl_clock mult_pipeline_clock adder_input_clock  adder_input_2_clock]
        } else {
            return [list ax_clock ay_clock az_clock output_clock ax_chainin_pl_clock mult_pipeline_clock adder_input_clock  adder_input_2_clock]
        }
   } elseif  { [string equal [get_parameter_value OPERATION] "sp_mult_acc"] } {
        return  [list ay_clock az_clock output_clock accumulate_clock accum_pipeline_clock mult_pipeline_clock adder_input_2_clock accum_adder_clock]
   } elseif  { [string equal [get_parameter_value OPERATION] "sp_vector1"] } {
        return  [list ax_clock ay_clock az_clock output_clock ax_chainin_pl_clock mult_pipeline_clock adder_input_clock  adder_input_2_clock]
   } elseif  { [string equal [get_parameter_value OPERATION] "sp_vector2"] } {
        return  [list ax_clock ay_clock az_clock output_clock ax_chainin_pl_clock mult_pipeline_clock adder_input_clock  adder_input_2_clock]
   } else {
        return  [list ax_clock ay_clock az_clock output_clock accumulate_clock ax_chainin_pl_clock accum_pipeline_clock mult_pipeline_clock adder_input_clock  adder_input_2_clock accum_adder_clock]
   }
}


    foreach clock [get_clocks] {
        add_parameter $clock string "0"
        set_parameter_property $clock VISIBLE false
    }    
    foreach clock [get_hdl_clocks] {
        add_parameter "${clock}_derived" string "0"
        set_parameter_property "${clock}_derived" VISIBLE false
        set_parameter_property "${clock}_derived" derived true
    }


    add_parameter adder_subtract boolean false
    set_parameter_property adder_subtract VISIBLE false

    add_parameter chain_mux string "0"
    set_parameter_property chain_mux VISIBLE false
    add_parameter chain_out_mux string "0"
    set_parameter_property chain_out_mux VISIBLE false
    add_parameter possible_registers string "0"
    set_parameter_property possible_registers VISIBLE false
    set_parameter_property possible_registers derived true


    set_display_item_property widget_group WIDGET_PARAMETER_MAP  {
            OPERATION  OPERATION
            VIEW  VIEW
            ax_clock             ax_clock
            ay_clock             ay_clock
            az_clock             az_clock
            output_clock             output_clock
            accumulate_clock             accumulate_clock
            ax_chainin_pl_clock             ax_chainin_pl_clock
            accum_pipeline_clock             accum_pipeline_clock
            mult_pipeline_clock             mult_pipeline_clock
            adder_input_clock             adder_input_clock
            adder_input_2_clock             adder_input_2_clock
            accum_adder_clock             accum_adder_clock
            adder_subtract             adder_subtract
            chain_mux             chain_mux
            chain_out_mux             chain_out_mux
            single_clear             single_clear
            possible_registers        possible_registers

           }       



proc render_terp {output_name terp_file} {
    # get template

    set template_path $terp_file  ;# path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it



    # add port details to template parameters
    # note that element must be appended to lists evenly and in-order or else iteration will not work
    # calculate output_width    

    foreach parameter_name [lsort [get_parameters]] {
        set params($parameter_name) [get_parameter_value $parameter_name]
    }
    set params(interfaces) [get_interfaces] 
    set params(hdl_clocks) [get_hdl_clocks] 
    set params(used_clocks) [get_used_clocks] 
    set params(output_name) $output_name ;# template params are element of a Tcl array
   # process template with parameters
    set contents [altera_terp $template params] ;# pass parameter array in by reference
    return $contents    
}




proc add_filesets {} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset" 
    }
}

proc quartus_synth_callback {output_name} {  
    set type synth

    set filename ${output_name}.sv ;# dependent on what Qsys gives us as the output name
    set terp_file "dsp_block.sv.template"
    set top_level_contents [render_terp $output_name $terp_file]
    add_fileset_file $filename SYSTEM_VERILOG TEXT $top_level_contents TOP_LEVEL_FILE

}

proc generate_sim_vhdl {output_name} {
    set type synth

    set filename ${output_name}.vhd ;# dependent on what Qsys gives us as the output name
    set terp_file "dsp_block.vhd.template"
    set top_level_contents [render_terp $output_name $terp_file]
    add_fileset_file $filename VHDL TEXT $top_level_contents TOP_LEVEL_FILE
}

proc generate_sim_verilog {output_name} {
    set type synth

    set filename ${output_name}.sv ;# dependent on what Qsys gives us as the output name
    set terp_file "dsp_block.sv.template"
    set top_level_contents [render_terp $output_name $terp_file]
    add_fileset_file $filename SYSTEM_VERILOG TEXT $top_level_contents TOP_LEVEL_FILE
}




proc get_simulator_list {} {
    return { \
             {mentor   0   } \ #0
             {aldec    0    } \ #0
             {synopsys 0 } \ #0
             {cadence  0  } \ #0
           }
}

# | 
# +-----------------------------------



proc add_interface_input { name bit_width } {
    add_interface $name conduit end
    set_interface_property $name associatedClock clk
    set_interface_property $name associatedReset areset
    set_interface_property $name ENABLED true
    add_interface_port $name $name $name Input $bit_width 
}

proc add_interface_output { name bit_width } {
    add_interface $name conduit start
    set_interface_assignment $name "ui.blockdiagram.direction" OUTPUT
    set_interface_property $name associatedClock clk
    set_interface_property $name associatedReset ""
    add_interface_port $name $name $name Output $bit_width
}

 


add_parameter total_clks_used integer 0
set_parameter_property total_clks_used derived true
set_parameter_property total_clks_used visible false
add_parameter clk0_used boolean false
set_parameter_property clk0_used derived true
set_parameter_property clk0_used visible false
add_parameter clk1_used boolean false
set_parameter_property clk1_used derived true
set_parameter_property clk1_used visible false
add_parameter clk2_used boolean false
set_parameter_property clk2_used derived true
set_parameter_property clk2_used visible false

add_parameter use_chainin boolean false
set_parameter_property use_chainin derived true
set_parameter_property use_chainin visible false

add_parameter use_chainout boolean false
set_parameter_property use_chainout derived true
set_parameter_property use_chainout visible false




proc elab {} {


    set_parameter_value clk0_used false
    set_parameter_value clk1_used false
    set_parameter_value clk2_used false
    set total_clks_used 0
    foreach clock [get_clocks] {
        if { [string equal [get_parameter_value $clock]  "0"] && ([lsearch -nocase [get_used_clocks]  $clock  ] != -1)  } {
            set_parameter_value clk0_used true
        }        
        if { [string equal [get_parameter_value $clock]  "1"] && ([lsearch -nocase [get_used_clocks]  $clock  ] != -1) } {
            set_parameter_value clk1_used true
        }         
        if { [string equal [get_parameter_value $clock]  "2"] && ([lsearch -nocase [get_used_clocks]  $clock  ] != -1) } {
            set_parameter_value clk2_used true
        } 
    }
    if { ([get_parameter_value clk2_used]  && (![get_parameter_value clk1_used] || ![get_parameter_value clk0_used] ))
            || ([get_parameter_value clk1_used]  && ![get_parameter_value clk0_used] ) } {
            send_message ERROR "Please ensure clocks are used in order, Clock 2 cannot be used without using clocks 0 & 1, clock 1 cannot be used with clock 0 already used"
    }
    if {[get_parameter_value clk0_used] } {
        set total_clks_used [expr $total_clks_used + 1]
    }    
    if {[get_parameter_value clk1_used] } {
        set total_clks_used [expr $total_clks_used + 1]
    }    
    if {[get_parameter_value clk2_used] } {
        set total_clks_used [expr $total_clks_used + 1]
    }
    set_parameter_value total_clks_used $total_clks_used

    if { $total_clks_used > 0 } {
        add_interface_input clk $total_clks_used
        add_interface_input ena $total_clks_used
    }
    if { [get_parameter_value single_clear]  } {
        add_interface_input aclr 1
    } else {
        add_interface_input aclr 2
    }




    set operation [get_parameter_value OPERATION]
    add_interface_output "result" 32

    if {$operation eq "sp_mult"} {
        add_interface_input "ay" 32
        add_interface_input "az" 32
    } elseif {$operation eq"sp_add"} {
        add_interface_input "ax" 32
        add_interface_input "ay" 32
    } elseif {$operation eq "sp_mult_add"} {
        if {[get_parameter_value chain_mux]} {
            add_interface_input "chainin" 32
            set_parameter_value use_chainin true
        } else {
            add_interface_input "ax" 32
        }
        add_interface_input "ay" 32
        add_interface_input "az" 32
    } elseif {$operation eq "sp_mult_acc"} {
        add_interface_input "accumulate" 1
        add_interface_input "ay" 32
        add_interface_input "az" 32
    } else {
        add_interface_input "chainin" 32
        set_parameter_value use_chainin true

        add_interface_input "ax" 32
        add_interface_input "ay" 32
        add_interface_input "az" 32
    }
    if {[get_parameter_value chain_out_mux] == "1"} {
            add_interface_output "chainout" 32
            set_parameter_value use_chainout true

    }

    if { [get_parameter_value use_chainin] || [get_parameter_value use_chainout] } {
        send_message INFO "When using Chainin and Chainout ports they must be connected to chainin/chainout ports of another DSP Block"
    }
    set_parameter_value possible_registers [join [get_used_clocks] ","]
}


proc validate {} {
 set operation [get_parameter_value OPERATION]
 set list_of_fixed_clock_modes [list sp_vector1 sp_vector2 sp_add sp_mult_add ]
 if { ![string equal [get_parameter_value adder_input_2_clock] [get_parameter_value adder_input_clock] ] &&   ([lsearch -nocase $list_of_fixed_clock_modes  $operation  ] != -1) } {
    send_message ERROR "Adder input registers must share the same clock"
 } 
 set list_of_fixed_clock_modes [list sp_vector1 sp_vector2 sp_mult_add ]
 if { ![string equal [get_parameter_value ax_clock] [get_parameter_value az_clock] ] &&   ([lsearch -nocase $list_of_fixed_clock_modes  $operation  ] != -1) } {
    send_message ERROR "Input registers Ax and Az must share the same clock when used"
 }
 foreach cur_clock [get_hdl_clocks] {
    if { [string equal $cur_clock "adder_input_clock"] } {
            if { [lsearch -nocase [get_used_clocks]  "adder_input_clock"  ] != -1 } {
                    set_parameter_value "${cur_clock}_derived" [get_parameter_value adder_input_clock]
            } elseif { [lsearch -nocase [get_used_clocks]  "adder_input_2_clock"  ] != -1 } {
                    set_parameter_value "${cur_clock}_derived" [get_parameter_value adder_input_2_clock]
            }
    } elseif { [lsearch -nocase [get_used_clocks]  $cur_clock  ] != -1 } {
        set_parameter_value "${cur_clock}_derived" [get_parameter_value $cur_clock]
    } else {
        set_parameter_value "${cur_clock}_derived" "NONE"
    }
 }

}   
