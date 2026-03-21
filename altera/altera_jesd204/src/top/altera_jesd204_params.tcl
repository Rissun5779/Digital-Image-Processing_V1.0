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


package provide altera_jesd204::gui_params 16.0

namespace eval ::altera_jesd204::gui_params:: {
   namespace export \
             params_top_hw \
             params_tx_hw \
	     params_tx_mlpcs_hw \
	     params_rx_hw \
	     params_rx_mlpcs_hw \
	     params_phy_adapter \
	     params_phy \
             params_pll_wrapper_hw

}	


######################################
# Set the names for TAB and Group (GUI)
######################################
#Tab and group names for "IP" tab
set tab_ip "IP"
set tab_ip_grp "Altera Jesd204b IP Configuration"
set tab_ip_tab1 "Main"
set tab_ip_tab1_grp1 "Device Family"
set tab_ip_tab1_grp2 "Wrapper Options"
set tab_ip_tab1_grp3 "Operation Modes and Speed"
set tab_ip_tab1_grp4 "Transceiver Options"
set tab_ip_tab2 "Jesd204b Configurations"
set tab_ip_tab2_grp1 "Common Configurations"
set tab_ip_tab2_grp2 "Advanced Configurations"
set tab_ip_tab3 "Configurations and Status Registers"
set tab_ip_tab3_grp1 "Programmability"
set tab_ip_tab3_grp2 "Device ID"
set tab_ip_tab3_grp3 "Lanes ID and Checksums"
set tab_ip_tab4 "Test Configurations"
set tab_ip_tab4_grp1 "Test Components"
set tab_ip_hidden_grp "Hidden Parameters"
#Tab and group names for "Example Design" tab
set tab_ed "Example Design"
set tab_ed_grp1 "Available Example Designs"
set tab_ed_grp2 "Example Design Files"
set tab_ed_grp3 "Generated HDL Format for Simulation"
set tab_ed_grp4 "Generated HDL Format for Synthesis"
set tab_ed_grp5 "Target Development Kit"

proc ::altera_jesd204::gui_params::conf_params {param_name} {
 
   # Variable for gui
   global tab_ip_tab1_grp1 
   global tab_ip_tab1_grp2 
   global tab_ip_tab1_grp3 
   global tab_ip_tab1_grp4
   global tab_ip_tab2_grp1
   global tab_ip_tab2_grp2
   global tab_ip_tab3_grp1
   global tab_ip_tab3_grp2
   global tab_ip_tab3_grp3
   global tab_ip_tab4_grp1
   global tab_ip_hidden_grp
   global tab_ed_grp1
   global tab_ed_grp2
   global tab_ed_grp3
   global tab_ed_grp4
   global tab_ed_grp5

# Reference for html codes used in this section
 # ----------------------------------------------
 # &lt = less than (<)
 # &gt = greater than (>)
 # <b></b> = bold text
 # <ul></ul> = defines an unordered list
 # <li></li> = bullet list
 # <br> = line break

    if {[expr {$param_name == "DEVICE_FAMILY"}]} {
    add_display_item $tab_ip_tab1_grp1 "DEVICE_FAMILY" PARAMETER 
    add_parameter "DEVICE_FAMILY" STRING 
    set_parameter_property "DEVICE_FAMILY" SYSTEM_INFO {DEVICE_FAMILY}
    set_parameter_property "DEVICE_FAMILY" DISPLAY_NAME "Device family"
    set_parameter_property "DEVICE_FAMILY" ENABLED 0    
    set_parameter_property "DEVICE_FAMILY" HDL_PARAMETER true
    set_parameter_property "DEVICE_FAMILY" DESCRIPTION "Select the targeted device family"
    }

    if {[expr {$param_name == "part_trait_bd"}]} {
    add_display_item $tab_ip_tab1_grp1 "part_trait_bd" PARAMETER 
    add_parameter "part_trait_bd" STRING 
    set_parameter_property "part_trait_bd" SYSTEM_INFO_TYPE PART_TRAIT
    set_parameter_property "part_trait_bd" SYSTEM_INFO_ARG BASE_DEVICE
    set_parameter_property "part_trait_bd" DISPLAY_NAME "Base Device"
    set_parameter_property "part_trait_bd" ENABLED 0    
    set_parameter_property "part_trait_bd" HDL_PARAMETER false
    set_parameter_property "part_trait_bd" VISIBLE false
    }

    if {[expr {$param_name == "part_trait_dp"}]} {
    add_display_item $tab_ip_tab1_grp1 "part_trait_dp" PARAMETER 
    add_parameter "part_trait_dp" STRING 
    set_parameter_property "part_trait_dp" SYSTEM_INFO_TYPE PART_TRAIT
    set_parameter_property "part_trait_dp" SYSTEM_INFO_ARG DEVICE
    set_parameter_property "part_trait_dp" DISPLAY_NAME "Device Part"
    set_parameter_property "part_trait_dp" ENABLED 0    
    set_parameter_property "part_trait_dp" HDL_PARAMETER false
    set_parameter_property "part_trait_dp" VISIBLE false
    }

    if {[expr {$param_name == "wrapper_opt"}]} {
    add_display_item $tab_ip_tab1_grp2 "wrapper_opt" PARAMETER 
    add_parameter "wrapper_opt" STRING "base_phy"
    set_parameter_property "wrapper_opt" DEFAULT_VALUE "base_phy"
    set_parameter_property "wrapper_opt" DISPLAY_NAME "Jesd204b wrapper"
    set_parameter_property "wrapper_opt" HDL_PARAMETER false
    set_parameter_property "wrapper_opt" ALLOWED_RANGES { "base:Base Only" "phy:Phy Only" "base_phy:Both Base and Phy"}
    set_parameter_property "wrapper_opt" DISPLAY_HINT "RADIO"
    set_parameter_property "wrapper_opt" VISIBLE true
    set_parameter_property "wrapper_opt" DESCRIPTION \
    "<html>
        Select the wrapper.
        <ul>
	<li><b>Base Only</b> : Generate Altera JESD204B IP with Data Link layer only.</li>
	<li><b>Phy Only </b> : Generate Altera JESD204B IP with PHY layer only.</li>
	<li><b>Both Base and Phy</b> : Generate Altera JESD204B IP  with both Data Link layer and PHY layer.</li>
	</ul>
     </html>"
    }

    if {[expr {$param_name == "DATA_PATH"}]} {   
    add_display_item $tab_ip_tab1_grp3 "DATA_PATH" PARAMETER 
    add_parameter "DATA_PATH" STRING "RX"
    set_parameter_property "DATA_PATH" DEFAULT_VALUE "RX"
    set_parameter_property "DATA_PATH" DISPLAY_NAME "Data path"
    set_parameter_property "DATA_PATH" TYPE STRING
    set_parameter_property "DATA_PATH" UNITS None
    set_parameter_property "DATA_PATH" ALLOWED_RANGES { "RX:Receiver" "TX:Transmitter" "RX_TX:Duplex"}
    set_parameter_property "DATA_PATH" HDL_PARAMETER false
#    set_parameter_update_callback "DATA_PATH" parameter_update_callback
    set_parameter_property "DATA_PATH" DESCRIPTION \
     "<html>
	Select operation modes.
	<ul>
	<li><b>Receiver</b> : Instantiate Altera JESD204B IP Receiver to interface to ADC.</li>
	<li><b>Transmitter</b> : Instantiate Altera JESD204B IP Transmitter to interface to DAC.</li>
	<li><b>Duplex</b> : Instantiate both Altera JESD204B IP Receiver and Transimitter to interface to both ADC and DAC.</li>
	</ul>
     </html>"
    }

    if {[expr {$param_name == "SUBCLASSV"}]} {
    add_parameter "SUBCLASSV" INTEGER 1
    add_display_item $tab_ip_tab1_grp3 "SUBCLASSV" PARAMETER
    set_parameter_property "SUBCLASSV" DEFAULT_VALUE 1
    set_parameter_property "SUBCLASSV" DISPLAY_NAME "Jesd204b subclass"
    set_parameter_property "SUBCLASSV" TYPE INTEGER
    set_parameter_property "SUBCLASSV" UNITS None
    set_parameter_property "SUBCLASSV" ALLOWED_RANGES  {0 1 2}
    set_parameter_property "SUBCLASSV" HDL_PARAMETER true
    set_parameter_property "SUBCLASSV" DESCRIPTION \
     "<html>
	Select the subclass modes. 
	<ul>
	<li><b>0</b> : Set subclass 0</li>
	<li><b>1</b> : Set subclass 1</li>
	<li><b>2</b> : Set subclass 2</li>
	</ul>
     </html>"
    }

    if {[expr {$param_name == "lane_rate"}]} {
    add_parameter "lane_rate" FLOAT 5000
    add_display_item $tab_ip_tab1_grp3 "lane_rate" PARAMETER
    set_parameter_property "lane_rate" DEFAULT_VALUE 5000   
    set_parameter_property "lane_rate" DISPLAY_NAME "Data rate"
    set_parameter_property "lane_rate" TYPE FLOAT
    set_parameter_property "lane_rate" UNITS None
    set_parameter_property "lane_rate" DISPLAY_UNITS "Mbps"
    set_parameter_property "lane_rate" ALLOWED_RANGES  1000:20000 
    set_parameter_property "lane_rate" HDL_PARAMETER false
    set_parameter_property "lane_rate" DESCRIPTION \
     "<html>
      Set the data rate for each lane. The maximum data rate is limited by device speed grade, transceiver PMA speed grade, and PCS options.
          <p>Please refer to JESD204B IP Core User Guide for details.
	<!-- <ul>
	<li><b>Arria 10</b> : Supports 2Gbps-13.5Gbps.</li>
	<li><b>Stratix V</b> : Supports 2Gbps-12.5Gbps.</li> 
	<li><b>Arria V GZ</b> : Supports 2Gbps-9.9Gbps.</li> 
	<li><b>Arria V</b> : Supports 1Gbps-7.5Gbps.</li>
       	<li><b>Cyclone V</b> : Supports 1Gbps-5Gbps.</li>
	</ul> -->
     </html>"
    }
  
    if {[expr {$param_name == "PCS_CONFIG"}]} {  
    add_display_item $tab_ip_tab1_grp4 "PCS_CONFIG" PARAMETER  
    add_parameter "PCS_CONFIG" STRING "JESD_PCS_CFG1"
    #PCS_CONFIG is selected based on Lane rate & Device family.
    set_parameter_property "PCS_CONFIG" DISPLAY_NAME "PCS Option"
    set_parameter_property "PCS_CONFIG" TYPE STRING
    set_parameter_property "PCS_CONFIG" UNITS None
    set_parameter_property "PCS_CONFIG" ALLOWED_RANGES {"JESD_PCS_CFG1:Enabled Hard PCS" "JESD_PCS_CFG2:Enabled Soft PCS" "JESD_PCS_CFG4:Enabled PMA Direct"}
    set_parameter_property "PCS_CONFIG" HDL_PARAMETER true
    set_parameter_property "PCS_CONFIG" VISIBLE true 
    set_parameter_property "PCS_CONFIG" DERIVED false
    set_parameter_property "PCS_CONFIG" DESCRIPTION \
    "<html> 
     <p>Select PCS modes.</p>
     <ul>
     <li><b>Enabled Hard PCS</b> : <br><i>(All supported device families)</i><br>Utilize Hard PCS components. Select this option will minimize resource utilization with data rate supports up to Hard PCS's limitation. </li>
     <li><b>Enabled Soft PCS</b> : <br><i>(Stratix V, Arria V GZ, Arria 10 & Stratix 10 only)</i><br>Utilize Soft PCS components. Select this option will allow higher supported data rate but increase in resource utilization.</li>
     <li><b>Enabled PMA Direct</b> : <br><i>(Arria V GT/ST only)</i><br>NativePHY is set to PMA Direct mode. Select this option will allow highest supported data rate and maximize resource utilization.</li>
     </ul>
     </html>"
    }

    if {[expr {$param_name == "pll_type"}]} {
    add_parameter "pll_type" STRING "CMU"
    add_display_item $tab_ip_tab1_grp4 "pll_type" PARAMETER 
    set_parameter_property "pll_type" DEFAULT_VALUE "CMU"
    set_parameter_property "pll_type" DISPLAY_NAME "PLL Type"
    set_parameter_property "pll_type" TYPE STRING
    set_parameter_property "pll_type" UNITS None
    set_parameter_property "pll_type" ALLOWED_RANGES {"CMU" "ATX"}
    set_parameter_property "pll_type" DERIVED false
    set_parameter_property "pll_type" HDL_PARAMETER false
    set_parameter_property "pll_type" DESCRIPTION \
     "<html>
	Select Phase-Locked Loop(PLL) type. Arria V and Cyclone V only support CMU PLL.<p>
	<i>**This parameter is not applicable to Arria 10 and Stratix 10 devices.</i>
     </html>"
    }

    if {[expr {$param_name == "bonded_mode"}]} {
    add_parameter "bonded_mode" STRING "bonded"
    add_display_item $tab_ip_tab1_grp4 "bonded_mode" PARAMETER 
    set_parameter_property "bonded_mode" DEFAULT_VALUE "bonded"
    set_parameter_property "bonded_mode" DISPLAY_NAME "Bonding Mode "
    set_parameter_property "bonded_mode" TYPE STRING
    set_parameter_property "bonded_mode" UNITS None
    set_parameter_property "bonded_mode" ALLOWED_RANGES {"bonded:Bonded" "non_bonded:Non-Bonded"}
    set_parameter_property "bonded_mode" DERIVED false
    set_parameter_property "bonded_mode" HDL_PARAMETER false
    set_parameter_property "bonded_mode" DISPLAY_HINT "RADIO"
    set_parameter_property "bonded_mode" DESCRIPTION \
     "<html>
	Select the bonding modes. Please refer to device book for bonding details. 
        <ul>
        <li><b>Bonded</b> : Select this option to minimize inter-lanes skew for transmitter datapath. </li>
        <li><b>Non-bonded</b> : Select this option to disable inter-lanes skew control for transmitter datapath.</li>
        </ul>

     </html>"
    }


    if {[expr {$param_name == "REFCLK_FREQ"}]} {
    add_parameter "REFCLK_FREQ" FLOAT 125.0
    add_display_item $tab_ip_tab1_grp4 "REFCLK_FREQ" PARAMETER 
    set_parameter_property "REFCLK_FREQ" DEFAULT_VALUE 125.0
    set_parameter_property "REFCLK_FREQ" DISPLAY_NAME "PLL/CDR Reference Clock Frequency"
    set_parameter_property "REFCLK_FREQ" TYPE FLOAT
    set_parameter_property "REFCLK_FREQ" UNITS Megahertz
    set_parameter_property "REFCLK_FREQ" ALLOWED_RANGES {}
    set_parameter_property "REFCLK_FREQ" HDL_PARAMETER false
    set_parameter_property "REFCLK_FREQ" DESCRIPTION \
     "<html>
	Set the transceiver reference clock frequency for Phase-Locked Loop(PLL) or CDR.<br>
	<b>Note</b> : For Arria 10 device, the transceiver transmit PLL(TX PLL) reference clock frequency needs to be set in the externally instantiated transceiver TX PLL.
     </html>"
    }

    if {[expr {$param_name =="bitrev_en"}]} {
    add_display_item $tab_ip_tab1_grp4 "bitrev_en" PARAMETER 
    add_parameter "bitrev_en" BOOLEAN false
    set_parameter_property "bitrev_en" DISPLAY_NAME "Enable Bit reversal and Byte reversal"
    set_parameter_property "bitrev_en" HDL_PARAMETER false
    set_parameter_property "bitrev_en" DESCRIPTION \
     "<html>
          Turn on this option to set data transmission order in MSB-first serialization. <br>If this option is off, the data transmission order is in LSB-first serialization.
     </html>"
    }

    # Displays information on selected bonding mode
    add_display_item $tab_ip_tab1_grp4 "gui_bonded_mode" text ""

    if {[expr {$param_name == "pll_reconfig_enable"}]} {
    add_display_item $tab_ip_tab1_grp4 "gui_pll_reconfig_enable" text "<html><b>Dynamic Reconfiguration</b></html>"
    add_parameter "pll_reconfig_enable" BOOLEAN false
    add_display_item $tab_ip_tab1_grp4 "pll_reconfig_enable" PARAMETER 
    set_parameter_property "pll_reconfig_enable" DISPLAY_NAME "Enable Transceiver Dynamic Reconfiguration"
    set_parameter_property "pll_reconfig_enable" HDL_PARAMETER false
    set_parameter_property "pll_reconfig_enable" DESCRIPTION \
     "<html>
	For V series device families,<br> 
        Turn on this option to enable dynamic data rate change. When you enable this option,you need to connect the reconfiguration interface to transceiver reconfiguration controller.<br>
        For Arria 10 device,<br>
        Turn on this option to enable Transceiver Native PHY reconfiguration interface. 	
      </html>"
    }

    if {[expr {$param_name == "rcfg_jtag_enable"}]} {
    add_parameter "rcfg_jtag_enable" BOOLEAN false
    add_display_item $tab_ip_tab1_grp4 "rcfg_jtag_enable" PARAMETER 
    set_parameter_property "rcfg_jtag_enable" DISPLAY_NAME "Enable Altera Debug Master Endpoint"
    set_parameter_property "rcfg_jtag_enable" HDL_PARAMETER false
    set_parameter_property "rcfg_jtag_enable" DESCRIPTION \
     "<html>
	When enabled, Transceiver Native PHY includes an embeded Altera Debug Master Endpoint that connects internally to Avalon-MM slave interface of Transceiver Native PHY. The ADME can access the reconfiguration space of the transceiver. It can perform certain test and debug functions via JTAG using System Console. This option requires you to enable the \"Share reconfiguration interface\" option for configurations using more than 1 channel and may also require that a jtag_debug link be included in the system.<br>
        This option can only be set for Arria 10 device with \"Transceiver Dynamic Reconfiguration\" enabled.	
      </html>"
    }

    if {[expr {$param_name == "rcfg_shared"}]} {
    add_parameter "rcfg_shared" BOOLEAN true
    add_display_item $tab_ip_tab1_grp4 "rcfg_shared" PARAMETER  
    set_parameter_property "rcfg_shared" DISPLAY_NAME "Share Reconfiguration Interface"
    set_parameter_property "rcfg_shared" HDL_PARAMETER false
    set_parameter_property "rcfg_shared" DESCRIPTION \
     "<html>
        When enabled, Transceiver Native PHY presents a single Avalon-MM slave interface for dynamic reconfiguration of all channels. In this configuration the upper \[n-1:10\] address bits of the reconfiguration address bus specify the selected channel. Address bits \[9:0\] provide the register offset address within the reconfiguration space of the selected channel.<br>
        For configurations using more than one channel, this option must be enabled when \"Altera Debug Master Endpoint\" is enabled.
      </html>"
    }

    if {[expr {$param_name == "set_capability_reg_enable"}]} {
    add_parameter "set_capability_reg_enable" BOOLEAN false
    add_display_item $tab_ip_tab1_grp4 "set_capability_reg_enable" PARAMETER 
    set_parameter_property "set_capability_reg_enable" DISPLAY_NAME "Enable Capability Registers"
    set_parameter_property "set_capability_reg_enable" HDL_PARAMETER false
    set_parameter_property "set_capability_reg_enable" DESCRIPTION \
     "<html>
	Enable capability registers, which provide high level information about transceiver channel's configuration.	
      </html>"
    }

    if {[expr {$param_name == "set_user_identifier"}]} {
    add_parameter "set_user_identifier" INTEGER 0
    add_display_item $tab_ip_tab1_grp4 "set_user_identifier" PARAMETER 
    set_parameter_property "set_user_identifier" DISPLAY_NAME "Set user-defined IP identifier"
    set_parameter_property "set_user_identifier" ALLOWED_RANGES 0:255
    set_parameter_property "set_user_identifier" HDL_PARAMETER false
    set_parameter_property "set_user_identifier" DESCRIPTION \
     "<html>
	Set a user-defined numeric identifier that can be read from the user identifer offset when the capability registers are enabled.	
      </html>"
    }

    if {[expr {$param_name == "set_csr_soft_logic_enable"}]} {
    add_parameter "set_csr_soft_logic_enable" BOOLEAN false
    add_display_item $tab_ip_tab1_grp4 "set_csr_soft_logic_enable" PARAMETER 
    set_parameter_property "set_csr_soft_logic_enable" DISPLAY_NAME "Enable Control and Status Registers"
    set_parameter_property "set_csr_soft_logic_enable" HDL_PARAMETER false
    set_parameter_property "set_csr_soft_logic_enable" DESCRIPTION \
     "<html>
	Enable soft registers for reading status signals and writing control signals on the phy interface through the embedded debug. Signals include rx_is_locktoref, rx_is_locktodata, tx_cal_busy, rx_cal_busy, rx_serial_loopback, set_rx_locktodata, set_rx_locktoref, tx_analogreset, tx_digitalreset, rx_analogreset and rx_digitalrest. For more information, please refer to Arria 10/Stratix 10 Transceiver User Guide.	
      </html>"
    }

    if {[expr {$param_name == "set_prbs_soft_logic_enable"}]} {
    add_parameter "set_prbs_soft_logic_enable" BOOLEAN false
    add_display_item $tab_ip_tab1_grp4 "set_prbs_soft_logic_enable" PARAMETER 
    set_parameter_property "set_prbs_soft_logic_enable" DISPLAY_NAME "Enable PRBS Soft Accumulators"
    set_parameter_property "set_prbs_soft_logic_enable" HDL_PARAMETER false
    set_parameter_property "set_prbs_soft_logic_enable" DESCRIPTION \
     "<html>
	Enable soft logic for doing prbs bit and error accumulation when using the hard prbs generator and checker. 	
      </html>"
    }

#    if {[expr {$param_name == "set_odi_soft_logic_enable"}]} {
#    add_parameter "set_odi_soft_logic_enable" BOOLEAN false
#    add_display_item $tab_ip_tab1_grp4 "set_odi_soft_logic_enable" PARAMETER 
#    set_parameter_property "set_odi_soft_logic_enable" DISPLAY_NAME "Enable ODI Acceleration Logic"
#    set_parameter_property "set_odi_soft_logic_enable" HDL_PARAMETER false
#    set_parameter_property "set_odi_soft_logic_enable" DESCRIPTION \
#     "<html>
#	Enables soft logic for accelerating bit and error accumulation when using ODI. 	
#      </html>"
#    }

    if {[expr {$param_name == "L"}]} {
    add_parameter "L" INTEGER 1
    add_display_item $tab_ip_tab2_grp1 "L" PARAMETER 
    set_parameter_property "L" DEFAULT_VALUE 1
    set_parameter_property "L" DISPLAY_NAME "Lanes per converter device (L)"
    set_parameter_property "L" TYPE INTEGER
    set_parameter_property "L" UNITS None
    set_parameter_property "L" ALLOWED_RANGES 1:32
    set_parameter_property "L" HDL_PARAMETER true
    set_parameter_property "L" DESCRIPTION \
     "<html>
	Set the number of lanes per converter device.<br>
	Supported range : 1-8 or 1-32 for PHY only options 
     </html>"
    lappend global_params "L"
    }

    if {[expr {$param_name == "M"}]} {
    add_display_item $tab_ip_tab2_grp1 "M" PARAMETER 
    add_parameter "M" INTEGER 2 
    set_parameter_property "M" DEFAULT_VALUE 2
    set_parameter_property "M" DISPLAY_NAME "Converters per device (M)"
    set_parameter_property "M" TYPE INTEGER
    set_parameter_property "M" UNITS None
    set_parameter_property "M" ALLOWED_RANGES 1:256
    set_parameter_property "M" HDL_PARAMETER true
    set_parameter_property "M" DESCRIPTION \
     "<html>
	Set the number of converters per converter device.<br>
	Supported range : 1-256.
     </html>"
    lappend global_params "M"
    }

    if {[expr {$param_name == "GUI_EN_CFG_F"}]} {
    add_display_item $tab_ip_tab2_grp1 "GUI_EN_CFG_F" PARAMETER 
    add_parameter "GUI_EN_CFG_F" BOOLEAN 0
    set_parameter_property "GUI_EN_CFG_F" DEFAULT_VALUE 0
    set_parameter_property "GUI_EN_CFG_F" DISPLAY_NAME "Enable manual F configuration"
    set_parameter_property "GUI_EN_CFG_F" UNITS None
    set_parameter_property "GUI_EN_CFG_F" HDL_PARAMETER false
    set_parameter_property "GUI_EN_CFG_F" VISIBLE true
    set_parameter_property "GUI_EN_CFG_F" DESCRIPTION \
    "<html>
       Turn this on to set parameter <b>F</b> in manual mode and enable parameter <b>F</b> to be configurable. Otherwise, the parameter <b>F</b> is in derived mode.
       You may require to enable this parameter and configure the appropriate <b>F</b> value if your transport layer is supporting Control Word (CF) and/or High Density format(HD). <br>
       <b>Note</b> : <br>
       The auto derived <b>F</b> value using formula <b>F=M*S*N\'/(8*L) </b> may not applicable if parameter <b>CF</b> and/or parameter <b>HD</b> are enabled.       
    </html>"
    }

    if {[expr {$param_name == "GUI_CFG_F"}]} {
    add_display_item $tab_ip_tab2_grp1 "GUI_CFG_F" PARAMETER 
    add_parameter "GUI_CFG_F" INTEGER 4
    set_parameter_property "GUI_CFG_F" DEFAULT_VALUE 4
    set_parameter_property "GUI_CFG_F" DISPLAY_NAME "Octets per frame (F)"
    set_parameter_property "GUI_CFG_F" TYPE INTEGER
    set_parameter_property "GUI_CFG_F" UNITS None
    set_parameter_property "GUI_CFG_F" HDL_PARAMETER false
    set_parameter_property "GUI_CFG_F" ALLOWED_RANGES 1:256
    set_parameter_property "GUI_CFG_F" ENABLED false
    set_parameter_property "GUI_CFG_F" VISIBLE false
    set_parameter_property "GUI_CFG_F" DESCRIPTION \
     "<html>
	Set the number of octets per frame. This parameter <b>F</b> can be in derived mode or manual mode. In derived mode, the <b>F</b> value will be derived based on equation below. In manual mode, it requires input from user.<br>
	Equation : <b>F=M*S*N\'/(8*L) </b>.<br>
	Supported range : 1,2,4-256.
     </html>"
    }

    if {[expr {$param_name == "F"}]} {
    add_display_item $tab_ip_tab2_grp1 "F" PARAMETER 
    add_parameter "F" INTEGER 4
    set_parameter_property "F" DEFAULT_VALUE 4
    set_parameter_property "F" DISPLAY_NAME "Octets per frame (F)"
    set_parameter_property "F" TYPE INTEGER
    set_parameter_property "F" UNITS None
    set_parameter_property "F" ALLOWED_RANGES 1:256
    set_parameter_property "F" HDL_PARAMETER true
    set_parameter_property "F" VISIBLE true
    set_parameter_property "F" ENABLED true
    set_parameter_property "F" DERIVED true
    set_parameter_property "F" DESCRIPTION \
     "<html>
	Set the number of octets per frame. This parameter <b>F</b> can be in derived mode or manual mode. In derived mode, the <b>F</b> value will be derived based on equation below. In manual mode, it requires input from user.<br>
	Equation : <b>F=M*S*N\'/(8*L) </b>.<br>
	Supported range : 1,2,4-256.
     </html>"
    }

    if {[expr {$param_name == "N"}]} {
    add_display_item $tab_ip_tab2_grp1 "N" PARAMETER
    add_parameter "N" INTEGER 12
    set_parameter_property "N" DEFAULT_VALUE 12
    set_parameter_property "N" DISPLAY_NAME "Converter resolution (N)"
    set_parameter_property "N" TYPE INTEGER
    set_parameter_property "N" UNITS None
    set_parameter_property "N" ALLOWED_RANGES 1:32
    set_parameter_property "N" HDL_PARAMETER true
    set_parameter_property "N" DESCRIPTION \
     "<html>
	Set the number of converstion bits per converter.<br>
	Supported range : 1-32.
     </html>"
    }

    if {[expr {$param_name == "N_PRIME"}]} {
    add_display_item $tab_ip_tab2_grp1 "N_PRIME" PARAMETER 
    add_parameter "N_PRIME" INTEGER 16
    set_parameter_property "N_PRIME" DEFAULT_VALUE 16
    set_parameter_property "N_PRIME" DISPLAY_NAME "Transmitted bits per sample (N')"
    set_parameter_property "N_PRIME" TYPE INTEGER
    set_parameter_property "N_PRIME" UNITS None
    set_parameter_property "N_PRIME" ALLOWED_RANGES {4 8 12 16 20 24 28 32}
    set_parameter_property "N_PRIME" HDL_PARAMETER true
    set_parameter_property "N_PRIME" DESCRIPTION \
     "<html>
	Set the number of transmitted bits per sample (JESD204 word size). This parameter is derived using the constraints below : <br>  
	<ul>
	 <li> If parameter <b>CF = 0</b> (no control word), <b>N' &ge N + CS</b>, else <b>N' &ge N</b> </li>
	 <li> Must be divisible by 4.</li>
        </ul>
	Supported range : 4-32.(JESD word size which is in nibble group)
     </html>"
    }

    if {[expr {$param_name == "S"}]} {
    add_display_item $tab_ip_tab2_grp1 "S" PARAMETER 
    add_parameter "S" INTEGER 1
    set_parameter_property "S" DEFAULT_VALUE 1
    set_parameter_property "S" DISPLAY_NAME "Samples per converter per frame (S)"
    set_parameter_property "S" TYPE INTEGER
    set_parameter_property "S" UNITS None
    set_parameter_property "S" ALLOWED_RANGES 1:32
    set_parameter_property "S" HDL_PARAMETER true
    set_parameter_property "S" DESCRIPTION \
     "<html>
	Set the number of transmitted samples per converter per frame.<br>
	Supported range : 1-32.
     </html>"
    }

    if {[expr {$param_name == "K"}]} {
    add_display_item $tab_ip_tab2_grp1 "K" PARAMETER 
    add_parameter "K" INTEGER 16
    set_parameter_property "K" DEFAULT_VALUE 16
    set_parameter_property "K" DISPLAY_NAME "Frames per multiframe (K)"
    set_parameter_property "K" TYPE INTEGER
    set_parameter_property "K" UNITS None
    set_parameter_property "K" ALLOWED_RANGES 1:32
    set_parameter_property "K" HDL_PARAMETER true
    set_parameter_property "K" DESCRIPTION \
     "<html>
	Set the number of frames per multiframe. The legal value of this parameter <b>K</b> is depends on parameter <b>F</b>. <br>
	It is derived using the constraints below : <br>
        <ul>
	 <li> The value of <b>K</b> must falls within this range <b>17/F&lt=K&lt=min(32,floor(1024/F))</b> .</li>
	 <li> The outcome of <b>F*K</b> must be divisible by 4.</li>
        </ul>
	<p> Supported range : 1-32.</p>
     </html>"
    }

    if {[expr {$param_name == "SCR"}]} {
    add_display_item $tab_ip_tab2_grp2 "SCR" PARAMETER 
    add_parameter "SCR" BOOLEAN 0
    set_parameter_property "SCR" DEFAULT_VALUE 0
    set_parameter_property "SCR" DISPLAY_NAME "Enable scramble (SCR)"
    set_parameter_property "SCR" TYPE INTEGER
    set_parameter_property "SCR" UNITS None
    set_parameter_property "SCR" HDL_PARAMETER true
    set_parameter_property "SCR" DISPLAY_HINT "boolean"
    set_parameter_property "SCR" DESCRIPTION \
     "<html>
	Turn on this option to scramble the transmitted data. 
     </html>"
    }

    if {[expr {$param_name == "CS"}]} {
    add_display_item $tab_ip_tab2_grp2 "CS" PARAMETER 
    add_parameter "CS" INTEGER 0
    set_parameter_property "CS" DEFAULT_VALUE 0
    set_parameter_property "CS" DISPLAY_NAME "Control Bits (CS)"
    set_parameter_property "CS" TYPE INTEGER
    set_parameter_property "CS" UNITS None
    set_parameter_property "CS" ALLOWED_RANGES {0 1 2 3}
    set_parameter_property "CS" HDL_PARAMETER true
    set_parameter_property "CS" DESCRIPTION \
     "<html>
	Set the number of control bits per conversion sample.<br> 
	Supported range : 0-3.
     </html>"
    }

    if {[expr {$param_name == "CF"}]} {
    add_display_item $tab_ip_tab2_grp2 "CF" PARAMETER 
    add_parameter "CF" INTEGER 0
    set_parameter_property "CF" DEFAULT_VALUE 0
    set_parameter_property "CF" DISPLAY_NAME "Control Words (CF)"
    set_parameter_property "CF" TYPE INTEGER
    set_parameter_property "CF" UNITS None
    set_parameter_property "CF" ALLOWED_RANGES 0:32
    set_parameter_property "CF" HDL_PARAMETER true
    set_parameter_property "CF" DESCRIPTION \
     "<html>
	Set the number of control words per frame clock period per link.<b>CF=0</b> means no control words are used.<br> 
	Other allowed <b>CF</b> values are common subdivisor of <b>L</b> and <b>M</b>. <br> 
	Supported range : 0-32.
     </html>"
    }

    if {[expr {$param_name == "HD"}]} {
    add_display_item $tab_ip_tab2_grp2 "HD" PARAMETER 
    add_parameter "HD" BOOLEAN 0 
    set_parameter_property "HD" DEFAULT_VALUE 0
    set_parameter_property "HD" DISPLAY_NAME "High Density user data format (HD)"
    set_parameter_property "HD" TYPE INTEGER
    set_parameter_property "HD" UNITS None
    set_parameter_property "HD" HDL_PARAMETER true
    set_parameter_property "HD" DISPLAY_HINT "boolean"
    set_parameter_property "HD" DESCRIPTION \
     "<html>
	Turn on this option to set data format. Parameter HD controls whether a sample may be divided over more lanes. <br> 
        <ul>
	 <li> On: High Density format .</li>
	 <li> Off: Data should not cross lane boundary.</li>
        </ul>
     </html>"
    }

    if {[expr {$param_name == "ECC_EN"}]} {
    add_display_item $tab_ip_tab2_grp2 "ECC_EN" PARAMETER 
    add_parameter "ECC_EN" BOOLEAN 0
    set_parameter_property "ECC_EN" DEFAULT_VALUE 0
    set_parameter_property "ECC_EN" DISPLAY_NAME "Enable Error Code Correction (ECC_EN)"
    set_parameter_property "ECC_EN" TYPE INTEGER
    set_parameter_property "ECC_EN" UNITS None
    set_parameter_property "ECC_EN" HDL_PARAMETER true
    set_parameter_property "ECC_EN" DISPLAY_HINT "boolean"
    set_parameter_property "ECC_EN" DESCRIPTION \
     "<html>
         Turn on this option to enable Error Code Correction (ECC) for memory blocks.  
     </html>"
    }

    if {[expr {$param_name == "DLB_TEST"}]} {
    #Hide from User
    add_display_item $tab_ip_tab2_grp2 "DLB_TEST" PARAMETER 
    add_parameter "DLB_TEST" BOOLEAN 0
    set_parameter_property "DLB_TEST" DEFAULT_VALUE 0
    set_parameter_property "DLB_TEST" DISPLAY_NAME "Enable Digital Loop Back Test (DLB_TEST)"
    set_parameter_property "DLB_TEST" TYPE INTEGER
    set_parameter_property "DLB_TEST" UNITS None
    set_parameter_property "DLB_TEST" HDL_PARAMETER true
    set_parameter_property "DLB_TEST" DISPLAY_HINT "boolean"
    set_parameter_property "DLB_TEST" VISIBLE false 
    set_parameter_property "DLB_TEST" DESCRIPTION \
     "<html>
         Turn on this option to enable digital loop back test.<br> 
     </html>"
    }

    if {[expr {$param_name == "PHADJ"}]} {
    add_display_item $tab_ip_tab2_grp2 "gui_sub2" text "<html><b>Subclass 2 Parameters</b></html>"
    add_display_item $tab_ip_tab2_grp2 "PHADJ" PARAMETER 
    add_parameter "PHADJ" BOOLEAN 0
    set_parameter_property "PHADJ" DEFAULT_VALUE 0
    set_parameter_property "PHADJ" DISPLAY_NAME "Phase adjustment request (PHADJ)"
    set_parameter_property "PHADJ" TYPE INTEGER
    set_parameter_property "PHADJ" UNITS None
    set_parameter_property "PHADJ" HDL_PARAMETER true
    set_parameter_property "PHADJ" DISPLAY_HINT "boolean"
    set_parameter_property "PHADJ" DESCRIPTION \
     "<html>
       Turn on this option to specify the phase adjustment request to DAC. <br>
        <ul>
	 <li> On: Request for phase adjustment .</li>
	 <li> Off: No phase adjustment.</li>
        </ul>
     </html>"
    }

    if {[expr {$param_name == "ADJCNT"}]} {
    add_display_item $tab_ip_tab2_grp2 "ADJCNT" PARAMETER 
    add_parameter "ADJCNT" INTEGER 0 
    set_parameter_property "ADJCNT" DEFAULT_VALUE 0
    set_parameter_property "ADJCNT" DISPLAY_NAME "Adjustment resolution step count (ADJCNT)"
    set_parameter_property "ADJCNT" TYPE INTEGER
    set_parameter_property "ADJCNT" UNITS None
    set_parameter_property "ADJCNT" ALLOWED_RANGES {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
    set_parameter_property "ADJCNT" HDL_PARAMETER true
    set_parameter_property "ADJCNT" DESCRIPTION \
     "<html>
	Set the adjustment resolution steps for DAC LMFC.<br> 
	Supported range : 0-15.
     </html>"
    }
   
    if {[expr {$param_name == "ADJDIR"}]} {
    add_display_item $tab_ip_tab2_grp2 "ADJDIR" PARAMETER 
    add_parameter "ADJDIR" INTEGER 0
    set_parameter_property "ADJDIR" DEFAULT_VALUE 0
    set_parameter_property "ADJDIR" DISPLAY_NAME "Direction of adjustment (ADJDIR)"
    set_parameter_property "ADJDIR" TYPE INTEGER
    set_parameter_property "ADJDIR" UNITS None
    set_parameter_property "ADJDIR" ALLOWED_RANGES {"0:Advance" "1:Delay"}
    set_parameter_property "ADJDIR" HDL_PARAMETER true
    set_parameter_property "ADJDIR" DISPLAY_HINT "radio"
    set_parameter_property "ADJDIR" DESCRIPTION \
     "<html>
	Select to adjust DAC LMFC direction. <br>     
     </html>"
    }

    if {[expr {$param_name == "OPTIMIZE"}]} {
    add_display_item $tab_ip_tab3_grp1 "OPTIMIZE" PARAMETER
    add_parameter "OPTIMIZE" INTEGER 0
    set_parameter_property "OPTIMIZE" DEFAULT_VALUE 0
    set_parameter_property "OPTIMIZE" DISPLAY_NAME "CSR Programmability"
    set_parameter_property "OPTIMIZE" TYPE INTEGER
    set_parameter_property "OPTIMIZE" UNITS None
    set_parameter_property "OPTIMIZE" ALLOWED_RANGES  {"0:Fully Programmable" "1:Optimized"}
    set_parameter_property "OPTIMIZE" HDL_PARAMETER true
    set_parameter_property "OPTIMIZE" VISIBLE false
    set_parameter_property "OPTIMIZE" DISPLAY_HINT "radio"
    set_parameter_property "OPTIMIZE" DESCRIPTION \
     "<html>
     Select the programmability of CSR.<br>
	<li> <b>Fully Programmable</b> : Fully Programmable ILAS data through CSR but <b>NO Resource Optimized</b>.</li>
	<li> <b>Optimized</b> : <b>Resource Optimized</b> but limited programmability on ILAS data through CSR.<br> Only <b>L</b>, <b>F</b>, <b>K</b>, <b>M</b> and <b>SCR</b> are programmable through CSR.</li>
     </html>"
    }

    if {[expr {$param_name == "DID"}]} {
    add_display_item $tab_ip_tab3_grp2 "DID" PARAMETER 
    add_parameter "DID" INTEGER 0
    set_parameter_property "DID" DEFAULT_VALUE 0
    set_parameter_property "DID" DISPLAY_NAME "Device ID"
    set_parameter_property "DID" TYPE INTEGER
    set_parameter_property "DID" UNITS None
    set_parameter_property "DID" ALLOWED_RANGES 0:255
    set_parameter_property "DID" HDL_PARAMETER true
    set_parameter_property "DID" DESCRIPTION \
     "<html>
	Set the device ID number.<br>
	Supported range : 0-255.
     </html>"
    }

    if {[expr {$param_name == "BID"}]} {
    add_display_item $tab_ip_tab3_grp2 "BID" PARAMETER 
    add_parameter "BID" INTEGER 0
    set_parameter_property "BID" DEFAULT_VALUE 0
    set_parameter_property "BID" DISPLAY_NAME "Bank ID"
    set_parameter_property "BID" TYPE INTEGER
    set_parameter_property "BID" UNITS None
    set_parameter_property "BID" ALLOWED_RANGES 0:15
    set_parameter_property "BID" HDL_PARAMETER true
    set_parameter_property "BID" DESCRIPTION \
     "<html>
	Set the device bank ID number.<br>
	Supported range : 0-15.
     </html>"
    }

    if {[expr {$param_name == "LID0"}]} {
    add_display_item $tab_ip_tab3_grp3 "gui_lid0" text "<html><b>Lane 0</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID0" PARAMETER
    add_parameter "LID0" INTEGER 0
    set_parameter_property "LID0" DEFAULT_VALUE 0
    set_parameter_property "LID0" DISPLAY_NAME "Lane0 ID"
    set_parameter_property "LID0" TYPE INTEGER
    set_parameter_property "LID0" UNITS None
    set_parameter_property "LID0" ALLOWED_RANGES 0:31
    set_parameter_property "LID0" HDL_PARAMETER true
    set_parameter_property "LID0" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 0. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK0"}]} {
    add_display_item $tab_ip_tab3_grp3 "FCHK0" PARAMETER 
    add_parameter "FCHK0" INTEGER 0
    set_parameter_property "FCHK0" DEFAULT_VALUE 0
    set_parameter_property "FCHK0" DISPLAY_NAME "Lane0 checksum"
    set_parameter_property "FCHK0" TYPE INTEGER
    set_parameter_property "FCHK0" UNITS None
    set_parameter_property "FCHK0" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK0" HDL_PARAMETER true
    set_parameter_property "FCHK0" ENABLED false
    set_parameter_property "FCHK0" DERIVED true
    set_parameter_property "FCHK0" DESCRIPTION \
     "<html>
	Checksum for Lane 0. <br>
	Supported range : 0-255.
     </html>"
    }
    
    if {[expr {$param_name == "LID1"}]} {
    add_display_item $tab_ip_tab3_grp3 "gui_lid1" text "<html><b>Lane 1</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID1" PARAMETER 
    add_parameter "LID1" INTEGER 1
    set_parameter_property "LID1" DEFAULT_VALUE 1
    set_parameter_property "LID1" DISPLAY_NAME "Lane1 ID"
    set_parameter_property "LID1" TYPE INTEGER
    set_parameter_property "LID1" UNITS None
    set_parameter_property "LID1" ALLOWED_RANGES 0:31
    set_parameter_property "LID1" HDL_PARAMETER true
    set_parameter_property "LID1" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 1. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK1"}]} {
    add_display_item $tab_ip_tab3_grp3 "FCHK1" PARAMETER 
    add_parameter "FCHK1" INTEGER 0
    set_parameter_property "FCHK1" DEFAULT_VALUE 0
    set_parameter_property "FCHK1" DISPLAY_NAME "Lane1 checksum"
    set_parameter_property "FCHK1" TYPE INTEGER
    set_parameter_property "FCHK1" UNITS None
    set_parameter_property "FCHK1" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK1" HDL_PARAMETER true
    set_parameter_property "FCHK1" ENABLED false
    set_parameter_property "FCHK1" DERIVED true
    set_parameter_property "FCHK1" DESCRIPTION \
     "<html>
	Checksum for Lane 1. <br>
	Supported range : 0-255.
     </html>"
    }

    if {[expr {$param_name == "LID2"}]} {
    add_display_item $tab_ip_tab3_grp3 "gui_lid2" text "<html><b>Lane 2</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID2" PARAMETER 
    add_parameter "LID2" INTEGER 2
    set_parameter_property "LID2" DEFAULT_VALUE 2
    set_parameter_property "LID2" DISPLAY_NAME "Lane2 ID"
    set_parameter_property "LID2" TYPE INTEGER
    set_parameter_property "LID2" UNITS None
    set_parameter_property "LID2" ALLOWED_RANGES 0:31
    set_parameter_property "LID2" HDL_PARAMETER true
    set_parameter_property "LID2" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 2. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK2"}]} {
    add_parameter "FCHK2" INTEGER 0
    add_display_item $tab_ip_tab3_grp3 "FCHK2" PARAMETER 
    set_parameter_property "FCHK2" DEFAULT_VALUE 0
    set_parameter_property "FCHK2" DISPLAY_NAME "Lane2 checksum"
    set_parameter_property "FCHK2" TYPE INTEGER
    set_parameter_property "FCHK2" UNITS None
    set_parameter_property "FCHK2" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK2" HDL_PARAMETER true
    set_parameter_property "FCHK2" ENABLED false
    set_parameter_property "FCHK2" DERIVED true
    set_parameter_property "FCHK2" DESCRIPTION \
     "<html>
	Checksum for Lane 2. <br>
	Supported range : 0-255.
     </html>"
    }

    if {[expr {$param_name == "LID3"}]} { 
    add_display_item $tab_ip_tab3_grp3 "gui_lid3" text "<html><b>Lane 3</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID3" PARAMETER 
    add_parameter "LID3" INTEGER 3
    set_parameter_property "LID3" DEFAULT_VALUE 3
    set_parameter_property "LID3" DISPLAY_NAME "Lane3 ID"
    set_parameter_property "LID3" TYPE INTEGER
    set_parameter_property "LID3" UNITS None
    set_parameter_property "LID3" ALLOWED_RANGES 0:31
    set_parameter_property "LID3" AFFECTS_GENERATION true
    set_parameter_property "LID3" AFFECTS_VALIDATION true
    set_parameter_property "LID3" HDL_PARAMETER true
    set_parameter_property "LID3" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 3. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK3"}]} {  
    add_display_item $tab_ip_tab3_grp3 "FCHK3" PARAMETER 
    add_parameter "FCHK3" INTEGER 0
    set_parameter_property "FCHK3" DEFAULT_VALUE 0
    set_parameter_property "FCHK3" DISPLAY_NAME "Lane3 checksum"
    set_parameter_property "FCHK3" TYPE INTEGER
    set_parameter_property "FCHK3" UNITS None
    set_parameter_property "FCHK3" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK3" HDL_PARAMETER true
    set_parameter_property "FCHK3" ENABLED false
    set_parameter_property "FCHK3" DERIVED true
    set_parameter_property "FCHK3" DESCRIPTION \
     "<html>
	Checksum for Lane 3. <br>
	Supported range : 0-255.
     </html>"
    }

    if {[expr {$param_name == "LID4"}]} {  
    add_display_item $tab_ip_tab3_grp3 "gui_lid4" text "<html><b>Lane 4</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID4" PARAMETER 
    add_parameter "LID4" INTEGER 4
    set_parameter_property "LID4" DEFAULT_VALUE 4
    set_parameter_property "LID4" DISPLAY_NAME "Lane4 ID"
    set_parameter_property "LID4" TYPE INTEGER
    set_parameter_property "LID4" UNITS None
    set_parameter_property "LID4" ALLOWED_RANGES 0:31
    set_parameter_property "LID4" HDL_PARAMETER true
    set_parameter_property "LID4" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 4. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK4"}]} {  
    add_display_item $tab_ip_tab3_grp3 "FCHK4" PARAMETER 
    add_parameter "FCHK4" INTEGER 0
    set_parameter_property "FCHK4" DEFAULT_VALUE 0
    set_parameter_property "FCHK4" DISPLAY_NAME "Lane4 checksum"
    set_parameter_property "FCHK4" TYPE INTEGER
    set_parameter_property "FCHK4" UNITS None
    set_parameter_property "FCHK4" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK4" HDL_PARAMETER true
    set_parameter_property "FCHK4" ENABLED false
    set_parameter_property "FCHK4" DERIVED true
    set_parameter_property "FCHK4" DESCRIPTION \
     "<html>
	Checksum for Lane 4. <br>
	Supported range : 0-255.
     </html>"
    }
    
    if {[expr {$param_name == "LID5"}]} { 
    add_display_item $tab_ip_tab3_grp3 "gui_lid5" text "<html><b>Lane 5</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID5" PARAMETER 
    add_parameter "LID5" INTEGER 5
    set_parameter_property "LID5" DEFAULT_VALUE 5
    set_parameter_property "LID5" DISPLAY_NAME "Lane5 ID"
    set_parameter_property "LID5" TYPE INTEGER
    set_parameter_property "LID5" UNITS None
    set_parameter_property "LID5" ALLOWED_RANGES 0:31
    set_parameter_property "LID5" HDL_PARAMETER true
    set_parameter_property "LID5" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 5. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK5"}]} {  
    add_display_item $tab_ip_tab3_grp3 "FCHK5" PARAMETER 
    add_parameter "FCHK5" INTEGER 0
    set_parameter_property "FCHK5" DEFAULT_VALUE 0
    set_parameter_property "FCHK5" DISPLAY_NAME "Lane5 checksum"
    set_parameter_property "FCHK5" TYPE INTEGER
    set_parameter_property "FCHK5" UNITS None
    set_parameter_property "FCHK5" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK5" HDL_PARAMETER true
    set_parameter_property "FCHK5" ENABLED false
    set_parameter_property "FCHK5" DERIVED true
    set_parameter_property "FCHK5" DESCRIPTION \
     "<html>
	Checksum for Lane 5. <br>
	Supported range : 0-255.
     </html>"
    }

    if {[expr {$param_name == "LID6"}]} {
    add_display_item $tab_ip_tab3_grp3 "gui_lid6" text "<html><b>Lane 6</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID6" PARAMETER   
    add_parameter "LID6" INTEGER 6
    set_parameter_property "LID6" DEFAULT_VALUE 6
    set_parameter_property "LID6" DISPLAY_NAME "Lane6 ID"
    set_parameter_property "LID6" TYPE INTEGER
    set_parameter_property "LID6" UNITS None
    set_parameter_property "LID6" ALLOWED_RANGES 0:31
    set_parameter_property "LID6" HDL_PARAMETER true
    set_parameter_property "LID6" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 6. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK6"}]} {  
    add_display_item $tab_ip_tab3_grp3 "FCHK6" PARAMETER 
    add_parameter "FCHK6" INTEGER 0
    set_parameter_property "FCHK6" DEFAULT_VALUE 0
    set_parameter_property "FCHK6" DISPLAY_NAME "Lane6 checksum"
    set_parameter_property "FCHK6" TYPE INTEGER
    set_parameter_property "FCHK6" UNITS None
    set_parameter_property "FCHK6" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK6" HDL_PARAMETER true
    set_parameter_property "FCHK6" ENABLED false
    set_parameter_property "FCHK6" DERIVED true
    set_parameter_property "FCHK6" DESCRIPTION \
     "<html>
	Checksum for Lane 6. <br>
	Supported range : 0-255.
     </html>"
    }

    if {[expr {$param_name == "LID7"}]} {
    add_display_item $tab_ip_tab3_grp3 "gui_lid7" text "<html><b>Lane 7</b></html>"
    add_display_item $tab_ip_tab3_grp3 "LID7" PARAMETER 
    add_parameter "LID7" INTEGER 7
    set_parameter_property "LID7" DEFAULT_VALUE 7
    set_parameter_property "LID7" DISPLAY_NAME "Lane7 ID"
    set_parameter_property "LID7" TYPE INTEGER
    set_parameter_property "LID7" UNITS None
    set_parameter_property "LID7" ALLOWED_RANGES 0:31
    set_parameter_property "LID7" HDL_PARAMETER true
    set_parameter_property "LID7" DESCRIPTION \
     "<html>
	Set the lane ID number for Lane 7. <br>
	Supported range : 0-31.
     </html>"
    }

    if {[expr {$param_name == "FCHK7"}]} {
    add_display_item $tab_ip_tab3_grp3 "FCHK7" PARAMETER  
    add_parameter "FCHK7" INTEGER 0
    set_parameter_property "FCHK7" DEFAULT_VALUE 0
    set_parameter_property "FCHK7" DISPLAY_NAME "Lane7 checksum"
    set_parameter_property "FCHK7" TYPE INTEGER
    set_parameter_property "FCHK7" UNITS None
    set_parameter_property "FCHK7" ALLOWED_RANGES 0:255
    set_parameter_property "FCHK7" HDL_PARAMETER true
    set_parameter_property "FCHK7" ENABLED false
    set_parameter_property "FCHK7" DERIVED true
    set_parameter_property "FCHK7" DESCRIPTION \
     "<html>
	Checksum for Lane 7. <br>
	Supported range : 0-255.
     </html>"
    }

    #######################################################
    #            Hidden HDL Parameters
    #######################################################

    if {[expr {$param_name == "d_refclk_freq"}]} {
    add_parameter "d_refclk_freq" FLOAT 125.0
    add_display_item $tab_ip_hidden_grp "d_refclk_freq" PARAMETER 
#    set_parameter_property "d_refclk_freq" DEFAULT_VALUE 125.0
    set_parameter_property "d_refclk_freq" DISPLAY_NAME "PLL/CDR Reference Clock Frequency"
    set_parameter_property "d_refclk_freq" TYPE FLOAT
    set_parameter_property "d_refclk_freq" UNITS None
    set_parameter_property "d_refclk_freq" HDL_PARAMETER false
    set_parameter_property "d_refclk_freq" VISIBLE false 
    set_parameter_property "d_refclk_freq" DERIVED true
    }

    if {[expr {$param_name == "JESDV"}]} {
    add_display_item $tab_ip_hidden_grp "JESDV" PARAMETER  
    add_parameter "JESDV" INTEGER 1
    set_parameter_property "JESDV" DEFAULT_VALUE 1
    set_parameter_property "JESDV" TYPE INTEGER
    set_parameter_property "JESDV" UNITS None
    set_parameter_property "JESDV" ALLOWED_RANGES {1}
    set_parameter_property "JESDV" HDL_PARAMETER true
    set_parameter_property "JESDV" VISIBLE false
    }

    if {[expr {$param_name == "PMA_WIDTH"}]} { 
    add_display_item $tab_ip_hidden_grp "PMA_WIDTH" PARAMETER  
    add_parameter "PMA_WIDTH" INTEGER 32
    set_parameter_property "PMA_WIDTH" DEFAULT_VALUE 32
    set_parameter_property "PMA_WIDTH" TYPE INTEGER
    set_parameter_property "PMA_WIDTH" UNITS None
    set_parameter_property "PMA_WIDTH" ALLOWED_RANGES {16 32 40 80}
    set_parameter_property "PMA_WIDTH" HDL_PARAMETER true
    set_parameter_property "PMA_WIDTH" VISIBLE false
    set_parameter_property "PMA_WIDTH" DERIVED true
    }

    if {[expr {$param_name == "SER_SIZE"}]} {  
    add_display_item $tab_ip_hidden_grp "SER_SIZE" PARAMETER  
    add_parameter "SER_SIZE" INTEGER 4
    set_parameter_property "SER_SIZE" DEFAULT_VALUE 4
    set_parameter_property "SER_SIZE" DISPLAY_NAME "SER_SIZE"
    set_parameter_property "SER_SIZE" TYPE INTEGER
    set_parameter_property "SER_SIZE" UNITS None
    set_parameter_property "SER_SIZE" ALLOWED_RANGES {0 2 4}
    set_parameter_property "SER_SIZE" HDL_PARAMETER true
    set_parameter_property "SER_SIZE" VISIBLE false
    set_parameter_property "SER_SIZE" DERIVED true
    }
    
    if {[expr {$param_name == "FK"}]} { 
    add_display_item $tab_ip_hidden_grp "FK" PARAMETER  
    add_parameter "FK" INTEGER 64
    set_parameter_property "FK" DEFAULT_VALUE 64
    set_parameter_property "FK" DISPLAY_NAME "FK"
    set_parameter_property "FK" TYPE INTEGER
    set_parameter_property "FK" UNITS None
    set_parameter_property "FK" HDL_PARAMETER true
    set_parameter_property "FK" VISIBLE false
    set_parameter_property "FK" DERIVED true
    }
    
    if {[expr {$param_name == "RES1"}]} { 
    add_display_item $tab_ip_hidden_grp "RES1" PARAMETER  
    add_parameter "RES1" INTEGER 0
    set_parameter_property "RES1" DEFAULT_VALUE 0
    set_parameter_property "RES1" TYPE INTEGER
    set_parameter_property "RES1" UNITS None
    set_parameter_property "RES1" ALLOWED_RANGES 0:255
    set_parameter_property "RES1" HDL_PARAMETER true
    set_parameter_property "RES1" VISIBLE false
    }
    
    if {[expr {$param_name == "RES2"}]} { 
    add_display_item $tab_ip_hidden_grp "RES2" PARAMETER  
    add_parameter "RES2" INTEGER 0
    set_parameter_property "RES2" DEFAULT_VALUE 0
    set_parameter_property "RES2" TYPE INTEGER
    set_parameter_property "RES2" UNITS None
    set_parameter_property "RES2" ALLOWED_RANGES 0:255
    set_parameter_property "RES2" HDL_PARAMETER true
    set_parameter_property "RES2" VISIBLE false
    }
    
    if {[expr {$param_name == "BIT_REVERSAL"}]} {  
    add_display_item $tab_ip_hidden_grp "BIT_REVERSAL" PARAMETER  
    add_parameter "BIT_REVERSAL" INTEGER 0
    set_parameter_property "BIT_REVERSAL" DEFAULT_VALUE 0
    set_parameter_property "BIT_REVERSAL" TYPE INTEGER
    set_parameter_property "BIT_REVERSAL" UNITS None
    set_parameter_property "BIT_REVERSAL" ALLOWED_RANGES {0 1}
    set_parameter_property "BIT_REVERSAL" HDL_PARAMETER true
    set_parameter_property "BIT_REVERSAL" VISIBLE false
    set_parameter_property "BIT_REVERSAL" DERIVED true
    }
    
    if {[expr {$param_name == "BYTE_REVERSAL"}]} { 
    add_display_item $tab_ip_hidden_grp "BYTE_REVERSAL" PARAMETER  
    add_parameter "BYTE_REVERSAL" INTEGER 0
    set_parameter_property "BYTE_REVERSAL" DEFAULT_VALUE 0
    set_parameter_property "BYTE_REVERSAL" TYPE INTEGER
    set_parameter_property "BYTE_REVERSAL" UNITS None
    set_parameter_property "BYTE_REVERSAL" ALLOWED_RANGES {0 1}
    set_parameter_property "BYTE_REVERSAL" HDL_PARAMETER true
    set_parameter_property "BYTE_REVERSAL" VISIBLE false
    set_parameter_property "BYTE_REVERSAL" DERIVED true
    }
    
    if {[expr {$param_name == "ALIGNMENT_PATTERN"}]} {
    add_display_item $tab_ip_hidden_grp "ALIGNMENT_PATTERN" PARAMETER  
    # 658812 = A0D7C , 256773=3EB05  
    add_parameter "ALIGNMENT_PATTERN" INTEGER 658812
    set_parameter_property "ALIGNMENT_PATTERN" ALLOWED_RANGES {658812 256773}
    set_parameter_property "ALIGNMENT_PATTERN" HDL_PARAMETER true
    set_parameter_property "ALIGNMENT_PATTERN" VISIBLE false
    set_parameter_property "ALIGNMENT_PATTERN" DERIVED true
    lappend global_params "ALIGNMENT_PATTERN"
    }

    if {[expr {$param_name == "PULSE_WIDTH"}]} {
    add_display_item $tab_ip_hidden_grp "PULSE_WIDTH" PARAMETER  
    add_parameter "PULSE_WIDTH" INTEGER 4
    set_parameter_property "PULSE_WIDTH" HDL_PARAMETER true
    set_parameter_property "PULSE_WIDTH" VISIBLE false
    set_parameter_property "PULSE_WIDTH" DERIVED true
    }

    if {[expr {$param_name == "LS_FIFO_DEPTH"}]} {
    add_display_item $tab_ip_hidden_grp "LS_FIFO_DEPTH" PARAMETER  
    add_parameter "LS_FIFO_DEPTH" INTEGER 256
    set_parameter_property "LS_FIFO_DEPTH" HDL_PARAMETER true
    set_parameter_property "LS_FIFO_DEPTH" VISIBLE false
    set_parameter_property "LS_FIFO_DEPTH" DERIVED true
    }

    if {[expr {$param_name == "LS_FIFO_WIDTHU"}]} {
    add_display_item $tab_ip_hidden_grp "LS_FIFO_WIDTHU" PARAMETER  
    add_parameter "LS_FIFO_WIDTHU" INTEGER 8
    set_parameter_property "LS_FIFO_WIDTHU" HDL_PARAMETER true
    set_parameter_property "LS_FIFO_WIDTHU" VISIBLE false
    set_parameter_property "LS_FIFO_WIDTHU" DERIVED true
    }

    if {[expr {$param_name == "UNUSED_TX_PARALLEL_WIDTH"}]} {
    add_display_item $tab_ip_hidden_grp "UNUSED_TX_PARALLEL_WIDTH" PARAMETER  
    add_parameter "UNUSED_TX_PARALLEL_WIDTH" INTEGER 8
    set_parameter_property "UNUSED_TX_PARALLEL_WIDTH" HDL_PARAMETER true
    set_parameter_property "UNUSED_TX_PARALLEL_WIDTH" VISIBLE false
    set_parameter_property "UNUSED_TX_PARALLEL_WIDTH" DERIVED true
    }

    if {[expr {$param_name == "UNUSED_RX_PARALLEL_WIDTH"}]} {
    add_display_item $tab_ip_hidden_grp "UNUSED_RX_PARALLEL_WIDTH" PARAMETER  
    add_parameter "UNUSED_RX_PARALLEL_WIDTH" INTEGER 8
    set_parameter_property "UNUSED_RX_PARALLEL_WIDTH" HDL_PARAMETER true
    set_parameter_property "UNUSED_RX_PARALLEL_WIDTH" VISIBLE false
    set_parameter_property "UNUSED_RX_PARALLEL_WIDTH" DERIVED true
    }

    if {[expr {$param_name == "XCVR_PLL_LOCKED_WIDTH"}]} {
    add_display_item $tab_ip_hidden_grp "XCVR_PLL_LOCKED_WIDTH" PARAMETER  
    add_parameter "XCVR_PLL_LOCKED_WIDTH" INTEGER 1
    set_parameter_property "XCVR_PLL_LOCKED_WIDTH" HDL_PARAMETER true
    set_parameter_property "XCVR_PLL_LOCKED_WIDTH" VISIBLE false
    set_parameter_property "XCVR_PLL_LOCKED_WIDTH" DERIVED true
    }

    if {[expr {$param_name == "RECONFIG_ADDRESS_WIDTH"}]} {
    add_display_item $tab_ip_hidden_grp "RECONFIG_ADDRESS_WIDTH" PARAMETER  
    add_parameter "RECONFIG_ADDRESS_WIDTH" INTEGER 8
    set_parameter_property "RECONFIG_ADDRESS_WIDTH" HDL_PARAMETER true
    set_parameter_property "RECONFIG_ADDRESS_WIDTH" VISIBLE false
    set_parameter_property "RECONFIG_ADDRESS_WIDTH" DERIVED true
    }

    ############################################
    #        Hidden non-HDL Parameters
    ############################################
    if {[expr {$param_name == "sdc_constraint"}]} {  
    add_display_item $tab_ip_hidden_grp "sdc_constraint" PARAMETER  
    add_parameter "sdc_constraint" float 1.00
    set_parameter_property "sdc_constraint" DISPLAY_NAME "Set constraint for sdc"
    set_parameter_property "sdc_constraint" HDL_PARAMETER false
    set_parameter_property "sdc_constraint" VISIBLE false
    }

#################################################################
##-----------------JESD204 MegaCore Parameters-------------------
#################################################################
    if {[expr {$param_name == "TEST_COMPONENTS_EN"}]} {  
    add_display_item $tab_ip_tab4_grp1 "TEST_COMPONENTS_EN" PARAMETER  
    add_parameter "TEST_COMPONENTS_EN" boolean false
    set_parameter_property "TEST_COMPONENTS_EN" DISPLAY_NAME "Add Test Components"
    set_parameter_property "TEST_COMPONENTS_EN" HDL_PARAMETER false
    set_parameter_property "TEST_COMPONENTS_EN" VISIBLE true
    }
    if {[expr {$param_name == "TERMINATE_RECONFIG_EN"}]} {  
    add_display_item $tab_ip_tab4_grp1 "TERMINATE_RECONFIG_EN" PARAMETER  
    add_parameter "TERMINATE_RECONFIG_EN" boolean false
    set_parameter_property "TERMINATE_RECONFIG_EN" DISPLAY_NAME "Terminate Reconfig Signals"
    set_parameter_property "TERMINATE_RECONFIG_EN" HDL_PARAMETER false
    set_parameter_property "TERMINATE_RECONFIG_EN" VISIBLE true
    }

############################################
#        Example Design Parameters
############################################
    if {[expr {$param_name == "ED_TYPE"}]} {
    add_display_item $tab_ed_grp1 "ED_TYPE" PARAMETER
    add_display_item $tab_ed_grp1 "gui_ed_type" text ""
    add_parameter "ED_TYPE" STRING "NONE"
    set_parameter_property "ED_TYPE" DEFAULT_VALUE "NONE"
    set_parameter_property "ED_TYPE" DISPLAY_NAME "Select Design"
    set_parameter_property "ED_TYPE" ALLOWED_RANGES { "NONE:None" "NIOS:NIOS Control" "RTL:RTL State Machine Control" "DATAPATH:Data Path Only"}
    set_parameter_property "ED_TYPE" HDL_PARAMETER false
	set_parameter_property "ED_TYPE" DERIVED true
    set_parameter_property "ED_TYPE" DESCRIPTION \
     "<html><br>Select example design type</b>
	<ul>
	<li><b>None</b> : No example design matching the parameters selected is available. You may select a generic example design for generation. <b>Warning</b> : Generic example design parameters may not match the parameters selected for IP</li>
	<li><b>RTL State Machine Control</b> : Example design has RTL-based state machine as control unit</li>
	<li><b>NIOS Control</b> : Example design has NIOS-II processor as control unit</li>
	<li><b>Data Path Only</b> : Example design has data path only with System Console access</li>
	</ul>
     </html>"
    set_parameter_update_callback "ED_TYPE" update_fileset_sim_setting
    set_parameter_update_callback "ED_TYPE" update_nios_board_setting
    }
	
    if {$param_name == "ED_GENERIC_5SERIES"} {
        add_display_item $tab_ed_grp1 "ED_GENERIC_5SERIES" PARAMETER
        add_display_item $tab_ed_grp1 "gui_generic_ed_type" text ""
        
        add_parameter "ED_GENERIC_5SERIES" String No
        set_parameter_property "ED_GENERIC_5SERIES" VISIBLE        false
        set_parameter_property "ED_GENERIC_5SERIES" DISPLAY_NAME   "Generate generic example design?"
        set_parameter_property "ED_GENERIC_5SERIES" ALLOWED_RANGES {"No:No" "RTL:Generic RTL State Machine Control"}
        
        set_parameter_property "ED_GENERIC_5SERIES" DESCRIPTION \
            "<html>Select generic example design
                <ul>
                    <li><b>No</b> : No generic example design will be generated</li>
                    <li><b>Generic RTL State Machine Control</b> : Generate generic example design with RTL-based state machine as control unit</li>
                </ul>
            </html>"
    }
    
    if {$param_name == "ED_GENERIC_A10"} {
        add_display_item $tab_ed_grp1 "ED_GENERIC_A10" PARAMETER
        add_display_item $tab_ed_grp1 "gui_generic_ed_type" text ""
        
        add_parameter "ED_GENERIC_A10" String No
        set_parameter_property "ED_GENERIC_A10" VISIBLE        false
        set_parameter_property "ED_GENERIC_A10" DISPLAY_NAME   "Generate generic example design?"
        set_parameter_property "ED_GENERIC_A10" ALLOWED_RANGES {"No:No" "RTL:Generic RTL State Machine Control" "NIOS:Generic NIOS Control"}
        
        set_parameter_property "ED_GENERIC_A10" DESCRIPTION \
            "<html>Select generic example design
                <ul>
                    <li><b>No</b> : No generic example design will be generated</li>
                    <li><b>Generic RTL State Machine Control</b> : Generate generic example design with RTL-based state machine as control unit</li>
                    <li><b>Generic NIOS Control</b> : Generate generic example design with NIOS-II processsor as control unit</li>
                </ul>
            </html>"
    }
    
    if {$param_name == "ED_GENERIC_S10"} {
        add_display_item $tab_ed_grp1 "ED_GENERIC_S10" PARAMETER
        add_display_item $tab_ed_grp1 "gui_generic_ed_type" text ""
        
        add_parameter "ED_GENERIC_S10" String No
        set_parameter_property "ED_GENERIC_S10" VISIBLE        false
    }
    
    if {[expr {$param_name == "ED_FILESET_SIM"}]} {
    add_parameter "ED_FILESET_SIM" BOOLEAN false
    add_display_item $tab_ed_grp2 "ED_FILESET_SIM" PARAMETER 
    set_parameter_property "ED_FILESET_SIM" DISPLAY_NAME "Simulation"
    set_parameter_property "ED_FILESET_SIM" HDL_PARAMETER false
    set_parameter_property "ED_FILESET_SIM" DESCRIPTION \
     "<html>
	Generate simulation files
      </html>"
    
    }

    if {[expr {$param_name == "ED_FILESET_SYNTH"}]} {
    add_parameter "ED_FILESET_SYNTH" BOOLEAN false
    add_display_item $tab_ed_grp2 "ED_FILESET_SYNTH" PARAMETER 
    set_parameter_property "ED_FILESET_SYNTH" DISPLAY_NAME "Synthesis"
    set_parameter_property "ED_FILESET_SYNTH" HDL_PARAMETER false
    set_parameter_property "ED_FILESET_SYNTH" DESCRIPTION \
     "<html>
	Generate synthesis files
      </html>"
    }

    if {[expr {$param_name == "ED_HDL_FORMAT_SIM"}]} {
    add_display_item $tab_ed_grp3 "ED_HDL_FORMAT_SIM" PARAMETER
    add_parameter "ED_HDL_FORMAT_SIM" STRING "VERILOG"
    set_parameter_property "ED_HDL_FORMAT_SIM" DEFAULT_VALUE "VERILOG"
    set_parameter_property "ED_HDL_FORMAT_SIM" DISPLAY_NAME "HDL Format"
    set_parameter_property "ED_HDL_FORMAT_SIM" TYPE STRING
    set_parameter_property "ED_HDL_FORMAT_SIM" ALLOWED_RANGES { "VERILOG:Verilog" "VHDL:VHDL"}
    set_parameter_property "ED_HDL_FORMAT_SIM" HDL_PARAMETER false
    set_parameter_property "ED_HDL_FORMAT_SIM" DESCRIPTION \
     "<html>
	Select HDL format
	<ul>
	<li><b>Verilog</b> : Example design is in Verilog HDL format. Note that certain submodules may contain mixed format</li>
	<li><b>VHDL</b> : Example design is in VHDL format. Note that certain submodules may contain mixed format</li>
	</ul>
     </html>"
    }

    if {[expr {$param_name == "ED_HDL_FORMAT_SYNTH"}]} {
    add_display_item $tab_ed_grp4 "ED_HDL_FORMAT_SYNTH" PARAMETER
    add_parameter "ED_HDL_FORMAT_SYNTH" STRING "VERILOG"
    set_parameter_property "ED_HDL_FORMAT_SYNTH" DEFAULT_VALUE "VERILOG"
    set_parameter_property "ED_HDL_FORMAT_SYNTH" DISPLAY_NAME "HDL Format"
    set_parameter_property "ED_HDL_FORMAT_SYNTH" TYPE STRING
    set_parameter_property "ED_HDL_FORMAT_SYNTH" ALLOWED_RANGES { "VERILOG:Verilog"}
    set_parameter_property "ED_HDL_FORMAT_SYNTH" HDL_PARAMETER false
    set_parameter_property "ED_HDL_FORMAT_SYNTH" DESCRIPTION \
     "<html>
	Select HDL format
	<ul>
	<li><b>Verilog</b> : Example design is in Verilog HDL format. Note that certain submodules may contain mixed format</li>
	<li><b>VHDL</b> : Example design is in VHDL format. Note that certain submodules may contain mixed format</li>
	</ul>
     </html>"
    }

    if {[expr {$param_name == "ED_DEV_KIT"}]} {
    add_display_item $tab_ed_grp5 "ED_DEV_KIT" PARAMETER
    add_display_item $tab_ed_grp5 "gui_ed_dev_kit" text ""
    add_parameter "ED_DEV_KIT" STRING "NONE"
    set_parameter_property "ED_DEV_KIT" DEFAULT_VALUE "NONE"
    set_parameter_property "ED_DEV_KIT" DISPLAY_NAME "Select Board"
    set_parameter_property "ED_DEV_KIT" TYPE STRING
    set_parameter_property "ED_DEV_KIT" ALLOWED_RANGES { "NONE:None" "A10_FPGA:Arria 10 GX FPGA Development Kit" "S10_SI:Stratix 10 Signal Integrity Development Kit"}
    set_parameter_property "ED_DEV_KIT" HDL_PARAMETER false
    set_parameter_property "ED_DEV_KIT" DESCRIPTION \
     "<html>
	Select development kit
	<ul>
	<li><b>None</b> : Example design does not target any board</li>
	<li><b>Arria 10 GX FPGA Development Kit</b> : Example design is targetted for Arria 10 GX FPGA Development Kit. <b>Warning</b> : Target device of generated example design is for Arria 10 GX FPGA Development Kit and may not match your selected target device</li>
	<li><b>Stratix 10 Signal Integrity Development Kit</b> : Example design is targetted for Stratix 10 Signal Integrity Development Kit. <b>Warning</b> : Target device of generated example design is for Stratix 10 Signal Integrity Development Kit and may not match your selected target device</li>
	</ul>
     </html>"
    }
}

proc ::altera_jesd204::gui_params::params_top_hw {} {
# List down what parameters to add. 
  define_params "wrapper_opt" 
  define_params "sdc_constraint" 
  define_params "DEVICE_FAMILY" 
  define_params "part_trait_bd"
  define_params "part_trait_dp" 
  define_params "DATA_PATH" 
  define_params "SUBCLASSV" 
  define_params "lane_rate"
  define_params "PCS_CONFIG" 
  define_params "pll_type" 
  define_params "bonded_mode"
  define_params "REFCLK_FREQ" 
  define_params "bitrev_en" 
  define_params "pll_reconfig_enable" 
  define_params "rcfg_jtag_enable"
  define_params "rcfg_shared"
  define_params "set_capability_reg_enable"
  define_params "set_user_identifier"
  define_params "set_csr_soft_logic_enable"
  define_params "set_prbs_soft_logic_enable"
#  define_params "set_odi_soft_logic_enable"
  define_params "L" 
  define_params "M"
  define_params "GUI_EN_CFG_F" 
  define_params "GUI_CFG_F" 
  define_params "F" 
  define_params "N" 
  define_params "N_PRIME" 
  define_params "S" 
  define_params "K" 
  define_params "SCR" 
  define_params "CS" 
  define_params "CF" 
  define_params "HD"
  define_params "ECC_EN" 
  define_params "DLB_TEST" 
  define_params "PHADJ" 
  define_params "ADJCNT" 
  define_params "ADJDIR" 
  define_params "OPTIMIZE" 
  define_params "DID" 
  define_params "BID" 
  define_params "LID0" 
  define_params "FCHK0" 
  define_params "LID1" 
  define_params "FCHK1" 
  define_params "LID2" 
  define_params "FCHK2" 
  define_params "LID3" 
  define_params "FCHK3" 
  define_params "LID4" 
  define_params "FCHK4" 
  define_params "LID5" 
  define_params "FCHK5" 
  define_params "LID6" 
  define_params "FCHK6" 
  define_params "LID7" 
  define_params "FCHK7" 
  define_params "d_refclk_freq" 
  define_params "JESDV" 
  define_params "PMA_WIDTH" 
  define_params "SER_SIZE" 
  define_params "FK" 
  define_params "RES1" 
  define_params "RES2" 
  define_params "BIT_REVERSAL" 
  define_params "BYTE_REVERSAL" 
  define_params "ALIGNMENT_PATTERN" 
  define_params "PULSE_WIDTH" 
  define_params "LS_FIFO_DEPTH" 
  define_params "LS_FIFO_WIDTHU" 
  define_params "UNUSED_TX_PARALLEL_WIDTH"
  define_params "UNUSED_RX_PARALLEL_WIDTH" 
  define_params "XCVR_PLL_LOCKED_WIDTH"
  define_params "RECONFIG_ADDRESS_WIDTH"
  # Test Components parameters
  define_params "TEST_COMPONENTS_EN"
  define_params "TERMINATE_RECONFIG_EN"
  # Example Design parameters
  define_params "ED_TYPE"
  define_params "ED_GENERIC_5SERIES"
  define_params "ED_GENERIC_A10"
  define_params "ED_GENERIC_S10"
  define_params "ED_FILESET_SIM"
  define_params "ED_FILESET_SYNTH"
  define_params "ED_HDL_FORMAT_SIM"
  define_params "ED_HDL_FORMAT_SYNTH"
  define_params "ED_DEV_KIT"

# Define GUI Layout
  global tab_ip
  global tab_ip_grp
  global tab_ip_tab1
  global tab_ip_tab1_grp1
  global tab_ip_tab1_grp2
  global tab_ip_tab1_grp3
  global tab_ip_tab1_grp4
  global tab_ip_tab2
  global tab_ip_tab2_grp1
  global tab_ip_tab2_grp2
  global tab_ip_tab3
  global tab_ip_tab3_grp1
  global tab_ip_tab3_grp2
  global tab_ip_tab3_grp3
  global tab_ip_tab4
  global tab_ip_tab4_grp1
  global tab_ip_hidden_grp
  global tab_ed
  global tab_ed_grp1
  global tab_ed_grp2
  global tab_ed_grp3
  global tab_ed_grp4
  global tab_ed_grp5

  add_display_item "" $tab_ip GROUP "tab"
  add_display_item $tab_ip $tab_ip_grp GROUP
  add_display_item $tab_ip_grp $tab_ip_tab1 GROUP "tab"
  add_display_item $tab_ip_tab1 $tab_ip_tab1_grp1 GROUP
  add_display_item $tab_ip_tab1 $tab_ip_tab1_grp2 GROUP
  add_display_item $tab_ip_tab1 $tab_ip_tab1_grp3 GROUP 
  add_display_item $tab_ip_tab1 $tab_ip_tab1_grp4 GROUP
  add_display_item $tab_ip_grp $tab_ip_tab2 GROUP "tab"
  add_display_item $tab_ip_tab2 $tab_ip_tab2_grp1 GROUP 
  add_display_item $tab_ip_tab2 $tab_ip_tab2_grp2 GROUP 
  add_display_item $tab_ip_grp $tab_ip_tab3 GROUP "tab"
  add_display_item $tab_ip_tab3 $tab_ip_tab3_grp1 GROUP

  add_display_item "" $tab_ed GROUP "tab"
  add_display_item $tab_ed $tab_ed_grp1 GROUP
  add_display_item $tab_ed $tab_ed_grp2 GROUP
  add_display_item $tab_ed $tab_ed_grp3 GROUP
  add_display_item $tab_ed $tab_ed_grp4 GROUP
  add_display_item $tab_ed $tab_ed_grp5 GROUP

  # Hide OPTIMIZE options from customer for now FB:136867
  set_display_item_property $tab_ip_tab3_grp1 ENABLED false
  add_display_item $tab_ip_tab3 $tab_ip_tab3_grp2 GROUP 
  add_display_item $tab_ip_tab3 $tab_ip_tab3_grp3 GROUP 
  set_display_item_property $tab_ip_hidden_grp ENABLED false
  add_display_item $tab_ip_grp $tab_ip_tab4 GROUP "tab"
  add_display_item $tab_ip_tab4 $tab_ip_tab4_grp1 GROUP 
  # Hide this tab : This tab contains the parameters for test only
  set_display_item_property $tab_ip_tab4  VISIBLE false


# Add selected parameters
  global GLOBAL_PARAMS
  foreach params $GLOBAL_PARAMS {
  conf_params $params
  set_parameter_property $params AFFECTS_VALIDATION true
  set_parameter_property $params AFFECTS_GENERATION true
  set_parameter_property $params AFFECTS_ELABORATION true
  }

}

proc ::altera_jesd204::gui_params::params_tx_hw {} {
# List down what parameters to add. 
  define_params "wrapper_opt" 
  define_params "sdc_constraint" 	
  define_params "DEVICE_FAMILY" 
  define_params "DATA_PATH" 
  define_params "SUBCLASSV" 
  define_params "lane_rate" 
  define_params "pll_type" 
#  define_params "REFCLK_FREQ" 
  define_params "L" 
  define_params "M" 
  define_params "F" 
  define_params "N" 
  define_params "N_PRIME" 
  define_params "S" 
  define_params "K" 
  define_params "SCR" 
  define_params "CS" 
  define_params "CF" 
  define_params "HD" 
  define_params "ADJCNT" 
  define_params "ADJDIR" 
  define_params "PHADJ" 
  define_params "OPTIMIZE" 
  define_params "DID" 
  define_params "BID" 
  define_params "LID0" 
  define_params "FCHK0" 
  define_params "LID1"
  define_params "FCHK1"
  define_params "LID2" 
  define_params "FCHK2" 
  define_params "LID3" 
  define_params "FCHK3" 
  define_params "LID4" 
  define_params "FCHK4" 
  define_params "LID5" 
  define_params "FCHK5" 
  define_params "LID6" 
  define_params "FCHK6" 
  define_params "LID7" 
  define_params "FCHK7" 
  define_params "JESDV"  
  define_params "PMA_WIDTH" 
  define_params "SER_SIZE" 
  define_params "FK" 
  define_params "RES1"
  define_params "RES2" 
  define_params "BIT_REVERSAL" 
  define_params "BYTE_REVERSAL" 
  define_params "PULSE_WIDTH" 

   # Add selected parameters
  global GLOBAL_PARAMS
  foreach params $GLOBAL_PARAMS {
  conf_params $params
  set_parameter_property $params AFFECTS_GENERATION true
  set_parameter_property $params AFFECTS_VALIDATION false
  set_parameter_property $params AFFECTS_ELABORATION true
  set_parameter_property $params DERIVED false
  set_parameter_property $params VISIBLE true
     if {[ expr {$params == "sdc_constraint"}]} {
     set_parameter_property $params VISIBLE false
     }
  }
}

proc ::altera_jesd204::gui_params::params_tx_mlpcs_hw {} {
# List down what parameters to add. 
 
   define_params "wrapper_opt" 
   define_params "sdc_constraint" 	
   define_params "DEVICE_FAMILY" 
   define_params "DATA_PATH" 
   define_params "lane_rate" 
#   define_params "REFCLK_FREQ" 
   define_params "d_refclk_freq" 
   define_params "L" 
   define_params "PCS_CONFIG" 
   define_params "PMA_WIDTH" 
   define_params "SER_SIZE"
   define_params "TEST_COMPONENTS_EN"
   define_params "pll_reconfig_enable"
   define_params "rcfg_shared"

   # Add selected parameters 
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params AFFECTS_VALIDATION false
   set_parameter_property $params AFFECTS_ELABORATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
      if {[ expr {$params == "sdc_constraint"}]} {
      set_parameter_property $params VISIBLE false
      }
   }
}

proc ::altera_jesd204::gui_params::params_phy_hw {} {
# List down what parameters to add. 
 
   define_params "wrapper_opt" 
   define_params "sdc_constraint" 	
   define_params "DEVICE_FAMILY" 
   define_params "DATA_PATH" 
   define_params "lane_rate" 
   define_params "pll_reconfig_enable"
   define_params "rcfg_jtag_enable"
   define_params "rcfg_shared"
   define_params "set_capability_reg_enable"
   define_params "set_user_identifier"
   define_params "set_csr_soft_logic_enable"
   define_params "set_prbs_soft_logic_enable"
#   define_params "set_odi_soft_logic_enable"
#   define_params "REFCLK_FREQ" 
   define_params "d_refclk_freq" 
   define_params "pll_type"
   define_params "bonded_mode"
   define_params "L" 
   define_params "PCS_CONFIG" 
   define_params "PMA_WIDTH" 
   define_params "SER_SIZE" 
   define_params "BIT_REVERSAL" 
   define_params "ALIGNMENT_PATTERN" 
   define_params "UNUSED_TX_PARALLEL_WIDTH"
   define_params "UNUSED_RX_PARALLEL_WIDTH" 
   define_params "XCVR_PLL_LOCKED_WIDTH"  
   define_params "RECONFIG_ADDRESS_WIDTH"
   define_params "TEST_COMPONENTS_EN"

# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
      if {[ expr {$params == "BIT_REVERSAL"}]} {
      set_parameter_property $params HDL_PARAMETER false
      }
   }
}

proc ::altera_jesd204::gui_params::params_phy_adapter_hw {} {
# List down what parameters to add. 
   define_params "L" 
   define_params "PCS_CONFIG" 
   define_params "DATA_PATH" 
   define_params "DEVICE_FAMILY" 
   define_params "UNUSED_TX_PARALLEL_WIDTH"
   define_params "UNUSED_RX_PARALLEL_WIDTH" 
   define_params "XCVR_PLL_LOCKED_WIDTH"
   define_params "RECONFIG_ADDRESS_WIDTH"
   define_params "bonded_mode"
   define_params "pll_reconfig_enable"

# Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION false
   set_parameter_property $params AFFECTS_VALIDATION false
   set_parameter_property $params AFFECTS_ELABORATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
      if {[ expr {$params == "DEVICE_FAMILY"}]} {
      set_parameter_property $params AFFECTS_GENERATION true
      }
   }
}

proc ::altera_jesd204::gui_params::params_rx_hw {} {
# List down what parameters to add. 

   define_params "wrapper_opt" 
   define_params "sdc_constraint" 	
   define_params "DEVICE_FAMILY"
   define_params "DATA_PATH" 
   define_params "SUBCLASSV" 
   define_params "lane_rate" 
#  define_params "REFCLK_FREQ" 
   define_params "L" 
   define_params "M" 
   define_params "F" 
   define_params "N" 
   define_params "N_PRIME" 
   define_params "S" 
   define_params "K" 
   define_params "SCR" 
   define_params "CS" 
   define_params "CF" 
   define_params "HD" 
   define_params "ECC_EN" 
   define_params "DLB_TEST" 
   define_params "JESDV" 
   define_params "FK" 
   define_params "BIT_REVERSAL" 
   define_params "BYTE_REVERSAL" 
   define_params "PULSE_WIDTH" 
   define_params "LS_FIFO_DEPTH" 
   define_params "LS_FIFO_WIDTHU" 

   # Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params AFFECTS_VALIDATION false
   set_parameter_property $params AFFECTS_ELABORATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
      if {[ expr {$params == "sdc_constraint"}]} {
      set_parameter_property $params VISIBLE false
      }      
   }
}

proc ::altera_jesd204::gui_params::params_rx_mlpcs_hw {} {
# List down what parameters to add. 

   define_params "wrapper_opt" 
   define_params "sdc_constraint" 	
   define_params "DEVICE_FAMILY" 
   define_params "DATA_PATH" 
   define_params "lane_rate" 
#   define_params "REFCLK_FREQ" 
   define_params "d_refclk_freq" 
   define_params "L" 
   define_params "PCS_CONFIG" 
   define_params "PMA_WIDTH" 
   define_params "SER_SIZE" 
   define_params "ALIGNMENT_PATTERN" 
   define_params "TEST_COMPONENTS_EN"
   define_params "pll_reconfig_enable"
   define_params "rcfg_shared"

   # Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params AFFECTS_VALIDATION false
   set_parameter_property $params AFFECTS_ELABORATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   }
}

proc ::altera_jesd204::gui_params::params_pll_wrapper_hw {} {
# List down what parameters to add. 

   define_params "lane_rate" 
   define_params "L" 
   define_params "bonded_mode"
   define_params "PCS_CONFIG" 
   define_params "DEVICE_FAMILY"
   define_params "REFCLK_FREQ"

   # Add selected parameters
   global GLOBAL_PARAMS
   foreach params $GLOBAL_PARAMS {
   conf_params $params
   set_parameter_property $params AFFECTS_GENERATION true
   set_parameter_property $params DERIVED false
   set_parameter_property $params VISIBLE true
   }
}


proc define_params {param_name} {
   global GLOBAL_PARAMS
   lappend GLOBAL_PARAMS $param_name
}

proc update_fileset_sim_setting {arg} {
   set ED_TYPE [get_parameter_value $arg]
   if {[expr {$ED_TYPE == "NIOS"}]} {
      set_parameter_value ED_FILESET_SIM false
   } 
   if {[expr {$ED_TYPE == "NONE"}]} {
     set_parameter_value ED_FILESET_SYNTH false
     set_parameter_value ED_FILESET_SIM false
   }
}

proc update_nios_board_setting {arg} {
   set ED_TYPE [get_parameter_value $arg]
   if {[expr {$ED_TYPE == "NONE"}] || [expr {$ED_TYPE == "RTL"}]} {
     set_parameter_value ED_DEV_KIT "NONE"
   }
}
