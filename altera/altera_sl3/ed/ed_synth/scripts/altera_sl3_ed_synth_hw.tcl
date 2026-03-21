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


proc ed_synth {} {
    global env
    set qdir $env(QUARTUS_ROOTDIR)
    set quartus_sh_exe_path "$::env(QUARTUS_BINDIR)/quartus_sh"
    set qsys_script_exe_path "$::env(QUARTUS_ROOTDIR)/sopc_builder/bin/qsys-script"
    set ed_synth_scripts_dir "${qdir}/../ip/altera/altera_sl3/ed/ed_synth/demo_control"
    set tmpdir             "."
    set dir                [get_parameter_value direction]
    set lanes              [get_parameter_value "LANES"]
	set DEVICE             [get_parameter_value part_trait_device]
    set df                 [get_parameter_value system_family]
    set cmode              [get_parameter_value gui_clocking_mode]
	set part_trait_device  [get_parameter_value part_trait_device]
    set language           [get_parameter_value SELECT_ED_FILESET]
    #set ed_option          [get_parameter_value ed_option]
    set user_input         [get_parameter_value gui_user_input]	
    set tmp_dir_path       [create_temp_file ""]
    set tmp_ex_design_dir_path "${tmp_dir_path}tmp_ex_synth/"
    set tmp_demo_ctrl_dir_path        "${tmp_ex_design_dir_path}/ed_hwtest/"
    file mkdir $tmp_ex_design_dir_path
    file mkdir $tmp_demo_ctrl_dir_path

	if {$language == 0} {
       set hdl "verilog"
    } else {
       set hdl "vhdl"
    }

    if { $dir == "Duplex"} {
        set dir_qsys {"Duplex" "dup"}
    } else {
        set dir_qsys {"Tx" "tx" "Rx" "rx"}
    }
    
	set variant_name_tx "altera_sl3_tx"
    set variant_name_rx "altera_sl3_rx"
    set variant_name_dup "altera_sl3_dup"
	
    # Create QSYS script for IP core
    foreach {dir_qsys_tcl tail_output_name} $dir_qsys {
        set output_name "altera_sl3_${tail_output_name}"
        set gen_ip_qsys_script_file [create_temp_file gen_qsys.tcl]
        set out_ip_qsys_tcl [ open $gen_ip_qsys_script_file w ]
        puts $out_ip_qsys_tcl "package require \-exact qsys 14.1"
        puts $out_ip_qsys_tcl "create_system"
        puts $out_ip_qsys_tcl "set_project_property DEVICE_FAMILY \"[get_parameter_value "system_family"]\""
        puts $out_ip_qsys_tcl "add_instance $output_name altera_sl3"		
        puts $out_ip_qsys_tcl "set_instance_property $output_name AUTO_EXPORT 1"

        foreach {param_name} [get_parameters] {
            set is_derived_param [get_parameter_property $param_name DERIVED]
            set param_value [get_parameter_value $param_name]
               
            # Print out the DUT parameters that are not derived
            if {$is_derived_param == 1} {
                continue
            } elseif {[string match "*DIRECTION*" $param_name]} {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"$dir_qsys_tcl\""
            } elseif {$dir != "Duplex" && [string match "*rcfg_jtag_enable*" $param_name]} {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name 0"
            } else {
                puts $out_ip_qsys_tcl "set_instance_parameter_value $output_name $param_name \"[get_parameter_value "$param_name"]\""
            }
        }
        puts $out_ip_qsys_tcl "save_system $output_name"
        close $out_ip_qsys_tcl

        file copy $gen_ip_qsys_script_file $tmp_ex_design_dir_path
        file rename ${tmp_ex_design_dir_path}gen_qsys.tcl ${tmp_ex_design_dir_path}gen_qsys_altera_sl3_${tail_output_name}.tcl   
    }
    
    ## Generate ATX PLL 
    set atx_pll_output_name "altera_sl3_atx_pll"
    set gen_qsys_pll_script_file [create_temp_file gen_qsys_atx_pll.tcl]
    set out_qsys_pll_tcl [ open $gen_qsys_pll_script_file w ]
    set atx_pll_outclk_freq [expr {[get_parameter_value "lane_rate_recommended"]*1000/2}]
    puts $out_qsys_pll_tcl "package require \-exact qsys 14.1"
    puts $out_qsys_pll_tcl "create_system"
    puts $out_qsys_pll_tcl "set_project_property DEVICE_FAMILY \"[get_parameter_value "system_family"]\""
    puts $out_qsys_pll_tcl "add_instance $atx_pll_output_name altera_xcvr_atx_pll_s10"
    puts $out_qsys_pll_tcl "set_instance_property $atx_pll_output_name AUTO_EXPORT 1"
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name device_family \"[get_parameter_value "system_family"]\"" 
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name device \"[get_parameter_value "part_trait_device"]\"" 
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name set_output_clock_frequency $atx_pll_outclk_freq"
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name set_auto_reference_clock_frequency \"[get_parameter_value "gui_pll_ref_freq"]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name usr_analog_voltage \"[get_parameter_value "gui_analog_voltage"]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name enable_mcgb \"[expr {$lanes > 6 ? 1 : 0}]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $atx_pll_output_name enable_hfreq_clk \"[expr {$lanes > 6 ? 1 : 0}]\""
    puts $out_qsys_pll_tcl "save_system $atx_pll_output_name"
    close $out_qsys_pll_tcl
		
    file copy $gen_qsys_pll_script_file $tmp_ex_design_dir_path
    file rename ${tmp_ex_design_dir_path}gen_qsys_atx_pll.tcl ${tmp_ex_design_dir_path}gen_qsys_altera_sl3_atx_pll.tcl   
	
    ## Generate user clock from FPLL
    set fpll_output_name "altera_sl3_fpll"
    set gen_qsys_fpll_script_file [create_temp_file gen_qsys_fpll.tcl]
    set out_qsys_fpll_tcl [ open $gen_qsys_fpll_script_file w ]
    puts $out_qsys_pll_tcl "package require \-exact qsys 14.1"
    puts $out_qsys_pll_tcl "create_system"
    puts $out_qsys_pll_tcl "set_project_property DEVICE_FAMILY \"[get_parameter_value "system_family"]\""
    puts $out_qsys_pll_tcl "add_instance $fpll_output_name altera_xcvr_fpll_s10"
    puts $out_qsys_pll_tcl "set_instance_property $fpll_output_name AUTO_EXPORT 1"
    puts $out_qsys_pll_tcl "set_instance_parameter_value $fpll_output_name device_family \"[get_parameter_value "system_family"]\"" 
    puts $out_qsys_pll_tcl "set_instance_parameter_value $fpll_output_name device \"[get_parameter_value "part_trait_device"]\"" 
    puts $out_qsys_pll_tcl "set_instance_parameter_value $fpll_output_name set_primary_use 0" 
    puts $out_qsys_pll_tcl "set_instance_parameter_value $fpll_output_name set_power_mode \"[get_parameter_value "gui_analog_voltage"]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $fpll_output_name set_output_clock_frequency \"[get_parameter_value "gui_user_clock_frequency"]\""
    puts $out_qsys_pll_tcl "set_instance_parameter_value $fpll_output_name set_auto_reference_clock_frequency \"[get_parameter_value "gui_pll_ref_freq"]\""
    puts $out_qsys_pll_tcl "save_system $fpll_output_name"
    close $out_qsys_pll_tcl
		
    file copy $gen_qsys_fpll_script_file $tmp_ex_design_dir_path
    file rename ${tmp_ex_design_dir_path}gen_qsys_fpll.tcl ${tmp_ex_design_dir_path}gen_qsys_altera_sl3_fpll.tcl   
	
    foreach {sim_language} $hdl {

        set out_run_script_file [create_temp_file gen_quartus_synth.tcl]
        set out [ open $out_run_script_file w ]
        
        puts $out "set qdir $::env(QUARTUS_ROOTDIR)"
        puts $out "set qsys_exec \[file join \$qdir sopc_builder bin\]"
        puts $out "set qsys_script \[file join \$qsys_exec qsys-script\]"
        puts $out "set qsys_generate \[file join \$qsys_exec qsys-generate\]"
		
		puts $out "set output_dir [file join src]"
        # gen_IP_QSYS (qsys-script)
        if {$dir == "Duplex"} {
            puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_altera_sl3_dup.tcl \]\} temp"
            puts $out "puts \$temp"
        } else {
            puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_altera_sl3_tx.tcl\]\} temp"
            puts $out "puts \$temp"
            puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_altera_sl3_rx.tcl\]\} temp"
            puts $out "puts \$temp"
        }
        puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_altera_sl3_atx_pll.tcl \]\} temp"
        puts $out "puts \$temp"		
	
        puts $out "catch \{eval \[list exec \"\$qsys_script\" --script=gen_qsys_altera_sl3_fpll.tcl \]\} temp"
        puts $out "puts \$temp"		
        # gen_IP (qsys-generate)
        if {$dir == "Duplex"} {
            puts $out "set output_dir_dup \[file join \$output_dir $variant_name_dup\]"
            puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_dup.ip --synthesis=$sim_language --part=$part_trait_device --output-directory=\$output_dir_dup\]\} temp"
            puts $out "puts \$temp"
        } else {
            puts $out "set output_dir_tx \[file join \$output_dir $variant_name_tx\]"
            puts $out "set output_dir_rx \[file join \$output_dir $variant_name_rx\]"
            puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_tx.ip --synthesis=$sim_language --part=$part_trait_device --output-directory=\$output_dir_tx\]\} temp"
            puts $out "puts \$temp"
            puts $out "catch \{eval \[list exec \"\$qsys_generate\" $variant_name_rx.ip --synthesis=$sim_language --part=$part_trait_device --output-directory=\$output_dir_rx\]\} temp"
            puts $out "puts \$temp"		    
        }
        puts $out "set output_dir_pll \[file join altera_sl3_atx_pll\]"
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" altera_sl3_atx_pll.ip --synthesis=$sim_language --part=$part_trait_device --output-directory=\$output_dir_pll\]\} temp"
        puts $out "puts \$temp"
		
        puts $out "set output_dir_fpll \[file join altera_sl3_fpll\]"
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" altera_sl3_fpll.ip --synthesis=$sim_language --part=$part_trait_device --output-directory=\$output_dir_fpll\]\} temp"
        puts $out "puts \$temp"
		
        puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control.qsys --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"

		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_clk\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_clk.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"
		
		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_code_data_memory\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_code_data_memory.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"
		
		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_demo_mgmt\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_demo_mgmt.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"
		
		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_jtag_uart\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_jtag_uart.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"

		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_nios2_qsys_0\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_nios2_qsys_0.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"

		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_reset_bridge_0\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_reset_bridge_0.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"

		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_source_mgmt\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_source_mgmt.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"

		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_sink_mgmt\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_sink_mgmt.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"
		
		puts $out "set output_dir_ctrl \[file join \$output_dir \"demo_control_timer_0\"\]" 
        puts $out "catch \{eval \[list exec \"\$qsys_generate\" demo_control_timer_0.ip --synthesis=verilog --part=$part_trait_device --output-directory=\$output_dir_ctrl\]\} temp"
        puts $out "puts \$temp"
		
        close $out
        
        if {$dir == "Duplex"} {
            file copy "../../ed/ed_synth/src/demo_control/demo_control_duplex.qsys" $tmp_ex_design_dir_path
            file rename ${tmp_ex_design_dir_path}demo_control_duplex.qsys ${tmp_ex_design_dir_path}demo_control.qsys
        } else {
            file copy "../../ed/ed_synth/src/demo_control/demo_control_simplex.qsys" $tmp_ex_design_dir_path
            file rename ${tmp_ex_design_dir_path}demo_control_simplex.qsys ${tmp_ex_design_dir_path}demo_control.qsys
        }
		
        file copy "../../ed/ed_synth/src/demo_control/demo_control_clk.ip" $tmp_ex_design_dir_path 
        file copy "../../ed/ed_synth/src/demo_control/demo_control_code_data_memory.ip" $tmp_ex_design_dir_path 
        file copy "../../ed/ed_synth/src/demo_control/demo_control_demo_mgmt.ip" $tmp_ex_design_dir_path 
        file copy "../../ed/ed_synth/src/demo_control/demo_control_jtag_uart.ip" $tmp_ex_design_dir_path 
        file copy "../../ed/ed_synth/src/demo_control/demo_control_nios2_qsys_0.ip" $tmp_ex_design_dir_path 		
        file copy "../../ed/ed_synth/src/demo_control/demo_control_reset_bridge_0.ip" $tmp_ex_design_dir_path 		
        file copy "../../ed/ed_synth/src/demo_control/demo_control_source_mgmt.ip" $tmp_ex_design_dir_path 
		file copy "../../ed/ed_synth/src/demo_control/demo_control_sink_mgmt.ip" $tmp_ex_design_dir_path 
        file copy "../../ed/ed_synth/src/demo_control/demo_control_timer_0.ip" $tmp_ex_design_dir_path 

		file copy $out_run_script_file $tmp_ex_design_dir_path
        file rename ${tmp_ex_design_dir_path}gen_quartus_synth.tcl ${tmp_ex_design_dir_path}gen_synth_${sim_language}.tcl   	
    }

    
    set sim_gen_log_file "log_generate_eds.txt"
    set sim_gen_log_path [create_temp_file $sim_gen_log_file]
    set fh [open $sim_gen_log_path "w"]
    set hw_tcl_dir [pwd]
    cd "${tmp_ex_design_dir_path}"

    set cmd [concat [list exec $quartus_sh_exe_path -t "${tmp_ex_design_dir_path}gen_synth_${sim_language}.tcl"]]
    set cmd_fail [catch { eval $cmd } tempresult]
    cd "$hw_tcl_dir"
    puts $fh $tempresult

    close $fh
	
    set sim_files [ls_recursive "${tmp_ex_design_dir_path}" "*"]
    foreach path $sim_files {
        set file [ string range $path [string length $tmp_ex_design_dir_path] [string length $path] ]
        add_fileset_file ed_synth/$file [get_file_type $file 0 0] PATH $path
    }
    
	#Do Terp for seriallite_iii_streaming_demo
    if {$dir == "Duplex"} {
        set sl3_demo_path [file join "../../ed/ed_synth/src/top/" "seriallite_iii_streaming_demo_duplex.v.terp"]
		set template_filenodev_qsf [ file join "../../ed/ed_synth/src/top/" "seriallite_iii_streaming_demo_duplex.qsf.terp" ] 
    } else {
        set sl3_demo_path [file join "../../ed/ed_synth/src/top/" "seriallite_iii_streaming_demo_simplex.v.terp"]
		set template_filenodev_qsf [ file join "../../ed/ed_synth/src/top/" "seriallite_iii_streaming_demo_simplex.qsf.terp" ] 
    }
	
    set paramsdemo(lanes) $lanes
	set paramsdemo(cmode) $cmode
 	set template_demo_v [ read [ open $sl3_demo_path r ] ]
    set result_demo   [ altera_terp $template_demo_v paramsdemo ]
	
    set paramqsf(DEVICE) $DEVICE
	set template_filenodev_v [ read [ open $template_filenodev_qsf r ] ]
	set result_qsf   [ altera_terp $template_filenodev_v paramqsf ]
	
	#add fileset
	add_fileset_file ed_synth/$sim_gen_log_file OTHER PATH $sim_gen_log_path
	add_fileset_file "ed_synth/src/seriallite_iii_streaming_demo.v" VERILOG TEXT $result_demo
    add_fileset_file "ed_synth/seriallite_iii_streaming_demo.qsf" OTHER TEXT $result_qsf	
	add_fileset_file "ed_synth/seriallite_iii_streaming_demo.qpf" OTHER TEXT "../../ed/ed_synth/src/top/seriallite_iii_streaming_demo.qpf" 
    add_fileset_file "ed_synth/src/demo_mgmt.v" VERILOG PATH "../../ed/common/demo_mgmt.v"
    add_fileset_file "ed_synth/src/dp_hs_req.v" VERILOG PATH "../../ed/ed_synth/src/demo_control/dp_hs_req.v"
	add_fileset_file "ed_synth/src/dp_hs_resp.v" VERILOG PATH "../../ed/ed_synth/src/demo_control/dp_hs_resp.v"
    add_fileset_file "ed_synth/src/prbs_generator.v" VERILOG PATH "../../ed/common/prbs_generator.v"
	add_fileset_file "ed_synth/src/prbs_poly.v" VERILOG PATH "../../ed/common/prbs_poly.v"		
    add_fileset_file "ed_synth/src/traffic_check.v" VERILOG PATH "../../ed/common/traffic_check.v"
    add_fileset_file "ed_synth/src/traffic_gen.sv" SYSTEM_VERILOG PATH "../../ed/common/traffic_gen.sv"

	######## SDC generation through terp ########
   set ecc_mode  [get_parameter_value gui_ecc_enable]
   set ccf_val   [get_parameter_value gui_actual_coreclkin_frequency]
   set ref_val   [get_parameter_value gui_pll_ref_freq]
   if {$user_input == 0} {
     set ucf_val [get_parameter_value gui_user_clock_frequency]
   } else {
     set ucf_val [get_parameter_value gui_actual_user_clock_frequency]
   }

  set sl3_demosdc_path [file join "../../ed/ed_synth/src/top/" "seriallite_iii_streaming_demo.sdc.terp"]
  set template      [ read [ open $sl3_demosdc_path r ] ]
  set paramsdc(cmode)     $cmode
  set paramsdc(ecc_mode)  $ecc_mode
  set paramsdc(direction) $dir
  set paramsdc(refclk_freq) $ref_val
  set paramsdc(user_freq) $ucf_val
  set paramsdc(coreclk_freq) $ccf_val
  set result  [ altera_terp $template paramsdc ]
  add_fileset_file "ed_synth/seriallite_iii_streaming_demo.sdc" SDC TEXT $result	
}


proc ls_recursive {base glob} {
   set files [list]

   foreach f [glob -nocomplain -types f -directory $base $glob] {
      set file_path [file join $base $f]
      lappend files $file_path
   }

   foreach d [glob -nocomplain -types d -directory $base *] {
      set files_recursive [ls_recursive [file join $base $d] $glob]
      lappend files {*}$files_recursive
   }

   return $files
}
