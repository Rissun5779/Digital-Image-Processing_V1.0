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


#!/bin/sh
# specify where example design simulation libraries are generated for 25G
QSYS_SIMDIR="/data/fkhan/qshells/50g/p4/ip/ethernet/alt_e2550/testgen/alt_e2550_example_design/ex_25g/sim"
# specify quartus path
QUARTUS_INSTALL_DIR="/data/fkhan/qshells/50g/acds/quartus/"

vcs -lca -l compile.log  -debug_all -sverilog +verilog2001ext+.v -timescale=1ps/1ps \
  +incdir+../../25g/rtl/mac +incdir+../../25g/rtl/pcs  \
  +incdir+../../25g/rtl/pma +incdir+../../25g/rtl/top \
  +incdir+../../hslx +incdir+../../../alt_eth_ultra/testbench/includes \
  +incdir+../../qsys/atx_pll_e50g/altera_xcvr_atx_pll_a10_150/sim \
  +incdir+../../qsys/rxcore_pll/altera_xcvr_fpll_a10_150/sim \
  +incdir+../../qsys/txcore_pll/altera_iopll_150/sim \
  +incdir+../../qsys/rxcore_pll/sim \
  +incdir+../../qsys/txcore_pll/sim \
  -y ../../25g/rtl/mac -y ../../25g/rtl/pcs \
  -y ../../25g/rtl/pma -y ../../25g/rtl/top \
  -y ../../hslx \
  -y ../../25g/rtl/ast \
  -y ../../25g/rtl/csr \
  -y ../../25g/rtl/rsfec \
  -y ../../qsys/atx_pll_e50g/altera_xcvr_atx_pll_a10_150/sim \
  -y ../../qsys/rxcore_pll/altera_xcvr_fpll_a10_150/sim \
 +libext+.v+.sv+vo+ \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v \
     $QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim.sv \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/twentynm_atoms_ncrypt.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/twentynm_hssi_atoms.v \
  -v $QUARTUS_INSTALL_DIR/eda/sim_lib/synopsys/twentynm_hssi_atoms_ncrypt.v \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/altera_xcvr_native_a10_functions_h.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/twentynm_xcvr_avmm.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_resync.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_arbiter.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/a10_avmm_h.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_arb.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/a10_xcvr_atx_pll.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_embedded_debug.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_avmm_csr.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/ex_25g_altera_xcvr_atx_pll_a10_160_bampmdq.sv \
  $QSYS_SIMDIR/../altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_opt_logic_bampmdq.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/twentynm_pcs.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/twentynm_pma.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/twentynm_xcvr_native.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/alt_xcvr_native_pipe_retry.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/alt_xcvr_native_avmm_csr.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/alt_xcvr_native_prbs_accum.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/alt_xcvr_native_odi_accel.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_arb.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/ex_25g_altera_xcvr_native_a10_160_z7jzymy.sv \
  $QSYS_SIMDIR/../altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_opt_logic_z7jzymy.sv \
  $QSYS_SIMDIR/../alt_e2550_160/sim/atx_pll_e50g.v \
  $QSYS_SIMDIR/../alt_e2550_160/sim/a10_xcvr_25g.v \
  ./alt_e25_otn_tb.sv \
  -top alt_e25_otn_tb -cm_dir ./simv.vdb

./simv -l sim.log  +vcs+lic+wait 

