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



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY altera_fault_injection IS
	GENERIC 
	(
		LPM_TYPE					: STRING := "ALT_FAULT_INJECTION";
		INTENDED_DEVICE_FAMILY		: STRING := "Stratix V";
		ENABLE_INTOSC_SHARE 		: STRING := "NO";
		INSTANTIATE_PR_BLOCK        : NATURAL := 1;
		DATA_REG_WIDTH              : NATURAL := 16;
		EMR_WIDTH 		            : NATURAL := 67
	);
	PORT
	(
		-- mandatory input
		crcerror_pin				: IN STD_LOGIC := '0';
		emr_valid					: IN STD_LOGIC := '0';
		emr_data					: IN STD_LOGIC_VECTOR (EMR_WIDTH-1 DOWNTO 0) := (others => '0');
		reset						: IN STD_LOGIC; --dummy input to satisfy AVST requirement
		-- mandatory output
		error_injected				: OUT STD_LOGIC;
		error_scrubbed				: OUT STD_LOGIC;
        
		-- for prblock sharing
		pr_ready                    : IN STD_LOGIC := '0';
		pr_done                     : IN STD_LOGIC := '0';
		pr_error                    : IN STD_LOGIC := '0';
		pr_ext_request              : IN STD_LOGIC := '0';
		pr_request                  : OUT STD_LOGIC;
		pr_clk                      : OUT STD_LOGIC;
		pr_data                     : OUT STD_LOGIC_VECTOR (DATA_REG_WIDTH-1 DOWNTO 0);
		
		-- optional output
		intosc						: OUT STD_LOGIC
	);
END ENTITY altera_fault_injection;

ARCHITECTURE rtl OF altera_fault_injection IS
	COMPONENT alt_fault_injection
		GENERIC 
		(
			LPM_TYPE					: STRING := "ALT_FAULT_INJECTION";
			INTENDED_DEVICE_FAMILY		: STRING := "Stratix V";
			ENABLE_INTOSC_SHARE 		: STRING := "NO";
			INSTANTIATE_PR_BLOCK        : NATURAL := 1;
			DATA_REG_WIDTH              : NATURAL := 16;
			EMR_WIDTH 		            : NATURAL := 67
		);
		PORT
		(
			-- mandatory input
			crc_error					: IN STD_LOGIC := '0';
			emr_valid					: IN STD_LOGIC := '0';
			emr_data					: IN STD_LOGIC_VECTOR (EMR_WIDTH-1 DOWNTO 0) := (others => '0');
			
			-- mandatory output
			error_injected				: OUT STD_LOGIC;
			error_scrubbed				: OUT STD_LOGIC;

			-- for system testing
			system_error                : IN STD_LOGIC := '0';
			system_reset                : OUT STD_LOGIC;
            
			-- for prblock sharing
			pr_ready                    : IN STD_LOGIC := '0';
			pr_done                     : IN STD_LOGIC := '0';
			pr_error                    : IN STD_LOGIC := '0';
			pr_ext_request              : IN STD_LOGIC := '0';
			pr_request                  : OUT STD_LOGIC;
			pr_clk                      : OUT STD_LOGIC;
			pr_data                     : OUT STD_LOGIC_VECTOR (DATA_REG_WIDTH-1 DOWNTO 0);
			
			-- optional output
			user_intosc					: OUT STD_LOGIC
		);
	END COMPONENT alt_fault_injection;
begin

	alt_fault_injection_component : alt_fault_injection
	GENERIC MAP
	(
		LPM_TYPE					=> LPM_TYPE,
		INTENDED_DEVICE_FAMILY		=> INTENDED_DEVICE_FAMILY,
		ENABLE_INTOSC_SHARE			=> "YES",
		INSTANTIATE_PR_BLOCK        => INSTANTIATE_PR_BLOCK,
		DATA_REG_WIDTH			    => DATA_REG_WIDTH,
		EMR_WIDTH                   => EMR_WIDTH
	)
	PORT MAP
	(
		-- mandatory input
		crc_error					=> crcerror_pin,
		emr_valid					=> emr_valid,
		emr_data					=> emr_data,
			
		-- mandatory output
		error_injected				=> error_injected,
		error_scrubbed				=> error_scrubbed,
        
		-- for prblock sharing
		pr_ready                => pr_ready,
		pr_done                 => pr_done,
		pr_error                => pr_error,
		pr_ext_request          => pr_ext_request,
		pr_request              => pr_request,
		pr_clk                  => pr_clk,
		pr_data                 => pr_data,
			
		-- optional output
		user_intosc					=> intosc
	);
END ARCHITECTURE;
