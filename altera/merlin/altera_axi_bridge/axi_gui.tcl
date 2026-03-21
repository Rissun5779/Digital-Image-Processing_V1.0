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


# +-----------------------------------
# | display items
# |
add_display_item "" "Bridge Parameters" GROUP tab
add_display_item "Bridge Parameters" AXI_VERSION PARAMETER ""
add_display_item "Bridge Parameters" DATA_WIDTH PARAMETER ""
add_display_item "Bridge Parameters" ADDR_WIDTH PARAMETER ""
add_display_item "Bridge Parameters" READ_DATA_REORDERING_DEPTH PARAMETER ""
add_display_item "Bridge Parameters" "Sideband Signal Width" GROUP
add_display_item "Sideband Signal Width" WRITE_ADDR_USER_WIDTH PARAMETER ""
add_display_item "Sideband Signal Width" READ_ADDR_USER_WIDTH PARAMETER ""
add_display_item "Sideband Signal Width" WRITE_DATA_USER_WIDTH PARAMETER ""
add_display_item "Sideband Signal Width" READ_DATA_USER_WIDTH PARAMETER ""
add_display_item "Sideband Signal Width" WRITE_RESP_USER_WIDTH PARAMETER ""
add_display_item "Bridge Parameters" USE_PIPELINE PARAMETER ""
add_display_item "" "Slave Side Interface" GROUP tab
add_display_item "Slave Side Interface" "Slave Main" GROUP
add_display_item "Slave Side Interface" "Slave Write Address Channel" GROUP
add_display_item "Slave Side Interface" "Slave Write Data Channel" GROUP
add_display_item "Slave Side Interface" "Slave Write Response Channel" GROUP
add_display_item "Slave Side Interface" "Slave Read Address Channel" GROUP
add_display_item "Slave Side Interface" "Slave Read Data Channel" GROUP
add_display_item "Slave Main" S0_ID_WIDTH PARAMETER ""
add_display_item "Slave Main" WRITE_ACCEPTANCE_CAPABILITY PARAMETER ""
add_display_item "Slave Main" READ_ACCEPTANCE_CAPABILITY PARAMETER ""
add_display_item "Slave Main" COMBINED_ACCEPTANCE_CAPABILITY PARAMETER ""
add_display_item "Slave Write Address Channel" USE_S0_AWREGION PARAMETER ""
add_display_item "Slave Write Address Channel" USE_S0_AWLOCK PARAMETER ""
add_display_item "Slave Write Address Channel" USE_S0_AWCACHE PARAMETER ""
add_display_item "Slave Write Address Channel" USE_S0_AWQOS PARAMETER ""
add_display_item "Slave Write Address Channel" USE_S0_AWPROT PARAMETER ""
add_display_item "Slave Write Address Channel" USE_S0_AWUSER PARAMETER ""
add_display_item "Slave Write Data Channel" USE_S0_WLAST PARAMETER ""
add_display_item "Slave Write Data Channel" USE_S0_WUSER PARAMETER ""
add_display_item "Slave Write Response Channel" USE_S0_BRESP PARAMETER ""
add_display_item "Slave Write Response Channel" USE_S0_BUSER PARAMETER ""
add_display_item "Slave Read Address Channel" USE_S0_ARREGION PARAMETER ""
add_display_item "Slave Read Address Channel" USE_S0_ARLOCK PARAMETER ""
add_display_item "Slave Read Address Channel" USE_S0_ARCACHE PARAMETER ""
add_display_item "Slave Read Address Channel" USE_S0_ARQOS PARAMETER ""
add_display_item "Slave Read Address Channel" USE_S0_ARPROT PARAMETER ""
add_display_item "Slave Read Address Channel" USE_S0_ARUSER PARAMETER ""  
add_display_item "Slave Read Data Channel" USE_S0_RRESP PARAMETER ""
add_display_item "Slave Read Data Channel" USE_S0_RUSER PARAMETER ""
add_display_item "" "Master Side Interface" GROUP tab
add_display_item "Master Side Interface" "Master Main" GROUP
add_display_item "Master Side Interface" "Master Write Address Channel" GROUP
add_display_item "Master Side Interface" "Master Write Data Channel" GROUP
add_display_item "Master Side Interface" "Master Write Response Channel" GROUP
add_display_item "Master Side Interface" "Master Read Address Channel" GROUP
add_display_item "Master Side Interface" "Master Read Data Channel" GROUP
add_display_item "Master Main" M0_ID_WIDTH PARAMETER ""
add_display_item "Master Main" WRITE_ISSUING_CAPABILITY PARAMETER ""
add_display_item "Master Main" READ_ISSUING_CAPABILITY PARAMETER ""
add_display_item "Master Main" COMBINED_ISSUING_CAPABILITY PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWID     PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWREGION PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWLEN    PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWSIZE   PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWBURST  PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWLOCK   PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWCACHE  PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWQOS    PARAMETER ""
add_display_item "Master Write Address Channel" USE_M0_AWUSER   PARAMETER ""
add_display_item "Master Write Data Channel"  USE_M0_WSTRB    PARAMETER ""
add_display_item "Master Write Data Channel"  USE_M0_WUSER    PARAMETER ""
add_display_item "Master Write Response Channel"  USE_M0_BID      PARAMETER ""
add_display_item "Master Write Response Channel"  USE_M0_BRESP    PARAMETER ""
add_display_item "Master Write Response Channel"  USE_M0_BUSER    PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARID     PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARREGION PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARLEN    PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARSIZE   PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARBURST  PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARLOCK   PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARCACHE  PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARQOS    PARAMETER ""
add_display_item "Master Read Address Channel" USE_M0_ARUSER   PARAMETER ""
add_display_item "Master Read Data Channel"  USE_M0_RID      PARAMETER ""
add_display_item "Master Read Data Channel"  USE_M0_RRESP    PARAMETER ""
add_display_item "Master Read Data Channel"  USE_M0_RLAST    PARAMETER ""
add_display_item "Master Read Data Channel"  USE_M0_RUSER    PARAMETER ""

proc validate_parameters {} {
    set axi3_version          [ get_parameter_value AXI_VERSION ]

    set_enable USE_S0_AWREGION
    set_enable USE_S0_AWLOCK
    set_enable USE_S0_AWCACHE
    set_enable USE_S0_AWQOS
    set_enable USE_S0_AWPROT
    set_enable USE_S0_WLAST
    set_enable USE_S0_WUSER
    set_enable USE_S0_BRESP
    set_enable USE_S0_BUSER
    set_enable USE_S0_ARREGION
    set_enable USE_S0_ARLOCK
    set_enable USE_S0_ARCACHE
    set_enable USE_S0_ARQOS
    set_enable USE_S0_ARPROT  
    set_enable USE_S0_RRESP
    set_enable USE_S0_RUSER

    set_enable USE_M0_AWID    
    set_enable USE_M0_AWREGION
    set_enable USE_M0_AWLEN   
    set_enable USE_M0_AWSIZE  
    set_enable USE_M0_AWBURST 
    set_enable USE_M0_AWLOCK  
    set_enable USE_M0_AWCACHE 
    set_enable USE_M0_AWQOS   
    set_enable USE_M0_WSTRB   
    set_enable USE_M0_WUSER   
    set_enable USE_M0_BID     
    set_enable USE_M0_BUSER     
    set_enable USE_M0_BRESP   
    set_enable USE_M0_ARID    
    set_enable USE_M0_ARREGION
    set_enable USE_M0_ARLEN   
    set_enable USE_M0_ARSIZE  
    set_enable USE_M0_ARBURST 
    set_enable USE_M0_ARLOCK  
    set_enable USE_M0_ARCACHE 
    set_enable USE_M0_ARQOS   
    set_enable USE_M0_RID     
    set_enable USE_M0_RRESP   
    set_enable USE_M0_RLAST   
    set_enable USE_M0_RUSER   

    if { [expr {$axi3_version == "AXI3"}] } {
        set_disable USE_S0_AWREGION
        set_disable USE_S0_AWLOCK
        set_disable USE_S0_AWCACHE
        set_disable USE_S0_AWQOS
        set_disable USE_S0_AWPROT
        set_disable USE_S0_WLAST
        set_disable USE_S0_WUSER
        set_disable USE_S0_BRESP
        set_disable USE_S0_BUSER
        set_disable USE_S0_ARREGION
        set_disable USE_S0_ARLOCK
        set_disable USE_S0_ARCACHE
        set_disable USE_S0_ARQOS
        set_disable USE_S0_ARPROT
        set_disable USE_S0_RRESP
        set_disable USE_S0_RUSER

        set_disable USE_M0_AWID
        set_disable USE_M0_AWREGION
        set_disable USE_M0_AWLEN
        set_disable USE_M0_AWSIZE
        set_disable USE_M0_AWBURST
        set_disable USE_M0_AWLOCK
        set_disable USE_M0_AWCACHE
        set_disable USE_M0_AWQOS
        set_disable USE_M0_WSTRB
        set_disable USE_M0_WUSER
        set_disable USE_M0_BID
        set_disable USE_M0_BUSER
        set_disable USE_M0_BRESP
        set_disable USE_M0_ARID
        set_disable USE_M0_ARREGION
        set_disable USE_M0_ARLEN
        set_disable USE_M0_ARSIZE
        set_disable USE_M0_ARBURST
        set_disable USE_M0_ARLOCK
        set_disable USE_M0_ARCACHE
        set_disable USE_M0_ARQOS
        set_disable USE_M0_RID
        set_disable USE_M0_RRESP
        set_disable USE_M0_RLAST
        set_disable USE_M0_RUSER   
    }
}   
