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


###############################################################################
## altera_phylite::util
###############################################################################
package ifneeded altera_phylite::util::enum_defs   0.1 [list source [file join $dir .. util enum_defs.tcl]]
package ifneeded altera_phylite::util::arch_expert 0.1 [list source [file join $dir .. util arch_expert.tcl]]
package ifneeded altera_phylite::util::hwtcl_utils 0.1 [list source [file join $dir .. util hwtcl_utils.tcl]]

###############################################################################
## altera_phylite::ip_top
###############################################################################
package ifneeded altera_phylite::ip_top::main      0.1 [list source [file join $dir .. ip_top main.tcl]]
package ifneeded altera_phylite::ip_top::general   0.1 [list source [file join $dir .. ip_top general.tcl]]
package ifneeded altera_phylite::ip_top::group     0.1 [list source [file join $dir .. ip_top group.tcl]]
package ifneeded altera_phylite::ip_top::exports   0.1 [list source [file join $dir .. ip_top exports.tcl]]
package ifneeded altera_phylite::ip_top::ex_design 0.1 [list source [file join $dir .. ip_top ex_design.tcl]]

###############################################################################
## altera_phylite::ip_arch_nf
###############################################################################
package ifneeded altera_phylite::ip_arch_nf::main                        0.1 [list source [file join $dir .. ip_arch_nf main.tcl]]
package ifneeded altera_phylite::ip_arch_nf::pll                         0.1 [list source [file join $dir .. ip_arch_nf pll.tcl]]
package ifneeded altera_phylite::ip_arch_nf::sdc                         0.1 [list source [file join $dir .. ip_arch_nf sdc.tcl]]
package ifneeded altera_phylite::ip_arch_nf::ioaux_param_table           0.1 [list source [file join $dir .. ip_arch_nf ioaux_param_table.tcl]]
package ifneeded altera_phylite::ip_arch_nf::enum_defs_timing_params     0.1 [list source [file join $dir .. ip_arch_nf enum_defs_timing_params.tcl]]
package ifneeded altera_phylite::ip_arch_nf::timing                      0.1 [list source [file join $dir .. ip_arch_nf timing.tcl]]
package ifneeded altera_phylite::ip_arch_nf::arch_expert_exports         0.1 [list source [file join $dir .. ip_arch_nf arch_expert_exports.tcl]]

###############################################################################
## altera_phylite::ip_arch_nd
###############################################################################
package ifneeded altera_phylite::ip_arch_nd::main                        0.1 [list source [file join $dir .. ip_arch_nd main.tcl]]
package ifneeded altera_phylite::ip_arch_nd::pll                         0.1 [list source [file join $dir .. ip_arch_nd pll.tcl]]
package ifneeded altera_phylite::ip_arch_nd::sdc                         0.1 [list source [file join $dir .. ip_arch_nd sdc.tcl]]
package ifneeded altera_phylite::ip_arch_nd::ioaux_param_table           0.1 [list source [file join $dir .. ip_arch_nd ioaux_param_table.tcl]]
package ifneeded altera_phylite::ip_arch_nd::enum_defs_timing_params     0.1 [list source [file join $dir .. ip_arch_nd enum_defs_timing_params.tcl]]
package ifneeded altera_phylite::ip_arch_nd::timing                      0.1 [list source [file join $dir .. ip_arch_nd timing.tcl]]
package ifneeded altera_phylite::ip_arch_nd::arch_expert_exports         0.1 [list source [file join $dir .. ip_arch_nd arch_expert_exports.tcl]]


###############################################################################
## altera_phylite::ip_driver
###############################################################################
package ifneeded altera_phylite::ip_driver::main    0.1 [list source [file join $dir .. ip_driver main.tcl]]

###############################################################################
## altera_phylite::ip_agent
###############################################################################
package ifneeded altera_phylite::ip_agent::main    0.1 [list source [file join $dir .. ip_agent main.tcl]]

###############################################################################
## altera_phylite::ip_sim_ctrl
###############################################################################
package ifneeded altera_phylite::ip_sim_ctrl::main    0.1 [list source [file join $dir .. ip_sim_ctrl main.tcl]]

###############################################################################
## altera_phylite::ip_addr_cmd
###############################################################################
package ifneeded altera_phylite::ip_addr_cmd::main    0.1 [list source [file join $dir .. ip_addr_cmd main.tcl]]

###############################################################################
## altera_phylite::ip_avl_ctrl
###############################################################################
package ifneeded altera_phylite::ip_avl_ctrl::main    0.1 [list source [file join $dir .. ip_avl_ctrl main.tcl]]

###############################################################################
## altera_phylite::ip_cfg_ctrl
###############################################################################
package ifneeded altera_phylite::ip_cfg_ctrl::main    0.1 [list source [file join $dir .. ip_cfg_ctrl main.tcl]]
