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






















package nios2_insts;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    $a_inst_field
    $b_inst_field
    $c_inst_field
    $custom_n_inst_field
    $custom_readra_inst_field
    $custom_readrb_inst_field
    $custom_writerc_inst_field
    $opx_inst_field
    $op_inst_field
    $i12_x_inst_field
    $dcache_x_inst_field
    $imm5_inst_field
    $imm16_inst_field
    $imm26_inst_field
    $control_regnum_inst_field
    $imm12_inst_field
    $rsie_inst_field
    $bmx_msb_inst_field
    $bmx_lsb_inst_field
    $memsz_inst_field
    $i12_memsz_inst_field
    $f1x4l17_regmask_inst_field
    $f1x4l17_pc_inst_field
    $f1x4l17_rs_inst_field
    $f1x4l17_wb_inst_field
    $f1x4l17_id_inst_field
    $i10_imm10_inst_field
    $t1i7_imm7_inst_field
    $f1i5_imm5_inst_field
    $t2i4_imm4_inst_field
    $a3_inst_field
    $b3_inst_field
    $c3_inst_field
    $a5_inst_field
    $b5_inst_field
    $as_n_x_inst_field
    $x1i7_imm7_inst_field
    $spi_n_x_inst_field
    $stz_n_x_inst_field
    $l5i4x1_imm4_inst_field
    $l5i4x1_regrange_inst_field
    $l5i4x1_fp_inst_field
    $l5i4x1_cs_inst_field
    $pp_n_x_inst_field
    $t2x1l3_shamt_inst_field
    $shi_n_x_inst_field
    $t2x1i3_imm3_inst_field
    $asi_n_x_inst_field
    $x2l5_lit5_inst_field
    $r_n_x_inst_field
    $t1x1i6_imm6_inst_field

    $iw_a_sz $iw_a_lsb $iw_a_msb 
    $iw_b_sz $iw_b_lsb $iw_b_msb
    $iw_c_sz $iw_c_lsb $iw_c_msb 
    $iw_custom_n_sz $iw_custom_n_lsb $iw_custom_n_msb
    $iw_custom_readra_sz $iw_custom_readra_lsb $iw_custom_readra_msb
    $iw_custom_readrb_sz $iw_custom_readrb_lsb $iw_custom_readrb_msb
    $iw_custom_writerc_sz $iw_custom_writerc_lsb $iw_custom_writerc_msb
    $iw_opx_sz $iw_opx_lsb $iw_opx_msb
    $iw_op_sz $iw_op_lsb $iw_op_msb
    $iw_i12_x_sz $iw_i12_x_lsb $iw_i12_x_msb
    $iw_dcache_x_sz $iw_dcache_x_lsb $iw_dcache_x_msb
    $iw_imm5_sz $iw_imm5_lsb $iw_imm5_msb
    $iw_imm16_sz $iw_imm16_lsb $iw_imm16_msb
    $iw_imm26_sz $iw_imm26_lsb $iw_imm26_msb
    $iw_control_regnum_sz $iw_control_regnum_lsb $iw_control_regnum_msb 
    $iw_imm12_sz $iw_imm12_lsb $iw_imm12_msb
    $iw_rsie_sz $iw_rsie_lsb $iw_rsie_msb
    $iw_bmx_msb_sz $iw_bmx_msb_lsb $iw_bmx_msb_msb
    $iw_bmx_lsb_sz $iw_bmx_lsb_lsb $iw_bmx_lsb_msb
    $iw_memsz_sz $iw_memsz_lsb $iw_memsz_msb
    $iw_i12_memsz_sz $iw_i12_memsz_lsb $iw_i12_memsz_msb
    $iw_f1x4l17_regmask_sz $iw_f1x4l17_regmask_lsb $iw_f1x4l17_regmask_msb
    $iw_f1x4l17_pc_sz $iw_f1x4l17_pc_lsb $iw_f1x4l17_pc_msb
    $iw_f1x4l17_rs_sz $iw_f1x4l17_rs_lsb $iw_f1x4l17_rs_msb
    $iw_f1x4l17_wb_sz $iw_f1x4l17_wb_lsb $iw_f1x4l17_wb_msb
    $iw_f1x4l17_id_sz $iw_f1x4l17_id_lsb $iw_f1x4l17_id_msb
    
    $iw_stz_n_x_sz $iw_stz_n_x_lsb $iw_stz_n_x_msb
    $iw_spi_n_x_sz $iw_spi_n_x_lsb $iw_spi_n_x_msb
    $iw_pp_n_x_sz $iw_pp_n_x_lsb $iw_pp_n_x_msb
    $iw_as_n_x_sz $iw_as_n_x_lsb $iw_as_n_x_msb
    $iw_shi_n_x_sz $iw_shi_n_x_lsb $iw_shi_n_x_msb
    $iw_asi_n_x_sz $iw_asi_n_x_lsb $iw_asi_n_x_msb
    $iw_r_n_x_sz $iw_r_n_x_lsb $iw_r_n_x_msb
    $iw_i10_imm10_sz $iw_i10_imm10_lsb $iw_i10_imm10_msb
    $iw_t1i7_imm7_sz $iw_t1i7_imm7_lsb $iw_t1i7_imm7_msb
    $iw_f1i5_imm5_sz $iw_f1i5_imm5_lsb $iw_f1i5_imm5_msb
    $iw_t2i4_imm4_sz $iw_t2i4_imm4_lsb $iw_t2i4_imm4_msb
    $iw_t1x1i6_imm6_sz $iw_t1x1i6_imm6_lsb $iw_t1x1i6_imm6_msb
    $iw_a3_sz $iw_a3_lsb $iw_a3_msb
    $iw_b3_sz $iw_b3_lsb $iw_b3_msb
    $iw_c3_sz $iw_c3_lsb $iw_c3_msb
    $iw_a5_sz $iw_a5_lsb $iw_a5_msb
    $iw_b5_sz $iw_b5_lsb $iw_b5_msb
    $iw_x1i7_imm7_sz $iw_x1i7_imm7_lsb $iw_x1i7_imm7_msb
    $iw_l5i4x1_imm4_sz $iw_l5i4x1_imm4_lsb $iw_l5i4x1_imm4_msb
    $iw_l5i4x1_regrange_sz $iw_l5i4x1_regrange_lsb $iw_l5i4x1_regrange_msb
    $iw_l5i4x1_fp_sz $iw_l5i4x1_fp_lsb $iw_l5i4x1_fp_msb
    $iw_l5i4x1_cs_sz $iw_l5i4x1_cs_lsb $iw_l5i4x1_cs_msb
    $iw_t2x1l3_shamt_sz $iw_t2x1l3_shamt_lsb $iw_t2x1l3_shamt_msb
    $iw_t2x1i3_imm3_sz $iw_t2x1i3_imm3_lsb $iw_t2x1i3_imm3_msb
    $iw_x2l5_lit5_sz $iw_x2l5_lit5_lsb $iw_x2l5_lit5_msb
    
    $iw_memsz_byte $iw_memsz_hword $iw_memsz_word_msb
    $logic_op_sz $logic_op_lsb $logic_op_msb
    $logic_op_nor $logic_op_and $logic_op_or $logic_op_xor
    $compare_op_sz $compare_op_lsb $compare_op_msb
    $compare_op_eq $compare_op_ge $compare_op_lt $compare_op_ne
    $jmp_callr_vs_ret_opx_bit $jmp_callr_vs_ret_is_ret
    $empty_intr_iw $empty_hbreak_iw $empty_crst_iw $empty_nop_iw $empty_ret_iw

    $unimp_trap_ctrl
    $unimp_nop_ctrl
    $reserved_ctrl
    $illegal_ctrl
    $trap_inst_ctrl
    $custom_ctrl
    $custom_combo_ctrl
    $custom_multi_ctrl
    $supervisor_only_ctrl
    $ic_index_inv_ctrl
    $invalidate_i_ctrl
    $flush_pipe_ctrl
    $jmp_indirect_non_trap_ctrl
    $jmp_indirect_ctrl
    $jmp_indirect_word_aligned_ctrl
    $jmp_indirect_hword_aligned_ctrl
    $jmp_direct_ctrl
    $mul_lsw_ctrl
    $mulx_ctrl
    $mul_ctrl
    $div_unsigned_ctrl
    $div_signed_ctrl
    $div_ctrl
    $implicit_dst_retaddr_ctrl
    $implicit_dst_eretaddr_ctrl
    $intr_ctrl
    $exception_ctrl
    $break_ctrl
    $crst_ctrl
    $wr_ctl_reg_flush_ctrl
    $rd_ctl_reg_ctrl
    $uncond_cti_non_br_ctrl
    $retaddr_ctrl
    $shift_left_ctrl
    $shift_logical_ctrl
    $rot_left_ctrl
    $shift_rot_left_ctrl
    $shift_right_logical_ctrl
    $shift_right_arith_ctrl
    $shift_right_ctrl
    $rot_right_ctrl
    $shift_rot_right_ctrl
    $shift_rot_ctrl
    $shift_rot_imm_ctrl
    $rot_ctrl
    $bmx_ctrl
    $logic_reg_ctrl
    $logic_hi_imm16_ctrl
    $signed_imm12_ctrl
    $logic_lo_imm16_ctrl
    $logic_imm16_ctrl
    $logic_ctrl
    $hi_imm16_ctrl
    $unsigned_lo_imm16_ctrl
    $andc_ctrl
    $set_src2_rem_imm_ctrl
    $arith_imm16_ctrl
    $cmp_imm16_ctrl
    $jmpi_ctrl
    $cmp_imm16_with_call_jmpi_rdprs_ctrl
    $cmp_reg_ctrl
    $src_imm5_ctrl
    $src_imm5_shift_rot_ctrl
    $src_imm3_shift_rot_ctrl
    $cmp_with_lt_ctrl
    $cmp_with_eq_ctrl
    $cmp_with_ge_ctrl
    $cmp_with_ne_ctrl
    $cmp_alu_signed_ctrl
    $cmp_ctrl
    $br_with_lt_ctrl
    $br_with_ge_ctrl
    $br_with_eq_ctrl
    $br_with_ne_ctrl
    $br_alu_signed_ctrl
    $br_cond_ctrl
    $br_uncond_ctrl
    $br_always_pred_taken_ctrl
    $br_ctrl
    $alu_subtract_ctrl
    $a_is_sp_ctrl
    $dst_is_sp_ctrl
    $alu_signed_comparison_ctrl
    $br_cmp_ctrl
    $br_cmp_eq_ne_ctrl
    $ld8_ctrl
    $ld16_ctrl
    $ld8_ld16_ctrl
    $ld32_ctrl
    $ld_signed_ctrl
    $ld_unsigned_ctrl
    $ld_ctrl
    $ld_imm_ctrl
    $ld_ex_ctrl
    $multiple_loads_ctrl
    $multiple_stores_ctrl
    $multiple_loads_stores_ctrl
    $dcache_management_nop_ctrl
    $dcache_management_only_ctrl
    $ld_dcache_management_ctrl
    $ld_non_io_ctrl
    $st8_ctrl
    $st16_ctrl
    $st_non32_ctrl
    $st32_ctrl
    $st_ex_ctrl
    $st_ctrl
    $st_imm_ctrl
    $st_ignore_dst_ctrl
    $st_non_io_ctrl
    $ld_st_ctrl
    $ld_st_io_ctrl
    $ld_st_non_io_ctrl
    $ld_st_non_io_non_st32_ctrl
    $ld_st_non_st32_ctrl
    $ld_st_ex_ctrl
    $mem_ctrl
    $mem_data_access_ctrl
    $mem8_ctrl
    $mem16_ctrl
    $mem32_ctrl
    $dc_index_nowb_inv_ctrl
    $dc_addr_nowb_inv_ctrl
    $dc_index_wb_inv_ctrl
    $dc_addr_wb_inv_ctrl
    $dc_index_inv_ctrl
    $dc_addr_inv_ctrl
    $dc_wb_inv_ctrl
    $dc_nowb_inv_ctrl
    $dcache_management_ctrl
    $ld_io_ctrl
    $st_io_ctrl
    $st_io_non_st32_ctrl
    $st_non_io_non_st32_ctrl
    $mem_io_ctrl
    $a_not_src_ctrl
    $b_not_src_ctrl
    $a3_not_src_ctrl
    $b3_not_src_ctrl
    $b_is_dst_ctrl
    $a3_is_src_ctrl
    $b3_is_src_ctrl
    $a3_is_dst_ctrl
    $b3_is_dst_ctrl
    $c3_is_dst_ctrl
    $ignore_dst_ctrl
    $ignore_dst_or_ld_ctrl
    $src2_choose_imm_ctrl
    $src2_choose_cdx_imm_ctrl
    $wrctl_inst_ctrl
    $rdctl_inst_ctrl
    $intr_inst_ctrl
    $rdprs_ctrl
    $mul_src1_signed_ctrl
    $mul_src2_signed_ctrl
    $mul_shift_src1_signed_ctrl
    $mul_shift_src2_signed_ctrl
    $mul_shift_rot_ctrl
    $dont_display_dst_reg_ctrl
    $dont_display_src1_reg_ctrl
    $dont_display_src2_reg_ctrl
    $src1_no_x_ctrl
    $src2_no_x_ctrl
    $narrow_ctrl
    $cdx_ctrl
);

use cpu_inst_field;
use cpu_inst_desc;
use cpu_inst_ctrl;
use cpu_inst_gen;
use cpu_inst_table;
use cpu_control_reg;
use cpu_utils;
use nios2_custom_insts;
use strict;













our $OP_INST_TYPE = 0;
our $OPX_INST_TYPE = 1;
our $I12_INST_TYPE = 2;
our $DCACHE_INST_TYPE = 3;
our $AS_N_INST_TYPE = 4;
our $R_N_INST_TYPE = 5;
our $SPI_N_INST_TYPE = 6;
our $ASI_N_INST_TYPE = 7;
our $SHI_N_INST_TYPE = 8;
our $PP_N_INST_TYPE = 9;
our $STZ_N_INST_TYPE = 10;
our $CUSTOM_INST_TYPE = 11;



our @INST_TYPES = (
  { name => "op",         value => $OP_INST_TYPE,         },
  { name => "opx",        value => $OPX_INST_TYPE,        },
  { name => "i12",        value => $I12_INST_TYPE,        },
  { name => "dcache",     value => $DCACHE_INST_TYPE,     },
  { name => "as_n",       value => $AS_N_INST_TYPE,       },
  { name => "r_n",        value => $R_N_INST_TYPE,        },
  { name => "spi_n",      value => $SPI_N_INST_TYPE,      },
  { name => "asi_n",      value => $ASI_N_INST_TYPE,      },
  { name => "shi_n",      value => $SHI_N_INST_TYPE,      },
  { name => "pp_n",       value => $PP_N_INST_TYPE,       },
  { name => "stz_n",      value => $STZ_N_INST_TYPE,      },
);


our $a_inst_field;
our $b_inst_field;
our $c_inst_field;
our $custom_n_inst_field;
our $custom_readra_inst_field;
our $custom_readrb_inst_field;
our $custom_writerc_inst_field;
our $opx_inst_field;
our $op_inst_field;
our $i12_x_inst_field;
our $dcache_x_inst_field;
our $imm5_inst_field;
our $imm16_inst_field;
our $imm26_inst_field;
our $control_regnum_inst_field;
our $imm12_inst_field;
our $rsie_inst_field;
our $bmx_msb_inst_field;
our $bmx_lsb_inst_field;
our $memsz_inst_field;
our $i12_memsz_inst_field;
our $f1x4l17_regmask_inst_field;
our $f1x4l17_pc_inst_field;
our $f1x4l17_rs_inst_field;
our $f1x4l17_wb_inst_field;
our $f1x4l17_id_inst_field;
our $i10_imm10_inst_field;
our $t1i7_imm7_inst_field;
our $f1i5_imm5_inst_field;
our $t2i4_imm4_inst_field;
our $a3_inst_field;
our $b3_inst_field;
our $c3_inst_field;
our $a5_inst_field;
our $b5_inst_field;
our $as_n_x_inst_field;
our $x1i7_imm7_inst_field;
our $t1x1i6_imm6_inst_field;
our $spi_n_x_inst_field;
our $stz_n_x_inst_field;
our $l5i4x1_imm4_inst_field;
our $l5i4x1_regrange_inst_field;
our $l5i4x1_fp_inst_field;
our $l5i4x1_cs_inst_field;
our $pp_n_x_inst_field;
our $t2x1l3_shamt_inst_field;
our $shi_n_x_inst_field;
our $t2x1i3_imm3_inst_field;
our $asi_n_x_inst_field;
our $x2l5_lit5_inst_field;
our $r_n_x_inst_field;


our $iw_a_sz;
our $iw_a_lsb;
our $iw_a_msb;
our $iw_b_sz;
our $iw_b_lsb;
our $iw_b_msb;
our $iw_c_sz;
our $iw_c_lsb;
our $iw_c_msb;
our $iw_custom_n_sz;
our $iw_custom_n_lsb;
our $iw_custom_n_msb;
our $iw_custom_readra_sz;
our $iw_custom_readra_lsb;
our $iw_custom_readra_msb;
our $iw_custom_readrb_sz;
our $iw_custom_readrb_lsb;
our $iw_custom_readrb_msb;
our $iw_custom_writerc_sz;
our $iw_custom_writerc_lsb;
our $iw_custom_writerc_msb;
our $iw_opx_sz;
our $iw_opx_lsb;
our $iw_opx_msb;
our $iw_op_sz;
our $iw_op_lsb;
our $iw_op_msb;
our $iw_i12_x_sz;
our $iw_i12_x_lsb;
our $iw_i12_x_msb;
our $iw_dcache_x_sz;
our $iw_dcache_x_lsb;
our $iw_dcache_x_msb;
our $iw_imm5_sz;
our $iw_imm5_lsb;
our $iw_imm5_msb;
our $iw_imm16_sz;
our $iw_imm16_lsb;
our $iw_imm16_msb;
our $iw_imm26_sz;
our $iw_imm26_lsb;
our $iw_imm26_msb;
our $iw_control_regnum_sz;
our $iw_control_regnum_lsb;
our $iw_control_regnum_msb;
our $iw_imm12_sz;
our $iw_imm12_lsb;
our $iw_imm12_msb;
our $iw_rsie_sz;
our $iw_rsie_lsb;
our $iw_rsie_msb;
our $iw_bmx_msb_sz;
our $iw_bmx_msb_lsb;
our $iw_bmx_msb_msb;
our $iw_bmx_lsb_sz;
our $iw_bmx_lsb_lsb;
our $iw_bmx_lsb_msb;
our $iw_memsz_sz;
our $iw_memsz_lsb;
our $iw_memsz_msb;
our $iw_i12_memsz_sz;
our $iw_i12_memsz_lsb;
our $iw_i12_memsz_msb;
our $iw_f1x4l17_regmask_sz;
our $iw_f1x4l17_regmask_lsb;
our $iw_f1x4l17_regmask_msb;
our $iw_f1x4l17_pc_sz;
our $iw_f1x4l17_pc_lsb;
our $iw_f1x4l17_pc_msb;
our $iw_f1x4l17_rs_sz;
our $iw_f1x4l17_rs_lsb;
our $iw_f1x4l17_rs_msb;
our $iw_f1x4l17_wb_sz;
our $iw_f1x4l17_wb_lsb;
our $iw_f1x4l17_wb_msb;
our $iw_f1x4l17_id_sz;
our $iw_f1x4l17_id_lsb;
our $iw_f1x4l17_id_msb;
our $iw_stz_n_x_sz;
our $iw_stz_n_x_lsb;
our $iw_stz_n_x_msb;
our $iw_spi_n_x_sz;
our $iw_spi_n_x_lsb;
our $iw_spi_n_x_msb;
our $iw_as_n_x_sz;
our $iw_as_n_x_lsb;
our $iw_as_n_x_msb;
our $iw_pp_n_x_sz;
our $iw_pp_n_x_lsb;
our $iw_pp_n_x_msb;
our $iw_shi_n_x_sz;
our $iw_shi_n_x_lsb;
our $iw_shi_n_x_msb;
our $iw_asi_n_x_sz;
our $iw_asi_n_x_lsb;
our $iw_asi_n_x_msb;
our $iw_r_n_x_sz;
our $iw_r_n_x_lsb;
our $iw_r_n_x_msb;
our $iw_i10_imm10_sz;
our $iw_i10_imm10_lsb;
our $iw_i10_imm10_msb;
our $iw_t1i7_imm7_sz;
our $iw_t1i7_imm7_lsb;
our $iw_t1i7_imm7_msb;
our $iw_f1i5_imm5_sz;
our $iw_f1i5_imm5_lsb;
our $iw_f1i5_imm5_msb;
our $iw_t2i4_imm4_sz;
our $iw_t2i4_imm4_lsb;
our $iw_t2i4_imm4_msb;
our $iw_t1x1i6_imm6_sz;
our $iw_t1x1i6_imm6_lsb;
our $iw_t1x1i6_imm6_msb;
our $iw_a3_sz;
our $iw_a3_lsb;
our $iw_a3_msb;
our $iw_b3_sz;
our $iw_b3_lsb;
our $iw_b3_msb;
our $iw_c3_sz;
our $iw_c3_lsb;
our $iw_c3_msb;
our $iw_a5_sz;
our $iw_a5_lsb;
our $iw_a5_msb;
our $iw_b5_sz;
our $iw_b5_lsb;
our $iw_b5_msb;
our $iw_x1i7_imm7_sz;
our $iw_x1i7_imm7_lsb;
our $iw_x1i7_imm7_msb;
our $iw_l5i4x1_imm4_sz;
our $iw_l5i4x1_imm4_lsb;
our $iw_l5i4x1_imm4_msb;
our $iw_l5i4x1_regrange_sz;
our $iw_l5i4x1_regrange_lsb;
our $iw_l5i4x1_regrange_msb;
our $iw_l5i4x1_fp_sz;
our $iw_l5i4x1_fp_lsb;
our $iw_l5i4x1_fp_msb;
our $iw_l5i4x1_cs_sz;
our $iw_l5i4x1_cs_lsb;
our $iw_l5i4x1_cs_msb;
our $iw_t2x1l3_shamt_sz;
our $iw_t2x1l3_shamt_lsb;
our $iw_t2x1l3_shamt_msb;
our $iw_t2x1i3_imm3_sz;
our $iw_t2x1i3_imm3_lsb;
our $iw_t2x1i3_imm3_msb;
our $iw_x2l5_lit5_sz;
our $iw_x2l5_lit5_lsb;
our $iw_x2l5_lit5_msb;


our $iw_memsz_byte;
our $iw_memsz_hword;
our $iw_memsz_word_msb;
our $logic_op_sz;
our $logic_op_lsb;
our $logic_op_msb;
our $logic_op_nor;
our $logic_op_and;
our $logic_op_or ;
our $logic_op_xor;
our $compare_op_sz;
our $compare_op_lsb;
our $compare_op_msb;
our $compare_op_eq;
our $compare_op_ge;
our $compare_op_lt;
our $compare_op_ne;
our $jmp_callr_vs_ret_opx_bit;
our $jmp_callr_vs_ret_is_ret;
our $empty_intr_iw;
our $empty_hbreak_iw;
our $empty_crst_iw;
our $empty_nop_iw;
our $empty_ret_iw;



our $unimp_trap_ctrl;
our $unimp_nop_ctrl;
our $reserved_ctrl;
our $illegal_ctrl;
our $trap_inst_ctrl;
our $custom_ctrl;
our $custom_combo_ctrl;
our $custom_multi_ctrl;
our $supervisor_only_ctrl;
our $ic_index_inv_ctrl;
our $invalidate_i_ctrl;
our $flush_pipe_ctrl;
our $jmp_indirect_non_trap_ctrl;
our $jmp_indirect_ctrl;
our $jmp_indirect_word_aligned_ctrl;
our $jmp_indirect_hword_aligned_ctrl;
our $jmp_direct_ctrl;
our $mul_lsw_ctrl;
our $mulx_ctrl;
our $mul_ctrl;
our $div_unsigned_ctrl;
our $div_signed_ctrl;
our $div_ctrl;
our $implicit_dst_retaddr_ctrl;
our $implicit_dst_eretaddr_ctrl;
our $intr_ctrl;
our $exception_ctrl;
our $break_ctrl;
our $crst_ctrl;
our $wr_ctl_reg_flush_ctrl;
our $rd_ctl_reg_ctrl;
our $uncond_cti_non_br_ctrl;
our $retaddr_ctrl;
our $shift_left_ctrl;
our $shift_logical_ctrl;
our $rot_left_ctrl;
our $shift_rot_left_ctrl;
our $shift_right_logical_ctrl;
our $shift_right_arith_ctrl;
our $shift_right_ctrl;
our $rot_right_ctrl;
our $shift_rot_right_ctrl;
our $shift_rot_ctrl;
our $shift_rot_imm_ctrl;
our $rot_ctrl;
our $bmx_ctrl;
our $logic_reg_ctrl;
our $logic_hi_imm16_ctrl;
our $logic_lo_imm16_ctrl;
our $logic_imm16_ctrl;
our $logic_ctrl;
our $hi_imm16_ctrl;
our $andc_ctrl;
our $set_src2_rem_imm_ctrl;
our $signed_imm12_ctrl;
our $unsigned_lo_imm16_ctrl;
our $arith_imm16_ctrl;
our $cmp_imm16_ctrl;
our $jmpi_ctrl;
our $cmp_imm16_with_call_jmpi_rdprs_ctrl;
our $cmp_reg_ctrl;
our $src_imm5_ctrl;
our $src_imm5_shift_rot_ctrl;
our $src_imm3_shift_rot_ctrl;
our $cmp_with_lt_ctrl;
our $cmp_with_eq_ctrl;
our $cmp_with_ge_ctrl;
our $cmp_with_ne_ctrl;
our $cmp_alu_signed_ctrl;
our $cmp_ctrl;
our $br_with_lt_ctrl;
our $br_with_ge_ctrl;
our $br_with_eq_ctrl;
our $br_with_ne_ctrl;
our $br_alu_signed_ctrl;
our $br_cond_ctrl;
our $br_uncond_ctrl;
our $br_always_pred_taken_ctrl;
our $br_ctrl;
our $alu_subtract_ctrl;
our $a_is_sp_ctrl;
our $dst_is_sp_ctrl;
our $alu_signed_comparison_ctrl;
our $br_cmp_ctrl;
our $br_cmp_eq_ne_ctrl;
our $ld8_ctrl;
our $ld16_ctrl;
our $ld8_ld16_ctrl;
our $ld32_ctrl;
our $ld_signed_ctrl;
our $ld_unsigned_ctrl;
our $ld_ctrl;
our $ld_imm_ctrl;
our $ld_ex_ctrl;
our $multiple_loads_ctrl;
our $multiple_stores_ctrl;
our $multiple_loads_stores_ctrl;
our $dcache_management_nop_ctrl;
our $dcache_management_only_ctrl;
our $ld_dcache_management_ctrl;
our $ld_non_io_ctrl;
our $st8_ctrl;
our $st16_ctrl;
our $st_non32_ctrl;
our $st32_ctrl;
our $st_ex_ctrl;
our $st_ctrl;
our $st_imm_ctrl;
our $st_ignore_dst_ctrl;
our $st_non_io_ctrl;
our $ld_st_ctrl;
our $ld_st_io_ctrl;
our $ld_st_non_io_ctrl;
our $ld_st_non_io_non_st32_ctrl;
our $ld_st_non_st32_ctrl;
our $ld_st_ex_ctrl;
our $mem_ctrl;
our $mem_data_access_ctrl;
our $mem8_ctrl;
our $mem16_ctrl;
our $mem32_ctrl;
our $dc_index_nowb_inv_ctrl;
our $dc_addr_nowb_inv_ctrl;
our $dc_index_wb_inv_ctrl;
our $dc_addr_wb_inv_ctrl;
our $dc_index_inv_ctrl;
our $dc_addr_inv_ctrl;
our $dc_wb_inv_ctrl;
our $dc_nowb_inv_ctrl;
our $dcache_management_ctrl;
our $ld_io_ctrl;
our $st_io_ctrl;
our $st_io_non_st32_ctrl;
our $st_non_io_non_st32_ctrl;
our $mem_io_ctrl;
our $a_not_src_ctrl;
our $b_not_src_ctrl;
our $a3_not_src_ctrl;
our $b3_not_src_ctrl;
our $b_is_dst_ctrl;
our $a3_is_src_ctrl;
our $b3_is_src_ctrl;
our $a3_is_dst_ctrl;
our $b3_is_dst_ctrl;
our $c3_is_dst_ctrl;
our $ignore_dst_ctrl;
our $ignore_dst_or_ld_ctrl;
our $src2_choose_imm_ctrl;
our $src2_choose_cdx_imm_ctrl;
our $wrctl_inst_ctrl;
our $rdctl_inst_ctrl;
our $intr_inst_ctrl;
our $rdprs_ctrl;
our $mul_src1_signed_ctrl;
our $mul_src2_signed_ctrl;
our $mul_shift_src1_signed_ctrl;
our $mul_shift_src2_signed_ctrl;
our $mul_shift_rot_ctrl;
our $dont_display_dst_reg_ctrl;
our $dont_display_src1_reg_ctrl;
our $dont_display_src2_reg_ctrl;
our $src1_no_x_ctrl;
our $src2_no_x_ctrl;
our $narrow_ctrl;
our $cdx_ctrl;







sub
create_inst_args_from_infos
{
    my $nios2_isa_info = shift;
    my $misc_info = shift;
    my $custom_inst_info = shift;
    my $control_reg_info = shift;
    my $multiply_info = shift;
    my $divide_info = shift;
    my $exception_info = shift;
    my $elaborated_advanced_exc_info = shift;
    my $icache_info = shift;
    my $dcache_info = shift;
    my $elaborated_dcache_info = shift;
    my $elaborated_debug_info = shift;
    my $test_info = shift;
    my $interrupt_info = shift;


    my $cpu_reset = manditory_bool($misc_info, "cpu_reset");
    my $shadow_present = (manditory_int($misc_info, "num_shadow_reg_sets") > 0);
    my $hardware_divide_present = 
      manditory_bool($divide_info, "hardware_divide_present");
    my $hardware_multiply_present = 
      manditory_bool($multiply_info, "hardware_multiply_present");
    my $hardware_multiply_omits_msw =
      $hardware_multiply_present && 
      manditory_bool($multiply_info, "hardware_multiply_omits_msw");
    my $advanced_exc = 
      manditory_bool($elaborated_advanced_exc_info, "advanced_exc");
    my $cache_has_icache = manditory_bool($icache_info, "cache_has_icache");
    my $cache_has_dcache = manditory_bool($dcache_info, "cache_has_dcache");;
    my $hbreak_present = manditory_bool($elaborated_debug_info, "hbreak_present");
    my $oci_present = manditory_bool($elaborated_debug_info, "debugger_present");
    my $allow_break_inst = 
      manditory_bool($test_info, "allow_break_inst");
    my $eic_present = manditory_bool($interrupt_info, "eic_present");
    my $mpx_present = manditory_bool($misc_info, "mpx_present");
    my $cpu_arch_rev = manditory_int($misc_info, "cpu_arch_rev");
    my $bmx_present = manditory_bool($misc_info, "bmx_present");
    my $cdx_present = manditory_bool($misc_info, "cdx_present");
    
    my $inst_args = {
        isa_constants => manditory_hash($nios2_isa_info, "isa_constants"),
        cpu_reset => $cpu_reset,
        shadow_present => $shadow_present,
        custom_instructions => $custom_inst_info->{custom_instructions},
        control_reg_num_decode_sz => 
          get_control_reg_num_decode_sz($control_reg_info->{control_regs}),
        hardware_divide_present => $hardware_divide_present,
        hardware_multiply_present => $hardware_multiply_present,
        hardware_multiply_omits_msw => $hardware_multiply_omits_msw,
        advanced_exc => $advanced_exc,
        cache_has_icache => $cache_has_icache,
        cache_has_dcache => $cache_has_dcache,
        hbreak_present => $hbreak_present,
        oci_present => $oci_present,
        allow_break_inst => $allow_break_inst,
        eic_present => $eic_present,
        mpx_present => $mpx_present,
        cpu_arch_rev => $cpu_arch_rev,
        bmx_present => $bmx_present,
        cdx_present => $cdx_present,
    };

    return $inst_args;
}




sub
create_inst_args_from_test_args
{
    my $nios2_isa_info = shift;
    my $custom_instructions = shift;
    my $test_args = shift;  # Hash to args required to setup for tests

    my $inst_args = {
        isa_constants               => manditory_hash($nios2_isa_info, "isa_constants"),
        cpu_reset                   => manditory_bool($test_args, "cpu_reset"),
        shadow_present              => manditory_bool($test_args, "shadow_present"),
        custom_instructions         => $custom_instructions,
        control_reg_num_decode_sz   => 5,
        hardware_divide_present     => manditory_bool($test_args, "hardware_divide_present"),
        hardware_multiply_present   => manditory_bool($test_args, "hardware_multiply_present"),
        hardware_multiply_omits_msw => manditory_bool($test_args, "hardware_multiply_omits_msw"),
        advanced_exc                => manditory_bool($test_args, "advanced_exc"),
        cache_has_icache            => manditory_bool($test_args, "cache_has_icache"),
        cache_has_dcache            => manditory_bool($test_args, "cache_has_dcache"),
        hbreak_present              => manditory_bool($test_args, "hbreak_present"),
        oci_present                 => manditory_bool($test_args, "oci_present"),
        allow_break_inst            => manditory_bool($test_args, "allow_break_inst"),
        eic_present                 => manditory_bool($test_args, "eic_present"),
        mpx_present                 => manditory_bool($test_args, "mpx_present"),
        cpu_arch_rev                => manditory_int($test_args, "cpu_arch_rev"),
        bmx_present                 => manditory_bool($test_args, "bmx_present"),
        cdx_present                 => manditory_bool($test_args, "cdx_present"),
    };

    return $inst_args;
}


sub
get_default_test_args_configuration
{
    my $cpu_arch_rev = shift;

    return {
      configuration_name          => "default",
      cpu_reset                   => 1,
      shadow_present              => 1,
      hardware_divide_present     => 1,
      hardware_multiply_present   => 1,
      hardware_multiply_omits_msw => 0,
      advanced_exc                => 0,    # Needs to be off to get intr/hbreak in nios2_isa.h
      cache_has_icache            => 1,
      cache_has_dcache            => 1,
      hbreak_present              => 1,
      oci_present                 => 1,
      allow_break_inst            => 0,
      eic_present                 => 1,
      mpx_present                 => 1,
      cpu_arch_rev                => $cpu_arch_rev,
      bmx_present                 => 1,
      cdx_present                 => 1,
    };
}


sub
get_test_args_configurations
{
    my $cpu_arch_rev = shift;

    return [
      {
        configuration_name          => "no_mul",
        cpu_reset                   => 0,
        shadow_present              => 0,
        hardware_divide_present     => 1,
        hardware_multiply_present   => 0,
        hardware_multiply_omits_msw => 0,
        advanced_exc                => 0,
        cache_has_icache            => 1,
        cache_has_dcache            => 1,
        hbreak_present              => 0,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
      {
        configuration_name          => "no_mulx",
        cpu_reset                   => 0,
        shadow_present              => 0,
        hardware_divide_present     => 1,
        hardware_multiply_present   => 1,
        hardware_multiply_omits_msw => 1,
        advanced_exc                => 0,
        cache_has_icache            => 1,
        cache_has_dcache            => 1,
        hbreak_present              => 0,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
      {
        configuration_name          => "no_div",
        cpu_reset                   => 0,
        shadow_present              => 0,
        hardware_divide_present     => 0,
        hardware_multiply_present   => 1,
        hardware_multiply_omits_msw => 0,
        advanced_exc                => 0,
        cache_has_icache            => 1,
        cache_has_dcache            => 1,
        hbreak_present              => 0,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
      {
        configuration_name          => "advanced_exc",
        cpu_reset                   => 1,
        shadow_present              => 0,
        hardware_divide_present     => 1,
        hardware_multiply_present   => 1,
        hardware_multiply_omits_msw => 0,
        advanced_exc                => 1,
        cache_has_icache            => 1,
        cache_has_dcache            => 1,
        hbreak_present              => 1,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
      {
        configuration_name          => "not_advanced_exc",
        cpu_reset                   => 1,
        shadow_present              => 0,
        hardware_divide_present     => 1,
        hardware_multiply_present   => 1,
        hardware_multiply_omits_msw => 0,
        advanced_exc                => 0,
        cache_has_icache            => 1,
        cache_has_dcache            => 1,
        hbreak_present              => 1,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
      {
        configuration_name          => "no_icache",
        cpu_reset                   => 0,
        shadow_present              => 0,
        hardware_divide_present     => 1,
        hardware_multiply_present   => 1,
        hardware_multiply_omits_msw => 0,
        advanced_exc                => 0,
        cache_has_icache            => 0,
        cache_has_dcache            => 1,
        hbreak_present              => 0,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
      {
        configuration_name          => "no_dcache",
        cpu_reset                   => 0,
        shadow_present              => 0,
        hardware_divide_present     => 1,
        hardware_multiply_present   => 1,
        hardware_multiply_omits_msw => 0,
        advanced_exc                => 0,
        cache_has_icache            => 1,
        cache_has_dcache            => 0,
        hbreak_present              => 0,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
      {
        configuration_name          => "shadow",
        cpu_reset                   => 0,
        shadow_present              => 1,
        hardware_divide_present     => 1,
        hardware_multiply_present   => 1,
        hardware_multiply_omits_msw => 0,
        advanced_exc                => 0,
        cache_has_icache            => 1,
        cache_has_dcache            => 1,
        hbreak_present              => 0,
        oci_present                 => 1,
        allow_break_inst            => 0,
        eic_present                 => 0,
        mpx_present                 => 0,
        cpu_arch_rev                => $cpu_arch_rev,
        bmx_present                 => 1,
        cdx_present                 => 1,
      },
    ];
}




sub
create_inst_args_gen_isa_configuration
{
    my $nios2_isa_info = shift;
    my $cpu_arch_rev = shift;

    if (!defined($nios2_isa_info)) {
        return &$error("nios2_isa_info is undefined");
    }

    if (!defined($cpu_arch_rev)) {
        return &$error("cpu_arch_rev is undefined");
    }

    return create_inst_args_from_test_args($nios2_isa_info, {},
      get_default_test_args_configuration($cpu_arch_rev));
}




sub
validate_and_elaborate
{
    my $inst_args = shift; # Hash reference containing all args
    my $prefix = shift; #  Prefix for new CPU architecture 

    my $isa_constants = manditory_hash($inst_args, "isa_constants");
    my $custom_instructions = manditory_hash($inst_args, "custom_instructions");
    my $control_reg_num_decode_sz = manditory_int($inst_args, "control_reg_num_decode_sz");
    my $shadow_present = manditory_bool($inst_args, "shadow_present");
    my $eic_present = manditory_bool($inst_args, "eic_present");
    my $bmx_present = manditory_bool($inst_args, "bmx_present");
    my $cdx_present = manditory_bool($inst_args, "cdx_present");
    my $r1 = manditory_int($inst_args, "cpu_arch_rev") == 1;

    my $inst_fields = $r1 ?
      r1_add_inst_fields($control_reg_num_decode_sz) :
      r2_add_inst_fields($control_reg_num_decode_sz, $eic_present, 
        $shadow_present, $bmx_present, $cdx_present);
    my ($inst_tables, $top_inst_table) = $r1 ?
      r1_add_inst_tables($inst_fields) :
      r2_add_inst_tables($inst_fields);
    my $inst_descs = add_inst_descs($inst_tables, $top_inst_table, $custom_instructions,
      $inst_args) || return undef;
    my $constants = add_inst_constants($inst_fields, $inst_descs, $isa_constants, $r1) || return undef;
    my $inst_ctrls = $r1 ?
      r1_add_inst_ctrls($inst_args, $inst_descs) :
      r2_add_inst_ctrls($inst_args, $inst_descs, $prefix);

    my $inst_info = {
      default_inst_ctrl_allowed_modes => get_default_inst_ctrl_allowed_modes($inst_args),
      exception_inst_ctrl_allowed_modes => get_exception_inst_ctrl_allowed_modes($inst_args),
      inst_field_info       => {
        inst_fields => $inst_fields,
        extra_gen_func => \&gen_extra_inst_field_signals,
        extra_gen_func_arg => $r1,
      },
      inst_tables           => $inst_tables,
      top_inst_table        => $top_inst_table,
      inst_constants        => $constants,
      inst_desc_info        => {
        inst_descs  => $inst_descs,
        extra_gen_func => \&gen_extra_inst_desc_signals,
        extra_gen_func_arg => {
            inst_tables             => $inst_tables,
            top_inst_table          => $top_inst_table,
        },
      },
      inst_ctrls            => $inst_ctrls,
    };


    foreach my $var (keys(%$constants)) {
        eval_cmd('$' . $var . ' = "' . $constants->{$var} . '"');
    }


    foreach my $inst_field (@$inst_fields) {





        foreach my $cmd (@{get_inst_field_into_scalars($inst_field)}) {
            eval_cmd($cmd);
        }
    }

    return $inst_info;
}


sub
convert_to_c
{
    my $cpu_arch = shift;
    my $inst_info = shift;
    my $c_lines = shift;        # Reference to array of lines for *.c file
    my $h_lines = shift;        # Reference to array of lines for *.h file
    my $prefix = shift;         # Prefix

    my $inst_field_info = manditory_hash($inst_info, "inst_field_info");
    my $inst_fields = manditory_array($inst_field_info, "inst_fields");

    my $inst_tables = manditory_array($inst_info, "inst_tables");
    my $top_inst_table = manditory_hash($inst_info, "top_inst_table");
    my $inst_constants = manditory_hash($inst_info, "inst_constants");
    my $inst_ctrls = manditory_array($inst_info, "inst_ctrls");

    my $inst_desc_info = manditory_hash($inst_info, "inst_desc_info");
    my $inst_descs = manditory_array($inst_desc_info, "inst_descs");
    
    convert_inst_fields_to_c($inst_fields, $c_lines, $h_lines, $prefix) || return undef;
    convert_inst_tables_to_c($inst_tables, $c_lines, $h_lines, $prefix) || return undef;
    convert_constants_to_c($inst_constants, $c_lines, $h_lines, $prefix) || return undef;
    convert_inst_ctrls_to_c($inst_ctrls, $inst_descs, $c_lines, $h_lines, $prefix) || return undef;
    create_c_inst_info($cpu_arch,$inst_descs, $inst_tables, $top_inst_table, $c_lines, $h_lines, $prefix) ||
      return undef;
    create_c_mask_match($inst_descs, $inst_fields, $top_inst_table, $h_lines, $prefix) || 
      return undef;
    create_nlagen_tables($cpu_arch,$c_lines, $h_lines) || return undef;

    return 1;   # Some defined value
}




sub
additional_inst_ctrl
{
    my $Opt = shift;
    my $props = shift;

    my $inst_ctrls = manditory_array($Opt, "inst_ctrls");

    return nios2_insts::add_inst_ctrl($inst_ctrls, $props);
}







sub
add_inst_constants
{
    my $inst_fields = shift;
    my $inst_descs = shift;
    my $isa_constants = shift;
    my $r1 = shift;

    my %constants;


    $constants{iw_memsz_byte} = "2'b00";
    $constants{iw_memsz_hword} = "2'b01";
    $constants{iw_memsz_word_msb} = "1'b1";  # top bit is enough for word


    $constants{logic_op_sz} = 2;
    $constants{logic_op_lsb} = 3;
    $constants{logic_op_msb} = 
      $constants{logic_op_lsb} + $constants{logic_op_sz} - 1;
    $constants{logic_op_nor} = "2'b00";
    $constants{logic_op_and} = "2'b01";
    $constants{logic_op_or}  = "2'b10";
    $constants{logic_op_xor} = "2'b11";
    

    $constants{compare_op_sz} = 2;
    $constants{compare_op_lsb} = 3;
    $constants{compare_op_msb} = 
      $constants{compare_op_lsb} + $constants{compare_op_sz} - 1;
    $constants{compare_op_ne} = $r1 ? "2'b11" : "2'b00";
    $constants{compare_op_eq} = $r1 ? "2'b00" : "2'b01";
    $constants{compare_op_ge} = $r1 ? "2'b01" : "2'b10";
    $constants{compare_op_lt} = $r1 ? "2'b10" : "2'b11";


    $constants{jmp_callr_vs_ret_opx_bit} = 3;
    $constants{jmp_callr_vs_ret_is_ret} = "0";


    my $retaddr_regnum_int = 
      manditory_int($isa_constants, "retaddr_regnum_int");
    my $eretaddr_regnum_int = 
      manditory_int($isa_constants, "eretaddr_regnum_int");
    my $bretaddr_regnum_int = 
      manditory_int($isa_constants, "bretaddr_regnum_int");

    $constants{empty_intr_iw} = encode_opx_inst(
       $inst_fields, $inst_descs, "intr", 0, 0, $eretaddr_regnum_int) || return undef;
    $constants{empty_hbreak_iw} = encode_opx_inst(
      $inst_fields, $inst_descs, "hbreak", 0, 0, $bretaddr_regnum_int) || return undef;
    $constants{empty_crst_iw} = encode_opx_inst(
      $inst_fields, $inst_descs, "crst", 0, 0, 0) || return undef;
    $constants{empty_nop_iw} = encode_opx_inst(
      $inst_fields, $inst_descs, "add", 0, 0, 0) || return undef;
    $constants{empty_ret_iw} = encode_opx_inst(
      $inst_fields, $inst_descs, "ret", $retaddr_regnum_int, 0, 0) || return undef;

    return \%constants;
}

















sub
r1_add_inst_fields
{
    my $control_reg_num_decode_sz = shift;

    my $inst_fields = [];

    $a_inst_field = add_inst_field($inst_fields, {
      name => "a", 
      lsb  => 27,
      sz   => 5,
    });

    $b_inst_field = add_inst_field($inst_fields, {
      name => "b", 
      lsb  => 22,
      sz   => 5,
    });
    
    $c_inst_field = add_inst_field($inst_fields, {
      name => "c", 
      lsb  => 17,
      sz   => 5,
    });
    
    $custom_n_inst_field = add_inst_field($inst_fields, {
      name => "custom_n", 
      lsb  => 6,
      sz   => 8,
    });
    
    $custom_readra_inst_field = add_inst_field($inst_fields, {
      name => "custom_readra", 
      lsb  => 16,
      sz   => 1,
    });

    $custom_readrb_inst_field = add_inst_field($inst_fields, {
      name => "custom_readrb", 
      lsb  => 15,
      sz   => 1,
    });

    $custom_writerc_inst_field = add_inst_field($inst_fields, {
      name => "custom_writerc", 
      lsb  => 14,
      sz   => 1,
    });
    
    $opx_inst_field = add_inst_field($inst_fields, {
      name => "opx", 
      lsb  => 11,
      sz   => 6,
    });
    
    $op_inst_field = add_inst_field($inst_fields, {
      name => "op", 
      lsb  => 0,
      sz   => 6,
    });
    
    $imm5_inst_field = add_inst_field($inst_fields, {
      name => "imm5", 
      lsb  => 6,
      sz   => 5,
    });
    
    $imm16_inst_field = add_inst_field($inst_fields, {
      name => "imm16", 
      lsb  => 6,
      sz   => 16,
    });
    
    $imm26_inst_field = add_inst_field($inst_fields, {
      name => "imm26", 
      lsb  => 6,
      sz   => 26,
    });
    
    $memsz_inst_field = add_inst_field($inst_fields, {
      name => "memsz", 
      lsb  => 3,
      sz   => 2,
    });

    $control_regnum_inst_field = add_inst_field($inst_fields, {
      name => "control_regnum", 
      lsb  => 6,
      sz   => $control_reg_num_decode_sz,
    });

    return $inst_fields;
}



sub
r2_add_inst_fields
{
    my $control_reg_num_decode_sz = shift;
    my $eic_present = shift;
    my $shadow_present = shift;
    my $bmx_present = shift;
    my $cdx_present = shift;

    my $inst_fields = [];

    $a_inst_field = add_inst_field($inst_fields, {
      name => "a", 
      lsb  => 6,
      sz   => 5,
    });

    $b_inst_field = add_inst_field($inst_fields, {
      name => "b", 
      lsb  => 11,
      sz   => 5,
    });
    
    $c_inst_field = add_inst_field($inst_fields, {
      name => "c", 
      lsb  => 16,
      sz   => 5,
    });
    
    $custom_n_inst_field = add_inst_field($inst_fields, {
      name => "custom_n", 
      lsb  => 24,
      sz   => 8,
    });
    
    $custom_readra_inst_field = add_inst_field($inst_fields, {
      name => "custom_readra", 
      lsb  => 21,
      sz   => 1,
    });

    $custom_readrb_inst_field = add_inst_field($inst_fields, {
      name => "custom_readrb", 
      lsb  => 22,
      sz   => 1,
    });

    $custom_writerc_inst_field = add_inst_field($inst_fields, {
      name => "custom_writerc", 
      lsb  => 23,
      sz   => 1,
    });
    
    $opx_inst_field = add_inst_field($inst_fields, {
      name => "opx", 
      lsb  => 26,
      sz   => 6,
    });
    
    $op_inst_field = add_inst_field($inst_fields, {
      name => "op", 
      lsb  => 0,
      sz   => 6,
    });

    $i12_x_inst_field = add_inst_field($inst_fields, {
      name => "i12_x", 
      lsb  => 28,
      sz   => 4,
    });
    
    $dcache_x_inst_field = add_inst_field($inst_fields, {
      name => "dcache_x", 
      lsb  => 11,
      sz   => 5,
    });
   
    $imm5_inst_field = add_inst_field($inst_fields, {
      name => "imm5", 
      lsb  => 21,
      sz   => 5,
    });
    
    $imm16_inst_field = add_inst_field($inst_fields, {
      name => "imm16", 
      lsb  => 16,
      sz   => 16,
    });
    
    $imm26_inst_field = add_inst_field($inst_fields, {
      name => "imm26", 
      lsb  => 6,
      sz   => 26,
    });
    
    $memsz_inst_field = add_inst_field($inst_fields, {
      name => "memsz", 
      lsb  => 3,
      sz   => 2,
    });

    $i12_memsz_inst_field = add_inst_field($inst_fields, {
      name => "i12_memsz", 
      lsb  => 30,
      sz   => 2,
    });

    $control_regnum_inst_field = add_inst_field($inst_fields, {
      name => "control_regnum", 
      lsb  => 21,
      sz   => $control_reg_num_decode_sz,
    });

    $imm12_inst_field = add_inst_field($inst_fields, {
      name => "imm12", 
      lsb  => 16,
      sz   => 12,
    });

    if ($bmx_present) {
        $bmx_msb_inst_field = add_inst_field($inst_fields, {
          name => "bmx_msb", 
          lsb  => 21,
          sz   => 5,
        });
        
        $bmx_lsb_inst_field = add_inst_field($inst_fields, {
          name => "bmx_lsb", 
          lsb  => 16,
          sz   => 5,
        });
    }

    if ($eic_present & $shadow_present) {
        $rsie_inst_field = add_inst_field($inst_fields, {
          name => "rsie", 
          lsb  => 21,
          sz   => 1,
        });
    }

    if ($cdx_present) {
        $f1x4l17_regmask_inst_field = add_inst_field($inst_fields, {
          name => "f1x4l17_regmask", 
          lsb  => 16,
          sz   => 12,
        });
        
        $f1x4l17_pc_inst_field = add_inst_field($inst_fields, {
          name => "f1x4l17_pc", 
          lsb  => 14,
          sz   => 1,
        });
        
        $f1x4l17_rs_inst_field = add_inst_field($inst_fields, {
          name => "f1x4l17_rs", 
          lsb  => 13,
          sz   => 1,
        });
        
        $f1x4l17_wb_inst_field = add_inst_field($inst_fields, {
          name => "f1x4l17_wb", 
          lsb  => 12,
          sz   => 1,
        });
        
        $f1x4l17_id_inst_field = add_inst_field($inst_fields, {
          name => "f1x4l17_id", 
          lsb  => 11,
          sz   => 1,
        });

        $i10_imm10_inst_field = add_inst_field($inst_fields, {
          name => "i10_imm10", 
          lsb  => 6,
          sz   => 10,
        });
        
        $t1i7_imm7_inst_field = add_inst_field($inst_fields, {
          name => "t1i7_imm7", 
          lsb  => 9,
          sz   => 7,
        });
        
        $f1i5_imm5_inst_field = add_inst_field($inst_fields, {
          name => "f1i5_imm5", 
          lsb  => 6,
          sz   => 5,
        });
        
        $t2i4_imm4_inst_field = add_inst_field($inst_fields, {
          name => "t2i4_imm4", 
          lsb  => 12,
          sz   => 4,
        });
        
        $t1x1i6_imm6_inst_field = add_inst_field($inst_fields, {
          name => "t1x1i6_imm6", 
          lsb  => 9,
          sz   => 6,
        });

        $a3_inst_field = add_inst_field($inst_fields, {
          name => "a3", 
          lsb  => 6,
          sz   => 3,
        });
        
        $b3_inst_field = add_inst_field($inst_fields, {
          name => "b3", 
          lsb  => 9,
          sz   => 3,
        });
        
        $c3_inst_field = add_inst_field($inst_fields, {
          name => "c3", 
          lsb  => 12,
          sz   => 3,
        });
        
        $a5_inst_field = add_inst_field($inst_fields, {
          name => "a5", 
          lsb  => 6,
          sz   => 5,
        });
        
        $b5_inst_field = add_inst_field($inst_fields, {
          name => "b5", 
          lsb  => 11,
          sz   => 5,
        });
        
        $x1i7_imm7_inst_field = add_inst_field($inst_fields, {
          name => "x1i7_imm7", 
          lsb  => 6,
          sz   => 7,
        });
       
        $l5i4x1_imm4_inst_field = add_inst_field($inst_fields, {
          name => "l5i4x1_imm4", 
          lsb  => 6,
          sz   => 4,
        });
        
        $l5i4x1_regrange_inst_field = add_inst_field($inst_fields, {
          name => "l5i4x1_regrange", 
          lsb  => 10,
          sz   => 3,
        });
        
        $l5i4x1_fp_inst_field = add_inst_field($inst_fields, {
          name => "l5i4x1_fp", 
          lsb  => 13,
          sz   => 1,
        });
        
        $l5i4x1_cs_inst_field = add_inst_field($inst_fields, {
          name => "l5i4x1_cs", 
          lsb  => 14,
          sz   => 1,
        });

        $t2x1l3_shamt_inst_field = add_inst_field($inst_fields, {
          name => "t2x1l3_shamt", 
          lsb  => 12,
          sz   => 3,
        });
        
        $t2x1i3_imm3_inst_field = add_inst_field($inst_fields, {
          name => "t2x1i3_imm3", 
          lsb  => 12,
          sz   => 3,
        });
        
        $x2l5_lit5_inst_field = add_inst_field($inst_fields, {
          name => "x2l5_lit5", 
          lsb  => 6,
          sz   => 5,
        });
    }
    
    $as_n_x_inst_field = add_inst_field($inst_fields, {
      name => "as_n_x", 
      lsb  => 15,
      sz   => 1,
    });

    $r_n_x_inst_field = add_inst_field($inst_fields, {
      name => "r_n_x", 
      lsb  => 12,
      sz   => 4,
    });
    
    $asi_n_x_inst_field = add_inst_field($inst_fields, {
      name => "asi_n_x", 
      lsb  => 15,
      sz   => 1,
    });
    
    $shi_n_x_inst_field = add_inst_field($inst_fields, {
      name => "shi_n_x", 
      lsb  => 15,
      sz   => 1,
    });
    
    $pp_n_x_inst_field = add_inst_field($inst_fields, {
      name => "pp_n_x", 
      lsb  => 15,
      sz   => 1,
    });
    
    $stz_n_x_inst_field = add_inst_field($inst_fields, {
      name => "stz_n_x", 
      lsb  => 15,
      sz   => 1,
    });

    $spi_n_x_inst_field = add_inst_field($inst_fields, {
      name => "spi_n_x", 
      lsb  => 15,
      sz   => 1,
    });

    return $inst_fields;
}



sub
add_inst_field
{
    my $inst_fields = shift;
    my $props = shift;

    my $field_name = $props->{name};

    if (defined(get_inst_field_by_name_or_undef($inst_fields, $field_name))) {
        return &$error("Instruction field name '$field_name' already exists");
    }

    my $inst_field = create_inst_field($props);


    push(@$inst_fields, $inst_field);

    return $inst_field;
}


sub
gen_extra_inst_field_signals
{
    my $gen_info = shift;
    my $r1 = shift;     # If this is true, it is a Nios II R1
    my $stage = shift;

    my $assignment_func = manditory_code($gen_info, "assignment_func");

    &$assignment_func({
      lhs => "${stage}_mem8",
      rhs => $r1 ? "(${stage}_iw_memsz == $iw_memsz_byte)" :
                   "(${stage}_iw_memsz == $iw_memsz_byte) || (${stage}_iw_i12_memsz == $iw_memsz_byte)",
      sz => 1,
      never_export => 1,
    });

    &$assignment_func({
      lhs => "${stage}_mem16",
      rhs => $r1 ? "(${stage}_iw_memsz == $iw_memsz_hword)" :
                   "(${stage}_iw_memsz == $iw_memsz_hword) || (${stage}_iw_i12_memsz == $iw_memsz_hword)",
      sz => 1,
      never_export => 1,
    });

    &$assignment_func({
      lhs => "${stage}_mem32",
      rhs => $r1 ? "(${stage}_iw_memsz[1] == $iw_memsz_word_msb)" :
                   "(${stage}_iw_memsz[1] == $iw_memsz_word_msb) || (${stage}_iw_i12_memsz[1] == $iw_memsz_word_msb)",
      sz => 1,
      never_export => 1,
    });
}













sub
r1_add_inst_tables
{
    my $inst_fields = shift;

    my $inst_tables = [];


    our @possible_op_insts =

        qw(   call    jmpi    02      ldbu    addi    stb     br      ldb
              cmpgei  09      10      ldhu    andi    sth     bge     ldh
              cmplti  17      18      initda  ori     stw     blt     ldw
              cmpnei  25      26      flushda xori    stc     bne     ldl
              cmpeqi  33      34      ldbuio  muli    stbio   beq     ldbio
              cmpgeui 41      42      ldhuio  andhi   sthio   bgeu    ldhio
              cmpltui 49      custom  initd   orhi    stwio   bltu    ldwio
              rdprs   57      OPX     flushd  xorhi   61      62      63
        );
    
    my $op_inst_table = add_inst_table($inst_tables, {
      name          => "op",
      inst_field    => get_inst_field_by_name($inst_fields, "op"),
      opcodes       => \@possible_op_insts,
      inst_type     => $OP_INST_TYPE,
    });


    our @possible_opx_insts =

        qw(   00      eret    roli    rol     flushp  ret     nor     mulxuu
              cmpge   bret    10      ror     flushi  jmp     and     15
              cmplt   17      slli    sll     wrprs   21      or      mulxsu
              cmpne   25      srli    srl     nextpc  callr   xor     mulxss
              cmpeq   33      34      35      divu    div     rdctl   mul
              cmpgeu  initi   42      43      44      trap    wrctl   47
              cmpltu  add     50      51      break   hbreak  sync    55
              56      sub     srai    sra     60      intr    crst    63
        );
        
    add_inst_table($inst_tables, {
      name          => "opx",
      inst_field    => get_inst_field_by_name($inst_fields, "opx"),
      opcodes       => \@possible_opx_insts,
      parent_table  => $op_inst_table,
      inst_type     => $OPX_INST_TYPE,
    });

    return ($inst_tables, $op_inst_table);
}













sub
r2_add_inst_tables
{
    my $inst_fields = shift;

    my $inst_tables = [];


    my @possible_op_insts =

        qw(   call    AS_N      br      br_n      addi    ldbu_n   ldbu    ldb
              jmpi    R_N       10      andi_n    andi    ldhu_n   ldhu    ldh
              16      ASI_N     bge     ldwsp_n   ori     ldw_n    cmpgei  ldw
              24      SHI_N     blt     movi_n    xori    STZ_N    cmplti  andci
              OPX     PP_N      bne     bnez_n    muli    stb_n    cmpnei  stb
              I12     SPI_N     beq     beqz_n    andhi   sth_n    cmpeqi  sth
              custom  49        bgeu    stwsp_n   orhi    stw_n    cmpgeui stw
              56      57        bltu    mov_n     xorhi   spaddi_n cmpltui andchi
          );
    
    my $op_inst_table = add_inst_table($inst_tables, {
      name          => "op",
      inst_field    => get_inst_field_by_name($inst_fields, "op"),
      opcodes       => \@possible_op_insts,
      inst_type     => $OP_INST_TYPE,
    });


    my @possible_opx_insts =

        qw(   wrpie   eret    roli    rol     flushp  ret     nor     mulxuu
              eni     bret    10      ror     flushi  jmp     and     15
              cmpge   17      slli    sll     wrprs   21      or      mulxsu
              cmplt   25      srli    srl     nextpc  callr   xor     mulxss
              cmpne   33      34      insert  divu    div     rdctl   mul
              cmpeq   initi   42      merge   hbreak  trap    wrctl   47
              cmpgeu  add     50      extract break   ldex    sync    ldsex
              cmpltu  sub     srai    sra     intr    stex    crst    stsex
          );
        
    add_inst_table($inst_tables, {
      name          => "opx",
      inst_field    => get_inst_field_by_name($inst_fields, "opx"),
      opcodes       => \@possible_opx_insts,
      parent_table  => $op_inst_table,
      inst_type     => $OPX_INST_TYPE,
    });

    my @possible_i12_insts =

        qw(   ldbio   stbio   ldbuio  DCACHE  ldhio   sthio   ldhuio  rdprs
              ldwio   stwio   10      11      ldwm    stwm    14      15
          );
    
    my $i12_inst_table = add_inst_table($inst_tables, {
      name          => "i12",
      inst_field    => get_inst_field_by_name($inst_fields, "i12_x"),
      opcodes       => \@possible_i12_insts,
      parent_table  => $op_inst_table,
      inst_type     => $I12_INST_TYPE,
    });

    my @possible_dcache_insts =

        qw(   initd   initda  flushd  flushda 04      05      06      07
              08      09      10      11      12      13      14      15
              16      17      18      19      20      21      22      23
              24      25      26      27      28      29      30      31
          );
    
    add_inst_table($inst_tables, {
      name          => "dcache",
      inst_field    => get_inst_field_by_name($inst_fields, "dcache_x"),
      opcodes       => \@possible_dcache_insts,
      parent_table  => $i12_inst_table,
      inst_type     => $DCACHE_INST_TYPE,
    });

    my @possible_as_n_insts =

        qw(   add_n   sub_n    );

    add_inst_table($inst_tables, {
      name          => "as_n",
      inst_field    => get_inst_field_by_name($inst_fields, "as_n_x"),
      opcodes       => \@possible_as_n_insts,
      parent_table  => $op_inst_table,
      inst_type     => $AS_N_INST_TYPE,
    });

    my @possible_r_n_insts =

        qw(   and_n   01      or_n    xor_n   sll_n   srl_n   not_n   neg_n
              callr_n 09      jmpr_n  11      break_n trap_n  ret_n   15
           );

    add_inst_table($inst_tables, {
      name          => "r_n",
      inst_field    => get_inst_field_by_name($inst_fields, "r_n_x"),
      opcodes       => \@possible_r_n_insts,
      parent_table  => $op_inst_table,
      inst_type     => $R_N_INST_TYPE,
    });

    my @possible_spi_n_insts =

        qw(   spinci_n spdeci_n   );

    add_inst_table($inst_tables, {
      name          => "spi_n",
      inst_field    => get_inst_field_by_name($inst_fields, "spi_n_x"),
      opcodes       => \@possible_spi_n_insts,
      parent_table  => $op_inst_table,
      inst_type     => $SPI_N_INST_TYPE,
    });
    
    my @possible_stz_n_insts =

        qw( stwz_n   stbz_n   );

    add_inst_table($inst_tables, {
      name          => "stz_n",
      inst_field    => get_inst_field_by_name($inst_fields, "stz_n_x"),
      opcodes       => \@possible_stz_n_insts,
      parent_table  => $op_inst_table,
      inst_type     => $STZ_N_INST_TYPE,
    });

    my @possible_asi_n_insts =

        qw(   addi_n   subi_n   );

    add_inst_table($inst_tables, {
      name          => "asi_n",
      inst_field    => get_inst_field_by_name($inst_fields, "asi_n_x"),
      opcodes       => \@possible_asi_n_insts,
      parent_table  => $op_inst_table,
      inst_type     => $ASI_N_INST_TYPE,
    });

    my @possible_shi_n_insts =

        qw(   slli_n   srli_n   );

    add_inst_table($inst_tables, {
      name          => "shi_n",
      inst_field    => get_inst_field_by_name($inst_fields, "shi_n_x"),
      opcodes       => \@possible_shi_n_insts,
      parent_table  => $op_inst_table,
      inst_type     => $SHI_N_INST_TYPE,
    });

    my @possible_pp_n_insts =

        qw(   pop_n   push_n    );

    add_inst_table($inst_tables, {
      name          => "pp_n",
      inst_field    => get_inst_field_by_name($inst_fields, "pp_n_x"),
      opcodes       => \@possible_pp_n_insts,
      parent_table  => $op_inst_table,
      inst_type     => $PP_N_INST_TYPE,
    });

    return ($inst_tables, $op_inst_table);
}



sub
add_inst_table
{
    my $inst_tables = shift;
    my $props = shift;

    my $table_name = $props->{name};

    if (defined(get_inst_table_by_name_or_undef($inst_tables, $table_name))) {
        return &$error("Instruction table name '$table_name' already exists");
    }

    my $inst_table = create_inst_table($props);


    push(@$inst_tables, $inst_table);

    return $inst_table;
}



sub
add_inst_descs
{
    my $inst_tables = shift;
    my $top_inst_table = shift;
    my $custom_instructions = shift;
    my $inst_args = shift;

    my $inst_descs = [];



    add_inst_descs_for_inst_table($inst_descs, $inst_tables, $top_inst_table, $inst_args,
      0, 0) || return undef;

    add_custom_inst_descs($inst_descs, $custom_instructions);

    return $inst_descs;
}


sub
add_custom_inst_descs
{
    my $inst_descs = shift;
    my $custom_instructions = shift;

    foreach my $ci_name (sort(keys(%$custom_instructions))) {
        my $props = {};
        $props->{name} = $ci_name;
        $props->{code} = $custom_instructions->{$ci_name}{addr_base};
        $props->{v_decode_func} = \&v_decode_custom_inst;
        $props->{c_decode_func} = \&c_decode_custom_inst;
        $props->{decode_arg} = $custom_instructions;
        $props->{inst_type} = $CUSTOM_INST_TYPE;

        add_inst_desc($inst_descs, $props);
    }
}









sub
v_decode_custom_inst
{
    my $decode_arg = shift; # Custom instructions hash reference
    my $inst_desc = shift;
    my $stage = shift;

    my $inst_name = get_inst_desc_name($inst_desc);

    my $n_decode_expr = nios2_custom_insts::get_n_decode_expr(
      $decode_arg,
      $inst_name,
      $stage . "_iw_custom_n");

    if (!defined($n_decode_expr)) {
        return undef;
    }

    return "(${stage}_op_custom & " . $n_decode_expr . ")";
}


sub
c_decode_custom_inst
{
    return undef;
}



sub
add_inst_descs_for_inst_table
{
    my $inst_descs = shift;
    my $inst_tables = shift;
    my $inst_table = shift; 
    my $inst_args = shift;
    my $parent_c_mask = shift;
    my $parent_c_match = shift;

    my $opcodes = get_inst_table_opcodes($inst_table); 
    my $table_index_inst_field = get_inst_table_inst_field($inst_table);
    my $c_mask = ($parent_c_mask | get_inst_field_shifted_mask($table_index_inst_field));
    my $c_match_lsb = get_inst_field_lsb($table_index_inst_field);



    for (my $code=0; $code < scalar(@$opcodes); $code++) {
        my $opcode = $opcodes->[$code];
        my $opcode_type = get_inst_table_opcode_type($opcode);

        my $name;
        my $mode;

        if ($opcode_type == $OPCODE_TYPE_INST_NAME) {
            $name= $opcode;
            $mode = calc_inst_desc_mode($inst_args, $opcode);
        } elsif ($opcode_type == $OPCODE_TYPE_RESERVED_NUM) {
            $name = sprintf("%s_rsv%02d", get_inst_table_name($inst_table), $code);
            $mode = $INST_DESC_RESERVED_MODE;
        } elsif ($opcode_type == $OPCODE_TYPE_CHILD_TABLE_NAME) {

            next;
        } else {
            return &$error("Unknown opcode_type of '$opcode_type' for opcode '$opcode'");
        }

        add_inst_desc($inst_descs, {
          name          => $name,
          code          => $code,
          mode          => $mode,
          v_decode_func => \&v_decode_inst,
          c_decode_func => \&c_decode_inst,
          decode_arg    => $inst_table,
          inst_type     => get_inst_table_inst_type($inst_table),
          inst_table    => $inst_table,
          c_mask        => $c_mask,
          c_match       => ($parent_c_match | ($code << $c_match_lsb)),
        });
    }


    foreach my $child_table_info (@{get_inst_table_child_table_infos($inst_tables, $inst_table)}) {
        my $child_table = manditory_hash($child_table_info, "child_table");
        my $child_codes = manditory_array($child_table_info, "codes");

        if (scalar(@$child_codes) != 1) {
            return &$error("Child table has multiple codes in parent table!");
        }

        my $child_code = $child_codes->[0];

        add_inst_descs_for_inst_table($inst_descs, $inst_tables, $child_table,
          $inst_args, $c_mask, ($parent_c_match | ($child_code << $c_match_lsb))) || return undef;
    }

    return 1;   # Some defined value
}

sub
calc_inst_desc_mode
{
    my $inst_args = shift;
    my $opcode = shift;

    if (($opcode eq "ldwm") || ($opcode eq "stwm") || ($opcode =~ /_n$/)) {
        my $cdx_present = manditory_bool($inst_args, "cdx_present");
        return $cdx_present ? $INST_DESC_NORMAL_MODE : $INST_DESC_RESERVED_MODE;
    }

    if (($opcode eq "insert") || ($opcode eq "extract") || ($opcode eq "merge")) {
        my $bmx_present = manditory_bool($inst_args, "bmx_present");
        return $bmx_present ? $INST_DESC_NORMAL_MODE : $INST_DESC_RESERVED_MODE;
    }

    if (($opcode eq "mul") || ($opcode eq "muli")) {
        my $hardware_multiply_present = manditory_bool($inst_args, "hardware_multiply_present");
        return $hardware_multiply_present ? $INST_DESC_NORMAL_MODE : $INST_DESC_UNIMP_TRAP_MODE;
    }

    if (($opcode eq "mulxss") || ($opcode eq "mulxsu") || ($opcode eq "mulxuu")) {
        my $hardware_multiply_present = manditory_bool($inst_args, "hardware_multiply_present");
        my $hardware_multiply_omits_msw = manditory_bool($inst_args, "hardware_multiply_omits_msw");
        return ($hardware_multiply_present && !$hardware_multiply_omits_msw) ? 
                                   $INST_DESC_NORMAL_MODE :
                                   $INST_DESC_UNIMP_TRAP_MODE;
    }

    if (($opcode eq "div") || ($opcode eq "divu")) {
        my $hardware_divide_present = manditory_bool($inst_args, "hardware_divide_present");
        return $hardware_divide_present ? $INST_DESC_NORMAL_MODE : $INST_DESC_UNIMP_TRAP_MODE;
    }

    my $advanced_exc = manditory_bool($inst_args, "advanced_exc");


    if ($opcode eq "intr") {
        return $advanced_exc ? $INST_DESC_RESERVED_MODE : $INST_DESC_NORMAL_MODE;
    }



    if ($opcode eq "hbreak") {
        my $hbreak_present = manditory_bool($inst_args, "hbreak_present");

        return ($hbreak_present && !$advanced_exc) ? $INST_DESC_NORMAL_MODE :
                                                     $INST_DESC_RESERVED_MODE;
    }



    if ($opcode eq "crst") {
        my $cpu_reset = manditory_bool($inst_args, "cpu_reset");

        return ($cpu_reset && !$advanced_exc) ? $INST_DESC_NORMAL_MODE :
                                                $INST_DESC_RESERVED_MODE;
    }

    if (($opcode eq "flushi") || ($opcode eq "initi")) {
        my $cache_has_icache = manditory_bool($inst_args, "cache_has_icache");

        return $cache_has_icache ? $INST_DESC_NORMAL_MODE : $INST_DESC_UNIMP_NOP_MODE;
    }

    if (
      ($opcode eq "initd") || ($opcode eq "initda") || 
      ($opcode eq "flushd") || ($opcode eq "flushda")) {
        my $cache_has_dcache = manditory_bool($inst_args, "cache_has_dcache");

        return $cache_has_dcache ? $INST_DESC_NORMAL_MODE : $INST_DESC_UNIMP_NOP_MODE;
    }

    if (($opcode eq "wrprs") || ($opcode eq "rdprs")) {
        my $shadow_present = manditory_bool($inst_args, "shadow_present");

        return $shadow_present ? $INST_DESC_NORMAL_MODE : $INST_DESC_RESERVED_MODE;
    }

    if (($opcode eq "break") || ($opcode eq "break_n") || ($opcode eq "bret")) {
        my $oci_present = manditory_bool($inst_args, "oci_present");
        my $allow_break_inst = manditory_bool($inst_args, "allow_break_inst");

        my $r1 = manditory_int($inst_args, "cpu_arch_rev") == 1;

        return ($oci_present || $allow_break_inst || $r1) ? $INST_DESC_NORMAL_MODE :
                                                     $INST_DESC_RESERVED_MODE;
    }

    if (($opcode eq "ldsex") || ($opcode eq "stsex")) {
        my $mpx_present = manditory_bool($inst_args, "mpx_present");

        return $mpx_present ? $INST_DESC_NORMAL_MODE : $INST_DESC_RESERVED_MODE;
    }


    if (($opcode eq "stc") || ($opcode eq "ldl")) {
        return $INST_DESC_RESERVED_MODE;
    }

    return $INST_DESC_NORMAL_MODE; # default
}

sub
add_inst_desc
{
    my $inst_descs = shift;
    my $props = shift;

    my $inst_name = $props->{name};

    if (defined(get_inst_desc_by_name_or_undef($inst_descs, $inst_name))) {
        return &$error("Instruction description name '$inst_name' already exists");
    }

    my $inst_desc = create_inst_desc($props);


    push(@$inst_descs, $inst_desc);

    return $inst_desc;
}










sub
v_decode_inst
{
    my $decode_arg = shift;
    my $inst_desc = shift;
    my $stage = shift;


    my $inst_table = $decode_arg;

    my $inst_table_name = get_inst_table_name($inst_table);
    my $inst_field = get_inst_table_inst_field($inst_table);
    my $inst_field_name = get_inst_field_name($inst_field);

    my $code = get_inst_desc_code($inst_desc);

    my $decode_expr = "(${stage}_iw_${inst_field_name} == $code)";

    if (get_inst_table_parent_table($inst_table)) {
        $decode_expr .= " & ${stage}_is_${inst_table_name}_inst";
    }

    return $decode_expr;
}












sub
c_decode_inst
{
    my $decode_arg = shift;
    my $inst_desc = shift;


    my $inst_table = $decode_arg;

    my $inst_table_name_uc = uc(get_inst_table_name($inst_table));
    my $inst_field = get_inst_table_inst_field($inst_table);
    my $inst_field_name_uc = uc(get_inst_field_name($inst_field));

    my $inst_name_uc = uc(get_inst_desc_name($inst_desc));

    my $decode_expr = 
      "(GET_IW_${inst_field_name_uc}((Iw)) ==" .
      " ${inst_table_name_uc}_${inst_name_uc})";

    if (get_inst_table_parent_table($inst_table)) {
        $decode_expr .= " && IS_${inst_table_name_uc}_INST(Iw)";
    }

    return $decode_expr;
}


sub
gen_extra_inst_desc_signals
{
    my $gen_info = shift;
    my $extra_gen_func_arg = shift;
    my $stage = shift;
    my $create_register = shift;
    my $previous_stage = shift;
    my $first_stage_with_register = shift;


    my $inst_tables = manditory_array($extra_gen_func_arg, "inst_tables");
    my $top_inst_table = manditory_hash($extra_gen_func_arg, "top_inst_table");



    gen_extra_inst_desc_signals_for_inst_table($gen_info, $inst_tables,
      $top_inst_table, $stage, $create_register, $previous_stage,
      $first_stage_with_register);
}



sub
gen_extra_inst_desc_signals_for_inst_table
{
    my $gen_info = shift;
    my $inst_tables = shift;
    my $inst_table = shift;
    my $stage = shift;
    my $create_register = shift;
    my $previous_stage = shift;
    my $first_stage_with_register = shift;

    my $assignment_func = manditory_code($gen_info, "assignment_func");
    my $register_func = manditory_code($gen_info, "register_func");

    my $child_table_infos = get_inst_table_child_table_infos($inst_tables, $inst_table);

    if (scalar(@$child_table_infos) > 0) {

        my $inst_table_name = get_inst_table_name($inst_table);
        my $inst_field = get_inst_table_inst_field($inst_table);
        my $inst_field_name = get_inst_field_name($inst_field);
        my $opcodes = get_inst_table_opcodes($inst_table); 

        foreach my $child_table_info (@$child_table_infos) {
            my $child_table = manditory_hash($child_table_info, "child_table");
            my $child_table_name = get_inst_table_name($child_table);
            my $lhs = "${stage}_is_${child_table_name}_inst";

            if ($create_register) {
                my $rhs;

                if (($stage eq $first_stage_with_register) &&
                  get_inst_table_parent_table($inst_table)) {


                    my $rhs = get_child_table_code_expr($child_table_info,
                      $stage, $inst_field_name) . 
                      " & ${stage}_is_${inst_table_name}_inst";

                    &$assignment_func({
                      lhs => $lhs,
                      rhs => $rhs,
                      sz => 1,
                      never_export => 1,
                    });
                } else {

                    &$register_func({
                      lhs => $lhs,
                      rhs => "${previous_stage}_is_${child_table_name}_inst",
                      sz => 1,
                      en => $stage . "_en",
                      never_export => 1,
                    });
                }
            } else {



                my $rhs = get_child_table_code_expr($child_table_info,
                  $stage, $inst_field_name);

                if (get_inst_table_parent_table($inst_table)) {
                    $rhs .= " & ${stage}_is_${inst_table_name}_inst";
                }

                &$assignment_func({
                  lhs => $lhs,
                  rhs => $rhs,
                  sz => 1,
                  never_export => 1,
                });
            }


            gen_extra_inst_desc_signals_for_inst_table($gen_info, $inst_tables,
              $child_table, $stage, $create_register, $previous_stage,
              $first_stage_with_register);
        }
    }
}

sub
get_child_table_code_expr
{
    my $child_table_info = shift;
    my $stage = shift;
    my $inst_field_name = shift;

    my $codes = manditory_array($child_table_info, "codes");
    my @code_exprs;
    foreach my $code (@$codes) {


        push(@code_exprs, "(${stage}_iw_${inst_field_name} == $code)");
    }

    return "(" . join('|', @code_exprs) . ")";
}

















sub
r1_add_inst_ctrls
{
    my $inst_args = shift;
    my $inst_descs = shift;

    my $custom_instructions = manditory_hash($inst_args, "custom_instructions");
    my $has_custom_insts = nios2_custom_insts::has_insts($custom_instructions);
    
    my $default_allowed_modes = get_default_inst_ctrl_allowed_modes($inst_args);
    my $exception_allowed_modes = 
      get_exception_inst_ctrl_allowed_modes($inst_args);
    my $shadow_present = manditory_bool($inst_args, "shadow_present");

    my $inst_ctrls = [];


    $unimp_trap_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "unimp_trap",
      insts => get_inst_desc_names_by_modes($inst_descs, 
        [$INST_DESC_UNIMP_TRAP_MODE]),
      allowed_modes => [$INST_DESC_UNIMP_TRAP_MODE],
    });


    $unimp_nop_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "unimp_nop",
      insts => get_inst_desc_names_by_modes($inst_descs, 
        [$INST_DESC_UNIMP_NOP_MODE]),
      allowed_modes => [$INST_DESC_UNIMP_NOP_MODE],
    });


    $reserved_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "reserved",
      insts => get_inst_desc_names_by_modes($inst_descs, [$INST_DESC_RESERVED_MODE]),
      allowed_modes => [$INST_DESC_RESERVED_MODE],
    });


    $illegal_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "illegal",
      ctrls => (["reserved"]),
      allowed_modes => [$INST_DESC_RESERVED_MODE],
    });


    $trap_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "trap_inst",
      insts => ["trap"],
      allowed_modes => $exception_allowed_modes,
    });


    $custom_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "custom",
      insts => nios2_custom_insts::get_ci_names($custom_instructions),
      allowed_modes => $default_allowed_modes,
    });


    $custom_combo_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "custom_combo",
      insts => nios2_custom_insts::get_combo_ci_names($custom_instructions),
      allowed_modes => $default_allowed_modes,
    });


    $custom_multi_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "custom_multi",
      insts => nios2_custom_insts::get_multi_ci_names($custom_instructions),
      allowed_modes => $default_allowed_modes,
    });


    my $supervisor_only_insts = 
      ["initi", "initd", "eret", "bret", "wrctl", "rdctl"];
    if ($shadow_present) {
        push(@$supervisor_only_insts, "rdprs", "wrprs");
    }
    $supervisor_only_ctrl = add_inst_ctrl($inst_ctrls, { 
      name  => "supervisor_only",
      insts => $supervisor_only_insts,
      allowed_modes => $default_allowed_modes,
    });


    $ic_index_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ic_index_inv",
      insts => ["initi", "flushi"],
      allowed_modes => $default_allowed_modes,
    });


    $invalidate_i_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "invalidate_i",
      ctrls => ["ic_index_inv", "crst"],
      allowed_modes => $default_allowed_modes,
    });


    $flush_pipe_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "flush_pipe",
      insts => ["flushp","bret","wrprs"],
      ctrls => ["ic_index_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $jmp_indirect_non_trap_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_indirect_non_trap",
      insts => ["ret","jmp","opx_rsv21","callr"],
      allowed_modes => $default_allowed_modes,
    });


    $jmp_indirect_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_indirect",
      insts => ["eret","bret","opx_rsv17","opx_rsv25"],
      ctrls => ["jmp_indirect_non_trap"],
      allowed_modes => $default_allowed_modes,
    });


    $jmp_direct_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_direct",
      insts => ["call","jmpi"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_lsw_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_lsw",
      insts => ["muli","mul","opx_rsv47","opx_rsv55","opx_rsv63"],
      allowed_modes => $default_allowed_modes,
    });


    $mulx_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mulx",
      insts => ["mulxuu","opx_rsv15","mulxsu","mulxss"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul",
      ctrls => ["mul_lsw", "mulx"],
      allowed_modes => $default_allowed_modes,
    });

    $div_unsigned_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "div_unsigned",
      insts => ["divu"],
      allowed_modes => $default_allowed_modes,
    });

    $div_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "div_signed",
      insts => ["div"],
      allowed_modes => $default_allowed_modes,
    });


    $div_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "div",
      ctrls => ["div_unsigned", "div_signed"],
      allowed_modes => $default_allowed_modes,
    });



    $implicit_dst_retaddr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "implicit_dst_retaddr",
      insts => ["call","op_rsv02"],
      allowed_modes => $default_allowed_modes,
    });



    $implicit_dst_eretaddr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "implicit_dst_eretaddr",
      ctrls => ["unimp_trap", "illegal"],
      allowed_modes => $exception_allowed_modes,
    });


    $intr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "intr",
      insts => ["intr","opx_rsv60"],
      allowed_modes => $default_allowed_modes,
    });


    $exception_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "exception",
      insts => ["trap","opx_rsv44"],
      ctrls => ["unimp_trap", "illegal", "intr"],
      allowed_modes => $exception_allowed_modes,
    });


    $break_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "break",
      insts => ["break","hbreak"],
      allowed_modes => $default_allowed_modes,
    });


    $crst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "crst",
      insts => ["crst","opx_rsv63"],
      allowed_modes => $default_allowed_modes,
    });


    $wr_ctl_reg_flush_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "wr_ctl_reg_flush",
      insts => ["wrctl","bret","eret"],
      ctrls => ["exception", "break", "crst"],
      allowed_modes => $exception_allowed_modes,
    });


    $rd_ctl_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rd_ctl_reg",
      insts => ["rdctl"],
      allowed_modes => $default_allowed_modes,
    });


    $uncond_cti_non_br_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "uncond_cti_non_br",
      ctrls => ["jmp_direct", "jmp_indirect"],
      allowed_modes => $default_allowed_modes,
    });


    $retaddr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "retaddr",
      insts => ["call","op_rsv02","nextpc","callr"],
      ctrls => ["exception", "break"],
      allowed_modes => $exception_allowed_modes,
    });


    $shift_left_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_left",
      insts => ["slli","opx_rsv50","sll","opx_rsv51"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_logical_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_logical",
      insts => ["slli","sll","srli","srl"],
      allowed_modes => $default_allowed_modes,
    });


    $rot_left_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rot_left",
      insts => ["roli","opx_rsv34","rol","opx_rsv35"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_left_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot_left",
      ctrls => ["shift_left","rot_left"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_right_logical_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_right_logical",
      insts => ["srli","srl"],
      allowed_modes => $default_allowed_modes,
    });
    $shift_right_arith_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_right_arith",
      insts => ["srai","sra"],
      allowed_modes => $default_allowed_modes,
    });
    $shift_right_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_right",
      ctrls => ["shift_right_logical","shift_right_arith"],
      allowed_modes => $default_allowed_modes,
    });


    $rot_right_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rot_right",
      insts => ["opx_rsv10","ror","opx_rsv42","opx_rsv43"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_right_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot_right",
      ctrls => ["shift_right","rot_right"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot",
      ctrls => ["shift_rot_left","shift_rot_right"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot_imm",
      insts => 
        ["roli","opx_rsv10","slli","srli","opx_rsv34","opx_rsv42","opx_rsv50","srai"],
      allowed_modes => $default_allowed_modes,
    });


    $rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rot",
      ctrls => ["rot_left","rot_right"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_reg",
      insts => ["and","or","xor","nor"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_hi_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_hi_imm16",
      insts => ["andhi","orhi","xorhi"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_lo_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_lo_imm16",
      insts => ["andi","ori","xori"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_imm16",
      ctrls => ["logic_hi_imm16","logic_lo_imm16"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic",
      ctrls => ["logic_reg","logic_imm16"],
      allowed_modes => $default_allowed_modes,
    });


    $hi_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "hi_imm16",
      ctrls => ["logic_hi_imm16"],
      allowed_modes => $default_allowed_modes,
    });



    $andc_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "andc",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });



    $set_src2_rem_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "set_src2_rem_imm",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });





    $unsigned_lo_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "unsigned_lo_imm16",
      insts => ["cmpgeui","cmpltui"],
      ctrls => ["logic_lo_imm16","shift_rot_imm"],
      allowed_modes => $default_allowed_modes,
    });



    $signed_imm12_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "signed_imm12",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });


    $arith_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "arith_imm16",
      insts => ["addi","muli"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_imm16",
      insts => ["cmpgei","cmplti","cmpnei","cmpgeui","cmpltui","cmpeqi"],
      allowed_modes => $default_allowed_modes,
    });


    $jmpi_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmpi",
      insts => ["jmpi","op_rsv09","op_rsv17","op_rsv25","op_rsv33","op_rsv41","op_rsv49","op_rsv57"],
      allowed_modes => $default_allowed_modes,
    });



    $cmp_imm16_with_call_jmpi_rdprs_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_imm16_with_call_jmpi_rdprs",
      insts => ["call","rdprs"],
      ctrls => ["cmp_imm16","jmpi"],
      allowed_modes => $default_allowed_modes,
    });
    

    $cmp_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_reg",
      insts => 
        ["opx_rsv00","cmpge","cmplt","cmpne","cmpgeu","cmpltu","cmpeq","opx_rsv56"],
      allowed_modes => $default_allowed_modes,
    });


    $src_imm5_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src_imm5",
      insts => ["trap","break"],
      ctrls => ["shift_rot_imm"],
      allowed_modes => $default_allowed_modes,
    });


    $src_imm5_shift_rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src_imm5_shift_rot",
      ctrls => ["shift_rot_imm"],
      allowed_modes => $default_allowed_modes,
    });
    

    $cmp_with_lt_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_lt",
      insts => ["cmplti","cmpltui","cmplt","cmpltu"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_with_eq_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_eq",
      insts => ["cmpgei","cmpgeui","cmpeqi","cmpge","cmpgeu","cmpeq"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_with_ge_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_ge",
      insts => ["cmpgei","cmpgeui","cmpge","cmpgeu"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_with_ne_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_ne",
      insts => ["cmpnei","cmpne"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_alu_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_alu_signed",
      insts => ["cmpge","cmpgei","cmplt","cmplti"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp",
      ctrls => ["cmp_imm16","cmp_reg"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_lt_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_lt",
      insts => ["blt","bltu"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_ge_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_ge",
      insts => ["bge","op_rsv10","bgeu","op_rsv42"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_eq_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_eq",
      insts => ["bge","op_rsv10","bgeu","op_rsv42","beq","op_rsv34"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_ne_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_ne",
      insts => ["bne","op_rsv62"],
      allowed_modes => $default_allowed_modes,
    });


    $br_alu_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_alu_signed",
      insts => ["bge","blt"],
      allowed_modes => $default_allowed_modes,
    });


    $br_cond_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_cond",
      insts => 
        ["bge","op_rsv10","blt","bne","op_rsv62","bgeu","op_rsv42","bltu","beq","op_rsv34"],
      allowed_modes => $default_allowed_modes,
    });


    $br_uncond_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_uncond",
      insts => ["br","op_rsv02"],
      allowed_modes => $default_allowed_modes,
    });



    $br_always_pred_taken_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_always_pred_taken",
      allowed_modes => $default_allowed_modes,
    });


    $br_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br",
      insts => ["br","bge","blt","bne","beq","bgeu","bltu","op_rsv62"],
      allowed_modes => $default_allowed_modes,
    });


    $alu_subtract_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "alu_subtract",
      insts => ["sub","opx_rsv25"],
      ctrls => ["cmp_with_lt","br_with_lt","cmp_with_ge","br_with_ge"],
      allowed_modes => $default_allowed_modes,
    });


    $alu_signed_comparison_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "alu_signed_comparison",
      ctrls => ["cmp_alu_signed","br_alu_signed"],
      allowed_modes => $default_allowed_modes,
    });


    $br_cmp_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_cmp",
      ctrls => ["br", "cmp"],
      allowed_modes => $default_allowed_modes,
    });



    $br_cmp_eq_ne_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_cmp_eq_ne",
      ctrls => ["cmp_with_eq","cmp_with_ne","br_with_eq","br_with_ne"],
      allowed_modes => $default_allowed_modes,
    });


    $ld8_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld8",
      insts => ["ldb","ldbu","ldbio","ldbuio"],
      allowed_modes => $default_allowed_modes,
    });


    $ld16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld16",
      insts => ["ldhu","ldh","ldhio","ldhuio"],
      allowed_modes => $default_allowed_modes,
    });


    $ld8_ld16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld8_ld16",
      ctrls => ["ld8", "ld16"],
      allowed_modes => $default_allowed_modes,
    });


    $ld32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld32",
      insts => ["ldw","ldl","ldwio","op_rsv63"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_signed",
      insts => ["ldb","ldh","ldl","ldw","ldbio","ldhio","ldwio","op_rsv63"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_unsigned_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_unsigned",
      insts => ["ldbu","ldhu","ldbuio","ldhuio"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "ld",
      ctrls => ["ld_signed","ld_unsigned"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_imm_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "ld_imm",
      ctrls => ["ld",],
      allowed_modes => $default_allowed_modes,
    });



    $ld_ex_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "ld_ex",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });



    $dcache_management_nop_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dcache_management_nop",
      insts => ["initd","initda","flushd","flushda"],
      allowed_modes => [$INST_DESC_UNIMP_NOP_MODE],
    });


    $ld_dcache_management_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_dcache_management",
      insts => ["initd","initda","flushd","flushda"],
      ctrls => ["ld"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_non_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_non_io",
      insts => ["ldbu","ldhu","ldb","ldh","ldw","ldl"],
      allowed_modes => $default_allowed_modes,
    });


    $st8_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st8",
      insts => ["stb","stbio"],
      allowed_modes => $default_allowed_modes,
    });


    $st16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st16",
      insts => ["sth","op_rsv09","sthio","op_rsv41"],
      allowed_modes => $default_allowed_modes,
    });


    $st_non32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_non32",
      insts => [ "stb","stbio", "sth","sthio" ],
      allowed_modes => $default_allowed_modes,
    });


    $st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st32",
      insts => ["stw","op_rsv17","stc","op_rsv25","stwio","op_rsv49","op_rsv61","op_rsv57"],
      allowed_modes => $default_allowed_modes,
    });



    $st_ex_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "st_ex",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });


    $st_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st",
      insts => ["stb","sth","stw","stc","stbio","sthio","stwio","op_rsv61"],
      allowed_modes => $default_allowed_modes,
    });


    $st_non_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_non_io",
      insts => ["stb","sth","stw","stc"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st",
      ctrls => ["ld","st"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_io",
      ctrls => ["ld_io","st_io"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_non_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_non_io",
      ctrls => ["ld_non_io","st_non_io"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_non_io_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_non_io_non_st32",
      insts => ["stb", "sth"],
      ctrls => ["ld_non_io"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_non_st32",
      ctrls => ["ld","st8","st16"],
      allowed_modes => $default_allowed_modes,
    });



    $ld_st_ex_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_ex",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });


    $mem_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem",
      ctrls => ["ld_dcache_management","st"],
      allowed_modes => $default_allowed_modes,
    });


    $mem_data_access_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem_data_access",
      insts => ["flushda", "initda"],
      ctrls => ["ld","st"],
      allowed_modes => $default_allowed_modes,
    });


    $mem8_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem8",
      ctrls => ["ld8","st8"],
      allowed_modes => $default_allowed_modes,
    });


    $mem16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem16",
      ctrls => ["ld16","st16"],
      allowed_modes => $default_allowed_modes,
    });


    $mem32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem32",
      ctrls => ["ld32","st32"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_index_nowb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_index_nowb_inv",
      insts => ["initd","op_rsv49"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_addr_nowb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_addr_nowb_inv",
      insts => ["initda","op_rsv17"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_index_wb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_index_wb_inv",
      insts => ["flushd","op_rsv57"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_addr_wb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_addr_wb_inv",
      insts => ["flushda","op_rsv25"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_index_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_index_inv",
      ctrls => ["dc_index_nowb_inv","dc_index_wb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_addr_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_addr_inv",
      ctrls => ["dc_addr_nowb_inv","dc_addr_wb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_wb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_wb_inv",
      ctrls => ["dc_index_wb_inv","dc_addr_wb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_nowb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_nowb_inv",
      ctrls => ["dc_index_nowb_inv","dc_addr_nowb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dcache_management_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dcache_management",
      ctrls => ["dc_index_inv","dc_addr_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_io",
      insts => ["ldbuio","ldhuio","ldbio","ldhio","ldwio","op_rsv63"],
      allowed_modes => $default_allowed_modes,
    });
    $st_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_io",
      insts => 
        ["stbio","op_rsv33","sthio","op_rsv41","stwio","op_rsv49","op_rsv61","op_rsv57"],
      allowed_modes => $default_allowed_modes,
    });
    $st_io_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_io_non_st32",
      insts => ["stbio","op_rsv33","sthio","op_rsv41"],
      allowed_modes => $default_allowed_modes,
    });
    $st_non_io_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_non_io_non_st32",
      insts => ["stb", "sth"],
      allowed_modes => $default_allowed_modes,
    });
    $mem_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem_io",
      ctrls => ["ld_io","st_io"],
      allowed_modes => $default_allowed_modes,
    });



    $a_not_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "a_not_src",
      ctrls => ["jmp_direct"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_readra)";
          } :
          undef,
      c_expr_func => 
          sub {
              return "  || (IS_CUSTOM_INST(Iw) && !GET_IW_CUSTOM_READRA(Iw))";
          },
      allowed_modes => $default_allowed_modes,
    });



    my @b_field_allowed_modes = 
      (@$default_allowed_modes, $INST_DESC_UNIMP_NOP_MODE);







    $b_not_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "b_not_src",
      ctrls => ["arith_imm16","logic_imm16","cmp_imm16_with_call_jmpi_rdprs",
                "ld","dcache_management_nop"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_readrb)";
          } :
          undef,
      c_expr_func => 
          sub {
              return "  || (IS_CUSTOM_INST(Iw) && !GET_IW_CUSTOM_READRB(Iw))";
          },
      allowed_modes => \@b_field_allowed_modes,
    });






    $b_is_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "b_is_dst",
      ctrls => ["b_not_src"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "& ~${stage}_op_custom";
          } :
          undef,
      allowed_modes => \@b_field_allowed_modes,
    });





    $ignore_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ignore_dst",
      ctrls => ["br","st","jmpi"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_writerc)";
          } :
          undef,
      c_expr_func => 
          sub {
              return "  || (IS_CUSTOM_INST(Iw) && !GET_IW_CUSTOM_WRITERC(Iw))";
          },
      allowed_modes => $default_allowed_modes,
    });





    $ignore_dst_or_ld_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ignore_dst_or_ld",
      ctrls => ["ignore_dst","ld"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_writerc)";
          } :
          undef,
      allowed_modes => $default_allowed_modes,
    });





    $src2_choose_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src2_choose_imm",
      ctrls => ["b_not_src","st","shift_rot_imm"],
      allowed_modes => \@b_field_allowed_modes,
    });


    $wrctl_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "wrctl_inst",
      insts => ["wrctl"],
      allowed_modes => $default_allowed_modes,
    });
    $rdctl_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rdctl_inst",
      insts => ["rdctl"],
      allowed_modes => $default_allowed_modes,
    });



    $intr_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "intr_inst",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });


    $rdprs_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rdprs",
      insts => ["rdprs","op_rsv57"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_src1_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_src1_signed",
      insts => ["mulxss","mulxsu"],
      allowed_modes => $default_allowed_modes,
    });
    $mul_src2_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_src2_signed",
      insts => ["mulxss"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_shift_src1_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_shift_src1_signed",
      ctrls => ["mul_src1_signed","shift_right_arith"],
      allowed_modes => $default_allowed_modes,
    });

    $mul_shift_src2_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_shift_src2_signed",
      ctrls => ["mul_src2_signed"],
      allowed_modes => $default_allowed_modes,
    });

    $mul_shift_rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_shift_rot",
      ctrls => ["mul", "shift_rot"],
      allowed_modes => $default_allowed_modes,
    });



    $dont_display_dst_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dont_display_dst_reg",
      insts => ["eret","bret","sync","callr","wrctl","initi","flushi",
                "flushp","initda","flushda","initd","flushd","jmp","ret"],
      ctrls => ["jmp_direct","exception","break","crst"],
      allowed_modes => get_all_inst_desc_modes(),
    });



    $dont_display_src1_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dont_display_src1_reg",
      insts => ["eret","bret","sync","br","ret","nextpc","rdctl","flushp"],
      ctrls => ["exception","break","crst"],
      allowed_modes => get_all_inst_desc_modes(),
    });



    $dont_display_src2_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dont_display_src2_reg",
      insts => ["jmp","ret","eret","bret","sync","br","callr","nextpc","rdctl",
                "wrctl","flushp","initi","flushi"],
      ctrls => ["exception","break","crst","shift_rot_imm"],
      allowed_modes => get_all_inst_desc_modes(),
    });




    $src1_no_x_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src1_no_x",
      insts => ["wrctl"],
      ctrls => ["cmp","mem","mul","br","jmp_indirect"],
      allowed_modes => get_all_inst_desc_modes(),
    });




    $src2_no_x_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src2_no_x",
      ctrls => ["cmp","mem","mul","br"],
      allowed_modes => get_all_inst_desc_modes(),
    });



    $bmx_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "bmx",
      insts => [],
      allowed_modes => $default_allowed_modes,
    });

    return $inst_ctrls;
}

















sub
r2_add_inst_ctrls
{
    my $inst_args = shift;
    my $inst_descs = shift;
    my $prefix = shift;

    my $custom_instructions = manditory_hash($inst_args, "custom_instructions");
    my $has_custom_insts = nios2_custom_insts::has_insts($custom_instructions);
    
    my $default_allowed_modes = get_default_inst_ctrl_allowed_modes($inst_args);
    my $exception_allowed_modes = get_exception_inst_ctrl_allowed_modes($inst_args);
    my $shadow_present = manditory_bool($inst_args, "shadow_present");
    my $cdx_present = manditory_bool($inst_args, "cdx_present");

    my $inst_ctrls = [];


    $unimp_trap_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "unimp_trap",
      insts => get_inst_desc_names_by_modes($inst_descs, [$INST_DESC_UNIMP_TRAP_MODE]),
      allowed_modes => [$INST_DESC_UNIMP_TRAP_MODE],
    });


    $unimp_nop_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "unimp_nop",
      insts => get_inst_desc_names_by_modes($inst_descs, [$INST_DESC_UNIMP_NOP_MODE]),
      allowed_modes => [$INST_DESC_UNIMP_NOP_MODE],
    });


    $reserved_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "reserved",
      insts => get_inst_desc_names_by_modes($inst_descs, [$INST_DESC_RESERVED_MODE]),
      allowed_modes => [$INST_DESC_RESERVED_MODE],
    });


    $illegal_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "illegal",
      ctrls => (["reserved"]),
      allowed_modes => [$INST_DESC_RESERVED_MODE],
    });


    $trap_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "trap_inst",
      insts => ["trap","trap_n"],
      allowed_modes => $exception_allowed_modes,
    });


    $custom_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "custom",
      insts => nios2_custom_insts::get_ci_names($custom_instructions),
      allowed_modes => $default_allowed_modes,
    });


    $custom_combo_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "custom_combo",
      insts => nios2_custom_insts::get_combo_ci_names($custom_instructions),
      allowed_modes => $default_allowed_modes,
    });


    $custom_multi_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "custom_multi",
      insts => nios2_custom_insts::get_multi_ci_names($custom_instructions),
      allowed_modes => $default_allowed_modes,
    });


    my $supervisor_only_insts = 
      ["initi", "initd", "eret", "bret", "wrctl", "rdctl", "wrpie", "eni"];
    if ($shadow_present) {
        push(@$supervisor_only_insts, "rdprs", "wrprs");
    }
    $supervisor_only_ctrl = add_inst_ctrl($inst_ctrls, { 
      name  => "supervisor_only",
      insts => $supervisor_only_insts,
      allowed_modes => $default_allowed_modes,
    });


    $ic_index_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ic_index_inv",
      insts => ["initi", "flushi"],
      allowed_modes => $default_allowed_modes,
    });


    $invalidate_i_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "invalidate_i",
      ctrls => ["ic_index_inv", "crst"],
      allowed_modes => $default_allowed_modes,
    });


    $flush_pipe_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "flush_pipe",
      insts => ["flushp","bret","wrprs"],
      ctrls => ["ic_index_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $jmp_indirect_non_trap_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_indirect_non_trap",
      insts => ["ret","jmp","opx_rsv21","callr","ret_n","jmpr_n","callr_n"],
      allowed_modes => $default_allowed_modes,
    });


    $jmp_indirect_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_indirect",
      insts => ["eret","bret","opx_rsv17","opx_rsv25"],
      ctrls => ["jmp_indirect_non_trap"],
      allowed_modes => $default_allowed_modes,
    });
    

    $jmp_indirect_word_aligned_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_indirect_word_aligned",
      insts => ["callr","callr_n"],
      allowed_modes => $default_allowed_modes,
    });
    

    $jmp_indirect_hword_aligned_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_indirect_hword_aligned",
      insts => ["ret","eret","bret","opx_rsv17","opx_rsv25","jmp","opx_rsv21","jmpr_n","ret_n"],
      allowed_modes => $default_allowed_modes,
    });


    $jmp_direct_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmp_direct",
      insts => ["call","jmpi"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_lsw_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_lsw",
      insts => ["muli","mul"],
      allowed_modes => $default_allowed_modes,
    });


    $mulx_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mulx",
      insts => ["mulxuu","opx_rsv15","mulxsu","mulxss"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul",
      ctrls => ["mul_lsw", "mulx"],
      allowed_modes => $default_allowed_modes,
    });

    $div_unsigned_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "div_unsigned",
      insts => ["divu"],
      allowed_modes => $default_allowed_modes,
    });

    $div_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "div_signed",
      insts => ["div","opx_rsv33"],
      allowed_modes => $default_allowed_modes,
    });


    $div_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "div",
      ctrls => ["div_unsigned", "div_signed"],
      allowed_modes => $default_allowed_modes,
    });



    $implicit_dst_retaddr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "implicit_dst_retaddr",
      insts => ["call","callr","callr_n"],
      allowed_modes => $default_allowed_modes,
    });



    $implicit_dst_eretaddr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "implicit_dst_eretaddr",
      ctrls => ["unimp_trap", "illegal"],
      allowed_modes => $exception_allowed_modes,
    });


    $intr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "intr",
      insts => ["intr"],
      allowed_modes => $default_allowed_modes,
    });


    $exception_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "exception",
      insts => ["trap","trap_n"],
      ctrls => ["unimp_trap", "illegal", "intr"],
      allowed_modes => $exception_allowed_modes,
    });


    $break_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "break",
      insts => ["break","hbreak","break_n"],
      allowed_modes => $default_allowed_modes,
    });


    $crst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "crst",
      insts => ["crst"],
      allowed_modes => $default_allowed_modes,
    });


    $wr_ctl_reg_flush_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "wr_ctl_reg_flush",
      insts => ["wrctl","bret","eret"],
      ctrls => ["exception", "break", "crst"],
      allowed_modes => $exception_allowed_modes,
    });


    $rd_ctl_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rd_ctl_reg",
      insts => ["rdctl","wrpie"],
      allowed_modes => $default_allowed_modes,
    });


    $uncond_cti_non_br_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "uncond_cti_non_br",
      ctrls => ["jmp_direct", "jmp_indirect"],
      allowed_modes => $default_allowed_modes,
    });


    $retaddr_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "retaddr",
      insts => ["call","nextpc","callr","callr_n"],
      ctrls => ["exception", "break"],
      allowed_modes => $exception_allowed_modes,
    });


    $shift_left_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_left",
      insts => ["slli","sll","insert","opx_rsv34","sll_n","slli_n","merge"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_logical_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_logical",
      insts => [
         "slli","sll","srli","srl","insert","extract","opx_rsv34","opx_rsv50",
         "sll_n","slli_n","srl_n","srli_n"],
      allowed_modes => $default_allowed_modes,
    });


    $rot_left_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rot_left",
      insts => ["roli","rol"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_left_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot_left",
      ctrls => ["shift_left","rot_left"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_right_logical_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_right_logical",
      insts => ["srli","srl","extract","opx_rsv50","srl_n","srli_n"],
      allowed_modes => $default_allowed_modes,
    });
    $shift_right_arith_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_right_arith",
      insts => ["srai","sra"],
      allowed_modes => $default_allowed_modes,
    });
    $shift_right_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_right",
      ctrls => ["shift_right_logical","shift_right_arith"],
      allowed_modes => $default_allowed_modes,
    });


    $rot_right_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rot_right",
      insts => ["opx_rsv10","ror"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_right_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot_right",
      ctrls => ["shift_right","rot_right"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot",
      ctrls => ["shift_rot_left","shift_rot_right"],
      allowed_modes => $default_allowed_modes,
    });


    $shift_rot_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "shift_rot_imm",
      insts => 
        ["roli","opx_rsv10","slli","srli","opx_rsv34","opx_rsv42","opx_rsv50","srai"],
      allowed_modes => $default_allowed_modes,
    });


    $rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rot",
      ctrls => ["rot_left","rot_right"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_reg",
      insts => ["and","or","xor","nor","and_n","not_n","or_n","xor_n"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_hi_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_hi_imm16",
      insts => ["andhi","orhi","xorhi","andchi"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_lo_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_lo_imm16",
      insts => ["andi","ori","xori","andci"],
      allowed_modes => $default_allowed_modes,
    });


    $logic_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic_imm16",
      ctrls => ["logic_hi_imm16","logic_lo_imm16"],
      allowed_modes => $default_allowed_modes,
    });



    $logic_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "logic",
      insts => ["andi_n"],
      ctrls => ["logic_reg","logic_imm16"],
      allowed_modes => $default_allowed_modes,
    });



    $hi_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "hi_imm16",
      ctrls => ["logic_hi_imm16","ld_st_ex"],
      allowed_modes => $default_allowed_modes,
    });


    $andc_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "andc",
      insts => ["andchi","andci"],
      allowed_modes => $default_allowed_modes,
    });


    $set_src2_rem_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "set_src2_rem_imm",
      ctrls => ["andc"],
      allowed_modes => $default_allowed_modes,
    });






    $unsigned_lo_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "unsigned_lo_imm16",
      insts => ["cmpgeui","cmpltui"],
      ctrls => ["logic_lo_imm16","shift_rot_imm","ld_st_ex"],
      allowed_modes => $default_allowed_modes,
    });


    $signed_imm12_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "signed_imm12",
      insts => ["ldbio","stbio","ldbuio","ldhio","sthio","ldhuio","rdprs","ldwio","stwio","initd","initda","flushd","flushda",
      "dcache_rsv04","dcache_rsv05","dcache_rsv06","dcache_rsv07","dcache_rsv08","dcache_rsv09","dcache_rsv10","dcache_rsv11","dcache_rsv12",
      "dcache_rsv13","dcache_rsv14","dcache_rsv15","dcache_rsv16","dcache_rsv17","dcache_rsv18","dcache_rsv19","dcache_rsv20","dcache_rsv21",
      "dcache_rsv21","dcache_rsv22","dcache_rsv23","dcache_rsv24","dcache_rsv25","dcache_rsv26","dcache_rsv27","dcache_rsv28","dcache_rsv29",
      "dcache_rsv30","dcache_rsv31","i12_rsv10","i12_rsv14","i12_rsv15"],
      allowed_modes => $default_allowed_modes,
    });


    $arith_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "arith_imm16",
      insts => ["addi","muli"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_imm16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_imm16",
      insts => ["cmpgei","cmplti","cmpnei","cmpgeui","cmpltui","cmpeqi"],
      allowed_modes => $default_allowed_modes,
    });


    $jmpi_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "jmpi",
      insts => ["jmpi","op_rsv24"],
      allowed_modes => $default_allowed_modes,
    });



    $cmp_imm16_with_call_jmpi_rdprs_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_imm16_with_call_jmpi_rdprs",
      insts => ["call","rdprs"],
      ctrls => ["cmp_imm16","jmpi"],
      allowed_modes => $default_allowed_modes,
    });
    

    $cmp_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_reg",
      insts => ["cmpge","cmplt","cmpne","cmpgeu","cmpltu","cmpeq"],
      allowed_modes => $default_allowed_modes,
    });


    $src_imm5_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src_imm5",
      insts => ["trap","break"],
      ctrls => ["shift_rot_imm"],
      allowed_modes => $default_allowed_modes,
    });


    $src_imm5_shift_rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src_imm5_shift_rot",
      ctrls => ["shift_rot_imm"],
      allowed_modes => $default_allowed_modes,
    });
    

    $src_imm3_shift_rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src_imm3_shift_rot",
      insts => ["slli_n","srli_n"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_with_lt_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_lt",
      insts => ["cmplti","cmpltui","cmplt","cmpltu"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_with_eq_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_eq",
      insts => ["cmpgei","cmpgeui","cmpeqi","cmpge","cmpgeu","cmpeq"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_with_ge_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_ge",
      insts => ["cmpgei","cmpgeui","cmpge","cmpgeu"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_with_ne_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_with_ne",
      insts => ["cmpnei","cmpne"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_alu_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp_alu_signed",
      insts => ["cmpge","cmpgei","cmplt","cmplti"],
      allowed_modes => $default_allowed_modes,
    });


    $cmp_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cmp",
      ctrls => ["cmp_imm16","cmp_reg"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_lt_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_lt",
      insts => ["blt","op_rsv24","bltu","op_rsv56"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_ge_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_ge",
      insts => ["bge","op_rsv16","bgeu"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_eq_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_eq",
      insts => ["bge","op_rsv16","bgeu","beq","beqz_n"],
      allowed_modes => $default_allowed_modes,
    });


    $br_with_ne_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_with_ne",
      insts => ["bne","bnez_n"],
      allowed_modes => $default_allowed_modes,
    });


    $br_alu_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_alu_signed",
      insts => ["bge","op_rsv16","blt","op_rsv24"],
      allowed_modes => $default_allowed_modes,
    });


    $br_cond_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_cond",
      insts => 
        ["bge","op_rsv16","blt","op_rsv24","bne","bgeu","bltu","op_rsv56","beq","beqz_n","bnez_n"],
      allowed_modes => $default_allowed_modes,
    });


    $br_uncond_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_uncond",
      insts => ["br","op_rsv10", "br_n"],
      allowed_modes => $default_allowed_modes,
    });



    $br_always_pred_taken_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_always_pred_taken",
      allowed_modes => $default_allowed_modes,
    });


    $br_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br",
      insts => $cdx_present ? ["br","op_rsv10","bge","blt","bne","beq","bgeu","bltu","br_n","beqz_n","bnez_n"] :
                              ["br","op_rsv10","bge","blt","bne","beq","bgeu","bltu"] ,
      allowed_modes => $default_allowed_modes,
    });


    $alu_subtract_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "alu_subtract",
      insts => ["sub","opx_rsv25","sub_n","subi_n","spdeci_n","neg_n"],
      ctrls => ["cmp_with_lt","br_with_lt","cmp_with_ge","br_with_ge"],
      allowed_modes => $default_allowed_modes,
    });
    


    $a_is_sp_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "a_is_sp",
      insts => ["spdeci_n","spinci_n","spaddi_n"],
      allowed_modes => $default_allowed_modes,
    });

    $dst_is_sp_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dst_is_sp",
      insts => ["spdeci_n","spinci_n"],
      allowed_modes => $default_allowed_modes,
    });


    $alu_signed_comparison_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "alu_signed_comparison",
      ctrls => ["cmp_alu_signed","br_alu_signed"],
      allowed_modes => $default_allowed_modes,
    });


    $br_cmp_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_cmp",
      ctrls => ["br", "cmp"],
      allowed_modes => $default_allowed_modes,
    });



    $br_cmp_eq_ne_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "br_cmp_eq_ne",
      ctrls => ["cmp_with_eq","cmp_with_ne","br_with_eq","br_with_ne"],
      allowed_modes => $default_allowed_modes,
    });


    $ld8_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld8",
      insts => ["ldb","ldbu","ldbio","ldbuio","ldbu_n"],
      allowed_modes => $default_allowed_modes,
    });


    $ld16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld16",
      insts => ["ldhu","ldh","ldhio","ldhuio","ldhu_n"],
      allowed_modes => $default_allowed_modes,
    });


    $ld8_ld16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld8_ld16",
      ctrls => ["ld8", "ld16"],
      allowed_modes => $default_allowed_modes,
    });


    $ld32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld32",
      insts => ["ldw","ldwio","ldex","ldsex","ldw_n","ldwsp_n"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_signed",
      insts => ["ldb","ldh","ldw","ldbio","ldhio","ldwio","ldw_n","ldwsp_n"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_unsigned_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_unsigned",
      insts => ["ldbu","ldhu","ldbuio","ldhuio","ldbu_n","ldhu_n"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "ld",
      ctrls => ["ld_signed","ld_unsigned","ld_ex"],
      allowed_modes => $default_allowed_modes,
    });
    

    $ld_imm_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "ld_imm",
      insts => ["ldb","ldh","ldw","ldbio","ldhio","ldwio",
                "ldbu","ldhu","ldbuio","ldhuio"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_ex_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "ld_ex",
      insts => ["ldex","ldsex"],
      allowed_modes => $default_allowed_modes,
    });


    $multiple_loads_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "multiple_loads",
      insts => ["ldwm","pop_n"],
      allowed_modes => $default_allowed_modes,
    });


    $multiple_stores_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "multiple_stores",
      insts => ["stwm","push_n"],
      allowed_modes => $default_allowed_modes,
    });


    $multiple_loads_stores_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "multiple_loads_stores",
      ctrls => ["multiple_loads","multiple_stores"],
      allowed_modes => $default_allowed_modes,
    });




    $dcache_management_nop_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dcache_management_nop",
      insts => ["initd","initda","flushd","flushda","dcache_rsv04","dcache_rsv05","dcache_rsv06","dcache_rsv07","dcache_rsv08","dcache_rsv09","dcache_rsv10","dcache_rsv11","dcache_rsv12","dcache_rsv13","dcache_rsv14","dcache_rsv15",
      "dcache_rsv16","dcache_rsv17","dcache_rsv18","dcache_rsv19","dcache_rsv20","dcache_rsv21","dcache_rsv21","dcache_rsv22","dcache_rsv23","dcache_rsv24","dcache_rsv25","dcache_rsv26","dcache_rsv27","dcache_rsv28","dcache_rsv29","dcache_rsv30","dcache_rsv31"],
      allowed_modes => [$INST_DESC_UNIMP_NOP_MODE],
    });


    my @b_field_allowed_modes = (@$default_allowed_modes, $INST_DESC_UNIMP_NOP_MODE);
      

    $dcache_management_only_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dcache_management_only",
      insts => ["initd","initda","flushd","flushda","dcache_rsv04","dcache_rsv05","dcache_rsv06","dcache_rsv07","dcache_rsv08","dcache_rsv09","dcache_rsv10","dcache_rsv11","dcache_rsv12","dcache_rsv13","dcache_rsv14","dcache_rsv15",
      "dcache_rsv16","dcache_rsv17","dcache_rsv18","dcache_rsv19","dcache_rsv20","dcache_rsv21","dcache_rsv21","dcache_rsv22","dcache_rsv23","dcache_rsv24","dcache_rsv25","dcache_rsv26","dcache_rsv27","dcache_rsv28","dcache_rsv29","dcache_rsv30","dcache_rsv31"],
      allowed_modes => \@b_field_allowed_modes,
    });


    $ld_dcache_management_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_dcache_management",
      ctrls => ["ld","dcache_management_only"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_non_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_non_io",
      insts => ["ldbu","ldhu","ldb","ldh","ldw","ldex","ldsex",
                "ldwsp_n","ldw_n","ldbu_n","ldhu_n"],
      allowed_modes => $default_allowed_modes,
    });


    $st8_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st8",
      insts => ["stb","stbio","stb_n","stbz_n"],
      allowed_modes => $default_allowed_modes,
    });


    $st16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st16",
      insts => ["sth","sthio","sth_n"],
      allowed_modes => $default_allowed_modes,
    });


    $st_non32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_non32",
      insts => [
        "stb","stbio","stb_n","stbz_n",
        "sth","sthio","sth_n",
      ],
      allowed_modes => $default_allowed_modes,
    });


    $st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st32",
      insts => ["stw","stwio","stex","stsex","stw_n","stwz_n","stwsp_n"],
      allowed_modes => $default_allowed_modes,
    });


    $st_ex_ctrl = add_inst_ctrl($inst_ctrls, { 
      name => "st_ex",
      insts => ["stex","stsex"],
      allowed_modes => $default_allowed_modes,
    });


    $st_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st",
      insts => ["stb","sth","stw","stbio","sthio","stwio","stex","stsex",
                "stb_n","sth_n","stw_n","stbz_n","stwz_n","stwsp_n"],
      allowed_modes => $default_allowed_modes,
    });


    $st_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_imm",
      insts => ["stb","sth","stw","stbio","sthio","stwio"],
      allowed_modes => $default_allowed_modes,
    });


    $st_ignore_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_ignore_dst",
      insts => ["stb","sth","stw","stbio","sthio","stwio",
                "stb_n","sth_n","stw_n","stbz_n","stwz_n","stwsp_n"],
      allowed_modes => $default_allowed_modes,
    });


    $st_non_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_non_io",
      insts => ["stb","sth","stw","stex","stsex","stb_n","sth_n","stw_n","stbz_n","stwz_n"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st",
      ctrls => ["ld","st"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_io",
      ctrls => ["ld_io","st_io"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_non_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_non_io",
      ctrls => ["ld_non_io","st_non_io"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_non_io_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_non_io_non_st32",
      insts => ["stb", "sth","stb_n","sth_n"],
      ctrls => ["ld_non_io"],
      allowed_modes => $default_allowed_modes,
    });

    $ld_st_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_non_st32",
      ctrls => ["ld","st8","st16"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_st_ex_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_st_ex",
      insts => ["ldex","ldsex","stex","stsex"],
      allowed_modes => $default_allowed_modes,
    });


    $mem_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem",
      ctrls => ["ld_dcache_management","st"],
      allowed_modes => $default_allowed_modes,
    });


    $mem_data_access_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem_data_access",
      insts => ["flushda", "initda","dcache_rsv05","dcache_rsv07","dcache_rsv09","dcache_rsv11","dcache_rsv13","dcache_rsv15","dcache_rsv17","dcache_rsv19","dcache_rsv21","dcache_rsv23","dcache_rsv25","dcache_rsv27","dcache_rsv29","dcache_rsv31"],
      ctrls => ["ld","st"],
      allowed_modes => $default_allowed_modes,
    });


    $mem8_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem8",
      ctrls => ["ld8","st8"],
      allowed_modes => $default_allowed_modes,
    });


    $mem16_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem16",
      ctrls => ["ld16","st16"],
      allowed_modes => $default_allowed_modes,
    });


    $mem32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem32",
      ctrls => ["ld32","st32"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_index_nowb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_index_nowb_inv",
      insts => ["initd","dcache_rsv04","dcache_rsv08","dcache_rsv12","dcache_rsv16","dcache_rsv20","dcache_rsv24","dcache_rsv28"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_addr_nowb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_addr_nowb_inv",
      insts => ["initda","dcache_rsv05","dcache_rsv09","dcache_rsv13","dcache_rsv17","dcache_rsv21","dcache_rsv25","dcache_rsv29"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_index_wb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_index_wb_inv",
      insts => ["flushd","dcache_rsv06","dcache_rsv10","dcache_rsv14","dcache_rsv18","dcache_rsv22","dcache_rsv26","dcache_rsv30"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_addr_wb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_addr_wb_inv",
      insts => ["flushda","dcache_rsv07","dcache_rsv11","dcache_rsv15","dcache_rsv19","dcache_rsv23","dcache_rsv27","dcache_rsv31"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_index_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_index_inv",
      ctrls => ["dc_index_nowb_inv","dc_index_wb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_addr_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_addr_inv",
      ctrls => ["dc_addr_nowb_inv","dc_addr_wb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_wb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_wb_inv",
      ctrls => ["dc_index_wb_inv","dc_addr_wb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dc_nowb_inv_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dc_nowb_inv",
      ctrls => ["dc_index_nowb_inv","dc_addr_nowb_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $dcache_management_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dcache_management",
      ctrls => ["dc_index_inv","dc_addr_inv"],
      allowed_modes => $default_allowed_modes,
    });


    $ld_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ld_io",
      insts => ["ldbio","ldbuio","ldhio","ldhuio","ldwio","i12_rsv10","i12_rsv14"],
      allowed_modes => $default_allowed_modes,
    });
    $st_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_io",
      insts => 
        ["stbio","sthio","stwio"],
      allowed_modes => $default_allowed_modes,
    });
    $st_io_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_io_non_st32",
      insts => ["stbio","sthio"],
      allowed_modes => $default_allowed_modes,
    });
    $st_non_io_non_st32_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "st_non_io_non_st32",
      insts => ["stb", "sth","stb_n","sth_n"],
      allowed_modes => $default_allowed_modes,
    });
    $mem_io_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mem_io",
      ctrls => ["ld_io","st_io"],
      allowed_modes => $default_allowed_modes,
    });



    $a_not_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "a_not_src",
      ctrls => ["jmp_direct"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_readra)";
          } :
          undef,
      c_expr_func => 
          sub {
              return "  || (IS_${prefix}CUSTOM_INST(Iw) && !GET_${prefix}IW_CUSTOM_READRA(Iw))";
          },
      allowed_modes => $default_allowed_modes,
    });






    $b_not_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "b_not_src",
      insts => ["extract","opx_rsv50"],
      ctrls => ["arith_imm16","logic_imm16","cmp_imm16_with_call_jmpi_rdprs",
                "ld_imm","dcache_management_only"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_readrb)";
          } :
          undef,
      c_expr_func => 
          sub {
              return "  || (IS_${prefix}CUSTOM_INST(Iw) && !GET_${prefix}IW_CUSTOM_READRB(Iw))";
          },
      allowed_modes => \@b_field_allowed_modes,
    });



    $b3_not_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "b3_not_src",
      insts => ["beqz_n","bnez_n","ldbu_n","ldhu_n","ldw_n","andi_n","not_n"
               ,"spaddi_n","br_n","movi_n","callr_n","jmpr_n","break_n","trap_n","ret_n","mov_n"],
      v_expr_func => 
          sub {
              my $stage = shift;
              return "| (${stage}_is_asi_n_inst | ${stage}_is_shi_n_inst | ${stage}_is_spi_n_inst | ${stage}_is_stz_n_inst)";
          },
      c_expr_func => 
          sub {
              return "  || (IS_ASI_N_INST(Iw) || IS_SHI_N_INST(Iw) || IS_SPI_N_INST(Iw) || IS_STZ_N_INST(Iw))";
          },
      allowed_modes => \@b_field_allowed_modes,
    });

    $a3_not_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "a3_not_src",
      insts => ["br_n","movi_n","break_n","trap_n"],
      allowed_modes => \@b_field_allowed_modes,
    });







    $b_is_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "b_is_dst",
      ctrls => ["b_not_src","bmx"],
      insts => ["mov_n","ldwsp_n","stwsp_n"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "& ~${stage}_op_custom";
          } :
          undef,
      allowed_modes => \@b_field_allowed_modes,
    });





    $ignore_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ignore_dst",
      insts => ["jmpr_n","ret_n"],
      ctrls => ["br","dcache_management_only","st_ignore_dst","jmpi"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_writerc)";
          } :
          undef,
      c_expr_func => 
          sub {
              return "  || (IS_${prefix}CUSTOM_INST(Iw) && !GET_${prefix}IW_CUSTOM_WRITERC(Iw))";
          },
      allowed_modes => \@b_field_allowed_modes,
    });





    $ignore_dst_or_ld_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "ignore_dst_or_ld",
      ctrls => ["ignore_dst","ld"],
      v_expr_func => $has_custom_insts ? 
          sub {


              my $stage = shift;
              return "| (${stage}_op_custom & ~${stage}_iw_custom_writerc)";
          } :
          undef,
      allowed_modes => $default_allowed_modes,
    });






    $src2_choose_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src2_choose_imm",
      ctrls => ["b_not_src","st_imm","shift_rot_imm","ld_st_ex"],
      allowed_modes => \@b_field_allowed_modes,
    });
    
    $src2_choose_cdx_imm_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src2_choose_cdx_imm",
      insts => ["pop_n","beqz_n","bnez_n","ldbu_n","ldhu_n","ldw_n","andi_n","not_n"
               ,"spaddi_n","br_n","movi_n","callr_n","jmpr_n","break_n","trap_n","ret_n","mov_n"
               ,"stb_n","sth_n","stw_n","stbz_n","stwz_n","ldwsp_n","stwsp_n","push_n","stwm","ldwm"],
      v_expr_func => 
          sub {
              my $stage = shift;
              return "| (${stage}_is_asi_n_inst | ${stage}_is_shi_n_inst | ${stage}_is_spi_n_inst | ${stage}_is_stz_n_inst)";
          },
      c_expr_func => 
          sub {
              return "  || IS_ASI_N_INST(Iw) || IS_SHI_N_INST(Iw) || IS_SPI_N_INST(Iw) || IS_STZ_N_INST(Iw)";
          },
      allowed_modes => \@b_field_allowed_modes,
    });
   
    $a3_is_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "a3_is_src",
      insts => ["beqz_n","bnez_n","ldbu_n","ldhu_n","ldw_n","stb_n",
                "sth_n","stw_n","andi_n","and_n","not_n","or_n","xor_n","sll_n","srl_n"],
      v_expr_func => 
          sub {
              my $stage = shift;
              return "| (${stage}_is_as_n_inst | ${stage}_is_asi_n_inst | ${stage}_is_shi_n_inst | ${stage}_is_stz_n_inst)";
          },
      c_expr_func => 
          sub {
              return "  || IS_AS_N_INST(Iw) || IS_ASI_N_INST(Iw) || IS_SHI_N_INST(Iw) || IS_STZ_N_INST(Iw)";
          },
      allowed_modes => \@b_field_allowed_modes,
    });
    
    $b3_is_src_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "b3_is_src",
      insts => ["stb_n","sth_n","stw_n","and_n","or_n","xor_n","sll_n","srl_n","neg_n"],
      v_expr_func => 
          sub {
              my $stage = shift;
              return "| (${stage}_is_as_n_inst| ${stage}_is_stz_n_inst)";
          },
      c_expr_func => 
          sub {
              return "  || IS_AS_N_INST(Iw)";
          },
      allowed_modes => \@b_field_allowed_modes,
    });

    $a3_is_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "a3_is_dst",
      insts => ["movi_n","spaddi_n","and_n","or_n","xor_n","sll_n","srl_n","neg_n"],
      allowed_modes => \@b_field_allowed_modes,
    });
    
    $b3_is_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "b3_is_dst",
      insts => ["ldbu_n","ldhu_n","ldw_n","andi_n","not_n"],
      v_expr_func => 
          sub {
              my $stage = shift;
              return "| (${stage}_is_asi_n_inst | ${stage}_is_shi_n_inst)";
          },
      c_expr_func => 
          sub {
              return "  || IS_ASI_N_INST(Iw) || IS_SHI_N_INST(Iw)";
          },
      allowed_modes => \@b_field_allowed_modes,
    });


    $c3_is_dst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "c3_is_dst",
      v_expr_func => 
          sub {
              my $stage = shift;
              return "| (${stage}_is_as_n_inst)";
          },
      c_expr_func => 
          sub {
              return " IS_AS_N_INST(Iw)";
          },
      allowed_modes => \@b_field_allowed_modes,
    });


    $wrctl_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "wrctl_inst",
      insts => ["wrctl","opx_rsv47"],
      allowed_modes => $default_allowed_modes,
    });
    $rdctl_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rdctl_inst",
      insts => ["rdctl"],
      allowed_modes => $default_allowed_modes,
    });
    

    $intr_inst_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "intr_inst",
      insts => ["wrpie","eni"],
      allowed_modes => $default_allowed_modes,
    });


    $rdprs_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "rdprs",
      insts => ["rdprs","i12_rsv15"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_src1_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_src1_signed",
      insts => ["mulxss","mulxsu"],
      allowed_modes => $default_allowed_modes,
    });
    $mul_src2_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_src2_signed",
      insts => ["mulxss"],
      allowed_modes => $default_allowed_modes,
    });


    $mul_shift_src1_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_shift_src1_signed",
      ctrls => ["mul_src1_signed","shift_right_arith"],
      allowed_modes => $default_allowed_modes,
    });

    $mul_shift_src2_signed_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_shift_src2_signed",
      ctrls => ["mul_src2_signed"],
      allowed_modes => $default_allowed_modes,
    });

    $mul_shift_rot_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "mul_shift_rot",
      ctrls => ["mul", "shift_rot"],
      allowed_modes => $default_allowed_modes,
    });



    $dont_display_dst_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dont_display_dst_reg",
      insts => ["eret","bret","sync","callr","wrctl","initi","flushi",
        "eni","flushp","initda","flushda","initd","flushd","jmp","ret",
        "callr_n","spdeci_n","spinci_n","pop_n","push_n","ldwm","stwm"],
      ctrls => ["jmp_direct","exception","break","crst"],
      allowed_modes => get_all_inst_desc_modes(),
    });



    $dont_display_src1_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dont_display_src1_reg",
      insts => ["eret","bret","sync","br","ret","nextpc","rdctl", "eni","flushp",
        "spaddi_n","spdeci_n","spinci_n","pop_n","push_n","ret_n","ldwsp_n","stwsp_n"],
      ctrls => ["exception","break","crst"],
      allowed_modes => get_all_inst_desc_modes(),
    });



    $dont_display_src2_reg_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "dont_display_src2_reg",
      insts => ["jmp","ret","eret","bret","sync","br","callr","nextpc",
        "rdctl","wrpie","eni","wrctl","flushp","initi","flushi",
        "beqz_n","bnez_n","pop_n","push_n","ldwm","stwm"],
      ctrls => ["exception","break","crst","shift_rot_imm","bmx"],
      allowed_modes => get_all_inst_desc_modes(),
    });




    $src1_no_x_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src1_no_x",
      insts => ["wrctl"],
      ctrls => ["cmp","mem","mul","br","jmp_indirect"],
      allowed_modes => get_all_inst_desc_modes(),
    });




    $src2_no_x_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "src2_no_x",
      ctrls => ["cmp","mem","mul","br"],
      allowed_modes => get_all_inst_desc_modes(),
    });


    $narrow_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "narrow",
      insts => [
        "br_n", "andi_n", "ldwsp_n", "movi_n", "bnez_n", "beqz_n", "stwsp_n", "mov_n",
        "ldbu_n", "ldhu_n", "ldw_n", "stb_n", "sth_n", "stw_n", "spaddi_n",
        "op_rsv49", "op_rsv57",
      ],
      v_expr_func => \&narrow_inst_groups_v_expr,
      c_expr_func => \&narrow_inst_groups_c_expr,
      allowed_modes => $default_allowed_modes,
    });


    $cdx_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "cdx",
      insts => ["ldwm","stwm"],
      ctrls => ["narrow"],
      v_expr_func => \&narrow_inst_groups_v_expr,
      c_expr_func => \&narrow_inst_groups_c_expr,
      allowed_modes => $default_allowed_modes,
    });


    $bmx_ctrl = add_inst_ctrl($inst_ctrls, {
      name => "bmx",
      insts => ["extract","insert","merge","opx_rsv34","opx_rsv42","opx_rsv50"],
      allowed_modes => $default_allowed_modes,
    });


    return $inst_ctrls;
}



sub
get_default_inst_ctrl_allowed_modes
{
    my $inst_args = shift;

    my $advanced_exc = manditory_bool($inst_args, "advanced_exc");
















    my $default_allowed_modes = [$INST_DESC_NORMAL_MODE];
    if ($advanced_exc) {
        push(@$default_allowed_modes, $INST_DESC_RESERVED_MODE);
    }

    return $default_allowed_modes;
}



sub
get_exception_inst_ctrl_allowed_modes
{
    my $inst_args = shift;

    return 
      [$INST_DESC_NORMAL_MODE, 
       $INST_DESC_RESERVED_MODE, 
       $INST_DESC_UNIMP_TRAP_MODE];
}

sub
narrow_inst_groups_v_expr
{


    my $stage = shift;
    return "| (${stage}_is_as_n_inst | ${stage}_is_r_n_inst | ${stage}_is_asi_n_inst | ${stage}_is_shi_n_inst | ${stage}_is_pp_n_inst | ${stage}_is_spi_n_inst | ${stage}_is_stz_n_inst)";
}

sub
narrow_inst_groups_c_expr
{


    return "  || (IS_AS_N_INST(Iw) || IS_R_N_INST(Iw) || IS_ASI_N_INST(Iw) || IS_SHI_N_INST(Iw) || IS_PP_N_INST(Iw) || IS_SPI_N_INST(Iw) || IS_STZ_N_INST(Iw))";
}



sub
add_inst_ctrl
{
    my $inst_ctrls = shift;
    my $props = shift;

    my $ctrl_name = $props->{name};

    if (defined(get_inst_ctrl_by_name_or_undef($inst_ctrls, $ctrl_name))) {
        return &$error("Instruction control name '$ctrl_name' already exists");
    }

    my $inst_ctrl = create_inst_ctrl($props);


    push(@$inst_ctrls, $inst_ctrl);

    return $inst_ctrl;
}




sub
encode_opx_inst
{
    my $inst_fields = shift;
    my $inst_descs = shift;
    my $inst_name = shift;
    my $a_field_value = shift;
    my $b_field_value = shift;
    my $c_field_value = shift;

    my $inst_desc = get_inst_desc_by_name($inst_descs, $inst_name) || return undef;
    if (get_inst_desc_inst_type($inst_desc) != $OPX_INST_TYPE) {
        return &$error("encode_opx_inst() called with non-OPX instruction '$inst_name'.");
    }
    my $code = get_inst_desc_code($inst_desc);  # OPX field value

    my $opx_table = get_inst_desc_inst_table($inst_desc) || 
      return &$error("No inst_table for '$inst_name'");
    my $op_table = get_inst_table_parent_table($opx_table) || 
      return &$error("No parent_table for '$inst_name'");
    my $op_opx_code = get_inst_table_inst_code_by_name($op_table, "OPX") || 
      return &$error("No inst_code in parent table for OPX");

    my $op_field = get_inst_field_by_name($inst_fields, "op");
    my $opx_field = get_inst_field_by_name($inst_fields, "opx");
    my $a_field = get_inst_field_by_name($inst_fields, "a");
    my $b_field = get_inst_field_by_name($inst_fields, "b");
    my $c_field = get_inst_field_by_name($inst_fields, "c");


    return 
      ($op_opx_code   << get_inst_field_lsb($op_field)) |
      ($code          << get_inst_field_lsb($opx_field)) |
      ($a_field_value << get_inst_field_lsb($a_field)) |
      ($b_field_value << get_inst_field_lsb($b_field)) |
      ($c_field_value << get_inst_field_lsb($c_field));
}

sub
convert_inst_fields_to_c
{
    my $inst_fields = shift;
    my $c_lines = shift;
    my $h_lines = shift;
    my $prefix = shift;         # Prefix

    push(@$h_lines, 
      "",
      "/*",
      " * Instruction field macros",
      " */");

    foreach my $inst_field (@$inst_fields) {
        if (!defined(
          convert_inst_field_to_c($inst_field, $c_lines, $h_lines, $prefix))) {
            return undef;
        }
    }

    return 1;   # Some defined value
}

sub
convert_inst_tables_to_c
{
    my $inst_tables = shift;
    my $c_lines = shift;        # Reference to array of lines for *.c file
    my $h_lines = shift;        # Reference to array of lines for *.h file
    my $prefix = shift;

    foreach my $inst_table (@$inst_tables) {
        convert_inst_table_to_c($inst_tables, $inst_table, $prefix,
          $c_lines, $h_lines) || return undef;
    }

    push(@$h_lines, "");
    push(@$h_lines, "/* Macro to detect custom instruction */");
    push(@$h_lines, "#define IS_CUSTOM_INST(Iw) ((GET_IW_OP(Iw) == OP_CUSTOM))");

    return 1;   # Some defined value
}

sub
convert_constants_to_c
{
    my $inst_constants = shift;
    my $c_lines = shift;
    my $h_lines = shift;
    my $prefix = shift;         # Prefix

    push(@$h_lines, "");
    push(@$h_lines, "/* Instruction Constants */");
    format_hash_as_c_macros($inst_constants, $h_lines, $prefix);

    return 1;   # Some defined value
}



sub
convert_inst_ctrls_to_c
{
    my $inst_ctrls = shift;
    my $all_inst_descs = shift;
    my $c_lines = shift;
    my $h_lines = shift;
    my $prefix = shift;          # Prefix
    my $prefix_lc = lc($prefix); # tolower

    push(@$h_lines,
      "",
      "/*", 
      " * Instruction property macros",
      " */");

    foreach my $inst_ctrl (@$inst_ctrls) {


        my $expanded_inst_descs = [];
        if (!defined(cpu_inst_gen::expand_ctrl_insts($inst_ctrls, $inst_ctrl, 
          $all_inst_descs, $expanded_inst_descs))) {
            return undef;
        }


        my $filtered_inst_descs = get_inst_descs_by_modes(
          $expanded_inst_descs, [$INST_DESC_NORMAL_MODE]);

        my $ctrl_name_lc = get_inst_ctrl_name($inst_ctrl);
        my $ctrl_name_uc = uc($ctrl_name_lc);
        my $define_prefix = "#define IW_PROP_${ctrl_name_uc}(Iw) ";



        my $c_expr_func = get_inst_ctrl_c_expr_func($inst_ctrl);
        my $extra_expr = "";
        if (defined($c_expr_func)) {
            $extra_expr = &$c_expr_func();
        }

        my $num_filtered_inst_descs = scalar(@$filtered_inst_descs);



        if ($num_filtered_inst_descs == 0) {
            push(@$h_lines, $define_prefix . 
              (($extra_expr eq "") ? "(0)" : "($extra_expr)"));
        } elsif ($num_filtered_inst_descs <= 2) {

            push(@$h_lines, 
              $define_prefix . "( \\",
              "  ( \\");

            foreach my $inst_desc (@$filtered_inst_descs) {
                my $c_decode_func = get_inst_desc_c_decode_func($inst_desc);
                my $decode_func_arg = get_inst_desc_decode_arg($inst_desc);

                my $c_decode_expr = &$c_decode_func($decode_func_arg, $inst_desc);

                my $line = "    (" . $c_decode_expr . ")";

                if ($inst_desc == 
                  $filtered_inst_descs->[$num_filtered_inst_descs-1]) {

                    push(@$h_lines, 
                      $line . " \\",
                      "  ) \\",
                      $extra_expr . " \\",
                      ")");
                } else {

                    push(@$h_lines, $line . " || \\");
                }
            }
        } else {



            my $inst_tables = [];
            foreach my $inst_desc (@$filtered_inst_descs) {
                my $inst_table = get_inst_desc_inst_table($inst_desc);
                validate_inst_table($inst_table) || return undef;

                my $already_exists = 0;
                foreach my $existing_inst_table (@$inst_tables) {
                    if ($existing_inst_table == $inst_table) {
                        $already_exists = 1;
                    }
                }

                if (!$already_exists) {
                    push(@$inst_tables, $inst_table);
                }
            }


            my @macro_lines;
            foreach my $inst_table (@$inst_tables) {
                my $table_name = get_inst_table_name($inst_table);
                my $table_name_uc = uc($table_name);
                my $inst_field = get_inst_table_inst_field($inst_table);
                my $inst_field_name = get_inst_field_name($inst_field);
                my $inst_field_name_uc = uc($inst_field_name);

                my $is_child = defined(get_inst_table_parent_table($inst_table));

                push(@macro_lines,
                  "    " .
                  "(" .
                    ($is_child ? "IS_${table_name_uc}_INST(Iw) && " : "") .
                    "${table_name}_prop_${ctrl_name_lc}\[GET_IW_${inst_field_name_uc}(Iw)]" .
                  ")"
                );
            }

            push(@$h_lines, $define_prefix . "( \\");

            my $num_macro_lines = scalar(@macro_lines);
            for (my $macro_line_index = 0; $macro_line_index < $num_macro_lines;
              $macro_line_index++) {
                my $is_last_line = ($macro_line_index == ($num_macro_lines - 1));
                if ($is_last_line) {
                    push(@$h_lines, $macro_lines[$macro_line_index] . $extra_expr . ")");
                } else {
                    push(@$h_lines, $macro_lines[$macro_line_index] . " || \\");
                }
            }


            push(@$c_lines,
              "",
              "/* Table(s) for IW_PROP_${ctrl_name_uc} macro */");;

            foreach my $inst_table (@$inst_tables) {
                my $table_name = get_inst_table_name($inst_table);
                my $opcodes = get_inst_table_opcodes($inst_table);
                my $num_opcodes = scalar(@$opcodes);
                push(@$c_lines,
                  "unsigned char",
                  "${prefix}${table_name}_prop_" .
                    "${ctrl_name_lc}\[$num_opcodes] = {");

                for (my $code = 0; $code < $num_opcodes; $code++) {
                    my $opcode = $opcodes->[$code];
                    my $opcode_type = get_inst_table_opcode_type($opcode);
                    my $after_number = ($code == ($num_opcodes-1)) ? " " : ",";

                    my $on_list = 0;


                    if ($opcode_type == $OPCODE_TYPE_INST_NAME) {

                        $on_list = get_inst_desc_by_name_or_undef(
                          $filtered_inst_descs, $opcode);
                    }

                    if ($on_list) {

                        my $c_name = $opcode;
                        $c_name =~ s/_n$/.n/;
                        push(@$c_lines, sprintf("    1%s /* %s */", $after_number, 
                          $c_name));
                    } else {
                        push(@$c_lines, sprintf("    0%s", $after_number));
                    }
                }

                push(@$c_lines, "};");


                push(@$h_lines,
                  "",
                  "#ifndef ALT_ASM_SRC",
                  "extern unsigned char" .
                    " ${prefix}${table_name}_prop_" .
                    "${ctrl_name_lc}\[$num_opcodes];",
                  "#endif /* ALT_ASM_SRC */");
            }
        }

        push(@$h_lines, "");
    }

    return 1;   # Some defined value
}








sub
create_c_inst_info
{
    my $cpu_arch = shift;
    my $inst_descs = shift;
    my $inst_tables = shift;
    my $top_inst_table = shift;
    my $c_lines = shift;
    my $h_lines = shift;
    my $prefix = shift;

    my $r1 = ($cpu_arch == 1);

    push(@$h_lines,
      "",
      "/* Instruction types */",
    );







        foreach my $inst_type (@INST_TYPES) {
            my $inst_type_name_uc = uc(not_empty_scalar($inst_type, "name"));
            my $inst_type_value = manditory_int($inst_type, "value");
    
            push(@$h_lines, "#define INST_TYPE_${inst_type_name_uc} $inst_type_value");
        }
    
        push(@$h_lines, "#define TOTAL_INST_TYPE " . scalar(@INST_TYPES)); 

    
    push(@$h_lines,
      "",
      "/* Canonical instruction codes independent of encoding. Sorted alphabetically. */"
    ); 

    push(@$c_lines,
      "",
      "/* Instruction information array (indexed by instruction code) */",
      "Nios2InstInfo nios2InstInfo[] = {");

    my $num_inst_info_entries = 0;
    my $first_reserved_inst_desc;

    my $inst_code_fmt = "    { \"%s\", INST_TYPE_%s, %d },";


    my %inst_codes;

    foreach my $inst_desc (@$inst_descs) {
        my $mode = get_inst_desc_mode($inst_desc);

        if ($mode == $INST_DESC_RESERVED_MODE) {
            if (!defined($first_reserved_inst_desc)) {
                $first_reserved_inst_desc = $inst_desc;
            }
            

            my $ldl = (get_inst_desc_name($inst_desc) eq "ldl");
            my $stc = (get_inst_desc_name($inst_desc) eq "stc");
            if (! ($ldl || $stc)) {
                next;
            }
        }

        $inst_codes{get_inst_desc_name($inst_desc)} = $inst_desc;
    }




    $inst_codes{rsv} = undef;

    foreach my $inst_name (sort(keys(%inst_codes))) {
        my $inst_desc = $inst_codes{$inst_name};
        my $inst_code;
        my $inst_type;

        if (defined($inst_desc)) {
            $inst_code = get_inst_desc_code($inst_desc);
            $inst_type = get_inst_desc_inst_type($inst_desc);




        } elsif ($inst_name eq "rsv") {
            if (!defined($first_reserved_inst_desc)) {
                return &$error("Couldn't find any reserved instructions");
            }
            $inst_code = get_inst_desc_code($first_reserved_inst_desc);
            $inst_type = get_inst_desc_inst_type($first_reserved_inst_desc);
        } else {
            return &$error("Missing inst_desc for instruction '$inst_name'");
        }
        
        my $inst_name_uc = uc($inst_name);


        $inst_name =~ s/_n$/.n/;

        if (!defined($inst_type)) {
            return &$error("Missing inst_type for instruction '$inst_name'");
        }

        my $inst_type_name = $INST_TYPES[$inst_type]->{name};
        my $inst_type_name_uc = uc($inst_type_name);

        push(@$c_lines, sprintf($inst_code_fmt, $inst_name, $inst_type_name_uc, $inst_code));
        push(@$h_lines, sprintf("#define %s_INST_CODE %d", $inst_name_uc, $num_inst_info_entries));

        $num_inst_info_entries++;
    }

    push(@$c_lines, 
      "};"
    );

    push(@$h_lines, 
      "#define NUM_INST_CODES $num_inst_info_entries",
      "",
      "#ifndef ALT_ASM_SRC",
      "/* Instruction information entry */",
      "typedef struct {",
      "  const char* name;     /* Assembly-language instruction name */",
      "  int         instType; /* INST_TYPE_* */",
      "  unsigned    opcode;   /* Value of field used to index into table */",
      "} Nios2InstInfo;",
      "",
      "extern Nios2InstInfo nios2InstInfo[NUM_INST_CODES];",
      "",
      "/* Returns the instruction code given the instruction word */",
      "#define GET_INST_CODE(Iw) (get_nios2_inst_code(Iw))",
      "",
      "extern int get_nios2_inst_code(unsigned int iw);",
      "#endif /* ALT_ASM_SRC */"
    );

    push(@$c_lines,
      "",
      "/* Returns the instruction code given the 32-bit instruction word */",
      "int",
      "get_nios2_inst_code(unsigned int iw)",
      "{",
    );


    create_c_inst_info_for_inst_table($inst_tables, $top_inst_table,
      "    ", $c_lines, $h_lines, $prefix);

    push(@$c_lines,
      "}",
    );

    foreach my $inst_table (@$inst_tables) {
        my $table_name = get_inst_table_name($inst_table);
        my $table_name_uc = uc($table_name);
        my $opcodes = get_inst_table_opcodes($inst_table);
        my $inst_field = get_inst_table_inst_field($inst_table);
        my $inst_field_name_uc = uc(get_inst_field_name($inst_field));

        my $num_opcodes = scalar(@$opcodes);
        
        push(@$c_lines,
          "",
          "/* Used by GET_INST_CODE() to map $table_name_uc" .
            " instructions to instruction code */",
          "int ${prefix}${table_name}_to_inst_code[$num_opcodes] = {",
        );

        for (my $code=0; $code < scalar(@$opcodes); $code++) {
            my $opcode = $opcodes->[$code];
            my $opcode_type = get_inst_table_opcode_type($opcode);
            my $last = ($code == (scalar(@$opcodes) - 1));
            my $term = ($last ? "" : ",");

            if ($opcode_type == $OPCODE_TYPE_INST_NAME) {
                my $inst_name_uc = uc($opcode);

                push(@$c_lines,
                  "  " . $inst_name_uc . "_INST_CODE" . $term
                );
            } elsif (
              ($opcode_type == $OPCODE_TYPE_RESERVED_NUM) ||
              ($opcode_type == $OPCODE_TYPE_CHILD_TABLE_NAME)) {
                my $inst_name_uc = uc($opcode);

                push(@$c_lines,
                  "  RSV_INST_CODE" . $term
                );
            } else {
              return &$error(
                  "Unknown opcode_type of '$opcode_type' for opcode '$opcode'");
            }
        }

        push(@$c_lines,
          "};"
        );

        push(@$h_lines,
          "",
          "#ifndef ALT_ASM_SRC",
          "extern int ${prefix}${table_name}" .
            "_to_inst_code[$num_opcodes];",
          "#endif /* ALT_ASM_SRC */"
        );
    }

    return 1;   # Some defined value
}



sub
create_c_inst_info_for_inst_table
{
    my $inst_tables = shift;
    my $inst_table = shift;
    my $indent = shift;
    my $c_lines = shift;        # Reference to array of lines for *.c file
    my $h_lines = shift;        # Reference to array of lines for *.h file
    my $prefix = shift;

    my $table_name = get_inst_table_name($inst_table);
    my $table_name_uc = uc($table_name);
    my $inst_field = get_inst_table_inst_field($inst_table);
    my $inst_field_name_uc = uc(get_inst_field_name($inst_field));

    my $child_table_infos = 
      get_inst_table_child_table_infos($inst_tables, $inst_table);
    my $num_children = scalar(@$child_table_infos);

    for (my $child_index = 0; $child_index < $num_children; $child_index++) {
        my $child_table_info = $child_table_infos->[$child_index];
        my $child_table = manditory_hash($child_table_info, "child_table");
        my $child_table_name = get_inst_table_name($child_table);
        my $child_table_name_uc = uc($child_table_name);
        my $last_child = ($child_index == ($num_children -1 ));

        push(@$c_lines,
          "${indent}if (IS_${child_table_name_uc}_INST(iw)) {");


        create_c_inst_info_for_inst_table($inst_tables, $child_table,
          $indent . "    ", $c_lines, $c_lines);

        push(@$c_lines,
          "${indent}}");
    }

    push(@$c_lines,
      "${indent}return ${prefix}${table_name}" .
        "_to_inst_code[GET_IW_${inst_field_name_uc}(iw)];");
}



sub
create_c_mask_match
{
    my $all_inst_descs = shift;
    my $inst_fields = shift;
    my $top_inst_table = shift;
    my $h_lines = shift;
    my $prefix = shift;

    push(@$h_lines,
      "",
      "/* Mask/match values for each instruction. */",
      "/*   is_instruction = ((instruction_value & mask) == match) */");

    foreach my $inst_desc (@$all_inst_descs) {

        if (get_inst_desc_mode($inst_desc) == $INST_DESC_RESERVED_MODE) {
            next;
        }
        
        my $inst_name_uc = uc(get_inst_desc_name($inst_desc));
        my $c_mask = get_inst_desc_c_mask($inst_desc);
        if (!defined($c_mask)) {
            return 
              &$error("The c_mask for instruction $inst_name_uc doesn't exist");
        }

        add_one_c_mask($h_lines, $prefix, $inst_name_uc, $c_mask);

        my $c_match = get_inst_desc_c_match($inst_desc);
        if (!defined($c_match)) {
            return 
              &$error("The c_match for instruction $inst_name_uc doesn't exist");
        }

        add_one_c_match($h_lines, $prefix, $inst_name_uc, $c_match);
    }









    return 1;   # Some defined value
}

sub
add_one_c_mask
{
    my $h_lines = shift;
    my $prefix = shift;
    my $inst_name_uc = shift;
    my $c_mask = shift;

    push(@$h_lines, 
      sprintf("#define ${prefix}OP_MASK_%s 0x%08x", 
        $inst_name_uc, $c_mask),
    );
}

sub
add_one_c_match
{
    my $h_lines = shift;
    my $prefix = shift;
    my $inst_name_uc = shift;
    my $c_match = shift;

    push(@$h_lines, 
      sprintf("#define ${prefix}OP_MATCH_%s 0x%08x", 
        $inst_name_uc, $c_match),
    );
}

sub
create_nlagen_tables
{
    my $cpu_arch = shift;
    my $c_lines = shift;
    my $h_lines = shift;

    my $r1 = ($cpu_arch == 1);

    push(@$h_lines,
      "",
      "#ifndef ALT_ASM_SRC",
      "/* Tables for nlagen in nios2_line_asm_lib */",
      "",
      "extern const char* g_inst_type_prefix[TOTAL_INST_TYPE];",
      "extern int g_num_of_inst_in_table[TOTAL_INST_TYPE];",
      "#endif /* ALT_ASM_SRC */"
    );

    push(@$c_lines,
      "",
      "/* Tables for nlagen in nios2_line_asm_lib */",
      "",
      "const char* g_inst_type_prefix[TOTAL_INST_TYPE] = {",
    );

    my $num_inst_types = scalar(@INST_TYPES);

    printf("num_inst_types = %d", $num_inst_types);
    foreach my $inst_type (@INST_TYPES) {
        my $inst_type_name = not_empty_scalar($inst_type, "name");
        my $last_inst_type = ($inst_type == ($num_inst_types - 1));

        if ($r1) {
            if (($inst_type_name eq "op") || ($inst_type_name eq "opx")) {
                push(@$c_lines, "  \"$inst_type_name\"" . ($last_inst_type ? "" : ","));
            }
        } else {
            push(@$c_lines, "  \"$inst_type_name\"" . ($last_inst_type ? "" : ","));
        }
    }

    push(@$c_lines,
      "};",
      "",
      "int g_num_of_inst_in_table[TOTAL_INST_TYPE] = {",
    );
      
    foreach my $inst_type (@INST_TYPES) {
        my $inst_type_name_uc = uc(not_empty_scalar($inst_type, "name"));
        my $last_inst_type = ($inst_type == ($num_inst_types - 1));

        if ($r1) {
            if (($inst_type_name_uc eq "OP") || ($inst_type_name_uc eq "OPX")) {
                push(@$c_lines, "  NUM_${inst_type_name_uc}_INSTS" . ($last_inst_type ? "" : ","));
            }
        } else {
            push(@$c_lines, "  NUM_${inst_type_name_uc}_INSTS" . ($last_inst_type ? "" : ","));
        }
    }

    push(@$c_lines,
      "};",
    );
      
    return 1;   # Some defined value
}

sub
eval_cmd
{
    my $cmd = shift;

    eval($cmd);
    if ($@) {
        &$error("nios2_insts.pm: eval($cmd) returns '$@'\n");
    }
}

1;
