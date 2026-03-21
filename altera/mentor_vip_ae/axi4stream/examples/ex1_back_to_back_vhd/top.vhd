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
  signal TVALID  : std_logic;
  signal TDATA   : std_logic_vector(31 downto 0);
  signal TSTRB   : std_logic_vector(3 downto 0);
  signal TKEEP   : std_logic_vector(3 downto 0);
  signal TLAST   : std_logic;
  signal TID     : std_logic_vector(7 downto 0);
  signal TUSER   : std_logic_vector(3 downto 0);
  signal TDEST   : std_logic_vector(3 downto 0);
  signal TREADY  : std_logic;

 
 component mgc_axi4stream_master_vhd
  generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
 port(
    ACLK       : in std_logic;
    ARESETn    : in std_logic;
    TVALID     : out std_logic;
    TDATA      : out std_logic_vector(((AXI4_DATA_WIDTH) - 1) downto 0);
    TSTRB      : out std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
    TKEEP      : out std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
    TLAST      : out std_logic;
    TID        : out std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
    TUSER      : out std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
    TDEST      : out std_logic_vector(((AXI4_DEST_WIDTH) - 1) downto 0);
    TREADY     : in std_logic
    );
 end component;

 component mgc_axi4stream_slave_vhd
  generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
  port(
    ACLK       : in std_logic;
    ARESETn    : in std_logic;
    TVALID     : in std_logic;
    TDATA      : in std_logic_vector(((AXI4_DATA_WIDTH) - 1) downto 0);
    TSTRB      : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
    TKEEP      : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
    TLAST      : in std_logic;
    TID        : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
    TUSER      : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
    TDEST      : in std_logic_vector(((AXI4_DEST_WIDTH) - 1) downto 0);
    TREADY     : out std_logic
    );
 end component;

 component mgc_axi4stream_monitor_vhd
  generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
 port(
      ACLK       : in std_logic;
      ARESETn    : in std_logic;
      TVALID     : in std_logic;
      TDATA      : in std_logic_vector(((AXI4_DATA_WIDTH) - 1) downto 0);
      TSTRB      : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
      TKEEP      : in std_logic_vector((((AXI4_DATA_WIDTH / 8)) - 1) downto 0);
      TLAST      : in std_logic;
      TID        : in std_logic_vector(((AXI4_ID_WIDTH) - 1) downto 0);
      TUSER      : in std_logic_vector(((AXI4_USER_WIDTH) - 1) downto 0);
      TDEST      : in std_logic_vector(((AXI4_DEST_WIDTH) - 1) downto 0);
      TREADY     : in std_logic 
     );
 end component;

  component master_test_program
   generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
  end component;

  component slave_test_program
   generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
  end component;

  component monitor_test_program
   generic(
            AXI4_ID_WIDTH : integer := 8;
            AXI4_USER_WIDTH : integer := 8;
            AXI4_DEST_WIDTH : integer := 18;
            AXI4_DATA_WIDTH : integer := 1024;
            index : integer range 0 to 511 := 0
           );
  end component;
begin

master_vhd: mgc_axi4stream_master_vhd
generic map(AXI4_ID_WIDTH   => 8,
             AXI4_USER_WIDTH => 4,
             AXI4_DEST_WIDTH => 4,
             AXI4_DATA_WIDTH => 32,
             index           => 0)
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
  TREADY     => TREADY
 );

 slave_vhd: mgc_axi4stream_slave_vhd
 generic map(AXI4_ID_WIDTH   => 8,
             AXI4_USER_WIDTH => 4,
             AXI4_DEST_WIDTH => 4,
             AXI4_DATA_WIDTH => 32,
             index           => 1)
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
  TREADY     => TREADY
 );

 monitor_vhd: mgc_axi4stream_monitor_vhd
 generic map(AXI4_ID_WIDTH   => 8,
             AXI4_USER_WIDTH => 4,
             AXI4_DEST_WIDTH => 4,
             AXI4_DATA_WIDTH => 32,
             index           => 2)
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
  TREADY     => TREADY
 );

mas_test: master_test_program
  generic map(AXI4_ID_WIDTH   => 8,
             AXI4_USER_WIDTH => 4,
             AXI4_DEST_WIDTH => 4,
             AXI4_DATA_WIDTH => 32,
             index           => 0);

slv_test: slave_test_program
  generic map(AXI4_ID_WIDTH   => 8,
             AXI4_USER_WIDTH => 4,
             AXI4_DEST_WIDTH => 4,
             AXI4_DATA_WIDTH => 32,
             index           => 1);

mon_test: monitor_test_program
 generic map(AXI4_ID_WIDTH   => 8,
             AXI4_USER_WIDTH => 4,
             AXI4_DEST_WIDTH => 4,
             AXI4_DATA_WIDTH => 32,
             index           => 2);

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
