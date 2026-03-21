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


#########################################
### request TCL package from ACDS
#########################################
package require -exact qsys 16.0
package require altera_tcl_testlib 1.0
package require -exact altera_terp 1.0

#########################################
### Source required procs
#########################################
source $env(QUARTUS_ROOTDIR)/../ip/altera/altera_jesd204/src/top/altera_jesd204_common_procs.tcl

##########################
# module altera_jesd204b
##########################
set_module_property NAME altera_jesd204_rx
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "JESD204B MegaCore Function"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/JESD"
set_module_property DISPLAY_NAME "JESD204B RX"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property HIDE_FROM_SOPC true

########################
# Declare the callbacks
######################## 
set_module_property ELABORATION_CALLBACK my_elaboration_callback

########################
# Add fileset
########################
add_fileset synth2 QUARTUS_SYNTH synthproc
add_fileset sim_verilog SIM_VERILOG verilogsimproc
add_fileset sim_vhdl SIM_VHDL vhdlsimproc

set_fileset_property synth2 TOP_LEVEL altera_jesd204_rx_base
set_fileset_property sim_verilog TOP_LEVEL altera_jesd204_rx_base
set_fileset_property sim_vhdl TOP_LEVEL altera_jesd204_rx_base


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../top/altera_jesd204_params.tcl
::altera_jesd204::gui_params::params_rx_hw

##############################################################
##           Elaboration Callback
##############################################################
#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------
proc my_elaboration_callback {} {
	set d_L [get_parameter_value "L"]

	common_add_clock                rxlink_clk              clock   input   1   std   true  0
	common_add_reset 		rxlink_rst_n 		input 	rxlink_clk 0	
	
	# Management Interface (AV-MM) for JESD204B RX
	common_add_clock 		jesd204_rx_avs_clk      clock   input   1   std   true  0
	common_add_reset 		jesd204_rx_avs_rst_n 	input 	                        jesd204_rx_avs_clk 0
	add_interface 	                jesd204_rx_avs	        avalon 		                end
	set_interface_property          jesd204_rx_avs          ASSOCIATED_CLOCK                jesd204_rx_avs_clk
	add_interface_port              jesd204_rx_avs          jesd204_rx_avs_chipselect 	chipselect 	Input 	1
	add_interface_port              jesd204_rx_avs          jesd204_rx_avs_address 		address 	Input 	8
	add_interface_port              jesd204_rx_avs          jesd204_rx_avs_read 		read 		Input 	1
	add_interface_port              jesd204_rx_avs          jesd204_rx_avs_readdata	        readdata 	Output 	32
	add_interface_port              jesd204_rx_avs          jesd204_rx_avs_waitrequest	waitrequest 	Output 	1
	add_interface_port              jesd204_rx_avs          jesd204_rx_avs_write 		write 		Input 	1
	add_interface_port              jesd204_rx_avs          jesd204_rx_avs_writedata	writedata 	Input 	32
	set_interface_property          jesd204_rx_avs          readLatency                 1

	#AV-ST Interface Signal(Source) for JESD204B RX
	add_interface 	                avst_rx        avalon_streaming             source
	set_interface_property          avst_rx        associatedClock              rxlink_clk
	set_interface_property          avst_rx        associatedReset              rxlink_rst_n
	set_interface_property          avst_rx        symbolsPerBeat               1
	set_interface_property          avst_rx        dataBitsPerSymbol            [ expr {$d_L*32} ]
	set_interface_property          avst_rx        errorDescriptor              ""
	set_interface_property          avst_rx        firstSymbolInHighOrderBits   true
	set_interface_property          avst_rx        maxChannel                   0
	set_interface_property          avst_rx        readyLatency                 0
	set_interface_property          avst_rx        ENABLED                      true
	add_interface_port              avst_rx        jesd204_rx_link_data      data    Output   32*$d_L
	add_interface_port              avst_rx        jesd204_rx_link_valid     valid   Output   1
	add_interface_port              avst_rx        jesd204_rx_link_ready     ready   Input    1

        #Non AV-ST Interface Signals
#       common_add_optional_conduit    { port_name   signal_type   port_dir   width  vhdl_type  used   terminate }  
	common_add_optional_conduit     sof                   export   output 4  vector true   0 
	common_add_optional_conduit     somf                  export   output 4  vector true   0 

	#JESD204 Specific Interface Signals
	common_add_optional_conduit 	alldev_lane_aligned   export   input  1   std  true  0 
	common_add_optional_conduit 	dev_lane_aligned      export   output 1   std  true  0 
        common_add_optional_conduit     dev_sync_n            export   output 1   std  true  0 
	common_add_optional_conduit 	sysref	              export   input  1   std  true  0 
        
	#OOB Signal
	add_interface           jesd204_rx_int       interrupt         sender
	set_interface_property  jesd204_rx_int       ASSOCIATED_CLOCK  jesd204_rx_avs_clk
	set_interface_property  jesd204_rx_int       associatedAddressablePoint  jesd204_rx_avs
        add_interface_port      jesd204_rx_int       jesd204_rx_int    irq  output 1   

        #Configurations and Status Signals
	common_add_optional_conduit     csr_rx_testmode          export   output 4     vector   true  0 
	common_add_optional_conduit 	csr_f 			 export   output 8     vector   true  0 
	common_add_optional_conduit 	csr_k 			 export   output 5     vector   true  0 
	common_add_optional_conduit 	csr_l 		         export   output 5     vector   true  0 
	common_add_optional_conduit 	csr_m 			 export   output 8     vector   true  0 
	common_add_optional_conduit 	csr_n 			 export   output 5     vector   true  0 
	common_add_optional_conduit 	csr_s 			 export   output 5     vector   true  0 
	common_add_optional_conduit 	csr_cf 			 export   output 5     vector   true  0 
	common_add_optional_conduit 	csr_cs 			 export   output 2     vector   true  0 
	common_add_optional_conduit 	csr_hd 			 export   output 1     std      true  0 
	common_add_optional_conduit 	csr_np 			 export   output 5     vector   true  0 
        common_add_optional_conduit 	csr_byte_reversal        export   output 1     std      true  0  
        common_add_optional_conduit 	csr_bit_reversal         export   output 1     std      true  0 
        common_add_optional_conduit 	csr_lane_polarity	 export   output $d_L  vector   true  0  
	common_add_optional_conduit     csr_lane_powerdown       export   output $d_L  vector   true  0 
	common_add_optional_conduit 	jesd204_rx_frame_error	 export   input  1     std      true  0 

	#PHY interfaces
	common_add_optional_conduit 	jesd204_rx_pcs_data 		export 	input  $d_L*32  vector  true  0         
	common_add_optional_conduit     jesd204_rx_pcs_data_valid	export 	input  $d_L     vector  true  0  
	common_add_optional_conduit     jesd204_rx_pcs_kchar_data       export 	input  $d_L*4   vector  true  0  
        common_add_optional_conduit 	jesd204_rx_pcs_errdetect        export  input  $d_L*4   vector  true  0  
	common_add_optional_conduit 	jesd204_rx_pcs_disperr   	export 	input  $d_L*4   vector  true  0 
	common_add_optional_conduit     patternalign_en                 export  output $d_L     vector  true  0 
	common_add_optional_conduit 	phy_csr_rx_pcfifo_empty	        export 	input  $d_L     vector  true  0  
        common_add_optional_conduit 	phy_csr_rx_pcfifo_full	        export 	input  $d_L     vector  true  0 
        common_add_optional_conduit     phy_csr_rx_cal_busy             rx_cal_busy         input  $d_L     vector  true  0 
	common_add_optional_conduit     phy_csr_rx_locked_to_data       rx_is_lockedtodata  input  $d_L     vector  true  0 

	# Test/Digital near-end loopback
	common_add_optional_conduit 	jesd204_rx_dlb_data 		export 	input $d_L*32  vector  true  0  
	common_add_optional_conduit     jesd204_rx_dlb_data_valid	export 	input $d_L     vector  true  0 
	common_add_optional_conduit     jesd204_rx_dlb_kchar_data       export 	input $d_L*4   vector  true  0 
        common_add_optional_conduit 	jesd204_rx_dlb_errdetect        export  input $d_L*4   vector  true  0 
	common_add_optional_conduit 	jesd204_rx_dlb_disperr   	export 	input $d_L*4   vector  true  0 

}

#------------------------------------------------------------------------
# 3. Fileset
#------------------------------------------------------------------------
global env
proc common_fileset {language gensim simulator} {
	global env
	set qdir $env(QUARTUS_ROOTDIR)
	set topdir "${qdir}/../ip/altera/altera_jesd204/src/top"
	set tmpdir "."
	
   if {[string compare -nocase ${simulator} synopsys] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "synopsys"
       set simulator_specific "SYNOPSYS_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} mentor] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "mentor"
       set simulator_specific "MENTOR_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} cadence] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "cadence"
       set simulator_specific "CADENCE_SPECIFIC"
   } elseif {[string compare -nocase ${simulator} aldec] == 0} {
       set filekind "VERILOG_ENCRYPT"
       set filekind_systemverilog "SYSTEM_VERILOG_ENCRYPT"
       set simulator_path "aldec"
       set simulator_specific "ALDEC_SPECIFIC"
   } else { 
       #for synthesis
       set filekind "VERILOG"
       set filekind_systemverilog "SYSTEMVERILOG"
       set simulator_path "."
       set simulator_specific ""
   } 

    # Top level - verilog file
    add_fileset_file ${simulator_path}/altera_jesd204_rx_base.v       $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_base.v $simulator_specific     
    
    # source files for jesd204 rx     
    add_fileset_file ${simulator_path}/altera_jesd204_rx_csr.v                $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_csr.v            $simulator_specific     
    add_fileset_file ${simulator_path}/altera_jesd204_rx_ctl.v                $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_ctl.v            $simulator_specific     
    add_fileset_file ${simulator_path}/altera_jesd204_rx_descrambler.v        $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_descrambler.v    $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll.v                $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll.v            $simulator_specific        
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_char_val.v       $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_char_val.v   $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_cs.v             $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_cs.v         $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_fs_char_replace.v $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_fs_char_replace.v $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_frame_align.v    $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_frame_align.v $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_lane_align.v     $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_lane_align.v  $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_data_store.v     $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_data_store.v  $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_ecc_enc.v        $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_ecc_enc.v     $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_ecc_dec.v        $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_ecc_dec.v     $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_ecc_fifo.v       $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_ecc_fifo.v    $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_dll_wo_ecc_fifo.v    $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_dll_wo_ecc_fifo.v $simulator_specific
    add_fileset_file ${simulator_path}/altera_jesd204_rx_regmap.v             $filekind PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_regmap.v          $simulator_specific

  
    # Add SDC, OCP and debug_stp files for Synthesis
    #-----------------------------------
    # Terp for SDC file
    #-----------------------------------
    if {[param_matches wrapper_opt "base"]} {
       set margin [get_parameter_value sdc_constraint]
       set g_device_family [get_parameter_value DEVICE_FAMILY]
       #Set up Terp Variables
       set g_wrapper_opt [ get_parameter_value wrapper_opt]
       set g_DATA_PATH   [ get_parameter_value DATA_PATH ]
       set g_lane_rate  [ get_parameter_value lane_rate ]    
       set linkclk_period_ns  [format %0.3f [expr {40.000*1000/($g_lane_rate*$margin)}] ]
       # Set avs_clk = 125MHz * sdc_constraint
       set avsclk_period_ns  [format %0.3f [expr {1000.000/(125*$margin)}] ]
    
       #Do Terp
       set template_file [ file join $topdir "altera_jesd204.sdc.terp" ]  
       set template   [ read [ open $template_file r ] ]
       set params(wrapper) $g_wrapper_opt  
       set params(data_path) $g_DATA_PATH
       set params(linkclk_period_ns) $linkclk_period_ns
       set params(avsclk_period_ns) $avsclk_period_ns   
       set result   [ altera_terp $template params ]
  
       if {[string compare -nocase ${simulator} synthesis] == 0} {
          # SDC for DATA_PATH == TX and DATA_PATH == RX_TX is genereted under TX instance while SDC for DATA_PATH == RX is generated under RX instance
          if { $g_DATA_PATH == "RX"} {
             add_fileset_file altera_jesd204.sdc SDC TEXT $result $simulator_specific
             if { $g_device_family == "Arria 10" } {
                add_fileset_file debug/stp/README.txt OTHER PATH ../lib/debug_stp/README.txt
                add_fileset_file debug/stp/build_stp.tcl OTHER PATH ../lib/debug_stp/build_stp.tcl
                add_fileset_file debug/stp/jesd204b_base_simplex.xml OTHER PATH ../lib/debug_stp/jesd204b_base_simplex.xml.txt
             }
          }
       }
    }
    # OCP file
    if {[string compare -nocase ${simulator} synthesis] == 0} {
       add_fileset_file altera_jesd204_rx_base.ocp OTHER PATH ${tmpdir}/${simulator_path}/altera_jesd204_rx_base.ocp $simulator_specific 
    }

}

#------------------------------------------------------------------------
# 4. Customer Demo Testbench
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# 5. Add fileset for synthesis and simulators
#------------------------------------------------------------------------
proc synthproc {name} {

    common_fileset "verilog" 0 synthesis
   
}

proc verilogsimproc {name} {

    if {1} {
    common_fileset "verilog" 1 mentor
    }
    if {1} {
    common_fileset "verilog" 1 synopsys
    }
    if {1} {
    common_fileset "verilog" 1 cadence
    }
    if {1} {
    common_fileset "verilog" 1 aldec
    }

}

proc vhdlsimproc {name} {
 
    if {1} {
    common_fileset "vhdl" 1 mentor
    }
    if {1} {
    common_fileset "vhdl" 1 synopsys
    }
    if {1} {
    common_fileset "vhdl" 1 cadence
    }
    if {1} {
    common_fileset "vhdl" 1 aldec
    }

 
} 
