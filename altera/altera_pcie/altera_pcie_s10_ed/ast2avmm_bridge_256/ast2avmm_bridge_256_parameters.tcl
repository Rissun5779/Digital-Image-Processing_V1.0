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

proc add_parameters_ui_system_settings {} {
   send_message debug "proc:add_parameters_ui_system_settings"

   set group_name "System Settings"

   add_parameter pcie_qsys integer 1
   set_parameter_property pcie_qsys VISIBLE false

   # Application Interface
   add_parameter          DBUS_WIDTH integer 256
   set_parameter_property DBUS_WIDTH DISPLAY_NAME "Avalon-ST interface width"
   set_parameter_property DBUS_WIDTH ALLOWED_RANGES {256}
   set_parameter_property DBUS_WIDTH GROUP $group_name
   set_parameter_property DBUS_WIDTH VISIBLE true
   set_parameter_property DBUS_WIDTH HDL_PARAMETER true
   set_parameter_property DBUS_WIDTH DESCRIPTION "Selects the width of the data interface between the transaction layer and the application layer implemented in the PLD fabric. The IP core supports interfaces of 256 bits."

      # Port type
   add_parameter          PORT_TYPE string "Native endpoint"
   set_parameter_property PORT_TYPE DISPLAY_NAME "Port Type"
   set_parameter_property PORT_TYPE ALLOWED_RANGES {"Root Port" "Native endpoint"}
   set_parameter_property PORT_TYPE GROUP $group_name
   set_parameter_property PORT_TYPE VISIBLE true
   set_parameter_property PORT_TYPE HDL_PARAMETER true
   set_parameter_property PORT_TYPE DESCRIPTION "Selects the port type. Root Port and Native endpoint are supported"


      # CRA
   add_parameter          ENABLE_CRA integer 0
   set_parameter_property ENABLE_CRA DISPLAY_NAME "Enable Control Register Access (CRA)"
   set_parameter_property ENABLE_CRA DISPLAY_HINT boolean
   set_parameter_property ENABLE_CRA GROUP $group_name
   set_parameter_property ENABLE_CRA VISIBLE true
   set_parameter_property ENABLE_CRA HDL_PARAMETER true
   set_parameter_property ENABLE_CRA DESCRIPTION "Selects control register access through Avalon MM slave interface"

      # TXS
   add_parameter          ENABLE_TXS integer 0
   set_parameter_property ENABLE_TXS DISPLAY_NAME "Enable TX Salve Interface (TXS)"
   set_parameter_property ENABLE_TXS DISPLAY_HINT boolean
   set_parameter_property ENABLE_TXS GROUP $group_name
   set_parameter_property ENABLE_TXS VISIBLE true
   set_parameter_property ENABLE_TXS HDL_PARAMETER true
   set_parameter_property ENABLE_TXS DESCRIPTION "Enables Single DWORD access from upstream(EP Mode) device or downstream(RP Mode) device through Avalon MM slave interface"

   #Bar Number
   add_parameter          BAR_NUMBER integer 0
   set_parameter_property BAR_NUMBER DISPLAY_NAME "Target BAR Number"
   set_parameter_property BAR_NUMBER ALLOWED_RANGES { "0:BAR0" "1:BAR1" "2:BAR2"  "3:BAR3"  "4:BAR4"  "5:BAR5"}
   set_parameter_property BAR_NUMBER GROUP $group_name
   set_parameter_property BAR_NUMBER VISIBLE true
   set_parameter_property BAR_NUMBER HDL_PARAMETER true
   set_parameter_property BAR_NUMBER DESCRIPTION "Selects Target BAR for RXM Interface."
   #Bar Type
   add_parameter          BAR_TYPE integer 1
   set_parameter_property BAR_TYPE DISPLAY_NAME "Type"
   set_parameter_property BAR_TYPE ALLOWED_RANGES { "0:32-bit address" "1:64-bit address" }
   set_parameter_property BAR_TYPE GROUP $group_name
   set_parameter_property BAR_TYPE VISIBLE true
   set_parameter_property BAR_TYPE HDL_PARAMETER false
   set_parameter_property BAR_TYPE DESCRIPTION "Selects either a 64-or 32-bit BAR. When 64 bits, BARs 0 and 1 combine to form a single BAR."
   #Bar Mask
   add_parameter          BAR_SIZE_MASK integer 12
   set_parameter_property BAR_SIZE_MASK DISPLAY_NAME "Size"
   set_parameter_property BAR_SIZE_MASK ALLOWED_RANGES { "0:N/A" "4: 16 Bytes - 4 bits" "5: 32 Bytes - 5 bits" "6: 64 Bytes - 6 bits" "7: 128 Bytes - 7 bits" "8: 256 Bytes - 8 bits" "9: 512 Bytes - 9 bits" "10: 1 KByte - 10 bits" "11: 2 KBytes - 11 bits" "12: 4 KBytes - 12 bits" "13: 8 KBytes - 13 bits" "14: 16 KBytes - 14 bits" "15: 32 KBytes - 15 bits" "16: 64 KBytes - 16 bits" "17: 128 KBytes - 17 bits" "18: 256 KBytes - 18 bits" "19: 512 KBytes - 19 bits" "20: 1 MByte - 20 bits" "21: 2 MBytes - 21 bits" "22: 4 MBytes - 22 bits" "23: 8 MBytes - 23 bits" "24: 16 MBytes - 24 bits" "25: 32 MBytes - 25 bits" "26: 64 MBytes - 26 bits" "27: 128 MBytes - 27 bits" "28: 256 MBytes - 28 bits" "29: 512 MBytes - 29 bits" "30: 1 GByte - 30 bits" "31: 2 GBytes - 31 bits"}
   set_parameter_property BAR_SIZE_MASK GROUP $group_name
   set_parameter_property BAR_SIZE_MASK VISIBLE true
   set_parameter_property BAR_SIZE_MASK HDL_PARAMETER true
   set_parameter_property BAR_SIZE_MASK DESCRIPTION "Sets from 4-63 bits per base address register (BAR)."

          #Avalon MM Address Size for TXS : Do not show for timebeing
   add_parameter          TX_S_ADDR_WIDTH integer 32
   set_parameter_property TX_S_ADDR_WIDTH DISPLAY_NAME "TXS Address Width"
   set_parameter_property TX_S_ADDR_WIDTH ALLOWED_RANGES { 8 16 20 24 32 64 }
   set_parameter_property TX_S_ADDR_WIDTH GROUP $group_name
   set_parameter_property TX_S_ADDR_WIDTH VISIBLE true
   set_parameter_property TX_S_ADDR_WIDTH HDL_PARAMETER true
   set_parameter_property TX_S_ADDR_WIDTH DESCRIPTION "Selects either a 64-or 32-bit Address for AVMM Transmit Slave interface"

   add_parameter          BURST_COUNT_WIDTH integer 6
   set_parameter_property BURST_COUNT_WIDTH DISPLAY_NAME "Burst Count on RXM interface"
   set_parameter_property BURST_COUNT_WIDTH ALLOWED_RANGES { 6 }
   set_parameter_property BURST_COUNT_WIDTH GROUP $group_name
   set_parameter_property BURST_COUNT_WIDTH VISIBLE false
   set_parameter_property BURST_COUNT_WIDTH HDL_PARAMETER true
   set_parameter_property BURST_COUNT_WIDTH DESCRIPTION "Selects burst count width for AVMM RX Master Interface"

   add_parameter          BE_WIDTH integer 0
   set_parameter_property BE_WIDTH DERIVED true
   set_parameter_property BE_WIDTH VISIBLE false
   set_parameter_property BE_WIDTH HDL_PARAMETER true

   add_parameter          RXM_ADDR_WIDTH integer 0
   set_parameter_property RXM_ADDR_WIDTH DERIVED true
   set_parameter_property RXM_ADDR_WIDTH VISIBLE false
   set_parameter_property RXM_ADDR_WIDTH HDL_PARAMETER true




# All Parameters below are SRIOV parameters - Unused in this design
     #=========================================================================

      # SRIOV-EN
   add_parameter          SRIOV_EN integer 0
   set_parameter_property SRIOV_EN DISPLAY_NAME "Enable SRIOV Support"
   set_parameter_property SRIOV_EN DISPLAY_HINT boolean
   set_parameter_property SRIOV_EN GROUP $group_name
   set_parameter_property SRIOV_EN VISIBLE false
   set_parameter_property SRIOV_EN HDL_PARAMETER true
   set_parameter_property SRIOV_EN DESCRIPTION "Enables Access to SRIOV Functions Connected to RXM Port"


   set group_name "SR-IOV System Settings"
   # TOTAL_PF_COUNT
   add_parameter          PF_COUNT integer 4
   set_parameter_property PF_COUNT DISPLAY_NAME "Total Physical Functions (PFs)"
   set_parameter_property PF_COUNT ALLOWED_RANGES {1 2 3 4}
   set_parameter_property PF_COUNT GROUP $group_name
   set_parameter_property PF_COUNT VISIBLE false
   set_parameter_property PF_COUNT HDL_PARAMETER true
   set_parameter_property PF_COUNT DESCRIPTION "Selects the number of Physical Function supported. Valid values are 1 to 4"

   # TOTAL_PF_COUNT_WIDTH (derived)
   add_parameter          PFCNT_WD integer 2
   set_parameter_property PFCNT_WD DERIVED true
   set_parameter_property PFCNT_WD VISIBLE false
   set_parameter_property PFCNT_WD HDL_PARAMETER true

   # TOTAL_VF_COUNT (derived)
   add_parameter          VF_COUNT integer 4
   set_parameter_property VF_COUNT DERIVED true
   set_parameter_property VF_COUNT VISIBLE false
   set_parameter_property VF_COUNT HDL_PARAMETER true

   # TOTAL_VF_COUNT_WIDTH (derived)
   add_parameter          VFCNT_WD integer 2
   set_parameter_property VFCNT_WD DERIVED true
   set_parameter_property VFCNT_WD VISIBLE false
   set_parameter_property VFCNT_WD HDL_PARAMETER true

   # PF0_VF_COUNT_USER
   add_parameter          PF0_VF_COUNT_USER integer 1
   set_parameter_property PF0_VF_COUNT_USER DISPLAY_NAME "Total Virtual Functions of Physical Function0 (PF0 VFs)"
   set_parameter_property PF0_VF_COUNT_USER ALLOWED_RANGES {0:4096}
   set_parameter_property PF0_VF_COUNT_USER GROUP $group_name
   set_parameter_property PF0_VF_COUNT_USER VISIBLE false
   set_parameter_property PF0_VF_COUNT_USER HDL_PARAMETER false
   set_parameter_property PF0_VF_COUNT_USER DESCRIPTION "Total VFs assigned to PF0. 0-8 in multiple of 1, 8 - 256 in multiple of 4, 256 - 1024 in multiple of 64, 1024 - 4096 in multiple of 512. The sum of VFs assigned to PF0, PF1, PF2 and PF3 should not exceed 4096 VFs"

   # PF1_VF_COUNT_USER
   add_parameter          PF1_VF_COUNT_USER integer 1
   set_parameter_property PF1_VF_COUNT_USER DISPLAY_NAME "Total Virtual Functions of Physical Function0 (PF1 VFs)"
   set_parameter_property PF1_VF_COUNT_USER ALLOWED_RANGES {0:4096}
   set_parameter_property PF1_VF_COUNT_USER GROUP $group_name
   set_parameter_property PF1_VF_COUNT_USER VISIBLE false
   set_parameter_property PF1_VF_COUNT_USER HDL_PARAMETER false
   set_parameter_property PF1_VF_COUNT_USER DESCRIPTION "Total VFs assigned to PF1. 0 - 8 in multiple of 1, 8 - 256 in multiple of 4, 256 - 1024 in multiple of 64, 1024 - 4096 in multiple of 512. The sum of VFs assigned to PF0, PF1, PF2 and PF3 should not exceed 4096 VFs"


   # PF2_VF_COUNT_USER
   add_parameter          PF2_VF_COUNT_USER integer 1
   set_parameter_property PF2_VF_COUNT_USER DISPLAY_NAME "Total Virtual Functions of Physical Function0 (PF2 VFs)"
   set_parameter_property PF2_VF_COUNT_USER ALLOWED_RANGES {0:4096}
   set_parameter_property PF2_VF_COUNT_USER GROUP $group_name
   set_parameter_property PF2_VF_COUNT_USER VISIBLE false
   set_parameter_property PF2_VF_COUNT_USER HDL_PARAMETER false
   set_parameter_property PF2_VF_COUNT_USER DESCRIPTION "Total VFs assigned to PF2. 0 - 8 in multiple of 1, 8 - 256 in multiple of 4, 256 - 1024 in multiple of 64, 1024 - 4096 in multiple of 512. The sum of VFs assigned to PF0, PF1, PF2 and PF3 should not exceed 4096 VFs"


   # PF3_VF_COUNT_USER
   add_parameter          PF3_VF_COUNT_USER integer 1
   set_parameter_property PF3_VF_COUNT_USER DISPLAY_NAME "Total Virtual Functions of Physical Function0 (PF3 VFs)"
   set_parameter_property PF3_VF_COUNT_USER ALLOWED_RANGES {0:4096}
   set_parameter_property PF3_VF_COUNT_USER GROUP $group_name
   set_parameter_property PF3_VF_COUNT_USER VISIBLE false
   set_parameter_property PF3_VF_COUNT_USER HDL_PARAMETER false
   set_parameter_property PF3_VF_COUNT_USER DESCRIPTION "Total VFs assigned to PF3. 0 - 8 in multiple of 1, 8 - 256 in multiple of 4, 256 - 1024 in multiple of 64, 1024 - 4096 in multiple of 512. The sum of VFs assigned to PF0, PF1, PF2 and PF3 should not exceed 4096 VFs"



}


proc validation_parameter_bar {} {

 set data_bus_width [get_parameter_value DBUS_WIDTH]
 set bar64          [get_parameter_value BAR_TYPE]
 set barNum         [get_parameter_value BAR_NUMBER]

 set_parameter_value  BE_WIDTH [expr $data_bus_width / 8]

 if ($bar64) {
  set_parameter_value  RXM_ADDR_WIDTH   64
 } else {
  set_parameter_value  RXM_ADDR_WIDTH   32
 }
  set evenbarNum  [expr {$barNum % 2}]
  # BAR1,BAR3 and BAR5 must be disabled when 64-bit addressing is selected
  if { ($bar64) && ($evenbarNum != 0) } {
   send_message error "Select Target BAR Number as BAR0 or BAR2 or BAR4 for 64 Bit addressing"
    }
}

#SRIOV Unused in this design
proc validation_total_vf_count {} {

    proc vector_width {vec_num} {

        if {$vec_num == 0} {
          send_message debug "Unsupported vector size for PF COUNT or VF COUNT"
        } else {
                 set vec_num [expr $vec_num - 1]
                 set width [expr $vec_num == 0 ? 1 : 0 ]

                         while {$vec_num != 0} {
                    set width [expr $width + 1]
                    set vec_num [expr $vec_num >> 1]
                           }
                return $width
            }
    }

   set PF0_VF_COUNT_USER                       [ get_parameter_value PF0_VF_COUNT_USER   ]
   set PF1_VF_COUNT_USER                       [ get_parameter_value PF1_VF_COUNT_USER   ]
   set PF2_VF_COUNT_USER                       [ get_parameter_value PF2_VF_COUNT_USER   ]
   set PF3_VF_COUNT_USER                       [ get_parameter_value PF3_VF_COUNT_USER   ]
   set SR_IOV_SUPPORT                          [ get_parameter_value SRIOV_EN ]
   set TOTAL_PF_COUNT                          [ get_parameter_value PF_COUNT ]
   set MEMORY_SIZE                             [ get_parameter_value BAR_SIZE_MASK]

   set_parameter_value PFCNT_WD                [ vector_width $TOTAL_PF_COUNT ]

   #=========================================================================
   # Derived and validate TOTAL_VF_COUNT = Sum of both PF0 and PF1 VF_COUNT
   set TOTAL_VF                  [ expr {$PF0_VF_COUNT_USER + $PF1_VF_COUNT_USER + $PF2_VF_COUNT_USER + $PF3_VF_COUNT_USER}]
   set TOTAL_FN                  [ expr {$TOTAL_VF + $TOTAL_PF_COUNT}]

   set_parameter_value VF_COUNT  $TOTAL_VF
   set_parameter_value VFCNT_WD  [ vector_width $TOTAL_VF ]

   set TOTAL_FN_WD [ vector_width $TOTAL_FN ]

   if { $MEMORY_SIZE < $TOTAL_FN_WD } {
     send_message error "Total Functions require minimum memory size of $TOTAL_FN_WD bits, Please select \"Size\" greater than or equal to $TOTAL_FN_WD bits"
   }

}
