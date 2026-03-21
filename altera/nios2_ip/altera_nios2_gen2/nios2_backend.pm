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






















package nios2_backend;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &be_set_control_reg_pipeline_desc
    &be_make_control_regs
    &be_make_custom_instruction_master
    &be_make_alu
    &be_make_stdata
    &be_make_hbreak
    &be_make_cpu_reset
);

use europa_all;
use europa_utils;
use e_custom_instruction_master;
use cpu_utils;
use cpu_wave_signals;
use cpu_control_reg;
use cpu_control_reg_gen;
use nios_europa;
use nios_avalon_masters;
use nios_common;
use nios_isa;
use nios_icache;
use nios_dcache;
use nios2_isa;
use nios2_control_regs;
use nios2_insts;
use nios2_common;
use nios2_custom_insts;
use strict;







sub
be_set_control_reg_pipeline_desc
{
    my $Opt = shift;

    my $whoami = "Control registers pipeline desc";

    my $stages = manditory_array($Opt, "stages");
    my $cs = not_empty_scalar($Opt, "control_reg_stage");
    my $rs = check_opt_value($Opt, "rdctl_stage", ["E", "M"], $whoami);
    my $wss = not_empty_scalar($Opt, "wrctl_setup_stage");
    my $wd = not_empty_scalar($Opt, "wrctl_data");

    my $pipeline_desc = {
        stages => $stages,
        control_reg_stage => $cs,
        rdctl_stage => $rs,
        wrctl_setup_stage => $wss,
        wrctl_data => $wd,
        regnum_field => $control_regnum_inst_field,
    };

    if (!defined(set_control_reg_pipeline_desc($pipeline_desc))) {
        &$error("set_control_reg_pipeline_desc() failed");
    }
}

sub 
be_make_control_regs
{
    my $Opt = shift;

    my $whoami = "Control registers";

    my $cs = not_empty_scalar($Opt, "control_reg_stage");
    my $rs = check_opt_value($Opt, "rdctl_stage", ["E", "M"], $whoami);
    my $wss = not_empty_scalar($Opt, "wrctl_setup_stage");
    my $control_regs = manditory_array($Opt, "control_regs");
    my $num_tightly_coupled_data_masters = manditory_int($Opt, "num_tightly_coupled_data_masters");
    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");
    my $oci_version = manditory_int($Opt, "oci_version");

    my $r1 = ($cpu_arch_rev == 1);
    my $r2 = ($cpu_arch_rev == 2);

    my $oci_version = manditory_int($Opt, "oci_version");
        

    my $wdata = "${wss}_wrctl_data";




    foreach my $field (@{get_control_reg_fields($ienable_reg)}) {
        my $f = get_control_reg_field_name($field);
        my $irq = get_control_reg_field_lsb($field);


        set_control_reg_field_input_expr($field,
          "((${wss}_wrctl_ienable & ${wss}_valid) ? 
                   ${wdata}_ienable_reg_${f} :
                   ${cs}_ienable_reg_${f})");
    }
    



    foreach my $field (@{get_control_reg_fields($ipending_reg)}) {
        my $f = get_control_reg_field_name($field);
        my $irq = get_control_reg_field_lsb($field);

        if ($oci_version == 2) {

            set_control_reg_field_input_expr($field,
             "irq[$irq] & ${cs}_ienable_reg_${f} & ~oci_idisable");
        } else {

            set_control_reg_field_input_expr($field,
             "irq[$irq] & ${cs}_ienable_reg_${f} & oci_ienable[$irq]");
        }


        set_control_reg_field_wr_en_expr($field, "1");
    }

    if ($sim_reg) {






        set_control_reg_no_rdctl($sim_reg, 1);

        if ($sim_reg_stop) {



            e_assign->adds(
              [["${cs}_sim_reg_stop_nxt", 1],
                "(${wss}_wrctl_sim & ${wss}_valid) ? ${wdata}_sim_reg_stop :
                                                     ${cs}_sim_reg_stop"],
            );

            e_register->adds(
              {out => ["${cs}_sim_reg_stop", 1],
               in => "${cs}_sim_reg_stop_nxt",       
               enable => "${cs}_en" },
            );
        }

        if ($sim_reg_perf_cnt_en) {
            set_control_reg_field_input_expr($sim_reg_perf_cnt_en,
              "(${wss}_wrctl_sim & ${wss}_valid) ? 
                    ${wdata}_sim_reg_perf_cnt_en :
                    ${cs}_sim_reg_perf_cnt_en");
        }
    }


    e_assign->adds(




        [["${wss}_eret_src", $estatus_reg_sz],
          $shadow_present ?
            "(${cs}_status_reg_crs == 0) ? 
                ${cs}_estatus_reg[$estatus_reg_msb:$estatus_reg_lsb] : 
                ${wss}_src2[$estatus_reg_msb:$estatus_reg_lsb]" :
            "${cs}_estatus_reg[$estatus_reg_msb:$estatus_reg_lsb]"],
    );

    e_assign->adds(




      [["${cs}_status_reg_pie_inst_nxt", $status_reg_pie_sz],
      $r2 ?
        "${wss}_op_wrpie        ? A_status_reg_pie_alu_0 :
         ${wss}_op_eni          ? 1'b1 :
         ${wss}_op_eret         ? ${wss}_eret_src[$status_reg_pie_lsb] :
         ${wss}_op_bret         ? ${cs}_bstatus_reg[$status_reg_pie_lsb] :
         ${wss}_wrctl_status    ? ${wdata}_status_reg_pie :
                                  ${cs}_status_reg_pie" :
        "${wss}_op_eret         ? ${wss}_eret_src[$status_reg_pie_lsb] :
         ${wss}_op_bret         ? ${cs}_bstatus_reg[$status_reg_pie_lsb] :
         ${wss}_wrctl_status    ? ${wdata}_status_reg_pie :
                                  ${cs}_status_reg_pie"],

    );

    my $pie_expr =
      "${wss}_exc_any_active  ? 1'b0 :
       ${wss}_valid           ? ${cs}_status_reg_pie_inst_nxt : 
                                ${cs}_status_reg_pie";




    set_control_reg_field_input_expr($status_reg_pie, $pie_expr);

    if ($status_reg_u) {
        e_assign->adds(
          [["${cs}_status_reg_u_inst_nxt", $status_reg_u_sz],
            "${wss}_op_eret         ? ${wss}_eret_src[$status_reg_u_lsb] :
             ${wss}_op_bret         ? ${cs}_bstatus_reg[$status_reg_u_lsb] :
             ${wss}_wrctl_status    ? ${wdata}_status_reg_u :
                                      ${cs}_status_reg_u"],
        );

        set_control_reg_field_input_expr($status_reg_u,
          "${wss}_exc_any_active  ? 1'b0 :
           ${wss}_valid           ? ${cs}_status_reg_u_inst_nxt : 
                                    ${cs}_status_reg_u");
    }

    if ($status_reg_eh) {
        e_assign->adds(
          [["${cs}_status_reg_eh_inst_nxt", $status_reg_eh_sz],
            "${wss}_op_eret       ? ${wss}_eret_src[$status_reg_eh_lsb] :
             ${wss}_op_bret       ? ${cs}_bstatus_reg[$status_reg_eh_lsb] :
             ${wss}_wrctl_status  ? ${wdata}_status_reg_eh :
                                    ${cs}_status_reg_eh"],
        );

        set_control_reg_field_input_expr($status_reg_eh,
          "${wss}_exc_crst_active     ? 0 :
           (${wss}_exc_any_active & ~${wss}_exc_ext_intr_active) ? 1 :
           ${wss}_valid               ? ${cs}_status_reg_eh_inst_nxt : 
                                        ${cs}_status_reg_eh");
    }

    if ($status_reg_ih) {
        e_assign->adds(
          [["${cs}_status_reg_ih_inst_nxt", $status_reg_ih_sz],
            "${wss}_op_eret      ? ${wss}_eret_src[$status_reg_ih_lsb] :
             ${wss}_op_bret      ? ${cs}_bstatus_reg[$status_reg_ih_lsb] :
             ${wss}_wrctl_status ? ${wdata}_status_reg_ih :
                                   ${cs}_status_reg_ih"],
        );

        set_control_reg_field_input_expr($status_reg_ih, 
          "${wss}_exc_crst_active     ? 0 :
           ${wss}_exc_ext_intr_active ? 1 :
           ${wss}_valid               ? ${cs}_status_reg_ih_inst_nxt : 
                                        ${cs}_status_reg_ih");
    }

    if ($status_reg_il) {
        e_assign->adds(
          [["${cs}_status_reg_il_inst_nxt", $status_reg_il_sz],
            "${wss}_op_eret ? 
               ${wss}_eret_src[$status_reg_il_msb:$status_reg_il_lsb] :
             ${wss}_op_bret ? 
               ${cs}_bstatus_reg[$status_reg_il_msb:$status_reg_il_lsb] :
             ${wss}_wrctl_status ? ${wdata}_status_reg_il :
             ${cs}_status_reg_il"],
        );

        set_control_reg_field_input_expr($status_reg_il, 
          "${wss}_exc_crst_active     ? 0 :
           ${wss}_exc_ext_intr_active ? ${wss}_eic_ril :
           ${wss}_valid               ? ${cs}_status_reg_il_inst_nxt : 
                                        ${cs}_status_reg_il");
    }

    if ($status_reg_crs) {
        e_assign->adds(
          [["${cs}_status_reg_crs_inst_nxt", $status_reg_crs_sz],
            "${wss}_op_eret      ? 
               ${wss}_eret_src[$status_reg_crs_msb:$status_reg_crs_lsb] :
             ${wss}_op_bret      ? 
               ${cs}_bstatus_reg[$status_reg_crs_msb:$status_reg_crs_lsb] :
               ${cs}_status_reg_crs"],
        );

        my $crs_expr =
          "${wss}_exc_any_active  ? 0 :
           ${wss}_valid           ? ${cs}_status_reg_crs_inst_nxt : 
                                    ${cs}_status_reg_crs";

        if ($eic_and_shadow) {
          $crs_expr = 
            "${wss}_exc_ext_intr_active ? ${wss}_eic_rrs :
             $crs_expr";
        }

        set_control_reg_field_input_expr($status_reg_crs, $crs_expr);
    }

    if ($status_reg_prs) {
        e_assign->adds(
          [["${cs}_status_reg_prs_inst_nxt", $status_reg_prs_sz],
            "${wss}_op_eret      ? 
               ${wss}_eret_src[$status_reg_prs_msb:$status_reg_prs_lsb] :
             ${wss}_op_bret      ? 
                ${cs}_bstatus_reg[$status_reg_prs_msb:$status_reg_prs_lsb] :
             ${wss}_wrctl_status ? 
                ${wdata}_status_reg_prs :
                ${cs}_status_reg_prs"],
        );

        set_control_reg_field_input_expr($status_reg_prs,
          "${wss}_exc_crst_active ?    0 :
           ((${wss}_exc_active_no_break & ~W_exc_handler_mode) |
            ${wss}_exc_break_active) ? ${cs}_status_reg_crs :
           ${wss}_valid              ? ${cs}_status_reg_prs_inst_nxt : 
                                       ${cs}_status_reg_prs");
    }

    if ($status_reg_nmi) {

        e_assign->adds(
          [["${cs}_status_reg_nmi_inst_nxt", $status_reg_nmi_sz],
            "(${wss}_op_eret & ~${wss}_eret_src[$status_reg_nmi_lsb]) ? 0 :
             ${wss}_op_bret ? ${cs}_bstatus_reg[$status_reg_nmi_lsb] :
                              ${cs}_status_reg_nmi"],
        );

        set_control_reg_field_input_expr($status_reg_nmi, 
          "${wss}_exc_crst_active     ? 0 :
           ${wss}_exc_ext_intr_active ? ${wss}_eic_rnmi :
           ${wss}_valid               ? ${cs}_status_reg_nmi_inst_nxt : 
                                        ${cs}_status_reg_nmi");
    }

    if ($status_reg_rsie) {
        e_assign->adds(
          [["${cs}_status_reg_rsie_inst_nxt", $status_reg_rsie_sz],
            $r2 ?
            "${wss}_op_eni  ? (W_status_reg_rsie | A_iw_rsie) :
             ${wss}_op_eret ? ${wss}_eret_src[$status_reg_rsie_lsb] :
             ${wss}_op_bret ? ${cs}_bstatus_reg[$status_reg_rsie_lsb] :
             ${wss}_wrctl_status ? ${wdata}_status_reg_rsie :
                              ${cs}_status_reg_rsie" :
            "${wss}_op_eret ? ${wss}_eret_src[$status_reg_rsie_lsb] :
             ${wss}_op_bret ? ${cs}_bstatus_reg[$status_reg_rsie_lsb] :
             ${wss}_wrctl_status ? ${wdata}_status_reg_rsie :
                              ${cs}_status_reg_rsie"],
        );

        set_control_reg_field_input_expr($status_reg_rsie, 
          "${wss}_exc_crst_active     ? 1 :
           ${wss}_exc_ext_intr_active ? 0 :
           ${wss}_valid               ? ${cs}_status_reg_rsie_inst_nxt : 
                                        ${cs}_status_reg_rsie");
    }


    foreach my $status_field (@{get_control_reg_fields($status_reg)}) {
        my $f = get_control_reg_field_name($status_field);
        my $sz = get_control_reg_field_sz($status_field);
        my $estatus_field = get_control_reg_field($estatus_reg, $f);
        my $bstatus_field = get_control_reg_field($bstatus_reg, $f);

        e_assign->adds(

          [["${cs}_estatus_reg_${f}_inst_nxt", $sz],
            "${wss}_wrctl_estatus ? ${wdata}_estatus_reg_${f}:
                                    ${cs}_estatus_reg_${f}"],


          [["${cs}_bstatus_reg_${f}_inst_nxt", $sz],
            "${wss}_wrctl_bstatus ? ${wdata}_bstatus_reg_${f}:
                                    ${cs}_bstatus_reg_${f}"],
        );

        set_control_reg_field_input_expr($estatus_field,
            "${wss}_exc_crst_active ? 0 :
            (${wss}_exc_active_no_break & ~${wss}_exc_shadow &
               ~W_exc_handler_mode) ? ${cs}_status_reg_${f} :
             ${wss}_valid           ? ${cs}_estatus_reg_${f}_inst_nxt : 
                                      ${cs}_estatus_reg_${f}");

        set_control_reg_field_input_expr($bstatus_field,
            "${wss}_exc_break_active ? ${cs}_status_reg_${f} :
             ${wss}_valid            ? ${cs}_bstatus_reg_${f}_inst_nxt :
                                       ${cs}_bstatus_reg_${f}");
    }

    if ($eic_and_shadow) {
        e_assign->adds(

          [["${cs}_sstatus_reg_srs_nxt", 1],
            "${wss}_eic_rrs != ${cs}_status_reg_crs"],




          [["${cs}_sstatus_reg_nxt", 32],
            "{ ${cs}_sstatus_reg_srs_nxt, ${cs}_status_reg[30:0] }"],
        );
    }

    if ($exception_reg) {



        if ($exception_reg_cause) {
            set_control_reg_field_input_expr($exception_reg_cause,
                $oci_version == 2 & $oci_present ?
                "(${wss}_exc_active_no_break & 
                 ~${wss}_exc_ext_intr_active & ~(W_debug_mode & oci_debug_mode_exc)) ? 
                    ${wss}_exc_highest_pri_cause_code :
                    ${cs}_exception_reg_cause" :
                "(${wss}_exc_active_no_break & 
                 ~${wss}_exc_ext_intr_active) ? 
                    ${wss}_exc_highest_pri_cause_code :
                    ${cs}_exception_reg_cause");
        }
        
        if ($exception_reg_eccftl) {
            my @ftl_signals;

            if ($rf_ecc_present) {
                push(@ftl_signals, "A_exc_ecc_rf_error_active");
            }
            
            if ($dc_ecc_present) {
                push(@ftl_signals, "A_exc_ecc_data_error_active");
                push(@ftl_signals, "A_exc_ecc_dcache_async_error_active");
            }

            my $ftl_expr = scalar(@ftl_signals) ? join(' | ', @ftl_signals) : "0";

            set_control_reg_field_input_expr($exception_reg_eccftl,
                "(${wss}_exc_active_no_break & ~${wss}_exc_ext_intr_active) ? 
                   ($ftl_expr) :
                   ${cs}_exception_reg_eccftl");
        }
    }

    if ($badaddr_reg) {
        set_control_reg_field_input_expr($badaddr_reg_baddr,
            $oci_version == 2 & $oci_present? 
            "${wss}_exc_crst_active  ? 0 :
             (${wss}_exc_record_baddr & ~(W_debug_mode & oci_debug_mode_exc))? ${wss}_exc_highest_pri_baddr :
                                       ${cs}_badaddr_reg_baddr" :
            "${wss}_exc_crst_active  ? 0 :
             ${wss}_exc_record_baddr ? ${wss}_exc_highest_pri_baddr :
                                       ${cs}_badaddr_reg_baddr");
    }

    if ($pteaddr_reg) {

        set_control_reg_field_input_expr($pteaddr_reg_ptbase,
          "${wss}_exc_crst_active ? 0 : ${wdata}_pteaddr_reg_ptbase");

        set_control_reg_field_wr_en_expr($pteaddr_reg_ptbase, 
            "${cs}_en & 
              ((${wss}_wrctl_pteaddr & ${wss}_valid) | 
               ${wss}_exc_crst_active)");



        set_control_reg_field_input_expr($pteaddr_reg_vpn,
            "${wss}_exc_crst_active  ? 0 :
             (${wss}_exc_tlb_active & ~W_exc_handler_mode) ? 
                                       ${wss}_exc_vpn :
             ${cs}_tlb_rd_operation  ? tlb_rd_vpn :
                                       ${wdata}_pteaddr_reg_vpn");

        set_control_reg_field_wr_en_expr($pteaddr_reg_vpn, 
            "${cs}_en &
              ((${wss}_exc_tlb_active & ~W_exc_handler_mode) |
               ${cs}_tlb_rd_operation |
               (${wss}_wrctl_pteaddr & ${wss}_valid) |
               ${wss}_exc_crst_active)");

        set_control_reg_field_testbench_expr($pteaddr_reg_vpn,
           "${cs}_tlb_rd_operation ? ${cs}_pteaddr_reg_vpn_nxt
                                   : ${cs}_pteaddr_reg_vpn");
    }

    if ($tlbacc_reg) {


        my $wr_en_expr =
            "${cs}_en &
              (${cs}_tlb_rd_operation |
               (${wss}_wrctl_tlbacc & ${wss}_valid) |
               ${wss}_exc_crst_active)";

        set_control_reg_field_input_expr($tlbacc_reg_pfn,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_tlb_rd_operation   ? tlb_rd_pfn :
                                        ${wdata}_tlbacc_reg_pfn");
        set_control_reg_field_wr_en_expr($tlbacc_reg_pfn, $wr_en_expr);
        set_control_reg_field_testbench_expr($tlbacc_reg_pfn,
         "${cs}_tlb_rd_operation ? ${cs}_tlbacc_reg_pfn_nxt :
                                   ${cs}_tlbacc_reg_pfn");

        set_control_reg_field_input_expr($tlbacc_reg_g,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_tlb_rd_operation   ? tlb_rd_g :
                                        ${wdata}_tlbacc_reg_g");
        set_control_reg_field_wr_en_expr($tlbacc_reg_g, $wr_en_expr);
        set_control_reg_field_testbench_expr($tlbacc_reg_g,
         "${cs}_tlb_rd_operation ? ${cs}_tlbacc_reg_g_nxt :
                                   ${cs}_tlbacc_reg_g");

        set_control_reg_field_input_expr($tlbacc_reg_x,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_tlb_rd_operation   ? tlb_rd_x :
                                        ${wdata}_tlbacc_reg_x");
        set_control_reg_field_wr_en_expr($tlbacc_reg_x, $wr_en_expr);
        set_control_reg_field_testbench_expr($tlbacc_reg_x,
         "${cs}_tlb_rd_operation ? ${cs}_tlbacc_reg_x_nxt :
                                   ${cs}_tlbacc_reg_x");

        set_control_reg_field_input_expr($tlbacc_reg_w,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_tlb_rd_operation   ? tlb_rd_w :
                                        ${wdata}_tlbacc_reg_w");
        set_control_reg_field_wr_en_expr($tlbacc_reg_w, $wr_en_expr);
        set_control_reg_field_testbench_expr($tlbacc_reg_w,
         "${cs}_tlb_rd_operation ? ${cs}_tlbacc_reg_w_nxt :
                                   ${cs}_tlbacc_reg_w");

        set_control_reg_field_input_expr($tlbacc_reg_r,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_tlb_rd_operation   ? tlb_rd_r :
                                        ${wdata}_tlbacc_reg_r");
        set_control_reg_field_wr_en_expr($tlbacc_reg_r, $wr_en_expr);
        set_control_reg_field_testbench_expr($tlbacc_reg_r,
         "${cs}_tlb_rd_operation ? ${cs}_tlbacc_reg_r_nxt :
                                   ${cs}_tlbacc_reg_r");

        set_control_reg_field_input_expr($tlbacc_reg_c,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_tlb_rd_operation   ? tlb_rd_c :
                                        ${wdata}_tlbacc_reg_c");
        set_control_reg_field_wr_en_expr($tlbacc_reg_c, $wr_en_expr);
        set_control_reg_field_testbench_expr($tlbacc_reg_c,
         "${cs}_tlb_rd_operation ? ${cs}_tlbacc_reg_c_nxt :
                                   ${cs}_tlbacc_reg_c");
    }

    if ($tlbmisc_reg) {

        set_control_reg_field_input_expr($tlbmisc_reg_we,
            "${wss}_exc_crst_active                ? 0 :
             (${wss}_exc_tlb_active & ~W_exc_handler_mode) ? 1 :
             (${wss}_wrctl_tlbmisc & ${wss}_valid) ? 
                                        ${wdata}_tlbmisc_reg_we :
                                        ${cs}_tlbmisc_reg_we");

        my $ecc_tlbmisc_way = "";
        my $ecc_tlbmisc_way_en = "";
        if ($mmu_ecc_present) {
            my $tlb_way_sz = get_control_reg_field_sz($tlbmisc_reg_way);

            e_register->adds(
                {out => ["E_uitlb_way", $tlb_way_sz], 
                 in => "D_uitlb_way",         enable => "E_en"},
                {out => ["M_uitlb_way", $tlb_way_sz], 
                 in => "E_uitlb_way",         enable => "M_en"},
                {out => ["A_uitlb_way", $tlb_way_sz], 
                 in => "M_uitlb_way",         enable => "A_en"},
            
                {out => ["A_udtlb_way", $tlb_way_sz], 
                 in => "M_udtlb_way",         enable => "A_en"},
            );
            
            $ecc_tlbmisc_way = "${wss}_exc_ecc_error_itlb_active ? ${wss}_uitlb_way :
                                ${wss}_exc_ecc_error_dtlb_active ? ${wss}_udtlb_way :";
            $ecc_tlbmisc_way_en = "| (${wss}_exc_ecc_error_itlb_active | ${wss}_exc_ecc_error_dtlb_active)";
        }




        set_control_reg_field_input_expr($tlbmisc_reg_way,
            "${wss}_exc_crst_active              ? 0 :
             $ecc_tlbmisc_way
            (${wss}_wrctl_tlbacc & ${wss}_valid & ${cs}_tlbmisc_reg_we) ?
               (${cs}_tlbmisc_reg_way + 1) :
               ${wdata}_tlbmisc_reg_way");
        set_control_reg_field_wr_en_expr($tlbmisc_reg_way,
            "${cs}_en & 
              ((${wss}_wrctl_tlbacc & ${wss}_valid & ${cs}_tlbmisc_reg_we) |
               (${wss}_wrctl_tlbmisc & ${wss}_valid) |
               ${wss}_exc_crst_active $ecc_tlbmisc_way_en)");



        set_control_reg_field_input_expr($tlbmisc_reg_pid,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_tlb_rd_operation   ? tlb_rd_pid :
                                        ${wdata}_tlbmisc_reg_pid");
        set_control_reg_field_wr_en_expr($tlbmisc_reg_pid,
            "${cs}_en & 
              (${cs}_tlb_rd_operation |
               (${wss}_wrctl_tlbmisc & ${wss}_valid) |
               ${wss}_exc_crst_active)");
        set_control_reg_field_testbench_expr($tlbmisc_reg_pid,
           "${cs}_tlb_rd_operation ? ${cs}_tlbmisc_reg_pid_nxt :
                                     ${cs}_tlbmisc_reg_pid");


        set_control_reg_field_input_expr($tlbmisc_reg_dbl,
            "(${wss}_exc_tlb_inst_miss_active | 
              ${wss}_exc_tlb_data_miss_active) ?
                                          W_exc_handler_mode :
             ${wss}_exc_active_no_break ? 0 :
                                          ${cs}_tlbmisc_reg_dbl");


        set_control_reg_field_input_expr($tlbmisc_reg_bad,
            "${wss}_exc_bad_virtual_addr_active ? 1 :
             ${wss}_exc_active_no_break         ? 0 :
                                                  ${cs}_tlbmisc_reg_bad");


        set_control_reg_field_input_expr($tlbmisc_reg_perm,
            "(${wss}_exc_tlb_x_perm_active | ${wss}_exc_tlb_r_perm_active |
              ${wss}_exc_tlb_w_perm_active) ?  1 :
             ${wss}_exc_active_no_break ? 0 :
                                          ${cs}_tlbmisc_reg_perm");


        set_control_reg_field_input_expr($tlbmisc_reg_d,
            "${wss}_exc_crst_active                             ? 0 :
             (${wss}_exc_data & ~W_exc_handler_mode)            ? 1 :
             (${wss}_exc_active_no_break & ~W_exc_handler_mode) ? 0 :
                                        ${cs}_tlbmisc_reg_d");
        
        if ($ecc_present) {

            my $mmu_ecc_error = "0";
            if ($mmu_ecc_present) {
                $mmu_ecc_error = "tlb_one_two_or_three_bit_err";    
            }

            set_control_reg_field_input_expr($tlbmisc_reg_ee,
            "${wss}_exc_crst_active                             ? 0 :
             ${cs}_tlb_rd_operation_d1                          ? $mmu_ecc_error :
                                        ${wdata}_tlbmisc_reg_ee");
            set_control_reg_field_wr_en_expr($tlbmisc_reg_ee,
            "${cs}_tlb_rd_operation_d1 |
               ${cs}_en & (
               (${wss}_wrctl_tlbmisc & ${wss}_valid) |
               ${wss}_exc_crst_active)");
        }
    }

    if ($mmu_present) {



        e_assign->adds(

          [["${wss}_tlb_rd_operation", 1],
            "${wss}_wrctl_tlbmisc & ${wdata}_tlbmisc_reg_rd & 
             ${wss}_valid"],
        );

        e_register->adds(
          {out => ["${cs}_tlb_rd_operation", 1], 
           in => "${wss}_tlb_rd_operation", enable => "${cs}_en"},
        );
        
        if ($ecc_present) {

            e_register->adds(
              {out => ["W_en_d1", 1], 
               in => "W_en", enable => "1'b1"},
              {out => ["${cs}_tlb_rd_operation_d1", 1], 
               in => "${cs}_tlb_rd_operation", enable => "W_en_d1"},
        );
        }
    }

    if ($config_reg) {
        if ($config_reg_pe) {
            e_assign->adds(

              [["${cs}_config_reg_pe_inst_nxt", $config_reg_pe_sz],
                "${wss}_wrctl_config ? ${wdata}_config_reg_pe :
                                       ${cs}_config_reg_pe"],
            );



            set_control_reg_field_input_expr($config_reg_pe,
                "${wss}_exc_crst_active ? 0 :
                 ${wss}_valid           ? ${cs}_config_reg_pe_inst_nxt : 
                                          ${cs}_config_reg_pe");
        }

        if ($config_reg_eccen) {
            e_assign->adds(

              [["${cs}_config_reg_eccen_inst_nxt", $config_reg_eccen_sz],
                "${wss}_wrctl_config ? ${wdata}_config_reg_eccen :
                                       ${cs}_config_reg_eccen"],
            );



            set_control_reg_field_input_expr($config_reg_eccen,
                "${wss}_exc_crst_active ? 0 :
                 ${wss}_valid           ? ${cs}_config_reg_eccen_inst_nxt : 
                                          ${cs}_config_reg_eccen");
        }
        
        if ($config_reg_eccexc) {
            e_assign->adds(

              [["${cs}_config_reg_eccexc_inst_nxt", $config_reg_eccexc_sz],
                "${wss}_wrctl_config ? ${wdata}_config_reg_eccexc :
                                       ${cs}_config_reg_eccexc"],
            );



            set_control_reg_field_input_expr($config_reg_eccexc,
                "${wss}_exc_crst_active ? 0 :
                 ${wss}_valid           ? ${cs}_config_reg_eccexc_inst_nxt :
                                          ${cs}_config_reg_eccexc");
        }



        if ($config_reg_eccen && $config_reg_eccexc) {
            e_register->adds(
              {out => ["${cs}_ecc_exc_enabled", 1], 
               in => 
                 "${cs}_config_reg_eccen_nxt & 
                 ${cs}_config_reg_eccexc_nxt", 
               enable => 
                 "${cs}_config_reg_eccen_wr_en |
                  ${cs}_config_reg_eccexc_wr_en"
               },
            );
        }
    }

    if ($mpubase_reg) {


        set_control_reg_field_input_expr($mpubase_reg_base,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_dmpu_rd_operation  ? dmpu_rd_base :
             ${cs}_impu_rd_operation  ? impu_rd_base :
                                        ${wdata}_mpubase_reg_base");
        set_control_reg_field_wr_en_expr($mpubase_reg_base,
            "${cs}_en & 
              (${cs}_dmpu_rd_operation |
               ${cs}_impu_rd_operation |
               (${wss}_wrctl_mpubase & ${wss}_valid) |
               ${wss}_exc_crst_active)");
        set_control_reg_field_testbench_expr($mpubase_reg_base,
          "${cs}_mpu_rd_operation ? ${cs}_mpubase_reg_base_nxt :
                                    ${cs}_mpubase_reg_base");

        e_assign->adds(

          [["${cs}_mpubase_reg_index_inst_nxt", $mpubase_reg_index_sz],
            "${wss}_wrctl_mpubase ? ${wdata}_mpubase_reg_index :
                                    ${cs}_mpubase_reg_index"],
        );
    


        set_control_reg_field_input_expr($mpubase_reg_index,
            "${wss}_exc_crst_active ? 0 :
             ${wss}_valid           ? ${cs}_mpubase_reg_index_inst_nxt : 
                                      ${cs}_mpubase_reg_index");

        e_assign->adds(

          [["${cs}_mpubase_reg_d_inst_nxt", $mpubase_reg_d_sz],
            "${wss}_wrctl_mpubase ? ${wdata}_mpubase_reg_d :
                                    ${cs}_mpubase_reg_d"],
        );
    


        set_control_reg_field_input_expr($mpubase_reg_d,
            "${wss}_exc_crst_active ? 0 :
             ${wss}_valid           ? ${cs}_mpubase_reg_d_inst_nxt : 
                                      ${cs}_mpubase_reg_d");
    }

    if ($mpuacc_reg) {



        my $wr_en_expr =
            "${cs}_en &
              (${cs}_mpu_rd_operation |
               (${wss}_wrctl_mpuacc & ${wss}_valid) |
               ${wss}_exc_crst_active)";



        if ($mpuacc_reg_limit) {
            set_control_reg_field_input_expr($mpuacc_reg_limit,
              "${wss}_exc_crst_active   ? 0 :
               ${cs}_dmpu_rd_operation  ? dmpu_rd_limit :
               ${cs}_impu_rd_operation  ? impu_rd_limit :
                                          ${wdata}_mpuacc_reg_limit");
            set_control_reg_field_wr_en_expr($mpuacc_reg_limit, 
              $wr_en_expr);
            set_control_reg_field_testbench_expr($mpuacc_reg_limit,
              "${cs}_mpu_rd_operation ? ${cs}_mpuacc_reg_limit_nxt :
                                        ${cs}_mpuacc_reg_limit");
        }

        if ($mpuacc_reg_mask) {
            set_control_reg_field_input_expr($mpuacc_reg_mask,
              "${wss}_exc_crst_active   ? 0 :
               ${cs}_dmpu_rd_operation  ? dmpu_rd_mask :
               ${cs}_impu_rd_operation  ? impu_rd_mask :
                                          ${wdata}_mpuacc_reg_mask");
            set_control_reg_field_wr_en_expr($mpuacc_reg_mask, 
              $wr_en_expr);
            set_control_reg_field_testbench_expr($mpuacc_reg_mask,
              "${cs}_mpu_rd_operation ? ${cs}_mpuacc_reg_mask_nxt :
                                        ${cs}_mpuacc_reg_mask");
        }



        set_control_reg_field_input_expr($mpuacc_reg_mt,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_dmpu_rd_operation  ? dmpu_rd_mt :
             ${cs}_impu_rd_operation  ? 0 :
                                        ${wdata}_mpuacc_reg_mt");
        set_control_reg_field_wr_en_expr($mpuacc_reg_mt, $wr_en_expr);
        set_control_reg_field_testbench_expr($mpuacc_reg_mt,
          "${cs}_mpu_rd_operation ? ${cs}_mpuacc_reg_mt_nxt :
                                    ${cs}_mpuacc_reg_mt");


        if ($mpuacc_reg_s) {
            set_control_reg_field_input_expr($mpuacc_reg_s,
                "${wss}_exc_crst_active   ? 0 :
                 ${cs}_dmpu_rd_operation  ? dmpu_rd_s :
                 ${cs}_impu_rd_operation  ? 0 :
                                        ${wdata}_mpuacc_reg_s");
            set_control_reg_field_wr_en_expr($mpuacc_reg_s, $wr_en_expr);
        }

        set_control_reg_field_input_expr($mpuacc_reg_perm,
            "${wss}_exc_crst_active   ? 0 :
             ${cs}_dmpu_rd_operation  ? dmpu_rd_perm :
             ${cs}_impu_rd_operation  ? impu_rd_perm :
                                        ${wdata}_mpuacc_reg_perm");
        set_control_reg_field_wr_en_expr($mpuacc_reg_perm, $wr_en_expr);
        set_control_reg_field_testbench_expr($mpuacc_reg_perm,
          "${cs}_mpu_rd_operation ? ${cs}_mpuacc_reg_perm_nxt :
                                    ${cs}_mpuacc_reg_perm");
    }

    if ($mpu_present) {



        e_assign->adds(


          [["${wss}_impu_rd_operation", 1],
            "${wss}_wrctl_mpuacc & ${wdata}_mpuacc_reg_rd &
             ${wss}_valid & ~${cs}_mpubase_reg_d"],
        


          [["${wss}_dmpu_rd_operation", 1],
            "${wss}_wrctl_mpuacc & ${wdata}_mpuacc_reg_rd &
             ${wss}_valid & ${cs}_mpubase_reg_d"],

          [["${cs}_mpu_rd_operation", 1], 
            "${cs}_impu_rd_operation | ${cs}_dmpu_rd_operation"],



          [["${wss}_impu_wr_operation", 1],
            "${wss}_wrctl_mpuacc & ${wdata}_mpuacc_reg_wr &
             ${wss}_valid & ~${cs}_mpubase_reg_d"],
        


          [["${wss}_dmpu_wr_operation", 1],
            "${wss}_wrctl_mpuacc & ${wdata}_mpuacc_reg_wr &
             ${wss}_valid & ${cs}_mpubase_reg_d"],
        );

        e_register->adds(

          {out => ["${cs}_impu_rd_operation", 1], 
           in => "${wss}_impu_rd_operation", enable => "${cs}_en"},
          {out => ["${cs}_dmpu_rd_operation", 1], 
           in => "${wss}_dmpu_rd_operation", enable => "${cs}_en"},
          {out => ["${cs}_impu_wr_operation", 1], 
           in => "${wss}_impu_wr_operation", enable => "${cs}_en"},
          {out => ["${cs}_dmpu_wr_operation", 1], 
           in => "${wss}_dmpu_wr_operation", enable => "${cs}_en"},
        );
    }

    if ($eccinj_reg) {
        if ($eccinj_reg_rf) {

            set_control_reg_field_input_expr($eccinj_reg_rf,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_rf :
                 rf_wr_port_en                        ? 0 :
                                                        ${cs}_eccinj_reg_rf");
            set_control_reg_field_wr_en_expr($eccinj_reg_rf, "W_en | rf_wr_port_en");
            

            e_signal->adds(
             { name => "W_rf_injs", width => 1, never_export => 1 },
             { name => "W_rf_injd", width => 1, never_export => 1 },
            );
    
            e_assign->adds(
                 ["W_rf_injs", "${cs}_eccinj_reg_rf[0]"],
                 ["W_rf_injd", "${cs}_eccinj_reg_rf[1]"],
            );
        }

        if ($eccinj_reg_ictag) {
            set_control_reg_field_input_expr($eccinj_reg_ictag,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_ictag :
                 (ic_fill_done & ic_inject_en)        ? 0 :
                                                        ${cs}_eccinj_reg_ictag");
            set_control_reg_field_wr_en_expr($eccinj_reg_ictag, "W_en | ic_inject_en");

            e_assign->adds(
                 ["W_ic_tag_injs", "${cs}_eccinj_reg_ictag[0]"],
                 ["W_ic_tag_injd", "${cs}_eccinj_reg_ictag[1]"],
            );

            e_signal->adds(
                { name => "W_ic_tag_injs", width => 1, never_export => 1 },
                { name => "W_ic_tag_injd", width => 1, never_export => 1 },
            );
        }
            
        if ($eccinj_reg_icdat) {
            set_control_reg_field_input_expr($eccinj_reg_icdat,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_icdat :
                 (ic_data_wren & ic_inject_en)        ? 0 :
                                                        ${cs}_eccinj_reg_icdat");
            set_control_reg_field_wr_en_expr($eccinj_reg_icdat, "W_en | ic_inject_en");

            e_assign->adds(
                 ["W_ic_data_injs", "${cs}_eccinj_reg_icdat[0]"],
                 ["W_ic_data_injd", "${cs}_eccinj_reg_icdat[1]"],
            );
            
            e_signal->adds(
                { name => "W_ic_data_injs", width => 1, never_export => 1 },
                { name => "W_ic_data_injd", width => 1, never_export => 1 },
            );
        }

        if ($eccinj_reg_dctag) {
            set_control_reg_field_input_expr($eccinj_reg_dctag,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_dctag :
                 dc_tag_wr_port_en                    ? 0 :
                                                        ${cs}_eccinj_reg_dctag");
            set_control_reg_field_wr_en_expr($eccinj_reg_dctag, "W_en | dc_tag_wr_port_en");

            e_assign->adds(
                 ["W_dc_tag_injs", "${cs}_eccinj_reg_dctag[0]"],
                 ["W_dc_tag_injd", "${cs}_eccinj_reg_dctag[1]"],
            );

            e_signal->adds(
             { name => "W_dc_tag_injs", width => 1, never_export => 1 },
             { name => "W_dc_tag_injd", width => 1, never_export => 1 },
            );
        }
            
        if ($eccinj_reg_dcdat) {
            set_control_reg_field_input_expr($eccinj_reg_dcdat,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_dcdat :
                 dc_data_wr_port_en                   ? 0 :
                                                        ${cs}_eccinj_reg_dcdat");
            set_control_reg_field_wr_en_expr($eccinj_reg_dcdat, "W_en | dc_data_wr_port_en");

            e_assign->adds(
                 ["W_dc_data_injs", "${cs}_eccinj_reg_dcdat[0]"],
                 ["W_dc_data_injd", "${cs}_eccinj_reg_dcdat[1]"],
            );


            e_signal->adds(
             { name => "W_dc_data_injs", width => 1, never_export => 1 },
             { name => "W_dc_data_injd", width => 1, never_export => 1 },
            );
        }

        if ($eccinj_reg_dcwb) {
            set_control_reg_field_input_expr($eccinj_reg_dcwb,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_dcwb :
                 dc_wb_wr_port_en                     ? 0 :
                                                        ${cs}_eccinj_reg_dcwb");
            set_control_reg_field_wr_en_expr($eccinj_reg_dcwb, "W_en | dc_wb_wr_port_en");

            e_assign->adds(
                 ["W_dc_wb_injs", "${cs}_eccinj_reg_dcwb[0]"],
                 ["W_dc_wb_injd", "${cs}_eccinj_reg_dcwb[1]"],
            );

            e_signal->adds(
             { name => "W_dc_wb_injs", width => 1, never_export => 1 },
             { name => "W_dc_wb_injd", width => 1, never_export => 1 },
            );
        }

        if ($eccinj_reg_tlb) {





            set_control_reg_field_input_expr($eccinj_reg_tlb,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_tlb :
                 tlb_wr_en                            ? 0 :
                                                        ${cs}_eccinj_reg_tlb");
            set_control_reg_field_wr_en_expr($eccinj_reg_tlb, "W_en | tlb_wr_en");

            e_assign->adds(
                 ["W_tlb_injs", "${cs}_eccinj_reg_tlb[0]"],
                 ["W_tlb_injd", "${cs}_eccinj_reg_tlb[1]"],
            );
            

            e_signal->adds(
             { name => "W_tlb_injs", width => 1, never_export => 1 },
             { name => "W_tlb_injd", width => 1, never_export => 1 },
            );
        }
        
        if ($eccinj_reg_dtcm0) {
            set_control_reg_field_input_expr($eccinj_reg_dtcm0,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_dtcm0 :
                 dtcm0_write                           ? 0 :
                                                        ${cs}_eccinj_reg_dtcm0");
            set_control_reg_field_wr_en_expr($eccinj_reg_dtcm0, "W_en | dtcm0_write");

            e_assign->adds(
                 ["W_dtcm0_injs", "${cs}_eccinj_reg_dtcm0[0]"],
                 ["W_dtcm0_injd", "${cs}_eccinj_reg_dtcm0[1]"],
            );
            

            e_signal->adds(
             { name => "W_dtcm0_injs", width => 1, never_export => 1 },
             { name => "W_dtcm0_injd", width => 1, never_export => 1 },
            );
        }
        
        if ($eccinj_reg_dtcm1) {
            set_control_reg_field_input_expr($eccinj_reg_dtcm1,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_dtcm1 :
                 dtcm1_write                           ? 0 :
                                                        ${cs}_eccinj_reg_dtcm1");
            set_control_reg_field_wr_en_expr($eccinj_reg_dtcm1, "W_en | dtcm1_write");

            e_assign->adds(
                 ["W_dtcm1_injs", "${cs}_eccinj_reg_dtcm1[0]"],
                 ["W_dtcm1_injd", "${cs}_eccinj_reg_dtcm1[1]"],
            );
            

            e_signal->adds(
             { name => "W_dtcm1_injs", width => 1, never_export => 1 },
             { name => "W_dtcm1_injd", width => 1, never_export => 1 },
            );
        }
        
        if ($eccinj_reg_dtcm2) {
            set_control_reg_field_input_expr($eccinj_reg_dtcm2,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_dtcm2 :
                 dtcm2_write                           ? 0 :
                                                        ${cs}_eccinj_reg_dtcm2");
            set_control_reg_field_wr_en_expr($eccinj_reg_dtcm2, "W_en | dtcm2_write");

            e_assign->adds(
                 ["W_dtcm2_injs", "${cs}_eccinj_reg_dtcm2[0]"],
                 ["W_dtcm2_injd", "${cs}_eccinj_reg_dtcm2[1]"],
            );
            

            e_signal->adds(
             { name => "W_dtcm2_injs", width => 1, never_export => 1 },
             { name => "W_dtcm2_injd", width => 1, never_export => 1 },
            );
        }
        
        if ($eccinj_reg_dtcm3) {
            set_control_reg_field_input_expr($eccinj_reg_dtcm3,
                "${wss}_exc_crst_active               ? 0 :
                 (${wss}_valid & ${wss}_wrctl_eccinj) ? ${wdata}_eccinj_reg_dtcm3 :
                 dtcm3_write                           ? 0 :
                                                        ${cs}_eccinj_reg_dtcm3");
            set_control_reg_field_wr_en_expr($eccinj_reg_dtcm3, "W_en | dtcm3_write");

            e_assign->adds(
                 ["W_dtcm3_injs", "${cs}_eccinj_reg_dtcm3[0]"],
                 ["W_dtcm3_injd", "${cs}_eccinj_reg_dtcm3[1]"],
            );
            

            e_signal->adds(
             { name => "W_dtcm3_injs", width => 1, never_export => 1 },
             { name => "W_dtcm3_injd", width => 1, never_export => 1 },
            );
        }
    }

    if ($debugger_present) { 

        if (manditory_int($Opt, "internal_irq_mask") == 0) {


            if ($oci_version == 2) {
                e_assign->adds(
                  [["oci_idisable_dummy_sink", 1, 0, $force_never_export], 
                    "oci_idisable"],
                );
            } else {
                e_assign->adds(
                  [["oci_ienable_dummy_sink", 32, 0, $force_never_export], 
                    "oci_ienable"],
                );
            }
               
        }
    } else {

        if ($oci_version == 2) {
            e_assign->adds(
              [["oci_idisable", 1, 0, $force_never_export], "1'b0"],
            );    
        } else {
            e_assign->adds(
              [["oci_ienable", 32, 0, $force_never_export], "{32{1'b1}}"],
            );
        }
    }

    if ($cdsr_reg_status) {

       e_signal->adds({name => "${wss}_wrctl_data_cdsr_reg_status", never_export => 1, width => 32});
       e_signal->adds({name => "${wss}_wrctl_cdsr", never_export => 1, width => 1});


       set_control_reg_field_input_expr($cdsr_reg_status,
           ($oci_version == 2 & $oci_present) ? "{31'h0,host_present}" : "0");
    }

    if ($oci_version == 2) {
    	if ($oci_present) {
        	if ($cdsr_reg_status) {
        	        e_assign->adds(

        	          [["${cs}_host_data_register_nxt", $cdsr_reg_status_sz],
        	            "${wss}_wrctl_cdsr ? ${wdata}_cdsr_reg_status :
        	                                 ${cs}_host_data_register"],
        	        );
        	



        	        e_register->adds(
        	          {out => ["${cs}_host_data_register", $cdsr_reg_status_sz],
        	           in => "${wss}_exc_crst_active ? 0 :
        	                  host_data_reg_write    ? host_data_reg_writedata :
        	                  ${wss}_valid           ? ${cs}_host_data_register_nxt : 
        	                                           ${cs}_host_data_register",       
        	           enable => "${cs}_en" },
        	        );
        	}
        } else {
        	e_register->adds(
        	  {out => ["${cs}_host_data_register", $cdsr_reg_status_sz],
        	   in => "0",       
        	   enable => "${cs}_en" },
        	);
        }
    }


    my %rdctl_info = (



      "D" => [$status_reg, $estatus_reg, $bstatus_reg, $ienable_reg,
               $ipending_reg, $cpuid_reg, $cdsr_reg],



      "E" => "remaining",
    );


    if (!defined(gen_control_regs($control_regs, 
      \&nios_europa_assignment, \&nios_europa_register, 
      \&nios_europa_binary_mux, \%rdctl_info))) {
        &$error("$whoami: gen_control_regs() failed");
    }

    my @control_registers = (
        { divider => "control_registers" },
        { radix => "x", signal => "${rs}_ctrl_rd_ctl_reg" },
        { radix => "x", signal => "${rs}_valid" },
        { radix => "x", signal => "${rs}_iw_control_regnum" },
        { radix => "x", signal => "${rs}_rdctl_data" },
        { radix => "x", signal => "${wss}_ctrl_wrctl_inst" },
        { radix => "x", signal => "${wss}_valid" },
        { radix => "x", signal => "${wss}_iw_control_regnum" },
        { radix => "x", signal => "${wss}_wrctl_status" },
        { radix => "x", signal => "${wss}_wrctl_estatus" },
        { radix => "x", signal => "${wss}_wrctl_bstatus" },
        { radix => "x", signal => "${wss}_ctrl_exception" },
        { radix => "x", signal => "${wss}_op_intr" },
        { radix => "x", signal => "${wss}_op_trap" },
        { radix => "x", signal => "${wss}_op_break" },
        { radix => "x", signal => "${wss}_op_hbreak" },
        { radix => "x", signal => "${wss}_op_eret" },
        { radix => "x", signal => "${wss}_op_bret" },
        { radix => "x", signal => "${wss}_eret_src" },
        { radix => "x", signal => "${cs}_status_reg_pie_inst_nxt" },
        @{get_control_regs_for_waves($control_regs)},
    );

    push(@plaintext_wave_signals, @control_registers);
}


sub 
be_make_custom_instruction_master
{
    my $Opt = shift;


    my $cs = not_empty_scalar($Opt, "ci_combo_stage");
    my $ms = not_empty_scalar($Opt, "ci_multi_stage");
    my $control_reg_stage = not_empty_scalar($Opt, "control_reg_stage");

    my $ci_ports = 
        {
            clk      => "clk",
        };

    if ($cs eq $ms) {

        &$error("Must have different combo and multi custom instruciton stages");
    } else {

        if (nios2_custom_insts::has_combo_insts($Opt->{custom_instructions})) {
            e_signal->adds(
              {name => "${cs}_ci_combo_result", width => $datapath_sz },
            );
    

            $ci_ports->{"${cs}_ci_combo_dataa"} = "combo_dataa";
            $ci_ports->{"${cs}_ci_combo_datab"} = "combo_datab";
            $ci_ports->{"${cs}_ci_combo_ipending"} = "combo_ipending";
            $ci_ports->{"${cs}_ci_combo_status"} = "combo_status";
            $ci_ports->{"${cs}_ci_combo_estatus"} = "combo_estatus";
            $ci_ports->{"${cs}_ci_combo_n"} = "combo_n";
            $ci_ports->{"${cs}_ci_combo_a"} = "combo_a";
            $ci_ports->{"${cs}_ci_combo_b"} = "combo_b";
            $ci_ports->{"${cs}_ci_combo_c"} = "combo_c";
            $ci_ports->{"${cs}_ci_combo_readra"} = "combo_readra";
            $ci_ports->{"${cs}_ci_combo_readrb"} = "combo_readrb";
            $ci_ports->{"${cs}_ci_combo_writerc"} = "combo_writerc";
            $ci_ports->{"${cs}_ci_combo_result"} = "combo_result";
    

            e_assign->adds(
              [["${cs}_ci_combo_dataa", $datapath_sz], "${cs}_src1"],
              [["${cs}_ci_combo_datab", $datapath_sz], "${cs}_src2"],
              [["${cs}_ci_combo_ipending", $interrupt_sz], 
                "${control_reg_stage}_ipending_reg"],
              [["${cs}_ci_combo_status", $status_reg_pie_sz], 
                "${control_reg_stage}_status_reg[$status_reg_pie_lsb]"],
              [["${cs}_ci_combo_estatus", $status_reg_pie_sz], 
                "${control_reg_stage}_estatus_reg[$status_reg_pie_lsb]"],
              [["${cs}_ci_combo_n", $iw_custom_n_sz], "${cs}_iw_custom_n"],
              [["${cs}_ci_combo_a", $iw_a_sz], "${cs}_iw_a"],
              [["${cs}_ci_combo_b", $iw_b_sz], "${cs}_iw_b"],
              [["${cs}_ci_combo_c", $iw_c_sz], "${cs}_iw_c"],
              [["${cs}_ci_combo_readra", 1], "${cs}_iw_custom_readra"],
              [["${cs}_ci_combo_readrb", 1], "${cs}_iw_custom_readrb"],
              [["${cs}_ci_combo_writerc", 1], "${cs}_iw_custom_writerc"],
            );
    

            push(@{$Opt->{port_list}},
              ["${cs}_ci_combo_dataa"   => $datapath_sz,        "out" ],
              ["${cs}_ci_combo_datab"   => $datapath_sz,        "out" ],
              ["${cs}_ci_combo_ipending"=> $interrupt_sz,       "out" ],
              ["${cs}_ci_combo_status"  => $status_reg_pie_sz,  "out" ],
              ["${cs}_ci_combo_estatus" => $status_reg_pie_sz,  "out" ],
              ["${cs}_ci_combo_n"       => $iw_custom_n_sz,     "out" ],
              ["${cs}_ci_combo_a"       => $iw_a_sz,            "out" ],
              ["${cs}_ci_combo_b"       => $iw_b_sz,            "out" ],
              ["${cs}_ci_combo_c"       => $iw_c_sz,            "out" ],
              ["${cs}_ci_combo_readra"  => 1,                   "out" ],
              ["${cs}_ci_combo_readrb"  => 1,                   "out" ],
              ["${cs}_ci_combo_writerc" => 1,                   "out" ],
              ["${cs}_ci_combo_result"  => $datapath_sz,        "in"  ],
            );
    
            my @ci_combo = (
                { divider => "combinatorial_custom_instruction" },
                { radix => "x", signal => "${cs}_ctrl_custom_combo" },
                { radix => "x", signal => "${cs}_ci_combo_dataa" },
                { radix => "x", signal => "${cs}_ci_combo_datab" },
                { radix => "x", signal => "${cs}_ci_combo_ipending" },
                { radix => "x", signal => "${cs}_ci_combo_status" },
                { radix => "x", signal => "${cs}_ci_combo_estatus" },
                { radix => "x", signal => "${cs}_ci_combo_n" },
                { radix => "x", signal => "${cs}_ci_combo_readra" },
                { radix => "x", signal => "${cs}_ci_combo_readrb" },
                { radix => "x", signal => "${cs}_ci_combo_writerc" },
                { radix => "x", signal => "${cs}_ci_combo_result" },
            );
    
            push(@plaintext_wave_signals, @ci_combo);
        }
    
        if (nios2_custom_insts::has_multi_insts($Opt->{custom_instructions})) {

            $ci_ports->{"${ms}_ci_multi_dataa"} = "multi_dataa";
            $ci_ports->{"${ms}_ci_multi_datab"} = "multi_datab";
            $ci_ports->{"${ms}_ci_multi_ipending"} = "multi_ipending";
            $ci_ports->{"${ms}_ci_multi_status"} = "multi_status";
            $ci_ports->{"${ms}_ci_multi_estatus"} = "multi_estatus";
            $ci_ports->{"${ms}_ci_multi_n"} = "multi_n";
            $ci_ports->{"${ms}_ci_multi_a"} = "multi_a";
            $ci_ports->{"${ms}_ci_multi_b"} = "multi_b";
            $ci_ports->{"${ms}_ci_multi_c"} = "multi_c";
            $ci_ports->{"${ms}_ci_multi_readra"} = "multi_readra";
            $ci_ports->{"${ms}_ci_multi_readrb"} = "multi_readrb";
            $ci_ports->{"${ms}_ci_multi_writerc"} = "multi_writerc";
            $ci_ports->{"${ms}_ci_multi_result"} = "multi_result";
            $ci_ports->{"${ms}_ci_multi_clk_en"} = "multi_clk_en";
            $ci_ports->{"${ms}_ci_multi_clock"} = "multi_clk";
            $ci_ports->{"${ms}_ci_multi_reset"} = "multi_reset";
            $ci_ports->{"${ms}_ci_multi_reset_req"} = "multi_reset_req";
            $ci_ports->{"${ms}_ci_multi_start"} = "multi_start";
            $ci_ports->{"${ms}_ci_multi_done"} = "multi_done";
    

            e_assign->adds(
              [["${ms}_ci_multi_dataa", $datapath_sz], "${ms}_ci_multi_src1"],
              [["${ms}_ci_multi_datab", $datapath_sz], "${ms}_ci_multi_src2"],
              [["${ms}_ci_multi_ipending", $interrupt_sz],
                "${ms}_ci_multi_ipending"],
              [["${ms}_ci_multi_status", $status_reg_pie_sz],
                "${ms}_ci_multi_status"],
              [["${ms}_ci_multi_estatus", $status_reg_pie_sz],
                "${ms}_ci_multi_estatus"],
              [["${ms}_ci_multi_n", $iw_custom_n_sz], "${ms}_iw_custom_n"],
              [["${ms}_ci_multi_a", $iw_a_sz], "${ms}_iw_a"],
              [["${ms}_ci_multi_b", $iw_b_sz], "${ms}_iw_b"],
              [["${ms}_ci_multi_c", $iw_c_sz], "${ms}_iw_c"],
              [["${ms}_ci_multi_readra", 1], "${ms}_iw_custom_readra"],
              [["${ms}_ci_multi_readrb", 1], "${ms}_iw_custom_readrb"],
              [["${ms}_ci_multi_writerc", 1], "${ms}_iw_custom_writerc"],
            );
    

            push(@{$Opt->{port_list}},
              ["${ms}_ci_multi_dataa"   => $datapath_sz,        "out" ],
              ["${ms}_ci_multi_datab"   => $datapath_sz,        "out" ],
              ["${ms}_ci_multi_ipending"=> $interrupt_sz,       "out" ],
              ["${ms}_ci_multi_status"  => $status_reg_pie_sz,  "out" ],
              ["${ms}_ci_multi_estatus" => $status_reg_pie_sz,  "out" ],
              ["${ms}_ci_multi_n"       => $iw_custom_n_sz,     "out" ],
              ["${ms}_ci_multi_a"       => $iw_a_sz,            "out" ],
              ["${ms}_ci_multi_b"       => $iw_b_sz,            "out" ],
              ["${ms}_ci_multi_c"       => $iw_c_sz,            "out" ],
              ["${ms}_ci_multi_readra"  => 1,    "out" ],
              ["${ms}_ci_multi_readrb"  => 1,    "out" ],
              ["${ms}_ci_multi_writerc" => 1,    "out" ],
              ["${ms}_ci_multi_result"  => $datapath_sz,        "in"  ],
              ["${ms}_ci_multi_clk_en"  => 1,                   "out" ],
              ["${ms}_ci_multi_start"   => 1,                   "out" ],
              ["${ms}_ci_multi_done"    => 1,                   "in"  ],
            );
    
            my @ci_multi = (
                { divider => "multicycle_custom_instruction" },
                { radix => "x", signal => "${ms}_ctrl_custom_multi" },
                { radix => "x", signal => "${ms}_ci_multi_dataa" },
                { radix => "x", signal => "${ms}_ci_multi_datab" },
                { radix => "x", signal => "${ms}_ci_multi_ipending" },
                { radix => "x", signal => "${ms}_ci_multi_status" },
                { radix => "x", signal => "${ms}_ci_multi_estatus" },
                { radix => "x", signal => "${ms}_ci_multi_n" },
                { radix => "x", signal => "${ms}_ci_multi_readra" },
                { radix => "x", signal => "${ms}_ci_multi_readrb" },
                { radix => "x", signal => "${ms}_ci_multi_writerc" },
                { radix => "x", signal => "${ms}_ci_multi_result" },
                { radix => "x", signal => "${ms}_ci_multi_clk_en" },
                { radix => "x", signal => "${ms}_ci_multi_start" },
                { radix => "x", signal => "${ms}_ci_multi_done" },
                { radix => "x", signal => "${ms}_ci_multi_stall" },
            );
    
            push(@plaintext_wave_signals, @ci_multi);
        }
    }


    e_custom_instruction_master->add ({
        name     => "custom_instruction_master",
        type_map => $ci_ports,
    });
}




sub 
be_make_alu
{
    my $Opt = shift;

    my $rdctl_stage = not_empty_scalar($Opt, "rdctl_stage");

    my $core_type = not_empty_scalar($Opt, "core_type");
    my $is_small = ($core_type eq "small");
    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");
    my $r2 = ($cpu_arch_rev == 2);





    e_assign->adds(

      [["E_arith_src1", $datapath_sz], 
        "{ E_src1[$datapath_msb] ^ E_ctrl_alu_signed_comparison, 
           E_src1[$datapath_msb-1:0]}"],
      [["E_arith_src2", $datapath_sz], 
        "{ E_src2[$datapath_msb] ^ E_ctrl_alu_signed_comparison, 
           E_src2[$datapath_msb-1:0]}"],



      [["E_arith_result", $datapath_sz+1],
        "E_ctrl_alu_subtract ?
                       E_arith_src1 - E_arith_src2 :
                       E_arith_src1 + E_arith_src2"],







      [["E_mem_baddr_corrupt", 1], "E_src1_corrupt"],
    );
    
    if ($is_small) {
        e_assign->adds(



          [["D_src2_mem_imm", $datapath_sz], 
            $cdx_present ? "D_ctrl_src2_choose_cdx_imm ? D_src2_imm_cdx_inst : D_src2_imm_32b_inst" : "D_src2_imm_32b_inst"],
          
          [["D_mem_baddr_lo", 17], 
            "D_src1[15:0] + D_src2_mem_imm[15:0]"],
          [["D_mem_baddr_hi_plus_one", 16], 
            "D_src1[31:16] + D_src2_mem_imm[31:16] + 1"],
          [["D_mem_baddr_hi", 16], 
            "D_src1[31:16] + D_src2_mem_imm[31:16]"],
          

          [["D_mem_baddr", $datapath_sz], 
            "{(D_mem_baddr_lo[16] ? D_mem_baddr_hi_plus_one : D_mem_baddr_hi), D_mem_baddr_lo[15:0]}"],
        );
        

        e_register->adds(
          { out => ["E_mem_baddr", $mem_baddr_sz], 
            in => "D_mem_baddr[$mem_baddr_sz-1:0]",
            enable => "E_en", },
        );
    } else {
        e_assign->adds(

          [["E_mem_baddr", $mem_baddr_sz], "E_arith_result[$mem_baddr_sz-1:0]"],
        );
    }

    e_register->adds(
      { out => ["M_mem_baddr_corrupt", 1, 0, $force_never_export], 
        in => "E_mem_baddr_corrupt",
        enable => "M_en", },
    );
 




    e_mux->add ({
      lhs => ["E_logic_result", $datapath_sz],
      selecto => "E_logic_op",
      table => [
        "$logic_op_nor" => "~(E_src1 | E_src2)",    # NOR
        "$logic_op_and" => "  E_src1 & E_src2 ",    # AND
        "$logic_op_or"  => "  E_src1 | E_src2 ",    # OR
        "$logic_op_xor" => "  E_src1 ^ E_src2 ",    # XOR, and br/cmp with eq/ne
        ],
      });






    e_assign->adds(
      [["E_eq", 1],    "E_src1_eq_src2"],
      [["E_lt", 1],    "E_arith_result[$datapath_msb+1]"],
      );

    e_mux->add({
      lhs   => ["E_cmp_result", 1],
      selecto => "E_compare_op",
      table => [
        "$compare_op_eq"     => "E_eq",
        "$compare_op_ge"     => "~E_lt",
        "$compare_op_lt"     => "E_lt",
        "$compare_op_ne"     => "~E_eq",
       ],
      });

    e_assign->adds(
      [["E_br_result", 1], "E_cmp_result"],
    );







    my $alu_result_mux_table = [];

    push(@$alu_result_mux_table,
      "E_ctrl_cmp"          => "{31'b0, E_cmp_result}",
    );

    if ($rdctl_stage eq "E") {
        push(@$alu_result_mux_table,
          "E_ctrl_rd_ctl_reg"            => "E_rdctl_data",
        );
    }


    push(@$alu_result_mux_table,
      "E_ctrl_logic"                     => "E_logic_result",
    );
    if ($is_small) {
    	my $remainder_pc_bits = 32 - $pch_sz - 1;
        push(@$alu_result_mux_table,
          "E_ctrl_retaddr"                   => $remainder_pc_bits > 0 ? "{{${remainder_pc_bits}{1'b0}},{E_extra_pc, 1'b0}}" : "{E_extra_pc, 1'b0}",
        );
    } else {
    	my $remainder_pc_bits = 32 - $pc_sz - 2;
        push(@$alu_result_mux_table,
          "E_ctrl_retaddr"                   => $remainder_pc_bits > 0 ? "{{${remainder_pc_bits}{1'b0}},{E_extra_pc, 2'b00}}" : "{E_extra_pc, 2'b00}",
        );    
    }
    push(@$alu_result_mux_table,
      "E_ctrl_st_ex"                     => "{31'b0, E_up_ex_mon_state_latest}",
    );


    if ($Opt->{long_latency_output_stage} eq "E" ) {
        if ($bmx_present) {
            push(@$alu_result_mux_table,
              "E_ctrl_shift_rot|E_op_merge" => "E_shift_rot_bmx_result"
            );
        } else {
            push(@$alu_result_mux_table,
              "E_ctrl_shift_rot" => "E_shift_rot_bmx_result"
            );    
        }
    }
   
    if (nios2_custom_insts::has_combo_insts($Opt->{custom_instructions})) {
      push(@$alu_result_mux_table,
        "E_ctrl_custom_combo"            => "E_ci_combo_result",
      );
    }

    e_mux->add({
      lhs   => ["E_alu_result", $datapath_sz],
      type  => "and_or",
      table => $alu_result_mux_table,
      default => "E_arith_result[$datapath_msb:0]",
      });

    my @alu = (
        { divider => "alu" },
        { radix => "x", signal => "clk" },
        { radix => "x", signal => "E_src1" },
        { radix => "x", signal => "E_src2" },
        { radix => "x", signal => "E_arith_src1" },
        { radix => "x", signal => "E_arith_src2" },
        { radix => "x", signal => "E_ctrl_alu_signed_comparison" },
        { radix => "x", signal => "E_arith_result" },
        { radix => "x", signal => "E_logic_result" },
        { radix => "x", signal => "E_compare_op" },
        { radix => "x", signal => "E_cmp_result" },
        { radix => "x", signal => "E_alu_result" },
        { radix => "x", signal => "E_ctrl_cmp" },
        { radix => "x", signal => "E_ctrl_logic" },
        { radix => "x", signal => "E_ctrl_retaddr" },
      );

    push(@plaintext_wave_signals, @alu);
}




sub 
be_make_stdata
{
    my $Opt = shift;






    if ($big_endian) {
      e_assign->adds(
        [["E_sth_data", 16], "{E_src2_reg[7:0],E_src2_reg[15:8]}"],
        [["E_stw_data", 32], "{E_src2_reg[7:0],E_src2_reg[15:8],
           E_src2_reg[23:16],E_src2_reg[31:24]}"],
        );
    } else {
      e_assign->adds(
        [["E_sth_data", 16], "E_src2_reg[15:0]"],
        [["E_stw_data", 32], "E_src2_reg[31:0]"],
        );
    }

    e_assign->adds(
       [["E_stb_data", 8],  "E_src2_reg[7:0]"],
    );
  

    if (!$dtcm_present) {


        e_mux->add({
          lhs   => ["E_st_data", $datapath_sz],
          type  => "priority",
          table => [
            "E_ctrl_mem8"    => "{E_stb_data, E_stb_data, E_stb_data, E_stb_data}",
            "E_ctrl_mem16"   => "{E_sth_data, E_sth_data}",
            "1'b1"      => "E_stw_data",
          ],
          });
    } else {



        e_mux->add({
          lhs   => ["E_st_data", $datapath_sz],
          selecto => "{E_ctrl_mem16, E_ctrl_mem8}",
          table => [
            "2'b01"  => 
              "{E_stb_data, E_stb_data, E_stb_data, E_stb_data}",
            "2'b10" => 
              "{E_sth_data, E_sth_data}",
            ],
          default => "E_stw_data",
          });
    }







    my $E_mem_byte_en_table = $big_endian ?
      [


        "{2'b01, 2'b00}" => "4'b1000",
        "{2'b01, 2'b01}" => "4'b0100",
        "{2'b01, 2'b10}" => "4'b0010",
        "{2'b01, 2'b11}" => "4'b0001",



        "{2'b10, 2'b00}" => "4'b1100",
        "{2'b10, 2'b01}" => "4'b1100",
        "{2'b10, 2'b10}" => "4'b0011",
        "{2'b10, 2'b11}" => "4'b0011",
      ] 
      :
      [


        "{2'b01, 2'b00}" => "4'b0001",
        "{2'b01, 2'b01}" => "4'b0010",
        "{2'b01, 2'b10}" => "4'b0100",
        "{2'b01, 2'b11}" => "4'b1000",



        "{2'b10, 2'b00}" => "4'b0011",
        "{2'b10, 2'b01}" => "4'b0011",
        "{2'b10, 2'b10}" => "4'b1100",
        "{2'b10, 2'b11}" => "4'b1100",
      ]; 

    e_mux->add ({
      lhs => ["E_mem_byte_en", $byte_en_sz],
      selecto => "{E_ctrl_mem16, E_ctrl_mem8, E_mem_baddr[1:0]}",
      table => $E_mem_byte_en_table,
      default => "4'b1111",
      });
}




sub 
be_make_hbreak
{
    my $Opt = shift;























    if ($hbreak_present) {







        e_assign->adds(
          [["hbreak_enabled", 1, 0, 1],"~W_debug_mode"],
        );

        if ($hbreak_test_bench) { 
            e_assign->adds(
              [["oci_tb_hbreak_req", 1, 0, 1],"(test_hbreak_req)"],
              [["oci_single_step_mode", 1, 0, 1],"1'b0"],
              [["oci_sync_hbreak_req", 1],"M_oci_sync_hbreak_req"],
            );
        } else {   #advanced exception
            e_assign->adds(
              [["oci_tb_hbreak_req", 1, 0, 1],"oci_async_hbreak_req"],
            );
        }
    





        e_assign->adds(
          [["hbreak_req", 1], 
             "(oci_tb_hbreak_req | latched_oci_tb_hbreak_req) 
               & hbreak_enabled
               & (~wait_for_one_post_bret_inst | ~A_one_post_bret_inst_n)"],
        );

        e_register->adds(
            { out => ["M_oci_sync_hbreak_req", 1], 
              in => "E_oci_sync_hbreak_req",
              enable => "M_en", 
            },
          );

        if ($hbreak_test_bench) { 
          e_assign->adds(

            [["M_hbreak_req", 1], "hbreak_req"],
          );
        } else {
          e_assign->adds(


            [["M_hbreak_req", 1], "(hbreak_req | M_oci_sync_hbreak_req)"],
          );
        }

        e_assign->adds(






          [["latched_oci_tb_hbreak_req_next", 1], 
            "latched_oci_tb_hbreak_req ? hbreak_enabled 
                                    : (hbreak_req)"],
        );

        e_register->adds(
          { out => ["latched_oci_tb_hbreak_req", 1, 0, 1], 
            in => "latched_oci_tb_hbreak_req_next",
            enable => "1'b1", 
            async_value => "1'b0"
          },
        );




















        
        e_assign->add(
          [["A_one_post_bret_inst_n", 1, 0, 1],
             "(oci_single_step_mode & 
                (~hbreak_enabled | ~(A_valid | A_exc_any_active)))"],
        );
        e_register->adds(
          { out => ["wait_for_one_post_bret_inst", 1, 0, 1], 
            in => "(~hbreak_enabled & oci_single_step_mode) ? 1'b1 
                    : ((~A_one_post_bret_inst_n) | 
                       (~oci_single_step_mode))             ? 1'b0 
                    : wait_for_one_post_bret_inst",
            enable => "1'b1", 
            async_value => "1'b0"
          },
        )
    } else {


      e_assign->adds(
        [["hbreak_enabled", 1, 0, $force_never_export],             "1'b0"],
        [["hbreak_req", 1, 0, $force_never_export],                 "1'b0"],
        [["latched_oci_tb_hbreak_req", 1, 0, $force_never_export],  "1'b0"],
        [["M_hbreak_req", 1, 0, $force_never_export],               "1'b0"],
      );
    }

    if ($debugger_present) {
        my @hbreak_waves = (
            { divider => "hbreak" },
            { radix => "x", signal => "hbreak_req" },
            { radix => "x", signal => "hbreak_enabled" },
            { radix => "x", signal => "wait_for_one_post_bret_inst" },
            { radix => "x", signal => "E_pc" },
        );

        push(@hbreak_waves,
          { radix => "x", signal => "oci_async_hbreak_req" },
          { radix => "x", signal => "E_oci_sync_hbreak_req" },
         );
      
        push(@plaintext_wave_signals, @hbreak_waves);
    }
}




sub 
be_make_cpu_reset
{
    my $Opt = shift;

    my $crst_taken = not_empty_scalar($Opt, "crst_taken");


    e_signal->adds(
      {name => "cpu_resettaken",   width => 1, export => $force_export },
    );


    e_assign->add(["cpu_resettaken", $crst_taken]);
    
    push(@{$Opt->{port_list}},
      ["cpu_resetrequest" => 1, "in" ],
      ["cpu_resettaken"   => 1, "out" ],
    );

    my @cpu_reset_waves = (
        { divider => "cpu_reset" },
        { radix => "x", signal => "cpu_resetrequest" },
        { radix => "x", signal => "cpu_resettaken" },
    );
   
    push(@plaintext_wave_signals, @cpu_reset_waves);
}

1;
