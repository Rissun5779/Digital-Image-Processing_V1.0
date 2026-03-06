
module NiosV (
	clk_clk,
	pio_led_export,
	pio_sw_export,
	reset_reset_n);	

	input		clk_clk;
	output	[7:0]	pio_led_export;
	input	[7:0]	pio_sw_export;
	input		reset_reset_n;
endmodule
