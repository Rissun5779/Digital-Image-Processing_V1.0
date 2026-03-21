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
vlog -sv +incdir+../../src ../../demo/src/interlaken_native_wrapper_duplex.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src ../../demo/src/seriallite_iii_streaming.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/clock_gen.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_source_adaptation.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_source_adaptation_ecc.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_source_application.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_source_control.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_source_csr.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_source_mac.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_dp_sync.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/*.v +access +w +define+ALTERA +define+SIMULATION
#vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/clkctrl.v +access +w +define+ALTERA +define+SIMULATION
#vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/control_word_decoder.v +access +w +define+ALTERA +define+SIMULATION +define+DUPLEX_MODE

#// Sink Components
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_sink_mac.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_sink_csr.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_sink_application.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_sink_alignment.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_sink_adaptation.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_sink_dcfifo.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv $env(SIM_LOCATION)/seriallite_iii_a10_160/sim/mentor/altera_sl3_sink_dcfifo_fifo.v +access +w +define+ALTERA +define+SIMULATION

#// Demo Components 
vlog -sv +incdir+../../src+../ ../../demo/src/traffic_gen.sv +access +w +define+ALTERA +define+SIMULATION 
vlog -sv +incdir+../../src ../../demo/src/prbs_generator.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src ../../demo/src/prbs_poly.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src+../ ../../demo/src/traffic_check.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src ../../demo/src/source_reconfig.v +access +w +define+ALTERA +define+SIMULATION
vlog -sv +incdir+../../src ../../demo/src/sink_reconfig.v +access +w +define+ALTERA +define+SIMULATION

#// Testbench Components 
vlog -sv +incdir+../../src+../ ../skew_insertion.v +access +w +define+ALTERA +define+SIMULATION +define+DUPLEX_MODE
vlog -sv +incdir+../../src+../ ../testbench.sv +access +w +define+ALTERA +define+SIMULATION +define+DUPLEX_MODE
vlog -sv +incdir+../../src+../ ../test_env.v +access +w +define+ALTERA +define+SIMULATION +define+DUPLEX_MODE +define+$device_info
vlog -sv +incdir+../../src+../ ../top_cfg.v +access +w +define+ALTERA +define+SIMULATION  +define+$device_info
