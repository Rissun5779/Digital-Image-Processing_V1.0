// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


module twentynm_hps_interface_interrupts (
   input  wire [63:0] f2s_fpga_irq,
   output wire        fakedout,
   output wire        s2f_clkmgr_irq,
   output wire        s2f_dma_irq_abort,
   output wire        s2f_ecc_derr_irq,
   output wire        s2f_ecc_serr_irq,
   output wire        s2f_emac0_irq,
   output wire        s2f_emac1_irq,
   output wire        s2f_emac2_irq,
   output wire        s2f_fpga_man_irq,
   output wire        s2f_gpio0_irq,
   output wire        s2f_gpio1_irq,
   output wire        s2f_gpio2_irq,
   output wire        s2f_hmc_irq,
   output wire        s2f_i2c0_irq,
   output wire        s2f_i2c1_irq,
   output wire        s2f_i2c_emac0_irq,
   output wire        s2f_i2c_emac1_irq,
   output wire        s2f_i2c_emac2_irq,
   output wire        s2f_mpuwakeup_irq,
   output wire        s2f_nand_irq,
   output wire        s2f_parity_l1_irq,
   output wire        s2f_qspi_irq,
   output wire        s2f_sdmmc_irq,
   output wire        s2f_spim0_irq,
   output wire        s2f_spim1_irq,
   output wire        s2f_spis0_irq,
   output wire        s2f_spis1_irq,
   output wire        s2f_timer_l4sp_0_irq,
   output wire        s2f_timer_l4sp_1_irq,
   output wire        s2f_timer_sys_0_irq,
   output wire        s2f_timer_sys_1_irq,
   output wire        s2f_uart0_irq,
   output wire        s2f_uart1_irq,
   output wire        s2f_usb0_irq,
   output wire        s2f_usb1_irq,
   output wire        s2f_wdog0_irq,
   output wire        s2f_wdog1_irq,
   output wire [7:0]  s2f_dma_irq,
   output wire [1:0]  s2f_ncti_irq
   
);
   assign fake_dout = 1'b0;
   
   altera_avalon_interrupt_sink #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(32),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) f2h_irq0 (
      .clk(1'b0),
      .reset(1'b0),
      .irq(f2s_fpga_irq[31:0])
   );
   
   altera_avalon_interrupt_sink #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(32),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) f2h_irq1 (
      .clk(1'b0),
      .reset(1'b0),
      .irq(f2s_fpga_irq[63:32])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_clkmgr_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_clkmgr_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma_abort_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq_abort)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_ecc_derr_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_ecc_derr_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_ecc_serr_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_ecc_serr_irq)
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_emac0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_emac0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_emac1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_emac1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_emac2_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_emac2_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_fpga_man_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_fpga_man_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_gpio0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_gpio0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_gpio1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_gpio1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_gpio2_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_gpio2_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_hmc_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_hmc_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_i2c0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_i2c0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_i2c1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_i2c1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_i2c_emac0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_i2c_emac0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_i2c_emac1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_i2c_emac1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_i2c_emac2_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_i2c_emac2_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_mpuwakeup_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_mpuwakeup_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_nand_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_nand_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_parity_l1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_parity_l1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_qspi_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_qspi_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_sdmmc_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_sdmmc_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_spim0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_spim0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_spim1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_spim1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_spis0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_spis0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_spis1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_spis1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_timer_l4sp0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_timer_l4sp_0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_timer_l4sp1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_timer_l4sp_1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_timer_sys0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_timer_sys_0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_timer_sys1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_timer_sys_1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_uart0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_uart0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_uart1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_uart1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_usb0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_usb0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_usb1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_usb1_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_wdog0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_wdog0_irq)
   );

   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_wdog1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_wdog1_irq)
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[0])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[1])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma2_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[2])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma3_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[3])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma4_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[4])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma5_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[5])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma6_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[6])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_dma7_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_dma_irq[7])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_ncti0_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_ncti_irq[0])
   );
   
   altera_avalon_interrupt_source #(
      .ASSERT_HIGH_IRQ(1),
      .AV_IRQ_W(1),
      .ASYNCHRONOUS_INTERRUPT(1)
   ) s2f_ncti1_interrupt (
      .clk(1'b0),
      .reset(1'b0),
      .irq(s2f_ncti_irq[1])
   );
   
endmodule 

