-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
-- MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
--
-- *****************************************************************************

--    This is a simple example of an axi4stream master to demonstrate the mgc_axi4stream_master BFM usage. 
--
--    This master performs a directed test, initiating 10 sequential packets at higher abstraction level 
--    followed by 10 transfer at phase level.

library ieee ;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.mgc_axi4stream_bfm_pkg.all;
entity master_test_program is
 generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
end master_test_program;

architecture master_test_program_a of master_test_program is

begin
  process
    variable trans: integer;
    variable byte_count : integer := AXI4_DATA_WIDTH/8;
    variable transfer_count : integer;
    variable k    : integer;
    variable m    : integer;
  begin    
    wait_on(AXI4STREAM_RESET_POSEDGE, index, axi4stream_tr_if_0(index));
    wait_on(AXI4STREAM_CLOCK_POSEDGE, index, axi4stream_tr_if_0(index));

    --************************
    -- Traffic generation: **
    --************************
    -- 10 x packet with 
    -- Number of transfer = i % 10. Values : 1, 2 .. 10 
    -- id = i % 15. Values 0, 1, 2 .. 14
    -- dest = i %20. Values 0, 1, 2 .. 19
    for i in  0 to 9 loop
      transfer_count := (i mod 10) + 1;
      create_master_transaction(transfer_count, trans, index, axi4stream_tr_if_0(index));
      set_id(i mod 15, trans, index, axi4stream_tr_if_0(index));
      set_dest(i mod 20, trans, index, axi4stream_tr_if_0(index));
      for j in  0 to ((transfer_count * byte_count) - 1) loop
        set_data(i + j, j, trans, index, axi4stream_tr_if_0(index));
        if(((i + j) mod 5) = 0) then
          set_byte_type(AXI4STREAM_NULL_BYTE, j, trans, index, axi4stream_tr_if_0(index));
        elsif(((i + j) mod 5) = 1) then 
          set_byte_type(AXI4STREAM_POS_BYTE, j, trans, index, axi4stream_tr_if_0(index));
        else 
          set_byte_type(AXI4STREAM_DATA_BYTE, j, trans, index, axi4stream_tr_if_0(index));
        end if;
      end loop;
      execute_transaction(trans, index, axi4stream_tr_if_0(index));
    end loop; 
 
    -- 10 x packet at transfer level with 
    -- Number of transfer = i % 10. Values : 1, 2 .. 10 
    -- id = i % 15. Values 0, 1, 2 .. 14
    -- dest = i %20. Values 0, 1, 2 .. 19
    for i in  0 to 9 loop
      transfer_count := (i mod 10) + 1;
      create_master_transaction(transfer_count, trans, index, axi4stream_tr_if_0(index));
      set_id(i mod 15, trans, index, axi4stream_tr_if_0(index));
      set_dest(i mod 20, trans, index, axi4stream_tr_if_0(index));
      m := 0;
      while(m < transfer_count) loop
        k := 0;
        while(k < byte_count) loop
          set_data(k, ((m*byte_count)+k), trans, index, axi4stream_tr_if_0(index));
          if(((i + m) mod 5) = 0) then
            set_byte_type(AXI4STREAM_NULL_BYTE, ((m*byte_count)+k), trans, index, axi4stream_tr_if_0(index));
          elsif(((i + m) mod 5) = 1) then 
            set_byte_type(AXI4STREAM_POS_BYTE, ((m*byte_count)+k), trans, index, axi4stream_tr_if_0(index));
          else 
            set_byte_type(AXI4STREAM_DATA_BYTE, ((m*byte_count)+k), trans, index, axi4stream_tr_if_0(index));
          end if;
          k := k + 1;
        end loop; 
        execute_transfer(trans, m, index, axi4stream_tr_if_0(index));
        m := m + 1;
      end loop;
    end loop;

    wait;
  end process;
end master_test_program_a;

