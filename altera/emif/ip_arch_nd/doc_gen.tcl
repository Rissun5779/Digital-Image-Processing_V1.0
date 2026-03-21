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


package provide altera_emif::ip_arch_nd::doc_gen 0.1

package require altera_emif::util::messaging
package require altera_emif::util::math
package require altera_emif::util::qini
package require altera_emif::util::doc_gen
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::ip_arch_nd::util

namespace eval ::altera_emif::ip_arch_nd::doc_gen:: {
   
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::device_family::*
   namespace import ::altera_emif::ip_arch_nd::util::*


}


proc ::altera_emif::ip_arch_nd::doc_gen::add_readme {docs_varname if_ports} {
   
   upvar 1 $docs_varname docs
   
   _add_readme_desc              docs "readme.txt" "About this file"                                     
   _add_filesets_desc            docs "readme.txt" "Outputs of IP generation"                                            
   _add_howto_inst_ip_qii        docs "readme.txt" "Instantiating IP in a Quartus Prime project"
   _add_early_io_timing_desc     docs "readme.txt" "Early I/O timing analysis"                           
   _add_io_asgmts_desc           docs "readme.txt" "I/O assignments"                                     $if_ports
   _add_pin_locs_desc            docs "readme.txt" "Pin locations"                                       $if_ports
   _add_howto_share_core_clks    docs "readme.txt" "Sharing core clocks between interfaces"
   _add_howto_share_pll_ref_clk  docs "readme.txt" "Sharing PLL reference clock pin between interfaces"  
   _add_howto_share_rzq_pin      docs "readme.txt" "Sharing RZQ pin between interfaces"                  
   _add_ifs_desc                 docs "readme.txt"                                                       $if_ports
   _add_howto_inst_ip_sim        docs "readme.txt" "Instantiating IP in a simulation project"
   _add_cal_mode_desc            docs "readme.txt" "Full-calibration versus skip-calibration simulation"
   _add_ip_settings              docs "readme.txt" "IP Settings"
}


proc ::altera_emif::ip_arch_nd::doc_gen::_add_readme_desc {docs_varname filename title} {

   upvar 1 $docs_varname docs

   set family_enum   [get_device_family_enum]
   set family_name   [enum_data $family_enum UI_NAME]
   set protocol_enum [get_parameter_value PROTOCOL_ENUM]
   set protocol_name [enum_data $protocol_enum UI_NAME]

   set lines [list \
      "This is the readme file for the Altera External Memory Interface (EMIF) IP v18.1." \
      "" \
      "The file provides a high-level overview of the IP. For details, refer to the" \
      "handbook chapter on $family_name $protocol_name External Memory Interface." \
      "" \
      "This file was auto-generated."]

   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_filesets_desc {docs_varname filename title} {

   upvar 1 $docs_varname docs

   set lines [list \
      "IP generation supports the following output filesets:" \
      "" \
      "   Synthesis            - This is the fileset you should use when instantiating the IP in" \
      "                          your Quartus Prime project. RTL files in this fileset can be" \
      "                          simulated, but your simulator must support SystemVerilog." \
      "                          Simulating the synthesis files yields identical results as" \
      "                          simulating the simulation files." \
      "" \
      "   Simulation           - This fileset contains scripts and source files to help you" \
      "                          integrate the IP into your simulation project targeting a" \
      "                          3rd-party simulator of your choice. If you select VHDL" \
      "                          during IP generation, the fileset contains IEEE-encrypted" \
      "                          Verilog files that can be used in VHDL-only simulators, such" \
      "                          as ModelSim Altera-Edition. All source files in the simulation" \
      "                          filesets are functionally equivalent to the synthesis fileset." \
      "" \
      "   Example Design       - This fileset contains scripts to generate example Quartus Prime project" \
      "                          and simulation projects for 3rd-party simulators. An example" \
      "                          design contains an instantiation of the IP, a simple traffic" \
      "                          generator, and in the case of a simulation example design, a" \
      "                          simple memory model."]
      
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_howto_inst_ip_qii {docs_varname filename title} {

   upvar 1 $docs_varname docs

   set lines [list \
      "If you instantiate the IP as part of a Qsys system, follow the Qsys" \
      "documentation on how to instantiate the system in a Quartus Prime project." \
      "" \
      "If the IP was generated as a standalone component, it is sufficient to add" \
      "the generated .qip file from the synthesis fileset to your Quartus Prime project." \
      "The .qip file allows the Quartus Prime software to locate all the files of" \
      "the IP, including RTL files, SDC files, hex files, and timing scripts. Once the" \
      ".qip file is added, you can instantiate the memory interface in your RTL."]
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_early_io_timing_desc {docs_varname filename title} {

   upvar 1 $docs_varname docs
   
   set lines [list \
      "Early I/O timing analysis allows you to run I/O timing analysis without first" \
      "running a Quartus Prime compilation. This is useful if you want to quickly evaluate" \
      "whether the I/O interface between the FPGA and the external memory device has" \
      "sufficient timing margin. The analysis takes into account the timing parameters" \
      "of the memory device, the speed and topology of the memory interface, the board" \
      "timing and ISI characteristics, and the timing of the selected FPGA device." \
      "" \
      "To run early I/O timing analysis:" \
      "" \
      "   1) Create a Quartus Prime project that instantiates the IP (or use the example design)" \
      "   2) Open the project in the Quartus Prime GUI" \
      "   3) Go to \"Tools\" -> \"TimeQuest Timing Analyzer\"" \
      "   4) Inside TimeQuest, Go to \"Script\" -> \"Run Tcl Script...\"" \
      "   5) Locate the *_report_io_timing.tcl script, and click \"Open\""]
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_io_asgmts_desc {docs_varname filename title if_ports} {

   upvar 1 $docs_varname docs

   set lines [list \
      "The generated .qip file in the synthesis fileset contains the I/O standard and input/output" \
      "termination assignments required by the memory interface pins to function correctly." \
      "The values to the assignments are based on user inputs provided during generation." \
      "" \
      "Unlike previous EMIF IP, there is no need to manually run a *_pin_assignments.tcl" \
      "script to annotate the assignments into the project's .qsf file." \
      "Assignments in the .qip file are read and applied during every compilation, regardless" \
      "of how you name the memory interface pins in your design top-level component. No new" \
      "assignment is created in the project's .qsf file during the process." \
      "" \
      "You should never edit the generated .qip file, because changes made to this file" \
      "are overwritten when you regenerate the IP. To override an I/O assignment made in" \
      "the .qip file, simply add an assignment to the project's .qsf file. Assignments in" \
      "the .qsf file always take precedence over those in the .qip file. Note that I/O" \
      "assignments in the .qsf file must specify the names of your top-level pins as" \
      "target (i.e. -to), and you must not use the -entity and -library options." \
      "" \
      "Consult the .qip file for the set of I/O assignments that come with the IP."]
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_pin_locs_desc {docs_varname filename title if_ports} {

   upvar 1 $docs_varname docs

   set family_enum [get_device_family_enum]
   set family_name [enum_data $family_enum UI_NAME]
   
   if {[get_is_hps]} {
      set lines [list \
         "External memory interface for the $family_name Hard Processor Subsystem (HPS)" \
         "must follow a specific pinout. This is unlike external memory interfaces that" \
         "do not target the HPS, where some flexibility exists." \
         "" \
         "Compile the interface through the Quartus Prime Fitter to obtain the HPS-specific" \
         "memory interface pinout. Alternatively, consult the device handbook and/or the" \
         "device pinout files." \
         "" \
         ]
   } else {
      set lines [list \
         "The $family_name I/O subsystem is located in the I/O columns. The device has up to" \
         "two I/O columns that can be used by memory interfaces. Each column consists of up" \
         "to 12 I/O banks. Each bank consists of 4 I/O lanes. A lane is a group of 12 I/Os." \
         "A bank is a group of 48 I/Os." \
         "" \
         "The pins of a memory interface must be placed within a single I/O column. A memory" \
         "interface can occupy one or more banks. When multiple banks are needed, the banks must" \
         "be consecutive." \
         "" \
         "All address/command pins of a memory interface must be placed within a single bank." \
         "This bank is denoted as the \"address/command\" bank. While any physical bank within" \
         "an I/O column can be used as an \"address/command\" bank, for a multi-bank memory" \
         "interface, the \"address/command\" bank must be at the center of the interface." \
         "" \
         "Address/command pins within the \"address/command\" bank must follow a fixed pinout" \
         "scheme within the bank. Note that the pinout scheme used is dependent on the topology" \
         "of the memory interface, and is a hardware requirement. An I/O lane unused in the" \
         "\"address/command\" bank can be used to implement a data group (e.g. a x8 DQS group)." \
         "" \
         "A read data group must be placed based on the DQS/CQ/QK grouping in the pin table." \
         "Specifically, read data strobes/clocks must be placed at physical pins capable of" \
         "functioning as DQS/CK/QK for a specific read data group size, and the associated" \
         "data pins must be placed within the same group." \
         "A x8/x9 read data group occupies one lane; a x16/x18 read data group occupies either" \
         "the top or bottom 2 lanes of a bank; a x36 read data group occupies all four lanes of" \
         "a bank. For protocols/topologies where a write data group consists of multiple read data" \
         "groups, the read data groups should be placed in the same bank to improve I/O timing." \
         ""\
         "I/Os that are unused by memory interface pins can be used as general-purpose I/Os with" \
         "compatible I/O standard and termination settings." \
         "" \
         "The following shows the suggested grouping of memory interface pins into logical banks. To" \
         "implement the scheme in your Quartus Prime project, you need to:" \
         "" \
         "   1) Decide which physical I/O banks the logical banks occupy." \
         "   2) Add location assignments for the following pins:" \
         "         All read data strobes/clocks (e.g. DQS/CQ/DQ)" \
         "         One of the address/command pins" \
         "         PLL reference clock pins (unless using a shared PLL reference clock pin in another interface)" \
         "         RZQ pin (unless using a shared RZQ pin in another interface)" \
         "      The Quartus Prime Fitter automatically places the remaining pins." \
         "" \
         ]
         
      set lanes_per_tile   [get_family_trait FAMILY_TRAIT_LANES_PER_TILE]
      set pins_per_lane    [get_family_trait FAMILY_TRAIT_PINS_PER_LANE]
      set mem_ports        [dict get $if_ports IF_MEM PORTS]
      set mem_pins_alloc   [dict get $if_ports IF_MEM PINS_ALLOC]
      set num_of_rtl_tiles [dict size $mem_pins_alloc]
      set ac_tile_i        [get_ac_tile_index $mem_ports]
      set ac_pm_scheme     [altera_emif::ip_arch_nd::protocol_expert::get_ac_pin_map_scheme]
      set ac_pm_enum       [dict get $ac_pm_scheme ENUM]
      set num_of_ac_lanes  [enum_data $ac_pm_enum LANES_USED]
      
      lappend lines "The current memory interface occupies $num_of_rtl_tiles banks:"
      
      for {set tile_i [expr {$num_of_rtl_tiles - 1}]} {$tile_i >= 0} {incr tile_i -1} {
         
         lappend lines ""
         
         if {$tile_i == $ac_tile_i} {
            lappend lines "Logical bank $tile_i (address/command bank):"
            lappend lines "--------------------------------------------"
            lappend lines ""
            lappend lines "   Address/command pinout scheme  : [enum_data $ac_pm_enum USER_STRING]"
            lappend lines "   Number of address/command lanes: $num_of_ac_lanes"
         } else {
            lappend lines "Logical bank $tile_i:"
            lappend lines "----------------------"
         }
         
         lappend lines ""
         lappend lines "   Lane index      Pin index       Port                  "
         lappend lines "   -------------------------------------------------------"
      
         for {set lane_i [expr {$lanes_per_tile - 1}]} {$lane_i >= 0} {incr lane_i -1} {
            for {set pin_i [expr {$pins_per_lane - 1}]} {$pin_i >= 0} {incr pin_i -1} {
               
               set display_pin_i  [expr {$lane_i * $pins_per_lane + $pin_i}]
               set display_lane_i [expr {($pin_i + 1) % $pins_per_lane == 0 ? $lane_i : "."}]
               
               if {[dict exists $mem_pins_alloc $tile_i $lane_i $pin_i]} {
                  set port [dict get $mem_pins_alloc $tile_i $lane_i $pin_i]
                  set port_enum [dict get $port TYPE_ENUM]
                  set port_name [enum_data $port_enum RTL_NAME]
                  set bus_index [dict get $port BUS_INDEX]               
                  set pin_name "${port_name}\[$bus_index\]"
               } else {
                  set pin_name "-"
                  if {$tile_i == $ac_tile_i && $lane_i == 2} {
                     if {$pin_i == 0} {
                        set pin_name "[enum_data PORT_PLL_REF_CLK RTL_NAME] (positive leg) - if needed"
                     } elseif {$pin_i == 1} {
                        set pin_name "[enum_data PORT_PLL_REF_CLK RTL_NAME] (negative leg) - if needed"
                     } elseif {$pin_i == 2} {
                        set pin_name "[enum_data PORT_OCT_RZQIN RTL_NAME] - if needed"
                     }
                  }
               }
               lappend lines "   [format "%-15s" $display_lane_i] [format "%-15s" $display_pin_i] $pin_name"
            }
         }
      }
   }

   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_howto_share_core_clks {docs_varname filename title} {

   upvar 1 $docs_varname docs
   
   set core_clks_sharing_enum [get_parameter_value PHY_CORE_CLKS_SHARING_ENUM]
   
   set lines [list \
      "When a design contains multiple memory interfaces of the same protocol, rate," \
      "frequency, and PLL reference clock source, it is possible for these interfaces" \
      "to share a common set of core clock signals. Core clocks sharing allows your" \
      "logic to use a single clock domain to synchronously access all interfaces." \
      "The feature also reduces the number of core clock networks required." \
      "" \
      "In order for multiple memory interfaces to share core clocks, one of the interfaces" \
      "must be specified as \"Master\" using the \"Core clocks sharing\" setting during" \
      "generation, and the remaining interfaces must be denoted as \"Slave\". There is no" \
      "preference to which interface needs to be a master. In the RTL, connect the" \
      "clks_sharing_master_out signal from the master interface to the clks_sharing_slave_in" \
      "signal of all the slave interfaces. Note that both the master and slave interfaces" \
      "expose their own output clock ports in the RTL (e.g. emif_usr_clk, afi_clk), but the" \
      "physical signals are equivalent and so it does not matter whether a clock port from a" \
      "master or a slave is used." \
      "" \
      "Core clocks sharing necessitates PLL reference clock sharing. Therefore," \
      "only the master interface exposes an input port for the PLL reference clock. The" \
      "same PLL reference clock signal is used by all the slave interfaces. See section" \
      "on PLL reference clock sharing for additional requirements." \
      ""
   ]
   
   lappend lines "The core clocks sharing mode of the current IP is \"[enum_data $core_clks_sharing_enum UI_NAME]\""   
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_howto_share_pll_ref_clk {docs_varname filename title} {

   upvar 1 $docs_varname docs

   set lines [list \
      "To share a single PLL reference clock signal between multiple memory interfaces," \
      "simply connect the same PLL reference clock signal to all interfaces in the RTL." \
      "" \
      "Interfaces that share the same PLL reference clock signal must be placed in the" \
      "same I/O column and must occupy consecutive banks."
   ]
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_howto_share_rzq_pin {docs_varname filename title} {
   
   upvar 1 $docs_varname docs   
   
   set lines [list \
      "To share a single RZQ pin between multiple memory interfaces of compatible I/O" \
      "standard and termination settings, simply connect the same RZQ pin to all interfaces" \
      "in the RTL. Sharing the RZQ pin also causes the OCT calibration block to be shared." \
      "" \
      "Interfaces that share the RZQ pin must be placed in the same I/O column and must" \
      "use the same I/O voltage and RZQ resistor value." 
   ]
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_ifs_desc {docs_varname filename if_ports} {
   
   upvar 1 $docs_varname docs   
   
   foreach if_enum [dict keys $if_ports] {
      set if_desc [get_string "${if_enum}_DESC"]
      set ports   [dict get $if_ports $if_enum PORTS]
      
      foreach if_index [dict keys [dict get $if_ports $if_enum INSTS]] {
         set if_enabled [dict get $if_ports $if_enum INSTS $if_index ENABLED]
         if {$if_enabled} {
            set lines [list "Port                           Width   Direction   Description                                        " \
                            "------------------------------------------------------------------------------------------------------" ]
            
            foreach port $ports {
               set port_enabled [dict get $port ENABLED]
               
               if {$port_enabled} {
                  set type_enum      [dict get $port TYPE_ENUM]
                  set port_name      [enum_data $type_enum RTL_NAME]
                  set port_dir       [enum_data $type_enum QSYS_DIR]
                  set port_desc      [get_string "${type_enum}_DESC"]
                  set port_bus_index [dict get $port BUS_INDEX]
                  set port_bus_width [dict get $port BUS_WIDTH]
                  
                  if {$if_index > -1} {
                     set port_name "${port_name}_${if_index}"
                  }
                  if {$port_desc == ""} {
                     set port_desc $port_name
                  }
                  if {$port_bus_width == -1} {
                     set port_bus_width 1
                  }
                  
                  if {$port_bus_width == 1 || $port_bus_index == 0} {
                     lappend lines "[format "%-30s" $port_name] [format "%-7s" $port_bus_width] [format "%-11s" $port_dir] $port_desc"
                  }
               }
            }
            
            if {$if_enum == "IF_CTRL_AMM"} {
               set amm_if_props [::altera_emif::ip_arch_nd::protocol_expert::get_interface_properties IF_CTRL_AMM]
               lappend lines ""
               lappend lines "Interface properties:"
               foreach prop [dict keys $amm_if_props] {
                  lappend lines "   [format "%-30s" $prop]: [dict get $amm_if_props $prop]"
               }
               lappend lines ""
               lappend lines "For details, refer to documentation on \"Avalon Interface Specifications\"."
            }
                     
            if {$if_index != -1} {
               set if_desc "$if_desc $if_index"
            }
            altera_emif::util::doc_gen::add_section docs $filename $if_desc -1 $lines
         }
      }
   }
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_howto_inst_ip_sim {docs_varname filename title} {

   upvar 1 $docs_varname docs
   
   set lines [list \
      "The simulation fileset as well as the simulation example design contain scripts" \
      "that illustrate what files are required when including the EMIF IP for simulation." \
      "The scripts are customized for all the 3rd-party simulators supported. It is highly" \
      "recommended that you use these scripts as reference when setting up your simulation" \
      "environment."
   ]
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_cal_mode_desc {docs_varname filename title} {

   upvar 1 $docs_varname docs
   
   set sim_cal_mode_enum [get_parameter_value DIAG_SIM_CAL_MODE_ENUM]

   set lines [list \
      "During generation, you can specify the default RTL simulation behavior for PHY calibration." \
      "If you specify full-calibration simulation, the simulation time can take a very long time" \
      "because all the stages and the detailed behavior of PHY calibration are simulated. If you" \
      "specify skip-calibration simulation, the detailed behavior of PHY calibration is not" \
      "simulated. Skip-calibration simulation is recommended unless you suspect a functional" \
      "issue with the PHY calibration algorithm. Note however, that RTL simulation is a zero-delay" \
      "simulation, and so timing-related calibration failures on hardware do not manifest themselves" \
      "during RTL simulations." \
      "" \
      "The setting that controls the calibration mode is encoded within the *_seq_params_sim.hex file" \
      "and the *_seq_params_synth.hex file. When the IP is compiled under the Quartus Prime software," \
      "synthesis-directive causes the *_seq_params_synth.hex file to always be used. Outside of the" \
      "Quartus Prime software (e.g. 3rd-party simulator), the *_seq_params_sim.hex file is always used." \
      "The behavior is the same regardless of which fileset is being synthesized or simulated." \
      "The calibration mode setting specified during generation only affects the *_seq_params_sim.hex" \
      "file. The *_seq_params_synth.hex file always specifies full-calibration since full calibration" \
      "is key to functional hardware."
   ]
   
   lappend lines "The RTL simulation behavior of the current IP is \"[enum_data $sim_cal_mode_enum UI_NAME]\""
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_add_ip_settings {docs_varname filename title} {

   upvar 1 $docs_varname docs

   set protocol_enum [get_parameter_value PROTOCOL_ENUM]
   
   set params [list]
   foreach param_name [get_parameters] {
      if {![get_parameter_property $param_name DERIVED]} {
         set relevant 1
         foreach curr_protocol_enum [enums_of_type PROTOCOL] {
            if {$curr_protocol_enum == "PROTOCOL_INVALID"} {
               continue
            }
         
            if {$protocol_enum != $curr_protocol_enum} {
               set module_name "_[string toupper [enum_data $curr_protocol_enum MODULE_NAME]]_"
               if {[string first $module_name $param_name] != -1} {
                  set relevant 0
                  continue
               }
            }
         }
         if {$relevant} {
            set param_val [get_parameter_value $param_name]
            lappend params [list $param_name $param_val]
         }
      }
   }
   
   set lines [list]
   foreach param $params {
      set param_name [lindex $param 0]
      set param_val  [lindex $param 1]

      if {[regexp {^MEM_\w+_MR\d+} $param_name]} {
         lappend lines "[format "%-50s" $param_name]: [format "0x%x" $param_val]"
      } else {
         lappend lines "[format "%-50s" $param_name]: $param_val"
      }
   }
   
   altera_emif::util::doc_gen::add_section docs $filename $title -1 $lines
}

proc ::altera_emif::ip_arch_nd::doc_gen::_init {} {
}

::altera_emif::ip_arch_nd::doc_gen::_init
