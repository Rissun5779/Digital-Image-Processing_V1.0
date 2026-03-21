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


#Copyright (C)2005 Altera Corporation
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

package em_cf_qsys;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &make_em_cf
);

use europa_all;
use europa_utils;
use strict;

my $clock_speed;
my $debounce_count;
my $debounce_width;

###############################################################################
# make_em_cf()
#
# This module creates a hardware True-IDE mode Compact Flash controller, based
# heavily on a Verilog implementation by Microtronix.
#
# The module has already been marked for us.
###############################################################################
sub make_em_cf
{
  my ($module,$Options) = (@_);
  
  # Calculate number of clocks in 1ms  & how many bits to encode it
  $clock_speed = $Options->{clock_speed};
  $debounce_count = &ceil($clock_speed / 1000); 
  $debounce_width = &ceil(&log2($debounce_count));
  
  my $marker = e_default_module_marker->new($module);
  
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

  e_port->adds(@common_ports);
  e_port->adds(@ctl_ports);
  e_port->adds(@ide_ports);

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

  e_avalon_slave->add({
      name     => "ctl",
      type_map => $ctl_type_map,
  }); 

  e_avalon_slave->add({
      name     => "ide",
      type_map => $ide_type_map,
  }); 
  
  #############################################################################
  # Take care of simple signal assignments necessary for True-IDE mode.
  #############################################################################
  e_assign->adds(
    ["atasel_n",        "1'b0"],
    ["we_n",            "1'b1"],
    ["rfu",             "1'b1"],
    ["addr[10:3]",      "8'h00"],
    ["addr[2:0]",       "av_ide_address[2:0]"],
    ["iord_n",          "av_ide_read_n"],
    ["iowr_n",          "av_ide_write_n"], 
  );

  #############################################################################
  # Use the highest Avalon address bit to separate the two chip selects 
  # putting their memory spaces back to back. cs_n[0] at the lower addresses.
  #############################################################################
  e_assign->adds(
    ["cs_n[0]",
      "~av_ide_chipselect_n ? (~av_ide_address[3] ? 1'b0 : 1'b1) : 1'b1"],

    ["cs_n[1]", 
      "~av_ide_chipselect_n ? ( av_ide_address[3] ? 1'b0 : 1'b1) : 1'b1"],
  );

  #############################################################################
  # Take care of bi-directional IDE data bus. IDE slave setup/hold time takes
  # care of any contention issues.
  #
  # Data is qualified (both ways) on CF card presence.
  #############################################################################
  e_assign->adds(
    ["av_ide_readdata", "present_reg ? data_cf : 16'hFFFF"],
    ["data_cf", "(~av_ide_write_n && present_reg) ? av_ide_writedata :16'hZZZZ"],
  );
  
  #############################################################################
  # Turn on CF card power when:
  #  1) Told to do so in control register, and
  #  2) Card present
  #############################################################################
  e_assign->adds(
    ["power", "(power_reg && present_reg) ? 1'b1 : 1'b0"],
  );
  
  #############################################################################
  # The original Microtronix Verilog controller had reset circuit. It is 
  # dutifully reconstructed and exported to the top-level. However,
  # the Nios development boards do not connect the card-slot's reset_n
  # to the FPGA; the configuration CPLD's reset-distribution circuitry
  # handles it for us.
  #
  # Reset CF card on:
  #   1) CPU setting the reset register, or
  #   2) Avalon reset, or
  #   3) CF card not present
  #############################################################################
  e_assign->adds(
    ["reset_n_cf", "(reset_reg || ~av_reset_n || ~present_reg) ? 1'b0 : 1'b1"],
  );

  #############################################################################
  # Enable IDE interrupts when:
  #   1) Specified in the IDE control register, and
  #   2) When the card is present
  #############################################################################
  e_assign->adds(
    ["av_ide_irq", "(ide_irq_en_reg && present_reg) ? intrq : 1'b0"],
  );


  #############################################################################
  #                   Compact Flash controller register map
  #############################################################################
  #                              Control slave
  # +---------+----------+-----+----------------------------------------------+
  # | A[1..0] | Register | R/W |               Description/Bits               |
  # |         |   name   |     |     3     |     2     |     1     |    0     |
  # +---------+----------+-----+-----------+-----------+-----------+----------+
  # |   00    | cfctl    | R/W | Detect IE |  CF Reset |   Power   | Detect   |
  # |   01    | idectl   | R/W |     (0)   |    (0)    |    (0)    | IDE IE   |
  # |   10    | reserved | R/O |     (0)   |    (0)    |    (0)    |   (0)    |
  # |   11    | reserved | R/O |     (0)   |    (0)    |    (0)    |   (0)    |
  # +---------+----------+-----+-----------+-----------+-----------+----------+  
  # 
  # Note: Description above maps to the following e_registers:
  #       "Detect IE" --> ctl_irq_en_reg
  #       "Power"     --> power_reg
  #       "CF Reset"  --> reset_reg  
  #       "Detect"    --> present_reg
  #       "IDE IE"    --> ide_irq_en_reg
  #
  # Note: All unused bits are read as zero and not writable.
  #
  # Note: We don't care about the IDE slave; its register map is defined by
  #       the IDE spec & handled in the CF card.
  #############################################################################
  # Control registers that can be modified by CPU -- Write strobe generation:
  #   A=0 selects the "low" control registers (ctl irq en, reset, power)
  #   A=1 selects the "high" control register (ide irq enable)
  #############################################################################
  e_assign->adds(
    ["ctl_lo_write_strobe", "~av_ctl_chipselect_n && ~av_ctl_write_n && 
      (av_ctl_address == 4'h0)"],
      
    ["ctl_hi_write_strobe", "~av_ctl_chipselect_n && ~av_ctl_write_n &&
      (av_ctl_address == 4'h1)"],
  );
  
  ############################################################################# 
  # And the actual registers
  #############################################################################
  e_register->add({
    out         => e_signal->add(["ctl_irq_en_reg", 1]),
    in          => "av_ctl_writedata[3]",
    enable      => "ctl_lo_write_strobe",
    async_value => 0,
   });
   
  e_register->add({
    out         => e_signal->add(["reset_reg", 1]),
    in          => "av_ctl_writedata[2]",
    enable      => "ctl_lo_write_strobe",
    async_value => 0,
   });  
  
  e_register->add({
    out         => e_signal->add(["power_reg", 1]),
    in          => "av_ctl_writedata[1]",
    enable      => "ctl_lo_write_strobe",
    async_value => 0,
   });  
  
  e_register->add({
    out         => e_signal->add(["ide_irq_en_reg", 1]),
    in          => "av_ctl_writedata[0]",
    enable      => "ctl_hi_write_strobe",
    async_value => 0,
   });  
    
  
  #############################################################################
  # Control slave readdata. There is likely a more elegant way to handle this.
  #############################################################################
  # 1) Construct arrays of individual bits that make up each word, MSB first.
  my @ctl_reg_zero_bits = ();  
  push (@ctl_reg_zero_bits,
    "ctl_irq_en_reg", 
    "reset_reg", 
    "power_reg", 
    "present_reg",
  );
  
  my @ctl_reg_one_bits = ();
  push (@ctl_reg_one_bits,
    "3'h0",
    "ide_irq_en_reg",
  );
  
  # 2) Make the readdata mux.
  my $ctl_read_mux;
  $ctl_read_mux = e_mux->add({
    lhs     => e_signal->add(["ctl_read_mux", 4]),
    selecto => "av_ctl_address",
    table   => [
      "2'b00" => &concatenate(@ctl_reg_zero_bits),
      "2'b01" => &concatenate(@ctl_reg_one_bits),
      "2'b10" => "4'h0",
      "2'b11" => "4'h0",
      ],
  });

  # 3) Register the readdata from the mux. Implies one read-wait-state.
  e_register->add({
    out         => "av_ctl_readdata",
    in          => "ctl_read_mux",
    async_value => 0,
    enable      => 1,
  });

  #############################################################################
  #             CF card detection debounce & interrupt generation
  #############################################################################
  # When a CF card is inserted or removed the "detect_n" input tells us
  # so. However, detect_n is simply pulled high when a card is not present,
  # and then driven to GND when the card is inserted. This creates a rather
  # horrible bounce, depending on how "cleanly" the user inserts/removes
  # the card. Since card insertion or removal generates an interrupt request,
  # we will qualify the interrupt based on detect_n being stable for the
  # duration of a counter. Removing a card will trigger an interrupt instantly
  # (desirable), but no interrupt for card insertion will be generated until
  # the counter (reset with any bounce) qualifies it. 
  #
  # A 1-millisecond debounce count removes all but the most dirty bounce
  # (measured with signal tap), and allows sufficient time for the CPU to 
  # service the interrupt & tell software that the card is available (or not). 
  # On the odd case that bounce results in a stable detect_n for longer than 
  # 1ms, a (false) interrupt will be generated, and then a subsequent interrupt
  # once detect_n settles down. Note that this won't be a spurious interrupt 
  # since the CPU must read the low ctl register to clear the irq. 
  #
  # The control slave will then generate an interrupt when the debounce-adjusted
  # card presence register indicates card insertion or removal. This is done 
  # by XOR'ing the card presence register with a register delay of itself.
  #############################################################################
  
  # Debounce counter. Reset anytime card is removed.
  e_register->add({
    out         => e_signal->add(["present_counter", $debounce_width]),
    in          => "present_counter + 1",
    enable      => 1,
    async_value => 0,
    sync_reset  => "detect_n",
  });
  
  # Card presence (ctl register A=0, bit 0). Set on counter reaching 1ms.
  e_register->add({
    out         => e_signal->add(["present_reg", 1]),
    sync_set    => "present_counter == $debounce_count",
    sync_reset  => "detect_n",
    async_value => 0,
    enable      => 1,
  }); 
  
  # Register delay of card presence
  e_register->add({
    out         => e_signal->add(["d1_present_reg", 1]),
    in          => "present_reg",
    async_value => 0,
    enable      => 1,
  }); 

  # Control reg A=0 read strobe (to clear interrupt)
  e_assign->adds(
    ["ctl_lo_read_strobe", "~av_ctl_chipselect_n && ~av_ctl_read_n && 
      (av_ctl_address == 4'h0)"],
  );

  # Interrupt generation for card insertion & removal. 
  # Reading to ctl reg A=0 clears it.    
  e_register->add({
    out         => "av_ctl_irq",
    sync_set    => "(d1_present_reg ^ present_reg)",
    sync_reset  => "ctl_lo_read_strobe",
    async_value => 0,
    enable      => "ctl_irq_en_reg",
  });

  e_assign->adds({
      lhs => {name => "reset_n", never_export => 1,},
      rhs => "av_reset_n",
  });
};

1;
