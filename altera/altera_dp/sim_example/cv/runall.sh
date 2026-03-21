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


# Regenerate the IP simulation models
qmegawiz -silent cv_xcvr_reconfig.v
qmegawiz -silent cv_dp.v
qmegawiz -silent cv_native_phy_tx.v
qmegawiz -silent cv_native_phy_rx.v

# Merge the msim_setup.tcl files
ip-make-simscript --spd=./cv_xcvr_reconfig.spd --spd=./cv_dp.spd --spd=./cv_native_phy_tx.spd --spd=./cv_native_phy_rx.spd 

# Call ModelSim to compile the design and run the simulation
vsim -c -do msim_dp.tcl
