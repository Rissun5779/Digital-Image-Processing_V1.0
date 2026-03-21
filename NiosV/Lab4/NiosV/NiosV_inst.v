	NiosV u0 (
		.clk_clk             (<connected-to-clk_clk>),             //          clk.clk
		.clk_sdram_clk       (<connected-to-clk_sdram_clk>),       //    clk_sdram.clk
		.pio_hex_0_export    (<connected-to-pio_hex_0_export>),    //    pio_hex_0.export
		.pio_hex_1_export    (<connected-to-pio_hex_1_export>),    //    pio_hex_1.export
		.pio_hex_2_export    (<connected-to-pio_hex_2_export>),    //    pio_hex_2.export
		.pio_hex_3_export    (<connected-to-pio_hex_3_export>),    //    pio_hex_3.export
		.pio_led_export      (<connected-to-pio_led_export>),      //      pio_led.export
		.pio_sw_export       (<connected-to-pio_sw_export>),       //       pio_sw.export
		.pll_0_locked_export (<connected-to-pll_0_locked_export>), // pll_0_locked.export
		.reset_reset_n       (<connected-to-reset_reset_n>),       //        reset.reset_n
		.sdram_addr          (<connected-to-sdram_addr>),          //        sdram.addr
		.sdram_ba            (<connected-to-sdram_ba>),            //             .ba
		.sdram_cas_n         (<connected-to-sdram_cas_n>),         //             .cas_n
		.sdram_cke           (<connected-to-sdram_cke>),           //             .cke
		.sdram_cs_n          (<connected-to-sdram_cs_n>),          //             .cs_n
		.sdram_dq            (<connected-to-sdram_dq>),            //             .dq
		.sdram_dqm           (<connected-to-sdram_dqm>),           //             .dqm
		.sdram_ras_n         (<connected-to-sdram_ras_n>),         //             .ras_n
		.sdram_we_n          (<connected-to-sdram_we_n>)           //             .we_n
	);

