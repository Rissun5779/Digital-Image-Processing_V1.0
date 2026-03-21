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


###############################################################
# Optrex 16207 LCD Display Interface.
#
# Provides an ultra-simple interface to a character LCD display 
# module (like the one provided in the Nios dev kit). 
#
# Really, the LCD display unit has two internal 8-bit registers--so it
# would be possible to phrase it as a logic-less "external"
# (instantiate_in_system_module = 0) peripheral that lived out on a
# tri-state bus.  This would, in fact, work--and would require
# somewhat less logic than what is implemented here.  With one major
# disadvantage:  The peripheral would have to assert the wait-signal
# for XX microseconds.
#
#    IT WOULD BE REALLY SLOW.
#
# If your Nios was running at 100MHz, writing a single command to the
# LCD would stall your processor for Y -hundred-
# clock-cycles!  Just touching the stupid LCD display would seriously
# hose your real-time performance.  
#
# So, instead, this peripheral accepts each command from the processor 
# without delay, and then ever-so-slowly performs a write-cycle to the
# hardware itself--during which time your processor has long since
# moved on to other important tasks.  When the painfully-slow
# transaction with the actual LCD unit is complete, this peripheral is
# ready to accept another command from the processor.  It signals its
# readiness by (1) requesting an interrupt and (2) asserting the
# "RDY" bit in the readable STATUS/CONTROL register.  
#
# Note that Interrupts are only generated if the "IE" bit is true in
# the STATUS/CONTROL register.
#
# NOTE: This peripheral currently provides an output-only interface to
# the LCD module, i.e. you can only WRITE data and commands to the LCD
# unit.  It seems electrically possible to READ information from the
# LCD, but it's hard to imagine why this would be useful.  
#
#
# THE REGISTER MAP
# 
#                   7     6     5     4     3     2     1     0      Register #
#                +-----+-----+-----+-----+-----+-----+-----+-----+
# tx_command     |                TX-Command                     |  0
#                +-----+-----+-----+-----+-----+-----+-----+-----+
# tx_data        |                  TX-Data                      |  1
#                +-----+-----+-----+-----+-----+-----+-----+-----+
# Command        |                  --0--                  |  IE |  2
#                +-----+-----+-----+-----+-----+-----+-----+-----+
# Status         |                  --0--                  | RDY |  3
#                +-----+-----+-----+-----+-----+-----+-----+-----+
#
# Any value you write to the TX-Command register is passed-along to the 
# LCD-controller's command register (RS = 0).  Any value you write to the 
# TX-Data register will be passed-along to the LCD-controller's data
# register (RS=1).  Following a write to the TX-Command or TX-Data register,
# the RDY bit will be 0 until the write-transaction with the LCD hardware
# is finished.  When the transaction is finished, RDY <- 1 and 
# an interrupt is generated if IE == 0.  
#
# The TX-Command and TX-Data registers are write-only; reading them
# produces an undefined result.
#
#
# HARDWARE INTERFACE
#
# This module doesn't go through the pretense of a tri-state interface.
# Only output (write) transactions are supported.  The databus is always 
# driven.  The "RW" output is always driven to 1'b0 (--> "write").  
# 
#
################################################################

use europa_all;
use europa_utils;
use strict;


#START:
my $project = e_project->new(@ARGV);

&make_performance_counter ($project->top(), $project);

$project->output();
# DONE!


# Null for now, but you never know what the future will bring.
sub Validate_Options 
{
   my ($Opt, $SBI, $project) = (@_);

   # Compute a divisor that will give our write-pulse width 
   # (100 microseconds)
   #
   $Opt->{counter_load_value} =
    int  (($Options->{clock_freq} * (100.0/1000000.0)) + 0.5);


}


################################################################
# make_lcd_interface
#
#
################################################################
sub overly_complicated_make_lcd_interface
{
   my ($module, $project) = (@_);
   
   my $Opt = &copy_of_hash($project->WSA());
   
   # Extract the system clock-frequency (we need it!)
   $Opt->{clock_freq} = $project->get_module_clock_frequency();

   my $SBI  = $project->SBI("control_slave");
   #&Validate_Options ($Opt, $SBI, $project);

   # mark the new, empty module as the one into which
   # all new "things" should go.  It gets unmarked when this subroutine
   # exits and "$marker" is destroyed.
   #
   my $marker = e_default_module_marker->new($module);

   e_port->adds(# Avalon slave ports:
                ["address",       2,   "in" ],
                ["writedata",     8,   "in" ],
                ["readdata",      8,   "out"],
                ["write",         1,   "in" ],
                ["begintransfer", 1,   "in" ],
                ["irq",           1,   "out"], 

                # LCD hardware interface ports:
                ["LCD_data",      8, "inout"],
                ["LCD_RS",        1,   "out"],
                ["LCD_RW",        1,   "out"],
                ["LCD_E",         1,   "out"],
                );

   # The RW bit is easy--we just always write.
   e_assign->adds (["LCD_RW",   "address[0]"                     ],
                   ["LCD_RS",   "address[1]"                     ],
                   ["LCD_E",    "read | write"                   ],
                   ["LCD_data", "(address[0]) ? 8'bz : writedata"],
                   ["readdata", "LCD_data"                       ],
                   );
}

sub overly_complicated_make_lcd_interface
{
   my ($module, $project) = (@_);
   
   my $Opt = &copy_of_hash($project->WSA());
   
   # Extract the system clock-frequency (we need it!)
   $Opt->{clock_freq} = $project->get_module_clock_frequency();

   my $SBI  = $project->SBI("control_slave");
   &Validate_Options ($Opt, $SBI, $project);

   # mark the new, empty module as the one into which
   # all new "things" should go.  It gets unmarked when this subroutine
   # exits and "$marker" is destroyed.
   #
   my $marker = e_default_module_marker->new($module);

   e_port->adds(# Avalon slave ports:
                ["address",       2,   "in" ],
                ["writedata",     8,   "in" ],
                ["readdata",      8,   "out"],
                ["write",         1,   "in" ],
                ["begintransfer", 1,   "in" ],
                ["irq",           1,   "out"], 

                # LCD hardware interface ports:
                ["LCD_data",      8,   "out"],
                ["LCD_RS",        1,   "out"],
                ["LCD_RW",        1,   "out"],
                ["LCD_E",         1,   "out"],
                );

   # The RW bit is easy--we just always write.
   e_assign->add (["LCD_RW", "0"]);

   e_avalon_slave->add ({name => "control_slave",});  
   e_assign->add (["clk_en", "-1"]);
   my @read_mux_table = ();


   e_assign->adds
       (["write_strobe",        "write & begintransfer"                ],
        # A write to either of the first two registers is an implicit
        # request for a transaction to the LCD.
        ["transaction_request", "(write_strobe                    )&& 
                                 ((address == 0) || (address == 1))   "],
        );

   # Do the boring R/W control register first:
   #
   e_register->add 
       ({out         => e_signal->add(["control_register", 1]),
         in          => "writedata",
         enable      => "(address == 2) && write_strobe ",
         async_value => "1'b0",
         });
   push (@read_mux_table, "(address == 0)",  "control_register");
   e_assign->add ([&concatenate ("IE"), "control_register"]);

   e_assign->add (["irq", "IE & RDY"]);


   # The LCD data register is also pretty easy--if either tx_control
   # or tx_data registers get written, the 8-bit value gets stored 
   # here--and immediately driven-out to the LCD module.
   #
   e_register->add 
       ({out        => "LCD_data", 
         in         => "writedata",
         enable     => "transaction_request",
         });

   # The LCD_RS (Register Select) bit is simple.  It just remebers
   # whether the TX-Control (0) or TX-Data (1) register was the last
   # one written-to:
   #
   e_register->add 
       ({out        => "LCD_RS", 
         sync_reset => "transaction_request && (address == 0)",
         sync_set   => "transaction_request && (address == 1)",
      });

   # The LCD_E bit is the only hard one in the bunch.  For every 
   # transaction, we have to hold E high for XX microseconds--and
   # then, for safety, hold it low for another XX microseconds (only 
   # then do we assert the RDY bit).

   # First, we need a counter.  This counts-off XX microseconds.

   $counter_bits = &Bits_To_Encode ($Opt->{counter_load_value});
   e_register->add 
       ({out     => e_signal->add (["counter", $counter_bits]),
         in      => "counter_input",
         enable  => "counter_enable",
      });

   # Count down whenever not loading.  
   e_assign->add 
       ({lhs => ["counter_input", $counter_bits],
         rhs => "counter_load ? $Opt->{counter_load_value} : counter - 1",
       });

   e_assign->adds 
       (["counter_enable", "counter_load || ~RDY"                 ],
        ["counter_load",   "transaction_request || (counter == 0)"],
        );

   e_register->add 
       ({out        => "LCD_E",
         sync_set   => "transaction_request",
         sync_reset => "(counter == 0) && LCD_E",
         priority   => "set",
      });
       

   # The RDY bit
   # 
   # The minute anyone requests a transaction, we're no longer ready.
   # Only when we've finished cycling the LCD_E-output (XX microseconds 
   # up AND down) are we ready again:
   #
   e_register->add 
       ({out        => e_signal->add(["RDY", 1]),
         sync_reset => "transaction_request",
         sync_set   => "(counter == 0) && ~LCD_E",
         priority   => "reset",
      });

   # The status register--containing (for now) one glorious bit.
   #
   e_assign->add ({lhs => ["status_register, 1"], 
                   rhs => &concatenate ("RDY")
                    });
   push (@read_mux_table, "(address == 3)", "status_register");


   ################
   # The read-mux
   # 
   #  All the important bits were added to the @read_mux list, above.
   #
   e_mux->add ({out   => e_signal->add(["read_mux_out", 32]),
                table => \@read_mux_table,
                type  => "and-or"
               });

  e_register->add ({out => "readdata",
                    in  => "read_mux_out"});
}



