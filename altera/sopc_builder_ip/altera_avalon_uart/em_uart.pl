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

###############################################################
# Altera Avalon UART
#
#   (This file also serves as a Europa example / reference design).
#
# **** ABOUT THE UART ****
# 
# The Avalon UART is a relatively-simple, ***--NOT--***
# 16450/16550-compatible serial port.  It may be simple, but it has,
# IMHO, every important feature necessary for software to conveniently
# communicate over a serial port (with the exception of FIFO-buffering,
# which will come later).  A complete document for the Altera Avalon
# UART, its operations, and its register map appear in a glorious
# PDF data sheet which ships with the Nios development kit.  I
# strongly advise you to read the entire data sheet before proceeding.
#
# UART Structure:
#
# The top-level UART module is just a wrapper which instantiates the
# three functional sub-modules:  The transmitter, the receiver, and
# the control registers.  As you would expect, the main functional
# element in both the transmitter and receiver is a shift-register.
# As you might not expect, both the transmitter and reciever have
# their own, separate baud-rate counters.  This is because the tx- and
# rx-data are totally asynchronous, and may have a completely
# different phase.  It is also true, though somewhat of a secret, that
# this UART includes a resynch-on-edge feature in its rx-logic.
#
# UART Parameters:
#
# The UART is constructed based on several parameters which this
# script dredges-up out of the system PTF file (we find the PTF-file,
# and identify the relevant section, by inspecting the command-line
# arguments to this program, described below).  Here are the PTF-parameters 
# and their default values:
#
#        WIZARD_SCRIPT_ARGUMENTS 
#        {
#           baud             = "115200";
#           data_bits        = "8";
#           fixed_baud       = "1";
#           parity           = "N";
#           stop_bits        = "2";
#           use_cts_rts      = "0";
#           use_eop_register = "0"
#           clock_freq       = "33333000";    # No default.  
#        }
#
# This script reads and validates these parameters to be sure the
# required ones exist, that they are within-range, etc.
# 
#
# Major Option: Fixed/Writeable Baud Rate.
#
# Sometimes you just want your UART to have, and always have, a
# certain baud-rate (115,200, for example).  Other times, you may want
# to change the baud-rate around using software.  This UART lets you
# have it either way--the PTF-parameter "fixed_baud" determines which.
# If fixed_baud="1" then the internal baud-rate counter is loaded from
# a hard-wired constant, and there's nothing software can do about
# it (this is often a good thing).   This script is clever-enough to
# make the counter only as big (number of bits) as it needs to be to
# implement the specified divisor.  The divisor-constant value is
# determined, using arithmetic, from the "baud" and "clock_freq"
# parameters.
#
# If fixed_baud="0", then the UART will include a 16-bit baud-divisor
# register.  Software may write any 16-bit value in this register that
# it likes.  The register's reset-value will be the same
# divisor-constant computed for the fixed-baud case.
#
# Major Option: CTS/RTS support
#
# If you so specify (use_cts_rts="1"), the UART will include CTS
# (input) and RTS (output) pins, and associated control/status bits
# for reading/driving them.  Note that these signals have -absolutely
# no effect- on the reciever- or transmitter-operation.  This may
# strike you as lame, but that's the way every other UART in the
# world works, and who am I to go against tradition.  In effect,
# CTS and RTS are just two PIO bits for the amusement of software.
# Software could, for example, stop sending characters if it noticed
# that CTS was false--but that's up to the software.  The UART
# hardware has no opinion.  If you ask for CTS/RTS support, the UART
# will "sprout" the extra pins and implement the associated register 
# bits.
#
# **** EUROPA ****
#
# What Europa Is:
#
# "Europa" is a Perl object library.  The objects are "things" which
# correspond to familiar HDL constructs:  continuous assignments,
# sequential statements, ports, instances, modules, etc.  If you are
# familiar with any HDL (Verilog, VHDL, etc), and you have some
# experience with Perl, then you have all the required background to
# create logic designs using Europa.
#
# But why?  Why not just create my logic in Verilog?  There are three
# cardinal advantages of Europa, which I will list ordinally:
#
#   1) Heavy parameterization, through access to the full power of Perl.
#
#   2) Plumbing.  Ports and wires are automatically and intelligently
#      generated and connected to one another, automatically
#      "bubbled-up" through the module hierarchy, etc.
#
#   3) Verilog/VHDL agnosticism.  When you're done coding your design
#      in Europa, you can "print" it as either Verilog or VHDL.  In
#      the future, you will be able to "print" it as C so that you 
#      can emulate your logic on your Windows desktop (!).
#
#
# Some other (not-yet-existing) document will describe all the
# ins-and-outs of every Europa class.  
#
# Europa Basics--Named Arguments:
#
# One feature which is used -heavily- throughout Europa is 
# -named arguments-.  This is the practice of calling a function with 
# a hash instead of a list.  This may seem like foolish pedantry, and
# perhaps it is.  But it is also glorious.  Named arguments confer the
# following three advantages:
#
#     1) The poor programmer doesn't have to remember argument-order.
#     2) It's easy/possible to support default-values for arguments.
#     3) The code practically documents itself!
#
# Allow me to demonstrate.  Suppose I wanted to create an "e_register"
# object (some kind of flip-flop).  Suppose I called its constructor
# ("new()" method) like this:
#
#     my $thing = e_register->new ($module, "tx_ready", "do_load"shifter",
#                                  "tx_wr_strobe_onset", "1'b1");
#
# You would probably have no idea what was going on.  The "e_register"
# constructor can (optionally) take a zillion different arguments, as
# it must: there are a zillion different kinds of registers you can
# make.  What to do?  How about this:
#
#     my $thing =    e_register->new ({
#                          within      => $module,
#                          out         => e_port->add (["tx_ready", 1, "out"]),
#                          sync_set    => "do_load_shifter",
#                          sync_reset  => "tx_wr_strobe_onset",
#                          async_value => "1'b1",
#                       });
#
# Much clearer, no?  Just for completeness, I'll tell you what this
# means in English:
#
#     Please build me a new e_register object.  I would like it to
#     reside within the e_module object given by $module.
#     I would like the register's output connected to a one-bit output
#     port (which I am creating on the spot) named "tx_ready".  I 
#     would like this to be a synchronous S/R-flip-flop.  Please
#     connect the synchronous-set input to a signal named "do_load_shifter".
#     Please connect the synchronous-reset input to a singal named 
#     "tx_wr_strobe_onset".  Since I haven't otherwise specified,
#     the register will have a clock-signal named "clk" and an active-low
#     asynchronous-reset input named "reset_n".  I would like to
#     explicitly state that the reset-value of this register is "1".
#
# Well, there you have it.  You can see that the named-argument
# convention reads something like English, once you get the hang of
# it.  I suggest you get the hang of it.
#
# Virtually every function-of-interest in the Europa library takes
# named-arguments.  The curly-braces in the example above are the Perl 
# syntax for creating an "anonymous" hash which gets passed to the
# function by reference.  To you, the user, this means you will tend
# to rituallistically call functions like this:
#
#   func ({arg_name_1 => arg_value_1,
#          arg_name_2 => arg_value_2,
#            ...
#        });
#
# This whole named-argument business is niether new nor unique to
# Europa.  Savvy Perl-programmers (esp. CGI programmers) have been
# doing this for years.  We just make heavy use of it throughout the library.
#
#
# Europa Basics--Constructors:
#
# Building a block of logic using Europa is, mostly, a construction
# process.  You -create-, one-by-one, the elements of your design: 
# combinatorial logic, seqential logic, registers, instances, and
# modules.  In an object-oriented world, you "create" things by
# calling their constructors.  By convention, Perl objects are
# constructed by a class-method named "new".  Eurpoa objects are all 
# based on the common primordial Europa ancestor "e_object".  The 
# e_object->add() method, and all derived methods, are most frequently
# called with a hash of named arguments (see above).  The names of all
# the arguments are (in general) the names of the various fields in
# the object.  Thus, you can create a new object and initialize all
# its vital bits in one fell swoop.  That's how it's usually done.
# 
# Also, by dint of the way e_objects are implemented, every data-field
# of any e_object will have an associated access-method, which can
# either set the field (when called with argument(s)) or read the
# field (when called with no arguments).  It is generally considered
# polite to use an object's access-methods to set/read internal field
# values.
#
# Europa Basics--Module Contents:
#
# It's all well-and-good to go around creating a bunch of e_objects,
# but what happens to them?  Well...nothing.  Unless, of course, you
# add all your happy e_objects to (at least one) e_module.
#
# Let's start from the top:  Ultimately, the point of Europa is to get
# your design "printed" in a format that can be read by another tool
# (Synthesis, simulation, whatever).   To this end, the fundamental
# agent-of-action is an "e_project" object.  At the highest level,
# Europa works like this:  You create an "e_project" object, you fill
# it up with goop, and then you print ("e_project->output()") it.
# That's it.
#
# For the purpose of this discussion, the "goop" you put in an
# e_project is, of course, a bunch of e_module objects, with one
# particular e_module designated as the "top" module (all of this
# should be very familiar to HDL coders).  "e_module" objects, of
# course, correspond to the conventional HDL notion of
# "modules"--things with ports and contents, which can be instantiated
# within other "modules" to build hierarchical designs.
#
# Most of your time in Europa is spent creating e_module objects and
# filling them up with contents.  There are two happy ways to add
# contents to an e_module:
# 
#    1) use the e_module->add_contents() method.
#       (you pass in a list of e_objects you've created).
#
#    2) Every time you create an e_object, you specify which 
#       e_module it lives in using the "within" field.
#
# Let me show you an example of method (2):
#
#    e_assign->add ({within => $my_happy_module_under_construction,
#                    lhs    => "shift_done",
#                    rhs    => "~(|tx_shift_register_contents)",
#                   });
#
# This creates a new e_assign-object (a "continuous assignment", aka
# combinatorial logic), and places it inside the e_module object
# $my_happy_module_under_construction.  By creating a variety of such 
# objects, one could construct an e_module which served a useful
# purpose.
#
################################################################

use e_std_synchronizer;
use filename_utils;  # This is for to Perlcopy 'uart.pl'
use europa_all;      # This imports the entire Eurpoa object-library.
use strict;          # This spanks you when you're naughty.  That's
                     #   -very- good.

################################################################
# Europa Process:
#
#   1) Create an "e_project" object from our command-line arguments
#   2) Build the uart logic, using the project as a source.
#   3) "Output" the project (dump HDL, update PTF file).
#
################################################################

# Step 1:
my $project = e_project->new(@ARGV);
# Step 2:
&make_uart ($project);
# Step 3:
$project->output() unless $project->_software_only();


################################################################
################        D O N E                 ################ 
################################################################


################################################################
# Validate_Uart_Options
#
# Given a hash (ref) of UART compile-time options taken from 
# the PTF-file, verify that they are safe-and-sane.
#
# This function also computes some derived values (e.g. divisor_bits)
# and shoves them into the $UART_Options hash as-if they were
# ordinary parameters.
#
#################################################################
sub Validate_Uart_Options
{
  my ($Options, $project) = (@_);
  
  # Parameter: fixed_baud
  # Section:   MODULE/WSA
  # Type:      Boolean     (1 or 0).
  # Default:   0
  # 
  # When fixed_baud = 1, the UART is implemented using a constant
  # (unchangable) baud-divisor.  Thus, UARTs constructed with 
  # fixed_baud=1 will always run at the same baud-rate, given by 
  # the "baud" assignment (see below).  When fixed_baud=1, the hard-coded
  # baud divisor value is computed accordig to the following formula:
  #
  #     divisor = int ((system-clock-frequency / baud) + 0.5)
  # 
  # The SYSTEM/WIZARD_SCRIPT_ARGUMENTS/clock_freq assignment is used 
  # to determine the clock frequency.  When fixed_baud=1, software cannot
  # change the UART's baud rate, and the UART will -not- implement
  # a DIVISOR register at address offset 4.  When fixed_baud=1, writing to 
  # address offset 4 will have no effect, and reading from address offset
  # 4 will produce an undefined result.
  #
  # When fixed_baud=0, the UART will include a 16-bit DIVISOR register 
  # (address offset 4).  The value in the DIVISOR register determines the 
  # baud rate according to the following formula:
  #
  #    baud-rate = system-clock-frequency / (DIVISOR + 1)
  #
  # Software can write the DIVISOR register to any 16-bit value, which is 
  # treated as an unsigned integer.  At reset, the DIVISOR register is 
  # initialized to a value which depends on the "baud" assignment, according
  # to the following formula:
  # 
  #    DIVISOR reset-value = int (system-clock-frequency / baud) + 0.5)
  #
  # Thus, when fixed_baud=0, the baud-rate of the UART is determined by 
  # the "baud" assigment, until and unless software writes a different 
  # value into the DIVISOR register.  
  # 
  &validate_parameter ({hash    => $Options,
                        name    => "fixed_baud",
                        type    => "boolean",
                        default => 1,
                       });

  # Parameter: use_cts_rts
  # Section:   MODULE/WSA
  # Type:      Boolean     (1 or 0).
  # Default:   0
  # 
  # When use_cts_rts=1, the UART will include:
  #    -- a  cts_n (logic-negative CTS) input pin, 
  #    -- an rts_n (logic-negative RTS) output-pin, 
  #    -- a CTS bit in the STAUTS register.
  #    -- a dCTS bit in the STAUTS register.
  #    -- an RTS bit in the CONTROL register.
  #    -- an idCTS bit in the CONTROL register.
  #
  # When use_cts_rts=1, software can detect CTS, and transmit RTS flow-
  # control signals.  The cts-input and rts-output pins are entirely 
  # under the control of software, and have no direct effect on any 
  # other part of the UART hardware (other than the associated control
  # and status bits).  
  #
  # When use_cts_rts=0, the UART does -not- include cts_n and rts_n
  # pins, and the CTS, dCTS, idCTS, and RTS CONTROL/STATUS bits are 
  # unimplemented (always read as 0).  
  # 
  # These bits WILL appear in the CONTROL/STATUS register regardless of
  # use_cts_rts setting, if the use_eop_register setting is on, so the
  # bit position of eop shows up in the correct place.
  &validate_parameter ({hash    => $Options,
                        name    => "use_cts_rts",
                        type    => "boolean",
                        default => 0,
                       });

  # Parameter: use_eop_register
  # Section:   MODULE/WSA
  # Type:      Boolean   (1 or 0)
  # Default:   0
  #
  # When use_eop_register=1, the UART will include:
  #   -- an 7, 8, or 9-bit EOPchar register at address-offset 5.
  #       (size given by "data_bits" assignment).
  #   -- an EOP bit in the STATUS register.
  #   -- an iEOP bit in the CONTROL register.
  #   -- an "endofpacket" signal on its Avalon bus interface
  #        (not exported as a system-level optuput).
  # 
  # When use_eop_register=1, the UART can be programmed to automatically
  # terminate streaming data transactions when used with a 
  # streaiming-capable Avalon master (e.g. a DMA controller).  
  # The eop-detection feature can be used in combination with a DMA, for 
  # example, to implement a UART which automatically fills a buffer
  # until a specified character is encountered in the incoming RxData 
  # or TxData stream.  The value of the terminating (end-of-packet) character
  # is taken from the EOPchar register.
  # 
  # When use_eop_register=0, the UART does not includes neither an EOPchar
  # register nor an "endofpacket" Avalon interface signal nor an EOP bit in
  # the STATUS register nor an iEOP bit in the CONTROL register.  When 
  # use_eop_register=0, writing to address offset 5 has no effect, and 
  # reading from address offset 5 produces an undefined result.
  #
  # Data Sheet and excalibur.h say this bit is constrained to show up as
  # bit-12 of the CONTROL & STATUS registers.  It will appear in that
  # position, even if use_cts_rts=0, due to some legacy simplification code.
  &validate_parameter ({hash    => $Options,
                        name    => "use_eop_register",
                        type    => "boolean",
                        default => 0,
                       });


  # Parameter:      data_bits
  # Section:        MODULE/WSA
  # Type:           integer
  # Allowed Values: 7, 8, 9
  # Default:        8
  #
  # The UART can be constructed to transmit and recieve 7, 8, or 9-bit
  # data values, as-determined by the value of data_bits.  Note that the 
  # TxData, RxData, and EOPchar registers' widths are all determined
  # by the data_bits assignment.  
  # 
  &validate_parameter ({hash      => $Options,
                        name      => "data_bits",
                        type      => "integer",
                        allowed   => [7, 8, 9],
                        default   => 8,
                       });

  # Parameter:      stop_bits
  # Section:        MODULE/WSA
  # Type:           integer
  # Allowed Values: 1,2
  # Default:        2
  #
  # The UART can be constructed to transmit either 1 or 2 stop-bits
  # with every character, as-determined by this assignment.  The 
  # UART will always terminate a recieve-transaction at the first stop bit, 
  # and ignore all subsequent stop bits, regardless of the value of this
  # assignment.
  #
  &validate_parameter ({hash      => $Options,
                        name      => "stop_bits",
                        type      => "integer",
                        allowed   => [1, 2],
                        default   => 2,
                       });

  # Parameter:      parity
  # Section:        MODULE/WSA
  # Type:           string
  # Allowed Values: "N", "E", "O", "S0" "S1"
  # Default:        "N"
  #
  # When parity="N", the UART transmit-logic sends data without including
  # a parity bit, and the uart recieve-logic presumes that the incoming
  # data does not include a parity-bit.  When parity="N", the PE bit
  # in the status register is unimplemented (always reads 0).
  #
  # For all other values of  "parity", the UART transmit-logic 
  # computes and inserts the required  parity bit into the outoging 
  # TxD bitstream, and the UART recieve-logic checks the incoming parity bit 
  # in the RxD bitstream.  If the reciever finds data with incorrect 
  # parity, the PE bit in the STATUS register is checked, and an interrupt
  # will be asserted if the corresponding mask-bit in the CONTROL register
  # (iPE) is enabled.  
  #
  # The outgoing parity-bit inserted into the TxD stream, and the
  # expected correct value of the recieved parity bit, is given by 
  # the following formuae for each setting of the "parity" assignment:
  #
  #    E  parity-bit = 0 if TxData has an even number of 1-bits, 0 otherwise.  
  #       This ensures that the parity of the total package 
  #        (excluding start and stop bits) is always even.
  #
  #    O  parity-bit = 0 if TxData has an odd  number of 1-bits, 0 otherwise.
  #       This ensures that the parity of the total package 
  #        (excluding start and stop bits) is always odd.
  #  
  #    S0 parity-bit always 0.
  #    S1 parity-bit always 1.
  # 
  &validate_parameter ({hash      => $Options,
                        name      => "parity",
                        type      => "string",
                        allowed   => ["S0", "S1", "E", "O", "N"],
                        default   => "N",
                       });

  # Parameter:      sync_reg_depth
  # Section:        MODULE/WSA
  # Type:           integer
  # Allowed Values: 2, 3, 4, 5
  # Default:        2
  #
  # The UART synchronizer stages setting is to ensure UART is metastable safe.
  # Default value is 2, but requires higher depth for 40nm device families.
  # 
  &validate_parameter ({hash      => $Options,
                        name      => "sync_reg_depth",
                        type      => "integer",
                        allowed   => [2, 3, 4, 5],
                        default   => 2,
                        message   => "invalid synchronizer depth", 
                       });

  # Parameter:      baud
  # Section:        MODULE/WSA
  # Type:           integer
  # Allowed Values: [clock-frequency/65536 .. clock-frequency/2]
  # Default:        115200
  #
  # When fixed_baud=1, the "baud" assignment determines the baud-rate
  # of the UART.  When fixed_baud=0, the "baud" assignment is used to compute
  # the initial (reset) value of the DIVISOR register.  Formulae for computing
  # the resultant divisor-constant is given, above, in the description of the 
  # fixed_baud assignment.
  # 
  &validate_parameter ({hash      => $Options,
                        name      => "baud",
                        type      => "integer",
                        allowed   => [   300,
                                        1200,
                                        2400,
                                        4800,
                                        9600,
                                       14400,
                                       19200,
                                       28800,
                                       31250,
                                       38400,
                                       57600,
                                      115200,],
                        default  =>   115200,
                        severity => "warning",
                       });

  &validate_parameter ({hash      => $Options,
                        name      => "baud",
                        type      => "integer",
                       });

  &validate_parameter ({hash      => $Options,
                        name      => "clock_freq",
                        type      => "integer",
                       });

  # Parameter:      sim_true_baud
  # Section:        MODULE/WSA
  # Type:           Boolean    (1 or 0)
  # Default:        0
  #
  # When the UART logic is generated, a simulation model is also 
  # constructed.  when sim_true_baud=1, the UART simulation will
  # faithfully model the transmit- and recieve baud-divisor logic.
  # This often leads to inconveniently-long simulation run-times,
  # since serial transmission-rates are often many orders of magnitude
  # slower than any other process in the system.  Accurately 
  # modeling the UART's divisor logic is seldom useful and always
  # costly.  
  # 
  # when sim_true_baud=0, the simulated UART's baud-divisor is 
  # overridden by the fixed value "4."  Note that this assignment 
  # only affects the simulation model--the generated UART logic -per-se-
  # is not changed.  The smaller baud-divisor tends to greatly accelerate
  # simulation run-times with little loss of authenticity in the simulated 
  # system results.   When fixed_baud=0 and sim_true_baud=0, the 
  # software-writable DIVISOR register is included in the simulation model,
  # but its initial (reset) value will be '4' instead of the actual
  # (non-simulation) value determined by the "baud" assignment.
  #
  &validate_parameter ({hash      => $Options,
                        name      => "sim_true_baud",
                        type      => "boolean",
                        default   => "0",
                       });

  ################
  # Derived parameters.
  #
  $Options->{baud_divisor_constant} =
    int ( ($Options->{clock_freq} / $Options->{baud}) + 0.5);

  $Options->{divisor_bits} = 
      &Bits_To_Encode ($Options->{baud_divisor_constant});

  # Widen-out baud divisor to full 16-bits if software-writeable:
  if (!$Options->{fixed_baud}) {
    $Options->{divisor_bits} = max ($Options->{divisor_bits}, 16);
  }

  &validate_parameter ({hash    => $Options,
                        name    => "divisor_bits",
                        type    => "integer",
                        range   => [1,16],
                        message => "cannot make desired baud rate from clock",
                       });

  $Options->{num_control_reg_bits} =
    ($Options->{use_cts_rts} | $Options->{use_eop_register}) ? 13 : 10 ;

  # There are always 13 status bits. If CTS/RTS is not supported, then
  # the associated bits always read as zero.  Likewise for EOP
  # 
  #
  $Options->{num_status_reg_bits} = 13;

  ################
  # Print out a courtesy message about accuracy:
  #

  return 1;
}

################################################################
# Setup_Input_Stream
#
# For simulation, you can specify an input character-stream,
# which we pretend is arriving on the RXD-pin of the 
# UART.  You can either specify it directly in the ptf-file
# (by setting "sim_char_stream"), or you can specify 
# a file which contains the character stream ("sim_char_file").
# But you can't specify both--and we check.
#
# Either way, the bunch of characters you provide has to be
# "processed" for simulation.  Specifically, we need to convert
# it to a Verilog ".dat" file in its nasty ASCII-binary format.
#
################################################################
sub Setup_Input_Stream
{
  my ($Options, $project) = (@_);

  if (($Options->{sim_char_file}   ne "") && 
      ($Options->{sim_char_stream} ne "")) {
    &ribbit
      ("Cannot set 'sim_char_stream' parameter when using 'sim_char_file'");
  }

  my $char_stream = $Options->{sim_char_stream};

  if ($Options->{sim_char_file} ne "") {
    $char_stream = "";
    open (CHARFILE, "< $Options->{sim_char_file}")
      or &ribbit ("Cannot open input-file $Options->{sim_char_file} ($!)");
    while (<CHARFILE>) {
      $char_stream .= $_;
    }
    close CHARFILE;
  }

  # Allow certain backslash-escapes for 'funny' characters.
  # for now, we limit ourselves to "\n" and "\r" and "\"" for 
  # newline, carriage-return, and double-quote, respectively.
  my $newline      = "\n";
  my $cr           = "\n";
  my $double_quote = "\"";
  
  # First, convert any \n\r sequences into \n.  If by "\n\r" you meant
  # two carriage returns, you lose.
  $char_stream =~ s/\\n\\r/\n/sg;
  
  $char_stream     =~ s/\\n/$newline/sg;
  $char_stream     =~ s/\\r/$cr/sg;
  $char_stream     =~ s/\\\"/$double_quote/sg;
  # Now substitute CRLF-pairs for lone newline-chars, because GERMS likes it.
  my $crlf = "\n\r";
  $char_stream =~ s/\n/$crlf/smg;

  $Options->{stream_length} = length ($char_stream);
  
  $Options->{char_data_file} = $Options->{name} . "_input_data_stream.dat";
  $Options->{char_mutex_file} = $Options->{name} . "_input_data_mutex.dat";

  my $sim_dir_name = $project->simulation_directory();
  &Create_Dir_If_Needed($sim_dir_name);

  open (DATFILE, "> $sim_dir_name/$Options->{char_data_file}") 
    or &ribbit ("couldn't open $sim_dir_name/$Options->{char_data_file} ($!)");

  my $addr = 0;
  foreach my $char (split (//, $char_stream)) {
    printf DATFILE "\@%X\n", $addr; 
    printf DATFILE "%X\n", ord($char);
    $addr++;
  }
  # Add null-terminator so q output is stable and '0x0' if address is overrun.
  printf DATFILE "\@%X\n", $addr;
  printf DATFILE "%X\n", 0;

  close DATFILE;

  open (MUTFILE, "> $sim_dir_name/$Options->{char_mutex_file}") 
   or &ribbit ("couldn't open $sim_dir_name/$Options->{char_mutex_file} ($!)");
  
  # addr of terminal null is known unsafe in e_drom via this
  if ($Options->{interactive_in})
  { # force user to use interactive window if selected by making mutex 0
      printf MUTFILE "0\n";
  }
  else
  { # set up proper stream file size in Mutex:
      printf MUTFILE "%X\n", $addr;
  }

  close MUTFILE;
  $Options->{mutex_file_size} = $addr;
}

################################################################
# make_uart
#
# A subroutine which returns an e_module object.  The returned
# object implements the entire UART which is, itself, a composite
# module.
#
# This function takes four arguments:
#   1) an empty e_module-object which we fill-up with a working UART.
#   2) A (reference to) a hash which holds the contents of the PTF WSA section.
#   3) A clock-frequency.
#
# The astute observer will note that this function doesn't do 
# much in the way of UART-construction.  Indeed not--it just
# delegates the construction to three other functions, each of which 
# creates one of the UART's internal pieces.
#
# A UART consists of three basic blocks:
#   * The RX-machinery.
#   * The TX-machinery.
#   * The Control Registers.
#
# Note that we never declare the ports on the top-level UART module.
# this is because we rely entirely on Europa's port-bubbling 
# mechanism.  Each sub-unit is (inevitably) constructed with a bunch
# of input- and output-ports.  When we instantiate the three
# sub-units, ports with like-names will be connected together.
# All "dangling" (undriven) inputs and all "dangling" (unused) outputs
# will be promoted to ports on the top-level UART module (the module
# we construct here).  As it happens, that simple rule is entirely
# sufficient to build all the ports on this module.  Golly.
#
################################################################
sub make_uart
{
  my ($project) = (@_);

  my $module  = $project->top();
  my $Options = &copy_of_hash ($project->WSA());

  # Poke my name and clock-frequency into the $Options hash, just
  # to keep everything together (very sugary):
  #
  $Options->{name}       = $module->name();
  my $clock_freq = $project->get_module_clock_frequency();
  $clock_freq || &ribbit ("Couldn't find Clock frequency\n");
  $Options->{clock_freq} = $clock_freq;

  # poke interactive features into options hash to make it even sweeter:
  my $int_in_section = 
$project->spaceless_module_ptf($Options->{name})->{SIMULATION}{INTERACTIVE_IN};
  my $int_out_section=
$project->spaceless_module_ptf($Options->{name})->{SIMULATION}{INTERACTIVE_OUT};
  my $interactive_in = 0; # default to non-interactive mode.
  my $interactive_out= 0;

  my $int_key;
  my $this_int_section;
  ## use foreach loop to avoid knowing the name of the INTERACTIVE section:
  foreach $int_key (sort(keys (%{$int_in_section}))) {
      $this_int_section = $int_in_section->{$int_key};
      $interactive_in = $this_int_section->{enable};
      # print "$Options->{name}: key = $int_key, enable = $interactive_in\n";
  }

  ## use foreach loop to avoid knowing the name of the INTERACTIVE section:
  foreach $int_key (sort(keys (%{$int_out_section}))) {
      $this_int_section = $int_out_section->{$int_key};
      $interactive_out = $this_int_section->{enable};
      # print "$Options->{name}: key = $int_key, enable = $interactive_out\n";
  }

  $Options->{interactive_in} = $interactive_in;
  $Options->{interactive_out}= $interactive_out;

  &Validate_Uart_Options ($Options, $project);

  ################
  # Go open-up the character-stream input, if any:
  #
  &Setup_Input_Stream ($Options, $project);
  

  # If this generator-program is being run in software-only mode,
  # then all we wanted to do was regenerate the input-stream,
  # which we just did.  Game over.
  return if $project->_software_only();

  # Make all my sub-modules first.  Trust me:  it's a 
  # good idea to have only one module under construction at a time:
  # Create sub-modules with similar names by calling 
  # subroutines with similar names after setting parameters 
  # with similar names.  How similar.
  #
  $Options->{tx_module_name}  = $Options->{name} . "_tx";
  $Options->{rx_module_name}  = $Options->{name} . "_rx";
  $Options->{reg_module_name} = $Options->{name} . "_regs";
  $Options->{log_module_name} = $Options->{name} . "_log";

  my $tx_module  = &make_uart_tx  ($Options);
  my $rx_module  = &make_uart_rx  ($Options);
  my $reg_module = &make_uart_regs($Options);
  my $log_instance = &make_uart_log ($Options);

  # Mark the uart as the "current" module, so that all subsequently-created
  # stuff will, by default, be added to this module (otherwise, you'd
  # have to explicitly call "add_contents()" every time you made
  # anything).
  #
  my $marker = e_default_module_marker->new ($module);
  $module->add_attribute (altera_attribute => "-name SYNCHRONIZER_IDENTIFICATION OFF");

  # Most of the registers in a UART are -always- clock-enabled.
  #
  # By just setting "clk_en = 1" in this module,
  # we relieve all sub-modules of needing to explicitly
  # neutering their disable-signals.
  #
  e_assign->add(["clk_en", 1]);

  e_instance->add ({module => $tx_module });
  e_instance->add ({module => $rx_module });
  e_instance->add ({module => $reg_module});

  $module->add_contents ( $log_instance );

  # Oh, by the way, copy 'uart.pl' to sim directory in case somebody
  # wants to use the interactive input features:
  if ($Options->{interactive_in})
  {
      &Perlcopy ($project->_module_lib_dir . "/uart.pl",
		 $project->simulation_directory () . "/uart.pl" );
  }

  # Copy perl version of 'tail' if interactive out is selected.
  if ($Options->{interactive_out})
  {
      &Perlcopy ($project->_module_lib_dir . "/tail-f.pl",
                 $project->simulation_directory () . "/tail-f.pl" );
  }
  
  #
  # This object is a "flag" that declares an avalon slave-port on this
  # module (for subsequent discovery by the SOPC-builder).  We don't
  # need to tell it about our ports because we've "played ball" and
  # given all our avalon slave-ports the default happy names (e.g. our
  # address-type port is named "address" and our readdata-type port is
  # named "readdata").  If our ports had funny names, then we'd need to
  # pass-in a "type_map" argument to this constructor.  But we didn't,
  # so we don't.

  e_avalon_slave->add ({name => "s1"});

  return $module;
}

################################################################
# make_uart_log
#
# A subroutine which returns an e_instance!  The instance has only
# inputs so that it can send ascii coded 8-bit data to a log file.
################################################################
sub make_uart_log {
    my ($Options) = (@_);
    return e_log->new ({
	name            => $Options->{"log_module_name"},
	tag             => "simulation",
	relativepath    => $Options->{"relativepath"},
	port_map        => {
	    "valid"	=> "~tx_ready",
	    "strobe"	=> "tx_wr_strobe",
	    "data"	=> "tx_data",
	    "log_file"	=> $Options->{log_file},
	},
    });
    
};

sub make_uart_tx
{
  my ($Options) = (@_);

  # Make empty module, then add contents:
  my $module = e_module->new ({name  => $Options->{tx_module_name}});
  my $marker = e_default_module_marker->new ($module);

  ################
  # Write-strobe conditioning.
  #
  # It is possible that the CPU will assert tx_wr_strobe for more
  # than one cycle (wait states, etc.)   It's safest and most
  # rigorous if we only respond to the  -onset-
  # of the write-strobe (instead of for the -duration- of the read-strobe).
  # The onset is easy enough to detect:
  e_assign->add (["tx_wr_strobe_onset",  "tx_wr_strobe && begintransfer"]),

  # The parity bit comes from one of several sources, depending on 
  # the type of parity the user has selected.  The user's selection
  # determines the source of the "correct" parity bit.
  my $parity_expr = "";
     $parity_expr = "1'b0"        if ($Options->{parity} =~ /^S0$/i);
     $parity_expr = "1'b1"        if ($Options->{parity} =~ /^S1$/i);
     $parity_expr = "  ^tx_data " if ($Options->{parity} =~ /^E$/i );
     $parity_expr = "~(^tx_data)" if ($Options->{parity} =~ /^O$/i );

  # compute how many bits in the transmitter:
  my $tx_shift_bits = 
    ($Options->{stop_bits}             )  +   # stop bits.
    ($Options->{parity} =~ /N/i ? 0 : 1)  +   # parity bit (opt.)
    ($Options->{data_bits}             )  +   # "payload"
    (1                                 )  ;   # start-bit

  # It's important to say how wide tx_data is:
  e_signal->add(["tx_data", $Options->{data_bits}]);

  my $load_val_expr = &concatenate ("\{$Options->{stop_bits} \{1'b1\}\}",
                                    $parity_expr,
                                    "tx_data",
                                    "1'b0",
                                   );

  e_assign->add ({lhs => e_signal->add (["tx_load_val", $tx_shift_bits]),
                  rhs => $load_val_expr,
  });

  ################
  # When to load?
  #
  # Load the shifter when there's a character waiting in the
  # Transmitter-buffer register (i.e. when tx_ready is 0), and
  # when the shifter is empty.  It's OK to lose a micro-cycle or
  # two here and there, so I'm going to put a delay on this
  # computation just to keep all the resutls neat and glitch-free:
  #
  e_assign->add (["shift_done", "~(|tx_shift_register_contents)"]);

  e_register->add ({out => "do_load_shifter",
                     in  => "(~tx_ready) && shift_done",
                    });


  # tx_ready bit:  set by transfer of data into shifter.
  # cleared by arrival of new character.
  #
  # For now, I make the simplifying assumption that the incoming
  # write-strobe is synchronous (UART running on processor-bus clock).
  #
  # Note that we actually do want the UART to start up "ready" on 
  # reset.  This eliminates the start-up blip observed with older
  # versions of this UART.
  e_register->add ({
    out         => e_port->add (["tx_ready", 1, "out"]),
    sync_set    => "do_load_shifter",
    sync_reset  => "tx_wr_strobe_onset",
    async_value => "1'b1",
  });

  # We cry "Overrun!" when the host writes a new character, but the 
  # transmitter is not yet tx_ready.
  #
  e_register->add ({
    out        => "tx_overrun",
    sync_set   => "(~tx_ready && tx_wr_strobe_onset)",
    sync_reset => "status_wr_strobe",
  });

  e_register->add ({
    out         => "tx_shift_empty",
    in          => "tx_ready && shift_done",
    async_value => "1'b1",
  });

  ################
  # Baud-rate generator.
  # 
  # The transmit-block has its very-own baud-rate
  # counter.  I do this because a Baud-rate counter is not 
  # actually very big (100MHz --> 19,200 only requires 12 bits).
  # Also, the transmit phase wants to be independent of the receive
  # phase.
  #
  # If you're simulating, then the baud-rate divisor is arbitrarily set
  # to two.
  # 
  e_register->add ({
      out        => e_signal->add({name  => "baud_rate_counter",
                                   width => $Options->{divisor_bits}
                                  }),
      in         => "baud_rate_counter - 1",
      sync_set   => "baud_rate_counter_is_zero || do_load_shifter",
      set_value  => "baud_divisor",
    });

  e_assign->add(["baud_rate_counter_is_zero", "baud_rate_counter == 0"]);

  e_register->add ({out    => "baud_clk_en",
                    in     => "baud_rate_counter_is_zero",
                   });


  ################
  # The transmit shift-register proper.
  #
  # Shifts on every baud_clk_en pulse during which the 
  # shifter is not empty.  Also synchronously-loads from
  # the data-in register at the appropriate time.
  #
  e_assign->add(["do_shift", "baud_clk_en  && 
                             (~shift_done) && 
                             (~do_load_shifter)"
   ]);

  e_shift_register->add ({
    serial_out   => "tx_shift_reg_out",
    serial_in    => "1'b0",
    parallel_in  => "tx_load_val",
    parallel_out => "tx_shift_register_contents",
    shift_length => $tx_shift_bits,
    direction    => "LSB-first",
    load         => "do_load_shifter",
    shift_enable => "do_shift",
  });

  ################
  # The final output-bit.
  # 
  # Mostly, the final-output TXD bit is just the serial-out from
  # the shift register above.  But we have to make sure that it powers-up
  # inactive (high), and stays high inbetween character transmissions.
  #
  # Also, we need to implement the break-forcing feature:
  #
  e_register->add({
    out         => "pre_txd",
    in          => "tx_shift_reg_out",
    enable      => "~shift_done",
    async_value => "1",
  });

  e_register->add ({
    out         => "txd",
    in          => "pre_txd & ~do_force_break",
    async_value => "1",
  });

  return $module;
}

################################
# MODULE: Rx
#
# The UART receiver shifts-in characters off the rxd-line.  It 
# contains the single-character storage needed for double-buffering,
# as well as the shift-register itself.  Depending on compile options,
# the incoming serial data is checked for parity.
#
# The Rx module takes these two inputs from the uP interface:
#
#    rx_rd_strobe  : Pulses TRUE (1) when uP reads the rx-buffer.
#                    The output bit "rx_char_ready" is CLEARED when
#                    rx_rd_strobe pulses TRUE.
#
#    status_wr_strobe : Pulses TRUE (1) when uP writes the status register.
#                       All the Rx status-output bits (except rx_char_ready)
#                       are cleared when status_wr_strobe pulses TRUE.
#
# The Rx module produces the following output signals:
#
#    rx_data          : An 8-bit (N-bit) character, arrived and waiting to 
#                       be read.
#
#    rx_char_ready    : Status bit.  Goes TRUE when a new character
#                       from the serial port is presented on rx_data.  Is
#                       cleared when rx_data is read by host.
#
#    rx_overrun       : Goes TRUE when a new character arrives when
#                       an old, unread character is still sitting in the
#                       rx_data register.  The old contents of rx_data
#                       are overwritten, and rx_overrun is set TRUE.
#                       rx_overrun is cleared when the status register is
#                       written-to by the host (status_wr_strobe TRUE).
#
#    break_detect     : Goes TRUE when a BREAK signal is received on the
#                       rxd pin (rxd LOW for more than one full
#                       character-time).   break_detect is cleared when
#                       the status register is written-to by the host 
#                       (status_wr_strobe TRUE).
#
#    framing_error    : Goes TRUE whenever the UART fails to detect a
#                       valid stop-bit for a received character (always
#                       true when break_detect is true) framing_error 
#                       is cleared when the status register is read by 
#                       the host.
#
################################
sub make_uart_rx
{
  my ($Options) = (@_);

  ################
  # First, create our one-and-only sub-module: the "source"
  # for presenting character streams on the rxd-pin during
  # simulation
  #
  $Options->{rx_source_module_name} = 
  $Options->{rx_module_name} . "_stimulus_source";
  my $stim_module = &make_uart_rxd_source($Options);

  # Make empty module, then add contents:
  my $module = e_module->new ({name  => $Options->{rx_module_name}});
  my $marker = e_default_module_marker->new ($module);
  my $depth;

  if ($Options->{sync_reg_depth}) {
     $depth  = $Options->{sync_reg_depth};
  } else {
     $depth  = "2";
  }

  e_instance->add ({module => $stim_module});

  ######## 
  # First things first: Synchronize the input 
  #
  # Note that this entire UART thing is really synchronous, the "A"
  # notwithstanding.  The only thing Asynchronous about it is the 
  # aboriginal rxd pin itself.  And, guess what:  The first thing
  # we do is synchronize it.  The metastability nuts will insist on 
  # two flip-flops, so that's what they get:
  #

  e_std_synchronizer->add({
     data_in  => "source_rxd",
     data_out => "sync_rxd",
     clock    => "clk",
     reset_n  => "reset_n",
     depth    => "$depth",
     comment  => "e_std_synchronizer",
  });

  # Look for both falling edges and any-edge on RXD:
  e_edge_detector->add({
    in     => "sync_rxd",
    out    => "rxd_falling",
    edge   => "falling",
  });

  e_edge_detector->add({
    in     => "sync_rxd",
    out    => "rxd_edge",
    edge   => "any",
  });

  ########
  # Read-strobe conditioning.
  #
  # It is possible that the CPU will assert rx_rd_strobe for more
  # than one cycle (wait states, etc.)   It's safest and most
  # rigorous if we only clear the rx_char_ready flag on the -onset-
  # of the read-strobe (instead of for the -duration- of the read-strobe).
  # The onset is easy enough to detect:
  #
  e_assign->add (["rx_rd_strobe_onset", "rx_rd_strobe && begintransfer"]);

  ########
  # Now generate the baud clock (enable)
  #
  # Conventionally, this is referred to as the "baud clock."  But,
  # because I'm the Smartest Guy on Earth, I don't have multiple clocks
  # in my design unless I absolutely have to.  In this case, I don't have 
  # to.  The "baud clock" is really just a clock-enable pulse which goes
  # true for every Nth signal (N being the value of the divisor, calculated
  # below.
  #
  # Thus, the signal is baud_clk_en.
  #
  # Also note: There are two distinct time-intervals I need to 
  # wait when I'm sampling the input (RxD) waveform.  Of course, I'd like
  # to sample in the middle of a bit-cell.  Thus, I need to wait 1/2 
  # of a bit-time, which requires a 2x-baud-rate clock.  But, once
  # I'm sampling in the middle of a bit cell, I want to take the next
  # sample one -full- bit-cell-time (1x-baud) later.  
  #
  # So, how long I wait inbetween samples depends on what I'm doing.
  # If I see an RxD-edge (either way) in the middle of sampling, then
  # I reset the counter to the 1/2-bit-cell time.  This "realigns" the 
  # timebase and allows me to accommodate a much wider range of input 
  # baud rates.  For what that's worth.
  #
  e_signal->add (["half_bit_cell_divisor", $Options->{divisor_bits} - 1]);
  e_assign->add ({
    lhs => "half_bit_cell_divisor",
    rhs => 'baud_divisor [baud_divisor.msb : 1]',
  });

  e_mux->add ({
    lhs     => e_signal->add (["baud_load_value", $Options->{divisor_bits}]),
    table   => [rxd_edge => "half_bit_cell_divisor"],
    default => "baud_divisor",
  });

  e_register->add ({
    out       => e_signal->add(["baud_rate_counter",$Options->{divisor_bits}]),
    in        => "baud_rate_counter - 1",
    sync_set  => "baud_rate_counter_is_zero || rxd_edge",
    set_value => "baud_load_value",
  });

  e_assign->add (["baud_rate_counter_is_zero", "baud_rate_counter == 0"]);

  e_register->add ({
    in        => "baud_rate_counter_is_zero",
    out       => "baud_clk_en",
    sync_set  => "rxd_edge",
    set_value => "0",
  });

  ################
  # It's important to know when we're receiving a character,
  # and when we're done receiving it.  We start receiving whenever
  # we're idle and we see an edge (a falling edge, obviously) on RxD.
  #
  # we stop receiving whenever a "0" appears in the MS(ultimate) bit of the 
  # input-shift register (it's initialized with all-1's, so that's how 
  # we know the shift is complete).  
  #
  e_assign->add (["sample_enable", "baud_clk_en && rx_in_process"]);

  e_register->add ({
    out         => "do_start_rx",
    in          => "0",
    sync_set    => "(~rx_in_process && rxd_falling)",
    set_value   => "1",
    async_value => "0",
  });

  # compute how many bits in the recieve shift-register:
  # Note that we only look for one (1) stop-bit, even if the 
  # user has specified that we should send 2.  A stop-bit is a stop-bit--
  # it's not like we require that they send the (inevitable) second one
  # in order to terminate a transaction.
  #
  my $rx_shift_bits = 
    (1                                 )  +   # stop bit.
    ($Options->{parity} =~ /N/i ? 0 : 1)  +   # parity bit (opt.)
    ($Options->{data_bits}             )  +   # "payload"
    (1                                 )  ;

  e_shift_register->add ({
    parallel_out => "rxd_shift_reg",
    serial_in    => "sync_rxd",
    serial_out   => "shift_reg_start_bit_n",
    parallel_in  => "\{$rx_shift_bits\{1'b1\}\}",
    shift_length => $rx_shift_bits,
    direction    => "LSB-first",
    load         => "do_start_rx",
    shift_enable => "sample_enable",
  });

  e_assign->add (["rx_in_process", "shift_reg_start_bit_n"]);

  # Break-out the various components of the shifted-in data:
  #
  e_signal->add (["raw_data_in", $Options->{data_bits}]);

  # Build-up a list of the names of the "fields" in the 
  # recieved data.
  #   Note that the "start bit" field of the incoming data is 
  #   unused--well, actually, we use it, but we take it as the
  #   serial-out of the shift register, and not the MSB of the
  #   parallel-out, even though that's the same thing..if you see 
  #   what I mean.
  my $start_bit_sig = e_signal->add(["unused_start_bit", 1]);
  $start_bit_sig->never_export(1);

  my    @register_segments = ("stop_bit"  );
  push (@register_segments,   "parity_bit") unless $Options->{parity} =~/^N$/i;
  push (@register_segments,   "raw_data_in",
                              "unused_start_bit");

  e_assign->add([&concatenate (@register_segments), "rxd_shift_reg"]);

  # Detect "Break:" if the entire contents of the shift-register are 
  # zero, then it was a break.
  # 
  # These are the raw break/framing-error condition bits.
  # the actual status-bits read by the CPU are "conditioned" versions
  # of these.  By "conditioning," I mean:
  # (set only on arrival of new character, and cleared by CPU).
  #
  e_assign->adds(["is_break",         "~(|rxd_shift_reg)"      ],
                 ["is_framing_error", "~stop_bit && ~is_break" ]);

  # When "rx_in_process" falls, that's the sign that a new 
  # character has arrived.
  #
  e_edge_detector->add ({
    out    => "got_new_char",
    in     => "rx_in_process",
    edge   => "falling",
  });

  e_register->add({
    in     => "raw_data_in",
    out    => e_signal->add(["rx_data", $Options->{data_bits}]),
    enable => "got_new_char",
  });

  e_register->add({
    out        => "framing_error",
    sync_set   => "(got_new_char && is_framing_error)",
    sync_reset => "status_wr_strobe",
  });

  e_register->add({
    out        => "break_detect",
    sync_set   => "(got_new_char && is_break)",
    sync_reset => "status_wr_strobe",
  });

  e_register->add({
    out        => "rx_overrun",
    sync_set   => "(got_new_char && rx_char_ready)",
    sync_reset => "status_wr_strobe",
  });

  e_register->add({
    out        => e_port->add (["rx_char_ready", 1, "out"]),
    sync_set   => "got_new_char",
    sync_reset => "rx_rd_strobe_onset",
    priority   => "reset",
  });

  # Compute correct parity from the data bits:
  #
  if ($Options->{parity} =~ /^N$/i) {
    e_assign->add (["parity_error", "0"]);
  } else {
    my $correct_parity_expr = "";
    $correct_parity_expr = "0"               if $Options->{parity} =~ /^S0$/i;
    $correct_parity_expr = "1"               if $Options->{parity} =~ /^S1$/i;
    $correct_parity_expr = " (^raw_data_in)" if $Options->{parity} =~ /^E$/i;
    $correct_parity_expr = "~(^raw_data_in)" if $Options->{parity} =~ /^O$/i;

    e_assign->add (["correct_parity", $correct_parity_expr]);

    e_assign->add ({
      lhs    => "is_parity_error",
      rhs    => "(correct_parity != parity_bit) && ~is_break",
    });

    e_register->add ({
      out        => "parity_error",
      sync_set   => "got_new_char && is_parity_error",
      sync_reset => "status_wr_strobe",
    });
  }

  return $module;
}

################################################################
# make_uart_regs
#
# UARTs have the following register-interface,
# which is described in more detail in their official data sheet:
#
#           | 1   1   1   1   1   1         |                               |
#           | 5   4   3   2   1   0   9   8 | 7   6   5   4   3   2   1   0 |
# ----------+-------------------------------+-------------------------------+
# 0  RxData |                               |          -- rx-data --        |
# ----------+-------------------------------+-------------------------------+
# 1  TxData |                               |          -- tx-data --        |
# ----------+-------------------------------+-------------------------------+
# 2  Status |            EOP CTS  D  -0-  E |R   T   TMT TOE ROE BRK  FE  PE|
#           |                    CTS        |RDY RDY                        |
# ----------+-------------------------------+-------------------------------+
# 3 Control |             i  RTS  iD  T   iE|iR  iT   i   i   i   i   i   i |
#           |            EOP     CTS BRK    |RDY RDY TMT TOE ROE BRK  FE  PE|
# ----------+-------------------------------+-------------------------------+
# 4 Baud    |              -- Baud-Rate Divisor (optional) --               |
# ----------+-------------------------------+-------------------------------+
# 5 EOPchar |                               |     -- end-packet value --    |
# ----------+-------------------------------+-------------------------------+
#
################################################################

sub make_uart_regs
{
  # For brevity, the incoming "\%UART_Options" hash-ref gets nicknamed
  # "$Options" here.
  my ($Options) = (@_);

  # Make empty module, then add contents:
  my $module = e_module->new ({name  => $Options->{reg_module_name}});
  my $marker = e_default_module_marker->new ($module);

  ################
  # This UART has a register on its read-data output.  Consequently,
  # it's a one-wait-state (or, alternatively, one-cycle latency) read-device.
  # While we're registering our CPU interface, throw a register on 
  # the irq, too.
  #
  e_register->add({
   out => e_signal->add (["readdata",           16]),
   in  => e_signal->add (["selected_read_data", 16]),
  });

  e_register->add({
    out    => "irq",
    in     => "qualified_irq",
  });

  ################
  # Compute the register-access strobes
  #
  # Because some of these things are both created and used internally,
  # we have to explicitly declare them as ports.
  #
  # It also avoids confusion to explicitly say how wide the 
  # address- and data-busses are.
  #
  e_port->adds (
    ["address",          3,                        "in" ],
    ["writedata",       16,                        "in" ],
    ["tx_wr_strobe",     1,                        "out"],
    ["status_wr_strobe", 1,                        "out"],
    ["rx_rd_strobe",     1,                        "out"],
    ["baud_divisor",     $Options->{divisor_bits}, "out"],
  );

  e_assign->adds(
    ["rx_rd_strobe",      "chipselect && ~read_n  && (address == 3'd0)"],
    ["tx_wr_strobe",      "chipselect && ~write_n && (address == 3'd1)"],
    ["status_wr_strobe",  "chipselect && ~write_n && (address == 3'd2)"],
    ["control_wr_strobe", "chipselect && ~write_n && (address == 3'd3)"],
  );
  e_assign->add([
     "divisor_wr_strobe", "chipselect && ~write_n  && (address == 3'd4)",
  ]) if !$Options->{fixed_baud};
  e_assign->add([
     "eop_char_wr_strobe","chipselect && ~write_n  && (address == 3'd5)",
  ]) if  $Options->{use_eop_register};

  ################
  # Writeable registers
  #
  my $tx_data_sig = e_signal->add(["tx_data", $Options->{data_bits}]);
  $tx_data_sig->export(1);

  e_register->add ({
    out    => $tx_data_sig,
    in     => "writedata\[tx_data.msb : 0\]",
    enable => "tx_wr_strobe",
  });

  e_register->add ({
    out    => e_signal->add(["control_reg", $Options->{num_control_reg_bits}]),
    in     => "writedata\[control_reg.msb:0\]",
    enable => "control_wr_strobe",
  });

  e_register->add ({
    out    => e_signal->add(["eop_char_reg", $Options->{data_bits}]),
    in     => "writedata\[eop_char_reg.msb:0\]",
    enable => "eop_char_wr_strobe",
  }) if $Options->{use_eop_register};

  # Simulation output:
  #   when we load a new value into the tx shift-register, 
  #   print it to the console.  We know a character has been 
  #   loaded-in when "tx_ready" goes true (after having been 
  #   false)
  #
  e_edge_detector->add ({
    tag  => "simulation",
    out  => "do_write_char",
    in   => "tx_ready",
  });

  e_process->add ({ 
    tag  => "simulation",
    contents => [
      e_if->new ({
      tag  => "simulation",
      condition       => "do_write_char",
      then            => [
        e_sim_write->new ({
          spec_string => '%c', 
          expressions => ["tx_data"],
        })
      ],
    }),
  ]});

  # Create a signal which is set to the baud-constant.  Drive it to
  # '4' if the user has selected the fast-simulation option.
  e_signal->add (["divisor_constant", $Options->{divisor_bits}]);
  e_assign->add ({
    tag  => $Options->{sim_true_baud} ? "normal" : "synthesis",
    lhs  => "divisor_constant",
    rhs  => $Options->{baud_divisor_constant}
  });
  e_assign->add ({
    tag   => "simulation",
    lhs   => "divisor_constant",
    rhs   => 4,
  }) if !$Options->{sim_true_baud};


  # Optionally create the baud-rate divisor register:
  #
  if ($Options->{fixed_baud}) {
    e_assign->add(["baud_divisor", "divisor_constant"]);
  } else {
    e_register->add ({
      in          => "writedata\[baud_divisor.msb:0\]",
      out         => "baud_divisor",
      enable      => "divisor_wr_strobe",
      async_value => "divisor_constant",
    });
  }

  ################
  # Deal with ludicrous CTS input:
  #   (and RTS output).
  #
  # First level of dealing: synchronization.
  # Then edge-detection.
  if ($Options->{use_cts_rts}) {
    e_register->add ({
      in          => "~cts_n",
      out         => "cts_status_bit",
      async_value => 1,
    });

    e_edge_detector->add ({
      in     => "cts_status_bit",
      out    => "cts_edge",
      edge   => "any",
    });

    e_register->add ({
      out         => "dcts_status_bit",
      sync_set    => "cts_edge",
      sync_reset  => "status_wr_strobe",
      async_value => 0,
    });

    # The "rts_n" out-pin is just an inverted version of its
    # control-bit:
    #
    e_assign->add (["rts_n", "~rts_control_bit"]);
  } else {
    # CTS/RTS not supported.  CTS, dCTS status bits read as zero.
    #
    e_assign->adds (["cts_status_bit",  0],
                    ["dcts_status_bit", 0]);
  }


  ################ 
  # assign individual signals to control-register bits:
  #
  # rts_control_bit and ie_dcts may be 'always 0' if (use_cts_rts=0 &
  # use_eop_register=1), and will float out the top without this:
  e_signal->adds({name => "rts_control_bit", never_export => 1},
                 {name => "ie_dcts",         never_export => 1});

  my @control_reg_bits = ();

  push (@control_reg_bits, "ie_eop"  ) if $Options->{use_eop_register};
  push (@control_reg_bits, "rts_control_bit",
                           "ie_dcts" ) if ($Options->{use_cts_rts} |
                                           $Options->{use_eop_register});

  push (@control_reg_bits, "do_force_break",
                           "ie_any_error",
                           "ie_rx_char_ready",
                           "ie_tx_ready",
                           "ie_tx_shift_empty",
                           "ie_tx_overrun",
                           "ie_rx_overrun",
                           "ie_break_detect",
                           "ie_framing_error",
                           "ie_parity_error",
       );

  e_assign->add([&concatenate(@control_reg_bits), "control_reg"]);

  ################
  # Compose the status-register readback value
  #
  e_assign->add ({
    lhs    => "any_error",
    rhs    => join (" ||\n", "tx_overrun",
                             "rx_overrun",
                             "parity_error",
                             "framing_error",
                             "break_detect",
                   ),
  });

  my @status_reg_bits = ();
  push (@status_reg_bits, "eop_status_bit",
                          "cts_status_bit",
                          "dcts_status_bit",
                          "1'b0",
                          "any_error",
                          "rx_char_ready",
                          "tx_ready",
                          "tx_shift_empty",
                          "tx_overrun",
                          "rx_overrun",
                          "break_detect",
                          "framing_error",
                          "parity_error",
       );

  e_assign->add ({
    lhs => e_signal->add(["status_reg", $Options->{num_status_reg_bits}]),
    rhs => &concatenate (@status_reg_bits),
  });

  ################
  # Streaming signals
  # 
  # The Avalon signaling standard now supports "streaming."  This
  # means that slaves, such as this very UART, can have control ports
  # that tell a presumptive master when to start-and-stop a 
  # continuous flow of data.  Avalon slaves don't -need- to have these
  # signals.  But, if they do, they can be used to implement  
  # high-speed streaming.  
  #
  # Now, "high-speed" and "UART" may strike the common-sense reader
  # as an oxymoron.  Nevertheless, that's what the oxymoronic
  # customers say they want, so that's what they're oxymoronically
  # going to get.  The UART is, if nothing else, an excellent test / demo
  # platform for streaming functionality.
  #
  # The two Avalon streaming signals are:
  #
  #     dataavailable
  #        width                : 1
  #        direction (on slave) : output
  #        required             : no
  #  
  #        Slaves produce this signal if they want to be (optionally) 
  #        used as a streaming data source.  They hold this signal
  #        active whenever there is a new data item ready to be
  #        read by a presumptive streaming data-master.  The
  #        particular address, and address-sequence, for the streaming-
  #        read operations is handled by convention. [by convention,
  #        for this UART, a streaming master will always read data
  #        items from our rx_data register].  This signal is 
  #        sometimes colloquially known as "come-'n'-get-it."
  #
  #     readyfordata
  #        width                : 1
  #        direction (on slave) : output
  #        required             : no
  #  
  #        Slaves produce this signal if they want to be (optionally) 
  #        used as a streaming data sink.  They hold this signal
  #        active whenever they can accept new data items 
  #        written by a presumptive streaming data-master.  The
  #        particular address, and address-sequence, for the streaming-
  #        write operations is handled by convention. [by convention,
  #        for this UART, a streaming master will always write data
  #        items into our tx_data register].  This signal is 
  #        sometimes colloquially known as "sock-it-to-me"
  #
  # These signals are, really, just renamed versions of the 
  # "rx_char_ready" and "tx_ready"  bits which already appear in the 
  # status-register.  But the status-bits are intended for use by
  # -software-.  The streaming-control ouptuts are intended for use
  # by -hardware-.  
  #
  # Through the magic of Europa and the "e_avalon_slave" object 
  # in the uart's top-level, all we need to do to export these signals
  # is create ports with the conventional names, given above.  
  # Europa will do us the favor of bubbling-up these ports to the 
  # design's top-level, and the e_avalon_slave object will notice
  # these ports automatically, by dint of their names, and add the 
  # appropriate entries to our section of the PTF-file.  What luxury.
  #
  e_register->add({
    in => "rx_char_ready",
  });
  e_register->add({
    in => "tx_ready",
  });

  e_assign->adds 
    ([e_port->new (["dataavailable", 1, "out"]),  "d1_rx_char_ready"],
     [e_port->new (["readyfordata",  1, "out"]),  "d1_tx_ready"     ] );

  ################
  # The fabulous, and entirely optional, "eop_status_bit" register.
  #
  # If this register is implemented, then the UART sprouts an 
  # an extra "EOP" readable status-bit.  We assert this signal
  # when:
  #
  #   -- The host writes an EOP character (which we do transmit).
  #   -- The host reads an EOP character (which, of course, we don't erase).
  #    
  # This bit is cleared when the host writes to the UART status register.
  # This bit is also output directly as an Avalon port of type
  # "endofpacket"
  if ($Options->{use_eop_register}) {
     e_register->add ({
        out         => "eop_status_bit",
        # On the tx side, look ahead one cycle: use writedata, not tx_data.
        sync_set    => "(rx_rd_strobe && (eop_char_reg == rx_data)) ||
                        (tx_wr_strobe && 
                          (eop_char_reg == writedata\[tx_data.msb:0\]))",
        sync_reset  => "status_wr_strobe",
        async_value => 0,
     });
     e_assign->add 
         ([e_port->new (["endofpacket", 1, "out"]), "eop_status_bit"]);
  } else {
     # No EOP register--ground the bit.
     e_assign->add (["eop_status_bit", "1'b0"]);
  }

  ################
  # Data-read mux
  # 
  my @read_mux_table = (
    "(address == 3'd0)" => "rx_data",
    "(address == 3'd1)" => "tx_data",
    "(address == 3'd2)" => "status_reg",
    "(address == 3'd3)" => "control_reg",
  );

  push (@read_mux_table, "(address == 3'd4)" => "baud_divisor") 
    if !$Options->{fixed_baud};

  push (@read_mux_table, "(address == 3'd5)" => "eop_char_reg") 
    if  $Options->{use_eop_register};

  e_mux->add ({
    lhs    => e_signal->add(["selected_read_data", 16]),
    table  => \@read_mux_table,
    type   => "and-or",
  });

  ################
  # IRQ generation and masking
  #
  my @irq_terms = ();
  push (@irq_terms, "(ie_dcts           && dcts_status_bit )")
    if $Options->{use_cts_rts};
  push (@irq_terms, "(ie_eop            && eop_status_bit  )")
    if $Options->{use_eop_register};

  push (@irq_terms, "(ie_any_error      && any_error      )",
                    "(ie_tx_shift_empty && tx_shift_empty )",
                    "(ie_tx_overrun     && tx_overrun     )",
                    "(ie_rx_overrun     && rx_overrun     )",
                    "(ie_break_detect   && break_detect   )",
                    "(ie_framing_error  && framing_error  )",
                    "(ie_parity_error   && parity_error   )",
                    "(ie_rx_char_ready  && rx_char_ready  )",
                    "(ie_tx_ready       && tx_ready       )",
       );

  e_assign->add (["qualified_irq", join (" ||\n", @irq_terms)]);

  return $module,
}

################################################################
# make_uart_rxd_source
#
# If you're simulating your UART, we do you the service of
# creating a little phony module that pumps characters in 
# through the RXD pin.  This module is a little tumor that
# lives -inside- the uart_rx module.  
#
# When you're synthesizing, it only passes-through the RXD pin.
# When you're simulating, it prints nasty messages if anyone wiggles
# the RXD pin, and dumps a character-stream from a file.  You 
# specify the contents of this file using the wizard.
#
# We know when it's "safe" to send the next character by snooping
# on the rx_char_ready bit.  We only start sending the next 
# character from the file when we notice the CPU has picked-up the 
# last one.
#
################################################################
sub make_uart_rxd_source
{
  my ($Options) = (@_);
  my $module = e_module->new ({name  => $Options->{rx_source_module_name}});
  my $marker = e_default_module_marker->new ($module);

  ################
  # Declare my ports.  These are nonnegotiable.  Unless I've made
  # an error of some kind, the same ports will appear for both
  # simulation and synthesis versions of this module.
  #
  e_port->adds(
    ["rxd",           1,                        "in"],
    ["source_rxd",    1,                       "out"],
    ["rx_char_ready", 1,                        "in"],
    ["clk",           1,                        "in"],
    ["clk_en",        1,                        "in"],
    ["reset_n",       1,                        "in"],
    ["rx_char_ready", 1,                        "in"],
    ["baud_divisor",  $Options->{divisor_bits}, "in"],
  );


  ################
  # Do the non-sim case first, because it's trivial:
  #
  e_assign->add({
   tag  => "synthesis",
   lhs  => "source_rxd",
   rhs  => "rxd",
  });

  ################
  # Instantiate...guess what?  A whole TX-module.
  # This is just the thing for driving the rxd-pin!
  #
  # Make a bunch of bogus, un-exported signals to 
  # tie-off the unused outputs.  
  #
  my @dummies = e_signal->adds (
    ["unused_overrun"],
    ["unused_ready"  ],
    ["unused_empty"  ],
  );

  foreach my $dummy_sig (@dummies) {
    $dummy_sig->never_export   (1);
  }

  e_instance->add ({
    module             => $Options->{"tx_module_name"},
    name               => "stimulus_transmitter",
    tag                => "simulation",
    port_map           => {
      txd                => "source_rxd",
      tx_overrun         => "unused_overrun",
      tx_ready           => "unused_ready",
      tx_shift_empty     => "unused_empty",
      do_force_break     => "1'b0",
      status_wr_strobe   => "1'b0",
      tx_data            => "d1_stim_data",
      begintransfer      => "do_send_stim_data",
      tx_wr_strobe       => "1'b1",
    },
  });

  ################
  # Instantiate the ROM with the character data in it,
  # plus an address-counter:
  #
  e_signal->add ({
    tag             => "simulation",
    name            => "stim_data",
    width           => $Options->{data_bits},
  });

  # Need to hold data from ROM for 1 cycle (to avoid skipping first char)
  e_register->add ({
    tag    => "simulation",
    in     => "stim_data",
    out    => e_signal->add(["d1_stim_data", $Options->{data_bits}]),
    enable => "do_send_stim_data",
  });

  # Since all this junk is only used for simulation, there's no actual
  # cost associated with gigantic (simulated) character-stream
  # memories.  Thus, even if the user has only a single character, 
  # we build them a big rom. 
  #
  # Why?  Because in software-only mode, they may later change
  # their character stream contents, and we don't want to
  # inconvenience them by making them regenerate the HDL.  They 
  # are less likely to need to regenerate the HDL if we make the 
  # ROM big in the first place.  If, in spite of our efforts, they
  # -still- end up subsequently-changing their character stream to be
  # too big, then ModelSim will give them a warning.

  # sometimes, people want to slam in a massive slug of data.
  # Add 1 to the mutex_file_size to account for the extra 0 pad at the end.
  my $size = &max ($Options->{mutex_file_size} + 1, 1024);  
  # Old rom, address and Address-counter is in e_drom.
  e_drom->add ({
     name	    => $module->name()."_character_source_rom",
     rom_size       => $size,
     dat_name	    => $Options->{char_data_file},
     mutex_name	    => $Options->{char_mutex_file},
     interactive    => $Options->{interactive_in},
     relativepath   => $Options->{"relativepath"},
     allow_missing_mutex_file => 1,
     port_map	    => {"q"         => "stim_data",
			"new_rom"   => "new_rom_pulse",
			"incr_addr" => "do_send_stim_data",
		    }
  });

  ################
  # Well now.  I've pushed all the nastiness in this process down into
  # the "do_send_stim_data" signal.  In English, this signal goes true
  # whenever it's time to send the next character.  Implicit in its
  # use (above), it pulses true for exactly one clock cycle whenever
  # it's time to send a new characer.
  #
  # So.  When is it time to send a new character?  Easy:  Whenever we
  # see the CPU pick up the last one.  We snoop on this via the 
  # "rx_char_ready" signal, which is available in this module.  So--
  # "do_send_stim_data" just pulses on the falling edge of 
  # "rx_char_ready", right?  Well, not quite.  What about start-up?
  # What about the end of the stream?
  # Handling each case separately:  
  #    To handle start-up, we can just emit a single bonus-pulse
  #    at a fixed time after reset.  A bit of a hassle, but not difficult.
  #
  #    To handle the end-condition, we can just suppress all
  #    "do_send_stim_data" pulses once we've reached the end of the buffer.
  #
  e_edge_detector->add ({
    tag             => "simulation",
    out             => "pickup_pulse",
    in              => "rx_char_ready",
    edge            => "falling",
  });

  # The counter that makes the start-pulse has been backed up into e_drom.  It
  # arbitrarily wait 10 clocks before starting, just like the old em_uart's
  # aboriginal_start_pulse.

  e_assign->add ({
    tag             => "simulation",
    lhs             => "do_send_stim_data",
    rhs             => "(pickup_pulse || new_rom_pulse) && safe",
  });

  return $module;
}
