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
-- This is a simple example of an AXI Slave to demonstrate the mgc_axi4_slave BFM configured as axi4lite usage. 
--
-- This is a fairly generic slave which handles almost all write and read transaction
-- scenarios from master. It handles write data with address as well as data after address
-- both.
--
-- This slave code is divided in two parts, one which user might need to edit to change slave
-- mode (Transaction/burst or Phase level) and memory handling.
-- Out of the code which is grouped as user do not need to edit, could be edited for achieving
-- required phase valid/ready delays.
--
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.all;
use work.mgc_axi4_bfm_pkg.all;

entity slave_test_program is
   generic (AXI4_ADDRESS_WIDTH : integer := 32;
            AXI4_RDATA_WIDTH : integer := 32;
            AXI4_WDATA_WIDTH : integer := 32;
            index : integer range 0 to 511 := 0
          );
 end slave_test_program;

architecture slave_test_program_a of slave_test_program is
  type memory_t is array (0 to 2**16-1) of std_logic_vector(7 downto 0);

  --///////////////////////////////////////////////
  -- Code user could edit according to requirements
  --///////////////////////////////////////////////

  -- Variable : m_wr_addr_phase_ready_delay
  signal m_wr_addr_phase_ready_delay : integer := 2;

  -- Variable : m_rd_addr_phase_ready_delay
  signal m_rd_addr_phase_ready_delay : integer := 2;

  -- Variable : m_wr_data_phase_ready_delay
  signal m_wr_data_phase_ready_delay : integer := 2;

  -- Storage for a memory
  shared variable mem : memory_t;

  procedure do_byte_read(addr : in std_logic_vector(AXI4_MAX_BIT_SIZE-1 downto 0); data : out std_logic_vector(7 downto 0));
  procedure do_byte_write(addr : in std_logic_vector(AXI4_MAX_BIT_SIZE-1 downto 0);  data : in std_logic_vector(7 downto 0));
  procedure set_wr_resp_valid_delay(id : integer; signal tr_if : inout axi4_vhd_if_struct_t);
  procedure set_wr_resp_valid_delay(id : integer; path_id : in axi4_path_t; signal tr_if : inout axi4_vhd_if_struct_t);
  procedure set_read_data_valid_delay(id : integer; signal tr_if : inout axi4_vhd_if_struct_t);
  procedure set_read_data_valid_delay(id : integer; path_id : in axi4_path_t; signal tr_if : inout axi4_vhd_if_struct_t);

  -- Procedure : do_byte_read
  -- Procedure to provide read data byte from memory at particular input
  -- address
  procedure do_byte_read(addr : in std_logic_vector(AXI4_MAX_BIT_SIZE-1 downto 0); data : out std_logic_vector(7 downto 0)) is
  begin
    data := mem(to_integer(addr));
  end do_byte_read;

  -- Procedure : do_byte_write
  -- Procedure to write data byte to memory at particular input address
  procedure do_byte_write(addr : in std_logic_vector(AXI4_MAX_BIT_SIZE-1 downto 0);  data : in std_logic_vector(7 downto 0)) is
  begin
    mem(to_integer(addr)) := data;
  end do_byte_write;

  -- Procedure : set_wr_resp_valid_delay
  -- This is used to set write response phase valid delay to start driving
  -- write response phase after specified delay.
  procedure set_wr_resp_valid_delay(id : integer; signal tr_if : inout axi4_vhd_if_struct_t) is
  begin
    set_write_response_valid_delay(2, id, index, tr_if);
  end set_wr_resp_valid_delay;
  procedure set_wr_resp_valid_delay(id : integer; path_id : in axi4_path_t; signal tr_if : inout axi4_vhd_if_struct_t) is
  begin
    set_write_response_valid_delay(2, id, index, path_id, tr_if);
  end set_wr_resp_valid_delay;

  -- Procedure : set_read_data_valid_delay
  -- This will set the ready delay for write data phase 
  procedure set_read_data_valid_delay(id : integer; signal tr_if : inout axi4_vhd_if_struct_t) is
    variable burst_length : integer;
  begin
    set_data_valid_delay(2, id, index, tr_if);
  end set_read_data_valid_delay;
  procedure set_read_data_valid_delay(id : integer; path_id : in axi4_path_t; signal tr_if : inout axi4_vhd_if_struct_t) is
    variable burst_length : integer;
  begin
    set_data_valid_delay(2, id, index, path_id, tr_if);
  end set_read_data_valid_delay;

begin

  -- To create pipelining in VHDL there are multiple channel path in each API.
  -- So each process will choose separate path to interact with BFM.

  -- process_write : write address phase through path 0
  -- This process keep receiving write address phase and push the transaction into queue through 
  -- push_transaction_id API.
  process
    variable write_trans : integer;
  begin
    loop
      create_slave_transaction(write_trans, index, axi4_tr_if_0(index));
      get_write_addr_phase(write_trans, index, axi4_tr_if_0(index));
      push_transaction_id(write_trans, AXI4_QUEUE_ID_0, index, axi4_tr_if_0(index));
    end loop;
    wait; 
  end process;

  -- handle_write : write data phase through path 1 
  -- This method receive write data phase for write transaction
  process
    variable write_trans: integer;
    variable byte_length : integer;
    variable addr : std_logic_vector(AXI4_MAX_BIT_SIZE-1 downto 0);
    variable data : std_logic_vector(7 downto 0);
    variable last : integer := 0;
  begin
    loop
      pop_transaction_id(write_trans, AXI4_QUEUE_ID_0, index, AXI4_PATH_1, axi4_tr_if_1(index));

      get_write_data_phase(write_trans, 0, last, index, AXI4_PATH_1, axi4_tr_if_1(index));
      get_write_addr_data(write_trans, 0, 0, byte_length, addr, data, index, AXI4_PATH_1, axi4_tr_if_1(index));
      do_byte_write(addr, data); 
      if byte_length > 1 then 
        for j in 1 to byte_length-1 loop
          get_write_addr_data(write_trans, 0, j, byte_length, addr, data, index, AXI4_PATH_1, axi4_tr_if_1(index));
          do_byte_write(addr, data); 
        end loop;
      end if;
      push_transaction_id(write_trans, AXI4_QUEUE_ID_2, index, AXI4_PATH_1, axi4_tr_if_1(index));
    end loop;
    wait;
  end process;

  -- handle_response : write response phase through path 2
  -- This method sends the write response phase
  process
    variable write_trans: integer;
  begin
    loop  
      pop_transaction_id(write_trans, AXI4_QUEUE_ID_2, index, AXI4_PATH_2, axi4_tr_if_2(index));
      set_wr_resp_valid_delay(write_trans, AXI4_PATH_2, axi4_tr_if_2(index));
      execute_write_response_phase(write_trans, index, AXI4_PATH_2, axi4_tr_if_2(index));
    end loop;
    wait;
  end process;

  -- process_read : read address phase through path 3
  -- This process keep receiving read address phase and push the transaction into queue through 
  -- push_transaction_id API.
  process
    variable read_trans: integer;
  begin
    loop
      create_slave_transaction(read_trans, index, AXI4_PATH_3, axi4_tr_if_3(index));
      get_read_addr_phase(read_trans, index, AXI4_PATH_3, axi4_tr_if_3(index));
      push_transaction_id(read_trans, AXI4_QUEUE_ID_1, index, AXI4_PATH_3, axi4_tr_if_3(index));
    end loop;
    wait;
  end process;

  -- handle_read : read data and response through path 4
  -- This process reads data from memory and send read data/response
  process
    variable read_trans: integer;
    variable byte_length : integer;
    variable addr : std_logic_vector(AXI4_MAX_BIT_SIZE-1 downto 0);
    variable data : std_logic_vector(7 downto 0);
  begin
    loop
      pop_transaction_id(read_trans, AXI4_QUEUE_ID_1, index, AXI4_PATH_4, axi4_tr_if_4(index));
      set_read_data_valid_delay(read_trans, AXI4_PATH_4, axi4_tr_if_4(index));
   
      get_read_addr(read_trans, 0, 0, byte_length, addr, index, AXI4_PATH_4, axi4_tr_if_4(index));
      do_byte_read(addr, data);
      set_read_data(read_trans, 0, 0, byte_length, addr, data, index, AXI4_PATH_4, axi4_tr_if_4(index));
      if byte_length > 1 then 
        for j in 1 to byte_length-1 loop
           get_read_addr(read_trans, 0, j, byte_length, addr, index, AXI4_PATH_4, axi4_tr_if_4(index));
           do_byte_read(addr, data);
           set_read_data(read_trans, 0, j, byte_length, addr, data, index, AXI4_PATH_4, axi4_tr_if_4(index));
        end loop;
      end if;
      execute_read_data_phase(read_trans, index, AXI4_PATH_4, axi4_tr_if_4(index));
    end loop;
    wait;
  end process;

  -- handle_write_addr_ready : write address ready through path 5
  -- This method assert/de-assert the write address channel ready signal.
  -- Assertion and de-assertion is done based on m_wr_addr_phase_ready_delay
  process
    variable tmp_ready_delay : integer;
  begin
    loop
      tmp_ready_delay := m_wr_addr_phase_ready_delay;
      execute_write_addr_ready(0, 1, index, AXI4_PATH_5, axi4_tr_if_5(index)); 
      get_write_addr_cycle(index, AXI4_PATH_5, axi4_tr_if_5(index)); 
      if(tmp_ready_delay > 1) then
        for i in  0 to tmp_ready_delay-2 loop
          wait_on(AXI4_CLOCK_POSEDGE, index, AXI4_PATH_5, axi4_tr_if_5(index));
        end loop;
      end if;  
      execute_write_addr_ready(1, 0, index, AXI4_PATH_5, axi4_tr_if_5(index)); 
    end loop;
    wait;
  end process;

  -- handle_read_addr_ready : read address ready through path 6
  -- This method assert/de-assert the write address channel ready signal.
  -- Assertion and de-assertion is done based on m_rd_addr_phase_ready_delay
  process
    variable tmp_ready_delay : integer;
  begin
    loop
      tmp_ready_delay := m_rd_addr_phase_ready_delay;
      execute_read_addr_ready(0, 1, index, AXI4_PATH_6, axi4_tr_if_6(index)); 
      get_read_addr_cycle(index, AXI4_PATH_6, axi4_tr_if_6(index)); 
      if(tmp_ready_delay > 1) then
        for i in  0 to tmp_ready_delay-2 loop
          wait_on(AXI4_CLOCK_POSEDGE, index, AXI4_PATH_6, axi4_tr_if_6(index));
        end loop;
      end if;  
      execute_read_addr_ready(1, 0, index, AXI4_PATH_6, axi4_tr_if_6(index)); 
    end loop;
    wait;
  end process;

  -- handle_write_data_ready : write data ready through path 7
  -- This method assert/de-assert the write data channel ready signal.
  -- Assertion and de-assertion is done based on m_wr_data_phase_ready_delay
  process
    variable tmp_ready_delay : integer;
  begin
    loop
      tmp_ready_delay := m_wr_data_phase_ready_delay;
      execute_write_data_ready(0, 1, index, AXI4_PATH_7, axi4_tr_if_7(index)); 
      get_write_data_cycle(index, AXI4_PATH_7, axi4_tr_if_7(index)); 
      if(tmp_ready_delay > 1) then
        for i in  0 to tmp_ready_delay-2 loop
          wait_on(AXI4_CLOCK_POSEDGE, index, AXI4_PATH_7, axi4_tr_if_7(index));
        end loop;
      end if;  
      execute_write_data_ready(1, 0, index, AXI4_PATH_7, axi4_tr_if_7(index)); 
    end loop;
    wait;
  end process;

end slave_test_program_a;

