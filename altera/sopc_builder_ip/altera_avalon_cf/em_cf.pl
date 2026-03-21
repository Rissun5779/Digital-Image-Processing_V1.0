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


##Copyright (C) 2005 Altera Corporation
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
use em_cf;

###############################################################################
# Flush stderr
###############################################################################
$| = 1;

###############################################################################
# If we're not given any args this is a syntax check; exit
###############################################################################
exit if(not @ARGV);

###############################################################################
# Retrieve the project, and derive the options and module
###############################################################################
my $project = e_project->new(@ARGV);
my $module = $project->top();

###############################################################################
# Set the marker for the module we're adding to
###############################################################################
my $marker = e_default_module_marker->new($module);

###############################################################################
# Build the compact flash controller
###############################################################################
make_em_cf($project);

###############################################################################
# Declare ports. It's not necessary to declare your ports in europa, but
# it's reassuring and documentary:
###############################################################################
my @common_ports = (
  [clk                  => 1,   "in" ],
  [av_reset_n           => 1,   "in" ],
);

my @ctl_ports = (
  [av_ctl_address       => 2,   "in"    ],
  [av_ctl_chipselect_n  => 1,   "in"    ],
  [av_ctl_irq           => 1,   "out"   ],
  [av_ctl_read_n        => 1,   "in"    ],
  [av_ctl_readdata      => 4,   "out"   ],
  [av_ctl_write_n       => 1,   "in"    ],
  [av_ctl_writedata     => 4,   "in"    ],
); 

my @ide_ports = (
  [av_ide_address       => 4,   "in"    ],
  [av_ide_chipselect_n  => 1,   "in"    ],
  [av_ide_irq           => 1,   "out"   ],
  [av_ide_read_n        => 1,   "in"    ],
  [av_ide_readdata      => 16,  "out"   ],
  [av_ide_write_n       => 1,   "in"    ],
  [av_ide_writedata     => 16,  "in"    ],
  [addr                 => 11,  "out"   ],
  [atasel_n             => 1,   "out"   ],
  [cs_n                 => 2,   "out"   ], 
  [data_cf              => 16,  "inout" ],
  [detect_n             => 1,   "in"    ],
  [intrq                => 1,   "in"    ],
  [iordy                => 1,   "in"    ],
  [iord_n               => 1,   "out"   ],
  [iowr_n               => 1,   "out"   ],
  [power                => 1,   "out"   ],
  [reset_n_cf           => 1,   "out"   ],
  [rfu                  => 1,   "out"   ],
  [we_n                 => 1,   "out"   ],
);

###############################################################################
# Add the ports
###############################################################################
e_port->adds(@common_ports);
e_port->adds(@ctl_ports);
e_port->adds(@ide_ports);

###############################################################################
# Create the type map for the slaves
###############################################################################
my $ctl_type_map = {
  clk                 => "clk",
  av_reset_n          => "reset_n",
  av_ctl_address      => "address",
  av_ctl_chipselect_n => "chipselect_n",
  av_ctl_irq          => "irq",
  av_ctl_read_n       => "read_n",
  av_ctl_readdata     => "readdata",
  av_ctl_write_n      => "write_n",
  av_ctl_writedata    => "writedata",
};

my $ide_type_map = {
  clk                 => "clk",
  av_reset_n          => "reset_n",
  av_ide_address      => "address",
  av_ide_chipselect_n => "chipselect_n",
  av_ide_irq          => "irq",
  av_ide_read_n       => "read_n",
  av_ide_readdata     => "readdata",
  av_ide_write_n      => "write_n",
  av_ide_writedata    => "writedata",
  addr                => "export",
  atasel_n            => "export",
  cs_n                => "export",
  data_cf             => "export",   
  detect              => "export",
  intrq               => "export",
  iordy               => "export",
  iord_n              => "export",
  iowr_n              => "export",
  power               => "export",
  reset_n_cf          => "export",
  rfu                 => "export",
  we_n                => "export",
};

###############################################################################
# Add the slaves
###############################################################################
e_avalon_slave->add({
    name     => "ctl",
    type_map => $ctl_type_map,
}); 

e_avalon_slave->add({
    name     => "ide",
    type_map => $ide_type_map,
}); 

###############################################################################
# If we reach this point, HDL was successfully generated. 
############################################################################### 
$project->output();

# end of file
