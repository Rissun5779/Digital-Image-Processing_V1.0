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


# (C) 2001-2010 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | 
# | altera_pll v14.0
# | 
# +-----------------------------------

# +============================================================================================================
# | REQUEST TCL PACKAGES AND SOURCE FILES

proc my_local_get_quartus_bindir {} {
    # Get Quartus bindir

    set QUARTUS_ROOTDIR $::env(QUARTUS_ROOTDIR)
    set PLATFORM $::tcl_platform(platform)
    if { $PLATFORM == "java" } {
        set PLATFORM $::tcl_platform(host_platform)
    }

    if { [catch {set QUARTUS_BINDIR $::quartus(binpath)} errmsg] } {
        if { $PLATFORM == "windows" } {
            set BINDIRNAME "bin"
        } else {
            set BINDIRNAME "linux"
        }

        # Only the native tcl interpreter has 'tcl_platform(pointerSize)'
        # In Jacl however 'tcl_platform(machine)' is set to the JVM bitness, not the OS bitness
        if { [catch {set POINTERSIZE $::tcl_platform(pointerSize)} errmsg] } {
            if {[string match "*64" $::tcl_platform(machine)]} {
                set POINTERSIZE 8
            } else {
                set POINTERSIZE 4
            }
        }
        if { $POINTERSIZE == 8 } {
            set BINDIRNAME "${BINDIRNAME}64"
        }
        set QUARTUS_BINDIR "$QUARTUS_ROOTDIR/$BINDIRNAME"
    }
	return $QUARTUS_BINDIR
}

# QSYS version 14.0
package require -exact qsys 14.0

# The computation engine
package require ::altera::pll_legality

# TCL commands
package require Itcl

# PLL and Reconfig TCL libraries
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_iopll/tclpackages.tcl
package require altera_iopll::util 14.0
package require altera_iopll::update_callbacks 14.0
package require altera_iopll_reconfig::mif_validation 14.0

# IPCC functions (used during SDC gen)
source $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/altera_avalon_mega_common/ipcc_wrap_split.tcl

set QUARTUS_BINDIR [my_local_get_quartus_bindir]
source [file join $QUARTUS_BINDIR .. common tcl packages pll pll_legality.tcl]
package require ::quartus::pll::legality


# +============================================================================================================
# | MODULE SETTINGS

namespace eval altera_iopll::module {
	set module_params {\
		{NAME                                           VERSION       \
        INTERNAL                                        SUPPORTED_DEVICE_FAMILIES \
        GROUP                                           AUTHOR	\
  		DISPLAY_NAME	                                DESCRIPTION	\
  		DATASHEET_URL                                   EDITABLE	\
        ELABORATION_CALLBACK                        	VALIDATION_CALLBACK	\
       	PARAMETER_UPGRADE_CALLBACK                    	UPGRADEABLE_FROM }\
		{altera_iopll                                	18.1 \
 		false	                                     	{"ARRIA 10" "STRATIX 10"} \
    	"Basic Functions/Clocks; PLLs and Resets/PLL"	"Intel Corporation" \
       	"IOPLL Intel FPGA IP"                              	"Intel Phase-Locked Loop" \
    	"http://www.altera.com/literature/ug/ug_altera_iopll.pdf"	true	\
     	elaboration_callback	                        validation_callback \
     	parameter_upgrade_callback \
       	{altera_pll 13.1 "Arria 10"  altera_pll 14.0 "Arria 10"  altera_pll 12.0 "Stratix V" \
         altera_pll 12.1 "Stratix V" altera_pll 13.0 "Stratix V" altera_pll 13.1 "Stratix V" \
         altera_pll 14.0 "Stratix V" altera_pll 12.0 "Arria V"   altera_pll 12.1 "Arria V" \
         altera_pll 13.0 "Arria V"   altera_pll 13.1 "Arria V"   altera_pll 14.0 "Arria V" \
         altera_pll 12.0 "Cyclone V" altera_pll 12.1 "Cyclone V" altera_pll 13.0 "Cyclone V" \
         altera_pll 13.1 "Cyclone V" altera_pll 14.0 "Cyclone V"} }\
	}

	set file_sets {\
		{NAME			TYPE			CALLBACK_FUNCTION				} \
		{sim_vhdl		SIM_VHDL		generate_vhdl_sim				} \
		{sim_verilog	SIM_VERILOG		generate_verilog_sim			} \
		{quartus_synth	QUARTUS_SYNTH	generate_synth					} \
	}

	proc declare_module {} {
		variable module_params
		::altera_iopll::util::declare_hwtcl_module $module_params
	}
	
	proc declare_filesets {} {
		variable file_sets
		::altera_iopll::util::declare_hwtcl_filesets $file_sets	
	}
}

# |============================================================================================================
# | GUI VISIBLE PARAMETERS
# | 
# | All visible controls in the gui live here.
# | 
namespace eval altera_pll_gui_params {
	
	# +-----------------------------------
	# | DISPLAY ITEMS
	set pll_tab_display_items { \
		{NAME							INSTANCES	PARENT						TYPE    ADDITIONALINFO	DISPLAY_HINT } \
		{"PLL"							""			""							GROUP	tab             TAB     } \
		{"Device"						""			"PLL"						GROUP	""              false   } \
		{"General"						""			"PLL"						GROUP	""	            false	} \
		{"Compensation"					""			"PLL"						GROUP	""	            false	} \
		{"Compensation"					""			"PLL"						GROUP	""	            false	} \
        {"direct_warning"   		   	""			"Compensation"	   	        TEXT \
            	"<html><b>Direct mode</b> is suitable for most applications. It provides the best jitter \
                performance and avoids expending compensation clocking resources unnecessarily.<br>" \
                false } \
		{"normal_warning"				""		    "Compensation"		   	    TEXT \
             	"<html><b>Normal mode</b> compensates for the delay of the internal clock network used
                by the clock output. If this is not necessary, consider using direct mode.<br>" \
                false  } \
		{"external_warning"				""			"Compensation"		   	    TEXT \
            	"<html><b>External mode </b>compensates for the delay between fbclk and fboutclk ports, \
                which must be connected at the board level. If this is not necessary, consider using \
                direct mode.<br>" \
                false } \
		{"ss_warning"					""			"Compensation"				TEXT  \
                "<html><b>Source Synchronous </b>mode ensures that the clock delay and data delay from \
                pin to I/O input register are equal. If this is not necessary, consider using direct \
                mode.<br>" \
                false } \
		{"zdb_warning"					""			"Compensation"				TEXT \
            	"<html>In <b>ZDB mode</b>, the IOPLL drives an external output pin, zdbfbclk, and \
                compensates for the delay introduced by that pin. If this is not necessary, consider \
                using direct mode.<br>" \
                false } \
    	{"lvds_warning"					""			"Compensation"				TEXT \
             	"<html><b>LVDS mode</b> ensures that the same data and clock timing relationship is \
                maintained at the pins of the internal SERDES capture register. If the IOPLL does not \
                connect to an LVDS, consider using direct mode.<br>" \
                false } \
		{"NDFB_warning"					""			"Compensation"				TEXT \
            	"<html>Compensation modes that use<b> nondedicated feedback </b>conserve clock resources \
                and have timing analysis benefits, but they create phase shift and frequency limitations.\
                If compensation is not necessary, consider using direct mode.<br>"\
                false } \
		{"Output Clocks"				""			"PLL"						GROUP	""	false   } \
		{"NDFB_phase_warning"			""		    "outclk0"				    TEXT \
             	"Outclk0 phase shifts are not possible in this compensation mode" \
                false } \
		{"outclk#"						0-17		"Output Clocks"				GROUP	""	false   } \
        {"Nearest Legal Values #"        0-17        "outclk#"                   GROUP    \
                "These are the nearest legal values that can be implemented, given the current PLL \
                parameters. The generated RTL will use the legal value closest to your desired value." \
                COLLAPSED } \
	
    }
    
    set pll_tab_info_and_warnings { \
		{NAME						    	INSTANCES	PARENT						TYPE	ADDITIONALINFO	} \
		{"LVDS_port_instruction0"	    	""			"outclk0"				    TEXT \
         	"<html>Configuration for <b>LVDS Fast Clock</b> (lvds_clk[0])<br>"			                	} \
		{"LVDS_port_instruction1"	    	""			"outclk1"				    TEXT \
             "<html>Configuration for <b>LVDS Load Enable</b> (loaden[0])<br>"			                   	} \
		{"LVDS_port_instruction2a"	    	""			"outclk2"				    TEXT \
         	"<html>Configuration for <b>LVDS Core Clock</b><br>"				                        	} \
		{"LVDS_port_instruction2b"	    	""			"outclk2"				    TEXT \
             "<html>Configuration for <b>LVDS Fast Clock</b> (lvds_clk[1])<br>"			                	} \
		{"LVDS_port_instruction3"	    	""			"outclk3"				    TEXT \
             "<html>Configuration for <b>LVDS Load Enable</b> (loaden[1])<br>"			                 	} \
		{"LVDS_port_instruction4"	    	""			"outclk4"				    TEXT \
             "<html>Configuration for <b>LVDS Core Clock</b><br>"				                        	} \
		{"clock_to_compensate_message0"		""			"outclk0"				    TEXT \
             "Compensation applies to this outclk "				                                        	} \
		{"clock_to_compensate_message1"		""			"outclk1"				    TEXT \
             "Compensation applies to this outclk "				                                        	} \
		{"clock_to_compensate_message2"		""			"outclk2"				    TEXT \
             "Compensation applies to this outclk "				                                          	} \
		{"clock_to_compensate_message3"		""			"outclk3"				    TEXT \
             "Compensation applies to this outclk "				                                        	} \
		{"clock_to_compensate_message4"		""			"outclk4"				    TEXT \
             "Compensation applies to this outclk "				                                        	} \
		{"clock_to_compensate_message5"		""			"outclk5"				    TEXT \
             "Compensation applies to this outclk "				                                          	} \
		{"clock_to_compensate_message6"		""			"outclk6"				    TEXT \
             "Compensation applies to this outclk "			                                        		} \
		{"clock_to_compensate_message7"		""			"outclk7"				    TEXT \
             "Compensation applies to this outclk "				                                        	} \
		{"clock_to_compensate_message8"		""			"outclk8"				    TEXT \
             "Compensation applies to this outclk "				                                          	} \
		{"Bootstrap_counter_7_disabled"		""	  	"outclk7"				        TEXT \
             "Outclk7 cannot be used with Auto Reset enabled."	    	                                	} \
	}

	# +-----------------------------------
	# | SETTINGS TAB
	set settings_tab_display_items { \
		{NAME							INSTANCES	PARENT						TYPE	ADDITIONALINFO	} \
		{"Settings"						""			""							GROUP	tab			  	} \
		\
		{"Physical PLL Settings"		""			"Settings"					GROUP	""				} \
		{"Clock Switchover"				""			"Settings"					GROUP	""				} \
		\
		{"Clock Switchover Ports"		""			"Clock Switchover"			GROUP	""				} \
		{"Input Clock Switchover Mode"	""			"Clock Switchover"			GROUP	""				} \
		\
		{"LVDS External PLL"			""			"Settings"					GROUP	""				} \
       	{"External Clock Output"		""	    	"Settings"			    	GROUP	""				} \
	}
	
	# +-----------------------------------
	# | CASCADING TAB
	set cascading_tab_display_items { \
		{NAME							INSTANCES	PARENT						TYPE	ADDITIONALINFO	} \
		{"Cascading"					""			""							GROUP	tab         	} \
		{"PLL-to-PLL Cascading"			""			"Cascading"					GROUP	""				} \
        {"Cascading Explanation0"	  	""      	"PLL-to-PLL Cascading"	   	TEXT \
         	"Cascading can be done in one of two ways:"                                                 } \
        {"Cascading Explanation1"	   	""      	"PLL-to-PLL Cascading"	   	TEXT \
        	"<html>     1) <b>Core Clock Network Cascading</b>: Connect the outclk and refclk signals \
             of two PLLs<br>"                                                                           } \
        {"Cascading Explanation2"	  	""      	"PLL-to-PLL Cascading"	   	TEXT \
         	"<html>     2) <b>IO Column Cascading</b>: Connect the cascade_out and adjpllin signals \
            of two IOPLLs<br>"                                                                          } \
		{"PLL Use As Upstream PLL"		""			"PLL-to-PLL Cascading"		GROUP	""				} \
		{"PLL Use As Downstream PLL"	""			"PLL-to-PLL Cascading"		GROUP	""				} \
		{"Output Counter Cascading"		""			"Cascading"					GROUP	""				} \
	}

	# +-----------------------------------
	# | RECONFIG TAB
	set reconfig_tab_display_items { \
		{NAME							INSTANCES	PARENT						TYPE	ADDITIONALINFO	} \
		{"Dynamic Reconfiguration"		""			""							GROUP	tab			  	} \
		{"MIF Streaming"				""			"Dynamic Reconfiguration"	GROUP	""				} \
		{"Dynamic Phase Shift (MIF)"	""			"MIF Streaming"				GROUP 	""				} \
		{"MIF_file_info"				""			"MIF Streaming"				TEXT \
            	"<html>In order to dynamically reconfigure the IOPLL via MIF streaming, a .mif file \
                containing one or more legal IOPLL configurations must be provided to the \
                altera_iopll_reconfig IP.<br>"                                                          } \
    } 
	
	# +-----------------------------------
	# | ADVANCED PARAMETERS TAB
	set adv_params_tab_display_items { \
		{NAME							INSTANCES	PARENT						TYPE	ADDITIONALINFO	} \
		{"Advanced Parameters"			""			""							GROUP	tab			  	} \
	}

	# +-----------------------------------
	# | TABLES
	set tables {\
		{NAME						PARENT				    	TYPE		ADDITIONALINFO	DISPLAY_HINT } \
		{"parameterTable"			"Advanced Parameters"	    GROUP		TABLE	\
                                                                           "table fixed_size rows:30"	} \
		{"mifTable"			        "Dynamic Reconfiguration"	GROUP		TABLE	\
                                                                           "table fixed_size rows:10"	} \
	}
    
	set table_columns { \
		{NAME				    PARENT		    TYPE			 DISPLAY_NAME          DERIVED \
                    		    DISPLAY_HINT    DESCRIPTION                                           } \
		{parameterTable_names   parameterTable  STRING_LIST	 "Parameter Names"         true	\
                        	    "width:200"	    "Shows the list of advanced PLL parameters"           } \
		{parameterTable_values  parameterTable	STRING_LIST	 "Parameter Values"        true	\
                        	    "width:200"  "Shows the list of values of the advanced PLL parameters"} \
		{mifTable_names         mifTable	    STRING_LIST	 "MIF File Property"        true	\
                        	    "width:300"  "Shows the list of MIF file properties" } \
		{mifTable_values        mifTable	    STRING_LIST	 "Values"                   true	\
                        	    "width:200"  "Shows the list of MIF file values "} \
	}

	set reconfig_tab_buttons { \
		{NAME							INSTANCES	PARENT						TYPE	ADDITIONALINFO	} \
		{"Create MIF File"	  	     	""			"MIF Streaming"				ACTION \
            	create_new_mif_file                                                                     } \
		{"Append to MIF File"	       	""			"MIF Streaming"				ACTION \
            	append_to_mif_file                                                                      } \
	}
	
	# |-----------------------------------
	# | SYSTEM_INFO parameters (non-visible)
	set system_info_parameters {\
		{NAME						   	  TYPE    DISPLAY_GROUP	 VISIBLE  DISPLAY_NAME	  SYSTEM_INFO	    } \
		{"system_info_device_family"   	  STRING  ""			 false	  "Device Family" DEVICE_FAMILY	    } \
		{"system_info_device_component"	  STRING  ""			 false	  "Component"	  DEVICE			} \
		{"system_info_device_speed_grade" STRING  ""			 false	  "Speed Grade"	  DEVICE_SPEEDGRADE } \
	}

	set system_part_trait_parameters {\
		{NAME				         	  TYPE	           DISPLAY_GROUP	 VISIBLE  DISPLAY_NAME	\
                                     	  SYSTEM_INFO_TYPE SYSTEM_INFO_ARG                                 } \
		{"system_part_trait_speed_grade"  STRING           ""			     false	  "Speed Grade Trait" \
                                     	  PART_TRAIT	   DEVICE_SPEEDGRADE } \
	}
		
	set gui_system_info_parameters {\
		{NAME					  INSTANCES      TYPE	         DISPLAY_GROUP	 DISPLAY_NAME \
                               	  VISIBLE        ENABLED		 DERIVED  \
                             	  DEFAULT_VALUE	 ALLOWED_RANGES	 \
                                  VALIDATION_CALLBACK } \
		{gui_device_family		  ""             STRING   	     "Device"        "Device Family" \
                              	  true           false		     true \
                         	      ""			 ""		      	 NOVAL } \
		{gui_device_component	  ""             STRING	         "Device"		 "Component" \
                      			  true           false		     true \
          	                      ""		 	 ""	   	         NOVAL  } \
		{gui_device_speed_grade	  ""             INTEGER	     "Device"		 "Speed Grade" \
                              	  true           true		     true  \
                                  1  			 ""				 ""                        } \
	}
	

	# |-----------------------------------
	# | DEBUG PARAMS : Misc non-visible gui parameters
    set gui_invis_parameters {\
		{NAME					       TYPE	DISPLAY_GROUP  DISPLAY_NAME	 VISIBLE	ENABLED	 DERIVED \
       	                               DEFAULT_VALUE	             ALLOWED_RANGES	} \
		{gui_debug_mode			       BOOLEAN	""		    ""		      false	    true	 false \
	                                   false		                 ""	 } \
        {gui_include_iossm 	           BOOLEAN	""		    ""		      false	    true	 false	\
                                       false		                 ""	 } \
        {gui_cal_code_hex_file         STRING	""		    ""		      false	    true	 false	\
                                       "iossm.hex"		         ""	 } \
        {gui_parameter_table_hex_file  STRING	""		    ""		      false	    true	 false	\
                                       "seq_params_sim.hex"		     ""	 } \
		{gui_pll_tclk_mux_en  		   BOOLEAN	""		    ""		      false	    true	 false	\
                                       false		                 ""	 } \
		{gui_pll_tclk_sel     		   STRING	""		    ""		      false	    true	 false	\
                                       "pll_tclk_m_src"		         ""	 } \
		{gui_pll_vco_freq_band_0       STRING	""		    ""		      false	    true	 false	\
                                       "pll_freq_clk0_disabled"		         ""	 } \
		{gui_pll_vco_freq_band_1       STRING	""		    ""		      false	    true	 false	\
                                       "pll_freq_clk1_disabled"		         ""	 } \
		{gui_pll_freqcal_en            BOOLEAN	""		    ""		      false	    true	 false	\
                                       true		                 ""	 } \
		{gui_pll_freqcal_req_flag      BOOLEAN	""		    ""		      false	    true	 false	\
                                       true		                 ""	 } \
		{gui_cal_converge              BOOLEAN	""		    ""		      false	    true	 false	\
                                       false		                 ""	 } \
		{gui_cal_error                 STRING	""		    ""		      false	    true	 false	\
                                       "cal_clean"		             ""	 } \
		{gui_pll_cal_done              BOOLEAN	""		    ""		      false	    true	 false	\
                                       false		                 ""	 } \
        {gui_pll_type     			   STRING	""		    ""		      false	    true	 false	\
                                       "S10_Simple"		             ""	 } \
		{gui_pll_m_cnt_in_src     	   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src0     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src1     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src2     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src3     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src4     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src5     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src6     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src7     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
		{gui_c_cnt_in_src8     		   STRING	""		    ""		      false	    true	 false	\
                                       "c_m_cnt_in_src_ph_mux_clk"	 ""	 } \
    }

    # +-----------------------------------
	# | PLL TAB GUI PARAMS
	set gui_parameters {\
		{NAME				    INSTANCES		                                  TYPE  \
    	                        VALIDATION_CALLBACK	                              DISPLAY_GROUP \
                                DISPLAY_NAME                                      DEFAULT_VALUE \
           			            ALLOWED_RANGES	                                  UNITS \
                                DISPLAY_UNITS 	                                  DERIVED \
                                DESCRIPTION                                       DISPLAY_HINT} \
		{"gui_usr_device_speed_grade"	    ""			      	                  STRING \
                                ::altera_iopll::update_callbacks::main_callback   "Device" \
                     		    "Speed Grade"			                          1 \
         					    {1 2 3}										      None \
                 			    ""				                                  false \
                         	    "Select the speed grade of the device."                                    	} \
		{"gui_en_reconf"	    ""			      	                              BOOLEAN \
                                NOVAL				   	                          "Dynamic Reconfiguration" \
                     		    "Enable dynamic reconfiguration of PLL"			  false \
         					    ""											      None \
                 			    ""				                                  false \
                         	    "Select this option to enable the dynamic reconfiguration of this IOPLL \
                                (in conjunction with Altera PLL Reconfig IP). \
                                Creates 'reconfig_from_pll' and 'reconfig_to_pll' ports, through which \
                                current M, N and C counter settings are read from the IOPLL, and new \
                                settings are written to the IOPLL."                                     	} \
		{"gui_en_dps_ports"     ""                                                BOOLEAN \
                                NOVAL                                             "Dynamic Reconfiguration"	\
	                            "Enable access to dynamic phase shift ports"      false \
             					""											   	  None	\
                           		""				                                  false \
        	                    "<html> Select this option to enable the dynamic phase shift interface \
                                with the IOPLL. Six new ports will be created. \
                                The values of <b>updn</b>, <b>num_phase_shift</b>, and <b>cntsel</b> \
                                determine whether the shift is positive or negative, the number of phase \
                                steps performed (one phase step is equal to 1/8 of the VCO period) and \
                                the counter to which a phase shift is applied. A phase shift will occur \
                                when <b>phase_en</b> is asserted. \
                                After phase_en is asserted, <b>phase_done</b> goes low to indicate \
                                that a dynamic phase shift is in progress. <br>   "                         } \
		{"gui_pll_mode"		   	""			                                      STRING \
                            	NOVAL							                  "General"	\
       					        "PLL Mode"										  "Integer-N PLL" \
    		                	{"Integer-N PLL"}		      None	\
                          		""				                                  false \
                                "For Arria 10 and Stratix 10, the only available mode is Integer-N PLL. \
                                Please use the Fractional PLL IP if you require   a fractional PLL."    	} \
		{"gui_reference_clock_frequency"		""				                  FLOAT \
                               ::altera_iopll::update_callbacks::main_callback  	"General" \
  						       "Reference Clock Frequency"					   	  100.0	\
                			   ""   		                                      "megahertz" \
                        	   MHz				                                  false \
                               "Specifies the frequency of the reference clock"                          	} \
		{"gui_fractional_cout" ""			                                  	  INTEGER \
                               NOVAL							                  "General"	\
        					   "Fractional carry out"					 		  32 \
 					           {8 16 24 32}								   		  None \
                     		   ""				                                  false \
         	                   "Setting not available for Arria 10 or Stratix 10, as there is a \
                               separate fpll IP. Specifies the fractional carry out for DSM mode. \
                               The fractional carry determines the denominator in the equation K/2^Fcout"	} \
		{"gui_dsm_out_sel"	   ""			                                  	  STRING \
                               NOVAL						                      "General"	\
          					   "DSM Order"							 		   	  "1st_order" \
			                   {"1st_order" "2nd_order" "3rd_order" "disable"}    None	\
                       		   ""			                                   	  false \
                               "Setting not available for Arria 10 or Stratix 10, as there is a separate \
                               fpll IP. Specifies the DSM order for shifting the fractional noise to \
                               high frequencies to be filtered out by the PLL"                              } \
		{"gui_use_locked"      ""		                                      	  BOOLEAN \
                               NOVAL						                	  "General"	\
      				           "Enable locked output port"				 		  true	\
              				   ""											      None \
                       		   ""				                                  false \
                           	   "Select this option to enable the 'locked' port. The locked signal \
                               goes high to indicate that the output frequencies of the IOPLL have \
                               converged to the desired values."                                        	} \
		{"gui_en_adv_params"   ""				                                  BOOLEAN \
                               ::altera_iopll::update_callbacks::main_callback      	  "General" \
        					   "Enable physical output clock parameters"	   	  false \
            				   ""											      None \
                    		   ""		                                 	      false \
                               "Select this option to enter the values of the IOPLL's M,N and C \
                                counters instead of specifying an output clock frequency. \
                                If this option is not selected, counter values will be calculated  \
                                automatically in order to achieve the desired frequency \
                                and are displayed in the 'Advanced Parameters' tab. "	} \
		{"gui_pll_bandwidth_preset"		""			                           	  STRING \
                            	NOVAL						                      "Physical PLL Settings" \
                   			    "PLL Bandwidth Preset"						 	  "Low"	\
                  				{"Low" "Medium" "High"}						      None \
                   			    ""				                                  false \
                             	"Specifies the PLL bandwidth preset setting."						    	} \
	    {"gui_lock_setting"	    ""			                                      STRING \
                             	""                                          	  "Physical PLL Settings" \
                    			"Lock Threshold Setting"						  "Low Lock Time" \
         				   {"Low Lock Time" "Medium Lock Time" "High Lock Time"}  None \
                     			""				                                  false \
                               	"This setting determines the sensitivity of the IOPLL when detecting \
                                lock. This is a tradeoff between the time it takes to lock \
                                and the accuracy of the outclk frequency when 'locked' is first asserted. \
                                For applications that require the IOPLL to lock quickly, 'Low Lock Time' \
                                is the best option. For applications that require a high degree of \
                                accuracy in the outclk frequency as soon as lock is asserted, \
                                'High Lock Time' is a better option. The estimated lock times are \
                                30us + a*refclk_period, where a is 100, 2048 and 4095 for \
                                'Low Lock Time', 'Medium Lock Time' and 'High Lock Time' respectively." 	} \
		{"gui_pll_auto_reset"  	""			                                 	  BOOLEAN \
 	                            NOVAL						                  	  "Physical PLL Settings" \
               			        "PLL Auto Reset"							      false	 \
                  				""											  	  None	\
                         		""				                                  false \
        	                    "With this option selected, the IOPLL will automatically reset after \
                                 a loss-of-lock condition. "                                            	} \
        {"gui_en_lvds_ports"  	""			                                      STRING \
                              	::altera_iopll::update_callbacks::main_callback   "LVDS External PLL" \
                 				"Access to PLL LVDS_CLK/LOADEN output port"		  "Disabled" \
               	{"Disabled" "Enable LVDS_CLK/LOADEN 0" "Enable LVDS_CLK/LOADEN 0 & 1"}     None	\
                         		""				                                  false \
                               	"This option enables the IOPLL's LVDS_CLK/LOADEN output ports.\
                                These ports are exported instead of outclks, and can be \
                                configured through the corresponding outclk settings (the outclks \
                                that correspond to LVDS ports are indicated in the 'Output Clocks' section).\
                                The LVDS_CLK and LOADEN ports can be connected to one or two LVDS."      	} \
		{"gui_operation_mode" 	""			                                      STRING \
                                ::altera_iopll::update_callbacks::main_callback    "Compensation" \
             					"Compensation Mode"							   	  "direct"	\
       	   	 {"direct" "external feedback" "normal" "source synchronous" "zero delay buffer" "lvds"} None \
                      			""				                                  false \
                               	"Specifies the desired feedback/compensation mode. Feedback modes \
                                compensate for clock network delays to align the IOPLL \
                                output's rising edge with the rising edge of the refclk. If no phase \
                                relationship is required between the refclk and the output clock,direct \
                                mode is recommended."   	                                                } \
		{"gui_feedback_clock"  	""			                                   	  STRING \
                            	""								                  "Compensation" \
             					"Feedback Clock"						     	  "Global Clock"	\
                			    {"Global Clock" "Regional Clock"}	              None   \
                                ""                                                false \
                            	"N/A"                                                                     	} \
		{"gui_clock_to_compensate"  	""			                              INTEGER \
                          	    ::altera_iopll::update_callbacks::main_callback 	"Compensation" \
                    		  	"Compensated Outclk"							  0	\
             			        {0}				                                  None  \
                                ""                                                false \
                               	"For Stratix 10 devices, compensation is only applied to one output \
                                clock. The feedback mode of the IOPLL will compensate \
                                for the clock network delays of the outclk selected. "                  	} \
		{"gui_use_NDFB_modes"   ""		                                     	  BOOLEAN \
                                ::altera_iopll::update_callbacks::main_callback    "Compensation" \
          					    "Use Nondedicated Feedback Path"				  false	\
              			        ""				                                  None  \
                                ""                                                false \
                              	"If this option is selected, the IOPLL will not use additional \
                                core clock resources in its feedback path."                              	} \
		{"gui_refclk_switch"   	""				                                  BOOLEAN \
                             	""								                  "Clock Switchover" \
               				    "Create a second input clock signal 'refclk1'"	  false	\
                  				""										    	  None	\
                        		""				                                  false \
        	                    "The clock switchover feature allows the PLL to switch between \
                                two reference input clocks. The extra input clock can act \
                                as a 'backup' reference clock for if the original refclk stops running. \
                                Please read clock switchover guidelines in the IOPLL documentation \
                                for more information on this feature and its limitations."	} \
		{"gui_refclk1_frequency"  ""			                                  FLOAT	\
                               ::altera_iopll::update_callbacks::main_callback  "Clock Switchover" \
                			   "Second Reference Clock Frequency"		   		  "100.0" \
             			       ""											      "megahertz" \
                        	   MHz				                                  false \
        	                   "Specifies the frequency of refclk1. Automatic Switchover requires \
                                for the two refclk frequencies to be within 20% of \
                                each other, but if Manual Switchover is selected, the difference \
                                can be more than 100%. It is recommended to try setting the \
                                Reference Clock Frequency to your Secondary Reference Clock Frequency, \
                                and performing timing analysis of your design to ensure that the \
                                Secondary Reference Clock Frequency you have selected is legal \
                                and does not result in a timing violation when switchover occurs. "	       } \
		{"gui_en_phout_ports" 	""			                                      BOOLEAN \
                             	""							                      "LVDS External PLL" \
                			 	"Enable access to PLL DPA output port"		  	  false	\
                				""											   	  None	\
                         		""			                                   	  false \
                             	"Turn on this parameter to enable the PLL DPA output port (phout)"         } \
		{"gui_phout_division"  	""			                                      INTEGER \
                             	""								                  "LVDS External PLL" \
         				    	"PLL DPA output division"					      1	\
            					{1 2 4}										      None	\
                          		""				                                  false \
        	                    "N/A"														      	 	   } \
		{"gui_en_extclkout_ports"   ""				                              BOOLEAN \
                               	""								                  "External Clock Output" \
                       			"Enable access to PLL external clock output port" false	\
                 				""										    	  None \
                     			""				                                  false \
        	                    "Select this option to enable external clock output port. These \
                                 outputs can be connected directly to pins on the IO tile, \
                                 whereas outclks must be routed through the core."					       } \
		{"gui_number_of_clocks" ""				                                  INTEGER \
                                ::altera_iopll::update_callbacks::main_callback  "Output Clocks" \
               					"Number Of Clocks"							      1	\
            					{1 2 3 4 5 6 7 8 9}								  None \
                       			""				                                  false \
                               	"Specifies the number of output clocks required in your design."	   	  } \
		{"gui_multiply_factor"  ""			                                  	  INTEGER \
                                ::altera_iopll::update_callbacks::main_callback	  "Output Clocks" \
         					    "Multiply Factor (M-Counter)"				      6	\
               					{1:510}										   	  None \
                        		""				                                  false \
                             	"Specifies the value of the M counter"								   	  } \
		{"gui_divide_factor_n"  ""	                                     		  INTEGER \
                                ::altera_iopll::update_callbacks::main_callback	  "Output Clocks" \
            					"Divide Factor (N-Counter)"					      1	\
          					    {1:510}										      None \
                     			""				                                  false \
        	                    "Specifies value for the N counter"		    					         } \
		{"gui_frac_multiply_factor"    ""			                              LONG \
                            	""							                 	  "Output Clocks" \
               					"Fractional Multiply Factor (K)"			   	  1	\
             					{1:4294967296}									  None	\
                         		""			                                      false \
                             	"N/A"															        } \
		{"gui_fix_vco_frequency" ""				                                  BOOLEAN \
                                ::altera_iopll::update_callbacks::main_callback      	  "Output Clocks" \
         					    "Specify VCO frequency"							  false	\
                   				""												  None	\
                          		""				                                  false \
                             	"Restricts the VCO frequency to the specified value. Otherwise \
                                 the VCO frequency will default to the lowest frequency \
                                 possible in order to minimize jitter."							        } \
		{"gui_fixed_vco_frequency" 	""			                             	  FLOAT \
                                ::altera_iopll::update_callbacks::main_callback	  "Output Clocks" \
               					"Desired VCO Frequency"								      600.0	\
                     			{0.000001:10000}							   	  "megahertz" \
                         		MHz				                                  false \
        	                    "The desired frequency of the voltage controlled oscillator (VCO)."	  	} \
		{"gui_vco_frequency"   	""				                                  STRING \
                                ::altera_iopll::update_callbacks::main_callback	  "Output Clocks" \
           					    "Actual VCO Frequency"								      600.0	\
                				{0.0 600.0}									      "megahertz" \
                        		MHz			                                  	  false \
         	                    "Legal frequencies of the voltage controlled oscillator."             	} \
		{"gui_enable_output_counter_cascading"	""				                  BOOLEAN \
                              	""							                  	"Output Counter Cascading" \
                         		"Enable output counter cascading"				  false	\
                     			""											      None	\
                        		""				                                  false \
        	                    "This feature will be enabled in a future version of Quartus."	        } \
        {"gui_mif_gen_options"  ""		  	                                      STRING \
                              	""								                  "MIF Streaming" \
          					    "MIF Generation Options"				   	      "Generate New MIF File" \
                            	{"Generate New MIF File" "Add Configuration to Existing MIF File" \
                                "Create MIF file during IP Generation"}        	  None	\
                         		""				                                  false \
        	                    "Either create a new MIF file containing the current configuration \
                                of the IOPLL, or add this configuration to an existing MIF file.\
                                This MIF file can then be used during dynamic reconfiguration to \
                                reconfigure the IOPLL to its current settings."							} \
        {"gui_new_mif_file_path" ""		  	                                      STRING \
                               	""								                  "MIF Streaming" \
                  				"Path to New MIF file"				   			  "~/pll.mif" \
                         	    ""                                                None \
                     			""			         	                          false \
        	                    "Enter location and filename of the new MIF file to be created."	  	} \
        {"gui_existing_mif_file_path"  	""		                              	  STRING \
                            	""								                  "MIF Streaming" \
               					"Path to Existing MIF file"				   		  "~/pll.mif" \
                             	""                                                None \
                    			""			         	                          false \
        	                    "Enter the location and filename of the existing MIF file \
                                you intend to add to."				                   		            } \
        {"gui_mif_config_name"  ""		                                       	  STRING \
                            	""								                  "MIF Streaming" \
          					    "Name of Current Configuration"		    		  "unnamed" \
                             	""                                                None	\
                         		""			         	                          false \
        	                    "Enter the location and filename of the existing MIF file \
                                 you intend to add to."				                   		            } \
		{"gui_active_clk"	    ""				                                  BOOLEAN \
                              	""								                  "Clock Switchover Ports" \
                         		"Create an 'active_clk' signal to indicate the input clock in use" 	false \
                 			  	""											      None	\
                          		""			                                 	  false \
                              	"The 'active_clk' signal indicates which input clock is currently \
                                in use by the PLL. Low indicates refclk, High indicates refclk1."		} \
		{"gui_clk_bad"			""			                                   	  BOOLEAN \
                             	""								                  "Clock Switchover Ports" \
                        		"Create a 'clkbad' signal for each of the input clocks" 	false \
              					""											      None	\
                        		""				                                  false \
                              	"Seleting this option creates two CLKBAD outputs, one for each \
                                input clock. Low indicates that the corresponding refclk is \
                                working and high indicates that the corresponding refclk isn't \
                                working. Note that these signals are not reliable if neither \
                                clock is toggling."	                                                    } \
		{"gui_switchover_mode"  ""			                                   	  STRING \
                              	""							             	"Input Clock Switchover Mode" \
                            	"Switchover Mode"								  "Automatic Switchover" \
                            	{"Automatic Switchover" "Manual Switchover" \
                                  "Automatic Switchover with Manual Override"}    None \
                     			""				                                  false \
         	                    "<html>Specifies how Input frequency switchover will be handled. \
		                        <b>Automatic Switchover</b> uses built in circuitry to detect if one \
                                 of your input clocks has stopped toggling and switch to the other. \
		                        <b>Manual Switchover</b> will create an 'extswitch' signal. \
                                'Extswitch' can be used to manually switch between the current \
                                input clock and the other input clock, by asserting high for at \
                                least 3 cycles. <b>Automatic Switchover with Manual Override </b> \
                                will act as Automatic Switchover until the 'extswitch' goes high, \
                                at which point it will switch clocks and ignore any automatic \
                                switches for as long as extswitch stays high"	                       } \
		{"gui_switchover_delay" ""				                                  INTEGER \
                             	""								           "Input Clock Switchover Mode" \
                             	"Switchover Delay"							  	  0 \
         						{0 1 2 3 4 5 6 7}							      None \
                     			""				                                  false \
                             	"Adds a specific amount of cycle delay to the Switchover Process"  	   } \
		{"gui_enable_cascade_out"   ""				                              BOOLEAN \
                               	""								             "PLL Use As Upstream PLL" \
                   "Create a 'cascade_out' signal to connect to a downstream PLL" false \
  				              	""										     	  None \
                     			""				                                  false \
        	                    "This option creates an output port to connect to a downstream \
                                PLL for IO Column cascading."		                                   } \
		{"gui_cascade_outclk_index" 	""				                          STRING \
                                NOVAL  "PLL Use As Upstream PLL"	\
                            	"cascade_out source"						      0	\
           					    {0}												  None \
                   			    ""				                                  false \
        	                    "The 'cascade_out' signal can correspond to any one of the outclks. \
                                This setting determines which of the outclks configured \
                                feeds the cascade_out signal."									       } \
		{"gui_enable_cascade_in" 	""				                              BOOLEAN \
                           	    ""								                  "PLL Use As Downstream PLL"\
                       		    "Create an 'adjpllin' (cascade in) signal to connect to an upstream PLL" \
                                false \
                        		""											      None	\
                        		""				                                  false \
        	                    "This option creates an input port to connect to an upstream PLL \
                                for IO Column Cascading. Note that if this port is added, and not  \
                                connected to an upstream PLL, this IOPLL will not lock. "	} \
		{"gui_pll_cascading_mode" 	""				                              STRING \
                               	""								               "PLL Use As Downstream PLL" \
 	                        	"Connection Signal Type to Upstream PLL"	      "adjpllin" \
            				    {"adjpllin"	"cclk"}							   	  None	\
                         		""				                                  false \
	                            "N/A"														           } \
		{"gui_enable_mif_dps"   ""			                                   	  BOOLEAN \
                              	""								               "Dynamic Phase Shift (MIF)" \
                         		"Enable Dynamic Phase Shift for MIF streaming"	  false	\
                 				""											      None \
                    			""				                                  false \
        	                    "Store dynamic phase shift properties into a MIF file for PLL \
                                Reconfiguration. Dynamic reconfiguration of the IOPLL must be enabled. \
                                This MIF file can be used during dynamic reconfiguration to perform \
                                the phase shift specified below."		                             	} \
		{"gui_dps_cntr"		   	""				                                  STRING \
                                NOVAL	   "Dynamic Phase Shift (MIF)" \
                        		"DPS Counter Selection"						      "C0"	\
                   				{"C0" "All C" "M"}      None \
                    			""			                                      false \
                               	"Counter on which to perform dynamic phase shift"					  	} \
		{"gui_dps_num"		   	""			                                      INTEGER \
                                NOVAL		   "Dynamic Phase Shift (MIF)" \
                         		"Number of Dynamic Phase Shifts"			      1	\
            					{1:65535}									      None \
                     			""				                                  false \
	                           "Number of phase steps to be performed \
                                (one phase step is equal to 1/8 of the VCO period)"					  	} \
		{"gui_dps_dir"		   ""			                                      STRING \
                               ""					                       	  "Dynamic Phase Shift (MIF)" \
	                           "Dynamic Phase Shift Direction"                   "Positive"	\
		                       {"Positive" "Negative"}						      None \
                    		   ""				                                  false \
                               "Direction in which phase shift should be performed."			    	} \
		{"gui_extclkout_0_source" 	""			                             	  STRING \
	                           NOVAL	  "External Clock Output" \
                  	           "extclk_out[0] source"					          "C0" \
           				       {"C0"}											  None	\
                    	       ""				                                  false \
        	                   "This setting determines which of the outclks configured feeds \
                               the extclk_out[0] signal"						""  } \
		{"gui_extclkout_1_source"  	""			                                  STRING \
	                           NOVAL   "External Clock Output" \
                  	           "extclk_out[1] source"					          "C0"	\
              				   {"C0"}											  None	\
                        	   ""				                                  false \
                               "This setting determines which of the outclks configured feeds \
                               the extclk_out[1] signal"								                } \
		{"gui_clock_name_global"  	""			                                  BOOLEAN \
                               	""						                          "Output Clocks" \
         						"Give clocks global names"					      false	\
                 				""											      "" \
                  				""			                                  	  false \
                             	"When this option is selected, the 'Clock Name' entered below \
                                is a 'global' clock name, and can be used in SDC constraints \
                                and assignments without specifing its the full design hierarchy of \
                                the signal. Use caution with this feature, since if there are two \
                                IOPLLs with the same global clock names in a design, there is no way \
                                to differentiate between the identically named signals when making \
                                assignments and SDC constraints."						            	} \
        {"gui_clock_name_string#" 	0-17		                              	  STRING \
                            	NOVAL  "outclk#"	\
             					"Clock Name"								      "outclk#"	\
                     			""										    	  "" \
                				""			                                      false \
                              	"The clock name used in SDC constraints and assignments."	       	    } \
		{"gui_divide_factor_c#"	0-17		                                  	  INTEGER \
                              	::altera_iopll::update_callbacks::main_callback 		  "outclk#"	\
					            "Divide Factor (C-Counter)"                       6	\
					            {1:510}                                       	  "" \
  			                    ""                                             	  false \
                               	"Specifies the value of the C counter feeding this outclk."	      	   } \
		{"gui_cascade_counter#"  0-17		                                   	  BOOLEAN	\
                                ""							               	      "outclk#"	\
 					            "Make this a cascade counter"                	  false	\
			                    ""                                            	  "" \
				                ""                                             	  false \
                                "N/A"                                                                  } \
		{"gui_output_clock_frequency#"	0-17		                       	      FLOAT \
                              	::altera_iopll::update_callbacks::main_callback         "outclk#"	\
        				     	"Desired Frequency"						     	  100.0	\
        			         	{0.000001:10000}							      "megahertz" \
	                      	    "MHz"			                                  false \
                               	"Specifies the desired value of this outclk's frequency."		       } \
		{"gui_actual_output_clock_frequency#"	0-17             		      	STRING	\
                                ""                          "outclk#"	\
         					    "Actual Frequency"						    	  100.0	\
            				    ""      									      "megahertz" \
                       		    "MHz"		                                  	  true \
        	                    "Possible frequencies near the requested frequency." fixed_size	   } \
		{"gui_actual_output_clock_frequency_range#"	0-17             		      	  STRING_LIST	\
                                ""                                   "Nearest Legal Values #"	\
         					    "Legal Frequencies"						    	  100.0	\
            				    ""      									      "megahertz" \
                       		    "MHz"		                                  	  true \
        	                    "Possible frequencies near the requested frequency." fixed_size	   } \
		{"gui_ps_units#"	    0-17		                                   	  STRING	\
                                ""                                                     "outclk#"	\
               					"Phase Shift Units"						    	  "ps"	\
                 				{"ps" "degrees"}							      "" \
                 				""				                                  false \
                             	"Determines whether the phase shift is entered in picoseconds \
                                or degrees."						    				               } \
		{"gui_phase_shift#"	    0-17		                                   	  FLOAT	\
                                ::altera_iopll::update_callbacks::main_callback         "outclk#"	\
            					"Desired Phase Shift"						      0	\
     				         	""										    	  "picoseconds" \
                            	"ps"			                                  false \
                              	"Specifies the desired value of this outclk's phase shift in \
                                picoseconds."									   			} \
		{"gui_phase_shift_deg#" 0-17			                                  FLOAT \
                                ::altera_iopll::update_callbacks::main_callback         "outclk#" \
            				  	"Desired Phase Shift"							  0	\
          					    {-360:360}					 				      "" \
               				    "degrees"		                                  false \
        	                    "Specifies the desired value of this outclk's phase shift in degrees."	} \
		{"gui_actual_phase_shift#" 	0-17			                        STRING \
                                ""                                               "outclk#"	\
				          	    "Actual phase shift"							  0.0	\
               					""      									      "picoseconds" \
                            	"ps"		                                  	  true \
                             	"possible phase shifts near the requested phase shift."     } \
		{"gui_actual_phase_shift_range#" 	0-17			                              STRING_LIST \
                                ""                                       "Nearest Legal Values #"	\
				          	    "Legal Phase Shifts"							  0.0	\
               					""      									      "picoseconds" \
                            	"ps"		                                  	  true \
                             	"Possible phase shifts near the requested phase shift."	 fixed_size     } \
		{"gui_actual_phase_shift_deg#"	0-17			                    STRING \
                                ""                                                "outclk#"	\
          					    "Actual Phase Shift"						      0.0	\
             					""      								     	  "" \
   			                  	"degrees"	                                      true \
                              	"Possible phase shifts near the requested phase shift." } \
		{"gui_actual_phase_shift_deg_range#"	0-17			                          STRING_LIST \
                                ""                                        "Nearest Legal Values #"	\
          					    "Legal Phase Shifts"						      0.0	\
             					""      								     	  "" \
   			                  	"degrees"	                                      true \
                              	"Possible phase shifts near the requested phase shift." fixed_size} \
		{"gui_duty_cycle#"	   	0-17		                                   	  FLOAT	\
                                ::altera_iopll::update_callbacks::main_callback         "outclk#"	\
    				            "Desired Duty Cycle"                              50.0	\
    				            {0.000001:100}                                    "percent" \
                                "%"                                               false \
        	                    "Specifies desired value of this outclk's duty cycle."                 } \
		{"gui_actual_duty_cycle#" 	0-17			                        STRING\
                                ""                                                "outclk#"	\
          					    "Actual duty cycle"							      50.0	\
                 				""									      "percent"	\
                            	"%"			                                      true \
        	                    "possible duty cycles near the requested duty cycle."} \
		{"gui_actual_duty_cycle_range#" 	0-17			                              STRING_LIST\
                                ""                                       "Nearest Legal Values #"	\
          					    "Legal Duty Cycles"							      50.0	\
                 				""									      "percent"	\
                            	"%"			                                      true \
        	                    "Possible duty cycles near the requested duty cycle."	fixed_size   } \
	}

	# +------------------------------
	# | FUNCTIONS for gui parameters 
	# |	
	proc add_all_items_to_display {} {
	# Description:	
	#  Top level function to add all gui controls to the gui.
	#  It will add all of the tabs/parameters/etc. defined by the namespace parameter lists to the gui.
   
		# Namespace variables containing tables of parameter data
		variable gui_parameters
		variable system_info_parameters
		variable system_part_trait_parameters
		variable gui_system_info_parameters
		variable gui_invis_parameters
		variable tables
		variable table_columns
		variable pll_tab_display_items
		variable pll_tab_info_and_warnings
		variable settings_tab_display_items
		variable cascading_tab_display_items
		variable reconfig_tab_display_items
		variable reconfig_tab_buttons
		variable adv_params_tab_display_items
      
		#--Declare parameters
		::altera_iopll::util::declare_hwtcl_parameters $gui_system_info_parameters true
		::altera_iopll::util::declare_hwtcl_parameters $gui_invis_parameters true
		::altera_iopll::util::declare_hwtcl_display_items $pll_tab_info_and_warnings
		::altera_iopll::util::declare_hwtcl_parameters $system_info_parameters true
		::altera_iopll::util::declare_hwtcl_parameters $system_part_trait_parameters true
		::altera_iopll::util::declare_hwtcl_parameters $gui_parameters true
		
		#--Declare display items next
		::altera_iopll::util::declare_hwtcl_display_items $pll_tab_display_items
		::altera_iopll::util::declare_hwtcl_display_items $settings_tab_display_items
		::altera_iopll::util::declare_hwtcl_display_items $cascading_tab_display_items
		::altera_iopll::util::declare_hwtcl_display_items $reconfig_tab_display_items
		::altera_iopll::util::declare_hwtcl_display_items $adv_params_tab_display_items

		#--Declare the tables
		::altera_iopll::util::declare_hwtcl_display_items $tables
		::altera_iopll::util::declare_hwtcl_parameters $table_columns true

		#--Declare the buttons
		::altera_iopll::util::declare_hwtcl_display_items $reconfig_tab_buttons
	}  
	 
    proc get_gui_debug_parameters_list {family} {
		variable gui_invis_parameters
		set master_list [list]
        
        # Add the debug params as physical params. Should only be generated if debug_mode is true
		set gui_debug_params [::altera_iopll::util::extract_columns_as_array NAME {DERIVED} \
                                 $gui_invis_parameters] 
		
		# Foreach physical parameter, determine whether we want to add it
		foreach {parameter_name param_data} $gui_debug_params {
			array set param_data_array $param_data
            lappend master_list $parameter_name
		}
 		
		set master_list [lsort $master_list]
		return $master_list 
    }
}	

# |+==========================================================================================================
# | INTERFACES AND PORTS
# | Interfaces are logical groupings of ports
# | Ports are the actual wires/buses to/from the pll
# | Ports must be associated with an interface

namespace eval altera_pll_interfaces {
	# Static interfaces ALWAYS exist (can be added at gui startup)
	set static_interfaces {\
		{NAME				TYPE	DIRECTION	associatedClock	synchronousEdges} \
		{reset				reset	end			""				NONE } \
	}
	
	# Non-static interfaces: added conditionally during elaboration
	set nf_interfaces {\
		{NAME				TYPE	DIRECTION	associatedClock synchronousEdges} \
		{refclk				clock	end			""				"" } \
		{fbclk				clock	end			""			    "" } \
		{fboutclk			clock	start		""			    "" } \
		{zdbfbclk			conduit	start		""			    "" } \
		{locked				conduit	start		""			    "" } \
		{reconfig_to_pll	conduit	end 		""			    "" } \
		{reconfig_from_pll	conduit	start		""			    "" } \
		{scanclk			conduit	end			""			    "" } \
		{phase_en			conduit	end			""			    "" } \
		{updn				conduit	end			""			    "" } \
		{cntsel				conduit	end			""			    "" } \
		{phase_done			conduit	start		""			    "" } \
		{phout				conduit start		""			    "" } \
		{extclk_out			conduit start		""			    "" } \
		{lvds_clk			conduit start		""			    "" } \
		{loaden				conduit start		""			    "" } \
		{refclk1			clock	end			""			    "" } \
		{extswitch			conduit	end			""			    "" } \
		{activeclk			conduit	start 		""			    "" } \
		{clkbad				conduit	start		""			    "" } \
		{cascade_out		clock	start		""			    "" } \
		{adjpllin			clock	end			""			    "" } \
		{cclk				clock	end			""			    "" } \
		{num_phase_shifts	conduit	end			""			    "" } \
		{outclk0		    clock	start		""			 	} \
		{outclk1		    clock	start		""			 	} \
		{outclk2		    clock	start		""			 	} \
		{outclk3		    clock	start		""			 	} \
		{outclk4		    clock	start		""			 	} \
		{outclk5		    clock	start		""			 	} \
		{outclk6		    clock	start		""			 	} \
		{outclk7			clock	start		""			 	} \
		{outclk8		    clock	start		""			 	} \
	}

	# Non-static interfaces: added conditionally during elaboration
	set nd_interfaces {\
		{NAME				TYPE	DIRECTION	associatedClock synchronousEdges} \
		{refclk				clock	end			""				"" } \
		{fbclk				clock	end			""			    "" } \
		{fboutclk			clock	start		""			    "" } \
		{zdbfbclk			clock 	start		""			    "" } \
		{locked				conduit	start		""			    "" } \
		{reconfig_to_pll	conduit	end	    	""			    "" } \
		{reconfig_from_pll	conduit	start		""			    "" } \
		{scanclk			clock 	end			""			    "" } \
		{phase_en			conduit	end			""			    "" } \
		{updn				conduit	end			""			    "" } \
		{cntsel				conduit	end			""			    "" } \
		{phase_done			conduit	start		""			    "" } \
		{phout				clock   start		""			    "" } \
		{extclk_out			conduit start		""			    "" } \
		{lvds_clk			conduit	start		""			    "" } \
		{loaden				conduit	start		""			    "" } \
		{refclk1			clock	end			""			    "" } \
		{extswitch			conduit	end			""			    "" } \
		{activeclk			conduit	start 		""			    "" } \
		{clkbad				conduit	start		""			    "" } \
		{cascade_out		clock	start		""			    "" } \
		{adjpllin			clock	end			""			    "" } \
		{cclk				clock	end			""			    "" } \
		{num_phase_shifts	conduit	end			""			    "" } \
		{outclk0		    clock	start		""			 	} \
		{outclk1		    clock	start		""			 	} \
		{outclk2		    clock	start		""			 	} \
		{outclk3		    clock	start		""			 	} \
		{outclk4		    clock	start		""			 	} \
		{outclk5		    clock	start		""			 	} \
		{outclk6		    clock	start		""			 	} \
		{outclk7			clock	start		""			 	} \
		{outclk8		    clock	start		""			 	} \
	}
	
	# Non-static interfaces (multiple version)
	set interfaces_multiple { \
		{NAME				INSTANCES	TYPE	DIRECTION	associatedClock} \
		{outclk#			TBD			clock	start		""			 	} \
	}
    
	# Static ports: always exist (can be added at gui startup)
	set static_ports {\
		{NAME				INTERFACE			ROLE				DIRECTION	WIDTH_EXPR	} \
		{rst				reset				reset				Input		1		} \
	}
	
	# Non-static ports: these are added conditionally during elaboration
	set nf_ports {\
		{NAME				INTERFACE			ROLE				DIRECTION	WIDTH_EXPR	} \
		{refclk				refclk				clk					Input		1		} \
		{fbclk				fbclk				clk					Input		1		} \
		{fboutclk			fboutclk			clk					Output		1		} \
		{zdbfbclk			zdbfbclk			export				Bidir		1		} \
		{locked				locked				export				Output		1		} \
		{reconfig_to_pll	reconfig_to_pll		reconfig_to_pll		Input		64		} \
		{reconfig_from_pll	reconfig_from_pll	reconfig_from_pll	Output		64		} \
		{scanclk			scanclk				clk 				Input		1		} \
		{phase_en			phase_en			phase_en			Input		1		} \
		{updn				updn				updn				Input		1		} \
		{cntsel				cntsel				cntsel				Input		5		} \
		{phase_done			phase_done			phase_done			Output		1		} \
		{phout				phout				phout				Output		8		} \
		{extclk_out			extclk_out			extclk_out			Output		2		} \
		{lvds_clk			lvds_clk			lvds_clk			Output		2       } \
		{loaden				loaden				loaden				Output		2       } \
		{refclk1			refclk1				clk					Input		1		} \
		{extswitch			extswitch			extswitch			Input		1		} \
		{activeclk			activeclk			activeclk			Output		1		} \
		{clkbad				clkbad				clkbad				Output		2		} \
		{cascade_out		cascade_out			clk			    	Output		1		} \
		{adjpllin			adjpllin			clk			    	Input		1		} \
		{cclk				cclk				export				Input		1		} \
		{num_phase_shifts	num_phase_shifts	num_phase_shifts	Input		3		} \
		{outclk_0		    outclk0				clk					Output		1	  	} \
		{outclk_1		    outclk1		    	clk					Output		1	  	} \
		{outclk_2		    outclk2				clk					Output		1	  	} \
		{outclk_3		    outclk3				clk					Output		1	  	} \
		{outclk_4		    outclk4				clk					Output		1	   	} \
		{outclk_5		    outclk5				clk					Output		1	   	} \
		{outclk_6		    outclk6				clk					Output		1	   	} \
		{outclk_7		    outclk7				clk					Output		1	   	} \
		{outclk_8	        outclk8				clk					Output		1	   	} \
	}

    set nd_ports {\
		{NAME				INTERFACE			ROLE				DIRECTION	WIDTH_EXPR	} \
		{refclk				refclk				clk					Input		1		} \
		{fbclk				fbclk				clk					Input		1		} \
		{fboutclk			fboutclk			clk					Output		1		} \
		{zdbfbclk			zdbfbclk			export				Bidir		1		} \
		{locked				locked				export				Output		1		} \
		{reconfig_to_pll	reconfig_to_pll		reconfig_to_pll		Input		30		} \
		{reconfig_from_pll	reconfig_from_pll	reconfig_from_pll	Output		10		} \
		{scanclk			scanclk				clk 				Input		1		} \
		{phase_en			phase_en			phase_en			Input		1		} \
		{updn				updn				updn				Input		1		} \
		{cntsel				cntsel				cntsel				Input		5		} \
		{phase_done			phase_done			phase_done			Output		1		} \
		{phout				phout				phout				Output		8		} \
		{extclk_out			extclk_out			extclk_out			Output		2		} \
		{lvds_clk			lvds_clk			lvds_clk			Output		2		} \
		{loaden				loaden				loaden				Output		2		} \
		{refclk1			refclk1				clk					Input		1		} \
		{extswitch			extswitch			extswitch			Input		1		} \
		{activeclk			activeclk			activeclk			Output		1		} \
		{clkbad				clkbad				clkbad				Output		2		} \
		{cascade_out		cascade_out			clk			    	Output		1		} \
		{adjpllin			adjpllin			clk			    	Input		1		} \
		{cclk				cclk				export				Input		1		} \
		{num_phase_shifts	num_phase_shifts	num_phase_shifts	Input		3		} \
		{outclk_0		    outclk0				clk					Output		1	 	} \
		{outclk_1		    outclk1		    	clk					Output		1	  	} \
		{outclk_2		    outclk2				clk					Output		1	   	} \
		{outclk_3		    outclk3				clk					Output		1	   	} \
		{outclk_4		    outclk4				clk					Output		1	   	} \
		{outclk_5		    outclk5				clk					Output		1	   	} \
		{outclk_6		    outclk6				clk					Output		1	   	} \
		{outclk_7		    outclk7				clk					Output		1	   	} \
		{outclk_8	        outclk8				clk					Output		1  		} \
    }
	#NOTE: cntsel is actually 4 on nf and nd 
    # cntsel on IOPLL is 4 bits, but 5 on 28nm. For backwards compatibility, keep it 5
    # and pass in cntsel[3:0] to the IOPLL		
	
	set ports_multiple { \
		{NAME				INSTANCES	INTERFACE			ROLE				DIRECTION	WIDTH_EXPR	} \
		{outclk_#			TBD			outclk#				clk					Output		1			} \
	}
	
	# |-----------------------------------
	# | Altera_iopll ports
	# | These are the ports on the instantiation of the altera_iopll module within the qsys top-level system
	# | If a port corresponds directly to a top-level port, then DIRECT_MAPPING = true and the altera_pll
    # | port will be directly connected to it's top-level counterpart with the same name
	# | If a port does not correspond directly to a top-level port (ie, it's name is different,
    # | or the value passed to it is different potentially, or it exists even if the top-level
	# |  port does not exist), then set DIRECT_MAPPING = false, and add a MAPPING_FUNCTION, which
	# |  will be called when the port is added and determines  what to put in .port_name(<HERE>). 
	set altera_pll_ports {\
		{NAME				DIRECT_MAPPING	MAPPING_FUNCTION    TIE_OFF	} \
		{refclk				true			""				    "1'b0"	} \
		{rst				true			""				    "1'b0"	} \
		{fbclk				false			map_fbclk_port		""      } \
		{fboutclk			false			map_fboutclk_port	""      } \
		{zdbfbclk			true			""					" "     } \
		{locked				true			""					" "     } \
		{reconfig_to_pll	false			map_reconfig_to_port	""  } \
		{reconfig_from_pll	true			""					" "     } \
		{scanclk			true			""					"1'b0"  } \
		{phase_en			true			""					"1'b0"  } \
		{updn				true			""					"1'b0"  } \
		{cntsel				true			""					"5'b0"  } \
		{phase_done			true			""					" "     } \
		{phout				true			""					" "     } \
		{extclk_out			true			""					" "     } \
		{lvds_clk			true			""					" "     } \
		{loaden				true			""					" "     } \
		{refclk1			true			""					"1'b0"  } \
		{extswitch			true			""					"1'b0"  } \
		{activeclk			true			""					" "     } \
		{clkbad				true			""					" "     } \
		{cascade_out		true			""					" "     } \
		{outclk				false			map_outclk_port		""      } \
		{num_phase_shifts	true			""					"3'b0"  } \
		{adjpllin			true			""					"1'b0"  } \
	}
	
	proc add_static_interfaces {} {
		variable static_interfaces
		
		::altera_iopll::util::declare_hwtcl_interfaces $static_interfaces
	}
	
	proc add_static_ports {} {
		variable static_ports
		
		::altera_iopll::util::declare_hwtcl_ports $static_ports
	}
	
	proc add_dynamic_interface {interface_name {instances ""}} {
		variable nf_interfaces
		variable nd_interfaces
		variable interfaces_multiple
		
	    set family [get_parameter_value gui_device_family]
        if {$family == "Stratix 10"} {
            set interfaces $nd_interfaces
        } else {
            set interfaces $nf_interfaces
        }

		set desired_row [::altera_iopll::util::extract_rows_given_duplicate_keys \
                         NAME $interface_name $interfaces false]
		::altera_iopll::util::extract_header_and_data $interfaces header interfaces_less_header
		
		if {[llength $desired_row] < 1} {
			# Otherwise try the other table
			set desired_row [::altera_iopll::util::extract_rows_given_duplicate_keys \
                            NAME $interface_name $interfaces_multiple false]		
			::altera_iopll::util::extract_header_and_data $interfaces_multiple header interfaces_less_header
		}	
		
		# Extract rows gives a list of lists
		set desired_row [lindex $desired_row 0]
		if {$instances != ""} {
			set i_instances [lsearch $header INSTANCES]
			set desired_row [lreplace $desired_row $i_instances $i_instances $instances]
		}
		set interface_table ""
		lappend interface_table $header
		lappend interface_table $desired_row

		::altera_iopll::util::declare_hwtcl_interfaces $interface_table	

	}
	
	proc add_dynamic_ports {interface_name {instances ""} } {
		variable nf_ports
		variable nd_ports
		variable ports_multiple
		
        set family [get_parameter_value gui_device_family]
		# Get a subtable of the desired interfaces

        if {$family == "Stratix 10"} {
            set ports $nd_ports
        } else {
            set ports $nf_ports
        }

		# We assume that instance indices sync with port indices
		if {$instances == ""} {
			set desired_rows [::altera_iopll::util::extract_rows_given_duplicate_keys \
                              INTERFACE $interface_name $ports false]
			::altera_iopll::util::extract_header_and_data $ports header ports_less_header

		} else {
			set desired_rows [::altera_iopll::util::extract_rows_given_duplicate_keys \
                              INTERFACE $interface_name $ports_multiple false]
			::altera_iopll::util::extract_header_and_data $ports_multiple header ports_less_header	
			set i_instances [lsearch $header INSTANCES]
			set new_desired_rows ""
			foreach element $desired_rows {
				lappend new_desired_rows [lreplace $element $i_instances $i_instances $instances]	
			}
			set desired_rows $new_desired_rows		

		}
		set ports_table [linsert $desired_rows 0 $header]
		
		::altera_iopll::util::declare_hwtcl_ports $ports_table

	}

	# Returns an array masquerading as a list
	proc get_altera_pll_ports_as_array {} {
		variable altera_pll_ports
		return [::altera_iopll::util::extract_columns_as_array NAME \
               {DIRECT_MAPPING MAPPING_FUNCTION TIE_OFF} $altera_pll_ports]
	}
	
}	

# +===========================================================================================================
# | HELPER PARAMETERS - non-visible, but also non-physical
# | 
namespace eval altera_pll_helper_gui_parameters {
    # Invisible parameters
	set helper_parameters { \
		{NAME									INSTANCES TYPE	   VALIDATION_CALLBACK  \
                                                VISIBLE   DEFAULT_VALUE \
                                             	DERIVED	  DESCRIPTION} \
		{hp_number_of_family_allowable_clocks	""        INTEGER	 ""  \
                                                false     9   	   true  \
                                                "Set to max number of clocks allowed for this family"} \
		{hp_previous_num_clocks			        ""        INTEGER  ""  \
                                                false	  1   	   true    \
                                                "Used in update callback to determine whether the user\
                                                added or removed clocks "} \
	    {hp_actual_vco_frequency_fp             ""        FLOAT    "" \
                                                false	  600.0    true   \
                                              	"Full precision version of actual VCO frequency"} \
        {hp_parameter_update_message            ""        STRING   ""      \
                                                false	  {}       true	 \
                                                "Messages from update callbacks to send during validation"} \
        {hp_qsys_scripting_mode                 ""        BOOLEAN  ""      \
                                                false	  true     false	 \
                                                "Whether qsys-scripting is being used - true if update \
                                                callbacks have not been used."} \
	}
	
	# The lists of non-truncated values
	# Note: the defaults MUST MATCH the defaults for the corresponding gui parameters
	set helper_parameters_multiple { \
		{NAME					  INSTANCES		TYPE            VALIDATION_CALLBACK\
		                          VISIBLE		DEFAULT_VALUE	DERIVED \
                                  DESCRIPTION} \
		{hp_actual_output_clock_frequency_fp#  0-17			FLOAT	        "" \
 	                              false	    	100.0		  	true \
        	"Keep track of the full precision version of the frequency, to send to qcl/pll" 	} \
		{hp_actual_phase_shift_fp#             0-17			FLOAT	        "" \
 	                              false	    	0.0			  	true \
	        "Keep track of the full precision version of the phase, to send to qcl/pll" 	} \
		{hp_actual_duty_cycle_fp#              0-17			FLOAT	        "" \
 	                              false	    	50			  	true \
	          "Keep track of the full precision version of the duty_cycle, to send to qcl/pll" 	} \
	}
	
	proc declare_parameters_for_display {parameters} {
		::altera_iopll::util::declare_hwtcl_parameters $parameters false
	}	
    
}

# +===========================================================================================================
# | PHYSICAL PARAMETERS
# | These are the parameters on the altera_pll instantiation. 
# | Note that they are NOT HDL_PARAMETERS on the top level module.
# | MIF_PARAM - is currently unused, but provides an indication of which parameters are
# |    being used for mif streaming
# | VIRTUAL_PARAM - indicates whether the parameter appears on generic_pll
# | FAMILY - indicates whether the parameter is present on altera_pll instantiations for 
# |   a given family

namespace eval altera_pll_physical_parameters {

    # Physical Parameters only set in Debug mode. 
    set debug_physical_params { \
		{NAME						  TYPE		MIF_PARAM	VIRTUAL_PARAM	FAMILY	\
                                      VALIDATION_CALLBACK	\
  									  DEFAULT_VALUE  VISIBLE UNITS ALLOWED_RANGES DERIVED AFFECTS_GENERATION} \
		{pll_tclk_mux_en              BOOLEAN	false	    false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params \
                                      false		        false	 None    ""			 true	    true    } \
        {pll_tclk_sel                 STRING   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      "pll_tclk_m_src"  false	None     ""			 true		true	} \
        {pll_vco_freq_band_0          STRING   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      "pll_freq_clk0_disabled"  false	None     ""			 true		true	} \
        {pll_vco_freq_band_1          STRING   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      "pll_freq_clk1_disabled"  false	None     ""			 true		true	} \
        {pll_freqcal_en               BOOLEAN   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      true             false	 None     ""			 true		true	} \
        {pll_freqcal_req_flag         BOOLEAN   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      true             false	 None     ""			 true		true	} \
        {cal_converge                 BOOLEAN   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      false             false	 None     ""			 true		true	} \
        {cal_error                    STRING   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      "cal_clean"  false	None     ""			 true		true	} \
        {pll_cal_done                 BOOLEAN   false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      false             false	 None     ""			 true		true	} \
		{include_iossm                BOOLEAN	false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      false				false	None     ""			 true		true  	} \
        {cal_code_hex_file            STRING	false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      "iossm.hex"   	false	None     ""			 true		true	} \
        {parameter_table_hex_file     STRING	false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      "seq_params_sim.hex" false None    ""	         true	    true	} \
        {iossm_nios_sim_clk_period_ps INTEGER	 false		false			""	\
		                              ::altera_pll_physical_parameters::update_debug_params  \
                                      1333   			false	None     ""	         true		true    } \
    }
	set physical_non_hdl {\
		{NAME				TYPE		   VALIDATION_CALLBACK \
                            DEFAULT_VALUE  VISIBLE	\
                            UNITS		   ALLOWED_RANGES			\
 		                    DERIVED		   AFFECTS_GENERATION	} \
		{pll_m_cnt_basic	INTEGER	       ::altera_pll_physical_parameters::update_pll_m_cnt_params_basic \
      		               	1			   false \
                         	none	       "" \
 							true	       true			} \
		{pll_m_cnt			INTEGER	       ::altera_pll_physical_parameters::update_pll_m_cnt \
    						1			   false \
                         	none	       "" \
 							true	       true	  	} \
	}

	set physical_parameters { \
		{NAME						TYPE	    	   MIF_PARAM	    VIRTUAL_PARAM 	FAMILY \
                            		VALIDATION_CALLBACK	 \
                                    DEFAULT_VALUE      VISIBLE	        UNITS		    ALLOWED_RANGES \
       								DERIVED	           AFFECTS_GENERATION	} \
		{m_cnt_hi_div				INTEGER		       true		        false           "" \
                         			NOVAL	\
          	   		                1                  false	        None		    {1:256}	\
   									true		       true  } \
		{m_cnt_lo_div				INTEGER		       true		        false           "" \
                          			NOVAL	\
       	                            1                  false	        None		    {1:256} \
         						   	true	           true	} \
		{n_cnt_hi_div				INTEGER		       true	           	false           "" \
                          			NOVAL	\
         	   		                1                  false	        None		    {1:256}	\
   									true		       true	} \
		{n_cnt_lo_div				INTEGER		       true		        false           "" \
               			            NOVAL \
 			   	                    1		           false	        None		    {1:256}	\
   									true		       true	} \
		{m_cnt_bypass_en			BOOLEAN		       true		        false           "" \
                        			NOVAL \
				                    false 	           false	        None	        "" \
         							true		       true	} \
		{n_cnt_bypass_en			BOOLEAN		       true		        false           "" \
           			                NOVAL \
				                    true               false	        None		    ""	\
									true		       true  } \
		{m_cnt_odd_div_duty_en		BOOLEAN		       true		        false           "" \
         			                NOVAL \
				                    false              false	        None		    ""	\
								  	true		       true	} \
		{n_cnt_odd_div_duty_en		BOOLEAN		       true		        false           "" \
                     			    NOVAL \
				                    false              false	        None		    ""	\
 									true		       true	} \
		{pll_vco_div				INTEGER		       true		        false           {28nm} \
            			            NOVAL \
				                    1                  false	        None	        {1 2}	\
 									true		       true	} \
		{pll_cp_current				STRING		       true		        false           "" \
                           			NOVAL \
				                    "PLL_CP_SETTING0"  false	        None		    "" \
                 					true		       true	} \
		{pll_bwctrl					STRING		       true		        false           "" \
                          			NOVAL \
				                    "PLL_BW_RES_SETTING4" false	        None		    ""	\
     								true		       true    } \
		{pll_fractional_division	INTEGER		       true	            false           {28nm} \
                         		    NOVAL \
				                    1                  false	        None		    "" \
 									true		       true	} \
		\
		{fractional_vco_multiplier	BOOLEAN		       false		    true	        {28nm} \
                            		::altera_pll_physical_parameters::update_fractional_vco_multiplier \
	                                0                  false	        None		    ""	\
  									true		       true   	} \
		{reference_clock_frequency	STRING		       false		    true			""	\
                            		::altera_pll_physical_parameters::update_reference_clock_frequency \
                                	"0 MHz"	   	       false	        None		    "" \
      								true		       true		} \
		{pll_fractional_cout		INTEGER		       false		    false			{28nm}	\
                               	    NOVAL \
          							32				   false	        None		    {1 8 16 24 32} \
    								true		       true	  	} \
		{pll_dsm_out_sel			STRING		       false		    false			{28nm} \
                          		    NOVAL	\
   									"1st_order"		   false	        None \
                             		{"1st_order" "2nd_order" "3rd_order"} \
                            		true		       true	  	} \
		{operation_mode				STRING		       false		    true			"" \
                         			::altera_pll_physical_parameters::update_operation_mode	\
                  			        "direct"		   false	        None \
                           		    {"direct" "external feedback" "external" "normal" "source synchronous" \
									"source_synchronous" "zero delay buffer" 	"zdb" "lvds" "NDFB normal" \
                                    "NDFB source synchronous"}	\
          							true		       true		} \
		{number_of_clocks			INTEGER		       false		    true			"" \
                         			::altera_pll_physical_parameters::update_number_of_clocks \
    								1				   false	        None		    {1:18}	\
									true		       true	  	} \
		{pll_vcoph_div				INTEGER		       false		    false			{28nm} \
		                            NOVAL	\
									1				   false	        None		    {1 2 4}	\
 							        true		       true		} \
		{pll_type					STRING		       false		    true			""	\
		                            ::altera_pll_physical_parameters::update_pll_type \
						            "General"		   false	        None		    ""	\
									true		       true		} \
		{pll_subtype				STRING		       false		    true			""	\
		                            ::altera_pll_physical_parameters::update_pll_subtype \
					                "General"		   false	        None		    ""	\
									true		       true	  	} \
		{pll_output_clk_frequency	STRING		       false		    false			"" \
			                        ::altera_pll_physical_parameters::update_pll_output_clk_frequency \
		                            "0 MHz"			   false	        None		    ""	\
									true		       true	   	} \
		{mimic_fbclk_type			STRING		       false		    false			{28nm}	\
	                                NOVAL \
								   	"gclk"			   false	        None		    "" \
									true		       true	  	} \
		{pll_bw_sel			        STRING		       false		    false			"" \
		                            ::altera_pll_physical_parameters::update_pll_bw_sel	\
					                "low"			   false	        None		    ""											                true		       true	   	} \
		{pll_slf_rst    			BOOLEAN		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_pll_slf_rst \
					                false			   false	        None		    ""	\
									true		       true	  	} \
		{pll_fbclk_mux_1			STRING		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_fb_params	\
					                "glb"			   false	        None		    "" \
									true 		       true	  	} \
		{pll_fbclk_mux_2			STRING		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_fb_params	\
                					"fb_1"			   false	        None		    "" \
									true		       true		} \
		{pll_m_cnt_in_src			STRING		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_fb_params \
						            "c_m_cnt_in_src_ph_mux_clk"	 false  None	        ""	\
									true		       true		} \
		{pll_clkin_0_src			STRING		       false		    false			""	\
	                             	::altera_pll_physical_parameters::update_pll_clkin_0_src \
                   				    "clk_0"			   false	        None		    "" \
									true		       true	  	} \
		{refclk1_frequency			STRING		       false		    false			"" \
			                        ::altera_pll_physical_parameters::update_refclk_switchover_params \
		                            "100.0 MHz"		   false	        None		    ""											                true		       true	   	} \
		{pll_clk_loss_sw_en			BOOLEAN		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_refclk_switchover_params \
		                            false			   false	        None		    ""											                true		       true				} \
		{pll_manu_clk_sw_en			BOOLEAN		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_refclk_switchover_params \
	                             	false			   false	        None	    	""											                true		       true				} \
		{pll_auto_clk_sw_en			BOOLEAN		       false		    false			"" \
			                        ::altera_pll_physical_parameters::update_refclk_switchover_params \
		                            false			   false	        None	    	""											                true		       true				} \
		{pll_clkin_1_src			STRING		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_refclk_switchover_params \
		                            "clk_0"			   false	        None	     	""											                true		       true				} \
		{pll_clk_sw_dly				INTEGER		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_refclk_switchover_params \
	                              	0				   false	        None	    	""											                true		       true				} \
		\
		{pll_extclk_0_cnt_src		STRING		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_extclk_cnt_src_params	\
		                            "pll_extclk_cnt_src_vss"  false	    None		    ""											                true		       true				} \
		{pll_extclk_1_cnt_src		STRING		       false		    false			""	\
		                            ::altera_pll_physical_parameters::update_extclk_cnt_src_params \
			                        "pll_extclk_cnt_src_vss"   false	None		    ""											                true		       true				} \
		
        {pll_lock_fltr_cfg		    INTEGER		       false		    false			{ND} \
	                                ::altera_pll_physical_parameters::update_pll_lock_fltr  \
            	                    100                false	        None	        ""	\
									true		       true				} \
		{pll_unlock_fltr_cfg	    INTEGER		       false		    false			{ND} \
	                                ::altera_pll_physical_parameters::update_pll_lock_fltr \
                                  	2                  false	        None	    	"" \
 									true		       true				} \
        {lock_mode      		    STRING		       false		    false			{ND} \
	                                ::altera_pll_physical_parameters::update_pll_lock_fltr  \
            	                    "mid_lock_time"    false	        None	        ""	\
									true		       true				} \
        {clock_to_compensate		INTEGER		       false		    true			{ND} \
		                            ::altera_pll_physical_parameters::update_fb_params \
             			            0                  false        	None	    	""										                 	true	           true				} \
        {clock_name_global  		BOOLEAN		       false		    true		    {ND}   \
                            		::altera_pll_physical_parameters::update_clock_names  \
                    	            0                  false	        None		    "" \
 									true		       true		  	} \
	}
	
	set physical_multiple_parameters {\
		{NAME						TYPE		INSTANCES	    MIF_PARAM	VIRTUAL_PARAM 	FAMILY \
	                                VALIDATION_CALLBACK	 	    DEFAULT_VALUE	            VISIBLE	\
                                 	UNITS	ALLOWED_RANGES				DERIVED	} \
		{c_cnt_hi_div#				INTEGER		0-17			true		false			""	\
	                                NOVAL   	                1			false		    None \
                         	        {1:256}		true	} \
		{c_cnt_lo_div#				INTEGER		0-17			true		false			"" \
		                            NOVAL						1			false		    None \
                                  	{1:256}		true	} \
		{c_cnt_prst#				INTEGER		0-17			true		false			"" \
		                            NOVAL						1			false		    None \
                                	{1:256}		true	} \
		{c_cnt_ph_mux_prst#			INTEGER		0-17			true		false			"" \
	                            	NOVAL						0			false		    None \
                                 	{0:7}		true	} \
		{c_cnt_in_src#				STRING		0-17			true		false			""  \
                                 	NOVAL	   "c_m_cnt_in_src_ph_mux_clk"  false		    None \
                                   	""       	true	} \
		{c_cnt_bypass_en#			BOOLEAN		0-17			true		false			""	\
	                                NOVAL						true		false		    None \
                                  	""			true	} \
		{c_cnt_odd_div_duty_en#		BOOLEAN		0-17			true		false			""	\
	                                NOVAL						false		false		    None \
                                 	""			true	} \
		\
		{output_clock_frequency#	STRING		0-17			false		true			""	\
	                                NOVAL						"0 MHz"		false		    None \
                                	""			true	} \
		{phase_shift#				STRING		0-17			false		true			"" \
                              		NOVAL						"0 ps"		false	    	None \
                                   	""			true	} \
		{duty_cycle#				INTEGER		0-17			false		true			"" \
                            		NOVAL	                	50		   	false		    None \
                                 	""			true	} \
		\
		{clock_name_#				STRING		0-8				false		true			{NF ND}	\
                                    ::altera_pll_physical_parameters::update_clock_names \
                                                            	""	    	false		    None \
                                	""		    true	} \
        {clock_name_global_#		BOOLEAN		0-8				false		true			{NF} \
                                 	::altera_pll_physical_parameters::update_clock_names \
                                                             	""			false		None \
                                 	""			true	} \
	}
	
	# +------------------------------
	# | Physical parameter table entries
	# | The FUNCTION_PARAMS entry determines how the value in the table is calculated. 
	# | (possible values are defined below)
	# |
	set physical_param_table {\
		{NAME							INSTANCES	FUNCTION_PARAMS						} \
		{"M-Counter Divide Setting"		""		\
                      	{sum_if_not_else m_cnt_hi_div m_cnt_lo_div m_cnt_bypass_en 1} 	} \
		{"N-Counter Divide Setting"		""		\
                    	{sum_if_not_else n_cnt_hi_div n_cnt_lo_div n_cnt_bypass_en 1} 	} \
		{"VCO Frequency"				""			{value pll_output_clk_frequency} 	} \
		{"C-Counter-# Divide Setting"	0-17	\
                   	{sum_if_not_else c_cnt_hi_div# c_cnt_lo_div# c_cnt_bypass_en# 1} 	} \
		{"PLL Auto Reset"			    ""			{value pll_slf_rst}					} \
		{"M-Counter Hi Divide"			""			{value m_cnt_hi_div}			 	} \
		{"M-Counter Lo Divide"			""			{value m_cnt_lo_div}				} \
		{"M-Counter Even Duty Enable"	""			{value m_cnt_odd_div_duty_en} 		} \
		{"M-Counter Bypass Enable"		""			{value m_cnt_bypass_en} 			} \
		{"N-Counter Hi Divide"			""			{value n_cnt_hi_div}			 	} \
		{"N-Counter Lo Divide"			""			{value n_cnt_lo_div}				} \
		{"N-Counter Even Duty Enable"	""			{value n_cnt_odd_div_duty_en} 		} \
		{"N-Counter Bypass Enable"		""			{value n_cnt_bypass_en} 			} \
		{"C-Counter-# Hi Divide"		0-17		{value c_cnt_hi_div#}			 	} \
		{"C-Counter-# Lo Divide"		0-17		{value c_cnt_lo_div#}				} \
		{"C-Counter-# Even Duty Enable"	0-17		{value c_cnt_odd_div_duty_en#} 		} \
		{"C-Counter-# Bypass Enable"	0-17		{value c_cnt_bypass_en#} 			} \
		{"C-Counter-# Preset"		    0-17		{value c_cnt_prst#}			 	    } \
		{"C-Counter-# Phase Mux Preset" 0-17		{value c_cnt_ph_mux_prst#}	    	} \
		{"Charge Pump Current"	        ""		    {value pll_cp_current} 		    	} \
		{"Bandwidth Control"	        ""		    {value pll_bwctrl} 		    	    } \
	}

	proc get_altera_pll_physical_parameters_as_array {} {
		variable altera_pll_ports
		return [::altera_iopll::util::extract_columns_as_array \
                NAME {DIRECT_MAPPING MAPPING_FUNCTION} $altera_pll_ports]
	}
	
	proc make_phys_param_table_ordered_lists {{input_instances ""}} {
		# Description: Make an array with two columns NAME_LIST and VALUE_LIST which will be ordered
		# in the order of the desired contents of the array
		variable physical_param_table
	
		# Split header and data
		::altera_iopll::util::extract_header_and_data $physical_param_table header data_less_header
		
		# List the expected columns
		set expected_columns {NAME INSTANCES FUNCTION_PARAMS}
	
		::altera_iopll::util::get_index_array_from_column_list $header $expected_columns index_array
	
		foreach row $data_less_header {
			
			set name 			[lindex $row $index_array(NAME)]
			set instances		[lindex $row $index_array(INSTANCES)]
			set function_params	[lindex $row $index_array(FUNCTION_PARAMS)]
			
			if {$input_instances != "" && $instances != ""} {
				set instances $input_instances
			}
			if {$instances == ""} {
				lappend name_list $name
				set value [determine_table_value $function_params]
				lappend value_list $value
			} else {
				#convert instances into a useful range
				set instances [::altera_iopll::util::convert_range_to_list $instances]
				
				#convert function params into a useful list
				foreach i $instances {
					set new_list [list]
					foreach element $function_params {
						set new_value [::altera_iopll::util::replace_symbol_with_integer $element # $i]
						lappend new_list $new_value
					}
					
					set value [determine_table_value $new_list]
					
					set instance_name [::altera_iopll::util::replace_symbol_with_integer $name # $i]	
					lappend name_list $instance_name
					lappend value_list $value
				}
			}
		}
		
		array set outputarray [list NAMES $name_list VALUES $value_list]
		return [array get outputarray]
	}
	
	proc determine_table_value {arg} {
		set procedure [lindex $arg 0]
		switch $procedure {
			"value" {
				set param [lindex $arg 1]
				return [get_parameter_value $param]
			}
			"sum" {
				set param1 [lindex $arg 1]
				set param2 [lindex $arg 2]
				set val1 [get_parameter_value $param1]
				set val2 [get_parameter_value $param2]
				set ret_val [expr {$val1 + $val2}]
				return $ret_val
			}
			"sum_if_not_else" {
				set param1 [lindex $arg 1]
				set param2 [lindex $arg 2]
				set param3 [lindex $arg 3]
				set val1 [get_parameter_value $param1]
				set val2 [get_parameter_value $param2]
				set val3 [get_parameter_value $param3]
				set val4 [lindex $arg 4]
				if {$val3} {
					set ret_val $val4
				} else {
					set ret_val [expr {$val1 + $val2}]
				}
				return $ret_val
			}
			default {
				error "unknown procedure type. do you need to update this case statement?"
			}
		}
	}
	
	proc does_current_family_support_this_param {allowable_families family} {
		if {$allowable_families == "" } {
			return true
		}
		switch $family {
			"Arria 10" {
				if {[lsearch $allowable_families "NF"] != -1 || [lsearch $allowable_families "20nm"] != -1 } {
					return true
				}
			}
            "Stratix 10" {
				if { [lsearch $allowable_families "ND"] != -1 || [lsearch $allowable_families "14nm"] != -1} {
					return true
				}
			}
			"Arria V" {
				if {[lsearch $allowable_families "AV"] != -1 || [lsearch $allowable_families "28nm"] != -1} {
					return true
				}			
			}
			"Cyclone V" {
				if {[lsearch $allowable_families "CV"] != -1 || [lsearch $allowable_families "28nm"] != -1} {
					return true
				}
			}
			"Stratix V" {
				if {[lsearch $allowable_families "SV"] != -1 || [lsearch $allowable_families "28nm"] != -1} {
					return true
				}
			}
			default {
				return false
			}
		}
		return false
	}

	proc get_debug_parameters_list {family} {
		variable debug_physical_params
		set master_list [list]
        
        # Add the debug params as physical params. SHould only be generated if debug_mode is true
		set physical_params [::altera_iopll::util::extract_columns_as_array \
                            NAME {VIRTUAL_PARAM FAMILY} $debug_physical_params] 
		
		# Foreach physical parameter, determine whether we want to add it
		foreach {parameter_name param_data} $physical_params {
			array set param_data_array $param_data
			set allowable_families $param_data_array(FAMILY)
			set virtual $param_data_array(VIRTUAL_PARAM)
			
            if {[does_current_family_support_this_param $allowable_families $family]} {
                lappend master_list $parameter_name
            }	
		}
 		
		set master_list [lsort $master_list]
		return $master_list 
    }

	proc get_parameter_list {family {get_enabled_only true}} {
		# If param == virtual -> get hdl parameters
		# Possible values for "family" = 28nm, CV, AV, SV, NF, 20nm
	
		variable physical_parameters
		variable physical_multiple_parameters
        variable debug_physical_params
		set master_list [list]
		
		# Get the VIRTUAL_PARAM and FAMILY columns from the physical parmaeter table
		set physical_params [::altera_iopll::util::extract_columns_as_array \
                               NAME {VIRTUAL_PARAM FAMILY} $physical_parameters] 
		
		# Foreach physical parameter, determine whether we want to add it
		foreach {parameter_name param_data} $physical_params {
			array set param_data_array $param_data
			set allowable_families $param_data_array(FAMILY)
			set virtual $param_data_array(VIRTUAL_PARAM)
			set parameter_is_enabled [get_parameter_property $parameter_name ENABLED]
			
			if {($get_enabled_only && $parameter_is_enabled) || !$get_enabled_only} {
                if {[does_current_family_support_this_param $allowable_families $family]} {
                    lappend master_list $parameter_name
                }				
			}
		}
		
		# Now repeat for the multiple physical parameters
		# But don't instance expand them
		set physical_params [::altera_iopll::util::extract_columns_as_array \
                            NAME {VIRTUAL_PARAM FAMILY} $physical_multiple_parameters]
		
		# Foreach physical parameter, determine whether we want to add it
		foreach {parameter_name param_data} $physical_params {
			array set param_data_array $param_data
			set allowable_families $param_data_array(FAMILY)
			set virtual $param_data_array(VIRTUAL_PARAM)

			# Boolean function which determines whether or not a parameter should be added
			set parameter_is_enabled [get_parameter_property $parameter_name ENABLED]

			if {($get_enabled_only && $parameter_is_enabled) || !$get_enabled_only} {
                if {[does_current_family_support_this_param $allowable_families $family]} {
                    lappend master_list $parameter_name
				}	
			}
		}
		
        # Add the debug params as physical params. SHould only be generated if debug_mode is true
		set physical_params [::altera_iopll::util::extract_columns_as_array \
                            NAME {VIRTUAL_PARAM FAMILY} $debug_physical_params] 
		# Foreach physical parameter, determine whether we want to add it
		foreach {parameter_name param_data} $physical_params {
			array set param_data_array $param_data
			set allowable_families $param_data_array(FAMILY)
			set virtual $param_data_array(VIRTUAL_PARAM)
			set parameter_is_enabled [get_parameter_property $parameter_name ENABLED]
			
			if {($get_enabled_only && $parameter_is_enabled) || !$get_enabled_only} {
                if {[does_current_family_support_this_param $allowable_families $family]} {
                    lappend master_list $parameter_name
                }				
			}	
		}
		set master_list [lsort $master_list]
		return $master_list
	}
	
	proc declare_parameters_for_display {parameters} {
		::altera_iopll::util::declare_hwtcl_parameters $parameters false
	}			
}

namespace eval initialize_dropdowns {
	proc initialize_dropdowns {} {
        ::altera_iopll::update_callbacks::initialize_dropdowns
	}	
}

# +===========================================================================================================
# | MAIN CALLBACK

# pll hw extra
source altera_iopll_hw_upgrade.tcl
source altera_iopll_hw_validation.tcl
source altera_iopll_hw_elaboration.tcl
source altera_iopll_hw_generation.tcl

# 17 ensures full floating point precision
set tcl_precision 17

# +-----------------------------------
# | Error handling 
interp alias {} TCL_OK {} error_code_0
interp alias {} TCL_ERROR {} error_code_1
proc error_code_0 {} {
	return 0
}
proc error_code_1 {} {
	return 1
}


# +-----------------------------------
# | Create the module etc. 
set WIZARD_NAME "altera_iopll"

# -- STEP 1: Create the altera_pll_module and create the filesets
altera_iopll::module::declare_module 	
altera_iopll::module::declare_filesets 

# -- STEP 2: Add all the gui items to the gui
altera_pll_gui_params::add_all_items_to_display

# -- STEP 3: Add all the static interfaces and ports
altera_pll_interfaces::add_static_interfaces
altera_pll_interfaces::add_static_ports

# --- STEP 4: Add all the non-display parameters
altera_pll_physical_parameters::declare_parameters_for_display \
              $altera_pll_physical_parameters::physical_non_hdl
altera_pll_physical_parameters::declare_parameters_for_display \
              $altera_pll_physical_parameters::physical_parameters
altera_pll_physical_parameters::declare_parameters_for_display \
              $altera_pll_physical_parameters::physical_multiple_parameters
altera_pll_physical_parameters::declare_parameters_for_display \
              $altera_pll_physical_parameters::debug_physical_params

# -- STEP 5: Add all the helper parameters (also non-display)
altera_pll_helper_gui_parameters::declare_parameters_for_display \
             $altera_pll_helper_gui_parameters::helper_parameters
altera_pll_helper_gui_parameters::declare_parameters_for_display \
             $altera_pll_helper_gui_parameters::helper_parameters_multiple

# --- Set module assignments for Device Tree Generation (FB 323294)
set_module_assignment embeddedsw.dts.group clock
set_module_assignment embeddedsw.dts.compatible {altr,pll}
set_module_assignment embeddedsw.dts.vendor altr

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" \
              https://documentation.altera.com/#/link/mcn1403678389838/mcn1403678554052
add_documentation_link "Release Notes" \
              https://dopertocumentation.altera.com/#/link/hco1421698042087/hco1421698013408
