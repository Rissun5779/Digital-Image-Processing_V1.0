-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
-- MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
--
-- *****************************************************************************

-- This is a simple example of an AXI4 STREAM monitor to demonstrate the usage of the Monitor API. 


library ieee ;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.mgc_axi4stream_bfm_pkg.all;

entity monitor_test_program is
   generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
 end monitor_test_program;

architecture monitor_test_program_a of monitor_test_program is
begin

  process
    variable i : integer;
    variable last : integer;
    variable trans: integer;
  begin
     --*******************
    --** Initialisation **
    --********************
     wait_on(AXI4STREAM_RESET_POSEDGE, index, axi4stream_tr_if_0(index));
     wait_on(AXI4STREAM_CLOCK_POSEDGE, index, axi4stream_tr_if_0(index));

    ------------------------/
    -- Packet receiving:-- 
    ------------------------/   
    loop
      create_monitor_transaction(trans, index, axi4stream_tr_if_0(index));
      i := 0;
      last := 0;
      while(last = 0) loop
        get_transfer(trans, i, last, index, axi4stream_tr_if_0(index));
        i := i + 1;  
      end loop;
      report "=======================";
      report "MONITOR: Packet";
      print(trans, index, axi4stream_tr_if_0(index));
      report "=======================";
    end loop;  
     
    wait;
  end process;
end monitor_test_program_a;
