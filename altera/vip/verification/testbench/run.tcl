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


# (C) 2001-2016 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


set QSYS_SIMDIR ../testbench/testbench/simulation
set TOP_LEVEL_NAME "testbench_stimulus"

source $QSYS_SIMDIR/mentor/msim_setup.tcl

# Compile all the project files :
com

# compile tech specific libraries:
dev_com

set VSIM_VER [eval "pwd"]
if {[string first "example_constrained_random" $VSIM_VER ] != -1 } {
	set TEST_TYPE "CONSTRAINED_RANDOM_TEST"
} else {
	set TEST_TYPE "VIDEO_FILE_EXAMPLE_TEST"
}

# Compile class libraries and top level :
set VSIM_VER [eval "which vsim"]
if {[string first "modelsim_ae" $VSIM_VER ] != -1 } {
    vlog -L altera_common_sv_packages +define+$DEFINES +incdir+../class_library_ae/ -novopt -sv ../testbench/testbench_stimulus.sv
} else {
    vlog -L altera_common_sv_packages +define+$DEFINES +incdir+../class_library/ -novopt -sv ../testbench/testbench_stimulus.sv
}

# Elaborate the top level :
elab_debug

# Simulate :
run -all
