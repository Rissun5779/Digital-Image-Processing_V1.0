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


--////////////////////////////////////////////////////////////////////
--//
--//  ALTSOURCE_PROBE Parameterized Megafunction Body
--//
--//	(c) Altera Corporation, 2006
--//
--//	Version 1.0
--
--//************************************************************
--// Description:
--//
--// This module contains altsource_probe megafunction stub
--// simulation implementation
--//************************************************************
--
--///////////////////////////////////////////////////////////////////////////////
--// Description    : IP for Interactive Probe. Capture internal signals using the
--//          probe input, drive internal signals using the source output.
--//          The captured value and the input source value generated are 
--//          transmitted through the JTAG interface.
--///////////////////////////////////////////////////////////////////////////////

library ieee;
use ieee.std_logic_1164.all;

entity altsource_probe is
	generic
	(
		lpm_type : string := "altsource_probe";
		lpm_hint : string := "UNUSED";
		
		sld_auto_instance_index : string := "YES";
		sld_instance_index : natural := 0;
		SLD_NODE_INFO : natural := 4746752;
		sld_ir_width : natural := 4;
								
		instance_id : string := "UNUSED";  	
		probe_width : natural := 1;  		
		source_width : natural := 1;  		
		source_initial_value : string := "0"; 
		enable_metastability : string := "NO"
	);
	
	port
	(
		probe : in std_logic_vector (probe_width-1 downto 0) := (others => '0');
		source : out std_logic_vector (source_width-1 downto 0);
		source_clk : in std_logic := '0';
		source_ena : in std_logic := 'Z';
		
		raw_tck : in std_logic := '0';
		tdi : in std_logic := '0';
	    usr1 : in std_logic := '0';
	    jtag_state_cdr : in std_logic := '0';
	    jtag_state_sdr : in std_logic := '0';
	    jtag_state_e1d : in std_logic := '0';
	    jtag_state_udr : in std_logic := '0';
	    jtag_state_cir : in std_logic := '0';
	    jtag_state_uir : in std_logic := '0';
	    jtag_state_tlr : in std_logic := '0';
	    clr : in std_logic := '0';
	    ena : in std_logic := '0';
	    ir_in : in std_logic_vector (sld_ir_width-1 downto 0) := (others => '0');
	    
	    ir_out : out std_logic_vector (sld_ir_width-1 downto 0);
	    tdo : out std_logic
	);
end entity altsource_probe;

architecture rtl of altsource_probe is

begin

	tdo <= '0';
	ir_out <= (others => '0');
	source <= (others => '0');

end architecture rtl;
