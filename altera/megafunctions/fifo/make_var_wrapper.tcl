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


#+---------------------------------------------------------------------------------------
#|
#| Name: make_var_wrapper
#|
#| Purpose: get ip parameters from hw.tcl file and transfer to terp params
#|
#| Return: ip specific vhd and verilog parameters array to pass to terp file
#|
#+----------------------------------------------------------------------------------------

proc make_var_wrapper {params_ref} {

    upvar $params_ref   params
    #----------------------------------------------------------------------------------
    # get module_name and lib_name #
    if {$params(clock)==0} {
        set module_name  "scfifo"
    } elseif {$params(diff_widths)} {
        set module_name  "dcfifo_mixed_widths"
    } else {
        set module_name  "dcfifo"
    }
    set lib_name "altera_mf"

    #---------------------------------------------------------------------------------
    # loop through port_list and add to list module_port_list(port direction width value(for vhdl only)) #
    set module_port_list    [list ]
    set data_width      [expr {$params(width)-1}]
    set q_width         [expr {$params(output_width)-1}]
    set usedw_width     [expr {$params(usedw_width) -1 }]
    set rdusedw_width   [expr {$params(rdusedw_width) -1 }]
    set wrusedw_width   [expr {$params(wrusedw_width) -1 }]

    foreach port $params(input_port_list) {
        lappend module_port_list $port 
        switch -exact -- $port {
            "data"     {
                lappend module_port_list    "IN"    $data_width -1
            }
            "aclr"      {
                if {$module_name eq "scfifo"} {
                    lappend module_port_list  "IN"  -1  -1
                } else {
                    lappend module_port_list    "IN"    -1  0
                }
            }
            default     {
                lappend module_port_list    "IN"    -1  -1
            }
        }
    }
    foreach port $params(output_port_list) {
        lappend module_port_list $port
        switch -exact -- $port {
            "q"     {
                if {$module_name eq "dcfifo_mixed_widths"} {
                    lappend module_port_list    "OUT"   $q_width -1
                } else {
                    lappend module_port_list    "OUT"   $data_width    -1
                }
            }
            "usedw" {
                lappend module_port_list    "OUT"   $usedw_width    -1
            }
            "rdusedw"   {
                lappend module_port_list    "OUT"   $rdusedw_width  -1
            }
            "wrusedw"   {
                lappend module_port_list    "OUT"   $wrusedw_width  -1
            }
            "eccstatus" {
                lappend module_port_list    "OUT"   1   -1
            }
            default {
                lappend module_port_list    "OUT"   -1  -1
            }
        }
    }
    #----------------------------------------------------------------------------------
    # add all output wire connectin to wire_list and sub_wire_list #
    set wire_list [list ]
    set sub_wire_list [list ]
    set wire_number 0
    foreach {port direction width num} $module_port_list {
        if {$direction eq "OUT"} {
            lappend sub_wire_list   "sub_wire$wire_number"  $width
            lappend wire_list   $port "sub_wire$wire_number" $width 0
            incr wire_number
        }
    }


    #----------------------------------------------------------------------------------
    set tri_port_list [list ]
    set port_map_list [list ]
    set port_map_not_list  [list ]
    set ports_not_added_list  [list ]
    set params_list   [list ]

    #-----------------------------------------------------------------------------------
    foreach port $params(input_port_list) {
        set port_map($port) 1
    }
    foreach port $params(output_port_list) {
        set port_map($port) 1
    }
    # tri_port_list #
    if {$module_name ne "scfifo"} {
        set range_list {"aclr" 0}
        foreach {port num } $range_list {
            if {[info exists port_map($port)]} {
                lappend tri_port_list $num $port -1
            }
        }
    }

    #-----------------------------------------------------------------------------------
    # total_ports_list  #
    if {$module_name eq "scfifo"} {
        set total_ports_list_in     {aclr clock data rdreq sclr wrreq}
        set total_ports_list_out    {almost_empty almost_full eccstatus empty full q usedw}
    } else {
        set total_ports_list_in     {aclr data rdclk rdreq wrclk wrreq}
        set total_ports_list_out    {eccstatus q rdempty rdfull rdusedw wrempty wrfull wrusedw}
    }
    set total_ports_list_in     [lsort -ascii $total_ports_list_in]
    set total_ports_list_out    [lsort -ascii $total_ports_list_out]
    # port_map_list (nameL nameR )#
    foreach port $total_ports_list_in {
        if {[info exists port_map($port)]} {
            lappend port_map_list   $port   $port
        } else {
            lappend port_map_not_list   $port
        }
    }
    set output_port_index   0
    foreach port $total_ports_list_out {
        if {[info exists port_map($port)]} {
            lappend port_map_list   $port   "sub_wire$output_port_index"
            incr    output_port_index
        } else {
            lappend port_map_not_list   $port
        }
    }
    set port_map_not_list   [lsort -ascii $port_map_not_list]
    foreach port $port_map_not_list {
        if {($port eq "aclr") && ($module_name eq "dcfifo_mixed_widths")} {
            lappend ports_not_added_list  $port "1'b0"
        } else {
            lappend ports_not_added_list  $port  ""
        }
    }

    #------------------------------------------------------------------------------------
    # params_list #
    if {($params(device_family) ne "MAX II") && ($params(device_family) ne "MAX V")} {
        if {$module_name ne "scfifo"} {
            if {$params(msb_usedw)} {      ;# add_usedw_msb_bit
                lappend params_list  "add_usedw_msb_bit" "STRING"
                lappend params_list  "\"ON\""
            }
        } else {
            lappend  params_list "add_ram_output_register"  "STRING"             ;# add_ram_output_register
            if {$params(optimize)==1} {
                lappend params_list "\"ON\""
            } else {
                lappend  params_list "\"OFF\""
            }
        }
    }
    if {$module_name eq "scfifo"} {
        if {$params(almostempty)} {
            lappend  params_list "almost_empty_value"  "NATURAL"  $params(almostemptythr)     ;#almost_full_value
        }
        if {$params(almostfull)} {
            lappend  params_list "almost_full_value" "NATURAL"  $params(almostfullthr)      ;#almost_empty_value
        }
    }
    if {($params(device_family) eq "MAX II") || ($params(device_family) eq "MAX V")} {
        if {$module_name ne "scfifo"} {
            lappend params_list "clocks_are_synchronized" "STRING"     ;#clocks_are_synchronized
            if {$params(clocks_are_synchronized)==1} {
                lappend params_list "\"TRUE\""
            } else {
                lappend params_list "\"FALSE\""
            }
        }
    } else {
        if {$module_name ne "scfifo"} {
            if {$params(le_basedfifo)} {
                lappend params_list "clocks_are_synchronized" "STRING"   "\"FALSE\""     ;#clocks_are_synchronized
            }
        }
    }
    
    lappend params_list "enable_ecc"  "STRING"     ;#enable_ecc
    if {$params(enable_ecc)}  {
        lappend  params_list "\"TRUE\"" 
    } else {
        lappend  params_list "\"FALSE\""
    }
    
    lappend  params_list "intended_device_family" "STRING"   \"$params(device_family)\"      ;#intended_device_family
    set block_type $params(ram_block_type)
    set max_depth   $params(max_depth)
    if {$params(max_depth_by_9)} {
        if {$block_type eq "MLAB"} {    ;# for MLAB
            set max_depth   64 
        } elseif {$block_type eq "M144K"} {     ;#for M144K
            set max_depth   65536
        } elseif {$block_type ne "Auto"} {  ;#for M9K/M10K/M20K
            set max_depth   512
        }
    }
    if {($params(device_family) ne "MAX II") && ($params(device_family) ne "MAX V")} {
      if {$params(disable_dcfifo_embedded_timing_constraint)}  {
        if {$module_name ne "scfifo"} {
            if {($max_depth ne "Auto") && ($block_type ne "Auto")} {            ;#lpm_hint
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type,MAXIMUM_DEPTH=$max_depth,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE\""
            } elseif {$max_depth ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"MAXIMUM_DEPTH=$max_depth,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE\""
            } elseif {$block_type ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE\""
            } elseif {($max_depth eq "Auto") && ($block_type eq "Auto")} {            ;#lpm_hint
                lappend  params_list "lpm_hint" "STRING" "\"DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE\""
            }
        } else {
            if {($max_depth ne "Auto") && ($block_type ne "Auto")} {            ;#lpm_hint
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type,MAXIMUM_DEPTH=$max_depth\""
            } elseif {$max_depth ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"MAXIMUM_DEPTH=$max_depth\""
            } elseif {$block_type ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type\""
            }     
        }
      } else {
        if {$module_name ne "scfifo"} {      
            if {($max_depth ne "Auto") && ($block_type ne "Auto")} {            ;#lpm_hint
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type,MAXIMUM_DEPTH=$max_depth,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE\""
            } elseif {$max_depth ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"MAXIMUM_DEPTH=$max_depth,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE\""
            } elseif {$block_type ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE\""
            } elseif {($max_depth eq "Auto") && ($block_type eq "Auto")} {            ;#lpm_hint
                lappend  params_list "lpm_hint" "STRING" "\"DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE\""
            }     
        } else {
            if {($max_depth ne "Auto") && ($block_type ne "Auto")} {            ;#lpm_hint
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type,MAXIMUM_DEPTH=$max_depth\""
            } elseif {$max_depth ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"MAXIMUM_DEPTH=$max_depth\""
            } elseif {$block_type ne "Auto"} {
                lappend  params_list "lpm_hint" "STRING" "\"RAM_BLOCK_TYPE=$block_type\""
            }  
          }
      }     
    } else {
        if {($module_name  eq "scfifo") &&($params(optimize_max)==1)} {
            lappend params_list "lpm_hint" "STRING" "\"MAXIMIZE_SPEED=7\""
        } elseif {$params(optimize_max)==2} {
            lappend params_list "lpm_hint" "STRING" "\"MAXIMIZE_SPEED=5\""
        }
    }

    lappend params_list "lpm_numwords"  "NATURAL"   $params(depth)      ;#lpm_numwords
    lappend params_list "lpm_showahead" "STRING"                     ;#lpm_showahead
    if {$params(legacyrreq)==0} {
        lappend  params_list "\"ON\""
    } else {
        lappend  params_list "\"OFF\""
    }
    lappend params_list "lpm_type" "STRING"     "\"$module_name\""        ;#lpm_type
    lappend params_list "lpm_width" "NATURAL"     $params(width)      ;#lpm_width
    lappend params_list "lpm_widthu" "NATURAL"                        ;#lpm_widthu
    if {$module_name eq "scfifo"}  {  
        lappend params_list  $params(usedw_width)
    } else {
        lappend  params_list $params(wrusedw_width)
    }
    if {$module_name eq "dcfifo_mixed_widths"} {
        lappend params_list "lpm_widthu_r" "NATURAL"      $params(rdusedw_width)  ;#lpm_widthu_r
        lappend params_list "lpm_width_r"  "NATURAL"      $params(output_width)   ;#lpm_width_r
    }
    lappend params_list "overflow_checking"  "STRING"     ;#overflow_checking
    if {$params(overflow_checking)}  {
        lappend  params_list "\"OFF\"" 
    } else {
        lappend  params_list "\"ON\""
    }
    if {($params(device_family) ne "MAX II") && ($params(device_family) ne "MAX V")} {
        if {$module_name ne "scfifo"} {
            lappend params_list "rdsync_delaypipe" "NATURAL"      ;#rdsyn_delaypipe
            if {$params(delaypipe)!=5} {
                lappend params_list $params(delaypipe)
            } else {
                lappend params_list [expr {$params(synstage)+2}]
            }
            if {$params(dc_aclr)} {
                lappend params_list "read_aclr_synch" "STRING"        ;# read_aclr_synch
                if {$params(read_aclr_synch)}  {
                    lappend params_list "\"ON\""
                } else {
                    lappend params_list "\"OFF\""
                }
            }
        }
    }
    lappend  params_list "underflow_checking" "STRING"       ;#underflow_checking
    if {$params(underflow_checking)} {
        lappend params_list "\"OFF\"" 
    } else {
        lappend params_list "\"ON\""
    }
    lappend params_list "use_eab" "STRING"            ;#use_eab
    if {$params(le_basedfifo)}    {
        lappend params_list "\"OFF\""
    } else {
        lappend params_list  "\"ON\""
    }
    if {($params(device_family) ne "MAX II") && ($params(device_family) ne "MAX V")} {
        if {$module_name ne "scfifo"} {
            if {$params(dc_aclr)} {
                lappend params_list "write_aclr_synch" "STRING"      ;#write_aclr_synch
                if {$params(write_aclr_synch)}  {
                    lappend params_list "\"ON\""
                } else {
                    lappend params_list "\"OFF\""
                }
            }
            lappend params_list "wrsync_delaypipe" "NATURAL"   ;#wrsynch_delaypipe
            if {$params(delaypipe)!=5} {
                lappend params_list $params(delaypipe)
            } else {
                lappend params_list [expr {$params(synstage)+2}]
            }
        }
    }



    #---------------------------------------------------------------------------------------
    # add all terp params to array params_terp #
    set params_terp(module_port_list)   $module_port_list
    set params_terp(sub_wire_list)      $sub_wire_list
    set params_terp(wire_list)          $wire_list
    set params_terp(port_map_list)      $port_map_list
    set params_terp(ports_not_added_list)   $ports_not_added_list
    set params_terp(tri_port_list)      $tri_port_list
    set params_terp(params_list)        $params_list
    set params_terp(module_name)        $module_name
    set params_terp(lib_name)           $lib_name
    return [array get params_terp]
}


