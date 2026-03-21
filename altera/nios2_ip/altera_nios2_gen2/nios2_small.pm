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






















package nios2_small;

use cpu_utils;
use cpu_wave_signals;
use cpu_inst_gen;
use cpu_exception_gen;
use cpu_control_reg_gen;
use europa_all;
use europa_utils;
use nios_europa;
use nios_brpred;
use nios_avalon_masters;
use nios_common;
use nios_isa;
use nios_icache;
use nios_dcache;
use nios_mul;
use nios_div;
use nios_shift_rotate;
use nios2_control_regs;
use nios2_insts;
use nios2_exceptions;
use nios2_common;
use nios2_frontend_100;
use nios2_backend_400;
use nios2_backend;
use nios2_custom_insts;
use nios2_oci;
use nios2_third_party_debugger_gasket;

use strict;


















sub
get_core_funcs
{
    return {
      get_gen_info_stages   => \&get_gen_info_stages,
      make_cpu              => \&make_cpu,
      make_exc              => \&make_exc,
    };
}


sub
get_gen_info_stages
{
    return ["F", "D", "E", "M", "A", "W"];
}

sub 
make_cpu
{
    my ($Opt, $top_module) = @_;

    my $marker = e_default_module_marker->new($top_module);

    if (manditory_scalar($Opt, "branch_prediction_type") eq "") {
        $Opt->{branch_prediction_type} = $DYNAMIC_BRPRED;
    }

    set_pipeline_description($Opt);
    be_set_control_reg_pipeline_desc($Opt);

    my $testbench_submodule = nios2_be400_make_testbench($Opt);
    e_signal->adds({name => "test_ending", never_export => 1, width => 1});
    e_signal->adds({name => "test_has_ended", never_export => 1, width => 1});

    make_inst_decode($Opt);

    make_small_pipeline($Opt, $testbench_submodule);

    nios2_fe100_make_frontend($Opt);
    nios2_be400_make_backend($Opt);

    if ($perf_cnt_present) {
        make_perf_cnt($Opt);
    }

    if ($oci_present) {
        make_nios2_oci($Opt, $top_module);

    } elsif ($third_party_debug_present) {
        make_nios2_third_party_debugger_gasket($Opt, $top_module);
    }
}



sub 
make_exc
{
    my $Opt = shift;

    my $exc_stages = manditory_array($Opt, "exc_stages");

    my @extra_exc_info_wave_signals;


    gen_exception_signals($Opt->{gen_info}, $exc_stages);

    my @exc_stages_array = @$exc_stages;
    my $last_stage = $exc_stages_array[$#exc_stages_array];

    if ($last_stage ne "A") {
        &$error("last_stage must be A");
    }


    my $cause_mux_table = gen_exception_cause_code("A");
    my $cause_code_signal = "A_exc_highest_pri_cause_code";

    if (scalar(@$cause_mux_table)) {

        e_mux->add ({
          lhs => [$cause_code_signal, $exception_reg_cause_sz],
          type => "priority",
          table => $cause_mux_table,
        });
    } else {

        e_assign->adds(
          [[$cause_code_signal, $exception_reg_cause_sz], "0"],
        );
    }


    my $exc_id_mux_table = gen_exception_id("A");
    my $exc_id_signal = "A_exc_highest_pri_exc_id";
    
    if (scalar(@$exc_id_mux_table)) {

        e_mux->add ({
          lhs => [$exc_id_signal, 32],
          type => "priority",
          table => $exc_id_mux_table,
        });
    } else {

        e_assign->adds(
          [[$exc_id_signal, 32], "0"],
        );
    }


    my ($baddr_mux_table, $baddr_record_signals) = 
      gen_exception_baddr("A");

    my $baddr_addr_signal = "A_exc_highest_pri_baddr";
    my $baddr_record_signal = "A_exc_record_baddr";







    
    if ($mpu_present && $cdx_present) {
        my $sel_signal = get_exc_signal_name($mpu_inst_region_violation_exc, "A");
        my $addr_signal = "A_pcb";

        unshift(@$baddr_mux_table, $sel_signal => $addr_signal);
        unshift(@$baddr_record_signals, $sel_signal);
    } 


    my $data_read_error_signal = "A_bus_data_read_error";
    my $data_read_addr_signal = "A_mem_baddr";
    unshift(@$baddr_mux_table, $data_read_error_signal => $data_read_addr_signal);
    unshift(@$baddr_record_signals, $data_read_error_signal);


    e_mux->add ({
      lhs => [$baddr_addr_signal, $badaddr_reg_baddr_sz],
      type => "priority",
      table => $baddr_mux_table,
    });


    e_assign->adds(
      [[$baddr_record_signal, 1], 
        "A_exc_allowed & " .
        "(" . join('|', @$baddr_record_signals) . ")"],
    );

    my @extra_exc_info_wave_signals = (
      { divider => "extra_exc_info" },
      { radix => "d", signal => $cause_code_signal },
      { radix => "x", signal => $baddr_addr_signal },
      { radix => "x", signal => $baddr_record_signal },
    );

    if (scalar(@extra_exc_info_wave_signals)) {
        push(@plaintext_wave_signals, @extra_exc_info_wave_signals);
    }
}







sub set_pipeline_description
{
    my $Opt = shift;


    $Opt->{stages} = ["F", "D", "E", "M", "A", "W"];


    $Opt->{exc_stages} = ["D", "E", "M", "A"];


    $Opt->{dispatch_stage} = "F";


    $Opt->{fetch_npc} = "npc";


    $Opt->{fetch_npcb} = "npcb";


    $Opt->{brpred_table_output_stage} = "F";



    $Opt->{inst_ram_output_stage} = "F";


    $Opt->{ic_fill_stage} = "D";


    $Opt->{cache_operation} = "((A_ctrl_invalidate_i & A_valid) | A_exc_crst_active)";


    $Opt->{cache_operation_baddr} = "A_inst_result";


    $Opt->{inst_crst} = "A_exc_crst_active";


    $Opt->{crst_taken} = "A_exc_crst_active";


    $Opt->{bht_wr_data} = "M_bht_wr_data_filtered";
    $Opt->{bht_wr_en} = "M_bht_wr_en_filtered";
    $Opt->{bht_wr_addr} = "M_bht_ptr_filtered";
    $Opt->{bht_br_cond_taken_history} = "M_br_cond_taken_history";


    $Opt->{rf_a_field_name} = "a";


    $Opt->{rf_b_field_name} = "b";



    $Opt->{current_register_set} = "W_status_reg_crs";
    $Opt->{previous_register_set} = "W_status_reg_prs";


    $Opt->{add_br_to_taken_history} = "E_add_br_to_taken_history_filtered";



    $Opt->{brpred_prediction_stage} = "D";


    $Opt->{brpred_resolution_stage} = "E";


    $Opt->{brpred_mispredict_stage} = "M";


    $Opt->{brpred_mispredict_reset} = "0";


    $Opt->{rdctl_stage} = "M";



    $Opt->{wrctl_setup_stage} = "A";


    $Opt->{wrctl_data} = "A_inst_result";


    $Opt->{control_reg_stage} = "W";


    $Opt->{ci_combo_stage} = "E";


    $Opt->{ci_multi_stage} = "M";


    $Opt->{divider_input_stage} = "E";



    $Opt->{non_pipelined_long_latency_input_stage} = "M";



    $Opt->{long_latency_output_stage} = "E";



    $Opt->{le_fast_shift_rot_cycles} = 1;


    
    $Opt->{le_fast_shift_rot_shfcnt} = $bmx_present? "(E_ctrl_bmx ? (~{5{E_op_merge}} & E_iw_bmx_lsb) : E_src2[4:0])" : "E_src2[4:0]";


    $Opt->{le_fast_shift_data} = "E_src1";


    $Opt->{le_medium_shift_rot_shfcnt} = "E_src2[4:0]";
    $Opt->{le_small_shift_rot_shfcnt} = "M_src2[4:0]";


    $Opt->{mul_cell_pipelined} = "1";


    $Opt->{div_done} = "A_div_done";


    $Opt->{data_master_interrupt_sz} = 32;
   

    $Opt->{bmx_s} = "M";
}








sub make_small_pipeline
{
    my ($Opt, $testbench_submodule) = @_;



























    e_mux->add ({
      lhs => ["npc", $pch_sz],
      type => "priority",
      table => [
        "A_pipe_flush"                  => "A_pipe_flush_haddr",
        "E_br_mispredict"               => "E_extra_pc",
        "E_valid_jmp_indirect"          => "E_valid_jmp_indirect_haddr",
        "D_br_pred_taken & D_valid"     => "D_br_taken_haddr",
        "D_ctrl_jmp_direct & D_valid"   => "D_jmp_direct_target_haddr",
        "imaster_stall"                 => "fetch_pc",
        "1'b1"                          => "fetch_pc_plus_two",
        ],
      });





    my $oci_version = manditory_int($Opt, "oci_version");

    my $imaster_kill_d1_stall = "imaster_transition";    
    if ($itcm_present) {
       $imaster_kill_d1_stall = "(~master_pc_sel_itcm & imaster_transition)"; 
    }



    if ($oci_version == 2 & !$oci_present) {
    	 e_assign->adds(
    	   [["fetch_inst_cancel", 1], "1'b0" ],
    	 );
    }


    my $oci_version_2_inst_valid = ($oci_version == 2) & $oci_present ? "| host_data_reg_valid" : "";
    my $oci_version_2_pending_flush_cancel = ($oci_version == 2) & $oci_present ? "| W_debug_mode" : "";
    my $oci_version_2_disable_itcm = ($oci_version == 2) & $oci_present ? " & ~fetch_inst_cancel" : "";

    e_assign->adds(    

      [["master_pc_sel_itcm", 1], "~(master_pc_sel_instruction_master | master_pc_sel_instruction_master_high_performance)" . $oci_version_2_disable_itcm],





      [["imaster_iw_valid", 1], 
          "~W_exc_crst_active & imaster_data_issued"
      ],
      [["ibuf_iw_valid", 1], 
          "~W_exc_crst_active & ibuf_occupied_d1"
      ],









      [["master_older_non_sequential", 1], 
        "(D_br_pred_taken & D_valid) |
         (D_multiple_jmp_indirect & D_valid) |
         (D_ctrl_uncond_cti_non_br & D_valid) |
         E_valid_jmp_indirect |
         E_br_mispredict |
         M_pipe_flush"],




      
      [["imaster_kill", 1], "master_older_non_sequential | imaster_pending_flush" . $oci_version_2_pending_flush_cancel],
      [["ibuf_kill", 1], "master_older_non_sequential | imaster_pending_flush" . $oci_version_2_pending_flush_cancel],




      [["F_issue", 1], "((imaster_iw_valid & ~imaster_kill) | (ibuf_iw_valid & ~ibuf_kill)
                        | (D_lower_iw_16b & ~imaster_kill))" . $oci_version_2_inst_valid],
     





      [["imaster_stall", 1], "imaster_waiting|" . $imaster_kill_d1_stall . "|ihp_pending_read_stall|ibuf_full|ihp_non_sequential_stall"],
    );

    e_register->adds(





      {out => ["imaster_pending_flush", 1],  in => "(master_older_non_sequential & (imaster_waiting| ihp_pending_second_read | (ihp_pending_first_read & ~ihp_readdatavalid))) ? 1'b1 : 
                                                    (ihp_last_readdata_from_pending_read | i_readdata_arrived | master_pc_sel_itcm)? 1'b0 : 
                                                     imaster_pending_flush", 
       enable => "1'b1"},



      {out => ["imaster_transition", 1],  in => "(i_waiting | ibuf_kill) & imaster_kill & master_pc_nxt_sel_instruction_master", 
       enable => "1'b1"},
      {out => ["ihp_non_sequential_stall", 1],  in => "(~ihp_read_starting & master_older_non_sequential & master_pc_nxt_sel_instruction_master_high_performance) ? 1'b1 :
                                            ihp_waiting_d1 ? ihp_non_sequential_stall :
                                            1'b0", 
       enable => "1'b1"},
       

      {out => ["fetch_pc", $pch_sz],                   in => "npc",
       enable => "1'b1",
       async_value => 
         manditory_bool($Opt, "export_vectors") ? "reset_vector_word_addr" : "$reset_pch - 2"},
    );







    e_register->adds(
      {out => ["D_issue", 1],                   in => "F_issue | D_multiple_shift_reg_stall",  
       enable => "D_en"},
      );





    my $br_sex = $imm16_sex_waddr_sz + 2;
    e_assign->adds(

      [["D_br_offset_sex", $pch_sz], 
         ($br_sex > 0) ? "{{$br_sex {D_iw_imm16[15]}}, D_iw_imm16[15:1]}" 
                                   : "D_iw_imm16[$pch_sz:1]" ],
      [["D_br_32b_haddr", $pch_sz], 
         "D_pc_plus_two + D_br_offset_sex"],
    );

    if ($cdx_present) {
        my $br_10_sex = $pch_sz - 10;
        my $br_7_sex = $pch_sz - 7;
        e_assign->adds(

          [["D_br_imm10_offset_sex", $pch_sz], 
             ($br_10_sex > 0) ? "{{$br_10_sex {D_iw_i10_imm10[9]}}, D_iw_i10_imm10[9:0]}" 
                              : "{D_iw_i10_imm10[$pch_sz:0]}" ],
          [["D_br_imm7_offset_sex", $pch_sz], 
             ($br_7_sex > 0) ? "{{$br_7_sex {D_iw_t1i7_imm7[6]}}, D_iw_t1i7_imm7[6:0]}" 
                              : "{D_iw_t1i7_imm7[$pch_sz:0]}" ],
          [["D_br_16b_offset_sex", $pch_sz], "D_op_br_n ? D_br_imm10_offset_sex : D_br_imm7_offset_sex" ],
          [["D_br_16b_haddr", $pch_sz], 
             "D_pc_plus_one + D_br_16b_offset_sex" ],
        );
    }

    e_assign->adds(


      [["D_br_taken_haddr", $pch_sz], 
         $cdx_present ? "D_ctrl_narrow ? D_br_16b_haddr : D_br_32b_haddr" : "D_br_32b_haddr"],
    );


    e_signal->adds({name => "D_br_taken_baddr", never_export => 1, 
      width => $pch_sz+1});
    e_assign->adds(["D_br_taken_baddr", "{D_br_taken_haddr, 1'b0}"]);

    e_register->adds(
      {out => ["E_br_taken_baddr", $pcb_sz, 0, $force_never_export], 
       in => "D_br_taken_baddr",  enable => "E_en"},
      {out => ["M_br_taken_baddr", $pcb_sz, 0, $force_never_export], 
       in => "E_br_taken_baddr",  enable => "M_en"},
      {out => ["A_br_taken_baddr", $pcb_sz, 0, $force_never_export], 
       in => "M_br_taken_baddr",  enable => "A_en"},
      {out => ["W_br_taken_baddr", $pcb_sz, 0, $force_never_export], 
       in => "A_br_taken_baddr",  enable => "1'b1"},
    );






    my @pipeline_wave_signals = (
        { divider => "base pipeline" },
        { radix => "x", signal => "clk" },
        { radix => "x", signal => "reset_n" },
        { radix => "x", signal => "D_stall" },
        { radix => "x", signal => "A_stall" },
        { radix => "x", signal => "npcb" },
        { radix => "x", signal => "F_pcb" },
        { radix => "x", signal => "D_pcb" },
        { radix => "x", signal => "E_pcb" },
        { radix => "x", signal => "M_pcb" },
        { radix => "x", signal => "A_pcb" },
        { radix => "x", signal => "W_pcb" },
        { radix => "a", signal => "F_vinst" },
        { radix => "a", signal => "D_vinst" },
        { radix => "a", signal => "E_vinst" },
        { radix => "a", signal => "M_vinst" },
        { radix => "a", signal => "A_vinst" },
        { radix => "a", signal => "W_vinst" },
        { radix => "x", signal => "F_iw_avail" },
        { radix => "x", signal => "imaster_data_issued" },
        { radix => "x", signal => "F_issue" },
        { radix => "x", signal => "imaster_kill" },
        { radix => "x", signal => "ibuf_kill" },
        { radix => "x", signal => "D_issue" },
        { radix => "x", signal => "D_valid" },
        { radix => "x", signal => "D_rdprs_stall" },
        { radix => "x", signal => "D_rdprs_stall_done" },
        { radix => "x", signal => "E_valid" },
        { radix => "x", signal => "M_valid" },
        { radix => "x", signal => "A_valid" },
        { radix => "x", signal => "W_valid" },
        { radix => "x", signal => "W_wr_dst_reg" },
        { radix => "x", signal => "W_dst_regnum" },
        { radix => "x", signal => "W_wr_data" },
        { radix => "x", signal => "D_en" },
        { radix => "x", signal => "E_en" },
        { radix => "x", signal => "M_en" },
        { radix => "x", signal => "A_en" },
        { radix => "x", signal => "F_iw" },
        { radix => "x", signal => "D_iw" },
        { radix => "x", signal => "E_iw" },
        { radix => "x", signal => "M_pipe_flush" },
        { radix => "x", signal => "A_pipe_flush" },
        { radix => "x", signal => "A_pipe_flush_baddr" },
        { radix => "x", signal => 
          $eic_present ? "ext_intr_req" : "norm_intr_req"},
        @{get_control_regs_for_waves($Opt->{control_regs})},
        { divider => "npc" },
        { radix => "x", signal => "A_pipe_flush" },
        { radix => "x", signal => "A_pipe_flush_baddr" },
        { radix => "x", signal => "M_pipe_flush" },
        { radix => "x", signal => "D_pcb" },
        { radix => "x", signal => "D_br_pred_taken" },
        { radix => "x", signal => "D_br_taken_baddr" },
        { radix => "x", signal => "E_valid_jmp_indirect" },
        { radix => "x", signal => "E_src1" },
        { radix => "x", signal => "D_ctrl_jmp_direct" },
        { radix => "x", signal => "D_jmp_direct_target_baddr" },
        { radix => "x", signal => "npcb" },
    );

    push(@plaintext_wave_signals, @pipeline_wave_signals);
}







sub make_inst_decode
{
    my $Opt = shift;

    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");

    my $r1 = ($cpu_arch_rev == 1);
    my $r2 = ($cpu_arch_rev == 2);

    &$progress("    Instruction decoding");





    my $gen_info = manditory_hash($Opt, "gen_info");




    &$progress("      Instruction fields");
    cpu_inst_gen::gen_inst_fields($gen_info, $Opt->{inst_field_info},
      ["D", "E", "M", "A", "W"]);





    &$progress("      Instruction decodes");
    cpu_inst_gen::gen_inst_decodes($gen_info, $Opt->{inst_desc_info},
      ["D", "E", "M", "A", "W"]);




    &$progress("      Signals for RTL simulation waveforms");
    cpu_inst_gen::create_sim_wave_inst_names($gen_info, $Opt->{inst_desc_info},
      ["D", "E", "M", "A", "W"]);




    cpu_inst_gen::create_sim_wave_vinst_names($gen_info, $Opt->{inst_desc_info},
      ["D", "E", "M", "A", "W"],
      {},       # Default inst signal names
      { D => "D_issue" });

    &$progress("      Instruction controls");

    set_inst_ctrl_initial_stage($a_not_src_ctrl, "D");
    set_inst_ctrl_initial_stage($b_not_src_ctrl, "D");
    set_inst_ctrl_initial_stage($b_is_dst_ctrl, "D");
    set_inst_ctrl_initial_stage($ignore_dst_ctrl, "D");
    set_inst_ctrl_initial_stage($src2_choose_imm_ctrl, "D");

    set_inst_ctrl_initial_stage($br_ctrl, "D");
    set_inst_ctrl_initial_stage($br_uncond_ctrl, "D");
    set_inst_ctrl_initial_stage($br_cond_ctrl, "D");
    set_inst_ctrl_initial_stage($br_always_pred_taken_ctrl, "D");
    set_inst_ctrl_initial_stage($jmp_direct_ctrl, "D");
    set_inst_ctrl_initial_stage($jmp_indirect_ctrl, "D");
    set_inst_ctrl_initial_stage($uncond_cti_non_br_ctrl, "D");

    set_inst_ctrl_initial_stage($supervisor_only_ctrl, "D");
    set_inst_ctrl_initial_stage($unimp_trap_ctrl, "D");
    set_inst_ctrl_initial_stage($unimp_nop_ctrl, "D");
    set_inst_ctrl_initial_stage($illegal_ctrl, "D");
    set_inst_ctrl_initial_stage($trap_inst_ctrl, "D");
    set_inst_ctrl_initial_stage($exception_ctrl, "D");
    set_inst_ctrl_initial_stage($break_ctrl, "D");
    set_inst_ctrl_initial_stage($crst_ctrl, "D");
    set_inst_ctrl_initial_stage($implicit_dst_retaddr_ctrl, "D");
    set_inst_ctrl_initial_stage($implicit_dst_eretaddr_ctrl, "D");
    set_inst_ctrl_initial_stage($hi_imm16_ctrl, "D");
    set_inst_ctrl_initial_stage($unsigned_lo_imm16_ctrl, "D");
    set_inst_ctrl_initial_stage($signed_imm12_ctrl, "D");
    set_inst_ctrl_initial_stage($src_imm5_shift_rot_ctrl, "D");
    set_inst_ctrl_initial_stage($set_src2_rem_imm_ctrl, "D");
    set_inst_ctrl_initial_stage($alu_signed_comparison_ctrl, "D");
    set_inst_ctrl_initial_stage($alu_subtract_ctrl, "D");
    set_inst_ctrl_initial_stage($cmp_ctrl, "D");
    set_inst_ctrl_initial_stage($logic_ctrl, "D");
    set_inst_ctrl_initial_stage($retaddr_ctrl, "D");
    set_inst_ctrl_initial_stage($wrctl_inst_ctrl, "E");
    set_inst_ctrl_initial_stage($rd_ctl_reg_ctrl, "E");
    set_inst_ctrl_initial_stage($intr_inst_ctrl, "D");

    set_inst_ctrl_initial_stage($ld_ctrl, "D");
    set_inst_ctrl_initial_stage($ld_dcache_management_ctrl, "E");
    set_inst_ctrl_initial_stage($ld_signed_ctrl, "E");
    set_inst_ctrl_initial_stage($ld8_ctrl, "E");
    set_inst_ctrl_initial_stage($ld16_ctrl, "E");
    set_inst_ctrl_initial_stage($ld32_ctrl, "E");
    set_inst_ctrl_initial_stage($ld8_ld16_ctrl, "E");
    set_inst_ctrl_initial_stage($ld_io_ctrl, "E");
    set_inst_ctrl_initial_stage($ld_ex_ctrl, "D");
    set_inst_ctrl_initial_stage($ld_non_io_ctrl, "E");

    set_inst_ctrl_initial_stage($st_ctrl, "E");
    set_inst_ctrl_initial_stage($st8_ctrl, "E");
    set_inst_ctrl_initial_stage($st16_ctrl, "E");
    set_inst_ctrl_initial_stage($st_non32_ctrl, "E");
    set_inst_ctrl_initial_stage($st_io_ctrl, "E");
    set_inst_ctrl_initial_stage($st_ex_ctrl, "D");
    set_inst_ctrl_initial_stage($st_non_io_ctrl, "E");

    set_inst_ctrl_initial_stage($mem_ctrl, "E");
    set_inst_ctrl_initial_stage($mem_data_access_ctrl, "E");
    set_inst_ctrl_initial_stage($mem8_ctrl, "D");
    set_inst_ctrl_initial_stage($mem16_ctrl, "D");
    set_inst_ctrl_initial_stage($mem32_ctrl, "D");
    set_inst_ctrl_initial_stage($ld_st_ctrl, "E");
    set_inst_ctrl_initial_stage($ld_st_ex_ctrl, "D");
    set_inst_ctrl_initial_stage($ld_st_io_ctrl, "E");
    set_inst_ctrl_initial_stage($ld_st_non_io_ctrl, "E");
    set_inst_ctrl_initial_stage($invalidate_i_ctrl, "E");
    set_inst_ctrl_initial_stage($dcache_management_ctrl, "E");

    set_inst_ctrl_initial_stage($custom_combo_ctrl, "D");
    set_inst_ctrl_initial_stage($custom_multi_ctrl, "D");

    my $late_result_ctrl_names = ["ld","rd_ctl_reg","custom_multi"];

    
    my $default_allowed_modes = 
      manditory_array($Opt, "default_inst_ctrl_allowed_modes");
    my $exception_allowed_modes = 
      manditory_array($Opt, "exception_inst_ctrl_allowed_modes");

    if ($cdx_present) {
        set_inst_ctrl_initial_stage($jmp_indirect_word_aligned_ctrl, "D");
        set_inst_ctrl_initial_stage($jmp_indirect_hword_aligned_ctrl, "D");
        set_inst_ctrl_initial_stage($narrow_ctrl, "D");
        set_inst_ctrl_initial_stage($cdx_ctrl, "D");
        set_inst_ctrl_initial_stage($a3_is_src_ctrl, "D");
        set_inst_ctrl_initial_stage($b3_is_src_ctrl, "D");
        set_inst_ctrl_initial_stage($a3_is_dst_ctrl, "D");
        set_inst_ctrl_initial_stage($b3_is_dst_ctrl, "D");
        set_inst_ctrl_initial_stage($c3_is_dst_ctrl, "D");
        set_inst_ctrl_initial_stage($a3_not_src_ctrl, "D");
        set_inst_ctrl_initial_stage($b3_not_src_ctrl, "D");
        set_inst_ctrl_initial_stage($src2_choose_cdx_imm_ctrl, "D");
        

        my $src1_force_zero_ctrl = nios2_insts::additional_inst_ctrl($Opt, {
            name => "src1_force_zero",
            insts => ["movi_n","neg_n"],
            allowed_modes => $default_allowed_modes,
        });
        set_inst_ctrl_initial_stage($src1_force_zero_ctrl, "D");
        
        my $implicit_src1_sp_regnum_ctrl = nios2_insts::additional_inst_ctrl($Opt, {
            name => "implicit_src1_sp_regnum",
            insts => ["ldwsp_n","stwsp_n","spaddi_n"],
            v_expr_func => 
                sub {
                    my $stage = shift;
                    return "| (${stage}_is_spi_n_inst) | (${stage}_is_pp_n_inst)";
                },
            allowed_modes => $default_allowed_modes,
        });
        set_inst_ctrl_initial_stage($implicit_src1_sp_regnum_ctrl, "D");
        set_inst_ctrl_initial_stage($multiple_loads_ctrl, "D");
        set_inst_ctrl_initial_stage($multiple_stores_ctrl, "D");
    }

    if ($hw_mul) {
        set_inst_ctrl_initial_stage($mul_lsw_ctrl, "D");
        push(@$late_result_ctrl_names, "mul_lsw");
        if (!$hw_mul_omits_msw) {
            set_inst_ctrl_initial_stage($mulx_ctrl, "D");
            set_inst_ctrl_initial_stage($mul_src1_signed_ctrl, "D");
            set_inst_ctrl_initial_stage($mul_src2_signed_ctrl, "D");
        }
    }

    if ($fast_shifter_uses_les || $fast_shifter_uses_designware) {
        set_inst_ctrl_initial_stage($rot_ctrl, "D");
        set_inst_ctrl_initial_stage($shift_rot_ctrl, "D");
        set_inst_ctrl_initial_stage($shift_rot_right_ctrl, "D");
        set_inst_ctrl_initial_stage($shift_rot_left_ctrl, "D");
        set_inst_ctrl_initial_stage($shift_right_arith_ctrl, "D");
        set_inst_ctrl_initial_stage($bmx_ctrl, "D");
    } elsif ($small_shifter_uses_les || $medium_shifter_uses_les) {
        set_inst_ctrl_initial_stage($shift_rot_ctrl, "M");
        set_inst_ctrl_initial_stage($rot_right_ctrl, "M");
        set_inst_ctrl_initial_stage($shift_logical_ctrl, "M");
        set_inst_ctrl_initial_stage($shift_rot_right_ctrl, "M");
        set_inst_ctrl_initial_stage($shift_right_arith_ctrl, "M");
    } else {
        &$error("make_inst_decode: unsupported shifter implementation");
    }

    if ($hw_div) {
        set_inst_ctrl_initial_stage($div_ctrl, "D");
        set_inst_ctrl_initial_stage($div_signed_ctrl, "D");
        push(@$late_result_ctrl_names, "div");
    }

    if ($shadow_present) {
        set_inst_ctrl_initial_stage($rdprs_ctrl, "D");
    }


    my $flush_pipe_always_ctrl = nios2_insts::additional_inst_ctrl($Opt, {
      name  => "flush_pipe_always",
      ctrls => ["flush_pipe", "wr_ctl_reg_flush"],
      allowed_modes => $exception_allowed_modes,
    });
    set_inst_ctrl_initial_stage($flush_pipe_always_ctrl, "D");




    my $alu_force_xor_ctrl = nios2_insts::additional_inst_ctrl($Opt, {
      name => "alu_force_xor",
      insts => $cdx_present ? ["not_n"] : [],
      ctrls => ["br_cmp_eq_ne"],
      allowed_modes => $default_allowed_modes,
    });
    set_inst_ctrl_initial_stage($alu_force_xor_ctrl, "D");



    my $alu_force_and_ctrl = nios2_insts::additional_inst_ctrl($Opt, {
      name => "alu_force_and",
      ctrls => ["andc"],
      insts => $cdx_present ? ["and_n"] : [],
      allowed_modes => $default_allowed_modes,
    });
    set_inst_ctrl_initial_stage($alu_force_and_ctrl, "D");





    my $late_result_ctrl = nios2_insts::additional_inst_ctrl($Opt, {
      name  => "late_result",
      ctrls => $late_result_ctrl_names,
      insts => $cdx_present ? ["pop_n","ldwm"] : [],
      allowed_modes => $default_allowed_modes,
    });
    set_inst_ctrl_initial_stage($late_result_ctrl, "D");

}






sub make_perf_cnt
{
    my $Opt = shift;

    my $wdata = not_empty_scalar($Opt, "wrctl_data");


    my $perf_cnt_sz = manditory_int($Opt, "performance_counters_width");






    e_register->adds(
      {out => "E_refetch_perf_cnt",         in => "D_refetch",
       enable => "E_en"},
      {out => "A_pipe_flush_perf_cnt",      in => "M_pipe_flush", 
       enable => "A_en"},


      {out => ["perf_clr", 1], 
       in => "(A_wrctl_sim & A_valid) ? 
               A_wrctl_data_sim_reg_perf_cnt_clr : 0",
       enable => "W_en", async_value => "1'b1" },
      );











    e_assign->adds(


      [["D_no_disp_pipe_flush", 1], 
        "M_pipe_flush | A_pipe_flush_perf_cnt"],


      [["D_no_disp_delay_slot", 1], 
        "D_kill & ~E_refetch_perf_cnt & ~D_no_disp_pipe_flush"],




      [["D_no_disp_data_depend", 1], 
        "D_data_depend & D_issue & ~M_pipe_flush"],
    );














    e_assign->adds(

      [["perf_cycles_nxt", $perf_cnt_sz], "perf_cycles + 1"],


      [["perf_dispatched_nxt", $perf_cnt_sz], 
        "(D_valid & E_en) ? perf_dispatched + 1 : perf_dispatched"],


      [["perf_retired_nxt", $perf_cnt_sz], 
        "(A_valid & A_en) ? perf_retired + 1 : perf_retired"],


      [["perf_A_rd_stall_nxt", $perf_cnt_sz], 
        "$perf_cnt_inc_rd_stall ? perf_A_rd_stall + 1 : perf_A_rd_stall"],


      [["perf_A_wr_stall_nxt", $perf_cnt_sz], 
        "$perf_cnt_inc_wr_stall ? perf_A_wr_stall + 1 : perf_A_wr_stall"],



      [["perf_no_disp_pipe_flush_nxt", $perf_cnt_sz], 
        "(D_no_disp_pipe_flush & ~E_stall) ? 
           perf_no_disp_pipe_flush + 1 : perf_no_disp_pipe_flush"],



      [["perf_no_disp_delay_slot_nxt", $perf_cnt_sz], 
        "(D_no_disp_delay_slot & ~E_stall) ? 
           perf_no_disp_delay_slot + 1 : perf_no_disp_delay_slot"],



      [["perf_no_disp_data_depend_nxt", $perf_cnt_sz], 
        "(D_no_disp_data_depend & ~E_stall) ? 
           perf_no_disp_data_depend + 1 : perf_no_disp_data_depend"],



      [["perf_br_pred_bad_nxt", $perf_cnt_sz], 
        "(M_br_mispredict & ~A_stall) ? 
           perf_br_pred_bad + 1 : perf_br_pred_bad"],



      [["perf_br_pred_good_nxt", $perf_cnt_sz], 
        "(M_ctrl_br_cond & ~M_br_mispredict & ~A_stall) ? 
           perf_br_pred_good + 1 : perf_br_pred_good"],
    );

    e_assign->adds(
      [["perf_en", 1], "W_sim_reg_perf_cnt_en"],
    );   

    e_register->adds(
      {out => ["perf_cycles", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_cycles_nxt", enable => "perf_en"},
      {out => ["perf_dispatched", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_dispatched_nxt", enable => "perf_en"},
      {out => ["perf_retired", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_retired_nxt", enable => "perf_en"},
      {out => ["perf_A_rd_stall", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_A_rd_stall_nxt", enable => "perf_en"},
      {out => ["perf_A_wr_stall", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_A_wr_stall_nxt", enable => "perf_en"},
      {out => ["perf_no_disp_pipe_flush", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_no_disp_pipe_flush_nxt", 
       enable => "perf_en"},
      {out => ["perf_no_disp_delay_slot", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_no_disp_delay_slot_nxt", 
       enable => "perf_en"},
      {out => ["perf_no_disp_data_depend", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_no_disp_data_depend_nxt", 
       enable => "perf_en"},
      {out => ["perf_br_pred_bad", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_br_pred_bad_nxt", enable => "perf_en"},
      {out => ["perf_br_pred_good", $perf_cnt_sz], 
       in => "perf_clr ? 0 : perf_br_pred_good_nxt", enable => "perf_en"},
    );

    my @perf_counters = (
      { divider => "perf_counters" },
      { radix => "x", signal => "clk" },
      { radix => "x", signal => "perf_clr" },
      { radix => "x", signal => "perf_en" },
      { radix => "a", signal => "F_vinst" },
      { radix => "a", signal => "D_vinst" },
      { radix => "a", signal => "E_vinst" },
      { radix => "a", signal => "M_vinst" },
      { radix => "a", signal => "A_vinst" },
      { radix => "a", signal => "W_vinst" },
      { radix => "x", signal => "F_issue" },
      { radix => "x", signal => "F_kill" },

      { radix => "x", signal => "D_refetch" },

      { radix => "x", signal => "D_issue" },
      { radix => "d", signal => "perf_cycles" },
      { radix => "d", signal => "perf_dispatched" },
      { radix => "d", signal => "perf_retired" },
      { radix => "d", signal => "perf_A_rd_stall" },
      { radix => "d", signal => "perf_A_wr_stall" },
      { radix => "d", signal => "perf_no_disp_pipe_flush" },
      { radix => "d", signal => "perf_no_disp_delay_slot" },
      { radix => "d", signal => "perf_no_disp_data_depend" },
      { radix => "d", signal => "perf_br_pred_bad" },
      { radix => "d", signal => "perf_br_pred_good" },
    );

    push(@plaintext_wave_signals, @perf_counters);
}

1;
