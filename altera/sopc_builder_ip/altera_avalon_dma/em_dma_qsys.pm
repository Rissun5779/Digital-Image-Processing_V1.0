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


use europa_all;
use europa_utils;
use e_avalon_master;
use e_fsm;
use strict;

my $p4_revision = '$Revision: #1 $';
my $p4_datetime = '$DateTime: 2018/07/18 14:55:49 $';
$p4_revision =~ /#(\d+)/;
my $revision = $1;

my $read_master_name = "read_master";
my $write_master_name = "write_master";
my $control_port_name = "control_port_slave";

my @all_transactions = qw(
  quadword
  doubleword
  word
  hw
  byte_access
);

sub Encode_Address 
{
    my $x;
    ($x) = (@_);
	if ($x == 0) {	#this is to address usecase where the master interface is exported and results in max_slave_address_span == 0
		return log2($x+1);
	} else {
		return ceil(log2($x));
	}
}

sub control_register
{
  my ($comment,
      $name,
      $width,
      $condition,
      $data,
      $else_if,
      $else_event,
      $reset_value) = @_;

  # If there's nothing to do, return an empty list.
  return () if ($width == 0);

  # Fix up the reset value with the proper width.
  $reset_value =~ s/^[0-9]*\'h/$width\'h/;

  # Make a table for my mux...
  my @table = ($condition, $data);
  if ($else_if)
  {
    push @table, ($else_if, $name . $else_event);
  }

  # ... a mux for my register input...  
  my $mux = e_mux->new({
    lhs => e_signal->new(["p1_$name",]),
    table          => \@table,
    type           => "priority",
    default => $name,
  });

  # ... and a register.  
  my $reg = e_register->new({
    comment => $comment,
    in => "p1_$name",
    out => e_signal->new({name => $name, width => $width}),
    async_value => $reset_value,
  });

  return ($reg, $mux);
}

sub get_slave_port_data_width
{
  # Find the max width value over all register descriptors.     
  return max(map {$_->[2]} get_slave_port_registers(@_));
}

sub get_slave_port_addr_width
{
  my @registers = get_slave_port_registers(@_);

  my $addr_width = ceil(log2(0 + @registers));
  return $addr_width;
}

sub get_max_transaction_size_in_bits
{
  my @trans = reverse get_transaction_size_bit_names();
  my $size = 8;
  @trans = map {
    my $this_size = $size; $size *= 2; {trans => $_, size => $this_size}
  } @trans;

  my $max_size = -1;

  map {$max_size = $_->{size} if is_transaction_allowed($_->{trans})} @trans;

  ribbit("no possible transactions!") if $max_size == -1;

  return $max_size;
}

# Transaction bit names, in a list with the least-significant bit
# (the one encoding "byte" transaction") in the last position.
sub get_transaction_size_bit_names
{
  return @all_transactions;
}

# We're interested in the indices of the control bits that encode the
# transaction size in a few places, so here's a handy function.
# 
# Bit indices are turned in a list with the least-significant bit
# (the one encoding "byte" transaction") in the last position.
sub get_transaction_size_bit_indices
{
  return get_slave_port_bits('control', get_transaction_size_bit_names());
}

# get_transaction_size_expression()
# Get the list of control bit indices, least-significant ("byte") last;
# form the expression of the associated control bit in the control register;
# return the concatenation of all such control bits.
# 
# The returned expression is appropriate for use as a number, namely a
# read- or write-master address increment or length register decrement.
# 
# Optimization: if the user promised to use any transaction sizes, exclude
# their control bits.
sub get_transaction_size_expression
{
  return concatenate(
    map {is_transaction_allowed($_) ? $_ : "1'b0"}
    get_transaction_size_bit_names()
  );
}

sub get_slave_port_registers
{
  my $Options = shift;

  # Historical note: registers "reserved1" and "reserved2" below
  # used to be read and write increment override.  The list contents for
  # those register positions was formerly:
#   [" read master increment override",
#     "readincov",
#     $Options->{readincovwidth},
#     "",
#     "dma_ctl_writedata",
#     "",
#     "",
#     0,
#   ],
#   [" write master increment override",
#     "writeincov",
#     $Options->{writeincovwidth},
#     "",
#     "dma_ctl_writedata",
#     "",
#     "",
#     0,
#   ],

# Likewise, "reserved3" used to be "altcontrol".  Documenting that
# register seems difficult, and it's likely of limited utility to
# most people, so it's now renamed.
#    [" control register alternate",
#     "alt_control",
#      $control_register_width,
#      "",
#      "dma_ctl_writedata",
#      "",
#      "",
#      $control_default_reset_string,
#    ],

  # This function can be called at generate time in which case
  # $Options is a hash of various useful things from the ptf file,
  # or it can be called by generate_appurtenances, in which case
  # $Options is undef.

  # Here are the registers accessible from the slave port.

  # Some of these widths depend on user choices/slave sizes, etc.
  # But the status and control register widths are known.  Go inspect
  # the bit defs to figure those widths out.
  # [register_name, bit_name, bit_pos, comment]
  # my @bits = get_slave_port_bit_definitions();
  my @controlbits = get_control_bits();
  my @statusbits =  get_status_bits();
  
  my $control_register_width = 1 + max(map {$_->[2]} @controlbits);
  my $status_register_width =  1 + max(map {$_->[2]} @statusbits);
  
  my $transaction_size = get_transaction_size_expression();

  # Go figure out a decent default reset value for the control register.
  # I declare that the 'word' and 'leen' bits should be set.
  my $control_default_reset_string = 0;
  map {
    $control_default_reset_string += (($_->[1] =~ /(^word$)|(leen)/) ? 1 << $_->[2] : 0)
  } get_control_bits();

  # Don't change the format of this table without first looking at all its
  # dependencies!

  my @reg_info = (
    [" status register",
      "status",
      $status_register_width,
      "",
      "0",
      "",
      "",
      0,
    ],
    [" read address",
      "readaddress",
      $Options->{readaddresswidth},
      "",
      "dma_ctl_writedata",
      "inc_read",
      " + readaddress_inc",
      0,
    ],
    [" write address",
      "writeaddress",
      $Options->{writeaddresswidth},
      "",
      "dma_ctl_writedata",
      "inc_write",
      " + writeaddress_inc",
      0,
    ],
    [" length in bytes",
      "length",
      # width should be no greater than the max address width, but at least
      # as large as lengthwidth.
      min(
        $::g_max_address_width,
        max(
          $Options->{lengthwidth},
          Encode_Address($Options->{max_slave_address_span}),
        ),
      ),
      "",
      "dma_ctl_writedata",
      "inc_read && (!length_eq_0)",
      $Options->{burst_enable} ? " - length" : " - $transaction_size",
      0,
    ],
    [" reserved",
      "reserved1",
      0,
      "",
      "dma_ctl_writedata",
      "",
      "",
      0,
    ],
    [" reserved",
      "reserved2",
      0,
      "",
      "dma_ctl_writedata",
      "",
      "",
      0,
    ],
    [" control register",
      "control",
      $control_register_width,
      "",
      "dma_ctl_writedata",
      "",
      "",
      $control_default_reset_string,
    ],
    [" control register alternate",
      "reserved3",
      $control_register_width,
      "",
      "dma_ctl_writedata",
      "",
      "",
      $control_default_reset_string,
    ],
  );

  # If there are any over-ride reset values in Options, set them now.
  # Meanwhile, fill in the write-condition expression, using the array
  # position as register address.
  my $index = 0;
  my $control_reg_index = -1;
  my $alt_control_reg_index = -1;
  for my $reg_spec (@reg_info)
  {
    # Most registers have the following default write select.
    $reg_spec->[3] = 
      "dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == $index)";

    $control_reg_index = $index if ($reg_spec->[1] eq "control");
    $alt_control_reg_index = $index if ($reg_spec->[1] eq "reserved3");
    $index++;

    my $name = $reg_spec->[1];
    my $reset_value = $Options->{$name . "_reset_value"};

    if (defined($reset_value))
    {
      $reset_value = eval($reset_value);

      # The width is set to the max here; it'll be fixed up later.
      $reg_spec->[7] = sprintf("%d'h%X", $::g_max_register_width, $reset_value);
    }
  }
  ribbit ("can't find control register\n") if (-1 == $control_reg_index);
  ribbit ("can't find alt_control register\n")
    if (-1 == $alt_control_reg_index);

  # Since I've decided to make an alternate control register, aliased
  # to the control register, let writes to it go to the real control.
  $reg_info[$control_reg_index]->[3] = 
    "dma_ctl_chipselect & ~dma_ctl_write_n & " .
    "((dma_ctl_address == $control_reg_index) || " .
    "(dma_ctl_address == $alt_control_reg_index))";

  # Say, wouldn't it be handy to be able to specify reset values for
  # control register bits by name?  If any such are found, they override
  # the control register reset value.
  my $cleared_bits = ~0;  # That is, all 1-bits.
  my $set_bits = 0;

  # Bleh.  Go grab the current reset value, and convert it back to a decimal
  # number if necessary.
  my $cur_reset = $reg_info[$control_reg_index]->[7];
  $cur_reset =~ s/[0-9]*\'h/0x/g;
  $cur_reset = eval($cur_reset);

  my $i = 0;
  for (get_control_bits())
  {
    my $bitname = $_->[1];  
    my $optionname = "control_" . $bitname . "_reset_value";

    my $override_bit = $Options->{"control_" . $bitname . "_reset_value"};
    if (defined($override_bit))
    {
      if ($override_bit)
      {
        $set_bits |= 1 << $i;
      }
      else
      {
        $cleared_bits &= ~(1 << $i);
      }
    }

    $i++;
  }

  $cur_reset |= $set_bits;
  $cur_reset &= $cleared_bits;

  # A few sanity checks: I'm not going to enforce these at run-time, since
  # that would cost logic, but I might as well prevent silly errors in the
  # ptf-file reset values.  Why allow my gun to point directly at my foot?

  # Only one of byte_access, hw, word
  # should be true.
  my @check_bits = get_transaction_size_bit_indices();

  if (1 != grep {$cur_reset & (1 << $_)} @check_bits)
  {
    ribbit(
      sprintf(
        "Multiple bits set in bogus control register reset value 0x%X\n",
        $cur_reset)
    );
  }

  # The width is set to the max here; it'll be fixed up later.
  $reg_info[$control_reg_index]->[7] =
    sprintf("%d'h%X", $::g_max_register_width, $cur_reset);

  return @reg_info;
}

sub get_control_bits
{
  my @control_bits = (
    ["byte_access",                  "Byte transaction", ],
    ["hw",                    "Half-word transaction", ],
    ["word",                  "Word transaction", ],
    ["go",                    "enable execution", ],
    ["i_en",                  "enable interrupt", ],
    ["reen",                  "Enable read end-of-packet", ],
    ["ween",                  "Enable write end-of-packet", ],
    ["leen",                  "Enable length=0 transaction end", ],
    ["rcon",                  "Read from a fixed address", ],
    ["wcon",                  "Write to a fixed address", ],
    ["doubleword",            "Double-word transaction", ],
    ["quadword",              "Quad-word transaction", ],
    ["softwarereset",         "Software reset - write twice in succession to reset", ],
  );

  # Convert the above simple list into a list of listrefs of the form:
  # [register name, bit name, bit position, comment].
  my $i = 0;
  return map {["control", $_->[0], $i++, $_->[1]]} @control_bits;
}

sub get_status_bits
{
  my @status_bits = (
    [ "done",           "1 when done.  Status write clears.", ],
    [ "busy",           "1 when busy.", ],
    [ "reop",           "read-eop received",],
    [ "weop",           "write-eop received",],
    [ "len",            "requested length transacted",],
  );

  # Convert the above simple list into a list of listrefs of the form:
  # [register name, bit name, bit position, comment].
  my $i = 0;
  return map {["status", $_->[0], $i++, $_->[1]]} @status_bits;
}

sub get_slave_port_bit_definitions
{
  # Bits within registers.  Each list element is a list ref
  # of [register name, bit name, bit position, comment].

  return (get_control_bits(), get_status_bits());  
}

# Look up a register and bit name(s) in the slave port
# bit defs, and return their indices.
sub get_slave_port_bits
{
  my ($reg_name, @bit_names) = @_;

  my @bits = ();

  my @reg_spec;
  {
    $reg_name eq "control" and do {@reg_spec = get_control_bits(); last;};
    $reg_name eq "status"  and do {@reg_spec = get_status_bits();  last;};
  }

  ribbit("bad register-bit request '$reg_name'\n") if !@reg_spec;

  # Where are map and grep when you need them?
  for my $bit_name (@bit_names)
  {
    push @bits, (map {$_->[1] eq $bit_name ? $_->[2] : ()} @reg_spec);
  }

  return undef if (0 + @bits != @bit_names);  
  return @bits;
}

sub get_slave_port_register_indices
{
  my ($Options, @names) = @_;
  my @regs = get_slave_port_registers($Options);
  my @indices;
  
  for my $name (@names)
  {
    my $register_index = '';
    my $i = 0;
    for my $reg (@regs)
    {
      if ($reg->[1] eq $name)
      {
        $register_index = $i;
        last;
      }
      
      $i++;
    }
    
    # Push the index if found, otherwise null string.
    push @indices, $register_index;
  }
  
  return @indices;
}

# Reads are always done at full slave data width - there's no analogy to the
# byte enable signals of a write access.  So, for cases like
#
#  8/16-bit peripheral streaming to 32-bit memory
#  32/16-bit memory streaming to 16/8 bit peripheral
# 
# where the FIFO is written with data of the width of the transaction, that
# is, the minimum size of read and write, we need a data mux.

sub make_read_master_data_mux
{
  # If all slaves on the read side are non-latent, then the mux select is just
  # the low bits of the read address.  If any slave is latent, then load a
  # 2-bit counter on read_address write, and increment it synchronously on
  # readdatavalid. What the heck, I'll throw this stuff in in all cases.
  # Future optimization: trim the unnecessary address counter if all read
  # slaves have latency=0.

  my ($Options, $module, $project) = @_;

  my $read_data_mux_module = e_module->new({
    name => $module->name() . "_read_data_mux",
  });

  my @contents = ();

  my $mux_select_bits = log2($Options->{readdatawidth} / 8);
  if (get_allowed_transactions() == 1 or $mux_select_bits == 0)
  {
    # Special case: only one possible transaction.  Don't make a mux (it
    # would be a pretty simple mux, selected by the transaction-size bit
    # alone).  I can make it even simpler: a plain old assignment.
    # Also, there's a degenerate case: readdatawidth (and fifodatawidth) are 8.
    # Only byte transactions are possible. No mux is necessary!
    push @contents, 
      e_assign->new({
        lhs => "fifo_wr_data[@{[$Options->{readdatawidth} - 1]} : 0]",
        rhs =>  "read_readdata[@{[$Options->{readdatawidth} - 1]} : 0]",
      });
  }
  else
  {
    # General case: 
    my $address_select_range = "0";
    if ($mux_select_bits > 1)
    {
      $address_select_range = "@{[$mux_select_bits - 1]}: 0";
    }

    push @contents, (
      e_signal->new({name => "readdata_mux_select", width => $mux_select_bits,}),
    );

    # always generate mux logic for readdata_mux_select
      # Grab the memory map.  
      my @reg_info = get_slave_port_registers($Options);

      # Get the locations of the control, readaddress and length registers.
      my ($control_index, $readaddress_index, $length_index) =
        get_slave_port_register_indices($Options, "control", "readaddress", "length");

      ribbit("No control register!") if ('' eq $control_index);
      ribbit("No readaddress register!") if ('' eq $readaddress_index);
      ribbit("No readaddress register!") if ('' eq $length_index);

      push @contents, (
        e_assign->new([
          e_signal->new(["control_write"]), $reg_info[$control_index]->[3]
        ]),
      );
      push @contents, (
        e_assign->new([
          e_signal->new(["length_write"]), $reg_info[$length_index]->[3]
        ]),
      );

      # Look up the bit number of the go bit in the control register.
      my ($go_bit_pos) = get_slave_port_bits("control", "go");
      ribbit("no go bit!\n") if (!defined($go_bit_pos));

      # Get the indices of the transaction size bits within the control register.
      my @trans_bits = get_transaction_size_bit_indices();

      # Figure out the reset value of the bits of the readaddress register
      # which correspond to the transaction-size bits.
      my $readaddress_reset_val = $reg_info[$readaddress_index]->[7];
      $readaddress_reset_val =~ s/([0-9]*)\'h/0x/g;
      $readaddress_reset_val = hex($readaddress_reset_val);

      if ($readaddress_reset_val)
      {
        # If non-zero reset value, AND against the mux select bits.
        $readaddress_reset_val .=
          sprintf(" & %d\'b%s", $mux_select_bits, '1' x $mux_select_bits);
      }        

      # Right, so how about a loadable counter, incremented by the current
      # transaction size when readdatavalid is true?  This counter resets
      # to the same value as the readaddress register, and is written with the
      # readaddress register contents whenever the go bit is written. 
      # Whenever readdatavalid is true, the register increments by the same
      # value that the readaddress increments by.
      # SPR 170912: also reset the counter when the length register is written.
      push @contents, (
        e_mux->new({
          lhs => e_signal->new({name => "read_data_mux_input", width => $mux_select_bits,}),
          table => [
            "control_write && dma_ctl_writedata[$go_bit_pos] || length_write",
            "readaddress[1:0]",

            "read_readdatavalid",
            "readdata_mux_select + readaddress_inc",
          ],
          default => "readdata_mux_select",
          type           => "priority",
        }),
        e_register->new({
          comment =>
            " Reset value: the transaction size bits of the read address reset value.",
          out => "readdata_mux_select",
          in => "read_data_mux_input[$address_select_range]",
          async_value => $readaddress_reset_val,
        }),
      );

    # Define a read-data mux.  This routes data from the read data
    # bus into the fifo.  It's possible that the read data bus is
    # wider than the fifo, but the fifo cannot be wider than the
    # read data bus (the fifo data width is the minimum of the
    # read- and write-data bus widths).

    # The structure of the mux depends on:
    # $Options->{readdatawidth}
    # $Options->{fifodatawidth}
    # The mux select input is based on
    # readdata_mux_select and the current transaction size.

    # Loop over each allowed transaction size.
    # Optimization alert: disallow small transaction sizes to avoid generating
    # lots of mux logic.
    # 
    # Optimization alert: generate <fifodatawidth> 1-bit muxes.  The LSBs of the 
    # current mux have many terms which the MSBs lack, which I try to express
    # as don't cares, but I'm not sure how well the synthesizer will take
    # this info into account.

    push @contents, e_signal->new({
      name => "fifo_wr_data",
      width => $Options->{fifodatawidth},
    });

    # Get transaction bit names in least-significant order first.
    my @trans_names = reverse get_transaction_size_bit_names();
    my $msb = $Options->{fifodatawidth} - 1;
    my $lsb = $Options->{fifodatawidth} / 2;

    while (1)
    {
      # Make a mux for fifo_wr_data[$msb : $lsb]
      my @mux_table;

      for my $trans_index (0 .. @trans_names - 1)
      {
        my $trans_name = $trans_names[$trans_index];
        next if not is_transaction_allowed($trans_name);

        my $trans_size_in_bits = transaction_size_in_bits($trans_name);

        next if $trans_size_in_bits <= $lsb;

        my $multiple = $Options->{readdatawidth} / $trans_size_in_bits;
        my $mux_select_msb = log2($Options->{readdatawidth} / 8) - 1;
        my $mux_select_lsb = $trans_index;
        my $mux_select;
        if ($mux_select_msb >= $mux_select_lsb)
        {
          $mux_select = "readdata_mux_select[$mux_select_msb : $mux_select_lsb]";
        }

        for my $i (0 .. $multiple - 1)
        {
          my $select = $trans_name;
          if ($mux_select)
          {
            $select .= " & ($mux_select == $i)";
          }
          my $basic_selection = 
            "read_readdata[@{[$i * $trans_size_in_bits + $msb]} : @{[$i * $trans_size_in_bits + $lsb]}]";
          my $full_selection;
          my $excess_bits = $Options->{fifodatawidth} - $trans_size_in_bits;

          my $top_half = sprintf("read_readdata[%d : %d]", 
            $Options->{fifodatawidth} - 1, $Options->{fifodatawidth} / 2);
          my $dont_care_part;
          my $dont_care_bits = $excess_bits - $Options->{fifodatawidth} / 2;
          if ($dont_care_bits > 0)
          {
            $dont_care_part =
              sprintf("{%d{1'b%s}}, ", $dont_care_bits, $::g_dont_care_value);
          }
          push @mux_table, ($select, $basic_selection);
        }

      }
      # If the mux table contains only one term, emit a straight assignment instead.
      if (@mux_table == 2)
      {
        push @contents, 
          e_assign->new({
            lhs  => "fifo_wr_data[$msb : $lsb]",
            rhs => $mux_table[1],
          });
      }
      else
      {
        # More than one term: make a real mux.
        push @contents, 
          e_mux->new({
            lhs  => "fifo_wr_data[$msb : $lsb]",
            type => "and_or",
            table => \@mux_table,
          });
      }
      # Get the msb and lsb for the next segment.  This code is oddly complicated,
      # due to the fact that lsb = 0 is a weird special case in the sequence, which 
      # goes 64, 32, 16, 8, ... -> 0 instead of 4 <-
      last if $lsb == 0;
      $msb -= $lsb;
      $lsb /= 2;
      $lsb = 0 if $lsb < 8;
    }
  }

  $read_data_mux_module->add_contents(@contents);
  return e_instance->new({module => $read_data_mux_module});
}

sub make_registers
{
  my ($module, $Options) = @_;

  my $burst_enable = $Options->{burst_enable};

Progress("DMA burst enable state: $burst_enable") if $Options->{europa_debug};

  # Grab the memory map.  
  my @reg_info = get_slave_port_registers($Options);

  # Make a control register process for each register descriptor
  # in the list.
  my @write_regdesc;
  my $length_index = -1;
  for my $i (0 .. @reg_info - 1)
  {
    my $reg = $reg_info[$i];

    # Special case: don't generate the status register: it's composed
    # of individual register bits, which are assigned to the signal
    # 'status' for export.
    if ($reg->[1] eq "status")
    {
      # We don't need a register for status (it's composed of various
      # register bits) but while we're here, make a handy status-write
      # signal.
      $module->add_contents(
        e_assign->new({
          lhs => e_signal->new(["status_register_write"]),
          rhs =>
            "dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == $i)",
        }),
      );

      next;
    }

    # Special case: "reserved3" is just an alias of "control", and has
    # no hardware existence except for an extra address that decodes to
    # control.
    next if ($reg->[1] eq "reserved3");

    # The writelength register isn't visible to the programmer, but it
    # behaves like an ordinary register in all other ways. It's very
    # similar to the length register, so make a copy of that 
    # info when that register passes by.
    if ($reg->[1] eq "length")
    {
      $length_index = $i;
      @write_regdesc = @{$reg};
    }

    $module->add_contents(
      control_register(@{$reg})
    );
  }

  ribbit ("length not found: can't make writelength register!\n")
    if (!@write_regdesc or ($length_index == -1));

  # Now make some small modifications to writelength.
  $write_regdesc[0] = " write master length";
  $write_regdesc[1] = "writelength";
  $write_regdesc[5] = "inc_write && (!writelength_eq_0)";
  $write_regdesc[6] = " - " . get_transaction_size_expression();
  $module->add_contents(control_register(@write_regdesc));

  # In the FSMs, I need to know one cycle ahead of time if the
  # length and writelength registers will be 0.  Make handy signals
  # for that condition.
  $module->add_contents(
    e_assign->new({
      lhs => e_signal->new({name => "p1_writelength_eq_0",}),
      rhs => "$write_regdesc[5] && ((writelength $write_regdesc[6]) == 0)",
    }),
    e_assign->new({
      lhs => e_signal->new({name => "p1_length_eq_0",}),
      rhs => "$reg_info[$length_index]->[5] && " .
        "((length $reg_info[$length_index]->[6]) == 0)",
    }),
  );

  # Create registered "length equals 0" and "writelength equals 0" signals.
  # Note: if the user writes 0 into the length register, length_eq_0 will 
  # momentarily go false.

  # Ugh. As always, remember to convert those reset values from verilog constants
  # into perl numbers.
  my $length_reset_as_number;
  ($length_reset_as_number = $reg_info[$length_index]->[7]) =~ s/[0-9]*\'h/0x/g;
  $length_reset_as_number = eval($length_reset_as_number);

  my $writelength_reset_as_number;
  ($writelength_reset_as_number = $write_regdesc[7]) =~ s/[0-9]*\'h/0x/g;
  $writelength_reset_as_number = eval($writelength_reset_as_number);

  $module->add_contents(
    e_register->new({
      out => "length_eq_0",
      async_value => 0 + ($length_reset_as_number == 0),
      sync_set => "p1_length_eq_0",
      sync_reset => $reg_info[$length_index]->[3],
    }),
    e_register->new({
      out => "writelength_eq_0",
      async_value => 0 + ($writelength_reset_as_number == 0),
      sync_set => "p1_writelength_eq_0",
      sync_reset => $write_regdesc[3],
    }),
  );

  # The increment next values of the read and write addresses are
  # determined as follows:
  # if the addr_constant bit is 1, the increment is 0.
  #  otherwise, 
  # if the increment register is 0, the 
  #   increment is determined by the control register bits
  #   {word, hw, byte_access}.
  #  otherwise
  # the increment value is set by the increment register.

  # Most users will never need to override the increment values
  # with readincov and writeincov.  Therefore, if (read|write)incovwidth
  # is set to 0, that register doesn't get implemented.  To handle both
  # cases and allow Leo to remove lots of logic, created a
  # (read|write)incov_eq_0 register which is
  # - constant 1, if the register has 0 width
  # - otherwise, latched with the appropriate value when the register is
  #   written.

  if ($Options->{readincovwidth})
  {
    my $is0_p1_rhs;
    my $readinc_index = -1;
    map {
      $readinc_index = $_ if ($reg_info[$_]->[1] eq "readincov")
    } (0 .. -1 + @reg_info);
    ribbit("no readincov register!") if $readinc_index == -1;

    my $incov_clken = $reg_info[$readinc_index]->[3];
    my $reset_val;
    ($reset_val = $reg_info[$readinc_index]->[7]) =~ s/[0-9]*\'h/0x/g;
    $reset_val = eval($reset_val);
    my $async_val = $reset_val == 0 ? "1" : "0";

    $is0_p1_rhs =
      sprintf("dma_ctl_writedata[%d:0] == 0", $Options->{readincovwidth} - 1);
    $module->add_contents(
      e_assign->new({
        lhs => e_signal->new({
          name => "p1_readincov_eq_0", never_export => 1,
        }),
        rhs => $is0_p1_rhs,
      }),
      e_register->new({
        out => "readincov_eq_0",
        in => "p1_readincov_eq_0",
        enable => $incov_clken,
        async_value => $async_val,
      }),
    );
  }

  if ($Options->{writeincovwidth})
  {
    my $is0_p1_rhs;
    my $writeinc_index = -1;
    map {
      $writeinc_index = $_ if ($reg_info[$_]->[1] eq "writeincov")
    } (0 .. -1 + @reg_info);
    ribbit("no writeincov register!") if $writeinc_index == -1;

    my $incov_clken = $reg_info[$writeinc_index]->[3];
    my $reset_val;
    ($reset_val = $reg_info[$writeinc_index]->[7]) =~ s/[0-9]*\'h/0x/g;
    $reset_val = eval($reset_val);
    my $async_val = $reset_val == 0 ? "1" : "0";

    $is0_p1_rhs = sprintf("dma_ctl_writedata[%d:0] == 0",
      $Options->{writeincovwidth} - 1);

    $module->add_contents(
      e_assign->new({
        lhs => ["p1_writeincov_eq_0", 1, 0, 1],
        rhs => $is0_p1_rhs,
      }),
      e_register->new({
        out                => ["writeincov_eq_0", 1, 0, 1],
        in                 => "p1_writeincov_eq_0",
        enable             => $incov_clken,
        async_value        => $async_val,
      }),
    );
  }

  my $transaction_size = get_transaction_size_expression();

  my @top_priority =
    $Options->{writeincovwidth} ? ("~writeincov_eq_0", "writeincov") : ();

  $module->add_contents(
    e_mux->new({
      lhs => e_signal->new({
        name => "writeaddress_inc",
        # The increment width is at least the number of transaction-size bits
        # in the control register, but can be as large as the override.
        width => max(
          scalar(get_transaction_size_bit_indices()),
          $Options->{writeincovwidth}
        ),
      }),
      type           => "priority",
      table          => [
        @top_priority,
        "wcon", "0",
        "$burst_enable", "0",
      ],
      default => "$transaction_size",
    }),
  );

  @top_priority =
    $Options->{readincovwidth} ? ("~readincov_eq_0", "readincov") : ();
  $module->add_contents(
    e_mux->new({
      lhs => e_signal->new({
        name => "readaddress_inc",
        # The increment width is at least the number of transaction-size bits
        # in the control register, but can be as large as the override.
        width => max(
          scalar(get_transaction_size_bit_indices()),
          $Options->{readincovwidth}
        ),
      }),
      type           => "priority",
      table          => [
        @top_priority,
        "rcon", "0",
        "$burst_enable", "0",
      ],
      default => "$transaction_size",
    }),
  );

  # How about a nice read-data mux?
  my @muxtable = ();
  for (my $i = 0; $i < @reg_info; ++$i)
  {
    # Skip "reserved" registers.
    next if $reg_info[$i]->[1] =~ /reserved/;

    # Skip any register with width 0.
    next if $reg_info[$i]->[2] == 0;

    # Register select.
    push @muxtable, "dma_ctl_address == $i";

    # Selected register name.
    my $reg_name = @{$reg_info[$i]}->[1];

    # Special case: when "reserved3" is read, you get "control".
    $reg_name = "control" if ($reg_name eq "reserved3");

    # Special case: when "length" is read, you get
    # writelength instead.  That's because the value in the
    # (user-invisible) writelength register keeps track of 
    # transfers which are fully completed, while length
    # can run ahead a bit.
    $reg_name = "writelength" if ($reg_name eq "length");

    push @muxtable, $reg_name;
  }

  my $data_width = get_slave_port_data_width($Options);

  $module->add_contents(
    e_mux->new({
      lhs => ["p1_dma_ctl_readdata", $data_width, ],
      type => "and_or",
      table => \@muxtable,
    }),
    e_register->new({
      in => "p1_dma_ctl_readdata",
      out => "dma_ctl_readdata",
    }),
  );

  $module->add_contents(
    e_assign->new({
      lhs => e_signal->new({name => "done_transaction", width => 1}),    
      rhs => "go & done_write",
    })
  );

  $module->add_contents(
    e_register->new({
      out                => "done",
      sync_set           => "done_transaction & ~d1_done_transaction",
      sync_reset         => "status_register_write",
      clock              => "clk",
      async_value        => 0,
    }),
  );

  $module->add_contents(
    e_register->new({
      out                => "d1_done_transaction",
      in                 => "done_transaction",
      clock              => "clk",
      async_value        => 0,
    }),
  );

  $module->add_contents(
    e_assign->new({
      lhs => e_signal->new({name => "busy", width => 1}),
      rhs => "go & ~done_write",
    })
  );

  # Pull the status and control bits out into their own lists,
  # indexed by bit number.
  my @status_bits;
  map {
    # $_ = ["reg_name", "bit_name", "bit_pos", "comment"];
    $status_bits[$_->[2]] = $_->[1];
  } get_status_bits();

  my @control_bits;
  map {
    # $_ = ["reg_name", "bit_name", "bit_pos", "comment"];
    $control_bits[$_->[2]] = $_->[1];
  } get_control_bits();

  $module->add_contents(
    e_signal->new({
      name => "status",
      width => 0 + @status_bits,
      never_export => 1,
    }),
  );

  # Assign each status bit from its status reg.
  for my $i (0 .. @status_bits - 1)
  {
    $module->add_contents(
      e_assign->new({
        rhs => "$status_bits[$i]",
        lhs => "status[$i]",
      })
    );
  }

  # Assign random control bit signals from the control register.    
  for my $i (0 .. @control_bits - 1)
  {
    my $bit_name = $control_bits[$i];
    my $rhs = "control[$i]";
    if ($Options->{burst_enable} && ($bit_name =~ /^[rw]een$/))
    {
      # Bursting DMAs are not allowed to terminate early on
      # write endofpacket events (doing so would violate the 
      # burst master rule that all requested burst transactions
      # must be done - in all likelihood, the result would be system
      # lockup).  To avoid this, prevent the ween bit from being set.
      # Also prevent the reen bit from being set, because I can't see
      # any use in setting reen on a read burst.
      $rhs = "1'b0";
    }
    $module->add_contents(
      e_assign->new({
        lhs => e_signal->new({
          name => $bit_name,
          never_export => 1
        }),
        rhs => $rhs,
      })
    );
  }

  # How about an IRQ output?
  $module->add_contents(
    e_assign->new({
      lhs => "dma_ctl_irq",
      rhs => "i_en & done",
    })
  );
}

sub push_global_ports
{
  my $module = shift;

  $module->add_contents(
    e_port->new({name => "clk", type => "clk",}),
    e_port->new({name => "system_reset_n", type => "reset_n",}),


  );
}


sub get_control_interface_map
{
  my $Options = shift;

  # Even master-less DMAs need these signals.
  my @map = (
    "dma_ctl_irq" => "irq",
#    "dma_ctl_readyfordata" => "readyfordata",
  );

#  if (@{$Options->{masters_of_my_slave_port}})
#  {
    # If the slave port has master(s), these ports are also needed.
    push @map, (
      "dma_ctl_chipselect" => "chipselect",
      "dma_ctl_address" => "address",
      "dma_ctl_write_n" => "write_n",
      "dma_ctl_writedata" => "writedata",
      "dma_ctl_readdata" => "readdata",
      "clk" => "clk",
      "system_reset_n" => "reset_n",
    );
#  }

  return @map;
}

#sub modify_burst_system_ptf_asssignments {
#  my ($project, $module, $Options) = @_;
#
#  my $max_burst_size = $Options->{burst_enable} ? $Options->{max_burst_size} : 1;
#  my $module_name = $module->name();
#  my $sys_ptf = $project->system_ptf();
#
#  $sys_ptf->
#    {"MODULE $module_name"}->
#    {"MASTER $write_master_name"}->
#    {"SYSTEM_BUILDER_INFO"}->{Maximum_Burst_Size} = $max_burst_size;
#  $sys_ptf->
#    {"MODULE $module_name"}->
#    {"MASTER $read_master_name"}->
#    {"SYSTEM_BUILDER_INFO"}->{Maximum_Burst_Size} = $max_burst_size;
#}

sub push_control_interface_ports
{
  my ($project, $module, $Options) = @_;

  my $data_width = get_slave_port_data_width($Options);
  my $addr_width = get_slave_port_addr_width($Options);

  # While we're here, why not update the SBI section of the slave?
  # It's got probably-reasonable values from the class.ptf, but it
  # will be wrong if e.g. there's a large read- or write-address port.
  my $module_name = $module->name();
  #my $sys_ptf = $project->system_ptf();

  #my $slave_sbi =
  #  $sys_ptf->
  #  {"MODULE $module_name"}->
  #  {"SLAVE $control_port_name"}->
  #  {"SYSTEM_BUILDER_INFO"};
  #ribbit("what th'?") if (!$slave_sbi);
  #
  #$slave_sbi->{Data_Width} = $data_width;
  #$slave_sbi->{Address_Width} = $addr_width;

#  if (@{$Options->{masters_of_my_slave_port}})
#  {
    $module->add_contents(
      e_port->new({name => "dma_ctl_irq", type => "irq", direction => "output"}),
    );

#Removed from top level port
#    $module->add_contents(
#      e_port->new({
#        name => "dma_ctl_readyfordata",
#        type => "readyfordata",
#        direction => "output"
#      }), 
#      e_assign->new(["dma_ctl_readyfordata", "~busy"]),
#    );

    $module->add_contents(
      e_port->new({name => "dma_ctl_chipselect", type => "chipselect",}),
      e_port->new({
        name => "dma_ctl_address", type => "address", width => $addr_width,
      }),
      e_port->new({name => "dma_ctl_write_n", type => "write_n",}),
      e_port->new({
        name => "dma_ctl_writedata",
        width => $data_width,
        type => "writedata",
      }),
      e_port->new({
        name => "dma_ctl_readdata",
        width => $data_width,
        type => "readdata",
        direction => "output",
      },),
    );    
#  }
#  else
#  {
#    # No masters.  Generate a minimal port set; generate default-level signals
#    # for other control signals.
#    $module->add_contents(
#      e_port->new({
#        name => "dma_ctl_readyfordata",
#        direction => "output"
#      }), 
#      e_assign->new(["dma_ctl_readyfordata", "~busy"]),
#      e_port->new({name => "dma_ctl_irq", direction => "output"}),
#      e_assign->new([
#        e_signal->new(["dma_ctl_chipselect", 1, 0, 1,]), 0
#      ]),
#      e_assign->new([
#        e_signal->new(["dma_ctl_address", $addr_width, 0, 1]), 0
#      ]),
#      e_assign->new([
#        e_signal->new(["dma_ctl_write_n", 1, 0, 1,]),    1
#      ]),
#      e_assign->new([
#        e_signal->new(["dma_ctl_writedata", $data_width, 0, 1]), 0
#      ]),
#      e_signal->new([
#        "dma_ctl_readdata",                 $data_width, 0, 1
#      ]),
#    );
#  }
}

sub get_read_master_type_list
{
  return qw(
    readdata
    readdatavalid
    read_n
  );
}

sub get_write_master_type_list
{
  return qw(
    write_n
    writedata
    byteenable
  );
}

sub get_master_type_list
{
  my $Options = shift;
  my $burst_enable = $Options->{burst_enable};

  my @master_type_list = qw(
    address
    chipselect
    waitrequest
    endofpacket
  );
  push @master_type_list, "burstcount" if $burst_enable;
  return @master_type_list;
}

sub get_write_master_type_map
{
  my $Options = shift;
  ribbit("no Options hash\n") if (!$Options);

  my $port_prefix = 'write';

  my @types = get_master_type_list($Options);

  # Add in all write-master-specific ports.  Omit
  # byteenable if there ain't none.
  push @types,
    grep {has_byteenables($Options) or $_ ne 'byteenable'}
      get_write_master_type_list();

  # Make a hash of $port_prefix . "_" . $type[] => $type[].
  return map {($port_prefix . "_$_" => $_)} @types;
}

sub get_read_master_type_map
{
  my $Options = shift;
  ribbit("no Options hash\n") if (!$Options);

  my $port_prefix = 'read';

  my @types = get_master_type_list($Options);
  push @types, get_read_master_type_list();

  # Make a hash of $port_prefix . "_" . $type[] => $type[].
  return map {($port_prefix . "_$_" => $_)} @types;
}

sub has_byteenables
{
  my $Options = shift;

  # We need byteenables if more than one transaction size
  # is allowed.
  my $has_byteenables = scalar(get_allowed_transactions()) > 1;

  return $has_byteenables;
}

# This is the point where the transaction size bits have an impact.
# The write master sends out its byte address as always, but must modulate
# the byte enables according to  1) the lower address bits and 2) the
# transaction size.

# The maximum number of bytes transferred in one write is equal to the 
# number represented by '1' in the most-significant transaction size bit,
# and '0' in all other bits.

# Loop over all possible transaction sizes.  Note that the number of
# byteenables (related to the write port data width) determines the
# maximum transaction size.  Example: if the write data port is 32 bits,
# there are 4 byte enables and the max transaction size is 4 bytes aka
# 'word'.

sub make_write_byteenables
{
  my ($Options, $module, $project) = @_;
  my $port_prefix = 'write';
  my $num_byteenables = $Options->{writedatawidth} / 8;

  # SPR 12225.
  return () if not has_byteenables($Options);

  my $byteenable_module = e_module->new({
    name => $module->name() . "_byteenables",
  });

  my @contents = ();

  my @muxtable;
  # Get transaction bit names, least-significant first.
  my @trans_bit_names = get_transaction_size_bit_names();

  # Optimization alert: it sure seems that I ought to be able to drop the all-1's
  # case from the byteenable mux.
  for (my $trans_size = 1; $trans_size <= $num_byteenables; $trans_size <<= 1)
  {
    # Each time through this loop, push a pair of values into muxtable.
    # Value 1: selector (simply the name of the transaction size bit for
    # this transaction size).
    # Value 2: an expression for the byteenable signal, depending on
    # the address and the current transaction size.
    my $trans_bit_name = pop @trans_bit_names;
    ribbit("unexpected error") if !$trans_bit_name;

    next if !is_transaction_allowed($trans_bit_name);

    ribbit("ran out of transaction bit names!") if !$trans_bit_name;

    my $be_expression;

    # Log(multiplier) tells you how many address bits the elements of the 
    # byteenable expression depend on.
    my $num_important_address_bits = log2($num_byteenables / $trans_size);
    if ($num_important_address_bits == 0)
    {
      $be_expression =
        sprintf("%d'b%s", $num_byteenables, '1' x $num_byteenables);
    }
    else
    {
      my @terms;
      my $address_msb = log2($num_byteenables) - 1;
      my $address_lsb = $address_msb - $num_important_address_bits + 1;

      my $addr_sel =
        $address_msb == $address_lsb ? "$address_msb" : "$address_msb : $address_lsb";
      my $addr_sel_for_signal;
      ($addr_sel_for_signal = $addr_sel) =~ s/ : /_to_/;
      my $sig_name_prefix = "wa_$addr_sel_for_signal\_is_";

      my %sel_signals;  # Avoid redundant signal names.      
      for my $sel (reverse(0 .. $num_byteenables - 1))
      {
        my $sig_name = "$sig_name_prefix@{[$sel >> $address_lsb]}";
        if (!defined($sel_signals{$sig_name}))
        {
          # Create the signal.
          push @contents, e_assign->new({
            lhs => [$sig_name, 1,],
            rhs => sprintf("($port_prefix\_address\[$addr_sel] == %d'h%X)",
              $num_important_address_bits, $sel >> $address_lsb),
          });

          # Remember that this signal has been created.
          $sel_signals{$sig_name} = 1;
        }
        push @terms, $sig_name;
      }
      # Concatenate all terms.
      $be_expression = "{@{[join(', ', @terms)]}}";

    }
    if (get_allowed_transactions() > 1)
    {
      push @muxtable, ($trans_bit_name, $be_expression);
    }
    else
    {
      # Instead of a mux, a simple assignment.
      push @contents, (
        e_assign->new({
          lhs => "$port_prefix\_byteenable",
          rhs => $be_expression,
        }),
      );
    }
  }

  if (get_allowed_transactions() > 1)
  {
    push @contents, (
      e_mux->new({
        lhs => "$port_prefix\_byteenable",
        table => \@muxtable,
        type => "and_or",
      }),
    );
  }

  $byteenable_module->add_contents(@contents);

  return e_instance->new({module => $byteenable_module});

}

sub get_write_master_ports
{
  my ($Options, $burst_enable, $max_burstcount_width) = @_;
  my $port_prefix = 'write';
  my @ports = get_master_ports($Options, $port_prefix);

  # SPR 12225.  
  if (has_byteenables($Options))
  {
    my $num_byteenables = $Options->{writedatawidth} / 8;

    push @ports, (
      e_port->new({
        name => $port_prefix . "_byteenable",
        width => $num_byteenables,
        direction => "output",
        type => 'byteenable',
      }),
    );
  }

  push @ports, (
    e_port->new({
      name => $port_prefix . "_address",
      direction => "output",
      width => $Options->{writeaddresswidth},
      type => 'address',
    }),

    e_port->new({
      name => $port_prefix . "_writedata",
      direction => "output",
      width => $Options->{writedatawidth},
      type => 'writedata',
    }),

    e_port->new({
      name => $port_prefix . "_write_n",
      direction => "output",
      type => 'write_n',
    }),

  );

  push @ports, (
    e_port->new({
      name => $port_prefix . "_burstcount",
      type => "burstcount",
      direction => "output",
      width => "$max_burstcount_width"
    })
   ) if ($burst_enable);

  return @ports;
}

sub get_read_master_ports
{
  my ($Options, $burst_enable, $max_burstcount_width) = @_;
  my $port_prefix = 'read';
  my @ports = get_master_ports($Options, $port_prefix);

  push @ports, (
    e_port->new({
      name => $port_prefix . "_address",
      direction => "output",
      width => $Options->{readaddresswidth},
      type => 'address',
    }),

    e_port->new({
      name => $port_prefix . "_readdata",
      direction => "input",
      width => $Options->{readdatawidth},
      type => 'readdata',
    }),

    e_port->new({
      name => $port_prefix . "_read_n",
      direction => "output",
      type => 'read_n',
    }),

    e_port->new({
      name => $port_prefix . "_readdatavalid",
      direction => "input",
      type => 'readdatavalid',
    }),

#    e_port->new({
#      name => $port_prefix . "_flush",
#      direction => "output",
#      type => 'flush',
#    }),
  );

  push @ports, (
    e_port->new({
      name => $port_prefix . "_burstcount",
      type => "burstcount",
      direction => "output",
      width => "$max_burstcount_width"
    })
  ) if ($burst_enable);

  return @ports;
}

sub get_master_ports
{
  my ($Options, $port_prefix) = @_;

  my @master_ports = (
    e_port->new({
      name => $port_prefix . "_chipselect",
      direction => "output",
      type => 'chipselect',
    }),
    e_port->new({
      name => $port_prefix . "_waitrequest",
      direction => "input",
      type => 'waitrequest',
    }),
    e_port->new({
      name => $port_prefix . "_endofpacket",
      direction => "input",
      type => 'endofpacket',
    })
  );
  return @master_ports;
}

sub make_fifo
{
  my ($top_module, $Options) = @_;

  $top_module->add_contents(
    e_assign->new([
      "flush_fifo",
      "~d1_done_transaction & done_transaction"
    ]),
  );

  my $fifo_module = e_fifo->new({
    device_family => $Options->{device_family},
    name_stub => $top_module->name(),
    data_width => $Options->{fifodatawidth},
    fifo_depth => $Options->{fifo_depth},
    flush => "flush_fifo",
    full_port => 0,
    p1_full_port => 1,
    empty_port => 1,
    implement_as_esb => $Options->{fifo_in_logic_elements} ? 0 : 1,
    Read_Latency => $Options->{fifo_read_latency},
  });

  return $fifo_module;
}

sub make_fsm
{
  my (
    $name,
    $go,
    $p1_done,
    $mem_wait,
    $p1_fifo_stall,
    $select,
    $access_n,
    $inc,
    $fifo_access,
    $extra_latency,
    ) = @_;

  my $fsm = e_fsm->new({
    name => $name,
    start_state => "idle",
  });

  # Registered outputs for memory control.
  my $p1_select = "p1_" . $select;
  $fsm->add_contents(
    e_signal->new({
      name => $p1_select, never_export => 1,
    }),
    e_assign->new({
      lhs => e_signal->new({name => $access_n, export => 1,}),
      rhs => "~$select",
    }),
    e_register->new({
      delay => 1 + $extra_latency,
      in => $p1_select,
      out => e_signal->new({name => $select, never_export => 1,}),
    }),
  );

  # Optional fifo-access output - same as $inc.
  if ($fifo_access)
  {
    $fsm->add_contents(
      e_signal->new({name => $inc, export => 1,}),

      e_assign->new({
        lhs => e_signal->new({name => $fifo_access,}),
        rhs => "$name\_access & ~$mem_wait",
      }),
    );
  }

  $fsm->OUTPUT_DEFAULTS({
    $p1_select => 0,
  });
  $fsm->OUTPUT_WIDTHS({
    $p1_select => 1,
  });

  $fsm->add_state(
    "idle",
    [
      {$go => 0,},
      "idle",
      {}
    ],
    [
      {$p1_done => 1,},
      "idle",
      {}
    ],
    # Loop while the fifo forces a stall.
    [
      {$p1_fifo_stall => 1,},
      "idle",
      {}
    ],
    [
      # Go off to do an access.
      # Note extra latency here: p1_fifo_stall = 0 means that it would
      # be safe to do an access to a latent peripheral now, because there
      # will be room by the time the new data arrives.  But, since select
      # is registered, it takes one more cycle to make the request.  Seems
      # like this could be optimized, but it might cause trouble with
      # reads of non-latent slaves.
      {
        $go => 1,
        $p1_done => 0,
        $p1_fifo_stall => 0,
      },
      "access",
      {$p1_select => 1,},
    ],
  );

  $fsm->add_state(
    "access",

    # FIFO stalls: wait in idle.
    [
      {$p1_fifo_stall => 1, $mem_wait => 0,},
      "idle",
      {},
    ],

    # When finished, go back to idle.
    [
      {$p1_done => 1, $mem_wait => 0,},
      "idle",
      {},
    ],

    # If the memory says "wait", wait!
    [
      {$mem_wait => 1, },
      "access",
      {$p1_select => 1,},
    ],

    # Streaming right along... do another access.
    [
      {
        $mem_wait => 0,
        $p1_fifo_stall => 0,
        $p1_done => 0,
      },
      "access",
      {$p1_select => 1,},
    ],
  );

  # Special case: dumb e_fsm can't figure out how to make this expression
  # without a combinational logic loop, but I can.
  $fsm->add_contents(
    e_assign->new({
      # comment => " $inc is active in state $name\_access, unless $mem_wait is high.",
      lhs => [$inc, 1,],
      rhs => "$select & ~$mem_wait",
    }),
  );

  return $fsm;
}

sub make_write_machine
{
  my ($Options, $name) = @_;

  # Given
  #
  #   write_waitrequest
  #   fifo_datavalid
  #
  # generate 
  #
  #   fifo_read
  #   inc_write
  #   mem_write_n
  #   write_select
  #
  my $write_fsm_module = e_module->new({
    name => $name,
  });

  $write_fsm_module->add_contents(
    e_assign->new({
      lhs => e_signal->new({name => "write_select", export => 1,}),
      rhs => 'fifo_datavalid & ~d1_enabled_write_endofpacket',
    }),
    e_assign->new({
      lhs => e_signal->new({name => "mem_write_n", export => 1,}),
      rhs => "~write_select",
    }),
    e_assign->new({
      lhs => e_signal->new({name => "fifo_read", export => 1,}),
      rhs => "write_select & ~write_waitrequest",
    }),
    e_assign->new({
      lhs => "inc_write",
      rhs => "fifo_read",
    }),
  );

  return $write_fsm_module;
}

sub make_fsms
{
  my ($top_module, $Options) = @_;

  # Create three state machines:
  # 1) reads memory
  # 2) writes to FIFO when data arrives
  # 3) reads from FIFO, writes to memory.

  # READ FSM (read memory, write to FIFO):
  # Inputs:
  #  go
  #  p1_done_read
  #  read_waitrequest
  #  p1_fifo_full
  #
  # Outputs:
  #  read_select
  #  mem_read_n
  #  inc_read
  #

  my $fsm_read = make_fsm(
    $top_module->name() . "_mem_read",
    "go",
    "p1_done_read",
    "read_waitrequest",
    "p1_fifo_full",
    "read_select",
    "mem_read_n",
    "inc_read"
  );

  $top_module->add_contents(
    e_instance->new({
      name => "the_" . $fsm_read->name(),
      module => $fsm_read,
    })
  );

  $top_module->add_contents(
    e_assign->new({
      lhs => "fifo_write",
      rhs => "fifo_write_data_valid",
    }),
  );
  
  $top_module->add_contents(
    e_assign->new({
      lhs => "enabled_write_endofpacket",
      rhs => "write_endofpacket & ween",
    }),
    e_register->new({
      out => 'd1_enabled_write_endofpacket',
      in => 'enabled_write_endofpacket',
    })
  );
  
  # WRITE FSM (read from FIFO, write to memory):

  my $fsm_write =
    make_write_machine($Options, $top_module->name() . "_mem_write");
  $top_module->add_contents(e_instance->new({module => $fsm_write,}));
}

# Why do I care about the masters of my slave port?
# 1) If I have 0 masters, then I might want to make a slave-port-free
#  module.  Then a system with no Nios can be built.  Currently, I don't
#  bother.
# 2) My slave port's masters have a certain data width (I hope it's either
#   16 or 32).  Certain arcane details of the master's SDK (e.g. sizeof(int)) 
#   depend on that data width.  It's best if a given DMA peripheral advertises
#   the same data width as the master of its slave port, so that SDK pointer
#   values like &np_uart->np_uartrxdata can be written into DMA address 
#   register without translation.

# In this function I query all masters of my slave port, find their data
# widths, and set the read and write masters' data widths to that same width.
# If I have multiple masters whose data widths are different, print a warning
# and use the max width.
sub learn_about_the_masters_of_my_slave_port
{
  my ($module, $project, $Options) = @_;

  # How many masters do I have?  Interesting answers are
  # "0" and "non-zero".
  # We don't have SBI anymore (in ptf)
  #my $slave_sbi = $project->SBI($control_port_name);
  #$Options->{masters_of_my_slave_port} =
    #[map {/MASTERED_BY/i ? keys %{$slave_sbi->{$_}} : ()} keys %$slave_sbi];
  # Always ensure that there is a master to the control slave port
  $Options->{masters_of_my_slave_port} = "control_slave_port";
  $module->comment($module->comment() . "Mastered by:\n");
  for my $master_name (@{$Options->{masters_of_my_slave_port}})
  {
    $module->comment(" " . $module->comment() . "$master_name; ");
  }
  $module->comment($module->comment() . "\n");

  # Check the data widths of all masters.  If we're lucky, they all have 
  # the same data width.  If not, print a warning and try to cope.
  #my @master_data_widths;
  #for my $master_name (@{$Options->{masters_of_my_slave_port}})
  #{
  #  my $master_sbi = $project->SBI($master_name, "MASTER");
  #  push @master_data_widths, $master_sbi->{Data_Width};
  #}
}

{
  # I think it might be useful as an optimization to disallow
  # certain transaction sizes.  For example, if the read and
  # write masters connect to 32-bit slaves, read- and write-mux
  # logic is generated to enable byte_access and halfword transactions,
  # even if they will never occur.  If byte_access and halfword transactions
  # are not explicitly allowed, those muxes need not be generated.
  my @allowed_transactions;
  my %transaction_size;

  sub transaction_size_in_bits
  {
    my $t = shift;
    return $transaction_size{$t} if exists($transaction_size{$t});

    my @t = reverse @all_transactions;
    for (0 .. @t - 1)
    {
      my $width = 8 * (1 << $_);
      my $transaction = $t[$_];
      $transaction_size{$transaction} = $width;
    }

    return $transaction_size{$t} if exists($transaction_size{$t});
    ribbit("transaction_size(): I never heard of transaction '$t'\n");
  }

  sub set_allowed_transactions
  {
    my ($lr) = @_;
    @allowed_transactions = @{$lr};

    # Strip whitespace.
    map {s/^\s+//g; s/\s+$//} @allowed_transactions;
    # Check transaction names for legality.
    @allowed_transactions = grep {
      my $t = $_;
      if (not grep {$t eq $_} get_transaction_size_bit_names())
      {
        print STDERR "Ignoring request to allow transaction '$t'\n";
        0;
      }
      else
      {
        1;
      }
    } @allowed_transactions;

  }

  sub limit_max_allowed_transaction
  {
    my $max = shift;

    # Limit transactions to no wider than the widest data width supported.
    @allowed_transactions = grep {
      $max >= transaction_size_in_bits($_)      
    } @allowed_transactions;
  }

  sub is_transaction_allowed
  {
    my $trans = shift;
    return 0 + grep {$trans eq $_} @allowed_transactions;
  }

  sub get_allowed_transactions
  {
    return @allowed_transactions;
  }
}

sub get_options
{
  my ($Options, $module, $project) = @_;

  #my $wsa = $project->WSA();
  #my $Options = {};

  #my @copy_options = grep {/reset_value$/} keys %$wsa;
  # Copy the reset values over, converting to decimal if necessary.
  #map {$Options->{$_} = eval($wsa->{$_})} @copy_options;

  # Copy the minimum lengthwidth spec
  #$Options->{lengthwidth} = $wsa->{lengthwidth};
  # copy the burst attributes as well
  #$Options->{burst_enable} = $wsa->{burst_enable};
  #$Options->{max_burst_size} = $wsa->{max_burst_size};
  #$Options->{allow_legacy_signals} = $wsa->{allow_legacy_signals};

  #learn_about_the_masters_of_my_slave_port($module, $project, $Options);

  # Go out and get info from the slaves.  We'll use this info to
  # decide:
  # Fifo depth:
  #   depends on maximum read latency of all slaves of the read master.
  # Fifo width:
  #   depends on the data width of all read and write slaves.
  # Read port address bits:
  #   maximum address bits of all read slaves
  # Write port address bits:
  #   maximum address bits of all write slaves.

  my $read_master_address;
  my $write_master_address;

  my @read_byteaddr_widths;
  my @write_byteaddr_widths;

  my @read_data_widths;
  my @write_data_widths;

  my @read_slave_names = $Options->{read_slave_name};
  my @write_slave_names = $Options->{write_slave_name};

  # Report info about the slaves.
  $module->comment($module->comment() . "Read slaves:\n");
  for (@read_slave_names)
  {
    $module->comment($module->comment() . "$_; ");
  }
  $module->comment($module->comment() . "\n\n");

  $module->comment($module->comment() . "Write slaves:\n");
  for (@write_slave_names)
  {
    $module->comment($module->comment() . "$_; ");
  }
  $module->comment($module->comment() . "\n\n");

  #my $read_master_desc = $module->name() . "/" . $read_master_name;    

  # Accumulate the maximum address span over all read and write slaves,
  # to determine the necessary number of bits for the length and 
  # writelength registers.
  # User_defined_fifo_depth is always true
  if ($Options->{user_defined_fifo_depth}) {
    
    push @read_byteaddr_widths, $Options->{read_address_width};
    push @read_data_widths, $Options->{read_data_width};
    push @write_byteaddr_widths, $Options->{write_address_width};
    push @write_data_widths, $Options->{write_data_width};
    
    $Options->{max_read_latency} = 0;
  } 
  #else {
  #  $Options->{max_slave_address_span} = 0;
  #  for my $slave_desc (@read_slave_names)
  #  {
  #    my ($address_width, $base_addr, $last_addr) = 
  #      master_address_width_from_slave_parameters(
  #        $project, $read_master_desc, $slave_desc);
  #  
  #    $Options->{max_slave_address_span} =
  #      max($Options->{max_slave_address_span}, $last_addr - $base_addr + 1);
  #  
  #    push @read_byteaddr_widths, $address_width;
  #    push @read_data_widths, 0 + $project->SBI($slave_desc)->{Data_Width};
  #  }
  #  
  #  my $write_master_desc = $module->name() . "/" . $write_master_name;
  #  for my $slave_desc (@write_slave_names)
  #  {
  #    my ($address_width, $base_addr, $last_addr) = 
  #      master_address_width_from_slave_parameters(
  #        $project, $write_master_desc, $slave_desc);
  #  
  #    $Options->{max_slave_address_span} =
  #      max($Options->{max_slave_address_span}, $last_addr - $base_addr + 1);
  #  
  #    push @write_byteaddr_widths, $address_width;
  #    push @write_data_widths, 0 + $project->SBI($slave_desc)->{Data_Width};
  #  }
  #  
  #  # Rule of thumb: set the fifo depth to the max over all read slave
  #  # read latencies.
  #  $Options->{max_read_latency} =
  #    $project->get_max_slave_read_latency(
  #      $project->_target_module_name(), $read_master_name,
  #    );
  #}

  #$Options->{fifo_in_logic_elements} = $wsa->{fifo_in_logic_elements};

  # My experiments indicate that a FIFO depth of 4 makes for 
  # efficient data transfers, while lower depths cause inefficient
  # use of bandwidth (frequent stalls as the fifo fills or empties.
  # But, the ptf file can override the fifo_depth with a larger value.
  my $wsa_fifo_depth = $Options->{fifo_depth};

  $Options->{fifo_depth} = max(4,
    $wsa_fifo_depth,
    $Options->{burst_enable} ? $Options->{max_burst_size} : 0 ,
    $Options->{max_read_latency});

  # Fifo depth must be an integer power of 2.
  # Note that 1 is an interesting special case: fifo address width is 0!
  #FIXIT - don't need this we think...
  if ($Options->{fifo_depth} < 1)
  {
    $Options->{fifo_depth} = 1;
  }

  if (not is_power_of_two($Options->{fifo_depth}))
  {
    $Options->{fifo_depth} = next_higher_power_of_two($Options->{fifo_depth});
  }

  # Warning!  I decree that all y'all have a fifo_read_latency of 1.
  $Options->{fifo_read_latency} = 1;

  # "allowed_transactions": let the user promise not to make
  # some transactions, which lets the DMA logic (byte enable,
  # read data mux) be simpler.
  #
  # Backwards compatibility: if the "allowed_transactions" wsa value is
  # not present, provide the default (all transactions), limited of
  # course by the maximum possible, aka fifodatawidth.

  delete $Options->{allowed_transactions};

  # Any not-present transaction size is set to 1.
  map {
    my $key = "allow_$_\_transactions";
    $Options->{$key} = 1 if not exists($Options->{$key})
  } @all_transactions;

  my @allowed_transactions = grep {
    my $key = "allow_$_\_transactions";
    $Options->{$key}
  } @all_transactions;

  set_allowed_transactions(\@allowed_transactions);

  # These are the widths of the read and write master data ports.
  # Note that masters are restricted in their data widths: only
  # 8, 16, 32, ... are allowed.
  $Options->{writedatawidth} =
    round_up_to_next_computer_acceptable_bit_width(max(@write_data_widths));
  $Options->{readdatawidth} =
    round_up_to_next_computer_acceptable_bit_width(max(@read_data_widths));

  # Limit the read- and write-data buses to no greater than the largest
  # allowed transaction sizes.  There's no need to sprout port pins that
  # will never be used (the synthesizer may not be able to determine they'll
  # never be used, so logic could be wasted) and as a side benefit, the 
  # fifo data memory will be no larger than necessary.
  map {$_ = min($_, get_max_transaction_size_in_bits())}
    ($Options->{writedatawidth}, $Options->{readdatawidth});

  # The FIFO will contain data only as wide as the narrowest
  # master.  This is not as good as it could be, because we
  # might be mastering some peripheral which advertises a 16-bit
  # data path, of which only 8 bits are active (e.g. UART).
  # This sub-optimality can only be resolved with user input,
  # via "allowed_transactions".

  # Consider a system where one of the master's max data width slave
  # is a native peripheral with data width 24 bits.  The actual fifo
  # that's built need only be 24 bits, but we need to treat it as though
  # it's 32 bits, as far as transaction sizes go.  Should investigate
  # whether or not the fifo ends up larger than it needs to be, after
  # synthesis.
  $Options->{fifodatawidth} = max(
    $Options->{writedatawidth}, $Options->{readdatawidth}
  );

  # Finally, since we're restricted to transactions no greater than
  # the fifo data width, set the read and write masters to be no 
  # wider than fifo data width.
  $Options->{writedatawidth} = $Options->{fifodatawidth};
  $Options->{readdatawidth} = $Options->{fifodatawidth};

  # Now that we know how wide the read- and write-master data is,
  # go back and limit the max transaction to no larger than that.
  limit_max_allowed_transaction($Options->{fifodatawidth});

  Progress("  @{[$module->name()]}: allowing these transactions: " .
    "@{[join(', ', get_allowed_transactions())]}");

  Progress("P4 $p4_revision $p4_datetime") if $Options->{europa_debug};


  # SPR 178278: provide a minimum address width of 5 bits (sufficient to
  # span a single doubleword of address space).
  $Options->{readaddresswidth} = max(@read_byteaddr_widths, 5);
  $Options->{writeaddresswidth} = max(@write_byteaddr_widths, 5);

  #return $Options;
}

#sub set_SBI_values
#{
#  my ($Options, $module, $project) = @_;
#
#  my $module_name = $module->name();
#
#  # Go modify my SBI, so that when the system is generated I'll get my 
#  # wires.
#  my $sys_ptf = $project->system_ptf();
#  my $write_master_sbi =
#    $sys_ptf->
#    {"MODULE $module_name"}->
#    {"MASTER $write_master_name"}->
#    {"SYSTEM_BUILDER_INFO"};
#  ribbit("what th'?") if (!$write_master_sbi);
#
#  $write_master_sbi->{Data_Width} = $Options->{writedatawidth};
#  $write_master_sbi->{Address_Width} = $Options->{writeaddresswidth};
#
#  my $read_master_sbi =
#    $sys_ptf->
#    {"MODULE $module_name"}->
#    {"MASTER $read_master_name"}->
#    {"SYSTEM_BUILDER_INFO"};
#  ribbit("what th'?") if (!$read_master_sbi);
#  $read_master_sbi->{Data_Width} = $Options->{readdatawidth};
#  $read_master_sbi->{Address_Width} = $Options->{readaddresswidth};
#}

sub set_sim_ptf
{
  my ($Options, $module, $project) = @_;

  # Signals which match any of the following regexps should be
  # radix hex.
  my @bus_signals = qw(
    length
    address
    data$
    byteenable
  );

  my $module_name = $module->name();
  my $sys_ptf = $project->system_ptf();
  my $mod_ptf = $sys_ptf->{"MODULE $module_name"};
  $mod_ptf->{SIMULATION} = {} if (!defined($mod_ptf->{SIMULATION}));
  $mod_ptf->{SIMULATION}->{DISPLAY} = {} if (!defined($mod_ptf->{SIMULATION}->{DISPLAY}));

  my $sig_ptf = $mod_ptf->{SIMULATION}->{DISPLAY};

  # Make a list of interesting signals, in order, with out-of-band 'divider'
  # names.
  my @signals;

  push @signals, qw(
    busy
    done
    length
    fifo_empty
    p1_fifo_full
  );

  push @signals, "Divider $module_name $read_master_name";
  my %read_signals = get_read_master_type_map($Options);
  push @signals, sort keys %read_signals;

  push @signals, "Divider $module_name $write_master_name";
  my %write_signals = get_write_master_type_map($Options);
  push @signals, sort keys %write_signals;

  $project->set_sim_wave_signals(\@signals);
}

sub make_write_master_data_mux
{
  my ($Options, $input, $output) = @_;
  my @things;

  # How sad.  I need a write-data mux for narrow writes.

  # For each possible transaction size, make a "fifo_read_as_transaction_size"
  # signal, by replicating the fifo read data up to the write data bus size.
  my @trans_names = reverse get_transaction_size_bit_names();  

  # Make a mux, create its table below.
  my $mux = e_mux->new({
    lhs => "write_writedata",
    type => "and_or",
  });

  my @mux_table;
  # Optimization alert: disallow small transaction sizes to avoid mux logic.
  for my $trans_index (0 .. @trans_names - 1)
  {
    my $trans_name = $trans_names[$trans_index];
    next if !is_transaction_allowed($trans_name);

    my $trans_size_in_bits = transaction_size_in_bits($trans_name);

    # Transactions larger than the fifo data width are impossible.
    last if $trans_size_in_bits > $Options->{fifodatawidth};

    my $signame = "fifo_rd_data_as_$trans_name";
    my $sig_value;
    my $dont_care_bits = $trans_size_in_bits - $Options->{fifodatawidth};

    if ($dont_care_bits <= 0)
    {
      $sig_value = "fifo_rd_data[@{[$trans_size_in_bits - 1]} : 0]";
    }
    else
    {
      $sig_value = sprintf("{{%d{1'b%s}}, fifo_rd_data}",
        $dont_care_bits, $::g_dont_care_value);
    }

    # Replicate the signal out to writedata width.
    my $multiple = $Options->{writedatawidth} / $trans_size_in_bits;
    # $sig_value = "{$multiple {$sig_value}}" if ($multiple != 1);
    $sig_value = concatenate(($sig_value) x $multiple) if ($multiple != 1);

    push @things, e_assign->new([
      e_signal->new({
        name => $signame,
        width => $Options->{writedatawidth},
        never_export => 1,
      }),
      $sig_value,
    ]);

    # Add this new signal to the mux table, along with its select signal.
    push @mux_table, ($trans_name, $signame);
  }

  $mux->table(\@mux_table);
  push @things, $mux;

  return @things;
}

sub make_dma
{
  # No arguments means "don't make the logic, make that other stuff" -
  # the class.ptf and the sdk bits.

  # A few handy constants.
  # These local typeglobs are available in this dynamic scope,
  # as e.g. $::g_max_address_width.
  local *g_max_address_width = \32;
  local *g_max_register_width = \$::g_max_address_width;
  local *g_max_data_width = \128;
  local *g_dont_care_value = \qq(X);

  my ($project, $Options, $module) = @_;
  #if (!@_)
  #{
  #  return make_appurtenances();
  #}
  #
  #my $project = e_project->new(@_);

  # Grab the module that was created during handle_args.
  #my $module = $project->top();

  $module->comment("DMA peripheral " . $module->name() . "\n\n");

  # Copy a few handy options from the slave port SBI into
  # $Options.
  # become a sub to update its value
  get_options($Options, $module, $project);
  
  # Suppress warnings in design assistant
  my $language = $Options->{project_info}{language};
  if ($language =~ /verilog/i) {
      $module->add_attribute ( ALTERA_ATTRIBUTE => qq(SUPPRESS_DA_RULE_INTERNAL=\\"R101\\")); 
  }
  else {
      $module->add_attribute ( ALTERA_ATTRIBUTE => qq(SUPPRESS_DA_RULE_INTERNAL=""R101""));
  }

  $Options->{device_family} = $project->{device_family};
  my $europa_debug = 0;
  $Options->{europa_debug} = 1 if $europa_debug;

  # get the burst PTF parameters
  my $burst_enable = $Options->{burst_enable};
  my $max_burst_size = $burst_enable ? $Options->{max_burst_size} : 1;
  ribbit "DMA maximum burst size must be greater than zero when burst mode is enabled. Please assign a larger value in the DMA configuration GUI."
    if $max_burst_size < 1;
  my $max_burstcount_width = $burst_enable ? log2($max_burst_size)+1 : 1;

  # Write back some stuff into SBI.
  #set_SBI_values($Options, $module, $project);

  # Here's a handy clk_en signal, which lets all e_process and
  # e_registers around here use the default clock-enable.
  $module->add_contents(
    e_assign->new({
      lhs => e_signal->new({name => "clk_en", never_export => 1,}),
      rhs => 1,
    })
  );

  # Generate a slave port, if anyone's available to master it.
  # always have a master
  #if (@{$Options->{masters_of_my_slave_port}})
  #{
    $module->add_contents(
      e_avalon_slave->new({
        name => $control_port_name,
        type_map => {get_control_interface_map($Options, $module, $project)},
      })
    );
  #}
#  else
#  {
#    # Can I delete the vestigial slave port that came from class.ptf?
#    my $module_name = $module->name();
#    my $module_ptf = $project->system_ptf()->{"MODULE $module_name"};
#
#    print STDERR "DMA with no master on its slave port.\n";
#    print STDERR "module ptf:\n",
#      map {"\t$_: $module_ptf->{$_}\n"} keys %$module_ptf;
#
#    print STDERR "Brutally deleting DMA ptf slave section.\n";
#    delete $module_ptf->{foo};
#    delete $module_ptf->{"SLAVE $control_port_name"};
#
#    print STDERR "new module ptf:\n",
#      map {"\t$_: $module_ptf->{$_}\n"} keys %$module_ptf;
#  }

  # Read master port...
  $module->add_contents(
    e_avalon_master->new({
      name => $read_master_name,
      type_map => {get_read_master_type_map($Options)},
    }),
    get_read_master_ports($Options, $burst_enable, $max_burstcount_width)
  );

  # Read data mux.
  $module->add_contents(
    make_read_master_data_mux($Options, $module, $project),
  );

  # Write master port...
  $module->add_contents(
    e_avalon_master->new({
      name => $write_master_name,
      type_map => {get_write_master_type_map($Options)},
    }),
    get_write_master_ports($Options, $burst_enable, $max_burstcount_width)
  );

  $module->add_contents(
    make_write_byteenables($Options, $module, $project),
  );

  push_global_ports($module);
  push_control_interface_ports($project, $module, $Options);

  #modify_burst_system_ptf_asssignments($project, $module, $Options);

  if ($burst_enable)
  {
    #FIXIT - grab the length of dma xfer and force it to be burst size for now
    my $length_reset_value = $Options->{length_reset_value};
    $length_reset_value = eval($length_reset_value);

    my $burstcount_reset_value = 1;
    if ($length_reset_value)
    {
      $burstcount_reset_value = $length_reset_value >> log2($Options->{readdatawidth} / 8);
    }

    $module->add_contents(
      e_assign->new({
        lhs => "length_register_write",
        rhs =>
        "dma_ctl_chipselect & ~dma_ctl_write_n & (dma_ctl_address == 3)",
      }),

      # latch DMA transfer length contents on initialization
      # initial burst implementation has burstlength=transfer length, so
      # alias the burstcount with the transfer count

#FIXIT - add a simulation assertion - can't write length value greater than max burst count words * bytes

      e_register->new({
        in => "dma_ctl_writedata >> " .
          log2($Options->{readdatawidth} / 8), # value in words!
        out => e_signal->new({name => "burstcount_update",
          width => $max_burstcount_width
        }),
        enable => "length_register_write",
        # we default to the pathological case of burst
        # length equals 1 word i.e. individual transactions
        async_value        => 1,
      }),
      # don't update the burstcount if there is a DMA transfer in progress
      # wait until we're done and then load the update
      e_register->new({
        in => "burstcount_update",
        out => "burstcount",
        enable => "~busy",
        async_value        => $burstcount_reset_value,
      }),
      e_assign->new({
        lhs => "read_burstcount",
        rhs => "burstcount"
      }),
      e_assign->new({
        lhs => "write_burstcount",
        rhs => "burstcount"
      }),

      # read_n is active only for the first cycle of the burst transaction request
      # hold off deasserting the read while waitrequest is active

      e_register->new({
        comment => "read burst request cycle",
        in => " ~mem_read_n",
        out => "burst_read_waitrequest_s1",
        async_value => "0"
      }),
      e_register->new({
        in => "read_waitrequest",
        out => "read_waitrequest_s1",
        async_value => "0"
      }),
      e_assign->new({
        lhs => "read_read_n",
        rhs => "(~read_waitrequest_s1 & burst_read_waitrequest_s1) || mem_read_n"
      })
    );
  } else { # not burst mode
    $module->add_contents(
      e_assign->new({
        lhs => "read_read_n",
        rhs => "mem_read_n"
      })
    );
  }

  # Define the slave port registers, and a handful of signal aliases
  # for control and status register bits.
  make_registers($module, $Options);

  # Make registered versions of the slaves' endofpacket signals.
  $module->add_contents(
    e_assign->new({
      lhs => "p1_read_got_endofpacket",
      rhs => "~status_register_write && " .
        "(read_got_endofpacket || (read_endofpacket & reen))",
    }),
  );

  $module->add_contents(
    e_assign->new({
      lhs => "p1_write_got_endofpacket",
      rhs => "~status_register_write && " .
        "(write_got_endofpacket || (inc_write & write_endofpacket & ween))",
    }),
  );

  $module->add_contents(
    e_register->new({
      in => "p1_read_got_endofpacket",
      out => e_signal->new(["read_got_endofpacket",]),
    }),
    e_register->new({
      in => "p1_write_got_endofpacket",
      out => e_signal->new(["write_got_endofpacket",]),
    }),
  );

  my $fifo_module = make_fifo($module, $Options);
  $module->add_contents(
    e_instance->new({
      module => $fifo_module,
      port_map => {
        inc_pending_data => "inc_read",
      },
    })
  );

  make_fsms($module, $Options);  

  # Connect the FSM outputs to their destinations.
  # 

  $module->add_contents(
    e_assign->new({
      lhs => "p1_done_read",
      rhs =>
        "(leen && (p1_length_eq_0 || (length_eq_0))) | " .
        "p1_read_got_endofpacket | " .
        "p1_done_write",
    }),
  );

  # Say, I need a len bit to wire into the status register.
  # Status register write clears the len condition.  Otherwise,
  # the bit sticks high as long as writelength is 0, and done_write isn't true.
  # (This means you can clear it by writing the length register.)
  $module->add_contents(
    e_register->new({
      out => "len",
      sync_reset => "status_register_write",
      sync_set =>
        "~d1_done_transaction & done_transaction && (writelength_eq_0)",
      priority => "reset",
      clock              => "clk",
      async_value        => 0,
    }),
  );

  # Similarly, I need save the fact that the transaction terminated due
  # to end-of-packet events.
  # The read-eop case is complicated by the fact that we don't declare
  # read-eop until after the data's been written out by the write master.
  # This logic is probably duplicated in done_write.
  # 
  $module->add_contents(
    e_register->new({
      out => "reop",
      sync_reset => "status_register_write",
      sync_set => "fifo_empty & read_got_endofpacket & d1_read_got_endofpacket",
      clock              => "clk",
      async_value        => 0,
    }),
  );

  $module->add_contents(
    e_register->new({
      out => "weop",
      sync_reset => "status_register_write",
      sync_set => "write_got_endofpacket",
      clock              => "clk",
      async_value        => 0,
    }),
  );

  $module->add_contents(
    # This is inelegant, but I think it's correct.  Use a delayed
    # version of read_got_endofpacket to delay the time we declare 'done!'.
    # This solves the problem of read_got_endofpacket while the fifo
    # is actually empty (before the last read value gets written into
    # the fifo).  As long as the latency in the internal DMA read data
    # to write fifo path doesn't change, this solution works.
    e_assign->new({
      lhs => "p1_done_write",
      rhs => 
        "(leen && (p1_writelength_eq_0 || writelength_eq_0)) | " .
        "p1_write_got_endofpacket | " .
        "fifo_empty & d1_read_got_endofpacket",
    }),
    e_register->new({
      in => "read_got_endofpacket",
      out => e_signal->new(["d1_read_got_endofpacket"]),
    }),
    e_register->new({
      comment =>
        " Write has completed when the length goes to 0, or\n" .
        " the write source said end-of-packet, or\n" .
        " the read source said end-of-packet and the fifo has emptied.",
      out => "done_write",
      in => "p1_done_write",
    })
  );

  # Assign address ports from address registers.
  # Vestigial remant of master address optimization,
  # now in e_ptf_master.pm.
  $module->add_contents(
    e_assign->news(['read_address','readaddress',]),
    e_assign->news(['write_address','writeaddress',])
  );

  $module->add_contents(
    e_assign->new({
      lhs => "write_chipselect",
      rhs => "write_select",
    })
  );

  $module->add_contents(
    e_assign->new({
      lhs => "read_chipselect",
      rhs => "~read_read_n",
    })
  );


  $module->add_contents(
    e_assign->new({
      lhs => "write_write_n",
      rhs => "mem_write_n",
    })
  );

  # If end of packet occurs, it's necessary to flush the state of any pending
  # latent reads.
 
#  $module->add_contents(e_assign->new(["read_flush", "flush_fifo",]));

  $module->add_contents(
    make_write_master_data_mux(
      $Options,
      "fifo_rd_data",
      "write_writedata", ),
  );

  $module->add_contents(
    e_assign->new({
      lhs => e_signal->new({
        name => "fifo_write_data_valid",
        never_export => 1,
      }),
      rhs => "read_readdatavalid",
    })
  );

  # Reset logic.  Reset can occur from the system reset input or from two writes
  # in succession to the control register softwarereset bit. (SPR 176807).
  
  # Get the index of the control register within the slave port register list.
  my @reg_info = get_slave_port_registers($Options);
  my ($control_index) = get_slave_port_register_indices($Options, "control");
  my ($alt_control_index) = get_slave_port_register_indices($Options, "reserved3");
  my $control_register_write_expression = "($reg_info[$control_index]->[3])";

  # Get the position of the "softwarereset" bit within the control register.
  my $sr_bit_position = -1;
  map {$sr_bit_position = $_->[2] if $_->[1] eq 'softwarereset'} get_control_bits();
  ribbit("Can't find 'softwarereset' bit") if ($sr_bit_position == -1);
  
  # A 1-cycle positive pulse on software_reset_request occurs when
  # a software reset is executed.  That positive pulse occurs in the
  # 2nd cycle of the 2nd set-software-reset-bit event.
  #
  # Implementation details: the following is a 2-shift-register chain.  The
  # output of the chain is software_reset_request, which asynchronously
  # resets the registers of this component, with the exception of the
  # shift register itself - the shift register is _synchronously_ reset by
  # software_reset_request.  The input to the shift-register chain is the
  # control register bit "softwarereset".
  # The 2 registers are enabled when the control register softwarereset bit
  # is being written (signal "set_software_reset_bit") and also when
  # software_reset_request is true (to allow the synchronous reset to occur).
  if ($Options->{softreset_enable})
  {
	  $module->add_contents(
		e_assign->new({
		  lhs => {name => "set_software_reset_bit", never_export => 1,},
		  rhs => # Set this register if someone writes the control register...
			"($control_register_write_expression)" .
			# ... but not the alternate control register..
			" & (dma_ctl_address != $alt_control_index)" .
			# ... and the softwarereset bit is being set.
			" & dma_ctl_writedata[$sr_bit_position] ",
		}),
		e_register->news(
		  {
			out => "d1_softwarereset",
			in => "softwarereset & ~software_reset_request",
			enable => "set_software_reset_bit | software_reset_request",
			_reset => "system_reset_n",
		  },
		  {
			out => "software_reset_request",
			in => "d1_softwarereset & ~software_reset_request",
			enable => "set_software_reset_bit | software_reset_request",
			_reset => "system_reset_n",
		  },
		  {
			out => "reset_n",
			in => "~(~system_reset_n | software_reset_request)",
			enable => "1",
			_reset => "system_reset_n",
		  },
		)         
	  );
  } else {
  	  $module->add_contents(
  	  	e_signal->new({name=>"reset_n", width=>1, never_export=>1}),
		e_assign->add(["reset_n"=>"system_reset_n"])
	  );
  }

  #set_sim_ptf($Options, $module, $project);

  if (!$Options->{allow_legacy_signals}) {
    $module->add_contents(
	  e_signal->new({name=>"read_endofpacket", width=>1, never_export=>1}),
	  e_signal->new({name=>"write_endofpacket", width=>1, never_export=>1}),
#	  e_signal->new({name=>"read_flush",width=>1}),
#	  e_signal->new({name=>"dma_ctl_readyfordata", width=>1}),
	  e_assign->add(["read_endofpacket"=>"0"]),
	  e_assign->add(["write_endofpacket"=>"0"])
    );
  }
  
  # All done.  Oh wait, might as well produce some output.
  #$project->output();
}

#sub make_appurtenances
#{
#  make_class_ptf();
#  make_sdk_stuff();
#}

#sub make_sdk_stuff
#{
#  # First, create the sdk folder if it doesn't exist yet.
#  # This is only necessary because I can't figure out how
#  # to add an empty directory to source control.
#  Create_Dir_If_Needed("sdk");
#
#  # Grab names for sdk file generation.
#  make_sdk_dot_h();
#  make_sdk_dot_s();
#}
#
#my $global_magic_comment_string =
#  "# This file created by em_dma.pm.";
#sub do_create_class_ptf
#{
#  my $sig = shift;
#
#  # Time to make a class.ptf.  But first!  Check to see if
#  # 1) the file exists
#  # 2) it does not start with the magic built-by-this-script signature
#
#  # If both conditions hold, leave the file alone.  This allows someone
#  # to override the file with (e.g.) their own GUI improvements.
#  my $do_create_class_ptf = 0;
#  if (!-e "class.ptf")
#  {
#    $do_create_class_ptf = 1;
#  }
#  else
#  {
#    open FILE, "class.ptf" or ribbit("Can't open 'class.ptf'\n");
#    while (<FILE>)
#    {
#      if (/$global_magic_comment_string/)
#      {
#        $do_create_class_ptf = 1;
#        last;
#      }
#    }
#
#    close FILE;
#  }
#
#  return $do_create_class_ptf;
#}
#
#sub make_class_ptf
#{
#  if (!do_create_class_ptf())
#  {
#    print STDERR "\nNot generating class.ptf: user has overridden.\n\n";
#    return;
#  }
#
#  my $max_burst_size = 1;
#
#  my $slave_data_width = get_slave_port_data_width();
#  my $slave_addr_width = get_slave_port_addr_width();
#
#  my $doGUI = 1;
#  my $addeditprogram = qq("");
#  $addeditprogram = qq("default") if $doGUI;
#
#  # Grab the register names and their reset values for
#  # the WSA section.
#  my @wsa_values;
#  my $control_reg_reset_value = "";
#  for (get_slave_port_registers())
#  {
#    if ($_->[1] !~ /status/ and $_->[1] !~ /control/ and $_->[1] !~ /reserved/)
#    {
#      # [1]: register name; [7]: register reset value.
#      # Add a string of the form <foo>_reset_value = 0x<reset value>;
#      my $name = $_->[1] . "_reset_value";
#      my $val = $_->[7];
#      $val =~ s/[0-9]*'h/0x/g; # '
#      $val = eval($val);
#      my $spacer = " " x (26 - length($name));
#      push @wsa_values, 
#        sprintf("      $name$spacer = \"0x%X\";", $val);
#    }
#
#    if ($_->[1] eq "control")
#    {
#      ($control_reg_reset_value = $_->[7]) =~ s/[0-9]*\'h/0x/g;;
#      $control_reg_reset_value = eval($control_reg_reset_value);
#    }
#  }
#  ribbit("no control register reset value\n")
#    if ($control_reg_reset_value eq "");
#
#  push @wsa_values, (
#    " ",
#    "      # Note: control register reset values are specified",
#    "      # on a per-bit basis.",
#    " ",
#    "      # Individual specifications for control register bits:",
#  );
#
#  # Define the default values for all control register bits.
#  my $i = 0;
#  for (get_control_bits())
#  {
#    my $option_name = "control_" . $_->[1] . "_reset_value";
#    my $spacer = " " x (30 - length($option_name));
#    my $option_value = ($control_reg_reset_value & (1 << $i)) ? "1" : "0";
#
#    push @wsa_values, "      $option_name$spacer= \"$option_value\";";
#    $i++;
#  }
#
#  # And some other handy default values.  Some of these are present just so
#  # that they'll be present, spelled correctly, in every DMA ptf section. 
#  push @wsa_values, (
#    qq( ),
##    qq(      \# Increment widths can be increased if large increment values),
##    qq(      \# will be written into the increment registers.),
##    qq(      \# Default: 0, so that the minimum logic is generated.),
##    qq(      writeincovwidth = "0";),
##    qq(      readincovwidth  = "0";),
#    qq(      \# A minimum for the width of the length register can be specified:),
#    qq(      lengthwidth                    = "13";),
#
#    qq(      burst_enable                   = "0";),
#
#    qq(      \# A minimum size for the fifo depth can be specified:),
#    qq(      fifo_in_logic_elements         = "1";),
#    qq(      allow_byte_transactions        = "1";),
#    qq(      allow_hw_transactions          = "1";),
#    qq(      allow_word_transactions        = "1";),
#    qq(      allow_doubleword_transactions  = "1";),
#    qq(      allow_quadword_transactions    = "1";),
#    qq(      max_burst_size                 = "128";),
#    qq(      big_endian                     = "0";),
#    qq(      altera_show_unpublished_features = "0";),
#  );
#
#  my $wsa_values = join("\n", @wsa_values);
#
#  my $class = "altera_avalon_dma";
#  open FILE, ">class.ptf" or die "Can't open 'class.ptf'\n";
#
#  print FILE qq[$global_magic_comment_string
#CLASS $class
#{
#  SDK_GENERATION 
#  {
#    SDK_FILES 0
#    {
#      cpu_architecture = "always";
#      c_structure_type = "np_dma *";
#      short_type = "dma";
#      c_header_file = "sdk/dma_struct.h";
#      asm_header_file = "sdk/dma_struct.s";
#      sdk_files_dir = "sdk";
#    }
#  }
#  ASSOCIATED_FILES 
#  {
#    Add_Program       = $addeditprogram;
#    Edit_Program      = $addeditprogram;
#    Generator_Program = "em_dma.pl";
#    Bind_Program      = "bind";
#  }
#  MODULE_DEFAULTS
#  {
#    class      = "$class";
#    class_version = "5.01";
#    MASTER $read_master_name
#    {
#      SYSTEM_BUILDER_INFO
#      {
#        Bus_Type = "avalon";
#        Max_Address_Width = "32";
#        Data_Width        = "32";
#        Do_Stream_Reads   = "1";
#        Is_Readable       = "1";
#        Is_Writable       = "0";
#        Maximum_Burst_Size   = "$max_burst_size";
#        Is_Big_Endian    = "0";
#      }
#    }
#    MASTER $write_master_name
#    {
#      SYSTEM_BUILDER_INFO 
#      {
#        Bus_Type = "avalon";
#        Max_Address_Width = "32";
#        Data_Width        = "32";
#        Do_Stream_Writes   = "1";
#        Is_Readable        = "0";
#        Is_Writable        = "1";
#        Maximum_Burst_Size   = "$max_burst_size";
#        Is_Big_Endian    = "0";
#      }
#    }
#    SLAVE $control_port_name
#    {
#      SYSTEM_BUILDER_INFO 
#      {
#        Bus_Type          = "avalon";
#        Address_Width     = "$slave_addr_width";
#        Data_Width        = "16";
#        Has_IRQ           = "1";
#        Address_Alignment = "native";
#        Read_Wait_States  = "1";
#        Write_Wait_States = "1";
#      }
#    }
#    SYSTEM_BUILDER_INFO 
#    {
#      Is_Enabled= "1";
#      Instantiate_In_System_Module = "1";
#      Top_Level_Ports_Are_Enumerated = "1";
#    }
#    WIZARD_SCRIPT_ARGUMENTS
#    {
#$wsa_values
#    }
#  }
#];
#
## Supply a label for this peripheral.
#if (!$doGUI)
#{
#print FILE qq[
#  USER_INTERFACE
#  {
#    USER_LABELS
#    {
#      name="DMA";
#      description="Direct Memory Access Controller";
#      license = "full";
#      technology="Other";
#    }
#     LINKS
#     {
#         LINK help
#         {
#            title="Data Sheet";
#            url="http://www.altera.com/literature/hb/nios2/n2cpu_nii51006.pdf";
#         }
#     }
#    WIZARD_UI default
#    {
#      DEBUG {}
#    }
#  }
#];
#}
#else
#{
## Maybe we want some elaborate GUI?
#print FILE qq[
#  USER_INTERFACE
#  {
#    USER_LABELS
#    {
#      name="DMA";
#      description="Direct Memory Access Controller";
#      license = "full";
#      technology="Other";
#    }
#     LINKS
#     {
#         LINK help
#         {
#            title="Data Sheet";
#            url="http://www.altera.com/literature/hb/nios2/n2cpu_nii51006.pdf";
#         }
#     }
#     WIZARD_UI bind
#     {
#        CONTEXT
#        {
#           MOD = "";
#           RMSBI="MASTER read_master/SYSTEM_BUILDER_INFO";
#           WMSBI="MASTER write_master/SYSTEM_BUILDER_INFO";
#        }
#        visible = "0";
#        # make sure the DMA master data widths track the DMA slaves
#        code = "{{
#            \$RMSBI/Data_Width = sopc_max_data_width(\$MOD, 'read_master');
#            \$WMSBI/Data_Width = sopc_max_data_width(\$MOD, 'write_master');
#        }}";
#     }
#     WIZARD_UI default
#     {
#      title="Avalon DMA Controller - {{ \$MOD }}";
#      CONTEXT
#      {
#        WSA="WIZARD_SCRIPT_ARGUMENTS";
#        RMSBI="MASTER read_master/SYSTEM_BUILDER_INFO";
#        WMSBI="MASTER write_master/SYSTEM_BUILDER_INFO";
#      }
#      ACTION wizard_finish
#      {
#        \$RMSBI/Maximum_Burst_Size = "{{ if (\$WSA/burst_enable) { \$WSA/max_burst_size; } else {1; } }}";
#        \$WMSBI/Maximum_Burst_Size = "{{ if (\$WSA/burst_enable) { \$WSA/max_burst_size; } else {1; } }}";
#
#        # Set appropriate endianness
#        \$RMSBI/Is_Big_Endian = "{{ \$WSA/big_endian }}";
#        \$WMSBI/Is_Big_Endian = "{{ \$WSA/big_endian }}";
#      }
#      PAGES main
#      {
#        select=1;
#        PAGE 1
#        {
#          title = "DMA Parameters";
#          GROUP
#          {
#            GROUP
#            {
#              align = "left";
#              title = "Transfer Size";
#              spacing=8;
#              EDIT
#              {
#                id="width";
#                width=40;
#                title=" Width of the DMA length register (1-32):";
#                key="w";
#                suffix="bits";
#                type="decimal";
#                DATA { \$WSA/lengthwidth = \$; }
#                \$\$bad_width="{{ \$WSA/lengthwidth > 32 || \$WSA/lengthwidth < 1; }}";
#                error="{{ if (\$\$bad_width) 'Invalid DMA length register width.'; }}";
#                \$\$foo = "{{ 2 ^ \$WSA/lengthwidth; }}";
#                \$\$max_val = "{{ ceil(-1 + ( (\$\$foo ) ) ); }}";
#                \$\$good_str="A minimum of {{\$\$max_val; }} bytes may be moved in a transaction.<br>The length may be automatically increased to encompass the slave span.";
#                \$\$title_str="{{ if (\$\$bad_width==0) {\$\$good_str} else {'Invalid DMA length register width.'}; }}";
#                warning="{{ if (\$WSA/burst_enable && \$WSA/fifo_in_logic_elements) {'Construct FIFO from embedded memory blocks to avoid excessive LE usage'; } }}";
#              }
#              TEXT
#              {
#                title="{{ \$\$title_str; }}";
#              }
#            }
#
#            GROUP
#            {
#              align = "left";
#              title = "Burst Transactions";
#              spacing=8;
#              CHECK
#              {
#                id ="burst_enable";
#                title="Enable Burst Transfers";
#                tooltip = "Enable Burst Transfers";
#                DATA {  \$WSA/burst_enable = \$; }
#              }
#              EDIT
#              {
#                id="width";
#                width=40;
#                title="Maximum Burst Size:";
#                key="w";
#                suffix="words";
#                type="decimal";
#                \$\$editable_max_burst = "{{ \$WSA/burst_enable == 1 }}";
#                enable = "{{ \$\$editable_max_burst; }}";
#                DATA { \$WSA/max_burst_size = \$; }
#                \$\$bad_max = "{{ log2(\$WSA/max_burst_size) != int(log2(\$WSA/max_burst_size)) || ( \$WSA/max_burst_size == '' ) ; }}";
#                error = "{{ if (\$\$bad_max && \$\$editable_max_burst) {'Burst size must be a power of 2.'} }}";
#              }
#            }
#            GROUP
#            {
#              align = "left";
#              title = "FIFO Implementation";
#              spacing=8;
#              align="left";
#              RADIO
#              {
#                id ="fifo_reg";
#                title = "Construct FIFO from Registers  ";
#                DATA { fifo_in_logic_elements = "1"; }
#              }
#              RADIO
#              {
#                id ="fifo_mem";
#                title = "Construct FIFO from Embedded Memory Blocks";
#                DATA on { fifo_in_logic_elements = "0"; }
#              }
#            }
#          }
#        }
#        PAGE 2
#        {
#          title = "Advanced";
#          GROUP
#          {
#            GROUP
#            {
#              align = "left";
#              title = "Allowed Transactions";
#              tooltip = "Decrease logic consumption by disabling unneeded transaction sizes";
#              spacing=8;
#              CHECK
#              {
#                id ="allow_byte";
#                title="byte";
#                tooltip = "Allow byte (8-bit) transactions";
#                DATA { \$WSA/allow_byte_transactions = \$; }
#              }
#              CHECK
#              {
#                id ="allow_halfword";
#                title="halfword";
#                tooltip = "Allow halfword (16-bit) transactions";
#                DATA { \$WSA/allow_hw_transactions = \$; }
#              }
#              CHECK
#              {
#                id ="allow_word";
#                title="word";
#                tooltip = "Allow word (32-bit) transactions";
#                DATA { \$WSA/allow_word_transactions = \$; }
#              }
#              CHECK
#              {
#                id ="allow_dword";
#                title="doubleword";
#                tooltip = "Allow doubleword (64-bit) transactions";
#                DATA { \$WSA/allow_doubleword_transactions = \$; }
#              }
#              CHECK
#              {
#                id ="allow_quadword";
#                title="quadword";
#                tooltip = "Allow quadword (128-bit) transactions";
#                DATA { \$WSA/allow_quadword_transactions = \$; }
#              }
#            }
#            CHECK 
#            {
#                visible = "{{ \$WSA/altera_show_unpublished_features; }}";
#                align = "left";
#                id = "big_endian";
#                title = "Big Endian";
#                TEXT
#                {
#                    title = "{{ if (\$WSA/altera_show_unpublished_features) 'DMA operates in big-endian mode instead of little-endian mode.'; else ''; }}";
#                }
#                DATA { \$WSA/big_endian = \$; }
#            }
#            error = "{{ if (!\$WSA/allow_quadword_transactions &&
#                            !\$WSA/allow_doubleword_transactions &&
#                            !\$WSA/allow_word_transactions &&
#                            !\$WSA/allow_hw_transactions &&
#                            !\$WSA/allow_byte_transactions)
#                        'At least one type of transaction must be allowed.'; }}";
#            error = "{{ if (\$WSA/big_endian && (
#                              \$WSA/allow_quadword_transactions ||
#                              \$WSA/allow_doubleword_transactions ||
#                              \$WSA/allow_word_transactions ||
#                              \$WSA/allow_hw_transactions))
#                        'Big-endian mode only supports byte transactions.'; }}";
#          }
#        }
#      }
#    }
#  }
#];
#}
#
## Don't forget the closing brace!
#print FILE qq[
#}
#];
#
#  close FILE;
#}
#
#sub make_sdk_dot_s
#{
#  open FILE, ">sdk/dma_struct.s" or die "Can't open 'sdk/dma_struct.s\n";
#
#  # Grab the register descriptions and make a struct.
#  my $struct_elements;
#
#  my $index = 0;
#  my @registers = 
#    map {
#      my $def = "  .equ np_dma$_->[1],";
#      my $space = " " x (30 - length($def));
#      my $value_and_comment = "$index   ; $_->[0]";
#      $index++;
#
#      $def . $space . $value_and_comment;
#    } get_slave_port_registers();
#
#  my $struct_elements = join("\n", @registers);
#
#  # Get bit definitions and masks
#  my @enum_defs =
#    map {
#      my $name = "  .equ np_dma$_->[0]\_$_->[1]\_bit, ";
#      my $equals = $_->[2];
#      my $space = " " x (48 - length($name));
#      my $comment = " ; $_->[3]";
#
#      $name . $space . $equals . $comment;
#    } get_slave_port_bit_definitions();
#
#  push @enum_defs, " ";
#  # Also throw in some handy mask definitions.
#  push @enum_defs,
#    map {
#      my $name = "  .equ np_dma$_->[0]\_$_->[1]\_mask, ";
#      my $equals = "(1 << $_->[2])";
#      my $space = " " x (48 - length($name));
#      my $comment = " ; $_->[3]";
#
#      $name . $space . $equals . $comment;
#    } get_slave_port_bit_definitions();
#
#  my $enum_elements = join("\n", @enum_defs);
#
#  print FILE qq[
#; ----------------------------------------------
#;  DMA Peripheral
#
#;  DMA Registers
#$struct_elements
#
#; DMA Register Bits
#$enum_elements
#;  DMA Routines
#
#];
#
#  close FILE;
#}
#
#sub make_sdk_dot_h
#{
#  open FILE, ">sdk/dma_struct.h" or die "Can't open 'sdk/dma_struct.h\n";
#
#  # Grab the register descriptions and make a struct.
#  my $struct_elements;
#
#  my @registers = 
#    map {
#      my $def = "  int np_dma$_->[1];";
#      my $space = " " x (27 - length($def));
#      my $comment = "//$_->[0]";
#
#      $def . $space . $comment;
#    } get_slave_port_registers();
#
#  my $struct_elements = join("\n", @registers);    
#
#  # Grab the bit definitions and make an enum of bits and
#  # the masks who love to hate them.
#  my @enum_defs =
#    map {
#      if (!ref($_))
#      {
#        " ",
#      }
#      else
#      {
#        my $name = "  np_dma$_->[0]\_$_->[1]\_bit";
#        my $equals = " = $_->[2],";
#        my $space = " " x (25 - length($name));
#        my $comment = " // $_->[3]";
#
#        $name . $space . $equals . $comment;
#      }
#    } (get_control_bits(), "", get_status_bits());
#
#  push @enum_defs, " ";
#  # Also throw in some handy mask definitions.
#  push @enum_defs,
#    map {
#      if (!ref($_))
#      {
#        " ",
#      }
#      else
#      {
#        my $name = "  np_dma$_->[0]\_$_->[1]\_mask";
#        my $equals = " = (1 << $_->[2]),";
#        my $space = " " x (25 - length($name));
#        my $comment = " // $_->[3]";
#
#        $name . $space . $equals . $comment;
#      }
#    } (get_control_bits(), "", get_status_bits());
#
#  my $enum_elements = join("\n", @enum_defs);
#
#  print FILE qq[
#// ----------------------------------------------
#// DMA Peripheral
#
#// DMA Registers
#typedef volatile struct
#{
#$struct_elements
#} np_dma;
#
#// DMA Register Bits
#enum
#{
#$enum_elements
#};
#
#// DMA Routines
#
#void nr_dma_copy_1_to_1
#    (
#    np_dma *dma,
#    int bytes_per_transfer,
#    void *source_address,
#    void *destination_address,
#    int transfer_count
#    );
#
#void nr_dma_copy_1_to_range
#    (
#    np_dma *dma,
#    int bytes_per_transfer,
#    void *source_address,
#    void *first_destination_address,
#    int transfer_count
#    );
#
#void nr_dma_copy_range_to_range
#    (
#    np_dma *dma,
#    int bytes_per_transfer,
#    void *first_source_address,
#    void *first_destination_address,
#    int transfer_count
#    );
#
#void nr_dma_copy_range_to_1
#    (
#    np_dma *dma,
#    int bytes_per_transfer,
#    void *first_source_address,
#    void *destination_address,
#    int transfer_count
#    );
#
#];
#
#  close FILE;
#}

1;
