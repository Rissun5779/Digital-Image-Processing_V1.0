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




package provide alt_xcvr::de_tcl::DE_TCL_CONSTANTS 18.1 

#package provide alt_xcvr::de_tcl::all_connections 1

#package require alt_xcvr::de_tcl::framework

namespace eval ::alt_xcvr::de_tcl::DE_TCL_CONSTANTS:: {

  variable QSYS_VERSION

  variable INDEX_OF_PROJ_SETTING_NAME
  variable INDEX_OF_PROJ_SETTING_VALUE  

  variable INDEX_OF_INSTANCE_NAME
  variable INDEX_OF_INSTANCE_TYPE
   
  variable INDEX_OF_PARAM_INSTANCE_NAME
  variable INDEX_OF_PARAM_PARAMETER_NAME
  variable INDEX_OF_PARAM_PARAMETER_VALUE
  
  variable INDEX_OF_CONNECTION_NAME
  variable INDEX_OF_CONNECTION_SPLIT
  variable INDEX_OF_CONNECTION_ADAPT
  variable INDEX_OF_CONNECTION_GROUP; # this is for multi-target group ID

  set QSYS_VERSION 18.1  

  set INDEX_OF_PROJ_SETTING_NAME  0
  set INDEX_OF_PROJ_SETTING_VALUE 1
  
  set INDEX_OF_INSTANCE_NAME 0
  set INDEX_OF_INSTANCE_TYPE 1
  
  set INDEX_OF_PARAM_INSTANCE_NAME   0
  set INDEX_OF_PARAM_PARAMETER_NAME  1
  set INDEX_OF_PARAM_PARAMETER_VALUE 2
  
  set INDEX_OF_CONNECTION_NAME  0
  set INDEX_OF_CONNECTION_SPLIT 1
  set INDEX_OF_CONNECTION_ADAPT 2
  set INDEX_OF_CONNECTION_GROUP 3

}