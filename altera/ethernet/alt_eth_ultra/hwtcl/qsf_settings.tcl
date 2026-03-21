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


package provide alt_eth_ultra::qsf_settings 18.1
package require ethernet::tools
package require alt_eth_ultra::fileset
package require alt_xcvr::ip_tcl::ip_module

namespace eval ::alt_eth_ultra::qsf_settings {
    namespace import ::alt_xcvr::ip_tcl::ip_module::*

    # Generate QSF file for the compilation example design
    proc generate_compilation_qsf { } {
        set DEVICE_FAMILY [ip_get "parameter.DEVICE_FAMILY.value"]
        set IS_100G       [ip_get "parameter.IS_100G.value"]
        set DEVICE        [::alt_eth_ultra::fileset::get_board_safe_part]

        # Variant specific settings
        if {$IS_100G} {
            set top_level_name eth_100g_a10
        } else {
            set top_level_name eth_40g_a10
        }

        # Create temp directory
        set temp_file [create_temp_file ".tempfile"]
        set temp_dir [file dirname $temp_file]

        # Write script to generate qsf and qpf
        set fd [open "${temp_dir}/qsf_generation.tcl" "w"]
        puts $fd "project_new -overwrite -part $DEVICE -family \"$DEVICE_FAMILY\" ${temp_dir}/${top_level_name}"
        generate_common_compilation_qsf_settings $fd
        generate_virtual_pins $fd
        puts $fd "export_assignments -reorganize"
        puts $fd "project_close"
        close $fd

        # Generate project using script
        set cmd "quartus_sh -t ${temp_dir}/qsf_generation.tcl"
        set res [exec $cmd]
        puts "Result = $res"

        # Copy generated qsf and qpf to compilation project dir
        add_fileset_file "../compilation_test_design/${top_level_name}.qpf" OTHER   PATH "${temp_dir}/${top_level_name}.qpf"
        add_fileset_file "../compilation_test_design/${top_level_name}.qsf" OTHER   PATH "${temp_dir}/${top_level_name}.qsf"
    }

    # Generate QSF file for the hardware example design
    proc generate_hardware_qsf { } {
        set DEVICE_FAMILY [ip_get "parameter.DEVICE_FAMILY.value"]
        set IS_100G       [ip_get "parameter.IS_100G.value"]
        set DEVICE        [::alt_eth_ultra::fileset::get_board_safe_part]
        set ENA_KR4       [ip_get "parameter.ENA_KR4.value"]

        if {$IS_100G == 1} {
            set top_level_name "eth_ex_100g_a10"
        } else {
            if {$ENA_KR4} {
                set top_level_name "eth_ex_40g_kr4_a10"
            } else {
                set top_level_name "eth_ex_40g_a10"
            }
        }

        # Create temp directory
        set temp_file [create_temp_file ".tempfile"]
        set temp_dir [file dirname $temp_file]

        # Write script to generate qsf and qpf
        set fd [open "${temp_dir}/qsf_generation.tcl" "w"]
        puts $fd "project_new -overwrite -part $DEVICE -family \"$DEVICE_FAMILY\" ${temp_dir}/${top_level_name}"
        generate_common_hardware_qsf_settings $fd
        puts $fd "export_assignments -reorganize"
        puts $fd "project_close"
        close $fd

        # Generate project using script
        set cmd "quartus_sh -t ${temp_dir}/qsf_generation.tcl"
        set res [exec $cmd]
        puts "Result = $res"

        # Copy generated qsf and qpf to compilation project dir
        add_fileset_file "../hardware_test_design/${top_level_name}.qpf" OTHER   PATH "${temp_dir}/${top_level_name}.qpf"
        add_fileset_file "../hardware_test_design/${top_level_name}.qsf" OTHER   PATH "${temp_dir}/${top_level_name}.qsf"
    }

    # Generate QSF settings for the virtual pins
    proc generate_virtual_pins {file_pointer} {
        set ports [get_interface_ports]
        foreach port $ports {
            set termination [get_port_property $port TERMINATION]
            if {$termination == 1} {
                # Skip unused signals
            } else {
                set is_clk [regexp -nocase {clk} $port]
                set is_xcvr [regexp {[rt]x_serial} $port]
                set is_tx_pll_locked [regexp {tx_pll_locked} $port]
                if {$is_clk} {
                    # Skip clocks
                } elseif {$is_xcvr} {
                    # Skip xcvrs
                } elseif {$is_tx_pll_locked} {
                    # Skip tx_pll_locked
                } else {
                    puts $file_pointer "set_instance_assignment -name VIRTUAL_PIN ON -to $port"
                }
            }
        }
    }

    # Generate QSF settings specific to the compilation example design
    proc generate_common_compilation_qsf_settings {fd} {
        set IS_NOT_CAUI4  [ip_get "parameter.NOT_CAUI4.value"]
        set IS_100G       [ip_get "parameter.IS_100G.value"]

        if {$IS_100G} {
            set top_level_name eth_100g_a10
            if {$IS_NOT_CAUI4} {
                set variant "ex_100g"
            } else {
                set variant "ex_100g_caui4"
            }
        } else {
            set top_level_name eth_40g_a10
            set variant "ex_40g"
        }

        puts $fd "set_global_assignment -name VERILOG_FILE ${top_level_name}.v"
        puts $fd "set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files"
        puts $fd "set_global_assignment -name SIP_FILE ../${variant}/${variant}.sip"
        puts $fd "set_global_assignment -name QIP_FILE ../${variant}/${variant}.qip"
        puts $fd "set_global_assignment -name SDC_FILE ./${top_level_name}.sdc"

        puts $fd "set_instance_assignment -name IO_STANDARD \"CURRENT MODE LOGIC (CML)\" -to rx_serial\[*\]"
        puts $fd "set_instance_assignment -name IO_STANDARD \"HSSI DIFFERENTIAL I/O\" -to tx_serial\[*\]"

        puts $fd "set_instance_assignment -name IO_STANDARD LVDS -to clk_ref"

        if {$IS_NOT_CAUI4} {
            puts $fd "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial\[*\]"
            puts $fd "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial\[*\]"
        } else {
            puts $fd "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_1V -to rx_serial\[*\]"
            puts $fd "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_1V -to tx_serial\[*\]"
        }


        set SYNOPT_PTP  [ip_get "parameter.SYNOPT_PTP.value"]
        if {$SYNOPT_PTP} {
            puts $fd "set_global_assignment -name SEARCH_PATH ./common/tod"
        }

        # todo: review all settings below
        #puts $fd "set_instance_assignment -name GXB_0PPM_CORECLK ON -to rx_serial"
        #puts $fd "set_instance_assignment -name GXB_0PPM_CORECLK ON -to tx_serial"

        if {!$IS_NOT_CAUI4} {
            puts $fd "set_instance_assignment -name GLOBAL_SIGNAL OFF -to \"*alt_aeu_100_top:ex_100g_caui4_inst|alt_aeu_100_eth_4:e100|caui4_e100_pcs_assembly:phy.epa|caui4_e100_pma:iof|caui4_xcvr:xcvr|altera_xcvr_native_a10:caui4_xcvr|twentynm_xcvr_native:g_xcvr_native_insts\[*\].twentynm_xcvr_native_inst|twentynm_pcs:inst_twentynm_pcs|twentynm_pcs_ch:ch\[0\].inst_twentynm_pcs_ch*pld_pcs_rx_clk_out*\""
        }

        if {!$IS_100G} {
            # todo: determine if these are needed
            # puts $fd "set_location_assignment IOBANK_1G -to clk_ref"
            # puts $fd "set_location_assignment IOBANK_1G -to rx_serial\[3\]"
            # puts $fd "set_location_assignment IOBANK_1G -to rx_serial\[2\]"
            # puts $fd "set_location_assignment IOBANK_1G -to rx_serial\[1\]"
            # puts $fd "set_location_assignment IOBANK_1G -to rx_serial\[0\]"
            # puts $fd "set_location_assignment IOBANK_1G -to tx_serial\[3\]"
            # puts $fd "set_location_assignment IOBANK_1G -to tx_serial\[2\]"
            # puts $fd "set_location_assignment IOBANK_1G -to tx_serial\[1\]"
            # puts $fd "set_location_assignment IOBANK_1G -to tx_serial\[0\]"
            # puts $fd "set_instance_assignment -name GLOBAL_SIGNAL \"PERIPHERY CLOCK\" -to \"*|a10_40bit_4pack:fp|gx_a10:gx|*|pld_pcs_rx_clk_out\""
        }

        # common_timing_settings.qsf
        # puts $fd "set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS OFF"
        puts $fd "set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON"
        # puts $fd "set_global_assignment -name AUTO_GLOBAL_REGISTER_CONTROLS OFF"
        # puts $fd "set_global_assignment -name OPTIMIZE_HOLD_TIMING \"ALL PATHS\""
        # puts $fd "set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING OFF"
        # puts $fd "set_global_assignment -name FITTER_EFFORT \"STANDARD FIT\""
        # puts $fd "set_global_assignment -name TIMEQUEST_DO_REPORT_TIMING ON"
        # puts $fd "set_global_assignment -name BLOCK_RAM_TO_MLAB_CELL_CONVERSION OFF"
        # puts $fd "set_global_assignment -name AUTO_RAM_RECOGNITION OFF"
        # puts $fd "set_global_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF"
        # puts $fd "set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 10"
        # puts $fd "set_global_assignment -name REMOVE_DUPLICATE_REGISTERS OFF"
    }

    # Generate QSF settings specific to the hardware example design
    proc generate_common_hardware_qsf_settings {fd} {
        set IS_NOT_CAUI4  [ip_get "parameter.NOT_CAUI4.value"]
        set IS_100G       [ip_get "parameter.IS_100G.value"]
        set ENA_KR4       [ip_get "parameter.ENA_KR4.value"]

        if {$IS_100G == 1} {
            set top_level_name "eth_ex_100g_a10"
            if {$IS_NOT_CAUI4 == 1} {
                set variant "ex_100g"
            } else {
                set variant "ex_100g_caui4"
            }
        } else {
            set variant "ex_40g"
            if {$ENA_KR4} {
                set top_level_name "eth_ex_40g_kr4_a10"
            } else {
                set top_level_name "eth_ex_40g_a10"
            }
        }

        puts $fd "set_global_assignment -name VERILOG_FILE ${top_level_name}.v"
        puts $fd "set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files"
        puts $fd "set_global_assignment -name QIP_FILE ../${variant}/${variant}.qip"
        puts $fd "set_global_assignment -name SDC_FILE ./common/common_timing_a10.sdc"
        puts $fd "set_global_assignment -name SEARCH_PATH ./common"
        puts $fd "set_global_assignment -name QSYS_FILE common/alt_aeuex_jtag_avalon.qsys"
        puts $fd "set_global_assignment -name QSYS_FILE common/alt_aeuex_iopll_a10.qsys"

        # common_timing_settings.qsf
        #puts $fd "set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS OFF"
        #puts $fd "set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON"
        #puts $fd "set_global_assignment -name AUTO_GLOBAL_REGISTER_CONTROLS OFF"
        #puts $fd "set_global_assignment -name OPTIMIZE_HOLD_TIMING \"ALL PATHS\""
        #puts $fd "set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING OFF"
        #puts $fd "set_global_assignment -name FITTER_EFFORT \"STANDARD FIT\""
        #puts $fd "set_global_assignment -name TIMEQUEST_DO_REPORT_TIMING ON"
        #puts $fd "set_global_assignment -name BLOCK_RAM_TO_MLAB_CELL_CONVERSION OFF"
        #puts $fd "set_global_assignment -name AUTO_RAM_RECOGNITION OFF"
        #puts $fd "set_global_assignment -name AUTO_SHIFT_REGISTER_RECOGNITION OFF"
        #puts $fd "set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 10"
        #puts $fd "set_global_assignment -name REMOVE_DUPLICATE_REGISTERS OFF"

        set SYNOPT_PTP  [ip_get "parameter.SYNOPT_PTP.value"]
        if {$SYNOPT_PTP} {
            puts $fd "set_global_assignment -name SEARCH_PATH ./common/tod"
        }

        if {$ENA_KR4} {
            puts $fd "set_instance_assignment -name GLOBAL_SIGNAL OFF -to \"*e40_inst*twentynm_xcvr_native:g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pma_clkdiv_rx_user\""
            puts $fd "set_instance_assignment -name GLOBAL_SIGNAL OFF -to \"*e40_inst*twentynm_xcvr_native:g_xcvr_native_insts*inst_twentynm_hssi_rx_pld_pcs_interface|pld_pma_rx_clk_out\""
            puts $fd "set_instance_assignment -name GLOBAL_SIGNAL OFF -to \"*e40_inst*twentynm_xcvr_native:g_xcvr_native_insts*inst_twentynm_hssi_tx_pld_pcs_interface|pld_pma_tx_clk_out\""
        }

        generate_pin_qsf_settings $fd
    }

    # Generate QSF settings related to pin settings
    proc generate_pin_qsf_settings { fd } {
        set IS_100G       [ip_get "parameter.IS_100G.value"]
        set ENA_KR4       [ip_get "parameter.ENA_KR4.value"]
        set DEV_BOARD     [ip_get "parameter.DEV_BOARD.value"]

        # A10 GX SI Board
        if {$DEV_BOARD == 1} {
            puts $fd "set_location_assignment PIN_AU33 -to clk50"
            puts $fd "set_location_assignment PIN_AU22 -to cpu_resetn"
            #LEDs
            puts $fd "set_location_assignment PIN_AP22 -to leds\[0\]"
            puts $fd "set_location_assignment PIN_AP23 -to leds\[1\]"
            puts $fd "set_location_assignment PIN_AT25 -to leds\[2\]"
            puts $fd "set_location_assignment PIN_AR25 -to leds\[3\]"
            puts $fd "set_location_assignment PIN_AT23 -to leds\[4\]"
            puts $fd "set_location_assignment PIN_AT24 -to leds\[5\]"
            puts $fd "set_location_assignment PIN_AR24 -to leds\[6\]"
            puts $fd "set_location_assignment PIN_AP24 -to leds\[7\]"
            #DIP SW
            puts $fd "set_location_assignment PIN_BA19 -to user_dip\[0\]"
            puts $fd "set_location_assignment PIN_BA20 -to user_dip\[1\]"
            puts $fd "set_location_assignment PIN_BA17 -to user_dip\[2\]"
            puts $fd "set_location_assignment PIN_BA18 -to user_dip\[3\]"
            puts $fd "set_location_assignment PIN_BC21 -to user_dip\[4\]"
            puts $fd "set_location_assignment PIN_BB21 -to user_dip\[5\]"
            puts $fd "set_location_assignment PIN_BC20 -to user_dip\[6\]"
            if {$IS_100G == 1} {
                puts $fd "set_location_assignment PIN_AW38 -to rx_serial_r\[0\]"
                puts $fd "set_location_assignment PIN_BC38 -to tx_serial_r\[0\]"
                puts $fd "set_location_assignment PIN_BA38 -to rx_serial_r\[1\]"
                puts $fd "set_location_assignment PIN_BD40 -to tx_serial_r\[1\]"
                puts $fd "set_location_assignment PIN_AY40 -to rx_serial_r\[2\]"
                puts $fd "set_location_assignment PIN_BB40 -to tx_serial_r\[2\]"
                puts $fd "set_location_assignment PIN_AV40 -to rx_serial_r\[3\]"
                puts $fd "set_location_assignment PIN_BC42 -to tx_serial_r\[3\]"
                puts $fd "set_location_assignment PIN_AT40 -to rx_serial_r\[4\]"
                puts $fd "set_location_assignment PIN_BB44 -to tx_serial_r\[4\]"
                puts $fd "set_location_assignment PIN_AP40 -to rx_serial_r\[5\]"
                puts $fd "set_location_assignment PIN_BA42 -to tx_serial_r\[5\]"
                puts $fd "set_location_assignment PIN_AN42 -to rx_serial_r\[6\]"
                puts $fd "set_location_assignment PIN_AY44 -to tx_serial_r\[6\]"
                puts $fd "set_location_assignment PIN_AM40 -to rx_serial_r\[7\]"
                puts $fd "set_location_assignment PIN_AW42 -to tx_serial_r\[7\]"
                puts $fd "set_location_assignment PIN_AL42 -to rx_serial_r\[8\]"
                puts $fd "set_location_assignment PIN_AV44 -to tx_serial_r\[8\]"
                puts $fd "set_location_assignment PIN_AK40 -to rx_serial_r\[9\]"
                puts $fd "set_location_assignment PIN_AU42 -to tx_serial_r\[9\]"
                puts $fd "set_location_assignment PIN_AC37 -to clk_ref_r"
            } else {
                if {$ENA_KR4} {
                    puts $fd "set_location_assignment PIN_R42 -to rx_serial_r\[0\]"
                    puts $fd "set_location_assignment PIN_K44 -to tx_serial_r\[0\]"
                    puts $fd "set_location_assignment PIN_P40 -to rx_serial_r\[1\]"
                    puts $fd "set_location_assignment PIN_J42 -to tx_serial_r\[1\]"
                    puts $fd "set_location_assignment PIN_M40 -to rx_serial_r\[2\]"
                    puts $fd "set_location_assignment PIN_G42 -to tx_serial_r\[2\]"
                    puts $fd "set_location_assignment PIN_L42 -to rx_serial_r\[3\]"
                    puts $fd "set_location_assignment PIN_F44 -to tx_serial_r\[3\]"
                    puts $fd "set_location_assignment PIN_R37 -to clk_ref_r"
                } else {
                    puts $fd "set_location_assignment PIN_AG42 -to rx_serial_r\[0\]"
                    puts $fd "set_location_assignment PIN_AP44 -to tx_serial_r\[0\]"
                    puts $fd "set_location_assignment PIN_AF40 -to rx_serial_r\[1\]"
                    puts $fd "set_location_assignment PIN_AM44 -to tx_serial_r\[1\]"
                    puts $fd "set_location_assignment PIN_AD40 -to rx_serial_r\[2\]"
                    puts $fd "set_location_assignment PIN_AH44 -to tx_serial_r\[2\]"
                    puts $fd "set_location_assignment PIN_AC42 -to rx_serial_r\[3\]"
                    puts $fd "set_location_assignment PIN_AF44 -to tx_serial_r\[3\]"
                    puts $fd "set_location_assignment PIN_AC37 -to clk_ref_r"
                    #QSFP Control
                    puts $fd "set_location_assignment PIN_B20 -to eQSFP_modselL"
                    puts $fd "set_location_assignment PIN_C20 -to eQSFP_resetL"
                    puts $fd "set_location_assignment PIN_D18 -to eQSFP_LPmode"
                    puts $fd "set_location_assignment PIN_D19 -to eQSFP_modprsL"
                    puts $fd "set_location_assignment PIN_C19 -to eQSFP_intl"
                    #i2c
                    puts $fd "set_location_assignment PIN_AM35 -to I2C_18V_SCL"
                    puts $fd "set_location_assignment PIN_AK32 -to I2C_18V_SDA"
                }
            }
        }

        puts $fd "set_instance_assignment -name IO_STANDARD \"CURRENT MODE LOGIC (CML)\" -to rx_serial_r\[*\]"
        puts $fd "set_instance_assignment -name IO_STANDARD \"HSSI DIFFERENTIAL I/O\" -to tx_serial_r\[*\]"
        puts $fd "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to rx_serial_r\[*\]"
        puts $fd "set_instance_assignment -name XCVR_VCCR_VCCT_VOLTAGE 1_0V -to tx_serial_r\[*\]"
        puts $fd "set_instance_assignment -name IO_STANDARD LVDS -to clk_ref_r"
        puts $fd "set_instance_assignment -name IO_STANDARD LVDS -to clk50"
    }
}


