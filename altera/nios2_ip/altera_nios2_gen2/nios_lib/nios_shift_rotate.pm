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






















package nios_shift_rotate;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $fast_shifter_uses_les
    $fast_shifter_uses_designware
    $small_shifter_uses_les
    $medium_shifter_uses_les
);

use cpu_utils;
use cpu_wave_signals;
use nios_europa;
use nios_isa;
use europa_all;
use europa_utils;
use strict;





our $fast_shifter_uses_les;
our $fast_shifter_uses_designware;
our $small_shifter_uses_les;
our $medium_shifter_uses_les;





sub 
initialize_config_constants
{
    my $misc_info = shift;

    my $shift_rot_impl = not_empty_scalar($misc_info, "shift_rot_impl");


    if (manditory_bool($misc_info, "use_designware")) {
        $fast_shifter_uses_designware = 1;
    } else {
        if ($shift_rot_impl eq "fast_le_shift") {
            $fast_shifter_uses_les = 1;
        } elsif ($shift_rot_impl eq "medium_le_shift") {
            $medium_shifter_uses_les = 1;
        } elsif ($shift_rot_impl eq "small_le_shift") {
            $small_shifter_uses_les = 1;
        } else {
            &$error("Unknown shift/rotate implementation of '$shift_rot_impl'");
        }
    }
}

sub
gen_shift_rotate
{
    my $Opt = shift;

    if ($fast_shifter_uses_les) {
        gen_fast_shift_rotate($Opt);
    } elsif ($medium_shifter_uses_les) {
        gen_medium_shift_rotate($Opt);
    } elsif ($small_shifter_uses_les) {
        gen_small_shift_rotate($Opt);
    } elsif ($fast_shifter_uses_designware) {
        gen_designware_fast_shift_rotate($Opt);
    } else {
        &$error("Unsupported shifter implementation");
    }
}














sub 
gen_fast_shift_rotate
{
    my $Opt = shift;

    my $whoami = "fast shift/rotate";


    my $impl = not_empty_scalar($Opt, "core_type");
    my $pre_os = not_empty_scalar($Opt, 
      "non_pipelined_long_latency_input_stage");
    my $os = not_empty_scalar($Opt, "long_latency_output_stage");
    my $num_shift_rot_cycles = 
      not_empty_scalar($Opt, "le_fast_shift_rot_cycles");
    my $le_fast_shift_rot_shfcnt = 
      not_empty_scalar($Opt, "le_fast_shift_rot_shfcnt");
    my $le_fast_shift_data = 
      not_empty_scalar($Opt, "le_fast_shift_data");
    my $le_fast_shift_data_lsw = $le_fast_shift_data . "[30:0]";
    my $le_fast_shift_data_msb = $le_fast_shift_data . "[31]";

    my $num_stall_cycles = $num_shift_rot_cycles - 1;


    my $shift_rot_cnt_sz = num2sz($num_stall_cycles);

    if ($num_shift_rot_cycles > 1) {
    e_assign->adds(
      [["${os}_shift_rot_cnt_nxt", $shift_rot_cnt_sz],
        "${os}_shift_rot_stall ? 
           ${os}_shift_rot_cnt-1 :
           $num_stall_cycles"],

      [["${os}_shift_rot_done_nxt", 1],
        "${os}_shift_rot_cnt_nxt == 0"],

      [["${os}_shift_rot_stall_nxt", 1], 
        "~${os}_shift_rot_done_nxt & 
         (${os}_shift_rot_stall |
          (${pre_os}_ctrl_shift_rot & ${pre_os}_valid & ${os}_en))"],
      );

    e_register->adds(
      {out => ["${os}_shift_rot_cnt", $shift_rot_cnt_sz], 
       in => "${os}_shift_rot_cnt_nxt", enable => "1'b1",
       enable => "1'b1"},
      {out => ["${os}_shift_rot_stall", 1], 
       in => "${os}_shift_rot_stall_nxt", enable => "1'b1",
       enable => "1'b1"},
      );
    }

    my $s4    = ($os eq "A") ? "A"    : "E"  ;
    my $s4_en = ($os eq "A") ? "A_en" : "E_en";

    my $os_en = "1'b1";














    e_assign->adds(
      [["E_rot_n", 5],  "$le_fast_shift_rot_shfcnt"],
      [["E_rot_rn", 5], "E_ctrl_shift_rot_right ? -E_rot_n : E_rot_n"],
      [["E_rot_fill_bit", 1], "E_ctrl_shift_right_arith ? $le_fast_shift_data_msb : 0"],
      );




    e_mux->add ({
      lhs => ["E_rot_left_mask", 8],
      selecto => "E_rot_n[2:0]",
      table => [
        "3'b000" => "8'b00000000",
        "3'b001" => "8'b00000001",
        "3'b010" => "8'b00000011",
        "3'b011" => "8'b00000111",
        "3'b100" => "8'b00001111",
        "3'b101" => "8'b00011111",
        "3'b110" => "8'b00111111",
        "3'b111" => "8'b01111111",
        ],
      });

    e_mux->add ({
      lhs => ["E_rot_right_mask", 8],
      selecto => "E_rot_n[2:0]",
      table => [
        "3'b000" => "8'b00000000",
        "3'b001" => "8'b10000000",
        "3'b010" => "8'b11000000",
        "3'b011" => "8'b11100000",
        "3'b100" => "8'b11110000",
        "3'b101" => "8'b11111000",
        "3'b110" => "8'b11111100",
        "3'b111" => "8'b11111110",
        ],
      });

    e_assign->adds(
      [["E_rot_mask", 8],
        "E_ctrl_shift_rot_right ? E_rot_right_mask : E_rot_left_mask"],

      [["E_rot_pass0",1], "E_ctrl_rot ||                                              (E_ctrl_shift_rot_right && (E_rot_n < 24))"],
      [["E_rot_pass1",1], 
        "E_ctrl_rot || (E_ctrl_shift_rot_left && (E_rot_n <  8))" .
        " || (E_ctrl_shift_rot_right && (E_rot_n < 16))"],
      [["E_rot_pass2",1], 
        "E_ctrl_rot || (E_ctrl_shift_rot_left && (E_rot_n < 16))" .
        " || (E_ctrl_shift_rot_right && (E_rot_n <  8))"],
      [["E_rot_pass3",1], 
        "E_ctrl_rot || (E_ctrl_shift_rot_left && (E_rot_n < 24))"], 
      [["E_rot_sel_fill0", 1], 
        "(E_ctrl_shift_rot_left && (E_rot_n >=  8))"],
      [["E_rot_sel_fill1", 1], 
        "(E_ctrl_shift_rot_left && (E_rot_n >= 16))" .
        " || (E_ctrl_shift_rot_right && (E_rot_n >= 24))"],
      [["E_rot_sel_fill2", 1], 
        "(E_ctrl_shift_rot_left && (E_rot_n >= 24))" .
        " || (E_ctrl_shift_rot_right && (E_rot_n >= 16))"],
      [["E_rot_sel_fill3", 1], "(E_ctrl_shift_rot_right && (E_rot_n >=  8))"],
    );


    if ($s4 eq "A" ) {
        e_register->adds(
          {out => ["M_rot_fill_bit", 1], in => "E_rot_fill_bit", enable => "M_en"},
          {out => ["M_rot_mask", 8],     in => "E_rot_mask",     enable => "M_en"},
        
          {out => ["M_rot_pass0", 1],    in => "E_rot_pass0",    enable => "M_en"},
          {out => ["M_rot_pass1", 1],    in => "E_rot_pass1",    enable => "M_en"},
          {out => ["M_rot_pass2", 1],    in => "E_rot_pass2",    enable => "M_en"},
          {out => ["M_rot_pass3", 1],    in => "E_rot_pass3",    enable => "M_en"},
        
          {out => ["M_rot_sel_fill0", 1], in => "E_rot_sel_fill0", 
           enable => "M_en"},
          {out => ["M_rot_sel_fill1", 1], in => "E_rot_sel_fill1", 
           enable => "M_en"},
          {out => ["M_rot_sel_fill2", 1], in => "E_rot_sel_fill2", 
           enable => "M_en"},
          {out => ["M_rot_sel_fill3", 1], in => "E_rot_sel_fill3", 
           enable => "M_en"},
        );
    }



    e_assign->adds(
      [["E_rot_prestep1", $datapath_sz],
        "E_rot_rn[0] ? {$le_fast_shift_data_lsw, $le_fast_shift_data_msb} : $le_fast_shift_data"],
      [["E_rot_step1", $datapath_sz],
        "E_rot_rn[1] ? {E_rot_prestep1[29:0], E_rot_prestep1[31:30]} : E_rot_prestep1"],
      );

    if ($s4 eq "A" ) {

        e_register->adds(
          {out => ["M_rot_prestep2", $datapath_sz],
           in => 
             "E_rot_rn[2] ?" .
             " {E_rot_step1[27:0], E_rot_step1[31:28]} : E_rot_step1",
           enable => "M_en",
          },
          {out => ["M_rot_rn", 5],
           in => "E_rot_rn",
           enable => "M_en",
          },
        );
    } else {
        e_assign->adds(
          [["E_rot_prestep2", $datapath_sz],
            "E_rot_rn[2] ? {E_rot_step1[27:0], E_rot_step1[31:28]} : E_rot_step1",],
          );
    }




    if ($s4 eq "A" ) {
        e_assign->adds(
           [["M_rot_step2", $datapath_sz],
            "M_rot_rn[3] ? 
              {M_rot_prestep2[23:0], M_rot_prestep2[31:24]} : 
              M_rot_prestep2"],
          [["M_rot", $datapath_sz],
            "M_rot_rn[4] ? 
              {M_rot_step2[15:0], M_rot_step2[31:16]} : 
              M_rot_step2"],
        );
    } else {
        e_assign->adds(
           [["E_rot_step2", $datapath_sz],
            "E_rot_rn[3] ? 
              {E_rot_prestep2[23:0], E_rot_prestep2[31:24]} : 
              E_rot_prestep2"],
          [["E_rot", $datapath_sz],
            "E_rot_rn[4] ? 
              {E_rot_step2[15:0], E_rot_step2[31:16]} : 
              E_rot_step2"],
        );
    }












    if ($s4 eq "A" ) {
        e_assign->adds(






        



          [["M_rot_lut0", 8], 
            "{8{M_rot_sel_fill0 & M_rot_fill_bit}} | (M_rot_fill_bit ? ({8{~M_rot_sel_fill0}} & (M_rot[ 7: 0] | M_rot_mask)) : ({8{~M_rot_sel_fill0}} & M_rot[ 7: 0] & ~M_rot_mask))"],
          [["M_rot_lut1", 8], 
            "{8{M_rot_sel_fill1 & M_rot_fill_bit}} | (M_rot_fill_bit ? ({8{~M_rot_sel_fill1}} & (M_rot[15: 8] | M_rot_mask)) : ({8{~M_rot_sel_fill1}} & M_rot[15: 8] & ~M_rot_mask))"],
          [["M_rot_lut2", 8], 
            "{8{M_rot_sel_fill2 & M_rot_fill_bit}} | (M_rot_fill_bit ? ({8{~M_rot_sel_fill2}} & (M_rot[23:16] | M_rot_mask)) : ({8{~M_rot_sel_fill2}} & M_rot[23:16] & ~M_rot_mask))"],
          [["M_rot_lut3", 8], 
            "{8{M_rot_sel_fill3 & M_rot_fill_bit}} | (M_rot_fill_bit ? ({8{~M_rot_sel_fill3}} & (M_rot[31:24] | M_rot_mask)) : ({8{~M_rot_sel_fill3}} & M_rot[31:24] & ~M_rot_mask))"],
          );  

        e_signal->adds(
          {name => "${os}_shift_rot_result", width => $datapath_sz },
        );
        
        e_register->adds(
          {out => "${os}_shift_rot_result[ 7: 0]", 
           in => "M_rot_pass0 ? M_rot[ 7: 0] : M_rot_lut0",
           enable => $s4_en},
          {out => "${os}_shift_rot_result[15: 8]", 
           in => "M_rot_pass1 ? M_rot[15: 8] : M_rot_lut1",
           enable => $s4_en},
          {out => "${os}_shift_rot_result[23:16]", 
           in => "M_rot_pass2 ? M_rot[23:16] : M_rot_lut2",
           enable => $s4_en},
          {out => "${os}_shift_rot_result[31:24]", 
           in => "M_rot_pass3 ? M_rot[31:24] : M_rot_lut3",
           enable => $s4_en},
          );
    } else {
        e_assign->adds(






        



          [["E_rot_lut0", 8], 
            "{8{E_rot_sel_fill0 & E_rot_fill_bit}} | (E_rot_fill_bit ? ({8{~E_rot_sel_fill0}} & (E_rot[ 7: 0] | E_rot_mask)) : ({8{~E_rot_sel_fill0}} & E_rot[ 7: 0] & ~E_rot_mask))"],
          [["E_rot_lut1", 8], 
            "{8{E_rot_sel_fill1 & E_rot_fill_bit}} | (E_rot_fill_bit ? ({8{~E_rot_sel_fill1}} & (E_rot[15: 8] | E_rot_mask)) : ({8{~E_rot_sel_fill1}} & E_rot[15: 8] & ~E_rot_mask))"],
          [["E_rot_lut2", 8], 
            "{8{E_rot_sel_fill2 & E_rot_fill_bit}} | (E_rot_fill_bit ? ({8{~E_rot_sel_fill2}} & (E_rot[23:16] | E_rot_mask)) : ({8{~E_rot_sel_fill2}} & E_rot[23:16] & ~E_rot_mask))"],
          [["E_rot_lut3", 8], 
            "{8{E_rot_sel_fill3 & E_rot_fill_bit}} | (E_rot_fill_bit ? ({8{~E_rot_sel_fill3}} & (E_rot[31:24] | E_rot_mask)) : ({8{~E_rot_sel_fill3}} & E_rot[31:24] & ~E_rot_mask))"],
          );  
       
         e_assign->adds(
          [["E_shift_rot_result", $datapath_sz], 
            "{E_shift_rot_result_byte3,E_shift_rot_result_byte2,E_shift_rot_result_byte1,E_shift_rot_result_byte0}"],
        );
    
        e_assign->adds(
          [["E_shift_rot_result_byte0", 8], 
            "E_rot_pass0 ? E_rot[ 7: 0] : E_rot_lut0"],
          [["E_shift_rot_result_byte1", 8], 
            "E_rot_pass1 ? E_rot[15: 8] : E_rot_lut1"],
          [["E_shift_rot_result_byte2", 8], 
            "E_rot_pass2 ? E_rot[23:16] : E_rot_lut2"],
          [["E_shift_rot_result_byte3", 8], 
            "E_rot_pass3 ? E_rot[31:24] : E_rot_lut3"],
        );
    }

    my @shift_rotate = (
        { divider => "shift_rotate" },
        { radix => "x", signal => "E_src1" },
        { radix => "x", signal => "E_src2" },
        { radix => "x", signal => "E_valid" },
        { radix => "x", signal => "${os}_en" },
        { radix => "x", signal => "E_ctrl_shift_rot" },
        { radix => "x", signal => "E_ctrl_shift_rot_right" },
        { radix => "x", signal => "E_ctrl_shift_right_arith" },
        ($s4 eq "A") ? { radix => "x", signal => "M_ctrl_shift_rot_right" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_ctrl_rot" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_ctrl_shift_rot_left" } : "",
        { radix => "x", signal => "E_rot_n" },
        { radix => "x", signal => "E_rot_rn" },
        { radix => "x", signal => "E_rot_fill_bit" },
        { radix => "x", signal => "E_rot_left_mask" },
        { radix => "x", signal => "E_rot_mask" },
        { radix => "x", signal => "E_rot_right_mask" },
        { radix => "x", signal => "E_rot_prestep1" },
        { radix => "x", signal => ($s4 eq "A") ? "M_rot_prestep2" : "E_rot_prestep2" } ,
        { radix => "x", signal => ($s4 eq "A") ? "M_rot" : "E_rot" },
        { radix => "x", signal => ($s4 eq "A") ? "M_rot_step2" : "E_rot_step2" },
        { radix => "x", signal => ($s4 eq "A") ? "M_rot_rn" : "E_rot_prestep2" },
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_fill_bit" } : "",
        { radix => "x", signal => "E_rot_mask" },
        { radix => "x", signal => "E_rot_pass0" },
        { radix => "x", signal => "E_rot_pass1" },
        { radix => "x", signal => "E_rot_pass2" },
        { radix => "x", signal => "E_rot_pass3" },
        { radix => "x", signal => "E_rot_sel_fill0" },
        { radix => "x", signal => "E_rot_sel_fill1" },
        { radix => "x", signal => "E_rot_sel_fill2" },
        { radix => "x", signal => "E_rot_sel_fill3" },
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_mask" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_pass0" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_pass1" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_pass2" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_pass3" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_sel_fill0" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_sel_fill1" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_sel_fill2" } : "",
        ($s4 eq "A") ? { radix => "x", signal => "M_rot_sel_fill3" } : "",
        { radix => "x", signal => "${os}_shift_rot_result" },
      );

    push(@plaintext_wave_signals, @shift_rotate);
}







sub 
gen_medium_shift_rotate
{
    my $Opt = shift;

    my $whoami = "small shift/rotate";

    my $le_medium_shift_rot_shfcnt = 
      not_empty_scalar($Opt, "le_medium_shift_rot_shfcnt");
    my $is = not_empty_scalar($Opt, "non_pipelined_long_latency_input_stage");
    my $os = not_empty_scalar($Opt, "long_latency_output_stage");





    e_assign->adds(
      [["E_rot_n", 5],  "$le_medium_shift_rot_shfcnt"],
    );

    e_mux->add ({
      lhs => ["E_shift_by_1", 3],
      selecto => "E_rot_n[1:0]",
      table => [
        "2'b00" => "3'b000",
        "2'b01" => "3'b001",
        "2'b10" => "3'b011",
        "2'b11" => "3'b111",
        ],
      });

    e_mux->add ({
      lhs => ["E_shift_by_4", 7],
      selecto => "E_rot_n[4:2]",
      table => [
        "3'b000" => "7'b0000000",
        "3'b001" => "7'b0000001",
        "3'b010" => "7'b0000011",
        "3'b011" => "7'b0000111",
        "3'b100" => "7'b0001111",
        "3'b101" => "7'b0011111",
        "3'b110" => "7'b0111111",
        "3'b111" => "7'b1111111",
        ],
      });

    e_register->adds(
      {out => ["${is}_shift_by_1", 3], 
       in => "E_shift_by_1", enable => "M_en"},
      {out => ["${is}_shift_by_4", 7], 
       in => "E_shift_by_4", enable => "M_en"},
      );

    e_assign->adds(
      [["${os}_shift_by_1_nxt", 3],
        "${os}_shift_rot_stall ? 
          {1'b0,${os}_shift_by_1[2:1]} : 
           ${is}_shift_by_1"],



      [["${os}_shift_by_4_nxt", 7],
        "(~${os}_shift_rot_stall) ? M_shift_by_4 :
         (~${os}_shift_by_1[0])   ? {1'b0,${os}_shift_by_4[6:1]} : 
           ${os}_shift_by_4"],
           
      [["${os}_shift_rot_done_nxt", 1], "~(${os}_shift_by_1_nxt[0] || ${os}_shift_by_4_nxt[0])"],

      [["${os}_shift_rot_stall_nxt", 1], 
        "~${os}_shift_rot_done_nxt & 
         (${os}_shift_rot_stall | (${is}_ctrl_shift_rot & 
          ${is}_valid & ${os}_en))"],


      [["${os}_shift_rot_fill_bit", 1],
        "${os}_ctrl_shift_logical ? 1'b0 :
          (${os}_ctrl_rot_right ? 
            ${os}_shift_rot_result[0] : 
            ${os}_shift_rot_result[31])"],
            
      [["${os}_shift_rot_fill_bit4", 4],
      "(${os}_ctrl_shift_logical | ${os}_ctrl_shift_right_arith) ? ({4{${os}_ctrl_shift_right_arith}} & {4{${os}_shift_rot_result[31]}}) :
          (${os}_ctrl_rot_right ? 
            ${os}_shift_rot_result[3:0] : 
            ${os}_shift_rot_result[31:28])"],
      



      [["${os}_shift_rot_result_nxt", $datapath_sz],
        "(~${os}_shift_rot_stall)? M_src1 : 
            (${os}_shift_by_1[0] ? (${os}_ctrl_shift_rot_right ? {${os}_shift_rot_fill_bit, ${os}_shift_rot_result[31 : 1]} :
                {${os}_shift_rot_result[30 : 0], ${os}_shift_rot_fill_bit}) :
            (${os}_ctrl_shift_rot_right? {${os}_shift_rot_fill_bit4, ${os}_shift_rot_result[31 : 4]} :
                {${os}_shift_rot_result[27 : 0], ${os}_shift_rot_fill_bit4}))"],
      );

    e_register->adds(
      {out => ["${os}_shift_rot_result", $datapath_sz], 
       in => "${os}_shift_rot_result_nxt", enable => "1'b1"},
      {out => ["${os}_shift_by_1", 3], 
       in => "${os}_shift_by_1_nxt", enable => "1'b1"},
      {out => ["${os}_shift_by_4", 7], 
       in => "${os}_shift_by_4_nxt", enable => "1'b1"},
      {out => ["${os}_shift_rot_stall", 1], 
       in => "${os}_shift_rot_stall_nxt", enable => "1'b1"},
      );

    my @shift_rotate = (
        { divider => "shift_rotate" },
        { radix => "x", signal => "${is}_src1" },
        { radix => "x", signal => "${is}_src2" },
        { radix => "x", signal => "${os}_ctrl_shift_rot" },
        { radix => "x", signal => "${os}_ctrl_shift_logical " },
        { radix => "x", signal => "${os}_ctrl_rot_right" },
        { radix => "x", signal => "${os}_ctrl_shift_rot_right" },
        { radix => "x", signal => "${os}_shift_rot_done_nxt" },
        { radix => "x", signal => "${os}_shift_rot_stall" },
        { radix => "x", signal => "${os}_shift_rot_fill_bit" },
        { radix => "x", signal => "${os}_shift_rot_cnt_nxt" },
        { radix => "x", signal => "${os}_shift_rot_cnt" },
        { radix => "x", signal => "${os}_shift_rot_result_nxt" },
        { radix => "x", signal => "${os}_shift_rot_result" },
    );

    push(@plaintext_wave_signals, @shift_rotate);
}







sub 
gen_small_shift_rotate
{
    my $Opt = shift;

    my $whoami = "small shift/rotate";

    my $is = not_empty_scalar($Opt, "non_pipelined_long_latency_input_stage");
    my $os = not_empty_scalar($Opt, "long_latency_output_stage");
    my $le_small_shift_rot_shfcnt = 
      not_empty_scalar($Opt, "le_small_shift_rot_shfcnt");





    e_assign->adds(
      [["M_rot_n", 5],  "$le_small_shift_rot_shfcnt"],
      [["${os}_shift_rot_cnt_nxt", $datapath_log2_sz],
        "${os}_shift_rot_stall ? 
           ${os}_shift_rot_cnt-1 : 
           M_rot_n"],

      [["${os}_shift_rot_done_nxt", 1], "${os}_shift_rot_cnt_nxt == 0"],

      [["${os}_shift_rot_stall_nxt", 1], 
        "~${os}_shift_rot_done_nxt & 
         (${os}_shift_rot_stall | (${is}_ctrl_shift_rot & 
          ${is}_valid & ${os}_en))"],


      [["${os}_shift_rot_fill_bit", 1],
        "${os}_ctrl_shift_logical ? 1'b0 :
          (${os}_ctrl_rot_right ? 
            ${os}_shift_rot_result[0] : 
            ${os}_shift_rot_result[31])"],
      );

    e_mux->add ({
      lhs => ["${os}_shift_rot_result_nxt", $datapath_sz],
      type => "priority",
      table => [


        "~${os}_shift_rot_stall" => "${is}_src1",


        "${os}_ctrl_shift_rot_right" => 
          "{${os}_shift_rot_fill_bit, ${os}_shift_rot_result[$datapath_msb:1]}",


        "1'b1" => 
          "{${os}_shift_rot_result[$datapath_msb-1:0], ${os}_shift_rot_fill_bit}",
        ],
      });

    e_register->adds(
      {out => ["${os}_shift_rot_result", $datapath_sz], 
       in => "${os}_shift_rot_result_nxt", enable => "1'b1"},
      {out => ["${os}_shift_rot_cnt", $datapath_log2_sz], 
       in => "${os}_shift_rot_cnt_nxt", enable => "1'b1"},
      {out => ["${os}_shift_rot_stall", 1], 
       in => "${os}_shift_rot_stall_nxt", enable => "1'b1"},
      );

    my @shift_rotate = (
        { divider => "shift_rotate" },
        { radix => "x", signal => "${is}_src1" },
        { radix => "x", signal => "${is}_src2" },
        { radix => "x", signal => "${os}_ctrl_shift_rot" },
        { radix => "x", signal => "${os}_ctrl_shift_logical " },
        { radix => "x", signal => "${os}_ctrl_rot_right" },
        { radix => "x", signal => "${os}_ctrl_shift_rot_right" },
        { radix => "x", signal => "${os}_shift_rot_done_nxt" },
        { radix => "x", signal => "${os}_shift_rot_stall" },
        { radix => "x", signal => "${os}_shift_rot_fill_bit" },
        { radix => "x", signal => "${os}_shift_rot_cnt_nxt" },
        { radix => "x", signal => "${os}_shift_rot_cnt" },
        { radix => "x", signal => "${os}_shift_rot_result_nxt" },
        { radix => "x", signal => "${os}_shift_rot_result" },
    );

    push(@plaintext_wave_signals, @shift_rotate);
}

sub 
gen_designware_fast_shift_rotate
{
    my $Opt = shift;

    my $whoami = "Designware fast shift/rotate";
    my $os = check_opt_value($Opt, "long_latency_output_stage", ["E","A"], $whoami);
    my $le_fast_shift_rot_shfcnt = 
      not_empty_scalar($Opt, "le_fast_shift_rot_shfcnt");


    my $submodule_name = $Opt->{name}."_shift_rot_cell";
    my $submodule = e_module->new({
      name        => $submodule_name,
      output_file => $submodule_name,
    });
    e_instance->add({module => $submodule});
    my $marker = e_default_module_marker->new($submodule);


    e_comment->add({
      comment=>"Need decode control signals such as shift direction,\n".
               "shift or rotate, arithmetic or logical.\n",
    });


    e_signal->adds(
       {name => "E_shift_rot_result", width => $datapath_sz },
    );



    e_assign->add(
      [["E_src2_control", 5], "$le_fast_shift_rot_shfcnt"],
    );







    e_assign->add(
      [["E_src2_tc", 5], 
        "E_ctrl_shift_rot_left ? E_src2_control :" .
          " (5'd31 - E_src2_control + 5'd1)"],
    );




    e_assign->add(
      ["rt_shift_0", 
        "E_ctrl_shift_rot_left ? 1'b0 : (E_src2_control == 0 ? 1'b1 : 1'b0 )"],
    );





    e_assign->add(
      ["dir_control", "~E_ctrl_shift_rot_left ^ rt_shift_0"],
    );











    my %shift_rot_inputs = (
        "data_in"       => "E_src1",

        "data_tc"       => "E_ctrl_shift_right_arith",


        "sh"       => "{dir_control, E_src2_tc}",

        "sh_tc"       => "1'b1",







        "sh_mode"         => "!E_ctrl_rot",
    );

    my %shift_rot_outputs = (
         "data_out" => "E_shift_rot_result",
    );
    
    my %shift_rot_parameters = (
        "data_width"                               => $datapath_sz,
        "sh_width"                               => 6,
    );

    e_comment->add({
      comment => 
        "Replace shifter-rotator with desigware ASIC shifter-rotator.\n",
    });

    e_blind_instance->add({
      name              => "the_designware_shift_rot",
      module            => "DW_shifter",
      in_port_map       => \%shift_rot_inputs,
      out_port_map      => \%shift_rot_outputs,
      parameter_map     => \%shift_rot_parameters,
      use_sim_models    => 1,
    });

    if ($os ne "E") {


        e_comment->add({
          comment => 
            "A pipeline register here for M_en\n".
            "as the shifter doesn't have pipeline inside.\n",
        });
        
        e_register->adds(
          {out => ["M_shift_rot_result", $datapath_sz], 
           in => "E_shift_rot_result", enable => "M_en"},
        );
        



        e_register->adds(
          {out => ["A_shift_rot_result", $datapath_sz], 
           in => "M_shift_rot_result", enable => "A_en"},
        );
    }

    my @shift_rotate = (
        { divider => "shift_rotate" },
        { radix => "x", signal => "E_src1" },
        { radix => "x", signal => "E_src2" },
        { radix => "x", signal => "E_ctrl_shift_rot" },
        { radix => "x", signal => "E_ctrl_shift_rot_right" },
        { radix => "x", signal => "E_ctrl_shift_right_arith" },
        ($os ne "E") ? { radix => "x", signal => "M_shift_rot_result" } : "",
        ($os ne "E") ? { radix => "x", signal => "A_shift_rot_result" } : "",
      );

    push(@plaintext_wave_signals, @shift_rotate);
}


1;
