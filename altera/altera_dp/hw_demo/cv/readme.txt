=======================================================================================================
Altera DisplayPort Readme File
=======================================================================================================

Design example description:

// DisplayPort Receiver + DisplayPort Transmitter. 
// The DisplayPort received image clock is recovered and output
// from the DisplayPort Transmitter. 
// Support for HBR (RX and TX) and all resolutions up to 1920 x 1200 (154 MHz)

=======================================================================================================

The Altera DisplayPort design example allows you to compile the DisplayPort IP Core with the 
Quartus Prime software to evaluate its performance and resource utilization.

Setting up and running the DisplayPort design example involves the following steps:

1. Copy the example folder to your working folder.
2. Generate the project and IP synthesis files and compile.
3. View Results.

COPY THE EXAMPLE FOLDER TO YOUR WORKING FOLDER
-----------------------------------------------------------------------------------------------------

In this step, you copy the *complete* design example folder to your project folder. Copy the
folder using the command:

cp -r <example directory> <working directory>

e.g.

cp -r c:\<quartus installed directory>\ip\altera\altera_dp\hw_demo\cv c:\work\cv


GENERATE THE PROJECT AND IP SYNTHESIS FILES AND COMPILE
-----------------------------------------------------------------------------------------------------

In this step you use a Tcl script to generate the project and IP synthesis files and compile them. 

1. Open a Nios II Command Shell
2. Navigate to your new copy of the example folder, e.g.

cd c:\work\cv

3. Type the command:

source runall.tcl

This script executes the following commands:

* Generate the synthesis files for the DisplayPort and transceiver reconfiguration IP cores

* Generate a new project and add assignments

* Compile the design in the Quartus software

VIEW RESULTS
-----------------------------------------------------------------------------------------------------

You can view the results by downloading the .sof file to the CVGT dev kit.

1. In your NIOS II Command Shell, type the command:

nios2-configure-sof cv_dp_demo.sof

2. You should be able to view the output in your monitor now.
=======================================================================================================
