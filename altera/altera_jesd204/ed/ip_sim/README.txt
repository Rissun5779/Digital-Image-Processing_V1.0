Altera JESD204B Customer Testbench Notes 
===========================================
This note has the following contents :  
- Quick Summary for JESD204B Customer Testbench
- Simulation Guideline
- Directory Structure for JESD204B Customer Testbench

1. Quick Summary for JESD204B Customer Testbench
==========================================================
This JESD204B Customer Testbench is designed to demonstrate a normal link-up sequence for JESD204B core with supported configurations.    

Test items :
 - DATA_CHECK         : Compared the samples sent to JESD204B TX with received by JESD204 RX
                        for each lane.
 - RX_INTERRUPT_CHECK : Check whether the JESD204B RX interrupt's signal is flagged. 
 - TX_INTTERUPT_CHECK : Check whether the JESD204B TX interrupt's signal is flagged.
            
Preset configurations for testbench : 
 - Datapath        : Simplex 
 - Wrapper         : base_phy 
 - Link clock      : data_rate/40
 - AVS clock       : 100MHz

Supported simulator : 
 - ModelSim AE/SE, VCS, VCSMX, Cadence and Aldec. 

Supported language  : 
 - Verilog and VHDL


2. Simulation Guideline
==========================================================

-------------------------------------
Part I : Generate Simulation Filesets
--------------------------------------
JESD204B customer testbench is targeted to supports for both Verilog and VHDL simulation model. Please read the instructions below 
to generate Verilog/VHDL simulation model.

--VERILOG--

To generate the Verilog simulation model, run "quartus_sh -t gen_sim_verilog.tcl"
at Linux command prompt.

The generated JESD204B Verilog simulation model files can be found in the subdirectory "./testbench/altera_jesd204_sim".

--VHDL--

To generate the VHDL simulation model, run "quartus_sh -t gen_sim_vhdl.tcl"
at Linux command prompt.

The generated JESD204B VHDL simulation model files can be found in the subdirectory "./testbench/altera_jesd204_sim".

---------------------------------
Part II : Run Customer Testbench
---------------------------------
Follow the instructions below to run customer testbench for both Verilog and VHDL simulation model through different simulators

NOTE: VCS simulator does not support VHDL. 

--Aldec--
To simulate the testbench using Aldec:

1) Change directory to ./testbench/aldec 
2) Start Riviera and run the "run_altera_jesd204_tb.tcl" script: in Riviera, enter "do run_altera_jesd204_tb.tcl".

--Cadence--
To simulate the testbench using Cadence:

1) Change directory to ./testbench/cadence 
2) Start NCSIM and run "sh run_altera_jesd204_tb.sh".

--ModelSim--
To simulate the testbench using ModelSim AE/SE: 

1) Change directory to ./testbench/mentor 
2) Start ModelSim and run the "run_altera_jesd204_tb.tcl" script: in ModelSim, enter "do run_altera_jesd204_tb.tcl".

--VCSMX--
To simulate the testbench using VCSMX:

1) Change directory to ./testbench/synopsys/vcsmx 
2) Start VCSMX and run "sh run_altera_jesd204_tb.sh".
3) To view the waveforms, run "dve -vpd wave.vpd"

--VCS--
To simulate the testbench using VCS:

1) Change directory to ./testbench/synopsys/vcs 
2) Start VCS and run "sh run_altera_jesd204_tb.sh".
3) To view the waveforms, run "dve -vpd wave.vpd"



3. Directory Structure for JESD204B Customer Testbench
======================================================
----<example_design_directory_name>
           |
           |--ip_sim
               |
               |--README.txt
               |--gen_sim_verilog.tcl   (Script to generate Verilog simulation model)
               |--gen_sim_vhld.tcl      (Script to generate VHDL simulation model) 
               |--testbench
                     |
                     |--altera_jesd204_tx**                        (JESD204B TX IP core simulation model)
                     |
                     |--altera_jesd204_rx**                        (JESD204B RX IP core simulation model)
                     |
                     |--setup_scripts**                            (Simulator setup scripts)
                     |     |
                     |     |--aldec
                     |     |    |
                     |     |    |--rivierapro_setup.tcl            (Simulation setup script for Aldec simulator)
                     |     |    
                     |     |--cadence
                     |     |    |
                     |     |    |--ncsim_setup.tcl                 (Simulation setup script for Cadence simulator)
                     |     |    
                     |     |--mentor (AE & SE)
                     |     |    |
                     |     |    |--msim_setup.tcl                  (Simulation setup script for ModelSim AE/SE simulator)
                     |     |    
                     |     |--synopsys
                     |         |
                     |         |--vcsmx
                     |         |    |
                     |         |    |--vcsmx_setup.sh              (Simulation setup script for VCSMX simulator)
                     |         |  
                     |         |--vcs
                     |              |
                     |              |--vcs_setup.sh                (Simulation setup script for VCS simulator)
                     |
                     |--models
                     |     |
                     |     |--tb_jesd204.sv                        (Top level of JESD204B customer testbench)
                     |     |--tb_jesd204.spd**                     (spd file)
                     |
                     |--aldec
                     |     |
                     |     |--run_altera_jesd204_tb.tcl            (Script to run JESD204B customer testbench through Aldec simulator)
                     |     |--altera_jesd204_wave.do               (do file to display signals after simulation)
                     |
                     |--cadence
                     |     |
                     |     |--run_altera_jesd204_tb.sh             (Script to run JESD204B customer testbench through Cadence simulator)
                     |     |--altera_jesd204_wave.tcl              (do file to display signals after simulation)
                     |
                     |--mentor (AE & SE)
                     |     |
                     |     |--run_altera_jesd204_tb.tcl            (Script to run JESD204B customer testbench through ModelSim AE/SE simulator)
                     |     |--altera_jesd204_wave.do               (do file to display signals after simulation )         
                     |                     
                     |--synopsys
                           |
                           |--vcsmx
                           |     |
                           |     |--run_altera_jesd204_tb.sh       (Script to run JESD204B customer testbench through VCSMX simulator)
                           |     |--altera_jesd204_wave.do         (do file to display signals after simulation )         
                           |
                           |--vcs
                                 |
                                 |--run_altera_jesd204_tb.sh       (Script to run JESD204B customer testbench through VCS simulator)
                                 |--altera_jesd204_wave.do         (do file to display signals after simulation ) 


NOTE : All the folder/files marked with (**) are generated through gen_sim_verilog.tcl or gen_sim_vhdl.tcl.    
