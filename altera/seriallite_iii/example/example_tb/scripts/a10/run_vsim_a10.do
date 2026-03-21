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
#vlib work
#vlib sink_nc_seriallite_iii
#vlib source_nc_seriallite_iii 

vlib          ./libraries/     
vlib          ./libraries/work/
vlib          ./libraries/sink_seriallite_iii_a10_150/     
vlib          ./libraries/source_seriallite_iii_a10_150/ 
 
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
vmap       sink_seriallite_iii     ./libraries/sink_seriallite_iii_a10_150/   
vmap       source_seriallite_iii   ./libraries/source_seriallite_iii_a10_150/ 

setenv SIM_NAME "modelsim"
# Map the Altera libraries
if { [file exists $env(QUARTUS_ROOTDIR)/eda/sim_lib] } {
  if [regexp {ModelSim ALTERA} [vsim -version]] {
     vmap twentynm            $env(MODELSIM_ALTERA_LIBS)/twentynm
     vmap twentynm_hssi        $env(MODELSIM_ALTERA_LIBS)/twentynm_hssi
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
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/twentynm_atoms.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/twentynm_atoms_ncrypt.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/twentynm_hssi_atoms_ncrypt.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/twentynm_hssi_atoms.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/mentor/twentynm_hip_atoms_ncrypt.v
     vlog $env(QUARTUS_ROOTDIR)/eda/sim_lib/twentynm_hip_atoms.v
   }    
}

# Compile A10 components
do interlaken_a10_native.do

# Compile the generic design files
set device_info SERIALLITE_III_FOR_A10
do seriallite_src_lst_vsim.do

# Run the simulation
if [regexp {ModelSim ALTERA} [vsim -version]] {
   vsim -c +test_name=data_forwarding +random_seed=3080670388 +define+ALTERA \
     -L twentynm \
     -L twentynm_hssi \
     -L 220model \
     -L altera \
     -L altera_mf \
     -L sgate \
     -L altera_lnsim \
     -L sink_seriallite_iii \
     -L source_seriallite_iii \
     -L work \
     -L work_lib \
     +access +w +define+SIMULATION \
	 test_env
    

} else {
  vsim -c -novopt -L work -L work_lib -L sink_seriallite_iii -L source_seriallite_iii +test_name=data_forwarding +define+ALTERA +access +w +define+SIMULATION test_env
}
# Uncomment the following for waveformms
#add wave *
run -all
quit
