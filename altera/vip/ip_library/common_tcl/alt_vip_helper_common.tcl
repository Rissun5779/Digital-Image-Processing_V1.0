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


package require -exact qsys 16.1

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information shared by all VIP cores and components                                   --
# -- the NAME, DISPLAY_NAME and DESCRIPTION module properties have to be declared independently   --
# -- by each component                                                                            --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# Global Video IP constants
set vib_vob_removal    0
set enable_8k_support  1
set vipsuite_version   VIPSUITE_STANDARD

if { "0" == 0 } {
    set acdsVersion  18.1
    set isVersion    18.1
    set internalComponents true
} else {
    set acdsVersion  17.1
    set isVersion    99.0
    set internalComponents false
}

if {$enable_8k_support} {
    set vipsuite_max_width 8192
    set vipsuite_max_height 8192
    set vipsuite_max_pip 8
    set vipsuite_allowed_pip_ranges {1 2 4 8}
} else {
    set vipsuite_max_width 4096
    set vipsuite_max_height 2560
    set vipsuite_max_pip 4
    set vipsuite_allowed_pip_ranges {1 2 4}
}


proc declare_general_module_info {{released 1}} {
    global isVersion

    set_module_property     GROUP                            [expr {$released ? "DSP/Video and Image Processing" : "DSP/Video and Image Processing/Non-released"}]
    set_module_property     VERSION                          [expr {$released ? $isVersion : 0.1}]
    set_module_property     AUTHOR                           "Intel Corporation"
    set_module_property     HIDE_FROM_QUARTUS                true
    set_module_property     SUPPORTED_DEVICE_FAMILIES        {{Cyclone IV E} {Cyclone IV GX} {Cyclone V} {Cyclone 10 LP} {Cyclone 10 GX} {Arria II GX} {Arria II GZ} {Arria V} {Arria V GZ} {Arria 10} {MAX 10} {Stratix IV} {Stratix V}}
    if {$released} {
        add_documentation_link  "User Guide"                     https://documentation.altera.com/#/link/bhc1411020596507/bhc1411019828278
        add_documentation_link  "Release Notes"                  https://documentation.altera.com/#/link/hco1421698042087/hco1421697985505/en-us
    }
}

proc declare_general_component_info {{released 1}} {
    global isVersion internalComponents

    set_module_property     GROUP                            [expr {$released ? "DSP/Video and Image Processing/Component Library" :  "DSP/Video and Image Processing/Non-released/Component Library"}]
    set_module_property     VERSION                          [expr {$released ? $isVersion : 0.1}]
    set_module_property     AUTHOR                           "Intel Corporation"
    set_module_property     INTERNAL                         $internalComponents
    set_module_property     HIDE_FROM_QUARTUS                true
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General helper functions                                                                     --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# clogb2_pure: ceil(log2(x))
# ceil(log2(4)) = 2 wires are required to address a memory of depth 4
proc clogb2_pure {max_value} {
   set l2 [expr int(ceil(log($max_value)/(log(2))))]
   if { $l2 == 0 } {
      set l2 1
   }
   return $l2
}

# clogb2: ceil(log2(x+1))
# ceil(log2(4)) = 3 wires are required to represent the number 4 in binary format
proc clogb2 {max_value} {
    set l2g [clogb2_pure [expr $max_value+1]]
    return $l2g
}

# power: num**p
proc power {num p} {
    set result 1
    while {$p > 0} {
        set result [expr $result * $num]
        set p [expr $p - 1]
    }
    return $result
}

# min(a,b) function
proc min {in_1 in_2} {
    if { $in_1 < $in_2 } {
        set temp $in_1
    } else {
        set temp $in_2
    }
    return $temp
}

# max(a,b) function
proc max {in_1 in_2} {
    if { $in_1 > $in_2 } {
        set temp $in_1
    } else {
        set temp $in_2
    }
    return $temp
}
