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



use strict;
use europa_all;
use byteenable_gen;

sub make_write_block {
  my $mod = shift;
  my $WSA = shift;
  my $proj = shift;

  # parameters
  my $DESC_WIDTH = $WSA->{""};
  my $ADDRESS_WIDTH = $WSA->{"address_width"};
  my $WRITE_BLOCK_DATA_WIDTH = $WSA->{"write_block_data_width"};
  my $STREAM_DATA_WIDTH = $WSA->{"stream_data_width"};
  my $BYTES_TO_TRANSFER_WIDTH = $WSA->{"bytes_to_transfer_data_width"};
  my $COUNTER_WIDTH = $BYTES_TO_TRANSFER_WIDTH;
  my $BURST_WIDTH = $WSA->{"burst_data_width"};
  my $STATUS_TOKEN_WIDTH = $WSA->{"status_token_data_width"};
  my $STATUS_WIDTH = $WSA->{"status_data_width"};
  my $COMMAND_WIDTH = 1 + $BURST_WIDTH + $BYTES_TO_TRANSFER_WIDTH + $ADDRESS_WIDTH;
  my $HAS_READ_BLOCK = $WSA->{"has_read_block"};
  my $HAS_WRITE_BLOCK = $WSA->{"has_write_block"};
  my $SYMBOLS_PER_BEAT = $WSA->{"symbols_per_beat"};
  my $UNALIGNED_TRANSFER = $WSA->{"unaligned_transfer"};
  my $IN_ERROR_WIDTH = $WSA->{"in_error_width"};
  my $BURST_TRANSFER = $WSA->{"burst_transfer"};
  my $write_burst_size = $WSA->{"write_burstcount_width"};
  my $ALWAYS_DO_MAX_BURST = $WSA->{"always_do_max_burst"};
  my $WRITE_BLOCK_DATA_WIDTH = $WSA->{"write_block_data_width"};
  my $BYTEENABLE_WIDTH = $WRITE_BLOCK_DATA_WIDTH / 8;
  my $handle_illegal_byteenable = 1;

  $UNALIGNED_TRANSFER &= ($SYMBOLS_PER_BEAT != 1);
  # maximum bits of error that is supported by the hardware
  my $MAX_SUPPORTED_ERROR_WIDTH = 7;

  my $credit_width = 32;

  my $empty_signal_width = Bits_To_Encode($SYMBOLS_PER_BEAT) - 1;
  my $bits_to_encode_symbols_per_beat = $empty_signal_width;
 
  my $write_master_name = "m_write";
  my $prefix = "m_write";
  my $writeblock_fifo_depth = &get_writeblock_internal_fifo_depth($WRITE_BLOCK_DATA_WIDTH, $WSA);
  
  &add_write_block_ports($mod, $WRITE_BLOCK_DATA_WIDTH, $ADDRESS_WIDTH, $STREAM_DATA_WIDTH, $COMMAND_WIDTH, $SYMBOLS_PER_BEAT, $empty_signal_width, $IN_ERROR_WIDTH, $BURST_TRANSFER, $writeblock_fifo_depth);
  &make_write_block_avalon_master($mod, $WRITE_BLOCK_DATA_WIDTH, $ADDRESS_WIDTH, $write_master_name, $prefix, $BURST_TRANSFER, $write_burst_size);
  &make_write_block_assignments($mod, $ADDRESS_WIDTH, $BYTES_TO_TRANSFER_WIDTH, $BURST_WIDTH, $WRITE_BLOCK_DATA_WIDTH, $SYMBOLS_PER_BEAT, $empty_signal_width, $UNALIGNED_TRANSFER, $BURST_TRANSFER, $ALWAYS_DO_MAX_BURST, $write_burst_size,$BYTEENABLE_WIDTH,$WSA->{"avalon_mm_byte_reorder_mode"});
  &make_write_block_registers($mod, $COMMAND_WIDTH, $COUNTER_WIDTH, $SYMBOLS_PER_BEAT, $UNALIGNED_TRANSFER, $BURST_TRANSFER);
  my $IS_MEM_TO_MEM_MODE = $HAS_READ_BLOCK && $HAS_WRITE_BLOCK;
  &make_m_write_status_token($mod, $STATUS_TOKEN_WIDTH, $BYTES_TO_TRANSFER_WIDTH, $STATUS_WIDTH, $IS_MEM_TO_MEM_MODE, $IN_ERROR_WIDTH, $MAX_SUPPORTED_ERROR_WIDTH);
  &pop_data_into_m_write_status_token_fifo($mod);
  
  if ($UNALIGNED_TRANSFER) {
    &make_rx_barrel_shift_logic($mod, $bits_to_encode_symbols_per_beat);
  }

  if ($handle_illegal_byteenable) {
  if ($BURST_TRANSFER) {
  if ($BYTEENABLE_WIDTH > 1) {
      #Bypass byteenable generator
      $mod->add_contents(
        e_signal->new({name=>"m_write_waitrequest_out", width=>"1", never_export=>"1"}),
        e_assign->new({lhs=>"m_write_waitrequest_out", rhs=>"m_write_waitrequest"}),
        e_signal->new({name=>"m_write_byteenable", width=>"1", export=>"1"}),
        e_assign->new({lhs=>"m_write_byteenable", rhs=>"m_write_byteenable_in"}),
	);
  } else {
      $mod->add_contents(
        e_signal->new({name=>"m_write_waitrequest_out", width=>"1", never_export=>"1"}),
        e_assign->new({lhs=>"m_write_waitrequest_out", rhs=>"m_write_waitrequest"}),
        );
      }

  }  else  {
  if ($BYTEENABLE_WIDTH > 1) {
  my $byteenable_gen_mod = $proj->make_new_private_module("byteenable_gen");
  &byteenable_gen($byteenable_gen_mod, $WSA, $proj);
  $mod->add_contents(
  e_instance->new({	module=>$byteenable_gen_mod,
        		port_map  => {
          		"clk"           	=> "clk",
          		"reset_n"       	=> "reset_n",
			"write_in"		=> "m_write_write",
          		"byteenable_in"     	=> "m_write_byteenable_in",
          		"waitrequest_out"       => "m_write_waitrequest_out",
          		"byteenable_out"       	=> "m_write_byteenable",
          		"waitrequest_in"        => "m_write_waitrequest" },
  			}),
  		);
  } else {
      $mod->add_contents(
        e_signal->new({name=>"m_write_waitrequest_out", width=>"1", never_export=>"1"}),
        e_assign->new({lhs=>"m_write_waitrequest_out", rhs=>"m_write_waitrequest"}),
	);
      }

  }
 } else {
  if ($BYTEENABLE_WIDTH > 1) {
      #Bypass byteenable generator
      $mod->add_contents(
        e_signal->new({name=>"m_write_waitrequest_out", width=>"1", never_export=>"1"}),
        e_assign->new({lhs=>"m_write_waitrequest_out", rhs=>"m_write_waitrequest"}),
        e_signal->new({name=>"m_write_byteenable", width=>"1", export=>"1"}),
        e_assign->new({lhs=>"m_write_byteenable", rhs=>"m_write_byteenable_in"}),
	);
  } else {
      $mod->add_contents(
        e_signal->new({name=>"m_write_waitrequest_out", width=>"1", never_export=>"1"}),
        e_assign->new({lhs=>"m_write_waitrequest_out", rhs=>"m_write_waitrequest"}),
	);
      }
 }

  return $mod;
}


sub make_rx_barrel_shift_logic {
  my $mod = shift;
  my $bits_to_encode_symbols_per_beat = shift;

  # first we assume this is only for M-T-M, where every transfer is a complete packet
  $mod->add_contents(
    e_port->new([rx_shift=>$bits_to_encode_symbols_per_beat=>"output"]),
    e_register->new({out=>"rx_shift",
      in=>"start_address[$bits_to_encode_symbols_per_beat-1:0]", 
      enable=>"delayed_write_command_valid"}),
  );
}

sub add_write_block_ports {
  my $mod = shift;
  my $WRITE_BLOCK_DATA_WIDTH = shift;
  my $ADDRESS_WIDTH = shift;
  my $STREAM_DATA_WIDTH = shift;
  my $COMMAND_WIDTH = shift;
  my $SYMBOLS_PER_BEAT = shift;
  my $empty_signal_width = shift;
  my $IN_ERROR_WIDTH = shift;
  my $BURST_TRANSFER = shift;
  my $writeblock_fifo_depth = shift;

  my @ports = (
    [clk=>1=>"input"],
    [reset_n=>1=>"input"],
    
    [write_command_data=>"$COMMAND_WIDTH"=>"input"],
    [write_command_valid=>1=>"input"],
    [sink_stream_startofpacket=>1=>"input"],
    [sink_stream_endofpacket=>1=>"input"],
    [sink_stream_empty=>$empty_signal_width=>"input"],
    [sink_stream_valid=>1=>"input"],
    [sink_stream_data=>"$STREAM_DATA_WIDTH"=>"input"],
    [sink_stream_ready=>1=>"output"], 
    
    # write_go bit
    [write_go=>1=>"output"],
    
  );

  if ($SYMBOLS_PER_BEAT > 1) {
    push(@ports, [sink_stream_empty=>$empty_signal_width=>"input"]);
  }
  
  if ($IN_ERROR_WIDTH > 0) {
    push(@ports, [sink_stream_error=>$IN_ERROR_WIDTH=>"input"]);
  }
  if ($BURST_TRANSFER) {
    push(@ports, ["eop_found"=>1=>"input"]);
    push(@ports, ["m_writefifo_fill"=>1=>"input"]);
  }
 
  $mod->add_contents(
    e_port->new(@ports),
  );
}

sub make_write_block_assignments {
  my $mod = shift;
  my $ADDRESS_WIDTH = shift;
  my $BYTES_TO_TRANSFER_WIDTH = shift;
  my $BURST_WIDTH = shift;
  my $WRITE_BLOCK_DATA_WIDTH = shift;
  my $SYMBOLS_PER_BEAT = shift;
  my $empty_signal_width = shift;
  my $UNALIGNED_TRANSFER = shift;
  my $BURST_TRANSFER = shift;
  my $ALWAYS_DO_MAX_BURST = shift;
  my $write_burst_size = shift;
  my $BYTEENABLE_WIDTH =shift;
  my $avalon_mm_byte_reorder_mode=shift;
  my $increment_block = $ADDRESS_WIDTH / 8;
  my $BYTES_OFFSET = $ADDRESS_WIDTH;
  my $BURST_OFFSET = $BYTES_OFFSET + $BYTES_TO_TRANSFER_WIDTH;
  my $INCREMENT_OFFSET = $BURST_OFFSET + $BURST_WIDTH;
  my $byteenable_case;
  my $bits_to_encode_symbols_per_beat = $empty_signal_width;
  my $address_alignment_padding = $bits_to_encode_symbols_per_beat . "'b0";
  my $flipped_writedata_signal;
  my $flipped_be_signal;

  my $all_one_signal = "$SYMBOLS_PER_BEAT" . "'b";
  for (my $i=0; $i<$SYMBOLS_PER_BEAT; $i++) {
    $all_one_signal .=  "1";
  }

  

  if ($BURST_TRANSFER) {
    if ($ALWAYS_DO_MAX_BURST) {
      my $max_burst = 2 ** ($write_burst_size-1);
      my $byte_width_m1 = ($WRITE_BLOCK_DATA_WIDTH / 8)-1;
      my $data_width_shift = log2($WRITE_BLOCK_DATA_WIDTH / 8);
      $mod->add_contents(

      e_signal->new({name=>"transfer_remaining", width=>$BYTES_TO_TRANSFER_WIDTH, export=>"0"}),
      e_register->new({out=>"transfer_remaining", in=>" ((bytes_to_transfer-counter_in + $byte_width_m1)>>$data_width_shift)",enable=>"1"}),

      e_register->new({out=>"burst_size", in=>" (!(|bytes_to_transfer)) ?$max_burst:
                          transfer_remaining>=$max_burst?$max_burst:transfer_remaining",enable=>"1"}),
      );
    } else {
      $mod->add_contents(
        e_assign->new({lhs=>"burst_size", rhs=>"write_command_data_reg[$BURST_WIDTH+$BURST_OFFSET-1:$BURST_OFFSET]"}),
      );
    }
    $mod->add_contents(
      e_signal->new({name=>"burst_downcounter", width=>$BURST_WIDTH, never_export=>"1"}),
      e_assign->new({lhs=>"enough_data", rhs=>"m_writefifo_fill >= burst_size"}),
      # only if the write signal is being waitrequested and a new data comes in, we remember it and inform the write signal once it's unfrozen
      
      e_register->new({out=>"m_write_write", in=>"write_go_reg & ((|burst_counter & sink_stream_really_valid) | m_write_write_sig)", enable=>"~m_write_waitrequest_out"}),

      # burstcount
      e_signal->new({name=>"m_write_burstcount", width=>$write_burst_size, export=>"1"}),
      e_process->new({
        reset => "reset_n",
        reset_level => 0,
        asynchronous_contents => [e_assign->new(["m_write_burstcount" => "0"])],
        contents => [
          e_if->new({
            condition => "~m_write_waitrequest_out",
            then => [
              e_if->new({
                condition => "~|burst_counter",
                then => [
                  e_if->new({
                    condition => "enough_data",
                    then => ["m_write_burstcount" => "burst_size"],
                    elsif => {
                      condition => "eop_found_hold",
                      then => ["m_write_burstcount" => "m_writefifo_fill"],
                    },
                  }),
                ],
              }), 
            ],
          }),
        ],
      }),
      
    );
  } else {
    $mod->add_contents(
      e_assign->new({lhs=>"burst_size", rhs=>"1"}),
      e_register->new({out=>"m_write_write", in=>"write_go_reg & (sink_stream_really_valid | m_write_write_sig)", enable=>"~m_write_waitrequest_out"}),

      # tie off burst signals
      e_assign->new({lhs=>"m_writefifo_fill", rhs=>"1"}),
      e_signal->new({name=>"m_writefifo_fill", never_export=>"1"}),
    );
  }

   if ($avalon_mm_byte_reorder_mode == 1){ 
   $flipped_writedata_signal = &swap_signals($SYMBOLS_PER_BEAT, "m_write_writedata_reg");
   } else {
   $flipped_writedata_signal =  "m_write_writedata_reg";
   }

  $mod->add_contents(
    # command input
    e_comment->new({comment=>"command input"}),
    e_assign->new({lhs=>"start_address", rhs=>"write_command_data_reg[$ADDRESS_WIDTH-1:0]"}),
    e_assign->new({lhs=>"bytes_to_transfer", 
      rhs=>"write_command_data_reg[$BYTES_TO_TRANSFER_WIDTH+$BYTES_OFFSET-1:$BYTES_OFFSET]"}),
    e_assign->new({lhs=>"increment_address", rhs=>"write_command_data_reg[$INCREMENT_OFFSET]"}),
    
    # these signals are for internal use only
    e_signal->new({name=>"start_address", width=>"$ADDRESS_WIDTH", never_export=>"1"}),
    e_signal->new({name=>"bytes_to_transfer", width=>"$BYTES_TO_TRANSFER_WIDTH", never_export=>"1"}),
    e_signal->new({name=>"burst_size", width=>"$write_burst_size", never_export=>"1"}),
    e_signal->new({name=>"increment_address", width=>"1", never_export=>"1"}),
  
    # increment or keep constant, the m_write_address depending on the command bit
    e_comment->new({comment=>"increment or keep constant, the m_write_address depending on the command bit"}),
    e_signal->new({name=>"m_write_writedata", width=>"$WRITE_BLOCK_DATA_WIDTH", never_export=>"1"}),
    e_assign->new({lhs=>"m_write_writedata", rhs=>$flipped_writedata_signal}),
    e_assign->new({lhs=>"increment", rhs=>"write_go_reg & sink_stream_really_valid"}),
    e_register->new({out=>"m_write_writedata_reg", in=>"sink_stream_data", enable=>"~m_write_waitrequest_out"}),
    e_signal->new({name=>"m_write_writedata_reg", width=>"$WRITE_BLOCK_DATA_WIDTH"}),

    e_register->new({out=>"m_write_write_sig", in=>"sink_stream_really_valid & ~m_write_write", enable=>"m_write_waitrequest_out"}),

  );
  if ($UNALIGNED_TRANSFER) {

    $mod->add_contents(
      # generate the m_write_address with aligned_start_address if we're using unaligned transfer
      e_comment->new({comment=>"Generate an aligned m_write_address for unaligned transfer."}),
      e_register->new({out=>"m_write_address", 
        in=>"delayed_write_command_valid ? aligned_start_address : (increment_address ? (m_write_write ? (m_write_address + $SYMBOLS_PER_BEAT) : m_write_address) : aligned_start_address)", enable=>"~m_write_waitrequest_out"}),
      e_assign->new({lhs=>"aligned_start_address", rhs=>"{start_address[$ADDRESS_WIDTH-1:$bits_to_encode_symbols_per_beat], $address_alignment_padding}"}),
      e_signal->new({name=>"aligned_start_address", width=>$ADDRESS_WIDTH}),
    
    );
  } else {
    if ($BURST_TRANSFER) {
      my $m_write_burstcount_right_shifted = $write_burst_size +  $bits_to_encode_symbols_per_beat;
      if ($SYMBOLS_PER_BEAT>1) {
      $mod->add_contents(
      e_signal->new({name=>"m_write_burstcount_right_shifted", width=>"$m_write_burstcount_right_shifted", never_export=>"1"}),
      e_assign->new({lhs=>"m_write_burstcount_right_shifted", rhs=>"{m_write_burstcount, $address_alignment_padding}"}),
      e_register->new({out=>"m_write_address", 
          in=>"delayed_write_command_valid ? start_address : (increment_address ? (m_write_write ? (m_write_address + m_write_burstcount_right_shifted) : m_write_address) : start_address)", enable=>"~m_write_waitrequest_out & ~|burst_counter"}),
      );
       } else {
      $mod->add_contents(
      e_register->new({out=>"m_write_address",
          in=>"delayed_write_command_valid ? start_address : (increment_address ? (m_write_write ? (m_write_address + m_write_burstcount) : m_write_address) : start_address)", enable=>"~m_write_waitrequest_out & ~|burst_counter"}),
      );
       }
    } else {
      $mod->add_contents(
        e_register->new({out=>"m_write_address", 
          in=>"delayed_write_command_valid ? start_address : (increment_address ? (m_write_write ? (m_write_address + $SYMBOLS_PER_BEAT) : m_write_address) : start_address)", enable=>"~m_write_waitrequest_out"}),

      );
    }
    $mod->add_contents(

      e_register->new({out=>"eop_found_hold", in=>"eop_found_hold ? ~(sink_stream_endofpacket & sink_stream_really_valid) : eop_found", enable=>"write_go_reg"}),
      e_signal->new({name=>"burst_counter_reg", width=>$write_burst_size, never_export=>"1"}),
      e_register->new({out=>"burst_counter_reg", in=>"burst_counter", enable=>"~m_write_waitrequest_out"}),
      e_signal->new({name=>"burst_counter", width=>$write_burst_size, never_export=>"1"}),
      e_assign->new({lhs=>"burst_counter_decrement", rhs=>"|burst_counter & write_go_reg & sink_stream_really_valid"}),
      e_signal->new({name=>"burst_counter_next", width=>"$write_burst_size", never_export=>"1"}),
      e_assign->new({lhs=>"burst_counter_next", rhs=>"burst_counter - 1"}),
   
      e_process->new({
        reset => "reset_n",
        reset_level => 0,
        asynchronous_contents => [e_assign->new(["burst_counter" => "0"])],
        contents => [
          e_if->new({
            condition => "~|burst_counter & ~|burst_counter_reg & write_go_reg",
            then => [
              e_if->new({
                condition => "enough_data",
                then => ["burst_counter" => "burst_size"],
                elsif => {
                  condition => "eop_found_hold",
                  then => ["burst_counter" => "m_writefifo_fill"],
                },
              }),
            ],
            elsif => {
              condition => "~m_write_waitrequest_out",
              then => [
                e_if->new({
                  condition => "burst_counter_decrement",
                  then => ["burst_counter" => "burst_counter_next"],
                }),
              ],
            },
          }),
        ] 
      }),
     
    );
  }
  if ($SYMBOLS_PER_BEAT > 1) {
    $mod->add_contents(
      e_signal->new({name=>"sink_stream_empty", width=>$empty_signal_width}),
    );

    my $sink_stream_empty_shift = "(";
    my $sop_rx_shift = "(";

    # Consider that we have a four bit byteenable
    for (my $i=($SYMBOLS_PER_BEAT-1); $i >= 0; $i--) {
      my $bit_of_zeros = $SYMBOLS_PER_BEAT;
      my $shift_zeroes = $i . "'b0";
      my $invert_i = ($SYMBOLS_PER_BEAT-1) - $i;
      $sop_rx_shift .= "((rx_shift == $i) ? rx_shift" ."$i" .": 0)";
      $sink_stream_empty_shift .= "((sink_stream_empty == $i) ? shift" ."$i" ." : 0)";
      if ($i > 0) {
        $sink_stream_empty_shift .= " | ";
        $mod->add_contents(
          e_signal->new({name=>"shift$i", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
          e_assign->new({lhs=>"shift$i", rhs=>"{$shift_zeroes, all_one[$SYMBOLS_PER_BEAT-1-$i:0]}"}),
        );
      } else {
        $mod->add_contents(
          e_signal->new({name=>"shift$i", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
          e_assign->new({lhs=>"shift$i", rhs=>"all_one"}),
        );
	}

    if ($UNALIGNED_TRANSFER) {
      if ($i > 0) {
        $sop_rx_shift .= " | ";
        $mod->add_contents(
          e_signal->new({name=>"rx_shift$i", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
          e_assign->new({lhs=>"rx_shift$i", rhs=>"{all_one[$SYMBOLS_PER_BEAT-1-$i:0], $shift_zeroes}"}),
        );
      } else {
        $mod->add_contents(
          e_signal->new({name=>"rx_shift$i", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
          e_assign->new({lhs=>"rx_shift$i", rhs=>"all_one"}),
        );

      }	}
    }
    $sink_stream_empty_shift .= ")";
    $sop_rx_shift .= ")";
   if ($avalon_mm_byte_reorder_mode == 1){ 
       $flipped_be_signal = &swap_byteenables("$BYTEENABLE_WIDTH", "m_write_byteenable_reg");
   } else {
       $flipped_be_signal = "m_write_byteenable_reg";
   }

    $mod->add_contents(
        e_signal->new({name=>"sink_stream_empty_shift", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
        e_assign->new({lhs=>"sink_stream_empty_shift", rhs=>"$sink_stream_empty_shift"}),
	);

    if ($UNALIGNED_TRANSFER) {
      $mod->add_contents(
        e_signal->new({name=>"sop_rx_shift", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
        e_assign->new({lhs=>"sop_rx_shift", rhs=>"$sop_rx_shift"}),
        e_signal->new({name=>"byteenable_single_transfer", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
        e_assign->new({lhs=>"byteenable_single_transfer", rhs=>"(sop_rx_shift & sink_stream_empty_shift)"}),
        e_signal->new({name=>"byteenable_sop", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
        e_assign->new({lhs=>"byteenable_sop", rhs=>"sop_rx_shift"}),
        e_signal->new({name=>"byteenable_eop", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
        e_assign->new({lhs=>"byteenable_eop", rhs=>"sink_stream_empty_shift"}),
        e_assign->new({lhs=>"sop_wrbe", rhs=>"sink_stream_startofpacket & ~sink_stream_endofpacket"}), 
        e_assign->new({lhs=>"eop_wrbe", rhs=>"~sink_stream_startofpacket & sink_stream_endofpacket"}), 
        e_register->new({out=>"m_write_byteenable_reg", in=>"({$SYMBOLS_PER_BEAT {single_transfer}} & byteenable_single_transfer) | ({$SYMBOLS_PER_BEAT {sop_wrbe}} & byteenable_sop) | ({$SYMBOLS_PER_BEAT {eop_wrbe}} & byteenable_eop)", enable=>"~m_write_waitrequest_out"}), 


      );
      $byteenable_case = "sink_stream_startofpacket | sink_stream_endofpacket"; 
    } else {

      $mod->add_contents(
        e_register->new({out=>"m_write_byteenable_reg", in=>"$sink_stream_empty_shift", enable=>"~m_write_waitrequest_out"}),

      );
      $byteenable_case = "sink_stream_endofpacket";
    }

    $mod->add_contents(
      e_signal->new({name=>"m_write_byteenable_reg", width=>$SYMBOLS_PER_BEAT, never_export=>"1"}),

      e_signal->new({name=>"all_one", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
      e_assign->new({lhs=>"all_one", rhs=>"$all_one_signal"}),

      e_signal->new({name=>"m_write_byteenable_in", width=>"$SYMBOLS_PER_BEAT", never_export=>"1"}),
       e_assign->new({lhs=>"m_write_byteenable_in", rhs=>"(byteenable_enable ? $flipped_be_signal : all_one)"}),
      e_register->new({out=>"byteenable_enable", in=>"$byteenable_case", enable=>"~m_write_waitrequest_out"}),
    );
  }


}

sub make_write_block_registers {
  my $mod = shift;
  my $COMMAND_WIDTH = shift;
  my $COUNTER_WIDTH = shift;
  my $SYMBOLS_PER_BEAT = shift;
  my $UNALIGNED_TRANSFER = shift;
  my $BURST_TRANSFER  = shift;
 
  if ($UNALIGNED_TRANSFER) {
    $mod->add_contents(
      e_assign->new({lhs=>"sink_stream_ready", rhs=>"write_go_reg & ~m_write_waitrequest_out & ~eop_reg & (|bytes_to_transfer ? ~(counter >= bytes_to_transfer) : 1)"}),
    );
  } else {
    if ($BURST_TRANSFER) {
      $mod->add_contents(
        e_assign->new({lhs=>"sink_stream_ready", rhs=>"write_go_reg & ~m_write_waitrequest_out & ~eop_reg & |burst_counter"}),
      );
    } else {
      $mod->add_contents(
        e_assign->new({lhs=>"sink_stream_ready", rhs=>"write_go_reg & ~m_write_waitrequest_out & ~eop_reg & (|bytes_to_transfer ? ~(counter >= bytes_to_transfer) : 1)"}),
      );
    }
  } 
  $mod->add_contents(
    # sink_stream_ready_sig
    e_comment->new({comment=>"sink_stream_ready_sig"}),
    e_signal->new({name=>"sink_stream_ready", width=>"1", export=>"1"}),

    # sink_stream_really_valid
    e_comment->new({comment=>"sink_stream_valid is only really valid when we're ready"}),
    e_assign->new({lhs=>"sink_stream_really_valid", rhs=>"sink_stream_valid && sink_stream_ready"}),

    # write_command_data_reg
    e_comment->new({comment=>"write_command_data_reg"}),
    e_signal->new({name=>"write_command_data_reg", width=>"$COMMAND_WIDTH"}),
    e_register->new({out=>"write_command_data_reg", in=>"write_command_data", enable=>"write_command_valid"}),
    e_register->new({out=>"delayed_write_command_valid", in=>"write_command_valid", enable=>"1"}),
    
    # 8-bits up-counter
    e_comment->new({comment=>"8-bits up-counter"}),
    e_signal->new({name=>"counter", width=>"$COUNTER_WIDTH"}),
    e_register->new({out=>"counter", in=>"counter_in", enable=>"~m_write_waitrequest_out"}),
    
    # write_go bit for all of this operation until count is up
    e_comment->new({comment=>"write_go bit for all of this operation until count is up"}),
    # TODO : STATUS_TOKEN_FIFO_FULL_ERROR check that this is the behavior we are going at. 
    # Disallow the whole operation from beginning if the status_token_fifo is full
    	
    # if bytes_to_transfer is specified, follow this rule
    e_assign->new({lhs=>"write_go_reg_in", 
    	rhs=>"(delayed_write_command_valid) ? 1'b1 : (counter >= bytes_to_transfer) ? 1'b0 : write_go_reg"}),
   	# else if bytes_to_transfer == 0, terminate when we encounter an EOP
    e_assign->new({lhs=>"write_go_reg_in_teop", rhs=>"eop_reg ? ~(m_write_write & ~m_write_waitrequest_out) : 1'b1"}),
    e_register->new({out=>"eop_reg", in=>"eop_reg ? ~(m_write_write & ~m_write_waitrequest_out) : sink_stream_endofpacket & sink_stream_really_valid", enable=>"1"}),

    e_register->new({out=>"write_go_reg", in=>"(write_go_reg && (bytes_to_transfer == 0)) ? write_go_reg_in_teop : write_go_reg_in", enable=>"~m_write_waitrequest_out"}),
    e_assign->new({lhs=>"write_go", rhs=>"write_go_reg"}),
    
    # Terminated by EOP 
    # If descriptor is configured with 0 bytes_to_transfer, i.e. terminate at endofpacket, And we encounter an EOP.
    e_assign->new({lhs=>"t_eop", rhs=>"(sink_stream_endofpacket && sink_stream_really_valid) && (bytes_to_transfer == 0)"}),
    
  );

  if ($SYMBOLS_PER_BEAT > 1) {
      $mod->add_contents(
        e_signal->new({name=>"single_transfer", width=>"1", never_export=>"1"}),
        e_assign->new({lhs=>"single_transfer", rhs=>"sink_stream_startofpacket & sink_stream_endofpacket"}),
      );
    if ($UNALIGNED_TRANSFER) {
      $mod->add_contents(
        e_assign->new({lhs=>"counter_in", 
          rhs=>"(delayed_write_command_valid) ? $COUNTER_WIDTH\'b0 : (increment ? (single_transfer ? (counter + $SYMBOLS_PER_BEAT - rx_shift - sink_stream_empty) : (sink_stream_startofpacket ? (counter + $SYMBOLS_PER_BEAT - rx_shift) : (sink_stream_endofpacket ? (counter + $SYMBOLS_PER_BEAT - sink_stream_empty) : (counter + $SYMBOLS_PER_BEAT)))) : counter)"}), 
      );
    } else {
      $mod->add_contents(
        e_assign->new({lhs=>"counter_in", 
          rhs=>"(delayed_write_command_valid) ? $COUNTER_WIDTH\'b0 : (increment ? (counter + $SYMBOLS_PER_BEAT - (sink_stream_endofpacket ? sink_stream_empty : 0)) : counter)"}),
      );
    }

  } else {
    $mod->add_contents(
      e_signal->new({name=>"single_transfer", width=>"1", never_export=>"1"}),
      e_assign->new({lhs=>"single_transfer", rhs=>"sink_stream_startofpacket & sink_stream_endofpacket"}),
    );
    $mod->add_contents(
      e_assign->new({lhs=>"counter_in", 
        rhs=>"(delayed_write_command_valid) ? $COUNTER_WIDTH\'b0 : (increment ? (counter + $SYMBOLS_PER_BEAT) : counter)"}),
    );
  }
  
}


sub make_write_block_avalon_master {
  my $mod = shift;
  my $WRITE_BLOCK_DATA_WIDTH = shift;
  my $ADDRESS_WIDTH = shift;
  my $write_master_name = shift;
  my $prefix = shift;
  my $BURST_TRANSFER = shift;
  my $write_burst_size = shift;
  my $data_available_master_name = shift;
  
  $mod->add_contents(
    e_avalon_master->new({
      name => $write_master_name,
      type_map => {&get_write_master_type_map($prefix, $BURST_TRANSFER)},
    }),
    &get_write_master_ports($prefix, $WRITE_BLOCK_DATA_WIDTH, $ADDRESS_WIDTH, $BURST_TRANSFER, $write_burst_size),
  );
}

sub get_data_available_master_type_map {
  my $prefix = shift;
  my @port_types = qw(read readdata waitrequest);
  return map{($prefix . "_$_" => $_)} @port_types;
}

sub get_write_master_type_map {
  my $prefix = shift;
  my $BURST_TRANSFER = shift;

  my @port_types = &get_write_master_type_list($BURST_TRANSFER);
  return map {($prefix . "_$_" => $_)} @port_types
}

sub get_write_master_type_list {
  my $BURST_TRANSFER = shift;

  my @ports = qw(
    address
    writedata
    write
    waitrequest  
    byteenable
  );

  push (@ports, "burstcount") if $BURST_TRANSFER;  
  return @ports;
}

sub get_write_master_ports {
  my $prefix = shift;
  my $WRITE_BLOCK_DATA_WIDTH = shift;
  my $ADDRESS_WIDTH = shift;
  my $BURST_TRANSFER = shift;
  my $write_burst_size = shift;
  my @ports;
  
  my $BYTEENABLE_WIDTH = $WRITE_BLOCK_DATA_WIDTH / 8;
  
  push @ports, (
    e_port->new({
      name => $prefix . "_address",
      direction => "output",
      width => $ADDRESS_WIDTH,
      type => 'address',
    }),

    e_port->new({
      name => $prefix . "_writedata",
      direction => "output",
      width => $WRITE_BLOCK_DATA_WIDTH,
      type => 'writedata',
    }),

    e_port->new({
      name => $prefix . "_write",
      direction => "output",
      type => 'write',
    }),

    e_port->new({
      name => $prefix . "_waitrequest",
      direction => "input",
      type => "waitrequest",
    }),
    
    
  );
    
  push @ports, (
		e_port->new({
	    name => $prefix . "_byteenable",
	    width => $BYTEENABLE_WIDTH,
	    direction => "output",
	    type => "byteenable",
	  }),
  ) if ($BYTEENABLE_WIDTH > 1);
  
  push @ports, (
    e_port->new({
      name => $prefix . "_burstcount",
      type => "burstcount",
      direction => "output",
      width => "$write_burst_size"
    })
  ) if ($BURST_TRANSFER);

  return @ports;
}



# Don't call this in a Mem-To-Stream Mode you say?, this will never occur. 
# In any of the configurations where the Writeblock is present, it will be the status token generator
# However, we do not want to generate Atlantic error signals when we are in M-T-M mode.

sub make_m_write_status_token {
  my $mod 			= shift;
  my $STATUS_TOKEN_WIDTH 	= shift;
  my $BYTES_TO_TRANSFER_WIDTH 	= shift;
  my $STATUS_WIDTH 		= shift;
  my $IS_MEM_TO_MEM_MODE 	= shift;
  my $IN_ERROR_WIDTH 		= shift;
  my $MAX_SUPPORTED_ERROR_WIDTH = shift;
  
  $mod->add_contents(
    # add the input ports for the atlantic error signals
    e_port->news(&get_atlantic_error_signals()),
    
    # ports for the status_token_fifo
    e_port->news(&get_status_token_fifo_ports($STATUS_TOKEN_WIDTH)),
    
    # assign them to a status token, bitwise OR with existing status
    # two separate registers for the status and actual_bytes_transferred
    
    # status register
    e_comment->new({comment=>"status register"}),
    e_signal->new({name=>"status_reg", width=>"$STATUS_WIDTH"}),
    e_signal->new({name=>"status_word", width=>"$STATUS_WIDTH"}),
    e_assign->new({lhs=>"status_reg_in", rhs=>"write_go_fall_reg ? 0 : (status_word | status_reg)"}),
    e_register->new({out=>"status_reg", in=>"status_reg_in", enable=>"1"}),
    
    # actual_bytes_transferred register
    e_comment->new({comment=>"actual_bytes_transferred register"}),
    e_signal->new({name=>"actual_bytes_transferred", width=>"$BYTES_TO_TRANSFER_WIDTH"}),
    e_assign->new({lhs=>"actual_bytes_transferred", rhs=>"counter"}),
    
    # compose the status_token_data from both the status signals and the actual bytes transferred.
    e_comment->new({comment=>"status_token consists of the status signals and actual_bytes_transferred"}),
    e_assign->new({lhs=>"status_token_fifo_data", rhs=>"{status_reg, actual_bytes_transferred}"}),
  );
  
  if ($IS_MEM_TO_MEM_MODE) {
  	$mod->add_contents(
 	    e_assign->new({lhs=>"status_word", rhs=>"{t_eop, 7'b0}"}),
  	);
  } else {
  	$mod->add_contents(
      e_assign->new({lhs=>"status_word", rhs=>"{t_eop, e_06, e_05, e_04, e_03, e_02, e_01, e_00}"}),
		);
    if ($IN_ERROR_WIDTH > 0) {
      for (my $i=0; $i < $MAX_SUPPORTED_ERROR_WIDTH; $i++) {
        my $err_sig_name = "e_0" . $i;
        if ($i < $IN_ERROR_WIDTH) {
          $mod->add_contents(
            e_assign->new({lhs=>"$err_sig_name", rhs=>"sink_stream_error[$i]"}),
            e_signal->new({name=>"sink_stream_error", width=>$IN_ERROR_WIDTH}),
          );
        } else {
          $mod->add_contents(
            e_assign->new({lhs=>"$err_sig_name", rhs=>"1'b0"}),
          );
        }
      }
    } else {
      $mod->add_contents(
        e_assign->new({lhs=>"e_00", rhs=>"1'b0"}),
        e_assign->new({lhs=>"e_01", rhs=>"1'b0"}),
        e_assign->new({lhs=>"e_02", rhs=>"1'b0"}),
        e_assign->new({lhs=>"e_03", rhs=>"1'b0"}),
        e_assign->new({lhs=>"e_04", rhs=>"1'b0"}),
        e_assign->new({lhs=>"e_05", rhs=>"1'b0"}),
        e_assign->new({lhs=>"e_06", rhs=>"1'b0"}),
      );
    }
  }
}

sub pop_data_into_m_write_status_token_fifo {
  my $mod = shift;
  
  $mod->add_contents(
    # the status_token_fifo is populated when a falling edge is detected on the "write_go" signal
    
    # write_go falling edge detector
    e_comment->new({comment=>"delayed write go register"}),
    e_register->new({out=>"delayed_write_go", in=>"write_go_reg", enable=>"1"}),
    
    # write go falling edge detector
    e_comment->new({comment=>"write_go falling edge detector"}),
    e_assign->new({lhs=>"write_go_fall_reg_in", rhs=>"delayed_write_go && ~write_go_reg"}),
    e_register->new({out=>"write_go_fall_reg", in=>"write_go_fall_reg_in", enable=>"1"}),
    
    # TODO : STATUS_TOKEN_FIFO_FULL_ERROR this assumes that there is always place for data in the status_token_fifo and 
    # does not stop the write_block operation if the fifo is full. 
    # If fifo is full, we should wait before going off and perform the next operation.
    # We can enforce that the status_token_fifo must be empty before any operation can take place.
    # Of course, this is not the optimal operation scheme. 
    # In any case, the status_token_fifo SHOULD not be the bottleneck, if it is, that's a big No, No in the design.
    e_assign->new({lhs=>"status_token_fifo_wrreq", rhs=>"write_go_fall_reg && ~status_token_fifo_full"}),
  );
}

sub get_status_token_fifo_ports {
  my $STATUS_TOKEN_WIDTH = shift;
  
  my @ports = (
    [status_token_fifo_data=>"$STATUS_TOKEN_WIDTH"=>"output"],
    [status_token_fifo_wrreq=>1=>"output"],
    [status_token_fifo_full=>1=>"input"],
  );
}

sub get_atlantic_error_signals {
  my @ports = (
    [e_00=>1=>"input"],
    [e_01=>1=>"input"],
    [e_02=>1=>"input"],
    [e_03=>1=>"input"],
    [e_04=>1=>"input"],
    [e_05=>1=>"input"],
    [e_06=>1=>"input"],
    [t_eop=>1=>"input"],  # TODO : get this from the endofpacket signal
  );
  return @ports;
}
 sub log2 {
  my $n = shift;
  return (log($n)/log(2));
}
 sub swap_signals {
  my $SYMBOLS_PER_BEAT = shift;
  my $indata = shift;

  my $flipped_data_signal = "{";
  for (my $i=0; $i < $SYMBOLS_PER_BEAT; $i++) {
    my $lower_bound = ($i*8);
    my $upper_bound = $lower_bound + 7;
      $flipped_data_signal .= "$indata" ."[$upper_bound:$lower_bound]";
    if ($i == ($SYMBOLS_PER_BEAT -1)) {
      $flipped_data_signal .= "}";
    } else {
      $flipped_data_signal .= ", ";
    }
  }
  return $flipped_data_signal;
}
 sub swap_byteenables {
  my $BITS = shift;
  my $indata = shift;
#if there id only one bit then nothing to do
  if ($BITS == "1") {
    return $indata;
  }
  my $flipped_data_signal = "{";
  for (my $i=0; $i < $BITS; $i++) {
    my $lower_bound = ($i);
      $flipped_data_signal .= "$indata" ."[$lower_bound]";
    if ($i == ($BITS -1)) {
      $flipped_data_signal .= "}";
    } else {
      $flipped_data_signal .= ", ";
    }
  }
  return $flipped_data_signal;
}
1;    
