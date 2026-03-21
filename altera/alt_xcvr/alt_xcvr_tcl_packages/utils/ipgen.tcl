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


package provide alt_xcvr::utils::ipgen 13.0

namespace eval ::alt_xcvr::utils::ipgen:: {
  namespace export \
    ipgenerate \
    run_tclsh_script \
    parse_filelist_from_csv_report \
    create_system_verilog_param_package \
    create_c_param_header
}


###
# Procedure to call ipgenerate for generating an IP core. "exec"s out to
# TCL shell to call ip-generate.
#
# @param filepath - The path to a directory where IP generation will be performed. The
#                   path must have write permissions. Usually this is obtained from
#                   the "_hw.tcl" framework using the "create_temp_file" command.
# @param filename - The name of a ".tcl" file that will be used to create the TCL script
#                   that will call the ip-generate command. This is usually obtained from
#                   the "_hw.tcl" framework using the "create_temp_file" command.
# @param subdir - A subdirectory name under the provided "filepath" where the output of
#                 ip-generate will be generated to.
# @param arg_list - A list of arguments to pass to "ip-generate". This will likely include
#                 - IP parameters and values, etc.
# @param add_files - 1=Automatically add generated files to the current fileset.
#                    0=Do not add generated files to the current fileset.
#
# @return - A list of files (full path) that were generated.
proc ::alt_xcvr::utils::ipgen::ipgenerate { filepath filename subdir {arg_list} {add_files 0} } {

  set csvfile "${filepath}/${subdir}/filelist.csv"

  set qdir $::env(QUARTUS_ROOTDIR)
  set cmd "${qdir}/sopc_builder/bin/ip-generate"
  set cmd "${cmd} --output-directory=${filepath}/${subdir}"
  set cmd "${cmd} --report-file=csv:${csvfile}"
  
  foreach arg $arg_list {
    set cmd "${cmd} ${arg}"
  }

  set fh [open $filename w]
  
  puts $fh "catch \{eval \[exec ${cmd}\]\} temp"
  puts $fh "puts \$temp"

  close $fh
  set result [run_tclsh_script $filename]
  puts "run_tclsh_script result:${result}"

  # Get list of files from CSV report
  set filelist [parse_filelist_from_csv_report $csvfile]

  # We need to:
  # 1 - Extract the generated file paths from the file list.
  # 2 - Prepend the full file path to the listed files.
  # # - Optionally add the files to the current fileset
  set fullfilelist {}
  set filetypes {}
  foreach line $filelist {
    set item "${filepath}/${subdir}/[lindex [split $line ","] 0]"
    set filetype [lindex [split $line ","] 1]
    lappend fullfilelist $item
    lappend filetypes $filetype
    # Add files to fileset if specified
    if {$add_files} {
      add_fileset_file "./[file tail $item]" $filetype PATH $item
    }
  }
  # Return the file list (if desired)
  return $fullfilelist
}

# proc: get_quartus_bindir
#
#   Returns the QUARTUS_BINDIR value without requring it to be set in the environment.
#   Works in both the Jacl & Native tcl interpreters
#
# returns:
#
#   Directory containing the Quartus binaries which match the bitness of the current tcl interpreter
#
proc alt_xcvr::utils::ipgen::get_quartus_bindir {} {

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

proc alt_xcvr::utils::ipgen::run_tclsh_script {filename} {
    set qbindir [get_quartus_bindir]
	set cmd [concat [list exec "${qbindir}/tclsh" $filename]]
	#_dprint 1 "Running the command: $cmd"
	set cmd_fail [catch { eval $cmd } tempresult]

	set lines [split $tempresult "\n"]
	set num_errors 0
	foreach line $lines {
		#_dprint 1 "Returned: $line"
		if {[regexp -nocase -- {[ ]+error[ ]*:[ ]*(.*)[ ]*$} $line match error_msg]} {
			# e.g: 2011.09.15.17:38:15 Error: core1_p0_altdqdqs: "Memory frequency" (INPUT_FREQ) (800) out of range (120,600)
			#_eprint "Error during execution of script $filename: $error_msg" 1
			incr num_errors
		} elseif {[regexp -nocase -- {^[ ]*couldn.*execute.*$} $line match]} {
			# e.g: couldn't execute "quartus_ma": no such file or directory
			#_eprint "Error during execution of script $filename: $match" 1
			incr num_errors
		} elseif {[regexp -nocase -- {child process exited abnormally} $line match]} {
			#_eprint "Error during execution of script $filename: $match" 1
			incr num_errors
		} elseif {[regexp -nocase -- {Quartus.*Shell was unsuccessful} $line match]} {
			# e.g: Error: Quartus II 64-Bit Shell was unsuccessful. 1 error, 0 warnings
			# This one doesn't match any useful single line error message, so don't print anything right now.
			# The entire error output will be printed outside of this loop.
			incr num_errors
		}
	}

	if {$num_errors > 0 || $cmd_fail} {
		#_eprint "Execution of script $filename failed" 1
		# For some reason printing $tempresult with _iprint doesn't work.
		# It might contain weird control characters. Instead, loop and print every line.
		foreach line $lines {
			#_eprint "$line" 1
		}
	} else {
		#_dprint 1 "Execution of script $filename was a success"
	}

	return $tempresult
}


proc ::alt_xcvr::utils::ipgen::parse_filelist_from_csv_report { csvfile } {
  set fh [open "$csvfile" r]
  set state 0
  set filelist {}
  while {[gets $fh line] >= 0} {
    if {$state == 0} {
      #Looking for filelist
      if { [string first "filepath" $line] == 0 } {
        set state 1
      }
    } elseif {$state == 1} {
      if {[string first "#" $line] == 0} {
        set state 2
      } else {
        # Within filelist
        lappend filelist $line
      }
    }
  }
  close $fh
  return $filelist
}


# Generates text for a system_verilog package file containing parameters defining variables
# containing the data specified by the "data" argument.
#
# NOTE - Requirse TCL 8.5
#
# @param package_name - Name of the systemverilog package.
# @param data - A dictionary 3-deep dictionary (name->property->value). The file output will
# appear as follows:
#
#   package package_name;
#
#   localparam NAME0_PROPERTY0 = NAME0_PROPERTY0_VALUE;
#   localparam NAME0_PROPERTY1 = NAME0_PROPERTY1_VALUE;
#   ...
#   ...
#   localparam NAME1_PROPERTY0 = NAME1_PROPERTY0_VALUE;
#   localparam NAME1_PROPERTY1 = NAME1_PROPERTY1_VALUE;
#   ...
#   endpackage
#
proc ::alt_xcvr::utils::ipgen::create_system_verilog_param_package { family package_name data {ram_data "" } } {

  set out_str "package ${package_name};\n\n"

  # Determine DPRIO address width
  if {$family == "stratix10"} {
    set addr_width 27
  } elseif {$family == "arria10"} {
    set addr_width 26
  } else {
    set addr_width 26
  }

  # First add RAM data array if passed
  if {$ram_data != ""} {
    set ram_entries [build_ram_entries_from_ram_config_data $family $ram_data]
    set ram_length [dict size $ram_entries]
    set out_str "${out_str}localparam ram_depth = $ram_length;\n"
    set ram_length [expr {$ram_length - 1}]
    set out_str "${out_str}function \[[expr {${addr_width}-1}]:0\] get_ram_data;\n \
                  input integer index;\n"
    # Declare ram data array
    set out_str "${out_str}  automatic reg \[0:$ram_length\]\[[expr {${addr_width}-1}]:0\] ram_data = \{\n"
    set count 0
    dict for {offset offset_data} $ram_entries {
      dict with offset_data {
        set out_str "$out_str    $addr_width'h[format %03X $offset][format %02X $mask][format %02X $val_mask]"
        if {$count < $ram_length} {
          set out_str "${out_str},"
        } else {
          set out_str "${out_str} "
        }
        set out_str "${out_str} // $comment\n"
      }
      incr count
    }
    set out_str "${out_str}\};\n\n"

    # Add function body
    set out_str "${out_str}  begin\n \
                      get_ram_data = ram_data\[index\];\n \
                  end\n"
    set out_str "${out_str}endfunction\n\n"

  }

  dict for {name props} $data {
    dict for {prop val} $props {
      set out_str "${out_str}localparam [string toupper ${name}_${prop}] = ${val};\n"
    }
    set out_str "${out_str}\n"
  }
  set out_str "${out_str}endpackage"

  return $out_str
}

# Generates text for a C header file containing macros
# containing the data specified by the "data" argument.
#
# NOTE - Requirse TCL 8.5
#
# @param header_macro - Name of the #ifndef to surround the contents of the file
# @param param_prefix - Prefix to apply to all macro definitions (to avoid namespace collisions)
# @param data - A dictionary 3-deep dictionary (name->property->value). The file output will
# appear as follows:
#
#   #ifndef __HEADERMACRO_H__
#   #define __HEADERMACRO_H__
#
#   #define <PARAM_PREFIX>_NAME0_PROPERTY0 NAME0_PROPERTY0_VALUE
#   #define <PARAM_PREFIX>_NAME0_PROPERTY1 NAME0_PROPERTY1_VALUE
#   ...
#   ...
#   #define <PARAM_PREFIX>_NAME1_PROPERTY0 NAME1_PROPERTY0_VALUE
#   #define <PARAM_PREFIX>_NAME1_PROPERTY1 NAME1_PROPERTY1_VALUE
#   ...
#   #endif //__HEADERMACRO_H__
#
proc ::alt_xcvr::utils::ipgen::create_c_param_header { family header_macro param_prefix data {ram_data ""} } {

  set header_macro [string toupper $header_macro]
  set out_str "#ifndef __${header_macro}_H__\n"
  set out_str "${out_str}#define __${header_macro}_H__\n\n"

  # First add RAM data array if passed
  if {$ram_data != ""} {
    set ram_entries [build_ram_entries_from_ram_config_data $family $ram_data]
    set ram_length [dict size $ram_entries]

    set out_str "${out_str}#ifdef [string toupper "${param_prefix}_DECLARE_RAM_ARRAY"]\n"
    set out_str "${out_str}#define [string toupper "${param_prefix}_RAM_SIZE"] $ram_length\n"
    set out_str "${out_str}unsigned int ${param_prefix}_ram_array\[${ram_length}\] = \{\n"
    set ram_length [expr {$ram_length - 1}]
    set count 0
    dict for {offset offset_data} $ram_entries {
      dict with offset_data {
        set out_str "$out_str    0x[format %03X $offset][format %02X $mask][format %02X $val_mask]"
        if {$count < $ram_length} {
          set out_str "${out_str},"
        } else {
          set out_str "${out_str} "
        }
        set out_str "${out_str} /* $comment */\n"
      }
      incr count
    }
    set out_str "${out_str}\};\n#endif\n\n"
  }


  dict for {name props} $data {
    dict for {prop val} $props {
      set val [regsub {.*'h} $val "0x"]
      set val [regsub {.*'d} $val "" ]
      set out_str "${out_str}#define [string toupper ${param_prefix}_${name}_${prop}] ${val}\n"
    }
    set out_str "${out_str}\n"
  }
  set out_str "${out_str}#endif //__${header_macro}_H__\n"

  return $out_str
}


##
# 
# @param data - A 4-deep dictionary (address_offset0
#                                     {highest_bit_in_bit_mask0
#                                       {mask <bitmask>
#                                        val_mask <bit_mask with data applied>
#                                        param <parameter name for this mask (used for comment)>
#                                        param_val <parameter value (used for comment)>
#                                        bit_l <lowest bit in bitmask>
#                                        bit_h <highest bit in bitmask (redundant with previous key)>
#                                       }
#                                     }
#                                     {highest_bit_in_bit_mask1
#                                       ...
#                                     }
#                                    address_offset1
#                                     ...
proc ::alt_xcvr::utils::ipgen::build_ram_entries_from_ram_config_data { family data } {
  set ram_entry [dict create]

  # Determine DPRIO address width
  if {$family == "stratix10"} {
    set addr_width 27
  } elseif {$family == "arria10"} {
    set addr_width 26
  } else {
    set addr_width 26
  }

  # Iterate over offsets
  set offset_list [lsort -integer [dict keys $data]]
  foreach offset $offset_list {
    # Initialize data
    set this_mask 0
    set this_val_mask 0
    set comment ""
    # Iterate over each field and modify data
    set bit_h_list [lsort -integer [dict keys [dict get $data $offset]]]
    foreach this_bit_h $bit_h_list {
      set info [dict get $data $offset $this_bit_h]
      dict with info {
        set this_mask [expr {$this_mask | $mask}]
        set this_val_mask [expr {$this_val_mask | $val_mask}]
        set comment "\[$bit_h:$bit_l\]-$param=$param_val\($bit_s'h[format %X $bit_value]\); ${comment}"
      }
    }
    set comment [string trim "\[[expr {${addr_width}-1}]:16\]-DPRIO address=0x[format %03X $offset]; \[15:8\]-bit mask=0x[format %02X $this_mask]; ${comment}"]

    dict set ram_entry $offset offset $offset
    dict set ram_entry $offset mask $this_mask
    dict set ram_entry $offset val_mask $this_val_mask
    dict set ram_entry $offset comment $comment
  }

  return $ram_entry
}

# Generates text for a MIF (Memory Initialization File)
# containing the data specified by the "data" argument.
# The MIF contains the address, data, and data mask for
# registers within the HSSI channel
#
# NOTE - Requires TCL 8.5
#
# @param data - Dictionary containing ram data (see ::build_ram_entries_from_ram_config_data )
#                                     {highest_bit_in_bit_mask0
#                                       {mask <bitmask>
#                                        val_mask <bit_mask with data applied>
#                                        param <parameter name for this mask (used for comment)>
#                                        param_val <parameter value (used for comment)>
#                                        bit_l <lowest bit in bitmask>
#                                        bit_h <highest bit in bitmask (redundant with previous key)>
#                                       }
#                                     }
#                                     {highest_bit_in_bit_mask1
#                                       ...
#                                     }
#                                    address_offset1
#                                     ...
#
# @return - Returns text that can be output to a MIF file. The content of each
#           entry in the MIF is:
# STRATIX10 bits[26:16]-DPRIO address; bits[15:8]-bitmask; bits[7:0]-data
# ARRIA10   bits[25:16]-DPRIO address; bits[15:8]-bitmask; bits[7:0]-data
proc ::alt_xcvr::utils::ipgen::create_series10_style_mif { family data args } {
  set output ""
  set address 0

  # Determine DPRIO address width
  if {$family == "stratix10"} {
    set addr_width 27
  } elseif {$family == "arria10"} {
    set addr_width 26
  } else {
    set addr_width 26
  }

  # Add a record to the memory contents
  # Automatically increments address counter
  proc add_record { value {comment ""} } {
    upvar address address
    upvar output output

    if [string is integer $value] {
      set value [format %07X $value]
    }
    set output "${output}[format %02X $address] : $value;"
    if {$comment != ""} {
      set output "${output} -- $comment"
    }
    set output "${output}\n"
    # Increment memory address
    incr address
  }

  # MIF header information
  # DEPTH will be substituted later
  set output "DEPTH = \0DEPTH_KEY\0;\n"
  set output "${output}WIDTH = $addr_width;\n"
  set output "${output}ADDRESS_RADIX = HEX;\n"
  set output "${output}DATA_RADIX = HEX;\n"
  set output "${output}CONTENT\n"
  set output "${output}BEGIN\n"

  # Convert ram data to ram entries and add records
  set ram_entries [build_ram_entries_from_ram_config_data $family $data]
  dict for {offset offset_data} $ram_entries {
    dict with offset_data {
      add_record [expr {($offset << 16) | ($mask << 8) | $val_mask}] ${comment}
    }
  }

  # Add 0xFFFFFFF record to indicate end of file
  if {$family == "stratix10"} {
    add_record 0x7ffffff "End of data"
  } elseif {$family == "arria10"} {
    add_record 0x3ffffff "End of data"
  } else {
    add_record 0x3ffffff "End of data"
  }


  # Finish file
  set output "${output}END;\n"
  # Replace RAM depth
  set output [regsub "\0DEPTH_KEY\0" $output $address]

  return $output
}


# Generates comma-separated hex values for a single profile
# to initialize the embedded reconfiguration rom. Contains
# the address, data, and data mask for registers within the
# HSSI channel
#
# NOTE - Requires TCL 8.5
#
# @param data - Dictionary containing ram data (see ::build_ram_entries_from_ram_config_data )
#                                     {highest_bit_in_bit_mask0
#                                       {mask <bitmask>
#                                        val_mask <bit_mask with data applied>
#                                        param <parameter name for this mask (used for comment)>
#                                        param_val <parameter value (used for comment)>
#                                        bit_l <lowest bit in bitmask>
#                                        bit_h <highest bit in bitmask (redundant with previous key)>
#                                       }
#                                     }
#                                     {highest_bit_in_bit_mask1
#                                       ...
#                                     }
#                                    address_offset1
#                                     ...
#
# @return - Returns a strong of comma-separated hex values. The content of each
#           entry is:
# STRATIX10 bits[26:16]-DPRIO address; bits[15:8]-bitmask; bits[7:0]-data
# ARRIA10   bits[25:16]-DPRIO address; bits[15:8]-bitmask; bits[7:0]-data
proc ::alt_xcvr::utils::ipgen::create_raw_hex_file { family data args } {
  set output ""
  set address 0

  # Determine DPRIO address width
  if {$family == "stratix10"} {
    set addr_width 27
  } elseif {$family == "arria10"} {
    set addr_width 26
  } else {
    set addr_width 26
  }

  # Add a record to the memory contents
  # Automatically increments address counter
  proc add_record { value } {
    upvar address address
    upvar output output
    upvar addr_width addr_width

    if [string is integer $value] {
      set value [format %07X $value]
    }
    set output "${output}    $addr_width'h"
    set output "${output}$value"
    set output "${output},\n"
    # Increment memory address
    incr address
  }

  # Convert ram data to ram entries and add records
  set ram_entries [build_ram_entries_from_ram_config_data $family $data]
  dict for {offset offset_data} $ram_entries {
    dict with offset_data {
      add_record [expr {($offset << 16) | ($mask << 8) | $val_mask}]
    }
  }

  # Add 0xFFFFFFF record to indicate end of file
  if {$family == "stratix10"} {
    add_record 0x7ffffff
  } elseif {$family == "arria10"} {
    add_record 0x3ffffff
  } else {
    add_record 0x3ffffff
  }

  return [list $address $output]
}


# Generates SystemVerilog package file for embedded reconfiguration streamer.
# Includes a list of configuration profile depths corresponding to the hex
# values generated by create_raw_hex_file, a total rom depth, and a 2D array
# containing the hex values for initializing the embedded reconfiguration rom.
#
# NOTE - Requires TCL 8.5
#
# @param data - List containing:
#           the depths of the configuration profiles in the
#           concatenated hex files beginning with the depth of profile 0 and in
#           order of increasing profile number
#
# @return - Returns text that can be output to a SystemVerilog package file.
proc ::alt_xcvr::utils::ipgen::create_rcfg_strm_params { family filename depths_list rom_depth rom_data} {

  # Determine DPRIO address width
  if {$family == "stratix10"} {
    set addr_width 27
  } elseif {$family == "arria10"} {
    set addr_width 26
  } else {
    set addr_width 26
  }

  # Generate package file header
  set out_str "// Parameters for embedded reconfiguration streamer\n\n"
  set out_str "${out_str}package ${filename};\n\n"
  
  # Generate parameters
  set out_str "${out_str}  localparam rom_data_width = ${addr_width}; // ROM data width \n"
  set out_str "${out_str}  localparam rom_depth = ${rom_depth}; // Depth of reconfiguration rom\n"
  set out_str "${out_str}  localparam rcfg_cfg_depths = \"${depths_list},"
  set out_str [string trimright $out_str ","]
  set out_str "${out_str}\"; // Depths of individual configuration profiles in rom\n\n"
  
  # Genrate rom initializer
  set out_str "${out_str}  // Reconfiguration rom containing all profiles in order\n"
  set out_str "${out_str}  localparam reg \[[expr {${addr_width}-1}]:0\] config_rom \[0:[expr {${rom_depth} - 1}]\] = '{\n"
  set out_str "${out_str}${rom_data}"
  set out_str [string trimright $out_str ",\n"]
  set out_str "${out_str}\n  };\n"
  
  # Close package
  set out_str "${out_str}endpackage"

  return $out_str
}


