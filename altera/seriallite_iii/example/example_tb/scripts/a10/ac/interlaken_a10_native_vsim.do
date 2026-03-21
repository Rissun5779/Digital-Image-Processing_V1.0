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


# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# Compile native PHY and wrapper files

vlog -sv $env(SIM_LOCATION)/altera_xcvr_native_a10_160/sim/altera_xcvr_native_a10_functions_h.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_native_a10_160/sim/*.sv

vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/core_reset_logic.v
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/alt_xcvr_csr_common_h.sv
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/alt_xcvr_csr_pcs8g_h.sv
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/sv_xcvr_h.sv
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/altera_xcvr_functions.sv
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_reset_counter.sv
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/altera_wait_generate.v
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/altera_xcvr_reset_control.sv
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/ilk_mux.v
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_csr_common.sv 
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/ilk_mux.v
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_interlaken_amm_slave.v
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_interlaken_soft_pbip.sv
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/interlaken_native_wrapper_duplex*.v  
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/*.v

# Compile test-bench components - PLLs
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/twentynm_xcvr_avmm.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_resync.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_arbiter.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/a10_avmm_h.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_arb.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/a10_xcvr_atx_pll.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_embedded_debug.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_avmm_csr.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/*altera_xcvr_atx_pll_a10_*.sv
vlog -sv $env(SIM_LOCATION)/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_opt_logic_*.sv

vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/a10_atx_pll.v