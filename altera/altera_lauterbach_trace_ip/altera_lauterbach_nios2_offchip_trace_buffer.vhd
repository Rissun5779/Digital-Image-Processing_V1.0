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


library IEEE;
use IEEE.std_logic_1164.all;

entity altera_lauterbach_nios2_offchip_trace_buffer is
	port (
		iReset     : in STD_LOGIC; -- not used, because not needed; to make QSYS happy
		iClk       : in STD_LOGIC;

		iClkX2     : in STD_LOGIC;
		iTraceData : in STD_LOGIC_VECTOR(35 downto 0);
		
		oTraceClk  : out STD_LOGIC;
		oTraceData : out STD_LOGIC_VECTOR(17 downto 0)
	);

    -- VHDL attributes to use IO registers for Trace Clock and Trace Data
	attribute useioff : boolean;
	attribute useioff of oTraceClk  : signal is true;
	attribute useioff of oTraceData : signal is true;

end altera_lauterbach_nios2_offchip_trace_buffer;

architecture behavior of altera_lauterbach_nios2_offchip_trace_buffer is

signal rTraceClk1  : STD_LOGIC;
signal rTraceData1 : STD_LOGIC_VECTOR(35 downto 0);

signal rTraceClk2  : STD_LOGIC;
signal rTraceClk2o : STD_LOGIC;
signal rTraceData2 : STD_LOGIC_VECTOR(35 downto 0);

signal rTraceClk3  : STD_LOGIC;
signal rTraceClk3o : STD_LOGIC;
signal rTraceData3 : STD_LOGIC_VECTOR(35 downto 0);

signal rTraceClk4o : STD_LOGIC;
signal rTraceData4 : STD_LOGIC_VECTOR(17 downto 0);

signal rTraceClk5o : STD_LOGIC;


begin
	process(iClk)
	begin
		if rising_edge(iClk) then
			-- One extra register layer, synced to CPU clock
			rTraceData1<=iTraceData;
			rTraceClk1<=not rTraceClk1;
		end if;
	end process;
	
	process(iClkX2)
	begin
		if rising_edge(iClkX2) then
			-- Sync to 2X CPU clock frequency.
			rTraceData2 <= rTraceData1;
			rTraceClk2  <= rTraceClk1;

			-- Convert into DDR (with respect to rTraceClk3o)
			rTraceClk2o <= rTraceClk2;
			if rTraceClk2/=rTraceClk2o then
				rTraceClk3o<='0';
				rTraceData3<=rTraceData2;
			else
				rTraceClk3o<='1';
				rTraceData3(35 downto 18)<=(others => '0');
				rTraceData3(17 downto  0)<=rTraceData3(35 downto 18);
			end if;

			-- This register stage should be put into IO registers.
			rTraceData4<=rTraceData3(17 downto  0);
		end if;
	end process;
	
	-- Delay output trace clock by a quarter of an external visible clock cycle
	-- by syncing the output to the falling edge of iClkX2
	process(iClkX2)
	begin
		if falling_edge(iClkX2) then
			rTraceClk4o<=rTraceClk3o;
			rTraceClk5o<=rTraceClk4o;
		end if;
	end process;
	
	-- Connect to output pins.
	oTraceClk  <= rTraceClk5o;
	oTraceData <= rTraceData4;
end behavior;
