# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


package ifneeded altera_iopll_common::iopll 18.1           [list source [file join $dir .. .. altera_iopll_common tcl iopll.tcl]]

package ifneeded altera_emif::util::messaging                            0.1 [list source [file join $dir .. util messaging.tcl]]
package ifneeded altera_emif::util::qini                                 0.1 [list source [file join $dir .. util qini.tcl]]
package ifneeded altera_emif::util::hwtcl_utils                          0.1 [list source [file join $dir .. util hwtcl_utils.tcl]]
package ifneeded altera_emif::util::hwtcl_debug                          0.1 [list source [file join $dir .. util hwtcl_debug.tcl]]
package ifneeded altera_emif::util::math                                 0.1 [list source [file join $dir .. util math.tcl]]
package ifneeded altera_emif::util::device_family                        0.1 [list source [file join $dir .. util device_family.tcl]]
package ifneeded altera_emif::util::arch_expert                          0.1 [list source [file join $dir .. util arch_expert.tcl]]
package ifneeded altera_emif::util::ctrl_expert                          0.1 [list source [file join $dir .. util ctrl_expert.tcl]]
package ifneeded altera_emif::util::doc_gen                              0.1 [list source [file join $dir .. util doc_gen.tcl]]
package ifneeded altera_emif::util::enums                                0.1 [list source [file join $dir .. util enums.tcl]]
package ifneeded altera_emif::util::enum_defs                            0.1 [list source [file join $dir .. util enum_defs.tcl]]
package ifneeded altera_emif::util::enum_defs_interfaces                 0.1 [list source [file join $dir .. util enum_defs_interfaces.tcl]]
package ifneeded altera_emif::util::enum_defs_family_traits_and_features 0.1 [list source [file join $dir .. util enum_defs_family_traits_and_features.tcl]]
package ifneeded altera_emif::util::channel_uncertainty                  0.1 [list source [file join $dir .. util channel_uncertainty.tcl]]

package ifneeded altera_emif::ip_top::exports                        0.1 [list source [file join $dir .. ip_top exports.tcl]]
package ifneeded altera_emif::ip_top::compat                         0.1 [list source [file join $dir .. ip_top compat.tcl]]
package ifneeded altera_emif::ip_top::main                           0.1 [list source [file join $dir .. ip_top main.tcl]]
package ifneeded altera_emif::ip_top::protocol_expert                0.1 [list source [file join $dir .. ip_top protocol_expert.tcl]]
package ifneeded altera_emif::ip_top::util                           0.1 [list source [file join $dir .. ip_top util.tcl]]
package ifneeded altera_emif::ip_top::ex_design                      0.1 [list source [file join $dir .. ip_top ex_design.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui                  0.1 [list source [file join $dir .. ip_top ex_design_gui.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui::ddr3            0.1 [list source [file join $dir .. ip_top ex_design_gui ddr3.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui::ddr4            0.1 [list source [file join $dir .. ip_top ex_design_gui ddr4.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui::rld3            0.1 [list source [file join $dir .. ip_top ex_design_gui rld3.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui::qdr2            0.1 [list source [file join $dir .. ip_top ex_design_gui qdr2.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui::rld2            0.1 [list source [file join $dir .. ip_top ex_design_gui rld2.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui::qdr4            0.1 [list source [file join $dir .. ip_top ex_design_gui qdr4.tcl]]
package ifneeded altera_emif::ip_top::ex_design_gui::lpddr3          0.1 [list source [file join $dir .. ip_top ex_design_gui lpddr3.tcl]]
package ifneeded altera_emif::ip_top::phy                            0.1 [list source [file join $dir .. ip_top phy.tcl]]
package ifneeded altera_emif::ip_top::vg_autogen                     0.1 [list source [file join $dir .. ip_top vg_autogen.tcl]]
package ifneeded altera_emif::ip_top::phy::ddr3                      0.1 [list source [file join $dir .. ip_top phy ddr3.tcl]]
package ifneeded altera_emif::ip_top::phy::ddr4                      0.1 [list source [file join $dir .. ip_top phy ddr4.tcl]]
package ifneeded altera_emif::ip_top::phy::rld3                      0.1 [list source [file join $dir .. ip_top phy rld3.tcl]]
package ifneeded altera_emif::ip_top::phy::qdr2                      0.1 [list source [file join $dir .. ip_top phy qdr2.tcl]]
package ifneeded altera_emif::ip_top::phy::rld2                      0.1 [list source [file join $dir .. ip_top phy rld2.tcl]]
package ifneeded altera_emif::ip_top::phy::qdr4                      0.1 [list source [file join $dir .. ip_top phy qdr4.tcl]]
package ifneeded altera_emif::ip_top::phy::lpddr3                    0.1 [list source [file join $dir .. ip_top phy lpddr3.tcl]]
package ifneeded altera_emif::ip_top::mem                            0.1 [list source [file join $dir .. ip_top mem.tcl]]
package ifneeded altera_emif::ip_top::mem::ddr4                      0.1 [list source [file join $dir .. ip_top mem ddr4.tcl]]
package ifneeded altera_emif::ip_top::mem::ddr3                      0.1 [list source [file join $dir .. ip_top mem ddr3.tcl]]
package ifneeded altera_emif::ip_top::mem::rld3                      0.1 [list source [file join $dir .. ip_top mem rld3.tcl]]
package ifneeded altera_emif::ip_top::mem::qdr2                      0.1 [list source [file join $dir .. ip_top mem qdr2.tcl]]
package ifneeded altera_emif::ip_top::mem::rld2                      0.1 [list source [file join $dir .. ip_top mem rld2.tcl]]
package ifneeded altera_emif::ip_top::mem::qdr4                      0.1 [list source [file join $dir .. ip_top mem qdr4.tcl]]
package ifneeded altera_emif::ip_top::mem::lpddr3                    0.1 [list source [file join $dir .. ip_top mem lpddr3.tcl]]
package ifneeded altera_emif::ip_top::board                          0.1 [list source [file join $dir .. ip_top board.tcl]]
package ifneeded altera_emif::ip_top::board::ddr3                    0.1 [list source [file join $dir .. ip_top board ddr3.tcl]]
package ifneeded altera_emif::ip_top::board::ddr4                    0.1 [list source [file join $dir .. ip_top board ddr4.tcl]]
package ifneeded altera_emif::ip_top::board::rld3                    0.1 [list source [file join $dir .. ip_top board rld3.tcl]]
package ifneeded altera_emif::ip_top::board::qdr2                    0.1 [list source [file join $dir .. ip_top board qdr2.tcl]]
package ifneeded altera_emif::ip_top::board::qdr4                    0.1 [list source [file join $dir .. ip_top board qdr4.tcl]]
package ifneeded altera_emif::ip_top::board::lpddr3                  0.1 [list source [file join $dir .. ip_top board lpddr3.tcl]]
package ifneeded altera_emif::ip_top::ctrl                           0.1 [list source [file join $dir .. ip_top ctrl.tcl]]
package ifneeded altera_emif::ip_top::ctrl::ddr3                     0.1 [list source [file join $dir .. ip_top ctrl ddr3.tcl]]
package ifneeded altera_emif::ip_top::ctrl::ddr4                     0.1 [list source [file join $dir .. ip_top ctrl ddr4.tcl]]
package ifneeded altera_emif::ip_top::ctrl::rld3                     0.1 [list source [file join $dir .. ip_top ctrl rld3.tcl]]
package ifneeded altera_emif::ip_top::ctrl::qdr2                     0.1 [list source [file join $dir .. ip_top ctrl qdr2.tcl]]
package ifneeded altera_emif::ip_top::ctrl::rld2                     0.1 [list source [file join $dir .. ip_top ctrl rld2.tcl]]
package ifneeded altera_emif::ip_top::ctrl::qdr4                     0.1 [list source [file join $dir .. ip_top ctrl qdr4.tcl]]
package ifneeded altera_emif::ip_top::ctrl::lpddr3                   0.1 [list source [file join $dir .. ip_top ctrl lpddr3.tcl]]
package ifneeded altera_emif::ip_top::diag                           0.1 [list source [file join $dir .. ip_top diag.tcl]]
package ifneeded altera_emif::ip_top::diag::ddr3                     0.1 [list source [file join $dir .. ip_top diag ddr3.tcl]]
package ifneeded altera_emif::ip_top::diag::ddr4                     0.1 [list source [file join $dir .. ip_top diag ddr4.tcl]]
package ifneeded altera_emif::ip_top::diag::rld3                     0.1 [list source [file join $dir .. ip_top diag rld3.tcl]]
package ifneeded altera_emif::ip_top::diag::qdr2                     0.1 [list source [file join $dir .. ip_top diag qdr2.tcl]]
package ifneeded altera_emif::ip_top::diag::rld2                     0.1 [list source [file join $dir .. ip_top diag rld2.tcl]]
package ifneeded altera_emif::ip_top::diag::qdr4                     0.1 [list source [file join $dir .. ip_top diag qdr4.tcl]]
package ifneeded altera_emif::ip_top::diag::lpddr3                   0.1 [list source [file join $dir .. ip_top diag lpddr3.tcl]]

package ifneeded altera_emif::arch_common::main                      0.1 [list source [file join $dir .. arch_common main.tcl]]
package ifneeded altera_emif::arch_common::util                      0.1 [list source [file join $dir .. arch_common util.tcl]]
package ifneeded altera_emif::arch_common::seq_param_tbl             0.1 [list source [file join $dir .. arch_common seq_param_tbl.tcl]]
package ifneeded altera_emif::arch_common::timing                    0.1 [list source [file join $dir .. arch_common timing.tcl]]

package ifneeded altera_emif::ip_arch_nf::main                       0.1 [list source [file join $dir .. ip_arch_nf main.tcl]]
package ifneeded altera_emif::ip_arch_nf::util                       0.1 [list source [file join $dir .. ip_arch_nf util.tcl]]
package ifneeded altera_emif::ip_arch_nf::rtl_autogen                0.1 [list source [file join $dir .. ip_arch_nf rtl_autogen.tcl]]
package ifneeded altera_emif::ip_arch_nf::doc_gen                    0.1 [list source [file join $dir .. ip_arch_nf doc_gen.tcl]]
package ifneeded altera_emif::ip_arch_nf::enum_defs                  0.1 [list source [file join $dir .. ip_arch_nf enum_defs.tcl]]
package ifneeded altera_emif::ip_arch_nf::enum_defs_seq_param_tbl    0.1 [list source [file join $dir .. ip_arch_nf enum_defs_seq_param_tbl.tcl]]
package ifneeded altera_emif::ip_arch_nf::enum_defs_ac_pin_mapping   0.1 [list source [file join $dir .. ip_arch_nf enum_defs_ac_pin_mapping.tcl]]
package ifneeded altera_emif::ip_arch_nf::enum_defs_hmc_cfgs         0.1 [list source [file join $dir .. ip_arch_nf enum_defs_hmc_cfgs.tcl]]
package ifneeded altera_emif::ip_arch_nf::enum_defs_ioaux            0.1 [list source [file join $dir .. ip_arch_nf enum_defs_ioaux.tcl]]
package ifneeded altera_emif::ip_arch_nf::enum_defs_timing_params    0.1 [list source [file join $dir .. ip_arch_nf enum_defs_timing_params.tcl]]
package ifneeded altera_emif::ip_arch_nf::enum_defs_hps              0.1 [list source [file join $dir .. ip_arch_nf enum_defs_hps.tcl]]
package ifneeded altera_emif::ip_arch_nf::arch_expert_exports        0.1 [list source [file join $dir .. ip_arch_nf arch_expert_exports.tcl]]
package ifneeded altera_emif::ip_arch_nf::protocol_expert            0.1 [list source [file join $dir .. ip_arch_nf protocol_expert.tcl]]
package ifneeded altera_emif::ip_arch_nf::pll                        0.1 [list source [file join $dir .. ip_arch_nf pll.tcl]]
package ifneeded altera_emif::ip_arch_nf::seq_param_tbl              0.1 [list source [file join $dir .. ip_arch_nf seq_param_tbl.tcl]]
package ifneeded altera_emif::ip_arch_nf::timing                     0.1 [list source [file join $dir .. ip_arch_nf timing.tcl]]
package ifneeded altera_emif::ip_arch_nf::hps                        0.1 [list source [file join $dir .. ip_arch_nf hps.tcl]]
package ifneeded altera_emif::ip_arch_nf::hps_csr                    0.1 [list source [file join $dir .. ip_arch_nf hps_csr.tcl]]
package ifneeded altera_emif::ip_arch_nf::ddrx                       0.1 [list source [file join $dir .. ip_arch_nf ddrx.tcl]]
package ifneeded altera_emif::ip_arch_nf::ddr4                       0.1 [list source [file join $dir .. ip_arch_nf ddr4.tcl]]
package ifneeded altera_emif::ip_arch_nf::ddr3                       0.1 [list source [file join $dir .. ip_arch_nf ddr3.tcl]]
package ifneeded altera_emif::ip_arch_nf::lpddr3                     0.1 [list source [file join $dir .. ip_arch_nf lpddr3.tcl]]
package ifneeded altera_emif::ip_arch_nf::rldx                       0.1 [list source [file join $dir .. ip_arch_nf rldx.tcl]]
package ifneeded altera_emif::ip_arch_nf::rld3                       0.1 [list source [file join $dir .. ip_arch_nf rld3.tcl]]
package ifneeded altera_emif::ip_arch_nf::rld2                       0.1 [list source [file join $dir .. ip_arch_nf rld2.tcl]]
package ifneeded altera_emif::ip_arch_nf::qdrx                       0.1 [list source [file join $dir .. ip_arch_nf qdrx.tcl]]
package ifneeded altera_emif::ip_arch_nf::qdr4                       0.1 [list source [file join $dir .. ip_arch_nf qdr4.tcl]]
package ifneeded altera_emif::ip_arch_nf::qdr2                       0.1 [list source [file join $dir .. ip_arch_nf qdr2.tcl]]

package ifneeded altera_emif::ip_arch_nd::main                       0.1 [list source [file join $dir .. ip_arch_nd main.tcl]]
package ifneeded altera_emif::ip_arch_nd::util                       0.1 [list source [file join $dir .. ip_arch_nd util.tcl]]
package ifneeded altera_emif::ip_arch_nd::rtl_autogen                0.1 [list source [file join $dir .. ip_arch_nd rtl_autogen.tcl]]
package ifneeded altera_emif::ip_arch_nd::doc_gen                    0.1 [list source [file join $dir .. ip_arch_nd doc_gen.tcl]]
package ifneeded altera_emif::ip_arch_nd::enum_defs                  0.1 [list source [file join $dir .. ip_arch_nd enum_defs.tcl]]
package ifneeded altera_emif::ip_arch_nd::enum_defs_seq_param_tbl    0.1 [list source [file join $dir .. ip_arch_nd enum_defs_seq_param_tbl.tcl]]
package ifneeded altera_emif::ip_arch_nd::enum_defs_ac_pin_mapping   0.1 [list source [file join $dir .. ip_arch_nd enum_defs_ac_pin_mapping.tcl]]
package ifneeded altera_emif::ip_arch_nd::enum_defs_hmc_cfgs         0.1 [list source [file join $dir .. ip_arch_nd enum_defs_hmc_cfgs.tcl]]
package ifneeded altera_emif::ip_arch_nd::enum_defs_timing_params    0.1 [list source [file join $dir .. ip_arch_nd enum_defs_timing_params.tcl]]
package ifneeded altera_emif::ip_arch_nd::arch_expert_exports        0.1 [list source [file join $dir .. ip_arch_nd arch_expert_exports.tcl]]
package ifneeded altera_emif::ip_arch_nd::protocol_expert            0.1 [list source [file join $dir .. ip_arch_nd protocol_expert.tcl]]
package ifneeded altera_emif::ip_arch_nd::pll                        0.1 [list source [file join $dir .. ip_arch_nd pll.tcl]]
package ifneeded altera_emif::ip_arch_nd::seq_param_tbl              0.1 [list source [file join $dir .. ip_arch_nd seq_param_tbl.tcl]]
package ifneeded altera_emif::ip_arch_nd::timing                     0.1 [list source [file join $dir .. ip_arch_nd timing.tcl]]
package ifneeded altera_emif::ip_arch_nd::hps                        0.1 [list source [file join $dir .. ip_arch_nd hps.tcl]]
package ifneeded altera_emif::ip_arch_nd::ddrx                       0.1 [list source [file join $dir .. ip_arch_nd ddrx.tcl]]
package ifneeded altera_emif::ip_arch_nd::ddr4                       0.1 [list source [file join $dir .. ip_arch_nd ddr4.tcl]]
package ifneeded altera_emif::ip_arch_nd::ddr3                       0.1 [list source [file join $dir .. ip_arch_nd ddr3.tcl]]
package ifneeded altera_emif::ip_arch_nd::lpddr3                     0.1 [list source [file join $dir .. ip_arch_nd lpddr3.tcl]]
package ifneeded altera_emif::ip_arch_nd::rldx                       0.1 [list source [file join $dir .. ip_arch_nd rldx.tcl]]
package ifneeded altera_emif::ip_arch_nd::rld3                       0.1 [list source [file join $dir .. ip_arch_nd rld3.tcl]]
package ifneeded altera_emif::ip_arch_nd::rld2                       0.1 [list source [file join $dir .. ip_arch_nd rld2.tcl]]
package ifneeded altera_emif::ip_arch_nd::qdrx                       0.1 [list source [file join $dir .. ip_arch_nd qdrx.tcl]]
package ifneeded altera_emif::ip_arch_nd::qdr4                       0.1 [list source [file join $dir .. ip_arch_nd qdr4.tcl]]
package ifneeded altera_emif::ip_arch_nd::qdr2                       0.1 [list source [file join $dir .. ip_arch_nd qdr2.tcl]]

package ifneeded altera_emif::ip_board_delay_model::main             0.1 [list source [file join $dir .. ip_board_delay_model main.tcl]]
package ifneeded altera_emif::ip_board_delay_model::util             0.1 [list source [file join $dir .. ip_board_delay_model util.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_top::main             0.1 [list source [file join $dir .. ip_mem_model ip_top main.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_core_ddr3::main       0.1 [list source [file join $dir .. ip_mem_model ip_core_ddr3 main.tcl]]
package ifneeded altera_emif::ip_mem_model::ip_core_ddr3::util       0.1 [list source [file join $dir .. ip_mem_model ip_core_ddr3 util.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_core_ddr4::main       0.1 [list source [file join $dir .. ip_mem_model ip_core_ddr4 main.tcl]]
package ifneeded altera_emif::ip_mem_model::ip_core_ddr4::util       0.1 [list source [file join $dir .. ip_mem_model ip_core_ddr4 util.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_core_qdr2::main       0.1 [list source [file join $dir .. ip_mem_model ip_core_qdr2 main.tcl]]
package ifneeded altera_emif::ip_mem_model::ip_core_qdr2::util       0.1 [list source [file join $dir .. ip_mem_model ip_core_qdr2 util.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_core_rld3::main       0.1 [list source [file join $dir .. ip_mem_model ip_core_rld3 main.tcl]]
package ifneeded altera_emif::ip_mem_model::ip_core_rld3::util       0.1 [list source [file join $dir .. ip_mem_model ip_core_rld3 util.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_core_rld2::main       0.1 [list source [file join $dir .. ip_mem_model ip_core_rld2 main.tcl]]
package ifneeded altera_emif::ip_mem_model::ip_core_rld2::util       0.1 [list source [file join $dir .. ip_mem_model ip_core_rld2 util.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_core_qdr4::main       0.1 [list source [file join $dir .. ip_mem_model ip_core_qdr4 main.tcl]]
package ifneeded altera_emif::ip_mem_model::ip_core_qdr4::util       0.1 [list source [file join $dir .. ip_mem_model ip_core_qdr4 util.tcl]]

package ifneeded altera_emif::ip_mem_model::ip_core_lpddr3::main     0.1 [list source [file join $dir .. ip_mem_model ip_core_lpddr3 main.tcl]]
package ifneeded altera_emif::ip_mem_model::ip_core_lpddr3::util     0.1 [list source [file join $dir .. ip_mem_model ip_core_lpddr3 util.tcl]]

package ifneeded altera_emif::ip_ctrl::util                          0.1 [list source [file join $dir .. ip_ctrl common util.tcl]]

package ifneeded altera_emif::ip_ctrl::ip_qdr2::main                 0.1 [list source [file join $dir .. ip_ctrl ip_qdr2 main.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_qdr2::ctrl_expert_exports  0.1 [list source [file join $dir .. ip_ctrl ip_qdr2 ctrl_expert_exports.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_qdr2::enum_defs            0.1 [list source [file join $dir .. ip_ctrl ip_qdr2 enum_defs.tcl]]

package ifneeded altera_emif::ip_ctrl::ip_qdr4::main                 0.1 [list source [file join $dir .. ip_ctrl ip_qdr4 main.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_qdr4::ctrl_expert_exports  0.1 [list source [file join $dir .. ip_ctrl ip_qdr4 ctrl_expert_exports.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_qdr4::enum_defs            0.1 [list source [file join $dir .. ip_ctrl ip_qdr4 enum_defs.tcl]]

package ifneeded altera_emif::ip_ctrl::ip_rld3::main                 0.1 [list source [file join $dir .. ip_ctrl ip_rld3 main.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_rld3::ctrl_expert_exports  0.1 [list source [file join $dir .. ip_ctrl ip_rld3 ctrl_expert_exports.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_rld3::enum_defs            0.1 [list source [file join $dir .. ip_ctrl ip_rld3 enum_defs.tcl]]

package ifneeded altera_emif::ip_ctrl::ip_rld2::main                 0.1 [list source [file join $dir .. ip_ctrl ip_rld2 main.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_rld2::ctrl_expert_exports  0.1 [list source [file join $dir .. ip_ctrl ip_rld2 ctrl_expert_exports.tcl]]
package ifneeded altera_emif::ip_ctrl::ip_rld2::enum_defs            0.1 [list source [file join $dir .. ip_ctrl ip_rld2 enum_defs.tcl]]

package ifneeded altera_emif::ip_sim_checker::main                   0.1 [list source [file join $dir .. ip_sim_checker main.tcl]]

package ifneeded altera_emif::ip_sig_splitter::main                  0.1 [list source [file join $dir .. ip_sig_splitter main.tcl]]

package ifneeded altera_emif::ip_tg_afi::util                        0.1 [list source [file join $dir .. ip_tg_afi common util.tcl]]
package ifneeded altera_emif::ip_tg_afi::enum_defs                   0.1 [list source [file join $dir .. ip_tg_afi common enum_defs.tcl]]

package ifneeded altera_emif::ip_tg_afi::ip_rld3::main               0.1 [list source [file join $dir .. ip_tg_afi ip_rld3 main.tcl]]

package ifneeded altera_emif::ip_tg_afi::ip_ddr3::main               0.1 [list source [file join $dir .. ip_tg_afi ip_ddr3 main.tcl]]

package ifneeded altera_emif::ip_tg_afi::ip_ddr4::main               0.1 [list source [file join $dir .. ip_tg_afi ip_ddr4 main.tcl]]

package ifneeded altera_emif::ip_tg_afi::ip_qdr4::main               0.1 [list source [file join $dir .. ip_tg_afi ip_qdr4 main.tcl]]

package ifneeded altera_emif::ip_tg_afi::ip_lpddr3::main             0.1 [list source [file join $dir .. ip_tg_afi ip_lpddr3 main.tcl]]

package ifneeded altera_emif::ip_tg_avl::main                        0.1 [list source [file join $dir .. ip_tg_avl main.tcl]]
package ifneeded altera_emif::ip_tg_avl::util                        0.1 [list source [file join $dir .. ip_tg_avl util.tcl]]
package ifneeded altera_emif::ip_tg_avl::enum_defs                   0.1 [list source [file join $dir .. ip_tg_avl enum_defs.tcl]]

package ifneeded altera_emif::ip_col_if::main                        0.1 [list source [file join $dir .. ip_col_if main.tcl]]

package ifneeded altera_emif::ip_soft_nios::main                     0.1 [list source [file join $dir .. ip_soft_nios main.tcl]]

package ifneeded altera_emif::ip_cal_slave::ip_core_nf::main             0.1 [list source [file join $dir .. ip_cal_slave ip_core_nf main.tcl]]
package ifneeded altera_emif::ip_cal_slave::ip_core_nd::main             0.1 [list source [file join $dir .. ip_cal_slave ip_core_nd main.tcl]]

package ifneeded altera_emif::ip_ecc::ip_top::main                   0.1 [list source [file join $dir .. ip_ecc ip_top main.tcl]]

package ifneeded altera_emif::ip_ecc::ip_core_nf::main                  0.1 [list source [file join $dir .. ip_ecc ip_core_nf main.tcl]]
package ifneeded altera_emif::ip_ecc::ip_core_nf::util                  0.1 [list source [file join $dir .. ip_ecc ip_core_nf util.tcl]]
package ifneeded altera_emif::ip_ecc::ip_core_nf::enum_defs             0.1 [list source [file join $dir .. ip_ecc ip_core_nf enum_defs.tcl]]

package ifneeded altera_emif::ip_ecc::ip_core_nd::main                  0.1 [list source [file join $dir .. ip_ecc ip_core_nd main.tcl]]
package ifneeded altera_emif::ip_ecc::ip_core_nd::util                  0.1 [list source [file join $dir .. ip_ecc ip_core_nd util.tcl]]
package ifneeded altera_emif::ip_ecc::ip_core_nd::enum_defs             0.1 [list source [file join $dir .. ip_ecc ip_core_nd enum_defs.tcl]]

package ifneeded altera_emif::ip_tg_avl_2::main                        0.1 [list source [file join $dir .. ip_tg_avl_2 main.tcl]]
package ifneeded altera_emif::ip_tg_avl_2::util                        0.1 [list source [file join $dir .. ip_tg_avl_2 util.tcl]]
package ifneeded altera_emif::ip_tg_avl_2::enum_defs                   0.1 [list source [file join $dir .. ip_tg_avl_2 enum_defs.tcl]]

