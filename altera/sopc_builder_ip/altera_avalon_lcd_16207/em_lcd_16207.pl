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
# The module itself is accessed via a simple 8-bit data/address bus
# with a R/W_n pin and an E (strobe) pin.  The module only has two 
# internal 8-bit registers, so there's only one address bit, which
# they call "RS" (register-select).
#
# You can -almost- express the LCD interface directly as an avalon tri-state
# slave.  But, in the end, you can't--because of the way the timing
# signals happen to be used (E is the logical-or of the Avalon "read" 
# and "write" signal types).
#
#     NOTE: I -could- have made this as a direct external Avalon 
#           tri-state slave, but this would have required a system-
#           external OR-gate (or-ing "read" and "write" to form "E"). 
#           I considered the requirement of an external OR-gate too
#           untidy.
# 
# So, this module is just a regular Avalon slave that includes--you
# guessed it-- a single OR-gate.  Now you know.
#
# WARNING: This peripheral is declared with MANY wait-states.  A read-
# or write-access will take about 500ns--which can be nearly a hundred
# clock-cycles on a fast Nios II system.  During each access, the
# processor is completely stalled.  You've been warned.
#
#
################################################################

use europa_all;
use europa_utils;
use strict;


#START:
my $project = e_project->new(@ARGV);

&make_lcd_interface ($project->top(), $project);

$project->output();
# DONE!



################################################################
# make_lcd_interface
#
#
################################################################
sub make_lcd_interface
{
   my ($module, $project) = (@_);
   
   my $Opt = &copy_of_hash($project->WSA());
   
   my $SBI  = $project->SBI("control_slave");
   #&Validate_Options ($Opt, $SBI, $project);

   # mark the new, empty module as the one into which
   # all new "things" should go.  It gets unmarked when this subroutine
   # exits and "$marker" is destroyed.
   #
   my $marker = e_default_module_marker->new($module);

   e_port->adds(# Avalon slave ports:
                ["clk",           1,   "in"],
                ["reset_n",       1,   "in"],
                ["address",       2,   "in" ],
                ["writedata",     8,   "in" ],
                ["readdata",      8,   "out"],
                ["write",         1,   "in" ],
                ["begintransfer", 1,   "in" ],

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

   e_avalon_slave->add ({name => "control_slave",});  
}








