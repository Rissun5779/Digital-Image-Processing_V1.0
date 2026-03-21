// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// /**
//  * Wrapper for SR-IOV 2 Bridge with 4 PFs and 4096 VFs
//  */
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings
// altera message_level Level1
// altera message_off 10034 10035 10036 10037 10230 10240 10030

//-----------------------------------------------------------------------------
// Title         : PCI Express SR-IOV 2 Bridge
// Project       : PCI Express MegaCore function
//-----------------------------------------------------------------------------
// File          : altera_pcie_sriov2_bridge.sv
// Author        : Altera Corporation
//-----------------------------------------------------------------------------
//

module altera_pcie_sriov2_bridge #
  (
  //****************************************************************************************************
  // Device-level parameters
  //****************************************************************************************************
   parameter MAX_LINK_SPEED                      = "Gen3", // "Gen1", "Gen2" or "Gen3"  
   parameter LINK_WIDTH                          = 8,  // Width of PCI Express Link (1, 2, 4 or 8)
   parameter DATA_WIDTH                          = 256, // Width of internal data path (128 or 256)
   parameter CLK_FREQUENCY                       = 250, // 125 or 250
   parameter PARITY_SUPPORT                      = 1, // 0 or 1
   parameter ARI_SUPPORT                         = 1, // 0 or 1 (must be 1 when SR_IOV_SUPPORT is 1)
   parameter ENABLE_ALTERNATE_LINK_LIST          = 0, // 0 or 1
   parameter TOTAL_PF_COUNT                      = 4, // Total number of PFs: 1, 2, 3 or 4 
   parameter TOTAL_PF_COUNT_WIDTH                = 2, // Must be set to 2 when TOTAL_PF_COUNT = 3 or 4,
                                                      // and to 1 otherwise.
   parameter FLR_SUPPORT                         = 1, // set to 1 to enable support for FLR in PFs.
                                                      // Support for FLR in VFs is always enabled.
   parameter RELAXED_ORDER_SUPPORT               = 1, // Device supports relaxed ordering (0 or 1)
   parameter EXTENDED_TAG_SUPPORT                = 1, // Device supports 8-bit tags (0 or 1)
   parameter MAX_PAYLOAD_SIZE                    = 256, // Maximum Payload Size: 128, 256, 512, 1024 or 2048
   parameter NO_SOFT_RESET                       = 0, // Setting of the "No Soft Reset" bit (bit 3) in the
                                                      // Power Management Control & Status Register
   parameter DROP_POISONED_REQ                   = 0, // Set this to 1 to make the bridge drop
                                                      // Poisoned requests received from the link.
   parameter DROP_POISONED_COMPL                 = 0, // Set this to 1 to make the bridge drop
                                                      // Poisoned Completions received from the link
   parameter SIG_TEST_EN                         = 1'b1, // Set this to 1 to enable PCIECV test work-around 
  //****************************************************************************************************
  // PCI Configuration Space parameters
  //****************************************************************************************************
   parameter PF0_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 0
   parameter PF1_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 1
   parameter PF2_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 2
   parameter PF3_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 3
   parameter PF4_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 4
   parameter PF5_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 5
   parameter PF6_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 6
   parameter PF7_VENDOR_ID                       = 4466, // PCI Vendor ID associated with PF 7
   
   parameter PF0_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 0
   parameter PF1_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 1
   parameter PF2_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 2
   parameter PF3_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 3
   parameter PF4_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 4
   parameter PF5_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 5
   parameter PF6_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 6
   parameter PF7_DEVICE_ID                       = 57345, // PCI Device ID associated with PF 7   
   
   parameter PF0_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 0
   parameter PF1_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 1
   parameter PF2_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 2
   parameter PF3_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 3
   parameter PF4_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 4
   parameter PF5_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 5
   parameter PF6_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 6
   parameter PF7_SUBVENDOR_ID                    = 4466, // PCI Subsystem Vendor ID associated with PF 7
   
   parameter PF0_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 0
   parameter PF1_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 1
   parameter PF2_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 2
   parameter PF3_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 3
   parameter PF4_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 4
   parameter PF5_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 5
   parameter PF6_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 6
   parameter PF7_SUBSYS_ID                       = 57345, // PCI Subsystem ID associated with PF 7
   
   parameter PF0_CLASS_CODE                      = 255, // PCI Class Code associated with PF 0
   parameter PF1_CLASS_CODE                      = 255, // PCI Class Code associated with PF 1
   parameter PF2_CLASS_CODE                      = 255, // PCI Class Code associated with PF 2
   parameter PF3_CLASS_CODE                      = 255, // PCI Class Code associated with PF 3
   parameter PF4_CLASS_CODE                      = 255, // PCI Class Code associated with PF 4
   parameter PF5_CLASS_CODE                      = 255, // PCI Class Code associated with PF 5
   parameter PF6_CLASS_CODE                      = 255, // PCI Class Code associated with PF 6
   parameter PF7_CLASS_CODE                      = 255, // PCI Class Code associated with PF 7
   
   parameter PF0_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 0
   parameter PF1_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 1
   parameter PF2_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 2
   parameter PF3_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 3
   parameter PF4_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 4
   parameter PF5_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 5
   parameter PF6_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 6
   parameter PF7_SUBCLASS_CODE                   = 0, // PCI Subclass Code associated with PF 7

   parameter PF0_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 0
   parameter PF1_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 1
   parameter PF2_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 2
   parameter PF3_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 3
   parameter PF4_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 4
   parameter PF5_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 5
   parameter PF6_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 6
   parameter PF7_PCI_PROG_INTFC_BYTE             = 0, // PCI PCI Prog Interface Byte, PF 7
   
   parameter PF0_REVISION_ID                     = 1, // PCI Revision ID associated with PF 0
   parameter PF1_REVISION_ID                     = 1, // PCI Revision ID associated with PF 1
   parameter PF2_REVISION_ID                     = 1, // PCI Revision ID associated with PF 2
   parameter PF3_REVISION_ID                     = 1, // PCI Revision ID associated with PF 3
   parameter PF4_REVISION_ID                     = 1, // PCI Revision ID associated with PF 4
   parameter PF5_REVISION_ID                     = 1, // PCI Revision ID associated with PF 5
   parameter PF6_REVISION_ID                     = 1, // PCI Revision ID associated with PF 6
   parameter PF7_REVISION_ID                     = 1, // PCI Revision ID associated with PF 7
   
   parameter PF0_INTR_PIN                        = "inta", // Setting of Interrupt Pin Register of PF 0.
                                                           // Can be "inta", "intb", "intc", "intd"
   parameter PF1_INTR_PIN                        = "intb", // Setting of Interrupt Pin Register of PF 1.
                                                           // Can be "inta", "intb", "intc", "intd"
   parameter PF2_INTR_PIN                        = "intc", // Setting of Interrupt Pin Register of PF 2.
                                                           // Can be "inta", "intb", "intc", "intd"
   parameter PF3_INTR_PIN                        = "intd", // Setting of Interrupt Pin Register of PF 3.
                                                           // Can be "inta", "intb", "intc", "intd"
   parameter PF4_INTR_PIN                        = "inta", // Setting of Interrupt Pin Register of PF 4.
                                                           // Can be "inta", "intb", "intc", "intd"    
   parameter PF5_INTR_PIN                        = "intb", // Setting of Interrupt Pin Register of PF 5.
                                                           // Can be "inta", "intb", "intc", "intd"    
   parameter PF6_INTR_PIN                        = "intc", // Setting of Interrupt Pin Register of PF 6.
                                                           // Can be "inta", "intb", "intc", "intd"    
   parameter PF7_INTR_PIN                        = "intd", // Setting of Interrupt Pin Register of PF 7.
                                                           // Can be "inta", "intb", "intc", "intd"
                                                           
   parameter PF0_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 0.
   parameter PF1_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 1.
   parameter PF2_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 2.
   parameter PF3_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 3.
   parameter PF4_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 4.
   parameter PF5_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 5.
   parameter PF6_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 6.
   parameter PF7_INTR_LINE                       = 8'hff, // Setting of Interrupt Line Register of PF 7.   
  //****************************************************************************************************
  // PCI Express Configuration Space parameters
  //****************************************************************************************************
   parameter SLOT_CLK_CFG                        = 1, // Slot Clock Configuration bit (bit 12)
                                                      // in PCI Express Link Status Register
   parameter EP_L0S_ACCEPTABLE_LATENCY           = 0, // Setting of the Endpoint L0S Acceptable Latency field
                                                      // (bits 8:6) in Device Capabilities Register
   parameter EP_L1_ACCEPTABLE_LATENCY            = 0, // Setting of the Endpoint L1 Acceptable Latency field
                                                      // (bits 11:9) in Device Capabilities Register
   parameter ASPM_L0S_SUPPORT                    = 1, // Setting of the ASPM L0S Supported bit (bit 10)
                                                      // in Link Capabilities Register
   parameter ASPM_L1_SUPPORT                     = 1, // Setting of the ASPM L1 Supported bit (bit 11)
                                                      // in Link Capabilities Register
   parameter L0S_EXIT_LATENCY                    = 6, // Setting of the L0S Exit Latency field (bits 14:12)
                                                      // in Link Capabilities Register
   parameter L1_EXIT_LATENCY                     = 1, // Setting of the L1 Exit Latency field (bits 17:13)
                                                      // in Link Capabilities Register
   parameter COMPL_TIMEOUT_DISABLE_SUPPORT       = 1, // Setting of the Completion Timeout Disable Supported bit
                                                      // (bit 4) in the Device Capabilities 2 Register
   parameter COMPL_TIMEOUT_RANGES                = "abcd", // Setting of the Completion Timeout Ranges field
                                                      // (bits 3:0) in the Device Capabilities 2 Register.
                                                      // Valid settings are "a", "b", "ab", "bc", "abc",
                                                      // "bcd", "abcd" 
   parameter ECRC_GEN_CAPABLE                    = 0, // Setting of the ECRC Generation Capable bit (bit 5)
                                                      // in the AER Capabilities & Control Register.
   parameter ECRC_CHECK_CAPABLE                  = 0, // Setting of the ECRC Check Capable bit (bit 7)
  //****************************************************************************************************
  // SR-IOV parameters
  //****************************************************************************************************
   parameter SR_IOV_SUPPORT                      = 1, // 0 or 1
   parameter TOTAL_VF_COUNT                      = 4096, // Total number of VFs
                                                         // 1 - 8 (in steps of 1),
                                                         // 8 - 256 (in multiples of 4)
                                                         // 256 - 1024 (in multiples of 64)
                                                         // 1024 - 4096 (in multiples of 512)
	                                                 // Sum of PF0_VF_COUNT, PF1_VF_COUNT, PF2_VF_COUNT and
                                                         // PF3_VF_COUNT must equal TOTAL_VF_COUNT
   parameter TOTAL_VF_COUNT_WIDTH                = 12,   // Number of bits needed to represent TOTAL_VF_COUNT
   parameter PF0_VF_COUNT                        = 1024, // Number of VFs attached to PF 0
                                                         // 0 - 8 (in steps of 1),
                                                         // 8 - 256 (in multiples of 4)
                                                         // 256 - 1024 (in multiples of 64)
                                                         // 1024 - 4096 (in multiples of 512)
   parameter PF1_VF_COUNT                        = 1024, // Number of VFs attached to PF 0
                                                         // 0 - 8 (in steps of 1),
                                                         // 8 - 256 (in multiples of 4)
                                                         // 256 - 1024 (in multiples of 64)
                                                         // 1024 - 4096 (in multiples of 512)
   parameter PF2_VF_COUNT                        = 1024, // Number of VFs attached to PF 0
                                                         // 0 - 8 (in steps of 1),
                                                         // 8 - 256 (in multiples of 4)
                                                         // 256 - 1024 (in multiples of 64)
                                                         // 1024 - 4096 (in multiples of 512)
   parameter PF3_VF_COUNT                        = 1024, // Number of VFs attached to PF 0
                                                         // 0 - 8 (in steps of 1),
                                                         // 8 - 256 (in multiples of 4)
                                                         // 256 - 1024 (in multiples of 64)
                                                         // 1024 - 4096 (in multiples of 512)

   parameter PF0_VF_DEVICE_ID                    = 16'hE001, // VF Device ID for VFs attached to PF 0
   parameter PF1_VF_DEVICE_ID                    = 16'hE001, // VF Device ID for VFs attached to PF 1
   parameter PF2_VF_DEVICE_ID                    = 16'hE001, // VF Device ID for VFs attached to PF 2
   parameter PF3_VF_DEVICE_ID                    = 16'hE001, // VF Device ID for VFs attached to PF 3
   parameter SYSTEM_PAGE_SIZES_SUPPORTED         = 32'h553, // Supported page sizes for SR-IOV
  //****************************************************************************************************
  // MSI parameters (PFs only)
  //****************************************************************************************************
   parameter MSI_SUPPORT                         = 1, // MSI Capability supported by PFs
   parameter MSI_64BIT_CAPABLE                   = 1, // Indicates whether 64-bit addressing is supported
                                                      // for MSI interrupts.
   parameter PF0_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 0 is
                                                      // capable of generating.
                                                      // Value is power of 2 (0 - 5)
   parameter PF1_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 1 is
                                                      // capable of generating.
                                                      // Value is power of 2 (0 - 5)
   parameter PF2_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 2 is
                                                      // capable of generating.
                                                      // Value is power of 2 (0 - 5)
   parameter PF3_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 3 is
                                                      // capable of generating.
                                                      // Value is power of 2 (0 - 5)
   parameter PF4_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 4 is
                                                     // capable of generating.                  
                                                     // Value is power of 2 (0 - 5)             
   parameter PF5_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 5 is
                                                     // capable of generating.                  
                                                     // Value is power of 2 (0 - 5)             
   parameter PF6_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 6 is
                                                     // capable of generating.                  
                                                     // Value is power of 2 (0 - 5)             
   parameter PF7_MSI_MULTI_MSG_CAPABLE           = 5, // Maximum number of MSI vectors that PF 7 is
                                                      // capable of generating.
                                                      // Value is power of 2 (0 - 5)
  //****************************************************************************************************
  // MSIX parameters of Physical Functions
  //****************************************************************************************************
   parameter MSIX_SUPPORT                        = 1, // MSIX Capability supported by PFs
   parameter PF0_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 0
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
   parameter PF1_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 1
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
   parameter PF2_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 2
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
   parameter PF3_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 3
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
   parameter PF4_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 4
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
   parameter PF5_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 5
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
   parameter PF6_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 6
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
   parameter PF7_MSIX_TBL_SIZE                   = 11'h1F, // Size of MSIX Table in PF 7
                                                           // Value is one less than the table size
                                                           // (0 - 11'h7FF)
                                                           
   parameter PF0_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where the MSIX Table
                                                      // of PF 0 is located, relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF1_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where MSIX Table
                                                      // of PF 1 is located, relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF2_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where MSIX Table
                                                      // of PF 2 is located, relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF3_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where MSIX Table
                                                      // of PF 3 is located, relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF4_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where the MSIX Table
                                                      // of PF 4 is located, relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF5_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where MSIX Table
                                                      // of PF 5 is located, relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF6_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where MSIX Table
                                                      // of PF 6 is located, relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF7_MSIX_TBL_OFFSET                 = 0, // Offset of memory address where MSIX Table
                                                      // of PF 7 is located, relative to its base address.
                                                      // Value is in Quadwords.
                                                      
   parameter PF0_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 0 (0 - 5)
   parameter PF1_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 1 (0 - 5)
   parameter PF2_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 2 (0 - 5)
   parameter PF3_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 3 (0 - 5)
   parameter PF4_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 4 (0 - 5)
   parameter PF5_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 5 (0 - 5)
   parameter PF6_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 6 (0 - 5)
   parameter PF7_MSIX_TBL_BIR                    = 0, // MSIX Table BAR Indicator for PF 7 (0 - 5)
   
   parameter PF0_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 0 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF1_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 1 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF2_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 2 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF3_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 3 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF4_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 4 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF5_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 5 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF6_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 6 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF7_MSIX_PBA_OFFSET                 = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of PF 7 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
                                                      
   parameter PF0_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 0 (0 - 5)
   parameter PF1_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 1 (0 - 5)
   parameter PF2_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 2 (0 - 5)
   parameter PF3_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 3 (0 - 5)
   parameter PF4_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 4 (0 - 5)
   parameter PF5_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 5 (0 - 5)
   parameter PF6_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 6 (0 - 5)
   parameter PF7_MSIX_PBA_BIR                    = 0, // MSIX PBA BAR Indicator for PF 7 (0 - 5)   
  //****************************************************************************************************
  // MSIX parameters of Virtual Functions
  //****************************************************************************************************
   parameter VF_MSIX_SUPPORT                     = 1, // MSIX Capability supported by VFs
   parameter PF0_VF_MSIX_TBL_SIZE                = 11'h1F, // Size of MSIX Table in VFs attached to PF 0
                                                      // Value is one less than the table size
                                                      // (0 - 11'h7FF)
   parameter PF1_VF_MSIX_TBL_SIZE                = 11'h1F, // Size of MSIX Table in VFs attached to PF 1
                                                      // Value is one less than the table size
                                                      // (0 - 11'h7FF)
   parameter PF2_VF_MSIX_TBL_SIZE                = 11'h1F, // Size of MSIX Table in VFs attached to PF 2
                                                      // Value is one less than the table size
                                                      // (0 - 11'h7FF)
   parameter PF3_VF_MSIX_TBL_SIZE                = 11'h1F, // Size of MSIX Table in VFs attached to PF 3
                                                      // Value is one less than the table size
                                                      // (0 - 11'h7FF)
   parameter PF0_VF_MSIX_TBL_OFFSET              = 0, // Offset of memory address where the MSIX Table
                                                      // of a VF attached to PF 0 is located,
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF1_VF_MSIX_TBL_OFFSET              = 0, // Offset of memory address where MSIX Table
                                                      // of a VF attached to PF 1 is located,
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF2_VF_MSIX_TBL_OFFSET              = 0, // Offset of memory address where MSIX Table
                                                      // of a VF attached to PF 2 is located,
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF3_VF_MSIX_TBL_OFFSET              = 0, // Offset of memory address where MSIX Table
                                                      // of a VF attached to PF 3 is located,
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF0_VF_MSIX_TBL_BIR                 = 0, // MSIX Table BAR Indicator for VFs 
                                                      // attached to PF 0 (0 - 5)
   parameter PF1_VF_MSIX_TBL_BIR                 = 0, // MSIX Table BAR Indicator for VFs
                                                      // attached to PF 0 (0 - 5)
   parameter PF2_VF_MSIX_TBL_BIR                 = 0, // MSIX Table BAR Indicator for VFs 
                                                      // attached to PF 0 (0 - 5)
   parameter PF3_VF_MSIX_TBL_BIR                 = 0, // MSIX Table BAR Indicator for VFs 
                                                      // attached to PF 0 (0 - 5)
   parameter PF0_VF_MSIX_PBA_OFFSET              = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of a VF attached to PF 0 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF1_VF_MSIX_PBA_OFFSET              = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of a VF attached to PF 1 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF2_VF_MSIX_PBA_OFFSET              = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of a VF attached to PF 2 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF3_VF_MSIX_PBA_OFFSET              = 0, // Offset of memory address where the MSIX Pending
                                                      // Bit Array of a VF attached to PF 3 is located, 
                                                      // relative to its base address.
                                                      // Value is in Quadwords.
   parameter PF0_VF_MSIX_PBA_BIR                 = 0, // MSIX PBA BAR Indicator for VFs
                                                      // attached to PF 0 (0 - 5)
   parameter PF1_VF_MSIX_PBA_BIR                 = 0, // MSIX PBA BAR Indicator for VFs
                                                      // attached to PF 1 (0 - 5)
   parameter PF2_VF_MSIX_PBA_BIR                 = 0, // MSIX PBA BAR Indicator for VFs
                                                      // attached to PF 2 (0 - 5)
   parameter PF3_VF_MSIX_PBA_BIR                 = 0, // MSIX PBA BAR Indicator for VFs
                                                      // attached to PF 3 (0 - 5)
  //****************************************************************************************************
  // PF BAR parameters
  //****************************************************************************************************
   parameter PF0_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF1_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF2_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF3_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF4_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF5_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF6_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF7_BAR0_PRESENT                    = 1,  // 0 = not present, 1 = present

   parameter PF0_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF1_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF2_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF3_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF4_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF5_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF6_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF7_BAR1_PRESENT                    = 1,  // 0 = not present, 1 = present

   parameter PF0_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF1_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF2_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF3_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF4_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF5_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF6_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF7_BAR2_PRESENT                    = 1,  // 0 = not present, 1 = present

   parameter PF0_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF1_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF2_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF3_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF4_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF5_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF6_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF7_BAR3_PRESENT                    = 1,  // 0 = not present, 1 = present

   parameter PF0_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF1_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF2_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF3_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF4_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF5_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF6_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF7_BAR4_PRESENT                    = 1,  // 0 = not present, 1 = present

   parameter PF0_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF1_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF2_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF3_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF4_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF5_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF6_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present
   parameter PF7_BAR5_PRESENT                    = 1,  // 0 = not present, 1 = present

   parameter PF0_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   parameter PF1_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   parameter PF2_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   parameter PF3_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   parameter PF4_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   parameter PF5_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   parameter PF6_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   parameter PF7_EXPROM_BAR_PRESENT              = 1,  // 0 = not present, 1 = present
   
   parameter PF0_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF1_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF2_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF3_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF4_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF5_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF6_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF7_BAR0_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing

   parameter PF0_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF1_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF2_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF3_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF4_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF5_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF6_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF7_BAR2_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing

   parameter PF0_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF1_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF2_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF3_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF4_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF5_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF6_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF7_BAR4_TYPE                       = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing

   parameter PF0_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF4_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF5_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF6_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF7_BAR0_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable   

   parameter PF0_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF4_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF5_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF6_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF7_BAR1_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable 

   parameter PF0_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF4_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF5_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF6_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF7_BAR2_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable 

   parameter PF0_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF4_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF5_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF6_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF7_BAR3_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable 

   parameter PF0_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF4_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF5_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF6_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF7_BAR4_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable 

   parameter PF0_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF4_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF5_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF6_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF7_BAR5_PREFETCHABLE               = 1, // 0 = non-prefetchable, 1 = prefetchable    

   parameter PF0_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF1_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF2_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF3_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF4_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF5_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF6_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF7_BAR0_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E

   parameter PF0_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF1_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF2_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF3_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF4_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF5_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF6_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF7_BAR1_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E

   parameter PF0_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF1_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF2_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF3_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF4_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF5_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF6_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF7_BAR2_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E

   parameter PF0_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF1_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF2_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF3_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF4_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF5_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF6_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF7_BAR3_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E

   parameter PF0_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF1_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF2_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF3_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF4_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF5_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF6_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF7_BAR4_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E

   parameter PF0_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF1_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF2_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF3_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF4_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF5_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF6_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF7_BAR5_SIZE                       = 22, // 7 = 128 bytes, 8 = 256 bytes, 9 = 512 bytes, ..., 63 = 8E
   parameter PF0_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M
   parameter PF1_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M
   parameter PF2_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M
   parameter PF3_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M
   parameter PF4_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M
   parameter PF5_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M
   parameter PF6_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M
   parameter PF7_EXPROM_BAR_SIZE                 = 12, // 11= 2K  bytes, 12= 4K  bytes, 13= 8K bytes,  ..., 24 = 16M

   //****************************************************************************************************
  // VF BAR parameters
  //****************************************************************************************************
   parameter PF0_VF_BAR0_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF1_VF_BAR0_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF2_VF_BAR0_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF3_VF_BAR0_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF0_VF_BAR1_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF1_VF_BAR1_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF2_VF_BAR1_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF3_VF_BAR1_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF0_VF_BAR2_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF1_VF_BAR2_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF2_VF_BAR2_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF3_VF_BAR2_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF0_VF_BAR3_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF1_VF_BAR3_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF2_VF_BAR3_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF3_VF_BAR3_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF0_VF_BAR4_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF1_VF_BAR4_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF2_VF_BAR4_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF3_VF_BAR4_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF0_VF_BAR5_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF1_VF_BAR5_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF2_VF_BAR5_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF3_VF_BAR5_PRESENT                 = 1,  // 0 = not present, 1 = present
   parameter PF0_VF_BAR0_TYPE                    = 0, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF1_VF_BAR0_TYPE                    = 0, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF2_VF_BAR0_TYPE                    = 0, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF3_VF_BAR0_TYPE                    = 0, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF0_VF_BAR2_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF1_VF_BAR2_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF2_VF_BAR2_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF3_VF_BAR2_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF0_VF_BAR4_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF1_VF_BAR4_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF2_VF_BAR4_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF3_VF_BAR4_TYPE                    = 1, // 0 = 32-bit addressing, 1 = 64-bit addressing
   parameter PF0_VF_BAR0_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_VF_BAR0_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_VF_BAR0_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_VF_BAR0_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF0_VF_BAR1_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_VF_BAR1_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_VF_BAR1_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_VF_BAR1_PREFETCHABLE            = 0, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF0_VF_BAR2_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_VF_BAR2_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_VF_BAR2_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_VF_BAR2_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF0_VF_BAR3_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_VF_BAR3_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_VF_BAR3_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_VF_BAR3_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF0_VF_BAR4_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_VF_BAR4_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_VF_BAR4_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_VF_BAR4_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF0_VF_BAR5_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF1_VF_BAR5_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF2_VF_BAR5_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF3_VF_BAR5_PREFETCHABLE            = 1, // 0 = non-prefetchable, 1 = prefetchable
   parameter PF0_VF_BAR0_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF1_VF_BAR0_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF2_VF_BAR0_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF3_VF_BAR0_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF0_VF_BAR1_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF1_VF_BAR1_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF2_VF_BAR1_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF3_VF_BAR1_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF0_VF_BAR2_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF1_VF_BAR2_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF2_VF_BAR2_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF3_VF_BAR2_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF0_VF_BAR3_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF1_VF_BAR3_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF2_VF_BAR3_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF3_VF_BAR3_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF0_VF_BAR4_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF1_VF_BAR4_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF2_VF_BAR4_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF3_VF_BAR4_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF0_VF_BAR5_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF1_VF_BAR5_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF2_VF_BAR5_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
   parameter PF3_VF_BAR5_SIZE                    = 22, // 12 = 4K, 13 = 8K, ..., 63 = 8E
  //****************************************************************************************************
  // TPH parameters of Physical Functions
  //****************************************************************************************************
   parameter PF_TPH_SUPPORT                      = 0, // TPH Requester Capability supported by PFs
   parameter PF0_TPH_INT_MODE_SUPPORT            = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of PF 0 
   parameter PF1_TPH_INT_MODE_SUPPORT            = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of PF 1 
   parameter PF2_TPH_INT_MODE_SUPPORT            = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of PF 2 
   parameter PF3_TPH_INT_MODE_SUPPORT            = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of PF 3 
   parameter PF0_TPH_DEV_SPECIFIC_MODE_SUPPORT   = 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of PF 0 
   parameter PF1_TPH_DEV_SPECIFIC_MODE_SUPPORT   = 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of PF 1 
   parameter PF2_TPH_DEV_SPECIFIC_MODE_SUPPORT   = 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of PF 2 
   parameter PF3_TPH_DEV_SPECIFIC_MODE_SUPPORT   = 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of PF 3 
   parameter PF0_TPH_ST_TABLE_LOCATION           = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of PF 0.
                                                      // Valid settings are 0 and 2.
   parameter PF1_TPH_ST_TABLE_LOCATION           = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of PF 1.
                                                      // Valid settings are 0 and 2.
   parameter PF2_TPH_ST_TABLE_LOCATION           = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of PF 2.
                                                      // Valid settings are 0 and 2.
   parameter PF3_TPH_ST_TABLE_LOCATION           = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of PF 3.
                                                      // Valid settings are 0 and 2.
   parameter PF0_TPH_ST_TABLE_SIZE               = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of PF 0.
                                                      // Value is one less than the size of the table.
   parameter PF1_TPH_ST_TABLE_SIZE               = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of PF 1.
                                                      // Value is one less than the size of the table.
   parameter PF2_TPH_ST_TABLE_SIZE               = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of PF 2.
                                                      // Value is one less than the size of the table.
   parameter PF3_TPH_ST_TABLE_SIZE               = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of PF 3.
                                                      // Value is one less than the size of the table.
  //****************************************************************************************************
  // TPH parameters of Virtual Functions
  //****************************************************************************************************
   parameter VF_TPH_SUPPORT                      = 0, // TPH Requester Capability supported by PFs
   parameter PF0_VF_TPH_INT_MODE_SUPPORT         = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 0.
   parameter PF1_VF_TPH_INT_MODE_SUPPORT         = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 1.
   parameter PF2_VF_TPH_INT_MODE_SUPPORT         = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 2.
   parameter PF3_VF_TPH_INT_MODE_SUPPORT         = 1, // Setting of Interrupt Vector Mode Supported bit (bit 1)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 3.
   parameter PF0_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT= 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 0.
   parameter PF1_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT= 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 1.
   parameter PF2_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT= 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 2.
   parameter PF3_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT= 1, // Setting of Device Specific Mode Supported bit (bit 2)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 3.
   parameter PF0_VF_TPH_ST_TABLE_LOCATION        = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 0.
                                                      // Valid settings are 0 and 2.
   parameter PF1_VF_TPH_ST_TABLE_LOCATION        = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 1.
                                                      // Valid settings are 0 and 2.
   parameter PF2_VF_TPH_ST_TABLE_LOCATION        = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 2.
                                                      // Valid settings are 0 and 2.
   parameter PF3_VF_TPH_ST_TABLE_LOCATION        = 0, // Setting of ST Table Location field (bits 10:9)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 3.
                                                      // Valid settings are 0 and 2.
   parameter PF0_VF_TPH_ST_TABLE_SIZE            = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 0.
                                                      // Value is one less than the size of the table.
   parameter PF1_VF_TPH_ST_TABLE_SIZE            = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 1.
                                                      // Value is one less than the size of the table.
   parameter PF2_VF_TPH_ST_TABLE_SIZE            = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 2.
                                                      // Value is one less than the size of the table.
   parameter PF3_VF_TPH_ST_TABLE_SIZE            = 63,// Setting of ST Table Size field (bits 26:16)
                                                      // in the TPH Requester Capability Register of
                                                      // VFs attached to PF 3.
                                                      // Value is one less than the size of the table.
  //****************************************************************************************************
  // ATS parameters of Physical Functions
  //****************************************************************************************************
   parameter PF_ATS_SUPPORT                      = 0, // ATS Capability supported by PFs
   parameter PF0_ATS_INVALIDATE_QUEUE_DEPTH      = 0, // Setting of the Invalidate Queue Depth field
                                                      // in the ATS Capability Register of PF 0 (0 - 31)
   parameter PF1_ATS_INVALIDATE_QUEUE_DEPTH      = 0, // Setting of the Invalidate Queue Depth field
                                                      // in the ATS Capability Register of PF 1 (0 - 31)
   parameter PF2_ATS_INVALIDATE_QUEUE_DEPTH      = 0, // Setting of the Invalidate Queue Depth field
                                                      // in the ATS Capability Register of PF 2 (0 - 31)
   parameter PF3_ATS_INVALIDATE_QUEUE_DEPTH      = 0, // Setting of the Invalidate Queue Depth field
                                                      // in the ATS Capability Register of PF 3 (0 - 31)
  //****************************************************************************************************
  // ATS parameters of Virtual Functions
  //****************************************************************************************************
   parameter VF_ATS_SUPPORT                      = 0,  // ATS Capability supported by VFs
  //****************************************************************************************************
  // VirtIO Specific Parameters PF0
  //****************************************************************************************************   
   parameter       PF0_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF0_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF0_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF0_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF0_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF0_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF0_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF0_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF0_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF0_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF0_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF0_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF0_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF0_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF0_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF0_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF0_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF0_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF1
  //****************************************************************************************************
   parameter       PF1_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF1_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF1_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF1_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF1_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF1_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF1_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF1_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF1_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF1_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF1_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF1_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF1_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF1_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF1_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF1_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF1_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF1_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF2
  //****************************************************************************************************
   parameter       PF2_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF2_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF2_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF2_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF2_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF2_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF2_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF2_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF2_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF2_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF2_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF2_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF2_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF2_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF2_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF2_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF2_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF2_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF3
  //****************************************************************************************************
   parameter       PF3_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF3_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF3_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF3_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF3_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF3_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF3_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF3_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF3_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF3_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF3_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF3_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF3_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF3_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF3_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF3_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF3_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF3_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF4
  //****************************************************************************************************   
   parameter       PF4_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF4_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF4_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF4_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF4_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF4_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF4_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF4_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF4_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF4_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF4_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF4_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF4_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF4_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF4_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF4_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF4_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF4_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF5
  //****************************************************************************************************   
   parameter       PF5_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF5_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF5_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF5_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF5_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF5_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF5_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF5_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF5_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF5_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF5_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF5_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF5_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF5_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF5_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF5_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF5_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF5_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF6
  //****************************************************************************************************   
   parameter       PF6_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF6_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF6_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF6_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF6_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF6_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF6_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF6_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF6_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF6_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF6_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF6_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF6_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF6_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF6_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF6_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF6_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF6_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF7
  //****************************************************************************************************   
   parameter       PF7_VIRTIO_CAPABILITY_PRESENT                    = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF7_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT           = 0,            //This is optional capability for VIRTIO
   
   parameter       PF7_VIRTIO_CMN_CONFIG_BAR_INDICATOR              = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF7_VIRTIO_NOTIFICATION_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF7_VIRTIO_ISRSTATUS_BAR_INDICATOR               = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF7_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR        = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF7_VIRTIO_DEVSPECIFIC_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF7_VIRTIO_CMN_CONFIG_BAR_OFFSET                 = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF7_VIRTIO_NOTIFICATION_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF7_VIRTIO_ISRSTATUS_BAR_OFFSET                  = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF7_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET           = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF7_VIRTIO_DEVSPECIFIC_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF7_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH           = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF7_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF7_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH            = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF7_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH     = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF7_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF7_VIRTIO_NOTIFY_OFF_MULTIPLIER                 = 32'h00000008,    //Indicates Multiplier for queue_notify_off  

  //****************************************************************************************************
  // VirtIO Specific Parameters PF0 VFs
  //****************************************************************************************************   
   parameter       PF0VF_VIRTIO_CAPABILITY_PRESENT                  = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF0VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT         = 0,            //This is optional capability for VIRTIO
   
   parameter       PF0VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF0VF_VIRTIO_NOTIFICATION_BAR_INDICATOR          = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF0VF_VIRTIO_ISRSTATUS_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF0VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR      = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF0VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR           = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF0VF_VIRTIO_CMN_CONFIG_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF0VF_VIRTIO_NOTIFICATION_BAR_OFFSET             = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF0VF_VIRTIO_ISRSTATUS_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF0VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET         = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF0VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET              = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF0VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF0VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH       = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF0VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF0VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH   = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF0VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH        = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF0VF_VIRTIO_NOTIFY_OFF_MULTIPLIER               = 32'h00000008, //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF1 VFs
  //****************************************************************************************************
   parameter       PF1VF_VIRTIO_CAPABILITY_PRESENT                  = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF1VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT         = 0,            //This is optional capability for VIRTIO
   
   parameter       PF1VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF1VF_VIRTIO_NOTIFICATION_BAR_INDICATOR          = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF1VF_VIRTIO_ISRSTATUS_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF1VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR      = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF1VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR           = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF1VF_VIRTIO_CMN_CONFIG_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF1VF_VIRTIO_NOTIFICATION_BAR_OFFSET             = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF1VF_VIRTIO_ISRSTATUS_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF1VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET         = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF1VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET              = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF1VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF1VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH       = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF1VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF1VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH   = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF1VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH        = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF1VF_VIRTIO_NOTIFY_OFF_MULTIPLIER               = 32'h00000008, //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF2 VFs
  //****************************************************************************************************
   parameter       PF2VF_VIRTIO_CAPABILITY_PRESENT                  = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF2VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT         = 0,            //This is optional capability for VIRTIO
   
   parameter       PF2VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF2VF_VIRTIO_NOTIFICATION_BAR_INDICATOR          = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF2VF_VIRTIO_ISRSTATUS_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF2VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR      = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF2VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR           = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF2VF_VIRTIO_CMN_CONFIG_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF2VF_VIRTIO_NOTIFICATION_BAR_OFFSET             = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF2VF_VIRTIO_ISRSTATUS_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF2VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET         = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF2VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET              = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF2VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF2VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH       = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF2VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF2VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH   = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF2VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH        = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF2VF_VIRTIO_NOTIFY_OFF_MULTIPLIER               = 32'h00000008, //Indicates Multiplier for queue_notify_off  
  
  //****************************************************************************************************
  // VirtIO Specific Parameters PF3 VFs
  //****************************************************************************************************
   parameter       PF3VF_VIRTIO_CAPABILITY_PRESENT                  = 0,            //Indicates VIRTIO Capability is Present             
   parameter       PF3VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT         = 0,            //This is optional capability for VIRTIO
   
   parameter       PF3VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR            = 8'h00,        //Indicates BAR holding the Common Config Structure
   parameter       PF3VF_VIRTIO_NOTIFICATION_BAR_INDICATOR          = 8'h00,        //Indicates BAR holding the Notification Structure
   parameter       PF3VF_VIRTIO_ISRSTATUS_BAR_INDICATOR             = 8'h00,        //Indicates BAR holding the ISR STATUS Structure 
   parameter       PF3VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR      = 8'h00,        //Indicates BAR holding the PCI Config Access Structure 
   parameter       PF3VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR           = 8'h00,        //Indicates BAR holding the Device Specific Configuration Structure    
                                                                    
   parameter       PF3VF_VIRTIO_CMN_CONFIG_BAR_OFFSET               = 32'h00000000, //Indicates Starting position of Common Config Structure in given BAR
   parameter       PF3VF_VIRTIO_NOTIFICATION_BAR_OFFSET             = 32'h00000000, //Indicates Starting position of Notification Structure in given BAR
   parameter       PF3VF_VIRTIO_ISRSTATUS_BAR_OFFSET                = 32'h00000000, //Indicates Starting position of ISR STATUS Structure in given BAR
   parameter       PF3VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET         = 32'h00000000, //Indicates Starting position of PCI Config Access Structure in given BAR
   parameter       PF3VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET              = 32'h00000000, //Indicates Starting position of Device Specific Configuration Structure in given BAR
                                                                    
   parameter       PF3VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH         = 32'h00000008, //Indicates length of Common Config Structure
   parameter       PF3VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH       = 32'h00000008, //Indicates length of Notification Structure
   parameter       PF3VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH          = 32'h00000008, //Indicates length of ISR STATUS Structure 
   parameter       PF3VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH   = 32'h00000008, //Indicates length of PCI Config Access Structure 
   parameter       PF3VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH        = 32'h00000008, //Indicates length of Device Specific Configuration Structure    
   parameter       PF3VF_VIRTIO_NOTIFY_OFF_MULTIPLIER               = 32'h00000008, //Indicates Multiplier for queue_notify_off  
   
   //****************************************************************************************************
   // Customer-Specific Parameters
   //****************************************************************************************************
   parameter PF0_EXTRA_BAR_PRESENT                = 0,  // Set to 1 to enable extra  64-bit BAR in PF 0
   parameter PF0_EXTRA_BAR_SIZE                   = 12, // Aperture of Extra BAR
                                                        // 12 = 4K bytes, 12 = 8K bytes, ..., 63 = 8E
   parameter DEVHIDE_SUPPORT                      = 0,  // Set to 1 to enable Device Hide feature.
                                                        // Device will generate UR when devhide_pf0 input set to 1.
   parameter DEVICE_EMBEDDED_EP_SUPPORT           = 0   // Set to 1 to enable device to advertise as RC-integrated EP
                                                        // when the device_rciep input is set to 1.
   ) (
   // Clocks 
   input wire                                   pld_clk,
   // Resets
   input wire                                   power_on_reset_n,
   input wire                                   testin_zero,
   input wire                                   reset_status,

   input wire                                   pld_clk_inuse,
   //###################################################################################
   // Avalon receive Data Streaming Interface from HIP
   //###################################################################################
   input wire [DATA_WIDTH-1:0]                  rx_st_data_hip,
   input wire [DATA_WIDTH/8 -1:0]               rx_st_parity_hip,
   input wire                                   rx_st_sop_hip,
   input wire                                   rx_st_eop_hip,
   input wire                                   rx_st_err_hip, 
   input wire                                   rx_st_valid_hip,
   input wire [DATA_WIDTH/128 -1:0]             rx_st_empty_hip,
   output wire                                  rx_st_ready_hip,
   output wire                                  rx_st_mask_hip, 
   input wire                                   rxfc_cplbuf_ovf_hip,  // Signals overflow of the RX buffer in the HIP
   //###################################################################################
   // Avalon receive Data Streaming Interface to user application
   //###################################################################################
   output wire [DATA_WIDTH-1:0]                 rx_st_data_app,
   output wire [DATA_WIDTH/8 -1:0]              rx_st_parity_app,
   output wire                                  rx_st_sop_app,
   output wire                                  rx_st_eop_app,
   output wire                                  rx_st_err_app,
   output wire                                  rx_st_valid_app,
   output wire [DATA_WIDTH/128 -1:0]            rx_st_empty_app,
   input wire                                   rx_st_ready_app,
   input wire                                   rx_st_mask_app, 
   // Function number and BAR identification signals
   output wire [2:0]                            rx_st_bar_range, // Matching BAR number
   output wire [TOTAL_PF_COUNT_WIDTH-1:0]       rx_st_pf_num, // PF number that was hit
   output wire [TOTAL_VF_COUNT_WIDTH-1:0]       rx_st_vf_num, // Offset of VF number that was hit
   output wire                                  rx_st_vf_active, // Indicates that the Function
                                                                 // that was hit is a VF
   output wire                                  rx_st_pf_exprom_bar_hit, //Indicates Expansion ROM Bar Hit                                                             
   //###################################################################################
   // Avalon Transmit Data Streaming Interface to HIP
   //###################################################################################
   output wire [DATA_WIDTH-1:0]                 tx_st_data_hip,
   output wire [DATA_WIDTH/8 -1:0]              tx_st_parity_hip,
   output wire                                  tx_st_sop_hip,
   output wire                                  tx_st_eop_hip,
   output wire                                  tx_st_err_hip,
   output wire                                  tx_st_valid_hip,
   output wire  [DATA_WIDTH/128 -1:0]           tx_st_empty_hip,
   input  wire                                  tx_st_ready_hip,
   //###################################################################################
   // Avalon Transmit Data Streaming Interface from user application
   //###################################################################################
   input wire [DATA_WIDTH-1:0]                  tx_st_data_app,
   input wire [DATA_WIDTH/8 -1:0]               tx_st_parity_app,
   input wire                                   tx_st_sop_app,
   input wire                                   tx_st_eop_app,
   input wire                                   tx_st_err_app,
   input wire                                   tx_st_valid_app,
   input wire  [1:0]                            tx_st_empty_app,
   output wire                                  tx_st_ready_app,
   input wire [TOTAL_PF_COUNT_WIDTH-1:0]        tx_st_pf_num, // PF number of originating Fn
   input wire [TOTAL_VF_COUNT_WIDTH-1:0]        tx_st_vf_num, // Offset of VF number 
                                                              // of originating Fn  
   input wire                                   tx_st_vf_active, // Indicates that the 
                                                                 // originating Fn is a VF
   output [5:0]                                 tx_cred_fc_hip_cons_o,//One clock cycle pulse indicating tx credit consumed by SRIOV core
   //###################################################################################
   // Interrupt interface
   //###################################################################################
   input wire [TOTAL_PF_COUNT-1:0]              app_int_sts, // Legacy interrupt status from PFs
   output wire [TOTAL_PF_COUNT-1:0]             app_intx_disable, // INTX Disable from 
                                                                  // PCI Command Register of PFs
   input wire                                   app_msi_req, // MSI interrupt request
   input wire [TOTAL_PF_COUNT_WIDTH-1:0]        app_msi_req_fn, // Function number corresponding to
                                                                // MSI interrupt request
   input wire [4:0]                             app_msi_num, // MSI interrupt number corresponding to
                                                             // MSI interrupt request
   input wire [2:0]                             app_msi_tc,  // Traffic Class corresponding to
                                                             // MSI interrupt request
   output wire                                  app_msi_ack, // Ack to MSI interrupt request
   output wire [1:0]                            app_msi_status, // Execution status of MSI interrupt request,
                                                                // 00 = MSI message sent, 
                                                                // 01 = Pending bit set and no message sent, 
                                                                // 10 = error 
   input wire                                   app_msix_req, // MSIX interrupt request, common for all Functions
   input wire [63:0]                            app_msix_addr,  // Address to be sent in MSIX interrupt message
   input wire [31:0]                            app_msix_data,  // Data to be sent in MSIX interrupt message
   input wire [TOTAL_PF_COUNT_WIDTH-1:0]        app_msix_pf_num, // PF number of Function originating
                                                                 // MSIX interrupt
   input wire [TOTAL_VF_COUNT_WIDTH-1:0]        app_msix_vf_num, // VF number offset of Function originating
                                                                 // MSIX interrupt
   input wire                                   app_msix_vf_active, // Indicates that the Function originating
                                                                    // MSIX interrupt is a VF
   input wire [2:0]                             app_msix_tc,  // Traffic Class corresponding to
                                                              // MSIX interrupt request
   output wire                                  app_msix_ack, // Ack to MSIX interrupt request
   output wire                                  app_msix_err, // Error status for MSIX interrupt request,
                                                              // common for all Functions
   input wire                                   app_msi_pending_bit_write_en, // Write enable for bit 
                                                              // in the MSI Pending Bit Register
   input wire                                   app_msi_pending_bit_write_data, // Write data for bit 
                                                              // in the MSI Pending Bit Register
   // PF MSI Capability Register Outputs
   output wire [TOTAL_PF_COUNT*64-1:0]          app_msi_addr_pf,// MSI Address Register setting of PFs
   output wire [TOTAL_PF_COUNT*16-1:0]          app_msi_data_pf,// MSI Data Register setting of PFs
   output wire [TOTAL_PF_COUNT*32-1:0]          app_msi_mask_pf,// MSI Mask Register setting of PFs
   output wire [TOTAL_PF_COUNT*32-1:0]          app_msi_pending_pf,// MSI Pending Bit Register setting of PFs
   output wire [TOTAL_PF_COUNT-1:0]             app_msi_enable_pf,// MSI Enable setting of PFs
   output wire [TOTAL_PF_COUNT*3-1:0]           app_msi_multi_msg_enable_pf,// MSI Multiple Msg field setting of PFs
   // MSIX Capability Register Outputs
   output wire [TOTAL_PF_COUNT-1:0]             app_msix_en_pf, // MSIX Enable bit from MSIX Control Reg of PFs
   output wire [TOTAL_PF_COUNT-1:0]             app_msix_fn_mask_pf, // MSIX Function Mask bit from 
                                                                     // MSIX Control Reg of PFs
   //###################################################################################
   // Configuration Status Interface of PFs
   //###################################################################################
   output wire [7:0]                            bus_num_f0, // Captured bus number for PF 0
   output wire [7:0]                            bus_num_f1, // Captured bus number for PF 1
   output wire [7:0]                            bus_num_f2, // Captured bus number for PF 2
   output wire [7:0]                            bus_num_f3, // Captured bus number for PF 3
   output wire [7:0]                            bus_num_f4,
   output wire [7:0]                            bus_num_f5,
   output wire [7:0]                            bus_num_f6,
   output wire [7:0]                            bus_num_f7,   
   output wire [4:0]                            device_num_f0, // Captured device number for PF 0
   output wire [4:0]                            device_num_f1, // Captured device number for PF 1
   output wire [4:0]                            device_num_f2, // Captured device number for PF 2
   output wire [4:0]                            device_num_f3, // Captured device number for PF 3
   output wire [4:0]                            device_num_f4,
   output wire [4:0]                            device_num_f5,
   output wire [4:0]                            device_num_f6,
   output wire [4:0]                            device_num_f7,   
   output wire [TOTAL_PF_COUNT-1:0]             mem_space_en_pf, // Memory Space Enable for PFs
   output wire [TOTAL_PF_COUNT-1:0]             bus_master_en_pf, // Bus Master Enable for PFs
   output wire [TOTAL_PF_COUNT-1:0]             mem_space_en_vf, // Memory Space Enable for VFs 
                                                 // (common for all VFs attached to the same PF)
   output wire [TOTAL_PF_COUNT-1:0]             exprom_en_pf,  //Expansion ROM Enable per PF                                              
   output wire [15:0]                           pf0_num_vfs, // Number of enabled VFs for PF 0        
   output wire [15:0]                           pf1_num_vfs, // Number of enabled VFs for PF 1        
   output wire [15:0]                           pf2_num_vfs, // Number of enabled VFs for PF 2        
   output wire [15:0]                           pf3_num_vfs, // Number of enabled VFs for PF 3        
   output wire [2:0]                            max_payload_size, // Max payload size from
                                                                 // Device Control Register
   output wire [2:0]                            rd_req_size, // Read Request Size from 
                                                               //Device Control Register
   output wire [TOTAL_PF_COUNT-1:0]             compl_timeout_disable_pf, // Completion Timeout Disable for PFs
                                                               // Bit 4 of Device Control 2 Reg
   output wire [TOTAL_PF_COUNT-1:0]             atomic_op_requester_en_pf, // AtomicOp Requester Enable for PFs
                                                               // Bit 6 of Device Control 2 Reg
   output wire [TOTAL_PF_COUNT-1:0]             extended_tag_en_pf, // Extended Tag Enable for PFs
                                                               // Bit 8 of Device Control Reg
   output wire [TOTAL_PF_COUNT*2-1:0]           tph_st_mode_pf, // TPH ST Mode Select for PFs
                                                               // Bits [1:0] of TPH Requester Control Reg
   output wire [TOTAL_PF_COUNT-1:0]             tph_requester_en_pf, // TPH Requester Enable for PFs
                                                               // Bit 8 of TPH Requester Control Reg
   output wire [TOTAL_PF_COUNT*5-1:0]           ats_stu_pf, // Smallest Translation Unit field of
                                                             // ATS Control Register (bits 4:0)
   output wire [TOTAL_PF_COUNT-1:0]             ats_en_pf,  // ATS Enable for PFs
                                                             // Bit 15 of ATS Control Reg
   //###################################################################################
   // Control Shadow Interface of VFs
   //###################################################################################
   output wire                                  ctl_shdw_update, // Indicates presence of valid data
                                                              // on ctl_shdw_* outputs
   output wire [TOTAL_PF_COUNT_WIDTH-1:0]       ctl_shdw_pf_num, // PF number of config register
                                                               // whose data is on ctl_shdw_cfg
   output wire [TOTAL_VF_COUNT_WIDTH-1:0]       ctl_shdw_vf_num, // VF number offset of config register
                                                               // whose data is on ctl_shdw_cfg
   output wire                                  ctl_shdw_vf_active, // Indicates that the Function whose
                                                               // data is on ctl_shdw_cfg is a VF.
   output wire [6:0]                            ctl_shdw_cfg, // Config Register outputs
                                                // Bit 0 = Bus Master Enable
                                                // Bit 1 = MSIX Function Mask
                                                // Bit 2 = MSIX Enable
                                                // Bit 4:3 = TPH ST Mode Sel
                                                // Bit 5 = TPH Requester Enable
                                                // Bit 6 = ATS Enable
   input wire                                   ctl_shdw_req_all, // Scan request from user
   //###################################################################################
   // LMI interface to HIP
   //###################################################################################
   output wire [11:0]                           lmi_addr_hip,
   output wire [31:0]                           lmi_din_hip,
   output wire                                  lmi_rden_hip,
   output wire                                  lmi_wren_hip,
   input wire                                   lmi_ack_hip,
   input wire [31:0]                            lmi_dout_hip,
   //###################################################################################
   // LMI interface to user application
   //###################################################################################
   input wire [11:0]                            lmi_addr_app, // [11:0] = address
   input wire [TOTAL_PF_COUNT_WIDTH-1:0]        lmi_pf_num_app, // PF number of config register
                                                               // to read or write
   input wire [TOTAL_VF_COUNT_WIDTH-1:0]        lmi_vf_num_app, // VF number offset of config register
                                                               // to read or write
   input wire                                   lmi_vf_active_app, // Indicates that the register
                                                                  // being read or written resides in a VF.
   input wire [31:0]                            lmi_din_app,
   input wire                                   lmi_rden_app,
   input wire                                   lmi_wren_app,
   output wire                                  lmi_ack_app,
   output wire [31:0]                           lmi_dout_app,
   //###################################################################################
   // Status signals from HIP.
   // These are passed through to the user application unmodified.
   //###################################################################################
   input wire                                   derr_cor_ext_rcv,
   input wire                                   derr_cor_ext_rpl,
   input wire                                   derr_rpl,
   input wire                                   dlup_exit,
   input wire                                   ev128ns,
   input wire                                   ev1us,
   input wire                                   hotrst_exit,
   input wire [3:0]                             int_status,
   input wire                                   l2_exit,          // used by reset block
   input wire [3:0]                             lane_act,
   input wire [4:0]                             ltssmstate,       // used by reset block  
   input wire                                   dlup,
   input wire                                   rx_par_err ,
   input wire [1:0]                             tx_par_err ,
   input wire                                   cfg_par_err,
   input wire [7:0]                             ko_cpl_spc_header,
   input wire [11:0]                            ko_cpl_spc_data,
   //###################################################################################
   // Status signals to user application
   //###################################################################################
   output wire                                  derr_cor_ext_rcv_drv,
   output wire                                  derr_cor_ext_rpl_drv,
   output wire                                  derr_rpl_drv,
   output wire                                  dlup_exit_drv,
   output wire                                  ev128ns_drv,
   output wire                                  ev1us_drv,
   output wire                                  hotrst_exit_drv,
   output wire [3:0]                            int_status_drv,
   output wire                                  l2_exit_drv,
   output wire [3:0]                            lane_act_drv,
   output wire [4:0]                            ltssmstate_drv,
   output wire                                  dlup_drv,
   output wire                                  rx_par_err_drv,
   output wire [1:0]                            tx_par_err_drv,
   output wire                                  cfg_par_err_drv,
   output wire [7:0]                            ko_cpl_spc_header_drv,
   output wire [11:0]                           ko_cpl_spc_data_drv,
   output wire                                  rxfc_cplbuf_ovf_app,  // Signals overflow of the RX buffer in the HIP
   //###################################################################################
   // Completion Status Signals from user application
   //###################################################################################
   input wire [6:0]                             cpl_err,    // Error indications from user application  
                                      // [0] = Completion timeout with recovery
                                      // [1] = Completion timeout without recovery
                                      // [2] = Completer Abort sent
                                      // [3] = Unexpected Completion received
                                      // [4] = Posted request received and flagged as UR
                                      // [5] = Non-Posted request received and flagged as UR
                                      // [6] = Header Logging enable (header supplied on log_hdr input) 
   input wire [TOTAL_PF_COUNT_WIDTH-1:0]        cpl_err_pf_num, // PF number of reporting Function      
   input wire [TOTAL_VF_COUNT_WIDTH-1:0]        cpl_err_vf_num, // VF number offset of reporting Function      
   input wire                                   cpl_err_vf_active, // Indicates that the reporting Function
                                                                   // is a VF.
   input wire [TOTAL_PF_COUNT-1:0]              cpl_pending_pf,// Completion pending status from PFs
   input wire [127:0]                           log_hdr,    // TLP header for logging
   input wire                                   vf_compl_status_update, //Completion Pending status update from VF
   input wire                                   vf_compl_status, // current Completion Pending status of VF
   input wire [TOTAL_PF_COUNT_WIDTH-1:0]        vf_compl_status_pf_num, // PF number of Function reporting
                                                                        // Completion Pending status.
   input wire [TOTAL_VF_COUNT_WIDTH-1:0]        vf_compl_status_vf_num, // VF number offset of Function reporting
                                                                        // Completion Pending status.
   output wire                                  vf_compl_status_update_ack, // Ack from SR-IOV Bridge indicating
                                                                        // Completion Pending status change has been
                                                                        // processed.
   //###################################################################################
   // FLR Interface
   //###################################################################################
   output wire [TOTAL_PF_COUNT-1:0]             flr_active_pf, // FLR status for PFs
   input wire [TOTAL_PF_COUNT-1:0]              flr_completed_pf, // Indication from user to re-enable PFs after FLR
   output wire                                  flr_rcvd_vf, // One-cycle pulse indicates that
                                                             // an FLR was received from host targeting a VF.
   output wire [TOTAL_PF_COUNT_WIDTH-1:0]       flr_rcvd_pf_num, // Parent PF number of VF undergoing FLR
   output wire [TOTAL_VF_COUNT_WIDTH-1:0]       flr_rcvd_vf_num, // VF number offset of VF undergoing FLR
   input wire                                   flr_completed_vf, // One-cycle pulse from user to re-enable VF
   input wire [TOTAL_PF_COUNT_WIDTH-1:0]        flr_completed_pf_num, // Parent PF number of VF to re-enable
   input wire [TOTAL_VF_COUNT_WIDTH-1:0]        flr_completed_vf_num, // VF number offset of VF to re-enable
   //###################################################################################
   // Config Bypass inputs from HIP
   //###################################################################################
   input wire [7:0]                             cfgbp_lane_err, // Sets the error status bits in Lane Error Status Register
   input wire                                   cfgbp_link_equlz_req, // Input to set Link equalization request bit of Link Status 2 Register
   input wire                                   cfgbp_equiz_complete, // Input to set Equalization Complete bit of Link Status 2 Register
   input wire                                   cfgbp_phase_3_successful, // Input to set Equalization Phase 1 Successful bit of Link Status 2 Register
   input wire                                   cfgbp_phase_2_successful, // Input to set Equalization Phase 2 Successful bit of Link Status 2 Register
   input wire                                   cfgbp_phase_1_successful, // Input to set Equalization Phase 3 Successful bit of Link Status 2 Register
   input wire                                   cfgbp_current_deemph, // Current de-emphasis setting in Link Control 2 Register
   input wire [1:0]                             cfgbp_current_speed, // Current speed setting in Link Status Register
   input wire                                   cfgbp_link_up, // Unused

   input wire                                   cfgbp_link_train, // Unused
   input wire                                   cfgbp_10state, // Unused
   input wire                                   cfgbp_10sstate, // Unused
   input wire                                   cfgbp_rx_val_pm, // Unused
   input wire [2:0]                             cfgbp_rx_typ_pm, // Unused
   input wire                                   cfgbp_tx_ack_pm,// Unused
   input wire [1:0]                             cfgbp_ack_phypm, // Unused
   input wire                                   cfgbp_vc_status, // Unused
   input wire                                   cfgbp_rxfc_max, // Unused
   input wire                                   cfgbp_txfc_max, // Unused
   input wire                                   cfgbp_txbuf_emp,// Unused
   input wire                                   cfgbp_cfgbuf_emp, // Unused
   input wire                                   cfgbp_rpbuf_emp, // Unused
   input wire                                   cfgbp_dll_req, // Unused
   input wire                                   cfgbp_link_auto_bdw_status, // Unused
   input wire                                   cfgbp_link_bdw_mng_status, // Unused
   input wire                                   cfgbp_rst_tx_margin_field, // Resets Tx Margin bit in Link Control 2 Reg
   input wire                                   cfgbp_rst_enter_comp_bit, // Resets Enter Compliance bit in Link Control 2 Reg
   input wire [3:0]                             cfgbp_rx_st_ecrcerr, // Sets the ECRC error status bit in in AER Uncorr Err Status Register
   input wire                                   cfgbp_err_uncorr_internal, // Unused
   input wire                                   cfgbp_rx_corr_internal, // Unused
   input wire                                   cfgbp_err_tlrcvovf, // Sets the Receive FIFO overflow status bit in in AER Uncorr Err Status Register
   input wire                                   cfgbp_txfc_err, // Sets the Flow Control Protocol Error status bit in in AER Uncorr Err Status Register
   input wire                                   cfgbp_err_tlmalf, // Sets the Malformed TLP Error status bit in in AER Uncorr Err Status Register
   input wire                                   cfgbp_err_surpdwn_dll, // Not used
   input wire                                   cfgbp_err_dllrev, // Sets the DL Protocol Error status bit in in AER Uncorr Err Status Register
   input wire                                   cfgbp_err_dll_repnum, // Sets the Replay Number Rollover Error status bit in in AER Corr Err Status Register
   input wire                                   cfgbp_err_dllreptim, // Sets the Replay Timeout Error status bit in in AER Corr Err Status Register
   input wire                                   cfgbp_err_dllp_baddllp, // Sets the DLLP Error status bit in in AER Corr Err Status Register
   input wire                                   cfgbp_err_dll_badtlp, // Sets the TLP Error status bit in in AER Corr Err Status Register
   input wire                                   cfgbp_err_phy_tng, // Unused
   input wire                                   cfgbp_err_phy_rcv, // Sets the Receiver Error status bit in in AER Corr Err Status Register
   input wire                                   cfgbp_root_err_reg_sts, // Unused
   input wire                                   cfgbp_corr_err_reg_sts, // Unused
   input wire                                   cfgbp_unc_err_reg_sts, // Unused
   //###################################################################################
   // Config Bypass Outputs to HIP
   //###################################################################################
   output wire [12:0]                           cfgbp_link2csr, // Setting of bits [12:0] of Link Control 2 Register of PF 0
   output wire                                  cfgbp_comclk_reg, // Common Clock Configuration bit from Link Control Register of PF 0
   output wire                                  cfgbp_extsy_reg, // // Extended Synch Enable bit from Link Control Register of PF 0
   output wire [2:0]                            cfgbp_max_pload, // Max Payload Size from Device Control Register 
   output wire                                  cfgbp_tx_ecrcgen, // ECRC Generation Enable bit from AER Advanced Error Capabilities and Control Register of PF 0
   output wire                                  cfgbp_rx_ecrchk,  // ECRC Check Enable bit from AER Advanced Error Capabilities and Control Register of PF 0
   output wire [7:0]                            cfgbp_secbus, // Unused, set to 0
   output wire                                  cfgbp_linkcsr_bit0, // ASPM control bit 0 from Link Control Register of PF 0
   output wire                                  cfgbp_tx_req_pm, // Unused, set to 0
   output wire [2:0]                            cfgbp_tx_typ_pm, // Unused, set to 0
   output wire [3:0]                            cfgbp_req_phypm, // Unused, set to 0
   output wire [3:0]                            cfgbp_req_phycfg, // Unused, set to 0
   output wire [6:0]                            cfgbp_vc0_tcmap_pld, // Unused, set to 0
   output wire                                  cfgbp_inh_dllp, // Unused, set to 0
   output wire                                  cfgbp_inh_tx_tlp,  // Unused, set to 0
   output wire                                  cfgbp_req_wake,  // Unused, set to 0
   output wire [1:0]                            cfgbp_link3_ctl,  // Unused, set to 0
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF0
   //###################################################################################
   output [7:0 ]    f0_virtio_pcicfg_bar_o,       
   output [31:0 ]   f0_virtio_pcicfg_length_o,    
   output [31:0 ]   f0_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f0_virtio_pcicfg_cfgdata_o,   
   output           f0_virtio_pcicfg_cfgwr_o,     
   output           f0_virtio_pcicfg_cfgrd_o,
   input            f0_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f0_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f0_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF1
   //###################################################################################
   output [7:0 ]    f1_virtio_pcicfg_bar_o,       
   output [31:0 ]   f1_virtio_pcicfg_length_o,    
   output [31:0 ]   f1_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f1_virtio_pcicfg_cfgdata_o,   
   output           f1_virtio_pcicfg_cfgwr_o,     
   output           f1_virtio_pcicfg_cfgrd_o,
   input            f1_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f1_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f1_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF2
   //###################################################################################
   output [7:0 ]    f2_virtio_pcicfg_bar_o,       
   output [31:0 ]   f2_virtio_pcicfg_length_o,    
   output [31:0 ]   f2_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f2_virtio_pcicfg_cfgdata_o,   
   output           f2_virtio_pcicfg_cfgwr_o,     
   output           f2_virtio_pcicfg_cfgrd_o,
   input            f2_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f2_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f2_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF3
   //###################################################################################
   output [7:0 ]    f3_virtio_pcicfg_bar_o,       
   output [31:0 ]   f3_virtio_pcicfg_length_o,    
   output [31:0 ]   f3_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f3_virtio_pcicfg_cfgdata_o,   
   output           f3_virtio_pcicfg_cfgwr_o,     
   output           f3_virtio_pcicfg_cfgrd_o,
   input            f3_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f3_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f3_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF4
   //###################################################################################
   output [7:0 ]    f4_virtio_pcicfg_bar_o,       
   output [31:0 ]   f4_virtio_pcicfg_length_o,    
   output [31:0 ]   f4_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f4_virtio_pcicfg_cfgdata_o,   
   output           f4_virtio_pcicfg_cfgwr_o,     
   output           f4_virtio_pcicfg_cfgrd_o,
   input            f4_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f4_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f4_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF5
   //###################################################################################
   output [7:0 ]    f5_virtio_pcicfg_bar_o,       
   output [31:0 ]   f5_virtio_pcicfg_length_o,    
   output [31:0 ]   f5_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f5_virtio_pcicfg_cfgdata_o,   
   output           f5_virtio_pcicfg_cfgwr_o,     
   output           f5_virtio_pcicfg_cfgrd_o,
   input            f5_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f5_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f5_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF6
   //###################################################################################
   output [7:0 ]    f6_virtio_pcicfg_bar_o,       
   output [31:0 ]   f6_virtio_pcicfg_length_o,    
   output [31:0 ]   f6_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f6_virtio_pcicfg_cfgdata_o,   
   output           f6_virtio_pcicfg_cfgwr_o,     
   output           f6_virtio_pcicfg_cfgrd_o,
   input            f6_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f6_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f6_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF7
   //###################################################################################
   output [7:0 ]    f7_virtio_pcicfg_bar_o,       
   output [31:0 ]   f7_virtio_pcicfg_length_o,    
   output [31:0 ]   f7_virtio_pcicfg_baroffset_o, 
   output [31:0 ]   f7_virtio_pcicfg_cfgdata_o,   
   output           f7_virtio_pcicfg_cfgwr_o,     
   output           f7_virtio_pcicfg_cfgrd_o,
   input            f7_virtio_pcicfg_rdack_i,     //Application Read Data Ack to store config data
   input  [3:0]     f7_virtio_pcicfg_rdbe_i,      //Application indicates which byte to store
   input  [31:0]    f7_virtio_pcicfg_data_i,      //Data to be stored in config data register
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF0 VFs
   //###################################################################################
   output [7:0 ]                 f0vf_virtio_pcicfg_bar_o,       
   output [31:0]                 f0vf_virtio_pcicfg_length_o,    
   output [31:0]                 f0vf_virtio_pcicfg_baroffset_o, 
   output [31:0]                 f0vf_virtio_pcicfg_cfgdata_o,   
   output                        f0vf_virtio_pcicfg_cfgwr_o,     
   output                        f0vf_virtio_pcicfg_cfgrd_o,
   output [TOTAL_VF_COUNT_WIDTH-1:0]     f0vf_virtio_pcicfg_vfnum_o,
   input                         f0vf_virtio_pcicfg_rdack_i,     // Application Read Data Ack to store config data
   input  [3:0 ]                 f0vf_virtio_pcicfg_rdbe_i,      // Application indicates which byte to store
   input  [31:0]                 f0vf_virtio_pcicfg_data_i,      // Data to be stored in config data register
   input  [TOTAL_VF_COUNT_WIDTH-1:0]     f0vf_virtio_pcicfg_appvfnum_i,  // Application indicates for which VF
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF1 VFs
   //###################################################################################
   output [7:0 ]                 f1vf_virtio_pcicfg_bar_o,       
   output [31:0]                 f1vf_virtio_pcicfg_length_o,    
   output [31:0]                 f1vf_virtio_pcicfg_baroffset_o, 
   output [31:0]                 f1vf_virtio_pcicfg_cfgdata_o,   
   output                        f1vf_virtio_pcicfg_cfgwr_o,     
   output                        f1vf_virtio_pcicfg_cfgrd_o,
   output [TOTAL_VF_COUNT_WIDTH-1:0]     f1vf_virtio_pcicfg_vfnum_o,
   input                         f1vf_virtio_pcicfg_rdack_i,     // Application Read Data Ack to store config data
   input  [3:0 ]                 f1vf_virtio_pcicfg_rdbe_i,      // Application indicates which byte to store
   input  [31:0]                 f1vf_virtio_pcicfg_data_i,      // Data to be stored in config data register
   input  [TOTAL_VF_COUNT_WIDTH-1:0]     f1vf_virtio_pcicfg_appvfnum_i,  // Application indicates for which VF
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF2 VFs
   //###################################################################################
   output [7:0 ]                 f2vf_virtio_pcicfg_bar_o,       
   output [31:0]                 f2vf_virtio_pcicfg_length_o,    
   output [31:0]                 f2vf_virtio_pcicfg_baroffset_o, 
   output [31:0]                 f2vf_virtio_pcicfg_cfgdata_o,   
   output                        f2vf_virtio_pcicfg_cfgwr_o,     
   output                        f2vf_virtio_pcicfg_cfgrd_o,
   output [TOTAL_VF_COUNT_WIDTH-1:0]     f2vf_virtio_pcicfg_vfnum_o,
   input                         f2vf_virtio_pcicfg_rdack_i,     // Application Read Data Ack to store config data
   input  [3:0 ]                 f2vf_virtio_pcicfg_rdbe_i,      // Application indicates which byte to store
   input  [31:0]                 f2vf_virtio_pcicfg_data_i,      // Data to be stored in config data register
   input  [TOTAL_VF_COUNT_WIDTH-1:0]     f2vf_virtio_pcicfg_appvfnum_i,  // Application indicates for which VF
   //###################################################################################
   //VIRTIO PCICFG ACCESS Hooks PF3 VFs
   //###################################################################################
   output [7:0 ]                 f3vf_virtio_pcicfg_bar_o,       
   output [31:0]                 f3vf_virtio_pcicfg_length_o,    
   output [31:0]                 f3vf_virtio_pcicfg_baroffset_o, 
   output [31:0]                 f3vf_virtio_pcicfg_cfgdata_o,   
   output                        f3vf_virtio_pcicfg_cfgwr_o,     
   output                        f3vf_virtio_pcicfg_cfgrd_o,
   output [TOTAL_VF_COUNT_WIDTH-1:0]     f3vf_virtio_pcicfg_vfnum_o,
   input                         f3vf_virtio_pcicfg_rdack_i,     // Application Read Data Ack to store config data
   input  [3:0 ]                 f3vf_virtio_pcicfg_rdbe_i,      // Application indicates which byte to store
   input  [31:0]                 f3vf_virtio_pcicfg_data_i,      // Data to be stored in config data register
   input  [TOTAL_VF_COUNT_WIDTH-1:0]     f3vf_virtio_pcicfg_appvfnum_i,  // Application indicates for which VF
   //****************************************************************************************************
   // Customer-Specific Inputs and Outputs
   //****************************************************************************************************
   input wire                                    extraBAR_lock,  // Set to 1 to disable writes to Extra BAR
   input wire [TOTAL_PF_COUNT-1:0]               devhide_pf,     // When the ith bits is set to 1, Config accesses 
                                                                 // to PF i will generate UR.
   input wire                                    device_rciep,   // When set to 1, device will advertise itself
                                                                 // as RC Integrated EndPoint.
   output wire                                   extraBAR_hit    // Signals a hit to extra BAR on a mem access.
                                                                 // Valid when rx_st_sop_app and rx_st_valid_app are both high.
   );

  // BAR apertures      
   wire [63:0]    f0_bar0_aperture;
   wire [63:0]    f0_bar1_aperture;
   wire [63:0]    f0_bar2_aperture;
   wire [63:0]    f0_bar3_aperture;
   wire [63:0]    f0_bar4_aperture;
   wire [63:0]    f0_bar5_aperture;
   wire [31:0]    f0_exprom_bar_aperture;

   wire [63:0]    f0_vf_bar0_aperture;
   wire [63:0]    f0_vf_bar1_aperture;
   wire [63:0]    f0_vf_bar2_aperture;
   wire [63:0]    f0_vf_bar3_aperture;
   wire [63:0]    f0_vf_bar4_aperture;
   wire [63:0]    f0_vf_bar5_aperture;

   wire [63:0]    f0_vf_bar0_aperture_bitmask;
   wire [63:0]    f0_vf_bar1_aperture_bitmask;
   wire [63:0]    f0_vf_bar2_aperture_bitmask;
   wire [63:0]    f0_vf_bar3_aperture_bitmask;
   wire [63:0]    f0_vf_bar4_aperture_bitmask;
   wire [63:0]    f0_vf_bar5_aperture_bitmask;

   wire [63:0]    f1_bar0_aperture;
   wire [63:0]    f1_bar1_aperture;
   wire [63:0]    f1_bar2_aperture;
   wire [63:0]    f1_bar3_aperture;
   wire [63:0]    f1_bar4_aperture;
   wire [63:0]    f1_bar5_aperture;
   wire [31:0]    f1_exprom_bar_aperture;

   wire [63:0]    f1_vf_bar0_aperture;
   wire [63:0]    f1_vf_bar1_aperture;
   wire [63:0]    f1_vf_bar2_aperture;
   wire [63:0]    f1_vf_bar3_aperture;
   wire [63:0]    f1_vf_bar4_aperture;
   wire [63:0]    f1_vf_bar5_aperture;

   wire [63:0]    f1_vf_bar0_aperture_bitmask;
   wire [63:0]    f1_vf_bar1_aperture_bitmask;
   wire [63:0]    f1_vf_bar2_aperture_bitmask;
   wire [63:0]    f1_vf_bar3_aperture_bitmask;
   wire [63:0]    f1_vf_bar4_aperture_bitmask;
   wire [63:0]    f1_vf_bar5_aperture_bitmask;

   wire [63:0]    f2_bar0_aperture;
   wire [63:0]    f2_bar1_aperture;
   wire [63:0]    f2_bar2_aperture;
   wire [63:0]    f2_bar3_aperture;
   wire [63:0]    f2_bar4_aperture;
   wire [63:0]    f2_bar5_aperture;
   wire [31:0]    f2_exprom_bar_aperture;

   wire [63:0]    f2_vf_bar0_aperture;
   wire [63:0]    f2_vf_bar1_aperture;
   wire [63:0]    f2_vf_bar2_aperture;
   wire [63:0]    f2_vf_bar3_aperture;
   wire [63:0]    f2_vf_bar4_aperture;
   wire [63:0]    f2_vf_bar5_aperture;

   wire [63:0]    f2_vf_bar0_aperture_bitmask;
   wire [63:0]    f2_vf_bar1_aperture_bitmask;
   wire [63:0]    f2_vf_bar2_aperture_bitmask;
   wire [63:0]    f2_vf_bar3_aperture_bitmask;
   wire [63:0]    f2_vf_bar4_aperture_bitmask;
   wire [63:0]    f2_vf_bar5_aperture_bitmask;

   wire [63:0]    f3_bar0_aperture;
   wire [63:0]    f3_bar1_aperture;
   wire [63:0]    f3_bar2_aperture;
   wire [63:0]    f3_bar3_aperture;
   wire [63:0]    f3_bar4_aperture;
   wire [63:0]    f3_bar5_aperture;
   wire [31:0]    f3_exprom_bar_aperture;

   wire [63:0]    f3_vf_bar0_aperture;
   wire [63:0]    f3_vf_bar1_aperture;
   wire [63:0]    f3_vf_bar2_aperture;
   wire [63:0]    f3_vf_bar3_aperture;
   wire [63:0]    f3_vf_bar4_aperture;
   wire [63:0]    f3_vf_bar5_aperture;

   wire [63:0]    f3_vf_bar0_aperture_bitmask;
   wire [63:0]    f3_vf_bar1_aperture_bitmask;
   wire [63:0]    f3_vf_bar2_aperture_bitmask;
   wire [63:0]    f3_vf_bar3_aperture_bitmask;
   wire [63:0]    f3_vf_bar4_aperture_bitmask;
   wire [63:0]    f3_vf_bar5_aperture_bitmask;

   wire [63:0]    f4_bar0_aperture;
   wire [63:0]    f4_bar1_aperture;
   wire [63:0]    f4_bar2_aperture;
   wire [63:0]    f4_bar3_aperture;
   wire [63:0]    f4_bar4_aperture;
   wire [63:0]    f4_bar5_aperture;
   wire [31:0]    f4_exprom_bar_aperture;

   wire [63:0]    f5_bar0_aperture;
   wire [63:0]    f5_bar1_aperture;
   wire [63:0]    f5_bar2_aperture;
   wire [63:0]    f5_bar3_aperture;
   wire [63:0]    f5_bar4_aperture;
   wire [63:0]    f5_bar5_aperture;
   wire [31:0]    f5_exprom_bar_aperture;

   wire [63:0]    f6_bar0_aperture;
   wire [63:0]    f6_bar1_aperture;
   wire [63:0]    f6_bar2_aperture;
   wire [63:0]    f6_bar3_aperture;
   wire [63:0]    f6_bar4_aperture;
   wire [63:0]    f6_bar5_aperture;
   wire [31:0]    f6_exprom_bar_aperture;

   wire [63:0]    f7_bar0_aperture;
   wire [63:0]    f7_bar1_aperture;
   wire [63:0]    f7_bar2_aperture;
   wire [63:0]    f7_bar3_aperture;
   wire [63:0]    f7_bar4_aperture;
   wire [63:0]    f7_bar5_aperture;
   wire [31:0]    f7_exprom_bar_aperture;   
   wire [2:0]     max_payload_size_int;

   wire           app_rstn;

   //======================
   // Generated reset
   //======================
   altpcierd_hip_rs rs_hip (
      .npor             (!reset_status & pld_clk_inuse),
      .pld_clk          (pld_clk),
      .dlup_exit        (dlup_exit),
      .hotrst_exit      (!reset_status),
      .l2_exit          (l2_exit),     // from hip_status block
      .ltssm            (ltssmstate),  // from hip_status block
      .app_rstn         (app_rstn),
      .test_sim         (testin_zero)
   );


  //=====================================================================
  // Calculate BAR apertures of Function 0 PF BARs
  //=====================================================================
  assign f0_bar0_aperture =                                                  {{(64-PF0_BAR0_SIZE){1'b1}}, {(PF0_BAR0_SIZE){1'b0}}};
  assign f0_bar1_aperture = (PF0_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF0_BAR1_SIZE){1'b1}}, {(PF0_BAR1_SIZE){1'b0}}};
  assign f0_bar2_aperture =                                                  {{(64-PF0_BAR2_SIZE){1'b1}}, {(PF0_BAR2_SIZE){1'b0}}};
  assign f0_bar3_aperture = (PF0_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF0_BAR3_SIZE){1'b1}}, {(PF0_BAR3_SIZE){1'b0}}};
  assign f0_bar4_aperture =                                                  {{(64-PF0_BAR4_SIZE){1'b1}}, {(PF0_BAR4_SIZE){1'b0}}};
  assign f0_bar5_aperture = (PF0_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF0_BAR5_SIZE){1'b1}}, {(PF0_BAR5_SIZE){1'b0}}};
  assign f0_exprom_bar_aperture =                                            {{(32-PF0_EXPROM_BAR_SIZE){1'b1}}, {(PF0_EXPROM_BAR_SIZE){1'b0}}}; 
  //=====================================================================
  // Calculate BAR apertures of Function 1 PF BARs
  //=====================================================================
  assign f1_bar0_aperture =                                                  {{(64-PF1_BAR0_SIZE){1'b1}}, {(PF1_BAR0_SIZE){1'b0}}};
  assign f1_bar1_aperture = (PF1_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF1_BAR1_SIZE){1'b1}}, {(PF1_BAR1_SIZE){1'b0}}};
  assign f1_bar2_aperture =                                                  {{(64-PF1_BAR2_SIZE){1'b1}}, {(PF1_BAR2_SIZE){1'b0}}};
  assign f1_bar3_aperture = (PF1_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF1_BAR3_SIZE){1'b1}}, {(PF1_BAR3_SIZE){1'b0}}};
  assign f1_bar4_aperture =                                                  {{(64-PF1_BAR4_SIZE){1'b1}}, {(PF1_BAR4_SIZE){1'b0}}};
  assign f1_bar5_aperture = (PF1_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF1_BAR5_SIZE){1'b1}}, {(PF1_BAR5_SIZE){1'b0}}};
  assign f1_exprom_bar_aperture =                                            {{(32-PF1_EXPROM_BAR_SIZE){1'b1}}, {(PF1_EXPROM_BAR_SIZE){1'b0}}}; 

  //=====================================================================
  // Calculate BAR apertures of Function 2 PF BARs
  //=====================================================================
  assign f2_bar0_aperture =                                                  {{(64-PF2_BAR0_SIZE){1'b1}}, {(PF2_BAR0_SIZE){1'b0}}};
  assign f2_bar1_aperture = (PF2_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF2_BAR1_SIZE){1'b1}}, {(PF2_BAR1_SIZE){1'b0}}};
  assign f2_bar2_aperture =                                                  {{(64-PF2_BAR2_SIZE){1'b1}}, {(PF2_BAR2_SIZE){1'b0}}};
  assign f2_bar3_aperture = (PF2_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF2_BAR3_SIZE){1'b1}}, {(PF2_BAR3_SIZE){1'b0}}};
  assign f2_bar4_aperture =                                                  {{(64-PF2_BAR4_SIZE){1'b1}}, {(PF2_BAR4_SIZE){1'b0}}};
  assign f2_bar5_aperture = (PF2_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF2_BAR5_SIZE){1'b1}}, {(PF2_BAR5_SIZE){1'b0}}};
  assign f2_exprom_bar_aperture =                                            {{(32-PF2_EXPROM_BAR_SIZE){1'b1}}, {(PF2_EXPROM_BAR_SIZE){1'b0}}}; 

  //=====================================================================
  // Calculate BAR apertures of Function 3 PF BARs
  //=====================================================================
  assign f3_bar0_aperture =                                                  {{(64-PF3_BAR0_SIZE){1'b1}}, {(PF3_BAR0_SIZE){1'b0}}};
  assign f3_bar1_aperture = (PF3_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF3_BAR1_SIZE){1'b1}}, {(PF3_BAR1_SIZE){1'b0}}};
  assign f3_bar2_aperture =                                                  {{(64-PF3_BAR2_SIZE){1'b1}}, {(PF3_BAR2_SIZE){1'b0}}};
  assign f3_bar3_aperture = (PF3_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF3_BAR3_SIZE){1'b1}}, {(PF3_BAR3_SIZE){1'b0}}};
  assign f3_bar4_aperture =                                                  {{(64-PF3_BAR4_SIZE){1'b1}}, {(PF3_BAR4_SIZE){1'b0}}};
  assign f3_bar5_aperture = (PF3_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF3_BAR5_SIZE){1'b1}}, {(PF3_BAR5_SIZE){1'b0}}};
  assign f3_exprom_bar_aperture =                                            {{(32-PF3_EXPROM_BAR_SIZE){1'b1}}, {(PF3_EXPROM_BAR_SIZE){1'b0}}}; 

  //=====================================================================
  // Calculate BAR apertures of Function 4 PF BARs
  //=====================================================================
  assign f4_bar0_aperture =                                                  {{(64-PF4_BAR0_SIZE){1'b1}}, {(PF4_BAR0_SIZE){1'b0}}};
  assign f4_bar1_aperture = (PF4_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF4_BAR1_SIZE){1'b1}}, {(PF4_BAR1_SIZE){1'b0}}};
  assign f4_bar2_aperture =                                                  {{(64-PF4_BAR2_SIZE){1'b1}}, {(PF4_BAR2_SIZE){1'b0}}};
  assign f4_bar3_aperture = (PF4_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF4_BAR3_SIZE){1'b1}}, {(PF4_BAR3_SIZE){1'b0}}};
  assign f4_bar4_aperture =                                                  {{(64-PF4_BAR4_SIZE){1'b1}}, {(PF4_BAR4_SIZE){1'b0}}};
  assign f4_bar5_aperture = (PF4_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF4_BAR5_SIZE){1'b1}}, {(PF4_BAR5_SIZE){1'b0}}};
  assign f4_exprom_bar_aperture =                                            {{(32-PF4_EXPROM_BAR_SIZE){1'b1}}, {(PF4_EXPROM_BAR_SIZE){1'b0}}}; 

  //=====================================================================
  // Calculate BAR apertures of Function 5 PF BARs
  //=====================================================================
  assign f5_bar0_aperture =                                                  {{(64-PF5_BAR0_SIZE){1'b1}}, {(PF5_BAR0_SIZE){1'b0}}};
  assign f5_bar1_aperture = (PF5_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF5_BAR1_SIZE){1'b1}}, {(PF5_BAR1_SIZE){1'b0}}};
  assign f5_bar2_aperture =                                                  {{(64-PF5_BAR2_SIZE){1'b1}}, {(PF5_BAR2_SIZE){1'b0}}};
  assign f5_bar3_aperture = (PF5_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF5_BAR3_SIZE){1'b1}}, {(PF5_BAR3_SIZE){1'b0}}};
  assign f5_bar4_aperture =                                                  {{(64-PF5_BAR4_SIZE){1'b1}}, {(PF5_BAR4_SIZE){1'b0}}};
  assign f5_bar5_aperture = (PF5_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF5_BAR5_SIZE){1'b1}}, {(PF5_BAR5_SIZE){1'b0}}};
  assign f5_exprom_bar_aperture =                                            {{(32-PF5_EXPROM_BAR_SIZE){1'b1}}, {(PF5_EXPROM_BAR_SIZE){1'b0}}}; 

  //=====================================================================
  // Calculate BAR apertures of Function 6 PF BARs
  //=====================================================================
  assign f6_bar0_aperture =                                                  {{(64-PF6_BAR0_SIZE){1'b1}}, {(PF6_BAR0_SIZE){1'b0}}};
  assign f6_bar1_aperture = (PF6_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF6_BAR1_SIZE){1'b1}}, {(PF6_BAR1_SIZE){1'b0}}};
  assign f6_bar2_aperture =                                                  {{(64-PF6_BAR2_SIZE){1'b1}}, {(PF6_BAR2_SIZE){1'b0}}};
  assign f6_bar3_aperture = (PF6_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF6_BAR3_SIZE){1'b1}}, {(PF6_BAR3_SIZE){1'b0}}};
  assign f6_bar4_aperture =                                                  {{(64-PF6_BAR4_SIZE){1'b1}}, {(PF6_BAR4_SIZE){1'b0}}};
  assign f6_bar5_aperture = (PF6_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF6_BAR5_SIZE){1'b1}}, {(PF6_BAR5_SIZE){1'b0}}};
  assign f6_exprom_bar_aperture =                                            {{(32-PF6_EXPROM_BAR_SIZE){1'b1}}, {(PF6_EXPROM_BAR_SIZE){1'b0}}}; 

  //=====================================================================
  // Calculate BAR apertures of Function 7 PF BARs
  //=====================================================================
  assign f7_bar0_aperture =                                                  {{(64-PF7_BAR0_SIZE){1'b1}}, {(PF7_BAR0_SIZE){1'b0}}};
  assign f7_bar1_aperture = (PF7_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF7_BAR1_SIZE){1'b1}}, {(PF7_BAR1_SIZE){1'b0}}};
  assign f7_bar2_aperture =                                                  {{(64-PF7_BAR2_SIZE){1'b1}}, {(PF7_BAR2_SIZE){1'b0}}};
  assign f7_bar3_aperture = (PF7_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF7_BAR3_SIZE){1'b1}}, {(PF7_BAR3_SIZE){1'b0}}};
  assign f7_bar4_aperture =                                                  {{(64-PF7_BAR4_SIZE){1'b1}}, {(PF7_BAR4_SIZE){1'b0}}};
  assign f7_bar5_aperture = (PF7_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF7_BAR5_SIZE){1'b1}}, {(PF7_BAR5_SIZE){1'b0}}};
  assign f7_exprom_bar_aperture =                                            {{(32-PF7_EXPROM_BAR_SIZE){1'b1}}, {(PF7_EXPROM_BAR_SIZE){1'b0}}}; 
  
  //=====================================================================
  // Calculate BAR apertures of Function 0 VF BARs
  //=====================================================================
  assign f0_vf_bar0_aperture         =                                   (1'b1 << PF0_VF_BAR0_SIZE); 
  assign f0_vf_bar1_aperture         = (PF0_VF_BAR0_TYPE == 1) ? 32'h0 : (1'b1 << PF0_VF_BAR1_SIZE); 
  assign f0_vf_bar2_aperture         =                                   (1'b1 << PF0_VF_BAR2_SIZE); 
  assign f0_vf_bar3_aperture         = (PF0_VF_BAR2_TYPE == 1) ? 32'h0 : (1'b1 << PF0_VF_BAR3_SIZE); 
  assign f0_vf_bar4_aperture         =                                   (1'b1 << PF0_VF_BAR4_SIZE); 
  assign f0_vf_bar5_aperture         = (PF0_VF_BAR4_TYPE == 1) ? 32'h0 : (1'b1 << PF0_VF_BAR5_SIZE); 

  assign f0_vf_bar0_aperture_bitmask =                                                     {{(64-PF0_VF_BAR0_SIZE){1'b1}}, {(PF0_VF_BAR0_SIZE){1'b0}}};
  assign f0_vf_bar1_aperture_bitmask = (PF0_VF_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF0_VF_BAR1_SIZE){1'b1}}, {(PF0_VF_BAR1_SIZE){1'b0}}};
  assign f0_vf_bar2_aperture_bitmask =                                                     {{(64-PF0_VF_BAR2_SIZE){1'b1}}, {(PF0_VF_BAR2_SIZE){1'b0}}};
  assign f0_vf_bar3_aperture_bitmask = (PF0_VF_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF0_VF_BAR3_SIZE){1'b1}}, {(PF0_VF_BAR3_SIZE){1'b0}}};
  assign f0_vf_bar4_aperture_bitmask =                                                     {{(64-PF0_VF_BAR4_SIZE){1'b1}}, {(PF0_VF_BAR4_SIZE){1'b0}}};
  assign f0_vf_bar5_aperture_bitmask = (PF0_VF_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF0_VF_BAR5_SIZE){1'b1}}, {(PF0_VF_BAR5_SIZE){1'b0}}};

  //=====================================================================
  // Calculate BAR apertures of Function 1 VF BARs
  //=====================================================================
  assign f1_vf_bar0_aperture         =                                   (1'b1 << PF1_VF_BAR0_SIZE); 
  assign f1_vf_bar1_aperture         = (PF1_VF_BAR0_TYPE == 1) ? 32'h0 : (1'b1 << PF1_VF_BAR1_SIZE); 
  assign f1_vf_bar2_aperture         =                                   (1'b1 << PF1_VF_BAR2_SIZE); 
  assign f1_vf_bar3_aperture         = (PF1_VF_BAR2_TYPE == 1) ? 32'h0 : (1'b1 << PF1_VF_BAR3_SIZE); 
  assign f1_vf_bar4_aperture         =                                   (1'b1 << PF1_VF_BAR4_SIZE); 
  assign f1_vf_bar5_aperture         = (PF1_VF_BAR4_TYPE == 1) ? 32'h0 : (1'b1 << PF1_VF_BAR5_SIZE); 

  assign f1_vf_bar0_aperture_bitmask =                                                     {{(64-PF1_VF_BAR0_SIZE){1'b1}}, {(PF1_VF_BAR0_SIZE){1'b0}}};
  assign f1_vf_bar1_aperture_bitmask = (PF1_VF_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF1_VF_BAR1_SIZE){1'b1}}, {(PF1_VF_BAR1_SIZE){1'b0}}};
  assign f1_vf_bar2_aperture_bitmask =                                                     {{(64-PF1_VF_BAR2_SIZE){1'b1}}, {(PF1_VF_BAR2_SIZE){1'b0}}};
  assign f1_vf_bar3_aperture_bitmask = (PF1_VF_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF1_VF_BAR3_SIZE){1'b1}}, {(PF1_VF_BAR3_SIZE){1'b0}}};
  assign f1_vf_bar4_aperture_bitmask =                                                     {{(64-PF1_VF_BAR4_SIZE){1'b1}}, {(PF1_VF_BAR4_SIZE){1'b0}}};
  assign f1_vf_bar5_aperture_bitmask = (PF1_VF_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF1_VF_BAR5_SIZE){1'b1}}, {(PF1_VF_BAR5_SIZE){1'b0}}};

  //=====================================================================
  // Calculate BAR apertures of Function 2 VF BARs
  //=====================================================================
  assign f2_vf_bar0_aperture         =                                   (1'b1 << PF2_VF_BAR0_SIZE); 
  assign f2_vf_bar1_aperture         = (PF2_VF_BAR0_TYPE == 1) ? 32'h0 : (1'b1 << PF2_VF_BAR1_SIZE); 
  assign f2_vf_bar2_aperture         =                                   (1'b1 << PF2_VF_BAR2_SIZE); 
  assign f2_vf_bar3_aperture         = (PF2_VF_BAR2_TYPE == 1) ? 32'h0 : (1'b1 << PF2_VF_BAR3_SIZE); 
  assign f2_vf_bar4_aperture         =                                   (1'b1 << PF2_VF_BAR4_SIZE); 
  assign f2_vf_bar5_aperture         = (PF2_VF_BAR4_TYPE == 1) ? 32'h0 : (1'b1 << PF2_VF_BAR5_SIZE); 

  assign f2_vf_bar0_aperture_bitmask =                                                     {{(64-PF2_VF_BAR0_SIZE){1'b1}}, {(PF2_VF_BAR0_SIZE){1'b0}}};
  assign f2_vf_bar1_aperture_bitmask = (PF2_VF_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF2_VF_BAR1_SIZE){1'b1}}, {(PF2_VF_BAR1_SIZE){1'b0}}};
  assign f2_vf_bar2_aperture_bitmask =                                                     {{(64-PF2_VF_BAR2_SIZE){1'b1}}, {(PF2_VF_BAR2_SIZE){1'b0}}};
  assign f2_vf_bar3_aperture_bitmask = (PF2_VF_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF2_VF_BAR3_SIZE){1'b1}}, {(PF2_VF_BAR3_SIZE){1'b0}}};
  assign f2_vf_bar4_aperture_bitmask =                                                     {{(64-PF2_VF_BAR4_SIZE){1'b1}}, {(PF2_VF_BAR4_SIZE){1'b0}}};
  assign f2_vf_bar5_aperture_bitmask = (PF2_VF_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF2_VF_BAR5_SIZE){1'b1}}, {(PF2_VF_BAR5_SIZE){1'b0}}};

  //=====================================================================
  // Calculate BAR apertures of Function 3 VF BARs
  //=====================================================================
  assign f3_vf_bar0_aperture         =                                   (1'b1 << PF3_VF_BAR0_SIZE); 
  assign f3_vf_bar1_aperture         = (PF3_VF_BAR0_TYPE == 1) ? 32'h0 : (1'b1 << PF3_VF_BAR1_SIZE); 
  assign f3_vf_bar2_aperture         =                                   (1'b1 << PF3_VF_BAR2_SIZE); 
  assign f3_vf_bar3_aperture         = (PF3_VF_BAR2_TYPE == 1) ? 32'h0 : (1'b1 << PF3_VF_BAR3_SIZE); 
  assign f3_vf_bar4_aperture         =                                   (1'b1 << PF3_VF_BAR4_SIZE); 
  assign f3_vf_bar5_aperture         = (PF3_VF_BAR4_TYPE == 1) ? 32'h0 : (1'b1 << PF3_VF_BAR5_SIZE); 

  assign f3_vf_bar0_aperture_bitmask =                                                     {{(64-PF3_VF_BAR0_SIZE){1'b1}}, {(PF3_VF_BAR0_SIZE){1'b0}}};
  assign f3_vf_bar1_aperture_bitmask = (PF3_VF_BAR0_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF3_VF_BAR1_SIZE){1'b1}}, {(PF3_VF_BAR1_SIZE){1'b0}}};
  assign f3_vf_bar2_aperture_bitmask =                                                     {{(64-PF3_VF_BAR2_SIZE){1'b1}}, {(PF3_VF_BAR2_SIZE){1'b0}}};
  assign f3_vf_bar3_aperture_bitmask = (PF3_VF_BAR2_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF3_VF_BAR3_SIZE){1'b1}}, {(PF3_VF_BAR3_SIZE){1'b0}}};
  assign f3_vf_bar4_aperture_bitmask =                                                     {{(64-PF3_VF_BAR4_SIZE){1'b1}}, {(PF3_VF_BAR4_SIZE){1'b0}}};
  assign f3_vf_bar5_aperture_bitmask = (PF3_VF_BAR4_TYPE == 1) ? 64'hffff_ffff_ffff_ffff : {{(64-PF3_VF_BAR5_SIZE){1'b1}}, {(PF3_VF_BAR5_SIZE){1'b0}}};

  //=====================================================================
  // Set aperture of customer-specific Extra BAR
  //=====================================================================
   wire [63:12] f0_extra_bar_aperture = {{(64-PF0_EXTRA_BAR_SIZE){1'b1}}, {(PF0_EXTRA_BAR_SIZE-12){1'b0}}};
   
//Add two stahe syncronizer for tl_cfg_sts (config bypass signals)

localparam phase3_successful_pos = 0;                          // 0
localparam phase2_successful_pos = phase3_successful_pos + 1;  // 1
localparam phase1_successful_pos = phase2_successful_pos + 1;  // 2
localparam eqcompl_pos           = phase1_successful_pos + 1;  // 3
localparam eqreq_pos             = eqcompl_pos + 1;            // 4  
localparam lane_err_pos          = eqreq_pos + 1;              // 5
localparam lane_err_end          = lane_err_pos + 7;           // 12
localparam txmargin_pos          = lane_err_end + 1;           // 13
localparam enter_compliance_pos  = txmargin_pos + 1;           // 14
localparam repnum_pos            = enter_compliance_pos + 1;   // 15
localparam reptim_pos            = repnum_pos + 1;             // 16
localparam badtlp_pos            = reptim_pos + 1;             // 17
localparam baddllp_pos           = badtlp_pos + 1;             // 18
localparam rcvr_err_pos          = baddllp_pos + 1;            // 19
localparam ecrc_err_pos          = rcvr_err_pos + 1;           // 20
localparam ecrc_err_end          = ecrc_err_pos + 3;           // 23
localparam malf_pos              = ecrc_err_end + 1;           // 24
localparam rcvr_ovfl_pos         = malf_pos + 1;               // 25
localparam fc_err_pos            = rcvr_ovfl_pos + 1;          // 26
localparam dlpro_err_pos         = fc_err_pos +1;              // 27
localparam deemph_pos            = dlpro_err_pos + 1;          // 28
localparam speed_pos             = deemph_pos + 1;             // 29
localparam speed_end             = speed_pos + 1;              // 30 


wire [speed_end : phase3_successful_pos] cfgbp_hip2sriov ;
reg  [speed_end : phase3_successful_pos] cfgbp_hip2sriov_q1,cfgbp_hip2sriov_q2;


assign cfgbp_hip2sriov = {cfgbp_current_speed,cfgbp_current_deemph,cfgbp_err_dllrev,
                          cfgbp_txfc_err,cfgbp_err_tlrcvovf,cfgbp_err_tlmalf,
                          cfgbp_rx_st_ecrcerr,cfgbp_err_phy_rcv,cfgbp_err_dllp_baddllp,
                          cfgbp_err_dll_badtlp,cfgbp_err_dllreptim,cfgbp_err_dll_repnum,
                          cfgbp_rst_enter_comp_bit,cfgbp_rst_tx_margin_field,cfgbp_lane_err,
                          cfgbp_link_equlz_req,cfgbp_equiz_complete,cfgbp_phase_1_successful,
                          cfgbp_phase_2_successful,cfgbp_phase_3_successful};

always @ (posedge pld_clk ) begin
  cfgbp_hip2sriov_q1 <= cfgbp_hip2sriov;
  cfgbp_hip2sriov_q2 <= cfgbp_hip2sriov_q1;
end
   
   //======================
   // SR_IOV Bridge Top
   //======================
   altpcie_sriov2_top 
     #(
       // Device-Level Parameters                                     
       .MAX_LINK_SPEED                      (MAX_LINK_SPEED),
       .LINK_WIDTH                          (LINK_WIDTH),
       .DATA_WIDTH                          (DATA_WIDTH),
       .CLK_FREQUENCY                       (CLK_FREQUENCY),
       .PARITY_SUPPORT                      (PARITY_SUPPORT),
       .ARI_SUPPORT                         (ARI_SUPPORT),
       .ENABLE_ALTERNATE_LINK_LIST          (ENABLE_ALTERNATE_LINK_LIST),
       .TOTAL_PF_COUNT                      (TOTAL_PF_COUNT),
       .TOTAL_PF_COUNT_WIDTH                (TOTAL_PF_COUNT_WIDTH),
       .FLR_SUPPORT                         (FLR_SUPPORT),
       .RELAXED_ORDER_SUPPORT               (RELAXED_ORDER_SUPPORT),
       .EXTENDED_TAG_SUPPORT                (EXTENDED_TAG_SUPPORT),
       .MAX_PAYLOAD_SIZE                    (MAX_PAYLOAD_SIZE),
       .NO_SOFT_RESET                       (NO_SOFT_RESET),
       .DROP_POISONED_REQ                   (DROP_POISONED_REQ),
       .DROP_POISONED_COMPL                 (DROP_POISONED_COMPL),
       .SIG_TEST_EN                         (SIG_TEST_EN),
      // PCI Configuration Space parameters
      .PF0_VENDOR_ID          (PF0_VENDOR_ID          ),
      .PF1_VENDOR_ID          (PF1_VENDOR_ID          ),
      .PF2_VENDOR_ID          (PF2_VENDOR_ID          ),
      .PF3_VENDOR_ID          (PF3_VENDOR_ID          ),
      .PF4_VENDOR_ID          (PF4_VENDOR_ID          ),
      .PF5_VENDOR_ID          (PF5_VENDOR_ID          ),
      .PF6_VENDOR_ID          (PF6_VENDOR_ID          ),
      .PF7_VENDOR_ID          (PF7_VENDOR_ID          ),
      .PF0_DEVICE_ID          (PF0_DEVICE_ID          ),
      .PF1_DEVICE_ID          (PF1_DEVICE_ID          ),
      .PF2_DEVICE_ID          (PF2_DEVICE_ID          ),
      .PF3_DEVICE_ID          (PF3_DEVICE_ID          ),
      .PF4_DEVICE_ID          (PF4_DEVICE_ID          ),
      .PF5_DEVICE_ID          (PF5_DEVICE_ID          ),
      .PF6_DEVICE_ID          (PF6_DEVICE_ID          ),
      .PF7_DEVICE_ID          (PF7_DEVICE_ID),
      .PF0_SUBVENDOR_ID       (PF0_SUBVENDOR_ID       ),
      .PF1_SUBVENDOR_ID       (PF1_SUBVENDOR_ID       ),
      .PF2_SUBVENDOR_ID       (PF2_SUBVENDOR_ID       ),
      .PF3_SUBVENDOR_ID       (PF3_SUBVENDOR_ID       ),
      .PF4_SUBVENDOR_ID       (PF4_SUBVENDOR_ID       ),
      .PF5_SUBVENDOR_ID       (PF5_SUBVENDOR_ID       ),
      .PF6_SUBVENDOR_ID       (PF6_SUBVENDOR_ID       ),
      .PF7_SUBVENDOR_ID       (PF7_SUBVENDOR_ID),
      .PF0_SUBSYS_ID          (PF0_SUBSYS_ID          ),
      .PF1_SUBSYS_ID          (PF1_SUBSYS_ID          ),
      .PF2_SUBSYS_ID          (PF2_SUBSYS_ID          ),
      .PF3_SUBSYS_ID          (PF3_SUBSYS_ID          ),
      .PF4_SUBSYS_ID          (PF4_SUBSYS_ID          ),
      .PF5_SUBSYS_ID          (PF5_SUBSYS_ID          ),
      .PF6_SUBSYS_ID          (PF6_SUBSYS_ID          ),
      .PF7_SUBSYS_ID          (PF7_SUBSYS_ID),
      .PF0_CLASS_CODE         (PF0_CLASS_CODE         ),
      .PF1_CLASS_CODE         (PF1_CLASS_CODE         ),
      .PF2_CLASS_CODE         (PF2_CLASS_CODE         ),
      .PF3_CLASS_CODE         (PF3_CLASS_CODE         ),
      .PF4_CLASS_CODE         (PF4_CLASS_CODE         ),
      .PF5_CLASS_CODE         (PF5_CLASS_CODE         ),
      .PF6_CLASS_CODE         (PF6_CLASS_CODE         ),
      .PF7_CLASS_CODE         (PF7_CLASS_CODE),
      .PF0_SUBCLASS_CODE      (PF0_SUBCLASS_CODE      ),
      .PF1_SUBCLASS_CODE      (PF1_SUBCLASS_CODE      ),
      .PF2_SUBCLASS_CODE      (PF2_SUBCLASS_CODE      ),
      .PF3_SUBCLASS_CODE      (PF3_SUBCLASS_CODE      ),
      .PF4_SUBCLASS_CODE      (PF4_SUBCLASS_CODE      ),
      .PF5_SUBCLASS_CODE      (PF5_SUBCLASS_CODE      ),
      .PF6_SUBCLASS_CODE      (PF6_SUBCLASS_CODE      ),
      .PF7_SUBCLASS_CODE      (PF7_SUBCLASS_CODE),
      .PF0_PCI_PROG_INTFC_BYTE(PF0_PCI_PROG_INTFC_BYTE),
      .PF1_PCI_PROG_INTFC_BYTE(PF1_PCI_PROG_INTFC_BYTE),
      .PF2_PCI_PROG_INTFC_BYTE(PF2_PCI_PROG_INTFC_BYTE),
      .PF3_PCI_PROG_INTFC_BYTE(PF3_PCI_PROG_INTFC_BYTE),
      .PF4_PCI_PROG_INTFC_BYTE(PF4_PCI_PROG_INTFC_BYTE),
      .PF5_PCI_PROG_INTFC_BYTE(PF5_PCI_PROG_INTFC_BYTE),
      .PF6_PCI_PROG_INTFC_BYTE(PF6_PCI_PROG_INTFC_BYTE),
      .PF7_PCI_PROG_INTFC_BYTE(PF7_PCI_PROG_INTFC_BYTE),
      .PF0_REVISION_ID        (PF0_REVISION_ID        ),
      .PF1_REVISION_ID        (PF1_REVISION_ID        ),
      .PF2_REVISION_ID        (PF2_REVISION_ID        ),
      .PF3_REVISION_ID        (PF3_REVISION_ID        ),
      .PF4_REVISION_ID        (PF4_REVISION_ID        ),
      .PF5_REVISION_ID        (PF5_REVISION_ID        ),
      .PF6_REVISION_ID        (PF6_REVISION_ID        ),
      .PF7_REVISION_ID        (PF7_REVISION_ID        ),
      .PF0_INTR_PIN           (PF0_INTR_PIN           ),
      .PF1_INTR_PIN           (PF1_INTR_PIN           ),
      .PF2_INTR_PIN           (PF2_INTR_PIN           ),
      .PF3_INTR_PIN           (PF3_INTR_PIN           ),
      .PF4_INTR_PIN           (PF4_INTR_PIN           ),
      .PF5_INTR_PIN           (PF5_INTR_PIN           ),
      .PF6_INTR_PIN           (PF6_INTR_PIN           ),
      .PF7_INTR_PIN           (PF7_INTR_PIN           ),
      .PF0_INTR_LINE          (PF0_INTR_LINE          ),
      .PF1_INTR_LINE          (PF1_INTR_LINE          ),
      .PF2_INTR_LINE          (PF2_INTR_LINE          ),
      .PF3_INTR_LINE          (PF3_INTR_LINE          ),
      .PF4_INTR_LINE          (PF4_INTR_LINE          ),
      .PF5_INTR_LINE          (PF5_INTR_LINE          ),
      .PF6_INTR_LINE          (PF6_INTR_LINE          ),
      .PF7_INTR_LINE          (PF7_INTR_LINE          ),
      // PCI Express Configuration Space parameters
       .SLOT_CLK_CFG                        (SLOT_CLK_CFG),
       .EP_L0S_ACCEPTABLE_LATENCY           (EP_L0S_ACCEPTABLE_LATENCY),
       .EP_L1_ACCEPTABLE_LATENCY            (EP_L1_ACCEPTABLE_LATENCY),
       .ASPM_L0S_SUPPORT                    (ASPM_L0S_SUPPORT),
       .ASPM_L1_SUPPORT                     (ASPM_L1_SUPPORT),
       .L0S_EXIT_LATENCY                    (L0S_EXIT_LATENCY),
       .L1_EXIT_LATENCY                     (L1_EXIT_LATENCY),
       .COMPL_TIMEOUT_DISABLE_SUPPORT       (COMPL_TIMEOUT_DISABLE_SUPPORT),
       .COMPL_TIMEOUT_RANGES                (COMPL_TIMEOUT_RANGES),
       .ECRC_GEN_CAPABLE                    (ECRC_GEN_CAPABLE),
       .ECRC_CHECK_CAPABLE                  (ECRC_CHECK_CAPABLE),
     // SR-IOV parameters
       .SR_IOV_SUPPORT                      (SR_IOV_SUPPORT),
       .TOTAL_VF_COUNT                      (TOTAL_VF_COUNT),
       .TOTAL_VF_COUNT_WIDTH                (TOTAL_VF_COUNT_WIDTH),
       .PF0_VF_COUNT                        (PF0_VF_COUNT),
       .PF1_VF_COUNT                        (PF1_VF_COUNT),
       .PF2_VF_COUNT                        (PF2_VF_COUNT),
       .PF3_VF_COUNT                        (PF3_VF_COUNT),
       .PF0_VF_DEVICE_ID                    (PF0_VF_DEVICE_ID),
       .PF1_VF_DEVICE_ID                    (PF1_VF_DEVICE_ID),
       .PF2_VF_DEVICE_ID                    (PF2_VF_DEVICE_ID),
       .PF3_VF_DEVICE_ID                    (PF3_VF_DEVICE_ID),
       .SYSTEM_PAGE_SIZES_SUPPORTED         (SYSTEM_PAGE_SIZES_SUPPORTED),
      // MSI parameters (PFs only)
      .MSI_SUPPORT              (MSI_SUPPORT              ),
      .MSI_64BIT_CAPABLE        (MSI_64BIT_CAPABLE        ),
      .PF0_MSI_MULTI_MSG_CAPABLE(PF0_MSI_MULTI_MSG_CAPABLE),
      .PF1_MSI_MULTI_MSG_CAPABLE(PF1_MSI_MULTI_MSG_CAPABLE),
      .PF2_MSI_MULTI_MSG_CAPABLE(PF2_MSI_MULTI_MSG_CAPABLE),
      .PF3_MSI_MULTI_MSG_CAPABLE(PF3_MSI_MULTI_MSG_CAPABLE),
      .PF4_MSI_MULTI_MSG_CAPABLE(PF4_MSI_MULTI_MSG_CAPABLE),
      .PF5_MSI_MULTI_MSG_CAPABLE(PF5_MSI_MULTI_MSG_CAPABLE),
      .PF6_MSI_MULTI_MSG_CAPABLE(PF6_MSI_MULTI_MSG_CAPABLE),
      .PF7_MSI_MULTI_MSG_CAPABLE(PF7_MSI_MULTI_MSG_CAPABLE),
      // MSIX parameters of Physical Functions
      .MSIX_SUPPORT       (MSIX_SUPPORT       ),       
      .PF0_MSIX_TBL_SIZE  (PF0_MSIX_TBL_SIZE  ), 
      .PF1_MSIX_TBL_SIZE  (PF1_MSIX_TBL_SIZE  ),
      .PF2_MSIX_TBL_SIZE  (PF2_MSIX_TBL_SIZE  ),
      .PF3_MSIX_TBL_SIZE  (PF3_MSIX_TBL_SIZE  ),
      .PF4_MSIX_TBL_SIZE  (PF4_MSIX_TBL_SIZE  ),
      .PF5_MSIX_TBL_SIZE  (PF5_MSIX_TBL_SIZE  ),
      .PF6_MSIX_TBL_SIZE  (PF6_MSIX_TBL_SIZE  ),
      .PF7_MSIX_TBL_SIZE  (PF7_MSIX_TBL_SIZE  ),
      .PF0_MSIX_TBL_OFFSET(PF0_MSIX_TBL_OFFSET),
      .PF1_MSIX_TBL_OFFSET(PF1_MSIX_TBL_OFFSET),
      .PF2_MSIX_TBL_OFFSET(PF2_MSIX_TBL_OFFSET),
      .PF3_MSIX_TBL_OFFSET(PF3_MSIX_TBL_OFFSET),
      .PF4_MSIX_TBL_OFFSET(PF4_MSIX_TBL_OFFSET),
      .PF5_MSIX_TBL_OFFSET(PF5_MSIX_TBL_OFFSET),
      .PF6_MSIX_TBL_OFFSET(PF6_MSIX_TBL_OFFSET),
      .PF7_MSIX_TBL_OFFSET(PF7_MSIX_TBL_OFFSET),
      .PF0_MSIX_TBL_BIR   (PF0_MSIX_TBL_BIR   ), 
      .PF1_MSIX_TBL_BIR   (PF1_MSIX_TBL_BIR   ), 
      .PF2_MSIX_TBL_BIR   (PF2_MSIX_TBL_BIR   ), 
      .PF3_MSIX_TBL_BIR   (PF3_MSIX_TBL_BIR   ), 
      .PF4_MSIX_TBL_BIR   (PF4_MSIX_TBL_BIR   ), 
      .PF5_MSIX_TBL_BIR   (PF5_MSIX_TBL_BIR   ), 
      .PF6_MSIX_TBL_BIR   (PF6_MSIX_TBL_BIR   ), 
      .PF7_MSIX_TBL_BIR   (PF7_MSIX_TBL_BIR   ),
      .PF0_MSIX_PBA_OFFSET(PF0_MSIX_PBA_OFFSET),
      .PF1_MSIX_PBA_OFFSET(PF1_MSIX_PBA_OFFSET),
      .PF2_MSIX_PBA_OFFSET(PF2_MSIX_PBA_OFFSET),
      .PF3_MSIX_PBA_OFFSET(PF3_MSIX_PBA_OFFSET),
      .PF4_MSIX_PBA_OFFSET(PF4_MSIX_PBA_OFFSET),
      .PF5_MSIX_PBA_OFFSET(PF5_MSIX_PBA_OFFSET),
      .PF6_MSIX_PBA_OFFSET(PF6_MSIX_PBA_OFFSET),
      .PF7_MSIX_PBA_OFFSET(PF7_MSIX_PBA_OFFSET),
      .PF0_MSIX_PBA_BIR   (PF0_MSIX_PBA_BIR   ), 
      .PF1_MSIX_PBA_BIR   (PF1_MSIX_PBA_BIR   ), 
      .PF2_MSIX_PBA_BIR   (PF2_MSIX_PBA_BIR   ), 
      .PF3_MSIX_PBA_BIR   (PF3_MSIX_PBA_BIR   ), 
      .PF4_MSIX_PBA_BIR   (PF4_MSIX_PBA_BIR   ), 
      .PF5_MSIX_PBA_BIR   (PF5_MSIX_PBA_BIR   ), 
      .PF6_MSIX_PBA_BIR   (PF6_MSIX_PBA_BIR   ), 
      .PF7_MSIX_PBA_BIR   (PF7_MSIX_PBA_BIR   ),
     // MSIX parameters of Virtual Functions
       .VF_MSIX_SUPPORT                     (VF_MSIX_SUPPORT),
       .PF0_VF_MSIX_TBL_SIZE                (PF0_VF_MSIX_TBL_SIZE),
       .PF1_VF_MSIX_TBL_SIZE                (PF1_VF_MSIX_TBL_SIZE),
       .PF2_VF_MSIX_TBL_SIZE                (PF2_VF_MSIX_TBL_SIZE),
       .PF3_VF_MSIX_TBL_SIZE                (PF3_VF_MSIX_TBL_SIZE),
       .PF0_VF_MSIX_TBL_OFFSET              (PF0_VF_MSIX_TBL_OFFSET),
       .PF1_VF_MSIX_TBL_OFFSET              (PF1_VF_MSIX_TBL_OFFSET),
       .PF2_VF_MSIX_TBL_OFFSET              (PF2_VF_MSIX_TBL_OFFSET),
       .PF3_VF_MSIX_TBL_OFFSET              (PF3_VF_MSIX_TBL_OFFSET),
       .PF0_VF_MSIX_TBL_BIR                 (PF0_VF_MSIX_TBL_BIR),
       .PF1_VF_MSIX_TBL_BIR                 (PF1_VF_MSIX_TBL_BIR),
       .PF2_VF_MSIX_TBL_BIR                 (PF2_VF_MSIX_TBL_BIR),
       .PF3_VF_MSIX_TBL_BIR                 (PF3_VF_MSIX_TBL_BIR),
       .PF0_VF_MSIX_PBA_OFFSET              (PF0_VF_MSIX_PBA_OFFSET),
       .PF1_VF_MSIX_PBA_OFFSET              (PF1_VF_MSIX_PBA_OFFSET),
       .PF2_VF_MSIX_PBA_OFFSET              (PF2_VF_MSIX_PBA_OFFSET),
       .PF3_VF_MSIX_PBA_OFFSET              (PF3_VF_MSIX_PBA_OFFSET),
       .PF0_VF_MSIX_PBA_BIR                 (PF0_VF_MSIX_PBA_BIR),
       .PF1_VF_MSIX_PBA_BIR                 (PF1_VF_MSIX_PBA_BIR),
       .PF2_VF_MSIX_PBA_BIR                 (PF2_VF_MSIX_PBA_BIR),
       .PF3_VF_MSIX_PBA_BIR                 (PF3_VF_MSIX_PBA_BIR),
      // PF BAR parameters      
      .PF0_BAR0_PRESENT      (PF0_BAR0_PRESENT      ), 
      .PF1_BAR0_PRESENT      (PF1_BAR0_PRESENT      ),
      .PF2_BAR0_PRESENT      (PF2_BAR0_PRESENT      ),
      .PF3_BAR0_PRESENT      (PF3_BAR0_PRESENT      ),
      .PF4_BAR0_PRESENT      (PF4_BAR0_PRESENT      ),
      .PF5_BAR0_PRESENT      (PF5_BAR0_PRESENT      ),
      .PF6_BAR0_PRESENT      (PF6_BAR0_PRESENT      ),
      .PF7_BAR0_PRESENT      (PF7_BAR0_PRESENT      ),
      .PF0_BAR1_PRESENT      (PF0_BAR1_PRESENT      ),
      .PF1_BAR1_PRESENT      (PF1_BAR1_PRESENT      ),
      .PF2_BAR1_PRESENT      (PF2_BAR1_PRESENT      ),
      .PF3_BAR1_PRESENT      (PF3_BAR1_PRESENT      ),
      .PF4_BAR1_PRESENT      (PF4_BAR1_PRESENT      ),
      .PF5_BAR1_PRESENT      (PF5_BAR1_PRESENT      ),
      .PF6_BAR1_PRESENT      (PF6_BAR1_PRESENT      ),
      .PF7_BAR1_PRESENT      (PF7_BAR1_PRESENT      ),
      .PF0_BAR2_PRESENT      (PF0_BAR2_PRESENT      ),
      .PF1_BAR2_PRESENT      (PF1_BAR2_PRESENT      ),
      .PF2_BAR2_PRESENT      (PF2_BAR2_PRESENT      ),
      .PF3_BAR2_PRESENT      (PF3_BAR2_PRESENT      ),
      .PF4_BAR2_PRESENT      (PF4_BAR2_PRESENT      ),
      .PF5_BAR2_PRESENT      (PF5_BAR2_PRESENT      ),
      .PF6_BAR2_PRESENT      (PF6_BAR2_PRESENT      ),
      .PF7_BAR2_PRESENT      (PF7_BAR2_PRESENT      ),
      .PF0_BAR3_PRESENT      (PF0_BAR3_PRESENT      ),
      .PF1_BAR3_PRESENT      (PF1_BAR3_PRESENT      ),
      .PF2_BAR3_PRESENT      (PF2_BAR3_PRESENT      ),
      .PF3_BAR3_PRESENT      (PF3_BAR3_PRESENT      ),
      .PF4_BAR3_PRESENT      (PF4_BAR3_PRESENT      ),
      .PF5_BAR3_PRESENT      (PF5_BAR3_PRESENT      ),
      .PF6_BAR3_PRESENT      (PF6_BAR3_PRESENT      ),
      .PF7_BAR3_PRESENT      (PF7_BAR3_PRESENT      ),
      .PF0_BAR4_PRESENT      (PF0_BAR4_PRESENT      ),
      .PF1_BAR4_PRESENT      (PF1_BAR4_PRESENT      ),
      .PF2_BAR4_PRESENT      (PF2_BAR4_PRESENT      ),
      .PF3_BAR4_PRESENT      (PF3_BAR4_PRESENT      ),
      .PF4_BAR4_PRESENT      (PF4_BAR4_PRESENT      ),
      .PF5_BAR4_PRESENT      (PF5_BAR4_PRESENT      ),
      .PF6_BAR4_PRESENT      (PF6_BAR4_PRESENT      ),
      .PF7_BAR4_PRESENT      (PF7_BAR4_PRESENT      ),
      .PF0_BAR5_PRESENT      (PF0_BAR5_PRESENT      ),
      .PF1_BAR5_PRESENT      (PF1_BAR5_PRESENT      ),
      .PF2_BAR5_PRESENT      (PF2_BAR5_PRESENT      ),
      .PF3_BAR5_PRESENT      (PF3_BAR5_PRESENT      ),
      .PF4_BAR5_PRESENT      (PF4_BAR5_PRESENT      ),
      .PF5_BAR5_PRESENT      (PF5_BAR5_PRESENT      ),
      .PF6_BAR5_PRESENT      (PF6_BAR5_PRESENT      ),
      .PF7_BAR5_PRESENT      (PF7_BAR5_PRESENT      ),
      .PF0_EXPROM_BAR_PRESENT(PF0_EXPROM_BAR_PRESENT),
      .PF1_EXPROM_BAR_PRESENT(PF1_EXPROM_BAR_PRESENT),
      .PF2_EXPROM_BAR_PRESENT(PF2_EXPROM_BAR_PRESENT),
      .PF3_EXPROM_BAR_PRESENT(PF3_EXPROM_BAR_PRESENT),
      .PF4_EXPROM_BAR_PRESENT(PF4_EXPROM_BAR_PRESENT),
      .PF5_EXPROM_BAR_PRESENT(PF5_EXPROM_BAR_PRESENT),
      .PF6_EXPROM_BAR_PRESENT(PF6_EXPROM_BAR_PRESENT),
      .PF7_EXPROM_BAR_PRESENT(PF7_EXPROM_BAR_PRESENT),
      .PF0_BAR0_TYPE         (PF0_BAR0_TYPE         ),
      .PF1_BAR0_TYPE         (PF1_BAR0_TYPE         ),
      .PF2_BAR0_TYPE         (PF2_BAR0_TYPE         ),
      .PF3_BAR0_TYPE         (PF3_BAR0_TYPE         ),
      .PF4_BAR0_TYPE         (PF4_BAR0_TYPE         ),
      .PF5_BAR0_TYPE         (PF5_BAR0_TYPE         ),
      .PF6_BAR0_TYPE         (PF6_BAR0_TYPE         ),
      .PF7_BAR0_TYPE         (PF7_BAR0_TYPE         ),
      .PF0_BAR2_TYPE         (PF0_BAR2_TYPE         ),
      .PF1_BAR2_TYPE         (PF1_BAR2_TYPE         ),
      .PF2_BAR2_TYPE         (PF2_BAR2_TYPE         ),
      .PF3_BAR2_TYPE         (PF3_BAR2_TYPE         ),
      .PF4_BAR2_TYPE         (PF4_BAR2_TYPE         ),
      .PF5_BAR2_TYPE         (PF5_BAR2_TYPE         ),
      .PF6_BAR2_TYPE         (PF6_BAR2_TYPE         ),
      .PF7_BAR2_TYPE         (PF7_BAR2_TYPE         ),
      .PF0_BAR4_TYPE         (PF0_BAR4_TYPE         ),
      .PF1_BAR4_TYPE         (PF1_BAR4_TYPE         ),
      .PF2_BAR4_TYPE         (PF2_BAR4_TYPE         ),
      .PF3_BAR4_TYPE         (PF3_BAR4_TYPE         ),
      .PF4_BAR4_TYPE         (PF4_BAR4_TYPE         ),
      .PF5_BAR4_TYPE         (PF5_BAR4_TYPE         ),
      .PF6_BAR4_TYPE         (PF6_BAR4_TYPE         ),
      .PF7_BAR4_TYPE         (PF7_BAR4_TYPE         ),
      .PF0_BAR0_PREFETCHABLE (PF0_BAR0_PREFETCHABLE ),
      .PF1_BAR0_PREFETCHABLE (PF1_BAR0_PREFETCHABLE ),
      .PF2_BAR0_PREFETCHABLE (PF2_BAR0_PREFETCHABLE ),
      .PF3_BAR0_PREFETCHABLE (PF3_BAR0_PREFETCHABLE ),
      .PF4_BAR0_PREFETCHABLE (PF4_BAR0_PREFETCHABLE ),
      .PF5_BAR0_PREFETCHABLE (PF5_BAR0_PREFETCHABLE ),
      .PF6_BAR0_PREFETCHABLE (PF6_BAR0_PREFETCHABLE ),
      .PF7_BAR0_PREFETCHABLE (PF7_BAR0_PREFETCHABLE ),
      .PF0_BAR1_PREFETCHABLE (PF0_BAR1_PREFETCHABLE ),
      .PF1_BAR1_PREFETCHABLE (PF1_BAR1_PREFETCHABLE ),
      .PF2_BAR1_PREFETCHABLE (PF2_BAR1_PREFETCHABLE ),
      .PF3_BAR1_PREFETCHABLE (PF3_BAR1_PREFETCHABLE ),
      .PF4_BAR1_PREFETCHABLE (PF4_BAR1_PREFETCHABLE ),
      .PF5_BAR1_PREFETCHABLE (PF5_BAR1_PREFETCHABLE ),
      .PF6_BAR1_PREFETCHABLE (PF6_BAR1_PREFETCHABLE ),
      .PF7_BAR1_PREFETCHABLE (PF7_BAR1_PREFETCHABLE ),
      .PF0_BAR2_PREFETCHABLE (PF0_BAR2_PREFETCHABLE ),
      .PF1_BAR2_PREFETCHABLE (PF1_BAR2_PREFETCHABLE ),
      .PF2_BAR2_PREFETCHABLE (PF2_BAR2_PREFETCHABLE ),
      .PF3_BAR2_PREFETCHABLE (PF3_BAR2_PREFETCHABLE ),
      .PF4_BAR2_PREFETCHABLE (PF4_BAR2_PREFETCHABLE ),
      .PF5_BAR2_PREFETCHABLE (PF5_BAR2_PREFETCHABLE ),
      .PF6_BAR2_PREFETCHABLE (PF6_BAR2_PREFETCHABLE ),
      .PF7_BAR2_PREFETCHABLE (PF7_BAR2_PREFETCHABLE ),
      .PF0_BAR3_PREFETCHABLE (PF0_BAR3_PREFETCHABLE ),
      .PF1_BAR3_PREFETCHABLE (PF1_BAR3_PREFETCHABLE ),
      .PF2_BAR3_PREFETCHABLE (PF2_BAR3_PREFETCHABLE ),
      .PF3_BAR3_PREFETCHABLE (PF3_BAR3_PREFETCHABLE ),
      .PF4_BAR3_PREFETCHABLE (PF4_BAR3_PREFETCHABLE ),
      .PF5_BAR3_PREFETCHABLE (PF5_BAR3_PREFETCHABLE ),
      .PF6_BAR3_PREFETCHABLE (PF6_BAR3_PREFETCHABLE ),
      .PF7_BAR3_PREFETCHABLE (PF7_BAR3_PREFETCHABLE ),
      .PF0_BAR4_PREFETCHABLE (PF0_BAR4_PREFETCHABLE ),
      .PF1_BAR4_PREFETCHABLE (PF1_BAR4_PREFETCHABLE ),
      .PF2_BAR4_PREFETCHABLE (PF2_BAR4_PREFETCHABLE ),
      .PF3_BAR4_PREFETCHABLE (PF3_BAR4_PREFETCHABLE ),
      .PF4_BAR4_PREFETCHABLE (PF4_BAR4_PREFETCHABLE ),
      .PF5_BAR4_PREFETCHABLE (PF5_BAR4_PREFETCHABLE ),
      .PF6_BAR4_PREFETCHABLE (PF6_BAR4_PREFETCHABLE ),
      .PF7_BAR4_PREFETCHABLE (PF7_BAR4_PREFETCHABLE ),
      .PF0_BAR5_PREFETCHABLE (PF0_BAR5_PREFETCHABLE ),
      .PF1_BAR5_PREFETCHABLE (PF1_BAR5_PREFETCHABLE ),
      .PF2_BAR5_PREFETCHABLE (PF2_BAR5_PREFETCHABLE ),
      .PF3_BAR5_PREFETCHABLE (PF3_BAR5_PREFETCHABLE ),
      .PF4_BAR5_PREFETCHABLE (PF4_BAR5_PREFETCHABLE ),
      .PF5_BAR5_PREFETCHABLE (PF5_BAR5_PREFETCHABLE ),
      .PF6_BAR5_PREFETCHABLE (PF6_BAR5_PREFETCHABLE ),
      .PF7_BAR5_PREFETCHABLE (PF7_BAR5_PREFETCHABLE ),
      .PF0_BAR0_SIZE         (PF0_BAR0_SIZE         ),
      .PF1_BAR0_SIZE         (PF1_BAR0_SIZE         ),
      .PF2_BAR0_SIZE         (PF2_BAR0_SIZE         ),
      .PF3_BAR0_SIZE         (PF3_BAR0_SIZE         ),
      .PF4_BAR0_SIZE         (PF4_BAR0_SIZE         ),
      .PF5_BAR0_SIZE         (PF5_BAR0_SIZE         ),
      .PF6_BAR0_SIZE         (PF6_BAR0_SIZE         ),
      .PF7_BAR0_SIZE         (PF7_BAR0_SIZE         ),
      .PF0_BAR1_SIZE         (PF0_BAR1_SIZE         ),
      .PF1_BAR1_SIZE         (PF1_BAR1_SIZE         ),
      .PF2_BAR1_SIZE         (PF2_BAR1_SIZE         ),
      .PF3_BAR1_SIZE         (PF3_BAR1_SIZE         ),
      .PF4_BAR1_SIZE         (PF4_BAR1_SIZE         ),
      .PF5_BAR1_SIZE         (PF5_BAR1_SIZE         ),
      .PF6_BAR1_SIZE         (PF6_BAR1_SIZE         ),
      .PF7_BAR1_SIZE         (PF7_BAR1_SIZE         ),
      .PF0_BAR2_SIZE         (PF0_BAR2_SIZE         ),
      .PF1_BAR2_SIZE         (PF1_BAR2_SIZE         ),
      .PF2_BAR2_SIZE         (PF2_BAR2_SIZE         ),
      .PF3_BAR2_SIZE         (PF3_BAR2_SIZE         ),
      .PF4_BAR2_SIZE         (PF4_BAR2_SIZE         ),
      .PF5_BAR2_SIZE         (PF5_BAR2_SIZE         ),
      .PF6_BAR2_SIZE         (PF6_BAR2_SIZE         ),
      .PF7_BAR2_SIZE         (PF7_BAR2_SIZE         ),
      .PF0_BAR3_SIZE         (PF0_BAR3_SIZE         ),
      .PF1_BAR3_SIZE         (PF1_BAR3_SIZE         ),
      .PF2_BAR3_SIZE         (PF2_BAR3_SIZE         ),
      .PF3_BAR3_SIZE         (PF3_BAR3_SIZE         ),
      .PF4_BAR3_SIZE         (PF4_BAR3_SIZE         ),
      .PF5_BAR3_SIZE         (PF5_BAR3_SIZE         ),
      .PF6_BAR3_SIZE         (PF6_BAR3_SIZE         ),
      .PF7_BAR3_SIZE         (PF7_BAR3_SIZE         ),
      .PF0_BAR4_SIZE         (PF0_BAR4_SIZE         ),
      .PF1_BAR4_SIZE         (PF1_BAR4_SIZE         ),
      .PF2_BAR4_SIZE         (PF2_BAR4_SIZE         ),
      .PF3_BAR4_SIZE         (PF3_BAR4_SIZE         ),
      .PF4_BAR4_SIZE         (PF4_BAR4_SIZE         ),
      .PF5_BAR4_SIZE         (PF5_BAR4_SIZE         ),
      .PF6_BAR4_SIZE         (PF6_BAR4_SIZE         ),
      .PF7_BAR4_SIZE         (PF7_BAR4_SIZE         ),
      .PF0_BAR5_SIZE         (PF0_BAR5_SIZE         ),
      .PF1_BAR5_SIZE         (PF1_BAR5_SIZE         ),
      .PF2_BAR5_SIZE         (PF2_BAR5_SIZE         ),
      .PF3_BAR5_SIZE         (PF3_BAR5_SIZE         ),
      .PF4_BAR5_SIZE         (PF4_BAR5_SIZE         ),
      .PF5_BAR5_SIZE         (PF5_BAR5_SIZE         ),
      .PF6_BAR5_SIZE         (PF6_BAR5_SIZE         ),
      .PF7_BAR5_SIZE         (PF7_BAR5_SIZE         ),
     // VF BAR parameters
       .PF0_VF_BAR0_PRESENT                 (PF0_VF_BAR0_PRESENT),
       .PF1_VF_BAR0_PRESENT                 (PF1_VF_BAR0_PRESENT),
       .PF2_VF_BAR0_PRESENT                 (PF2_VF_BAR0_PRESENT),
       .PF3_VF_BAR0_PRESENT                 (PF3_VF_BAR0_PRESENT),
       .PF0_VF_BAR1_PRESENT                 (PF0_VF_BAR1_PRESENT),
       .PF1_VF_BAR1_PRESENT                 (PF1_VF_BAR1_PRESENT),
       .PF2_VF_BAR1_PRESENT                 (PF2_VF_BAR1_PRESENT),
       .PF3_VF_BAR1_PRESENT                 (PF3_VF_BAR1_PRESENT),
       .PF0_VF_BAR2_PRESENT                 (PF0_VF_BAR2_PRESENT),
       .PF1_VF_BAR2_PRESENT                 (PF1_VF_BAR2_PRESENT),
       .PF2_VF_BAR2_PRESENT                 (PF2_VF_BAR2_PRESENT),
       .PF3_VF_BAR2_PRESENT                 (PF3_VF_BAR2_PRESENT),
       .PF0_VF_BAR3_PRESENT                 (PF0_VF_BAR3_PRESENT),
       .PF1_VF_BAR3_PRESENT                 (PF1_VF_BAR3_PRESENT),
       .PF2_VF_BAR3_PRESENT                 (PF2_VF_BAR3_PRESENT),
       .PF3_VF_BAR3_PRESENT                 (PF3_VF_BAR3_PRESENT),
       .PF0_VF_BAR4_PRESENT                 (PF0_VF_BAR4_PRESENT),
       .PF1_VF_BAR4_PRESENT                 (PF1_VF_BAR4_PRESENT),
       .PF2_VF_BAR4_PRESENT                 (PF2_VF_BAR4_PRESENT),
       .PF3_VF_BAR4_PRESENT                 (PF3_VF_BAR4_PRESENT),
       .PF0_VF_BAR5_PRESENT                 (PF0_VF_BAR5_PRESENT),
       .PF1_VF_BAR5_PRESENT                 (PF1_VF_BAR5_PRESENT),
       .PF2_VF_BAR5_PRESENT                 (PF2_VF_BAR5_PRESENT),
       .PF3_VF_BAR5_PRESENT                 (PF3_VF_BAR5_PRESENT),
       .PF0_VF_BAR0_TYPE                    (PF0_VF_BAR0_TYPE),
       .PF1_VF_BAR0_TYPE                    (PF1_VF_BAR0_TYPE),
       .PF2_VF_BAR0_TYPE                    (PF2_VF_BAR0_TYPE),
       .PF3_VF_BAR0_TYPE                    (PF3_VF_BAR0_TYPE),
       .PF0_VF_BAR2_TYPE                    (PF0_VF_BAR2_TYPE),
       .PF1_VF_BAR2_TYPE                    (PF1_VF_BAR2_TYPE),
       .PF2_VF_BAR2_TYPE                    (PF2_VF_BAR2_TYPE),
       .PF3_VF_BAR2_TYPE                    (PF3_VF_BAR2_TYPE),
       .PF0_VF_BAR4_TYPE                    (PF0_VF_BAR4_TYPE),
       .PF1_VF_BAR4_TYPE                    (PF1_VF_BAR4_TYPE),
       .PF2_VF_BAR4_TYPE                    (PF2_VF_BAR4_TYPE),
       .PF3_VF_BAR4_TYPE                    (PF3_VF_BAR4_TYPE),
       .PF0_VF_BAR0_PREFETCHABLE            (PF0_VF_BAR0_PREFETCHABLE),
       .PF1_VF_BAR0_PREFETCHABLE            (PF1_VF_BAR0_PREFETCHABLE),
       .PF2_VF_BAR0_PREFETCHABLE            (PF2_VF_BAR0_PREFETCHABLE),
       .PF3_VF_BAR0_PREFETCHABLE            (PF3_VF_BAR0_PREFETCHABLE),
       .PF0_VF_BAR1_PREFETCHABLE            (PF0_VF_BAR1_PREFETCHABLE),
       .PF1_VF_BAR1_PREFETCHABLE            (PF1_VF_BAR1_PREFETCHABLE),
       .PF2_VF_BAR1_PREFETCHABLE            (PF2_VF_BAR1_PREFETCHABLE),
       .PF3_VF_BAR1_PREFETCHABLE            (PF3_VF_BAR1_PREFETCHABLE),
       .PF0_VF_BAR2_PREFETCHABLE            (PF0_VF_BAR2_PREFETCHABLE),
       .PF1_VF_BAR2_PREFETCHABLE            (PF1_VF_BAR2_PREFETCHABLE),
       .PF2_VF_BAR2_PREFETCHABLE            (PF2_VF_BAR2_PREFETCHABLE),
       .PF3_VF_BAR2_PREFETCHABLE            (PF3_VF_BAR2_PREFETCHABLE),
       .PF0_VF_BAR3_PREFETCHABLE            (PF0_VF_BAR3_PREFETCHABLE),
       .PF1_VF_BAR3_PREFETCHABLE            (PF1_VF_BAR3_PREFETCHABLE),
       .PF2_VF_BAR3_PREFETCHABLE            (PF2_VF_BAR3_PREFETCHABLE),
       .PF3_VF_BAR3_PREFETCHABLE            (PF3_VF_BAR3_PREFETCHABLE),
       .PF0_VF_BAR4_PREFETCHABLE            (PF0_VF_BAR4_PREFETCHABLE),
       .PF1_VF_BAR4_PREFETCHABLE            (PF1_VF_BAR4_PREFETCHABLE),
       .PF2_VF_BAR4_PREFETCHABLE            (PF2_VF_BAR4_PREFETCHABLE),
       .PF3_VF_BAR4_PREFETCHABLE            (PF3_VF_BAR4_PREFETCHABLE),
       .PF0_VF_BAR5_PREFETCHABLE            (PF0_VF_BAR5_PREFETCHABLE),
       .PF1_VF_BAR5_PREFETCHABLE            (PF1_VF_BAR5_PREFETCHABLE),
       .PF2_VF_BAR5_PREFETCHABLE            (PF2_VF_BAR5_PREFETCHABLE),
       .PF3_VF_BAR5_PREFETCHABLE            (PF3_VF_BAR5_PREFETCHABLE),
       .PF0_VF_BAR0_SIZE                    (PF0_VF_BAR0_SIZE),
       .PF1_VF_BAR0_SIZE                    (PF1_VF_BAR0_SIZE),
       .PF2_VF_BAR0_SIZE                    (PF2_VF_BAR0_SIZE),
       .PF3_VF_BAR0_SIZE                    (PF3_VF_BAR0_SIZE),
       .PF0_VF_BAR1_SIZE                    (PF0_VF_BAR1_SIZE),
       .PF1_VF_BAR1_SIZE                    (PF1_VF_BAR1_SIZE),
       .PF2_VF_BAR1_SIZE                    (PF2_VF_BAR1_SIZE),
       .PF3_VF_BAR1_SIZE                    (PF3_VF_BAR1_SIZE),
       .PF0_VF_BAR2_SIZE                    (PF0_VF_BAR2_SIZE),
       .PF1_VF_BAR2_SIZE                    (PF1_VF_BAR2_SIZE),
       .PF2_VF_BAR2_SIZE                    (PF2_VF_BAR2_SIZE),
       .PF3_VF_BAR2_SIZE                    (PF3_VF_BAR2_SIZE),
       .PF0_VF_BAR3_SIZE                    (PF0_VF_BAR3_SIZE),
       .PF1_VF_BAR3_SIZE                    (PF1_VF_BAR3_SIZE),
       .PF2_VF_BAR3_SIZE                    (PF2_VF_BAR3_SIZE),
       .PF3_VF_BAR3_SIZE                    (PF3_VF_BAR3_SIZE),
       .PF0_VF_BAR4_SIZE                    (PF0_VF_BAR4_SIZE),
       .PF1_VF_BAR4_SIZE                    (PF1_VF_BAR4_SIZE),
       .PF2_VF_BAR4_SIZE                    (PF2_VF_BAR4_SIZE),
       .PF3_VF_BAR4_SIZE                    (PF3_VF_BAR4_SIZE),
       .PF0_VF_BAR5_SIZE                    (PF0_VF_BAR5_SIZE),
       .PF1_VF_BAR5_SIZE                    (PF1_VF_BAR5_SIZE),
       .PF2_VF_BAR5_SIZE                    (PF2_VF_BAR5_SIZE),
       .PF3_VF_BAR5_SIZE                    (PF3_VF_BAR5_SIZE),
     // TPH parameters of Physical Functions
       .PF_TPH_SUPPORT                      (PF_TPH_SUPPORT),
       .PF0_TPH_INT_MODE_SUPPORT            (PF0_TPH_INT_MODE_SUPPORT),
       .PF1_TPH_INT_MODE_SUPPORT            (PF1_TPH_INT_MODE_SUPPORT),
       .PF2_TPH_INT_MODE_SUPPORT            (PF2_TPH_INT_MODE_SUPPORT),
       .PF3_TPH_INT_MODE_SUPPORT            (PF3_TPH_INT_MODE_SUPPORT),
       .PF0_TPH_DEV_SPECIFIC_MODE_SUPPORT   (PF0_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF1_TPH_DEV_SPECIFIC_MODE_SUPPORT   (PF1_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF2_TPH_DEV_SPECIFIC_MODE_SUPPORT   (PF2_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF3_TPH_DEV_SPECIFIC_MODE_SUPPORT   (PF3_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF0_TPH_ST_TABLE_LOCATION           (PF0_TPH_ST_TABLE_LOCATION),
       .PF1_TPH_ST_TABLE_LOCATION           (PF1_TPH_ST_TABLE_LOCATION),
       .PF2_TPH_ST_TABLE_LOCATION           (PF2_TPH_ST_TABLE_LOCATION),
       .PF3_TPH_ST_TABLE_LOCATION           (PF3_TPH_ST_TABLE_LOCATION),
       .PF0_TPH_ST_TABLE_SIZE               (PF0_TPH_ST_TABLE_SIZE),
       .PF1_TPH_ST_TABLE_SIZE               (PF1_TPH_ST_TABLE_SIZE),
       .PF2_TPH_ST_TABLE_SIZE               (PF2_TPH_ST_TABLE_SIZE),
       .PF3_TPH_ST_TABLE_SIZE               (PF3_TPH_ST_TABLE_SIZE),
     // TPH parameters of Virtual Functions
       .VF_TPH_SUPPORT                      (VF_TPH_SUPPORT),
       .PF0_VF_TPH_INT_MODE_SUPPORT         (PF0_VF_TPH_INT_MODE_SUPPORT),
       .PF1_VF_TPH_INT_MODE_SUPPORT         (PF1_VF_TPH_INT_MODE_SUPPORT),
       .PF2_VF_TPH_INT_MODE_SUPPORT         (PF2_VF_TPH_INT_MODE_SUPPORT),
       .PF3_VF_TPH_INT_MODE_SUPPORT         (PF3_VF_TPH_INT_MODE_SUPPORT),
       .PF0_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT(PF0_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF1_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT(PF1_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF2_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT(PF2_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF3_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT(PF3_VF_TPH_DEV_SPECIFIC_MODE_SUPPORT),
       .PF0_VF_TPH_ST_TABLE_LOCATION        (PF0_VF_TPH_ST_TABLE_LOCATION),
       .PF1_VF_TPH_ST_TABLE_LOCATION        (PF1_VF_TPH_ST_TABLE_LOCATION),
       .PF2_VF_TPH_ST_TABLE_LOCATION        (PF2_VF_TPH_ST_TABLE_LOCATION),
       .PF3_VF_TPH_ST_TABLE_LOCATION        (PF3_VF_TPH_ST_TABLE_LOCATION),
       .PF0_VF_TPH_ST_TABLE_SIZE            (PF0_VF_TPH_ST_TABLE_SIZE),
       .PF1_VF_TPH_ST_TABLE_SIZE            (PF1_VF_TPH_ST_TABLE_SIZE),
       .PF2_VF_TPH_ST_TABLE_SIZE            (PF2_VF_TPH_ST_TABLE_SIZE),
       .PF3_VF_TPH_ST_TABLE_SIZE            (PF3_VF_TPH_ST_TABLE_SIZE),
      // ATS parameters of Physical Functions
       .PF_ATS_SUPPORT                      (PF_ATS_SUPPORT),
       .PF0_ATS_INVALIDATE_QUEUE_DEPTH      (PF0_ATS_INVALIDATE_QUEUE_DEPTH),
       .PF1_ATS_INVALIDATE_QUEUE_DEPTH      (PF1_ATS_INVALIDATE_QUEUE_DEPTH),
       .PF2_ATS_INVALIDATE_QUEUE_DEPTH      (PF2_ATS_INVALIDATE_QUEUE_DEPTH),
       .PF3_ATS_INVALIDATE_QUEUE_DEPTH      (PF3_ATS_INVALIDATE_QUEUE_DEPTH),
      // ATS parameters of Virtual Functions
       .VF_ATS_SUPPORT                      (VF_ATS_SUPPORT),
      // VirtIO Specific Parameters PF0
      .PF0_VIRTIO_CAPABILITY_PRESENT                 (PF0_VIRTIO_CAPABILITY_PRESENT                ),
      .PF0_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF0_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF0_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF0_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF0_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF0_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF0_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF0_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF0_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF0_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF0_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF0_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF0_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF0_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF0_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF0_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF0_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF0_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF0_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF0_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF0_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF0_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF0_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF0_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF0_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF0_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF0_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF0_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF0_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF0_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF0_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF0_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),          
      .PF0_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF0_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF1
      .PF1_VIRTIO_CAPABILITY_PRESENT                 (PF1_VIRTIO_CAPABILITY_PRESENT                ),
      .PF1_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF1_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF1_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF1_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF1_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF1_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF1_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF1_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF1_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF1_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF1_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF1_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF1_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF1_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF1_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF1_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF1_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF1_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF1_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF1_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF1_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF1_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF1_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF1_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF1_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF1_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF1_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF1_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF1_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF1_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF1_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF1_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),
      .PF1_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF1_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF2
      .PF2_VIRTIO_CAPABILITY_PRESENT                 (PF2_VIRTIO_CAPABILITY_PRESENT                ),
      .PF2_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF2_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF2_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF2_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF2_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF2_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF2_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF2_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF2_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF2_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF2_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF2_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF2_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF2_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF2_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF2_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF2_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF2_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF2_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF2_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF2_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF2_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF2_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF2_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF2_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF2_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF2_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF2_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF2_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF2_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF2_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF2_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),
      .PF2_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF2_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF3
      .PF3_VIRTIO_CAPABILITY_PRESENT                 (PF3_VIRTIO_CAPABILITY_PRESENT                ),
      .PF3_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF3_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF3_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF3_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF3_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF3_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF3_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF3_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF3_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF3_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF3_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF3_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF3_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF3_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF3_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF3_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF3_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF3_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF3_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF3_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF3_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF3_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF3_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF3_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF3_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF3_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF3_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF3_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF3_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF3_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF3_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF3_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),
      .PF3_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF3_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF4
      .PF4_VIRTIO_CAPABILITY_PRESENT                 (PF4_VIRTIO_CAPABILITY_PRESENT                ),
      .PF4_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF4_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF4_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF4_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF4_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF4_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF4_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF4_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF4_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF4_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF4_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF4_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF4_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF4_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF4_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF4_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF4_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF4_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF4_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF4_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF4_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF4_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF4_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF4_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF4_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF4_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF4_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF4_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF4_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF4_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF4_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF4_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),    
      .PF4_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF4_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF5
      .PF5_VIRTIO_CAPABILITY_PRESENT                 (PF5_VIRTIO_CAPABILITY_PRESENT                ),
      .PF5_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF5_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF5_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF5_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF5_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF5_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF5_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF5_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF5_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF5_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF5_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF5_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF5_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF5_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF5_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF5_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF5_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF5_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF5_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF5_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF5_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF5_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF5_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF5_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF5_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF5_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF5_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF5_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF5_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF5_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF5_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF5_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),    
      .PF5_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF5_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF6
      .PF6_VIRTIO_CAPABILITY_PRESENT                 (PF6_VIRTIO_CAPABILITY_PRESENT                ),
      .PF6_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF6_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF6_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF6_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF6_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF6_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF6_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF6_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF6_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF6_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF6_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF6_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF6_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF6_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF6_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF6_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF6_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF6_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF6_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF6_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF6_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF6_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF6_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF6_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF6_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF6_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF6_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF6_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF6_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF6_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF6_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF6_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),    
      .PF6_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF6_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF7
      .PF7_VIRTIO_CAPABILITY_PRESENT                 (PF7_VIRTIO_CAPABILITY_PRESENT                ),
      .PF7_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT        (PF7_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF7_VIRTIO_CMN_CONFIG_BAR_INDICATOR           (PF7_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF7_VIRTIO_NOTIFICATION_BAR_INDICATOR         (PF7_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF7_VIRTIO_ISRSTATUS_BAR_INDICATOR            (PF7_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF7_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR     (PF7_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF7_VIRTIO_DEVSPECIFIC_BAR_INDICATOR          (PF7_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF7_VIRTIO_CMN_CONFIG_BAR_OFFSET              (PF7_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF7_VIRTIO_NOTIFICATION_BAR_OFFSET            (PF7_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF7_VIRTIO_ISRSTATUS_BAR_OFFSET               (PF7_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF7_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET        (PF7_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF7_VIRTIO_DEVSPECIFIC_BAR_OFFSET             (PF7_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF7_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH        (PF7_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF7_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH      (PF7_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF7_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH         (PF7_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF7_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH  (PF7_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF7_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH       (PF7_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),       
      .PF7_VIRTIO_NOTIFY_OFF_MULTIPLIER              (PF7_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF0 VFs
      .PF0VF_VIRTIO_CAPABILITY_PRESENT                     (PF0VF_VIRTIO_CAPABILITY_PRESENT                ),
      .PF0VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT            (PF0VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF0VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR               (PF0VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF0VF_VIRTIO_NOTIFICATION_BAR_INDICATOR             (PF0VF_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF0VF_VIRTIO_ISRSTATUS_BAR_INDICATOR                (PF0VF_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF0VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR         (PF0VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF0VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR              (PF0VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF0VF_VIRTIO_CMN_CONFIG_BAR_OFFSET                  (PF0VF_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF0VF_VIRTIO_NOTIFICATION_BAR_OFFSET                (PF0VF_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF0VF_VIRTIO_ISRSTATUS_BAR_OFFSET                   (PF0VF_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF0VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET            (PF0VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF0VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET                 (PF0VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF0VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH            (PF0VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF0VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH          (PF0VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF0VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH             (PF0VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF0VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH      (PF0VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF0VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH           (PF0VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),
      .PF0VF_VIRTIO_NOTIFY_OFF_MULTIPLIER                  (PF0VF_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF1 VFs
      .PF1VF_VIRTIO_CAPABILITY_PRESENT                     (PF1VF_VIRTIO_CAPABILITY_PRESENT                ),
      .PF1VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT            (PF1VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF1VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR               (PF1VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF1VF_VIRTIO_NOTIFICATION_BAR_INDICATOR             (PF1VF_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF1VF_VIRTIO_ISRSTATUS_BAR_INDICATOR                (PF1VF_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF1VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR         (PF1VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF1VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR              (PF1VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF1VF_VIRTIO_CMN_CONFIG_BAR_OFFSET                  (PF1VF_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF1VF_VIRTIO_NOTIFICATION_BAR_OFFSET                (PF1VF_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF1VF_VIRTIO_ISRSTATUS_BAR_OFFSET                   (PF1VF_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF1VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET            (PF1VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF1VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET                 (PF1VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF1VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH            (PF1VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF1VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH          (PF1VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF1VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH             (PF1VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF1VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH      (PF1VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF1VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH           (PF1VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),
      .PF1VF_VIRTIO_NOTIFY_OFF_MULTIPLIER                  (PF1VF_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF2 VFs
      .PF2VF_VIRTIO_CAPABILITY_PRESENT                     (PF2VF_VIRTIO_CAPABILITY_PRESENT                ),
      .PF2VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT            (PF2VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF2VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR               (PF2VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF2VF_VIRTIO_NOTIFICATION_BAR_INDICATOR             (PF2VF_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF2VF_VIRTIO_ISRSTATUS_BAR_INDICATOR                (PF2VF_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF2VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR         (PF2VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF2VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR              (PF2VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF2VF_VIRTIO_CMN_CONFIG_BAR_OFFSET                  (PF2VF_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF2VF_VIRTIO_NOTIFICATION_BAR_OFFSET                (PF2VF_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF2VF_VIRTIO_ISRSTATUS_BAR_OFFSET                   (PF2VF_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF2VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET            (PF2VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF2VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET                 (PF2VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF2VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH            (PF2VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF2VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH          (PF2VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF2VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH             (PF2VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF2VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH      (PF2VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF2VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH           (PF2VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),
      .PF2VF_VIRTIO_NOTIFY_OFF_MULTIPLIER                  (PF2VF_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // VirtIO Specific Parameters PF3 VFs
      .PF3VF_VIRTIO_CAPABILITY_PRESENT                     (PF3VF_VIRTIO_CAPABILITY_PRESENT                ),
      .PF3VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT            (PF3VF_VIRTIO_DEVICE_SPECIFIC_CAP_PRESENT       ),
      .PF3VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR               (PF3VF_VIRTIO_CMN_CONFIG_BAR_INDICATOR          ),
      .PF3VF_VIRTIO_NOTIFICATION_BAR_INDICATOR             (PF3VF_VIRTIO_NOTIFICATION_BAR_INDICATOR        ),
      .PF3VF_VIRTIO_ISRSTATUS_BAR_INDICATOR                (PF3VF_VIRTIO_ISRSTATUS_BAR_INDICATOR           ),
      .PF3VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR         (PF3VF_VIRTIO_PCICONFIG_ACCESS_BAR_INDICATOR    ),
      .PF3VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR              (PF3VF_VIRTIO_DEVSPECIFIC_BAR_INDICATOR         ),
      .PF3VF_VIRTIO_CMN_CONFIG_BAR_OFFSET                  (PF3VF_VIRTIO_CMN_CONFIG_BAR_OFFSET             ),
      .PF3VF_VIRTIO_NOTIFICATION_BAR_OFFSET                (PF3VF_VIRTIO_NOTIFICATION_BAR_OFFSET           ),
      .PF3VF_VIRTIO_ISRSTATUS_BAR_OFFSET                   (PF3VF_VIRTIO_ISRSTATUS_BAR_OFFSET              ),
      .PF3VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET            (PF3VF_VIRTIO_PCICONFIG_ACCESS_BAR_OFFSET       ),
      .PF3VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET                 (PF3VF_VIRTIO_DEVSPECIFIC_BAR_OFFSET            ),
      .PF3VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH            (PF3VF_VIRTIO_CMN_CONFIG_STRUCTURE_LENGTH       ),
      .PF3VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH          (PF3VF_VIRTIO_NOTIFICATION_STRUCTURE_LENGTH     ),
      .PF3VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH             (PF3VF_VIRTIO_ISRSTATUS_STRUCTURE_LENGTH        ),
      .PF3VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH      (PF3VF_VIRTIO_PCICONFIG_ACCESS_STRUCTURE_LENGTH ),
      .PF3VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH           (PF3VF_VIRTIO_DEVSPECIFIC_STRUCTURE_LENGTH      ),
      .PF3VF_VIRTIO_NOTIFY_OFF_MULTIPLIER                  (PF3VF_VIRTIO_NOTIFY_OFF_MULTIPLIER             ),
   // Customer-Specific Parameters
      .PF0_EXTRA_BAR_PRESENT               (PF0_EXTRA_BAR_PRESENT),
      .DEVHIDE_SUPPORT                     (DEVHIDE_SUPPORT),
      .DEVICE_EMBEDDED_EP_SUPPORT          (DEVICE_EMBEDDED_EP_SUPPORT)
    )
       altpcie_pcie_sriov2_top_inst 
         (
          .Clk_i                            (pld_clk),
          .Rstn_i                           (app_rstn),
          .PowerOnRstn_i                    (power_on_reset_n),

          // PF 0 BAR apertures
          .f0_bar0_aperture_i               (f0_bar0_aperture),
          .f0_bar1_aperture_i               (f0_bar1_aperture),
          .f0_bar2_aperture_i               (f0_bar2_aperture),
          .f0_bar3_aperture_i               (f0_bar3_aperture),
          .f0_bar4_aperture_i               (f0_bar4_aperture),
          .f0_bar5_aperture_i               (f0_bar5_aperture),
          .f0_exprom_bar_aperture_i         (f0_exprom_bar_aperture),

          .f0_vf_bar0_aperture_i            (f0_vf_bar0_aperture),
          .f0_vf_bar1_aperture_i            (f0_vf_bar1_aperture),
          .f0_vf_bar2_aperture_i            (f0_vf_bar2_aperture),
          .f0_vf_bar3_aperture_i            (f0_vf_bar3_aperture),
          .f0_vf_bar4_aperture_i            (f0_vf_bar4_aperture),
          .f0_vf_bar5_aperture_i            (f0_vf_bar5_aperture),

          .f0_vf_bar0_aperture_bitmask_i    (f0_vf_bar0_aperture_bitmask),
          .f0_vf_bar1_aperture_bitmask_i    (f0_vf_bar1_aperture_bitmask),
          .f0_vf_bar2_aperture_bitmask_i    (f0_vf_bar2_aperture_bitmask),
          .f0_vf_bar3_aperture_bitmask_i    (f0_vf_bar3_aperture_bitmask),
          .f0_vf_bar4_aperture_bitmask_i    (f0_vf_bar4_aperture_bitmask),
          .f0_vf_bar5_aperture_bitmask_i    (f0_vf_bar5_aperture_bitmask),

          // PF 1 BAR apertures
          .f1_bar0_aperture_i               (f1_bar0_aperture),
          .f1_bar1_aperture_i               (f1_bar1_aperture),
          .f1_bar2_aperture_i               (f1_bar2_aperture),
          .f1_bar3_aperture_i               (f1_bar3_aperture),
          .f1_bar4_aperture_i               (f1_bar4_aperture),
          .f1_bar5_aperture_i               (f1_bar5_aperture),
          .f1_exprom_bar_aperture_i         (f1_exprom_bar_aperture),
          
          .f1_vf_bar0_aperture_i            (f1_vf_bar0_aperture),
          .f1_vf_bar1_aperture_i            (f1_vf_bar1_aperture),
          .f1_vf_bar2_aperture_i            (f1_vf_bar2_aperture),
          .f1_vf_bar3_aperture_i            (f1_vf_bar3_aperture),
          .f1_vf_bar4_aperture_i            (f1_vf_bar4_aperture),
          .f1_vf_bar5_aperture_i            (f1_vf_bar5_aperture),

          .f1_vf_bar0_aperture_bitmask_i    (f1_vf_bar0_aperture_bitmask),
          .f1_vf_bar1_aperture_bitmask_i    (f1_vf_bar1_aperture_bitmask),
          .f1_vf_bar2_aperture_bitmask_i    (f1_vf_bar2_aperture_bitmask),
          .f1_vf_bar3_aperture_bitmask_i    (f1_vf_bar3_aperture_bitmask),
          .f1_vf_bar4_aperture_bitmask_i    (f1_vf_bar4_aperture_bitmask),
          .f1_vf_bar5_aperture_bitmask_i    (f1_vf_bar5_aperture_bitmask),

          // PF 2 BAR apertures
          .f2_bar0_aperture_i               (f2_bar0_aperture),
          .f2_bar1_aperture_i               (f2_bar1_aperture),
          .f2_bar2_aperture_i               (f2_bar2_aperture),
          .f2_bar3_aperture_i               (f2_bar3_aperture),
          .f2_bar4_aperture_i               (f2_bar4_aperture),
          .f2_bar5_aperture_i               (f2_bar5_aperture),
          .f2_exprom_bar_aperture_i         (f2_exprom_bar_aperture),

          .f2_vf_bar0_aperture_i            (f2_vf_bar0_aperture),
          .f2_vf_bar1_aperture_i            (f2_vf_bar1_aperture),
          .f2_vf_bar2_aperture_i            (f2_vf_bar2_aperture),
          .f2_vf_bar3_aperture_i            (f2_vf_bar3_aperture),
          .f2_vf_bar4_aperture_i            (f2_vf_bar4_aperture),
          .f2_vf_bar5_aperture_i            (f2_vf_bar5_aperture),

          .f2_vf_bar0_aperture_bitmask_i    (f2_vf_bar0_aperture_bitmask),
          .f2_vf_bar1_aperture_bitmask_i    (f2_vf_bar1_aperture_bitmask),
          .f2_vf_bar2_aperture_bitmask_i    (f2_vf_bar2_aperture_bitmask),
          .f2_vf_bar3_aperture_bitmask_i    (f2_vf_bar3_aperture_bitmask),
          .f2_vf_bar4_aperture_bitmask_i    (f2_vf_bar4_aperture_bitmask),
          .f2_vf_bar5_aperture_bitmask_i    (f2_vf_bar5_aperture_bitmask),

          // PF 3 BAR apertures
          .f3_bar0_aperture_i               (f3_bar0_aperture),
          .f3_bar1_aperture_i               (f3_bar1_aperture),
          .f3_bar2_aperture_i               (f3_bar2_aperture),
          .f3_bar3_aperture_i               (f3_bar3_aperture),
          .f3_bar4_aperture_i               (f3_bar4_aperture),
          .f3_bar5_aperture_i               (f3_bar5_aperture),
          .f3_exprom_bar_aperture_i         (f3_exprom_bar_aperture),
 
          .f3_vf_bar0_aperture_i            (f3_vf_bar0_aperture),
          .f3_vf_bar1_aperture_i            (f3_vf_bar1_aperture),
          .f3_vf_bar2_aperture_i            (f3_vf_bar2_aperture),
          .f3_vf_bar3_aperture_i            (f3_vf_bar3_aperture),
          .f3_vf_bar4_aperture_i            (f3_vf_bar4_aperture),
          .f3_vf_bar5_aperture_i            (f3_vf_bar5_aperture),

          .f3_vf_bar0_aperture_bitmask_i    (f3_vf_bar0_aperture_bitmask),
          .f3_vf_bar1_aperture_bitmask_i    (f3_vf_bar1_aperture_bitmask),
          .f3_vf_bar2_aperture_bitmask_i    (f3_vf_bar2_aperture_bitmask),
          .f3_vf_bar3_aperture_bitmask_i    (f3_vf_bar3_aperture_bitmask),
          .f3_vf_bar4_aperture_bitmask_i    (f3_vf_bar4_aperture_bitmask),
          .f3_vf_bar5_aperture_bitmask_i    (f3_vf_bar5_aperture_bitmask),
          .f4_bar0_aperture_i               (f4_bar0_aperture), 
          .f4_bar1_aperture_i               (f4_bar1_aperture),
          .f4_bar2_aperture_i               (f4_bar2_aperture),
          .f4_bar3_aperture_i               (f4_bar3_aperture),
          .f4_bar4_aperture_i               (f4_bar4_aperture),
          .f4_bar5_aperture_i               (f4_bar5_aperture),
          .f4_exprom_bar_aperture_i         (f4_exprom_bar_aperture),      
          .f5_bar0_aperture_i               (f5_bar0_aperture),
          .f5_bar1_aperture_i               (f5_bar1_aperture),
          .f5_bar2_aperture_i               (f5_bar2_aperture),
          .f5_bar3_aperture_i               (f5_bar3_aperture),
          .f5_bar4_aperture_i               (f5_bar4_aperture),
          .f5_bar5_aperture_i               (f5_bar5_aperture),
          .f5_exprom_bar_aperture_i         (f5_exprom_bar_aperture),      
          .f6_bar0_aperture_i               (f6_bar0_aperture),
          .f6_bar1_aperture_i               (f6_bar1_aperture),
          .f6_bar2_aperture_i               (f6_bar2_aperture),
          .f6_bar3_aperture_i               (f6_bar3_aperture),
          .f6_bar4_aperture_i               (f6_bar4_aperture),
          .f6_bar5_aperture_i               (f6_bar5_aperture),
          .f6_exprom_bar_aperture_i         (f6_exprom_bar_aperture),      
          .f7_bar0_aperture_i               (f7_bar0_aperture),
          .f7_bar1_aperture_i               (f7_bar1_aperture),
          .f7_bar2_aperture_i               (f7_bar2_aperture),
          .f7_bar3_aperture_i               (f7_bar3_aperture),
          .f7_bar4_aperture_i               (f7_bar4_aperture),
          .f7_bar5_aperture_i               (f7_bar5_aperture),
          .f7_exprom_bar_aperture_i         (f7_exprom_bar_aperture),
          
          // RX Streaming Interface to HIP 
          .RxStData_hip_i                   (rx_st_data_hip),
          .RxStParity_hip_i                 (rx_st_parity_hip),
          .RxStMask_hip_o                   (rx_st_mask_hip),
          .RxStSop_hip_i                    (rx_st_sop_hip),
          .RxStEop_hip_i                    (rx_st_eop_hip),
          .RxStErr_hip_i                    (rx_st_err_hip),
          .RxStValid_hip_i                  (rx_st_valid_hip),
          .RxStEmpty_hip_i                  (rx_st_empty_hip),
          .RxStReady_hip_o                  (rx_st_ready_hip),
          .RxStBuff_Overflow_i              (rxfc_cplbuf_ovf_hip),
          
          // RX Streaming Interface to app layer
          .RxStData_app_o                   (rx_st_data_app),
          .RxStParity_app_o                 (rx_st_parity_app),
          .RxStSop_app_o                    (rx_st_sop_app),
          .RxStEop_app_o                    (rx_st_eop_app),
          .RxStErr_app_o                    (rx_st_err_app),
          .RxStMask_app_i                   (rx_st_mask_app),
          .RxStValid_app_o                  (rx_st_valid_app),
          .RxStEmpty_app_o                  (rx_st_empty_app),
          .RxStReady_app_i                  (rx_st_ready_app),
          // Function number and BAR identification signals
          .rx_st_bar_range_o                (rx_st_bar_range),
          .rx_st_pf_num_o                   (rx_st_pf_num),
          .rx_st_vf_num_o                   (rx_st_vf_num),
          .rx_st_vf_active_o                (rx_st_vf_active),
          .rx_st_pf_exprom_bar_hit_o        (rx_st_pf_exprom_bar_hit), 
          // TX Streaming Interface to HIP 
          .TxStData_hip_o                   (tx_st_data_hip),
          .TxStParity_hip_o                 (tx_st_parity_hip),
          .TxStSop_hip_o                    (tx_st_sop_hip),
          .TxStEop_hip_o                    (tx_st_eop_hip),
          .TxStErr_hip_o                    (tx_st_err_hip),
          .TxStEmpty_hip_o                  (tx_st_empty_hip),
          .TxStValid_hip_o                  (tx_st_valid_hip),
          .TxStReady_hip_i                  (tx_st_ready_hip),
          .tx_cred_fc_hip_cons_o            (tx_cred_fc_hip_cons_o), 
          
          // TX Streaming Interface to app layer 
          .TxStData_app_i                   (tx_st_data_app),
          .TxStParity_app_i                 (tx_st_parity_app),
          .TxStSop_app_i                    (tx_st_sop_app),
          .TxStEop_app_i                    (tx_st_eop_app),
          .TxStErr_app_i                    (tx_st_err_app),
          .TxStEmpty_app_i                  (tx_st_empty_app),
          .TxStValid_app_i                  (tx_st_valid_app),
          .TxStReady_app_o                  (tx_st_ready_app),
          .tx_st_pf_num_i                   (tx_st_pf_num),
          .tx_st_vf_num_i                   (tx_st_vf_num),
          .tx_st_vf_active_i                (tx_st_vf_active),

          // Interrupt interface
          .int_sts_i                        (app_int_sts),
          .intx_disable_o                   (app_intx_disable),
          .msi_req_i                        (app_msi_req),
          .msi_req_fn_i                     (app_msi_req_fn),
          .msi_num_i                        (app_msi_num),
          .msi_tc_i                         (app_msi_tc),
          .msi_ack_o                        (app_msi_ack),
          .msi_status_o                     (app_msi_status),
          .msix_req_i                       (app_msix_req),
          .msix_ack_o                       (app_msix_ack),
          .msix_err_o                       (app_msix_err),
          .msix_addr_i                      (app_msix_addr),
          .msix_data_i                      (app_msix_data),
          .msix_pf_num_i                    (app_msix_pf_num),
          .msix_vf_num_i                    (app_msix_vf_num),
          .msix_vf_active_i                 (app_msix_vf_active),
          .msix_tc_i                        (app_msix_tc),
          .msi_pending_bit_write_en_i(app_msi_pending_bit_write_en),
          .msi_pending_bit_write_data_i(app_msi_pending_bit_write_data),
          // PF MSI Capability Register Outputs
          .msi_addr_pf_o                    (app_msi_addr_pf),
          .msi_data_pf_o                    (app_msi_data_pf),
          .msi_mask_pf_o                    (app_msi_mask_pf),
          .msi_pending_pf_o                 (app_msi_pending_pf),
          .msi_en_pf_o                      (app_msi_enable_pf),
          .msi_mult_msg_en_pf_o             (app_msi_multi_msg_enable_pf),
          // MSIX Capability Register Outputs
          .msix_en_pf_o                     (app_msix_en_pf),
          .msix_fn_mask_pf_o                (app_msix_fn_mask_pf),

          // Configuration Status Interface of PFs
          .bus_num_f0_o                    (bus_num_f0),
          .device_num_f0_o                 (device_num_f0),
          .bus_num_f1_o                    (bus_num_f1),
          .device_num_f1_o                 (device_num_f1),
          .bus_num_f2_o                    (bus_num_f2),
          .device_num_f2_o                 (device_num_f2),
          .bus_num_f3_o                    (bus_num_f3),
          .device_num_f3_o                 (device_num_f3),
          .bus_num_f4_o                    (bus_num_f4),
          .device_num_f4_o                 (device_num_f4),
          .bus_num_f5_o                    (bus_num_f5),
          .device_num_f5_o                 (device_num_f5),
          .bus_num_f6_o                    (bus_num_f6),
          .device_num_f6_o                 (device_num_f6),
          .bus_num_f7_o                    (bus_num_f7),
          .device_num_f7_o                 (device_num_f7),      
          
          .mem_space_en_pf_o               (mem_space_en_pf),
          .mem_space_en_vf_o               (mem_space_en_vf),
          .bus_master_en_pf_o              (bus_master_en_pf),
          .exprom_en_pf_o                  (exprom_en_pf),
          .pf0_num_vfs_o                   (pf0_num_vfs),
          .pf1_num_vfs_o                   (pf1_num_vfs),
          .pf2_num_vfs_o                   (pf2_num_vfs),
          .pf3_num_vfs_o                   (pf3_num_vfs),
          .device_control_reg_max_payload_size_o(max_payload_size_int),
          .device_control_reg_read_req_size_o(rd_req_size),
          .device_control2_reg_compl_timeout_disable_o(compl_timeout_disable_pf),
          .device_control2_reg_atomic_op_requester_en_o(atomic_op_requester_en_pf),
          .extended_tag_en_o               (extended_tag_en_pf),
          .tph_st_mode_o                   (tph_st_mode_pf),
          .tph_requester_en_o              (tph_requester_en_pf),
          .ats_stu_o                       (ats_stu_pf),
          .ats_en_o                        (ats_en_pf),
          // Control Shadow Interface of VFs
          .ctl_shdw_update_o               (ctl_shdw_update),
          .ctl_shdw_pf_num_o               (ctl_shdw_pf_num),
          .ctl_shdw_vf_num_o               (ctl_shdw_vf_num),
          .ctl_shdw_vf_active_o            (ctl_shdw_vf_active),
          .ctl_shdw_cfg_o                  (ctl_shdw_cfg),
          .ctl_shdw_req_all_i              (ctl_shdw_req_all),

          // LMI interface to HIP
          .lmi_addr_hip_o                  (lmi_addr_hip),
          .lmi_din_hip_o                   (lmi_din_hip),
          .lmi_rden_hip_o                  (lmi_rden_hip),
          .lmi_wren_hip_o                  (lmi_wren_hip),
          .lmi_ack_hip_i                   (lmi_ack_hip),
          .lmi_dout_hip_i                  (lmi_dout_hip),
          // LMI interface to user application
          .lmi_addr_app_i                  (lmi_addr_app),
          .lmi_pf_num_app_i                (lmi_pf_num_app),
          .lmi_vf_num_app_i                (lmi_vf_num_app),
          .lmi_vf_active_app_i             (lmi_vf_active_app),
          .lmi_din_app_i                   (lmi_din_app),
          .lmi_rden_app_i                  (lmi_rden_app),
          .lmi_wren_app_i                  (lmi_wren_app),
          .lmi_ack_app_o                   (lmi_ack_app),
          .lmi_dout_app_o                  (lmi_dout_app),

          // Completion Status Signals from user application
          .compl_timeout_with_recovery_i   (cpl_err[0]),
          .compl_timeout_without_recovery_i(cpl_err[1]),
          .ca_sent_i                       (cpl_err[2]),
          .unexp_compl_rcvd_i              (cpl_err[3]),
          .unsupp_p_req_rcvd_i             (cpl_err[4]),
          .unsupp_np_req_rcvd_i            (cpl_err[5]),
          .app_header_logging_en_i         (cpl_err[6]),
          .error_reporting_fn_pf_num_i     (cpl_err_pf_num),
          .error_reporting_fn_vf_num_i     (cpl_err_vf_num),
          .error_reporting_fn_vf_active_i  (cpl_err_vf_active),
          .trans_pending_pf_i              (cpl_pending_pf),
          .app_log_hdr_i                   (log_hdr),
          .trans_pending_vf_status_update_i(vf_compl_status_update),
          .trans_pending_vf_status_i       (vf_compl_status),
          .trans_pending_vf_status_pf_num_i(vf_compl_status_pf_num),
          .trans_pending_vf_status_vf_num_i(vf_compl_status_vf_num),
          .trans_pending_vf_status_update_ack_o(vf_compl_status_update_ack),
          // FLR Interface
          .flr_active_pf_o                 (flr_active_pf),
          .flr_completed_pf_i              (flr_completed_pf),
          .flr_rcvd_vf_o                   (flr_rcvd_vf),
          .flr_rcvd_pf_num_o               (flr_rcvd_pf_num),
          .flr_rcvd_vf_num_o               (flr_rcvd_vf_num),
          .flr_completed_vf_i              (flr_completed_vf),
          .flr_completed_pf_num_i          (flr_completed_pf_num),
          .flr_completed_vf_num_i          (flr_completed_vf_num),

          // Control/Status signals from HIP Config Bypass interface
          .current_speed_i                 (cfgbp_hip2sriov_q2[speed_end:speed_pos]),
          .current_deemph_i                (cfgbp_hip2sriov_q2[deemph_pos]),
          .lane_active_i                   (lane_act),
          .dl_prot_err_i                   (cfgbp_hip2sriov_q2[dlpro_err_pos]), 
          .fl_prot_err_i                   (cfgbp_hip2sriov_q2[fc_err_pos]), 
          .rx_fifo_overflow_i              (cfgbp_hip2sriov_q2[rcvr_ovfl_pos]), 
          .malf_tlp_rcvd_i                 (cfgbp_hip2sriov_q2[malf_pos]),
          .ecrc_err_i                      (|cfgbp_hip2sriov_q2[ecrc_err_end:ecrc_err_pos]), 
          .phy_err_i                       (cfgbp_hip2sriov_q2[rcvr_err_pos]), 
          .dllp_err_i                      (cfgbp_hip2sriov_q2[baddllp_pos]), 
          .tlp_err_i                       (cfgbp_hip2sriov_q2[badtlp_pos]),
          .replay_timeout_i                (cfgbp_hip2sriov_q2[reptim_pos]), 
          .replay_timer_rollover_i         (cfgbp_hip2sriov_q2[repnum_pos]), 
          .link_control2_reg_reset_enter_compl_i(cfgbp_hip2sriov_q2[enter_compliance_pos]),
          .link_control2_reg_reset_tx_margin_i(cfgbp_hip2sriov_q2[txmargin_pos]),
          .lane_error_detected_i           (cfgbp_hip2sriov_q2[lane_err_end:lane_err_pos]),
          .link_equalization_req_i         (cfgbp_hip2sriov_q2[eqreq_pos]),
          .link_equalization_complete_i    (cfgbp_hip2sriov_q2[eqcompl_pos]),
          .link_eq_phase1_successful_i     (cfgbp_hip2sriov_q2[phase1_successful_pos]),
          .link_eq_phase2_successful_i     (cfgbp_hip2sriov_q2[phase2_successful_pos]),
          .link_eq_phase3_successful_i     (cfgbp_hip2sriov_q2[phase3_successful_pos]),
          .ltssm_state_i                   (ltssmstate),

         // Config register outputs to HIP
          .f0_link_control2_reg_o          (cfgbp_link2csr),
          .f0_link_control_reg_com_clk_conf_o(cfgbp_comclk_reg),
          .f0_link_control_reg_ext_synch_o (cfgbp_extsy_reg),
          .f0_link_control_reg_aspm_ctl_o  (cfgbp_linkcsr_bit0),
          .f0_ecrc_gen_enable_o            (cfgbp_tx_ecrcgen),
          .f0_ecrc_chk_enable_o            (cfgbp_rx_ecrchk),
         // VirtIO for PFs
          .f0_virtio_pcicfg_bar_o          (f0_virtio_pcicfg_bar_o      ),
          .f0_virtio_pcicfg_length_o       (f0_virtio_pcicfg_length_o   ),
          .f0_virtio_pcicfg_baroffset_o    (f0_virtio_pcicfg_baroffset_o),
          .f0_virtio_pcicfg_cfgdata_o      (f0_virtio_pcicfg_cfgdata_o  ),
          .f0_virtio_pcicfg_cfgwr_o        (f0_virtio_pcicfg_cfgwr_o    ),
          .f0_virtio_pcicfg_cfgrd_o        (f0_virtio_pcicfg_cfgrd_o    ),
          .f0_virtio_pcicfg_rdack_i        (f0_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f0_virtio_pcicfg_rdbe_i         (f0_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f0_virtio_pcicfg_data_i         (f0_virtio_pcicfg_data_i     ),//Data to be stored in config data register
          .f1_virtio_pcicfg_bar_o          (f1_virtio_pcicfg_bar_o      ),
          .f1_virtio_pcicfg_length_o       (f1_virtio_pcicfg_length_o   ),
          .f1_virtio_pcicfg_baroffset_o    (f1_virtio_pcicfg_baroffset_o),
          .f1_virtio_pcicfg_cfgdata_o      (f1_virtio_pcicfg_cfgdata_o  ),
          .f1_virtio_pcicfg_cfgwr_o        (f1_virtio_pcicfg_cfgwr_o    ),
          .f1_virtio_pcicfg_cfgrd_o        (f1_virtio_pcicfg_cfgrd_o    ),
          .f1_virtio_pcicfg_rdack_i        (f1_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f1_virtio_pcicfg_rdbe_i         (f1_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f1_virtio_pcicfg_data_i         (f1_virtio_pcicfg_data_i     ),//Data to be stored in config data register
          .f2_virtio_pcicfg_bar_o          (f2_virtio_pcicfg_bar_o      ),
          .f2_virtio_pcicfg_length_o       (f2_virtio_pcicfg_length_o   ),
          .f2_virtio_pcicfg_baroffset_o    (f2_virtio_pcicfg_baroffset_o),
          .f2_virtio_pcicfg_cfgdata_o      (f2_virtio_pcicfg_cfgdata_o  ),
          .f2_virtio_pcicfg_cfgwr_o        (f2_virtio_pcicfg_cfgwr_o    ),
          .f2_virtio_pcicfg_cfgrd_o        (f2_virtio_pcicfg_cfgrd_o    ),
          .f2_virtio_pcicfg_rdack_i        (f2_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f2_virtio_pcicfg_rdbe_i         (f2_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f2_virtio_pcicfg_data_i         (f2_virtio_pcicfg_data_i     ),//Data to be stored in config data register
          .f3_virtio_pcicfg_bar_o          (f3_virtio_pcicfg_bar_o      ),
          .f3_virtio_pcicfg_length_o       (f3_virtio_pcicfg_length_o   ),
          .f3_virtio_pcicfg_baroffset_o    (f3_virtio_pcicfg_baroffset_o),
          .f3_virtio_pcicfg_cfgdata_o      (f3_virtio_pcicfg_cfgdata_o  ),
          .f3_virtio_pcicfg_cfgwr_o        (f3_virtio_pcicfg_cfgwr_o    ),
          .f3_virtio_pcicfg_cfgrd_o        (f3_virtio_pcicfg_cfgrd_o    ),
          .f3_virtio_pcicfg_rdack_i        (f3_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f3_virtio_pcicfg_rdbe_i         (f3_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f3_virtio_pcicfg_data_i         (f3_virtio_pcicfg_data_i     ),//Data to be stored in config data register
          .f4_virtio_pcicfg_bar_o          (f4_virtio_pcicfg_bar_o      ),
          .f4_virtio_pcicfg_length_o       (f4_virtio_pcicfg_length_o   ),
          .f4_virtio_pcicfg_baroffset_o    (f4_virtio_pcicfg_baroffset_o),
          .f4_virtio_pcicfg_cfgdata_o      (f4_virtio_pcicfg_cfgdata_o  ),
          .f4_virtio_pcicfg_cfgwr_o        (f4_virtio_pcicfg_cfgwr_o    ),
          .f4_virtio_pcicfg_cfgrd_o        (f4_virtio_pcicfg_cfgrd_o    ),
          .f4_virtio_pcicfg_rdack_i        (f4_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f4_virtio_pcicfg_rdbe_i         (f4_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f4_virtio_pcicfg_data_i         (f4_virtio_pcicfg_data_i     ),//Data to be stored in config data register
          .f5_virtio_pcicfg_bar_o          (f5_virtio_pcicfg_bar_o      ),
          .f5_virtio_pcicfg_length_o       (f5_virtio_pcicfg_length_o   ),
          .f5_virtio_pcicfg_baroffset_o    (f5_virtio_pcicfg_baroffset_o),
          .f5_virtio_pcicfg_cfgdata_o      (f5_virtio_pcicfg_cfgdata_o  ),
          .f5_virtio_pcicfg_cfgwr_o        (f5_virtio_pcicfg_cfgwr_o    ),
          .f5_virtio_pcicfg_cfgrd_o        (f5_virtio_pcicfg_cfgrd_o    ),
          .f5_virtio_pcicfg_rdack_i        (f5_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f5_virtio_pcicfg_rdbe_i         (f5_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f5_virtio_pcicfg_data_i         (f5_virtio_pcicfg_data_i     ),//Data to be stored in config data register
          .f6_virtio_pcicfg_bar_o          (f6_virtio_pcicfg_bar_o      ),
          .f6_virtio_pcicfg_length_o       (f6_virtio_pcicfg_length_o   ),
          .f6_virtio_pcicfg_baroffset_o    (f6_virtio_pcicfg_baroffset_o),
          .f6_virtio_pcicfg_cfgdata_o      (f6_virtio_pcicfg_cfgdata_o  ),
          .f6_virtio_pcicfg_cfgwr_o        (f6_virtio_pcicfg_cfgwr_o    ),
          .f6_virtio_pcicfg_cfgrd_o        (f6_virtio_pcicfg_cfgrd_o    ),
          .f6_virtio_pcicfg_rdack_i        (f6_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f6_virtio_pcicfg_rdbe_i         (f6_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f6_virtio_pcicfg_data_i         (f6_virtio_pcicfg_data_i     ),//Data to be stored in config data register
          .f7_virtio_pcicfg_bar_o          (f7_virtio_pcicfg_bar_o      ),
          .f7_virtio_pcicfg_length_o       (f7_virtio_pcicfg_length_o   ),
          .f7_virtio_pcicfg_baroffset_o    (f7_virtio_pcicfg_baroffset_o),
          .f7_virtio_pcicfg_cfgdata_o      (f7_virtio_pcicfg_cfgdata_o  ),
          .f7_virtio_pcicfg_cfgwr_o        (f7_virtio_pcicfg_cfgwr_o    ),
          .f7_virtio_pcicfg_cfgrd_o        (f7_virtio_pcicfg_cfgrd_o    ),
          .f7_virtio_pcicfg_rdack_i        (f7_virtio_pcicfg_rdack_i    ),//Application Read Data Ack to store config data
          .f7_virtio_pcicfg_rdbe_i         (f7_virtio_pcicfg_rdbe_i     ),//Application indicates which byte to store
          .f7_virtio_pcicfg_data_i         (f7_virtio_pcicfg_data_i     ),//Data to be stored in config data register
         // VirtIO for VFs
          .f0vf_virtio_pcicfg_bar_o        (f0vf_virtio_pcicfg_bar_o       ),
          .f0vf_virtio_pcicfg_length_o     (f0vf_virtio_pcicfg_length_o    ),
          .f0vf_virtio_pcicfg_baroffset_o  (f0vf_virtio_pcicfg_baroffset_o ),
          .f0vf_virtio_pcicfg_cfgdata_o    (f0vf_virtio_pcicfg_cfgdata_o   ),
          .f0vf_virtio_pcicfg_cfgwr_o      (f0vf_virtio_pcicfg_cfgwr_o     ),
          .f0vf_virtio_pcicfg_cfgrd_o      (f0vf_virtio_pcicfg_cfgrd_o     ),
          .f0vf_virtio_pcicfg_vfnum_o      (f0vf_virtio_pcicfg_vfnum_o     ),
          .f0vf_virtio_pcicfg_rdack_i      (f0vf_virtio_pcicfg_rdack_i     ),     //Application Read Data Ack to store config data
          .f0vf_virtio_pcicfg_rdbe_i       (f0vf_virtio_pcicfg_rdbe_i      ),     //Application indicates which byte to store
          .f0vf_virtio_pcicfg_data_i       (f0vf_virtio_pcicfg_data_i      ),     //Data to be stored in config data register
          .f0vf_virtio_pcicfg_appvfnum_i   (f0vf_virtio_pcicfg_appvfnum_i  ),
          .f1vf_virtio_pcicfg_bar_o        (f1vf_virtio_pcicfg_bar_o       ),
          .f1vf_virtio_pcicfg_length_o     (f1vf_virtio_pcicfg_length_o    ),
          .f1vf_virtio_pcicfg_baroffset_o  (f1vf_virtio_pcicfg_baroffset_o ),
          .f1vf_virtio_pcicfg_cfgdata_o    (f1vf_virtio_pcicfg_cfgdata_o   ),
          .f1vf_virtio_pcicfg_cfgwr_o      (f1vf_virtio_pcicfg_cfgwr_o     ),
          .f1vf_virtio_pcicfg_cfgrd_o      (f1vf_virtio_pcicfg_cfgrd_o     ),
          .f1vf_virtio_pcicfg_vfnum_o      (f1vf_virtio_pcicfg_vfnum_o     ),
          .f1vf_virtio_pcicfg_rdack_i      (f1vf_virtio_pcicfg_rdack_i     ),     //Application Read Data Ack to store config data
          .f1vf_virtio_pcicfg_rdbe_i       (f1vf_virtio_pcicfg_rdbe_i      ),     //Application indicates which byte to store
          .f1vf_virtio_pcicfg_data_i       (f1vf_virtio_pcicfg_data_i      ),     //Data to be stored in config data register
          .f1vf_virtio_pcicfg_appvfnum_i   (f1vf_virtio_pcicfg_appvfnum_i  ),
          .f2vf_virtio_pcicfg_bar_o        (f2vf_virtio_pcicfg_bar_o       ),
          .f2vf_virtio_pcicfg_length_o     (f2vf_virtio_pcicfg_length_o    ),
          .f2vf_virtio_pcicfg_baroffset_o  (f2vf_virtio_pcicfg_baroffset_o ),
          .f2vf_virtio_pcicfg_cfgdata_o    (f2vf_virtio_pcicfg_cfgdata_o   ),
          .f2vf_virtio_pcicfg_cfgwr_o      (f2vf_virtio_pcicfg_cfgwr_o     ),
          .f2vf_virtio_pcicfg_cfgrd_o      (f2vf_virtio_pcicfg_cfgrd_o     ),
          .f2vf_virtio_pcicfg_vfnum_o      (f2vf_virtio_pcicfg_vfnum_o     ),
          .f2vf_virtio_pcicfg_rdack_i      (f2vf_virtio_pcicfg_rdack_i     ),     //Application Read Data Ack to store config data
          .f2vf_virtio_pcicfg_rdbe_i       (f2vf_virtio_pcicfg_rdbe_i      ),     //Application indicates which byte to store
          .f2vf_virtio_pcicfg_data_i       (f2vf_virtio_pcicfg_data_i      ),     //Data to be stored in config data register
          .f2vf_virtio_pcicfg_appvfnum_i   (f2vf_virtio_pcicfg_appvfnum_i  ),
          .f3vf_virtio_pcicfg_bar_o        (f3vf_virtio_pcicfg_bar_o       ),
          .f3vf_virtio_pcicfg_length_o     (f3vf_virtio_pcicfg_length_o    ),
          .f3vf_virtio_pcicfg_baroffset_o  (f3vf_virtio_pcicfg_baroffset_o ),
          .f3vf_virtio_pcicfg_cfgdata_o    (f3vf_virtio_pcicfg_cfgdata_o   ),
          .f3vf_virtio_pcicfg_cfgwr_o      (f3vf_virtio_pcicfg_cfgwr_o     ),
          .f3vf_virtio_pcicfg_cfgrd_o      (f3vf_virtio_pcicfg_cfgrd_o     ),
          .f3vf_virtio_pcicfg_vfnum_o      (f3vf_virtio_pcicfg_vfnum_o     ),
          .f3vf_virtio_pcicfg_rdack_i      (f3vf_virtio_pcicfg_rdack_i     ),     //Application Read Data Ack to store config data
          .f3vf_virtio_pcicfg_rdbe_i       (f3vf_virtio_pcicfg_rdbe_i      ),     //Application indicates which byte to store
          .f3vf_virtio_pcicfg_data_i       (f3vf_virtio_pcicfg_data_i      ),     //Data to be stored in config data register
          .f3vf_virtio_pcicfg_appvfnum_i   (f3vf_virtio_pcicfg_appvfnum_i  ),
      // Customer-Specific Inputs and Outputs
          .f0_extra_bar_aperture_i         (f0_extra_bar_aperture),
          .extra_bar_lock_i                (extraBAR_lock),
          .devhide_pf_i                    (devhide_pf),
          .device_rciep_i                  (device_rciep),
          .extra_bar_hit_o                 (extraBAR_hit)
        );       

   assign   cfgbp_max_pload                  = max_payload_size_int;
   //===============================================================
   // Unused Config Bypass status inputs to HIP, assigned to 0.
   //===============================================================
   assign     cfgbp_secbus                   = 8'h0;   
   assign     cfgbp_tx_req_pm                = 1'b0;
   assign     cfgbp_tx_typ_pm                = 3'h0;   
   assign     cfgbp_req_phypm                = 4'h0;   
   assign     cfgbp_req_phycfg               = 4'h0;   
   assign     cfgbp_vc0_tcmap_pld            = 7'h7F;   
   assign     cfgbp_inh_dllp                 = 1'b0; 
   assign     cfgbp_inh_tx_tlp               = 1'b0;   
   assign     cfgbp_req_wake                 = 1'b0;  
   assign     cfgbp_link3_ctl                 = 2'h0;
  //-----------------------------------------------------------------------------------------   
  // Pass through HIP status for HWTCL script
   assign     derr_cor_ext_rcv_drv  = derr_cor_ext_rcv;
   assign     derr_cor_ext_rpl_drv  = derr_cor_ext_rpl;
   assign     derr_rpl_drv          = derr_rpl;
   assign     dlup_drv              = dlup;
   assign     dlup_exit_drv         = dlup_exit;
   assign     ev128ns_drv           = ev128ns;
   assign     ev1us_drv             =  ev1us;
   assign     hotrst_exit_drv       = hotrst_exit;
   assign     int_status_drv        = int_status;
   assign     l2_exit_drv           = l2_exit;
   assign     lane_act_drv          = lane_act;
   assign     ltssmstate_drv        = ltssmstate;
   assign     rx_par_err_drv        = rx_par_err;
   assign     tx_par_err_drv        = tx_par_err;
   assign     cfg_par_err_drv       = cfg_par_err;
   assign     ko_cpl_spc_header_drv = ko_cpl_spc_header;
   assign     ko_cpl_spc_data_drv   = ko_cpl_spc_data; 
   assign     rxfc_cplbuf_ovf_app   = rxfc_cplbuf_ovf_hip;
  //-----------------------------------------------------------------------------------------   
   assign     max_payload_size = max_payload_size_int;

endmodule

