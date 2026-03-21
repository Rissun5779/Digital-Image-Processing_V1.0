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





proc elab_F2H {device_family} {
    set instance_name  fpga2hps
    set wys_atom_name  twentynm_hps_rl_interface_fpga2hps
    set termination_value { 0 0 0 0 }


    set addr_width 32
    set width [get_parameter_value F2S_Width]
    set enable_ready_latency 0
    if {$width > 3} {
        set enable_ready_latency 1
    }

    fpga_interfaces::add_module_instance $instance_name $wys_atom_name 
    
    if {$width > 0} {
        set data_width 32
        set strb_width 4
        set termination_value { 0 0 1 0 }

        if {$width == 2 || $width == 5} {
            set data_width 64
            set strb_width 8
            set termination_value { 1 0 1 0 }
        } elseif {$width == 3 || $width == 6} {
            set data_width 128
            set strb_width 16
            set termination_value { 0 1 1 0 }
        }

        set clock_name "f2h_axi_clock"
        set clk_wire [fpga_interfaces::allocate_wire]
        
        fpga_interfaces::set_instance_parameter $instance_name DWIDTH $data_width
        
        fpga_interfaces::add_interface      $clock_name  clock           Input
        fpga_interfaces::add_interface_port $clock_name  f2h_axi_clk  clk Input 1
        fpga_interfaces::set_port_fragments $clock_name  f2h_axi_clk  [fpga_interfaces::wire_tofragment $clk_wire]

        foreach port_name { clk w_clk b_clk ar_clk r_clk aw_clk } {
            set port_wire [fpga_interfaces::allocate_wire] ;# set wire simulation rendering later
            fpga_interfaces::set_wire_port_fragments $port_wire drives "${instance_name}:${port_name}(0:0)"
            fpga_interfaces::hookup_wires  $port_wire $clk_wire
        }
        

        if {$enable_ready_latency} {
            set reset_name "f2h_axi_reset"
            fpga_interfaces::add_interface           $reset_name reset Input
            fpga_interfaces::add_interface_port      $reset_name f2h_axi_rst  reset_n Input 1 $instance_name rst_n
            fpga_interfaces::set_interface_property  $reset_name associatedClock $clock_name
        } else {
            set reset_name "h2f_reset"
            fpga_interfaces::set_instance_port_termination ${instance_name} "rst_n" 1 1  0:0 1
            
        }
        
        set iface_name "f2h_axi_slave"
        set z          "f2h_"

        fpga_interfaces::add_interface               $iface_name axi slave
        fpga_interfaces::set_interface_property      $iface_name associatedClock $clock_name
        fpga_interfaces::set_interface_property      $iface_name associatedReset $reset_name
        fpga_interfaces::set_interface_property      $iface_name readAcceptanceCapability 8
        fpga_interfaces::set_interface_property      $iface_name writeAcceptanceCapability 8
        fpga_interfaces::set_interface_property      $iface_name combinedAcceptanceCapability 16
        fpga_interfaces::set_interface_property      $iface_name readDataReorderingDepth 8
        fpga_interfaces::set_interface_meta_property $iface_name data_width $data_width
        fpga_interfaces::set_interface_meta_property $iface_name address_width $addr_width

        fpga_interfaces::add_interface_port  $iface_name ${z}AWID     awid     Input  4           $instance_name aw_id       
        fpga_interfaces::add_interface_port  $iface_name ${z}AWADDR   awaddr   Input  $addr_width $instance_name aw_addr     
        fpga_interfaces::add_interface_port  $iface_name ${z}AWLEN    awlen    Input  4           $instance_name aw_len      
        fpga_interfaces::add_interface_port  $iface_name ${z}AWSIZE   awsize   Input  3           $instance_name aw_size     
        fpga_interfaces::add_interface_port  $iface_name ${z}AWBURST  awburst  Input  2           $instance_name aw_burst    
        fpga_interfaces::add_interface_port  $iface_name ${z}AWLOCK   awlock   Input  2           $instance_name aw_lock     
        fpga_interfaces::add_interface_port  $iface_name ${z}AWCACHE  awcache  Input  4           $instance_name aw_cache    
        fpga_interfaces::add_interface_port  $iface_name ${z}AWPROT   awprot   Input  3           $instance_name aw_prot     
        fpga_interfaces::add_interface_port  $iface_name ${z}AWVALID  awvalid  Input  1           $instance_name aw_valid    
        fpga_interfaces::add_interface_port  $iface_name ${z}AWREADY  awready  Output 1           $instance_name aw_ready    
        fpga_interfaces::add_interface_port  $iface_name ${z}AWUSER   awuser   Input  5           $instance_name aw_user     
                                                                                                                            
        fpga_interfaces::add_interface_port  $iface_name ${z}WID      wid      Input  4           $instance_name w_id        
        fpga_interfaces::add_interface_port  $iface_name ${z}WDATA    wdata    Input  $data_width $instance_name w_data      
        fpga_interfaces::add_interface_port  $iface_name ${z}WSTRB    wstrb    Input  $strb_width $instance_name w_strb      
        fpga_interfaces::add_interface_port  $iface_name ${z}WLAST    wlast    Input  1           $instance_name w_last      
        fpga_interfaces::add_interface_port  $iface_name ${z}WVALID   wvalid   Input  1           $instance_name w_valid     
        fpga_interfaces::add_interface_port  $iface_name ${z}WREADY   wready   Output 1           $instance_name w_ready     
                                                                                                                            
        fpga_interfaces::add_interface_port  $iface_name ${z}BID      bid      Output 4           $instance_name b_id        
        fpga_interfaces::add_interface_port  $iface_name ${z}BRESP    bresp    Output 2           $instance_name b_resp      
        fpga_interfaces::add_interface_port  $iface_name ${z}BVALID   bvalid   Output 1           $instance_name b_valid     
        fpga_interfaces::add_interface_port  $iface_name ${z}BREADY   bready   Input  1           $instance_name b_ready     
                                                                                                                            
        fpga_interfaces::add_interface_port  $iface_name ${z}ARID     arid     Input  4           $instance_name ar_id       
        fpga_interfaces::add_interface_port  $iface_name ${z}ARADDR   araddr   Input  $addr_width $instance_name ar_addr     
        fpga_interfaces::add_interface_port  $iface_name ${z}ARLEN    arlen    Input  4           $instance_name ar_len      
        fpga_interfaces::add_interface_port  $iface_name ${z}ARSIZE   arsize   Input  3           $instance_name ar_size     
        fpga_interfaces::add_interface_port  $iface_name ${z}ARBURST  arburst  Input  2           $instance_name ar_burst    
        fpga_interfaces::add_interface_port  $iface_name ${z}ARLOCK   arlock   Input  2           $instance_name ar_lock     
        fpga_interfaces::add_interface_port  $iface_name ${z}ARCACHE  arcache  Input  4           $instance_name ar_cache    
        fpga_interfaces::add_interface_port  $iface_name ${z}ARPROT   arprot   Input  3           $instance_name ar_prot     
        fpga_interfaces::add_interface_port  $iface_name ${z}ARVALID  arvalid  Input  1           $instance_name ar_valid    
        fpga_interfaces::add_interface_port  $iface_name ${z}ARREADY  arready  Output 1           $instance_name ar_ready    
        fpga_interfaces::add_interface_port  $iface_name ${z}ARUSER   aruser   Input  5           $instance_name ar_user     
                                                                                                                            
        fpga_interfaces::add_interface_port  $iface_name ${z}RID      rid      Output 4           $instance_name r_id        
        fpga_interfaces::add_interface_port  $iface_name ${z}RDATA    rdata    Output $data_width $instance_name r_data      
        fpga_interfaces::add_interface_port  $iface_name ${z}RRESP    rresp    Output 2           $instance_name r_resp      
        fpga_interfaces::add_interface_port  $iface_name ${z}RLAST    rlast    Output 1           $instance_name r_last      
        fpga_interfaces::add_interface_port  $iface_name ${z}RVALID   rvalid   Output 1           $instance_name r_valid     
        fpga_interfaces::add_interface_port  $iface_name ${z}RREADY   rready   Input  1           $instance_name r_ready     
    }

    if {$enable_ready_latency} {
        set termination_value [lreplace $termination_value 3 3 1]
    } else {
        set termination_value [lreplace $termination_value 3 3 0]
    }

    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_0" 1 0  0:0 [lindex $termination_value 0]
    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_1" 1 0  0:0 [lindex $termination_value 1]
    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_2" 1 0  0:0 [lindex $termination_value 2]
    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_3" 1 0  0:0 [lindex $termination_value 3]
}

proc elab_H2F {device_family} {
    set instance_name  hps2fpga
    set wys_atom_name  twentynm_hps_rl_interface_hps2fpga
    set termination_value { 0 0 0 0 }


    set addr_width 32
    set id_width   4
    set width [get_parameter_value S2F_Width]
    set enable_ready_latency 0
    if {$width > 3} {
        set enable_ready_latency 1
    }

    fpga_interfaces::add_module_instance $instance_name $wys_atom_name 
    
    
    if {$width > 0} {
        set data_width 32
        set strb_width 4
        set termination_value { 0 0 1 0 }

        if {$width == 2 || $width == 5} {
            set data_width 64
            set strb_width 8
            set termination_value { 1 0 1 0 }
        } elseif {$width == 3 || $width == 6} {
            set data_width 128
            set strb_width 16
            set termination_value { 0 1 1 0 }
        }

        fpga_interfaces::set_instance_parameter $instance_name DWIDTH $data_width
        
        set clock_name "h2f_axi_clock"
        set clk_wire [fpga_interfaces::allocate_wire]
        fpga_interfaces::add_interface      $clock_name  clock           Input
        fpga_interfaces::add_interface_port $clock_name  h2f_axi_clk  clk Input 1
        fpga_interfaces::set_port_fragments $clock_name  h2f_axi_clk  [fpga_interfaces::wire_tofragment $clk_wire]

        foreach port_name { clk w_clk b_clk ar_clk r_clk aw_clk } {
            set port_wire [fpga_interfaces::allocate_wire] ;# set wire simulation rendering later
            fpga_interfaces::set_wire_port_fragments $port_wire drives "${instance_name}:${port_name}(0:0)"
            fpga_interfaces::hookup_wires $port_wire $clk_wire
        }

        if {$enable_ready_latency} {
            set reset_name "h2f_axi_reset"
            fpga_interfaces::add_interface           $reset_name reset Input
            fpga_interfaces::add_interface_port      $reset_name h2f_axi_rst  reset_n Input 1 $instance_name rst_n
            fpga_interfaces::set_interface_property  $reset_name associatedClock $clock_name
        } else {
            set reset_name "h2f_reset"
            fpga_interfaces::set_instance_port_termination ${instance_name} "rst_n" 1 1  0:0 1
        }

        set iface_name "h2f_axi_master"
        set z          "h2f_"

        fpga_interfaces::add_interface               $iface_name  axi master
        fpga_interfaces::set_interface_property      $iface_name associatedClock $clock_name
        fpga_interfaces::set_interface_property      $iface_name associatedReset $reset_name
        fpga_interfaces::set_interface_property      $iface_name readIssuingCapability 8
        fpga_interfaces::set_interface_property      $iface_name writeIssuingCapability 8
        fpga_interfaces::set_interface_property      $iface_name combinedIssuingCapability 16

        fpga_interfaces::set_interface_meta_property $iface_name data_width $data_width
        fpga_interfaces::set_interface_meta_property $iface_name address_width $addr_width
        fpga_interfaces::set_interface_meta_property $iface_name id_width $id_width

        fpga_interfaces::add_interface_port $iface_name  ${z}AWID     awid     Output $id_width   $instance_name aw_id        
        fpga_interfaces::add_interface_port $iface_name  ${z}AWADDR   awaddr   Output $addr_width $instance_name aw_addr      
        fpga_interfaces::add_interface_port $iface_name  ${z}AWLEN    awlen    Output 4           $instance_name aw_len       
        fpga_interfaces::add_interface_port $iface_name  ${z}AWSIZE   awsize   Output 3           $instance_name aw_size      
        fpga_interfaces::add_interface_port $iface_name  ${z}AWBURST  awburst  Output 2           $instance_name aw_burst     
        fpga_interfaces::add_interface_port $iface_name  ${z}AWLOCK   awlock   Output 2           $instance_name aw_lock      
        fpga_interfaces::add_interface_port $iface_name  ${z}AWCACHE  awcache  Output 4           $instance_name aw_cache     
        fpga_interfaces::add_interface_port $iface_name  ${z}AWPROT   awprot   Output 3           $instance_name aw_prot      
        fpga_interfaces::add_interface_port $iface_name  ${z}AWVALID  awvalid  Output 1           $instance_name aw_valid     
        fpga_interfaces::add_interface_port $iface_name  ${z}AWREADY  awready  Input  1           $instance_name aw_ready     
        fpga_interfaces::add_interface_port $iface_name  ${z}AWUSER   awuser   Output 5           $instance_name aw_user      
                                                                                                                             
        fpga_interfaces::add_interface_port $iface_name  ${z}WID      wid      Output $id_width   $instance_name w_id         
        fpga_interfaces::add_interface_port $iface_name  ${z}WDATA    wdata    Output $data_width $instance_name w_data       
        fpga_interfaces::add_interface_port $iface_name  ${z}WSTRB    wstrb    Output $strb_width $instance_name w_strb       
        fpga_interfaces::add_interface_port $iface_name  ${z}WLAST    wlast    Output 1           $instance_name w_last       
        fpga_interfaces::add_interface_port $iface_name  ${z}WVALID   wvalid   Output 1           $instance_name w_valid      
        fpga_interfaces::add_interface_port $iface_name  ${z}WREADY   wready   Input  1           $instance_name w_ready      
                                                                                                                             
        fpga_interfaces::add_interface_port $iface_name  ${z}BID      bid      Input  $id_width   $instance_name b_id         
        fpga_interfaces::add_interface_port $iface_name  ${z}BRESP    bresp    Input  2           $instance_name b_resp       
        fpga_interfaces::add_interface_port $iface_name  ${z}BVALID   bvalid   Input  1           $instance_name b_valid      
        fpga_interfaces::add_interface_port $iface_name  ${z}BREADY   bready   Output 1           $instance_name b_ready      
                                                                                                                             
        fpga_interfaces::add_interface_port $iface_name  ${z}ARID     arid     Output $id_width   $instance_name ar_id        
        fpga_interfaces::add_interface_port $iface_name  ${z}ARADDR   araddr   Output $addr_width $instance_name ar_addr      
        fpga_interfaces::add_interface_port $iface_name  ${z}ARLEN    arlen    Output 4           $instance_name ar_len       
        fpga_interfaces::add_interface_port $iface_name  ${z}ARSIZE   arsize   Output 3           $instance_name ar_size      
        fpga_interfaces::add_interface_port $iface_name  ${z}ARBURST  arburst  Output 2           $instance_name ar_burst     
        fpga_interfaces::add_interface_port $iface_name  ${z}ARLOCK   arlock   Output 2           $instance_name ar_lock      
        fpga_interfaces::add_interface_port $iface_name  ${z}ARCACHE  arcache  Output 4           $instance_name ar_cache     
        fpga_interfaces::add_interface_port $iface_name  ${z}ARPROT   arprot   Output 3           $instance_name ar_prot      
        fpga_interfaces::add_interface_port $iface_name  ${z}ARVALID  arvalid  Output 1           $instance_name ar_valid     
        fpga_interfaces::add_interface_port $iface_name  ${z}ARREADY  arready  Input  1           $instance_name ar_ready     
        fpga_interfaces::add_interface_port  $iface_name ${z}ARUSER   aruser   Output 5           $instance_name ar_user      
                                                                                                                             
        fpga_interfaces::add_interface_port $iface_name  ${z}RID      rid      Input  $id_width   $instance_name r_id         
        fpga_interfaces::add_interface_port $iface_name  ${z}RDATA    rdata    Input  $data_width $instance_name r_data       
        fpga_interfaces::add_interface_port $iface_name  ${z}RRESP    rresp    Input  2           $instance_name r_resp       
        fpga_interfaces::add_interface_port $iface_name  ${z}RLAST    rlast    Input  1           $instance_name r_last       
        fpga_interfaces::add_interface_port $iface_name  ${z}RVALID   rvalid   Input  1           $instance_name r_valid      
        fpga_interfaces::add_interface_port $iface_name  ${z}RREADY   rready   Output 1           $instance_name r_ready      

    }

    if {$enable_ready_latency} {
        set termination_value [lreplace $termination_value 3 3 1]
    } else {
        set termination_value [lreplace $termination_value 3 3 0]
    }

    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_0" 1 0  0:0 [lindex $termination_value 0]
    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_1" 1 0  0:0 [lindex $termination_value 1]
    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_2" 1 0  0:0 [lindex $termination_value 2]
    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_3" 1 0  0:0 [lindex $termination_value 3]
}

proc elab_LWH2F {device_family} {
    set instance_name  hps2fpga_light_weight
    set wys_atom_name  twentynm_hps_rl_interface_hps2fpga_light_weight
    set termination_value { 1 0 }

    set lwh2f_en [get_parameter_value LWH2F_Enable]

    set enable_ready_latency 0
    if {$lwh2f_en > 1} {
        set enable_ready_latency 1
    }
    fpga_interfaces::add_module_instance $instance_name $wys_atom_name 

    if {$lwh2f_en > 0} {
        set addr_width 32
        set data_width 32
        set strb_width 4
        set id_width   4
        set clock_name "h2f_lw_axi_clock"

        set clk_wire [fpga_interfaces::allocate_wire]
        fpga_interfaces::add_interface      $clock_name  clock           Input
        fpga_interfaces::add_interface_port $clock_name  h2f_lw_axi_clk  clk Input 1
        fpga_interfaces::set_port_fragments $clock_name  h2f_lw_axi_clk  [fpga_interfaces::wire_tofragment $clk_wire]

        fpga_interfaces::set_instance_parameter $instance_name DWIDTH $data_width
        
        foreach port_name { clk w_clk b_clk ar_clk r_clk aw_clk } {
            set port_wire [fpga_interfaces::allocate_wire] ;# set wire simulation rendering later
            fpga_interfaces::set_wire_port_fragments $port_wire drives "${instance_name}:${port_name}(0:0)"
            fpga_interfaces::hookup_wires $port_wire $clk_wire
        }

        if {$enable_ready_latency} {
            set reset_name "h2f_lw_axi_reset"
            fpga_interfaces::add_interface           $reset_name reset Input
            fpga_interfaces::add_interface_port      $reset_name h2f_lw_axi_rst  reset_n Input 1 $instance_name rst_n
            fpga_interfaces::set_interface_property  $reset_name associatedClock $clock_name
        } else {
            set reset_name "h2f_reset"
            fpga_interfaces::set_instance_port_termination ${instance_name} "rst_n" 1 1  0:0 1
        }
        
        set iface_name "h2f_lw_axi_master"
        set z "h2f_lw_"
        fpga_interfaces::add_interface               $iface_name axi master
        fpga_interfaces::set_interface_property      $iface_name associatedClock $clock_name
        fpga_interfaces::set_interface_property      $iface_name associatedReset $reset_name
        fpga_interfaces::set_interface_property      $iface_name readIssuingCapability 8
        fpga_interfaces::set_interface_property      $iface_name writeIssuingCapability 8
        fpga_interfaces::set_interface_property      $iface_name combinedIssuingCapability 16
        fpga_interfaces::set_interface_meta_property $iface_name data_width $data_width
        fpga_interfaces::set_interface_meta_property $iface_name address_width $addr_width
        fpga_interfaces::set_interface_meta_property $iface_name id_width $id_width

        fpga_interfaces::add_interface_port $iface_name  ${z}AWID     awid     Output $id_width   $instance_name aw_id     
        fpga_interfaces::add_interface_port $iface_name  ${z}AWADDR   awaddr   Output $addr_width $instance_name aw_addr   
        fpga_interfaces::add_interface_port $iface_name  ${z}AWLEN    awlen    Output 4           $instance_name aw_len    
        fpga_interfaces::add_interface_port $iface_name  ${z}AWSIZE   awsize   Output 3           $instance_name aw_size   
        fpga_interfaces::add_interface_port $iface_name  ${z}AWBURST  awburst  Output 2           $instance_name aw_burst  
        fpga_interfaces::add_interface_port $iface_name  ${z}AWLOCK   awlock   Output 2           $instance_name aw_lock   
        fpga_interfaces::add_interface_port $iface_name  ${z}AWCACHE  awcache  Output 4           $instance_name aw_cache  
        fpga_interfaces::add_interface_port $iface_name  ${z}AWPROT   awprot   Output 3           $instance_name aw_prot   
        fpga_interfaces::add_interface_port $iface_name  ${z}AWVALID  awvalid  Output 1           $instance_name aw_valid  
        fpga_interfaces::add_interface_port $iface_name  ${z}AWREADY  awready  Input  1           $instance_name aw_ready  
        fpga_interfaces::add_interface_port $iface_name  ${z}AWUSER   awuser   Output 5           $instance_name aw_user   
                                                                                                                          
        fpga_interfaces::add_interface_port $iface_name  ${z}WID      wid      Output $id_width   $instance_name w_id      
        fpga_interfaces::add_interface_port $iface_name  ${z}WDATA    wdata    Output $data_width $instance_name w_data    
        fpga_interfaces::add_interface_port $iface_name  ${z}WSTRB    wstrb    Output $strb_width $instance_name w_strb    
        fpga_interfaces::add_interface_port $iface_name  ${z}WLAST    wlast    Output 1           $instance_name w_last    
        fpga_interfaces::add_interface_port $iface_name  ${z}WVALID   wvalid   Output 1           $instance_name w_valid   
        fpga_interfaces::add_interface_port $iface_name  ${z}WREADY   wready   Input  1           $instance_name w_ready   
                                                                                                                          
        fpga_interfaces::add_interface_port $iface_name  ${z}BID      bid      Input  $id_width   $instance_name b_id      
        fpga_interfaces::add_interface_port $iface_name  ${z}BRESP    bresp    Input  2           $instance_name b_resp    
        fpga_interfaces::add_interface_port $iface_name  ${z}BVALID   bvalid   Input  1           $instance_name b_valid   
        fpga_interfaces::add_interface_port $iface_name  ${z}BREADY   bready   Output 1           $instance_name b_ready   
                                                                                                                          
        fpga_interfaces::add_interface_port $iface_name  ${z}ARID     arid     Output $id_width   $instance_name ar_id     
        fpga_interfaces::add_interface_port $iface_name  ${z}ARADDR   araddr   Output $addr_width $instance_name ar_addr   
        fpga_interfaces::add_interface_port $iface_name  ${z}ARLEN    arlen    Output 4           $instance_name ar_len    
        fpga_interfaces::add_interface_port $iface_name  ${z}ARSIZE   arsize   Output 3           $instance_name ar_size   
        fpga_interfaces::add_interface_port $iface_name  ${z}ARBURST  arburst  Output 2           $instance_name ar_burst  
        fpga_interfaces::add_interface_port $iface_name  ${z}ARLOCK   arlock   Output 2           $instance_name ar_lock   
        fpga_interfaces::add_interface_port $iface_name  ${z}ARCACHE  arcache  Output 4           $instance_name ar_cache  
        fpga_interfaces::add_interface_port $iface_name  ${z}ARPROT   arprot   Output 3           $instance_name ar_prot   
        fpga_interfaces::add_interface_port $iface_name  ${z}ARVALID  arvalid  Output 1           $instance_name ar_valid  
        fpga_interfaces::add_interface_port $iface_name  ${z}ARREADY  arready  Input  1           $instance_name ar_ready  
        fpga_interfaces::add_interface_port  $iface_name ${z}ARUSER   aruser   Output 5           $instance_name ar_user   
                                                                                                                          
        fpga_interfaces::add_interface_port $iface_name  ${z}RID      rid      Input  $id_width   $instance_name r_id      
        fpga_interfaces::add_interface_port $iface_name  ${z}RDATA    rdata    Input  $data_width $instance_name r_data    
        fpga_interfaces::add_interface_port $iface_name  ${z}RRESP    rresp    Input  2           $instance_name r_resp    
        fpga_interfaces::add_interface_port $iface_name  ${z}RLAST    rlast    Input  1           $instance_name r_last    
        fpga_interfaces::add_interface_port $iface_name  ${z}RVALID   rvalid   Input  1           $instance_name r_valid   
        fpga_interfaces::add_interface_port $iface_name  ${z}RREADY   rready   Output 1           $instance_name r_ready   
    }

    if {$enable_ready_latency} {
        set termination_value [lreplace $termination_value 1 1 1]
    } else {
        set termination_value [lreplace $termination_value 1 1 0]
    }

    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_0" 1 0  0:0 [lindex $termination_value 0]
    fpga_interfaces::set_instance_port_termination ${instance_name} "port_size_config_1" 1 0  0:0 [lindex $termination_value 1]
}

proc elab_F2SDRAM {device_family} {

    set instance_name  "f2sdram"
    set wys_instance_created 0
    set address_width [get_parameter_value F2SDRAM_ADDRESS_WIDTH]

    foreach n { 0 1 2 } {

        set width   [ get_parameter_value F2SDRAM${n}_Width ]

        set enable_ready_latency 0
        if {$width > 3} {
            set enable_ready_latency 1
        }
    
        if {$width > 0} {
            if { $wys_instance_created == 0} { 
                fpga_interfaces::add_module_instance $instance_name fourteennm_hps_interface_fpga2sdram 
                set wys_instance_created 1
            }
            
            set data_width 32
            set strb_width 4
            set termination_value 0
    
            
            if {$width == 2 || $width == 5} {
                set data_width 64
                set strb_width 8
                set termination_value 1
            } elseif {$width == 3 || $width == 6} {
                set data_width 128
                set strb_width 16
                set termination_value 2
            }
            send_message warning "Generated F2SDRAM RTL code for port width is not ready for production."
            fpga_interfaces::set_instance_parameter $instance_name DWIDTH${n} $data_width
            
            F2SDRAM_wires   $instance_name $n $data_width $strb_width $enable_ready_latency $address_width
            
            if {$enable_ready_latency} {
                set termination_value [expr $termination_value + 8 ]
            }  
        
            fpga_interfaces::set_instance_port_termination $instance_name "FPGA2SDRAM${n}_PORT_SIZE_CONFIG" 4 1  3:0 $termination_value

        }
    }
    
 
}

proc F2SDRAM_wires {instance_name x dw aw ready_latency_enabled  address_width} {

    set clock_name "f2sdram${x}_clock"
    set clk_wire [fpga_interfaces::allocate_wire]
    fpga_interfaces::add_interface      $clock_name  clock                  Input
    fpga_interfaces::add_interface_port $clock_name  "f2sdram${x}_clk"      clk Input 1
    fpga_interfaces::set_port_fragments $clock_name  "f2sdram${x}_clk"     [fpga_interfaces::wire_tofragment $clk_wire]

    foreach port_name { clk w_clk b_clk ar_clk r_clk aw_clk } {
        set port_wire [fpga_interfaces::allocate_wire] ;
        fpga_interfaces::set_wire_port_fragments $port_wire drives "${instance_name}:f2s_sdram${x}_${port_name}(0:0)"
        fpga_interfaces::hookup_wires  $port_wire $clk_wire
    }
    
    if {$ready_latency_enabled} {
        set reset_name "f2sdram${x}_reset"
        fpga_interfaces::add_interface           $reset_name reset Input
        fpga_interfaces::add_interface_port      $reset_name "f2s_sdram${x}_rst"  reset_n Input 1 $instance_name "f2s_sdram${x}_rst_n"
        fpga_interfaces::set_interface_property  $reset_name associatedClock $clock_name
    } else {
        set reset_name "h2f_reset"
        fpga_interfaces::set_instance_port_termination $instance_name "f2s_sdram${x}_rst_n" 1 0  0:0 1
    }
    
    set iface_name "f2sdram${x}_data"
    set z          "f2sdram${x}_"
        
    fpga_interfaces::add_interface               $iface_name axi slave
    fpga_interfaces::set_interface_property      $iface_name associatedClock $clock_name
    fpga_interfaces::set_interface_property      $iface_name associatedReset $reset_name
    fpga_interfaces::set_interface_property      $iface_name readAcceptanceCapability     8
    fpga_interfaces::set_interface_property      $iface_name writeAcceptanceCapability    8
    fpga_interfaces::set_interface_property      $iface_name combinedAcceptanceCapability 16
    fpga_interfaces::set_interface_meta_property $iface_name data_width    $dw
    fpga_interfaces::set_interface_meta_property $iface_name address_width $address_width
    fpga_interfaces::set_interface_meta_property $iface_name bfm_type      f2sdram


    fpga_interfaces::add_interface_port $iface_name ${z}ARADDR     araddr   input      $address_width $instance_name fpga2sdram${x}_ar_addr
    fpga_interfaces::add_interface_port $iface_name ${z}ARBURST    arburst  input      2 $instance_name fpga2sdram${x}_ar_burst
    fpga_interfaces::add_interface_port $iface_name ${z}ARCACHE    arcache  input      4 $instance_name fpga2sdram${x}_ar_cache
    fpga_interfaces::add_interface_port $iface_name ${z}ARID       arid     input      4 $instance_name fpga2sdram${x}_ar_id
    fpga_interfaces::add_interface_port $iface_name ${z}ARLEN      arlen    input      4 $instance_name fpga2sdram${x}_ar_len
    fpga_interfaces::add_interface_port $iface_name ${z}ARLOCK     arlock   input      2 $instance_name fpga2sdram${x}_ar_lock
    fpga_interfaces::add_interface_port $iface_name ${z}ARPROT     arprot   input      3 $instance_name fpga2sdram${x}_ar_prot
    fpga_interfaces::add_interface_port $iface_name ${z}ARREADY    arready  output     1 $instance_name fpga2sdram${x}_ar_ready
    fpga_interfaces::add_interface_port $iface_name ${z}ARSIZE     arsize   input      3 $instance_name fpga2sdram${x}_ar_size
    fpga_interfaces::add_interface_port $iface_name ${z}ARUSER     aruser   input      5 $instance_name fpga2sdram${x}_ar_user
    fpga_interfaces::add_interface_port $iface_name ${z}ARVALID    arvalid  input      1 $instance_name fpga2sdram${x}_ar_valid
    fpga_interfaces::add_interface_port $iface_name ${z}AWADDR     awaddr   input      $address_width $instance_name fpga2sdram${x}_aw_addr
    fpga_interfaces::add_interface_port $iface_name ${z}AWBURST    awburst  input      2 $instance_name fpga2sdram${x}_aw_burst
    fpga_interfaces::add_interface_port $iface_name ${z}AWCACHE    awcache  input      4 $instance_name fpga2sdram${x}_aw_cache
    fpga_interfaces::add_interface_port $iface_name ${z}AWID       awid     input      4 $instance_name fpga2sdram${x}_aw_id
    fpga_interfaces::add_interface_port $iface_name ${z}AWLEN      awlen    input      4 $instance_name fpga2sdram${x}_aw_len
    fpga_interfaces::add_interface_port $iface_name ${z}AWLOCK     awlock   input      2 $instance_name fpga2sdram${x}_aw_lock
    fpga_interfaces::add_interface_port $iface_name ${z}AWPROT     awprot   input      3 $instance_name fpga2sdram${x}_aw_prot
    fpga_interfaces::add_interface_port $iface_name ${z}AWREADY    awready  output     1 $instance_name fpga2sdram${x}_aw_ready
    fpga_interfaces::add_interface_port $iface_name ${z}AWSIZE     awsize   input      3 $instance_name fpga2sdram${x}_aw_size
    fpga_interfaces::add_interface_port $iface_name ${z}AWUSER     awuser   input      5 $instance_name fpga2sdram${x}_aw_user
    fpga_interfaces::add_interface_port $iface_name ${z}AWVALID    awvalid  input      1 $instance_name fpga2sdram${x}_aw_valid
    fpga_interfaces::add_interface_port $iface_name ${z}WDATA      wdata    input    $dw $instance_name fpga2sdram${x}_w_data
    fpga_interfaces::add_interface_port $iface_name ${z}WID        wid      input      4 $instance_name fpga2sdram${x}_w_id
    fpga_interfaces::add_interface_port $iface_name ${z}WLAST      wlast    input      1 $instance_name fpga2sdram${x}_w_last
    fpga_interfaces::add_interface_port $iface_name ${z}WREADY     wready   output     1 $instance_name fpga2sdram${x}_w_ready
    fpga_interfaces::add_interface_port $iface_name ${z}WSTRB      wstrb    input    $aw $instance_name fpga2sdram${x}_w_strb
    fpga_interfaces::add_interface_port $iface_name ${z}WVALID     wvalid   input      1 $instance_name fpga2sdram${x}_w_valid
    fpga_interfaces::add_interface_port $iface_name ${z}BID        bid      output     4 $instance_name fpga2sdram${x}_b_id
    fpga_interfaces::add_interface_port $iface_name ${z}BREADY     bready   input      1 $instance_name fpga2sdram${x}_b_ready
    fpga_interfaces::add_interface_port $iface_name ${z}BRESP      bresp    output     2 $instance_name fpga2sdram${x}_b_resp
    fpga_interfaces::add_interface_port $iface_name ${z}BVALID     bvalid   output     1 $instance_name fpga2sdram${x}_b_valid
    fpga_interfaces::add_interface_port $iface_name ${z}RDATA      rdata    output   $dw $instance_name fpga2sdram${x}_r_data
    fpga_interfaces::add_interface_port $iface_name ${z}RID        rid      output     4 $instance_name fpga2sdram${x}_r_id
    fpga_interfaces::add_interface_port $iface_name ${z}RLAST      rlast    output     1 $instance_name fpga2sdram${x}_r_last
    fpga_interfaces::add_interface_port $iface_name ${z}RREADY     rready   input      1 $instance_name fpga2sdram${x}_r_ready
    fpga_interfaces::add_interface_port $iface_name ${z}RRESP      rresp    output     2 $instance_name fpga2sdram${x}_r_resp
    fpga_interfaces::add_interface_port $iface_name ${z}RVALID     rvalid   output     1 $instance_name fpga2sdram${x}_r_valid
}


