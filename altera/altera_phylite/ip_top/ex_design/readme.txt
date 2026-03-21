###############################################################################
What is this?
###############################################################################

This is the readme.txt file for the example design file set of the Altera
PHYLite IP. The files in this directory allow you to do
the following:

1) Create a Quartus Prime project that instantiates the PHYLite interface 
   specified in the MegaWizard.
      
2) Create simulation projects for various supported simulators. The
   simulation projects instantiate an external memory interface (same
   configuration as what you specified in the MegaWizard),
   an example controller, and a basic example memory model. Once
   the projects are generated, you can run simulation and use the
   results as a way to understand the behavior of the IP. This flow 
   only supports functional simulation. Timing simulation is not supported, 
   and you must use static timing analysis provided by the TimeQuest 
   software to verify timing closure.

Notes:
   When using dynamic reconfig with the avalon controller, an example design is 
   provided in a standalone QSYS file (phylite_debug_kit.qsys).
   This can be modified and used in the user's design for dynamic reconfig
   using avalon controller. We only support the synthesis example for this
   configuration. No simulation files will be generated for it.
   In the synthesis example design, there is an example of how to
   connect PHYLite to the NIOS-II.
   The files phylite_niosii_bridge.v and phylite_niosii_hw.tcl
   define a custom component to help connect PHYLite to the NIOS-II in QSYS.
   Make sure both files are added to the project directory if you 
   wish to modify either the synthesis or simulation QSYS systems.
   This component is not needed if the use will control the avalon controller
   from core RTL

###############################################################################
Generating a Quartus Prime Example Design
###############################################################################
   
To generate a Quartus Prime example design, run:
   quartus_sh -t make_qii_design.tcl 
   
To specify an exact device to use, run:   
   quartus_sh -t make_qii_design.tcl [device_name]
   
The generated example design is stored under the "qii" sub-directory. To
re-generate the design, simply delete the "qii" sub-directory, and re-run
the commands above.
   
###############################################################################   
Generating a Simulation Example Design
###############################################################################   
  
To generate simulation example designs for a Verilog or a mixed-language
simulator, run:

   quartus_sh -t make_sim_design.tcl VERILOG
   
To generate simulation example designs for a VHDL-only simulator, run:

   quartus_sh -t make_sim_design.tcl VHDL
   
The generated example designs for various simulators are stored under the "sim"
sub-directory. For example, to run simulation using Synopsys' VCS, run:

   cd sim/synopsys/vcs
   ./vcs_setup.sh
   
