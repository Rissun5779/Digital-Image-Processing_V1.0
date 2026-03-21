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


# (C) 2001-2010 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.

# +-----------------------------------
# | Request TCL package from ACDS 14.0
# | 
package require -exact qsys 14.0
package ifneeded altera_iopll_reconfig::mif_validation 14.0 [list source iopll_reconfig_hw_mif_validation.tcl]
package require altera_iopll_reconfig::mif_validation 14.0 
package require Itcl
# | 
# +-----------------------------------

## Main altera IOPLL reconfig namespace
namespace eval altera_iopll_reconfig {

    proc declare_module {} {
        # +-----------------------------------
        # | Adding basic module properties
        # +------------------------------------ 
        set_module_property NAME                       altera_iopll_reconfig
        set_module_property VERSION                    18.1
        set_module_property INTERNAL                   false
        set_module_property SUPPORTED_DEVICE_FAMILIES  {"STRATIX 10"}
        set_module_property GROUP                      "Basic Functions/Clocks; PLLs and Resets/PLL"
        set_module_property AUTHOR                     "Intel Corporation"
        set_module_property DISPLAY_NAME               "IOPLL Reconfig Intel FPGA IP"
        set_module_property DESCRIPTION                "Intel Phase-Locked Loop Reconfiguration Block"
        set_module_property DATASHEET_URL              ""
        set_module_property EDITABLE                   true
        set_module_property ELABORATION_CALLBACK       elaboration_callback
        set_module_property VALIDATION_CALLBACK        validation_callback
    }

    proc declare_filesets {} {
         add_fileset     quartus_synth   QUARTUS_SYNTH  do_quartus_synth
         set_fileset_property quartus_synth TOP_LEVEL altera_iopll_reconfig_top
         add_fileset     sim_vhdl        SIM_VHDL       do_quartus_synth
         set_fileset_property sim_vhdl TOP_LEVEL altera_iopll_reconfig_top
         add_fileset     sim_verilog     SIM_VERILOG    do_quartus_synth 
         set_fileset_property sim_verilog TOP_LEVEL altera_iopll_reconfig_top
    }

   proc create_display_items {} {
        add_display_item       ""                     "Reconfig IP Instantiation"   GROUP    tab 
        add_display_item       "Reconfig IP Instantiation"                     "System Parameters"          GROUP    ""
        create_system_info_parameters
        add_display_item       "Reconfig IP Instantiation"                     "MIF File"                    GROUP    ""

        create_mif_file_parameters
        create_physical_parameters
        create_misc_parameters

        add_display_item       "MIF File"             "mif_out_table"         GROUP    TABLE        
        set_display_item_property   "mif_out_table" DISPLAY_HINT "table fixed_size rows:25"
        create_table_parameters
    }

    proc create_system_info_parameters {} {
        # +-----------------------------------
        # | Adding system info parameters to GUI
        # +------------------------------------ 
        add_parameter           device_family   STRING             
        set_parameter_property  device_family   HDL_PARAMETER      true
        set_parameter_property  device_family   VISIBLE            false
        set_parameter_property  device_family   ENABLED            false
        set_parameter_property  device_family   SYSTEM_INFO        DEVICE_FAMILY
        set_parameter_property  device_family   DISPLAY_NAME       "Device Family"
        add_display_item "System Parameters" device_family parameter

        add_parameter           gui_device_family   STRING             ""
        set_parameter_property  gui_device_family   VISIBLE            true
        set_parameter_property  gui_device_family   ENABLED            false
        set_parameter_property  gui_device_family   DERIVED            true
        set_parameter_property  gui_device_family   DISPLAY_NAME       "Device Family"
        set_parameter_property  gui_device_family   DEFAULT_VALUE      ""
        set_parameter_property  gui_device_family   ALLOWED_RANGES     ""
        set_parameter_property  gui_device_family   DESCRIPTION        "Device Family: Currently this IP is only available for Stratix 10"
        add_display_item "System Parameters" gui_device_family parameter
    }

   proc create_mif_file_parameters {} {

        add_parameter           gui_reconfig_mif_filename STRING             "~/pll.mif"
        set_parameter_property  gui_reconfig_mif_filename VISIBLE            true
        set_parameter_property  gui_reconfig_mif_filename ENABLED            true
        set_parameter_property  gui_reconfig_mif_filename DISPLAY_NAME       "MIF file path"
        set_parameter_property  gui_reconfig_mif_filename DESCRIPTION        "Path of MIF file to be read by the altera_iopll_reconfig IP generated."
        add_display_item        "MIF File"            gui_reconfig_mif_filename parameter


        add_parameter           gui_wait_for_lock     BOOLEAN            false
        set_parameter_property  gui_wait_for_lock     VISIBLE            true
        set_parameter_property  gui_wait_for_lock     ENABLED            true
        set_parameter_property  gui_wait_for_lock     DISPLAY_NAME       "Assert waitrequest until IOPLL has locked"
        set_parameter_property  gui_wait_for_lock     DESCRIPTION        "With this option selected, in MIF streaming, Advanced mode, and Gating mode, the Altera IOPLL Reconfig IP will only desassert waitrequest when the IOPLL has locked. Otherwise, the changes may not have been taken into effect when waitrequest is deasserted."
        add_display_item        "MIF File"            gui_wait_for_lock       parameter
    }


    proc create_physical_parameters {} {
        # +-----------------------------------
        # | Adding all physical parameters
        # +------------------------------------ 
        
        # DPRIO_ADDR_WIDTH
        add_parameter          DPRIO_ADDR_WIDTH INTEGER             10
        set_parameter_property DPRIO_ADDR_WIDTH HDL_PARAMETER       true
        set_parameter_property DPRIO_ADDR_WIDTH VISIBLE             false
        set_parameter_property DPRIO_ADDR_WIDTH AFFECTS_ELABORATION true
        set_parameter_property DPRIO_ADDR_WIDTH DERIVED             true
        add_display_item "System Parameters" DPRIO_ADDR_WIDTH parameter

        # DPRIO_DATA_WIDTH
        add_parameter DPRIO_DATA_WIDTH INTEGER                      8
        set_parameter_property DPRIO_DATA_WIDTH HDL_PARAMETER       true
        set_parameter_property DPRIO_DATA_WIDTH VISIBLE false
        set_parameter_property DPRIO_DATA_WIDTH AFFECTS_ELABORATION true
        set_parameter_property DPRIO_DATA_WIDTH DERIVED             true
        add_display_item "System Parameters" DPRIO_DATA_WIDTH parameter

        # DPRIO_MODE_SEL_WIDTH
        add_parameter          DPRIO_MODE_SEL_WIDTH INTEGER             2
        set_parameter_property DPRIO_MODE_SEL_WIDTH HDL_PARAMETER       true
        set_parameter_property DPRIO_MODE_SEL_WIDTH VISIBLE             false
        set_parameter_property DPRIO_MODE_SEL_WIDTH AFFECTS_ELABORATION true
        set_parameter_property DPRIO_MODE_SEL_WIDTH DERIVED             true
        add_display_item "System Parameters" DPRIO_MODE_SEL_WIDTH parameter

        # ROM_ADDR_WIDTH
        add_parameter          ROM_ADDR_WIDTH INTEGER             6
        set_parameter_property ROM_ADDR_WIDTH HDL_PARAMETER       true
        set_parameter_property ROM_ADDR_WIDTH VISIBLE             false
        set_parameter_property ROM_ADDR_WIDTH AFFECTS_ELABORATION true
        set_parameter_property ROM_ADDR_WIDTH DERIVED             true
        add_display_item "System Parameters" ROM_ADDR_WIDTH parameter

        # ROM_DATA_WIDTH
        add_parameter          ROM_DATA_WIDTH INTEGER             16
        set_parameter_property ROM_DATA_WIDTH HDL_PARAMETER       true
        set_parameter_property ROM_DATA_WIDTH VISIBLE             false
        set_parameter_property ROM_DATA_WIDTH AFFECTS_ELABORATION true
        set_parameter_property ROM_DATA_WIDTH DERIVED             true
        add_display_item "System Parameters" ROM_DATA_WIDTH parameter

        # ROM_NUM_WORDS
        add_parameter          ROM_NUM_WORDS INTEGER             512
        set_parameter_property ROM_NUM_WORDS HDL_PARAMETER       true
        set_parameter_property ROM_NUM_WORDS VISIBLE             false
        set_parameter_property ROM_NUM_WORDS AFFECTS_ELABORATION true
        set_parameter_property ROM_NUM_WORDS DERIVED             true
        add_display_item "System Parameters" ROM_NUM_WORDS parameter

        # Reconf to PLL  Width
        add_parameter          TO_PLL_WIDTH INTEGER                 30 
        set_parameter_property TO_PLL_WIDTH HDL_PARAMETER           true
        set_parameter_property TO_PLL_WIDTH VISIBLE                 false
        set_parameter_property TO_PLL_WIDTH AFFECTS_ELABORATION     true
        set_parameter_property TO_PLL_WIDTH DERIVED                 true
        add_display_item "System Parameters" TO_PLL_WIDTH parameter

        # Reconf from PLL  Width
        add_parameter          FROM_PLL_WIDTH INTEGER               10 
        set_parameter_property FROM_PLL_WIDTH HDL_PARAMETER         true
        set_parameter_property FROM_PLL_WIDTH VISIBLE               false
        set_parameter_property FROM_PLL_WIDTH AFFECTS_ELABORATION   true
        set_parameter_property FROM_PLL_WIDTH DERIVED               true
        add_display_item "System Parameters"  FROM_PLL_WIDTH parameter

        # DPRIO_GATING_ADDR (00010110 -> 22)
        add_parameter          DPRIO_GATING_ADDR  INTEGER                22
        set_parameter_property DPRIO_GATING_ADDR  HDL_PARAMETER         true
        set_parameter_property DPRIO_GATING_ADDR  VISIBLE               false
        set_parameter_property DPRIO_GATING_ADDR  AFFECTS_ELABORATION   true
        set_parameter_property DPRIO_GATING_ADDR  DERIVED               true
        add_display_item "System Parameters"  DPRIO_GATING_ADDR  parameter

        # MIF_EOF (For s10, 1111111111111111 => 65535)
        add_parameter          MIF_EOF  INTEGER                65535
        set_parameter_property MIF_EOF  HDL_PARAMETER         true
        set_parameter_property MIF_EOF  VISIBLE               false
        set_parameter_property MIF_EOF  AFFECTS_ELABORATION   true
        set_parameter_property MIF_EOF  DERIVED               true
        add_display_item "System Parameters"  MIF_EOF  parameter

        # +-----------------------------------
        # | Parameters that depend on GUI selections
        # +------------------------------------ 

        # Wait for lock
        add_parameter          WAIT_FOR_LOCK  STRING                "false"
        set_parameter_property WAIT_FOR_LOCK  HDL_PARAMETER         true
        set_parameter_property WAIT_FOR_LOCK  VISIBLE               false
        set_parameter_property WAIT_FOR_LOCK  AFFECTS_ELABORATION   true
        set_parameter_property WAIT_FOR_LOCK  DERIVED               true
        add_display_item "System Parameters" WAIT_FOR_LOCK          parameter

        # MIF Filename
        add_parameter           reconfig_mif_filename STRING             "RECONFIG_MIF.mif"
        set_parameter_property  reconfig_mif_filename HDL_PARAMETER      true
        set_parameter_property  reconfig_mif_filename VISIBLE            false
        set_parameter_property  reconfig_mif_filename AFFECTS_ELABORATION   true
        set_parameter_property  reconfig_mif_filename DERIVED               true
        add_display_item        "MIF File"            reconfig_mif_filename parameter

        altera_iopll_reconfig::add_multiple_parameters MIF_ADDRESS_# 0 INTEGER false true false true "" "" "System Parameters" 32
    }
    proc create_misc_parameters {} {
        # +-----------------------------------
        # | Adding all physical parameters
        # +------------------------------------ 
        
        # DPRIO_ADDR_WIDTH
        add_parameter          debug_mode BOOLEAN             false
        set_parameter_property debug_mode HDL_PARAMETER       false
        set_parameter_property debug_mode VISIBLE             false
        set_parameter_property debug_mode AFFECTS_ELABORATION true
        set_parameter_property debug_mode DERIVED             false
    }
 
    proc create_table_parameters {} {
        # +-----------------------------------
        # | Adding all physical parameters
        # +------------------------------------ 
        
        # RECONFIG_ADDR_WIDTH

        add_parameter          table_names  STRING_LIST             
        set_parameter_property table_names  DERIVED             true
        set_parameter_property table_names  DISPLAY_HINT        "width:200"
        set_parameter_property table_names  DISPLAY_NAME        "MIF File Property"
        add_display_item mif_out_table table_names parameter

        add_parameter          table_values  STRING_LIST             
        set_parameter_property table_values  DERIVED             true
        set_parameter_property table_values  DISPLAY_HINT        "width:200"
        set_parameter_property table_values  DISPLAY_NAME        "Value"
        add_display_item mif_out_table table_values parameter
    }

    proc add_static_interfaces {} {
        # +-----------------------------------
        # | Adding the clock interface mgmt_clk
        # +------------------------------------ 
        add_interface mgmt_clk clock sink
        add_interface_port mgmt_clk mgmt_clk clk input 1
        # +-----------------------------------
        # | Adding the reset interface mgmt_reset with associate clk mgmt_clk
        # +------------------------------------ 
        add_interface mgmt_reset reset sink mgmt_clk
        add_interface_port mgmt_reset mgmt_reset reset input 1
        # +-----------------------------------
        # | Adding the avalon interface
        # +------------------------------------ 
        add_interface mgmt_avalon_slave avalon slave
        set_interface_property mgmt_avalon_slave associatedClock mgmt_clk
        set_interface_property mgmt_avalon_slave associatedReset mgmt_reset
        set_interface_property mgmt_avalon_slave readLatency 0
        add_interface_port mgmt_avalon_slave mgmt_waitrequest waitrequest output 1
        add_interface_port mgmt_avalon_slave mgmt_write write     input 1
        add_interface_port mgmt_avalon_slave mgmt_read  read      input 1
        # +-----------------------------------
        # | Adding connections to and from the IOPLL
        # +------------------------------------ 
        add_interface reconfig_to_pll conduit start
        set_interface_assignment reconfig_to_pll "ui.blockdiagram.direction" OUTPUT
        add_interface reconfig_from_pll conduit end
        set_interface_assignment reconfig_from_pll "ui.blockdiagram.direction" INPUT
    }

    proc add_multiple_parameters { name default_string type visible hdl enabled derived display_name description tab instances} {
    	for {set i 0} {$i < $instances} {incr i} {
            regsub -all "#" $name $i name_with_sub
            regsub -all "#" $default_string $i default_with_sub
            regsub -all "#" $display_name $i display_name_with_sub
            regsub -all "#" $description  $i description_with_sub
            add_parameter           $name_with_sub            $type              $default_with_sub
            set_parameter_property  $name_with_sub            VISIBLE            $visible
            set_parameter_property  $name_with_sub            HDL_PARAMETER      $hdl
            set_parameter_property  $name_with_sub            ENABLED            $enabled
            set_parameter_property  $name_with_sub            DERIVED            $derived
            set_parameter_property  $name_with_sub            DISPLAY_NAME       $display_name_with_sub
            set_parameter_property  $name_with_sub            DESCRIPTION        $description_with_sub
            add_display_item        $tab                      $name_with_sub     parameter
        }
    }

}

altera_iopll_reconfig::create_display_items
altera_iopll_reconfig::declare_module
altera_iopll_reconfig::add_static_interfaces
altera_iopll_reconfig::declare_filesets

# +-----------------------------------
# | VALIDATION CALLBACK
# +------------------------------------ 
proc validation_callback {} {


    # +-----------------------------------
    # | Ensure that the family is legal
    # +------------------------------------ 
    set supported_families [list "Stratix 10"]
	set current_family [get_parameter_value device_family]
	if {[lsearch $supported_families $current_family] == -1} {
		send_message ERROR "The selected device family is not supported. Please select $supported_families or use altera_pll_reconfig IP."
	} else {
        set_parameter_value gui_device_family $current_family
    }

    # +-----------------------------------
    # | Validate MIF File
    # +------------------------------------ 
    set orig_name [get_parameter_value gui_reconfig_mif_filename]
    set new_name [file normalize $orig_name]

    set debug_mode [get_parameter_value debug_mode]
    if {$debug_mode} {
        global env
        set cwd $env(PWD)
        set mif_base_name [file tail $new_name]
        set new_name [file join $cwd $mif_base_name]
        set_parameter_value reconfig_mif_filename $mif_base_name
    } else {
        set_parameter_value reconfig_mif_filename $new_name
    }
    set reconfig_mif_file_path $new_name

    if { $orig_name == "" } {
        send_message ERROR "Please provide a path to the MIF file that describes the original configuration of the IOPLL."
    }  elseif {![file exists $reconfig_mif_file_path]} {
        # TODO: Reduce this to warning.
        send_message ERROR "File $reconfig_mif_file_path does not exist."
    }  else {
        send_message INFO "Validating MIF file: In order for validation to be meaningful, the original configuration of the IOPLL must be included in the MIF file."
        set ROM_width [expr {[get_parameter_value DPRIO_ADDR_WIDTH] + [get_parameter_value DPRIO_DATA_WIDTH] -1}]
        set valid_mif_list [altera_iopll_reconfig::mif_validation::validate_reconfig_mif_file \
                            $reconfig_mif_file_path $ROM_width]
        set valid_mif [lindex $valid_mif_list 0]
        set_parameter_value table_names [lindex $valid_mif_list 1]
        set_parameter_value table_values [lindex $valid_mif_list 2]
        set config_indices [lindex $valid_mif_list 3]
        set mif_depth [lindex $valid_mif_list 4]

        foreach {config_index_pair} $config_indices {
            set config_index_name [lindex $config_index_pair 0]
            set config_index_value [lindex $config_index_pair 1]
            send_message INFO "$config_index_name: $config_index_value"
            set_parameter_value $config_index_name $config_index_value
        } 


        if {!$valid_mif} {
            send_message ERROR "Invalid MIF File: MIF file validation was not successful. Generate the MIF file using the altera_iopll IP GUI to ensure the MIF file format is legal"
        } else {
            send_message INFO "Validating MIF file: The MIF file is valid."
        }

        set_parameter_value ROM_NUM_WORDS $mif_depth
        set_parameter_value ROM_ADDR_WIDTH [expr {ceil(log($mif_depth)/log(2))}]

        set_display_item_property "mif_out_table" VISIBLE  true
    }
           

    # +-----------------------------------
    # | Set physical parameters
    # +------------------------------------
 
    set wait [get_parameter_value gui_wait_for_lock]
    if {$wait} {
        set_parameter_value WAIT_FOR_LOCK true
    } else {
        set_parameter_value WAIT_FOR_LOCK false
    }
}

# +-----------------------------------
# | ELABORATION CALLBACK
# +------------------------------------
proc elaboration_callback {} {

   # +-----------------------------------
   # | Some interfaces are static, and are added above in add_static_interfaces.
   # | Others depend on parameters and must be added during elaboration.
   # +------------------------------------ 

   # This may later depend on family...
    set w_wd 8
    set w_add 8
    set reconf_to_width_val 30
    set reconf_from_width_val 10

    add_interface_port mgmt_avalon_slave mgmt_writedata       writedata         input   8
    add_interface_port mgmt_avalon_slave mgmt_readdata        readdata          output  8
    add_interface_port mgmt_avalon_slave mgmt_address         address           input   [expr {$w_add+2}]
    add_interface_port reconfig_to_pll   reconfig_to_pll      reconfig_to_pll   output   $reconf_to_width_val
    add_interface_port reconfig_from_pll reconfig_from_pll  reconfig_from_pll   input  $reconf_from_width_val
	
    # Set Bus width values
    set_parameter_value DPRIO_ADDR_WIDTH $w_add
    set_parameter_value DPRIO_DATA_WIDTH $w_wd
    set_parameter_value TO_PLL_WIDTH     $reconf_to_width_val
    set_parameter_value FROM_PLL_WIDTH   $reconf_from_width_val
}

# +-----------------------------------
# | GENERATION CALLBACK
# +------------------------------------
proc generation_callback {} {
	send_message info "Starting Generation"

	set language [get_generation_property HDL_LANGUAGE]
	set outdir [get_generation_property OUTPUT_DIRECTORY ]
	set outputname [get_generation_property OUTPUT_NAME ]
    	
}


proc do_quartus_synth { name } {
    set filename ${name}.sv
    add_fileset_file $filename SYSTEMVERILOG PATH altera_iopll_reconfig_top.sv
    add_fileset_file altera_iopll_reconfig_fsm.sv SYSTEMVERILOG PATH altera_iopll_reconfig_fsm.sv
    set curr [pwd]
    # It might take a few tries to find the synchronizer
    set synch_path_cust  [file join $curr .. primitives altera_std_synchronizer altera_std_synchronizer.v]
    set synch_path_debug_0  [file join $curr .. .. .. acds ip altera primitives altera_std_synchronizer altera_std_synchronizer.v]
    set synch_path_debug_1 [file join $curr .. sopc components primitives altera_std_synchronizer altera_std_synchronizer.v]
    set synch_path_debug_2 [file join $curr .. .. .. p4 ip sopc components primitives altera_std_synchronizer altera_std_synchronizer.v]
    if {[file exists $synch_path_cust]} {
        add_fileset_file altera_std_synchronizer.v VERILOG PATH $synch_path_cust
    } elseif {[file exists $synch_path_debug_0]} {
        add_fileset_file altera_std_synchronizer.v VERILOG PATH $synch_path_debug_0
    } elseif {[file exists $synch_path_debug_1]} {
        add_fileset_file altera_std_synchronizer.v VERILOG PATH $synch_path_debug_1
    } elseif {[file exists $synch_path_debug_2]} {
        add_fileset_file altera_std_synchronizer.v VERILOG PATH $synch_path_debug_2
    } else {
        send_message ERROR "Altera_std_synchronizer could not be found."
    }
}

proc do_verilog_sim { name } {
}

proc do_vhdl_sim { name } {
}


