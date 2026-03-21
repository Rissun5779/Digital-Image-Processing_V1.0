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



Library ieee;
use ieee.std_logic_1164.all;

entity sim_filter_xz is
   generic (
     width     : natural := 1);

   port (
     o   : out std_logic_vector(width-1 downto 0);
     i   : in  std_logic_vector(width-1 downto 0));
end sim_filter_xz;

architecture behavior of sim_filter_xz is
begin

  loopbits : for idx in o'range generate
    process(i(idx))
    begin
      if (i(idx) = '1') then
        o(idx) <= '1';
      else
        o(idx) <= '0';
      end if;
    end process;
  end generate loopbits;

end behavior;

