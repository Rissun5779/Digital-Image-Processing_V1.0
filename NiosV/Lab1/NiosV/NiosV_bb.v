
module NiosV (
	clk_clk,
	reset_reset_n,
	pio_led_export,
	pio_sw_export);	

	input		clk_clk;
	input		reset_reset_n;
	output	[7:0]	pio_led_export;
	input	[7:0]	pio_sw_export;
endmodule
