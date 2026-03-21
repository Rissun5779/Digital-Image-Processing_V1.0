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






















package nios_common;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $nios_id
    $perf_cnt_inc_rd_stall
    $perf_cnt_inc_wr_stall
    $rf_num_set
    $rf_set_sz
    $rf_total_addr_sz
    $shadow_present
    $register_file_por
    $eic_present
    $eic_and_shadow
    $fa_present
    $bmx_present
    $cdx_present
    $ecc_present
    $ecc_test_ports_present
    $ic_ecc_present
    $dc_ecc_present
    $rf_ecc_present
    $itcm_ecc_present
    $dtcm_ecc_present
    $mmu_ecc_present
    $advanced_exc
    $reset_pc
    $reset_pch
    $exception_pc
    $exception_pch
    $big_endian
    $big_endian_tilde
    $perf_cnt_present
    $victim_buf_ram
    $victim_buf_reg

    $jmp_direct_hi_sz
    $imm16_sex_waddr_sz
    $imm16_sex_datapath_sz
    $byte_en_sz
    $byte_en_all_on
    $max_control_reg_sz
    $max_baddr_width
);

use cpu_utils;
use nios_avalon_masters;
use nios_isa;
use strict;


















































our $nios_id;
our $perf_cnt_inc_rd_stall = "1'b0";
our $perf_cnt_inc_wr_stall = "1'b0";
our $rf_num_set;
our $rf_set_sz;
our $rf_total_addr_sz;
our $shadow_present;
our $register_file_por;
our $eic_present;
our $eic_and_shadow;
our $fa_present;
our $bmx_present;
our $cdx_present;
our $ecc_present;
our $ecc_test_ports_present;
our $ic_ecc_present;
our $dc_ecc_present;
our $rf_ecc_present;
our $itcm_ecc_present;
our $dtcm_ecc_present;
our $mmu_ecc_present;
our $advanced_exc;
our $reset_pc;
our $reset_pch;
our $exception_pc;
our $exception_pch;
our $big_endian;
our $big_endian_tilde;
our $perf_cnt_present;
our $victim_buf_ram;
our $victim_buf_reg;

our $jmp_direct_hi_sz;
our $imm16_sex_waddr_sz;
our $imm16_sex_datapath_sz;
our $byte_en_sz;
our $byte_en_all_on;
our $max_control_reg_sz;





sub 
initialize_config_constants
{
    my $Opt = shift;







    $rf_num_set = manditory_int($Opt, "num_shadow_reg_sets") + 1;


    $rf_set_sz = count2sz($rf_num_set);


    $rf_total_addr_sz = $rf_addr_sz + $rf_set_sz;


    $shadow_present = ($rf_num_set > 1);
   
    $eic_present = manditory_bool($Opt, "eic_present");

    $eic_and_shadow = ($eic_present && $shadow_present);

    my $dcache_present = manditory_bool($Opt, "cache_has_dcache");
    my $icache_present = manditory_bool($Opt, "cache_has_icache");
    
    my $cache_dcache_victim_buf_impl = not_empty_scalar($Opt, "cache_dcache_victim_buf_impl");
    $victim_buf_ram = ($cache_dcache_victim_buf_impl eq "ram");
    $victim_buf_reg = ($cache_dcache_victim_buf_impl eq "reg");

    $fa_present  = manditory_bool($Opt, "fa_present");
    $bmx_present = manditory_bool($Opt, "bmx_present");
    $cdx_present = manditory_bool($Opt, "cdx_present");

    $ecc_present = manditory_bool($Opt, "ecc_present");
    $ecc_test_ports_present = $ecc_present && manditory_bool($Opt, "activate_ecc_sim_test_ports");
    $ic_ecc_present = $ecc_present && $icache_present && manditory_bool($Opt, "ic_ecc_present");
    $dc_ecc_present = $ecc_present && $dcache_present && manditory_bool($Opt, "dc_ecc_present");
    $rf_ecc_present = $ecc_present && manditory_bool($Opt, "rf_ecc_present");
    $itcm_ecc_present = $ecc_present && 
      (manditory_int($Opt, "num_tightly_coupled_instruction_masters") > 0) && 
      manditory_bool($Opt, "itcm_ecc_present");
    $dtcm_ecc_present = $ecc_present &&
      (manditory_int($Opt, "num_tightly_coupled_data_masters") > 0) && 
      manditory_bool($Opt, "dtcm_ecc_present");
    $mmu_ecc_present = $ecc_present && 
      manditory_bool($Opt, "mmu_present") &&
      manditory_bool($Opt, "mmu_ecc_present");


    $advanced_exc = manditory_bool($Opt, "advanced_exc");


    $reset_pc = manditory_int($Opt, "reset_addr") >> 2;
    $reset_pch = manditory_int($Opt, "reset_addr") >> 1;


    $exception_pc = manditory_int($Opt, "general_exception_addr") >> 2;
    $exception_pch = manditory_int($Opt, "general_exception_addr") >> 1;

    $big_endian = manditory_bool($Opt, "big_endian");
    $big_endian_tilde = $big_endian ? "~" : "";


    $perf_cnt_present = manditory_bool($Opt, "perf_cnt_present");


    $register_file_por = manditory_bool($Opt, "register_file_por");
    




    if (!defined($pc_sz)) {
        &$error("pc_sz is not defined");
    }

    if (!defined($datapath_sz)) {
        &$error("datapath_sz is not defined");
    }





    $jmp_direct_hi_sz = $pc_sz - 26;


    $imm16_sex_waddr_sz = $pc_sz - 16;    


    $imm16_sex_datapath_sz = $datapath_sz - 16;    


    $byte_en_sz = $datapath_sz / 8;


    $byte_en_all_on = "{${byte_en_sz}\{1'b1}}";


    $max_control_reg_sz = 32;
    
    my $cpu_arch_rev = manditory_int($Opt, "cpu_arch_rev");
    my $core_type = not_empty_scalar($Opt, "core_type");
    

    my $nios_version = 2;
    my $nios_arch_revision = $cpu_arch_rev;
    my $nios_core_type = ($core_type eq "tiny") ? 1 :
                         ($core_type eq "fast") ? 2 :
                         ($core_type eq "small") ? 3 :
                         0; # Undefined
    my $oci_version = manditory_int($Opt, "oci_version");
    
    $nios_id =  ($nios_core_type << 13) | ($oci_version << 6) | ($nios_arch_revision << 4) | $nios_version;
}

1;
