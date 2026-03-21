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


# altera_iopll_hw_generation.tcl

# + ========================================================================================================
# |  GENERATION STAGE
# |  Called after validation during IP generation. 
# |  Generates HDL file that instantiates the IOPLL wrappers
# |  Also, procedures for generating MIF files.
# + ========================================================================================================

# ==========================================================================================================
# | MIF FILE GENERATION
# | It is possible to reconfigure IOPLLs by saving an IOPLL configuration
# | in a MIF file, which is then read by the Altera IOPLL Reconfig IP.

proc generate_mif_file {mif_filename} {
    # Description:
    #  Called only if user chooses "Create MIF file during IP Generation"
    #  Creates a MIF file containing the current configuration. 
	# Inputs: mif_filename is an uniquified name, like other generated files. 

    set device_family [get_parameter_value gui_device_family]
    if {$device_family == "Stratix 10"} {
        generate_mif_file_for_iopll_reconfig_s10 $mif_filename true
    } else {
        generate_mif_file_for_iopll_reconfig_a10 $mif_filename true
    }
}

proc create_new_mif_file {} {
    # Description:
    #  Called on "Create MIF" button click. 
	#  Creates a new mif file, using the user specified 'gui_new_mif_file_path'
    #  Overwrites the file if it already exists. 
	# Inputs: mif_filename is a filename (should be absolute) 
  
	set orig_mif_filename		[get_parameter_value	 gui_new_mif_file_path]
    set device_family           [get_parameter_value gui_device_family]
    set mif_filename            [file normalize $orig_mif_filename]
    altera_iopll::util::pll_send_message info       "Creating MIF file $mif_filename"
    if {$device_family == "Stratix 10"} {
        generate_mif_file_for_iopll_reconfig_s10 $mif_filename true
    } else {

        generate_mif_file_for_iopll_reconfig_a10 $mif_filename true
    }
    gui_mif_filename_validation
}

proc append_to_mif_file {} {
    # Description:
    #  Called on "Append to MIF" button click. 
	#  Appends to user's specified MIF file, 'gui_new_existing_file_path'
    #  Sends a warning and creates a new MIF file if the file doesn't already exist.
	# Inputs: mif_filename is a filename (should be absolute)  

	set orig_mif_filename		[get_parameter_value	 gui_existing_mif_file_path]
    set device_family           [get_parameter_value gui_device_family]
    set mif_filename            [file normalize $orig_mif_filename]
    if {![file exists $mif_filename]} {
        # Can't append to a file that doesn't exist. Do nothing. 
        altera_iopll::util::pll_send_message warning  \
              "The file $mif_filename does not exist and cannot be appended to."
    } else {
        altera_iopll::util::pll_send_message info \
              "Appending to MIF file $mif_filename"
        if {$device_family == "Stratix 10"} {
            generate_mif_file_for_iopll_reconfig_s10 $mif_filename false
        } else {
            generate_mif_file_for_iopll_reconfig_a10 $mif_filename false
        }
    }
    gui_mif_filename_validation
}

proc generate_mif_file_for_iopll_reconfig_s10 {mif_filename new_file} {
    # Description:
    #  Called on "Append to MIF" button click, or "Create MIF" button click
	#  or during generation (generate_synth), depending on MIF generation option.
    #  Sends a warning and creates a new MIF file if the file doesn't already exist.
    #  For Stratix10 only (and potentially future families). Calls qcl/pll.
	# Inputs: 
	#  - MIF filename is the file to create or append the current configuration.
    #  - new_file is a boolean - true if creating a new file, false if appending. 

	##  -------GET MIF FILE PARAMETERS--------------
    # Get all required gui parameters and construct a list
    set m_high [get_parameter_value	m_cnt_hi_div]
	set m_low [get_parameter_value	m_cnt_lo_div]
	set m_bypass_en	[get_parameter_value	m_cnt_bypass_en]
	set m_tweak	[get_parameter_value	m_cnt_odd_div_duty_en]
	set n_high [get_parameter_value	n_cnt_hi_div]
	set n_low [get_parameter_value	n_cnt_lo_div]
	set n_bypass_en	[get_parameter_value	n_cnt_bypass_en]
	set n_tweak	[get_parameter_value	n_cnt_odd_div_duty_en]
	set n_c_counters 9
    set refclk1_en [get_parameter_value   gui_refclk_switch]

    array set c_counters_low [list]
    array set c_counters_high [list]
    array set c_counters_bypass_en [list]
    array set c_counters_tweak [list]

	for {set i 0} {$i < $n_c_counters} {incr i} {
		set mif_c_cnt_odd_div_duty_en($i)	[get_parameter_value c_cnt_odd_div_duty_en$i]
		set mif_c_cnt_bypass_en($i)	[get_parameter_value	c_cnt_bypass_en$i]
        set c_counters_low($i) [get_parameter_value	c_cnt_lo_div$i]
        set c_counters_high($i) [get_parameter_value	c_cnt_hi_div$i]
        set c_counters_bypass_en($i) [get_parameter_value	c_cnt_bypass_en$i]
        set c_counters_tweak($i) [get_parameter_value	c_cnt_odd_div_duty_en$i]
	}
	set mif_pll_cp_current	[get_parameter_value	pll_cp_current]
    if {![regexp {(pll_cp_setting([0-9]+)$)} $mif_pll_cp_current a b cp_i]} {
        altera_iopll::util::pll_send_message error \
           "Unknown Charge Pump value $mif_pll_cp_current"
    }
    set mif_pll_bwctrl	[get_parameter_value	pll_bwctrl]
    if {![regexp {(pll_bw_res_setting([0-9]+)$)} $mif_pll_bwctrl a b bw_ctrl ]} {
        altera_iopll::util::pll_send_message \
             error "Unknown BW value $mif_pll_cp_current"
    }
    set pll_m_cnt_in_src [get_parameter_value pll_m_cnt_in_src]
    if {$pll_m_cnt_in_src == "c_m_cnt_in_src_ph_mux_clk"} {
        set m_src 0
    } else {
        set m_src 3
    }

    # Send list of gui parameters to qcl/pll function get_mif_file_values. 
    # This translates the user's settings into a list of mif lines. 
	if {[catch {get_mif_file_values \
				-m_low $m_low \
                -m_high $m_high \
                -m_bypass_en $m_bypass_en \
                -m_tweak $m_tweak  \
				-n_low $n_low \
                -n_high $n_high \
                -n_bypass_en $n_bypass_en \
                -n_tweak $n_tweak \
                -bw_ctrl $bw_ctrl \
                -cp_i $cp_i \
                -num_counters $n_c_counters \
                -c_counters_low [array get c_counters_low] \
                -c_counters_high [array get c_counters_high] \
                -c_counters_bypass_en [array get c_counters_bypass_en] \
                -c_counters_tweak [array get c_counters_tweak] \
                -m_src $m_src \
                -refclk1_en $refclk1_en     } \
		result] } {
	    altera_iopll::util::pll_send_message ERROR \
             "Invalid physical values for MIF generation"
		return TCL_ERROR
	} 
    array set result_array $result

	#------WRITE PARAMETERS TO FILE----------------
    # If appending to file, save original data into 'to_write'
    # and adjust the initial mif_index. 
    if {$new_file} {
        set  mif_index 0
        set  to_write ""
    } else {
        set orig_mif_file [open $mif_filename r]
        set orig_mif_data [read $orig_mif_file]
        set orig_mif_data_lines [split $orig_mif_data "\n"]
        set to_write ""
        set mif_index 0
        foreach line $orig_mif_data_lines {
            if {[regexp {([0-9]+)[ \t]*:[ \t]*(([0-1]{16});[ \t]*(--.*)*)$} \
                             $line full_match index value_and_comment value]} {
                 append to_write "$line\n"
                 set mif_index $index
             } 
        }
        close $orig_mif_file
        incr mif_index
    }
   
    # Add all lines of current configuration to to_write
    set mif_file [open $mif_filename w]
    set dprio_lines [llength $result]   
	for {set i 0} {$i < [expr $dprio_lines / 2]} {incr i} {
        array set currline $result_array($i)
        set value $currline(value)
        set comment $currline(comment)
        append to_write  "$mif_index:$value;        --$comment\n" 
        incr mif_index
	}
     set config_name [get_parameter_value gui_mif_config_name]

     append to_write "$mif_index:1111111111111111;        --END_OF_CONFIG:$config_name \n"
     incr mif_index

     # Write to MIF file
     puts $mif_file "DEPTH = $mif_index;"
     puts $mif_file "WIDTH = 16;"
     puts $mif_file "ADDRESS_RADIX = UNS;"
     puts $mif_file "DATA_RADIX = BIN;"
     puts $mif_file "CONTENT"
     puts $mif_file "BEGIN\n"
     puts $mif_file "$to_write"
	 puts $mif_file "END;"
     close $mif_file
}

proc generate_mif_file_for_iopll_reconfig_a10	{mif_filename new_file}	{
    # Description:
    #  Called on "Append to MIF" button click, or "Create MIF" button click
	#  or during generation (generate_synth), depending on MIF generation option.
    #  Sends a warning and creates a new MIF file if the file doesn't already exist.
    #  For Arria10 only. Values hard-coded here. 
	# Inputs: 
	#  - MIF filename is the file to create or append the current configuration.
    #  - new_file is a boolean - true if creating a new file, false if appending. 

	##  -------GET MIF FILE PARAMETERS--------------
    # Translate the user's settings into MIF lines 
	set device_family	[get_parameter_value	gui_device_family]
	set n_c_counters 9
	set pll_mode	[get_parameter_value	gui_pll_mode]
	set mif_dps_enabled [get_parameter_value gui_enable_mif_dps]

	# - get fractional mode
	set mif_frac_div_value	[get_parameter_value	pll_fractional_division]
	
	#get M cnt hi
	set mif_m_cnt_hi_div [get_parameter_value	m_cnt_hi_div]
	set mif_m_cnt_hi_div [conv_256_to_0	$mif_m_cnt_hi_div]
	set mif_m_cnt_hi_div [int_to_n_bits $mif_m_cnt_hi_div 8] 
	
	#get n cnt hi
	set mif_n_cnt_hi_div [get_parameter_value	n_cnt_hi_div]
	set mif_n_cnt_hi_div [conv_256_to_0	$mif_n_cnt_hi_div]
	set mif_n_cnt_hi_div [int_to_n_bits $mif_n_cnt_hi_div 8] 	
	
	#get M cnt lo
	set mif_m_cnt_lo_div [get_parameter_value	m_cnt_lo_div]
	set mif_m_cnt_lo_div [conv_256_to_0	$mif_m_cnt_lo_div]
	set mif_m_cnt_lo_div [int_to_n_bits $mif_m_cnt_lo_div 8] 
	
	#get n cnt lo
	set mif_n_cnt_lo_div [get_parameter_value	n_cnt_lo_div]
	set mif_n_cnt_lo_div [conv_256_to_0	$mif_n_cnt_lo_div]
	set mif_n_cnt_lo_div [int_to_n_bits $mif_n_cnt_lo_div 8] 

	## - get the bypass enables
	#get m bypass en
	set mif_m_cnt_bypass_en	[get_parameter_value	m_cnt_bypass_en]
	set mif_m_cnt_bypass_en [bool_to_int			$mif_m_cnt_bypass_en]
	
	#get n bypass en
	set mif_n_cnt_bypass_en	[get_parameter_value	n_cnt_bypass_en]
	set mif_n_cnt_bypass_en [bool_to_int			$mif_n_cnt_bypass_en]
	
	#get m_odd_div
	set mif_m_cnt_odd_div_duty_en	[get_parameter_value	m_cnt_odd_div_duty_en]
	set mif_m_cnt_odd_div_duty_en 	[bool_to_int			$mif_m_cnt_odd_div_duty_en]	

	#get n_odd_div
	set mif_n_cnt_odd_div_duty_en	[get_parameter_value	n_cnt_odd_div_duty_en]
	set mif_n_cnt_odd_div_duty_en 	[bool_to_int			$mif_n_cnt_odd_div_duty_en]		
	
	## - get C counter stuff
	for {set i 0} {$i < 18} {incr i} {
		# c high div
		set mif_c_cnt_hi_div($i) [get_parameter_value	c_cnt_hi_div$i]
		set mif_c_cnt_hi_div($i) [conv_256_to_0	$mif_c_cnt_hi_div($i)]
		set mif_c_cnt_hi_div($i) [int_to_n_bits $mif_c_cnt_hi_div($i) 8] 	

		# c lo div
		set mif_c_cnt_lo_div($i) [get_parameter_value	c_cnt_lo_div$i]
		set mif_c_cnt_lo_div($i) [conv_256_to_0	$mif_c_cnt_lo_div($i)]
		set mif_c_cnt_lo_div($i) [int_to_n_bits $mif_c_cnt_lo_div($i) 8]
		
		#get c_odd_div
		set mif_c_cnt_odd_div_duty_en($i)	[get_parameter_value c_cnt_odd_div_duty_en$i]
		set mif_c_cnt_odd_div_duty_en($i)	[bool_to_int $mif_c_cnt_odd_div_duty_en($i)]	
		
		#get c bypass en
		set mif_c_cnt_bypass_en($i)	[get_parameter_value	c_cnt_bypass_en$i]
		set mif_c_cnt_bypass_en($i) [bool_to_int			$mif_c_cnt_bypass_en($i)]
	
	}
	
	## - CHARGE PUMP
	set mif_pll_cp_current	[get_parameter_value	pll_cp_current]
	switch $mif_pll_cp_current {
		pll_cp_setting0   {set mif_pll_cp_current "000000"}
		pll_cp_setting1   {set mif_pll_cp_current "000001"}
		pll_cp_setting2   {set mif_pll_cp_current "000010"}
		pll_cp_setting3   {set mif_pll_cp_current "000011"}
		pll_cp_setting4   {set mif_pll_cp_current "000100"}
		pll_cp_setting5   {set mif_pll_cp_current "000101"}
		pll_cp_setting6   {set mif_pll_cp_current "000110"}
		pll_cp_setting7   {set mif_pll_cp_current "001000"}
		pll_cp_setting8   {set mif_pll_cp_current "001001"}
		pll_cp_setting9   {set mif_pll_cp_current "001010"}
		pll_cp_setting10  {set mif_pll_cp_current "001011"}
		pll_cp_setting11  {set mif_pll_cp_current "001100"}
		pll_cp_setting12  {set mif_pll_cp_current "001101"}
		pll_cp_setting13  {set mif_pll_cp_current "001110"}
		pll_cp_setting14  {set mif_pll_cp_current "010000"}
		pll_cp_setting15  {set mif_pll_cp_current "010001"}
		pll_cp_setting16  {set mif_pll_cp_current "010010"}
		pll_cp_setting17  {set mif_pll_cp_current "010011"}
		pll_cp_setting18  {set mif_pll_cp_current "010100"}
		pll_cp_setting19  {set mif_pll_cp_current "010101"}
		pll_cp_setting20  {set mif_pll_cp_current "010110"}
		pll_cp_setting21  {set mif_pll_cp_current "011000"}
		pll_cp_setting22  {set mif_pll_cp_current "011001"}
		pll_cp_setting23  {set mif_pll_cp_current "011010"}
		pll_cp_setting24  {set mif_pll_cp_current "011011"}
		pll_cp_setting25  {set mif_pll_cp_current "011100"}
		pll_cp_setting26  {set mif_pll_cp_current "011101"}
		pll_cp_setting27  {set mif_pll_cp_current "011110"}
		pll_cp_setting28  {set mif_pll_cp_current "100000"}
		pll_cp_setting29  {set mif_pll_cp_current "100001"}
		pll_cp_setting30  {set mif_pll_cp_current "100010"}
		pll_cp_setting31  {set mif_pll_cp_current "100011"}
		pll_cp_setting32  {set mif_pll_cp_current "100100"}
		pll_cp_setting33  {set mif_pll_cp_current "100101"}
		pll_cp_setting34  {set mif_pll_cp_current "100110"}
		pll_cp_setting35  {set mif_pll_cp_current "101000"}
		default {altera_iopll::util::pll_send_message error \
            "Unknown Charge Pump value $mif_pll_cp_current"}
	}
    
	## - BW Resistor
	set mif_pll_bwctrl	[get_parameter_value	pll_bwctrl]
	switch $mif_pll_bwctrl {
		pll_bw_res_setting0  {set mif_pll_bwctrl "0000"}
		pll_bw_res_setting1  {set mif_pll_bwctrl "0001"}
		pll_bw_res_setting2  {set mif_pll_bwctrl "0010"}
		pll_bw_res_setting3  {set mif_pll_bwctrl "0011"}
		pll_bw_res_setting4  {set mif_pll_bwctrl "0100"}
		pll_bw_res_setting5  {set mif_pll_bwctrl "0101"}
		pll_bw_res_setting6  {set mif_pll_bwctrl "0110"}
		pll_bw_res_setting7  {set mif_pll_bwctrl "0111"}
		pll_bw_res_setting8  {set mif_pll_bwctrl "1000"}
		pll_bw_res_setting9  {set mif_pll_bwctrl "1001"}
		pll_bw_res_setting10 {set mif_pll_bwctrl "1010"}
		default {altera_iopll::util::pll_send_message error \
             "Unknown Bandwidth Setting value $mif_pll_bwctrl"}
	}	
	
	# - DPS
	if {$mif_dps_enabled} {
		set dps_cntr_num	[get_parameter_value	gui_dps_cntr]
		switch -regexp $dps_cntr_num {
			{C([0-9]?[0-9])} {
				regexp {C([0-9]?[0-9])} $dps_cntr_num dps_match dps_cntr_num
				set dps_cnt_select	[int_to_n_bits $dps_cntr_num 4]
			}
			"All C" { 
				set dps_cnt_select	"1111"
			}
			"M" { 
				set dps_cnt_select	"1011"
			}
			default {set a 4}
		}
		
		#DPS shifts
		set dps_num_shifts [get_parameter_value gui_dps_num]
		set dps_num_shifts [int_to_n_bits $dps_num_shifts 3]
		
		# DPS direction
		set dps_up_dn [get_parameter_value gui_dps_dir]
		switch $dps_up_dn {
			"Positive" {set dps_up_dn 1}
			"Negative" {set dps_up_dn 0}
		}
	}
    
	#28nm 20nm
	array set opcodes_28nm {
		OP_SOM			111110
		OP_EOM			111111
		OP_START		000010
		OP_MODE			000000
		OP_STATUS		000001
		OP_N			000011
		OP_M			000100
		OP_C_COUNTERS	000101
		OP_DPS			000110
		OP_DSM			000111
		OP_BWCTRL		001000
		OP_CP_CURRENT	001001
	}
	array set opcodes_20nm {
		OP_SOM			000011110
		OP_EOM			000011111
		OP_START		000000000
		OP_MODE			""
		OP_STATUS		""
		OP_N			010100000
		OP_M			010010000
		OP_C_COUNTERS	011000000
		OP_DPS			100000000
		OP_DSM			""		
		OP_BWCTRL		001000000
		OP_CP_CURRENT	000100000
	}
	array set opcodes [array get opcodes_20nm]
	
    
	#------WRITE PARAMETERS TO FILE----------------
    # If appending to file, save original data into 'to_write'
    # and adjust the initial mif_index. 

    if {$new_file} {
        set  mif_index 0
        set  to_write ""
    } else {
        set orig_mif_file [open $mif_filename r]
        set orig_mif_data [read $orig_mif_file]
        set orig_mif_data_lines [split $orig_mif_data "\n"]
        set to_write ""
        set mif_index 0
        set is_config false
        foreach line $orig_mif_data_lines {
            if {[regexp {([0-9]+)[ \t]*:[ \t]*((00000000000000000000000000011110);[ \t]*(--.*)*)$}  \
                              $line full_match index value_and_comment value]} {
                 # Start of a MIF configuration
                 append to_write "$line\n"
                 set is_config true
                 set mif_index $index
             } elseif {[regexp {([0-9]+)[ \t]*:[ \t]*((00000000000000000000000000011111);[ \t]*(--.*)*)$}  \
                              $line full_match index value_and_comment value]} {
                 # End of a MIF configuration
                 append to_write "$line\n"
                 set is_config false
                 set mif_index $index
             } elseif {[regexp {([0-9]+)[ \t]*:[ \t]*(([0-1]{32});[ \t]*(--.*)*)$}  \
                              $line full_match index value_and_comment value]} {
                 if {$is_config} {
                     append to_write "$line\n"
                     set mif_index $index
                 }
             }
        }
        close $orig_mif_file
        incr mif_index
    }

    if {$mif_index > 483} {
        # There is not space for another configuration
		altera_iopll::util::pll_send_message warning "The MIF file length cannot exceed 512 lines, so the current configuration could not be added."
        return 0
    }

    # Write initial lines of MIF (independent of configuration)
    set mif_file [open $mif_filename w]
    puts $mif_file "DEPTH = 512;"
    puts $mif_file "WIDTH = 32;"
    puts $mif_file "ADDRESS_RADIX = UNS;"
    puts $mif_file "DATA_RADIX = BIN;"
    puts $mif_file "CONTENT"
    puts $mif_file "BEGIN"

	set addr_num $mif_index

	# - START OF MIF
    append to_write [get_line_for_mif $addr_num $opcodes(OP_SOM) "START OF MIF"]
	incr addr_num
	
	# - M COUNTER
    append to_write  [get_line_for_mif $addr_num $opcodes(OP_M)	"M COUNTER"]
	incr addr_num
    append to_write  [get_line_for_mif $addr_num  \
      $mif_m_cnt_odd_div_duty_en$mif_m_cnt_bypass_en$mif_m_cnt_hi_div$mif_m_cnt_lo_div	""]
    incr addr_num
	
	# - N Counter
    append to_write [get_line_for_mif $addr_num $opcodes(OP_N) "N COUNTER"]
    incr addr_num
    append to_write [get_line_for_mif $addr_num \
      $mif_n_cnt_odd_div_duty_en$mif_n_cnt_bypass_en$mif_n_cnt_hi_div$mif_n_cnt_lo_div ""]
    incr addr_num	
	
	# -- C counters
	for {set i 0} {$i < $n_c_counters} {incr i} {
		set c_cnt_bits [int_to_n_bits	$i	4]
		set new_opcode	[string replace $opcodes(OP_C_COUNTERS) 5 8 $c_cnt_bits]
	    append to_write [get_line_for_mif $addr_num	$new_opcode	"C$i COUNTER"]
		incr addr_num
	    append to_write	[get_line_for_mif $addr_num \
       $mif_c_cnt_odd_div_duty_en($i)$mif_c_cnt_bypass_en($i)$mif_c_cnt_hi_div($i)$mif_c_cnt_lo_div($i)	""]
		incr addr_num	
	}
	
	# -- Charge pump
    append to_write [get_line_for_mif $addr_num $opcodes(OP_CP_CURRENT) "CHARGE PUMP"]
    incr addr_num
    append to_write [get_line_for_mif $addr_num $mif_pll_cp_current ""]
    incr addr_num

    # -- Print BW Resistor
    append to_write [get_line_for_mif $addr_num $opcodes(OP_BWCTRL) "LOOP FILTER SETTING"]
    incr addr_num
	set trailing_zeros 000000
    append to_write [get_line_for_mif $addr_num $mif_pll_bwctrl$trailing_zeros ""]
    incr addr_num	
	
    # -- Print Fractional Division 
    if {$pll_mode == "Fractional-N PLL"} {
       append to_write [get_line_for_mif $addr_num $opcodes(OP_DSM) "M COUNTER FRACTIONAL VALUE"]
       incr addr_num
       append to_write [get_line_for_mif $addr_num $mif_frac_div_value ""]
       incr addr_num
	}	
	
	# -- Print DPS (if enabled)
	if {$mif_dps_enabled} {
        set dps_address	[string replace $opcodes(OP_DPS) 5 8 $dps_cnt_select]
        append to_write [get_line_for_mif $addr_num $dps_address "DYNAMIC PHASE SHIFT"]
        incr addr_num
	    append to_write [get_line_for_mif $addr_num $dps_up_dn$dps_num_shifts ""] 
        incr addr_num	
	}
	
    # Print EOF
    append to_write [get_line_for_mif $addr_num $opcodes(OP_EOM) "END OF MIF"]
    incr addr_num	
	
	# Set the rest of MIF file to zero (to avoid Quartus warning)
    # We have 512 lines of 32 bits for 1 M20K
    while {$addr_num < 512} {
        append to_write [get_line_for_mif $addr_num  "0"	""]
        incr addr_num
    }
	
    puts $mif_file "$to_write"
	puts $mif_file "END;"

    close $mif_file
}

# +------------------------------------
# | MIF Generation Utils

proc int_to_n_bits	{integer n} {
    # Desicription: Convert an integer to n bits. Used in MIF generation
	set old_bits [int_to_bits $integer]
    set new_bits $old_bits
    set len [string length $new_bits]
    set zero "0"

    while {$len < $n} {
        # Pad MSBs with 0
        set new_bits $zero$new_bits
        set len [string length $new_bits]
    }

    return $new_bits
}

proc int_to_bits {integer} {
    # Description: Convert an integer to binary. Used in MIF generation
    set bits ""
    set temp $integer

    while {$temp > 0} {
        set new_bit [expr $temp % 2]
        set bits $new_bit$bits
        set temp [expr $temp/2]
    }

    return $bits
}

proc bool_to_int {boolean} {
    # Description: Convert a boolean string to an integer. Used in MIF generation
	if {$boolean} {
		return 1
	} else  {
		return 0
	}
}

proc conv_256_to_0 {int} {
    # Description: Convert 256 to 0. Used in MIF generation
	if {$int == 256} {
		return 0
	} else  {
		return $int
	}
}

proc get_line_for_mif {addr data comment} {
    # | Description: Given the MIF address, data and a comment, return a line to add to a MIF file. 
	set padded_data	[pad_to_32 $data]
	if {$comment == ""} {
		set padded_comment ""
	} else {
		set padded_comment "-- $comment"
	}
	set return_line "$addr : $padded_data;        $padded_comment\n"
	return $return_line
}

proc pad_to_32 {data} {
    # Description: Given data < 32 bits, returns the data padded to 32 bits. 
	set length [string length $data]
	set n_zeros [expr {(32 - $length)}]
	set padded_data [string repeat "0" $n_zeros]$data
	return $padded_data
}


proc generate_verilog_fileset {name} {
	set file_list [list \
		${name}.v \
	]
	
	return $file_list
}


# ==========================================================================================================
# | IP Simulation/Synthesis Generation Callbacks
# | These functions are called by Qmegawiz/Qsys when the user clicks 'Generate IP'
# | They generate the HDL, qip and simulation files.

proc generate_verilog_sim {name} {
    # Description:
    #  Callback function when generating simulation file (VERILOG)
    #  This function is called through Qmegawiz when "Verilog" is selected.
	altera_iopll::util::pll_send_message DEBUG "IN VERILOG SIM"
	generate_sim $name VERILOG
}

proc generate_vhdl_sim {name} {
    # Description:
    #  Callback function when generating simulation file (VHDL)
    #  in Qmegawiz vhdl version of generate_verilog_sim
	altera_iopll::util::pll_send_message DEBUG "IN VHDL SIM"
	generate_sim $name VHDL
}
proc get_cal_code_hex_path {} {
    # Description:
    #   Returns path of actual Calibration hex file.   
	set hex_file_name [get_parameter_value gui_cal_code_hex_file]
    set QUARTUS_BINDIR [my_local_get_quartus_bindir]
    set path [file join $QUARTUS_BINDIR .. .. ip altera emif ip_arch_nd src $hex_file_name]

    return $path
}

proc get_params_sim_hex_path {} {
    # Description:
    #   Returns path of Calibration hex file for simulation. 
	set hex_file_name [get_parameter_value gui_parameter_table_hex_file]
    set path [file join .. test $hex_file_name]

    return $path
}               
                            
proc generate_sim {name simulation_type} {
    # Description:
    # - Qmegawiz: 
    #      Called by generate_verilog_sim or generate_vhdl_sim during IP gen
    #      Produces the {name}_sim/ folder and the {name}.vo file in that folder
    # - Qsys:
    #      Called through Qsys when "Verilog" is selected for simulation.
    #      Produces /simulation/submodules/{name}_pll_0.vo
    # Inputs:
    #  - name is the uniquified instance name
    #  - simulation_type is either VERILOG or VHDL
    
	# Generate HDL wrapper (top level module) 
	set generated_files [generate_verilog_fileset	 $name]

	# Determine the extension of the top level file
	if {$simulation_type == "VERILOG"} {
		set extension "vo"
	} elseif {$simulation_type == "VHDL"} {
		#set extension "vho"
		set extension "vo"
	}
	
	# Create the name of the sub module file
	set hdl_filename  "$name.$extension"
	
	# Create a location for the top level file
	set hdl_filelocation [create_temp_file $hdl_filename]
    
	# Create the sub module, which instantiates the iopll wrapper
	generate_hdl_wrapper $hdl_filelocation $name
		
	# Add the top level file to the fileset
	add_fileset_file $hdl_filename VERILOG PATH $hdl_filelocation

    # If necessary, also add the wrapper itself. 
	set family [get_parameter_value gui_device_family]
	set debug_mode [get_parameter_value gui_debug_mode]
	if { $family == "Stratix 10"} {
        if {$debug_mode} {
            add_fileset_file stratix10_altera_iopll_debug.v VERILOG PATH \
               [file join .. wrappers stratix10_altera_iopll_debug.v]

            set cal_hex_file_name [get_parameter_value gui_cal_code_hex_file]
            set params_hex_file_name [get_parameter_value gui_parameter_table_hex_file]
            add_fileset_file $cal_hex_file_name OTHER PATH [get_cal_code_hex_path]
            add_fileset_file $params_hex_file_name OTHER PATH [get_params_sim_hex_path]
        } else {
            add_fileset_file stratix10_altera_iopll.v VERILOG PATH \
               [file join .. wrappers stratix10_altera_iopll.v]
        }
    }
}

proc generate_synth {name} {
    # Description:
    #   Callback function when generating variation file
    #   This function should generate a QIP file based on pll compensation mode
    # - Qmegawiz: Called to create the {name}/ folder and the 
    #             {name}_0002.v file in it
    # - Qsys:     Called to create the synthesis/submodules folder and the
    #             {name}_pll_0.v and {name}_pll_0.qip files therein
    # Inputs:
    #  - name is the uniquified instance name

	# Generate v file
	set hdl_filename	"$name.v"
	set hdl_filelocation [create_temp_file $hdl_filename]

	# Generate HDL wrapper that instantiates the iopll wrapper
	generate_hdl_wrapper $hdl_filelocation $name
	add_fileset_file $hdl_filename VERILOG PATH $hdl_filelocation
		
	# Generate SDC constraints file
	set family [get_parameter_value gui_device_family]
	set debug_mode [get_parameter_value gui_debug_mode]
	if {$family == "Stratix 10"} {
		set tmpdir [create_temp_file {}]
		generate_sdc_related_files $tmpdir $name 
        if {$debug_mode} {
            add_fileset_file stratix10_altera_iopll_debug.v VERILOG PATH \
               [file join .. wrappers stratix10_altera_iopll_debug.v]
            set cal_hex_file_name [get_parameter_value gui_cal_code_hex_file]
            set params_hex_file_name [get_parameter_value gui_parameter_table_hex_file]
            add_fileset_file $cal_hex_file_name OTHER PATH [get_cal_code_hex_path]
            add_fileset_file $params_hex_file_name OTHER PATH [get_params_sim_hex_path]
        } else {
            add_fileset_file stratix10_altera_iopll.v VERILOG PATH \
               [file join .. wrappers stratix10_altera_iopll.v]
        }
	}
	
	# Generate MIF file (if required)
	set gui_mif_gen_option	[get_parameter_value	 gui_mif_gen_options]
	if {$gui_mif_gen_option == "Create MIF file during IP Generation"} {
		altera_iopll::util::pll_send_message DEBUG "Name: $name"
		# Create the file name
		set mif_filename "${name}.mif"	
		# Create a temporary mif file
		set mif_filelocation	[create_temp_file	$mif_filename]
		altera_iopll::util::pll_send_message info "Generating MIF file $mif_filename"
		generate_mif_file	$mif_filelocation
		# Copy the file over with other geneated files.
		add_fileset_file	$mif_filename MIF PATH $mif_filelocation
	}	
}

proc generate_hdl_wrapper {path_name output_name} {
    # Description:
    #   Generates an HDL wrapper from static ports and parameters, and from mapping data.
    #   Wrappers:
    #     A10, generic  ->  quartus/mega/mlib/altera_pll.v
    #     A10, physical ->  quartus/mega/mlib/altera_iopll.v
    #     S10, physical ->  ip/altera_iopll/wrappers/fourteennm_altera_iopll.v
    #   Future wrappers should be family dependent and added to ip/altera_iopll/wrappers
    # Inputs: 
    # - path_name is the full name of the file to be generated. 
    # - output_name is the uniquefied instance name of the IP instance. 

    set pll_type [get_parameter_value pll_type]
	set family [get_parameter_value gui_device_family]
	set debug_mode [get_parameter_value gui_debug_mode]
    
    # Get the wrapper name.
	if { $family == "Arria 10" && $pll_type == "General"} {
		set sub_module_name altera_pll
	} elseif {($family == "Arria 10" && $pll_type != "General")} {
		set sub_module_name altera_iopll
    } elseif {($family == "Stratix 10")} {
        if {$debug_mode} {
            set sub_module_name stratix10_altera_iopll_debug
        } else {
            set sub_module_name stratix10_altera_iopll
        }
	} else {
		altera_iopll::util::pll_send_message ERROR \
            "generate_hdl_wrapper{}: Illegal device family: $family"
	}
	
	# Get the physical parameters for this modle
	set hdl_params [altera_iopll::util::get_hdl_parameters]
	set hdl_file $path_name 
	
	if [ catch {open $hdl_file w} fid ] {
		altera_iopll::util::pll_send_message ERROR  \
             "generate_hdl_wrapper{}: Couldn't open file '$hdl_file' for writing: $fid"
	} else {
		puts $fid "`timescale 1ns/10ps"
		puts $fid "module  ${output_name}("
		set line_cnt 0
		
		# Generate the wrapper module declaration, grouped by interface
		set enabled_interfaces [altera_iopll::util::get_enabled_interfaces]
		altera_iopll::util::pll_send_message DEBUG "IN HDL WRAP: $enabled_interfaces"
		foreach interface $enabled_interfaces {
			set if_comment "\n\t// interface '$interface'"	;
			foreach port [get_interface_ports $interface] {
				if {$line_cnt > 0} {
					puts -nonewline $fid ",\n"	;
				}
				incr line_cnt
				if {[string length $if_comment] > 0} {
					puts $fid "$if_comment"
					set if_comment ""
				}

				# Generate HDL port declaration
				set port_direction [string tolower [get_port_property $port DIRECTION]]
				set port_width [expr [get_port_property $port WIDTH_VALUE] - 1]
				if {$port_direction == "bidir"} {
					set port_direction "inout"
				}
				if {$port_width == 0} {
					puts -nonewline $fid "\t$port_direction wire $port"
				} else {
					puts -nonewline $fid "\t$port_direction wire \[${port_width}:0\] $port"
				}
			}
		}
		puts $fid "\n);\n"	   

		# Generate sub-module instantiation, parameters first
		set line_cnt 0
		puts $fid "\t$sub_module_name #("
		altera_iopll::util::pll_send_message DEBUG "--hdl_params: $hdl_params"
		foreach param $hdl_params {
			if {$line_cnt > 0} {
				puts -nonewline $fid ",\n"
			}
			incr line_cnt
			set p_value [get_parameter_value $param]
			set p_type [get_parameter_property $param TYPE]
			if {[regexp -nocase {^(string|boolean)} $p_type ] } {
				puts -nonewline $fid "\t\t.$param\(\"${p_value}\"\)"
			} else {
				puts -nonewline $fid "\t\t.$param\(${p_value}\)"
			}
		}
		puts -nonewline $fid "\n\t)"

		set line_cnt 0
		puts $fid " ${sub_module_name}_i ("
		array set altera_pll_ports [altera_iopll::util::get_altera_pll_ports]
		altera_iopll::util::pll_send_message DEBUG \
            "altera_pll_ports ports: [array get altera_pll_ports]"
		set ports_list [get_module_ports]
		altera_iopll::util::pll_send_message DEBUG "module ports: $ports_list"
		
		# Loop through the ports on the altera_pll_module
		foreach {port port_property} [array get altera_pll_ports] {
			
			array set port_property_array $port_property
		    if {$line_cnt > 0} {
			  	puts -nonewline $fid ",\n"
		   	}	
            incr line_cnt

			if {$port_property_array(DIRECT_MAPPING)} {
				# Determine whether the port on the altera_pll has been enabled on the 
				# higher level module
				if {[lsearch $ports_list $port] != -1} {
					puts -nonewline $fid "\t\t.$port\t($port)"
				} else {
				    set tieoff $port_property_array(TIE_OFF)
				    puts -nonewline $fid "\t\t.$port\t($tieoff)"
                }
			} else {
				# There is no direct mapping
                # We need to call the mapping function to fill in the port values
				set function_to_call $port_property_array(MAPPING_FUNCTION)
				#this function should return a "value" for which to set the port to
				set port_connection [$function_to_call]
				puts -nonewline $fid "\t\t.$port\t($port_connection)"				
			}
		}
		puts $fid "\n\t);"
		puts $fid "endmodule\n"
		close $fid
	}
	return $hdl_file
}

# +------------------------------------
# | Mapping functions: Utils for wrapper generation

proc map_fbclk_port {} {
    # Description:
    #   Export fbclk if in external feedback mode only.

	set op_mode [get_parameter_value gui_operation_mode]
	if { $op_mode != "external feedback" }  {
		return "1'b0"
	} else {
		return "fbclk"
	}
}

proc map_fboutclk_port {} {
    # Description:
    #   Export fbclkout if in external feedback mode only.

	set op_mode [get_parameter_value gui_operation_mode]
	if { $op_mode != "external feedback" }  {
		return " "
	} else {
		return "fboutclk"
	}
}

proc map_phout_port {} {
    # Description:
    #   Export phout if enabled by user only.

	set usr_enabled_phout_ports		[get_parameter_value		gui_en_phout_ports]
	if { !$usr_enabled_phout_ports }  {
		return " "
	} else {
		return "phout"
	}
}

proc map_reconfig_to_port {} {
    # Description:
    #   Export reconfig_to_pll port if reconfiguration is enabled. 

	set family [get_parameter_value gui_device_family]
	set reconfig_en		[get_parameter_value		gui_en_reconf]
    if {$reconfig_en} {
        return "reconfig_to_pll"
    } elseif {$family == "Stratix 10"} {
        return "30'b0"
    } else {
        return "64'b0"
    }
}

proc map_outclk_port {} {
    # Description:
    #   Export outclk0 - outclk{number_of_clocks}

	set usr_num_clocks [get_parameter_value gui_number_of_clocks]
	set usr_en_adv_params [get_parameter_value gui_en_adv_params]
	set counter_map [list]
	if {$usr_en_adv_params} {
		# In adv mode, the user tells us whether a counter is cascaded or not
		for {set i [expr {$usr_num_clocks - 1}]} {$i >= 0} {incr i -1} {
			set is_cascade_counter [get_parameter_value gui_cascade_counter$i]
			if {$is_cascade_counter} {
				lappend counter_map "output_unavailable"
			} else {
				lappend counter_map "outclk_$i"
			}
		}
	} else {
		# In non-adv mode, a counter could be implicitly cascaded
		set current_physical_clock 0
		for {set i_clock 0} {$i_clock < $usr_num_clocks} {incr i_clock} {
			lappend counter_map "outclk_$current_physical_clock"
			incr current_physical_clock
		}
		# Now reverse the list
		set counter_map [lreverse $counter_map]
	}
	
	set ports [join $counter_map ", "]
	append ret_val "{" $ports "}"
	
	return $ret_val
}


# ==========================================================================================================
# | SDC Generation
# | This code deals with modifying the .sdc file checked into ip/altera_iopll
# | so that it sets sdc constraints correctly.

proc generate_sdc_related_files {path_name output_name} {
    # Description:
    #   Generate SDC related files. 
    # Inputs : path name is the SDC file path name
    #    output_name is the uniquified instance name. 

	global ipcc_l_mapped_ports	;# raw port mapping data
	global ipcc_module	;# top-level module name
	
	# First dynamically create the parameters.tcl
	set hdl_params [ipcc_get_hdl_params]
	set parameters_tcl_file "$path_name${output_name}_parameters.tcl"	;# parameters.tcl file
	#_dprint 1 "Module name: $ipcc_module for generate_sdc_related_files"
	
	if {[ catch {open $parameters_tcl_file w} fid ]} {
		altera_iopll::util::pll_send_message error  "generate_sdc_related_files{}: \
                Couldn't open file '$parameters_tcl_file' for writing: $fid"
	} else {
		# Get non-counter specific PLL parameters
		set number_of_clocks [get_parameter_value gui_number_of_clocks]
		if {[get_parameter_value m_cnt_bypass_en] == "true"} {
			set mcnt 1
		} else {
			set mcnt [expr [get_parameter_value m_cnt_hi_div] + [get_parameter_value m_cnt_lo_div]]
		}
		if {[get_parameter_value n_cnt_bypass_en] == "true"} {
			set ncnt 1
		} else {
			set ncnt [expr [get_parameter_value n_cnt_hi_div] + [get_parameter_value n_cnt_lo_div]]
		}
		
		# Determine instance name
		if {[regexp {([0-9a-zA-Z]+)\_[0-9]+$} $output_name instance_name instance_name]} {
			set core_name ${instance_name}_inst
		} else {
			set core_name $output_name
		}

        # Determine if clock names are global
        set clock_name_global [get_parameter_value clock_name_global]

		# Write out PLL parameters
		puts $fid "# PLL Parameters"
		puts $fid ""
		puts $fid "#USER W A R N I N G !"
		puts $fid "#USER The PLL parameters are statically defined in this"
		puts $fid "#USER file at generation time!"
		puts $fid "#USER To ensure timing constraints and timing reports are correct, when you make "
		puts $fid "#USER any changes to the PLL component using the Qsys,"
		puts $fid "#USER apply those changes to the PLL parameters in this file"
		puts $fid ""
		puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_corename $core_name"
		puts $fid ""
		puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_num_pll_clock $number_of_clocks"
		puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_global_clock_names \
                        $clock_name_global"
		puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_ref_freq \
                      \"[get_parameter_value reference_clock_frequency]\""
		puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_n_cnt_val $ncnt"
        #For PLL refclk switchover
        set refclk_switchover_enabled [get_parameter_value gui_refclk_switch]
        if {$refclk_switchover_enabled} {
            set refclk1_frequency [get_parameter_value refclk1_frequency]

            altera_iopll::util::pll_send_message DEBUG "Adding refclk1 port to SDC with freq: \
                $refclk1_frequency "
            puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_ref1_freq \
                      \"$refclk1_frequency\""
        }

        # Extclk ports 
        set ext0_src -1
        set ext1_src -1
        set extclk_out_ports_enabled [get_parameter_value gui_en_extclkout_ports]
        if {$extclk_out_ports_enabled} {
            set extclk_0_src [get_parameter_value gui_extclkout_0_source]
            set extclk_1_src [get_parameter_value gui_extclkout_1_source]
            regexp {([0-9.]+)} $extclk_0_src ext0_src
            regexp {([0-9.]+)} $extclk_1_src ext1_src

            altera_iopll::util::pll_send_message DEBUG "Adding extclk0 port to SDC with source: \
                                                       ${ext0_src}"
            altera_iopll::util::pll_send_message DEBUG "Adding extclk1 port to SDC with source: \
                                                       ${ext1_src}"
            puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_ports_enabled true"
        }
        
        # Cascade_out port 
        set cascade_out_src -1
        set enable_cascade_out [get_parameter_value gui_enable_cascade_out]
        if {$enable_cascade_out} {
            set cascade_out_src [get_parameter_value gui_cascade_outclk_index]

            altera_iopll::util::pll_send_message DEBUG "Adding pll_cascade_out port to \
                  SDC with source: ${cascade_out_src}"
            puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_cascade_out_enabled true"
        }

        # pll_cascade_in port 
        set enable_cascade_in [get_parameter_value gui_enable_cascade_in]
        if {$enable_cascade_in} {
            altera_iopll::util::pll_send_message DEBUG "Adding pll_cascade_in port to SDC. \
                No refclk assignment in SDC anymore."
            puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_cascade_in_enabled true"
        }
  
		puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_vco_freq \
                    \"[get_parameter_value pll_output_clk_frequency]\""

        if {[get_parameter_value gui_use_NDFB_modes]} {
            set k [get_parameter_value clock_to_compensate]
            if {[get_parameter_value c_cnt_bypass_en$k] == "true"} {
				set ccnt_k 1
			} else {
				set ccnt_k [expr [get_parameter_value c_cnt_hi_div$k] + \
                           [get_parameter_value c_cnt_lo_div$k]]
			}
 
        }

        # Setting parameters for Output clocks 
		for { set i 0 } { $i < $number_of_clocks } { incr i } {

			set clk_prst [get_parameter_value c_cnt_prst$i]
			set clk_ph_mux [get_parameter_value c_cnt_ph_mux_prst$i]
			set clk_duty_cycle [get_parameter_value duty_cycle$i]
            if {[get_parameter_value c_cnt_bypass_en$i] == "true"} {
				set ccnt 1
			} else {
				set ccnt [expr [get_parameter_value c_cnt_hi_div$i] + \
                                [get_parameter_value c_cnt_lo_div$i]]
			}

            # Handle NDFB mode. 
            # The equation for counter which is to be compensated: C_k = M / N
            # The equation for all other counters:                 C_!k = (M * C_k) / (N * C_!k)
            if {[get_parameter_value gui_use_NDFB_modes]} {
                if {$i == $k} {
                    set clk_mult $mcnt
                    set clk_div $ncnt
                } else {
                    set clk_mult [expr $mcnt * $ccnt_k]
                    set clk_div [expr $ncnt * $ccnt]
                }
            } else {
                set clk_mult $mcnt
                set clk_div [expr $ncnt*$ccnt]
            }
            
			# Set clk_phase [expr 360 * ($clk_ph_mux  + 8*($clk_prst-1))/(8*$clk_div)]
            # Get the phase shift for the clock, remove "ps"
			set phase_with_ps [get_parameter_value phase_shift$i]
            if {[regexp {([0-9Ee\.]+)\s+ps} $phase_with_ps all_match phase_in_ps]} {
                set clk_phase $phase_in_ps
            }

            set clock_name [get_parameter_value clock_name_$i]

			puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_mult(${i}) $clk_mult"
			puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_div(${i}) $clk_div"
			puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_phase(${i}) $clk_phase"
			puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_dutycycle(${i}) $clk_duty_cycle"
			puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_pll_clock_name(${i}) $clock_name"

            # Copying outclk params for Extclks
            if {$ext0_src == $i} { 
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_mult(0) $clk_mult"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_div(0) $clk_div"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_phase(0) $clk_phase"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_dutycycle(0) $clk_duty_cycle"
            }
            if {$ext1_src == $i} { 
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_mult(1) $clk_mult"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_div(1) $clk_div"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_phase(1) $clk_phase"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_ext_dutycycle(1) $clk_duty_cycle"
            }

            if {$cascade_out_src == $i} {
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_cascade_out_mult $clk_mult"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_cascade_out_div $clk_div"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_cascade_out_phase $clk_phase"
                puts $fid "set ::GLOBAL_${ipcc_module}_${output_name}_cascade_out_dutycycle $clk_duty_cycle"
            }
		}		
		
		close $fid
		add_fileset_file ${output_name}_parameters.tcl OTHER PATH ${path_name}${output_name}_parameters.tcl
	}
	
	# Now uniquify the static pin_map and SDC files
	set file_list "altera_iopll.sdc"
	set sdc_file [parse_tcl_params $output_name "" $path_name [list $file_list]]
	add_fileset_file ${output_name}.sdc SDC PATH $sdc_file
	
	set file_list "altera_iopll_pin_map.tcl"
	set pin_map_tcl_file [parse_tcl_params $output_name "" $path_name [list $file_list]]
	add_fileset_file ${output_name}_pin_map.tcl OTHER PATH $pin_map_tcl_file 
	
	return [list $parameters_tcl_file $sdc_file $pin_map_tcl_file]
}


# +------------------------------------
# | SDC utils.

proc parse_tcl_params {module indir outdir infile_list } {
    # Description:
    #   Performs string replacement on a TCL script.. 
    #   Called by generate_sdc_related_files as part of SDC file generation.
    #   Returns a list of the files generated. 
    # Inputs : 
    #    - module      : name of IP variant
    #    - indir       : input directory
    #    - outdir      : output directory
    #    - infile_list : input file list

	global ipcc_module	;# top-level module name
	
	# Initialize the list of known parameters
	set known_params [get_parameters]
	
	# Initialize list of generated files
	set generated_files [list]
	
	foreach infile_name $infile_list {
		set infull_name [file join $indir $infile_name]

		#_dprint 1 "Preparing to run parse_tcl_params on $infile_name"
		#_dprint 1 "Source Dir = $indir"
		#_dprint 1 "Dest Dir = $outdir"

		set outfile_name [ string map "altera_iopll $module" $infile_name ]
		set outfile_name [file join $outdir $outfile_name]
		set outfile_name_tmp "${outfile_name}.tmp"
		
		lappend generated_files $outfile_name
		set outtcl [open "$outfile_name_tmp" w]

		#_dprint 1 "Preparing to create $outfile_name"

		set intcl [open "$infull_name" r]

		set skip_to_end 0
		set ifdef_level 0

		# Start parsing line by line
		while {[gets $intcl line] != -1} {
			set out_line 1	

			#_dprint 2 "LINE: $line"

			# Here go all lines modifications
			if {$out_line == 1 && $skip_to_end == 0} {
				set modified_line [replace_module_name $line $module]

            }

			if {$out_line == 1 && $skip_to_end == 0} {
				puts $outtcl $modified_line
			}
		}
		close $intcl
		close $outtcl		
		# Rename the output file
		file rename -force $outfile_name_tmp $outfile_name
	}

	return $generated_files
}

proc replace_module_name {line new_module_name} {
    # Description:
    #   Returns the modified line with module name replaced for specific
    #   hardcoded cases. Returns the modified line (or the same line if no modifications)
    # Inputs :  
    #    - line            :  Line to modify
    #    - new_module_name :  String with which to replace old module name.

    # top-level module name
	global ipcc_module;
   
    set strings_to_replace [list create]

    set old_module_name "altera_iopll"
    #Dict = {"old_string0" -> "new string0", "old_string1" -> "new_string1" ... }

    set spaces "\[ \t\n\]"
    set alpha_num_underscore "\[A-z0-9_]"

    ##################
    #Hardcoded strings BEGIN
    #################
    lappend strings_to_replace "::GLOBAL_"
    lappend strings_to_replace "altera_iopll${alpha_num_underscore}*\[.\]{1}tcl"
    lappend strings_to_replace "altera_iopll${alpha_num_underscore}*\[.\]{1}sdc"
    ##################
    #Hardcoded strings END
    #################
    #return the same line by default if no changes found
    set modified_line $line

    #go through each key in the dict and replace the strings
    #if it exists in this particular line of the file
    foreach {old_str} $strings_to_replace {

        if {[regexp $old_str $line] } {
                #replace the occurence of the old module name with new module name
                #in that line
                if {[string equal $old_str "::GLOBAL_"]} {
					set modified_line [ string map  \
                          "::GLOBAL_ ::GLOBAL_${ipcc_module}_${new_module_name}_" $line ]
                } else {
                    set modified_line [ string map "$old_module_name $new_module_name" $line ]
                }
              
                #we should only match to one unique replacement string
                break
        }
    }
    return $modified_line
}

