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


# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# (C) 2001-2016 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


#       printf DO "-v $ENV{\"QUARTUS_ROOTDIR\"}/eda/sim_lib/synopsys/twentynm_pcie_hip_atoms_ncrypt.v\n";
#       printf DO "-v $ENV{\"QUARTUS_ROOTDIR\"}/eda/sim_lib/twentynm_pcie_hip_atoms.v\n";
# sh ../ilk_100g/sim/synopsys/vcsmx/vcsmx_setup.sh SKIP_ELAB=1 SKIP_SIM=1 QSYS_SIMDIR=./ >> compile_transcript
cd ../ilk_uflex/sim/synopsys/vcsmx/
# sh vcsmx_setup.sh SKIP_ELAB=1 SKIP_SIM=1 >> compile_transcript
sh vcsmx_setup.sh SKIP_ELAB=1 SKIP_SIM=1 | tee  compile_transcript
# sh ../ilk_100g/sim/synopsys/vcs/vcs_setup.sh SKIP_ELAB=1 SKIP_SIM=1 >> compile_transcript
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_oob_flow_rx.v
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_oob_flow_rx_dcfifo.v
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_oob_flow_tx.v
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_reset_delay.v
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_status_sync.v
vlogan +v2k -sverilog ../../../../example_design_s10/top_tb.sv
vlogan +v2k -sverilog ../../../../example_design_s10/one_shot.v
vlogan +v2k -sverilog ../../../../example_design_s10/test_dut.sv
vlogan +v2k -sverilog ../../../../example_design_s10/example_design.sv
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_top.v
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_pkt_checker.sv
vlogan +v2k -sverilog ../../../../example_design_s10/ilk_pkt_gen.sv
vlogan +v2k -sverilog ../../../../example_design_s10/test_agent.sv
vlogan +v2k -sverilog ../../../../example_design_s10/test_env.sv
vlogan +v2k -sverilog ../../../../example_design_s10/test_host.sv
vlogan +v2k -sverilog ../../../../example_design_s10/test_infra.sv
# vcs -lca -t ps top_tb -l transcript
vcs -lca -debug_all -t ps top_tb -l transcript +vcs+vcdpluson+lic+wait
# ./simv >> transcript
./simv | tee transcript
