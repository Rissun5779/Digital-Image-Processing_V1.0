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


set QSYS_SIMDIR "../ilk_uflex/sim"
set TOP_LEVEL_NAME "top_tb"
do ../ilk_uflex/sim/mentor/msim_setup.tcl
dev_com
com
vlog -timescale "1 ps / 1 ps" +acc one_shot.v
vlog -timescale "1 ps / 1 ps" +acc ilk_oob_flow_rx.v
vlog -timescale "1 ps / 1 ps" +acc ilk_oob_flow_rx_dcfifo.v
vlog -timescale "1 ps / 1 ps" +acc ilk_oob_flow_tx.v
vlog -timescale "1 ps / 1 ps" +acc ilk_reset_delay.v
vlog -timescale "1 ps / 1 ps" +acc ilk_status_sync.v
vlog -timescale "1 ps / 1 ps" +acc test_dut.sv
vlog -timescale "1 ps / 1 ps" +acc example_design.sv
vlog -timescale "1 ps / 1 ps" +acc ilk_top.v
vlog -timescale "1 ps / 1 ps" +acc ilk_pkt_checker.sv
vlog -timescale "1 ps / 1 ps" +acc ilk_pkt_gen.sv
vlog -timescale "1 ps / 1 ps" +acc test_agent.sv
vlog -timescale "1 ps / 1 ps" +acc test_env.sv
vlog -timescale "1 ps / 1 ps" +acc test_host.sv
vlog -timescale "1 ps / 1 ps" +acc test_infra.sv
vlog -timescale "1 ps / 1 ps" +acc top_tb.sv -L altera_xcvr_reset_control_160
elab
run -all
