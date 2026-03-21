Altera JESD204B Example Design  Notes 
===========================================
This note has the following contents :  
- Simulation guideline
- Directory Structure for Jesd204 example design testbench



1. Simulation Guideline
==========================================================

-------------------------------------
Part I : Generate simulation filesets
--------------------------------------
Jesd204 example design testbench is targeted to supports for both Verilog and VHDL simulation model. Please read the instructions below 
to generate Verilog/VHDL simulation model.

--VERILOG--

To generate the Verilog simulation model, run "quartus_sh -t gen_ed_sim_verilog.tcl"
at Linux command prompt.

The generated jesd204b Verilog simulation model files can be found in the subdirectory "./testbench/altera_jesd204_sim".
Meanwhile, the transceiver reset control Verilog simulation model files are available in "./testbench/xcvr_reset_control_sim".
The core pll reconfig simulation model will be inside "./testbench/core_pll_reconfig".
The XCVR reconfig simulation model is located inside "./testbench/XCVR_reconfig_sim".


--VHDL--

To generate the VHDL simulation model, run "quartus_sh -t gen_ed_sim_vhdl.tcl"
at Linux command prompt.

The generated jesd204b VHDL simulation model files can be found in the subdirectory "./testbench/altera_jesd204_sim".
Meanwhile, the transceiver reset control VHDL simulation model files are available in "./testbench/xcvr_reset_control_sim"
The core pll reconfig simulation model will be inside "./testbench/core_pll_reconfig".
The XCVR reconfig simulation model is located inside "./testbench/XCVR_reconfig_sim".

------------------------------------------
Part II : Run Example Design Testbench
-----------------------------------------
Follow the instructions below to run customer testbench for both Verilog and Vhdl simulation model through different simulators

--Modelsim--
To simulate the testbench using Modelsim AE/SE:

1) Move into the directory ./testbench/mentor 
2) Start Modelsim and run the "run_tb_top.tcl" script: in Modelsim, enter "do run_tb_top.tcl".

Alternative way :Type vsim -do run_tb_top.tcl at Linux command prompt.

--VCS--
To simulate the testbench using VCS:

1) Move into the directory ./testbench/synopsys/vcs 
2) Start Vcs and run "sh run_tb_top.sh".
3) To view the waveforms, run "dve -vpd wave.vpd"

--VCSMX--
To simulate the testbench using VCSMX:

1) Move into the directory ./testbench/synopsys/vcsmx 
2) Start Vcsmx and run "sh run_tb_top.sh".
3) To view the waveforms, run "dve -vpd wave.vpd"


--Aldec--
To simulate the testbench using Aldec:

1) Move into the directory ./testbench/aldec 
2) Start riviera and run the "run_tb_top.tcl" script: in Riviera, enter "do run_tb_top.tcl".

Alternative way: Since riviera license is limited , we need to acquire the resource and license by typing this command at Linux command prompt  $arc shell --wait-for-resources riviera riviera-lic. After getting the resource and license , type vsim -do run_tb_top.tcl at the command prompt.

--Cadence--
To simulate the testbench using NCSIM:

1) Move into the directory ./testbench/cadence 
2) In command prompt, enter "sh run_tb_top.sh".
3) In order to debug through waveform if the simulation is failed , please continue by typing "ncsim -GUI tb_top " . This will bring up the GUI of ncsim . The "simvision" is waveform viewer. At design browser ,choose the signal that want to monitor by right click on the signal and "set to target -> waveform window " . At the console of simvision , type run . Finish running , then we will obtain the waveform .

Note: Since ncsim license is limited , we need to acquire the resource and license by typing this command at Linux command prompt  $arc shell --wait-for-resource ncsim ncsim-lic/idts-restricted. After getting the resource and license , type " ncsim -GUI tb_top "at the command prompt.

2. Directory Structure for Jesd204 Example Design testbench
===================================================== 
--<example_design_directory_name>
         |  
         |--ed_sim
           |--testbench
               |--README.txt
               |--gen_ed_sim_verilog.tcl   (Script to generate Verilog simulation model)
               |--gen_ed_sim_vhld.tcl      (Script to generate VHDL simulation model) 
               |--testbench
                 |--aldec    
                 |--altera_jesd204_sim
                 |--cadence     
                 |--control_unit
                 |--core_pll_reconfig
                 |--mentor
                 |--models
                 |--mentor
                 |--pattern
                 |--pll
                 |--setup_scripts
                 |--spi
                 |--synopsys
                 |--transport_layer
                 |--XCVR_reconfig_sim
                 |--xcvr_reset_control_sim