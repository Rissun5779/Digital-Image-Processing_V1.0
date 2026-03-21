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


package require -exact qsys 12.0
source "$hard_peripheral_logical_view_dir/common/hps_utils.tcl"
#
# arm_gic_0
#
proc hps_instantiate_arm_gic_0 {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 arm_gic_0 arm_gic

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master arm_gic_0.axi_slave0 {0xfffed000}

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master arm_gic_0.axi_slave0 {0xfffed000}
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master arm_gic_0.axi_slave1 {0xfffec100}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master arm_gic_0.axi_slave1 {0xfffec100}
    }

}

#
# L2
#
proc hps_instantiate_L2 {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 L2 arm_pl310_L2

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection L2.interrupt_sender h2f_L2_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master L2.axi_slave0 {0xfffef000}

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master L2.axi_slave0 {0xfffef000}
    }



    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_32 L2.interrupt_sender 6

}

#
# dma
#
proc hps_instantiate_dma {num_a9s} {

    #hps_utils_add_instance_clk_reset clk_0 dma dma
    add_instance dma arm_pl330_dma 18.1
    add_connection clk_0.clk_reset dma.reset_sink
    add_connection clkmgr.l4_main_clk dma.apb_pclk clock

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection dma.interrupt_sender h2f_dma_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master dma.axi_slave0 {0xffe01000}

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master dma.axi_slave0 {0xffe01000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 dma.interrupt_sender 0

}

#
# sysmgr
#
proc hps_instantiate_sysmgr {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 sysmgr altera_sysmgr

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master sysmgr.axi_slave0 {0xffd08000}

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master sysmgr.axi_slave0 {0xffd08000}
    }
    


}

#
# clkmgr
#
proc hps_instantiate_clkmgr {num_a9s} {

    add_instance clkmgr asimov_clkmgr 18.1
    add_connection clk_0.clk_reset clkmgr.reset_sink
    add_connection eosc1.clk clkmgr.eosc1 clock
	
    add_connection eosc2.clk clkmgr.eosc2 clock

    add_connection f2s_periph_ref_clk.clk clkmgr.f2s_periph_ref_clk clock

    add_connection f2s_sdram_ref_clk.clk clkmgr.f2s_sdram_ref_clk clock

    # Copy parameter values from compositing parent hw.tcl to child instance hw.tcl.
    # Parent hw.tcl must contain all parameters in child instance hw.tcl.

    # The following clocks are now specified using divider values,
    # however the frequency parameters are still being reported by
    # get_instance_parameters, to workaround this, we will manually
    # exclude them as we transfer parameter values from parent to 
    # child logical callback instance
    set exclude_param_name [ list desired_l3_mp_clk_mhz desired_l3_sp_clk_mhz desired_dbg_at_clk_mhz desired_dbg_clk_mhz desired_dbg_trace_clk_mhz ]
	
    foreach param_name [get_instance_parameters clkmgr] {
    	if { [ lsearch $exclude_param_name $param_name ] < 0 } {
    		set_instance_parameter clkmgr $param_name [get_parameter_value $param_name]
    	}
    }

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master clkmgr.axi_slave0 {0xffd04000}

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master clkmgr.axi_slave0 {0xffd04000}
    }


}

#
# rstmgr
#
proc hps_instantiate_rstmgr {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 rstmgr altera_rstmgr

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master rstmgr.axi_slave0 {0xffd05000}

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master rstmgr.axi_slave0 {0xffd05000}
    }


}

#
# sdrctl
#
proc hps_sdrctl_base {} {return 0xffc25000}
proc hps_instantiate_sdrctl {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 sdrctl altera_sdrctl

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master sdrctl.axi_slave0 [hps_sdrctl_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master sdrctl.axi_slave0 [hps_sdrctl_base]
    }


}

#
# l3regs
#
proc hps_l3regs_base {} {return 0xff800000}
proc hps_instantiate_l3regs {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 l3regs altera_l3regs

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master l3regs.axi_slave0 [hps_l3regs_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master l3regs.axi_slave0 [hps_l3regs_base]
    }


}

#
# dcan0
#
proc hps_dcan0_base {} {return 0xffc00000}
proc hps_instantiate_dcan0 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.can0_clk dcan0 bosch-dcan

    hps_utils_set_swEnabled dcan0 $pinmux

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master dcan0.axi_slave0 [hps_dcan0_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master dcan0.axi_slave0 [hps_dcan0_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 dcan0.interrupt_sender0 27
    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 dcan0.interrupt_sender1 28

}

#
# dcan1
#
proc hps_dcan1_base {} {return 0xffc01000}
proc hps_instantiate_dcan1 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.can1_clk dcan1 bosch-dcan

    hps_utils_set_swEnabled dcan1 $pinmux

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master dcan1.axi_slave0 [hps_dcan1_base]

    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master dcan1.axi_slave0 [hps_dcan1_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 dcan1.interrupt_sender0 31
    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 dcan1.interrupt_sender1 0

}

proc hps_instantiate_pmu {} {
    hps_utils_add_instance_clk_reset clk_0 pmu0 pmu
    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 pmu0.interrupt_sender0 10
    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 pmu0.interrupt_sender1 11
}
# fpgamgr
#
proc hps_instantiate_fpgamgr {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 fpgamgr altera_fpgamgr

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection fpgamgr.interrupt_sender h2f_fpgamgr_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master fpgamgr.axi_slave0 {0xff706000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master fpgamgr.axi_slave0 {0xff706000}
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master fpgamgr.axi_slave1 {0xffb90000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master fpgamgr.axi_slave1 {0xffb90000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 fpgamgr.interrupt_sender 9

}

#
# uart0
#
proc hps_instantiate_uart0 {num_a9s pinmux clk_freq_mhz} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk uart0 snps_uart

    hps_utils_set_swEnabled uart0 $pinmux

    set_instance_parameter_value uart0 clk_freq_mhz $clk_freq_mhz

    if {[get_parameter_value S2FINTERRUPT_UART_Enable]} {
	send_message debug "S2FINTERRUPT_UART_Enable is set"
	add_interface h2f_uart0_interrupt interrupt end
	set_interface_property h2f_uart0_interrupt EXPORT_OF uart0.interrupt_sender
	set_interface_property h2f_uart0_interrupt PORT_NAME_MAP "h2f_uart0_irq interrupt_sender"
    } 


    hps_utils_add_slave_interface arm_a9_0.altera_axi_master uart0.axi_slave0 {0xffc02000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master uart0.axi_slave0 {0xffc02000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 uart0.interrupt_sender 26

}

#
# uart1
#
proc hps_instantiate_uart1 {num_a9s pinmux clk_freq_mhz} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk uart1 snps_uart

    hps_utils_set_swEnabled uart1 $pinmux

    set_instance_parameter_value uart1 clk_freq_mhz $clk_freq_mhz

    if {[get_parameter_value S2FINTERRUPT_UART_Enable]} {
	send_message debug "S2FINTERRUPT_UART_Enable is set"
	add_interface h2f_uart1_interrupt interrupt end
	set_interface_property h2f_uart1_interrupt EXPORT_OF uart1.interrupt_sender
	set_interface_property h2f_uart1_interrupt PORT_NAME_MAP "h2f_uart1_irq interrupt_sender"
    } 


    hps_utils_add_slave_interface arm_a9_0.altera_axi_master uart1.axi_slave0 {0xffc03000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master uart1.axi_slave0 {0xffc03000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 uart1.interrupt_sender 27

}

#
# timer0
#
proc hps_instantiate_timer0 {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk timer0 dw-apb-timer-sp

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection timer0.interrupt_sender h2f_timer0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master timer0.axi_slave0 {0xffc08000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master timer0.axi_slave0 {0xffc08000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 timer0.interrupt_sender 1

}

#
# timer1
#
proc hps_instantiate_timer1 {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk timer1 dw-apb-timer-sp

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection timer1.interrupt_sender h2f_timer1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master timer1.axi_slave0 {0xffc09000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master timer1.axi_slave0 {0xffc09000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 timer1.interrupt_sender 2

}

#
# timer2
#
proc hps_timer2_base {} {return 0xffd00000}
proc hps_instantiate_timer2 {num_a9s} {

    hps_utils_add_instance_clk_reset eosc1 timer2 dw-apb-timer-osc

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection timer2.interrupt_sender h2f_timer2_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master timer2.axi_slave0 [hps_timer2_base]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master timer2.axi_slave0 [hps_timer2_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 timer2.interrupt_sender 3

}

#
# timer3
#
proc hps_timer3_base {} {return 0xffd01000}
proc hps_instantiate_timer3 {num_a9s} {

    hps_utils_add_instance_clk_reset eosc1 timer3 dw-apb-timer-osc

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection timer3.interrupt_sender h2f_timer3_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master timer3.axi_slave0 [hps_timer3_base]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master timer3.axi_slave0 [hps_timer3_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 timer3.interrupt_sender 4

}

proc hps_wd_timer0_base {} {return 0xffd02000}
proc hps_instantiate_wd_timer0 {num_a9s} {
    hps_utils_add_instance_clk_reset eosc1 wd_timer0 dw_wd_timer

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master wd_timer0.axi_slave0 [hps_wd_timer0_base]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master wd_timer0.axi_slave0 [hps_wd_timer0_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 wd_timer0.interrupt_sender 5
}

proc hps_wd_timer1_base {} {return 0xffd03000}
proc hps_instantiate_wd_timer1 {num_a9s} {
    hps_utils_add_instance_reset_clk clk_0 clkmgr.per_base_clk wd_timer1 dw_wd_timer

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master wd_timer1.axi_slave0 [hps_wd_timer1_base]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master wd_timer1.axi_slave0 [hps_wd_timer1_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 wd_timer1.interrupt_sender 6
}

#
# gpio0
#
proc hps_instantiate_gpio0 {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_mp_clk gpio0 dw-gpio

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection gpio0.interrupt_sender h2f_gpio0_interrupt
        return
    }

    set_instance_parameter_value gpio0 embeddedsw.dts.instance.GPIO_PORTA_INTR 1
    set_instance_parameter_value gpio0 embeddedsw.dts.instance.GPIO_PWIDTH_A 29
    set_instance_parameter_value gpio0 embeddedsw.dts.instance.GPIO_PWIDTH_B 0
    set_instance_parameter_value gpio0 embeddedsw.dts.instance.GPIO_PWIDTH_C 0
    set_instance_parameter_value gpio0 embeddedsw.dts.instance.GPIO_PWIDTH_D 0

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master gpio0.axi_slave0 {0xff708000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master gpio0.axi_slave0 {0xff708000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 gpio0.interrupt_sender 28

}

#
# gpio1
#
proc hps_instantiate_gpio1 {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_mp_clk gpio1 dw-gpio

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection gpio1.interrupt_sender h2f_gpio1_interrupt
        return
    }

    set_instance_parameter_value gpio1 embeddedsw.dts.instance.GPIO_PORTA_INTR 1
    set_instance_parameter_value gpio1 embeddedsw.dts.instance.GPIO_PWIDTH_A 29
    set_instance_parameter_value gpio1 embeddedsw.dts.instance.GPIO_PWIDTH_B 0
    set_instance_parameter_value gpio1 embeddedsw.dts.instance.GPIO_PWIDTH_C 0
    set_instance_parameter_value gpio1 embeddedsw.dts.instance.GPIO_PWIDTH_D 0

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master gpio1.axi_slave0 {0xff709000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master gpio1.axi_slave0 {0xff709000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 gpio1.interrupt_sender 29

}

#
# gpio2
#
proc hps_instantiate_gpio2 {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_mp_clk gpio2 dw-gpio

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection gpio2.interrupt_sender h2f_gpio2_interrupt
        return
    }

    set_instance_parameter_value gpio2 embeddedsw.dts.instance.GPIO_PORTA_INTR 1
    set_instance_parameter_value gpio2 embeddedsw.dts.instance.GPIO_PWIDTH_A 27
    set_instance_parameter_value gpio2 embeddedsw.dts.instance.GPIO_PWIDTH_B 0
    set_instance_parameter_value gpio2 embeddedsw.dts.instance.GPIO_PWIDTH_C 0
    set_instance_parameter_value gpio2 embeddedsw.dts.instance.GPIO_PWIDTH_D 0


    hps_utils_add_slave_interface arm_a9_0.altera_axi_master gpio2.axi_slave0 {0xff70a000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master gpio2.axi_slave0 {0xff70a000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_166 gpio2.interrupt_sender 0

}

#
# i2c0
#
proc hps_instantiate_i2c0 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk i2c0 designware-i2c

    hps_utils_set_swEnabled i2c0 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i2c0.interrupt_sender h2f_i2c0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i2c0.axi_slave0 {0xffc04000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i2c0.axi_slave0 {0xffc04000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 i2c0.interrupt_sender 22

}

#
# i2c1
#
proc hps_instantiate_i2c1 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk i2c1 designware-i2c

    hps_utils_set_swEnabled i2c1 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i2c1.interrupt_sender h2f_i2c1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i2c1.axi_slave0 {0xffc05000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i2c1.axi_slave0 {0xffc05000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 i2c1.interrupt_sender 23

}

#
# i2c2
#
proc hps_instantiate_i2c2 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk i2c2 designware-i2c

    hps_utils_set_swEnabled i2c2 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i2c2.interrupt_sender h2f_i2c2_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i2c2.axi_slave0 {0xffc06000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i2c2.axi_slave0 {0xffc06000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 i2c2.interrupt_sender 24

}

#
# i2c3
#
proc hps_instantiate_i2c3 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.l4_sp_clk i2c3 designware-i2c

    hps_utils_set_swEnabled i2c3 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection i2c3.interrupt_sender h2f_i2c3_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master i2c3.axi_slave0 {0xffc07000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master i2c3.axi_slave0 {0xffc07000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 i2c3.interrupt_sender 25

}

#
# nand0
#
proc hps_instantiate_nand0 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.nand_clk nand0 denali_nand

    hps_utils_set_swEnabled nand0 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection nand0.interrupt_sender h2f_nand0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master nand0.axi_slave0 {0xff900000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master nand0.axi_slave0 {0xff900000}
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master nand0.axi_slave1 {0xffb80000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master nand0.axi_slave1 {0xffb80000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 nand0.interrupt_sender 8

}

#
# spi0
#
proc hps_spim0_base {} {return 0xfff00000}
proc hps_instantiate_spim0 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.spi_m_clk spim0 spi

    hps_utils_set_swEnabled spim0 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection spim0.interrupt_sender h2f_spi0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master spim0.axi_slave0 [hps_spim0_base]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master spim0.axi_slave0 [hps_spim0_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 spim0.interrupt_sender 18

}

#
# spi1
#
proc hps_spim1_base {} {return 0xfff01000}
proc hps_instantiate_spim1 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.spi_m_clk spim1 spi

    hps_utils_set_swEnabled spim1 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection spim1.interrupt_sender h2f_spim1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master spim1.axi_slave0 [hps_spim1_base]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master spim1.axi_slave0 [hps_spim1_base]
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 spim1.interrupt_sender 19

}

#
# qspi
#
proc hps_instantiate_qspi {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.qspi_clk qspi cadence_qspi

    hps_utils_set_swEnabled qspi $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection qspi.interrupt_sender h2f_qspi_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master qspi.axi_slave0 {0xff705000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master qspi.axi_slave0 {0xff705000}
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master qspi.axi_slave1 {0xffa00000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master qspi.axi_slave1 {0xffa00000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 qspi.interrupt_sender 15

}

#
# sdmmc
#
proc hps_instantiate_sdmmc {num_a9s pinmux} {

    #hps_utils_add_instance_clk_reset clk_0 sdmmc sdmmc
    add_instance sdmmc sdmmc 18.1
    add_connection clk_0.clk_reset sdmmc.reset_sink
    add_connection clkmgr.l4_mp_clk sdmmc.biu clock
    add_connection clkmgr.sdmmc_clk sdmmc.ciu clock

    hps_utils_set_swEnabled sdmmc $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection sdmmc.interrupt_sender h2f_sdmmc_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master sdmmc.axi_slave0 {0xff704000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master sdmmc.axi_slave0 {0xff704000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_136 sdmmc.interrupt_sender 3

}

#
# usb0
#
proc hps_instantiate_usb0 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.usb_mp_clk usb0 usb

    hps_utils_set_swEnabled usb0 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection usb0.interrupt_sender h2f_usb0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master usb0.axi_slave0 {0xffb00000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master usb0.axi_slave0 {0xffb00000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 usb0.interrupt_sender 21

}

#
# usb1
#
proc hps_instantiate_usb1 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.usb_mp_clk usb1 usb

    hps_utils_set_swEnabled usb1 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection usb1.interrupt_sender h2f_usb1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master usb1.axi_slave0 {0xffb40000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master usb1.axi_slave0 {0xffb40000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 usb1.interrupt_sender 24

}

#
# gmac0
#
proc hps_instantiate_gmac0 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.emac0_clk gmac0 stmmac

    hps_utils_set_swEnabled gmac0 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection gmac0.interrupt_sender h2f_gmac0_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master gmac0.axi_slave0 {0xff700000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master gmac0.axi_slave0 {0xff700000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 gmac0.interrupt_sender 11

}

#
# gmac1
#
proc hps_instantiate_gmac1 {num_a9s pinmux} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.emac1_clk gmac1 stmmac

    hps_utils_set_swEnabled gmac1 $pinmux

    if {$num_a9s == 0} {
        hps_utils_add_fpga_irq_connection gmac1.interrupt_sender h2f_gmac1_interrupt
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master gmac1.axi_slave0 {0xff702000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master gmac1.axi_slave0 {0xff702000}
    }

    hps_utils_add_gic_irq_connection arm_gic_0.irq_rx_offset_104 gmac1.interrupt_sender 16

}

#
# h2f
#
proc hps_instantiate_h2f {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 h2f hps_h2f_bridge_avalon

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master h2f.axi_slave0 {0xc0000000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master h2f.axi_slave0 {0xc0000000}
    }

}

#
# h2f_lw
#
proc hps_instantiate_h2f_lw {num_a9s} {

    #hps_utils_add_instance_clk_reset clk_0 h2f_lw hps_h2flw_bridge_avalon

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master h2f_lw.axi_slave0 {0xff200000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master h2f_lw.axi_slave0 {0xff200000}
    }

}

#
# axi_ocram
#
proc hps_instantiate_axi_ocram {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 axi_ocram axi_ocram

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master axi_ocram.axi_slave0 {0xffff0000}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master axi_ocram.axi_slave0 {0xffff0000}
    }

}

#
# axi_sdram
#
proc hps_sdram_base {} {return 0x00000000}
proc hps_instantiate_axi_sdram {num_a9s} {

    hps_utils_add_instance_clk_reset clk_0 axi_sdram axi_sdram

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master axi_sdram.axi_slave0 [hps_sdram_base]


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master axi_sdram.axi_slave0 [hps_sdram_base]
    }

}

#
# timer
#
proc hps_instantiate_timer {num_a9s} {

    hps_utils_add_instance_reset_clk clk_0 clkmgr.mpu_periph_clk timer arm_internal_timer

    if {$num_a9s == 0} {
        return
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master timer.axi_slave0 {0xfffec600}


    if {$num_a9s > 1} {
        hps_utils_add_slave_interface arm_a9_1.altera_axi_master timer.axi_slave0 {0xfffec600}
    }
}

proc hps_scu_base {} {return 0xfffec000}
proc hps_instantiate_scu {num_a9s} {
    hps_utils_add_instance_clk_reset clk_0 scu scu

    if {$num_a9s == 0} {
	return;
    }

    hps_utils_add_slave_interface arm_a9_0.altera_axi_master scu.axi_slave0 [hps_scu_base]
    
    if {$num_a9s > 1} {
    	hps_utils_add_slave_interface arm_a9_1.altera_axi_master scu.axi_slave0 [hps_scu_base]
    }
}
