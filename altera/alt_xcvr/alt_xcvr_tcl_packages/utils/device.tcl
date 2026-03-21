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


package provide alt_xcvr::utils::device 18.1

package require alt_xcvr::utils::common
package require alt_xcvr::utils::fileset

namespace eval ::alt_xcvr::utils::device:: {

  namespace export \
    get_c4gx_name \
    get_s4_name \
    get_a2gz_name \
    get_a2gx_name \
    get_hc4_name \
    get_s5_name \
    get_a5gz_name \
    get_a5_name \
    list_c4_style_hssi_families \
    list_c4_style_hssi_families \
    list_s4_style_hssi_families \
    list_s4_style_hssi10g_families \
    list_s4_style_hssi10g_families \
    list_s5_style_hssi_families \
    list_a5gz_style_hssi_families \
    list_a5_style_hssi_families \
    list_c5_style_hssi_families \
    has_c4_style_hssi \
    has_s4_style_hssi \
    has_s4_style_hssi10g \
    has_s5_style_hssi \
    has_a5gz_style_hssi \
    has_a5_style_hssi \
    has_c5_style_hssi \
    get_typical_device \
    get_device_speedgrades \
	get_pcs_speedgrade \
	get_pma_speedgrade \
	get_operating_temperature \
    get_a10_pcs_speedgrade \
    get_a10_pma_speedgrade \
    get_a10_operating_temperature \
    is_a10_gt \
    get_s10_pcs_speedgrade \
    get_s10_pma_speedgrade \
    get_s10_operating_temperature \
    get_device_family_max_channels \
    get_fpll_name \
    get_cmu_pll_name \
    get_atx_pll_name \
    get_hssi_pll_types \
    get_cgb_divider_values \
    get_reconfig_to_xcvr_width \
    get_reconfig_from_xcvr_width \
    get_reconfig_interface_count \
    get_reconfig_to_xcvr_total_width \
    get_reconfig_from_xcvr_total_width \
    convert_speed_grade \
    get_arria10_regmap \
    get_stratix10_regmap

	variable opn_data	
	set opn_data ""
}

######################################
# +-----------------------------------
# | Device families
# +-----------------------------------
######################################

# +-----------------------------------
# | Define list of Cyclone IV GX-derived families
# |
proc ::alt_xcvr::utils::device::get_c4gx_name { } { return "Cyclone IV GX" }
proc ::alt_xcvr::utils::device::list_c4_style_hssi_families { } {
  return [list [get_c4gx_name]]
}

# +-----------------------------------
# | Test if given family has Cyclone IV GX-style HSSI features
# |
proc ::alt_xcvr::utils::device::has_c4_style_hssi { fam } {
  set fams [ list_c4_style_hssi_families ]
  set famPos [ lsearch -exact $fams $fam ]
  return [expr $famPos > -1 ]
}

# +-----------------------------------
# | Define list of Stratix IV-derived families
# | 
proc ::alt_xcvr::utils::device::get_s4_name    { } { return "Stratix IV" }
proc ::alt_xcvr::utils::device::get_a2gz_name  { } { return "Arria II GZ" }
proc ::alt_xcvr::utils::device::get_a2gx_name  { } { return "Arria II GX" }
proc ::alt_xcvr::utils::device::get_hc4_name   { } { return "HardCopy IV" }

proc ::alt_xcvr::utils::device::list_s4_style_hssi_families { } {
  #return {{Stratix IV} {Arria II GZ} {Arria II GX} {HardCopy IV}}
  return [ list [get_s4_name] [get_a2gz_name] [get_a2gx_name] [get_hc4_name] ]
}

# +-----------------------------------
# | Define list of Stratix IV-derived families that are 10G capable
# | 
proc ::alt_xcvr::utils::device::list_s4_style_hssi10g_families { } {
  return [ list [get_s4_name] ]
}

# +-----------------------------------
# | Test if given family has Stratix IV-style HSSI features
# | 
proc ::alt_xcvr::utils::device::has_s4_style_hssi { fam } {
  set fams [ list_s4_style_hssi_families ]
  set famPos [ lsearch -exact $fams $fam ]
  return [expr $famPos > -1 ]
}

# +-----------------------------------
# | Test if given family has Stratix IV-style HSSI features
# | 
proc ::alt_xcvr::utils::device::has_s4_style_hssi10g { fam } {
  set fams [ list_s4_style_hssi10g_families ]
  set famPos [ lsearch -exact $fams $fam ]
  return [expr $famPos > -1 ]
}

# +-----------------------------------
# | Define list of Stratix V-derived families
# | 
proc ::alt_xcvr::utils::device::get_s5_name { } { return "Stratix V" }
proc ::alt_xcvr::utils::device::get_a5gz_name { } { return "Arria V GZ" }

proc ::alt_xcvr::utils::device::list_s5_style_hssi_families { } {
  return [ list [get_s5_name] [get_a5gz_name] ]
}

proc ::alt_xcvr::utils::device::list_a5gz_style_hssi_families { } {
  return [ list [get_a5gz_name] ]
}

# +-----------------------------------
# | Test if given family has Stratix V-style HSSI features
# | 
proc ::alt_xcvr::utils::device::has_s5_style_hssi { fam } {
  set fams [ list_s5_style_hssi_families ]
  set famPos [ lsearch -exact $fams $fam ]
  return [expr $famPos > -1 ]
}

proc ::alt_xcvr::utils::device::has_a5gz_style_hssi { fam } {
  set fams [ list_a5gz_style_hssi_families ]
  set famPos [ lsearch -exact $fams $fam ]
  return [expr $famPos > -1 ]
}

# +-----------------------------------
# | Define list of Arria V-derived families
# | 
proc ::alt_xcvr::utils::device::get_a5_name { } { return "Arria V" }

proc ::alt_xcvr::utils::device::list_a5_style_hssi_families { } {
  return [ list [get_a5_name] ]
}

# +-----------------------------------
# | Test if given family has Arria V-style HSSI features
# |

proc ::alt_xcvr::utils::device::has_a5_style_hssi { fam } {
  set fams [ list_a5_style_hssi_families ]
  set famPos [ lsearch -exact $fams $fam ]
  return [expr $famPos > -1 ]
}

# +-----------------------------------
# | Define list of Cylcone V-derived families
# | 
proc ::alt_xcvr::utils::device::list_c5_style_hssi_families { } {
        #return {"Cyclone V"}
        return [ list "Cyclone V" ]
}

# +-----------------------------------
# | Test if given family has Arria V-style HSSI features
# |

proc ::alt_xcvr::utils::device::has_c5_style_hssi { fam } {
  set fams [ list_c5_style_hssi_families ]
  set famPos [ lsearch -exact $fams $fam ]
  return [expr $famPos > -1 ]
}

##
# Get the part number of the typical devices for a given family
# for speedgrade argument values
proc ::alt_xcvr::utils::device::get_typical_device { device_family {speedgrade "default"} } {

  set device ""
        
  if [has_a5gz_style_hssi $device_family] {
   # case:170999 - Initial speedgrade strings for AVGZ from "get_device_speedgrades" were
   # incorrect. Adding "3H2" and "4H3" to compensate. 
    switch $speedgrade {
      "3_H2"  { set device "ARRIAVGZ_F2D_V2_H2F1517AC3" }
      "4_H3"  { set device "ARRIAVGZ_F2D_V2_H3F1517AC4" }
      "3H2"   { set device "ARRIAVGZ_F2D_V2_H2F1517AC3" }
      "4H3"   { set device "ARRIAVGZ_F2D_V2_H3F1517AC4" }
      default { set device "ARRIAVGZ_F2D_V2_H2F1517AC3" }
    }
  } elseif [has_s5_style_hssi $device_family] {
    switch $speedgrade {
      "1_H1"  { set device "5SGXEA7H1F35C1" }
      "1_H2"  { set device "5SGXEA7H2F35C1" }
      "1_H3"  { set device "5SGXEA7H3F35C1" }
      "2_H1"  { set device "5SGXEA7H1F35C2" }
      "2_H2"  { set device "5SGXEA7H2F35C2" }
      "2_H3"  { set device "5SGXEA7H3F35C2" }
      "3_H2"  { set device "5SGXEA7H2F35C3" }
      "3_H3"  { set device "5SGXEA7H3F35C3" }
      "4_H3"  { set device "5SGSMD4E3H29C4" }
      default { set device "5SGXEA7H1F35C2" }
    }
  } elseif [has_a5_style_hssi $device_family] {
	switch $speedgrade {
      "3_H3"  { set device "5AGTFD3H3F35I3" }
      "4_H4"  { set device "5AGXFB3H4F35C4" }
      "5_H3"  { set device "5AGTFD3H3F35I5" }
      "5_H4"  { set device "5AGXFB3H4F35I5" }
      "6_H6"  { set device "5AGXFB3H6F40C6" }
      default { set device "5AGXFB3H4F40C4" }
    }
  } elseif [has_c5_style_hssi $device_family] {
	switch $speedgrade {
      "6_H6"  { set device "5CGXFC7D6F31C6" }
      "7_H5"  { set device "5CGTFD9E5F35C7" }
      "7_H6"  { set device "5CGXFC9E6F35C7" }
      "8_H6"  { set device "5CSXFC6D6F31C8" }
      "8_H7"  { set device "5CGXFC9E7F35C8" }
	  default { set device "5CGTFD6F27C5ES" }
    }
  }
	
  return $device
}

proc ::alt_xcvr::utils::device::get_device_speedgrades { device_family } {

  # Note. See case 170999. AVGZ speedgrades were coded incorrectly. Don't modify to maintain
  # backward compatibility. Added new mappings in "get_typical_device" to compensate
  set speedgrades [expr { [has_a5gz_style_hssi $device_family]? {fastest 3H2 4H3}
    : [has_s5_style_hssi $device_family] ? {fastest 1_H1 1_H2 1_H3 2_H1 2_H2 2_H3 3_H2 3_H3 4_H3}
    : [has_a5_style_hssi $device_family] ? {fastest 3_H3 4_H4 5_H3 5_H4 6_H6} 
	: [has_c5_style_hssi $device_family] ? {fastest 6_H6 7_H5 7_H6 8_H6 8_H7} 
    : "fastest" }]
  
  return $speedgrades
}

##
# returns pcs speed grade for Arria 10 devices (13th char in part number)
proc ::alt_xcvr::utils::device::get_a10_pcs_speedgrade { part_number } {
  set ret "1"
  if { [is_a10_part_number $part_number] } {
    set ret [string range $part_number 13 13]
  }
  return $ret
}

##
# returns pma speed grade for Arria 10 devices (8th char in part number)
# default is 2, we want to return fastest and seems like currently fastest gt speed grade for pma is 2 
proc ::alt_xcvr::utils::device::get_a10_pma_speedgrade { part_number } {
  set ret "2"
  if { [is_a10_part_number $part_number] } {
    set ret [string range $part_number 8 8]
  }
  return $ret
}

##
# returns operating temperature char for Arria 10 devices (12th char in part number)
proc ::alt_xcvr::utils::device::get_a10_operating_temperature { part_number } {
  set ret "e"
  if { [is_a10_part_number $part_number] } {
    set ret [string tolower [string range $part_number 12 12]]
  }
  return $ret
}

##
# check 3rd char for Arria 10 devices (GT --> 10AT )
proc ::alt_xcvr::utils::device::is_a10_gt { part_number } {
  set ret 0
  if { [is_a10_part_number $part_number] } {
    set ret [expr { [string tolower [string range $part_number 3 3]] == "t" ? 1 : 0 } ]
  }
  return $ret
}

##
# returns pcs speed grade for Stratix10 devices (13th char in part number)
proc ::alt_xcvr::utils::device::get_s10_pcs_speedgrade { part_number } {
  set ret "1"
  if { [is_s10_part_number $part_number] } {
    set ret [string range $part_number 13 13]
  }
  return $ret
}

##
# returns pma speed grade for Stratix 10 devices (8th char in part number)
# default is 2, we want to return fastest and seems like currently fastest gt speed grade for pma is 2 
proc ::alt_xcvr::utils::device::get_s10_pma_speedgrade { part_number } {
  set ret "2"
  if { [is_s10_part_number $part_number] } {
    set ret [string range $part_number 8 8]
  }
  return $ret
}

##
# returns operating temperature char for Stratix 10 devices (12th char in part number)
proc ::alt_xcvr::utils::device::get_s10_operating_temperature { part_number } {
  set ret "e"
  if { [is_s10_part_number $part_number] } {
    set ret [string tolower [string range $part_number 12 12]]
  }
  return $ret
}

##
# checks if the part number is for an Arria 10 device (checks length as well as the first 3 letters)
proc ::alt_xcvr::utils::device::is_a10_part_number { part_number } {
  set ret 0
  set pn_length [string length $part_number]
  if { $pn_length>=16 && $pn_length<=18 } {
    if { [string range $part_number 0 2] == "10A" } {
      set ret 1
    }
  }
  return $ret
}
##
# checks if the part number is for an Stratix 10 device (checks length as well as the first 3 letters)
proc ::alt_xcvr::utils::device::is_s10_part_number { part_number } {
  set ret 0
  set pn_length [string length $part_number]
  if { $pn_length>=16 && $pn_length<=18 } {
    if { [string range $part_number 0 2] == "10S" } {
      set ret 1
    }
  }
  return $ret
}

proc ::alt_xcvr::utils::device::get_opn_data {} {
	variable opn_data

	if { $opn_data == "" } {
		# Initialize opn_data
		if {[catch {set opn_data [dict create]}]} {
			return $opn_data
		}
		
		set opn_field_table {\
			{ FAMILY		PART	MIN_OPN	MAX_OPN	DEFAULT_PMA_SPEEDGRADE	DEFAULT_PCS_SPEEDGRADE	DEFAULT_TEMPERATURE	MAX_CHANNELS	I_SERIES	I_PMA_SPEEDGRADE	I_TEMPERATURE	I_PCS_SPEEDGRADE} \
			{ "Arria 10"	"10A"	16		18		2						1						"e"					96				0:2			8:8					12:12			13:13			} \
			{ "Stratix 10"	"1S"	16		18		2						1						"e"					144				0:2			8:8					12:12			13:13			} \
		}  
	
		set headers [lindex $opn_field_table 0]  
		set length [llength $opn_field_table]
		set family_index [lsearch $headers FAMILY]
		for {set i 1} {$i < $length} {incr i} {
			set this_entry [lindex $opn_field_table $i]
			set key [lindex $this_entry $family_index]
			for {set j 0} {$j < [llength $this_entry]} {incr j} {
				dict set opn_data $key [lindex $headers $j] [lindex $this_entry $j]
			}
		}
	} 

	return $opn_data	
}

##
# checks if the part number is for the family (checks length as well as the part prefix)
proc ::alt_xcvr::utils::device::is_valid_part_number { family part_number } {
  set opn_data [get_opn_data]
  set ret 0
  set opn_length [string length $part_number]

  set min_opn [dict get $opn_data $family MIN_OPN]
  set max_opn [dict get $opn_data $family MAX_OPN]
  set part [dict get $opn_data $family PART]
  
  set i_series [split [dict get $opn_data $family I_SERIES] ":"]
  set part_begin [lindex $i_series 0 ]
  set part_end [lindex $i_series 1 ]

  # The part number length varies because of ES or production. ES devices will have "ES" at the end of the OPN but not production devices.
  if { $opn_length>=$min_opn && $opn_length<=$max_opn } {
    if { [string range $part_number $part_begin $part_end] == $part } {
      set ret 1
    }
  }
  return $ret
}

##
# returns pcs speed grade for the selected device part
proc ::alt_xcvr::utils::device::get_pcs_speedgrade { family part_number } {
  set opn_data [get_opn_data]
  
  set default_pcs_speedgrade [dict get $opn_data $family DEFAULT_PCS_SPEEDGRADE]  
  set i_pcs_speedgrade [split [dict get $opn_data $family I_PCS_SPEEDGRADE] ":"]
  set pcs_speedgrade_begin [lindex $i_pcs_speedgrade 0 ]
  set pcs_speedgrade_end [lindex $i_pcs_speedgrade 1 ]

  set ret $default_pcs_speedgrade
  if { [is_valid_part_number $family $part_number] } {
    set ret [string range $part_number $pcs_speedgrade_begin $pcs_speedgrade_end]
  }
  return $ret
}

##
# returns pma speed grade for selected device part
# default is 0, we want to return fastest and seems like currently fastest gt speed grade for pma is 2
proc ::alt_xcvr::utils::device::get_pma_speedgrade { family part_number } {
   set opn_data [get_opn_data]
  
  set default_pma_speedgrade [dict get $opn_data $family DEFAULT_PMA_SPEEDGRADE]  
  set i_pma_speedgrade [split [dict get $opn_data $family I_PMA_SPEEDGRADE] ":"]
  set pma_speedgrade_begin [lindex $i_pma_speedgrade 0 ]
  set pma_speedgrade_end [lindex $i_pma_speedgrade 1 ]

  set ret $default_pma_speedgrade
  if { [is_valid_part_number $family $part_number] } {
    set ret [string range $part_number $pma_speedgrade_begin $pma_speedgrade_end]
  }
  return $ret
}

##
# returns operating temperature char for the selected device part
proc ::alt_xcvr::utils::device::get_operating_temperature { family part_number } {
   set opn_data [get_opn_data]
  
  set default_temperature [dict get $opn_data $family DEFAULT_TEMPERATURE]  
  set i_temperature [split [dict get $opn_data $family I_TEMPERATURE] ":"]
  set temperature_begin [lindex $i_temperature 0 ]
  set temperature_end [lindex $i_temperature 1 ]

  set ret $default_temperature
  if { [is_valid_part_number $family $part_number] } {
    set ret [string tolower [string range $part_number $temperature_begin $temperature_end]]
  }
  return $ret
}

##
# Get the maximum number of channels for a given device family
proc ::alt_xcvr::utils::device::get_device_family_max_channels { device_family } {
  set channels 0
  if [has_s5_style_hssi $device_family] {
    set channels 66
  } elseif [has_a5_style_hssi $device_family] {
    set channels 36
  } elseif [has_c5_style_hssi $device_family] {
		set channels 12
  } else {
	set opn_data [get_opn_data]
	if {$opn_data != ""} {
		if [dict exists $opn_data $device_family] {
			set channels [dict get $opn_data $device_family MAX_CHANNELS]
		}	
	}
  }

  return $channels
}

#
proc ::alt_xcvr::utils::device::get_fpll_name { } {
  return "FPLL"
}

proc ::alt_xcvr::utils::device::get_cmu_pll_name { } {
  return "CMU"
}

proc ::alt_xcvr::utils::device::get_atx_pll_name { } {
  return "ATX"
}

##
# Get a list of supported HSSI transceiver PLLs for the given device family
proc ::alt_xcvr::utils::device::get_hssi_pll_types { device_family } {
  if [has_s5_style_hssi $device_family] {
    return [list [get_cmu_pll_name] [get_atx_pll_name]]
  }
  if [has_a5_style_hssi $device_family] {
    return [list [get_cmu_pll_name]]
  }
  if [has_c5_style_hssi $device_family] {
    return [list [get_cmu_pll_name]]
    # return {"FPLL"}
  }
  if [has_s4_style_hssi $device_family] {
    return [list [get_cmu_pll_name] [get_atx_pll_name]]
  }
}

proc ::alt_xcvr::utils::device::get_cgb_divider_values { device_family } {
  if [has_s5_style_hssi $device_family] {
    return {1 2 4 8}
  } elseif [has_a5_style_hssi $device_family] {
    return {1 2 4 8}
  } elseif [has_c5_style_hssi $device_family] {
    return {1 2 4 8}
  } else {
    return {1}
  }
}


# +---------------------------------------------------------------
# | Given a device family, return the reconfig_to_xcvr bundle width
# |
proc ::alt_xcvr::utils::device::get_reconfig_to_xcvr_width { fam } {
  set s4_style_width 4
  set s5_style_width 70

  if { [has_s4_style_hssi $fam] } {
    # Stratix IV style
    return $s4_style_width
  } elseif { [has_c4_style_hssi $fam] } {
    # Cyclone IV style
    return $s4_style_width
  } elseif { [has_s5_style_hssi $fam] | [has_a5_style_hssi $fam] | [has_c5_style_hssi $fam] } {
    # Stratix V style
    return $s5_style_width
  } else {
    # Invalid family - not sure what to do here.
    return 0;
  }
}


# +-----------------------------------------------------------------
# | Given a device family, return the reconfig_from_xcvr bundle width
proc ::alt_xcvr::utils::device::get_reconfig_from_xcvr_width { fam } {
  set s4_style_width 17
  set s5_style_width 46

  if { [has_s4_style_hssi $fam] } {
    # Stratix IV style
    return $s4_style_width
  } elseif { [has_c4_style_hssi $fam] } {
    # Cyclone IV style
    return $s4_style_width
  } elseif { [has_s5_style_hssi $fam] | [has_a5_style_hssi $fam] | [has_c5_style_hssi $fam] } {
    # Stratix V style
    return $s5_style_width
  } else {
    # Invalid family - not sure what to do here.
    return 0;
  }
}


# +----------------------------------------------------------------
# | Get the number of reconfig interfaces given a device family and
# | other required parameters
# | fam - Device family
# | channels - Number of transceiver channels
# | tx_plls - Number of transmit plls (needed for Stratix V families)
proc ::alt_xcvr::utils::device::get_reconfig_interface_count { fam channels tx_plls } {
  set count 0
  if { [has_s4_style_hssi $fam] } {
    set count [expr {$channels / 4} ]
    if { [expr {$channels % 4}] != 0 } {
      set count [expr {$count + 1}]
    }
  } elseif { [has_s5_style_hssi $fam] | [has_a5_style_hssi $fam] | [has_c5_style_hssi $fam] } {
    set count [expr {$channels + $tx_plls}]
  }

  return $count
}

# +------------------------------------------------------------------
# | Get reconfig_to_xcvr total port width for specified device family
#
# | Returns 0 if the device_family argument is invalid, otherwise
# | it returns the width of the reconfig_to_xcvr port for that family
proc ::alt_xcvr::utils::device::get_reconfig_to_xcvr_total_width { fam reconfig_interfaces } {
  set count 0
  set width [get_reconfig_to_xcvr_width $fam]
  if { [has_s5_style_hssi $fam ] | [has_a5_style_hssi $fam] | [has_c5_style_hssi $fam] } {
    set count [expr {$reconfig_interfaces * $width}]
  } elseif { [has_s4_style_hssi $fam] } {
    set count $width
  }  elseif { [has_c4_style_hssi $fam] } {
    # Cyclone IV style
    set count $width
  } else {
    set count 0
  }
  return $count
}


# +------------------------------------------------------------------
# | Get reconfig_from_xcvr total port width for specified device family
#
# | Returns 0 if the device_family argument is invalid, otherwise
# | it returns the width of the reconfig_from_xcvr port for that family
proc ::alt_xcvr::utils::device::get_reconfig_from_xcvr_total_width { fam reconfig_interfaces } {
  set count 0
  set width [get_reconfig_from_xcvr_width $fam]
  if { [has_s5_style_hssi $fam ] | [has_a5_style_hssi $fam] | [has_c5_style_hssi $fam] } {
    set count [expr {$reconfig_interfaces * $width}]
  } elseif { [has_s4_style_hssi $fam] } {
    set count [expr {$reconfig_interfaces * $width}]
  } elseif { [has_c4_style_hssi $fam] } {
    set count [expr {$reconfig_interfaces * $width}]
  } else {
    set count 0
  }
  return $count
}

# +-----------------------------------
# | converting the given speedgrade representation to the corresponding value (-2, -3, -4)
# |
proc ::alt_xcvr::utils::device::convert_speed_grade { speed_grade } {
   set speed_grade_val 4

   if {[string compare -nocase $speed_grade 1_H2]==0 } {
      set speed_grade_val 2   
   } elseif { [string compare -nocase $speed_grade 1_H3]==0 } {
      set speed_grade_val 3   
   } elseif { [string compare -nocase $speed_grade 1_H4]==0 } {
      set speed_grade_val 4   
   } else {
      set speed_grade_val 4   
   }
   return $speed_grade_val    
}


###
# Returns a data structure (dictionary) containing the register map 
# for the specified blocks.
#
# @param blocks A list of the desired blocks "pma, pcs, fpll, or atx" the register map should contain
#
# @return A dictionary of the structure returned by the 
#         ::alt_xcvr_utils::common::parse_series10_style_register_map procedure.
#         Refer to that procedure for details
#         Returns -1 if an error occurs
proc ::alt_xcvr::utils::device::get_arria10_regmap { {blocks {pma pcs fpll atx}} {device_revision NOVAL} {replace_x 1} } {
  set filenames [dict create]
  dict set filenames pma  [expr { $device_revision=="20nm5es2" ?    "PMA_Register_Map_nf5es2.csv"    :    "PMA_Register_Map.csv"}]
  dict set filenames pcs  [expr { $device_revision=="20nm5es2" ?    "PCS_Register_Map_nf5es2.csv"    :    "PCS_Register_Map.csv"}]
  dict set filenames fpll [expr { $device_revision=="20nm5es2" ?   "FPLL_Register_Map_nf5es2.csv"    :   "FPLL_Register_Map.csv"}]
  dict set filenames atx  [expr { $device_revision=="20nm5es2" ? "ATXPLL_Register_Map_nf5es2.csv"    : "ATXPLL_Register_Map.csv"}]
  
  set data [dict create]

  foreach block $blocks {
    if {![dict exists $filenames $block]} {
      return -1
    } else {
      set filename "[::alt_xcvr::utils::fileset::get_alt_xcvr_path]/alt_xcvr_core/nf/doc/[dict get $filenames $block]"
      set retval [::alt_xcvr::utils::common::parse_series10_style_register_map $filename $replace_x]
      if {$retval == -1} {
        return $retval
      } else {
        set data [dict merge $data $retval]
      }
    }
  }

  return $data
}

###
# Returns a data structure (dictionary) containing the register map 
# for the specified blocks.
#
# @param blocks A list of the desired blocks "pma, pcs, fpll, or atx" the register map should contain
#
# @return A dictionary of the structure returned by the 
#         ::alt_xcvr_utils::common::parse_series10_style_register_map procedure.
#         Refer to that procedure for details
#         Returns -1 if an error occurs
proc ::alt_xcvr::utils::device::get_stratix10_regmap { {blocks {pma pcs fpll atx}} {device_revision NOVAL} } {
  set filenames [dict create]
  dict set filenames pma  [expr { $device_revision=="14nm5es2" ?     "PMA_RegMap_nf5es2.csv"    :     "PMA_RegMap.csv"}]
  dict set filenames pcs  [expr { $device_revision=="14nm5es2" ?     "PCS_RegMap_nf5es2.csv"    :     "PCS_RegMap.csv"}]
  dict set filenames fpll [expr { $device_revision=="14nm5es2" ?    "FPLL_RegMap_nf5es2.csv"    :    "FPLL_RegMap.csv"}]
  dict set filenames atx  [expr { $device_revision=="14nm5es2" ? "ATX_PLL_RegMap_nf5es2.csv"    : "ATX_PLL_RegMap.csv"}]
  
  set data [dict create]

  foreach block $blocks {
    if {![dict exists $filenames $block]} {
      return -1
    } else {
      set filename "[::alt_xcvr::utils::fileset::get_alt_xcvr_path]/alt_xcvr_core/nd/doc/[dict get $filenames $block]"
      set retval [::alt_xcvr::utils::common::parse_stratix10_style_register_map $filename]
      if {$retval == -1} {
        puts "Parsing register map $filename failed."
        return $retval
      } else {
        set data [dict merge $data $retval]
      }
    }
  }
#  puts $data
  return $data
}
