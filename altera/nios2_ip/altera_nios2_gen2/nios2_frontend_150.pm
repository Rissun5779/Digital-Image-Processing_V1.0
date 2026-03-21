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






















package nios2_frontend_150;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &nios2_fe150_make_frontend
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
use nios_icache;
use nios_flash_accelerator;
use nios2_isa;
use nios2_insts;
use nios2_mmu;
use nios2_mpu;
use nios2_exceptions;
use nios2_common;
use nios_common;
use nios2_control_regs;
use nios_ecc_encoder;
use nios_ecc_decoder;
use strict;


















sub 
nios2_fe150_make_frontend
{
    my $Opt = shift;

    &$progress("    Pipeline frontend");

    gen_pc($Opt);

    if ($icache_present) {
        nios_icache::gen_instruction_cache($Opt);
    }
    
    if ($fa_present) {
        nios_flash_accelerator::gen_flash_accelerator($Opt);
        gen_flash_accelerator_master($Opt);
    }

    gen_instruction_master($Opt);

    if ($itcm_present) {
        gen_instruction_tcm_masters($Opt);
    }

    gen_instruction_word_mux($Opt);

    if ($mmu_present) {
        &$progress("      Micro-ITLB");
        gen_tlb_inst($Opt);
    }

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


    e_signal->adds({name => "F_pcb_nxt", never_export => 1, width => $pcb_sz});
    e_signal->adds({name => "F_pcb", never_export => 1, width => $pcb_sz});

    e_assign->adds(["F_pcb_nxt", "{F_pc_nxt, 2'b00}"]);
    e_assign->adds(["F_pcb", "{F_pc, 2'b00}"]);


    e_register->adds(
      {out => ["F_pc", $pc_sz],                   in => "F_pc_nxt", 
       enable => "F_en"},
      );

    e_assign->adds(
      [["F_pc_plus_one", $pc_sz], "F_pc + 1"],
    );
}









sub 
gen_instruction_master
{
    my $Opt = shift;
    my $oci_version = manditory_int($Opt, "oci_version");

    $Opt->{instruction_master}{port_map} = {
      i_readdata      => "readdata",
      i_address       => "address",
      i_read          => "read",
      i_waitrequest   => "waitrequest",
    };

    if ($icache_present) {
        $Opt->{instruction_master}{port_map}{i_readdatavalid} = "readdatavalid";
    }

    if ($imaster_bursts) {
        $Opt->{instruction_master}{port_map}{i_burstcount} = "burstcount";
    }

    my $instruction_master_baddr_sz = $Opt->{instruction_master}{Address_Width};

    push(@{$Opt->{port_list}},

      [i_readdata       => $iw_sz,                          "in" ],
      [i_waitrequest    => 1,                               "in" ],
      [i_address        => $instruction_master_baddr_sz,    "out"],
      [i_read           => 1,                               "out"],
    );

    if ($icache_present) {
        push(@{$Opt->{port_list}},
          [i_readdatavalid  => 1,                           "in" ],
        );
    }

    if ($imaster_bursts) {
        push(@{$Opt->{port_list}},
          [i_burstcount     => $imaster_burstcount_sz,  "out"],
        );
    }


    if (manditory_bool($Opt, "hbreak_test")) {
        my $data_master_interrupt_sz = 
          manditory_int($Opt, "data_master_interrupt_sz");

        $Opt->{instruction_master}{port_map}{test_hbreak_req} = "irq";

        push(@{$Opt->{port_list}},

          [test_hbreak_req  => $data_master_interrupt_sz,  "in" ],
        );
    }

    e_register->adds(
      {out => ["i_read", 1],                        in => "i_read_nxt",
      enable => "1'b1"},
    );

    if ($icache_present) {
        e_register->adds(
          {out => ["i_readdata_d1", $iw_sz],        in => "i_readdata",
          enable => "1'b1"},
          {out => ["i_readdatavalid_d1", 1],        in => "i_readdatavalid",
          enable => "1'b1"},
        );
    } else {








        e_assign->adds(

          [["F_i_want_inst", 1], "F_sel_instruction_master & ~F_kill"],





          [["F_i_hit", 1], "i_readdata_d1_valid & (F_pcb == i_address)"],




          [["F_i_want_read", 1], "F_i_want_inst & ~F_i_hit"],










          [["F_i_read_starting", 1], ($oci_version == 2) ? "F_i_want_read & ~i_read & ~fetch_inst_cancel"  :
                                                           "F_i_want_read & ~i_read"],







          [["F_i_consumed", 1], "F_i_want_inst & F_i_hit & F_en"],


          [["i_readdata_arrived", 1], "i_read & ~i_waitrequest"],



          [["i_read_nxt", 1], "F_i_read_starting | (i_read & i_waitrequest)"],
        );

        e_register->adds(


          {out => ["i_address", $instruction_master_baddr_sz],              
           in => $instruction_master_baddr_sz > 1 ? "F_pcb[$instruction_master_baddr_sz-1:0]" : "1'b0",               enable => "F_i_read_starting"},









          {out => ["i_readdata_d1_valid", 1],              
           in => "F_i_read_starting   ? 1'b0 :
                  i_readdata_d1_valid ? ~F_i_consumed : 
                                        i_readdata_arrived", 
           enable => "1'b1"},


          {out => ["i_readdata_d1", $iw_sz],        in => "i_readdata",
          enable => "i_readdata_arrived"},
        );
   }

    my @instruction_master_waves = (
      { divider => "instruction_master" },
      { radix => "x", signal => "i_read" },
      { radix => "x", signal => "i_address" },
      { radix => "x", signal => "i_waitrequest" },
      { radix => "x", signal => "i_readdata_d1" },
      $imaster_bursts ? { radix => "x", signal => "i_burstcount" } : "",
      $icache_present ? { radix => "x", signal => "i_readdatavalid_d1" } : "",
    );

    if (!$icache_present) {
        push(@instruction_master_waves,
          { radix => "x", signal => "F_i_want_inst" },
          { radix => "x", signal => "F_i_hit" },
          { radix => "x", signal => "F_i_want_read" },
          { radix => "x", signal => "F_i_read_starting" },
          { radix => "x", signal => "F_i_consumed" },
          { radix => "x", signal => "i_readdata_d1_valid" },
        );      
    }

    push(@plaintext_wave_signals, @instruction_master_waves);
}








sub 
gen_flash_accelerator_master
{
    my $Opt = shift;

    $Opt->{flash_instruction_master}{port_map} = {
      fa_readdata      => "readdata",
      fa_address       => "address",
      fa_read          => "read",
      fa_waitrequest   => "waitrequest",
      fa_readdatavalid   => "readdatavalid",
      fa_burstcount   => "burstcount",
    };

    my $instruction_master_baddr_sz = $Opt->{flash_instruction_master}{Address_Width};
    my $imaster_burstcount_sz = $Opt->{fa_cache_line_size} == 8 ? 2 : 3;

    push(@{$Opt->{port_list}},

      [fa_readdata       => $iw_sz,                          "in" ],
      [fa_waitrequest    => 1,                               "in" ],
      [fa_address        => $instruction_master_baddr_sz,    "out"],
      [fa_read           => 1,                               "out"],
      [fa_readdatavalid  => 1,                           "in" ],
      [fa_burstcount     => $imaster_burstcount_sz,  "out"],
    );

    my @flash_accelerator_master_waves = (
      { divider => "flash_instruction_master" },
      { radix => "x", signal => "fa_read" },
      { radix => "x", signal => "fa_address" },
      { radix => "x", signal => "fa_waitrequest" },
      { radix => "x", signal => "fa_readdata" },
      { radix => "x", signal => "fa_burstcount" },
      { radix => "x", signal => "fa_readdatavalid" },
    );

    push(@plaintext_wave_signals, @flash_accelerator_master_waves);
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
















    my $F_pc_expr;
    my $M_pc_expr;


    if ($slave_addr_width < $avalon_addr_width) {


        my $top_bits = not_empty_scalar($Opt->{$master_name}, "Paddr_Base_Top_Bits");

        $F_pc_expr = $itcm_ecc_present ? "{ 2'b00, $top_bits, ${fetch_npc}[$slave_addr_width-3:0] }" : "{ $top_bits, ${fetch_npcb}[$slave_addr_width-1:0] }";
        $M_pc_expr = $itcm_ecc_present ? "{ 2'b00, $top_bits, M_pc[$slave_addr_width-3:0] }" : "{ $top_bits, M_pcb[$slave_addr_width-1:0] }";
    } else {
        $F_pc_expr = $itcm_ecc_present ? "{ 2'b00, ${fetch_npc}[$avalon_addr_width-3:0] }" : "${fetch_npcb}[$avalon_addr_width-1:0]";
        $M_pc_expr = $itcm_ecc_present ? "{ 2'b00, M_pc[$avalon_addr_width-3:0] }" : "M_pcb[$avalon_addr_width-1:0]";
    }


    my $ecc_recoverable = "";
    if ($itcm_ecc_present) {
            $ecc_recoverable = "M_itcm${cmi}_one_bit_err ? $M_pc_expr : ";
    }

    e_assign->adds(
      ["itcm${cmi}_address", $ecc_recoverable . $F_pc_expr],
    );


    e_assign->adds(
       ["itcm${cmi}_read", "1'b1"],
    );


    if ($itcm_ecc_present) {
        e_assign->adds(
          ["itcm${cmi}_clken", "F_en | M_itcm${cmi}_one_bit_err"],
        );   
    } else {
        e_assign->adds(
          ["itcm${cmi}_clken", "F_en"],
        );
    }

    my @ecc_write_port;
    if ($itcm_ecc_present) {
        e_assign->adds(
           ["itcm${cmi}_write", "M_itcm${cmi}_one_bit_err"],
           ["itcm${cmi}_writedata", "M_itcm${cmi}_writedata"],
        );
        push(@ecc_write_port,
          "itcm${cmi}_write"       => "write",
          "itcm${cmi}_writedata"   => "writedata",
        );
    }

    $Opt->{$master_name}{port_map} = {
      "itcm${cmi}_readdata"       => "readdata",
      "itcm${cmi}_address"        => "address",
      "itcm${cmi}_read"           => "read",
      "itcm${cmi}_clken"          => "clken",
      @ecc_write_port
    };

    $Opt->{$master_name}{sideband_signals} = [
      "clken",
    ];

    if ($itcm_ecc_present) {
        my $ecc_bits = calc_num_ecc_bits($datapath_sz);
        my $ecc_data_sz =  $datapath_sz + $ecc_bits;
        push(@{$Opt->{port_list}},
          ["itcm${cmi}_readdata"      => $ecc_data_sz,            "in" ],
          ["itcm${cmi}_write"         => 1,                       "out" ],
          ["itcm${cmi}_writedata"     => $ecc_data_sz,            "out" ],
        );       
    } else {
        push(@{$Opt->{port_list}},
          ["itcm${cmi}_readdata"      => $datapath_sz,            "in" ],
        );
    }
    
    push(@{$Opt->{port_list}},
      ["itcm${cmi}_address"       => $avalon_addr_width,      "out"],
      ["itcm${cmi}_read"          => 1,                       "out"],
      ["itcm${cmi}_clken"         => 1,                       "out"],
    );
}








sub 
gen_instruction_word_mux
{
    my $Opt = shift;
    my $oci_version = manditory_int($Opt,"oci_version");



    my $cmp_pcb_sz = $mmu_present ? 32 : manditory_int($Opt, "i_Address_Width");

    my $avalon_master_info = manditory_hash($Opt, "avalon_master_info");

    my $flash_list = "avalon_data_master_high_performance_list";
    if ($fa_present) {
        $flash_list = "avalon_flash_accelerator_master_list";
    }

    my @sel_signals = make_master_address_decoder({
      avalon_master_info    => $avalon_master_info,
      normal_master_name    => "instruction_master",
      tightly_coupled_master_names => manditory_array($avalon_master_info,
        "avalon_tightly_coupled_instruction_master_list"), 
      high_performance_master_names => manditory_array($avalon_master_info,
        "avalon_data_master_high_performance_list"),
      flash_accelerator_master_names => manditory_array($avalon_master_info,
        $flash_list),
      
      addr_signal           => "F_pcb[$cmp_pcb_sz-1:0]", 
      addr_sz               => $cmp_pcb_sz, 
      sel_prefix            => "F_sel_",
      mmu_present           => $mmu_present,
      fa_present            => $fa_present,
      master_paddr_mapper_func => \&nios2_mmu::master_paddr_mapper,
    });






    my @iw_mux_table;

    if ($oci_version == 2) {


        push(@iw_mux_table, "W_debug_mode" => "W_host_data_register");
    }

    if ($icache_present) {

        push(@iw_mux_table, "F_sel_instruction_master" => "F_ic_iw");
    } else {

        push(@iw_mux_table, "F_sel_instruction_master" => "i_readdata_d1");
    }

    if ($fa_present) {

        push(@iw_mux_table, "F_sel_flash_instruction_master" => "F_fa_iw");       
    }

    if ($itcm_ecc_present) {
        my $ecc_bits = calc_num_ecc_bits($datapath_sz);
        my $ecc_data_sz =  $datapath_sz + $ecc_bits;
        my @tcim_ecc_error;


        for (my $cmi = 0; 
          $cmi < manditory_int($Opt, "num_tightly_coupled_instruction_masters");
          $cmi++) {

            nios_ecc_decoder->add({
              name => $Opt->{name} . "_tightly_coupled_instruction_master_${cmi}_ecc_decoder",
              codeword_width          => $ecc_data_sz,
              dataword_width          => $datapath_sz,
              standalone_decoder      => 1,
              correct_parity          => 1,
              port_map => {
                data          => "itcm${cmi}_readdata",
                q             => "itcm${cmi}_instword",
                one_bit_err   => "itcm${cmi}_one_bit_err_nxt",
                two_bit_err   => "itcm${cmi}_two_bit_err_nxt",
                corrected_data => "itcm${cmi}_corrected_data_nxt",
                one_two_or_three_bit_err     => "itcm${cmi}_one_two_three_bit_err",
              },
            });
        }


        for (my $cmi = 0; 
          $cmi < manditory_int($Opt, "num_tightly_coupled_instruction_masters");
          $cmi++) {
            my $master_name = "tightly_coupled_instruction_master_${cmi}";
            my $sel_name = "F_sel_" . $master_name;
            my $data_name = "itcm${cmi}_instword";
        
            if ($cmi == (manditory_int($Opt, 
              "num_tightly_coupled_instruction_masters") - 1)) {
                push(@iw_mux_table,
                  "1'b1" => $data_name);
            } else {
                push(@iw_mux_table,
                  $sel_name => $data_name);
            }
            
            e_register->adds(
                {out => ["D_itcm${cmi}_writedata", $ecc_data_sz],    in => "itcm${cmi}_corrected_data_nxt",
                 enable => "D_en"},
                {out => ["E_itcm${cmi}_writedata", $ecc_data_sz],    in => "D_itcm${cmi}_writedata",
                 enable => "E_en"},
                {out => ["M_itcm${cmi}_writedata", $ecc_data_sz],    in => "E_itcm${cmi}_writedata",
                 enable => "M_en"},
                 {out => ["D_itcm${cmi}_one_bit_err", 1],    in => "W_config_reg_eccen & itcm${cmi}_one_bit_err_nxt & F_sel_tightly_coupled_instruction_master_${cmi}",
                 enable => "D_en"},
                {out => ["E_itcm${cmi}_one_bit_err", 1],    in => "D_itcm${cmi}_one_bit_err & D_valid",
                 enable => "E_en"},
                {out => ["M_itcm${cmi}_one_bit_err", 1],    in => "E_itcm${cmi}_one_bit_err",
                 enable => "M_en"},

                {out => ["D_itcm${cmi}_two_bit_err", 1],    in => "W_ecc_exc_enabled & itcm${cmi}_two_bit_err_nxt & F_sel_tightly_coupled_instruction_master_${cmi}",
                 enable => "D_en"},
                 

                {out => ["D_itcm${cmi}_re", 1],    in => "itcm${cmi}_one_bit_err_nxt & F_sel_tightly_coupled_instruction_master_${cmi}",
                 enable => "D_en"},         
                {out => ["D_itcm${cmi}_ue", 1],    in => "itcm${cmi}_two_bit_err_nxt & F_sel_tightly_coupled_instruction_master_${cmi}",
                 enable => "D_en"},
            );

            create_x_filter({
               lhs       => "itcm${cmi}_re",
               rhs       => "D_itcm${cmi}_re", 
               sz        => 1,
             });
            
            create_x_filter({
               lhs       => "itcm${cmi}_ue",
               rhs       => "D_itcm${cmi}_ue", 
               sz        => 1,
             });


            e_signal->adds({ name => "itcm${cmi}_one_two_three_bit_err", width => 1, never_export => 1 });
            
            push(@tcim_ecc_error, "D_itcm${cmi}_two_bit_err");
        }
        
        my $ecc_two_bit_valid_err = "(" . join(" | ", @tcim_ecc_error) . ") & D_valid";
        new_exc_signal({
            exc             => $ecc_inst_error_exc,
            initial_stage   => "D", 
            rhs             => $ecc_two_bit_valid_err,
        });
    } else {
        for (my $cmi = 0; 
          $cmi < manditory_int($Opt, "num_tightly_coupled_instruction_masters");
          $cmi++) {
            my $master_name = "tightly_coupled_instruction_master_${cmi}";
            my $sel_name = "F_sel_" . $master_name;
            my $data_name = "itcm${cmi}_readdata";
        
            if ($cmi == (manditory_int($Opt, 
              "num_tightly_coupled_instruction_masters") - 1)) {
                push(@iw_mux_table,
                  "1'b1" => $data_name);
            } else {
                push(@iw_mux_table,
                  $sel_name => $data_name);
            }
        }
    }

    my $F_instruction_word = $big_endian ? "F_iw_be" : "F_iw";
    e_mux->add ({
      lhs => [$F_instruction_word, $datapath_sz],
      type => "priority",
      table => \@iw_mux_table,
    });

    if ($big_endian) {

        e_assign->adds(
            [["F_iw", 32], "{F_iw_be[7:0],F_iw_be[15:8],F_iw_be[23:16],F_iw_be[31:24]}"],
        );
    }

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
gen_tlb_inst
{
    my $Opt = shift;

    my $cs = not_empty_scalar($Opt, "control_reg_stage");

    my $oci_version = manditory_int($Opt, "oci_version");
    my $oci_bypasss_tlb = ($oci_version == 2) ? "| W_debug_mode" : ""; #bypass tlb when it is OCI version 2

    e_assign->adds(

      [["F_pc_vpn", $mmu_addr_vpn_sz], 
        "F_pc[$mmu_addr_vpn_msb-2:$mmu_addr_vpn_lsb-2]"], 
      [["D_pc_vpn", $mmu_addr_vpn_sz], 
        "D_pc[$mmu_addr_vpn_msb-2:$mmu_addr_vpn_lsb-2]"], 


      [["F_pc_page_offset", $mmu_addr_page_offset_sz-2], 
        "F_pc[$mmu_addr_page_offset_msb-2:$mmu_addr_page_offset_lsb]"], 


      [["F_pc_kernel_region", 1],
        "F_pc[$mmu_addr_kernel_region_msb-2:$mmu_addr_kernel_region_lsb-2]
          == $mmu_addr_kernel_region"],

      [["F_pc_io_region", 1],
        "F_pc[$mmu_addr_io_region_msb-2:$mmu_addr_io_region_lsb-2]
          == $mmu_addr_io_region"],

      [["D_pc_user_region", 1],
        "D_pc[$mmu_addr_user_region_msb-2:$mmu_addr_user_region_lsb-2]
          == $mmu_addr_user_region"],
      [["D_pc_supervisor_region", 1], "~D_pc_user_region"],

      [["D_pc_kernel_region", 1],
        "D_pc[$mmu_addr_kernel_region_msb-2:$mmu_addr_kernel_region_lsb-2]
          == $mmu_addr_kernel_region"],

      [["D_pc_io_region", 1],
        "D_pc[$mmu_addr_io_region_msb-2:$mmu_addr_io_region_lsb-2]
          == $mmu_addr_io_region"],


      [["F_pc_bypass_tlb", 1], "F_pc_kernel_region | F_pc_io_region" . $oci_bypasss_tlb],
      [["D_pc_bypass_tlb", 1], "D_pc_kernel_region | D_pc_io_region" . $oci_bypasss_tlb],
    );



    my $supervisor_inst_addr_exc_sig = new_exc_signal({
        exc             => $supervisor_inst_addr_exc,
        initial_stage   => "D",
        rhs             => "D_pc_supervisor_region & ${cs}_status_reg_u",
    });





    my $tlb_inst_miss_exc_sig = new_exc_signal({
        exc             => $tlb_inst_miss_exc,
        initial_stage   => "D",
        rhs             => "~D_pc_bypass_tlb & D_uitlb_m",
    });





    my $tlb_x_perm_exc_sig = new_exc_signal({
        exc             => $tlb_x_perm_exc,
        initial_stage   => "D", 
        rhs             => "~D_pc_bypass_tlb & ~D_uitlb_x",
    });


    my $uitlb_wave_signals = nios2_mmu::make_utlb($Opt, 0);


    e_register->adds(
      {out => ["D_uitlb_x", 1], 
       in => "F_uitlb_x",                       enable => "D_en"},
      {out => ["D_uitlb_m", 1], 
       in => "F_uitlb_m",                       enable => "D_en"},
      {out => ["D_pc_phy_got_pfn", 1], 
       in => "F_pc_phy_got_pfn",                enable => "D_en"},
      {out => ["D_pc_phy_pfn_valid", 1], 
       in => "F_pc_phy_pfn_valid",              enable => "D_en"},
      {out => ["D_pcb_phy", manditory_int($Opt, "i_Address_Width"),
       0, $force_never_export], 
       in => "F_pcb_phy",                       enable => "D_en"},
      {out => ["D_uitlb_index", $uitlb_index_sz],
      in => "F_uitlb_index",                    enable => "D_en"},
    );


    if ($mmu_ecc_present) {        
        my $ecc_itlb_sig = new_exc_signal({
            exc             => $ecc_itlb_error_exc,
            initial_stage   => "D", 
            rhs             => "D_uitlb_two_bit_err",
        });

        my $tlb_way_sz = get_control_reg_field_sz($tlbmisc_reg_way);
        e_register->adds(
          {out => ["D_uitlb_two_bit_err", 1], 
           in => "F_uitlb_two_bit_err",         enable => "D_en"},
          {out => ["D_uitlb_way", $tlb_way_sz], 
           in => "F_uitlb_way",                 enable => "D_en"},
        );
    }

    push(@plaintext_wave_signals, 
      @$uitlb_wave_signals,
      { divider => "TLB instruction Exceptions" },
      { radix => "x", signal => $supervisor_inst_addr_exc_sig },
      { radix => "x", signal => $tlb_inst_miss_exc_sig },
      { radix => "x", signal => $tlb_x_perm_exc_sig },
    );
}




sub 
gen_impu
{
    my $Opt = shift;

    my $cs = not_empty_scalar($Opt, "control_reg_stage");


    e_mux->add ({
      lhs => ["D_impu_good_perm", 1],
      selecto => "D_impu_perm",
      table => [
        $mpu_inst_perm_super_none_user_none => "0",
        $mpu_inst_perm_super_exec_user_none => "~${cs}_status_reg_u",
        $mpu_inst_perm_super_exec_user_exec => "1",
        ],
      default => "0",
    });






    my @impu_exc_conds = ("~D_impu_hit", "~D_impu_good_perm");

    my $unused_pc_msb = 29;
    my $unused_pc_lsb = manditory_int($Opt, "i_Address_Width") - 2;
    my $unused_pc_sz = $unused_pc_msb - $unused_pc_lsb + 1;

    if ($unused_pc_sz > 0) {
        push(@impu_exc_conds, "(D_pc[$unused_pc_msb:$unused_pc_lsb] != 0)");
    }

    new_exc_signal({
        exc             => $mpu_inst_region_violation_exc,
        initial_stage   => "D", 
        rhs             => 
          "${cs}_config_reg_pe & ~W_debug_mode & " .
          "(" . join('|', @impu_exc_conds) . ")",
    });


    my $impu_region_wave_signals = nios2_mpu::make_mpu_regions($Opt, 0);


    e_register->adds(
      {out => ["D_impu_hit", 1], 
       in => "F_impu_hit",                      enable => "D_en"},
      {out => ["D_impu_perm", $mpu_inst_perm_sz], 
       in => "F_impu_perm",                     enable => "D_en"},
    );

    push(@plaintext_wave_signals, 
      @$impu_region_wave_signals,
      { divider => "IMPU Exceptions" },
      get_exc_signal_wave($mpu_inst_region_violation_exc, "D"),
    );
}

1;
