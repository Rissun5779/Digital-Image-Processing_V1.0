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
package require altera_hdl_wrapper 1.0
package require altera_terp

source "../src/tcl_libs/altera_vit_ii_parameters.tcl"
source "../src/tcl_libs/altera_vit_ii_example_design.tcl"
source "../src/tcl_libs/avalon_streaming_util.tcl"
source "../../lib/tcl/dspip_common.tcl"

# |
# +-----------------------------------

# +-----------------------------------
# | module altera_viterbi
# |
set_module_property NAME altera_viterbi_ii
set_module_property AUTHOR "Intel Corporation"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property GROUP "DSP/Error Detection and Correction"
set_module_property DISPLAY_NAME "Viterbi"
set_module_property DESCRIPTION "Altera Viterbi"
set_module_property DATASHEET_URL "https://documentation.altera.com/#/link/dmi1416822321903/dmi1416822603240"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
add_module_parametersTOP 
set_module_property VALIDATION_CALLBACK validateTOP
set_module_property ELABORATION_CALLBACK elaborate
set_module_property PARAMETER_UPGRADE_CALLBACK upgrade_callback

set_module_property SUPPORTED_DEVICE_FAMILIES {
    {STRATIX IV} {STRATIX V} {STRATIX 10}
    {ARRIA II GX} {ARRIA II GZ} {ARRIA V} {ARRIA V GZ} {ARRIA 10}
    {CYCLONE IV GX} {CYCLONE IV E} {CYCLONE V} {CYCLONE 10 LP}
    {MAX 10 FPGA} 
}


add_fileset example_design EXAMPLE_DESIGN example_fileset "Viterbi Example Design"

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/dmi1416822321903/dmi1416822603240 
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697994286 

# 
# device parameters
# this is currently not used by the core itself but is necessary for 
# old to new migration as ip_migrate.tcl uses this paramter to set the 
# device family for qsys
# 
add_parameter selected_device_family STRING
set_parameter_property selected_device_family VISIBLE false
set_parameter_property selected_device_family SYSTEM_INFO {DEVICE_FAMILY}
set_parameter_property selected_device_family HDL_PARAMETER false

set_parameter_property design_env HDL_PARAMETER false
set_parameter_property design_env VISIBLE false
set_parameter_property design_env SYSTEM_INFO DESIGN_ENVIRONMENT

add_display_item "Code sets"           widget_group     group tab
add_display_item widget_group data_width       parameter
add_display_item widget_group fabric           parameter
add_display_item widget_group enable_interrupt parameter
set jar_path [file join $env(QUARTUS_ROOTDIR) .. ip altera dsp altera_vit_ii top_hw Viterbi_Codes.jar]
set widget_name "Polynomial_Table"
set widget [list $jar_path $widget_name]
set_display_item_property widget_group WIDGET $widget

 set parameter_map {
    viterbi_type       arch
    ISOCTAL           octal
    ncodes             enabledCodes 
    N                  N            
    L                  L            
    DEC_MODE           M            
     ga                ga           
     gb                gb           
     gc                gc           
     gd                gd           
     ge                ge           
     gf                gf           
     gg                gg           
  }
set_display_item_property widget_group WIDGET_PARAMETER_MAP $parameter_map

    # set_parameter_property viterbi_type GROUP "Architecture"
    # set_parameter_property ISBER GROUP "Options"
    # set_parameter_property parallel_optimization GROUP "Optimizations"
    # set_parameter_property ISOCTAL GROUP "Code sets"
    # set_parameter_property acs_units GROUP "Parameters"
    # set_parameter_property FMAX GROUP "Throughput Calculator"
    # set_parameter_property rr_size GROUP "HDL"



add_display_item "Algorithm" "Architecture" GROUP  
# add_display_item "Algorithm" "Options" GROUP 
add_display_item "Algorithm" "Optimizations" GROUP 
add_display_item "Algorithm" "Parameters" GROUP 

add_display_item "" "Algorithm" GROUP TAB
add_display_item "" "Code sets"         GROUP TAB
add_display_item "" "Throughput Calculator" GROUP TAB



# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 

#add_filesets auk_vit_top
add_filesets ""

proc generate {type entity} {

    set dir  ../src/hdl_libs
    add_file_list  $type  ${dir}/vi_interface.vhd 0
    add_file_list  $type  ${dir}/vi_functions.vhd 0
    set dir  ../src/rtl/Common_units 
    set file_list [get_file_list  $dir {*.*}  ]
    add_file_list  $type $file_list 0


    set dir_list [list  ../src/rtl/Hybrid ../src/rtl/Parallel]
    set file_list [get_file_list  $dir_list {*trb_atl*}]
    add_file_list  $type $file_list 1

    set file_list [get_file_list  $dir_list {*.*}  {*.ocp *trb_atl*}]
    add_file_list  $type $file_list 1

    set file_list [get_file_list  $dir_list  {*.ocp}]
    add_file_list  $type $file_list 0


    set orig_name auk_vit_top
    add_top_level_file  $type  $entity $orig_name

    # generate the c model files for simulation fileset
    if {$type != "QUARTUS_SYNTH"} {
       foreach c_file [get_c_model_files] {
          if {[string match *Makefile*  $c_file ] == 1} {
             add_fileset_file "c_model/Makefile" OTHER PATH "../${c_file}"
          } else {
             add_fileset_file $c_file OTHER PATH "../${c_file}"
          }
       }
    }
}


# +-----------------------------------
# | Callbacks
# | 
proc elaborate {} {
    set viterbi                    [ get_parameter_value viterbi_type ]
    set bmgwide                    [ get_parameter_value bmgwide ]    
    set numerr_size                [ get_parameter_value numerr_size ]
    set vlog_wide                  [ get_parameter_value vlog_wide ]
    set constraint_length_m_1      [ get_parameter_value constraint_length_m_1 ]
    set log2_n_max                 [ get_parameter_value log2_n_max ]
    set rr_size                    [ get_parameter_value rr_size ] 
    set ber                        [ get_parameter_value ber ] 
    set parallel_optimization      [ get_parameter_value parallel_optimization ]
    set bsf                        [ get_parameter_value best_state_finder ]
    set ncodes                     [ get_parameter_value ncodes ]
    set node_sync                  [ get_parameter_value node_sync ]
    set sel_code_size              [ get_parameter_value sel_code_size ]
    set n_max                      [ get_parameter_value n_max ]

    


    if {[string equal $ber "unused"]} {set isber 0} else {set isber 1}
    if {[string equal $node_sync "unused"]} {set isnodesync 0} else {set isnodesync 1}
    if {[string equal $viterbi "Hybrid"]|[string equal $bsf "used"]} {set isbsf 1} else {set isbsf 0}
    if {[string equal $viterbi "Parallel"]&[string equal $parallel_optimization "None"]} {set isnone 1} else {set isnone 0}
    if {[string equal $viterbi "Parallel"]&[string equal $parallel_optimization "Continuous"]} {set isconti 1} else {set isconti 0}
    if {[string equal $viterbi "Parallel"]&[string equal $parallel_optimization "Block"]} {set isblock 1} else {set isblock 0}
    if {[string equal $viterbi "Hybrid"]} {set ishyb 1} else {set ishyb 0}
    
    
    set in_datawidth   [expr $rr_size + $n_max + $isber  + $isnone + $sel_code_size*($ncodes>1)+ $log2_n_max*$isnodesync*$isber \
                       + $vlog_wide*$isnone + $constraint_length_m_1*(1-$isconti) + $ishyb*($vlog_wide+$constraint_length_m_1+$bmgwide)]
    set out_datawidth  [expr 1 + 8 + ($bmgwide + $constraint_length_m_1)*$isbsf + $numerr_size*$isber]
    

    add_interface end_ports conduit end
    set_interface_property end_ports ENABLED false

    # +-----------------------------------
    # | Elaborate sink interface (sch_in)
    # +-----------------------------------


    dsp_add_streaming_interface in sink
    set_interface_property in ENABLED true
    set_interface_property in associatedClock clk
    set_interface_property in associatedReset rst
	dsp_set_interface_property in readyLatency 1
    dsp_set_interface_property in dataBitsPerSymbol $in_datawidth
    
    add_interface_port in sink_sop startofpacket Input 1
    add_interface_port in sink_eop endofpacket Input 1    
    if {[string equal $viterbi "Parallel"] & [string equal $parallel_optimization "Continuous"]} { 
        set_port_property sink_sop TERMINATION 1
        set_port_property sink_eop TERMINATION 1
    }
    add_interface_port in sink_val valid Input 1
    add_interface_port in sink_rdy ready Output 1
    
    
    
    
    set fraglist_in     [list ]
	set fraglistdisplay [list]
    
    if {[string equal $ber "used"] & [string equal $node_sync "used"]} {
        lappend fraglist_in state_node_sync $log2_n_max
		lappend fraglistdisplay "state_node_sync \[[expr $log2_n_max-1]:0\]"
    } else {
        add_interface_port end_ports state_node_sync export Input $log2_n_max
        if {$log2_n_max>1} {
            set_port_property state_node_sync VHDL_TYPE STD_LOGIC_VECTOR
        }
    }     
    if {[string equal $ber "used"]} {
        lappend fraglist_in  ber_clear 1
        lappend fraglistdisplay "ber_clear\[0:0\]"
    } else {
        add_interface_port end_ports ber_clear export Input 1
        set_port_property ber_clear TERMINATION 1
    }

    if {$ncodes>1} {
        lappend fraglist_in sel_code $sel_code_size
        lappend fraglistdisplay "sel_code\[[expr $sel_code_size-1]:0\]"
    } else {
        add_interface_port end_ports sel_code export Input $sel_code_size
        if {$sel_code_size>1} {
            set_port_property sel_code VHDL_TYPE STD_LOGIC_VECTOR
        }
    }

    if {[string equal $viterbi "Parallel"]&([string equal $parallel_optimization "None"])} {
        lappend fraglist_in tb_type 1
        lappend fraglistdisplay "tb_type\[0:0\]"
    } else {
        add_interface_port in tb_type data Input 1 
        set_port_property tb_type TERMINATION 1
    }

    if {[string equal $viterbi "Parallel"]&([string equal $parallel_optimization "Continuous"] | [string equal $parallel_optimization "Block"]) } {
        add_interface_port end_ports tb_length export Input $vlog_wide
    } else {
        lappend fraglist_in  tb_length $vlog_wide
        lappend fraglistdisplay "tb_length\[[expr $vlog_wide-1]:0\]   "
    }  
    
    if {[string equal $viterbi "Parallel"]&[string equal $parallel_optimization "Continuous"]} {
        add_interface_port end_ports tr_init_state export Input $constraint_length_m_1
    } else {
        lappend fraglist_in  tr_init_state $constraint_length_m_1
        lappend fraglistdisplay "tr_init_state\[[expr $constraint_length_m_1-1]:0\]   "
    }  
    
    if {[string equal $viterbi "Hybrid"]} {
        lappend fraglist_in bm_init_state $constraint_length_m_1 bm_init_value $bmgwide  
        lappend fraglistdisplay "bm_init_state\[[expr $constraint_length_m_1-1]:0\]   "
        lappend fraglistdisplay "bm_init_value\[[expr $bmgwide-1]:0\]   "    
    } else {
        #add_interface_port end_ports bm_init_state export Input $constraint_length_m_1
        #add_interface_port end_ports bm_init_value export Input $bmgwide
        add_interface_port in bm_init_state data Input $constraint_length_m_1 
		set_port_property bm_init_state VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property bm_init_state TERMINATION 1
        set_port_property bm_init_state TERMINATION_VALUE 0
        add_interface_port in bm_init_value data Input $bmgwide 
		set_port_property bm_init_value VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property bm_init_value TERMINATION 1
        set_port_property bm_init_value TERMINATION_VALUE 0
    }  
    
    lappend fraglist_in eras_sym $n_max rr $rr_size
    lappend fraglistdisplay "eras_sym\[[expr $n_max-1]:0\]   "
    lappend fraglistdisplay "rr\[[expr $rr_size-1]:0\]   "
    dsp_add_interface_port in sink_data data Input $in_datawidth $fraglist_in

    send_message info "Input data list:   $fraglistdisplay"

    # +-----------------------------------
    # | Elaborate sink interface (cw_out)
    # +-----------------------------------
    dsp_add_streaming_interface out source
    set_interface_property out ENABLED true
    set_interface_property out associatedClock clk
    set_interface_property out associatedReset rst
	dsp_set_interface_property out readyLatency 1
    dsp_set_interface_property out dataBitsPerSymbol $out_datawidth

    
    add_interface_port out source_sop startofpacket Output 1
    add_interface_port out source_eop endofpacket Output 1
    if {[string equal $viterbi "Parallel"] & [string equal $parallel_optimization "Continuous"]} { 
        set_port_property source_sop TERMINATION 1
        set_port_property source_eop TERMINATION 1
    }
    add_interface_port out source_val valid Output 1
    add_interface_port out source_rdy ready Input 1
    
    
    set fraglist_out       [list ]
	set fraglistdisplay    [list ]
    
    if {[string equal $ber "used"]} {
        lappend fraglist_out numerr $numerr_size
		lappend fraglistdisplay "numerr\[[expr $numerr_size-1]:0\]   "
    } else {
        #add_interface_port end_ports numerr export Output $numerr_size
        add_interface_port out numerr data Output $numerr_size 
		set_port_property numerr VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property numerr TERMINATION 1
    } 
    if {[string equal $viterbi "Hybrid"]|[string equal $bsf "used"]} {
        lappend fraglist_out bestadd $constraint_length_m_1 bestmet $bmgwide
        lappend fraglistdisplay "bestadd\[[expr $constraint_length_m_1-1]:0\]   "
        lappend fraglistdisplay "bestmet\[[expr $bmgwide-1]:0\]   "
    } else {
        add_interface_port end_ports bestadd export Output $constraint_length_m_1
        add_interface_port end_ports bestmet export Output $bmgwide
    } 
    
    lappend fraglist_out  normalizations 8 decbit 1
    lappend fraglistdisplay "normalizations\[7:0\]   "
    lappend fraglistdisplay "decbit\[0:0\]   "

    dsp_add_interface_port out out_data data Output $out_datawidth $fraglist_out

    send_message info "Output data list: $fraglistdisplay"
}


# +-----------------------------------
# | connection point clock
# | 
add_interface clk clock end
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point reset
# | 
add_interface rst reset end
set_interface_property rst ENABLED true
set_interface_property rst associatedClock clk
add_interface_port rst reset reset Input 1
# | 
# +-----------------------------------

proc get_c_model_files {} {
   set c_model_files {
        c_model/Example/Example_Command.txt
	c_model/Example/a_rcvsym.txt
	c_model/Example/block_period_stim.txt
	c_model/Example/decoded_expected.txt
        c_model/Makefile.txt
	c_model/Readme.txt
	c_model/c_wrapper.c
	c_model/c_wrapper_args.c
	c_model/compile.sh
	c_model/compile_mex.sh
	c_model/decoded_c.txt
	c_model/mex_vit.cpp
	c_model/mex_vit_direct.cpp
	c_model/mex_vit_direct_out.cpp
	c_model/varchmodel.c
	c_model/varchmodel.h
	c_model/vcommonlib.c
	c_model/vcommonlib.h
	c_model/vdef.h
	c_model/venginelib.c
	c_model/venginelib.h
   }
   return $c_model_files
}

