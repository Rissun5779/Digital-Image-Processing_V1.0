	component NiosV is
		port (
			clk_clk          : in  std_logic                    := 'X';             -- clk
			pio_led_export   : out std_logic_vector(7 downto 0);                    -- export
			pio_sw_export    : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			reset_reset_n    : in  std_logic                    := 'X';             -- reset_n
			pio_hex_0_export : out std_logic_vector(7 downto 0);                    -- export
			pio_hex_1_export : out std_logic_vector(7 downto 0);                    -- export
			pio_hex_2_export : out std_logic_vector(7 downto 0);                    -- export
			pio_hex_3_export : out std_logic_vector(7 downto 0)                     -- export
		);
	end component NiosV;

	u0 : component NiosV
		port map (
			clk_clk          => CONNECTED_TO_clk_clk,          --       clk.clk
			pio_led_export   => CONNECTED_TO_pio_led_export,   --   pio_led.export
			pio_sw_export    => CONNECTED_TO_pio_sw_export,    --    pio_sw.export
			reset_reset_n    => CONNECTED_TO_reset_reset_n,    --     reset.reset_n
			pio_hex_0_export => CONNECTED_TO_pio_hex_0_export, -- pio_hex_0.export
			pio_hex_1_export => CONNECTED_TO_pio_hex_1_export, -- pio_hex_1.export
			pio_hex_2_export => CONNECTED_TO_pio_hex_2_export, -- pio_hex_2.export
			pio_hex_3_export => CONNECTED_TO_pio_hex_3_export  -- pio_hex_3.export
		);

