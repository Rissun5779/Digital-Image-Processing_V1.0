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


# generate_rtl.pl
#
# Generates a component RTL with given configuration file.

use Getopt::Long;
use europa_all;
#NOTE: use the em_dma_qsys component package
use em_dma_qsys;
#NOTE: use the embedded_ip_generate_common package
use embedded_ip_generate_common;
use strict;

$| = 1;     # Always flush stderr

#-------------------------------------------------------------------------------
# main code
#-------------------------------------------------------------------------------

#main()
{
    # process command-line arguements
    # NOTE: read the configuration file and command arguement and prepare the infos hash
    my $infos = process_args();
    #NOTE: 
    my $project = prepare_project($infos);
    
    # prepare generation options
    my $Options = &copy_of_hash($infos);    

    #NOTE: call the component generation entry (refer to em_dma_qsys.pm)
    my $module = $project->top(); 
    
    &make_dma($project, $Options, $module);
     
    $project->output();
    exit(0);
}

