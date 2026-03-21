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


package provide altera_phylite::ip_agent::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_phylite::ip_top::exports

package require altera_emif::util::device_family

namespace eval ::altera_phylite::ip_agent::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_phylite::ip_agent::main::create_parameters {} {
   
   ::altera_phylite::ip_top::exports::inherit_top_level_parameter_defs

   set_parameter_property PHYLITE_NUM_GROUPS                  HDL_PARAMETER true
   set_parameter_property PHYLITE_USE_DYNAMIC_RECONFIGURATION HDL_PARAMETER true
   

   add_user_param     AGENT_GROUP_INDEX                     integer   0                    {0:17}

   add_derived_param  "AGENT_INDEX"                        integer    0                 false
   add_derived_param  "AGENT_PIN_TYPE"                     string     ""                false
   add_derived_param  "AGENT_PIN_WIDTH"                    integer    0                 false
   add_derived_param  "AGENT_DDR_SDR_MODE"                 string     ""                false
   add_derived_param  "AGENT_STROBE_CONFIG"                string     "SINGLE_ENDED"    false
   add_derived_param  "AGENT_DATA_CONFIG"                  string     "SGL_ENDED"       false
   add_derived_param  "AGENT_READ_LATENCY"                 integer    0                 false
   add_derived_param  "AGENT_CAPTURE_PHASE_SHIFT"          integer    0                 false
   add_derived_param  "AGENT_WRITE_LATENCY"                integer    0                 false
   add_derived_param  "AGENT_USE_OUTPUT_STROBE"            boolean    false             false
   add_derived_param  "AGENT_USE_SEPARATE_STROBES"         boolean    false             false
   add_derived_param  "AGENT_OUTPUT_STROBE_PHASE"          integer    0                 false
   add_derived_param  "AGENT_USE_INTERNAL_CAPTURE_STROBE"  boolean    false             false
   add_derived_param  "AGENT_SWAP_CAPTURE_STROBE_POLARITY" boolean    false             false
   add_derived_param  "AGENT_DATA_IN_DELAY_PS"             integer    0                 false
   add_derived_param  "AGENT_DATA_OUT_DELAY_PS"            integer    0                 false
   add_derived_param  "AGENT_STROBE_OUT_DELAY_PS"          integer    0                 false

   set_parameter_property "AGENT_INDEX"                        HDL_PARAMETER true
   set_parameter_property "AGENT_PIN_TYPE"                     HDL_PARAMETER true
   set_parameter_property "AGENT_PIN_WIDTH"                    HDL_PARAMETER true
   set_parameter_property "AGENT_DDR_SDR_MODE"                 HDL_PARAMETER true
   set_parameter_property "AGENT_STROBE_CONFIG"                HDL_PARAMETER true
   set_parameter_property "AGENT_DATA_CONFIG"                  HDL_PARAMETER true
   set_parameter_property "AGENT_READ_LATENCY"                 HDL_PARAMETER true
   set_parameter_property "AGENT_CAPTURE_PHASE_SHIFT"          HDL_PARAMETER true
   set_parameter_property "AGENT_WRITE_LATENCY"                HDL_PARAMETER true
   set_parameter_property "AGENT_USE_OUTPUT_STROBE"            HDL_PARAMETER true
   set_parameter_property "AGENT_USE_SEPARATE_STROBES"         HDL_PARAMETER true
   set_parameter_property "AGENT_OUTPUT_STROBE_PHASE"          HDL_PARAMETER true
   set_parameter_property "AGENT_USE_INTERNAL_CAPTURE_STROBE"  HDL_PARAMETER true
   set_parameter_property "AGENT_SWAP_CAPTURE_STROBE_POLARITY" HDL_PARAMETER true
   set_parameter_property "AGENT_DATA_IN_DELAY_PS"             HDL_PARAMETER true
   set_parameter_property "AGENT_DATA_OUT_DELAY_PS"            HDL_PARAMETER true
   set_parameter_property "AGENT_STROBE_OUT_DELAY_PS"          HDL_PARAMETER true

   return 1
}

proc ::altera_phylite::ip_agent::main::elaboration_callback {} {

   ::altera_emif::util::device_family::load_data

   set agent_idx [get_parameter_value AGENT_GROUP_INDEX]

   _elaborate_mem_cmd_interface
   _elaborate_mem_cmd_next_interface
   _elaborate_io_interface
   _elaborate_side_interface
   _elaborate_side_next_interface

   set_parameter_value "AGENT_INDEX"                        $agent_idx
   set_parameter_value "AGENT_PIN_TYPE"                     [get_parameter_value "GROUP_${agent_idx}_PIN_TYPE"                    ]
   set_parameter_value "AGENT_PIN_WIDTH"                    [get_parameter_value "GROUP_${agent_idx}_PIN_WIDTH"                   ]
   set_parameter_value "AGENT_DDR_SDR_MODE"                 [get_parameter_value "GROUP_${agent_idx}_DDR_SDR_MODE"                ]
   set_parameter_value "AGENT_STROBE_CONFIG"                [get_parameter_value "GROUP_${agent_idx}_STROBE_CONFIG"               ]
   set_parameter_value "AGENT_DATA_CONFIG"                  [get_parameter_value "GROUP_${agent_idx}_DATA_CONFIG"                 ]
   set_parameter_value "AGENT_READ_LATENCY"                 [get_parameter_value "GROUP_${agent_idx}_READ_LATENCY"                ]
   set_parameter_value "AGENT_CAPTURE_PHASE_SHIFT"          [get_parameter_value "GROUP_${agent_idx}_CAPTURE_PHASE_SHIFT"         ]
   set_parameter_value "AGENT_WRITE_LATENCY"                [get_parameter_value "GROUP_${agent_idx}_WRITE_LATENCY"               ]
   set_parameter_value "AGENT_USE_OUTPUT_STROBE"            [get_parameter_value "GROUP_${agent_idx}_USE_OUTPUT_STROBE"           ]
   set_parameter_value "AGENT_USE_SEPARATE_STROBES"         [get_parameter_value "GROUP_${agent_idx}_USE_SEPARATE_STROBES"        ]
   set_parameter_value "AGENT_OUTPUT_STROBE_PHASE"          [get_parameter_value "GROUP_${agent_idx}_OUTPUT_STROBE_PHASE"         ]
   set_parameter_value "AGENT_USE_INTERNAL_CAPTURE_STROBE"  [get_parameter_value "GROUP_${agent_idx}_USE_INTERNAL_CAPTURE_STROBE" ]
   set_parameter_value "AGENT_SWAP_CAPTURE_STROBE_POLARITY" [get_parameter_value "GROUP_${agent_idx}_SWAP_CAPTURE_STROBE_POLARITY"]

   set use_dyn_cfg      [get_parameter_value PHYLITE_USE_DYNAMIC_RECONFIGURATION]
   set mem_clk_freq_mhz [get_parameter_value PHYLITE_MEM_CLK_FREQ_MHZ]

   set data_in_del    0
   set data_out_del   0
   set strobe_out_del 0
   if {[string compare -nocase $use_dyn_cfg "true"] == 0} {
      set delays [_get_rand_delays $mem_clk_freq_mhz]

      set data_in_del    [lindex $delays 0]
      set data_out_del   [lindex $delays 1]
      set strobe_out_del [lindex $delays 2]
   }

   set_parameter_value "AGENT_DATA_IN_DELAY_PS"    $data_in_del
   set_parameter_value "AGENT_DATA_OUT_DELAY_PS"   $data_out_del
   set_parameter_value "AGENT_STROBE_OUT_DELAY_PS" $strobe_out_del

   return 1
}

proc ::altera_phylite::ip_agent::main::sim_vhdl_fileset_callback {top_level} {
  
   set rtl_only 1
   set encrypted 1   
   
   set non_encryp_simulators [::altera_emif::util::hwtcl_utils::get_simulator_attributes 1]

   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]

      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name] PATH $file_path $non_encryp_simulators

      add_fileset_file [file join mentor $file_name] [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH [file join mentor $file_path] {MENTOR_SPECIFIC}
   }   
}

proc ::altera_phylite::ip_agent::main::sim_verilog_fileset_callback {top_level} {
   
   set rtl_only 1
   set encrypted 0   
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }   
}

proc ::altera_phylite::ip_agent::main::quartus_synth_fileset_callback {top_level} {
   
   set rtl_only 0
   set encrypted 0
   
   foreach file_path [_generate_verilog_fileset] {
      set tmp [file split $file_path]
      set file_name [lindex $tmp end]
      add_fileset_file $file_name [::altera_emif::util::hwtcl_utils::get_file_type $file_name $rtl_only $encrypted] PATH $file_path
   }  
}



proc ::altera_phylite::ip_agent::main::_generate_verilog_fileset {} {

   set file_list [list \
      rtl/phylite_agent.sv \
   ]
 
   return $file_list
}

proc ::altera_phylite::ip_agent::main::_elaborate_io_interface {} {
   set grp_idx [get_parameter_value AGENT_GROUP_INDEX]

   set pin_type             [get_parameter_value "GROUP_${grp_idx}_PIN_TYPE"           ]
   set pin_width            [get_parameter_value "GROUP_${grp_idx}_PIN_WIDTH"          ]
   set use_separate_strobes [get_parameter_value "GROUP_${grp_idx}_USE_SEPARATE_STROBES"]
   set data_config 	    [get_parameter_value "GROUP_${grp_idx}_DATA_CONFIG"]

   set num_strobes [::altera_phylite::ip_top::group::get_num_strobes_in_grp ${grp_idx}]
   
   set io_interface "io_interface_conduit_end"
   add_interface $io_interface conduit end
   set_interface_property $io_interface ENABLED true

   add_interface_port $io_interface data_in      io_data_out     Input  $pin_width
   set_port_property data_in VHDL_TYPE std_logic_vector
   add_interface_port $io_interface strobe_in    io_strobe_out   Input  1
   add_interface_port $io_interface strobe_in_n  io_strobe_out_n Input  1
   add_interface_port $io_interface data_out     io_data_in      Output $pin_width
   set_port_property data_out VHDL_TYPE std_logic_vector
   add_interface_port $io_interface strobe_out   io_strobe_in    Output 1
   add_interface_port $io_interface strobe_out_n io_strobe_in_n  Output 1
   add_interface_port $io_interface data_io      io_data_io      Bidir  $pin_width
   set_port_property data_io VHDL_TYPE std_logic_vector
   add_interface_port $io_interface strobe_io    io_strobe_io    Bidir  1
   add_interface_port $io_interface strobe_io_n  io_strobe_io_n  Bidir  1
   add_interface_port $io_interface data_in_n      io_data_out_n     Input  $pin_width
   set_port_property data_in_n VHDL_TYPE std_logic_vector
   add_interface_port $io_interface data_out_n     io_data_in_n      Output $pin_width
   set_port_property data_out_n VHDL_TYPE std_logic_vector
   add_interface_port $io_interface data_io_n      io_data_io_n      Bidir  $pin_width
   set_port_property data_io_n VHDL_TYPE std_logic_vector

   if {[string compare -nocase $pin_type "OUTPUT"] == 0} {
      set_port_property data_out   TERMINATION true
      set_port_property data_io    TERMINATION true
      set_port_property data_out_n TERMINATION true
      set_port_property data_io_n  TERMINATION true

      if {[string compare -nocase $data_config "SGL_ENDED"] == 0} {
	      set_port_property data_in_n TERMINATION true
      }
 
      set_port_property strobe_out   TERMINATION true
      set_port_property strobe_out_n TERMINATION true
      set_port_property strobe_io    TERMINATION true
      set_port_property strobe_io_n  TERMINATION true

      if {$num_strobes == 0} {
         set_port_property strobe_in   TERMINATION true
	 set_port_property strobe_in_n TERMINATION true
      }
      if {$num_strobes == 1} {
         set_port_property strobe_in_n TERMINATION true
      }
   } elseif {[string compare -nocase $pin_type "INPUT"] == 0} {
      set_port_property data_in    TERMINATION true
      set_port_property data_io    TERMINATION true
      set_port_property data_in_n  TERMINATION true
      set_port_property data_io_n  TERMINATION true
 
      if {[string compare -nocase $data_config "SGL_ENDED"] == 0} {
	      set_port_property data_out_n TERMINATION true
      }
      
      set_port_property strobe_in    TERMINATION true
      set_port_property strobe_in_n  TERMINATION true
      set_port_property strobe_io    TERMINATION true
      set_port_property strobe_io_n  TERMINATION true

      if {$num_strobes == 0} {
         set_port_property strobe_out   TERMINATION true
         set_port_property strobe_out_n TERMINATION true
      }
      if {$num_strobes == 1} {
         set_port_property strobe_out_n TERMINATION true
      }
   } else { 
      set_port_property data_out   TERMINATION true
      set_port_property data_in    TERMINATION true
      set_port_property data_out_n TERMINATION true
      set_port_property data_in_n  TERMINATION true

      if {[string compare -nocase $data_config "SGL_ENDED"] == 0} {
	      set_port_property data_io_n TERMINATION true
      }

      if { [string compare -nocase $use_separate_strobes "true"] == 0 } {
         set_port_property strobe_io    TERMINATION true
         set_port_property strobe_io_n  TERMINATION true

         if {$num_strobes == 2} {
            set_port_property strobe_out_n TERMINATION true
            set_port_property strobe_in_n  TERMINATION true
         }
      } else {
         set_port_property strobe_out   TERMINATION true
         set_port_property strobe_out_n TERMINATION true
         set_port_property strobe_in    TERMINATION true
         set_port_property strobe_in_n  TERMINATION true

         if {$num_strobes == 0} {
            set_port_property strobe_io   TERMINATION true
            set_port_property strobe_io_n TERMINATION true
         }
         if {$num_strobes == 1} {
            set_port_property strobe_io_n TERMINATION true
         }
      }
   }
}

proc ::altera_phylite::ip_agent::main::_elaborate_side_interface {} {
   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]

   set side_interface "side_interface_conduit_end"
   add_interface $side_interface conduit end
   set_interface_property $side_interface ENABLED true

   add_interface_port $side_interface side_write_in           side_write          Input  1
   add_interface_port $side_interface side_read_in            side_read           Input  1
   add_interface_port $side_interface side_write_data_in      side_write_data     Input  48*2
   add_interface_port $side_interface side_read_data_out      side_read_data      Output 48*2
   add_interface_port $side_interface side_readdata_valid_out side_readdata_valid Output 1
   add_interface_port $side_interface side_readaddr_in        side_readaddr       Input  4
   add_interface_port $side_interface agent_select_in         agent_select        Input  $num_grps
   set_port_property agent_select_in VHDL_TYPE STD_LOGIC_VECTOR
}

proc ::altera_phylite::ip_agent::main::_elaborate_side_next_interface {} {
   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]

   set side_interface "side_next_interface_conduit_end"
   add_interface $side_interface conduit end
   set_interface_property $side_interface ENABLED true

   add_interface_port $side_interface side_write_out          side_write          Output  1
   add_interface_port $side_interface side_read_out           side_read           Output  1
   add_interface_port $side_interface side_write_data_out     side_write_data     Output  48*2
   add_interface_port $side_interface side_read_data_in       side_read_data      Input 48*2
   add_interface_port $side_interface side_readdata_valid_in  side_readdata_valid Input 1
   add_interface_port $side_interface side_readaddr_out       side_readaddr       Output  4
   add_interface_port $side_interface agent_select_out        agent_select        Output  $num_grps
   set_port_property agent_select_out VHDL_TYPE STD_LOGIC_VECTOR
}

proc ::altera_phylite::ip_agent::main::_elaborate_mem_cmd_interface {} {
   set num_grps 	[get_parameter_value PHYLITE_NUM_GROUPS]
   set rate     	[get_parameter_value  "PHYLITE_RATE_ENUM"]

   set rate_mult 4
   if {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
      set rate_mult 2
   } elseif {[string compare -nocase $rate "RATE_IN_FULL"] == 0} {
      set rate_mult 1
   }

   set cmd_interface "mem_cmd_interface_conduit_end"
   add_interface $cmd_interface conduit end
   set_interface_property $cmd_interface ENABLED true
   add_interface_port $cmd_interface mem_cmd_in     io_data_out     Input 3+${num_grps}
   add_interface_port $cmd_interface mem_cmd_clk_in io_strobe_out Input 1

}

proc ::altera_phylite::ip_agent::main::_elaborate_mem_cmd_next_interface {} {
   set num_grps [get_parameter_value PHYLITE_NUM_GROUPS]
   set rate     [get_parameter_value  "PHYLITE_RATE_ENUM"]

   set rate_mult 4
   if {[string compare -nocase $rate "RATE_IN_HALF"] == 0} {
      set rate_mult 2
   } elseif {[string compare -nocase $rate "RATE_IN_FULL"] == 0} {
      set rate_mult 1
   }

   set cmd_interface "mem_cmd_next_interface_conduit_end"
   add_interface $cmd_interface conduit end
   set_interface_property $cmd_interface ENABLED true
   add_interface_port $cmd_interface mem_cmd_out	io_data_out 	Output 3+${num_grps}
   add_interface_port $cmd_interface mem_cmd_clk_out io_strobe_out Output 1

}

proc ::altera_phylite::ip_agent::main::_get_rand_delays {mem_clk_freq_mhz} {
   set retval [list]

   set mem_clk_freq_ps [expr (1.0/${mem_clk_freq_mhz})*1000000]

   set max_delay_ps   [expr ((${mem_clk_freq_ps})/2.0)]
   set min_delay_ps   [expr (${max_delay_ps}/2.0)]


   set data_in_del    [expr int(${min_delay_ps}+((${max_delay_ps}-${min_delay_ps})/2.0))]
   set data_out_del   [expr int(${min_delay_ps}+((${max_delay_ps}-${min_delay_ps})/2.0))]
   set strobe_out_del [expr int(${min_delay_ps}+((${max_delay_ps}-${min_delay_ps})/2.0))]

   lappend retval $data_in_del
   lappend retval $data_out_del
   lappend retval $strobe_out_del

   return $retval
}

proc ::altera_phylite::ip_agent::main::_init {} {
}

::altera_phylite::ip_agent::main::_init
