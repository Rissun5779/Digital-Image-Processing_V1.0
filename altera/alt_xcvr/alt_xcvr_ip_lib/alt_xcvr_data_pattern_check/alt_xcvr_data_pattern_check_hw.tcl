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


lappend auto_path $env(QUARTUS_ROOTDIR)/../ip/altera/alt_xcvr/alt_xcvr_tcl_packages

package require -exact qsys 14.0
package require -exact alt_xcvr::ip_tcl::ip_module 13.0
package require alt_xcvr::ip_tcl::ip_interfaces
package require alt_xcvr::ip_tcl::messages

namespace import ::alt_xcvr::ip_tcl::ip_module::*
namespace import ::alt_xcvr::ip_tcl::ip_interfaces::*
namespace import ::alt_xcvr::ip_tcl::messages::*

# Declare the module using a nested list. First list is header, second list is property values
set module {\
  {NAME                    	  VERSION INTERNAL              VALIDATION_CALLBACK                    ELABORATION_CALLBACK                       DISPLAY_NAME                       GROUP                          AUTHOR   }\
  {alt_xcvr_data_pattern_check      15.1    true     alt_xcvr_data_pattern_check_val_callback     alt_xcvr_data_pattern_check_elab_callback    "Data Pattern Checker"    "Interface Protocols/Transceiver PHY"     "Altera Corporation"}\
}


# Declare the fileset using a nested list. First list is a header row.
set filesets {\
  {NAME            TYPE            CALLBACK                TOP_LEVEL     }\
  {quartus_synth   QUARTUS_SYNTH   callback_quartus_synth  alt_xcvr_data_pattern_check_top}\
  {sim_verilog     SIM_VERILOG     callback_sim_verilog    alt_xcvr_data_pattern_check_top}\
  {sim_vhdl        SIM_VHDL        callback_sim_vhdl       alt_xcvr_data_pattern_check_top}\
}

set display_items {\
  {NAME               GROUP             TYPE  ARGS  }\
  {"General Options"  ""                GROUP NOVAL }\
  {"Patterns"         ""                GROUP NOVAL }\
}


# Declare the parameters using a nested list. First list is a header row.
set parameters {\
  {NAME                 TYPE     DERIVED HDL_PARAMETER DEFAULT_VALUE ALLOWED_RANGES ENABLED   VISIBLE                     									      DISPLAY_HINT    DISPLAY_NAME                            DISPLAY_ITEM              DESCRIPTION                                                                                                                                                  VALIDATION_CALLBACK}\
  {design_environment   STRING   false   false         "QSYS"        NOVAL           true      false                        										NOVAL         NOVAL                                    NOVAL                       NOVAL																				NOVAL}\
  {DATA_WIDTH           integer  false   true          16            "1:128"         true      true                         										NOVAL         "Data Width"                             "General Options"           "Specifies the data width of the data pattern to be verified"													NOVAL}\
  {CHANNELS             integer  false   true          1             "1:96"          true      true                         										NOVAL         "Number of channels"                     "General Options"           "Specifies the number of channels"																        NOVAL}\
  {NUM_MATCHES_FOR_LOCK integer  false   true          16            "4:32"          true      true                         										NOVAL         "Number of matches needed to lock"       "General Options"           "SPecifies the number of consecutive data match needed for checker to get into the locked state. For more info, check the FD"					NOVAL}\
  {ERROR_WIDTH          integer  false   true          8             "4:32"          true      false                        										NOVAL         "Width of the accumulated errors"        "General Options"           NOVAL																				NOVAL}\
  {PATTERN_ADDR_WIDTH   integer  false   true          4             NOVAL           true      false        	            										NOVAL         "Width of the pattern address"           "General Options"           NOVAL																				NOVAL}\
  {SPLIT_INTERFACE_EN   integer  false   false         0             NOVAL           true      true                        										boolean       "Seperate interface per channel"         "General Options"           "If enabled, splits the inputs and outputs per number of channels"													NOVAL}\
  {UNLOCK               integer  false   true          1             NOVAL           true      true                         										boolean       "Enable unlocking feature"               "General Options"           "If enabled the checker will have the unlocking feature enabled. For more info, check the FD"									NOVAL}\
  {AVMM_EN              integer  false   true          0             NOVAL           true      true         	            										boolean       "Enable AVMM interface"                  "General Options"           "If eanbled, the user will have the option to control the generator via AVMM interface"										NOVAL}\
  {STATIC_PATTERN_EN    integer  false   false         0             NOVAL           true      true         	           										boolean       "Static Pattern"                         "General Options"           "If enabled, the generator will generate only one pattern, specified by the user"											NOVAL}\
  {STATIC_PATTERN       integer  false   false         0             NOVAL           true      "STATIC_PATTERN_EN"          										boolean       "Choose a pattern"                       "Patterns"                  "The data pattern generator will generate the data  according to the chosen static pattern"										NOVAL}\
  {L_STATIC_PATTERN     integer  true    false         0             NOVAL           true      false                                                                                                    NOVAL         NOVAL                                    NOVAL                       NOVAL                                                                                                                                                                validate_l_static_pattern}\
  {SET_PRBS7            integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"         										boolean       "Prbs-7"         		               "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"									                                NOVAL}\
  {SET_PRBS9            integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"         										boolean       "Prbs-9"                                 "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_PRBS10           integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"         										boolean       "Prbs-10"                                "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_PRBS15           integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"         										boolean       "Prbs-15"                                "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_PRBS23           integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"        										boolean       "Prbs-23"                                "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_PRBS31           integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"         										boolean       "Prbs-31"                                "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_WALKING          integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"         										boolean       "Walking pattern"                        "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_COUNTER          integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"        										boolean       "Counter"                                "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_EXTERNAL         integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"         										boolean       "External Data Pattern"                  "Patterns"                  "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {SET_INVERTED_PRBS    integer  false   false         1             NOVAL           true      "!STATIC_PATTERN_EN"        										boolean       "Inverted Prbs"                          "Patterns"              	   "Enable the patterns to be used in dynamic pattern configuration"													NOVAL}\
  {PRBS7                integer  true    true          1             NOVAL           true      false                      										NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_prbs7}\
  {PRBS9                integer  true    true          1             NOVAL           true      false         												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_prbs9}\
  {PRBS10               integer  true    true          1             NOVAL           true      false         												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_prbs10}\
  {PRBS15               integer  true    true          1             NOVAL           true      false         												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_prbs15}\
  {PRBS23               integer  true    true          1             NOVAL           true      false        												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_prbs23}\
  {PRBS31               integer  true    true          1             NOVAL           true      false         												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_prbs31}\
  {WALKING              integer  true    true          1             NOVAL           true      false         												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_walking}\
  {COUNTER              integer  true    true          1             NOVAL           true      false        												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_counter}\
  {EXTERNAL             integer  true    true          1             NOVAL           true      false         												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_external}\
  {INVERTED_PRBS        integer  true    true          1             NOVAL           true      false        												NOVAL         NOVAL                                    NOVAL                        NOVAL																				validate_inverted}\
}

# Declare the ports and interfaces using a nested list. First list is a header row.
set ports {\
 {NAME                 DIRECTION UI_DIRECTION  WIDTH_EXPR             ROLE                TERMINATION    							                                                                                            TERMINATION_VALUE    IFACE_NAME            IFACE_TYPE      IFACE_DIRECTION DYNAMIC     SPLIT            SPLIT_WIDTH      SPLIT_COUNT   ELABORATION_CALLBACK }\
 {clk                  input     input         CHANNELS               clk                 false          																			NOVAL              clk                   clock           sink            true     SPLIT_INTERFACE_EN     1           CHANNELS      NOVAL}\
 {reset                input     input         CHANNELS               reset               false         								 											NOVAL              reset                 reset           sink            true     SPLIT_INTERFACE_EN     1           CHANNELS      elaborate_interfaces}\
 {enable               input     input         CHANNELS               conduit             false          																			NOVAL              enable                conduit         end             true     SPLIT_INTERFACE_EN     1           CHANNELS      NOVAL}\
 {data_in              input     input         CHANNELS*DATA_WIDTH    rx_parallel_data    false          																			NOVAL              data_in               conduit         end             true     SPLIT_INTERFACE_EN     DATA_WIDTH  CHANNELS      NOVAL}\
 {pattern              input     input         CHANNELS*4             conduit             STATIC_PATTERN_EN          																		L_STATIC_PATTERN   pattern               conduit         end             true     SPLIT_INTERFACE_EN     4           CHANNELS      NOVAL}\
 {ext_data_pattern     input     input         CHANNELS*DATA_WIDTH    conduit             "((!WALKING) && (!EXTERNAL)) || (STATIC_PATTERN_EN && (STATIC_PATTERN != 0) && (STATIC_PATTERN != 7))"  								NOVAL              ext_data_pattern      conduit         end             true     SPLIT_INTERFACE_EN     DATA_WIDTH  CHANNELS      NOVAL}\
 {error_flag           output    output        CHANNELS               conduit             false          																			NOVAL              error_flag            conduit         end             true     SPLIT_INTERFACE_EN     1           CHANNELS      NOVAL}\
 {is_data_locked       output    output        CHANNELS               conduit             false          																			NOVAL              is_data_locked        conduit         end             true     SPLIT_INTERFACE_EN     1           CHANNELS      NOVAL}\
 {avmm_clk             input     input         CHANNELS               clk                 "!AVMM_EN"         																			NOVAL              avmm_clk              clock           sink            true     SPLIT_INTERFACE_EN     1           CHANNELS      NOVAL}\
 {avmm_reset           input     input         CHANNELS               reset               "!AVMM_EN"          																			0                  avmm_reset            reset           slave           true     SPLIT_INTERFACE_EN     1           CHANNELS      elaborate_avmm_reset}\
 {avmm_write           input     input         CHANNELS               write               "!AVMM_EN"          																			0                  avmm                  avalon          slave           true     SPLIT_INTERFACE_EN     1           CHANNELS      elaborate_avmm}\
 {avmm_read            input     input         CHANNELS               read                "!AVMM_EN"          																			0                  avmm                  avalon          slave           true     SPLIT_INTERFACE_EN     1           CHANNELS      NOVAL}\
 {avmm_writedata       input     input         CHANNELS*32            writedata           "!AVMM_EN"          																			0                  avmm                  avalon          slave           true     SPLIT_INTERFACE_EN     32          CHANNELS      NOVAL}\
 {avmm_address         input     input         CHANNELS*4             address             "!AVMM_EN"          																			0                  avmm                  avalon          slave           true     SPLIT_INTERFACE_EN     4           CHANNELS      NOVAL}\
 {avmm_readdata        output    output        CHANNELS*32            readdata            "!AVMM_EN"          																			NOVAL              avmm                  avalon          slave           true     SPLIT_INTERFACE_EN     32          CHANNELS      NOVAL}\
 {avmm_waitrequest     output    output        CHANNELS               waitrequest         "!AVMM_EN"          																			NOVAL              avmm                  avalon          slave           true     SPLIT_INTERFACE_EN     1           CHANNELS      NOVAL}\
}

ip_declare_module $module
ip_declare_filesets $filesets
ip_declare_parameters $parameters
ip_set_auto_conduit_in_native_mode 1
ip_set_iface_split_suffix "_ch"
ip_declare_interfaces $ports
ip_set "parameter.design_environment.SYSTEM_INFO" DESIGN_ENVIRONMENT
ip_set "parameter.STATIC_PATTERN.allowed_ranges" [list "0:External Data Pattern" "1:Prbs-7" "9:Inverted Prbs-7" "2:Prbs-9" "10:Inverted Prbs-9" "3:Prbs-10" "11:Inverted Prbs-10s" "4:Prbs-15" "12:Inverted Prbs-15" "5:Prbs-23" "13:Inverted Prbs-23" "6:Prbs31" "14:Inverted Prbs-31" "7:Walking Pattern" "8:Counter"]

proc elaborate_interfaces { PROP_IFACE_SPLIT_INDEX PROP_IFACE_NAME design_environment SPLIT_INTERFACE_EN CHANNELS DATA_WIDTH} {
    set channels [expr {$SPLIT_INTERFACE_EN ? 1 : $CHANNELS}]
    set sfx [expr {$SPLIT_INTERFACE_EN ? "_ch${PROP_IFACE_SPLIT_INDEX}" : ""}]
    set add_offset [expr 1 * $PROP_IFACE_SPLIT_INDEX]
    #                            condition               pname                src_port        dir      channels    sing_ch_width  grp_width   words       width         offset   used     add_offset  
    #create_fragmented_interface  $SPLIT_INTERFACE_EN    "clk${sfx}"          "clk"           input    $channels   1              1           1           1             0        used     $add_offset
    #create_fragmented_interface  $SPLIT_INTERFACE_EN    "reset${sfx}"        "reset"         input    $channels   1              1           1           1             0        used     $add_offset
  
    if { $design_environment != "NATIVE" } {
    set clk "clk"
    set reset "reset"
    if {$SPLIT_INTERFACE_EN} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {clk\1} clk  
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {reset\1} reset  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $clk
  }
}

proc elaborate_avmm_reset { PROP_IFACE_SPLIT_INDEX PROP_IFACE_NAME design_environment SPLIT_INTERFACE_EN  } {
  if { $design_environment != "NATIVE" } {
    set avmm_clk "avmm_clk"
    if {$SPLIT_INTERFACE_EN} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {avmm_clk\1} avmm_clk  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $avmm_clk
  }
}


proc elaborate_avmm { PROP_IFACE_SPLIT_INDEX PROP_IFACE_NAME design_environment SPLIT_INTERFACE_EN } {
  if { $design_environment != "NATIVE" } {
    set avmm_reset "avmm_reset"
    set avmm_clk "avmm_clk"
    if {$SPLIT_INTERFACE_EN} {
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {avmm_clk\1} avmm_clk    
      regsub {.*(_ch.*)} $PROP_IFACE_NAME {avmm_reset\1} avmm_reset  
    }
    ip_set "interface.${PROP_IFACE_NAME}.associatedclock" $avmm_clk
    ip_set "interface.${PROP_IFACE_NAME}.associatedreset" $avmm_reset
  }
}

# this is added to propogate static_pattern to multiple channels properly
proc validate_l_static_pattern { PROP_NAME PROP_VALUE STATIC_PATTERN CHANNELS PATTERN_ADDR_WIDTH} {
  set value 0
  for {set idx 0} {$idx < $CHANNELS} {incr idx} {
    set value [expr {$value + ($STATIC_PATTERN * ((2**$PATTERN_ADDR_WIDTH)**$idx))}];# ptrn+ptrn*16+ptrn*16*16 
  }
 ip_set "parameter.${PROP_NAME}.value" $value
} 

proc validate_prbs7 { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_PRBS7 } {

 set value [expr {($STATIC_PATTERN_EN) ? ((($STATIC_PATTERN == "1") || ($STATIC_PATTERN == "9")) ? "1" : "0") : $SET_PRBS7}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_prbs9 { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_PRBS9 } {

 set value [expr {($STATIC_PATTERN_EN) ? ((($STATIC_PATTERN == "2") || ($STATIC_PATTERN == "10")) ? "1" : "0") : $SET_PRBS9}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_prbs10 { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_PRBS10 } {

 set value [expr {($STATIC_PATTERN_EN) ? ((($STATIC_PATTERN == "3") || ($STATIC_PATTERN == "11")) ? "1" : "0") : $SET_PRBS10}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_prbs15 { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_PRBS15 } {

 set value [expr {($STATIC_PATTERN_EN) ? ((($STATIC_PATTERN == "4") || ($STATIC_PATTERN == "12")) ? "1" : "0") : $SET_PRBS15}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_prbs23 { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_PRBS23 } {

 set value [expr {($STATIC_PATTERN_EN) ? ((($STATIC_PATTERN == "5") || ($STATIC_PATTERN == "13")) ? "1" : "0") : $SET_PRBS23}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_prbs31 { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_PRBS31 } {

 set value [expr {($STATIC_PATTERN_EN) ? ((($STATIC_PATTERN == "6") || ($STATIC_PATTERN == "14")) ? "1" : "0") : $SET_PRBS31}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_external { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_EXTERNAL } {

 set value [expr {($STATIC_PATTERN_EN) ? (($STATIC_PATTERN == "0") ? "1" : "0") : $SET_EXTERNAL}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_counter { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_COUNTER } {

 set value [expr {($STATIC_PATTERN_EN) ? (($STATIC_PATTERN == "8") ? "1" : "0") : $SET_COUNTER}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_walking { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_WALKING } {

 set value [expr {($STATIC_PATTERN_EN) ? (($STATIC_PATTERN == "7") ? "1" : "0") : $SET_WALKING}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc validate_inverted { PROP_NAME PROP_VALUE STATIC_PATTERN_EN STATIC_PATTERN SET_INVERTED_PRBS } {

 set value [expr {($STATIC_PATTERN_EN) ? ((($STATIC_PATTERN == "9") || ($STATIC_PATTERN == "10") || ($STATIC_PATTERN == "11") || ($STATIC_PATTERN == "12") || ($STATIC_PATTERN == "13") || ($STATIC_PATTERN == "14")) ? "1" : "0") : $SET_INVERTED_PRBS}]
 ip_set "parameter.${PROP_NAME}.value" $value
}

proc alt_xcvr_data_pattern_check_val_callback {} {  
  ip_validate_parameters
}

proc alt_xcvr_data_pattern_check_elab_callback {} {
  ip_elaborate_interfaces
}

proc elaborate_nreset {} {
  ip_set "interface.nreset.synchronousEdges" none
}

proc elaborate_reset {} {
  ip_set "interface.reset.synchronousEdges" none
}

proc callback_quartus_synth { entity } {
  add_fileset_file ./alt_xcvr_data_pattern_check_avmm_h.sv        SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_avmm_h.sv 
  add_fileset_file ./alt_xcvr_data_pattern_check_top.sv           SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_top.sv  
  add_fileset_file ./alt_xcvr_data_pattern_check.sv               SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check.sv
  add_fileset_file ./alt_xcvr_data_pattern_check_main.sv          SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_main.sv 
  add_fileset_file ./alt_xcvr_data_pattern_check_avmm_csr.sv      SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_avmm_csr.sv 
  add_fileset_file ./alt_xcvr_data_pattern_prbs_poly.sv           SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_prbs_poly.sv 
  add_fileset_file ./alt_xcvr_resync.sv                           SYSTEM_VERILOG PATH  ./alt_xcvr_resync.sv
}

proc callback_sim_verilog { entity } {
  add_fileset_file ./alt_xcvr_data_pattern_check_avmm_h.sv        SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_avmm_h.sv 
  add_fileset_file ./alt_xcvr_data_pattern_check_top.sv           SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_top.sv  
  add_fileset_file ./alt_xcvr_data_pattern_check.sv               SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check.sv
  add_fileset_file ./alt_xcvr_data_pattern_check_main.sv          SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_main.sv 
  add_fileset_file ./alt_xcvr_data_pattern_check_avmm_csr.sv      SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_avmm_csr.sv 
  add_fileset_file ./alt_xcvr_data_pattern_prbs_poly.sv           SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_prbs_poly.sv 
  add_fileset_file ./alt_xcvr_resync.sv                           SYSTEM_VERILOG PATH  ./alt_xcvr_resync.sv
}

proc callback_sim_vhdl { entity } {
  add_fileset_file ./alt_xcvr_data_pattern_check_avmm_h.sv        SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_avmm_h.sv 
  add_fileset_file ./alt_xcvr_data_pattern_check_top.sv           SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_top.sv  
  add_fileset_file ./alt_xcvr_data_pattern_check.sv               SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check.sv
  add_fileset_file ./alt_xcvr_data_pattern_check_main.sv          SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_main.sv 
  add_fileset_file ./alt_xcvr_data_pattern_check_avmm_csr.sv      SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_check_avmm_csr.sv 
  add_fileset_file ./alt_xcvr_data_pattern_prbs_poly.sv           SYSTEM_VERILOG PATH  ./alt_xcvr_data_pattern_prbs_poly.sv 
  add_fileset_file ./alt_xcvr_resync.sv                           SYSTEM_VERILOG PATH  ./alt_xcvr_resync.sv
}
