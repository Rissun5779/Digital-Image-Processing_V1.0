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


#Copyright (C)2004 Altera Corporation
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

package em_mutex;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &make_em_mutex
    &validate_mutex_options
);

use europa_all;
use europa_utils;
#use e_dpram;
#use add_ptf_signals;

use strict;

###############################################################################
## em_mutex
##
## This module creates a harware mutex
##
###############################################################################

####################
# Global Constants #
####################

my $mutex_data_width = 32;

my $max_value_bits = 16;
my $max_owner_bits = 16;

my $min_value_bit_position = 0;
my $max_value_bit_position = 15;
my $min_owner_bit_position = 16;
my $max_owner_bit_position = 31;
my $reset_reg_bit_position = 0;

my $mutex_value_init;
my $mutex_owner_init;

my $mutex_value_width;
my $mutex_value_bitrange;
my $mutex_value_pad_width;
my $mutex_value_pad_bitrange;

my $mutex_owner_width;
my $mutex_owner_bitrange;
my $mutex_owner_pad_width;
my $mutex_owner_pad_bitrange;


################################################################
# validate_mutex_options
################################################################
sub validate_mutex_options
{
    my ($Options) = (@_);

    validate_parameter({
        hash    => $Options,
        name    => "value_width",
        type    => "integer",
        range   => [1, $max_value_bits],
    });

    validate_parameter({
        hash    => $Options,
        name    => "owner_width",
        type    => "integer",
        range   => [1, $max_owner_bits],
   });

    validate_parameter({
        hash    => $Options,
        name    => "value_init",
        type    => "integer",
        range   => [0, (( 2 ** $max_value_bits ) - 1)],
    });

    validate_parameter({
        hash    => $Options,
        name    => "owner_init",
        type    => "integer",
        range   => [0, (( 2 ** $max_owner_bits ) - 1)],
    });
}

################################################################
# initialize_global_constants
#
#
# Create strings to describe a register that looks like this:
#
#  3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
#  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
# |<---OWNER PAD->|<----OWNER---->|<--VALUE PAD-->|<----VALUE---->|
#
# where:
#  VALUE are the bits storing the Mutex's current value.
#  VALUE PAD is filled with zeros.
#  OWNER are the bits storing the Mutex's current owner.
#  MUTEX PAD is filled with zeros.
#
# For example, if the input options indicate a mutex with a
#   value field 8 bits wide and an owner field 5 bits wide,
#   the global constants will be:
#
#   $mutex_value_width          == 8
#   $mutex_owner_width          == 5
#   $mutex_value_bitrange       == "7:0"
#   $mutex_value_pad_width      == 8
#   $mutex_value_pad_bitrange   == "15:8"
#   $mutex_owner_pad_width      == 13
#   $mutex_owner_bitrange       == "20:16"
#   $mutex_owner_pad_bitrange   == "30:21"
#
################################################################
sub initialize_global_constants
{
    my ($Opt) = @_;

    # retrieve the initial values
    $mutex_value_init = $Opt->{value_init};
    $mutex_owner_init = $Opt->{owner_init};

    #
    # Create strings to describe a register that looks like this:
    #
    #  3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
    #  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
    # |R|<-OWNER PAD->|<----OWNER---->|<--VALUE PAD-->|<----VALUE---->|
    #
    # where:
    #  VALUE are the bits storing the Mutex's current value.
    #  VALUE PAD is filled with zeros.
    #  OWNER are the bits storing the Mutex's current owner.
    #  MUTEX PAD is filled with zeros.
    #  R is the reset detection bit.
    #

    # the widths of the value and owner
    $mutex_value_width = $Opt->{value_width};
    $mutex_owner_width = $Opt->{owner_width};

    # bit range for the mutex value
    $mutex_value_bitrange = ($mutex_value_width - 1);
    if ( 1 < $mutex_value_width ) {
        $mutex_value_bitrange .= ':' . $min_value_bit_position;
    }

    # width of the mutex value pad (if any)
    $mutex_value_pad_width = $max_value_bits - $mutex_value_width;

    # if the value pad has a width, it needs a bit range
    if (0 != $mutex_value_pad_width)
    {
        # bit range for the mutex value pad
        $mutex_value_pad_bitrange = $max_value_bit_position;
        if ( 1 < $mutex_value_pad_width ) {
            $mutex_value_pad_bitrange .= ':' . $mutex_value_width;
        }
    }

    # bit range for the mutex owner
    $mutex_owner_bitrange =
        ($mutex_owner_width - 1) + $min_owner_bit_position;
    if ( 1 < $mutex_owner_width ) {
        $mutex_owner_bitrange .= ':' . $min_owner_bit_position;
    }

    # width of the mutex owner pad
    $mutex_owner_pad_width = $max_owner_bits - $mutex_owner_width;

    # if the owner pad has a width, it needs a bit range
    if (0 != $mutex_owner_pad_width)
    {
        # bit range for the mutex owner pad
        $mutex_owner_pad_bitrange = $max_owner_bit_position;
        if ( 1 < $mutex_owner_pad_width ) {
            $mutex_owner_pad_bitrange .=
                ':' . ($mutex_owner_width + $min_owner_bit_position);
        }
    }

    # debug print statements
    # print( "mutex_value_init: " . $mutex_value_init . "\n");
    # print( "mutex_owner_init: " . $mutex_owner_init . "\n");

    # print( "mutex_value_width: " . $mutex_value_width . "\n");
    # print( "mutex_value_bitrange: " . $mutex_value_bitrange . "\n");
    # print( "mutex_value_pad_width: " . $mutex_value_pad_width . "\n");
    # print( "mutex_value_pad_bitrange: " . $mutex_value_pad_bitrange . "\n");

    # print( "mutex_owner_width: " . $mutex_owner_width . "\n");
    # print( "mutex_owner_bitrange: " . $mutex_owner_bitrange . "\n");
    # print( "mutex_owner_pad_width: " . $mutex_owner_pad_width . "\n");
    # print( "mutex_owner_pad_bitrange: " . $mutex_owner_pad_bitrange . "\n");
}


############################################################################
#
# make_em_mutex
#
#   The module has already been marked for us
#
############################################################################
sub make_em_mutex
{
    my ($Opt, $project) = (@_);

    # Make sure all global constants have been initialized.
    initialize_global_constants($Opt);

    # TODO use the address width to determine how many mutexes to create

    # Create a writeable register for the mutex value
    e_register->adds({
        name        => "mutex_value",
        out         => "mutex_value",
        in          => "data_from_cpu[$mutex_value_bitrange]",
        enable      => "mutex_reg_enable",
        async_value => $mutex_value_init,
    });

    # Create a writeable register for the mutex owner id
    e_register->adds({
        name        => "mutex_owner",
        out         => "mutex_owner",
        in          => "data_from_cpu[$mutex_owner_bitrange]",
        enable      => "mutex_reg_enable",
        async_value => $mutex_owner_init,
    });

    # Create a single bit register for the reset detector
    e_register->adds({
        name        => "reset_reg",
        out         => "reset_reg",
        in          => "1'b0",
        enable      => "reset_reg_enable",
        async_value => "1'b1",
    });

    # Create the free test
    e_signal->add (["mutex_free",   1]);
    e_assign->add (["mutex_free", "mutex_value == 0"]);

    # Create the owner test
    e_signal->add (["owner_valid",   1]);

    # do we need to compare the owner, or the owner plus some zeros?
    if ($max_owner_bits == $mutex_owner_width) {
        e_assign->add (["owner_valid",
            "(mutex_owner == data_from_cpu[$mutex_owner_bitrange])"
        ]);
    }
    else {
        e_assign->add (["owner_valid",
            "(mutex_owner == data_from_cpu[$mutex_owner_bitrange]) &&
             (data_from_cpu[$mutex_owner_pad_bitrange] == $mutex_owner_pad_width\'b0)"
        ]);
    }

    # create the mutex register enable
    e_signal->add (["mutex_reg_enable",   1]);
    e_assign->add (["mutex_reg_enable",
        "(mutex_free | owner_valid) & chipselect & write & ~address"]);

    # create the reset register enable
    e_signal->add (["reset_reg_enable",   1]);
    e_assign->add (["reset_reg_enable", "chipselect & write & address"]);

    # Data is always available for read, assign it to read bus
    #
    # Use a "mutex state" in preparation for muxing the contents of
    # multiple mutexes once we support multiple addresses.
    e_signal->add (["mutex_state",   $mutex_data_width]);
    e_assign->add (["data_to_cpu", "address ? reset_reg : mutex_state"]);

    # assign the mutex value to the mutex state
    e_signal->add (["mutex_value",   $mutex_value_width]);

    e_assign->add (["mutex_state[$mutex_value_bitrange]", "mutex_value"]);
    if ($mutex_value_pad_width)
    {
        e_assign->add (["mutex_state[$mutex_value_pad_bitrange]", "$mutex_value_pad_width\'b0"]);
    }

    # assign the mutex owner id to the mutex state
    e_signal->add (["mutex_owner",   $mutex_owner_width]);
    e_assign->add (["mutex_state[$mutex_owner_bitrange]", "mutex_owner"]);
    if ($mutex_value_pad_width)
    {
        e_assign->add (["mutex_state[$mutex_owner_pad_bitrange]", "$mutex_owner_pad_width\'b0"]);
    }
};

1;
