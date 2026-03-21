
module NiosV (
	clk_clk,
	pio_hex_0_export,
	pio_hex_1_export,
	pio_hex_2_export,
	pio_hex_3_export,
	pio_led_export,
	pio_sw_export,
	reset_reset_n);	

	input		clk_clk;
	output	[7:0]	pio_hex_0_export;
	output	[7:0]	pio_hex_1_export;
	output	[7:0]	pio_hex_2_export;
	output	[7:0]	pio_hex_3_export;
	output	[7:0]	pio_led_export;
	input	[7:0]	pio_sw_export;
	input		reset_reset_n;
endmodule
