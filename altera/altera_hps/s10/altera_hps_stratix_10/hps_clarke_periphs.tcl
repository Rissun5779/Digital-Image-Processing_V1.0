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


source ../util/hps_utils.tcl
#
# arm_gic_0
#
proc hps_arm_gic_0_base {} {return 0xffffd000}
proc hps_arm_gic_0_base2 {} {return 0xffffc100}
proc hps_instantiate_arm_gic_0 {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 arm_gic_0 stratix10_arm_gic

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master arm_gic_0.axi_slave0 [hps_arm_gic_0_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master arm_gic_0.axi_slave0 [hps_arm_gic_0_base]
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master arm_gic_0.axi_slave1 [hps_arm_gic_0_base2]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master arm_gic_0.axi_slave1 [hps_arm_gic_0_base2]
    }

}

#
# i_clk_mgr_clkmgr
#
proc hps_i_clk_mgr_clkmgr_base {} {return 0xffd04000}
proc hps_instantiate_i_clk_mgr_clkmgr {num_a9s} {

    #hps_utils_add_instance_clk_reset clk_0 clark_clkmgr clark_clkmgr
    add_instance clark_clkmgr clark_clkmgr 
    add_connection clk_0.clk_reset clark_clkmgr.reset_sink
    add_connection cb_intosc_hs_div2_clk.clk clark_clkmgr.cb_intosc_hs_div2_clk clock
    add_connection cb_intosc_ls_clk.clk clark_clkmgr.cb_intosc_ls_clk clock
    add_connection f2s_free_clk.clk clark_clkmgr.f2s_free_clk clock
    add_connection eosc1.clk clark_clkmgr.eosc1 clock

    if {$num_a9s == 0} {
        #hps_utils_add_fpga_irq_connection i_clk_mgr_clkmgr.interrupt_sender h2f_i_clk_mgr_clkmgr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master clark_clkmgr.axi_slave0 [hps_i_clk_mgr_clkmgr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master clark_clkmgr.axi_slave0 [hps_i_clk_mgr_clkmgr_base]
    }

    #hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 clark_clkmgr.interrupt_sender 6

}

#
# i_noc_mpu_m0_usb1_m_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_usb1_m_I_main_QosGenerator_base {} {return 0xffd16500}
proc hps_instantiate_i_noc_mpu_m0_usb1_m_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_usb1_m_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_usb1_m_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_usb1_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_usb1_m_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_usb1_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_usb1_m_I_main_QosGenerator_base]
    }

}

#
# i_i2c_emac_1_i2c
#
proc hps_i_i2c_emac_1_i2c_base {} {return 0xffc02500}
proc hps_instantiate_i_i2c_emac_1_i2c {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_i2c_emac_1_i2c designware-i2c 

    hps_utils_set_swEnabled i_i2c_emac_1_i2c $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_i2c_emac_1_i2c.interrupt_sender h2f_i_i2c_emac_1_i2c_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_i2c_emac_1_i2c.axi_slave0 [hps_i_i2c_emac_1_i2c_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_i2c_emac_1_i2c.axi_slave0 [hps_i_i2c_emac_1_i2c_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_i2c_emac_1_i2c.interrupt_sender 25

}

#
# i_usbotg_1_hostgrp
#
proc hps_i_usbotg_1_hostgrp_base {} {return 0xffb40400}
proc hps_instantiate_i_usbotg_1_hostgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_hostgrp.interrupt_sender h2f_i_usbotg_1_hostgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_hostgrp.axi_slave0 [hps_i_usbotg_1_hostgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_hostgrp.axi_slave0 [hps_i_usbotg_1_hostgrp_base]
    }

}

#
# ecc_otg0_ecc_registerBlock
#
proc hps_ecc_otg0_ecc_registerBlock_base {} {return 0xff8c8800}
proc hps_instantiate_ecc_otg0_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_otg0_ecc_registerBlock.interrupt_sender h2f_ecc_otg0_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_otg0_ecc_registerBlock.axi_slave0 [hps_ecc_otg0_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_otg0_ecc_registerBlock.axi_slave0 [hps_ecc_otg0_ecc_registerBlock_base]
    }

}

#
# i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator_base {} {return 0xffd16180}
proc hps_instantiate_i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_axi64_I_main_QosGenerator_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_15
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_15_base {} {return 0xffb50000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_15 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_15.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_15_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_15.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_15_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_15.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_15_base]
    }

}

#
# i_spim_0_spim
#
proc hps_i_spim_0_spim_base {} {return 0xffda4000}
proc hps_instantiate_i_spim_0_spim {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_spim_0_spim spi

    hps_utils_set_swEnabled i_spim_0_spim $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_spim_0_spim.interrupt_sender h2f_i_spim_0_spim_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_spim_0_spim.axi_slave0 [hps_i_spim_0_spim_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_spim_0_spim.axi_slave0 [hps_i_spim_0_spim_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_spim_0_spim.interrupt_sender 20

}

#
# i_noc_mpu_m0_mpu_m0_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_mpu_m0_I_main_QosGenerator_base {} {return 0xffd16000}
proc hps_instantiate_i_noc_mpu_m0_mpu_m0_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_mpu_m0_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_mpu_m0_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_mpu_m0_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_mpu_m0_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_mpu_m0_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_mpu_m0_I_main_QosGenerator_base]
    }

}

#
# i_watchdog_0_l4wd
#
proc hps_i_watchdog_0_l4wd_base {} {return 0xffd00200}
proc hps_instantiate_i_watchdog_0_l4wd {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sys_free_clk i_watchdog_0_l4wd dw_wd_timer

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_watchdog_0_l4wd.interrupt_sender h2f_i_watchdog_0_l4wd_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_watchdog_0_l4wd.axi_slave0 [hps_i_watchdog_0_l4wd_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_watchdog_0_l4wd.axi_slave0 [hps_i_watchdog_0_l4wd_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_watchdog_0_l4wd.interrupt_sender 4

}

#
# noc_fw_l4_sys_l4_sys_scr
#
proc hps_noc_fw_l4_sys_l4_sys_scr_base {} {return 0xffd13100}
proc hps_instantiate_noc_fw_l4_sys_l4_sys_scr {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection noc_fw_l4_sys_l4_sys_scr.interrupt_sender h2f_noc_fw_l4_sys_l4_sys_scr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master noc_fw_l4_sys_l4_sys_scr.axi_slave0 [hps_noc_fw_l4_sys_l4_sys_scr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master noc_fw_l4_sys_l4_sys_scr.axi_slave0 [hps_noc_fw_l4_sys_l4_sys_scr_base]
    }

}

#
# i_gpio_2_gpio
#
proc hps_i_gpio_2_gpio_base {} {return 0xffc02b00}
proc hps_instantiate_i_gpio_2_gpio {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_gpio_2_gpio dw-gpio

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_gpio_2_gpio.interrupt_sender h2f_i_gpio_2_gpio_interrupt
        return
    }

    set_instance_parameter_value i_gpio_2_gpio embeddedsw.dts.instance.GPIO_PORTA_INTR 1
    set_instance_parameter_value i_gpio_2_gpio embeddedsw.dts.instance.GPIO_PWIDTH_A 14
    set_instance_parameter_value i_gpio_2_gpio embeddedsw.dts.instance.GPIO_PWIDTH_B 0
    set_instance_parameter_value i_gpio_2_gpio embeddedsw.dts.instance.GPIO_PWIDTH_C 0
    set_instance_parameter_value i_gpio_2_gpio embeddedsw.dts.instance.GPIO_PWIDTH_D 0

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_gpio_2_gpio.axi_slave0 [hps_i_gpio_2_gpio_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_gpio_2_gpio.axi_slave0 [hps_i_gpio_2_gpio_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_gpio_2_gpio.interrupt_sender 31

}

#
# i_io48_pin_mux_fpga_interface_grp
#
proc hps_i_io48_pin_mux_fpga_interface_grp_base {} {return 0xffd07400}
proc hps_instantiate_i_io48_pin_mux_fpga_interface_grp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_io48_pin_mux_fpga_interface_grp.interrupt_sender h2f_i_io48_pin_mux_fpga_interface_grp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_io48_pin_mux_fpga_interface_grp.axi_slave0 [hps_i_io48_pin_mux_fpga_interface_grp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_io48_pin_mux_fpga_interface_grp.axi_slave0 [hps_i_io48_pin_mux_fpga_interface_grp_base]
    }

}

#
# i_fpga_bridge_lwsoc2fpga
#
proc hps_i_fpga_bridge_lwsoc2fpga_base {} {return 0xff200000}
proc hps_instantiate_i_fpga_bridge_lwsoc2fpga {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_fpga_bridge_lwsoc2fpga.interrupt_sender h2f_i_fpga_bridge_lwsoc2fpga_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_fpga_bridge_lwsoc2fpga.axi_slave0 [hps_i_fpga_bridge_lwsoc2fpga_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_fpga_bridge_lwsoc2fpga.axi_slave0 [hps_i_fpga_bridge_lwsoc2fpga_base]
    }

}

#
# ecc_nandw_ecc_registerBlock
#
proc hps_ecc_nandw_ecc_registerBlock_base {} {return 0xff8c2800}
proc hps_instantiate_ecc_nandw_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_nandw_ecc_registerBlock.interrupt_sender h2f_ecc_nandw_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_nandw_ecc_registerBlock.axi_slave0 [hps_ecc_nandw_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_nandw_ecc_registerBlock.axi_slave0 [hps_ecc_nandw_ecc_registerBlock_base]
    }

}

#
# i_timer_sp_1_timer
#
proc hps_i_timer_sp_1_timer_base {} {return 0xffc02800}
proc hps_instantiate_i_timer_sp_1_timer {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_timer_sp_1_timer dw-apb-timer-sp

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_timer_sp_1_timer.interrupt_sender h2f_i_timer_sp_1_timer_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_timer_sp_1_timer.axi_slave0 [hps_i_timer_sp_1_timer_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_timer_sp_1_timer.axi_slave0 [hps_i_timer_sp_1_timer_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_timer_sp_1_timer.interrupt_sender 1

}

#
# i_noc_mpu_m0_ddr_T_main_Probe
#
proc hps_i_noc_mpu_m0_ddr_T_main_Probe_base {} {return 0xffd12000}
proc hps_instantiate_i_noc_mpu_m0_ddr_T_main_Probe {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_ddr_T_main_Probe.interrupt_sender h2f_i_noc_mpu_m0_ddr_T_main_Probe_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_ddr_T_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_ddr_T_main_Probe_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_ddr_T_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_ddr_T_main_Probe_base]
    }

}

#
# ecc_emac0_rx_ecc_registerBlock
#
proc hps_ecc_emac0_rx_ecc_registerBlock_base {} {return 0xff8c0800}
proc hps_instantiate_ecc_emac0_rx_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_emac0_rx_ecc_registerBlock.interrupt_sender h2f_ecc_emac0_rx_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_emac0_rx_ecc_registerBlock.axi_slave0 [hps_ecc_emac0_rx_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_emac0_rx_ecc_registerBlock.axi_slave0 [hps_ecc_emac0_rx_ecc_registerBlock_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_13
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_13_base {} {return 0xffb0e000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_13 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_13.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_13_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_13.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_13_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_13.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_13_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_4
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_4_base {} {return 0xffb05000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_4 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_4.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_4_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_4.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_4_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_4.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_4_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator_base {} {return 0xffd16980}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram2_axi64_I_main_QosGenerator_base]
    }

}

#
# i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator_base {} {return 0xffd16100}
proc hps_instantiate_i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_axi32_I_main_QosGenerator_base]
    }

}

#
# ecc_emac0_tx_ecc_registerBlock
#
proc hps_ecc_emac0_tx_ecc_registerBlock_base {} {return 0xff8c0c00}
proc hps_instantiate_ecc_emac0_tx_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_emac0_tx_ecc_registerBlock.interrupt_sender h2f_ecc_emac0_tx_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_emac0_tx_ecc_registerBlock.axi_slave0 [hps_ecc_emac0_tx_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_emac0_tx_ecc_registerBlock.axi_slave0 [hps_ecc_emac0_tx_ecc_registerBlock_base]
    }

}

#
# i_noc_mpu_m0_Probe_MPU_main_Probe
#
proc hps_i_noc_mpu_m0_Probe_MPU_main_Probe_base {} {return 0xffd15000}
proc hps_instantiate_i_noc_mpu_m0_Probe_MPU_main_Probe {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_Probe_MPU_main_Probe.interrupt_sender h2f_i_noc_mpu_m0_Probe_MPU_main_Probe_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_Probe_MPU_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_Probe_MPU_main_Probe_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_Probe_MPU_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_Probe_MPU_main_Probe_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_11
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_11_base {} {return 0xffb4c000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_11 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_11.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_11_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_11.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_11_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_11.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_11_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_6
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_6_base {} {return 0xffb07000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_6 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_6.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_6_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_6.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_6_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_6.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_6_base]
    }

}

#
# i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator_base {} {return 0xffd16200}
proc hps_instantiate_i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_axi128_I_main_QosGenerator_base]
    }

}

#
# i_clk_mgr_mainpllgrp
#
proc hps_i_clk_mgr_mainpllgrp_base {} {return 0xffd04040}
proc hps_instantiate_i_clk_mgr_mainpllgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_clk_mgr_mainpllgrp.interrupt_sender h2f_i_clk_mgr_mainpllgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_clk_mgr_mainpllgrp.axi_slave0 [hps_i_clk_mgr_mainpllgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_clk_mgr_mainpllgrp.axi_slave0 [hps_i_clk_mgr_mainpllgrp_base]
    }

}

#
# i_i2c_1_i2c
#
proc hps_i_i2c_1_i2c_base {} {return 0xffc02300}
proc hps_instantiate_i_i2c_1_i2c {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_i2c_1_i2c designware-i2c

    hps_utils_set_swEnabled i_i2c_1_i2c $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_i2c_1_i2c.interrupt_sender h2f_i_i2c_1_i2c_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_i2c_1_i2c.axi_slave0 [hps_i_i2c_1_i2c_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_i2c_1_i2c.axi_slave0 [hps_i_i2c_1_i2c_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_i2c_1_i2c.interrupt_sender 23

}

#
# i_usbotg_1_DWC_otg_DFIFO_5
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_5_base {} {return 0xffb46000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_5 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_5.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_5_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_5.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_5_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_5.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_5_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator_base {} {return 0xffd16680}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram0_axi32_I_main_QosGenerator_base]
    }

}

#
# i_fpga_mgr_fpgamgrregs
#
proc hps_i_fpga_mgr_fpgamgrregs_base {} {return 0xffd03000}
proc hps_instantiate_i_fpga_mgr_fpgamgrregs {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 i_fpga_mgr_fpgamgrregs fpgamgr

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_fpga_mgr_fpgamgrregs.interrupt_sender h2f_i_fpga_mgr_fpgamgrregs_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_fpga_mgr_fpgamgrregs.axi_slave0 [hps_i_fpga_mgr_fpgamgrregs_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_fpga_mgr_fpgamgrregs.axi_slave0 [hps_i_fpga_mgr_fpgamgrregs_base]
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_fpga_mgr_fpgamgrregs.axi_slave1 [hps_i_fpga_mgr_fpgamgrdata_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_fpga_mgr_fpgamgrregs.axi_slave1 [hps_i_fpga_mgr_fpgamgrdata_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_fpga_mgr_fpgamgrregs.interrupt_sender 8

}

#
# i_usbotg_1_globgrp
#
proc hps_i_usbotg_1_globgrp_base {} {return 0xffb40000}
proc hps_instantiate_i_usbotg_1_globgrp {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.usb_clk i_usbotg_1_globgrp usb

    hps_utils_set_swEnabled i_usbotg_1_globgrp $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_globgrp.interrupt_sender h2f_i_usbotg_1_globgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_globgrp.axi_slave0 [hps_i_usbotg_1_globgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_globgrp.axi_slave0 [hps_i_usbotg_1_globgrp_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_usbotg_1_globgrp.interrupt_sender 13

}

#
# i_usbotg_0_globgrp
#
proc hps_i_usbotg_0_globgrp_base {} {return 0xffb00000}
proc hps_instantiate_i_usbotg_0_globgrp {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.usb_clk i_usbotg_0_globgrp usb

    hps_utils_set_swEnabled i_usbotg_0_globgrp $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_globgrp.interrupt_sender h2f_i_usbotg_0_globgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_globgrp.axi_slave0 [hps_i_usbotg_0_globgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_globgrp.axi_slave0 [hps_i_usbotg_0_globgrp_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_usbotg_0_globgrp.interrupt_sender 12

}

#
# i_emac_emac2
#
proc hps_i_emac_emac2_base {} {return 0xff804000}
proc hps_instantiate_i_emac_emac2 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.emac2_clk i_emac_emac2 stmmac

    hps_utils_set_swEnabled i_emac_emac2 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_emac_emac2.interrupt_sender h2f_i_emac_emac2_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_emac_emac2.axi_slave0 [hps_i_emac_emac2_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_emac_emac2.axi_slave0 [hps_i_emac_emac2_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_emac_emac2.interrupt_sender 11

}

#
# i_emac_emac0
#
proc hps_i_emac_emac0_base {} {return 0xff800000}
proc hps_instantiate_i_emac_emac0 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.emac0_clk i_emac_emac0 stmmac

    hps_utils_set_swEnabled i_emac_emac0 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_emac_emac0.interrupt_sender h2f_i_emac_emac0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_emac_emac0.axi_slave0 [hps_i_emac_emac0_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_emac_emac0.axi_slave0 [hps_i_emac_emac0_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_emac_emac0.interrupt_sender 9

}

#
# noc_fw_soc2fpga_soc2fpga_scr
#
proc hps_noc_fw_soc2fpga_soc2fpga_scr_base {} {return 0xffd13500}
proc hps_instantiate_noc_fw_soc2fpga_soc2fpga_scr {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection noc_fw_soc2fpga_soc2fpga_scr.interrupt_sender h2f_noc_fw_soc2fpga_soc2fpga_scr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master noc_fw_soc2fpga_soc2fpga_scr.axi_slave0 [hps_noc_fw_soc2fpga_soc2fpga_scr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master noc_fw_soc2fpga_soc2fpga_scr.axi_slave0 [hps_noc_fw_soc2fpga_soc2fpga_scr_base]
    }

}

#
# i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0
#
proc hps_i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0_base {} {return 0xffd14980}
proc hps_instantiate_i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0.interrupt_sender h2f_i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0.axi_slave0 [hps_i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0.axi_slave0 [hps_i_noc_mpu_m0_cs_obs_at_main_ErrorLogger_0_base]
    }

}

#
# i_nand_dma
#
proc hps_i_nand_dma_base {} {return 0xffb80700}
proc hps_instantiate_i_nand_dma {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_nand_dma.interrupt_sender h2f_i_nand_dma_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_nand_dma.axi_slave0 [hps_i_nand_dma_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_nand_dma.axi_slave0 [hps_i_nand_dma_base]
    }

}

#
# ecc_onchip_ram_ecc_registerBlock
#
proc hps_ecc_onchip_ram_ecc_registerBlock_base {} {return 0xff8c3000}
proc hps_instantiate_ecc_onchip_ram_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_onchip_ram_ecc_registerBlock.interrupt_sender h2f_ecc_onchip_ram_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_onchip_ram_ecc_registerBlock.axi_slave0 [hps_ecc_onchip_ram_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_onchip_ram_ecc_registerBlock.axi_slave0 [hps_ecc_onchip_ram_ecc_registerBlock_base]
    }

}

#
# ecc_qspi_ecc_registerBlock
#
proc hps_ecc_qspi_ecc_registerBlock_base {} {return 0xff8c8400}
proc hps_instantiate_ecc_qspi_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_qspi_ecc_registerBlock.interrupt_sender h2f_ecc_qspi_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_qspi_ecc_registerBlock.axi_slave0 [hps_ecc_qspi_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_qspi_ecc_registerBlock.axi_slave0 [hps_ecc_qspi_ecc_registerBlock_base]
    }

}

#
# i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter
#
proc hps_i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter_base {} {return 0xffd11500}
proc hps_instantiate_i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter.interrupt_sender h2f_i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_L3Tosoc2fpgaResp_main_RateAdapter_base]
    }

}

#
# i_uart_0_uart
#
proc hps_i_uart_0_uart_base {} {return 0xffc02000}
proc hps_instantiate_i_uart_0_uart {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_uart_0_uart snps_uart

    hps_utils_set_swEnabled i_uart_0_uart $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_uart_0_uart.interrupt_sender h2f_i_uart_0_uart_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_uart_0_uart.axi_slave0 [hps_i_uart_0_uart_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_uart_0_uart.axi_slave0 [hps_i_uart_0_uart_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_uart_0_uart.interrupt_sender 27

}

#
# i_usbotg_0_DWC_otg_DFIFO_7
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_7_base {} {return 0xffb08000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_7 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_7.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_7_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_7.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_7_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_7.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_7_base]
    }

}

#
# i_i2c_emac_2_i2c
#
proc hps_i_i2c_emac_2_i2c_base {} {return 0xffc02600}
proc hps_instantiate_i_i2c_emac_2_i2c {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_i2c_emac_2_i2c designware-i2c

    hps_utils_set_swEnabled i_i2c_emac_2_i2c $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_i2c_emac_2_i2c.interrupt_sender h2f_i_i2c_emac_2_i2c_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_i2c_emac_2_i2c.axi_slave0 [hps_i_i2c_emac_2_i2c_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_i2c_emac_2_i2c.axi_slave0 [hps_i_i2c_emac_2_i2c_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_i2c_emac_2_i2c.interrupt_sender 26

}

#
# i_usbotg_1_DWC_otg_DFIFO_Direct_access
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_Direct_access_base {} {return 0xffb60000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_Direct_access {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_Direct_access.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_Direct_access_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_Direct_access.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_Direct_access_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_Direct_access.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_Direct_access_base]
    }

}

#
# i_usbotg_1_pwrclkgrp
#
proc hps_i_usbotg_1_pwrclkgrp_base {} {return 0xffb40e00}
proc hps_instantiate_i_usbotg_1_pwrclkgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_pwrclkgrp.interrupt_sender h2f_i_usbotg_1_pwrclkgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_pwrclkgrp.axi_slave0 [hps_i_usbotg_1_pwrclkgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_pwrclkgrp.axi_slave0 [hps_i_usbotg_1_pwrclkgrp_base]
    }

}

#
# i_noc_mpu_m0_Probe_emacs_main_Probe
#
proc hps_i_noc_mpu_m0_Probe_emacs_main_Probe_base {} {return 0xffd14400}
proc hps_instantiate_i_noc_mpu_m0_Probe_emacs_main_Probe {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_Probe_emacs_main_Probe.interrupt_sender h2f_i_noc_mpu_m0_Probe_emacs_main_Probe_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_Probe_emacs_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_Probe_emacs_main_Probe_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_Probe_emacs_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_Probe_emacs_main_Probe_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_2
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_2_base {} {return 0xffb43000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_2 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_2.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_2_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_2.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_2_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_2.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_2_base]
    }

}

#
# i_ram_onchip_ram_block
#
proc hps_i_ram_onchip_ram_block_base {} {return 0xffe00000}
proc hps_instantiate_i_ram_onchip_ram_block {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_ram_onchip_ram_block.interrupt_sender h2f_i_ram_onchip_ram_block_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_ram_onchip_ram_block.axi_slave0 [hps_i_ram_onchip_ram_block_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_ram_onchip_ram_block.axi_slave0 [hps_i_ram_onchip_ram_block_base]
    }

}

#
# ecc_dmac_ecc_registerBlock
#
proc hps_ecc_dmac_ecc_registerBlock_base {} {return 0xff8c8000}
proc hps_instantiate_ecc_dmac_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_dmac_ecc_registerBlock.interrupt_sender h2f_ecc_dmac_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_dmac_ecc_registerBlock.axi_slave0 [hps_ecc_dmac_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_dmac_ecc_registerBlock.axi_slave0 [hps_ecc_dmac_ecc_registerBlock_base]
    }

}

#
# ecc_emac2_rx_ecc_registerBlock
#
proc hps_ecc_emac2_rx_ecc_registerBlock_base {} {return 0xff8c1800}
proc hps_instantiate_ecc_emac2_rx_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_emac2_rx_ecc_registerBlock.interrupt_sender h2f_ecc_emac2_rx_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_emac2_rx_ecc_registerBlock.axi_slave0 [hps_ecc_emac2_rx_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_emac2_rx_ecc_registerBlock.axi_slave0 [hps_ecc_emac2_rx_ecc_registerBlock_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator_base {} {return 0xffd16800}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram1_axi32_I_main_QosGenerator_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_8
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_8_base {} {return 0xffb49000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_8 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_8.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_8_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_8.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_8_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_8.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_8_base]
    }

}

#
# i_fpga_mgr_fpgamgrdata
#
proc hps_i_fpga_mgr_fpgamgrdata_base {} {return 0xffcfe400}
proc hps_instantiate_i_fpga_mgr_fpgamgrdata {num_a9s} {
    
    hps_utils_add_instance_clk_reset clk_0 i_fpga_mgr_fpgamgrdata fpgamgr

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_fpga_mgr_fpgamgrdata.interrupt_sender h2f_i_fpga_mgr_fpgamgrdata_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_fpga_mgr_fpgamgrdata.axi_slave0 [hps_i_fpga_mgr_fpgamgrdata_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_fpga_mgr_fpgamgrdata.axi_slave0 [hps_i_fpga_mgr_fpgamgrdata_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_fpga_mgr_fpgamgrdata.interrupt_sender 8

}

#
# ecc_hmc_ocp_slv_block
#
proc hps_ecc_hmc_ocp_slv_block_base {} {return 0xffcfb000}
proc hps_instantiate_ecc_hmc_ocp_slv_block {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_hmc_ocp_slv_block.interrupt_sender h2f_ecc_hmc_ocp_slv_block_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_hmc_ocp_slv_block.axi_slave0 [hps_ecc_hmc_ocp_slv_block_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_hmc_ocp_slv_block.axi_slave0 [hps_ecc_hmc_ocp_slv_block_base]
    }

}

#
# i_usbotg_0_hostgrp
#
proc hps_i_usbotg_0_hostgrp_base {} {return 0xffb00400}
proc hps_instantiate_i_usbotg_0_hostgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_hostgrp.interrupt_sender h2f_i_usbotg_0_hostgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_hostgrp.axi_slave0 [hps_i_usbotg_0_hostgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_hostgrp.axi_slave0 [hps_i_usbotg_0_hostgrp_base]
    }

}

#
# i_spis_1_spis
#
proc hps_i_spis_1_spis_base {} {return 0xffda3000}
proc hps_instantiate_i_spis_1_spis {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_spis_1_spis spi

    hps_utils_set_swEnabled i_spis_1_spis $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_spis_1_spis.interrupt_sender h2f_i_spis_1_spis_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_spis_1_spis.axi_slave0 [hps_i_spis_1_spis_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_spis_1_spis.axi_slave0 [hps_i_spis_1_spis_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_spis_1_spis.interrupt_sender 19

}

#
# i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter
#
proc hps_i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter_base {} {return 0xffd11200}
proc hps_instantiate_i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter.interrupt_sender h2f_i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_MPU_M0_rate_adResp_main_RateAdapter_base]
    }

}

#
# i_i2c_0_i2c
#
proc hps_i_i2c_0_i2c_base {} {return 0xffc02200}
proc hps_instantiate_i_i2c_0_i2c {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_i2c_0_i2c designware-i2c

    hps_utils_set_swEnabled i_i2c_0_i2c $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_i2c_0_i2c.interrupt_sender h2f_i_i2c_0_i2c_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_i2c_0_i2c.axi_slave0 [hps_i_i2c_0_i2c_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_i2c_0_i2c.axi_slave0 [hps_i_i2c_0_i2c_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_i2c_0_i2c.interrupt_sender 22

}

#
# i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter
#
proc hps_i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter_base {} {return 0xffd11100}
proc hps_instantiate_i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter.interrupt_sender h2f_i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_MPU_M1toDDRResp_main_RateAdapter_base]
    }

}

#
# i_timer_sp_0_timer
#
proc hps_i_timer_sp_0_timer_base {} {return 0xffc02700}
proc hps_instantiate_i_timer_sp_0_timer {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_timer_sp_0_timer dw-apb-timer-sp

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_timer_sp_0_timer.interrupt_sender h2f_i_timer_sp_0_timer_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_timer_sp_0_timer.axi_slave0 [hps_i_timer_sp_0_timer_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_timer_sp_0_timer.axi_slave0 [hps_i_timer_sp_0_timer_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_timer_sp_0_timer.interrupt_sender 0

}

#
# i_sdmmc_sdmmc
#
proc hps_i_sdmmc_sdmmc_base {} {return 0xff808000}
proc hps_instantiate_i_sdmmc_sdmmc {num_a9s pinmux} {

    add_instance i_sdmmc_sdmmc sdmmc    
    add_connection clk_0.clk_reset i_sdmmc_sdmmc.reset_sink
    add_connection clark_clkmgr.l4_mp_clk i_sdmmc_sdmmc.biu clock
    add_connection clark_clkmgr.sdmmc_clk i_sdmmc_sdmmc.ciu clock

    hps_utils_set_swEnabled i_sdmmc_sdmmc $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_sdmmc_sdmmc.interrupt_sender h2f_i_sdmmc_sdmmc_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_sdmmc_sdmmc.axi_slave0 [hps_i_sdmmc_sdmmc_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_sdmmc_sdmmc.axi_slave0 [hps_i_sdmmc_sdmmc_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_sdmmc_sdmmc.interrupt_sender 15

}

#
# i_nand_config
#
proc hps_i_nand_config_base {} {return 0xffb80000}
proc hps_instantiate_i_nand_config {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_nand_config.interrupt_sender h2f_i_nand_config_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_nand_config.axi_slave0 [hps_i_nand_config_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_nand_config.axi_slave0 [hps_i_nand_config_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_nand_config.interrupt_sender 16

}

#
# i_fpga_bridge_soc2fpga128
#
proc hps_i_fpga_bridge_soc2fpga128_base {} {return 0xc0000000}
proc hps_instantiate_i_fpga_bridge_soc2fpga128 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_fpga_bridge_soc2fpga128.interrupt_sender h2f_i_fpga_bridge_soc2fpga128_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_fpga_bridge_soc2fpga128.axi_slave0 [hps_i_fpga_bridge_soc2fpga128_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_fpga_bridge_soc2fpga128.axi_slave0 [hps_i_fpga_bridge_soc2fpga128_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_4
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_4_base {} {return 0xffb45000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_4 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_4.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_4_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_4.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_4_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_4.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_4_base]
    }

}

#
# ecc_emac1_tx_ecc_registerBlock
#
proc hps_ecc_emac1_tx_ecc_registerBlock_base {} {return 0xff8c1400}
proc hps_instantiate_ecc_emac1_tx_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_emac1_tx_ecc_registerBlock.interrupt_sender h2f_ecc_emac1_tx_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_emac1_tx_ecc_registerBlock.axi_slave0 [hps_ecc_emac1_tx_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_emac1_tx_ecc_registerBlock.axi_slave0 [hps_ecc_emac1_tx_ecc_registerBlock_base]
    }

}

#
# i_io48_hmc_mmr_io48_mmr
#
proc hps_i_io48_hmc_mmr_io48_mmr_base {} {return 0xffcfa000}
proc hps_instantiate_i_io48_hmc_mmr_io48_mmr {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_io48_hmc_mmr_io48_mmr.interrupt_sender h2f_i_io48_hmc_mmr_io48_mmr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_io48_hmc_mmr_io48_mmr.axi_slave0 [hps_i_io48_hmc_mmr_io48_mmr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_io48_hmc_mmr_io48_mmr.axi_slave0 [hps_i_io48_hmc_mmr_io48_mmr_base]
    }

}

#
# i_noc_mpu_m0_emac2_m_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_emac2_m_I_main_QosGenerator_base {} {return 0xffd16400}
proc hps_instantiate_i_noc_mpu_m0_emac2_m_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_emac2_m_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_emac2_m_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_emac2_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_emac2_m_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_emac2_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_emac2_m_I_main_QosGenerator_base]
    }

}

#
# noc_fw_ocram_ocram_scr
#
proc hps_noc_fw_ocram_ocram_scr_base {} {return 0xffd13200}
proc hps_instantiate_noc_fw_ocram_ocram_scr {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection noc_fw_ocram_ocram_scr.interrupt_sender h2f_noc_fw_ocram_ocram_scr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master noc_fw_ocram_ocram_scr.axi_slave0 [hps_noc_fw_ocram_ocram_scr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master noc_fw_ocram_ocram_scr.axi_slave0 [hps_noc_fw_ocram_ocram_scr_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_1
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_1_base {} {return 0xffb02000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_1 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_1.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_1.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_1_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_1.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_1_base]
    }

}

#
# i_usbotg_1_devgrp
#
proc hps_i_usbotg_1_devgrp_base {} {return 0xffb40800}
proc hps_instantiate_i_usbotg_1_devgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_devgrp.interrupt_sender h2f_i_usbotg_1_devgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_devgrp.axi_slave0 [hps_i_usbotg_1_devgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_devgrp.axi_slave0 [hps_i_usbotg_1_devgrp_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator_base {} {return 0xffd16700}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram0_axi64_I_main_QosGenerator_base]
    }

}

#
# i_timer_sys_1_timer
#
proc hps_i_timer_sys_1_timer_base {} {return 0xffd00100}
proc hps_instantiate_i_timer_sys_1_timer {num_a9s} {

    hps_utils_add_instance_clk_reset eosc1 i_timer_sys_1_timer dw_apb_timer_osc

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_timer_sys_1_timer.interrupt_sender h2f_i_timer_sys_1_timer_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_timer_sys_1_timer.axi_slave0 [hps_i_timer_sys_1_timer_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_timer_sys_1_timer.axi_slave0 [hps_i_timer_sys_1_timer_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_timer_sys_1_timer.interrupt_sender 3

}

#
# ecc_emac2_tx_ecc_registerBlock
#
proc hps_ecc_emac2_tx_ecc_registerBlock_base {} {return 0xff8c1c00}
proc hps_instantiate_ecc_emac2_tx_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_emac2_tx_ecc_registerBlock.interrupt_sender h2f_ecc_emac2_tx_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_emac2_tx_ecc_registerBlock.axi_slave0 [hps_ecc_emac2_tx_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_emac2_tx_ecc_registerBlock.axi_slave0 [hps_ecc_emac2_tx_ecc_registerBlock_base]
    }

}

#
# i_clk_mgr_alteragrp
#
proc hps_i_clk_mgr_alteragrp_base {} {return 0xffd04140}
proc hps_instantiate_i_clk_mgr_alteragrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_clk_mgr_alteragrp.interrupt_sender h2f_i_clk_mgr_alteragrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_clk_mgr_alteragrp.axi_slave0 [hps_i_clk_mgr_alteragrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_clk_mgr_alteragrp.axi_slave0 [hps_i_clk_mgr_alteragrp_base]
    }

}

#
# i_i2c_emac_0_i2c
#
proc hps_i_i2c_emac_0_i2c_base {} {return 0xffc02400}
proc hps_instantiate_i_i2c_emac_0_i2c {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_i2c_emac_0_i2c designware-i2c

    hps_utils_set_swEnabled i_i2c_emac_0_i2c $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_i2c_emac_0_i2c.interrupt_sender h2f_i_i2c_emac_0_i2c_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_i2c_emac_0_i2c.axi_slave0 [hps_i_i2c_emac_0_i2c_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_i2c_emac_0_i2c.axi_slave0 [hps_i_i2c_emac_0_i2c_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_i2c_emac_0_i2c.interrupt_sender 24

}

#
# i_gpio_1_gpio
#
proc hps_i_gpio_1_gpio_base {} {return 0xffc02a00}
proc hps_instantiate_i_gpio_1_gpio {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_gpio_1_gpio dw-gpio

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_gpio_1_gpio.interrupt_sender h2f_i_gpio_1_gpio_interrupt
        return
    }
    set_instance_parameter_value i_gpio_1_gpio embeddedsw.dts.instance.GPIO_PORTA_INTR 1
    set_instance_parameter_value i_gpio_1_gpio embeddedsw.dts.instance.GPIO_PWIDTH_A 24
    set_instance_parameter_value i_gpio_1_gpio embeddedsw.dts.instance.GPIO_PWIDTH_B 0
    set_instance_parameter_value i_gpio_1_gpio embeddedsw.dts.instance.GPIO_PWIDTH_C 0
    set_instance_parameter_value i_gpio_1_gpio embeddedsw.dts.instance.GPIO_PWIDTH_D 0

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_gpio_1_gpio.axi_slave0 [hps_i_gpio_1_gpio_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_gpio_1_gpio.axi_slave0 [hps_i_gpio_1_gpio_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_gpio_1_gpio.interrupt_sender 30

}

#
# i_usbotg_0_DWC_otg_DFIFO_10
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_10_base {} {return 0xffb0b000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_10 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_10.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_10_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_10.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_10_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_10.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_10_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_10
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_10_base {} {return 0xffb4b000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_10 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_10.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_10_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_10.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_10_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_10.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_10_base]
    }

}

#
# i_qspi_QSPIDATA
#
proc hps_i_qspi_QSPIDATA_base {} {return 0xffa00000}
proc hps_instantiate_i_qspi_QSPIDATA {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_qspi_QSPIDATA qspi

    hps_utils_set_swEnabled i_qspi_QSPIDATA $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_qspi_QSPIDATA.interrupt_sender h2f_i_qspi_QSPIDATA_interrupt
        return
    }

     hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_qspi_QSPIDATA.axi_slave0 [hps_i_qspi_qspiregs_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_qspi_QSPIDATA.axi_slave0 [hps_i_qspi_qspiregs_base]
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_qspi_QSPIDATA.axi_slave1 [hps_i_qspi_QSPIDATA_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_qspi_QSPIDATA.axi_slave1 [hps_i_qspi_QSPIDATA_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_qspi_QSPIDATA.interrupt_sender 17

}

#
# i_dma_DMASECURE
#
proc hps_i_dma_DMASECURE_base {} {return 0xffda1000}
proc hps_instantiate_i_dma_DMASECURE {num_a9s} {

    add_instance i_dma_DMASECURE dma 
    add_connection clk_0.clk_reset i_dma_DMASECURE.reset_sink
    add_connection clark_clkmgr.l4_main_clk i_dma_DMASECURE.apb_pclk clock

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_dma_DMASECURE.interrupt_sender h2f_i_dma_DMASECURE_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_dma_DMASECURE.axi_slave0 [hps_i_dma_DMASECURE_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_dma_DMASECURE.axi_slave0 [hps_i_dma_DMASECURE_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_dma_DMASECURE.interrupt_sender 0

}

#
# i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter
#
proc hps_i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter_base {} {return 0xffd17080}
proc hps_instantiate_i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter.interrupt_sender h2f_i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter.axi_slave0 [hps_i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter.axi_slave0 [hps_i_noc_mpu_m0_emac0_m_I_main_TransactionStatFilter_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_15
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_15_base {} {return 0xffb10000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_15 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_15.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_15_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_15.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_15_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_15.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_15_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_12
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_12_base {} {return 0xffb4d000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_12 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_12.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_12_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_12.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_12_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_12.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_12_base]
    }

}

#
# i_sec_mgr_core
#
proc hps_i_sec_mgr_core_base {} {return 0xffd02000}
proc hps_instantiate_i_sec_mgr_core {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_sec_mgr_core.interrupt_sender h2f_i_sec_mgr_core_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_sec_mgr_core.axi_slave0 [hps_i_sec_mgr_core_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_sec_mgr_core.axi_slave0 [hps_i_sec_mgr_core_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_sec_mgr_core.interrupt_sender 11

}

#
# i_noc_mpu_m0_acp_rate_ad_main_RateAdapter
#
proc hps_i_noc_mpu_m0_acp_rate_ad_main_RateAdapter_base {} {return 0xffd11600}
proc hps_instantiate_i_noc_mpu_m0_acp_rate_ad_main_RateAdapter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_acp_rate_ad_main_RateAdapter.interrupt_sender h2f_i_noc_mpu_m0_acp_rate_ad_main_RateAdapter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_acp_rate_ad_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_acp_rate_ad_main_RateAdapter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_acp_rate_ad_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_acp_rate_ad_main_RateAdapter_base]
    }

}

#
# i_nand_param
#
proc hps_i_nand_param_base {} {return 0xffb80300}
proc hps_instantiate_i_nand_param {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_nand_param.interrupt_sender h2f_i_nand_param_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_nand_param.axi_slave0 [hps_i_nand_param_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_nand_param.axi_slave0 [hps_i_nand_param_base]
    }

}

#
# i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator_base {} {return 0xffd16600}
proc hps_instantiate_i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_sdmmc_m_I_main_QosGenerator_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator_base {} {return 0xffd16880}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram1_axi64_I_main_QosGenerator_base]
    }

}

#
# i_noc_mpu_m0_mpu_m1_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_mpu_m1_I_main_QosGenerator_base {} {return 0xffd16080}
proc hps_instantiate_i_noc_mpu_m0_mpu_m1_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_mpu_m1_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_mpu_m1_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_mpu_m1_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_mpu_m1_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_mpu_m1_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_mpu_m1_I_main_QosGenerator_base]
    }

}

#
# i_noc_mpu_m0_usb0_m_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_usb0_m_I_main_QosGenerator_base {} {return 0xffd16480}
proc hps_instantiate_i_noc_mpu_m0_usb0_m_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_usb0_m_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_usb0_m_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_usb0_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_usb0_m_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_usb0_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_usb0_m_I_main_QosGenerator_base]
    }

}

#
# i_emac_emac1
#
proc hps_i_emac_emac1_base {} {return 0xff802000}
proc hps_instantiate_i_emac_emac1 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.emac1_clk i_emac_emac1 stmmac

    hps_utils_set_swEnabled i_emac_emac1 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_emac_emac1.interrupt_sender h2f_i_emac_emac1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_emac_emac1.axi_slave0 [hps_i_emac_emac1_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_emac_emac1.axi_slave0 [hps_i_emac_emac1_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_emac_emac1.interrupt_sender 10

}

#
# i_usbotg_0_DWC_otg_DFIFO_9
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_9_base {} {return 0xffb0a000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_9 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_9.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_9_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_9.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_9_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_9.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_9_base]
    }

}

#
# ecc_nandr_ecc_registerBlock
#
proc hps_ecc_nandr_ecc_registerBlock_base {} {return 0xff8c2400}
proc hps_instantiate_ecc_nandr_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_nandr_ecc_registerBlock.interrupt_sender h2f_ecc_nandr_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_nandr_ecc_registerBlock.axi_slave0 [hps_ecc_nandr_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_nandr_ecc_registerBlock.axi_slave0 [hps_ecc_nandr_ecc_registerBlock_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_11
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_11_base {} {return 0xffb0c000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_11 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_11.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_11_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_11.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_11_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_11.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_11_base]
    }

}

#
# mpu_reg_l2_MPUL2
#
proc hps_mpu_reg_l2_MPUL2_base {} {return 0xfffff000}
proc hps_instantiate_mpu_reg_l2_MPUL2 {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 mpu_reg_l2_MPUL2 L2

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection mpu_reg_l2_MPUL2.interrupt_sender h2f_mpu_reg_l2_MPUL2_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master mpu_reg_l2_MPUL2.axi_slave0 [hps_mpu_reg_l2_MPUL2_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master mpu_reg_l2_MPUL2.axi_slave0 [hps_mpu_reg_l2_MPUL2_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_0 mpu_reg_l2_MPUL2.interrupt_sender 18

}

#
# i_usbotg_1_DWC_otg_DFIFO_9
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_9_base {} {return 0xffb4a000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_9 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_9.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_9_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_9.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_9_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_9.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_9_base]
    }

}

#
# i_nand_ecc
#
proc hps_i_nand_ecc_base {} {return 0xffb80650}
proc hps_instantiate_i_nand_ecc {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_nand_ecc.interrupt_sender h2f_i_nand_ecc_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_nand_ecc.axi_slave0 [hps_i_nand_ecc_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_nand_ecc.axi_slave0 [hps_i_nand_ecc_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_6
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_6_base {} {return 0xffb47000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_6 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_6.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_6_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_6.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_6_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_6.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_6_base]
    }

}

#
# i_nand_NANDDATA
#
proc hps_i_nand_NANDDATA_base {} {return 0xffb90000}
proc hps_instantiate_i_nand_NANDDATA {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_nand_NANDDATA denali_nand

    hps_utils_set_swEnabled i_nand_NANDDATA $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_nand_NANDDATA.interrupt_sender h2f_i_nand_NANDDATA_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_nand_NANDDATA.axi_slave0 [hps_i_nand_NANDDATA_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_nand_NANDDATA.axi_slave0 [hps_i_nand_NANDDATA_base]
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_nand_NANDDATA.axi_slave1 [hps_i_nand_config_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_nand_NANDDATA.axi_slave1 [hps_i_nand_config_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_nand_NANDDATA.interrupt_sender 16

}

#
# i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler
#
proc hps_i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler_base {} {return 0xffd14800}
proc hps_instantiate_i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler.interrupt_sender h2f_i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler.axi_slave0 [hps_i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler.axi_slave0 [hps_i_noc_mpu_m0_Probe_emacs_main_TransactionStatProfiler_base]
    }

}

#
# i_noc_mpu_m0_nand_m_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_nand_m_I_main_QosGenerator_base {} {return 0xffd16580}
proc hps_instantiate_i_noc_mpu_m0_nand_m_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_nand_m_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_nand_m_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_nand_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_nand_m_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_nand_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_nand_m_I_main_QosGenerator_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_3
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_3_base {} {return 0xffb04000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_3 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_3.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_3_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_3.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_3_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_3.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_3_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_Direct_access
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_Direct_access_base {} {return 0xffb20000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_Direct_access {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_Direct_access.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_Direct_access_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_Direct_access.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_Direct_access_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_Direct_access.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_Direct_access_base]
    }

}

#
# i_rom_onchip_rom_block
#
proc hps_i_rom_onchip_rom_block_base {} {return 0xfffc0000}
proc hps_instantiate_i_rom_onchip_rom_block {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_rom_onchip_rom_block.interrupt_sender h2f_i_rom_onchip_rom_block_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_rom_onchip_rom_block.axi_slave0 [hps_i_rom_onchip_rom_block_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_rom_onchip_rom_block.axi_slave0 [hps_i_rom_onchip_rom_block_base]
    }

}

#
# noc_fw_ddr_mpu_fpga2sdram_ddr_scr
#
proc hps_noc_fw_ddr_mpu_fpga2sdram_ddr_scr_base {} {return 0xffd13300}
proc hps_instantiate_noc_fw_ddr_mpu_fpga2sdram_ddr_scr {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection noc_fw_ddr_mpu_fpga2sdram_ddr_scr.interrupt_sender h2f_noc_fw_ddr_mpu_fpga2sdram_ddr_scr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master noc_fw_ddr_mpu_fpga2sdram_ddr_scr.axi_slave0 [hps_noc_fw_ddr_mpu_fpga2sdram_ddr_scr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master noc_fw_ddr_mpu_fpga2sdram_ddr_scr.axi_slave0 [hps_noc_fw_ddr_mpu_fpga2sdram_ddr_scr_base]
    }

}

#
# noc_fw_ddr_l3_ddr_scr
#
proc hps_noc_fw_ddr_l3_ddr_scr_base {} {return 0xffd13400}
proc hps_instantiate_noc_fw_ddr_l3_ddr_scr {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection noc_fw_ddr_l3_ddr_scr.interrupt_sender h2f_noc_fw_ddr_l3_ddr_scr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master noc_fw_ddr_l3_ddr_scr.axi_slave0 [hps_noc_fw_ddr_l3_ddr_scr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master noc_fw_ddr_l3_ddr_scr.axi_slave0 [hps_noc_fw_ddr_l3_ddr_scr_base]
    }

}

#
# i_qspi_qspiregs
#
proc hps_i_qspi_qspiregs_base {} {return 0xff809000}
proc hps_instantiate_i_qspi_qspiregs {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_qspi_qspiregs.interrupt_sender h2f_i_qspi_qspiregs_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_qspi_qspiregs.axi_slave0 [hps_i_qspi_qspiregs_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_qspi_qspiregs.axi_slave0 [hps_i_qspi_qspiregs_base]
    }

}

#
# i_noc_mpu_m0_ddr_T_main_Scheduler
#
proc hps_i_noc_mpu_m0_ddr_T_main_Scheduler_base {} {return 0xffd12400}
proc hps_instantiate_i_noc_mpu_m0_ddr_T_main_Scheduler {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_ddr_T_main_Scheduler.interrupt_sender h2f_i_noc_mpu_m0_ddr_T_main_Scheduler_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_ddr_T_main_Scheduler.axi_slave0 [hps_i_noc_mpu_m0_ddr_T_main_Scheduler_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_ddr_T_main_Scheduler.axi_slave0 [hps_i_noc_mpu_m0_ddr_T_main_Scheduler_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_0
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_0_base {} {return 0xffb01000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_0 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_0.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_0.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_0_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_0.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_0_base]
    }

}

#
# i_nand_status
#
proc hps_i_nand_status_base {} {return 0xffb80400}
proc hps_instantiate_i_nand_status {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_nand_status.interrupt_sender h2f_i_nand_status_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_nand_status.axi_slave0 [hps_i_nand_status_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_nand_status.axi_slave0 [hps_i_nand_status_base]
    }

}

#
# i_spis_0_spis
#
proc hps_i_spis_0_spis_base {} {return 0xffda2000}
proc hps_instantiate_i_spis_0_spis {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_spis_0_spis spi

    hps_utils_set_swEnabled i_spis_0_spis $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_spis_0_spis.interrupt_sender h2f_i_spis_0_spis_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_spis_0_spis.axi_slave0 [hps_i_spis_0_spis_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_spis_0_spis.axi_slave0 [hps_i_spis_0_spis_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_spis_0_spis.interrupt_sender 18

}

#
# i_io48_pin_mux_dedicated_io_grp
#
proc hps_i_io48_pin_mux_dedicated_io_grp_base {} {return 0xffd07200}
proc hps_instantiate_i_io48_pin_mux_dedicated_io_grp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_io48_pin_mux_dedicated_io_grp.interrupt_sender h2f_i_io48_pin_mux_dedicated_io_grp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_io48_pin_mux_dedicated_io_grp.axi_slave0 [hps_i_io48_pin_mux_dedicated_io_grp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_io48_pin_mux_dedicated_io_grp.axi_slave0 [hps_i_io48_pin_mux_dedicated_io_grp_base]
    }

}

#
# i_sys_mgr_core
#
proc hps_i_sys_mgr_core_base {} {return 0xffd06000}
proc hps_instantiate_i_sys_mgr_core {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 i_sys_mgr_core sysmgr

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_sys_mgr_core.interrupt_sender h2f_i_sys_mgr_core_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_sys_mgr_core.axi_slave0 [hps_i_sys_mgr_core_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_sys_mgr_core.axi_slave0 [hps_i_sys_mgr_core_base]
    }

    #hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_0 i_sys_mgr_core.interrupt_sender 0

}

#
# i_usbotg_1_DWC_otg_DFIFO_13
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_13_base {} {return 0xffb4e000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_13 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_13.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_13_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_13.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_13_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_13.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_13_base]
    }

}

#
# i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe
#
proc hps_i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe_base {} {return 0xffd14000}
proc hps_instantiate_i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe.interrupt_sender h2f_i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe.axi_slave0 [hps_i_noc_mpu_m0_Probe_SoC2FPGA_main_Probe_base]
    }

}

#
# ecc_nandecc_ecc_registerBlock
#
proc hps_ecc_nandecc_ecc_registerBlock_base {} {return 0xff8c2000}
proc hps_instantiate_ecc_nandecc_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_nandecc_ecc_registerBlock.interrupt_sender h2f_ecc_nandecc_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_nandecc_ecc_registerBlock.axi_slave0 [hps_ecc_nandecc_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_nandecc_ecc_registerBlock.axi_slave0 [hps_ecc_nandecc_ecc_registerBlock_base]
    }

}

#
# i_sys_mgr_rom
#
proc hps_i_sys_mgr_rom_base {} {return 0xffd06200}
proc hps_instantiate_i_sys_mgr_rom {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_sys_mgr_rom.interrupt_sender h2f_i_sys_mgr_rom_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_sys_mgr_rom.axi_slave0 [hps_i_sys_mgr_rom_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_sys_mgr_rom.axi_slave0 [hps_i_sys_mgr_rom_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_12
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_12_base {} {return 0xffb0d000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_12 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_12.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_12_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_12.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_12_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_12.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_12_base]
    }

}

#
# i_io48_pin_mux_shared_3v_io_grp
#
proc hps_i_io48_pin_mux_shared_3v_io_grp_base {} {return 0xffd07000}
proc hps_instantiate_i_io48_pin_mux_shared_3v_io_grp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_io48_pin_mux_shared_3v_io_grp.interrupt_sender h2f_i_io48_pin_mux_shared_3v_io_grp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_io48_pin_mux_shared_3v_io_grp.axi_slave0 [hps_i_io48_pin_mux_shared_3v_io_grp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_io48_pin_mux_shared_3v_io_grp.axi_slave0 [hps_i_io48_pin_mux_shared_3v_io_grp_base]
    }

}

#
# i_sec_mgr_aesfifo
#
proc hps_i_sec_mgr_aesfifo_base {} {return 0xffcfe000}
proc hps_instantiate_i_sec_mgr_aesfifo {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_sec_mgr_aesfifo.interrupt_sender h2f_i_sec_mgr_aesfifo_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_sec_mgr_aesfifo.axi_slave0 [hps_i_sec_mgr_aesfifo_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_sec_mgr_aesfifo.axi_slave0 [hps_i_sec_mgr_aesfifo_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_8
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_8_base {} {return 0xffb09000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_8 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_8.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_8_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_8.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_8_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_8.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_8_base]
    }

}

#
# ecc_sdmmc_ecc_registerBlock
#
proc hps_ecc_sdmmc_ecc_registerBlock_base {} {return 0xff8c2c00}
proc hps_instantiate_ecc_sdmmc_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_sdmmc_ecc_registerBlock.interrupt_sender h2f_ecc_sdmmc_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_sdmmc_ecc_registerBlock.axi_slave0 [hps_ecc_sdmmc_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_sdmmc_ecc_registerBlock.axi_slave0 [hps_ecc_sdmmc_ecc_registerBlock_base]
    }

}

#
# i_gpio_0_gpio
#
proc hps_i_gpio_0_gpio_base {} {return 0xffc02900}
proc hps_instantiate_i_gpio_0_gpio {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_gpio_0_gpio dw-gpio

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_gpio_0_gpio.interrupt_sender h2f_i_gpio_0_gpio_interrupt
        return
    }

    set_instance_parameter_value i_gpio_0_gpio embeddedsw.dts.instance.GPIO_PORTA_INTR 1
    set_instance_parameter_value i_gpio_0_gpio embeddedsw.dts.instance.GPIO_PWIDTH_A 24
    set_instance_parameter_value i_gpio_0_gpio embeddedsw.dts.instance.GPIO_PWIDTH_B 0
    set_instance_parameter_value i_gpio_0_gpio embeddedsw.dts.instance.GPIO_PWIDTH_C 0
    set_instance_parameter_value i_gpio_0_gpio embeddedsw.dts.instance.GPIO_PWIDTH_D 0

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_gpio_0_gpio.axi_slave0 [hps_i_gpio_0_gpio_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_gpio_0_gpio.axi_slave0 [hps_i_gpio_0_gpio_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_gpio_0_gpio.interrupt_sender 29

}

#
# i_usbotg_0_DWC_otg_DFIFO_5
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_5_base {} {return 0xffb06000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_5 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_5.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_5_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_5.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_5_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_5.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_5_base]
    }

}

#
# i_rst_mgr_rstmgr
#
proc hps_i_rst_mgr_rstmgr_base {} {return 0xffd05000}
proc hps_instantiate_i_rst_mgr_rstmgr {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 i_rst_mgr_rstmgr rstmgr

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_rst_mgr_rstmgr.interrupt_sender h2f_i_rst_mgr_rstmgr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_rst_mgr_rstmgr.axi_slave0 [hps_i_rst_mgr_rstmgr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_rst_mgr_rstmgr.axi_slave0 [hps_i_rst_mgr_rstmgr_base]
    }

   # hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_rst_mgr_rstmgr.interrupt_sender 7

}

#
# i_usbotg_0_pwrclkgrp
#
proc hps_i_usbotg_0_pwrclkgrp_base {} {return 0xffb00e00}
proc hps_instantiate_i_usbotg_0_pwrclkgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_pwrclkgrp.interrupt_sender h2f_i_usbotg_0_pwrclkgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_pwrclkgrp.axi_slave0 [hps_i_usbotg_0_pwrclkgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_pwrclkgrp.axi_slave0 [hps_i_usbotg_0_pwrclkgrp_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator_base {} {return 0xffd17000}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram2_axi128_I_main_QosGenerator_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_1
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_1_base {} {return 0xffb42000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_1 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_1.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_1.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_1_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_1.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_1_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_2
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_2_base {} {return 0xffb03000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_2 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_2.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_2_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_2.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_2_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_2.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_2_base]
    }

}

#
# i_spim_1_spim
#
proc hps_i_spim_1_spim_base {} {return 0xffda5000}
proc hps_instantiate_i_spim_1_spim {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_mp_clk i_spim_1_spim spi

    hps_utils_set_swEnabled i_spim_1_spim $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_spim_1_spim.interrupt_sender h2f_i_spim_1_spim_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_spim_1_spim.axi_slave0 [hps_i_spim_1_spim_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_spim_1_spim.axi_slave0 [hps_i_spim_1_spim_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_spim_1_spim.interrupt_sender 21

}

#
# i_watchdog_1_l4wd
#
proc hps_i_watchdog_1_l4wd_base {} {return 0xffd00300}
proc hps_instantiate_i_watchdog_1_l4wd {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sys_free_clk i_watchdog_1_l4wd dw_wd_timer

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_watchdog_1_l4wd.interrupt_sender h2f_i_watchdog_1_l4wd_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_watchdog_1_l4wd.axi_slave0 [hps_i_watchdog_1_l4wd_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_watchdog_1_l4wd.axi_slave0 [hps_i_watchdog_1_l4wd_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_watchdog_1_l4wd.interrupt_sender 5

}

#
# i_clk_mgr_perpllgrp
#
proc hps_i_clk_mgr_perpllgrp_base {} {return 0xffd040c0}
proc hps_instantiate_i_clk_mgr_perpllgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_clk_mgr_perpllgrp.interrupt_sender h2f_i_clk_mgr_perpllgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_clk_mgr_perpllgrp.axi_slave0 [hps_i_clk_mgr_perpllgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_clk_mgr_perpllgrp.axi_slave0 [hps_i_clk_mgr_perpllgrp_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_0
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_0_base {} {return 0xffb41000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_0 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_0.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_0.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_0_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_0.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_0_base]
    }

}

#
# noc_l4_priv_l4_priv_filter
#
proc hps_noc_l4_priv_l4_priv_filter_base {} {return 0xffd11000}
proc hps_instantiate_noc_l4_priv_l4_priv_filter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection noc_l4_priv_l4_priv_filter.interrupt_sender h2f_noc_l4_priv_l4_priv_filter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master noc_l4_priv_l4_priv_filter.axi_slave0 [hps_noc_l4_priv_l4_priv_filter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master noc_l4_priv_l4_priv_filter.axi_slave0 [hps_noc_l4_priv_l4_priv_filter_base]
    }

}

#
# i_dma_DMANONSECURE
#
proc hps_i_dma_DMANONSECURE_base {} {return 0xffda0000}
proc hps_instantiate_i_dma_DMANONSECURE {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_dma_DMANONSECURE.interrupt_sender h2f_i_dma_DMANONSECURE_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_dma_DMANONSECURE.axi_slave0 [hps_i_dma_DMANONSECURE_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_dma_DMANONSECURE.axi_slave0 [hps_i_dma_DMANONSECURE_base]
    }

}

#
# i_usbotg_0_devgrp
#
proc hps_i_usbotg_0_devgrp_base {} {return 0xffb00800}
proc hps_instantiate_i_usbotg_0_devgrp {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_devgrp.interrupt_sender h2f_i_usbotg_0_devgrp_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_devgrp.axi_slave0 [hps_i_usbotg_0_devgrp_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_devgrp.axi_slave0 [hps_i_usbotg_0_devgrp_base]
    }

}

#
# i_noc_mpu_m0_dma_m0_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_dma_m0_I_main_QosGenerator_base {} {return 0xffd16280}
proc hps_instantiate_i_noc_mpu_m0_dma_m0_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_dma_m0_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_dma_m0_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_dma_m0_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_dma_m0_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_dma_m0_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_dma_m0_I_main_QosGenerator_base]
    }

}

#
# noc_fw_l4_per_l4_per_scr
#
proc hps_noc_fw_l4_per_l4_per_scr_base {} {return 0xffd13000}
proc hps_instantiate_noc_fw_l4_per_l4_per_scr {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection noc_fw_l4_per_l4_per_scr.interrupt_sender h2f_noc_fw_l4_per_l4_per_scr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master noc_fw_l4_per_l4_per_scr.axi_slave0 [hps_noc_fw_l4_per_l4_per_scr_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master noc_fw_l4_per_l4_per_scr.axi_slave0 [hps_noc_fw_l4_per_l4_per_scr_base]
    }

}

#
# i_noc_mpu_m0_emac0_m_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_emac0_m_I_main_QosGenerator_base {} {return 0xffd16300}
proc hps_instantiate_i_noc_mpu_m0_emac0_m_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_emac0_m_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_emac0_m_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_emac0_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_emac0_m_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_emac0_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_emac0_m_I_main_QosGenerator_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator_base {} {return 0xffd16780}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram0_axi128_I_main_QosGenerator_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_14
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_14_base {} {return 0xffb4f000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_14 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_14.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_14_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_14.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_14_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_14.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_14_base]
    }

}

#
# i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint
#
proc hps_i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint_base {} {return 0xffd14900}
proc hps_instantiate_i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint.interrupt_sender h2f_i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint.axi_slave0 [hps_i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint.axi_slave0 [hps_i_noc_mpu_m0_cs_obs_at_main_AtbEndPoint_base]
    }

}

#
# i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator_base {} {return 0xffd16900}
proc hps_instantiate_i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_fpga2sdram2_axi32_I_main_QosGenerator_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_7
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_7_base {} {return 0xffb48000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_7 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_7.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_7_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_7.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_7_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_7.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_7_base]
    }

}

#
# i_timer_sys_0_timer
#
proc hps_i_timer_sys_0_timer_base {} {return 0xffd00000}
proc hps_instantiate_i_timer_sys_0_timer {num_a9s} {

    hps_utils_add_instance_clk_reset eosc1 i_timer_sys_0_timer dw_apb_timer_osc

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_timer_sys_0_timer.interrupt_sender h2f_i_timer_sys_0_timer_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_timer_sys_0_timer.axi_slave0 [hps_i_timer_sys_0_timer_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_timer_sys_0_timer.axi_slave0 [hps_i_timer_sys_0_timer_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_115 i_timer_sys_0_timer.interrupt_sender 2

}

#
# i_noc_mpu_m0_emac1_m_I_main_QosGenerator
#
proc hps_i_noc_mpu_m0_emac1_m_I_main_QosGenerator_base {} {return 0xffd16380}
proc hps_instantiate_i_noc_mpu_m0_emac1_m_I_main_QosGenerator {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_emac1_m_I_main_QosGenerator.interrupt_sender h2f_i_noc_mpu_m0_emac1_m_I_main_QosGenerator_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_emac1_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_emac1_m_I_main_QosGenerator_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_emac1_m_I_main_QosGenerator.axi_slave0 [hps_i_noc_mpu_m0_emac1_m_I_main_QosGenerator_base]
    }

}

#
# mpu_reg_scu_MPUSCU
#
proc hps_mpu_reg_scu_MPUSCU_base {} {return 0xffffc000}
proc hps_instantiate_mpu_reg_scu_MPUSCU {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection mpu_reg_scu_MPUSCU.interrupt_sender h2f_mpu_reg_scu_MPUSCU_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master mpu_reg_scu_MPUSCU.axi_slave0 [hps_mpu_reg_scu_MPUSCU_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master mpu_reg_scu_MPUSCU.axi_slave0 [hps_mpu_reg_scu_MPUSCU_base]
    }

}

#
# i_usbotg_0_DWC_otg_DFIFO_14
#
proc hps_i_usbotg_0_DWC_otg_DFIFO_14_base {} {return 0xffb0f000}
proc hps_instantiate_i_usbotg_0_DWC_otg_DFIFO_14 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_0_DWC_otg_DFIFO_14.interrupt_sender h2f_i_usbotg_0_DWC_otg_DFIFO_14_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_14.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_14_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_0_DWC_otg_DFIFO_14.axi_slave0 [hps_i_usbotg_0_DWC_otg_DFIFO_14_base]
    }

}

#
# i_uart_1_uart
#
proc hps_i_uart_1_uart_base {} {return 0xffc02100}
proc hps_instantiate_i_uart_1_uart {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.l4_sp_clk i_uart_1_uart snps_uart

    hps_utils_set_swEnabled i_uart_1_uart $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_uart_1_uart.interrupt_sender h2f_i_uart_1_uart_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_uart_1_uart.axi_slave0 [hps_i_uart_1_uart_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_uart_1_uart.axi_slave0 [hps_i_uart_1_uart_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_83 i_uart_1_uart.interrupt_sender 28

}

#
# ecc_otg1_ecc_registerBlock
#
proc hps_ecc_otg1_ecc_registerBlock_base {} {return 0xff8c8c00}
proc hps_instantiate_ecc_otg1_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_otg1_ecc_registerBlock.interrupt_sender h2f_ecc_otg1_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_otg1_ecc_registerBlock.axi_slave0 [hps_ecc_otg1_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_otg1_ecc_registerBlock.axi_slave0 [hps_ecc_otg1_ecc_registerBlock_base]
    }

}

#
# i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter
#
proc hps_i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter_base {} {return 0xffd11300}
proc hps_instantiate_i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter.interrupt_sender h2f_i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_L4_MP_rate_ad_main_RateAdapter_base]
    }

}

#
# i_usbotg_1_DWC_otg_DFIFO_3
#
proc hps_i_usbotg_1_DWC_otg_DFIFO_3_base {} {return 0xffb44000}
proc hps_instantiate_i_usbotg_1_DWC_otg_DFIFO_3 {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_usbotg_1_DWC_otg_DFIFO_3.interrupt_sender h2f_i_usbotg_1_DWC_otg_DFIFO_3_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_3.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_3_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_usbotg_1_DWC_otg_DFIFO_3.axi_slave0 [hps_i_usbotg_1_DWC_otg_DFIFO_3_base]
    }

}

#
# i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter
#
proc hps_i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter_base {} {return 0xffd11400}
proc hps_instantiate_i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter.interrupt_sender h2f_i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter.axi_slave0 [hps_i_noc_mpu_m0_fpga2soc_rate_ad_main_RateAdapter_base]
    }

}

#
# ecc_emac1_rx_ecc_registerBlock
#
proc hps_ecc_emac1_rx_ecc_registerBlock_base {} {return 0xff8c1000}
proc hps_instantiate_ecc_emac1_rx_ecc_registerBlock {num_a9s} {

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection ecc_emac1_rx_ecc_registerBlock.interrupt_sender h2f_ecc_emac1_rx_ecc_registerBlock_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master ecc_emac1_rx_ecc_registerBlock.axi_slave0 [hps_ecc_emac1_rx_ecc_registerBlock_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master ecc_emac1_rx_ecc_registerBlock.axi_slave0 [hps_ecc_emac1_rx_ecc_registerBlock_base]
    }

}

proc hps_instantiate_clark_timer {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clark_clkmgr.mpu_periph_clk timer timer

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master timer.axi_slave0 {0xffffc600}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master timer.axi_slave0 {0xffffc600}
    }

    add_connection arm_gic_0.arm_gic_ppi timer.interrupt_sender
    set_connection_parameter_value arm_gic_0.arm_gic_ppi/timer.interrupt_sender irqNumber 13
}

