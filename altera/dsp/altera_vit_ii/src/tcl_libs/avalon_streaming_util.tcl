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


########################################################################
#
# If you are adding an avalon streaming interfaces which has a
# fragment list, then you must use the following functions:
# dsp_add_streaming_interface
# dsp_add_interface_port
# dsp_set_interface_property 
#
# instead of:
# add_interface
# add_interface_port
# set_interface_property
#
# This will ensure that the correct port names appear at the top level
# entity when the IP core is generated outside of Qsys.
#
########################################################################
add_parameter design_env STRING "SYSTEM"
set_parameter_property design_env VISIBLE false
set_parameter_property design_env system_info DESIGN_ENVIRONMENT

#
# direction is one of sink or source
# name is the name of the interface
#
proc dsp_add_streaming_interface { name direction } {
    if { [get_parameter_value design_env] eq {QSYS} } {
         add_interface $name avalon_streaming $direction
    } else { 
        if { $direction eq {sink} } {
           add_interface $name conduit end
        } else {
           add_interface $name conduit start
           set_interface_assignment $name "ui.blockdiagram.direction" OUTPUT
        }
        #set_interface_property $name allowMultipleExportRoles 1	
    }
}

#
# The method signature is identical to  that of add_interface_port except that a fragment list
# must be specified for data signal_type.
#
# frag_list should be a list of name value pairs where the name is the name of the port
# and value is the width of the port. For example, "imag 16 real 16" 
#
proc dsp_add_interface_port { interface port signal_type direction width_expression {frag_list ""} } {
   if { [get_parameter_value design_env] eq {QSYS} } {
      add_interface_port $interface $port $signal_type $direction $width_expression
      if { $signal_type eq {data} } { 
         set_port_property $port fragment_list [build_fragment_list $frag_list] 
 
      }
   } else {
      if { $signal_type eq {data} } { 
         set len [llength $frag_list]
         if { $len % 2 } {
            send_message ERROR "List must have an even number of items: $frag_list"
         }
         for {set i 0} {$i < $len} {incr i; incr i} {
            set port  [lindex $frag_list $i]
            set width [lindex $frag_list [expr {$i+1}]]
            add_interface_port $interface $port $port $direction $width

            if {$width>1} {
                set_port_property $port VHDL_TYPE STD_LOGIC_VECTOR
            }
         }
      } else {
         add_interface_port $interface $port $port $direction $width_expression 
      }
      
   }
}

#
# The method signature is identical to that of set_interface_property
#
proc dsp_set_interface_property { name  property value } {
   if { ($property eq {dataBitsPerSymbol}) ||  $property eq {beatsPerCycle} ||  $property eq {symbolsPerBeat} || ($property eq {maxChannel})|| ($property eq {readyLatency})} {
      if { [get_parameter_value design_env] eq {QSYS} } {
         set_interface_property $name $property $value
      }
   } else {
         set_interface_property $name $property $value
   }
}

proc build_fragment_list { frag_list } {
   set x ""
   for {set i 0} {$i < [llength $frag_list]} {incr i; incr i} {
      set port  [lindex $frag_list $i]
      set width [lindex $frag_list [expr {$i+1}]]
      if { $width eq 1 } {
         append x "$port "
      } else {
         append x "$port\([expr $width-1]:0\) "
      }
   }
   return $x
}
