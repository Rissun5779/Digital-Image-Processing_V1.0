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


# CFG files have to be compiled before rcfg_sdi_cdr.sv file
# Creating a modified version of the setup.sh without CFG files in the file list
# and compile the CFG files from filelist.f instead
sed '/altera_xcvr_native_a10_reconfig_parameters_CFG/d' vcs_setup.sh > vcs_setup_mod.sh

source ./vcs_setup_mod.sh \
TOP_LEVEL_NAME=tb_top \
USER_DEFINED_ELAB_OPTIONS="\"+define+USE_ICD_CDR_MODEL+SDI_SIM +incdir+../../testbench/tb_control/ -f filelist.f \"" \
USER_DEFINED_SIM_OPTIONS=""
