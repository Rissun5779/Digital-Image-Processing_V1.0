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


sub make_chain_control_status_slave {
	my $mod = shift;
  my $WSA = shift;
  

  my $CONTROL_SLAVE_ADDRESS_WIDTH = $WSA->{"control_slave_address_width"};
  my $CONTROL_SLAVE_DATA_WIDTH = $WSA->{"control_slave_data_width"};
	my $HAS_READ_BLOCK = $WSA->{"has_read_block"};
  my $HAS_WRITE_BLOCK = $WSA->{"has_write_block"};
  
  my $read_slave_name = "csr";
  my $prefix = "csr";
  my $IS_STREAM_TO_MEM_MODE = !$HAS_READ_BLOCK && $HAS_WRITE_BLOCK;
  
  &add_chain_control_slave_ports($mod, $CONTROL_SLAVE_DATA_WIDTH, $HAS_READ_BLOCK, $HAS_WRITE_BLOCK);
  &make_chain_control_avalon_slave($mod, $CONTROL_SLAVE_DATA_WIDTH, $CONTROL_SLAVE_ADDRESS_WIDTH, $read_slave_name, $prefix);
  &make_chain_control_status_slave_assignments($mod, $CONTROL_SLAVE_DATA_WIDTH, $CONTROL_SLAVE_ADDRESS_WIDTH);
  &make_chain_control_status_slave_registers($mod, $CONTROL_SLAVE_DATA_WIDTH, $CONTROL_SLAVE_ADDRESS_WIDTH, $IS_STREAM_TO_MEM_MODE, $HAS_READ_BLOCK, $HAS_WRITE_BLOCK);
  
  &make_descriptor_counter($mod);
  &create_interrupt_logic($mod);
  return $mod;
}

sub add_chain_control_slave_ports {
  my $mod = shift;
  my $CONTROL_SLAVE_DATA_WIDTH = shift;
  my $HAS_READ_BLOCK = shift;
  my $HAS_WRITE_BLOCK = shift;
  
  my @ports = (
    [clk=>1=>"input"],
    [reset_n=>1=>"input"],
    [csr_irq=>1=>"output"],
	[pollen_clear_run=>1=>"output"]
  );
  push (@ports, &get_other_control_slave_ports($CONTROL_SLAVE_DATA_WIDTH, $HAS_READ_BLOCK, $HAS_WRITE_BLOCK));
  push (@ports, &get_fifo_ports());
  $mod->add_contents(
    e_port->news(@ports),
  );
}

sub get_other_control_slave_ports {
  my $CONTROL_SLAVE_DATA_WIDTH = shift;
  my $HAS_READ_BLOCK = shift;
  my $HAS_WRITE_BLOCK = shift;
  my $IS_STREAM_TO_MEM_MODE = !$HAS_READ_BLOCK && $HAS_WRITE_BLOCK;
  
  my @ports = (
    [owned_by_hw=>1=>"input"],
    
    [descriptor_pointer_upper_reg_out=>$CONTROL_SLAVE_DATA_WIDTH=>"output"],
    [descriptor_pointer_lower_reg_out=>$CONTROL_SLAVE_DATA_WIDTH=>"output"],
  
    # Control register output
    [sw_reset=>1=>"output"],
    [run=>1=>"output"],
    [park=>1=>"output"],
    
    # Tap this port to signal descriptor done
    [descriptor_write_write=>1=>"input"],

    # Tap this port to know descriptor write is really busy
    [descriptor_write_busy=>1=>"input"],

    # Tap this port to know if I'm busy
    [chain_run=>1=>"input"],
  );
  
  if ($IS_STREAM_TO_MEM_MODE) {
  	push (@ports, [t_eop=>1=>"input"]);
  }
  if ($HAS_WRITE_BLOCK) {
  	push (@ports, [write_go=>1=>"input"]);
  } 
  if ($HAS_READ_BLOCK) {
  	push (@ports, [read_go=>1=>"input"]);
  }
  
  return @ports;
}

sub get_fifo_ports {
  my @ports = (
    [command_fifo_empty=>1=>"input"],
    [desc_address_fifo_empty=>1=>"input"],
    [status_token_fifo_empty=>1=>"input"],
    [status_token_fifo_rdreq=>1=>"input"],
    
  );
  return @ports;
}

# Control/status register.
# Address | 31 : 24 | 23 : 16 | 15 : 8 | 7 : 0   |
#    0    |                            |  Status |
#    4    |                   |     Control      |
#    8    |            Descriptor                |
#    C    |              Pointer                 |

sub make_chain_control_status_slave_assignments {
  my $mod = shift;
  my $CONTROL_SLAVE_DATA_WIDTH = shift;
  my $CONTROL_SLAVE_ADDRESS_WIDTH = shift;
  my $PREPEND_WIDTH = $CONTROL_SLAVE_ADDRESS_WIDTH-4;
  my $status_reg_addr;
  my $version_reg_addr;
  my $control_reg_addr;
  my $descriptor_pointer_upper_reg_addr;
  my $descriptor_pointer_lower_reg_addr;

  if ($PREPEND_WIDTH > 0) {
  $status_reg_addr  = "{$PREPEND_WIDTH\'b0, 4\'b0000}";
  $version_reg_addr = "{$PREPEND_WIDTH\'b0, 4\'b0001}";
  $control_reg_addr = "{$PREPEND_WIDTH\'b0, 4\'b0100}";
  $descriptor_pointer_upper_reg_addr = "{$PREPEND_WIDTH\'b0, 4\'b1100}";
  $descriptor_pointer_lower_reg_addr = "{$PREPEND_WIDTH\'b0, 4\'b1000}";
  } else {
  $status_reg_addr  = "{4\'b0000}";
  $version_reg_addr = "{4\'b0001}";
  $control_reg_addr = "{4\'b0100}";
  $descriptor_pointer_upper_reg_addr = "{4\'b1100}";
  $descriptor_pointer_lower_reg_addr = "{4\'b1000}";
  }
  $mod->add_contents(

    e_comment->new({comment=>"Control Status Register (Readdata)"}),

    e_process->new({
      reset => "reset_n",
      reset_level => 0,
      asynchronous_contents => [e_assign->new(["csr_readdata" => "0"]),],
      contents => [
        e_if->new({
          condition => "csr_read",
          then => [
            e_case->new({
              switch => "csr_address",
              parallel => "1",
              default_sim => 0,
              contents => {
					$status_reg_addr => [
					e_assign->new({lhs=>"csr_readdata", rhs=>"status_reg"}),
					],
					$version_reg_addr => [
					e_assign->new({lhs=>"csr_readdata", rhs=>"version_reg"}),
					],
					$control_reg_addr => [
					e_assign->new({lhs=>"csr_readdata", rhs=>"control_reg"}),
					],
					$descriptor_pointer_upper_reg_addr => [
					e_assign->new({lhs=>"csr_readdata", rhs=>"descriptor_pointer_upper_reg"}),
					],
					$descriptor_pointer_lower_reg_addr => [
					e_assign->new({lhs=>"csr_readdata", rhs=>"descriptor_pointer_lower_reg"}),
					],
					default=> [
					e_assign->new({lhs=>"csr_readdata", rhs=>"$CONTROL_SLAVE_DATA_WIDTH\'b0"}),
					], # default
				}, 
            }), # e_case
          ], # then
        }), # e_if
      ], # process contents
    }), # e_process

    
    # register outs
    e_comment->new({comment=>"register outs"}),
    e_assign->new({lhs=>"descriptor_pointer_upper_reg_out", rhs=>"descriptor_pointer_upper_reg"}),
    e_assign->new({lhs=>"descriptor_pointer_lower_reg_out", rhs=>"descriptor_pointer_lower_reg"}),
    
    # control register bits
    e_comment->new({comment=>"control register bits"}),
    e_assign->new({lhs=>"ie_error", rhs=>"control_reg[0]"}),
    e_assign->new({lhs=>"ie_eop_encountered", rhs=>"control_reg[1]"}),
    e_assign->new({lhs=>"ie_descriptor_completed", rhs=>"control_reg[2]"}),
    e_assign->new({lhs=>"ie_chain_completed", rhs=>"control_reg[3]"}),
    e_assign->new({lhs=>"ie_global", rhs=>"control_reg[4]"}),
	# run needs to be reaserted in polling mode when do_restart is asserted
    e_assign->new({lhs=>"run", rhs=>"control_reg[5] && (!(stop_dma_error && error) && ((!chain_completed_int ) ||( do_restart && poll_en && chain_completed_int)))"}),
    e_register->new({out=>"delayed_run", in=>"run", enable=>"1"}),
    e_assign->new({lhs=>"stop_dma_error", rhs=>"control_reg[6]"}),
    e_assign->new({lhs=>"ie_max_desc_processed", rhs=>"control_reg[7]"}),
    e_assign->new({lhs=>"max_desc_processed", rhs=>"control_reg[15:8]"}),
    e_signal->new({name=>"max_desc_processed", width=>8}),
    e_assign->new({lhs=>"sw_reset", rhs=>"control_reg[16]"}),
    
    # park feature
    e_assign->new({lhs=>"park", rhs=>"control_reg[17]"}),
    
	#    needed to add the poll enable bit to the status register and the
	#    time out register.  value in the time out register coresponds to timeout_reg * 32 +31 clock delay
	#    between polling periods.
	#    and the do restart logic.
     e_assign->new({lhs=>"poll_en", rhs=>"control_reg[18]"}),
     e_signal->new({name=>"timeout_reg", width=>11}),
     e_assign->new({lhs=>"timeout_reg", rhs=>"control_reg[30:20] "}),
     e_signal->new({name=>"timeout_counter", width=>16}),
     e_register->new({out=>"timeout_counter", in=>"do_restart ? 0:(timeout_counter + 1'b1)", enable=>"(control_reg[5] && !busy && poll_en )|| do_restart"}),
     e_register->new({out=>"do_restart_compare", in=>"timeout_counter == {timeout_reg,5'b11111}", enable=>"1"}),
     e_register->new({out=>"do_restart", in=>"poll_en && do_restart_compare", enable=>"1"}),
    e_register->new({out=>"clear_interrupt", in=>"control_reg_en ? csr_writedata[31] : 0", enable=>"1"}),

  );
}

sub make_chain_control_status_slave_registers {
  my $mod = shift;
  my $CONTROL_SLAVE_DATA_WIDTH = shift;
  my $CONTROL_SLAVE_ADDRESS_WIDTH = shift;
  my $IS_STREAM_TO_MEM_MODE = shift;
  my $HAS_READ_BLOCK = shift;
  my $HAS_WRITE_BLOCK = shift;
  my $prepend_zero;

  my $PREPEND_WIDTH = $CONTROL_SLAVE_ADDRESS_WIDTH-4;


  my $busy_indicator = "~command_fifo_empty || ~status_token_fifo_empty || ~desc_address_fifo_empty || chain_run || descriptor_write_busy || delayed_csr_write || owned_by_hw";
  if ($HAS_WRITE_BLOCK) {
    $busy_indicator .= " || write_go";
  } 
  if ($HAS_READ_BLOCK) {
    $busy_indicator .= " || read_go";
  }
  
  if ($PREPEND_WIDTH > 0) {
  $prepend_zero = "$PREPEND_WIDTH\'b0,";
} else {
  $prepend_zero = "";
}

  $mod->add_contents(
    # control register
    e_comment->new({comment=>"control register"}),
    e_assign->new({lhs=>"control_reg_en", 
      rhs=>"(csr_address == {$prepend_zero 4\'b0100}) && csr_write && csr_chipselect"}),
    e_signal->new({name=>"control_reg", width=>"$CONTROL_SLAVE_DATA_WIDTH"}),

    # we do not register bit 31 which is a clear_interrupt command
    e_register->new({out=>"control_reg", in=>"{1'b0, csr_writedata[30:0]}", enable=>"control_reg_en"}),
    
    # descriptor_pointer_upper_reg
    e_comment->new({comment=>"descriptor_pointer_upper_reg"}),
    e_assign->new({lhs=>"descriptor_pointer_upper_reg_en", 
      rhs=>"(csr_address == {$prepend_zero 4\'b1100}) && csr_write && csr_chipselect"}),
    e_signal->new({name=>"descriptor_pointer_upper_reg", width=>"$CONTROL_SLAVE_DATA_WIDTH"}),
    e_register->new({out=>"descriptor_pointer_upper_reg", in=>"csr_writedata", enable=>"descriptor_pointer_upper_reg_en"}),
    
	# added discriptor_read_read
	# when it rises need to update the descriptor pointer with descriptor_read_address
	# otherwise if the data is being written in the port pass the info along.
	# can be an issue if this value is written to while the SGDMA is running.

    e_comment->new({comment=>"section to update the descriptor pointer"}),
	# add a registered version of read read
    e_register->new({out=>"descriptor_read_read_r", in=>"descriptor_read_read",enable=>"1"}),
	# determine the rising edge.
    e_assign->new({lhs=>"descriptor_read_read_rising",
      rhs=>"descriptor_read_read && !descriptor_read_read_r"}),
	# mux the bus adata with the new deswcriptor pointer.
    e_signal->new({name=>"descriptor_pointer_data", width=>"$CONTROL_SLAVE_DATA_WIDTH"}),
    e_assign->new({lhs=>"descriptor_pointer_data",
      rhs=>"descriptor_read_read_rising ? descriptor_read_address:csr_writedata"}),

    e_comment->new({comment=>"descriptor_pointer_lower_reg"}),
    e_assign->new({lhs=>"descriptor_pointer_lower_reg_en",
      rhs=>"((csr_address == {$prepend_zero 4\'b1000}) && csr_write && csr_chipselect) || (poll_en && descriptor_read_read_rising)"}),
    e_signal->new({name=>"descriptor_pointer_lower_reg", width=>"$CONTROL_SLAVE_DATA_WIDTH"}),
	#   need to pass in the option of csr_write or descriptor_pointer_data
	#   so the descriptor pointer can be updated with each descriptor for poll_en mode.
    e_register->new({out=>"descriptor_pointer_lower_reg", in=>"descriptor_pointer_data", enable=>"descriptor_pointer_lower_reg_en"}),


    e_comment->new({comment=>"Hardware Version Register"}),
    e_signal->new({name=>"hw_version", width=>4}),
    e_assign->new({lhs=>"hw_version", rhs=>"4\'b0001"}),
	e_assign->new({lhs=>"version_reg", rhs=>"{24'h000000, hw_version}"}),

    e_comment->new({comment=>"status register"}),
    e_signal->new({name=>"status_reg", width=>"$CONTROL_SLAVE_DATA_WIDTH"}),
	e_assign->new({lhs=>"status_reg", rhs=>"{27'b0, busy, chain_completed, descriptor_completed, eop_encountered, error}"}),

	e_register->new({out=>"busy", in=>"$busy_indicator", enable=>"1"}),

  	e_comment->new({comment=>"Chain Completed Status Register"}),
	e_register->new({out=>"chain_completed", in=>"(clear_chain_completed || do_restart)? 1'b0 : ~delayed_csr_write",
			enable=>"(run && ~owned_by_hw && ~busy) || clear_chain_completed || do_restart"}),


  	e_comment->new({comment=>"chain_completed_int is the internal chain completed state for SGDMA."}),
  	e_comment->new({comment=>"Will not be affected with clearing of chain_completed Status Register,to prevent SGDMA being restarted when the status bit is cleared"}),
    e_register->new({out=>"chain_completed_int", in=>"(clear_run || do_restart) ? 1'b0 : ~delayed_csr_write",
                        enable=>"(run && ~owned_by_hw && ~busy) || clear_run || do_restart"}),
    e_register->new({out=>"delayed_csr_write", in=>"csr_write", enable=>"1"}),
	e_register->new({out=>"descriptor_completed", in=>"~clear_descriptor_completed", 
			enable=>"descriptor_write_write_fall || clear_descriptor_completed"}),
	e_register->new({out=>"error", in=>"~clear_error", enable=>"atlantic_error || clear_error"}),
		
		# clear bits for the individual parts of the status register
		e_assign->new({lhs=>"csr_status", rhs=>"csr_write && csr_chipselect && (csr_address == $CONTROL_SLAVE_ADDRESS_WIDTH\'b0)"}),
		e_assign->new({lhs=>"clear_chain_completed", rhs=>"csr_writedata[3] && csr_status"}),
		e_assign->new({lhs=>"clear_descriptor_completed", rhs=>"csr_writedata[2] && csr_status"}),
		e_assign->new({lhs=>"clear_error", rhs=>"csr_writedata[0] && csr_status"}),
		e_assign->new({lhs=>"csr_control", rhs=>"csr_write && csr_chipselect && (csr_address == $CONTROL_SLAVE_ADDRESS_WIDTH\'h4)"}),
        e_assign->new({lhs=>"clear_run", rhs=>"!csr_writedata[5] && csr_control"}),
        e_assign->new({lhs=>"pollen_clear_run", rhs=>"poll_en & clear_run"}),

    # eop_encountered rising edge detector
    e_register->new({out=>"delayed_eop_encountered", in=>"eop_encountered", enable=>"1"}),
    e_assign->new({lhs=>"eop_encountered_rise", rhs=>"~delayed_eop_encountered && eop_encountered"}),

    # descriptor_write_write rising edge detector, this is used in place of descriptor_completed
    e_register->new({out=>"delayed_descriptor_write_write", in=>"descriptor_write_write", enable=>"1"}),
    e_assign->new({lhs=>"descriptor_write_write_fall", rhs=>"delayed_descriptor_write_write && ~descriptor_write_write"}),
  );
  
  if ($IS_STREAM_TO_MEM_MODE) {
  	$mod->add_contents(
  		# eop_encountered register - only in S-T-M mode.
    	e_comment->new({comment=>"eop_encountered register"}),
    	e_assign->new({lhs=>"clear_eop_encountered", rhs=>"csr_writedata[1] && csr_status"}),
		  e_register->new({out=>"eop_encountered", in=>"~clear_eop_encountered", enable=>"t_eop || clear_eop_encountered"}),
    );
  } else {
  	$mod->add_contents(
    	e_assign->new({lhs=>"eop_encountered", rhs=>"1'b0"}),
    );
  }
  
  $mod->add_contents(
    e_comment->new({comment=>"chain_completed rising edge detector"}),
    e_register->new({out=>"delayed_chain_completed_int", in=>"chain_completed_int", enable=>"1"}),
    e_register->new({out=>"can_have_new_chain_complete", in=>"descriptor_write_write", enable=>"descriptor_write_write || (~delayed_chain_completed_int && chain_completed_int) "}),
    e_assign->new({lhs=>"chain_completed_int_rise", rhs=>"~delayed_chain_completed_int && chain_completed_int && can_have_new_chain_complete"}),

  );

}

sub make_descriptor_counter {
	my $mod = shift;
	
	$mod->add_contents(
		# taps onto the status_token_fifo_rdreq because that is a one clock-cycle signal
		# we don't want the counter to have multiple-increment when only one descriptor has completed now, do we?
		e_signal->new({name=>"descriptor_counter", width=>8}),
		e_register->new({out=>"descriptor_counter", in=>"descriptor_counter + 1'b1", enable=>"status_token_fifo_rdreq"}),
                e_register->new({out=>"delayed_descriptor_counter", in=>"descriptor_counter", enable=>"1"}),
	);
}


sub create_interrupt_logic {
	my $mod = shift;
	
	my $interrupt_condition = "delayed_run && ie_global && ";
	$interrupt_condition .= "((ie_error && error) || (ie_eop_encountered && eop_encountered_rise) || (ie_descriptor_completed && descriptor_write_write_fall) || ";
	$interrupt_condition .= "(ie_chain_completed && chain_completed_int_rise) || (ie_max_desc_processed && (descriptor_counter == max_desc_processed) && (delayed_descriptor_counter == delayed_max_desc_processed) ))";
	
	# Adding a 8 bit wire to force the delayed_max_desc to be 8 bit after subtracting by 1
	$mod->add_contents(
	    e_assign->new({lhs=>"delayed_max_desc_processed", rhs=>"max_desc_processed - 1"}),
	    e_signal->new({name=>"delayed_max_desc_processed", width=>8}),
		e_register->new({out=>"csr_irq", in=>"csr_irq ? ~clear_interrupt : ($interrupt_condition)", enable=>"1"}),
	);
}
  
sub make_chain_control_avalon_slave {
  my $mod = shift;
  my $CONTROL_SLAVE_DATA_WIDTH = shift;
  my $CONTROL_SLAVE_ADDRESS_WIDTH = shift;
  my $read_slave_name = shift;
  my $prefix = shift;
  
  $mod->add_contents(
    e_avalon_slave->new({
      name => $read_slave_name,
      type_map => {get_read_slave_type_map($prefix)},
    }),
    &get_control_slave_ports($prefix, $CONTROL_SLAVE_DATA_WIDTH, $CONTROL_SLAVE_ADDRESS_WIDTH),
  );
}

sub get_read_slave_type_map {
  my $prefix = shift;
  my @port_types = &get_read_slave_type_list();
  my @port_map = map {($prefix . "_$_" => $_)} @port_types;
  # We need at least one control slave with the reset_n mapping
  push (@port_map, ("system_reset_n" => "reset_n"));
  return @port_map;
}

sub get_read_slave_type_list {
  return qw(
    address
    readdata
    read
    writedata
    write
    chipselect
    irq

  );
}

sub get_control_slave_ports {
  my $prefix = shift;
  my $CONTROL_SLAVE_DATA_WIDTH = shift;
  my $CONTROL_SLAVE_ADDRESS_WIDTH = shift;
  my @ports;
  
  push @ports, (
    e_port->new({
      name => $prefix . "_address",
      direction => "input",
      width => $CONTROL_SLAVE_ADDRESS_WIDTH,
      type => 'address',
    }),

    e_port->new({
      name => $prefix . "_readdata",
      direction => "output",
      width => $CONTROL_SLAVE_DATA_WIDTH,
      type => 'readdata',
    }),

    e_port->new({
      name => $prefix . "_read",
      direction => "input",
      type => 'read',
    }),

    e_port->new({
      name => $prefix . "_writedata",
      direction => "input",
      width => $CONTROL_SLAVE_DATA_WIDTH,
      type => 'writedata',
    }),

    e_port->new({
      name => $prefix . "_write",
      direction => "input",
      type => 'write',
    }),

    e_port->new({
      name => $prefix . "_chipselect",
      direction => "input",
     type => 'chipselect',
    }),
    
  );
    
  return @ports;
}


1;


