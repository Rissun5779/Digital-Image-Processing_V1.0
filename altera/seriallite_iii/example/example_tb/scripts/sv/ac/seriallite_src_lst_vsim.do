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



if  {[info exists device_info]} { 
 } else {
  set device_info SERIALLITE_III_FOR_SV
 }

vlog -sv +incdir+../../src+../ ../def_a10.v  
#// Infrastructure components 
vlog -sv ../../demo/src/dp_sync.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv ../../demo/src/dp_hs_req.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv ../../demo/src/dp_hs_resp.v +access +w +define+ALTERA +define+SIMULATION

#// Source Components 
vlog -sv +incdir+$env(SRC_SIM_LOCATION)/seriallite_iii_sv/ $env(SRC_SIM_LOCATION)/seriallite_iii_sv/seriallite_iii_streaming_source.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/interlaken_phy_ip_tx.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_source_adaptation.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_source_adaptation_ecc.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_source_application.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_source_control.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_source_csr.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_source_mac.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_dp_sync.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/*.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING 
#vlog -sv $env(SRC_SIM_LOCATION)/seriallite_iii_sv/control_word_decoder.v +access +w +define+ALTERA +define+SIMULATION

#// Sink Components
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/core_reset_logic.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+$env(SNK_SIM_LOCATION)/seriallite_iii_sv/ $env(SNK_SIM_LOCATION)/seriallite_iii_sv/seriallite_iii_streaming_sink.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/interlaken_phy_ip_rx.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING 
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_sink_mac.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_sink_csr.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_sink_application.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_sink_alignment.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_sink_adaptation.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_sink_dcfifo.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv $env(SNK_SIM_LOCATION)/seriallite_iii_sv/mentor/altera_sl3_sink_dcfifo_fifo.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING

#// Demo Components 
vlog -sv +incdir+../../src+../ ../../demo/src/traffic_gen.sv +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src ../../demo/src/prbs_generator.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src ../../demo/src/prbs_poly.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ ../../demo/src/traffic_check.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src ../../demo/src/source_reconfig.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src ../../demo/src/sink_reconfig.v +access +w +define+ALTERA +define+SIMULATION

#// Testbench Components 
vlog -sv ../skew_insertion.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ ../testbench.sv +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING
vlog -sv +incdir+../../src+../ ../test_env.v +access +w +define+ALTERA +define+SIMULATION +define+ADVANCED_CLOCKING +define+$device_info
