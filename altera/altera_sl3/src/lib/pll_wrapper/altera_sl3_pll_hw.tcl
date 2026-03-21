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
package require -exact qsys 14.1

#########################################
### Source required procs
#########################################
source ../../top/altera_sl3_common_procs.tcl


##########################
# module altera_sl3_pll_wrapper
##########################
set_module_property NAME altera_sl3_pll_wrapper
set_module_property AUTHOR "Altera Corporation"
set_module_property DESCRIPTION "Seriallite III Streaming PLL wrapper"
set_module_property VERSION 18.1
set_module_property INTERNAL true
set_module_property GROUP "Interface Protocols/SerialLite"
set_module_property DISPLAY_NAME "Seriallite III Streaming PLL Wrapper"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
#set_module_property ANALYZE_HDL false
set_module_property HIDE_FROM_SOPC true

########################
# Declare the callbacks
######################## 
set_module_property COMPOSITION_CALLBACK my_compose_callback


#------------------------------------------------------------------------
# 1. GUI parameters
#------------------------------------------------------------------------
source ./../../top/altera_sl3_params.tcl
::altera_sl3::gui_params::params_pll_wrapper_hw


#------------------------------------------------------------------------
# 2. Ports and Interfaces
#------------------------------------------------------------------------

proc my_compose_callback {} {
   # Add ATX PLL A10
   set g_xs_PLL 1
   my_pll_add_instance $g_xs_PLL
   my_pll_add_connection $g_xs_PLL

}

proc my_pll_add_instance {g_xs_PLL} {
    set d_L [get_parameter_value "LANES"]
    set pma_width [get_parameter_value "PMA_MODE"]
    set user_input [get_parameter_value "gui_user_input"] 
   
    if {$user_input} {
       set user_clock_freq [get_parameter_value "gui_actual_user_clock_frequency"]
    } else {
       set user_clock_freq [get_parameter_value "gui_user_clock_frequency"]
    }
    if {[param_matches DIRECTION "Tx" ] || [param_matches DIRECTION "Duplex" ]} {
        add_instance                  inst_atx_pll      altera_xcvr_atx_pll_s10  18.1
        set_instance_parameter_value  inst_atx_pll      rcfg_file_prefix "altera_xcvr_atx_pll_s10"
        set_instance_parameter_value  inst_atx_pll      set_output_clock_frequency [expr {[get_parameter_value "lane_rate_recommended"]*1000/2}]
        set_instance_parameter_value  inst_atx_pll      set_auto_reference_clock_frequency [expr {[get_parameter_value "gui_pll_ref_freq"]}]
        set_instance_parameter_value  inst_atx_pll      usr_analog_voltage [get_parameter_value "gui_analog_voltage"]
        set_instance_parameter_value  inst_atx_pll      {enable_mcgb} [expr {$d_L > 6 ? 1 : 0}]
        set_instance_parameter_value  inst_atx_pll      {enable_hfreq_clk} [expr {$d_L > 6 ? 1 : 0}]
    }

    if {[param_matches GUI_USE_FPLL "false"] } {
      add_instance                    inst_iopll  altera_iopll   18.1
      set_instance_parameter_value    inst_iopll  {gui_reference_clock_frequency}     [get_parameter_value "int_reference_clock_frequency"]
      set_instance_parameter_value    inst_iopll  {gui_output_clock_frequency0}       $user_clock_freq
      set_instance_parameter_value    inst_iopll  {gui_number_of_clocks}              {1}
      set_instance_parameter_value    inst_iopll  {gui_use_locked}                    {1}
    } else { 

      add_instance                    inst_fpll altera_xcvr_fpll_s10 18.1
      set_instance_parameter_value    inst_fpll {enable_pll_reconfig} {0}
      set_instance_parameter_value    inst_fpll {rcfg_jtag_enable} {0}
      set_instance_parameter_value    inst_fpll {gui_fpll_mode} {0}
      set_instance_parameter_value    inst_fpll {gui_hssi_prot_mode} {0}
      set_instance_parameter_value    inst_fpll {gui_refclk_switch} {0}
      set_instance_parameter_value    inst_fpll {generate_docs} {1}
      set_instance_parameter_value    inst_fpll {gui_bw_sel} {medium}
      set_instance_parameter_value    inst_fpll {gui_self_reset_enabled} {0}
      set_instance_parameter_value    inst_fpll {gui_reference_clock_frequency} [get_parameter_value "int_reference_clock_frequency"]
      set_instance_parameter_value    inst_fpll {gui_operation_mode} {0}
      set_instance_parameter_value    inst_fpll {gui_iqtxrxclk_outclk_index} {0}
      set_instance_parameter_value    inst_fpll {gui_refclk_cnt} {1}
      set_instance_parameter_value    inst_fpll {gui_refclk_index} {0}
      set_instance_parameter_value    inst_fpll {gui_enable_fractional} {1}
      set_instance_parameter_value    inst_fpll {enable_analog_resets} {0}
      set_instance_parameter_value    inst_fpll {gui_enable_pld_cal_busy_port} {1}
      set_instance_parameter_value    inst_fpll {gui_enable_cascade_out} {0}
      set_instance_parameter_value    inst_fpll {gui_cascade_outclk_index} {0}
      set_instance_parameter_value    inst_fpll {gui_enable_manual_config} {0}
      set_instance_parameter_value    inst_fpll {gui_number_of_output_clocks} {1}
      set_instance_parameter_value    inst_fpll {gui_enable_phase_alignment} {0}
      set_instance_parameter_value    inst_fpll {gui_desired_outclk0_frequency} $user_clock_freq
      set_instance_parameter_value    inst_fpll {support_mode} {user_mode}
      set_instance_parameter_value    inst_fpll {enable_mcgb} {0}
      set_instance_parameter_value    inst_fpll {mcgb_div} {1}
      set_instance_parameter_value    inst_fpll pma_width $pma_width
      set_instance_parameter_value    inst_fpll set_power_mode [get_parameter_value "gui_analog_voltage"]
    }
}

proc my_pll_add_connection {g_xs_PLL} {
  set d_L [get_parameter_value "LANES"]

    if {[param_matches DIRECTION "Tx" ] || [param_matches DIRECTION "Duplex" ] } {
        set_export_interface   atxpll_refclk0      clock               sink        inst_atx_pll    pll_refclk0     1
        set_export_interface   atxpll_cal_busy     conduit             start       inst_atx_pll    pll_cal_busy    1
        set_export_interface   atxpll_locked       conduit             start       inst_atx_pll    pll_locked      1
        #set_export_interface   atxpll_powerdown    conduit             sink        inst_atx_pll    pll_powerdown   1
        if { $d_L > 6 } {
        set_export_interface   mcgb_serial_clk     hssi_serial_clock   start       inst_atx_pll    mcgb_serial_clk   1
        } else {
        set_export_interface   tx_serial_clk       hssi_serial_clock   start       inst_atx_pll    tx_serial_clk   1
        }
    }
    if {[param_matches GUI_USE_FPLL "false"] } {
        set_export_interface   usrclk_pll_outclk0    clock       start    inst_iopll      outclk0            1
        set_export_interface   usrclk_pll_locked     conduit     start    inst_iopll      locked             1
        set_export_interface   usrclk_pll_refclk     clock       sink     inst_iopll      refclk             1
        set_export_interface   usrclk_pll_reset      reset       sink     inst_iopll      reset              1
    } else {
        set_export_interface   usrclk_pll_outclk0    clock       start    inst_fpll      outclk0            1
        set_export_interface   usrclk_pll_locked     conduit     start    inst_fpll      pll_locked         1
        set_export_interface   usrclk_pll_refclk     clock       sink     inst_fpll      pll_refclk0        1
        #set_export_interface   usrclk_pll_powerdown  conduit     sink     inst_fpll      pll_powerdown      1
        set_export_interface   usrclk_pll_cal_busy   conduit     start    inst_fpll      pll_cal_busy       1
    }

}
