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


###########################################################################################################
# Notes: Update path variables 
# QUARTUS_ROOTDIR based on Quartus install location 
# SNK_SIM_LOCATION to where generated simulation files for Sink Interface are located
# SRC_SIM_LOCATION to where generated simulation files for Source Interface are located
###########################################################################################################


# Compile the Interlaken and Transceiver Reconfig IP

vcs -lca -sverilog +verilog2001ext+.v -timescale=1ps/1ps +define+ALTERA +define+SIMULATION +define+SERIALLITE_III_FOR_A10 \
  +define+DUPLEX_MODE +incdir+../../src+../ -debug_pp \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/altera_primitives.v \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/220model.v \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/altera_mf.v \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/sgate.v \
     $QUARTUS_ROOTDIR/eda/sim_lib/altera_lnsim.sv \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/twentynm_atoms.v \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/synopsys/twentynm_atoms_ncrypt.v \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/twentynm_hssi_atoms.v \
  -v $QUARTUS_ROOTDIR/eda/sim_lib/synopsys/twentynm_hssi_atoms_ncrypt.v \
  $SIM_LOCATION/altera_iopll_160/sim/*altera_iopll_160*.vo \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/altera_xcvr_native_a10_functions_h.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/twentynm_xcvr_avmm.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_resync.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_arbiter.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/a10_avmm_h.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_arb.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/a10_xcvr_atx_pll.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_embedded_debug.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_avmm_csr.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/*_altera_xcvr_atx_pll_a10_*.sv \
  $SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_opt_logic_*.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_arbiter.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_avmm_csr.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_prbs_accum.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_odi_accel.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_arb.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_opt_logic_*.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_pcs.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_pma.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_xcvr_native.sv \
  $SIM_LOCATION/altera_xcvr_native_a10_160/sim/*_altera_xcvr_native_a10_*.sv \
  $SIM_LOCATION/seriallite_iii_a10_160/sim/native_ilk_wrapper*.v \
  $SIM_LOCATION/seriallite_iii_a10_160/sim/interlaken_native_wrapper_duplex_*.v \
  -F interlaken_a10_native.txt \
  \"+incdir+$SIM_LOCATION/seriallite_iii_a10_160/sim/\" $SIM_LOCATION/seriallite_iii_a10_160/sim/seriallite_iii_streaming.v \
  -F seriallite_src_lst_vcs.txt \
  -top test_env 

# use +random_seed='value' for a specific random_seed

./simv -l transcript_vcs -vcd dump.vcd +test_name=data_forwarding +random_seed=222

