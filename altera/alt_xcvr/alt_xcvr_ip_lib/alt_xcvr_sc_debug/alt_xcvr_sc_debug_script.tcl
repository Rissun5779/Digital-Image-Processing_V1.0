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


#######################################################
# File: atso_sc_api_script.tcl
# User: nmelosh
# date: 6/25/14
# Description:
#
# Default System Console script for reading/writing from the system console debug block
# This script contains the memory map for sys_console_debug.sv, and any changes to the
# verilog file should also be reflected in this system console script for continuity.
# For now, this script will support a commandline argument to support importing the API.
# This script will be sourced by the default atso_sc_script.tcl, which will do the pass
# fail analysis
########################################################


########################################################
# Memory Map for the Debug Block
########################################################
set ::NUM_CHNL_ADDR          0x0000
set ::NUM_FREQ_CHK_ADDR      0x0001
set ::NUM_PTRN_VER_ADDR      0x0002
set ::NUM_PTRN_GEN_ADDR      0x0003
set ::NUM_WRD_ALGN_ADDR      0x0004
set ::NUM_SCRATCH_ADDR       0x0005
set ::NUM_PLLS_ADDR          0x0006
set ::ATSO_STATUS_ADDR       0x0007
set ::SYS_CONTROL_ADDR       0x0008
set ::SOFT_RESET_ADDR        0x0010
set ::CHNL_BASE_ADDR         0x0100
set ::FREQ_CHK_BASE_ADDR     0x0200
set ::PTRN_GEN_BASE_ADDR     0x0300
set ::PTRN_VER_BASE_ADDR     0x0400
set ::WRD_ALGN_BASE_ADDR     0x0500
set ::PLL_BASE_ADDR          0x0600
set ::SCRATCH_STA_BASE_ADDR  0x0700

########################################################
# Open the slave for the debug block
# Arguments: None
# Return: Slave for reading and writing
########################################################
proc atso_open_debug_slave {} {
  set i 0
  foreach temp [get_service_paths slave] {
    incr i
    set marker [marker_get_info $temp]
    if { [regexp {system_console_debug_block} $marker] > 0 } {
      set atso_slave [lindex [get_service_paths slave] [expr $i - 1]]
      open_service slave $atso_slave
      set ::debug_slave $atso_slave
      return $atso_slave
    } else {
    }
  }
  puts "Debug Block Not Found! Please check the design."
}

########################################################
# asserts the reset to the design from the system console debug block.
# Arguments: None
# Returns: None
########################################################
proc atso_design_reset {} { 
  master_write_32 $::debug_slave [expr $::SOFT_RESET_ADDR * 4]  1
  master_write_32 $::debug_slave [expr $::SOFT_RESET_ADDR * 4]  0
  puts "Asserting Reset..."
}

########################################################
# Reads the atso status
# Arguments: None
# Return: 32-bit register value
########################################################
proc atso_read_atso_status {} {
  master_read_32 $::debug_slave [ expr $::ATSO_STATUS_ADDR * 4] 1
}

########################################################
# Read the tx-ready and rx-ready from each channel
# Arguments: None
# Return: None
########################################################
proc atso_read_all_channel {} {
  set num_chnl [master_read_32 $::debug_slave [expr $::NUM_CHNL_ADDR * 4] 1]
  puts [format "Number of Channels: %s" $num_chnl]
  set n 0
  foreach temp [master_read_32 $::debug_slave [expr $::CHNL_BASE_ADDR * 4] $num_chnl] {
    incr n
    set tx_cal    [expr ($temp & 0x20)/32]
    set rx_cal    [expr ($temp & 0x10)/16]
    set lock_data [expr ($temp & 0x8)/8]
    set lock_ref  [expr ($temp & 0x4)/4]
    set tx_ready  [expr ($temp & 0x2)/2]
    set rx_ready  [expr ($temp & 0x1)/1]
    puts [format " Channel:           %5s \n     tx_cal_busy=%s \n     rx_cal_busy=%s \n     rx_is_lockedtodata=%s \n     rx_is_lockedtoref=%s \n     tx_ready=%s \n     rx_ready=%s" $n $tx_cal $rx_cal $lock_data $lock_ref $tx_ready $rx_ready]
  }
}

########################################################
# Read all frequency checkers
# Arguments: None
# Return: None
########################################################
proc atso_read_all_freq_chk {} {
  set num_freq_chk [master_read_32 $::debug_slave [expr $::NUM_FREQ_CHK_ADDR * 4] 1]
  puts [format "Number of Frequency Checkers: %s" $num_freq_chk]
  set n 0
  foreach temp [master_read_32 $::debug_slave [expr $::FREQ_CHK_BASE_ADDR * 4] $num_freq_chk] {
    incr n
    set value    [expr ($temp & 0x3FFFC)/4]
    set measured [expr ($temp & 0x2)/2]
    set start    [expr ($temp & 0x1)/1]
    puts [format " Freq Checker:      %5s \n     Measured Done=%s \n     Freq Start Count=%s \n     Measured Frequency=%d" $n $measured $start $value]
  }
}

########################################################
# Read pattern generators and checkers
# Arguments: None
# Return: None
########################################################
proc atso_read_all_data_gen {} {
  set num_ptrn_gen [master_read_32 $::debug_slave [expr $::NUM_PTRN_GEN_ADDR * 4] 1]
  puts [format "Number of Data Generators: %s" $num_ptrn_gen]
  set n 0
  foreach temp [master_read_32 $::debug_slave [expr $::PTRN_GEN_BASE_ADDR * 4] $num_ptrn_gen] {
    incr n
    set gen_enable [expr ($temp & 0x1)/1]
    puts [format " Patten Generator:  %5s \n     Enabled=%s" $n $gen_enable]
  }
}

########################################################
# Read all pattern verifier
# Arguments: None
# Return: None
########################################################
proc atso_read_all_data_chk {} {
  set num_ptrn_chk [master_read_32 $::debug_slave [expr $::NUM_PTRN_VER_ADDR * 4] 1]
  puts [format "Number of Data Checkers: %s" $num_ptrn_chk]
  set n 0
  foreach temp [master_read_32 $::debug_slave [expr $::PTRN_VER_BASE_ADDR * 4] $num_ptrn_chk] {
    incr n
    set ver_error    [expr ($temp & 0x4)/4]
    set ver_lock     [expr ($temp & 0x2)/2]
    set ver_enable   [expr ($temp & 0x1)/1]
    puts [format " Pattern Verifier:  %5s \n     Enabled=%s \n     Locked=%s \n     Error=%s" $n $ver_enable $ver_lock $ver_error]
  }
}

########################################################
# Read all word aligners
# Arguments: None
# Return: None
########################################################
proc atso_read_all_wrd_algn {} {
  set num_wrd_algn [master_read_32 $::debug_slave [expr $::NUM_WRD_ALGN_ADDR * 4] 1]
  puts [format "Number of Word Aligners: %s" $num_wrd_algn]
  set n 0
  foreach temp [master_read_32 $::debug_slave [expr $::WRD_ALGN_BASE_ADDR * 4] $num_wrd_algn] {
    incr n
    set wa_align [expr ($temp & 0x2)/2]
    set wa_sync  [expr ($temp & 0x1)/1]
    puts [format " Word Aligner:      %5s \n     Aligned=%s \n     Synchronizing=%s" $n $wa_align $wa_sync]
  }
}

########################################################
# Reads pll locked for all PLLs
# Arguments: None
# Return: None
########################################################
proc atso_read_all_pll {} {
  set num_plls [master_read_32 $::debug_slave [expr $::NUM_PLLS_ADDR * 4] 1]
  puts [format "Number of PLLs: %s" $num_plls]
  set n 0
  foreach temp [master_read_32 $::debug_slave [expr $::PLL_BASE_ADDR * 4] $num_plls] {
    incr n
    set pll_cal [expr ($temp & 0x2)/2]
    set pll_lck [expr ($temp & 0x1)/1]
    puts [format " PLL:               %5s \n     Pll Locked=%s \n     Pll cal busy=%s" $n $pll_lck $pll_cal]
  }
}

########################################################
# Read the 32-bit value of all scratch registers
# Arguments: None
# Return: None
########################################################
proc atso_read_all_scratch {} {
  set num_scratch [master_read_32 $::debug_slave [expr $::NUM_SCRATCH_ADDR * 4] 1]
  puts [format "Number of Scratch Registers: %s" $num_scratch]
  set n 0
  foreach temp [master_read_32 $::debug_slave [expr $::SCRATCH_STA_BASE_ADDR * 4] $num_scratch] {
    incr n
    puts [format " Scratch Register:  %5s Status: %8s" $n $temp]
  }
}

########################################################
# Read the value of the control signals out of the system console debug block
# Arguments: None
# Return: None
########################################################
proc atso_read_control_signal {} {
  puts [format " Control Regiser Status: %8s" [master_read_32 $::debug_slave [expr $::SYS_CONTROL_ADDR * 4] 1]
}

########################################################
# Write a value to the control register block
# Arguments: 32-bit Value
# Return: None
########################################################
proc atso_write_control_signal {control_data} {
  puts "Writing $control_data to Control Register"
  master_write_32 $::debug_slave [expr $::SYS_CONTROL_ADDR * 4] $control_data
}

########################################################
# Read the value for the ATSO pass status
# Arguments: None
# Return: 1 bit
########################################################
proc atso_read_pass {} {
  set val [master_read_32 $::debug_slave [expr $::ATSO_STATUS_ADDR * 4] 1]
  set atso_status [expr [expr $val & 4]/4]
  return $atso_status
}

########################################################
# Read the value for the ATSO error status
# Arguments: None
# Return: 1 bit
########################################################
proc atso_read_error {} {
  set val [master_read_32 $::debug_slave [expr $::ATSO_STATUS_ADDR * 4] 1]
  set atso_status [expr [expr $val & 2]/2]
  return $atso_status
}
#
########################################################
# Read the value for the ATSO start status
# Arguments: None
# Return: 1 bit
########################################################
proc atso_read_start {} {
  set val [master_read_32 $::debug_slave [expr $::ATSO_STATUS_ADDR * 4] 1]
  set atso_status [expr $val & 1]
  return $atso_status
}

