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

rm -fr ./libraries/work/
rm -fr ./libraries/sink_seriallite_iii/
rm -fr ./libraries/source_seriallite_iii/
mkdir -p ./libraries/work/
mkdir -p ./libraries/sink_seriallite_iii/
mkdir -p ./libraries/source_seriallite_iii/

echo "WORK > DEFAULT" > synopsys_sim.setup
echo "DEFAULT:                          ./libraries/work/" >> synopsys_sim.setup
echo "work:                             ./libraries/work/" >> synopsys_sim.setup
echo "sink_seriallite_iii:      ./libraries/sink_seriallite_iii/" >> synopsys_sim.setup
echo "source_seriallite_iii:     ./libraries/source_seriallite_iii/" >> synopsys_sim.setup
echo "LIBRARY_SCAN = TRUE" >> synopsys_sim.setup




# Compile the Interlaken and Transceiver Reconfig IP
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/altera_primitives.v" 
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/220model.v" 
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/altera_mf.v" 
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/sgate.v" 
vlogan +v2k -sverilog  "$QUARTUS_ROOTDIR/eda/sim_lib/altera_lnsim.sv" 
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/twentynm_atoms.v" 
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/synopsys/twentynm_atoms_ncrypt.v" 
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/twentynm_hssi_atoms.v" 
vlogan +v2k   "$QUARTUS_ROOTDIR/eda/sim_lib/synopsys/twentynm_hssi_atoms_ncrypt.v" 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_iopll_160/sim/*_altera_iopll_160_*.vo
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/altera_xcvr_native_a10_functions_h.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/twentynm_xcvr_avmm.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_resync.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_arbiter.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/a10_avmm_h.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_arb.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/a10_xcvr_atx_pll.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_embedded_debug.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_avmm_csr.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/*_altera_xcvr_atx_pll_a10_*.sv
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_opt_logic_*.sv
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_arbiter.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_avmm_csr.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_prbs_accum.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_odi_accel.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_arb.sv
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/altera_xcvr_native_a10_functions_h.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_pcs.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_pma.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_xcvr_native.sv 
vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_native_a10_160/sim/*_altera_xcvr_native_a10_*.sv 
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/*_altera_xcvr_native_a10_*.sv 

vlogan +v2k -sverilog +define+ALTERA +define+SIMULATION +define+SERIALLITE_III_FOR_A10 \
 +incdir+../../src+../ -debug_pp \
  -F interlaken_a10_native.txt \
  -F seriallite_src_lst_vcs.txt 

vlogan +v2k -sverilog  $SNK_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_opt_logic_*.sv
vlogan +v2k -sverilog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_opt_logic_*.sv
vlogan +v2k           "$SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/native_ilk_wrapper_rx*.v"                            -work sink_seriallite_iii
vlogan +v2k           "$SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/native_ilk_wrapper_tx*.v"                            -work source_seriallite_iii
vlogan +v2k           \"+incdir+$SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/\" "$SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/interlaken_native_wrapper_duplex_*.v"                -work source_seriallite_iii
vlogan +v2k           \"+incdir+$SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/\" "$SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/interlaken_native_wrapper_duplex_*.v"                -work sink_seriallite_iii
vlogan +v2k           \"+incdir+$SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/\" "$SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/seriallite_iii_streaming_source.v"                 -work source_seriallite_iii
vlogan +v2k           \"+incdir+$SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/\" "$SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/seriallite_iii_streaming_sink.v"                   -work sink_seriallite_iii


# use +random_seed='value' for a specific random_seed
vcs -lca -timescale=1ps/1ps -debug_pp -top test_env

./simv -l transcript_vcs -vcd dump.vcd +test_name=data_forwarding +random_seed=222


