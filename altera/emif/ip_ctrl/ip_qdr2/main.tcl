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


package provide altera_emif::ip_ctrl::ip_qdr2::main 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::enum_defs
package require altera_emif::util::arch_expert
package require altera_emif::util::device_family
package require altera_emif::ip_top::exports
package require altera_emif::ip_ctrl::util
package require altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports
package require altera_emif::ip_ctrl::ip_qdr2::enum_defs

namespace eval ::altera_emif::ip_ctrl::ip_qdr2::main:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*

}


proc ::altera_emif::ip_ctrl::ip_qdr2::main::create_parameters {} {
     
   ::altera_emif::ip_top::exports::inherit_top_level_parameter_defs
   
   ::altera_emif::ip_ctrl::util::define_common_hdl_parameters

   add_derived_hdl_param      CTRL_BL        integer              4
   add_derived_hdl_param      CTRL_BWS_EN    boolean              true

   return 1
}

proc ::altera_emif::ip_ctrl::ip_qdr2::main::elaboration_callback {} {

   if {[get_parameter_value SYS_INFO_DEVICE_FAMILY] == ""} {
      return 0
   }

   ::altera_emif::util::device_family::load_data
   
   set if_ports_names [altera_emif::ip_ctrl::util::register_ctrl_interfaces CTRL_QDR2_IF]
   set if_ports [dict get $if_ports_names IF_PORTS]
   set if_names [dict get $if_ports_names IF_NAMES]
   
   foreach if_enum [list IF_CTRL_AMM] {
     foreach if_index [dict keys [dict get $if_names $if_enum]] {
        set if_name [dict get $if_names $if_enum $if_index] 

        set rdata_valid_port_name [enum_data PORT_CTRL_AMM_RDATA_VALID RTL_NAME]
        set rdata_port_name       [enum_data PORT_CTRL_AMM_RDATA RTL_NAME]
        set read_port_name        [enum_data PORT_CTRL_AMM_READ RTL_NAME]
        set wdata_port_name       [enum_data PORT_CTRL_AMM_WDATA RTL_NAME]
        set write_port_name       [enum_data PORT_CTRL_AMM_WRITE RTL_NAME]
        
        if {$if_index != -1} {
         set rdata_valid_port_name "${rdata_valid_port_name}_${if_index}"
         set rdata_port_name       "${rdata_port_name}_${if_index}"
         set read_port_name        "${read_port_name}_${if_index}"
         set wdata_port_name       "${wdata_port_name}_${if_index}"
         set write_port_name       "${write_port_name}_${if_index}"
        }
          
        if {$if_index == 0} {
           set_port_property $wdata_port_name TERMINATION_VALUE 0
           set_port_property $wdata_port_name TERMINATION true
           
           set_port_property $write_port_name TERMINATION_VALUE 0
           set_port_property $write_port_name TERMINATION true
        } 
          
        if {$if_index == 1} {
           set_port_property $rdata_valid_port_name TERMINATION_VALUE 0
           set_port_property $rdata_valid_port_name TERMINATION true
             
           set_port_property $rdata_port_name TERMINATION_VALUE 0
           set_port_property $rdata_port_name TERMINATION true
             
           set_port_property $read_port_name TERMINATION_VALUE 0
           set_port_property $read_port_name TERMINATION true
             
           set_interface_property $if_name maximumPendingReadTransactions 0
        }
     }
   }
         
   ::altera_emif::ip_ctrl::util::derive_common_hdl_parameters $if_ports
   
   _derive_mem_model_parameters
   
   issue_pending_ipgen_e_msg_and_terminate
   
   return 1
}

proc ::altera_emif::ip_ctrl::ip_qdr2::main::sim_vhdl_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::sim_vhdl_fileset_callback $top_level [_generate_verilog_fileset]
}

proc ::altera_emif::ip_ctrl::ip_qdr2::main::sim_verilog_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::sim_verilog_fileset_callback $top_level [_generate_verilog_fileset]
}

proc ::altera_emif::ip_ctrl::ip_qdr2::main::quartus_synth_fileset_callback {top_level} {
   ::altera_emif::ip_ctrl::util::quartus_synth_fileset_callback $top_level [_generate_verilog_fileset]
}


proc ::altera_emif::ip_ctrl::ip_qdr2::main::_derive_mem_model_parameters {} {
   set mem_model_param_list   [list \
                                 BL \
                                 BWS_EN
                              ]

   foreach mem_model_param $mem_model_param_list {
      set_parameter_value "CTRL_${mem_model_param}"  [get_parameter_value "MEM_QDR2_${mem_model_param}"]   
   }
}

proc ::altera_emif::ip_ctrl::ip_qdr2::main::_generate_verilog_fileset {} {
   
   set qdir $::env(QUARTUS_ROOTDIR)
	set common_dir "${qdir}/../ip/altera/emif/ip_ctrl/common/rtl"
   
   set file_list [list \
      rtl/altera_emif_ctrl_qdr2_top.sv \
      rtl/altera_emif_ctrl_qdr2.sv \
      rtl/altera_emif_ctrl_qdr2_afi.sv \
      rtl/altera_emif_ctrl_qdr2_fsm.sv	\
      ${common_dir}/altera_emif_ctrl_burst_latency_shifter.sv \
      ${common_dir}/altera_emif_ctrl_data_if.sv \
      ${common_dir}/altera_emif_ctrl_reset_sync.sv

   ]
 
   return $file_list
}

proc ::altera_emif::ip_ctrl::ip_qdr2::main::_init {} {
}

::altera_emif::ip_ctrl::ip_qdr2::main::_init

