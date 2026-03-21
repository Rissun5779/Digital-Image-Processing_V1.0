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


# ----------------------------------------
# vcs - simulation script for alt_e40_avalon_kr4_tb

# ----------------------------------------
# copy RAM/ROM files to simulation directory
cp ../example/common/alt_e40_e_reco/alt_e40_e_reco/*.mif .
cp ../example/common/alt_e40_e_reco/alt_e40_e_reco/*.hex .
cp ../example/common/com_design_ex/*.mif .
cp ../example/common/com_design_ex/*.hex .

QSYS_SIMDIR="../../../ENET_ENTITY_QMEGA_06072013_sim"
QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR
USER_DEFINED_ELAB_OPTIONS="alt_e40_avalon_tb_packet_gen_sanity_check.v alt_e40_avalon_tb_packet_gen.v alt_e40_avalon_tb_sample_tx_rom.v alt_e40_avalon_kr4_tb.sv"
SKIP_SIM=1
TOP_LEVEL_NAME="alt_e40_avalon_kr4_tb -F ./kr4_example_files.txt"

sh $QSYS_SIMDIR/synopsys/vcs/vcs_setup.sh QSYS_SIMDIR=$QSYS_SIMDIR QUARTUS_INSTALL_DIR=$QUARTUS_INSTALL_DIR USER_DEFINED_ELAB_OPTIONS="\"$USER_DEFINED_ELAB_OPTIONS\"" SKIP_SIM=$SKIP_SIM TOP_LEVEL_NAME="\"$TOP_LEVEL_NAME\""

./simv
