-- (C) 2001-2018 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel FPGA IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity altera_system_max_id is
	generic
	(
		MANUFACTURER_ID : natural:= 110;
		BOARD_ID        : natural:= 0;
		MAX_VERSION     : natural:= 0
	);
	port (
		reset_n: in std_logic;
		clk : in std_logic;
		
		-- interface for AvMM-slave
		slv_address : in std_logic_vector(2 downto 0);
		slv_read_n : in std_logic;
		slv_data_out : out std_logic_vector(31 downto 0);

		board_version : in std_logic_vector(15 downto 0) := x"0000"
	);
end altera_system_max_id;


architecture rtl of altera_system_max_id is

begin
	process(clk, reset_n)begin
		if(reset_n = '0')then
			slv_data_out <= x"00000000";
		elsif(clk'event and clk = '1')then
			if(slv_read_n = '0')then
				case (unsigned(slv_address)) is
					when "000" =>
						slv_data_out <= x"A17E2ABD"; -- ALTERA BoarD
					when "001" =>
						slv_data_out <= x"00000000"; -- System MAX ID register set version number
					when "010" =>
						slv_data_out <= std_logic_vector(to_unsigned(MANUFACTURER_ID, slv_data_out'length));
					when "011" =>
						slv_data_out <= std_logic_vector(to_unsigned(BOARD_ID, slv_data_out'length));
					when "100" =>
						slv_data_out <= std_logic_vector(to_unsigned(MAX_VERSION, slv_data_out'length));
					when "101" =>
						slv_data_out <= x"0000" & board_version; -- Board revision number (assumed to come from pins on max)
					when others =>
						slv_data_out <= x"00000000";
				end case;
			end if;
		end if;
	end process;
end rtl;
