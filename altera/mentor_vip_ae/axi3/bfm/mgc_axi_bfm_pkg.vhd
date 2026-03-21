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

-- Title: mgc_axi_bfm_pkg
--
-- This package contains the user APIs.
--
-- For multiple BFMs there can be an array of bus_if records, with the
-- appropriate array member being passed to the read or write procedure

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.all;
package mgc_axi_bfm_pkg is

    -- axi_size_e
    --------------------------------------------------------------------------------
    --  Word size encoding 
    --------------------------------------------------------------------------------
    constant AXI_BYTES_1   : integer := 0;
    constant AXI_BYTES_2   : integer := 1;
    constant AXI_BYTES_4   : integer := 2;
    constant AXI_BYTES_8   : integer := 3;
    constant AXI_BYTES_16  : integer := 4;
    constant AXI_BYTES_32  : integer := 5;
    constant AXI_BYTES_64  : integer := 6;
    constant AXI_BYTES_128 : integer := 7;

    -- axi_prot_e
    --------------------------------------------------------------------------------
    --  Protection type 
    --------------------------------------------------------------------------------
    constant AXI_NORM_SEC_DATA    : integer := 0;
    constant AXI_PRIV_SEC_DATA    : integer := 1;
    constant AXI_NORM_NONSEC_DATA : integer := 2;
    constant AXI_PRIV_NONSEC_DATA : integer := 3;
    constant AXI_NORM_SEC_INST    : integer := 4;
    constant AXI_PRIV_SEC_INST    : integer := 5;
    constant AXI_NORM_NONSEC_INST : integer := 6;
    constant AXI_PRIV_NONSEC_INST : integer := 7;

    -- axi_cache_e
    --------------------------------------------------------------------------------
    --  Cache type
    --------------------------------------------------------------------------------
    constant AXI_NONCACHE_NONBUF             : integer := 0;
    constant AXI_BUF_ONLY                    : integer := 1;
    constant AXI_CACHE_NOALLOC               : integer := 2;
    constant AXI_CACHE_BUF_NOALLOC           : integer := 3;
    constant AXI_CACHE_RSVD0                 : integer := 4;
    constant AXI_CACHE_RSVD1                 : integer := 5;
    constant AXI_CACHE_WTHROUGH_ALLOC_R_ONLY : integer := 6;
    constant AXI_CACHE_WBACK_ALLOC_R_ONLY    : integer := 7;
    constant AXI_CACHE_RSVD2                 : integer := 8;
    constant AXI_CACHE_RSVD3                 : integer := 9;
    constant AXI_CACHE_WTHROUGH_ALLOC_W_ONLY : integer := 10;
    constant AXI_CACHE_WBACK_ALLOC_W_ONLY    : integer := 11;
    constant AXI_CACHE_RSVD4                 : integer := 12;
    constant AXI_CACHE_RSVD5                 : integer := 13;
    constant AXI_CACHE_WTHROUGH_ALLOC_RW     : integer := 14;
    constant AXI_CACHE_WBACK_ALLOC_RW        : integer := 15;

    -- axi_burst_e
    --------------------------------------------------------------------------------
    --  This specifies Burst type which determines address calculation
    --------------------------------------------------------------------------------
    constant AXI_FIXED      : integer := 0;
    constant AXI_INCR       : integer := 1;
    constant AXI_WRAP       : integer := 2;
    constant AXI_BURST_RSVD : integer := 3;

    -- axi_response_e
    --------------------------------------------------------------------------------
    --  Response type 
    --------------------------------------------------------------------------------
    constant AXI_OKAY   : integer := 0;
    constant AXI_EXOKAY : integer := 1;
    constant AXI_SLVERR : integer := 2;
    constant AXI_DECERR : integer := 3;

    -- axi_lock_e
    --------------------------------------------------------------------------------
    --  Lock type for atomic accesses
    --------------------------------------------------------------------------------
    constant AXI_NORMAL    : integer := 0;
    constant AXI_EXCLUSIVE : integer := 1;
    constant AXI_LOCKED    : integer := 2;
    constant AXI_LOCK_RSVD : integer := 3;

    -- axi_rw_e
    --------------------------------------------------------------------------------
    --  Specifies transaction type read or write 
    --------------------------------------------------------------------------------
    constant AXI_TRANS_READ  : integer := 0;
    constant AXI_TRANS_WRITE : integer := 1;

    -- axi_error_e
    --------------------------------------------------------------------------------
    --  Specifies error type 
    --------------------------------------------------------------------------------
    constant AXI_AWBURST_RSVD        : integer := 0;
    constant AXI_ARBURST_RSVD        : integer := 1;
    constant AXI_AWSIZE_GT_BUS_WIDTH : integer := 2;
    constant AXI_ARSIZE_GT_BUS_WIDTH : integer := 3;
    constant AXI_AWLOCK_RSVD         : integer := 4;
    constant AXI_ARLOCK_RSVD         : integer := 5;
    constant AXI_AWLEN_LAST_MISMATCH : integer := 6;
    constant AXI_AWID_WID_MISMATCH   : integer := 7;
    constant AXI_WSTRB_ILLEGAL       : integer := 8;
    constant AXI_AWCACHE_RSVD        : integer := 9;
    constant AXI_ARCACHE_RSVD        : integer := 10;


    constant AXI_MAX_BIT_SIZE : integer := 1024;

-- enum: axi_config_e
--
-- An enum which fields corresponding to each configuration parameter of the VIP
--    AXI_CONFIG_WRITE_CTRL_TO_DATA_MINTIME - 
--         
--         Sets the delay from start of address phase to start of data phase in a write 
--         transaction (in terms of ACLK).
--         
--         Default: 1 
--         
--         This configuration variable has been deprecated and is maintained 
--         for backward compatibility. However, you can use ~write_address_to_data_delay~ 
--         configuration variable to control the delay between a write address phase 
--         and a write data phase.
--         
--    AXI_CONFIG_ENABLE_ALL_ASSERTIONS - 
--         
--         Enables all protocol assertions. 
--         
--         Default: 1
--         
--    AXI_CONFIG_ENABLE_ASSERTION - 
--         
--         Enables individual protocol assertion.
--         This variable controls whether specific assertion within QVIP (of type <axi_assertion_e>) is enabled or disabled.
--         Individual assertion can be disabled as follows:-
--         //-----------------------------------------------------------------------
--         // < BFM interface>.set_config_enable_assertion_index1(<name of assertion>,1'b0);
--         //-----------------------------------------------------------------------
--         
--         For example, the assertion AXI_READ_DATA_UNKN is disabled as follows:
--         <bfm>.set_config_enable_assertion_index1(AXI_READ_DATA_UNKN, 1'b0); 
--         
--         Here bfm is the AXI interface instance name for which the assertion to be disabled. 
--         
--         Default: All assertions are enabled
--           
--         
--    AXI_CONFIG_SUPPORT_EXCLUSIVE_ACCESS - 
--         
--         Enables exclusive transactions support for slave.
--         If disabled, every exclusive read/write returns an OKAY response,
--         and exclusive write updates memory. 
--         
--         Default: 1  
--         
--    AXI_CONFIG_READ_DATA_REORDERING_DEPTH - 
--         
--         Sets the maximum number of different read transaction addresses for which read 
--         data(response) can be sent in any order from slave. 
--         
--         Default: 2 ** AXI_ID_WIDTH
--         
--    AXI_CONFIG_MAX_TRANSACTION_TIME_FACTOR - 
--          
--         Sets maximum timeout period (in terms of ACLK) for any complete read or write transaction, which
--         includes time period for all individual phases of transaction. 
--         
--         Default: 100000 clock cycles
--         
--    AXI_CONFIG_TIMEOUT_MAX_DATA_TRANSFER - 
--          
--         Sets maximum number of write data beats in a write data burst. 
--         
--         Default: 1024  
--         
--    AXI_CONFIG_BURST_TIMEOUT_FACTOR - 
--          
--         Sets maximum timeout period (in terms of ACLK) between individual phases of a transaction. 
--         
--         Default: 10000 clock cycles 
--         
--    AXI_CONFIG_MAX_LATENCY_AWVALID_ASSERTION_TO_AWREADY - 
--          
--         Sets maximum timeout period (in terms of ACLK) from assertion of AWVALID to assertion of AWREADY.
--         An error message AXI_AWREADY_NOT_ASSERTED_AFTER_AWVALID is generated if AWREADY is not asserted
--         after assertion of AWVALID within this period. 
--         
--         Default: 10000 clock cycles
--         
--    AXI_CONFIG_MAX_LATENCY_ARVALID_ASSERTION_TO_ARREADY - 
--          
--         Sets maximum timeout period (in terms of ACLK) from assertion of ARVALID to assertion of ARREADY.
--         An error message AXI_ARREADY_NOT_ASSERTED_AFTER_ARVALID is generated if ARREADY is not asserted
--         after assertion of ARVALID within this period. 
--         
--         Default: 10000 clock cycles
--         
--    AXI_CONFIG_MAX_LATENCY_RVALID_ASSERTION_TO_RREADY - 
--          
--         Sets maximum timeout period (in terms of ACLK) from assertion of RVALID to assertion of RREADY.
--         An error message AXI_RREADY_NOT_ASSERTED_AFTER_RVALID is generated if RREADY is not asserted
--         after assertion of RVALID within this period. 
--         
--         Default: 10000 clock cycles
--         
--    AXI_CONFIG_MAX_LATENCY_BVALID_ASSERTION_TO_BREADY - 
--          
--         Sets maximum timeout period (in terms of ACLK) from assertion of BVALID to assertion of BREADY.
--         An error message AXI_BREADY_NOT_ASSERTED_AFTER_BVALID is generated if BREADY is not asserted
--         after assertion of BVALID within this period. 
--         
--         Default: 10000 clock cycles
--         
--    AXI_CONFIG_MAX_LATENCY_WVALID_ASSERTION_TO_WREADY - 
--          
--         Sets maximum timeout period (in terms of ACLK) from assertion of WVALID to assertion of WREADY.
--         An error message AXI_WREADY_NOT_ASSERTED_AFTER_WVALID is generated if WREADY is not asserted
--         after assertion of WVALID within this period. 
--         
--         Default: 10000 clock cycles
--         
--    AXI_CONFIG_MASTER_ERROR_POSITION - 
--         
--         Sets type of master error.
--         
--    AXI_CONFIG_SETUP_TIME - 
--         
--         Sets number of simulation time units from the setup time to the active 
--         clock edge of ACLK. The setup time will always be less than the time period
--         of the clock. 
--         
--         Default: 0
--         
--    AXI_CONFIG_HOLD_TIME - 
--         
--         Sets number of simulation time units from the hold time to the active 
--         clock edge of ACLK. 
--         
--         Default: 0
--         
--    AXI_CONFIG_MAX_OUTSTANDING_WR -  Configures maximum possible outstanding Write transactions
--    AXI_CONFIG_MAX_OUTSTANDING_RD -  Configures maximum possible outstanding Read transactions
--    AXI_CONFIG_MAX_OUTSTANDING_RW -  Configures maximum possible outstanding Combined (Read and Write) transactions
--    AXI_CONFIG_IS_ISSUING -  Enables Master component to use "config_max_outstanding_wr/config_max_outstanding_rd/config_max_outstanding_rw" variables for transaction issuing capability when set to true
    constant AXI_CONFIG_WRITE_CTRL_TO_DATA_MINTIME    : std_logic_vector(7 downto 0) := X"00";
    constant AXI_CONFIG_MASTER_WRITE_DELAY            : std_logic_vector(7 downto 0) := X"01";
    constant AXI_CONFIG_ENABLE_ALL_ASSERTIONS         : std_logic_vector(7 downto 0) := X"02";
    constant AXI_CONFIG_ENABLE_ASSERTION              : std_logic_vector(7 downto 0) := X"03";
    constant AXI_CONFIG_SLAVE_START_ADDR              : std_logic_vector(7 downto 0) := X"04";
    constant AXI_CONFIG_SLAVE_END_ADDR                : std_logic_vector(7 downto 0) := X"05";
    constant AXI_CONFIG_SUPPORT_EXCLUSIVE_ACCESS      : std_logic_vector(7 downto 0) := X"06";
    constant AXI_CONFIG_READ_DATA_REORDERING_DEPTH    : std_logic_vector(7 downto 0) := X"07";
    constant AXI_CONFIG_MAX_TRANSACTION_TIME_FACTOR   : std_logic_vector(7 downto 0) := X"08";
    constant AXI_CONFIG_TIMEOUT_MAX_DATA_TRANSFER     : std_logic_vector(7 downto 0) := X"09";
    constant AXI_CONFIG_BURST_TIMEOUT_FACTOR          : std_logic_vector(7 downto 0) := X"0A";
    constant AXI_CONFIG_MAX_LATENCY_AWVALID_ASSERTION_TO_AWREADY : std_logic_vector(7 downto 0) := X"0B";
    constant AXI_CONFIG_MAX_LATENCY_ARVALID_ASSERTION_TO_ARREADY : std_logic_vector(7 downto 0) := X"0C";
    constant AXI_CONFIG_MAX_LATENCY_RVALID_ASSERTION_TO_RREADY : std_logic_vector(7 downto 0) := X"0D";
    constant AXI_CONFIG_MAX_LATENCY_BVALID_ASSERTION_TO_BREADY : std_logic_vector(7 downto 0) := X"0E";
    constant AXI_CONFIG_MAX_LATENCY_WVALID_ASSERTION_TO_WREADY : std_logic_vector(7 downto 0) := X"0F";
    constant AXI_CONFIG_MASTER_ERROR_POSITION         : std_logic_vector(7 downto 0) := X"10";
    constant AXI_CONFIG_SETUP_TIME                    : std_logic_vector(7 downto 0) := X"11";
    constant AXI_CONFIG_HOLD_TIME                     : std_logic_vector(7 downto 0) := X"12";
    constant AXI_CONFIG_MAX_OUTSTANDING_WR            : std_logic_vector(7 downto 0) := X"13";
    constant AXI_CONFIG_MAX_OUTSTANDING_RD            : std_logic_vector(7 downto 0) := X"14";
    constant AXI_CONFIG_MAX_OUTSTANDING_RW            : std_logic_vector(7 downto 0) := X"15";
    constant AXI_CONFIG_IS_ISSUING                    : std_logic_vector(7 downto 0) := X"16";

    -- axi_vhd_if_e
    constant AXI_VHD_SET_CONFIG                         : integer := 0;
    constant AXI_VHD_GET_CONFIG                         : integer := 1;
    constant AXI_VHD_CREATE_WRITE_TRANSACTION           : integer := 2;
    constant AXI_VHD_CREATE_READ_TRANSACTION            : integer := 3;
    constant AXI_VHD_SET_ADDR                           : integer := 4;
    constant AXI_VHD_GET_ADDR                           : integer := 5;
    constant AXI_VHD_SET_SIZE                           : integer := 6;
    constant AXI_VHD_GET_SIZE                           : integer := 7;
    constant AXI_VHD_SET_BURST                          : integer := 8;
    constant AXI_VHD_GET_BURST                          : integer := 9;
    constant AXI_VHD_SET_LOCK                           : integer := 10;
    constant AXI_VHD_GET_LOCK                           : integer := 11;
    constant AXI_VHD_SET_CACHE                          : integer := 12;
    constant AXI_VHD_GET_CACHE                          : integer := 13;
    constant AXI_VHD_SET_PROT                           : integer := 14;
    constant AXI_VHD_GET_PROT                           : integer := 15;
    constant AXI_VHD_SET_ID                             : integer := 16;
    constant AXI_VHD_GET_ID                             : integer := 17;
    constant AXI_VHD_SET_BURST_LENGTH                   : integer := 18;
    constant AXI_VHD_GET_BURST_LENGTH                   : integer := 19;
    constant AXI_VHD_SET_DATA_WORDS                     : integer := 20;
    constant AXI_VHD_GET_DATA_WORDS                     : integer := 21;
    constant AXI_VHD_SET_WRITE_STROBES                  : integer := 22;
    constant AXI_VHD_GET_WRITE_STROBES                  : integer := 23;
    constant AXI_VHD_SET_RESP                           : integer := 24;
    constant AXI_VHD_GET_RESP                           : integer := 25;
    constant AXI_VHD_SET_ADDR_USER                      : integer := 26;
    constant AXI_VHD_GET_ADDR_USER                      : integer := 27;
    constant AXI_VHD_SET_READ_OR_WRITE                  : integer := 28;
    constant AXI_VHD_GET_READ_OR_WRITE                  : integer := 29;
    constant AXI_VHD_SET_ADDRESS_VALID_DELAY            : integer := 30;
    constant AXI_VHD_GET_ADDRESS_VALID_DELAY            : integer := 31;
    constant AXI_VHD_SET_DATA_VALID_DELAY               : integer := 32;
    constant AXI_VHD_GET_DATA_VALID_DELAY               : integer := 33;
    constant AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY     : integer := 34;
    constant AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY     : integer := 35;
    constant AXI_VHD_SET_ADDRESS_READY_DELAY            : integer := 36;
    constant AXI_VHD_GET_ADDRESS_READY_DELAY            : integer := 37;
    constant AXI_VHD_SET_DATA_READY_DELAY               : integer := 38;
    constant AXI_VHD_GET_DATA_READY_DELAY               : integer := 39;
    constant AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY     : integer := 40;
    constant AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY     : integer := 41;
    constant AXI_VHD_SET_GEN_WRITE_STROBES              : integer := 42;
    constant AXI_VHD_GET_GEN_WRITE_STROBES              : integer := 43;
    constant AXI_VHD_SET_OPERATION_MODE                 : integer := 44;
    constant AXI_VHD_GET_OPERATION_MODE                 : integer := 45;
    constant AXI_VHD_SET_DELAY_MODE                     : integer := 46;
    constant AXI_VHD_GET_DELAY_MODE                     : integer := 47;
    constant AXI_VHD_SET_WRITE_DATA_MODE                : integer := 48;
    constant AXI_VHD_GET_WRITE_DATA_MODE                : integer := 49;
    constant AXI_VHD_SET_DATA_BEAT_DONE                 : integer := 50;
    constant AXI_VHD_GET_DATA_BEAT_DONE                 : integer := 51;
    constant AXI_VHD_SET_TRANSACTION_DONE               : integer := 52;
    constant AXI_VHD_GET_TRANSACTION_DONE               : integer := 53;
    constant AXI_VHD_EXECUTE_TRANSACTION                : integer := 54;
    constant AXI_VHD_GET_RW_TRANSACTION                 : integer := 55;
    constant AXI_VHD_EXECUTE_READ_DATA_BURST            : integer := 56;
    constant AXI_VHD_GET_READ_DATA_BURST                : integer := 57;
    constant AXI_VHD_EXECUTE_WRITE_DATA_BURST           : integer := 58;
    constant AXI_VHD_GET_WRITE_DATA_BURST               : integer := 59;
    constant AXI_VHD_EXECUTE_READ_ADDR_PHASE            : integer := 60;
    constant AXI_VHD_GET_READ_ADDR_PHASE                : integer := 61;
    constant AXI_VHD_EXECUTE_READ_DATA_PHASE            : integer := 62;
    constant AXI_VHD_GET_READ_DATA_PHASE                : integer := 63;
    constant AXI_VHD_EXECUTE_WRITE_ADDR_PHASE           : integer := 64;
    constant AXI_VHD_GET_WRITE_ADDR_PHASE               : integer := 65;
    constant AXI_VHD_EXECUTE_WRITE_DATA_PHASE           : integer := 66;
    constant AXI_VHD_GET_WRITE_DATA_PHASE               : integer := 67;
    constant AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE       : integer := 68;
    constant AXI_VHD_GET_WRITE_RESPONSE_PHASE           : integer := 69;
    constant AXI_VHD_CREATE_MONITOR_TRANSACTION         : integer := 70;
    constant AXI_VHD_CREATE_SLAVE_TRANSACTION           : integer := 71;
    constant AXI_VHD_PUSH_TRANSACTION_ID                : integer := 72;
    constant AXI_VHD_POP_TRANSACTION_ID                 : integer := 73;
    constant AXI_VHD_GET_WRITE_ADDR_DATA                : integer := 74;
    constant AXI_VHD_GET_READ_ADDR                      : integer := 75;
    constant AXI_VHD_SET_READ_DATA                      : integer := 76;
    constant AXI_VHD_PRINT                              : integer := 77;
    constant AXI_VHD_DESTRUCT_TRANSACTION               : integer := 78;
    constant AXI_VHD_WAIT_ON                            : integer := 79;

    -- axi_wait_e
    constant AXI_CLOCK_POSEDGE        : integer := 0;
    constant AXI_CLOCK_NEGEDGE        : integer := 1;
    constant AXI_CLOCK_ANYEDGE        : integer := 2;
    constant AXI_CLOCK_0_TO_1         : integer := 3;
    constant AXI_CLOCK_1_TO_0         : integer := 4;
    constant AXI_RESET_POSEDGE        : integer := 5;
    constant AXI_RESET_NEGEDGE        : integer := 6;
    constant AXI_RESET_ANYEDGE        : integer := 7;
    constant AXI_RESET_0_TO_1         : integer := 8;
    constant AXI_RESET_1_TO_0         : integer := 9;

    -- axi_operation_mode_e
    constant AXI_TRANSACTION_NON_BLOCKING : integer := 0;
    constant AXI_TRANSACTION_BLOCKING     : integer := 1;

    -- axi_delay_mode_e
    constant AXI_VALID2READY              : integer := 0;
    constant AXI_TRANS2READY              : integer := 1;

    -- axi_write_data_mode_e
    constant AXI_DATA_AFTER_ADDRESS       : integer := 0;
    constant AXI_DATA_WITH_ADDRESS        : integer := 1;

    -- Queue ID
    constant AXI_QUEUE_ID_0 : integer := 0;
    constant AXI_QUEUE_ID_1 : integer := 1;
    constant AXI_QUEUE_ID_2 : integer := 2;
    constant AXI_QUEUE_ID_3 : integer := 3;
    constant AXI_QUEUE_ID_4 : integer := 4;
    constant AXI_QUEUE_ID_5 : integer := 5;
    constant AXI_QUEUE_ID_6 : integer := 6;
    constant AXI_QUEUE_ID_7 : integer := 7;

    -- Parallel path
    type axi_path_t is (
      AXI_PATH_0,
      AXI_PATH_1,
      AXI_PATH_2,
      AXI_PATH_3,
      AXI_PATH_4
    );

    -- Parallel ready-path
    type axi_adv_path_t is (
      AXI_PATH_5,
      AXI_PATH_6,
      AXI_PATH_7
    );

    -- Global signal record
    type axi_vhd_if_struct_t is record
        req             : std_logic_vector(AXI_VHD_WAIT_ON downto 0);
        ack             : std_logic_vector(AXI_VHD_WAIT_ON downto 0);
        transaction_id  : integer; 
        value_0         : integer;
        value_1         : integer;
        value_2         : integer;
        value_3         : integer;
        value_max       : std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
    end record;

    -- 512 array of records 
    type axi_tr_if_array_t is array(511 downto 0) of axi_vhd_if_struct_t;
    type axi_tr_if_path_array_t is array(axi_path_t) of axi_vhd_if_struct_t;
    type axi_tr_if_path_2d_array_t is array(511 downto 0) of axi_tr_if_path_array_t;
    type axi_tr_adv_if_path_array_t is array(axi_adv_path_t) of axi_vhd_if_struct_t;
    type axi_tr_adv_if_path_2d_array_t is array(511 downto 0) of axi_tr_adv_if_path_array_t;

    -- Global signal passed to each API
    signal axi_tr_if_0              : axi_tr_if_array_t;
    signal axi_tr_if_1              : axi_tr_if_array_t;
    signal axi_tr_if_2              : axi_tr_if_array_t;
    signal axi_tr_if_3              : axi_tr_if_array_t;
    signal axi_tr_if_4              : axi_tr_if_array_t;
    signal axi_tr_if_5              : axi_tr_if_array_t;
    signal axi_tr_if_6              : axi_tr_if_array_t;
    signal axi_tr_if_7              : axi_tr_if_array_t;
    signal axi_tr_if_local          : axi_tr_if_path_2d_array_t;
    signal axi_tr_adv_if_local      : axi_tr_adv_if_path_2d_array_t;

    -- Helper method to convert to integer
    function to_integer (OP: STD_LOGIC_VECTOR) return INTEGER;

    -- API: Master, Slave, Monitor
    -- This procedure sets the configuration of the BFM.
    procedure set_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    procedure set_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id        : in    integer;
                         path_id       : in    axi_path_t;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    procedure set_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : in    integer;
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    procedure set_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : in    integer;
                         bfm_id        : in    integer;
                         path_id       : in    axi_path_t;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- This procedure gets the configuration of the BFM.
    procedure get_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : out   std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    procedure get_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : out   std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id        : in    integer;
                         path_id       : in    axi_path_t;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    procedure get_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : out   integer;
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    procedure get_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : out   integer;
                         bfm_id        : in    integer;
                         path_id       : in    axi_path_t;
                         signal tr_if  : inout axi_vhd_if_struct_t);

    -- API: Master
    -- This procedure creates a write transaction with the given parameters.
    procedure create_write_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_write_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_write_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_write_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_write_transaction(addr            : in integer;
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_write_transaction(addr            : in integer;
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_write_transaction(addr            : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_write_transaction(addr            : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    -- API: Master
    -- This procedure creates a read transaction with the given parameters.
    procedure create_read_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_read_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_read_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_read_transaction(addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_read_transaction(addr            : in integer;
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_read_transaction(addr            : in integer;
                                       burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_read_transaction(addr            : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    procedure create_read_transaction(addr            : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       path_id         : in axi_path_t;
                                       signal tr_if    : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the addr field of the transaction.
    procedure set_addr(addr                : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_addr(addr                : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_addr(addr                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_addr(addr                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the addr field of the transaction.
    procedure get_addr(addr                : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_addr(addr                : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_addr(addr                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_addr(addr                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the size field of the transaction.
    procedure set_size(size                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_size(size                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the size field of the transaction.
    procedure get_size(size                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_size(size                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the burst field of the transaction.
    procedure set_burst(burst               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_burst(burst               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the burst field of the transaction.
    procedure get_burst(burst               : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_burst(burst               : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the lock field of the transaction.
    procedure set_lock(lock                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_lock(lock                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the lock field of the transaction.
    procedure get_lock(lock                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_lock(lock                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the cache field of the transaction.
    procedure set_cache(cache               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_cache(cache               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the cache field of the transaction.
    procedure get_cache(cache               : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_cache(cache               : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the prot field of the transaction.
    procedure set_prot(prot                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_prot(prot                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the prot field of the transaction.
    procedure get_prot(prot                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_prot(prot                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the id field of the transaction.
    procedure set_id(id                  : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_id(id                  : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_id(id                  : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_id(id                  : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the id field of the transaction.
    procedure get_id(id                  : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_id(id                  : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_id(id                  : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_id(id                  : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the burst_length field of the transaction.
    procedure set_burst_length(burst_length        : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_burst_length(burst_length        : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_burst_length(burst_length        : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_burst_length(burst_length        : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the burst_length field of the transaction.
    procedure get_burst_length(burst_length        : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_burst_length(burst_length        : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_burst_length(burst_length        : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_burst_length(burst_length        : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the data_words field of the transaction.
    procedure set_data_words(data_words          : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_words(data_words          : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_words(data_words          : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_words(data_words          : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_words(data_words          : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_words(data_words          : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_words(data_words          : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_words(data_words          : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the data_words field of the transaction.
    procedure get_data_words(data_words          : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_words(data_words          : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_words(data_words          : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_words(data_words          : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_words(data_words          : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_words(data_words          : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_words(data_words          : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_words(data_words          : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the write_strobes field of the transaction.
    procedure set_write_strobes(write_strobes       : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_strobes(write_strobes       : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_strobes(write_strobes       : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_strobes(write_strobes       : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_strobes(write_strobes       : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_strobes(write_strobes       : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_strobes(write_strobes       : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_strobes(write_strobes       : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the write_strobes field of the transaction.
    procedure get_write_strobes(write_strobes       : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_strobes(write_strobes       : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_strobes(write_strobes       : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_strobes(write_strobes       : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_strobes(write_strobes       : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_strobes(write_strobes       : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_strobes(write_strobes       : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_strobes(write_strobes       : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the resp field of the transaction.
    procedure set_resp(resp                : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_resp(resp                : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_resp(resp                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_resp(resp                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the resp field of the transaction.
    procedure get_resp(resp                : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_resp(resp                : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_resp(resp                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_resp(resp                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the addr_user field of the transaction.
    procedure set_addr_user(addr_user           : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_addr_user(addr_user           : in    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_addr_user(addr_user           : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_addr_user(addr_user           : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the addr_user field of the transaction.
    procedure get_addr_user(addr_user           : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_addr_user(addr_user           : out    std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_addr_user(addr_user           : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_addr_user(addr_user           : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- This field is set by default when creating a transaction.
    procedure set_read_or_write(read_or_write       : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_read_or_write(read_or_write       : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the read_or_write field of the transaction.
    procedure get_read_or_write(read_or_write       : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_read_or_write(read_or_write       : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the address_valid_delay field of the transaction.
    procedure set_address_valid_delay(address_valid_delay : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_address_valid_delay(address_valid_delay : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the address_valid_delay field of the transaction.
    procedure get_address_valid_delay(address_valid_delay : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_address_valid_delay(address_valid_delay : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the data_valid_delay field of the transaction.
    procedure set_data_valid_delay(data_valid_delay    : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_valid_delay(data_valid_delay    : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_valid_delay(data_valid_delay    : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_valid_delay(data_valid_delay    : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the data_valid_delay field of the transaction.
    procedure get_data_valid_delay(data_valid_delay    : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_valid_delay(data_valid_delay    : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_valid_delay(data_valid_delay    : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_valid_delay(data_valid_delay    : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the write_response_valid_delay field of the transaction.
    procedure set_write_response_valid_delay(write_response_valid_delay: in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_response_valid_delay(write_response_valid_delay: in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the write_response_valid_delay field of the transaction.
    procedure get_write_response_valid_delay(write_response_valid_delay: out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_response_valid_delay(write_response_valid_delay: out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the address_ready_delay field of the transaction.
    procedure set_address_ready_delay(address_ready_delay : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_address_ready_delay(address_ready_delay : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the address_ready_delay field of the transaction.
    procedure get_address_ready_delay(address_ready_delay : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_address_ready_delay(address_ready_delay : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the data_ready_delay field of the transaction.
    procedure set_data_ready_delay(data_ready_delay    : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_ready_delay(data_ready_delay    : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_ready_delay(data_ready_delay    : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_ready_delay(data_ready_delay    : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the data_ready_delay field of the transaction.
    procedure get_data_ready_delay(data_ready_delay    : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_ready_delay(data_ready_delay    : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_ready_delay(data_ready_delay    : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_ready_delay(data_ready_delay    : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the write_response_ready_delay field of the transaction.
    procedure set_write_response_ready_delay(write_response_ready_delay: in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_response_ready_delay(write_response_ready_delay: in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the write_response_ready_delay field of the transaction.
    procedure get_write_response_ready_delay(write_response_ready_delay: out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_response_ready_delay(write_response_ready_delay: out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the gen_write_strobes field of the transaction.
    procedure set_gen_write_strobes(gen_write_strobes   : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_gen_write_strobes(gen_write_strobes   : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the gen_write_strobes field of the transaction.
    procedure get_gen_write_strobes(gen_write_strobes   : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_gen_write_strobes(gen_write_strobes   : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the operation_mode field of the transaction.
    procedure set_operation_mode(operation_mode      : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_operation_mode(operation_mode      : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the operation_mode field of the transaction.
    procedure get_operation_mode(operation_mode      : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_operation_mode(operation_mode      : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the delay_mode field of the transaction.
    procedure set_delay_mode(delay_mode          : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_delay_mode(delay_mode          : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the delay_mode field of the transaction.
    procedure get_delay_mode(delay_mode          : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_delay_mode(delay_mode          : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Set the write_data_mode field of the transaction.
    procedure set_write_data_mode(write_data_mode     : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_write_data_mode(write_data_mode     : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the write_data_mode field of the transaction.
    procedure get_write_data_mode(write_data_mode     : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_write_data_mode(write_data_mode     : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave
    -- Set the data_beat_done field of the transaction.
    procedure set_data_beat_done(data_beat_done      : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_beat_done(data_beat_done      : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_beat_done(data_beat_done      : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_data_beat_done(data_beat_done      : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the data_beat_done field of the transaction.
    procedure get_data_beat_done(data_beat_done      : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_beat_done(data_beat_done      : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_beat_done(data_beat_done      : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_data_beat_done(data_beat_done      : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave
    -- Set the transaction_done field of the transaction.
    procedure set_transaction_done(transaction_done    : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure set_transaction_done(transaction_done    : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the transaction_done field of the transaction.
    procedure get_transaction_done(transaction_done    : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    procedure get_transaction_done(transaction_done    : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    path_id             : in    axi_path_t;
                    signal tr_if        : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Execute a transaction defined by the paramters.
    procedure execute_transaction(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_transaction(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master, Monitor
    -- Get a read_data_burst defined by the paramters.
    procedure get_read_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_read_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Execute a write_data_burst defined by the paramters.
    procedure execute_write_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_write_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Execute a read_addr_phase defined by the paramters.
    procedure execute_read_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_read_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master, Monitor
    -- Get a read_data_phase defined by the paramters.
    procedure get_read_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     last         : out   integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_read_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     last         : out    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_read_data_phase(transaction_id  : in    integer;
                                     last         : out   integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_read_data_phase(transaction_id  : in    integer;
                                     last         : out    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Execute a write_addr_phase defined by the paramters.
    procedure execute_write_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_write_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master
    -- Execute a write_data_phase defined by the paramters.
    procedure execute_write_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_write_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_write_data_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_write_data_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master, Monitor
    -- Get a write_response_phase defined by the paramters.
    procedure get_write_response_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_write_response_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave
    -- Create a slave_transaction defined by the paramters.
    procedure create_slave_transaction(transaction_id  : out    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure create_slave_transaction(transaction_id  : out    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave
    -- Execute a read_data_burst defined by the paramters.
    procedure execute_read_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_read_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave, Monitor
    -- Get a write_data_burst defined by the paramters.
    procedure get_write_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_write_data_burst(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave, Monitor
    -- Get a read_addr_phase defined by the paramters.
    procedure get_read_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_read_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave
    -- Execute a read_data_phase defined by the paramters.
    procedure execute_read_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_read_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_read_data_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_read_data_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave, Monitor
    -- Get a write_addr_phase defined by the paramters.
    procedure get_write_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_write_addr_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave, Monitor
    -- Get a write_data_phase defined by the paramters.
    procedure get_write_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     last         : out   integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_write_data_phase(transaction_id  : in    integer;
                                     index        : in    integer;
                                     last         : out    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_write_data_phase(transaction_id  : in    integer;
                                     last         : out   integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_write_data_phase(transaction_id  : in    integer;
                                     last         : out    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Slave
    -- Execute a write_response_phase defined by the paramters.
    procedure execute_write_response_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure execute_write_response_phase(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Monitor
    -- Create a monitor_transaction defined by the paramters.
    procedure create_monitor_transaction(transaction_id  : out    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure create_monitor_transaction(transaction_id  : out    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Monitor
    -- Get a rw_transaction defined by the paramters.
    procedure get_rw_transaction(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    procedure get_rw_transaction(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     path_id      : in    axi_path_t;
                                     signal tr_if : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Push the transaction_id into the back of the queue.
    procedure push_transaction_id(transaction_id  : in integer;
                           queue_id        : in integer;
                           bfm_id          : in integer;
                           signal tr_if    : inout axi_vhd_if_struct_t);

    procedure push_transaction_id(transaction_id  : in integer;
                           queue_id        : in integer;
                           bfm_id          : in integer;
                           path_id         : in axi_path_t;
                           signal tr_if    : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Pop the transaction_id from the front of the queue.
    procedure pop_transaction_id(transaction_id  : out integer;
                           queue_id        : in integer;
                           bfm_id          : in integer;
                           signal tr_if    : inout axi_vhd_if_struct_t);

    procedure pop_transaction_id(transaction_id  : out integer;
                           queue_id        : in integer;
                           bfm_id          : in integer;
                           path_id         : in axi_path_t;
                           signal tr_if    : inout axi_vhd_if_struct_t);

    -- API: Slave
    -- Returns the address and data of the given byte within a write_data_phase.
    procedure get_write_addr_data(transaction_id  : in  integer;
                    index           : in  integer;
                    byte_index      : in  integer;
                    dynamic_size    : out integer;
                    addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                    data            : out std_logic_vector(7 downto 0);
                    bfm_id          : in  integer;
                    signal tr_if    : inout axi_vhd_if_struct_t);

    procedure get_write_addr_data(transaction_id  : in  integer;
                    index           : in  integer;
                    byte_index      : in  integer;
                    dynamic_size    : out integer;
                    addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                    data            : out std_logic_vector(7 downto 0);
                    bfm_id          : in  integer;
                    path_id         : in  axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t);

    -- API: Slave
    -- Returns the address of the given byte within a read_data transaction.
    procedure get_read_addr(transaction_id  : in  integer;
                    index           : in  integer;
                    byte_index      : in  integer;
                    dynamic_size    : out integer;
                    addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                    bfm_id          : in  integer;
                    signal tr_if    : inout axi_vhd_if_struct_t);

    procedure get_read_addr(transaction_id  : in  integer;
                    index           : in  integer;
                    byte_index      : in  integer;
                    dynamic_size    : out integer;
                    addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                    bfm_id          : in  integer;
                    path_id         : in  axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t);

    -- API: Slave
    -- Set the given data byte within a read transaction.
    procedure set_read_data(transaction_id  : in integer;
                    index           : in integer;
                    byte_index      : in integer;
                    dynamic_size    : in integer;
                    addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                    data            : in std_logic_vector(7 downto 0);
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t);

    procedure set_read_data(transaction_id  : in integer;
                    index           : in integer;
                    byte_index      : in integer;
                    dynamic_size    : in integer;
                    addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                    data            : in std_logic_vector(7 downto 0);
                    bfm_id          : in integer;
                    path_id         : in axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Print the transaction identified by the transaction_id.
    procedure print( transaction_id  : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure print( transaction_id  : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure print( transaction_id  : in integer;
                    print_delays    : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure print( transaction_id  : in integer;
                    print_delays    : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    -- API: Master, Slave, Monitor
    -- Remove and clean up the transaction identified by the transaction_id.
    procedure destruct_transaction( transaction_id  : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure destruct_transaction( transaction_id  : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    -- API: Master, Slave, Monitor
    -- Wait for the event specified by the parameters.
    procedure wait_on( phase           : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure wait_on( phase           : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure wait_on( phase           : in integer;
                    count           : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure wait_on( phase           : in integer;
                    count           : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure wait_on( phase           : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_adv_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t );

    procedure wait_on( phase           : in integer;
                    count           : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_adv_path_t;
                    signal tr_if    : inout axi_vhd_if_struct_t );

end mgc_axi_bfm_pkg;

-- Procedure implementations:
package body mgc_axi_bfm_pkg is

    ------------------------------------------------------------------------
    -- Id: TI2
    -- Convert passed std_logic_vector into integer.
    -- generate warning message if:
    --  array contains anything other than 0 or 1.
    ------------------------------------------------------------------------
    function to_integer (OP: STD_LOGIC_VECTOR)
      return INTEGER is
      variable result : INTEGER := 0;
      variable tmp_op : STD_LOGIC_VECTOR (OP'range) := OP;
    begin
      if not (Is_X(OP)) then
        for i in OP'range loop
          if OP(i) = '1' then
            result := result + 2**i;
          end if;
        end loop; 
        return result;
      -- OP contains anything other than 0 or 1
      else
      --  assert FALSE
      --    report "Illegal value detected in the conversion of TO_INTEGER"
      --    severity WARNING;
            return 0;
      end if;
    end to_integer;

    procedure set_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id       : in integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0   <= to_integer(config_name);
      tr_if.value_max <= config_val;
      tr_if.req(AXI_VHD_SET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_CONFIG) = '1');
      tr_if.req(AXI_VHD_SET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_CONFIG) = '0');
    end set_config;

    procedure set_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : in integer;
                         bfm_id       : in integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0   <= to_integer(config_name);
      tr_if.value_max <= conv_std_logic_vector(config_val, AXI_MAX_BIT_SIZE);
      tr_if.req(AXI_VHD_SET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_CONFIG) = '1');
      tr_if.req(AXI_VHD_SET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_CONFIG) = '0');
    end set_config;

    procedure set_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id       : in integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0   <= to_integer(config_name);
      tr_if.value_max <= config_val;
      tr_if.req(AXI_VHD_SET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_CONFIG) = '1');
      tr_if.req(AXI_VHD_SET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_CONFIG) = '0');
    end set_config;

    procedure set_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : in integer;
                         bfm_id       : in integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0   <= to_integer(config_name);
      tr_if.value_max <= conv_std_logic_vector(config_val, AXI_MAX_BIT_SIZE);
      tr_if.req(AXI_VHD_SET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_CONFIG) = '1');
      tr_if.req(AXI_VHD_SET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_CONFIG) = '0');
    end set_config;

    procedure get_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id       : in integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= to_integer(config_name);
      tr_if.req(AXI_VHD_GET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_CONFIG) = '1');
      tr_if.req(AXI_VHD_GET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_CONFIG) = '0');
      config_val := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_config;

    procedure get_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : out integer;
                         bfm_id       : in integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= to_integer(config_name);
      tr_if.req(AXI_VHD_GET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_CONFIG) = '1');
      tr_if.req(AXI_VHD_GET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_CONFIG) = '0');
      config_val := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_config;

    procedure get_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         bfm_id       : in integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= to_integer(config_name);
      tr_if.req(AXI_VHD_GET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_CONFIG) = '1');
      tr_if.req(AXI_VHD_GET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_CONFIG) = '0');
      config_val := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_config;

    procedure get_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : out integer;
                         bfm_id       : in integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= to_integer(config_name);
      tr_if.req(AXI_VHD_GET_CONFIG) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_CONFIG) = '1');
      tr_if.req(AXI_VHD_GET_CONFIG) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_CONFIG) = '0');
      config_val := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_config;

    procedure create_write_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_write_transaction;

    procedure create_write_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_write_transaction;

    procedure create_write_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_write_transaction;

    procedure create_write_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_write_transaction;

    procedure create_write_transaction(addr : in integer;
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_write_transaction;

    procedure create_write_transaction(addr : in integer;
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_write_transaction;

    procedure create_write_transaction(addr : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_write_transaction;

    procedure create_write_transaction(addr : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_WRITE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_WRITE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_write_transaction;

    procedure create_read_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_read_transaction;

    procedure create_read_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_read_transaction;

    procedure create_read_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_read_transaction;

    procedure create_read_transaction(addr : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= addr;
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_read_transaction;

    procedure create_read_transaction(addr : in integer;
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_read_transaction;

    procedure create_read_transaction(addr : in integer;
                         burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_read_transaction;

    procedure create_read_transaction(addr : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_read_transaction;

    procedure create_read_transaction(addr : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         path_id      : in axi_path_t;
                         signal tr_if : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max   <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0     <= 0;
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_READ_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_READ_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_read_transaction;

    procedure set_addr(addr       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= addr;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR) = '1');
      tr_if.req(AXI_VHD_SET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR) = '0');
    end set_addr;

    procedure set_addr(addr       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR) = '1');
      tr_if.req(AXI_VHD_SET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR) = '0');
    end set_addr;

    procedure get_addr(addr       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR) = '1');
      tr_if.req(AXI_VHD_GET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR) = '0');
      addr := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_addr;

    procedure get_addr(addr       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR) = '1');
      tr_if.req(AXI_VHD_GET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR) = '0');
      addr := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_addr;

    procedure set_addr(addr       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= addr;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR) = '1');
      tr_if.req(AXI_VHD_SET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR) = '0');
    end set_addr;

    procedure set_addr(addr       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(addr, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR) = '1');
      tr_if.req(AXI_VHD_SET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR) = '0');
    end set_addr;

    procedure get_addr(addr       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR) = '1');
      tr_if.req(AXI_VHD_GET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR) = '0');
      addr := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_addr;

    procedure get_addr(addr       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR) = '1');
      tr_if.req(AXI_VHD_GET_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR) = '0');
      addr := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_addr;

    procedure set_size(size       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= size;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_SIZE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_SIZE) = '1');
      tr_if.req(AXI_VHD_SET_SIZE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_SIZE) = '0');
    end set_size;

    procedure get_size(size       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_SIZE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_SIZE) = '1');
      tr_if.req(AXI_VHD_GET_SIZE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_SIZE) = '0');
      size := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_size;

    procedure set_size(size       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= size;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_SIZE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_SIZE) = '1');
      tr_if.req(AXI_VHD_SET_SIZE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_SIZE) = '0');
    end set_size;

    procedure get_size(size       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_SIZE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_SIZE) = '1');
      tr_if.req(AXI_VHD_GET_SIZE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_SIZE) = '0');
      size := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_size;

    procedure set_burst(burst       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= burst;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_BURST) = '1');
      tr_if.req(AXI_VHD_SET_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_BURST) = '0');
    end set_burst;

    procedure get_burst(burst       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_BURST) = '1');
      tr_if.req(AXI_VHD_GET_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_BURST) = '0');
      burst := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_burst;

    procedure set_burst(burst       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= burst;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_BURST) = '1');
      tr_if.req(AXI_VHD_SET_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_BURST) = '0');
    end set_burst;

    procedure get_burst(burst       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_BURST) = '1');
      tr_if.req(AXI_VHD_GET_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_BURST) = '0');
      burst := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_burst;

    procedure set_lock(lock       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= lock;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_LOCK) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_LOCK) = '1');
      tr_if.req(AXI_VHD_SET_LOCK) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_LOCK) = '0');
    end set_lock;

    procedure get_lock(lock       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_LOCK) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_LOCK) = '1');
      tr_if.req(AXI_VHD_GET_LOCK) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_LOCK) = '0');
      lock := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_lock;

    procedure set_lock(lock       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= lock;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_LOCK) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_LOCK) = '1');
      tr_if.req(AXI_VHD_SET_LOCK) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_LOCK) = '0');
    end set_lock;

    procedure get_lock(lock       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_LOCK) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_LOCK) = '1');
      tr_if.req(AXI_VHD_GET_LOCK) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_LOCK) = '0');
      lock := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_lock;

    procedure set_cache(cache       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= cache;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_CACHE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_CACHE) = '1');
      tr_if.req(AXI_VHD_SET_CACHE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_CACHE) = '0');
    end set_cache;

    procedure get_cache(cache       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_CACHE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_CACHE) = '1');
      tr_if.req(AXI_VHD_GET_CACHE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_CACHE) = '0');
      cache := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_cache;

    procedure set_cache(cache       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= cache;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_CACHE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_CACHE) = '1');
      tr_if.req(AXI_VHD_SET_CACHE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_CACHE) = '0');
    end set_cache;

    procedure get_cache(cache       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_CACHE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_CACHE) = '1');
      tr_if.req(AXI_VHD_GET_CACHE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_CACHE) = '0');
      cache := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_cache;

    procedure set_prot(prot       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= prot;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_PROT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_PROT) = '1');
      tr_if.req(AXI_VHD_SET_PROT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_PROT) = '0');
    end set_prot;

    procedure get_prot(prot       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_PROT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_PROT) = '1');
      tr_if.req(AXI_VHD_GET_PROT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_PROT) = '0');
      prot := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_prot;

    procedure set_prot(prot       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= prot;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_PROT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_PROT) = '1');
      tr_if.req(AXI_VHD_SET_PROT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_PROT) = '0');
    end set_prot;

    procedure get_prot(prot       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_PROT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_PROT) = '1');
      tr_if.req(AXI_VHD_GET_PROT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_PROT) = '0');
      prot := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_prot;

    procedure set_id(id       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= id;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ID) = '1');
      tr_if.req(AXI_VHD_SET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ID) = '0');
    end set_id;

    procedure set_id(id       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(id, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ID) = '1');
      tr_if.req(AXI_VHD_SET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ID) = '0');
    end set_id;

    procedure get_id(id       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ID) = '1');
      tr_if.req(AXI_VHD_GET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ID) = '0');
      id := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_id;

    procedure get_id(id       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ID) = '1');
      tr_if.req(AXI_VHD_GET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ID) = '0');
      id := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_id;

    procedure set_id(id       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= id;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ID) = '1');
      tr_if.req(AXI_VHD_SET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ID) = '0');
    end set_id;

    procedure set_id(id       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(id, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ID) = '1');
      tr_if.req(AXI_VHD_SET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ID) = '0');
    end set_id;

    procedure get_id(id       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ID) = '1');
      tr_if.req(AXI_VHD_GET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ID) = '0');
      id := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_id;

    procedure get_id(id       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ID) = '1');
      tr_if.req(AXI_VHD_GET_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ID) = '0');
      id := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_id;

    procedure set_burst_length(burst_length       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= burst_length;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_BURST_LENGTH) = '0');
    end set_burst_length;

    procedure set_burst_length(burst_length       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(burst_length, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_BURST_LENGTH) = '0');
    end set_burst_length;

    procedure get_burst_length(burst_length       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_BURST_LENGTH) = '0');
      burst_length := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_burst_length;

    procedure get_burst_length(burst_length       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_BURST_LENGTH) = '0');
      burst_length := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_burst_length;

    procedure set_burst_length(burst_length       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= burst_length;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_BURST_LENGTH) = '0');
    end set_burst_length;

    procedure set_burst_length(burst_length       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(burst_length, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_SET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_BURST_LENGTH) = '0');
    end set_burst_length;

    procedure get_burst_length(burst_length       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_BURST_LENGTH) = '0');
      burst_length := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_burst_length;

    procedure get_burst_length(burst_length       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_BURST_LENGTH) = '1');
      tr_if.req(AXI_VHD_GET_BURST_LENGTH) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_BURST_LENGTH) = '0');
      burst_length := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_burst_length;

    procedure set_data_words(data_words       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= data_words;
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure set_data_words(data_words       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= data_words;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure set_data_words(data_words       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(data_words, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure set_data_words(data_words       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(data_words, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure get_data_words(data_words       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_data_words;

    procedure get_data_words(data_words       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_data_words;

    procedure get_data_words(data_words       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_data_words;

    procedure get_data_words(data_words       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_data_words;

    procedure set_data_words(data_words       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= data_words;
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure set_data_words(data_words       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= data_words;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure set_data_words(data_words       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(data_words, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure set_data_words(data_words       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(data_words, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_SET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_WORDS) = '0');
    end set_data_words;

    procedure get_data_words(data_words       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_data_words;

    procedure get_data_words(data_words       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_data_words;

    procedure get_data_words(data_words       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_data_words;

    procedure get_data_words(data_words       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '1');
      tr_if.req(AXI_VHD_GET_DATA_WORDS) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_WORDS) = '0');
      data_words := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_data_words;

    procedure set_write_strobes(write_strobes       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= write_strobes;
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure set_write_strobes(write_strobes       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= write_strobes;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure set_write_strobes(write_strobes       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(write_strobes, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure set_write_strobes(write_strobes       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(write_strobes, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure get_write_strobes(write_strobes       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_write_strobes;

    procedure get_write_strobes(write_strobes       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_write_strobes;

    procedure get_write_strobes(write_strobes       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_write_strobes;

    procedure get_write_strobes(write_strobes       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_write_strobes;

    procedure set_write_strobes(write_strobes       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= write_strobes;
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure set_write_strobes(write_strobes       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= write_strobes;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure set_write_strobes(write_strobes       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(write_strobes, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure set_write_strobes(write_strobes       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(write_strobes, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_STROBES) = '0');
    end set_write_strobes;

    procedure get_write_strobes(write_strobes       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_write_strobes;

    procedure get_write_strobes(write_strobes       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_write_strobes;

    procedure get_write_strobes(write_strobes       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_write_strobes;

    procedure get_write_strobes(write_strobes       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_STROBES) = '0');
      write_strobes := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_write_strobes;

    procedure set_resp(resp       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= resp;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_RESP) = '1');
      tr_if.req(AXI_VHD_SET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_RESP) = '0');
    end set_resp;

    procedure set_resp(resp       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= resp;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_RESP) = '1');
      tr_if.req(AXI_VHD_SET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_RESP) = '0');
    end set_resp;

    procedure get_resp(resp       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_RESP) = '1');
      tr_if.req(AXI_VHD_GET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_RESP) = '0');
      resp := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_resp;

    procedure get_resp(resp       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_RESP) = '1');
      tr_if.req(AXI_VHD_GET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_RESP) = '0');
      resp := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_resp;

    procedure set_resp(resp       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= resp;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_RESP) = '1');
      tr_if.req(AXI_VHD_SET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_RESP) = '0');
    end set_resp;

    procedure set_resp(resp       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= resp;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_RESP) = '1');
      tr_if.req(AXI_VHD_SET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_RESP) = '0');
    end set_resp;

    procedure get_resp(resp       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_RESP) = '1');
      tr_if.req(AXI_VHD_GET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_RESP) = '0');
      resp := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_resp;

    procedure get_resp(resp       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_RESP) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_RESP) = '1');
      tr_if.req(AXI_VHD_GET_RESP) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_RESP) = '0');
      resp := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_resp;

    procedure set_addr_user(addr_user       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= addr_user;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR_USER) = '0');
    end set_addr_user;

    procedure set_addr_user(addr_user       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(addr_user, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDR_USER) = '0');
    end set_addr_user;

    procedure get_addr_user(addr_user       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR_USER) = '0');
      addr_user := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_addr_user;

    procedure get_addr_user(addr_user       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDR_USER) = '0');
      addr_user := to_integer(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max);
    end get_addr_user;

    procedure set_addr_user(addr_user       : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= addr_user;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR_USER) = '0');
    end set_addr_user;

    procedure set_addr_user(addr_user       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(addr_user, AXI_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_SET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDR_USER) = '0');
    end set_addr_user;

    procedure get_addr_user(addr_user       : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR_USER) = '0');
      addr_user := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_addr_user;

    procedure get_addr_user(addr_user       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR_USER) = '1');
      tr_if.req(AXI_VHD_GET_ADDR_USER) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDR_USER) = '0');
      addr_user := to_integer(axi_tr_if_local(bfm_id)(path_id).value_max);
    end get_addr_user;

    procedure set_read_or_write(read_or_write       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= read_or_write;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_READ_OR_WRITE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_READ_OR_WRITE) = '1');
      tr_if.req(AXI_VHD_SET_READ_OR_WRITE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_READ_OR_WRITE) = '0');
    end set_read_or_write;

    procedure get_read_or_write(read_or_write       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_READ_OR_WRITE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_OR_WRITE) = '1');
      tr_if.req(AXI_VHD_GET_READ_OR_WRITE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_OR_WRITE) = '0');
      read_or_write := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_read_or_write;

    procedure set_read_or_write(read_or_write       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= read_or_write;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_READ_OR_WRITE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_READ_OR_WRITE) = '1');
      tr_if.req(AXI_VHD_SET_READ_OR_WRITE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_READ_OR_WRITE) = '0');
    end set_read_or_write;

    procedure get_read_or_write(read_or_write       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_READ_OR_WRITE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_OR_WRITE) = '1');
      tr_if.req(AXI_VHD_GET_READ_OR_WRITE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_OR_WRITE) = '0');
      read_or_write := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_read_or_write;

    procedure set_address_valid_delay(address_valid_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= address_valid_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDRESS_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDRESS_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_ADDRESS_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDRESS_VALID_DELAY) = '0');
    end set_address_valid_delay;

    procedure get_address_valid_delay(address_valid_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDRESS_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDRESS_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_ADDRESS_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDRESS_VALID_DELAY) = '0');
      address_valid_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_address_valid_delay;

    procedure set_address_valid_delay(address_valid_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= address_valid_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDRESS_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDRESS_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_ADDRESS_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDRESS_VALID_DELAY) = '0');
    end set_address_valid_delay;

    procedure get_address_valid_delay(address_valid_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDRESS_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDRESS_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_ADDRESS_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDRESS_VALID_DELAY) = '0');
      address_valid_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_address_valid_delay;

    procedure set_data_valid_delay(data_valid_delay       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_valid_delay;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '0');
    end set_data_valid_delay;

    procedure set_data_valid_delay(data_valid_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_valid_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '0');
    end set_data_valid_delay;

    procedure get_data_valid_delay(data_valid_delay       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '0');
      data_valid_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_data_valid_delay;

    procedure get_data_valid_delay(data_valid_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '0');
      data_valid_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_data_valid_delay;

    procedure set_data_valid_delay(data_valid_delay       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_valid_delay;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '0');
    end set_data_valid_delay;

    procedure set_data_valid_delay(data_valid_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_valid_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_VALID_DELAY) = '0');
    end set_data_valid_delay;

    procedure get_data_valid_delay(data_valid_delay       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '0');
      data_valid_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_data_valid_delay;

    procedure get_data_valid_delay(data_valid_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_VALID_DELAY) = '0');
      data_valid_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_data_valid_delay;

    procedure set_write_response_valid_delay(write_response_valid_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= write_response_valid_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) = '0');
    end set_write_response_valid_delay;

    procedure get_write_response_valid_delay(write_response_valid_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) = '0');
      write_response_valid_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_write_response_valid_delay;

    procedure set_write_response_valid_delay(write_response_valid_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= write_response_valid_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_RESPONSE_VALID_DELAY) = '0');
    end set_write_response_valid_delay;

    procedure get_write_response_valid_delay(write_response_valid_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_RESPONSE_VALID_DELAY) = '0');
      write_response_valid_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_write_response_valid_delay;

    procedure set_address_ready_delay(address_ready_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= address_ready_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDRESS_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDRESS_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_ADDRESS_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_ADDRESS_READY_DELAY) = '0');
    end set_address_ready_delay;

    procedure get_address_ready_delay(address_ready_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDRESS_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDRESS_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_ADDRESS_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_ADDRESS_READY_DELAY) = '0');
      address_ready_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_address_ready_delay;

    procedure set_address_ready_delay(address_ready_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= address_ready_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_ADDRESS_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDRESS_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_ADDRESS_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_ADDRESS_READY_DELAY) = '0');
    end set_address_ready_delay;

    procedure get_address_ready_delay(address_ready_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_ADDRESS_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDRESS_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_ADDRESS_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_ADDRESS_READY_DELAY) = '0');
      address_ready_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_address_ready_delay;

    procedure set_data_ready_delay(data_ready_delay       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_ready_delay;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_READY_DELAY) = '0');
    end set_data_ready_delay;

    procedure set_data_ready_delay(data_ready_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_ready_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_READY_DELAY) = '0');
    end set_data_ready_delay;

    procedure get_data_ready_delay(data_ready_delay       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_READY_DELAY) = '0');
      data_ready_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_data_ready_delay;

    procedure get_data_ready_delay(data_ready_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_READY_DELAY) = '0');
      data_ready_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_data_ready_delay;

    procedure set_data_ready_delay(data_ready_delay       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_ready_delay;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_READY_DELAY) = '0');
    end set_data_ready_delay;

    procedure set_data_ready_delay(data_ready_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_ready_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_READY_DELAY) = '0');
    end set_data_ready_delay;

    procedure get_data_ready_delay(data_ready_delay       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_READY_DELAY) = '0');
      data_ready_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_data_ready_delay;

    procedure get_data_ready_delay(data_ready_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_DATA_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_READY_DELAY) = '0');
      data_ready_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_data_ready_delay;

    procedure set_write_response_ready_delay(write_response_ready_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= write_response_ready_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) = '0');
    end set_write_response_ready_delay;

    procedure get_write_response_ready_delay(write_response_ready_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) = '0');
      write_response_ready_delay := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_write_response_ready_delay;

    procedure set_write_response_ready_delay(write_response_ready_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= write_response_ready_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_RESPONSE_READY_DELAY) = '0');
    end set_write_response_ready_delay;

    procedure get_write_response_ready_delay(write_response_ready_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_RESPONSE_READY_DELAY) = '0');
      write_response_ready_delay := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_write_response_ready_delay;

    procedure set_gen_write_strobes(gen_write_strobes       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= gen_write_strobes;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_GEN_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_GEN_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_GEN_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_GEN_WRITE_STROBES) = '0');
    end set_gen_write_strobes;

    procedure set_gen_write_strobes(gen_write_strobes       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= gen_write_strobes;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_GEN_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_GEN_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_SET_GEN_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_GEN_WRITE_STROBES) = '0');
    end set_gen_write_strobes;

    procedure get_gen_write_strobes(gen_write_strobes       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_GEN_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_GEN_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_GEN_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_GEN_WRITE_STROBES) = '0');
      gen_write_strobes := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_gen_write_strobes;

    procedure get_gen_write_strobes(gen_write_strobes       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_GEN_WRITE_STROBES) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_GEN_WRITE_STROBES) = '1');
      tr_if.req(AXI_VHD_GET_GEN_WRITE_STROBES) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_GEN_WRITE_STROBES) = '0');
      gen_write_strobes := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_gen_write_strobes;

    procedure set_operation_mode(operation_mode       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= operation_mode;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_OPERATION_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_OPERATION_MODE) = '1');
      tr_if.req(AXI_VHD_SET_OPERATION_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_OPERATION_MODE) = '0');
    end set_operation_mode;

    procedure set_operation_mode(operation_mode       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= operation_mode;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_OPERATION_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_OPERATION_MODE) = '1');
      tr_if.req(AXI_VHD_SET_OPERATION_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_OPERATION_MODE) = '0');
    end set_operation_mode;

    procedure get_operation_mode(operation_mode       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_OPERATION_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_OPERATION_MODE) = '1');
      tr_if.req(AXI_VHD_GET_OPERATION_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_OPERATION_MODE) = '0');
      operation_mode := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_operation_mode;

    procedure get_operation_mode(operation_mode       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_OPERATION_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_OPERATION_MODE) = '1');
      tr_if.req(AXI_VHD_GET_OPERATION_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_OPERATION_MODE) = '0');
      operation_mode := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_operation_mode;

    procedure set_delay_mode(delay_mode       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= delay_mode;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DELAY_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DELAY_MODE) = '1');
      tr_if.req(AXI_VHD_SET_DELAY_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DELAY_MODE) = '0');
    end set_delay_mode;

    procedure set_delay_mode(delay_mode       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= delay_mode;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DELAY_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DELAY_MODE) = '1');
      tr_if.req(AXI_VHD_SET_DELAY_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DELAY_MODE) = '0');
    end set_delay_mode;

    procedure get_delay_mode(delay_mode       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DELAY_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DELAY_MODE) = '1');
      tr_if.req(AXI_VHD_GET_DELAY_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DELAY_MODE) = '0');
      delay_mode := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_delay_mode;

    procedure get_delay_mode(delay_mode       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DELAY_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DELAY_MODE) = '1');
      tr_if.req(AXI_VHD_GET_DELAY_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DELAY_MODE) = '0');
      delay_mode := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_delay_mode;

    procedure set_write_data_mode(write_data_mode       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= write_data_mode;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_DATA_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_DATA_MODE) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_DATA_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_WRITE_DATA_MODE) = '0');
    end set_write_data_mode;

    procedure set_write_data_mode(write_data_mode       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= write_data_mode;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_WRITE_DATA_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_DATA_MODE) = '1');
      tr_if.req(AXI_VHD_SET_WRITE_DATA_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_WRITE_DATA_MODE) = '0');
    end set_write_data_mode;

    procedure get_write_data_mode(write_data_mode       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_MODE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_MODE) = '0');
      write_data_mode := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_write_data_mode;

    procedure get_write_data_mode(write_data_mode       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_MODE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_MODE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_MODE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_MODE) = '0');
      write_data_mode := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_write_data_mode;

    procedure set_data_beat_done(data_beat_done       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_beat_done;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '0');
    end set_data_beat_done;

    procedure set_data_beat_done(data_beat_done       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_beat_done;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '0');
    end set_data_beat_done;

    procedure set_data_beat_done(data_beat_done       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_beat_done;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '0');
    end set_data_beat_done;

    procedure set_data_beat_done(data_beat_done       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data_beat_done;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_SET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_DATA_BEAT_DONE) = '0');
    end set_data_beat_done;

    procedure get_data_beat_done(data_beat_done       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '0');
      data_beat_done := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_data_beat_done;

    procedure get_data_beat_done(data_beat_done       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '0');
      data_beat_done := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_data_beat_done;

    procedure get_data_beat_done(data_beat_done       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '0');
      data_beat_done := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_data_beat_done;

    procedure get_data_beat_done(data_beat_done       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '1');
      tr_if.req(AXI_VHD_GET_DATA_BEAT_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_DATA_BEAT_DONE) = '0');
      data_beat_done := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_data_beat_done;

    procedure set_transaction_done(transaction_done       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= transaction_done;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_TRANSACTION_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_TRANSACTION_DONE) = '1');
      tr_if.req(AXI_VHD_SET_TRANSACTION_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_TRANSACTION_DONE) = '0');
    end set_transaction_done;

    procedure set_transaction_done(transaction_done       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= transaction_done;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI_VHD_SET_TRANSACTION_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_TRANSACTION_DONE) = '1');
      tr_if.req(AXI_VHD_SET_TRANSACTION_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_TRANSACTION_DONE) = '0');
    end set_transaction_done;

    procedure get_transaction_done(transaction_done       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_TRANSACTION_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_TRANSACTION_DONE) = '1');
      tr_if.req(AXI_VHD_GET_TRANSACTION_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_TRANSACTION_DONE) = '0');
      transaction_done := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_transaction_done;

    procedure get_transaction_done(transaction_done       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          path_id        : in axi_path_t;
                          signal tr_if       : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI_VHD_GET_TRANSACTION_DONE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_TRANSACTION_DONE) = '1');
      tr_if.req(AXI_VHD_GET_TRANSACTION_DONE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_TRANSACTION_DONE) = '0');
      transaction_done := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_transaction_done;

    procedure execute_transaction(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_EXECUTE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_TRANSACTION) = '0');
    end execute_transaction;

    procedure execute_transaction(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_EXECUTE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_TRANSACTION) = '0');
    end execute_transaction;

    procedure get_read_data_burst(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_READ_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_GET_READ_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_DATA_BURST) = '0');
    end get_read_data_burst;

    procedure get_read_data_burst(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_READ_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_GET_READ_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_DATA_BURST) = '0');
    end get_read_data_burst;

    procedure execute_write_data_burst(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_DATA_BURST) = '0');
    end execute_write_data_burst;

    procedure execute_write_data_burst(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_DATA_BURST) = '0');
    end execute_write_data_burst;

    procedure execute_read_addr_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_READ_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_ADDR_PHASE) = '0');
    end execute_read_addr_phase;

    procedure execute_read_addr_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_READ_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_ADDR_PHASE) = '0');
    end execute_read_addr_phase;

    procedure get_read_data_phase(transaction_id  : in integer;
                              index           : in  integer; 
                              last            : out integer; 
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_read_data_phase;

    procedure get_read_data_phase(transaction_id  : in integer;
                              index           : in  integer; 
                              last            : out integer; 
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_read_data_phase;

    procedure get_read_data_phase(transaction_id  : in integer;
                              last            : out integer; 
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_read_data_phase;

    procedure get_read_data_phase(transaction_id  : in integer;
                              last            : out integer; 
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_read_data_phase;

    procedure execute_write_addr_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) = '0');
    end execute_write_addr_phase;

    procedure execute_write_addr_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_ADDR_PHASE) = '0');
    end execute_write_addr_phase;

    procedure execute_write_data_phase(transaction_id  : in integer;
                              index           : in  integer; 
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '0');
    end execute_write_data_phase;

    procedure execute_write_data_phase(transaction_id  : in integer;
                              index           : in  integer; 
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '0');
    end execute_write_data_phase;

    procedure execute_write_data_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '0');
    end execute_write_data_phase;

    procedure execute_write_data_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_DATA_PHASE) = '0');
    end execute_write_data_phase;

    procedure get_write_response_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_RESPONSE_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_RESPONSE_PHASE) = '0');
    end get_write_response_phase;

    procedure get_write_response_phase(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              path_id         : in  axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_RESPONSE_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_RESPONSE_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_RESPONSE_PHASE) = '0');
    end get_write_response_phase;

    procedure create_slave_transaction(transaction_id  : out integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_CREATE_SLAVE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_SLAVE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_SLAVE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_SLAVE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_slave_transaction;

    procedure create_slave_transaction(transaction_id  : out integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_CREATE_SLAVE_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_SLAVE_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_SLAVE_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_SLAVE_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_slave_transaction;

    procedure execute_read_data_burst(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_DATA_BURST) = '0');
    end execute_read_data_burst;

    procedure execute_read_data_burst(transaction_id  : in integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_DATA_BURST) = '0');
    end execute_read_data_burst;

    procedure get_write_data_burst(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_BURST) = '0');
    end get_write_data_burst;

    procedure get_write_data_burst(transaction_id  : in integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_BURST) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_BURST) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_BURST) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_BURST) = '0');
    end get_write_data_burst;

    procedure get_read_addr_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_READ_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_READ_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_ADDR_PHASE) = '0');
    end get_read_addr_phase;

    procedure get_read_addr_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_READ_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_READ_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_ADDR_PHASE) = '0');
    end get_read_addr_phase;

    procedure execute_read_data_phase(transaction_id  : in integer;
                              index           : in integer; 
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '0');
    end execute_read_data_phase;

    procedure execute_read_data_phase(transaction_id  : in integer;
                              index           : in integer; 
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '0');
    end execute_read_data_phase;

    procedure execute_read_data_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '0');
    end execute_read_data_phase;

    procedure execute_read_data_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_READ_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_READ_DATA_PHASE) = '0');
    end execute_read_data_phase;

    procedure get_write_addr_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_ADDR_PHASE) = '0');
    end get_write_addr_phase;

    procedure get_write_addr_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_ADDR_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_ADDR_PHASE) = '0');
    end get_write_addr_phase;

    procedure get_write_data_phase(transaction_id  : in integer;
                              index           : in integer; 
                              last            : out integer; 
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_write_data_phase;

    procedure get_write_data_phase(transaction_id  : in integer;
                              index           : in integer; 
                              last            : out integer; 
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_write_data_phase;

    procedure get_write_data_phase(transaction_id  : in integer;
                              last            : out integer; 
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
    end get_write_data_phase;

    procedure get_write_data_phase(transaction_id  : in integer;
                              last            : out integer; 
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_DATA_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_DATA_PHASE) = '0');
      last           := axi_tr_if_local(bfm_id)(path_id).value_0;
    end get_write_data_phase;

    procedure execute_write_response_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) = '0');
    end execute_write_response_phase;

    procedure execute_write_response_phase(transaction_id  : in integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) = '1');
      tr_if.req(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_EXECUTE_WRITE_RESPONSE_PHASE) = '0');
    end execute_write_response_phase;

    procedure create_monitor_transaction(transaction_id  : out integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_CREATE_MONITOR_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_MONITOR_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_MONITOR_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_CREATE_MONITOR_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end create_monitor_transaction;

    procedure create_monitor_transaction(transaction_id  : out integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_CREATE_MONITOR_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_MONITOR_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_CREATE_MONITOR_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_CREATE_MONITOR_TRANSACTION) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end create_monitor_transaction;

    procedure get_rw_transaction(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_RW_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_RW_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_GET_RW_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_RW_TRANSACTION) = '0');
    end get_rw_transaction;

    procedure get_rw_transaction(transaction_id  : in integer;
                              bfm_id          : in integer;
                              path_id         : in axi_path_t; 
                              signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI_VHD_GET_RW_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_RW_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_GET_RW_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_RW_TRANSACTION) = '0');
    end get_rw_transaction;

    procedure push_transaction_id(transaction_id  : in integer;
                                  queue_id        : in integer;
                                  bfm_id          : in integer; 
                                  signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= queue_id;
      tr_if.req(AXI_VHD_PUSH_TRANSACTION_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_PUSH_TRANSACTION_ID) = '1');
      tr_if.req(AXI_VHD_PUSH_TRANSACTION_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_PUSH_TRANSACTION_ID) = '0');
    end push_transaction_id;

    procedure push_transaction_id(transaction_id  : in integer;
                                  queue_id        : in integer;
                                  bfm_id          : in integer; 
                                  path_id         : in axi_path_t; 
                                  signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= queue_id;
      tr_if.req(AXI_VHD_PUSH_TRANSACTION_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_PUSH_TRANSACTION_ID) = '1');
      tr_if.req(AXI_VHD_PUSH_TRANSACTION_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_PUSH_TRANSACTION_ID) = '0');
    end push_transaction_id;

    procedure pop_transaction_id(transaction_id  : out integer;
                                 queue_id        : in integer;
                                 bfm_id          : in integer; 
                                 signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= queue_id;
      tr_if.req(AXI_VHD_POP_TRANSACTION_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_POP_TRANSACTION_ID) = '1');
      tr_if.req(AXI_VHD_POP_TRANSACTION_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_POP_TRANSACTION_ID) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(AXI_PATH_0).transaction_id;
    end pop_transaction_id;

    procedure pop_transaction_id(transaction_id  : out integer;
                                 queue_id        : in integer;
                                 bfm_id          : in integer; 
                                 path_id         : in axi_path_t;
                                 signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= queue_id;
      tr_if.req(AXI_VHD_POP_TRANSACTION_ID) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_POP_TRANSACTION_ID) = '1');
      tr_if.req(AXI_VHD_POP_TRANSACTION_ID) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_POP_TRANSACTION_ID) = '0');
      transaction_id := axi_tr_if_local(bfm_id)(path_id).transaction_id;
    end pop_transaction_id;

    procedure get_write_addr_data(transaction_id  : in integer;
                                  index           : in integer;
                                  byte_index      : in integer;
                                  dynamic_size    : out integer;
                                  addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                  data            : out std_logic_vector(7 downto 0);
                                  bfm_id          : in integer;
                                  signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= index;
      tr_if.value_1 <= byte_index;
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_DATA) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_ADDR_DATA) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_DATA) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_WRITE_ADDR_DATA) = '0');
      dynamic_size := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
      addr := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
      data := conv_std_logic_vector(axi_tr_if_local(bfm_id)(AXI_PATH_0).value_1, 8);
    end get_write_addr_data;

    procedure get_write_addr_data(transaction_id  : in integer;
                                  index           : in integer;
                                  byte_index      : in integer;
                                  dynamic_size    : out integer;
                                  addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                                  data            : out std_logic_vector(7 downto 0);
                                  bfm_id          : in integer;
                                  path_id         : in axi_path_t; 
                                  signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= index;
      tr_if.value_1 <= byte_index;
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_DATA) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_ADDR_DATA) = '1');
      tr_if.req(AXI_VHD_GET_WRITE_ADDR_DATA) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_WRITE_ADDR_DATA) = '0');
      dynamic_size := axi_tr_if_local(bfm_id)(path_id).value_0;
      addr := axi_tr_if_local(bfm_id)(path_id).value_max;
      data := conv_std_logic_vector(axi_tr_if_local(bfm_id)(path_id).value_1, 8);
    end get_write_addr_data;

    procedure get_read_addr(transaction_id  : in integer;
                                  index           : in integer;
                            byte_index      : in integer;
                            dynamic_size    : out integer;
                            addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                            bfm_id          : in integer;
                            signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= index;
      tr_if.value_1 <= byte_index;
      tr_if.req(AXI_VHD_GET_READ_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_ADDR) = '1');
      tr_if.req(AXI_VHD_GET_READ_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_GET_READ_ADDR) = '0');
      dynamic_size := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_0;
      addr := axi_tr_if_local(bfm_id)(AXI_PATH_0).value_max;
    end get_read_addr;

    procedure set_read_data(transaction_id  : in integer;
                                  index           : in integer;
                            byte_index      : in integer;
                            dynamic_size    : in integer;
                            addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                            data            : in std_logic_vector(7 downto 0);
                            bfm_id          : in integer;
                            signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= index;
      tr_if.value_1 <= byte_index;
      tr_if.value_2 <= dynamic_size;
      tr_if.value_max <= addr;
      tr_if.value_3 <= to_integer(data);
      tr_if.req(AXI_VHD_SET_READ_DATA) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_READ_DATA) = '1');
      tr_if.req(AXI_VHD_SET_READ_DATA) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_SET_READ_DATA) = '0');
    end set_read_data;

    procedure get_read_addr(transaction_id  : in integer;
                                  index           : in integer;
                            byte_index      : in integer;
                            dynamic_size    : out integer;
                            addr            : out std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                            bfm_id          : in integer;
                            path_id         : in axi_path_t; 
                            signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= index;
      tr_if.value_1 <= byte_index;
      tr_if.req(AXI_VHD_GET_READ_ADDR) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_ADDR) = '1');
      tr_if.req(AXI_VHD_GET_READ_ADDR) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_GET_READ_ADDR) = '0');
      dynamic_size := axi_tr_if_local(bfm_id)(path_id).value_0;
      addr := axi_tr_if_local(bfm_id)(path_id).value_max;
    end get_read_addr;

    procedure set_read_data(transaction_id  : in integer;
                                  index           : in integer;
                            byte_index      : in integer;
                            dynamic_size    : in integer;
                            addr            : in std_logic_vector(AXI_MAX_BIT_SIZE-1 downto 0);
                            data            : in std_logic_vector(7 downto 0);
                            bfm_id          : in integer;
                            path_id         : in axi_path_t; 
                            signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= index;
      tr_if.value_1 <= byte_index;
      tr_if.value_2 <= dynamic_size;
      tr_if.value_max <= addr;
      tr_if.value_3 <= to_integer(data);
      tr_if.req(AXI_VHD_SET_READ_DATA) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_READ_DATA) = '1');
      tr_if.req(AXI_VHD_SET_READ_DATA) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_SET_READ_DATA) = '0');
    end set_read_data;

    procedure print(transaction_id  : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= 0;
      tr_if.req(AXI_VHD_PRINT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_PRINT) = '1');
      tr_if.req(AXI_VHD_PRINT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_PRINT) = '0');
    end print;

    procedure print(transaction_id  : in integer;
                    print_delays    : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= print_delays;
      tr_if.req(AXI_VHD_PRINT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_PRINT) = '1');
      tr_if.req(AXI_VHD_PRINT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_PRINT) = '0');
    end print;

    procedure print(transaction_id  : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_path_t; 
                    signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= 0;
      tr_if.req(AXI_VHD_PRINT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_PRINT) = '1');
      tr_if.req(AXI_VHD_PRINT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_PRINT) = '0');
    end print;

    procedure print(transaction_id  : in integer;
                    print_delays    : in integer;
                    bfm_id          : in integer;
                    path_id         : in axi_path_t; 
                    signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= print_delays;
      tr_if.req(AXI_VHD_PRINT) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_PRINT) = '1');
      tr_if.req(AXI_VHD_PRINT) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_PRINT) = '0');
    end print;

    procedure destruct_transaction(transaction_id  : in integer;
                                   bfm_id          : in integer;
                                   signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.req(AXI_VHD_DESTRUCT_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_DESTRUCT_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_DESTRUCT_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_DESTRUCT_TRANSACTION) = '0');
    end destruct_transaction;

    procedure destruct_transaction(transaction_id  : in integer;
                                   bfm_id          : in integer;
                                   path_id         : in axi_path_t; 
                                   signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.req(AXI_VHD_DESTRUCT_TRANSACTION) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_DESTRUCT_TRANSACTION) = '1');
      tr_if.req(AXI_VHD_DESTRUCT_TRANSACTION) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_DESTRUCT_TRANSACTION) = '0');
    end destruct_transaction;

    procedure wait_on(phase           : in integer;
                      bfm_id          : in integer;
                      signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= 1;
      tr_if.req(AXI_VHD_WAIT_ON) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_WAIT_ON) = '1');
      tr_if.req(AXI_VHD_WAIT_ON) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_WAIT_ON) = '0');
    end wait_on;

    procedure wait_on(phase           : in integer;
                      count           : in integer;
                      bfm_id          : in integer;
                      signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= count;
      tr_if.req(AXI_VHD_WAIT_ON) <= '1';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_WAIT_ON) = '1');
      tr_if.req(AXI_VHD_WAIT_ON) <= '0';
      wait until (axi_tr_if_local(bfm_id)(AXI_PATH_0).ack(AXI_VHD_WAIT_ON) = '0');
    end wait_on;

    procedure wait_on(phase           : in integer;
                      bfm_id          : in integer;
                      path_id         : in axi_path_t; 
                      signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= 1;
      tr_if.req(AXI_VHD_WAIT_ON) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '1');
      tr_if.req(AXI_VHD_WAIT_ON) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '0');
    end wait_on;

    procedure wait_on(phase           : in integer;
                      count           : in integer;
                      bfm_id          : in integer;
                      path_id         : in axi_path_t; 
                      signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= count;
      tr_if.req(AXI_VHD_WAIT_ON) <= '1';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '1');
      tr_if.req(AXI_VHD_WAIT_ON) <= '0';
      wait until (axi_tr_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '0');
    end wait_on;

    procedure wait_on(phase           : in integer;
                      bfm_id          : in integer;
                      path_id         : in axi_adv_path_t; 
                      signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= 1;
      tr_if.req(AXI_VHD_WAIT_ON) <= '1';
      wait until (axi_tr_adv_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '1');
      tr_if.req(AXI_VHD_WAIT_ON) <= '0';
      wait until (axi_tr_adv_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '0');
    end wait_on;

    procedure wait_on(phase           : in integer;
                      count           : in integer;
                      bfm_id          : in integer;
                      path_id         : in axi_adv_path_t; 
                      signal tr_if    : inout axi_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= count;
      tr_if.req(AXI_VHD_WAIT_ON) <= '1';
      wait until (axi_tr_adv_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '1');
      tr_if.req(AXI_VHD_WAIT_ON) <= '0';
      wait until (axi_tr_adv_if_local(bfm_id)(path_id).ack(AXI_VHD_WAIT_ON) = '0');
    end wait_on;

end mgc_axi_bfm_pkg;
