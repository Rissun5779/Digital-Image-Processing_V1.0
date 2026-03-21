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


#! /bin/sh

#
# the line below turns the C header file with base addresses
# into a a set of tcl procs of the same name to get the base addresses.
#
#perl -ne 'split ; print "proc $_[1] {} { return $_[2] }\n";'< altera_hps_arria_10_base_addrs.h >arria10_hps_base_addrs.tcl

#
# run the perl script through the C preprocessor, strip out ^# added by C preprocess,
# finally send the output to the perl interreter.
#
gcc -x c -include/data/triffel/p4root/depot/soc/baum_sw/baremetal_fw/drivers/interrupt_headers/irq_ids.h -E ${ACDS_SRC_ROOT}/ip/altera_hps/utility_scripts/baum_ipxact_parser/gen_baum_base_addr_xml.pl | grep -v '^#' | perl
