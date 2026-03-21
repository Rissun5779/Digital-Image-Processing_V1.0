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






















package nios_flash_accelerator;

use europa_all;
use europa_utils;
use cpu_utils;
use cpu_wave_signals;
use cpu_file_utils;
use cpu_bit_field;
use nios_utils;
use nios_common;
use nios_avalon_masters;
use nios_isa;
use strict;














sub 
gen_flash_accelerator
{
    my $Opt = shift;

    my $whoami = "Flash-Accelerator";

    my $fa_lines = manditory_int($Opt,"fa_cache_line");
    my $fa_cache_line_size = manditory_int($Opt,"fa_cache_line_size");
    my $fa_cache_increment = $fa_cache_line_size / 4;


    my $fa_master_baddr_sz = $Opt->{flash_instruction_master}{Address_Width};
    my $fa_master_word_msb = $fa_master_baddr_sz - 2 - 1;

    my $fa_data_bits = $fa_cache_line_size * 8;
    my $fa_cache_word_per_line = $fa_cache_line_size / 4;
    my $fa_tag_lsb = log($fa_cache_word_per_line) / log(2);
    my $fa_index_size = log($fa_lines) / log(2);
        

    my $fa_tag_field_msb = $fa_master_baddr_sz - 2 - 1;
    my $fa_address_word_sz = $fa_tag_field_msb + 1;
    my $fa_tag_field_lsb = $fa_tag_lsb; 
    my $fa_tag_field_sz = $fa_tag_field_msb - $fa_tag_field_lsb + 1;

    my $fa_need_fill_pc = "(D_refetch ? D_pc[$fa_tag_field_msb:0] : F_pc[$fa_tag_field_msb:0])";

    e_register->adds(
      {out => ["fa_address_fixed", $fa_address_word_sz],     in => "$fa_need_fill_pc", 
       enable => "fa_need_fill_starting"},
      );




    e_assign->adds(
      [["fa_waddress_nxt", $fa_address_word_sz], "fa_need_fill_starting ? $fa_need_fill_pc :
      fa_pending_starting ? fa_address_fixed :
      fa_read & ~fa_waitrequest  ? {fa_waddress[$fa_tag_field_msb:$fa_tag_field_lsb] + 1, {${fa_tag_lsb}{1'b0}}} :
                                    fa_waddress"],

      [["fa_w_address_nxt", $fa_address_word_sz], "{(D_refetch ? D_pc[$fa_tag_field_msb:$fa_tag_field_lsb] : F_pc[$fa_tag_field_msb:$fa_tag_field_lsb]) + 1, {${fa_tag_lsb}{1'b0}}}"],                              
    );
    
    e_register->adds(
      {out => ["fa_waddress", $fa_address_word_sz],     in => "fa_waddress_nxt", 
       enable => "~(fa_read & fa_waitrequest)"},
      );
    
    e_assign->adds(
        [["fa_address", $fa_master_baddr_sz], "{fa_waddress[$fa_master_word_msb:0],2'b00}"],
        







                                    
        [["fa_non_sequential", 1], "fa_op_call|
                                    fa_op_jmpi|
                                    fa_op_eret|
                                    fa_op_bret|
                                    fa_op_ret|
                                    fa_op_jmp|
                                    fa_op_callr|
                                    fa_op_br
                                    "],
    );
    


    e_assign->adds(
      [["buffer_en", 1], " fa_need_fill_starting | fa_pending_starting | ((fa_read & ~fa_waitrequest) & (buffer_level != 1))"],
    );
    
    e_register->adds(
      {out => ["buffer_level", 2],     in => "fa_need_fill_starting | fa_pending_starting? 0 : buffer_level + 1", 
       enable => "buffer_en"},
      );
    
    my $oci_version = manditory_int($Opt, "oci_version");
    my $fa_burstcount_size = $fa_cache_line_size == 8 ? 2 : 3;


    e_assign->adds(
      [["fa_burstcount", $fa_burstcount_size], "$fa_cache_increment"],
    );

    e_register->adds(
      {out => ["fa_read", 1],     in => ($oci_version == 2) ? "(fa_waitrequest & fa_read) | (fa_need_fill & ~fetch_inst_cancel)" : "(fa_waitrequest & fa_read) | fa_need_fill", 
       enable => "1'b1"},
      );
    

    e_assign->adds(
      [["fa_valid_mux", $fa_cache_word_per_line], $fa_cache_word_per_line == 2 ? "buffer_fill_offset ? 2'b10 :
                                                                                                       2'b01" :
                                                                                 "buffer_fill_offset == 3 ? 4'b1000 :
                                                                                  buffer_fill_offset == 2 ? 4'b0100 :
                                                                                  buffer_fill_offset == 1 ? 4'b0010 :
                                                                                                            4'b0001"
                                                                                  ],
      [["fa_non_sequential_mux", $fa_cache_word_per_line], $fa_cache_word_per_line == 2 ? "buffer_fill_offset ? {fa_non_sequential, 1'b0} :
                                                                                                                {1'b0, fa_non_sequential}" :
                                                                                 "buffer_fill_offset == 3 ? {fa_non_sequential, 3'b000} :
                                                                                  buffer_fill_offset == 2 ? { 1'b0, fa_non_sequential, 2'b00} :
                                                                                  buffer_fill_offset == 1 ? { 2'b0, fa_non_sequential, 1'b00} :
                                                                                                            { 3'b0, fa_non_sequential}"
                                                                                  ],
    );
    
    for (my $lines =0; $lines < $fa_lines ; $lines = $lines + 1) {
        e_register->adds(
            {out => ["fa_line${lines}_tag", $fa_tag_field_sz],     in => "fa_fill_address[${fa_tag_field_msb}:${fa_tag_field_lsb}]", 
             enable => "fa_fill_select${lines} & (fa_readdatavalid & ~fa_prevent_fill)"},
            {out => ["fa_line${lines}_valid", $fa_cache_word_per_line],     in => "fa_fill_line_start | fa_invalidate_line${lines} ?  {${fa_cache_word_per_line}{(fa_readdatavalid & ~fa_prevent_fill)}} & fa_valid_mux : 
                                                             (fa_valid_mux | fa_line${lines}_valid)", 
             enable => "(fa_fill_select${lines} & ((fa_readdatavalid & ~fa_prevent_fill) | fa_fill_line_start)) | fa_invalidate_line${lines}"},

            {out => ["fa_line${lines}_non_sequential", 4],     in => "fa_fill_line_start ? {4{(fa_readdatavalid)}} & fa_non_sequential_mux : 
                                                                      fa_non_sequential_mux | fa_line${lines}_non_sequential", 
             enable => "(fa_fill_select${lines} & ((fa_readdatavalid & ~fa_prevent_fill) | fa_fill_line_start))"},
            {out => ["fa_line${lines}_data", $fa_data_bits],     
             in => ($fa_cache_line_size == 8) ? "buffer_fill_offset ? {fa_readdata,fa_line${lines}_data[31:0]} :
                                                                      {fa_line${lines}_data[63:32],fa_readdata}" : 
                                                "buffer_fill_offset == 3 ? {fa_readdata,fa_line${lines}_data[95:0]} :
                                                 buffer_fill_offset == 2 ? {fa_line${lines}_data[127:96],fa_readdata,fa_line${lines}_data[63:0]} :
                                                 buffer_fill_offset == 1 ? {fa_line${lines}_data[127:64],fa_readdata,fa_line${lines}_data[31:0]} :
                                                                           {fa_line${lines}_data[127:32],fa_readdata}", 
             enable => "fa_fill_select${lines} & (fa_readdatavalid & ~fa_prevent_fill)"},
            );
    }
    

    my @F_fa_hit_expr;
    my @F_fa_index_expr;
    my @F_fa_iw_expr;
    my @F_fa_non_sequential_expr;
    
    my $F_pc_expr = "F_pc";
    
    e_assign->adds(
        [["F_fa_offset", $fa_tag_lsb], $fa_tag_lsb == 2 ? "${F_pc_expr}[1:0]" : "${F_pc_expr}[0]"],
    );
    
    for (my $lines =0; $lines < $fa_lines ; $lines = $lines + 1) {
        e_assign->adds(
            [["F_fa_line${lines}_match", 1], "fa_line${lines}_tag == ${F_pc_expr}[${fa_tag_field_msb}:${fa_tag_field_lsb}]"],
            [["F_fa_line${lines}_iw", 32], 
            ($fa_cache_line_size == 8) ? "F_fa_offset ? fa_line${lines}_data[63:32] : fa_line${lines}_data[31:0]" : 
                                         "F_fa_offset == 3 ? fa_line${lines}_data[127:96] :
                                          F_fa_offset == 2 ? fa_line${lines}_data[95:64] :
                                          F_fa_offset == 1 ? fa_line${lines}_data[63:32] :
                                                             fa_line${lines}_data[31:0]"],
            [["F_fa_line${lines}_valid_bit", 1], "fa_line${lines}_valid[F_fa_offset]"],
            [["F_fa_line${lines}_non_sequential", 1], "fa_line${lines}_non_sequential[F_fa_offset]"],
        );
        push(@F_fa_hit_expr, "(F_fa_line${lines}_match & F_fa_line${lines}_valid_bit)");
        push(@F_fa_index_expr, "({${fa_index_size} {F_fa_line${lines}_match}} & $lines)");
        push(@F_fa_iw_expr, "({32 {F_fa_line${lines}_match}} & F_fa_line${lines}_iw)");
        push(@F_fa_non_sequential_expr, "({1 {F_fa_line${lines}_match}} & F_fa_line${lines}_non_sequential)");
    }

    e_assign->adds(
        [["F_fa_hit", 1], "(" . join(" | ", @F_fa_hit_expr) . ")"],
        [["F_fa_iw_valid", 1], "F_fa_hit & F_sel_flash_instruction_master"],
        [["F_fa_non_sequential", 1], "(" . join(" | ", @F_fa_non_sequential_expr) . ")"],
        [["F_fa_index", $fa_index_size], join(" | ", @F_fa_index_expr)],
        [["F_fa_iw", 32], join(" | ", @F_fa_iw_expr)],
        [["fa_iw", 32], "fa_readdata"],
    );


    e_register->adds(
      {out => ["D_fa_hit", 1],     in => "F_fa_hit", 
       enable => "1'b1"},
      {out => ["D_fa_index", $fa_index_size],     in => "F_fa_index", 
       enable => "D_en"},
      );



    my @fa_w_nxt_hit_expr;
    
    e_assign->adds(
        [["fa_w_nxt_offset", $fa_tag_lsb, 0, $force_never_export], $fa_tag_lsb == 2 ? "fa_w_address_nxt[1:0]" : "fa_w_address_nxt[0]"],
    );
    
    for (my $lines =0; $lines < $fa_lines ; $lines = $lines + 1) {
        e_assign->adds(
            [["fa_w_nxt_line${lines}_match", 1], "fa_line${lines}_tag == fa_w_address_nxt[${fa_tag_field_msb}:${fa_tag_field_lsb}]"],
            [["fa_w_nxt_line${lines}_valid_bit", 1], "fa_line${lines}_valid[fa_w_nxt_offset]"],
        );
        push(@fa_w_nxt_hit_expr, "({1 {fa_w_nxt_line${lines}_match}} & fa_w_nxt_line${lines}_valid_bit)");
    }
    
    e_assign->adds(
        [["fa_w_nxt_hit", 1], "(" . join(" | ", @fa_w_nxt_hit_expr) . ")"],
    );
    
    e_register->adds(

      {out => ["fa_w_nxt_hit_pending", 1],     in => "(fa_w_nxt_hit & fa_need_fill_starting) ? 1'b1 : 
                                                      fa_fill_line_done ? 1'b0 :
                                                      fa_w_nxt_hit_pending", 
       enable => "1'b1"},
      );

    my $half_fill_count = $fa_cache_line_size/4;

    e_assign->adds(


        [["fa_non_sequential_valid", 1],  "(buffer_fill_offset >= fa_address_fixed[${fa_tag_lsb}-1:0]) & fa_readdatavalid"],

        [["fa_prevent_next_fill_valid", 1], "(fa_non_sequential_valid & fa_non_sequential) & (buffer_fill_count < ${half_fill_count}) & ~fa_w_nxt_hit_pending"],
    );

    e_register->adds(
      {out => ["fa_prevent_next_fill", 1],     in => "fa_prevent_fill ? 1'b0 : 
                                                      fa_prevent_next_fill_valid ? 1'b1 : 
                                                      fa_prevent_next_fill", 
       enable => "1'b1"},
      {out => ["fa_prevent_fill_d1", 1],     in => "fa_prevent_fill_done ? 1'b0 : fa_prevent_fill", 
       enable => "1'b1"},
      




      {out => ["fa_prevent_fill_reg", 1],     in => "fa_prevent_fill", 
       enable => "fa_readdatavalid|fa_prevent_fill_done"},
      {out => ["fa_prevent_fill_reg_d1", 1, 0, $force_never_export],     in => "fa_prevent_fill & fa_prevent_fill_reg", 
       enable => "fa_readdatavalid|fa_prevent_fill_done"},
      {out => ["fa_prevent_fill_reg_d2", 1, 0, $force_never_export],     in => "fa_prevent_fill & fa_prevent_fill_reg_d1", 
       enable => "fa_readdatavalid|fa_prevent_fill_done"},
    ); 

    e_assign->adds(
        [["fa_prevent_fill_done", 1], $fa_cache_line_size == 8 ? "fa_prevent_fill & (fa_readdatavalid & fa_prevent_fill_reg)" : "fa_prevent_fill & (fa_readdatavalid & fa_prevent_fill_reg_d2)"],



        [["fa_prevent_fill", 1], "(fa_prevent_next_fill & fa_fill_line_done_d1) | fa_prevent_fill_d1"],
    );


    e_register->adds(
      {out => ["D_fa_non_sequential", 1],     in => "D_fa_non_sequential_d2 ? 1'b0 :
                                                     (F_fa_non_sequential & F_fa_iw_valid)? 1'b1 :
                                                     D_fa_non_sequential", 
       enable => "1'b1"},
      {out => ["D_fa_non_sequential_d1", 1],     in => "F_fa_non_sequential & F_fa_iw_valid", 
       enable => "1'b1"},
      {out => ["D_fa_non_sequential_d2", 1],     in => "(F_ctrl_jmp_direct & F_fa_iw_valid) |D_fa_non_sequential_d1", 
       enable => "1'b1"},
      {out => ["fa_fetch_same_line", 1],     in => "fa_fill_address[$fa_tag_field_msb:$fa_tag_field_lsb] == F_pc[$fa_tag_field_msb:$fa_tag_field_lsb] & fa_need_fill_active", 
       enable => "1'b1"},
      
    );
    

     e_register->adds(
      {out => ["fa_pending_starting", 1],     in => "fa_need_fill_starting & fa_read & fa_waitrequest ? 1'b1 :
      	  											 fa_read & ~fa_waitrequest ? 1'b0 :
      	  											 fa_pending_starting", 
       enable => "1'b1"},     
    );
     
    e_assign->adds(
        [["fa_prevent_miss", 1],  "D_fa_non_sequential|fa_fetch_same_line"],
    );
    



    e_assign->adds(
        [["fa_miss", 1],  "(~F_fa_hit & F_sel_flash_instruction_master) & reset_sync & ~fa_prevent_miss"],
        [["fa_need_fill_starting", 1], "fa_miss & ~fa_miss_d1"],
        [["fa_need_fill", 1], "fa_need_fill_starting | (~(fa_w_nxt_hit_pending) & buffer_level !=1 & fa_need_fill_d1) | fa_pending_starting"],
    );
    

    my $fill_count_max = 2 * $fa_cache_line_size/4 - 1;
    my $half_fill_count_max = $fa_cache_line_size/4 - 1;

    e_register->adds(

      {out => ["fa_miss_d1", 1],     in => "fa_miss_d1 ? ~(((fa_w_nxt_hit_pending|fa_prevent_next_fill_valid|fa_prevent_next_fill) ? buffer_fill_count == ${half_fill_count_max} : buffer_fill_count == ${fill_count_max}) & fa_fill_line_done) :
                                            fa_miss", 
       enable => "1'b1"},
      {out => ["fa_need_fill_d1", 1],     in => "fa_need_fill", 
       enable => "1'b1"},
      {out => ["fa_fill_line_done_d1", 1],     in => "fa_fill_line_done", 
       enable => "1'b1"},
      {out => ["reset_sync", 1],     in => "1'b1", 
       enable => "1'b1"}, 
      ); 
   

    e_assign->adds(
        [["fa_lru_access", 1], "fa_fill_line_done | (D_fa_hit & ~fa_need_fill_active)"],
    );
    
    my $lru_fifo_bits = count2sz($fa_lines);
    my $lru_fifo_tail = 0;
    my $lru_fifo_head = $fa_lines - 1;

    e_assign->adds(
        [["fa_fill_index", $fa_index_size], "fa_lru_fifo${lru_fifo_head}"],
    );


    my $ui;
    for ($ui = 0; $ui < $fa_lines; $ui++) {
        my $ui_less_one = $ui - 1;




        my $fifo_input = ($ui == $lru_fifo_tail) ? 
          "fa_fill_line_done ? fa_fill_index : D_fa_index" : "fa_lru_fifo${ui_less_one}";



        my @accept_higher_entry;
        for (my $mi = $ui; $mi < $fa_lines; $mi++) {
            if ($ui != $lru_fifo_tail) {
                push(@accept_higher_entry, "fa_lru_fifo${mi}_match");
            }
        }

        my $accept_higher_entry_expr = scalar(@accept_higher_entry > 0) ? 
          " & (" . join('|', @accept_higher_entry) . ")" :
          "";

        if ($ui != $lru_fifo_tail) {
            e_assign->adds(



              [["fa_lru_fifo${ui}_match", 1], 
                "fa_lru_fifo${ui} == (fa_fill_line_done ? fa_fill_index : D_fa_index)"],
            );
        }

        e_assign->adds(


          [["fa_fill_select${ui}", 1], 
            "fa_lru_fifo${lru_fifo_head} == $ui"],





          [["fa_lru_fifo${ui}_wr_en", 1], 
            "fa_lru_access" . $accept_higher_entry_expr],
        );

        e_register->adds(

          {out          => ["fa_lru_fifo${ui}", $lru_fifo_bits],
           in           => $fifo_input,
           enable       => "fa_lru_fifo${ui}_wr_en",
           async_value  => $ui },
        );
    }
    

    e_assign->adds(
        [["fa_fill_address", $fa_address_word_sz], "{fa_address_fixed[$fa_tag_field_msb:${fa_tag_lsb}] + buffer_fill_count[${fa_tag_lsb}],buffer_fill_offset}"],
        [["buffer_fill_en", 1], "((fa_need_fill_starting) | ((fa_readdatavalid & ~fa_prevent_fill) & buffer_fill_count !=${fill_count_max}))"],
        [["buffer_fill_offset_en", 1], "((fa_need_fill_starting) | (fa_readdatavalid & ~fa_prevent_fill))"],
        [["buffer_fill_offset_nxt", $fa_tag_lsb], "fa_need_fill_starting ? D_refetch ? D_pc[${fa_tag_lsb}-1:0] : F_pc[${fa_tag_lsb}-1:0] :
                                                   buffer_fill_count == $half_fill_count_max ? 0 :
                                                   buffer_fill_offset + 1"],
    );
    
    e_register->adds(
      {out => ["buffer_fill_count", 3],     in => "fa_need_fill_starting ? 0 : 
                                                   fa_w_nxt_hit_pending & fa_fill_line_done ? ${fill_count_max} :
                                                   buffer_fill_count + 1", 
       enable => "buffer_fill_en"},
       {out => ["buffer_fill_offset", $fa_tag_lsb],     in => "buffer_fill_offset_nxt", 
       enable => "buffer_fill_offset_en"},
    );
    

    e_assign->adds(
        [["fa_fill_line_done", 1], "(buffer_fill_count == ${half_fill_count_max} | buffer_fill_count == ${fill_count_max}) & (fa_readdatavalid & ~fa_prevent_fill)"],
        [["fa_fill_line_start", 1], "fa_need_fill_starting | (buffer_fill_count == ${half_fill_count} & fa_need_fill_active_d1 & ~fa_prevent_fill)"],
        [["fa_need_fill_active", 1], "fa_fill_line_start | (fa_need_fill_active_d1 & ~fa_fill_line_done_d1)"],
    );
    
    e_register->adds(
      {out => ["fa_need_fill_active_d1", 1],     in => "fa_need_fill_active", 
       enable => "1'b1"},
    );
    


    my @A_invalidate_index_expr;
    my @A_invalidate_any_match_expr;

    for (my $lines =0; $lines < $fa_lines ; $lines = $lines + 1) {
        e_assign->adds(
            [["A_fa_invalidate_line${lines}_match", 1], "fa_line${lines}_tag == A_inst_result[${pcb_sz}-1:${fa_tag_lsb}+2]"],
            [["fa_invalidate_line${lines}", 1], "(fa_invalidate_index == $lines) & fa_cache_line_invalidate"],
        );
        push(@A_invalidate_index_expr, "({${fa_index_size} {A_fa_invalidate_line${lines}_match}} & $lines)");
        push(@A_invalidate_any_match_expr, "A_fa_invalidate_line${lines}_match");
    }
    
    e_assign->adds(
        [["A_fa_invalidate_index", $fa_index_size], join(" | ", @A_invalidate_index_expr)],
        [["A_fa_invalidate_any_match", 1], join(" | ", @A_invalidate_any_match_expr)],
        [["A_fa_cache_line_invalidate", 1], "(A_ctrl_invalidate_i & A_valid & A_fa_invalidate_any_match)"],
    );


    e_register->adds(
      {out => ["fa_invalidate_index", $fa_index_size],     in => "A_fa_invalidate_index", 
       enable => "1'b1"},
      {out => ["fa_cache_line_invalidate", 1],     in => "A_fa_cache_line_invalidate", 
       enable => "1'b1"},
    );
    
}

1;
