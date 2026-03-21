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



###########################################################################################################
# Notes: Update path variables 
# For ModelSim-Altera Edition: MODELSIM_ALTERA_LIBS based on Quartus install location
# For ModelSim Non-Altera Editions: QUARTUS_ROOTDIR based on Quartus install location
# SNK_SIM_LOCATION to where generated simulation files for Sink Interface are located
# SRC_SIM_LOCATION to where generated simulation files for Source Interface are located
###########################################################################################################

if {[file exists work]} {
  vdel -lib work -all
}
vlib work

setenv SIM_NAME "modelsim"
# Map the Altera libraries
if { [file exists $env(QUARTUS_ROOTDIR)/eda/sim_lib] } {
  if [regexp {ModelSim ALTERA} [vsim -version]] {
     vmap stratixv            $env(MODELSIM_ALTERA_LIBS)/stratixv
     vmap stratixv_hssi        $env(MODELSIM_ALTERA_LIBS)/stratixv_hssi
     vmap stratixv_pcie_hip    $env(MODELSIM_ALTERA_LIBS)/stratixv_pcie_hip
     vmap arriavgz            $env(MODELSIM_ALTERA_LIBS)/arriavgz
     vmap arriavgz_hssi       $env(MODELSIM_ALTERA_LIBS)/arriavgz_hssi
     vmap arriavgz_pcie_hip    $env(MODELSIM_ALTERA_LIBS)/arriavgz_pcie_hip   
     vmap 220model             $env(MODELSIM_ALTERA_LIBS)/220model
     vmap altera               $env(MODELSIM_ALTERA_LIBS)/altera
     vmap altera_mf            $env(MODELSIM_ALTERA_LIBS)/altera_mf
     vmap altera_lnsim         $env(MODELSIM_ALTERA_LIBS)/altera_lnsim
     vmap sgate                $env(MODELSIM_ALTERA_LIBS)/sgate
  } else {
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_primitives.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/220model.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_mf.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/sgate.v
     vlog -sv $env(QUARTUS_ROOTDIR)/eda/sim_lib/altera_lnsim.sv
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/stratixv_hssi_atoms_ncrypt.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/stratixv_hssi_atoms.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/stratixv_atoms.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/stratixv_atoms_ncrypt.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/arriavgz_hssi_atoms_ncrypt.v 
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/arriavgz_hssi_atoms.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/arriavgz_atoms.v 
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/arriavgz_atoms_ncrypt.v 
   }    
}

# Compile the Interlaken and transceiver reconfig IP

do interlaken_phy_ip_lib.do
do reconfig_ctrlr_lib.do

# Compile the generic design files
do seriallite_src_lst_vsim.do

# Run the simulation
if [regexp {ModelSim ALTERA} [vsim -version]] {
   vsim -c +test_name=data_forwarding +random_seed=3080670388 +define+ALTERA \
     -L stratixv \
     -L stratixv_hssi \
     -L stratixv_pcie_hip \
     -L arriavgz\
     -L arriavgz_hssi \
     -L arriavgz_pcie_hip \
     -L 220model \
     -L altera \
     -L altera_mf \
     -L sgate \
     -L altera_lnsim \
     +access +w \
     test_env     
} else {
  vsim -c -novopt +test_name=data_forwarding +define+ALTERA +access +w +define+SIMULATION  test_env
}
# Uncomment the following for waveformms
#add wave *
run -all
quit
