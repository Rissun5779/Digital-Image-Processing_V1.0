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


####################################################################################################
#
# AVMM 256 Clock conduit
#
proc add_port_clk {} {

   send_message debug "proc:add_port_clk"

   add_interface pld_clk clock end
   add_interface_port pld_clk Clk_i clk Input 1

}


##################################################################################################
#
# AVMM 256 Reset conduit
#
proc add_port_rst {} {

   send_message debug "proc:add_port_rst"
   add_interface clr_st reset end
   set_interface_property clr_st ASSOCIATED_CLOCK pld_clk
   add_interface_port clr_st Rstn_i reset Input 1

}
##################################################################################################
#
#       // MSI Conduit
#
proc add_port_hip_msiintfc {} {

   send_message debug "proc:add_port_hip_msiintfc"
   add_interface msi_intfc conduit end
   add_interface_port msi_intfc MsiInterface_i msi_intfc Input 82
}
###################################################################################
#
# Read Descriptor Controller AVMM Slave Interface [Register Access]
#
proc add_pcie_avmm_readdcslave {} {

   send_message debug "proc:add_pcie_avmm_readdcslave"

   add_interface readdcs avalon slave
   set_interface_property readdcs associatedClock                pld_clk
   set_interface_property readdcs associatedReset                clr_st
   set_interface_property readdcs addressAlignment               DYNAMIC
   set_interface_property readdcs interleaveBursts               false
   set_interface_property readdcs readLatency                    0
   set_interface_property readdcs writeWaitTime                  1
   set_interface_property readdcs readWaitTime                   1
   set_interface_property readdcs addressUnits                   SYMBOLS

   add_interface_port readdcs RdDCSChipSelect_i    chipselect    Input  1
   add_interface_port readdcs RdDCSWrite_i         write         Input  1
   add_interface_port readdcs RdDCSAddress_i       address       Input  8
   add_interface_port readdcs RdDCSWriteData_i     writedata     Input  32
   add_interface_port readdcs RdDCSByteEnable_i    byteenable    Input  4
   add_interface_port readdcs RdDCSWaitRequest_o   waitrequest   Output 1
   add_interface_port readdcs RdDCSRead_i          read          Input  1
   add_interface_port readdcs RdDCSReadData_o      readdata      Output 32

}

###################################################################################
#
# Read Descriptor Controller AVMM Master Interface [MSI Generation]
#
proc add_pcie_avmm_avmm_readdcmaster {} {

   send_message debug "proc:add_pcie_avmm_avmm_readdcmaster"

   add_interface readdcm avalon master
   set_interface_property readdcm associatedClock  pld_clk
   set_interface_property readdcm associatedReset  clr_st
   set_interface_property readdcm interleaveBursts false
   set_interface_property readdcm doStreamReads    false
   set_interface_property readdcm doStreamWrites   false
   set_interface_property readdcm maxAddressWidth  64
   set_interface_property readdcm addressGroup     0

   add_interface_port readdcm RdDCMWrite_o         write         Output 1
   add_interface_port readdcm RdDCMAddress_o       address       Output 64
   add_interface_port readdcm RdDCMWriteData_o     writedata     Output 32
   add_interface_port readdcm RdDCMByteEnable_o    byteenable    Output 4
   add_interface_port readdcm RdDCMWaitRequest_i   waitrequest   Input  1
   add_interface_port readdcm RdDCMRead_o          read          Output 1
   add_interface_port readdcm RdDCMReadData_i      readdata      Input  32
   add_interface_port readdcm RdDCMReadDataValid_i readdatavalid Input  1

}
###################################################################################
#
# Read Descriptor Table Slave Interface [Descriptor table Access]
#
proc add_pcie_avmm_readdtslave {} {

   send_message debug "proc:add_pcie_avmm_readdtslave"

   add_interface readdts avalon slave
   set_interface_property readdts associatedClock                pld_clk
   set_interface_property readdts associatedReset                clr_st
   set_interface_property readdts addressAlignment               DYNAMIC
   set_interface_property readdts interleaveBursts               false
   set_interface_property readdts readLatency                    0
   set_interface_property readdts writeWaitTime                  1
   set_interface_property readdts readWaitTime                   1
   set_interface_property readdts addressUnits                   SYMBOLS

   add_interface_port readdts RdDTSChipSelect_i    chipselect    Input  1
   add_interface_port readdts RdDTSWrite_i         write         Input  1
   add_interface_port readdts RdDTSBurstCount_i    burstcount    Input  5
   add_interface_port readdts RdDTSAddress_i       address       Input  8
   add_interface_port readdts RdDTSWriteData_i     writedata     Input  256
   add_interface_port readdts RdDTSWaitRequest_o   waitrequest   Output 1

}


###################################################################################
#
# Read Descriptor Avalon Streaming Transmit Interface - [Descriptor Programming]
#
proc add_pcie_rd_ast_tx {} {

   send_message debug "proc:add_pcie_rd_ast_tx"

   add_interface rd_ast_tx avalon_streaming start
   set_interface_property rd_ast_tx dataBitsPerSymbol 160
   set_interface_property rd_ast_tx maxChannel        0
   set_interface_property rd_ast_tx readyLatency      0
   set_interface_property rd_ast_tx ENABLED           true
   set_interface_property rd_ast_tx ASSOCIATED_CLOCK  pld_clk
   set_interface_property rd_ast_tx associatedReset   clr_st

   add_interface_port rd_ast_tx RdDmaTxData_o  data  Output 160
   add_interface_port rd_ast_tx RdDmaTxValid_o valid Output 1
   add_interface_port rd_ast_tx RdDmaTxReady_i ready Input 1

}

###################################################################################
#
# Read Descriptor Avalon Streaming Receive Interface - [Descriptor Status]
#
proc add_pcie_rd_ast_rx {} {

   send_message debug "proc:add_pcie_rd_ast_rx"

   add_interface rd_ast_rx avalon_streaming end
   set_interface_property rd_ast_rx dataBitsPerSymbol 32
   set_interface_property rd_ast_rx maxChannel        0
   set_interface_property rd_ast_rx readyLatency      0
   set_interface_property rd_ast_rx ENABLED           true
   set_interface_property rd_ast_rx ASSOCIATED_CLOCK  pld_clk
   set_interface_property rd_ast_rx associatedReset   clr_st

   add_interface_port rd_ast_rx RdDmaRxData_i  data  Input 32
   add_interface_port rd_ast_rx RdDmaRxValid_i valid Input 1

}

###################################################################################
#
# Write Descriptor Controller AVMM Slave Interface [Register Access]
#
proc add_pcie_avmm_writedcslave {} {

   send_message debug "proc:add_pcie_avmm_writedcslave"

   add_interface writedcs avalon slave
   set_interface_property writedcs associatedClock                pld_clk
   set_interface_property writedcs associatedReset                clr_st
   set_interface_property writedcs addressAlignment               DYNAMIC
   set_interface_property writedcs interleaveBursts               false
   set_interface_property writedcs readLatency                    0
   set_interface_property writedcs writeWaitTime                  1
   set_interface_property writedcs readWaitTime                   1
   set_interface_property writedcs addressUnits                   SYMBOLS

   add_interface_port writedcs WrDCSChipSelect_i    chipselect    Input  1
   add_interface_port writedcs WrDCSWrite_i         write         Input  1
   add_interface_port writedcs WrDCSAddress_i       address       Input  8
   add_interface_port writedcs WrDCSWriteData_i     writedata     Input  32
   add_interface_port writedcs WrDCSByteEnable_i    byteenable    Input  4
   add_interface_port writedcs WrDCSWaitRequest_o   waitrequest   Output 1
   add_interface_port writedcs WrDCSRead_i          read          Input  1
   add_interface_port writedcs WrDCSReadData_o      readdata      Output 32

}

###################################################################################
#
# Write Descriptor Controller AVMM Master Interface [MSI Generation]
#
proc add_pcie_avmm_avmm_writedcmaster {} {

   send_message debug "proc:add_pcie_avmm_avmm_writedcmaster"

   add_interface writedcm avalon master
   set_interface_property writedcm associatedClock  pld_clk
   set_interface_property writedcm associatedReset  clr_st
   set_interface_property writedcm interleaveBursts false
   set_interface_property writedcm doStreamReads    false
   set_interface_property writedcm doStreamWrites   false
   set_interface_property writedcm maxAddressWidth  64
   set_interface_property writedcm addressGroup     0

   add_interface_port writedcm WrDCMWrite_o         write         Output 1
   add_interface_port writedcm WrDCMAddress_o       address       Output 64
   add_interface_port writedcm WrDCMWriteData_o     writedata     Output 32
   add_interface_port writedcm WrDCMByteEnable_o    byteenable    Output 4
   add_interface_port writedcm WrDCMWaitRequest_i   waitrequest   Input  1
   add_interface_port writedcm WrDCMRead_o          read          Output 1
   add_interface_port writedcm WrDCMReadData_i      readdata      Input  32
   add_interface_port writedcm WrDCMReadDataValid_i readdatavalid Input  1

}
###################################################################################
#
# Write Descriptor Table Slave Interface [Descriptor table Access]
#
proc add_pcie_avmm_writedtslave {} {

   send_message debug "proc:add_pcie_avmm_writedtslave"

   add_interface writedts avalon slave
   set_interface_property writedts associatedClock                pld_clk
   set_interface_property writedts associatedReset                clr_st
   set_interface_property writedts addressAlignment               DYNAMIC
   set_interface_property writedts interleaveBursts               false
   set_interface_property writedts readLatency                    0
   set_interface_property writedts writeWaitTime                  1
   set_interface_property writedts readWaitTime                   1
   set_interface_property writedts addressUnits                   SYMBOLS

   add_interface_port writedts WrDTSChipSelect_i    chipselect    Input  1
   add_interface_port writedts WrDTSWrite_i         write         Input  1
   add_interface_port writedts WrDTSBurstCount_i    burstcount    Input  5
   add_interface_port writedts WrDTSAddress_i       address       Input  8
   add_interface_port writedts WrDTSWriteData_i     writedata     Input  256
   add_interface_port writedts WrDTSWaitRequest_o   waitrequest   Output 1

}


###################################################################################
#
# Write Descriptor Avalon Streaming Transmit Interface - [Descriptor Programming]
#
proc add_pcie_wr_ast_tx {} {

   send_message debug "proc:add_pcie_wr_ast_tx"

   add_interface wr_ast_tx avalon_streaming start
   set_interface_property wr_ast_tx dataBitsPerSymbol 160
   set_interface_property wr_ast_tx maxChannel        0
   set_interface_property wr_ast_tx readyLatency      0
   set_interface_property wr_ast_tx ENABLED           true
   set_interface_property wr_ast_tx ASSOCIATED_CLOCK  pld_clk
   set_interface_property wr_ast_tx associatedReset   clr_st

   add_interface_port wr_ast_tx WrDmaTxData_o  data  Output 160
   add_interface_port wr_ast_tx WrDmaTxValid_o valid Output 1
   add_interface_port wr_ast_tx WrDmaTxReady_i ready Input 1

}

###################################################################################
#
# Write Descriptor Avalon Streaming Receive Interface - [Descriptor Status]
#
proc add_pcie_wr_ast_rx {} {

   send_message debug "proc:add_pcie_wr_ast_rx"

   add_interface wr_ast_rx avalon_streaming end
   set_interface_property wr_ast_rx dataBitsPerSymbol 32
   set_interface_property wr_ast_rx maxChannel        0
   set_interface_property wr_ast_rx readyLatency      0
   set_interface_property wr_ast_rx ENABLED           true
   set_interface_property wr_ast_rx ASSOCIATED_CLOCK  pld_clk
   set_interface_property wr_ast_rx associatedReset   clr_st

   add_interface_port wr_ast_rx WrDmaRxData_i  data  Input 32
   add_interface_port wr_ast_rx WrDmaRxValid_i valid Input 1

}






