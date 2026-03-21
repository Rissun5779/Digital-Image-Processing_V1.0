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
-- Title: mgc_axi4lite_slave_vhd
--
-- This is a wrapper around mgc_axi4_slave_vhd interface (axi4 slave BFM) and
-- provides the sub-set of full axi4 interface (configured to work as
-- axi4lite inteface) signals which are intended for axi4lite, to connect to
-- the axi4lite DUT signals. It ties the axi4 signals which are not specific to
-- axi4lite interface to their default value accordingly.
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.mgc_axi4_bfm_pkg.all;

entity mgc_axi4lite_slave_vhd is
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
        AWVALID : in std_logic;
			  AWPROT  : in std_logic_vector(2 downto 0);
			  AWREADY : out  std_logic;
			  ARVALID : in std_logic;
			  ARPROT  : in std_logic_vector(2 downto 0);
			  ARREADY : out  std_logic;
			  RVALID  : out  std_logic;
			  RRESP   : out  std_logic_vector(1 downto 0);
			  RREADY  : in std_logic;
			  WVALID  : in std_logic;
			  WREADY  : out  std_logic;
			  BVALID  : out  std_logic;
			  BRESP   : out  std_logic_vector(1 downto 0);
			  BREADY  : in std_logic;
			  AWADDR  : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
			  ARADDR  : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
			  RDATA   : out  std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
			  WDATA   : in std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
			  WSTRB   : in std_logic_vector(((AXI4_WDATA_WIDTH / 8) - 1) downto 0);
			  ACLK    : in  std_logic;
			  ARESETn : in  std_logic
		    );

end mgc_axi4lite_slave_vhd;

architecture slave of mgc_axi4lite_slave_vhd is

component mgc_axi4_slave_vhd
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
      AWID            : in std_logic_vector(17 downto 0);
      AWUSER          : in std_logic_vector(7 downto 0);
      AWREADY         : out std_logic;
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
      ARID            : in std_logic_vector(17 downto 0);
      ARUSER          : in std_logic_vector(7 downto 0);
      ARREADY         : out std_logic;
      RVALID          : out std_logic;
      RDATA           : out std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
      RRESP           : out std_logic_vector(1 downto 0);
      RLAST           : out std_logic;
      RID             : out std_logic_vector(17 downto 0);
      RUSER           : out std_logic_vector(7 downto 0);
      RREADY          : in std_logic;
      WVALID          : in std_logic;
      WDATA           : in std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
      WSTRB           : in std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
      WLAST           : in std_logic;
      WUSER           : in std_logic_vector(7 downto 0);
      WREADY          : out std_logic;
      BVALID          : out std_logic;
      BRESP           : out std_logic_vector(1 downto 0);
      BID             : out std_logic_vector(17 downto 0);
      BUSER           : out std_logic_vector(7 downto 0);
      BREADY          : in std_logic
       );

end component mgc_axi4_slave_vhd;

begin

mgc_axi4_slave_bfm_inst : component mgc_axi4_slave_vhd
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
      ACLK      =>  ACLK,      
      ARESETn   =>  ARESETn,   
      AWVALID   =>  AWVALID,   
      AWADDR    =>  AWADDR,    
      AWPROT    =>  AWPROT,    
      AWREGION  =>  (others => '0'),  
      AWLEN     =>  (others => '0'),    
      AWSIZE    =>  (others => '0'),    
      AWBURST   =>  (others => '0'),   
      AWLOCK    =>  '0',
      AWCACHE   =>  (others => '0'),
      AWQOS     =>  (others => '0'),
      AWID      =>  (others => '0'),
      AWUSER    =>  (others => '0'),
      AWREADY   =>  AWREADY,   
      ARVALID   =>  ARVALID,   
      ARADDR    =>  ARADDR,    
      ARPROT    =>  ARPROT,    
      ARREGION  =>  (others => '0'),
      ARLEN     =>  (others => '0'),
      ARSIZE    =>  (others => '0'),
      ARBURST   =>  (others => '0'),
      ARLOCK    =>  '0',
      ARCACHE   =>  (others => '0'),
      ARQOS     =>  (others => '0'),
      ARID      =>  (others => '0'),
      ARUSER    =>  (others => '0'),
      ARREADY   =>  ARREADY,   
      RVALID    =>  RVALID,    
      RDATA     =>  RDATA,     
      RRESP     =>  RRESP,     
      RLAST     =>  open,    
      RID       =>  open,    
      RUSER     =>  open,
      RREADY    =>  RREADY,    
      WVALID    =>  WVALID,    
      WDATA     =>  WDATA,     
      WSTRB     =>  WSTRB,     
      WLAST     =>  '1',    
      WUSER     =>  (others => '0'),
      WREADY    =>  WREADY,    
      BVALID    =>  BVALID,    
      BRESP     =>  BRESP,     
      BID       =>  open,      
      BUSER     =>  open,
      BREADY    =>  BREADY    
		);

  set_config(AXI4_CONFIG_AXI4LITE_INTERFACE, 1, index, axi4_tr_if_2(0));

end architecture slave;
