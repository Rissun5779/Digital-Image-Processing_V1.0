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


cd ./../../ilk_50g/sim/synopsys/vcsmx/
sh vcsmx_setup.sh SKIP_ELAB=1 SKIP_SIM=1 | tee  compile_transcript
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/top_tb.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/one_shot.v
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/test_dut.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/example_design.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/ilk_top.v
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/ilk_pkt_checker.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/ilk_pkt_gen.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/test_agent.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/test_env.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/test_host.sv
vlogan +v2k -sverilog ../../../../example_design_a10/rtl/test_infra.sv
vcs -lca -debug_all -t ps top_tb -l transcript +vcs+vcdpluson+lic+wait
./simv | tee transcript
