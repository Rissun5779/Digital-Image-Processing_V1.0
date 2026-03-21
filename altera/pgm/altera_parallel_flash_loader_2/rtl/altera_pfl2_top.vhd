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


PACKAGE TOP_CONST is
	CONSTANT PFL_QUAD_IO_FLASH_IR_BITS	: NATURAL := 8;
	CONSTANT PFL_CFI_FLASH_IR_BITS		: NATURAL := 5;
	CONSTANT PFL_NAND_FLASH_IR_BITS		: NATURAL := 4;	
	CONSTANT N_FLASH_BITS					: NATURAL := 4;
END PACKAGE TOP_CONST;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
use WORK.TOP_CONST.all;

ENTITY altera_pfl2_top IS
	GENERIC 
	(
		-- General 
		AUTO_RESTART						: STRING := "OFF";
		LPM_TYPE							: STRING := "altera_pfl2_top";
		N_FLASH								: NATURAL := 1;
		FLASH_DATA_WIDTH					: NATURAL := 16;
		ADDR_WIDTH							: NATURAL := 20;
		FEATURES_PGM						: NATURAL := 1;
		FEATURES_CFG						: NATURAL := 1;
		TRISTATE_CHECKBOX					: NATURAL := 0;
		
		-- General (Configuration)
		OPTION_START_ADDR		: NATURAL := 0;			-- Control Block
		SAFE_MODE_HALT						: NATURAL := 0;			-- Control Block (Error Handling)
		SAFE_MODE_RETRY					: NATURAL := 1;			-- Control Block (Error Handling)
		SAFE_MODE_REVERT					: NATURAL := 0;			-- Control Block (Error Handling)
		SAFE_MODE_REVERT_ADDR			: NATURAL := 0;			-- Control Block (Error Handling)
		CONF_DATA_WIDTH					: NATURAL := 1;			-- FPGA Block
		CONF_WAIT_TIMER_WIDTH			: NATURAL := 16; 			-- FPGA Block
		PFL_RSU_WATCHDOG_ENABLED		: NATURAL := 0;			-- Enable RSU Watchdog
		RSU_WATCHDOG_COUNTER				: NATURAL := 100000000;
		
		-- CFI Flash (Flash Programming)
		ENHANCED_FLASH_PROGRAMMING		: NATURAL := 0;
		FIFO_SIZE							: NATURAL := 16;
		DISABLE_CRC_CHECKBOX 			: NATURAL := 0;
		
		-- CFI Flash (Configuration)
		CLK_DIVISOR							: NATURAL := 1;
		PAGE_CLK_DIVISOR					: NATURAL := 1;
		NORMAL_MODE							: NATURAL := 1;
		BURST_MODE							: NATURAL := 0;
		PAGE_MODE							: NATURAL := 0;
		BURST_MODE_INTEL					: NATURAL := 0;
		BURST_MODE_SPANSION				: NATURAL := 0;
		BURST_MODE_NUMONYX				: NATURAL := 0;
		FLASH_NRESET_CHECKBOX 			: NATURAL := 0;
		FLASH_NRESET_COUNTER				: NATURAL := 1;
		FLASH_BURST_EXTRA_CYCLE			: NATURAL := 0;
		BURST_MODE_LATENCY_COUNT		: NATURAL := 4;
             -- Configuration ready synchronizer state
        READY_SYNC_STAGES   : natural := 2
		
	);
	PORT
	(
		-- General
		pfl_nreset							: IN STD_LOGIC := '0';
		pfl_flash_access_granted		: IN STD_LOGIC := '0';
		pfl_flash_access_request		: OUT	STD_LOGIC;
		
		-- General (Configuration)
		pfl_clk								: IN STD_LOGIC := '0';
		fpga_nstatus						: IN STD_LOGIC := '0';
		fpga_conf_done						: IN STD_LOGIC := '0';
		pfl_nreconfigure					: IN STD_LOGIC := '1';
		fpga_pgm								: IN STD_LOGIC_VECTOR (2 DOWNTO 0) := (others=>'0');
		fpga_nconfig						: OUT STD_LOGIC;
		avst_clk						: out STD_LOGIC;
		avst_data						: out STD_LOGIC_VECTOR (CONF_DATA_WIDTH-1 downto 0);
		avst_valid						: out STD_LOGIC;
		avst_ready						: IN STD_LOGIC := '0';
		pfl_reset_watchdog				: IN STD_LOGIC	:= '0';
		pfl_watchdog_error				: OUT	STD_LOGIC;
		
		-- CFI flash (General)
		flash_rdy							: IN STD_LOGIC := '1';
		flash_data							: INOUT STD_LOGIC_VECTOR (FLASH_DATA_WIDTH-1 downto 0);
		flash_addr							: OUT STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
		flash_nreset						: OUT STD_LOGIC;
		
		-- CFI flash (Flash Programming) -- shared by NAND
		flash_nce							: OUT STD_LOGIC_VECTOR (N_FLASH-1 downto 0);
		flash_noe							: OUT STD_LOGIC;
		flash_nwe							: OUT STD_LOGIC;
		
		-- CFI flash (Configuration)
		flash_clk							: OUT STD_LOGIC;
		flash_nadv							: OUT STD_LOGIC
	);
END ENTITY altera_pfl2_top;

ARCHITECTURE rtl OF altera_pfl2_top IS
	COMPONENT altera_pfl2_single_cfi
	GENERIC
	(
		-- General
		FEATURES_PGM						: NATURAL;
		FEATURES_CFG						: NATURAL;
		ADDR_WIDTH							: NATURAL;
		FLASH_DATA_WIDTH					: NATURAL;
		TRISTATE_CHECKBOX					: NATURAL := 0;
		N_FLASH								: NATURAL := 1;
		N_FLASH_BITS						: NATURAL := 4;
		FLASH_NRESET_CHECKBOX 			: NATURAL := 0;
		FLASH_NRESET_COUNTER				: NATURAL := 1;
		
		-- Programming
		PFL_IR_BITS							: NATURAL;
		ENHANCED_FLASH_PROGRAMMING		: NATURAL := 0;
		FIFO_SIZE							: NATURAL := 16;
		DISABLE_CRC_CHECKBOX 			: NATURAL := 0;
		
		-- Configuration
		OPTION_START_ADDR					: NATURAL;
		CLK_DIVISOR							: NATURAL;
		PAGE_CLK_DIVISOR					: NATURAL;
		CONF_DATA_WIDTH					: NATURAL;
		-- Configuration (Error Handling)
		SAFE_MODE_HALT						: NATURAL := 0;
		SAFE_MODE_RETRY					: NATURAL := 1;
		SAFE_MODE_REVERT					: NATURAL := 0;
		SAFE_MODE_REVERT_ADDR			: NATURAL := 0;
		-- Configuration (Read Mode)
		NORMAL_MODE							: NATURAL := 1;
		BURST_MODE							: NATURAL := 0;
		PAGE_MODE							: NATURAL := 0;
		BURST_MODE_INTEL					: NATURAL := 0;
		BURST_MODE_SPANSION				: NATURAL := 0;
		BURST_MODE_NUMONYX				: NATURAL := 0;
		FLASH_BURST_EXTRA_CYCLE			: NATURAL := 0;
		CONF_WAIT_TIMER_WIDTH 			: NATURAL := 16;
		BURST_MODE_LATENCY_COUNT		: NATURAL := 4;
		-- Configuration (RSU Watchdog)
		PFL_RSU_WATCHDOG_ENABLED		: NATURAL := 0;	
		RSU_WATCHDOG_COUNTER				: NATURAL := 100000000;
        -- Configuration ready synchronizer state
        READY_SYNC_STAGES   : natural := 2
	);
	PORT
	(
		-- General
		pfl_nreset							: IN STD_LOGIC;
		pfl_flash_access_granted		: IN STD_LOGIC;
		pfl_flash_access_request		: OUT STD_LOGIC;
		
		-- General (Configuration)
		pfl_clk								: IN STD_LOGIC;
		fpga_nstatus						: IN STD_LOGIC;
		fpga_conf_done						: IN STD_LOGIC;
		pfl_nreconfigure					: IN STD_LOGIC;
		fpga_pgm								: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		fpga_nconfig						: OUT STD_LOGIC;
		avst_clk						: OUT STD_LOGIC;
		avst_data						: OUT STD_LOGIC_VECTOR (CONF_DATA_WIDTH-1 downto 0);
		avst_valid						: OUT STD_LOGIC;
		avst_ready						: IN STD_LOGIC := '0';
		pfl_reset_watchdog				: IN STD_LOGIC	:= '0';
		pfl_watchdog_error				: OUT STD_LOGIC;
		
		-- CFI flash (General)
		flash_rdy							: IN STD_LOGIC;
		flash_data							: INOUT STD_LOGIC_VECTOR (FLASH_DATA_WIDTH-1 downto 0);
		flash_addr							: OUT STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
		flash_nreset						: OUT STD_LOGIC;

		-- CFI flash (Flash Programming)
		flash_nce							: OUT STD_LOGIC;
		flash_noe							: OUT STD_LOGIC;
		flash_nwe							: OUT STD_LOGIC;
		
		-- CFI flash (Configuration)
		flash_clk							: OUT STD_LOGIC;
		flash_nadv							: OUT STD_LOGIC
		
	);
	END COMPONENT altera_pfl2_single_cfi;
	
	COMPONENT altera_pfl2_multiple_cfi
	GENERIC
	(
		-- General
		FEATURES_PGM						: NATURAL;
		FEATURES_CFG						: NATURAL;
		ADDR_WIDTH							: NATURAL;
		FLASH_DATA_WIDTH					: NATURAL;
		TRISTATE_CHECKBOX					: NATURAL := 0;
		N_FLASH								: NATURAL := 1;
		N_FLASH_BITS						: NATURAL := 4;
		
		-- Programming
		PFL_IR_BITS							: NATURAL;
		ENHANCED_FLASH_PROGRAMMING		: NATURAL := 0;
		FIFO_SIZE				 			: NATURAL := 16;
		DISABLE_CRC_CHECKBOX 			: NATURAL := 0;
		
		-- Configuration
		OPTION_START_ADDR					: NATURAL;
		CLK_DIVISOR							: NATURAL;
		PAGE_CLK_DIVISOR					: NATURAL;
		CONF_DATA_WIDTH					: NATURAL;
		-- Configuration (Error Handling)
		SAFE_MODE_HALT						: NATURAL := 0;
		SAFE_MODE_RETRY					: NATURAL := 1;
		SAFE_MODE_REVERT					: NATURAL := 0;
		SAFE_MODE_REVERT_ADDR			: NATURAL := 0;
		-- Configuration (Read Mode)
		NORMAL_MODE							: NATURAL := 1;
		BURST_MODE							: NATURAL := 0;
		PAGE_MODE							: NATURAL := 0;
		BURST_MODE_INTEL					: NATURAL := 0;
		BURST_MODE_SPANSION				: NATURAL := 0;
		BURST_MODE_NUMONYX				: NATURAL := 0;
		FLASH_BURST_EXTRA_CYCLE			: NATURAL := 0;
		CONF_WAIT_TIMER_WIDTH 			: NATURAL := 16;
		BURST_MODE_LATENCY_COUNT		: NATURAL := 4;
		-- Configuration (RSU Watchdog)
		PFL_RSU_WATCHDOG_ENABLED		: NATURAL := 0;	
		RSU_WATCHDOG_COUNTER				: NATURAL := 100000000;
        -- Configuration ready synchronizer state
        READY_SYNC_STAGES   : natural := 2
	);
	PORT
	(
		-- General
		pfl_nreset							: IN STD_LOGIC;
		pfl_flash_access_granted		: IN STD_LOGIC;
		pfl_flash_access_request		: OUT STD_LOGIC;
		
		-- General (Configuration)
		pfl_clk								: IN STD_LOGIC;
		fpga_nstatus						: IN STD_LOGIC;
		fpga_conf_done						: IN STD_LOGIC;
		pfl_nreconfigure					: IN STD_LOGIC;
		fpga_pgm								: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		fpga_nconfig						: OUT STD_LOGIC;
		pfl_reset_watchdog				: IN STD_LOGIC	:= '0';
		pfl_watchdog_error				: OUT STD_LOGIC;
		
		-- CFI flash (General)
		flash_rdy							: IN STD_LOGIC;
		flash_data							: INOUT STD_LOGIC_VECTOR (FLASH_DATA_WIDTH-1 downto 0);
		flash_addr							: OUT STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
		flash_nreset						: OUT STD_LOGIC;
		
		-- CFI flash (Flash Programming)
		flash_nce							: OUT STD_LOGIC_VECTOR (N_FLASH-1 downto 0);
		flash_noe							: OUT STD_LOGIC;
		flash_nwe							: OUT STD_LOGIC;
		
		-- CFI flash (Configuration)
		flash_clk							: OUT STD_LOGIC;
		flash_nadv							: OUT STD_LOGIC
	);
	END COMPONENT altera_pfl2_multiple_cfi;
	
begin
	PFL_CFI_AVST: IF (N_FLASH = 1) GENERATE
		pfl_cfi_avst_inst: altera_pfl2_single_cfi
		GENERIC MAP
		(
			-- General
			PFL_IR_BITS						=> PFL_CFI_FLASH_IR_BITS,
			FEATURES_CFG					=> FEATURES_CFG,
			FEATURES_PGM					=> FEATURES_PGM,
			ADDR_WIDTH						=> ADDR_WIDTH,
			FLASH_DATA_WIDTH				=> FLASH_DATA_WIDTH,
			N_FLASH 							=> N_FLASH,
			N_FLASH_BITS 					=> N_FLASH_BITS,
			TRISTATE_CHECKBOX				=> TRISTATE_CHECKBOX,
			FLASH_NRESET_CHECKBOX		=> FLASH_NRESET_CHECKBOX,
			FLASH_NRESET_COUNTER			=> FLASH_NRESET_COUNTER,
			
			-- Flash Programming
			ENHANCED_FLASH_PROGRAMMING	=> ENHANCED_FLASH_PROGRAMMING,
			FIFO_SIZE 						=> FIFO_SIZE,
			DISABLE_CRC_CHECKBOX			=> DISABLE_CRC_CHECKBOX,
			
			-- Configuration
			OPTION_START_ADDR				=> OPTION_START_ADDR,
			CLK_DIVISOR						=> CLK_DIVISOR,
			PAGE_CLK_DIVISOR				=> PAGE_CLK_DIVISOR,
			CONF_DATA_WIDTH				=> CONF_DATA_WIDTH,
			-- Configuration (Error Handling)
			SAFE_MODE_HALT 				=> SAFE_MODE_HALT,
			SAFE_MODE_RETRY 				=> SAFE_MODE_RETRY,
			SAFE_MODE_REVERT 				=> SAFE_MODE_REVERT,
			SAFE_MODE_REVERT_ADDR 		=> SAFE_MODE_REVERT_ADDR,
			-- Configuration (Read Mode)
			NORMAL_MODE 					=> NORMAL_MODE,
			BURST_MODE 						=> BURST_MODE,
			PAGE_MODE 						=> PAGE_MODE,
			BURST_MODE_INTEL 				=> BURST_MODE_INTEL,
			BURST_MODE_SPANSION 			=> BURST_MODE_SPANSION,
			BURST_MODE_NUMONYX 			=> BURST_MODE_NUMONYX,
			FLASH_BURST_EXTRA_CYCLE		=> FLASH_BURST_EXTRA_CYCLE,
			CONF_WAIT_TIMER_WIDTH 		=> CONF_WAIT_TIMER_WIDTH,
			BURST_MODE_LATENCY_COUNT		=> BURST_MODE_LATENCY_COUNT,
			-- Configuration (RSU Watchdog)
			PFL_RSU_WATCHDOG_ENABLED	=> PFL_RSU_WATCHDOG_ENABLED,
			RSU_WATCHDOG_COUNTER			=> RSU_WATCHDOG_COUNTER,
            -- Configuration ready synchronizer state
            READY_SYNC_STAGES   => READY_SYNC_STAGES
		)
		PORT MAP
		(
			-- General
			pfl_clk 							=> pfl_clk,
			pfl_nreset						=> pfl_nreset,
			pfl_flash_access_granted 	=> pfl_flash_access_granted,
			pfl_flash_access_request 	=> pfl_flash_access_request,
			
			-- General (Configuration)
			fpga_nstatus					=> fpga_nstatus,
			fpga_conf_done					=> fpga_conf_done,
			pfl_nreconfigure 				=> pfl_nreconfigure,
			fpga_pgm							=> fpga_pgm,
			fpga_nconfig					=> fpga_nconfig,
			avst_clk					=> avst_clk,
			avst_data						=> avst_data,
			avst_valid								=> avst_valid,
			avst_ready						=> avst_ready,
			pfl_reset_watchdog			=> pfl_reset_watchdog,
			pfl_watchdog_error			=> pfl_watchdog_error,
			
			-- CFI flash (General)
			flash_rdy						=> flash_rdy,
			flash_data						=> flash_data,
			flash_addr						=> flash_addr,
			flash_nreset					=> flash_nreset,
			
			-- CFI flash (Flash Programming)
			flash_nce						=> flash_nce(0),
			flash_noe						=> flash_noe,
			flash_nwe						=> flash_nwe,
			
			-- CFI flash (Configuration)
			flash_clk						=> flash_clk,
			flash_nadv						=> flash_nadv		
		);
	END GENERATE;
	
	
	PFL_MULTIPLE_CFI: IF (N_FLASH > 1) GENERATE
		pfl_mltiple_cfi_inst: altera_pfl2_multiple_cfi
		GENERIC MAP
		(
			-- General
			PFL_IR_BITS						=> PFL_CFI_FLASH_IR_BITS,
			FEATURES_CFG					=> FEATURES_CFG,
			FEATURES_PGM					=> FEATURES_PGM,
			ADDR_WIDTH						=> ADDR_WIDTH,
			FLASH_DATA_WIDTH				=> FLASH_DATA_WIDTH,
			N_FLASH 							=> N_FLASH,
			N_FLASH_BITS 					=> N_FLASH_BITS,
			TRISTATE_CHECKBOX 			=> TRISTATE_CHECKBOX,
			
			-- Flash Programming
			ENHANCED_FLASH_PROGRAMMING	=> ENHANCED_FLASH_PROGRAMMING,
			FIFO_SIZE 						=> FIFO_SIZE,
			DISABLE_CRC_CHECKBOX			=> DISABLE_CRC_CHECKBOX,

			-- Configuration
			OPTION_START_ADDR				=> OPTION_START_ADDR,
			CLK_DIVISOR						=> CLK_DIVISOR,
			PAGE_CLK_DIVISOR				=> PAGE_CLK_DIVISOR,
			CONF_DATA_WIDTH				=> CONF_DATA_WIDTH,
			-- Configuration (Error Handling)
			SAFE_MODE_HALT 				=> SAFE_MODE_HALT,
			SAFE_MODE_RETRY 				=> SAFE_MODE_RETRY,
			SAFE_MODE_REVERT 				=> SAFE_MODE_REVERT,
			SAFE_MODE_REVERT_ADDR 		=> SAFE_MODE_REVERT_ADDR,
			-- Configuration (Read Mode)
			NORMAL_MODE 					=> NORMAL_MODE,
			BURST_MODE 						=> BURST_MODE,
			PAGE_MODE 						=> PAGE_MODE,
			BURST_MODE_INTEL 				=> BURST_MODE_INTEL,
			BURST_MODE_SPANSION 			=> BURST_MODE_SPANSION,
			BURST_MODE_NUMONYX 			=> BURST_MODE_NUMONYX,
			FLASH_BURST_EXTRA_CYCLE		=> FLASH_BURST_EXTRA_CYCLE,
			CONF_WAIT_TIMER_WIDTH 		=> CONF_WAIT_TIMER_WIDTH,
			BURST_MODE_LATENCY_COUNT	=> BURST_MODE_LATENCY_COUNT,
			-- Configuration (RSU Watchdog)
			PFL_RSU_WATCHDOG_ENABLED	=> PFL_RSU_WATCHDOG_ENABLED,
			RSU_WATCHDOG_COUNTER			=> RSU_WATCHDOG_COUNTER,
            -- Configuration ready synchronizer state
            READY_SYNC_STAGES   => READY_SYNC_STAGES
		)
		PORT MAP
		(
			-- General 
			pfl_clk 							=> pfl_clk,
			pfl_nreset						=> pfl_nreset,
			pfl_flash_access_granted 	=> pfl_flash_access_granted,
			pfl_flash_access_request 	=> pfl_flash_access_request,
			
			-- General (Configuration)
			fpga_nstatus					=> fpga_nstatus,
			fpga_conf_done					=> fpga_conf_done,
			pfl_nreconfigure 				=> pfl_nreconfigure,
			fpga_pgm							=> fpga_pgm,
			fpga_nconfig					=> fpga_nconfig,
			pfl_reset_watchdog			=> pfl_reset_watchdog,
			pfl_watchdog_error			=> pfl_watchdog_error,
	
			-- CFI flash (General)
			flash_rdy						=> flash_rdy,
			flash_data						=> flash_data,
			flash_addr						=> flash_addr,
			flash_nreset					=> flash_nreset,
			
			-- CFI flash (Flash Programming)
			flash_nce						=> flash_nce,
			flash_noe						=> flash_noe,
			flash_nwe						=> flash_nwe,
			
			-- CFI flash (Configuration)
			flash_clk						=> flash_clk,
			flash_nadv						=> flash_nadv
		);
	END GENERATE;
	

	
END ARCHITECTURE;
