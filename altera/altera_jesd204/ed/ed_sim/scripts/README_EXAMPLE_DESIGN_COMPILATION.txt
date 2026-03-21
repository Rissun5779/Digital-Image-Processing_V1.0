Altera JESD204B Example Design Compilation Notes 
===========================================
This note has the following contents :  
- Compilation guideline
- Directory Structure for Jesd204 example design



1. Compilation Guideline
==========================================================

-------------------------------------
Part I : Generate compilation filesets
--------------------------------------
To run the Tcl script using the Quartus Prime sofware, follow these steps:

Note: If you use the Quartus Prime Tcl console to generate the gen_quartus_synth.tcl script, close all Quartus Prime project before you start generating.

1. Launch the Quartus Prime software.

2. On the View menu, click Utility Windows and select Tcl Console.

3. In the Tcl Console, type cd <example_design_directory>/ed_synth to go to the specified directory.

4. Type source gen_quartus_synth.tcl to generate JESD204B design example for compilation.

To run the Tcl script using the command line, follow these steps:

1. Obtain the Quartus Prime software resource.

2. Type cd <example_design_directory>/ed_synth to go to the specified directory.

3. Type quartus_sh -t gen_quartus_synth.tcl to generate JESD204B design example for compilation.



To compile your design using the Quartus Prime software , follow these steps:

1. Launch the Quartus Prime software.

2. On the File menu, click Open Project > Select <example_design_directory>/ed_synth/example_design/.

3. Select jesd204b_ed.qpf.

4. On the Processing menu, click Start Compilation.

At the end of the compilation, the Quartus Prime software provides a pass/fail indication.


2. Directory Structure for Jesd204 Example Design
=================================================
--<example_design_directory_name>
         |  
         |--ed_synth
           |--example_design
               |--README_EXAMPLE_DESIGN_COMPILATION.txt
               |--gen_quartus_synth.tcl   (Script to generate synthesis files) 
                 |--altera_jesd204
                 |--altera_reset_controller
                 |--control_unit
                 |--core_pll_module
                 |--core_pll_reconfig_module
                 |--pattern
                 |--spi
                 |--transport_layer
                 |--xcvr_atx_pll_module   (only available in example design targeted on Arria 10 FPGA device)
                 |--XCVR_reconfig_module  (only available in example design targeted on V series FPGA device)
                 |--xcvr_reset_control_module
                 |--altera_jesd204.csv
		 |--create_project.tcl
                 |--ed.sdc
                 |--jesd204_ed.qpf
                 |--jesd204_ed.qsf
                 |--jesd204_ed.qws
                 |--jesd204_ed.sv