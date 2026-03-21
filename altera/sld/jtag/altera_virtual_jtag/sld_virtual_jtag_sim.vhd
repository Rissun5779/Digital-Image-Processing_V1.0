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


--//////////////////////////////////////////////////////////////////
--
--   SLD_VIRTUAL_JTAG Parameterized Megafunction
--
--	(c) Altera Corporation, 2005
--
--************************************************************
-- Description:
--
-- This module contains sld_virtual_jtag megafunction
-- stub implementation
--************************************************************

library ieee;
use ieee.std_logic_1164.all;

entity sld_virtual_jtag is
	generic
	(
		sld_auto_instance_index : string := "NO";
		sld_instance_index : natural := 0;			
		sld_ir_width : natural := 1;
		sld_sim_n_scan : natural := 0;
		sld_sim_action : string := "UNUSED";
        sld_sim_total_length : natural := 0;
        
        lpm_type : string := "sld_virtual_jtag";
        lpm_hint : string := "UNUSED"
	);
	
	port
	(
		tck : out std_logic;
		tdi : out std_logic;
		ir_in : out std_logic_vector (sld_ir_width-1 downto 0);
		
		tdo : in std_logic;
		ir_out : in std_logic_vector (sld_ir_width-1 downto 0);
		
		virtual_state_cdr : out std_logic;
		virtual_state_sdr : out std_logic;
		virtual_state_e1dr : out std_logic;	
		virtual_state_pdr : out std_logic;	
		virtual_state_e2dr : out std_logic;
		virtual_state_udr : out std_logic;	
		virtual_state_cir : out std_logic;	
		virtual_state_uir : out std_logic;	
		
		tms : out std_logic;
		jtag_state_tlr : out std_logic;
		jtag_state_rti : out std_logic;
		jtag_state_sdrs : out std_logic;
		jtag_state_cdr : out std_logic;
		jtag_state_sdr : out std_logic;
		jtag_state_e1dr : out std_logic;
		jtag_state_pdr : out std_logic;	
		jtag_state_e2dr : out std_logic;
		jtag_state_udr : out std_logic;
		jtag_state_sirs : out std_logic;
		jtag_state_cir : out std_logic;
		jtag_state_sir : out std_logic;
		jtag_state_e1ir : out std_logic;
		jtag_state_pir : out std_logic;
		jtag_state_e2ir : out std_logic;
		jtag_state_uir : out std_logic
	);

end entity sld_virtual_jtag;

architecture rtl of sld_virtual_jtag is

begin
	
	tck <= '0';
	tdi <= '0';
	ir_in <= (others => '0');
	
	virtual_state_cdr <= '0';
	virtual_state_sdr <= '0';
	virtual_state_e1dr <= '0';
	virtual_state_pdr <= '0';
	virtual_state_e2dr <= '0';
	virtual_state_udr <= '0';
	virtual_state_cir <= '0';
	virtual_state_uir <= '0';
	
	tms <= '0';
	jtag_state_tlr <= '0';
	jtag_state_rti <= '0';
	jtag_state_sdrs <= '0';
	jtag_state_cdr <= '0';
	jtag_state_sdr <= '0';
	jtag_state_e1dr <= '0';
	jtag_state_pdr <= '0';
	jtag_state_e2dr <= '0';
	jtag_state_udr <= '0';
	jtag_state_sirs <= '0';
	jtag_state_cir <= '0';
	jtag_state_sir <= '0';
	jtag_state_e1ir <= '0';
	jtag_state_pir <= '0';
	jtag_state_e2ir <= '0';
	jtag_state_uir <= '0';	

end architecture rtl;
