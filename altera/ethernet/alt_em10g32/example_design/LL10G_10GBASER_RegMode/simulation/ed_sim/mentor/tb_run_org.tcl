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


global env ;
if [regexp {ModelSim ALTERA} [vsim -version]] {
    ;# Using OEM Version ModelSIM .ini file (modelsim.ini at ModelSIM Altera installation directory) 
} else {
    # Using non-OEM Version, compile all of the libraries
    vlib lpm_ver
    vmap lpm_ver lpm_ver 
    vlog -work lpm_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/220model.v 

    vlib altera_mf_ver
    vmap altera_mf_ver altera_mf_ver
    vlog -work altera_mf_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf.v

    vlib sgate_ver
    vmap sgate_ver sgate_ver
    vlog -work sgate_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate.v
    
    # vlib cycloneiv_hssi_ver
    # vmap cycloneiv_hssi_ver cycloneiv_hssi_ver
    # vlog -work cycloneiv_hssi_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/cycloneiv_hssi_atoms.v
    # vlog -work cycloneiv_hssi_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/cycloneiv_pcie_hip_atoms.v
    # vlog -work cycloneiv_hssi_ver $env(QUARTUS_ROOTDIR)/eda/sim_lib/cycloneiv_atom.v
    
    
}

# Create the work library
vlib work
vlib reset_controller

# Compile Avalon VIP
vlog -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/lib/verbosity_pkg.sv
vlog -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/lib/avalon_mm_pkg.sv
vlog -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/lib/avalon_utilities_pkg.sv
vlog -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/altera_avalon_mm_master_bfm/altera_avalon_mm_master_bfm.sv
vlog -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/altera_avalon_st_sink_bfm/altera_avalon_st_sink_bfm.sv
vlog -work work $env(QUARTUS_ROOTDIR)/../ip/altera/sopc_builder_ip/verification/altera_avalon_st_source_bfm/altera_avalon_st_source_bfm.sv

# device library files
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_primitives.v
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_lnsim.sv
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/twentynm_atoms.v
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/twentynm_atoms_ncrypt.v
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/twentynm_hssi_atoms_ncrypt.v
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/twentynm_hssi_atoms.v
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/twentynm_hip_atoms_ncrypt.v
vlog -work work $env(QUARTUS_ROOTDIR)/eda/sim_lib/twentynm_hip_atoms.v

# Compile DUT
vlog -work work ../../rtl/*.*v

# compile address decoder
vlog -work work ../../rtl/address_decoder/address_decode/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_avalon_packets_to_master_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_avalon_sc_fifo_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_avalon_st_bytes_to_packets_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_avalon_st_handshake_clock_crosser_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_avalon_st_packets_to_bytes_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_jtag_avalon_master_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_jtag_dc_streaming_100999897/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_burst_adapter_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_demultiplexer_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_master_agent_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_master_translator_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_multiplexer_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_router_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_slave_agent_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_slave_translator_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_merlin_traffic_limiter_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_mm_interconnect_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/altera_reset_controller_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/channel_adapter_*/sim/*.*v
vlog -work work ../../rtl/address_decoder/address_decode/timing_adapter_*/sim/*.*v

# compile atxpll
vlog -work work ../../rtl/pll_atxpll/altera_xcvr_atx_pll_ip/altera_xcvr_atx_pll_a10_*/sim/*.*v
vlog -work work ../../rtl/pll_atxpll/altera_xcvr_atx_pll_ip/altera_xcvr_atx_pll_a10_*/sim/mentor/*.*v
vlog -work work ../../rtl/pll_atxpll/altera_xcvr_atx_pll_ip/sim/*.*v

# reset controller

vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/altera_xcvr_functions.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/mentor/altera_xcvr_functions.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/alt_xcvr_resync.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/mentor/alt_xcvr_resync.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/altera_xcvr_reset_control.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/alt_xcvr_reset_counter.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/mentor/altera_xcvr_reset_control.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/altera_xcvr_reset_control_*/sim/mentor/alt_xcvr_reset_counter.sv
vlog -work reset_controller ../../rtl/xcvr_reset_controller/reset_control/sim/*.*v


# mac
vlog -work work ../../rtl/mac/low_latency_mac/sim/*.*v
vlog -work work ../../rtl/mac/low_latency_mac/alt_em10g32_*/sim/*.*v
vlog -work work ../../rtl/mac/low_latency_mac/alt_em10g32_*/sim/mentor/*.*v
vlog -work work ../../rtl/mac/low_latency_mac/alt_em10g32_*/sim/mentor/adapters/altera_eth_avalon_mm_adapter/*.*v
vlog -work work ../../rtl/mac/low_latency_mac/alt_em10g32_*/sim/mentor/adapters/altera_eth_avalon_st_adapter/*.*v
vlog -work work ../../rtl/mac/low_latency_mac/alt_em10g32_*/sim/mentor/adapters/altera_eth_xgmii_width_adaptor/*.*v
vlog -work work ../../rtl/mac/low_latency_mac/alt_em10g32_*/sim/mentor/adapters/altera_eth_xgmii_data_format_adapter/*.*v
vlog -work work ../../rtl/mac/low_latency_mac/alt_em10g32_*/sim/mentor/rtl/*.*v

# baser
vlog -work work ../../rtl/phy/low_latency_baser/sim/*.*v
vlog -work work ../../rtl/phy/low_latency_baser/altera_xcvr_native_a10_*/sim/*.*v
vlog -work work ../../rtl/phy/low_latency_baser/altera_xcvr_native_a10_*/sim/mentor/*.*v

# fifo
vlog -work work ../../rtl/fifo_scfifo/sc_fifo/sim/*.*v
vlog -work work ../../rtl/fifo_scfifo/sc_fifo/altera_avalon_sc_fifo_*/sim/*.*v

# generator and checker
vlog -work work ../../rtl/eth_traffic_controller/*.*v 
vlog -work work ../../rtl/eth_traffic_controller/crc32/*.*v 
vlog -work work ../../rtl/eth_traffic_controller/crc32/crc32_lib/*.*v 

# DC FIFO
vlog -work work ../../rtl/fifo_dcfifo/dc_fifo/altera_avalon_dc_fifo_*/sim/*.*v 
vlog -work work ../../rtl/fifo_dcfifo/dc_fifo/sim/*.*v 

# Compile Testbench
vlog -work work tb.sv

# Start simulation
vsim\
-novopt\
-t ps\
-L altera_mf_ver -L lpm_ver -L sgate_ver -L reset_controller\
work.tb

log -r /*

# Add waveform
do wave.do

# Run the simulation
run -all
