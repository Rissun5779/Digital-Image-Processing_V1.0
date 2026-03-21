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


global env
set QUARTUS_ROOTDIR $env(QUARTUS_ROOTDIR)
source ${QUARTUS_ROOTDIR}/../ip/altera/altera_pcie/altera_pcie_sv_hip_ast/pcie_sv_parameters_common.tcl

proc add_pcie_hip_parameters_ui_system_settings {} {
   send_message debug "proc:add_pcie_hip_parameters_ui_system_settings"

   set group_name "System Settings"

   # Device Family
   add_parameter INTENDED_DEVICE_FAMILY String "STRATIX V"
   set_parameter_property INTENDED_DEVICE_FAMILY SYSTEM_INFO DEVICE_FAMILY
   set_parameter_property INTENDED_DEVICE_FAMILY VISIBLE FALSE
   set_parameter_property INTENDED_DEVICE_FAMILY HDL_PARAMETER true


   # Gen1/Gen2
   add_parameter          lane_mask_hwtcl string "x8"
   set_parameter_property lane_mask_hwtcl DISPLAY_NAME "Number of lanes"
   set_parameter_property lane_mask_hwtcl ALLOWED_RANGES {"x4" "x8"}
   set_parameter_property lane_mask_hwtcl GROUP $group_name
   set_parameter_property lane_mask_hwtcl VISIBLE true
   set_parameter_property lane_mask_hwtcl HDL_PARAMETER true
   set_parameter_property lane_mask_hwtcl DESCRIPTION "Selects the maximum number of lanes supported. The IP core supports 1, 2, 4, or 8 lanes."

   # Gen1/Gen2
   add_parameter          gen123_lane_rate_mode_hwtcl string "Gen3 (8.0 Gbps)"
   set_parameter_property gen123_lane_rate_mode_hwtcl DISPLAY_NAME "Lane rate"
   set_parameter_property gen123_lane_rate_mode_hwtcl ALLOWED_RANGES {"Gen1 (2.5 Gbps)" "Gen2 (5.0 Gbps)" "Gen3 (8.0 Gbps)"}
   set_parameter_property gen123_lane_rate_mode_hwtcl GROUP $group_name
   set_parameter_property gen123_lane_rate_mode_hwtcl VISIBLE true
   set_parameter_property gen123_lane_rate_mode_hwtcl HDL_PARAMETER true
   set_parameter_property gen123_lane_rate_mode_hwtcl DESCRIPTION "Selects the maximum data rate of the link.Gen1 (2.5 Gbps), Gen3 (8.0 Gbps), and Gen2 (5.0 Gbps) are supported."

   # Selects the port type
   add_parameter          port_type_hwtcl string "Native endpoint"
   set_parameter_property port_type_hwtcl DISPLAY_NAME "Port type"
   set_parameter_property port_type_hwtcl ALLOWED_RANGES {"Native endpoint" "Root port"}
   set_parameter_property port_type_hwtcl GROUP $group_name
   set_parameter_property port_type_hwtcl VISIBLE false
   set_parameter_property port_type_hwtcl HDL_PARAMETER true
   set_parameter_property port_type_hwtcl DESCRIPTION "Selects the port type. Native Endpoints, Root Ports, and legacy Endpoints are supported."

   add_parameter          avmm_width_hwtcl integer 256
   set_parameter_property avmm_width_hwtcl DISPLAY_NAME "Data Width"
   #set_parameter_property avmm_width_hwtcl ALLOWED_RANGES {"64:64-bit" "128:128-bit" "256:256-bit"}
   set_parameter_property avmm_width_hwtcl ALLOWED_RANGES {"128:128-bit" "256:256-bit"}
   set_parameter_property avmm_width_hwtcl DESCRIPTION "Select datapath width on Avalon-ST and AVMM buses"
   set_parameter_property avmm_width_hwtcl GROUP $group_name
   set_parameter_property avmm_width_hwtcl VISIBLE true
   set_parameter_property avmm_width_hwtcl HDL_PARAMETER true

#   # RX Buffer Credit Setting
#   add_parameter          rxbuffer_rxreq_hwtcl string "Low"
#   set_parameter_property rxbuffer_rxreq_hwtcl DISPLAY_NAME "RX buffer credit  allocation - performance for received requests"
#   set_parameter_property rxbuffer_rxreq_hwtcl ALLOWED_RANGES {"Minimum" "Low" "Balanced" "High" "Maximum"}
#   set_parameter_property rxbuffer_rxreq_hwtcl GROUP $group_name
#   set_parameter_property rxbuffer_rxreq_hwtcl VISIBLE true
#   set_parameter_property rxbuffer_rxreq_hwtcl HDL_PARAMETER false
#   set_parameter_property rxbuffer_rxreq_hwtcl DESCRIPTION "Set the credits in the RX buffer for Posted, Non-Posted and Completion TLPs. The number of credits increases as the desired performance and maximum payload size increase."
#
   # x1 frequency
   add_parameter          set_pld_clk_x1_625MHz_hwtcl integer 0
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl DISPLAY_NAME "Use  62.5 MHz application clock"
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl DISPLAY_HINT boolean
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl GROUP $group_name
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl VISIBLE false
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl HDL_PARAMETER true
   set_parameter_property set_pld_clk_x1_625MHz_hwtcl DESCRIPTION "Only available in x1 configurations."

   # Enable RXM Burst Master
   add_parameter          enable_rxm_burst_hwtcl integer 0
   set_parameter_property enable_rxm_burst_hwtcl DISPLAY_NAME "Enable burst capabilities for RXM BAR2 and BAR3 ports"
   set_parameter_property enable_rxm_burst_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_rxm_burst_hwtcl GROUP $group_name
   set_parameter_property enable_rxm_burst_hwtcl VISIBLE false
   set_parameter_property enable_rxm_burst_hwtcl HDL_PARAMETER true
   set_parameter_property enable_rxm_burst_hwtcl DESCRIPTION "Enable burst capabilities for the RXM BAR2 and BAR3 ports. If this option is set to true, RXM BAR2 and BAR3 ports will be bursting masters. Otherwise, RXM BAR2 and BAR3 will be a single DW master."

   # ATX PLL HWTCL
   add_parameter          use_atx_pll_hwtcl integer 0
   set_parameter_property use_atx_pll_hwtcl DISPLAY_NAME "Use ATX PLL"
   set_parameter_property use_atx_pll_hwtcl DISPLAY_HINT boolean
   set_parameter_property use_atx_pll_hwtcl GROUP $group_name
   set_parameter_property use_atx_pll_hwtcl VISIBLE false
   set_parameter_property use_atx_pll_hwtcl HDL_PARAMETER true
   set_parameter_property use_atx_pll_hwtcl DESCRIPTION "When On, use ATX PLL instead of CMU PLL"

   # Multiple packets per cycle
   add_parameter          multiple_packets_per_cycle_hwtcl integer 0
   set_parameter_property multiple_packets_per_cycle_hwtcl DISPLAY_NAME "Enable multiple packets per cycle"
   set_parameter_property multiple_packets_per_cycle_hwtcl DISPLAY_HINT boolean
   set_parameter_property multiple_packets_per_cycle_hwtcl GROUP $group_name
   set_parameter_property multiple_packets_per_cycle_hwtcl VISIBLE false
   set_parameter_property multiple_packets_per_cycle_hwtcl HDL_PARAMETER true
   set_parameter_property multiple_packets_per_cycle_hwtcl DESCRIPTION "When On, the Avalon-ST interface supports the transmission of TLPs starting at any 64-bit address boundary, allowing support for multiple packets in a single cycle. To support multiple packets per cycle, the Avalon-ST interface includes either 2 or 4 start of packet and end of packet signals for the 128- and 256-bit Avalon-ST interfaces."


   #=========================================================================
   set group_name "SR-IOV System Settings"

   # TOTAL_PF_COUNT
   add_parameter          TOTAL_PF_COUNT integer 1
   set_parameter_property TOTAL_PF_COUNT DISPLAY_NAME "Total Active PFs"
   set_parameter_property TOTAL_PF_COUNT ALLOWED_RANGES {1}
   set_parameter_property TOTAL_PF_COUNT GROUP $group_name
   set_parameter_property TOTAL_PF_COUNT VISIBLE true
   set_parameter_property TOTAL_PF_COUNT HDL_PARAMETER true
   set_parameter_property TOTAL_PF_COUNT DESCRIPTION "Selects the number of Physical Function supported per Physical Function. Valid value is 1"

   # TOTAL_VF_COUNT
   add_parameter          TOTAL_VF_COUNT integer 4
   set_parameter_property TOTAL_VF_COUNT DERIVED true
   set_parameter_property TOTAL_VF_COUNT VISIBLE false
   set_parameter_property TOTAL_VF_COUNT HDL_PARAMETER true

   # PF0_VF_COUNT_USER
   add_parameter          PF0_VF_COUNT_USER integer 4
   set_parameter_property PF0_VF_COUNT_USER DISPLAY_NAME "Total PF0 VFs"
   set_parameter_property PF0_VF_COUNT_USER ALLOWED_RANGES {0:128}
   set_parameter_property PF0_VF_COUNT_USER GROUP $group_name
   set_parameter_property PF0_VF_COUNT_USER VISIBLE true
   set_parameter_property PF0_VF_COUNT_USER HDL_PARAMETER false
   set_parameter_property PF0_VF_COUNT_USER DESCRIPTION "Total VFs assigned to PF0. Single PF and no ARI: 0-7. Single PF with ARI Capability: 4-128 in multiple of 4. Two PFs with no ARI: 0-6. Two PFs with ARI Capability: 4-128 in multiple of 4. The sum of VFs assigned to both PF0 and PF1 should not exceed 128 VFs"


   # PF0_VF_COUNT (derived)
   add_parameter          PF0_VF_COUNT integer 4
   set_parameter_property PF0_VF_COUNT DERIVED true
   set_parameter_property PF0_VF_COUNT VISIBLE false
   set_parameter_property PF0_VF_COUNT HDL_PARAMETER true


   # PF1_VF_COUNT_USER
   add_parameter          PF1_VF_COUNT_USER integer 0
   set_parameter_property PF1_VF_COUNT_USER DISPLAY_NAME "Total PF1 VFs"
   set_parameter_property PF1_VF_COUNT_USER ALLOWED_RANGES {0:128}
   set_parameter_property PF1_VF_COUNT_USER GROUP $group_name
   set_parameter_property PF1_VF_COUNT_USER VISIBLE false
   set_parameter_property PF1_VF_COUNT_USER HDL_PARAMETER false
   set_parameter_property PF1_VF_COUNT_USER DESCRIPTION "Total VFs assigned to PF1. Single PF and no ARI: 0-7. Single PF with ARI Capability: 4-128 in multiple of 4. Two PFs with no ARI: 0-6. Two PFs with ARI Capability: 4-128 in multiple of 4. The sum of VFs assigned to both PF0 and PF1 should not exceed 128 VFs"

   # PF1_VF_COUNT (derived)
   add_parameter          PF1_VF_COUNT integer 0
   set_parameter_property PF1_VF_COUNT DERIVED true
   set_parameter_property PF1_VF_COUNT VISIBLE false
   set_parameter_property PF1_VF_COUNT HDL_PARAMETER true

   # ARI_SUPPORT
   add_parameter          ARI_SUPPORT integer 1
   set_parameter_property ARI_SUPPORT DISPLAY_NAME "ARI SUPPORT"
   set_parameter_property ARI_SUPPORT DISPLAY_HINT boolean
   set_parameter_property ARI_SUPPORT GROUP $group_name
   set_parameter_property ARI_SUPPORT VISIBLE true
   set_parameter_property ARI_SUPPORT HDL_PARAMETER true
   set_parameter_property ARI_SUPPORT DESCRIPTION "If true, will use "

   # SR_IOV_SUPPORT
   add_parameter          SR_IOV_SUPPORT integer 1
   set_parameter_property SR_IOV_SUPPORT DISPLAY_NAME "SR-IOV SUPPORT"
   set_parameter_property SR_IOV_SUPPORT DISPLAY_HINT boolean
   set_parameter_property SR_IOV_SUPPORT GROUP $group_name
   set_parameter_property SR_IOV_SUPPORT VISIBLE false
   set_parameter_property SR_IOV_SUPPORT HDL_PARAMETER true
   set_parameter_property SR_IOV_SUPPORT DESCRIPTION "If true, will use "

   # ACTIVE_VFS
   add_parameter ACTIVE_VFS integer 4
   set_parameter_property ACTIVE_VFS DISPLAY_NAME "Number of active VFs"
   #set_parameter_property ACTIVE_VFS ALLOWED_RANGES { "0:No VF" "1:2VFs" "2:4VFs" "3:8VFs" "4:16VFs" "5:32VFs" "6:64VFs" "7:128VFs"}
   set_parameter_property ACTIVE_VFS ALLOWED_RANGES { "0:No VF" "1:2VFs" "2:4VFs" "3:8VFs" "4:16VFs" "5:32VFs"}
   set_parameter_property ACTIVE_VFS GROUP $group_name
   set_parameter_property ACTIVE_VFS VISIBLE false
   set_parameter_property ACTIVE_VFS HDL_PARAMETER true
   set_parameter_property ACTIVE_VFS DESCRIPTION "Specify bits that represent the number of active VFs. These bits will be used as part of the RXM Address bus"

   # Enable CRA Slave Port
   add_parameter          enable_cra_hwtcl integer 0
   set_parameter_property enable_cra_hwtcl DISPLAY_NAME "Enable AVMM CRA Slave HIP Status port"
   set_parameter_property enable_cra_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_cra_hwtcl GROUP $group_name
   set_parameter_property enable_cra_hwtcl VISIBLE false
   set_parameter_property enable_cra_hwtcl HDL_PARAMETER true
   set_parameter_property enable_cra_hwtcl DESCRIPTION "Enable CRA Slave Port allowing access to selected HIP Config register values and link status"

   # COMPLETER_ONLY_HWTCL
   add_parameter          COMPLETER_ONLY_HWTCL integer 0
   set_parameter_property COMPLETER_ONLY_HWTCL DISPLAY_NAME "Completer-Only mode"
   set_parameter_property COMPLETER_ONLY_HWTCL DISPLAY_HINT boolean
   set_parameter_property COMPLETER_ONLY_HWTCL GROUP $group_name
   set_parameter_property COMPLETER_ONLY_HWTCL VISIBLE true
   set_parameter_property COMPLETER_ONLY_HWTCL HDL_PARAMETER true
   set_parameter_property COMPLETER_ONLY_HWTCL DESCRIPTION "If true, only support target single DW access. Otherwise support both DMA and target"

   # use_tx_cons_cred_sel_hwtcl
   add_parameter          use_tx_cons_cred_sel_hwtcl integer 0
   set_parameter_property use_tx_cons_cred_sel_hwtcl DISPLAY_NAME "Enable credit consumed selection port"
   set_parameter_property use_tx_cons_cred_sel_hwtcl DISPLAY_HINT boolean
   set_parameter_property use_tx_cons_cred_sel_hwtcl GROUP $group_name
   set_parameter_property use_tx_cons_cred_sel_hwtcl VISIBLE true
   set_parameter_property use_tx_cons_cred_sel_hwtcl HDL_PARAMETER false
   set_parameter_property use_tx_cons_cred_sel_hwtcl DESCRIPTION "The optional input port tx_cons_cred_sel could be used to retrieve the TX credit consumed HIP counter value "

   # enable_lmi_hwtcl
   add_parameter          enable_lmi_hwtcl integer 1
   set_parameter_property enable_lmi_hwtcl DISPLAY_NAME "LMI Interface"
   set_parameter_property enable_lmi_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_lmi_hwtcl GROUP $group_name
   set_parameter_property enable_lmi_hwtcl VISIBLE true
   set_parameter_property enable_lmi_hwtcl HDL_PARAMETER false
   set_parameter_property enable_lmi_hwtcl DESCRIPTION "If true, expose LMI ports"

   # enable_int_hwtcl
   add_parameter          enable_int_hwtcl integer 1
   set_parameter_property enable_int_hwtcl DISPLAY_NAME "Interrupt Interface"
   set_parameter_property enable_int_hwtcl DISPLAY_HINT boolean
   set_parameter_property enable_int_hwtcl GROUP $group_name
   set_parameter_property enable_int_hwtcl VISIBLE true
   set_parameter_property enable_int_hwtcl HDL_PARAMETER false
   set_parameter_property enable_int_hwtcl DESCRIPTION "If true, expose interrupt ports"

   #  Rxm Parameters
   set MAX_PREFETCH_MASTERS 6

 for { set i 0 } { $i < $MAX_PREFETCH_MASTERS } { incr i } {


        add_parameter "SLAVE_ADDRESS_MAP_$i" integer 0
        set_parameter_property "SLAVE_ADDRESS_MAP_$i" system_info_type ADDRESS_WIDTH
        set_parameter_property "SLAVE_ADDRESS_MAP_$i" system_info_arg "Rxm_BAR${i}"
        set_parameter_property "SLAVE_ADDRESS_MAP_$i" AFFECTS_ELABORATION true
        set_parameter_property "SLAVE_ADDRESS_MAP_$i" VISIBLE false

        add_parameter "PF0_VF_RXM_ADDR_MAP$i" integer 0
        set_parameter_property "PF0_VF_RXM_ADDR_MAP$i" system_info_type ADDRESS_WIDTH
        set_parameter_property "PF0_VF_RXM_ADDR_MAP$i" system_info_arg "pf0_vf_Rxm_BAR${i}"
        set_parameter_property "PF0_VF_RXM_ADDR_MAP$i" AFFECTS_ELABORATION true
        set_parameter_property "PF0_VF_RXM_ADDR_MAP$i" VISIBLE false

        add_parameter "CB_P2A_AVALON_ADDR_B${i}" integer "32'h00000000"
        set_parameter_property "CB_P2A_AVALON_ADDR_B${i}" "units" "Address"
        set_parameter_property  "CB_P2A_AVALON_ADDR_B${i}" VISIBLE FALSE
        set_parameter_property  "CB_P2A_AVALON_ADDR_B${i}" HDL_PARAMETER false

  }

        ##   DMA Read Master Size Map
        add_parameter "RD_SLAVE_ADDRESS_MAP" integer 1
        set_parameter_property "RD_SLAVE_ADDRESS_MAP" system_info_type ADDRESS_WIDTH
        set_parameter_property "RD_SLAVE_ADDRESS_MAP" system_info_arg "dmard_WrToFPGA"
        set_parameter_property "RD_SLAVE_ADDRESS_MAP" AFFECTS_ELABORATION true
        set_parameter_property "RD_SLAVE_ADDRESS_MAP" VISIBLE false

        ##   DMA Read Master Size Map
        add_parameter          "WR_SLAVE_ADDRESS_MAP" integer 1
        set_parameter_property "WR_SLAVE_ADDRESS_MAP" system_info_type ADDRESS_WIDTH
        set_parameter_property "WR_SLAVE_ADDRESS_MAP" system_info_arg "dmawr_RdFromFPGA"
        set_parameter_property "WR_SLAVE_ADDRESS_MAP" AFFECTS_ELABORATION true
        set_parameter_property "WR_SLAVE_ADDRESS_MAP" VISIBLE false

}

proc add_pcie_hip_parameters_bar_avmm {} {

   set MAX_PREFETCH_MASTERS 6
   add_parameter          NUM_PREFETCH_MASTERS integer 1
   set_parameter_property NUM_PREFETCH_MASTERS DISPLAY_NAME "Number of BARs"
   set_parameter_property NUM_PREFETCH_MASTERS ALLOWED_RANGES "0:$MAX_PREFETCH_MASTERS"
   set_parameter_property NUM_PREFETCH_MASTERS AFFECTS_ELABORATION true
   set_parameter_property NUM_PREFETCH_MASTERS VISIBLE FALSE

   add_pcie_hip_parameters_ui_pci_bar_avmm

   #By default, we have one 64 bit Bar
 #  for { set i 0 } { $i < $MAX_PREFETCH_MASTERS } { incr i } {
 #     add_parameter "CB_P2A_AVALON_ADDR_B${i}" integer "32'h00000000"
 #     set_parameter_property "CB_P2A_AVALON_ADDR_B${i}" "units" "Address"
 #     set_parameter_property  "CB_P2A_AVALON_ADDR_B${i}" VISIBLE FALSE
 #  }

   add_parameter "fixed_address_mode" string 0
   set_parameter_property  "fixed_address_mode" VISIBLE FALSE

   for { set i 0 } { $i < $MAX_PREFETCH_MASTERS } { incr i } {
      add_parameter "CB_P2A_FIXED_AVALON_ADDR_B${i}" integer "32'h00000000"
      set_parameter_property  "CB_P2A_FIXED_AVALON_ADDR_B${i}" VISIBLE FALSE
   }
}


# ====================================
proc add_avalon_mm_parameters {} {
   # +------------------------------PAGE 6 ( Avalon )-------------------------------------------------------------
   send_message debug "proc:add_avalon_mm_parameters"

   set group_name "Avalon-MM System Settings"

   add_parameter CG_COMMON_CLOCK_MODE integer 1
   set_parameter_property  CG_COMMON_CLOCK_MODE VISIBLE false

  # add_parameter          avmm_burst_width_hwtcl integer 7
  # set_parameter_property avmm_burst_width_hwtcl VISIBLE false
  # set_parameter_property avmm_burst_width_hwtcl DERIVED true
  # set_parameter_property avmm_burst_width_hwtcl HDL_PARAMETER true


   add_parameter CG_RXM_IRQ_NUM integer 16
   set_parameter_property  CG_RXM_IRQ_NUM VISIBLE false

  # ==================
  set group_name_address_trans "TXS PCIe Host Address Size "

    add_parameter          TX_S_ADDR_WIDTH integer 32
    set_parameter_property TX_S_ADDR_WIDTH DISPLAY_NAME "Address width of accessible PCIe memory space"
    set_parameter_property TX_S_ADDR_WIDTH ALLOWED_RANGES {20:64}
    set_parameter_property TX_S_ADDR_WIDTH DESCRIPTION "The address width of accessible memory space"
    set_parameter_property TX_S_ADDR_WIDTH GROUP $group_name_address_trans
    set_parameter_property TX_S_ADDR_WIDTH VISIBLE true
    set_parameter_property TX_S_ADDR_WIDTH HDL_PARAMETER true

   #-----------------------------------------------------------------------------------------------------------------
  # DMA Width derived parameters
  # ============================

   set group_name "FPGA DMA Derived Address Size (Valid after system is connected)"
   add_parameter          rd_dma_size_mask_hwtcl integer 1
   set_parameter_property rd_dma_size_mask_hwtcl DISPLAY_NAME "DMA-Read Size"
   set_parameter_property rd_dma_size_mask_hwtcl GROUP $group_name
   set_parameter_property rd_dma_size_mask_hwtcl VISIBLE true
   set_parameter_property rd_dma_size_mask_hwtcl DERIVED true
   set_parameter_property rd_dma_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property rd_dma_size_mask_hwtcl DESCRIPTION "DMA-Read address size derived from user logic connected to this bus"

  # add_display_item "Master Address Width" "DMA-Write" group
  # set_display_item_property "DMA-Write" display_hint tab

   add_parameter          wr_dma_size_mask_hwtcl integer 8
   set_parameter_property wr_dma_size_mask_hwtcl DISPLAY_NAME "DMA-Write Size"
   set_parameter_property wr_dma_size_mask_hwtcl GROUP $group_name
   set_parameter_property wr_dma_size_mask_hwtcl VISIBLE true
   set_parameter_property wr_dma_size_mask_hwtcl DERIVED true
   set_parameter_property wr_dma_size_mask_hwtcl HDL_PARAMETER true
   set_parameter_property wr_dma_size_mask_hwtcl DESCRIPTION "DMA-Write address size derived from user logic connected to this bus"

}

# ====================================
# Need the following parameters to derive PLD_CLK
proc add_pcie_hip_hidden_rtl_parameters {} {

   add_parameter          port_width_be_hwtcl integer 32
   set_parameter_property port_width_be_hwtcl VISIBLE false
   set_parameter_property port_width_be_hwtcl HDL_PARAMETER true
   set_parameter_property port_width_be_hwtcl DERIVED true

   add_parameter          port_width_data_hwtcl integer 256
   set_parameter_property port_width_data_hwtcl VISIBLE false
   set_parameter_property port_width_data_hwtcl DERIVED true
   set_parameter_property port_width_data_hwtcl HDL_PARAMETER true

   add_parameter          pld_clk_MHz integer 125
   set_parameter_property pld_clk_MHz VISIBLE false
   set_parameter_property pld_clk_MHz HDL_PARAMETER false
   set_parameter_property pld_clk_MHz DERIVED true
}

# ====================================
# PCIe BARs parameters
proc add_pcie_hip_parameters_ui_pci_bar_avmm {} {

   send_message debug "proc: add_pcie_hip_parameters_ui_pci_bar_avmm"

   #-----------------------------------------------------------------------------------------------------------------
   set master_group_name "PF0 Base Address Registers"
   add_display_item "" ${master_group_name} group

   for { set i 0 } { $i < 6 } { incr i } {
       set group_name "PF0_BAR${i}"
       add_display_item ${master_group_name} ${group_name} group
       set_display_item_property ${group_name} display_hint tab
   }

   #===========================================
   # PF0 BARs
   #===========================================
   for { set i 0 } { $i < 6 } { incr i } {
      set group_name "PF0_BAR${i}"

      #Only enable BAR0
      if { ($i == 0) } {
        add_parameter          PF0_BAR${i}_PRESENT integer 1
      } else {
        add_parameter          PF0_BAR${i}_PRESENT integer 0
      }
      set_parameter_property PF0_BAR${i}_PRESENT DISPLAY_NAME "Present"
      set_parameter_property PF0_BAR${i}_PRESENT ALLOWED_RANGES { "0:Disabled" "1:Enabled" }
      set_parameter_property PF0_BAR${i}_PRESENT GROUP $group_name
      set_parameter_property PF0_BAR${i}_PRESENT VISIBLE true
      set_parameter_property PF0_BAR${i}_PRESENT HDL_PARAMETER true
      set_parameter_property PF0_BAR${i}_PRESENT DESCRIPTION "Sets Physical Function BAR Present bit."

      if { ($i == 0)  || ($i == 2) || ($i == 4)} {
         add_parameter          PF0_BAR${i}_TYPE integer 64
         set_parameter_property PF0_BAR${i}_TYPE DISPLAY_NAME "Type"
         set_parameter_property PF0_BAR${i}_TYPE ALLOWED_RANGES {"32:32-bit address" "64:64-bit address"}
         set_parameter_property PF0_BAR${i}_TYPE GROUP $group_name
         set_parameter_property PF0_BAR${i}_TYPE VISIBLE true
         set_parameter_property PF0_BAR${i}_TYPE HDL_PARAMETER true
         set_parameter_property PF0_BAR${i}_TYPE DESCRIPTION "Selects either a 64-or 32-bit BAR. When 64 bits, BARs 0 and 1 combine to form a single BAR."
      } else {
         add_parameter          PF0_BAR${i}_TYPE integer 32
         set_parameter_property PF0_BAR${i}_TYPE DISPLAY_NAME "Type"
         set_parameter_property PF0_BAR${i}_TYPE GROUP $group_name
         set_parameter_property PF0_BAR${i}_TYPE DERIVED true
         set_parameter_property PF0_BAR${i}_TYPE VISIBLE false
         set_parameter_property PF0_BAR${i}_TYPE HDL_PARAMETER true
         set_parameter_property PF0_BAR${i}_TYPE DESCRIPTION "Odd BARs can only be 32bit by itself"
      }

    #  add_parameter          PF0_BAR${i}_PREFETCHABLE integer 1
    #  set_parameter_property PF0_BAR${i}_PREFETCHABLE DISPLAY_NAME "Prefetchable"
    #  set_parameter_property PF0_BAR${i}_PREFETCHABLE ALLOWED_RANGES { "0:Non-Prefetchable" "1:Prefetchable" }
    #  set_parameter_property PF0_BAR${i}_PREFETCHABLE GROUP $group_name
    #  set_parameter_property PF0_BAR${i}_PREFETCHABLE VISIBLE true
    #  set_parameter_property PF0_BAR${i}_PREFETCHABLE HDL_PARAMETER true
    #  set_parameter_property PF0_BAR${i}_PREFETCHABLE DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable. The 64-bit BAR is always prefetchable."

      add_parameter          PF0_BAR${i}_SIZE integer 12
      set_parameter_property PF0_BAR${i}_SIZE DISPLAY_NAME "Size"
      set_parameter_property PF0_BAR${i}_SIZE ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits"}
      set_parameter_property PF0_BAR${i}_SIZE GROUP $group_name
      set_parameter_property PF0_BAR${i}_SIZE VISIBLE true
      set_parameter_property PF0_BAR${i}_SIZE HDL_PARAMETER true
      set_parameter_property PF0_BAR${i}_SIZE DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."
}

   #-----------------------------------------------------------------------------------------------------------------
   set master_group_name "PF0 VF Base Address Registers"
   add_display_item "" ${master_group_name} group

   for { set i 0 } { $i < 6 } { incr i } {
       set group_name "PF0_VF_BAR${i}"
       add_display_item ${master_group_name} ${group_name} group
       set_display_item_property ${group_name} display_hint tab
   }

   for { set i 0 } { $i < 6 } { incr i } {
      set group_name "PF0_VF_BAR${i}"

      # Only enable BAR0
      if { ($i  == 0) } {
        add_parameter          PF0_VF_BAR${i}_PRESENT integer 1
      } else {
        add_parameter          PF0_VF_BAR${i}_PRESENT integer 0
      }
      set_parameter_property PF0_VF_BAR${i}_PRESENT DISPLAY_NAME "Present"
      set_parameter_property PF0_VF_BAR${i}_PRESENT ALLOWED_RANGES { "0:Disabled" "1:Enabled" }
      set_parameter_property PF0_VF_BAR${i}_PRESENT GROUP $group_name
      set_parameter_property PF0_VF_BAR${i}_PRESENT VISIBLE true
      set_parameter_property PF0_VF_BAR${i}_PRESENT HDL_PARAMETER true
      set_parameter_property PF0_VF_BAR${i}_PRESENT DESCRIPTION "Sets Physical Function BAR Present bit."

      if { ($i == 0)  || ($i == 2) || ($i == 4)} {
         add_parameter          PF0_VF_BAR${i}_TYPE integer 64
         set_parameter_property PF0_VF_BAR${i}_TYPE DISPLAY_NAME "Type"
         set_parameter_property PF0_VF_BAR${i}_TYPE ALLOWED_RANGES { "32:32-bit address" "64:64-bit address" }
         set_parameter_property PF0_VF_BAR${i}_TYPE GROUP $group_name
         set_parameter_property PF0_VF_BAR${i}_TYPE VISIBLE true
         set_parameter_property PF0_VF_BAR${i}_TYPE HDL_PARAMETER true
         set_parameter_property PF0_VF_BAR${i}_TYPE DESCRIPTION "Selects either a 64-or 32-bit BAR. When 64 bits, BARs 0 and 1 combine to form a single BAR."
      } else {
         add_parameter          PF0_VF_BAR${i}_TYPE integer 32
         set_parameter_property PF0_VF_BAR${i}_TYPE DISPLAY_NAME "Type"
         set_parameter_property PF0_VF_BAR${i}_TYPE GROUP $group_name
         set_parameter_property PF0_VF_BAR${i}_TYPE DERIVED true
         set_parameter_property PF0_VF_BAR${i}_TYPE VISIBLE false
         set_parameter_property PF0_VF_BAR${i}_TYPE HDL_PARAMETER true
         set_parameter_property PF0_VF_BAR${i}_TYPE DESCRIPTION "Odd BARs can only be 32bit by itself"
      }
     # add_parameter          PF0_VF_BAR${i}_PREFETCHABLE integer 1
     # set_parameter_property PF0_VF_BAR${i}_PREFETCHABLE DISPLAY_NAME "Prefetchable"
     # set_parameter_property PF0_VF_BAR${i}_PREFETCHABLE ALLOWED_RANGES { "0:Non-Prefetchable" "1:Prefetchable" }
     # set_parameter_property PF0_VF_BAR${i}_PREFETCHABLE GROUP $group_name
     # set_parameter_property PF0_VF_BAR${i}_PREFETCHABLE VISIBLE true
     # set_parameter_property PF0_VF_BAR${i}_PREFETCHABLE HDL_PARAMETER true
     # set_parameter_property PF0_VF_BAR${i}_PREFETCHABLE DESCRIPTION "Specifies whether or not the 32-bit BAR is prefetchable. The 64-bit BAR is always prefetchable."
      add_parameter          PF0_VF_BAR${i}_SIZE integer 12
      set_parameter_property PF0_VF_BAR${i}_SIZE DISPLAY_NAME "Size"
      set_parameter_property PF0_VF_BAR${i}_SIZE ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits"}
      set_parameter_property PF0_VF_BAR${i}_SIZE GROUP $group_name
      set_parameter_property PF0_VF_BAR${i}_SIZE VISIBLE true
      set_parameter_property PF0_VF_BAR${i}_SIZE HDL_PARAMETER true
      set_parameter_property PF0_VF_BAR${i}_SIZE DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."
  }

}


#=============================================
proc isBarUsed { index } {
    set result 1
    # split the contents on ,
    set bar_type_list [split [ get_parameter_value "BAR Type" ] ","]
    set value_at_index [lindex $bar_type_list $index]
    if {[ string compare -nocase $value_at_index "Not used" ] == 0 } {
        set result 0
    }
    return $result
}

#=============================================
proc is64bitBar { index } {

    set result 0
    # split the contents on ,
    set bar_type_list [split [ get_parameter_value "BAR Type" ] ","]
    set value_at_index [lindex $bar_type_list $index]
    if {[ string compare -nocase $value_at_index "64 bit Prefetchable" ] == 0 } {
        set result 1
    }
    return $result
}

#=============================================
proc validation_parameter_system_setting {} {

   set ast_width_hwtcl             [ get_parameter_value avmm_width_hwtcl            ]
   set lane_mask_hwtcl             [ get_parameter_value lane_mask_hwtcl             ]
   set gen123_lane_rate_mode_hwtcl [ get_parameter_value gen123_lane_rate_mode_hwtcl ]
   set set_pld_clk_x1_625MHz_hwtcl [ get_parameter_value set_pld_clk_x1_625MHz_hwtcl ]
   set use_atx_pll                 [ get_parameter_value use_atx_pll_hwtcl     ]

   if { $set_pld_clk_x1_625MHz_hwtcl == 1 } {
      if { [ regexp x1 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] && [ regexp $use_atx_pll 0 ] } {
         send_message info "The application clock frequency (pld_clk) is 62.5 Mhz"
      } else {
         send_message error "62.5 Mhz application clock setting is only valid for Gen1 x1 with CMU PLL"
      }
   }


   if { [ regexp x1 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen1:x1
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         if { $set_pld_clk_x1_625MHz_hwtcl == 0 } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
         } else {
            send_message info "The application clock frequency (pld_clk) is 62.5 Mhz"
            set_parameter_value pld_clk_MHz 625
         }
      }
   } elseif { [ regexp x1 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen2:x1
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
      }
   } elseif { [ regexp x1 $lane_mask_hwtcl ] && [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen3:x1
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
      }
   } elseif { [ regexp x2 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ]  } {
   # Gen1:x2
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
      }
   } elseif { [ regexp x2 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ]  } {
   # Gen2:x2
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
      }
   } elseif { [ regexp x2 $lane_mask_hwtcl ] && [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ]  } {
   # Gen3:x2
      if { [ regexp 256 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit or 128-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 128 $ast_width_hwtcl ] } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
         } else {
            send_message info "The application clock frequency (pld_clk) is 250 Mhz"
            set_parameter_value pld_clk_MHz 2500
         }
      }
   } elseif { [ regexp x4 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen1:x4
      if { [ regexp 256 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 125 Mhz"
         set_parameter_value pld_clk_MHz 1250
      }
   } elseif { [ regexp x4 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen2:x4
      if { [ regexp 256 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit or 128-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 128 $ast_width_hwtcl ] } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
         } else {
            send_message info "The application clock frequency (pld_clk) is 250 Mhz"
            set_parameter_value pld_clk_MHz 2500
         }
      }
   } elseif { [ regexp x4 $lane_mask_hwtcl ] && [ regexp Gen3 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen3:x4
      if { [ regexp 64 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 128-bit or 256-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 256 $ast_width_hwtcl ] } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
         } else {
            send_message info "The application clock frequency (pld_clk) is 250 Mhz"
            set_parameter_value pld_clk_MHz 2500
         }
      }
   } elseif { [ regexp x8 $lane_mask_hwtcl ] && [ regexp Gen1 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen1:x8
      if { [ regexp 256 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 64-bit or 128-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 128 $ast_width_hwtcl ] } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
         } else {
            send_message info "The application clock frequency (pld_clk) is 250 Mhz"
            set_parameter_value pld_clk_MHz 2500
         }
      }
   } elseif { [ regexp x8 $lane_mask_hwtcl ] && [ regexp Gen2 $gen123_lane_rate_mode_hwtcl ] } {
   # Gen2:x8
      if { [ regexp 64 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 256-bit or 128-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         if { [ regexp 256 $ast_width_hwtcl ] } {
            send_message info "The application clock frequency (pld_clk) is 125 Mhz"
            set_parameter_value pld_clk_MHz 1250
         } else {
            send_message info "The application clock frequency (pld_clk) is 250 Mhz"
            set_parameter_value pld_clk_MHz 2500
         }
      }
   } else {
   # Gen3:x8
      if { [ regexp 64 $ast_width_hwtcl ] || [ regexp 128 $ast_width_hwtcl ] } {
         send_message error "The application interface must be set to Avalon-ST 256-bit when using $lane_mask_hwtcl $gen123_lane_rate_mode_hwtcl"
      } else {
         send_message info "The application clock frequency (pld_clk) is 250 Mhz"
         set_parameter_value pld_clk_MHz 2500
      }
   }


   ##################################################################################################
   #
   # Setting AST Port width parameters
   set dataWidth        [ expr [ regexp 256 $ast_width_hwtcl  ] ? 256 : [ regexp 128 $ast_width_hwtcl ] ? 128 : 64 ]
   set dataByteWidth    [ expr [ regexp 256 $ast_width_hwtcl  ] ? 32  : [ regexp 128 $ast_width_hwtcl ] ? 16 : 8 ]
   set dataEmptyWidth   [ expr [ regexp 256 $ast_width_hwtcl  ] ? 2  : 1 ]

   set_parameter_value port_width_data_hwtcl      $dataWidth
   set_parameter_value port_width_be_hwtcl        $dataByteWidth


   ##################################################################################################
   #
   # Interface properties update
   set pld_clk_MHz [ get_parameter_value pld_clk_MHz ]
   set_interface_property pld_clk_hip clockRate [expr {$pld_clk_MHz * 100000}]

    #########################################################################################################
   #
   # Set RXM Data With paramter

}

proc validation_parameter_prj_setting {} {
   # Check that device used is Stratix V
   send_message warning "PRELIMINARY SUPPORT: Component 'Avalon-MM SR-IOV DMA for PCI Express SUBJECT TO CHANGE"
   set INTENDED_DEVICE_FAMILY [ get_parameter_value INTENDED_DEVICE_FAMILY]
   send_message info "Family: $INTENDED_DEVICE_FAMILY"
   if { ([string compare -nocase $INTENDED_DEVICE_FAMILY "Stratix V"] != 0) && ([string compare -nocase $INTENDED_DEVICE_FAMILY "Arria V GZ"] != 0) &&
        ([string compare -nocase $INTENDED_DEVICE_FAMILY "Arria 10"] != 0) } {
      send_message error "Selected device family: $INTENDED_DEVICE_FAMILY is not supported"
   }
}

#========================
proc validation_parameter_pf0_bar {} {

   set  port_type_hwtcl [ get_parameter_value port_type_hwtcl ]

   set  bar_size_mask_hwtcl(0) [ get_parameter_value PF0_BAR0_SIZE]
   set  bar_size_mask_hwtcl(1) [ get_parameter_value PF0_BAR1_SIZE]
   set  bar_size_mask_hwtcl(2) [ get_parameter_value PF0_BAR2_SIZE]
   set  bar_size_mask_hwtcl(3) [ get_parameter_value PF0_BAR3_SIZE]

   set  bar_ignore_warning_size(0) 0
   set  bar_ignore_warning_size(1) 0
   set  bar_ignore_warning_size(2) 0
   set  bar_ignore_warning_size(3) 0
   set  bar_ignore_warning_size(4) 0
   set  bar_ignore_warning_size(5) 0

   # BAR present
   set  bar_present_hwtcl(0) [ get_parameter_value PF0_BAR0_PRESENT]
   set  bar_present_hwtcl(1) [ get_parameter_value PF0_BAR1_PRESENT]
   set  bar_present_hwtcl(2) [ get_parameter_value PF0_BAR2_PRESENT]
   set  bar_present_hwtcl(3) [ get_parameter_value PF0_BAR3_PRESENT]

   # BAR Type: 1 = 64bit, 0 = 32bit
   set  bar_type_hwtcl(0) [ get_parameter_value PF0_BAR0_TYPE]
   set  bar_type_hwtcl(2) [ get_parameter_value PF0_BAR2_TYPE]

   set DISABLE_BAR             0
   set PREFETACHBLE_64_BAR     64

   if { [ regexp endpoint $port_type_hwtcl ] } {
      if { $bar_present_hwtcl(0) == $DISABLE_BAR && $bar_present_hwtcl(1) == $DISABLE_BAR && $bar_present_hwtcl(2) == $DISABLE_BAR && $bar_present_hwtcl(3) == $DISABLE_BAR } {
         send_message error "An Endpoint requires to enable a minimum of one BAR"
      }
      # 64-bit address checking
      for {set i 0} {$i < 4} {incr i 2} {
         if { (($i==0) || ($i==2)) && ($bar_type_hwtcl($i) == $PREFETACHBLE_64_BAR) } {
            set ii [ expr $i+1 ]
            set bar_ignore_warning_size($ii) 1
            if { $bar_present_hwtcl($ii) > 0 } {
              # set bar_present_hwtcl($ii) $DISABLE_BAR;
              # send_message warning "BAR$ii is disabled as BAR$i is set to 64-bit prefetchable memory"
               send_message error "BAR$ii should be disabled as BAR$i is set to 64-bit prefetchable memory"
            }
         }
      }
   } else {
      set expansion_base_address_register [ get_parameter_value expansion_base_address_register_hwtcl ]
      if { $expansion_base_address_register > 0 } {
         send_message error "Expansion ROM must be Disabled when using Root port"
      }
      for {set i 2} {$i < 4} {incr i 1} {
         if {  $bar_present_hwtcl($i) > 0 } {
            send_message error "BAR$i: must be Disabled when using Root port"
         }
      }
   }

   # Setting derived parameter
   for {set i 0} {$i < 4} {incr i 1} {
      if { $bar_present_hwtcl($i)>0 } {
         if { $bar_size_mask_hwtcl($i)==0 && $bar_ignore_warning_size($i)==0 } {
            send_message error "The size of BAR$i is incorrectly set"
         }
      }
   }
}

proc validation_parameter_pf0_vf_bar {} {

   set  port_type_hwtcl [ get_parameter_value port_type_hwtcl ]

   set  bar_size_mask_hwtcl(0) [ get_parameter_value PF0_VF_BAR0_SIZE]
   set  bar_size_mask_hwtcl(1) [ get_parameter_value PF0_VF_BAR1_SIZE]
   set  bar_size_mask_hwtcl(2) [ get_parameter_value PF0_VF_BAR2_SIZE]
   set  bar_size_mask_hwtcl(3) [ get_parameter_value PF0_VF_BAR3_SIZE]
   set  bar_size_mask_hwtcl(4) [ get_parameter_value PF0_VF_BAR4_SIZE]
   set  bar_size_mask_hwtcl(5) [ get_parameter_value PF0_VF_BAR5_SIZE]

   set  bar_ignore_warning_size(0) 0
   set  bar_ignore_warning_size(1) 0
   set  bar_ignore_warning_size(2) 0
   set  bar_ignore_warning_size(3) 0
   set  bar_ignore_warning_size(4) 0
   set  bar_ignore_warning_size(5) 0

   # BAR present
   set  bar_present_hwtcl(0) [ get_parameter_value PF0_VF_BAR0_PRESENT]
   set  bar_present_hwtcl(1) [ get_parameter_value PF0_VF_BAR1_PRESENT]
   set  bar_present_hwtcl(2) [ get_parameter_value PF0_VF_BAR2_PRESENT]
   set  bar_present_hwtcl(3) [ get_parameter_value PF0_VF_BAR3_PRESENT]
   set  bar_present_hwtcl(4) [ get_parameter_value PF0_VF_BAR4_PRESENT]
   set  bar_present_hwtcl(5) [ get_parameter_value PF0_VF_BAR5_PRESENT]

   # BAR Type: 1 = 64bit, 0 = 32bit
   set  bar_type_hwtcl(0) [ get_parameter_value PF0_VF_BAR0_TYPE]
   set  bar_type_hwtcl(2) [ get_parameter_value PF0_VF_BAR2_TYPE]
   set  bar_type_hwtcl(4) [ get_parameter_value PF0_VF_BAR4_TYPE]

   set DISABLE_BAR             0
   set PREFETACHBLE_64_BAR     64

   if { [ regexp endpoint $port_type_hwtcl ] } {
      if { $bar_present_hwtcl(0) == $DISABLE_BAR && $bar_present_hwtcl(1) == $DISABLE_BAR && $bar_present_hwtcl(2) == $DISABLE_BAR && $bar_present_hwtcl(3) == $DISABLE_BAR } {
         send_message error "An Endpoint requires to enable a minimum of one BAR"
      }
      # 64-bit address checking
      for {set i 0} {$i < 6} {incr i 2} {
         if { (($i==0) || ($i==2)) && ($bar_type_hwtcl($i) == $PREFETACHBLE_64_BAR) } {
            set ii [ expr $i+1 ]
            set bar_ignore_warning_size($ii) 1
            if { $bar_present_hwtcl($ii) > 0 } {
              # set bar_present_hwtcl($ii) $DISABLE_BAR;
              # send_message warning "BAR$ii is disabled as BAR$i is set to 64-bit prefetchable memory"
               send_message error "BAR$ii should be disabled as BAR$i is set to 64-bit prefetchable memory"
            }
         }
      }
   }
}

#================================
# Validation for total_vf_count
#================================
proc validation_total_vf_count {} {

   set PF0_VF_COUNT_USER                       [ get_parameter_value PF0_VF_COUNT_USER   ]
   set PF1_VF_COUNT_USER                       [ get_parameter_value PF1_VF_COUNT_USER   ]
   set ARI_SUPPORT                             [ get_parameter_value ARI_SUPPORT    ]
   set SR_IOV_SUPPORT                          [ get_parameter_value SR_IOV_SUPPORT ]
   set TOTAL_PF_COUNT                          [ get_parameter_value TOTAL_PF_COUNT ]

   #=========================================================================
   # Derived and validate TOTAL_VF_COUNT = Sum of both PF0 and PF1 VF_COUNT
   set TOTAL_VF               [ expr {$PF0_VF_COUNT_USER + $PF1_VF_COUNT_USER}]
   set PF0_VF_COUNT_MOD_4     [ expr {$PF0_VF_COUNT_USER % 4}]
   set PF1_VF_COUNT_MOD_4     [ expr {$PF1_VF_COUNT_USER % 4}]

   if ($SR_IOV_SUPPORT) {
      set_parameter_value TOTAL_VF_COUNT $TOTAL_VF
      set_parameter_value PF0_VF_COUNT $PF0_VF_COUNT_USER
      set_parameter_value PF1_VF_COUNT $PF1_VF_COUNT_USER

      if { ($TOTAL_PF_COUNT==1) && ($PF1_VF_COUNT_USER >  0) } {
         send_message error "Total VF Counts for PF1 must be zero because only PF0 is active (TOTAL Active PFs = 1)"
      }

      if { ($TOTAL_PF_COUNT==1) && ($ARI_SUPPORT == 0) && ($TOTAL_VF >  7) } {
         send_message error "Total VF Counts for PF0 must be less than 7 when ARI is disabled"
      } elseif {($TOTAL_PF_COUNT==1) && ($ARI_SUPPORT == 1) && (($TOTAL_VF < 4) || ($TOTAL_VF >  128) ) } {
         send_message error "Total VF Counts for PF0 must be between 4-128 when ARI is enabled"
      } elseif {($TOTAL_PF_COUNT==1) && ($ARI_SUPPORT == 1) && ($PF0_VF_COUNT_MOD_4 ) } {
         send_message error "If ARI is enabled and only PF0 is active, PF0 VF value must be multiples of 4 and within 4-128 range"
      }

      if { ($TOTAL_PF_COUNT==2) && ($ARI_SUPPORT == 0) && ($TOTAL_VF >  6) } {
         send_message error "Total VF Counts for both PF0 and PF1 must be less than 6 when ARI is disabled"
      } elseif {($TOTAL_PF_COUNT==2) && ($ARI_SUPPORT == 1) && (($TOTAL_VF < 4) || ($TOTAL_VF >  128) ) } {
         send_message error "Total VF Counts for both PF0 and PF1 must be between 4-128 when ARI is enabled"
      } elseif {($TOTAL_PF_COUNT==2) && ($ARI_SUPPORT == 1) && ($PF0_VF_COUNT_MOD_4 ) } {
         send_message error "PF0 VF Count value must be multiples of 4 and within 4-128 range if ARI is enabled and both PF0 and PF1 are active"
      } elseif {($TOTAL_PF_COUNT==2) && ($ARI_SUPPORT == 1) && ($PF1_VF_COUNT_MOD_4 ) } {
         send_message error "PF1 VF Count value must be multiples of 4 and within 4-128 range if ARI is enabled and both PF0 and PF1 are active"
      }
  } else {
      set_parameter_value TOTAL_VF_COUNT 4
      set_parameter_value PF0_VF_COUNT 4
      set_parameter_value PF1_VF_COUNT 0
  }
}

