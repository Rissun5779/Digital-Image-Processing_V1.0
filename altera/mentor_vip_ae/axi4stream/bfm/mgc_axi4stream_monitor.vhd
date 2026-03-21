-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
-- MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
--
-- *****************************************************************************
-- dvc           Version: 20160107
-- *****************************************************************************

-- Title: axi4stream_monitor_bfm
--

--
-- This is a wrapper around the SystemVerilog BFM wrapper
-- It provides a semi-abstract interface to the VHDL BFM interface package
-- and routes the BFM signals through to the DUT in the testbench
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.mgc_axi4stream_bfm_pkg.all;

entity mgc_axi4stream_monitor_vhd is
    generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
    port(
        ACLK            : in std_logic;
        ARESETn         : in std_logic;
        TVALID          : in std_logic;
        TDATA           : in std_logic_vector(((AXI4_DATA_WIDTH) - 1) downto 0);
        TSTRB           : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        TKEEP           : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        TLAST           : in std_logic;
        TID             : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        TUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        TDEST           : in std_logic_vector(((AXI4_DEST_WIDTH) - 1) downto 0);
        TREADY          : in std_logic
        );
end mgc_axi4stream_monitor_vhd;

architecture monitor_a of mgc_axi4stream_monitor_vhd is

component mgc_axi4stream_monitor
    generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
    port(
        ACLK            : in std_logic;
        ARESETn         : in std_logic;
        TVALID          : in std_logic;
        TDATA           : in std_logic_vector(((AXI4_DATA_WIDTH) - 1) downto 0);
        TSTRB           : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        TKEEP           : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        TLAST           : in std_logic;
        TID             : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        TUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        TDEST           : in std_logic_vector(((AXI4_DEST_WIDTH) - 1) downto 0);
        TREADY          : in std_logic;

    --  VHDL application interface
    --  Parallel path 0
        req_p0                           : in std_logic_vector(AXI4STREAM_VHD_WAIT_ON downto 0);
        transaction_id_in_p0             : in integer;
        value_in0_p0                     : in integer;
        value_in1_p0                     : in integer;
        value_in2_p0                     : in integer;
        value_in3_p0                     : in integer;
        value_in_max_p0                  : in std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
        ack_p0                           : out std_logic_vector(AXI4STREAM_VHD_WAIT_ON downto 0);
        transaction_id_out_p0            : out integer;
        value_out0_p0                    : out integer;
        value_out1_p0                    : out integer;
        value_out_max_p0                 : out std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0)
     );
end component;

  -- Parallel path 0
  signal req_p0                           : std_logic_vector(AXI4STREAM_VHD_WAIT_ON downto 0);
  signal transaction_id_in_p0             : integer;
  signal value_in0_p0                     : integer;
  signal value_in1_p0                     : integer;
  signal value_in2_p0                     : integer;
  signal value_in3_p0                     : integer;
  signal value_in_max_p0                  : std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
  signal ack_p0                           : std_logic_vector(AXI4STREAM_VHD_WAIT_ON downto 0);
  signal transaction_id_out_p0            : integer;
  signal value_out0_p0                    : integer;
  signal value_out1_p0                    : integer;
  signal value_out_max_p0                 : std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);


begin

  --  Parallel path 0
  req_p0                                              <= axi4stream_tr_if_0(index).req;
  transaction_id_in_p0                                <= axi4stream_tr_if_0(index).transaction_id;
  value_in0_p0                                        <= axi4stream_tr_if_0(index).value_0;
  value_in1_p0                                        <= axi4stream_tr_if_0(index).value_1;
  value_in2_p0                                        <= axi4stream_tr_if_0(index).value_2;
  value_in3_p0                                        <= axi4stream_tr_if_0(index).value_3;
  value_in_max_p0                                     <= axi4stream_tr_if_0(index).value_max;
  axi4stream_tr_if_local(index)(AXI4STREAM_PATH_0).ack              <= ack_p0;
  axi4stream_tr_if_local(index)(AXI4STREAM_PATH_0).transaction_id   <= transaction_id_out_p0;
  axi4stream_tr_if_local(index)(AXI4STREAM_PATH_0).value_0          <= value_out0_p0;
  axi4stream_tr_if_local(index)(AXI4STREAM_PATH_0).value_1          <= value_out1_p0;
  axi4stream_tr_if_local(index)(AXI4STREAM_PATH_0).value_max        <= value_out_max_p0;

  -- Instantiation of the SystemVerilog BFM:
  mgc_axi4stream_monitor_inst: mgc_axi4stream_monitor
    generic map(
        AXI4_ID_WIDTH   => AXI4_ID_WIDTH,
        AXI4_USER_WIDTH => AXI4_USER_WIDTH,
        AXI4_DEST_WIDTH => AXI4_DEST_WIDTH,
        AXI4_DATA_WIDTH => AXI4_DATA_WIDTH,
        index           => index
    )
    port map(
        ACLK       => ACLK,
        ARESETn    => ARESETn,
        TVALID     => TVALID,
        TDATA      => TDATA,
        TSTRB      => TSTRB,
        TKEEP      => TKEEP,
        TLAST      => TLAST,
        TID        => TID,
        TUSER      => TUSER,
        TDEST      => TDEST,
        TREADY     => TREADY,

        -- VHDL application interface
        --  Parallel path 0
        req_p0                 =>  req_p0,
        transaction_id_in_p0   =>  transaction_id_in_p0,
        value_in0_p0           =>  value_in0_p0,
        value_in1_p0           =>  value_in1_p0,
        value_in2_p0           =>  value_in2_p0,
        value_in3_p0           =>  value_in3_p0,
        value_in_max_p0        =>  value_in_max_p0,
        ack_p0                 =>  ack_p0,
        transaction_id_out_p0  =>  transaction_id_out_p0,
        value_out0_p0          =>  value_out0_p0,
        value_out1_p0          =>  value_out1_p0,
        value_out_max_p0       =>  value_out_max_p0
     );
end monitor_a;
