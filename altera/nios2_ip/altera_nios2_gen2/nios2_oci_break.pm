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
use europa_all;
use strict;

sub make_nios2_oci_break
{
  my $Opt = shift;

  my $module = e_module->new ({
      name    => $Opt->{name}."_nios2_oci_break",
  });

  my $is_oci_version2 = ($Opt->{oci_version} == 2) ? 1 : 0;
  my $oci_num_xbrk = $Opt->{oci_num_xbrk};  # shorthand
  my $oci_num_dbrk = $Opt->{oci_num_dbrk};

  my $xbrk_width  = $Opt->{cpu_i_address_width};
  my $max_latency = 1;



  $module->add_contents (

    e_signal->news (



      ["xbrk_ctrl0",          8,                        1],
      ["xbrk_ctrl1",          8,                        1],
      ["xbrk_ctrl2",          8,                        1],
      ["xbrk_ctrl3",          8,                        1],
    ),

  );
  
  if ($is_oci_version2) {
    $module->add_contents (

      e_signal->news (
        ["debug_host_slave_writedata",  32,    0],
      ),
    );
  } else {
    $module->add_contents (

      e_signal->news (
        ["trigbrktype",           1,                      1],
      ),

      e_signal->news (
        ["jdo",           $SR_WIDTH,    0],
      ),
    );
  }







  my $dbrk_addr_high = $Opt->{cpu_d_address_width} - 1;
  my $dbrk_data_high = 32 + ($Opt->{cpu_d_data_width} - 1);
  my $dbrk_ctrl_width = $Opt->{oci_dbrk_trace} ? 10 : 7;
  my $dbrk_ctrl_high = 64 + ($dbrk_ctrl_width - 1);
  
  if (!$is_oci_version2) {







      $module->add_contents (   
        e_signal->news (    # never export these
          ["xbrk0_value",                32,    0,  1],
          ["xbrk1_value",                32,    0,  1],
          ["xbrk2_value",                32,    0,  1],
          ["xbrk3_value",                32,    0,  1],
        ),
      );
  }












  my @user_attributes_D101;
  my @user_attributes_D101_R101;
  
  if (!(manditory_bool($Opt, "asic_enabled") && manditory_bool($Opt, "asic_third_party_synthesis"))) {
      if ($is_oci_version2) {
      	push(@user_attributes_D101_R101, 
      	user_attributes => [
      	     {
      	       attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
      	       attribute_operator => '=',
      	       attribute_values => [qw(R101)],
      	     },
      	   ],
      	 );
      } else {
      	push(@user_attributes_D101, 
      	user_attributes => [
      	     {
      	       attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
      	       attribute_operator => '=',
      	       attribute_values => [qw(D101)],
      	     },
      	   ],
      	 );
      	push(@user_attributes_D101_R101, 
      	user_attributes => [
      	     {
      	       attribute_name => 'SUPPRESS_DA_RULE_INTERNAL',
      	       attribute_operator => '=',
      	       attribute_values => [qw(D101 R101)],
      	     },
      	   ],
      	 );   
      }
  }

if ($is_oci_version2) {
  my @any_control_reg_write;
  for (my $xbrk = 0 ; $xbrk < 8 ; $xbrk++) {
      push(@any_control_reg_write, "xbrk${xbrk}_address_reg_write");
      push(@any_control_reg_write, "xbrk${xbrk}_control_reg_write");
  }
  
  for (my $dbrk = 0 ; $dbrk < 8 ; $dbrk++) {
      push(@any_control_reg_write, "dbrk${dbrk}_address_reg_write");
      push(@any_control_reg_write, "dbrk${dbrk}_data_reg_write");
      push(@any_control_reg_write, "dbrk${dbrk}_control_reg_write");
  }

  $module->add_contents (   

    e_signal->news (
      ["any_control_reg_write", 1, 0, 1],
    ),
    e_assign->news (
      ["any_control_reg_write"  => scalar(@any_control_reg_write) ? join('|', @any_control_reg_write) : "0"],
    ),

    e_process->new ({
      clock     => "clk",
      reset     => "jrst_n",
      user_attributes_names => ["xbrk_ctrl0", "xbrk_ctrl1", "xbrk_ctrl2", "xbrk_ctrl3","xbrk_ctrl4", "xbrk_ctrl5", "xbrk_ctrl6", "xbrk_ctrl7"],
      @user_attributes_D101_R101,
      asynchronous_contents => [
        e_assign->news (
          ["xbrk_ctrl0"    => "0"],
          ["xbrk_ctrl1"    => "0"],
          ["xbrk_ctrl2"    => "0"],
          ["xbrk_ctrl3"    => "0"],
          ["xbrk_ctrl4"    => "0"],
          ["xbrk_ctrl5"    => "0"],
          ["xbrk_ctrl6"    => "0"],
          ["xbrk_ctrl7"    => "0"],
        ),
      ],
      contents  => [

         e_if->new ({
           condition => "xbrk0_control_reg_write",
           then  => [
           ["xbrk_ctrl0[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl0[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl0[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl0[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl0[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl0[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl0[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl0[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
         e_if->new ({
           condition => "xbrk1_control_reg_write",
           then  => [
           ["xbrk_ctrl1[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl1[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl1[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl1[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl1[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl1[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl1[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl1[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
         e_if->new ({
           condition => "xbrk2_control_reg_write",
           then  => [
           ["xbrk_ctrl2[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl2[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl2[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl2[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl2[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl2[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl2[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl2[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
         e_if->new ({
           condition => "xbrk3_control_reg_write",
           then  => [
           ["xbrk_ctrl3[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl3[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl3[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl3[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl3[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl3[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl3[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl3[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
         e_if->new ({
           condition => "xbrk4_control_reg_write",
           then  => [
           ["xbrk_ctrl4[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl4[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl4[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl4[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl4[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl4[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl4[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl4[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
         e_if->new ({
           condition => "xbrk5_control_reg_write",
           then  => [
           ["xbrk_ctrl5[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl5[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl5[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl5[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl5[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl5[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl5[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl5[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
         e_if->new ({
           condition => "xbrk6_control_reg_write",
           then  => [
           ["xbrk_ctrl6[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl6[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl6[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl6[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl6[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl6[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl6[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl6[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
         e_if->new ({
           condition => "xbrk7_control_reg_write",
           then  => [
           ["xbrk_ctrl7[$xbrk_ctrl_brk_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_brk_bit]"],
           ["xbrk_ctrl7[$xbrk_ctrl_tout_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_tout_bit]"],
           ["xbrk_ctrl7[$xbrk_ctrl_toff_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_toff_bit]"],
           ["xbrk_ctrl7[$xbrk_ctrl_ton_bit]" => "debug_host_slave_writedata[$xbrk_ctrl_ton_bit]"],
           ["xbrk_ctrl7[$xbrk_ctrl_arm0_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm0_bit]"],
           ["xbrk_ctrl7[$xbrk_ctrl_arm1_bit]"=> "debug_host_slave_writedata[$xbrk_ctrl_arm1_bit]"],
           ["xbrk_ctrl7[$xbrk_ctrl_goto0_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto0_bit]"],
           ["xbrk_ctrl7[$xbrk_ctrl_goto1_bit]"=>"debug_host_slave_writedata[$xbrk_ctrl_goto1_bit]"],
           ],
         }),
      ], # end contents
    }),
  );  # end module->add_contents







  if ($oci_num_dbrk >= 1) {
    $module->add_contents (
       e_signal->news (
         ["dbrk0",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit0_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit0_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit0_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit0",
                 then => [ 
                   ["dbrk_hit0_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk0"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk0" => "0"]),
         ], 
         contents  => [
              e_if-> new ({
                 condition=> "dbrk0_address_reg_write",
                 then => [
                   e_assign->new ( ["dbrk0[$dbrk_addr_high : 0]" => 
                     "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
                 ],
              }),
              e_if-> new ({
                 condition=> "dbrk0_data_reg_write",
                 then => [
                   e_assign->new (["dbrk0[$dbrk_data_high :32]" => 
                     "debug_host_slave_writedata"]) 
                 ],
              }),
              e_if->new ({
                condition => "dbrk0_control_reg_write",
                then => [ 
                  ["dbrk0[$dbrk_paired_bit  ]"=>  $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk0[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk0[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk0[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk0[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk0[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk0[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk0[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk0[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk0[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk0[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk0[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk0[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk0[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              ),  #end of e_if
         ],  #end of contents
      }), #end of e_process   
    ); #end module add contents for dbrk0
  } else { #end if oci_num_dbrk >= 1
    $module->add_contents (
      e_assign->new (["dbrk_hit0_latch"  => "1'b0"]),
    );
  };

  if ($oci_num_dbrk >= 2) {
    $module->add_contents (
       e_signal->news (
         ["dbrk1",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit1_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit1_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit1_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit1",
                 then => [ 
                   ["dbrk_hit1_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk1"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk1" => "0"]),
         ], 
         contents  => [
 
            e_if-> new ({
               condition=> "dbrk1_address_reg_write",
               then => [
                 e_assign->new ( ["dbrk1[$dbrk_addr_high : 0]" => 
                   "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
               ],
            }),
            e_if-> new ({
               condition=> "dbrk1_data_reg_write",
               then => [
                 e_assign->new (["dbrk1[$dbrk_data_high :32]" => 
                   "debug_host_slave_writedata"]) 
               ],
            }),
            e_if->new ({
                condition => "dbrk1_control_reg_write",
                then => [ 
                  ["dbrk1[$dbrk_paired_bit  ]"=> $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk1[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk1[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk1[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk1[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk1[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk1[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk1[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk1[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk1[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk1[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk1[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk1[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk1[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              ),  #end of e_if
         ],  #end of contents
      }), #end of e_process   
    ); #end module add contents for dbrk1
  } else { #end if oci_num_dbrk >= 2
    $module->add_contents (
      e_assign->new (["dbrk_hit1_latch"  => "1'b0"]),
    );
  };

  if ($oci_num_dbrk >= 3) {
    $module->add_contents (
       e_signal->news (
         ["dbrk2",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit2_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit2_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit2_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit2",
                 then => [ 
                   ["dbrk_hit2_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk2"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk2" => "0"]),
         ], 
         contents  => [

            e_if-> new ({
               condition=> "dbrk2_address_reg_write",
               then => [
                 e_assign->new ( ["dbrk2[$dbrk_addr_high : 0]" => 
                   "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
               ],
            }),
            e_if-> new ({
               condition=> "dbrk2_data_reg_write",
               then => [
                 e_assign->new (["dbrk2[$dbrk_data_high :32]" => 
                   "debug_host_slave_writedata"]) 
               ],
            }),
            e_if->new ({
                condition => "dbrk2_control_reg_write",
                then => [ 
                  ["dbrk2[$dbrk_paired_bit  ]"=> $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk2[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk2[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk2[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk2[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk2[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk2[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk2[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk2[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk2[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk2[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk2[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk2[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk2[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
    ); #end module add contents for dbrk2
  } else { #end if oci_num_dbrk >= 3
    $module->add_contents (
      e_assign->new (["dbrk_hit2_latch"  => "1'b0"]),
    );
  };

  if ($oci_num_dbrk >= 4) {
    $module->add_contents (
       e_signal->news (
         ["dbrk3",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit3_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit3_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit3_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit3",
                 then => [ 
                   ["dbrk_hit3_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk3"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk3" => "0"]),
         ], 
         contents  => [

            e_if-> new ({
               condition=> "dbrk3_address_reg_write",
               then => [
                 e_assign->new ( ["dbrk3[$dbrk_addr_high : 0]" => 
                   "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
               ],
            }),
            e_if-> new ({
               condition=> "dbrk3_data_reg_write",
               then => [
                 e_assign->new (["dbrk3[$dbrk_data_high :32]" => 
                   "debug_host_slave_writedata"]) 
               ],
            }),
            e_if->new ({
                condition => "dbrk3_control_reg_write",
                then => [ 
                  ["dbrk3[$dbrk_paired_bit  ]"=>  $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk3[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk3[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk3[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk3[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk3[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk3[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk3[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk3[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk3[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk3[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk3[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk3[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk3[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
    
    ); #end module add contents for dbrk3
  } else { #end if oci_num_dbrk >= 3
    $module->add_contents (
      e_assign->new (["dbrk_hit3_latch"  => "1'b0"]),
    );
  };
  
  if ($oci_num_dbrk >= 5) {
    $module->add_contents (
       e_signal->news (
         ["dbrk4",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit4_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit4_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit4_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit4",
                 then => [ 
                   ["dbrk_hit4_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk4"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk4" => "0"]),
         ], 
         contents  => [
              e_if-> new ({
                 condition=> "dbrk4_address_reg_write",
                 then => [
                   e_assign->new ( ["dbrk4[$dbrk_addr_high : 0]" => 
                     "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
                 ],
              }),
              e_if-> new ({
                 condition=> "dbrk4_data_reg_write",
                 then => [
                   e_assign->new (["dbrk4[$dbrk_data_high :32]" => 
                     "debug_host_slave_writedata"]) 
                 ],
              }),
              e_if->new ({
                condition => "dbrk4_control_reg_write",
                then => [ 
                  ["dbrk4[$dbrk_paired_bit  ]"=>  $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk4[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk4[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk4[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk4[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk4[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk4[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk4[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk4[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk4[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk4[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk4[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk4[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk4[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              ),  #end of e_if
         ],  #end of contents
      }), #end of e_process   
    ); #end module add contents for dbrk4
  } else { #end if oci_num_dbrk >= 1
    $module->add_contents (
      e_assign->new (["dbrk_hit4_latch"  => "1'b0"]),
    );
  };

  if ($oci_num_dbrk >= 6) {
    $module->add_contents (
       e_signal->news (
         ["dbrk5",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit5_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit5_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit5_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit5",
                 then => [ 
                   ["dbrk_hit5_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk5"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk5" => "0"]),
         ], 
         contents  => [
 
            e_if-> new ({
               condition=> "dbrk5_address_reg_write",
               then => [
                 e_assign->new ( ["dbrk5[$dbrk_addr_high : 0]" => 
                   "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
               ],
            }),
            e_if-> new ({
               condition=> "dbrk5_data_reg_write",
               then => [
                 e_assign->new (["dbrk5[$dbrk_data_high :32]" => 
                   "debug_host_slave_writedata"]) 
               ],
            }),
            e_if->new ({
                condition => "dbrk5_control_reg_write",
                then => [ 
                  ["dbrk5[$dbrk_paired_bit  ]"=>  $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk5[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk5[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk5[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk5[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk5[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk5[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk5[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk5[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk5[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk5[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk5[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk5[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk5[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              ),  #end of e_if
         ],  #end of contents
      }), #end of e_process   
    ); #end module add contents for dbrk5
  } else { #end if oci_num_dbrk >= 2
    $module->add_contents (
      e_assign->new (["dbrk_hit5_latch"  => "1'b0"]),
    );
  };

  if ($oci_num_dbrk >= 7) {
    $module->add_contents (
       e_signal->news (
         ["dbrk6",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit6_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit6_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit6_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit6",
                 then => [ 
                   ["dbrk_hit6_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk6"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk6" => "0"]),
         ], 
         contents  => [

            e_if-> new ({
               condition=> "dbrk6_address_reg_write",
               then => [
                 e_assign->new ( ["dbrk6[$dbrk_addr_high : 0]" => 
                   "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
               ],
            }),
            e_if-> new ({
               condition=> "dbrk6_data_reg_write",
               then => [
                 e_assign->new (["dbrk6[$dbrk_data_high :32]" => 
                   "debug_host_slave_writedata"]) 
               ],
            }),
            e_if->new ({
                condition => "dbrk6_control_reg_write",
                then => [ 
                  ["dbrk6[$dbrk_paired_bit  ]"=>  $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk6[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk6[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk6[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk6[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk6[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk6[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk6[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk6[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk6[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk6[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk6[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk6[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk6[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
    ); #end module add contents for dbrk6
  } else { #end if oci_num_dbrk >= 3
    $module->add_contents (
      e_assign->new (["dbrk_hit6_latch"  => "1'b0"]),
    );
  };

  if ($oci_num_dbrk >= 8) {
    $module->add_contents (
       e_signal->news (
         ["dbrk7",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk_hit7_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit7_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["dbrk_hit7_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit7",
                 then => [ 
                   ["dbrk_hit7_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk7"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk7" => "0"]),
         ], 
         contents  => [

            e_if-> new ({
               condition=> "dbrk7_address_reg_write",
               then => [
                 e_assign->new ( ["dbrk7[$dbrk_addr_high : 0]" => 
                   "debug_host_slave_writedata[$dbrk_addr_high:0]"]) 
               ],
            }),
            e_if-> new ({
               condition=> "dbrk7_data_reg_write",
               then => [
                 e_assign->new (["dbrk7[$dbrk_data_high :32]" => 
                   "debug_host_slave_writedata"]) 
               ],
            }),
            e_if->new ({
                condition => "dbrk7_control_reg_write",
                then => [ 
                  ["dbrk7[$dbrk_paired_bit  ]"=>  $Opt->{oci_dbrk_pairs} ? "debug_host_slave_writedata[$DBRK_CONTROL_PAIR_POS]" : "1'b0"],
                  ["dbrk7[$dbrk_writeenb_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_ST_POS ]"],
                  ["dbrk7[$dbrk_readenb_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_LD_POS ]"],
                  ["dbrk7[$dbrk_addrused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_AU_POS ]"],
                  ["dbrk7[$dbrk_dataused_bit]"=> "debug_host_slave_writedata[$DBRK_CONTROL_DU_POS ]"],
                  ["dbrk7[$dbrk_break_bit   ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_BRK_POS]"],
                  ["dbrk7[$dbrk_trigout_bit ]"=> "debug_host_slave_writedata[$DBRK_CONTROL_TOUT_POS]"],
                  ["dbrk7[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TOFF_POS]" : "1'b0"],
                  ["dbrk7[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TON_POS ]" : "1'b0"],
                  ["dbrk7[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "debug_host_slave_writedata[$DBRK_CONTROL_TME_POS ]" : "1'b0"],
                  ["dbrk7[$dbrk_arm0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM0_POS]"],
                  ["dbrk7[$dbrk_arm1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_ARM1_POS]"],
                  ["dbrk7[$dbrk_goto0_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO0_POS]"],
                  ["dbrk7[$dbrk_goto1_bit]"=>"debug_host_slave_writedata[$DBRK_CONTROL_GOTO1_POS]"],
                ], # end of then
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
    
    ); #end module add contents for dbrk7
  } else { #end if oci_num_dbrk >= 8
    $module->add_contents (
      e_assign->new (["dbrk_hit7_latch"  => "1'b0"]),
    );
  };






  if ($oci_num_xbrk >= 1) {
    $module->add_contents (
       e_signal->news (
         ["xbrk0",               $xbrk_width,              1],
       ),
       
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit0_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit0_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit0_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit0",
                 then => [ 
                   ["xbrk_hit0_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk0"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk0" => "0"]),
          ],
          contents  => [
            e_if->new ({
              condition => "xbrk0_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk0[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit0_latch" => "1'b0"]),
    );
  }

  if ($oci_num_xbrk >= 2) {
    $module->add_contents (
       e_signal->news (
         ["xbrk1",               $xbrk_width,              1],
       ),
       
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit1_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit1_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit1_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit1",
                 then => [ 
                   ["xbrk_hit1_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk1"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk1" => "0"]),
          ],
          contents  => [
            e_if->new ({
              condition => "xbrk1_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk1[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit1_latch" => "1'b0"]),
    
    );
  }


  if ($oci_num_xbrk >= 3) {
    $module->add_contents (
       e_signal->news (
         ["xbrk2",               $xbrk_width,              1],
       ),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit2_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit2_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit2_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit2",
                 then => [ 
                   ["xbrk_hit2_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk2"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk2" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "xbrk2_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk2[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit2_latch" => "1'b0"]),
    
    );
  }


  if ($oci_num_xbrk >= 4) {
    $module->add_contents (
       e_signal->news (
         ["xbrk3",               $xbrk_width,              1],
       ),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit3_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit3_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit3_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit3",
                 then => [ 
                   ["xbrk_hit3_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk3"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk3" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "xbrk3_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk3[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit3_latch" => "1'b0"]),

    );
  }

  if ($oci_num_xbrk >= 5) {
    $module->add_contents (
       e_signal->news (
         ["xbrk4",               $xbrk_width,              1],
       ),
       
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit4_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit4_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit4_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit4",
                 then => [ 
                   ["xbrk_hit4_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk4"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk4" => "0"]),
          ],
          contents  => [
            e_if->new ({
              condition => "xbrk4_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk4[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit4_latch" => "1'b0"]),
    );
  }

  if ($oci_num_xbrk >= 6) {
    $module->add_contents (
       e_signal->news (
         ["xbrk5",               $xbrk_width,              1],
       ),
       
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit5_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit5_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit5_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit5",
                 then => [ 
                   ["xbrk_hit5_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk5"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk5" => "0"]),
          ],
          contents  => [
            e_if->new ({
              condition => "xbrk5_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk5[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit5_latch" => "1'b0"]),
    
    );
  }


  if ($oci_num_xbrk >= 7) {
    $module->add_contents (
       e_signal->news (
         ["xbrk6",               $xbrk_width,              1],
       ),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit6_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit6_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit6_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit6",
                 then => [ 
                   ["xbrk_hit6_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk6"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk6" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "xbrk6_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk6[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit6_latch" => "1'b0"]),
    
    );
  }


  if ($oci_num_xbrk >= 8) {
    $module->add_contents (
       e_signal->news (
         ["xbrk7",               $xbrk_width,              1],
       ),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["xbrk_hit7_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["xbrk_hit7_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "any_control_reg_write",
             then => [ 
               e_assign->news (
                   ["xbrk_hit7_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "xbrk_hit7",
                 then => [ 
                   ["xbrk_hit7_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk7"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk7" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "xbrk7_address_reg_write",
              then => [ e_assign->new (
                        ["xbrk7[$xbrk_width-1 : 0]" => 
                          "debug_host_slave_writedata[$xbrk_width-1 : 0]"]) 
                      ],
            }),
          ],
       }), # end e_process
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk_hit7_latch" => "1'b0"]),

    );
  }
} else {
  $module->add_contents (   
    e_signal->news (
      ["break_a_wpr",($BREAK_A_WPR_MSB_POS-$BREAK_A_WPR_LSB_POS+1), 0, 1],
      ["break_b_rr", ($BREAK_B_RR_MSB_POS-$BREAK_B_RR_LSB_POS+1), 0, 1],
      ["break_c_rr", ($BREAK_C_RR_MSB_POS-$BREAK_C_RR_LSB_POS+1), 0, 1],
    ),
    e_assign->news (
      ["break_a_wpr"  => "jdo[$BREAK_A_WPR_MSB_POS:$BREAK_A_WPR_LSB_POS]",],
      ["break_a_wpr_high_bits"  => "break_a_wpr [3:2]"], 
      ["break_a_wpr_low_bits"   => "break_a_wpr [1:0]"], 
      ["break_b_rr" => "jdo[$BREAK_B_RR_MSB_POS:$BREAK_B_RR_LSB_POS]"],
      ["break_c_rr" => "jdo[$BREAK_C_RR_MSB_POS:$BREAK_C_RR_LSB_POS]"],
      ["take_action_any_break" => 
          "(take_action_break_a | take_action_break_b | take_action_break_c)"],
    ),

    e_process->new ({
      clock     => "clk",
      reset     => "jrst_n",
      user_attributes_names => ["xbrk_ctrl0", "xbrk_ctrl1", "xbrk_ctrl2",
      "xbrk_ctrl3", "trigbrktype"],
      @user_attributes_D101_R101,
      asynchronous_contents => [
        e_assign->news (
          ["xbrk_ctrl0"    => "0"],
          ["xbrk_ctrl1"    => "0"],
          ["xbrk_ctrl2"    => "0"],
          ["xbrk_ctrl3"    => "0"],
          ["trigbrktype"  => "0"],
        ),
      ],
      contents  => [


        e_if->new ({
          condition => "take_action_any_break",
          then      => [ e_assign->new (["trigbrktype" => "0"]),],
          elsif   => {
            condition => "(dbrk_break)",
            then      => [ e_assign->new (["trigbrktype" => "1"]),],
          },
        }),

        e_if->new ({



            condition => "(take_action_break_b)",
            then    => [
              e_if->new ({
                condition => "(break_b_rr == 2'b00) && ($oci_num_xbrk >= 1)",
                then  => [
                ["xbrk_ctrl0[$xbrk_ctrl_brk_bit]" => "jdo[$BREAK_B_BRK_POS]"],
                ["xbrk_ctrl0[$xbrk_ctrl_tout_bit]"=>"jdo[$BREAK_B_TOUT_POS]"],
                ["xbrk_ctrl0[$xbrk_ctrl_toff_bit]"=>"jdo[$BREAK_B_TOFF_POS]"],
                ["xbrk_ctrl0[$xbrk_ctrl_ton_bit]" => "jdo[$BREAK_B_TON_POS]"],
                ["xbrk_ctrl0[$xbrk_ctrl_arm0_bit]"=>"jdo[$BREAK_B_ARM0_POS]"],
                ["xbrk_ctrl0[$xbrk_ctrl_arm1_bit]"=>"jdo[$BREAK_B_ARM1_POS]"],
                ["xbrk_ctrl0[$xbrk_ctrl_goto0_bit]"=>"jdo[$BREAK_B_GOTO0_POS]"],
                ["xbrk_ctrl0[$xbrk_ctrl_goto1_bit]"=>"jdo[$BREAK_B_GOTO1_POS]"],
                ],
              }),
              e_if->new ({
                condition => "(break_b_rr == 2'b01) && ($oci_num_xbrk >= 2)",
                then  => [
                ["xbrk_ctrl1[$xbrk_ctrl_brk_bit]" => "jdo[$BREAK_B_BRK_POS]"],
                ["xbrk_ctrl1[$xbrk_ctrl_tout_bit]"=>"jdo[$BREAK_B_TOUT_POS]"],
                ["xbrk_ctrl1[$xbrk_ctrl_toff_bit]"=>"jdo[$BREAK_B_TOFF_POS]"],
                ["xbrk_ctrl1[$xbrk_ctrl_ton_bit]" => "jdo[$BREAK_B_TON_POS]"],
                ["xbrk_ctrl1[$xbrk_ctrl_arm0_bit]"=>"jdo[$BREAK_B_ARM0_POS]"],
                ["xbrk_ctrl1[$xbrk_ctrl_arm1_bit]"=>"jdo[$BREAK_B_ARM1_POS]"],
                ["xbrk_ctrl1[$xbrk_ctrl_goto0_bit]"=>"jdo[$BREAK_B_GOTO0_POS]"],
                ["xbrk_ctrl1[$xbrk_ctrl_goto1_bit]"=>"jdo[$BREAK_B_GOTO1_POS]"],
                ],
              }),
              e_if->new ({
                condition => "(break_b_rr == 2'b10) && ($oci_num_xbrk >= 3)",
                then  => [
                ["xbrk_ctrl2[$xbrk_ctrl_brk_bit]" => "jdo[$BREAK_B_BRK_POS]"],
                ["xbrk_ctrl2[$xbrk_ctrl_tout_bit]"=>"jdo[$BREAK_B_TOUT_POS]"],
                ["xbrk_ctrl2[$xbrk_ctrl_toff_bit]"=>"jdo[$BREAK_B_TOFF_POS]"],
                ["xbrk_ctrl2[$xbrk_ctrl_ton_bit]" => "jdo[$BREAK_B_TON_POS]"],
                ["xbrk_ctrl2[$xbrk_ctrl_arm0_bit]"=>"jdo[$BREAK_B_ARM0_POS]"],
                ["xbrk_ctrl2[$xbrk_ctrl_arm1_bit]"=>"jdo[$BREAK_B_ARM1_POS]"],
                ["xbrk_ctrl2[$xbrk_ctrl_goto0_bit]"=>"jdo[$BREAK_B_GOTO0_POS]"],
                ["xbrk_ctrl2[$xbrk_ctrl_goto1_bit]"=>"jdo[$BREAK_B_GOTO1_POS]"],
                ],
              }),
              e_if->new ({
                condition => "(break_b_rr == 2'b11) && ($oci_num_xbrk >= 4)",
                then  => [
                ["xbrk_ctrl3[$xbrk_ctrl_brk_bit]" => "jdo[$BREAK_B_BRK_POS]"],
                ["xbrk_ctrl3[$xbrk_ctrl_tout_bit]"=>"jdo[$BREAK_B_TOUT_POS]"],
                ["xbrk_ctrl3[$xbrk_ctrl_toff_bit]"=>"jdo[$BREAK_B_TOFF_POS]"],
                ["xbrk_ctrl3[$xbrk_ctrl_ton_bit]" => "jdo[$BREAK_B_TON_POS]"],
                ["xbrk_ctrl3[$xbrk_ctrl_arm0_bit]"=>"jdo[$BREAK_B_ARM0_POS]"],
                ["xbrk_ctrl3[$xbrk_ctrl_arm1_bit]"=>"jdo[$BREAK_B_ARM1_POS]"],
                ["xbrk_ctrl3[$xbrk_ctrl_goto0_bit]"=>"jdo[$BREAK_B_GOTO0_POS]"],
                ["xbrk_ctrl3[$xbrk_ctrl_goto1_bit]"=>"jdo[$BREAK_B_GOTO1_POS]"],
                ],
              }),
            ],
        }), # end if (b)
      ], # end contents
    }),
  );  # end module->add_contents







  if ($oci_num_dbrk >= 1) {
    $module->add_contents (
       e_signal->news (
         ["dbrk0",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         user_attributes_names => ["dbrk_hit0_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit0_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "take_action_any_break",
             then => [ 
               e_assign->news (
                   ["dbrk_hit0_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit0 & dbrk0[$dbrk_break_bit]",
                 then => [ 
                   ["dbrk_hit0_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk0"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk0" => "0"]),
         ], 
         contents  => [
            e_if->new ({
              condition => "(take_action_break_a && break_a_wpr_low_bits == 2'b00)",
              then => [ 
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 2)",
                    then => [
                      e_assign->new ( ["dbrk0[$dbrk_addr_high : 0]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 3)",
                    then => [
                      e_assign->new (["dbrk0[$dbrk_data_high :32]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
              ],
              elsif => {
                condition => "(take_action_break_c && break_c_rr == 2'b00)",
                then => [ 
                  ["dbrk0[$dbrk_writeenb_bit]"=> "jdo[$BREAK_C_ST_POS ]"],
                  ["dbrk0[$dbrk_readenb_bit ]"=> "jdo[$BREAK_C_LD_POS ]"],
                  ["dbrk0[$dbrk_addrused_bit]"=> "jdo[$BREAK_C_AU_POS ]"],
                  ["dbrk0[$dbrk_dataused_bit]"=> "jdo[$BREAK_C_DU_POS ]"],
                  ["dbrk0[$dbrk_break_bit   ]"=> "jdo[$BREAK_C_BRK_POS]"],
                  ["dbrk0[$dbrk_trigout_bit ]"=> "jdo[$BREAK_C_TOUT_POS]"],
                  ["dbrk0[$dbrk_paired_bit  ]"=> $Opt->{oci_dbrk_pairs} ? "jdo[$BREAK_C_PAIR_POS]" : "1'b0"],
                  ["dbrk0[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TOFF_POS]" : "1'b0"],
                  ["dbrk0[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TON_POS ]" : "1'b0"],
                  ["dbrk0[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TME_POS ]" : "1'b0"],
                  ["dbrk0[$dbrk_arm0_bit]"=>"jdo[$BREAK_C_ARM0_POS]"],
                  ["dbrk0[$dbrk_arm1_bit]"=>"jdo[$BREAK_C_ARM1_POS]"],
                  ["dbrk0[$dbrk_goto0_bit]"=>"jdo[$BREAK_C_GOTO0_POS]"],
                  ["dbrk0[$dbrk_goto1_bit]"=>"jdo[$BREAK_C_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
      e_assign->new (["dbrk0_low_value"  => "dbrk0[$dbrk_addr_high : 0]"]),
      e_assign->new (["dbrk0_high_value" => "dbrk0[$dbrk_data_high : 32]"]),
    
    ); #end module add contents for dbrk0
  } else { #end if oci_num_dbrk >= 1
    $module->add_contents (
      e_assign->new (["dbrk_hit0_latch"  => "1'b0"]),
      e_assign->new (["dbrk0_low_value"  => "0"]),
      e_assign->new (["dbrk0_high_value" => "0"]),
    );
  };

  if ($oci_num_dbrk >= 2) {
    $module->add_contents (
       e_signal->news (
         ["dbrk1",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         user_attributes_names => ["dbrk_hit1_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit1_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "take_action_any_break",
             then => [ 
               e_assign->news (
                   ["dbrk_hit1_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit1 & dbrk1[$dbrk_break_bit]",
                 then => [ 
                   ["dbrk_hit1_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk1"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk1" => "0"]),
         ], 
         contents  => [
            e_if->new ({
              condition => "(take_action_break_a && break_a_wpr_low_bits == 2'b01)",
              then => [ 
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 2)",
                    then => [
                      e_assign->new ( ["dbrk1[$dbrk_addr_high : 0]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 3)",
                    then => [
                      e_assign->new (["dbrk1[$dbrk_data_high :32]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
              ],
              elsif => {
                condition => "(take_action_break_c && break_c_rr == 2'b01)",
                then => [ 
                  ["dbrk1[$dbrk_writeenb_bit]"=> "jdo[$BREAK_C_ST_POS ]"],
                  ["dbrk1[$dbrk_readenb_bit ]"=> "jdo[$BREAK_C_LD_POS ]"],
                  ["dbrk1[$dbrk_addrused_bit]"=> "jdo[$BREAK_C_AU_POS ]"],
                  ["dbrk1[$dbrk_dataused_bit]"=> "jdo[$BREAK_C_DU_POS ]"],
                  ["dbrk1[$dbrk_break_bit   ]"=> "jdo[$BREAK_C_BRK_POS]"],
                  ["dbrk1[$dbrk_trigout_bit ]"=> "jdo[$BREAK_C_TOUT_POS]"],
                  ["dbrk1[$dbrk_paired_bit  ]"=> $Opt->{oci_dbrk_pairs} ? "jdo[$BREAK_C_PAIR_POS]" : "1'b0"],
                  ["dbrk1[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TOFF_POS]" : "1'b0"],
                  ["dbrk1[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TON_POS ]" : "1'b0"],
                  ["dbrk1[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TME_POS ]" : "1'b0"],
                  ["dbrk1[$dbrk_arm0_bit]"=>"jdo[$BREAK_C_ARM0_POS]"],
                  ["dbrk1[$dbrk_arm1_bit]"=>"jdo[$BREAK_C_ARM1_POS]"],
                  ["dbrk1[$dbrk_goto0_bit]"=>"jdo[$BREAK_C_GOTO0_POS]"],
                  ["dbrk1[$dbrk_goto1_bit]"=>"jdo[$BREAK_C_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
      e_assign->new (["dbrk1_low_value"  => "dbrk1[$dbrk_addr_high : 0]"]),
      e_assign->new (["dbrk1_high_value" => "dbrk1[$dbrk_data_high : 32]"]),
    
    ); #end module add contents for dbrk1
  } else { #end if oci_num_dbrk >= 2
    $module->add_contents (
      e_assign->new (["dbrk_hit1_latch"  => "1'b0"]),
      e_assign->new (["dbrk1_low_value"  => "0"]),
      e_assign->new (["dbrk1_high_value" => "0"]),
    );
  };

  if ($oci_num_dbrk >= 3) {
    $module->add_contents (
       e_signal->news (
         ["dbrk2",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         user_attributes_names => ["dbrk_hit2_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit2_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "take_action_any_break",
             then => [ 
               e_assign->news (
                   ["dbrk_hit2_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit2 & dbrk2[$dbrk_break_bit]",
                 then => [ 
                   ["dbrk_hit2_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk2"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk2" => "0"]),
         ], 
         contents  => [
            e_if->new ({
              condition => "(take_action_break_a && break_a_wpr_low_bits == 2'b10)",
              then => [ 
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 2)",
                    then => [
                      e_assign->new ( ["dbrk2[$dbrk_addr_high : 0]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 3)",
                    then => [
                      e_assign->new (["dbrk2[$dbrk_data_high :32]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
              ],
              elsif => {
                condition => "(take_action_break_c && break_c_rr == 2'b10)",
                then => [ 
                  ["dbrk2[$dbrk_writeenb_bit]"=> "jdo[$BREAK_C_ST_POS ]"],
                  ["dbrk2[$dbrk_readenb_bit ]"=> "jdo[$BREAK_C_LD_POS ]"],
                  ["dbrk2[$dbrk_addrused_bit]"=> "jdo[$BREAK_C_AU_POS ]"],
                  ["dbrk2[$dbrk_dataused_bit]"=> "jdo[$BREAK_C_DU_POS ]"],
                  ["dbrk2[$dbrk_break_bit   ]"=> "jdo[$BREAK_C_BRK_POS]"],
                  ["dbrk2[$dbrk_trigout_bit ]"=> "jdo[$BREAK_C_TOUT_POS]"],
                  ["dbrk2[$dbrk_paired_bit  ]"=> $Opt->{oci_dbrk_pairs} ? "jdo[$BREAK_C_PAIR_POS]" : "1'b0"],
                  ["dbrk2[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TOFF_POS]" : "1'b0"],
                  ["dbrk2[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TON_POS ]" : "1'b0"],
                  ["dbrk2[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TME_POS ]" : "1'b0"],
                  ["dbrk2[$dbrk_arm0_bit]"=>"jdo[$BREAK_C_ARM0_POS]"],
                  ["dbrk2[$dbrk_arm1_bit]"=>"jdo[$BREAK_C_ARM1_POS]"],
                  ["dbrk2[$dbrk_goto0_bit]"=>"jdo[$BREAK_C_GOTO0_POS]"],
                  ["dbrk2[$dbrk_goto1_bit]"=>"jdo[$BREAK_C_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
      e_assign->new (["dbrk2_low_value"  => "dbrk2[$dbrk_addr_high : 0]"]),
      e_assign->new (["dbrk2_high_value" => "dbrk2[$dbrk_data_high : 32]"]),
    
    ); #end module add contents for dbrk2
  } else { #end if oci_num_dbrk >= 3
    $module->add_contents (
      e_assign->new (["dbrk_hit2_latch"  => "1'b0"]),
      e_assign->new (["dbrk2_low_value"  => "0"]),
      e_assign->new (["dbrk2_high_value" => "0"]),
    );
  };

  if ($oci_num_dbrk >= 4) {
    $module->add_contents (
       e_signal->news (
         ["dbrk3",               78,                       1],
       ),

       e_process->new ({
         clock     => "clk",
         user_attributes_names => ["dbrk_hit3_latch"],
         @user_attributes_D101,
         asynchronous_contents => [
            e_assign->new (["dbrk_hit3_latch" => "0"]),
         ],
         contents  => [
           e_if->new ({
             condition => "take_action_any_break",
             then => [ 
               e_assign->news (
                   ["dbrk_hit3_latch"  => "1'b0"],
               ),
             ], 
             else => [
               e_if->new ({
                 condition => "dbrk_hit3 & dbrk3[$dbrk_break_bit]",
                 then => [ 
                   ["dbrk_hit3_latch"  => "1'b1"],
                 ],
               }),
             ],
           }),
         ],
       }),
       e_process->new ({
         clock     => "clk",
         reset     => "jrst_n",
         user_attributes_names => ["dbrk3"],
         @user_attributes_D101_R101,
         asynchronous_contents => [
            e_assign->new (["dbrk3" => "0"]),
         ], 
         contents  => [
            e_if->new ({
              condition => "(take_action_break_a && break_a_wpr_low_bits == 2'b11)",
              then => [ 
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 2)",
                    then => [
                      e_assign->new ( ["dbrk3[$dbrk_addr_high : 0]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
                 e_if-> new ({
                    condition=> "(break_a_wpr_high_bits == 3)",
                    then => [
                      e_assign->new (["dbrk3[$dbrk_data_high :32]" => 
                        "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                    ],
                 }),
              ],
              elsif => {
                condition => "(take_action_break_c && break_c_rr == 2'b11)",
                then => [ 
                  ["dbrk3[$dbrk_writeenb_bit]"=> "jdo[$BREAK_C_ST_POS ]"],
                  ["dbrk3[$dbrk_readenb_bit ]"=> "jdo[$BREAK_C_LD_POS ]"],
                  ["dbrk3[$dbrk_addrused_bit]"=> "jdo[$BREAK_C_AU_POS ]"],
                  ["dbrk3[$dbrk_dataused_bit]"=> "jdo[$BREAK_C_DU_POS ]"],
                  ["dbrk3[$dbrk_break_bit   ]"=> "jdo[$BREAK_C_BRK_POS]"],
                  ["dbrk3[$dbrk_trigout_bit ]"=> "jdo[$BREAK_C_TOUT_POS]"],
                  ["dbrk3[$dbrk_paired_bit  ]"=> $Opt->{oci_dbrk_pairs} ? "jdo[$BREAK_C_PAIR_POS]" : "1'b0"],
                  ["dbrk3[$dbrk_traceoff_bit]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TOFF_POS]" : "1'b0"],
                  ["dbrk3[$dbrk_traceon_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TON_POS ]" : "1'b0"],
                  ["dbrk3[$dbrk_traceme_bit ]"=> $Opt->{oci_dbrk_trace} ? "jdo[$BREAK_C_TME_POS ]" : "1'b0"],
                  ["dbrk3[$dbrk_arm0_bit]"=>"jdo[$BREAK_C_ARM0_POS]"],
                  ["dbrk3[$dbrk_arm1_bit]"=>"jdo[$BREAK_C_ARM1_POS]"],
                  ["dbrk3[$dbrk_goto0_bit]"=>"jdo[$BREAK_C_GOTO0_POS]"],
                  ["dbrk3[$dbrk_goto1_bit]"=>"jdo[$BREAK_C_GOTO1_POS]"],
                ], # end of then
               }, # end of elsif
              }),  #end of e_if
         ],  #end of contents
      }), #end of e_process
      e_assign->new (["dbrk3_low_value"  => "dbrk3[$dbrk_addr_high : 0]"]),
      e_assign->new (["dbrk3_high_value" => "dbrk3[$dbrk_data_high : 32]"]),
    
    ); #end module add contents for dbrk3
  } else { #end if oci_num_dbrk >= 3
    $module->add_contents (
      e_assign->new (["dbrk_hit3_latch"  => "1'b0"]),
      e_assign->new (["dbrk3_low_value"  => "0"]),
      e_assign->new (["dbrk3_high_value" => "0"]),
    );
  };






  if ($oci_num_xbrk >= 1) {
    $module->add_contents (
       e_signal->news (
         ["xbrk0",               $xbrk_width,              1],
       ),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk0"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk0" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "(take_action_break_a 
                 && (break_a_wpr_high_bits == 0) 
                 && (break_a_wpr_low_bits == 2'b00))",
              then => [ e_assign->new (
                        ["xbrk0[$xbrk_width-1 : 0]" => 
                          "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                      ],
            }),
          ],
       }), # end e_process
    
       e_assign->new (["xbrk0_value" => "xbrk0"]),

    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk0_value" => "32'b0"]),

    );
  }

  if ($oci_num_xbrk >= 2) {
    $module->add_contents (
       e_signal->news (
         ["xbrk1",               $xbrk_width,              1],
       ),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk1"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk1" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "(take_action_break_a 
                 && (break_a_wpr_high_bits == 0) 
                 && (break_a_wpr_low_bits == 2'b01))",
              then => [ e_assign->new (
                        ["xbrk1[$xbrk_width-1 : 0]" => 
                          "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                      ],
            }),
          ],
       }), # end e_process
       e_assign->new (["xbrk1_value" => "xbrk1"]),
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk1_value" => "32'b0"]),
    
    );
  }


  if ($oci_num_xbrk >= 3) {
    $module->add_contents (
       e_signal->news (
         ["xbrk2",               $xbrk_width,              1],
       ),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk2"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk2" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "(take_action_break_a 
                 && (break_a_wpr_high_bits == 0) 
                 && (break_a_wpr_low_bits == 2'b10))",
              then => [ e_assign->new (
                        ["xbrk2[$xbrk_width-1 : 0]" => 
                          "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                      ],
            }),
          ],
       }), # end e_process
       e_assign->new (["xbrk2_value" => "xbrk2"]),
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk2_value" => "32'b0"]),
    
    );
  }


  if ($oci_num_xbrk >= 4) {
    $module->add_contents (
       e_signal->news (
         ["xbrk3",               $xbrk_width,              1],
       ),
       e_process->new ({
          clock     => "clk",
          reset     => "jrst_n",
          user_attributes_names => ["xbrk3"],
          @user_attributes_D101_R101,
          asynchronous_contents => [
            e_assign->new (["xbrk3" => "0"]),
          ],
          contents  => [
            e_if->new ({

              condition => "(take_action_break_a 
                 && (break_a_wpr_high_bits == 0) 
                 && (break_a_wpr_low_bits == 2'b11))",
              then => [ e_assign->new (
                        ["xbrk3[$xbrk_width-1 : 0]" => 
                          "jdo[$BREAK_A_WRDATA_MSB_POS:$BREAK_A_WRDATA_LSB_POS]"]) 
                      ],
            }),
          ],
       }), # end e_process
       e_assign->new (["xbrk3_value" => "xbrk3"]),
    
    );
  } else {
    $module->add_contents (
       e_assign->new (["xbrk3_value" => "32'b0"]),

    );
  }







  $module->add_contents (   
    e_signal->news (
      ["break_readreg",   32],
    ),

    e_process->new ({
      clock     => "clk",
      reset     => "jrst_n",
      user_attributes_names => ["break_readreg"],
      @user_attributes_D101_R101,
      asynchronous_contents => [
        e_assign->new ([break_readreg  => "32'b0"]),
      ],
      contents  => [



        e_if->new ({
          condition => "take_action_any_break",
          then => [ 
            [break_readreg  => "jdo[31:0]"],
          ],
          elsif => {



            condition => "(take_no_action_break_a)",
            then => [ 
              e_case->new ({
                switch    => "break_a_wpr_high_bits",
                parallel  => 0,
                full      => 0,
                contents  => {

                  0 => [
                    e_case->new ({
                      switch    => "break_a_wpr_low_bits",
                      parallel  => 0,
                      full      => 1,
                      contents  => {
                        0 => [ [break_readreg => "xbrk0_value"], ],
                        1 => [ [break_readreg => "xbrk1_value"], ],
                        2 => [ [break_readreg => "xbrk2_value"], ],
                        3 => [ [break_readreg => "xbrk3_value"], ],
                      },
                    }),
                  ],


                  1 => [
                    e_assign->new ([break_readreg  => "32'b0"]),
                  ],


                  2 => [
                    e_case->new ({
                      switch    => "break_a_wpr_low_bits",
                      parallel  => 0,
                      full      => 1,
                      contents  => {
                        0 => [ [break_readreg => "dbrk0_low_value"], ],
                        1 => [ [break_readreg => "dbrk1_low_value"], ],
                        2 => [ [break_readreg => "dbrk2_low_value"], ],
                        3 => [ [break_readreg => "dbrk3_low_value"], ],
                        },
                    }),
                  ],
                  

                  3 => [
                    e_case->new ({
                      switch    => "break_a_wpr_low_bits",
                      parallel  => 0,
                      full      => 1,
                      contents  => {
                        0 => [ [break_readreg => "dbrk0_high_value"], ],
                        1 => [ [break_readreg => "dbrk1_high_value"], ],
                        2 => [ [break_readreg => "dbrk2_high_value"], ],
                        3 => [ [break_readreg => "dbrk3_high_value"], ],
                      },
                    }),
                  ],
                },
              }),
            ],
            elsif => {



              condition => "(take_no_action_break_b)",
              then    => [

                [break_readreg  => "jdo[31:0]"],
              ],
              elsif => {



                condition => "(take_no_action_break_c)",
                then    => [

                  [break_readreg  => "jdo[31:0]"],
                ], # end take action (c)
              } # end elsif (c)
            } # end elsif (b)
          }, # end elsif (a)
        }), # end if (any action)
      ], # end contents
    }),

  );
}







  if ($Opt->{oci_trigger_arming}) {
    $module->add_contents (   
      e_register->news (
        { out         => ["trigger_state", 1, 0, 1] ,
          sync_set    => "(trigger_state_0 & (xbrk_goto1 | dbrk_goto1))",
          sync_reset  => "(trigger_state_1 & (xbrk_goto0 | dbrk_goto0))",
          async_value => 0,
          enable      => "1",
          reset       => "jrst_n",
        },
      ),
      e_assign->news (
        [["trigger_state_0", 1, 1, 0], "~trigger_state"],
        [["trigger_state_1", 1, 1 ,0], " trigger_state"],
      ),
    );
  } else {  # no trigger arming, no trigger states



    $module->get_and_set_thing_by_name({
      thing => "mux",
      lhs   => ["dummy_sink", 1, 0, 1],
      name  => "dummy sink",
      type  => "and_or",
      add_table => ["xbrk_goto1", "xbrk_goto1",
                    "xbrk_goto0", "xbrk_goto0",
                    "dbrk_goto1", "dbrk_goto1",
                    "dbrk_goto0", "dbrk_goto0",
                   ],
    });


    $module->add_contents (   
      e_assign->news (
        [["trigger_state_0", 1, 1, 0], "1'b1"],
        [["trigger_state_1", 1, 1 ,0], "1'b0"],
      ),
    );
  }

  return $module;
}



1;


