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


proc add_mc_channels {} {
    send_message warning "PRELIMINARY SUPPORT: Component 'PCI Express Multi-Channel DMA Interface'"
   set NUMBER_OF_CHANNELS     [ get_parameter_value NUMBER_OF_CHANNELS ]
   set DESC_WIDTH             [ get_parameter_value DESC_WIDTH ]
   set DESC_MOVER_WIDTH       [expr $DESC_WIDTH - 1]
   
   # 
   # connection point Clock
   # 
   add_interface Clock clock end
   set_interface_property Clock clockRate 0
   set_interface_property Clock ENABLED true
   set_interface_property Clock EXPORT_OF ""
   set_interface_property Clock PORT_NAME_MAP ""
   set_interface_property Clock CMSIS_SVD_VARIABLES ""
   set_interface_property Clock SVD_ADDRESS_GROUP ""
   
   add_interface_port Clock Clk_i clk Input 1
   
   
   # 
   # connection point resetn
   # 
   add_interface resetn reset end
   set_interface_property resetn associatedClock Clock
   set_interface_property resetn synchronousEdges DEASSERT
   set_interface_property resetn ENABLED true
   set_interface_property resetn EXPORT_OF ""
   set_interface_property resetn PORT_NAME_MAP ""
   set_interface_property resetn CMSIS_SVD_VARIABLES ""
   set_interface_property resetn SVD_ADDRESS_GROUP ""
   
   add_interface_port resetn Rstn_i reset_n Input 1           
   
  # 
# connection point DMADesc
# 
add_interface DMADesc avalon_streaming start
set_interface_property DMADesc associatedClock Clock
set_interface_property DMADesc associatedReset resetn
set_interface_property DMADesc dataBitsPerSymbol 8
set_interface_property DMADesc errorDescriptor ""
set_interface_property DMADesc firstSymbolInHighOrderBits true
set_interface_property DMADesc maxChannel 0
set_interface_property DMADesc readyLatency 3
set_interface_property DMADesc ENABLED true
set_interface_property DMADesc EXPORT_OF ""
set_interface_property DMADesc PORT_NAME_MAP ""
set_interface_property DMADesc CMSIS_SVD_VARIABLES ""
set_interface_property DMADesc SVD_ADDRESS_GROUP ""

add_interface_port DMADesc DmaRxData_o data Output $DESC_MOVER_WIDTH
add_interface_port DMADesc DmaRxValid_o valid Output 1
add_interface_port DMADesc DmaRxReady_i ready Input 1

 add_interface DMAStatus avalon_streaming end
 set_interface_property DMAStatus associatedClock Clock
 set_interface_property DMAStatus associatedReset resetn
 set_interface_property DMAStatus dataBitsPerSymbol 32
 set_interface_property DMAStatus errorDescriptor ""
 set_interface_property DMAStatus firstSymbolInHighOrderBits false
 set_interface_property DMAStatus maxChannel 0
 set_interface_property DMAStatus readyLatency 0
 set_interface_property DMAStatus ENABLED true
 set_interface_property DMAStatus EXPORT_OF ""
 set_interface_property DMAStatus PORT_NAME_MAP ""
 set_interface_property DMAStatus CMSIS_SVD_VARIABLES ""
 set_interface_property DMAStatus SVD_ADDRESS_GROUP ""
 
 add_interface_port DMAStatus DmaTxData_i data Input 32
 add_interface_port DMAStatus DmaTxValid_i valid Input 1


# 
# connection point ControlReg
# 
add_interface ControlReg avalon end
set_interface_property ControlReg addressUnits SYMBOLS
set_interface_property ControlReg associatedClock Clock
set_interface_property ControlReg associatedReset resetn
set_interface_property ControlReg bitsPerSymbol 8
set_interface_property ControlReg burstOnBurstBoundariesOnly false
set_interface_property ControlReg burstcountUnits WORDS
set_interface_property ControlReg explicitAddressSpan 0
set_interface_property ControlReg holdTime 0
set_interface_property ControlReg linewrapBursts false
set_interface_property ControlReg maximumPendingReadTransactions 0
set_interface_property ControlReg maximumPendingWriteTransactions 0
set_interface_property ControlReg readLatency 0
set_interface_property ControlReg readWaitTime 1
set_interface_property ControlReg setupTime 0
set_interface_property ControlReg timingUnits Cycles
set_interface_property ControlReg writeWaitTime 0
set_interface_property ControlReg ENABLED true
set_interface_property ControlReg EXPORT_OF ""
set_interface_property ControlReg PORT_NAME_MAP ""
set_interface_property ControlReg CMSIS_SVD_VARIABLES ""
set_interface_property ControlReg SVD_ADDRESS_GROUP ""

add_interface_port ControlReg MCSlaveChipSelect_i chipselect Input 1
add_interface_port ControlReg MCSlaveWrite_i write Input 1
add_interface_port ControlReg MCSlaveAddress_i address Input 14
add_interface_port ControlReg MCSlaveWriteData_i writedata Input 32
add_interface_port ControlReg MCSlaveWaitRequest_o waitrequest Output 1
set_interface_assignment ControlReg embeddedsw.configuration.isFlash 0
set_interface_assignment ControlReg embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment ControlReg embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment ControlReg embeddedsw.configuration.isPrintableDevice 0 
   
   
   
   
   for { set i 0 } { $i < $NUMBER_OF_CHANNELS } { incr i } {      
   	
    ## Controller Instructionb Interface
        add_interface ControllerDescriptor_${i} avalon_streaming end
        set_interface_property ControllerDescriptor_${i} associatedClock Clock
        set_interface_property ControllerDescriptor_${i} associatedReset resetn
        set_interface_property ControllerDescriptor_${i} dataBitsPerSymbol $DESC_WIDTH
        set_interface_property ControllerDescriptor_${i} errorDescriptor ""
        set_interface_property ControllerDescriptor_${i} firstSymbolInHighOrderBits false
        set_interface_property ControllerDescriptor_${i} maxChannel 0
        set_interface_property ControllerDescriptor_${i} readyLatency 0
        set_interface_property ControllerDescriptor_${i} ENABLED true
        set_interface_property ControllerDescriptor_${i} EXPORT_OF ""
        set_interface_property ControllerDescriptor_${i} PORT_NAME_MAP ""
        set_interface_property ControllerDescriptor_${i} CMSIS_SVD_VARIABLES ""
        set_interface_property ControllerDescriptor_${i} SVD_ADDRESS_GROUP ""
        
        add_interface_port ControllerDescriptor_${i} DescInstr${i}_i data Input $DESC_WIDTH
        add_interface_port ControllerDescriptor_${i} DescInstrValid${i}_i valid Input 1
        add_interface_port ControllerDescriptor_${i} DescInstrReady${i}_o ready Output 1
        
    ### Controller Status Interface    
        add_interface ControllerStatus_${i} avalon_streaming start
        set_interface_property ControllerStatus_${i} associatedClock Clock
        set_interface_property ControllerStatus_${i} associatedReset resetn
        set_interface_property ControllerStatus_${i} dataBitsPerSymbol 32
        set_interface_property ControllerStatus_${i} errorDescriptor ""
        set_interface_property ControllerStatus_${i} firstSymbolInHighOrderBits false
        set_interface_property ControllerStatus_${i} maxChannel 0
        set_interface_property ControllerStatus_${i} readyLatency 0
        set_interface_property ControllerStatus_${i} ENABLED true
        set_interface_property ControllerStatus_${i} EXPORT_OF ""
        set_interface_property ControllerStatus_${i} PORT_NAME_MAP ""
        set_interface_property ControllerStatus_${i} CMSIS_SVD_VARIABLES ""
        set_interface_property ControllerStatus_${i} SVD_ADDRESS_GROUP ""
        
        add_interface_port ControllerStatus_${i} DmaTxData${i}_o data Output 32
        add_interface_port ControllerStatus_${i} DmaTxValid${i}_o valid Output 1
        
      }
                   }
                   
                   