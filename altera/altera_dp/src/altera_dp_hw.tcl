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


# +----------------------------------
# | 
# | DisplayPort v12.1
# | Altera Corporation
# | 
# +-----------------------------------

package require -exact qsys 16.0
package require altera_terp

source altera_dp_qsys_ed.tcl

# +-----------------------------------
# | module altera_dp
# | 
set_module_property DESCRIPTION "DisplayPort Intel FPGA IP"
set_module_property NAME altera_dp
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Interface Protocols/Audio & Video"
set_module_property DISPLAY_NAME "DisplayPort Intel FPGA IP"
set_module_property AUTHOR "Intel Corporation"

# Use this to enable beta features not officially included in the
# release
set encrypted_core 0
set include_mst 1
set include_lpm 0
set include_hdcp 0
set include_apb 0

#set_module_property DATASHEET_URL http://www.altera.com/literature/ug/ug_displayport.pdf
add_documentation_link "DisplayPort MegaCore Function User Guide" http://www.altera.com/literature/ug/ug_displayport.pdf
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property supported_device_families {{stratix v} {arria v gz} {arria v} {cyclone v} {arria 10}}

# :::JGS::: Check if this properly disables VHDL support
#set_module_property simulation_model_in_vhdl false

# | 
# +-----------------------------------
proc debug_message { msg_type msg_string } {
   # Uncomment the next line to turn on verbose debugging info
   send_message $msg_type $msg_string
}

# +-----------------------------------
# | files
# | 

# # +-----------------------------------
# # | QUARTUS_SYNTH design RTL files
#   |
add_fileset synth QUARTUS_SYNTH synth_proc

# # +-----------------------------------
# # | SIM_ design files
#   |
add_fileset sim_verilog SIM_VERILOG sim_proc_v

add_fileset sim_vhdl SIM_VHDL sim_proc_vhdl

proc gen_terp { outputName dest_dir verilog args } {
   # This function generates a terp'ed file with the appropriately
   # generated PHY IP matching the parameters used for the
   # add_hdl_instance in the elaboration call-back

   # Choose the appropriate PHY based on the family, link rate & xcvr_width
   set device_family [get_parameter_value device_family]
   if {$device_family == "Stratix V"} {
      set family "sv"
   } elseif {$device_family == "Arria V"} {
      set family "av"
   } elseif {$device_family == "Arria V GZ"} {
      set family "avgz"
   } elseif {$device_family == "Cyclone V"} {
      set family "cv"
   } elseif {$device_family == "Arria 10"} {
      set family "a10"
   } else {
      # Unknown family
      send_message error "Current device family ($device_family) is not supported."
   }

   # Get the XCVR width from the symbols per clock
   # only 2 and 4 symbols are allowed
   set rx_symbols_per_clock [get_parameter_value RX_SYMBOLS_PER_CLOCK]
   set tx_symbols_per_clock [get_parameter_value TX_SYMBOLS_PER_CLOCK]

   if {$rx_symbols_per_clock == 2} {
      set rx_phy_xcvr_width 20
   } elseif {$rx_symbols_per_clock == 4} {
      set rx_phy_xcvr_width 40
   } else {
      send_message error "Sink: $rx_symbols_per_clock symbols per clock is not supported."
   }

   if {$tx_symbols_per_clock == 2} {
      set tx_phy_xcvr_width 20
   } elseif {$tx_symbols_per_clock == 4} {
      set tx_phy_xcvr_width 40
   } else {
      send_message error "Source: $tx_symbols_per_clock symbols per clock is not supported."
   }

   set params(output_name) $outputName
   debug_message INFO "Generating $outputName"

   # check for simulator tag
   set num_args [llength $args]
   if {$num_args == 1} {
      set sim_tag [lindex $args 0]
   } 

   # Warning we only support Verilog today, need to add VHDL
   # versions that match Verilog
   if {$verilog} {
      # Find all the TERP files to process
      set file_lst [glob -nocomplain -- -path "./*.v.terp"]
      foreach file ${file_lst} {
         debug_message INFO "Reading TERP file $file"
         set fd   [open $file "r"]
         set template [read $fd]
         close $fd

         set contents [altera_terp $template params]

         # Append the last terp'ed file to the same generated file
         if {$num_args == 0} {
            add_fileset_file ${dest_dir}${outputName}.v VERILOG TEXT $contents
            debug_message INFO "Adding file ${dest_dir}${outputName}.v for synth"
         } else {
            add_fileset_file ${dest_dir}${outputName}.v SYSTEM_VERILOG TEXT $contents $sim_tag
            debug_message INFO "Adding file ${dest_dir}${outputName}.v for simlation"
         }
      }
   } else {
      debug_message WARNING "VHDL TERP file support has not been added yet creating verilog instead"

      # Find all the TERP files to process
      set file_lst [glob -nocomplain -- -path "./*.v.terp"]
      foreach file ${file_lst} {
         debug_message INFO "Reading TERP file $file"
         set fd   [open $file "r"]
         set template [read $fd]
         close $fd

         set contents [altera_terp $template params]

         # Append the last terp'ed file to the same generated file
         if {$num_args == 0} {
            add_fileset_file ${dest_dir}${outputName}.v VERILOG TEXT $contents
            debug_message INFO "Adding file ${dest_dir}${outputName}.v for synth"
         } else {
            add_fileset_file ${dest_dir}${outputName}.v VERILOG TEXT $contents $sim_tag
            debug_message INFO "Adding file ${dest_dir}${outputName}.v for simlation"
         }
      }
   }
}



# +-------------------------------
# |SYNTH PROC
# |

proc synth_proc { outputName } {
   set synth_dir_lst {"." "./bitec_dp" "./bitec_dp/common" "./bitec_dp/rx" "./bitec_dp/rx/ss" "./bitec_dp/tx" "./bitec_dp/tx/ss"}

   foreach synth_dir $synth_dir_lst {
      set file_lst [glob -nocomplain -- -path $synth_dir/*]
      foreach file ${file_lst} {   
         set     is_dir  [file isdirectory $file]
         if {$is_dir == 1} {
            debug_message INFO "Ignoring $file for synthesis"
         } else {
            set file_string [split $file /]
            set file_name [lindex $file_string end]

            # Add the file to the correct fileset based on
            # extension
            if {[regexp {.v$} $file_name]} {
               add_fileset_file "$synth_dir/$file_name" VERILOG PATH ${file} 
               debug_message INFO "Adding Verilog $file for synthesis"
            } elseif {[regexp {.sv$} $file_name]} {
               add_fileset_file "$synth_dir/$file_name" SYSTEM_VERILOG PATH ${file} 
               debug_message INFO "Adding SystemVerilog $file for synthesis"
            } elseif {[regexp {.ocp$} $file_name]} {
               add_fileset_file "$synth_dir/$file_name" OTHER PATH ${file} 
               debug_message INFO "Adding OpenCore+ $file for synthesis"
            } elseif {[regexp {.sdc$} $file_name]} {
               add_fileset_file "$synth_dir/$file_name" SDC PATH ${file} 
               debug_message INFO "Adding SDC $file for synthesis"
            } else {
               debug_message INFO "Ignoring $file for synthesis"
            }
         }
      }
   }
   gen_terp $outputName "./" 1 
}


# +-------------------------------
# |SIM PROC
# |
proc sim_proc_v {outputName} {
    sim_proc $outputName 1
}

proc sim_proc_vhdl {outputName} {
    sim_proc $outputName 0
}

# Add all the Bitec files encrypted for a specific simulator
proc sim_proc_bitec { sim_path sim_tag } {

   set sim_dir_lst {"bitec_dp/common" "bitec_dp/rx" "bitec_dp/rx/ss" "bitec_dp/tx" "bitec_dp/tx/ss"}

   foreach sim_dir $sim_dir_lst {
      set file_lst [glob -nocomplain -- -path $sim_path$sim_dir/*]
      foreach file ${file_lst} {   
         set     is_dir  [file isdirectory $file]
         if {$is_dir == 1} {
            debug_message INFO "Ignoring $file for simulation"
         } else {
            set file_string [split $file /]
            set file_name [lindex $file_string end]

            # Add the file to the correct fileset based on
            # extension
            if {[regexp {.v$} $file_name]} {
               add_fileset_file "$sim_path$sim_dir/$file_name" SYSTEM_VERILOG PATH ${file} $sim_tag
               debug_message INFO "Adding Verilog $file for simulation"
            } elseif {[regexp {.sv$} $file_name]} {
               add_fileset_file "$sim_path$sim_dir/$file_name" SYSTEM_VERILOG PATH ${file} $sim_tag
               debug_message INFO "Adding SystemVerilog $file for simulation"
            } else {
               debug_message INFO "Ignoring $file for simulation"
            }
         }
      }
   }
}

proc sim_proc {outputName {sim_v 1} } {
   set sim_dir_lst   {"."}

   set dest_path_sy   "./synopsys/"
   set dest_path_ca   "./cadence/"
   set dest_path_me   "./mentor/"
   set dest_path_ald   "./aldec/"

   # Add the clear text top-level files for all simulators unless
   # doing VHDL. Then use the mentor tagged and encrypted
   foreach sim_dir $sim_dir_lst {
      set file_lst [glob -nocomplain -- -path $sim_dir/*]
      foreach file ${file_lst} {   
         set     is_dir  [file isdirectory $file]
         if {$is_dir == 1} {
            debug_message INFO "Ignoring $file for simulation"
         } else {
            set file_string [split $file /]
            set file_name [lindex $file_string end]

            # Add the file to the correct fileset based on
            # extension
            if {[regexp {.v$} $file_name]} {
               add_fileset_file "$dest_path_sy$sim_dir/$file_name" VERILOG PATH ${file} SYNOPSYS_SPECIFIC
               add_fileset_file "$dest_path_ca$sim_dir/$file_name" VERILOG PATH ${file} CADENCE_SPECIFIC
               add_fileset_file "$dest_path_ald$sim_dir/$file_name" VERILOG PATH ${file} ALDEC_SPECIFIC

            # FB case:387845 Missing .v files in Mentor VHDL_sim. This was added since rev8.
            #   if {$sim_v} {
               add_fileset_file "$dest_path_me$sim_dir/$file_name" VERILOG PATH ${file} MENTOR_SPECIFIC
            #   }
               debug_message INFO "Adding Verilog $file for simulation"
            } elseif {[regexp {.sv$} $file_name]} {
               add_fileset_file "$dest_path_sy$sim_dir/$file_name" SYSTEM_VERILOG PATH ${file} SYNOPSYS_SPECIFIC
               add_fileset_file "$dest_path_ca$sim_dir/$file_name" SYSTEM_VERILOG PATH ${file} CADENCE_SPECIFIC
               add_fileset_file "$dest_path_ald$sim_dir/$file_name" SYSTEM_VERILOG PATH ${file} ALDEC_SPECIFIC

            #   if {$sim_v} {
               add_fileset_file "$dest_path_me$sim_dir/$file_name" SYSTEM_VERILOG PATH ${file} MENTOR_SPECIFIC
            #   }
               debug_message INFO "Adding SystemVerilog $file for simulation"
            } else {
               debug_message INFO "Ignoring $file for simulation"
            }
         }
      }
   }

   # Adding the Mentor encrypted for VHDL simulation models
   if {$sim_v == 0} {
      foreach sim_dir $sim_dir_lst {
         set file_lst [glob -nocomplain -- -path $dest_path_me$sim_dir/*]
         foreach file ${file_lst} {   
            set     is_dir  [file isdirectory $file]
            if {$is_dir == 1} {
               debug_message INFO "Ignoring $file for simulation"
            } else {
               set file_string [split $file /]
               set file_name [lindex $file_string end]

               # Add the file to the correct fileset based on
               # extension
               if {[regexp {.v$} $file_name]} {
                  add_fileset_file "$dest_path_me$sim_dir/$file_name" VERILOG PATH ${file} MENTOR_SPECIFIC
               } elseif {[regexp {.sv$} $file_name]} {
                  add_fileset_file "$dest_path_me$sim_dir/$file_name" SYSTEM_VERILOG PATH ${file} MENTOR_SPECIFIC
               } else {
                  debug_message INFO "Ignoring $file for simulation"
               }
            }
         }
      }
   }

   # Add all the encrypted Bitec files for their specific simulators
   sim_proc_bitec $dest_path_sy  SYNOPSYS_SPECIFIC
   sim_proc_bitec $dest_path_ca  CADENCE_SPECIFIC
   sim_proc_bitec $dest_path_me  MENTOR_SPECIFIC
   sim_proc_bitec $dest_path_ald ALDEC_SPECIFIC

   # Add all the TERP files for all simulations
   gen_terp $outputName $dest_path_sy  $sim_v SYNOPSYS_SPECIFIC
   gen_terp $outputName $dest_path_ca  $sim_v CADENCE_SPECIFIC
   gen_terp $outputName $dest_path_me  $sim_v MENTOR_SPECIFIC
   gen_terp $outputName $dest_path_ald $sim_v ALDEC_SPECIFIC
}

# # +-----------------------------------
# # | Example files
#   |
# Disable example files for now. Potentially turn back on
#add_fileset example EXAMPLE_DESIGN proc_add_files_to_fileset_example

# | 
# +-----------------------------------

# +-----------------------------------
# | GUI
# | 

# | Split to 2 tabs
add_display_item "" "IP" GROUP tab
add_display_item "" "Design Example" GROUP tab

# | IP tab
# DP Source
add_display_item "IP" "Device Family" GROUP
add_display_item "Device Family" device_family parameter

add_display_item "IP" "Source" GROUP
add_display_item Source   TX_SUPPORT_DP parameter
add_display_item Source   TX_VIDEO_BPS parameter

add_display_item Source "DisplayPort source" GROUP

add_display_item "DisplayPort source"	TX_MAX_LINK_RATE	parameter
add_display_item "DisplayPort source"   TX_MAX_LANE_COUNT	parameter
add_display_item "DisplayPort source"	TX_SYMBOLS_PER_CLOCK	parameter
add_display_item "DisplayPort source"	TX_PIXELS_PER_CLOCK	parameter
add_display_item "DisplayPort source"   TX_SCRAMBLER_SEED	parameter
add_display_item "DisplayPort source"   TX_VIDEO_IM_ENABLE	parameter
add_display_item "DisplayPort source"   TX_SUPPORT_ANALOG_RECONFIG	parameter
add_display_item "DisplayPort source"	TX_AUX_DEBUG		parameter
add_display_item "DisplayPort source"	TX_SUPPORT_AUTOMATED_TEST parameter
add_display_item "DisplayPort source"   TX_SUPPORT_GTC parameter
if { $include_hdcp } {
  add_display_item "DisplayPort source"   TX_SUPPORT_HDCP1  parameter
  add_display_item "DisplayPort source"   TX_SUPPORT_HDCP2  parameter
}
if { $include_apb} {
add_display_item "DisplayPort source"	TX_APB_CONTROL parameter
}
add_display_item "DisplayPort source"  TX_SUPPORT_SS parameter
add_display_item "DisplayPort source" "Source audio support" GROUP
add_display_item "Source audio support" TX_SUPPORT_AUDIO parameter
add_display_item "Source audio support" TX_AUDIO_CHANS parameter
# add_display_item "DisplayPort source"	TX_IMPORT_MSA		parameter
# add_display_item "DisplayPort source"	TX_INTERLACED_VID	parameter
# add_display_item "DisplayPort source"   TX_POLINV			parameter
#add_display_item "DisplayPort source" "Source color depth support" GROUP
#add_display_item "Source color depth support"   TX_SUPPORT_18BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_24BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_30BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_36BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_48BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_YCBCR422_16BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_YCBCR422_20BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_YCBCR422_24BPP parameter
#add_display_item "Source color depth support"   TX_SUPPORT_YCBCR422_32BPP parameter

if { $include_mst } {
  # MST
  add_display_item "DisplayPort source" "Source MST (Multistream) Support" GROUP
  add_display_item "Source MST (Multistream) Support"  TX_SUPPORT_MST parameter
  add_display_item "Source MST (Multistream) Support"  TX_MAX_NUM_OF_STREAMS parameter
}

# DP SINK
add_display_item "IP" "Sink" GROUP

add_display_item Sink   RX_SUPPORT_DP parameter
add_display_item Sink   RX_VIDEO_BPS parameter

# add_display_item Sink   RX_IMAGE_OUT_FORMAT parameter

add_display_item Sink  "DisplayPort sink" GROUP

add_display_item "DisplayPort sink"  RX_MAX_LINK_RATE	parameter
add_display_item "DisplayPort sink"  RX_MAX_LANE_COUNT	parameter
add_display_item "DisplayPort sink"  RX_SYMBOLS_PER_CLOCK parameter
add_display_item "DisplayPort sink"  RX_PIXELS_PER_CLOCK parameter
add_display_item "DisplayPort sink"  RX_SCRAMBLER_SEED	parameter
# add_display_item "DisplayPort sink"  RX_POLINV			parameter
add_display_item "DisplayPort sink"  RX_EXPORT_MSA		parameter
add_display_item "DisplayPort sink"  RX_IEEE_OUI		parameter      
add_display_item "DisplayPort sink"  RX_AUX_GPU			parameter
add_display_item "DisplayPort sink"  RX_AUX_DEBUG		parameter
add_display_item "DisplayPort sink"  RX_SUPPORT_AUTOMATED_TEST parameter
add_display_item "DisplayPort sink"  RX_SUPPORT_GTC parameter
if { $include_hdcp } {
  add_display_item "DisplayPort sink"  RX_SUPPORT_HDCP1   parameter
  add_display_item "DisplayPort sink"  RX_SUPPORT_HDCP2   parameter
}
if { $include_apb} {
add_display_item "DisplayPort sink"	RX_APB_CONTROL parameter
}
add_display_item "DisplayPort sink"  RX_SUPPORT_SS parameter
if { $include_lpm } {
  add_display_item "DisplayPort sink"  RX_SUPPORT_LPM   parameter
}
add_display_item "DisplayPort sink"  RX_SUPPORT_I2CMASTER parameter
add_display_item "DisplayPort sink"  RX_I2C_SCL_KHZ parameter
add_display_item "DisplayPort sink" "Sink audio support" GROUP
add_display_item "Sink audio support" RX_SUPPORT_AUDIO parameter
add_display_item "Sink audio support" RX_AUDIO_CHANS parameter
#add_display_item "DisplayPort sink" "Sink color depth support" GROUP
#add_display_item "Sink color depth support"   RX_SUPPORT_18BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_24BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_30BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_36BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_48BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_YCBCR422_16BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_YCBCR422_20BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_YCBCR422_24BPP parameter
#add_display_item "Sink color depth support"   RX_SUPPORT_YCBCR422_32BPP parameter
if { $include_mst } {
  # MST
  add_display_item "DisplayPort sink" "Sink MST (Multistream) Support" GROUP
  add_display_item "Sink MST (Multistream) Support"  RX_SUPPORT_MST parameter
  add_display_item "Sink MST (Multistream) Support"  RX_MAX_NUM_OF_STREAMS parameter
}

    # | Design Example tab  
    add_display_item "Design Example" "Available Design Example" GROUP
    add_display_item "Available Design Example" SELECT_SUPPORTED_VARIANT parameter

    add_display_item "Design Example" "Design Example Files" GROUP
    add_display_item "Design Example Files" ENABLE_ED_FILESET_SIM parameter
    add_display_item "Design Example Files" ENABLE_ED_FILESET_SYNTHESIS parameter
    add_display_item "Design Example Files" "ed_fileset_txt" text \
        "<html>The design example supports generation, simulation, and Quartus compilation flows for any selected device. To use the <br> \
        design example for simulation, select the 'Simulation' option above. To use the design example for compilation and <br> \
        hardware, select the 'Synthesis' option above.</html>"

    add_display_item "Design Example" "Generated HDL Format" GROUP
    add_display_item "Generated HDL Format" SELECT_ED_FILESET parameter

    add_display_item "Design Example" "Target Development Kit" GROUP
    add_display_item "Target Development Kit" SELECT_TARGETED_BOARD parameter
    add_display_item "Target Development Kit" "target_devkit_txt" text \
        "<html>Design Example supports generation, simulation and Quartus compilation flows for any selected device.<br> \
        The hardware support is provided through selected development kit with a specific device.<br> \
        To exclude hardware aspects of design example, select 'None' from the Target Development Kit pull down menu.</html>"

    add_display_item "Design Example" "Target Device" GROUP
	add_display_item "Target Device" "target_dev" text "<html>Device Selected:     Family: Arria 10 Device 10AX115S2F45I1SG<br><br></html>"
    add_display_item "Target Device" SELECT_CUSTOM_DEVICE parameter
    add_display_item "Target Device" "custom_device_txt" text "<html></html>"

# | 
# +-----------------------------------


# +-----------------------------------
# | parameters
# | 

# Adding device family from system info, taken from reconfig
# controller setup, device_family must be lowercase
add_parameter device_family STRING "Stratix V"
set_parameter_property device_family DISPLAY_NAME "Device family"
set_parameter_property device_family SYSTEM_INFO device_family	;#forces family to always match Qsys
set_parameter_property device_family ALLOWED_RANGES {"Stratix V" "Arria V" "Arria V GZ" "Cyclone V" "Arria 10"}
set_parameter_property device_family HDL_PARAMETER true 
set_parameter_property device_family DESCRIPTION "Targeted device family"
set_parameter_property device_family ENABLED false ; #Shows value, but must match family chosen

add_parameter DEVICE string "Unknown"
set_parameter_property DEVICE SYSTEM_INFO {DEVICE}
set_parameter_property DEVICE HDL_PARAMETER false
set_parameter_property DEVICE VISIBLE false
 
add_parameter BASE_DEVICE string "Unknown"
set_parameter_property BASE_DEVICE SYSTEM_INFO_TYPE {PART_TRAIT}
set_parameter_property BASE_DEVICE SYSTEM_INFO_ARG {BASE_DEVICE}
set_parameter_property BASE_DEVICE HDL_PARAMETER false
set_parameter_property BASE_DEVICE VISIBLE false

add_parameter ED_DEVICE string "Unknown"
set_parameter_property ED_DEVICE DERIVED true
set_parameter_property ED_DEVICE HDL_PARAMETER false
set_parameter_property ED_DEVICE VISIBLE false


#Display GTC option but grey out. Default not support.
add_parameter TX_SUPPORT_GTC INTEGER 0
set_parameter_property TX_SUPPORT_GTC DEFAULT_VALUE 0
set_parameter_property TX_SUPPORT_GTC DISPLAY_NAME "Support GTC"
set_parameter_property TX_SUPPORT_GTC TYPE INTEGER
set_parameter_property TX_SUPPORT_GTC DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_GTC UNITS None
set_parameter_property TX_SUPPORT_GTC AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_GTC HDL_PARAMETER true
set_parameter_property TX_SUPPORT_GTC DESCRIPTION "Support Global Time Code in Source. Please contact Altera for early access."
set_parameter_property TX_SUPPORT_GTC ENABLED false

add_parameter TX_SUPPORT_SS INTEGER 0
set_parameter_property TX_SUPPORT_SS DEFAULT_VALUE 0
set_parameter_property TX_SUPPORT_SS DISPLAY_NAME "Support secondary data channel"
set_parameter_property TX_SUPPORT_SS TYPE INTEGER
set_parameter_property TX_SUPPORT_SS DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_SS UNITS None
set_parameter_property TX_SUPPORT_SS AFFECTS_GENERATION true
set_parameter_property TX_SUPPORT_SS HDL_PARAMETER true
set_parameter_property TX_SUPPORT_SS DESCRIPTION "Support secondary stream in source"

add_parameter TX_SUPPORT_AUDIO INTEGER 0
set_parameter_property TX_SUPPORT_AUDIO DEFAULT_VALUE 0
set_parameter_property TX_SUPPORT_AUDIO DISPLAY_NAME "Support audio data channel"
set_parameter_property TX_SUPPORT_AUDIO TYPE INTEGER
set_parameter_property TX_SUPPORT_AUDIO DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_AUDIO UNITS None
set_parameter_property TX_SUPPORT_AUDIO AFFECTS_GENERATION true
set_parameter_property TX_SUPPORT_AUDIO HDL_PARAMETER true
set_parameter_property TX_SUPPORT_AUDIO DESCRIPTION "Support audio stream in source. Requires Secondary Data Channel Support."
set_parameter_update_callback TX_SUPPORT_SS update_tx_audio_params

add_parameter TX_AUDIO_CHANS INTEGER int 2
set_parameter_property TX_AUDIO_CHANS DEFAULT_VALUE 2
set_parameter_property TX_AUDIO_CHANS ALLOWED_RANGES {2:2 8:8}
set_parameter_property TX_AUDIO_CHANS HDL_PARAMETER true
set_parameter_property TX_AUDIO_CHANS DISPLAY_NAME "Number of audio data channels"
set_parameter_property TX_AUDIO_CHANS DISPLAY_UNITS "Chans"
set_parameter_property TX_AUDIO_CHANS DESCRIPTION "Number of audio data channels"

add_parameter TX_VIDEO_BPS INTEGER int 8
set_parameter_property TX_VIDEO_BPS DEFAULT_VALUE 8
set_parameter_property TX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8 10:10 12:12 16:16}
set_parameter_property TX_VIDEO_BPS HDL_PARAMETER true
set_parameter_property TX_VIDEO_BPS DISPLAY_NAME "Maximum video input color depth"
set_parameter_property TX_VIDEO_BPS DISPLAY_UNITS "bpc"
set_parameter_property TX_VIDEO_BPS DESCRIPTION "The maximum number of bits-per-color used by the video input"

add_parameter TX_MAX_LINK_RATE INTEGER 10
set_parameter_property TX_MAX_LINK_RATE DEFAULT_VALUE 10
set_parameter_property TX_MAX_LINK_RATE DISPLAY_NAME "TX maximum link rate"
set_parameter_property TX_MAX_LINK_RATE UNITS None
set_parameter_property TX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps 20:5.4Gbps}
set_parameter_property TX_MAX_LINK_RATE DESCRIPTION "Maximum link rate supported by source"
set_parameter_property TX_MAX_LINK_RATE AFFECTS_GENERATION true
set_parameter_property TX_MAX_LINK_RATE HDL_PARAMETER true

# Hide the image out setting and default to Image-Port
#add_parameter RX_IMAGE_OUT_FORMAT INTEGER 1
#set_parameter_property RX_IMAGE_OUT_FORMAT DEFAULT_VALUE 1
#set_parameter_property RX_IMAGE_OUT_FORMAT DISPLAY_NAME "Video output port type"
#set_parameter_property RX_IMAGE_OUT_FORMAT ALLOWED_RANGES {0:Avalon-ST "1:Image port"}
#set_parameter_property RX_IMAGE_OUT_FORMAT HDL_PARAMETER true
#set_parameter_property RX_IMAGE_OUT_FORMAT DISPLAY_HINT radio
#set_parameter_property RX_IMAGE_OUT_FORMAT DESCRIPTION "Video output via avalon-st port or image port"
#set_parameter_property RX_IMAGE_OUT_FORMAT VISIBLE false

add_parameter TX_MAX_LANE_COUNT INTEGER 4
set_parameter_property TX_MAX_LANE_COUNT DEFAULT_VALUE 4
set_parameter_property TX_MAX_LANE_COUNT DISPLAY_NAME "Maximum lane count"
set_parameter_property TX_MAX_LANE_COUNT ALLOWED_RANGES {1:1 2:2 4:4}
set_parameter_property TX_MAX_LANE_COUNT UNITS None
set_parameter_property TX_MAX_LANE_COUNT DESCRIPTION "Maximum lane count supported by source"
set_parameter_property TX_MAX_LANE_COUNT AFFECTS_GENERATION true
set_parameter_property TX_MAX_LANE_COUNT HDL_PARAMETER true

add_parameter TX_SUPPORT_ANALOG_RECONFIG INTEGER 0
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG DEFAULT_VALUE 0
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG DISPLAY_NAME "Support analog reconfiguration"
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG TYPE INTEGER
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG UNITS None
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG AFFECTS_GENERATION true
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG HDL_PARAMETER true
set_parameter_property TX_SUPPORT_ANALOG_RECONFIG DESCRIPTION "Enable analog reconfiguration interface. Used to reconfigure Vod and pre-emphasis values"

add_parameter TX_AUX_DEBUG INTEGER 1
set_parameter_property TX_AUX_DEBUG DEFAULT_VALUE false
set_parameter_property TX_AUX_DEBUG DISPLAY_NAME "Enable AUX debug stream"
set_parameter_property TX_AUX_DEBUG WIDTH ""
set_parameter_property TX_AUX_DEBUG TYPE INTEGER
set_parameter_property TX_AUX_DEBUG UNITS None
set_parameter_property TX_AUX_DEBUG DESCRIPTION "Enable source AUX traffic output to an Avalon-ST port"
set_parameter_property TX_AUX_DEBUG AFFECTS_GENERATION true
set_parameter_property TX_AUX_DEBUG HDL_PARAMETER true
set_parameter_property TX_AUX_DEBUG DISPLAY_HINT boolean

add_parameter TX_SCRAMBLER_SEED INTEGER 65535
set_parameter_property TX_SCRAMBLER_SEED DEFAULT_VALUE 65535
set_parameter_property TX_SCRAMBLER_SEED DISPLAY_NAME "Scrambler seed value"
set_parameter_property TX_SCRAMBLER_SEED TYPE INTEGER
set_parameter_property TX_SCRAMBLER_SEED WIDTH "16"
set_parameter_property TX_SCRAMBLER_SEED UNITS None
set_parameter_property TX_SCRAMBLER_SEED DESCRIPTION "Scrambler seed value. Use 0xFFFF for DP and 0xFFFE for eDP"
set_parameter_property TX_SCRAMBLER_SEED AFFECTS_GENERATION true
set_parameter_property TX_SCRAMBLER_SEED HDL_PARAMETER true
set_parameter_property TX_SCRAMBLER_SEED DISPLAY_HINT boolean
set_parameter_property TX_SCRAMBLER_SEED ALLOWED_RANGES {65535:xFFFF 65534:xFFFE}

add_parameter TX_VIDEO_IM_ENABLE INTEGER 1
set_parameter_property TX_VIDEO_IM_ENABLE DEFAULT_VALUE false
set_parameter_property TX_VIDEO_IM_ENABLE DISPLAY_NAME "Enable Video input Image port"
set_parameter_property TX_VIDEO_IM_ENABLE WIDTH ""
set_parameter_property TX_VIDEO_IM_ENABLE TYPE INTEGER
set_parameter_property TX_VIDEO_IM_ENABLE UNITS None
set_parameter_property TX_VIDEO_IM_ENABLE DESCRIPTION "Enable Video input Image port instead of traditional VS/HS/DE interface"
set_parameter_property TX_VIDEO_IM_ENABLE AFFECTS_GENERATION true
set_parameter_property TX_VIDEO_IM_ENABLE HDL_PARAMETER true
set_parameter_property TX_VIDEO_IM_ENABLE DISPLAY_HINT boolean
set_parameter_update_callback TX_VIDEO_IM_ENABLE update_design_example_variant3

add_parameter TX_PIXELS_PER_CLOCK INTEGER 1
set_parameter_property TX_PIXELS_PER_CLOCK DEFAULT_VALUE 1
set_parameter_property TX_PIXELS_PER_CLOCK DISPLAY_NAME "Pixel input mode"
set_parameter_property TX_PIXELS_PER_CLOCK WIDTH ""
set_parameter_property TX_PIXELS_PER_CLOCK TYPE INTEGER
set_parameter_property TX_PIXELS_PER_CLOCK UNITS None
set_parameter_property TX_PIXELS_PER_CLOCK DESCRIPTION "Enable input of 1, 2 or 4 video pixels in parallel"
set_parameter_property TX_PIXELS_PER_CLOCK AFFECTS_GENERATION true
set_parameter_property TX_PIXELS_PER_CLOCK HDL_PARAMETER true
set_parameter_property TX_PIXELS_PER_CLOCK DISPLAY_HINT boolean
set_parameter_property TX_PIXELS_PER_CLOCK ALLOWED_RANGES {1:Single 2:Dual 4:Quad}

add_parameter TX_SYMBOLS_PER_CLOCK INTEGER 2
set_parameter_property TX_SYMBOLS_PER_CLOCK DEFAULT_VALUE 4
set_parameter_property TX_SYMBOLS_PER_CLOCK DISPLAY_NAME "Symbol output mode"
set_parameter_property TX_SYMBOLS_PER_CLOCK WIDTH ""
set_parameter_property TX_SYMBOLS_PER_CLOCK TYPE INTEGER
set_parameter_property TX_SYMBOLS_PER_CLOCK UNITS None
set_parameter_property TX_SYMBOLS_PER_CLOCK DESCRIPTION "Enable output of 2 or 4 symbols in parallel"
# set_parameter_property TX_SYMBOLS_PER_CLOCK AFFECTS_GENERATION false
set_parameter_property TX_SYMBOLS_PER_CLOCK HDL_PARAMETER true
set_parameter_property TX_SYMBOLS_PER_CLOCK DISPLAY_HINT boolean
set_parameter_property TX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}
#set_parameter_update_callback TX_SYMBOLS_PER_CLOCK update_tx_audio_params2

#add_parameter TX_IMPORT_MSA INTEGER 1
#set_parameter_property TX_IMPORT_MSA DEFAULT_VALUE 0
#set_parameter_property TX_IMPORT_MSA DISPLAY_NAME "Import fixed MSA"
#set_parameter_property TX_IMPORT_MSA WIDTH ""
#set_parameter_property TX_IMPORT_MSA TYPE INTEGER
#set_parameter_property TX_IMPORT_MSA UNITS None
#set_parameter_property TX_IMPORT_MSA DESCRIPTION "Enable source to accept a fixed MSA value rather than calculating one from video input data"
#set_parameter_property TX_IMPORT_MSA AFFECTS_GENERATION false
#set_parameter_property TX_IMPORT_MSA HDL_PARAMETER true
#set_parameter_property TX_IMPORT_MSA DISPLAY_HINT boolean
#set_parameter_property TX_IMPORT_MSA VISIBLE false

# Disable Tx Interlace support until Hardware testing complete.
# add_parameter TX_INTERLACED_VID INTEGER 1
# set_parameter_property TX_INTERLACED_VID DEFAULT_VALUE 0
# set_parameter_property TX_INTERLACED_VID DISPLAY_NAME "Interlaced input video"
# set_parameter_property TX_INTERLACED_VID WIDTH ""
# set_parameter_property TX_INTERLACED_VID TYPE INTEGER
# set_parameter_property TX_INTERLACED_VID UNITS None
# set_parameter_property TX_INTERLACED_VID DESCRIPTION "Video input is interlaced. Turn on for interlaced, turn off for progressive"
# set_parameter_property TX_INTERLACED_VID AFFECTS_GENERATION false
# set_parameter_property TX_INTERLACED_VID HDL_PARAMETER true
# set_parameter_property TX_INTERLACED_VID DISPLAY_HINT boolean

add_parameter TX_SUPPORT_18BPP INTEGER 1
set_parameter_property TX_SUPPORT_18BPP DEFAULT_VALUE true
set_parameter_property TX_SUPPORT_18BPP DISPLAY_NAME "6-bpc RGB or YCbCr 4:4:4 (18 bpp)"
set_parameter_property TX_SUPPORT_18BPP WIDTH ""
set_parameter_property TX_SUPPORT_18BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_18BPP UNITS None
set_parameter_property TX_SUPPORT_18BPP DESCRIPTION "Enable support for 18 bpp decoding"
set_parameter_property TX_SUPPORT_18BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_18BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_18BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_18BPP DERIVED true
set_parameter_property TX_SUPPORT_18BPP VISIBLE false

add_parameter TX_SUPPORT_24BPP INTEGER 1
set_parameter_property TX_SUPPORT_24BPP DEFAULT_VALUE true
set_parameter_property TX_SUPPORT_24BPP DISPLAY_NAME "8-bpc RGB or YCbCr 4:4:4 (24 bpp)"
set_parameter_property TX_SUPPORT_24BPP WIDTH ""
set_parameter_property TX_SUPPORT_24BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_24BPP UNITS None
set_parameter_property TX_SUPPORT_24BPP DESCRIPTION "Enable support for 24 bpp decoding"
set_parameter_property TX_SUPPORT_24BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_24BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_24BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_24BPP DERIVED true
set_parameter_property TX_SUPPORT_24BPP VISIBLE false

add_parameter TX_SUPPORT_30BPP INTEGER 1
set_parameter_property TX_SUPPORT_30BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_30BPP DISPLAY_NAME "10-bpc RGB or YCbCr 4:4:4 (30 bpp)"
set_parameter_property TX_SUPPORT_30BPP WIDTH ""
set_parameter_property TX_SUPPORT_30BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_30BPP UNITS None
set_parameter_property TX_SUPPORT_30BPP DESCRIPTION "Enable support for 30 bpp decoding"
set_parameter_property TX_SUPPORT_30BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_30BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_30BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_30BPP DERIVED true
set_parameter_property TX_SUPPORT_30BPP VISIBLE false

add_parameter TX_SUPPORT_36BPP INTEGER 1
set_parameter_property TX_SUPPORT_36BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_36BPP DISPLAY_NAME "12-bpc RGB or YCbCr 4:4:4 (36 bpp)"
set_parameter_property TX_SUPPORT_36BPP WIDTH ""
set_parameter_property TX_SUPPORT_36BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_36BPP UNITS None
set_parameter_property TX_SUPPORT_36BPP DESCRIPTION "Enable support for 36 bpp decoding"
set_parameter_property TX_SUPPORT_36BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_36BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_36BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_36BPP DERIVED true
set_parameter_property TX_SUPPORT_36BPP VISIBLE false

add_parameter TX_SUPPORT_48BPP INTEGER 1
set_parameter_property TX_SUPPORT_48BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_48BPP DISPLAY_NAME "16-bpc RGB or YCbCr 4:4:4 (48 bpp)"
set_parameter_property TX_SUPPORT_48BPP WIDTH ""
set_parameter_property TX_SUPPORT_48BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_48BPP UNITS None
set_parameter_property TX_SUPPORT_48BPP DESCRIPTION "Enable support for 48 bpp decoding"
set_parameter_property TX_SUPPORT_48BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_48BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_48BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_48BPP DERIVED true
set_parameter_property TX_SUPPORT_48BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR422_16BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR422_16BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR422_16BPP DISPLAY_NAME "8-bpc YCbCr 4:2:2 (16 bpp)"
set_parameter_property TX_SUPPORT_YCBCR422_16BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR422_16BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR422_16BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR422_16BPP DESCRIPTION "Enable support for 16 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR422_16BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR422_16BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR422_16BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR422_16BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR422_16BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR422_20BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR422_20BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR422_20BPP DISPLAY_NAME "10-bpc YCbCr 4:2:2 (20 bpp)"
set_parameter_property TX_SUPPORT_YCBCR422_20BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR422_20BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR422_20BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR422_20BPP DESCRIPTION "Enable support for 20 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR422_20BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR422_20BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR422_20BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR422_20BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR422_20BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR422_24BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR422_24BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR422_24BPP DISPLAY_NAME "12-bpc YCbCr 4:2:2 (24 bpp)"
set_parameter_property TX_SUPPORT_YCBCR422_24BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR422_24BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR422_24BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR422_24BPP DESCRIPTION "Enable support for 24 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR422_24BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR422_24BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR422_24BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR422_24BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR422_24BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR422_32BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR422_32BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR422_32BPP DISPLAY_NAME "16-bpc YCbCr 4:2:2 (32 bpp)"
set_parameter_property TX_SUPPORT_YCBCR422_32BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR422_32BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR422_32BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR422_32BPP DESCRIPTION "Enable support for 32 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR422_32BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR422_32BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR422_32BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR422_32BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR422_32BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR420_12BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR420_12BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR420_12BPP DISPLAY_NAME "8-bpc YCbCr 4:2:0 (12 bpp)"
set_parameter_property TX_SUPPORT_YCBCR420_12BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR420_12BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR420_12BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR420_12BPP DESCRIPTION "Enable support for 12 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR420_12BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR420_12BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR420_12BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR420_12BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR420_12BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR420_15BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR420_15BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR420_15BPP DISPLAY_NAME "10-bpc YCbCr 4:2:0 (15 bpp)"
set_parameter_property TX_SUPPORT_YCBCR420_15BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR420_15BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR420_15BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR420_15BPP DESCRIPTION "Enable support for 15 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR420_15BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR420_15BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR420_15BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR420_15BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR420_15BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR420_18BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR420_18BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR420_18BPP DISPLAY_NAME "12-bpc YCbCr 4:2:0 (18 bpp)"
set_parameter_property TX_SUPPORT_YCBCR420_18BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR420_18BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR420_18BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR420_18BPP DESCRIPTION "Enable support for 18 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR420_18BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR420_18BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR420_18BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR420_18BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR420_18BPP VISIBLE false

add_parameter TX_SUPPORT_YCBCR420_24BPP INTEGER 1
set_parameter_property TX_SUPPORT_YCBCR420_24BPP DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_YCBCR420_24BPP DISPLAY_NAME "16-bpc YCbCr 4:2:0 (24 bpp)"
set_parameter_property TX_SUPPORT_YCBCR420_24BPP WIDTH ""
set_parameter_property TX_SUPPORT_YCBCR420_24BPP TYPE INTEGER
set_parameter_property TX_SUPPORT_YCBCR420_24BPP UNITS None
set_parameter_property TX_SUPPORT_YCBCR420_24BPP DESCRIPTION "Enable support for 24 bpp decoding"
set_parameter_property TX_SUPPORT_YCBCR420_24BPP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_YCBCR420_24BPP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_YCBCR420_24BPP DISPLAY_HINT boolean
set_parameter_property TX_SUPPORT_YCBCR420_24BPP DERIVED true
set_parameter_property TX_SUPPORT_YCBCR420_24BPP VISIBLE false

add_parameter TX_SUPPORT_DP INTEGER 1
set_parameter_property TX_SUPPORT_DP DEFAULT_VALUE true
set_parameter_property TX_SUPPORT_DP DISPLAY_NAME "Support DisplayPort source"
set_parameter_property TX_SUPPORT_DP WIDTH ""
set_parameter_property TX_SUPPORT_DP TYPE INTEGER
set_parameter_property TX_SUPPORT_DP UNITS None
set_parameter_property TX_SUPPORT_DP DESCRIPTION "Enable DisplayPort source"
set_parameter_property TX_SUPPORT_DP AFFECTS_GENERATION false
set_parameter_property TX_SUPPORT_DP HDL_PARAMETER true
set_parameter_property TX_SUPPORT_DP DISPLAY_HINT boolean

add_parameter TX_SUPPORT_AUTOMATED_TEST INTEGER 1
set_parameter_property TX_SUPPORT_AUTOMATED_TEST DEFAULT_VALUE false
set_parameter_property TX_SUPPORT_AUTOMATED_TEST DISPLAY_NAME "Support CTS test automation"
set_parameter_property TX_SUPPORT_AUTOMATED_TEST WIDTH ""
set_parameter_property TX_SUPPORT_AUTOMATED_TEST TYPE INTEGER
set_parameter_property TX_SUPPORT_AUTOMATED_TEST UNITS None
set_parameter_property TX_SUPPORT_AUTOMATED_TEST DESCRIPTION "Enable CTS CRC test logic"
set_parameter_property TX_SUPPORT_AUTOMATED_TEST AFFECTS_GENERATION true
set_parameter_property TX_SUPPORT_AUTOMATED_TEST HDL_PARAMETER true
set_parameter_property TX_SUPPORT_AUTOMATED_TEST DISPLAY_HINT boolean

if { $include_hdcp } {
   # Hidden parameter support for HDCP1
   add_parameter TX_SUPPORT_HDCP1 INTEGER 1
   set_parameter_property TX_SUPPORT_HDCP1 DEFAULT_VALUE false
   set_parameter_property TX_SUPPORT_HDCP1 DISPLAY_NAME "Support source HDCP1"
   set_parameter_property TX_SUPPORT_HDCP1 WIDTH ""
   set_parameter_property TX_SUPPORT_HDCP1 TYPE INTEGER
   set_parameter_property TX_SUPPORT_HDCP1 UNITS None
   set_parameter_property TX_SUPPORT_HDCP1 DESCRIPTION "Enable support for HDCP1 encryption"
   set_parameter_property TX_SUPPORT_HDCP1 AFFECTS_GENERATION false
   set_parameter_property TX_SUPPORT_HDCP1 HDL_PARAMETER true
   set_parameter_property TX_SUPPORT_HDCP1 DISPLAY_HINT boolean

   # Hidden parameter support for HDCP2
   add_parameter TX_SUPPORT_HDCP2 INTEGER 1
   set_parameter_property TX_SUPPORT_HDCP2 DEFAULT_VALUE false
   set_parameter_property TX_SUPPORT_HDCP2 DISPLAY_NAME "Support source HDCP2"
   set_parameter_property TX_SUPPORT_HDCP2 WIDTH ""
   set_parameter_property TX_SUPPORT_HDCP2 TYPE INTEGER
   set_parameter_property TX_SUPPORT_HDCP2 UNITS None
   set_parameter_property TX_SUPPORT_HDCP2 DESCRIPTION "Enable support for HDCP2 encryption"
   set_parameter_property TX_SUPPORT_HDCP2 AFFECTS_GENERATION false
   set_parameter_property TX_SUPPORT_HDCP2 HDL_PARAMETER true
   set_parameter_property TX_SUPPORT_HDCP2 DISPLAY_HINT boolean

}

if { $include_apb} {
add_parameter TX_APB_CONTROL INTEGER 1
set_parameter_property TX_APB_CONTROL DEFAULT_VALUE false
set_parameter_property TX_APB_CONTROL DISPLAY_NAME "Support source APB control"
set_parameter_property TX_APB_CONTROL WIDTH ""
set_parameter_property TX_APB_CONTROL TYPE INTEGER
set_parameter_property TX_APB_CONTROL UNITS None
set_parameter_property TX_APB_CONTROL DESCRIPTION "Enable source APB control"
set_parameter_property TX_APB_CONTROL AFFECTS_GENERATION false
set_parameter_property TX_APB_CONTROL HDL_PARAMETER true
set_parameter_property TX_APB_CONTROL DISPLAY_HINT boolean
}

if { $include_mst } {
  # MST
  add_parameter TX_SUPPORT_MST INTEGER 0
  set_parameter_property TX_SUPPORT_MST DEFAULT_VALUE 0
  set_parameter_property TX_SUPPORT_MST DISPLAY_NAME "Support MST"
  set_parameter_property TX_SUPPORT_MST TYPE INTEGER
  set_parameter_property TX_SUPPORT_MST DISPLAY_HINT boolean
  set_parameter_property TX_SUPPORT_MST UNITS None
  set_parameter_property TX_SUPPORT_MST AFFECTS_GENERATION true
  set_parameter_property TX_SUPPORT_MST HDL_PARAMETER true
  set_parameter_property TX_SUPPORT_MST DESCRIPTION "Support MST (multistream)"
  #set_parameter_update_callback TX_SUPPORT_MST update_design_example_variant2
  
  add_parameter TX_MAX_NUM_OF_STREAMS INTEGER 1
  set_parameter_property TX_MAX_NUM_OF_STREAMS DEFAULT_VALUE 1
  set_parameter_property TX_MAX_NUM_OF_STREAMS DISPLAY_NAME "Max stream count"
  set_parameter_property TX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {1:1}
  set_parameter_property TX_MAX_NUM_OF_STREAMS UNITS None
  set_parameter_property TX_MAX_NUM_OF_STREAMS DESCRIPTION "Maximum number of streams supported by Source"
  set_parameter_property TX_MAX_NUM_OF_STREAMS AFFECTS_GENERATION true
  set_parameter_property TX_MAX_NUM_OF_STREAMS HDL_PARAMETER true
  set_parameter_update_callback TX_SUPPORT_MST update_tx_max_stream_params
}

add_parameter RX_SUPPORT_GTC INTEGER 0
set_parameter_property RX_SUPPORT_GTC DEFAULT_VALUE 0
set_parameter_property RX_SUPPORT_GTC DISPLAY_NAME "Support GTC"
set_parameter_property RX_SUPPORT_GTC TYPE INTEGER
set_parameter_property RX_SUPPORT_GTC DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_GTC UNITS None
set_parameter_property RX_SUPPORT_GTC AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_GTC HDL_PARAMETER true
set_parameter_property RX_SUPPORT_GTC DESCRIPTION "Support Global Time Code in Sink. Please contact Altera for early access."
set_parameter_property RX_SUPPORT_GTC ENABLED false

add_parameter RX_PIXELS_PER_CLOCK INTEGER 1
set_parameter_property RX_PIXELS_PER_CLOCK DEFAULT_VALUE 1
set_parameter_property RX_PIXELS_PER_CLOCK DISPLAY_NAME "Pixel output mode"
set_parameter_property RX_PIXELS_PER_CLOCK WIDTH ""
set_parameter_property RX_PIXELS_PER_CLOCK TYPE INTEGER
set_parameter_property RX_PIXELS_PER_CLOCK UNITS None
set_parameter_property RX_PIXELS_PER_CLOCK DESCRIPTION "Enable output of 1, 2 or 4 video pixels in parallel"
set_parameter_property RX_PIXELS_PER_CLOCK AFFECTS_GENERATION true
set_parameter_property RX_PIXELS_PER_CLOCK HDL_PARAMETER true
set_parameter_property RX_PIXELS_PER_CLOCK DISPLAY_HINT boolean
set_parameter_property RX_PIXELS_PER_CLOCK ALLOWED_RANGES {1:Single 2:Dual 4:Quad}

add_parameter RX_SYMBOLS_PER_CLOCK INTEGER 2
set_parameter_property RX_SYMBOLS_PER_CLOCK DEFAULT_VALUE 4
set_parameter_property RX_SYMBOLS_PER_CLOCK DISPLAY_NAME "Symbol input mode"
set_parameter_property RX_SYMBOLS_PER_CLOCK WIDTH ""
set_parameter_property RX_SYMBOLS_PER_CLOCK TYPE INTEGER
set_parameter_property RX_SYMBOLS_PER_CLOCK UNITS None
set_parameter_property RX_SYMBOLS_PER_CLOCK DESCRIPTION "Enable input of 2 or 4 symbols in parallel"
# set_parameter_property RX_SYMBOLS_PER_CLOCK AFFECTS_GENERATION false
set_parameter_property RX_SYMBOLS_PER_CLOCK HDL_PARAMETER true
set_parameter_property RX_SYMBOLS_PER_CLOCK DISPLAY_HINT boolean
set_parameter_property RX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}  
#set_parameter_update_callback RX_SYMBOLS_PER_CLOCK update_rx_audio_params2

add_parameter RX_EXPORT_MSA INTEGER 1
set_parameter_property RX_EXPORT_MSA DEFAULT_VALUE 1
set_parameter_property RX_EXPORT_MSA DISPLAY_NAME "Export MSA"
set_parameter_property RX_EXPORT_MSA WIDTH ""
set_parameter_property RX_EXPORT_MSA TYPE INTEGER
set_parameter_property RX_EXPORT_MSA UNITS None
set_parameter_property RX_EXPORT_MSA DESCRIPTION "Outputs MSA to top level port interface"
set_parameter_property RX_EXPORT_MSA AFFECTS_GENERATION true
set_parameter_property RX_EXPORT_MSA HDL_PARAMETER true
set_parameter_property RX_EXPORT_MSA DISPLAY_HINT boolean

add_parameter RX_VIDEO_BPS INTEGER int 8
set_parameter_property RX_VIDEO_BPS DEFAULT_VALUE 8
set_parameter_property RX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8 10:10 12:12 16:16}
set_parameter_property RX_VIDEO_BPS HDL_PARAMETER true
set_parameter_property RX_VIDEO_BPS DISPLAY_NAME "Maximum video output color depth"
set_parameter_property RX_VIDEO_BPS DISPLAY_UNITS "bpc"
set_parameter_property RX_VIDEO_BPS DESCRIPTION "The maximum number of bits-per-color used by the video output"

add_parameter RX_SUPPORT_SS INTEGER 0
set_parameter_property RX_SUPPORT_SS DEFAULT_VALUE 0
set_parameter_property RX_SUPPORT_SS DISPLAY_NAME "Support secondary data channel"
set_parameter_property RX_SUPPORT_SS TYPE INTEGER
set_parameter_property RX_SUPPORT_SS DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_SS UNITS None
set_parameter_property RX_SUPPORT_SS AFFECTS_GENERATION true
set_parameter_property RX_SUPPORT_SS HDL_PARAMETER true
set_parameter_property RX_SUPPORT_SS DESCRIPTION "Support secondary stream in sink"

add_parameter RX_SUPPORT_I2CMASTER INTEGER 0
set_parameter_property RX_SUPPORT_I2CMASTER DEFAULT_VALUE 0
set_parameter_property RX_SUPPORT_I2CMASTER DISPLAY_NAME "Support External I2C Slaves"
set_parameter_property RX_SUPPORT_I2CMASTER TYPE INTEGER
set_parameter_property RX_SUPPORT_I2CMASTER DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_I2CMASTER UNITS None
set_parameter_property RX_SUPPORT_I2CMASTER AFFECTS_GENERATION false
# set_parameter_property RX_SUPPORT_I2CMASTER HDL_PARAMETER true
set_parameter_property RX_SUPPORT_I2CMASTER VISIBLE false
set_parameter_property RX_SUPPORT_I2CMASTER DESCRIPTION "Enable two I2C Master interfaces"

add_parameter RX_I2C_SCL_KHZ INTEGER 100
set_parameter_property RX_I2C_SCL_KHZ DEFAULT_VALUE 100
set_parameter_property RX_I2C_SCL_KHZ DISPLAY_NAME "I2C Slaves bitrate"
set_parameter_property RX_I2C_SCL_KHZ TYPE INTEGER
set_parameter_property RX_I2C_SCL_KHZ UNITS "Kilohertz"
set_parameter_property RX_I2C_SCL_KHZ ALLOWED_RANGES 50:400
set_parameter_property RX_I2C_SCL_KHZ AFFECTS_GENERATION false
# set_parameter_property RX_I2C_SCL_KHZ HDL_PARAMETER true
set_parameter_property RX_I2C_SCL_KHZ VISIBLE false
set_parameter_property RX_I2C_SCL_KHZ DESCRIPTION "SCL frequency for the external I2C Slaves"


add_parameter RX_SUPPORT_AUDIO INTEGER 0
set_parameter_property RX_SUPPORT_AUDIO DEFAULT_VALUE 0
set_parameter_property RX_SUPPORT_AUDIO DISPLAY_NAME "Support audio data channel"
set_parameter_property RX_SUPPORT_AUDIO TYPE INTEGER
set_parameter_property RX_SUPPORT_AUDIO DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_AUDIO UNITS None
set_parameter_property RX_SUPPORT_AUDIO AFFECTS_GENERATION true
set_parameter_property RX_SUPPORT_AUDIO HDL_PARAMETER true
set_parameter_property RX_SUPPORT_AUDIO DESCRIPTION "Support audio stream. Requires Secondary Data Channel Support."
set_parameter_update_callback RX_SUPPORT_SS update_rx_audio_params

add_parameter RX_AUDIO_CHANS INTEGER int 2
set_parameter_property RX_AUDIO_CHANS DEFAULT_VALUE 2
set_parameter_property RX_AUDIO_CHANS ALLOWED_RANGES {2:2 8:8}
set_parameter_property RX_AUDIO_CHANS HDL_PARAMETER true
set_parameter_property RX_AUDIO_CHANS DISPLAY_NAME "Number of audio data channels"
set_parameter_property RX_AUDIO_CHANS DISPLAY_UNITS "Chans"
set_parameter_property RX_AUDIO_CHANS DESCRIPTION "Number of audio data channels"

add_parameter RX_MAX_LINK_RATE INTEGER 10
set_parameter_property RX_MAX_LINK_RATE DEFAULT_VALUE 10
set_parameter_property RX_MAX_LINK_RATE DISPLAY_NAME "RX maximum link rate"
set_parameter_property RX_MAX_LINK_RATE UNITS None
set_parameter_property RX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps 20:5.4Gbps}
set_parameter_property RX_MAX_LINK_RATE DESCRIPTION "Maximum link rate supported by sink"
set_parameter_property RX_MAX_LINK_RATE AFFECTS_GENERATION true
set_parameter_property RX_MAX_LINK_RATE HDL_PARAMETER true

add_parameter RX_MAX_LANE_COUNT INTEGER 4
set_parameter_property RX_MAX_LANE_COUNT DEFAULT_VALUE 4
set_parameter_property RX_MAX_LANE_COUNT DISPLAY_NAME "Maximum lane count"
set_parameter_property RX_MAX_LANE_COUNT ALLOWED_RANGES {1:1 2:2 4:4}
set_parameter_property RX_MAX_LANE_COUNT UNITS None
set_parameter_property RX_MAX_LANE_COUNT DESCRIPTION "Maximum lane count supported"
set_parameter_property RX_MAX_LANE_COUNT AFFECTS_GENERATION true
set_parameter_property RX_MAX_LANE_COUNT HDL_PARAMETER true

add_parameter RX_SCRAMBLER_SEED INTEGER 65535
set_parameter_property RX_SCRAMBLER_SEED DEFAULT_VALUE 65535
set_parameter_property RX_SCRAMBLER_SEED DISPLAY_NAME "Sink scrambler seed value"
set_parameter_property RX_SCRAMBLER_SEED TYPE INTEGER
set_parameter_property RX_SCRAMBLER_SEED WIDTH "16"
set_parameter_property RX_SCRAMBLER_SEED UNITS None
set_parameter_property RX_SCRAMBLER_SEED DESCRIPTION "Scrambler seed value. Use 0xFFFF for DP and 0xFFFE for eDP"
set_parameter_property RX_SCRAMBLER_SEED AFFECTS_GENERATION true
set_parameter_property RX_SCRAMBLER_SEED HDL_PARAMETER true
set_parameter_property RX_SCRAMBLER_SEED DISPLAY_HINT boolean
set_parameter_property RX_SCRAMBLER_SEED ALLOWED_RANGES {65535:xFFFF 65534:xFFFE}

# support edp (hidden)
add_parameter RX_SUPPORT_EDP INTEGER 0
set_parameter_property RX_SUPPORT_EDP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_EDP DISPLAY_NAME "Sink support eDP"
set_parameter_property RX_SUPPORT_EDP TYPE INTEGER
set_parameter_property RX_SUPPORT_EDP WIDTH ""
set_parameter_property RX_SUPPORT_EDP UNITS None
set_parameter_property RX_SUPPORT_EDP DESCRIPTION "Support eDP to compliance with eDP HPD specification"
set_parameter_property RX_SUPPORT_EDP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_EDP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_EDP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_EDP DERIVED true
set_parameter_property RX_SUPPORT_EDP VISIBLE false

add_parameter RX_SUPPORT_AUTOMATED_TEST INTEGER 1
set_parameter_property RX_SUPPORT_AUTOMATED_TEST DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_AUTOMATED_TEST DISPLAY_NAME "Support CTS test automation"
set_parameter_property RX_SUPPORT_AUTOMATED_TEST WIDTH ""
set_parameter_property RX_SUPPORT_AUTOMATED_TEST TYPE INTEGER
set_parameter_property RX_SUPPORT_AUTOMATED_TEST UNITS None
set_parameter_property RX_SUPPORT_AUTOMATED_TEST DESCRIPTION "Enable CTS CRC test logic"
set_parameter_property RX_SUPPORT_AUTOMATED_TEST AFFECTS_GENERATION true
set_parameter_property RX_SUPPORT_AUTOMATED_TEST HDL_PARAMETER true
set_parameter_property RX_SUPPORT_AUTOMATED_TEST DISPLAY_HINT boolean

if { $include_hdcp } {
   #Hidden support for HDCP1
   add_parameter RX_SUPPORT_HDCP1 INTEGER 1
   set_parameter_property RX_SUPPORT_HDCP1 DEFAULT_VALUE false
   set_parameter_property RX_SUPPORT_HDCP1 DISPLAY_NAME "Support sink HDCP1"
   set_parameter_property RX_SUPPORT_HDCP1 WIDTH ""
   set_parameter_property RX_SUPPORT_HDCP1 TYPE INTEGER
   set_parameter_property RX_SUPPORT_HDCP1 UNITS None
   set_parameter_property RX_SUPPORT_HDCP1 DESCRIPTION "Enable for HDCP1 decryption"
   set_parameter_property RX_SUPPORT_HDCP1 AFFECTS_GENERATION false
   set_parameter_property RX_SUPPORT_HDCP1 HDL_PARAMETER true
   set_parameter_property RX_SUPPORT_HDCP1 DISPLAY_HINT boolean

   #Hidden support for HDCP2
   add_parameter RX_SUPPORT_HDCP2 INTEGER 1
   set_parameter_property RX_SUPPORT_HDCP2 DEFAULT_VALUE false
   set_parameter_property RX_SUPPORT_HDCP2 DISPLAY_NAME "Support sink HDCP2"
   set_parameter_property RX_SUPPORT_HDCP2 WIDTH ""
   set_parameter_property RX_SUPPORT_HDCP2 TYPE INTEGER
   set_parameter_property RX_SUPPORT_HDCP2 UNITS None
   set_parameter_property RX_SUPPORT_HDCP2 DESCRIPTION "Enable for HDCP2 decryption"
   set_parameter_property RX_SUPPORT_HDCP2 AFFECTS_GENERATION false
   set_parameter_property RX_SUPPORT_HDCP2 HDL_PARAMETER true
   set_parameter_property RX_SUPPORT_HDCP2 DISPLAY_HINT boolean
}

if { $include_apb} {
add_parameter RX_APB_CONTROL INTEGER 1
set_parameter_property RX_APB_CONTROL DEFAULT_VALUE false
set_parameter_property RX_APB_CONTROL DISPLAY_NAME "Support sink APB control"
set_parameter_property RX_APB_CONTROL WIDTH ""
set_parameter_property RX_APB_CONTROL TYPE INTEGER
set_parameter_property RX_APB_CONTROL UNITS None
set_parameter_property RX_APB_CONTROL DESCRIPTION "Enable sink APB control"
set_parameter_property RX_APB_CONTROL AFFECTS_GENERATION false
set_parameter_property RX_APB_CONTROL HDL_PARAMETER true
set_parameter_property RX_APB_CONTROL DISPLAY_HINT boolean
}

if { $include_lpm } {
  add_parameter RX_SUPPORT_LPM INTEGER 0
  set_parameter_property RX_SUPPORT_LPM DEFAULT_VALUE false
  set_parameter_property RX_SUPPORT_LPM DISPLAY_NAME "Support Sink Low Power Manager"
  set_parameter_property RX_SUPPORT_LPM WIDTH ""
  set_parameter_property RX_SUPPORT_LPM TYPE INTEGER
  set_parameter_property RX_SUPPORT_LPM UNITS None
  set_parameter_property RX_SUPPORT_LPM DESCRIPTION ""
  set_parameter_property RX_SUPPORT_LPM AFFECTS_GENERATION false
  set_parameter_property RX_SUPPORT_LPM VISIBLE false
  set_parameter_property RX_SUPPORT_LPM HDL_PARAMETER true
  set_parameter_property RX_SUPPORT_LPM DISPLAY_HINT boolean
}

add_parameter RX_SUPPORT_18BPP INTEGER 1
set_parameter_property RX_SUPPORT_18BPP DEFAULT_VALUE true
set_parameter_property RX_SUPPORT_18BPP DISPLAY_NAME "6-bpc RGB or YCbCr 4:4:4 (18 bpp)"
set_parameter_property RX_SUPPORT_18BPP WIDTH ""
set_parameter_property RX_SUPPORT_18BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_18BPP UNITS None
set_parameter_property RX_SUPPORT_18BPP DESCRIPTION "Enable support for 18 bpp decoding"
set_parameter_property RX_SUPPORT_18BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_18BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_18BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_18BPP DERIVED true
set_parameter_property RX_SUPPORT_18BPP VISIBLE false

add_parameter RX_SUPPORT_24BPP INTEGER 1
set_parameter_property RX_SUPPORT_24BPP DEFAULT_VALUE true
set_parameter_property RX_SUPPORT_24BPP DISPLAY_NAME "8-bpc RGB or YCbCr 4:4:4 (24 bpp)"
set_parameter_property RX_SUPPORT_24BPP WIDTH ""
set_parameter_property RX_SUPPORT_24BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_24BPP UNITS None
set_parameter_property RX_SUPPORT_24BPP DESCRIPTION "Enable support for 24 bpp decoding"
set_parameter_property RX_SUPPORT_24BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_24BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_24BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_24BPP DERIVED true
set_parameter_property RX_SUPPORT_24BPP VISIBLE false

add_parameter RX_SUPPORT_30BPP INTEGER 1
set_parameter_property RX_SUPPORT_30BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_30BPP DISPLAY_NAME "10-bpc RGB or YCbCr 4:4:4 (30 bpp)"
set_parameter_property RX_SUPPORT_30BPP WIDTH ""
set_parameter_property RX_SUPPORT_30BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_30BPP UNITS None
set_parameter_property RX_SUPPORT_30BPP DESCRIPTION "Enable support for 30 bpp decoding"
set_parameter_property RX_SUPPORT_30BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_30BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_30BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_30BPP DERIVED true
set_parameter_property RX_SUPPORT_30BPP VISIBLE false

add_parameter RX_SUPPORT_36BPP INTEGER 1
set_parameter_property RX_SUPPORT_36BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_36BPP DISPLAY_NAME "12-bpc RGB or YCbCr 4:4:4 (36 bpp)"
set_parameter_property RX_SUPPORT_36BPP WIDTH ""
set_parameter_property RX_SUPPORT_36BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_36BPP UNITS None
set_parameter_property RX_SUPPORT_36BPP DESCRIPTION "Enable support for 36 bpp decoding"
set_parameter_property RX_SUPPORT_36BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_36BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_36BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_36BPP DERIVED true
set_parameter_property RX_SUPPORT_36BPP VISIBLE false

add_parameter RX_SUPPORT_48BPP INTEGER 1
set_parameter_property RX_SUPPORT_48BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_48BPP DISPLAY_NAME "16-bpc RGB or YCbCr 4:4:4 (48 bpp)"
set_parameter_property RX_SUPPORT_48BPP WIDTH ""
set_parameter_property RX_SUPPORT_48BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_48BPP UNITS None
set_parameter_property RX_SUPPORT_48BPP DESCRIPTION "Enable support for 48 bpp decoding"
set_parameter_property RX_SUPPORT_48BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_48BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_48BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_48BPP DERIVED true
set_parameter_property RX_SUPPORT_48BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR422_16BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR422_16BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR422_16BPP DISPLAY_NAME "8-bpc YCbCr 4:2:2 (16 bpp)"
set_parameter_property RX_SUPPORT_YCBCR422_16BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR422_16BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR422_16BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR422_16BPP DESCRIPTION "Enable support for 16 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR422_16BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR422_16BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR422_16BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR422_16BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR422_16BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR422_20BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR422_20BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR422_20BPP DISPLAY_NAME "10-bpc YCbCr 4:2:2 (20 bpp)"
set_parameter_property RX_SUPPORT_YCBCR422_20BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR422_20BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR422_20BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR422_20BPP DESCRIPTION "Enable support for 20 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR422_20BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR422_20BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR422_20BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR422_20BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR422_20BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR422_24BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR422_24BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR422_24BPP DISPLAY_NAME "12-bpc YCbCr 4:2:2 (24 bpp)"
set_parameter_property RX_SUPPORT_YCBCR422_24BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR422_24BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR422_24BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR422_24BPP DESCRIPTION "Enable support for 24 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR422_24BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR422_24BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR422_24BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR422_24BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR422_24BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR422_32BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR422_32BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR422_32BPP DISPLAY_NAME "16-bpc YCbCr 4:2:2 (32 bpp)"
set_parameter_property RX_SUPPORT_YCBCR422_32BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR422_32BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR422_32BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR422_32BPP DESCRIPTION "Enable support for 32 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR422_32BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR422_32BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR422_32BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR422_32BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR422_32BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR420_12BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR420_12BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR420_12BPP DISPLAY_NAME "8-bpc YCbCr 4:2:0 (12 bpp)"
set_parameter_property RX_SUPPORT_YCBCR420_12BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR420_12BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR420_12BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR420_12BPP DESCRIPTION "Enable support for 12 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR420_12BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR420_12BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR420_12BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR420_12BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR420_12BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR420_15BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR420_15BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR420_15BPP DISPLAY_NAME "10-bpc YCbCr 4:2:0 (15 bpp)"
set_parameter_property RX_SUPPORT_YCBCR420_15BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR420_15BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR420_15BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR420_15BPP DESCRIPTION "Enable support for 15 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR420_15BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR420_15BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR420_15BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR420_15BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR420_15BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR420_18BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR420_18BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR420_18BPP DISPLAY_NAME "12-bpc YCbCr 4:2:0 (18 bpp)"
set_parameter_property RX_SUPPORT_YCBCR420_18BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR420_18BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR420_18BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR420_18BPP DESCRIPTION "Enable support for 18 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR420_18BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR420_18BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR420_18BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR420_18BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR420_18BPP VISIBLE false

add_parameter RX_SUPPORT_YCBCR420_24BPP INTEGER 1
set_parameter_property RX_SUPPORT_YCBCR420_24BPP DEFAULT_VALUE false
set_parameter_property RX_SUPPORT_YCBCR420_24BPP DISPLAY_NAME "16-bpc YCbCr 4:2:0 (24 bpp)"
set_parameter_property RX_SUPPORT_YCBCR420_24BPP WIDTH ""
set_parameter_property RX_SUPPORT_YCBCR420_24BPP TYPE INTEGER
set_parameter_property RX_SUPPORT_YCBCR420_24BPP UNITS None
set_parameter_property RX_SUPPORT_YCBCR420_24BPP DESCRIPTION "Enable support for 24 bpp decoding"
set_parameter_property RX_SUPPORT_YCBCR420_24BPP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_YCBCR420_24BPP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_YCBCR420_24BPP DISPLAY_HINT boolean
set_parameter_property RX_SUPPORT_YCBCR420_24BPP DERIVED true
set_parameter_property RX_SUPPORT_YCBCR420_24BPP VISIBLE false


add_parameter RX_SUPPORT_DP INTEGER 1
set_parameter_property RX_SUPPORT_DP DEFAULT_VALUE true
set_parameter_property RX_SUPPORT_DP DISPLAY_NAME "Support DisplayPort sink"
set_parameter_property RX_SUPPORT_DP WIDTH ""
set_parameter_property RX_SUPPORT_DP TYPE INTEGER
set_parameter_property RX_SUPPORT_DP UNITS None
set_parameter_property RX_SUPPORT_DP DESCRIPTION "Enable DisplayPort sink"
set_parameter_property RX_SUPPORT_DP AFFECTS_GENERATION false
set_parameter_property RX_SUPPORT_DP HDL_PARAMETER true
set_parameter_property RX_SUPPORT_DP DISPLAY_HINT boolean

add_parameter RX_AUX_DEBUG INTEGER 1
set_parameter_property RX_AUX_DEBUG DEFAULT_VALUE false
set_parameter_property RX_AUX_DEBUG DISPLAY_NAME "Enable AUX debug stream"
set_parameter_property RX_AUX_DEBUG WIDTH ""
set_parameter_property RX_AUX_DEBUG TYPE INTEGER
set_parameter_property RX_AUX_DEBUG UNITS None
set_parameter_property RX_AUX_DEBUG DESCRIPTION "Enable AUX traffic output to an Avalon-ST port"
set_parameter_property RX_AUX_DEBUG AFFECTS_GENERATION true
set_parameter_property RX_AUX_DEBUG HDL_PARAMETER true
set_parameter_property RX_AUX_DEBUG DISPLAY_HINT boolean

add_parameter RX_IEEE_OUI INTEGER 1
set_parameter_property RX_IEEE_OUI DEFAULT_VALUE 1
set_parameter_property RX_IEEE_OUI DISPLAY_NAME "IEEE OUI"
set_parameter_property RX_IEEE_OUI TYPE INTEGER
set_parameter_property RX_IEEE_OUI UNITS None
set_parameter_property RX_IEEE_OUI ALLOWED_RANGES 0:16777215
set_parameter_property RX_IEEE_OUI AFFECTS_GENERATION true
set_parameter_property RX_IEEE_OUI HDL_PARAMETER true
set_parameter_property RX_IEEE_OUI DESCRIPTION "Specify an IEEE organizationally unique identifier (OUI) as part of the DPCD registers"

add_parameter RX_AUX_GPU INTEGER 1
set_parameter_property RX_AUX_GPU DEFAULT_VALUE true
set_parameter_property RX_AUX_GPU DISPLAY_NAME "Enable GPU control" 
set_parameter_property RX_AUX_GPU WIDTH ""
set_parameter_property RX_AUX_GPU TYPE INTEGER
set_parameter_property RX_AUX_GPU UNITS None
set_parameter_property RX_AUX_GPU DESCRIPTION "Use an embedded controller to control the sink"
set_parameter_property RX_AUX_GPU AFFECTS_GENERATION true
set_parameter_property RX_AUX_GPU HDL_PARAMETER true
set_parameter_property RX_AUX_GPU DISPLAY_HINT boolean

# Hidden MST support
if { $include_mst } {
  # MST
  add_parameter RX_SUPPORT_MST INTEGER 0
  set_parameter_property RX_SUPPORT_MST DEFAULT_VALUE 0
  set_parameter_property RX_SUPPORT_MST DISPLAY_NAME "Support MST"
  set_parameter_property RX_SUPPORT_MST TYPE INTEGER
  set_parameter_property RX_SUPPORT_MST DISPLAY_HINT boolean
  set_parameter_property RX_SUPPORT_MST UNITS None
  set_parameter_property RX_SUPPORT_MST AFFECTS_GENERATION true
  set_parameter_property RX_SUPPORT_MST HDL_PARAMETER true
  set_parameter_property RX_SUPPORT_MST DESCRIPTION "Support MST (multi-stream). Requires GPU control."
  set_parameter_update_callback RX_AUX_GPU update_rx_mst_params
  #set_parameter_update_callback RX_SUPPORT_MST update_design_example_variant1

  add_parameter RX_MAX_NUM_OF_STREAMS INTEGER 1
  set_parameter_property RX_MAX_NUM_OF_STREAMS DEFAULT_VALUE 1
  set_parameter_property RX_MAX_NUM_OF_STREAMS DISPLAY_NAME "Max stream count"
  set_parameter_property RX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {1:1}
  set_parameter_property RX_MAX_NUM_OF_STREAMS UNITS None
  set_parameter_property RX_MAX_NUM_OF_STREAMS DESCRIPTION "Maximum number of streams supported by Sink"
  set_parameter_property RX_MAX_NUM_OF_STREAMS AFFECTS_GENERATION true
  set_parameter_property RX_MAX_NUM_OF_STREAMS HDL_PARAMETER true
  set_parameter_update_callback RX_SUPPORT_MST update_rx_max_stream_params
}


# Design Example Parameter
    add_parameter SELECT_SUPPORTED_VARIANT INTEGER 0
    set_parameter_property SELECT_SUPPORTED_VARIANT DEFAULT_VALUE "1"
    set_parameter_property SELECT_SUPPORTED_VARIANT DISPLAY_NAME "Select Design"
    set_parameter_property SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "0:None" "1:DisplayPort SST Parallel Loopback with PCR"}
    set_parameter_property SELECT_SUPPORTED_VARIANT HDL_PARAMETER false
    set_parameter_update_callback SELECT_SUPPORTED_VARIANT update_support_var_params
    set_parameter_property SELECT_SUPPORTED_VARIANT DESCRIPTION \
        "<html>Please select available design for Design Example generation.<br> \
        <br> \
        <b>None</b>: <br> \
		When there is no design example available for current parameter selections. \
        For example, when Parameter <b>Support MST</b> is selected. <br><br> \
        <b>DisplayPort SST Parallel Loopback with PCR</b>: <br> \
		This design example demonstrate parallel loopback from DisplayPort Sink to DisplayPort Source through a Pixel Clock Recovery (PCR) \
        when Source Parameter <b>Enable Video Input Image Port</b> is not selected.<br><br> \
        <br> \
        <i>Please note that when you apply preset, current IP and other parameter settings will be set to match those of selected preset. \
        If you like to save your current settings, you should do so before you hit apply preset. Also you can always save the new 'preset' \
        settings under a different name using File->Save as</i></html>"

    add_parameter ENABLE_ED_FILESET_SYNTHESIS INTEGER 0
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DEFAULT_VALUE 1
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_NAME "Synthesis"
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DESCRIPTION "When Synthesis box is checked, all necessary filesets required for synthesis will be generated."
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS TYPE INTEGER
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS UNITS None
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS DISPLAY_HINT boolean
    set_parameter_property ENABLE_ED_FILESET_SYNTHESIS HDL_PARAMETER false

    add_parameter ENABLE_ED_FILESET_SIM INTEGER 0
    set_parameter_property ENABLE_ED_FILESET_SIM DEFAULT_VALUE 0
    set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_NAME "Simulation"
    set_parameter_property ENABLE_ED_FILESET_SIM DESCRIPTION "When Simulation box is checked, all necessary filesets required for simulation will be generated."
    set_parameter_property ENABLE_ED_FILESET_SIM TYPE INTEGER
    set_parameter_property ENABLE_ED_FILESET_SIM UNITS None
    set_parameter_property ENABLE_ED_FILESET_SIM DISPLAY_HINT boolean
    set_parameter_property ENABLE_ED_FILESET_SIM HDL_PARAMETER false

    add_parameter SELECT_ED_FILESET string "VERILOG"
    set_parameter_property SELECT_ED_FILESET DEFAULT_VALUE "VERILOG"
    set_parameter_property SELECT_ED_FILESET DISPLAY_NAME "Generate File Format"
    set_parameter_property SELECT_ED_FILESET DESCRIPTION \
        "Please select an HDL format for the generated Design Example filesets. \
        Note that this will only affect the generated top level IP files."
    set_parameter_property SELECT_ED_FILESET ALLOWED_RANGES { "VERILOG:Verilog" "VHDL:VHDL"}
    set_parameter_property SELECT_ED_FILESET HDL_PARAMETER false

    add_parameter SELECT_TARGETED_BOARD INTEGER 0
    set_parameter_property SELECT_TARGETED_BOARD DEFAULT_VALUE "0"
    set_parameter_property SELECT_TARGETED_BOARD DISPLAY_NAME "Select Board"
    set_parameter_property SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "1:Arria 10 GX FPGA Development Kit" "2:Custom Development Kit" }
    set_parameter_property SELECT_TARGETED_BOARD HDL_PARAMETER false
    set_parameter_update_callback SELECT_TARGETED_BOARD update_target_board_params
    set_parameter_property SELECT_TARGETED_BOARD DESCRIPTION \
        "<html>This option provides supports for various Development Kits listed. The details of Intel FPGA Development Kits can be found on Intel FPGA website \
        <a href='https://www.altera.com/products/boards_and_kits/all-development-kits.html'>https://www.altera.com/products/boards_and_kits/all-development-kits.html</a>. \
        If this menu is greyed out, it is because no board is supported for the options selected such as synthesis checked off. \
        If an Intel FPGA Development board is selected, the Target Device used for generation will be the one that matches the device on the Development Kit<br> \
        <br> \
        <b>Altera  Development Kit:</b><br> \
        This option allows the Design Example to be tested on the selected Altera development kit. \
        This selection automatically selects the Target Device to match the device on the selected Altera development kit. \
        If your board revision has a different grade of this device, you can correct it.<br> \
        <br> \
        <b>Custom Development Kit:</b><br> \
        This option allows the Design Example to be tested on a third party development kit with Altera device, \
        a custom designed board with Altera device, or a standard Altera development kit not available for selection. \
        You may also select a custom device for the custom development kit.<br> \
        <br> \
        <b>No Development Kit:</b><br> \
        This option excluding hardware aspects for the Design Example.</html>"

    add_parameter SELECT_CUSTOM_DEVICE INTEGER 0
    set_parameter_property SELECT_CUSTOM_DEVICE DEFAULT_VALUE 0
    set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_NAME "Change Target Device"
    set_parameter_property SELECT_CUSTOM_DEVICE DESCRIPTION \
        "<html>When select, user is able to select different device grade for Altera development kit. \
        For device specific details look for Device data sheet on <a href='http://www.altera.com/'>www.altera.com</a></html>"
    set_parameter_property SELECT_CUSTOM_DEVICE TYPE INTEGER
    set_parameter_property SELECT_CUSTOM_DEVICE UNITS None
    set_parameter_property SELECT_CUSTOM_DEVICE DISPLAY_HINT boolean
    set_parameter_property SELECT_CUSTOM_DEVICE HDL_PARAMETER false
    
    
# +-----------------------------------
# | 
# | INTERFACES
# | 
# +-----------------------------------

# +-----------------------------------
# | DP SOURCE
# +-----------------------------------

# +-----------------------------------
# | connection point tx_gxb_conduit
# | 
add_interface tx_xcvr_interface conduit end

# +-----------------------------------
# | connection point tx_aux
# | 
add_interface tx_aux conduit end

set_interface_property tx_aux ENABLED true

add_interface_port tx_aux tx_aux_in tx_aux_in Input 1
add_interface_port tx_aux tx_aux_out tx_aux_out Output 1
add_interface_port tx_aux tx_aux_oe tx_aux_oe Output 1
add_interface_port tx_aux tx_hpd tx_hpd Input 1

# +-----------------------------------
# | connection point aux_tx_debug_st
# | 
add_interface tx_aux_debug avalon_streaming start
set_interface_property tx_aux_debug associatedClock aux_clk
set_interface_property tx_aux_debug associatedReset aux_reset
set_interface_property tx_aux_debug dataBitsPerSymbol 32
set_interface_property tx_aux_debug errorDescriptor ""
set_interface_property tx_aux_debug maxChannel 1
set_interface_property tx_aux_debug readyLatency 0

add_interface_port tx_aux_debug tx_aux_debug_data data Output 32
add_interface_port tx_aux_debug tx_aux_debug_valid valid Output 1
add_interface_port tx_aux_debug tx_aux_debug_sop startofpacket Output 1
add_interface_port tx_aux_debug tx_aux_debug_eop endofpacket Output 1
add_interface_port tx_aux_debug tx_aux_debug_err error Output 1
add_interface_port tx_aux_debug tx_aux_debug_cha channel Output 1

# +-----------------------------------
# | connection point tx_gtc
# | 
add_interface tx_gtc conduit  end
add_interface_port tx_gtc tx_clk_gtc tx_clk_gtc Input 1
add_interface_port tx_gtc tx_gtc_value tx_gtc_value Input 32
add_interface_port tx_gtc tx_gtc_fce tx_gtc_fce Output 32
add_interface_port tx_gtc tx_gtc_remote tx_gtc_remote Output 32
add_interface_port tx_gtc tx_gtc_update tx_gtc_update Output 1

# +-----------------------------------
# | connection point txN_vid_clk
# | 
add_interface tx_vid_clk clock end
set_interface_property tx_vid_clk clockRate 0
add_interface_port tx_vid_clk tx_vid_clk clk Input 1
add_interface tx1_vid_clk clock end
set_interface_property tx1_vid_clk clockRate 0
add_interface_port tx1_vid_clk tx1_vid_clk clk Input 1
add_interface tx2_vid_clk clock end
set_interface_property tx2_vid_clk clockRate 0
add_interface_port tx2_vid_clk tx2_vid_clk clk Input 1
add_interface tx3_vid_clk clock end
set_interface_property tx3_vid_clk clockRate 0
add_interface_port tx3_vid_clk tx3_vid_clk clk Input 1

# +-----------------------------------
# | connection point txN_video_in
# | 
add_interface tx_video_in conduit end
add_interface tx1_video_in conduit end
add_interface tx2_video_in conduit end
add_interface tx3_video_in conduit end

# +-----------------------------------
# | connection point txN_im_clk
# | 
add_interface tx_im_clk clock end
set_interface_property tx_im_clk clockRate 0
add_interface_port tx_im_clk tx_im_clk clk Input 1
add_interface tx1_im_clk clock end
set_interface_property tx1_im_clk clockRate 0
add_interface_port tx1_im_clk tx1_im_clk clk Input 1
add_interface tx2_im_clk clock end
set_interface_property tx2_im_clk clockRate 0
add_interface_port tx2_im_clk tx2_im_clk clk Input 1
add_interface tx3_im_clk clock end
set_interface_property tx3_im_clk clockRate 0
add_interface_port tx3_im_clk tx3_im_clk clk Input 1

# +-----------------------------------
# | connection point txN_video_in_im
# | 
add_interface tx_video_in_im conduit end
add_interface_port tx_video_in_im tx_im_sol tx_im_sol Input 1
add_interface_port tx_video_in_im tx_im_eol tx_im_eol Input 1
add_interface_port tx_video_in_im tx_im_sof tx_im_sof Input 1
add_interface_port tx_video_in_im tx_im_eof tx_im_eof Input 1
add_interface_port tx_video_in_im tx_im_locked tx_im_locked Input 1
add_interface_port tx_video_in_im tx_im_interlace tx_im_interlace Input 1
add_interface_port tx_video_in_im tx_im_field tx_im_field Input 1
add_interface_port tx_video_in_im tx_im_full tx_im_full Output 1
add_interface_port tx_video_in_im tx_im_afull tx_im_afull Output 1
add_interface_port tx_video_in_im tx_im_aempty tx_im_aempty Output 1
add_interface_port tx_video_in_im tx_im_empty tx_im_empty Output 1
add_interface tx1_video_in_im conduit end
add_interface_port tx1_video_in_im tx1_im_sol tx1_im_sol Input 1
add_interface_port tx1_video_in_im tx1_im_eol tx1_im_eol Input 1
add_interface_port tx1_video_in_im tx1_im_sof tx1_im_sof Input 1
add_interface_port tx1_video_in_im tx1_im_eof tx1_im_eof Input 1
add_interface_port tx1_video_in_im tx1_im_locked tx1_im_locked Input 1
add_interface_port tx1_video_in_im tx1_im_interlace tx1_im_interlace Input 1
add_interface_port tx1_video_in_im tx1_im_field tx1_im_field Input 1
add_interface_port tx1_video_in_im tx1_im_full tx1_im_full Output 1
add_interface_port tx1_video_in_im tx1_im_afull tx1_im_afull Output 1
add_interface_port tx1_video_in_im tx1_im_aempty tx1_im_aempty Output 1
add_interface_port tx1_video_in_im tx1_im_empty tx1_im_empty Output 1
add_interface tx2_video_in_im conduit end
add_interface_port tx2_video_in_im tx2_im_sol tx2_im_sol Input 1
add_interface_port tx2_video_in_im tx2_im_eol tx2_im_eol Input 1
add_interface_port tx2_video_in_im tx2_im_sof tx2_im_sof Input 1
add_interface_port tx2_video_in_im tx2_im_eof tx2_im_eof Input 1
add_interface_port tx2_video_in_im tx2_im_locked tx2_im_locked Input 1
add_interface_port tx2_video_in_im tx2_im_interlace tx2_im_interlace Input 1
add_interface_port tx2_video_in_im tx2_im_field tx2_im_field Input 1
add_interface_port tx2_video_in_im tx2_im_full tx2_im_full Output 1
add_interface_port tx2_video_in_im tx2_im_afull tx2_im_afull Output 1
add_interface_port tx2_video_in_im tx2_im_aempty tx2_im_aempty Output 1
add_interface_port tx2_video_in_im tx2_im_empty tx2_im_empty Output 1
add_interface tx3_video_in_im conduit end
add_interface_port tx3_video_in_im tx3_im_sol tx3_im_sol Input 1
add_interface_port tx3_video_in_im tx3_im_eol tx3_im_eol Input 1
add_interface_port tx3_video_in_im tx3_im_sof tx3_im_sof Input 1
add_interface_port tx3_video_in_im tx3_im_eof tx3_im_eof Input 1
add_interface_port tx3_video_in_im tx3_im_locked tx3_im_locked Input 1
add_interface_port tx3_video_in_im tx3_im_interlace tx3_im_interlace Input 1
add_interface_port tx3_video_in_im tx3_im_field tx3_im_field Input 1
add_interface_port tx3_video_in_im tx3_im_full tx3_im_full Output 1
add_interface_port tx3_video_in_im tx3_im_afull tx3_im_afull Output 1
add_interface_port tx3_video_in_im tx3_im_aempty tx3_im_aempty Output 1
add_interface_port tx3_video_in_im tx3_im_empty tx3_im_empty Output 1

# +-----------------------------------
# | connection point txN_ss
# | 
add_interface tx_ss avalon_streaming end
set_interface_property tx_ss associatedClock tx_ss_clk
set_interface_property tx_ss associatedReset reset
set_interface_property tx_ss dataBitsPerSymbol 128
set_interface_property tx_ss errorDescriptor ""
set_interface_property tx_ss maxChannel 0
set_interface_property tx_ss readyLatency 0

add_interface tx1_ss avalon_streaming end
set_interface_property tx1_ss associatedClock tx_ss_clk
set_interface_property tx1_ss associatedReset reset
set_interface_property tx1_ss dataBitsPerSymbol 128
set_interface_property tx1_ss errorDescriptor ""
set_interface_property tx1_ss maxChannel 0
set_interface_property tx1_ss readyLatency 0

add_interface tx2_ss avalon_streaming end
set_interface_property tx2_ss associatedClock tx_ss_clk
set_interface_property tx2_ss associatedReset reset
set_interface_property tx2_ss dataBitsPerSymbol 128
set_interface_property tx2_ss errorDescriptor ""
set_interface_property tx2_ss maxChannel 0
set_interface_property tx2_ss readyLatency 0

add_interface tx3_ss avalon_streaming end
set_interface_property tx3_ss associatedClock tx_ss_clk
set_interface_property tx3_ss associatedReset reset
set_interface_property tx3_ss dataBitsPerSymbol 128
set_interface_property tx3_ss errorDescriptor ""
set_interface_property tx3_ss maxChannel 0
set_interface_property tx3_ss readyLatency 0

add_interface_port tx_ss tx_ss_ready ready Output 1
add_interface_port tx_ss tx_ss_valid valid Input 1
add_interface_port tx_ss tx_ss_data data Input 128
add_interface_port tx_ss tx_ss_sop startofpacket Input 1
add_interface_port tx_ss tx_ss_eop endofpacket Input 1

add_interface_port tx1_ss tx1_ss_ready ready Output 1
add_interface_port tx1_ss tx1_ss_valid valid Input 1
add_interface_port tx1_ss tx1_ss_data data Input 128
add_interface_port tx1_ss tx1_ss_sop startofpacket Input 1
add_interface_port tx1_ss tx1_ss_eop endofpacket Input 1

add_interface_port tx2_ss tx2_ss_ready ready Output 1
add_interface_port tx2_ss tx2_ss_valid valid Input 1
add_interface_port tx2_ss tx2_ss_data data Input 128
add_interface_port tx2_ss tx2_ss_sop startofpacket Input 1
add_interface_port tx2_ss tx2_ss_eop endofpacket Input 1

add_interface_port tx3_ss tx3_ss_ready ready Output 1
add_interface_port tx3_ss tx3_ss_valid valid Input 1
add_interface_port tx3_ss tx3_ss_data data Input 128
add_interface_port tx3_ss tx3_ss_sop startofpacket Input 1
add_interface_port tx3_ss tx3_ss_eop endofpacket Input 1

# +-----------------------------------
# | connection point tx_ss_clk
# | 
add_interface tx_ss_clk clock start
set_interface_property tx_ss_clk clockRate 0

add_interface_port tx_ss_clk tx_ss_clk clk Output 1

# +-----------------------------------
# | connection point txN_audio
# | 
add_interface tx_audio_clk clock end
set_interface_property tx_audio_clk clockRate 0
add_interface_port tx_audio_clk tx_audio_clk clk Input 1
add_interface tx1_audio_clk clock end
set_interface_property tx1_audio_clk clockRate 0
add_interface_port tx1_audio_clk tx1_audio_clk clk Input 1
add_interface tx2_audio_clk clock end
set_interface_property tx2_audio_clk clockRate 0
add_interface_port tx2_audio_clk tx2_audio_clk clk Input 1
add_interface tx3_audio_clk clock end
set_interface_property tx3_audio_clk clockRate 0
add_interface_port tx3_audio_clk tx3_audio_clk clk Input 1

add_interface tx_audio conduit  end
add_interface_port tx_audio tx_audio_valid tx_audio_valid Input 1
add_interface_port tx_audio tx_audio_mute tx_audio_mute Input 1
add_interface tx1_audio conduit  end
add_interface_port tx1_audio tx1_audio_valid tx1_audio_valid Input 1
add_interface_port tx1_audio tx1_audio_mute tx1_audio_mute Input 1
add_interface tx2_audio conduit  end
add_interface_port tx2_audio tx2_audio_valid tx2_audio_valid Input 1
add_interface_port tx2_audio tx2_audio_mute tx2_audio_mute Input 1
add_interface tx3_audio conduit  end
add_interface_port tx3_audio tx3_audio_valid tx3_audio_valid Input 1
add_interface_port tx3_audio tx3_audio_mute tx3_audio_mute Input 1

# +-----------------------------------
# | connection point txN_msa_conduit
# | 
#add_interface tx_msa_conduit conduit end
#add_interface_port tx_msa_conduit tx_msa export Input 192
#add_interface tx1_msa_conduit conduit end
#add_interface_port tx1_msa_conduit tx1_msa export Input 192
#add_interface tx2_msa_conduit conduit end
#add_interface_port tx2_msa_conduit tx2_msa export Input 192
#add_interface tx3_msa_conduit conduit end
#add_interface_port tx3_msa_conduit tx3_msa export Input 192

# +-----------------------------------
# | connection point tx_hdcp_enc_conduit
# | 
# add_interface tx_hdcp_enc_conduit conduit end

# +-----------------------------------
# | DP SINK
# +-----------------------------------

# +-----------------------------------
# | connection point rx_gxb_conduit
# | 
add_interface rx_xcvr_interface conduit end

# +-----------------------------------
# | connection point rx_aux
# | 
add_interface rx_aux conduit end

add_interface_port rx_aux rx_aux_in rx_aux_in Input 1
add_interface_port rx_aux rx_aux_out rx_aux_out Output 1
add_interface_port rx_aux rx_aux_oe rx_aux_oe Output 1
add_interface_port rx_aux rx_hpd rx_hpd Output 1
add_interface_port rx_aux rx_cable_detect rx_cable_detect Input 1
add_interface_port rx_aux rx_pwr_detect rx_pwr_detect Input 1

# +-----------------------------------
# | connection point rx_i2c
# | 
# add_interface rx_i2c conduit end

# add_interface_port rx_i2c rx_i2c0_scl export
# add_interface_port rx_i2c rx_i2c0_sda export
# add_interface_port rx_i2c rx_i2c1_scl export
# add_interface_port rx_i2c rx_i2c1_sda export

# +-----------------------------------
# | connection point rx_params
# | 
add_interface rx_params conduit end

add_interface_port rx_params rx_lane_count rx_lane_count Output 5

# +-----------------------------------
# | connection point rx_gtc
# | 
add_interface rx_gtc conduit  end
add_interface_port rx_gtc rx_clk_gtc rx_clk_gtc Input 1
add_interface_port rx_gtc rx_gtc_value rx_gtc_value Input 32
add_interface_port rx_gtc rx_gtc_fce rx_gtc_fce Output 32
add_interface_port rx_gtc rx_gtc_remote rx_gtc_remote Output 32
add_interface_port rx_gtc rx_gtc_update rx_gtc_update Output 1

# +-----------------------------------
# | connection point rxN_video_out_im
# | 
add_interface rx_video_out conduit end
add_interface_port rx_video_out rx_vid_sol rx_vid_sol Output 1
add_interface_port rx_video_out rx_vid_eol rx_vid_eol Output 1
add_interface_port rx_video_out rx_vid_sof rx_vid_sof Output 1
add_interface_port rx_video_out rx_vid_eof rx_vid_eof Output 1
add_interface_port rx_video_out rx_vid_locked rx_vid_locked Output 1
add_interface_port rx_video_out rx_vid_interlace rx_vid_interlace Output 1
add_interface_port rx_video_out rx_vid_field rx_vid_field Output 1
add_interface_port rx_video_out rx_vid_overflow rx_vid_overflow Output 1
add_interface rx1_video_out conduit end
add_interface_port rx1_video_out rx1_vid_sol rx1_vid_sol Output 1
add_interface_port rx1_video_out rx1_vid_eol rx1_vid_eol Output 1
add_interface_port rx1_video_out rx1_vid_sof rx1_vid_sof Output 1
add_interface_port rx1_video_out rx1_vid_eof rx1_vid_eof Output 1
add_interface_port rx1_video_out rx1_vid_locked rx1_vid_locked Output 1
add_interface_port rx1_video_out rx1_vid_interlace rx1_vid_interlace Output 1
add_interface_port rx1_video_out rx1_vid_field rx1_vid_field Output 1
add_interface_port rx1_video_out rx1_vid_overflow rx1_vid_overflow Output 1
add_interface rx2_video_out conduit end
add_interface_port rx2_video_out rx2_vid_sol rx2_vid_sol Output 1
add_interface_port rx2_video_out rx2_vid_eol rx2_vid_eol Output 1
add_interface_port rx2_video_out rx2_vid_sof rx2_vid_sof Output 1
add_interface_port rx2_video_out rx2_vid_eof rx2_vid_eof Output 1
add_interface_port rx2_video_out rx2_vid_locked rx2_vid_locked Output 1
add_interface_port rx2_video_out rx2_vid_interlace rx2_vid_interlace Output 1
add_interface_port rx2_video_out rx2_vid_field rx2_vid_field Output 1
add_interface_port rx2_video_out rx2_vid_overflow rx2_vid_overflow Output 1
add_interface rx3_video_out conduit end
add_interface_port rx3_video_out rx3_vid_sol rx3_vid_sol Output 1
add_interface_port rx3_video_out rx3_vid_eol rx3_vid_eol Output 1
add_interface_port rx3_video_out rx3_vid_sof rx3_vid_sof Output 1
add_interface_port rx3_video_out rx3_vid_eof rx3_vid_eof Output 1
add_interface_port rx3_video_out rx3_vid_locked rx3_vid_locked Output 1
add_interface_port rx3_video_out rx3_vid_interlace rx3_vid_interlace Output 1
add_interface_port rx3_video_out rx3_vid_field rx3_vid_field Output 1
add_interface_port rx3_video_out rx3_vid_overflow rx3_vid_overflow Output 1

# +-----------------------------------
# | connection point rxN_video_out_st
# | 
# add_interface rx_video_out_st avalon_streaming start
# set_interface_property rx_video_out_st associatedClock rx_vid_clk
# set_interface_property rx_video_out_st associatedReset rx_vid_st_reset
# set_interface_property rx_video_out_st errorDescriptor ""
# set_interface_property rx_video_out_st maxChannel 0
# set_interface_property rx_video_out_st readyLatency 1
# add_interface rx1_video_out_st avalon_streaming start
# set_interface_property rx1_video_out_st associatedClock rx1_vid_clk
# set_interface_property rx1_video_out_st associatedReset rx1_vid_st_reset
# set_interface_property rx1_video_out_st errorDescriptor ""
# set_interface_property rx1_video_out_st maxChannel 0
# set_interface_property rx1_video_out_st readyLatency 1
# add_interface rx2_video_out_st avalon_streaming start
# set_interface_property rx2_video_out_st associatedClock rx2_vid_clk
# set_interface_property rx2_video_out_st associatedReset rx2_vid_st_reset
# set_interface_property rx2_video_out_st errorDescriptor ""
# set_interface_property rx2_video_out_st maxChannel 0
# set_interface_property rx2_video_out_st readyLatency 1
# add_interface rx3_video_out_st avalon_streaming start
# set_interface_property rx3_video_out_st associatedClock rx3_vid_clk
# set_interface_property rx3_video_out_st associatedReset rx3_vid_st_reset
# set_interface_property rx3_video_out_st errorDescriptor ""
# set_interface_property rx3_video_out_st maxChannel 0
# set_interface_property rx3_video_out_st readyLatency 1

# add_interface_port rx_video_out_st rx_vid_st_ready ready Input 1
# add_interface_port rx_video_out_st rx_vid_st_valid valid Output 1
# add_interface_port rx_video_out_st rx_vid_st_sop startofpacket Output 1
# add_interface_port rx_video_out_st rx_vid_st_eop endofpacket Output 1
# add_interface_port rx1_video_out_st rx1_vid_st_ready ready Input 1
# add_interface_port rx1_video_out_st rx1_vid_st_valid valid Output 1
# add_interface_port rx1_video_out_st rx1_vid_st_sop startofpacket Output 1
# add_interface_port rx1_video_out_st rx1_vid_st_eop endofpacket Output 1
# add_interface_port rx2_video_out_st rx2_vid_st_ready ready Input 1
# add_interface_port rx2_video_out_st rx2_vid_st_valid valid Output 1
# add_interface_port rx2_video_out_st rx2_vid_st_sop startofpacket Output 1
# add_interface_port rx2_video_out_st rx2_vid_st_eop endofpacket Output 1
# add_interface_port rx3_video_out_st rx3_vid_st_ready ready Input 1
# add_interface_port rx3_video_out_st rx3_vid_st_valid valid Output 1
# add_interface_port rx3_video_out_st rx3_vid_st_sop startofpacket Output 1
# add_interface_port rx3_video_out_st rx3_vid_st_eop endofpacket Output 1

# +-----------------------------------
# | connection point rxN_video_out_clk
# | 
add_interface rx_vid_clk clock end
set_interface_property rx_vid_clk clockRate 0
add_interface_port rx_vid_clk rx_vid_clk clk Input 1
add_interface rx1_vid_clk clock end
set_interface_property rx1_vid_clk clockRate 0
add_interface_port rx1_vid_clk rx1_vid_clk clk Input 1
add_interface rx2_vid_clk clock end
set_interface_property rx2_vid_clk clockRate 0
add_interface_port rx2_vid_clk rx2_vid_clk clk Input 1
add_interface rx3_vid_clk clock end
set_interface_property rx3_vid_clk clockRate 0
add_interface_port rx3_vid_clk rx3_vid_clk clk Input 1

# +-----------------------------------
# | connection point rxN_video_out_clk_reset
# | 
# add_interface rx_vid_st_reset reset end
# set_interface_property rx_vid_st_reset associatedClock rx_vid_clk
# set_interface_property rx_vid_st_reset synchronousEdges DEASSERT
# add_interface_port rx_vid_st_reset rx_vid_st_reset reset Input 1
# add_interface rx1_vid_st_reset reset end
# set_interface_property rx1_vid_st_reset associatedClock rx1_vid_clk
# set_interface_property rx1_vid_st_reset synchronousEdges DEASSERT
# add_interface_port rx1_vid_st_reset rx1_vid_st_reset reset Input 1
# add_interface rx2_vid_st_reset reset end
# set_interface_property rx2_vid_st_reset associatedClock rx2_vid_clk
# set_interface_property rx2_vid_st_reset synchronousEdges DEASSERT
# add_interface_port rx2_vid_st_reset rx2_vid_st_reset reset Input 1
# add_interface rx3_vid_st_reset reset end
# set_interface_property rx3_vid_st_reset associatedClock rx3_vid_clk
# set_interface_property rx3_vid_st_reset synchronousEdges DEASSERT
# add_interface_port rx3_vid_st_reset rx3_vid_st_reset reset Input 1

# +-----------------------------------
# | connection point rxN_stream_out
# | 
add_interface rx_stream conduit end
add_interface_port rx_stream rx_stream_valid rx_stream_valid Output 1
add_interface_port rx_stream rx_stream_clk rx_stream_clk Output 1
add_interface rx1_stream conduit end
add_interface_port rx1_stream rx1_stream_valid rx1_stream_valid Output 1
add_interface_port rx1_stream rx1_stream_clk rx1_stream_clk Output 1
add_interface rx2_stream conduit end
add_interface_port rx2_stream rx2_stream_valid rx2_stream_valid Output 1
add_interface_port rx2_stream rx2_stream_clk rx2_stream_clk Output 1
add_interface rx3_stream conduit end
add_interface_port rx3_stream rx3_stream_valid rx3_stream_valid Output 1
add_interface_port rx3_stream rx3_stream_clk rx3_stream_clk Output 1

# +-----------------------------------
# | connection point aux_rx_debug_st
# | 
add_interface rx_aux_debug avalon_streaming start
set_interface_property rx_aux_debug associatedClock aux_clk
set_interface_property rx_aux_debug associatedReset aux_reset
set_interface_property rx_aux_debug dataBitsPerSymbol 32
set_interface_property rx_aux_debug errorDescriptor ""
set_interface_property rx_aux_debug maxChannel 1
set_interface_property rx_aux_debug readyLatency 0

add_interface_port rx_aux_debug rx_aux_debug_data data Output 32
add_interface_port rx_aux_debug rx_aux_debug_valid valid Output 1
add_interface_port rx_aux_debug rx_aux_debug_sop startofpacket Output 1
add_interface_port rx_aux_debug rx_aux_debug_eop endofpacket Output 1
add_interface_port rx_aux_debug rx_aux_debug_err error Output 1
add_interface_port rx_aux_debug rx_aux_debug_cha channel Output 1

# +-----------------------------------
# | connection point rxN_ss
# | 
add_interface rx_ss avalon_streaming start
set_interface_property rx_ss associatedClock rx_ss_clk
set_interface_property rx_ss associatedReset reset
set_interface_property rx_ss dataBitsPerSymbol 160
set_interface_property rx_ss errorDescriptor ""
set_interface_property rx_ss maxChannel 0
set_interface_property rx_ss readyLatency 1
add_interface rx1_ss avalon_streaming start
set_interface_property rx1_ss associatedClock rx_ss_clk
set_interface_property rx1_ss associatedReset reset
set_interface_property rx1_ss dataBitsPerSymbol 160
set_interface_property rx1_ss errorDescriptor ""
set_interface_property rx1_ss maxChannel 0
set_interface_property rx1_ss readyLatency 1
add_interface rx2_ss avalon_streaming start
set_interface_property rx2_ss associatedClock rx_ss_clk
set_interface_property rx2_ss associatedReset reset
set_interface_property rx2_ss dataBitsPerSymbol 160
set_interface_property rx2_ss errorDescriptor ""
set_interface_property rx2_ss maxChannel 0
set_interface_property rx2_ss readyLatency 1
add_interface rx3_ss avalon_streaming start
set_interface_property rx3_ss associatedClock rx_ss_clk
set_interface_property rx3_ss associatedReset reset
set_interface_property rx3_ss dataBitsPerSymbol 160
set_interface_property rx3_ss errorDescriptor ""
set_interface_property rx3_ss maxChannel 0
set_interface_property rx3_ss readyLatency 1

add_interface_port rx_ss rx_ss_valid valid Output 1
add_interface_port rx_ss rx_ss_data data Output 160
add_interface_port rx_ss rx_ss_sop startofpacket Output 1
add_interface_port rx_ss rx_ss_eop endofpacket Output 1  
add_interface_port rx1_ss rx1_ss_valid valid Output 1
add_interface_port rx1_ss rx1_ss_data data Output 160
add_interface_port rx1_ss rx1_ss_sop startofpacket Output 1
add_interface_port rx1_ss rx1_ss_eop endofpacket Output 1  
add_interface_port rx2_ss rx2_ss_valid valid Output 1
add_interface_port rx2_ss rx2_ss_data data Output 160
add_interface_port rx2_ss rx2_ss_sop startofpacket Output 1
add_interface_port rx2_ss rx2_ss_eop endofpacket Output 1  
add_interface_port rx3_ss rx3_ss_valid valid Output 1
add_interface_port rx3_ss rx3_ss_data data Output 160
add_interface_port rx3_ss rx3_ss_sop startofpacket Output 1
add_interface_port rx3_ss rx3_ss_eop endofpacket Output 1  

# +-----------------------------------
# | connection point rx_ss_clk
# | 
add_interface rx_ss_clk clock start
set_interface_property rx_ss_clk clockRate 0

add_interface_port rx_ss_clk rx_ss_clk clk Output 1

# +-----------------------------------
# | connection point rxN_msa_conduit
# | 
add_interface rx_msa_conduit conduit end
add_interface_port rx_msa_conduit rx_msa rx_msa Output 217
add_interface rx1_msa_conduit conduit end
add_interface_port rx1_msa_conduit rx1_msa rx1_msa Output 217
add_interface rx2_msa_conduit conduit end
add_interface_port rx2_msa_conduit rx2_msa rx2_msa Output 217
add_interface rx3_msa_conduit conduit end
add_interface_port rx3_msa_conduit rx3_msa rx3_msa Output 217

# +-----------------------------------
# | connection point rxN_audio
# | 
add_interface rx_audio conduit  end
add_interface_port rx_audio rx_audio_valid rx_audio_valid Output 1
add_interface_port rx_audio rx_audio_mute rx_audio_mute Output 1
add_interface_port rx_audio rx_audio_infoframe rx_audio_infoframe Output 40
 add_interface rx1_audio conduit  end
add_interface_port rx1_audio rx1_audio_valid rx1_audio_valid Output 1
add_interface_port rx1_audio rx1_audio_mute rx1_audio_mute Output 1
add_interface_port rx1_audio rx1_audio_infoframe rx1_audio_infoframe Output 40
add_interface rx2_audio conduit  end
add_interface_port rx2_audio rx2_audio_valid rx2_audio_valid Output 1
add_interface_port rx2_audio rx2_audio_mute rx2_audio_mute Output 1
add_interface_port rx2_audio rx2_audio_infoframe rx2_audio_infoframe Output 40
add_interface rx3_audio conduit  end
add_interface_port rx3_audio rx3_audio_valid rx3_audio_valid Output 1
add_interface_port rx3_audio rx3_audio_mute rx3_audio_mute Output 1
add_interface_port rx3_audio rx3_audio_infoframe rx3_audio_infoframe Output 40

# +-----------------------------------
# | connection point rx_edid
# | 
add_interface rx_edid avalon start
set_interface_property rx_edid addressUnits SYMBOLS
set_interface_property rx_edid associatedClock aux_clk
set_interface_property rx_edid associatedReset aux_reset
set_interface_property rx_edid burstOnBurstBoundariesOnly false
set_interface_property rx_edid doStreamReads false
set_interface_property rx_edid doStreamWrites false
set_interface_property rx_edid linewrapBursts false
set_interface_property rx_edid readLatency 0

set_interface_property rx_edid ENABLED false

add_interface_port rx_edid rx_edid_address address Output 8
add_interface_port rx_edid rx_edid_readdata readdata Input 8
add_interface_port rx_edid rx_edid_writedata writedata Output 8
add_interface_port rx_edid rx_edid_read read Output 1
add_interface_port rx_edid rx_edid_write write Output 1
add_interface_port rx_edid rx_edid_waitrequest waitrequest Input 1

# +-----------------------------------
# | connection point rx_hdcp_dec_conduit
# | 
# add_interface rx_hdcp_dec_conduit conduit end

# +-----------------------------------
# | VARIOUS
# +-----------------------------------

# +-----------------------------------
# | connection point tx_reconfig_conduit
# | 
add_interface tx_analog_reconfig conduit end
add_interface tx_reconfig conduit end


# +-----------------------------------
# | connection point av_tx_control
# | 
add_interface tx_mgmt avalon end
set_interface_property tx_mgmt addressAlignment DYNAMIC
set_interface_property tx_mgmt addressUnits WORDS
set_interface_property tx_mgmt associatedClock clk
set_interface_property tx_mgmt associatedReset reset
set_interface_property tx_mgmt burstOnBurstBoundariesOnly false
set_interface_property tx_mgmt explicitAddressSpan 0
set_interface_property tx_mgmt holdTime 0
set_interface_property tx_mgmt isMemoryDevice false
set_interface_property tx_mgmt isNonVolatileStorage false
set_interface_property tx_mgmt linewrapBursts false
set_interface_property tx_mgmt maximumPendingReadTransactions 0
set_interface_property tx_mgmt printableDevice false
set_interface_property tx_mgmt readLatency 0
set_interface_property tx_mgmt readWaitTime 1
set_interface_property tx_mgmt setupTime 0
set_interface_property tx_mgmt timingUnits Cycles
set_interface_property tx_mgmt writeWaitTime 0

add_interface_port tx_mgmt tx_mgmt_address address Input 9
add_interface_port tx_mgmt tx_mgmt_chipselect chipselect Input 1
add_interface_port tx_mgmt tx_mgmt_read read Input 1
add_interface_port tx_mgmt tx_mgmt_write write Input 1
add_interface_port tx_mgmt tx_mgmt_writedata writedata Input 32
add_interface_port tx_mgmt tx_mgmt_readdata readdata Output 32
add_interface_port tx_mgmt tx_mgmt_waitrequest waitrequest Output 1

# +-----------------------------------
# | connection point av_tx_control_interrupt
# | 
add_interface tx_mgmt_interrupt interrupt end
set_interface_property tx_mgmt_interrupt associatedAddressablePoint tx_mgmt
set_interface_property tx_mgmt_interrupt associatedClock clk
set_interface_property tx_mgmt_interrupt associatedReset reset

add_interface_port tx_mgmt_interrupt tx_mgmt_irq irq Output 1

# +-----------------------------------
# | connection point rx_reconfig_conduit
# | 
add_interface rx_reconfig conduit end
add_interface rx_analog_reconfig conduit end

# +-----------------------------------
# | connection point av_rx_control
# | 
add_interface rx_mgmt avalon end
set_interface_property rx_mgmt addressAlignment DYNAMIC
set_interface_property rx_mgmt addressUnits WORDS
set_interface_property rx_mgmt associatedClock clk
set_interface_property rx_mgmt associatedReset reset
set_interface_property rx_mgmt burstOnBurstBoundariesOnly false
set_interface_property rx_mgmt explicitAddressSpan 0
set_interface_property rx_mgmt holdTime 0
set_interface_property rx_mgmt isMemoryDevice false
set_interface_property rx_mgmt isNonVolatileStorage false
set_interface_property rx_mgmt linewrapBursts false
set_interface_property rx_mgmt maximumPendingReadTransactions 0
set_interface_property rx_mgmt printableDevice false
set_interface_property rx_mgmt readLatency 0
set_interface_property rx_mgmt readWaitTime 1
set_interface_property rx_mgmt setupTime 0
set_interface_property rx_mgmt timingUnits Cycles
set_interface_property rx_mgmt writeWaitTime 0

set_interface_property rx_mgmt ENABLED true

add_interface_port rx_mgmt rx_mgmt_chipselect chipselect Input 1
add_interface_port rx_mgmt rx_mgmt_read read Input 1
add_interface_port rx_mgmt rx_mgmt_write write Input 1
add_interface_port rx_mgmt rx_mgmt_address address Input 9
add_interface_port rx_mgmt rx_mgmt_writedata writedata Input 32
add_interface_port rx_mgmt rx_mgmt_readdata readdata Output 32
add_interface_port rx_mgmt rx_mgmt_waitrequest waitrequest Output 1

# +-----------------------------------
# | connection point av_rx_control_interrupt
# | 
add_interface rx_mgmt_interrupt interrupt end
set_interface_property rx_mgmt_interrupt associatedAddressablePoint rx_mgmt
set_interface_property rx_mgmt_interrupt associatedClock clk
set_interface_property rx_mgmt_interrupt associatedReset reset

#set_interface_property rx_mgmt_interrupt ENABLED true

add_interface_port rx_mgmt_interrupt rx_mgmt_irq irq Output 1

# +-----------------------------------
# | connection point remregs
# | 
# add_interface lpm_remregs conduit end

# add_interface_port lpm_remregs lpm_remregs_miso export Output 1
# add_interface_port lpm_remregs lpm_remregs_mosi export Input 1
# add_interface_port lpm_remregs lpm_remregs_sclk export Input 1
# add_interface_port lpm_remregs lpm_remregs_ssn export Input 1

# +-----------------------------------
# | connection point lpm_control
# | 
# add_interface lpm_control conduit end
# add_interface_port lpm_control lpm_irq export Output 1
# add_interface_port lpm_control lpm_pwrdwn_req export Input 1
# add_interface_port lpm_control lpm_pwrdwn_ack export Output 1

# +-----------------------------------
# | connection point av_clk
# | 
add_interface clk clock end
set_interface_property clk clockRate 0

#set_interface_property clk ENABLED true

add_interface_port clk clk clk Input 1

# +-----------------------------------
# | connection point av_clk_reset
# | 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT

#set_interface_property reset ENABLED true

add_interface_port reset reset reset Input 1


# +-----------------------------------
# | connection point clk_16
# | 
add_interface aux_clk clock end
set_interface_property aux_clk clockRate 16000000

add_interface_port aux_clk aux_clk clk Input 1
set_interface_property aux_clk ENABLED true

add_interface aux_reset reset end
set_interface_property aux_reset associatedClock aux_clk
add_interface_port aux_reset aux_reset reset Input 1

# +-----------------------------------
# | connection point xcvr_mgmt_clk
# | 
add_interface xcvr_mgmt_clk clock end
set_interface_property xcvr_mgmt_clk clockRate 100000000
add_interface_port xcvr_mgmt_clk xcvr_mgmt_clk clk Input 1
set_interface_property xcvr_mgmt_clk ENABLED true

# +-----------------------------------
# | connection point clk_cal
# | 
add_interface clk_cal clock end
set_interface_property clk_cal clockRate 50000000
add_interface_port clk_cal clk_cal clk Input 1
set_interface_property clk_cal ENABLED true


# +-----------------------------------
# | TX/RX reconfig conduits
# | 

add_interface_port tx_reconfig tx_link_rate tx_link_rate Output 2
add_interface_port tx_reconfig tx_link_rate_8bits tx_link_rate_8bits Output 8
add_interface_port tx_reconfig tx_reconfig_req tx_reconfig_req Output 1
add_interface_port tx_reconfig tx_reconfig_ack tx_reconfig_ack Input 1
add_interface_port tx_reconfig tx_reconfig_busy tx_reconfig_busy Input 1

add_interface_port tx_analog_reconfig tx_analog_reconfig_req tx_analog_reconfig_req Output 1
add_interface_port tx_analog_reconfig tx_analog_reconfig_ack tx_analog_reconfig_ack Input 1
add_interface_port tx_analog_reconfig tx_analog_reconfig_busy tx_analog_reconfig_busy Input 1


add_interface_port rx_reconfig rx_link_rate rx_link_rate Output 2
add_interface_port rx_reconfig rx_link_rate_8bits rx_link_rate_8bits Output 8
add_interface_port rx_reconfig rx_reconfig_req rx_reconfig_req Output 1
add_interface_port rx_reconfig rx_reconfig_ack rx_reconfig_ack Input 1
add_interface_port rx_reconfig rx_reconfig_busy rx_reconfig_busy Input 1

add_interface_port rx_analog_reconfig rx_analog_reconfig_req rx_analog_reconfig_req Output 1

# +-----------------------------------
# | ELABORATION CALLBACK
# +-----------------------------------

proc update_rx_mst_params {arg} {
    set rx_aux_gpu [get_parameter_value $arg]
    if { $rx_aux_gpu == 0 } {
        set_parameter_value RX_SUPPORT_MST 0
        set_parameter_value RX_MAX_NUM_OF_STREAMS 1
    }
}

proc update_rx_max_stream_params {arg} {
    set rx_support_mst [get_parameter_value $arg]
    set tx_video_im_enable [get_parameter_value TX_VIDEO_IM_ENABLE]
    set tx_support_mst [get_parameter_value TX_SUPPORT_MST]
    if { $rx_support_mst == 0 } {
		if { $tx_support_mst == 1 } {
			set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
		} elseif { $tx_video_im_enable == 1} {
			set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
		} else {
			set_parameter_value		SELECT_SUPPORTED_VARIANT 1
		}
        set_parameter_value     RX_MAX_NUM_OF_STREAMS 1
    } else {
        set_parameter_value     RX_MAX_NUM_OF_STREAMS 2   
        set_parameter_value     RX_MAX_LANE_COUNT 4
        #set_parameter_value     RX_SYMBOLS_PER_CLOCK 4
        #set_parameter_value     RX_SUPPORT_AUDIO 0    
        #set_parameter_value     RX_VIDEO_BPS 8
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
    }
}

proc update_tx_max_stream_params {arg} {
    set tx_support_mst [get_parameter_value $arg]
    set tx_video_im_enable [get_parameter_value TX_VIDEO_IM_ENABLE]
    set rx_support_mst [get_parameter_value RX_SUPPORT_MST]
    if { $tx_support_mst == 0 } {
		if { $rx_support_mst == 1 } {
			set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
		} elseif { $tx_video_im_enable == 1} {
			set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
		} else {
			set_parameter_value		SELECT_SUPPORTED_VARIANT 1
		}
        set_parameter_value     TX_MAX_NUM_OF_STREAMS 1
    } else {
        set_parameter_value     TX_MAX_NUM_OF_STREAMS 2   
        set_parameter_value     TX_MAX_LANE_COUNT 4
        #set_parameter_value     TX_SYMBOLS_PER_CLOCK 4
        #set_parameter_value     TX_SUPPORT_AUDIO 0    
        #set_parameter_value     TX_VIDEO_BPS 8
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
    }
}

proc update_tx_audio_params {arg} {
    set support_tx_ss [get_parameter_value $arg]
    if { $support_tx_ss == 0} {
        set_parameter_value TX_SUPPORT_AUDIO 0    
    }
}

proc update_rx_audio_params {arg} {
    set support_rx_ss [get_parameter_value $arg]
    if { $support_rx_ss == 0} {
        set_parameter_value RX_SUPPORT_AUDIO 0    
    }
}

proc update_tx_audio_params2 {arg} {
    set tx_symbols_per_clock [get_parameter_value $arg]
    if { $tx_symbols_per_clock == 2} {
        set_parameter_value TX_SUPPORT_AUDIO 0    
    }
}

proc update_rx_audio_params2 {arg} {
    set rx_symbols_per_clock [get_parameter_value $arg]
    if { $rx_symbols_per_clock == 2} {
        set_parameter_value RX_SUPPORT_AUDIO 0    
    }
}

proc update_design_example_variant1 {arg} {
    set tx_video_im_enable [get_parameter_value TX_VIDEO_IM_ENABLE]
    set tx_support_mst [get_parameter_value TX_SUPPORT_MST]
    set rx_support_mst [get_parameter_value $arg]
	if { $rx_support_mst == 1 } {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} elseif { $tx_support_mst == 1 } {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} elseif { $tx_video_im_enable == 1} {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} else {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 1
	}
}

proc update_design_example_variant2 {arg} {
    set tx_video_im_enable [get_parameter_value TX_VIDEO_IM_ENABLE]
    set tx_support_mst [get_parameter_value $arg]
    set rx_support_mst [get_parameter_value RX_SUPPORT_MST]
	if { $tx_support_mst == 1 } {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} elseif { $rx_support_mst == 1 } {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} elseif { $tx_video_im_enable == 1} {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} else {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 1
	}
}

proc update_design_example_variant3 {arg} {
    set tx_video_im_enable [get_parameter_value $arg]
    set tx_support_mst [get_parameter_value TX_SUPPORT_MST]
    set rx_support_mst [get_parameter_value RX_SUPPORT_MST]
	if { $rx_support_mst == 1 } {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} elseif { $tx_support_mst == 1 } {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} elseif { $tx_video_im_enable == 1} {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 0	
	} else {
		set_parameter_value		SELECT_SUPPORTED_VARIANT 1
	}
}

set_module_property ELABORATION_CALLBACK dp_elaboration_callback

proc dp_elaboration_callback {} {
	
  global include_mst
  global include_lpm

	set device_family [get_parameter_value device_family]
	set device_part [get_parameter_value DEVICE]
	set support_dp_tx [get_parameter_value TX_SUPPORT_DP]
	set support_dp_rx [get_parameter_value RX_SUPPORT_DP]
	set tx_aux_debug [get_parameter_value TX_AUX_DEBUG]
	set rx_aux_gpu [get_parameter_value RX_AUX_GPU]
	set tx_link_rate [get_parameter_value TX_MAX_LINK_RATE]
	set rx_link_rate [get_parameter_value RX_MAX_LINK_RATE]
	set rx_export_msa [get_parameter_value RX_EXPORT_MSA]
	#set tx_import_msa [get_parameter_value TX_IMPORT_MSA]
	# set tx_support_hdcp [get_parameter_value TX_SUPPORT_HDCP1]
	# set tx_support_hdcp [get_parameter_value TX_SUPPORT_HDCP2]
	# set rx_support_hdcp [get_parameter_value RX_SUPPORT_HDCP1]
	# set rx_support_hdcp [get_parameter_value RX_SUPPORT_HDCP2]
    # set tx_apb_control [get_parameter_value TX_APB_CONTROL]
    # set rx_apb_control [get_parameter_value RX_APB_CONTROL]
	set tx_lane_count [get_parameter_value TX_MAX_LANE_COUNT]
	set rx_lane_count [get_parameter_value RX_MAX_LANE_COUNT]
	set rx_symbols_per_clock [get_parameter_value RX_SYMBOLS_PER_CLOCK]
	set tx_symbols_per_clock [get_parameter_value TX_SYMBOLS_PER_CLOCK]
    set rx_num_of_streams [get_parameter_value RX_MAX_NUM_OF_STREAMS]
    set tx_num_of_streams [get_parameter_value TX_MAX_NUM_OF_STREAMS]
	set rx_scrambler_seed [get_parameter_value RX_SCRAMBLER_SEED]
	set tx_video_im_enable [get_parameter_value TX_VIDEO_IM_ENABLE]

        
	# Only Cyclone V does not support HBR2 support in this release
	if { ($device_family == "Cyclone V") } {
		set_parameter_property TX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps}
		set_parameter_property RX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps}
    } elseif {$device_family == "Arria 10"} {
		set_parameter_property TX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps 20:5.4Gbps}
		set_parameter_property RX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps 20:5.4Gbps}
	} else {
		set_parameter_property TX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps 20:5.4Gbps}
		set_parameter_property RX_MAX_LINK_RATE ALLOWED_RANGES {6:1.62Gbps 10:2.70Gbps 20:5.4Gbps}
	}

    if {$device_family == "Arria V"} {
        if {[expr {$tx_link_rate} == "20"] && [expr {$tx_symbols_per_clock} == "2"]} {
            send_message error "DisplayPort HBR2 Source only support in Quad Symbols Input Mode"
        } 
        if {[expr {$rx_link_rate} == "20"] && [expr {$rx_symbols_per_clock} == "2"]} {
            send_message error "DisplayPort HBR2 Sink only support in Quad Symbols Input Mode"
        } 
    }

	if { $include_mst } {
		# MST
		set rx_support_mst [get_parameter_value RX_SUPPORT_MST]
        if { $rx_support_mst } {
            set_parameter_property RX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {2:2 3:3 4:4}
            set_parameter_property RX_MAX_LANE_COUNT ALLOWED_RANGES {4:4}
            #set_parameter_property RX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8}
            if {$device_family == "Arria V"} {
                set_parameter_property RX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {4:Quad}  
                send_message warning "DisplayPort MST Sink only support in Quad Symbols Input Mode, Maximum BPC of 8 and Maximum Lane Count of 4"
            } else {
                set_parameter_property RX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}              
                send_message warning "DisplayPort MST Sink only support Maximum Lane Count of 4"
            }
        } else {
            set_parameter_property RX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {1:1}
            set_parameter_property RX_MAX_LANE_COUNT ALLOWED_RANGES {1:1 2:2 4:4}
            #set_parameter_property RX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8 10:10 12:12 16:16}
            set_parameter_property RX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}  
        }
		set tx_support_mst [get_parameter_value TX_SUPPORT_MST]
        if { $tx_support_mst } {
            set_parameter_property TX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {2:2 3:3 4:4}
            set_parameter_property TX_MAX_LANE_COUNT ALLOWED_RANGES {4:4}
            #set_parameter_property TX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8}
            if {$device_family == "Arria V"} {
                set_parameter_property TX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {4:Quad}  
                send_message warning "DisplayPort MST Source only support in Quad Symbols Input Mode, Maximum BPC of 8 and Maximum Lane Count of 4"
            } else {
                set_parameter_property TX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}  
                send_message warning "DisplayPort MST Source only support Maximum Lane Count of 4"
            }
        } else {
            set_parameter_property TX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {1:1}
            set_parameter_property TX_MAX_LANE_COUNT ALLOWED_RANGES {1:1 2:2 4:4}
            #set_parameter_property TX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8 10:10 12:12 16:16}
            set_parameter_property TX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}  
        }
	} else {
		set rx_support_mst 0
		set tx_support_mst 0
        set_parameter_property RX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {1:1}
        set_parameter_property TX_MAX_NUM_OF_STREAMS ALLOWED_RANGES {1:1}
        set_parameter_property RX_MAX_LANE_COUNT ALLOWED_RANGES {1:1 2:2 4:4}
        set_parameter_property TX_MAX_LANE_COUNT ALLOWED_RANGES {1:1 2:2 4:4}
        #set_parameter_property RX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8 10:10 12:12 16:16}
        #set_parameter_property TX_VIDEO_BPS ALLOWED_RANGES {6:6 8:8 10:10 12:12 16:16}
        set_parameter_property RX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}  
        set_parameter_property TX_SYMBOLS_PER_CLOCK ALLOWED_RANGES {2:Dual 4:Quad}  
	}
	
	if { $include_lpm } {
	    set rx_support_lpm [get_parameter_value RX_SUPPORT_LPM]
 	} else {
	    set rx_support_lpm 0
 	}

  #set_interface_property tx_msa_conduit ENABLED false 
  #set_interface_property tx1_msa_conduit ENABLED false 
  #set_interface_property tx2_msa_conduit ENABLED false 
  #set_interface_property tx3_msa_conduit ENABLED false 
  #if { $support_dp_tx && $tx_import_msa} { set_interface_property tx_msa_conduit ENABLED true }
  #if { $support_dp_tx && $tx_import_msa && $tx_support_mst && [expr {$tx_num_of_streams} > 1] } { set_interface_property tx1_msa_conduit ENABLED true }
  #if { $support_dp_tx && $tx_import_msa && $tx_support_mst && [expr {$tx_num_of_streams} > 2] } { set_interface_property tx2_msa_conduit ENABLED true }
  #if { $support_dp_tx && $tx_import_msa && $tx_support_mst && [expr {$tx_num_of_streams} > 3] } { set_interface_property tx3_msa_conduit ENABLED true }

  set_interface_property rx_msa_conduit ENABLED false
  set_interface_property rx1_msa_conduit ENABLED false
  set_interface_property rx2_msa_conduit ENABLED false
  set_interface_property rx3_msa_conduit ENABLED false
  if { $support_dp_rx && $rx_export_msa} {
    set_interface_property rx_msa_conduit ENABLED true
  }	
  if { $support_dp_rx && $rx_export_msa && $rx_support_mst && [expr {$rx_num_of_streams} > 1] } {
    set_interface_property rx1_msa_conduit ENABLED true
  }	
  if { $support_dp_rx && $rx_export_msa && $rx_support_mst && [expr {$rx_num_of_streams} > 2] } {
    set_interface_property rx2_msa_conduit ENABLED true
  }	
  if { $support_dp_rx && $rx_export_msa && $rx_support_mst && [expr {$rx_num_of_streams} > 3] } {
    set_interface_property rx3_msa_conduit ENABLED true
  }

	if { $support_dp_tx } {
		set_interface_property tx_mgmt ENABLED true 
		set_interface_property tx_mgmt_interrupt ENABLED true} else {
		set_interface_property tx_mgmt_interrupt ENABLED false
		set_interface_property tx_mgmt ENABLED false }

	if { $support_dp_rx & ~$rx_support_lpm} {
		set_parameter_property RX_AUX_DEBUG  ENABLED true
		set rx_aux_debug [get_parameter_value RX_AUX_DEBUG] } else {
		set_parameter_property RX_AUX_DEBUG  ENABLED false
		set rx_aux_debug 0
	}

	if { $support_dp_rx && ($rx_aux_debug || $rx_aux_gpu)} {              
		set_interface_property rx_mgmt ENABLED true 
		set_interface_property rx_mgmt_interrupt ENABLED true} else {
		set_interface_property rx_mgmt_interrupt ENABLED false
		set_interface_property rx_mgmt ENABLED false }

	if { $support_dp_rx || $support_dp_tx } {            
		set_interface_property clk ENABLED true 
		set_interface_property reset ENABLED true} else { 
		set_interface_property clk ENABLED false 
		set_interface_property reset ENABLED false}

	if { $support_dp_tx } {
		set_interface_property tx_aux ENABLED true} else {
		set_interface_property tx_aux ENABLED false }

	if { $support_dp_rx & ~$rx_support_lpm} {
		set_interface_property rx_aux ENABLED true} else {
		set_interface_property rx_aux ENABLED false }

	if { $support_dp_rx } {
		set_interface_property rx_params ENABLED true } else {
		set_interface_property rx_params ENABLED false }

	if { $rx_aux_debug && $support_dp_rx} {
           set_interface_property rx_aux_debug ENABLED true 
    } else {
           set_interface_property rx_aux_debug ENABLED false  }

	if { $tx_aux_debug && $support_dp_tx} {
           set_interface_property tx_aux_debug ENABLED true 
    } else {
           set_interface_property tx_aux_debug ENABLED false  }

  # Configure RX Image stream
	#set output_format [get_parameter_value RX_IMAGE_OUT_FORMAT]  
	set rx_bps [get_parameter_value RX_VIDEO_BPS]

	set rx_pixels_per_clock [get_parameter_value RX_PIXELS_PER_CLOCK]
	set rx_data_width [expr $rx_bps * 3 * $rx_pixels_per_clock ]
	set rx_valid_data_width [expr $rx_pixels_per_clock ]

	# set_interface_property rx_video_out_st dataBitsPerSymbol [expr $rx_bps * $rx_pixels_per_clock ] 
	# add_interface_port rx_video_out_st rx_vid_st_data data Output $rx_data_width
	add_interface_port rx_video_out rx_vid_data rx_vid_data Output $rx_data_width
	add_interface_port rx_video_out rx_vid_valid rx_vid_valid Output $rx_valid_data_width

	# set_interface_property rx1_video_out_st dataBitsPerSymbol [expr $rx_bps * $rx_pixels_per_clock ] 
	# add_interface_port rx1_video_out_st rx1_vid_st_data data Output $rx_data_width
	add_interface_port rx1_video_out rx1_vid_data rx1_vid_data Output $rx_data_width
	add_interface_port rx1_video_out rx1_vid_valid rx1_vid_valid Output $rx_valid_data_width

	# set_interface_property rx2_video_out_st dataBitsPerSymbol [expr $rx_bps * $rx_pixels_per_clock ] 
	# add_interface_port rx2_video_out_st rx2_vid_st_data data Output $rx_data_width
	add_interface_port rx2_video_out rx2_vid_data rx2_vid_data Output $rx_data_width
	add_interface_port rx2_video_out rx2_vid_valid rx2_vid_valid Output $rx_valid_data_width

	# set_interface_property rx3_video_out_st dataBitsPerSymbol [expr $rx_bps * $rx_pixels_per_clock ] 
	# add_interface_port rx3_video_out_st rx3_vid_st_data data Output $rx_data_width
	add_interface_port rx3_video_out rx3_vid_data rx3_vid_data Output $rx_data_width
	add_interface_port rx3_video_out rx3_vid_valid rx3_vid_valid Output $rx_valid_data_width

    set_port_property rx_vid_valid VHDL_TYPE STD_LOGIC_VECTOR
    set_port_property rx1_vid_valid VHDL_TYPE STD_LOGIC_VECTOR
    set_port_property rx2_vid_valid VHDL_TYPE STD_LOGIC_VECTOR
    set_port_property rx3_vid_valid VHDL_TYPE STD_LOGIC_VECTOR  

  set_interface_property rx_stream ENABLED false
  set_interface_property rx1_stream ENABLED false
  set_interface_property rx2_stream ENABLED false
  set_interface_property rx3_stream ENABLED false
  if { $support_dp_rx } { set_interface_property rx_stream ENABLED true}   
  if { $support_dp_rx && $rx_support_mst && $rx_aux_gpu && [expr {$rx_num_of_streams} > 1] } { set_interface_property rx1_stream ENABLED true }
  if { $support_dp_rx && $rx_support_mst && $rx_aux_gpu && [expr {$rx_num_of_streams} > 2] } { set_interface_property rx2_stream ENABLED true }
  if { $support_dp_rx && $rx_support_mst && $rx_aux_gpu && [expr {$rx_num_of_streams} > 3] } { set_interface_property rx3_stream ENABLED true }

	set_interface_property rx_video_out ENABLED false
	# set_interface_property rx_video_out_st ENABLED false 
	set_interface_property rx1_video_out ENABLED false
	# set_interface_property rx1_video_out_st ENABLED false  
	set_interface_property rx2_video_out ENABLED false
	# set_interface_property rx2_video_out_st ENABLED false  
	set_interface_property rx3_video_out ENABLED false
	# set_interface_property rx3_video_out_st ENABLED false 
	set_interface_property rx_vid_clk ENABLED false
	# set_interface_property rx_vid_st_reset ENABLED false
	set_interface_property rx1_vid_clk ENABLED false
	# set_interface_property rx1_vid_st_reset ENABLED false
	set_interface_property rx2_vid_clk ENABLED false
	# set_interface_property rx2_vid_st_reset ENABLED false
	set_interface_property rx3_vid_clk ENABLED false
	# set_interface_property rx3_vid_st_reset ENABLED false
	if { $support_dp_rx } {
		#if {$output_format} {
			set_interface_property rx_video_out ENABLED true
			set_interface_property rx_vid_clk ENABLED true
		# } else {
			# set_interface_property rx_video_out_st ENABLED true 
			# set_interface_property rx_vid_clk ENABLED true
			# set_interface_property rx_vid_st_reset ENABLED true
		#}
	}

	if { $support_dp_rx && $rx_support_mst && $rx_aux_gpu && [expr {$rx_num_of_streams} > 1] } {
		#if {$output_format} {
			set_interface_property rx1_video_out ENABLED true
			set_interface_property rx1_vid_clk ENABLED true
		# } else {
			# set_interface_property rx1_video_out_st ENABLED true
			# set_interface_property rx1_vid_clk ENABLED true
			# set_interface_property rx1_vid_st_reset ENABLED true
		#} 
	}   

	if { $support_dp_rx && $rx_support_mst && $rx_aux_gpu && [expr {$rx_num_of_streams} > 2] } {
		#if {$output_format} {
			set_interface_property rx2_video_out ENABLED true
			set_interface_property rx2_vid_clk ENABLED true
		# } else {
			# set_interface_property rx2_video_out_st ENABLED true
			# set_interface_property rx2_vid_clk ENABLED true
			# set_interface_property rx2_vid_st_reset ENABLED true
		#} 
	}   

	if { $support_dp_rx && $rx_support_mst && $rx_aux_gpu && [expr {$rx_num_of_streams} > 3] } {
		#if {$output_format} {
			set_interface_property rx3_video_out ENABLED true
			set_interface_property rx3_vid_clk ENABLED true
		# } else {
			# set_interface_property rx3_video_out_st ENABLED true 
			# set_interface_property rx3_vid_clk ENABLED true
			# set_interface_property rx3_vid_st_reset ENABLED true
		#} 
	} 

	# Configure TX Image input data width            
	set tx_bps [get_parameter_value TX_VIDEO_BPS]
	set tx_pixels_per_clock [get_parameter_value TX_PIXELS_PER_CLOCK]
	set tx_data_width [expr $tx_bps * 3 * $tx_pixels_per_clock ]

	add_interface_port tx_video_in tx_vid_data tx_vid_data Input $tx_data_width
	add_interface_port tx_video_in tx_vid_v_sync tx_vid_v_sync Input $tx_pixels_per_clock
	add_interface_port tx_video_in tx_vid_h_sync tx_vid_h_sync Input $tx_pixels_per_clock
	add_interface_port tx_video_in tx_vid_de tx_vid_de Input $tx_pixels_per_clock

	add_interface_port tx1_video_in tx1_vid_data tx1_vid_data Input $tx_data_width
	add_interface_port tx1_video_in tx1_vid_v_sync tx1_vid_v_sync Input $tx_pixels_per_clock
	add_interface_port tx1_video_in tx1_vid_h_sync tx1_vid_h_sync Input $tx_pixels_per_clock
	add_interface_port tx1_video_in tx1_vid_de tx1_vid_de Input $tx_pixels_per_clock

	add_interface_port tx2_video_in tx2_vid_data tx2_vid_data Input $tx_data_width
	add_interface_port tx2_video_in tx2_vid_v_sync tx2_vid_v_sync Input $tx_pixels_per_clock
	add_interface_port tx2_video_in tx2_vid_h_sync tx2_vid_h_sync Input $tx_pixels_per_clock
	add_interface_port tx2_video_in tx2_vid_de tx2_vid_de Input $tx_pixels_per_clock

	add_interface_port tx3_video_in tx3_vid_data tx3_vid_data Input $tx_data_width
	add_interface_port tx3_video_in tx3_vid_v_sync tx3_vid_v_sync Input $tx_pixels_per_clock
	add_interface_port tx3_video_in tx3_vid_h_sync tx3_vid_h_sync Input $tx_pixels_per_clock
	add_interface_port tx3_video_in tx3_vid_de tx3_vid_de Input $tx_pixels_per_clock

    set_port_property tx_vid_v_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx_vid_h_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx_vid_de VHDL_TYPE STD_LOGIC_VECTOR
    set_port_property tx1_vid_v_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx1_vid_h_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx1_vid_de VHDL_TYPE STD_LOGIC_VECTOR
    set_port_property tx2_vid_v_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx2_vid_h_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx2_vid_de VHDL_TYPE STD_LOGIC_VECTOR
    set_port_property tx3_vid_v_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx3_vid_h_sync VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx3_vid_de VHDL_TYPE STD_LOGIC_VECTOR
	
	# Tx Video Image Interface
	add_interface_port tx_video_in_im tx_im_data tx_im_data Input $tx_data_width
	add_interface_port tx_video_in_im tx_im_valid tx_im_valid Input $tx_pixels_per_clock
	add_interface_port tx1_video_in_im tx1_im_data tx1_im_data Input $tx_data_width
	add_interface_port tx1_video_in_im tx1_im_valid tx1_im_valid Input $tx_pixels_per_clock
	add_interface_port tx2_video_in_im tx2_im_data tx2_im_data Input $tx_data_width
	add_interface_port tx2_video_in_im tx2_im_valid tx2_im_valid Input $tx_pixels_per_clock
	add_interface_port tx3_video_in_im tx3_im_data tx3_im_data Input $tx_data_width
	add_interface_port tx3_video_in_im tx3_im_valid tx3_im_valid Input $tx_pixels_per_clock

	set_port_property tx_im_valid VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx1_im_valid VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx2_im_valid VHDL_TYPE STD_LOGIC_VECTOR
	set_port_property tx3_im_valid VHDL_TYPE STD_LOGIC_VECTOR

  set_interface_property tx_video_in ENABLED false
  set_interface_property tx1_video_in ENABLED false
  set_interface_property tx2_video_in ENABLED false
  set_interface_property tx3_video_in ENABLED false
  set_interface_property tx_vid_clk ENABLED false
  set_interface_property tx1_vid_clk ENABLED false
  set_interface_property tx2_vid_clk ENABLED false
  set_interface_property tx3_vid_clk ENABLED false
  set_interface_property tx_video_in_im ENABLED false
  set_interface_property tx1_video_in_im ENABLED false
  set_interface_property tx2_video_in_im ENABLED false
  set_interface_property tx3_video_in_im ENABLED false
  set_interface_property tx_im_clk ENABLED false
  set_interface_property tx1_im_clk ENABLED false
  set_interface_property tx2_im_clk ENABLED false
  set_interface_property tx3_im_clk ENABLED false
 
  if { $support_dp_tx && $tx_video_im_enable} { 
	set_interface_property tx_video_in_im ENABLED true
	set_interface_property tx_im_clk  ENABLED true
	if { $tx_support_mst && [expr {$tx_num_of_streams} > 1] } { 
		set_interface_property tx1_video_in_im ENABLED true
		set_interface_property tx1_im_clk ENABLED true
	}
	if { $tx_support_mst && [expr {$tx_num_of_streams} > 2] } { 
		set_interface_property tx2_video_in_im ENABLED true
		set_interface_property tx2_im_clk ENABLED true
	}
	if { $tx_support_mst && [expr {$tx_num_of_streams} > 3] } { 
		set_interface_property tx3_video_in_im ENABLED true
		set_interface_property tx3_im_clk ENABLED true
	}
  } else {
	if { $support_dp_tx } { 
		set_interface_property tx_video_in ENABLED true
		set_interface_property tx_vid_clk  ENABLED true
		if { $tx_support_mst && [expr {$tx_num_of_streams} > 1] } { 
			set_interface_property tx1_video_in ENABLED true
			set_interface_property tx1_vid_clk ENABLED true
		}
		if { $tx_support_mst && [expr {$tx_num_of_streams} > 2] } { 
			set_interface_property tx2_video_in ENABLED true
			set_interface_property tx2_vid_clk ENABLED true
		}
		if { $tx_support_mst && [expr {$tx_num_of_streams} > 3] } { 
			set_interface_property tx3_video_in ENABLED true
			set_interface_property tx3_vid_clk ENABLED true
		}
	}
  }
	add_interface_port tx_analog_reconfig tx_vod tx_vod output [ expr ($tx_lane_count * 2)]
	add_interface_port tx_analog_reconfig tx_emp tx_emp output [ expr ($tx_lane_count * 2)]
	add_interface_port rx_analog_reconfig rx_vod rx_vod output [ expr ($rx_lane_count * 2)]
	add_interface_port rx_analog_reconfig rx_emp rx_emp output [ expr ($rx_lane_count * 2)]
 
	set tx_support_analog_reconfig [get_parameter_value TX_SUPPORT_ANALOG_RECONFIG]

        set width_conduit_tx_parallel_data [expr ($tx_lane_count * $tx_symbols_per_clock * 10)]
        add_interface_port tx_xcvr_interface tx_parallel_data tx_parallel_data output $width_conduit_tx_parallel_data
        add_interface_port tx_xcvr_interface tx_pll_powerdown tx_pll_powerdown output 1
        add_interface_port tx_xcvr_interface tx_analogreset tx_analogreset output $tx_lane_count
        add_interface_port tx_xcvr_interface tx_digitalreset tx_digitalreset output $tx_lane_count 
        add_interface_port tx_xcvr_interface tx_cal_busy tx_cal_busy input $tx_lane_count
        add_interface_port tx_xcvr_interface tx_std_clkout tx_std_clkout input $tx_lane_count
        add_interface_port tx_xcvr_interface tx_pll_locked tx_pll_locked input 1

        set_port_property tx_analogreset VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property tx_digitalreset VHDL_TYPE STD_LOGIC_VECTOR 
        set_port_property tx_cal_busy VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property tx_std_clkout VHDL_TYPE STD_LOGIC_VECTOR

        set width_conduit_rx_parallel_data [expr ($rx_lane_count * $rx_symbols_per_clock * 10)]
        add_interface_port rx_xcvr_interface rx_parallel_data rx_parallel_data input $width_conduit_rx_parallel_data
        add_interface_port rx_xcvr_interface rx_std_clkout rx_std_clkout input $rx_lane_count
        add_interface_port rx_xcvr_interface rx_is_lockedtoref rx_is_lockedtoref input $rx_lane_count
        add_interface_port rx_xcvr_interface rx_is_lockedtodata rx_is_lockedtodata input $rx_lane_count
        add_interface_port rx_xcvr_interface rx_restart rx_restart output 1
        add_interface_port rx_xcvr_interface rx_bitslip rx_bitslip output $rx_lane_count
        add_interface_port rx_xcvr_interface rx_cal_busy rx_cal_busy input $rx_lane_count
        add_interface_port rx_xcvr_interface rx_analogreset rx_analogreset output $rx_lane_count
        add_interface_port rx_xcvr_interface rx_digitalreset rx_digitalreset output $rx_lane_count
        add_interface_port rx_xcvr_interface rx_set_locktoref rx_set_locktoref output $rx_lane_count
        add_interface_port rx_xcvr_interface rx_set_locktodata rx_set_locktodata output $rx_lane_count

        set_port_property rx_std_clkout VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_is_lockedtoref VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_is_lockedtodata VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_bitslip VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_cal_busy VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_analogreset VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_digitalreset VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_set_locktoref VHDL_TYPE STD_LOGIC_VECTOR
        set_port_property rx_set_locktodata VHDL_TYPE STD_LOGIC_VECTOR

        
	add_interface_port rx_stream rx_stream_data rx_stream_data Output [expr (4*8*$rx_symbols_per_clock)]
	add_interface_port rx_stream rx_stream_ctrl rx_stream_ctrl Output [expr (4*1*$rx_symbols_per_clock)]
	add_interface_port rx1_stream rx1_stream_data rx1_stream_data Output [expr (4*8*$rx_symbols_per_clock)]
	add_interface_port rx1_stream rx1_stream_ctrl rx1_stream_ctrl Output [expr (4*1*$rx_symbols_per_clock)]
	add_interface_port rx2_stream rx2_stream_data rx2_stream_data Output [expr (4*8*$rx_symbols_per_clock)]
	add_interface_port rx2_stream rx2_stream_ctrl rx2_stream_ctrl Output [expr (4*1*$rx_symbols_per_clock)]
	add_interface_port rx3_stream rx3_stream_data rx3_stream_data Output [expr (4*8*$rx_symbols_per_clock)]
	add_interface_port rx3_stream rx3_stream_ctrl rx3_stream_ctrl Output [expr (4*1*$rx_symbols_per_clock)]

        if {$support_dp_rx} {
	        set_interface_property rx_xcvr_interface ENABLED true
	} else {
	        set_interface_property rx_xcvr_interface ENABLED false
	}

        if {$support_dp_tx} {
	        set_interface_property tx_xcvr_interface ENABLED true
	} else {
	        set_interface_property tx_xcvr_interface ENABLED false
	}

	if { $support_dp_tx } {
		set_interface_property tx_reconfig ENABLED true
	} else {
		set_interface_property tx_reconfig ENABLED false
	}

	if { $support_dp_tx && $tx_support_analog_reconfig } {
		set_interface_property tx_analog_reconfig ENABLED true
	} else {
		set_interface_property tx_analog_reconfig ENABLED false
	}
   
	if { $support_dp_rx} {
		set_interface_property rx_reconfig ENABLED true
	} else {
		set_interface_property rx_reconfig ENABLED false
	}

	set support_rx_ss [get_parameter_value RX_SUPPORT_SS]

	set_interface_property rx_ss ENABLED false  
	set_interface_property rx1_ss ENABLED false  
	set_interface_property rx2_ss ENABLED false  
	set_interface_property rx3_ss ENABLED false
	set_interface_property rx_ss_clk ENABLED false
	if { $support_dp_rx && $support_rx_ss } { 
		set_interface_property rx_ss ENABLED true
		set_interface_property rx_ss_clk ENABLED true 
	} 
	if { $support_dp_rx && $support_rx_ss && $rx_support_mst && [expr {$rx_num_of_streams} > 1] } {
		set_interface_property rx1_ss ENABLED true 
	}
	if { $support_dp_rx && $support_rx_ss && $rx_support_mst && [expr {$rx_num_of_streams} > 2] } {
		set_interface_property rx2_ss ENABLED true 
	}
	if { $support_dp_rx && $support_rx_ss && $rx_support_mst && [expr {$rx_num_of_streams} > 3] } {
		set_interface_property rx3_ss ENABLED true 
	}

	set support_tx_ss [get_parameter_value TX_SUPPORT_SS]

  set_interface_property tx_ss ENABLED false  
  set_interface_property tx1_ss ENABLED false  
  set_interface_property tx2_ss ENABLED false  
  set_interface_property tx3_ss ENABLED false  
  set_interface_property tx_ss_clk ENABLED false

  if { $support_dp_tx && $support_tx_ss } { 
    set_interface_property tx_ss ENABLED true 
    set_interface_property tx_ss_clk ENABLED true} 
  if { $support_dp_tx && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 1] } { set_interface_property tx1_ss ENABLED true }
  if { $support_dp_tx && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 2] } { set_interface_property tx2_ss ENABLED true }
  if { $support_dp_tx && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 3] } { set_interface_property tx3_ss ENABLED true }

  set tx_support_gtc [get_parameter_value TX_SUPPORT_GTC]	
   set_interface_property tx_gtc ENABLED false
   if { $support_dp_tx & $tx_support_gtc } {
     set_interface_property tx_gtc ENABLED true
   }

	if { $support_dp_rx & ~$rx_aux_gpu} {
		set_interface_property rx_edid ENABLED true } else {
		set_interface_property rx_edid ENABLED false
	}

  if { $include_mst } {
    # MST
    if { $support_dp_rx && $rx_aux_gpu } {
      set_parameter_property RX_SUPPORT_MST ENABLED true } else {
      set_parameter_property RX_SUPPORT_MST ENABLED false
    }
    if { $support_dp_rx & $rx_support_mst } {
      set_parameter_property RX_MAX_NUM_OF_STREAMS ENABLED true } else {
      set_parameter_property RX_MAX_NUM_OF_STREAMS ENABLED false
    }
    if { $support_dp_tx } {
      set_parameter_property TX_SUPPORT_MST ENABLED true } else {
      set_parameter_property TX_SUPPORT_MST ENABLED false
    }
    if { $support_dp_tx & $tx_support_mst } {
      set_parameter_property TX_MAX_NUM_OF_STREAMS ENABLED true } else {
      set_parameter_property TX_MAX_NUM_OF_STREAMS ENABLED false
    }
  }  

	 # if { $include_lpm & $support_dp_rx & $rx_aux_gpu } {
	    # set_parameter_property RX_SUPPORT_LPM ENABLED true } else {
	    # set_parameter_property RX_SUPPORT_LPM ENABLED false
	 # }
	
 	if { $support_dp_rx & $rx_aux_gpu & ~$rx_support_lpm} {
	    set_parameter_property RX_SUPPORT_I2CMASTER ENABLED true
	    set rx_support_i2cmaster [get_parameter_value RX_SUPPORT_I2CMASTER] } else {
	    set_parameter_property RX_SUPPORT_I2CMASTER ENABLED false
	    set rx_support_i2cmaster 0
 	}

 	# if { $support_dp_rx & ~$rx_support_lpm} {
	    # set_parameter_property RX_SUPPORT_HDCP1 ENABLED true
	    # set rx_support_hdcp [get_parameter_value RX_SUPPORT_HDCP1] } else {
	    # set_parameter_property RX_SUPPORT_HDCP1 ENABLED false
	    # set_parameter_property RX_SUPPORT_HDCP2 ENABLED true
	    # set rx_support_hdcp [get_parameter_value RX_SUPPORT_HDCP2] } else {
	    # set_parameter_property RX_SUPPORT_HDCP2 ENABLED false
 	# }

  # if { $rx_support_lpm } {
    # set_interface_property lpm_remregs ENABLED true
    # set_interface_property lpm_control ENABLED true } else {
    # set_interface_property lpm_remregs ENABLED false
    # set_interface_property lpm_control ENABLED false 
  # }

 	#set_port_property rx_i2c0_scl WIDTH_EXPR 1
 	#set_port_property rx_i2c0_sda WIDTH_EXPR 1
 	#set_port_property rx_i2c1_scl WIDTH_EXPR 1
 	#set_port_property rx_i2c1_sda WIDTH_EXPR 1
 	#if { $rx_support_i2cmaster } {
	#    set_port_property rx_i2c0_scl DIRECTION bidir
	#    set_port_property rx_i2c0_sda DIRECTION bidir
	#    set_port_property rx_i2c1_scl DIRECTION bidir
	#    set_port_property rx_i2c1_sda DIRECTION bidir
	#    set_interface_property rx_i2c ENABLED true
	#    set_parameter_property RX_I2C_SCL_KHZ ENABLED true } else {
	#    set_port_property rx_i2c0_scl DIRECTION output
	#    set_port_property rx_i2c0_sda DIRECTION output
	#    set_port_property rx_i2c1_scl DIRECTION output
	#    set_port_property rx_i2c1_sda DIRECTION output
	#    set_interface_property rx_i2c ENABLED false
	#    set_parameter_property RX_I2C_SCL_KHZ ENABLED false
 	#}

	set tx_support_audio [get_parameter_value TX_SUPPORT_AUDIO]
	set tx_audio_chans   [get_parameter_value TX_AUDIO_CHANS]
    add_interface_port tx_audio tx_audio_lpcm_data tx_audio_lpcm_data Input [ expr 32*$tx_audio_chans ]
    add_interface_port tx1_audio tx1_audio_lpcm_data tx1_audio_lpcm_data Input [ expr 32*$tx_audio_chans ]
    add_interface_port tx2_audio tx2_audio_lpcm_data tx2_audio_lpcm_data Input [ expr 32*$tx_audio_chans ]
    add_interface_port tx3_audio tx3_audio_lpcm_data tx3_audio_lpcm_data Input [ expr 32*$tx_audio_chans ] 

  set_interface_property tx_audio ENABLED false
  set_interface_property tx_audio_clk ENABLED false
  set_interface_property tx1_audio ENABLED false
  set_interface_property tx1_audio_clk ENABLED false
  set_interface_property tx2_audio ENABLED false
  set_interface_property tx2_audio_clk ENABLED false
  set_interface_property tx3_audio ENABLED false
  set_interface_property tx3_audio_clk ENABLED false
  
  if { $support_dp_tx && $tx_support_audio && $support_tx_ss } {
    set_interface_property tx_audio ENABLED true
    set_interface_property tx_audio_clk ENABLED true
  }
  if { $support_dp_tx && $tx_support_audio && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 1] } { set_interface_property tx1_audio ENABLED true }
  if { $support_dp_tx && $tx_support_audio && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 2] } { set_interface_property tx2_audio ENABLED true }
  if { $support_dp_tx && $tx_support_audio && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 3] } { set_interface_property tx3_audio ENABLED true }
  if { $support_dp_tx && $tx_support_audio && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 1] } { set_interface_property tx1_audio_clk ENABLED true }
  if { $support_dp_tx && $tx_support_audio && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 2] } { set_interface_property tx2_audio_clk ENABLED true }
  if { $support_dp_tx && $tx_support_audio && $support_tx_ss && $tx_support_mst && [expr {$tx_num_of_streams} > 3] } { set_interface_property tx3_audio_clk ENABLED true }

	set rx_support_audio [get_parameter_value RX_SUPPORT_AUDIO]	
	set rx_audio_chans   [get_parameter_value RX_AUDIO_CHANS]
    add_interface_port  rx_audio rx_audio_lpcm_data rx_audio_lpcm_data Output [ expr 32*$rx_audio_chans ] 
    add_interface_port  rx1_audio rx1_audio_lpcm_data rx1_audio_lpcm_data Output [ expr 32*$rx_audio_chans ] 
    add_interface_port  rx2_audio rx2_audio_lpcm_data rx2_audio_lpcm_data Output [ expr 32*$rx_audio_chans ] 
    add_interface_port  rx3_audio rx3_audio_lpcm_data rx3_audio_lpcm_data Output [ expr 32*$rx_audio_chans ] 

  set_interface_property rx_audio ENABLED false
  set_interface_property rx1_audio ENABLED false
  set_interface_property rx2_audio ENABLED false
  set_interface_property rx3_audio ENABLED false
  if { $rx_support_audio && $support_rx_ss && $support_dp_rx} {
    set_interface_property rx_audio ENABLED true
  }
  if { $rx_support_audio && $support_rx_ss && $support_dp_rx && $rx_support_mst && [expr {$rx_num_of_streams} > 1] } { set_interface_property rx1_audio ENABLED true }
  if { $rx_support_audio && $support_rx_ss && $support_dp_rx && $rx_support_mst && [expr {$rx_num_of_streams} > 2] } { set_interface_property rx2_audio ENABLED true }
  if { $rx_support_audio && $support_rx_ss && $support_dp_rx && $rx_support_mst && [expr {$rx_num_of_streams} > 3] } { set_interface_property rx3_audio ENABLED true }

  if { $support_dp_rx & $rx_aux_gpu & ~$rx_support_lpm} {
    set_parameter_property RX_SUPPORT_GTC ENABLED false
    set rx_support_gtc [get_parameter_value RX_SUPPORT_GTC] } else {
    set_parameter_property RX_SUPPORT_GTC ENABLED false
    set rx_support_gtc 0	
  }
   if { $rx_support_gtc } {
     set_interface_property rx_gtc ENABLED true } else {
     set_interface_property rx_gtc ENABLED false
   }

	# HDCP
	# set width_conduit_to_hdcp_enc  [ expr ($tx_symbols_per_clock*$tx_lane_count*9+44+5+2)]
	# set width_conduit_from_hdcp_enc [ expr ($tx_symbols_per_clock*$tx_lane_count*9+32+1+1)]
	# if { $tx_support_hdcp && $support_dp_tx } {
		# set_interface_property tx_hdcp_enc_conduit ENABLED true
		# add_interface_port tx_hdcp_enc_conduit to_hdcp_enc to_hdcp_enc Output $width_conduit_to_hdcp_enc
		# add_interface_port tx_hdcp_enc_conduit from_hdcp_enc from_hdcp_enc Input  $width_conduit_from_hdcp_enc
	# } else {
		# set_interface_property tx_hdcp_enc_conduit ENABLED false
	# }  

	# set width_conduit_to_hdcp_dec  [ expr ($rx_symbols_per_clock*$rx_lane_count*9+30+44+2+5+2)]
	# set width_conduit_from_hdcp_dec [ expr ($rx_symbols_per_clock*$rx_lane_count*9+8+32+1+1)]
	# if { $rx_support_hdcp && $support_dp_rx } {
		# set_interface_property rx_hdcp_dec_conduit ENABLED true
		# add_interface_port rx_hdcp_dec_conduit to_hdcp_dec to_hdcp_dec Output $width_conduit_to_hdcp_dec
		# add_interface_port rx_hdcp_dec_conduit from_hdcp_dec from_hdcp_dec Input  $width_conduit_from_hdcp_dec
	# } else {
		# set_interface_property rx_hdcp_dec_conduit ENABLED false
	# }
    
  # Enable appropriately
	if { $support_dp_tx } {
		set_parameter_property TX_SUPPORT_SS		ENABLED true
		set_parameter_property TX_VIDEO_BPS			ENABLED true
		set_parameter_property TX_MAX_LINK_RATE		ENABLED true
		set_parameter_property TX_MAX_LANE_COUNT	ENABLED true
		set_parameter_property TX_AUX_DEBUG			ENABLED true
		#set_parameter_property TX_POLINV			ENABLED true
		set_parameter_property TX_SUPPORT_ANALOG_RECONFIG ENABLED true
		set_parameter_property TX_SCRAMBLER_SEED	ENABLED true
		set_parameter_property TX_PIXELS_PER_CLOCK  ENABLED true
		#set_parameter_property TX_IMPORT_MSA		ENABLED true
		#set_parameter_property TX_INTERLACED_VID	ENABLED true
		#set_parameter_property TX_SUPPORT_18BPP		ENABLED true
		#set_parameter_property TX_SUPPORT_24BPP		ENABLED true
		#set_parameter_property TX_SUPPORT_30BPP		ENABLED true
		#set_parameter_property TX_SUPPORT_36BPP		ENABLED true
		#set_parameter_property TX_SUPPORT_48BPP		ENABLED true
		#set_parameter_property TX_SUPPORT_YCBCR422_16BPP ENABLED true
		#set_parameter_property TX_SUPPORT_YCBCR422_20BPP ENABLED true
		#set_parameter_property TX_SUPPORT_YCBCR422_24BPP ENABLED true
		#set_parameter_property TX_SUPPORT_YCBCR422_32BPP ENABLED true
		set_parameter_property TX_SUPPORT_AUTOMATED_TEST ENABLED true 
		set_parameter_property TX_SYMBOLS_PER_CLOCK ENABLED true
		# set_parameter_property TX_SUPPORT_HDCP1 ENABLED true 
		# set_parameter_property TX_SUPPORT_HDCP2 ENABLED true 
	} else {
		set_parameter_property TX_SUPPORT_SS		ENABLED false
		set_parameter_property TX_VIDEO_BPS			ENABLED false
		set_parameter_property TX_MAX_LINK_RATE		ENABLED false
		set_parameter_property TX_MAX_LANE_COUNT	ENABLED false
		set_parameter_property TX_AUX_DEBUG			ENABLED false
		#set_parameter_property TX_POLINV			ENABLED false
		set_parameter_property TX_SUPPORT_ANALOG_RECONFIG ENABLED false
		set_parameter_property TX_SCRAMBLER_SEED	ENABLED false
		set_parameter_property TX_PIXELS_PER_CLOCK  ENABLED false
		#set_parameter_property TX_IMPORT_MSA		ENABLED false
		#set_parameter_property TX_INTERLACED_VID	ENABLED false
		#set_parameter_property TX_SUPPORT_18BPP		ENABLED false
		#set_parameter_property TX_SUPPORT_24BPP		ENABLED false
		#set_parameter_property TX_SUPPORT_30BPP		ENABLED false
		#set_parameter_property TX_SUPPORT_36BPP		ENABLED false
		#set_parameter_property TX_SUPPORT_48BPP		ENABLED false
		#set_parameter_property TX_SUPPORT_YCBCR422_16BPP ENABLED false
		#set_parameter_property TX_SUPPORT_YCBCR422_20BPP ENABLED false
		#set_parameter_property TX_SUPPORT_YCBCR422_24BPP ENABLED false
		#set_parameter_property TX_SUPPORT_YCBCR422_32BPP ENABLED false
		set_parameter_property TX_SUPPORT_AUTOMATED_TEST ENABLED false 
		set_parameter_property TX_SYMBOLS_PER_CLOCK ENABLED false
		# set_parameter_property TX_SUPPORT_HDCP1 ENABLED false 
		# set_parameter_property TX_SUPPORT_HDCP2 ENABLED false 
	} 

	if { $support_dp_rx } {
		#set_parameter_property RX_IMAGE_OUT_FORMAT	ENABLED true
        #if { $output_format } {
          set_parameter_property RX_PIXELS_PER_CLOCK ENABLED true
	#} else {
    #      set_parameter_property RX_PIXELS_PER_CLOCK ENABLED false
    #    }
		set_parameter_property RX_EXPORT_MSA		ENABLED true
		set_parameter_property RX_VIDEO_BPS			ENABLED true
		set_parameter_property RX_SUPPORT_SS		ENABLED true
		set_parameter_property RX_MAX_LINK_RATE		ENABLED true
		set_parameter_property RX_MAX_LANE_COUNT	ENABLED true
		#set_parameter_property RX_POLINV			ENABLED true
		set_parameter_property RX_SCRAMBLER_SEED	ENABLED true
		set_parameter_property RX_SUPPORT_AUTOMATED_TEST ENABLED true
		#set_parameter_property RX_SUPPORT_18BPP		ENABLED true
		#set_parameter_property RX_SUPPORT_24BPP		ENABLED true
		#set_parameter_property RX_SUPPORT_30BPP		ENABLED true
		#set_parameter_property RX_SUPPORT_36BPP		ENABLED true
		#set_parameter_property RX_SUPPORT_48BPP		ENABLED true
		#set_parameter_property RX_SUPPORT_YCBCR422_16BPP ENABLED true
		#set_parameter_property RX_SUPPORT_YCBCR422_20BPP ENABLED true
		#set_parameter_property RX_SUPPORT_YCBCR422_24BPP ENABLED true
		#set_parameter_property RX_SUPPORT_YCBCR422_32BPP ENABLED true
		set_parameter_property RX_IEEE_OUI			ENABLED true
		set_parameter_property RX_AUX_GPU			ENABLED true 
		set_parameter_property RX_SYMBOLS_PER_CLOCK ENABLED true
	} else {
		#set_parameter_property RX_IMAGE_OUT_FORMAT	ENABLED false
		set_parameter_property RX_PIXELS_PER_CLOCK  ENABLED false
		set_parameter_property RX_EXPORT_MSA		ENABLED false
		set_parameter_property RX_VIDEO_BPS			ENABLED false
		set_parameter_property RX_SUPPORT_SS		ENABLED false
		set_parameter_property RX_MAX_LINK_RATE		ENABLED false
		set_parameter_property RX_MAX_LANE_COUNT	ENABLED false
		#set_parameter_property RX_POLINV			ENABLED false
		set_parameter_property RX_SCRAMBLER_SEED	ENABLED false
		set_parameter_property RX_SUPPORT_AUTOMATED_TEST ENABLED false
		#set_parameter_property RX_SUPPORT_18BPP		ENABLED false
		#set_parameter_property RX_SUPPORT_24BPP		ENABLED false
		#set_parameter_property RX_SUPPORT_30BPP		ENABLED false
		#set_parameter_property RX_SUPPORT_36BPP		ENABLED false
		#set_parameter_property RX_SUPPORT_48BPP		ENABLED false
		#set_parameter_property RX_SUPPORT_YCBCR422_16BPP ENABLED false
		#set_parameter_property RX_SUPPORT_YCBCR422_20BPP ENABLED false
		#set_parameter_property RX_SUPPORT_YCBCR422_24BPP ENABLED false
		#set_parameter_property RX_SUPPORT_YCBCR422_32BPP ENABLED false
		set_parameter_property RX_IEEE_OUI			ENABLED false
		set_parameter_property RX_AUX_GPU			ENABLED false
		set_parameter_property RX_SYMBOLS_PER_CLOCK ENABLED false
	}


	if {$support_dp_tx} {
        if {$tx_bps == 6} {
            set_parameter_value TX_SUPPORT_18BPP 1
            set_parameter_value TX_SUPPORT_24BPP 0
            set_parameter_value TX_SUPPORT_30BPP 0
            set_parameter_value TX_SUPPORT_36BPP 0
            set_parameter_value TX_SUPPORT_48BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_16BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_20BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_24BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_12BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_15BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_18BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$tx_bps == 8} {
            set_parameter_value TX_SUPPORT_18BPP 1
            set_parameter_value TX_SUPPORT_24BPP 1
            set_parameter_value TX_SUPPORT_30BPP 0
            set_parameter_value TX_SUPPORT_36BPP 0
            set_parameter_value TX_SUPPORT_48BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_20BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_24BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_15BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_18BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$tx_bps == 10} {
            set_parameter_value TX_SUPPORT_18BPP 1
            set_parameter_value TX_SUPPORT_24BPP 1
            set_parameter_value TX_SUPPORT_30BPP 1
            set_parameter_value TX_SUPPORT_36BPP 0
            set_parameter_value TX_SUPPORT_48BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_20BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_24BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_15BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_18BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$tx_bps == 12} {
            set_parameter_value TX_SUPPORT_18BPP 1
            set_parameter_value TX_SUPPORT_24BPP 1
            set_parameter_value TX_SUPPORT_30BPP 1
            set_parameter_value TX_SUPPORT_36BPP 1
            set_parameter_value TX_SUPPORT_48BPP 0
            set_parameter_value TX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_20BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_24BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value TX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_15BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_18BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$tx_bps == 16} {
            set_parameter_value TX_SUPPORT_18BPP 1
            set_parameter_value TX_SUPPORT_24BPP 1
            set_parameter_value TX_SUPPORT_30BPP 1
            set_parameter_value TX_SUPPORT_36BPP 1
            set_parameter_value TX_SUPPORT_48BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_20BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_24BPP 1
            set_parameter_value TX_SUPPORT_YCBCR422_32BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_15BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_18BPP 1
            set_parameter_value TX_SUPPORT_YCBCR420_24BPP 1
        } 
    }

    if {$rx_scrambler_seed == 65534} {
        set_parameter_value RX_SUPPORT_EDP 1
    }
    
	if {$support_dp_rx} {
        if {$rx_bps == 6} {
            set_parameter_value RX_SUPPORT_18BPP 1
            set_parameter_value RX_SUPPORT_24BPP 0
            set_parameter_value RX_SUPPORT_30BPP 0
            set_parameter_value RX_SUPPORT_36BPP 0
            set_parameter_value RX_SUPPORT_48BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_16BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_20BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_24BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_12BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_15BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_18BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$rx_bps == 8} {
            set_parameter_value RX_SUPPORT_18BPP 1
            set_parameter_value RX_SUPPORT_24BPP 1
            set_parameter_value RX_SUPPORT_30BPP 0
            set_parameter_value RX_SUPPORT_36BPP 0
            set_parameter_value RX_SUPPORT_48BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_20BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_24BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_15BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_18BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$rx_bps == 10} {
            set_parameter_value RX_SUPPORT_18BPP 1
            set_parameter_value RX_SUPPORT_24BPP 1
            set_parameter_value RX_SUPPORT_30BPP 1
            set_parameter_value RX_SUPPORT_36BPP 0
            set_parameter_value RX_SUPPORT_48BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_20BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_24BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_15BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_18BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$rx_bps == 12} {
            set_parameter_value RX_SUPPORT_18BPP 1
            set_parameter_value RX_SUPPORT_24BPP 1
            set_parameter_value RX_SUPPORT_30BPP 1
            set_parameter_value RX_SUPPORT_36BPP 1
            set_parameter_value RX_SUPPORT_48BPP 0
            set_parameter_value RX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_20BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_24BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_32BPP 0
            set_parameter_value RX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_15BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_18BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_24BPP 0
        } 
        if {$rx_bps == 16} {
            set_parameter_value RX_SUPPORT_18BPP 1
            set_parameter_value RX_SUPPORT_24BPP 1
            set_parameter_value RX_SUPPORT_30BPP 1
            set_parameter_value RX_SUPPORT_36BPP 1
            set_parameter_value RX_SUPPORT_48BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_16BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_20BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_24BPP 1
            set_parameter_value RX_SUPPORT_YCBCR422_32BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_12BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_15BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_18BPP 1
            set_parameter_value RX_SUPPORT_YCBCR420_24BPP 1
        } 
    }
        
   if { $support_tx_ss && $support_dp_tx } {
     #if { $tx_support_mst } {
     #set_parameter_property TX_SUPPORT_AUDIO  ENABLED false
     #send_message warning "Displayport MST Source does not support Audio mode"
     #} else {
     set_parameter_property TX_SUPPORT_AUDIO  ENABLED true     
     #}
   } else {
     set_parameter_property TX_SUPPORT_AUDIO  ENABLED false
   }

   if { $support_tx_ss && $support_dp_tx && $tx_support_audio} {
	 set_parameter_property TX_AUDIO_CHANS  ENABLED true
   } else {
	 set_parameter_property TX_AUDIO_CHANS  ENABLED false
   }

   if { $support_rx_ss  && $support_dp_rx } {
     #if { $rx_support_mst } {
     #set_parameter_property RX_SUPPORT_AUDIO  ENABLED false
     #send_message warning "Displayport MST Sink does not support Audio mode"
     #} else {
     set_parameter_property RX_SUPPORT_AUDIO  ENABLED true     
     #}
   } else {
     set_parameter_property RX_SUPPORT_AUDIO  ENABLED false
   }

   if { $support_rx_ss  && $support_dp_rx && $rx_support_audio} {
	 set_parameter_property RX_AUDIO_CHANS  ENABLED true
   } else {
	 set_parameter_property RX_AUDIO_CHANS  ENABLED false
   }


	# Publish RX and TX capabilities in "system.h"
	set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_MAX_LINK_RATE [get_parameter_value RX_MAX_LINK_RATE]
	set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_MAX_LINK_RATE [get_parameter_value TX_MAX_LINK_RATE]
	set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_MAX_LANE_COUNT [get_parameter_value RX_MAX_LANE_COUNT]
	set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_MAX_LANE_COUNT [get_parameter_value TX_MAX_LANE_COUNT]
	if { $include_mst && $rx_support_mst} {
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_SUPPORT_MST 1
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_MAX_NUM_OF_STREAMS [get_parameter_value RX_MAX_NUM_OF_STREAMS]
	} else {
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_SUPPORT_MST 0
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_MAX_NUM_OF_STREAMS 1
	}
  if { $include_mst && $tx_support_mst} {
    set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_SUPPORT_MST 1
    set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_MAX_NUM_OF_STREAMS [get_parameter_value TX_MAX_NUM_OF_STREAMS]
  } else {
    set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_SUPPORT_MST 0
    set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_MAX_NUM_OF_STREAMS 1
  }
	# if { $rx_support_hdcp && $support_dp_rx } {
		# set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_SUPPORT_HDCP1 1
		# set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_SUPPORT_HDCP2 1
	#} else {
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_SUPPORT_HDCP1 0
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_RX_SUPPORT_HDCP2 0
        #}
	# if { $tx_support_hdcp && $support_dp_tx } {
		# set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_SUPPORT_HDCP1 1
		# set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_SUPPORT_HDCP2 1
	# } else {
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_SUPPORT_HDCP1 0
		set_module_assignment embeddedsw.CMacro.BITEC_CFG_TX_SUPPORT_HDCP2 0
	# }

	###
	# Display messages indicating the number of reconfig interfaces required for a given configuration
	#

    # Total
    #set total [expr $rx_channels + $tx_channels*2]
    #set add_s [expr {$total > 1 ? "s" : " "}]
    #send_message info "altera_dp will require ${total} reconfiguration interface${add_s} for connection to the external reconfiguration controller."

    # RX Channels
    #if { [expr {$rx_channels > 0} ] } {
		#set max [expr $rx_channels - 1]
		#set add_s [expr {$rx_channels > 1 ? "s" : " "}]
		#set is_are [expr {$rx_channels > 1 ? "are" : "is"}]
		#set count [expr {$rx_channels > 1 ? "0-${max}" : "0"}]
		#send_message info "Reconfiguration interface offset${add_s} ${count} $is_are connected to the RX transceiver channel${add_s}."
	#}

    # TX Channels
    #if { [expr {$tx_channels > 0} ] } {
      #set min $rx_channels
      #set max [expr $min + $tx_channels - 1]
      #set add_s [expr {$tx_channels > 1 ? "s" : " "}]
      #set is_are [expr {$tx_channels > 1 ? "are" : "is"}]
      #set count [expr {$tx_channels > 1 ? "${min}-${max}" : "${min}"}]
      #send_message info "Reconfiguration interface offset${add_s} ${count} ${is_are} connected to the TX transceiver channel${add_s}."
    #}

    # TX PLLS
    #if { [expr {$tx_channels > 0} ] } {
      #set min [expr $rx_channels + $tx_channels]
      #set max [expr $min + $tx_channels - 1]
      #set add_s [expr {$tx_channels > 1 ? "s" : " "}]
      #set is_are [expr {$tx_channels > 1 ? "are" : "is"}]
      #set count [expr {$tx_channels > 1 ? "${min}-${max}" : "${min}"}]
      #send_message info "Reconfiguration interface offset${add_s} ${count} ${is_are} connected to the transmit PLL${add_s}."
    #}

	###
	# Display warning messages if the color depth support request
	# exceeds the BPC range
	#
    set tx_18bpp [get_parameter_value TX_SUPPORT_18BPP]
	set tx_24bpp [get_parameter_value TX_SUPPORT_24BPP]
	set tx_30bpp [get_parameter_value TX_SUPPORT_30BPP]
	set tx_36bpp [get_parameter_value TX_SUPPORT_36BPP]
	set tx_48bpp [get_parameter_value TX_SUPPORT_48BPP]
	set tx_422_16bpp [get_parameter_value TX_SUPPORT_YCBCR422_16BPP]
	set tx_422_20bpp [get_parameter_value TX_SUPPORT_YCBCR422_20BPP]
	set tx_422_24bpp [get_parameter_value TX_SUPPORT_YCBCR422_24BPP]
	set tx_422_32bpp [get_parameter_value TX_SUPPORT_YCBCR422_32BPP]
	set tx_420_12bpp [get_parameter_value TX_SUPPORT_YCBCR420_12BPP]
	set tx_420_15bpp [get_parameter_value TX_SUPPORT_YCBCR420_15BPP]
	set tx_420_18bpp [get_parameter_value TX_SUPPORT_YCBCR420_18BPP]
	set tx_420_24bpp [get_parameter_value TX_SUPPORT_YCBCR420_24BPP]

	if {$support_dp_tx} {
        if {!($tx_18bpp || $tx_24bpp || $tx_30bpp || $tx_36bpp || $tx_48bpp || $tx_422_16bpp || $tx_422_20bpp || $tx_422_24bpp || $tx_422_32bpp)} {
			send_message error "At least 1 source color depth support need to be selected"
        }
		if {$tx_24bpp && [expr {$tx_bps < 8}] } {
			send_message warning "Requested support for source color depth of 24 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
		if {$tx_30bpp && [expr {$tx_bps < 10}] } {
			send_message warning "Requested support for source color depth of 30 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
		if {$tx_36bpp && [expr {$tx_bps < 12}] } {
			send_message warning "Requested support for source color depth of 36 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
		if {$tx_48bpp && [expr {$tx_bps < 16}] } {
			send_message warning "Requested support for source color depth of 48 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
		if {$tx_422_16bpp && [expr {$tx_bps < 8}] } {
			send_message warning "Requested support for source color depth of 16 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
		if {$tx_422_20bpp && [expr {$tx_bps < 10}] } {
			send_message warning "Requested support for source color depth of 20 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
		if {$tx_422_24bpp && [expr {$tx_bps < 12}] } {
			send_message warning "Requested support for source color depth of 24 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
		if {$tx_422_32bpp && [expr {$tx_bps < 16}] } {
			send_message warning "Requested support for source color depth of 32 bpp which exceeds the maximum input color depth $tx_bps (bpc)"
		}
	}

	set rx_18bpp [get_parameter_value RX_SUPPORT_18BPP]
	set rx_24bpp [get_parameter_value RX_SUPPORT_24BPP]
	set rx_30bpp [get_parameter_value RX_SUPPORT_30BPP]
	set rx_36bpp [get_parameter_value RX_SUPPORT_36BPP]
	set rx_48bpp [get_parameter_value RX_SUPPORT_48BPP]
	set rx_422_16bpp [get_parameter_value RX_SUPPORT_YCBCR422_16BPP]
	set rx_422_20bpp [get_parameter_value RX_SUPPORT_YCBCR422_20BPP]
	set rx_422_24bpp [get_parameter_value RX_SUPPORT_YCBCR422_24BPP]
	set rx_422_32bpp [get_parameter_value RX_SUPPORT_YCBCR422_32BPP]
	set rx_420_12bpp [get_parameter_value RX_SUPPORT_YCBCR420_12BPP]
	set rx_420_15bpp [get_parameter_value RX_SUPPORT_YCBCR420_15BPP]
	set rx_420_18bpp [get_parameter_value RX_SUPPORT_YCBCR420_18BPP]
	set rx_420_24bpp [get_parameter_value RX_SUPPORT_YCBCR420_24BPP]

	if {$support_dp_rx} {
        if {!($rx_18bpp || $rx_24bpp || $rx_30bpp || $rx_36bpp || $rx_48bpp || $rx_422_16bpp || $rx_422_20bpp || $rx_422_24bpp || $rx_422_32bpp)} {
			send_message error "At least 1 sink color depth support need to be selected"
        }
		if {$rx_24bpp && [expr {$rx_bps < 8}] } {
			send_message warning "Requested support for sink color depth of 24 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
		if {$rx_30bpp && [expr {$rx_bps < 10}] } {
			send_message warning "Requested support for sink color depth of 30 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
		if {$rx_36bpp && [expr {$rx_bps < 12}] } {
			send_message warning "Requested support for sink color depth of 36 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
		if {$rx_48bpp && [expr {$rx_bps < 16}] } {
			send_message warning "Requested support for sink color depth of 48 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
		if {$rx_422_16bpp && [expr {$rx_bps < 8}] } {
			send_message warning "Requested support for sink color depth of 16 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
		if {$rx_422_20bpp && [expr {$rx_bps < 10}] } {
			send_message warning "Requested support for sink color depth of 20 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
		if {$rx_422_24bpp && [expr {$rx_bps < 12}] } {
			send_message warning "Requested support for sink color depth of 24 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
		if {$rx_422_32bpp && [expr {$rx_bps < 16}] } {
			send_message warning "Requested support for sink color depth of 32 bpp which exceeds the maximum output color depth $rx_bps (bpc)"
		}
	}

		# Choose the appropriate PHY based on the family, link rate &
		# xcvr_width
		if {$device_family == "Stratix V"} {
			set family "sv"
		} elseif {$device_family == "Arria V"} {
			set family "av"
		} elseif {$device_family == "Arria V GZ"} {
			set family "avgz"
		} elseif {$device_family == "Cyclone V"} {
			set family "cv"
		} elseif {$device_family == "Arria 10"} {
			set family "a10"
		} else {
			# Unknown family
			send_message error "Current device family ($device_family) is not supported."
		}

		# if {$tx_link_rate == 20} {
			# set tx_phy_link_rate "hbr2"
		# } elseif {$tx_link_rate == 10} {
			# set tx_phy_link_rate "hbr"
		# } else {
			# set tx_phy_link_rate "rbr"
		# }

		# if {$rx_link_rate == 20} {
			# set rx_phy_link_rate "hbr2"
		# } elseif {$rx_link_rate == 10} {
			# set rx_phy_link_rate "hbr"
		# } else {
			# set rx_phy_link_rate "rbr"
		# }

		# Get the XCVR width from the symbols per clock
		# only 2 and 4 symbols are allowed
		if {$rx_symbols_per_clock == 2} {
			set rx_phy_xcvr_width 20
		} elseif {$rx_symbols_per_clock == 4} {
			set rx_phy_xcvr_width 40
		} else {
			send_message error "Sink: $rx_symbols_per_clock symbols per clock is not supported."
		}

		if {$tx_symbols_per_clock == 2} {
			set tx_phy_xcvr_width 20
		} elseif {$tx_symbols_per_clock == 4} {
			set tx_phy_xcvr_width 40
		} else {
			send_message error "Source: $tx_symbols_per_clock symbols per clock is not supported."
		}

		# Register the PHY IP variants
		#register_phy_ip $family "rx" $rx_phy_link_rate $rx_phy_xcvr_width
		#register_phy_ip $family "tx" $tx_phy_link_rate $tx_phy_xcvr_width
        
        
# ##############################################
# Example Design tab validation
# ##############################################
    if {$device_family == "Arria 10"} {
        set_display_item_property  "Design Example"    VISIBLE         true
    } else {
        set_display_item_property  "Design Example"    VISIBLE         false
    }

    if { $rx_support_mst || $tx_support_mst || $tx_video_im_enable } {
        set_parameter_property  SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "0:None" }
    } else {
        set_parameter_property  SELECT_SUPPORTED_VARIANT ALLOWED_RANGES { "1:DisplayPort SST Parallel Loopback with PCR" }
    }
    
    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] != 0 } {
        set_parameter_property ENABLE_ED_FILESET_SYNTHESIS  ENABLED true
        set_parameter_property ENABLE_ED_FILESET_SIM        ENABLED true
        set_parameter_property SELECT_ED_FILESET            ENABLED true
        set_parameter_property SELECT_TARGETED_BOARD        ENABLED true
    }

    if {[get_parameter_value ENABLE_ED_FILESET_SYNTHESIS] == 0 && [get_parameter_value ENABLE_ED_FILESET_SIM] == 0} {
        send_message warning "At least one of the \"Simulation\" and \"Synthesis\" check boxes from \"Design Example Files\" must be selected to allow generation of Design Example Files."
    }

    if { [get_parameter_value SELECT_SUPPORTED_VARIANT] == 0 } {
        set_parameter_property  SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" }
    } else {
        set_parameter_property  SELECT_TARGETED_BOARD ALLOWED_RANGES { "0:No Development Kit" "1:Arria 10 GX FPGA Development Kit" "2:Custom Development Kit" }
    }
    
    if { [get_parameter_value SELECT_TARGETED_BOARD] == 0 } {
        ## No development kit selection
		set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
        set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $device_part<br><br></html>"
        set_parameter_value ED_DEVICE $device_part
       
        set_display_item_property target_devkit_txt TEXT \
            "<html>Design Example generation will produce necessary files for Quartus compile. The Quartus<br>
            Settings File (QSF) will have pin assignments set to virtual pins.<br>
            <br>
            The field Device Selected under the <b>Target Device</b> category below displays the target <br>
            device for this Design Example. If you need to change the target device, follow instructions <br> 
            provided in the field <b>To Change Target Device</b> under <b>Target Device</b> below.</html>"

        set_display_item_property custom_device_txt TEXT \
            "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
            desired device. When completed, the <b>Device Selected</b> field above reflects the new device.</html>"

    } elseif { [get_parameter_value SELECT_TARGETED_BOARD] == 1 } {
        # Altera development kit selection
        set_parameter_property SELECT_CUSTOM_DEVICE ENABLED true
			set devkit_part "10AX115S2F45I1SG"

        if {[get_parameter_value SELECT_CUSTOM_DEVICE] == 1} {
            if {![validate_custom_device $devkit_part]} {
                send_message WARNING "The device selected is not a valid variation of the device on the selected Intel FPGA Development kit. \
                                        Allowed variations are only for 'SerDes Speed Grade'.etc. Check the device part number and try again."
                set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $devkit_part<br><br></html>"
                set_parameter_value ED_DEVICE $devkit_part
            } else {
                set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $device_part<br><br></html>"
                set_parameter_value ED_DEVICE $device_part
            }
        } else {
          set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $devkit_part<br><br></html>"
          set_parameter_value ED_DEVICE $devkit_part
        }

        set_display_item_property target_devkit_txt TEXT \
            "<html>Design Example generation produces the necessary files for Quartus Prime project targeted<br>
            to the selected Altera development kit.<br>
            <br>
            The field <b>Device Selected</b> under the <b>Targeted Device</b> category below displays the target <br>
            device for the selected Altera development kit. If your board revision has a different grade <br>
            of this device, you should change it to correct device grade. To change the target device, <br>
            follow instructions provided in the field <b>To change Target Device</b> under <b>Target Device</b> <br>
            below.</html>"

        set_display_item_property custom_device_txt TEXT \
            "<html><b>To change Target Device</b>: First check the <b>Change Target Device</b> box above. Then from <br>
            the menu bar use <b>View</b> -> '<b>Device Family</b>' to select desired device. When completed, <br>
            the <b>Device Selected</b> field above reflects the new device.</html>"

    } else {
        # Custom development kit selection
		set_parameter_property SELECT_CUSTOM_DEVICE ENABLED false
        set_display_item_property target_dev TEXT "<html>Device Selected:     Family: $device_family Device $device_part<br><br></html>"
        set_parameter_value ED_DEVICE $device_part

        set_display_item_property target_devkit_txt TEXT \
            "<html>Design Example generation produces the necessary files for Quartus Prime project. The <br>
            Quartus Settings File (QSF) includes pin assignment statements without pin number. After the <br>
            Design Example generation, you must edit the QSF file in quartus folder to add pin numbers according to your custom board layout.<br>
            <br>
            The field <b>Device Selected</b> under the <b>Targeted Device</b> category below displays the target <br>
            device for this Design Example. If your board revision has a different device, you should <br>
            change it to correct device. To change the target device, follow instructions provided in <br>
            the field <b>To change Target Device</b> under <b>Target Device</b> below.</html>"

        set_display_item_property custom_device_txt TEXT "<html><b>To change Target Device</b>: From the menu bar use <b>View</b> -> '<b>Device Family</b>' to select <br>
        desired device. When completed, the <b>Device Selected</b> field above reflects the new device.</html>"
    }
         
}

proc validate_custom_device { devkit_part } {
    set DEVICE [get_parameter_value DEVICE]
    set DEVKIT_DEVICE $devkit_part

    set success_extract_device_info [regexp -nocase {(^[0-9]*[a-z]*[0-9]*[a-z]*)[0-9]*([a-z]*[0-9]*)[a-z]*[0-9]*[a-z](G)(.*$)} $DEVICE \
                                    full_match device_info_1 device_info_2 device_info_3 device_info_4]
    set success_extract_devkit_device_info [regexp -nocase {(^[0-9]*[a-z]*[0-9]*[a-z]*)[0-9]*([a-z]*[0-9]*)[a-z]*[0-9]*[a-z](G)(.*$)} $DEVKIT_DEVICE \
                                            full_match_devkit devkit_device_info_1 devkit_device_info_2 devkit_device_info_3 devkit_device_info_4]

    if {$success_extract_device_info == 1 && $success_extract_devkit_device_info == 1} {
        if {![string compare -nocase $device_info_1 $devkit_device_info_1] && ![string compare -nocase $device_info_2 $devkit_device_info_2] \
            && ![string compare -nocase $device_info_3 $devkit_device_info_3] && \
            ( [string equal $device_info_4 "E3"] || [string equal $device_info_4 "" ])} {
            ## Added above line to not support NF5ES and ES2 devices
            return 1;          
        } else {
            return 0;
        }
    } else {
        return 0;
    }

}

# +-----------------------------------
# | Example design fileset generation
# | 

add_fileset example_design EXAMPLE_DESIGN generate_example
set_fileset_property example_design ENABLE_FILE_OVERWRITE_MODE true

proc generate_example {name} {  
    global env
    set qdir $env(QUARTUS_ROOTDIR)
    set family [get_parameter_value device_family]
    set variant [get_parameter_value SELECT_SUPPORTED_VARIANT]
    set sv_src_dir "${qdir}/../ip/altera/altera_dp/hw_demo/sv"
    set av_src_dir "${qdir}/../ip/altera/altera_dp/hw_demo/av_sk_4k"
    set cv_src_dir "${qdir}/../ip/altera/altera_dp/hw_demo/cv"

    if { $family == "Arria 10" } {
        generate_qsys_ed
    } elseif  { $family == "Stratix V" } {
        glob_recursive $sv_src_dir sv
    } elseif  { $family == "Arria V" } {
        glob_recursive $av_src_dir av
    } elseif  { $family == "Cyclone V" } {
        glob_recursive $cv_src_dir cv
    } else {}
}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/hco1410462777019/hco1410462237607
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697803359
