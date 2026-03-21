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
# module altera_xcvr_reset_sequencer_s10
# 
set_module_property DESCRIPTION "Altera Stratix 10 Transceiver Reset Sequencer"
set_module_property NAME altera_xcvr_reset_sequencer_s10
set_module_property VERSION 18.1
set_module_property SUPPORTED_DEVICE_FAMILIES {{ALL}}
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Altera Corporation"
set_module_property DISPLAY_NAME "Altera Stratix 10 Transceiver Reset Sequencer"
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

###################################################################################
#   PROCEDURES
###################################################################################

proc do_fileset_quartus_synth {output_name} {
    set filename ${output_name}.v ;# Depends on what Qsys gives us as the output_name 
    set top_level_contents [render_top_level $output_name] 
    add_fileset_file $filename VERILOG TEXT $top_level_contents ;# adds VHDL file with contents taken from variable $top_level_contents
    add_fileset_file ./altera_xcvr_reset_sequencer_s10.sv SYSTEM_VERILOG PATH altera_xcvr_reset_sequencer_s10.sv
    add_fileset_file ./../../../../../altera_xcvr_generic/ctrl/alt_xcvr_resync.sv SYSTEM_VERILOG PATH alt_xcvr_resync.sv
}

# At present QHD --> !NEEDS_CLOCK
proc get_needs_clock {} {
    return 0
}

# Check if a specific reset endpoint index is configured as the default
proc is_full_endpoint {index} {
    set settings [get_parameter_value SETTINGS]
    array set conf {supply_trs_clock 0 receive_trs_clock 0 } ; # Defaults
    catch {array set conf [lindex $settings $index]}
    set supply_trs_clk $conf(supply_trs_clock)
    set receive_trs_clk $conf(receive_trs_clock)
    
    return [expr {$supply_trs_clk == 0 && $receive_trs_clk == 0}]
}

# Check if a specific reset endpoint index is configured as a TRS clock input
proc is_inclk_endpoint {index} {
    set settings [get_parameter_value SETTINGS]
    array set conf {supply_trs_clock 0 receive_trs_clock 0 } ; # Defaults
    catch {array set conf [lindex $settings $index]}
    set supply_trs_clk $conf(supply_trs_clock)
    set receive_trs_clk $conf(receive_trs_clock)
    
    return [expr {$supply_trs_clk == 1 && $receive_trs_clk == 0}]
}

# Check if a specific reset endpoint index is configured as a TRS clock output
proc is_clkout_endpoint {index} {
    set settings [get_parameter_value SETTINGS]
    array set conf {supply_trs_clock 0 receive_trs_clock 0 } ; # Defaults
    catch {array set conf [lindex $settings $index]}
    set supply_trs_clk $conf(supply_trs_clock)
    set receive_trs_clk $conf(receive_trs_clock)
    
    return [expr {$supply_trs_clk == 0 && $receive_trs_clk == 1}]
}

# Find the specific reset endpoint index is configured as a clock source
proc find_clock_input_ep {} {
    set clock_index 0
    
    for { set i 0 } { $i < $count } { incr i } {
        if {[is_inclk_endpoint $i]} {
            set clock_index $i
            break
        }
    }
    
    return $clock_index
}

# Get the total number of reset endpoints configured as clock outputs
proc get_total_clock_output_eps {} {    
    set count [get_parameter_value COUNT]
    set ep_count 0
    
    for { set i 0 } { $i < $count } { incr i } {
        set current_clock_output [is_clkout_endpoint $i]        
        set ep_count [expr {$current_clock_output + $ep_count}]
    }
    
    return $ep_count
}

# Get the total number of reset endpoints configured as clock source (in theory should be only 0 or 1!)
proc get_total_clock_input_eps {} {    
    set count [get_parameter_value COUNT]
    set ep_count 0
    
    for { set i 0 } { $i < $count } { incr i } {
        set current_clock_input [is_inclk_endpoint $i]        
        set ep_count [expr {$current_clock_input + $ep_count}]
    }
    
    return $ep_count
}

# Get the total number of reset endpoints not configured as clock sources
proc get_total_reset_eps {} {    
    set count [get_parameter_value COUNT]
    set total_clocks [expr {[get_total_clock_output_eps] + [get_total_clock_input_eps]}]
    
    return [expr {$count - $total_clocks}]
}

# Get the total number of clk_out_* ports
proc get_total_clock_output_ports {} {
    return [expr {[get_total_reset_eps] + [get_total_clock_output_eps]}]
}

proc render_top_level {output_name} {    
    set template {
@@if {$is_pro} {
@@	if {!$needs_clock} {
    (*altera_attribute = "-name INTERFACES \\"\\
    \{\\
        'version' : '1',\\
        'interfaces' : [\\
            \{\\
                'type' : 'altera:instrumentation:fabric_monitor:1.0',\\
                'ports' : [\\
                    \{\\
                        'name' : 'osc_clk_in',\\
                        'role' : 'osc_clk_in'\\
                    \}\\
                ],\\
                'parameters' : [\\
                    \{\\
                        'name' : 'SECTION_ID',\\
                        'value' : '***reserved_s10_xcvr***'\\
                    \}\\
                ]\\
            \}\\
        ]\\
    \}\\
    \\" -to |;\\
-name SDC_STATEMENT \\"if { [get_collection_size [get_nodes -nowarn *divided_osc_clk]] > 0 } { create_clock -name ALTERA_INSERTED_INTOSC_FOR_TRS|divided_osc_clk -period 8 [get_nodes -nowarn *divided_osc_clk] }\\"" *)

@@      }    
@@} else {
@@	if {!$needs_clock} {
    (*altera_attribute = "-name SDC_STATEMENT \\"if { [get_collection_size [get_nodes -nowarn *divided_osc_clk]] > 0 } { create_clock -name ALTERA_INSERTED_INTOSC_FOR_TRS|divided_osc_clk -period 8 [get_nodes -nowarn *divided_osc_clk] }\\"" *)
@@	}
@@}

module ${output_name} (
input wire osc_clk_in,
@@for { set i 0 } { $i < $count } { incr i } {
@@  if {[is_full_endpoint $i]} {
    input wire reset_req_${i},
    output wire reset_ack_${i},
@@    if { [expr $i == ($count - 1)] } {
    output wire clk_out_${i}
@@    } else {
    output wire clk_out_${i},
@@    }
@@  } elseif {[is_inclk_endpoint $i]} {
@@    if { [expr $i == ($count - 1)] } {
    input wire clk_in_${i}
@@    } else {
    input wire clk_in_${i},
@@    }
@@  } elseif {[is_clkout_endpoint $i]} {
@@    if { [expr $i == ($count - 1)] } {
    output wire clk_out_${i}
@@    } else {
    output wire clk_out_${i},
@@    }
@@  }
@@}
);

@@ set clkout_count 0;
@@for { set i 0 } { $i < $count } { incr i } {
@@  if {[is_full_endpoint $i] || [is_clkout_endpoint $i]} {
@@    incr clkout_count;
@@  } 
@@}
    
  wire [$reset_count-1:0] reset_req;
  wire [$reset_count-1:0] reset_ack;

 // Assigning clk sources
  wire osc_clk_in_int;
@@if {!$needs_clock} { 
  wire sdm_osc_output;

  fourteennm_sdm_oscillator ALTERA_INSERTED_INTOSC_FOR_TRS
  ( 
     //Input Ports

     //Output Ports
    .clkout    (sdm_osc_output),
    .clkout1   ()

  );

  // Dividing SDM oscillator clock frequency in half for 125 MHz (100 MHz in ND5 ES)
  (*altera_attribute = "-name GLOBAL_SIGNAL GLOBAL_CLOCK"*)
  reg divided_osc_clk = 1'b0;

  always@(posedge sdm_osc_output) begin
    divided_osc_clk <= ~divided_osc_clk;
  end

  assign osc_clk_in_int = divided_osc_clk;

@@} else {
@@    set clk_ep_index [find_clock_input_ep]
@@    for { set i 0 } { $i < $count } { incr i } {
  assign osc_clk_in_int = clk_in_${clk_ep_index};
}
@@}

  // Assignments to break apart the bus
@@set clock_offset 0
@@for { set i 0 } { $i < $count } { incr i } {
@@  set current_reset_index [expr {$i - $clock_offset}]
@@  if {[is_full_endpoint $i]} {
  assign reset_req[${current_reset_index}]  = reset_req_${i};
  assign reset_ack_${i}  = reset_ack[${current_reset_index}];
  assign clk_out_${i} = osc_clk_in_int;
@@  } elseif {[is_inclk_endpoint $i]} {
@@    incr clock_offset
@@  } elseif {[is_clkout_endpoint $i]} {
  assign clk_out_${i} = osc_clk_in_int;
@@    incr clock_offset;
@@  }
@@}


  altera_xcvr_reset_sequencer_s10
  #(
    .CLK_FREQ_IN_HZ              ( 125000000 ),
    .RESET_SEPARATION_NS         ( 200       ),
    .NUM_RESETS                  ( $reset_count    )        // total number of resets to sequence
                                                            // rx/tx_analog, pll_powerdown
  ) altera_reset_sequencer (
    // Input clock
    .osc_clk_in                  ( osc_clk_in_int ),       // Connect to OSC_CLK_1
    // Reset requests and acknowledgements
    .reset_req                   ( reset_req       ),
    .reset_ack                   ( reset_ack       )
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
    set settings [get_parameter_value SETTINGS]
    
    for { set i 0 } { $i < $count } { incr i } {
        array set conf {supply_trs_clock 0 receive_trs_clock 0 } ; # Defaults
        catch {array set conf [lindex $settings $i]}
        set supply_trs_clk $conf(supply_trs_clock)
        set receive_trs_clk $conf(receive_trs_clock)

        ### Reset Interface
        add_interface reset_$i conduit end
    
        ### Signals
        if {$supply_trs_clk == 0 && $receive_trs_clk == 0} {
            add_interface_port reset_$i clk_out_$i clk_out Output 1
            add_interface_port reset_$i reset_ack_$i tre_reset_ack Output 1
            add_interface_port reset_$i reset_req_$i tre_reset_req Input 1
        } elseif {$supply_trs_clk == 0 && $receive_trs_clk == 1} {
            add_interface_port reset_$i clk_out_$i clk_out Output 1
        } elseif {$supply_trs_clk == 1 && $receive_trs_clk == 0} {
            add_interface_port reset_$i clk_in_$i clk_in Input 1
        } else {
            send_message error "Unsupported endpoint parametrization."
        }
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
