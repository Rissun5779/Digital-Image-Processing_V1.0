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


#Copyright (C)2001-2002 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.

#use europa_all;
use strict;

#-------------------------------------------------------------------------------
# Component parameter check, internal variables will be used for RTL generation
#-------------------------------------------------------------------------------

# internal variables with default value, will considered as verilog parameter
my $period = 0;
my $period_units = "sec";
my $snapshot = 1;
my $load_value_count;
my $load_value;
my $clock_freq;
my $counter_bits;
my $counter_size = 32;
my $always_run = 0;
my $reset_output = 0;
my $watchdogPulse = 0;
my $fixed_period = 0;
my $timeout_pulse_output = 0;
my $control_register_width;

my $temp;
my $t;
my $modu;
my $loadHigh;
my $loadLow;
my $load_value_string;

my $var;
my @d2h;
my $hexcount;
my @halfword_0;
my @halfword_1;
my @halfword_2;
my @halfword_3;
my $load_value_halfword0;
my $load_value_halfword1;
my $load_value_halfword2;
my $load_value_halfword3;

#-------------------------------------------------------------------------------
# parameter validation
#-------------------------------------------------------------------------------

# validate parameter
sub Validate_Timer_Options
{
  my ($Timer_Options) = (@_);

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "fixed_period",
                        type    => "boolean",
                        default => 0,
                       });

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "snapshot",
                        type    => "boolean",
                        default => 1,
                       });

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "always_run",
                        type    => "boolean",
                        default => 0,
                       });

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "timeout_pulse_output",
                        type    => "boolean",
                        default => 0,
                       });

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "reset_output",
                        type    => "boolean",
                        default => 0,
                       });
  
  &validate_parameter ({hash    => $Timer_Options,
                        name    => "watchdogPulse",
                        type    => "int",
                        allowed => [2 .. 16],
                        default => 2,
                       });

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "period",
                        type    => "string",
                        default => 0,
                       });
  
  &validate_parameter ({hash    => $Timer_Options,
                        name    => "counter_size",
                        type    => "int",
                        allowed => [32,64],
                        default => 32,
                       });

  &validate_parameter ({hash    => $Timer_Options,
                        name    => "period_units",
                        type    => "string",
                        allowed => ["ns",
                                    "us",
                                    "usec",
                                    "ms",
                                    "msec",
                                    "s",
                                    "sec",
                                    "clocks",
                                    "clock"],
                        default => "sec",
                       });
  
  $clock_freq             = $Timer_Options->{clock_freq};
  $period                 = $Timer_Options->{period};
  $period_units           = $Timer_Options->{period_units};
  $snapshot               = $Timer_Options->{snapshot};
  $load_value             = $Timer_Options->{load_value};
  $counter_size           = $Timer_Options->{counter_size};
  $always_run             = $Timer_Options->{always_run};
  $reset_output           = $Timer_Options->{reset_output};
  $watchdogPulse		  = $Timer_Options->{watchdogPulse};
  $fixed_period           = $Timer_Options->{fixed_period};
  $timeout_pulse_output   = $Timer_Options->{timeout_pulse_output};
  
  &ribbit ("fixed-period timers must specify a nonzero period") 
    if ($fixed_period && ($period == 0));
    
  # SPR 246803
  #
  # If load_value is provided in the PTF from the Java model in SOPC Builder,
  # don't compute it.  This is done so that the C-model can just read
  # the value in the PTF and match the hardware easily.

  if (!$load_value) {
    if ($period_units =~ /^clock/i) {
      $load_value = $period - 1;
    } else {
      &ribbit ("bad period_unit value: $period_units") 
        unless $period_units =~ /^(\w*)s(ec)?$/i;
  
      $t = $period * &unit_prefix_to_num ($1);
      
      # SPR 181671
      # perl represent numbers as floating-point values internally,
      # such as
      # print sprintf("%.20f", (1.0 / 1000000.0) * 50 * 1000000);
      # will get 49.99999999999999289457
      #
      # For the above example, sprintf(%u) will get 49,
      #  therefore, round to a %.0f to get 50
      #
      # eg2:
      #   (1.0 / 1000.0) * 29.99999 * 50000000 = 1499999.5
      # it will get rounded to 1500000 (load_value <= 1499999)
      #
      # eg3:
      #   (1.0 / 1000.0) * 29.9999 * 50000000 = 1499995 (load_value <= 1499994)
      
      $temp = $t * $clock_freq;
      $load_value_count = sprintf("%.0f",$temp);
      
      # not to count one too many as zero is included
      $load_value_count = $load_value_count - 1;
      # check for minimum of 1 tick
      $load_value = $load_value_count<1?1:$load_value_count;
    }
  } 

  $counter_bits = 
    &Bits_To_Encode ($load_value);

  &ribbit ("Timepout value ", $period, 
           $period_units, " is too long for a ",$counter_size,"-bit counter")
    if ($counter_bits > $counter_size);

  if (($load_value < 1) && 
      ($period != 0)      ) {
    &ribbit ("Timepout value ", $period, 
             $period_units, " is less than one clock.\n",
             "  using minimum possible value (1 clock period).");
  }

  $counter_bits = $counter_size if !$fixed_period;
  
  if (!$fixed_period) 
  {
      if ($counter_size == 64 ) {
		  my $load_value_halfword3_temp = $load_value >> 48;
		  $load_value_halfword3 = sprintf("16'h%X", $load_value_halfword3_temp);
		  
		  my $load_value_halfword2_temp = $load_value >> 32 & 0x0000FFFF;
		  $load_value_halfword2 = sprintf("16'h%X", $load_value_halfword2_temp);
		  
		  my $load_value_halfword1_temp = $load_value >> 16 & 0x00000000FFFF;
		  $load_value_halfword1 = sprintf("16'h%X", $load_value_halfword1_temp);
		  
		  my $load_value_halfword0_temp = $load_value & 0xFFFF;
		  $load_value_halfword0 = sprintf("16'h%X", $load_value_halfword0_temp);
      }
  }
  
  $control_register_width = $always_run ? 1 : 4 ;

  $load_value_string = sprintf("%d'h%X", 
                                $counter_bits,
                                $load_value,   );
}

#-------------------------------------------------------------------------------
# RTL generation
#-------------------------------------------------------------------------------

sub make_timer
{
  my ($module, $Timer_Options) = (@_);
  &Validate_Timer_Options ($Timer_Options);
  
  my $marker = e_default_module_marker->new($module);

  e_assign->add (["clk_en", 1]);

  e_signal->adds(["internal_counter",   $counter_bits],
                 ["counter_load_value", $counter_bits]);

  e_register->add ({out         => "internal_counter",
                    in          => "internal_counter - 1",
                    enable      => "(counter_is_running || force_reload)",
                    sync_set    => "(counter_is_zero    || force_reload)",
                    set_value   => "counter_load_value",
                    async_value => $load_value_string,
                   });

  e_assign->add(["counter_is_zero", "(internal_counter == 0)"]);

  if ($fixed_period)
  {
    e_assign->add (["counter_load_value", $load_value_string]);

  } else {
     if ($counter_size == 64 ) {
         e_assign->add (["counter_load_value",
                         &concatenate("period_halfword_3_register", "period_halfword_2_register","period_halfword_1_register", "period_halfword_0_register"),
                       ]);
     } else { 
         e_assign->add (["counter_load_value",
                         &concatenate("period_h_register", "period_l_register"),
                        ]);
     }
  }

  if ($counter_size == 64 ) {
    e_register->add ({out => "force_reload",
                      in  => "(period_halfword_3_wr_strobe || period_halfword_2_wr_strobe || period_halfword_1_wr_strobe || period_halfword_0_wr_strobe)",
                   });
  } else { 
    e_register->add ({out => "force_reload",
                      in  => "(period_h_wr_strobe || period_l_wr_strobe)",
                    });
  }

  if ($always_run) 
  {
     if ($reset_output) {
        e_assign->add (["do_start_counter", "start_strobe"]);
     } else { 
        e_assign->add (["do_start_counter", "1"]);
     }
     e_assign->add    (["do_stop_counter",  "0"]);
  } else {
     e_assign->add (["do_start_counter", "start_strobe"]);
     e_assign->add
      (["do_stop_counter", "(stop_strobe                            ) ||
                            (force_reload                           ) ||
                            (counter_is_zero && ~control_continuous )  "]);
  }
  e_register->add ({out         => "counter_is_running",
                    sync_set    => "do_start_counter",
                    sync_reset  => "do_stop_counter",
                    priority    => "set",
                    async_value => "1'b0",
                   });

  e_edge_detector->add ({in   => "counter_is_zero",
                         out  => "timeout_event",
                         edge => "rising",
                        });

  e_register->add ({out        => "timeout_occurred",
                    sync_set   => "timeout_event",
                    sync_reset => "status_wr_strobe",
                   });

  e_assign->add(["irq", "timeout_occurred && control_interrupt_enable"]);

  e_avalon_slave->add ({name => "s1",});  

  e_port->adds (["writedata", 16, "in"],
                ["readdata",  16, "out"],
               );
  
  if ($counter_size == 64 ) {
      e_port->adds (["address",    4, "in"]);
  } else { 
      e_port->adds (["address",    3, "in"]);
  }



  if ($timeout_pulse_output) {
    e_port->add   (["timeout_pulse", 1, "out"]);
    e_register->add ({out       => "timeout_pulse",
					  in		=> "timeout_event",
					 });
  }

  my $watchdogPulse_bits = &Bits_To_Encode ($watchdogPulse);

  if ($reset_output) {
    e_port->add   (["resetrequest", 1, "out"]);
	
	e_edge_detector->add ({in   => "timeout_occurred",
                         out  => "timeout_detected",
                         edge => "rising",
                        });
	
	e_signal->adds(["timeout_counter",   $watchdogPulse_bits],
                 ["timeout_counter_load_value", $watchdogPulse_bits]);
				 
	e_assign->add (["timeout_counter_load_value", $watchdogPulse]);

    e_register->add ({out       => "timeout_counter",
  					in          => "timeout_counter - 1",
					enable		=> "timeout_detected || timeout_counter > 0",
  					sync_set    => "timeout_detected",
  					set_value   => "timeout_counter_load_value",
  				   });
    e_assign->add (["resetrequest", "timeout_counter > 0"]);

  }

  my $read_mux = e_mux->add ({lhs  => e_signal->add (["read_mux_out", 16]),
                              type => "and-or",
                             });

  e_register->add ({out => "readdata",
                    in  => "read_mux_out"});

  if ($counter_size == 64 ) {
      e_assign->adds 
         (["period_halfword_0_wr_strobe", "chipselect && ~write_n && (address == 2)"],
          ["period_halfword_1_wr_strobe", "chipselect && ~write_n && (address == 3)"],
          ["period_halfword_2_wr_strobe", "chipselect && ~write_n && (address == 4)"],
          ["period_halfword_3_wr_strobe", "chipselect && ~write_n && (address == 5)"]);
  } else { 
      e_assign->adds 
         (["period_l_wr_strobe", "chipselect && ~write_n && (address == 2)"],
          ["period_h_wr_strobe", "chipselect && ~write_n && (address == 3)"]);
  }

  if (!$fixed_period) 
  {
     if ($counter_size == 64 ) {
     e_register->adds (
                          {out         => e_signal->add(["period_halfword_0_register", 16]),
                           in          => "writedata",
                           async_value => $load_value_halfword0,
                           enable      => "period_halfword_0_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_halfword_1_register", 16]),
                           in          => "writedata",
                           async_value => $load_value_halfword1,
                           enable      => "period_halfword_1_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_halfword_2_register", 16]),
                           in          => "writedata",
			   async_value => $load_value_halfword2,
                           enable      => "period_halfword_2_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_halfword_3_register", 16]),
                           in          => "writedata",
			   async_value => $load_value_halfword3,
                           enable      => "period_halfword_3_wr_strobe",
                          });
    
     $read_mux->add_table("(address == 2)" => "period_halfword_0_register",
                             "(address == 3)" => "period_halfword_1_register",
                             "(address == 4)" => "period_halfword_2_register",
                             "(address == 5)" => "period_halfword_3_register");
     } else {
        e_register->adds (
                          {out         => e_signal->add(["period_l_register", 16]),
                           in          => "writedata",
                           async_value => ($load_value & 0xFFFF),
                           enable      => "period_l_wr_strobe",
                          },
    
                          {out         => e_signal->add(["period_h_register", 16]),
                           in          => "writedata",
                           async_value => ($load_value >> 16),
                           enable      => "period_h_wr_strobe",
                          });
    
        $read_mux->add_table("(address == 2)" => "period_l_register",
                             "(address == 3)" => "period_h_register");
     }
  }

  if ($snapshot) {
     if ($counter_size == 64 ) {
        e_assign->adds 
          (["snap_halfword_0_wr_strobe", "chipselect && ~write_n && (address == 6)"],
           ["snap_halfword_1_wr_strobe", "chipselect && ~write_n && (address == 7)"],
           ["snap_halfword_2_wr_strobe", "chipselect && ~write_n && (address == 8)"],
           ["snap_halfword_3_wr_strobe", "chipselect && ~write_n && (address == 9)"],
           ["snap_strobe",      "snap_halfword_0_wr_strobe ||snap_halfword_1_wr_strobe ||snap_halfword_2_wr_strobe ||snap_halfword_3_wr_strobe"    ]);
    
        $read_mux->add_table ("(address == 6)" => 'snap_read_value[15: 0]',
                              "(address == 7)" => 'snap_read_value[31:16]',
                              "(address == 8)" => 'snap_read_value[47:32]',
                              "(address == 9)" => 'snap_read_value[63:48]',
                              );
     } else { 
        e_assign->adds 
          (["snap_l_wr_strobe", "chipselect && ~write_n && (address == 4)"],
           ["snap_h_wr_strobe", "chipselect && ~write_n && (address == 5)"],
           ["snap_strobe",      "snap_l_wr_strobe || snap_h_wr_strobe"    ]);
    
        $read_mux->add_table ("(address == 4)" => 'snap_read_value[15: 0]',
                              "(address == 5)" => 'snap_read_value[31:16]',
                              );
     }
     
     e_register->add({in     => "internal_counter",
                      enable => "snap_strobe",
                      out    => e_signal->add (["counter_snapshot", $counter_bits]),
                     });
   
     e_assign->add([
                    e_signal->add (["snap_read_value", $counter_size]),
                    "counter_snapshot"]);
     
  }

  e_assign->add
      (["control_wr_strobe", "chipselect && ~write_n && (address == 1)"]);

  e_signal->add ({name  => "control_register",
                  width => $control_register_width,
                 });

  e_register->add ({out    => "control_register",
                    in     => 'writedata[control_register.msb : 0]',
                    enable => "control_wr_strobe",
                   });

  $read_mux->add_table("(address == 1)" => "control_register");


  if (!$always_run) {
    e_assign->adds 
      (["stop_strobe",        'writedata[3] && control_wr_strobe'],
       ["start_strobe",       'writedata[2] && control_wr_strobe'],
       ["control_continuous", 'control_register[1]'              ]);
  }
  elsif ($reset_output)
  {
    e_assign->adds 
        (["start_strobe",     'writedata[2] && control_wr_strobe']);
  }

  if ($always_run) {
      # When always_run, the control register is 1 bit wide only 
      e_assign->add(["control_interrupt_enable", 'control_register']);
  } else {
      # Fixes linting error due to mismatch between left/right hand assignments
      e_assign->add(["control_interrupt_enable", 'control_register[0]']);
  }

  e_assign->add
      (["status_wr_strobe", "chipselect && ~write_n && (address == 0)"]);

  $read_mux->add_table
   ("(address == 0)" => &concatenate("counter_is_running","timeout_occurred"));

  return $module;
}

1;
