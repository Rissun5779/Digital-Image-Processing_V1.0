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






















package nios_div;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $hw_div
);

use cpu_utils;
use cpu_wave_signals;
use nios_europa;
use nios_isa;
use europa_all;
use europa_utils;
use strict;





our $hw_div;
our $hw_div_srt2;





sub 
initialize_config_constants
{
    my $divide_info = shift;


    $hw_div = manditory_bool($divide_info, "hardware_divide_present");

    if ($hw_div) {
        my $hw_div_impl = 
          not_empty_scalar($divide_info, "hardware_divide_impl");

        if ($hw_div_impl eq "srt2") {
            $hw_div_srt2 = 1;
        } else {
            &$error("Unsupported hardware divider implementation of" .
              " '$hw_div_impl'");
        }
    }
}








sub 
gen_div
{
    my $Opt = shift;

    if (!$hw_div) {
        &$error("Called when hw_div is false");
    }

    if ($hw_div_srt2) {
        gen_srt2_div($Opt);
    } else {
        &$error("Unsupported hardware divider implementation");
    }
}

sub
gen_srt2_div
{
    my $Opt = shift;

    my $whoami = "srt2 hardware divide";



    my $div_is = check_opt_value($Opt, "divider_input_stage",
      ["E", "M"], $whoami);
    my $is = check_opt_value($Opt, "non_pipelined_long_latency_input_stage",
      ["E", "M"], $whoami);
    my $os = not_empty_scalar($Opt, "long_latency_output_stage");
    my $div_done = not_empty_scalar($Opt, "div_done");


    e_assign->adds(
          [["E_src2_eq_zero", 1], "E_src2 == 0"],
    );








    e_signal->adds(
      {name => "W_div_quot_ready", never_export => 1, width => 1},
      {name => "div_active_d2", never_export => 1, width => 1},
      {name => "${os}_div_done", never_export => 1, width => 1},
    );


    my $m_ctrl_div = "M_ctrl_div";

    my $os_en_div_valid ="M_en";

    my $pipe_stage ="${is}";






    e_assign->adds(
      [["${div_is}_div_negate_src1", 1],
        "${div_is}_ctrl_div_signed & ${div_is}_src1[$datapath_msb]"],

      [["${div_is}_div_negate_src2", 1], 
        "${div_is}_ctrl_div_signed & ${div_is}_src2[$datapath_msb]"],

      [["${div_is}_div_negate_result", 1], 
        "${div_is}_div_negate_src1 ^ ${div_is}_div_negate_src2"],

      [["${div_is}_div_negate_remainder", 1], 
        "${div_is}_div_negate_src1"],

      [["E_div_valid", 1, 0, $force_never_export],
        "E_ctrl_div & E_valid"],

      [["M_div_valid", 1, 0, $force_never_export],
        "$m_ctrl_div & M_valid"],
    );


    e_register->adds(
      {out => ["${pipe_stage}_div_negate_result", 1],
       in => "${div_is}_div_negate_result ",
       enable => "${os_en_div_valid}"},

      {out => ["${pipe_stage}_div_negate_remainder", 1],
       in => "${div_is}_div_negate_remainder", enable => "${os_en_div_valid}"},
    );

    e_register->adds(
      {out => ["${pipe_stage}_div_src2", $datapath_sz],
       in => "${div_is}_div_src2", 
       enable => "${os_en_div_valid}"},

      {out => ["${pipe_stage}_div_src1", $datapath_sz],
       in => "${div_is}_div_src1", 
       enable => "${os_en_div_valid}"},

      {out => ["${pipe_stage}_src2_eq_zero", 1],
       in => "${div_is}_src2_eq_zero", 
       enable => "${os_en_div_valid}"},

    );


    e_assign->adds(
      [["${div_is}_div_src1", $datapath_sz, 0, $force_never_export], 
        "${div_is}_div_negate_src1 ? -${div_is}_src1 : ${div_is}_src1"],

      [["${div_is}_div_src2", $datapath_sz, 0, $force_never_export], 
        "${div_is}_div_negate_src2 ? -${div_is}_src2 : ${div_is}_src2"],
    );



    e_assign->adds(
      [["M_src1", $datapath_sz, 0, $force_never_export], "M_div_src1"],
      [["M_src2", $datapath_sz, 0, $force_never_export], "M_div_src2"],
    );

    e_assign->adds(
      [["A_div_valid", 1, 0, $force_never_export], "A_ctrl_div & A_valid"],
    );  


    my $div_cnt_rem = 33;
    my $div_cnt_quot_ready = 34;
    my $div_cnt_quotient_done = 32;

    my $div_active_invert = "~";
    my $div_valid_not_active = "A_en";
    my $not_active = "A_en";
    my $div_valid_a_en = "A_en";
    my $mthilo_a_en_valid = "${pipe_stage}_en & ${pipe_stage}_valid";
    e_assign->adds(



        [["A_div_stall", 1], 
          "A_div_valid & ~${div_done}"],
    );




    e_assign->adds (
      [["div_sum", 33],
        "(div_quotient_done ?  div_remainder : 
        {div_remainder[$datapath_msb:0],${os}_div_quotient[$datapath_msb+1]}) + 
        (div_subtract ? (~{1'b0,div_src2}) : div_src2) + div_subtract"],

      [["${os}_div_quot", $datapath_sz, 0, $force_never_export],
        "div_src2_eq_zero ? 32'hdeadbeef :
         div_negate_result ? (-${os}_div_quotient[$datapath_msb:0]) : 
          ${os}_div_quotient[$datapath_msb:0]"],

      [["${os}_div_rem", $datapath_sz, 0, $force_never_export],
        "div_src2_eq_zero ? 32'hdeadbeef :
         div_negate_remainder ? (-div_remainder[$datapath_msb:0]) : 
          div_remainder[$datapath_msb:0]"],

      [["remainder_done", 1],
        "((div_cnt == 6'd${div_cnt_rem}) & !div_remainder[$datapath_msb+1]) | (div_cnt == 6'd${div_cnt_quot_ready})"],

      [["${os}_div_quot_ready", 1],
        "(div_cnt == 6'd${div_cnt_quot_ready})"],

      [["div_active_nxt",1],
        "${os}_div_quot_ready ? 0 : 
         ${os}_div_valid & ${div_active_invert}${os}_en  ?  1 : div_active"],
      );



    e_register->adds (
      {out    => "div_quotient_done",
      in      => "div_cnt == 6'd${div_cnt_quotient_done}",
      enable  => "1'b1"},

      {out    => "div_subtract",
      in      => "(${div_valid_not_active}) ? 1'b1 : 
                  ~div_sum[$datapath_msb+1]",
      enable  => "1'b1"},

      {out    => ["${os}_div_quotient", $datapath_sz+1],
      in      => "div_quotient_done ? ${os}_div_quotient:
                   ${not_active} ? ${pipe_stage}_div_src1 : 
                   {${os}_div_quotient[$datapath_msb:0],~div_sum[$datapath_msb+1]}",

      enable  => "1'b1"},

      {out    => ["div_remainder", $datapath_sz+1],
      in      => "(${div_valid_not_active}) ? 0 : 
                  remainder_done ? div_remainder : div_sum[$datapath_msb+1:0]",
      enable  => "1'b1" },

      {out    => ["div_cnt", 6],
      in      => "${os}_div_quot_ready ? 0 : 
                 (${os}_div_valid & ~div_active) ? 1 :
                 ( div_active) ? 
                  div_cnt + 1 : 0",
      enable  => "1'b1" },

      {out    => "div_active",
      in      => "div_active_nxt",
      enable  => "1'b1" },

      {out    => "div_src2",
      in      => "${pipe_stage}_div_src2",
      enable  => "${div_valid_a_en}" },

      {out    => "div_negate_result",
      in      => "(${div_valid_a_en}) ? ${pipe_stage}_div_negate_result :
                   ${os}_div_quot_ready ? 1'b0 : div_negate_result",
      enable  => "1'b1" },

      {out => ["div_src2_eq_zero", 1],
       in => "(${mthilo_a_en_valid}) ? 0 :
              (${pipe_stage}_div_valid & ${pipe_stage}_en) ? ${pipe_stage}_src2_eq_zero : 
              ${os}_div_quot_ready ? 1'b0 : div_src2_eq_zero", 
       enable => "1'b1"},

      {out    => "div_negate_remainder",
      in      => "${pipe_stage}_div_negate_remainder",
      enable  => "${pipe_stage}_div_valid & ${pipe_stage}_en" },

      {out    => "div_active_d1",
      in      => "div_active", enable  => "1'b1" },

      {out    => "div_active_d2",
      in      => "div_active_d1", enable  => "1'b1" },

      {out    => "W_div_quot_ready",
      in      => "${os}_div_quot_ready",
      enable  => "1'b1" },
      );



    my @div = (
        { divider => "div" },
        { radix => "x", signal => "M_div_negate_src1" },
        { radix => "x", signal => "M_div_negate_src2" },
        { radix => "x", signal => "M_div_negate_result" },
        { radix => "x", signal => "${is}_ctrl_div" },
        { radix => "x", signal => "${is}_div_src1" },
        { radix => "x", signal => "${is}_div_src2" },
        { radix => "x", signal => "${is}_div_negate_result" },
        { radix => "x", signal => "${os}_ctrl_div" },
        { radix => "x", signal => "${os}_div_quot_ready" },
        { radix => "x", signal => "div_active" },
        { radix => "x", signal => "${os}_div_stall" },
        { radix => "x", signal => "$div_done" },
    );

    push(@plaintext_wave_signals, @div);
}

1;
