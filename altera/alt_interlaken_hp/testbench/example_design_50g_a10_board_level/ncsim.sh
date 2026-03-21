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


cd ./../../ilk_50g/sim/cadence/
sh ./ncsim_setup.sh SKIP_ELAB=0 SKIP_SIM=0 

ncvlog -sv ../../../example_design_a10/rtl/top_tb.sv
ncvlog -sv ../../../example_design_a10/rtl/one_shot.v
ncvlog -sv ../../../example_design_a10/rtl/test_dut.sv
ncvlog -sv ../../../example_design_a10/rtl/example_design.sv
ncvlog -sv ../../../example_design_a10/rtl/ilk_top.v
ncvlog -sv ../../../example_design_a10/rtl/ilk_pkt_checker.sv
ncvlog -sv ../../../example_design_a10/rtl/ilk_pkt_gen.sv
ncvlog -sv ../../../example_design_a10/rtl/test_agent.sv
ncvlog -sv ../../../example_design_a10/rtl/test_env.sv
ncvlog -sv ../../../example_design_a10/rtl/test_host.sv
ncvlog -sv ../../../example_design_a10/rtl/test_infra.sv 
ncelab -TIMESCALE 1ps/1ps -access +w+r+c -namemap_mixgen  -append_log -log transcript top_tb 
ncsim -licqueue top_tb  | tee -a transcript 
