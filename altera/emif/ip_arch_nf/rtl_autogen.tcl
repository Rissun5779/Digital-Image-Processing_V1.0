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


# package: altera_emif::ip_arch_nf::rtl_autogen
#
# Provides the utility functions for the arch_nf component
#
package provide altera_emif::ip_arch_nf::rtl_autogen 0.1

################################################################################
###                          TCL INCLUDES                                   ###
################################################################################
package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::enums
package require altera_emif::util::device_family
package require altera_emif::util::math

################################################################################
###                          TCL NAMESPACE                                   ###
################################################################################
namespace eval ::altera_emif::ip_arch_nf::rtl_autogen:: {
   # Namespace Variables
   
   # Import functions into namespace
   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::math::*

   # Export functions
}

################################################################################
###                          TCL PROCEDURES                                  ###
################################################################################

# proc: update_rtl
#
# Internal function to update RTL
#
# parameters:
#
# returns:
#
proc ::altera_emif::ip_arch_nf::rtl_autogen::update_rtl {} {
   return [_update_long_bitvec_params] && \
          [_update_hmc_params] && \
          [_update_mem_ports] && \
          [_update_afi_ports]
}

################################################################################
###                       PRIVATE FUNCTIONS                                  ###
################################################################################

# proc: _update_segment
#
# Internal function to update a code segment marked between a begin and an end marker
#
# parameters:
#
# returns: updated full string
#
proc ::altera_emif::ip_arch_nf::rtl_autogen::_update_segment {original new begin_marker end_marker} {

   set skip_line 0
   set updated 0
   
   set newlines [list]
   set lines [split $original "\n"]
   
   foreach line $lines {
      set trimmed_line [string trim $line]
      if {$trimmed_line == $begin_marker} {
         lappend newlines $line
         lappend newlines {*}[split $new "\n"]
         set skip_line 1
         set updated 1
      } elseif {$trimmed_line == $end_marker} {
         lappend newlines $line
         set skip_line 0
      } elseif {!$skip_line} {
         lappend newlines $line
      }
   }
  
   if {! $updated} {
      emif_ie "Unable to update code segment \"$begin_marker\""
   }
   return [join $newlines "\n"]
}

# proc: _update_long_bitvec_params
#
# Internal function to update RTL
#
# parameters:
#
# returns:
#
proc ::altera_emif::ip_arch_nf::rtl_autogen::_update_long_bitvec_params {} {

   set rtl_path "$::env(ACDS_SRC_ROOT)/ip/emif/ip_arch_nf/rtl/altera_emif_arch_nf_top.sv"

   # Collect all the special bit-vector params
   set bitvec_params [dict create]
   foreach param_name [get_parameters] {
      set i [string first "_AUTOGEN_WCNT" $param_name]
      if {$i != -1} {
         set num_of_words [get_parameter_property $param_name DEFAULT_VALUE] 
         set param_name   [string range $param_name 0 [expr {$i - 1}]]
         dict set bitvec_params $param_name $num_of_words
      }
   }
   
   # Read original RTL code
   set fh_rtl   [open $rtl_path r]
   set rtl_code [read $fh_rtl]
   close $fh_rtl
   
   # Generate most up-to-date RTL code
   set param_defs      [list]
   set localparam_defs [list]
   set assertion_defs  [list]
   
   foreach param_name [dict keys $bitvec_params] {
      set num_of_words    [dict get $bitvec_params $param_name]
      set wcnt_param_name "${param_name}_AUTOGEN_WCNT"
   
      lappend param_defs "parameter [format "%-40s" $wcnt_param_name]= 0"
      
      set sub_params [list]
      for {set i [expr {$num_of_words - 1}]} {$i >= 0} {incr i -1} {
         set sub_param_name "${param_name}_${i}"
         lappend sub_params $sub_param_name
         lappend param_defs "parameter [format "%-40s" $sub_param_name]= 1'b0"
      }
      
      lappend localparam_defs "localparam [format "%-30s" $param_name]= {[join $sub_params "\[29:0\],"]\[29:0\]};"
      lappend assertion_defs  "assert([format "%-40s" $wcnt_param_name] == $num_of_words) else \$fatal(\"$wcnt_param_name != $num_of_words - Parameter definitions in RTL and Tcl generation code are out of sync!\");"
   }
   
   set param_defs      "   [join $param_defs ",\n   "]"
   set localparam_defs "   [join $localparam_defs "\n   "]"
   set assertion_defs  "      [join $assertion_defs "\n      "]"
   
   # Update RTL
   set rtl_code [_update_segment $rtl_code $param_defs \
      "// AUTOGEN_BEGIN: Definition of bit-vector parameters" \
      "// AUTOGEN_END: Definition of bit-vector parameters"]
      
   set rtl_code [_update_segment $rtl_code $assertion_defs \
      "// AUTOGEN_BEGIN: Assertions to ensure Tcl and RTL are in sync" \
      "// AUTOGEN_END: Assertions to ensure Tcl and RTL are in sync"]

   set rtl_code [_update_segment $rtl_code $localparam_defs \
      "// AUTOGEN_BEGIN: Derive bit-vector parameters" \
      "// AUTOGEN_END: Derive bit-vector parameters"]

   # Write out RTL
   set has_error [catch {open $rtl_path w} fh_rtl]
   
   if {$has_error} {
      puts "Unable to update RTL: $rtl_path"
      puts "   Read-only? File does not exist?"
      return 0
   } else {
      puts $fh_rtl [string trim $rtl_code]
      close $fh_rtl
      puts "Updated RTL: $rtl_path"
      return 1
   }
}

# proc: _update_hmc_params
#
# Internal function to update RTL
#
# parameters:
#
# returns:
#
proc ::altera_emif::ip_arch_nf::rtl_autogen::_update_hmc_params {} {

   set top_rtl_path "$::env(ACDS_SRC_ROOT)/ip/emif/ip_arch_nf/rtl/altera_emif_arch_nf_top.sv"
   set io_tiles_rtl_path "$::env(ACDS_SRC_ROOT)/ip/emif/ip_arch_nf/rtl/altera_emif_arch_nf_io_tiles.sv"
   
   # Read original RTL code
   set fh_rtl [open $top_rtl_path r]
   set top_rtl_code [read $fh_rtl]
   close $fh_rtl
   
   set fh_rtl [open $io_tiles_rtl_path r]
   set io_tiles_rtl_code [read $fh_rtl]
   close $fh_rtl
   
   # Generate most up-to-date RTL code
   set param_defs      [list]
   set io_tiles_asgmts [list]
   set wysiwyg_asgmts  [list]
   
   foreach hmc_cfg_enum [enums_of_type HMC_CFG] {
      set data_type    [enum_data $hmc_cfg_enum DATA_TYPE]
      set wysiwyg_name [enum_data $hmc_cfg_enum WYSIWYG_NAME]
      set comment      [enum_data $hmc_cfg_enum COMMENT]
      set width        [enum_data $hmc_cfg_enum WIDTH]
      
      if {$data_type == "string"} {
         set default_val "\"\""
         lappend param_defs      "parameter           [format "%-40s" $hmc_cfg_enum]= $default_val"
      } else {
         set default_val 0
         lappend param_defs      "parameter \[[format "%3d" [expr {$width-1}]]:  0\] [format "%-40s" $hmc_cfg_enum]= $default_val"
      }
      lappend io_tiles_asgmts ".[format "%-36s" $hmc_cfg_enum] ($hmc_cfg_enum)"
      
      if {[string first "*" $wysiwyg_name] == -1} {
         lappend wysiwyg_asgmts  ".[format "%-32s" $wysiwyg_name] [format "%-38s" "($hmc_cfg_enum),"] //__ACDS_USER_COMMENT__ $comment"
      } else {
         # Expand RTL parameters to the full set that overs the controller and the dbc's
         lappend wysiwyg_asgmts  ".[format "%-32s" [string map {"*" "ctrl"} $wysiwyg_name]] [format "%-38s" "($hmc_cfg_enum),"] //__ACDS_USER_COMMENT__ $comment"
         lappend wysiwyg_asgmts  ".[format "%-32s" [string map {"*" "dbc0"} $wysiwyg_name]] [format "%-38s" "($hmc_cfg_enum),"] //__ACDS_USER_COMMENT__ $comment"
         lappend wysiwyg_asgmts  ".[format "%-32s" [string map {"*" "dbc1"} $wysiwyg_name]] [format "%-38s" "($hmc_cfg_enum),"] //__ACDS_USER_COMMENT__ $comment"
         lappend wysiwyg_asgmts  ".[format "%-32s" [string map {"*" "dbc2"} $wysiwyg_name]] [format "%-38s" "($hmc_cfg_enum),"] //__ACDS_USER_COMMENT__ $comment"
         lappend wysiwyg_asgmts  ".[format "%-32s" [string map {"*" "dbc3"} $wysiwyg_name]] [format "%-38s" "($hmc_cfg_enum),"] //__ACDS_USER_COMMENT__ $comment"
      }
   }
   
   set param_defs      "   [join $param_defs ",\n   "],"
   set io_tiles_asgmts "      [join $io_tiles_asgmts ",\n      "]," 
   set wysiwyg_asgmts  "            [join $wysiwyg_asgmts "\n            "]"
   
   # Update RTL
   set top_rtl_code [_update_segment $top_rtl_code $param_defs \
      "// AUTOGEN_BEGIN: Definition of HMC parameters" \
      "// AUTOGEN_END: Definition of HMC parameters"]
      
   set io_tiles_rtl_code [_update_segment $io_tiles_rtl_code $param_defs \
      "// AUTOGEN_BEGIN: Definition of HMC parameters" \
      "// AUTOGEN_END: Definition of HMC parameters"]
      
   set top_rtl_code [_update_segment $top_rtl_code $io_tiles_asgmts \
      "// AUTOGEN_BEGIN: Pass HMC parameters to io_tiles" \
      "// AUTOGEN_END: Pass HMC parameters to io_tiles"]      
      
   set io_tiles_rtl_code [_update_segment $io_tiles_rtl_code $wysiwyg_asgmts \
      "// AUTOGEN_BEGIN: Assign HMC parameters" \
      "// AUTOGEN_END: Assign HMC parameters"]

   # Write out RTL
   set has_error [catch {open $top_rtl_path w} fh_rtl]
   
   if {$has_error} {
      puts "Unable to update RTL: $top_rtl_path"
      puts "   Read-only? File does not exist?"
      return 0
   } else {
      puts $fh_rtl [string trim $top_rtl_code]
      close $fh_rtl
      puts "Updated RTL: $top_rtl_path"
   }
   
   set has_error [catch {open $io_tiles_rtl_path w} fh_rtl]
   
   if {$has_error} {
      puts "Unable to update RTL: $io_tiles_rtl_path"
      puts "   Read-only? File does not exist?"
      return 0
   } else {
      puts $fh_rtl [string trim $io_tiles_rtl_code]
      close $fh_rtl
      puts "Updated RTL: $io_tiles_rtl_path"
      return 1
   }   
}

# proc: _update_mem_ports
#
# Internal function to update RTL
#
# parameters:
#
# returns:
#
proc ::altera_emif::ip_arch_nf::rtl_autogen::_update_mem_ports {} {

   set top_rtl_path "$::env(ACDS_SRC_ROOT)/ip/emif/ip_arch_nf/rtl/altera_emif_arch_nf_top.sv"
   set bufs_rtl_path "$::env(ACDS_SRC_ROOT)/ip/emif/ip_arch_nf/rtl/altera_emif_arch_nf_bufs.sv"
   
   # Read original RTL code
   set fh_rtl [open $top_rtl_path r]
   set top_rtl_code [read $fh_rtl]
   close $fh_rtl
   
   set fh_rtl [open $bufs_rtl_path r]
   set bufs_rtl_code [read $fh_rtl]
   close $fh_rtl
   
   # Generate most up-to-date RTL code
   set width_param_defs       [list]
   set pinloc_param_defs      [list]
   set port_defs              [list]
   set width_param_asgmts     [list]
   set pinloc_param_asgmts    [list]
   
   foreach enum [enums_of_type PORT_MEM] {
      set port_name         [enum_data $enum RTL_NAME]
      set width_param_name  "${enum}_WIDTH"
      set pinloc_param_name "${enum}_PINLOC"
      set is_bus            [enum_data $enum IS_BUS]
      set direction         [enum_data $enum QSYS_DIR]
      
      lappend width_param_defs "parameter [format "%-39s" $width_param_name] = 1"
      lappend pinloc_param_defs "parameter [format "%-39s" $pinloc_param_name] = 10'b0000000000"
      
      if {$direction == "output"} {
         set direction_and_type "output logic"
      } elseif {$direction == "bidir"} {
         set direction_and_type "inout  tri  "
      } else {
         set direction_and_type "input  logic"
      }
      if {$is_bus} {
         set bus_width "\[${width_param_name}-1:0\]"
      } else {
         set bus_width ""
      }
      lappend port_defs  "$direction_and_type [format "%-45s" $bus_width] $port_name"
      
      lappend width_param_asgmts "[format "%-36s" ".${width_param_name}"] (${width_param_name})"
      lappend pinloc_param_asgmts "[format "%-36s" ".${pinloc_param_name}"] (${pinloc_param_name})"
   }
   
   set width_param_defs    "   [join $width_param_defs ",\n   "],"
   set pinloc_param_defs   "   [join $pinloc_param_defs ",\n   "],"
   set port_defs           "   [join $port_defs ",\n   "],"
   set width_param_asgmts  "         [join $width_param_asgmts ",\n         "]," 
   set pinloc_param_asgmts "      [join $pinloc_param_asgmts ",\n      "]," 
   
   # Update RTL
   set top_rtl_code [_update_segment $top_rtl_code $width_param_defs \
      "// AUTOGEN_BEGIN: Definition of memory port widths" \
      "// AUTOGEN_END: Definition of memory port widths"]
      
   set bufs_rtl_code [_update_segment $bufs_rtl_code $width_param_defs \
      "// AUTOGEN_BEGIN: Definition of memory port widths" \
      "// AUTOGEN_END: Definition of memory port widths"]
   
   set bufs_rtl_code [_update_segment $bufs_rtl_code $pinloc_param_defs \
      "// AUTOGEN_BEGIN: Definition of memory port pinlocs" \
      "// AUTOGEN_END: Definition of memory port pinlocs"]
   
   set top_rtl_code [_update_segment $top_rtl_code $port_defs \
      "// AUTOGEN_BEGIN: Definition of memory ports" \
      "// AUTOGEN_END: Definition of memory ports"]
      
   set bufs_rtl_code [_update_segment $bufs_rtl_code $port_defs \
      "// AUTOGEN_BEGIN: Definition of memory ports" \
      "// AUTOGEN_END: Definition of memory ports"]      
      
   set top_rtl_code [_update_segment $top_rtl_code $width_param_asgmts \
      "// AUTOGEN_BEGIN: Assignment of memory port widths" \
      "// AUTOGEN_END: Assignment of memory port widths"]      

   set top_rtl_code [_update_segment $top_rtl_code $pinloc_param_asgmts \
      "// AUTOGEN_BEGIN: Assignment of memory port pinlocs" \
      "// AUTOGEN_END: Assignment of memory port pinlocs"]      

   # Write out RTL
   set has_error [catch {open $top_rtl_path w} fh_rtl]
   
   if {$has_error} {
      puts "Unable to update RTL: $top_rtl_path"
      puts "   Read-only? File does not exist?"
      return 0
   } else {
      puts $fh_rtl [string trim $top_rtl_code]
      close $fh_rtl
      puts "Updated RTL: $top_rtl_path"
   }
   
   set has_error [catch {open $bufs_rtl_path w} fh_rtl]
   
   if {$has_error} {
      puts "Unable to update RTL: $bufs_rtl_path"
      puts "   Read-only? File does not exist?"
      return 0
   } else {
      puts $fh_rtl [string trim $bufs_rtl_code]
      close $fh_rtl
      puts "Updated RTL: $bufs_rtl_path"
      return 1
   }   
}

# proc: _update_afi_ports
#
# Internal function to update RTL
#
# parameters:
#
# returns:
#
proc ::altera_emif::ip_arch_nf::rtl_autogen::_update_afi_ports {} {

   set top_rtl_path "$::env(ACDS_SRC_ROOT)/ip/emif/ip_arch_nf/rtl/altera_emif_arch_nf_top.sv"
   set afi_if_rtl_path "$::env(ACDS_SRC_ROOT)/ip/emif/ip_arch_nf/rtl/altera_emif_arch_nf_afi_if.sv"
   
   # Read original RTL code
   set fh_rtl [open $top_rtl_path r]
   set top_rtl_code [read $fh_rtl]
   close $fh_rtl
   
   set fh_rtl [open $afi_if_rtl_path r]
   set afi_if_rtl_code [read $fh_rtl]
   close $fh_rtl
   
   # Generate most up-to-date RTL code
   set width_param_defs       [list]
   set port_defs              [list]
   set width_param_asgmts     [list]
   set pinloc_param_defs      [list]
   set pinloc_param_asgmts    [list]   
   
   foreach enum [enums_of_type PORT_AFI] {
      set port_name         [enum_data $enum RTL_NAME]
      set width_param_name  "${enum}_WIDTH"
      set is_bus            [enum_data $enum IS_BUS]
      set direction         [enum_data $enum QSYS_DIR]
      
      if {$is_bus} {
         lappend width_param_defs "parameter [format "%-39s" $width_param_name] = 1"
      }
      
      if {$direction == "output"} {
         set direction_and_type "output logic"
      } elseif {$direction == "bidir"} {
         set direction_and_type "inout  tri  "
      } else {
         set direction_and_type "input  logic"
      }
      if {$is_bus} {
         set bus_width "\[${width_param_name}-1:0\]"
      } else {
         set bus_width ""
      }
      lappend port_defs  "$direction_and_type [format "%-45s" $bus_width] $port_name"
      
      lappend width_param_asgmts "[format "%-36s" ".${width_param_name}"] (${width_param_name})"
   }
   
   foreach enum [enums_of_type PORT_MEM] {
      set pinloc_param_name "${enum}_PINLOC"
      lappend pinloc_param_defs "parameter [format "%-39s" $pinloc_param_name] = 10'b0000000000"
      lappend pinloc_param_asgmts "[format "%-36s" ".${pinloc_param_name}"] (${pinloc_param_name})"
   }   
   
   set width_param_defs    "   [join $width_param_defs ",\n   "],"
   set port_defs           "   [join $port_defs ",\n   "],"
   set width_param_asgmts  "         [join $width_param_asgmts ",\n         "]," 
   set pinloc_param_defs   "   [join $pinloc_param_defs ",\n   "],"
   set pinloc_param_asgmts "      [join $pinloc_param_asgmts ",\n      "]," 
   
   # Update RTL
   set top_rtl_code [_update_segment $top_rtl_code $width_param_defs \
      "// AUTOGEN_BEGIN: Definition of afi port widths" \
      "// AUTOGEN_END: Definition of afi port widths"]
      
   set afi_if_rtl_code [_update_segment $afi_if_rtl_code $width_param_defs \
      "// AUTOGEN_BEGIN: Definition of afi port widths" \
      "// AUTOGEN_END: Definition of afi port widths"]
      
   set afi_if_rtl_code [_update_segment $afi_if_rtl_code $pinloc_param_defs \
      "// AUTOGEN_BEGIN: Definition of memory port pinlocs" \
      "// AUTOGEN_END: Definition of memory port pinlocs"]      
   
   set top_rtl_code [_update_segment $top_rtl_code $port_defs \
      "// AUTOGEN_BEGIN: Definition of afi ports" \
      "// AUTOGEN_END: Definition of afi ports"]
      
   set afi_if_rtl_code [_update_segment $afi_if_rtl_code $port_defs \
      "// AUTOGEN_BEGIN: Definition of afi ports" \
      "// AUTOGEN_END: Definition of afi ports"]      
      
   set top_rtl_code [_update_segment $top_rtl_code $width_param_asgmts \
      "// AUTOGEN_BEGIN: Assignment of afi port widths" \
      "// AUTOGEN_END: Assignment of afi port widths"]      
      
   set top_rtl_code [_update_segment $top_rtl_code $pinloc_param_asgmts \
      "// AUTOGEN_BEGIN: Assignment of memory port pinlocs" \
      "// AUTOGEN_END: Assignment of memory port pinlocs"]          

   # Write out RTL
   set has_error [catch {open $top_rtl_path w} fh_rtl]
   
   if {$has_error} {
      puts "Unable to update RTL: $top_rtl_path"
      puts "   Read-only? File does not exist?"
      return 0
   } else {
      puts $fh_rtl [string trim $top_rtl_code]
      close $fh_rtl
      puts "Updated RTL: $top_rtl_path"
   }
   
   set has_error [catch {open $afi_if_rtl_path w} fh_rtl]
   
   if {$has_error} {
      puts "Unable to update RTL: $afi_if_rtl_path"
      puts "   Read-only? File does not exist?"
      return 0
   } else {
      puts $fh_rtl [string trim $afi_if_rtl_code]
      close $fh_rtl
      puts "Updated RTL: $afi_if_rtl_path"
      return 1
   }   
}

# proc: _init
#
# Private function to initialize internal constants
#
# parameters:
#
# returns:
#
proc ::altera_emif::ip_arch_nf::rtl_autogen::_init {} {
}

################################################################################
###                   AUTO RUN CODE AT STARTUP                               ###
################################################################################
# Run the initialization
::altera_emif::ip_arch_nf::rtl_autogen::_init
