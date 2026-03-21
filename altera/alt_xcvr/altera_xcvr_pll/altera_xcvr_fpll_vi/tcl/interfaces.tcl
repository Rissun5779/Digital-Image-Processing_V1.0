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
# | request TCL package from other libraries
# | 
package provide altera_xcvr_fpll_vi::interfaces 18.1
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages
package require mcgb_package_vi::mcgb

# +-----------------------------------
# | create CMU_FPLL interface
# |
namespace eval ::altera_xcvr_fpll_vi::interfaces:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
   namespace import ::alt_xcvr::ip_tcl::messages::*
   namespace export \
      declare_interfaces \
      elaborate
   variable interfaces
   set interfaces {\
      {NAME                 		DIRECTION UI_DIRECTION  WIDTH_EXPR         ROLE              TERMINATION_VALUE  IFACE_NAME        			IFACE_TYPE  		IFACE_DIRECTION  TERMINATION                                                       									ELABORATION_CALLBACK } \
      {pll_refclk0          		input     input         1                  clk               NOVAL              pll_refclk0       			clock       		sink             "gui_refclk_cnt < 1 || ((gui_fpll_mode == 2) && enable_cascade_in)"                                NOVAL                }\
      {pll_refclk1         		 	input     input         1                  clk               NOVAL              pll_refclk1      			clock       		sink             "(gui_refclk_cnt < 2 && !gui_refclk_switch) || ((gui_fpll_mode == 2) && enable_cascade_in)"        NOVAL                }\
      {pll_refclk2          		input     input         1                  clk               NOVAL              pll_refclk2       			clock       		sink             "gui_refclk_cnt < 3 || ((gui_fpll_mode == 2) && enable_cascade_in)"                                NOVAL                }\
      {pll_refclk3          		input     input         1                  clk               NOVAL              pll_refclk3       			clock       		sink             "gui_refclk_cnt < 4 || ((gui_fpll_mode == 2) && enable_cascade_in)"                                NOVAL                }\
      {pll_refclk4          		input     input         1                  clk               NOVAL              pll_refclk4       			clock       		sink             "gui_refclk_cnt < 5 || ((gui_fpll_mode == 2) && enable_cascade_in)"                                NOVAL                }\
      {pll_powerdown        		input     input         1                  pll_powerdown     NOVAL              pll_powerdown     			conduit     		sink             false                                     						   									NOVAL                } \
      {pll_locked           		output    output        1                  pll_locked        NOVAL              pll_locked        			conduit     		end              "gui_fpll_mode == 2 && gui_enable_fractional && gui_hssi_prot_mode == 6"                                     						   									NOVAL                } \
	  \
      {tx_serial_clk       			output    output        1                  clk     			 NOVAL              tx_serial_clk     			hssi_serial_clock   start            "!(gui_fpll_mode == 2)"  								   											NOVAL                } \
      {outclk0       				output    output        1                  clk      	   	 NOVAL              outclk0    		  			clock	     		start            "!(gui_fpll_mode == 0) || gui_number_of_output_clocks < 1"  	   									NOVAL                } \
      {outclk1       				output    output        1                  clk         		 NOVAL              outclk1    		  			clock	     		start            "!(gui_fpll_mode == 0) || gui_number_of_output_clocks < 2"  										NOVAL                } \
      {outclk2       				output    output        1                  clk         		 NOVAL              outclk2    		  			clock	     		start            "!(gui_fpll_mode == 0) || gui_number_of_output_clocks < 3"  	   									NOVAL                } \
      {outclk3       				output    output        1                  clk         		 NOVAL              outclk3    		  			clock	     		start            "!(gui_fpll_mode == 0) || gui_number_of_output_clocks < 4"  										NOVAL                } \
      {pll_pcie_clk         		output    output        1                  pll_pcie_clk      NOVAL              pll_pcie_clk      			conduit    			start            "!(gui_fpll_mode == 2) || gui_hssi_prot_mode == 0 || gui_hssi_prot_mode == 4 || gui_hssi_prot_mode == 5 || gui_hssi_prot_mode == 6"                									NOVAL                }\
	  \	
	  {fpll_to_fpll_cascade_clk		output    output        1                  clk         	 	 NOVAL              fpll_to_fpll_cascade_clk    clock	     		start            "!(gui_fpll_mode == 0 && gui_enable_cascade_out)"  	 								   			NOVAL                } \
	  {hssi_pll_cascade_clk			output    output        1                  clk         	 	 NOVAL              hssi_pll_cascade_clk 		clock	     		start            "!(gui_fpll_mode == 1)"										  	 					   				NOVAL                } \
      {atx_to_fpll_cascade_clk      input     input         1                  clk               NOVAL              atx_to_fpll_cascade_clk     clock               sink             "!enable_cascade_in || (gui_fpll_mode != 2)"                                                                               NOVAL                }\
      \                                                                                                                                                                                                                            									               
      {reconfig_clk0        		input    input          1                  clk               NOVAL              reconfig_clk0     			clock       		sink             "!(enable_pll_reconfig || (gui_enable_dps && gui_fpll_mode == 0))"                         									NOVAL                } \
      {reconfig_reset0       		input    input          1                  reset             NOVAL              reconfig_reset0   			reset      			slave            "!enable_pll_reconfig"                                            									::altera_xcvr_fpll_vi::interfaces::elaborate_reconfig_reset                } \
      {reconfig_write0       		input    input          1                  write             NOVAL              reconfig_avmm0    			avalon      		slave            "!enable_pll_reconfig"                                            									::altera_xcvr_fpll_vi::interfaces::elaborate_reconfig                } \
      {reconfig_read0        		input    input          1                  read              NOVAL              reconfig_avmm0    			avalon      		slave            "!enable_pll_reconfig"                                            									NOVAL                } \
      {reconfig_address0    		input    input          10                 address           NOVAL              reconfig_avmm0    			avalon      		slave            "!enable_pll_reconfig"                                            									NOVAL                } \
      {reconfig_writedata0   		input    input          32                 writedata         NOVAL              reconfig_avmm0    			avalon      		slave            "!enable_pll_reconfig"                                            									NOVAL                } \
      {reconfig_readdata0    		output   output         32                 readdata          NOVAL              reconfig_avmm0    			avalon      		slave            "!enable_pll_reconfig"                                            									NOVAL                } \
      {reconfig_waitrequest0 		output   output         1                  waitrequest       NOVAL              reconfig_avmm0    			avalon      		slave            "!enable_pll_reconfig"                                            									NOVAL                } \
      {avmm_busy0            		output   output         1                  avmm_busy0        NOVAL              avmm_busy0        			conduit     		end              "!enable_pll_reconfig || !rcfg_enable_avmm_busy_port || !enable_advanced_avmm_options"                                            									NOVAL                } \
      \                                                                                                                                   		                                                                                   									                     
      {pll_cal_busy          		output    output        1                  pll_cal_busy      NOVAL              pll_cal_busy      			conduit     		end              "!gui_enable_pld_cal_busy_port"                                   									NOVAL                } \
      {hip_cal_done          		output    output        1                  hip_cal_done      NOVAL              hip_cal_done      			conduit     		end              "!gui_enable_hip_cal_done_port"                                   									NOVAL                } \
      \                                                                                                                                   		                                                                                   							                     
      {phase_reset           		input     input         1                  phase_reset       NOVAL              phase_reset       			conduit     		sink             "!(gui_enable_dps && gui_fpll_mode == 0)"                                     			   									NOVAL                } \
      {phase_en        	 	 		input     input         1                  phase_en     	 NOVAL              phase_en     	  			conduit     		sink             "!(gui_enable_dps && gui_fpll_mode == 0)"      		     							   									NOVAL                } \
      {updn        	 	     		input     input         1                  updn     	     NOVAL              updn     	      			conduit     		sink             "!(gui_enable_dps && gui_fpll_mode == 0)"      		     							   									NOVAL                } \
      {cntsel        	 	 		input     input         4                  cntsel     	     NOVAL              cntsel     	      			conduit     		sink             "!(gui_enable_dps && gui_fpll_mode == 0)"      		     							   									NOVAL                } \
      {phase_done          	 		output    output        1                  phase_done      	 NOVAL              phase_done        			conduit     		end              "!(gui_enable_dps && gui_fpll_mode == 0)"                  							   									NOVAL                } \
      \                                                                                                                                   		                                                                                   									                     
      {extswitch        	 		input     input         1                  extswitch     	 NOVAL              extswitch     	  			conduit     		sink             "!gui_enable_extswitch || !gui_refclk_switch"      			   									NOVAL                } \
      {activeclk          	 		output    output        1                  activeclk      	 NOVAL              activeclk      	  			conduit     		end              "!gui_enable_active_clk || !gui_refclk_switch"                    									NOVAL                } \
      {clkbad          	 	 		output    output        2                  clkbad      	 	 NOVAL              clkbad      	  			conduit     		end              "!gui_enable_clk_bad || !gui_refclk_switch"                       									NOVAL                } \
      {clklow                           output    output        1                  clk               NOVAL            ext_lock_detect_clklow                     conduit                  end              "!enable_ext_lockdetect_ports"                                  NOVAL                } \
      {fref                             output    output        1                  clk               NOVAL            ext_lock_detect_fref                       conduit                  end              "!enable_ext_lockdetect_ports"                                  NOVAL                } \
}
}
# +-----------------------------------
# | 
# |
proc ::altera_xcvr_fpll_vi::interfaces::declare_interfaces {} {
   variable interfaces
   ip_declare_interfaces $interfaces
   ::mcgb_package_vi::mcgb::declare_mcgb_interfaces
}

# +-----------------------------------
# | 
# |
proc ::altera_xcvr_fpll_vi::interfaces::elaborate {} {
   ip_elaborate_interfaces
   
   	# Case:225478 -- provide a clock rate on input/output clock
	set mode [get_parameter_value gui_fpll_mode]
	if { $mode == 0 } {
		set num_clocks [get_parameter_value gui_number_of_output_clocks]
		for {set i 0} {$i < $num_clocks} {incr i} {
			set user_selected_gui_value [get_parameter_value gui_actual_outclk${i}_frequency]
			regexp {([-0-9.]+)} $user_selected_gui_value user_selected_gui_value_without_unit
			set user_selected_gui_value_hz [expr $user_selected_gui_value_without_unit * 1000000]
			set_interface_property outclk$i clockRateKnown true
			set_interface_property outclk$i clockRate $user_selected_gui_value_hz
		}
		
		set num_ref_clocks [get_parameter_value gui_refclk_cnt]		
		for {set i 0} {$i < $num_ref_clocks} {incr i} {
			set user_selected_gui_value [get_parameter_value gui_reference_clock_frequency]
			set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
			set_interface_property pll_refclk$i clockRate $user_selected_gui_value_hz
		}		
	} elseif { $mode == 1 } {
		set user_selected_gui_value [get_parameter_value gui_desired_hssi_cascade_frequency]
		set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
		set_interface_property hssi_pll_cascade_clk clockRateKnown true
		set_interface_property hssi_pll_cascade_clk clockRate $user_selected_gui_value_hz		

		set num_ref_clocks [get_parameter_value gui_refclk_cnt]		
		for {set i 0} {$i < $num_ref_clocks} {incr i} {
			set user_selected_gui_value [get_parameter_value full_actual_refclk_frequency]
			set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
			set_interface_property pll_refclk$i clockRate $user_selected_gui_value_hz
		}			
	} else {
		set user_selected_gui_value [get_parameter_value gui_hssi_output_clock_frequency]
		set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
		set_interface_property tx_serial_clk clockRate $user_selected_gui_value_hz		

		set num_ref_clocks [get_parameter_value gui_refclk_cnt]		
		for {set i 0} {$i < $num_ref_clocks} {incr i} {
			set user_selected_gui_value [get_parameter_value full_actual_refclk_frequency]
			set user_selected_gui_value_hz [expr $user_selected_gui_value * 1000000]
			set_interface_property pll_refclk$i clockRate $user_selected_gui_value_hz
		}		
	}
}

# +-----------------------------------
# | Call back function for elaborate reconfig reset port
# |
proc ::altera_xcvr_fpll_vi::interfaces::elaborate_reconfig_reset { } {
  ip_set "interface.reconfig_reset0.associatedclock" reconfig_clk0
}

# +-----------------------------------
# | Call back function for elaborate reconfig reset port
# |
proc ::altera_xcvr_fpll_vi::interfaces::elaborate_reconfig { device_revision } {
    set reconfig_clk "reconfig_clk0"
    set reconfig_reset "reconfig_reset0"

    ip_set "interface.reconfig_avmm0.associatedclock" $reconfig_clk
    ip_set "interface.reconfig_avmm0.associatedreset" $reconfig_reset
	ip_set "interface.reconfig_avmm0.assignment" [list "debug.typeName" "altera_xcvr_fpll_a10.slave"]
	ip_set "interface.reconfig_avmm0.assignment" [list "debug.param.device_revision" $device_revision]
}


