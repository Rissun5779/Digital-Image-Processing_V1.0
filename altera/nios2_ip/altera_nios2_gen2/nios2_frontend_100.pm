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






















package nios2_frontend_100;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &nios2_fe100_make_frontend
);

use cpu_utils;
use cpu_wave_signals;
use cpu_file_utils;
use cpu_bit_field;
use cpu_control_reg;
use cpu_exception_gen;
use europa_all;
use europa_utils;
use nios_utils;
use nios_addr_utils;
use nios_avalon_masters;
use nios_isa;
use nios2_isa;
use nios2_insts;

use nios2_mmu;
use nios2_mpu;
use nios2_exceptions;
use nios2_common;
use nios_common;
use nios2_control_regs;
use strict;















sub 
nios2_fe100_make_frontend
{
    my $Opt = shift;

    &$progress("    Pipeline frontend");

    gen_pc($Opt);

    gen_instruction_master($Opt);

    if ($itcm_present) {
        gen_instruction_tcm_masters($Opt);
    }
    
    gen_instruction_hp_master($Opt);
    gen_instruction_word_mux($Opt);
    
    if ($mpu_present) {
        &$progress("      IMPU");
        gen_impu($Opt);
    }



    nios_brpred::gen_frontend($Opt);
}





sub 
gen_pc
{
    my $Opt = shift;

    my $oci_version = manditory_int($Opt,"oci_version");

    e_signal->adds({name => "npcb", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "master_pcb", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "master_pcb_nxt", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "F_pc", never_export => 1, width => $pch_sz});
    e_signal->adds({name => "F_pcb", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "F_iw", never_export => 1, width => $iw_sz});
    e_signal->adds({name => "F_iw_new", never_export => 1, width => $iw_sz});
    e_signal->adds({name => "F_inst_response", never_export => 1, width => 2});
    e_signal->adds({name => "F_inst_response_new", never_export => 1, width => 2});
    e_signal->adds({name => "fetch_pc_plus_two", never_export => 1, width => $pch_sz});

    e_assign->adds(["F_pcb", "{F_pc, 1'b0}"]);
    e_assign->adds(["npcb", "{npc, 1'b0}"]);
    e_assign->adds(["master_pcb", "{master_pc, 1'b0}"]);


    e_assign->adds(["F_pc", $cdx_present ? "D_imaster_kill ? D_pc :
    	         (D_issue & D_ctrl_narrow) ? D_pc_plus_one :
                 D_pc_plus_two" :
                "D_imaster_kill ? D_pc : D_pc_plus_two"]
    );
    

    e_assign->adds(["F_iw_new", "ibuf_occupied_d1 ? ibuf : master_iw"]);
    e_assign->adds(["F_inst_response_new", "ibuf_occupied_d1 ? ibuf_response : master_response"]);

    e_assign->adds(["F_iw", "{F_iw_hi,F_iw_lo}"]);

    e_assign->adds(
      [["F_iw_lo", 16], ($oci_version == 2) ? 
                        "W_debug_mode ? W_host_data_register[15:0] :
                         (D_stall | D_iw_32b_misaligned_stall | D_multiple_shift_reg_stall) ? D_iw_lo :
                         D_lower_iw_16b ? D_iw_hi_reg :
                         F_pc[0] ? F_iw_new[31:16] : 
                         F_iw_new[15:0]" :  
                        "(D_stall | D_iw_32b_misaligned_stall | D_multiple_shift_reg_stall) ? D_iw_lo :
                         D_lower_iw_16b ? D_iw_hi_reg :
                         F_pc[0] ? F_iw_new[31:16] : 
                         F_iw_new[15:0]"],
      [["F_iw_hi", 16], ($oci_version == 2) ? 
                        "W_debug_mode ? W_host_data_register[31:16] :
                         D_iw_32b_misaligned_stall  ? F_iw_new[15:0] :
                         (D_stall | D_multiple_shift_reg_stall)? D_iw_hi_reg :
                         ibuf_hi_is_32b ? ibuf_2_hi :
                         F_pc[0]  ? F_iw_new[15:0] :
                         F_iw_new[31:16]" :
                         "D_iw_32b_misaligned_stall  ? F_iw_new[15:0] :
                         (D_stall | D_multiple_shift_reg_stall)? D_iw_hi_reg :
                         ibuf_hi_is_32b ? ibuf_2_hi :
                         F_pc[0]  ? F_iw_new[15:0] :
                         F_iw_new[31:16]"],
       [["ibuf_2_hi", 16], "ibuf_occupied_2_d1 ? ibuf_2[15:0] : master_iw[15:0]"],
    );

    e_assign->adds(
      ["fetch_pc_plus_two", "fetch_pc + 2"],
    );


    e_register->adds(
      {out => ["master_pc", $pch_sz],                   in => "master_pc_nxt", 
       enable => "1'b1",
       async_value => 
         manditory_bool($Opt, "export_vectors") ? "reset_vector_word_addr" : "$reset_pch"},
      );


























                                                                                                                                                 
    e_assign->adds(
      [["master_pc_nxt", $pch_sz], "imaster_waiting ? master_pc : npc"],
      [["master_pcb_nxt", $pcb_sz], "{master_pc_nxt, 1'b0}"],
    );


    e_assign->adds(
      [["i_waiting", 1], "i_read"],
      [["ihp_waiting", 1], "ihp_read & ihp_waitrequest"],

      [["imaster_waiting", 1], "i_waiting | ihp_waiting_d1 | ~reset_sync_d1"],
    );
    e_register->adds(


      {out => ["reset_sync_d1", 1],    in => "1'b1",
       enable => "1'b1"},

      {out => ["reset_sync_d2", 1],    in => "reset_sync_d1",
       enable => "1'b1"},
      {out => ["ihp_waiting_d1", 1],   in => "ihp_waiting", 
       enable => "1'b1"},
    );


    e_register->adds(
      {out => ["ibuf", $iw_sz],      in => "ibuf_occupied_2_d1 ? ibuf_2 : master_iw", 
       enable => "ibuf_en"},
      {out => ["ibuf_response", 2],      in => "ibuf_occupied_2_d1 ? ibuf_response_2 : master_response", 
       enable => "ibuf_en"},       
      {out => ["ibuf_2", $iw_sz],      in => "master_iw", 
       enable => "~ibuf_occupied_2_d1"},
      {out => ["ibuf_response_2", 2],      in => "master_response", 
       enable => "~ibuf_occupied_2_d1"},
      {out => ["ibuf_occupied_d1", 1],  in => "ibuf_occupied",
       enable => "1'b1"},
      {out => ["ibuf_occupied_2_d1", 1],  in => "ibuf_occupied_2",
       enable => "1'b1"},
      {out => ["ibuf_going_to_full_d1", 1],  in => "ibuf_going_to_full",
       enable => "1'b1"},
       




      {out => ["last_readdata_counter", 2],  in => $ihp_present ? "ihp_pending_third_read & master_older_non_sequential & ~ihp_readdatavalid ? 2'b11 :
                                 ihp_pending_second_read & master_older_non_sequential & (~ihp_readdatavalid|ihp_pending_third_read) ? 2'b10 :
                                 ihp_pending_first_read & master_older_non_sequential ? 2'b01 :
                                 ihp_readdatavalid ? last_readdata_counter - 1 :
                                 last_readdata_counter" : "2'b0",
       enable => "imaster_kill"}, 
    );   

    my $narrow_signal = $cdx_present ? " & ~D_ctrl_narrow" : "";
    e_assign->adds(
      [["ihp_last_readdata_from_pending_read", 1], "(last_readdata_counter == 1) & ihp_readdatavalid"],
      




      [["ibuf_occupied", 1], "(((D_stall | D_lower_iw_16b | D_iw_32b_misaligned_stall | D_multiple_shift_reg_stall) & (imaster_data_arrived|ibuf_occupied_d1)) | (imaster_data_arrived & ibuf_occupied_d1)  | ibuf_occupied_2_d1) & ~ibuf_kill"],
      




      [["ibuf_occupied_2", 1], "((((ibuf_occupied_d1 & imaster_data_arrived) | ibuf_occupied_2_d1) & (D_stall | D_lower_iw_16b | D_iw_32b_misaligned_stall | D_multiple_shift_reg_stall))) & ~ibuf_kill"],
      

      [["ibuf_going_to_full", 1], "(ibuf_occupied & ihp_pending_second_read)"],
      
      [["ibuf_full", 1], "ibuf_occupied_2 | ibuf_going_to_full_d1 | ibuf_going_to_full"],
      





      [["ibuf_en", 1], "~ibuf_occupied_d1 | (~(D_stall | D_lower_iw_16b | D_iw_32b_misaligned_stall | D_multiple_shift_reg_stall) & (ibuf_occupied_2_d1 | (ibuf_occupied_d1 & imaster_data_arrived)))"],
      
      [["ibuf_hi_is_32b", 1], "~(~(ibuf[18] & ibuf[17]) & ibuf[16]) & ibuf_occupied_d1 & D_pc[0]" . $narrow_signal ],
    );


    e_assign->adds(

      [["imaster_data_arrived", 1], "(i_readdata_arrived & master_pc_sel_instruction_master) | (ihp_readdata_arrived & master_pc_sel_instruction_master_high_performance) | (master_pc_sel_itcm & reset_sync_d2)"],
      

      [["imaster_data_issued", 1], "imaster_data_arrived"],
    );
    


    e_assign->adds(

      [["F_inst_response", 2], ($oci_version == 2) ? 
           "(D_stall | D_iw_32b_misaligned_stall | D_multiple_shift_reg_stall | D_lower_iw_16b | W_debug_mode) ? 2'b00 :
            F_inst_response_new" :  
           "(D_stall | D_iw_32b_misaligned_stall | D_multiple_shift_reg_stall | D_lower_iw_16b) ? 2'b00 :
            F_inst_response_new"],
    );

    e_register->adds(
      {out => ["D_inst_response", 2], 
       in => "F_inst_response",                      enable => "D_en"},
    );
    
    new_exc_signal({
            exc             => $bus_inst_fetch_error_exc,
            initial_stage   => "D", 
            rhs             => "D_inst_response != 0",
    });
}








sub 
gen_instruction_master
{
    my $Opt = shift;

    my $oci_version = manditory_int($Opt,"oci_version");

    $Opt->{instruction_master}{port_map} = {
      i_readdata      => "readdata",
      i_address       => "address",
      i_read          => "read",
      i_waitrequest   => "waitrequest",
      i_response      => "response",
    };

    my $instruction_master_baddr_sz = $Opt->{instruction_master}{Address_Width};
    my $instruction_master_waddr_sz = $instruction_master_baddr_sz - 2;

    push(@{$Opt->{port_list}},

      [i_readdata       => $iw_sz,                          "in" ],
      [i_waitrequest    => 1,                               "in" ],
      [i_response       => 2,                               "in" ],
      [i_address        => $instruction_master_baddr_sz,    "out"],
      [i_read           => 1,                               "out"],
    );


    if (manditory_bool($Opt, "hbreak_test")) {
        my $data_master_interrupt_sz = 
          manditory_int($Opt, "data_master_interrupt_sz");

        $Opt->{instruction_master}{port_map}{test_hbreak_req} = "irq";

        push(@{$Opt->{port_list}},

          [test_hbreak_req  => $data_master_interrupt_sz,  "in" ],
        );
    }

    e_register->adds(
      {out => ["i_read", 1],                                    in => "i_read_nxt",
      enable => "1'b1"},
      {out => ["i_readdata_arrived", 1],                        in => "i_readdata_arrived_nxt",
      enable => "1'b1"},
      {out => ["i_readdata_d1", 32],                            in => "i_readdata",
      enable => "1'b1"},
      {out => ["i_response_d1", 2],                             in => "i_response",
      enable => "1'b1"},
      
    );



    
    e_assign->adds(




      [["i_read_starting", 1], ($oci_version == 2) ? "master_pc_nxt_sel_instruction_master & ~i_read & ~ibuf_full & reset_sync_d1 & ~fetch_inst_cancel" :
                                                     "master_pc_nxt_sel_instruction_master & ~i_read & ~ibuf_full & reset_sync_d1"],


      [["i_readdata_arrived_nxt", 1], "i_read & ~i_waitrequest"],



      [["i_read_nxt", 1], "i_read_starting | (i_read & i_waitrequest)"],
    );
    
    if ($instruction_master_baddr_sz > 1) {
        e_assign->adds(       
          [["i_address", $instruction_master_baddr_sz], "{master_pcb[$instruction_master_baddr_sz-1:2],2'b00}"],
        );
    } else {
        e_assign->adds(       
          [["i_address", 1], "1'b0"],
        );
    }

    my @instruction_master_waves = (
      { divider => "instruction_master" },
      { radix => "x", signal => "i_read" },
      { radix => "x", signal => "i_address" },
      { radix => "x", signal => "i_waitrequest" },
      { radix => "x", signal => "i_response" },
    );

    push(@instruction_master_waves,
      { radix => "x", signal => "i_read_starting" },
    );      

    push(@plaintext_wave_signals, @instruction_master_waves);
}





sub
gen_instruction_tcm_masters
{
    my $Opt = shift;

    if (!$itcm_present) {
        &$error(
          "Called when no instruction tightly-coupled masters are present");
    }

    my $num_tightly_coupled_instruction_masters =
      manditory_int($Opt, "num_tightly_coupled_instruction_masters");

    for (my $cmi = 0; $cmi < $num_tightly_coupled_instruction_masters; $cmi++) {
        gen_one_tightly_coupled_instruction_master($Opt, $cmi);
    }
}

sub 
gen_one_tightly_coupled_instruction_master
{
    my $Opt = shift;
    my $cmi = shift;

    my $whoami = "Tightly-coupled instruction master";

    my $fetch_npcb = not_empty_scalar($Opt, "fetch_npcb");
    my $fetch_npc = not_empty_scalar($Opt, "fetch_npc");

    check_opt_value($Opt, "inst_ram_output_stage", "F", $whoami);

    my $master_name = "tightly_coupled_instruction_master_${cmi}";
    my $slave_addr_width = 
      manditory_int($Opt->{$master_name}, "Slave_Address_Width");
    my $avalon_addr_width = 
      manditory_int($Opt->{$master_name}, "Address_Width");














    my $pc_expr;

    if ($slave_addr_width < $avalon_addr_width) {


        my $top_bits = not_empty_scalar($Opt->{$master_name}, "Paddr_Base_Top_Bits");

        $pc_expr = "{ $top_bits, ${fetch_npcb}[$slave_addr_width-1:0] }";
    } else {
        $pc_expr = "${fetch_npcb}[$avalon_addr_width-1:0]";
    }


    e_assign->adds(
    	["itcm${cmi}_address", "{${avalon_addr_width}{reset_sync_d1}} & " . $pc_expr],
    );


    e_assign->adds(
       ["itcm${cmi}_read", "1'b1"],
    );


    e_assign->adds(
      ["itcm${cmi}_clken", "1'b1"],
    );

    $Opt->{$master_name}{port_map} = {
      "itcm${cmi}_readdata"       => "readdata",
      "itcm${cmi}_response"       => "response",
      "itcm${cmi}_address"        => "address",
      "itcm${cmi}_read"           => "read",
      "itcm${cmi}_clken"          => "clken",
    };

    $Opt->{$master_name}{sideband_signals} = [
      "clken",
    ];
    
    push(@{$Opt->{port_list}},
      ["itcm${cmi}_readdata"      => $datapath_sz,            "in" ],
      ["itcm${cmi}_response"      => 2,                       "in" ],
      ["itcm${cmi}_address"       => $avalon_addr_width,      "out"],
      ["itcm${cmi}_read"          => 1,                       "out"],
      ["itcm${cmi}_clken"         => 1,                       "out"],
    );
}






sub
gen_instruction_hp_master
{
    my $Opt = shift;

    my $whoami = "High-Performance instruction master";

    my $fetch_npcb = "master_pcb_nxt";
    my $fetch_npc = "master_pc_nxt";
    my $oci_version = manditory_int($Opt,"oci_version");

    check_opt_value($Opt, "inst_ram_output_stage", "F", $whoami);

    my $master_name = "instruction_master_high_performance";

    if ($ihp_present) {
      my $slave_addr_width = 
        manditory_int($Opt->{$master_name}, "Slave_Address_Width");
      my $avalon_addr_width = 
        manditory_int($Opt->{$master_name}, "Address_Width");


        my $pc_expr;
        
        if ($slave_addr_width < $avalon_addr_width) {


            my $top_bits = not_empty_scalar($Opt->{$master_name}, "Paddr_Base_Top_Bits");
            $pc_expr = "{ $top_bits, ${fetch_npcb}[$slave_addr_width-1:2], 2'b00 }";
        } else {
            $pc_expr = "{${fetch_npcb}[$avalon_addr_width-1:2], 2'b00}";
        }
        
        e_assign->adds(
          ["ihp_address", $pc_expr],
        );
               
        $Opt->{$master_name}{port_map} = {
          "ihp_readdata"       => "readdata",
          "ihp_waitrequest"    => "waitrequest",
          "ihp_response"       => "response",
          "ihp_readdatavalid"  => "readdatavalid",
          "ihp_address"        => "address",
          "ihp_read"           => "read",
        };
        
        push(@{$Opt->{port_list}},
          ["ihp_readdata"      => $datapath_sz,            "in" ],
        );
        
        push(@{$Opt->{port_list}},
          ["ihp_waitrequest"   => 1,                       "in" ],
          ["ihp_response"      => 2,                       "in" ],
          ["ihp_readdatavalid" => 1,                       "in" ],
          ["ihp_address"       => $avalon_addr_width,      "out"],
          ["ihp_read"          => 1,                       "out"],
        );
           
        e_assign->adds(


          [["ihp_read", 1], ($oci_version == 2) ? "master_pc_nxt_sel_instruction_master_high_performance & ~ihp_read_cancel & reset_sync_d1 & ~fetch_inst_cancel | ihp_waiting_d1" :
                                                  "master_pc_nxt_sel_instruction_master_high_performance & ~ihp_read_cancel & reset_sync_d1 | ihp_waiting_d1" ],


          [["ihp_readdata_arrived", 1], "ihp_readdatavalid"],


          [["ihp_read_starting", 1], ($oci_version == 2) ? "master_pc_nxt_sel_instruction_master_high_performance & ~ihp_waiting_d1 & ~ihp_read_cancel & reset_sync_d1 & ~fetch_inst_cancel" :
                                                           "master_pc_nxt_sel_instruction_master_high_performance & ~ihp_waiting_d1 & ~ihp_read_cancel & reset_sync_d1"],
        );

        e_register->adds(



          {out => ["ihp_pending_first_read", 1],   in => "ihp_readdatavalid ? ihp_read_starting : 
                                                          ihp_read_starting ? 1'b1 :
                                                          ihp_pending_first_read", 
           enable => "~ihp_pending_second_read",},
          {out => ["ihp_pending_second_read", 1],   in => "ihp_pending_second_read ? (ihp_read_starting | ~ihp_readdatavalid) : (ihp_read_starting & ~ihp_readdatavalid)", 
           enable => "ihp_pending_first_read & ~ihp_pending_third_read",},
          {out => ["ihp_pending_third_read", 1],   in => "ihp_pending_third_read ? (ihp_read_starting | ~ihp_readdatavalid) : (ihp_read_starting & ~ihp_readdatavalid)", 
           enable => "ihp_pending_second_read",},
        );
        e_assign->adds(



          [["ihp_read_cancel", 1], "(ibuf_full | ihp_pending_third_read)"],
          [["ihp_pending_read_stall", 1], "ihp_pending_third_read & master_pc_sel_instruction_master_high_performance"],
        );
    } else {     
        $Opt->{$master_name}{port_map} = {
          "ihp_readdata"       => "readdata",
          "ihp_waitrequest"    => "waitrequest",
          "ihp_response"       => "response",
          "ihp_readdatavalid"  => "readdatavalid",
          "ihp_address"        => "address",
          "ihp_read"           => "read",
        };
        
        push(@{$Opt->{port_list}},
          ["ihp_readdata"      => $datapath_sz,            "in" ],
        );
        
        push(@{$Opt->{port_list}},
          ["ihp_waitrequest"   => 1,                       "in" ],
          ["ihp_response"      => 2,                       "in" ],
          ["ihp_readdatavalid" => 1,                       "in" ],
          ["ihp_address"       => 1,                       "out"],
          ["ihp_read"          => 1,                       "out"],
        );
        
        e_assign->adds(
          [["ihp_address", 1], "1'b0"],
          [["ihp_read", 1], "1'b0"],
          [["ihp_readdata_arrived", 1], "1'b0"],
          [["ihp_read_starting", 1], "1'b0"],
          [["ihp_pending_first_read", 1], "1'b0"],
          [["ihp_pending_second_read", 1], "1'b0"],
          [["ihp_pending_read_stall", 1], "1'b0"],
        ); 
    }
}








sub 
gen_instruction_word_mux
{
    my $Opt = shift;


    my $cmp_pcb_sz = manditory_int($Opt, "i_Address_Width");

    my $avalon_master_info = manditory_hash($Opt, "avalon_master_info");


    my @sel_signals = make_master_address_decoder({
      avalon_master_info    => $avalon_master_info,
      normal_master_name    => "instruction_master",
      tightly_coupled_master_names => manditory_array($avalon_master_info,
        "avalon_tightly_coupled_instruction_master_list"), 
      high_performance_master_names => manditory_array($avalon_master_info,
        "avalon_instruction_master_high_performance_list"),
      flash_accelerator_master_names => manditory_array($avalon_master_info,
        "avalon_instruction_master_high_performance_list"), 
      addr_signal           => "master_pcb_nxt[$cmp_pcb_sz-1:0]", 
      addr_sz               => $cmp_pcb_sz, 
      sel_prefix            => "master_pc_nxt_sel_",
      mmu_present           => 0,
      fa_present            => 0,
      master_paddr_mapper_func => \&nios2_mmu::master_paddr_mapper,
    });
    

    if (!$ihp_present) {
        e_assign->adds(
            [["master_pc_nxt_sel_instruction_master_high_performance",1], "1'b0"],
        );
    }


    e_register->adds(
      {out => ["master_pc_sel_instruction_master_high_performance", 1], in => "master_pc_nxt_sel_instruction_master_high_performance",
       enable => "1'b1"},
      {out => ["master_pc_sel_instruction_master", 1], in => "master_pc_nxt_sel_instruction_master",
       enable => "1'b1"},
    );






    my @iw_mux_table;
    my @response_mux_table;


    if ($ihp_present) {
        push(@iw_mux_table, "master_pc_sel_instruction_master_high_performance" => "ihp_readdata");
        push(@response_mux_table, "master_pc_sel_instruction_master_high_performance" => "ihp_response");
    }


    push(@iw_mux_table, "master_pc_sel_instruction_master" => "i_readdata_d1");
    push(@response_mux_table, "master_pc_sel_instruction_master" => "i_response_d1");
    
    for (my $cmi = 0; 
      $cmi < manditory_int($Opt, "num_tightly_coupled_instruction_masters");
      $cmi++) {
        my $master_name = "tightly_coupled_instruction_master_${cmi}";
        my $sel_name = "master_pc_sel_" . $master_name;
        my $data_name = "itcm${cmi}_readdata";
        my $response_name = "itcm${cmi}_response";
    
        if ($cmi == (manditory_int($Opt, 
          "num_tightly_coupled_instruction_masters") - 1)) {
            push(@iw_mux_table,
              "1'b1" => $data_name);
            push(@response_mux_table,
              "1'b1" => $response_name);
        } else {
            push(@iw_mux_table,
              $sel_name => $data_name);
            push(@response_mux_table,
              $sel_name => $response_name);
        }
    }

    my $instruction_word = $big_endian ? "master_iw_be" : "master_iw";
    e_mux->add ({
      lhs => [$instruction_word, $datapath_sz],
      type => "priority",
      table => \@iw_mux_table,
    });
   
    if ($big_endian) {

        e_assign->adds(
            [["master_iw", 32], "{master_iw_be[7:0],master_iw_be[15:8],master_iw_be[23:16],master_iw_be[31:24]}"],
        );
    }


    e_mux->add ({
      lhs => ["master_response", 2],
      type => "priority",
      table => \@response_mux_table,
    });
    
    if (scalar(@sel_signals) > 1) {
        push(@plaintext_wave_signals, 
            { divider => "instruction_master_sel" },
        );

        foreach my $sel_signal (@sel_signals) {
            push(@plaintext_wave_signals, 
              { radix => "x", signal => $sel_signal },
            );
        }
    }
}




sub 
gen_impu
{
    my $Opt = shift;

    my $cs = not_empty_scalar($Opt, "control_reg_stage");


    e_mux->add ({
      lhs => ["E_impu_good_perm", 1],
      selecto => "E_impu_perm",
      table => [
        $mpu_inst_perm_super_none_user_none => "0",
        $mpu_inst_perm_super_exec_user_none => "~${cs}_status_reg_u",
        $mpu_inst_perm_super_exec_user_exec => "1",
        ],
      default => "0",
    });






    my @impu_exc_conds = ("~E_impu_hit", "~E_impu_good_perm");


    my $unused_pc_msb = 30;
    my $unused_pc_lsb = manditory_int($Opt, "i_Address_Width") - 1;
    my $unused_pc_sz = $unused_pc_msb - $unused_pc_lsb + 1;

    if ($unused_pc_sz > 0) {
        push(@impu_exc_conds, "(E_pc[$unused_pc_msb:$unused_pc_lsb] != 0)");
    }

    new_exc_signal({
        exc             => $mpu_inst_region_violation_exc,
        initial_stage   => "E", 
        rhs             => 
          "${cs}_config_reg_pe & ~W_debug_mode & " .
          "(" . join('|', @impu_exc_conds) . ")",
    });


    my $impu_region_wave_signals = nios2_mpu::make_mpu_regions($Opt, 0);









    push(@plaintext_wave_signals, 
      @$impu_region_wave_signals,
      { divider => "IMPU Exceptions" },
      get_exc_signal_wave($mpu_inst_region_violation_exc, "E"),
    );
}

1;
