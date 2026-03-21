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


##Copyright (C) 2004 Altera Corporation
##Any megafunction design, and related net list (encrypted or decrypted),
##support information, device programming or simulation file, and any other
##associated documentation or information provided by Altera or a partner
##under Altera's Megafunction Partnership Program may be used only to
##program PLD devices (but not masked PLD devices) from Altera.  Any other
##use of such megafunction design, net list, support information, device
##programming or simulation file, or any other related documentation or
##information is prohibited for any other purpose, including, but not
##limited to modification, reverse engineering, de-compiling, or use with
##any other silicon devices, unless such use is explicitly licensed under
##a separate agreement with Altera or a megafunction partner.  Title to
##the intellectual property, including patents, copyrights, trademarks,
##trade secrets, or maskworks, embodied in any such megafunction design,
##net list, support information, device programming or simulation file, or
##any other related documentation or information provided by Altera or a
##megafunction partner, remains with Altera, the megafunction partner, or
##their respective licensors.  No other licenses, including any licenses
##needed under any third party's intellectual property, are provided herein.
##Copying or modifying any file, or portion thereof, to which this notice
##is attached violates this copyright.

use europa_all;
use em_mutex;

# fixed data width (for now)
my $data_width = 32;

$| = 1;     # Always flush stderr

# if we're not given any args this is a syntax check, exit
exit if(not @ARGV);

################
# Retrieve the project, and derive the options and module
my $project = e_project->new(@ARGV);
my $module = $project->top();
my $Opt = &copy_of_hash ($project->WSA());


################
# Validate the options
validate_mutex_options($Opt);


################
# Set the marker for the module we're adding to
my $marker = e_default_module_marker->new($module);


################
# Build the mutex
make_em_mutex($Opt, $project);


################
# Declare ports
# It's not necessary to declare your ports in europa, but
# it's reassuring and documentary:
#
my @ports = (
    [clk            => 1,           "in" ],
    [reset_n        => 1,           "in" ],
    [chipselect     => 1,           "in" ],
    [data_from_cpu  => $data_width, "in" ],
    [data_to_cpu    => $data_width, "out"],
    [read           => 1,           "in" ],
    [write          => 1,           "in" ],
    [address        => 1,           "in" ]
); 

################
# Add the ports
#
e_port->adds(@ports);

################
# Create the type map for the slave
#
my $s1_type_map = {
    clk             => "clk",
    reset_n         => "reset_n",
    data_from_cpu   => "writedata",
    data_to_cpu     => "readdata",
    read            => "read",
    write           => "write",
    address         => "address",
};

################
# add the slave
#
e_avalon_slave->add({
    name     => "s1",
    type_map => $s1_type_map,
}); 


################################
# If we reach this point, HDL was successfully generated.  
$project->output();
