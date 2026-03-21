-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
-- MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
--
-- *****************************************************************************
--            Version: 20160107
-- *****************************************************************************

-- Title: mgc_axi4stream_inline_monitor
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

entity mgc_axi4stream_inline_monitor_vhd is
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
        master_TVALID          : out std_logic;
        master_TDATA           : out std_logic_vector(((AXI4_DATA_WIDTH) - 1) downto 0);
        master_TSTRB           : out std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        master_TKEEP           : out std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        master_TLAST           : out std_logic;
        master_TID             : out std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        master_TUSER           : out std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        master_TDEST           : out std_logic_vector(((AXI4_DEST_WIDTH) - 1) downto 0);
        master_TREADY          : in std_logic;

        slave_TVALID          : in std_logic;
        slave_TDATA           : in std_logic_vector(((AXI4_DATA_WIDTH) - 1) downto 0);
        slave_TSTRB           : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        slave_TKEEP           : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
        slave_TLAST           : in std_logic;
        slave_TID             : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        slave_TUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        slave_TDEST           : in std_logic_vector(((AXI4_DEST_WIDTH) - 1) downto 0);
        slave_TREADY          : out std_logic
        );
end mgc_axi4stream_inline_monitor_vhd;

architecture inline_monitor_a of mgc_axi4stream_inline_monitor_vhd is

component mgc_axi4stream_monitor_vhd is
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
end component;

begin

-- connect master and slave ends:
    master_TVALID         <= slave_TVALID;
    master_TDATA          <= slave_TDATA;
    master_TSTRB          <= slave_TSTRB;
    master_TKEEP          <= slave_TKEEP;
    master_TLAST          <= slave_TLAST;
    master_TID            <= slave_TID;
    master_TUSER          <= slave_TUSER;
    master_TDEST          <= slave_TDEST;
    slave_TREADY          <= master_TREADY;

-- Instantiation of the VHDL monitor:
mgc_axi4stream_monitor_vhd_inst: mgc_axi4stream_monitor_vhd
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
        TVALID     => slave_TVALID,
        TDATA      => slave_TDATA,
        TSTRB      => slave_TSTRB,
        TKEEP      => slave_TKEEP,
        TLAST      => slave_TLAST,
        TID        => slave_TID,
        TUSER      => slave_TUSER,
        TDEST      => slave_TDEST,
        TREADY     => master_TREADY
        );
end inline_monitor_a;
