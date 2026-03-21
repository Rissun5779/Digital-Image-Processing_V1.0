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
package provide altera_xcvr_fpll_vi::parameters 18.1
package require alt_xcvr::ip_tcl::ip_module
package require alt_xcvr::ip_tcl::messages
package require alt_xcvr::gui::messages
package require alt_xcvr::utils::device
package require alt_xcvr::utils::common
#package require quartus::qcl_pll 
#package require quartus::advanced_pll_legality 
package require mcgb_package_vi::mcgb
package require alt_xcvr::utils::reconfiguration_arria10
package require nf_cmu_fpll::parameters

source [file join $env(QUARTUS_BINDIR) .. common tcl packages pll pll_fpll_legality.tcl]
#package ifneeded pll::legality 14.0 [list source [file join $env(QUARTUS_BINDIR) .. common tcl packages pll pll_legality.tcl]]
package require ::quartus::pll::fpll_legality
# 17 ensures full floating point precision
set tcl_precision 17

proc trim_freq_double_precision { freq } {
#    puts $freq
    set idx [ string last "." $freq ]
    set idx [ expr $idx+ 6 ]
    set result [ string range $freq 0 $idx ]
    return $result
}


# for IPTAF
#package require ::altera::generic_pll

# +-----------------------------------
# | create CMU_FPLL parameter list
# | 
namespace eval ::altera_xcvr_fpll_vi::parameters:: {
   namespace import ::alt_xcvr::ip_tcl::ip_module::*
   namespace import ::alt_xcvr::ip_tcl::messages::*
   namespace export \
      declare_parameters \
      validate \

   variable display_items_pll
   variable generation_display_items
   variable refclk_switchover_display_items
   variable parameters
   variable mapped_parameters
   variable parameters_allowed_range
   variable atom_parameters
   variable logical_parameters
   variable debug_message

   # turn on/off debug message
   set debug_message 0 
   
   set error_occurred_in_validation false
   set error_message ""
   
   # creating items for display elements such as tab, header...	
   set display_items_pll {\
      {NAME                         GROUP                    ENABLED   VISIBLE   				TYPE   ARGS  } \
      {"PLL"                    	""                       NOVAL     NOVAL     				GROUP  tab   } \
	  {"Device"						"PLL"					 NOVAL	   NOVAL					GROUP  noval } \
      {"General"              		"PLL"                	 NOVAL     NOVAL     				GROUP  noval } \
	  {"Reference Clock"      		"PLL"                	 NOVAL     NOVAL     				GROUP  noval } \
	  {"Settings"					"PLL"                    NOVAL     NOVAL					GROUP  noval } \
      {"Feedback"                   "PLL"                    NOVAL     NOVAL     				GROUP  noval } \
      {"Ports"                      "PLL"                    NOVAL     NOVAL     				GROUP  noval } \
	  {"Output Frequency"           "PLL"                    NOVAL     NOVAL     				GROUP  noval } \
      {"Transceiver Usage"          "Output Frequency"       NOVAL     "gui_fpll_mode == 2"  	GROUP  noval } \
      {"Core Usage"              	"Output Frequency"       NOVAL     "gui_fpll_mode == 0"		GROUP  noval } \
	  {"Cascade Usage"				"Output Frequency"		 NOVAL	   "gui_fpll_mode == 1"		GROUP  noval } \
      {"outclk0"              		"Core Usage"             NOVAL     NOVAL    				GROUP  noval } \
      {"outclk1"              		"Core Usage"             NOVAL     NOVAL    				GROUP  noval } \
      {"outclk2"              		"Core Usage"             NOVAL     NOVAL   				  	GROUP  noval } \
      {"outclk3"              		"Core Usage"             NOVAL     NOVAL    				GROUP  noval } \
   }

   set generation_display_items {\
      {NAME                         GROUP                    ENABLED   VISIBLE   TYPE   ARGS  } \
      {"Generation Options"         ""                       NOVAL     NOVAL     GROUP  tab   } \
   }

   set refclk_switchover_display_items {\
      {NAME                           GROUP                  ENABLED  	VISIBLE   				TYPE   ARGS  } \
      {"Clock Switchover"             ""                     NOVAL		"gui_fpll_mode == 0"	GROUP  tab   } \
	  {"Input Clock Switchover Mode"  "Clock Switchover"     NOVAL     	NOVAL     				GROUP  noval } \
   }

   set system_info_parameters {\
		{NAME                               M_CONTEXT  M_USED_FOR_RCFG  M_SAME_FOR_RCFG  VALIDATION_CALLBACK                                                          SYSTEM_INFO	DERIVED HDL_PARAMETER   TYPE      DEFAULT_VALUE 							ALLOWED_RANGES                               							  						ENABLED                  	   																																															VISIBLE                   											DISPLAY_HINT  DISPLAY_UNITS 	DISPLAY_ITEM     				DISPLAY_NAME                                         				DESCRIPTION } \
		{system_info_device_family			NOVAL	   0 				0 				 NOVAL																		  device_family	true	false			STRING	  "Arria 10"								NOVAL																							true																																																					false																NOVAL		  NOVAL				"Device"						"Device Family"														NOVAL} \
   }
   
   # creating items for widgets for each parameters such as check box, drop down list...
   set parameters {\
      {NAME                                    M_CONTEXT  M_USED_FOR_RCFG  M_SAME_FOR_RCFG  VALIDATION_CALLBACK                                                          DERIVED HDL_PARAMETER   TYPE      DEFAULT_VALUE 							WIDTH 			ALLOWED_RANGES                               							  						ENABLED                  	   																																																			VISIBLE                   											DISPLAY_HINT  DISPLAY_UNITS 	DISPLAY_ITEM     				DISPLAY_NAME                                         				M_UPGRADE_CALLBACK	DESCRIPTION } \
      {gui_pll_set_hssi_m_counter                  NOVAL	   1				0				 NOVAL 		 		                                                          false   false           INTEGER   8             					NOVAL			::altera_xcvr_fpll_vi::parameters::update_manual_config	 																  			true                                                                                                                                                                                                                                    gui_enable_manual_hssi_counters        								NOVAL 		  NOVAL  			"Transceiver Usage"				"Multiply factor (M-counter)"                       				NOVAL				"Specifies the multiply factor (M counter)"} \
	  {gui_pll_set_hssi_n_counter              NOVAL	   1				0				 NOVAL                                                                        false   false           INTEGER   1             							NOVAL			::altera_xcvr_fpll_vi::parameters::update_manual_config 																  	  		true                                                                                                                                                                                                                                    gui_enable_manual_hssi_counters 									NOVAL 		  NOVAL  			"Transceiver Usage"  			"Divide factor (N-counter)"                        					NOVAL				"Specifies the divide factor (N counter)"} \
	  {gui_pll_set_hssi_l_counter              NOVAL	   1				0				 NOVAL                                                                        false   false           INTEGER   1             							NOVAL			::altera_xcvr_fpll_vi::parameters::update_manual_config 																  	  		true                                                                                                                                                                                                                                    gui_enable_manual_hssi_counters 									NOVAL 		  NOVAL  			"Transceiver Usage"  			"Divide factor (L-counter)"                        					NOVAL				"Specifies the divide factor (L counter)"} \
	  {gui_pll_set_hssi_k_counter              NOVAL	   1				0				 NOVAL                                                                        false   false           LONG      1             							NOVAL			NOVAL 																  	  					    true	   																																																								gui_enable_manual_hssi_counters 									NOVAL 		  NOVAL  			"Transceiver Usage"  			"Divide factor (K-counter)"                        					NOVAL				"Specifies the divide factor (K counter)"} \
	  {device_family                           NOVAL	   0 				0 				 ::altera_xcvr_fpll_vi::parameters::update_device_family      			      true	  false			  STRING	"Arria 10"								NOVAL			NOVAL																							true																																																									false																NOVAL		  NOVAL				"Device"						"Device Family"														NOVAL				NOVAL} \
	  {device                                  NOVAL	   0 				0 				 NOVAL                                                       				  false	  false			  STRING	"Unknown"								NOVAL			NOVAL																							true																																																									false																NOVAL		  NOVAL				"Device"						"Device"														    NOVAL				NOVAL} \
	  {base_device                             NOVAL	   0 				0 				 NOVAL                                                       				  false	  false			  STRING	"Unknown"								NOVAL			NOVAL																							true																																																									false																NOVAL		  NOVAL				"Device"						"Device"														    NOVAL				NOVAL} \
      {device_revision                         NOVAL      0                0				 ::altera_xcvr_fpll_vi::parameters::validate_device_revision				  true    false           STRING    "20nm5es"								NOVAL		    { "20nm5es" "20nm5es2" "20nm4es" "20nm4es2" "20nm5" "20nm4" "20nm3" "20nm2" "20nm1"}            true																																																									false																NOVAL         NOVAL				NOVAL							NOVAL																NOVAL				NOVAL} \
	  {device_speed_grade                      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_device_speed_grade                 true    false           STRING    "fastest"     							NOVAL			NOVAL                                        							  						true                     	   																																																			false                      											NOVAL         NOVAL         	"Device"        				"Speed grade"                                						NOVAL				"Specifies the desired device speedgrade. This information is used for data rate validation."} \
	  {numeric_speed_grade                     NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_numeric_speed_grade	              true    false           INTEGER   1     									NOVAL			NOVAL                                        							  						true                     	   																																																			false                      											NOVAL         NOVAL         	"Device"        				"Speed grade"                                						NOVAL				"Specifies the desired device speedgrade. This information is used for data rate validation."} \   
	  \
	  {gui_fpll_mode                           NOVAL	   0 				0 				 ::altera_xcvr_fpll_vi::parameters::check_gui_fpll_mode						  false	  false			  STRING	2										NOVAL			{"0:Core" "1:Cascade Source" "2:Transceiver"}	         										true																																																									true																NOVAL		  NOVAL				"General"						"FPLL Mode"															::altera_xcvr_fpll_vi::parameters::upgrade_gui_fpll_mode					"Selects the primary operation mode of the FPLL (Core/Transceiver/Cascade source"} \
	  {primary_use                             NOVAL	   0 				0 				 ::altera_xcvr_fpll_vi::parameters::update_primary_use						  true	  false			  STRING	"tx"									NOVAL			NOVAL																							true																																																									false																NOVAL		  NOVAL				"General"						"FPLL Mode"															NOVAL				NOVAL} \
	  {gui_hssi_prot_mode                      NOVAL	   1				0				 ::altera_xcvr_fpll_vi::parameters::validate_gui_hssi_prot_mode                                                                        false   false           STRING    0       								NOVAL			{ "0:Basic" "1:PCIe Gen 1" "2:PCIe Gen 2" "3:PCIe Gen 3" "4:SDI_cascade" "5:OTN_cascade" "6:SDI_direct" "7:SATA TX" "8:OTN_direct" "9:SATA GEN3" "10:HDMI" }			 							true 																																																									"gui_fpll_mode == 2"       											NOVAL         NOVAL         	"General"     					"Protocol mode"                                     				::altera_xcvr_fpll_vi::parameters::upgrade_gui_hssi_prot_mode				"Governs the internal setting rules for the VCO. This parameter is not a preset. You must set all other parameters for your protocol."} \
      {prot_mode                               NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_prot_mode				    	  true    false           STRING    "basic_tx"      						NOVAL			NOVAL                           							  			  						true 																																																									false                      											NOVAL         NOVAL         	"General"		     			"Protocol mode"                                     				NOVAL				NOVAL       } \
	  \
	  {gui_refclk_switch                       NOVAL      0                0                NOVAL                         												  false   false           BOOLEAN   false                        			NOVAL			NOVAL                                               					  						true                     																																																				true                     											BOOLEAN       NOVAL         	"Clock Switchover"      		"Create a second input clock 'pll_refclk1'"                			NOVAL				"Turn on this parameter to have a backup clock attached to your FPLL that can switch with your original reference clock"} \
      {gui_refclk1_frequency                   NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_reference_clock1_frequency         false   false           FLOAT     100.0          							NOVAL			NOVAL                                        							  						gui_refclk_switch 																																																						true   					 											NOVAL         MHz           	"Clock Switchover"     			"Second Reference Clock Frequency"                   				NOVAL				"Specifies the second reference clock frequency for FPLL"} \
      {gui_switchover_mode                     NOVAL	   0				0				 NOVAL														                  false   false           STRING    "Automatic Switchover"  				NOVAL			{"Automatic Switchover" "Manual Switchover" "Automatic Switchover with Manual Override"}      	gui_refclk_switch                     	   																																																true                      											RADIO         NOVAL         	"Input Clock Switchover Mode"	"Switchover Mode"  									 				NOVAL				"Specifies how Input frequency switchover will be handled. Automatic Switchover will use built in circuitry to detect if one of your input clocks has stopped toggling and switch to the other. Manual Switchover will create an EXTSWITCH signal which can be used to manually switch the clock by asserting high for atleast 3 cycles.  Automatic Switchover with Manual Override will perform act as Automatic Switchover until the EXTSWITCH goes high, in which case it will switch and ignore any automatic switches as long as EXTSWITCH stays high"} \
      {gui_switchover_delay                    NOVAL      0                0                NOVAL                    													  false   false           INTEGER   0                        				NOVAL			{0 1 2 3 4 5 6 7}                                         					  					gui_refclk_switch                     																																																	true                      											NOVAL         NOVAL         	"Input Clock Switchover Mode"   "Switchover Delays"          			 			 				NOVAL				"Adds a specific amount of cycle delay to the Switchover Process."}\
      {gui_enable_active_clk                   NOVAL	   0				0				 NOVAL                                                                        false   false           BOOLEAN   false           						NOVAL			NOVAL                                       	 						  						gui_refclk_switch                         																																																true                      											BOOLEAN       NOVAL         	"Input Clock Switchover Mode"  	"Create an 'active_clk' signal to indicate the input clock in use"  NOVAL				"This parameter creates an output which indicates which input clock is currently in use by the PLL. Low indicates refclk, High indicates refclk1."} \
      {gui_enable_clk_bad                      NOVAL	   0				0				 NOVAL                                                                        false   false           BOOLEAN   false           						NOVAL			NOVAL                                       	 						  						gui_refclk_switch                         																																																true                      											BOOLEAN       NOVAL         	"Input Clock Switchover Mode"  	"Create a 'clkbad' signal for each of the input clocks"             NOVAL				"This parameter creates two CLKBAD outputs, one for each input clock. Low indicates the CLK is working, High indicates the CLK isn't working."} \
      {gui_enable_extswitch                    NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_gui_enable_extswitch               true    false           BOOLEAN   false           						NOVAL			NOVAL                                       	 						  						gui_refclk_switch                         																																																false                      											BOOLEAN       NOVAL         	"Input Clock Switchover Mode"  	NOVAL                  				 								NOVAL				NOVAL       } \
      \
      {enable_advanced_options                 NOVAL      0                0                NOVAL                                                               		  true    false           INTEGER   0                        				NOVAL			{ 0 1 }                                               					  						true                     																																																				false                     											NOVAL         NOVAL         	NOVAL                  			NOVAL                                     							NOVAL				NOVAL} \
      {enable_hip_options                      NOVAL      0                0                NOVAL                                                               		  true    false           INTEGER   0                        				NOVAL			{ 0 1 }                                               					  						true                     																																																				false                     											NOVAL         NOVAL         	NOVAL                  			NOVAL                                     							NOVAL				NOVAL} \
      {generate_docs                           NOVAL      0                0                NOVAL                                                               		  false   false           INTEGER   0                        				NOVAL			NOVAL                                                 					  						true                     																																																				true                      											BOOLEAN       NOVAL         	"Generation Options"   			"Generate parameter documentation file"             				NOVAL				"When enabled, generation will produce a .CSV file with descriptions of the IP parameters."} \
      {generate_add_hdl_instance_example       NOVAL	   0                0                NOVAL                                                               		  false   false           INTEGER   0                        				NOVAL			NOVAL                                                 					  						enable_advanced_options  																																																				enable_advanced_options   											BOOLEAN       NOVAL         	"Generation Options"   			"Generate '_hw.tcl' 'add_hdl_instance' example file"				NOVAL				"When enabled, generation will produce a file containing an example of how to use the '_hw.tcl' 'add_hdl_instance' API. The example will be correct for the current configuration of the IP."} \
      \
	  {gui_bw_sel                              NOVAL	   1				0				 NOVAL          false   false           STRING    "high"           						NOVAL			NOVAL  							  										  						true                     	   																																																			true                      											NOVAL         NOVAL         	"Settings" 						"Bandwidth"                                          				NOVAL				NOVAL       } \
     {temp_bw_sel                             NOVAL	   1				0				 ::altera_xcvr_fpll_vi::parameters::update_temp_bw_sel						  true    false           STRING    "high"           						NOVAL			NOVAL  							  										  						false                    	   																																																			false                     											NOVAL         NOVAL         	"Settings" 						"Bandwidth"                                          				NOVAL				NOVAL       } \
	  {cmu_fpll_pll_bw_mode                    NOVAL	   1				0				 ::altera_xcvr_fpll_vi::parameters::update_cmu_fpll_pll_bw_mode				  true    true            STRING    "high"           						NOVAL			NOVAL  							  										  						false                    	   																																																			false                     											NOVAL         NOVAL         	"Settings" 						"Bandwidth"                                          				NOVAL				NOVAL       } \
      {pll_cp_lf_3rd_pole_freq                 NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pll_cp_lf_3rd_pole_freq            true    false           STRING    "lf_3rd_pole_setting0"  				NOVAL			NOVAL  							  										  						false                    	   																																																			false                      											NOVAL         NOVAL         	NOVAL     						NOVAL                                                				NOVAL				NOVAL       } \
	  \
	  {gui_self_reset_enabled                  NOVAL	   0				0				 NOVAL																		  false   false           BOOLEAN   false									NOVAL			NOVAL                                                                                           true                                                                                                                  																													"gui_fpll_mode == 0"												NOVAL		  NOVAL				"Settings"						"PLL Auto Reset"                                                    NOVAL				"Automatically self-resets the PLL on loss of lock"} \
	  \
	  {gui_enable_low_f_support                  NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_low_f_support 		  true   false           BOOLEAN   false									NOVAL			NOVAL                                                                                           true                                                                                                                  																													false												NOVAL		  NOVAL				"General"						"Enable expanded reference clock range for low output frequency support"                                                    NOVAL				"Expands the lower range of the allowed reference clock frequencies"} \
	  \
	  {gui_is_downstream_cascaded_pll          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::validate_is_downstream_cascaded_pll       false   false           BOOLEAN   false									NOVAL			NOVAL                                                                                           true                                                                                                                  																													true																NOVAL		  NOVAL				"General"						"Enable downstream cascaded pll"                                                    NOVAL				"Specifies whether this fPLL is a downstream cascaded pll"} \
	  \
      {gui_enable_50G_support                  NOVAL	   0				0				 NOVAL																		  false   false           BOOLEAN   false									NOVAL			NOVAL                                                                                           true                                                                                                                  																													false												NOVAL		  NOVAL				"General"						"Enable support for 50G solution"                                                    NOVAL				"Enables support for 50G solution"} \
	  \
      {silicon_rev                             NOVAL      0                0                NOVAL                                                               		  false   false           BOOLEAN   false                    				NOVAL			NOVAL                                                 											true                     																																																				false                        										NOVAL         NOVAL         	"General"                      "Silicon revision ES"                                   				NOVAL				NOVAL} \
      {gui_silicon_rev                         NOVAL	   0                0                ::altera_xcvr_fpll_vi::parameters::update_silicon_rev           			  true    false           STRING    "20nm5es"         NOVAL          { "20nm5es" "20nm5es2" "20nm4es" "20nm4es2" "20nm5" "20nm4" "20nm3" "20nm2" "20nm1"}                           											true                     																																																				false                        										NOVAL         NOVAL         	NOVAL                          NOVAL                                                   				NOVAL				NOVAL} \
      \
	  {gui_reference_clock_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::validate_reference_clock_frequency        false   false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true                     	   																																																			"gui_fpll_mode == 0"	 											NOVAL         MHz           	"Reference Clock"  				"Reference clock frequency"                      					NOVAL				NOVAL       } \
	  {gui_desired_refclk_frequency            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::validate_gui_desired_refclk_frequency                                                                        false   false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true                     	   																																																			"!(gui_fpll_mode == 0)"	 											NOVAL         MHz           	"Reference Clock"  				"Desired reference clock frequency"                					::altera_xcvr_fpll_vi::parameters::upgrade_gui_desired_refclk_frequency				NOVAL       } \
	  {gui_actual_refclk_frequency             NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_refclk_frequency               false   false           STRING    100.0         							NOVAL			NOVAL                                        							  						true                     	   																																																			"!(gui_fpll_mode == 0)"	 											NOVAL         MHz           	"Reference Clock"  				"Actual reference clock frequency"                 					NOVAL				NOVAL       } \      
	  {full_actual_refclk_frequency            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_actual_refclk_frequency          true    false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true                     	   																																																			false					 											NOVAL         MHz           	"Reference Clock"  				"Actual reference clock frequency"                 					NOVAL				NOVAL       } \	  
	  {reference_clock_frequency               NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_reference_clock_frequency      	  true    false           STRING    "100.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"Reference Clock"  				"Reference clock frequency"                      					NOVAL				NOVAL       } \
      \
      {gui_operation_mode                      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_gui_operation_mode				  false   false           STRING    0		  								NOVAL			NOVAL				    																		true                     	   																																																			true																NOVAL         NOVAL         	"Feedback"  					"Operation mode"                                 					::altera_xcvr_fpll_vi::parameters::upgrade_gui_operation_mode				"Specifies the feedback operation mode for FPLL."} \
	  {compensation_mode                       NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_compensation_mode                  true    false           STRING    "direct"  								NOVAL			{ "direct" "normal" "fpll_bonding" "iqtxrxclk" }      											true                     	   																																																			false                      											NOVAL         NOVAL         	"Feedback"  					"Operation mode"                                 					NOVAL				"Specifies the operation mode for FPLL."} \
	  {feedback                                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_feedback                           true    false           STRING    "normal"  								NOVAL			{ "normal" "iqtxrxclk" "core_comp" }      				    									true                     	   																																																			false                      											NOVAL         NOVAL         	"Feedback"  					"Operation mode"                                 					NOVAL				"Specifies the operation mode for FPLL."} \
      {gui_enable_iqtxrxclk_mode               NOVAL	   0				0				 NOVAL         																  true    false           BOOLEAN   false           						NOVAL			NOVAL                                       	 						  						true                         																																																			false                      											BOOLEAN       NOVAL         	"Feedback"  					"Operation mode for IQTXRXCLK"       								NOVAL				NOVAL       } \
      {gui_iqtxrxclk_outclk_index              NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_iqtxrxclk_outclk_index       	  false   false           STRING    "0"  									NOVAL			{ 0 1 2 3 }      														  						true        							   																																																false					                     						NOVAL         NOVAL         	"Feedback"  					 "Specifies which core outclk to be used as feedback source"        NOVAL				"Specifies the feedback source for IQTXRXCLK operation mode."} \
      \
      {gui_refclk_cnt                          NOVAL      1                1                ::altera_xcvr_fpll_vi::parameters::update_gui_refclk_cnt              		  false   false           INTEGER   1                        				NOVAL			{ 1 2 3 4 5 }                                         					  						!enable_cascade_in                     																																																				"gui_fpll_mode == 0 || gui_fpll_mode == 2"       					NOVAL         NOVAL         	"Reference Clock"              	"Number of PLL reference clocks"          							NOVAL				"Specifies the number of input reference clocks for the FPLL."}\
      {gui_refclk_index                        NOVAL      1                0                ::altera_xcvr_fpll_vi::parameters::update_refclk_index           			  false   false           INTEGER   0                        				NOVAL			NOVAL                                                 					  						true                     																																																				"gui_fpll_mode == 0 || gui_fpll_mode == 2"       					NOVAL         NOVAL         	"Reference Clock"              	"Selected reference clock source"         							NOVAL				"Specifies the initially selected reference clock input to the FPLL."}\
      \
      {gui_enable_fractional                   NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_fractional			  false   false           BOOLEAN   false         							!enable_cascade_in			NOVAL                                        							  						true  				   	   																																																				true					  											NOVAL         NOVAL         	"General"  						"Enable fractional mode"                          					NOVAL				"Enables the fractional frequency synthesis mode. This enables the PLL to output frequencies which are not integral multiples of the input reference clock.  In SDI direct mode when this option is enabled, pll_locked port is not available.  The user can create external lock detector using clklow and fref clock ports"} \
      {gui_enable_manual_hssi_counters         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_manual_hssi_counters  false   false           BOOLEAN   false           						NOVAL			NOVAL                                        							  						true                     	   																																																			"gui_fpll_mode == 2"       											BOOLEAN       NOVAL         	"General"  						"Enable manual counter configuration"           				    NOVAL				 "Selecting this option allows you to manually specify M,N, C and L counter values."       } \
      {enable_cascade_in                       NOVAL       0                0                NOVAL                                                                          true    false           INTEGER   0                                     NOVAL                NOVAL                                                                                                                                  "gui_fpll_mode == 2 && (gui_hssi_prot_mode == 4 || gui_hssi_prot_mode == 5)"        !is_c10                                                                 BOOLEAN       NOVAL             "General"                               "Enable ATX to FPLL cascade clock input port"                             NOVAL               "Enables the ATX to FPLL cascade clock input port. This port should only be used to drive the FPLL from the cascaded output clock port of an ATX PLL."}\
      {enable_analog_resets                    NOVAL	   0				0				 NOVAL                                               				    	  false   true            INTEGER   0              						    NOVAL			NOVAL                                            							  			  		enable_advanced_options																																															                        enable_advanced_options    											BOOLEAN       NOVAL         	"General"   		            "Enable pll_powerdown and mcgb_rst connections"                     NOVAL				"INTERNAL USE ONLY. When selected, the pll_powerdown and mcgb_rst input ports will be connected internally in the IP. Otherwise and by default these ports are made present but have no affect when asserted."}\
      \
      {gui_enable_pld_cal_busy_port            NOVAL      1                1                NOVAL                                                               		  false   false           INTEGER   1               						NOVAL			{ 0 1 }                                               					  						false                    																																																				false                     											BOOLEAN       NOVAL         	NOVAL                  			"enable_pld_fpll_cal_busy_port"                     				NOVAL				NOVAL		 } \
      {gui_enable_hip_cal_done_port            NOVAL      1                1                NOVAL                                                               		  false   false           INTEGER   0               						NOVAL			NOVAL                                               					  						enable_hip_options	 																																																					enable_hip_options        											BOOLEAN       NOVAL         	"Ports"                       	"Enable calibration status ports for HIP"                     		NOVAL				"Enables calibration status port from PLL and Master CGB(if enabled) for HIP"		 } \
      {gui_hip_cal_en                          NOVAL	   1				0				 NOVAL                                                                        false   false           INTEGER   0       							    NOVAL			NOVAL			  												                                enable_hip_options 																																																			            enable_hip_options                      							BOOLEAN       NOVAL         	"Ports"     		            "Enable PCIe hard IP calibration"                                   NOVAL				 "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels"       } \
      {hip_cal_en                              NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hip_cal_en				    	  true    true            STRING    "disable"      						    NOVAL			{ "enable" "disable" }                           							  			  		enable_hip_options 																																																			            false                      											NOVAL         NOVAL         	"Ports"     		            NOVAL                                     				            NOVAL				 "INTERNAL USE ONLY. Enabling this parameter prioritizes the calibration for PCIe hard IP channels"       } \
      \
      {gui_enable_cascade_out                  NOVAL	   0				0				 NOVAL														                  false   false           BOOLEAN   false           						NOVAL			NOVAL                                       	 						  						true                         																																																			"gui_fpll_mode == 0"       											BOOLEAN       NOVAL         	"Ports"  						"Enable cascade clock output port (FPLL to FPLL cascading)"         NOVAL				 "Enables the cascade clock output port for FPLL to FPLL cascading"       } \
      {gui_cascade_outclk_index                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_cascade_outclk_index               false   false           STRING    "0"  									NOVAL			{ 0 1 2 3 }      														  						gui_enable_cascade_out        							   																																												"gui_fpll_mode == 0"       											NOVAL         NOVAL         	"Ports"  					    "Specifies which core outclk to be used as cascading source"        NOVAL				 "Specifies the cascading source for FPLL to FPLL cascading."} \
      \
      {gui_enable_dps                          NOVAL       0                0                NOVAL                                                                        false   false           BOOLEAN   false                                   NOVAL           NOVAL                                                                                           true                                                                                                                                                                                                                                    "gui_fpll_mode == 0"                                                  BOOLEAN       NOVAL             "Ports"                       "Enable access to dynamic phase shift ports"                          NOVAL                "Enables access to dynamic phase shift ports. When this option is selected, phase_reset, phase_en, updn, cntsel\[3:0\], reconfig_avmm,phase_done ports are enabled." } \
      \
      {gui_enable_manual_config                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_manual_config         false   false           BOOLEAN   false           						NOVAL			NOVAL                                        							  						true                     	   																																																			"gui_fpll_mode == 0"       											BOOLEAN       NOVAL         	"General"  						"Enable physical output clock parameters"           				NOVAL				 "Selecting this option allows you to manually specify M,N and C counter values."       } \
      \
      {gui_hssi_calc_output_clock_frequency    NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_gui_hssi_calc_output_clock_frequency true  false           FLOAT     1250.0          						NOVAL			NOVAL                                        							  						true 																																																									"gui_enable_manual_hssi_counters"				 					NOVAL         MHz           	"Transceiver Usage"     		"PLL output frequency"                              				NOVAL				 NOVAL       } \
      {gui_hssi_output_clock_frequency         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_hssi_output_clock_frequency     false   false           FLOAT     1250.0          						NOVAL			NOVAL                                        							  						true 																																																									"!gui_enable_manual_config&&!gui_enable_manual_hssi_counters"  		NOVAL         MHz           	"Transceiver Usage"     		"PLL output frequency"                              				NOVAL				 NOVAL       } \
	  {hssi_output_clock_frequency             NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_output_clock_frequency    	  true    false           STRING    "1250.0 MHz"    						NOVAL			NOVAL                                        							  						true 																																																									false      				 											NOVAL         MHz           	"Transceiver Usage"     		"PLL output frequency"                      	 					NOVAL				 NOVAL       } \                                                                                                                 																																																							      
      {gui_pll_datarate                        NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_gui_pll_datarate                   true    false           FLOAT     0										NOVAL			NOVAL  							  										  						true                   	   																																																				true                     											NOVAL	  	  Mbps   	        "Transceiver Usage"     		"PLL Datarate"         	     										NOVAL				NOVAL       } \	  
      {pll_datarate                            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pll_datarate                   	  true    false           STRING    "0 Mbps"								NOVAL			NOVAL  							  										  						false                   	   																																																			false                     											NOVAL	  	  NOVAL 	        "Transceiver Usage"     		"PLL Datarate"         	     										NOVAL				NOVAL       } \	  
	  \
      {gui_pll_m_counter                       NOVAL	   1				0				 ::altera_xcvr_fpll_vi::parameters::validate_gui_pll_m_counter		 		  false   false           INTEGER   1             							NOVAL			NOVAL	 																  						true	   																																																								gui_enable_manual_config 											NOVAL 		  NOVAL  			"Core Usage"  					"Multiply factor (M-counter)"                       				NOVAL				"Specifies the multiply factor (M counter)"} \
	  {gui_pll_n_counter                       NOVAL	   1				0				 ::altera_xcvr_fpll_vi::parameters::validate_gui_pll_n_counter                false   false           INTEGER   1             							NOVAL			NOVAL 																  	  						true	   																																																								gui_enable_manual_config 											NOVAL 		  NOVAL  			"Core Usage"  					"Divide factor (N-counter)"                        					NOVAL				"Specifies the divide factor (N counter)"} \	  
	  {gui_fractional_x                        NOVAL	   1				0				 NOVAL																 		  false   false           INTEGER   32             							NOVAL			NOVAL	 																  						false	   																																																								false					 											NOVAL 		  NOVAL  			"Core Usage"  					"Fractional factor (x)"                       				 		NOVAL				"Specifies the fractional x factor (x counter)"} \
	  {gui_pll_dsm_fractional_division         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_pll_dsm_fractional_division     false   false           LONG  	1             							NOVAL			NOVAL 																	  						true   																																																									"gui_enable_manual_config && gui_enable_fractional"					NOVAL 		  NOVAL  			"Core Usage"  					"Fractional multiply factor (K)"                    				NOVAL				"Specifies the fractional multiply factor (K counter)"} \
      {gui_fractional_f                        NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_gui_fractional_f	     			  true    false           FLOAT  	1             							NOVAL			NOVAL 																	  						true   																																																									"gui_enable_manual_config && gui_enable_fractional"					NOVAL 		  NOVAL  			"Core Usage"  					"Fractional factor (F)"			                    				NOVAL				"Specifies the fractional F factor (F counter)"} \
	  {gui_pll_c_counter_0                     NOVAL	   1				0				 NOVAL                                                                        false   false           INTEGER   1             							NOVAL			{1:256} 																  						true 	   																																																								"gui_number_of_output_clocks >= 1 && gui_enable_manual_config" 	 		NOVAL 		  NOVAL  			"outclk0"  			    		"Divide factor (C-counter 0)"                        			NOVAL			    "Specifies the divide factor (C-counter 0)"} \
	  {gui_pll_c_counter_1                     NOVAL	   1				0				 NOVAL                                                                        false   false           INTEGER   1             							NOVAL			{1:256} 																  						true																																																									"gui_number_of_output_clocks >= 2 && gui_enable_manual_config" 	 		NOVAL 		  NOVAL	  			"outclk1"  						"Divide factor (C-counter 1)"                        			NOVAL				"Specifies the divide factor (C-counter 1)"} \
	  {gui_pll_c_counter_2                     NOVAL	   1				0				 NOVAL                                                                        false   false           INTEGER   1             							NOVAL			{1:256} 																  						true 	 																																																								"gui_number_of_output_clocks >= 3 && gui_enable_manual_config" 	    	NOVAL 		  NOVAL  			"outclk2"  						"Divide factor (C-counter 2)"                        			NOVAL				"Specifies the divide factor (C-counter 2)"} \     	  
	  {gui_pll_c_counter_3                     NOVAL	   1				0				 NOVAL                                                                        false   false           INTEGER   1             							NOVAL			{1:256} 																  						true 	 																																																								"gui_number_of_output_clocks == 4 && gui_enable_manual_config" 	 		NOVAL 		  NOVAL  			"outclk3"  						"Divide factor (C-counter 3)"                        			NOVAL				"Specifies the divide factor (C-counter 3)"} \
	  \
      {gui_number_of_output_clocks             NOVAL	   0				0				 NOVAL                                                                        false   false           STRING    "1"  									NOVAL			{ 1 2 3 4 }      														  						true        							   																																																true                      											NOVAL         NOVAL         	"Core Usage"  					"Number of clocks"                                  				NOVAL				"Specifies the number of output clocks required in the FPLL design."} \
      {gui_enable_phase_alignment              NOVAL	   0				0				 NOVAL                                                                        false   false           BOOLEAN   false           						NOVAL			NOVAL                                       	 						  						true                         																																																			true                     											BOOLEAN       NOVAL         	"Core Usage"  					"Enable phase alignment"											NOVAL				"Enables phase alignment."       } \
      {phase_alignment_check_var               NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_enable_phase_alignment          false   false           BOOLEAN   false           						NOVAL			NOVAL                                       	 						  						true                         																																																			false                     											BOOLEAN       NOVAL         	"Core Usage frequency check variable"  	"Core mode phase alignment frequency check variable"		NOVAL				"Variable used for frequency check in core mode phase alignment."       } \
      {gui_pfd_frequency                       NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_gui_pfd_frequency    			  true    false           STRING      100.0								    NOVAL			NOVAL  							  										  						true                   	   																																																		        true                                                             	NOVAL	  	  MHz    	        "Core Usage"     		        "PFD Frequency"         	     							    NOVAL				        "Provides the FPD Frequency to populate counter1 fields when core mode phase alignment is used."       } \	  
	  \
      {core_vco_frequency_basic                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_vco_frequency_basic			  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"VCO Frequency"                      								NOVAL				NOVAL       } \                                                                                                          																																																													
      {core_vco_frequency_adv                  NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_vco_frequency_adv  			  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"VCO Frequency"                      								NOVAL				NOVAL       } \
	  {hssi_vco_frequency                      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_vco_frequency      			  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"VCO Frequency"                      								NOVAL				NOVAL       } \                                                                                                          																																																													
      {hssi_cascade_vco_frequency              NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_vco_frequency      	  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"VCO Frequency"                      								NOVAL				NOVAL       } \
	  {vco_frequency                           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_vco_frequency      				  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"VCO Frequency"                      								NOVAL				NOVAL       } \                                                                                                          																																																													
	  \
      {core_pfd_frequency                      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_pfd_frequency      			  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"PFD Frequency"                      								NOVAL				NOVAL       } \                                                                                                          																																																													
      {hssi_pfd_frequency                      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_pfd_frequency      			  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"PFD Frequency"                      								NOVAL				NOVAL       } \                                                                                                          																																																													
      {hssi_cascade_pfd_frequency              NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_pfd_frequency      	  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"PFD Frequency"                      								NOVAL				NOVAL       } \
	  {pfd_frequency                           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pfd_frequency      				  true    false           STRING    "300.0 MHz"     						NOVAL			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         MHz           	"General"  						"PFD Frequency"                      								NOVAL				NOVAL       } \  
	  \
      {gui_desired_outclk0_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk0_frequency       false   false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true        																																																							"gui_number_of_output_clocks >= 1 && !gui_enable_manual_config"   		NOVAL         MHz           	"outclk0"  			    		"Desired frequency"                      			 			NOVAL					"Specifies requested value for output clock frequency"} \
      {gui_actual_outclk0_frequency            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_outclk0_frequency_values   	  false   false           STRING    "100.0"  								NOVAL			NOVAL     											  					  						true        																																																							"gui_number_of_output_clocks >= 1"   									NOVAL         MHz	         	"outclk0"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
	  {full_actual_outclk0_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk0_frequency_value	   	  true	  false           STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true        																																																							false								   									NOVAL         MHz	         	"outclk0"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
      {output_clock_frequency_0                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_0   	 	  true    false			  STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true        																																																							false							    									NOVAL         NOVAL         	"outclk0"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
      {gui_outclk0_phase_shift_unit            NOVAL	   0				0				 NOVAL           															  false   false           STRING    0  										NOVAL			{ "0:ps" "1:degrees" }    													  						true        																																																							"gui_number_of_output_clocks >= 1"   									NOVAL         NOVAL         	"outclk0"  			    		"Phase shift units"                                  			::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk0_phase_shift_unit					"Specifies phase shift in degrees or picoseconds"} \
      {gui_outclk0_desired_phase_shift         NOVAL	   0				0				 NOVAL        																  false   false           FLOAT   	0.0    									NOVAL			NOVAL     													  			  						true        																																																							"gui_number_of_output_clocks >= 1"   									NOVAL         "ps / degrees"    "outclk0"  			    		"Phase shift"                                  		 			NOVAL					"Specifies requested value for phase shift"} \
      {gui_outclk0_actual_phase_shift          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_0_values		 	  false   false           STRING    "0.0" 									NOVAL			NOVAL     													  			  						true        																																																							"gui_number_of_output_clocks >= 1 && gui_outclk0_phase_shift_unit == 0" NOVAL         ps			   	"outclk0"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
	  {gui_outclk0_actual_phase_shift_deg      NOVAL	   0				0				 NOVAL																	 	  false   false           STRING    "0.0" 									NOVAL			NOVAL     													  			  						true        																																																							"gui_number_of_output_clocks >= 1 && gui_outclk0_phase_shift_unit == 1"	NOVAL         degrees			"outclk0"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
	  {full_outclk0_actual_phase_shift         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk0_phase_shift_value	 	  true    false           STRING    "0.0" 									NOVAL			NOVAL     													  			  						true        																																																							false								   									NOVAL         NOVAL			   	"outclk0"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
	  {phase_shift_0                           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_phase_shift_0                  	  true    false           STRING    "0 ps"  								NOVAL			NOVAL     													  			  						true        																																																							false   																NOVAL         NOVAL         	"outclk0"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
      \
      {gui_desired_outclk1_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk1_frequency       false   false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true																																																									"gui_number_of_output_clocks >= 2 && !gui_enable_manual_config"   		NOVAL         MHz           	"outclk1"  			    		"Desired frequency"                      			 			NOVAL					"Specifies requested value for output clock frequency"} \
      {gui_actual_outclk1_frequency            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_outclk1_frequency_values   	  false   false           STRING    "100.0"									NOVAL			NOVAL     											  					  						true    																																																								"gui_number_of_output_clocks >= 2"  									NOVAL         MHz	         	"outclk1"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
	  {full_actual_outclk1_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk1_frequency_value	   	  true	  false           STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true        																																																							false								   									NOVAL         MHz	         	"outclk1"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
	  {output_clock_frequency_1                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_1   	 	  true    false			  STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true     	 																																																							false							    									NOVAL         NOVAL         	"outclk1"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
      {gui_outclk1_phase_shift_unit            NOVAL	   0				0				 NOVAL                                                                        false   false           STRING    0  										NOVAL			{ "0:ps" "1:degrees" }    													  						true    																																																								"gui_number_of_output_clocks >= 2"  									NOVAL         NOVAL         	"outclk1"  			    		"Phase shift units"                                  			::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk1_phase_shift_unit					"Specifies phase shift in degrees or picoseconds"} \
      {gui_outclk1_desired_phase_shift         NOVAL	   0				0				 NOVAL                                                                        false   false           INTEGER   0    									NOVAL			NOVAL     													  			  						!gui_enable_phase_alignment    																																																								"gui_number_of_output_clocks >= 2"  									NOVAL         "ps / degrees"    "outclk1"  			    		"Phase shift"                                  		 			NOVAL					"Specifies requested value for phase shift"} \
      {gui_outclk1_actual_phase_shift          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_1_values		 	  false   false           STRING    "0.0"  									NOVAL			NOVAL     													  			  						true    																																																								"gui_number_of_output_clocks >= 2 && gui_outclk1_phase_shift_unit == 0" NOVAL         NOVAL         	"outclk1"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
      {gui_outclk1_actual_phase_shift_deg      NOVAL	   0				0				 NOVAL																	 	  false   false           STRING    "0.0"	 								NOVAL			NOVAL     														  			  					true        																																																							"gui_number_of_output_clocks >= 2 && gui_outclk1_phase_shift_unit == 1"	NOVAL         NOVAL			   	"outclk1"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \      
	  {full_outclk1_actual_phase_shift         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk1_phase_shift_value	 	  true    false           STRING    "0.0" 									NOVAL			NOVAL     													  			  						true        																																																							false								   									NOVAL         NOVAL			   	"outclk1"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \	  
	  {phase_shift_1                           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_phase_shift_1                  	  true    false           STRING    "0 ps"  								NOVAL			NOVAL     													  			  						true      																																																								false   																NOVAL         NOVAL         	"outclk1"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
      \
      {gui_desired_outclk2_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk2_frequency       false   false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true      																																																								"gui_number_of_output_clocks >= 3 && !gui_enable_manual_config"     	NOVAL         MHz           	"outclk2"  			    		"Desired frequency"                      			 			NOVAL					"Specifies requested value for output clock frequency"} \
      {gui_actual_outclk2_frequency            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_outclk2_frequency_values   	  false   false           STRING    "100.0"									NOVAL			NOVAL     											  					  						true      																																																								"gui_number_of_output_clocks >= 3"  							 		NOVAL         MHz	         	"outclk2"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
	  {full_actual_outclk2_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk2_frequency_value	   	  true	  false           STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true        																																																							false								   									NOVAL         MHz	         	"outclk2"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
	  {output_clock_frequency_2                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_2   	 	  true    false			  STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true      																																																								false							    									NOVAL         NOVAL         	"outclk2"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
      {gui_outclk2_phase_shift_unit            NOVAL	   0				0				 NOVAL                                                                        false   false           STRING    0  										NOVAL			{ "0:ps" "1:degrees" }    													  						true      																																																								"gui_number_of_output_clocks >= 3"  							 		NOVAL         NOVAL         	"outclk2"  			    		"Phase shift units"                                  			::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk2_phase_shift_unit					"Specifies phase shift in degrees or picoseconds"} \
      {gui_outclk2_desired_phase_shift         NOVAL	   0				0				 NOVAL                                                                        false   false           INTEGER   0    									NOVAL			NOVAL     													  			  						true      																																																								"gui_number_of_output_clocks >= 3"  							 		NOVAL         "ps / degrees"    "outclk2"  			    		"Phase shift"                                  		 			NOVAL					"Specifies requested value for phase shift"} \
      {gui_outclk2_actual_phase_shift          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_2_values		 	  false   false           STRING    "0 ps"  								NOVAL			NOVAL     													  			  						true      																																																								"gui_number_of_output_clocks >= 3 && gui_outclk2_phase_shift_unit == 0" NOVAL         NOVAL         	"outclk2"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
      {gui_outclk2_actual_phase_shift_deg      NOVAL	   0				0				 NOVAL																	 	  false   false           STRING    "0 deg" 								NOVAL			NOVAL     													  			  						true        																																																							"gui_number_of_output_clocks >= 3 && gui_outclk2_phase_shift_unit == 1"	NOVAL         NOVAL			   	"outclk2"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \      
	  {full_outclk2_actual_phase_shift         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk2_phase_shift_value	 	  true    false           STRING    "0.0" 									NOVAL			NOVAL     													  			  						true        																																																							false								   									NOVAL         NOVAL			   	"outclk2"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \	  	  
	  {phase_shift_2                           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_phase_shift_2                  	  true    false           STRING    "0 ps"  								NOVAL			NOVAL     													  			  						true      																																																								false   																NOVAL         NOVAL         	"outclk2"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
      \
      {gui_desired_outclk3_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk3_frequency       false   false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true    																																																								"gui_number_of_output_clocks == 4 && !gui_enable_manual_config"   		NOVAL         MHz           	"outclk3"  			    		"Desired frequency"                      			 			NOVAL					"Specifies requested value for output clock frequency"} \
      {gui_actual_outclk3_frequency            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_outclk3_frequency_values   	  false   false           STRING    "100.0"									NOVAL			NOVAL     											  					  						true      																																																								"gui_number_of_output_clocks == 4"   									NOVAL         MHz 	        	"outclk3"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
	  {full_actual_outclk3_frequency           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk3_frequency_value	   	  true	  false           STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true        																																																							false								   									NOVAL         MHz	         	"outclk3"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
	  {output_clock_frequency_3                NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_3   	 	  true    false			  STRING    "100.0 MHz"  							NOVAL			NOVAL     											  					  						true      																																																								false   																NOVAL         NOVAL         	"outclk3"  			    		"Actual frequency"                                   			NOVAL					"Specifies actual value for output clock frequency"} \
      {gui_outclk3_phase_shift_unit            NOVAL	   0				0				 NOVAL                                                                        false   false           STRING    0  										NOVAL			{ "0:ps" "1:degrees" }    													  						true      																																																								"gui_number_of_output_clocks == 4"   									NOVAL         NOVAL         	"outclk3"  			    		"Phase shift units"                                  			::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk3_phase_shift_unit					"Specifies phase shift in degrees or picoseconds"} \
      {gui_outclk3_desired_phase_shift         NOVAL	   0				0				 NOVAL                                                                        false   false           INTEGER   0    									NOVAL			NOVAL     													  			  						true      																																																								"gui_number_of_output_clocks == 4"   									NOVAL         "ps / degrees"    "outclk3"  			    		"Phase shift"                                  		 			NOVAL					"Specifies requested value for phase shift"} \
      {gui_outclk3_actual_phase_shift          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_3_values		 	  false   false           STRING    "0.0"  									NOVAL			NOVAL     													  			  						true      																																																								"gui_number_of_output_clocks == 4 && gui_outclk3_phase_shift_unit == 0" NOVAL         NOVAL         	"outclk3"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
      {gui_outclk3_actual_phase_shift_deg      NOVAL	   0				0				 NOVAL																	 	  false   false           STRING    "0.0" 									NOVAL			NOVAL     													  			  						true        																																																							"gui_number_of_output_clocks == 4 && gui_outclk3_phase_shift_unit == 1" NOVAL         NOVAL			   	"outclk3"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \      
	  {full_outclk3_actual_phase_shift         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::set_full_outclk3_phase_shift_value	 	  true    false           STRING    "0.0" 									NOVAL			NOVAL     													  			  						true        																																																							false								  									NOVAL         NOVAL			   	"outclk3"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \	  	  	  
	  {phase_shift_3                           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_phase_shift_3                  	  true    false           STRING    "0 ps"  								NOVAL			NOVAL     													  			  						true      																																																								false   																NOVAL         NOVAL         	"outclk3"  			    		"Actual phase shift"                                 			NOVAL					"Specifies actual value for phase shift"} \
      \
      {gui_desired_hssi_cascade_frequency      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::check_gui_desired_hssi_cascade_frequency  false   false           FLOAT     100.0         							NOVAL			NOVAL                                        							  						true    																																																								true   																NOVAL         MHz           	"Cascade Usage"  			  	"Desired frequency"                      			 				::altera_xcvr_fpll_vi::parameters::upgrade_gui_desired_hssi_cascade_frequency				"Specifies the requested value for output clock frequency"} \
      \
      {refclk_select0                          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_refclk_select0                	  true    false           STRING    "lvpecl"  								NOVAL			NOVAL     													  			  						false        				 																																																			false   															NOVAL         NOVAL         	"General"  						"refclk_select0"                                   	 				NOVAL				NOVAL} \
      {refclk_select1                          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_refclk_select1                	  true    false           STRING    "ref_iqclk0"  							NOVAL			NOVAL     													  			  						false        				 																																																			false   															NOVAL         NOVAL         	"General"  						"refclk_select1"                                   	 				NOVAL				NOVAL} \
      \
      {core_c_counter_0                        NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0"                              	     				NOVAL				NOVAL} \
      {core_c_counter_0_in_src                 NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_in_src"                       	     				NOVAL				NOVAL} \
      {core_c_counter_0_ph_mux_prst            NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_ph_mux_prst   	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {core_c_counter_0_prst                   NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_prst"                         	     				NOVAL				NOVAL} \
      {core_c_counter_0_coarse_dly             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_coarse_dly"                   	     				NOVAL				NOVAL} \
      {core_c_counter_0_fine_dly               NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_fine_dly"                     	     				NOVAL				NOVAL} \
      {core_c_counter_1                        NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1"                              	     				NOVAL				NOVAL} \
      {core_c_counter_1_in_src                 NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_in_src"                       	     				NOVAL				NOVAL} \
      {core_c_counter_1_ph_mux_prst            NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_ph_mux_prst   	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {core_c_counter_1_prst                   NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_prst"                         	     				NOVAL				NOVAL} \
      {core_c_counter_1_coarse_dly             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_coarse_dly"                   	     				NOVAL				NOVAL} \
      {core_c_counter_1_fine_dly               NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_fine_dly"                     	     				NOVAL				NOVAL} \
      {core_c_counter_2                        NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2"                              	     				NOVAL				NOVAL} \
      {core_c_counter_2_in_src                 NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_in_src"                       	     				NOVAL				NOVAL} \
      {core_c_counter_2_ph_mux_prst            NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_ph_mux_prst   	  true    false           INTEGER   1 										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {core_c_counter_2_prst                   NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_prst"                         	     				NOVAL				NOVAL} \
      {core_c_counter_2_coarse_dly             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_coarse_dly"                   	     				NOVAL				NOVAL} \
      {core_c_counter_2_fine_dly               NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_fine_dly"                     	     				NOVAL				NOVAL} \
      {core_c_counter_3                        NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3"                              	     				NOVAL				NOVAL} \
      {core_c_counter_3_in_src                 NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_in_src"                       	     				NOVAL				NOVAL} \
      {core_c_counter_3_ph_mux_prst            NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_ph_mux_prst   	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {core_c_counter_3_prst                   NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_prst"                         	     				NOVAL				NOVAL} \
      {core_c_counter_3_coarse_dly             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_coarse_dly"                   	     				NOVAL				NOVAL} \
      {core_c_counter_3_fine_dly               NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_fine_dly"                     	     				NOVAL				NOVAL} \
	  \
      {hssi_l_counter                          NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter           		  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0"                              	     				NOVAL				NOVAL} \
      {hssi_l_counter_in_src                   NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_in_src       	  	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_in_src"                       	     				NOVAL				NOVAL} \
      {hssi_l_counter_ph_mux_prst              NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_ph_mux_prst  	  	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_ph_mux_prst"                  	     				NOVAL				NOVAL} \
	  {hssi_l_counter_bypass                   NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_bypass			  true    false           STRING    "false"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_l_counter_bypass"                    			 				NOVAL				NOVAL} \
      {hssi_l_counter_enable                   NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_enable			  true    false           STRING    "true"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_l_counter_enable"                    			 				NOVAL				NOVAL} \
	  \
      {hssi_pcie_c_counter_0                   NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0              true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0"                              	     				NOVAL				NOVAL} \
      {hssi_pcie_c_counter_0_in_src            NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_in_src       true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_in_src"                       	     				NOVAL				NOVAL} \
      {hssi_pcie_c_counter_0_ph_mux_prst       NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_ph_mux_prst  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {hssi_pcie_c_counter_0_prst              NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_prst         true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_prst"                         	     				NOVAL				NOVAL} \
      {hssi_pcie_c_counter_0_coarse_dly        NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_coarse_dly   true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_coarse_dly"                   	     				NOVAL				NOVAL} \
      {hssi_pcie_c_counter_0_fine_dly          NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_fine_dly     true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_fine_dly"                     	     				NOVAL				NOVAL} \
	  \
      {hssi_cascade_c_counter                  NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter               true    false           INTEGER   1  									NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0"                              	     			    NOVAL				NOVAL} \
      {hssi_cascade_c_counter_in_src           NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_in_src        true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_in_src"                       	     				NOVAL				NOVAL} \
      {hssi_cascade_c_counter_ph_mux_prst      NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_ph_mux_prst   true    false           INTEGER   1  									NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_ph_mux_prst"                  	     			    NOVAL				NOVAL} \
      {hssi_cascade_c_counter_prst             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_prst          true    false           INTEGER   1  									NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_prst"                         	     			    NOVAL				NOVAL} \
      {hssi_cascade_c_counter_coarse_dly       NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_coarse_dly    true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_coarse_dly"                   	     				NOVAL				NOVAL} \
      {hssi_cascade_c_counter_fine_dly         NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_fine_dly      true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_fine_dly"                     	     				NOVAL				NOVAL} \
      \
      {pll_m_counter_in_src                    NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_in_src               true    false           STRING    "m_cnt_in_src_ph_mux_clk"               NOVAL           NOVAL                                                                                           false                                                                                                                                                                                                                                   false                                                               NOVAL         NOVAL             "General"                       "pll_m_counter_in_src"                                              NOVAL               NOVAL} \
      {pll_c_counter_0                         NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0"                              	     				NOVAL				NOVAL} \
      {pll_c_counter_0_in_src                  NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_in_src"                       	     				NOVAL				NOVAL} \
      {pll_c_counter_0_ph_mux_prst             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_ph_mux_prst   	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {pll_c_counter_0_prst                    NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_prst"                         	     				NOVAL				NOVAL} \
      {pll_c_counter_0_coarse_dly              NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_coarse_dly"                   	     				NOVAL				NOVAL} \
      {pll_c_counter_0_fine_dly                NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_0_fine_dly"                     	     				NOVAL				NOVAL} \
      {pll_c_counter_1                         NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1"                              	     				NOVAL				NOVAL} \
      {pll_c_counter_1_in_src                  NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_in_src"                       	     				NOVAL				NOVAL} \
      {pll_c_counter_1_ph_mux_prst             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_ph_mux_prst   	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {pll_c_counter_1_prst                    NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_prst"                         	     				NOVAL				NOVAL} \
      {pll_c_counter_1_coarse_dly              NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_coarse_dly"                   	     				NOVAL				NOVAL} \
      {pll_c_counter_1_fine_dly                NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_1_fine_dly"                     	     				NOVAL				NOVAL} \
      {pll_c_counter_2                         NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2"                              	     				NOVAL				NOVAL} \
      {pll_c_counter_2_in_src                  NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_in_src"                       	     				NOVAL				NOVAL} \
      {pll_c_counter_2_ph_mux_prst             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_ph_mux_prst   	  true    false           INTEGER   1 										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {pll_c_counter_2_prst                    NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_prst"                         	     				NOVAL				NOVAL} \
      {pll_c_counter_2_coarse_dly              NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_coarse_dly"                   	     				NOVAL				NOVAL} \
      {pll_c_counter_2_fine_dly                NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_2_fine_dly"                     	     				NOVAL				NOVAL} \
      {pll_c_counter_3                         NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3               	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3"                              	     				NOVAL				NOVAL} \
      {pll_c_counter_3_in_src                  NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_in_src        	  true    false           STRING    "m_cnt_in_src_ph_mux_clk"   			NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_in_src"                       	     				NOVAL				NOVAL} \
      {pll_c_counter_3_ph_mux_prst             NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_ph_mux_prst   	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_ph_mux_prst"                  	     				NOVAL				NOVAL} \
      {pll_c_counter_3_prst                    NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_prst          	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_prst"                         	     				NOVAL				NOVAL} \
      {pll_c_counter_3_coarse_dly              NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_coarse_dly    	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_coarse_dly"                   	     				NOVAL				NOVAL} \
      {pll_c_counter_3_fine_dly                NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_fine_dly      	  true    false           STRING    "0 ps"   								NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_c_counter_3_fine_dly"                     	     				NOVAL				NOVAL} \
	  \
      {pll_iqclk_mux_sel                       NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_iqclk_mux_sel        		  true    false           STRING    "power_down"   							NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_iqclk_mux_sel"                          			 			NOVAL				NOVAL} \
	  \
      {pll_l_counter                           NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_l_counter                 	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_l_counter"                                      				NOVAL				NOVAL} \
	  \
	  {core_actual_using_fractional            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_actual_using_fractional		  true    false           BOOLEAN   false         							NOVAL			NOVAL                                        							  						false  				   	   																																																				false                      											NOVAL         NOVAL         	"General"  						"Enable fractional mode"                          					NOVAL				NOVAL} \
      {hssi_actual_using_fractional            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_actual_using_fractional		  true    false           BOOLEAN   false         							NOVAL			NOVAL                                        							  						false  				   	   																																																				false                      											NOVAL         NOVAL         	"General"  						"Enable fractional mode"                          					NOVAL				NOVAL} \
      {hssi_cascade_actual_using_fractional    NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_actual_using_fractional	true  false           BOOLEAN   false         							NOVAL			NOVAL                                        							  						false  				   	   																																																				false                      											NOVAL         NOVAL         	"General"  						"Enable fractional mode"                          					NOVAL				NOVAL} \
      {pll_actual_using_fractional             NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pll_actual_using_fractional		  true    false           BOOLEAN   false         							NOVAL			NOVAL                                        							  						false  				   	   																																																				false                      											NOVAL         NOVAL         	"General"  						"Enable fractional mode"                          					NOVAL				NOVAL} \
	  \
      {core_dsm_fractional_division            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_dsm_fractional_division       true    false           LONG  	 0             							NOVAL			{0:4294967296} 															  						false	   																																																								false																NOVAL 		  NOVAL  			"General"  						"pll_dsm_fractional_division"                     	 				NOVAL				NOVAL} \
      {hssi_dsm_fractional_division            NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_dsm_fractional_division       true    false           LONG  	 0             							NOVAL			{0:4294967296} 															  						false	   																																																								false																NOVAL 		  NOVAL  			"General"  						"pll_dsm_fractional_division"                     	 				NOVAL				NOVAL} \
      {hssi_cascade_dsm_fractional_division    NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_dsm_fractional_division true  false           LONG  	 0             							NOVAL			{0:4294967296} 															  						false	   																																																								false																NOVAL 		  NOVAL  			"General"  						"pll_dsm_fractional_division"                     	 				NOVAL				NOVAL} \
	  {pll_dsm_fractional_division             advanced	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pll_dsm_fractional_division        true    false           STRING  	 0             							NOVAL			NOVAL 															  								false	   																																																								false																NOVAL 		  NOVAL  			"General"  						"pll_dsm_fractional_division"                     	 				NOVAL				NOVAL} \
      {pll_dsm_mode                            NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_dsm_mode					      true    false           STRING    "dsm_mode_integer"   					NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_dsm_mode"                    			 						NOVAL				NOVAL} \
      {pll_dsm_out_sel                         NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_dsm_out_sel					  true    false           STRING    "pll_dsm_disable"   					NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_dsm_out_sel"                    			 					NOVAL				NOVAL} \
	  {cmu_fpll_fpll_cas_out_enable            NOVAL	   1				0				 ::altera_xcvr_fpll_vi::parameters::validate_cas_out_enable	                  true    true			  STRING    "fpll_cas_out_disable"           		NOVAL			NOVAL  							  										  						false                    	   																																																		false                     											NOVAL         NOVAL         	"Settings" 						"Dedicated FPLL to FPLL cascade out"                                    NOVAL				NOVAL} \
 	  {cmu_fpll_pll_self_reset                 NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_self_reset                     true    false           STRING    "false"                       			NOVAL    		NOVAL                                                                                    		false                                                                                                                                                                                                                 					false                                                               NOVAL         NOVAL             "General"                       "pll_self_reset"                                                   	NOVAL               NOVAL} \
      \
	  {core_m_counter                          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_core_m_counter                     true    false           INTEGER   1             							NOVAL			{1:256} 																  						false	   																																																								false 																NOVAL 		  NOVAL  			"General"  						"pll_m_counter"                        				 				NOVAL				NOVAL} \
      {hssi_m_counter                          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_m_counter                     true    false           INTEGER   1             							NOVAL			{1:256} 																  						false	   																																																								false 																NOVAL 		  NOVAL  			"General"  						"pll_m_counter"                        				 				NOVAL				NOVAL} \
      {hssi_cascade_m_counter                  NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_m_counter             true    false           INTEGER   1             							NOVAL			{1:256} 																  						false	   																																																								false 																NOVAL 		  NOVAL  			"General"  						"pll_m_counter"                        				 				NOVAL				NOVAL} \
      \
	  {core_n_counter                          NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_core_n_counter                 	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_n_counter"                                      				NOVAL				NOVAL} \
      {hssi_n_counter                          NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_n_counter                 	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_n_counter"                                      				NOVAL				NOVAL} \
      {hssi_cascade_n_counter                  NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_n_counter         	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_n_counter"                                      				NOVAL				NOVAL} \
	  \                                                                                                                                                                                                                                            NOVAL
	  {pll_m_counter                           NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter                      true    false           INTEGER   1             							NOVAL			{1:256} 																  						false	   																																																								false 																NOVAL 		  NOVAL  			"General"  						"pll_m_counter"                        				 				NOVAL				NOVAL} \
      {pll_n_counter                           NOVAL	   0				0			 	 ::altera_xcvr_fpll_vi::parameters::update_pll_n_counter                 	  true    false           INTEGER   1  										NOVAL			NOVAL     													  			  						false        				   																																																			false   															NOVAL         NOVAL         	"General"  						"pll_n_counter"                                      				NOVAL				NOVAL} \
      \
	  {refclk_freq_bitvec                      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_refclk_freq_bitvec		      	  true    false            STRING    "000000001"       						36			    NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         NOVAL           	"Reference Clock"  				"Reference clock frequency"                      					NOVAL				NOVAL} \
	  {vco_freq_bitvec                         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_vco_freq_bitvec      			  true    false            STRING    "000000001"       						36   			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         NOVAL           	"General"  						"VCO Frequency"                      								NOVAL				NOVAL} \
	  {pfd_freq_bitvec                         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pfd_freq_bitvec   				  true    false            STRING    "000000001"       						36  			NOVAL                                        							  						true                     	   																																																			false      				 											NOVAL         NOVAL           	"General"  						"PFD Frequency"                      								NOVAL				NOVAL} \
	  {output_freq_bitvec                      NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_output_freq_bitvec		    	  true    false            STRING    "000000001"       						36  			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"Transceiver Usage"     		"PLL output frequency"                      	 					NOVAL				NOVAL} \
	  {f_out_c0_bitvec                         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_f_out_c0_bitvec   		    	  true    false            STRING    "000000001"       						36   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"Core Usage"        			"PLL output frequency"                      	 					NOVAL				NOVAL} \
	  {f_out_c1_bitvec                         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_f_out_c1_bitvec   		    	  true    false            STRING    "000000001"       						36   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"Core Usage"        			"PLL output frequency"                      	 					NOVAL				NOVAL} \
	  {f_out_c2_bitvec                         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_f_out_c2_bitvec   		    	  true    false            STRING    "000000001"       						36   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"Core Usage"        			"PLL output frequency"                      	 					NOVAL				NOVAL} \
	  {f_out_c3_bitvec                         NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_f_out_c3_bitvec   		    	  true    false            STRING    "000000001"       						36   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"Core Usage"        			"PLL output frequency"                      	 					NOVAL				NOVAL} \
	  {l_counter_bitvec                        NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_l_counter_bitvec   		    	  true    false            INTEGER    1            							5   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"l_counter"     			                 	 					NOVAL				NOVAL} \
	  {n_counter_bitvec                        NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_n_counter_bitvec   		    	  true    false            INTEGER    1           							8   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"n_counter"                                 	 					NOVAL				NOVAL} \
	  {m_counter_bitvec                        NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_m_counter_bitvec   		    	  true    false            INTEGER    1           							6   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"m_counter"                                 	 					NOVAL				NOVAL} \
	  {c_counter0_bitvec                       NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_c_counter0_bitvec   		    	  true    false            INTEGER    1            							9   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"c0_counter"                                	 					NOVAL				NOVAL} \
	  {c_counter1_bitvec                       NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_c_counter1_bitvec   		    	  true    false            INTEGER    1            							9   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"c1_counter"                                	 					NOVAL				NOVAL} \
	  {c_counter2_bitvec                       NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_c_counter2_bitvec   		    	  true    false            INTEGER    1            							9   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"c2_counter"                                	 					NOVAL				NOVAL} \
	  {c_counter3_bitvec                       NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_c_counter3_bitvec   		    	  true    false            INTEGER    1            							9   			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"c3_counter"                                	 					NOVAL				NOVAL} \
	  {pma_width_bitvec                        NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_pma_width_bitvec    		    	  true    false            INTEGER    8            							NOVAL			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"pma_width"                                 	 					NOVAL				NOVAL} \
	  {cgb_div_bitvec                          NOVAL	   0				0				 ::altera_xcvr_fpll_vi::parameters::update_cgb_div_bitvec      		    	  true    false            INTEGER    1            							NOVAL			NOVAL                                        							  						true 																																																									false      				 											NOVAL         NOVAL         	"General"           			"cgb_div"                                   	 					NOVAL				NOVAL} \
	  {pll_auto_clk_sw_en                      NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_auto_clk_sw_en                 true    false            STRING     "false"                               NOVAL           NOVAL                                                                                           false                                                                                                                                                                                                                                   false                                                               NOVAL         NOVAL             "General"                       "pll_auto_clk_sw_en"                                                NOVAL               NOVAL} \
	  {pll_clk_loss_edge                       NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_clk_loss_edge                  true    false            STRING     "pll_clk_loss_both_edges"             NOVAL           NOVAL                                                                                           false                                                                                                                                                                                                                                   false                                                               NOVAL         NOVAL             "General"                       "pll_clk_loss_edge"                                                 NOVAL               NOVAL} \
	  {pll_clk_loss_sw_en                      NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_clk_loss_sw_en                 true    false            STRING     "false"                               NOVAL           NOVAL                                                                                           false                                                                                                                                                                                                                                   false                                                               NOVAL         NOVAL             "General"                       "pll_clk_loss_sw_en"                                                NOVAL               NOVAL} \
	  {pll_clk_sw_dly                          NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_clk_sw_dly                     true    false            INTEGER    0                                     NOVAL           NOVAL                                                                                           false                                                                                                                                                                                                                                   false                                                               NOVAL         NOVAL             "General"                       "pll_clk_sw_dly"                                                    NOVAL               NOVAL} \
	  {pll_manu_clk_sw_en                      NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_manu_clk_sw_en                 true    false            STRING     "false"                               NOVAL           NOVAL                                                                                           false                                                                                                                                                                                                                                   false                                                               NOVAL         NOVAL             "General"                       "pll_manu_clk_sw_en"                                                NOVAL               NOVAL} \
	  {pll_sw_refclk_src                       NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::update_pll_sw_refclk_src                  true    false            STRING     "pll_sw_refclk_src_clk_0"             NOVAL           NOVAL                                                                                           false                                                                                                                                                                                                                                   false                                                               NOVAL         NOVAL             "General"                       "pll_sw_refclk_src"                                                 NOVAL               NOVAL} \
      \
      {set_altera_xcvr_fpll_a10_calibration_en NOVAL      0                0                NOVAL                                                                        false   false           INTEGER    1                                      NOVAL           NOVAL                                                                                           enable_advanced_options                                                                                                                                                                                                                 enable_advanced_options                                             BOOLEAN       NOVAL             "General"                       "Enable calibration"                                                NOVAL               "Enable transceiver calibration algorithms."}\
      {calibration_en                          NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::validate_enable_calibration               true    false           STRING     "enable"                               NOVAL           {"enable" "disable"}                                                                            enable_advanced_options                                                                                                                                                                                                                 false                                                               NOVAL         NOVAL             NOVAL                           NOVAL                                                               NOVAL               NOVAL}\
	  \
	  {support_mode                            NOVAL      0                0                ::altera_xcvr_fpll_vi::parameters::validate_support_mode                     false   false           STRING    "user_mode"                             NOVAL           {"user_mode" "engineering_mode"}                                                                enable_advanced_options                                                                                                                                                                                                                 enable_advanced_options                                             NOVAL         NOVAL             "General"                       "Support mode"                                                      NOVAL               "Specifies the desired support mode. Note that engineering mode is available for internal-use only."} \
          {enable_ext_lockdetect_ports             NOVAL       0                0                NOVAL                                                                        false   false          INTEGER     0                                                                  NOVAL                    NOVAL                                                                             TRUE	TRUE	BOOLEAN	NOVAL	"General"	"Enable clklow and fref ports"	NOVAL	"Enables fref and clklow clock ports for external lock detector. In Transceiver mode when \"enable fractional mode\" is selected, pll_locked port is not available and user can create external lock detector using clklow and fref clock ports"} \
      {is_c10                                  NOVAL       0                0                ::altera_xcvr_fpll_vi::parameters::validate_c10                                true    false           INTEGER   0                                     NOVAL                NOVAL                                                                                                                                  true                                                                                false                                                                   NOVAL         NOVAL             NOVAL                                   NOVAL                                                                     NOVAL                 NOVAL} \
	  }

#{pll_vco_ph1_en                              NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_vco_ph1_en                           true        false             STRING      "true"                        NOVAL     NOVAL                                                                                    true                                        false                                                                       NOVAL            NOVAL              "General"                         "pll_vco_ph1_en"                                                       NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                \                      
#{pll_vco_ph2_en                              NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_vco_ph2_en                           true        false             STRING      "true"                        NOVAL     NOVAL                                                                                    true                                        false                                                                       NOVAL            NOVAL              "General"                         "pll_vco_ph2_en"                                                       NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                \                     
#{pll_vco_ph3_en                              NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_vco_ph3_en                           true        false             STRING      "true"                        NOVAL     NOVAL                                                                                    true                                        false                                                                       NOVAL            NOVAL              "General"                         "pll_vco_ph3_en"                                                       NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                \                     
#{pll_l_counter_bypass                        NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_l_counter_bypass                     true        false             STRING      "false"                       NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_l_counter_bypass"                                                 NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_l_counter_enable                        NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_l_counter_enable                     true        false             STRING      "true"                        NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_l_counter_enable"                                                 NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_m_counter_ph_mux_prst                   NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_ph_mux_prst                true        false             INTEGER     1                             NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_m_counter_ph_mux_prst"                                            NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_m_counter_prst                          NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_prst                       true        false             INTEGER     1                             NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_m_counter_prst"                                                   NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_m_counter_coarse_dly                    NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_coarse_dly                 true        false             STRING      "0 ps"                        NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_m_counter_coarse_dly"                                             NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_m_counter_fine_dly                      NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_fine_dly                   true        false             STRING      "0 ps"                        NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_m_counter_fine_dly"                                               NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_n_counter_coarse_dly                    NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_n_counter_coarse_dly                 true        false             STRING      "0 ps"                        NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_n_counter_coarse_dly"                                             NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_n_counter_fine_dly                      NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_n_counter_fine_dly                   true        false             STRING      "0 ps"                        NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_n_counter_fine_dly"                                               NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_fbclk_mux_1                             NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_fbclk_mux_1                          true        false             STRING      "pll_fbclk_mux_1_glb"         NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_fbclk_mux_1"                                                      NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_fbclk_mux_2                             NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_fbclk_mux_2                          true        false             STRING      "pll_fbclk_mux_2_m_cnt"       NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_fbclk_mux_2"                                                      NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_clkin_0_src                             NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_clkin_0_src                          true        false             STRING      "pll_clkin_0_src_lvpecl"      NOVAL     NOVAL                                                                                    true                                        false                                                                       NOVAL            NOVAL              "General"                         "pll_clkin_0_src"                                                      NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_clkin_1_src                             NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_clkin_1_src                          true        false             STRING      "pll_clkin_1_src_ref_clk"     NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_clkin_1_src"                                                      NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_auto_clk_sw_en                          NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_auto_clk_sw_en                       true        false             STRING      "false"                       NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_auto_clk_sw_en"                                                   NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_clk_loss_edge                           NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_clk_loss_edge                        true        false             STRING      "pll_clk_loss_both_edges"     NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_clk_loss_edge"                                                    NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_clk_loss_sw_en                          NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_clk_loss_sw_en                       true        false             STRING      "false"                       NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_clk_loss_sw_en"                                                   NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_clk_sw_dly                              NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_clk_sw_dly                           true        false             INTEGER     0                             NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_clk_sw_dly"                                                       NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_manu_clk_sw_en                          NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_manu_clk_sw_en                       true        false             STRING      "false"                       NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_manu_clk_sw_en"                                                   NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_sw_refclk_src                           NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_sw_refclk_src                        true        false             STRING      "pll_sw_refclk_src_clk_0"     NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              "General"                         "pll_sw_refclk_src"                                                    NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_vco_freq_band_0                         NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_vco_freq_band_0                      true        false             STRING      "pll_freq_band0"              NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              NOVAL                             NOVAL                                                                  NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_vco_freq_band_1                         NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_vco_freq_band_1                      true        false             STRING      "pll_freq_band0"              NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              NOVAL                             NOVAL                                                                  NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_lf_resistance                           NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_lf_resistance                        true        false             STRING      "lf_res_setting0"             NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              NOVAL                             NOVAL                                                                  NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_lf_ripplecap                            NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_lf_ripplecap                         true        false             STRING      "lf_ripple_enabled_0"         NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              NOVAL                             NOVAL                                                                  NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_lf_cbig                                 NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_lf_cbig                              true        false             STRING      "lf_cbig_setting4"            NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              NOVAL                             NOVAL                                                                  NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_cp_lf_order                             NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_cp_lf_order                          true        false             STRING      "lf_cbig_setting4"            NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              NOVAL                             NOVAL                                                                  NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
#{pll_cp_current_setting                      NOVAL         0                   0                   ::altera_xcvr_fpll_vi::parameters::update_pll_cp_current_setting                   true        false             STRING      "cp_current_setting0"         NOVAL     NOVAL                                                                                    false                                       false                                                                       NOVAL            NOVAL              NOVAL                             NOVAL                                                                  NOVAL                                                                             NOVAL                                                                                                                                                                                             }                                 \                     
		
set static_hdl_parameters {\
      { NAME                                                               M_AUTOSET       M_RCFG_REPORT   TYPE       DERIVED   HDL_PARAMETER   ENABLED   VISIBLE   DEFAULT_VALUE             VALIDATION_CALLBACK}\
      { cmu_fpll_initial_settings                                          false           0               STRING     true      true            false     false     "true"                    NOVAL }\
   }
	set parameters_allowed_range {\
      {NAME           ALLOWED_RANGES } \
      {prot_mode  	  { "unused" "basic_tx" "basic_kr_tx" "pcie_gen1_tx" "pcie_gen2_tx" "pcie_gen3_tx" "pcie_gen4_tx" "cei_tx" "qpi_tx" "cpri_tx" "fc_tx" "srio_tx" "gpon_tx" "sdi_tx" "sata_tx" "xaui_tx" "obsai_tx" "gige_tx" "higig_tx" "sonet_tx" "sfp_tx" "xfp_tx" "sfi_tx" } } \
      {gui_bw_sel     { "low" "medium" "high" } } \
      {temp_bw_sel    { "low" "medium" "high" } } \
   }
   
      #{cmu_fpll_pll_self_reset                       0                 STRING      true        gui_self_reset_enabled          true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_vco_ph1_en                       0                 STRING      true        pll_vco_ph1_en                  true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_vco_ph2_en                       0                 STRING      true        pll_vco_ph2_en                  true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_vco_ph3_en                       0                 STRING      true        pll_vco_ph3_en                  true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_l_counter_bypass                 1                 STRING      true        pll_l_counter_bypass            true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_l_counter_enable                 1                 STRING      true        pll_l_counter_enable            true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_m_counter_ph_mux_prst            1                 INTEGER     true        pll_m_counter_ph_mux_prst       true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_m_counter_prst                   1                 INTEGER     true        pll_m_counter_prst              true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_m_counter_coarse_dly             1                 STRING      true        pll_m_counter_coarse_dly        true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_m_counter_fine_dly               1                 STRING      true        pll_m_counter_fine_dly          true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_n_counter_coarse_dly             1                 STRING      true        pll_n_counter_coarse_dly        true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_n_counter_fine_dly               1                 STRING      true        pll_n_counter_fine_dly          true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_fbclk_mux_1                      1                 STRING      true        pll_fbclk_mux_1                 true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_fbclk_mux_2                      1                 STRING      true        pll_fbclk_mux_2                 true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_clkin_0_src        0                 STRING      true        pll_clkin_0_src                 true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_clkin_1_src        0                 STRING      true        pll_clkin_1_src                 true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_auto_clk_sw_en     1                 STRING      true        pll_auto_clk_sw_en              true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_clk_loss_edge      1                 STRING      true        pll_clk_loss_edge               true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_clk_loss_sw_en     1                 STRING      true        pll_clk_loss_sw_en              true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_clk_sw_dly         1                 INTEGER     true        pll_clk_sw_dly                  true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_manu_clk_sw_en     1                 STRING      true        pll_manu_clk_sw_en              true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_refclk_select_pll_sw_refclk_src      1                 STRING      true        pll_sw_refclk_src               true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_vco_freq_band_0                  0                 STRING      true        pll_vco_freq_band_0             true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_vco_freq_band_1                  0                 STRING      true        pll_vco_freq_band_1             true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_lf_resistance                    0                 STRING      true        pll_lf_resistance               true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_lf_ripplecap                     0                 STRING      true        pll_lf_ripplecap                true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_lf_cbig                          0                 STRING      true        pll_lf_cbig                     true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_cp_lf_order                      0                 STRING      true        pll_cp_lf_order                 true              false       false       NOVAL                                                                            }          
      #{cmu_fpll_pll_cp_current_setting               0                 STRING      true        pll_cp_current_setting          true              false       false       NOVAL                                                                            }     


set mapped_parameters {\
     { NAME                               M_AUTOSET   M_AUTOWARN   M_MAPS_FROM                      VALIDATION_CALLBACK                                             M_MAP_VALUES }\
      { enable_cascade_in                  false       true         gui_hssi_prot_mode                  NOVAL                                                        {"4:1" "5:1" "Basic:0" "0:0" "1:0" "PCIe G2:0 3:0"}} \
}

   set atom_parameters {\
      {NAME                                                              M_CONTEXT  DISPLAY_NAME   VALIDATION_CALLBACK     M_AUTOSET    TYPE       DERIVED  M_MAPS_FROM                     	HDL_PARAMETER   ENABLED     VISIBLE    M_MAP_VALUES }\
      {cmu_fpll_xpm_cmu_fpll_core_fpll_refclk_source                        NOVAL   NOVAL          NOVAL                   false        STRING     true     enable_cascade_in                  true            false       false      {"0:normal_refclk" "1:lc_dedicated_refclk"} } \
      {cmu_fpll_pll_sup_mode                                                NOVAL   NOVAL          NOVAL                   false        STRING     true     support_mode                       true            false       false      NOVAL } \
      {cmu_fpll_bw_sel                                                      NOVAL   NOVAL          NOVAL                   false        STRING     true     temp_bw_sel                        true            false       false      NOVAL } \
      {cmu_fpll_datarate                                                    NOVAL   NOVAL          NOVAL                   false        STRING     true     pll_datarate						 true            false      	false      NOVAL } \
	  \
      {cmu_fpll_reconfig_en                                                 NOVAL   NOVAL          NOVAL                   false        STRING     true     enable_pll_reconfig                true            false       false      NOVAL } \
      {cmu_fpll_dps_en                                                      NOVAL   NOVAL          NOVAL                   false        STRING     true     gui_enable_dps                     true            false       false      NOVAL } \
      {cmu_fpll_is_pa_core                                                  NOVAL   NOVAL          NOVAL                   false        STRING     true     gui_enable_phase_alignment         true            false       false      NOVAL } \
      {cmu_fpll_silicon_rev                                                 NOVAL   NOVAL          NOVAL                   false        STRING     true     device_revision            		 true     		false       false 	   NOVAL } \
      {cmu_fpll_refclk_select_mux_refclk_select0                            NOVAL   NOVAL          NOVAL                   false        STRING     true     gui_refclk_index                   true            false       false     {"0:lvpecl" "1:ref_iqclk0" "2:ref_iqclk1" "3:ref_iqclk2" "4:ref_iqclk3"} } \
      {cmu_fpll_refclk_select_mux_refclk_select1                            NOVAL   NOVAL          NOVAL                   false        STRING	   true 	  refclk_select1			   		 true 		   	false	 	false	   NOVAL } \
      \
      {cmu_fpll_refclk_select_mux_pll_auto_clk_sw_en                        NOVAL   NOVAL          NOVAL				    false		 STRING     true     pll_auto_clk_sw_en                 true            false       false      NOVAL } \
      {cmu_fpll_refclk_select_mux_pll_clk_loss_edge                         NOVAL   NOVAL          NOVAL                   false        STRING     true     pll_clk_loss_edge                  true            false       false      NOVAL } \
      {cmu_fpll_refclk_select_mux_pll_clk_loss_sw_en                        NOVAL   NOVAL          NOVAL                   false        STRING     true     pll_clk_loss_sw_en                 true            false       false      NOVAL } \
      {cmu_fpll_refclk_select_mux_pll_clk_sw_dly                            NOVAL   NOVAL          NOVAL                   false        INTEGER    true     pll_clk_sw_dly                     true            false       false      NOVAL } \
      {cmu_fpll_refclk_select_mux_pll_manu_clk_sw_en                        NOVAL   NOVAL          NOVAL                   false        STRING     true     pll_manu_clk_sw_en                 true            false       false      NOVAL } \
      {cmu_fpll_refclk_select_mux_pll_sw_refclk_src                         NOVAL   NOVAL          NOVAL                   false        STRING     true     pll_sw_refclk_src                  true            false       false      NOVAL } \
      {cmu_fpll_pll_m_counter_in_src                                        NOVAL   NOVAL          NOVAL                   false        STRING     true     pll_m_counter_in_src               true            false       false      NOVAL } \
	  {cmu_fpll_pll_c_counter_0_ph_mux_prst                                 NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_0_ph_mux_prst 		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_0_prst                                        NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_0_prst 	   			true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_0_in_src                                      NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_0_in_src 	   		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_0_coarse_dly                                  NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_0_coarse_dly  		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_0_fine_dly                                    NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_0_fine_dly    		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_1_ph_mux_prst                                 NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_1_ph_mux_prst 		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_1_prst                                        NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_1_prst 	   			true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_1_in_src                                      NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_1_in_src 	   		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_1_coarse_dly                                  NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_1_coarse_dly  		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_1_fine_dly                                    NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_1_fine_dly    		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_2_ph_mux_prst                                 NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_2_ph_mux_prst 		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_2_prst                                        NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_2_prst 	   			true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_2_in_src                                      NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_2_in_src 	   		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_2_coarse_dly                                  NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_2_coarse_dly  		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_2_fine_dly                                    NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_2_fine_dly    		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_3_ph_mux_prst                                 NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_3_ph_mux_prst 		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_3_prst                                        NOVAL   NOVAL          NOVAL                   false        INTEGER    true  	 pll_c_counter_3_prst 	   			true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_3_in_src                                      NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_3_in_src 	   		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_3_coarse_dly                                  NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_3_coarse_dly  		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_3_fine_dly                                    NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_c_counter_3_fine_dly    		true 		   	false	 	false	   NOVAL } \
	  \
	  {cmu_fpll_pll_m_counter                                               advanced "M-counter"    NOVAL                   false        INTEGER    true     pll_m_counter    					true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_0                                             advanced "C-counter-0"  NOVAL                   false        INTEGER    true     pll_c_counter_0 	           		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_1                                             advanced "C-counter-1"  NOVAL                   false        INTEGER    true  	 pll_c_counter_1 	           		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_2                                             advanced "C-counter-2"  NOVAL                   false        INTEGER    true  	 pll_c_counter_2 	           		true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_c_counter_3                                             advanced "C-counter-3"  NOVAL                   false        INTEGER    true  	 pll_c_counter_3 	           		true 		   	false	 	false	   NOVAL } \
      {cmu_fpll_pll_l_counter                                               advanced "L-counter"    NOVAL                   false        INTEGER    true  	 pll_l_counter    					true 		   	false	 	false	   NOVAL } \
	  {cmu_fpll_pll_dsm_fractional_division                                 NOVAL   "K-fractional division" NOVAL          false        INTEGER    true  	 pll_dsm_fractional_division    	true 		   	false	 	false	   NOVAL } \
      {cmu_fpll_pll_dsm_mode                                                NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_dsm_mode    					true 		   	false	 	false	   NOVAL } \
      {cmu_fpll_pll_dsm_out_sel                                             NOVAL   NOVAL          NOVAL                   false        STRING     true  	 pll_dsm_out_sel    				true 		   	false	 	false	   NOVAL } \
      {cmu_fpll_pll_n_counter                                               advanced "N-counter"    NOVAL                   false        INTEGER    true  	 pll_n_counter    					true 		   	false	 	false	   NOVAL } \
      \
      {cmu_fpll_refclk_select_mux_mux0_inclk0_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:lvpecl"     "2:lvpecl"     "3:lvpecl"     "4:lvpecl"     "5:lvpecl"} } \
      {cmu_fpll_refclk_select_mux_mux0_inclk1_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:ref_iqclk0" "3:ref_iqclk0" "4:ref_iqclk0" "5:ref_iqclk0"} } \
      {cmu_fpll_refclk_select_mux_mux0_inclk2_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:power_down" "3:ref_iqclk1" "4:ref_iqclk1" "5:ref_iqclk1"} } \
      {cmu_fpll_refclk_select_mux_mux0_inclk3_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:power_down" "3:power_down" "4:ref_iqclk2" "5:ref_iqclk2"} } \
      {cmu_fpll_refclk_select_mux_mux0_inclk4_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:power_down" "3:power_down" "4:power_down" "5:ref_iqclk3"} } \
      {cmu_fpll_refclk_select_mux_mux1_inclk0_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:lvpecl"     "2:lvpecl"     "3:lvpecl"     "4:lvpecl"     "5:lvpecl"} } \
      {cmu_fpll_refclk_select_mux_mux1_inclk1_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:ref_iqclk0" "3:ref_iqclk0" "4:ref_iqclk0" "5:ref_iqclk0"} } \
      {cmu_fpll_refclk_select_mux_mux1_inclk2_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:power_down" "3:ref_iqclk1" "4:ref_iqclk1" "5:ref_iqclk1"} } \
      {cmu_fpll_refclk_select_mux_mux1_inclk3_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:power_down" "3:power_down" "4:ref_iqclk2" "5:ref_iqclk2"} } \
      {cmu_fpll_refclk_select_mux_mux1_inclk4_logical_to_physical_mapping   NOVAL   NOVAL          NOVAL                   false        STRING     true      gui_refclk_cnt                     true            false       false     {"1:power_down" "2:power_down" "3:power_down" "4:power_down" "5:ref_iqclk3"} } \
      \
	  {cmu_fpll_primary_use                                                 NOVAL   NOVAL          NOVAL                   false 	   STRING     true      primary_use                        true            false       false     NOVAL } \
      {cmu_fpll_prot_mode                                                   NOVAL   NOVAL          NOVAL                   false 	   STRING     true      prot_mode                          true            false       false     NOVAL } \
	  {cmu_fpll_reference_clock_frequency                                   NOVAL   NOVAL          NOVAL                   false 	   STRING     true      reference_clock_frequency          true            false       false     NOVAL } \
	  {cmu_fpll_compensation_mode                                           NOVAL   NOVAL          NOVAL                   false 	   STRING     true      compensation_mode                  true            false       false     NOVAL } \
	  {cmu_fpll_feedback                                                    NOVAL   NOVAL          NOVAL                   false 	   STRING     true      feedback                           true            false       false     NOVAL } \
	  {cmu_fpll_hssi_output_clock_frequency                                 NOVAL   NOVAL          NOVAL                   false 	   STRING     true      hssi_output_clock_frequency        true            false       false     NOVAL } \
	  {cmu_fpll_vco_frequency                                               advanced "VCO Frequency" NOVAL                  false 	   STRING     true      vco_frequency                      true            false       false     NOVAL } \
      {cmu_fpll_output_clock_frequency_0                                    NOVAL   NOVAL          NOVAL                   false 	   STRING     true      output_clock_frequency_0           true            false       false     NOVAL } \
	  {cmu_fpll_phase_shift_0                                               NOVAL   NOVAL          NOVAL                   false 	   STRING     true      phase_shift_0                      true            false       false     NOVAL } \
	  {cmu_fpll_output_clock_frequency_1                                    NOVAL   NOVAL          NOVAL                   false 	   STRING     true      output_clock_frequency_1           true            false       false     NOVAL } \
	  {cmu_fpll_phase_shift_1                                               NOVAL   NOVAL          NOVAL                   false 	   STRING     true      phase_shift_1                      true            false       false     NOVAL } \
	  {cmu_fpll_output_clock_frequency_2                                    NOVAL   NOVAL          NOVAL                   false 	   STRING     true      output_clock_frequency_2           true            false       false     NOVAL } \
	  {cmu_fpll_phase_shift_2                                               NOVAL   NOVAL          NOVAL                   false 	   STRING     true      phase_shift_2                      true            false       false     NOVAL } \
	  {cmu_fpll_output_clock_frequency_3                                    NOVAL   NOVAL          NOVAL                   false 	   STRING     true      output_clock_frequency_3           true            false       false     NOVAL } \
	  {cmu_fpll_phase_shift_3                                               NOVAL   NOVAL          NOVAL                   false 	   STRING     true      phase_shift_3                      true            false       false     NOVAL } \
      {cmu_fpll_calibration_en                                              NOVAL   NOVAL          NOVAL                   false       STRING     true      calibration_en                     true            false       false     NOVAL } \
      {cmu_fpll_pll_iqclk_mux_sel                                           NOVAL   NOVAL          NOVAL                   false       STRING     true      pll_iqclk_mux_sel                  true            false       false     NOVAL } \
      \
	  {cmu_fpll_refclk_freq                                                 NOVAL   NOVAL          NOVAL                   false       STRING	   true      refclk_freq_bitvec                 true            false       false     NOVAL } \
	  {cmu_fpll_vco_freq                                                    NOVAL   NOVAL          NOVAL                   false       STRING	   true      vco_freq_bitvec                    true            false       false     NOVAL } \
	  {cmu_fpll_vco_freq_hz                                                 NOVAL   NOVAL          ::altera_xcvr_fpll_vi::parameters::validate_cmu_fpll_vco_freq_hz                   false       STRING	   true      NOVAL                    	true            false       false     NOVAL } \
	  {cmu_fpll_pfd_freq                                                    NOVAL   NOVAL          NOVAL                   false       STRING	   true      pfd_freq_bitvec                    true            false       false     NOVAL } \
	  {cmu_fpll_out_freq                                                    NOVAL   NOVAL          NOVAL                   false       STRING	   true      output_freq_bitvec                 true            false       false     NOVAL } \
	  {cmu_fpll_f_out_c0                                                    NOVAL   NOVAL          NOVAL                   false       STRING	   true      f_out_c0_bitvec                    true            false       false     NOVAL } \
	  {cmu_fpll_f_out_c1                                                    NOVAL   NOVAL          NOVAL                   false       STRING	   true      f_out_c1_bitvec                    true            false       false     NOVAL } \
	  {cmu_fpll_f_out_c2                                                    NOVAL   NOVAL          NOVAL                   false       STRING	   true      f_out_c2_bitvec                    true            false       false     NOVAL } \
	  {cmu_fpll_f_out_c3                                                    NOVAL   NOVAL          NOVAL                   false       STRING	   true      f_out_c3_bitvec                    true            false       false     NOVAL } \
	  {cmu_fpll_m_counter                                                   NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      m_counter_bitvec                   true            false       false     NOVAL } \
	  {cmu_fpll_m_counter_c0                                                NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      c_counter0_bitvec                  true            false       false     NOVAL } \
	  {cmu_fpll_m_counter_c1                                                NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      c_counter1_bitvec                  true            false       false     NOVAL } \
	  {cmu_fpll_m_counter_c2                                                NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      c_counter2_bitvec                  true            false       false     NOVAL } \
	  {cmu_fpll_m_counter_c3                                                NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      c_counter3_bitvec                  true            false       false     NOVAL } \
	  {cmu_fpll_pma_width                                                   NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      pma_width_bitvec                   true            false       false     NOVAL } \
	  {cmu_fpll_cgb_div                                                     NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      cgb_div_bitvec                     true            false       false     NOVAL } \
	  {cmu_fpll_n_counter                                                   NOVAL   NOVAL          NOVAL                   false       INTEGER	   true      n_counter_bitvec                   true            false       false     NOVAL } \
      {cmu_fpll_l_counter                                                   NOVAL   NOVAL          NOVAL                   false       INTEGER    true      l_counter_bitvec                   true            false       false     NOVAL } \
	  {cmu_fpll_f_min_vco                                                   NOVAL   NOVAL          ::altera_xcvr_fpll_vi::parameters::obtain_f_min_vco                   false       STRING	   true      NOVAL                    true            false       false     NOVAL } \
	  {cmu_fpll_f_max_vco                                                   NOVAL   NOVAL          ::altera_xcvr_fpll_vi::parameters::obtain_f_max_vco                   false       STRING	   true      NOVAL                    true            false       false     NOVAL } \
	  {cmu_fpll_is_sdi                                                      NOVAL   NOVAL          ::altera_xcvr_fpll_vi::parameters::validate_enable_sdi_rule_checks    false       STRING    true      NOVAL                    TRUE            false       false     NOVAL } \
	  {cmu_fpll_is_otn                                                      NOVAL   NOVAL          ::altera_xcvr_fpll_vi::parameters::validate_enable_otn_rule_checks    false       STRING    true      NOVAL                    TRUE            false       false     NOVAL } \
	  {cmu_fpll_side                                                        NOVAL   NOVAL          ::altera_xcvr_fpll_vi::parameters::validate_side                      false       STRING    true      NOVAL                    TRUE            false       false     NOVAL } \
	}

   set logical_parameters {\
      { NAME                    TYPE       DERIVED   M_MAPS_FROM                     HDL_PARAMETER   ENABLED   VISIBLE   M_MAP_VALUES }\
      { fpll_refclk_select        INTEGER    true      gui_refclk_index                false           false     false     NOVAL }\
   }

   set gui_parameter_list [list]
   set gui_parameter_values [list]

   #set_parameter_update_callback parameters.gui_desired_outclk1_frequency ::altera_xcvr_fpll_vi::parameters::test_single_parameter_callback
}

# +-----------------------------------
# | 
# |
proc ::altera_xcvr_fpll_vi::parameters::declare_parameters {} {
   variable display_items_pll
   variable generation_display_items
   variable refclk_switchover_display_items
   variable parameters
   variable parameters_allowed_range
   variable atom_parameters
   variable mapped_parameters
   variable logical_parameters
   variable system_info_parameters
   variable static_hdl_parameters

   variable gui_parameter_list
   variable gui_parameter_values
   # Determine which parameters are needed to include in reconfig reports is parameter dependent
   ip_add_user_property_type M_RCFG_REPORT integer

   # Initialize Reconfiguration parameters
   ::alt_xcvr::utils::reconfiguration_arria10::declare_parameters
   ip_set "parameter.rcfg_file_prefix.DEFAULT_VALUE" "altera_xcvr_fpll_a10"
   
   # Initialize General parameters
   ip_declare_parameters $system_info_parameters
   ip_declare_parameters [::nf_cmu_fpll::parameters::get_parameters]

   set nf_cmu_fpll_parameters [ip_get_matching_parameters [dict set criteria M_IP_CORE nf_cmu_fpll]]
   set mif_exclude [dict create cmu_fpll_pll_cal_status 1 cmu_fpll_pll_vco_ph3_value 1 cmu_fpll_pll_vco_ph2_value 1 cmu_fpll_pll_vco_ph1_value 1 cmu_fpll_pll_vco_ph0_value 1]

   foreach param $nf_cmu_fpll_parameters {
     if {[ip_get "parameter.${param}.M_IS_STATIC_HDL_PARAMETER"] == "false"} {
       ip_set "parameter.${param}.HDL_PARAMETER" 1
       if {[dict exist $mif_exclude $param] != 1} {
          ip_set "parameter.${param}.M_RCFG_REPORT" 1
       }
     }
     ip_set "parameter.${param}.M_AUTOSET" "true"
     ip_set "parameter.${param}.M_AUTOWARN" "true"
   }

   ip_declare_parameters $parameters
   ip_declare_parameters $parameters_allowed_range
   ip_declare_parameters $atom_parameters
   ip_declare_parameters $mapped_parameters
   ip_declare_parameters $logical_parameters
   ip_declare_parameters $static_hdl_parameters
   # Initialize Central Clock Divider parameters
   ::mcgb_package_vi::mcgb::set_hip_cal_done_enable_maps_from gui_enable_hip_cal_done_port
   ::mcgb_package_vi::mcgb::set_output_clock_frequency_maps_from hssi_output_clock_frequency
   ::mcgb_package_vi::mcgb::set_protocol_mode_maps_from prot_mode
   ::mcgb_package_vi::mcgb::set_silicon_rev_maps_from device_revision
   ::mcgb_package_vi::mcgb::declare_mcgb_parameters
   
   # Declare General tab
   ip_declare_display_items $display_items_pll

   # Declare Central Clock Divider tab
   ::mcgb_package_vi::mcgb::set_mcgb_display_item_properties "" tab
   ::mcgb_package_vi::mcgb::declare_mcgb_display_items
   
   # Declare Reconfiguration tab
   ::alt_xcvr::utils::reconfiguration_arria10::declare_display_items "" tab
   
   # Declare Refclk switchover tab
   ip_declare_display_items $refclk_switchover_display_items

   # Declare Generation option tab
   ip_declare_display_items $generation_display_items
	   
   # Initialize device information (to allow sharing of this function across device families)
   # Declare system info/family parameters
   ip_set "parameter.device.SYSTEM_INFO" DEVICE
   
   ip_set "parameter.base_device.SYSTEM_INFO_TYPE" PART_TRAIT
   ip_set "parameter.base_device.SYSTEM_INFO_ARG" BASE_DEVICE
   ip_set "parameter.base_device.DEFAULT_VALUE" "nightfury5es";#temporary hack once BASE_DEVICE is properly supported by qsys remove this line


   # Grab Quartus INI's
   ip_set "parameter.enable_advanced_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_10_advanced ENABLED]
   ip_set "parameter.enable_hip_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_fpll_atx_pll_10_hip_options ENABLED]
#   ip_set "parameter.enable_atx_fpll_cascade_options.DEFAULT_VALUE" [get_quartus_ini altera_xcvr_atx_fpll_10_cascade ENABLED]

    # To have a parameter displayed in the "Advanced Parameters" tab, set the M_CONTEXT property
    # of that parameter to "advanced" and set its DISPLAY_NAME property to a valid string.
   add_display_item "" "Advanced Parameters" GROUP tab   

   add_parameter gui_parameter_list STRING_LIST
   set_parameter_property gui_parameter_list DISPLAY_NAME "Parameter Names"
   set_parameter_property gui_parameter_list DERIVED true
   set_parameter_property gui_parameter_list DESCRIPTION "Shows the list of advanced PLL parameters"

   add_parameter gui_parameter_values STRING_LIST
   set_parameter_property gui_parameter_values DISPLAY_NAME "Parameter Values"
   set_parameter_property gui_parameter_values DERIVED true
   set_parameter_property gui_parameter_values DESCRIPTION "Shows the list of values for the advanced PLL parameters"

   add_display_item "Advanced Parameters" "parameterTable" GROUP TABLE 
   set_display_item_property "parameterTable" DISPLAY_HINT { table fixed_size rows:24 } 
   add_display_item "parameterTable" gui_parameter_list parameter
   add_display_item "parameterTable" gui_parameter_values parameter
 
   # Test single parameter callback
   #puts "register parameter check"
   set_parameter_update_callback gui_desired_outclk1_frequency ::altera_xcvr_fpll_vi::parameters::test_single_parameter_callback temp
}

# +-----------------------------------
# | 
# |
proc ::altera_xcvr_fpll_vi::parameters::validate {} {      
	variable debug_message

    variable gui_parameter_list
    variable gui_parameter_values

    set parameter_list [list]
    set parameter_values_list [list]

    set advanced_params [ip_get_matching_parameters [dict set criteria M_CONTEXT advanced]]
    foreach param $advanced_params {
        set name [ip_get "parameter.${param}.DISPLAY_NAME"]
        if { $name != "NOVAL" } {
            lappend parameter_list $name
            lappend parameter_values_list [ip_get "parameter.${param}.value"]
        }
    }

    set_parameter_value gui_parameter_list $parameter_list
    set_parameter_value gui_parameter_values $parameter_values_list

	if {$debug_message} {
		puts "\n----------------------------------------------------------------------------------------------------------------------------------\n"
	}
	variable error_occurred_in_validation
	set error_occurred_in_validation false
	ip_validate_parameters
	ip_validate_display_items

}

proc ::altera_xcvr_fpll_vi::parameters::check_gui_fpll_mode { gui_fpll_mode } {
	variable debug_message
	variable error_occurred_in_validation
		
	#check for bad value from a failed upgrade... (This is really unfortunate...)
	if {$gui_fpll_mode == -1} {
		ip_message error "Upgrade has failed. The imported settings have created an illegal FPLL."
		ip_message error "Illegal FPLL Mode. The intended usage mode could not be inferred during IP Upgrade. Please select one of the legal mutually exclusive use modes: Core, Transceiver and Cascade (cascade to Transceiver CDR/ATX plls)."
		ip_message error "Manual parameter modification is required. Please edit your IP in the component editor."
		set error_occurred_in_validation true
	}
        if {$gui_fpll_mode == 0} {
	    ip_message warning "Phase alignment between the reference clock and the outclks is not available by default in Core mode. Please select the 'Enable phase alignment' checkbox if you require this functionality."
	}
}

# +-----------------------------------
# | This function sets pll_datarate atom parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_gui_pll_datarate { \
	gui_hssi_output_clock_frequency \
	gui_fpll_mode \
    gui_hssi_calc_output_clock_frequency \
    gui_enable_manual_hssi_counters
} {

   variable debug_message
   variable error_occurred_in_validation
   if {$error_occurred_in_validation} {
      return
   }
	
   if {$debug_message} {
      puts "\n::altera_xcvr_fpll_vi::parameters::update_guid_pll_datarate"
   }

   set using_transceiver [using_hssi_mode $gui_fpll_mode]
   if {$using_transceiver} {
      if { $gui_enable_manual_hssi_counters } {
        set local_vco_freq [get_freq_in_mhz $gui_hssi_calc_output_clock_frequency]
        set result [expr $local_vco_freq * 2]
      } else {
        set local_vco_freq [get_freq_in_mhz $gui_hssi_output_clock_frequency]
        set result [expr $local_vco_freq * 2]
      }


      ip_set "parameter.gui_pll_datarate.value" "$result"
   } else {
      ip_set "parameter.gui_pll_datarate.value" "0"
   }

#	commented out debug msg due to different scopes 
#    if {$debug_message} {
#        puts "  result: $result"
#    }  

}

# +-----------------------------------
# | This function sets pll_datarate atom parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_datarate { \
	gui_hssi_output_clock_frequency \
	gui_fpll_mode \
    gui_hssi_calc_output_clock_frequency \
    gui_enable_manual_hssi_counters
} {

   variable debug_message
   variable error_occurred_in_validation
   if {$error_occurred_in_validation} {
      return
   }
	
   if {$debug_message} {
      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_datarate"
   }

   set using_transceiver [using_hssi_mode $gui_fpll_mode]
   if {$using_transceiver} {
      if { $gui_enable_manual_hssi_counters } {
#        set local_vco_freq [get_freq_in_mhz $gui_hssi_calc_output_clock_frequency]
        set local_vco_freq [get_freq_in_hz $gui_hssi_calc_output_clock_frequency]
        set result [expr $local_vco_freq * 2]
      } else {
          set local_vco_freq [get_freq_in_hz $gui_hssi_output_clock_frequency]
          set result [expr $local_vco_freq * 2]
      }
      ip_set "parameter.pll_datarate.value" "$result bps"
   } else {
      ip_set "parameter.pll_datarate.value" "0 Mbps"
   }


}

# +-----------------------------------
# | This function sets pll_cp_current_setting atom parameter
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_cp_current_setting {\
#    temp_bw_sel \
#   compensation_mode \
#    pll_m_counter \
#   pll_l_counter \
#   mcgb_div \
#   pma_width \
#} {
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_cp_current_setting"
#   }
#
#   set feedback_division [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
#                     $compensation_mode \
#                     $mcgb_div \
#                     $pma_width \
#                     $pll_m_counter \
#                     $pll_l_counter]
#   
#    set result [::altera_xcvr_fpll_vi::parameters::get_cp_bw_setting $temp_bw_sel $feedback_division]
#    
#   if {!$error_occurred_in_validation} {
#      array set result_array $result
#        ip_set "parameter.pll_cp_current_setting.value" $result_array(cp_current_setting)
#   }
#
#    if {$debug_message} {
#        puts "  result: $result"
#    }  
#}

# +-----------------------------------
# | This function sets pll_cp_lf_3rd_pole_freq atom parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_cp_lf_3rd_pole_freq {\
    temp_bw_sel \
	compensation_mode \
    pll_m_counter \
	pll_l_counter \
	mcgb_div \
	pma_width \
} {

	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_cp_lf_3rd_pole_freq"
	}

	set feedback_division [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
							$compensation_mode \
							$mcgb_div \
							$pma_width \
							$pll_m_counter \
							$pll_l_counter]
	
    set result [::altera_xcvr_fpll_vi::parameters::get_cp_bw_setting $temp_bw_sel $feedback_division]
    
	if {!$error_occurred_in_validation} {
		array set result_array $result
        ip_set "parameter.pll_cp_lf_3rd_pole_freq.value" $result_array(lf_3rd_pole_freq)
	}

    if {$debug_message} {
        puts "  result: $result"
    }  

}

# +-----------------------------------
# | This function sets pll_lf_resistance  atom parameter
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_lf_resistance {\
#    pll_m_counter \
#} {
#
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_lf_resistance"
#   }
#
#   if { $pll_m_counter <= 30 } { set result "lf_res_setting0" 
#        } else {                      set result "lf_res_setting1" 
#        } 
#
#        ip_set "parameter.pll_lf_resistance.value" $result
#
#    if {$debug_message} {
#        puts "  result: $result"
#    }  
#
#}
#
## +-----------------------------------
## | This function sets pll_cp_lf_order  atom parameter
## |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_cp_lf_order { } {
#
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_cp_lf_order"
#   }
#
#        ip_set "parameter.pll_cp_lf_order.value" "lf_2nd_order"
#
#    if {$debug_message} {
#        puts "  result: $result"
#    }  
#
#}
#
## +-----------------------------------
## | This function sets pll_lf_cbig  atom parameter
## |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_lf_cbig { } {
#
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_lf_cbig"
#   }
#
#        ip_set "parameter.pll_lf_cbig.value" "lf_cbig_setting4"
#
#    if {$debug_message} {
#        puts "  result: $result"
#    }  
#
#}
#
## +-----------------------------------
## | This function sets pll_lf_ripplecap atom parameter
## |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_lf_ripplecap {\
#    temp_bw_sel \
#   compensation_mode \
#    pll_m_counter \
#   pll_l_counter \
#   mcgb_div \
#   pma_width \
#} {
#
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_lf_ripplecap"
#   }
#
#   set feedback_division [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
#                     $compensation_mode \
#                     $mcgb_div \
#                     $pma_width \
#                     $pll_m_counter \
#                     $pll_l_counter]
#   
#    set result [::altera_xcvr_fpll_vi::parameters::get_cp_bw_setting $temp_bw_sel $feedback_division]
#    
#   if {!$error_occurred_in_validation} {
#      array set result_array $result
#        ip_set "parameter.pll_lf_ripplecap.value" $result_array(lf_ripplecap)
#   }
#
#    if {$debug_message} {
#        puts "  result: $result"
#    }  
#
#}

# +-----------------------------------
# | This function sets pll_vco_freq_band_0 atom parameter
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_vco_freq_band_0 { vco_frequency } {
#
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_vco_freq_band_0"
#   }
#
#   set local_vco_freq [get_freq_in_hz $vco_frequency]
#   set f_min_vco [obtain_f_min_vco]
#
#   obtain_band_limits "max_band_limits"
#
#   if       { $local_vco_freq >= $max_band_limits(7) }                                          { set result "pll_freq_band8" 
#   } elseif { $local_vco_freq >= $max_band_limits(6) && $local_vco_freq < $max_band_limits(7) } { set result "pll_freq_band7" 
#   } elseif { $local_vco_freq >= $max_band_limits(5) && $local_vco_freq < $max_band_limits(6) } { set result "pll_freq_band6" 
#   } elseif { $local_vco_freq >= $max_band_limits(4) && $local_vco_freq < $max_band_limits(5) } { set result "pll_freq_band5" 
#   } elseif { $local_vco_freq >= $max_band_limits(3) && $local_vco_freq < $max_band_limits(4) } { set result "pll_freq_band4"
#   } elseif { $local_vco_freq >= $max_band_limits(2) && $local_vco_freq < $max_band_limits(3) } { set result "pll_freq_band3"
#   } elseif { $local_vco_freq >= $max_band_limits(1) && $local_vco_freq < $max_band_limits(2) } { set result "pll_freq_band2"
#   } elseif { $local_vco_freq >= $max_band_limits(0) && $local_vco_freq < $max_band_limits(1) } { set result "pll_freq_band1"
#   } elseif { $local_vco_freq >= $f_min_vco          && $local_vco_freq < $max_band_limits(0) } { set result "pll_freq_band0"
#   } else   { return }
#
#   ip_set "parameter.pll_vco_freq_band_0.value" $result
#
#    if {$debug_message} {
#        puts "  result: $result"
#    }  
#
#}

# +-----------------------------------
# | This function sets pll_vco_freq_band_1 atom parameter
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_vco_freq_band_1 { vco_frequency } {
#
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_vco_freq_band_1"
#   }
#
#   set local_vco_freq [get_freq_in_hz $vco_frequency]
#   set f_min_vco [obtain_f_min_vco]
#
#   obtain_band_limits "max_band_limits"
#
#   if       { $local_vco_freq >= $max_band_limits(7) }                                          { set result "pll_freq_band8_1"
#   } elseif { $local_vco_freq >= $max_band_limits(6) && $local_vco_freq < $max_band_limits(7) } { set result "pll_freq_band7_1"
#   } elseif { $local_vco_freq >= $max_band_limits(5) && $local_vco_freq < $max_band_limits(6) } { set result "pll_freq_band6_1"
#   } elseif { $local_vco_freq >= $max_band_limits(4) && $local_vco_freq < $max_band_limits(5) } { set result "pll_freq_band5_1"
#   } elseif { $local_vco_freq >= $max_band_limits(3) && $local_vco_freq < $max_band_limits(4) } { set result "pll_freq_band4_1"
#   } elseif { $local_vco_freq >= $max_band_limits(2) && $local_vco_freq < $max_band_limits(3) } { set result "pll_freq_band3_1"
#   } elseif { $local_vco_freq >= $max_band_limits(1) && $local_vco_freq < $max_band_limits(2) } { set result "pll_freq_band2_1"
#   } elseif { $local_vco_freq >= $max_band_limits(0) && $local_vco_freq < $max_band_limits(1) } { set result "pll_freq_band1_1"
#   } elseif { $local_vco_freq >= $f_min_vco          && $local_vco_freq < $max_band_limits(0) } { set result "pll_freq_band0_1"
#   } else   { return }
#
#   ip_set "parameter.pll_vco_freq_band_1.value" $result
#
#    if {$debug_message} {
#        puts "  result: $result"
#    }  
#
#}

#convert units in mega (10^6) to base (10^0)
proc ::altera_xcvr_fpll_vi::parameters::mega_to_base { val } { 
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $val "" temp
  set temp [expr {wide(double($temp) * 1000000)}]
  return $temp
}

##############################################################################################################################################
#
# These numbers are pulled from the top of the file: p4/quartus/icd_data/nightfury/common/pm_cmu_fpll/bcmrbc/pm_cmu_fpll_atom.advanced.rbc.sv
#
# In the constraints:
# 
# constraint f_min_vco_rule
# constraint f_min_vax_rule
#
# ** Do not make changes here without having the same limit change in the RBC file. **
#
##############################################################################################################################################

proc ::altera_xcvr_fpll_vi::parameters::obtain_f_min_vco { \
	device_revision \
	gui_hssi_output_clock_frequency \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	cmu_fpll_is_otn \
	cmu_fpll_is_sdi \
	primary_use \
	gui_enable_low_f_support \
  gui_enable_50G_support \
} {
   set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
   set outclk_in_hz [ mega_to_base $gui_hssi_output_clock_frequency ]

   if {[::altera_xcvr_fpll_vi::parameters::is_production_device $device_revision]} {

      if [expr { ($primary_use == "core" && $gui_enable_50G_support) || $gui_enable_low_f_support }] {
         ip_set "parameter.cmu_fpll_f_min_vco.value" 4600000000
      } elseif [expr { ((($gui_hssi_prot_mode != 7) && ($outclk_in_hz >= 6250000000)) || (($gui_hssi_prot_mode == 7) && ($outclk_in_hz == 6000000000)) || ($cmu_fpll_is_otn == "true") || ($cmu_fpll_is_sdi == "true")) }] {
         ip_set "parameter.cmu_fpll_f_min_vco.value" 7000000000
      } else {
         ip_set "parameter.cmu_fpll_f_min_vco.value" 6000000000
      }
   } else {
      ip_set "parameter.cmu_fpll_f_min_vco.value" 3410943000
   }
}

proc ::altera_xcvr_fpll_vi::parameters::obtain_f_max_vco { \
	device_revision \
	gui_hssi_output_clock_frequency \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	cmu_fpll_is_otn \
	cmu_fpll_is_sdi \
} {

   set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
   set outclk_in_hz [ mega_to_base $gui_hssi_output_clock_frequency ]
   set using_core_mode [using_core_mode $gui_fpll_mode]

   if {[::altera_xcvr_fpll_vi::parameters::is_production_device $device_revision]} {
      if [expr { ((($gui_hssi_prot_mode != 7) && ($outclk_in_hz >= 6250000000)) || (($gui_hssi_prot_mode == 7) && ($outclk_in_hz == 6000000000)) || ($cmu_fpll_is_otn == "true") || ($cmu_fpll_is_sdi == "true") || ($using_core_mode == "true" )) }] {
         ip_set "parameter.cmu_fpll_f_max_vco.value" 14150000000
      } else {
         ip_set "parameter.cmu_fpll_f_max_vco.value" 12500000000
      }
   } else {
      ip_set "parameter.cmu_fpll_f_max_vco.value" 6821886000
   }
}

##############################################################################################################################################
proc ::altera_xcvr_fpll_vi::parameters::is_production_device { device_revision } {
    if { [regexp {es} $device_revision]} {
      return "false"
   } else {
      return "true"
   }
}

proc ::altera_xcvr_fpll_vi::parameters::obtain_band_limits { array_name } {

   upvar 1 $array_name max_band_limits

   array set max_band_limits {
      0 { 3861860000 }
      1 { 4287223000 }
      2 { 4688476000 }
      3 { 5072700000 }
      4 { 5423191000 }
      5 { 5762211000 }
      6 { 6075045000 }
      7 { 6374148000 }
      8 { 6653309000 }
   }

}

#
##############################################################################################################################################

proc ::altera_xcvr_fpll_vi::parameters::update_numeric_speed_grade { \
} {
	ip_set "parameter.numeric_speed_grade.value" 1
}

proc ::altera_xcvr_fpll_vi::parameters::update_device_speed_grade { \
	device_family \
    device \
} {
    set operating_temperature [::alt_xcvr::utils::device::get_a10_operating_temperature $device]
    set temp_pma_speed_grade [::alt_xcvr::utils::device::get_a10_pma_speedgrade $device]
    ip_message info "For the selected device($device), PLL speed grade is $temp_pma_speed_grade."

    set temp_pma_speed_grade "${operating_temperature}${temp_pma_speed_grade}"
    ip_set "parameter.device_speed_grade.value" $temp_pma_speed_grade
}

proc ::altera_xcvr_fpll_vi::parameters::update_device_family { \
	system_info_device_family \
} {
	#maybe do something here if the family changes upon opening the gui?
	
	ip_set "parameter.device_family.value" $system_info_device_family
}

proc ::altera_xcvr_fpll_vi::parameters::get_feedback_division {\
	compensation_mode \
	mcgb_div \
	pma_width \
	m_counter \
	l_counter \
} {
	if {$compensation_mode == "fpll_bonding"} {
		set feedback_division [expr {$l_counter * $mcgb_div * $pma_width / 2}]
	} else {
		set feedback_division $m_counter
	}

	return $feedback_division
}


proc ::altera_xcvr_fpll_vi::parameters::get_cp_bw_setting {\
    temp_bw_sel \
    pll_m_counter \
} {
	variable error_occurred_in_validation
	variable debug_message
	
	set ref_list [list -family "Arria 10" \
						-type "FPLL" \
						-m $pll_m_counter \
						-bw_setting $temp_bw_sel]

	if {$debug_message} {
		puts "  ref_list: $ref_list"
	}

    if {[catch {::quartus::pll::fpll_legality::get_physical_cp_bw_values $ref_list} result]} {
        ip_message error "IE: Error computing bw settings: $result"
        set error_occurred_in_validation true
    } else {
        return $result
    }
}

# +-----------------------------------
# | This function sets the new allowed ranges gui_refclk_cnt
# |
proc ::altera_xcvr_fpll_vi::parameters::update_gui_refclk_cnt { \
	enable_cascade_in \
	gui_refclk_cnt\
} { 

   # update gui_refclk_cnt range
   if {$enable_cascade_in} {
      ip_set "parameter.gui_refclk_cnt.ALLOWED_RANGES" {1}
	  if {$gui_refclk_cnt != 1} {
	    ip_message warning "When ATX to FPLL cascade clock input port is enabled, number of PLL reference clocks must first be set to 1"
      }
   } else {
      ip_set "parameter.gui_refclk_cnt.ALLOWED_RANGES" {1 2 3 4 5}
   }

}

# +-----------------------------------
# | This function sets the new allowed ranges based on given refclk_cnt
# |
proc ::altera_xcvr_fpll_vi::parameters::update_refclk_index { \
	gui_fpll_mode \
	gui_refclk_cnt \
} { 
	#no harm in setting this even if the feature is disabled

   # update refclk_index allowed range from 0 to gui_refclk_cnt-1
   set new_range 0
   for {set index 1} {$index < $gui_refclk_cnt} {incr index} {
      lappend new_range $index
   }
   ip_set "parameter.gui_refclk_index.ALLOWED_RANGES" $new_range
}

# +-----------------------------------
# | This function checks whether the user has inputted a totally illegal value for OUTCLK0
# |
proc ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk0_frequency { \
	gui_desired_outclk0_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::check_gui_outclk0_frequency"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 1}]
	if {!$gui_enable_manual_config && $using_core_mode && $enough_clocks_requested} {
		set result [check_user_inputted_frequency "outclk0" $gui_desired_outclk0_frequency]
		if {$result == "TCL_ERROR"} {
			set error_occurred_in_validation true
		}
	}
	
}

proc ::altera_xcvr_fpll_vi::parameters::using_core_mode {fpll_mode} {
	if {$fpll_mode == 0} {
		return true
	} else {
		return false
	}
}

proc ::altera_xcvr_fpll_vi::parameters::using_cascade_mode {fpll_mode} {
	if {$fpll_mode == 1} {
		return true
	} else {
		return false
	}
}

proc ::altera_xcvr_fpll_vi::parameters::using_hssi_mode {fpll_mode} {
	if {$fpll_mode == 2} {
		return true
	} else {
		return false
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_primary_use { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_primary_use"
	}
	
	switch $gui_fpll_mode {
		0 {
			set primary_use "core"
		}
		1 {
			set primary_use "iqtxrx"
		}
		2 {
			set primary_use "tx"
		}
		default {
			ip_message warning "Unexpected primary_use($gui_hssi_prot_mode), selecting tx"
			set primary_use "basic_tx"
			set error_occurred_in_validation true
			return
		}
	}	
	
	if {$debug_message} {
		puts "  primary_use->$primary_use"
	}
	
	ip_set "parameter.primary_use.value" $primary_use
}


proc ::altera_xcvr_fpll_vi::parameters::check_gui_desired_hssi_cascade_frequency {
	gui_desired_hssi_cascade_frequency \
	gui_fpll_mode \
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::check_gui_desired_hssi_cascade_frequency"
	}
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set result [check_user_inputted_frequency "transceiver cascade output clock" $gui_desired_hssi_cascade_frequency]
		if {$result == "TCL_ERROR"} {
			set error_occurred_in_validation true
		}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::get_actual_hssi_cascade_frequency  {} {

}

# | This function checks that counter phase alignment has not been selected when
# | in manual config for core
# |
proc ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_manual_hssi_counters { \
    gui_enable_manual_hssi_counters \
    gui_operation_mode \
} {
	if {$gui_operation_mode == 2 && $gui_enable_manual_hssi_counters} {
		ip_message error "Manual counter configuration cannot be selected when the operation mode is in feedback compensation bonding.  The operation mode must be set to direct"
		set error_occurred_in_validation true
	}
}

# | This function checks that counter phase alignment has not been selected when
# | in manual config for core
# |
proc ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_manual_config { \
    gui_enable_phase_alignment \
    gui_enable_manual_config \
} {
	if {$gui_enable_phase_alignment && $gui_enable_manual_config} {
		ip_message error "When selecting physical output clock parameters enable phase alignment must not be selected."
		set error_occurred_in_validation true
	}
}

# +-----------------------------------
# | This function checks that counter 1 has been correctly populated for phase alignment
# |
proc ::altera_xcvr_fpll_vi::parameters::check_gui_enable_phase_alignment { \
    gui_enable_phase_alignment \
	gui_enable_fractional \
	gui_pfd_frequency \
	gui_desired_outclk1_frequency \
	gui_actual_outclk1_frequency \
	full_actual_outclk1_frequency \
	gui_number_of_output_clocks \
	gui_fpll_mode \
	gui_enable_manual_config
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::check_gui_enable_phase_alignment"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 2}]
	if {$gui_enable_phase_alignment && $using_core_mode} {
	    if {!$enough_clocks_requested} {
		   ip_message error "For phase alignment, Number of clocks must be set to at least 2."
		   set error_occurred_in_validation true
		}

		if {$gui_enable_fractional} {
		   ip_message error "Phase alignment and Fractional mode cannot be enabled simultaneously"
		   set error_occurred_in_validation true
		}

	    if {$gui_pfd_frequency != $full_actual_outclk1_frequency} {
		   ip_message error "For phase alignment, use PFD Frequency value for outclk1 Actual frequency."
		   set error_occurred_in_validation true
		   #puts "outclk check"
		   #puts $gui_actual_outclk1_frequency
		   #puts $gui_desired_outclk1_frequency
		   #puts $gui_actual_outclk1_frequency.value
		}
	}
}

# +-----------------------------------
# | This function calculates the pfd frequency for core mode phase alignment
# |
proc ::altera_xcvr_fpll_vi::parameters::update_gui_pfd_frequency { \
    gui_reference_clock_frequency \
	pll_n_counter \
	gui_number_of_output_clocks \
	gui_fpll_mode \
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_gui_pfd_frequency"
	}
	
	set float_n_counter "$pll_n_counter.0"
	#puts "pfd calcs"
	#puts $gui_reference_clock_frequency
	#puts $pll_n_counter
	ip_set "parameter.gui_pfd_frequency.value" [expr {$gui_reference_clock_frequency/$float_n_counter}]
}

# +-----------------------------------
# | This function checks whether the user has inputted a totally illegal value for OUTCLK1
# |
proc ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk1_frequency { \
	gui_desired_outclk1_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::check_gui_outclk1_frequency"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 2}]
	if {!$gui_enable_manual_config && $using_core_mode && $enough_clocks_requested} {
		set result [check_user_inputted_frequency "outclk1" $gui_desired_outclk1_frequency]
		if {$result == "TCL_ERROR"} {
			set error_occurred_in_validation true
		}
	}
	
}

# +-----------------------------------
# | This function checks whether the user has inputted a totally illegal value for OUTCLK2
# |
proc ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk2_frequency { \
	gui_desired_outclk2_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::check_gui_outclk2_frequency"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 3}]
	if {!$gui_enable_manual_config && $using_core_mode && $enough_clocks_requested} {
		set result [check_user_inputted_frequency "outclk2" $gui_desired_outclk2_frequency]
		if {$result == "TCL_ERROR"} {
			set error_occurred_in_validation true
		}
	}
	
}

# +-----------------------------------
# | This function checks whether the user has inputted a totally illegal value for OUTCLK2
# |
proc ::altera_xcvr_fpll_vi::parameters::check_gui_desired_outclk3_frequency { \
	gui_desired_outclk3_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::check_gui_outclk3_frequency"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 4}]
	if {!$gui_enable_manual_config && $using_core_mode && $enough_clocks_requested} {
		set result [check_user_inputted_frequency "outclk3" $gui_desired_outclk3_frequency]
		if {$result == "TCL_ERROR"} {
			set error_occurred_in_validation true
		}
	}
	
}

proc ::altera_xcvr_fpll_vi::parameters::check_gui_pll_dsm_fractional_division { \
	gui_pll_dsm_fractional_division \
	gui_fractional_x \
	gui_enable_fractional \
	gui_enable_manual_config \
} {
	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters_check_gui_pll_dsm_fractional_division"
	}

	if {$gui_enable_fractional && $gui_enable_manual_config} {
		
		set ref_list [list -x $gui_fractional_x]
		if {[catch {::quartus::pll::fpll_legality::get_legal_k_range $ref_list} result]} {
			set error_occurred_in_validation true
			set error_message "IE: Error getting legal k range. ($result)"
			ip_message error $error_message
		} else {
			array set result_array $result
			set k_min $result_array(k_min)
			set k_max $result_array(k_max)
			
			if {![::altera_xcvr_fpll_vi::parameters::is_value_within_range $gui_pll_dsm_fractional_division $k_min $k_max]} {
				set error_message "Fractional division value ($gui_pll_dsm_fractional_division) is out of range. Legal range: $k_min - [expr {round($k_max)}]"
				set error_occurred_in_validation true
				ip_message error $error_message
			}			
		}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::get_gui_fractional_f { \
	gui_pll_dsm_fractional_division \
	gui_fractional_x \
} {

	variable debug_message
	variable error_occurred_in_validation
	
	set ref_list [list -x $gui_fractional_x \
						-k $gui_pll_dsm_fractional_division]
	if {[catch {::quartus::pll::fpll_legality::compute_f_factor $ref_list} result]} {
		set error_occurred_in_validation true
		set error_message "Error computing fractional f"
		puts $result
		ip_message error $error_message
	} else {
		array set result_array $result 
		set f_val [::altera_xcvr_fpll_vi::parameters::round_to_n_decimals $result_array(f) 4]
		ip_set "parameter.gui_fractional_f.value" $f_val
	}
}


# +-----------------------------------
# | This function checks whether the user has inputted a totally illegal value for Transceiver
# |
proc ::altera_xcvr_fpll_vi::parameters::check_gui_hssi_output_clock_frequency { \
	gui_desired_hssi_cascade_frequency \
	gui_hssi_output_clock_frequency \
	gui_fpll_mode \
	enable_cascade_in \
	gui_enable_low_f_support \
    gui_hssi_prot_mode \
    gui_desired_refclk_frequency \
} {
	variable debug_message
	variable error_occurred_in_validation
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::check_gui_hssi_output_clock_frequency"
	}
	
	set using_transceiver [using_hssi_mode $gui_fpll_mode]
	if {$using_transceiver} {      
	  set result [check_user_inputted_frequency "transceiver output clock" $gui_hssi_output_clock_frequency]
	  if {$result == "TCL_ERROR"} {
	  	set error_occurred_in_validation true
      } elseif { $gui_hssi_prot_mode == 9 } { 
        if { $gui_hssi_output_clock_frequency != 3000 } { 
			   ip_message error "When used as as a transceiver in SATA GEN 3 mode, PLL output clock frequency must be set to 3000 MHz."
	       }
      } else {
	      if { $gui_hssi_output_clock_frequency > 750 && $gui_enable_low_f_support && $gui_desired_refclk_frequency < 50 } { 
		  	ip_message error "When used as a transceiver clock source with an output frequency greater than 750MHz the reference clock should be set to 50MHz or greater."
	      }
	  }
### FB case 249378 - Set Fmin of HSSI PLL IP to be 500 Mhz - put output_clock_frequency limit as 500 Mhz, give error if frequency is > 500 MHz
	    set fmin 499.999

##############################################################################################################################################
#
# These numbers are pulled from the top of the file: p4/quartus/icd_data/nightfury/common/pm_cmu_fpll/bcmrbc/pm_cmu_fpll_atom.advanced.rbc.sv
#
# In the constraints:
# 
# `define f_max_fout_value 36'd6250000000
# `define f_max_fout_cascade_value 36'd7012500000

	    set fmax 6250.0
		if { $enable_cascade_in } {
	   	 set fmax 7075.0
        }

# ** Do not make changes here without having the same limit change in the RBC file. **
#
##############################################################################################################################################

	    if {$gui_hssi_output_clock_frequency < $fmin} {
			ip_message error "Error validating hssi output clock frequency. Output clock frequency needs to be equal to or greater than 500 Mhz. Please enter a valid frequency."		
	    }

	    if {$gui_hssi_output_clock_frequency > $fmax} {
			ip_message error "Error validating hssi output clock frequency. Output clock frequency needs to be equal to or less than ${fmax} Mhz. Please enter a valid frequency."		
	    }
	}
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
# We should limit the cascade out frequency to the Fmax of the IQTXRX clock network
	    set fmax 800.0
	    if {$gui_desired_hssi_cascade_frequency > $fmax} {
			ip_message error "Error validating hssi cascade frequency. HSSI cascade frequency needs to be equal to or less than ${fmax} Mhz. Please enter a valid frequency."		
	    }
	}
}

proc ::altera_xcvr_fpll_vi::parameters::get_actual_hssi_output_clock_frequency { \
	gui_fpll_mode \
	gui_reference_clock_frequency \
	compensation_mode \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	gui_fractional_x \
	device_family \
} {
	# variable debug_message
	# variable error_occurred_in_validation
	# variable error_message 
	
	# if {$error_occurred_in_validation} {
		# ::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_hssi_clock_frequency "N/A" "N/A"
		# return
	# }	
	
	# set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	# if {$using_hssi_mode} {
		# set family $device_family
		# set type "FPLL"
		# set speedgrade 1
		# set refclk_freq $gui_reference_clock_frequency
		# set is_fractional $gui_enable_fractional
		# set is_counter_cascading_enabled false
		# set x $gui_fractional_x
		
		# array set desired_clock_list [list]	
		# set outclk_data [list -type l -index 0 -freq $gui_hssi_output_clock_frequency]
		# set clock_id 0
		# ::quartus::pll::legality::add_outclk_to_basic_input_list desired_clock_list $clock_id $outclk_data
				
		# set ref_list [list 	-family $family \
							# -type $type \
							# -speedgrade $speedgrade \
							# -refclk_freq $refclk_freq \
							# -is_fractional $is_fractional \
							# -compensation_mode $compensation_mode \
							# -is_counter_cascading_enabled $is_counter_cascading_enabled \
							# -x $x \
							# -validated_counter_values [list] \
							# -desired_counter_values [array get desired_clock_list]]	
		# if {$debug_message} {
			# puts "  ref_list: \n  $ref_list"
		# }		
		
		# if {[catch {::quartus::pll::legality::retrieve_output_clock_frequency_list $ref_list} result]} {
			# set error_occurred_in_validation true
			# set error_message "Error validating hssi output clock frequency. Please enter a valid frequency."
			# ip_message error $error_message
		# } else {
			# array set result_array $result
			# set freq_value $result_array(closest_freq)
			# set freq_range $result_array(freq)	
			
			# set rounded_new_freq_range [round_freq $freq_range]
			# set rounded_new_freq_value [round_freq $freq_value]
			# ::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_hssi_clock_frequency $rounded_new_freq_range $rounded_new_freq_value
			# ip_set "parameter.full_actual_hssi_clock_frequency.ALLOWED_RANGES" $freq_range					
		# }
			
	# } else {
		# ::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_hssi_clock_frequency "N/A" "N/A"	
	# }
} 

proc ::altera_xcvr_fpll_vi::parameters::check_user_inputted_frequency { param_name param_value } {
	set ret_val TCL_SUCCESS
	
	if {$param_value < 0} {
		ip_message error "Illegal desired frequency for $param_name. Please enter a positive frequency."
		set ret_val TCL_ERROR
	}
	if {$param_value == 0} {
		ip_message error "Illegal desired frequency for $param_name. Please enter a non-zero frequency."
		set ret_val TCL_ERROR
	}
	
	return $ret_val
	
}

# +-----------------------------------
# | Test callback from gui_desired_outclk1_frequency
# |
proc ::altera_xcvr_fpll_vi::parameters::test_single_parameter_callback { args } {
  ::altera_xcvr_fpll_vi::parameters::get_actual_outclk1_frequency_values
  #set_parameter_value "gui_actual_outclk1_frequency.value" 100	
  set_parameter_value gui_actual_outclk1_frequency 100	
  #puts "setting default value"
}
#set_parameter_update_callback ::altera_xcvr_fpll_vi::parameters::parameters::gui_desired_outclk1_frequency ::altera_xcvr_fpll_vi::parameters::test_single_parameter_callback]

# +-----------------------------------
# | This function returns a list of valid output clock frequency for OUTCLK0
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_outclk0_frequency_values { \
	gui_fpll_mode \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	gui_pll_c_counter_0 \
	gui_desired_outclk0_frequency \
	device_family \
	core_vco_frequency_adv \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 0
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk${outclk_index}_frequency "N/A" "N/A"
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks > $outclk_index}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_outclk${outclk_index}_frequency_values"
		}
		
		# array set desired_clock_list [list]
		if {$gui_enable_manual_config} {
			set c_counter_list [list 0 $gui_pll_c_counter_0]
			
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				$gui_fractional_x \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
														
		} else {
			set c_counter_list [list 0 $gui_desired_outclk0_frequency]
			
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				$gui_fractional_x \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
		}
											
		if {$error_occurred_in_validation} {
			ip_message error $error_message	
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk0_frequency "N/A" "N/A"			
		} else {
			array set result_array $result
			set freq_value $result_array(freq_value)
			set freq_range $result_array(freq_range)
			
			set rounded_new_freq_range [round_freq $freq_range]
			set rounded_new_freq_value [round_freq $freq_value]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk0_frequency $rounded_new_freq_range $rounded_new_freq_value
			ip_set "parameter.full_actual_outclk0_frequency.ALLOWED_RANGES" $freq_range
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n  [get_parameter_property gui_actual_outclk0_frequency ALLOWED_RANGES]"
			puts "  new value: \n  [get_parameter_value gui_actual_outclk0_frequency]"
			puts "  new full range: \n  [get_parameter_property full_actual_outclk0_frequency ALLOWED_RANGES]"
			#puts "  new full value: \n  [get_parameter_value full_actual_outclk0_frequency]"
		}	
		
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk0_frequency "N/A" "N/A"
		#ip_set "parameter.gui_actual_outclk0_frequency.allowed_ranges" { "0.0 MHz" "100.0 MHz" "200.0 MHz"}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk0_frequency_value { \
	gui_actual_outclk0_frequency \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk0_frequency_value"
	}
	set new_selected_value [get_parameter_value gui_actual_outclk0_frequency]
	set new_selected_range [get_parameter_property gui_actual_outclk0_frequency ALLOWED_RANGES]
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_freq_range [get_parameter_property full_actual_outclk0_frequency ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_freq_range $new_index]
			
	ip_set "parameter.full_actual_outclk0_frequency.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::get_displayed_value_index {range value} {
	for {set i 0} {$i < [llength $range]} {incr i} {
		set element [lindex $range $i]
		set split_element [split $element ":"]
		if {[llength $split_element] > 1} {
			set qsys_element [lindex $split_element 0]
		} else {
			set qsys_element $element
		}
		if {$qsys_element == $value} {
			set selected_index $i
		}
	}
	return $selected_index 
}

proc round_freq {input_list} {
#set n_decimals 6
	set n_decimals 6
	return [altera_xcvr_fpll_vi::parameters::round_to_n_decimals $input_list $n_decimals]
}

proc round_phase {input_list} {
#set n_decimals 6
	set n_decimals 6
	return [altera_xcvr_fpll_vi::parameters::round_to_n_decimals $input_list $n_decimals]
}

proc altera_xcvr_fpll_vi::parameters::round_to_n_decimals {input_list n {keep_decimal true}} {
	set rounded_list [list]
	foreach item $input_list {
		set rounded_num [format "%.${n}f" $item]
		if {$keep_decimal} {
			set double_version [expr {double($rounded_num)}]
			if {[string length $double_version] <= [string length $rounded_num]} {
				lappend rounded_list $double_version
			} else  {
				lappend rounded_list $rounded_num
			}
		} else {
			lappend rounded_list $rounded_num
		}
		
		#lappend rounded_list [format "%.${n}f" $item]
		
	}
	return $rounded_list
}

proc ::altera_xcvr_fpll_vi::parameters::append_unit_to_each_element { range unit} {
	#puts "in range: $range"
	set list_with_unit ""
	foreach element $range {
		lappend list_with_unit "$element $unit"
	}
	regsub -all {\{} $list_with_unit {"} list_with_unit 
	regsub -all {\}} $list_with_unit {"} list_with_unit 
	
	#puts "out range: $list_with_unit"
	return $list_with_unit
}

proc ::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_basic { \
	family \
	type \
	speedgrade \
	refclk_freq \
	is_fractional \
	compensation_mode \
	is_counter_cascading_enabled \
	x \
	clock_index \
	c_counter_list \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional\
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable error_occurred_in_validation
	variable error_message
	variable debug_message 

	array set desired_clock_list [list]	
	array set validated_clock_list [list]	

    # WJ:
	if {$debug_message} {
           puts "======================WJ=============="
           puts $device_revision
           puts $primary_use
           puts $gui_enable_fractional
	   puts $compensation_mode
        }

	foreach {counter_index counter_value} $c_counter_list {
		set outclk_data [list -type c -index $counter_index -freq $counter_value]
		set clock_id $counter_index
		if {$counter_index < $clock_index} {
			::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list $clock_id $outclk_data
		} elseif {$counter_index == $clock_index} {
			::quartus::pll::fpll_legality::add_outclk_to_basic_input_list desired_clock_list $clock_id $outclk_data
		} else {
			error "Violating clock precedence"
		}
	}	

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

	set ref_list [list 	-family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-is_counter_cascading_enabled $is_counter_cascading_enabled \
						-x $x \
						-validated_counter_values [array get validated_clock_list] \
						-desired_counter_values [array get desired_clock_list] \
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						]


	
	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}
	if {[catch {::quartus::pll::fpll_legality::retrieve_output_clock_frequency_list $ref_list} result]} {
		set error_occurred_in_validation true
#		set error_message "Error validating ouptut clock $outclk_index frequency. Please enter a valid frequency."
		set error_message "Error validating output clock frequency. Please enter a valid frequency."
		#old message: "Please specify correct outclk0 desired output frequency."
	} else {
		array set result_array $result
		set new_actual_freq_value $result_array(closest_freq)
		set new_actual_freq_range $result_array(freq)
		
		array set new_result_array [list freq_value $new_actual_freq_value freq_range $new_actual_freq_range]
	}	
	
	return [array get new_result_array]
}

proc ::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_advanced {
	family \
	type \
	speedgrade \
	refclk_freq \
	is_fractional \
	compensation_mode \
	x \
	m \
	n \
	k \
	clock_index \
	c_counter_list \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional\
	primary_use\
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable error_occurred_in_validation
	variable error_message
	variable debug_message 

	array set desired_clock_list [list]
	
	foreach {counter_index counter_value} $c_counter_list {
		set outclk_data [list -type c -index $counter_index -cdiv $counter_value]
		set clock_id $counter_index
		::quartus::pll::fpll_legality::add_outclk_to_advanced_input_list desired_clock_list $clock_id $outclk_data		
	}

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list 	-family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-x $x \
						-m $m \
						-n $n \
						-k $k \
						-clock_index $clock_index \
						-validated_counter_values [array get desired_clock_list]\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						]


	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}
	if {[catch {::quartus::pll::fpll_legality::compute_output_counter_frequency $ref_list} result]} {
		set error_occurred_in_validation true
		set error_message "Error validating output clock $clock_index frequency. Please enter a valid C counter setting."
	} else {
		array set result_array $result
		set new_actual_freq_value $result_array(counter_frequency)
		set new_actual_freq_range $result_array(counter_frequency)
		array set new_result_array [list freq_value $new_actual_freq_value freq_range $new_actual_freq_range]
	}		

	return [array get new_result_array]
}

# +-----------------------------------
# | This function returns a list of valid output clock frequency for OUTCLK1
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_outclk1_frequency_values { \
	gui_fpll_mode \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	full_actual_outclk0_frequency \
	gui_desired_outclk1_frequency \
	device_family \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
    	device_revision \
    	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 1
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk1_frequency "N/A" "N/A"
		return
	}
	
	if {$debug_message} {
           puts "====================WJ=================="
           puts $gui_fpll_mode
           puts $device_family
           puts $primary_use
           puts $compensation_mode
        }

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 2}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_outclk1_frequency_values"
		}
	
		if {$gui_enable_manual_config} {
			set c_counter_list [list 0 $gui_pll_c_counter_0 \
									 1 $gui_pll_c_counter_1 ]
									 
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				$gui_fractional_x \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
    				$device_revision \
    				$gui_enable_fractional\
    				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			
		} else {
			set c_counter_list [list 0 $full_actual_outclk0_frequency \
									 1 $gui_desired_outclk1_frequency]
			
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				$gui_fractional_x \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			
		}
		
		if {$error_occurred_in_validation} {
			ip_message error $error_message		
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk1_frequency "N/A" "N/A"	
		} else {
			array set result_array $result
			set freq_value $result_array(freq_value)
			set freq_range $result_array(freq_range)
			
			set rounded_new_freq_range [round_freq $freq_range]
			set rounded_new_freq_value [round_freq $freq_value]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk1_frequency $rounded_new_freq_range $rounded_new_freq_value
			ip_set "parameter.full_actual_outclk1_frequency.ALLOWED_RANGES" $freq_range		
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n  [get_parameter_property gui_actual_outclk1_frequency ALLOWED_RANGES]"
			puts "  new value: \n  [get_parameter_value gui_actual_outclk1_frequency]"
			puts "  new full range: \n  [get_parameter_property full_actual_outclk1_frequency ALLOWED_RANGES]"			
		}	
		
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk1_frequency "N/A" "N/A"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk1_frequency_value { \
	gui_actual_outclk1_frequency \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk1_frequency_value"
	}
	set new_selected_value [get_parameter_value gui_actual_outclk1_frequency]
	set new_selected_range [get_parameter_property gui_actual_outclk1_frequency ALLOWED_RANGES]
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_freq_range [get_parameter_property full_actual_outclk1_frequency ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_freq_range $new_index]
			
	ip_set "parameter.full_actual_outclk1_frequency.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

# +-----------------------------------
# | This function returns a list of valid output clock frequency for OUTCLK2
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_outclk2_frequency_values { \
	gui_fpll_mode \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	gui_desired_outclk2_frequency \
	device_family \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 2
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk2_frequency "N/A" "N/A"
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 2}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_outclk2_frequency_values"
		}
	
		if {$gui_enable_manual_config} {
			set c_counter_list [list 0 $gui_pll_c_counter_0 \
									 1 $gui_pll_c_counter_1 \
									 2 $gui_pll_c_counter_2]
									 
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				$gui_fractional_x \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			
		} else {
			set c_counter_list [list 0 $full_actual_outclk0_frequency \
									 1 $full_actual_outclk1_frequency \
									 2 $gui_desired_outclk2_frequency]
			
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				$gui_fractional_x \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
				
						
		}
		
		if {$error_occurred_in_validation} {
			ip_message error $error_message		
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk2_frequency "N/A" "N/A"	
		} else {
			array set result_array $result
			set freq_value $result_array(freq_value)
			set freq_range $result_array(freq_range)
			
			set rounded_new_freq_range [round_freq $freq_range]
			set rounded_new_freq_value [round_freq $freq_value]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk2_frequency $rounded_new_freq_range $rounded_new_freq_value
			ip_set "parameter.full_actual_outclk2_frequency.ALLOWED_RANGES" $freq_range		
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n  [get_parameter_property gui_actual_outclk2_frequency ALLOWED_RANGES]"
			puts "  new value: \n  [get_parameter_value gui_actual_outclk2_frequency]"
			puts "  new full range: \n  [get_parameter_property full_actual_outclk2_frequency ALLOWED_RANGES]"			
		}	
		
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk2_frequency "N/A" "N/A"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk2_frequency_value { \
	gui_actual_outclk2_frequency \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk2_frequency_value"
	}
	set new_selected_value [get_parameter_value gui_actual_outclk2_frequency]
	set new_selected_range [get_parameter_property gui_actual_outclk2_frequency ALLOWED_RANGES]
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_freq_range [get_parameter_property full_actual_outclk2_frequency ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_freq_range $new_index]
			
	ip_set "parameter.full_actual_outclk2_frequency.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

# +-----------------------------------
# | This function returns a list of valid output clock frequency for OUTCLK3
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_outclk3_frequency_values { \
	gui_fpll_mode \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	gui_desired_outclk3_frequency \
	device_family \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 3
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk3_frequency "N/A" "N/A"
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks >= 2}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_outclk3_frequency_values"
		}
	
		if {$gui_enable_manual_config} {
			set c_counter_list [list 0 $gui_pll_c_counter_0 \
									 1 $gui_pll_c_counter_1 \
									 2 $gui_pll_c_counter_2 \
									 3 $gui_pll_c_counter_3]
									 
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				$gui_fractional_x \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list\
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			
			
		} else {
			set c_counter_list [list 0 $full_actual_outclk0_frequency \
									 1 $full_actual_outclk1_frequency \
									 2 $full_actual_outclk2_frequency \
									 3 $gui_desired_outclk3_frequency]
			
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_frequency_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				$gui_fractional_x \
				$outclk_index \
				$c_counter_list\
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
						
		}
		
		if {$error_occurred_in_validation} {
			ip_message error $error_message		
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk3_frequency "N/A" "N/A"	
		} else {			
			array set result_array $result
			set freq_value $result_array(freq_value)
			set freq_range $result_array(freq_range)
		
			set rounded_new_freq_range [round_freq $freq_range]
			set rounded_new_freq_value [round_freq $freq_value]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk3_frequency $rounded_new_freq_range $rounded_new_freq_value
			ip_set "parameter.full_actual_outclk3_frequency.ALLOWED_RANGES" $freq_range		
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n  [get_parameter_property gui_actual_outclk3_frequency ALLOWED_RANGES]"
			puts "  new value: \n  [get_parameter_value gui_actual_outclk3_frequency]"
			puts "  new full range: \n  [get_parameter_property full_actual_outclk3_frequency ALLOWED_RANGES]"			
		}	
		
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_outclk3_frequency "N/A" "N/A"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk3_frequency_value { \
	gui_actual_outclk3_frequency \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk3_frequency_value"
	}
	set new_selected_value [get_parameter_value gui_actual_outclk3_frequency]
	set new_selected_range [get_parameter_property gui_actual_outclk3_frequency ALLOWED_RANGES]
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_freq_range [get_parameter_property full_actual_outclk3_frequency ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_freq_range $new_index]
			
	ip_set "parameter.full_actual_outclk3_frequency.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

# +-----------------------------------
# | This function checks whether a value lies within a given range
# |
proc ::altera_xcvr_fpll_vi::parameters::is_value_within_range { value range_min range_max } {
	if {$value < $range_min} {
		return false
	}
	if {$value > $range_max} {
		return false
	}
	return true
}

proc ::altera_xcvr_fpll_vi::parameters::validate_reference_clock_frequency { \
	gui_reference_clock_frequency \
	device_family \
	numeric_speed_grade \
	gui_enable_fractional \
	gui_fpll_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	compensation_mode\
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	# check on whether refclk is within the spec
	variable error_occurred_in_validation
	variable debug_message	

	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::validate_reference_clock_frequency"
	}	
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {!$using_core_mode} {
		return
	}
	
	
	set family $device_family
	set speedgrade $numeric_speed_grade 
	set type "FPLL"
	set is_fractional $gui_enable_fractional

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

	set ref_list [list 	-family $family \
				-type $type \
				-speedgrade $speedgrade \
				-is_fractional $is_fractional \
				-f_min_vco $f_min_vco_mhz\
				-f_max_vco $f_max_vco_mhz\
				-f_min_pfd $f_min_pfd_mhz\
				-f_max_pfd $f_max_pfd_mhz\
				-device $device_revision \
                -primary_use $primary_use\
				]

	if {$debug_message} {
        puts "  ref_list: \n$ref_list"
    }

	
	if { [catch {::quartus::pll::fpll_legality::get_legal_refclk_range $ref_list} result] } {
		send_message error "Error retrieving reference clock frequency range"
		set error_occurred_in_validation true
	} else {
		array set result_array $result
		set legal_refclk_min $result_array(refclk_min) 
		set legal_refclk_max $result_array(refclk_max)
		if {![::altera_xcvr_fpll_vi::parameters::is_value_within_range $gui_reference_clock_frequency $legal_refclk_min $legal_refclk_max]} {
			set error_occurred_in_validation true
			send_message error "$gui_reference_clock_frequency MHz is an illegal reference clock frequency. Legal range: $legal_refclk_min MHz - $legal_refclk_max MHz"
		}	
	}	
}

# +-----------------------------------
# | This function sets the reference clock frequency parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_reference_clock_frequency { 
	gui_reference_clock_frequency \
	gui_fpll_mode \
	full_actual_refclk_frequency \
} {
	variable error_occurred_in_validation
	variable debug_message
	
	if {$error_occurred_in_validation} {
		return 
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_reference_clock_frequency"
	}	
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	
	if {$using_core_mode} {
		set reference_clock_frequency_to_set $gui_reference_clock_frequency
	} else {
		set reference_clock_frequency_to_set $full_actual_refclk_frequency
	}	
	
	ip_set "parameter.reference_clock_frequency.value" "$reference_clock_frequency_to_set MHz"

	if {$debug_message} {
		puts "  reference_clock_frequency-> $reference_clock_frequency_to_set MHz"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::strip_of_MHz {value} {
	regsub -all { MHz} $value "" new_value
	return $new_value
}

proc ::altera_xcvr_fpll_vi::parameters::strip_of_ps {value} {
	regsub -all { ps} $value "" new_value
	return $new_value
}


proc ::altera_xcvr_fpll_vi::parameters::is_phase_unit_degrees {unit} {
	if {$unit == 1} {
		return true
	} elseif {$unit == 0} {
		return false
	} else {
		puts "unit: $unit"
		error "IE: Unknown phase unit!!!"
	}
}

# +-----------------------------------
# | This function sets the reference clock1 frequency parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_reference_clock1_frequency { \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_refclk_switch \
	gui_refclk1_frequency \
	gui_enable_fractional \
	gui_reference_clock_frequency \
	compensation_mode \
	gui_enable_manual_config \
	gui_fpll_mode
	gui_number_of_output_clocks \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_n_counter \
	gui_pll_m_counter \
	gui_pll_dsm_fractional_division \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision\
	primary_use\
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$gui_fpll_mode != 0 || !$gui_refclk_switch} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_reference_clock1_frequency"
	}
	
	set family $device_family
	set speedgrade $numeric_speed_grade 
	set type "FPLL"
	
	set refclk_freq $gui_reference_clock_frequency
	set refclk1_freq $gui_refclk1_frequency
	set is_fractional $gui_enable_fractional
	set is_counter_cascading_enabled false
	set compensation_mode $compensation_mode	
	set x $gui_fractional_x
	set m $gui_pll_m_counter
	set n $gui_pll_n_counter
	set k $gui_pll_dsm_fractional_division

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

	if {$gui_enable_manual_config} {
		array set validated_clocks [::altera_xcvr_fpll_vi::parameters::get_validated_counter_values_advanced \
								$gui_pll_c_counter_0 \
								$gui_pll_c_counter_1 \
								$gui_pll_c_counter_2 \
								$gui_pll_c_counter_3 \
								$full_outclk0_actual_phase_shift \
								$full_outclk1_actual_phase_shift \
								$full_outclk2_actual_phase_shift \
								$full_outclk3_actual_phase_shift \
								$gui_number_of_output_clocks ]
		set ref_list [list 	-family $family \
			-type $type \
			-speedgrade $speedgrade \
			-is_fractional $is_fractional \
			-refclk_freq $refclk_freq \
			-refclk1_freq $refclk1_freq \
			-x $x \
			-m $m \
			-n $n \
			-k $k \
			-compensation_mode $compensation_mode \
			-validated_counter_settings [array get validated_clocks] \
            -f_min_vco $f_min_vco_mhz\
            -f_max_vco $f_max_vco_mhz\
            -f_min_pfd $f_min_pfd_mhz\
            -f_max_pfd $f_max_pfd_mhz\
		    -device $device_revision \
            -primary_use $primary_use\
			]

	} else {
		array set validated_clocks [::altera_xcvr_fpll_vi::parameters::get_validated_counter_values_basic \
								$full_actual_outclk0_frequency \
								$full_actual_outclk1_frequency \
								$full_actual_outclk2_frequency \
								$full_actual_outclk3_frequency \
								$full_outclk0_actual_phase_shift \
								$full_outclk1_actual_phase_shift \
								$full_outclk2_actual_phase_shift \
								$full_outclk3_actual_phase_shift \
								$gui_number_of_output_clocks ]
		set ref_list [list 	-family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-refclk1_freq $refclk1_freq \
						-is_fractional $is_fractional \
						-is_counter_cascading_enabled $is_counter_cascading_enabled \
						-compensation_mode $compensation_mode \
						-validated_counter_settings [array get validated_clocks] \
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						] 

	}

	if {$debug_message} {
		puts "  ref_list: \n$ref_list"
	}

	if {[catch {::quartus::pll::fpll_legality::validate_secondary_refclk_frequency $ref_list} result]} {
		send_message error "$gui_refclk1_frequency MHz is illegal reference clock frequency to use as second reference clock frequency for Clock Switchover feature"	
	}

	#ALTERA HACK - Stolen from IOPLL. This should be dealt with in IPTAF. 
	set relative_diff [expr abs($refclk1_freq - $refclk_freq) / $refclk_freq]
	if { $refclk1_freq != $refclk_freq } {
		ip_message WARNING "The second reference clock frequency is different from the primary reference clock. You must run TimeQuest at both frequencies to ensure timing closure."
	}
	# The following warnings come from from section 12.2 of the SV PLL NPP.  We expect this to be the same for NF IOPLL.
	if {$relative_diff > 0.20} {
		ip_message WARNING "The frequency difference between 'refclk' and 'refclk1' exceeds 20%: Automatic clock loss detection will not work."
		ip_message WARNING "The frequency difference between 'refclk' and 'refclk1' exceeds 20%: The 'clkbad' signals are now invalid."
	}
	
	if {$debug_message} {
		puts "  result: \n$result"
	}	
	
}

# +-----------------------------------
# | This function sets the switchover parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::get_switchover_mode_settings { gui_fpll_mode gui_refclk_switch gui_switchover_mode gui_switchover_delay} {
	if {$gui_fpll_mode == 0 && $gui_refclk_switch} {
		set pll_clk_sw_dly $gui_switchover_delay
		set pll_clk_loss_sw_en true
		switch $gui_switchover_mode {
			"Manual Switchover" {
				set pll_auto_clk_sw_en false
				set pll_manu_clk_sw_en true
				set gui_enable_extswitch true
			}	
			"Automatic Switchover" {
				set pll_auto_clk_sw_en true
				set pll_manu_clk_sw_en false
				set gui_enable_extswitch false
			}
			"Automatic Switchover with Manual Override" {
				set pll_auto_clk_sw_en true
				set pll_manu_clk_sw_en true
				set gui_enable_extswitch true		
			}
		}
	} else {
		set pll_auto_clk_sw_en false
		set pll_manu_clk_sw_en false
		set gui_enable_extswitch false
		set pll_clk_loss_sw_en false
		set pll_clk_sw_dly 0
	}
	
	return [list pll_auto_clk_sw_en $pll_auto_clk_sw_en \
				pll_manu_clk_sw_en $pll_manu_clk_sw_en \
				gui_enable_extswitch $gui_enable_extswitch \
				pll_clk_loss_sw_en $pll_clk_loss_sw_en \
				pll_clk_sw_dly $pll_clk_sw_dly]
				
}

proc ::altera_xcvr_fpll_vi::parameters::get_switchover_mode {param_to_check gui_switchover_mode} {
	# switch $gui_switchover_mode {
		# "Manual Switchover" {
			# set manual 	true
			# set auto 	false
			# set 
		# }
	# }
}

proc ::altera_xcvr_fpll_vi::parameters::get_desired_clock_index {desired_clock_list type {index 0}} {
	# variable debug_message
	# array set desired_clock_array $desired_clock_list
	# foreach unique_index [array names desired_clock_array] {
		# array set clock_data $desired_clock_array($unique_index)
		# if {$clock_data(-type) == $type && $clock_data(-index) == $index} {
			# if {$debug_message} {
				# puts "UNIQUE INDEX: $unique_index"
			# }
			# return $unique_index
		# }
	# }
	# error "You asked for a bad index/type combo. The desired clock list doesn't contain such an element."
}

# +-----------------------------------
# | This function sets the hssi output clock frequency parameter
# | This clock has priority over the core clocks
# |
proc ::altera_xcvr_fpll_vi::parameters::update_hssi_output_clock_frequency { \
	gui_fpll_mode \
	gui_hssi_output_clock_frequency \
    gui_enable_manual_hssi_counters \
    gui_hssi_calc_output_clock_frequency \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_output_clock_frequency"
	}
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {!$using_hssi_mode} {
		set hssi_freq "0 ps"
	} else {
        if { $gui_enable_manual_hssi_counters } {
            set hssi_freq "$gui_hssi_calc_output_clock_frequency MHz"
        } else {
            set hssi_freq "$gui_hssi_output_clock_frequency MHz"
        }
	}
	
	ip_set "parameter.hssi_output_clock_frequency.value" $hssi_freq
	
	if {$debug_message} {
		puts "  hssi_output_clock_frequency->$hssi_freq"
	}	

}

proc ::altera_xcvr_fpll_vi::parameters::using_pcie_prot_mode { prot_mode } {
	if {$prot_mode == 0 || $prot_mode == 4 || $prot_mode == 5 || $prot_mode == 6 || $prot_mode == 7 || $prot_mode == 8 || $prot_mode == 9 || $prot_mode == 10} {
		return false
	} else {
		return true
	}
}

# +-----------------------------------
# | This function sets the core output clock frequency 0 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_0 { 
	gui_fpll_mode \
	gui_hssi_prot_mode \
	gui_number_of_output_clocks \
	full_actual_outclk0_frequency \
	full_actual_outclk3_frequency \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_0"
	}	

	set clock_freq_unused_value "0 ps"
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	
	if {$using_hssi_mode} {
		set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode] 
		if {$using_pcie_prot_mode} {
			set clock_freq "500 MHz"
		} else {
			set clock_freq $clock_freq_unused_value
		}	
	} elseif {$using_cascade_mode} {
		set clock_freq $clock_freq_unused_value	
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 0} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set clock_freq $clock_freq_unused_value
			} else {
				set clock_freq "[round_freq $full_actual_outclk3_frequency] MHz"
			}
		} else {
			if {$gui_number_of_output_clocks < 1} {
				set clock_freq $clock_freq_unused_value
			} else {
				set clock_freq "[round_freq $full_actual_outclk0_frequency] MHz"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}
	
	ip_set "parameter.output_clock_frequency_0.value" $clock_freq
	
	if {$debug_message} {
		puts "  output_clock_frequency_0->$clock_freq"
	}

}

# +-----------------------------------
# | This function sets the core output clock frequency 1 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_1 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_desired_hssi_cascade_frequency \
	full_actual_outclk3_frequency \
	full_actual_outclk1_frequency \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {

	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_1"
	}		
	
	set clock_freq_unused_value "0 ps"

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set clock_freq $clock_freq_unused_value	
	} elseif {$using_cascade_mode} {
		set clock_freq "[round_freq $gui_desired_hssi_cascade_frequency] MHz"
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 1} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set clock_freq $clock_freq_unused_value
			} else {
				set clock_freq "[round_freq $full_actual_outclk3_frequency] MHz"
			}
		} else {
			if {$gui_number_of_output_clocks < 2} {
				set clock_freq $clock_freq_unused_value
			} else {
				set clock_freq "[round_freq $full_actual_outclk1_frequency] MHz"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.output_clock_frequency_1.value" $clock_freq
	
	if {$debug_message} {
		puts "  output_clock_frequency_1->$clock_freq"
	}	

}
proc ::altera_xcvr_fpll_vi::parameters::get_actual_refclk_frequency  { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_enable_fractional \
	gui_fractional_x \
	compensation_mode \
	mcgb_div \
	pma_width \
	gui_desired_refclk_frequency \
	gui_hssi_output_clock_frequency \
	gui_desired_hssi_cascade_frequency \
	gui_hssi_prot_mode \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision\
	primary_use\
	gui_enable_manual_hssi_counters \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_refclk_frequency "N/A" "N/A"
		return
	}	
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {!$using_core_mode} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_refclk_frequency"
		}
	
		set family $device_family
		set type "FPLL"
		set speedgrade $numeric_speed_grade
		set is_fractional $gui_enable_fractional
		set x $gui_fractional_x
		set compensation_mode $compensation_mode
		
		if {$compensation_mode == "fpll_bonding"} {
			set unnecessary_counter_value 1
			set hssi_div [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
							$compensation_mode \
							$mcgb_div \
							$pma_width \
							$unnecessary_counter_value \
							$unnecessary_counter_value]
		} else {
			set hssi_div 1
		}
		
		array set validated_clock_list [list]
		if {$using_hssi_mode} {
			set hssi_output_freq $gui_hssi_output_clock_frequency
			set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode]
			if {$using_pcie_prot_mode} {
				set is_degrees false
				set outclk_data [list -type c -index 0 -freq 500.0 -phase 0.0 -is_degrees $is_degrees]		
				::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data

				set is_degrees false
				set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
				::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 1 $outclk_data	
			} else {
				set is_degrees false
				set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
				::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data	
			}		
		} elseif {$using_cascade_mode} {
			#must be using cascade mode
			set hssi_cascade_freq $gui_desired_hssi_cascade_frequency
			set is_degrees false
			set outclk_data [list -type c -index 0 -freq $hssi_cascade_freq -phase 0.0 -is_degrees $is_degrees]		
			::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data				
		} else {
			error "IE: Unknown fpll mode"
		}
		
		set desired_refclk $gui_desired_refclk_frequency

		set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
		set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    		set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    		set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    		set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]
	
		set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-is_fractional $is_fractional \
							-x $x \
							-desired_refclk_freq $desired_refclk \
							-compensation_mode $compensation_mode \
							-validated_counter_settings [array get validated_clock_list] \
							-hssi_div $hssi_div \
							-f_min_vco $f_min_vco_mhz\
							-f_max_vco $f_max_vco_mhz\
							-f_min_pfd $f_min_pfd_mhz\
							-f_max_pfd $f_max_pfd_mhz \
							-device $device_revision \
                            -primary_use $primary_use\
							]
		
		if {$debug_message} {
			puts "  ref_list: $ref_list"
		}
		
		if {[catch {::quartus::pll::fpll_legality::retrieve_refclk_freq_list $ref_list} result]} {
			#For bonding mode, an error will always occur if the user has entered an output
			#frequency which forces an illegal pfd/vco freq. 
			#TODO: IPTAF function should be updated to return a better error message (ie result)
			#Original error message: set error_message "IE: Unable to compute nearest actual refclk_freqs ($result)"			

			if {$compensation_mode == "fpll_bonding"} {
                            if {$temp_bw_sel == "low" || $temp_bw_sel == "medium"} {
				set error_message "Unable to compute a valid reference clock frequency given desired output frequency, selected pma width and mcbg clock division factor.  Your selection of Bandwidth setting may also contribute to this issue."
			    } else {
				set error_message "Unable to compute a valid reference clock frequency given desired output frequency, selected pma width and mcbg clock division factor."
			    }
			} else {
				set error_message "Unable to compute a valid reference clock frequency given desired output frequency."
			}
			set error_occurred_in_validation true
			ip_message error $error_message
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_refclk_frequency "N/A" "N/A"		
		} else {
			array set result_array $result
			set freq_value $result_array(closest_freq)
			set freq_range $result_array(freq)	

			set rounded_new_freq_range [round_freq $freq_range]
			set rounded_new_freq_value [round_freq $freq_value]

			if {$gui_enable_manual_hssi_counters} {
				::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_refclk_frequency $gui_desired_refclk_frequency $gui_desired_refclk_frequency
				ip_set "parameter.gui_actual_refclk_frequency.ALLOWED_RANGES" [list $gui_desired_refclk_frequency $gui_desired_refclk_frequency]
				ip_set "parameter.full_actual_refclk_frequency.value" $gui_desired_refclk_frequency
				ip_set "parameter.full_actual_refclk_frequency.ALLOWED_RANGES" [list $gui_desired_refclk_frequency $gui_desired_refclk_frequency]
			} else {
				::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_refclk_frequency $rounded_new_freq_range $rounded_new_freq_value
				ip_set "parameter.full_actual_refclk_frequency.ALLOWED_RANGES" $freq_range
			}

			if {$debug_message} {
				puts "  ---\n  result: \n  $result"
				puts "  new range: \n  [get_parameter_property gui_actual_refclk_frequency ALLOWED_RANGES]"
				puts "  new value: \n  [get_parameter_value gui_actual_refclk_frequency]"
				puts "  new full range: \n  [get_parameter_property full_actual_refclk_frequency ALLOWED_RANGES]"
				#puts "  new full value: \n  [get_parameter_value full_actual_outclk0_frequency]"
			}
			
		}
		
		
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_actual_refclk_frequency "N/A" "N/A"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_actual_refclk_frequency {
	gui_actual_refclk_frequency \
	gui_desired_refclk_frequency \
	gui_enable_manual_hssi_counters \
} {
	variable debug_message
	variable error_occurred_in_validation

	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_actual_refclk_frequency"
	}
	if {$gui_enable_manual_hssi_counters} {
		set new_selected_value [get_parameter_value gui_desired_refclk_frequency]
	} else {
		set new_selected_value [get_parameter_value gui_actual_refclk_frequency]
	}
	set new_selected_range [get_parameter_property gui_actual_refclk_frequency ALLOWED_RANGES]
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_freq_range [get_parameter_property full_actual_refclk_frequency ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_freq_range $new_index]
			
	ip_set "parameter.full_actual_refclk_frequency.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

# +-----------------------------------
# | This function sets the core output clock frequency 2 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_2 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_2"
	}		
	
	set clock_freq_unused_value "0 ps"

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set clock_freq $clock_freq_unused_value	
	} elseif {$using_cascade_mode} {
		set clock_freq $clock_freq_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 2} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set clock_freq $clock_freq_unused_value
			} else {
				set clock_freq "[round_freq $full_actual_outclk3_frequency] MHz"
			}
		} else {
			if {$gui_number_of_output_clocks < 3} {
				set clock_freq $clock_freq_unused_value
			} else {
				set clock_freq "[round_freq $full_actual_outclk2_frequency] MHz"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.output_clock_frequency_2.value" $clock_freq
	
	if {$debug_message} {
		puts "  output_clock_frequency_2->$clock_freq"
	}	
}

# +-----------------------------------
# | This function sets the core output clock frequency 3 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_3 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	gui_cascade_outclk_index \
	gui_enable_cascade_out \
} {

	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_output_clock_frequency_3"
	}		
	
	set clock_freq_unused_value "0 ps"

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set clock_freq $clock_freq_unused_value	
	} elseif {$using_cascade_mode} {
		set clock_freq $clock_freq_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out} {
			switch $gui_cascade_outclk_index {
				0 {
					set clock_freq "[round_freq $full_actual_outclk0_frequency] MHz"
				}
				1 {
					set clock_freq "[round_freq $full_actual_outclk1_frequency] MHz"
				}
				2 {
					set clock_freq "[round_freq $full_actual_outclk2_frequency] MHz"
				}
				3 {
					set clock_freq "[round_freq $full_actual_outclk3_frequency] MHz"
				}
				default {
					error "IE: Unknown clock index"
				}
			}
		} else {
			if {$gui_number_of_output_clocks < 4} {
				set clock_freq $clock_freq_unused_value
			} else {
				set clock_freq "[round_freq $full_actual_outclk3_frequency] MHz"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.output_clock_frequency_3.value" $clock_freq
	
	if {$debug_message} {
		puts "  output_clock_frequency_3->$clock_freq"
	}	
}

# +-----------------------------------
# | This function sets the VCO frequency parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_core_vco_frequency_basic { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_pll_dsm_fractional_division \
	gui_pll_m_counter \
	gui_pll_n_counter \
	compensation_mode \
	gui_reference_clock_frequency \
	gui_enable_manual_config \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_number_of_output_clocks \
    	cmu_fpll_f_max_vco\
    	cmu_fpll_f_min_vco\
    	cmu_fpll_f_max_vco_fractional\
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use\
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode] 
	if {!$using_core_mode} {
		return
	} 
	if {$gui_enable_manual_config} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_vco_frequency_basic"
	}		
	
	set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_core_mode_outclk_list_basic \
									$full_actual_outclk0_frequency \
									$full_actual_outclk1_frequency \
									$full_actual_outclk2_frequency \
									$full_actual_outclk3_frequency \
									$full_outclk0_actual_phase_shift \
									$full_outclk1_actual_phase_shift \
									$full_outclk2_actual_phase_shift \
									$full_outclk3_actual_phase_shift \
									$gui_number_of_output_clocks]
	
	set type "FPLL"
	set family $device_family
	set speedgrade $numeric_speed_grade
	set x $gui_fractional_x
	set refclk_freq $gui_reference_clock_frequency
	set is_fractional $gui_enable_fractional
	set compensation_mode $compensation_mode
	set m $gui_pll_m_counter
	set n $gui_pll_n_counter
	set k $gui_pll_dsm_fractional_division
	set is_counter_cascading_enabled false


	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

	
	set ref_list [list -family $family \
				-type $type \
				-speedgrade $speedgrade \
				-refclk_freq $refclk_freq \
				-is_fractional $is_fractional \
				-compensation_mode $compensation_mode \
				-is_counter_cascading_enabled false \
				-x $x \
				-validated_counter_values $validated_clock_list \
                -f_min_vco $f_min_vco_mhz\
                -f_max_vco $f_max_vco_mhz\
                -f_min_pfd $f_min_pfd_mhz\
                -f_max_pfd $f_max_pfd_mhz\
				-device $device_revision \
                -primary_use $primary_use\
				]


	
	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}	
		
	if {[catch {::quartus::pll::fpll_legality::compute_vco_frequency $ref_list} result]} {
			set error_occurred_in_validation true
            if { $gui_enable_fractional } {
                set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco_fractional]
                set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
            } else {
                set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
                set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
            }
			ip_message error "1. The specified configuration causes Voltage-Controlled Oscillator (VCO) to go beyond the limit. Legal range = $f_min_vco_mhz\MHz-$f_max_vco_mhz\MHz"
	} else {
		array set result_array $result
		set vco_freq $result_array(vco_freq)
        set vco_freq [ trim_freq_double_precision $vco_freq ]
		ip_set "parameter.core_vco_frequency_basic.value" $vco_freq
	}
		
	if {$debug_message} {
		puts "  ---\n  result: \n  $result"
	}		

}

proc ::altera_xcvr_fpll_vi::parameters::update_core_vco_frequency_adv { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_pll_dsm_fractional_division \
	gui_pll_m_counter \
	gui_pll_n_counter \
	compensation_mode \
	gui_reference_clock_frequency \
	gui_enable_manual_config \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	gui_number_of_output_clocks \
    	cmu_fpll_f_max_vco\
    	cmu_fpll_f_min_vco\
    	cmu_fpll_f_max_vco_fractional\
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}
	
	#we're not passing in the phase shifts here because it doesn't matter...
	#this ensures that this code will ALWAYS get called (if something actually bad didn't happen
	set phase_0 0.0
	set phase_1 0.0
	set phase_2 0.0
	set phase_3 0.0
	
	set using_core_mode [using_core_mode $gui_fpll_mode] 
	if {!$using_core_mode} {
		return
	} 
	if {!$gui_enable_manual_config} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_vco_frequency_adv"
	}		
	

	set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_core_mode_outclk_list_advanced \
									$gui_pll_c_counter_0 \
									$gui_pll_c_counter_1 \
									$gui_pll_c_counter_2 \
									$gui_pll_c_counter_3 \
									$phase_0 \
									$phase_1 \
									$phase_2 \
									$phase_3 \
									$gui_number_of_output_clocks]	
	
	set type "FPLL"
	set family $device_family
	set speedgrade $numeric_speed_grade
	set x $gui_fractional_x
	set refclk_freq $gui_reference_clock_frequency
	set is_fractional $gui_enable_fractional
	set compensation_mode $compensation_mode
	set m $gui_pll_m_counter
	set n $gui_pll_n_counter
	set k $gui_pll_dsm_fractional_division
	set is_counter_cascading_enabled false

	set local_f_max_pfd [get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]
	

	
	set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-refclk_freq $refclk_freq \
							-is_fractional $is_fractional \
							-compensation_mode $compensation_mode \
							-x $x \
							-m $m \
							-n $n \
							-k $k \
							-validated_counter_values $validated_clock_list \
                            -f_min_vco $f_min_vco_mhz\
                            -f_max_vco $f_max_vco_mhz\
                            -f_min_pfd $f_min_pfd_mhz\
                            -f_max_pfd $f_max_pfd_mhz\
						    -device $device_revision \
                            -primary_use $primary_use\
						 	]


	
	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}	
		
	if {[catch {::quartus::pll::fpll_legality::compute_vco_frequency $ref_list} result]} {
			set error_occurred_in_validation true
            if { $gui_enable_fractional } {
                set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco_fractional]
                set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
            } else {
                set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
                set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
            }
            variable temp_vco_freq 
            set temp_vco_freq [expr ( ($refclk_freq / $n ) * ($m * 2) )]

            if { ( $f_min_vco_mhz <= $temp_vco_freq )  && ( $f_max_vco_mhz >= $temp_vco_freq ) } {
                if { $k < 47244640  } {
                 # set base_k [expr {double($k)/4294967296}]
			  	 # set frac [expr $base_k*100]
			      ip_message error "The specified value of k is below 1.1% of 2^32 which is outside the performance limits of Fpll."
                } else {
                  ip_message error "The specified value of k is above 98.9% of 2^32 which is outside the performance limits of Fpll."
                }
            } else {
			      ip_message error "2.The specified configuration causes Voltage-Controlled Oscillator (VCO) to go beyond the limit. Legal range = $f_min_vco_mhz\MHz-$f_max_vco_mhz\MHz"
            }

	} else {
		array set result_array $result
		set vco_freq $result_array(vco_freq)
        set vco_freq [ trim_freq_double_precision $vco_freq ]
		ip_set "parameter.core_vco_frequency_adv.value" $vco_freq
	}
		
	if {$debug_message} {
		puts "  ---\n  result: \n  $result"
	}		

}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_vco_frequency {\
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	compensation_mode \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
    	cmu_fpll_f_max_vco\
    	cmu_fpll_f_min_vco\
    	cmu_fpll_f_max_vco_fractional\
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode] 
	if {!$using_cascade_mode} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_vco_frequency"
	}		
	
	set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_cascade_mode_outclk_list \
								$gui_desired_hssi_cascade_frequency]		
	
	set type "FPLL"
	set family $device_family
	set speedgrade $numeric_speed_grade
	set x $gui_fractional_x
	set refclk_freq $full_actual_refclk_frequency
	set is_fractional $gui_enable_fractional
	set compensation_mode $compensation_mode
	
	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-is_counter_cascading_enabled false \
						-x $x \
						-validated_counter_values $validated_clock_list \
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
				 		]


	
	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}	
		
	if {[catch {::quartus::pll::fpll_legality::compute_vco_frequency $ref_list} result]} {
			set error_occurred_in_validation true
            if { $gui_enable_fractional } {
                set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco_fractional]
                set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
            } else {
                set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
                set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
            }
			ip_message error "3.The specified configuration causes Voltage-Controlled Oscillator (VCO) to go beyond the limit. Legal range = $f_min_vco_mhz\MHz-$f_max_vco_mhz\MHz"
	} else {
		array set result_array $result
		set vco_freq $result_array(vco_freq)
        set vco_freq [ trim_freq_double_precision $vco_freq ]
		ip_set "parameter.hssi_cascade_vco_frequency.value" $vco_freq
	}
		
	if {$debug_message} {
		puts "  ---\n CASCADE VCO FREQ result: \n  $result"
	}	

}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_vco_frequency {\
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	compensation_mode \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	gui_hssi_prot_mode \
	mcgb_div \
	pma_width \
    	cmu_fpll_f_max_vco\
    	cmu_fpll_f_min_vco\
    	cmu_fpll_f_max_vco_fractional\
    	cmu_fpll_f_min_pfd \
    	cmu_fpll_f_max_pfd \
	device_revision \
	primary_use\
	gui_enable_manual_hssi_counters \
	pll_l_counter \
	pll_m_counter \
	pll_n_counter \
	gui_pll_set_hssi_m_counter \
	gui_pll_set_hssi_n_counter \
	gui_pll_set_hssi_k_counter \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_actual_refclk_frequency \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode] 
	if {!$using_hssi_mode} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_vco_frequency"
	}		
	
	set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_hssi_mode_outclk_list \
								$gui_hssi_output_clock_frequency \
								$gui_hssi_prot_mode]	
	
	set type "FPLL"
	set family $device_family
	set speedgrade $numeric_speed_grade
	set x $gui_fractional_x
	set refclk_freq $full_actual_refclk_frequency
	set is_fractional $gui_enable_fractional
	set compensation_mode $compensation_mode

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

        if { $gui_enable_fractional } {
                set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco_fractional]
                set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
        }
	if {!$gui_enable_manual_hssi_counters} {
	    if {$compensation_mode == "fpll_bonding"} {
		set unnecessary_counter_value 1
		set hssi_div [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
				  $compensation_mode \
				  $mcgb_div \
				  $pma_width \
				  $unnecessary_counter_value \
				  $unnecessary_counter_value]
		set ref_list [list -family $family \
				  -type $type \
				  -speedgrade $speedgrade \
				  -refclk_freq $refclk_freq \
				  -is_fractional $is_fractional \
				  -compensation_mode $compensation_mode \
				  -is_counter_cascading_enabled false \
				  -x $x \
				  -validated_counter_values $validated_clock_list \
				  -hssi_div $hssi_div \
				  -f_min_vco $f_min_vco_mhz\
				  -f_max_vco $f_max_vco_mhz\
				  -f_min_pfd $f_min_pfd_mhz\
				  -f_max_pfd $f_max_pfd_mhz\
				  -device $device_revision \
				  -primary_use $primary_use\
				 ] 
		
		
	    } else {
		set ref_list [list -family $family \
				  -type $type \
				  -speedgrade $speedgrade \
				  -refclk_freq $refclk_freq \
				  -is_fractional $is_fractional \
				  -compensation_mode $compensation_mode \
				  -is_counter_cascading_enabled false \
				  -x $x \
				  -validated_counter_values $validated_clock_list \
				  -f_min_vco $f_min_vco_mhz\
				  -f_max_vco $f_max_vco_mhz\
				  -f_min_pfd $f_min_pfd_mhz\
				  -f_max_pfd $f_max_pfd_mhz\
				  -device $device_revision \
				  -primary_use $primary_use\
				 ] 
		
	    }
	
	    if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	    }	
	    
	if {[catch {::quartus::pll::fpll_legality::compute_vco_frequency $ref_list} result]} {
			set error_occurred_in_validation true
			ip_message error "4. The specified configuration causes Voltage-Controlled Oscillator (VCO) to go beyond the limit. Legal range = $f_min_vco_mhz\MHz-$f_max_vco_mhz\MHz"
	} else {
		array set result_array $result
		set vco_freq $result_array(vco_freq)
        set vco_freq [ trim_freq_double_precision $vco_freq ]
        ip_set "parameter.hssi_vco_frequency.value" $vco_freq
        ip_set "parameter.core_vco_frequency_basic.value" $vco_freq
	}
	} else {
         set float_n_counter "$gui_pll_set_hssi_n_counter.0"
         set temp_vco_freq  [expr {($refclk_freq * $gui_pll_set_hssi_m_counter * 2)/$float_n_counter}]
#        puts "calc vco freq: '$temp_vco_freq"
#        puts "f_min_vco: 'f_min_vco_mhz'"
#        puts "f_max_vco: 'f_max_vco_mhz'"
		if { $temp_vco_freq < $f_min_vco_mhz } {
            set error_occurred_in_validation true
         	set temp_vco_freq [ trim_freq_double_precision $temp_vco_freq ]
			if { $gui_pll_set_hssi_n_counter > 1 } { 
           		ip_message error "The specified configuration sets the Voltage-Controlled Oscillator (VCO) frequency to $temp_vco_freq\MHz which is outside the legal range. Legal range = $f_min_vco_mhz\MHz-$f_max_vco_mhz\MHz.  You may need to increase the reference clock frequency or the value of the M counter or decrease the value of the N counter."
			} else {
           		ip_message error "The specified configuration sets the Voltage-Controlled Oscillator (VCO) frequency to $temp_vco_freq\MHz which is outside the legal range. Legal range = $f_min_vco_mhz\MHz-$f_max_vco_mhz\MHz.  You may need to increase the reference clock frequency or the value of the M counter."
			}
		 } elseif {$temp_vco_freq > $f_max_vco_mhz } {
            set error_occurred_in_validation true
         	set temp_vco_freq [ trim_freq_double_precision $temp_vco_freq ]
            ip_message error "The specified configuration sets the Voltage-Controlled Oscillator (VCO) frequency to $temp_vco_freq\MHz which is outside the legal range. Legal range = $f_min_vco_mhz\MHz-$f_max_vco_mhz\MHz.  You may need to decrease the reference clock frequency or the value of the M counter or increase the value of the N counter."
       	 } else {
            if {$gui_enable_fractional} {
                if { $gui_pll_set_hssi_k_counter  < 47244640  } {
                   # set base_k [expr {double($k)/4294967296}]
			  	   # set frac [expr $base_k*100]
			        ip_message error "The specified value of k is below 1.1% of 2^32 which is outside the performance limits of Fpll."
                } elseif { $gui_pll_set_hssi_k_counter  > 4247722655 } {
                    ip_message error "The specified value of k is above 98.9% of 2^32 which is outside the performance limits of Fpll."
                } else {
				set lowest_frac_m [expr $gui_pll_set_hssi_m_counter - 3]
				set twice_lowest_frac_m [expr $lowest_frac_m * 2]
				set float_twice_lowest_frac_m "$twice_lowest_frac_m.0"
				set highest_frac_pfd_freq [expr $temp_vco_freq / $float_twice_lowest_frac_m  ]
			#puts "highest_frac_pfd_freq: '$highest_frac_pfd_freq'"
            	if {$highest_frac_pfd_freq <= $cmu_fpll_f_max_pfd} {
         	        set vco_freq [ trim_freq_double_precision $temp_vco_freq ]
	     	        ip_set "parameter.hssi_vco_frequency.value" $vco_freq
  	     	        ip_set "parameter.core_vco_frequency_basic.value" $vco_freq
				} else {
         			set temp_pfd_freq [ trim_freq_double_precision $highest_frac_pfd_freq]
            		ip_message error "The specified fractional configuration sets the maximum instantaneous Phase Frequency Detector (PFD) frequency to $temp_vco_freq\MHz which exceeds the maximum operating frequency of $cmu_fpll_f_max_pfd\MHz"
                  } 
                }
			} else {
          		set vco_freq [ trim_freq_double_precision $temp_vco_freq ]
	     		ip_set "parameter.hssi_vco_frequency.value" $vco_freq
  	     		ip_set "parameter.core_vco_frequency_basic.value" $vco_freq
         	}
        }
    } 
	if {$debug_message} {
		puts "  ---\n  result: \n  $result"
	}	

}

proc ::altera_xcvr_fpll_vi::parameters::update_vco_frequency { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	compensation_mode \
	core_vco_frequency_basic \
	core_vco_frequency_adv \
	hssi_vco_frequency \
	hssi_cascade_vco_frequency \
	gui_enable_manual_config \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_vco_frequency"
	}	
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]	
	
	if {$using_core_mode} {
		if {$gui_enable_manual_config} {
			set vco_freq $core_vco_frequency_adv
		} else {
			set vco_freq $core_vco_frequency_basic
		}
	} elseif {$using_cascade_mode} {
		set vco_freq $hssi_cascade_vco_frequency
	} elseif {$using_hssi_mode} {
		set vco_freq $hssi_vco_frequency
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}
	
	ip_set "parameter.vco_frequency.value" "$vco_freq MHz"
	
	if {$debug_message} {
		puts "  vco_frequency->$vco_freq MHz"
	}
}

# +-----------------------------------
# | This function sets the PFD frequency parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_core_pfd_frequency { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_pll_dsm_fractional_division \
	gui_pll_m_counter \
	gui_pll_n_counter \
	compensation_mode \
	gui_reference_clock_frequency \
	gui_enable_manual_config \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_number_of_output_clocks \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode] 
	if {!$using_core_mode} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_pfd_frequency"
	}		
	
	if {!$gui_enable_manual_config} {
		set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_core_mode_outclk_list_basic \
									$full_actual_outclk0_frequency \
									$full_actual_outclk1_frequency \
									$full_actual_outclk2_frequency \
									$full_actual_outclk3_frequency \
									$full_outclk0_actual_phase_shift \
									$full_outclk1_actual_phase_shift \
									$full_outclk2_actual_phase_shift \
									$full_outclk3_actual_phase_shift \
									$gui_number_of_output_clocks]
	} else {
		set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_core_mode_outclk_list_advanced \
									$gui_pll_c_counter_0 \
									$gui_pll_c_counter_1 \
									$gui_pll_c_counter_2 \
									$gui_pll_c_counter_3 \
									$full_outclk0_actual_phase_shift \
									$full_outclk1_actual_phase_shift \
									$full_outclk2_actual_phase_shift \
									$full_outclk3_actual_phase_shift \
									$gui_number_of_output_clocks]
	}	
	
	set type "FPLL"
	set family $device_family
	set speedgrade $numeric_speed_grade
	set x $gui_fractional_x
	set refclk_freq $gui_reference_clock_frequency
	set is_fractional $gui_enable_fractional
	set compensation_mode $compensation_mode
	set m $gui_pll_m_counter
	set n $gui_pll_n_counter
	set k $gui_pll_dsm_fractional_division
	set is_counter_cascading_enabled false

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	
	if {$gui_enable_manual_config} {
		set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-refclk_freq $refclk_freq \
							-is_fractional $is_fractional \
							-compensation_mode $compensation_mode \
							-x $x \
							-m $m \
							-n $n \
							-k $k \
							-validated_counter_values $validated_clock_list\
	                        -f_min_vco $f_min_vco_mhz\
	                        -f_max_vco $f_max_vco_mhz\
	                        -f_min_pfd $f_min_pfd_mhz\
	                        -f_max_pfd $f_max_pfd_mhz\
							-device $device_revision \
                            -primary_use $primary_use\
							]

	} else {
		set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-refclk_freq $refclk_freq \
							-is_fractional $is_fractional \
							-compensation_mode $compensation_mode \
							-is_counter_cascading_enabled false \
							-x $x \
							-validated_counter_values $validated_clock_list \
                            -f_min_vco $f_min_vco_mhz\
                            -f_max_vco $f_max_vco_mhz\
                            -f_min_pfd $f_min_pfd_mhz\
                            -f_max_pfd $f_max_pfd_mhz\
							-device $device_revision \
                            -primary_use $primary_use\
							]
	
	}
	
	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}	
		
	if {[catch {::quartus::pll::fpll_legality::compute_pfd_frequency $ref_list} result]} {
			set error_occurred_in_validation true
			ip_message error "The specified configuration causes Phase Frequency Detector (PFD) to go beyond the limit."
	} else {
		array set result_array $result
		set pfd_freq $result_array(pfd_freq)
		ip_set "parameter.core_pfd_frequency.value" $pfd_freq
		ip_set "parameter.gui_pfd_frequency.value" $pfd_freq
	}
	
	if {$debug_message} {
		puts "  ---\n  result: \n  $result"
	}		

}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_pfd_frequency {\
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	compensation_mode \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
    	gui_pll_set_hssi_m_counter \
    	gui_pll_set_hssi_n_counter \
    	gui_enable_manual_hssi_counters \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode] 
	if {!$using_cascade_mode} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_pfd_frequency"
	}		
	
	set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_cascade_mode_outclk_list \
								$gui_desired_hssi_cascade_frequency]		
	
	set type "FPLL"
	set family $device_family
	set speedgrade $numeric_speed_grade
	set x $gui_fractional_x
	set refclk_freq $full_actual_refclk_frequency
	set is_fractional $gui_enable_fractional
	set compensation_mode $compensation_mode

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]



	
	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-is_counter_cascading_enabled false \
						-x $x \
						-validated_counter_values $validated_clock_list \
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						]

	
	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}	
		
	if {[catch {::quartus::pll::fpll_legality::compute_pfd_frequency $ref_list} result]} {
			set error_occurred_in_validation true
			ip_message error "The specified configuration causes Phase Frequency Detector (PFD) to go beyond the limit."
	} else {
		array set result_array $result
		set pfd_freq $result_array(pfd_freq)
		ip_set "parameter.hssi_cascade_pfd_frequency.value" $pfd_freq
	}
		
	if {$debug_message} {
		puts "  ---\n  result: \n  $result"
	}	

}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_pfd_frequency {\
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	compensation_mode \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	gui_hssi_prot_mode \
	mcgb_div \
	pma_width \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_pll_set_hssi_m_counter \
	gui_pll_set_hssi_n_counter \
	gui_enable_manual_hssi_counters \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message 
	variable error_occurred_in_validation
	variable error_message
	
	if {$error_occurred_in_validation} {
		return
	}
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode] 
	if {!$using_hssi_mode} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_pfd_frequency"
	}		
	
	set validated_clock_list [::altera_xcvr_fpll_vi::parameters::make_hssi_mode_outclk_list \
								$gui_hssi_output_clock_frequency \
								$gui_hssi_prot_mode]	
	
	set type "FPLL"
	set family $device_family
	set speedgrade $numeric_speed_grade
	set x $gui_fractional_x
	set refclk_freq $full_actual_refclk_frequency
	set is_fractional $gui_enable_fractional
	set compensation_mode $compensation_mode

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

	
	if {!$gui_enable_manual_hssi_counters} {
	if {$compensation_mode == "fpll_bonding"} {
		set unnecessary_counter_value 1
		set hssi_div [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
						$compensation_mode \
						$mcgb_div \
						$pma_width \
						$unnecessary_counter_value \
						$unnecessary_counter_value]
		set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-refclk_freq $refclk_freq \
							-is_fractional $is_fractional \
							-compensation_mode $compensation_mode \
							-is_counter_cascading_enabled false \
							-x $x \
							-validated_counter_values $validated_clock_list \
							-hssi_div $hssi_div \
                        	-f_min_vco $f_min_vco_mhz\
                        	-f_max_vco $f_max_vco_mhz\
                        	-f_min_pfd $f_min_pfd_mhz\
                        	-f_max_pfd $f_max_pfd_mhz\
							-device $device_revision \
                            -primary_use $primary_use\
							]

	} else {
		set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-refclk_freq $refclk_freq \
							-is_fractional $is_fractional \
							-compensation_mode $compensation_mode \
							-is_counter_cascading_enabled false \
							-x $x \
							-validated_counter_values $validated_clock_list \
                            -f_min_vco $f_min_vco_mhz\
                            -f_max_vco $f_max_vco_mhz\
                            -f_min_pfd $f_min_pfd_mhz\
                            -f_max_pfd $f_max_pfd_mhz\
							-device $device_revision \
                            -primary_use $primary_use\
							]

	}
	
	if {$debug_message} {
		puts "  ref_list: \n  $ref_list"
	}	
		
	if {[catch {::quartus::pll::fpll_legality::compute_pfd_frequency $ref_list} result]} {
			set error_occurred_in_validation true
			ip_message error "The specified configuration causes Phase Frequency Detector (PFD) to go beyond the limit."
	} else {
		array set result_array $result
		set pfd_freq $result_array(pfd_freq)
		ip_set "parameter.hssi_pfd_frequency.value" $pfd_freq
	}       	
	} else {
	    set float_n_counter "$gui_pll_set_hssi_n_counter.0"
        if {$gui_enable_fractional} {
            set temp_vco_freq  [expr {($refclk_freq * $gui_pll_set_hssi_m_counter * 2)/$float_n_counter}]
			set lowest_frac_m [expr $gui_pll_set_hssi_m_counter - 3]
			set twice_lowest_frac_m [expr $lowest_frac_m * 2]
			set float_twice_lowest_frac_m "$twice_lowest_frac_m.0"
			set highest_frac_pfd_freq [expr $temp_vco_freq / $float_twice_lowest_frac_m  ]
            if {$highest_frac_pfd_freq <= $local_f_max_pfd} {
        	    set temp_pfd_freq  [expr {$refclk_freq/$float_n_counter}]
         		set pfd_freq [ trim_freq_double_precision $temp_pfd_freq ]
    		    ip_set "parameter.hssi_pfd_frequency.value" $pfd_freq
			} else {
            	set error_occurred_in_validation true
         		set temp_pfd_freq [ trim_freq_double_precision $highest_frac_pfd_freq]
           		ip_message error "The specified fractional configuration sets the maximum instantaneous Phase Frequency Detector (PFD) frequency to $temp_vco_freq\MHz which exceeds the maximum operating frequency of $cmu_fpll_f_max_pfd\MHz"
         	}
    	} else {
        	set temp_pfd_freq  [expr {$refclk_freq/$float_n_counter}]
			if { $temp_pfd_freq < $f_min_pfd_mhz } {
           	 set error_occurred_in_validation true
         		set temp_pfd_freq [ trim_freq_double_precision $temp_pfd_freq ]
				if { $gui_pll_set_hssi_n_counter > 1 } { 
           			ip_message error "The specified configuration sets the Phase Frequency Detector (PFD) frequency to $temp_pfd_freq\MHz which is below the legal range. Legal range = $f_min_pfd_mhz\MHz-$f_max_pfd_mhz\MHz.  You may need to increase the reference clock frequency or decrease the value of the N counter."
				} else {
           			ip_message error "The specified configuration sets the Phase Frequency Detector (PFD) frequency to $temp_pfd_freq\MHz which is below the legal range. Legal range = $f_min_pfd_mhz\MHz-$f_max_pfd_mhz\MHz.  You may need to increase the reference clock frequency."
				}
		 	} elseif {$temp_pfd_freq > $f_max_pfd_mhz } {
                set error_occurred_in_validation true
         		set temp_pfd_freq [ trim_freq_double_precision $temp_pfd_freq ]
           		ip_message error "The specified configuration sets the Phase Frequency Detector (PFD) frequency to $temp_pfd_freq\MHz which is above the legal range. Legal range = $f_min_pfd_mhz\MHz-$f_max_pfd_mhz\MHz.  You may need to decrease the reference clock frequency."
       	 	} else {
        	    set temp_pfd_freq  [expr {$refclk_freq/$float_n_counter}]
         		set pfd_freq [ trim_freq_double_precision $temp_pfd_freq ]
    		    ip_set "parameter.hssi_pfd_frequency.value" $pfd_freq
		    }
       	} 
	}		
	if {$debug_message} {
		puts "  ---\n  result: \n  $result"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_pfd_frequency { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	compensation_mode \
	core_pfd_frequency \
	hssi_pfd_frequency \
	hssi_cascade_pfd_frequency \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pfd_frequency"
	}	
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]	
	
	if {$using_core_mode} {
		set pfd_freq $core_pfd_frequency
	} elseif {$using_cascade_mode} {
		set pfd_freq $hssi_cascade_pfd_frequency
	} elseif {$using_hssi_mode} {
		set pfd_freq $hssi_pfd_frequency
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}
	
	ip_set "parameter.pfd_frequency.value" "$pfd_freq MHz"
	#ip_set "parameter.gui_pfd_frequency.value" $pfd_freq
	
	if {$debug_message} {
		puts "  pfd_frequency->$pfd_freq MHz"
	}
}

#proc ::altera_xcvr_fpll_vi::parameters::update_pll_vco_ph1_en { \
#   primary_use \
#} {
#   if {$primary_use == "tx"} {
#      ip_set "parameter.pll_vco_ph1_en.value" "false"
#   } else {
#      ip_set "parameter.pll_vco_ph1_en.value" "true"
#   }
#}

#proc ::altera_xcvr_fpll_vi::parameters::update_pll_vco_ph2_en { \
#   primary_use \
#   pll_l_counter \
#} {
#   if {$primary_use == "tx" && $pll_l_counter > 1} {
#      ip_set "parameter.pll_vco_ph2_en.value" "false"
#   } else {
#      ip_set "parameter.pll_vco_ph2_en.value" "true"
#   }
#}

#proc ::altera_xcvr_fpll_vi::parameters::update_pll_vco_ph3_en { \
#   primary_use \
#} {
#   if {$primary_use == "tx"} {
#      ip_set "parameter.pll_vco_ph3_en.value" "false"
#   } else {
#      ip_set "parameter.pll_vco_ph3_en.value" "true"
#   }
#}

proc ::altera_xcvr_fpll_vi::parameters::update_vco_freq_bitvec { \
	vco_frequency \
} {
	set width [get_parameter_property vco_freq_bitvec WIDTH]
	ip_set "parameter.vco_freq_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $vco_frequency $width]
}


proc ::altera_xcvr_fpll_vi::parameters::update_refclk_freq_bitvec { \
	reference_clock_frequency \
} {
	set width [get_parameter_property refclk_freq_bitvec WIDTH]
	ip_set "parameter.refclk_freq_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $reference_clock_frequency $width]
}

# ALTERA_HACK akertesz -- should get actual PFD frequency from computation code
proc ::altera_xcvr_fpll_vi::parameters::update_pfd_freq_bitvec { \
	pfd_frequency \
} {
	set width [get_parameter_property pfd_freq_bitvec WIDTH]
	ip_set "parameter.pfd_freq_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $pfd_frequency $width]
    set conv [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $pfd_frequency $width]
}

proc ::altera_xcvr_fpll_vi::parameters::update_output_freq_bitvec { \
	hssi_output_clock_frequency \
} {
	set width [get_parameter_property output_freq_bitvec WIDTH]
	ip_set "parameter.output_freq_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $hssi_output_clock_frequency $width]
}

proc ::altera_xcvr_fpll_vi::parameters::update_f_out_c0_bitvec { \
	output_clock_frequency_0 \
} {
	set width [get_parameter_property f_out_c0_bitvec WIDTH]
	ip_set "parameter.f_out_c0_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $output_clock_frequency_0 $width]
}

proc ::altera_xcvr_fpll_vi::parameters::update_f_out_c1_bitvec { \
	output_clock_frequency_1 \
} {
	set width [get_parameter_property f_out_c1_bitvec WIDTH]
	ip_set "parameter.f_out_c1_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $output_clock_frequency_1 $width]
}

proc ::altera_xcvr_fpll_vi::parameters::update_f_out_c2_bitvec { \
	output_clock_frequency_2 \
} {
	set width [get_parameter_property f_out_c2_bitvec WIDTH]
	ip_set "parameter.f_out_c2_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $output_clock_frequency_2 $width]
}

proc ::altera_xcvr_fpll_vi::parameters::update_f_out_c3_bitvec { \
	output_clock_frequency_3 \
} {
	set width [get_parameter_property f_out_c3_bitvec WIDTH]
	ip_set "parameter.f_out_c3_bitvec.value" [::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec $output_clock_frequency_3 $width]
}

proc ::altera_xcvr_fpll_vi::parameters::update_l_counter_bitvec { \
	cmu_fpll_pll_l_counter \
} {
	#set width [get_parameter_property l_counter_bitvec WIDTH]
	#ip_set "parameter.l_counter_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $cmu_fpll_pll_l_counter $width]
	ip_set "parameter.l_counter_bitvec.value" $cmu_fpll_pll_l_counter
}

proc ::altera_xcvr_fpll_vi::parameters::update_n_counter_bitvec { \
	cmu_fpll_pll_n_counter \
} {

	#set width [get_parameter_property n_counter_bitvec WIDTH]
	#ip_set "parameter.n_counter_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $cmu_fpll_pll_n_counter $width]
	ip_set "parameter.n_counter_bitvec.value" $cmu_fpll_pll_n_counter
}

proc ::altera_xcvr_fpll_vi::parameters::update_m_counter_bitvec { \
	cmu_fpll_pll_m_counter \
	cmu_fpll_pll_l_counter \
	gui_operation_mode \
	mcgb_div \
	pma_width \
} {
	set compensation_mode [get_compensation_mode $gui_operation_mode]
	set width [get_parameter_property m_counter_bitvec WIDTH]
	
	switch $compensation_mode {
		"fpll_bonding" {
			set fake_m_counter [expr $cmu_fpll_pll_l_counter * $mcgb_div * $pma_width / 2]
			#ip_set "parameter.m_counter_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $fake_m_counter $width]
			ip_set "parameter.m_counter_bitvec.value" $fake_m_counter
		}
		default {
			#ip_set "parameter.m_counter_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $cmu_fpll_pll_m_counter $width]
			ip_set "parameter.m_counter_bitvec.value" $cmu_fpll_pll_m_counter
		}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_c_counter0_bitvec { \
	cmu_fpll_pll_c_counter_0 \
} {
	#set width [get_parameter_property c_counter0_bitvec WIDTH]
	#ip_set "parameter.c_counter0_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $cmu_fpll_pll_c_counter_0 $width]
	ip_set "parameter.cmu_fpll_m_counter_c0.value" $cmu_fpll_pll_c_counter_0
}

proc ::altera_xcvr_fpll_vi::parameters::update_c_counter1_bitvec { \
	cmu_fpll_pll_c_counter_1 \
} {
	#set width [get_parameter_property c_counter1_bitvec WIDTH]
	#ip_set "parameter.c_counter1_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $cmu_fpll_pll_c_counter_1 $width]
	ip_set "parameter.cmu_fpll_m_counter_c1.value" $cmu_fpll_pll_c_counter_1
}

proc ::altera_xcvr_fpll_vi::parameters::update_c_counter2_bitvec { \
	cmu_fpll_pll_c_counter_2 \
} {
	#set width [get_parameter_property c_counter2_bitvec WIDTH]
	#ip_set "parameter.c_counter2_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $cmu_fpll_pll_c_counter_2 $width]
	ip_set "parameter.cmu_fpll_m_counter_c2.value" $cmu_fpll_pll_c_counter_2
}

proc ::altera_xcvr_fpll_vi::parameters::update_c_counter3_bitvec { \
	cmu_fpll_pll_c_counter_3 \
} {
	#set width [get_parameter_property c_counter3_bitvec WIDTH]
	#ip_set "parameter.c_counter3_bitvec.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $cmu_fpll_pll_c_counter_3 $width]
	ip_set "parameter.cmu_fpll_m_counter_c3.value" $cmu_fpll_pll_c_counter_3
}

proc ::altera_xcvr_fpll_vi::parameters::update_pma_width_bitvec { \
	pma_width \
} {
	#ip_set "parameter.cmu_fpll_pma_width.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $pma_width]
	ip_set "parameter.pma_width_bitvec.value" $pma_width
}

proc ::altera_xcvr_fpll_vi::parameters::update_cgb_div_bitvec { \
	mcgb_div \
} {
	#ip_set "parameter.cmu_fpll_cgb_div.value" [::altera_xcvr_fpll_vi::parameters::int_to_bitvec $mcgb_div]
	ip_set "parameter.cgb_div_bitvec.value" $mcgb_div
}
proc ::altera_xcvr_fpll_vi::parameters::int_to_bitvec { \
	int_val \
	width
} {
	return [::altera_xcvr_fpll_vi::parameters::dec2bin $int_val $width]
}

proc ::altera_xcvr_fpll_vi::parameters::big_time_to_bitvec { \
	big_time_frequency \
	width
} {
	regexp {([-0-9.]+)} $big_time_frequency freq_in_mhz
	set freq_in_hz [expr round($freq_in_mhz * 1e6)]
	return [::altera_xcvr_fpll_vi::parameters::dec2bin $freq_in_hz $width]
}	

proc ::altera_xcvr_fpll_vi::parameters::get_freq_in_mhz { big_time_frequency } {
	regexp {([-0-9.]+)} $big_time_frequency freq_in_mhz
	return $freq_in_mhz
}	

proc ::altera_xcvr_fpll_vi::parameters::get_freq_in_hz { big_time_frequency } {
	regexp {([-0-9.]+)} $big_time_frequency freq_in_mhz
	set freq_in_hz [expr round($freq_in_mhz * 1e6)]
	return $freq_in_hz
}	

# Convert integer  to bitvec string
# See http://wiki.tcl.tk/1591
proc ::altera_xcvr_fpll_vi::parameters::dec2bin {i width} {
    #returns the binary representation of $i
    # width determines the length of the returned string (left truncated or added left 0)
    # use of width allows concatenation of bits sub-fields

    set res {}
    if {$i<0} {
        set sign -
        set i [expr {abs($i)}]
    } else {
        set sign {}
    }
    while {$i>0} {
        set res [expr {$i%2}]$res
        set i [expr {$i/2}]
    }
    if {$res == {}} {set res 0}

    if {$width != {}} {
        append d [string repeat 0 $width] $res
        set res [string range $d [string length $res] end]
    }
    return $sign$res
}

# +-----------------------------------
# | This function sets the Transceiver protocol parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_prot_mode { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	gui_enable_manual_hssi_counters \
	gui_enable_fractional \
	device_revision \
	enable_pll_reconfig \
} {
    variable debug_message 
    set device_is_es [::altera_xcvr_fpll_vi::parameters::does_this_device_is_es $device_revision]
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_prot_mode"
	}

	if {$gui_fpll_mode == 2} {
		switch $gui_hssi_prot_mode {
			0 {
				set prot_mode "basic_tx"
			}
			1 {
			    set prot_mode "pcie_gen1_tx"
			    if { $gui_enable_manual_hssi_counters} {
				ip_message error " Enable manual hssi counters is not valid in pcie mode, disable \"Enable manual counter configuration\" checkbox"
			    }
			}
			2 {
			    set prot_mode "pcie_gen2_tx"
			    if { $gui_enable_manual_hssi_counters} {
				ip_message error " Enable manual hssi counters is not valid in pcie mode, disable \"Enable manual counter configuration\" checkbox"
			    }
			}
			3 {
			    set prot_mode "pcie_gen3_tx"
			    if { $gui_enable_manual_hssi_counters} {
				ip_message error " Enable manual hssi counters is not valid in pcie mode, disable \"Enable manual counter configuration\" checkbox"
			    }
			}
			4 {
				set prot_mode "basic_tx"
			    if { $device_is_es } {
				ip_message error "Selected device doesn't support SDI cascade, please select device other than ES and ES2."
			    } else {
				if { !$gui_enable_manual_hssi_counters } {
				    ip_message error "In SDI_cascade mode need to select \"Enable manual counter configuration\" checkbox"
				}
				if { $gui_enable_fractional} {
				    ip_message error "Fractional mode is illegal in SDI_cascade mode, disable \"Enable Fractional mode\" checkbox"
				}
				if {$enable_pll_reconfig} {
				    ip_message info "Note that it is not legal to reconfigure between cascade mode and non-cascade mode.  Reconfiguration of parameters while remaining in cascade mode is legal."
				}
			    }
			}
			5 {
			    set prot_mode "basic_tx"
			    if { $device_is_es } {
				ip_message error "Selected device doesn't support OTN_cascade, please select device other than ES and ES2."
			    } else {
				if { !$gui_enable_manual_hssi_counters } {
				    ip_message error "In OTN_cascade mode need to select \"Enable manual counter configuration\" checkbox"
				}
				if { $gui_enable_fractional} {
				    ip_message error "Fractional mode is illegal in OTN_cascade mode, disable \"Enable Fractional mode\" checkbox"
				}
				if { $enable_pll_reconfig} {
				    ip_message info "Note that it is not legal to reconfigure between cascade mode and non-cascade mode.  Reconfiguration of parameters while remaining in cascade mode is legal."
				}
			    }
			}
			6 {
			    set prot_mode "basic_tx"
				if { $gui_enable_fractional} {
					ip_message info "In SDI direct fractional mode the pll_locked port is not available.  The user can create external lock detect using clklow and fref clock ports"
				}
			    if { $device_is_es } {
				ip_message error "Selected device doesn't support SDI Direct, please select device other than ES and ES2."
			    }
			    
			}
			7 {
				set prot_mode "sata_tx"
			}
			8 {
			    set prot_mode "basic_tx"
			    ip_message info "In OTN direct mode the pll_locked port is not reliable.  The user can create external lock detect using clklow and fref clock ports"
			    if { $device_is_es } {
				ip_message error "Selected device doesn't support OTN_direct, please select device other than ES and ES2."
			    } else {
				if { $gui_enable_manual_hssi_counters } {
				    ip_message error "Manual counter configuration is not allowed in OTN_direct mode.  Please  disable the \"Enable manual counter configuration\" checkbox"
				}
				if { $gui_enable_fractional} {
				    ip_message error "Fractional mode is illegal in OTN_direct mode, disable \"Enable Fractional mode\" checkbox"
				}
			    }
			}
			9 {
                 set prot_mode "sata_tx"

            }
			10 {
                 set prot_mode "basic_tx"

            }
            default {
				ip_message warning "Unexpected prot_mode($gui_hssi_prot_mode), selecting basic_tx"
				set prot_mode "basic_tx"
			}
		}	
	} else {
		set prot_mode "basic_tx"
	}
	
	if {$debug_message} {
		puts "  prot_mode->$prot_mode"
	}
	
	ip_set "parameter.prot_mode.value" $prot_mode
     
}  

proc ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_basic { \
	family \
	type \
	speedgrade \
	refclk_freq \
	is_fractional \
	compensation_mode \
	is_counter_cascading_enabled \
	x \
	clock_index \
	c_counter_list \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable error_occurred_in_validation
	variable error_message
	variable debug_message 

	array set desired_clock_list [list]	
	array set validated_clock_list [list]	

	foreach {counter_index freq phase unit} $c_counter_list {
		set clock_id $counter_index
		if {$counter_index < $clock_index} {
			set is_degrees [is_phase_unit_degrees $unit]
			set outclk_data [list -type c -index $counter_index -freq $freq -phase $phase -is_degrees $is_degrees]		
			::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list $clock_id $outclk_data
		} elseif {$counter_index == $clock_index} {
			set is_degrees [is_phase_unit_degrees $unit]
			set outclk_data [list -type c -index $counter_index -freq $freq -phase $phase -is_degrees $is_degrees]		
			::quartus::pll::fpll_legality::add_outclk_to_basic_input_list desired_clock_list $clock_id $outclk_data
		} else {
			set outclk_data [list -type c -index $counter_index -freq $freq]
			::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list $clock_id $outclk_data
		}
	}

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list 	-family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-is_counter_cascading_enabled $is_counter_cascading_enabled \
						-x $x \
						-validated_counter_values [array get validated_clock_list] \
						-desired_counter_values [array get desired_clock_list] \
						-f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						]


	if {$debug_message } {
		puts "  reflist:\n  $ref_list"
	}
						
	if {[catch {::quartus::pll::fpll_legality::retrieve_output_clock_phase_list $ref_list} result]} {
		set error_occurred_in_validation true
		set error_message "Error validating output phase $outclk_index. Please enter a valid phase."
		#old message: "Please specify correct outclk0 desired phase shift."
	} else {
		array set result_array $result
		set new_actual_phase_value_deg $result_array(closest_phase_deg)
		set new_actual_phase_range_deg $result_array(phase_deg)
		set new_actual_phase_value $result_array(closest_phase)
		set new_actual_phase_range $result_array(phase)
		
		array set new_result_array [list phase_value $new_actual_phase_value phase_range $new_actual_phase_range phase_value_deg $new_actual_phase_value_deg phase_range_deg $new_actual_phase_range_deg]
	}		
	
	if {$debug_message} {
		puts "  result: $result"
	}

	return [array get new_result_array] 
}	

proc ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_advanced { \
	family \
	type \
	speedgrade \
	refclk_freq \
	is_fractional \
	compensation_mode \
	x \
	m \
	n \
	k \
	clock_index \
	c_counter_list \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable error_occurred_in_validation
	variable error_message
	variable debug_message 

	array set desired_clock_list [list]	
	array set validated_clock_list [list]	

	foreach {counter_index cdiv phase unit} $c_counter_list {
		set clock_id $counter_index
		if {$counter_index < $clock_index} {
			set is_degrees [is_phase_unit_degrees $unit]
			set outclk_data [list -type c -index $counter_index -cdiv $cdiv -phase $phase -is_degrees $is_degrees]		
			::quartus::pll::fpll_legality::add_outclk_to_advanced_input_list validated_clock_list $clock_id $outclk_data
		} elseif {$counter_index == $clock_index} {
			set is_degrees [is_phase_unit_degrees $unit]
			set outclk_data [list -type c -index $counter_index -cdiv $cdiv -phase $phase -is_degrees $is_degrees]		
			::quartus::pll::fpll_legality::add_outclk_to_advanced_input_list desired_clock_list $clock_id $outclk_data
		} else {
			set outclk_data [list -type c -index $counter_index -cdiv $cdiv]
			::quartus::pll::fpll_legality::add_outclk_to_advanced_input_list validated_clock_list $clock_id $outclk_data
		}
	}

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list 	-family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-x $x \
						-m $m \
						-n $n \
						-k $k \
						-validated_counter_values [array get validated_clock_list] \
						-desired_counter_values [array get desired_clock_list] \
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						]



	if {$debug_message } {
		puts "  reflist:\n  $ref_list"
	}
						
	if {[catch {::quartus::pll::fpll_legality::retrieve_output_clock_phase_list_adv $ref_list} result]} {
		set error_occurred_in_validation true
		set error_message "Error validating output phase $outclk_index. Please enter a valid phase."
		#old message: "Please specify correct outclk0 desired phase shift."
	} else {
		array set result_array $result
		set new_actual_phase_value_deg $result_array(closest_phase_deg)
		set new_actual_phase_range_deg $result_array(phase_deg)
		set new_actual_phase_value $result_array(closest_phase)
		set new_actual_phase_range $result_array(phase)
		
		array set new_result_array [list phase_value $new_actual_phase_value phase_range $new_actual_phase_range phase_value_deg $new_actual_phase_value_deg phase_range_deg $new_actual_phase_range_deg]
	}		
	
	if {$debug_message} {
		puts "  result: $result"
	}

	return [array get new_result_array] 
}	

proc ::altera_xcvr_fpll_vi::parameters::get_validated_counter_values_basic { \
	freq_0 \
	freq_1 \
	freq_2 \
	freq_3 \
	phase_0 \
	phase_1 \
	phase_2 \
	phase_3 \
	num_clocks_used \
} {
	array set validated_clock_list [list]
	
	for {set i 0} {$i < $num_clocks_used} {incr i} {
		set outclk_data [list -type c -index $i -freq [set freq_$i] -phase [set phase_$i] -is_degrees false]
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list $i $outclk_data 
	}
	
	return [array get validated_clock_list]
	
}

proc ::altera_xcvr_fpll_vi::parameters::get_validated_counter_values_advanced { \
	cdiv_0 \
	cdiv_1 \
	cdiv_2 \
	cdiv_3 \
	phase_0 \
	phase_1 \
	phase_2 \
	phase_3 \
	num_clocks_used \
} {

	array set validated_clock_list [list]
	
	for {set i 0} {$i < $num_clocks_used} {incr i} {
		set outclk_data [list -type c -index $i -cdiv [set cdiv_$i] -phase [set phase_$i] -is_degrees false]
		::quartus::pll::fpll_legality::add_outclk_to_advanced_input_list validated_clock_list $i $outclk_data
	}
	
	return [array get validated_clock_list]
	
}

# +-----------------------------------
# | This function gets the valid phase shift that can be implemented by the given desired phase shift
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_0_values { \
	gui_fpll_mode \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_enable_manual_config \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	gui_outclk0_desired_phase_shift \
	gui_outclk0_phase_shift_unit \
	device_family \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 0
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks > $outclk_index}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_${outclk_index}_values"
		}	
		
		if {$gui_enable_manual_config} {
			switch $gui_number_of_output_clocks {
				1 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit]
				}
				2 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit \
											 1 $gui_pll_c_counter_1 N/A N/A]
				}
				3 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit \
											 1 $gui_pll_c_counter_1 N/A N/A \
											 2 $gui_pll_c_counter_2 N/A N/A]
				}
				4 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit \
											 1 $gui_pll_c_counter_1 N/A N/A \
											 2 $gui_pll_c_counter_2 N/A N/A \
											 3 $gui_pll_c_counter_3 N/A N/A]			
				}
			}
	
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				$gui_fractional_x \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]			
		} else {
			switch $gui_number_of_output_clocks {
				1 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit]
				}
				2 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit \
											 1 $full_actual_outclk1_frequency N/A N/A]
				}
				3 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit \
											 1 $full_actual_outclk1_frequency N/A N/A \
											 2 $full_actual_outclk2_frequency N/A N/A]
				}
				4 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $gui_outclk0_desired_phase_shift $gui_outclk0_phase_shift_unit \
											 1 $full_actual_outclk1_frequency N/A N/A \
											 2 $full_actual_outclk2_frequency N/A N/A \
											 3 $full_actual_outclk3_frequency N/A N/A]			
				}
			}
	
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				$gui_fractional_x \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]	
		}
		
			
	
		if {$error_occurred_in_validation} {
			ip_message error $error_message		
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		} else {
			array set result_array $result
			set phase_value $result_array(phase_value)
			set phase_range $result_array(phase_range)	
			set phase_value_deg $result_array(phase_value_deg)
			set phase_range_deg $result_array(phase_range_deg)			
			
			set rounded_phase_value [round_phase $phase_value]
			set rounded_phase_range [round_phase $phase_range]
			set rounded_phase_value_deg [round_phase $phase_value_deg]
			set rounded_phase_range_deg [round_phase $phase_range_deg]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk0_actual_phase_shift $rounded_phase_range $rounded_phase_value
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk0_actual_phase_shift_deg $rounded_phase_range_deg $rounded_phase_value_deg		
						
			ip_set "parameter.full_outclk0_actual_phase_shift.ALLOWED_RANGES" $phase_range		
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n   [get_parameter_property gui_outclk0_actual_phase_shift ALLOWED_RANGES]"
			puts "  new value: \n   [get_parameter_value gui_outclk0_actual_phase_shift]"
			puts "  new range deg: \n   [get_parameter_property gui_outclk0_actual_phase_shift_deg ALLOWED_RANGES]"
			puts "  new value deg: \n   [get_parameter_value gui_outclk0_actual_phase_shift_deg]"
			puts "  new full range: \n   [get_parameter_property full_outclk0_actual_phase_shift ALLOWED_RANGES]"			
		}	
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
	}			
	
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk0_phase_shift_value {
	gui_outclk0_actual_phase_shift \
	gui_outclk0_actual_phase_shift_deg \
	gui_outclk0_phase_shift_unit \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	set clock_index 0
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk${clock_index}_phase_shift_value"
	}
	
	set is_degrees [is_phase_unit_degrees [set gui_outclk${clock_index}_phase_shift_unit]]
	if {!$is_degrees} {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	} else {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift_deg]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift_deg ALLOWED_RANGES]	
	}
	
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_phase_range [get_parameter_property full_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_phase_range $new_index]
			
	ip_set "parameter.full_outclk${clock_index}_actual_phase_shift.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk1_phase_shift_value {
	gui_outclk1_actual_phase_shift \
	gui_outclk1_actual_phase_shift_deg \
	gui_outclk1_phase_shift_unit \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	set clock_index 1
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk${clock_index}_phase_shift_value"
	}
	
	set is_degrees [is_phase_unit_degrees [set gui_outclk${clock_index}_phase_shift_unit]]
	if {!$is_degrees} {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	} else {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift_deg]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift_deg ALLOWED_RANGES]	
	}
	
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_phase_range [get_parameter_property full_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_phase_range $new_index]
			
	ip_set "parameter.full_outclk${clock_index}_actual_phase_shift.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk2_phase_shift_value {
	gui_outclk2_actual_phase_shift \
	gui_outclk2_actual_phase_shift_deg \
	gui_outclk2_phase_shift_unit \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	set clock_index 2
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk${clock_index}_phase_shift_value"
	}
	
	set is_degrees [is_phase_unit_degrees [set gui_outclk${clock_index}_phase_shift_unit]]
	if {!$is_degrees} {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	} else {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift_deg]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift_deg ALLOWED_RANGES]	
	}
	
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_phase_range [get_parameter_property full_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_phase_range $new_index]
			
	ip_set "parameter.full_outclk${clock_index}_actual_phase_shift.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::set_full_outclk3_phase_shift_value {
	gui_outclk3_actual_phase_shift \
	gui_outclk3_actual_phase_shift_deg \
	gui_outclk3_phase_shift_unit \
} {
	variable debug_message
	variable error_occurred_in_validation
	
	set clock_index 3
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::set_full_outclk${clock_index}_phase_shift_value"
	}
	
	set is_degrees [is_phase_unit_degrees [set gui_outclk${clock_index}_phase_shift_unit]]
	if {!$is_degrees} {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	} else {
		set new_selected_value [get_parameter_value gui_outclk${clock_index}_actual_phase_shift_deg]
		set new_selected_range [get_parameter_property gui_outclk${clock_index}_actual_phase_shift_deg ALLOWED_RANGES]	
	}
	
	set new_index [::altera_xcvr_fpll_vi::parameters::get_displayed_value_index $new_selected_range $new_selected_value]
	set new_actual_phase_range [get_parameter_property full_outclk${clock_index}_actual_phase_shift ALLOWED_RANGES]
	set new_full_value [lindex $new_actual_phase_range $new_index]
			
	ip_set "parameter.full_outclk${clock_index}_actual_phase_shift.value" $new_full_value
	if {$debug_message} {
		puts "  new_full_value: $new_full_value"
	}
}

# +-----------------------------------
# | This function gets the valid phase shift that can be implemented by the given desired phase shift
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_1_values { \
	gui_fpll_mode \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_manual_config \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_outclk0_actual_phase_shift \
	gui_outclk1_desired_phase_shift \
	gui_outclk1_phase_shift_unit \
	device_family \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 1
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks > $outclk_index}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_${outclk_index}_values"
		}	
		
		if {$gui_enable_manual_config} {
			switch $gui_number_of_output_clocks {
				1 {
					error "You have failed"
				}
				2 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $full_outclk0_actual_phase_shift 0 \
											 1 $gui_pll_c_counter_1 $gui_outclk1_desired_phase_shift $gui_outclk1_phase_shift_unit]
				}
				3 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $full_outclk0_actual_phase_shift 0  \
											 1 $gui_pll_c_counter_1 $gui_outclk1_desired_phase_shift $gui_outclk1_phase_shift_unit \
											 2 $gui_pll_c_counter_2 N/A N/A]
				}
				4 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $full_outclk0_actual_phase_shift 0 \
											 1 $gui_pll_c_counter_1 $gui_outclk1_desired_phase_shift $gui_outclk1_phase_shift_unit \
											 2 $gui_pll_c_counter_2 N/A N/A \
											 3 $gui_pll_c_counter_3 N/A N/A]			
				}
			}
		
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				$gui_fractional_x \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]		
		} else {
			switch $gui_number_of_output_clocks {
				1 {
					error "You have failed"
				}
				2 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $full_outclk0_actual_phase_shift 0 \
											 1 $full_actual_outclk1_frequency $gui_outclk1_desired_phase_shift $gui_outclk1_phase_shift_unit]
				}
				3 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $full_outclk0_actual_phase_shift 0  \
											 1 $full_actual_outclk1_frequency $gui_outclk1_desired_phase_shift $gui_outclk1_phase_shift_unit \
											 2 $full_actual_outclk2_frequency N/A N/A]
				}
				4 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $full_outclk0_actual_phase_shift 0 \
											 1 $full_actual_outclk1_frequency $gui_outclk1_desired_phase_shift $gui_outclk1_phase_shift_unit \
											 2 $full_actual_outclk2_frequency N/A N/A \
											 3 $full_actual_outclk3_frequency N/A N/A]			
				}
			}
		
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				$gui_fractional_x \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]			
		}
	
		if {$error_occurred_in_validation} {
			ip_message error $error_message		
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		} else {
			array set result_array $result
			set phase_value $result_array(phase_value)
			set phase_range $result_array(phase_range)	
			set phase_value_deg $result_array(phase_value_deg)
			set phase_range_deg $result_array(phase_range_deg)			
			
			set rounded_phase_value [round_phase $phase_value]
			set rounded_phase_range [round_phase $phase_range]
			set rounded_phase_value_deg [round_phase $phase_value_deg]
			set rounded_phase_range_deg [round_phase $phase_range_deg]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift $rounded_phase_range $rounded_phase_value
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg $rounded_phase_range_deg $rounded_phase_value_deg		
						
			ip_set "parameter.full_outclk${outclk_index}_actual_phase_shift.ALLOWED_RANGES" $phase_range		
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n   [get_parameter_property gui_outclk${outclk_index}_actual_phase_shift ALLOWED_RANGES]"
			puts "  new value: \n   [get_parameter_value gui_outclk${outclk_index}_actual_phase_shift]"
			puts "  new range deg: \n   [get_parameter_property gui_outclk${outclk_index}_actual_phase_shift_deg ALLOWED_RANGES]"
			puts "  new value deg: \n   [get_parameter_value gui_outclk${outclk_index}_actual_phase_shift_deg]"
			puts "  new full range: \n   [get_parameter_property full_outclk${outclk_index}_actual_phase_shift ALLOWED_RANGES]"			
		}	
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
	}	
}

# +-----------------------------------
# | This function gets the valid phase shift that can be implemented by the given desired phase shift
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_2_values { \
	gui_fpll_mode \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_enable_manual_config \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	gui_outclk2_desired_phase_shift \
	gui_outclk2_phase_shift_unit \
	device_family \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 2
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks > $outclk_index}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_${outclk_index}_values"
		}	
		
		if {$gui_enable_manual_config } {
			switch $gui_number_of_output_clocks {
				1 {
					error "You have failed"
				}
				2 {
					error "You have failed"
				}
				3 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $full_outclk0_actual_phase_shift 0 \
											 1 $gui_pll_c_counter_1 $full_outclk1_actual_phase_shift 0 \
											 2 $gui_pll_c_counter_2 $gui_outclk2_desired_phase_shift $gui_outclk2_phase_shift_unit]
				}
				4 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $full_outclk0_actual_phase_shift 0 \
											 1 $gui_pll_c_counter_1 $full_outclk1_actual_phase_shift 0 \
											 2 $gui_pll_c_counter_2 $gui_outclk2_desired_phase_shift $gui_outclk2_phase_shift_unit \
											 3 $gui_pll_c_counter_3 N/A N/A]			
				}
			}
		
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				$gui_fractional_x \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]		
		} else {
			switch $gui_number_of_output_clocks {
				1 {
					error "You have failed"
				}
				2 {
					error "You have failed"
				}
				3 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $full_outclk0_actual_phase_shift 0  \
											 1 $full_actual_outclk1_frequency $full_outclk1_actual_phase_shift 0 \
											 2 $full_actual_outclk2_frequency $gui_outclk2_desired_phase_shift $gui_outclk2_phase_shift_unit]
				}
				4 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $full_outclk0_actual_phase_shift 0 \
											 1 $full_actual_outclk1_frequency $full_outclk1_actual_phase_shift 0 \
											 2 $full_actual_outclk2_frequency $gui_outclk2_desired_phase_shift $gui_outclk2_phase_shift_unit \
											 3 $full_actual_outclk3_frequency N/A N/A]			
				}
			}
		
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				$gui_fractional_x \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]		
		}
	
	
		if {$error_occurred_in_validation} {
			ip_message error $error_message		
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		} else {
			array set result_array $result
			set phase_value $result_array(phase_value)
			set phase_range $result_array(phase_range)	
			set phase_value_deg $result_array(phase_value_deg)
			set phase_range_deg $result_array(phase_range_deg)			
			
			set rounded_phase_value [round_phase $phase_value]
			set rounded_phase_range [round_phase $phase_range]
			set rounded_phase_value_deg [round_phase $phase_value_deg]
			set rounded_phase_range_deg [round_phase $phase_range_deg]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift $rounded_phase_range $rounded_phase_value
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg $rounded_phase_range_deg $rounded_phase_value_deg		
						
			ip_set "parameter.full_outclk${outclk_index}_actual_phase_shift.ALLOWED_RANGES" $phase_range		
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n   [get_parameter_property gui_outclk${outclk_index}_actual_phase_shift ALLOWED_RANGES]"
			puts "  new value: \n   [get_parameter_value gui_outclk${outclk_index}_actual_phase_shift]"
			puts "  new range deg: \n   [get_parameter_property gui_outclk${outclk_index}_actual_phase_shift_deg ALLOWED_RANGES]"
			puts "  new value deg: \n   [get_parameter_value gui_outclk${outclk_index}_actual_phase_shift_deg]"
			puts "  new full range: \n   [get_parameter_property full_outclk${outclk_index}_actual_phase_shift ALLOWED_RANGES]"			
		}	
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
	}	
		
}

# +-----------------------------------
# | This function gets the valid phase shift that can be implemented by the given desired phase shift
# |
proc ::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_3_values { \
	gui_fpll_mode \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_enable_manual_config \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	gui_outclk3_desired_phase_shift \
	gui_outclk3_phase_shift_unit \
	device_family \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	set outclk_index 3
	
	if {$error_occurred_in_validation} {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		return
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set enough_clocks_requested [expr {$gui_number_of_output_clocks > $outclk_index}]
	if {$using_core_mode && $enough_clocks_requested} {
	
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_${outclk_index}_values"
		}	
		
		if {$gui_enable_manual_config} {
			switch $gui_number_of_output_clocks {
				1 {
					error "You have failed"
				}
				2 {
					error "You have failed"
				}
				3 {
					error "You have failed"
				}
				4 {
					set c_counter_list [list 0 $gui_pll_c_counter_0 $full_outclk0_actual_phase_shift 0 \
											 1 $gui_pll_c_counter_1 $full_outclk1_actual_phase_shift 0 \
											 2 $gui_pll_c_counter_2 $full_outclk2_actual_phase_shift 0  \
											 3 $gui_pll_c_counter_3 $gui_outclk3_desired_phase_shift $gui_outclk3_phase_shift_unit]			
				}
			}
		
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_advanced \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				32 \
				$gui_pll_m_counter \
				$gui_pll_n_counter \
				$gui_pll_dsm_fractional_division \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]		
		} else {
			switch $gui_number_of_output_clocks {
				1 {
					error "You have failed"
				}
				2 {
					error "You have failed"
				}
				3 {
					error "You have failed"
				}
				4 {
					set c_counter_list [list 0 $full_actual_outclk0_frequency $full_outclk0_actual_phase_shift 0 \
											 1 $full_actual_outclk1_frequency $full_outclk1_actual_phase_shift 0 \
											 2 $full_actual_outclk2_frequency $full_outclk2_actual_phase_shift 0  \
											 3 $full_actual_outclk3_frequency $gui_outclk3_desired_phase_shift $gui_outclk3_phase_shift_unit]			
				}
			}
		
			set result [::altera_xcvr_fpll_vi::parameters::get_actual_phase_shift_values_basic \
				$device_family \
				"FPLL" \
				1 \
				$gui_reference_clock_frequency \
				$gui_enable_fractional \
				$compensation_mode \
				false \
				32 \
				$outclk_index \
				$c_counter_list \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
		} 
			
	
		if {$error_occurred_in_validation} {
			ip_message error $error_message		
			set error_occurred_in_validation true
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
		} else {
			array set result_array $result
			set phase_value $result_array(phase_value)
			set phase_range $result_array(phase_range)	
			set phase_value_deg $result_array(phase_value_deg)
			set phase_range_deg $result_array(phase_range_deg)			
			
			set rounded_phase_value [round_phase $phase_value]
			set rounded_phase_range [round_phase $phase_range]
			set rounded_phase_value_deg [round_phase $phase_value_deg]
			set rounded_phase_range_deg [round_phase $phase_range_deg]
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift $rounded_phase_range $rounded_phase_value
			::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg $rounded_phase_range_deg $rounded_phase_value_deg		
						
			ip_set "parameter.full_outclk${outclk_index}_actual_phase_shift.ALLOWED_RANGES" $phase_range		
		}
		
		if {$debug_message} {
			puts "  ---\n  result: \n  $result"
			puts "  new range: \n   [get_parameter_property gui_outclk${outclk_index}_actual_phase_shift ALLOWED_RANGES]"
			puts "  new value: \n   [get_parameter_value gui_outclk${outclk_index}_actual_phase_shift]"
			puts "  new range deg: \n   [get_parameter_property gui_outclk${outclk_index}_actual_phase_shift_deg ALLOWED_RANGES]"
			puts "  new value deg: \n   [get_parameter_value gui_outclk${outclk_index}_actual_phase_shift_deg]"
			puts "  new full range: \n   [get_parameter_property full_outclk${outclk_index}_actual_phase_shift ALLOWED_RANGES]"			
		}	
	} else {
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift "N/A" "N/A"
		::altera_xcvr_fpll_vi::parameters::map_allowed_range gui_outclk${outclk_index}_actual_phase_shift_deg "N/A" "N/A"
	}	
		
}

# +-----------------------------------
# | This function sets phase_shift_0 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_phase_shift_0 { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	gui_number_of_output_clocks \
	full_outclk0_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {

	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_phase_shift_0"
	}	
	
	set clock_phase_unused_value "0 ps"

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode] 
		if {$using_pcie_prot_mode} {
			set clock_phase $clock_phase_unused_value
		} else {
			set clock_phase $clock_phase_unused_value
		}	
	} elseif {$using_cascade_mode} {
		set clock_phase $clock_phase_unused_value	
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 0} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set clock_phase $clock_phase_unused_value
			} else {
				set clock_phase "[round_phase $full_outclk3_actual_phase_shift] ps"
			}
		} else {
			if {$gui_number_of_output_clocks < 1} {
				set clock_phase $clock_freq_unused_value
			} else {
				set clock_phase "[round_phase $full_outclk0_actual_phase_shift] ps"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.phase_shift_0.value" $clock_phase
	
	if {$debug_message} {
		puts "  phase_shift_0->$clock_phase"
	}	

}

# +-----------------------------------
# | This function sets phase_shift_1 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_phase_shift_1 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	full_outclk1_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_phase_shift_1"
	}		
	
	set clock_phase_unused_value "0 ps"

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set clock_phase $clock_phase_unused_value	
	} elseif {$using_cascade_mode} {
		set clock_phase $clock_phase_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 1} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set clock_phase $clock_phase_unused_value
			} else {
				set clock_phase "[round_phase $full_outclk3_actual_phase_shift] ps"
			}
		} else {
			if {$gui_number_of_output_clocks < 2} {
				set clock_phase $clock_phase_unused_value
			} else {
				set clock_phase "[round_phase $full_outclk1_actual_phase_shift] ps"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.phase_shift_1.value" $clock_phase
	
	if {$debug_message} {
		puts "  phase_shift_1->$clock_phase"
	}	
}

# +-----------------------------------
# | This function sets phase_shift_2 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_phase_shift_2 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_phase_shift_2"
	}		
	
	set clock_phase_unused_value "0 ps"

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set clock_phase $clock_phase_unused_value	
	} elseif {$using_cascade_mode} {
		set clock_phase $clock_phase_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 2} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set clock_phase $clock_phase_unused_value
			} else {
				set clock_phase "[round_phase $full_outclk3_actual_phase_shift] ps"
			}
		} else {
			if {$gui_number_of_output_clocks < 3} {
				set clock_phase $clock_phase_unused_value
			} else {
				set clock_phase "[round_phase $full_outclk2_actual_phase_shift] ps"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.phase_shift_2.value" $clock_phase
	
	if {$debug_message} {
		puts "  phase_shift_2->$clock_phase"
	}	
}

# +-----------------------------------
# | This function sets phase_shift_3 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_phase_shift_3 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_cascade_outclk_index \
	gui_enable_cascade_out \
} {

	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_phase_shift_3"
	}		
	
	set clock_phase_unused_value "0 ps"

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set clock_phase $clock_phase_unused_value	
	} elseif {$using_cascade_mode} {
		set clock_phase $clock_phase_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out} {
			switch $gui_cascade_outclk_index {
				0 {
					set clock_phase "[round_phase $full_outclk0_actual_phase_shift] ps"
				}
				1 {
					set clock_phase "[round_phase $full_outclk1_actual_phase_shift] ps"
				}
				2 {
					set clock_phase "[round_phase $full_outclk2_actual_phase_shift] ps"
				}
				3 {
					set clock_phase "[round_phase $full_outclk3_actual_phase_shift] ps"
				}
				default {
					error "IE: Unknown clock index"
				}
			}
		} else {
			if {$gui_number_of_output_clocks < 4} {
				set clock_phase $clock_phase_unused_value
			} else {
				set clock_phase "[round_phase $full_outclk3_actual_phase_shift] ps"
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.phase_shift_3.value" $clock_phase
	
	if {$debug_message} {
		puts "  phase_shift_3->$clock_phase"
	}	
}

# +-----------------------------------
# | This function sets pll_clkin_0_src parameter
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_clkin_0_src {} {
#   ip_set "parameter.pll_clkin_0_src.value" "pll_clkin_0_src_lvpecl"
#}

# +-----------------------------------
# | This function sets pll_clkin_1_src parameter
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_clkin_1_src {} {
#   ip_set "parameter.pll_clkin_1_src.value" "pll_clkin_1_src_ref_clk"
#}

# +-----------------------------------
# | This function sets pll_auto_clk_sw_en parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_auto_clk_sw_en { gui_fpll_mode gui_refclk_switch gui_switchover_mode gui_switchover_delay} {
   array set switchover_param_settings [::altera_xcvr_fpll_vi::parameters::get_switchover_mode_settings $gui_fpll_mode $gui_refclk_switch $gui_switchover_mode $gui_switchover_delay]
   ip_set "parameter.pll_auto_clk_sw_en.value" $switchover_param_settings(pll_auto_clk_sw_en)
}

# +-----------------------------------
# | This function sets pll_clk_loss_edge parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_clk_loss_edge {} {
   ip_set "parameter.pll_clk_loss_edge.value" pll_clk_loss_both_edges
}

# +-----------------------------------
# | This function sets pll_clk_loss_sw_en parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_clk_loss_sw_en { \
   gui_fpll_mode \
   gui_refclk_switch \
   gui_switchover_mode \
   gui_switchover_delay \
} {
   array set switchover_param_settings [::altera_xcvr_fpll_vi::parameters::get_switchover_mode_settings $gui_fpll_mode $gui_refclk_switch $gui_switchover_mode $gui_switchover_delay]
   ip_set "parameter.pll_clk_loss_sw_en.value" $switchover_param_settings(pll_clk_loss_sw_en)
}

# +-----------------------------------
# | This function sets pll_clk_sw_dly parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_clk_sw_dly { \
   gui_fpll_mode \
   gui_refclk_switch \
   gui_switchover_mode \
   gui_switchover_delay \
} {
   array set switchover_param_settings [::altera_xcvr_fpll_vi::parameters::get_switchover_mode_settings $gui_fpll_mode $gui_refclk_switch $gui_switchover_mode $gui_switchover_delay]
   ip_set "parameter.pll_clk_sw_dly.value" $switchover_param_settings(pll_clk_sw_dly)
}

# +-----------------------------------
# | This function sets pll_manu_clk_sw_en parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_manu_clk_sw_en { gui_fpll_mode gui_refclk_switch gui_switchover_mode gui_switchover_delay} {
   array set switchover_param_settings [::altera_xcvr_fpll_vi::parameters::get_switchover_mode_settings $gui_fpll_mode $gui_refclk_switch $gui_switchover_mode $gui_switchover_delay]
   ip_set "parameter.pll_manu_clk_sw_en.value" $switchover_param_settings(pll_manu_clk_sw_en)
}

# +-----------------------------------
# | This function sets pll_manu_clk_sw_en parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_gui_enable_extswitch { gui_fpll_mode gui_refclk_switch gui_switchover_mode gui_switchover_delay} {
	array set switchover_param_settings [::altera_xcvr_fpll_vi::parameters::get_switchover_mode_settings $gui_fpll_mode $gui_refclk_switch $gui_switchover_mode $gui_switchover_delay]
	ip_set "parameter.gui_enable_extswitch.value" $switchover_param_settings(gui_enable_extswitch)
}

# +-----------------------------------
# | This function sets pll_sw_refclk_src parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_sw_refclk_src { gui_refclk_switch } {
   ip_set "parameter.pll_sw_refclk_src.value" "pll_sw_refclk_src_clk_0"
}

# +-----------------------------------
# | This function sets refclk_select1 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_refclk_select0 { gui_refclk_switch } {
	ip_set "parameter.refclk_select0.value" "lvpecl"
}

# +-----------------------------------
# | This function sets refclk_select1 parameter
# |
proc ::altera_xcvr_fpll_vi::parameters::update_refclk_select1 { gui_refclk_switch } {
	ip_set "parameter.refclk_select1.value" "ref_iqclk0"
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_c_counter_0 \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0"
	}	
	
	set default_value 1
	
	set clock_index 0
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		if {$gui_enable_manual_config} {
			set counter_value $gui_pll_c_counter_0
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(cnt_div)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_0.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_0->$counter_value"
	}
	
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_in_src {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_ph_mux_prst {
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_ph_mux_prst"
	}	
	
	set default_value 0
	
	set clock_index 0
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_0_ph_mux_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_0_ph_mux_prst->$counter_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_prst"
	}	
	
	set default_value 1
	
	set clock_index 0
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				] 
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_0_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_0_prst->$counter_value"
	}

}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_coarse_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_0_fine_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_c_counter_1 \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1"
	}	
	
	set default_value 1
	
	set clock_index 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set counter_value $gui_pll_c_counter_1
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional

			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(cnt_div)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_1.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_1->$counter_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_in_src {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_ph_mux_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_ph_mux_prst"
	}	
	
	set default_value 0
	
	set clock_index 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_1_ph_mux_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_1_ph_mux_prst->$counter_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_prst"
	}	
	
	set default_value 1
	
	set clock_index 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_1_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_1_prst->$counter_value"
	}

}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_coarse_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_1_fine_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_c_counter_2 \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2"
	}	
	
	set default_value 1
	
	set clock_index 2
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set counter_value $gui_pll_c_counter_2
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(cnt_div)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_2.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_2->$counter_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_in_src {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_ph_mux_prst {
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_ph_mux_prst"
	}	
	
	set default_value 0
	
	set clock_index 2
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
                		$cmu_fpll_f_max_vco \
                		$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_2_ph_mux_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_2_ph_mux_prst->$counter_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_prst"
	}	
	
	set default_value 1
	
	set clock_index 2
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use\
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_2_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_2_prst->$counter_value"
	}

}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_coarse_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_2_fine_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_c_counter_3 \
	gui_enable_manual_config \
	gui_reference_clock_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3"
	}	
	
	set default_value 1
	
	set clock_index 3
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set counter_value $gui_pll_c_counter_3
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(cnt_div)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_3.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_3->$counter_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_in_src {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_ph_mux_prst {
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_ph_mux_prst"
	}	
	
	set default_value 0
	
	set clock_index 3
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(ph_mux_tap)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_3_ph_mux_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_3_ph_mux_prst->$counter_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	gui_enable_manual_config \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_reference_clock_frequency \
	gui_enable_fractional \
	gui_pll_c_counter_0 \
	gui_pll_c_counter_1 \
	gui_pll_c_counter_2 \
	gui_pll_c_counter_3 \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	gui_pll_m_counter \
	gui_pll_n_counter \
	gui_pll_dsm_fractional_division \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_prst"
	}	
	
	set default_value 1
	
	set clock_index 3
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode && $gui_number_of_output_clocks > $clock_index } {
		
		#TODO!!!
		if {$gui_enable_manual_config} {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			set m $gui_pll_m_counter
			set n $gui_pll_n_counter
			set k $gui_pll_dsm_fractional_division
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$m \
				$n \
				$k \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$gui_pll_c_counter_0 \
				$gui_pll_c_counter_1 \
				$gui_pll_c_counter_2 \
				$gui_pll_c_counter_3 \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)	
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$clock_index \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(preset)		
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_c_counter_3_prst.value" $counter_value
	if {$debug_message} {
		puts "  core_c_counter_3_prst->$counter_value"
	}

}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_coarse_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_c_counter_3_fine_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
	mcgb_div \
	pma_width \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_pll_set_hssi_l_counter \
	gui_enable_manual_hssi_counters \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} { 
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter"
	}	
	
	set default_value 1
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		set is_hssi_clock_not_pcie_0_clock true
		
		if {$compensation_mode == "fpll_bonding"} {
			set unnecessary_counter_value 1
			set hssi_div [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
							$compensation_mode \
							$mcgb_div \
							$pma_width \
							$unnecessary_counter_value \
							$unnecessary_counter_value]
		} else {
			set hssi_div 1
		}
		
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_hssi_output_clock_frequency \
					$gui_hssi_prot_mode \
					$is_hssi_clock_not_pcie_0_clock \
					$hssi_div \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$gui_pll_set_hssi_l_counter \
					$gui_enable_manual_hssi_counters \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set counter_value $result_array(cnt_div)
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_l_counter.value" $counter_value
	if {$debug_message} {
		puts "  hssi_l_counter->$counter_value"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_in_src {} {

}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_bypass { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
	mcgb_div \
	pma_width \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_pll_set_hssi_l_counter \
	gui_enable_manual_hssi_counters \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} { 
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_bypass"
	}	
	
	set default_value 1
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		set is_hssi_clock_not_pcie_0_clock true
		
		if {$compensation_mode == "fpll_bonding"} {
			set unnecessary_counter_value 1
			set hssi_div [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
							$compensation_mode \
							$mcgb_div \
							$pma_width \
							$unnecessary_counter_value \
							$unnecessary_counter_value]
		} else {
			set hssi_div 1
		}
		
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_hssi_output_clock_frequency \
					$gui_hssi_prot_mode \
					$is_hssi_clock_not_pcie_0_clock \
					$hssi_div \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$gui_pll_set_hssi_l_counter \
					$gui_enable_manual_hssi_counters \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set bypass_value $result_array(bypass)
	} else {
		set bypass_value $default_value
	}
	
	ip_set "parameter.hssi_l_counter_bypass.value" $bypass_value
	if {$debug_message} {
		puts "  hssi_l_counter_bypass->$bypass_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_enable { \
	gui_fpll_mode \
} { 
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_enable"
	}	
	
	set default_value false
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		set enable_value true
	} else {
		set enable_value $default_value
	}
	
	ip_set "parameter.hssi_l_counter_enable.value" $enable_value
	if {$debug_message} {
		puts "  hssi_l_counter_enable->$enable_value"
	}
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_ph_mux_prst { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
	mcgb_div \
	pma_width \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_pll_set_hssi_l_counter \
	gui_enable_manual_hssi_counters \
        temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_l_counter_ph_mux_prst"
	}	
	
	set default_value 0
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		set is_hssi_clock_not_pcie_0_clock true
		
		if {$compensation_mode == "fpll_bonding"} {
			set unnecessary_counter_value 1
			set hssi_div [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
							$compensation_mode \
							$mcgb_div \
							$pma_width \
							$unnecessary_counter_value \
							$unnecessary_counter_value]
		} else {
			set hssi_div 1
		}
		
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_hssi_output_clock_frequency \
					$gui_hssi_prot_mode \
					$is_hssi_clock_not_pcie_0_clock \
					$hssi_div \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use\
					$gui_pll_set_hssi_l_counter \
					$gui_enable_manual_hssi_counters \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set ph_mux_tap_value $result_array(ph_mux_tap)
	} else {
		set ph_mux_tap_value $default_value
	}
	
	ip_set "parameter.hssi_l_counter_ph_mux_prst.value" $ph_mux_tap_value
	if {$debug_message} {
		puts "  hssi_l_counter_ph_mux_prst->$ph_mux_tap_value"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0 { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_pll_set_hssi_l_counter \
	gui_enable_manual_hssi_counters \
        temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0"
	}	
	
	set default_value 1
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode]
	if {$using_hssi_mode && $using_pcie_prot_mode} {
		set is_hssi_clock_not_pcie_0_clock false
		set hssi_div 1
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_hssi_output_clock_frequency \
					$gui_hssi_prot_mode \
					$is_hssi_clock_not_pcie_0_clock \
					$hssi_div \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$gui_pll_set_hssi_l_counter \
					$gui_enable_manual_hssi_counters \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set counter_value $result_array(cnt_div)
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_pcie_c_counter_0.value" $counter_value
	if {$debug_message} {
		puts "  hssi_pcie_c_counter_0->$counter_value"
	}	
	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_in_src {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_ph_mux_prst { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_pll_set_hssi_l_counter \
	gui_enable_manual_hssi_counters \
        temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_ph_mux_prst"
	}	
	
	set default_value 0
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode]
	if {$using_hssi_mode && $using_pcie_prot_mode} {
		set is_hssi_clock_not_pcie_0_clock false
		set hssi_div 1
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_hssi_output_clock_frequency \
					$gui_hssi_prot_mode \
					$is_hssi_clock_not_pcie_0_clock \
					$hssi_div \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$gui_pll_set_hssi_l_counter \
					$gui_enable_manual_hssi_counters \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set ph_mux_tap_value $result_array(ph_mux_tap)
	} else {
		set ph_mux_tap_value $default_value
	}
	
	ip_set "parameter.hssi_pcie_c_counter_0_ph_mux_prst.value" $ph_mux_tap_value
	if {$debug_message} {
		puts "  hssi_pcie_c_counter_0_ph_mux_prst->$ph_mux_tap_value"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_prst { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_pll_set_hssi_l_counter \
	gui_enable_manual_hssi_counters \
        temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_prst"
	}	
	
	set default_value 1
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode]
	if {$using_hssi_mode && $using_pcie_prot_mode} {
		set is_hssi_clock_not_pcie_0_clock false
		set hssi_div 1
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_hssi_output_clock_frequency \
					$gui_hssi_prot_mode \
					$is_hssi_clock_not_pcie_0_clock \
					$hssi_div \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$gui_pll_set_hssi_l_counter \
					$gui_enable_manual_hssi_counters \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set prst_value $result_array(preset)
	} else {
		set prst_value $default_value
	}
	
	ip_set "parameter.hssi_pcie_c_counter_0_prst.value" $prst_value
	if {$debug_message} {
		puts "  hssi_pcie_c_counter_0_prst->$prst_value"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_coarse_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_pcie_c_counter_0_fine_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter"
	}	
	
	set default_value 1
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_desired_hssi_cascade_frequency \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set counter_value $result_array(cnt_div)
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_cascade_c_counter.value" $counter_value
	if {$debug_message} {
		puts "  hssi_cascade_c_counter->$counter_value"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_in_src {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_ph_mux_prst { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_ph_mux_prst"
	}	
	
	set default_value 0
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_desired_hssi_cascade_frequency \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set ph_mux_value $result_array(ph_mux_tap)
	} else {
		set ph_mux_value $default_value
	}
	
	ip_set "parameter.hssi_cascade_c_counter_ph_mux_prst.value" $ph_mux_value
	if {$debug_message} {
		puts "  hssi_cascade_c_counter_ph_mux_prst->$ph_mux_value"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_prst { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_prst"
	}	
	
	set default_value 1
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_cnt_params_basic \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$gui_enable_fractional \
					$gui_desired_hssi_cascade_frequency \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set prst_value $result_array(preset)
	} else {
		set prst_value $default_value
	}
	
	ip_set "parameter.hssi_cascade_c_counter_prst.value" $prst_value
	if {$debug_message} {
		puts "  hssi_cascade_c_counter_prst->$prst_value"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_coarse_dly {} {
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_c_counter_fine_dly {} {
}

# +-----------------------------------
# | This function sets pll_c_counter_0 parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0 { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	hssi_pcie_c_counter_0 \
	core_c_counter_0 \
	core_c_counter_3 \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0"
	}
	
	set counter_unused_value 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode] 
		if {$using_pcie_prot_mode} {
			set counter_val $hssi_pcie_c_counter_0
		} else {
			set counter_val $counter_unused_value
		}	
	} elseif {$using_cascade_mode} {
		set counter_val $counter_unused_value	
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 0} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set counter_val $counter_unused_value
			} else {
				set counter_val $core_c_counter_3
			}
		} else {
			if {$gui_number_of_output_clocks < 1} {
				set counter_val $counter_unused_value
			} else {
				set counter_val $core_c_counter_0
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_0.value" $counter_val
	
	if {$debug_message} {
		puts "  pll_c_counter_0->$counter_val"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_adv { \
	refclk_freq \
	family \
	speedgrade \
	x \
	m \
	n \
	k \
	num_clocks_selected \
	compensation_mode \
	is_fractional \
	cnt_0 \
	cnt_1 \
	cnt_2 \
	cnt_3 \
	phase_0 \
	phase_1 \
	phase_2 \
	phase_3 \
	clock_index \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional\
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_message
	variable error_occurred_in_validation
	
	set type "FPLL"
	set is_cnt_casc_en false
	
	array set validated_clock_list [list]
	for {set i 0} {$i < $num_clocks_selected} {incr i} {
		set is_degrees false
		set outclk_data [list -type c -index $i -cdiv [set cnt_$i] -phase [set phase_$i] -is_degrees $is_degrees]	
		::quartus::pll::fpll_legality::add_outclk_to_advanced_input_list validated_clock_list $i $outclk_data
	}

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-compensation_mode $compensation_mode \
						-x $x \
						-m $m \
						-n $n \
						-k $k \
						-validated_counter_values [array get validated_clock_list] \
						-clock_index $clock_index\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						]


	if {$debug_message} {
		puts "  ref_list:\n  $ref_list"
	}							
	if {[catch {::quartus::pll::fpll_legality::get_physical_c_cnt_values_adv $ref_list} result]} {
		set error_message "Error getting physical c_cnt value ($result)"
		set error_occurred_in_validation true
		ip_message error $error_message
		return
	} else {
		set ret_val $result
	}
	if {$debug_message} {
		puts "  ---\n  result:\n  $result"
	}
	
	return $ret_val
}

proc ::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_cnt_params_basic { \
	refclk_freq \
	family \
	speedgrade \
	x \
	compensation_mode \
	is_fractional \
	hssi_cascade_freq \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_message
	variable error_occurred_in_validation

	set type "FPLL"
	set is_cnt_casc_en false

	array set validated_clock_list [list]

	set is_degrees false
	set outclk_data [list -type c -index 0 -freq $hssi_cascade_freq -phase 0.0 -is_degrees $is_degrees]		
	::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data	
	set clock_index 0

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]



	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-is_counter_cascading_enabled $is_cnt_casc_en \
						-compensation_mode $compensation_mode \
						-x $x \
						-validated_counter_values [array get validated_clock_list] \
						-clock_index $clock_index\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision\
                        -primary_use $primary_use\
						]


	if {$debug_message} {
		puts "  ref_list:\n  $ref_list"
	}							
	if {[catch {::quartus::pll::fpll_legality::get_physical_c_cnt_values_basic $ref_list} result]} {
		set error_message "Error getting physical hssi cascade clock value ($result)"
		set error_occurred_in_validation true
		ip_message error $error_message
		return
	} else {
		set ret_val $result
	}
	if {$debug_message} {
		puts "  ---\n  result:\n  $result"
	}
	
	return $ret_val	
}

proc ::altera_xcvr_fpll_vi::parameters::get_hssi_physical_cnt_params_basic { \
	refclk_freq \
	family \
	speedgrade \
	x \
	compensation_mode \
	is_fractional \
	hssi_output_freq \
	hssi_prot_mode \
	is_hssi_clock_not_pcie_0_clock \
	hssi_div \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use \
	gui_pll_set_hssi_l_counter \
	gui_enable_manual_hssi_counters \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_message
	variable error_occurred_in_validation

	set type "FPLL"
	set is_cnt_casc_en false

	array set validated_clock_list [list]
	set using_pcie_prot_mode [using_pcie_prot_mode $hssi_prot_mode]
	set device_is_es [::altera_xcvr_fpll_vi::parameters::does_this_device_is_es $device_revision]
	
	if {$gui_enable_manual_hssi_counters} {
		if {$using_pcie_prot_mode} {
# When in PCIe mode we force C0 to be at 500MHz 
			if { $device_is_es } {
				set ret_val [list cnt_div 10 preset 1 ph_mux_tap 0 bypass 0] 
			} else {
				set ret_val [list cnt_div 5 preset 1 ph_mux_tap 0 bypass 0] 
			}
		} else {
			set ret_val [list cnt_div $gui_pll_set_hssi_l_counter preset 1 ph_mux_tap 0 bypass 0]
		}
    } else {
	if {$using_pcie_prot_mode} {
		set is_degrees false
		set outclk_data [list -type c -index 0 -freq 500.0 -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data

		set is_degrees false
		set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 1 $outclk_data	

		if {$is_hssi_clock_not_pcie_0_clock} {
			set clock_index 1
		} else {
			set clock_index 0
		}
	} else {
		set is_degrees false
		set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data	

		if {$is_hssi_clock_not_pcie_0_clock} {
			set clock_index 0
		} else {
			error "IE: You can't request a pcie clock if you're not in pcie mode."
		}
	}

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-is_counter_cascading_enabled $is_cnt_casc_en \
						-compensation_mode $compensation_mode \
						-x $x \
						-validated_counter_values [array get validated_clock_list] \
						-clock_index $clock_index \
						-hssi_div $hssi_div\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision\
                        -primary_use $primary_use\
						]


	if {$debug_message} {
		puts "  ref_list:\n  $ref_list"
	}							
	if {[catch {::quartus::pll::fpll_legality::get_physical_c_cnt_values_basic $ref_list} result]} {
		set error_message "Error getting physical hssi clock value ($result)"
		set error_occurred_in_validation true
		ip_message error $error_message
		return
	} else {
		set ret_val $result
	}
	if {$debug_message} {
		puts "  ---\n  result:\n  $result"
	}
	}
	
	return $ret_val
	
}

proc ::altera_xcvr_fpll_vi::parameters::make_core_mode_outclk_list_basic {\
	freq_0 \
	freq_1 \
	freq_2 \
	freq_3 \
	phase_0 \
	phase_1 \
	phase_2 \
	phase_3 \
	num_clocks_used \
} {
	array set validated_clock_list [list]
	for {set i 0} {$i < $num_clocks_used} {incr i} {
		set is_degrees false
		set outclk_data [list -type c -index $i -freq [set freq_$i] -phase [set phase_$i] -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list $i $outclk_data
	}
	
	return [array get validated_clock_list]
}

proc ::altera_xcvr_fpll_vi::parameters::make_core_mode_outclk_list_advanced {\
	cnt_0 \
	cnt_1 \
	cnt_2 \
	cnt_3 \
	phase_0 \
	phase_1 \
	phase_2 \
	phase_3 \
	num_clocks_used \
} {
	array set validated_clock_list [list]
	for {set i 0} {$i < $num_clocks_used} {incr i} {
		set is_degrees false
		set outclk_data [list -type c -index $i -cdiv [set cnt_$i] -phase [set phase_$i] -is_degrees $is_degrees]	
		::quartus::pll::fpll_legality::add_outclk_to_advanced_input_list validated_clock_list $i $outclk_data
	}
	
	return [array get validated_clock_list]
}

proc ::altera_xcvr_fpll_vi::parameters::get_core_physical_cnt_params_basic { \
	refclk_freq \
	family \
	speedgrade \
	x \
	num_clocks_selected \
	compensation_mode \
	is_fractional \
	freq_0 \
	freq_1 \
	freq_2 \
	freq_3 \
	phase_0 \
	phase_1 \
	phase_2 \
	phase_3 \
	clock_index \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_message
	variable error_occurred_in_validation
	
	set type "FPLL"
	set is_cnt_casc_en false
	
	array set validated_clock_list [list]
	for {set i 0} {$i < $num_clocks_selected} {incr i} {
		set is_degrees false
		set outclk_data [list -type c -index $i -freq [set freq_$i] -phase [set phase_$i] -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list $i $outclk_data
	}
	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-is_counter_cascading_enabled $is_cnt_casc_en \
						-compensation_mode $compensation_mode \
						-x $x \
						-validated_counter_values [array get validated_clock_list] \
						-clock_index $clock_index\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision\
                        -primary_use $primary_use\
						]



	if {$debug_message} {
		puts "  ref_list:\n  $ref_list"
	}							
	if {[catch {::quartus::pll::fpll_legality::get_physical_c_cnt_values_basic $ref_list} result]} {
		set error_message "IE: Error getting physical c_cnt value ($result)"
		set error_occurred_in_validation true
		ip_message error $error_message
		return
	} else {
		set ret_val $result
	}
	if {$debug_message} {
		puts "  ---\n  result:\n  $result"
	}
	
	return $ret_val
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_m_counter { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	mcgb_div \
	pma_width \
	pll_l_counter \
	gui_hssi_prot_mode \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_enable_manual_hssi_counters \
	gui_pll_set_hssi_m_counter \
	gui_pll_set_hssi_n_counter \
	gui_pll_set_hssi_k_counter \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_m_counter"
	}	
	
	set default_value 11
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		if {$compensation_mode == "fpll_bonding"} {
			set unnecessary_counter_value 1
			set hssi_div [::altera_xcvr_fpll_vi::parameters::get_feedback_division \
							$compensation_mode \
							$mcgb_div \
							$pma_width \
							$unnecessary_counter_value \
							$pll_l_counter]
			set counter_value $hssi_div
		} else {
			
			set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_m_cnt_params \
						$full_actual_refclk_frequency \
						$device_family \
						$numeric_speed_grade \
						$gui_fractional_x \
						$compensation_mode \
						$gui_enable_fractional \
						$gui_hssi_output_clock_frequency \
						$gui_hssi_prot_mode \
    						$cmu_fpll_f_min_vco \
    						$cmu_fpll_f_max_vco \
    						$cmu_fpll_f_min_pfd \
						$device_revision \
						$gui_enable_fractional \
						$primary_use \
						$gui_enable_manual_hssi_counters \
						$gui_pll_set_hssi_m_counter \
						$gui_pll_set_hssi_n_counter \
						$gui_pll_set_hssi_k_counter \
						$temp_bw_sel \
						$gui_is_downstream_cascaded_pll \
						]
			if {$error_occurred_in_validation} {
				return
			} 
			array set result_array $result
			set counter_value $result_array(m)
		}
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_m_counter.value" $counter_value
	if {$debug_message} {
		puts "  hssi_m_counter->$counter_value"
	}		
}
proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_m_counter { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_m_counter"
	}	
	
	set default_value 11
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set family $device_family
		set speedgrade $numeric_speed_grade
		set x $gui_fractional_x
		set compensation_mode $compensation_mode
		set is_fractional $gui_enable_fractional
		set hssi_cascade_freq $gui_desired_hssi_cascade_frequency
		set refclk_freq $full_actual_refclk_frequency
		
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_m_cnt_params \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$is_fractional \
					$hssi_cascade_freq \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set counter_value $result_array(m)
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_cascade_m_counter.value" $counter_value
	if {$debug_message} {
		puts "  hssi_cascade_m_counter->$counter_value"
	}		
}


proc ::altera_xcvr_fpll_vi::parameters::update_core_n_counter { \
	gui_fpll_mode \
	device_family \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	numeric_speed_grade \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_n_counter \
	gui_enable_manual_config \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_n_counter"
	}	
	
	set default_value 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode} {
	
		if {$gui_enable_manual_config} {
			set counter_value $gui_pll_n_counter
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_m_cnt_params \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(n)	
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_n_counter.value" $counter_value
	if {$debug_message} {
		puts "  core_n_counter->$counter_value"
	}	
	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_n_counter { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_enable_manual_hssi_counters \
	gui_pll_set_hssi_m_counter \
	gui_pll_set_hssi_n_counter \
	gui_pll_set_hssi_k_counter \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_n_counter"
	}	
	
	set default_value 1
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		if {$compensation_mode == "fpll_bonding"} {
			set counter_value $default_value
			#TODO: should this be extracted from the computation code? Do we need this if? Is this necessary?
		} else {
			set is_hssi_clock_not_pcie_0_clock true
			
			set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_m_cnt_params \
						$full_actual_refclk_frequency \
						$device_family \
						$numeric_speed_grade \
						$gui_fractional_x \
						$compensation_mode \
						$gui_enable_fractional \
						$gui_hssi_output_clock_frequency \
						$gui_hssi_prot_mode \
    						$cmu_fpll_f_min_vco \
    						$cmu_fpll_f_max_vco \
    						$cmu_fpll_f_min_pfd \
						$device_revision \
						$gui_enable_fractional\
						$primary_use \
						$gui_enable_manual_hssi_counters \
						$gui_pll_set_hssi_m_counter \
						$gui_pll_set_hssi_n_counter \
						$gui_pll_set_hssi_k_counter \
						$temp_bw_sel \
						$gui_is_downstream_cascaded_pll \
						]
			if {$error_occurred_in_validation} {
				return
			} 
			array set result_array $result
			set counter_value $result_array(n)
		}
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_n_counter.value" $counter_value
	if {$debug_message} {
		puts "  hssi_n_counter->$counter_value"
	}		
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_n_counter { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_n_counter"
	}	
	
	set default_value 1
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set family $device_family
		set speedgrade $numeric_speed_grade
		set x $gui_fractional_x
		set compensation_mode $compensation_mode
		set is_fractional $gui_enable_fractional
		set hssi_cascade_freq $gui_desired_hssi_cascade_frequency
		set refclk_freq $full_actual_refclk_frequency
		
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_m_cnt_params \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$is_fractional \
					$hssi_cascade_freq \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set counter_value $result_array(n)
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_cascade_n_counter.value" $counter_value
	if {$debug_message} {
		puts "  hssi_cascade_n_counter->$counter_value"
	}		
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_m_counter { \
	gui_fpll_mode \
	device_family \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	numeric_speed_grade \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_m_counter \
	gui_enable_manual_config \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_m_counter"
	}	
	
	set default_value 11
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode} {
	
		if {$gui_enable_manual_config} {
			set counter_value $gui_pll_m_counter
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_m_cnt_params \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
    				$cmu_fpll_f_min_vco \
    				$cmu_fpll_f_max_vco \
    				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(m)	
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_m_counter.value" $counter_value
	if {$debug_message} {
		puts "  core_m_counter->$counter_value"
	}	
	
}

proc ::altera_xcvr_fpll_vi::parameters::get_core_physical_m_cnt_params { \
	refclk_freq \
	family \
	speedgrade \
	x \
	num_clocks_selected \
	compensation_mode \
	is_fractional \
	freq_0 \
	freq_1 \
	freq_2 \
	freq_3 \
	phase_0 \
	phase_1 \
	phase_2 \
	phase_3 \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_message
	variable error_occurred_in_validation
	
	set type "FPLL"
	set is_cnt_casc_en false
	
	array set validated_clock_list [list]
	for {set i 0} {$i < $num_clocks_selected} {incr i} {
		set is_degrees false
		set outclk_data [list -type c -index $i -freq [set freq_$i] -phase [set phase_$i] -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list $i $outclk_data
	}


	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-is_counter_cascading_enabled $is_cnt_casc_en \
						-compensation_mode $compensation_mode \
						-x $x \
						-validated_counter_values [array get validated_clock_list]\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision\
                        -primary_use $primary_use\
						]


	if {$debug_message} {
		puts "  ref_list:\n  $ref_list"
	}							
	if {[catch {::quartus::pll::fpll_legality::get_physical_m_cnt_values $ref_list} result]} {
		set error_message "IE: Error getting physical m_cnt value ($result)."
		set error_occurred_in_validation true
		ip_message error $error_message
		return
	} else {
		set ret_val $result
	}
	
	if {$debug_message} {
		puts "  ---\n  result:\n  $result"
	}
	
	return $ret_val
}

proc ::altera_xcvr_fpll_vi::parameters::make_hssi_mode_outclk_list { \
	hssi_output_freq \
	hssi_prot_mode \
} {
	array set validated_clock_list [list]

	set using_pcie_prot_mode [using_pcie_prot_mode $hssi_prot_mode]
	if {$using_pcie_prot_mode} {
		set is_degrees false
		set outclk_data [list -type c -index 0 -freq 500.0 -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data

		set is_degrees false
		set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 1 $outclk_data	

	} else {	
		set is_degrees false
		set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data	
	}	
	
	return [array get validated_clock_list]
}

proc ::altera_xcvr_fpll_vi::parameters::get_hssi_physical_m_cnt_params { \
	refclk_freq \
	family \
	speedgrade \
	x \
	compensation_mode \
	is_fractional \
	hssi_output_freq \
	hssi_prot_mode \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use \
	gui_enable_manual_hssi_counters \
	gui_pll_set_hssi_m_counter \
	gui_pll_set_hssi_n_counter \
	gui_pll_set_hssi_k_counter \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_message
	variable error_occurred_in_validation


	set type "FPLL"
	set is_cnt_casc_en false

	array set validated_clock_list [list]

	set using_pcie_prot_mode [using_pcie_prot_mode $hssi_prot_mode]

	if {$gui_enable_manual_hssi_counters} {
		set ret_val [list m $gui_pll_set_hssi_m_counter m_bypass $gui_pll_set_hssi_m_counter n $gui_pll_set_hssi_n_counter k $gui_pll_set_hssi_k_counter uses_fractional $gui_enable_fractional]
    } else {
	if {$using_pcie_prot_mode} {
		set is_degrees false
		set outclk_data [list -type c -index 0 -freq 500.0 -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data

		set is_degrees false
		set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 1 $outclk_data	

	} else {	
		set is_degrees false
		set outclk_data [list -type l -index 0 -freq $hssi_output_freq -phase 0.0 -is_degrees $is_degrees]		
		::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data	
	}	

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]

    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-is_counter_cascading_enabled $is_cnt_casc_en \
						-compensation_mode $compensation_mode \
						-x $x \
						-validated_counter_values [array get validated_clock_list]\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision \
                        -primary_use $primary_use\
						]



	if {$debug_message} {
		puts "  ref_list:\n  $ref_list"
	}							
	if {[catch {::quartus::pll::fpll_legality::get_physical_m_cnt_values $ref_list} result]} {
	#	puts "WJ DEBUG if"
		set error_message "IE: Error getting physical m_cnt value for hssi ($result)."
		set error_occurred_in_validation true
		ip_message error $error_message
		return
	} else {
	#	puts "WJ DEBUG else"
		set ret_val $result
	}
	
	if {$debug_message} {
		puts "  ---\n  result:\n  $result"
	}
	}
	
	return $ret_val						
}

proc ::altera_xcvr_fpll_vi::parameters::make_cascade_mode_outclk_list { \
	hssi_cascade_freq
} {
	array set validated_clock_list [list]
	set is_degrees false
	set outclk_data [list -type c -index 0 -freq $hssi_cascade_freq -phase 0.0 -is_degrees $is_degrees]		
	::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data	
	
	return [array get validated_clock_list]
}

proc ::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_m_cnt_params { \
	refclk_freq \
	family \
	speedgrade \
	x \
	compensation_mode \
	is_fractional \
	hssi_cascade_freq \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	gui_enable_fractional \
	primary_use\
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_message
	variable error_occurred_in_validation
	
	set type "FPLL"
	set is_cnt_casc_en false
	
	array set validated_clock_list [list]
	set is_degrees false
	set outclk_data [list -type c -index 0 -freq $hssi_cascade_freq -phase 0.0 -is_degrees $is_degrees]		
	::quartus::pll::fpll_legality::add_outclk_to_basic_input_list validated_clock_list 0 $outclk_data	

	set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    	set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    	set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    	set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    	set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


	set ref_list [list -family $family \
						-type $type \
						-speedgrade $speedgrade \
						-refclk_freq $refclk_freq \
						-is_fractional $is_fractional \
						-is_counter_cascading_enabled $is_cnt_casc_en \
						-compensation_mode $compensation_mode \
						-x $x \
						-validated_counter_values [array get validated_clock_list]\
                        -f_min_vco $f_min_vco_mhz\
                        -f_max_vco $f_max_vco_mhz\
                        -f_min_pfd $f_min_pfd_mhz\
                        -f_max_pfd $f_max_pfd_mhz\
						-device $device_revision\
                        -primary_use $primary_use\
						]

	
	if {$debug_message} {
		puts "  ref_list:\n  $ref_list"
	}							
	if {[catch {::quartus::pll::fpll_legality::get_physical_m_cnt_values $ref_list} result]} {
		set error_message "IE: Error getting physical m_cnt value for hssi cascade ($result)."
		set error_occurred_in_validation true
		ip_message error $error_message
		return
	} else {
		set ret_val $result
	}
	
	if {$debug_message} {
		puts "  ---\n  result:\n  $result"
	}
	
	return $ret_val
}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_k_cnt { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {
	
	# set result [get_physical_m_cnt_params \
		# $gui_reference_clock_frequency \
		# $gui_fpll_mode \
		# $gui_number_of_output_clocks \
		# $compensation_mode \
		# $hssi_output_clock_frequency \
		# $output_clock_frequency_0 \
		# $output_clock_frequency_1 \
		# $output_clock_frequency_2 \
		# $output_clock_frequency_3 \
		# $phase_shift_0 \
		# $phase_shift_1 \
		# $phase_shift_2 \
		# $phase_shift_3 ]
	# if {$result == "TCL_ERROR"} {
		# set ret_val $result
	# } else {
		# array set result_array $result
		# set ret_val $result_array(k)
	# }
	# return $ret_val
}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_n_cnt { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {
	
	# set result [get_physical_m_cnt_params \
		# $gui_reference_clock_frequency \
		# $gui_fpll_mode \
		# $gui_number_of_output_clocks \
		# $compensation_mode \
		# $gui_enable_fractional \
		# $hssi_output_clock_frequency \
		# $output_clock_frequency_0 \
		# $output_clock_frequency_1 \
		# $output_clock_frequency_2 \
		# $output_clock_frequency_3 \
		# $phase_shift_0 \
		# $phase_shift_1 \
		# $phase_shift_2 \
		# $phase_shift_3 ]
	# if {$result == "TCL_ERROR"} {
		# set ret_val $result
	# } else {
		# array set result_array $result
		# set ret_val $result_array(n)
	# }

	# return $ret_val
}


proc ::altera_xcvr_fpll_vi::parameters::get_physical_m_cnt { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {
	
	# set result [get_physical_m_cnt_params \
		# $gui_reference_clock_frequency \
		# $gui_enable_core_usage \
		# $gui_number_of_output_clocks \
		# $compensation_mode \
		# $gui_enable_fractional \
		# $gui_enable_transceiver_usage \
		# $hssi_output_clock_frequency \
		# $output_clock_frequency_0 \
		# $output_clock_frequency_1 \
		# $output_clock_frequency_2 \
		# $output_clock_frequency_3 \
		# $phase_shift_0 \
		# $phase_shift_1 \
		# $phase_shift_2 \
		# $phase_shift_3 ]
	# if {$result == "TCL_ERROR"} {
		# set ret_val $result
	# } else {
		# array set result_array $result
		# set ret_val $result_array(m)
	# }
	# return $ret_val
}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_m_cnt_bypass { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {
	
	# set result [get_physical_m_cnt_params \
		# $gui_reference_clock_frequency \
		# $gui_enable_core_usage \
		# $gui_number_of_output_clocks \
		# $compensation_mode \
		# $gui_enable_fractional \
		# $gui_enable_transceiver_usage \
		# $hssi_output_clock_frequency \
		# $output_clock_frequency_0 \
		# $output_clock_frequency_1 \
		# $output_clock_frequency_2 \
		# $output_clock_frequency_3 \
		# $phase_shift_0 \
		# $phase_shift_1 \
		# $phase_shift_2 \
		# $phase_shift_3 ]
	# if {$result_array == "TCL_ERROR"} {
		# set ret_val $result
	# } else {
		# array set result_array $result
		# set ret_val $result(m_bypass)
	# } 
	# return $ret_val
}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_l_cnt_params { \
	gui_reference_clock_frequency \
	gui_enable_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {

	# set clock_type l
	# set clock_index 0
	# set result [get_physical_cnt_params \
		# $gui_reference_clock_frequency \
		# $gui_enable_core_usage \
		# $gui_number_of_output_clocks \
		# $compensation_mode \
		# $gui_enable_fractional \
		# $gui_enable_transceiver_usage \
		# $hssi_output_clock_frequency \
		# $output_clock_frequency_0 \
		# $output_clock_frequency_1 \
		# $output_clock_frequency_2 \
		# $output_clock_frequency_3 \
		# $phase_shift_0 \
		# $phase_shift_1 \
		# $phase_shift_2 \
		# $phase_shift_3 \
		# $clock_index \
		# $clock_type]
	
	# return $result
}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_l_cnt_bypass { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {

	# array set result [::altera_xcvr_fpll_vi::parameters::get_physical_l_cnt_params \
					# $gui_reference_clock_frequency \
					# $gui_fpll_mode \
					# $gui_number_of_output_clocks \
					# $compensation_mode \
					# $gui_enable_fractional \
					# $hssi_output_clock_frequency \
					# $output_clock_frequency_0 \
					# $output_clock_frequency_1 \
					# $output_clock_frequency_2 \
					# $output_clock_frequency_3 \
					# $phase_shift_0 \
					# $phase_shift_1 \
					# $phase_shift_2 \
					# $phase_shift_3 ]
	# if {$result == "TCL_ERROR"} {
		# return $result
	# } else {
		# set ret_val $result(bypass)
		# if {$ret_val} {
			# return true
		# } else {
			# return false
		# }
	# }

}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_c_cnt_params { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
	clock_index \
} {

	# set clock_type c
	# set result [get_physical_cnt_params \
		# $gui_reference_clock_frequency \
		# $gui_enable_core_usage \
		# $gui_number_of_output_clocks \
		# $compensation_mode \
		# $gui_enable_fractional \
		# $gui_enable_transceiver_usage \
		# $hssi_output_clock_frequency \
		# $output_clock_frequency_0 \
		# $output_clock_frequency_1 \
		# $output_clock_frequency_2 \
		# $output_clock_frequency_3 \
		# $phase_shift_0 \
		# $phase_shift_1 \
		# $phase_shift_2 \
		# $phase_shift_3 \
		# $clock_index \
		# $clock_type]
	
	# return $result
}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_l_cnt { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {

	# set result [::altera_xcvr_fpll_vi::parameters::get_physical_l_cnt_params \
					# $gui_reference_clock_frequency \
					# $gui_enable_core_usage \
					# $gui_number_of_output_clocks \
					# $compensation_mode \
					# $gui_enable_fractional \
					# $gui_enable_transceiver_usage \
					# $hssi_output_clock_frequency \
					# $output_clock_frequency_0 \
					# $output_clock_frequency_1 \
					# $output_clock_frequency_2 \
					# $output_clock_frequency_3 \
					# $phase_shift_0 \
					# $phase_shift_1 \
					# $phase_shift_2 \
					# $phase_shift_3 ]
					
	# if {$result == "TCL_ERROR"} {
		# return $result
	# } else {
		# array set result_arr $result
		# return $result_arr(cnt_div)
	# }

}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_c_cnt_ph_mux_prst { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
	clock_index \
} {
	# if { $gui_enable_core_usage && $gui_number_of_output_clocks > $clock_index } {
		# set result [::altera_xcvr_fpll_vi::parameters::get_physical_c_cnt_params \
						# $gui_reference_clock_frequency \
						# $gui_enable_core_usage \
						# $gui_number_of_output_clocks \
						# $compensation_mode \
						# $gui_enable_fractional \
						# $gui_enable_transceiver_usage \
						# $hssi_output_clock_frequency \
						# $output_clock_frequency_0 \
						# $output_clock_frequency_1 \
						# $output_clock_frequency_2 \
						# $output_clock_frequency_3 \
						# $phase_shift_0 \
						# $phase_shift_1 \
						# $phase_shift_2 \
						# $phase_shift_3 \
						# $clock_index ]
		# if {$result == "TCL_ERROR"} {
			# return $result
		# } else {
			# array set result_arr $result
			# return $result_arr(ph_mux_tap)
		# }
	# } else {
		# return 0
	# }	

}

proc ::altera_xcvr_fpll_vi::parameters::get_physical_c_cnt_prst { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	hssi_output_clock_frequency \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
	clock_index \
} {

	# if { $gui_enable_core_usage && $gui_number_of_output_clocks > $clock_index } {
		# set result [::altera_xcvr_fpll_vi::parameters::get_physical_c_cnt_params \
						# $gui_reference_clock_frequency \
						# $gui_enable_core_usage \
						# $gui_number_of_output_clocks \
						# $compensation_mode \
						# $gui_enable_fractional \
						# $gui_enable_transceiver_usage \
						# $hssi_output_clock_frequency \
						# $output_clock_frequency_0 \
						# $output_clock_frequency_1 \
						# $output_clock_frequency_2 \
						# $output_clock_frequency_3 \
						# $phase_shift_0 \
						# $phase_shift_1 \
						# $phase_shift_2 \
						# $phase_shift_3 \
						# $clock_index ]
		# if {$result == "TCL_ERROR"} {
			# return $result
		# } else {
			# array set result_arr $result
			# return $result_arr(preset)
		# }
	# } else {
		# return 1
	# }

}

proc ::altera_xcvr_fpll_vi::parameters::get_pll_c_counter_in_src {} {
	return "m_cnt_in_src_ph_mux_clk"
}

# +-----------------------------------
# | This function sets pll_c_counter_0_in_src parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_in_src { \
	primary_use \
	prot_mode \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_in_src"
	}
	
	if {$primary_use == "core" || ($primary_use == "tx" && ($prot_mode == "pcie_gen1_tx" || $prot_mode == "pcie_gen2_tx" || $prot_mode == "pcie_gen3_tx"))} {
		set cnt_src_val [::altera_xcvr_fpll_vi::parameters::get_pll_c_counter_in_src]
	} else {
		set cnt_src_val "m_cnt_in_src_test_clk"
	}
	
	ip_set "parameter.pll_c_counter_0_in_src.value" $cnt_src_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_0_in_src -> $cnt_src_val"
	}
}


# +-----------------------------------
# | This function sets pll_c_counter_0_ph_mux_prst parameter  
# |pll_c_counter_0_ph_mux_prst
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_ph_mux_prst { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	gui_enable_fractional \
	hssi_pcie_c_counter_0_ph_mux_prst \
	core_c_counter_0_ph_mux_prst \
	core_c_counter_3_ph_mux_prst \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_ph_mux_prst"
	}
	
	set ph_mux_prst_unused_value 0
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	
	if {$using_hssi_mode} {
		set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode] 
		if {$using_pcie_prot_mode} {
			set ph_mux_val $hssi_pcie_c_counter_0_ph_mux_prst
		} else {
			set ph_mux_val $ph_mux_prst_unused_value
		}	
	} elseif {$using_cascade_mode} {
		set ph_mux_val $ph_mux_prst_unused_value	
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 0} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set ph_mux_val $ph_mux_prst_unused_value
			} else {
				set ph_mux_val $core_c_counter_3_ph_mux_prst
			}
		} else {
			if {$gui_number_of_output_clocks < 1} {
				set ph_mux_val $ph_mux_prst_unused_value
			} else {
				set ph_mux_val $core_c_counter_0_ph_mux_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_0_ph_mux_prst.value" $ph_mux_val
	
	if {$debug_message} {
		puts "  pll_c_counter_0_ph_mux_prst->$ph_mux_val"
	}
}

# +-----------------------------------
# | This function sets pll_c_counter_0_prst parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_prst { \
	gui_fpll_mode \
	gui_hssi_prot_mode \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	gui_enable_fractional \
	hssi_pcie_c_counter_0_prst \
	core_c_counter_0_prst \
	core_c_counter_3_prst \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_prst"
	}
	
	set prst_unused_value 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	
	if {$using_hssi_mode} {
		set using_pcie_prot_mode [using_pcie_prot_mode $gui_hssi_prot_mode] 
		if {$using_pcie_prot_mode} {
			set prst_val $hssi_pcie_c_counter_0_prst
		} else {
			set prst_val $prst_unused_value
		}	
	} elseif {$using_cascade_mode} {
		set prst_val $prst_unused_value	
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 0} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set prst_val $prst_unused_value
			} else {
				set prst_val $core_c_counter_3_prst
			}
		} else {
			if {$gui_number_of_output_clocks < 1} {
				set prst_val $prst_unused_value
			} else {
				set prst_val $core_c_counter_0_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_0_prst.value" $prst_val
	
	if {$debug_message} {
		puts "  pll_c_counter_0_prst->$prst_val"
	}

}

proc ::altera_xcvr_fpll_vi::parameters::get_c_counter_coarse_dly {} {
	return "0 ps"
}

proc ::altera_xcvr_fpll_vi::parameters::get_c_counter_fine_dly {} {
	return "0 ps"
}

# +-----------------------------------
# | This function sets pll_c_counter_0_coarse_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_coarse_dly {} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_coarse_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_coarse_dly]
	ip_set "parameter.pll_c_counter_0_coarse_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_0_coarse_dly -> $cnt_dly_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_0_fine_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_fine_dly {} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_0_fine_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_fine_dly]
	ip_set "parameter.pll_c_counter_0_fine_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_0_fine_dly -> $cnt_dly_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_1 parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	hssi_cascade_c_counter \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	core_c_counter_3 \
	core_c_counter_1 \
} {

	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1"
	}

	set counter_unused_value 1	

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set counter_value $counter_unused_value	
	} elseif {$using_cascade_mode} {
		set counter_value $hssi_cascade_c_counter
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 1} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set counter_value $counter_unused_value
			} else {
				set counter_value $core_c_counter_3
			}
		} else {
			if {$gui_number_of_output_clocks < 2} {
				set counter_value $counter_unused_value
			} else {
				set counter_value $core_c_counter_1
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	

	ip_set "parameter.pll_c_counter_1.value" $counter_value
	
	if {$debug_message} {
		puts "  pll_c_counter_1->$counter_value"
	}		
}

# +-----------------------------------
# | This function sets pll_c_counter_1_in_src parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_in_src { \
	primary_use \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_in_src"
	}
	
	if {$primary_use == "tx"}  {
		set cnt_src_val "m_cnt_in_src_test_clk"
	} else {
		set cnt_src_val [::altera_xcvr_fpll_vi::parameters::get_pll_c_counter_in_src]
	}
	
	ip_set "parameter.pll_c_counter_1_in_src.value" $cnt_src_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_1_in_src -> $cnt_src_val"
	}
	
}

# +-----------------------------------
# | This function sets pll_c_counter_1_ph_mux_prst parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_ph_mux_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	hssi_cascade_c_counter_ph_mux_prst \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	core_c_counter_1_ph_mux_prst \
	core_c_counter_3_ph_mux_prst \
} {

	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_ph_mux_prst"
	}

	set ph_mux_prst_unused_value 0	

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set ph_mux_val $ph_mux_prst_unused_value	
	} elseif {$using_cascade_mode} {
		set ph_mux_val $hssi_cascade_c_counter_ph_mux_prst
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 1} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set ph_mux_val $ph_mux_prst_unused_value
			} else {
				set ph_mux_val $core_c_counter_3_ph_mux_prst
			}
		} else {
			if {$gui_number_of_output_clocks < 2} {
				set ph_mux_val $ph_mux_prst_unused_value
			} else {
				set ph_mux_val $core_c_counter_1_ph_mux_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	

	ip_set "parameter.pll_c_counter_1_ph_mux_prst.value" $ph_mux_val
	
	if {$debug_message} {
		puts "  pll_c_counter_1_ph_mux_prst->$ph_mux_val"
	}		

}

# +-----------------------------------
# | This function sets pll_c_counter_1_prst parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	hssi_cascade_c_counter_prst \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	core_c_counter_1_prst \
	core_c_counter_3_prst \
} {

	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_prst"
	}

	set prst_unused_value 1

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set prst_val $prst_unused_value	
	} elseif {$using_cascade_mode} {
		set prst_val $hssi_cascade_c_counter_prst
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 1} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set prst_val $prst_unused_value
			} else {
				set prst_val $core_c_counter_3_prst
			}
		} else {
			if {$gui_number_of_output_clocks < 2} {
				set prst_val $prst_unused_value
			} else {
				set prst_val $core_c_counter_1_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	

	ip_set "parameter.pll_c_counter_1_prst.value" $prst_val
	
	if {$debug_message} {
		puts "  pll_c_counter_1_prst->$prst_val"
	}		

}



# +-----------------------------------
# | This function sets pll_c_counter_1_coarse_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_coarse_dly { \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_coarse_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_coarse_dly]
	ip_set "parameter.pll_c_counter_1_coarse_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_1_coarse_dly -> $cnt_dly_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_1_fine_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_fine_dly {} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_1_fine_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_fine_dly]
	ip_set "parameter.pll_c_counter_1_fine_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_1_fine_dly -> $cnt_dly_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_2 parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2 { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	core_c_counter_2 \
	core_c_counter_3 \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {
	variable debug_message 
	variable error_occurred_in_validation

	if {$error_occurred_in_validation} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2"
	}	

	set counter_unused_value 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]	

	if {$using_hssi_mode} {
		set counter_value $counter_unused_value	
	} elseif {$using_cascade_mode} {
		set counter_value $counter_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 2} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set counter_value $counter_unused_value
			} else {
				set counter_value $core_c_counter_3
			}
		} else {
			if {$gui_number_of_output_clocks < 3} {
				set counter_value $counter_unused_value
			} else {
				set counter_value $core_c_counter_2
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_2.value" $counter_value
	
	if {$debug_message} {
		puts "  pll_c_counter_2->$counter_value"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_2_in_src parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_in_src { \
	primary_use \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_in_src"
	}
	
	if {$primary_use != "core"}  {
		set cnt_src_val "m_cnt_in_src_test_clk"
	} else {
		set cnt_src_val [::altera_xcvr_fpll_vi::parameters::get_pll_c_counter_in_src]
	}
	ip_set "parameter.pll_c_counter_2_in_src.value" $cnt_src_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_2_in_src -> $cnt_src_val"
	}
	
}

# +-----------------------------------
# | This function sets pll_c_counter_2_ph_mux_prst parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_ph_mux_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	core_c_counter_2_ph_mux_prst \
	core_c_counter_3_ph_mux_prst \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {
	variable debug_message 
	variable error_occurred_in_validation

	if {$error_occurred_in_validation} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_ph_mux_prst"
	}	

	set ph_mux_prst_unused_value 0
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]	

	if {$using_hssi_mode} {
		set ph_mux_val $ph_mux_prst_unused_value	
	} elseif {$using_cascade_mode} {
		set ph_mux_val $ph_mux_prst_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 2} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set ph_mux_val $ph_mux_prst_unused_value
			} else {
				set ph_mux_val $core_c_counter_3_ph_mux_prst
			}
		} else {
			if {$gui_number_of_output_clocks < 3} {
				set ph_mux_val $ph_mux_prst_unused_value
			} else {
				set ph_mux_val $core_c_counter_2_ph_mux_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_2_ph_mux_prst.value" $ph_mux_val
	
	if {$debug_message} {
		puts "  pll_c_counter_2_ph_mux_prst->$ph_mux_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_2_prst parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_prst { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
	core_c_counter_2_prst \
	core_c_counter_3_prst \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
} {
	variable debug_message 
	variable error_occurred_in_validation

	if {$error_occurred_in_validation} {
		return
	} 
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_prst"
	}	

	set prst_unused_value 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]	

	if {$using_hssi_mode} {
		set prst_val $prst_unused_value	
	} elseif {$using_cascade_mode} {
		set prst_val $prst_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out && $gui_cascade_outclk_index == 2} {
			#swap with counter 3
			if {$gui_number_of_output_clocks < 4} {
				set prst_val $prst_unused_value
			} else {
				set prst_val $core_c_counter_3_prst
			}
		} else {
			if {$gui_number_of_output_clocks < 3} {
				set prst_val $prst_unused_value
			} else {
				set prst_val $core_c_counter_2_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_2_prst.value" $prst_val
	
	if {$debug_message} {
		puts "  pll_c_counter_2_prst->$prst_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_2_coarse_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_coarse_dly {} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_coarse_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_coarse_dly]
	ip_set "parameter.pll_c_counter_2_coarse_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_2_coarse_dly -> $cnt_dly_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_2_fine_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_fine_dly {} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_2_fine_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_fine_dly]
	ip_set "parameter.pll_c_counter_2_fine_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_2_fine_dly -> $cnt_dly_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_3 parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3 { \
	gui_fpll_mode \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	core_c_counter_0 \
	core_c_counter_1 \
	core_c_counter_2 \
	core_c_counter_3 \
	gui_number_of_output_clocks \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3"
	}		
	
	set counter_unused_value 1

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set counter_value $counter_unused_value	
	} elseif {$using_cascade_mode} {
		set counter_value $counter_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out} {
			switch $gui_cascade_outclk_index {
				0 {
					set counter_value $core_c_counter_0
				}
				1 {
					set counter_value $core_c_counter_1
				}
				2 {
					set counter_value $core_c_counter_2
				}
				3 {
					set counter_value $core_c_counter_3
				}
				default {
					error "IE: Unknown clock index"
				}
			}
		} else {
			if {$gui_number_of_output_clocks < 4} {
				set counter_value $counter_unused_value
			} else {
				set counter_value $core_c_counter_3
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_3.value" $counter_value
	
	if {$debug_message} {
		puts "  pll_c_counter_3->$counter_value"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_3_in_src parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_in_src { \
	primary_use \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_in_src"
	}
	
	if {$primary_use != "core"}  {
		set cnt_src_val "m_cnt_in_src_test_clk"
	} else {
		set cnt_src_val [::altera_xcvr_fpll_vi::parameters::get_pll_c_counter_in_src]
	}
	ip_set "parameter.pll_c_counter_3_in_src.value" $cnt_src_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_3_in_src -> $cnt_src_val"
	}
	
}

# +-----------------------------------
# | This function sets pll_c_counter_3_ph_mux_prst parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_ph_mux_prst { \
	gui_fpll_mode \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	core_c_counter_0_ph_mux_prst \
	core_c_counter_1_ph_mux_prst \
	core_c_counter_2_ph_mux_prst \
	core_c_counter_3_ph_mux_prst \
	gui_number_of_output_clocks \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_ph_mux_prst"
	}		
	
	set ph_mux_prst_unused_value 0

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set ph_mux_val $ph_mux_prst_unused_value	
	} elseif {$using_cascade_mode} {
		set ph_mux_val $ph_mux_prst_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out} {
			switch $gui_cascade_outclk_index {
				0 {
					set ph_mux_val $core_c_counter_0_ph_mux_prst
				}
				1 {
					set ph_mux_val $core_c_counter_1_ph_mux_prst
				}
				2 {
					set ph_mux_val $core_c_counter_2_ph_mux_prst
				}
				3 {
					set ph_mux_val $core_c_counter_3_ph_mux_prst
				}
				default {
					error "IE: Unknown clock index"
				}
			}
		} else {
			if {$gui_number_of_output_clocks < 4} {
				set ph_mux_val $ph_mux_prst_unused_value
			} else {
				set ph_mux_val $core_c_counter_3_ph_mux_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_3_ph_mux_prst.value" $ph_mux_val
	
	if {$debug_message} {
		puts "  pll_c_counter_3_ph_mux_prst->$ph_mux_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_3_prst parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_prst { \
	gui_fpll_mode \
	gui_enable_cascade_out \
	gui_cascade_outclk_index \
	core_c_counter_0_prst \
	core_c_counter_1_prst \
	core_c_counter_2_prst \
	core_c_counter_3_prst \
	gui_number_of_output_clocks \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return
	} 

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_prst"
	}		
	
	set prst_unused_value 1

	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set prst_value $prst_unused_value	
	} elseif {$using_cascade_mode} {
		set prst_value $prst_unused_value
	} elseif {$using_core_mode} {
		if {$gui_enable_cascade_out} {
			switch $gui_cascade_outclk_index {
				0 {
					set prst_value $core_c_counter_0_prst
				}
				1 {
					set prst_value $core_c_counter_1_prst
				}
				2 {
					set prst_value $core_c_counter_2_prst
				}
				3 {
					set prst_value $core_c_counter_3_prst
				}
				default {
					error "IE: Unknown clock index"
				}
			}
		} else {
			if {$gui_number_of_output_clocks < 4} {
				set prst_value $prst_unused_value
			} else {
				set prst_value $core_c_counter_3_prst
			}
		}	
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}	
	
	ip_set "parameter.pll_c_counter_3_prst.value" $prst_value
	
	if {$debug_message} {
		puts "  pll_c_counter_3_prst->$prst_value"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_3_coarse_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_coarse_dly {} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_coarse_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_coarse_dly]
	ip_set "parameter.pll_c_counter_3_coarse_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_3_coarse_dly -> $cnt_dly_val"
	}	
}

# +-----------------------------------
# | This function sets pll_c_counter_3_fine_dly parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_fine_dly {} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_c_counter_3_fine_dly"
	}
	
	set cnt_dly_val [::altera_xcvr_fpll_vi::parameters::get_c_counter_fine_dly]
	ip_set "parameter.pll_c_counter_3_fine_dly.value" $cnt_dly_val
	
	# debug information
	if { $debug_message } {
		puts "   pll_c_counter_3_fine_dly -> $cnt_dly_val"
	}
}

# +-----------------------------------
# | This function sets pll_fbclk_mux_1 parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_fbclk_mux_1 { \
#   compensation_mode \
#} {
#   variable debug_message
#   variable error_occurred_in_validation
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_fbclk_mux_1" 
#   }
#   switch $compensation_mode {
#      "direct" {
#         set result "pll_fbclk_mux_1_glb"
#      }
#      "normal" {
#         set result "pll_fbclk_mux_1_glb"
#      }
#      "iqtxrxclk" { 
#         set result "pll_fbclk_mux_1_fbclk_pll"
#      }
#      "fpll_bonding" {
#         set result "pll_fbclk_mux_1_fbclk_pll"
#      }
#      "zdb" {
#         set result "pll_fbclk_mux_1_zbd"
#      }
#      default {
#         error "Unknown compensation mode. Error in the gui. Update this list."
#      }
#   }
#   if {$debug_message} {
#      puts "  pll_fbclk_mux_1 -> $result " 
#   }   
#   ip_set "parameter.pll_fbclk_mux_1.value" $result
#}

# +-----------------------------------
# | This function sets pll_fbclk_mux_2 parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_fbclk_mux_2 { \
#   compensation_mode \
#} {
#   variable debug_message
#   variable error_occurred_in_validation
#   
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_fbclk_mux_2" 
#   }
#   switch $compensation_mode {
#      "direct" {
#         set result "pll_fbclk_mux_2_m_cnt"
#      }
#      "normal" {
#         set result "pll_fbclk_mux_2_fb_1"
#      }
#      "iqtxrxclk" { 
#         set result "pll_fbclk_mux_2_fb_1"
#      }
#      "fpll_bonding" {
#         set result "pll_fbclk_mux_2_fb_1"
#      }
#      "zdb" {
#         set result "pll_fbclk_mux_2_fb_1"
#      }
#      default {
#         error "Unknown compensation mode. Error in the gui. Update this list."
#      }
#   }
#   if {$debug_message} {
#      puts "  pll_fbclk_mux_2 -> $result " 
#   }   
#   ip_set "parameter.pll_fbclk_mux_2.value" $result
#   
#}
   
# +-----------------------------------
# | This function sets pll_iqclk_mux_sel parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_iqclk_mux_sel { \
   compensation_mode \
   cmu_fpll_is_pa_core \
} {
   variable debug_message
   variable error_occurred_in_validation
   
   if {$error_occurred_in_validation} {
      return
   }
   
   if {$debug_message} {
      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_iqclk_mux_sel" 
   }

   if { $cmu_fpll_is_pa_core } {
      set result "iqtxrxclk0"
   } else {
      switch $compensation_mode {
         "fpll_bonding" -
         "iqtxrxclk" {
            set result "iqtxrxclk0"
         }
         default {
            set result "power_down"
         }
      }
   }

   if {$debug_message} {
      puts "  pll_iqclk_mux_sel-> $result" 
   }   

   ip_set "parameter.pll_iqclk_mux_sel.value" $result
}

# +-----------------------------------
# | This function sets pll_l_counter_bypass parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_l_counter_bypass { \
#   gui_reference_clock_frequency \
#   gui_fpll_mode \
#   gui_number_of_output_clocks \
#   compensation_mode \
#   gui_enable_fractional \
#   hssi_output_clock_frequency \
#   output_clock_frequency_0 \
#   output_clock_frequency_1 \
#   output_clock_frequency_2 \
#   output_clock_frequency_3 \
#   phase_shift_0 \
#   phase_shift_1 \
#   phase_shift_2 \
#   phase_shift_3 \
#} {

   # variable debug_message 
   
   # if {$debug_message} {
      # puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_l_counter_bypass"
   # }
   
   # if {$gui_enable_transceiver_usage} {
      # set result false
      # # set result [get_physical_l_cnt_bypass \
                  # # $gui_reference_clock_frequency \
                  # # $gui_enable_core_usage \
                  # # $gui_number_of_output_clocks \
                  # # $compensation_mode \
                  # # $gui_enable_fractional \
                  # # $gui_enable_transceiver_usage \
                  # # $hssi_output_clock_frequency \
                  # # $output_clock_frequency_0 \
                  # # $output_clock_frequency_1 \
                  # # $output_clock_frequency_2 \
                  # # $output_clock_frequency_3 \
                  # # $phase_shift_0 \
                  # # $phase_shift_1 \
                  # # $phase_shift_2 \
                  # # $phase_shift_3]
   # } else {
      # set result true
   # }
   
   # if {$debug_message} {
      # puts "  pll_l_counter_bypass -> $result"
   # }   
   
   # ip_set "parameter.pll_l_counter_bypass.value" $result   
   
#}

# +-----------------------------------
# | This function sets pll_l_counter parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_l_counter { \
	gui_fpll_mode \
	hssi_l_counter \
	gui_pll_set_hssi_l_counter \
    gui_enable_manual_hssi_counters \
    gui_pll_set_hssi_n_counter \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_l_counter"
	}

	set counter_unused_value 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	
	if {$using_hssi_mode} {
        if { $gui_enable_manual_hssi_counters } {
            set counter_val $gui_pll_set_hssi_l_counter
        } else { 
    		set counter_val $hssi_l_counter
        }
	} elseif {$using_cascade_mode} {
		set counter_val $counter_unused_value
	} elseif {$using_core_mode} {
		set counter_val $counter_unused_value
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}

	ip_set "parameter.pll_l_counter.value" $counter_val
	if {$debug_message} {
		puts "  pll_l_counter->$counter_val"
	}		

}

# +-----------------------------------
# | This function sets pll_l_counter_enable parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_l_counter_enable { \
#   gui_fpll_mode \
#   hssi_l_counter_enable \
#} {
#   
#   variable debug_message 
#   variable error_occurred_in_validation
#   
#   if {$error_occurred_in_validation} {
#      return 
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_l_counter_enable"
#   }
#
#   set enable_unused_value false
#   
#   set using_core_mode [using_core_mode $gui_fpll_mode]
#   set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
#   set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
#   
#   if {$using_hssi_mode} {
#      set enable_val $hssi_l_counter_enable
#   } elseif {$using_cascade_mode} {
#      set enable_val $enable_unused_value
#   } elseif {$using_core_mode} {
#      set enable_val $enable_unused_value
#   } else {
#      error "IE: Unknown fpll mode ($gui_fpll_mode)"
#   }
#
#   ip_set "parameter.pll_l_counter_enable.value" $enable_val
#   if {$debug_message} {
#      puts "  pll_l_counter_enable ->$enable_val"
#   }   
#}

proc ::altera_xcvr_fpll_vi::parameters::update_core_dsm_fractional_division { \
	gui_fpll_mode \
	device_family \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	numeric_speed_grade \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_pll_dsm_fractional_division \
	gui_enable_manual_config \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_dsm_fractional_division"
	}	
	
	set default_value 1
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode} {
	
		if {$gui_enable_manual_config} {
			if {$gui_enable_fractional} {
				set counter_value $gui_pll_dsm_fractional_division
			} else {
				set counter_value 1
			}
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_m_cnt_params \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set counter_value $result_array(k)	
		}
		
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.core_dsm_fractional_division.value" $counter_value
	if {$debug_message} {
		puts "  core_dsm_fractional_division->$counter_value"
	}	
	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_dsm_fractional_division { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_enable_manual_hssi_counters \
	gui_pll_set_hssi_m_counter \
	gui_pll_set_hssi_n_counter \
	gui_pll_set_hssi_k_counter \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_dsm_fractional_division"
	}	
	
	set default_value 1
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		if {$compensation_mode == "fpll_bonding"} {
			set counter_value $default_value
		} else {
			
			set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_m_cnt_params \
						$full_actual_refclk_frequency \
						$device_family \
						$numeric_speed_grade \
						$gui_fractional_x \
						$compensation_mode \
						$gui_enable_fractional \
						$gui_hssi_output_clock_frequency \
						$gui_hssi_prot_mode \
    						$cmu_fpll_f_min_vco \
    						$cmu_fpll_f_max_vco \
    						$cmu_fpll_f_min_pfd \
						$device_revision \
						$gui_enable_fractional \
						$primary_use \
						$gui_enable_manual_hssi_counters \
						$gui_pll_set_hssi_m_counter \
						$gui_pll_set_hssi_n_counter \
						$gui_pll_set_hssi_k_counter \
						$temp_bw_sel \
						$gui_is_downstream_cascaded_pll \
						]
			if {$error_occurred_in_validation} {
				return
			} 
			array set result_array $result
			set counter_value $result_array(k)
		}
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_dsm_fractional_division.value" $counter_value
	if {$debug_message} {
		puts "  hssi_dsm_fractional_division->$counter_value"
	}		
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_dsm_fractional_division { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_dsm_fractional_division"
	}	
	
	set default_value 1
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set family $device_family
		set speedgrade $numeric_speed_grade
		set x $gui_fractional_x
		set compensation_mode $compensation_mode
		set is_fractional $gui_enable_fractional
		set hssi_cascade_freq $gui_desired_hssi_cascade_frequency
		set refclk_freq $full_actual_refclk_frequency
		
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_m_cnt_params \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$is_fractional \
					$hssi_cascade_freq \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set counter_value $result_array(k)
	} else {
		set counter_value $default_value
	}
	
	ip_set "parameter.hssi_cascade_dsm_fractional_division.value" $counter_value
	if {$debug_message} {
		puts "  hssi_cascade_dsm_fractional_division->$counter_value"
	}		
}

# +-----------------------------------
# | This function sets update_pll_dsm_fractional_division parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_dsm_fractional_division { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	core_dsm_fractional_division \
	hssi_dsm_fractional_division \
	hssi_cascade_dsm_fractional_division \
	pll_actual_using_fractional \
    gui_pll_set_hssi_k_counter \
    gui_enable_manual_hssi_counters \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_dsm_fractional_division"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {!$pll_actual_using_fractional} {
		set counter_val 1
	} else {
		if {$using_hssi_mode} {
            if { $gui_enable_manual_hssi_counters } {
                set counter_val $gui_pll_set_hssi_k_counter
            } else {
			    set counter_val $hssi_dsm_fractional_division
            }
		} elseif {$using_cascade_mode} {
			set counter_val $hssi_cascade_dsm_fractional_division
		} elseif {$using_core_mode} {
			set counter_val $core_dsm_fractional_division
		} else {
			error "IE: Unknown fpll mode ($gui_fpll_mode)"
		}
	}
	ip_set "parameter.pll_dsm_fractional_division.value" $counter_val
	
	if {$debug_message} {
		puts "  pll_dsm_fractional_division->$counter_val"
	}	
    set myval [ip_get "parameter.pll_dsm_fractional_division.value"]

}

# +-----------------------------------
# | This function sets pll_dsm_mode parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_dsm_mode { \
	pll_actual_using_fractional \
} {

	variable debug_message
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_dsm_mode"
	}

	if {$pll_actual_using_fractional} {
		set dsm_mode "dsm_mode_phase"
	} else {
		set dsm_mode "dsm_mode_integer"
	}
	
	if {$debug_message} {
		puts "  pll_dsm_mode -> $dsm_mode"
	}	
	
	ip_set "parameter.pll_dsm_mode.value" $dsm_mode

}

# +-----------------------------------
# | This function sets pll_dsm_out_sel parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_dsm_out_sel { \
	pll_actual_using_fractional \
} {

	variable debug_message
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_dsm_out_sel"
	}

	if {$pll_actual_using_fractional} {
		set dsm_mode "pll_dsm_3rd_order"
	} else {
		set dsm_mode "pll_dsm_disable"
	}
	
	if {$debug_message} {
		puts "  pll_dsm_out_sel -> $dsm_mode"
	}	
	
	ip_set "parameter.pll_dsm_out_sel.value" $dsm_mode
	
}

proc ::altera_xcvr_fpll_vi::parameters::validate_gui_pll_m_counter {
	gui_pll_m_counter \
	gui_fpll_mode \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_enable_manual_config \
	device_family \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	if {$error_occurred_in_validation} {
		return
	}	
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_advanced_parameters $gui_enable_manual_config
	
	if {$using_core_mode && $using_advanced_parameters} {
		
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::validate_gui_pll_m_counter"
		}		
		
		set family $device_family
		set type "FPLL"
		set speedgrade 1

		set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    		set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    		set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    		set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    		set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]


		set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-is_fractional $gui_enable_fractional \
							-compensation_mode $compensation_mode\
                        	-f_min_vco $f_min_vco_mhz\
                        	-f_max_vco $f_max_vco_mhz\
                        	-f_min_pfd $f_min_pfd_mhz\
                        	-f_max_pfd $f_max_pfd_mhz\
							-device $device_revision\
                            -primary_use $primary_use\
							]
						
	
		if {[catch {::quartus::pll::fpll_legality::get_legal_m_cnt_range $ref_list} result]} {
			set error_occurred_in_validation true
			set error_message "Error retrieving m cnt range"
			ip_message error $error_message
		} else {
			array set result_array $result 
			set m_min $result_array(m_min)
			set m_max $result_array(m_max)
			
			if {![::altera_xcvr_fpll_vi::parameters::is_value_within_range $gui_pll_m_counter $m_min $m_max]} {
				set error_occurred_in_validation true
				set error_message "M counter value ($gui_pll_m_counter) out of range. Legal range: $m_min - $m_max."
				ip_message error $error_message
			}
		}
	}

}

proc ::altera_xcvr_fpll_vi::parameters::validate_gui_pll_n_counter {
	gui_pll_n_counter \
	gui_fpll_mode \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	compensation_mode \
	gui_enable_fractional \
	gui_enable_manual_config \
	device_family \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {

	variable debug_message
	variable error_occurred_in_validation
	variable error_message 
	
	if {$error_occurred_in_validation} {
		return
	}	
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_advanced_parameters $gui_enable_manual_config
	
	if {$using_core_mode && $using_advanced_parameters} {
		
		if {$debug_message} {
			puts "\n::altera_xcvr_fpll_vi::parameters::validate_gui_pll_n_counter"
		}		
		
		set family $device_family
		set type "FPLL"
		set speedgrade 1

		set local_f_max_pfd [ get_local_f_max_pfd $device_revision $compensation_mode $gui_enable_fractional $primary_use $temp_bw_sel $gui_is_downstream_cascaded_pll ]
    		set f_max_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_max_vco]
    		set f_min_vco_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_vco]
    		set f_min_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $cmu_fpll_f_min_pfd]
    		set f_max_pfd_mhz [::altera_xcvr_fpll_vi::parameters::base_to_mega $local_f_max_pfd]

		set ref_list [list -family $family \
							-type $type \
							-speedgrade $speedgrade \
							-is_fractional $gui_enable_fractional \
							-compensation_mode $compensation_mode\
                        	-f_min_vco $f_min_vco_mhz\
                        	-f_max_vco $f_max_vco_mhz\
                        	-f_min_pfd $f_min_pfd_mhz\
                        	-f_max_pfd $f_max_pfd_mhz\
							-device $device_revision\
                            -primary_use $primary_use\
							]
		
					
		if {[catch {::quartus::pll::fpll_legality::get_legal_n_cnt_range $ref_list} result]} {
			set error_occurred_in_validation true
			set error_message "Error retrieving n cnt range"
			puts $result
			ip_message error $error_message
		} else {
			array set result_array $result 
			set n_min $result_array(n_min)
			set n_max $result_array(n_max)
			
			if {![::altera_xcvr_fpll_vi::parameters::is_value_within_range $gui_pll_n_counter $n_min $n_max]} {
				set error_occurred_in_validation true
				set error_message "N counter value ($gui_pll_n_counter) out of range. Legal range: $n_min - $n_max."
				ip_message error $error_message
			}
		}
	}

}

# +-----------------------------------
# | This function sets pll_m_counter parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	core_m_counter \
	hssi_cascade_m_counter \
	hssi_m_counter \
    gui_enable_manual_hssi_counters \
    gui_pll_set_hssi_m_counter \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_m_counter"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
        if {$gui_enable_manual_hssi_counters } {
            set counter_val $gui_pll_set_hssi_m_counter
        } else {
    		set counter_val $hssi_m_counter
        }
	} elseif {$using_cascade_mode} {
		set counter_val $hssi_cascade_m_counter
	} elseif {$using_core_mode} {
		set counter_val $core_m_counter
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}

	ip_set "parameter.pll_m_counter.value" $counter_val
	
	if {$debug_message} {
		puts "  pll_m_counter->$counter_val"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_core_actual_using_fractional { \
	gui_fpll_mode \
	device_family \
	gui_reference_clock_frequency \
	gui_number_of_output_clocks \
	numeric_speed_grade \
	compensation_mode \
	gui_enable_fractional \
	gui_fractional_x \
	gui_enable_manual_config \
	full_actual_outclk0_frequency \
	full_actual_outclk1_frequency \
	full_actual_outclk2_frequency \
	full_actual_outclk3_frequency \
	full_outclk0_actual_phase_shift \
	full_outclk1_actual_phase_shift \
	full_outclk2_actual_phase_shift \
	full_outclk3_actual_phase_shift \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_core_actual_using_fractional"
	}	
	
	set default_value false 
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	if {$using_core_mode} {
	
		if {$gui_enable_manual_config} {
			#TODO: Audrey - is this valid?
			set actual_is_fractional $gui_enable_fractional
			
		} else {
			set family $device_family
			set type "FPLL"
			set speedgrade $numeric_speed_grade
			set x $gui_fractional_x
			set refclk_freq $gui_reference_clock_frequency
			set is_fractional $gui_enable_fractional
			
			set result [::altera_xcvr_fpll_vi::parameters::get_core_physical_m_cnt_params \
				$refclk_freq \
				$family \
				$speedgrade \
				$x \
				$gui_number_of_output_clocks \
				$compensation_mode \
				$is_fractional \
				$full_actual_outclk0_frequency \
				$full_actual_outclk1_frequency \
				$full_actual_outclk2_frequency \
				$full_actual_outclk3_frequency \
				$full_outclk0_actual_phase_shift \
				$full_outclk1_actual_phase_shift \
				$full_outclk2_actual_phase_shift \
				$full_outclk3_actual_phase_shift \
				$cmu_fpll_f_min_vco \
				$cmu_fpll_f_max_vco \
				$cmu_fpll_f_min_pfd \
				$device_revision \
				$gui_enable_fractional \
				$primary_use \
				$temp_bw_sel \
				$gui_is_downstream_cascaded_pll \
				]
			if {$error_occurred_in_validation} {
				return
			}	
			
			array set result_array $result
			set actual_is_fractional $result_array(uses_fractional)	
		}
		
	} else {
		set actual_is_fractional $default_value
	}
	
	ip_set "parameter.core_actual_using_fractional.value" $actual_is_fractional
	if {$debug_message} {
		puts "  core_actual_using_fractional->$actual_is_fractional"
	}	
}

proc ::altera_xcvr_fpll_vi::parameters::update_hssi_actual_using_fractional { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_hssi_output_clock_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	gui_hssi_prot_mode \
    	cmu_fpll_f_min_vco \
    	cmu_fpll_f_max_vco \
    	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	gui_enable_manual_hssi_counters \
	gui_pll_set_hssi_m_counter \
	gui_pll_set_hssi_n_counter \
	gui_pll_set_hssi_k_counter \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_actual_using_fractional"
	}	
	
	set default_value false
	
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	if {$using_hssi_mode} {
		if {$compensation_mode == "fpll_bonding"} {
			set actual_is_fractional false
		} else {
			
			set result [::altera_xcvr_fpll_vi::parameters::get_hssi_physical_m_cnt_params \
						$full_actual_refclk_frequency \
						$device_family \
						$numeric_speed_grade \
						$gui_fractional_x \
						$compensation_mode \
						$gui_enable_fractional \
						$gui_hssi_output_clock_frequency \
						$gui_hssi_prot_mode \
    						$cmu_fpll_f_min_vco \
    						$cmu_fpll_f_max_vco \
    						$cmu_fpll_f_min_pfd \
						$device_revision \
						$gui_enable_fractional \
						$primary_use \
						$gui_enable_manual_hssi_counters \
						$gui_pll_set_hssi_m_counter \
						$gui_pll_set_hssi_n_counter \
						$gui_pll_set_hssi_k_counter \
						$temp_bw_sel \
						$gui_is_downstream_cascaded_pll \
						]
			if {$error_occurred_in_validation} {
				return
			} 
			array set result_array $result
			set actual_is_fractional $result_array(uses_fractional)
		}
	} else {
		set actual_is_fractional $default_value
	}
	
	ip_set "parameter.hssi_actual_using_fractional.value" $actual_is_fractional
	if {$debug_message} {
		puts "  hssi_actual_using_fractional->$actual_is_fractional"
	}		
}
proc ::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_actual_using_fractional { \
	gui_fpll_mode \
	device_family \
	numeric_speed_grade \
	gui_fractional_x \
	gui_enable_fractional \
	gui_desired_hssi_cascade_frequency \
	full_actual_refclk_frequency \
	compensation_mode \
	cmu_fpll_f_min_vco \
	cmu_fpll_f_max_vco \
	cmu_fpll_f_min_pfd \
	device_revision \
	primary_use \
	temp_bw_sel \
	gui_is_downstream_cascaded_pll \
} {
	variable debug_message 
	variable error_occurred_in_validation	
	
	if {$error_occurred_in_validation} {
		return
	}

	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_hssi_cascade_actual_using_fractional"
	}	
	
	set default_value false
	
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]
	if {$using_cascade_mode} {
		set family $device_family
		set speedgrade $numeric_speed_grade
		set x $gui_fractional_x
		set compensation_mode $compensation_mode
		set is_fractional $gui_enable_fractional
		set hssi_cascade_freq $gui_desired_hssi_cascade_frequency
		set refclk_freq $full_actual_refclk_frequency
		
		set result [::altera_xcvr_fpll_vi::parameters::get_hssi_cascade_physical_m_cnt_params \
					$full_actual_refclk_frequency \
					$device_family \
					$numeric_speed_grade \
					$gui_fractional_x \
					$compensation_mode \
					$is_fractional \
					$hssi_cascade_freq \
					$cmu_fpll_f_min_vco \
					$cmu_fpll_f_max_vco \
					$cmu_fpll_f_min_pfd \
					$device_revision \
					$gui_enable_fractional \
					$primary_use \
					$temp_bw_sel \
					$gui_is_downstream_cascaded_pll \
					]
		if {$error_occurred_in_validation} {
			return
		} 
		array set result_array $result
		set actual_is_fractional $result_array(uses_fractional)
	} else {
		set actual_is_fractional $default_value
	}
	
	ip_set "parameter.hssi_cascade_actual_using_fractional.value" $actual_is_fractional
	if {$debug_message} {
		puts "  hssi_cascade_actual_using_fractional->$actual_is_fractional"
	}		
}

proc ::altera_xcvr_fpll_vi::parameters::update_pll_actual_using_fractional { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	core_actual_using_fractional \
	hssi_actual_using_fractional \
	hssi_cascade_actual_using_fractional
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_actual_using_fractional"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
		set is_fractional $hssi_actual_using_fractional
	} elseif {$using_cascade_mode} {
		set is_fractional $hssi_cascade_actual_using_fractional
	} elseif {$using_core_mode} {
		set is_fractional $core_actual_using_fractional
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}

	ip_set "parameter.pll_actual_using_fractional.value" $is_fractional
	
	if {$debug_message} {
		puts "  pll_actual_using_fractional->$is_fractional"
	}	
}

# +-----------------------------------
# | This function sets pll_m_counter_in_src parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_in_src {} {
   
   variable debug_message
   
   if {$debug_message} {
      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_in_src" 
   }
   
   set result "m_cnt_in_src_ph_mux_clk"

   if {$debug_message} {
      puts "  pll_m_counter_in_src -> $result " 
   }   
   ip_set "parameter.pll_m_counter_in_src.value" $result
}

# +-----------------------------------
# | This function sets pll_m_counter_ph_mux_prst parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_ph_mux_prst {} {   
#
#   variable debug_message
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_ph_mux_prst" 
#   }
#   
#   set result 0
#
#   if {$debug_message} {
#      puts "  pll_m_counter_ph_mux_prst -> $result " 
#   }   
#   ip_set "parameter.pll_m_counter_ph_mux_prst.value" $result
#   
#}

# +-----------------------------------
# | This function sets pll_m_counter_prst parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_prst {} {   
#
#   variable debug_message
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_prst" 
#   }
#   
#   set result 1
#
#   if {$debug_message} {
#      puts "  pll_m_counter_prst -> $result " 
#   }   
#   ip_set "parameter.pll_m_counter_prst.value" $result
#   
#}

# +-----------------------------------
# | This function sets pll_m_counter_coarse_dly parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_coarse_dly {} {   
#
#   variable debug_message
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_coarse_dly" 
#   }
#   
#   set result "0 ps"
#
#   if {$debug_message} {
#      puts "  pll_m_counter_coarse_dly -> $result " 
#   }   
#   ip_set "parameter.pll_m_counter_coarse_dly.value" $result
#   
#}

# +-----------------------------------
# | This function sets pll_m_counter_fine_dly parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_fine_dly {} {   
#
#   variable debug_message
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_m_counter_fine_dly" 
#   }
#   
#   set result "0 ps"
#
#   if {$debug_message} {
#      puts "  pll_m_counter_fine_dly -> $result " 
#   }   
#   ip_set "parameter.pll_m_counter_fine_dly.value" $result
#   
#}

# +-----------------------------------
# | This function sets pll_n_counter parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_pll_n_counter { \
	gui_reference_clock_frequency \
	gui_fpll_mode \
	core_n_counter \
	hssi_cascade_n_counter \
	hssi_n_counter \
    gui_enable_manual_hssi_counters \
    gui_pll_set_hssi_n_counter \
} {
	variable debug_message 
	variable error_occurred_in_validation
	
	if {$error_occurred_in_validation} {
		return 
	}
	
	if {$debug_message} {
		puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_n_counter"
	}
	
	set using_core_mode [using_core_mode $gui_fpll_mode]
	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	set using_cascade_mode [using_cascade_mode $gui_fpll_mode]

	if {$using_hssi_mode} {
        if {$gui_enable_manual_hssi_counters } {
            set counter_val $gui_pll_set_hssi_n_counter
        } else {
		    set counter_val $hssi_n_counter
        } 
	} elseif {$using_cascade_mode} {
		set counter_val $hssi_cascade_n_counter
	} elseif {$using_core_mode} {
		set counter_val $core_n_counter
	} else {
		error "IE: Unknown fpll mode ($gui_fpll_mode)"
	}

	ip_set "parameter.pll_n_counter.value" $counter_val
	
	if {$debug_message} {
		puts "  pll_n_counter->$counter_val"
	}
}

# +-----------------------------------
# | This function sets pll_n_counter_coarse_dly parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_n_counter_coarse_dly {} {   
#
#   variable debug_message
#   variable error_occurred_in_validation
#   
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_n_counter_coarse_dly" 
#   }
#   
#   set result "0 ps"
#
#   if {$debug_message} {
#      puts "  pll_n_counter_coarse_dly -> $result " 
#   }   
#   ip_set "parameter.pll_n_counter_coarse_dly.value" $result
#   
#}

# +-----------------------------------
# | This function sets pll_n_counter_fine_dly parameter  
# |
#proc ::altera_xcvr_fpll_vi::parameters::update_pll_n_counter_fine_dly {} {   
#
#   variable debug_message
#   variable error_occurred_in_validation
#   
#   if {$error_occurred_in_validation} {
#      return
#   }
#   
#   if {$debug_message} {
#      puts "\n::altera_xcvr_fpll_vi::parameters::update_pll_n_counter_fine_dly" 
#   }
#   
#   set result "0 ps"
#
#   if {$debug_message} {
#      puts "  pll_n_counter_fine_dly -> $result " 
#   }   
#   ip_set "parameter.pll_n_counter_fine_dly.value" $result
#   
#}

# +-----------------------------------
# | This function sets speed_grade parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_speed_grade { device_speed_grade } {
	# set speed_grade [ ::alt_xcvr::utils::device::convert_speed_grade $device_speed_grade ]
	# ip_set "parameter.speed_grade.value" $speed_grade
}


proc ::altera_xcvr_fpll_vi::parameters::update_gui_operation_mode {\
	gui_operation_mode \
	gui_fpll_mode \
	gui_hssi_prot_mode \
} {

	variable error_occurred_in_validation
	# if {$error_occurred_in_validation} {
		# return
	# }
	
	switch $gui_fpll_mode {
		0 {
			#core mode
#			set allowed_range {"0:direct" "1:normal"}
#			set numerical_range {0 1}
			set allowed_range {"0:direct"}
			set numerical_range {0}
		}
		1 {
			#cascade mode
			set allowed_range {"0:direct"}
			set numerical_range {0}
		}
		2 {
			#hssi mode
			switch $gui_hssi_prot_mode {
				0 {
					#basic
					set allowed_range {"0:direct" "2:feedback compensation bonding"}
					set numerical_range {0 2}
				}
				1 -
				2 -
				3 {
					#any pcie mode
					set allowed_range {"0:direct"}
					set numerical_range {0}
				}
			    4 {
				set allowed_range {"0:direct"}
				set numerical_range {0}
			    }
			    5 {
				set allowed_range {"0:direct"}
				set numerical_range {0}
			    }
			    6 {
				# SDI direct
				set allowed_range {"0:direct" "2:feedback compensation bonding"}
				set numerical_range {0 2}
			    }
			    7 {
				set allowed_range {"0:direct" "2:feedback compensation bonding"}
				set numerical_range {0 2}
			    }
			    8 {
				# OTN direct
				set allowed_range {"0:direct"}
				set numerical_range {0}
			    }
                9 {
                # SATA GEN3
                set allowed_range {"0:direct"}
                set numerical_range {0}
                }
                10 {
                # HDMI
                set allowed_range {"0:direct"}
                set numerical_range {0}
                }
			    default {
				ip_message error "Unknown protocol mode $gui_hssi_prot_mode"
				}
			}
		}
		default {
			ip_message error "Unknown fpll mode $gui_fpll_mode"
			set error_occurred_in_validation true
			#HACK!!!
			set allowed_range {"0:direct"}
			set numerical_range {0}
		}
	}

	ip_set "parameter.gui_operation_mode.ALLOWED_RANGES" $allowed_range

	#now check that the current value actually lies in the allowed range. This is stupid, because qsys should take care of it for us, but it doesn't.
	if {$gui_fpll_mode == 0 && $gui_operation_mode == 1} {
	   # normal feedback is no longer supported in core mode. Upgrade to Direct mode
	   ip_message error "Feedback Operation Mode = Normal(gui_operation_mode = 1) is no longer supported for Core Mode -- switch to Direct"
	   #upgrade_parameter gui_operation_mode 0
	} 
	if {[lsearch $numerical_range $gui_operation_mode] == -1} {
	   set error_occurred_in_validation true
	}	
}


# +-----------------------------------
# | This function gets compensation_mode string based on the given parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::get_compensation_mode { \
	gui_operation_mode \
} {

	switch $gui_operation_mode {
		0 {
			set compensation_mode "direct"
		}
		1 {
			set compensation_mode "normal"
		}
		2 {
			set compensation_mode "fpll_bonding"
		}
		default {
			error "Unknown operation mode $gui_operation_mode"
		}
	}
	#old mode: iqtxrxclk

	return $compensation_mode
}

# +-----------------------------------
# | This function sets compensation_mode parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_compensation_mode { \
	gui_number_of_output_clocks \
	gui_operation_mode \
	enable_mcgb \
	enable_bonding_clks \
	enable_fb_comp_bonding \
	gui_fpll_mode \
	gui_enable_fractional \
} {

	variable error_occurred_in_validation

	set compensation_mode [get_compensation_mode $gui_operation_mode]
	ip_set "parameter.compensation_mode.value" $compensation_mode
	#set is_fpll_bonding_mode [get_parameter_value "enable_fb_comp_bonding"]

	set using_hssi_mode [using_hssi_mode $gui_fpll_mode]
	# if {!$using_hssi_mode} {
		# set must_uncheck_mcgb true
	# } else {
		# set must_uncheck_mcgb false
	# }
	
	set enabled_bonding_mode_through_mcgb_tab [expr {$enable_mcgb  && $enable_bonding_clks && $enable_fb_comp_bonding}]
	
	if {$using_hssi_mode && $gui_operation_mode == 2} {
		if {$gui_enable_fractional} {
			ip_message error "Feedback compensation bonding is not available in fractional PLL mode. To use feedback compensation bonding, please uncheck \"Enable fractional mode\" under PLL tab."
			set error_occurred_in_validation true 
		}
	}
	
	if {$using_hssi_mode} {
		if {$enabled_bonding_mode_through_mcgb_tab && $gui_operation_mode != 2} {
			ip_message error "To enable feedback compensation bonding, \"Operation mode\" must be set to \"feedback compensation bonding\" on the \"PLL\" tab."
			set error_occurred_in_validation true
		}
		if {!$enabled_bonding_mode_through_mcgb_tab && $gui_operation_mode == 2} {
			ip_message error "To enable feedback compensation bonding, check the \"Include Master Clock Generation Block\", \"Enable bonding clock output ports\", and \"Enable feedback compensation mode\" options on the \"Master Clock Generation Block\" tab."
			set error_occurred_in_validation true 
		}	
	}

	if {!$using_hssi_mode} {
		if {$enable_mcgb} {
			ip_message error "You must uncheck \"Include Master Clock Generation Block\" on the \"Master Clock Generation Block\" tab if Transceiver mode is not being used."
			set error_occurred_in_validation true 
			set mcgb_visibility true 
			#keep visible until error resolved
		} else {
			set mcgb_visibility false
		}
	} else {
		set mcgb_visibility true 
	}
	ip_set "display_item.Master Clock Generation Block.visible" $mcgb_visibility 
	# if {$must_uncheck_mcgb} {
		# #except, this is kinda a hack, but
		# if {$enable_mcgb} {
			# ip_message error "You must uncheck \"Include Master Clock Generation Block\" on the \"Master Clock Generation Block\" tab if feedback compensation bonding is not being used."
			# set error_occurred_in_validation true 
		# } else {
			# if {[get_parameter_value gui_fpll_mode] == 2} {
				# set mcgb_visibility true
			# } else {
				# set mcgb_visibility false
			# }
			# ip_set "display_item.Master Clock Generation Block.visible" $mcgb_visibility 			
		# }	
	# }

}

proc ::altera_xcvr_fpll_vi::parameters::update_feedback { \
	gui_operation_mode \
} {
	set compensation_mode [get_compensation_mode $gui_operation_mode]
	
	# Confusingly, the "feedback" BCM parameter takes three possible values...
	#   - NORMAL, for direct mode
	#   - CORE_COMP, for normal mode
	#   - IQTXRXCLK, for IQTXRX feedback (bonding mode)
	
	switch $compensation_mode {
		"direct" {
			set feedback "normal"
		}
		"normal" {
			set feedback "core_comp"
		}
		"iqtxrxclk" { 
			set feedback "iqtxrxclk"
		}
		"fpll_bonding" {
			set feedback "iqtxrxclk"
		}
		default {
			error "Unknown compensation mode. Error in the gui. Update this list."
		}
	}
	
	ip_set "parameter.feedback.value" $feedback
}

# +-----------------------------------
# | This function sets compensation_mode parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_silicon_rev { silicon_rev } {
   #ip_message warning "::altera_xcvr_fpll_vi::parameters::convert_silicon_rev NOTE TO IP DEVELOPER: THIS FUNCTION MUST CHANGE"

   if {[string compare -nocase $silicon_rev true]==0 } {
      ip_set "parameter.gui_silicon_rev.value" "20nm5es"
   } elseif { [string compare -nocase $silicon_rev false]==0 } {
      ip_set "parameter.gui_silicon_rev.value" "20nm5es"
   } else {
      ip_set "parameter.gui_silicon_rev.value" "20nm5es"
      ip_message warning "Unexpected silicon_rev($silicon_rev), selecting 20nm5es"
   }   
}       

# +-----------------------------------
# | This function updates/prints necessary error message when enable pcie_clk is turned on 
# |
proc ::altera_xcvr_fpll_vi::parameters::update_enable_pcie_clk { gui_enable_pcie_clk gui_fpll_mode output_clock_frequency_0 gui_hssi_output_clock_frequency } {
  # if { $gui_enable_pcie_clk } {
	  # if { $gui_enable_transceiver_usage } {
		# # the Transceiver usage is on -- make sure Transceiver outclock is running at 2500MHz
		# if { $gui_hssi_output_clock_frequency != "2500" } {
			# send_message error "Please specify correct output frequency on Tranceiver PLL usage -- output frequency is required to toggle at 2500 MHz for PCIe."
		# }
		
		# # the core usage (outclk0) needs to be on for PCIE usage
		# if { $gui_enable_core_usage } {
			# regexp {([0-9.]+)} $output_clock_frequency_0 outclk_freq_value_0  
			# if { [expr $outclk_freq_value_0 != 500] } {
				# send_message error "Please specify correct output frequency on Core PLL usage -- outclk0 is required to toggle at 500 MHz for PCIe."
			# }
		# } else {
			# send_message error "Please enable Core PLL usage -- outclk0 is required to toggle at 500 MHz for PCIe."
		# }
	  # } else {
		# send_message error "Please enable Tranceiver PLL usage -- output frequency is required to toggle at 2500 MHz for PCIe."
	  # }
  # }
} 


# +-----------------------------------
# | This function updates/prints necessary error message when enable atx pll cascade out is turned on
# |
proc ::altera_xcvr_fpll_vi::parameters::update_enable_atx_pll_cascade_out { \
	gui_fpll_mode \
	gui_number_of_output_clocks \
} {
   # if { $gui_enable_atx_pll_cascade_out } {
	   # # setup the new range for gui_atx_pllcascade_outclk_index
	   # set new_range 0
	   # if { $gui_number_of_output_clocks > 1} {
		  # lappend new_range 1
	   # }
	   # ip_set "parameter.gui_atx_pllcascade_outclk_index.ALLOWED_RANGES" $new_range
	   
	   # # a Core outclk is required for cascading purposes
	   # if { $gui_enable_core_usage } {
			# # no op
	   # } else {
			# send_message error "Please enable Core PLL usage -- an outclk is required to use for cascading."
	   # }
   # }
}

# +-----------------------------------
# | This function copies the pll_counter_3 parameters with the cascading source 
# |
proc ::altera_xcvr_fpll_vi::parameters::update_cascade_outclk_index { \
	gui_number_of_output_clocks \
	gui_enable_cascade_out \
} {
	
	if {$gui_enable_cascade_out} {
	   # setup the new range for gui_cascade_outclk_index
	   set new_range 0
	   for {set index 1} {$index < $gui_number_of_output_clocks} {incr index} {
		  lappend new_range $index
	   }
	   ip_set "parameter.gui_cascade_outclk_index.ALLOWED_RANGES" $new_range
	}
	# if { $gui_enable_cascade_out && $gui_cascade_outclk_index != 3 } {
		# set param "pll_c_counter_$gui_cascade_outclk_index"
		# set in_src "_in_src"
		# set ph_mux_prst "_ph_mux_prst"
		# set prst "_prst"
		# set coarse_dly "_coarse_dly"
		# set fine_dly "_fine_dly"
		
		# # overwrite pll_c_counter_3 paramters since cascade_out is connected with counter 3
		# ip_set "parameter.pll_c_counter_3.value" [set $param]
		# set param_name $param$in_src
		# ip_set "parameter.pll_c_counter_3_in_src.value" [set $param_name]
		# set param_name $param$ph_mux_prst
		# ip_set "parameter.pll_c_counter_3_ph_mux_prst.value" [set $param_name]
		# set param_name $param$prst
		# ip_set "parameter.pll_c_counter_3_prst.value" [set $param_name]
		# set param_name $param$coarse_dly
		# ip_set "parameter.pll_c_counter_3_coarse_dly.value" [set $param_name]
		# set param_name $param$fine_dly
		# ip_set "parameter.pll_c_counter_3_fine_dly.value" [set $param_name]
		# ip_set "parameter.output_clock_frequency_3.value" [set output_clock_frequency_$gui_cascade_outclk_index]
		# ip_set "parameter.phase_shift_3.value" [set phase_shift_$gui_cascade_outclk_index]
		
		# # output an info message to indicate that we are overwriting pll_c_counter_3 parameters
		# ip_message info "Replacing outclk3 with outclk$gui_cascade_outclk_index parameters as outclk3 will be used as FPLL to FPLL cascading source"
	# }	
}

# +-----------------------------------
# | This function copies the pll_counter_1 parameters with the cascading source 
# |
proc ::altera_xcvr_fpll_vi::parameters::update_atx_pll_cascade_outclk_index { 
	pll_c_counter_0 \
	pll_c_counter_1 \
	pll_c_counter_2 \
	pll_c_counter_3 \
	pll_c_counter_0_in_src \
	pll_c_counter_1_in_src \
	pll_c_counter_2_in_src \
	pll_c_counter_3_in_src \
	pll_c_counter_0_ph_mux_prst \
	pll_c_counter_1_ph_mux_prst \
	pll_c_counter_2_ph_mux_prst \
	pll_c_counter_3_ph_mux_prst \
	pll_c_counter_0_prst \
	pll_c_counter_1_prst \
	pll_c_counter_2_prst \
	pll_c_counter_3_prst \
	pll_c_counter_0_coarse_dly \
	pll_c_counter_1_coarse_dly \
	pll_c_counter_2_coarse_dly \
	pll_c_counter_3_coarse_dly \
	pll_c_counter_0_fine_dly \
	pll_c_counter_1_fine_dly \
	pll_c_counter_2_fine_dly \
	pll_c_counter_3_fine_dly \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {

	# if { $gui_enable_atx_pll_cascade_out && $gui_atx_pllcascade_outclk_index != 1 } {
		# set param "pll_c_counter_$gui_atx_pllcascade_outclk_index"
		# set in_src "_in_src"
		# set ph_mux_prst "_ph_mux_prst"
		# set prst "_prst"
		# set coarse_dly "_coarse_dly"
		# set fine_dly "_fine_dly"
		
		# # overwrite pll_c_counter_1 paramters since iqtxrxclk is connected with counter 1
		# ip_set "parameter.pll_c_counter_1.value" [set $param]
		# set param_name $param$in_src
		# ip_set "parameter.pll_c_counter_1_in_src.value" [set $param_name]
		# set param_name $param$ph_mux_prst
		# ip_set "parameter.pll_c_counter_1_ph_mux_prst.value" [set $param_name]
		# set param_name $param$prst
		# ip_set "parameter.pll_c_counter_1_prst.value" [set $param_name]
		# set param_name $param$coarse_dly
		# ip_set "parameter.pll_c_counter_1_coarse_dly.value" [set $param_name]
		# set param_name $param$fine_dly
		# ip_set "parameter.pll_c_counter_1_fine_dly.value" [set $param_name]
		# ip_set "parameter.output_clock_frequency_1.value" [set output_clock_frequency_$gui_atx_pllcascade_outclk_index]
		# ip_set "parameter.phase_shift_1.value" [set phase_shift_$gui_atx_pllcascade_outclk_index]

		# # output an info message to indicate that we are overwriting pll_c_counter_1 parameters
		# ip_message info "Replacing outclk1 with outclk$gui_atx_pllcascade_outclk_index parameters as outclk1 will be used as FPLL to ATX PLL cascading source"
	# }
}

# +-----------------------------------
# | This function copies the pll_counter_1 parameters with the IQTXRXCLK feedback source 
# |
proc ::altera_xcvr_fpll_vi::parameters::update_iqtxrxclk_outclk_index { \
	gui_enable_iqtxrxclk_mode \
	gui_iqtxrxclk_outclk_index \
	pll_c_counter_0 \
	pll_c_counter_1 \
	pll_c_counter_2 \
	pll_c_counter_3 \
	pll_c_counter_0_in_src \
	pll_c_counter_1_in_src \
	pll_c_counter_2_in_src \
	pll_c_counter_3_in_src \
	pll_c_counter_0_ph_mux_prst \
	pll_c_counter_1_ph_mux_prst \
	pll_c_counter_2_ph_mux_prst \
	pll_c_counter_3_ph_mux_prst \
	pll_c_counter_0_prst \
	pll_c_counter_1_prst \
	pll_c_counter_2_prst \
	pll_c_counter_3_prst \
	pll_c_counter_0_coarse_dly \
	pll_c_counter_1_coarse_dly \
	pll_c_counter_2_coarse_dly \
	pll_c_counter_3_coarse_dly \
	pll_c_counter_0_fine_dly \
	pll_c_counter_1_fine_dly \
	pll_c_counter_2_fine_dly \
	pll_c_counter_3_fine_dly \
	output_clock_frequency_0 \
	output_clock_frequency_1 \
	output_clock_frequency_2 \
	output_clock_frequency_3 \
	phase_shift_0 \
	phase_shift_1 \
	phase_shift_2 \
	phase_shift_3 \
} {
	#HACK!!!???
	
	# if { $gui_enable_atx_pll_cascade_out && $gui_enable_iqtxrxclk_mode && $gui_iqtxrxclk_outclk_index != $gui_atx_pllcascade_outclk_index } {
		# # conflict with cascading feature
		# ip_message error "Cannot use outclk1 as IQTXRXCLK feedback source as outclk1 is already used as FPLL to ATX PLL cascading source"		
	# } elseif { $gui_enable_iqtxrxclk_mode && $gui_iqtxrxclk_outclk_index != 1 } {
		# set param "pll_c_counter_$gui_iqtxrxclk_outclk_index"
		# set in_src "_in_src"
		# set ph_mux_prst "_ph_mux_prst"
		# set prst "_prst"
		# set coarse_dly "_coarse_dly"
		# set fine_dly "_fine_dly"
		
		# # overwrite pll_c_counter_1 paramters since iqtxrxclk is connected with counter 1
		# ip_set "parameter.pll_c_counter_1.value" [set $param]
		# set param_name $param$in_src
		# ip_set "parameter.pll_c_counter_1_in_src.value" [set $param_name]
		# set param_name $param$ph_mux_prst
		# ip_set "parameter.pll_c_counter_1_ph_mux_prst.value" [set $param_name]
		# set param_name $param$prst
		# ip_set "parameter.pll_c_counter_1_prst.value" [set $param_name]
		# set param_name $param$coarse_dly
		# ip_set "parameter.pll_c_counter_1_coarse_dly.value" [set $param_name]
		# set param_name $param$fine_dly
		# ip_set "parameter.pll_c_counter_1_fine_dly.value" [set $param_name]
		# ip_set "parameter.output_clock_frequency_1.value" [set output_clock_frequency_$gui_iqtxrxclk_outclk_index]
		# ip_set "parameter.phase_shift_1.value" [set phase_shift_$gui_iqtxrxclk_outclk_index]

		# # output an info message to indicate that we are overwriting pll_c_counter_1 parameters
		# ip_message info "Replacing outclk1 with outclk$gui_iqtxrxclk_outclk_index parameters as outclk1 will be used as IQTXRXCLK feedback source"
	# }
}

# +-----------------------------------
# | This function generate hip_cal_en parameter value
# |
proc ::altera_xcvr_fpll_vi::parameters::update_hip_cal_en { gui_hip_cal_en } {
	set value [expr { $gui_hip_cal_en ? "enable" : "disable"}]
	ip_set "parameter.hip_cal_en.value" $value
}
# +-----------------------------------
# | Map legal values in allowed range to fixed symbolic values
# | 
# | Inputs:
# |   $gui_param_name - symbolic parameter used for GUI display map
# |     Symbols are normal values like "8", or "16", or "32.5 MHz".
# |     At most one symbol will be mapped for any given parameter,
# |     typically because the default value or the last value entered
# |     by the user is no longer valid.
# |     If the current value of a parameter is legal, there will be
# |     no entries in the symbolic map array.
# |     The legal value set is given in the $legal_values parameter
# |   $legal_values   - list of currently legal real values
# | 
# | Returns:
# |   nothing, but does the following:
# |   - sets ALLOWED_RANGE for named parameter
# |   - saves mapping in global array for retrieval using [get_mapped_allowed_range_value gui_param]
# |   # $allowed_range - list that maps symbolic values to legal values for GUI selection
proc ::altera_xcvr_fpll_vi::parameters::map_allowed_range { gui_param_name legal_values map_value} {
 
	::alt_xcvr::utils::common::map_allowed_range $gui_param_name $legal_values $map_value false

}

# --------------------------------------------------------------------
# UPGRADE FUNCTIONS!!!!

proc ::altera_xcvr_fpll_vi::parameters::upgrade_parameter {param_name new_value} {
	set_parameter_value $param_name $new_value
}

proc ::altera_xcvr_fpll_vi::parameters::get_property {parameter_data parameter property} {
	
	if {[dict exist $parameter_data $parameter $property]} {
		set val [dict get $parameter_data $parameter $property]
		return $val
	} else {
		return "NOVAL"
	}
}
proc ::altera_xcvr_fpll_vi::parameters::upgrade {ip_core_type version old_param_set} {
	variable parameters
	set new_param_set [get_parameters]
	
	set param_dict [::alt_xcvr::ip_tcl::ip_module::convert_data_to_dict $parameters]
	foreach new_parameter $new_param_set {
		set upgrade_function [::altera_xcvr_fpll_vi::parameters::get_property $param_dict $new_parameter M_UPGRADE_CALLBACK]
		if {$upgrade_function != "NOVAL"} {
			$upgrade_function $version $old_param_set
		} else {
			if {[lsearch $old_param_set $new_parameter] != -1} {
				set old_param_value [get_old_parameter_value $new_parameter $old_param_set]
				upgrade_parameter $new_parameter $old_param_value
			}
		}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::get_old_parameter_value {param_name old_params} {
	set param_index [lsearch $old_params $param_name]
	if {$param_index == -1} {
		error "IE: $param_name doesn't exist in old parameter list"
	} else {
		return [lindex $old_params [expr {$param_index + 1}]]
	}
}

proc ::altera_xcvr_fpll_vi::parameters::get_necessary_parameters {version old_params necessary_parameters} {
	foreach param $necessary_parameters {
		set param_index [lsearch $old_params $param]
		if {$param_index == -1} {
			error "IE: Necessary parameter $param does not exist in $version"
		} else {
			upvar $param local_version
			set local_version [lindex $old_params [expr {$param_index + 1}]]
		}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::found_necessary_parameters {version old_params necessary_parameters} {
	foreach param $necessary_parameters {
		set param_index [lsearch $old_params $param]
		if {$param_index == -1} {
			return 0
		} else {
			return 1
		}
	}
}

##   if {$ghi_enable_fractional || $gui_fpll_mode == 1 || ($gui_fpll_mode == 0 && $gui_enable_cascade_out)} { --> follow what is happening update_temp_bw_sel

proc ::altera_xcvr_fpll_vi::parameters::upgrade_temp_bw_sel { version gui_enable_fractional gui_fpll_mode gui_enable_cascade_out } {
   if {$gui_enable_fractional || $gui_fpll_mode == 1} {
	return "medium"
   } else {
	return "high"
   }

}

# --------------------------------------------------------------------
proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_fpll_mode { \
	version \
	old_param_set \
} {
	
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
			{gui_enable_transceiver_usage \
			gui_enable_core_usage \
			gui_enable_atx_pll_cascade_out \
			gui_number_of_output_clocks \
			gui_refclk_cnt}
			
		if {$gui_enable_core_usage && !$gui_enable_transceiver_usage && !$gui_enable_atx_pll_cascade_out} {
			#set to core mode safely...
			set new_gui_fpll_mode 0 
		} elseif {$gui_enable_transceiver_usage && !$gui_enable_core_usage && !$gui_enable_atx_pll_cascade_out} {
			set new_gui_fpll_mode 2
		} elseif {$gui_enable_atx_pll_cascade_out && $gui_number_of_output_clocks == 1 && $gui_enable_core_usage && !$gui_enable_transceiver_usage} {
			set new_gui_fpll_mode 1
		} else {
			set new_gui_fpll_mode -1
			send_message warning "Upgrade failed. The imported settings have created an illegal FPLL. Unable to infer user's intended use mode."
			if {$gui_enable_core_usage && $gui_enable_transceiver_usage} {
				send_message warning "Simultaneous Core Usage and Transceiver Usage is no longer permitted."
			} 
			if {$gui_enable_atx_pll_cascade_out && $gui_number_of_output_clocks > 1 && $gui_enable_core_usage} {
				send_message warning "Cascading to Transceiver ATX/CDR PLL is no longer permitted with Core Usage. Only one output clock may be used while cascading."
			}
			if {$gui_enable_transceiver_usage && $gui_enable_atx_pll_cascade_out} {
				send_message warning "Cascading to Transceiver ATX/CDR PLL is no longer permitted with Transceiver Usage."
			}
		}
		upgrade_parameter gui_fpll_mode $new_gui_fpll_mode
		
		#if {$new_gui_fpll_mode != 0 && $gui_refclk_cnt != 1} {
		#	send_message error "Upgrade failed. Only 1 reference clock may be used in the inferred use mode of $new_gui_fpll_mode."
		#	send_message warning "Recovering from failure. Using 1 reference clock instead of $gui_refclk_cnt."
		#}
	} else {
		set found [::altera_xcvr_fpll_vi::parameters::found_necessary_parameters $version $old_param_set {gui_fpll_mode}]
		if { $found == 1 } {
			::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
				{gui_fpll_mode}			
			upgrade_parameter gui_fpll_mode $gui_fpll_mode
		} else {
			set found [::altera_xcvr_fpll_vi::parameters::found_necessary_parameters $version $old_param_set {gui_enable_transceiver_usage gui_enable_core_usage gui_enable_atx_pll_cascade_out gui_number_of_output_clocks gui_refclk_cnt}]
			if { $found == 1 } {
				::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
					{gui_enable_transceiver_usage \
					gui_enable_core_usage \
					gui_enable_atx_pll_cascade_out \
					gui_number_of_output_clocks \
					gui_refclk_cnt}

				if {$gui_enable_core_usage && !$gui_enable_transceiver_usage && !$gui_enable_atx_pll_cascade_out} {
					#set to core mode safely...
					set new_gui_fpll_mode 0 
				} elseif {$gui_enable_transceiver_usage && !$gui_enable_core_usage && !$gui_enable_atx_pll_cascade_out} {
					set new_gui_fpll_mode 2
				} elseif {$gui_enable_atx_pll_cascade_out && $gui_number_of_output_clocks == 1 && $gui_enable_core_usage && !$gui_enable_transceiver_usage} {
					set new_gui_fpll_mode 1
				} else {
					set new_gui_fpll_mode 2
				}
				upgrade_parameter gui_fpll_mode $new_gui_fpll_mode
			} else {
				upgrade_parameter gui_fpll_mode 2
			}
		}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_hssi_prot_mode { \
	version \
	old_param_set \
} {
	
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
			{gui_hssi_prot_mode}
			
		switch $gui_hssi_prot_mode {
			Basic {
				set new_value 0
			}
			"PCIe Gen 1" {
				set new_value 1
			}
			"PCIe Gen 2" {
				set new_value 2
			} 
			default {
				error "IE: Unknown old prot mode: $gui_hssi_prot_mode"
			}
		}	
		
		upgrade_parameter gui_hssi_prot_mode $new_value
	} else {
		::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
			{gui_hssi_prot_mode}			
			
		switch $gui_hssi_prot_mode {
			"Basic" {
				set new_value 0
			}
			"PCIe Gen 1" {
				set new_value 1
			}
			"PCIe Gen 2" {
				set new_value 2
			} 
			default {
				set new_value $gui_hssi_prot_mode
			}
		}				
			
		upgrade_parameter gui_hssi_prot_mode $new_value
	}
}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_operation_mode { \
	version \
	old_param_set \
} {
	
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
			{gui_operation_mode \
			enable_mcgb \
			enable_bonding_clks \
			enable_fb_comp_bonding}
			
		switch $gui_operation_mode {
			"direct" {
				set new_value 0
			}
			"normal" - 1
			{
			    #puts "switching gui_operation_mode"
			    ip_message warning "Feedback Operation Mode = Normal(gui_operation_mode = 1) is no longer supported for Core Mode -- switch to Direct"
				set new_value 1
				# set new_value 0
			}
			"fpll bonding" {
				set new_value 2
			} 
			default {
				error "IE: Unknown old operation mode: $gui_operation_mode"
			}
		}	
		
		if {$enable_mcgb && $enable_bonding_clks && $enable_fb_comp_bonding} {
			set new_value 2
		}
		upgrade_parameter gui_operation_mode $new_value
	} else {
		::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
			{gui_operation_mode}		
			
		switch $gui_operation_mode {
			"direct" {
				set new_value 0
			}
			"normal" - 1
			{
			    #puts "switching gui_operation_mode"
			    ip_message warning "Feedback Operation Mode = Normal(gui_operation_mode = 1) is no longer supported for Core Mode -- switch to Direct"
 				set new_value 1
				#set new_value 0
			}
			"fpll bonding" {
				set new_value 2
			} 
			default {
				set new_value $gui_operation_mode
			}
		}	
		upgrade_parameter gui_operation_mode $new_value
	}
}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk0_phase_shift_unit { \
	version \
	old_param_set \
} {
	
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::upgrade_phase_shift_units_131 \
			$version \
			$old_param_set \
			gui_outclk0_phase_shift_unit
	} 

}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk1_phase_shift_unit { \
	version \
	old_param_set \
} {
	
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::upgrade_phase_shift_units_131 \
			$version \
			$old_param_set \
			gui_outclk1_phase_shift_unit
	} 

}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk2_phase_shift_unit { \
	version \
	old_param_set \
} {
	
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::upgrade_phase_shift_units_131 \
			$version \
			$old_param_set \
			gui_outclk2_phase_shift_unit
	} 

}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_outclk3_phase_shift_unit { \
	version \
	old_param_set \
} {
	
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::upgrade_phase_shift_units_131 \
			$version \
			$old_param_set \
			gui_outclk3_phase_shift_unit
	} 

}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_phase_shift_units_131 { \
	version \
	old_param_set \
	param_to_find \
} {
	::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
		[list $param_to_find]
		
	switch [set $param_to_find] {
		ps {
			set new_value 0
		}
		degrees {
			set new_value 1
		}
		default {
			error "IE: Unknown old phase unit: [set $param_to_find]"
		}
	}	
	
	upgrade_parameter $param_to_find $new_value	
}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_desired_refclk_frequency { \
	version \
	old_param_set \
} {
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
			{gui_reference_clock_frequency}
		
		#might as well set this to the old refclk. if we're not in Hssi or Cascade mode, then it doesn't matter anyway
		upgrade_parameter gui_desired_refclk_frequency $gui_reference_clock_frequency
	} else {
		set found [::altera_xcvr_fpll_vi::parameters::found_necessary_parameters $version $old_param_set {gui_desired_refclk_frequency}]
		if { $found == 1 } {
			::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
				{gui_desired_refclk_frequency}			
			upgrade_parameter gui_desired_refclk_frequency $gui_desired_refclk_frequency
		}
	}
}

proc ::altera_xcvr_fpll_vi::parameters::upgrade_gui_desired_hssi_cascade_frequency { \
	version \
	old_param_set \
} {
	if {$version == "13.1"} {
		::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
			{gui_enable_atx_pll_cascade_out \
			gui_atx_pllcascade_outclk_index \
			gui_desired_outclk0_frequency \
			gui_desired_outclk1_frequency \
			gui_desired_outclk2_frequency \
			gui_desired_outclk3_frequency}
		
		#might as well set this to the old refclk. if we're not in Hssi or Cascade mode, then it doesn't matter anyway
		if {$gui_enable_atx_pll_cascade_out} {
			upgrade_parameter gui_desired_hssi_cascade_frequency [set gui_desired_outclk${gui_atx_pllcascade_outclk_index}_frequency]
		}
	} else {
		set found [::altera_xcvr_fpll_vi::parameters::found_necessary_parameters $version $old_param_set {gui_desired_hssi_cascade_frequency}]
		if { $found == 1 } {
			::altera_xcvr_fpll_vi::parameters::get_necessary_parameters $version $old_param_set \
				{gui_desired_hssi_cascade_frequency}			
			upgrade_parameter gui_desired_hssi_cascade_frequency $gui_desired_hssi_cascade_frequency
		}
	}    
}

proc ::altera_xcvr_fpll_vi::parameters::validate_enable_calibration { set_altera_xcvr_fpll_a10_calibration_en enable_advanced_options } {
  set value [expr { $enable_advanced_options ? $set_altera_xcvr_fpll_a10_calibration_en:1}]
  if { $value } {
    ip_set "parameter.calibration_en.value" "enable"
  } else {
    ip_set "parameter.calibration_en.value" "disable"
  }
}

# +-----------------------------------
# | This function sets compensation_mode parameter  
# |
# |  || ($gui_fpll_mode == 0 && $gui_enable_cascade_out)} { --> Need to make changes to ../source/altera_xcvr_fpll_a10.sv before we can add the dedicated cascade connection bw rule.
#   |Will also need to update what is happening in 'upgrade_temp_bw_sel' when making changes here.  Yuck.


## Implement following BW rules:
## Integer mode (not cascade): Low, Medium, High
## Integer mode (cascade): Medium and High only (No low)
## For Fractional mode OR if being used as a cascade source - LOW or MEDIUM

 proc ::altera_xcvr_fpll_vi::parameters::update_temp_bw_sel { gui_enable_fractional gui_desired_refclk_frequency gui_fpll_mode gui_enable_cascade_out gui_bw_sel gui_hssi_prot_mode gui_is_downstream_cascaded_pll gui_enable_low_f_support } {
     ip_set "parameter.temp_bw_sel.value" $gui_bw_sel
	 if { $gui_is_downstream_cascaded_pll } {
	    if { $gui_bw_sel != "low" } {
 	       ip_message error "Bandwidth setting must be \"low\" when the fPLL is specified as a downstream pll."
	    }
	 }
	 if { $gui_enable_low_f_support && $gui_desired_refclk_frequency < 50  } {
	    if { $gui_bw_sel != "low" } {
 	       ip_message error "Bandwidth setting must be \"low\" when the fPLL is configured to support the current protocol mode with 'Desired reference clock frequency' less than 50MHz."
	    }
	 }

     if { $gui_fpll_mode == 1 || $gui_enable_fractional } {
 	## Valid are only "low" "medium"
	 if { $gui_bw_sel == "high" } {
 	    ip_message error "Bandwidth setting \"high\" is invalid, valid values are low, medium"
	 } 
     } else {
	 if { $gui_fpll_mode == 2} {
	     ## If ATX to FPLL cascade is enabled then set it to Medium and high and give error if low is selected
	     if {$gui_hssi_prot_mode == 4 || $gui_hssi_prot_mode == 5} {
		 if { $gui_bw_sel == "low" } {
 		    ip_message error "Bandwidth setting \"low\" is invalid, valid values are medium, high"
 		}
 	    }
	} 
	if { $gui_hssi_prot_mode == 5 || $gui_hssi_prot_mode == 8 } {
		 if { $gui_bw_sel != "high" } {
 		    ip_message error "Bandwidth setting must be \"high\" for OTN_direct prot_mode"
         }
    }
    }
 }

# +-----------------------------------
# | This function sets compensation_mode parameter  
# |
proc ::altera_xcvr_fpll_vi::parameters::update_cmu_fpll_pll_bw_mode { temp_bw_sel } {
   if {$temp_bw_sel == "low"} {
        ip_set "parameter.cmu_fpll_pll_bw_mode.value" "low_bw"	
   } elseif {$temp_bw_sel == "medium"} {
        ip_set "parameter.cmu_fpll_pll_bw_mode.value" "mid_bw"	
   } else { 
        ip_set "parameter.cmu_fpll_pll_bw_mode.value" "hi_bw"
   }   
} 


proc ::altera_xcvr_fpll_vi::parameters::validate_device_revision { base_device } {  
  set temp_device_revision [nf_cmu_fpll::parameters::get_base_device_user_string $base_device]
  if {$temp_device_revision != "NOVAL"} {
	ip_set "parameter.device_revision.value" $temp_device_revision
      
  } else {
	set device [ip_get parameter.DEVICE.value]
	ip_message error "The current selected device \"$device\" is invalid, please select a valid device to generate the IP."
  }
}

#convert units in base (10^0) to mega (10^6) 
proc ::altera_xcvr_fpll_vi::parameters::base_to_mega { val } { 
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $val "" temp
  set temp [expr {wide(double($temp) / 1000000)}]
  return $temp
}

#convert units in mega (10^6) to base
proc ::altera_xcvr_fpll_vi::parameters::validate_cmu_fpll_vco_freq_hz { vco_frequency } { 
#  ip_message info "IN: vco_frequency: '$vco_frequency'"
  #replace anything not a number or DOT character (to account for doubles)
  regsub -nocase -all {\m(\D)} $vco_frequency "" temp
#  ip_message info "MID: temp: '$temp'"
  set temp [expr {wide(double($temp) * 1000000)}]
#  ip_message info "POST: temp: '$temp'"
  ip_set "parameter.cmu_fpll_vco_freq_hz.value" "$temp"
}

proc ::altera_xcvr_fpll_vi::parameters::validate_cas_out_enable { gui_enable_cascade_out } {
   if { $gui_enable_cascade_out } {
      ip_set "parameter.cmu_fpll_fpll_cas_out_enable.value" "fpll_cas_out_enable"	
   } else {
      ip_set "parameter.cmu_fpll_fpll_cas_out_enable.value" "fpll_cas_out_disable"	
   }
}

proc ::altera_xcvr_fpll_vi::parameters::update_pll_self_reset { gui_self_reset_enabled } {
   if {$gui_self_reset_enabled == "true"} {
      ip_set "parameter.cmu_fpll_pll_self_reset.value" "true"
   } else {
      ip_set "parameter.cmu_fpll_pll_self_reset.value" "false"
   }
}


##############################################################################################################################################
#
# These numbers are pulled from the top of the file: p4/quartus/icd_data/nightfury/common/pm_cmu_fpll/bcmrbc/pm_cmu_fpll_atom.advanced.rbc.sv
#
# `define f_max_pfd_value 36'd800000000
# `define f_max_pfd_bonded_value 36'd600000000
# `define f_max_pfd_fractional_value 36'd400000000
#
# ** Do not make changes here without having the same limit change in the RBC file. **
#
##############################################################################################################################################

proc ::altera_xcvr_fpll_vi::parameters::get_local_f_max_pfd { device_revision compensation_mode gui_enable_fractional primary_use temp_bw_sel gui_is_downstream_cascaded_pll } {
   variable debug_message 
   if {$debug_message} {
      puts "============================================"
      puts $device_revision
   }
   if { $gui_is_downstream_cascaded_pll } {
      set f_max_pfd 60000000
   } else {
      if { $temp_bw_sel == "high" } {
          if { $gui_enable_fractional } {
             set f_max_pfd 400000000
          } else {
             if [expr { (($primary_use == "tx") && ($compensation_mode == "fpll_bonding")) }] {
                 set f_max_pfd 600000000
             } else {
                 set f_max_pfd 800000000
             }
         }
      } elseif { $temp_bw_sel == "medium" } {
         set f_max_pfd 350000000
      } else {
         set f_max_pfd 160000000
      }
   }

   return $f_max_pfd
}

#
##############################################################################################################################################

proc ::altera_xcvr_fpll_vi::parameters::validate_support_mode { PROP_NAME PROP_VALUE } {
  if {$PROP_VALUE == "engineering_mode"} {
    ip_message warning "Engineering support mode has been selected. Engineering mode is for internal use only. Intel does not officially support or guarantee IP configurations for this mode."
  }
}
#convert range lists to standard TCL lists
proc ::altera_xcvr_fpll_vi::parameters::scrub_list_values { my_list } {
  set new_list {}
  set my_list_len [llength $my_list]
  for {set list_index 0} {$list_index < $my_list_len} { incr list_index } {
    set this_value [lindex $my_list $list_index]
    if [ regexp {:} $this_value ] then {
      regsub -all ":" $this_value " " temp_list
      set start_value [lindex $temp_list 0]
      set end_value [lindex $temp_list 1]
      for {set index $start_value} {$index <= $end_value} { incr index } {
        lappend new_list $index
      }
    } else {
      lappend new_list $this_value
    }
  }
  return $new_list
}
proc ::altera_xcvr_fpll_vi::parameters::update_gui_hssi_calc_output_clock_frequency { \
    gui_enable_manual_hssi_counters \
    full_actual_refclk_frequency \
    gui_pll_set_hssi_m_counter \
    gui_pll_set_hssi_n_counter \
    gui_pll_set_hssi_l_counter \
    gui_pll_set_hssi_k_counter \
    gui_enable_fractional \
    cmu_fpll_m_counter \
    cmu_fpll_n_counter \
    cmu_fpll_l_counter \
    enable_cascade_in \
} {
    variable debug_message 

    ### FB case 249378 - Set Fmin of HSSI PLL IP to be 500 Mhz - put output_clock_frequency limit as 500 Mhz, give error if frequency is > 500 MHz
    ### Set fmax limit as 6250 Mhz
    set fmin 499.999
    set fmax 6250.0
    if { $enable_cascade_in } {
        set fmax 7075.0
    }

    if {$debug_message} {
       puts "=====================WJ========================"
       puts cmu_fpll_m_counter
       puts $cmu_fpll_m_counter
    }
      set allowed_m [ip_get "parameter.cmu_fpll_m_counter.ALLOWED_RANGES"] 

    if {$debug_message} {
        puts "allowed_m"
        puts $allowed_m
    }


  if { $gui_enable_manual_hssi_counters } { 

      # TODO Obtain correct counter ranges from RBC rules (Chris to give massaged RBCs)
      set allowed_m [ip_get "parameter.cmu_fpll_m_counter.ALLOWED_RANGES"] 
      #puts "full_actual_refclk_freq = $full_actual_refclk_frequency\n"
      #puts "gui_pll_set_hssi_m_counter = $gui_pll_set_hssi_m_counter\n"
      #puts "gui_pll_set_hssi_n_counter = $gui_pll_set_hssi_n_counter\n"
      #puts "gui_pll_set_hssi_l_counter = $gui_pll_set_hssi_l_counter\n"


#      ip_set "parameter.gui_pll_set_hssi_m_counter.ALLOWED_RANGES" [scrub_list_values [ip_get "parameter.cmu_fpll_m_counter.ALLOWED_RANGES"]]
#      ip_set "parameter.gui_pll_set_hssi_n_counter.ALLOWED_RANGES" [scrub_list_values [ip_get "parameter.cmu_fpll_n_counter.ALLOWED_RANGES"]]
#      ip_set "parameter.gui_pll_set_hssi_l_counter.ALLOWED_RANGES" [scrub_list_values [ip_get "parameter.cmu_fpll_l_counter.ALLOWED_RANGES"]]
      # TODO Validation for set k counter

      if { $gui_enable_fractional } {
	  ### Following values from RBC
	  set m_counter_list [::altera_xcvr_fpll_vi::parameters::convert_to_list 11 123]
	  set n_counter_list [::altera_xcvr_fpll_vi::parameters::convert_to_list 1 31]	  
	  set l_counter_list [list 1 2 4 8]	  
	  ip_set "parameter.gui_pll_set_hssi_m_counter.ALLOWED_RANGES" $m_counter_list
	  ip_set "parameter.gui_pll_set_hssi_n_counter.ALLOWED_RANGES" $n_counter_list
	  ip_set "parameter.gui_pll_set_hssi_l_counter.ALLOWED_RANGES" $l_counter_list
	  
          # TODO Equation for fractional mode output frequency ?
          set out_freq [expr {($full_actual_refclk_frequency * $gui_pll_set_hssi_m_counter) / ($gui_pll_set_hssi_n_counter * $gui_pll_set_hssi_l_counter)}]
	  set mout_freq [format "%0.6f" $out_freq]
          ip_set "parameter.gui_hssi_calc_output_clock_frequency.value" $out_freq
	  if {$out_freq < $fmin} {
	      ip_message error "Error validating hssi output clock frequency. Output clock frequency needs to be equal to or greater than 500 Mhz. Please enter a valid frequency."
	  }
	  if {$out_freq > $fmax} {
	      ip_message error "Error validating hssi output clock frequency. Output clock frequency needs to be equal to or less than ${fmax} Mhz. Please enter a valid frequency"
	  }
      } else {
	  set m_counter_list [::altera_xcvr_fpll_vi::parameters::convert_to_list 8 127]
	  set n_counter_list [::altera_xcvr_fpll_vi::parameters::convert_to_list 1 31]
	  set l_counter_list [list 1 2 4 8]	  
	  ip_set "parameter.gui_pll_set_hssi_m_counter.ALLOWED_RANGES" $m_counter_list
	  ip_set "parameter.gui_pll_set_hssi_n_counter.ALLOWED_RANGES" $n_counter_list
	  ip_set "parameter.gui_pll_set_hssi_l_counter.ALLOWED_RANGES" $l_counter_list
          set out_freq [expr {($full_actual_refclk_frequency * $gui_pll_set_hssi_m_counter) / ($gui_pll_set_hssi_n_counter * $gui_pll_set_hssi_l_counter)}]
#	  puts "out_freq = $out_freq\n"
	  set mout_freq [format "%0.6f" $out_freq]
#	  puts "mout_freq = $mout_freq\n"	  
          ip_set "parameter.gui_hssi_calc_output_clock_frequency.value" $mout_freq
	  if {$mout_freq < $fmin} {
	      ip_message error "Error validating hssi output clock frequency. Output clock frequency needs to be equal to or greater than 500 Mhz. Please enter a valid frequency."
	  }
	  if {$mout_freq > $fmax} {
	      ip_message error "Error validating hssi output clock frequency. Output clock frequency needs to be equal to or less than ${fmax} Mhz. Please enter a valid frequency"
	  }
      }
  }
}



proc ::altera_xcvr_fpll_vi::parameters::validate_enable_sdi_rule_checks { gui_fpll_mode gui_hssi_prot_mode enable_cascade_in} {
    if { $gui_fpll_mode == 2 } { 
	if { $gui_hssi_prot_mode == 4 || $gui_hssi_prot_mode == 6} {
	    ip_set "parameter.cmu_fpll_is_sdi.value" "true"	    
	} else {
	    ip_set "parameter.cmu_fpll_is_sdi.value" "false"
	}
    } else {
	ip_set "parameter.cmu_fpll_is_sdi.value" "false"
    }
} 


proc ::altera_xcvr_fpll_vi::parameters::validate_enable_otn_rule_checks { gui_fpll_mode gui_hssi_prot_mode enable_cascade_in} {
    if { $gui_fpll_mode == 2  && ($gui_hssi_prot_mode == 5 || $gui_hssi_prot_mode == 8) } {
	ip_set "parameter.cmu_fpll_is_otn.value" "true"  
    } else {
	ip_set "parameter.cmu_fpll_is_otn.value" "false"
    }
}   

proc ::altera_xcvr_fpll_vi::parameters::validate_side { gui_enable_low_f_support gui_hssi_prot_mode gui_desired_refclk_frequency } {
  if { $gui_hssi_prot_mode == 9 && $gui_enable_low_f_support } {
	    ip_message error "Invalid selection. You can't enable expanded reference clock range and select SATA Gen3 protocol mode."		
  } else {
      if { $gui_hssi_prot_mode == 9 } {
            ip_set "parameter.cmu_fpll_side.value" "right" 
        } elseif { $gui_enable_low_f_support && $gui_desired_refclk_frequency < 50 } {
	        ip_set "parameter.cmu_fpll_side.value" "left"  
        } else {
	        ip_set "parameter.cmu_fpll_side.value" "side_unknown"
        }
    }  
}

proc ::altera_xcvr_fpll_vi::parameters::validate_is_downstream_cascaded_pll { gui_is_downstream_cascaded_pll } {
    if { $gui_is_downstream_cascaded_pll } {
	ip_set "parameter.cmu_fpll_top_or_bottom.value" "bot"  
    } else {
	ip_set "parameter.cmu_fpll_top_or_bottom.value" "tb_unknown"  
    }
}

proc ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_low_f_support  { gui_hssi_prot_mode } {
    if { $gui_hssi_prot_mode == 10 } {
	ip_set "parameter.gui_enable_low_f_support.value" "true"  
    } else {
	ip_set "parameter.gui_enable_low_f_support.value" "false"  
    }
}


proc ::altera_xcvr_fpll_vi::parameters::does_this_device_is_es { device_revision } {
### ES and ES2 devices don't have cascade support, device_revision for ES is 20nmES and for ES2 20nm5ES2
#    puts "DEVICE=$device_revision\n"
    set es_device [regexp -nocase {^[a-zA-Z0-9]+ES} $device_revision']    
    if { $es_device} {
	return "true"
    } else {
	return "false"
    }
}


proc ::altera_xcvr_fpll_vi::parameters::convert_to_list { firstval endval } {
    set newlist {}
    
    for {set i $firstval} {$i <= $endval} {incr i} {
	lappend newlist $i
   }
#   puts "newlist = $newlist\n"
   return $newlist
    
}

proc ::altera_xcvr_fpll_vi::parameters::update_manual_config { gui_enable_manual_hssi_counters gui_enable_fractional} {
  # TODO Do these RBC calls return automatic counter ranges appropriate for fractional and integer modes ?
  if { $gui_enable_manual_hssi_counters } { 
      set allowed_m [ip_get "parameter.cmu_fpll_m_counter.ALLOWED_RANGES"] 
      if { $gui_enable_fractional } {
	  ### Following values from RBC
	  set m_counter_list [::altera_xcvr_fpl<l_vi::parameters::convert_to_list 11 123]
	  set n_counter_list [::altera_xcvr_fpll_vi::parameters::convert_to_list 1 31]	  
	  set l_counter_list [list 1 2 4 8]	  
	  ip_set "parameter.gui_pll_set_hssi_m_counter.ALLOWED_RANGES" $m_counter_list
	  ip_set "parameter.gui_pll_set_hssi_n_counter.ALLOWED_RANGES" $n_counter_list
	  ip_set "parameter.gui_pll_set_hssi_l_counter.ALLOWED_RANGES" $l_counter_list
      } else {
	  set m_counter_list [::altera_xcvr_fpll_vi::parameters::convert_to_list 8 127]
	  set n_counter_list [::altera_xcvr_fpll_vi::parameters::convert_to_list 1 31]
	  set l_counter_list [list 1 2 4 8]	  
	  ip_set "parameter.gui_pll_set_hssi_m_counter.ALLOWED_RANGES" $m_counter_list
	  ip_set "parameter.gui_pll_set_hssi_n_counter.ALLOWED_RANGES" $n_counter_list
	  ip_set "parameter.gui_pll_set_hssi_l_counter.ALLOWED_RANGES" $l_counter_list
      }
  }

}

proc ::altera_xcvr_fpll_vi::parameters::validate_gui_enable_fractional { } {
	ip_message info "The output frequencies are not exact when the PLL is in fractional mode. You must be cautious with applications that require frequencies to be exact to within less than 0.5 Hz."
}

proc ::altera_xcvr_fpll_vi::parameters::validate_gui_desired_refclk_frequency { gui_fpll_mode gui_desired_refclk_frequency gui_enable_low_f_support gui_hssi_prot_mode } {
    if { $gui_enable_low_f_support } { 
    	set fmin 25.0
    } else {
    	set fmin 50.0
    }
    set fmax 800.0
    if {$gui_fpll_mode == 2} { 
      if { $gui_hssi_prot_mode == 9 } {
	      if { $gui_desired_refclk_frequency != 150 } { 
		   ip_message error "When used as as a transceiver in SATA GEN 3 mode, Desired reference clock frequency must be set to 150 MHz"
	      }
       } else {
	       if {$gui_desired_refclk_frequency < $fmin || $gui_desired_refclk_frequency > $fmax} {
	        ip_message error "Error validating hssi reference clock frequency. Legal range is $fmin MHz - $fmax MHz. Please enter a valid frequency."		
  	       }
       }
    }
}

#******************** C10 restructions procs ***************
proc ::altera_xcvr_fpll_vi::parameters::validate_c10 { device_family } {
   if { $device_family == "Cyclone 10 GX" } {
      ip_set "parameter.is_c10.value" 1
   } else {
      ip_set "parameter.is_c10.value" 0
   }
}
proc ::altera_xcvr_fpll_vi::parameters::validate_gui_hssi_prot_mode { is_c10 } {
   if {$is_c10 == 1} {
      ip_set "parameter.gui_hssi_prot_mode.ALLOWED_RANGES" { "0:Basic" "1:PCIe Gen 1" "2:PCIe Gen 2" "6:SDI_direct" "7:SATA TX" }
   } else {
      ip_set "parameter.gui_hssi_prot_mode.ALLOWED_RANGES" { "0:Basic" "1:PCIe Gen 1" "2:PCIe Gen 2" "3:PCIe Gen 3" "4:SDI_cascade" "5:OTN_cascade" "6:SDI_direct" "7:SATA TX" "8:OTN_direct" "9:SATA GEN3" "10:HDMI" }
   }
}
