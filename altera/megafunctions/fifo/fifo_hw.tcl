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


package require -exact qsys 14.0
package require altera_terp


#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "csv_ui_loader.tcl"
source "make_var_wrapper.tcl"

#+--------------------------------------------
#|
#|  Module Property
#|
#+--------------------------------------------
set_module_property     NAME                    "fifo"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "FIFO"
set_module_property     EDITABLE                false
set_module_property     ELABORATION_CALLBACK    elab
set_module_property     GROUP                   "Basic Functions/On Chip Memory"
add_documentation_link  "Data Sheet"            http://www.altera.com/literature/ug/ug_fifo.pdf

set supported_device_families_list      {"Arria 10" "Stratix 10"}
set_module_property     SUPPORTED_DEVICE_FAMILIES   $supported_device_families_list
set_module_property   	HIDE_FROM_QSYS true

#+--------------------------------------------
#|
#|  Load the ui from CSV files
#|
#+--------------------------------------------
load_parameters "parameters.csv"
load_layout     "layout.csv"


#+--------------------------------------------
#|
#|  Elaboration callback
#|
#+--------------------------------------------
proc  elab  {}  {

    ##device information#
    set device_family   [get_parameter_value   DEVICE_FAMILY]
    send_message    COMPONENT_INFO        "Targeting device family: $device_family."

    #add input and output interface#
    add_interface   fifo_input   conduit     input
    add_interface   fifo_output  conduit     output
    set_interface_assignment    fifo_input   ui.blockdiagram.direction   input
    set_interface_assignment    fifo_output  ui.blockdiagram.direction   output

    # get all parameter values#
    set params_list      [get_parameters]
    foreach param  $params_list {
        set param_temp  [string tolower $param]
        set $param_temp [get_parameter_value  $param]
    }

    # check data width#
    set width_params_list {GUI_Width GUI_output_width}
    foreach param $width_params_list {
        set param_value     [get_parameter_value  $param]
        set param_lower     [string tolower $param]
        if {$param_value <=0} {
            set $param_lower  1
        }
    }

    # param list for SCFIFO, DCFIFO1, DCFIFO2 #
    set params_scfifo_list   {GUI_Full GUI_Empty GUI_Usedw GUI_AlmostFull GUI_AlmostFullThr GUI_AlmostEmpty GUI_AlmostEmptyThr GUI_sc_aclr GUI_sc_sclr}
    set params_dcfifo1_list  {GUI_delaypipe GUI_synStage GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT}
    set params_dcfifo2_list  {GUI_rsFull GUI_rsEmpty GUI_rsUsedw GUI_wsFull GUI_wsEmpty GUI_wsUsedw GUI_msb_usedw GUI_dc_aclr GUI_write_aclr_synch GUI_read_aclr_synch}
    
    ############################################# SCFIFO/DCFIFO GENERAL GUI RULE #####################################################
    if {$gui_clock ==0} {   ;# SCFIFO
        #  usedw port width #
        set usedw_width  [expr {int(ceil(log($gui_depth)/log(2)))}]
        # use different width for output unavailable #
        foreach param {GUI_diff_widths GUI_output_width} {
            set_parameter_property  $param  VISIBLE  FALSE
        }
        # tab: SCFIFO available#
        foreach param $params_scfifo_list {
            set_parameter_property  $param  ENABLED     true
        }
        # tab: DCFIFO1 unavailable #
        foreach param $params_dcfifo1_list {
            set_parameter_property  $param  ENABLED     false 
        }
        send_message    component_info  "Tab: \'DCFIFO 1\' is unavailable while using Single-Clock FIFO."
        # tab: DCFIFO2 unavailable#
        foreach param $params_dcfifo2_list {
            set_parameter_property  $param  ENABLED     false
        }
        send_message    component_info  "Tab: \'DCFIFO 2\' is unavailable while using Single-Clock FIFO."
        # almost full thr available when almost full checked #
        if {$gui_almostfull}    {
            set_parameter_property  GUI_AlmostFullThr   ENABLED TRUE
            # almost full depth range #
            if {$gui_almostfullthr <0 } {
                send_message    error   "Invalid almost full threshold value, must be greater than or equal to 0."
            } elseif {$gui_almostfullthr > $gui_depth} {
                send_message    error   "\'almost_full\' threshold value cannot exceed the FIFO depth ($gui_depth)."
            }
        } else {
            set_parameter_property  GUI_AlmostFullThr   ENABLED FALSE
        }
        # almost empty thr available when almost empty checked #
        if {$gui_almostempty} {
            set_parameter_property  GUI_AlmostEmptyThr     ENABLED TRUE
            # almost empty depth range #
            if {$gui_almostemptythr > $gui_depth} {
                send_message    error   "\'almost_empty\' threshold value cannot exceed the FIFO depth ($gui_depth)."
            } elseif {$gui_almostemptythr <0} {
                send_message    error  "Invalid almost empty threshold value, must be greater than or equal to 0."
            }
        } else {
            set_parameter_property  GUI_AlmostEmptyThr     ENABLED FALSE
        }
    } else {                ;# DCFIFO
        # use different width for output available #
        foreach param {GUI_diff_widths GUI_output_width} {
            set_parameter_property  $param  VISIBLE  TRUE
        }
        if {$gui_diff_widths} { ;# use different width
            set_parameter_property  GUI_output_width    ENABLED TRUE
            if {$gui_width != $gui_output_width} {
                if {$gui_output_width > $gui_width} {
                    set large_width $gui_output_width
                    set small_width $gui_width
                } else {
                    set large_width $gui_width
                    set small_width $gui_output_width
               }
              
              set valid_ratio [expr $large_width/$small_width]   
              set valid_ratio_r [expr $large_width % $small_width]
              set ratio_a10 {1 2 4 8 16 32} 
              set ratio_s10 {1 2 4} 
              
              if {[check_device_family_equivalence $device_family {"Arria 10"}]} {
                  if {!(($valid_ratio in $ratio_a10) && ($valid_ratio_r ==0))} {
                    send_message	error	"The valid width ratio for mixed width dcfifo are $ratio_a10 when device family is set to $device_family."
                  } 
              }
              if {[check_device_family_equivalence $device_family {"Stratix 10"}]} {
                  if {!(($valid_ratio in $ratio_s10) && ($valid_ratio_r ==0))} {
                    send_message	error	"The valid width ratio for mixed width dcfifo are $ratio_s10 when device family is set to $device_family."
                  } 
              }
          }         
            #  wrusedw and rdusedw port width #
            set wrusedw_width   [expr {int(ceil(log($gui_depth)/log(2)))}]
            set width        [expr {double($gui_depth)*$gui_width/$gui_output_width}]
            set rdusedw_width  [expr {int(ceil(log($width)/log(2)))}]
        } else {        ;# use same output width as input width
            set_parameter_property  GUI_output_width    ENABLED FALSE
            # wrusedw and rdusedw port width
            set wrusedw_width   [expr {int(ceil(log($gui_depth)/log(2)))}]
            set rdusedw_width   $wrusedw_width
        }
        # tab: SCFIFO unavailable#
        foreach param $params_scfifo_list {
            set_parameter_property  $param  ENABLED     false
        }
        send_message    component_info  "Tab: \'SCFIFO Options\' is unavailable while using Dual-Clock FIFO."
        # tab: DCFIFO1 available #
        foreach param $params_dcfifo1_list {
            set_parameter_property  $param  ENABLED     true
        }
        # tab: DCFIFO2 available #
        foreach param $params_dcfifo2_list {
            set_parameter_property  $param  ENABLED     true
        }
        # more sync stages when delaypipe ==5 #
        if {$gui_delaypipe==5} {
            set_parameter_property  GUI_synStage    ENABLED     TRUE
        } else {
            set_parameter_property  GUI_synStage    ENABLED     FALSE
        }
    }

    ##################################### RAM BLOCK TYPE ######################################################################
    #set maximum block depth range list#
    set auto_depth_range_8192  {Auto 32 64 128 256 512 1024 2048 4096 8192}
    set auto_depth_range_128_8192  {Auto 128 256 512 1024 2048 4096 8192}
    set auto_depth_range_16384  "$auto_depth_range_8192 16384"
    set auto_depth_range_128_16384 "$auto_depth_range_128_8192 16384"
    set auto_depth_range_131072 "$auto_depth_range_16384 32768 65536 131072"
    set auto_depth_range_128_131072 "$auto_depth_range_128_16384 32768 65536 131072"
    set mlab_depth_range    {Auto 32 64}
    set m9k_depth_range     {Auto 128 256 512 1024 2048 4096 8192}
    set m10k_depth_range    {Auto 128 256 512 1024 2048 4096 8192}
    set m20k_depth_range    {Auto 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072}
    set m144k_depth_range   {Auto 4096 8192 16384 32768 65536 131072}
    set fifo_depth_range    {4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072}
    set fifo_depth_range_max  {4 8 16 32 64 128 256 512 1024 2048}

    #memory block type available for each device familiy#
    set pre_28nm_device_family_list  {"Arria II GX" "Arria II GZ" "Cyclone IV E" "Cyclone IV GX" "Stratix IV" "MAX 10 FPGA"}
    if {[check_device_family_equivalence $device_family $pre_28nm_device_family_list]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "MLAB" "M9K" "M144K"}
        # device families  'Cyclone IV E' 'Cyclone IV GX' 'MAX 10 FPGA'#
        if {[check_device_family_equivalence $device_family { "Cyclone IV E" "Cyclone IV GX" "MAX 10 FPGA"}]} {
            if {$gui_ram_block_type eq "M144K"} {
                send_message    error   "Option of M144K memory block type is unavailable for device family $device_family."
            } elseif {$gui_ram_block_type eq "Auto"} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_128_8192
            } elseif {$gui_ram_block_type eq "MLAB"} {
                send_message    error   "\'MLAB\' ram block type is unavailable for device family $device_family."
            }
        # device families "Arria II GZ" "Stratix IV" #
        } elseif {[check_device_family_equivalence $device_family {"Arria II GZ" "Stratix IV"}]} {
            if {$gui_ram_block_type eq "Auto"} {
                if {($gui_clock!= 0) && ($gui_diff_widths) && ($gui_width != $gui_output_width)} {
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_128_131072
                } else {
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_131072
                }
            }
        # device families "Arria II GX"
        } else {
            if {$gui_ram_block_type eq "M144K"} {
                send_message    error   "Option of M144K memory block type is unavailable for device family $device_family."
            } elseif {$gui_ram_block_type eq "Auto"} {
                if {($gui_clock!= 0) && ($gui_diff_widths) && ($gui_width != $gui_output_width)} {
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_128_8192
                } else {
                    set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192
                }
            }
        }
    # for device families "Arria V" Cyclone V" #
    } elseif {[check_device_family_equivalence $device_family {"Arria V" "Cyclone V"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES  {"Auto" "MLAB" "M10K" "M144K"}
        if {$gui_ram_block_type eq "M144K"} {
            send_message    error   "Option of M144K memory block type is unavailable for device family $device_family."
        } elseif {$gui_ram_block_type eq "Auto"} {
            if {($gui_clock!= 0) && ($gui_diff_widths) && ($gui_width != $gui_output_width)} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_128_8192
            } else {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_8192
            }
        }
    # for device families "Stratix V" 'Arria V GZ"#
    } elseif {[check_device_family_equivalence $device_family  {"Stratix V" "Arria V GZ" "Arria 10" "Stratix 10"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "MLAB" "M20K" "M144K"}
        if {$gui_ram_block_type eq "M144K"} {
            send_message    error   "Option of M144K memory block type is unavailable for device family $device_family."
        } elseif {$gui_ram_block_type eq "Auto"} {
            if {($gui_clock!= 0) && ($gui_diff_widths) && ($gui_width != $gui_output_width)} {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_128_131072
            } else {
                set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $auto_depth_range_131072
            }
        }
    }
    # for device families "MAX II" "MAX V" #
    if {[check_device_family_equivalence $device_family {"MAX II" "MAX V"}]} {
        set_parameter_property  GUI_RAM_BLOCK_TYPE  ALLOWED_RANGES {"Auto" "M512" "M4K" "M-RAM"}
        if {$gui_ram_block_type ne "Auto"} {
            send_message    error   "$gui_ram_block_type ram block type is unavailable for $device_family device family."
        }
        set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  {256}
        # parameters clock_syn/ optimize_max visible #
        set max_params  {GUI_CLOCKS_ARE_SYNCHRONIZED GUI_Optimize_max}
        foreach param $max_params {
            set_parameter_property  $param  VISIBLE TRUE
        }
        if {$gui_clock==4} {   ;# DCFIFO #
            set_parameter_property  GUI_CLOCKS_ARE_SYNCHRONIZED ENABLED TRUE
            set_parameter_property  GUI_Optimize_max  ENABLED   FALSE
            send_message    component_info  "Optimization is unavailable while using Dual-Clock FIFO."
            if {$gui_diff_widths} {
                send_message    error   "Use different width for output is unavailable for $device_family device family."
            }
            # tab: DCFIFO1 unavailable #
            foreach param $params_dcfifo1_list {
                set_parameter_property  $param  ENABLED     false
            }
            send_message    component_info  "Tab: \'DCFIFO 1\' is unavailable for $device_family device family."
            # msb unavailable #
            if {$gui_msb_usedw} {
                send_message    error   "\'Add an extra MSB to usedw port\' is unavailable while using $device_family device family."
            }
            # write_aclr_synch read_aclr_synch unavailable #
            if {$gui_write_aclr_synch} {
                send_message    error   "Can't synchronize \'aclr\' with \'wrclk\' for $device_family device family."
            }
            if {$gui_read_aclr_synch} {
                send_message    error   "Can't synchronize \'aclr\' with \'rdclk\' for $device_family device family."
            }
        } else {    ;# SCFIFO #
            set_parameter_property  GUI_CLOCKS_ARE_SYNCHRONIZED ENABLED FALSE
            set_parameter_property  GUI_Optimize_max  ENABLED   TRUE
            send_message    component_info  "Synchronize clocks is unavailable while using Single-Clock FIFO."
        }
        # implement fifo with logic cells true #
        if {!$gui_le_basedfifo}  {
            send_message    error   "\'Implement FIFO storage with logic cells\' option should be checked for $device_family device family."
        }
        # parameter optimize unvisible #
        set_parameter_property  GUI_Optimize VISIBLE FALSE
        # fifo depth #
        set_parameter_property  GUI_Depth   ALLOWED_RANGES  $fifo_depth_range_max
    } else {    ;# device family not 'MAX II' 'MAX V' #
        # parameters clock_syn/ optimize_max UNvisible #
        foreach param {GUI_CLOCKS_ARE_SYNCHRONIZED GUI_Optimize_max} {
            set_parameter_property  $param  VISIBLE  FALSE
        }
        # implement fifo with logic cells unavailable #
        if {$gui_le_basedfifo } {       ;# conditions while le_basedfifo unavailable
            if {$gui_depth >2048}  {
                send_message    error   "\'Implement FIFO storage with logic cells\' option is unavailable while FIFO depth larger than 2048."
            } elseif {$gui_clock==4 && $gui_msb_usedw} {
                send_message    error   "\'Implement FIFO storage with logic cells\' option is unavailable while extra MSB added to the usedw ports."
            }
        }
        # parameter optimize visible #
        set_parameter_property  GUI_Optimize VISIBLE TRUE
        if {$gui_clock==4} {   ;# DCFIFO #
            # output register unavailable #
            set_parameter_property  GUI_Optimize  ENABLED   false
            send_message    component_info  "\'Output register option\' is unavailable while using Dual-Clock FIFO."
            # add msb unavailable when usedw not checked #
            if {!$gui_rsusedw && !$gui_wsusedw} {
                if {$gui_msb_usedw} {
                    send_message    error   "\'Add an extra MSB to usedw port\' is unavailable while \'usedw\[\]\' control signal not added."
                }
            } elseif {$gui_msb_usedw} {
                incr wrusedw_width
                incr rdusedw_width
            }
            # aclr with wrclk or rdclk unavailable when aclr not checked #
            if {!$gui_dc_aclr} {
                if {$gui_write_aclr_synch} {
                    send_message    error   "Can't synchronize \'aclr\' with \'wrclk\' while \'aclr\' port not added."
                }
                if {$gui_read_aclr_synch} {
                    send_message    error   "Can't synchronize \'aclr\' with \'rdclk\' while \'aclr\' port not added."
                }
            }
        } else {    ;# SCFIFO #
            # output register available #
            set_parameter_property  GUI_Optimize  ENABLED   TRUE
        }
        # fifo depth #
        set_parameter_property  GUI_Depth   ALLOWED_RANGES  $fifo_depth_range
    }
    set divide_by_9     [expr  {$gui_width % 9}]
    if {$divide_by_9!=0} {
        if {$gui_max_depth_by_9} {
            send_message    error   "\'Reduce RAM usage\' is unavailable while data width is not divisible by 9."
        }
    }

        # parameter disable_dcfifo_embedded_timing_constraint #

        if {$gui_clock!=4} {   ;# SCFIFO #
            # disable_dcfifo_embedded_timing_constraint unavailable #
            set_parameter_property  GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT VISIBLE TRUE
            set_parameter_property  GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT  ENABLED   FALSE
         
        } else {    ;# DCFIFO #
            # disable_dcfifo_embedded_timing_constraint available #
            set_parameter_property GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT  ENABLED   TRUE
        }
       # set_parameter_property  GUI_DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT VISIBLE TRUE
       if {$gui_clock==4} {
            if {$gui_disable_dcfifo_embedded_timing_constraint==true} {
                send_message    component_info  "SDC file will be generated to apply correct constraints. User may experience increase in fitter compilation time"
                send_message    component_info  "Embedded set_false_path assignment is disabled."
            } else {
                send_message    component_info  "Embedded set_false_path assignment is enabled. User may experience hardware failure with high frequency design"
            }
        }

    ############################################# RAM BLOCK TYPE ##############################################################
    if {$gui_ram_block_type eq "MLAB"} {        ;# ram_block_type MLAB #
        set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $mlab_depth_range
        if {$gui_clock==0} {
            #output register should be checked #
            if {$gui_optimize==0  && $gui_legacyrreq==1} {
                send_message    error   "Output should be registered while using \'MLAB\' ram block type."
            }
        } elseif {$gui_diff_widths} {
            # MLAB unavailable when output_width != width #
            if {$gui_width != $gui_output_width} {
                send_message    error   "\"MLAB\" ram block type is unavailable while output data width not equal to input data width."
            }            
        }
        # max_depth_by_9 #
        if {$divide_by_9 ==0} {
            if {$gui_depth <=64 && $gui_max_depth_by_9} {
                send_message    error   "\'Reduce RAM usage\' is unavailable while FIFO depth is not larger than 64."
            }
        }

    } elseif {$gui_ram_block_type eq "M9K"} {   ;# ram_block_type M9K #
        set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m9k_depth_range
        # max_depth_by_9 #
        if {$divide_by_9 ==0} {
            if {$gui_depth <=512 && $gui_max_depth_by_9} {
                send_message    error   "\'Reduce RAM usage\' is unavailable while FIFO depth is not larger than 512."
            }
        }
    } elseif {$gui_ram_block_type eq "M10K"} {  ;# ram_block_type M10K #
        set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m10k_depth_range
        # max_depth_by_9 #
        if {$divide_by_9 ==0} {
            if {$gui_depth <=512 && $gui_max_depth_by_9} {
                send_message    error   "\'Reduce RAM usage\' is unavailable while FIFO depth is not larger than 512."
            }
        }
    } elseif {$gui_ram_block_type eq "M20K"} {  ;# ram_block_type M20K #
        set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m20k_depth_range
        # max_depth_by_9 #
        if {$divide_by_9 ==0} {
            if {$gui_depth <=512 && $gui_max_depth_by_9} {
                send_message    error   "\'Reduce RAM usage\' is unavailable while FIFO depth is not larger than 512."
            }
        }
    } elseif {$gui_ram_block_type eq "M144K"} { ;# ram_block_type M144K #
        set_parameter_property  GUI_MAX_DEPTH ALLOWED_RANGES  $m144k_depth_range
        # max_depth_by_9 #
        if {$divide_by_9 ==0} {
            if {$gui_depth <=65536 && $gui_max_depth_by_9} {
                send_message    error   "\'Reduce RAM usage\' is unavailable while FIFO depth is not larger than 65536."
            }
        }
    } elseif {$gui_ram_block_type eq "Auto"} {
        if {$divide_by_9==0} {
            if {$gui_max_depth_by_9} {
                send_message    error   "\'Reduce RAM usage\' is unavailable while using \'Auto\' ram block type."
            }
        }
    }

    ############################################# ECC Features ##############################################################

    if {$gui_enable_ecc eq "true"} {        
        set_parameter_property  GUI_ENABLE_ECC  ENABLED TRUE

        #Does not support different width#
        if {$gui_diff_widths eq "true"} {
            send_message    error   "ECC check is unavailable while using mixed width fifo."
        }
        # Width must be 32 bit FB:317073
        #if {$gui_width != 32} {
        #    send_message    error   "ECC check is only available while port width equals to 32 bits."
        #}
        # RAM block must be M20K
        if {$gui_ram_block_type ne "M20K"} {
            send_message    error   "ECC check is only available for M20K ram block."
        }  
        # ECC supported A10 onwards
        if {![check_device_family_equivalence $device_family {"Arria 10" "Stratix 10"}]} {
        send_message    error   "ECC feature is unavailable for device family $device_family."
        }
    }      

    ########################################## STATIC PORTS ####################################################################
    #add static ports: SC (data, wrreq, rdreq, clock, q)  DC (data, wrreq, rdreq, wrclk, rdclk, q)#
    add_interface_port  fifo_input  data    datain      input   $gui_width
    add_interface_port  fifo_input  wrreq   wrreq       input   1
    add_interface_port  fifo_input  rdreq   rdreq       input   1
    if {$gui_clock}   {       ;# DCFIFO#
		if {$gui_diff_widths} {
		add_interface_port  fifo_output q       dataout     output  $gui_output_width
        add_interface_port  fifo_input  wrclk   wrclk       input   1
        add_interface_port  fifo_input  rdclk   rdclk       input   1
		} else {
		add_interface_port  fifo_output q       dataout     output  $gui_width
        add_interface_port  fifo_input  wrclk   wrclk       input   1
        add_interface_port  fifo_input  rdclk   rdclk       input   1
		}
    } else {                    ;# SCFIFO #
        add_interface_port  fifo_output q       dataout     output  $gui_width
        add_interface_port  fifo_input  clock   clk         input   1
    }
    ######################################## DYNAMIC PORTS ######################################################################
    # add dynamic ports: SC(full,empty,usedw,almost_full,almost_empty,aclr,sclr) DC(rdfull, rdempty, rdusedw, wrfull, wrempty, wrusedw,aclr)#
    if {$gui_clock==0} {    ;# SCFIFO #
        set param_port_width_list_out {
            gui_full full   1 
            gui_empty empty 1
            gui_almostfull almost_full 1
            gui_almostempty almost_empty 1
        }
        set param_port_width_list_in {
            gui_sc_aclr aclr 1
            gui_sc_sclr sclr 1
        }
        if {$gui_usedw} {
            add_interface_port  fifo_output usedw  usedw output  $usedw_width
        }
    } else {        ;# DCFIFO #
        set param_port_width_list_out {
            gui_rsfull  rdfull 1
            gui_rsempty rdempty 1
            gui_wsfull  wrfull  1
            gui_wsempty wrempty 1
        }
        set param_port_width_list_in  {
            gui_dc_aclr  aclr   1
        }
        if {$gui_rsusedw} {
            add_interface_port  fifo_output  rdusedw rdusedw  output $rdusedw_width
        }
        if {$gui_wsusedw} {
            add_interface_port  fifo_output  wrusedw wrusedw  output  $wrusedw_width
        }
    }
    if {$gui_enable_ecc} {
        add_interface_port  fifo_output eccstatus eccstatus output 2
    }
    
    foreach {param port width} $param_port_width_list_out {
        if {[set $param]} {
            add_interface_port  fifo_output $port  $port output $width
        }
    }
    foreach {param port width} $param_port_width_list_in  {
        if {[set $param]} {
            add_interface_port  fifo_input  $port  $port input  $width
        }
    }
    
    ################################################# SET DERIVED PARAMETER ####################################################################
    if {$gui_clock ==0 } {
        set_parameter_value     GUI_Usedw_width $usedw_width
    } else {
        set_parameter_value     GUI_RdUsedw_width   $rdusedw_width
        set_parameter_value     GUI_WrUsedw_width   $wrusedw_width
    }
    
}


#+--------------------------------------------
#|
#|  Do Quartus Synth
#|
#+--------------------------------------------
add_fileset quartus_synth   QUARTUS_SYNTH   do_quartus_synth
add_fileset verilog_sim     SIM_VERILOG     do_quartus_synth

proc do_quartus_synth {output_name} {

    set file_name ${output_name}.v

    set terp_path params_to_v.v.terp

    set file_sdc_name ${output_name}.sdc
    
    set gui_clock [get_parameter_value gui_clock]
    
    set gui_diff_widths [get_parameter_value gui_diff_widths]

    set gui_disable_dcfifo_embedded_timing_constraint [get_parameter_value gui_disable_dcfifo_embedded_timing_constraint]

    set contents [params_to_wrapper_data $terp_path $output_name]

    add_fileset_file $file_name VERILOG TEXT $contents

    if { ($gui_clock!=0) & ($gui_disable_dcfifo_embedded_timing_constraint==true)} {

    set pre_out [create_temp_file dcfifo_out.sdc]
    if { ($gui_diff_widths == true) } {   
            set pre_in "dcfifo_mixed_widths.sdc" 
       } else {
            set pre_in "dcfifo.sdc"
    }
     
    set out [open $pre_out w]
    set in [open $pre_in r]
    
    while {[gets $in line] != -1} {
    if {[string match "REPLACE" $line]} {
        if { ($gui_diff_widths == true) } { 
            puts $out "apply_sdc_pre_mw_dcfifo ${output_name}"  
        } else {
             puts $out "apply_sdc_pre_dcfifo ${output_name}" 
        }
    } else {
        puts $out $line
        }   
    }
    close $in
    close $out
    add_fileset_file $file_sdc_name SDC PATH $pre_out

    }

}


#+--------------------------------------------
#|
#|  Do VHDL Simulation
#|
#+--------------------------------------------
add_fileset vhdl_sim SIM_VHDL do_vhdl_sim

proc do_vhdl_sim {output_name} {

    set file_name ${output_name}.vhd

    set terp_path params_to_vhd.vhd.terp

    set contents [params_to_wrapper_data $terp_path $output_name]

    add_fileset_file $file_name VHDL TEXT $contents
}

#+-------------------------------------------------------------------------------------------------------------------------
#|
#|  Procedure: params_to_wrapper_data
#|
#|  Purpose: get hw.tcl params into an array and pass to procedure make_var_wrapper
#|
#+-------------------------------------------------------------------------------------------------------------------------

proc    params_to_wrapper_data  {terp_path output_name}  {
 
        # get hw.tcl ip parameters #
        set param_list      [get_parameters]
        foreach param  $param_list  {
            if {$param eq "DEVICE_FAMILY"} {
                set param_lower     "device_family"
            } else {
                set param_lower     [string range [string tolower $param] 4 end]
            }
            set params($param_lower)    [get_parameter_value    $param]
        }

        set ports_list_input    [lsort -ascii [get_interface_ports fifo_input]]
        set ports_list_output   [lsort -ascii [get_interface_ports fifo_output]]
        set params(input_port_list)     $ports_list_input
        set params(output_port_list)    $ports_list_output

        set terp_fd     [open $terp_path]
        set terp_contents [read $terp_fd]
        close  $terp_fd

        array set params_terp   [make_var_wrapper params]
        set params_terp(output_name)    $output_name

        set contents            [altera_terp    $terp_contents  params_terp]
        return $contents
}


## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_fifo.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
