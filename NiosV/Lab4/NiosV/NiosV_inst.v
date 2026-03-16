	NiosV u0 (
		.clk_clk          (<connected-to-clk_clk>),          //        clk.clk
		.pio_hex_0_export (<connected-to-pio_hex_0_export>), //  pio_hex_0.export
		.pio_hex_1_export (<connected-to-pio_hex_1_export>), //  pio_hex_1.export
		.pio_hex_2_export (<connected-to-pio_hex_2_export>), //  pio_hex_2.export
		.pio_hex_3_export (<connected-to-pio_hex_3_export>), //  pio_hex_3.export
		.pio_led_export   (<connected-to-pio_led_export>),   //    pio_led.export
		.pio_sw_export    (<connected-to-pio_sw_export>),    //     pio_sw.export
		.reset_reset_n    (<connected-to-reset_reset_n>),    //      reset.reset_n
		.sdram_wire_addr  (<connected-to-sdram_wire_addr>),  // sdram_wire.addr
		.sdram_wire_ba    (<connected-to-sdram_wire_ba>),    //           .ba
		.sdram_wire_cas_n (<connected-to-sdram_wire_cas_n>), //           .cas_n
		.sdram_wire_cke   (<connected-to-sdram_wire_cke>),   //           .cke
		.sdram_wire_cs_n  (<connected-to-sdram_wire_cs_n>),  //           .cs_n
		.sdram_wire_dq    (<connected-to-sdram_wire_dq>),    //           .dq
		.sdram_wire_dqm   (<connected-to-sdram_wire_dqm>),   //           .dqm
		.sdram_wire_ras_n (<connected-to-sdram_wire_ras_n>), //           .ras_n
		.sdram_wire_we_n  (<connected-to-sdram_wire_we_n>)   //           .we_n
	);

