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






















package nios2_backend_400;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &nios2_be400_make_backend
    &nios2_be400_make_testbench
);

use e_custom_instruction_master;
use cpu_utils;
use cpu_wave_signals;
use cpu_control_reg;
use cpu_control_reg_gen;
use cpu_file_utils;
use cpu_gen;
use cpu_inst_gen;
use cpu_exception_gen;
use europa_all;
use europa_utils;
use e_atlantic_slave;
use nios_utils;
use nios_europa;
use nios_addr_utils;
use nios_testbench_utils;
use nios_sdp_ram;
use nios_register_file_ram;
use nios_avalon_masters;
use nios_brpred;
use nios_common;
use nios_isa;
use nios_shift_rotate;
use nios2_isa;
use nios2_insts;

use nios2_mmu;
use nios2_mpu;
use nios2_control_regs;
use nios2_exceptions;
use nios2_common;
use nios2_backend;
use nios2_custom_insts;

use strict;




































sub 
nios2_be400_make_backend
{
    my $Opt = shift;

    &$progress("    Pipeline backend");



    nios_brpred::gen_backend($Opt);

    make_base_pipeline($Opt);
    make_register_file($Opt);
    be_make_alu($Opt);
    be_make_stdata($Opt);
    be_make_hbreak_400($Opt);
    if ($cpu_reset) {
        be_make_cpu_reset($Opt);
    }
    make_reg_cmp($Opt);
    make_src_operands($Opt);
    make_cdx_multiple($Opt);
    make_alu_controls($Opt);
    if ($eic_present) {
        make_external_interrupt_controller($Opt);
    } else {
        make_internal_interrupt_controller($Opt);
    }

    nios_shift_rotate::gen_shift_rotate($Opt);

    if ($dtcm_present) {
        gen_dtcm_masters($Opt);
    }


    gen_master_mem($Opt);
   

    gen_dhp_master($Opt);
    gen_data_master($Opt);
    

    gen_slow_ld_aligner($Opt);
   
    if ($mpu_present) {
        &$progress("      DMPU");
        make_dmpu($Opt);
    }

    if (nios2_custom_insts::has_insts($Opt->{custom_instructions})) {
        make_custom_instruction_master($Opt);
    } else {
        my $is_hw_tcl_core = optional_bool($Opt, "hw_tcl_core");
        if ( $is_hw_tcl_core ) {
           
            my $ci_ports = { dummy_ci_port    => "combo_readra", };
            e_custom_instruction_master->add ({
                name     => "custom_instruction_master",
                type_map => $ci_ports,
            });
            
            e_assign->adds([["dummy_ci_port", 1], "1'b0"]);
        }
    }

    if (!manditory_bool($Opt, "simgen")) {
        make_potential_tb_logic($Opt);
    }

    be_make_control_regs($Opt);
}







sub 
nios2_be400_make_testbench
{
    my $Opt = shift;

    &$progress("    Testbench");

    my $whoami = "backend 400 testbench";

    my $submodule_name = $Opt->{name}."_test_bench";

    my $submodule = e_module->new({
      name        => $submodule_name,
      output_file => $submodule_name,
    });

    my $testbench_instance_name = "the_$submodule_name";
    my $testbench_instance = e_instance->add({
      module      => $submodule,
      name        => $testbench_instance_name,
    });

    my $marker = e_default_module_marker->new($submodule);

    my $gen_info = manditory_hash($Opt, "gen_info");

    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");

    my $r1 = ($cpu_arch_rev == 1);
    my $r2 = ($cpu_arch_rev == 2);





    cpu_inst_gen::gen_inst_decodes($gen_info, $Opt->{inst_desc_info},
      ["W"]);





    e_register->adds(
      {out => ["A_target_pcb", $pcb_sz, 0, $force_never_export],
       in => "M_target_pcb",            enable => "A_en"},
      {out => ["A_mem_baddr", $mem_baddr_sz, 0, $force_never_export],
       in => "M_mem_baddr",             enable => "A_en"},
      {out => ["W_wr_data_filtered", $datapath_sz, 0, $force_never_export], 
       in => "A_wr_data_filtered",  enable => "1'b1"},
      {out => ["W_st_data", $datapath_sz, 0, $force_never_export],
       in => "A_st_data",           enable => "1'b1"},
      {out => ["W_cmp_result", 1, 0, $force_never_export],
       in => "A_cmp_result",        enable => "1'b1"},
      {out => ["W_target_pcb", $pcb_sz, 0, $force_never_export],
       in => "A_target_pcb",        enable => "1'b1"},
      );

    my $A_hbreak_exc = $hbreak_present ? 
      get_exc_signal_name($hbreak_exc, "A") : "0";
    my $A_cpu_reset_exc = $cpu_reset ?
          get_exc_signal_name($cpu_reset_exc, "A") : "0";
    my $A_intr_exc = get_exc_signal_name(
      ($eic_present ? $ext_intr_exc : $norm_intr_exc), "A");


    e_register->adds(
      {out => ["W_valid_hbreak", 1, 0, $force_never_export],
       in => "$A_hbreak_exc & A_exc_allowed", 
       enable => "1'b1"},

      {out => ["W_valid_crst", 1, 0, $force_never_export],
           in => "$A_cpu_reset_exc & A_exc_allowed", 
           enable => "1'b1"},

      {out => ["W_valid_intr", 1, 0, $force_never_export],
       in => "$A_intr_exc & A_exc_allowed", 
       enable => "1'b1"},

      {out => ["W_exc_any_active", 1, 0, $force_never_export],
       in => "A_exc_any_active", 
       enable => "1'b1"},
    );

    e_register->adds(
      {out => ["W_exc_highest_pri_exc_id", 32, 0, $force_never_export],
       in => "A_exc_highest_pri_exc_id", 
       enable => "1'b1"},
    );

    if ($eic_present) {

        e_register->adds(
          {out => ["M_tb_eic_port_data", $eic_port_sz], 
           in => "eic_port_data", 
           enable => "M_en"},
          {out => ["A_tb_eic_port_data", $eic_port_sz], 
           in => "M_tb_eic_port_data", 
           enable => "A_en"},
          {out => ["W_tb_eic_port_data", $eic_port_sz], 
           in => "A_tb_eic_port_data", 
           enable => "W_en"},
        );


        e_assign->adds(
           [["W_tb_eic_ril", $eic_port_ril_sz, 0, $force_never_export], 
             "W_tb_eic_port_data[$eic_port_ril_msb:$eic_port_ril_lsb]"],
           [["W_tb_eic_rnmi", $eic_port_rnmi_sz, 0, $force_never_export],
             "W_tb_eic_port_data[$eic_port_rnmi_lsb]"],
           [["W_tb_eic_rrs", $eic_port_rrs_sz, 0, $force_never_export],
             "W_tb_eic_port_data[$eic_port_rrs_msb:$eic_port_rrs_lsb]"],
           [["W_tb_eic_rha", $eic_port_rha_sz, 0, $force_never_export],
             "W_tb_eic_port_data[$eic_port_rha_msb:$eic_port_rha_lsb]"],
        );
    }

    if ($eic_and_shadow) {
        e_register->adds(
          {out => ["W_tb_sstatus_reg", 32, 0, $force_never_export], 
           in => "W_sstatus_reg_nxt", 
           enable => "W_en"},
        );
    }








    if (manditory_bool($Opt, "simgen")) {
        make_potential_tb_logic($Opt);
    }
    
    e_signal->adds(
      {name => "W_dst_regnum", width => $regnum_sz},
    );

    my @x_signals = (
      { sig => "W_wr_dst_reg",                             },
      { sig => "W_dst_regnum", qual => "W_wr_dst_reg",     },
      { sig => "W_valid",                                  },
      { sig => "W_pcb",        qual => "W_valid",          },
      { sig => "W_iw",         qual => "W_valid",          },
      { sig => "A_en",                                     },
    );

    if ($shadow_present) {
        e_signal->adds(
          {name => "W_dst_regset", width => $rf_set_sz},
        );
        push(@x_signals,
          { sig => "W_dst_regset", qual => "W_wr_dst_reg", },
        );
    }

    if ($eic_present) {
        push(@x_signals,
          { sig => "eic_port_valid", },
          { sig => "eic_port_data_ril", 
            qual => "eic_port_valid" },
          { sig => "eic_port_data_rnmi", 
            qual => "eic_port_valid & (eic_port_data_ril != 0)" },
          { sig => "eic_port_data_rha", 
            qual => "eic_port_valid & (eic_port_data_ril != 0)" },
        );

        if ($shadow_present) {
            push(@x_signals,
              { sig => "eic_port_data_rrs", 
                qual => "eic_port_valid & (eic_port_data_ril != 0)" },
            );
        }
    }

    push(@x_signals,
      { sig => "M_valid",                                   },
      { sig => "A_valid",                                   },



        { sig => "W_status_reg",                        },
      { sig => "W_estatus_reg",                         },
      { sig => "W_bstatus_reg",                         },
    );

    if ($exception_reg) {
        push(@x_signals,
          { sig => "W_exception_reg",                   },
        );
    }

    push(@x_signals,
      { sig => "W_badaddr_reg",                     },
    );
   
    push(@x_signals,
      { sig => "A_exc_any_active",                      },
      { sig => "i_read",                                },
      { sig => "i_address",        qual => "i_read",        },
      { sig => "i_response",       qual => "i_read",        },
      { sig => "i_waitrequest",    qual => "i_read",        },
      { sig => "ihp_read",                                  },
      { sig => "ihp_address",      qual => "ihp_read",      },
      { sig => "ihp_waitrequest",  qual => "ihp_read",      },
      { sig => "ihp_readdatavalid",                         },
      { sig => "ihp_response",     qual => "ihp_readdatavalid",      },
      { sig => "d_write",                                   },
      { sig => "d_byteenable", qual => "d_write",           },
      { sig => "d_address",    qual => "d_write | d_read",  },
      { sig => "d_read",                                    },
      { sig => "d_waitrequest",  qual => "d_read | d_write",},
      { sig => "d_response",     qual => "d_read",          },
      { sig => "dhp_write",                                       },
      { sig => "dhp_byteenable", qual => "dhp_write",             },
      { sig => "dhp_address",    qual => "dhp_write | dhp_read",  },
      { sig => "dhp_read",                                        },
      { sig => "dhp_waitrequest",  qual => "dhp_read | dhp_write",},
      { sig => "dhp_readdatavalid",                               },
      { sig => "dhp_response",     qual => "dhp_readdatavalid",   },
      { sig => "dhp_readdata",     qual => "dhp_readdatavalid",   },
    );

    if ($mpu_present) {
        push(@x_signals,
          { sig => "W_config_reg",                  },
          { sig => "W_mpubase_reg",                 },
          { sig => "W_mpuacc_reg",                  },
        );
    }

    for (my $cmi = 0; 
      $cmi < manditory_int($Opt, "num_tightly_coupled_data_masters"); $cmi++) {
        push(@x_signals,
          { sig => "dtcm${cmi}_write",                                },
          { sig => "dtcm${cmi}_address",    qual => "dtcm${cmi}_write", },
          { sig => "dtcm${cmi}_byteenable", qual => "dtcm${cmi}_write", },
        );     
    }

    e_signal->adds(

      {name => "A_target_pcb", width => $pcb_sz},



      {name => "A_wr_data_filtered", width => $datapath_sz, 
       export => $force_export},
    );

    my $x_filter_qual = "A_ctrl_ld_non_io";

    if (manditory_bool($Opt, "clear_x_bits_ld_non_bypass") && 
      !manditory_bool($Opt, "asic_enabled")) {





        create_x_filter({
          lhs       => "A_wr_data_filtered",
          rhs       => "A_wr_data_unfiltered",
          sz        => $datapath_sz, 
          qual_expr => $x_filter_qual,
        });
    } else {

        e_assign->adds({
          lhs => "A_wr_data_filtered",
          rhs => "A_wr_data_unfiltered",
          comment => "Propagating 'X' data bits",
        });
    }

    my $display = $NIOS_DISPLAY_INST_TRACE | $NIOS_DISPLAY_MEM_TRAFFIC;
    my $use_reg_names = "1";

    my $test_end_expr;

    if (manditory_bool($Opt, "activate_monitors")) {
        create_x_checkers(\@x_signals);
    }

    if (manditory_bool($Opt, "activate_test_end_checker")) {
        my $inst_done_expr = "W_valid";






        $test_end_expr = 
          "$inst_done_expr & (
            W_sim_reg_stop |
            (W_op_cmpltui & (W_iw_a == 0) & (W_iw_b == 0) &
              ((W_iw_imm16 == 16'habc1) | (W_iw_imm16 == 16'habc2))))";
    }

    my $pc = "W_pcb";
    my $dstRegVal = "W_wr_data_filtered";

    my $crst_active = "W_valid_crst"; 

    my $reset_entry = {
        hard_reset_expr => "~reset_n",
        cpu_only_reset_expr => $cpu_reset ? $crst_active : undef,
    };

    my $crst_active = "W_valid_crst";
    my $intr_active = "W_valid_intr";
    my $hbreak_active = "W_valid_hbreak";

    my $iw_valid_expr;
    my $stages = manditory_array($gen_info, "stages");
    my $d_stage_or_later = 0;
    
    foreach my $stage (@$stages) {
        if ($stage eq "D") {
            $d_stage_or_later = 1;
        }
    
        if ($d_stage_or_later) {








            new_exc_combo_signal({
                name                => "${stage}_exc_inst_fetch",
                stage               => $stage,
                invalidates_inst_value => 1,
            });
        }
    }
    



    e_assign->adds(
      ["A_iw_invalid", "A_exc_inst_fetch & A_exc_active_no_break_no_crst"],
    );
    
    e_register->adds(
      {out => ["W_iw_invalid", 1, 0, $force_never_export], 
       in => "A_iw_invalid",  enable => "1'b1"},
    );
    
    $iw_valid_expr = "~W_iw_invalid";

    my $dstRegEccTestPort_expr = undef;
    
    my $hbreak_entry = {
        condition   => "W_valid_hbreak",
        pc          => $pc,
        dstRegWr    => "W_wr_dst_reg",
        dstRegNum   => "W_dst_regnum",
        dstRegVal   => $dstRegVal,
        dstRegSet   => $shadow_present ? "W_dst_regset" : undef,
        dstRegEccTestPort => $dstRegEccTestPort_expr,
    };

    my $intr_entry = {
        condition   => "W_valid_intr",
        pc          => $pc,
        dstRegWr    => "W_wr_dst_reg",
        dstRegNum   => "W_dst_regnum",
        dstRegVal   => $dstRegVal,
        dstRegSet   => $shadow_present ? "W_dst_regset" : undef,
        dstRegEccTestPort => $dstRegEccTestPort_expr,
        wrSstatus   => $eic_and_shadow ? "W_exc_wr_sstatus" : undef,
        sstatus     => $eic_and_shadow ? "W_tb_sstatus_reg" : undef,
        ril         => $eic_present ? "W_tb_eic_ril" : undef,
        rnmi        => $eic_present ? "W_tb_eic_rnmi" : undef,
        rrs         => $eic_present ? "W_tb_eic_rrs" : undef,
        rha         => $eic_present ? "W_tb_eic_rha" : undef,
    };
    
    my $inst_entry = {
        condition   => "W_valid || W_exc_any_active",
        exc         => "W_exc_any_active ? W_exc_highest_pri_exc_id : 0",
        excHandler  => undef,
        pc          => $pc,
        pcPhy       => undef,
        ivValid     => $iw_valid_expr,
        iv          => "W_iw",
        dstRegWr    => "W_wr_dst_reg",
        dstRegNum   => "W_dst_regnum",
        dstRegVal   => $dstRegVal,
        dstRegSet   => $shadow_present ? "W_dst_regset" : undef,
        dstRegEccTestPort => $dstRegEccTestPort_expr,
        memAddr     => "W_mem_baddr",
        memAddrPhy  => undef,
        stData      => "W_st_data",
        stByteEn    => "W_mem_byte_en",
        pass        => "W_cmp_result",
        targetPC    => "W_target_pcb",
    };

    if ($mpubase_reg) {
        set_control_reg_need_testbench_version($mpubase_reg, 1);
    }
    if ($mpuacc_reg) {
        set_control_reg_need_testbench_version($mpuacc_reg, 1);
    }

    my $cpu_info = {
        CpuCoreName     => "NiosII/m2",
        CpuInstanceName => not_empty_scalar($Opt, "name"),
        CpuArchName     => "Nios2",
        CpuArchRev      => $r2 ? "R2" : "R1",
    };

    my $trace_file_name = optional_scalar($Opt, "trace_file_name");
    my $filename_base = ($trace_file_name eq "") ? not_empty_scalar($Opt, "name") : $trace_file_name;

    create_rtl_trace_and_testend({
      activate_trace    => manditory_bool($Opt, "activate_trace"),
      filename_base     => $filename_base,
      reset_entry       => $reset_entry,
      intr_entry        => $intr_entry,
      hbreak_entry      => $hbreak_entry,
      inst_entry        => $inst_entry,
      control_regs      => manditory_array($Opt, "control_regs"),
      control_reg_stage => not_empty_scalar($Opt, "control_reg_stage"),
      extra_exc_info    => $extra_exc_info,
      cpu_info          => $cpu_info,
      test_end_expr     => $test_end_expr,
      language          => not_empty_scalar($Opt, "language"),
    });





    if (manditory_bool($Opt, "activate_trace") && !(manditory_bool($Opt, "asic_enabled"))) {
      $submodule->sink_signals(
        "W_vinst",
      );  
    }
    $submodule->sink_signals(
      "W_pcb",
      "W_valid",
      "W_iw",
    );

    push(@simgen_wave_signals,
        { radix => "x", signal => "$testbench_instance_name/W_pcb" },
        { radix => "a", signal => "$testbench_instance_name/W_vinst" },
        { radix => "x", signal => "$testbench_instance_name/W_valid" },
        { radix => "x", signal => "$testbench_instance_name/W_iw" },
    );

    return $submodule;
}





sub 
make_base_pipeline
{
    my $Opt = shift;

    my $whoami = "backend 400 base pipeline";


    e_signal->adds({name => "D_pcb", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "E_pcb", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "M_pcb", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "A_pcb", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "W_pcb", never_export => 1, width => $pcb_sz});

    e_assign->adds(["D_pcb", "{D_pc, 1'b0}"]);
    e_register->adds(
      {out => "E_pcb",             in => "D_pcb",         enable => "E_en"},
      {out => "M_pcb",             in => "E_pcb",         enable => "M_en"},
      {out => "A_pcb",             in => "M_pcb",         enable => "A_en", ip_debug_visible => !(manditory_bool($Opt, "asic_enabled"))},
      {out => "W_pcb",             in => "A_pcb",         enable => "1'b1", ip_debug_visible => !(manditory_bool($Opt, "asic_enabled"))},
      );

    if (manditory_bool($Opt, "export_pcbdebuginfo")) {
        

        e_signal->adds(
          {name => "pc", width => 32, export => $force_export },
          {name => "pc_valid", width => 1, export => $force_export },
        );

        push(@{$Opt->{port_list}},
          ["pc"         => 32,     "out" ],
          ["pc_valid"   => 1,      "out" ],
        );

        my $pcb_remainder_bits = 32 - $pcb_sz;

        e_assign->adds(
          ["pc", ($pcb_remainder_bits > 0) ? "{{${pcb_remainder_bits} {1'b0}},W_pcb}" : "W_pcb" ],
          ["pc_valid", "W_valid|W_exc_any"],
        );
        

        push(@{$Opt->{port_list}},
          ["iw"         => 32, "out" ],
          ["iw_valid"   => 1,      "out" ],
          ["exc"        => 1, "out" ],
          ["exc_valid"  => 1,      "out" ],
        );
        
        e_register->adds(
           {out => "W_exc_any",    in => "A_exc_any",         enable => "1'b1", ip_debug_visible => !(manditory_bool($Opt, "asic_enabled"))},
        );
        

        e_assign->adds(
          ["iw", "W_iw"],
          ["iw_valid", "W_valid|W_exc_any"],
          ["exc", "W_exc_any"],
          ["exc_valid", "W_valid|W_exc_any"],
        );
    }

    my @exc_wave_signals;

    make_D_stage($Opt);
    make_E_stage($Opt, \@exc_wave_signals);
    make_M_stage($Opt, \@exc_wave_signals);
    make_A_stage($Opt, \@exc_wave_signals);
    make_W_stage($Opt);





    if (scalar(@exc_wave_signals) > 0) {
        push(@plaintext_wave_signals, { divider => "exceptions" });
        push(@plaintext_wave_signals, @exc_wave_signals);
    }

    my @mem_load_store_wave_signals = (
        { divider => "mem" },
        { radix => "x", signal => "E_mem_baddr" },
        { radix => "x", signal => "M_mem_baddr" },
        { divider => "load" },
        { radix => "x", signal => "M_ctrl_ld8" },
        { radix => "x", signal => "M_ctrl_ld16" },
        { radix => "x", signal => "M_ctrl_ld_signed" },
        {radix =>"x", signal => "M_ram_rd_data"},
        { radix => "x", signal => "M_inst_result" },
        { radix => "x", signal => "A_inst_result" },
        { radix => "x", signal => "A_wr_data_unfiltered" },
        { radix => "x", signal => "A_wr_data_filtered" },
        { radix => "x", signal => "A_ld_align_sh16" },
        { radix => "x", signal => "A_ld_align_sh8" },
        { radix => "x", signal => "A_ld_align_byte1_fill" },
        { radix => "x", signal => "A_ld_align_byte2_byte3_fill" },
        { divider => "store" },
        { radix => "x", signal => "E_ctrl_st" },
        { radix => "x", signal => "E_ctrl_st8" },
        { radix => "x", signal => "E_ctrl_st16" },
        { radix => "x", signal => "E_valid" },
        { radix => "x", signal => "E_st_data" },
        { radix => "x", signal => "E_mem_byte_en" },
        { radix => "x", signal => "M_st_data" },
        { radix => "x", signal => "M_mem_byte_en" },
        { radix => "x", signal => "A_st_data" },
        { radix => "x", signal => "A_mem_byte_en" },
    );

    push(@plaintext_wave_signals, @mem_load_store_wave_signals);
}




sub 
make_D_stage
{
    my $Opt = shift;

    my $ds = not_empty_scalar($Opt, "dispatch_stage");

    my $w_debug_mode = "";
    my $oci_version = manditory_int($Opt, "oci_version");
    
    if ($oci_version == 2) {
        $w_debug_mode = " & ~W_debug_mode";
    }
    e_assign->adds(







      [["D_stall", 1], "(D_dep_stall | E_stall) & ~M_pipe_flush & ~E_br_mispredict & ~D_iw_32b_misaligned_stall"],


      [["D_en", 1], "~D_stall"],        







      [["D_dep_stall", 1], "D_data_depend & D_issue & ~D_imaster_kill"],




      [["D_valid", 1], "D_issue & D_multiple_wb_or_jmp & ~M_pipe_flush & ~E_br_mispredict & ~D_iw_32b_misaligned_stall & ~D_data_depend"],
      [["D_issue_rdprs", 1, 0, $force_never_export], $shadow_present ? "D_issue & D_ctrl_rdprs" : "0"],
      

      [["D_lower_iw_16b", 1], $cdx_present ? "D_ctrl_narrow & ~D_pc[0] & D_issue & ~D_imaster_kill" . "$w_debug_mode" : "1'b0"],
      


      [["D_iw_32b_misaligned", 1], $cdx_present ? "D_pc[0] & ~D_ctrl_narrow & (D_issue | D_iw_32_misaligned_stall_d1)" . "$w_debug_mode" : "1'b0"],


      [["D_iw_32b_misaligned_done", 1], $cdx_present ? "M_pipe_flush|E_br_mispredict|ibuf_occupied_d1|D_iw_32_misaligned_done_latch" : "1'b0"],
      [["D_iw_32b_misaligned_stall", 1], "D_iw_32b_misaligned & ~D_iw_32b_misaligned_done"],
    );

    if ($cdx_present) {
        e_register->adds(
          {out => "D_iw_32_misaligned_stall_d1", in => "D_iw_32b_misaligned_stall",
           enable => "1'b1"},


          {out => "D_iw_32_misaligned_done_latch", in => "~D_stall ? 1'b0 :
                                                          D_iw_32b_misaligned_done ? 1'b1 : 
                                                          D_iw_32_misaligned_done_latch",
           enable => "1'b1"},
        );
    }




    new_exc_combo_signal({
        name                => "D_exc_invalidates_inst_value",
        stage               => "D",
        invalidates_inst_value          => 1,
    });


    e_signal->adds({name => "D_pc_plus_two", never_export => 1, 
      width => $pch_sz});

    e_register->adds(
      {out => ["D_iw_lo", $iw_sz/2],                 in => "${ds}_iw_lo",
       enable => "1'b1"},
      {out => ["D_iw_hi_reg", $iw_sz/2],             in => "${ds}_iw_hi",
       enable => "1'b1"},

      {out => ["D_pc", $pch_sz],                 in => "master_older_non_sequential ? npc : 
              F_pc",
       async_value => $reset_pch,
       enable => "(master_older_non_sequential|(D_issue & ~(D_multiple_shift_reg_stall|D_iw_32b_misaligned_stall))) & ~D_stall"},
      {out => "D_imaster_kill", in => "imaster_kill",
       enable => "D_en"},
    );

    e_assign->adds(




      [["D_iw_hi", $iw_sz/2], $cdx_present ? "D_ctrl_narrow ? 16'h0000 : D_iw_hi_reg" : "D_iw_hi_reg"],
      [["D_iw", $iw_sz], "{D_iw_hi, D_iw_lo}"],
      
      [["D_pc_plus_one", $pch_sz, 0, $force_never_export], "D_pc + 1"],
      [["D_pc_plus_two", $pch_sz, 0, $force_never_export], "D_pc + 2"],
    );








    if ($pch_sz > $iw_imm26_sz) {
        e_assign->adds(
          [["D_jmp_direct_target_haddr", $pch_sz], 
            "{D_pc[$pch_sz-1:$iw_imm26_sz+1], D_iw[$iw_imm26_msb:$iw_imm26_lsb],1'b0}"],
        );
    } else {
        e_assign->adds(
          [["D_jmp_direct_target_haddr", $pch_sz], 
            "{D_iw[$pch_sz-2+$iw_imm26_lsb:$iw_imm26_lsb],1'b0}"],
        );
    }


    e_signal->adds({name => "D_jmp_direct_target_baddr", never_export => 1, 
      width => $pcb_sz});
    e_assign->adds(["D_jmp_direct_target_baddr", 
     "{D_jmp_direct_target_haddr, 1'b0}"]);





    e_assign->adds(




      [["D_extra_pc", $pch_sz], 
        $cdx_present ? "D_br_pred_not_taken ? D_br_taken_haddr : D_ctrl_narrow ? D_pc_plus_one : D_pc_plus_two" : 
        "D_br_pred_not_taken ? D_br_taken_haddr : D_pc_plus_two"],
    );


    e_signal->adds({name => "D_extra_pcb", never_export => 1, 
      width => $pcb_sz});
    e_assign->adds(["D_extra_pcb", "{D_extra_pc, 1'b0}"]);
}




sub 
make_E_stage
{
    my $Opt = shift;
    my $exc_wave_signals_ref = shift;
    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");

    my $r1 = ($cpu_arch_rev == 1);
    my $r2 = ($cpu_arch_rev == 2);



    e_assign->adds(
      [["E_stall", 1], "M_stall"],


      [["E_en", 1], "~E_stall"],        
    );


    e_register->adds(
      {out => ["E_valid_from_D", 1],        in => "D_valid",
       enable => "E_en"},
      {out => ["E_iw", $iw_sz],             in => "D_iw", 
       enable => "E_en"},
      {out => ["E_dst_regnum", $regnum_sz], in => "D_dst_regnum", 
       enable => "E_en" },
      {out => ["E_wr_dst_reg_from_D", 1],   in => "D_wr_dst_reg", 
       enable => "E_en"},
      {out => ["E_extra_pc", $pch_sz],       in => "D_extra_pc", 
       enable => "E_en"},
      {out => ["E_pc", $pch_sz],             in => "D_pc", 
       enable => "E_en"},
      {out => ["E_valid_jmp_indirect_haddr", $pch_sz],             in => $cdx_present ? "D_multiple_jmp_indirect ? D_src2_reg[$pcb_sz-1:1]: D_src1[$pcb_sz-1:1]" : "D_src1[$pcb_sz-1:1]", 
       enable => "E_en"},
      {out => ["E_valid_jmp_indirect", 1],  in => "(D_ctrl_jmp_indirect|D_multiple_jmp_indirect) & D_valid",
       enable => "E_en"},
      );


    e_signal->adds({name => "E_extra_pcb", never_export => 1, 
      width => $pcb_sz});
    e_assign->adds(["E_extra_pcb", "{E_extra_pc, 1'b0}"]);








    
    my @E_iw_corrupt_inputs;

    e_assign->adds(
      [["E_iw_corrupt", 1], scalar(@E_iw_corrupt_inputs) ? join('|', @E_iw_corrupt_inputs) : "0"],
    );
    e_register->adds(
      {out => ["M_iw_corrupt", 1, 0, $force_never_export],
       in => "E_iw_corrupt",     enable => "M_en"},
    );


    new_exc_signal({
        exc             => $trap_inst_exc,
        initial_stage   => "E", 
        speedup_stage   => "E",
        rhs             => "E_ctrl_trap_inst & !E_iw_corrupt",
    });


    new_exc_signal({
        exc             => $unimp_inst_exc,
        initial_stage   => "E", 
        speedup_stage   => "E",
        rhs             => "E_ctrl_unimp_trap & !E_iw_corrupt",
    });


    my $software_break = "1'b0";




    my $allow_break_inst = manditory_bool($Opt, "allow_break_inst");
    if ( $oci_present || $allow_break_inst || $r1 ) {
        $software_break = $cdx_present ? "(E_op_break|E_op_break_n) & !E_iw_corrupt" : "E_op_break & !E_iw_corrupt";
    }

    new_exc_signal({
        exc             => $break_inst_exc,
        initial_stage   => "E", 
        speedup_stage   => "E",
        rhs             => $software_break,
    });


    new_exc_signal({
        exc             => $illegal_inst_exc,
        initial_stage   => "E", 
        speedup_stage   => "E",
        rhs             => "E_ctrl_illegal & !E_iw_corrupt",
    });

    push(@$exc_wave_signals_ref,
      get_exc_signal_wave($trap_inst_exc, "E"),
      get_exc_signal_wave($unimp_inst_exc, "E"),
      get_exc_signal_wave($break_inst_exc, "E"),
      get_exc_signal_wave($illegal_inst_exc, "E"),
    );

    if ($mpu_present) {


        new_exc_signal({
            exc             => $supervisor_inst_exc,
            initial_stage   => "E", 
            speedup_stage   => "E",
            rhs             => 
               "E_ctrl_supervisor_only & W_status_reg_u & !E_iw_corrupt",
        });

        push(@$exc_wave_signals_ref,
          get_exc_signal_wave($supervisor_inst_exc, "E"),
        );
    }

    if ($illegal_mem_exc) {

        new_exc_signal({
            exc             => $misaligned_data_addr_exc,
            initial_stage   => "E", 
            speedup_stage   => "E",
            rhs             => 
              "!E_mem_baddr_corrupt & (((E_ctrl_mem32|E_multiple_ld|E_multiple_st) & (E_mem_baddr[1:0] != 2'b00)) |
                                       (E_ctrl_mem16 & (E_mem_baddr[0]   != 1'b0)))",
        });


        new_exc_signal({
            exc             => $misaligned_target_pc_exc,
            initial_stage   => "E", 
            speedup_stage   => "E",
            rhs             => 
              $cdx_present ? 
              "(E_ctrl_jmp_indirect_word_aligned & (E_src1[1:0] != 2'b00) & !E_src1_corrupt) |
               (E_ctrl_jmp_indirect_hword_aligned & (E_src1[0] != 1'b0) & !E_src1_corrupt) |
               (E_multiple_jmp_indirect & (E_src2_reg[0] != 1'b0) & !E_src2_corrupt) |
               (E_ctrl_br & ~E_ctrl_narrow & (E_iw_imm16[0] != 1'b0) & !E_iw_corrupt)" :
              "(E_ctrl_jmp_indirect & (E_src1[1:0] != 2'b00) & !E_src1_corrupt) |
               (E_ctrl_br & (E_iw_imm16[1:0] != 2'b00) & !E_iw_corrupt)",
        });

        push(@$exc_wave_signals_ref,
          get_exc_signal_wave($misaligned_data_addr_exc, "E"),
          get_exc_signal_wave($misaligned_target_pc_exc, "E"),
        );
    }

    if ($hbreak_present) {


        new_exc_signal({
            exc             => $hbreak_exc,
            initial_stage   => "E", 
            rhs             => "E_hbreak_req",
        });
    }

    if ($cpu_reset) {



        e_register->adds(
          {out => ["E_cpu_resetrequest", 1], 
           in => ($hbreak_present ? 
             "(cpu_resetrequest & hbreak_enabled)" : 
             "cpu_resetrequest"),
           enable => "E_en" },
        );
    
        push(@$exc_wave_signals_ref,
          get_exc_signal_wave($cpu_reset_exc, "E"));
    }

    if ($cpu_reset) {



        new_exc_signal({
            exc             => $cpu_reset_exc,
            initial_stage   => "E", 
            rhs             => "E_cpu_resetrequest",
        });
    
        my $M_crst_exc_nxt =
          get_exc_nxt_signal_name($cpu_reset_exc, "M");
    





        e_assign->adds([["E_exc_crst", 1], "$M_crst_exc_nxt"]);
    
        push(@$exc_wave_signals_ref,
          { radix => "x", signal => "E_exc_crst" },
        );
    } else {
        e_assign->adds([["E_exc_crst", 1, 0, $force_never_export], "0"]);
    }

    if ($eic_present) {



        new_exc_signal({
            exc             => $ext_intr_exc,
            initial_stage   => "E", 
            rhs             => "E_ext_intr_req",
        });

        e_assign->adds(





          [["E_exc_ext_intr", 1], get_exc_nxt_signal_name($ext_intr_exc, "M")],
        );

        push(@$exc_wave_signals_ref,
          get_exc_signal_wave($ext_intr_exc, "E"),
          { radix => "x", signal => "E_exc_ext_intr" },
        );
    } else {



        new_exc_signal({
            exc             => $norm_intr_exc,
            initial_stage   => "E", 
            rhs             => $r2 ? "E_norm_intr_req & E_status_reg_pie_latest" : "E_norm_intr_req",
        });

        e_assign->adds(

          [["E_exc_ext_intr", 1, 0, $force_never_export], "0"],
        );

        push(@$exc_wave_signals_ref,
          get_exc_signal_wave($norm_intr_exc, "E"),
        );
    }



    new_exc_combo_signal({
        name            => "E_exc_any",
        stage           => "E",
    });





    e_assign->adds(


      [["E_valid", 1], "E_valid_from_D & ~E_cancel"],
      


      [["E_valid_ignore_exc", 1], "E_valid_from_D & ~M_pipe_flush"],    



      [["E_wr_dst_reg", 1], "E_wr_dst_reg_from_D & ~M_pipe_flush"],
    );
    

    if (manditory_bool($Opt, "export_vectors")) {
        e_port->adds(["reset_vector_word_addr", $pc_sz, "in"]);
        e_port->adds(["exception_vector_word_addr", $pc_sz, "in"]);
    }

    e_assign->adds(
      [["E_exc_any_valid", 1], "E_exc_any & E_valid_from_D"],




      [["E_cancel", 1], "M_cancel | E_exc_any_valid"],
    );








    my $cmp_mem_baddr_sz = manditory_int($Opt, "d_Address_Width");

    my $avalon_master_info = manditory_hash($Opt, "avalon_master_info");


    my @sel_signals = make_master_address_decoder({
      avalon_master_info    => $avalon_master_info,
      normal_master_name    => "data_master", 
      tightly_coupled_master_names => manditory_array($avalon_master_info,
        "avalon_tightly_coupled_data_master_list"), 
      high_performance_master_names => manditory_array($avalon_master_info,
        "avalon_data_master_high_performance_list"),
      flash_accelerator_master_names => manditory_array($avalon_master_info,
        "avalon_instruction_master_high_performance_list"),
      addr_signal           => "E_mem_baddr[$cmp_mem_baddr_sz-1:0]",
      addr_sz               => $cmp_mem_baddr_sz, 
      sel_prefix            => "E_sel_",
      mmu_present           => 0,
      fa_present            => 0,
      master_paddr_mapper_func => \&nios2_mmu::master_paddr_mapper,
    });

    if (!$dhp_present) {
        e_assign->adds(
            [["E_sel_data_master_high_performance",1,0,$force_never_export], "1'b0"],
            [["M_sel_data_master_high_performance",1,0,$force_never_export], "1'b0"],
            [["A_sel_data_master_high_performance",1,0,$force_never_export], "1'b0"],
        );
    }

    e_assign->adds(

      [["E_sel_dtcm", 1], $dtcm_present ? "~(E_sel_data_master | E_sel_data_master_high_performance)" : "1'b0"],
    );

    if (scalar(@sel_signals) > 1) {
        push(@plaintext_wave_signals, 
            { divider => "data_master_sel" },
        );

        foreach my $sel_signal (@sel_signals) {
            push(@plaintext_wave_signals, 
              { radix => "x", signal => $sel_signal },
            );
        }
    }
}




sub 
make_M_stage
{
    my $Opt = shift;
    my $exc_wave_signals_ref = shift;

    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");

    my $r1 = ($cpu_arch_rev == 1);
    my $r2 = ($cpu_arch_rev == 2);




    
    my @M_stall_inputs;
    my @M_stall_non_mem_inputs;

    push(@M_stall_inputs, "M_mem_stall");

    if (nios2_custom_insts::has_multi_insts($Opt->{custom_instructions})) {
        push(@M_stall_non_mem_inputs, "M_ci_multi_stall");
    }

    push(@M_stall_inputs, @M_stall_non_mem_inputs);

    e_assign->adds(
      [["M_stall", 1], join('|', @M_stall_inputs)],
      [["M_stall_non_mem", 1, 0, $force_never_export], scalar(@M_stall_non_mem_inputs) ? join('|', @M_stall_non_mem_inputs) : "0"],


      [["M_en", 1], "~M_stall"],        
    );

    e_signal->adds(


      {name => "M_cmp_result", never_export => 1, width => 1},
      {name => "M_target_pcb", never_export => 1, width => $pcb_sz},
    );

    e_register->adds(
      {out => ["M_iw",  $iw_sz],                    in => "E_iw",
       enable => "M_en"},
      {out => ["M_mem_byte_en", $byte_en_sz],       in => "E_mem_byte_en",
       enable => "M_en", },
      {out => ["M_alu_result", $datapath_sz],       in => "E_alu_result",
       enable => "M_en"},
      {out => ["M_st_data", $datapath_sz],          in => "E_st_data",
       enable => "M_en"},
      {out => ["M_dst_regnum", $regnum_sz],         in => "E_dst_regnum",
       enable => "M_en"},
      {out => "M_cmp_result",                       in => "E_cmp_result",
       enable => "M_en"},
      {out => "M_target_pcb",                       in => $cdx_present ? "E_multiple_jmp_indirect ? E_src2_reg[$pcb_sz-1:0] : E_src1[$pcb_sz-1:0]" : "E_src1[$pcb_sz-1:0]",
       enable => "M_en"},
      {out => ["M_valid_from_E", 1],                in => "E_valid_ignore_exc",
       enable => "M_en"},
      {out => ["M_wr_dst_reg_from_E", 1],           in => "E_wr_dst_reg",
       enable => "M_en"},
      {out => ["M_exc_crst", 1],             in => "E_exc_crst",
       enable => "M_en"},
      {out => ["M_exc_ext_intr", 1],         in => "E_exc_ext_intr",
       enable => "M_en"},
      {out => ["M_sel_dtcm", 1],             in => "E_sel_dtcm",
       enable => "M_en"},
      );


    foreach my $master (@{$Opt->{avalon_data_master_list}}) {
        e_register->adds(
          {out => ["M_sel_${master}", 1, 0, $force_never_export],
           in => "E_sel_${master}", enable => "M_en"},
        );
    }

    e_assign->adds(
      [["M_dtcm_ld", 1, 0, $force_never_export], "(M_ctrl_ld|M_multiple_ld) & M_sel_dtcm"],
      [["M_dtcm_st", 1, 0, $force_never_export], "(M_ctrl_st|M_multiple_st) & M_sel_dtcm & M_st_writes_mem"],
      [["M_dtcm_st_non32", 1, 0, $force_never_export], 
        "M_ctrl_st_non32 & M_sel_dtcm & M_st_writes_mem"],

      [["M_sel_dhp", 1, 0, $force_never_export], "M_sel_data_master_high_performance"],
      [["M_dhp_ld", 1, 0, $force_never_export], "(M_ctrl_ld|M_multiple_ld) & M_sel_dhp"],
      [["M_dhp_st", 1, 0, $force_never_export], "(M_ctrl_st|M_multiple_st) & M_sel_dhp & M_st_writes_mem"],
      [["M_dhp_st_non32", 1, 0, $force_never_export], 
        "M_ctrl_st_non32 & M_sel_dhp & M_st_writes_mem"],
    );

    e_register->adds(
      {out => ["M_pc", $pch_sz], in => "E_pc", enable => "M_en"},

      {out => ["M_pc_plus_two", $pch_sz],     in => "E_pc + 2",
       enable => "M_en"},
    );
    
    if ($cdx_present) {
        e_register->adds(
          {out => ["M_pc_plus_one", $pch_sz],     in => "E_pc + 1",
           enable => "M_en"},
        );
    }

    push(@$exc_wave_signals_ref,
      get_exc_signal_wave(
        $eic_present ? $ext_intr_exc : $norm_intr_exc, "M"),
      get_exc_signal_wave($break_inst_exc, "M"),
    );

    if ($mpu_present) {
        push(@$exc_wave_signals_ref,
          get_exc_signal_wave($supervisor_inst_exc, "M"),
        );
    }

    e_assign->adds(
       [["M_mem_baddr", $mem_baddr_sz, 0, $force_never_export], "M_master_mem_baddr"],
       [["M_mem_waddr", $mem_baddr_sz-2, 0, $force_never_export], "M_mem_baddr[$mem_baddr_sz-1:2]"],
    );


    e_assign->adds(
       [["M_mem_waddr_phy", $mem_baddr_sz-2, 0, $force_never_export], 
         "M_mem_baddr[$mem_baddr_sz-1:2]"],
    );










    my @dtcm_rd_data_mux_table;
    my @dtcm_rd_response_mux_table;
    my $M_dtcm_data_present = 0;

    for (my $cmi = 0; 
      $cmi < manditory_int($Opt, "num_tightly_coupled_data_masters"); $cmi++) {
        my $master_name = "tightly_coupled_data_master_${cmi}";
        my $sel_name = "M_sel_" . $master_name;
        my $data_name = "dtcm${cmi}_readdata";
        my $response_name = "dtcm${cmi}_response";

        if ($cmi == 
          (manditory_int($Opt, "num_tightly_coupled_data_masters") - 1)) {
            push(@dtcm_rd_data_mux_table,
              "1'b1" => $data_name);
            push(@dtcm_rd_response_mux_table,
              "1'b1" => $response_name);
        } else {
            push(@dtcm_rd_data_mux_table,
              $sel_name => $data_name);
            push(@dtcm_rd_response_mux_table,
              $sel_name => $response_name);
        }
        $M_dtcm_data_present = 1;
    }

    if ($M_dtcm_data_present) {
        e_mux->add ({
          lhs => ["M_dtcm_readdata", $datapath_sz],
          type => "priority",
          table => \@dtcm_rd_data_mux_table,
          });
        e_mux->add ({
          lhs => ["M_dtcm_response", 2],
          type => "priority",
          table => \@dtcm_rd_response_mux_table,
          });
    }








    e_assign->adds(
      [["M_fwd_reg_data", $datapath_sz], "M_inst_result"],
    );









    if ($r2) {
        e_assign->adds(
          [["M_rdctl_data_0_latest", 1], 
             "(M_iw_control_regnum == 4'd0)? M_status_reg_pie_latest : M_rdctl_data[0]"],
        );
        
        if ($shadow_present & $eic_present) {
            e_assign->adds(
              [["M_rdctl_data_23_latest", 1], 
                 "(M_iw_control_regnum == 4'd0)? M_status_reg_rsie_latest : M_rdctl_data[23]"],
            );    
        }
    }

    e_assign->adds(
      [["M_rdctl_data_latest", $datapath_sz], 
         ($r2 && $shadow_present & $eic_present) ? "{M_rdctl_data[31:24],M_rdctl_data_23_latest,M_rdctl_data[22:1],M_rdctl_data_0_latest}" :
         ($r2) ? "{M_rdctl_data[31:1],M_rdctl_data_0_latest}" :
                                                   "M_rdctl_data"],
    );


    e_assign->adds(
      [["M_rdctl_data_inst_result", $datapath_sz], 
        "M_ctrl_intr_inst ? W_status_reg : M_rdctl_data_latest"],
    );
  
    my $M_inst_result_mux_table = [];

    push(@$M_inst_result_mux_table,
      "M_ctrl_rd_ctl_reg" => "M_rdctl_data_inst_result"
    );

    if (nios2_custom_insts::has_multi_insts($Opt->{custom_instructions})) {
        push(@$M_inst_result_mux_table,
          "M_ctrl_custom_multi"         => "M_ci_multi_result",
        );
    }

    push(@$M_inst_result_mux_table,
      "1'b1"              => "M_alu_result",
    );

    e_mux->add ({
      lhs => ["M_inst_result", $datapath_sz],
      type => "priority",
      table => $M_inst_result_mux_table,
      });





















































    e_register->adds(

      {out => ["W_up_ex_mon_state",1],
       in => "(A_ctrl_ld_ex & A_valid) ? 1'b1 :
              ((A_ctrl_st_ex | A_op_eret) & A_valid)? 1'b0 : 
              W_up_ex_mon_state",
       enable => "W_en"},
    );
    
    e_assign->adds(



      [["E_up_ex_mon_state_latest", 1], 
        "(M_ctrl_ld_st_ex & M_valid) ? M_ctrl_ld_ex :
         (A_ctrl_ld_st_ex & A_valid) ? A_ctrl_ld_ex :
         W_up_ex_mon_state"],



      [["E_st_writes_mem", 1, 0, $force_never_export], 
        "(~E_ctrl_st_ex | E_up_ex_mon_state_latest)"],




      [["M_up_ex_mon_state_latest", 1], 
        "(A_ctrl_ld_st_ex & A_valid) ? A_ctrl_ld_ex :
         W_up_ex_mon_state"],



      [["M_st_writes_mem", 1, 0, $force_never_export], 
        "(~M_ctrl_st_ex | M_up_ex_mon_state_latest)"],


      [["A_up_ex_mon_state_latest", 1], "W_up_ex_mon_state"],



      [["A_st_writes_mem", 1, 0, $force_never_export], 
        "(~A_ctrl_st_ex | A_up_ex_mon_state_latest)"],
    );
    
    if ($r2) {





        

        e_register->adds(
          {out => ["M_intr_inst_pie",1],
           in => "(E_op_wrpie & E_valid) ? E_src1[0] :
                  1'b1",
           enable => "M_en"},
        );

        e_register->adds(
          {out => ["A_intr_inst_pie",1],
           in => "M_intr_inst_pie",
           enable => "A_en"},
        );
           
        e_assign->adds(

           [["E_status_reg_pie_latest", 1], 
           "(M_ctrl_intr_inst & M_valid) ? M_intr_inst_pie :
            (A_ctrl_intr_inst & A_valid) ? A_intr_inst_pie :
            W_status_reg_pie"],

           [["M_status_reg_pie_latest", 1], 
           "(A_ctrl_intr_inst & A_valid) ? A_intr_inst_pie :
            W_status_reg_pie"],
        );
        

        e_register->adds(
           {out => ["A_status_reg_pie_alu_0",1],
           in => "M_alu_result[0]",
           enable => "A_en"},
        );
        
        if ($shadow_present & $eic_present) {

            e_register->adds(
              {out => ["M_intr_inst_rsie",1],
               in => "(W_status_reg_rsie | E_iw_rsie)",
               enable => "M_en"},
            );

            e_register->adds(
              {out => ["A_intr_inst_rsie",1],
               in => "M_intr_inst_rsie",
               enable => "A_en"},
            );   
             
            e_assign->adds(

               [["E_status_reg_rsie_latest", 1], 
               "(M_op_eni & M_valid) ? M_intr_inst_rsie :
                (A_op_eni & A_valid) ? A_intr_inst_rsie :
                W_status_reg_rsie"],

               [["M_status_reg_rsie_latest", 1], 
                "(A_op_eni & A_valid) ? A_intr_inst_rsie :
                W_status_reg_rsie"],
            );
        }
    }






    e_assign->adds(


      [["M_st_stall", 1], "(M_ctrl_st|M_multiple_st) & M_valid & ~(M_dhp_st_done | M_d_st_done | M_sel_dtcm) & M_st_writes_mem"],


      [["M_ld_stall", 1], "(M_ctrl_ld|M_multiple_ld) & M_valid & ~(M_dhp_ld_done | M_d_ld_done | M_sel_dtcm)"],
      [["M_mem_stall", 1], "(M_st_stall | M_ld_stall)"],
    );






    e_assign->adds(



      [["M_ld_align_sh16", 1], 
        "(M_ctrl_ld8 | M_ctrl_ld16) & ${big_endian_tilde}M_mem_baddr[1]"],





      [["M_ld_align_sh8", 1], 
        "M_ctrl_ld8 & ${big_endian_tilde}M_mem_baddr[0]"],



      [["M_ld_align_byte1_fill", 1], "M_ctrl_ld8"],
      


      [["M_ld_align_byte2_byte3_fill", 1], 
         "M_ctrl_ld8_ld16"],
    );






    e_register->adds(
      {out => ["M_exc_any_from_E",  1],                    in => "E_exc_any_valid",
       enable => "M_en"},
    );
    

    my @M_stage_exception_list;
    push(@M_stage_exception_list, "M_exc_any_from_E");
    
    e_assign->adds(
      [["M_exc_any", 1], join('|', @M_stage_exception_list)],
    );

    push(@$exc_wave_signals_ref,


    );




 
    my $A_hbreak_exc_nxt = $hbreak_present ?  get_exc_nxt_signal_name($hbreak_exc, "A") : "0";
    my $A_break_inst_exc_nxt = get_exc_nxt_signal_name($break_inst_exc, "A");

    e_assign->adds(





      [["M_exc_break", 1], "$A_hbreak_exc_nxt | $A_break_inst_exc_nxt"],












    );

    push(@$exc_wave_signals_ref,
      { radix => "x", signal => "M_exc_break" },
    );





    push(@$exc_wave_signals_ref,
      { radix => "x", signal => "M_cancel" },
      { radix => "x", signal => "M_cancel_except_refetch" },
      { radix => "x", signal => "M_valid_ignoring_refetch" },
    );

    e_assign->adds(



      [["M_pipe_flush", 1], "A_pipe_flush"],






      [["M_cancel", 1], "M_pipe_flush | M_exc_any"],



      [["M_valid", 1], "M_valid_from_E & ~M_cancel"],
      

      [["M_valid_ignore_exc", 1], "M_valid_from_E & ~M_pipe_flush"],
      



      [["M_exc_allowed", 1], "M_valid_ignore_exc"],





      [["M_wr_dst_reg", 1], "M_wr_dst_reg_from_E & ~M_pipe_flush"],
    );

    if ($bmx_present) {



        e_signal->adds(
          {name => "E_bmx_result", never_export => 1, width => $datapath_sz},
          {name => "E_bmx_target", never_export => 1, width => $datapath_sz},            
          {name => "E_ext_mask", never_export => 1, width => $datapath_sz},
          {name => "E_ins_mask", never_export => 1, width => $datapath_sz},
          {name => "E_bmx_mask", never_export => 1, width => $datapath_sz},
        );
        
        e_assign->adds(
          [["E_bmx_mask",32], "E_op_extract ? E_ext_mask : E_ins_mask"],
          [["E_bmx_src",32], "E_op_extract ? 32'b0 : E_st_data"],
          [["E_ext_size",5], "E_iw_bmx_msb - E_iw_bmx_lsb"],
        );
        
        my $bit;
        
        for ($bit = 0; $bit < 32; $bit++) {
            e_assign->adds(
              ["E_ext_mask[$bit]",
                 "($bit <= E_ext_size) ? 1'b1 : 1'b0"],
        
              ["E_ins_mask[$bit]",
                 "($bit >= E_iw_bmx_lsb && ($bit <= E_iw_bmx_msb)) ? 1'b1 : 1'b0"],
        
          );
        }

        e_assign->adds(
          ["E_bmx_target", "E_shift_rot_result"],
          );
        
        for ($bit = 0; $bit < 32; $bit++) {
          e_assign->adds(
            ["E_bmx_result[$bit]",
                 "E_bmx_mask[$bit] ? E_bmx_target[$bit] : 
                                        E_bmx_src[$bit]"],
            );
        }
    }
    
    e_assign->adds(
      [["E_shift_rot_bmx_result",32], $bmx_present ? "E_ctrl_bmx ? E_bmx_result : E_shift_rot_result" : "E_shift_rot_result"],
    );
}




sub
make_A_stage()
{
    my $Opt = shift;
    my $exc_wave_signals_ref = shift;

    my $whoami = "A-stage";


    my @A_stall_inputs;

    e_assign->adds(
      [["A_stall", 1], 
        scalar(@A_stall_inputs) ? join('|', @A_stall_inputs) : "0"],


      [["A_en", 1], "~A_stall"],        
      );

    e_signal->adds(



      {name => "A_cmp_result", never_export => 1, width => 1},
      {name => "A_br_jmp_target_pcb", never_export => 1, width => $pcb_sz},
      {name => "A_mem_baddr", never_export => 1, width => $mem_baddr_sz},
      {name => "A_exc_fast_tlb_miss", never_export => 1, width => 1 },
    );

    my $dhp_pending_ld_d1 = $dhp_present ?  "dhp_pending_ld_done_d1 | " : "";
    e_register->adds(
      {out => ["A_pc", $pch_sz],                     in => "M_pc", 
       enable => "A_en"},
      {out => ["A_valid_from_M", 1],                in => "M_valid_ignore_exc & M_en",
       enable => "A_en", ip_debug_visible => !(manditory_bool($Opt, "asic_enabled"))},
      {out => ["A_iw",  $iw_sz],                    in => "M_iw",
       enable => "A_en", ip_debug_visible => !(manditory_bool($Opt, "asic_enabled"))},
      {out => ["A_inst_result", $datapath_sz],      in => "M_inst_result",
       enable => "A_en"},
      {out => ["A_mem_byte_en", $byte_en_sz],       in => "M_mem_byte_en",
       enable => "A_en", },
      {out => ["A_st_data", $datapath_sz],          in => "M_st_data",
       enable => "A_en"},
      {out => ["A_dst_regnum_from_M", $regnum_sz],  in => "M_dst_regnum",
       enable => "A_en"},
      {out => ["A_ld_align_sh16", 1],               in => "M_ld_align_sh16",
       enable => "A_en"},
      {out => ["A_ld_align_sh8", 1],                in => "M_ld_align_sh8",
       enable => "A_en"},
      {out => ["A_ld_align_byte1_fill", 1],         
       in => "M_ld_align_byte1_fill",
       enable => "A_en"},
      {out => ["A_ld_align_byte2_byte3_fill", 1],   
       in => "M_ld_align_byte2_byte3_fill",
       enable => "A_en"},
      {out => "A_cmp_result",                       in => "M_cmp_result",  
       enable => "A_en"},
      {out => "A_mem_baddr",                        in => "M_mem_baddr",
       enable => "A_en"},
      {out => ["A_wr_dst_reg_from_M", 1],           in => "M_wr_dst_reg & M_en",
       enable => "A_en"},
      {out => ["A_target_pcb", $pcb_sz, 0, $force_never_export],
       in => "M_target_pcb",            enable => "A_en"},
      {out => ["A_npc", $pch_sz],           in => $cdx_present ? "M_ctrl_narrow ? M_pc_plus_one : M_pc_plus_two" : "M_pc_plus_two",
       enable => "A_en"},
      {out => ["A_sel_dtcm", 1],            in => "M_sel_dtcm",
       enable => "A_en"},
      {out => ["A_pc_plus_two", $pch_sz],   in => "M_pc_plus_two",
       enable => "A_en"},
      {out => ["A_ld_done", 1],             in => $dhp_pending_ld_d1 . "M_dhp_ld_done | M_d_ld_done | (M_ctrl_ld & M_sel_dtcm)",
       enable => "A_en"},
    );

    e_register->adds(
      {out => ["A_dtcm_readdata", 32],           in => $dtcm_present ? "M_dtcm_readdata" : "0",
       enable => "A_en"},
      {out => ["A_dtcm_response", 2],            in => $dtcm_present ? "M_dtcm_response" : "0",
       enable => "A_en"},
      {out => ["A_dhp_readdata", 32],            in => $dhp_present ? "dhp_pending_ld_done_d1 ? dhp_pending_readdata : dhp_readdata" : "0",
       enable => "A_en"},
      {out => ["A_dhp_response", 2],             in => $dhp_present ? "dhp_pending_ld_done_d1 ? dhp_pending_response : dhp_response" : "0",
       enable => "A_en"},
      {out => ["A_d_readdata", 32],              in => "d_readdata_d1",
       enable => "A_en"},
      {out => ["A_d_response", 2],              in => "d_response_d1",
       enable => "A_en"},
    );
    
    e_assign->adds(
       [["A_ld_data_unaligned_sel", 2], "{A_sel_dtcm, A_sel_dhp}"],           
    );

    e_mux->add ({
      lhs => ["A_slow_ld_data_unaligned", $datapath_sz],
      selecto => "A_ld_data_unaligned_sel",
      table => [
        "2'b10" => "A_dtcm_readdata",
        "2'b01" => "A_dhp_readdata",
        "2'b00" => "A_d_readdata",
        ],
      });


    e_mux->add ({
      lhs => ["A_data_response", 2],
      selecto => "A_ld_data_unaligned_sel",
      table => [
        "2'b10" => "A_dtcm_response",
        "2'b01" => "A_dhp_response",
        "2'b00" => "A_d_response",
        ],
      });
    

    e_assign->adds(
       [["A_bus_data_read_error", 1, 0, $force_never_export], "(A_data_response != 0) & A_ld_done & A_valid_from_M & ~pending_bus_data_read_err"],
       [["A_bus_data_read_error_A_refetch_required", 1, 0, $force_never_export], "A_bus_data_read_error"],
    );


    e_register->adds(
        {out => ["W_bus_data_read_error", 1],  
         in => "A_bus_data_read_error", enable => "1'b1"},
         
         {out => ["pending_bus_data_read_err", 1],  
          in => "pending_bus_data_read_err ?
                 ~(M_valid_from_E & ~A_pipe_flush) :
                 W_bus_data_read_error",
          enable => "1'b1"},
    );

    new_exc_signal({
       exc             => $bus_data_read_error_exc,
       initial_stage   => "E", 
       rhs             => "pending_bus_data_read_err",
    });

    e_assign->adds(
       [["A_mem_waddr", $mem_baddr_sz-2, 0, $force_never_export], "A_mem_baddr[$mem_baddr_sz-1:2]"],
    );

    if ($cdx_present) {
        e_assign->adds(
          [["M_br_16b_baddr", $pcb_sz], 
             "M_op_br_n ? ({M_pc_plus_one, 1'b0} + {{21 {M_iw_i10_imm10[9]}}, M_iw_i10_imm10[9:0],1'b0}) :
                          ({M_pc_plus_one, 1'b0} + {{24 {M_iw_t1i7_imm7[6]}}, M_iw_t1i7_imm7[6:0],1'b0})" ],
          [["M_br_32b_baddr", $pcb_sz], 
             "({M_pc_plus_two, 1'b0} + {{16 {M_iw_imm16[15]}}, M_iw_imm16})"],
        );
    }

    e_assign->adds(


      [["A_br_jmp_target_pcb_nxt", $pcb_sz], 
        $cdx_present ?
        "M_ctrl_br ? 
            M_ctrl_narrow ? M_br_16b_baddr : M_br_32b_baddr :
          M_target_pcb" :
        "M_ctrl_br ? 
          ({M_pc_plus_two, 1'b0} + {{16 {M_iw_imm16[15]}}, M_iw_imm16}) :
          M_target_pcb"],
    );


    foreach my $master (@{$Opt->{avalon_data_master_list}}) {
        e_register->adds(
          {out => ["A_sel_${master}", 1, 0, $force_never_export],
           in => "M_sel_${master}", enable => "A_en"},
        );
    }

    e_assign->adds(
      [["A_dtcm_ld", 1, 0, $force_never_export], "(A_ctrl_ld|A_multiple_ld) & A_sel_dtcm"],
      [["A_dtcm_st", 1, 0, $force_never_export], "(A_ctrl_st|A_multiple_st) & A_sel_dtcm & A_st_writes_mem"],
      
      [["A_sel_dhp", 1, 0, $force_never_export], "A_sel_data_master_high_performance"],

      [["A_dhp_ld", 1, 0, $force_never_export], "(A_ctrl_ld|A_multiple_ld) & A_sel_dhp"],
      [["A_dhp_st", 1, 0, $force_never_export], "(A_ctrl_st|A_multiple_st) & A_sel_dhp & A_st_writes_mem"],
    );

    e_register->adds(

      {out => ["A_exc_break", 1],            in => "M_exc_break",
       enable => "A_en"},
      {out => ["A_exc_crst", 1],             in => "M_exc_crst",
       enable => "A_en"},
      {out => ["A_exc_ext_intr", 1],         in => "M_exc_ext_intr",
       enable => "A_en"},
      {out => ["A_br_jmp_target_pcb", $pcb_sz, 0, $force_never_export],
       in => "A_br_jmp_target_pcb_nxt",
       enable => "A_en"},
      {out => ["A_exc_allowed", 1],          in => "M_exc_allowed", 
       enable => "1'b1"},
    );





    e_register->adds(
      {out => ["A_exc_any_from_M",  1],                    in => "M_exc_any",
       enable => "A_en"},
    );
    

    my @A_stage_exception_list;
    push(@A_stage_exception_list, "A_exc_any_from_M");
    
    e_assign->adds(
      [["A_exc_any", 1], join('|', @A_stage_exception_list)],
    );













    e_assign->adds(

      [["A_non_flushing_wrctl", 1], 
        $mpu_present ? 
          "A_ctrl_wrctl_inst & 
            ((A_iw_control_regnum == $mpubase_reg_regnum) |
             (A_iw_control_regnum == $mpuacc_reg_regnum))" :
          "0"],


      [["A_pipe_flush", 1], 
        "(((A_ctrl_flush_pipe_always & ~A_non_flushing_wrctl) | A_exc_any) & 
          A_valid_from_M) | A_refetch_required"],
    );



    my $pipe_flush_haddr_mux_table = [];

    push(@$pipe_flush_haddr_mux_table, 

      "A_refetch_required" => "A_pc",
    );
    
    my $oci_version = manditory_int($Opt, "oci_version");
    
    if ($oci_version == 1) {

        push(@$pipe_flush_haddr_mux_table, 

          "A_exc_break" => manditory_int($Opt, "break_word_addr") * 2,
        );
    }

    if ($cpu_reset) {
        push(@$pipe_flush_haddr_mux_table, 

          "A_exc_crst" => (manditory_bool($Opt, "export_vectors") ? 
            "{reset_vector_word_addr,1'b0}" :
            $reset_pch),
        );
    }

    if ($eic_present) {
         push(@$pipe_flush_haddr_mux_table, 

          "A_exc_ext_intr" => "A_eic_rha[$pcb_sz-1:1]",
        );
    }

    push(@$pipe_flush_haddr_mux_table, 

      "A_exc_any" => (manditory_bool($Opt, "export_vectors") ?  
        "{exception_vector_word_addr,1'b0}" :
        $exception_pch),


      "A_ctrl_jmp_indirect" => "A_target_pcb[$pcb_sz-1:1]",



      "1'b1" => "A_npc",
    );

    e_mux->add ({
      lhs => ["A_pipe_flush_haddr", $pch_sz],
      type => "priority",
      table => $pipe_flush_haddr_mux_table,
    });


    e_signal->adds({name => "A_pipe_flush_baddr", never_export => 1, width => $pcb_sz});
    e_assign->adds(["A_pipe_flush_baddr", "{A_pipe_flush_haddr, 1'b0}"]);













    my $rf_wr_mux_table = [];

    if ($eic_and_shadow) {



        e_register->adds(
            {out => ["W_sstatus_reg", 32], in => "W_sstatus_reg_nxt",
             enable => "W_en"},
        );
        push(@$rf_wr_mux_table, 
          "W_exc_wr_sstatus"                    => "W_sstatus_reg",
        );
    }






    push(@$rf_wr_mux_table, 
      "A_exc_any"                           => "{ A_pc_plus_two, 1'b0 }",
    );




    e_assign->adds(
      [["A_exc_addr", $datapath_sz, 0, $force_never_export], "{ A_npc, 1'b0 }"],
    );

    push(@$rf_wr_mux_table, 
      "(A_ctrl_ld|A_multiple_ld)"           => "A_slow_ld_data_aligned",
    );
    
    push(@$rf_wr_mux_table, 
      "1'b1"                            => "A_inst_result",
    );

    e_mux->add ({
      lhs => ["A_wr_data_unfiltered", $datapath_sz],
      type => "priority",
      table => $rf_wr_mux_table,
    });


    e_assign->adds(
      [["A_ld_data", $datapath_sz, 0, $force_never_export], "A_slow_ld_data_aligned"],
    );


    e_assign->adds(
      [["A_fwd_reg_data", $datapath_sz], "A_wr_data_filtered"],
    );





    e_assign->adds(


      [["A_exc_any_active", 1], "A_exc_any & A_exc_allowed"],
      [["A_exc_break_active", 1], "A_exc_break & A_exc_allowed"],
      [["A_exc_crst_active", 1], "A_exc_crst & A_exc_allowed"],
      [["A_exc_ext_intr_active", 1, 0, $force_never_export], 
        "A_exc_ext_intr & A_exc_allowed"],
    


      [["A_exc_shadow", 1], 
        $eic_and_shadow ? "A_exc_ext_intr & A_eic_rrs_non_zero" : "0"],
      [["A_exc_shadow_active", 1], "A_exc_shadow & A_exc_allowed"],
    
      [["A_exc_active_no_break", 1], 
         "A_exc_any_active & ~A_exc_break"],
    
      [["A_exc_active_no_crst", 1, 0, $force_never_export], 
         "A_exc_any_active & ~A_exc_crst"],
      [["A_exc_active_no_break_no_crst", 1, 0, $force_never_export], 
         "A_exc_any_active & ~(A_exc_break | A_exc_crst)"],
    






      [["A_exc_wr_ea_ba", 1],
        $status_reg_eh ?
          "A_exc_break_active |
            (A_exc_active_no_break_no_crst & ~W_exc_handler_mode)" :
          "A_exc_active_no_crst"],
    




      [["A_exc_wr_sstatus", 1], 
        "A_exc_shadow_active & ~W_exc_handler_mode"],
    

      [["A_dst_regnum", $regnum_sz],
        "W_exc_wr_sstatus ? $sstatus_regnum :
         A_exc_break      ? $bretaddr_regnum :
         A_exc_any        ? $eretaddr_regnum :
                            A_dst_regnum_from_M"],
    






      [["A_wr_dst_reg", 1], 
        "~A_cancel_ignore_exc & (A_wr_dst_reg_from_M | A_exc_wr_ea_ba | W_exc_wr_sstatus)"],
    



      [["W_debug_mode_nxt", 1],
        "A_exc_break_active            ? 1'b1 :
         (A_valid & A_op_bret)         ? 1'b0 : 
                                         W_debug_mode"],
    );
    
    if ($shadow_present) {
        e_assign->adds(





          [["A_dst_regset", $rf_set_sz], 
            "W_exc_wr_sstatus ? W_status_reg_crs : " .
            ($eic_present ?  "A_exc_ext_intr_active ? A_eic_rrs : " : "") .
            "A_exc_any ? 0 :
             (A_valid & A_op_wrprs) ? W_status_reg_prs : 
                          W_status_reg_crs"],
        );
    }
    
    e_register->adds(
      {out => ["W_exc_wr_sstatus", 1], in => "A_exc_wr_sstatus",
       enable => "W_en"},
    );
    
    push(@$exc_wave_signals_ref,
      { radix => "x", signal => "A_exc_allowed" },
      { radix => "x", signal => "A_exc_any " },
      { radix => "x", signal => "A_exc_break" },
      { radix => "x", signal => "A_exc_crst" },
      { radix => "x", signal => "A_exc_ext_intr" },
      { radix => "x", signal => "A_exc_any_active" },
      { radix => "x", signal => "A_exc_break_active" },
      { radix => "x", signal => "A_exc_active_no_break_no_crst" },
      { radix => "x", signal => "A_exc_active_no_break" },
      { radix => "x", signal => "A_exc_shadow_active" },
      { radix => "x", signal => "A_exc_wr_ea_ba" },
      { radix => "x", signal => "A_wr_dst_reg" },
      { radix => "x", signal => "W_debug_mode_nxt" },
    );
       
    if ($illegal_mem_exc) {
        push(@$exc_wave_signals_ref,
          get_exc_signal_wave($misaligned_data_addr_exc, "A"),
          get_exc_signal_wave($misaligned_target_pc_exc, "A"),
        );
    }





    push(@$exc_wave_signals_ref,
      { radix => "x", signal => "A_refetch_required" },
      { radix => "x", signal => "A_cancel" },
    );

    my @A_refetch_required_signal;
    if ($dc_ecc_present) {
        push(@A_refetch_required_signal, "A_dc_ecc_A_refetch_required")
    }
    if ($dtcm_ecc_present) {
        push(@A_refetch_required_signal, "A_dtcm_ecc_A_refetch_required")
    }


    push(@A_refetch_required_signal, "A_bus_data_read_error_A_refetch_required");

    e_assign->adds(






      [["A_refetch_required", 1], scalar(@A_refetch_required_signal) ? join('|', @A_refetch_required_signal) : "0"],



      [["A_cancel", 1], "A_refetch_required | A_exc_any"],
      [["A_cancel_ignore_exc", 1], "A_refetch_required"],


      [["A_valid", 1], "A_valid_from_M & ~A_cancel"],
    );
}




sub
make_W_stage()
{
    my $Opt = shift;


    e_assign->adds(
      [["W_en", 1, 0, $force_never_export], "1'b1"],
    );

    e_signal->adds(

      {name => "W_iw",          never_export => 1, width => $iw_sz},
      {name => "W_valid",       never_export => 1, width => 1},
      {name => "W_valid_from_M",       never_export => 1, width => 1},
      {name => "W_wr_dst_reg",  never_export => 1, width => 1},
      {name => "W_dst_regnum",  never_export => 1, width => $regnum_sz},
    );



    e_register->adds(    




      {out => "W_iw",         in => "A_iw",           enable => "1'b1"},
      {out => "W_valid",      in => "A_valid & A_en", enable => "1'b1"},
      {out => "W_valid_from_M",      in => "A_valid_from_M & A_en", enable => "1'b1"},	#non-cancellable valid for oci v2
      {out => "W_wr_dst_reg", in => "A_wr_dst_reg & A_en", enable => "1'b1"},
      {out => "W_dst_regnum", in => "A_dst_regnum",   enable => "1'b1"},

      {out => ["W_mem_baddr", $mem_baddr_sz, 0, $force_never_export],
       in => "A_mem_baddr",         enable => "1'b1"},
      {out => ["W_mem_byte_en", $byte_en_sz, 0, $force_never_export],
       in => "A_mem_byte_en",       enable => "1'b1"},
    );

    if ($shadow_present) {
        e_signal->adds(

          {name => "W_dst_regset",  never_export => 1, width => $rf_set_sz},
        );

        e_register->adds(
          {out => "W_dst_regset", in => "A_dst_regset",   enable => "1'b1"},
        );
    }

    e_register->adds(
      {out => ["W_debug_mode", 1],
       in => "W_debug_mode_nxt",                enable => "1'b1" },
 
      {out => ["W_exc_crst_active", 1, 0, $force_never_export],
       in => "A_exc_crst_active",               enable => "1'b1" },
    );
 
    e_assign->adds(
      [["W_exc_handler_mode", 1, 0, $force_never_export], 
        $status_reg_eh ? "W_status_reg_eh" : "0"],
    );
}


sub
gen_brpred
{
    my $Opt = shift;

    my $brpred_type = not_empty_scalar($Opt, "branch_prediction_type");



    if ($brpred_type eq $STATIC_BRPRED) {
        nios_brpred::backend_gen_static_brpred($Opt);
    } elsif ($brpred_type eq $DYNAMIC_BRPRED) {
        nios_brpred::backend_gen_dynamic_brpred($Opt);

        if (!manditory_bool($Opt, "bht_index_pc_only")) {
            e_assign->adds(
              [["E_add_br_to_taken_history_unfiltered", 1], 
                "(E_ctrl_br_cond & E_valid)"],
            );
        }
    } else {
        &$error("Unsupported branch_predition_type of '$brpred_type'");
    }
}


sub 
make_register_file
{
    my $Opt = shift;

    my $crs = 
      $shadow_present ? not_empty_scalar($Opt, "current_register_set") : undef;
    my $prs = 
      $shadow_present ? not_empty_scalar($Opt, "previous_register_set") : undef;

    if ($cdx_present) {
        my $rf_3b_mux_table = [];
        push(@$rf_3b_mux_table, "0" => "16", );
        push(@$rf_3b_mux_table, "1" => "17", );
        push(@$rf_3b_mux_table, "2" => "2", );
        push(@$rf_3b_mux_table, "3" => "3", );
        push(@$rf_3b_mux_table, "4" => "4", );
        push(@$rf_3b_mux_table, "5" => "5", );
        push(@$rf_3b_mux_table, "6" => "6", );
        push(@$rf_3b_mux_table, "7" => "7", );
        
        e_mux->add({
          lhs   => ["D_iw_5b_dec_a3", 5],
          selecto => "D_iw_a3",
          table => $rf_3b_mux_table,
        }),
        
        e_mux->add({
          lhs   => ["D_iw_5b_dec_b3", 5],
          selecto => "D_iw_b3",
          table => $rf_3b_mux_table,
        }),
        
        e_mux->add({
          lhs   => ["D_iw_5b_dec_c3", 5],
          selecto => "D_iw_c3",
          table => $rf_3b_mux_table,
        }),
    }
   
    if ($cdx_present) {
        my $iw_a_rf_mux_table = [];
        my $iw_b_rf_mux_table = [];
        push(@$iw_a_rf_mux_table, "D_op_ret_n"                    => "$retaddr_regnum",);
        push(@$iw_a_rf_mux_table, "D_ctrl_implicit_src1_sp_regnum"=> "$sp_regnum",);
        push(@$iw_a_rf_mux_table, "D_ctrl_a3_is_src"              => "D_iw_5b_dec_a3",);

        push(@$iw_b_rf_mux_table, "D_ctrl_multiple_loads"         => "$retaddr_regnum",);
        push(@$iw_b_rf_mux_table, "D_ctrl_multiple_stores"        => "D_multiple_dst",);
        push(@$iw_b_rf_mux_table, "D_ctrl_b3_is_src"              => "D_iw_5b_dec_b3 & ~{5{D_is_stz_n_inst}}",);
        
        e_mux->add ({
          lhs => ["D_iw_a_rf", $rf_addr_sz],
          type => "and_or",
          table => $iw_a_rf_mux_table,
          default => "D_iw_a",
          });
    
        e_mux->add ({
          lhs => ["D_iw_b_rf", $rf_addr_sz],
          type => "and_or",
          table => $iw_b_rf_mux_table,
          default => "D_iw_b",
          });
    } else {
        e_assign->adds(
           [["D_iw_a_rf",5], "D_iw_a"],
           [["D_iw_b_rf",5], "D_iw_b"],
        );
    }


   
    my $rf_port_map = {
     clk       => "clk",
     rdaddress_a => "D_iw_a_rf",
     rdaddress_b => "D_iw_b_rf",
     q_a         => "D_rf_a",
     q_b         => "D_rf_b",
     wren      => "A_wr_dst_reg",
     data      => "A_wr_data_filtered",
     wraddress => "A_dst_regnum",
    };

    if ($register_file_por) {
    	 $rf_port_map->{reset_n} = "por_rf_n";
    }

    if ($shadow_present) {
        e_assign->adds(




          [["D_regset_rf", $rf_set_sz], 
            "D_issue_rdprs ? $prs : $crs"],
        );
        
        $rf_port_map->{rdshadow_set} = "D_regset_rf";
        $rf_port_map->{wrshadow_set} = "A_dst_regset";
    }

    e_assign->adds(


      [["E_src1_corrupt", 1],       "0"],
      [["E_src2_corrupt", 1],       "0"],
    );

    e_register->adds(

      {out => ["M_src1_corrupt", 1, 0, $force_never_export], 
       in => "E_src1_corrupt",                      enable => "M_en"},
      {out => ["M_src2_corrupt", 1, 0, $force_never_export], 
       in => "E_src2_corrupt",                      enable => "M_en"},
    );

    nios_register_file_ram->add({
      name => $Opt->{name} . "_register_bank",,
      register_file_por       => $register_file_por,
      data_width              => $datapath_sz,
      address_width           => $regnum_sz,
      shadow_present          => $shadow_present,
      shadow_num_set          => $rf_num_set,
      shadow_set_sz           => $rf_set_sz,
      port_map                => $rf_port_map,
    });
   
    my @src_operands = (
        { divider => "register_file" },
        { radix => "x", signal => "D_iw_a_rf" },
        { radix => "x", signal => "D_iw_b_rf" },
        $shadow_present ? { radix => "x", signal => "D_regset_rf" } : "",
        $shadow_present ? { radix => "x", signal => "D_ctrl_rdprs" } : "",
        $shadow_present ? { radix => "x", signal => $crs } : "",
        $shadow_present ? { radix => "x", signal => $prs } : "",
        { radix => "x", signal => "D_rf_a" },
        { radix => "x", signal => "D_rf_b" },
        { radix => "x", signal => "A_wr_dst_reg" },
        { radix => "x", signal => "A_dst_regnum" },
        $shadow_present ? { radix => "x", signal => "A_dst_regset" } : "",
        { radix => "x", signal => "A_wr_data_unfiltered" },
        { radix => "x", signal => "A_wr_data_filtered" },
    );

    push(@plaintext_wave_signals, @src_operands);
}

sub
gen_master_mem
{


    my $Opt = shift;
    e_assign->adds(


      [["E_master_mem_baddr", $mem_baddr_sz], "(dmaster_waiting & ~dhp_pending_d1) ? M_master_mem_baddr : E_mem_baddr"],
      [["E_master_mem_writedata", $datapath_sz], "(dmaster_waiting & ~dhp_pending_d1) ? M_master_mem_writedata : E_st_data"],
      [["E_master_mem_byteenable", $byte_en_sz], "(dmaster_waiting & ~dhp_pending_d1) ? M_master_mem_byteenable : E_mem_byte_en"],
    );
    

    e_assign->adds(
      [["d_waiting", 1], "(d_read | d_write)"],
      [["dhp_waiting", 1], "(dhp_read | dhp_write) & dhp_waitrequest"],
      [["dmaster_waiting", 1], "d_waiting | dhp_waiting_d1"],
    );
    
    e_register->adds(
      {out => ["M_master_mem_baddr", $mem_baddr_sz], in => "E_master_mem_baddr", 
       enable => "~M_mem_stall"},
      {out => ["M_master_mem_writedata", $datapath_sz], in => "E_master_mem_writedata", 
       enable => "~M_mem_stall"},
      {out => ["M_master_mem_byteenable", $byte_en_sz], in => "E_master_mem_byteenable", 
       enable => "~M_mem_stall"},
      {out => ["dhp_waiting_d1", 1],   in => "dhp_waiting", 
       enable => "1'b1"},
    );
}




sub 
gen_dtcm_masters
{
    my $Opt = shift;

    for (my $cmi = 0; $cmi < manditory_int($Opt, "num_tightly_coupled_data_masters"); $cmi++) {
        gen_one_dtcm_master($Opt, $cmi);
    }
}

sub 
gen_one_dtcm_master
{
    my $Opt = shift;
    my $cmi = shift;

    my $master_name = "tightly_coupled_data_master_${cmi}";
    my $slave_addr_width = $Opt->{$master_name}{Slave_Address_Width};
    my $master_addr_width = $Opt->{$master_name}{Address_Width};
    my $dtcm_data_sz = 32;

    my %port_map = (
      "dtcm${cmi}_readdata"       => "readdata",
      "dtcm${cmi}_response"       => "response",
      "dtcm${cmi}_address"        => "address",
      "dtcm${cmi}_read"           => "read",
      "dtcm${cmi}_write"          => "write",
      "dtcm${cmi}_clken"          => "clken",
      "dtcm${cmi}_writedata"      => "writedata",
    );
    
    my @port_list = (
      ["dtcm${cmi}_readdata"      => $dtcm_data_sz,           "in" ],
      ["dtcm${cmi}_response"      => 2,                       "in" ],
      ["dtcm${cmi}_address"       => $master_addr_width,      "out"],
      ["dtcm${cmi}_read"          => 1,                       "out"],
      ["dtcm${cmi}_write"         => 1,                       "out"],
      ["dtcm${cmi}_clken"         => 1,                       "out"],
      ["dtcm${cmi}_writedata"     => $dtcm_data_sz,           "out"],
    );

    $port_map{"dtcm${cmi}_byteenable"} = "byteenable";
    push(@port_list, 
      ["dtcm${cmi}_byteenable"    => $byte_en_sz,             "out"],
    );

















    my $E_addr_expr;

    if ($slave_addr_width < $master_addr_width) {


        my $top_bits = not_empty_scalar($Opt->{$master_name}, "Paddr_Base_Top_Bits");

        $E_addr_expr = "{ $top_bits, E_mem_baddr[$slave_addr_width-1:0] }";
    } else {
        $E_addr_expr = "E_mem_baddr[$master_addr_width-1:0]";
    }


    my $read_expr = "(E_ctrl_ld|E_multiple_ld)";

    e_assign->adds(
      [["dtcm${cmi}_writedata", $datapath_sz], "E_st_data"],




      [["dtcm${cmi}_byteenable", $byte_en_sz], 
        "E_mem_byte_en"],
    );

    e_assign->adds(

      [["E_dtcm${cmi}_want_wr", 1], "(E_ctrl_st|E_multiple_st) & E_st_writes_mem & E_valid & E_sel_${master_name}"],




      [["dtcm${cmi}_address", $master_addr_width], "$E_addr_expr"],





      [["dtcm${cmi}_write", 1], "E_dtcm${cmi}_want_wr"],

      [["dtcm${cmi}_read", 1], "1'b1"],   # Always read to prevent bad timing from E_sel_* signal.



      [["dtcm${cmi}_clken", 1], "E_en"],
    );

    $Opt->{$master_name}{port_map} = \%port_map;
    $Opt->{$master_name}{sideband_signals} = [ "clken" ];
    push(@{$Opt->{port_list}}, @port_list);
}




sub 
gen_dhp_master
{
    my $Opt = shift;

    my $master_name = "data_master_high_performance";
    my $dhp_data_sz = 32;

    if ($dhp_present) {
        my $slave_addr_width = $Opt->{$master_name}{Slave_Address_Width};
        my $master_addr_width = $Opt->{$master_name}{Address_Width};
        
        my %port_map = (
          "dhp_readdata"       => "readdata",
          "dhp_waitrequest"    => "waitrequest",
          "dhp_response"       => "response",
          "dhp_readdatavalid"  => "readdatavalid",
          "dhp_address"        => "address",
          "dhp_read"           => "read",
          "dhp_write"          => "write",
          "dhp_writedata"      => "writedata",
        );
        
        my @port_list = (
          ["dhp_readdata"      => $dhp_data_sz,            "in" ],
          ["dhp_waitrequest"   => 1,                       "in" ],
          ["dhp_response"      => 2,                       "in" ],
          ["dhp_readdatavalid" => 1,                       "in" ],
          ["dhp_address"       => $master_addr_width,      "out"],
          ["dhp_read"          => 1,                       "out"],
          ["dhp_write"         => 1,                       "out"],
          ["dhp_writedata"     => $dhp_data_sz,            "out"],
        );
        
        $port_map{"dhp_byteenable"} = "byteenable";
        push(@port_list, 
          ["dhp_byteenable"    => $byte_en_sz,             "out"],
        );
        















        
        my $E_addr_expr;
        
        if ($slave_addr_width < $master_addr_width) {


            my $top_bits = not_empty_scalar($Opt->{$master_name}, "Paddr_Base_Top_Bits");
        
            $E_addr_expr = "E_master_mem_baddr[$master_addr_width-1:0]";
        } else {
            $E_addr_expr = "E_master_mem_baddr[$master_addr_width-1:0]";
        }

        e_assign->adds(
          [["dhp_writedata", $datapath_sz], "E_master_mem_writedata"],
        



          [["dhp_byteenable", $byte_en_sz], "E_master_mem_byteenable"],
        );
        
        e_assign->adds(


          [["E_dhp_want_wr", 1], "(E_ctrl_st|E_multiple_st) & E_st_writes_mem & E_valid & E_sel_${master_name} & ~(dmaster_waiting|dhp_pending_d1) & E_en"],
          [["E_dhp_want_rd", 1], "(E_ctrl_ld|E_multiple_ld) & E_valid & E_sel_${master_name} & ~(dmaster_waiting|dhp_pending_d1) & E_en"],
        

          [["dhp_address", $master_addr_width],  "$E_addr_expr"],
        


          [["dhp_write", 1], "E_dhp_want_wr | (dhp_write_d1 & dhp_waitrequest_d1)"],
          [["dhp_read", 1], "E_dhp_want_rd | (dhp_read_d1 & dhp_waitrequest_d1)"],
          

          [["M_dhp_st_done", 1], "(dhp_write_d1 & ~dhp_waitrequest_d1) | dhp_pending_st_done_d1"],
          [["M_dhp_ld_done", 1], "dhp_readdatavalid | dhp_pending_ld_done_d1"],
          

          [["dhp_pending", 1], "(E_stall & (E_dhp_want_rd | E_dhp_want_wr | dhp_pending_d1))"],

          [["dhp_pending_st_done", 1], "((dhp_write_d1 & ~dhp_waitrequest_d1) | dhp_pending_st_done_d1) & dhp_pending_d1"],

          [["dhp_pending_ld_done", 1], "(dhp_readdatavalid | dhp_pending_ld_done_d1) & dhp_pending_d1 & M_stall_non_mem_d1"],
        );
        
        e_register->adds(
          {out => ["dhp_write_d1", 1],              
           in => "dhp_write",                enable => "1'b1"},
          {out => ["dhp_read_d1", 1],              
           in => "dhp_read",                 enable => "1'b1"},
          {out => ["dhp_waitrequest_d1", 1],              
           in => "dhp_waitrequest",          enable => "1'b1"},
          {out => ["dhp_pending_d1", 1],              
           in => "dhp_pending",              enable => "1'b1"},
          {out => ["dhp_pending_st_done_d1", 1],              
           in => "dhp_pending_st_done",      enable => "1'b1"},
          {out => ["dhp_pending_ld_done_d1", 1],              
           in => "dhp_pending_ld_done",      enable => "1'b1"},
          {out => ["M_stall_non_mem_d1", 1],              
           in => "M_stall_non_mem",          enable => "1'b1"},
          {out => ["dhp_pending_readdata", 32],              
           in => "dhp_readdata",             enable => "dhp_readdatavalid"},
          {out => ["dhp_pending_response", 2],              
           in => "dhp_response",             enable => "dhp_readdatavalid"},
        );

        $Opt->{$master_name}{port_map} = \%port_map;
        push(@{$Opt->{port_list}}, @port_list);    
      
        push(@plaintext_wave_signals, 
          { divider => "Data HP Stall" },
        );
    } else {       
        my %port_map = (
          "dhp_readdata"       => "readdata",
          "dhp_waitrequest"    => "waitrequest",
          "dhp_response"       => "response",
          "dhp_readdatavalid"  => "readdatavalid",
          "dhp_address"        => "address",
          "dhp_read"           => "read",
          "dhp_write"          => "write",
          "dhp_writedata"      => "writedata",
        );
        
        my @port_list = (
          ["dhp_readdata"      => $dhp_data_sz,            "in" ],
          ["dhp_waitrequest"   => 1,                       "in" ],
          ["dhp_response"      => 2,                       "in" ],
          ["dhp_readdatavalid" => 1,                       "in" ],
          ["dhp_address"       => 1,                       "out"],
          ["dhp_read"          => 1,                       "out"],
          ["dhp_write"         => 1,                       "out"],
          ["dhp_writedata"     => $dhp_data_sz,            "out"],
        );
        
        $port_map{"dhp_byteenable"} = "byteenable";
        push(@port_list, 
          ["dhp_byteenable"    => $byte_en_sz,             "out"],
        );
        
        $Opt->{$master_name}{port_map} = \%port_map;
        push(@{$Opt->{port_list}}, @port_list);
        
        e_assign->adds(
          [["M_dhp_st_done", 1], "0"],
          [["M_dhp_ld_done", 1], "0"],
          [["dhp_write", 1], "0"],
          [["dhp_read", 1], "0"],
          [["dhp_writedata", 32], "0"],
          [["dhp_address", 1], "0"],
          [["dhp_pending_d1", 1], "0"],
        );
    }
}


sub 
gen_data_master
{
    my $Opt = shift;

    my $data_master_interrupt_sz = manditory_int($Opt, "data_master_interrupt_sz");




    $Opt->{data_master}{port_map} = {
      clk             => "clk",
      reset_n         => "reset_n",
      d_readdata      => "readdata",
      d_waitrequest   => "waitrequest",
      d_response      => "response",
      d_writedata     => "writedata",
      d_address       => "address",
      d_byteenable    => "byteenable",
      d_read          => "read",
      d_write         => "write",

      debug_mem_slave_debugaccess_to_roms  => "debugaccess",
    };












    if (!$eic_present) {
        $Opt->{data_master}{port_map}{irq} = "irq";
    }

    my $data_master_addr_sz = $Opt->{data_master}{Address_Width};

    push(@{$Opt->{port_list}},
      [clk              => 1,                           "in" ],
      [reset_n          => 1,                           "in" ],
      [d_readdata       => $datapath_sz,                "in" ],
      [d_waitrequest    => 1,                           "in" ],
      [d_response       => 2,                           "in" ],
      [d_address        => $data_master_addr_sz,        "out"],
      [d_byteenable     => $byte_en_sz,                 "out"],
      [d_read           => 1,                           "out"],
      [d_write          => 1,                           "out"],
      [d_writedata      => $datapath_sz,                "out"],
    );













    if (!$eic_present) {
        push(@{$Opt->{port_list}},
          [irq            => $data_master_interrupt_sz,   "in" ],
        );
    }


    e_register->adds(
      {out => ["M_d_read", 1],                        in => "E_d_read",    
       enable => "1'b1"},
      {out => ["M_d_write", 1],                       in => "E_d_write",    
       enable => "1'b1"},
    );


    my @stall_start;
    my @stall_stop;

    






 

    my $data_master_addr_msb = $data_master_addr_sz > 1 ? $data_master_addr_sz - 1 : $data_master_addr_sz;
    e_assign->adds(
      [["d_address", $data_master_addr_sz],
        "M_master_mem_baddr[$data_master_addr_msb:0]"],
      [["d_writedata", $datapath_sz], "M_master_mem_writedata"],
      [["d_byteenable", $byte_en_sz], "M_master_mem_byteenable"],
      [["d_read", 1], "M_d_read"],
      [["d_write", 1], "M_d_write"],
    );
 
    e_assign->adds(


      [["E_d_start_rd", 1], "(E_ctrl_ld|E_multiple_ld) & E_valid & E_sel_data_master & ~dmaster_waiting & E_en"],
 


      [["E_d_read", 1], "E_d_start_rd | (d_read & d_waitrequest)"],
 


      [["E_d_start_wr", 1], "(E_ctrl_st|E_multiple_st) & E_st_writes_mem & E_valid & E_sel_data_master & ~dmaster_waiting & E_en"],
 


      [["E_d_write", 1], "E_d_start_wr | (d_write & d_waitrequest)"],
 


      [["M_d_st_done_nxt", 1], "d_write & ~d_waitrequest"],
 

      [["M_d_ld_done_nxt", 1], "d_read & ~d_waitrequest"],
    );
 
    e_register->adds(
      {out => ["M_d_st_done", 1],                        in => "M_d_st_done_nxt",    
       enable => "1'b1"},
      {out => ["M_d_ld_done", 1],                        in => "M_d_ld_done_nxt",    
       enable => "1'b1"},
      {out => ["d_readdata_d1", 32],                      in => "d_readdata",    
       enable => "1'b1"},
      {out => ["d_response_d1", 2],                      in => "d_response",    
       enable => "1'b1"},
    );

    my @data_master = (
        { divider => "data_master" },
        { radix => "x", signal => "d_address" },
        { radix => "x", signal => "d_read_nxt" },
        { radix => "x", signal => "d_read" },
        { radix => "x", signal => "d_write_nxt" },
        { radix => "x", signal => "d_write" },
        { radix => "x", signal => "d_writedata" },
        { radix => "x", signal => "d_waitrequest" },
        { radix => "x", signal => "d_response" },
        { radix => "x", signal => "d_byteenable" },

        { radix => "x", signal => "A_mem_stall" },
    );

    push(@plaintext_wave_signals, @data_master);
}






sub 
gen_slow_ld_aligner
{
    my $Opt = shift;


    e_assign->adds(



      [["A_slow_ld_data_sign_bit_16", 2], 
        "${big_endian_tilde}A_mem_baddr[1]  ? 
          {A_slow_ld_data_unaligned[31], A_slow_ld_data_unaligned[23]} : 
          {A_slow_ld_data_unaligned[15], A_slow_ld_data_unaligned[7]}"],


      [["A_slow_ld_data_fill_bit", 1], 
        "A_slow_ld_data_sign_bit & A_ctrl_ld_signed"],
    );







    if ($big_endian) {
      e_assign->adds(


        [["A_slow_ld_data_sign_bit", 1],
          "((~A_mem_baddr[0]) | A_ctrl_ld16) ? 
              A_slow_ld_data_sign_bit_16[0] : A_slow_ld_data_sign_bit_16[1]"],

        [["A_slow_ld16_data", 16], "(A_ld_align_sh16 | A_ctrl_ld32) ? 
          A_slow_ld_data_unaligned[31:16] :
          A_slow_ld_data_unaligned[15:0]"],
  
        [["A_slow_ld_byte0_data_aligned_nxt", 8], "(A_ctrl_ld8 & ~A_mem_baddr[0]) ? 
          A_slow_ld16_data[7:0] :
          A_slow_ld16_data[15:8]"],

        [["A_slow_ld_byte1_data_aligned_nxt", 8], "A_ld_align_byte1_fill ? 
          {8 {A_slow_ld_data_fill_bit}} : 
          A_slow_ld16_data[7:0]"],

        [["A_slow_ld_byte2_data_aligned_nxt", 8], "A_ld_align_byte2_byte3_fill ? 
          {8 {A_slow_ld_data_fill_bit}} : 
          A_slow_ld_data_unaligned[15:8]"],

        [["A_slow_ld_byte3_data_aligned_nxt", 8], "A_ld_align_byte2_byte3_fill ? 
          {8 {A_slow_ld_data_fill_bit}} : 
          A_slow_ld_data_unaligned[7:0]"],
      );
    } else {
      e_assign->adds(


        [["A_slow_ld_data_sign_bit", 1],
          "((${big_endian_tilde}A_mem_baddr[0]) | A_ctrl_ld16) ? 
              A_slow_ld_data_sign_bit_16[1] : A_slow_ld_data_sign_bit_16[0]"],

        [["A_slow_ld16_data", 16], "A_ld_align_sh16 ? 
          A_slow_ld_data_unaligned[31:16] :
          A_slow_ld_data_unaligned[15:0]"],

        [["A_slow_ld_byte0_data_aligned", 8], "A_ld_align_sh8 ? 
          A_slow_ld16_data[15:8] :
          A_slow_ld16_data[7:0]"],

        [["A_slow_ld_byte1_data_aligned", 8], "A_ld_align_byte1_fill ? 
          {8 {A_slow_ld_data_fill_bit}} : 
          A_slow_ld16_data[15:8]"],

        [["A_slow_ld_byte2_data_aligned", 8], "A_ld_align_byte2_byte3_fill ? 
          {8 {A_slow_ld_data_fill_bit}} : 
          A_slow_ld_data_unaligned[23:16]"],

        [["A_slow_ld_byte3_data_aligned", 8], "A_ld_align_byte2_byte3_fill ? 
          {8 {A_slow_ld_data_fill_bit}} : 
          A_slow_ld_data_unaligned[31:24]"],
      );
    }

    e_assign->adds(
      [["A_slow_ld_data_aligned", $datapath_sz],
        "{A_slow_ld_byte3_data_aligned, A_slow_ld_byte2_data_aligned, 
          A_slow_ld_byte1_data_aligned, A_slow_ld_byte0_data_aligned}"],
    );

    my @slow_ld_aligner = (
      { divider => "A_slow_ld_aligner" },
      { radix => "x", signal => "A_slow_ld_data_unaligned"},
      { radix => "x", signal => "A_slow_ld_data_sign_bit" },
      { radix => "x", signal => "A_slow_ld_data_fill_bit" },
      { radix => "x", signal => "A_slow_ld16_data" },
      { radix => "x", signal => "A_slow_ld_byte0_data_aligned" },
      { radix => "x", signal => "A_slow_ld_byte1_data_aligned" },
      { radix => "x", signal => "A_slow_ld_byte2_data_aligned" },
      { radix => "x", signal => "A_slow_ld_byte3_data_aligned" },
      { radix => "x", signal => "A_slow_ld_data_aligned" },
      { radix => "x", signal => "A_slow_inst_result" },
    );

    push(@plaintext_wave_signals, @slow_ld_aligner);
}





sub 
make_custom_instruction_master
{
    my $Opt = shift;


    be_make_custom_instruction_master($Opt); 

    if (nios2_custom_insts::has_multi_insts($Opt->{custom_instructions})) {

        e_register->adds(

          {out => ["M_ci_multi_src1", $datapath_sz], in => "E_src1", 
           enable => "M_en"},
          {out => ["M_ci_multi_src2", $datapath_sz], in => "E_src2", 
           enable => "M_en"},





          {out => ["M_ci_multi_stall_reg", 1], 
           in => "M_pipe_flush ? 1'b0 :
             M_ci_multi_stall_reg ? ~M_ci_multi_done : 
             (E_ctrl_custom_multi & E_valid & M_en)",
           enable => "1'b1"},



          {out => ["M_ci_multi_start_reg", 1], 
           in => "M_ci_multi_start_reg ? 1'b0 : 
             (E_ctrl_custom_multi & E_valid & M_en)",
           enable => "1'b1"},
        );


        e_assign->adds(
          [["M_ci_multi_start", 1], "M_ci_multi_start_reg & M_valid"],
          [["M_ci_multi_stall", 1], "M_ci_multi_stall_reg & M_valid"],
        );




        e_assign->add([["M_ci_multi_clk_en", 1], "M_ci_multi_stall"]);
        e_assign->add([["M_ci_multi_clock", 1], "clk"]);
        e_assign->add([["M_ci_multi_reset", 1], "~reset_n"]);
        e_assign->add([["M_ci_multi_reset_req", 1], "reset_req"]);
    }
}





sub 
make_reg_cmp
{
    my $Opt = shift;

    my $ds = not_empty_scalar($Opt, "dispatch_stage");
    



    e_assign->adds(
      [["E_regnum_a_cmp_D", 1], "(D_iw_a_rf == E_dst_regnum) & E_wr_dst_reg"],
      [["M_regnum_a_cmp_D", 1], "(D_iw_a_rf == M_dst_regnum) & M_wr_dst_reg"],
      [["A_regnum_a_cmp_D", 1], "(D_iw_a_rf == A_dst_regnum) & A_wr_dst_reg"],

      [["E_regnum_b_cmp_D", 1], "(D_iw_b_rf == E_dst_regnum) & E_wr_dst_reg"],
      [["M_regnum_b_cmp_D", 1], "(D_iw_b_rf == M_dst_regnum) & M_wr_dst_reg"],
      [["A_regnum_b_cmp_D", 1], "(D_iw_b_rf == A_dst_regnum) & A_wr_dst_reg"],
      );






    e_register->adds(


      {out => ["E_src1_from_rf", 1, 0, $force_never_export],
       in => "~(D_src1_choose_E | D_src1_choose_M | D_src1_choose_A)",
       enable => "E_en"},
      {out => ["E_src2_from_rf", 1, 0, $force_never_export],
       in => "~(D_src2_choose_E | D_src2_choose_M | D_src2_choose_A)",
       enable => "E_en"},
      );





    e_assign->adds(

      [["D_ctrl_a_is_src", 1], $cdx_present ? "~(D_ctrl_a_not_src|D_ctrl_a3_not_src)" : "~D_ctrl_a_not_src"],
      [["D_ctrl_b_is_src", 1], $cdx_present ? "~(D_ctrl_b_not_src|D_ctrl_b3_not_src)" : "~D_ctrl_b_not_src"],
      [["E_ctrl_a_is_src", 1, 0, $force_never_export], "~E_ctrl_a_not_src"],
      [["E_ctrl_b_is_src", 1, 0, $force_never_export], "~E_ctrl_b_not_src"],





      [["D_src1_hazard_E", 1], "E_regnum_a_cmp_D & D_ctrl_a_is_src"],
      [["D_src1_hazard_M", 1], "M_regnum_a_cmp_D & D_ctrl_a_is_src"],
      [["D_src1_hazard_A", 1], "A_regnum_a_cmp_D & D_ctrl_a_is_src"],
    
      [["D_src2_hazard_E", 1], "E_regnum_b_cmp_D & D_ctrl_b_is_src"],
      [["D_src2_hazard_M", 1], "M_regnum_b_cmp_D & D_ctrl_b_is_src"],
      [["D_src2_hazard_A", 1], "A_regnum_b_cmp_D & D_ctrl_b_is_src"],



      [["D_src1_other_rs", 1], 
        $shadow_present ?
          "D_ctrl_rdprs & (W_status_reg_crs != W_status_reg_prs)" :
          "0"],








      [["D_src1_choose_E", 1], "D_src1_hazard_E & ~D_src1_other_rs"],
      [["D_src1_choose_M", 1], "D_src1_hazard_M & ~D_src1_other_rs"],
      [["D_src1_choose_A", 1], "D_src1_hazard_A & ~D_src1_other_rs"],
    

      [["D_src2_choose_E", 1], "D_src2_hazard_E"],
      [["D_src2_choose_M", 1], "D_src2_hazard_M"],
      [["D_src2_choose_A", 1], "D_src2_hazard_A"],






      [["D_data_depend", 1], 
        "((D_src1_hazard_E | D_src2_hazard_E) & E_ctrl_late_result) |
         ((D_src1_hazard_M | D_src2_hazard_M) & M_ctrl_late_result)"],












      [["D_wr_dst_reg", 1], 
        "(D_dst_regnum != 0) & ~(D_ctrl_ignore_dst|D_multiple_st) & D_valid"],
    );

    if ($cdx_present) {
        e_assign->adds(
           [["D_dstfield_regnum_a", $regnum_sz], "D_iw_5b_dec_a3"],
           [["D_dstfield_regnum_b", $regnum_sz], "D_ctrl_b3_is_dst ? D_iw_5b_dec_b3 : D_iw_b"],
           

           [["D_dstfield_regnum_c_sel", 2], "{D_ctrl_c3_is_dst,(D_ctrl_multiple_loads|D_ctrl_multiple_stores)}"],           
           [["D_dstfield_regnum_sel", 2], "{D_ctrl_a3_is_dst,(D_ctrl_b_is_dst|D_ctrl_b3_is_dst)}"],
        );
        
        e_mux->add ({
          lhs => ["D_dstfield_regnum_c", $regnum_sz],
          selecto => "D_dstfield_regnum_c_sel",
          table => [
            "2'b01" => "D_multiple_dst",
            "2'b10" => "D_iw_5b_dec_c3",
            "2'b00" => "D_iw_c",
            ],
          });

        e_mux->add ({
          lhs => ["D_dstfield_regnum", $regnum_sz],
          selecto => "D_dstfield_regnum_sel",
          table => [
            "2'b01" => "D_dstfield_regnum_b",
            "2'b10" => "D_dstfield_regnum_a",
            "2'b00" => "D_dstfield_regnum_c",
            ],
          });
        
        my $dst_regnum_mux_table = [];
        push(@$dst_regnum_mux_table, "D_ctrl_implicit_dst_retaddr"  => "$retaddr_regnum",);
        push(@$dst_regnum_mux_table, "D_op_break_n"                 => "$bretaddr_regnum",);
        push(@$dst_regnum_mux_table, "D_ctrl_implicit_dst_eretaddr" => "$eretaddr_regnum",);
        push(@$dst_regnum_mux_table, "D_is_spi_n_inst"              => "$sp_regnum",);
        e_mux->add ({
          lhs => ["D_dst_regnum", 5],
          type => "and_or",
          table => $dst_regnum_mux_table,
          default => "D_dstfield_regnum",
          });

    } else {
        e_assign->adds(

          [["D_dstfield_regnum_b", $regnum_sz], "D_iw_b"],
          [["D_dstfield_regnum_c", $regnum_sz], "D_iw_c"],
          
          [["D_dstfield_regnum", $regnum_sz], "D_ctrl_b_is_dst ? D_dstfield_regnum_b : D_dstfield_regnum_c"],
          [["D_dst_regnum", $regnum_sz], 
            "D_ctrl_implicit_dst_retaddr ? $retaddr_regnum : 
             D_ctrl_implicit_dst_eretaddr ? $eretaddr_regnum : 
             D_dstfield_regnum"],
        );
    }

    my @reg_cmp = (
        { divider => "reg_cmp" },
        { radix => "x", signal => "E_regnum_a_cmp_D" },
        { radix => "x", signal => "M_regnum_a_cmp_D" },
        { radix => "x", signal => "A_regnum_a_cmp_D" },
        { radix => "x", signal => "E_regnum_b_cmp_D" },
        { radix => "x", signal => "M_regnum_b_cmp_D" },
        { radix => "x", signal => "A_regnum_b_cmp_D" },
        { radix => "x", signal => "D_ctrl_a_is_src" },
        { radix => "x", signal => "D_ctrl_b_is_src" },
        { radix => "x", signal => "D_ctrl_ignore_dst" },
        { radix => "x", signal => "D_ctrl_src2_choose_imm" },
        { radix => "x", signal => "D_src1_other_rs" },
        { radix => "x", signal => "D_data_depend" },
        { radix => "x", signal => "D_dstfield_regnum" },
        { radix => "x", signal => "D_dst_regnum" },
        { radix => "x", signal => "D_wr_dst_reg" },
        { radix => "x", signal => "E_ctrl_late_result" },
        { radix => "x", signal => "M_ctrl_late_result" },
      );

    push(@plaintext_wave_signals, @reg_cmp);
}




sub 
make_src_operands
{
    my $Opt = shift;

    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");
    my $r1 = ($cpu_arch_rev == 1);
    my $r2 = ($cpu_arch_rev == 2);
    

    e_assign->adds(
      [["E_fwd_reg_data", $datapath_sz], "E_alu_result"],
    );




    e_mux->add ({
      lhs => ["D_src1_reg", $datapath_sz],
      type => "priority",
      table => [
        "D_src1_choose_E"   => "E_fwd_reg_data",
        "D_src1_choose_M"   => "M_fwd_reg_data",
        "D_src1_choose_A"   => "A_fwd_reg_data",
        "1'b1"              => "D_rf_a",
        ],
      });

    e_assign->adds(
      [["D_src1", $datapath_sz], $cdx_present ? "D_ctrl_src1_force_zero ? 32'd0 : D_src1_reg" : "D_src1_reg"],
      );







    e_mux->add ({
      lhs => ["D_src2_reg", $datapath_sz],
      type => "priority",
      table => [
        "D_src2_choose_E"   => "E_fwd_reg_data",
        "D_src2_choose_M"   => "M_fwd_reg_data",
        "D_src2_choose_A"   => "A_fwd_reg_data",
        "1'b1"              => "D_rf_b",
        ],
      });



    e_assign->adds(
      [["D_src2_imm16_sel", 2], "{D_ctrl_hi_imm16,D_ctrl_unsigned_lo_imm16}"],
      );


    my $imm16_sex_datapath_sz = $datapath_sz - 16;    

    e_mux->add ({
      lhs => ["D_src2_imm16", $datapath_sz],
      selecto => "D_src2_imm16_sel",
      table => [
        "2'b00" => "{{$imm16_sex_datapath_sz {D_iw_imm16[15]}}         , D_iw_imm16                    }",
        "2'b01" => "{{$imm16_sex_datapath_sz {D_ctrl_set_src2_rem_imm}}, D_iw_imm16                    }",
        "2'b10" => "{D_iw_imm16                                        , {16 {D_ctrl_set_src2_rem_imm}}}",
        "2'b11" => "{{$imm16_sex_datapath_sz {1'b0}}                   , 16'b0                         }",
        ],
      });
    

    if ($r2) {


        e_assign->adds(
          [["D_src2_imm12_5_sel", 2], "{D_ctrl_signed_imm12,D_ctrl_src_imm5_shift_rot}"],
          );
        

        my $imm12_sex_datapath_sz = $datapath_sz - 12;
        my $imm5_datapath_sz = $datapath_sz - 5;
        
        e_mux->add ({
          lhs => ["D_src2_imm_32b_inst", $datapath_sz],
          selecto => "D_src2_imm12_5_sel",
          table => [
            "2'b01" => "{{$imm5_datapath_sz {1'b0}}, D_iw_imm5}",
            "2'b10" => "{{$imm12_sex_datapath_sz {D_iw_imm12[11]}}, D_iw_imm12}",
            "2'b11" => "D_src2_imm16",
            ],
          });
    } else {
        e_assign->adds(
          [["D_src2_imm5_sel", 1], "D_ctrl_src_imm5_shift_rot"],
          );
        
        my $imm5_datapath_sz = $datapath_sz - 5;
        
        e_mux->add ({
          lhs => ["D_src2_imm_32b_inst", $datapath_sz],
          selecto => "D_src2_imm5_sel",
          table => [
            "1'b1" => "{{$imm5_datapath_sz {1'b0}}, D_iw_imm5}",
            "1'b0" => "D_src2_imm16",
            ],
          });
    }

    if ($cdx_present) {
        my $imm_cdx_inst_selection = [];

        my $t2x1i3_imm3_dec_table = [];
        for (my $var = 0; $var < 8 ; $var++) {
            my $powerof2 = 2**$var;
            push(@$t2x1i3_imm3_dec_table, "${var}" => "${powerof2}", );
        }
        e_mux->add({
          lhs   => ["D_iw_t2x1i3_imm3_dec", 8],
          selecto => "D_iw_t2x1i3_imm3",
          table => $t2x1i3_imm3_dec_table,
        }),
        push(@$imm_cdx_inst_selection, "D_is_asi_n_inst"         => "{{24{1'b0}}, D_iw_t2x1i3_imm3_dec}",);


        my $t2i4_imm4_dec_table = [];
        push(@$t2i4_imm4_dec_table, "0" => "1", );
        push(@$t2i4_imm4_dec_table, "1" => "2", );
        push(@$t2i4_imm4_dec_table, "2" => "3", );
        push(@$t2i4_imm4_dec_table, "3" => "4", );
        push(@$t2i4_imm4_dec_table, "4" => "8", );
        push(@$t2i4_imm4_dec_table, "5" => "16'hf", );
        push(@$t2i4_imm4_dec_table, "6" => "16'h10", );
        push(@$t2i4_imm4_dec_table, "7" => "16'h1f", );
        push(@$t2i4_imm4_dec_table, "8" => "16'h20", );
        push(@$t2i4_imm4_dec_table, "9" => "16'h3f", );
        push(@$t2i4_imm4_dec_table, "10" => "16'h7f", );
        push(@$t2i4_imm4_dec_table, "11" => "16'h80", );
        push(@$t2i4_imm4_dec_table, "12" => "16'hff", );
        push(@$t2i4_imm4_dec_table, "13" => "16'h7ff", );
        push(@$t2i4_imm4_dec_table, "14" => "16'hff00", );
        push(@$t2i4_imm4_dec_table, "15" => "16'hffff", );

        e_mux->add({
          lhs   => ["D_iw_t2i4_imm4_dec", 16],
          selecto => "D_iw_t2i4_imm4",
          table => $t2i4_imm4_dec_table,
        }),
        push(@$imm_cdx_inst_selection, "D_op_andi_n"         => "{{16{1'b0}}, D_iw_t2i4_imm4_dec}",);


        my $t1i7_imm7_dec_table = [];
        push(@$t1i7_imm7_dec_table, "125" => "32'hff", );
        push(@$t1i7_imm7_dec_table, "126" => "32'hfffffffe", );
        push(@$t1i7_imm7_dec_table, "127" => "32'hffffffff", );
        push(@$t1i7_imm7_dec_table, "0" => "{{25{1'b0}},D_iw_t1i7_imm7}", );

        e_mux->add({
          lhs   => ["D_iw_t1i7_imm7_dec", 32],
          selecto => "D_iw_t1i7_imm7",
          table => $t1i7_imm7_dec_table,
        }),
        push(@$imm_cdx_inst_selection, "D_op_movi_n"         => "D_iw_t1i7_imm7_dec",);


        push(@$imm_cdx_inst_selection, "D_op_mov_n|D_op_beqz_n|D_op_bnez_n"          => "0",);
        

        push(@$imm_cdx_inst_selection, "D_op_not_n"          => "32'hffffffff",);


        my $t2x1l3_shamt_dec_table = [];
        push(@$t2x1l3_shamt_dec_table, "0" => "1", );
        push(@$t2x1l3_shamt_dec_table, "1" => "2", );
        push(@$t2x1l3_shamt_dec_table, "2" => "3", );
        push(@$t2x1l3_shamt_dec_table, "3" => "8", );
        push(@$t2x1l3_shamt_dec_table, "4" => "12", );
        push(@$t2x1l3_shamt_dec_table, "5" => "16", );
        push(@$t2x1l3_shamt_dec_table, "6" => "24", );
        push(@$t2x1l3_shamt_dec_table, "7" => "31", );

        e_mux->add({
          lhs   => ["D_iw_t2x1l3_shamt_dec", 5],
          selecto => "D_iw_t2x1l3_shamt",
          table => $t2x1l3_shamt_dec_table,
        }),
        push(@$imm_cdx_inst_selection, "D_is_shi_n_inst"         => "{{27{1'b0}}, D_iw_t2x1l3_shamt_dec}",);


        push(@$imm_cdx_inst_selection, "D_op_ldbu_n|D_op_stb_n"    => "{{28{1'b0}}, D_iw_t2i4_imm4}",);

        push(@$imm_cdx_inst_selection, "D_op_ldhu_n|D_op_sth_n"    => "{{27{1'b0}}, D_iw_t2i4_imm4, 1'b0}",);

        push(@$imm_cdx_inst_selection, "D_op_ldw_n|D_op_stw_n"     => "{{26{1'b0}}, D_iw_t2i4_imm4, 2'b00}",);


        push(@$imm_cdx_inst_selection, "D_op_ldwsp_n|D_op_stwsp_n"     => "{{25{1'b0}}, D_iw_f1i5_imm5, 2'b00}",);


        push(@$imm_cdx_inst_selection, "D_op_spaddi_n"     => "{{23{1'b0}}, D_iw_t1i7_imm7, 2'b00}",);
        

        push(@$imm_cdx_inst_selection, "D_is_spi_n_inst"     => "{{23{1'b0}}, D_iw_x1i7_imm7, 2'b00}",);


        push(@$imm_cdx_inst_selection, "D_op_stbz_n"     => "{{26{1'b0}}, D_iw_t1x1i6_imm6}",);

        push(@$imm_cdx_inst_selection, "D_op_stwz_n"     => "{{24{1'b0}}, D_iw_t1x1i6_imm6, 2'b00}",);        

        e_mux->add ({
          lhs => ["D_src2_imm_cdx_inst", $datapath_sz],
          type => "and_or",
          table => $imm_cdx_inst_selection,
          default => "{{24{D_multiple_imm[5]}}, D_multiple_imm, 2'b00}",
          });
    }


    if ($cdx_present) {
        e_assign->adds(
          [["D_src2_imm_sel", 2], "{D_ctrl_src2_choose_imm,D_ctrl_src2_choose_cdx_imm}"],
          );
        
        e_mux->add ({
          lhs => ["D_src2", $datapath_sz],
          selecto => "D_src2_imm_sel",
          table => [
            "2'b01" => "D_src2_imm_cdx_inst",
            "2'b10" => "D_src2_imm_32b_inst",
            "2'b00" => "D_src2_reg",
            ],
          });
    } else {
    e_assign->adds(
      [["D_src2", $datapath_sz],
        "D_ctrl_src2_choose_imm ? D_src2_imm_32b_inst : D_src2_reg"],
      );
    }


    e_register->adds(
      {out => ["E_src1", $datapath_sz],     in => "D_src1", 
       enable => "E_en"},
      {out => ["E_src2", $datapath_sz],     in => "D_src2", 
       enable => "E_en"},
      {out => ["E_src2_reg", $datapath_sz], in => "D_src2_reg", 
       enable => "E_en"},
    );





    e_register->adds(
      {out => ["M_src1", $datapath_sz, 0, $force_never_export],
       in => "E_src1", enable => "M_en"},
      {out => ["M_src2", $datapath_sz, 0, $force_never_export], 
       in => "E_src2", enable => "M_en"},
    );



    e_register->adds(
      {out => ["A_src2", $datapath_sz, 0, $force_never_export],
       in => "M_src2", enable => "A_en"},
    );

    my @src_operands = (
        { divider => "src_operands" },
        { radix => "x", signal => "D_src1_choose_E" },
        { radix => "x", signal => "D_src1_choose_M" },
        { radix => "x", signal => "D_src1_choose_A" },
        { radix => "x", signal => "D_src2_choose_E" },
        { radix => "x", signal => "D_src2_choose_M" },
        { radix => "x", signal => "D_src2_choose_A" },
        { radix => "x", signal => "D_src1_reg" },
        { radix => "x", signal => "D_src1" },
        { radix => "x", signal => "D_src2_imm" },
        { radix => "x", signal => "D_src2_reg" },
        { radix => "x", signal => "D_src2" },
        { radix => "x", signal => "E_src1" },
        { radix => "x", signal => "E_src2" },
        { radix => "x", signal => "M_src1" },
        { radix => "x", signal => "M_src2" },
        { radix => "x", signal => "A_src2" },
      );

    push(@plaintext_wave_signals, @src_operands);
}




sub 
make_cdx_multiple
{
    my $Opt = shift;

    if ($cdx_present) {    
    my @multiple_shift_reg_mask_inc_mux_table;
    for (my $mask = 0 ; $mask <12 ; $mask ++) {
        my $poweroftwo = 2**$mask;
        push(@multiple_shift_reg_mask_inc_mux_table, "D_multiple_regmask[${mask}] & ~D_multiple_shift_reg[${mask}]" => "${poweroftwo}");
    }
    push(@multiple_shift_reg_mask_inc_mux_table, "1'b1" => "0");

    my @multiple_shift_reg_mask_dec_mux_table;
    for (my $mask = 11 ; $mask >= 0 ; $mask --) {
        my $poweroftwo = 2**$mask;
        push(@multiple_shift_reg_mask_dec_mux_table, "D_multiple_regmask[${mask}] & ~D_multiple_shift_reg[${mask}]" => "${poweroftwo}");
    }
    push(@multiple_shift_reg_mask_dec_mux_table, "1'b1" => "0");


    e_mux->add ({
      lhs => ["D_multiple_shift_reg_mask_inc", 12],
      type => "priority",
      table => \@multiple_shift_reg_mask_inc_mux_table,
      });

    e_mux->add ({
      lhs => ["D_multiple_shift_reg_mask_dec", 12],
      type => "priority",
      table => \@multiple_shift_reg_mask_dec_mux_table,
      });
 
    my @multiple_dst_inc_rs0_mux_table;
    for (my $var = 0 ; $var < 12 ; $var ++) {
        my $reg = $var + 2;
        push(@multiple_dst_inc_rs0_mux_table, "D_multiple_regmask[${var}] & ~D_multiple_shift_reg[${var}]" => "5'd${reg}");
    }
    push(@multiple_dst_inc_rs0_mux_table, "1'b1" => "5'd0");

    my @multiple_dst_inc_rs1_mux_table;
    for (my $var = 0 ; $var < 10 ; $var ++) {
        my $reg = $var + 14;
        push(@multiple_dst_inc_rs1_mux_table, "D_multiple_regmask[${var}] & ~D_multiple_shift_reg[${var}]" => "5'd${reg}");
    }
    push(@multiple_dst_inc_rs1_mux_table, "D_multiple_regmask[10] & ~D_multiple_shift_reg[10]" => "5'd28");
    push(@multiple_dst_inc_rs1_mux_table, "D_multiple_regmask[11] & ~D_multiple_shift_reg[11]" => "5'd31");
    push(@multiple_dst_inc_rs1_mux_table, "1'b1" => "5'd0");

    my @multiple_dst_dec_rs0_mux_table;
    for (my $var = 11 ; $var >= 0 ; $var --) {
        my $reg = $var + 2;
        push(@multiple_dst_dec_rs0_mux_table, "D_multiple_regmask[${var}] & ~D_multiple_shift_reg[${var}]" => "5'd${reg}");
    }
    push(@multiple_dst_dec_rs0_mux_table, "1'b1" => "5'd0");

    my @multiple_dst_dec_rs1_mux_table;
    push(@multiple_dst_dec_rs1_mux_table, "D_multiple_regmask[11] & ~D_multiple_shift_reg[11]" => "5'd31");
    push(@multiple_dst_dec_rs1_mux_table, "D_multiple_regmask[10] & ~D_multiple_shift_reg[10]" => "5'd28");

    for (my $var = 9 ; $var >= 0 ; $var --) {
        my $reg = $var + 14;
        push(@multiple_dst_dec_rs1_mux_table, "D_multiple_regmask[${var}] & ~D_multiple_shift_reg[${var}]" => "5'd${reg}");
    }   
    push(@multiple_dst_dec_rs1_mux_table, "1'b1" => "5'd0");


    e_mux->add ({
      lhs => ["D_multiple_dst_inc_rs0", 5],
      type => "priority",
      table => \@multiple_dst_inc_rs0_mux_table,
      });

    e_mux->add ({
      lhs => ["D_multiple_dst_inc_rs1", 5],
      type => "priority",
      table => \@multiple_dst_inc_rs1_mux_table,
      });

    e_mux->add ({
      lhs => ["D_multiple_dst_dec_rs0", 5],
      type => "priority",
      table => \@multiple_dst_dec_rs0_mux_table,
      });

    e_mux->add ({
      lhs => ["D_multiple_dst_dec_rs1", 5],
      type => "priority",
      table => \@multiple_dst_dec_rs1_mux_table,
      });
   
    e_mux->add ({
      lhs => ["D_iw_l5i4x1_regrange_dec", 8],
      selecto => "D_iw_l5i4x1_regrange",
      table => [
        "3'b000" => "8'h01",
        "3'b001" => "8'h03",
        "3'b010" => "8'h07",
        "3'b011" => "8'h0f",
        "3'b100" => "8'h1f",
        "3'b101" => "8'h3f",
        "3'b110" => "8'h7f",
        "3'b111" => "8'hff",
        ],
      });
    }
   
    if ($cdx_present) {
        e_assign->adds(

        	[["D_multiple_wb_or_jmp", 1], "~(D_multiple_reglist_done & ~(D_multiple_wb_reg|D_multiple_jmp_reg))"],

            [["D_multiple_is_increment", 1], "(D_is_i12_inst & D_iw_f1x4l17_id) | D_op_pop_n"],
            [["D_multiple_regmask", 12], "D_is_pp_n_inst ? {1'b1,D_iw_l5i4x1_fp,D_iw_pp_regrange_cs,2'b00} : D_iw_f1x4l17_regmask"],
            [["D_multiple_dst_needs_wb", 1], "D_multiple_wb_reg & D_multiple_reglist_done"],
            [["D_multiple_jmp_indirect", 1], "D_multiple_jmp_reg & D_multiple_reglist_done"],

            [["D_multiple_shift_reg_stall", 1], "((D_ctrl_multiple_loads|D_ctrl_multiple_stores) & D_issue & ~D_iw_32b_misaligned_stall) & ~(D_multiple_reglist_done|M_pipe_flush|E_br_mispredict|D_imaster_kill)"],
            [["D_multiple_reglist_done", 1], "(D_multiple_shift_reg == D_multiple_regmask) & D_multiple_shift_reg_stall_d1"],
            
            [["D_multiple_counter_inc", 6], "D_multiple_counter + 1"],
            [["D_multiple_counter_dec", 6], "D_multiple_counter - 1"],
             

            [["D_iw_pp_regrange_cs", 8], "D_iw_l5i4x1_regrange_dec & {8{D_iw_l5i4x1_cs}}"],
            [["D_multiple_regsource", 1], "D_iw_f1x4l17_rs|D_is_pp_n_inst"],

            [["D_multiple_imm_offset_zex", 6], "{6{D_is_pp_n_inst}} & {2'b00,D_iw_l5i4x1_imm4}"],
            
            [["D_multiple_ld", 1], "D_ctrl_multiple_loads & ~(D_multiple_dst_needs_wb | D_multiple_jmp_indirect)"],
            [["D_multiple_st", 1], "D_ctrl_multiple_stores & ~(D_multiple_dst_needs_wb | D_multiple_jmp_indirect)"],
        );


        e_assign->adds(
            [["D_multiple_stall_inc_sel", 2], "{D_multiple_shift_reg_stall,D_multiple_is_increment}"],

            [["D_multiple_dst_wb_sel", 2], "{D_multiple_dst_needs_wb,D_is_pp_n_inst}"],
            [["D_multiple_dst_sel", 2], "{D_multiple_is_increment,D_multiple_regsource}"],
            
            [["D_multiple_imm_sel", 2], "{(D_multiple_is_increment |D_multiple_dst_needs_wb),D_op_push_n}"],
        );

       e_mux->add ({
          lhs => ["D_multiple_dst", 5],
          selecto => "D_multiple_dst_wb_sel",
          table => [
            "2'b11" => "5'd27",
            "2'b10" => "D_iw_a",
            "2'b00" => "D_multiple_dst_shift",
            ],
          });
       
       e_mux->add ({
          lhs => ["D_multiple_dst_shift", 5],
          selecto => "D_multiple_dst_sel",
          table => [
            "2'b00" => "D_multiple_dst_dec_rs0",
            "2'b01" => "D_multiple_dst_dec_rs1",
            "2'b10" => "D_multiple_dst_inc_rs0",
            "2'b11" => "D_multiple_dst_inc_rs1",
            ],
          });

       e_mux->add ({
          lhs => ["D_multiple_counter_nxt", 6],
          selecto => "D_multiple_stall_inc_sel",
          table => [
            "2'b11" => "D_multiple_counter_inc",
            "2'b10" => "D_multiple_counter_dec",
            "2'b00" => "6'd0",
            ],
          });

       e_mux->add ({
          lhs => ["D_multiple_imm", 6],
          selecto => "D_multiple_imm_sel",
          table => [
            "2'b11" => "D_multiple_counter - D_multiple_imm_offset_zex",
            "2'b10" => "D_multiple_counter + D_multiple_imm_offset_zex",
            "2'b00" => "D_multiple_counter - 1",
            ],
          });

       e_mux->add ({
          lhs => ["D_multiple_shift_reg_nxt", 12],
          selecto => "D_multiple_stall_inc_sel",
          table => [
            "2'b11" => "D_multiple_shift_reg|D_multiple_shift_reg_mask_inc",
            "2'b10" => "D_multiple_shift_reg|D_multiple_shift_reg_mask_dec",
            "2'b00" => "12'd0",
            ],
          });

       e_register->adds(
       	{out => ["D_multiple_shift_reg_stall_d1", 1], in => "D_multiple_shift_reg_stall", 
         enable => "D_en"},

       	{out => ["D_multiple_wb_reg", 1], in => "(D_iw_f1x4l17_wb|D_is_pp_n_inst)", 
         enable => "1'b1"},
        {out => ["D_multiple_jmp_reg", 1], in => "((D_is_i12_inst & D_iw_f1x4l17_pc)|D_op_pop_n)", 
         enable => "1'b1"},

        {out => ["E_multiple_jmp_indirect", 1], in => "D_multiple_jmp_indirect", 
         enable => "E_en"},
       );
    } else {
        e_assign->adds(
            [["D_multiple_is_increment", 1], "1'b0"],
            [["D_multiple_jmp_indirect", 1], "1'b0"],
            [["D_multiple_wb_or_jmp", 1], "1'b1"],

            [["D_multiple_shift_reg_mask", 12], "0"],         
            [["D_multiple_shift_reg_nxt", 12], "D_multiple_shift_reg_stall ? (D_multiple_shift_reg | D_multiple_shift_reg_mask) : 0"],
            [["D_multiple_shift_reg_stall", 1], "1'b0"],
            
            [["D_multiple_counter_inc", 6], "D_multiple_counter + 1"],
            [["D_multiple_counter_dec", 6], "D_multiple_counter - 1"],
            [["D_multiple_counter_result", 6], "D_multiple_is_increment ? D_multiple_counter_inc : D_multiple_counter_dec"],
            
            [["D_multiple_counter_nxt", 6], "D_multiple_shift_reg_stall ? D_multiple_counter_result : 5'h0"],
             
            [["D_multiple_ld", 1], "1'b0"],
            [["D_multiple_st", 1], "1'b0"],
        );
    }
    
    e_register->adds(
      {out => ["D_multiple_shift_reg", 12], in => "D_multiple_shift_reg_nxt", 
       enable => "D_en"},
      {out => ["D_multiple_counter", 6], in => "D_multiple_counter_nxt", 
       enable => "D_en"},


      {out => ["E_multiple_ld", 1], in => "D_multiple_ld", 
       enable => "E_en"},
      {out => ["M_multiple_ld", 1], in => "E_multiple_ld", 
       enable => "M_en"},
      {out => ["A_multiple_ld", 1], in => "M_multiple_ld", 
       enable => "A_en"},
      {out => ["E_multiple_st", 1], in => "D_multiple_st", 
       enable => "E_en"},
      {out => ["M_multiple_st", 1], in => "E_multiple_st", 
       enable => "M_en"},
      {out => ["A_multiple_st", 1], in => "M_multiple_st", 
       enable => "A_en"},
    );
    
}



sub 
make_alu_controls
{
    my $Opt = shift;






    e_assign->adds(
      [["D_logic_op_raw_op_iw", $logic_op_sz],
         $cdx_present ? "D_is_r_n_inst ? D_iw_r_n_x[1:0] : D_iw_op[$logic_op_msb:$logic_op_lsb]" :
          "D_iw_op[$logic_op_msb:$logic_op_lsb]"],

      [["D_logic_op_raw", $logic_op_sz],
        "(D_is_opx_inst ? D_iw_opx[$logic_op_msb:$logic_op_lsb] :" .
          "D_logic_op_raw_op_iw)"],

      [["D_logic_op", $logic_op_sz],
        "D_ctrl_alu_force_xor ? $logic_op_xor : 
         D_ctrl_alu_force_and ? $logic_op_and :
         D_logic_op_raw"],

      [["D_compare_op", $compare_op_sz],
        "(D_is_opx_inst ? D_iw_opx[$compare_op_msb:$compare_op_lsb] : 
          D_iw_op[$compare_op_msb:$compare_op_lsb])"],
      );


    e_register->adds(
      {out => ["E_logic_op", $logic_op_sz], in => "D_logic_op", 
       enable => "E_en"},
      {out => ["E_compare_op", $compare_op_sz], in => "D_compare_op", 
       enable => "E_en"},
    );
}




sub 
make_internal_interrupt_controller
{
    my $Opt = shift;
    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");
    my $r2 = ($cpu_arch_rev == 2);






    e_assign->adds(
      [["norm_intr_req", 1], $r2 ? "(W_ipending_reg != 0)" : "W_status_reg_pie & (W_ipending_reg != 0)"],
    );
    



    e_register->adds(
      {out => ["E_norm_intr_req", 1], 
       in => "norm_intr_req", enable => "E_en" },
    );
}

sub
make_external_interrupt_controller
{
    my $Opt = shift;



    my $eic_port_name = "interrupt_controller_in";
    my $eic_signal_prefix = "eic_port_";
    my @eic_port_signals = (["data" => $eic_port_sz],
                            ["valid" => 1]);
    
    e_signal->adds(map {[$eic_signal_prefix . $_->[0] => $_->[1]]} 
                       @eic_port_signals);
    
    my $eic_port_type_map = { map {$eic_signal_prefix . $_->[0] => $_->[0]}
                                  @eic_port_signals };
    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");

    my $r2 = ($cpu_arch_rev == 2);

    e_atlantic_slave->add({
        name => $eic_port_name,
        type_map => $eic_port_type_map,
    });


    e_assign->adds(
      [["eic_port_data_ril", $eic_port_ril_sz], 
       "eic_port_data[$eic_port_ril_msb:$eic_port_ril_lsb]"],
      [["eic_port_data_rnmi", 1], 
       "eic_port_data[$eic_port_rnmi_lsb]"],
      [["eic_port_data_rha", $eic_port_rha_sz], 
       "eic_port_data[$eic_port_rha_msb:$eic_port_rha_lsb]"],
      [["eic_port_data_rrs", $eic_port_rrs_sz, 0, $force_never_export], 
       "eic_port_data[$eic_port_rrs_msb:$eic_port_rrs_lsb]"],
    );



    e_register->adds(
      {out => ["eic_ril", $status_reg_il_sz], 
       in => "eic_port_data_ril",
       enable => "eic_port_valid"},
      {out => ["eic_rnmi", 1], 
       in => "eic_port_data_rnmi",
       enable => "eic_port_valid"},
      {out => ["eic_rha", $pcb_sz], 
       in => "eic_port_data_rha",
       enable => "eic_port_valid"},
    );

    if ($shadow_present) {
        e_register->adds(
          {out => ["eic_rrs", $rf_set_sz], 
           in => "eic_port_data_rrs",
           enable => "eic_port_valid"},
        );
    }

    my $oci_version = manditory_int($Opt, "oci_version");

    e_assign->adds(
      [["nmi_req", 1], 
        "eic_rnmi & (eic_ril != 0) & ~W_status_reg_nmi"],
      [["mi_req", 1], 
        $r2 ? "~eic_rnmi & (eic_ril > W_status_reg_il) & E_status_reg_pie_latest" .
        ($shadow_present ?
          " & ((eic_rrs != W_status_reg_crs) | E_status_reg_rsie_latest)" :
          "")
            : "~eic_rnmi & (eic_ril > W_status_reg_il) & W_status_reg_pie" .
        ($shadow_present ?
          " & ((eic_rrs != W_status_reg_crs) | W_status_reg_rsie)" :
          "")],




      [["ext_intr_req", 1], $oci_version == 2 ? "(nmi_req | mi_req) & ~oci_idisable" : "(nmi_req | mi_req) & oci_ienable[0]"],
    );



    e_register->adds(
      {out => ["E_ext_intr_req", 1], 
       in => "ext_intr_req", 
       enable => "E_en" },

      {out => ["E_eic_ril", $status_reg_il_sz], 
       in => "eic_ril", 
       enable => "E_en" },
      {out => ["E_eic_rnmi", 1], 
       in => "eic_rnmi", 
       enable => "E_en" },
      {out => ["E_eic_rha", $pcb_sz], 
       in => "eic_rha", 
       enable => "E_en" },

      {out => ["M_eic_ril", $status_reg_il_sz], 
       in => "E_eic_ril", 
       enable => "M_en" },
      {out => ["M_eic_rnmi", 1], 
       in => "E_eic_rnmi", 
       enable => "M_en" },
      {out => ["M_eic_rha", $pcb_sz], 
       in => "E_eic_rha", 
       enable => "M_en" },

      {out => ["A_eic_ril", $status_reg_il_sz], 
       in => "M_eic_ril", 
       enable => "A_en" },
      {out => ["A_eic_rnmi", 1], 
       in => "M_eic_rnmi", 
       enable => "A_en" },
      {out => ["A_eic_rha", $pcb_sz, 0, $force_never_export], 
       in => "M_eic_rha", 
       enable => "A_en" },
    );

    e_assign->adds(
      [["A_oci_eic_rha", $pcb_sz, 0, $force_never_export], 
       "A_eic_rha"],
    );

    if ($shadow_present) {
        e_register->adds(
          {out => ["M_eic_rrs", $rf_set_sz], 
           in => "eic_rrs", 
           enable => "M_en" },
          {out => ["A_eic_rrs", $rf_set_sz], 
           in => "M_eic_rrs", 
           enable => "A_en" },
          {out => ["A_eic_rrs_non_zero", 1], 
           in => "M_eic_rrs != 0", 
           enable => "A_en" },
        );
    }

    my @mem_load_store_wave_signals = (
        { divider => "EIC Port" },
        { radix => "x", signal => "eic_port_valid" },
        { radix => "x", signal => "eic_port_data_ril" },
        { radix => "x", signal => "eic_port_data_rnmi" },
        { radix => "x", signal => "eic_port_data_rha" },
        { radix => "x", signal => "eic_port_data_rrs" },
        { radix => "x", signal => "eic_ril" },
        { radix => "x", signal => "eic_rnmi" },
        { radix => "x", signal => "eic_rha" },
        $shadow_present ? { radix => "x", signal => "eic_rrs" } : "",
        { radix => "x", signal => "nmi_req" },
        { radix => "x", signal => "mi_req" },
        { radix => "x", signal => "ext_intr_req" },
    );

    push(@plaintext_wave_signals, @mem_load_store_wave_signals);
}




sub 
make_dmpu
{
    my $Opt = shift;

    e_assign->adds(
      [["D_mem_baddr_for_dmpu", $datapath_sz], 
        "D_mem_baddr"],
    );


    e_mux->add ({
      lhs => ["E_dmpu_good_perm", 1],
      selecto => "E_dmpu_perm",
      table => [
        $mpu_data_perm_super_none_user_none => 
          "0",
        $mpu_data_perm_super_rd_user_none   => 
          "~W_status_reg_u & E_ctrl_ld",
        $mpu_data_perm_super_rd_user_rd     => 
          "E_ctrl_ld",
        $mpu_data_perm_super_rw_user_none   => 
          "~W_status_reg_u",
        $mpu_data_perm_super_rw_user_rd     =>
          "~W_status_reg_u | (W_status_reg_u & E_ctrl_ld)",
        $mpu_data_perm_super_rw_user_rw     =>
          "1",
        ],
      default => "0",
    });






    my @dmpu_exc_conds = ("~E_dmpu_hit", "~E_dmpu_good_perm");

    my $unused_mem_baddr_msb = 31;
    my $unused_mem_baddr_lsb = manditory_int($Opt, "d_Address_Width");
    my $unused_mem_baddr_sz = $unused_mem_baddr_msb - $unused_mem_baddr_lsb + 1;

    if ($unused_mem_baddr_sz > 0) {
        push(@dmpu_exc_conds, 
          "(E_mem_baddr[$unused_mem_baddr_msb:$unused_mem_baddr_lsb] != 0)");
    }

    new_exc_signal({
        exc             => $mpu_data_region_violation_exc,
        initial_stage   => "E", 
        speedup_stage   => "E",
        rhs             => 
          "W_config_reg_pe & ~W_debug_mode & !E_mem_baddr_corrupt & " .
          "(E_ctrl_mem_data_access|E_multiple_ld|E_multiple_st) & (" . join('|', @dmpu_exc_conds) . ")",
    });


    my $dmpu_region_wave_signals = nios2_mpu::make_mpu_regions($Opt, 1);

    push(@plaintext_wave_signals, 
      @$dmpu_region_wave_signals,
      { divider => "DMPU Exceptions" },
      get_exc_signal_wave($mpu_data_region_violation_exc, "E"),
    );
}




sub 
make_potential_tb_logic
{
    my $Opt = shift;

    e_assign->adds(
      [["E_src1_eq_src2", 1], "E_logic_result == 0"],
    );
}




sub 
be_make_hbreak_400
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
            );
            
            if ($oci_present) {
                e_assign->adds(
                  [["oci_sync_hbreak_req",1], "E_oci_sync_hbreak_req"],
                );    
            }
        } else {   #advanced exception
            e_assign->adds(
              [["oci_tb_hbreak_req", 1, 0, 1],"oci_async_hbreak_req"],
            );
        }
    





        e_assign->adds(
          [["hbreak_req", 1], 
             "(oci_tb_hbreak_req | latched_oci_tb_hbreak_req) 
               & hbreak_enabled
               & (~wait_for_one_post_bret_inst | ~M_one_post_bret_inst_n)"],
        );








        if ($hbreak_test_bench) { 
          e_assign->adds(

            [["E_hbreak_req", 1], "hbreak_req"],
          );
        } else {
          e_assign->adds(



            [["E_hbreak_req", 1], "(hbreak_req | (E_oci_sync_hbreak_req & hbreak_enabled))"],
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




















        
        if ($cdx_present) {


        	e_register->adds(


              { out => ["D_multiple_reglist_done_d1", 1, 0, 1], 
                in => "D_multiple_reglist_done",
                enable => "D_en" 
              },
              { out => ["E_multiple_inst_done", 1, 0, 1], 
                in => "(D_multiple_reglist_done & ~(D_multiple_wb_reg|D_multiple_jmp_reg)) | D_multiple_reglist_done_d1",
                enable => "E_en" 
              },

              { out => ["M_multiple_inst_done", 1, 0, 1], 
                in => "E_multiple_inst_done",
                enable => "M_en" 
              },
            );
        }
        e_assign->add(
          [["M_one_post_bret_inst_n", 1, 0, 1],
             $cdx_present ? "oci_single_step_mode & (~hbreak_enabled | ~((M_valid_ignore_exc & ~(M_ctrl_multiple_loads|M_ctrl_multiple_stores)) | M_multiple_inst_done))" :
             "(oci_single_step_mode & (~hbreak_enabled | ~(M_valid_ignore_exc)))"],
        );
        e_register->adds(
          { out => ["wait_for_one_post_bret_inst", 1, 0, 1], 
            in => "(~hbreak_enabled & oci_single_step_mode) ? 1'b1 
                    : ((~M_one_post_bret_inst_n) | 
                       (~oci_single_step_mode))             ? 1'b0 
                    : wait_for_one_post_bret_inst",
            enable => "1'b1", 
            async_value => "1'b0"
          },
        );
    } else {


      e_assign->adds(
        [["hbreak_enabled", 1, 0, $force_never_export],             "1'b0"],
        [["hbreak_req", 1, 0, $force_never_export],                 "1'b0"],
        [["latched_oci_tb_hbreak_req", 1, 0, $force_never_export],  "1'b0"],
        [["E_hbreak_req", 1, 0, $force_never_export],               "1'b0"],
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

1;
