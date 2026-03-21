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
# QUARTUS_ROOTDIR based on Quartus install location 
# SNK_SIM_LOCATION to where generated simulation files for Sink Interface are located
# SRC_SIM_LOCATION to where generated simulation files for Source Interface are located
###########################################################################################################
mkdir -p ./libraries/worklib/
mkdir -p ./libraries/sink_seriallite_iii/
mkdir -p ./libraries/source_seriallite_iii/
mkdir -p ./cds_libs/

ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/altera_primitives.v"         
ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/220model.v"                       
ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/sgate.v"                      
ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/altera_mf.v"                      
ncvlog -sv "$QUARTUS_ROOTDIR/eda/sim_lib/altera_lnsim.sv"                  
ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/cadence/twentynm_atoms_ncrypt.v"          
ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/twentynm_atoms.v"                        
ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/cadence/twentynm_hssi_atoms_ncrypt.v"  
ncvlog     "$QUARTUS_ROOTDIR/eda/sim_lib/twentynm_hssi_atoms.v"                   


# Compile the Interlaken IP

irun -compile -F interlaken_a10_native.txt

ncvlog      -incdir "$SRC_SIM_LOCATION/altera_iopll_160/sim/" $SRC_SIM_LOCATION/altera_iopll_160/sim/*altera_iopll_160*.vo
ncvlog      -incdir "$SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/" "$SNK_SIM_LOCATION/seriallite_iii_a10_160/sim/seriallite_iii_streaming_sink.v"
ncvlog      -incdir "$SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/"  "$SRC_SIM_LOCATION/seriallite_iii_a10_160/sim/seriallite_iii_streaming_source.v" 

# Compile the generic design files
irun -compile -sv +define+SIMULATION +define+SERIALLITE_III_FOR_A10  +incdir+../../src+../ -F seriallite_src_lst_ncsim.txt

# Run the simulation

ncelab -access +w+r+c +define+SERIALLITE_III_FOR_A10 test_env
ncsim -run +random_seed=123456 +define+SIMULATION +define+SERIALLITE_III_FOR_A10  +test_name=data_forwarding test_env