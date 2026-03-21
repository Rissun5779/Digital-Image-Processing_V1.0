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


-- $Id: //acds/main/ip/sopc/components/primitives/altera_std_synchronizer/altera_std_synchronizer.v#1 $
-- $Revision: #1 $
-- $Date: 2008/09/23 $
-------------------------------------------------------------------------------
--
-- File: altera_std_synchronizer.vhd
--
-- Abstract: Single bit clock domain crossing synchronizer. 
--           Composed of two flip flops connected in series.
--
-- Copyright (C) Altera Corporation 2008, All Rights Reserved
-------------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all;
use work.all;

entity altera_std_synchronizer is
    generic (depth : integer := 3);              -- must be >= 2
    
    port (
          clk     : in  std_logic;
    	  reset_n : in  std_logic;
    	  din     : in  std_logic;
    	  dout    : out std_logic
         );
end altera_std_synchronizer;

architecture behavioral of altera_std_synchronizer is
    signal din_s1 : std_logic;
    signal dreg : std_logic_vector(depth-2 downto 0);
begin
    process (din, clk) begin
        if (clk'event and clk='1') then
            if reset_n='0' then
                din_s1 <= '0';
            else
                din_s1 <= din;
            end if;
        end if;
    end process;

    g1: if depth = 1 generate
        -- normally this is an illegal condition
        dout <= din_s1;	    
    end generate g1;

    g2: if depth = 2 generate
        process (din, clk) begin
            if (clk'event and clk='1') then
                if reset_n='0' then
                    dout <= '0';
                else
                    dout <= din_s1;
                end if;
            end if;
        end process;
    end generate g2;

    g3: if depth >= 3 generate
        process (din, clk) begin
            if (clk'event and clk='1') then
                if reset_n='0' then
                    dreg <= (others => '0');
                else
		    dreg <= dreg(depth-3 downto 0) & din_s1;   
                end if;
            end if;
        end process;
        dout <= dreg(depth-2);	    
    end generate g3;

end behavioral;



