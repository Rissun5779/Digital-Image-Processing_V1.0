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


-- $Id: //acds/rel/18.1std/ip/sopc/components/primitives/altera_std_synchronizer/altera_std_synchronizer_bundle.vhd#1 $
-- $Revision: #1 $
-- $Date: 2018/07/18 $
------------------------------------------------------------------
--
-- File: altera_std_synchronizer_bundle.vhd
--
-- Abstract: Bundle of bit synchronizers. 
--           WARNING: only use this to synchronize a bundle of 
--           *independent* single bit signals or a Gray encoded 
--           bus of signals. Also remember that pulses entering 
--           the synchronizer will be swallowed upon a metastable
--           condition if the pulse width is shorter than twice
--           the synchronizing clock period.
--
-- Copyright (C) Altera Corporation 2008, All Rights Reserved
------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all;
use work.all;

entity altera_std_synchronizer_bundle is
    generic (depth : integer := 3;              -- must be >= 2
             width : integer := 1);
    port (
          clk     : in  std_logic;
    	  reset_n : in  std_logic;
    	  din     : in  std_logic_vector(width-1 downto 0);
    	  dout    : out std_logic_vector(width-1 downto 0));
end altera_std_synchronizer_bundle;

architecture behavioral of altera_std_synchronizer_bundle is
  component altera_std_synchronizer 
    generic (depth : integer := 3); 
    port (
          clk     : in  std_logic;
    	  reset_n : in  std_logic;
    	  din     : in  std_logic;
    	  dout    : out std_logic
         );
  end component;
begin
    g1: for i in 0 to width-1 generate 
        s: altera_std_synchronizer
          generic map (depth => depth)
          port map (clk => clk, 
                    reset_n => reset_n, 
                    din => din(i), 
                    dout => dout(i)
                    );
    end generate g1;
end behavioral;

