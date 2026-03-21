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
-- Title: mgc_axi4lite_master_vhd
--
-- This is a wrapper around mgc_axi4_master_vhd interface (axi4 master BFM) and
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

entity mgc_axi4lite_master_vhd is
    generic(
            AXI4_ADDRESS_WIDTH : integer := 64;
            AXI4_RDATA_WIDTH : integer := 1024;
            AXI4_WDATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0;
            READ_ISSUING_CAPABILITY : integer := 16;
            WRITE_ISSUING_CAPABILITY : integer := 16;
            COMBINED_ISSUING_CAPABILITY : integer := 16
           );
    port(
        AWVALID : out std_logic;
			  AWPROT  : out std_logic_vector(2 downto 0);
			  AWREADY : in  std_logic;
			  ARVALID : out std_logic;
			  ARPROT  : out std_logic_vector(2 downto 0);
			  ARREADY : in  std_logic;
			  RVALID  : in  std_logic;
			  RRESP   : in  std_logic_vector(1 downto 0);
			  RREADY  : out std_logic;
			  WVALID  : out std_logic;
			  WREADY  : in  std_logic;
			  BVALID  : in  std_logic;
			  BRESP   : in  std_logic_vector(1 downto 0);
			  BREADY  : out std_logic;
			  AWADDR  : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
			  ARADDR  : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
			  RDATA   : in  std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
			  WDATA   : out std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
			  WSTRB   : out std_logic_vector(((AXI4_WDATA_WIDTH / 8) - 1) downto 0);
			  ACLK    : in  std_logic;
			  ARESETn : in  std_logic
		    );

end mgc_axi4lite_master_vhd;

architecture master of mgc_axi4lite_master_vhd is

component mgc_axi4_master_vhd
  generic(
          AXI4_ADDRESS_WIDTH : integer := 64;
          AXI4_RDATA_WIDTH : integer := 1024;
          AXI4_WDATA_WIDTH : integer := 1024;
          index : integer range 0 to 511 := 0;
          READ_ISSUING_CAPABILITY : integer := 16;
          WRITE_ISSUING_CAPABILITY : integer := 16;
          COMBINED_ISSUING_CAPABILITY : integer := 16
         );
  port(
      ACLK            : in std_logic;
      ARESETn         : in std_logic;
      AWVALID         : out std_logic;
      AWADDR          : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
      AWPROT          : out std_logic_vector(2 downto 0);
      AWREGION        : out std_logic_vector(3 downto 0);
      AWLEN           : out std_logic_vector(7 downto 0);
      AWSIZE          : out std_logic_vector(2 downto 0);
      AWBURST         : out std_logic_vector(1 downto 0);
      AWLOCK          : out std_logic;
      AWCACHE         : out std_logic_vector(3 downto 0);
      AWQOS           : out std_logic_vector(3 downto 0);
      AWID            : out std_logic_vector(17 downto 0);
      AWUSER          : out std_logic_vector(7 downto 0);
      AWREADY         : in std_logic;
      ARVALID         : out std_logic;
      ARADDR          : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
      ARPROT          : out std_logic_vector(2 downto 0);
      ARREGION        : out std_logic_vector(3 downto 0);
      ARLEN           : out std_logic_vector(7 downto 0);
      ARSIZE          : out std_logic_vector(2 downto 0);
      ARBURST         : out std_logic_vector(1 downto 0);
      ARLOCK          : out std_logic;
      ARCACHE         : out std_logic_vector(3 downto 0);
      ARQOS           : out std_logic_vector(3 downto 0);
      ARID            : out std_logic_vector(17 downto 0);
      ARUSER          : out std_logic_vector(7 downto 0);
      ARREADY         : in std_logic;
      RVALID          : in std_logic;
      RDATA           : in std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0);
      RRESP           : in std_logic_vector(1 downto 0);
      RLAST           : in std_logic;
      RID             : in std_logic_vector(17 downto 0);
      RUSER           : in std_logic_vector(7 downto 0);
      RREADY          : out std_logic;
      WVALID          : out std_logic;
      WDATA           : out std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
      WSTRB           : out std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
      WLAST           : out std_logic;
      WUSER           : out std_logic_vector(7 downto 0);
      WREADY          : in std_logic;
      BVALID          : in std_logic;
      BRESP           : in std_logic_vector(1 downto 0);
      BID             : in std_logic_vector(17 downto 0);
      BUSER           : in std_logic_vector(7 downto 0);
      BREADY          : out std_logic
       );

end component mgc_axi4_master_vhd;

begin

mgc_axi4_master_bfm_inst : component mgc_axi4_master_vhd
		generic map (
			AXI4_ADDRESS_WIDTH => AXI4_ADDRESS_WIDTH,
			AXI4_RDATA_WIDTH   => AXI4_RDATA_WIDTH,
			AXI4_WDATA_WIDTH   => AXI4_WDATA_WIDTH,
			index              => index,  
      READ_ISSUING_CAPABILITY => READ_ISSUING_CAPABILITY,
      WRITE_ISSUING_CAPABILITY => WRITE_ISSUING_CAPABILITY,
      COMBINED_ISSUING_CAPABILITY => COMBINED_ISSUING_CAPABILITY
		)                              
		port map (                     
      ACLK      =>  ACLK,      
      ARESETn   =>  ARESETn,   
      AWVALID   =>  AWVALID,   
      AWADDR    =>  AWADDR,    
      AWPROT    =>  AWPROT,    
      AWREGION  =>  open,  
      AWLEN     =>  open,    
      AWSIZE    =>  open,    
      AWBURST   =>  open,   
      AWLOCK    =>  open,
      AWCACHE   =>  open,
      AWQOS     =>  open,
      AWID      =>  open,
      AWUSER    =>  open,
      AWREADY   =>  AWREADY,   
      ARVALID   =>  ARVALID,   
      ARADDR    =>  ARADDR,    
      ARPROT    =>  ARPROT,    
      ARREGION  =>  open,
      ARLEN     =>  open,
      ARSIZE    =>  open,
      ARBURST   =>  open,
      ARLOCK    =>  open,
      ARCACHE   =>  open,
      ARQOS     =>  open,
      ARID      =>  open,
      ARUSER    =>  open,
      ARREADY   =>  ARREADY,   
      RVALID    =>  RVALID,    
      RDATA     =>  RDATA,     
      RRESP     =>  RRESP,     
      RLAST     =>  '1',    
      RID       =>  (others => '0'),
      RUSER     =>  (others => '0'),
      RREADY    =>  RREADY,    
      WVALID    =>  WVALID,    
      WDATA     =>  WDATA,     
      WSTRB     =>  WSTRB,     
      WLAST     =>  open,
      WUSER     =>  open,
      WREADY    =>  WREADY,    
      BVALID    =>  BVALID,    
      BRESP     =>  BRESP,     
      BID       =>  (others => '0'),      
      BUSER     =>  (others => '0'),      
      BREADY    =>  BREADY    
		);

  set_config(AXI4_CONFIG_AXI4LITE_INTERFACE, 1, index, axi4_tr_if_1(index));

end architecture master;
