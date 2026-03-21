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

source "src/tcl_libs/altera_cic_ii_helper.tcl"
source "../lib/tcl/avalon_streaming_util.tcl"
source "../lib/tcl/dspip_common.tcl"
load_strings altera_cic_ii.properties

# |
# +-----------------------------------

# +-----------------------------------
# | module altera_cic
# |
set_module_property NAME altera_cic_ii
set_module_property AUTHOR [get_string AUTHOR]
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP [get_string GROUP]
set_module_property DISPLAY_NAME "CIC"
set_module_property DESCRIPTION [get_string DESCRIPTION]
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HELPER_JAR cic_helper.jar
set_module_property ELABORATION_CALLBACK elab
set_module_property VALIDATION_CALLBACK validation_cic_top

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/hco1421847945390/hco1421847882821      
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697778790

set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10}
    {CYCLONE IV GX} {CYCLONE IV E} {CYCLONE V} {CYCLONE 10 LP}
    {MAX 10 FPGA} {STRATIX 10}
}



###################### Parameters 


proc add_module_parameters_filter_type {} {
    add_parameter FILTER_TYPE string "interpolator"
    set_parameter_property FILTER_TYPE DISPLAY_NAME [get_string FILTER_TYPE_DISPLAY_NAME ]
    set_parameter_property FILTER_TYPE UNITS None
    set_parameter_property FILTER_TYPE DESCRIPTION [get_string FILTER_TYPE_DESCRIPTION]
    set_parameter_property FILTER_TYPE ALLOWED_RANGES [list "interpolator:[get_string FILTER_INTERPOLATOR_NAME]" "decimator:[get_string FILTER_DECIMATOR_NAME]"]
    set_parameter_property FILTER_TYPE GROUP [get_string FILTER_SPEC_SECTION_NAME]
    set_parameter_property FILTER_TYPE AFFECTS_GENERATION true
}

proc add_module_parameters_number_of_stages {} {
    add_parameter STAGES INTEGER 12
    set_parameter_property STAGES DISPLAY_NAME [get_string STAGES_DISPLAY_NAME ]
    set_parameter_property STAGES UNITS None
    set_parameter_property STAGES ALLOWED_RANGES 1:12
    set_parameter_property STAGES DESCRIPTION [get_string STAGES_DESCRIPTION]
    set_parameter_property STAGES GROUP [get_string FILTER_SPEC_SECTION_NAME]
    set_parameter_property STAGES AFFECTS_GENERATION true

}

proc add_module_parameters_differential_delay {} {
    add_parameter D_DELAY INTEGER 1 
    set_parameter_property D_DELAY DISPLAY_NAME [get_string D_DELAY_DISPLAY_NAME ]
    set_parameter_property D_DELAY UNITS Cycles
    set_parameter_property D_DELAY ALLOWED_RANGES 1:2
    set_parameter_property D_DELAY DESCRIPTION [get_string D_DELAY_DESCRIPTION]
    set_parameter_property D_DELAY GROUP [get_string FILTER_SPEC_SECTION_NAME]
    set_parameter_property D_DELAY AFFECTS_GENERATION true

}

proc add_module_parameters_variable_rate {} {
    add_parameter VRC_EN INTEGER 0
    set_parameter_property VRC_EN DISPLAY_NAME [get_string VRC_EN_DISPLAY_NAME ]
    set_parameter_property VRC_EN UNITS None
    set_parameter_property VRC_EN DESCRIPTION [get_string VRC_EN_DESCRIPTION]
    set_parameter_property VRC_EN DISPLAY_HINT boolean
    set_parameter_property VRC_EN GROUP [get_string FILTER_SPEC_SECTION_NAME]
    set_parameter_property VRC_EN AFFECTS_GENERATION true


    add_parameter RCF_FIX INTEGER 8
    set_parameter_property RCF_FIX DISPLAY_NAME [get_string RCF_FIX_DISPLAY_NAME ]
    set_parameter_property RCF_FIX UNITS None
    set_parameter_property RCF_FIX DESCRIPTION [get_string RCF_FIX_DESCRIPTION]
    set_parameter_property RCF_FIX GROUP [get_string FILTER_SPEC_SECTION_NAME]

    add_parameter RCF_LB INTEGER 8
    set_parameter_property RCF_LB DISPLAY_NAME [get_string RCF_LB_DISPLAY_NAME ]
    set_parameter_property RCF_LB ENABLED false
    set_parameter_property RCF_LB VISIBLE false
    set_parameter_property RCF_LB UNITS None
    set_parameter_property RCF_LB DESCRIPTION [get_string RCF_LB_DESCRIPTION]
    set_parameter_property RCF_LB GROUP [get_string FILTER_SPEC_SECTION_NAME]

    add_parameter RCF_UB INTEGER 21
    set_parameter_property RCF_UB DISPLAY_NAME [get_string RCF_UB_DISPLAY_NAME ]
    set_parameter_property RCF_UB ENABLED false
    set_parameter_property RCF_UB VISIBLE false
    set_parameter_property RCF_UB UNITS None
    set_parameter_property RCF_UB DESCRIPTION [get_string RCF_UB_DESCRIPTION]
    set_parameter_property RCF_UB GROUP [get_string FILTER_SPEC_SECTION_NAME]

    add_parameter RCF_MIN INTEGER 8
    set_parameter_property RCF_MIN DERIVED TRUE
    set_parameter_property RCF_MIN VISIBLE false
    set_parameter_property RCF_MIN AFFECTS_GENERATION true

    add_parameter RCF_MAX INTEGER 21
    set_parameter_property RCF_MAX DERIVED TRUE
    set_parameter_property RCF_MAX VISIBLE false
    set_parameter_property RCF_MAX AFFECTS_GENERATION true


}


proc add_module_parameters_multi_channel {} {
    add_parameter INTERFACES INTEGER 1
    set_parameter_property INTERFACES DISPLAY_NAME [get_string INTERFACES_DISPLAY_NAME ]
    set_parameter_property INTERFACES ALLOWED_RANGES 1:128
    set_parameter_property INTERFACES UNITS None
    set_parameter_property INTERFACES DESCRIPTION [get_string INTERFACES_DESCRIPTION] 
    set_parameter_property INTERFACES GROUP [get_string FILTER_SPEC_SECTION_NAME]
    set_parameter_property INTERFACES AFFECTS_GENERATION true

    add_parameter CH_PER_INT INTEGER 1
    set_parameter_property CH_PER_INT DISPLAY_NAME [get_string CH_PER_INT_DISPLAY_NAME ] 
    set_parameter_property CH_PER_INT ALLOWED_RANGES 1:1024
    set_parameter_property CH_PER_INT UNITS None
    set_parameter_property CH_PER_INT DESCRIPTION [get_string CH_PER_INT_DESCRIPTION]
    set_parameter_property CH_PER_INT GROUP [get_string FILTER_SPEC_SECTION_NAME]
    set_parameter_property CH_PER_INT AFFECTS_GENERATION true

}



proc add_module_data_storage {} {


    add_parameter INT_USE_MEM BOOLEAN  false
    set_parameter_property INT_USE_MEM DISPLAY_NAME [get_string INT_USE_MEM_DISPLAY_NAME ]
    set_parameter_property INT_USE_MEM ENABLED false
    set_parameter_property INT_USE_MEM VISIBLE false
    set_parameter_property INT_USE_MEM DERIVED true
    set_parameter_property INT_USE_MEM DISPLAY_HINT boolean
    set_parameter_property INT_USE_MEM GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property INT_USE_MEM AFFECTS_GENERATION true

    add_parameter INT_MEM string "auto"
    set_parameter_property INT_MEM DISPLAY_NAME [get_string INT_MEM_DISPLAY_NAME ]
    set_parameter_property INT_MEM ENABLED true
    set_parameter_property INT_MEM VISIBLE false
    set_parameter_property INT_MEM DERIVED true
    set_parameter_property INT_MEM              ALLOWED_RANGES  [all_memory_options]
    set_parameter_property INT_MEM GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property INT_MEM AFFECTS_GENERATION true

    add_parameter REQ_INT_MEM string "logic_element" 
    set_parameter_property REQ_INT_MEM DISPLAY_NAME [get_string INT_MEM_DISPLAY_NAME ] 
    set_parameter_property REQ_INT_MEM DESCRIPTION [get_string INT_MEM_DESCRIPTION] 
    set_parameter_property REQ_INT_MEM GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property REQ_INT_MEM    ALLOWED_RANGES   [all_memory_options]


    add_parameter DIF_USE_MEM BOOLEAN  false
    set_parameter_property DIF_USE_MEM DISPLAY_NAME [get_string DIF_USE_MEM_DISPLAY_NAME ]
    set_parameter_property DIF_USE_MEM ENABLED true
    set_parameter_property DIF_USE_MEM VISIBLE false
    set_parameter_property DIF_USE_MEM DERIVED true
    set_parameter_property DIF_USE_MEM DISPLAY_HINT boolean
    set_parameter_property DIF_USE_MEM GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property DIF_USE_MEM AFFECTS_GENERATION true

    add_parameter DIF_MEM string "auto"
    set_parameter_property DIF_MEM DISPLAY_NAME [get_string DIF_MEM_DISPLAY_NAME ]
    set_parameter_property DIF_MEM ENABLED true
    set_parameter_property DIF_MEM VISIBLE false
    set_parameter_property DIF_MEM DERIVED true
    set_parameter_property DIF_MEM GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property DIF_MEM AFFECTS_GENERATION true
    set_parameter_property DIF_MEM          ALLOWED_RANGES   [all_memory_options]

    add_parameter REQ_DIF_MEM string "logic_element"
    set_parameter_property REQ_DIF_MEM DISPLAY_NAME [get_string DIF_MEM_DISPLAY_NAME ]
    set_parameter_property REQ_DIF_MEM DESCRIPTION [get_string DIF_MEM_DESCRIPTION] 
    set_parameter_property REQ_DIF_MEM GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property REQ_DIF_MEM          ALLOWED_RANGES   [all_memory_options]

    
}

proc add_module_optimizations {} {


    add_parameter REQ_PIPELINE INTEGER 0
    set_parameter_property REQ_PIPELINE DISPLAY_NAME "Pipeline stages per integrator"
    set_parameter_property REQ_PIPELINE VISIBLE false
    set_parameter_property REQ_PIPELINE UNITS None
    set_parameter_property REQ_PIPELINE DESCRIPTION [get_string REQ_PIPELINE_DESCRIPTION] 
    set_parameter_property REQ_PIPELINE ALLOWED_RANGES  0:1024
    set_parameter_property REQ_PIPELINE GROUP [get_string IMPLEMENTATION_SECTION_NAME]

    add_parameter PIPELINING INTEGER 0
    set_parameter_property PIPELINING DISPLAY_NAME "Pipeline stages per integrator"
    set_parameter_property PIPELINING ENABLED false
    set_parameter_property PIPELINING UNITS None    
    set_parameter_property PIPELINING DERIVED  true
    set_parameter_property PIPELINING GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property PIPELINING AFFECTS_GENERATION true

}

proc add_hyper_pipeline {} {
    add_parameter hyper_opt_select INTEGER 0
    set_parameter_property hyper_opt_select DISPLAY_NAME "Optimize for Stratix 10"
    set_parameter_property hyper_opt_select UNITS None
    set_parameter_property hyper_opt_select VISIBLE false
    set_parameter_property hyper_opt_select DESCRIPTION "Enable the optimization for Stratix 10 (Can be evaluated on S10 early access model of Arria 10 family)"
    set_parameter_property hyper_opt_select DISPLAY_HINT boolean
    set_parameter_property hyper_opt_select GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property hyper_opt_select AFFECTS_GENERATION true

    add_parameter hyper_opt INTEGER 0
    set_parameter_property hyper_opt VISIBLE false
    set_parameter_property hyper_opt DERIVED true
    set_parameter_property hyper_opt_select GROUP [get_string IMPLEMENTATION_SECTION_NAME]
    set_parameter_property hyper_opt_select AFFECTS_GENERATION true
}

proc add_module_input_options {} {
    add_parameter  IN_WIDTH INTEGER 8
    set_parameter_property IN_WIDTH DISPLAY_NAME "Input data width"
    set_parameter_property IN_WIDTH UNITS Bits
    set_parameter_property IN_WIDTH ALLOWED_RANGES 1:32
    set_parameter_property IN_WIDTH DESCRIPTION [get_string IN_WIDTH_DESCRIPTION]
    set_parameter_property IN_WIDTH GROUP [get_string INTERFACE_SECTION_NAME]
    set_parameter_property IN_WIDTH AFFECTS_GENERATION true



    add_parameter CLK_EN_PORT BOOLEAN 0
    set_parameter_property CLK_EN_PORT DISPLAY_NAME [get_string CLK_EN_DISPLAY_NAME]
    set_parameter_property CLK_EN_PORT VISIBLE false
    set_parameter_property CLK_EN_PORT DESCRIPTION [get_string CLK_EN_PORT_DESCRIPTION] 
    set_parameter_property CLK_EN_PORT GROUP [get_string INTERFACE_SECTION_NAME]
}


proc  add_module_output_options {} {

    add_parameter ROUND_TYPE string "NONE"
    set_parameter_property ROUND_TYPE DISPLAY_NAME "Output Rounding Method"
    set_parameter_property ROUND_TYPE ENABLED TRUE
    set_parameter_property ROUND_TYPE UNITS None
    set_parameter_property ROUND_TYPE DESCRIPTION [get_string ROUND_TYPE_DESCRIPTION] 
    set_parameter_property ROUND_TYPE ALLOWED_RANGES [list "NONE:[get_string ROUND_NONE_NAME]" "TRUNCATE:[get_string ROUND_TRUNC_NAME]" "CONV_ROUND:[get_string ROUND_CONVERGENT_NAME]" "ROUND_UP:[get_string ROUND_UP_NAME]" "SATURATE:[get_string ROUND_SATURATION_NAME]" "H_PRUNE:[get_string ROUND_HOGENAUER_NAME]"]
    set_parameter_property ROUND_TYPE GROUP [get_string INTERFACE_SECTION_NAME]
    set_parameter_property ROUND_TYPE AFFECTS_GENERATION true

    add_parameter  REQ_OUT_WIDTH INTEGER 8
    set_parameter_property REQ_OUT_WIDTH DISPLAY_NAME "Output data width"
    set_parameter_property REQ_OUT_WIDTH VISIBLE false
    set_parameter_property REQ_OUT_WIDTH UNITS Bits
    set_parameter_property REQ_OUT_WIDTH DESCRIPTION [get_string REQ_OUT_WIDTH_DESCRIPTION] 
    set_parameter_property REQ_OUT_WIDTH GROUP [get_string INTERFACE_SECTION_NAME]

    add_parameter  OUT_WIDTH INTEGER 8
    set_parameter_property OUT_WIDTH DISPLAY_NAME "Output data width"
    set_parameter_property OUT_WIDTH ENABLED false
    set_parameter_property OUT_WIDTH VISIBLE TRUE
    set_parameter_property OUT_WIDTH UNITS Bits
    set_parameter_property OUT_WIDTH DERIVED true
    set_parameter_property OUT_WIDTH GROUP [get_string INTERFACE_SECTION_NAME]
    set_parameter_property OUT_WIDTH AFFECTS_GENERATION true

}

proc add_parameter_hdl_derived {name} {
        add_parameter $name INTEGER 60
        set_parameter_property $name VISIBLE false 
        set_parameter_property $name DERIVED true 
}

proc add_module_widths {} {
    set n 11
    for {set i 0} {$i <= $n} {incr i} {
        set comb "C_STAGE_${i}_WIDTH"
        add_parameter_hdl_derived $comb
        set int "I_STAGE_${i}_WIDTH"
        add_parameter_hdl_derived $int
    }
    add_parameter_hdl_derived MAX_I_STAGE_WIDTH
    add_parameter_hdl_derived MAX_C_STAGE_WIDTH
}




#Add all parameters

add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}

add_module_parameters_filter_type
add_module_parameters_number_of_stages
add_module_parameters_differential_delay
add_module_parameters_variable_rate
add_module_parameters_multi_channel
add_module_input_options
add_module_output_options
add_module_data_storage
add_module_optimizations
add_module_widths
add_hyper_pipeline







proc render_terp {output_name terp_file} {
    # get template

    set template_path $terp_file  ;# path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it
    set filter_type                          [ get_parameter_value FILTER_TYPE ]
    set stages                               [ get_parameter_value STAGES ]
    set differential_delay                   [ get_parameter_value D_DELAY ]
    set variable_rate_change_enabled         [ get_parameter_value VRC_EN ]
    set rate_change_ub                       [ get_parameter_value RCF_UB ]
    set rate_change_lb                       [ get_parameter_value RCF_LB ]
    set rate_change_factor                   [ get_parameter_value RCF_FIX ]

    set number_of_interfaces                 [ get_parameter_value INTERFACES ]
    set channels_per_interface               [ get_parameter_value CH_PER_INT ]
    set integrator_data_store_mem_type       [ get_parameter_value REQ_INT_MEM ]
    set differentiator_data_store_mem_type   [ get_parameter_value REQ_DIF_MEM ]

    set pipelining_stages                    [ get_parameter_value REQ_PIPELINE ]
    set input_width                          [ get_parameter_value IN_WIDTH ]
    set rounding_method                      [ get_parameter_value ROUND_TYPE ]
    set requested_output_width               [ get_parameter_value REQ_OUT_WIDTH ]
    set output_width                         [ get_parameter_value OUT_WIDTH ]
    set pipelining_depth                     [ get_parameter_value REQ_PIPELINE]
    # setup template parameters

    set params(output_name) $output_name ;# template params are element of a Tcl array

    # add port details to template parameters
    # note that element must be appended to lists evenly and in-order or else iteration will not work
    # calculate output_width    



    set parameter_names {FILTER_TYPE STAGES D_DELAY VRC_EN \
                        RCF_MAX RCF_MIN INTERFACES CH_PER_INT \
                        INT_USE_MEM INT_MEM DIF_USE_MEM DIF_MEM \
                        IN_WIDTH OUT_WIDTH ROUND_TYPE PIPELINING \
                        C_STAGE_0_WIDTH C_STAGE_1_WIDTH C_STAGE_2_WIDTH C_STAGE_3_WIDTH C_STAGE_4_WIDTH \
                        C_STAGE_5_WIDTH C_STAGE_6_WIDTH C_STAGE_7_WIDTH C_STAGE_8_WIDTH C_STAGE_9_WIDTH \
                        C_STAGE_10_WIDTH C_STAGE_11_WIDTH  MAX_C_STAGE_WIDTH \
                        I_STAGE_0_WIDTH I_STAGE_1_WIDTH I_STAGE_2_WIDTH I_STAGE_3_WIDTH I_STAGE_4_WIDTH \
                        I_STAGE_5_WIDTH I_STAGE_6_WIDTH I_STAGE_7_WIDTH I_STAGE_8_WIDTH I_STAGE_9_WIDTH \
                        I_STAGE_10_WIDTH I_STAGE_11_WIDTH  MAX_I_STAGE_WIDTH \
                        }
    set  params("DEVICE_FAMILY") [get_parameter_value selected_device_family]
    foreach param [lsort [get_parameters]] {
        set params($param) [get_parameter_value $param]
    }
    if { $filter_type=="interpolator"} {
        if {$number_of_interfaces == 1} {
            set params(IN_PORTS) 1
            set params(OUT_PORTS) 1
        }   else {
            set params(IN_PORTS) 1
            set params(OUT_PORTS) $number_of_interfaces
        }
    } else {
        if {$number_of_interfaces == 1} {
            set params(IN_PORTS) 1
            set params(OUT_PORTS) 1
        }   else {
            set params(IN_PORTS) $number_of_interfaces
            set params(OUT_PORTS) 1
        }
    }

   # process template with parameters
    set contents [altera_terp $template params] ;# pass parameter array in by reference

    return $contents    
}


proc get_c_model_files {} {
   set c_model_files {
        c_model/CIC.cpp
	c_model/CIC.h
	c_model/Example/cic_c_model_output_ref.txt
	c_model/Example/cic_input.txt
	c_model/Example/cic_output_ref.txt
	c_model/Example/commands.txt
	c_model/compile_mex.sh
	c_model/main.cpp
	c_model/mexCICDirect.cpp
	c_model/mexCICFile.cpp
	c_model/mexCICFileIn.cpp
   }
   return $c_model_files
}


proc source_files {} { 
    set support_file_list {
        ../lib/packages/auk_dspip_math_pkg.vhd
        ../lib/packages/auk_dspip_text_pkg.vhd
        ../lib/packages/auk_dspip_lib_pkg.vhd
        src/rtl/avalon_streaming/auk_dspip_avalon_streaming_small_fifo.vhd
        src/rtl/avalon_streaming/auk_dspip_avalon_streaming_controller.vhd
        src/rtl/avalon_streaming/auk_dspip_avalon_streaming_sink.vhd
        src/rtl/avalon_streaming/auk_dspip_avalon_streaming_source.vhd
        ../lib/fu/delay/rtl/auk_dspip_delay.vhd
        ../lib/fu/fastaddsub/rtl/auk_dspip_fastaddsub.vhd
        ../lib/fu/fastaddsub/rtl/auk_dspip_fastadd.vhd
        ../lib/fu/fastaddsub/rtl/auk_dspip_pipelined_adder.vhd
        ../lib/fu/roundsat/rtl/auk_dspip_roundsat.vhd
        src/rtl/alt_dsp_cic_common_pkg.sv
        src/rtl/auk_dspip_cic_lib_pkg.vhd
        src/rtl/auk_dspip_differentiator.vhd
        src/rtl/auk_dspip_downsample.sv
        src/rtl/auk_dspip_integrator.vhd
        src/rtl/auk_dspip_upsample.vhd
        src/rtl/auk_dspip_channel_buffer.vhd
        src/rtl/auk_dspip_variable_downsample.sv
        src/rtl/hyper_pipeline_interface.v
        src/rtl/counter_module.sv
        src/rtl/alt_cic_int_siso.sv
        src/rtl/alt_cic_dec_siso.sv
        src/rtl/alt_cic_int_simo.sv
        src/rtl/alt_cic_dec_miso.sv
        src/rtl/alt_cic_core.sv
        src/rtl/alt_cic_core.ocp
    }
    return $support_file_list
}



proc add_filesets {} {
    foreach fileset {quartus_synth sim_verilog sim_vhdl} {
        add_fileset $fileset [string toupper $fileset] "generate_$fileset" 
    }
    add_fileset example_design EXAMPLE_DESIGN example_fileset "CIC II Example Design"
}



proc generate_quartus_synth {output_name} { 
    generate_all $output_name QUARTUS_SYNTH
}
proc generate_sim_vhdl {output_name} {
    generate_all $output_name SIM_VHDL
}
proc generate_sim_verilog {output_name} {
    generate_all $output_name SIM_VERILOG
}
proc generate_all {output_name fileset} {  
    set source_file_list [source_files ]
    foreach current_file [source_files ] {
        dsp_add_fileset_file $current_file $fileset [get_simulator_list]
    }
    set filename ${output_name}.sv ;# dependent on what Qsys gives us as the output name
    set terp_file "src/rtl/top.sv.terp"
    set top_level_contents [render_terp $output_name $terp_file]
    add_fileset_file $filename SYSTEM_VERILOG TEXT $top_level_contents

    # generate the c model files for simulation fileset
    if {$fileset != "QUARTUS_SYNTH"} {
       foreach c_file [get_c_model_files] {
          add_fileset_file $c_file OTHER PATH $c_file
       }
    }
}


proc get_simulator_list {} {
    return { \
             {mentor   1   } \
             {aldec    1    } \
             {synopsys 1 } \
             {cadence  1  } \
           }
}

# | 
# +-----------------------------------

 
add_filesets






proc elab {} {

    set filter_type                          [ get_parameter_value FILTER_TYPE ]
    set stages                               [ get_parameter_value STAGES ]
    set differential_delay                   [ get_parameter_value D_DELAY ]
    set variable_rate_change_enabled         [ get_parameter_value VRC_EN ]
    set rate_change_lb                       [ get_parameter_value RCF_LB ]
    set rate_change_ub                       [ get_parameter_value RCF_UB ]
    set rate_change_factor                   [ get_parameter_value RCF_FIX ]

    set number_of_interfaces                 [ get_parameter_value INTERFACES ]
    set channels_per_interface               [ get_parameter_value CH_PER_INT ]
    set integrator_data_store_mem_type       [ get_parameter_value INT_MEM ]
    set differentiator_data_store_mem_type   [ get_parameter_value DIF_MEM ]

    set pipelining_stages                    [ get_parameter_value REQ_PIPELINE ]
    set input_width                          [ get_parameter_value IN_WIDTH ]
    set requested_output_width               [ get_parameter_value REQ_OUT_WIDTH ]
    set output_width                         [ get_parameter_value OUT_WIDTH ]
    set filter_type                          [ get_parameter_value FILTER_TYPE ]
    set rounding_method                      [ get_parameter_value ROUND_TYPE ]
    
    set hyper_opt_select                     [ get_parameter_value hyper_opt_select ]
    set family                               [ get_parameter_value selected_device_family ]

    if {$family == "Stratix 10" || $family == "Arria 10"} {
       set_parameter_property hyper_opt_select VISIBLE true
       set_parameter_value hyper_opt ${hyper_opt_select}
    } else {
       set_parameter_property hyper_opt_select VISIBLE false
       set_parameter_value hyper_opt 0
    }


    #clock
    add_interface           clock clock                 input
    add_interface_port      clock clk                   clk Input 1
    add_interface           reset reset                 input
    add_interface_port      reset reset_n               reset_n Input 1
    set_interface_property  reset associatedClock       clock ;# the clock is associated in either case

    #input stream
#This is now taken care of by the dsp common avalon package

    if {$filter_type=="interpolator"} {
        if {$number_of_interfaces == 1} {
            set data_width_in [expr $input_width]
            set data_width_out [expr $output_width]
        }   else {
            set data_width_in [expr $input_width]
            set data_width_out [expr $output_width * $number_of_interfaces]

        }
    } else {
        if {$number_of_interfaces == 1} {
            set data_width_in [expr $input_width]
            set data_width_out [expr $output_width]
        }   else {
            set data_width_in [expr $input_width * $number_of_interfaces]
            set data_width_out [expr $output_width]
        }
    }



    add_interface clken         conduit    end
    set_interface_property       clken     EXPORT_OF           clken
    add_interface_port           clken     clken              clken input 1
    if { [get_parameter_value design_env] eq {QSYS} || [get_parameter_value CLK_EN_PORT] == false} {
        set_port_property            clken     TERMINATION         true
        set_port_property            clken     TERMINATION_VALUE   1  
    }

    if { $number_of_interfaces > 1 & $filter_type == "decimator" } {
        set in_data_ports $number_of_interfaces
    } else {
        set in_data_ports 1 
    }   

    if { $in_data_ports > 1 } {
        for { set x 0 } { $x < $in_data_ports } { incr x } {
            lappend input_data_port in${x}_data
            lappend input_data_port $input_width
        } 
    } else {
        lappend input_data_port in_data
        lappend input_data_port $input_width
    }
    if { $input_width > 0 } {
        set input_name av_st_in
        dsp_add_streaming_interface     $input_name     sink    

        dsp_set_interface_property $input_name associatedClock clock
        dsp_set_interface_property $input_name associatedReset reset


        add_interface_port       $input_name     in_error               error    input      2
        add_interface_port       $input_name     in_valid               valid    input      1            
        add_interface_port       $input_name     in_ready               ready    output     1
        dsp_add_interface_port       $input_name     ${input_name}_data     data    input    $data_width_in $input_data_port
        dsp_set_interface_property   $input_name     dataBitsPerSymbol    $input_width
        dsp_set_interface_property   $input_name     symbolsPerBeat       $number_of_interfaces
    }

        if { $channels_per_interface > 1 || ($number_of_interfaces > 1 & $filter_type == "interpolator") } {
            add_interface_port $input_name in_startofpacket startofpacket input 1
            add_interface_port $input_name in_endofpacket endofpacket input 1
        }

    set error_desc ""
    if { [string compare $error_desc ""] } {
        set error_width [ llength [split $error_desc ,] ]
        add_interface_port $input_name ${input_name}_error    error    input   $error_width
        set_interface_property $input_name errorDescriptor $error_desc
    }

    #output stream

    if { $number_of_interfaces > 1 & $filter_type == "interpolator" } {
        set out_data_ports $number_of_interfaces
    } else {
        set out_data_ports 1 
    }


    set output_width_1 [expr $output_width - 1]
    if { $out_data_ports > 1 } {
        for { set x 0 } { $x < $out_data_ports } { incr x } {
            lappend output_data_port out${x}_data
            lappend output_data_port $output_width
        } 
    } else {
        lappend output_data_port out_data
        lappend output_data_port $output_width
    }
    if { $output_width > 0 } {
        set output_name av_st_out
        dsp_add_streaming_interface            $output_name   source     
        dsp_set_interface_property $output_name associatedClock clock
        dsp_set_interface_property $output_name associatedReset reset 
        dsp_add_interface_port       $output_name     ${output_name}_data   data    output    $data_width_out $output_data_port
        dsp_set_interface_property   $output_name     dataBitsPerSymbol    $output_width
        dsp_set_interface_property   $output_name     symbolsPerBeat       $number_of_interfaces
        add_interface_port       $output_name     out_error   error    output    2

        add_interface_port $output_name out_valid valid output 1
        add_interface_port $output_name out_ready    ready    input  1
    if { $channels_per_interface > 1 || ($number_of_interfaces > 1 & $filter_type == "decimator") } {
        add_interface_port $output_name out_startofpacket startofpacket output 1
        add_interface_port $output_name out_endofpacket endofpacket output 1
    }


    if { $channels_per_interface > 0 && $number_of_interfaces > 0 } {
        if { $filter_type == "interpolator" } {
        set channel_width [expr int(ceil(log($channels_per_interface)/log(2)))]
            if { $channels_per_interface > 1 } {
                add_interface_port $output_name out_channel  channel  output   $channel_width
            }
        } else {
        set channel_width [expr int(ceil(log(${channels_per_interface}*${number_of_interfaces})/log(2)))]
            if { $channels_per_interface > 1 || $number_of_interfaces > 1} {
                add_interface_port $output_name out_channel  channel  output   $channel_width
            }
        }
    }

    }








    set error_desc ""
    if { [string compare $error_desc ""] } {
        set error_width [ llength [split $error_desc ,] ]
        add_interface_port $output_width out_error    error    input   $error_width
        set_interface_property $output_width errorDescriptor $error_desc
    }


    #rate
    if {$variable_rate_change_enabled == 1} {
        set_parameter_value RCF_MIN $rate_change_lb
        set_parameter_value RCF_MAX $rate_change_ub
    } else {
        set_parameter_value RCF_MIN $rate_change_factor
        set_parameter_value RCF_MAX $rate_change_factor
    }
    if {$variable_rate_change_enabled == 1 && $rate_change_ub > 0 } {
        set rate_width [expr int(ceil(log(${rate_change_ub}+1)/log(2)))]
        add_interface rate conduit end
        set_interface_property rate EXPORT_OF rate
        add_interface_port rate rate conduit input $rate_width
    }

    if { $variable_rate_change_enabled == 1  } {
        set max_rate  $rate_change_ub
    } else {
        set max_rate $rate_change_factor
    }
    set max_output_width [calc_max_width $input_width $filter_type $max_rate $differential_delay $stages ]


    if { $filter_type == "decimator" && ($rounding_method == "H_PRUNE") } {
        do_hogenauer $filter_type $stages $max_rate $differential_delay $input_width $output_width $max_output_width 
    } else {
       foreach type {I C} {
            set n 11
            for {set i 0} {$i <= $n} {incr i} {
                set name "${type}_STAGE_${i}_WIDTH"
                set_parameter_value $name $max_output_width
            }
            set name "MAX_${type}_STAGE_WIDTH"
            set_parameter_value $name $max_output_width
        }
    }

}

# +-----------------------------------
# | Callbacks
# | 
proc validation_cic_top {} {
    set filter_type                          [ get_parameter_value FILTER_TYPE ]
    set stages                               [ get_parameter_value STAGES ]
    set differential_delay                   [ get_parameter_value D_DELAY ]
    set variable_rate_change_enabled         [ get_parameter_value VRC_EN ]
    set rate_change_ub                       [ get_parameter_value RCF_UB ]
    set rate_change_lb                       [ get_parameter_value RCF_LB ]
    set rate_change_factor                   [ get_parameter_value RCF_FIX ]

    set number_of_interfaces                 [ get_parameter_value INTERFACES ]
    set channels_per_interface               [ get_parameter_value CH_PER_INT ]
    set integrator_data_store_mem_type       [ get_parameter_value REQ_INT_MEM ]
    set differentiator_data_store_mem_type   [ get_parameter_value REQ_DIF_MEM ]

    set pipelining_stages                    [ get_parameter_value REQ_PIPELINE ]
    set input_width                          [ get_parameter_value IN_WIDTH ]
    set rounding_method               [ get_parameter_value ROUND_TYPE ]
    set requested_output_width                  [ get_parameter_value REQ_OUT_WIDTH ]
    set output_width                         [ get_parameter_value OUT_WIDTH ]
    set filter_type                          [ get_parameter_value FILTER_TYPE ]
    set pipelining_depth                    [ get_parameter_value REQ_PIPELINE]
    set round_type                          [get_parameter_value ROUND_TYPE]
    set total_channels [expr $channels_per_interface * $number_of_interfaces]
    # calculate output_width    

     if { $variable_rate_change_enabled == 1  } {
        set max_rate  $rate_change_ub
    } else {
        set max_rate $rate_change_factor
    }
    set max_output_width [calc_max_width $input_width $filter_type $max_rate $differential_delay $stages ]

    if { $requested_output_width < 1 } {
        send_message_from_strings ERROR OUTPUT_WIDTH_ERROR
    }


    if { [get_parameter_value design_env] eq {QSYS}} {
        set_parameter_property CLK_EN_PORT VISIBLE false
    } else {
        set_parameter_property CLK_EN_PORT VISIBLE true
    }
    if { [get_parameter_value CLK_EN_PORT] } {
        send_message_from_strings WARNING CLK_EN_WARNING
    }

    if { $filter_type == "interpolator" && $round_type eq "H_PRUNE" } {
        send_message_from_strings ERROR H_PRUNE_INT_WARNING
    }
    # Switch between fixed and variable rate change factor
    if { $variable_rate_change_enabled == 1 } {
        set_parameter_property RCF_LB VISIBLE true
        set_parameter_property RCF_LB ENABLED true
        set_parameter_property RCF_UB VISIBLE true
        set_parameter_property RCF_UB ENABLED true
        set_parameter_property RCF_FIX VISIBLE false
        set_parameter_property RCF_FIX ENABLED false

        if { $rate_change_ub < 2 } {
            send_message_from_strings error MAX_RATE_CHANGE_LESS_THAN_2_ERROR
        }  elseif { $rate_change_lb < 2 } {
            send_message_from_strings error MIN_RATE_CHANGE_LESS_THAN_2_ERROR
        } elseif { $rate_change_lb >= $rate_change_ub } {
            send_message_from_strings error MIN_GREATER_THAN_MAX_RATE_ERROR
        } elseif { $number_of_interfaces > $rate_change_lb } {
            send_message_from_strings error MIN_RATE_GRATER_THAN_INTERFACES_ERROR
        }

        } else {
        set_parameter_property RCF_LB VISIBLE false
        set_parameter_property RCF_LB ENABLED false
        set_parameter_property RCF_UB VISIBLE false
        set_parameter_property RCF_UB ENABLED false
        set_parameter_property RCF_FIX VISIBLE true
        set_parameter_property RCF_FIX ENABLED true
        if { $rate_change_factor < 2 } {
            send_message_from_strings error RATE_CHANGE_LESS_THAN_2_ERROR
        } elseif {  $number_of_interfaces  > $rate_change_factor } {
            send_message_from_strings error RATE_GRATER_THAN_INTERFACES_ERROR
        }
    }


    # Resource Utilisation 
    if {$number_of_interfaces > 1 } {
        if {$channels_per_interface > [expr 1024/$number_of_interfaces] } {
            send_message_from_strings error TOTAL_CHANNELS_ERROR
         }  
    }

    set max_pipeline_depth [expr $channels_per_interface]    
    if { $channels_per_interface > 4 } {
        if {$pipelining_depth > 4} {
            send_message_from_strings ERROR MAX_PIPELINE_DEPTH
        }        
    } else {
        if {$pipelining_depth > $max_pipeline_depth} {
            send_message_from_strings ERROR PIPELINE_GREATER_THAN_CHANNELS_ERROR
        }
    }




    if { $rounding_method == "NONE"} {
        set_parameter_property REQ_OUT_WIDTH VISIBLE false
        set_parameter_property OUT_WIDTH VISIBLE true
        set_parameter_value OUT_WIDTH $max_output_width
    } else {
        set_parameter_property REQ_OUT_WIDTH VISIBLE TRUE
        set_parameter_property OUT_WIDTH VISIBLE false
        set_parameter_value OUT_WIDTH $requested_output_width    
        set output_width $requested_output_width
        if { $output_width >= $max_output_width} {
            send_message_from_strings error  MAX_OUTPUT_ERROR
        }
    }   




    if { $channels_per_interface > 1} {
        set_parameter_value PIPELINING $pipelining_depth
        set_parameter_property PIPELINING VISIBLE false
        set_parameter_property REQ_PIPELINE VISIBLE true
        set_parameter_property PIPELINING VISIBLE false
    } else {
        set_parameter_value PIPELINING 0
        set_parameter_property PIPELINING VISIBLE true
        set_parameter_property REQ_PIPELINE VISIBLE false
        set_parameter_property PIPELINING VISIBLE true
    }



     set mem_display [memory_display_options]
    if { $channels_per_interface*$number_of_interfaces*$differential_delay >= 5 } {
        set_parameter_property REQ_DIF_MEM VISIBLE true
        set_parameter_property DIF_MEM VISIBLE false
        set_parameter_value DIF_MEM $differentiator_data_store_mem_type
        # Enable Diff Memory options
         if { [lsearch [memory_options ] $differentiator_data_store_mem_type] == -1 } {
            send_message_from_strings ERROR DIF_WRONG_MEM_TYPE_ERROR
         }
        if { $differentiator_data_store_mem_type == "logic_element" } {
            set_parameter_value DIF_USE_MEM      false
            set_parameter_value DIF_MEM "auto"
        } 
    } else {
        set_parameter_value DIF_USE_MEM      false
        set_parameter_value DIF_MEM "auto"
        set_parameter_property REQ_DIF_MEM VISIBLE false
        set_parameter_property DIF_MEM VISIBLE true
    }

    if { $channels_per_interface >= 5 } {
        # enable Int memory options
        set_parameter_property REQ_INT_MEM VISIBLE true
        set_parameter_property INT_MEM VISIBLE false
        set_parameter_value INT_MEM $integrator_data_store_mem_type
         if { [lsearch [memory_options ] $integrator_data_store_mem_type] == -1 } {
            send_message_from_strings ERROR INT_WRONG_MEM_TYPE_ERROR
         }
        if { $integrator_data_store_mem_type == "logic_element" } {
            set_parameter_value INT_USE_MEM      false
            set_parameter_value INT_MEM     "auto"
        }
    } else {
        set_parameter_property REQ_INT_MEM VISIBLE false
        set_parameter_property INT_MEM VISIBLE true
        set_parameter_value INT_USE_MEM      false
        set_parameter_value INT_MEM     "auto"
    }




}   

proc calc_max_width {input_width filter_type max_rate differential_delay stages} {
    if { $max_rate > 0 && $max_rate != 0 } {
        if { $filter_type == "interpolator" } {
            return  [expr  int(ceil($input_width+log(pow($max_rate*$differential_delay, $stages)/$max_rate)/log(2)))]
        } else {
            return  [expr int($input_width + ceil($stages*log($max_rate*$differential_delay)/log(2)))]
        }
    }
}
proc do_hogenauer {filter_type stages max_rate_change differential_delay input_width out_width max_width} {
    set params(num_stages) $stages
    set params(rate_change) $max_rate_change
    set params(diff_delay) $differential_delay
    set params(in_width)   $input_width
    set params(out_width)  $out_width
    set params(max_width) [calc_max_width $input_width $filter_type $max_rate_change $differential_delay $stages ]
    set params(cwd) [pwd]
    array set output [call_helper generateHogenauerPruningData [array get params]]
    if {! [info exists output(status)]} {
        send_message error [get_string JAVA_ERROR]
    }
    if {$output(status) != "success"} {
        send_message error $output(message)
    } else {
        set I_width [split $output(integrate_stage_data_width) , ]
        set C_width [split $output(comb_stage_data_width) , ]
        set n 11
            for {set i 0} {$i <= $n} {incr i} {
                set value [lindex $I_width $i]
                set_parameter_value I_STAGE_${i}_WIDTH $value
            }
        set name "MAX_I_STAGE_WIDTH"
        set_parameter_value $name $max_width

        set n 11
            for {set i 0} {$i <= $n} {incr i} {
                set value [lindex $C_width $i]
                set_parameter_value C_STAGE_${i}_WIDTH $value
            }
        set name "MAX_C_STAGE_WIDTH"
        set_parameter_value $name $max_width
    }
}


proc filetype { file_name } {
   switch -glob $file_name {
      *.vhd {     return VHDL}
      *.v {       return VERILOG}
      *.sv {      return SYSTEM_VERILOG}
      *.svo {     return SYSTEM_VERILOG}
      *.vho {     return VHDL}
      *.vo {      return VERILOG}
      default {   return OTHER }
   }
}

proc folder_worker { item } {
   foreach top_item [glob -directory [file join [pwd] $item] -tails *] {
      set relative_item [file join $item $top_item]
      set absolute_path [file join [pwd] $relative_item]
      if {[file isdirectory $relative_item] == 1 } {
         folder_worker $relative_item 
      } else {
         add_fileset_file [file join "simulation_scripts" $relative_item] OTHER PATH $absolute_path
      }
   }
}
proc add_files_recursive { root } {
   set old_path [pwd] 
   cd $root
   foreach top_item [glob -directory [pwd]  -tails *] {
      set absolute_path [file join [pwd] $top_item]
      if {[file isdirectory $top_item] == 1 } {
         folder_worker $top_item
      } else {
         add_fileset_file [file join "simulation_scripts" $top_item] OTHER PATH $absolute_path
      }
   }
   cd $old_path
}
proc  generate_test_data { test_data_dir output_name filter input_width interfaces channels max_rate min_rate } {
   set cwd [pwd]
   file mkdir $test_data_dir
   cd $test_data_dir
   if { $max_rate == $min_rate } {
     set fixed_rate true
   } else {
     set fixed_rate false
   }

   # NOTE: only one input interface is allowed for interpolator
   if {$filter == "interpolator"} {
     set interfaces 1
   }

   set n 5
   for {set i 0} {$i < $n} {incr i} {
       lappend rates [expr round($min_rate + ($i*($max_rate-$min_rate))/$n)]
   }
   set rate_test_length "100 150 200 150 100"

   if { $fixed_rate eq "true" } {
      set rate_name "${output_name}_rate_input.txt"
      set f_rate_handle [open $rate_name w+]
   }
    set data_name "${output_name}_tb_input.txt"
    set f_handle [open $data_name w+]
    set pi 3.1415926535897931

   for {set i 0} {$i < $n} {incr i} {
       for {set j 0} {$j < [lindex $rate_test_length $i]} {incr j} {
           for {set k 0} {$k < $channels} {incr k} {
               for {set l 0} {$l < $interfaces} {incr l} {
                    set channel [expr $k+$l]
                    set k_f [expr ($channels+$interfaces)]
                    set samples [lindex $rate_test_length $i]
                    set scale [expr (2**($input_width-1)-1)]
                    set phase [expr ((2*$pi*$channel)/($channels*$interfaces))]
                    set freq  [expr (( 2 * $pi * $j * $k_f)/($samples))]
                    set value [expr round( $scale * sin( $phase + $freq ))]
                    puts -nonewline $f_handle  "${value},"
               }
            if { $fixed_rate eq "true" } {
                puts $f_handle "[lindex $rates $i]"
            }
           }
       }
   }

   if { $fixed_rate eq "true" } {
    close $f_rate_handle
    add_fileset_file [file join "test_data" $rate_name] OTHER PATH "[file join $test_data_dir $rate_name]"
   }
    close $f_handle
    add_fileset_file [file join "test_data" $data_name] OTHER PATH "[file join $test_data_dir $data_name]"

    cd $cwd
}

proc get_all_file_abs {root_dir} {
    set cur_dir [pwd]
    cd $root_dir
    set all_files {}
    foreach item [glob -nocomplain -type d * ] {
        lappend all_files {*}[get_all_file_abs $item ]
    } 
    foreach item [glob -nocomplain  -type f * ] {
        lappend all_files $item
    } 
    cd $cur_dir
    return $all_files
}


proc example_fileset {output_name} {
    if { [get_parameter_value design_env] ne {QSYS} && [get_parameter_value CLK_EN_PORT] == true} {
        send_message ERROR "Example Design does not support the clock enable signal"
    }
   set cwd [pwd]
   send_message INFO "Creating MATLAB Models"


   #Generate matlab compenesation filter generator
   set matlab_files matlab
   set template_path "src/matlab/cic_ii_fir_comp_coeff.m.terp"
   set matlab_file "${output_name}_comp_coeff.m" 
   set terp_contents [render_terp $output_name $template_path ]
   add_fileset_file "[file join $matlab_files $matlab_file]" OTHER TEXT $terp_contents

   #Generate Test Program
   set source_files_path src
   set template_path "src/testbench/cic_ii_testbench.sv.terp"
   set terp_contents [render_terp $output_name $template_path ]
   set test_program_file "${output_name}_test_program.sv" 
   add_fileset_file "[file join $source_files_path $test_program_file]" OTHER TEXT $terp_contents
   send_message INFO "Generating Test Data"

   # #Generate Test Data
   # set direction        [get_parameter_value direction]
   # set arch             [get_parameter_value io_data_flow]
   # set input_format     [get_parameter_value data_rep]
   # set fft_size         [get_parameter_value length] 
   # set input_width      [get_parameter_value data_input_width_derived] 
    set test_data_dir [create_temp_file ""]


    set filter          [get_parameter_value FILTER_TYPE]
    set input_width     [get_parameter_value IN_WIDTH]    
    set interfaces      [get_parameter_value INTERFACES]    
    set channels        [get_parameter_value CH_PER_INT]
    set max_rate        [get_parameter_value RCF_MAX]
    set min_rate        [get_parameter_value RCF_MIN]
    generate_test_data $test_data_dir $output_name $filter $input_width $interfaces $channels $max_rate $min_rate


   send_message INFO "Generating Testbench System"

   #Generate Testbenching System
   set family "[get_parameter_value selected_device_family]"
   set cic_example_design "core" 
   set qsys_system "${output_name}.qsys"



   #Generate the testbench files
   set systemTime [clock seconds]
   set temp_dir  [create_temp_file ""]
   file mkdir $temp_dir
   cd $temp_dir

   set script_name "$temp_dir/${output_name}.tcl"
   set sim_script_name "$temp_dir/${output_name}.spd"
   set sim_script [open $sim_script_name w+]

   set f_handle [open $script_name w+]

   puts $f_handle    "package require -exact qsys 14.0"
   puts $f_handle    "set_project_property DEVICE_FAMILY \"${family}\""
   puts $f_handle    "add_instance ${cic_example_design} altera_cic_ii"
   foreach param [lsort [get_parameters]] {
      if {[get_parameter_property $param DERIVED] == 0} {
         #Screen for design environment, only QSYS flow is supported, because Native steps all over the BFMs by creating conduits
         if { $param ne "design_env" } { 
            puts $f_handle "set_instance_parameter_value $cic_example_design $param \"[get_parameter_value $param]\""
         } else {
            puts $f_handle "set_instance_parameter_value $cic_example_design $param \"QSYS\""

         }
      }
   }
   puts $f_handle    "add_interface ${cic_example_design}_reset reset sink"
   puts $f_handle    "set_interface_property ${cic_example_design}_reset EXPORT_OF ${cic_example_design}.reset"
   puts $f_handle    "add_interface ${cic_example_design}_clock clock sink"
   puts $f_handle    "set_interface_property ${cic_example_design}_clock EXPORT_OF ${cic_example_design}.clock"
   puts $f_handle    "add_interface ${cic_example_design}_av_st_in avalon_sink sink"
   puts $f_handle    "set_interface_property ${cic_example_design}_av_st_in EXPORT_OF ${cic_example_design}.av_st_in"
   puts $f_handle    "add_interface ${cic_example_design}_av_st_out avalon_source source"
   puts $f_handle    "set_interface_property ${cic_example_design}_av_st_out EXPORT_OF ${cic_example_design}.av_st_out"
   if { [get_parameter_value VRC_EN] == 1 } {
        puts $f_handle "add_interface ${cic_example_design}_rate conduit end";
        puts $f_handle "set_interface_property ${cic_example_design}_rate EXPORT_OF ${cic_example_design}.rate";
   }
   puts $f_handle    "save_system ${qsys_system}"

   close $f_handle
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-script"]


   set cmd [list  $program --script=$script_name ]
   set status [catch {exec {*}$cmd} err]
   if {$status != 1 } {
        send_message ERROR [get_string EXAMPLE_DESIGN_SYS_ERROR]
   } else {
        send_message NOTE "CIC II Example Core Generation Complete"
   }



   #now use this qsys SYSTEM to generate files and find out the correct compile order of these files
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "qsys-generate"] 
   set cmd "$program $qsys_system --testbench=STANDARD --testbench-simulation=VERILOG";
   set status [catch {exec {*}$cmd} err]
   if {$status != 1 } {
        send_message ERROR [get_string EXAMPLE_DESIGN_TB_ERROR]
   } else {
        send_message NOTE "CIC II Example Testbench Generation Complete"
   }        

   set simulator_list { \
             {mentor   modelsim} \
             {aldec    riviera} \
             {synopsys vcs} \
             {cadence  ncsim} \
           }
   
   set test_file_dir [file join "${temp_dir}"]
   send_message INFO "--- Looking in $test_file_dir ---"

   # add c_model files to the example design first
   set c_model_location [find_c_model_dir ${test_file_dir}]
   foreach c_file [get_c_model_files] {
      add_fileset_file $c_file OTHER PATH "${c_model_location}/../${c_file}"
   }

    # add all the RTL files etc.
    set all_files [get_all_file_abs $test_file_dir]
    foreach module [lsearch -inline -all -glob $all_files *] {
        if { [regexp  {.*(\.hex$)|(\.mif$)|(\.vo$)|(\.vho$)} [file tail $module] ] == 1 } {
            set ext [filetype submodule]
            add_fileset_file [file join "src" [file tail $module]] $ext PATH $module
        }
        if { [regexp  {.*(\.sv$)|(\.vhd$)|(\.v$)} [file tail $module] ] == 1 } {
            switch -glob $module {
               *.vhd    { set language VHDL}
               *.sv     { set language SYSTEM_VERILOG}
               *.v      { set language VERILOG}
            }

            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                # if it has encryption it will be located in the simulator sub-directory
                if {[string match *$sim*  $module ] == 1} {
                    add_fileset_file [file join "src/$sim" [file tail $module]] ${language}_ENCRYPT PATH $module [string toupper $sim]_SPECIFIC
                    set added 1
                    break
                }
            }
            if {!$added} {
                add_fileset_file [file join "src" [file tail $module]] $language PATH $module
            }
        }
    }

    set packages {}
    set top_files {}
    set generic_files {}
    set memory_files {}
    foreach cur_file $all_files {
        if { [regexp  {.*(tb\.)(v|(sv)|(vhd))} $cur_file ] == 1 } {
            lappend top_files $cur_file
        } elseif { [regexp  {.*((\.vo)|(\.vho)|(pack\.vhd)|(pkg\.v)|(pkg\.sv)|(pkg\.vhd))} $cur_file] == 1 } {
            lappend packages $cur_file
        } elseif { [regexp  {.*\.(v|(sv)|(vhd))} $cur_file] == 1 } {
            lappend generic_files $cur_file
        } elseif { [regexp  {.*\.((hex)|(mif))}  $cur_file] == 1 } {
            lappend memory_files $cur_file
        }
    }
    # use the source file list as the priority list, determines which file to add/compile first
    set rtl_files [concat $packages $generic_files]
    set rtl_files_temp [concat $packages $generic_files]
    set priority_files [source_files]
    set priority_file_list [list ]
    foreach priority_file $priority_files {
        foreach current_file $rtl_files_temp {
            if {[file tail $current_file] eq [file tail $priority_file]} {
                # add the file to the priority list
                lappend priority_file_list $current_file
                set pos [lsearch $rtl_files $current_file]
                # remove the file to the generic_files
                set rtl_files [lreplace $rtl_files $pos $pos]
            }
        }
    }
    set rtl_files [concat $priority_file_list $rtl_files]
    


   send_message INFO "Generating Simulation Scripts"

   #set the spd
   puts $sim_script "<simPackage>"
   set library "work"
   foreach file $rtl_files {
      if { [lsearch $all_files $file] != -1 } {
         # remove the current element from the list
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         if { [string match -nocase SYSTEM_VERILOG $file_type]==1 || [string match -nocase VHDL $file_type]==1 || [string match -nocase VERILOG $file_type]==1} { 
            set added 0
            foreach simulator $simulator_list {
                set sim [lindex $simulator 0]
                set tool [lindex $simulator 1]
                if {[string match *$sim*  $file ] == 1} {
                    set file_name [file join $source_files_path $sim [file tail $file]]
                    puts $sim_script [convert_to_spd_xml  $file_name ${file_type}_ENCRYPT $library $tool]
                    set added 1
                    break
                } 
            }
            if {!$added} {
                set file_name [file join $source_files_path [file tail $file]]
                puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
            }
         } else { 
             set file_name [file join $source_files_path [file tail $file]]
             puts $sim_script [convert_to_spd_xml  $file_name $file_type $library ""]
         }
      }
   }
   foreach file $memory_files {
      if { [lsearch $all_files $file] != -1 } {
         set all_files [lreplace $all_files [lsearch $all_files $file] [lsearch $all_files $file] ]
         set file_type [filetype $file]
         set file_name [file join $source_files_path [file tail $file]]
         puts $sim_script [convert_to_spd_xml  $file_name "Memory" $library]
      }
   }
   foreach file $top_files {
      set file_type [filetype $file]
      set file_name [file join $source_files_path [file tail $file]]
      puts $sim_script [convert_to_spd_xml  $file_name $file_type $library]
   }

   #Add the top level 
   set file_name [file join $source_files_path $test_program_file]
   set file_type "SYSTEM_VERILOG"
   puts $sim_script [convert_to_spd_xml  $file_name $file_type $library]


   #add input files
   set input_files [glob -directory $test_data_dir  -tails -nocomplain *{.txt}]
   foreach file $input_files {
      set file_type "Memory"
      set file_name [file tail $file]
      puts $sim_script [convert_to_spd_xml  [file join "test_data" $file_name] $file_type 0]
   }
   puts $sim_script "<topLevel name=\"test_program\"/>"
   puts $sim_script "<deviceFamily name=\"[get_parameter_value selected_device_family]\"/>"
   puts $sim_script "</simPackage>"
   close $sim_script

   file mkdir "sim_scripts"
   set program [file join $::env(QUARTUS_ROOTDIR) "sopc_builder" "bin" "ip-make-simscript"] 
   set cmd [list  $program --spd=$sim_script_name --use-relativepaths --output_directory=[file join [pwd] "sim_scripts"]]
   send_message INFO "$cmd"
   set status [catch {exec {*}$cmd} err]
   # send_message INFO "$err"
   set root     [file join [pwd] "sim_scripts" ] 
   add_files_recursive $root

   cd $cwd
}

proc memory_display_options {} {
   set device_family [get_parameter_value selected_device_family]
   if { [ check_device_family_equivalence $device_family {  "StratixIV"   "ArriaIIGZ" } ] == 1 } {
        return  "[get_string MEM_LE_NAME] [get_string MEM_AUTO_NAME] [get_string MEM_M512_NAME] [get_string MEM_M4K_NAME] [get_string MEM_MRAM_NAME]"
    } elseif { [ check_device_family_equivalence $device_family { "Max10FPGA" "CycloneIVGX"  "CycloneIVE" "Cyclone10LP" } ] == 1 } {
        return  "[get_string MEM_LE_NAME] [get_string MEM_AUTO_NAME] [get_string MEM_M9K_NAME]"
    } elseif { [ check_device_family_equivalence $device_family { "ArriaIIGX" } ] == 1 } {
        return  "[get_string MEM_LE_NAME] [get_string MEM_AUTO_NAME] [get_string MEM_M9K_NAME] [get_string MEM_MLAB_NAME]" 
    } elseif { [ check_device_family_equivalence $device_family {  "StratixV" "ArriaVGZ" } ] == 1 } {
        return  "[get_string MEM_LE_NAME] [get_string MEM_AUTO_NAME] [get_string MEM_M20K_NAME] [get_string MEM_MLAB_NAME]" 
    } elseif { [ check_device_family_equivalence $device_family {  "CycloneV" "ArriaV" } ] == 1 } {
        return  "[get_string MEM_LE_NAME] [get_string MEM_AUTO_NAME] [get_string MEM_M10K_NAME] [get_string MEM_MLAB_NAME]" 
    } elseif { [ check_device_family_equivalence $device_family {  "Arria10" } ] == 1 } {
        return  "[get_string MEM_LE_NAME] [get_string MEM_AUTO_NAME] [get_string MEM_M20K_NAME] [get_string MEM_MLAB_NAME]" 
    } else {
        return  "[get_string MEM_LE_NAME] [get_string MEM_AUTO_NAME]" 
    }

}

proc find_c_model_dir { cur_dir } {
   #send_message WARNING "searching $cur_dir"
   set found_dir "nothing"
   foreach sub_dir [glob -nocomplain -type d -directory $cur_dir *] {
      #send_message WARNING "found $sub_dir"
      if {[string match *c_model*  $sub_dir ] == 1} {
         set found_dir $sub_dir
         #send_message WARNING "!! found c_model"
         return $found_dir
      } else {
         set found_dir [find_c_model_dir $sub_dir]
      }
      if {[string match *c_model*  $found_dir ] == 1} {
         return $found_dir
      }
   }
   return $found_dir
}
