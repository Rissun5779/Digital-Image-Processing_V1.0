-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
-- MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
--
-- *****************************************************************************
--            Version: 20140122_Questa_10.2c
-- *****************************************************************************

-- Title: mgc_axi4_inline_monitor
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
use work.mgc_axi4_bfm_pkg.all;

entity mgc_axi4_inline_monitor_vhd is
    generic(
            AXI4_ADDRESS_WIDTH : integer := 64;
            AXI4_RDATA_WIDTH : integer := 1024;
            AXI4_WDATA_WIDTH : integer := 1024;
            AXI4_ID_WIDTH : integer := 18;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_REGION_MAP_SIZE : integer := 16;
            index : integer range 0 to 511 := 0;
            READ_ACCEPTANCE_CAPABILITY : integer := 16;
            WRITE_ACCEPTANCE_CAPABILITY : integer := 16;
            COMBINED_ACCEPTANCE_CAPABILITY : integer := 16;
            USE_AWID             : integer := 1;
            USE_AWREGION         : integer := 1;
            USE_AWLEN            : integer := 1;
            USE_AWSIZE           : integer := 1;
            USE_AWBURST          : integer := 1;
			      USE_AWLOCK           : integer := 1;
			      USE_AWCACHE          : integer := 1;
			      USE_AWQOS            : integer := 1;
            USE_WSTRB            : integer := 1;
            USE_BID              : integer := 1;
			      USE_AWPROT           : integer := 1;
			      USE_WLAST            : integer := 1;
			      USE_BRESP            : integer := 1;
            USE_ARID             : integer := 1;
			      USE_ARREGION         : integer := 1;
            USE_ARLEN            : integer := 1;
            USE_ARSIZE           : integer := 1;
            USE_ARBURST          : integer := 1;
			      USE_ARLOCK           : integer := 1;
			      USE_ARCACHE          : integer := 1;
			      USE_ARQOS            : integer := 1;
            USE_RID              : integer := 1;
			      USE_ARPROT           : integer := 1;
			      USE_RRESP            : integer := 1;
            USE_RLAST            : integer := 1;
			      USE_AWUSER           : integer := 1;
			      USE_ARUSER           : integer := 1;
			      USE_WUSER            : integer := 1;
			      USE_RUSER            : integer := 1;
			      USE_BUSER            : integer := 1
           );
    port(
        ACLK            : in std_logic;
        ARESETn         : in std_logic;
        master_AWVALID         : out std_logic;
        master_AWADDR          : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
        master_AWPROT          : out std_logic_vector(2 downto 0);
        master_AWREGION        : out std_logic_vector(3 downto 0);
        master_AWLEN           : out std_logic_vector(7 downto 0);
        master_AWSIZE          : out std_logic_vector(2 downto 0);
        master_AWBURST         : out std_logic_vector(1 downto 0);
        master_AWLOCK          : out std_logic;
        master_AWCACHE         : out std_logic_vector(3 downto 0);
        master_AWQOS           : out std_logic_vector(3 downto 0);
        master_AWID            : out std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        master_AWUSER          : out std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        master_AWREADY         : in std_logic;
        master_ARVALID         : out std_logic;
        master_ARADDR          : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
        master_ARPROT          : out std_logic_vector(2 downto 0);
        master_ARREGION        : out std_logic_vector(3 downto 0);
        master_ARLEN           : out std_logic_vector(7 downto 0);
        master_ARSIZE          : out std_logic_vector(2 downto 0);
        master_ARBURST         : out std_logic_vector(1 downto 0);
        master_ARLOCK          : out std_logic;
        master_ARCACHE         : out std_logic_vector(3 downto 0);
        master_ARQOS           : out std_logic_vector(3 downto 0);
        master_ARID            : out std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        master_ARUSER          : out std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        master_ARREADY         : in std_logic;
        master_RVALID          : in std_logic;
        master_RDATA           : in std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
        master_RRESP           : in std_logic_vector(1 downto 0);
        master_RLAST           : in std_logic;
        master_RID             : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        master_RUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        master_RREADY          : out std_logic;
        master_WVALID          : out std_logic;
        master_WDATA           : out std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
        master_WSTRB           : out std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
        master_WLAST           : out std_logic;
        master_WUSER           : out std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        master_WREADY          : in std_logic;
        master_BVALID          : in std_logic;
        master_BRESP           : in std_logic_vector(1 downto 0);
        master_BID             : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        master_BUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        master_BREADY          : out std_logic;

        slave_AWVALID         : in std_logic;
        slave_AWADDR          : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
        slave_AWPROT          : in std_logic_vector(2 downto 0);
        slave_AWREGION        : in std_logic_vector(3 downto 0);
        slave_AWLEN           : in std_logic_vector(7 downto 0);
        slave_AWSIZE          : in std_logic_vector(2 downto 0);
        slave_AWBURST         : in std_logic_vector(1 downto 0);
        slave_AWLOCK          : in std_logic;
        slave_AWCACHE         : in std_logic_vector(3 downto 0);
        slave_AWQOS           : in std_logic_vector(3 downto 0);
        slave_AWID            : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        slave_AWUSER          : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        slave_AWREADY         : out std_logic;
        slave_ARVALID         : in std_logic;
        slave_ARADDR          : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
        slave_ARPROT          : in std_logic_vector(2 downto 0);
        slave_ARREGION        : in std_logic_vector(3 downto 0);
        slave_ARLEN           : in std_logic_vector(7 downto 0);
        slave_ARSIZE          : in std_logic_vector(2 downto 0);
        slave_ARBURST         : in std_logic_vector(1 downto 0);
        slave_ARLOCK          : in std_logic;
        slave_ARCACHE         : in std_logic_vector(3 downto 0);
        slave_ARQOS           : in std_logic_vector(3 downto 0);
        slave_ARID            : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        slave_ARUSER          : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        slave_ARREADY         : out std_logic;
        slave_RVALID          : out std_logic;
        slave_RDATA           : out std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
        slave_RRESP           : out std_logic_vector(1 downto 0);
        slave_RLAST           : out std_logic;
        slave_RID             : out std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        slave_RUSER           : out std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        slave_RREADY          : in std_logic;
        slave_WVALID          : in std_logic;
        slave_WDATA           : in std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
        slave_WSTRB           : in std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
        slave_WLAST           : in std_logic;
        slave_WUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        slave_WREADY          : out std_logic;
        slave_BVALID          : out std_logic;
        slave_BRESP           : out std_logic_vector(1 downto 0);
        slave_BID             : out std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        slave_BUSER           : out std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        slave_BREADY          : in std_logic
        );
end mgc_axi4_inline_monitor_vhd;

architecture inline_monitor_a of mgc_axi4_inline_monitor_vhd is

component mgc_axi4_monitor_vhd is
    generic(
            AXI4_ADDRESS_WIDTH : integer := 64;
            AXI4_RDATA_WIDTH : integer := 1024;
            AXI4_WDATA_WIDTH : integer := 1024;
            AXI4_ID_WIDTH : integer := 18;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_REGION_MAP_SIZE : integer := 16;
            index : integer range 0 to 511 := 0;
            READ_ACCEPTANCE_CAPABILITY : integer := 16;
            WRITE_ACCEPTANCE_CAPABILITY : integer := 16;
            COMBINED_ACCEPTANCE_CAPABILITY : integer := 16;
            USE_AWID             : integer := 1;
            USE_AWREGION         : integer := 1;
            USE_AWLEN            : integer := 1;
            USE_AWSIZE           : integer := 1;
            USE_AWBURST          : integer := 1;
			      USE_AWLOCK           : integer := 1;
			      USE_AWCACHE          : integer := 1;
			      USE_AWQOS            : integer := 1;
            USE_WSTRB            : integer := 1;
            USE_BID              : integer := 1;
			      USE_AWPROT           : integer := 1;
			      USE_WLAST            : integer := 1;
			      USE_BRESP            : integer := 1;
            USE_ARID             : integer := 1;
			      USE_ARREGION         : integer := 1;
            USE_ARLEN            : integer := 1;
            USE_ARSIZE           : integer := 1;
            USE_ARBURST          : integer := 1;
			      USE_ARLOCK           : integer := 1;
			      USE_ARCACHE          : integer := 1;
			      USE_ARQOS            : integer := 1;
            USE_RID              : integer := 1;
			      USE_ARPROT           : integer := 1;
			      USE_RRESP            : integer := 1;
            USE_RLAST            : integer := 1;
			      USE_AWUSER           : integer := 1;
			      USE_ARUSER           : integer := 1;
			      USE_WUSER            : integer := 1;
			      USE_RUSER            : integer := 1;
			      USE_BUSER            : integer := 1
           );
    port(
        ACLK            : in std_logic;
        ARESETn         : in std_logic;
        AWVALID         : in std_logic;
        AWADDR          : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
        AWPROT          : in std_logic_vector(2 downto 0);
        AWREGION        : in std_logic_vector(3 downto 0);
        AWLEN           : in std_logic_vector(7 downto 0);
        AWSIZE          : in std_logic_vector(2 downto 0);
        AWBURST         : in std_logic_vector(1 downto 0);
        AWLOCK          : in std_logic;
        AWCACHE         : in std_logic_vector(3 downto 0);
        AWQOS           : in std_logic_vector(3 downto 0);
        AWID            : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        AWUSER          : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        AWREADY         : in std_logic;
        ARVALID         : in std_logic;
        ARADDR          : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
        ARPROT          : in std_logic_vector(2 downto 0);
        ARREGION        : in std_logic_vector(3 downto 0);
        ARLEN           : in std_logic_vector(7 downto 0);
        ARSIZE          : in std_logic_vector(2 downto 0);
        ARBURST         : in std_logic_vector(1 downto 0);
        ARLOCK          : in std_logic;
        ARCACHE         : in std_logic_vector(3 downto 0);
        ARQOS           : in std_logic_vector(3 downto 0);
        ARID            : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        ARUSER          : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        ARREADY         : in std_logic;
        RVALID          : in std_logic;
        RDATA           : in std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
        RRESP           : in std_logic_vector(1 downto 0);
        RLAST           : in std_logic;
        RID             : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        RUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        RREADY          : in std_logic;
        WVALID          : in std_logic;
        WDATA           : in std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
        WSTRB           : in std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
        WLAST           : in std_logic;
        WUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        WREADY          : in std_logic;
        BVALID          : in std_logic;
        BRESP           : in std_logic_vector(1 downto 0);
        BID             : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
        BUSER           : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
        BREADY          : in std_logic
        );
end component;

begin

-- connect master and slave ends:
    master_AWVALID        <= slave_AWVALID;
    master_AWADDR         <= slave_AWADDR;
    master_AWPROT         <= slave_AWPROT;
    master_AWREGION       <= slave_AWREGION;
    master_AWLEN          <= slave_AWLEN;
    master_AWSIZE         <= slave_AWSIZE;
    master_AWBURST        <= slave_AWBURST;
    master_AWLOCK         <= slave_AWLOCK;
    master_AWCACHE        <= slave_AWCACHE;
    master_AWQOS          <= slave_AWQOS;
    master_AWID           <= slave_AWID;
    master_AWUSER         <= slave_AWUSER;
    slave_AWREADY         <= master_AWREADY;
    master_ARVALID        <= slave_ARVALID;
    master_ARADDR         <= slave_ARADDR;
    master_ARPROT         <= slave_ARPROT;
    master_ARREGION       <= slave_ARREGION;
    master_ARLEN          <= slave_ARLEN;
    master_ARSIZE         <= slave_ARSIZE;
    master_ARBURST        <= slave_ARBURST;
    master_ARLOCK         <= slave_ARLOCK;
    master_ARCACHE        <= slave_ARCACHE;
    master_ARQOS          <= slave_ARQOS;
    master_ARID           <= slave_ARID;
    master_ARUSER         <= slave_ARUSER;
    slave_ARREADY         <= master_ARREADY;
    slave_RVALID          <= master_RVALID;
    slave_RDATA           <= master_RDATA;
    slave_RRESP           <= master_RRESP;
    slave_RLAST           <= master_RLAST;
    slave_RID             <= master_RID;
    slave_RUSER           <= master_RUSER;
    master_RREADY         <= slave_RREADY;
    master_WVALID         <= slave_WVALID;
    master_WDATA          <= slave_WDATA;
    master_WSTRB          <= slave_WSTRB;
    master_WLAST          <= slave_WLAST;
    master_WUSER          <= slave_WUSER;
    slave_WREADY          <= master_WREADY;
    slave_BVALID          <= master_BVALID;
    slave_BRESP           <= master_BRESP;
    slave_BID             <= master_BID;
    slave_BUSER           <= master_BUSER;
    master_BREADY         <= slave_BREADY;

-- Instantiation of the VHDL monitor:
mgc_axi4_monitor_vhd_inst: mgc_axi4_monitor_vhd
    generic map(
        AXI4_ADDRESS_WIDTH => AXI4_ADDRESS_WIDTH,
        AXI4_RDATA_WIDTH => AXI4_RDATA_WIDTH,
        AXI4_WDATA_WIDTH => AXI4_WDATA_WIDTH,
        AXI4_ID_WIDTH   => AXI4_ID_WIDTH,
        AXI4_USER_WIDTH => AXI4_USER_WIDTH,
        AXI4_REGION_MAP_SIZE => AXI4_REGION_MAP_SIZE,
        index           => index,
        READ_ACCEPTANCE_CAPABILITY => READ_ACCEPTANCE_CAPABILITY,
        WRITE_ACCEPTANCE_CAPABILITY => WRITE_ACCEPTANCE_CAPABILITY,
        COMBINED_ACCEPTANCE_CAPABILITY => COMBINED_ACCEPTANCE_CAPABILITY,
        USE_AWID        =>  USE_AWID,
        USE_AWREGION    => USE_AWREGION,      
        USE_AWLEN       =>  USE_AWLEN,
        USE_AWSIZE      =>  USE_AWSIZE,
        USE_AWBURST     =>  USE_AWBURST, 
			  USE_AWLOCK      => USE_AWLOCK,      
			  USE_AWCACHE     => USE_AWCACHE,      
			  USE_AWQOS       => USE_AWQOS,      
        USE_WSTRB       =>  USE_WSTRB,
        USE_BID         =>  USE_BID, 
			  USE_AWPROT      => USE_AWPROT,      
			  USE_WLAST       => USE_WLAST,      
			  USE_BRESP       => USE_BRESP,      
        USE_ARID        =>  USE_ARID, 
			  USE_ARREGION    => USE_ARREGION,      
        USE_ARLEN       =>  USE_ARLEN,  
        USE_ARSIZE      =>  USE_ARSIZE,
        USE_ARBURST     =>  USE_ARBURST,
			  USE_ARLOCK      => USE_ARLOCK,     
			  USE_ARCACHE     => USE_ARCACHE,      
			  USE_ARQOS       => USE_ARQOS,      
        USE_RID         =>  USE_RID,
			  USE_ARPROT      => USE_ARPROT,      
			  USE_RRESP       => USE_RRESP,      
        USE_RLAST       =>  USE_RLAST, 
			  USE_AWUSER      => USE_AWUSER,      
			  USE_ARUSER      => USE_ARUSER,      
			  USE_WUSER       => USE_WUSER,      
			  USE_RUSER       => USE_RUSER,      
			  USE_BUSER       => USE_BUSER      
    )
    port map(
        ACLK       => ACLK,
        ARESETn    => ARESETn,
        AWVALID    => slave_AWVALID,
        AWADDR     => slave_AWADDR,
        AWPROT     => slave_AWPROT,
        AWREGION   => slave_AWREGION,
        AWLEN      => slave_AWLEN,
        AWSIZE     => slave_AWSIZE,
        AWBURST    => slave_AWBURST,
        AWLOCK     => slave_AWLOCK,
        AWCACHE    => slave_AWCACHE,
        AWQOS      => slave_AWQOS,
        AWID       => slave_AWID,
        AWUSER     => slave_AWUSER,
        AWREADY    => master_AWREADY,
        ARVALID    => slave_ARVALID,
        ARADDR     => slave_ARADDR,
        ARPROT     => slave_ARPROT,
        ARREGION   => slave_ARREGION,
        ARLEN      => slave_ARLEN,
        ARSIZE     => slave_ARSIZE,
        ARBURST    => slave_ARBURST,
        ARLOCK     => slave_ARLOCK,
        ARCACHE    => slave_ARCACHE,
        ARQOS      => slave_ARQOS,
        ARID       => slave_ARID,
        ARUSER     => slave_ARUSER,
        ARREADY    => master_ARREADY,
        RVALID     => master_RVALID,
        RDATA      => master_RDATA,
        RRESP      => master_RRESP,
        RLAST      => master_RLAST,
        RID        => master_RID,
        RUSER      => master_RUSER,
        RREADY     => slave_RREADY,
        WVALID     => slave_WVALID,
        WDATA      => slave_WDATA,
        WSTRB      => slave_WSTRB,
        WLAST      => slave_WLAST,
        WUSER      => slave_WUSER,
        WREADY     => master_WREADY,
        BVALID     => master_BVALID,
        BRESP      => master_BRESP,
        BID        => master_BID,
        BUSER      => master_BUSER,
        BREADY     => slave_BREADY
        );
end inline_monitor_a;
