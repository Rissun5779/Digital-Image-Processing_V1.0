-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
-- PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
-- LICENSE TERMS.
--
-- *****************************************************************************
-- dvc           
-- *****************************************************************************
--
-- Title: mgc_axi4lite_inline_monitor_vhd
--
-- This is a wrapper around mgc_axi4_inline_monitor_vhd interface (axi4 monitor
-- BFM) and provides the sub-set of full axi4 interface (configured to work as
-- axi4lite inteface) signals which are intended for axi4lite, to connect to
-- the axi4lite DUT signals. It ties the axi4 signals which are not specific to
-- axi4lite interface to their default value accordingly.
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.mgc_axi4_bfm_pkg.all;

entity mgc_axi4lite_inline_monitor_vhd is
  generic(
          AXI4_ADDRESS_WIDTH : integer := 64;
          AXI4_RDATA_WIDTH : integer := 1024;
          AXI4_WDATA_WIDTH : integer := 1024;
          index : integer range 0 to 511 := 0;
          READ_ACCEPTANCE_CAPABILITY : integer := 16;
          WRITE_ACCEPTANCE_CAPABILITY : integer := 16;
          COMBINED_ACCEPTANCE_CAPABILITY : integer := 16
         );
  port(
		  ACLK           : in  std_logic;
		  ARESETn        : in  std_logic;
      master_AWVALID : out std_logic;
		  master_AWPROT  : out std_logic_vector(2 downto 0);
		  master_AWREADY : in  std_logic;
		  master_ARVALID : out std_logic;
		  master_ARPROT  : out std_logic_vector(2 downto 0);
		  master_ARREADY : in  std_logic;
		  master_RVALID  : in  std_logic;
		  master_RRESP   : in  std_logic_vector(1 downto 0);
		  master_RREADY  : out std_logic;
		  master_WVALID  : out std_logic;
		  master_WREADY  : in  std_logic;
		  master_BVALID  : in  std_logic;
		  master_BRESP   : in  std_logic_vector(1 downto 0);
		  master_BREADY  : out std_logic;
		  master_AWADDR  : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
		  master_ARADDR  : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
		  master_RDATA   : in  std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
		  master_WDATA   : out std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
		  master_WSTRB   : out std_logic_vector(((AXI4_WDATA_WIDTH / 8) - 1) downto 0);
      slave_AWVALID  : in std_logic;
		  slave_AWPROT   : in std_logic_vector(2 downto 0);
		  slave_AWREADY  : out  std_logic;
		  slave_ARVALID  : in std_logic;
		  slave_ARPROT   : in std_logic_vector(2 downto 0);
		  slave_ARREADY  : out  std_logic;
		  slave_RVALID   : out  std_logic;
		  slave_RRESP    : out  std_logic_vector(1 downto 0);
		  slave_RREADY   : in std_logic;
		  slave_WVALID   : in std_logic;
		  slave_WREADY   : out  std_logic;
		  slave_BVALID   : out  std_logic;
		  slave_BRESP    : out  std_logic_vector(1 downto 0);
		  slave_BREADY   : in std_logic;
		  slave_AWADDR   : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
		  slave_ARADDR   : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
		  slave_RDATA    : out  std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
		  slave_WDATA    : in std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
		  slave_WSTRB    : in std_logic_vector(((AXI4_WDATA_WIDTH / 8) - 1) downto 0)
	    );

end mgc_axi4lite_inline_monitor_vhd;

architecture inline_monitor of mgc_axi4lite_inline_monitor_vhd is

component mgc_axi4_inline_monitor_vhd
  generic(
          AXI4_ADDRESS_WIDTH : integer := 64;
          AXI4_RDATA_WIDTH : integer := 1024;
          AXI4_WDATA_WIDTH : integer := 1024;
          index : integer range 0 to 511 := 0;
          READ_ACCEPTANCE_CAPABILITY : integer := 16;
          WRITE_ACCEPTANCE_CAPABILITY : integer := 16;
          COMBINED_ACCEPTANCE_CAPABILITY : integer := 16
         );
  port(
      ACLK            : in std_logic;
      ARESETn         : in std_logic;
      master_AWVALID  : out std_logic;
      master_AWADDR   : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
      master_AWPROT   : out std_logic_vector(2 downto 0);
      master_AWREGION : out std_logic_vector(3 downto 0);
      master_AWLEN    : out std_logic_vector(7 downto 0);
      master_AWSIZE   : out std_logic_vector(2 downto 0);
      master_AWBURST  : out std_logic_vector(1 downto 0);
      master_AWLOCK   : out std_logic;
      master_AWCACHE  : out std_logic_vector(3 downto 0);
      master_AWQOS    : out std_logic_vector(3 downto 0);
      master_AWID     : out std_logic_vector(17 downto 0);
      master_AWUSER   : out std_logic_vector(7 downto 0);
      master_AWREADY  : in std_logic;
      master_ARVALID  : out std_logic;
      master_ARADDR   : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
      master_ARPROT   : out std_logic_vector(2 downto 0);
      master_ARREGION : out std_logic_vector(3 downto 0);
      master_ARLEN    : out std_logic_vector(7 downto 0);
      master_ARSIZE   : out std_logic_vector(2 downto 0);
      master_ARBURST  : out std_logic_vector(1 downto 0);
      master_ARLOCK   : out std_logic;
      master_ARCACHE  : out std_logic_vector(3 downto 0);
      master_ARQOS    : out std_logic_vector(3 downto 0);
      master_ARID     : out std_logic_vector(17 downto 0);
      master_ARUSER   : out std_logic_vector(7 downto 0);
      master_ARREADY  : in std_logic;
      master_RVALID   : in std_logic;
      master_RDATA    : in std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
      master_RRESP    : in std_logic_vector(1 downto 0);
      master_RLAST    : in std_logic;
      master_RID      : in std_logic_vector(17 downto 0);
      master_RUSER    : in std_logic_vector(7 downto 0);
      master_RREADY   : out std_logic;
      master_WVALID   : out std_logic;
      master_WDATA    : out std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
      master_WSTRB    : out std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
      master_WLAST    : out std_logic;
      master_WUSER    : out std_logic_vector(7 downto 0);
      master_WREADY   : in std_logic;
      master_BVALID   : in std_logic;
      master_BRESP    : in std_logic_vector(1 downto 0);
      master_BID      : in std_logic_vector(17 downto 0);
      master_BUSER    : in std_logic_vector(7 downto 0);
      master_BREADY   : out std_logic;
      slave_AWVALID   : in std_logic;
      slave_AWADDR    : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
      slave_AWPROT    : in std_logic_vector(2 downto 0);
      slave_AWREGION  : in std_logic_vector(3 downto 0);
      slave_AWLEN     : in std_logic_vector(7 downto 0);
      slave_AWSIZE    : in std_logic_vector(2 downto 0);
      slave_AWBURST   : in std_logic_vector(1 downto 0);
      slave_AWLOCK    : in std_logic;
      slave_AWCACHE   : in std_logic_vector(3 downto 0);
      slave_AWQOS     : in std_logic_vector(3 downto 0);
      slave_AWID      : in std_logic_vector(17 downto 0);
      slave_AWUSER    : in std_logic_vector(7 downto 0);
      slave_AWREADY   : out std_logic;
      slave_ARVALID   : in std_logic;
      slave_ARADDR    : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
      slave_ARPROT    : in std_logic_vector(2 downto 0);
      slave_ARREGION  : in std_logic_vector(3 downto 0);
      slave_ARLEN     : in std_logic_vector(7 downto 0);
      slave_ARSIZE    : in std_logic_vector(2 downto 0);
      slave_ARBURST   : in std_logic_vector(1 downto 0);
      slave_ARLOCK    : in std_logic;
      slave_ARCACHE   : in std_logic_vector(3 downto 0);
      slave_ARQOS     : in std_logic_vector(3 downto 0);
      slave_ARID      : in std_logic_vector(17 downto 0);
      slave_ARUSER    : in std_logic_vector(7 downto 0);
      slave_ARREADY   : out std_logic;
      slave_RVALID    : out std_logic;
      slave_RDATA     : out std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
      slave_RRESP     : out std_logic_vector(1 downto 0);
      slave_RLAST     : out std_logic;
      slave_RID       : out std_logic_vector(17 downto 0);
      slave_RUSER     : out std_logic_vector(7 downto 0);
      slave_RREADY    : in std_logic;
      slave_WVALID    : in std_logic;
      slave_WDATA     : in std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
      slave_WSTRB     : in std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
      slave_WLAST     : in std_logic;
      slave_WUSER     : in std_logic_vector(7 downto 0);
      slave_WREADY    : out std_logic;
      slave_BVALID    : out std_logic;
      slave_BRESP     : out std_logic_vector(1 downto 0);
      slave_BID       : out std_logic_vector(17 downto 0);
      slave_BUSER     : out std_logic_vector(7 downto 0);
      slave_BREADY    : in std_logic
     );

end component mgc_axi4_inline_monitor_vhd;

begin

mgc_axi4_inline_monitor_bfm_inst : component mgc_axi4_inline_monitor_vhd
	generic map (
		AXI4_ADDRESS_WIDTH => AXI4_ADDRESS_WIDTH,
		AXI4_RDATA_WIDTH   => AXI4_RDATA_WIDTH,
		AXI4_WDATA_WIDTH   => AXI4_WDATA_WIDTH,
		index              => index,
    READ_ACCEPTANCE_CAPABILITY => READ_ACCEPTANCE_CAPABILITY,
    WRITE_ACCEPTANCE_CAPABILITY => WRITE_ACCEPTANCE_CAPABILITY,
    COMBINED_ACCEPTANCE_CAPABILITY => COMBINED_ACCEPTANCE_CAPABILITY
	)
	port map (
    ACLK             =>  ACLK,      
    ARESETn          =>  ARESETn,   
    master_AWVALID   =>  master_AWVALID,   
    master_AWADDR    =>  master_AWADDR,    
    master_AWPROT    =>  master_AWPROT,    
    master_AWREGION  =>  open,  
    master_AWLEN     =>  open,    
    master_AWSIZE    =>  open,    
    master_AWBURST   =>  open,   
    master_AWLOCK    =>  open,
    master_AWCACHE   =>  open,
    master_AWQOS     =>  open,
    master_AWID      =>  open,
    master_AWUSER    =>  open,
    master_AWREADY   =>  master_AWREADY,   
    master_ARVALID   =>  master_ARVALID,   
    master_ARADDR    =>  master_ARADDR,    
    master_ARPROT    =>  master_ARPROT,    
    master_ARREGION  =>  open,
    master_ARLEN     =>  open,
    master_ARSIZE    =>  open,
    master_ARBURST   =>  open,
    master_ARLOCK    =>  open,
    master_ARCACHE   =>  open,
    master_ARQOS     =>  open,
    master_ARID      =>  open,
    master_ARUSER    =>  open,
    master_ARREADY   =>  master_ARREADY,   
    master_RVALID    =>  master_RVALID,    
    master_RDATA     =>  master_RDATA,     
    master_RRESP     =>  master_RRESP,     
    master_RLAST     =>  '1',    
    master_RID       =>  (others => '0'),    
    master_RUSER     =>  (others => '0'),
    master_RREADY    =>  master_RREADY,    
    master_WVALID    =>  master_WVALID,    
    master_WDATA     =>  master_WDATA,     
    master_WSTRB     =>  master_WSTRB,     
    master_WLAST     =>  open,    
    master_WUSER     =>  open,
    master_WREADY    =>  master_WREADY,    
    master_BVALID    =>  master_BVALID,    
    master_BRESP     =>  master_BRESP,     
    master_BID       =>  (others => '0'),      
    master_BUSER     =>  (others => '0'),
    master_BREADY    =>  master_BREADY,
    slave_AWVALID    =>  slave_AWVALID,   
    slave_AWADDR     =>  slave_AWADDR,    
    slave_AWPROT     =>  slave_AWPROT,    
    slave_AWREGION   =>  (others => '0'),  
    slave_AWLEN      =>  (others => '0'),    
    slave_AWSIZE     =>  (others => '0'),    
    slave_AWBURST    =>  (others => '0'),   
    slave_AWLOCK     =>  '0',
    slave_AWCACHE    =>  (others => '0'),
    slave_AWQOS      =>  (others => '0'),
    slave_AWID       =>  (others => '0'),
    slave_AWUSER     =>  (others => '0'),
    slave_AWREADY    =>  slave_AWREADY,   
    slave_ARVALID    =>  slave_ARVALID,   
    slave_ARADDR     =>  slave_ARADDR,    
    slave_ARPROT     =>  slave_ARPROT,    
    slave_ARREGION   =>  (others => '0'),
    slave_ARLEN      =>  (others => '0'),
    slave_ARSIZE     =>  (others => '0'),
    slave_ARBURST    =>  (others => '0'),
    slave_ARLOCK     =>  '0',
    slave_ARCACHE    =>  (others => '0'),
    slave_ARQOS      =>  (others => '0'),
    slave_ARID       =>  (others => '0'),
    slave_ARUSER     =>  (others => '0'),
    slave_ARREADY    =>  slave_ARREADY,   
    slave_RVALID     =>  slave_RVALID,    
    slave_RDATA      =>  slave_RDATA,     
    slave_RRESP      =>  slave_RRESP,     
    slave_RLAST      =>  open,    
    slave_RID        =>  open,    
    slave_RUSER      =>  open,
    slave_RREADY     =>  slave_RREADY,    
    slave_WVALID     =>  slave_WVALID,    
    slave_WDATA      =>  slave_WDATA,     
    slave_WSTRB      =>  slave_WSTRB,     
    slave_WLAST      =>  '1',    
    slave_WUSER      =>  (others => '0'),
    slave_WREADY     =>  slave_WREADY,    
    slave_BVALID     =>  slave_BVALID,    
    slave_BRESP      =>  slave_BRESP,     
    slave_BID        =>  open,      
    slave_BUSER      =>  open,
    slave_BREADY     =>  slave_BREADY
		);

  set_config(AXI4_CONFIG_AXI4LITE_INTERFACE, 1, index, axi4_tr_if_5(index));

end architecture inline_monitor;
