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


# Set hierarchy variables used in the Qsys-generated files
source ./vcsmx_setup.sh SKIP_ELAB=1 SKIP_SIM=1 

# Compile the additional test files
vlogan +v2k             ../../testbench/rx_freq_check.v
vlogan +v2k             ../../testbench/tx_freq_check.v
vlogan +v2k             ../../testbench/freq_check.v
vlogan +v2k             ../../testbench/vga_driver.v
vlogan +v2k             ../../testbench/clk_gen.v
vlogan +v2k             ../../dp_analog_mappings.v
vlogan +v2k -sverilog   ../../a10_reconfig_arbiter.sv
vlogan +v2k             ../../bitec_reconfig_alt_a10.v
vlogan +v2k             ../../rx_phy/rx_phy_top.v
vlogan +v2k             ../../tx_phy/tx_phy_top.v
vlogan +v2k             ../../a10_dp_demo.v
vlogan +v2k -sverilog   ../../testbench/a10_dp_harness.sv

# Runs com, elab, sim
# Added this elab option because of segmentation fault issue described in fb 321180 and 240959
source ./vcsmx_setup.sh \
   SKIP_FILE_COPY=1 \
   SKIP_DEV_COM=1 \
   SKIP_COM=1 \
   TOP_LEVEL_NAME="'-top a10_dp_harness'" \
   USER_DEFINED_ELAB_OPTIONS="-xlrm" \
   USER_DEFINED_SIM_OPTIONS=""
