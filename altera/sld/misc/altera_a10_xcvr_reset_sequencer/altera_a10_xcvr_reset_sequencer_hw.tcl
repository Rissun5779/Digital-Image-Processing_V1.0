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


package require -exact qsys 14.0

# 
# module altera_a10_xcvr_reset_sequencer
# 
set_module_property DESCRIPTION "Altera Arria 10 XCVR Reset Sequencer"
set_module_property NAME altera_a10_xcvr_reset_sequencer 
set_module_property VERSION 18.1
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Altera Arria 10 XCVR Reset Sequencer"
set_module_property INTERNAL true
set_module_property EDITABLE false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property elaboration_callback do_elaboration

# 
# file sets
#

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH do_fileset_quartus_synth

#
# parameters
# 

# SETTINGS
add_parameter SETTINGS STRING ""
set_parameter_property SETTINGS DEFAULT_VALUE ""
set_parameter_property SETTINGS UNITS None
set_parameter_property SETTINGS HDL_PARAMETER false

# COUNT
add_parameter COUNT INTEGER 3 "COUNT"
set_parameter_property COUNT DEFAULT_VALUE 3
set_parameter_property COUNT UNITS None
set_parameter_property COUNT HDL_PARAMETER false

proc do_fileset_quartus_synth {output_name} {
    set filename ${output_name}.v ;# Depends on what Qsys gives us as the output_name 
    set top_level_contents [render_top_level $output_name] 
    add_fileset_file $filename VERILOG TEXT $top_level_contents ;# adds VHDL file with contents taken from variable $top_level_contents
    add_fileset_file ./altera_xcvr_reset_sequencer.sv SYSTEM_VERILOG PATH altera_xcvr_reset_sequencer.sv
    add_fileset_file ./alt_xcvr_resync.sv SYSTEM_VERILOG PATH alt_xcvr_resync.sv
}

# Check if this compilation context requires a clock endpoint
# At present QIC --> NEEDS_CLOCK, QHD --> !NEEDS_CLOCK
proc get_needs_clock {} {
    set count [get_parameter_value COUNT]
    set settings [get_parameter_value SETTINGS]
    set result 0
    
    for { set i 0 } { $i < $count } { incr i } {   
        array set conf {use_clock 0 needs_clock 0 } ; # Defaults
        catch {array set conf [lindex $settings $i]}

        # Since 'needs_clock 0' is the default in fabrics.xml, and above, anything straying from this default
        # we can assume is because a clock is actually needed (i.e. we are in QIC)
        if {$conf(needs_clock) == 1} {
            set result 1
            break
        }
    }
    
    return $result
}

# Check if a specific reset endpoint index is configured as a clock source
proc get_use_clock {index} {
    set settings [get_parameter_value SETTINGS]
    
    array set conf {use_clock 0 needs_clock 0 } ; # Defaults
    catch {array set conf [lindex $settings $index]}
    set result $conf(use_clock)
    
    return $result
}

# Check if a specific reset endpoint index is configured as a clock source
proc find_clock {} {
    set count [get_parameter_value COUNT]
    set clock_index 0
    
    for { set i 0 } { $i < $count } { incr i } {
        if {[get_use_clock $i]} {
            set clock_index $i
            break
        }
    }
    
    return $clock_index
}

# Get the total number of reset endpoints configured as clock sources
proc get_total_clocks {} {    
    set count [get_parameter_value COUNT]
    set clock_ep_count 0
    
    for { set i 0 } { $i < $count } { incr i } {
        set current_use_clock [get_use_clock $i]        
        set clock_ep_count [expr {$current_use_clock + $clock_ep_count}]
    }
    
    return $clock_ep_count
}

# Get the total number of reset endpoints not configured as clock sources
proc get_total_reset_eps {} {    
    set count [get_parameter_value COUNT]
    set total_clocks [get_total_clocks]
    
    return [expr {$count - $total_clocks}]
}

#//DFF altera_clk_user_reg(
#//  .d    (1'b0),
#//  .clk  (altera_clk_user),
#//  .clrn (1'b1),
#//  .prn  (altera_clk_user),
#//  .q    (altera_clk_user)
#//  );
proc render_top_level {output_name} {    
    set template {
@@if {$is_pro} {
@@	if {!$needs_clock} {
    (*altera_attribute = "-name INTERFACE_TYPE \\"altera:instrumentation:fabric_monitor:1.0\\" -section_id ***reserved_a10_xcvr***; -name INTERFACE_ROLE \\"altera_clk_user\\" -to \\"altera_clk_user\\" -section_id ***reserved_a10_xcvr***;\\
-name INTERFACES \\"\\
    \{\\
        'version' : '1',\\
        'interfaces' : [\\
            \{\\
                'type' : 'altera:instrumentation:fabric_monitor:1.0',\\
                'ports' : [\\
                    \{\\
                        'name' : 'altera_clk_user',\\
                        'role' : 'altera_clk_user'\\
                    \}\\
                ],\\
                'parameters' : [\\
                    \{\\
                        'name' : 'SECTION_ID',\\
                        'value' : '***reserved_a10_xcvr***'\\
                    \}\\
                ]\\
            \}\\
        ]\\
    \}\\
    \\" -to |;\\
-name SDC_STATEMENT \\"if { [get_collection_size [get_pins -compatibility_mode -nowarn ~ALTERA_CLKUSR~~ibuf|o]] > 0 } { create_clock -name ~ALTERA_CLKUSR~ -period 8 [get_pins -compatibility_mode -nowarn ~ALTERA_CLKUSR~~ibuf|o] }\\"" *)
@@      }    
@@} else {
@@	if {!$needs_clock} {
    (*altera_attribute = "-name SDC_STATEMENT \\"if { [get_collection_size [get_pins -compatibility_mode -nowarn ~ALTERA_CLKUSR~~ibuf|o]] > 0 } { create_clock -name ~ALTERA_CLKUSR~ -period 8 [get_pins -compatibility_mode -nowarn ~ALTERA_CLKUSR~~ibuf|o] }\\"" *)
@@	}
@@}

module ${output_name} (
@@if {$is_pro} {
    input wire altera_clk_user,
@@}
@@for { set i 0 } { $i < $count } { incr i } {
@@  if {[get_use_clock $i]} {
    input wire clk_in_${i},
    input wire reset_req_${i}, // Unused (this is part of a reset ep configured as a clock input)
@@    if { [expr $i == ($count - 1)] } {
    output wire reset_out_${i}  // Unused (this is part of a reset ep configured as a clock input)
@@    } else {
    output wire reset_out_${i},  // Unused (this is part of a reset ep configured as a clock input)
@@    }
@@  } else {
    input wire clk_in_${i},  // Unused (this is part of a reset ep configured which isn't configured as a clock input)
    input  wire reset_req_${i},
@@    if { [expr $i == ($count - 1)] } {
    output wire reset_out_${i}
@@    } else {
    output wire reset_out_${i},
@@    }
@@  }
@@}
);
    
wire [$reset_count-1:0] reset_req;
wire [$reset_count-1:0] reset_out;

// Assgnments to break apart the bus
@@set clock_offset 0
@@for { set i 0 } { $i < $count } { incr i } {
@@  if {![get_use_clock $i]} {
@@    set current_reset_index [expr {$i - $clock_offset}]
assign reset_req[${current_reset_index}]  = reset_req_${i};
assign reset_out_${i}  = reset_out[${current_reset_index}];
@@  } else {
assign reset_out_${i}  = 1'b0;
@@    incr clock_offset
@@  }
@@}

@@if {!$needs_clock} {
  wire altera_clk_user_int;
  twentynm_oscillator ALTERA_INSERTED_INTOSC_FOR_TRS
  (
    .clkout(altera_clk_user_int),
    .clkout1(),
    .oscena(1'b1)
  );
@@}

altera_xcvr_reset_sequencer
#(
  .CLK_FREQ_IN_HZ              ( 125000000 ),
  .RESET_SEPARATION_NS         ( 200       ),
  .NUM_RESETS                  ( $reset_count    )              // total number of resets to sequence
                                                     // rx/tx_analog, pll_powerdown
) altera_reset_sequencer (
  // Input clock
@@if {$needs_clock} {
@@set clock_ep_index [find_clock]
  .altera_clk_user             ( clk_in_${clock_ep_index} ),       // Connect to CLKUSR
@@} else {
  .altera_clk_user             ( altera_clk_user_int ),       // Connect to CLKUSR
@@}
  // Reset requests and acknowledgements
  .reset_req                   ( reset_req       ),
  .reset_out                   ( reset_out       ) 
);
endmodule}
    
    # setup template parameters
    set params(output_name) $output_name
    set params(count) [get_parameter_value COUNT]
    set params(reset_count) [get_total_reset_eps]
    set params(needs_clock) [get_needs_clock]
    set params(is_pro) [is_software_edition quartus_prime_pro]
    
    # process template with parameters
    set contents [altera_terp $template params] ;# pass parameter array in by reference
    return $contents   
}

proc do_elaboration {} {
    set count [get_parameter_value COUNT]
    set clock_ep_count [get_total_clocks]
    set needs_clock [get_needs_clock]
    
    # Print error messages
    # TODO for now, remove the warning messages, as we only support internal oscillator
    #if {$needs_clock} {
    #    if {$clock_ep_count > 1} {
    #        send_message ERROR "Only one altera_a10_xcvr_clock_module is allowed per design."
    #    } elseif {$clock_ep_count < 1} {
    #        send_message ERROR "An altera_a10_xcvr_clock_module is required for this design to work properly."
    #    }
    #} else {
    #    if {$clock_ep_count > 0} {
    #        send_message ERROR "No altera_a10_xcvr_clock_module is required for this design to work properly."
    #    }
    #}
    
    for { set i 0 } { $i < $count } { incr i } {
        
        ### Reset Interface
        add_interface reset_$i conduit end
    
        ### Signals
        add_interface_port reset_$i clk_in_$i clk_in Input 1
        add_interface_port reset_$i reset_out_$i tre_reset_in Output 1
        add_interface_port reset_$i reset_req_$i tre_reset_req Input 1
    }
}

# This proc was put at the end to preserve syntax highlighting for the rest of the file
proc altera_terp { template parameters } {
        global terp_out
        set terp_out ""

    set r "";

    append r "global terp_out"
        upvar $parameters param;
        append r "\nupvar 2 $parameters param";
    foreach name [array names param] {
        append r "\nset $name " {$param(} "$name" {)}
    }
    
    set lines [split $template "\n"]
    foreach line $lines {
    
        set tclcmd ""
        set all ""
        set is_tcl_cmd [regexp {@@(.*)} $line all tclcmd]

        if {$is_tcl_cmd} {
            append r "\n$tclcmd";
        } else {
            # ----------------------------------------
            # This is not a tcl command, but we still want variable
            # substitution.
            # Escape '[', ']', and '"' so that TCL doesn't use them.
            # ----------------------------------------
            regsub -all {\[} $line {\\[} line
            regsub -all {\]} $line {\\]} line
            regsub -all {\"} $line {\\"} line
            
            append r "\nappend terp_out \"${line}\\n\""
        }
    }
        proc doGeneration { } "$r"
        if { [ catch { doGeneration } result ] == 1 } {
          send_message WARNING "proc doGeneration { } {"
          send_message WARNING "$r"
      send_message WARNING "}"
        }
        set terp_out ""
        doGeneration
    return $terp_out
}
