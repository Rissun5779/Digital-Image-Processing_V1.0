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


  # Core Base Address
  variable CORE_BASE 0x1000

  # HW Test Base Address
  variable HWTEST_BASE 0x2000
  variable ADDR_HWTEST_LOOPBACK 0x1012

  # Register bit masks
  #variable TX_LANES_ALIGNED_MASK 0x0002

  # Timout in seconds waiting register bit to set (during read)
  variable TIMEOUT 30

  variable master_path ""

###
# write message into the log file as well as on screen
proc tee { {log "null"} msg } {
  if {$log eq "null"} {
    puts $msg
  } else {
    set fptr [open $log a+]
    puts $msg
    puts $fptr $msg
    close $fptr
  }
}

###
# write message into the log file as well as on screen
proc tee_nonewline { {log "null"} msg } {
  if {$log eq "null"} {
    puts -nonewline $msg
  } else {
    set fptr [open $log a+]
    puts -nonewline $msg
    puts -nonewline $fptr $msg
    close $fptr
  }
}

###
# Use the first detected JTAG master
proc use_ilk_master {} {
  variable master_path
  set master_path [ lindex [ get_service_paths master ] 0 ]
}


###
# Perform a single register write to the HW test address space
#
# @param - address - The register address to write to.
# @param - data    - The data to be written to the register.
proc reg_write { address data } {
  set address [expr {$address * 4}]
  write_32 $address $data
}

###
# Perform a single register read from the HW test address space
#
# @param - address - The register address to read from.
# @return          - The value of the register specified by "address"
proc reg_read { address } {
  set address [expr {$address * 4}]
  return [read_32 $address 1]
}

###
# Turn on loopback
#
proc loop_on {} {
  variable ADDR_HWTEST_LOOPBACK
  reg_write $ADDR_HWTEST_LOOPBACK 0xFFFFFF
  
  # clear register sop eop crc24
  reg_write 0x200e 0x1
  sleep 1
  reg_write 0x200e 0x0
  
#  puts [format "0x%06x" [reg_read $ADDR_HWTEST_LOOPBACK]]
}

###
# Turn off loopback
#
proc loop_off {} {
  variable ADDR_HWTEST_LOOPBACK
  reg_write $ADDR_HWTEST_LOOPBACK 0x0
}

###
# Enable Traffic Generator
#
proc gen_on {} {
  variable HWTEST_BASE
  reg_write [expr {$HWTEST_BASE + 15}] 0x1
}

###
# Disable Traffic Generator
#
proc gen_off {} {
  variable HWTEST_BASE
  reg_write [expr {$HWTEST_BASE + 15}] 0x0
}

###
# Sleep N seconds
#
proc sleep {N} {
  after [expr {int($N * 1000)}]
}

###
# Reset system
#
proc sys_reset {} {
  variable HWTEST_BASE
  #variable TX_LANES_ALIGNED_MASK
  reg_write [expr {$HWTEST_BASE + 3}] 0x1
  reg_write [expr {$HWTEST_BASE + 2}] 0x1
  sleep 1
  reg_write [expr {$HWTEST_BASE + 3}] 0x0
  reg_write [expr {$HWTEST_BASE + 2}] 0x0
}



###
# System restart
#
proc restart {} {
  sys_reset
  loop_on
  gen_on
}


###
# Set Burst size for burst interleave mode (in bytes)
#
proc set_burst_size {burst_size} {
  variable HWTEST_BASE
  if {$burst_size == 128} {
    reg_write [expr {$HWTEST_BASE + 54}] 128
  } elseif {$burst_size == 256} {
    reg_write [expr {$HWTEST_BASE + 54}] 256
  } elseif {$burst_size == 512} {
    reg_write [expr {$HWTEST_BASE + 54}] 512
  } else {
    puts "  ERROR: Burst size can only be 128 Bytes, 256 Bytes or 512 Bytes"
  }
}

###
# Print Burst size
#
proc get_burst_size {} {
  variable HWTEST_BASE
  puts [format "  Burst Size is %u Bytes" [reg_read [expr {$HWTEST_BASE + 54}]]]
}

###
# Testcase setup
#
# @param - mode - random or one of four directed modes
# @param - minimum packet size (bytes)
# @param - maximum packet size (bytes)
# @param - packet size increment (in bytes)
# @param - number of packets of each size to run
proc set_test { mode min_pkt_size max_pkt_size step num_run } {
  variable HWTEST_BASE
  if {[string first "rand" $mode] != -1 } {
    puts "  Setting test to run in random mode"
    reg_write [expr {$HWTEST_BASE + 49}] 0
    reg_write [expr {$HWTEST_BASE + 51}] 0
    reg_write [expr {$HWTEST_BASE + 50}] 0
    reg_write [expr {$HWTEST_BASE + 53}] 0
    reg_write [expr {$HWTEST_BASE + 48}] 0
    reg_write [expr {$HWTEST_BASE + 52}] 0
  } elseif {$min_pkt_size > $max_pkt_size} {
    puts "  ERROR: Packet minimum size cannot be grater than packet maximum size"
  } elseif {$min_pkt_size == $max_pkt_size && $step != 0} {
    puts "  When min and max packet sizes set to the same value step should be set to 0"
  } else {
    puts "  Setting test to run in directed mode"
    reg_write [expr {$HWTEST_BASE + 49}] $min_pkt_size
    reg_write [expr {$HWTEST_BASE + 51}] $max_pkt_size
    reg_write [expr {$HWTEST_BASE + 50}] $step
    reg_write [expr {$HWTEST_BASE + 53}] $num_run
    reg_write [expr {$HWTEST_BASE + 48}] 1
    reg_write [expr {$HWTEST_BASE + 52}] $mode
  }
}

###
# Print status info
#
proc stat { {log "null"} } {
  set CORE_BASE 4096
  variable HWTEST_BASE
  variable data
  variable vendor
  variable major
  variable minor
  set SOP_ERR_MASK   0x0008
  set CH_ID_ERR_MASK 0x0004
  set PLD_ERR_MASK   0x0002
  set EOP_ERR_MASK   0x0001

  set data [reg_read [expr {$CORE_BASE + 240}]]
  set vendor [expr {$data >> 24}]
  set vendor [expr {$vendor & 0xff}]
  set major  [expr {$data >> 8}]
  set major  [expr {$major & 0xFF}]
  set minor  [expr {$data & 0xFF}]

  tee $log         "    ==== STATUS REPORT ===="
  #tee $log         "    Revision info"
  # Megacore does not have separate revision register
  #tee $log [format "         Vendor ID : %u" [expr {$vendor}]]
  #tee $log [format "         Major Rel : 0x%02x" $major]
  #tee $log [format "         Minor Rel : 0x%02x" $major]
  #tee $log ""
  tee $log [format "    TX KHz         : %u"     [reg_read [expr {$CORE_BASE + 14}]]]
  tee $log [format "    RX KHz         : %u"     [reg_read [expr {$CORE_BASE + 13}]]]
  tee $log [format "    PLL ref KHz    : %u"     [reg_read [expr {$CORE_BASE + 12}]]]
  tee $log [format "    Freq locks     : 0x%06x" [reg_read [expr {$CORE_BASE + 16}]]]
  tee $log [format "    TX PLL lock    : 0x%06x" [reg_read [expr {$CORE_BASE + 17}]]]
  tee $log ""
  tee $log [format "    word lock      : 0x%06x" [reg_read [expr {$HWTEST_BASE + 4}]]]
  tee $log [format "    sync lock      : 0x%06x" [reg_read [expr {$HWTEST_BASE + 5}]]]
  tee $log ""
  tee $log [format "    CRC32 errors   : %u"     [reg_read [expr {$HWTEST_BASE + 6}]]]
  tee $log [format "    CRC24 errors   : %u"     [reg_read [expr {$HWTEST_BASE + 10}]]]
  tee $log [format "    Checker errors : %u"     [reg_read [expr {$HWTEST_BASE + 14}]]]
  set data [reg_read [expr {$HWTEST_BASE + 16}]]
  #tee $log [format "0x%04x" $data]
  if {$data & $SOP_ERR_MASK}   {tee $log "      SOP data corrupted!"}
  if {$data & $CH_ID_ERR_MASK} {tee $log "      Channel ID corrupted!"}
  if {$data & $PLD_ERR_MASK}   {tee $log "      PLD data corrupted!"}
  if {$data & $EOP_ERR_MASK}   {tee $log "      EOP data corrupted!"}
  tee $log ""
  tee $log [format "    FIFO err flags : 0x%06x" [reg_read [expr {$HWTEST_BASE + 11}]]]
  tee $log [format "    SOP count      : %u"     [reg_read [expr {$HWTEST_BASE + 12}]]]
  tee $log [format "    EOP count      : %u"     [reg_read [expr {$HWTEST_BASE + 13}]]]
  tee $log ""
  # set temp [reg_read [expr {$CORE_BASE + 2}]]
  # set temp_F [expr {$temp & 0xff}]
  # set temp2  [expr {$temp >> 8}]
  # set temp_C [expr {$temp2 & 0xff}]
  # tee_nonewline $log "    Temp           : $temp_F degrees F ($temp_C"
  # tee $log "C)"
  tee $log "    Elapsed [expr [reg_read [expr {$CORE_BASE + 3}]]] sec since powerup"
  tee $log ""
}

###
# Print help info
#
proc help_cmd {} {
  puts "  loop_on                                                         : turn on internal loopback"
  puts "  loop_off                                                        : turn off internal loopback"
  puts "  gen_on                                                          : turn on traffic generator"
  puts "  gen_off                                                         : turn off traffic generator"
  puts "  sys_reset                                                       : system reset"
  puts "  restart                                                         : system reset -> loop_on -> gen_on"
  puts "  reset_loop N                                                    : repeat restart N times"
  puts "  set_test mode <min_pkt_size> <max_pkt_size> <step> <num_to_run> : Setup test to run in a specific mode"
  puts "  get_test_mode                                                   : Print test mode that is currently used"
  puts "  stat                                                            : Print general status info"
  puts "  set_burst_size   <burst_size>                                   : Set burst size in bytes. Acceptable values 128, 256, 512"
  puts "  get_burst_size                                                  : Print burst size info"
  puts "  help_cmd                                                        : print this info"
}

#****************************************************************************
#************************* Internal Functions *******************************

# Functions for accessing the jtag master
###
# Write a set of 32-bit (4 byte) values beginning at the address
# specified. The address must be on a 4-byte boundary
proc write_32 { address values } {
  variable master_path

  if { $master_path == "" } {
    puts "JTAG master path not specified! No write performed!"
  } else {
    master_write_32 $master_path $address $values
  }
}

###
# Read a set of 32-bit (4 byte) values beginning at the address
# specified. The address must be on a 4-byte boundary
proc read_32 { address size } {
  variable master_path

  if { $master_path == "" } {
    puts "JTAG master path not specified! No read performed!"
    return 0
  } else {
    return [ master_read_32 $master_path $address $size ]
  }
}

###
# run example design 
#
proc run_example_design {} {
  
  puts "__________________________________________________________"
  puts "\t INFO: Reseting the system"
  puts "__________________________________________________________\n\n"
  sys_reset
  
  puts "__________________________________________________________"
  puts "\t INFO: Enabling serial loopback"
  puts "__________________________________________________________\n\n"
  loop_on
  puts "__________________________________________________________"
  puts "\t INFO: Checking system statistics on reset"
  puts "__________________________________________________________\n\n"
  stat

  puts "__________________________________________________________"
  puts "\t INFO: INFO: Transmitting packets"
  puts "__________________________________________________________\n\n"  
  gen_on
  
  puts "__________________________________________________________"
  puts "\t INFO: INFO: Checking received packets statistics"
  puts "__________________________________________________________\n\n"

  stat
}

#************************* Internal Functions *******************************
#****************************************************************************

#set master_path [ lindex [ get_service_paths master ] 0 ]
foreach master_name [ get_service_paths master ] {
    if { [regexp .*phy_0* $master_name] } {
      	set master_path $master_name
        # puts "master_path:$master_name"
      	break
    }
}
open_service master $master_path
#use_default_master
use_ilk_master
