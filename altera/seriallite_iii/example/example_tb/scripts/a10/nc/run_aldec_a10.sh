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


rm -rf work
rm -rf sink_seriallite_iii
rm -rf source_seriallite_iii
vlib work
vlib source_seriallite_iii
vlib sink_seriallite_iii

# Compile the simulation Libraries
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/altera_primitives.v
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/220model.v
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/altera_mf.v
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/sgate.v
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/altera_lnsim.sv
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/aldec/twentynm_hssi_atoms_ncrypt.v
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/twentynm_hssi_atoms.v
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/twentynm_atoms.v
vlog +acc -sv $QUARTUS_ROOTDIR/eda/sim_lib/aldec/twentynm_atoms_ncrypt.v

# Compile the Interlaken and Transceiver Reconfiguration IPs
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_resync.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_arbiter.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_pcs.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_pma.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_xcvr_avmm.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/twentynm_xcvr_native.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/altera_xcvr_native_a10_functions_h.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/a10_avmm_h.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_avmm_csr.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_prbs_accum.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_odi_accel.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_arb.sv
#vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_embedded_debug.sv
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/*_altera_xcvr_native_a10_160_*.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_native_a10_160/sim/*_altera_xcvr_native_a10_160_*.sv
vlog  $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/interlaken_native_wrapper_duplex_*.v -work sink_seriallite_iii 

vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_native_avmm_nf.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/altera_xcvr_atx_pll_a10.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/a10_xcvr_atx_pll.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_embedded_debug.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_avmm_csr.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/altera_xcvr_native_a10_functions_h.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/twentynm_xcvr_avmm.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_resync.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_arbiter.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/a10_avmm_h.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_arb.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/a10_xcvr_atx_pll.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_embedded_debug.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_pll_avmm_csr.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/*_altera_xcvr_atx_pll_a10_*.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_atx_pll_a10_160/sim/alt_xcvr_atx_pll_rcfg_opt_logic_*.sv
vlog  $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_atx_pll.v


vlog  $SRC_SIM_LOCATION/altera_iopll_160/sim/*_altera_iopll_160_*.vo
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/altera_iopll_inst.v

vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/core_reset_logic.v
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/alt_xcvr_csr_common_h.sv
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/alt_xcvr_csr_pcs8g_h.sv
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/sv_xcvr_h.sv
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/altera_xcvr_interlaken/altera_xcvr_functions.sv
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_csr_common.sv 
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_native/ilk_mux.v
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_interlaken_amm_slave.v
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_interlaken_soft_pbip.sv
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_native/alt_xcvr_reset_counter.sv
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_native/altera_wait_generate.v
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/a10_native/altera_xcvr_reset_control.sv
vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/interlaken_native_wrapper_duplex_*.v -work source_seriallite_iii  
vlog  $SRC_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_opt_logic_*.sv
vlog  $SNK_SIM_LOCATION/altera_xcvr_native_a10_160/sim/alt_xcvr_native_rcfg_opt_logic_*.sv

vlog  $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/native_ilk_wrapper_tx*.v -work source_seriallite_iii
vlog  $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/native_ilk_wrapper_rx*.v -work sink_seriallite_iii

# Compile the generic design files
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/seriallite_iii_streaming_source.v +access +w +define+ALTERA +define+SIMULATION -work source_seriallite_iii
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/clock_gen.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_source_adaptation.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_source_adaptation_ecc.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_source_application.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_source_control.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_source_csr.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_source_mac.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_dp_sync.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/control_word_decoder.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/aclr_filter.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/dcfifo_s5m20k.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/delay_regs.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/eq_5_ena.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/gray_cntr_5_sl.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/gray_to_bin_5.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/neq_5_ena.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/s5m20k_ecc_1r1w.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/sync_regs_aclr_m2.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/wys_lut.v +access +w +define+ALTERA +define+SIMULATION 

// Sink Components
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/seriallite_iii_streaming_sink.v +access +w +define+ALTERA +define+SIMULATION -work sink_seriallite_iii
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_sink_mac.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_sink_csr.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_sink_application.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_sink_alignment.v +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_sink_adaptation.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_sink_dcfifo.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ $SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/aldec/altera_sl3_sink_dcfifo_fifo.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ -f seriallite_src_lst_rivr.txt +access +w +define+ALTERA +define+SIMULATION +define+SERIALLITE_III_FOR_A10 

vsim -c -novopt -L work -L source_seriallite_iii -L sink_seriallite_iii +test_name=data_forwarding +define+ALTERA +access +w +define+SIMULATION  +define+SERIALLITE_III_FOR_A10 test_env -do vrun.do
