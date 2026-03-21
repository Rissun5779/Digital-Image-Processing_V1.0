-- *****************************************************************************
--
-- Copyright 2007-2016 Mentor Graphics Corporation
-- All Rights Reserved.
--
-- THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
-- MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
--
-- *****************************************************************************

library ieee ;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity top is
end top;

architecture top_a of top is
  signal ACLK    : std_logic := '0';
  signal ARESETn : std_logic := '0';
  signal AWVALID : std_logic;
  signal AWADDR  : std_logic_vector(31 downto 0);
  signal AWPROT  : std_logic_vector(2 downto 0);
  signal AWREADY : std_logic; 
  signal ARVALID : std_logic;
  signal ARADDR  : std_logic_vector(31 downto 0);
  signal ARPROT  : std_logic_vector(2 downto 0);
  signal ARREADY : std_logic; 
  signal RVALID  : std_logic;     
  signal RDATA   : std_logic_vector(31 downto 0); 
  signal RRESP   : std_logic_vector(1 downto 0); 
  signal RREADY  : std_logic;
  signal WVALID  : std_logic;
  signal WDATA   : std_logic_vector(31 downto 0);
  signal WSTRB   : std_logic_vector(3 downto 0);
  signal WREADY  : std_logic;
  signal BVALID  : std_logic; 
  signal BRESP   : std_logic_vector(1 downto 0); 
  signal BREADY  : std_logic;
 
  component mgc_axi4lite_master_vhd
  generic (AXI4_ADDRESS_WIDTH : integer := 32;
           AXI4_RDATA_WIDTH : integer := 32;
           AXI4_WDATA_WIDTH : integer := 32;
           index : integer range 0 to 511 := 0;
           READ_ISSUING_CAPABILITY : integer := 16;
           WRITE_ISSUING_CAPABILITY : integer := 16;
           COMBINED_ISSUING_CAPABILITY : integer := 16
          );
 port(
    ACLK    : in std_logic;
    ARESETn : in std_logic;
    AWVALID : out std_logic;
    AWADDR  : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
    AWPROT  : out std_logic_vector(2 downto 0);
    AWREADY : in std_logic; 
    ARVALID : out std_logic;
    ARADDR  : out std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
    ARPROT  : out std_logic_vector(2 downto 0);
    ARREADY : in std_logic; 
    RVALID  : in std_logic;     
    RDATA   : in std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0); 
    RRESP   : in std_logic_vector(1 downto 0); 
    RREADY  : out std_logic;
    WVALID  : out std_logic;
    WDATA   : out std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
    WSTRB   : out std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
    WREADY  : in std_logic;
    BVALID  : in std_logic; 
    BRESP   : in std_logic_vector(1 downto 0); 
    BREADY  : out std_logic
   );
 end component;

  component mgc_axi4lite_slave_vhd
  generic (AXI4_ADDRESS_WIDTH : integer := 32;
           AXI4_RDATA_WIDTH : integer := 32;
           AXI4_WDATA_WIDTH : integer := 32;
           index : integer range 0 to 511 := 0;
           READ_ACCEPTANCE_CAPABILITY : integer := 16;
           WRITE_ACCEPTANCE_CAPABILITY : integer := 16;
           COMBINED_ACCEPTANCE_CAPABILITY : integer := 16
          );
  port(
    ACLK    : in std_logic;
    ARESETn : in std_logic;
    AWVALID : in std_logic;
    AWADDR  : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
    AWPROT  : in std_logic_vector(2 downto 0);
    AWREADY : out std_logic; 
    ARVALID : in std_logic;
    ARADDR  : in std_logic_vector(((AXI4_ADDRESS_WIDTH) - 1) downto 0);
    ARPROT  : in std_logic_vector(2 downto 0);
    ARREADY : out std_logic; 
    RVALID  : out std_logic;     
    RDATA   : out std_logic_vector(((AXI4_RDATA_WIDTH) - 1) downto 0); 
    RRESP   : out std_logic_vector(1 downto 0); 
    RREADY  : in std_logic;
    WVALID  : in std_logic;
    WDATA   : in std_logic_vector(((AXI4_WDATA_WIDTH) - 1) downto 0);
    WSTRB   : in std_logic_vector((((AXI4_WDATA_WIDTH / 8)) - 1) downto 0);
    WREADY  : out std_logic;
    BVALID  : out std_logic; 
    BRESP   : out std_logic_vector(1 downto 0); 
    BREADY  : in std_logic
   );
 end component;

  component mgc_axi4lite_inline_monitor_vhd
  generic (AXI4_ADDRESS_WIDTH : integer := 32;
           AXI4_RDATA_WIDTH : integer := 32;
           AXI4_WDATA_WIDTH : integer := 32;
           index : integer range 0 to 511 :=0;
           READ_ACCEPTANCE_CAPABILITY : integer := 16;
           WRITE_ACCEPTANCE_CAPABILITY : integer := 16;
           COMBINED_ACCEPTANCE_CAPABILITY : integer := 16
          );
 port(
    ACLK    : in std_logic;
    ARESETn : in std_logic;
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
 end component;

  component master_test_program
   generic (AXI4_ADDRESS_WIDTH : integer := 32;
            AXI4_RDATA_WIDTH : integer := 32;
            AXI4_WDATA_WIDTH : integer := 32;
            index : integer range 0 to 511 := 0
          );
  end component;

  component slave_test_program
   generic (AXI4_ADDRESS_WIDTH : integer := 32;
            AXI4_RDATA_WIDTH : integer := 32;
            AXI4_WDATA_WIDTH : integer := 32;
            index : integer range 0 to 511 := 0
          );
  end component;

  component monitor_test_program
   generic (AXI4_ADDRESS_WIDTH : integer := 32;
            AXI4_RDATA_WIDTH : integer := 32;
            AXI4_WDATA_WIDTH : integer := 32;
            index : integer range 0 to 511 := 0
          );
  end component;
begin

master_vhd:mgc_axi4lite_master_vhd
generic map(AXI4_ADDRESS_WIDTH => 32,
  AXI4_RDATA_WIDTH     => 32,
  AXI4_WDATA_WIDTH     => 32,
  index                => 0,
  READ_ISSUING_CAPABILITY => 16,
  WRITE_ISSUING_CAPABILITY => 16,
  COMBINED_ISSUING_CAPABILITY => 16)
port map(
  ACLK     => ACLK,    
  ARESETn  => ARESETn, 
  AWVALID  => AWVALID, 
  AWADDR   => AWADDR,  
  AWPROT   => AWPROT,  
  AWREADY  => AWREADY, 
  ARVALID  => ARVALID, 
  ARADDR   => ARADDR,  
  ARPROT   => ARPROT,  
  ARREADY  => ARREADY, 
  RVALID   => RVALID,  
  RDATA    => RDATA,   
  RRESP    => RRESP,   
  RREADY   => RREADY,  
  WVALID   => WVALID,  
  WDATA    => WDATA,   
  WSTRB    => WSTRB,   
  WREADY   => WREADY,  
  BVALID   => BVALID,  
  BRESP    => BRESP,   
  BREADY   => BREADY
 );

slave_vhd:mgc_axi4lite_slave_vhd
generic map(AXI4_ADDRESS_WIDTH => 32,
  AXI4_RDATA_WIDTH     => 32,
  AXI4_WDATA_WIDTH     => 32,
  index                => 1,
  READ_ACCEPTANCE_CAPABILITY => 2,
  WRITE_ACCEPTANCE_CAPABILITY => 2,
  COMBINED_ACCEPTANCE_CAPABILITY => 4)
 port map(
  ACLK     => ACLK,    
  ARESETn  => ARESETn, 
  AWVALID  => AWVALID, 
  AWADDR   => AWADDR,  
  AWPROT   => AWPROT,  
  AWREADY  => AWREADY, 
  ARVALID  => ARVALID, 
  ARADDR   => ARADDR,  
  ARPROT   => ARPROT,  
  ARREADY  => ARREADY, 
  RVALID   => RVALID,  
  RDATA    => RDATA,   
  RRESP    => RRESP,   
  RREADY   => RREADY,  
  WVALID   => WVALID,  
  WDATA    => WDATA,   
  WSTRB    => WSTRB,   
  WREADY   => WREADY,  
  BVALID   => BVALID,  
  BRESP    => BRESP,   
  BREADY   => BREADY
 );

monitor_vhd:mgc_axi4lite_inline_monitor_vhd
generic map(AXI4_ADDRESS_WIDTH => 32,
  AXI4_RDATA_WIDTH     => 32,
  AXI4_WDATA_WIDTH     => 32,
  index                => 2,
  READ_ACCEPTANCE_CAPABILITY => 2,
  WRITE_ACCEPTANCE_CAPABILITY => 2,
  COMBINED_ACCEPTANCE_CAPABILITY => 4)
port map(
  ACLK     => ACLK,    
  ARESETn  => ARESETn, 
  master_AWVALID  => open, 
  master_AWADDR   => open,  
  master_AWPROT   => open,  
  master_AWREADY  => AWREADY, 
  master_ARVALID  => open, 
  master_ARADDR   => open,  
  master_ARPROT   => open,  
  master_ARREADY  => ARREADY, 
  master_RVALID   => RVALID,  
  master_RDATA    => RDATA,   
  master_RRESP    => RRESP,   
  master_RREADY   => open,  
  master_WVALID   => open,  
  master_WDATA    => open,   
  master_WSTRB    => open,   
  master_WREADY   => WREADY,  
  master_BVALID   => BVALID,  
  master_BRESP    => BRESP,   
  master_BREADY   => open,
  slave_AWVALID   => AWVALID, 
  slave_AWADDR    => AWADDR,  
  slave_AWPROT    => AWPROT,  
  slave_AWREADY   => open, 
  slave_ARVALID   => ARVALID, 
  slave_ARADDR    => ARADDR,  
  slave_ARPROT    => ARPROT,  
  slave_ARREADY   => open, 
  slave_RVALID    => open,  
  slave_RDATA     => open,   
  slave_RRESP     => open,   
  slave_RREADY    => RREADY,  
  slave_WVALID    => WVALID,  
  slave_WDATA     => WDATA,   
  slave_WSTRB     => WSTRB,   
  slave_WREADY    => open,  
  slave_BVALID    => open,  
  slave_BRESP     => open,   
  slave_BREADY    => BREADY
 );

mas_test: master_test_program
generic map(AXI4_ADDRESS_WIDTH => 32,
  AXI4_RDATA_WIDTH     => 32,
  AXI4_WDATA_WIDTH     => 32,
  index                => 0);

slv_test: slave_test_program
generic map(AXI4_ADDRESS_WIDTH => 32,
  AXI4_RDATA_WIDTH     => 32,
  AXI4_WDATA_WIDTH     => 32,
  index                => 1);

mon_test: monitor_test_program
generic map(AXI4_ADDRESS_WIDTH => 32,
  AXI4_RDATA_WIDTH     => 32,
  AXI4_WDATA_WIDTH     => 32,
  index                => 2);

  -- Clock and reset generation 
  process
  begin
    ARESETn <= '0';
    wait for 100 ns;
    ARESETn <= '1';
    wait;
  end process;
  
  process
  begin
      ACLK <=  not ACLK;
      wait for 5 ns;
  end process;

end top_a;
