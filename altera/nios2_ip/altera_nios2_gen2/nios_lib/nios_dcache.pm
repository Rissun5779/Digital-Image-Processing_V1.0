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






















package nios_dcache;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $dcache_present
);

use europa_all;
use europa_utils;
use cpu_utils;
use cpu_wave_signals;
use cpu_file_utils;
use cpu_gen;
use cpu_bit_field;
use nios_sdp_ram;
use nios_utils;
use nios_avalon_masters;
use nios_common;
use nios_isa;
use strict;











our $dcache_present;
our $victim_buf_ram;
our $victim_buf_reg;





sub
initialize_config_constants
{
    my $Opt = shift;


    $dcache_present = manditory_bool($Opt, "cache_has_dcache");

}


sub
gen_dcache
{
    my $Opt = shift;

    if (!$dcache_present) {
        &$error("Called when data cache not present");
    }

    my $cache_dcache_victim_buf_impl = not_empty_scalar($Opt, "cache_dcache_victim_buf_impl");
    if (!$victim_buf_ram && !$victim_buf_reg) {
        &$error("Unrecognize value for cache_dcache_victim_buf_impl of '" .
          $cache_dcache_victim_buf_impl . "'");
    }

    gen_dcache_controls($Opt);

    return gen_wide_dcache($Opt);
}


sub
gen_dcache_controls
{
    my $Opt = shift;









    my $gen_info = manditory_hash($Opt, "gen_info");
    my $bypass_stages = ($mmu_present || $mpu_present) ? ["M", "A"] : ["E", "M", "A"];
    my $bs = ($mmu_present || $mpu_present) ? "M" : "E";





    if ($mpu_present) {       
        my @M_mem_bypass_non_io_expr;
        if (manditory_bool($Opt, "bit_31_bypass_dcache")) {


            push(@M_mem_bypass_non_io_expr, "(M_alu_result[$datapath_msb])");
        } 
        
        if (manditory_bool($Opt, "ioregion_dcache")) {

            my $ioregion_bit_sz =  count2sz(manditory_int($Opt, "ioregion_size_dcache"));
            my $ioregion_base_dcache =  manditory_int($Opt, "ioregion_base_dcache");


            my $io_size_msb = $ioregion_bit_sz;


            my $io_base_effective = (2 ** ($mem_baddr_sz - $io_size_msb)) - 1;



            my $ioregion_base_shifted = 
              ($ioregion_base_dcache >> $io_size_msb) & $io_base_effective;

            if ($ioregion_base_dcache == (2 ** 31)) {
                push(@M_mem_bypass_non_io_expr, "(M_mem_baddr[$mem_baddr_sz-1] == 1)");
            } else {
                push(@M_mem_bypass_non_io_expr, "(M_mem_baddr[$mem_baddr_sz-1:$io_size_msb] == $ioregion_base_shifted)");
            }
        }


        push(@M_mem_bypass_non_io_expr, "(~(M_dmpu_mt == 1) & W_config_reg_pe & ~W_debug_mode)");

        e_assign->adds(
              [["M_mem_bypass_non_io", 1], scalar(@M_mem_bypass_non_io_expr) ? join(' | ', @M_mem_bypass_non_io_expr) : "0"],
        );
    } elsif ($mmu_present) {


        e_assign->adds(
          [["M_mem_bypass_non_io", 1],
             "M_mem_baddr_io_region | (~M_mem_baddr_kernel_region & ~M_udtlb_c)"],
        );
    } else {
        my @E_mem_bypass_non_io_expr;
        if (manditory_bool($Opt, "bit_31_bypass_dcache")) {


            push(@E_mem_bypass_non_io_expr, "(E_arith_result[$datapath_msb])");
        } 
        
        if (manditory_bool($Opt, "ioregion_dcache")) {

            my $ioregion_bit_sz =  count2sz(manditory_int($Opt, "ioregion_size_dcache"));
            my $ioregion_base_dcache =  manditory_int($Opt, "ioregion_base_dcache");


            my $io_size_msb = $ioregion_bit_sz;


            my $io_base_effective = (2 ** ($mem_baddr_sz - $io_size_msb)) - 1;



            my $ioregion_base_shifted = 
              ($ioregion_base_dcache >> $io_size_msb) & $io_base_effective;

            if ($ioregion_base_dcache == (2 ** 31)) {
                push(@E_mem_bypass_non_io_expr, "(E_mem_baddr[$mem_baddr_sz-1] == 1)");
            } else {
                push(@E_mem_bypass_non_io_expr, "(E_mem_baddr[$mem_baddr_sz-1:$io_size_msb] == $ioregion_base_shifted)");
            }
        }
        
        e_assign->adds(
              [["E_mem_bypass_non_io", 1], scalar(@E_mem_bypass_non_io_expr) ? join(' | ', @E_mem_bypass_non_io_expr) : "0"],
        );
    }



    e_assign->adds(
      [["A_valid_st_writes_mem", 1], "A_ctrl_st & A_valid & A_st_writes_mem"],
    );










    e_assign->adds(



      [["${bs}_ld_cache", 1], 
        "${bs}_sel_data_master &
          ${bs}_ctrl_ld_non_io & ~${bs}_mem_bypass_non_io"],

      [["${bs}_st_cache", 1], 
        "${bs}_sel_data_master &
          ${bs}_ctrl_st_non_io & ~${bs}_mem_bypass_non_io & ${bs}_st_writes_mem"],

      [["${bs}_ld_st_cache", 1], 
        "${bs}_sel_data_master &
          ${bs}_ctrl_ld_st_non_io & ~${bs}_mem_bypass_non_io & ${bs}_st_writes_mem"],

      [["${bs}_stnon32_cache", 1], 
        "${bs}_sel_data_master &
          ${bs}_ctrl_st_non32 & ~${bs}_mem_bypass_non_io & ${bs}_st_writes_mem"],

      [["${bs}_ld_stnon32_cache", 1], 
        "${bs}_sel_data_master &
          (${bs}_ctrl_ld_non_io | ${bs}_ctrl_st_non32) &
            ~${bs}_mem_bypass_non_io & ${bs}_st_writes_mem"],




      [["${bs}_ld_bus", 1], 
        "${bs}_sel_data_master &
           (${bs}_ctrl_ld_io | (${bs}_ctrl_ld_non_io & ${bs}_mem_bypass_non_io))"],
           
      [["${bs}_st_bus", 1], 
        "${bs}_sel_data_master &
          (${bs}_ctrl_st_io | 
            (${bs}_ctrl_st_non_io & ${bs}_mem_bypass_non_io & ${bs}_st_writes_mem))"],

      [["${bs}_ld_st_bus", 1], 
        "${bs}_sel_data_master &
          (${bs}_ctrl_ld_st_io | 
            (${bs}_ctrl_ld_st_non_io & ${bs}_mem_bypass_non_io & ${bs}_st_writes_mem))"],

      [["${bs}_ld_st_dcache_management_bus", 1], 
        "${bs}_ld_st_bus | ${bs}_ctrl_dcache_management"],
    );


    cpu_pipeline_control_signal($gen_info, "ctrl_ld_cache", $bypass_stages, "${bs}_ld_cache");
    cpu_pipeline_control_signal($gen_info, "ctrl_st_cache", $bypass_stages, "${bs}_st_cache");
    cpu_pipeline_control_signal($gen_info, "ctrl_ld_st_cache", $bypass_stages, "${bs}_ld_st_cache");
    cpu_pipeline_control_signal($gen_info, "ctrl_stnon32_cache", $bypass_stages, 
      "${bs}_stnon32_cache");
    cpu_pipeline_control_signal($gen_info, "ctrl_ld_stnon32_cache", $bypass_stages, 
      "${bs}_ld_stnon32_cache");


    cpu_pipeline_control_signal($gen_info, "ctrl_ld_bypass", $bypass_stages, "${bs}_ld_bus");
    cpu_pipeline_control_signal($gen_info, "ctrl_st_bypass", $bypass_stages, "${bs}_st_bus");
    cpu_pipeline_control_signal($gen_info, "ctrl_ld_st_bypass", $bypass_stages, "${bs}_ld_st_bus");
    cpu_pipeline_control_signal($gen_info, "ctrl_ld_st_bypass_or_dcache_management", $bypass_stages,
      "${bs}_ld_st_dcache_management_bus");


    cpu_pipeline_control_signal($gen_info, "ctrl_ld_non_bypass", $bypass_stages,
      "${bs}_ld_cache | ${bs}_dtcm_ld");
    cpu_pipeline_control_signal($gen_info, "ctrl_st_non_bypass", $bypass_stages,
      "${bs}_st_cache | ${bs}_dtcm_st");
    cpu_pipeline_control_signal($gen_info, "ctrl_ld_st_non_bypass", $bypass_stages, 
      "${bs}_ld_st_cache | ${bs}_dtcm_ld_st");









    cpu_pipeline_control_signal($gen_info, "ctrl_mem_dc_tag_rd", $bypass_stages,
      "${bs}_ld_st_cache | 
       ${bs}_ctrl_dc_index_wb_inv |
       ${bs}_ctrl_dc_addr_wb_inv |
       ${bs}_ctrl_dc_addr_nowb_inv");







    cpu_pipeline_control_signal($gen_info, "ctrl_mem_dc_data_rd", $bypass_stages, 
      "${bs}_ld_stnon32_cache");

    my $M_A_dc_data_ram_addr_match = $dc_ecc_present ? "M_mem_baddr_line_field == A_mem_baddr_line_field" : "M_mem_waddr_phy == A_mem_waddr_phy";
    my $M_W_dc_data_ram_addr_match = $dc_ecc_present ? "M_mem_baddr_line_field == W_mem_baddr_line_field" : "M_mem_waddr_phy == W_mem_waddr_phy";
    
    e_assign->adds(





      [["M_A_dc_tag_ram_addr_match", 1], "M_mem_baddr_line_field == A_mem_baddr_line_field"],
      [["M_W_dc_tag_ram_addr_match", 1], "M_mem_baddr_line_field == W_mem_baddr_line_field"],


      [["M_A_dc_tag_line_addr_match", 1], $mmu_present ? 
         "(M_mem_baddr_line_field == A_mem_baddr_line_field)" :
         "(M_mem_baddr_tag_field == A_mem_baddr_tag_field) & 
          (M_mem_baddr_line_field == A_mem_baddr_line_field)"],

      [["A_dc_valid_st_cache_hit", 1], "A_ctrl_st_cache & A_valid & A_dc_hit"],





































      [["M_dc_dirty", 1], 
        "M_dc_dirty_raw | 
         (M_A_dc_tag_ram_addr_match & A_dc_valid_st_cache_hit) |
         (M_W_dc_tag_ram_addr_match & W_dc_valid_st_cache_hit)"],

      [["M_dc_raw_hazard", 1],
        "M_valid_ignoring_refetch & 
         (
           (
             A_dc_valid_st_cache_hit & ($M_A_dc_data_ram_addr_match) &
             (
               (M_ctrl_ld_cache & ($dc_ecc_present | ((M_mem_byte_en & A_mem_byte_en) != 0))) |
               (M_ctrl_stnon32_cache & $dc_ecc_present)
             )
           ) |
           (
             W_dc_valid_st_cache_hit & ($M_W_dc_data_ram_addr_match) &
             (
               (M_ctrl_ld_cache & ($dc_ecc_present | ((M_mem_byte_en & W_mem_byte_en) != 0))) |
               (M_ctrl_stnon32_cache & $dc_ecc_present)
             )
           )
         )"],
    );

    e_register->adds(
      {out => ["A_dc_dirty", 1],            
       in => "M_dc_dirty",                      enable => "A_en"},
      {out => ["W_dc_valid_st_cache_hit", 1],
       in => "A_dc_valid_st_cache_hit",         enable => "W_en"},
    );

    push(@plaintext_wave_signals,
        { divider => "dcache_controls" },
        { radix => "x", signal => "M_dc_dirty" },
        { radix => "x", signal => "M_dc_dirty_raw" },
        { radix => "x", signal => "M_A_dc_tag_ram_addr_match" },
        { radix => "x", signal => "M_W_dc_tag_ram_addr_match" },
        { radix => "x", signal => "A_dc_valid_st_cache_hit" },
        { radix => "x", signal => "W_dc_valid_st_cache_hit" },
        { radix => "x", signal => "M_dc_raw_hazard" },
        { radix => "x", signal => "M_ctrl_ld_cache" },
        { radix => "x", signal => "M_valid_ignoring_refetch" },
    );
}




sub 
gen_wide_dcache
{
    my $Opt = shift;

    my $whoami = "wide data cache";

    my @dc_ecc_waves;
    if ($dc_ecc_present) {
        push(@dc_ecc_waves, { divider => "dcache_ecc" });
    }















    my $dc_bytes_per_line = manditory_int($Opt, "cache_dcache_line_size");
    if ($dc_bytes_per_line < 8) {
        &$error("Number of D-Cache bytes per line must be 8 or more but is " .
           $dc_bytes_per_line . "\n");
    }

    my $dc_total_bytes = manditory_int($Opt, "cache_dcache_size");
    my $data_master_addr_sz = manditory_int($Opt->{data_master}, "Address_Width");


    my $dc_words_per_line = $dc_bytes_per_line >> 2;
    my $dc_num_lines = $dc_total_bytes / $dc_bytes_per_line;




    my $line_word_cnt_max = $dc_words_per_line;
    my $line_word_cnt_sz = num2sz($line_word_cnt_max);




    my $dc_addr_byte_field_sz = 2;
    my $dc_addr_byte_field_lsb = 0;
    my $dc_addr_byte_field_msb = $dc_addr_byte_field_lsb + $dc_addr_byte_field_sz - 1;

    my $dc_addr_offset_field_sz = count2sz($dc_words_per_line);
    my $dc_addr_offset_field_lsb = $dc_addr_byte_field_msb + 1;
    my $dc_addr_offset_field_msb = $dc_addr_offset_field_lsb + $dc_addr_offset_field_sz - 1;

    my $dc_max_addr_offset = (1 << $dc_addr_offset_field_sz) - 1;

    my $dc_addr_line_field_sz = count2sz($dc_num_lines);
    my $dc_addr_line_field_lsb = $dc_addr_offset_field_msb + 1;
    my $dc_addr_line_field_msb = $dc_addr_line_field_lsb + $dc_addr_line_field_sz - 1;


    my $dc_addr_line_offset_field_sz = $dc_addr_line_field_sz + $dc_addr_offset_field_sz;





    my $dc_addr_line_field_paddr_sz = $dc_addr_line_field_sz;
    my $dc_addr_line_field_paddr_lsb = $dc_addr_line_field_lsb;
    my $dc_addr_line_field_paddr_msb = $dc_addr_line_field_msb;

    my $dc_addr_tag_field_msb = $data_master_addr_sz - 1;
    my $dc_addr_tag_field_lsb = $dc_addr_line_field_msb + 1;
    if ($mmu_present) {
        my $mmu_addr_pfn_lsb = manditory_int($Opt, "mmu_addr_pfn_lsb");

        if ($dc_addr_tag_field_lsb > $mmu_addr_pfn_lsb) {

            $dc_addr_tag_field_lsb = $mmu_addr_pfn_lsb;
    

            $dc_addr_line_field_paddr_msb = $mmu_addr_pfn_lsb - 1;
            $dc_addr_line_field_paddr_sz = 
              $dc_addr_line_field_paddr_msb - $dc_addr_line_field_paddr_lsb + 1;
        }
    }
    my $dc_addr_tag_field_sz = $dc_addr_tag_field_msb - $dc_addr_tag_field_lsb + 1;

    if ($dc_addr_tag_field_sz < 1) {
        &$error("D-cache is too large relative to data address size");
    }


    my $dc_tag_addr_sz = $dc_addr_line_field_sz;
    my $dc_tag_num_addrs = 0x1 << $dc_tag_addr_sz;




    my $dc_tag_entry_tag_sz = $dc_addr_tag_field_sz;
    my $dc_tag_entry_tag_lsb = 0;
    my $dc_tag_entry_tag_msb = $dc_tag_entry_tag_lsb + $dc_tag_entry_tag_sz - 1;

    my $dc_tag_entry_valid_sz = 1;
    my $dc_tag_entry_valid_lsb = $dc_tag_entry_tag_msb + 1;
    my $dc_tag_entry_valid_msb = $dc_tag_entry_valid_lsb + $dc_tag_entry_valid_sz - 1;

    my $dc_tag_entry_dirty_sz = 1;
    my $dc_tag_entry_dirty_lsb = $dc_tag_entry_valid_msb + 1;
    my $dc_tag_entry_dirty_msb = $dc_tag_entry_dirty_lsb + $dc_tag_entry_dirty_sz - 1;


    my $dc_tag_data_sz = $dc_tag_entry_tag_sz + $dc_tag_entry_valid_sz + $dc_tag_entry_dirty_sz;


    my $dc_data_addr_sz = $dc_addr_line_offset_field_sz;
    my $dc_data_num_addrs = 0x1 << $dc_data_addr_sz;


    my $dc_data_data_sz = $datapath_sz;


    my $dcache_data_ram_block_type = not_empty_scalar($Opt, "cache_dcache_ram_block_type");
    my $dcache_tag_ram_block_type = not_empty_scalar($Opt, "cache_dcache_tag_ram_block_type");






    e_assign->adds(
      [["E_mem_baddr_tag_field", $dc_addr_tag_field_sz, 0, $force_never_export],
        "E_mem_baddr[$dc_addr_tag_field_msb:$dc_addr_tag_field_lsb]"],
      [["E_mem_baddr_line_field", $dc_addr_line_field_sz, 0, $force_never_export],
        "E_mem_baddr[$dc_addr_line_field_msb:$dc_addr_line_field_lsb]"],
      [["E_mem_baddr_offset_field", $dc_addr_offset_field_sz, 0, $force_never_export],
        "E_mem_baddr[$dc_addr_offset_field_msb:$dc_addr_offset_field_lsb]"],
      [["E_mem_baddr_line_offset_field", $dc_addr_line_offset_field_sz, 0, $force_never_export],
        "E_mem_baddr[$dc_addr_line_field_msb:$dc_addr_offset_field_lsb]"],
      [["E_mem_baddr_byte_field", $dc_addr_byte_field_sz, 0, $force_never_export],
        "E_mem_baddr[$dc_addr_byte_field_msb:$dc_addr_byte_field_lsb]"],

      [["M_mem_baddr_tag_field", $dc_addr_tag_field_sz, 0, $force_never_export],
        "M_mem_baddr[$dc_addr_tag_field_msb:$dc_addr_tag_field_lsb]"],
      [["M_mem_baddr_line_field", $dc_addr_line_field_sz, 0, $force_never_export],
        "M_mem_baddr[$dc_addr_line_field_msb:$dc_addr_line_field_lsb]"],
      [["M_mem_baddr_offset_field", $dc_addr_offset_field_sz, 0, $force_never_export],
        "M_mem_baddr[$dc_addr_offset_field_msb:$dc_addr_offset_field_lsb]"],
      [["M_mem_baddr_line_offset_field", $dc_addr_line_offset_field_sz, 0, $force_never_export],
        "M_mem_baddr[$dc_addr_line_field_msb:$dc_addr_offset_field_lsb]"],
      [["M_mem_baddr_byte_field", $dc_addr_byte_field_sz, 0, $force_never_export],
        "M_mem_baddr[$dc_addr_byte_field_msb:$dc_addr_byte_field_lsb]"],

      [["A_mem_baddr_tag_field", $dc_addr_tag_field_sz, 0, $force_never_export],
        "A_mem_baddr[$dc_addr_tag_field_msb:$dc_addr_tag_field_lsb]"],
      [["A_mem_baddr_line_field", $dc_addr_line_field_sz, 0, $force_never_export],
        "A_mem_baddr[$dc_addr_line_field_msb:$dc_addr_line_field_lsb]"],
      [["A_mem_baddr_offset_field", $dc_addr_offset_field_sz, 0, $force_never_export],
        "A_mem_baddr[$dc_addr_offset_field_msb:$dc_addr_offset_field_lsb]"],
      [["A_mem_baddr_line_offset_field", $dc_addr_line_offset_field_sz, 0, $force_never_export],
        "A_mem_baddr[$dc_addr_line_field_msb:$dc_addr_offset_field_lsb]"],
      [["A_mem_baddr_byte_field", $dc_addr_byte_field_sz, 0, $force_never_export],
        "A_mem_baddr[$dc_addr_byte_field_msb:$dc_addr_byte_field_lsb]"],

      [["W_mem_baddr_tag_field", $dc_addr_tag_field_sz, 0, $force_never_export],
        "W_mem_baddr[$dc_addr_tag_field_msb:$dc_addr_tag_field_lsb]"],
      [["W_mem_baddr_line_field", $dc_addr_line_field_sz, 0, $force_never_export],
        "W_mem_baddr[$dc_addr_line_field_msb:$dc_addr_line_field_lsb]"],
      [["W_mem_baddr_offset_field", $dc_addr_offset_field_sz, 0, $force_never_export],
        "W_mem_baddr[$dc_addr_offset_field_msb:$dc_addr_offset_field_lsb]"],
      [["W_mem_baddr_line_offset_field", $dc_addr_line_offset_field_sz, 0, $force_never_export],
        "W_mem_baddr[$dc_addr_line_field_msb:$dc_addr_offset_field_lsb]"],
      [["W_mem_baddr_byte_field", $dc_addr_byte_field_sz, 0, $force_never_export],
        "W_mem_baddr[$dc_addr_byte_field_msb:$dc_addr_byte_field_lsb]"],
    );
















     


    e_signal->adds(
      {name => "dc_tag_rd_port_data", width => $dc_tag_data_sz },
    );
    if ($dc_ecc_present) {
        e_signal->adds(
         {name => "dc_tag_rd_port_corrected_data", width => $dc_tag_data_sz },
         {name => "dc_tag_rd_port_one_bit_err", width => 1 },
         {name => "dc_tag_rd_port_two_bit_err", width => 1 },
         {name => "dc_tag_rd_port_any_ecc_err", width => 1 },
       );
    }










    my @dc_tag_wr_port_data_mux_table;

    if ($dc_ecc_present) {

        push (@dc_tag_wr_port_data_mux_table,
          "A_dc_ecc_flush_the_tag" => "{dc_line_dirty_off, dc_line_valid_off, A_dc_desired_tag}"
        );
    }
  
    push (@dc_tag_wr_port_data_mux_table,
      "A_dc_fill_starting_d1" => 
        "{A_valid_st_writes_mem, dc_line_valid_on, A_dc_desired_tag}",
      "A_dc_tag_dcache_management_wr_en" => 
        "{dc_line_dirty_off, dc_line_valid_off, A_dc_desired_tag}",
      "1'b1", => 
        "{dc_line_dirty_on,  dc_line_valid_on,  A_dc_desired_tag}",
    );
    e_mux->adds({
      lhs => ["dc_tag_wr_port_data", $dc_tag_data_sz],
      type => "priority",
      table => \@dc_tag_wr_port_data_mux_table,
    });

    e_assign->adds(



      [["A_dc_tag_st_wr_en", 1], "A_dc_valid_st_cache_hit & !A_dc_dirty & A_en_d1"],



      [["A_dc_tag_dcache_management_wr_en", 1], 
         "(A_ctrl_dc_index_inv | (A_ctrl_dc_addr_inv & A_dc_hit)) & A_valid & A_en_d1"],
    );

    my @dc_tag_wr_port_en_inputs = ( 
      "A_dc_tag_st_wr_en",
      "A_dc_tag_dcache_management_wr_en",
      "A_dc_fill_starting_d1",
    );

    if ($dc_ecc_present) {


      push(@dc_tag_wr_port_en_inputs, "(A_dc_ecc_correct_the_tag | A_dc_ecc_flush_the_tag)");
    }

    e_assign->adds(
      [["dc_tag_wr_port_en", 1], join("|", @dc_tag_wr_port_en_inputs)],


      [["dc_tag_wr_port_addr", $dc_tag_addr_sz], "A_mem_baddr_line_field"],


      [["dc_line_dirty_on", 1],  "1'b1"],
      [["dc_line_dirty_off", 1], "1'b0"],
      [["dc_line_valid_on", 1],  "1'b1"],
      [["dc_line_valid_off", 1], "1'b0"],
        

      [["M_dc_tag_entry", $dc_tag_data_sz], "dc_tag_rd_port_data"],


      [["M_dc_dirty_raw", 1], "M_dc_tag_entry[$dc_tag_entry_dirty_lsb]"],
      [["M_dc_valid", 1], "M_dc_tag_entry[$dc_tag_entry_valid_lsb]"],
      [["M_dc_actual_tag", $dc_addr_tag_field_sz], 
        "M_dc_tag_entry[$dc_tag_entry_tag_msb:$dc_tag_entry_tag_lsb]"],
    );

    my $dc_tag_port_map = {
      clock     => "clk",


      rdaddress => "dc_tag_rd_port_addr",
      q         => "dc_tag_rd_port_data",


      wren      => "dc_tag_wr_port_en",
      data      => "dc_tag_wr_port_data",
      wraddress => "dc_tag_wr_port_addr",
    };

    my @dc_tag_ram_ecc_waves;

    if ($dc_ecc_present) {

        $dc_tag_port_map->{corrected_data_to_encoder} = "dc_tag_wr_port_corrected_data";
        $dc_tag_port_map->{injs} = "dc_tag_wr_port_injs";
        $dc_tag_port_map->{injd} = "dc_tag_wr_port_injd";
        $dc_tag_port_map->{wrsel} = "dc_tag_wr_port_wrsel";
        if ($ecc_test_ports_present) {
            my $dc_tag_ecc_bits = calc_num_ecc_bits($dc_tag_data_sz);
            my $dc_tag_ecc_data_sz =  $dc_tag_data_sz + $dc_tag_ecc_bits;
            $dc_tag_port_map->{test_invert} = "ecc_test_dc_tag[$dc_tag_ecc_data_sz-1:0]";
        }


        $dc_tag_port_map->{corrected_data_from_decoder} = "dc_tag_rd_port_corrected_data";
        $dc_tag_port_map->{one_bit_err} = "dc_tag_rd_port_one_bit_err";
        $dc_tag_port_map->{two_bit_err} = "dc_tag_rd_port_two_bit_err";
        $dc_tag_port_map->{one_two_or_three_bit_err} = "dc_tag_rd_port_any_ecc_err";

        push(@dc_tag_ram_ecc_waves,
          { radix => "x", signal => "dc_tag_wr_port_corrected_data" },
          { radix => "x", signal => "dc_tag_wr_port_injs" },
          { radix => "x", signal => "dc_tag_wr_port_injd" },
          { radix => "x", signal => "dc_tag_wr_port_wrsel" },
          { radix => "x", signal => "dc_tag_rd_port_corrected_data" },
          { radix => "x", signal => "dc_tag_rd_port_one_bit_err" },
          { radix => "x", signal => "dc_tag_rd_port_two_bit_err" },
          { radix => "x", signal => "dc_tag_rd_port_any_ecc_err" },
        );

        push(@dc_ecc_waves,
            { radix => "x", signal => "W_dc_tag_injs" },
            { radix => "x", signal => "W_dc_tag_injd" },
            { radix => "x", signal => "M_dc_tag_raw_recoverable_ecc_err" },
            { radix => "x", signal => "M_dc_tag_raw_unrecoverable_ecc_err" },
            { radix => "x", signal => "M_dc_tag_raw_any_ecc_err" },
            { radix => "x", signal => "M_dc_unrecoverable_ecc_err" },
            { radix => "x", signal => "M_dc_ecc_A_refetch_required" },
            { radix => "x", signal => "A_dc_ecc_correct_the_tag" },
            { radix => "x", signal => "A_dc_ecc_flush_the_tag" },
            { radix => "x", signal => "A_dc_ecc_correct_the_data" },
            { radix => "x", signal => "A_dc_tag_ecc_event_recoverable_err" },
            { radix => "x", signal => "A_dc_data_ecc_event_recoverable_err" },
            { radix => "x", signal => "A_dc_unrecoverable_ecc_err" },
            { radix => "x", signal => "W_dc_unrecoverable_ecc_err" },
            { radix => "x", signal => "pending_dc_unrecoverable_ecc_err" },
            { radix => "x", signal => "M_valid_from_E" },
            { radix => "x", signal => "A_pipe_flush" },
        );

        e_assign->adds(

          [["dc_tag_wr_port_injs", 1], "W_dc_tag_injs"],
          [["dc_tag_wr_port_injd", 1], "W_dc_tag_injd"],





          [["M_dc_tag_raw_recoverable_ecc_err", 1], 
             "dc_tag_rd_port_one_bit_err & M_ctrl_mem_dc_tag_rd"],





          [["M_dc_tag_raw_unrecoverable_ecc_err", 1], 
             "dc_tag_rd_port_two_bit_err & M_ctrl_mem_dc_tag_rd"],




          [["M_dc_tag_raw_any_ecc_err", 1],
             "dc_tag_rd_port_any_ecc_err & M_ctrl_mem_dc_tag_rd"],



          [["dc_tag_wr_port_wrsel", 1], "A_dc_ecc_correct_the_tag"],


          [["M_dc_tag_corrected_data", $dc_tag_data_sz], "dc_tag_rd_port_corrected_data"],
          [["dc_tag_wr_port_corrected_data", $dc_tag_data_sz], "A_dc_tag_corrected_data"],
        );

        e_register->adds(

          {out => ["A_dc_tag_ecc_event_recoverable_err", 1], 
           in => "M_dc_tag_raw_recoverable_ecc_err & M_valid",
           enable => "A_en"},
          {out => ["A_dc_tag_raw_unrecoverable_ecc_err", 1], 
           in => "M_dc_tag_raw_unrecoverable_ecc_err & M_valid", 
           enable => "A_en"},


          {out => ["A_dc_tag_corrected_data", $dc_tag_data_sz], 
           in => "M_dc_tag_corrected_data", 
           enable => "A_en"},
        );

        if ($ecc_test_ports_present) {
            e_register->adds(
              {out => ["ecc_test_dc_tag_valid_d1", 1], 
               in => "ecc_test_dc_tag_valid & dc_tag_wr_port_en",
               enable => "1'b1"},
            );
            e_assign->adds(
              [["ecc_test_dc_tag_ready", 1], "~ecc_test_dc_tag_valid | ecc_test_dc_tag_valid_d1"],
           );
       }
    }











    e_assign->adds(
      [["dc_tag_rd_port_addr", $dc_tag_addr_sz], 
        "M_en ? E_mem_baddr_line_field : M_mem_baddr_line_field"],
    );

    my $dc_tag_ram_fname = $Opt->{name} . "_dc_tag_ram";



   if (manditory_bool($Opt, "export_large_RAMs")) {
        e_comment->add({
          comment => 
            ("Export D cache tag RAM ports to top level\n" .
             "because the RAM is instantiated external to CPU.\n"),
        });

        e_assign->adds(

          [["dcache_g4b_tag_ram_write_data", $dc_tag_data_sz], 
            "dc_tag_wr_port_data"],
          ["dcache_g4b_tag_ram_write_enable", 
            "dc_tag_wr_port_en"],
          [["dcache_g4b_tag_ram_write_address", $dc_tag_addr_sz], 
            "dc_tag_wr_port_addr"],
          [["dcache_g4b_tag_ram_read_clk_en", 1], "1'b1"],
          [["dcache_g4b_tag_ram_read_address", $dc_tag_addr_sz], 
            "dc_tag_rd_port_addr"],


          ["dc_tag_rd_port_data", 
            ["dcache_g4b_tag_ram_read_data", $dc_tag_data_sz]],
        );
    } else {




        nios_sdp_ram->add({
          name => $Opt->{name} . "_dc_tag",
          Opt                     => $Opt,
          data_width              => $dc_tag_data_sz,
          address_width           => $dc_tag_addr_sz,
          num_words               => $dc_tag_num_addrs,
          contents_file           => $dc_tag_ram_fname,
          read_during_write_mode_mixed_ports => qq("OLD_DATA"),
          ram_block_type          => '"' . $dcache_tag_ram_block_type . '"',
          ecc_present             => $dc_ecc_present,
          verification            => $ecc_test_ports_present,
          port_map                => $dc_tag_port_map,
        });
    }

    my $do_build_sim = manditory_bool($Opt, "do_build_sim");
    my $simulation_directory = $do_build_sim ? 
        not_empty_scalar($Opt, "simulation_directory") : undef;

    make_contents_file_for_ram({
      filename_no_suffix        => $dc_tag_ram_fname,
      data_sz                   => $dc_tag_data_sz,
      ecc_present               => $dc_ecc_present,
      num_entries               => $dc_tag_num_addrs, 
      value_str                 => "random",
      clear_hdl_sim_contents    => 
        manditory_bool($Opt, "hdl_sim_caches_cleared"),
      do_build_sim              => $do_build_sim,
      simulation_directory      => $simulation_directory,
      system_directory          => not_empty_scalar($Opt, "system_directory"),
    });





    if ($mmu_present) {
        e_assign->adds(
          [["M_dc_desired_tag", $dc_addr_tag_field_sz],
            "M_mem_baddr_phy[$dc_addr_tag_field_msb:$dc_addr_tag_field_lsb]"],







          [["M_dc_tag_match", 1], 
            "(M_dc_desired_tag == M_dc_actual_tag) & M_mem_baddr_phy_got_pfn"],
        );      


        e_register->adds(
          {out => ["A_dc_desired_tag", $dc_addr_tag_field_sz], 
           in => "M_dc_desired_tag", enable => "A_en"},
        );
    } else {
        e_assign->adds(

          [["M_dc_desired_tag", $dc_addr_tag_field_sz],
            "M_mem_baddr[$dc_addr_tag_field_msb:$dc_addr_tag_field_lsb]"],
      

          [["M_dc_tag_match", 1], "M_dc_desired_tag == M_dc_actual_tag"],


          [["A_dc_desired_tag", $dc_addr_tag_field_sz],
            "A_mem_baddr[$dc_addr_tag_field_msb:$dc_addr_tag_field_lsb]"],
        );
    }



    e_assign->adds(
      [["M_dc_hit", 1], "M_dc_tag_match & M_dc_valid"],
    );

    e_register->adds(
      {out => ["A_dc_hit", 1], 
       in => "M_dc_hit",                    enable => "A_en"},
    );
















    e_signal->adds(
      {name => "dc_data_rd_port_data", width => $dc_data_data_sz },
    );
    if ($dc_ecc_present) {
        e_signal->adds(
         {name => "dc_data_rd_port_corrected_data", width => $dc_data_data_sz },
         {name => "dc_data_rd_port_one_bit_err", width => 1 },
         {name => "dc_data_rd_port_two_bit_err", width => 1 },
         {name => "dc_data_rd_port_any_ecc_err", width => 1 },
       );
    }

    my $ecc_dc_data_wr_port_addr_expr;
    my $ecc_dc_data_wr_port_en_expr;

    if ($dc_ecc_present) {


        $ecc_dc_data_wr_port_addr_expr = 
          "A_dc_ecc_correct_the_data ? A_mem_baddr_line_offset_field :";
        $ecc_dc_data_wr_port_en_expr =
          "A_dc_ecc_correct_the_data | ";
    }

    e_assign->adds(









      [["dc_data_rd_port_line_field", $dc_addr_line_field_sz], 
        "M_en                     ? E_mem_baddr_line_field : 
         A_dc_xfer_rd_addr_active ? A_mem_baddr_line_field :
                                    M_mem_baddr_line_field"],










      [["dc_data_rd_port_offset_field", $dc_addr_offset_field_sz], 
        "M_en                      ? E_mem_baddr_offset_field : 
         A_dc_xfer_rd_addr_active  ? A_dc_xfer_rd_addr_offset :
                                     M_mem_baddr_offset_field"],
                                     

      [["dc_data_rd_port_addr", $dc_data_addr_sz], 
        "{dc_data_rd_port_line_field, dc_data_rd_port_offset_field}"],


      [["M_dc_rd_data", $dc_data_data_sz], "dc_data_rd_port_data"],










      [["M_dc_st_data", $dc_data_data_sz],
        "M_ctrl_dc_index_nowb_inv ? 32'b0 : " .
        ($dc_ecc_present ?
          "{ M_mem_byte_en[3] ? M_st_data[31:24] : M_dc_rd_data[31:24],
            M_mem_byte_en[2] ? M_st_data[23:16] : M_dc_rd_data[23:16],
            M_mem_byte_en[1] ? M_st_data[15:8]  : M_dc_rd_data[15:8],
            M_mem_byte_en[0] ? M_st_data[7:0]   : M_dc_rd_data[7:0] }" :
          "M_st_data"    
        )
      ],










      [["A_dc_data_st_wr_en", 1], "A_dc_valid_st_cache_hit & A_en_d1"],





      [["A_dc_data_dcache_management_wr_en", 1], "A_ctrl_dc_index_nowb_inv & A_valid & A_en_d1"],



      [["dc_data_wr_port_data", $dc_data_data_sz], 
        "A_dc_fill_active                  ? A_dc_fill_wr_data : 
                                             A_dc_st_data"],
      [["dc_data_wr_port_addr", $dc_data_addr_sz], 
        $ecc_dc_data_wr_port_addr_expr .
        "A_dc_fill_active                  ? { A_mem_baddr_line_field, A_dc_fill_dp_offset } : 
                                             A_mem_baddr_line_offset_field"],
      [["dc_data_wr_port_en", 1], 
        $ecc_dc_data_wr_port_en_expr .
        "(A_dc_fill_active ? d_readdatavalid_d1 : A_dc_data_st_wr_en) |
         A_dc_data_dcache_management_wr_en"],


      [["dc_data_wr_port_byte_en", $byte_en_sz, 0, $force_never_export], 
        "A_dc_fill_active               ? $byte_en_all_on : 
                                          A_mem_byte_en"],
    );

    my $dc_data_port_map = {
        clock      => "clk",
    


        rdaddress  => "dc_data_rd_port_addr",
        q          => "dc_data_rd_port_data",
   


        wren       => "dc_data_wr_port_en",
        data       => "dc_data_wr_port_data",
        wraddress  => "dc_data_wr_port_addr",
    };

    e_register->adds(
      {out => ["A_dc_st_data", $dc_data_data_sz],
       in => "M_dc_st_data", enable => "A_en"},
    );

    my @dc_data_ram_ecc_waves;

    if ($dc_ecc_present) {

        $dc_data_port_map->{corrected_data_to_encoder} = "dc_data_wr_port_corrected_data";
        $dc_data_port_map->{injs} = "dc_data_wr_port_injs";
        $dc_data_port_map->{injd} = "dc_data_wr_port_injd";
        $dc_data_port_map->{wrsel} = "dc_data_wr_port_wrsel";
        if ($ecc_test_ports_present) {
            my $dc_data_ecc_bits = calc_num_ecc_bits($dc_data_data_sz);
            my $dc_data_ecc_data_sz =  $dc_data_data_sz + $dc_data_ecc_bits;
            $dc_data_port_map->{test_invert} = "ecc_test_dc_data[$dc_data_ecc_data_sz-1:0]";
        }


        $dc_data_port_map->{corrected_data_from_decoder} = "dc_data_rd_port_corrected_data";
        $dc_data_port_map->{one_bit_err} = "dc_data_rd_port_one_bit_err";
        $dc_data_port_map->{two_bit_err} = "dc_data_rd_port_two_bit_err";
        $dc_data_port_map->{one_two_or_three_bit_err} = "dc_data_rd_port_any_ecc_err";

        push(@dc_data_ram_ecc_waves,
          { radix => "x", signal => "dc_data_wr_port_corrected_data" },
          { radix => "x", signal => "dc_data_wr_port_injs" },
          { radix => "x", signal => "dc_data_wr_port_injd" },
          { radix => "x", signal => "dc_data_wr_port_wrsel" },
          { radix => "x", signal => "dc_data_rd_port_corrected_data" },
          { radix => "x", signal => "dc_data_rd_port_one_bit_err" },
          { radix => "x", signal => "dc_data_rd_port_two_bit_err" },
          { radix => "x", signal => "dc_data_rd_port_any_ecc_err" },
        );

        push(@dc_ecc_waves,
            { radix => "x", signal => "W_dc_data_injs" },
            { radix => "x", signal => "W_dc_data_injd" },
            { radix => "x", signal => "M_dc_data_raw_recoverable_flush_ecc_err" },
            { radix => "x", signal => "M_dc_data_raw_recoverable_correct_ecc_err" },
            { radix => "x", signal => "M_dc_data_raw_unrecoverable_ecc_err" },
            { radix => "x", signal => "M_dc_data_raw_any_ecc_err" },
        );

        e_assign->adds(

          [["dc_data_wr_port_injs", 1], "W_dc_data_injs"],
          [["dc_data_wr_port_injd", 1], "W_dc_data_injd"],
































          [["M_dc_data_raw_recoverable_flush_ecc_err", 1], 
             "M_ctrl_mem_dc_data_rd & ~M_dc_tag_raw_any_ecc_err & M_dc_valid &
               ~M_dc_dirty & dc_data_rd_port_any_ecc_err"],

          [["M_dc_data_raw_recoverable_correct_ecc_err", 1], 
             "M_ctrl_mem_dc_data_rd & ~M_dc_tag_raw_any_ecc_err & M_dc_valid &
               M_dc_dirty & dc_data_rd_port_one_bit_err"],

          [["M_dc_data_raw_unrecoverable_ecc_err", 1], 
             "M_ctrl_mem_dc_data_rd & ~M_dc_tag_raw_any_ecc_err & M_dc_valid &
               & M_dc_dirty & dc_data_rd_port_two_bit_err"],




          [["M_dc_data_raw_any_ecc_err", 1],
             "dc_data_rd_port_any_ecc_err & M_ctrl_mem_dc_data_rd"],



          [["dc_data_wr_port_wrsel", 1], "A_dc_ecc_correct_the_data"],


          [["M_dc_data_corrected_data", $dc_data_data_sz], "dc_data_rd_port_corrected_data"],
          [["dc_data_wr_port_corrected_data", $dc_data_data_sz], "A_dc_data_corrected_data"],
        );

        e_register->adds(

          {out => ["A_dc_data_ecc_event_recoverable_err", 1], 
           in => "(M_dc_data_raw_recoverable_flush_ecc_err | " .
             "M_dc_data_raw_recoverable_correct_ecc_err) & M_valid",
           enable => "A_en"},
          {out => ["A_dc_data_raw_unrecoverable_ecc_err", 1], 
           in => "M_dc_data_raw_unrecoverable_ecc_err & M_valid", 
           enable => "A_en"},


          {out => ["A_dc_data_corrected_data", $dc_data_data_sz], 
           in => "M_dc_data_corrected_data", enable => "A_en"},
        );

        if ($ecc_test_ports_present) {
            e_register->adds(
              {out => ["ecc_test_dc_data_valid_d1", 1],    
               in => "ecc_test_dc_data_valid & dc_data_wr_port_en",
               enable => "1'b1"},
            );
            e_assign->adds(
              [["ecc_test_dc_data_ready", 1], 
                "~ecc_test_dc_data_valid | ecc_test_dc_data_valid_d1"],
           );
       }
    } else {

        $dc_data_port_map->{byteenable} = "dc_data_wr_port_byte_en";
    }



    if (manditory_bool($Opt, "export_large_RAMs")) {
        e_comment->add({
          comment => 
            ("Export D cache data RAM ports to top level\n" .
             "because the RAM is instantiated external to CPU.\n"),
        });
        e_assign->adds(

          [["dcache_g4b_data_ram_write_data", $dc_data_data_sz], 
            "dc_data_wr_port_data"],
          [["dcache_g4b_data_ram_write_enable",  1],
            "dc_data_wr_port_en"],
          [["dcache_g4b_data_ram_write_address", $dc_data_addr_sz],
            "dc_data_wr_port_addr"],
          [["dcache_g4b_data_ram_read_clk_en", 1], "1'b1"],
          [["dcache_g4b_data_ram_read_address", $dc_data_addr_sz], 
            "dc_data_rd_port_addr"],

          [["dcache_g4b_data_ram_byte_enable",  $byte_en_sz],
            "dc_data_wr_port_byte_en"],


          ["dc_data_rd_port_data", 
            ["dcache_g4b_data_ram_read_data", $dc_data_data_sz]],
        );
    } else {
        nios_sdp_ram->add({
          name => $Opt->{name} . "_dc_data",
          Opt                     => $Opt,
          data_width              => $dc_data_data_sz,
          address_width           => $dc_data_addr_sz,
          num_words               => $dc_data_num_addrs,
          read_during_write_mode_mixed_ports => qq("DONT_CARE"),
          ram_block_type          => '"' . $dcache_data_ram_block_type . '"',
          ecc_present             => $dc_ecc_present,
          verification            => $ecc_test_ports_present,
          port_map                => $dc_data_port_map, 
        });
    }











































    e_assign->adds(








      [["M_dc_want_fill", 1], "M_ctrl_ld_st_cache & M_valid & ~M_dc_hit "], 




      [["A_dc_fill_starting", 1], 
        "A_dc_want_fill & ~A_cancel & ~A_dc_fill_has_started & ~A_dc_wb_active"],
      


      [["A_dc_fill_has_started_nxt", 1], 
        "A_en ? 1'b0 : (A_dc_fill_starting | A_dc_fill_has_started)"],





      [["A_dc_fill_need_extra_stall_nxt", 1],
        "M_ctrl_ld_stnon32_cache & M_valid & M_A_dc_tag_line_addr_match & 
         (M_mem_baddr_offset_field == $dc_max_addr_offset)"],



      [["A_dc_fill_done", 1], 
         "A_dc_fill_need_extra_stall ? A_dc_rd_last_transfer_d1 : A_dc_rd_last_transfer"],


      [["A_dc_fill_active_nxt", 1], "A_dc_fill_active ? ~A_dc_fill_done : A_dc_fill_starting"],


      [["A_dc_fill_want_dmaster", 1], "A_dc_fill_starting | A_dc_fill_active"],




      [["A_dc_fill_dp_offset_nxt", $dc_addr_offset_field_sz], 
        "A_dc_fill_starting ? 0 : (A_dc_fill_dp_offset + 1)"],
      [["A_dc_fill_dp_offset_en", 1], "A_dc_fill_starting | d_readdatavalid_d1"],



      [["A_dc_fill_miss_offset_is_next", 1],
        "A_dc_fill_active & (A_dc_fill_dp_offset == A_mem_baddr_offset_field)"],




      [["A_dc_fill_wr_data", $dc_data_data_sz], 
        "(A_ctrl_st & A_st_writes_mem & A_dc_fill_miss_offset_is_next) ?
           A_dc_fill_st_data_merged : 
           d_readdata_d1"],


      [["A_dc_fill_st_data_merged", $dc_data_data_sz, 0, $force_never_export], 
        "{ A_mem_byte_en[3] ? A_st_data[31:24] : d_readdata_d1[31:24],
           A_mem_byte_en[2] ? A_st_data[23:16] : d_readdata_d1[23:16],
           A_mem_byte_en[1] ? A_st_data[15:8]  : d_readdata_d1[15:8],
           A_mem_byte_en[0] ? A_st_data[7:0]   : d_readdata_d1[7:0] }"],
    );

    e_register->adds(
      {out => ["A_dc_want_fill", 1],         
       in => "M_dc_want_fill",              enable => "A_en"},
      {out => ["A_dc_fill_has_started", 1],             
       in => "A_dc_fill_has_started_nxt",   enable => "1'b1"},
      {out => ["A_dc_fill_active", 1],             
       in => "A_dc_fill_active_nxt",        enable => "1'b1"},
      {out => ["A_dc_fill_dp_offset", $dc_addr_offset_field_sz], 
       in => "A_dc_fill_dp_offset_nxt",     enable => "A_dc_fill_dp_offset_en"},
      {out => ["A_dc_fill_starting_d1", 1],             
       in => "A_dc_fill_starting",          enable => "1'b1"},
      {out => ["A_dc_fill_need_extra_stall", 1],
       in => "A_dc_fill_need_extra_stall_nxt", enable => "1'b1"},
      {out => ["A_dc_rd_last_transfer_d1", 1],
       in => "A_dc_rd_last_transfer",           enable => "1'b1"},
    );





    e_assign->adds(



      [["A_dc_wb_active_nxt", 1], 
        "A_dc_wb_active ? ~A_dc_wr_last_transfer : A_dc_xfer_rd_addr_starting"],
    );

    e_register->adds(
      {out => ["A_dc_wb_active", 1],         
       in => "A_dc_wb_active_nxt",          enable => "1'b1"},
    );










    if ($victim_buf_ram) {

        e_signal->adds(
          {name => "A_dc_wb_rd_data", width => $dc_data_data_sz },
        );





        if (manditory_bool($Opt, "use_designware")) {

            e_comment->add({
              comment =>
                "DesignWare BCM58 part used for the eviction buffer\n",
            });
    
            my $victim_in_port_map = {
              addr_r   => 'A_dc_wb_rd_addr_offset',
              addr_w   => 'A_dc_xfer_wr_offset',
              clk_r    => 'clk',
              clk_w    => 'clk',
              data_w   => 'A_dc_xfer_wr_data',
              en_r_n   => '~A_dc_wb_rd_en',
              en_w_n   => '~A_dc_xfer_wr_active',
              init_r_n => qq(1'b1),
              init_w_n => qq(1'b1),
              rst_r_n  => 'reset_n',
              rst_w_n  => 'reset_n'
             };
    
            my $victim_out_port_map = {
              data_r       => 'A_dc_wb_rd_data',
              data_r_a     => ''
            };
    
            my $victim_parameter_map = {
              ADDR_WIDTH => $dc_addr_offset_field_sz,
              WIDTH      => $dc_data_data_sz,
              DEPTH      => $dc_words_per_line,
              MEM_MODE   => 2,
              RST_MODE   => 0
            };
    
            e_blind_instance->add({
             name                     => $Opt->{name} . "_dc_victim",
             module                   => 'DWC_n2p_bcm58',
             use_sim_models           => 1,
             in_port_map              => $victim_in_port_map,
             out_port_map             => $victim_out_port_map,
             parameter_map            => $victim_parameter_map
          });
    
       } else {
           e_assign->adds(

              [["dc_wb_wr_port_data", $dc_data_data_sz], "A_dc_xfer_wr_data"],
              [["dc_wb_wr_port_en", 1], "A_dc_xfer_wr_active"],
              [["dc_wb_wr_port_addr", $dc_addr_offset_field_sz], "A_dc_xfer_wr_offset"],          
              [["dc_wb_rd_port_en", 1], "A_dc_wb_rd_en"],
              [["dc_wb_rd_port_addr", $dc_addr_offset_field_sz], "A_dc_wb_rd_addr_offset"],







              [["A_dc_wb_rd_data", $dc_data_data_sz], 
                 $dc_ecc_present ? 
                    "dc_wb_port_one_bit_err ? dc_wb_port_corrected_data : dc_wb_rd_data" : 
                    "dc_wb_rd_data"],
           );
           my $dc_wb_port_map = {
               clock     => "clk",
       

               data      => "dc_wb_wr_port_data",
               wren      => "dc_wb_wr_port_en",
               wraddress => "dc_wb_wr_port_addr",
       

               rden      => "dc_wb_rd_port_en",
               rdaddress => "dc_wb_rd_port_addr",
               q         => "dc_wb_rd_data",
           };

           if ($dc_ecc_present) {

               $dc_wb_port_map->{corrected_data_to_encoder} = 
                 "dc_wb_port_corrected_data_to_encoder";
               $dc_wb_port_map->{injs} = "dc_wb_port_injs";
               $dc_wb_port_map->{injd} = "dc_wb_port_injd";
               $dc_wb_port_map->{wrsel} = "dc_wb_port_wrsel";
               if ($ecc_test_ports_present) {
                   my $dc_wb_ecc_bits = calc_num_ecc_bits($dc_data_data_sz);
                   my $dc_wb_ecc_data_sz =  $dc_data_data_sz + $dc_wb_ecc_bits;
                   $dc_wb_port_map->{test_invert} = "ecc_test_dc_wb[$dc_wb_ecc_data_sz-1:0]";
               }
               

               $dc_wb_port_map->{corrected_data_from_decoder} = "dc_wb_port_corrected_data";
               $dc_wb_port_map->{one_bit_err} = "dc_wb_port_one_bit_err";
               $dc_wb_port_map->{two_bit_err} = "dc_wb_port_two_bit_err";
               $dc_wb_port_map->{one_two_or_three_bit_err} = "dc_wb_port_any_ecc_err";

               e_assign->adds(

                [["dc_wb_port_injs", 1], "W_dc_wb_injs"],
                [["dc_wb_port_injd", 1], "W_dc_wb_injd"],
                

                [["dc_wb_port_wrsel", 1], "1'b0"],
                [["dc_wb_port_corrected_data_to_encoder", $dc_data_data_sz], 
                  "{${dc_data_data_sz}{1'b0}}"],
               );


               e_signal->adds(
                 { name => "dc_wb_port_any_ecc_err", width => 1, never_export => 1 },
                 { name => "dc_wb_rd_data", width => $dc_data_data_sz, never_export => 1 },
               );
               


               e_register->adds(
                 {out => ["A_dc_wb_rd_data_active", 1],             
                  in => "A_dc_wb_rd_en",            enable => "1'b1"},
               );
               
               if ($ecc_test_ports_present) {
                   e_register->adds(
                      {out => ["ecc_test_dc_wb_valid_d1", 1], 
                       in => "ecc_test_dc_wb_valid & A_dc_xfer_wr_active",
                       enable => "1'b1"},
                   );
                   e_assign->adds(
                       [["ecc_test_dc_wb_ready", 1], 
                         "~ecc_test_dc_wb_valid | ecc_test_dc_wb_valid_d1"],
                   );
                }
           }






           nios_sdp_ram->add({
             name => $Opt->{name} . "_dc_victim",
             Opt                     => $Opt,
             data_width              => $dc_data_data_sz,
             address_width           => $dc_addr_offset_field_sz,
             num_words               => $dc_words_per_line,
             read_during_write_mode_mixed_ports => qq("OLD_DATA"),
             ram_block_type          => '"' . $dcache_tag_ram_block_type . '"',
             ecc_present             => $dc_ecc_present,
             verification            => $ecc_test_ports_present,
             port_map                => $dc_wb_port_map,
           });
        }
    } elsif ($victim_buf_reg) {

















        e_assign->adds(

          [["A_dc_wb_rd_data", $dc_data_data_sz ], "dc_victim_0"],
        );

        for (my $w = 0; $w < $dc_words_per_line; $w++) {
            my $wp1 = $w + 1;
            my $last_entry = ($wp1 == $dc_words_per_line);

            e_register->adds(

              {out => ["dc_victim_$w", $dc_data_data_sz],         
               in => "dc_victim_${w}_nxt", enable => "dc_victim_${w}_wr_en"},
            );

            e_assign->adds(


              [["dc_victim_${w}_load_dc_data", 1], 
                "A_dc_xfer_wr_active & (A_dc_xfer_wr_offset_nxt == $w)"],




              [["dc_victim_${w}_wr_en", 1], "dc_victim_${w}_load_dc_data | A_dc_wb_rd_en"],





              [["dc_victim_${w}_nxt", $dc_data_data_sz], 
                $last_entry ?
                  "A_dc_xfer_wr_data" :
                  "dc_victim_${w}_load_dc_data ? A_dc_xfer_wr_data : dc_victim_${wp1}"],
            );
        }
    } else {
        &$error("Unknown data cache victim buffer implementation");
    }









































    e_assign->adds(

      [["A_dc_fill_want_xfer", 1],   "A_dc_want_fill & A_valid & A_dc_dirty"],
      [["A_dc_index_wb_inv_want_xfer", 1],
        "A_ctrl_dc_index_wb_inv & A_valid & A_dc_dirty"],
      [["A_dc_dc_addr_wb_inv_want_xfer", 1],
        "A_ctrl_dc_addr_wb_inv & A_valid & A_dc_dirty & A_dc_hit"],


      [["A_dc_want_xfer", 1], 
        "A_dc_fill_want_xfer | A_dc_index_wb_inv_want_xfer | A_dc_dc_addr_wb_inv_want_xfer"],




      [["A_dc_xfer_rd_addr_starting", 1], 
        "A_dc_want_xfer & ~A_dc_xfer_rd_addr_has_started & ~A_dc_wb_active"],



      [["A_dc_xfer_rd_addr_has_started_nxt", 1], 
         "A_en ? 1'b0 : (A_dc_xfer_rd_addr_starting | A_dc_xfer_rd_addr_has_started)"],





      [["A_dc_xfer_rd_addr_done_nxt", 1], 
        "A_dc_xfer_rd_addr_active & (A_dc_xfer_rd_addr_offset == ($dc_max_addr_offset - 1))"],



      [["A_dc_xfer_rd_addr_active_nxt", 1], 
        "A_dc_xfer_rd_addr_active ? ~A_dc_xfer_rd_addr_done : A_dc_xfer_rd_addr_starting"],




      [["A_dc_xfer_rd_addr_offset_nxt", $dc_addr_offset_field_sz], 
        "A_dc_xfer_rd_addr_starting ? 0 : (A_dc_xfer_rd_addr_offset + 1)"],




      [["A_dc_xfer_wr_offset_starting", 1],
        $victim_buf_ram ? "A_dc_xfer_wr_starting" : "A_dc_wb_rd_data_starting"],




      [["A_dc_xfer_wr_offset_nxt", $dc_addr_offset_field_sz], 
         "A_dc_xfer_wr_offset_starting          ? 0 : " .
         ($victim_buf_reg ? "A_dc_wb_rd_en ? A_dc_xfer_wr_offset : " : "") .
         "(A_dc_xfer_wr_offset + 1)"],








      [["A_dc_xfer_wr_data_nxt", $datapath_sz],
         $dc_ecc_present ? 
           "dc_data_rd_port_one_bit_err ? dc_data_rd_port_corrected_data : dc_data_rd_port_data" :
           "dc_data_rd_port_data"],
    );

    e_register->adds(
      {out => ["A_dc_xfer_rd_addr_has_started", 1],             
       in => "A_dc_xfer_rd_addr_has_started_nxt",   enable => "1'b1"},


      {out => ["A_dc_xfer_rd_addr_active", 1],             
       in => "A_dc_xfer_rd_addr_active_nxt",        enable => "1'b1"},
      {out => ["A_dc_xfer_rd_addr_done", 1],             
       in => "A_dc_xfer_rd_addr_done_nxt",          enable => "1'b1"},
      {out => ["A_dc_xfer_rd_addr_offset", $dc_addr_offset_field_sz], 
       in => "A_dc_xfer_rd_addr_offset_nxt",        enable => "1'b1"},




      {out => ["A_dc_xfer_rd_data_starting", 1],             
       in => "A_dc_xfer_rd_addr_starting",          enable => "1'b1"},
      {out => ["A_dc_xfer_rd_data_active", 1],             
       in => "A_dc_xfer_rd_addr_active",            enable => "1'b1"},








      {out => ["A_dc_xfer_wr_starting", 1],
       in => "A_dc_xfer_rd_data_starting",          enable => "1'b1"},
      {out => ["A_dc_xfer_wr_active", 1],             
       in => "A_dc_xfer_rd_data_active",            enable => "1'b1"},
      {out => ["A_dc_xfer_wr_offset", $dc_addr_offset_field_sz], 
       in => "A_dc_xfer_wr_offset_nxt",             enable => "1'b1"},
      {out => ["A_dc_xfer_wr_data", $datapath_sz],
       in => "A_dc_xfer_wr_data_nxt",               enable => "1'b1"},

      {out => ["A_dc_actual_tag", $dc_addr_tag_field_sz], 
       in => "M_dc_actual_tag",                     enable => "A_en"},


      {out => ["A_dc_wb_tag", $dc_addr_tag_field_sz], 
       in => "A_dc_actual_tag",                     
       enable => "A_dc_xfer_rd_data_starting"},
      {out => ["A_dc_wb_line", $dc_addr_line_field_sz], 
       in => "A_mem_baddr_line_field",                     
       enable => "A_dc_xfer_rd_data_starting"},
    );













































    e_assign->adds(















      [["A_dc_wb_rd_en", 1], 
        $victim_buf_ram ? 
          "A_dc_wb_rd_addr_starting | A_dc_wb_rd_data_starting | A_dc_wb_wr_starting | 
             av_wr_data_transfer" :
          "A_dc_wb_update_av_writedata"], 




      [["A_dc_wb_wr_starting", 1], "A_dc_wb_rd_data_first & ~d_read"],



      [["A_dc_wb_wr_active_nxt", 1], 
        "A_dc_wb_wr_active ? ~A_dc_wr_last_transfer : A_dc_wb_wr_starting"],


      [["A_dc_wb_wr_want_dmaster", 1], "A_dc_wb_wr_starting | A_dc_wb_wr_active"],




      [["A_dc_wb_rd_data_first_nxt", 1],
        "A_dc_wb_rd_data_first ? ~A_dc_wb_wr_starting : A_dc_wb_rd_data_starting"],





      [["A_dc_wb_update_av_writedata", 1], 
        "A_dc_wb_wr_starting | 
         (A_dc_wb_wr_active & ~A_dc_wr_last_driven & ~d_waitrequest)"],
    );

    if ($victim_buf_ram) {
        e_assign->adds(



          [["A_dc_wb_rd_addr_offset_nxt", $dc_addr_offset_field_sz], 
            "A_dc_wb_rd_addr_starting ? 0 : (A_dc_wb_rd_addr_offset + 1)"],
        );

        e_register->adds(



          {out => ["A_dc_wb_rd_addr_starting", 1],             
           in => "A_dc_xfer_wr_starting",               enable => "1'b1"},


          {out => ["A_dc_wb_rd_addr_offset", $dc_addr_offset_field_sz], 
           in => "A_dc_wb_rd_addr_offset_nxt",          enable => "A_dc_wb_rd_en"},

        );
    }

    e_register->adds(



      {out => ["A_dc_wb_rd_data_starting", 1],             
       in => $victim_buf_ram ? "A_dc_wb_rd_addr_starting" : "A_dc_xfer_wr_starting",
       enable => "1'b1"},



      {out => ["A_dc_wb_wr_active", 1],             
       in => "A_dc_wb_wr_active_nxt",               enable => "1'b1"},
      {out => ["A_dc_wb_rd_data_first", 1],             
       in => "A_dc_wb_rd_data_first_nxt",           enable => "1'b1"},
    );











    e_assign->adds(




      [["A_dc_index_wb_inv_done_nxt", 1], "~A_dc_dirty | A_dc_xfer_rd_addr_done"],






      [["A_dc_dc_addr_wb_inv_done_nxt", 1], "~A_dc_dirty | A_dc_xfer_rd_addr_done | ~A_dc_hit"],





      [["A_dc_dcache_management_done_nxt", 1],
        "A_valid & ~A_en &
            (A_ctrl_dc_nowb_inv |
            (A_ctrl_dc_index_wb_inv & A_dc_index_wb_inv_done_nxt) |
            ((A_ctrl_dc_addr_wb_inv ) & A_dc_dc_addr_wb_inv_done_nxt))"],
    );

    e_register->adds(
      {out => ["A_dc_dcache_management_done", 1],             
       in => "A_dc_dcache_management_done_nxt",  enable => "1'b1"},
    );







    e_assign->adds(









      [["M_dc_bypass_or_dcache_management", 1], 
        "M_ctrl_ld_st_bypass_or_dcache_management & M_valid"],





      [["A_ld_bypass_done", 1], "A_dc_rd_last_transfer"],





      [["A_st_bypass_done", 1], "A_dc_wr_last_transfer & ~A_dc_wb_active"],




      [["A_mem_bypass_pending", 1], "A_ctrl_ld_st_bypass & A_valid & ~A_en"],
    );

    e_register->adds(






      {out => ["A_ld_bypass_delayed", 1],             
       in => "M_ctrl_ld_bypass & M_valid & A_dc_wb_active",
       enable => "A_en"},
      {out => ["A_st_bypass_delayed", 1],             
       in => "M_ctrl_st_bypass & M_valid & A_dc_wb_active",
       enable => "A_en"},



      {out => ["A_ld_bypass_delayed_started", 1],             
       in => "A_en ? 0 : 
         ((A_ld_bypass_delayed & ~A_dc_wb_active) | 
           A_ld_bypass_delayed_started)",
       enable => "1'b1"},
      {out => ["A_st_bypass_delayed_started", 1],             
       in => "A_en ? 0 : 
         ((A_st_bypass_delayed & ~A_dc_wb_active) | 
           A_st_bypass_delayed_started)",
       enable => "1'b1"},
    );











    my @stall_start = (
      "M_dc_want_fill",
      "M_dc_bypass_or_dcache_management",
    );

    if ($dc_ecc_present) {









        push(@stall_start, "M_dc_ecc_A_refetch_required");
    }







    my @stall_stop = (
      "(A_dc_fill_active & A_dc_fill_done)",
      "A_dc_dcache_management_done",
      "(A_ctrl_ld_bypass & A_ld_bypass_done)",
      "(A_ctrl_st_bypass & A_st_bypass_done)",
    );

    if ($dc_ecc_present) {




        push(@stall_stop, "A_dc_ecc_A_refetch_required");
    }

    if ($dc_ecc_present) {
        e_assign->adds(






          [["M_dc_ecc_correct_the_tag", 1], 
            "W_config_reg_eccen & M_valid & M_dc_tag_raw_recoverable_ecc_err"],







          [["M_dc_ecc_flush_the_tag", 1], 
            "W_config_reg_eccen & M_valid & M_dc_data_raw_recoverable_flush_ecc_err"],







          [["M_dc_ecc_correct_the_data", 1], 
            "W_config_reg_eccen & M_valid & M_dc_data_raw_recoverable_correct_ecc_err"],





























          [["M_dc_ecc_A_refetch_required", 1],
            "W_config_reg_eccen & M_valid & ~pending_dc_unrecoverable_ecc_err &
               (M_dc_tag_raw_any_ecc_err | (M_dc_valid & M_dc_data_raw_any_ecc_err))"],
















          [["M_dc_unrecoverable_ecc_err", 1],
            "W_config_reg_eccen & M_valid & ~pending_dc_unrecoverable_ecc_err & 
              (M_dc_tag_raw_unrecoverable_ecc_err | M_dc_data_raw_unrecoverable_ecc_err)"],
        );

        e_register->adds(







          {out => ["pending_dc_unrecoverable_ecc_err", 1],  
           in => "pending_dc_unrecoverable_ecc_err ?
              ~(M_valid_from_E & ~A_pipe_flush) :
              W_dc_unrecoverable_ecc_err",
           enable => "1'b1"},


          {out => ["A_dc_ecc_A_refetch_required", 1],  
           in => "M_dc_ecc_A_refetch_required", enable => "A_en"},
          {out => ["A_dc_ecc_correct_the_tag", 1], 
           in => "M_dc_ecc_correct_the_tag", enable => "A_en"},
          {out => ["A_dc_ecc_flush_the_tag", 1], 
           in => "M_dc_ecc_flush_the_tag", enable => "A_en"},
          {out => ["A_dc_ecc_correct_the_data", 1], 
           in => "M_dc_ecc_correct_the_data", enable => "A_en"},
          {out => ["A_dc_unrecoverable_ecc_err", 1],  
           in => "M_dc_unrecoverable_ecc_err", enable => "A_en"},


          {out => ["W_dc_unrecoverable_ecc_err", 1],  
           in => "A_dc_unrecoverable_ecc_err", enable => "1'b1"},
        );
    }

    e_assign->adds(











      [["d_address_tag_field_nxt", $dc_addr_tag_field_sz],
        "A_dc_wb_wr_want_dmaster                         ? A_dc_wb_tag : 
         (A_dc_fill_want_dmaster | A_mem_bypass_pending) ? A_dc_desired_tag :
                                                           M_dc_desired_tag"],


      [["d_address_line_field_nxt", $dc_addr_line_field_sz],
        "A_dc_wb_wr_want_dmaster                         ? 
            A_dc_wb_line : 
         (A_dc_fill_want_dmaster | A_mem_bypass_pending) ? 
            A_mem_baddr_line_field :
            M_mem_baddr_line_field"],


      [["d_address_byte_field_nxt", $dc_addr_byte_field_sz],
        "(A_dc_wb_wr_want_dmaster | A_dc_fill_want_dmaster) ? 0 : 
         A_mem_bypass_pending                      ? A_mem_baddr_byte_field :
                                                     M_mem_baddr_byte_field"],


      [["d_byteenable_nxt", $byte_en_sz], 
        "(A_dc_wb_wr_want_dmaster | A_dc_fill_want_dmaster) ? $byte_en_all_on : 
         A_mem_bypass_pending                               ? A_mem_byte_en :
                                                              M_mem_byte_en"],
 





      [["d_writedata_nxt", $datapath_sz], 
        "A_dc_wb_update_av_writedata                 ? A_dc_wb_rd_data : 
         A_dc_wb_wr_active                           ? d_writedata :
         A_mem_bypass_pending                        ? A_st_data :
                                                       M_st_data"],






      [["d_write_nxt", 1],
        "A_dc_wb_wr_starting |
         (M_ctrl_st_bypass & M_valid & A_en & ~A_dc_wb_active) | 
         (A_st_bypass_delayed & ~A_st_bypass_delayed_started & ~A_dc_wb_active & ~A_refetch_required) |
         (d_write & (d_waitrequest | ~A_dc_wr_last_driven))"],




      [["d_address", $data_master_addr_sz],     
        "{d_address_tag_field, 
          d_address_line_field[$dc_addr_line_field_paddr_sz-1:0],
          d_address_offset_field,
          d_address_byte_field}"],









      [["A_dc_rd_data_cnt_nxt", $line_word_cnt_sz], 
        "d_readdatavalid_d1 ? (A_dc_rd_data_cnt + 1) :
         A_dc_fill_starting ? 1 :
         A_dc_fill_active   ? A_dc_rd_data_cnt :
                              $line_word_cnt_max"],


      [["A_dc_rd_last_transfer", 1], "A_dc_rd_data_cnt[$line_word_cnt_sz-1] & d_readdatavalid_d1"],


      [["av_wr_data_transfer", 1], "d_write & ~d_waitrequest"],









      [["A_dc_wr_data_cnt_nxt", $line_word_cnt_sz], 
        "av_wr_data_transfer ? (A_dc_wr_data_cnt + 1) :
         A_dc_wb_wr_starting ? 1 :
         A_dc_wb_wr_active   ? A_dc_wr_data_cnt :
                               $line_word_cnt_max"],



      [["A_dc_wr_last_driven", 1], "A_dc_wr_data_cnt[$line_word_cnt_sz-1]"],


      [["A_dc_wr_last_transfer", 1], "A_dc_wr_last_driven & d_write & ~d_waitrequest"],
    );



    $perf_cnt_inc_rd_stall = "(d_read & A_mem_stall)";
    $perf_cnt_inc_wr_stall = "(d_write & A_mem_stall)";

    if ($dmaster_bursts) {



        e_assign->adds(

          [["d_burstcount_nxt", $dmaster_burstcount_sz],    
            "(A_dc_wb_wr_want_dmaster | A_dc_fill_want_dmaster) ? 
                                                     $dmaster_burstcount_max :
                                                     1"],



          [["d_address_offset_field_nxt", $dc_addr_offset_field_sz],
            "(A_dc_wb_wr_want_dmaster | A_dc_fill_want_dmaster) ? 0 : 
             A_mem_bypass_pending                  ? A_mem_baddr_offset_field :
                                                     M_mem_baddr_offset_field"],





          [["d_read_nxt", 1],
            "A_dc_fill_starting | 
             (M_ctrl_ld_bypass & M_valid & A_en & ~A_dc_wb_active) |
             (A_ld_bypass_delayed & ~A_ld_bypass_delayed_started & ~A_dc_wb_active & ~A_refetch_required) |
             (d_read & d_waitrequest)"],
        );

        e_register->adds(
          {out => ["d_burstcount", $dmaster_burstcount_sz],    
           in => "d_burstcount_nxt",                enable => "1'b1"},
        );
    } else {


        e_assign->adds(

          [["av_addr_accepted", 1], "(d_read | d_write) & ~d_waitrequest"],




          [["d_address_offset_field_nxt", $dc_addr_offset_field_sz],
            "av_addr_accepted ? (d_address_offset_field + 1) :
             (A_dc_wb_wr_starting | A_dc_fill_starting) ? 0 :
             (A_dc_wb_wr_active | A_dc_fill_active) ? d_address_offset_field :
              A_mem_bypass_pending                ? A_mem_baddr_offset_field :
                                                    M_mem_baddr_offset_field"],






          [["d_read_nxt", 1],
            "A_dc_fill_starting |
             (M_ctrl_ld_bypass & M_valid & A_en & ~A_dc_wb_active) | 
             (A_ld_bypass_delayed & ~A_ld_bypass_delayed_started & 
              ~A_dc_wb_active) |
             (d_read & (d_waitrequest | ~A_dc_rd_last_driven))"],


          [["av_rd_addr_accepted", 1], "d_read & ~d_waitrequest"],
    








          [["A_dc_rd_addr_cnt_nxt", $line_word_cnt_sz], 
            "av_rd_addr_accepted ? (A_dc_rd_addr_cnt + 1) :
             A_dc_fill_starting  ? 1 :
             A_dc_fill_active    ? A_dc_rd_addr_cnt :
                                   $line_word_cnt_max"],
    


          [["A_dc_rd_last_driven", 1], 
            "A_dc_rd_addr_cnt[$line_word_cnt_sz-1]"],
        );

        e_register->adds(
          {out => ["A_dc_rd_addr_cnt", $line_word_cnt_sz],         
           in => "A_dc_rd_addr_cnt_nxt",            enable => "1'b1"},
        );
    }

    e_register->adds(
      {out => ["d_address_tag_field", $dc_addr_tag_field_sz],  
       in => "d_address_tag_field_nxt",         enable => "1'b1"},
      {out => ["d_address_line_field", $dc_addr_line_field_sz],  
       in => "d_address_line_field_nxt",        enable => "1'b1"},
      {out => ["d_address_offset_field", $dc_addr_offset_field_sz],  
       in => "d_address_offset_field_nxt",      enable => "1'b1"},
      {out => ["d_address_byte_field", $dc_addr_byte_field_sz],  
       in => "d_address_byte_field_nxt",        enable => "1'b1"},
      {out => ["d_byteenable", $byte_en_sz],    
       in => "d_byteenable_nxt",                enable => "1'b1"},
      {out => ["d_writedata", $datapath_sz],    
       in => "d_writedata_nxt",                 enable => "1'b1"},

      {out => ["A_dc_rd_data_cnt", $line_word_cnt_sz], 
       in => "A_dc_rd_data_cnt_nxt",            enable => "1'b1"},
      {out => ["A_dc_wr_data_cnt", $line_word_cnt_sz], 
       in => "A_dc_wr_data_cnt_nxt",            enable => "1'b1"},
    );

    my @waves;

    push(@waves, 
        { divider => "dcache_addr_fields" },
        { radix => "x", signal => "E_mem_baddr_line_field" },
        { radix => "x", signal => "E_mem_baddr_offset_field" },
        { radix => "x", signal => "M_mem_baddr_line_field" },
        { radix => "x", signal => "M_mem_baddr_offset_field" },
        { radix => "x", signal => "A_mem_baddr_line_field" },
        { radix => "x", signal => "A_mem_baddr_offset_field" },
        { divider => "dcache_tag_ram" },
        { radix => "x", signal => "A_dc_tag_st_wr_en" },
        { radix => "x", signal => "A_dc_tag_dcache_management_wr_en" },
        { radix => "x", signal => "dc_tag_rd_port_addr" },
        { radix => "x", signal => "dc_tag_rd_port_data" },
        { radix => "x", signal => "dc_tag_wr_port_en" },
        { radix => "x", signal => "dc_tag_wr_port_data" },
        { radix => "x", signal => "dc_tag_wr_port_addr" },
        @dc_tag_ram_ecc_waves,
        { radix => "x", signal => "M_dc_dirty_raw" },
        { radix => "x", signal => "M_dc_dirty" },
        { radix => "x", signal => "M_dc_valid" },
        { radix => "x", signal => "M_dc_actual_tag" },
        { radix => "x", signal => "A_dc_fill_active" },
        { radix => "x", signal => "M_dc_desired_tag" },
        { radix => "x", signal => "M_dc_tag_match" },
        { radix => "x", signal => "A_dc_desired_tag" },
        { radix => "x", signal => "M_dc_hit" },
        { divider => "dcache_data_ram" },
        { radix => "x", signal => "A_dc_data_st_wr_en" },
        { radix => "x", signal => "A_dc_fill_active" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_active" },
        { radix => "x", signal => "A_dc_data_dcache_management_wr_en" },
        { radix => "x", signal => "dc_data_rd_port_addr" },
        { radix => "x", signal => "dc_data_rd_port_data" },
        { radix => "x", signal => "dc_data_wr_port_en" },
        { radix => "x", signal => "dc_data_wr_port_data" },
        { radix => "x", signal => "dc_data_wr_port_addr" },
        @dc_data_ram_ecc_waves,
        { radix => "x", signal => "M_A_dc_tag_ram_addr_match" },
        { radix => "x", signal => "A_dc_valid_st_cache_hit" },
        @dc_ecc_waves,
        { divider => "dcache_fill" },
        { radix => "x", signal => "M_dc_want_fill" },
        { radix => "x", signal => "A_dc_fill_starting" },
        { radix => "x", signal => "A_dc_fill_has_started_nxt" },
        { radix => "x", signal => "A_dc_fill_need_extra_stall" },
        { radix => "x", signal => "A_dc_fill_done" },
        { radix => "x", signal => "A_dc_fill_active_nxt" },
        { radix => "x", signal => "A_dc_fill_dp_offset_nxt" },
        { radix => "x", signal => "A_dc_fill_dp_offset_en" },
        { radix => "x", signal => "A_dc_fill_miss_offset_is_next" },
        { radix => "x", signal => "A_dc_fill_wr_data" },
        { radix => "x", signal => "A_dc_want_fill" },
        { radix => "x", signal => "A_dc_fill_has_started" },
        { radix => "x", signal => "A_dc_fill_active" },
        { radix => "x", signal => "A_dc_fill_want_dmaster" },
        { radix => "x", signal => "A_dc_fill_dp_offset" },
        { radix => "x", signal => "A_dc_rd_last_transfer" },
        { radix => "x", signal => "A_dc_rd_last_transfer_d1" },
        { divider => "dcache_wb" },
        { radix => "x", signal => "A_dc_wb_active_nxt" },
        { radix => "x", signal => "A_dc_wb_active" },
        { divider => "dcache_victim_buffer" },
    );

    if ($victim_buf_reg) {
        for (my $w = 0; $w < $dc_words_per_line; $w++) {
            push(@waves, 
              { radix => "x", signal => "dc_victim_${w}_load_dc_data" },
              { radix => "x", signal => "dc_victim_${w}_wr_en" },
              { radix => "x", signal => "dc_victim_${w}_nxt" },
              { radix => "x", signal => "dc_victim_${w}" },
            );
        }
    }

    push(@waves, 
        { radix => "x", signal => "A_dc_xfer_wr_data" },
        { radix => "x", signal => "A_dc_xfer_wr_active" },
        { radix => "x", signal => "A_dc_xfer_wr_offset" },
        { radix => "x", signal => "A_dc_wb_rd_en" },
        $victim_buf_ram ?  { radix => "x", signal => "A_dc_wb_rd_addr_offset" } : "",
        { radix => "x", signal => "A_dc_wb_rd_data" },
        { divider => "dcache_victim_xfer" },
        { radix => "x", signal => "A_dc_fill_want_xfer" },
        { radix => "x", signal => "A_dc_index_wb_inv_want_xfer" },
        { radix => "x", signal => "A_dc_dc_addr_wb_inv_want_xfer" },
        { radix => "x", signal => "A_dc_want_xfer" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_starting" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_has_started_nxt" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_done" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_active_nxt" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_offset_nxt" },
        { radix => "x", signal => "A_dc_xfer_wr_data_nxt" },
        { radix => "x", signal => "A_dc_dirty" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_has_started" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_active" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_offset" },
        { radix => "x", signal => "A_dc_xfer_rd_data_starting" },
        { radix => "x", signal => "A_dc_xfer_rd_data_active" },
        { radix => "x", signal => "A_dc_xfer_wr_starting" },
        { radix => "x", signal => "A_dc_xfer_wr_active" },
        { radix => "x", signal => "A_dc_xfer_wr_data" },
        { radix => "x", signal => "A_dc_xfer_wr_offset" },
        { radix => "x", signal => "A_dc_xfer_wr_offset_starting" },
        { radix => "x", signal => "A_dc_wb_tag" },
        { radix => "x", signal => "A_dc_wb_line" },
        { divider => "dcache_wb" },
        { radix => "x", signal => "A_dc_wb_rd_en" },
        $victim_buf_ram ? { radix => "x", signal => "A_dc_wb_rd_addr_offset_nxt" } : "",
        { radix => "x", signal => "A_dc_wb_wr_starting" },
        { radix => "x", signal => "A_dc_wb_wr_active_nxt" },
        { radix => "x", signal => "A_dc_wb_rd_data_first_nxt" },
        { radix => "x", signal => "A_dc_wb_update_av_writedata" },
        $victim_buf_ram ? { radix => "x", signal => "A_dc_wb_rd_addr_starting" } : "",
        $victim_buf_ram ? { radix => "x", signal => "A_dc_wb_rd_addr_offset" } : "",
        { radix => "x", signal => "A_dc_wb_rd_data_starting" },
        { radix => "x", signal => "A_dc_wb_wr_active" },
        { radix => "x", signal => "A_dc_wb_wr_want_dmaster" },
        { radix => "x", signal => "A_dc_wb_rd_data_first" },
        { divider => "dcache_bypass" },
        { radix => "x", signal => "M_dc_bypass_or_dcache_management" },
        { radix => "x", signal => "A_ld_bypass_done" },
        { radix => "x", signal => "A_st_bypass_done" },
        { radix => "x", signal => "A_mem_bypass_pending" },
        { radix => "x", signal => "A_ld_bypass_delayed" },
        { radix => "x", signal => "A_st_bypass_delayed" },
        { radix => "x", signal => "A_ld_bypass_delayed_started" },
        { radix => "x", signal => "A_st_bypass_delayed_started" },
        { divider => "dcache_management" },
        { radix => "x", signal => "A_dc_hit" },
        { radix => "x", signal => "A_dc_dirty" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_active" },
        { radix => "x", signal => "A_dc_xfer_rd_addr_done" },
        { radix => "x", signal => "A_ctrl_dc_index_nowb_inv" },
        { radix => "x", signal => "A_ctrl_dc_addr_nowb_inv" },
        { radix => "x", signal => "A_ctrl_dc_index_wb_inv" },
        { radix => "x", signal => "A_ctrl_dc_addr_wb_inv" },
        { radix => "x", signal => "A_dc_index_wb_inv_done_nxt" },
        { radix => "x", signal => "A_dc_dc_addr_wb_inv_done_nxt" },
        { radix => "x", signal => "A_dc_dcache_management_done_nxt" },
        { radix => "x", signal => "A_dc_dcache_management_done" },
        { divider => "dcache_dmaster" },
        { radix => "x", signal => "d_address_tag_field_nxt" },
        { radix => "x", signal => "d_address_line_field_nxt" },
        { radix => "x", signal => "d_address_offset_field_nxt" },
        { radix => "x", signal => "d_address_byte_field_nxt" },
        { radix => "x", signal => "d_byteenable_nxt" },
        $dmaster_bursts ? { radix => "x", signal => "d_burstcount_nxt" } : "",
        { radix => "x", signal => "d_writedata_nxt" },
        { radix => "x", signal => "d_write_nxt" },
        { radix => "x", signal => "d_write" },
        { radix => "x", signal => "d_read_nxt" },
        { radix => "x", signal => "d_read" },
        { radix => "x", signal => "d_waitrequest" },
        { radix => "x", signal => "d_readdatavalid_d1" },
        { radix => "x", signal => "d_readdata_d1" },
        { radix => "x", signal => "d_address" },
        { radix => "x", signal => "M_dc_want_fill" },
        { radix => "x", signal => "M_dc_bypass_or_dcache_management" },
        { radix => "x", signal => "A_dc_fill_active" },
        { radix => "x", signal => "A_dc_fill_done" },
        { radix => "x", signal => "A_dc_dcache_management_done " },
        { radix => "x", signal => "A_dc_xfer_rd_addr_done" },
        { radix => "x", signal => "A_ctrl_ld_bypass" },
        { radix => "x", signal => "A_ld_bypass_done" },
        { radix => "x", signal => "A_ctrl_st_bypass" },
        { radix => "x", signal => "A_st_bypass_done" },
        { radix => "x", signal => "A_dc_rd_data_cnt_nxt" },
        { radix => "x", signal => "A_dc_rd_last_transfer" },
        { radix => "x", signal => "av_wr_data_transfer" },
        { radix => "x", signal => "A_dc_wr_data_cnt_nxt" },
        { radix => "x", signal => "A_dc_wr_last_driven" },
        { radix => "x", signal => "A_dc_wr_last_transfer" },
        { radix => "x", signal => "d_address_tag_field" },
        { radix => "x", signal => "d_address_line_field" },
        { radix => "x", signal => "d_address_offset_field" },
        { radix => "x", signal => "d_address_byte_field" },
        { radix => "x", signal => "d_byteenable" },
        $dmaster_bursts ? { radix => "x", signal => "d_burstcount" } : "",
        { radix => "x", signal => "d_writedata" },
        { radix => "x", signal => "A_dc_rd_data_cnt" },
        { radix => "x", signal => "A_dc_wr_data_cnt" },
        $dmaster_bursts ? "" : {radix => "x", signal => "av_rd_addr_accepted"},
        $dmaster_bursts ? "" : {radix => "x", signal => "A_dc_rd_addr_cnt_nxt"},
        $dmaster_bursts ? "" : {radix => "x", signal => "A_dc_rd_last_driven"},
        $dmaster_bursts ? "" : {radix => "x", signal => "A_dc_rd_addr_cnt"},
    );

    push(@plaintext_wave_signals, @waves);

    return {
        stall_start => \@stall_start,
        stall_stop  => \@stall_stop,
    };
}

1;
