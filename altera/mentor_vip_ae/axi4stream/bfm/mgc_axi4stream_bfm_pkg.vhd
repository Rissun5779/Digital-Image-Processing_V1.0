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

-- Title: mgc_axi4stream_bfm_pkg
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
package mgc_axi4stream_bfm_pkg is

    -- axi4stream_byte_type_e
    --------------------------------------------------------------------------------
    --  This is used as the <byte_type> argument to the <axi4stream_master_packet>
    --    transaction to indicate the type of the stream.
    -- 
    -- AXI4STREAM_DATA_BYTE       - Data byte when TKEEP = 1 and TSTRB = 1
    -- AXI4STREAM_NULL_BYTE       - Null byte when TKEEP = 0 and TSTRB = 0
    -- AXI4STREAM_POS_BYTE        - Position byte when TKEEP = 1 and TSTRB = 0
    -- AXI4STREAM_ILLEGAL_BYTE    - Illegal combination when TKEEP = 0 and TSTRB = 1
    --  
    --------------------------------------------------------------------------------
    constant AXI4STREAM_DATA_BYTE    : integer := 0;
    constant AXI4STREAM_NULL_BYTE    : integer := 1;
    constant AXI4STREAM_POS_BYTE     : integer := 2;
    constant AXI4STREAM_ILLEGAL_BYTE : integer := 3;

    -- axi4stream_assertion_e
    --------------------------------------------------------------------------------
    --  Type defining the error messages which can be produced by the <mgc_axi4stream> MVC.
    -- 
    -- Individual error messages can be disabled using the <config_enable_assertion> array of configuration bits.
    -- 
    --------------------------------------------------------------------------------
    constant AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_INVALID_LANE : integer := 0;
    constant AXI4STREAM_TDATA_X_ON_INVALID_LANE                     : integer := 1;
    constant AXI4STREAM_TDATA_Z_ON_INVALID_LANE                     : integer := 2;
    constant AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_VALID_LANE   : integer := 3;
    constant AXI4STREAM_TDATA_X_ON_VALID_LANE                       : integer := 4;
    constant AXI4STREAM_TDATA_Z_ON_VALID_LANE                       : integer := 5;
    constant AXI4STREAM_TDEST_CHANGED_BEFORE_TREADY                 : integer := 6;
    constant AXI4STREAM_TDEST_X                                     : integer := 7;
    constant AXI4STREAM_TDEST_Z                                     : integer := 8;
    constant AXI4STREAM_TID_CHANGED_BEFORE_TREADY                   : integer := 9;
    constant AXI4STREAM_TID_X                                       : integer := 10;
    constant AXI4STREAM_TID_Z                                       : integer := 11;
    constant AXI4STREAM_TKEEP_CHANGED_BEFORE_TREADY                 : integer := 12;
    constant AXI4STREAM_TKEEP_X                                     : integer := 13;
    constant AXI4STREAM_TKEEP_Z                                     : integer := 14;
    constant AXI4STREAM_TLAST_CHANGED_BEFORE_TREADY                 : integer := 15;
    constant AXI4STREAM_TLAST_X                                     : integer := 16;
    constant AXI4STREAM_TLAST_Z                                     : integer := 17;
    constant AXI4STREAM_TREADY_X                                    : integer := 18;
    constant AXI4STREAM_TREADY_Z                                    : integer := 19;
    constant AXI4STREAM_TSTRB_CHANGED_BEFORE_TREADY                 : integer := 20;
    constant AXI4STREAM_TSTRB_X                                     : integer := 21;
    constant AXI4STREAM_TSTRB_Z                                     : integer := 22;
    constant AXI4STREAM_TUSER_CHANGED_BEFORE_TREADY                 : integer := 23;
    constant AXI4STREAM_TUSER_X                                     : integer := 24;
    constant AXI4STREAM_TUSER_Z                                     : integer := 25;
    constant AXI4STREAM_TVALID_HIGH_EXITING_RESET                   : integer := 26;
    constant AXI4STREAM_TVALID_HIGH_ON_FIRST_CLOCK                  : integer := 27;
    constant AXI4STREAM_TVALID_CHANGED_BEFORE_TREADY                : integer := 28;
    constant AXI4STREAM_TVALID_X                                    : integer := 29;
    constant AXI4STREAM_TVALID_Z                                    : integer := 30;
    constant AXI4STREAM_DATA_WIDTH_VIOLATION                        : integer := 31;
    constant AXI4STREAM_TDEST_MAX_WIDTH_VIOLATION                   : integer := 32;
    constant AXI4STREAM_TID_MAX_WIDTH_VIOLATION                     : integer := 33;
    constant AXI4STREAM_TUSER_MAX_WIDTH_VIOLATION                   : integer := 34;
    constant AXI4STREAM_AUXM_TID_TDEST_WIDTH                        : integer := 35;
    constant AXI4STREAM_TSTRB_HIGH_WHEN_TKEEP_LOW                   : integer := 36;
    constant AXI4STREAM_TUSER_FIELD_NONZERO_NULL_BYTE               : integer := 37;
    constant AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID            : integer := 38;
    constant AXI4STREAM_INTERNAL_RESERVED                           : integer := 39;


    constant AXI4STREAM_MAX_BIT_SIZE : integer := 1024;

-- enum: axi4stream_config_e
--
-- An enum which fields corresponding to each configuration parameter of the VIP
--    AXI4STREAM_CONFIG_LAST_DURING_IDLE - 
--          Sets the value of TLAST signal during idle.
--         When set to 1'b0 then this indicates that TLAST will be driven 0 during idle.
--         When set to 1'b1 then TLAST will be driven 1 during idle.
--         
--            Default: 0
--         
--    AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS - 
--          Enables all protocol assertions. 
--              
--              Default: 1
--           
--    AXI4STREAM_CONFIG_ENABLE_ASSERTION - 
--         
--             Enables individual protocol assertion.
--             This variable controls whether specific assertion within QVIP (of type <axi4stream_assertion_e>) is enabled or disabled.
--             Individual assertion can be disabled as follows:-
--             //-----------------------------------------------------------------------
--             // < BFM interface>.set_config_enable_assertion_index1(<name of assertion>,1'b0);
--             //-----------------------------------------------------------------------
--             
--             For example, the assertion AXI4STREAM_TLAST_X can be disabled as follows:
--             <bfm>.set_config_enable_assertion_index1(AXI4STREAM_TLAST_X, 1'b0); 
--             
--             Here bfm is the AXI4STREAM interface instance name for which the assertion to be disabled. 
--             
--             Default: All assertions are enabled
--           
--    AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR - 
--          Sets maximum timeout value (in terms of clock) between phases of transaction.
--         
--            Default: 10000 clock cycles.
--         
--    AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY - 
--          
--         Sets maximum timeout period (in terms of clock) from assertion of TVALID to assertion of TREADY.
--         An error message AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID is generated if TREADY is not asserted
--         after assertion of TVALID within this period. 
--         
--         Default: 10000 clock cycles
--         
--    AXI4STREAM_CONFIG_SETUP_TIME - 
--         
--              Sets number of simulation time units from the setup time to the active 
--              clock edge of clock. The setup time will always be less than the time period
--              of the clock. 
--             
--              Default:0
--            
--    AXI4STREAM_CONFIG_HOLD_TIME - 
--         
--              Sets number of simulation time units from the hold time to the active 
--              clock edge of clock. 
--             
--              Default:0
--            
    constant AXI4STREAM_CONFIG_LAST_DURING_IDLE       : std_logic_vector(7 downto 0) := X"00";
    constant AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS  : std_logic_vector(7 downto 0) := X"01";
    constant AXI4STREAM_CONFIG_ENABLE_ASSERTION       : std_logic_vector(7 downto 0) := X"02";
    constant AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR   : std_logic_vector(7 downto 0) := X"03";
    constant AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY : std_logic_vector(7 downto 0) := X"04";
    constant AXI4STREAM_CONFIG_SETUP_TIME             : std_logic_vector(7 downto 0) := X"05";
    constant AXI4STREAM_CONFIG_HOLD_TIME              : std_logic_vector(7 downto 0) := X"06";

    -- axi4stream_vhd_if_e
    constant AXI4STREAM_VHD_SET_CONFIG                         : integer := 0;
    constant AXI4STREAM_VHD_GET_CONFIG                         : integer := 1;
    constant AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION          : integer := 2;
    constant AXI4STREAM_VHD_SET_DATA                           : integer := 3;
    constant AXI4STREAM_VHD_GET_DATA                           : integer := 4;
    constant AXI4STREAM_VHD_SET_BYTE_TYPE                      : integer := 5;
    constant AXI4STREAM_VHD_GET_BYTE_TYPE                      : integer := 6;
    constant AXI4STREAM_VHD_SET_ID                             : integer := 7;
    constant AXI4STREAM_VHD_GET_ID                             : integer := 8;
    constant AXI4STREAM_VHD_SET_DEST                           : integer := 9;
    constant AXI4STREAM_VHD_GET_DEST                           : integer := 10;
    constant AXI4STREAM_VHD_SET_USER_DATA                      : integer := 11;
    constant AXI4STREAM_VHD_GET_USER_DATA                      : integer := 12;
    constant AXI4STREAM_VHD_SET_VALID_DELAY                    : integer := 13;
    constant AXI4STREAM_VHD_GET_VALID_DELAY                    : integer := 14;
    constant AXI4STREAM_VHD_SET_READY_DELAY                    : integer := 15;
    constant AXI4STREAM_VHD_GET_READY_DELAY                    : integer := 16;
    constant AXI4STREAM_VHD_SET_OPERATION_MODE                 : integer := 17;
    constant AXI4STREAM_VHD_GET_OPERATION_MODE                 : integer := 18;
    constant AXI4STREAM_VHD_SET_TRANSFER_DONE                  : integer := 19;
    constant AXI4STREAM_VHD_GET_TRANSFER_DONE                  : integer := 20;
    constant AXI4STREAM_VHD_SET_TRANSACTION_DONE               : integer := 21;
    constant AXI4STREAM_VHD_GET_TRANSACTION_DONE               : integer := 22;
    constant AXI4STREAM_VHD_EXECUTE_TRANSACTION                : integer := 23;
    constant AXI4STREAM_VHD_GET_PACKET                         : integer := 24;
    constant AXI4STREAM_VHD_EXECUTE_TRANSFER                   : integer := 25;
    constant AXI4STREAM_VHD_GET_TRANSFER                       : integer := 26;
    constant AXI4STREAM_VHD_EXECUTE_STREAM_READY               : integer := 27;
    constant AXI4STREAM_VHD_GET_STREAM_READY                   : integer := 28;
    constant AXI4STREAM_VHD_CREATE_MONITOR_TRANSACTION         : integer := 29;
    constant AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION           : integer := 30;
    constant AXI4STREAM_VHD_PUSH_TRANSACTION_ID                : integer := 31;
    constant AXI4STREAM_VHD_POP_TRANSACTION_ID                 : integer := 32;
    constant AXI4STREAM_VHD_PRINT                              : integer := 33;
    constant AXI4STREAM_VHD_DESTRUCT_TRANSACTION               : integer := 34;
    constant AXI4STREAM_VHD_WAIT_ON                            : integer := 35;

    -- axi_wait_e
    constant AXI4STREAM_CLOCK_POSEDGE        : integer := 0;
    constant AXI4STREAM_CLOCK_NEGEDGE        : integer := 1;
    constant AXI4STREAM_CLOCK_ANYEDGE        : integer := 2;
    constant AXI4STREAM_CLOCK_0_TO_1         : integer := 3;
    constant AXI4STREAM_CLOCK_1_TO_0         : integer := 4;
    constant AXI4STREAM_RESET_POSEDGE        : integer := 5;
    constant AXI4STREAM_RESET_NEGEDGE        : integer := 6;
    constant AXI4STREAM_RESET_ANYEDGE        : integer := 7;
    constant AXI4STREAM_RESET_0_TO_1         : integer := 8;
    constant AXI4STREAM_RESET_1_TO_0         : integer := 9;

    -- axi4stream_operation_mode_e
    constant AXI4STREAM_TRANSACTION_NON_BLOCKING : integer := 0;
    constant AXI4STREAM_TRANSACTION_BLOCKING     : integer := 1;


    -- Queue ID
    constant AXI4STREAM_QUEUE_ID_0 : integer := 0;

    -- Parallel path
    type axi4stream_path_t is (
      AXI4STREAM_PATH_0
    );

    -- Global signal record
    type axi4stream_vhd_if_struct_t is record
        req             : std_logic_vector(AXI4STREAM_VHD_WAIT_ON downto 0);
        ack             : std_logic_vector(AXI4STREAM_VHD_WAIT_ON downto 0);
        transaction_id  : integer; 
        value_0         : integer;
        value_1         : integer;
        value_2         : integer;
        value_3         : integer;
        value_max       : std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
    end record;

    -- 512 array of records 
    type axi4stream_tr_if_array_t is array(511 downto 0) of axi4stream_vhd_if_struct_t;
    type axi4stream_tr_if_path_array_t is array(axi4stream_path_t) of axi4stream_vhd_if_struct_t;
    type axi4stream_tr_if_path_2d_array_t is array(511 downto 0) of axi4stream_tr_if_path_array_t;

    -- Global signal passed to each API
    signal axi4stream_tr_if_0              : axi4stream_tr_if_array_t;
    signal axi4stream_tr_if_local          : axi4stream_tr_if_path_2d_array_t;

    -- Helper method to convert to integer
    function to_integer (OP: STD_LOGIC_VECTOR) return INTEGER;

    -- API: Master, Slave, Monitor
    -- This procedure sets the configuration of the BFM.
    procedure set_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : in    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi4stream_vhd_if_struct_t);

    procedure set_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : in    integer;
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- This procedure gets the configuration of the BFM.
    procedure get_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : out   std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi4stream_vhd_if_struct_t);

    procedure get_config(config_name   : in    std_logic_vector(7 downto 0);
                         config_val    : out   integer;
                         bfm_id        : in    integer;
                         signal tr_if  : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- This procedure creates a master transaction.
    procedure create_master_transaction(burst_length    : in integer;
                                       transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi4stream_vhd_if_struct_t);

    procedure create_master_transaction(transaction_id  : out integer;
                                       bfm_id          : in integer;
                                       signal tr_if    : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the data field of the transaction.
    procedure set_data(data                : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_data(data                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the data field of the transaction.
    procedure get_data(data                : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_data(data                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the byte_type field of the transaction.
    procedure set_byte_type(byte_type           : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_byte_type(byte_type           : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the byte_type field of the transaction.
    procedure get_byte_type(byte_type           : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_byte_type(byte_type           : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the id field of the transaction.
    procedure set_id(id                  : in    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_id(id                  : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the id field of the transaction.
    procedure get_id(id                  : out    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_id(id                  : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the dest field of the transaction.
    procedure set_dest(dest                : in    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_dest(dest                : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the dest field of the transaction.
    procedure get_dest(dest                : out    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_dest(dest                : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the user_data field of the transaction.
    procedure set_user_data(user_data           : in    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_user_data(user_data           : in    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_user_data(user_data           : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_user_data(user_data           : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the user_data field of the transaction.
    procedure get_user_data(user_data           : out    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_user_data(user_data           : out    std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0 );
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_user_data(user_data           : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_user_data(user_data           : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the valid_delay field of the transaction.
    procedure set_valid_delay(valid_delay         : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_valid_delay(valid_delay         : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the valid_delay field of the transaction.
    procedure get_valid_delay(valid_delay         : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_valid_delay(valid_delay         : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the ready_delay field of the transaction.
    procedure set_ready_delay(ready_delay         : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_ready_delay(ready_delay         : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the ready_delay field of the transaction.
    procedure get_ready_delay(ready_delay         : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_ready_delay(ready_delay         : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the operation_mode field of the transaction.
    procedure set_operation_mode(operation_mode      : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the operation_mode field of the transaction.
    procedure get_operation_mode(operation_mode      : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Set the transfer_done field of the transaction.
    procedure set_transfer_done(transfer_done       : in    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure set_transfer_done(transfer_done       : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the transfer_done field of the transaction.
    procedure get_transfer_done(transfer_done       : out    integer;
                    index               : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    procedure get_transfer_done(transfer_done       : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave
    -- Set the transaction_done field of the transaction.
    procedure set_transaction_done(transaction_done    : in    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Get the transaction_done field of the transaction.
    procedure get_transaction_done(transaction_done    : out    integer;
                    transaction_id      : in    integer;
                    bfm_id              : in    integer;
                    signal tr_if        : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Execute a transaction defined by the paramters.
    procedure execute_transaction(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Master
    -- Execute a transfer defined by the paramters.
    procedure execute_transfer(transaction_id  : in    integer;
                                     index        : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    procedure execute_transfer(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Monitor
    -- Get a stream_ready defined by the paramters.
    procedure get_stream_ready(ready : out integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Slave
    -- Create a slave_transaction defined by the paramters.
    procedure create_slave_transaction(transaction_id  : out    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Slave, Monitor
    -- Get a transfer defined by the paramters.
    procedure get_transfer(transaction_id  : in    integer;
                                     index        : in    integer;
                                     last         : out   integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    procedure get_transfer(transaction_id  : in    integer;
                                     last         : out   integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Slave
    -- Execute a stream_ready defined by the paramters.
    procedure execute_stream_ready(ready : in integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    procedure execute_stream_ready(ready : in integer;
                                     non_blocking_mode : in integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Monitor
    -- Create a monitor_transaction defined by the paramters.
    procedure create_monitor_transaction(transaction_id  : out    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Monitor
    -- Get a packet defined by the paramters.
    procedure get_packet(transaction_id  : in    integer;
                                     bfm_id       : in    integer;
                                     signal tr_if : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Push the transaction_id into the back of the queue.
    procedure push_transaction_id(transaction_id  : in integer;
                           queue_id        : in integer;
                           bfm_id          : in integer;
                           signal tr_if    : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Pop the transaction_id from the front of the queue.
    procedure pop_transaction_id(transaction_id  : out integer;
                           queue_id        : in integer;
                           bfm_id          : in integer;
                           signal tr_if    : inout axi4stream_vhd_if_struct_t);

    -- API: Master, Slave, Monitor
    -- Print the transaction identified by the transaction_id.
    procedure print( transaction_id  : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi4stream_vhd_if_struct_t );

    procedure print( transaction_id  : in integer;
                    print_delays    : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi4stream_vhd_if_struct_t );

    -- API: Master, Slave, Monitor
    -- Remove and clean up the transaction identified by the transaction_id.
    procedure destruct_transaction( transaction_id  : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi4stream_vhd_if_struct_t );

    -- API: Master, Slave, Monitor
    -- Wait for the event specified by the parameters.
    procedure wait_on( phase           : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi4stream_vhd_if_struct_t );

    procedure wait_on( phase           : in integer;
                    count           : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi4stream_vhd_if_struct_t );

end mgc_axi4stream_bfm_pkg;

-- Procedure implementations:
package body mgc_axi4stream_bfm_pkg is

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
                         config_val  : in std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                         bfm_id       : in integer;
                         signal tr_if : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0   <= to_integer(config_name);
      tr_if.value_max <= config_val;
      tr_if.req(AXI4STREAM_VHD_SET_CONFIG) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_CONFIG) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_CONFIG) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_CONFIG) = '0');
    end set_config;

    procedure set_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : in integer;
                         bfm_id       : in integer;
                         signal tr_if : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0   <= to_integer(config_name);
      tr_if.value_max <= conv_std_logic_vector(config_val, AXI4STREAM_MAX_BIT_SIZE);
      tr_if.req(AXI4STREAM_VHD_SET_CONFIG) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_CONFIG) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_CONFIG) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_CONFIG) = '0');
    end set_config;

    procedure get_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : out std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                         bfm_id       : in integer;
                         signal tr_if : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= to_integer(config_name);
      tr_if.req(AXI4STREAM_VHD_GET_CONFIG) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_CONFIG) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_CONFIG) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_CONFIG) = '0');
      config_val := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max;
    end get_config;

    procedure get_config(config_name : in std_logic_vector(7 downto 0);
                         config_val  : out integer;
                         bfm_id       : in integer;
                         signal tr_if : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= to_integer(config_name);
      tr_if.req(AXI4STREAM_VHD_GET_CONFIG) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_CONFIG) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_CONFIG) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_CONFIG) = '0');
      config_val := to_integer(axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max);
    end get_config;

    procedure create_master_transaction(burst_length  : in integer;
                         transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0     <= burst_length;
      tr_if.req(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) = '1');
      tr_if.req(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) = '0');
      transaction_id := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).transaction_id;
    end create_master_transaction;

    procedure create_master_transaction(transaction_id : out integer;
                         bfm_id         : in  integer;
                         signal tr_if : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0     <= 1;
      tr_if.req(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) = '1');
      tr_if.req(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION) = '0');
      transaction_id := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).transaction_id;
    end create_master_transaction;

    procedure set_data(data       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DATA) = '0');
    end set_data;

    procedure set_data(data       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= data;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DATA) = '0');
    end set_data;

    procedure get_data(data       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DATA) = '0');
      data := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_data;

    procedure get_data(data       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DATA) = '0');
      data := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_data;

    procedure set_byte_type(byte_type       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= byte_type;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_BYTE_TYPE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_BYTE_TYPE) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_BYTE_TYPE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_BYTE_TYPE) = '0');
    end set_byte_type;

    procedure set_byte_type(byte_type       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= byte_type;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_BYTE_TYPE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_BYTE_TYPE) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_BYTE_TYPE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_BYTE_TYPE) = '0');
    end set_byte_type;

    procedure get_byte_type(byte_type       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_BYTE_TYPE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_BYTE_TYPE) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_BYTE_TYPE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_BYTE_TYPE) = '0');
      byte_type := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_byte_type;

    procedure get_byte_type(byte_type       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_BYTE_TYPE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_BYTE_TYPE) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_BYTE_TYPE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_BYTE_TYPE) = '0');
      byte_type := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_byte_type;

    procedure set_id(id       : in std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= id;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_ID) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_ID) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_ID) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_ID) = '0');
    end set_id;

    procedure set_id(id       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(id, AXI4STREAM_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_ID) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_ID) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_ID) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_ID) = '0');
    end set_id;

    procedure get_id(id       : out std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_ID) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_ID) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_ID) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_ID) = '0');
      id := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max;
    end get_id;

    procedure get_id(id       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_ID) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_ID) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_ID) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_ID) = '0');
      id := to_integer(axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max);
    end get_id;

    procedure set_dest(dest       : in std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= dest;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_DEST) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DEST) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_DEST) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DEST) = '0');
    end set_dest;

    procedure set_dest(dest       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(dest, AXI4STREAM_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_DEST) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DEST) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_DEST) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_DEST) = '0');
    end set_dest;

    procedure get_dest(dest       : out std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_DEST) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DEST) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_DEST) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DEST) = '0');
      dest := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max;
    end get_dest;

    procedure get_dest(dest       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_DEST) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DEST) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_DEST) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_DEST) = '0');
      dest := to_integer(axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max);
    end get_dest;

    procedure set_user_data(user_data       : in std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= user_data;
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '0');
    end set_user_data;

    procedure set_user_data(user_data       : in std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= user_data;
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '0');
    end set_user_data;

    procedure set_user_data(user_data       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(user_data, AXI4STREAM_MAX_BIT_SIZE);
      tr_if.value_0         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '0');
    end set_user_data;

    procedure set_user_data(user_data       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_max       <= conv_std_logic_vector(user_data, AXI4STREAM_MAX_BIT_SIZE);
      tr_if.value_0         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_USER_DATA) = '0');
    end set_user_data;

    procedure get_user_data(user_data       : out std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '0');
      user_data := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max;
    end get_user_data;

    procedure get_user_data(user_data       : out std_logic_vector(AXI4STREAM_MAX_BIT_SIZE-1 downto 0);
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '0');
      user_data := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max;
    end get_user_data;

    procedure get_user_data(user_data       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '0');
      user_data := to_integer(axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max);
    end get_user_data;

    procedure get_user_data(user_data       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_USER_DATA) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_USER_DATA) = '0');
      user_data := to_integer(axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_max);
    end get_user_data;

    procedure set_valid_delay(valid_delay       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= valid_delay;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_VALID_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_VALID_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_VALID_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_VALID_DELAY) = '0');
    end set_valid_delay;

    procedure set_valid_delay(valid_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= valid_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_VALID_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_VALID_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_VALID_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_VALID_DELAY) = '0');
    end set_valid_delay;

    procedure get_valid_delay(valid_delay       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_VALID_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_VALID_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_VALID_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_VALID_DELAY) = '0');
      valid_delay := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_valid_delay;

    procedure get_valid_delay(valid_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_VALID_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_VALID_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_VALID_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_VALID_DELAY) = '0');
      valid_delay := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_valid_delay;

    procedure set_ready_delay(ready_delay       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= ready_delay;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_READY_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_READY_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_READY_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_READY_DELAY) = '0');
    end set_ready_delay;

    procedure set_ready_delay(ready_delay       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= ready_delay;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_READY_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_READY_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_READY_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_READY_DELAY) = '0');
    end set_ready_delay;

    procedure get_ready_delay(ready_delay       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_READY_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_READY_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_READY_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_READY_DELAY) = '0');
      ready_delay := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_ready_delay;

    procedure get_ready_delay(ready_delay       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_READY_DELAY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_READY_DELAY) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_READY_DELAY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_READY_DELAY) = '0');
      ready_delay := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_ready_delay;

    procedure set_operation_mode(operation_mode       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= operation_mode;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_OPERATION_MODE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_OPERATION_MODE) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_OPERATION_MODE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_OPERATION_MODE) = '0');
    end set_operation_mode;

    procedure get_operation_mode(operation_mode       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_OPERATION_MODE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_OPERATION_MODE) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_OPERATION_MODE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_OPERATION_MODE) = '0');
      operation_mode := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_operation_mode;

    procedure set_transfer_done(transfer_done       : in integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= transfer_done;
      tr_if.value_1         <= index;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_TRANSFER_DONE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_TRANSFER_DONE) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_TRANSFER_DONE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_TRANSFER_DONE) = '0');
    end set_transfer_done;

    procedure set_transfer_done(transfer_done       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= transfer_done;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_TRANSFER_DONE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_TRANSFER_DONE) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_TRANSFER_DONE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_TRANSFER_DONE) = '0');
    end set_transfer_done;

    procedure get_transfer_done(transfer_done       : out integer;
                          index          : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= index;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER_DONE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER_DONE) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER_DONE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER_DONE) = '0');
      transfer_done := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_transfer_done;

    procedure get_transfer_done(transfer_done       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER_DONE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER_DONE) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER_DONE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER_DONE) = '0');
      transfer_done := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_transfer_done;

    procedure set_transaction_done(transaction_done       : in integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0         <= transaction_done;
      tr_if.value_1         <= 0;
      tr_if.transaction_id  <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_SET_TRANSACTION_DONE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_TRANSACTION_DONE) = '1');
      tr_if.req(AXI4STREAM_VHD_SET_TRANSACTION_DONE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_SET_TRANSACTION_DONE) = '0');
    end set_transaction_done;

    procedure get_transaction_done(transaction_done       : out integer;
                          transaction_id : in integer;
                          bfm_id         : in integer;
                          signal tr_if       : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0              <= 0;
      tr_if.transaction_id       <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_GET_TRANSACTION_DONE) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSACTION_DONE) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_TRANSACTION_DONE) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSACTION_DONE) = '0');
      transaction_done := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_transaction_done;

    procedure execute_transaction(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI4STREAM_VHD_EXECUTE_TRANSACTION) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_TRANSACTION) = '1');
      tr_if.req(AXI4STREAM_VHD_EXECUTE_TRANSACTION) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_TRANSACTION) = '0');
    end execute_transaction;

    procedure execute_transfer(transaction_id  : in integer;
                              index           : in  integer; 
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI4STREAM_VHD_EXECUTE_TRANSFER) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_TRANSFER) = '1');
      tr_if.req(AXI4STREAM_VHD_EXECUTE_TRANSFER) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_TRANSFER) = '0');
    end execute_transfer;

    procedure execute_transfer(transaction_id  : in integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI4STREAM_VHD_EXECUTE_TRANSFER) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_TRANSFER) = '1');
      tr_if.req(AXI4STREAM_VHD_EXECUTE_TRANSFER) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_TRANSFER) = '0');
    end execute_transfer;

    procedure get_stream_ready(ready : out integer;
                              bfm_id          : in  integer; 
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.req(AXI4STREAM_VHD_GET_STREAM_READY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_STREAM_READY) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_STREAM_READY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_STREAM_READY) = '0');
      ready := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_stream_ready;

    procedure create_slave_transaction(transaction_id  : out integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= 0;
      tr_if.req(AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION) = '1');
      tr_if.req(AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION) = '0');
      transaction_id := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).transaction_id;
    end create_slave_transaction;

    procedure get_transfer(transaction_id  : in integer;
                              index           : in integer; 
                              last            : out integer; 
                              bfm_id          : in integer;
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= index;
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER) = '0');
      last           := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_transfer;

    procedure get_transfer(transaction_id  : in integer;
                              last            : out integer; 
                              bfm_id          : in integer;
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_TRANSFER) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_TRANSFER) = '0');
      last           := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).value_0;
    end get_transfer;

    procedure execute_stream_ready(ready : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= ready;
      tr_if.value_1        <= 0;
      tr_if.req(AXI4STREAM_VHD_EXECUTE_STREAM_READY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_STREAM_READY) = '1');
      tr_if.req(AXI4STREAM_VHD_EXECUTE_STREAM_READY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_STREAM_READY) = '0');
    end execute_stream_ready;

    procedure execute_stream_ready(ready : in integer;
                              non_blocking_mode : in integer; 
                              bfm_id          : in integer;
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= ready;
      tr_if.value_1        <= non_blocking_mode;
      tr_if.req(AXI4STREAM_VHD_EXECUTE_STREAM_READY) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_STREAM_READY) = '1');
      tr_if.req(AXI4STREAM_VHD_EXECUTE_STREAM_READY) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_EXECUTE_STREAM_READY) = '0');
    end execute_stream_ready;

    procedure create_monitor_transaction(transaction_id  : out integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0        <= 0;
      tr_if.req(AXI4STREAM_VHD_CREATE_MONITOR_TRANSACTION) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_MONITOR_TRANSACTION) = '1');
      tr_if.req(AXI4STREAM_VHD_CREATE_MONITOR_TRANSACTION) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_CREATE_MONITOR_TRANSACTION) = '0');
      transaction_id := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).transaction_id;
    end create_monitor_transaction;

    procedure get_packet(transaction_id  : in integer;
                              bfm_id          : in integer;
                              signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0        <= 0;
      tr_if.req(AXI4STREAM_VHD_GET_PACKET) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_PACKET) = '1');
      tr_if.req(AXI4STREAM_VHD_GET_PACKET) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_GET_PACKET) = '0');
    end get_packet;

    procedure push_transaction_id(transaction_id  : in integer;
                                  queue_id        : in integer;
                                  bfm_id          : in integer; 
                                  signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= queue_id;
      tr_if.req(AXI4STREAM_VHD_PUSH_TRANSACTION_ID) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_PUSH_TRANSACTION_ID) = '1');
      tr_if.req(AXI4STREAM_VHD_PUSH_TRANSACTION_ID) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_PUSH_TRANSACTION_ID) = '0');
    end push_transaction_id;

    procedure pop_transaction_id(transaction_id  : out integer;
                                 queue_id        : in integer;
                                 bfm_id          : in integer; 
                                 signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= queue_id;
      tr_if.req(AXI4STREAM_VHD_POP_TRANSACTION_ID) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_POP_TRANSACTION_ID) = '1');
      tr_if.req(AXI4STREAM_VHD_POP_TRANSACTION_ID) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_POP_TRANSACTION_ID) = '0');
      transaction_id := axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).transaction_id;
    end pop_transaction_id;

    procedure print(transaction_id  : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= 0;
      tr_if.req(AXI4STREAM_VHD_PRINT) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_PRINT) = '1');
      tr_if.req(AXI4STREAM_VHD_PRINT) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_PRINT) = '0');
    end print;

    procedure print(transaction_id  : in integer;
                    print_delays    : in integer;
                    bfm_id          : in integer;
                    signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.value_0 <= print_delays;
      tr_if.req(AXI4STREAM_VHD_PRINT) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_PRINT) = '1');
      tr_if.req(AXI4STREAM_VHD_PRINT) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_PRINT) = '0');
    end print;

    procedure destruct_transaction(transaction_id  : in integer;
                                   bfm_id          : in integer;
                                   signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.transaction_id <= transaction_id;
      tr_if.req(AXI4STREAM_VHD_DESTRUCT_TRANSACTION) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_DESTRUCT_TRANSACTION) = '1');
      tr_if.req(AXI4STREAM_VHD_DESTRUCT_TRANSACTION) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_DESTRUCT_TRANSACTION) = '0');
    end destruct_transaction;

    procedure wait_on(phase           : in integer;
                      bfm_id          : in integer;
                      signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= 1;
      tr_if.req(AXI4STREAM_VHD_WAIT_ON) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_WAIT_ON) = '1');
      tr_if.req(AXI4STREAM_VHD_WAIT_ON) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_WAIT_ON) = '0');
    end wait_on;

    procedure wait_on(phase           : in integer;
                      count           : in integer;
                      bfm_id          : in integer;
                      signal tr_if    : inout axi4stream_vhd_if_struct_t) is
    begin
      tr_if.value_0 <= phase;
      tr_if.value_1 <= count;
      tr_if.req(AXI4STREAM_VHD_WAIT_ON) <= '1';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_WAIT_ON) = '1');
      tr_if.req(AXI4STREAM_VHD_WAIT_ON) <= '0';
      wait until (axi4stream_tr_if_local(bfm_id)(AXI4STREAM_PATH_0).ack(AXI4STREAM_VHD_WAIT_ON) = '0');
    end wait_on;

end mgc_axi4stream_bfm_pkg;
