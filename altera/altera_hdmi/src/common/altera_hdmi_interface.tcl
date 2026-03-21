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
# | Add Common interface
# | 

proc add_hdmi_export_interface { dir } {

	#add_rst_bridge ""
	common_add_optional_conduit reset export input 1 true
  common_add_optional_conduit vid_clk export input 1 true
  
#  if { $dir == "tx" } {
  
#    add_hdmi_tx_export_interface
    
#  }
  
#  if { $dir == "rx" } {
  
#    add_hdmi_rx_export_interface
    
#  } 
  
}

# +-----------------------------------
# | Add Tx interface
# | 

proc add_hdmi_tx_interface {symbols_per_clock} {

  set support_aux [get_parameter_value SUPPORT_AUXILIARY]
  set support_audio [get_parameter_value SUPPORT_AUDIO]
  
  common_add_optional_conduit ls_clk export input 1 true
  common_add_optional_conduit mode export input 1 true
  
  # Video data port
  common_add_optional_conduit vid_de export input 1*symbols_per_clock true
  common_add_optional_conduit vid_data export input 48*symbols_per_clock true
  common_add_optional_conduit vid_hsync export input 1*symbols_per_clock true
  common_add_optional_conduit vid_vsync export input 1*symbols_per_clock true

  # TMDS data
  common_add_optional_conduit out_b export output 10*symbols_per_clock true
  common_add_optional_conduit out_r export output 10*symbols_per_clock  true
  common_add_optional_conduit out_g export output 10*symbols_per_clock  true
  common_add_optional_conduit out_c export output 10*symbols_per_clock  true
  
  # Auxiliary Data Port
  # Need to depend on SUPPORT_AUXILIARY parameter
  common_add_optional_conduit	aux_ready export output 1   true
  common_add_optional_conduit	aux_valid export input  1   true
  common_add_optional_conduit	aux_data 	export input  72  true
  common_add_optional_conduit	aux_sop 	export input  1   true
  common_add_optional_conduit	aux_eop 	export input  1   true
  
  if { $support_aux == 0} {
    set_port_property aux_ready termination true
    set_port_property aux_valid termination true
    set_port_property aux_data termination true
    set_port_property aux_sop termination true
    set_port_property aux_eop termination true
  }
  
  # Auxiliary Control Port
  # Need to depend on SUPPORT_AUXILIARY parameter
  common_add_optional_conduit gcp               export input 6    true
  common_add_optional_conduit info_avi          export input 113  true
  common_add_optional_conduit info_vsi          export input 62   true
  
  if { $support_aux == 0} {
    set_port_property gcp termination true
    set_port_property info_avi termination true
    set_port_property info_vsi termination true
  }
  
  # Audio Port
  # Need to depend on SUPPORT_AUDIO parameter
  common_add_clock audio_clk input true
  common_add_optional_conduit  audio_CTS      export input 20   true
  common_add_optional_conduit  audio_N        export input 20   true  
  common_add_optional_conduit  audio_data     export input 256   true
  common_add_optional_conduit  audio_de       export input 1    true
  common_add_optional_conduit  audio_mute     export input 1    true
  common_add_optional_conduit  audio_info_ai  export input 49   true
  common_add_optional_conduit  audio_metadata export input 166   true
  common_add_optional_conduit  audio_format   export input 5   true
  
  if { $support_audio == 0} {
    set_port_property audio_clk termination true
    set_port_property audio_CTS termination true
    set_port_property audio_N termination true
    set_port_property audio_data termination true
    set_port_property audio_de termination true
    set_port_property audio_mute termination true
    set_port_property audio_info_ai termination true
    set_port_property audio_metadata termination true
    set_port_property audio_format termination true
  }
  
  # HDMI 2.0 SSDC Port
  
  # `define INCLUDE_SSDC is always enabled in the core
  common_add_optional_conduit  Scrambler_Enable       export input 1   true
  common_add_optional_conduit  TMDS_Bit_clock_Ratio   export input 1   true
  common_add_optional_conduit  version                export output 32   true

  common_add_optional_conduit  ctrl  export input     6*symbols_per_clock   true

  set_port_property version termination true
  
   #HDCP Ports is always enabled in Bitec level but terminated in the wrapper
  common_add_optional_conduit  AKeys      export input 56 true
  common_add_optional_conduit  AKeys_sel  export output 7 true
  common_add_optional_conduit  AKeys_ksv  export input 40 true
  
  common_add_clock hdcp_mm_clk input true
  common_add_optional_conduit  hdcp_mm_addr     export input  8 true
  common_add_optional_conduit  hdcp_mm_rdata    export output 32 true
  common_add_optional_conduit  hdcp_mm_wdata    export input  32 true
  common_add_optional_conduit  hdcp_mm_r        export input  1 true
  common_add_optional_conduit  hdcp_mm_w        export input  1 true
  
  common_add_optional_conduit  hdcp_enable  export input  1 true
  common_add_optional_conduit  rsa_clk      export input  1 true
  common_add_optional_conduit  hdcp_mm_wait export output 1 true
  
  common_add_optional_conduit  hdcp_kmem_dat export	 input  32 true
  common_add_optional_conduit  hdcp_kmem_add export	 output 7  true
  common_add_optional_conduit  hdcp_kmem_rd export	 output 1  true
  common_add_optional_conduit  hdcp_kmem_wait export input  1  true
  
  set_port_property AKeys termination true
  set_port_property AKeys_sel termination true
  set_port_property AKeys_ksv termination true
  set_port_property hdcp_mm_clk termination true
  set_port_property hdcp_mm_addr termination true
  set_port_property hdcp_mm_rdata termination true
  set_port_property hdcp_mm_wdata termination true
  set_port_property hdcp_mm_r termination true
  set_port_property hdcp_mm_w termination true
  set_port_property hdcp_enable termination true
  set_port_property rsa_clk termination true
  set_port_property hdcp_mm_wait termination true
  set_port_property hdcp_kmem_dat termination true
  set_port_property hdcp_kmem_add termination true
  set_port_property hdcp_kmem_rd termination true
  set_port_property hdcp_kmem_wait termination true
  
  
  
}

# +-----------------------------------
# | Add Rx interface
# | 

proc add_hdmi_rx_interface {symbols_per_clock} {

  set support_aux [get_parameter_value SUPPORT_AUXILIARY]
  set support_audio [get_parameter_value SUPPORT_AUDIO]

  
  common_add_optional_conduit  ls_clk  export input  3                    true
  common_add_optional_conduit  locked  export output 3                    true
  common_add_optional_conduit  mode    export output 1                    true
  common_add_optional_conduit  ctrl    export output 6*symbols_per_clock  true
  
  # Video ports
  common_add_optional_conduit vid_lock  export output 1                   true
  common_add_optional_conduit vid_de    export output 1*symbols_per_clock true
  common_add_optional_conduit vid_data  export output 48*symbols_per_clock true
  common_add_optional_conduit vid_hsync export output 1*symbols_per_clock true
  common_add_optional_conduit vid_vsync export output 1*symbols_per_clock true
  
  # TMDS data
  common_add_optional_conduit in_b      export input 10*symbols_per_clock true
  common_add_optional_conduit in_r      export input 10*symbols_per_clock true
  common_add_optional_conduit in_g      export input 10*symbols_per_clock true

  common_add_optional_conduit in_lock      export input 3 true
  
  # Auxiliary Data Port
  # Need to depend on SUPPORT_AUXILIARY parameter
  common_add_optional_conduit aux_valid export output  1  true
  common_add_optional_conduit aux_data  export output  72 true
  common_add_optional_conduit aux_sop   export output  1  true
  common_add_optional_conduit aux_eop   export output  1  true
  common_add_optional_conduit aux_error export output  1  true
  
  if { $support_aux == 0} {
    set_port_property aux_valid termination true
    set_port_property aux_data termination true
    set_port_property aux_sop termination true
    set_port_property aux_eop termination true
    set_port_property aux_error termination true
  }
  
  # Auxiliary Control Port
  # Need to depend on SUPPORT_AUXILIARY parameter
  common_add_optional_conduit gcp               export output 6    true
  common_add_optional_conduit info_avi          export output 112  true
  common_add_optional_conduit info_vsi          export output 61   true

  common_add_optional_conduit  aux_pkt_addr   export output 7   true
  common_add_optional_conduit  aux_pkt_data   export output 72  true
  common_add_optional_conduit  aux_pkt_wr     export output 1   true

  
  if { $support_aux == 0} {
    set_port_property gcp termination true
    set_port_property info_avi termination true
    set_port_property info_vsi termination true
    set_port_property aux_pkt_addr termination true
    set_port_property aux_pkt_data termination true
    set_port_property aux_pkt_wr termination true
  }
  
  # Audio Port
  # Need to depend on SUPPORT_AUDIO parameter
  common_add_optional_conduit  audio_CTS      export output 20  true
  common_add_optional_conduit  audio_N        export output 20  true
  common_add_optional_conduit  audio_data     export output 256 true
  common_add_optional_conduit  audio_de       export output 1   true
  common_add_optional_conduit  audio_info_ai  export output 48  true
  common_add_optional_conduit  audio_metadata export output 165 true
  common_add_optional_conduit  audio_format   export output 5   true
  
  if { $support_audio == 0} {
    set_port_property audio_CTS termination true
    set_port_property audio_N termination true
    set_port_property audio_data termination true
    set_port_property audio_de termination true
    set_port_property audio_info_ai termination true
    set_port_property audio_metadata termination true
    set_port_property audio_format termination true
  }

  
  
  # HDMI 2.0 SSDC Port
  # `define INCLUDE_SSDC is always enabled
  
  common_add_clock scdc_i2c_clk input true
  common_add_optional_conduit  scdc_i2c_addr         export input 8  true
  common_add_optional_conduit  scdc_i2c_wdata        export input 8  true
  common_add_optional_conduit  scdc_i2c_r            export input 1  true
  common_add_optional_conduit  scdc_i2c_w            export input 1  true
  common_add_optional_conduit  scdc_i2c_rdata        export output 8 true
  common_add_optional_conduit  TMDS_Bit_clock_Ratio  export output 1 true
  common_add_optional_conduit  version               export output 32 true
  common_add_optional_conduit  raw_data              export output 30*symbols_per_clock true
  set_port_property version  termination true
  set_port_property raw_data termination true
  
  common_add_optional_conduit  in_5v_power  export input 1 true
  common_add_optional_conduit  in_hpd       export input 1 true
  common_add_optional_conduit  err_count_b  export output 16 true
  common_add_optional_conduit  err_count_g  export output 16 true
  common_add_optional_conduit  err_count_r  export output 16 true
  set_port_property err_count_b termination true
  set_port_property err_count_g termination true
  set_port_property err_count_r termination true
  
  #HDCP Ports
  # HDCP ports are always enabled in the Bitec level but terminated at Altera wrapper
  common_add_optional_conduit  BKeys      export input 56 true
  common_add_optional_conduit  BKeys_sel  export output 7 true
  common_add_optional_conduit  BKeys_ksv  export input 40 true
  
  common_add_clock hdcp_i2c_clk input true
  common_add_optional_conduit  hdcp_i2c_addr  export input  8 true
  common_add_optional_conduit  hdcp_i2c_rdata export output 8 true
  common_add_optional_conduit  hdcp_i2c_wdata export input  8 true
  common_add_optional_conduit  hdcp_i2c_r     export input  1 true
  common_add_optional_conduit  hdcp_i2c_w     export input  1 true
  common_add_optional_conduit  hdcp1_enable   export output 1 true
  common_add_optional_conduit  rsa_clk        export input  1 true
  common_add_optional_conduit  rsa_dat        export input 32 true
  common_add_optional_conduit  rsa_add        export output 8 true
  common_add_optional_conduit  rsa_rd         export output 1 true
  common_add_optional_conduit  rsa_wait       export input 1 true
  common_add_optional_conduit  hdcp2_enable   export output 1 true
  common_add_optional_conduit  hdcp2_dbg_clk  export output 1 true
  common_add_optional_conduit  hdcp2_dbg_msg_id   export output 8 true
  common_add_optional_conduit  hdcp2_dbg_msg_data export output 8 true
  common_add_optional_conduit  hdcp2_dbg_valid    export output 1 true
  common_add_optional_conduit  hdcp2_dbg_flush    export output 1 true
  common_add_optional_conduit  hdcp_i2c_w_som     export input  1 true
  common_add_optional_conduit  hdcp_i2c_wait      export output 1 true
  common_add_optional_conduit  hdcp1_auth         export output 1 true
  common_add_optional_conduit  hdcp2_auth         export output 1 true
  common_add_optional_conduit  hdcp_kmem_dat 	  export input  64 true
  common_add_optional_conduit  hdcp_kmem_add	  export output 15 true
  common_add_optional_conduit  hdcp_kmem_rd       export output 2  true
  common_add_optional_conduit  hdcp_kmem_wait     export input  2  true
  
  set_port_property BKeys termination true
  set_port_property BKeys_sel termination true
  set_port_property BKeys_ksv termination true
  set_port_property hdcp_i2c_clk termination true
  set_port_property hdcp_i2c_addr termination true
  set_port_property hdcp_i2c_rdata termination true
  set_port_property hdcp_i2c_wdata termination true
  set_port_property hdcp_i2c_r termination true
  set_port_property hdcp_i2c_w termination true
  set_port_property hdcp1_enable termination true
  set_port_property rsa_clk termination true
  set_port_property rsa_dat termination true
  set_port_property rsa_add termination true
  set_port_property rsa_rd termination true
  set_port_property rsa_wait termination true
  set_port_property hdcp2_enable termination true
  set_port_property hdcp2_dbg_clk termination true
  set_port_property hdcp2_dbg_msg_id termination true
  set_port_property hdcp2_dbg_msg_data termination true
  set_port_property hdcp2_dbg_valid termination true
  set_port_property hdcp2_dbg_flush termination true
  set_port_property hdcp_i2c_w_som termination true
  set_port_property hdcp_i2c_wait termination true
  set_port_property hdcp1_auth termination true
  set_port_property hdcp2_auth termination true
  set_port_property hdcp_kmem_dat termination true
  set_port_property hdcp_kmem_add termination true
  set_port_property hdcp_kmem_rd termination true
  set_port_property hdcp_kmem_wait termination true
  

}

# +-----------------------------------
# | Add Tx Export interface
# | 

proc add_hdmi_tx_export_interface { instance} {

  set support_aux [get_parameter_value SUPPORT_AUXILIARY]
  set support_audio [get_parameter_value SUPPORT_AUDIO]

  add_export_interface $instance ls_clk conduit input  
  add_export_interface $instance reset conduit input  
  add_export_interface $instance vid_clk conduit input  
  
  add_export_interface $instance mode conduit input  

  # Video data port
  add_export_interface $instance vid_de conduit input
  add_export_interface $instance vid_data conduit input
  add_export_interface $instance vid_hsync conduit input
  add_export_interface $instance vid_vsync conduit input
  
  # TMDS data  
  add_export_interface $instance out_b conduit output
  add_export_interface $instance out_r conduit output
  add_export_interface $instance out_g conduit output
  add_export_interface $instance out_c conduit output
  
  # Auxiliary Data Port
	# Need to depend on SUPPORT_AUXILIARY parameter
  if { $support_aux} {
    add_export_interface $instance aux_ready  conduit output
    add_export_interface $instance aux_valid  conduit input
    add_export_interface $instance aux_data   conduit input
    add_export_interface $instance aux_sop    conduit input
    add_export_interface $instance aux_eop    conduit input
    
    # Auxiliary Control Port
    # Need to depend on SUPPORT_AUXILIARY parameter
    add_export_interface $instance gcp                conduit output
    add_export_interface $instance info_avi           conduit input
    add_export_interface $instance info_vsi           conduit input
  }
  
  # Audio Port
  # Need to depend on SUPPORT_AUDIO parameter
  if { $support_audio} {
    add_export_interface $instance audio_clk      clock   input
    add_export_interface $instance audio_CTS      conduit input
    add_export_interface $instance audio_N        conduit input
    add_export_interface $instance audio_data     conduit input
    add_export_interface $instance audio_de       conduit input
    add_export_interface $instance audio_mute     conduit input
    add_export_interface $instance audio_info_ai  conduit input
    add_export_interface $instance audio_metadata conduit input
    add_export_interface $instance audio_format   conduit input
  }
  
  add_export_interface $instance ctrl           conduit input
  
  # HDMI 2.0 SSDC Port

  # `define INCLUDE_SSDC is always enabled
  add_export_interface $instance Scrambler_Enable       conduit input
  add_export_interface $instance TMDS_Bit_clock_Ratio   conduit input
  #add_export_interface $instance version                conduit output
  
}

#|
#|
# +-----------------------------------

# +-----------------------------------
# | Add Rx Export interface
# | 

proc add_hdmi_rx_export_interface { instance } {

  set support_aux [get_parameter_value SUPPORT_AUXILIARY]
  set support_audio [get_parameter_value SUPPORT_AUDIO]

  add_export_interface $instance ls_clk      conduit input
  add_export_interface $instance reset       conduit input
  add_export_interface $instance vid_clk     conduit input
  add_export_interface $instance locked      conduit output
  add_export_interface $instance ctrl        conduit output
  add_export_interface $instance mode        conduit output
  
  add_export_interface $instance in_5v_power  conduit input
  add_export_interface $instance in_hpd       conduit input
  
  # Video ports
  add_export_interface $instance vid_lock     conduit output
  add_export_interface $instance vid_de       conduit output
  add_export_interface $instance vid_data     conduit output
  add_export_interface $instance vid_hsync    conduit output
  add_export_interface $instance vid_vsync    conduit output
  
  	# TMDS data
  add_export_interface $instance in_b      conduit input
  add_export_interface $instance in_r      conduit input
  add_export_interface $instance in_g      conduit input
  
  add_export_interface $instance in_lock      conduit input
  
  # Auxiliary Data Port
	# Need to depend on SUPPORT_AUXILIARY parameter
  if { $support_aux} {
    add_export_interface $instance aux_valid    conduit output
    add_export_interface $instance aux_data     conduit output
    add_export_interface $instance aux_sop      conduit output
    add_export_interface $instance aux_eop      conduit output
    add_export_interface $instance aux_error    conduit output
    
    # Auxiliary Control Port
    # Need to depend on SUPPORT_AUXILIARY parameter
    add_export_interface $instance gcp                conduit output
    add_export_interface $instance info_avi           conduit output
    add_export_interface $instance info_vsi           conduit output
    add_export_interface $instance aux_pkt_addr     conduit output
    add_export_interface $instance aux_pkt_data     conduit output
    add_export_interface $instance aux_pkt_wr       conduit output

  }
  
  # Audio Port
  # Need to depend on SUPPORT_AUDIO parameter
  if { $support_audio} {
    add_export_interface $instance audio_CTS        conduit output
    add_export_interface $instance audio_N          conduit output
    add_export_interface $instance audio_data       conduit output
    add_export_interface $instance audio_de         conduit output
    add_export_interface $instance audio_info_ai    conduit output
    add_export_interface $instance audio_metadata   conduit output
    add_export_interface $instance audio_format     conduit output
  }

  
  
  # HDMI 2.0 SSDC Port

  # Need to depend on `define INCLUDE_SSDC

  add_export_interface $instance scdc_i2c_clk          clock   input
  add_export_interface $instance scdc_i2c_addr         conduit input
  add_export_interface $instance scdc_i2c_wdata        conduit input
  add_export_interface $instance scdc_i2c_r            conduit input
  add_export_interface $instance scdc_i2c_w            conduit input
  add_export_interface $instance scdc_i2c_rdata        conduit output
  add_export_interface $instance TMDS_Bit_clock_Ratio  conduit output
  #add_export_interface $instance version               conduit output
  
  # Need to depend on `define INCLUDE_DATA_TAPS
  
  
  #add_export_interface $instance raw_data              conduit output
  
  
   #HDCP Ports
  # Need to determine how to control - parameter?
  #add_export_interface $instance BKeys      conduit input
  #add_export_interface $instance BKeys_sel  conduit output
  #add_export_interface $instance BKeys_ksv  conduit input
  
  #add_export_interface $instance hdcp_i2c_clk     clock   input
  #add_export_interface $instance hdcp_i2c_scl     conduit input
  #add_export_interface $instance hdcp_i2c_sda_in  conduit input
  #add_export_interface $instance hdcp_i2c_sda_out conduit output
  #add_export_interface $instance hdcp_i2c_sda_oe  conduit output
  

  

}
#|
#|
# +-----------------------------------




