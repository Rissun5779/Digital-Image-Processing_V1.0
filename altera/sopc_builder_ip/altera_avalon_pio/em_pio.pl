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


#Copyright (C)1991-2002 Altera Corporation
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






################################################################
# Altera Avalon PIO
#
# This module implements a simple parallel input/output port 
# that can be accessed from the CPU's memory bus.
#
# -- REGISTER MAP (all registers are Data_Width wide):
#
#  Name       	   |  Addr.  |  Function
#  ----------------|---------|-------------------------------------------------
#   Data-in    	   | 0 (rd)  | Data value currently on pio inputs (read-only).
#   Data-out   	   | 0 (wr)  | New value to drive on pio outputs (write-only).
#  ----------------|---------|-------------------------------------------------
#   Data Direction | 1 (r/w) | (optional): Individual tristate control for
#                  |         | each port bit.  1=out, 0=in.
#  ----------------|---------|-------------------------------------------------
#   Interrupt Mask | 2 (r/w) | (optional): Per-bit irq enable/disable
#  ----------------|---------|-------------------------------------------------
#   Edge Capture   | 3 (r/w) | (optional): Per-bit edge-capture register.
#  ----------------|---------|-------------------------------------------------
#   Out-clear      | 4 (wr)  | (optional): Per-bit output register clearing
#  ----------------|---------|-------------------------------------------------
#   Out-set        | 5 (wr)  | (optional): Per-bit output register setting
#  ----------------|---------|-------------------------------------------------
#
# By default, the PIO block will have only one internal address
# (Data-in / Data-out).  The other three registers only "pop into existence"
# if the "has_tri" (--> Data Direction), "irq_type"
# (--> Interrupt Mask), or "edge_type" parameters are set.
#
# There are two distinct applications of this module:  One where the
# I/O bits of the parallel port are connected to on-chip devices, and
# the other where the parallel port is connected off-chip.
#
# ** On-chip pio connections
#
#  In this case, there is an associated input register and output register
#  for every bit in the PIO block.  If you write to the output register
#  you set a value on the pio outputs, and if you read from the input
#  register you get the current value from the pio inputs.  The input
#  and output wires are distinct.
#
#  By default, the pio block will have both input and output pins.
#  you can independently control the presence/absence of both
#  inputs and outputs with the two parameters $PIO_INPUT_PINS and
#  $PIO_OUTPUT_PINS, respectively.  These are true/false parameters
#
# ** Off-chip pio connections.
#
# If you so desire, the pio block can have combined inout 
# (bidirectional input/output) pins instead of separate input pins and
# separate output pins.  This means the outputs can *only* go to
# external device pins--it's the only place on an Apex chip where
# physical tri-state structures exist.  If this is what you want,
# then you set the $PIO_TRISTATE_PINS attribute.  In this case,
# the pio register set will also include a data-direction register
# for software control of the output drivers.
#
# If you set the $PIO_TRISTATE_PINS parameter true, then
# this module's in_port and out_port connections will "go away" and
# be replaced by a single n-bit connection named bidir_port. It
# is the caller's (instantiator's) responsibility to connect
# all the individual bits of bidir_port to an I/O port on the top-level
# of the APEX device's design.
#
# --Variable Width
#
# This module can be between 1 and 32 bits wide, giving you
# between 1 and 32 I/Os you can control (that'd be 1..32 inputs and
# 1..32 outputs, if $PIO_TRISTATE_PINS is false).
#
# --Edge Capture
#
# By default, the pio block just lets you read input bit levels.  You 
# may, however, optionally choose an edge-capture function by
# setting the PIO_EDGE_CAPTURE parameter to one of the three
# values "RISING", "FALLING", or "ANY."  If the PIO_EDGE_CAPTURE
# parameter has one of these values, then the pio block will
# include an additional, CPU-readable edge-capture register as
# internal register #3.
#
# Each bit in the edge-capture register is set when the
# requested edge type ("RISING", "FALLING," or "ANY"), is seen 
# on the corresponding input-bit.  Once any bit in the edge-capture
# register is set, it can only be cleared by a -write- operation to the
# edge-capture register.  A write-operation to the edge-capture register
# clears all bits.
#
# The default value for PIO_EDGE_CAPTURE is "NONE," corresponding to
# no edge capture feature and no edge-capture register.
#
#
# --Interrupt Control
#
# By default, the pio block does not generate an interrupt, and has
# no interrupt-control logic or registers.  If you set the 
# $PIO_INTERRUPT parameter to "LEVEL" or "EDGE", then the block will include
# both an irq-pin to the CPU and an internal interrupt-masking register.
# 
# If PIO_INTERRUPT is set to "LEVEL," then the irq output will be driven
# active (1) whenever any given input-bit is true (1), and the 
# corresponding bit in the interrupt-masking register is also true (1).
#
# If PIO_INTERRUPT is set to "EDGE," then the irq output will be driven
# active (1) whenever any given bit in the edge-capture register is true (1)
# and the corresponding bit in the interrupt-masking register is also 
# true (1).  PIO_INTERRUPT may -not- be set to edge unless the 
# PIO_EDGE_CAPTURE parameter is also set to one of the three values
# "RISING," "FALLING," or "ANY."
#
#
# --No output-data read-back.
#
# Many pio-devices like this allow software to read-back the value
# currently sitting in the data-output registers.  This feature, while
# sometimes handy, is not strictly necessary--The software can know,
# after all, what value was written into the pio output register by
# other means (e.g. remembering the value).  An output-register readback 
# feature would prevent unused register bits from being "eaten" (see above), 
# and would increase the hardware complexity of the readback mux. 
# In the name of keeping this device as simple and LE-efficient as possible,
# the output-register read-back feature has been eliminated.
#
# Assumptions:
#
# * The internal registers are presumed to run off the same clock (clk) 
#   as the CPU.
#
# * This is a "normal" peripheral with one-wait-state read access.
#
# * This peripheral is not bytewise-writeable.  A case can be made for
#   a byte-writeable pio, but simplicity is the order of the day.
#
################################################################

use europa_all;
use em_pio;
use strict;

#START:
my $project = e_project->new(@ARGV);

# Make a copy so we don't write-back derived parameter values, etc.
my $Options = &copy_of_hash($project->WSA());
my $SBI     = &copy_of_hash($project->SBI("s1"));

# Add the data-width in with our options (this is something we care about).
# Along with the "Has_IRQ" setting, which we also care about.
#
$Options->{width}   = $Options->{Data_Width};
$Options->{has_irq} = $SBI->{Has_IRQ};

&make_pio ($project->top(), $Options);

$project->output();

# Just one more thing...
# poke the driven testbench value into the ptf file if required
if ($Options->{has_tri} || $Options->{has_in})
{
   my $port = ($Options->{has_in})? "in_port": 
       ($Options->{has_tri})? "bidir_port":
       &ribbit ("bad port selection");
   
   if ($Options->{Do_Test_Bench_Wiring})
   {  
      $project->module_ptf()->{PORT_WIRING}
            {"PORT $port"}{test_bench_value} = eval 
            ($Options->{Driven_Sim_Value});
      $project->ptf_to_file();
   }
   else
   {
      #SPR 198263 : Need to cleanup ptf file if user decide to remove testbench wiring
      if (exists $project->module_ptf()->{PORT_WIRING} {"PORT $port"}{test_bench_value})
      {
            delete $project->module_ptf()->{PORT_WIRING}{"PORT $port"}{test_bench_value};
            $project->ptf_to_file();
      }
   }
}







