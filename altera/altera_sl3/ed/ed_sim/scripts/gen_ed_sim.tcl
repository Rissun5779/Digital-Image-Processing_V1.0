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



puts "Generating altera_sl3 simulation model"

set qdir $::env(QUARTUS_ROOTDIR)
set qsys_exec [file join $qdir sopc_builder bin]
set qsys_script [file join $qsys_exec qsys-script]
set qsys_generate [file join $qsys_exec qsys-generate]
set ip_make_simscript [file join $qsys_exec ip-make-simscript]
set tb_spd [file join tb_components tb.spd]

# Generate IP QSYS file (qsys-script)
# gen_IP_QSYS

# Generate ATX PLL QSYS file (qsys-script)
# gen_ATX_PLL_QSYS

# Generate IP Core from QSYS file (qsys-generate)
# gen_IP

# Generate ATX PLL from QSYS file (qsys-generate)
# gen_ATX_PLL

# Declare directory for setup scripts
set setup_scripts_dir [file join testbench setup_scripts]

# Create setup scripts with generated spd files
# gen_simscript

