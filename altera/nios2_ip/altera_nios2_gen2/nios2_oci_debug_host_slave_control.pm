#Copyright (C) 2016 Intel Corporation. All rights reserved. 
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Intel or a partner
#under Intel's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Intel.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Intel or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Intel or a
#megafunction partner, remains with Intel, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.






















use cpu_utils;
use cpu_file_utils;
use nios2_insts;
use nios2_control_regs;
use nios_common;
use europa_all;
use cpu_control_reg;
use strict;


sub make_nios2_oci_debug_host_slave_control
{
  my $Opt = shift;

  my $DEBUG_HOST_SLAVE_DATA_WIDTH = 32;
  

  my $DEBUG_HOST_SLAVE_ADDRESS_WIDTH = 8;
  my $DEBUG_HOST_SLAVE_WORD_ADDRESS_WIDTH = 6;
  
  my $trace_addr_width = $Opt->{oci_trace_addr_width} + 1;
 
  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_debug_host_slave_control",
  });

  $module->add_contents (
      e_port->adds (
        ["debug_host_slave_address",     $DEBUG_HOST_SLAVE_ADDRESS_WIDTH,"in"],
        ["debug_host_slave_writedata",   $DEBUG_HOST_SLAVE_DATA_WIDTH,   "in"],
        ["debug_host_slave_readdata",    $DEBUG_HOST_SLAVE_DATA_WIDTH,  "out"],
        ["debug_host_slave_write",       1,   "in"],
        ["debug_host_slave_read",        1,   "in"],
        ["debug_host_slave_waitrequest",        1,   "out"],
        ["host_data_reg_valid",          1,   "out"],
        ["host_data_reg_write",          1,   "out"],
        ["debug_extra",                  2,   "in"],
        ["debugack",                     1,   "in"],
        ["host_trigger_break_on_reset_inst_valid",                     1,   "in"],
      ),
  );

  if (manditory_bool($Opt, "oci_onchip_trace")) {
    $module->add_contents (
      e_port->adds (
        ["debug_trace_slave_address",     $trace_addr_width,"in"],
        ["debug_trace_slave_read",        1                ,"in"],
        ["debug_trace_slave_readdata",    $DEBUG_HOST_SLAVE_DATA_WIDTH,   "out"],
      ),
  );
  }
  
  $module->add_contents (
      e_assign->news (
        [["debug_host_slave_word_address", $DEBUG_HOST_SLAVE_WORD_ADDRESS_WIDTH],    "debug_host_slave_address[$DEBUG_HOST_SLAVE_ADDRESS_WIDTH-1:2]" ],


        [["debug_host_slave_waitrequest", 1],    "((debug_host_slave_word_address == 8)  |
                                                   (debug_host_slave_word_address == 10)  |
                                                   fast_register_rd_sel) & host_data_reg_pending" ],
        [["fast_register_rd_sel", 1], $Opt->{oci_fast_reg_rd} ? "debug_host_slave_word_address == 11" : "1'b0" ],
        
        [["debug_go", 1],        "debug_extra[0]" ],
        [["debug_cancel", 1],    "debug_extra[1]" ],
        [["debug_host_slave_write_valid", 1],    "debug_host_slave_write & ~debug_cancel" ],
        
      ),
   );
  

    $module->add_contents (
    e_assign->news (
      [["crom_access", 1], "debug_host_slave_word_address[$DEBUG_HOST_SLAVE_WORD_ADDRESS_WIDTH-1:3] == 0" ],
    ),
  );
  
  $module->add_contents ( 
    e_mux->new ({
      lhs => ["cfgrom_readdata", 32],
      selecto => "debug_host_slave_word_address[2:0]",
      table => make_cfgrom_table_version2($Opt),
    }),
  );


  $module->add_contents (
    e_assign->news (
      [["host_data_reg_write", 1], "((debug_host_slave_word_address == 8) & debug_host_slave_write_valid & ~(host_data_reg_write_pending|oci_debug_mode_exc)) | fast_memory_instruction_stream_active | fast_register_instruction_stream_active" ],
      [["host_data_reg_read", 1], "((debug_host_slave_word_address == 8) & debug_host_slave_read) | fast_memory_read_starting | fast_register_read" ],
      [["host_data_reg_writedata", 32], "(fast_memory_any_active | fast_register_active) ? fast_access_iw :
                                         debug_host_slave_writedata" ],
    ),
    
    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_data_reg_write_pending"],
            asynchronous_contents => [
              e_assign->news (["host_data_reg_write_pending"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["host_data_reg_write_pending" => "(((debug_host_slave_word_address == 8) & debug_host_slave_write_valid) & ~debugack) & ~(fast_memory_any_active|fast_register_active) ? 1'b1 : 
                                                          (debugack | debug_cancel) ? 1'b0 : 
                                                          host_data_reg_write_pending"],
                  ),], 
    }),
  );


  $module->add_contents (
    e_assign->news (
      [["host_inst_count_register_write", 1], "(debug_host_slave_word_address == 9) & debug_host_slave_write_valid" ],
      [["host_inst_count_register_read", 1],  "(debug_host_slave_word_address == 9) & debug_host_slave_read" ],

      [["host_inst_count_register_writedata", 18], "debug_host_slave_writedata[17:0]" ],
    ),

    e_signal->news (
      ["host_inst_count_register", 18],
    ),

    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_inst_count_register"],
            asynchronous_contents => [
              e_assign->news (["host_inst_count_register"   => "18'h0"],),],
            contents  => [
              e_if->new ({ condition => "~oci_debug_mode_exc", then => [ 
                  e_assign->news (
                      ["host_inst_count_register" => "host_inst_count_register_write ? host_inst_count_register_writedata :
                                                                (W_valid & debugack) ? host_inst_count_register + 1 :
                                                                					   host_inst_count_register"],
                  ),
              ],
              },), 
            ], 
    }),
  );
  

 












  my $is_cpu_arch_rev2 = ($Opt->{cpu_arch_rev} == 2);

  my $write_sequence_1 = $is_cpu_arch_rev2 ? "{fast_memory_reg[31:16],16'h1834}" : "{5'h0,5'h3,fast_memory_reg[31:16],6'h34}";
  my $write_sequence_2 = $is_cpu_arch_rev2 ? "{fast_memory_reg[15:0],16'h18d4}"  : "{5'h3,5'h3,fast_memory_reg[15:0],6'h14}";
  my $write_sequence_3 = $is_cpu_arch_rev2 ? "32'h000018b7" : "32'h10c00015";
  my $write_sequence_4 = $is_cpu_arch_rev2 ? "32'h00041084" : "32'h10800104";
  
  my $read_sequence_1 = $is_cpu_arch_rev2 ? "32'h00001897" : "32'h10c00017";
  my $read_sequence_2 = $is_cpu_arch_rev2 ? "32'h00041084" : "32'h10800104";
  my $read_sequence_3 = $is_cpu_arch_rev2 ? "32'hbbe000e0" : "32'h180177fa";
  
  $module->add_contents (
    e_assign->news (
      [["fast_memory_write_starting", 1], "(debug_host_slave_word_address == 10) & debug_host_slave_write_valid & ~(fast_memory_any_active|fast_register_active|host_data_reg_write_pending|oci_debug_mode_exc)" ],
      [["fast_memory_read_starting", 1],  "(debug_host_slave_word_address == 10) & debug_host_slave_read & ~debug_cancel & ~(fast_memory_any_active|fast_register_active|host_data_reg_write_pending|oci_debug_mode_exc)" ],
      

      [["fast_memory_write_iw", 32], "fast_memory_counter == 3 ? ${write_sequence_1} :
                                      fast_memory_counter == 2 ? ${write_sequence_4} :
                                      fast_memory_counter == 1 ? ${write_sequence_3} :
                                      ${write_sequence_2}" ],
      [["fast_memory_read_iw", 32], "fast_memory_counter == 3 ? ${read_sequence_1} :
                                     fast_memory_counter == 2 ? ${read_sequence_3} :
                                     ${read_sequence_2}" ],
      [["fast_memory_instruction_stream_active", 1], "fast_memory_write_starting_d1 | fast_memory_read_starting_d1 | (W_valid & fast_memory_counter !=3)" ],
      [["fast_memory_any_active", 1], "fast_memory_read_active | fast_memory_write_active | (fast_register_active & ~debugack & ~debug_cancel)" ],
      [["fast_memory_done", 1], "(fast_memory_counter == 3 & W_valid & debugack & fast_memory_any_active & ~(fast_memory_write_starting_d1 | fast_memory_read_starting_d1)) | debug_cancel" ],
    ),
    
    e_signal->news (
      ["fast_memory_reg", 32],
      ["fast_memory_counter", 2],
    ),

    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_memory_reg"],
            asynchronous_contents => [ e_assign->news (["fast_memory_reg"   => "32'h0"],),],
            contents  => [
              e_if->new ({ condition => "fast_memory_write_starting", then => [ 
                  e_assign->news (
                      ["fast_memory_reg" => "debug_host_slave_writedata"],
                  ),
              ],
              },), 
            ], 
    }),
    
    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_memory_write_starting_d1"],
            asynchronous_contents => [ e_assign->news (["fast_memory_write_starting_d1"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["fast_memory_write_starting_d1" => "fast_memory_write_starting  | (fast_memory_write_active & ~debugack & ~debug_cancel)"],
                  ),], 
    }),
    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_memory_read_starting_d1"],
            asynchronous_contents => [ e_assign->news (["fast_memory_read_starting_d1"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["fast_memory_read_starting_d1" => "fast_memory_read_starting  | (fast_memory_read_active & ~debugack & ~debug_cancel)"],
                  ),], 
    }),
    


    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_memory_counter"],
            asynchronous_contents => [ e_assign->news (["fast_memory_counter"   => "2'h3"],),],
            contents  => [
              e_if->new ({ condition => "(((W_valid & fast_memory_counter != 3) |fast_memory_write_starting_d1|fast_memory_read_starting_d1) & debugack) | debug_cancel", then => [ 
                  e_assign->news (
                      ["fast_memory_counter" => "debug_cancel ? 2'b11 :
                                     fast_memory_write_starting_d1 ? 2'b00 :
                                     fast_memory_read_starting_d1 ? 2'b01 :
                                     fast_memory_counter + 1"],
                  ),
              ],
              },), 
            ], 
    }),
       

    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_memory_write_active"],
            asynchronous_contents => [ e_assign->news (["fast_memory_write_active"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["fast_memory_write_active" => "fast_memory_write_starting ? 1'b1 : 
                                                       fast_memory_done ? 1'b0 : 
                                                       fast_memory_write_active"],
                  ),], 
    }),
    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_memory_read_active"],
            asynchronous_contents => [ e_assign->news (["fast_memory_read_active"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["fast_memory_read_active" => "fast_memory_read_starting ? 1'b1 : 
                                                      fast_memory_done ? 1'b0 : 
                                                      fast_memory_read_active"],
                  ),], 
    }),    
  );
  





  my $control_regs = manditory_array($Opt, "control_regs");
  my $number_of_ctl_reg = 0;
  my $ctl_num;
  my @ctl_reg_array;
  
  my $sim_present = manditory_bool($Opt, "sim_reg_present");
  
  foreach my $control_reg (@$control_regs) {
      $number_of_ctl_reg = $number_of_ctl_reg + 1;
  }

  my $max_register_count = 0;
  if ($sim_present) {
  	  $max_register_count = 30 + $number_of_ctl_reg - 2;  # ctl31, ctl6 is not counted
  } else {
  	  $max_register_count = 30 + $number_of_ctl_reg - 1;  # ctl31
  }

  foreach my $control_reg (@$control_regs) {
      $ctl_num = get_control_reg_num($control_reg);
      if (($ctl_num == 31) || ($ctl_num == 0) || ($ctl_num == 6)) {

      } else {
          unshift(@ctl_reg_array,$ctl_num);
      }
  }
  
  my @control_reg_expr;
  my $control_reg_num = $max_register_count - 1;

  foreach my $control_reg (@ctl_reg_array) {
      push(@control_reg_expr, "fast_register_counter == ${control_reg_num} ? 5'd${control_reg} :");
      $control_reg_num = $control_reg_num - 1;
  }

  $control_reg_num = $max_register_count - 1;




  
  my $fast_reg_rd_sequence_1 = $is_cpu_arch_rev2 ? "{6'h26,ctl_number,5'h19,5'h0,5'h0      ,6'h20}" : "{5'h0      ,5'h0,5'h19,6'h26,ctl_number,6'h3a}" ;
  my $fast_reg_rd_sequence_2 = $is_cpu_arch_rev2 ? "{6'h2e,5'h1f     ,5'h0 ,5'h0,gpr_number,6'h20}" : "{gpr_number,5'h0,5'h0 ,6'h2e,5'h1f     ,6'h3a}" ;
  
  if ($Opt->{oci_fast_reg_rd}) {
  $module->add_contents (
    e_assign->news (

      [["fast_register_write", 1], "(debug_host_slave_word_address == 11) & debug_host_slave_write_valid & ~(fast_memory_any_active|fast_register_active|host_data_reg_write_pending|oci_debug_mode_exc)" ],
      [["fast_register_read", 1],  "(debug_host_slave_word_address == 11) & debug_host_slave_read & ~debug_cancel & ~(fast_memory_any_active|fast_register_active|host_data_reg_write_pending|oci_debug_mode_exc)" ],
      

      [["gpr_number", 5],  "fast_register_counter > 29 ? 5'd25 :
                            fast_register_counter > 23 ? fast_register_counter + 2 :
                            fast_register_counter + 1" ],
      [["ctl_number", 5],  join(' ', @control_reg_expr) . "5'd0" ],


      [["fast_register_iw", 32],  "fast_register_last ? ${fast_reg_rd_sequence_2} :
                                   ${fast_reg_rd_sequence_1}" ],

      [["fast_register_last", 1],  "fast_register_counter < 30 | ctl_reg_second_instruction" ],
      

      [["fast_register_instruction_stream_active", 1],  "fast_register_any_d1 | (ctl_reg_ignore_valid & W_valid)" ],
    ),
    
    e_signal->news (
      ["fast_register_counter", 6],
      ["fast_memory_counter", 2],
    ),

    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_register_counter"],
            asynchronous_contents => [ e_assign->news (["fast_register_counter"   => "6'h0"],),],
            contents  => [
              e_if->new ({ condition => "fast_register_write|(fast_register_instruction_stream_active & fast_register_last & debugack)", then => [ 
                  e_assign->news (
                      ["fast_register_counter" => "fast_register_write ? debug_host_slave_writedata[5 : 0] :
                                                    fast_register_counter == ${control_reg_num} ? 0 :
                                                    fast_register_counter + 1"],
                  ),
              ],
              },), 
            ], 
    }),

    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["ctl_reg_second_instruction"],
            asynchronous_contents => [ e_assign->news (["ctl_reg_second_instruction"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["ctl_reg_second_instruction" => "fast_register_counter > 29 & fast_register_active & debugack"],
                  ),], 
    }),

    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["ctl_reg_ignore_valid"],
            asynchronous_contents => [ e_assign->news (["ctl_reg_ignore_valid"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["ctl_reg_ignore_valid" => "fast_register_counter > 29 & fast_register_any_d1 ? 1'b1 : 
                                                   W_valid ? 1'b0 :
                                                   ctl_reg_ignore_valid"],
                  ),], 
    }),

    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_register_active"],
            asynchronous_contents => [ e_assign->news (["fast_register_active"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["fast_register_active" => "fast_register_write | fast_register_read ? 1'b1 : 
                                                   ~ctl_reg_ignore_valid & W_valid & debugack? 1'b0 : 
                                                   fast_register_active"],
                  ),], 
    }),
    e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["fast_register_any_d1"],
            asynchronous_contents => [ e_assign->news (["fast_register_any_d1"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["fast_register_any_d1" => "fast_register_write | fast_register_read | (fast_register_active & ~debugack & ~debug_cancel)"],
                  ),], 
    }),

    e_assign->news (

      [["fast_access_sel", 2], "{fast_memory_write_active,fast_memory_read_active}" ],
      [["fast_access_iw", 32], "(fast_access_sel == 2'b10) ? fast_memory_write_iw : 
                                (fast_access_sel == 2'b01) ? fast_memory_read_iw : 
                                fast_register_iw"],
    ),
    
  );
  } else {
    $module->add_contents (
      e_assign->news (

        [["fast_register_write", 1], "1'b0" ],
        [["fast_register_read", 1],  "1'b0" ],
        [["fast_register_active", 1],  "1'b0" ],
        [["fast_register_instruction_stream_active", 1],  "1'b0" ],
        [["ctl_reg_ignore_valid", 1],  "1'b0" ],
      ),
      
      e_assign->news (

      [["fast_access_iw", 32], "fast_memory_write_active ? fast_memory_write_iw : 
                                fast_memory_read_iw"],
    ),
    );
  }


  $module->add_contents (  
  	  e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_data_reg_write_d1"],
            asynchronous_contents => [ e_assign->news (["host_data_reg_write_d1"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["host_data_reg_write_d1" => "((host_data_reg_write & ~host_wait & (~host_data_reg_pending|fast_memory_instruction_stream_active | fast_register_instruction_stream_active)) | (debug_extra[0] & host_wait))"],
                  ),], 
      }),




      e_process->new ({
            clock     => "clk",
            reset     => "jrst_n",
            user_attributes_names => ["host_data_reg_pending"],
            asynchronous_contents => [ e_assign->news (["host_data_reg_pending"   => "1'b0"],),],
            contents  => [
                  e_assign->news (["host_data_reg_pending" => "(((W_valid | A_exc_any_active) & (debugack|W_op_bret) & ~(fast_memory_any_active|ctl_reg_ignore_valid)) | oci_debug_mode_exc | fast_memory_done) ? 1'b0 :
                  	  										   (host_data_reg_write | fast_memory_write_starting | fast_memory_read_starting | fast_register_write | fast_register_read) ? 1'b1 :
                  	  										    host_data_reg_pending & ~debug_cancel"],
                  ),], 
      }),

    e_assign->news (
      [["host_data_reg_valid", 1], "(host_data_reg_write_d1 | host_data_reg_write_pending) & debugack | host_trigger_break_on_reset_inst_valid"],
    ),
  );
  
  

  $module->add_contents (
    e_assign->news (
      [["host_control_register_write", 1], "(debug_host_slave_word_address == 12) & debug_host_slave_write_valid" ],

      [["host_control_register_read", 1],  "(debug_host_slave_word_address == 12) & debug_host_slave_read" ],
      [["host_control_register_set", 1],   "(debug_host_slave_word_address == 13) & debug_host_slave_write_valid" ],
      [["host_control_register_clear", 1], "(debug_host_slave_word_address == 14) & debug_host_slave_write_valid" ],

      [["host_control_writedata", 10], "debug_host_slave_writedata[9:0]" ],
      [["host_control_register", 10], "{oci_present,host_sticky_reset,debugack,oci_debug_mode_exc,oci_idisable,oci_single_step_mode,oci_wait,host_break_on_reset,host_reset,host_break}" ],
    ),     
  );


  my $oci_num_xbrk = $Opt->{oci_num_xbrk};
  my $oci_num_dbrk = $Opt->{oci_num_dbrk};


  $module->add_contents (
    e_assign->news (
      [["break_status_read", 1], "(debug_host_slave_word_address == 15) & debug_host_slave_read" ],
      [["break_status_register", 17], "{trigger_state_1,xbrk_hit7_latch,xbrk_hit6_latch,xbrk_hit5_latch,xbrk_hit4_latch,xbrk_hit3_latch,xbrk_hit2_latch,xbrk_hit1_latch,xbrk_hit0_latch,dbrk_hit7_latch,dbrk_hit6_latch,dbrk_hit5_latch,dbrk_hit4_latch,dbrk_hit3_latch,dbrk_hit2_latch,dbrk_hit1_latch,dbrk_hit0_latch}" ],
    ),
  );
    

    for (my $xbrk = 0 ; $xbrk < 8 ; $xbrk++) {
        if ($xbrk < $oci_num_xbrk) {
            my $address_reg = 20 + ($xbrk*2);
            my $control_reg = 21 + ($xbrk*2);
            $module->add_contents (
              e_assign->news (
                [["xbrk${xbrk}_address_reg_write", 1], "(debug_host_slave_word_address == $address_reg) & debug_host_slave_write_valid" ],
                [["xbrk${xbrk}_control_reg_write", 1], "(debug_host_slave_word_address == $control_reg) & debug_host_slave_write_valid" ],
              ),  
            );
        } else {
            $module->add_contents (
              e_assign->news (
                [["xbrk${xbrk}_address_reg_write", 1], "1'b0" ],
                [["xbrk${xbrk}_control_reg_write", 1], "1'b0" ],
              ),  
            );
        }
    }
    

    for (my $dbrk = 0 ; $dbrk < 8 ; $dbrk++) {
        if ($dbrk < $oci_num_dbrk) {
           my $address_reg = 36 + ($dbrk*3);
           my $data_reg = 37 + ($dbrk*3);
           my $control_reg = 38 + ($dbrk*3);
           $module->add_contents (
             e_assign->news (
               [["dbrk${dbrk}_address_reg_write", 1], "(debug_host_slave_word_address == $address_reg) & debug_host_slave_write_valid" ],
               [["dbrk${dbrk}_data_reg_write", 1],    "(debug_host_slave_word_address == $data_reg) & debug_host_slave_write_valid" ],
               [["dbrk${dbrk}_control_reg_write", 1], "(debug_host_slave_word_address == $control_reg) & debug_host_slave_write_valid" ],
             ),
           );
        } else {
           $module->add_contents (
             e_assign->news (
               [["dbrk${dbrk}_address_reg_write", 1], "1'b0" ],
               [["dbrk${dbrk}_data_reg_write", 1],    "1'b0" ],
               [["dbrk${dbrk}_control_reg_write", 1], "1'b0" ],
             ),
           );
        }
    }


  $module->add_contents (
    e_assign->news (
      [["trace_status_read", 1], "(debug_host_slave_word_address == 60) & debug_host_slave_read" ],
      [["trace_control_reg_write", 1], "(debug_host_slave_word_address == 61) & debug_host_slave_write_valid" ],
      [["trace_control_reg_writedata", 13], "debug_host_slave_writedata[12:0]" ],
      [["trace_status_register", 16], "{trc_im_addr,trc_wrap,trc_on}" ],
    ),
  );
  


  if (manditory_bool($Opt, "oci_onchip_trace")) {
    $module->add_contents (
      e_assign->news (
          [["tracemem_address", $trace_addr_width-1], "debug_trace_slave_address[$trace_addr_width-1 : 1]" ],
          [["debug_trace_slave_readdata", 32], "debug_trace_slave_address[0] ? {28'h0, tracemem_data[35:32]} : tracemem_data[31:0]" ],
      ),
    );
  }


  $module->add_contents (     
      e_assign->news (
        [["debug_host_slave_readdata", 32], "crom_access ? cfgrom_readdata :
                                             host_data_reg_read ? host_data_reg :
                                             host_control_register_read ? 32'd0 | host_control_register :
                                             host_inst_count_register_read ? 32'd0 | host_inst_count_register :
                                             break_status_read ? 32'd0 | break_status_register :
                                             trace_status_read ? 32'd0 | trace_status_register : 
                                             0" ],
      ),
  );


  return $module;
}



sub 
make_cfgrom_table_version2
{
  my $Opt = shift;



  my %bytes = ();

  my $mmu = $Opt->{mmu_present};
  my $mpu = $Opt->{mpu_present};
  
  my $bmx = $Opt->{bmx_present};
  my $cdx = $Opt->{cdx_present};
  my $mpx = $Opt->{mpx_present};
  my $cpu_arch_rev2 = ($Opt->{cpu_arch_rev} == 2);
  my $fast_reg_rd = $Opt->{oci_fast_reg_rd};
  
  my $onchip_trace = $Opt->{oci_onchip_trace};


  $bytes{0x0} = ($Opt->{general_exception_addr} >> 0 ) & 0xff;
  $bytes{0x1} = ($Opt->{general_exception_addr} >> 8 ) & 0xff;
  $bytes{0x2} = ($Opt->{general_exception_addr} >> 16) & 0xff;
  $bytes{0x3} = ($Opt->{general_exception_addr} >> 24) & 0xff;

  $bytes{0x4} = $Opt->{i_Address_Width};          # instr master width
  $bytes{0x5} = $Opt->{d_Address_Width};          # data master width
  $bytes{0x6} = $Opt->{oci_num_dbrk};             # number of dbrks
  $bytes{0x7} = $Opt->{oci_num_xbrk};             # number of xbrks

  $bytes{0x8} = $Opt->{oci_dbrk_trace};           # dbrk start trace?
  $bytes{0x9} = $Opt->{oci_dbrk_pairs};           # dbrk support pairs?
  $bytes{0xa} = #  width --v        v--- bit offset
    (($Opt->{oci_data_trace}  & 0x01    ) << 0) | # OCI have data trace?
    (($cdx                              ) << 1) | # CDX present?
    (($bmx                              ) << 2) | # BMX present?
    (($mmu                              ) << 3) | # MMU present?
    (($mpu                              ) << 4) | # MPU present?
    (($mpu ? $Opt->{mpu_use_limit} : 0  ) << 5) | # MPU uses LIMIT (not MASK)
    (($Opt->{extra_exc_info}            ) << 6) |  # EXCEPTION/BADADDR present?
    (($mpx                              ) << 7); # MPX present?
  $bytes{0xb} = (($Opt->{oci_offchip_trace}   & 0x01    ) << 0) | # have offchip trace?
                (($Opt->{ecc_present}                   ) << 1) | # ECC present?
                (($cpu_arch_rev2              & 0x01    ) << 2) | # CPU_ARCH == 2?
                ((0x1                                   ) << 3) | # FAST MEM always available
                (($fast_reg_rd                & 0x01    ) << 4);  # FAST REG RD is optional


  $bytes{0xc} = 
    (                            
      $onchip_trace ? $Opt->{oci_trace_addr_width} :    # Log2 num bytes
                      0
    ) & 0xff;
  $bytes{0xd} = 
    ($TRACE_VERSION_1 << 0) |  # Trace version 1
    (((
      $mpu ? ($Opt->{mpu_num_inst_regions}-1) : # 1-32 regions (coded 0-31)
             0
      ) & 0x1f ) << 3);
  $bytes{0xe} = 
    (((
      $mmu ? $Opt->{tlb_ptr_sz} :               # width of tlb addr (log2)
      $mpu ? ($Opt->{mpu_min_inst_region_size_log2}-5) : # 6-20 (coded 1-15)
             0
      ) & 0x0f ) << 0) | 
    (((
      $mmu ? count2sz($Opt->{tlb_num_ways}) :  # number of tlb ways 
      $mpu ? ($Opt->{mpu_min_data_region_size_log2}-5) : # 6-20 (coded 1-15)
             0
      ) & 0x0f ) << 4);  
  $bytes{0xf} = 
    (((
      $mpu ? ($Opt->{mpu_num_data_regions}-1) : # 1-32 region (coded 0-31)
             0
      ) & 0x1f ) << 0);
                                                      

  $bytes{0x10} = $Opt->{cache_has_icache} ?         # how much inst cache? 
                    count2sz($Opt->{cache_icache_size}) 
                     : 0;       
  $bytes{0x11} = $Opt->{cache_has_dcache} ?         # how much data cache? 
                    count2sz($Opt->{cache_dcache_size}) 
                     : 0;
                     
  my $exception_reg_present = defined($exception_reg);
  my $pteaddr_reg_present   = defined($pteaddr_reg);
  my $tlbacc_reg_present    = defined($tlbacc_reg);
  my $tlbmisc_reg_present   = defined($tlbmisc_reg);
  my $eccinj_reg_present    = defined($eccinj_reg);
  my $badaddr_reg_present   = defined($badaddr_reg);
  my $config_reg_present    = defined($config_reg);
  my $mpubase_reg_present   = defined($mpubase_reg);
  my $mpuacc_reg_present    = defined($mpuacc_reg);


  $bytes{0x12} =     
    ((0x1                               ) << 0) | # STATUS present
    ((0x1                               ) << 1) | # ESTATUS present
    ((0x1                               ) << 2) | # BSTATUS present
    ((0x1                               ) << 3) | # IENABLE present
    ((0x1                               ) << 4) | # IPENDING present
    ((0x1                               ) << 5) | # CPUID present
    ((0x0                               ) << 6) | # 0
    (($exception_reg_present            ) << 7);  # EXCEPTION present?
    
  $bytes{0x13} = 
    (($pteaddr_reg_present              )  << 0) | # PTEADDR present?
    (($tlbacc_reg_present               )  << 1) | # TLBACC present?
    (($tlbmisc_reg_present              ) << 2) | # TLBMISC present?
    (($eccinj_reg_present               ) << 3) | # ECCINJ present?
    (($badaddr_reg_present              ) << 4) | # BADDADDR present?
    (($config_reg_present               ) << 5) | # CONFIG present?
    (($mpubase_reg_present              ) << 6) | # MPUBASE present?
    (($mpuacc_reg_present               ) << 7) ;  # MPUACC present?


  $bytes{0x14} = ($Opt->{reset_addr} >> 0 ) & 0xff; # reset address
  $bytes{0x15} = ($Opt->{reset_addr} >> 8 ) & 0xff;
  $bytes{0x16} = ($Opt->{reset_addr} >> 16) & 0xff;
  $bytes{0x17} = ($Opt->{reset_addr} >> 24) & 0xff;


  $bytes{0x18} = ($Opt->{fast_tlb_miss_exception_addr} >> 0 ) & 0xff;
  $bytes{0x19} = ($Opt->{fast_tlb_miss_exception_addr} >> 8 ) & 0xff;
  $bytes{0x1a} = ($Opt->{fast_tlb_miss_exception_addr} >> 16) & 0xff;
  $bytes{0x1b} = ($Opt->{fast_tlb_miss_exception_addr} >> 24) & 0xff; 


  $bytes{0x1c} = 
    (manditory_int($Opt, "num_shadow_reg_sets") << 0) |
    (manditory_bool($Opt, "eic_present") << 6);


  $bytes{0x1d} = 0;
  $bytes{0x1e} = 0;
  $bytes{0x1f} = 0;


  my @cfgrom_table;
  for (my $cfgdout_waddr = 0; $cfgdout_waddr < 8; $cfgdout_waddr++) {

    my $baddr = $cfgdout_waddr * 4; 


    my $wval =
      (($bytes{$baddr+0} << 0) |
       ($bytes{$baddr+1} << 8) |
       ($bytes{$baddr+2} << 16) |
       ($bytes{$baddr+3} << 24));

    my $whex = sprintf("32'h%08x", $wval);


    push(@cfgrom_table, "3'd" . $cfgdout_waddr => $whex);
  }

  return \@cfgrom_table;
}

1;



