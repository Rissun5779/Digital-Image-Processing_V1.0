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


package require -exact qsys 13.1


#+-------------------------------------------
#|
#|  Source Files
#|
#+-------------------------------------------
source "csv_ui_loader.tcl"
source "lpm_counter_extra.tcl"


#+--------------------------------------------
#|
#|  Module Property
#|
#+--------------------------------------------
set_module_property     NAME                    "lpm_counter"
set_module_property     AUTHOR                  "Altera Corporation"
set_module_property     VERSION                 18.1
set_module_property     DISPLAY_NAME            "LPM_COUNTER"
set_module_property     DESCRIPTION             "Binary counter that creates up counters, down counters and up or down counters with outputs of up to 256 bits width."
set_module_property     GROUP                   "Basic Functions/Arithmetic"
set_module_property     EDITABLE                false
set_module_property     ELABORATION_CALLBACK    elab
set_module_property   	SUPPORTED_DEVICE_FAMILIES   {"Arria 10"}
set_module_property  	HIDE_FROM_QSYS true

#+--------------------------------------------
#|
#|  Filesets
#|
#+--------------------------------------------
add_fileset quartus_synth   QUARTUS_SYNTH   do_quartus_synth
add_fileset verilog_sim     SIM_VERILOG     do_quartus_synth
add_fileset vhdl_sim        SIM_VHDL        do_vhdl_sim


#+--------------------------------------------
#|
#|  Interfaces
#|
#+--------------------------------------------
add_interface               counter_input   conduit                     input
add_interface               counter_output  conduit                     output
set_interface_assignment    counter_input   ui.blockdiagram.direction   input
set_interface_assignment    counter_output  ui.blockdiagram.direction   output


#+--------------------------------------------
#|
#|  Load the parameters and ui from CSV files
#|
#+--------------------------------------------
load_parameters "parameters.csv"
load_layout     "layout.csv"

# Set the width allowed ranges property
set one_to_256 [list]
for {set i 1} {$i <= 256} {incr i} { lappend one_to_256 $i }
set_parameter_property GUI_WIDTH ALLOWED_RANGES $one_to_256


#+--------------------------------------------
#|
#|  Elaboration Callback
#|
#+--------------------------------------------
proc elab {} {
    # Get all the IP parameters and put them into an array
    array set params {}
    foreach p [get_parameters] {
        set params($p) [get_parameter_value $p]
    }
 
    #+---------- UPDATE_PAGE 1 ----------+#
    
    # Validation for GUI_SSET_ALL1 and GUI_ASET_ALL1 values
    if { $params(GUI_WIDTH) > 31 } {
        if { $params(GUI_SSET) && !$params(GUI_SSET_ALL1) } {
            send_message ERROR "Synchronous set mode must be 'All 1's' if width is larger than 31!"
        }
        
        if { $params(GUI_ASET) && !$params(GUI_ASET_ALL1) } {
            send_message ERROR "Asynchronous set mode must be 'All 1's' if width is larger than 31!"
        }
    }
    
    #+---------- UPDATE_PAGE 2 ----------+#
    
    # Validation for GUI_MODULUS_COUNTER value
    if { $params(GUI_WIDTH) > 31 } {
        if { $params(GUI_MODULUS_COUNTER) == 1 } {
            send_message ERROR "Counter type can only be 'plain binary' if width is larger than 31!"
        }
    }
    
    # Validation for GUI_MODULUS_VALUE values and enabled
    if { $params(GUI_MODULUS_COUNTER) == 1 } {
        # Check to make sure width is valid before doing shift
        if { $params(GUI_WIDTH) >= 1 && $params(GUI_WIDTH) <= 256 } {
            set_parameter_property GUI_MODULUS_VALUE ALLOWED_RANGES 1:[expr {(1 << $params(GUI_WIDTH)) - 1}]
        }
    } else {
        send_message INFO "GUI_MODULUS_VALUE will be ignored... Modulus value is ignored if 'Modulus Counter' is not selected."
        set_parameter_property GUI_MODULUS_VALUE ALLOWED_RANGES {}
    }
    
    #+---------- UPDATE_PAGE 3 ----------+#
    
    # Validation for GUI_SSET_ALL1 and GUI_SVALUE enabled
    if { $params(GUI_SSET) && $params(GUI_WIDTH) < 32 } {
        if { $params(GUI_SSET_ALL1) } {
            send_message INFO "GUI_SVALUE will be ignored... Sync value is ignored if 'Sync set all 1's' is selected."
        }
    } else {
        send_message INFO "GUI_SSET_ALL1 will be ignored... Sync set type is ignored if 'Sync set' is not selected or the width is greater than 32."
        send_message INFO "GUI_SVALUE will be ignored... Sync value is ignored if 'Sync set' is not selected or the width is greater than 32."
    }
    
    # Validation for GUI_ASET_ALL1 and GUI_AVALUE enabled
    if { $params(GUI_ASET) && $params(GUI_WIDTH) < 32 } {
        if { $params(GUI_ASET_ALL1) } {
            send_message INFO "GUI_AVALUE will be ignored... Async value is ignored if 'Async set all 1's' is selected."
        }
    } else {
        send_message INFO "GUI_ASET_ALL1 will be ignored... Async set type is ignored if 'Async set' is not selected or the width is greater than 32."
        send_message INFO "GUI_AVALUE will be ignored... Async value is ignored if 'Async set' is not selected of the width is greater than 32."
    }
    
    # Validation for GUI_SVALUE value low end
    if { $params(GUI_SSET) && !$params(GUI_SSET_ALL1) && [mwizc_global_str2int $params(GUI_SVALUE)] < 0 } {
        send_message ERROR "The synchronous set value can't be less than 0."
    }
    
    # Validation for GUI_AVALUE value low end
    if { $params(GUI_ASET) && !$params(GUI_ASET_ALL1) && [mwizc_global_str2int $params(GUI_AVALUE)] < 0 } {
        send_message ERROR "The asynchronous set value can't be less than 0."
    }
    
    # Check to make sure width is valid before doing shift
    if { $params(GUI_WIDTH) >= 1 && $params(GUI_WIDTH) <= 256 } {
        set max [expr { (1 << $params(GUI_WIDTH)) - 1 }]
    } else {
        set max 0
    }
    
    # Validation for GUI_SVALUE value high end
    if { $params(GUI_SSET) && !$params(GUI_SSET_ALL1) && [mwizc_global_str2int $params(GUI_SVALUE)] > $max } {
        send_message ERROR "The synchronous set value must be between (0 and $max\]"
    }
    
    # Validation for GUI_AVALUE value high end
    if { $params(GUI_MODULUS_COUNTER) == 1 } {
        set max $params(GUI_MODULUS_VALUE)
    }

    if { $params(GUI_ASET) && !$params(GUI_ASET_ALL1) && [mwizc_global_str2int $params(GUI_AVALUE)] >= $max } {
        send_message ERROR "The asynchronous set value must be between (0 and $max)"
    }
    
    #+---------- SETUP ALL PORTS ----------+#
    # If width is out of range, make it 1 for port definitions
    if { $params(GUI_WIDTH) < 1 || $params(GUI_WIDTH) > 256 } {
        set params(GUI_WIDTH) 1
    }
    
    # Ports that are always open
    add_interface_port  counter_input   clock   clock   input   1
    add_interface_port  counter_output  q       q       output  $params(GUI_WIDTH)
    set_port_property                   q       VHDL_TYPE       STD_LOGIC_VECTOR

    # clk_en port
    if { $params(GUI_CLKEN) } {
        add_interface_port counter_input    clk_en  clk_en  input   1
    }
    
    # cnt_en port
    if { $params(GUI_CNTEN) } {
        add_interface_port counter_input    cnt_en  cnt_en  input   1
    }

    # cin port
    if { $params(GUI_CARRYIN) } {
        add_interface_port counter_input    cin     cin     input   1
    }

    # updown port
    if { $params(GUI_DIRECTION) == 2 } {
        add_interface_port counter_input    updown  updown  input   1
    }

    # sclr port
    if { $params(GUI_SCLR) } {
        add_interface_port counter_input    sclr    sclr    input   1
    }

    # sload port
    if { $params(GUI_SLOAD) } {
        add_interface_port counter_input    sload   sload   input   1
    }

    # sset port
    if { $params(GUI_SSET) } {
        add_interface_port counter_input    sset    sset    input   1
    }

    # aclr port
    if { $params(GUI_ACLR) } {
        add_interface_port counter_input    aclr    aclr    input   1
    }

    # aload port
    if { $params(GUI_ALOAD) } {
        add_interface_port counter_input    aload   aload   input   1
    }

    # aset port
    if { $params(GUI_ASET) } {
        add_interface_port counter_input    aset    aset    input   1
    }

    # cout port
    if { $params(GUI_CARRYOUT) } {
        add_interface_port counter_output   cout    cout    output  1
    }

    # data port
    if { $params(GUI_SLOAD) || $params(GUI_ALOAD) } { 
        add_interface_port counter_input    data    data    input   $params(GUI_WIDTH) 
        set_port_property                   data    VHDL_TYPE       STD_LOGIC_VECTOR
    }
}


#+--------------------------------------------
#|
#|  Quartus Synth Callback (Synth / Verilog Sim)
#|
#+--------------------------------------------
proc do_quartus_synth {output_name} {
    set file_name ${output_name}.v
    set terp_path lpm_counter.v.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VERILOG TEXT $contents
}


#+--------------------------------------------
#|
#|  VHDL Simulation Callback
#|
#+--------------------------------------------
proc do_vhdl_sim {output_name} {
    set file_name ${output_name}.vhd
    set terp_path lpm_counter.vhd.terp
    set contents [gen_terp $terp_path $output_name]
    add_fileset_file $file_name VHDL TEXT $contents
}

## Add documentation links for user guide and/or release notes
add_documentation_link "Data Sheet" http://www.altera.com/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "User Guide" https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_lpm_alt_mfug.pdf
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421698013408
