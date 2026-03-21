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


# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# (C) 2001-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


#
# altera_uflex_ilk
#
#======================================

#======================================
#
# request TCL package from ACDS 14.0
#
package require -exact qsys 14.1
package require altera_terp 1.0
#
#======================================

#======================================
#
# module altera_uflex_ilk


send_message PROGRESS "Reading TCL"

set_module_property NAME "altera_uflex_ilk_barebone"
set_module_property VERSION 18.1
set_module_property INTERNAL false
set_module_property DISPLAY_NAME "Ultra Flexible Interlaken Core"
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property GROUP "Interface Protocols/Interlaken"
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Altera Ultra Flexible Interlaken Core"
set_module_property supported_device_families {{Stratix V} {Arria 10}}
set_module_property HIDE_FROM_QSYS true
set_module_property HIDE_FROM_QUARTUS true
set_module_property INTERNAL true

#===========================================================
# Add fileset for synthesis
#=========================================================== 

add_fileset synth QUARTUS_SYNTH synth_proc
set_fileset_property synth TOP_LEVEL uflex_ilk_core


#===========================================================
# Set properties of elaboration through a proc call
#=========================================================== 
set_module_property ELABORATION_CALLBACK elaborate


#===========================================================
# Add fileset for simulation
#=========================================================== 

add_fileset simulation_verilog SIM_VERILOG sim_ver
set_fileset_property simulation_verilog TOP_LEVEL uflex_ilk_core


#======================================
# display tabs
#======================================

add_display_item "" "General" GROUP
#add_display_item "" "Striper" GROUP


#=======================================================
# Parameters 
#=======================================================

add_parameter DEVICE_FAMILY STRING
set_parameter_property DEVICE_FAMILY DISPLAY_NAME "Device family"
set_parameter_property DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
set_parameter_property DEVICE_FAMILY ALLOWED_RANGES {"Stratix V" "Arria 10"}
set_parameter_property DEVICE_FAMILY DESCRIPTION "Supports Stratix V, Arria 10"
set_parameter_property DEVICE_FAMILY VISIBLE false
set_parameter_property DEVICE_FAMILY HDL_PARAMETER true
set_parameter_property DEVICE_FAMILY ENABLED false
add_display_item "General" DEVICE_FAMILY parameter


# add_parameter FAMILY STRING
# set_parameter_property FAMILY DEFAULT_VALUE "Arria 10"
# set_parameter_property FAMILY DISPLAY_NAME "family"
# set_parameter_property FAMILY ALLOWED_RANGES  {"Stratix V" "Arria 10"}
# set_parameter_property FAMILY DISPLAY_HINT ""
# set_parameter_property FAMILY AFFECTS_ELABORATION true
# set_parameter_property FAMILY AFFECTS_GENERATION true
# set_parameter_property FAMILY DESCRIPTION "Specifies family type"
# set_parameter_property FAMILY VISIBLE false
# set_parameter_property FAMILY DERIVED true
# set_parameter_property FAMILY HDL_PARAMETER ture
# add_display_item "General" FAMILY parameter



add_parameter SIM_MODE BOOLEAN
set_parameter_property SIM_MODE DEFAULT_VALUE 0
#set_parameter_property SIM_MODE ALLOWED_RANGES {0 1}
set_parameter_property SIM_MODE DISPLAY_HINT "BOOLEAN"
set_parameter_property SIM_MODE VISIBLE true
set_parameter_property SIM_MODE DERIVED false
set_parameter_property SIM_MODE HDL_PARAMETER true
add_display_item "General" SIM_MODE parameter


add_parameter ILA_MODE BOOLEAN
set_parameter_property ILA_MODE DEFAULT_VALUE 0
#set_parameter_property ILA_MODE ALLOWED_RANGES {0 1}
set_parameter_property ILA_MODE DISPLAY_HINT "BOOLEAN"
set_parameter_property ILA_MODE VISIBLE true
set_parameter_property ILA_MODE HDL_PARAMETER true
set_parameter_property ILA_MODE DESCRIPTION "Will be removed once the structure is finalized"
add_display_item "General" ILA_MODE parameter


add_parameter METALEN INTEGER
set_parameter_property METALEN DEFAULT_VALUE 2048
set_parameter_property METALEN ALLOWED_RANGES {64:8192}
set_parameter_property METALEN DISPLAY_NAME "Meta frame length"
set_parameter_property METALEN UNITS None
set_parameter_property METALEN VISIBLE true
set_parameter_property METALEN HDL_PARAMETER true
set_parameter_property METALEN DESCRIPTION "Specifies the meta frame length; possible lengths are 64-8192 words."
add_display_item "General" METALEN parameter


add_parameter PMA_WIDTH INTEGER
set_parameter_property PMA_WIDTH DEFAULT_VALUE 32
set_parameter_property PMA_WIDTH ALLOWED_RANGES {32,40}
set_parameter_property PMA_WIDTH VISIBLE false
set_parameter_property PMA_WIDTH HDL_PARAMETER true
add_display_item "General" PMA_WIDTH parameter


add_parameter TXFIFO_PEMPTY INTEGER
set_parameter_property TXFIFO_PEMPTY DEFAULT_VALUE 2
set_parameter_property TXFIFO_PEMPTY ALLOWED_RANGES {1,2}
set_parameter_property TXFIFO_PEMPTY VISIBLE false
set_parameter_property TXFIFO_PEMPTY HDL_PARAMETER true
add_display_item "General" TXFIFO_PEMPTY parameter


add_parameter MM_CLK_KHZ INTEGER 1
set_parameter_property MM_CLK_KHZ DEFAULT_VALUE 100000
set_parameter_property MM_CLK_KHZ DISPLAY_NAME "MM_CLK_KHZ"
set_parameter_property MM_CLK_KHZ ALLOWED_RANGES {100000:150000}
set_parameter_property MM_CLK_KHZ DISPLAY_HINT ""
set_parameter_property MM_CLK_KHZ DESCRIPTION "mm clock in KHz"
set_parameter_property MM_CLK_KHZ HDL_PARAMETER true
set_parameter_property MM_CLK_KHZ AFFECTS_ELABORATION true
set_parameter_property MM_CLK_KHZ VISIBLE false
add_display_item "General " MM_CLK_KHZ parameter


add_parameter MM_CLK_MHZ INTEGER 1
set_parameter_property MM_CLK_MHZ DEFAULT_VALUE 100
set_parameter_property MM_CLK_MHZ DISPLAY_NAME "MM_CLK_MHZ"
set_parameter_property MM_CLK_MHZ ALLOWED_RANGES {100:150}
set_parameter_property MM_CLK_MHZ DISPLAY_HINT ""
set_parameter_property MM_CLK_MHZ DESCRIPTION "mm clock in MHz"
set_parameter_property MM_CLK_MHZ HDL_PARAMETER true
set_parameter_property MM_CLK_MHZ AFFECTS_ELABORATION true
set_parameter_property MM_CLK_MHZ VISIBLE false
set_parameter_property MM_CLK_MHZ DERIVED true
add_display_item "General " MM_CLK_MHZ parameter


add_parameter STRIPER BOOLEAN
set_parameter_property STRIPER DEFAULT_VALUE 1
set_parameter_property STRIPER DERIVED true
set_parameter_property STRIPER DISPLAY_NAME "Striper"
set_parameter_property STRIPER ALLOWED_RANGES {0 1}
set_parameter_property STRIPER DISPLAY_HINT "BOOLEAN"
set_parameter_property STRIPER DESCRIPTION ""
set_parameter_property STRIPER AFFECTS_ELABORATION true
set_parameter_property STRIPER HDL_PARAMETER true
set_parameter_property STRIPER VISIBLE false
add_display_item "General" STRIPER parameter


add_parameter NUM_LANES INTEGER 12
set_parameter_property NUM_LANES DEFAULT_VALUE 4
set_parameter_property NUM_LANES DISPLAY_NAME "Number of lanes"
set_parameter_property NUM_LANES ALLOWED_RANGES {1:24}
set_parameter_property NUM_LANES VISIBLE true
set_parameter_property NUM_LANES ENABLED true
set_parameter_property NUM_LANES AFFECTS_ELABORATION true
set_parameter_property NUM_LANES AFFECTS_GENERATION true
set_parameter_property NUM_LANES HDL_PARAMETER ture
set_parameter_property NUM_LANES DESCRIPTION "You can select any lane from 1-12 and 24. For Additional lane and data rate configurations Contact your Altera sales representative or email interlaken@altera.com for more information."
add_display_item "General" NUM_LANES parameter


add_parameter INTERNAL_WORDS INTEGER 12
set_parameter_property INTERNAL_WORDS DEFAULT_VALUE 4
set_parameter_property INTERNAL_WORDS DISPLAY_NAME "Internal Words"
#set_parameter_property INTERNAL_WORDS DERIVED true
set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {1:12}
set_parameter_property INTERNAL_WORDS VISIBLE true
set_parameter_property INTERNAL_WORDS ENABLED true
set_parameter_property INTERNAL_WORDS DESCRIPTION "Number of parallel 64bit words in the datapath"
set_parameter_property INTERNAL_WORDS AFFECTS_ELABORATION true
set_parameter_property INTERNAL_WORDS AFFECTS_GENERATION true
set_parameter_property INTERNAL_WORDS HDL_PARAMETER ture
add_display_item "General" INTERNAL_WORDS parameter


add_parameter TX_CREDIT_LATENCY INTEGER
set_parameter_property TX_CREDIT_LATENCY DEFAULT_VALUE 4
set_parameter_property TX_CREDIT_LATENCY ALLOWED_RANGES {2:6}
set_parameter_property TX_CREDIT_LATENCY VISIBLE true
set_parameter_property TX_CREDIT_LATENCY HDL_PARAMETER true
set_parameter_property TX_CREDIT_LATENCY DESCRIPTION "It is the latency between tx_credit to the tx_valid. User logic should consider this value when it generates tx_valid signal."
add_display_item "General" TX_CREDIT_LATENCY parameter


add_parameter CALENDAR_PAGES INTEGER
set_parameter_property CALENDAR_PAGES DEFAULT_VALUE 1
set_parameter_property CALENDAR_PAGES DISPLAY_NAME "Number of calendar pages"
set_parameter_property CALENDAR_PAGES ALLOWED_RANGES {1,2,4,8,16}
set_parameter_property CALENDAR_PAGES DISPLAY_HINT ""
set_parameter_property CALENDAR_PAGES DESCRIPTION "In-band flow control supports 16-bit calendar pages. Supported numbers of pages are 1, 2, 4, 8, and 16. Flow control channels can be mapped to a calendar entry or entries."
set_parameter_property CALENDAR_PAGES HDL_PARAMETER true
set_parameter_property CALENDAR_PAGES AFFECTS_ELABORATION true
add_display_item "General" CALENDAR_PAGES parameter


add_parameter LOG_CALENDAR_PAGES INTEGER
set_parameter_property LOG_CALENDAR_PAGES DEFAULT_VALUE 1
set_parameter_property LOG_CALENDAR_PAGES DISPLAY_NAME "Log of calendar pages"
set_parameter_property LOG_CALENDAR_PAGES ALLOWED_RANGES {1:4}
set_parameter_property LOG_CALENDAR_PAGES DISPLAY_HINT ""
set_parameter_property LOG_CALENDAR_PAGES DESCRIPTION "Calendar Pages (CP) = 1,2,4,8,16 respective Log CP = 1,1,2,3,4"
set_parameter_property LOG_CALENDAR_PAGES HDL_PARAMETER true
set_parameter_property LOG_CALENDAR_PAGES VISIBLE false
set_parameter_property LOG_CALENDAR_PAGES DERIVED true
set_parameter_property LOG_CALENDAR_PAGES AFFECTS_ELABORATION true
add_display_item "General" LOG_CALENDAR_PAGES parameter

#INBAND
add_parameter INBAND_FLW_ON BOOLEAN
set_parameter_property INBAND_FLW_ON DEFAULT_VALUE 1
set_parameter_property INBAND_FLW_ON DISPLAY_NAME "In band flow control"
set_parameter_property INBAND_FLW_ON UNITS None
set_parameter_property INBAND_FLW_ON VISIBLE true
set_parameter_property INBAND_FLW_ON HDL_PARAMETER true
set_parameter_property INBAND_FLW_ON DESCRIPTION "Enables control to stop or continue the transmission of data through a simple on/off (XON/XOFF) mechanism of a channel or channels. Altera provides an out-of-band flow control block with this IP core. For designs that require retransmission, contact your Altera sales representative or email interlaken@altera.com."
add_display_item "General" INBAND_FLW_ON parameter

add_parameter IBFC_ERR BOOLEAN
set_parameter_property IBFC_ERR DEFAULT_VALUE 1
#set_parameter_property IBFC_ERR ALLOWED_RANGES {0 1}
set_parameter_property IBFC_ERR DISPLAY_NAME "Include In band flow control err handler"
set_parameter_property IBFC_ERR AFFECTS_GENERATION true
set_parameter_property IBFC_ERR HDL_PARAMETER true
set_parameter_property IBFC_ERR AFFECTS_ELABORATION true
set_parameter_property IBFC_ERR VISIBLE true
add_display_item "General" IBFC_ERR parameter


add_parameter TX_ERR_INJ_EN BOOLEAN
set_parameter_property TX_ERR_INJ_EN DEFAULT_VALUE 0
set_parameter_property TX_ERR_INJ_EN DISPLAY_HINT "BOOLEAN"
set_parameter_property TX_ERR_INJ_EN VISIBLE true
set_parameter_property TX_ERR_INJ_EN DERIVED false
set_parameter_property TX_ERR_INJ_EN HDL_PARAMETER true
set_parameter_property TX_ERR_INJ_EN DESCRIPTION "Error Injection at mac level for simulation only.Will be removed from final version"
add_display_item "General" TX_ERR_INJ_EN parameter


add_parameter DATA_RATE STRING
set_parameter_property DATA_RATE DEFAULT_VALUE "10.3125"
set_parameter_property DATA_RATE DISPLAY_NAME "Data rate"
set_parameter_property DATA_RATE ALLOWED_RANGES {"6.25" "10.3125" "12.5" }
set_parameter_property DATA_RATE UNITS GigabitsPerSecond
set_parameter_property DATA_RATE AFFECTS_ELABORATION true
set_parameter_property DATA_RATE AFFECTS_GENERATION true
set_parameter_property DATA_RATE HDL_PARAMETER false
set_parameter_property DATA_RATE DESCRIPTION "Supports three data rates: 6.25 Gbps,10.3125 Gbps, and 12.5 Gbps. "
add_display_item "General" DATA_RATE parameter


add_parameter CDR_REFCLK STRING
set_parameter_property CDR_REFCLK DISPLAY_NAME "CDR and PLL reference clock"
set_parameter_property CDR_REFCLK DEFAULT_VALUE "156.25"
set_parameter_property CDR_REFCLK ALLOWED_RANGES {"156.25" "195.3125" "250.0" "312.5" "390.625" "500.0" "625.0" }
set_parameter_property CDR_REFCLK UNITS Megahertz
set_parameter_property CDR_REFCLK DISPLAY_HINT ""
set_parameter_property CDR_REFCLK AFFECTS_ELABORATION true
set_parameter_property CDR_REFCLK AFFECTS_GENERATION true
set_parameter_property CDR_REFCLK VISIBLE true
set_parameter_property CDR_REFCLK HDL_PARAMETER false
set_parameter_property CDR_REFCLK DESCRIPTION "Supports multiple transceiver reference clock frequencies for flexibility in oscillator and PLL choices."
add_display_item "General" CDR_REFCLK parameter

#ADME
add_parameter ADME BOOLEAN 0 
set_parameter_property ADME DEFAULT_VALUE 0
set_parameter_property ADME DISPLAY_NAME "Enable Native XCVR PHY ADME"
set_parameter_property ADME DISPLAY_HINT BOOLEAN
set_parameter_property ADME AFFECTS_ELABORATION true
set_parameter_property ADME AFFECTS_GENERATION true
set_parameter_property ADME HDL_PARAMETER false
# set_parameter_property ADME DERIVED true
set_parameter_property ADME VISIBLE false
set_parameter_property ADME DESCRIPTION  "Enables ADME capabilities of the native xcvr phy."
add_display_item "General" ADME parameter

# add_parameter BASE_DEVICE string "Unknown"
# set_parameter_property BASE_DEVICE SYSTEM_INFO {BASE_DEVICE}
# set_parameter_property BASE_DEVICE VISIBLE false

add_parameter part_trait_bd string ""
set_parameter_property part_trait_bd SYSTEM_INFO_TYPE PART_TRAIT
set_parameter_property part_trait_bd SYSTEM_INFO_ARG BASE_DEVICE
set_parameter_property part_trait_bd VISIBLE false

add_parameter COMPONENT_EXTN BOOLEAN
set_parameter_property COMPONENT_EXTN DEFAULT_VALUE 0
#set_parameter_property COMPONENT_EXTN ALLOWED_RANGES {0 1}
set_parameter_property COMPONENT_EXTN DISPLAY_HINT "BOOLEAN"
set_parameter_property COMPONENT_EXTN VISIBLE true
set_parameter_property COMPONENT_EXTN HDL_PARAMETER false
set_parameter_property COMPONENT_EXTN DESCRIPTION "Maybe removed once the structure is finalized. Generates component extension"
add_display_item "General" COMPONENT_EXTN parameter



#=======================================================
# Code 
#=======================================================


proc elaborate {} {
  set lanes [get_parameter_value NUM_LANES]
  set words [get_parameter_value INTERNAL_WORDS]
  set data_rate_gui [get_parameter_value DATA_RATE]
  set cal_pages [get_parameter_value CALENDAR_PAGES]
  set cdr_refclk [get_parameter_value CDR_REFCLK]
  #set cdr_refclk_num [expr [string trim $cdr_refclk MHz ]]
  set sim_mode [get_parameter_value SIM_MODE]
  set metalen [get_parameter_value METALEN]
  set device_family [get_parameter_value DEVICE_FAMILY]
  set pma_width [get_parameter_value PMA_WIDTH]
  set mm_clock_mhz [get_parameter_value MM_CLK_MHZ]
  set ila_mode [get_parameter_value ILA_MODE]
  set comp_extn [get_parameter_value COMPONENT_EXTN]
  set adme [get_parameter_value ADME]
  
  #set_parameter_value FAMILY $device_family
  if {$ila_mode && $comp_extn} {
    send_message ERROR "Component Extension does not apply to ILA mode"
  }
  
  if {$comp_extn} {
    set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {4,8,16}
  } else {
    set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {1:12}  
    if {$lanes == 4 || $lanes == 8 || $lanes == 12 || $lanes == 16 || $lanes == 24}  {
      set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {4,8,12}
      if {$lanes == 4 } {
        if {$words != 4 } {
          send_message ERROR "Please select Internal Words as 4"
        }
        set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {4}
      }
      if {$lanes == 8 } {
        if {$words != 8 && $words != 4 } {
          send_message ERROR "Please select Internal Words as 4 or 8"
        }
        set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {4,8}
      }
      if {$lanes == 12 } {
        if {$words != 8 } {
          send_message ERROR "Please select Internal Words as 8"
        }
        set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {8}
      }
      if {$lanes == 16 } {
       if {$words != 8 } {
          send_message ERROR "Please select Internal Words as 8"
        }
        set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {8}
      }
      if {$lanes == 24 } {
        if {$words != 8 && $words != 12 } {
          send_message ERROR "Please select Internal Words as 8 or 12"
        }
        set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {8,12}
      }  
      set_parameter_value STRIPER 1
    } elseif {$lanes != 24 && $lanes > 12} {
        send_message error "This lane selection is not valid. For valid lanes please see the Ultra Flexible Interlaken documentation"
    } else {
      set_parameter_property INTERNAL_WORDS ALLOWED_RANGES {1,2,3,4,5,6,7,8,9,10,11}
      set_parameter_value STRIPER 0
      if {$words != $lanes } {
       send_message ERROR "For $lanes lanes select Internal Words as $lanes"
      }
    }
  }
 
 if {$words == 16} {
    set raw_words 12
  } else {
    set raw_words $words
  }
  
  
 if {$words == 4} {
    set log_words 3
  } elseif {$words == 8} {
    set log_words 4
  } else {
    set log_words 5
  }
  
  #set Meta Frame Length if sim_mode is on
  # if {$sim_mode} {
    # if {$metalen != 128} {
        # send_message ERROR "Please select MetaFrameLength as 128 for Sim Mode"
      # }
      # set_parameter_property METALEN ALLOWED_RANGES {128}
  # } else {
      # set_parameter_property METALEN ALLOWED_RANGES {64:8192}
  # }
  #set value of data rate
  if {$data_rate_gui == 6.25} {
    set data_rate 6250.0
  } elseif {$data_rate_gui == 10.3125} {
    set data_rate 10312.5
  } elseif {$data_rate_gui == 12.5} {
    set data_rate 12500
  } else {
      send_message error "Data Rate is not supported"
  }
  
  
  
  #set value of Log_calendar_pages
  if {$cal_pages == 1 || $cal_pages == 2 } {
    set_parameter_value LOG_CALENDAR_PAGES 1
  } elseif {$cal_pages == 4} {
      set_parameter_value LOG_CALENDAR_PAGES 2  
  } elseif {$cal_pages == 8} {
      set_parameter_value LOG_CALENDAR_PAGES 3
  } elseif {$cal_pages == 16} {
      set_parameter_value LOG_CALENDAR_PAGES 4
  } else {
      send_message error "Calendar width is not supported"
  }
  
  #CDR and PLL ref clocks
  if {$data_rate == 10312.5} {
    set_parameter_property CDR_REFCLK ALLOWED_RANGES {"156.25" "206.25" "257.8125" "322.265625" "412.5" "515.625" "644.53125" }
  } elseif {$data_rate == 12500.0} {
      set_parameter_property CDR_REFCLK ALLOWED_RANGES {"156.25" "195.3125" "250.0" "312.5" "390.625" "500.0" "625.0" }
  } elseif {$data_rate == 6250.0} {
      set_parameter_property CDR_REFCLK ALLOWED_RANGES {"156.25" "195.3125" "250.0" "312.5" "390.625" "500.0" "625.0" }
  } else {
      send_message error "Data rate is not supported, set range of pll ref clk"
  }
  
  #Pll and native phy instantiation for A10
  if {$device_family == "Arria 10"} {
    
    #Make ADME selection visible
    set_parameter_property ADME VISIBLE true
    
    #PLL 
    add_hdl_instance atxpll altera_xcvr_atx_pll_a10
    set atxpll_param_val_list [list \
            set_output_clock_frequency              [expr {$data_rate/2}] \
            set_auto_reference_clock_frequency      $cdr_refclk \
            pma_width                               $pma_width \
            enable_mcgb                             1 \
            enable_hfreq_clk                        1 \
            base_device                             [get_parameter_value part_trait_bd] \
            ]
        foreach {param val} $atxpll_param_val_list {
            set_instance_parameter_value atxpll $param $val
        }
    
    #Native PHY 
    add_hdl_instance uflex_ilk_xcvr altera_xcvr_native_a10
    set_instance_parameter_value  uflex_ilk_xcvr  base_device [get_parameter_value part_trait_bd]
    if {$adme} {
        set uflex_ilk_xcvr_param_val_list [list  \
            protocol_mode                        interlaken_mode \
            channels                             $lanes \
            set_data_rate                        $data_rate \
            plls                                 1 \
            set_cdr_refclk_freq                  $cdr_refclk \
            enable_ports_rx_prbs                 1 \
            enable_ports_rx_manual_cdr_mode      1 \
            enable_port_rx_seriallpbken          1 \
            rx_pma_dfe_adaptation_mode           continuous \
            enh_pcs_pma_width                    $pma_width \
            enh_pld_pcs_width                    67 \
            enh_txfifo_mode                      Interlaken \
            enh_txfifo_pfull                     11 \
            enh_txfifo_pempty                    2 \
            enable_port_tx_enh_fifo_full         1 \
            enable_port_tx_enh_fifo_pfull        1 \
            enable_port_tx_enh_fifo_empty        1 \
            enable_port_tx_enh_fifo_pempty       1 \
            enable_port_tx_enh_fifo_cnt          1 \
            enh_rxfifo_mode                      Interlaken  \
            enh_rxfifo_pempty                    2 \
            enable_port_rx_enh_data_valid        1 \
            enable_port_rx_enh_fifo_full         1 \
            enable_port_rx_enh_fifo_pfull        1 \
            enable_port_rx_enh_fifo_empty        1 \
            enable_port_rx_enh_fifo_pempty       1 \
            enable_port_rx_enh_fifo_rd_en        1 \
            enable_port_rx_enh_fifo_align_val    1 \
            enable_port_rx_enh_fifo_align_clr    1 \
            enh_tx_frmgen_enable                 1 \
            enh_tx_frmgen_mfrm_length            $metalen \
            enh_tx_frmgen_burst_enable           1 \
            enable_port_tx_enh_frame             1 \
            enable_port_tx_enh_frame_diag_status 1 \
            enable_port_tx_enh_frame_burst_en    1 \
            enh_rx_frmsync_enable                1 \
            enh_rx_frmsync_mfrm_length           $metalen \
            enable_port_rx_enh_frame             1 \
            enable_port_rx_enh_frame_lock        1 \
            enable_port_rx_enh_frame_diag_status 1 \
            enh_tx_crcgen_enable                 1 \
            enh_tx_crcerr_enable                 1 \
            enh_rx_crcchk_enable                 1 \
            enable_port_rx_enh_crc32_err         1 \
            enh_tx_scram_enable                  1 \
            enh_tx_scram_seed                    1 \
            enh_rx_descram_enable                1 \
            enh_tx_dispgen_enable                1 \
            enh_rx_dispchk_enable                1 \
            enh_rx_blksync_enable                1 \
            enable_port_rx_enh_blk_lock          1 \
            generate_add_hdl_instance_example    1 \
            rcfg_enable                          1 \
            rcfg_shared                          1 \
            rcfg_jtag_enable                   1 \
            set_capability_reg_enable    1 \
            set_prbs_soft_logic_enable  1 \
            set_odi_soft_logic_enable    1 \
            rcfg_file_prefix                     altera_xcvr_native_phy \
            ]
            
    } else {
        
        set uflex_ilk_xcvr_param_val_list [list  \
            protocol_mode                        interlaken_mode \
            channels                             $lanes \
            set_data_rate                        $data_rate \
            plls                                 1 \
            set_cdr_refclk_freq                  $cdr_refclk \
            enable_ports_rx_prbs                 1 \
            enable_ports_rx_manual_cdr_mode      1 \
            enable_port_rx_seriallpbken          1 \
            rx_pma_dfe_adaptation_mode           continuous \
            enh_pcs_pma_width                    $pma_width \
            enh_pld_pcs_width                    67 \
            enh_txfifo_mode                      Interlaken \
            enh_txfifo_pfull                     11 \
            enh_txfifo_pempty                    2 \
            enable_port_tx_enh_fifo_full         1 \
            enable_port_tx_enh_fifo_pfull        1 \
            enable_port_tx_enh_fifo_empty        1 \
            enable_port_tx_enh_fifo_pempty       1 \
            enable_port_tx_enh_fifo_cnt          1 \
            enh_rxfifo_mode                      Interlaken  \
            enh_rxfifo_pempty                    2 \
            enable_port_rx_enh_data_valid        1 \
            enable_port_rx_enh_fifo_full         1 \
            enable_port_rx_enh_fifo_pfull        1 \
            enable_port_rx_enh_fifo_empty        1 \
            enable_port_rx_enh_fifo_pempty       1 \
            enable_port_rx_enh_fifo_rd_en        1 \
            enable_port_rx_enh_fifo_align_val    1 \
            enable_port_rx_enh_fifo_align_clr    1 \
            enh_tx_frmgen_enable                 1 \
            enh_tx_frmgen_mfrm_length            $metalen \
            enh_tx_frmgen_burst_enable           1 \
            enable_port_tx_enh_frame             1 \
            enable_port_tx_enh_frame_diag_status 1 \
            enable_port_tx_enh_frame_burst_en    1 \
            enh_rx_frmsync_enable                1 \
            enh_rx_frmsync_mfrm_length           $metalen \
            enable_port_rx_enh_frame             1 \
            enable_port_rx_enh_frame_lock        1 \
            enable_port_rx_enh_frame_diag_status 1 \
            enh_tx_crcgen_enable                 1 \
            enh_tx_crcerr_enable                 1 \
            enh_rx_crcchk_enable                 1 \
            enable_port_rx_enh_crc32_err         1 \
            enh_tx_scram_enable                  1 \
            enh_tx_scram_seed                    1 \
            enh_rx_descram_enable                1 \
            enh_tx_dispgen_enable                1 \
            enh_rx_dispchk_enable                1 \
            enh_rx_blksync_enable                1 \
            enable_port_rx_enh_blk_lock          1 \
            generate_add_hdl_instance_example    1 \
            rcfg_enable                          1 \
            rcfg_shared                          1 \
            rcfg_file_prefix                     altera_xcvr_native_phy \
            ]
    }    

    foreach {param val} $uflex_ilk_xcvr_param_val_list {
        set_instance_parameter_value uflex_ilk_xcvr $param $val
    }
    
    #Reset_control 
    add_hdl_instance uflex_ilk_reset_control altera_xcvr_reset_control
    set param_val_list [list \
      channels                              $lanes \
      plls                                  1 \
      sys_clk_in_mhz                        $mm_clock_mhz \
      synchronize_reset                     1 \
      reduced_sim_time                      1 \
      tx_pll_enable                         1 \
      t_pll_powerdown                       1000 \
      synchronize_pll_reset                 1 \
      tx_enable                             1 \
      t_tx_digitalreset                     20 \
      rx_enable                             1 \
      t_rx_analogreset                      40 \
      t_rx_digitalreset                     4000  \
      ]
    foreach {param val} $param_val_list {
      set_instance_parameter_value uflex_ilk_reset_control $param $val
    }
  }
    
    
    #ADD ports
    
    #Clock and reset
    add_conduit pll_ref_clk         end     Input   1
    add_conduit reset_n             end     Input   1
    add_conduit tx_pll_locked       end     Input   1
    add_conduit tx_pll_cal_busy     end     Input   1
    add_conduit tx_serial_clk       end     Input   $lanes
    add_conduit tx_clk              end     Input   1
    add_conduit tx_srst             end     Output  1
    add_conduit clk_tx_common       end     Output  1
    add_conduit rx_clk              end     Input   1
    add_conduit rx_srst             end     Output  1
    add_conduit clk_rx_common       end     Output  1
    
    if {$comp_extn} {
      
      #Clock and reset
      add_conduit tx_pll_powerdown       end     Output  1
      
      #Burst config
      add_conduit burst_max_in     end        Input      4
      add_conduit burst_min_in      end        Input      4
      add_conduit burst_short_in    end       Input       4

      #TX User interface
      add_conduit itx_din_words            end     Input   [expr {64 * $words}]
      add_conduit itx_num_valid             end     Input   [expr {2 * $log_words}]
      add_conduit itx_sob              end     Input   2
      add_conduit itx_sop              end     Input   2
      add_conduit itx_eob                end     Input  1
      add_conduit itx_eopbits          end     Input   4
      add_conduit itx_chan             end     Input   8 
      add_conduit itx_ready           end     Output  1
      add_conduit itx_calendar         end     Input   [expr {16 * $cal_pages}]
      
       # RX User Interface
      add_conduit irx_dout_words            end     Output   [expr {64 * $words}]
      add_conduit irx_num_valid             end     Output    [expr {2 * $log_words}]
      add_conduit irx_sob              end     Output   2
      add_conduit irx_sop              end     Output   2
      add_conduit irx_eob              end     Output   1
      add_conduit irx_eopbits          end     Output  4
      add_conduit crc24_err        end     Output   1
      add_conduit irx_chan             end     Output   8
      add_conduit irx_calendar         end     Output   [expr {16 * $cal_pages}]
      
      # Miscellaneous signals
      add_conduit crc32_err        end     Output  $lanes
    
   } else {
    #Clock and reset    
    add_conduit pll_powerdown       end     Output  1
    
    #TX User interface
    add_conduit tx_valid            end     Input   1
    add_conduit tx_idle             end     Input   $words
    add_conduit tx_sob              end     Input   $words
    add_conduit tx_sop              end     Input   $words
    add_conduit tx_eopbits          end     Input   [expr {$words * 4}]
    add_conduit tx_chan             end     Input   [expr {8 * $words}]
    add_conduit tx_ctrl             end     Input   [expr {29 * $words}]
    add_conduit tx_data             end     Input   [expr {64 * $words}]
    add_conduit tx_credit           end     Output  1
    add_conduit tx_calendar         end     Input   [expr {16 * $cal_pages}]

    # RX User Interface
    add_conduit rx_valid            end     Output  1
    add_conduit rx_idle             end     Output   $words
    add_conduit rx_sob              end     Output   $words
    add_conduit rx_sop              end     Output   $words
    add_conduit rx_eopbits          end     Output   [expr {4 * $words}]
    add_conduit rx_crc24_err        end     Output   $words
    add_conduit rx_chan             end     Output   [expr {8 * $words}]
    add_conduit rx_ctrl             end     Output   [expr {29 * $words}]
    add_conduit rx_data             end     Output   [expr {64 * $words}]
    add_conduit rx_calendar         end     Output   [expr {16 * $cal_pages}]
    
    # Miscellaneous signals
    add_conduit rx_crc32_err        end     Output  $lanes

   }

    # Serial interface signals
    add_conduit tx_pin              end     Output  $lanes
    add_conduit rx_pin              end     Input   $lanes

    # Miscellaneous signals
    add_conduit tx_lanes_aligned    end     Output  1
    add_conduit rx_lanes_aligned    end     Output  1
    add_conduit word_locked         end     Output  $lanes
    add_conduit sync_locked         end     Output  $lanes
    add_conduit tx_overflow         end     Output  1
    add_conduit tx_underflow        end     Output  1
    add_conduit rx_overflow         end     Output  1
  

    # Avalon-MM interface for Uflex Interlaken core CSR
    add_conduit mm_clk              end     Input   1
    add_conduit mm_read             end     Input   1
    add_conduit mm_write            end     Input   1
    add_conduit mm_address          end     Input   16
    add_conduit mm_readdata         end     Output  32
    add_conduit mm_readdatavalid    end     Output  1
    add_conduit mm_writedata        end     Input   32

    # Avalon-MM interface for native PHY reconfiguration 
    add_conduit reconfig_clk         end     Input   1
    add_conduit reconfig_reset       end     Input   1
    add_conduit reconfig_read        end     Input   1
    add_conduit reconfig_write       end     Input   1
    add_conduit reconfig_address     end     Input   14
    add_conduit reconfig_readdata    end     Output  32
    add_conduit reconfig_writedata   end     Input   32
    add_conduit reconfig_waitrequest end     Output   1

    # Reconfiguration interface for StratixV
  
    add_conduit reconfig_to_xcvr      end     Input   [expr {70 * $lanes}]
    add_conduit reconfig_from_xcvr    end     Output  [expr {46 * $lanes}]
    
  
}  


proc add_conduit {iface_name type dir width} {

    add_interface $iface_name conduit $type
    add_interface_port $iface_name $iface_name export $dir $width
  
}

proc synth_proc {outputName} {

  set ila_mode [get_parameter_value ILA_MODE]
  set comp_extn [get_parameter_value COMPONENT_EXTN]

  if {$ila_mode} {
    
    set files_mac  "uflex_ilk_crc24_12.sv	uflex_ilk_crc24_4.sv	uflex_ilk_crc24_8.sv uflex_ilk_crc24_acc.sv	uflex_ilk_crc24_evo10_2lut.sv	uflex_ilk_crc24_evo11_2lut.sv	uflex_ilk_crc24_evo12_2lut.sv \
	   uflex_ilk_crc24_evo1_2lut.sv	uflex_ilk_crc24_evo2_2lut.sv	uflex_ilk_crc24_evo3_2lut.sv	uflex_ilk_crc24_evo4_2lut.sv	uflex_ilk_crc24_evo5_2lut.sv	uflex_ilk_crc24_evo6_2lut.sv	uflex_ilk_crc24_evo7_2lut.sv \
	   uflex_ilk_crc24_evo8_2lut.sv	uflex_ilk_crc24_evo9_2lut.sv	uflex_ilk_crc24_in_n.sv	uflex_ilk_crc24_n.sv	uflex_ilk_iw48c_rx_crc24.sv	uflex_ilk_iw48c_tx_crc24.sv	uflex_ilk_rx_crc24.sv	uflex_ilk_rx_crc24_calendar.sv \
	   uflex_ilk_rx_crc24_scalable.sv	uflex_ilk_rx_crc24_striper.sv	uflex_ilk_rx_ila.sv	uflex_ilk_tx_crc24.sv	uflex_ilk_tx_crc24_scalable.sv \
	   uflex_ilk_tx_crc24_striper.sv	uflex_ilk_tx_ila.sv	uflex_ilk_tx_intlv.sv"
       
      add_fileset_file /uflex_ilk_top/uflex_ilk_core.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_core.sv
      add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_dcore.sv
      
    set files_components_sv "	uflex_ilk_a10mlab.sv uflex_ilk_add3_cmp3.sv	uflex_ilk_compressor_3to2.sv	uflex_ilk_compressor_4to3.sv uflex_ilk_compressor_5to3.sv uflex_ilk_compressor_6to3.sv uflex_ilk_count_to_here_12.sv \
    	uflex_ilk_crc24_evo1.sv uflex_ilk_crc24_evo10.sv uflex_ilk_crc24_evo11.sv	uflex_ilk_crc24_evo12.sv	uflex_ilk_crc24_evo2.sv	uflex_ilk_crc24_evo3.sv	uflex_ilk_crc24_evo4.sv	uflex_ilk_crc24_evo5.sv \
	  	uflex_ilk_crc24_evo6.sv uflex_ilk_crc24_evo7.sv	uflex_ilk_crc24_evo8.sv uflex_ilk_crc24_evo9.sv uflex_ilk_crc24_in12.sv uflex_ilk_crc24_in4.sv uflex_ilk_crc24_in8.sv uflex_ilk_crc24_sig.sv uflex_ilk_delay_mlab.sv \
	  	uflex_ilk_delay_regs.sv uflex_ilk_eq_12.sv	uflex_ilk_eq_3.sv	uflex_ilk_frequency_monitor.sv	uflex_ilk_index_with_restart_12.sv	uflex_ilk_index_with_restart_3.sv	uflex_ilk_index_with_restart_6.sv \
	  	uflex_ilk_leftmost_one_12_1.sv	uflex_ilk_leftmost_one_12_2.sv	uflex_ilk_leftmost_one_4.sv	uflex_ilk_leftmost_one_8.sv	uflex_ilk_mx12_ena.sv	uflex_ilk_mx16r.sv	uflex_ilk_mx4r.sv	uflex_ilk_mx8r.sv \
	  	uflex_ilk_mx_nto1_r.sv	uflex_ilk_neq_24.sv uflex_ilk_priority_12.sv	uflex_ilk_priority_6.sv	uflex_ilk_priority_6_upper.sv	uflex_ilk_reg_delay.sv \
	  	uflex_ilk_reset_delay.sv	uflex_ilk_rst_sync.sv	uflex_ilk_scfifo_mlab.sv	uflex_ilk_status_sync.sv	uflex_ilk_sum_of_3bit_pair.sv	uflex_ilk_sync_fifo_mlab.sv	uflex_ilk_sync_fifo_mlab_2.sv	\
	  	uflex_ilk_wys_lut.sv	uflex_ilk_xor_lut.sv	uflex_ilk_xor_r.sv	uflex_ilk_xor_r_12w.sv uflex_ilk_or_r.sv uflex_ilk_one_hot_enc_16.sv uflex_ilk_one_hot_enc_8.sv uflex_ilk_nogap_one_12.sv uflex_ilk_nogap_one_8.sv \
        uflex_ilk_neq_5_ena.sv uflex_ilk_eq_5_ena.sv uflex_ilk_cross_bus.sv uflex_ilk_compressor_12to4.sv uflex_ilk_barrel_shift.sv uflex_ilk_barrel_layer.sv uflex_ilk_and_r.sv"
        
  } else {
    
    set files_mac  "uflex_ilk_crc24_12.sv uflex_ilk_crc24_4.sv uflex_ilk_crc24_8.sv uflex_ilk_crc24_acc.sv uflex_ilk_crc24_evo10_2lut.sv uflex_ilk_crc24_evo11_2lut.sv uflex_ilk_crc24_evo12_2lut.sv \
	uflex_ilk_crc24_evo1_2lut.sv uflex_ilk_crc24_evo2_2lut.sv uflex_ilk_crc24_evo3_2lut.sv uflex_ilk_crc24_evo4_2lut.sv uflex_ilk_crc24_evo5_2lut.sv uflex_ilk_crc24_evo6_2lut.sv uflex_ilk_crc24_evo7_2lut.sv \
	uflex_ilk_crc24_evo8_2lut.sv uflex_ilk_crc24_evo9_2lut.sv uflex_ilk_crc24_in_n.sv uflex_ilk_crc24_n.sv uflex_ilk_iw48c_rx_crc24.sv uflex_ilk_iw48c_tx_crc24.sv uflex_ilk_iw8_addr_gen.sv \
	uflex_ilk_iw8_barrel_shift.sv uflex_ilk_iw8_burst_decode.sv uflex_ilk_iw8_enhance_scheduler.sv uflex_ilk_iw8_enhance_scheduler_ctrl.sv uflex_ilk_iw8_idle_gen.sv uflex_ilk_iw8_local_buffer.sv uflex_ilk_iw8_sync_ram.sv \
	uflex_ilk_iw8_tx_bs_control_rd.sv uflex_ilk_rx_crc24.sv uflex_ilk_rx_crc24_calendar.sv uflex_ilk_rx_crc24_scalable.sv uflex_ilk_rx_crc24_striper.sv uflex_ilk_rx_ibfc.sv uflex_ilk_rx_ibfc_err_handle.sv \
	uflex_ilk_rx_ila.sv uflex_ilk_tx_crc24.sv uflex_ilk_tx_crc24_scalable.sv uflex_ilk_tx_crc24_striper.sv uflex_ilk_tx_ext.sv uflex_ilk_tx_ext_iw8.sv uflex_ilk_tx_ibfc.sv \
	uflex_ilk_tx_ila.sv uflex_ilk_tx_intlv.sv"
     
    set files_components_sv "uflex_ilk_a10mlab.sv uflex_ilk_add3_cmp3.sv uflex_ilk_altera_syncram.sv uflex_ilk_and_r.sv uflex_ilk_barrel_layer.sv uflex_ilk_barrel_shift.sv uflex_ilk_compressor_12to4.sv \
	uflex_ilk_compressor_3to2.sv uflex_ilk_compressor_4to3.sv uflex_ilk_compressor_5to3.sv uflex_ilk_compressor_6to3.sv uflex_ilk_compressor_8to4.sv uflex_ilk_count_to_here_12.sv uflex_ilk_crc24_evo1.sv \
	uflex_ilk_crc24_evo10.sv uflex_ilk_crc24_evo11.sv uflex_ilk_crc24_evo12.sv uflex_ilk_crc24_evo2.sv uflex_ilk_crc24_evo3.sv uflex_ilk_crc24_evo4.sv uflex_ilk_crc24_evo5.sv \
	uflex_ilk_crc24_evo6.sv uflex_ilk_crc24_evo7.sv uflex_ilk_crc24_evo8.sv uflex_ilk_crc24_evo9.sv uflex_ilk_crc24_in12.sv uflex_ilk_crc24_in4.sv uflex_ilk_crc24_in8.sv \
	uflex_ilk_crc24_sig.sv uflex_ilk_cross_bus.sv uflex_ilk_delay_mlab.sv uflex_ilk_delay_regs.sv uflex_ilk_eq_12.sv uflex_ilk_eq_3.sv uflex_ilk_eq_5_ena.sv \
	uflex_ilk_fifo_4.sv uflex_ilk_fifo_8.sv uflex_ilk_frequency_monitor.sv uflex_ilk_index_with_restart_12.sv uflex_ilk_index_with_restart_3.sv uflex_ilk_index_with_restart_6.sv uflex_ilk_leftmost_one_12_1.sv \
	uflex_ilk_leftmost_one_12_2.sv uflex_ilk_leftmost_one_4.sv uflex_ilk_leftmost_one_8.sv uflex_ilk_m20k.sv uflex_ilk_mlab.sv uflex_ilk_mlab_fifo.sv uflex_ilk_mx12_ena.sv \
	uflex_ilk_mx16r.sv uflex_ilk_mx4r.sv uflex_ilk_mx8r.sv uflex_ilk_mx_nto1_r.sv uflex_ilk_neq_24.sv uflex_ilk_neq_5_ena.sv uflex_ilk_nogap_one_12.sv \
	uflex_ilk_nogap_one_8.sv uflex_ilk_one_hot_enc_16.sv uflex_ilk_one_hot_enc_8.sv uflex_ilk_or_r.sv uflex_ilk_page_dealer_12.sv uflex_ilk_page_grabber_12.sv uflex_ilk_priority_12.sv \
	uflex_ilk_priority_6.sv uflex_ilk_priority_6_upper.sv uflex_ilk_reg_delay.sv uflex_ilk_reset_delay.sv uflex_ilk_rst_sync.sv uflex_ilk_scfifo_mlab.sv uflex_ilk_status_sync.sv \
	uflex_ilk_sum_of_3bit_pair.sv uflex_ilk_sum_of_3bit_two_1bit.sv uflex_ilk_sync_fifo_mlab.sv uflex_ilk_sync_fifo_mlab_2.sv uflex_ilk_wys_lut.sv uflex_ilk_xor_lut.sv uflex_ilk_xor_r.sv \
	uflex_ilk_xor_r_12w.sv"
  
    if {$comp_extn} {
     
      set files_regroup_sv "uflex_ilk_burst_read_scheduler_iw16.sv  uflex_ilk_burst_read_scheduler_iw4.sv   uflex_ilk_burst_read_scheduler_iw8.sv   uflex_ilk_dcfifo_m20k_ecc.sv    uflex_ilk_m20k_ecc_1r1w.sv \
	    uflex_ilk_m20k_group.sv uflex_ilk_pkt_annotate.sv   uflex_ilk_rg_ctlw_iw12.sv   uflex_ilk_rg_ctlw_iw4.sv    uflex_ilk_rg_ctlw_iw8.sv   uflex_ilk_rg_dp.sv   uflex_ilk_rg_out_iw16.sv    uflex_ilk_rg_out_iw4.sv \
	    uflex_ilk_rg_out_iw8.sv uflex_ilk_rx_crc24_shift.sv uflex_ilk_rx_eob_gen.sv uflex_ilk_rx_regroup.sv uflex_ilk_rx_regroup_iw12_to_iw16.sv    uflex_ilk_rx_regroup_iw4.sv uflex_ilk_rx_regroup_iw8.sv \
	    uflex_ilk_rx_regroup_n.sv   uflex_ilk_seg_shift.sv  uflex_ilk_seg_shift_layer.sv    uflex_ilk_seg_shift_split.sv    uflex_ilk_wram_m20k.sv  uflex_ilk_wram_mult_inst.sv"
        
      foreach svfile $files_regroup_sv {
        add_fileset_file /uflex_ilk_regroup/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_regroup/${svfile}
      }
      
      set output_name  "uflex_ilk_core"
      set params(output_name)                  $output_name
      #add_fileset_file /uflex_ilk_top/uflex_ilk_core.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_core_ext.sv
      add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_dcore_ext.sv
      interpret_terp /uflex_ilk_top/uflex_ilk_core.sv  ../uflex_ilk_top/uflex_ilk_core_ext.sv.terp  [array get params]
    
    } else { 
  
    # set files_components_sv "	uflex_ilk_a10mlab.sv	uflex_ilk_add3_cmp3.sv	uflex_ilk_compressor_3to2.sv	uflex_ilk_compressor_4to3.sv uflex_ilk_compressor_5to3.sv uflex_ilk_compressor_6to3.sv uflex_ilk_count_to_here_12.sv \
    	# uflex_ilk_crc24_evo1.sv uflex_ilk_crc24_evo10.sv uflex_ilk_crc24_evo11.sv	uflex_ilk_crc24_evo12.sv	uflex_ilk_crc24_evo2.sv	uflex_ilk_crc24_evo3.sv	uflex_ilk_crc24_evo4.sv	uflex_ilk_crc24_evo5.sv \
	  	# uflex_ilk_crc24_evo6.sv uflex_ilk_crc24_evo7.sv	uflex_ilk_crc24_evo8.sv uflex_ilk_crc24_evo9.sv uflex_ilk_crc24_in12.sv uflex_ilk_crc24_in4.sv uflex_ilk_crc24_in8.sv uflex_ilk_crc24_sig.sv uflex_ilk_delay_mlab.sv \
	  	# uflex_ilk_delay_regs.sv uflex_ilk_eq_12.sv	uflex_ilk_eq_3.sv	uflex_ilk_frequency_monitor.sv	uflex_ilk_index_with_restart_12.sv	uflex_ilk_index_with_restart_3.sv	uflex_ilk_index_with_restart_6.sv \
	  	# uflex_ilk_leftmost_one_12_1.sv	uflex_ilk_leftmost_one_12_2.sv	uflex_ilk_leftmost_one_4.sv	uflex_ilk_leftmost_one_8.sv	uflex_ilk_mx12_ena.sv	uflex_ilk_mx16r.sv	uflex_ilk_mx4r.sv	uflex_ilk_mx8r.sv \
	  	# uflex_ilk_mx_nto1_r.sv	uflex_ilk_neq_24.sv uflex_ilk_page_dealer_12.sv	uflex_ilk_page_grabber_12.sv	uflex_ilk_priority_12.sv	uflex_ilk_priority_6.sv	uflex_ilk_priority_6_upper.sv	uflex_ilk_reg_delay.sv \
	  	# uflex_ilk_reset_delay.sv	uflex_ilk_rst_sync.sv	uflex_ilk_scfifo_mlab.sv	uflex_ilk_status_sync.sv	uflex_ilk_sum_of_3bit_pair.sv	uflex_ilk_sync_fifo_mlab.sv	uflex_ilk_sync_fifo_mlab_2.sv	\
	  	# uflex_ilk_wys_lut.sv	uflex_ilk_xor_lut.sv	uflex_ilk_xor_r.sv	uflex_ilk_xor_r_12w.sv"
    
    add_fileset_file /uflex_ilk_top/uflex_ilk_core.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_core.sv
    add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_dcore.sv
    
    }
  }
  
  set files_pcs "uflex_ilk_csr.sv uflex_ilk_rx_pcsif.sv uflex_ilk_rxa.sv uflex_ilk_tx_pcsif.sv uflex_ilk_txa.sv"
  set files_striper "uflex_ilk_striper_2n_to_n.sv uflex_ilk_striper_n_to_2n.sv uflex_ilk_rx_striper.sv uflex_ilk_striper_3n_to_n.sv uflex_ilk_striper_n_to_3n.sv uflex_ilk_striper_12_to_8.sv uflex_ilk_striper_8_to_12.sv uflex_ilk_tx_striper.sv"
  set files_uflex_top "uflex_ilk_rx.sv uflex_ilk_tx.sv" 
  
  
  foreach svfile $files_components_sv {
       add_fileset_file /components/${svfile} SYSTEM_VERILOG PATH ../components/${svfile}
  }
  add_fileset_file /components/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/uflex_ilk_wys_lut.iv
  add_fileset_file /uflex_ilk_mac/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/uflex_ilk_wys_lut.iv
  
  foreach svfile $files_mac {
       add_fileset_file /uflex_ilk_mac/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_mac/${svfile}
  }
    
  foreach svfile $files_pcs {
       add_fileset_file /uflex_ilk_pcs/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_pcs/${svfile}
  }
  
  foreach svfile $files_striper {
       add_fileset_file /uflex_ilk_striper/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_striper/${svfile}
  }
  foreach svfile $files_uflex_top {
    add_fileset_file /uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/${svfile}
  }    
  
  add_fileset_file uflex_ilk_core.sdc SDC PATH uflex_ilk_core.sdc
  
}  

proc sim_ver {outputName} {
  
  set ila_mode [get_parameter_value ILA_MODE]
  set comp_extn [get_parameter_value COMPONENT_EXTN]
  
  if {$ila_mode} {
  
    set files_mac  "uflex_ilk_crc24_12.sv	uflex_ilk_crc24_4.sv	uflex_ilk_crc24_8.sv uflex_ilk_crc24_acc.sv	uflex_ilk_crc24_evo10_2lut.sv	uflex_ilk_crc24_evo11_2lut.sv	uflex_ilk_crc24_evo12_2lut.sv \
	   uflex_ilk_crc24_evo1_2lut.sv	uflex_ilk_crc24_evo2_2lut.sv	uflex_ilk_crc24_evo3_2lut.sv	uflex_ilk_crc24_evo4_2lut.sv	uflex_ilk_crc24_evo5_2lut.sv	uflex_ilk_crc24_evo6_2lut.sv	uflex_ilk_crc24_evo7_2lut.sv \
	   uflex_ilk_crc24_evo8_2lut.sv	uflex_ilk_crc24_evo9_2lut.sv	uflex_ilk_crc24_in_n.sv	uflex_ilk_crc24_n.sv	uflex_ilk_iw48c_rx_crc24.sv	uflex_ilk_iw48c_tx_crc24.sv	uflex_ilk_rx_crc24.sv	uflex_ilk_rx_crc24_calendar.sv \
	   uflex_ilk_rx_crc24_scalable.sv	uflex_ilk_rx_crc24_striper.sv	uflex_ilk_rx_ila.sv	uflex_ilk_tx_crc24.sv	uflex_ilk_tx_crc24_scalable.sv \
	   uflex_ilk_tx_crc24_striper.sv	uflex_ilk_tx_ila.sv	uflex_ilk_tx_intlv.sv"
    
    set files_components_sv "	uflex_ilk_a10mlab.sv uflex_ilk_add3_cmp3.sv	uflex_ilk_compressor_3to2.sv	uflex_ilk_compressor_4to3.sv uflex_ilk_compressor_5to3.sv uflex_ilk_compressor_6to3.sv uflex_ilk_count_to_here_12.sv \
    	uflex_ilk_crc24_evo1.sv uflex_ilk_crc24_evo10.sv uflex_ilk_crc24_evo11.sv	uflex_ilk_crc24_evo12.sv	uflex_ilk_crc24_evo2.sv	uflex_ilk_crc24_evo3.sv	uflex_ilk_crc24_evo4.sv	uflex_ilk_crc24_evo5.sv \
	  	uflex_ilk_crc24_evo6.sv uflex_ilk_crc24_evo7.sv	uflex_ilk_crc24_evo8.sv uflex_ilk_crc24_evo9.sv uflex_ilk_crc24_in12.sv uflex_ilk_crc24_in4.sv uflex_ilk_crc24_in8.sv uflex_ilk_crc24_sig.sv uflex_ilk_delay_mlab.sv \
	  	uflex_ilk_delay_regs.sv uflex_ilk_eq_12.sv	uflex_ilk_eq_3.sv	uflex_ilk_frequency_monitor.sv	uflex_ilk_index_with_restart_12.sv	uflex_ilk_index_with_restart_3.sv	uflex_ilk_index_with_restart_6.sv \
	  	uflex_ilk_leftmost_one_12_1.sv	uflex_ilk_leftmost_one_12_2.sv	uflex_ilk_leftmost_one_4.sv	uflex_ilk_leftmost_one_8.sv	uflex_ilk_mx12_ena.sv	uflex_ilk_mx16r.sv	uflex_ilk_mx4r.sv	uflex_ilk_mx8r.sv \
	  	uflex_ilk_mx_nto1_r.sv	uflex_ilk_neq_24.sv uflex_ilk_priority_12.sv	uflex_ilk_priority_6.sv	uflex_ilk_priority_6_upper.sv	uflex_ilk_reg_delay.sv \
	  	uflex_ilk_reset_delay.sv	uflex_ilk_rst_sync.sv	uflex_ilk_scfifo_mlab.sv	uflex_ilk_status_sync.sv	uflex_ilk_sum_of_3bit_pair.sv	uflex_ilk_sync_fifo_mlab.sv	uflex_ilk_sync_fifo_mlab_2.sv	\
	  	uflex_ilk_wys_lut.sv	uflex_ilk_xor_lut.sv	uflex_ilk_xor_r.sv	uflex_ilk_xor_r_12w.sv uflex_ilk_or_r.sv uflex_ilk_one_hot_enc_16.sv uflex_ilk_one_hot_enc_8.sv uflex_ilk_nogap_one_12.sv uflex_ilk_nogap_one_8.sv \
        uflex_ilk_neq_5_ena.sv uflex_ilk_eq_5_ena.sv uflex_ilk_cross_bus.sv uflex_ilk_compressor_12to4.sv uflex_ilk_barrel_shift.sv uflex_ilk_barrel_layer.sv uflex_ilk_and_r.sv"
  
      add_fileset_file /uflex_ilk_top/uflex_ilk_core.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_core.sv
      add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_dcore.sv
  
  } else {
    
    set files_mac  "uflex_ilk_crc24_12.sv uflex_ilk_crc24_4.sv uflex_ilk_crc24_8.sv uflex_ilk_crc24_acc.sv uflex_ilk_crc24_evo10_2lut.sv uflex_ilk_crc24_evo11_2lut.sv uflex_ilk_crc24_evo12_2lut.sv \
	uflex_ilk_crc24_evo1_2lut.sv uflex_ilk_crc24_evo2_2lut.sv uflex_ilk_crc24_evo3_2lut.sv uflex_ilk_crc24_evo4_2lut.sv uflex_ilk_crc24_evo5_2lut.sv uflex_ilk_crc24_evo6_2lut.sv uflex_ilk_crc24_evo7_2lut.sv \
	uflex_ilk_crc24_evo8_2lut.sv uflex_ilk_crc24_evo9_2lut.sv uflex_ilk_crc24_in_n.sv uflex_ilk_crc24_n.sv uflex_ilk_iw48c_rx_crc24.sv uflex_ilk_iw48c_tx_crc24.sv uflex_ilk_iw8_addr_gen.sv \
	uflex_ilk_iw8_barrel_shift.sv uflex_ilk_iw8_burst_decode.sv uflex_ilk_iw8_enhance_scheduler.sv uflex_ilk_iw8_enhance_scheduler_ctrl.sv uflex_ilk_iw8_idle_gen.sv uflex_ilk_iw8_local_buffer.sv uflex_ilk_iw8_sync_ram.sv \
	uflex_ilk_iw8_tx_bs_control_rd.sv uflex_ilk_rx_crc24.sv uflex_ilk_rx_crc24_calendar.sv uflex_ilk_rx_crc24_scalable.sv uflex_ilk_rx_crc24_striper.sv uflex_ilk_rx_ibfc.sv uflex_ilk_rx_ibfc_err_handle.sv \
	uflex_ilk_rx_ila.sv uflex_ilk_tx_crc24.sv uflex_ilk_tx_crc24_scalable.sv uflex_ilk_tx_crc24_striper.sv uflex_ilk_tx_ext.sv uflex_ilk_tx_ext_iw8.sv uflex_ilk_tx_ibfc.sv \
	uflex_ilk_tx_ila.sv uflex_ilk_tx_intlv.sv"
     
    set files_components_sv "uflex_ilk_a10mlab.sv uflex_ilk_add3_cmp3.sv uflex_ilk_altera_syncram.sv uflex_ilk_and_r.sv uflex_ilk_barrel_layer.sv uflex_ilk_barrel_shift.sv uflex_ilk_compressor_12to4.sv \
	uflex_ilk_compressor_3to2.sv uflex_ilk_compressor_4to3.sv uflex_ilk_compressor_5to3.sv uflex_ilk_compressor_6to3.sv uflex_ilk_compressor_8to4.sv uflex_ilk_count_to_here_12.sv uflex_ilk_crc24_evo1.sv \
	uflex_ilk_crc24_evo10.sv uflex_ilk_crc24_evo11.sv uflex_ilk_crc24_evo12.sv uflex_ilk_crc24_evo2.sv uflex_ilk_crc24_evo3.sv uflex_ilk_crc24_evo4.sv uflex_ilk_crc24_evo5.sv \
	uflex_ilk_crc24_evo6.sv uflex_ilk_crc24_evo7.sv uflex_ilk_crc24_evo8.sv uflex_ilk_crc24_evo9.sv uflex_ilk_crc24_in12.sv uflex_ilk_crc24_in4.sv uflex_ilk_crc24_in8.sv \
	uflex_ilk_crc24_sig.sv uflex_ilk_cross_bus.sv uflex_ilk_delay_mlab.sv uflex_ilk_delay_regs.sv uflex_ilk_eq_12.sv uflex_ilk_eq_3.sv uflex_ilk_eq_5_ena.sv \
	uflex_ilk_fifo_4.sv uflex_ilk_fifo_8.sv uflex_ilk_frequency_monitor.sv uflex_ilk_index_with_restart_12.sv uflex_ilk_index_with_restart_3.sv uflex_ilk_index_with_restart_6.sv uflex_ilk_leftmost_one_12_1.sv \
	uflex_ilk_leftmost_one_12_2.sv uflex_ilk_leftmost_one_4.sv uflex_ilk_leftmost_one_8.sv uflex_ilk_m20k.sv uflex_ilk_mlab.sv uflex_ilk_mlab_fifo.sv uflex_ilk_mx12_ena.sv \
	uflex_ilk_mx16r.sv uflex_ilk_mx4r.sv uflex_ilk_mx8r.sv uflex_ilk_mx_nto1_r.sv uflex_ilk_neq_24.sv uflex_ilk_neq_5_ena.sv uflex_ilk_nogap_one_12.sv \
	uflex_ilk_nogap_one_8.sv uflex_ilk_one_hot_enc_16.sv uflex_ilk_one_hot_enc_8.sv uflex_ilk_or_r.sv uflex_ilk_page_dealer_12.sv uflex_ilk_page_grabber_12.sv uflex_ilk_priority_12.sv \
	uflex_ilk_priority_6.sv uflex_ilk_priority_6_upper.sv uflex_ilk_reg_delay.sv uflex_ilk_reset_delay.sv uflex_ilk_rst_sync.sv uflex_ilk_scfifo_mlab.sv uflex_ilk_status_sync.sv \
	uflex_ilk_sum_of_3bit_pair.sv uflex_ilk_sum_of_3bit_two_1bit.sv uflex_ilk_sync_fifo_mlab.sv uflex_ilk_sync_fifo_mlab_2.sv uflex_ilk_wys_lut.sv uflex_ilk_xor_lut.sv uflex_ilk_xor_r.sv \
	uflex_ilk_xor_r_12w.sv"

     if {$comp_extn} {
       
      set files_regroup_sv "uflex_ilk_burst_read_scheduler_iw16.sv  uflex_ilk_burst_read_scheduler_iw4.sv   uflex_ilk_burst_read_scheduler_iw8.sv   uflex_ilk_dcfifo_m20k_ecc.sv    uflex_ilk_m20k_ecc_1r1w.sv \
	    uflex_ilk_m20k_group.sv uflex_ilk_pkt_annotate.sv   uflex_ilk_rg_ctlw_iw12.sv   uflex_ilk_rg_ctlw_iw4.sv    uflex_ilk_rg_ctlw_iw8.sv   uflex_ilk_rg_dp.sv   uflex_ilk_rg_out_iw16.sv    uflex_ilk_rg_out_iw4.sv \
	    uflex_ilk_rg_out_iw8.sv uflex_ilk_rx_crc24_shift.sv uflex_ilk_rx_eob_gen.sv uflex_ilk_rx_regroup.sv uflex_ilk_rx_regroup_iw12_to_iw16.sv    uflex_ilk_rx_regroup_iw4.sv uflex_ilk_rx_regroup_iw8.sv \
	    uflex_ilk_rx_regroup_n.sv   uflex_ilk_seg_shift.sv  uflex_ilk_seg_shift_layer.sv    uflex_ilk_seg_shift_split.sv    uflex_ilk_wram_m20k.sv  uflex_ilk_wram_mult_inst.sv"
        
      foreach svfile $files_regroup_sv {
        add_fileset_file /synopsys/uflex_ilk_regroup/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_regroup/synopsys/${svfile} SYNOPSYS_SPECIFIC
        add_fileset_file /mentor/uflex_ilk_regroup/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_regroup/mentor/${svfile} MENTOR_SPECIFIC
        add_fileset_file /cadence/uflex_ilk_regroup/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_regroup/cadence/${svfile} CADENCE_SPECIFIC
      }
      
      
      set output_name  "uflex_ilk_core"
      set params(output_name)                  $output_name
      
      add_fileset_file /synopsys/uflex_ilk_regroup/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/synopsys/uflex_ilk_wys_lut.iv 
      add_fileset_file /mentor/uflex_ilk_regroup/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/mentor/uflex_ilk_wys_lut.iv 
      
      #add_fileset_file /uflex_ilk_top/uflex_ilk_core.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_core_ext.sv      
      add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_dcore_ext.sv      
      interpret_terp /uflex_ilk_top/uflex_ilk_core.sv  ../uflex_ilk_top/uflex_ilk_core_ext.sv.terp  [array get params]
    
    } else { 
     
      # set files_components_sv "	uflex_ilk_a10mlab.sv	uflex_ilk_add3_cmp3.sv	uflex_ilk_compressor_3to2.sv	uflex_ilk_compressor_4to3.sv uflex_ilk_compressor_5to3.sv uflex_ilk_compressor_6to3.sv uflex_ilk_count_to_here_12.sv \
    	# uflex_ilk_crc24_evo1.sv uflex_ilk_crc24_evo10.sv uflex_ilk_crc24_evo11.sv	uflex_ilk_crc24_evo12.sv	uflex_ilk_crc24_evo2.sv	uflex_ilk_crc24_evo3.sv	uflex_ilk_crc24_evo4.sv	uflex_ilk_crc24_evo5.sv \
	  	# uflex_ilk_crc24_evo6.sv uflex_ilk_crc24_evo7.sv	uflex_ilk_crc24_evo8.sv uflex_ilk_crc24_evo9.sv uflex_ilk_crc24_in12.sv uflex_ilk_crc24_in4.sv uflex_ilk_crc24_in8.sv uflex_ilk_crc24_sig.sv uflex_ilk_delay_mlab.sv \
	  	# uflex_ilk_delay_regs.sv uflex_ilk_eq_12.sv	uflex_ilk_eq_3.sv	uflex_ilk_frequency_monitor.sv	uflex_ilk_index_with_restart_12.sv	uflex_ilk_index_with_restart_3.sv	uflex_ilk_index_with_restart_6.sv \
	  	# uflex_ilk_leftmost_one_12_1.sv	uflex_ilk_leftmost_one_12_2.sv	uflex_ilk_leftmost_one_4.sv	uflex_ilk_leftmost_one_8.sv	uflex_ilk_mx12_ena.sv	uflex_ilk_mx16r.sv	uflex_ilk_mx4r.sv	uflex_ilk_mx8r.sv \
	  	# uflex_ilk_mx_nto1_r.sv	uflex_ilk_neq_24.sv uflex_ilk_page_dealer_12.sv	uflex_ilk_page_grabber_12.sv	uflex_ilk_priority_12.sv	uflex_ilk_priority_6.sv	uflex_ilk_priority_6_upper.sv	uflex_ilk_reg_delay.sv \
	  	# uflex_ilk_reset_delay.sv	uflex_ilk_rst_sync.sv	uflex_ilk_scfifo_mlab.sv	uflex_ilk_status_sync.sv	uflex_ilk_sum_of_3bit_pair.sv	uflex_ilk_sync_fifo_mlab.sv	uflex_ilk_sync_fifo_mlab_2.sv	\
	  	# uflex_ilk_wys_lut.sv	uflex_ilk_xor_lut.sv	uflex_ilk_xor_r.sv	uflex_ilk_xor_r_12w.sv"
    
      add_fileset_file /uflex_ilk_top/uflex_ilk_core.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_core.sv
      
      add_fileset_file /uflex_ilk_top/uflex_ilk_dcore.sv SYSTEM_VERILOG PATH ../uflex_ilk_top/uflex_ilk_dcore.sv
    }
  }
  
  set files_pcs "uflex_ilk_csr.sv uflex_ilk_rx_pcsif.sv uflex_ilk_rxa.sv uflex_ilk_tx_pcsif.sv uflex_ilk_txa.sv"
  set files_striper "uflex_ilk_striper_2n_to_n.sv uflex_ilk_striper_n_to_2n.sv uflex_ilk_rx_striper.sv uflex_ilk_striper_3n_to_n.sv uflex_ilk_striper_n_to_3n.sv uflex_ilk_striper_12_to_8.sv uflex_ilk_striper_8_to_12.sv uflex_ilk_tx_striper.sv"
  set files_uflex_top "uflex_ilk_rx.sv uflex_ilk_tx.sv" 
  
  foreach svfile $files_components_sv {
     add_fileset_file /synopsys/components/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../components/synopsys/${svfile} SYNOPSYS_SPECIFIC
     add_fileset_file /mentor/components/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../components/mentor/${svfile} MENTOR_SPECIFIC
     add_fileset_file /cadence/components/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../components/cadence/${svfile} CADENCE_SPECIFIC
  }
  
  if { 0 } {  
       add_fileset_file /synopsys/uflex_ilk_mac/uflex_ilk_wys_lut.ivp SYSTEM_VERILOG_INCLUDE PATH ../components/synopsys/uflex_ilk_wys_lut.ivp SYNOPSYS_SPECIFIC
   } else {
        add_fileset_file /synopsys/uflex_ilk_mac/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/synopsys/uflex_ilk_wys_lut.ivp SYNOPSYS_SPECIFIC
   }
  #add_fileset_file /mentor/components/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/mentor/uflex_ilk_wys_lut.iv MENTOR_SPECIFIC
  #add_fileset_file /cadence/components/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE ../components/cadence/uflex_ilk_wys_lut.iv CADENCE_SPECIFIC
  #add_fileset_file /synopsys/uflex_ilk_mac/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/uflex_ilk_wys_lut.iv
  add_fileset_file /mentor/uflex_ilk_mac/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/mentor/uflex_ilk_wys_lut.iv MENTOR_SPECIFIC
  #add_fileset_file /cadence/uflex_ilk_mac/uflex_ilk_wys_lut.iv SYSTEM_VERILOG_INCLUDE PATH ../components/uflex_ilk_wys_lut.iv
  
  foreach svfile $files_mac {
     add_fileset_file /synopsys/uflex_ilk_mac/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_mac/synopsys/${svfile} SYNOPSYS_SPECIFIC
     add_fileset_file /mentor/uflex_ilk_mac/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_mac/mentor/${svfile} MENTOR_SPECIFIC
     add_fileset_file /cadence/uflex_ilk_mac/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_mac/cadence/${svfile} CADENCE_SPECIFIC
  }
    
  foreach svfile $files_pcs {
     add_fileset_file /synopsys/uflex_ilk_pcs/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_pcs/synopsys/${svfile} SYNOPSYS_SPECIFIC
     add_fileset_file /mentor/uflex_ilk_pcs/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_pcs/mentor/${svfile} MENTOR_SPECIFIC
     add_fileset_file /cadence/uflex_ilk_pcs/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_pcs/cadence/${svfile} CADENCE_SPECIFIC     
  }
  
  foreach svfile $files_striper {
     add_fileset_file /synopsys/uflex_ilk_striper/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_striper/synopsys/${svfile} SYNOPSYS_SPECIFIC
     add_fileset_file /mentor/uflex_ilk_striper/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_striper/mentor/${svfile} MENTOR_SPECIFIC
     add_fileset_file /cadence/uflex_ilk_striper/${svfile} SYSTEM_VERILOG_ENCRYPT PATH ../uflex_ilk_striper/cadence/${svfile} CADENCE_SPECIFIC
  }  
  
  foreach svfile $files_uflex_top {
     add_fileset_file /uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/${svfile} 
	 #SYNOPSYS_SPECIFIC
     #add_fileset_file /mentor/uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/mentor/${svfile} MENTOR_SPECIFIC
     #add_fileset_file /cadence/uflex_ilk_top/${svfile} SYSTEM_VERILOG PATH ../uflex_ilk_top/cadence/${svfile} CADENCE_SPECIFIC
  }

}

proc interpret_terp {output_file_path terp_file_path passed_in_params {file_type "SYSTEM_VERILOG"}} {
    array set params $passed_in_params

    # get template
    set template_path $terp_file_path; # path to the TERP template
    set template_fd   [open $template_path] ;# file handle for template
    set template      [read $template_fd]   ;# template contents
    close $template_fd ;# we are done with the file so we should close it

    # process template with parameters
    set contents [altera_terp $template params] ;# pass parameter array in by reference
    add_fileset_file $output_file_path $file_type TEXT $contents
}