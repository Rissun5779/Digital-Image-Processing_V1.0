-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
-- MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
--
-- *****************************************************************************
--
--  This is a simple example of an AXI4STREAM Slave to demonstrate the mgc_axi4stream_slave BFM usage.

library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.all;
use work.mgc_axi4stream_bfm_pkg.all;

entity slave_test_program is
   generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
 end slave_test_program;

architecture slave_test_program_a of slave_test_program is
  --This member controls the wait insertion in axi4 stream transfers coming from master.
  -- Making ~m_insert_wait~ to '0' truns off the wait insertion.
  signal m_insert_wait : std_logic := '1';

  procedure ready_delay(signal tr_if : inout axi4stream_vhd_if_struct_t);

  --///////////////////////////////////////////////
  -- Code user could edit according to requirements
  --///////////////////////////////////////////////

  -- Procedure : ready_delay
  -- This is used to set ready delay to extend the transfer
  procedure ready_delay(signal tr_if : inout axi4stream_vhd_if_struct_t) is
  begin
    --  Making TREADY '0'. This will consume one cycle.
    execute_stream_ready(0, index, tr_if);
    -- Two clock cycle wait. In total 3 clock wait.
    for i in 0 to 1 loop
      wait_on(AXI4STREAM_CLOCK_POSEDGE, index, tr_if);
    end loop;  
     -- Making TREADY '1'.
    execute_stream_ready(1, index, tr_if);
  end ready_delay;

begin

  --/////////////////////////////////////////////////////////////////////
  -- Code user do not need to edit
  --/////////////////////////////////////////////////////////////////////
  process
    variable trans: integer;
    variable i : integer;
    variable last : integer;
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
      create_slave_transaction(trans, index, axi4stream_tr_if_0(index));
      i := 0;
      last := 0;
      while(last = 0) loop
        if(m_insert_wait = '1') then
          -- READY is through path 0
          ready_delay(axi4stream_tr_if_0(index));
        end if;
        get_transfer(trans, i, last, index, axi4stream_tr_if_0(index));
        i := i + 1;  
      end loop;
    end loop;  
     
    wait;
  end process;
end slave_test_program_a;

