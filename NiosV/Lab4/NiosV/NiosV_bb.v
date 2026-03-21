
module NiosV (
	clk_clk,
	clk_sdram_clk,
	pio_hex_0_export,
	pio_hex_1_export,
	pio_hex_2_export,
	pio_hex_3_export,
	pio_led_export,
	pio_sw_export,
	pll_0_locked_export,
	reset_reset_n,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n);	

	input		clk_clk;
	output		clk_sdram_clk;
	output	[7:0]	pio_hex_0_export;
	output	[7:0]	pio_hex_1_export;
	output	[7:0]	pio_hex_2_export;
	output	[7:0]	pio_hex_3_export;
	output	[7:0]	pio_led_export;
	input	[7:0]	pio_sw_export;
	output		pll_0_locked_export;
	input		reset_reset_n;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
endmodule
