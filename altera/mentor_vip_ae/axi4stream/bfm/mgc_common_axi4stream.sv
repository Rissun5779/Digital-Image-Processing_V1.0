// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20160107
// *****************************************************************************

// Title: axi4stream_top
//

package mgc_axi4stream_pkg;
import QUESTA_MVC::*;

`ifdef MODEL_TECH
// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20160107
// *****************************************************************************

// Title: AXI4STREAM Enumeration Types
//

//------------------------------------------------------------------------------
//
// Enum: axi4stream_byte_type_e
//
//------------------------------------------------------------------------------
//  This is used as the <byte_type> argument to the <axi4stream_master_packet>
//    transaction to indicate the type of the stream.
// 
// AXI4STREAM_DATA_BYTE       - Data byte when TKEEP = 1 and TSTRB = 1
// AXI4STREAM_NULL_BYTE       - Null byte when TKEEP = 0 and TSTRB = 0
// AXI4STREAM_POS_BYTE        - Position byte when TKEEP = 1 and TSTRB = 0
// AXI4STREAM_ILLEGAL_BYTE    - Illegal combination when TKEEP = 0 and TSTRB = 1
//  
typedef enum bit [1:0]
{
    AXI4STREAM_DATA_BYTE    = 2'h0,
    AXI4STREAM_NULL_BYTE    = 2'h1,
    AXI4STREAM_POS_BYTE     = 2'h2,
    AXI4STREAM_ILLEGAL_BYTE = 2'h3
} axi4stream_byte_type_e;



//------------------------------------------------------------------------------
//
// Enum: axi4stream_assertion_e
//
//------------------------------------------------------------------------------
//  Type defining the error messages which can be produced by the <mgc_axi4stream> Questa Verification IP.
// 
// Individual error messages can be disabled using the <config_enable_assertion> array of configuration bits.
// 
// AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_INVALID_LANE -  60000 -  On an invalid byte lane (TSTRB = 0) the value of TDATA has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TDATA_X_ON_INVALID_LANE                     -  60001 -  On an invalid byte lane (TSTRB = 0), TDATA has an X value.
// AXI4STREAM_TDATA_Z_ON_INVALID_LANE                     -  60002 -  On an invalid byte lane (TSTRB = 0), TDATA has a Z value.
// AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_VALID_LANE   -  60003 -  On a valid byte lane (TSTRB = 1) the value of TDATA has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TDATA_X_ON_VALID_LANE                       -  60004 -  On a valid byte lane (TSTRB = 1), TDATA has an X value.
// AXI4STREAM_TDATA_Z_ON_VALID_LANE                       -  60005 -  On a valid byte lane (TSTRB = 1), TDATA has a Z value.
// AXI4STREAM_TDEST_CHANGED_BEFORE_TREADY                 -  60006 -  The value of TDEST has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TDEST_X                                     -  60007 -  TDEST has an X value.
// AXI4STREAM_TDEST_Z                                     -  60008 -  TDEST has a Z value.
// AXI4STREAM_TID_CHANGED_BEFORE_TREADY                   -  60009 -  The value of TID has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TID_X                                       -  60010 -  TID has an X value.
// AXI4STREAM_TID_Z                                       -  60011 -  TID has a Z value.
// AXI4STREAM_TKEEP_CHANGED_BEFORE_TREADY                 -  60012 -  The value of TKEEP has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TKEEP_X                                     -  60013 -  TID has an X value.
// AXI4STREAM_TKEEP_Z                                     -  60014 -  TID has a Z value.
// AXI4STREAM_TLAST_CHANGED_BEFORE_TREADY                 -  60015 -  The value of TLAST has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TLAST_X                                     -  60016 -  TLAST has an X value.
// AXI4STREAM_TLAST_Z                                     -  60017 -  TLAST has a Z value.
// AXI4STREAM_TREADY_X                                    -  60018 -  TREADY has an X value.
// AXI4STREAM_TREADY_Z                                    -  60019 -  TREADY has a Z value.
// AXI4STREAM_TSTRB_CHANGED_BEFORE_TREADY                 -  60020 -  The value of TSTRB has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TSTRB_X                                     -  60021 -  TSTRB has an X value.
// AXI4STREAM_TSTRB_Z                                     -  60022 -  TSTRB has a Z value.
// AXI4STREAM_TUSER_CHANGED_BEFORE_TREADY                 -  60023 -  The value of TUSER has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TUSER_X                                     -  60024 -  TUSER has an X value.
// AXI4STREAM_TUSER_Z                                     -  60025 -  TUSER has a Z value.
// AXI4STREAM_TVALID_HIGH_EXITING_RESET                   -  60026 -  TVALID should have been driven low when exiting reset (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.7.2).
// AXI4STREAM_TVALID_HIGH_ON_FIRST_CLOCK                  -  60027 -  A master interface must only begin driving TVALID at a rising edge of ACLK following a rising edge of ACLK at which TRESETn is de-asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.7.2).
// AXI4STREAM_TVALID_CHANGED_BEFORE_TREADY                -  60028 -  The value of TVALID has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TVALID_X                                    -  60029 -  TVALID has an X value.
// AXI4STREAM_TVALID_Z                                    -  60030 -  TVALID has a Z value.
// AXI4STREAM_DATA_WIDTH_VIOLATION                        -  60031 -  The data bus width of axi4 stream interface must be an integer number of bytes. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_TDEST_MAX_WIDTH_VIOLATION                   -  60032 -  The recommended width of TDEST on axi4 stream interface must be less than 4-bits. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_TID_MAX_WIDTH_VIOLATION                     -  60033 -  The recommended width of TID on axi4 stream interface must be less than 8-bits. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_TUSER_MAX_WIDTH_VIOLATION                   -  60034 -  The recommended width of TUSER on axi4 stream interface must be an integer multiplication of data bus width in bytes. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_AUXM_TID_TDEST_WIDTH                        -  60035 -  The value of AXI4STREAM_ID_WIDTH + AXI4STREAM_DEST_WIDTH must not exceed 24. See ARM AXI4STREAM Protcol Compliance checkers.
// AXI4STREAM_TSTRB_HIGH_WHEN_TKEEP_LOW                   -  60036 -  The combination of TSTRB HIGH and TKEEP LOW is a reserved value. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.3.4)
// AXI4STREAM_TUSER_FIELD_NONZERO_NULL_BYTE               -  60037 -  If a null byte is inserted then appropriate number of user bits must also be inserted, which must be fixed LOW. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.8)
// AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID            -  60038 -  Once TVALID has been asserted, ARREADY should be asserted within config_max_latency_TVALID_assertion_to_TREADY clock periods
// AXI4STREAM_INTERNAL_RESERVED                           -  60039 -  A value reserved for internal purposes of the BFM.
typedef enum bit [7:0]
{
    AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_INVALID_LANE = 8'h00,
    AXI4STREAM_TDATA_X_ON_INVALID_LANE                     = 8'h01,
    AXI4STREAM_TDATA_Z_ON_INVALID_LANE                     = 8'h02,
    AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_VALID_LANE   = 8'h03,
    AXI4STREAM_TDATA_X_ON_VALID_LANE                       = 8'h04,
    AXI4STREAM_TDATA_Z_ON_VALID_LANE                       = 8'h05,
    AXI4STREAM_TDEST_CHANGED_BEFORE_TREADY                 = 8'h06,
    AXI4STREAM_TDEST_X                                     = 8'h07,
    AXI4STREAM_TDEST_Z                                     = 8'h08,
    AXI4STREAM_TID_CHANGED_BEFORE_TREADY                   = 8'h09,
    AXI4STREAM_TID_X                                       = 8'h0a,
    AXI4STREAM_TID_Z                                       = 8'h0b,
    AXI4STREAM_TKEEP_CHANGED_BEFORE_TREADY                 = 8'h0c,
    AXI4STREAM_TKEEP_X                                     = 8'h0d,
    AXI4STREAM_TKEEP_Z                                     = 8'h0e,
    AXI4STREAM_TLAST_CHANGED_BEFORE_TREADY                 = 8'h0f,
    AXI4STREAM_TLAST_X                                     = 8'h10,
    AXI4STREAM_TLAST_Z                                     = 8'h11,
    AXI4STREAM_TREADY_X                                    = 8'h12,
    AXI4STREAM_TREADY_Z                                    = 8'h13,
    AXI4STREAM_TSTRB_CHANGED_BEFORE_TREADY                 = 8'h14,
    AXI4STREAM_TSTRB_X                                     = 8'h15,
    AXI4STREAM_TSTRB_Z                                     = 8'h16,
    AXI4STREAM_TUSER_CHANGED_BEFORE_TREADY                 = 8'h17,
    AXI4STREAM_TUSER_X                                     = 8'h18,
    AXI4STREAM_TUSER_Z                                     = 8'h19,
    AXI4STREAM_TVALID_HIGH_EXITING_RESET                   = 8'h1a,
    AXI4STREAM_TVALID_HIGH_ON_FIRST_CLOCK                  = 8'h1b,
    AXI4STREAM_TVALID_CHANGED_BEFORE_TREADY                = 8'h1c,
    AXI4STREAM_TVALID_X                                    = 8'h1d,
    AXI4STREAM_TVALID_Z                                    = 8'h1e,
    AXI4STREAM_DATA_WIDTH_VIOLATION                        = 8'h1f,
    AXI4STREAM_TDEST_MAX_WIDTH_VIOLATION                   = 8'h20,
    AXI4STREAM_TID_MAX_WIDTH_VIOLATION                     = 8'h21,
    AXI4STREAM_TUSER_MAX_WIDTH_VIOLATION                   = 8'h22,
    AXI4STREAM_AUXM_TID_TDEST_WIDTH                        = 8'h23,
    AXI4STREAM_TSTRB_HIGH_WHEN_TKEEP_LOW                   = 8'h24,
    AXI4STREAM_TUSER_FIELD_NONZERO_NULL_BYTE               = 8'h25,
    AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID            = 8'h26,
    AXI4STREAM_INTERNAL_RESERVED                           = 8'h27
} axi4stream_assertion_e;



typedef bit [1023:0] axi4stream_max_bits_t;

// enum: axi4stream_config_e
//
// An enum which fields corresponding to each configuration parameter of the VIP
//    AXI4STREAM_CONFIG_LAST_DURING_IDLE - 
//          Sets the value of TLAST signal during idle.
//         When set to 1'b0 then this indicates that TLAST will be driven 0 during idle.
//         When set to 1'b1 then TLAST will be driven 1 during idle.
//         
//            Default: 0
//         
//    AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS - 
//          Enables all protocol assertions. 
//              
//              Default: 1
//           
//    AXI4STREAM_CONFIG_ENABLE_ASSERTION - 
//         
//             Enables individual protocol assertion.
//             This variable controls whether specific assertion within QVIP (of type <axi4stream_assertion_e>) is enabled or disabled.
//             Individual assertion can be disabled as follows:-
//             //-----------------------------------------------------------------------
//             // < BFM interface>.set_config_enable_assertion_index1(<name of assertion>,1'b0);
//             //-----------------------------------------------------------------------
//             
//             For example, the assertion AXI4STREAM_TLAST_X can be disabled as follows:
//             <bfm>.set_config_enable_assertion_index1(AXI4STREAM_TLAST_X, 1'b0); 
//             
//             Here bfm is the AXI4STREAM interface instance name for which the assertion to be disabled. 
//             
//             Default: All assertions are enabled
//           
//    AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR - 
//          Sets maximum timeout value (in terms of clock) between phases of transaction.
//         
//            Default: 10000 clock cycles.
//         
//    AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY - 
//          
//         Sets maximum timeout period (in terms of clock) from assertion of TVALID to assertion of TREADY.
//         An error message AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID is generated if TREADY is not asserted
//         after assertion of TVALID within this period. 
//         
//         Default: 10000 clock cycles
//         
//    AXI4STREAM_CONFIG_SETUP_TIME - 
//         
//              Sets number of simulation time units from the setup time to the active 
//              clock edge of clock. The setup time will always be less than the time period
//              of the clock. 
//             
//              Default:0
//            
//    AXI4STREAM_CONFIG_HOLD_TIME - 
//         
//              Sets number of simulation time units from the hold time to the active 
//              clock edge of clock. 
//             
//              Default:0
//            

typedef enum bit [7:0]
{
    AXI4STREAM_CONFIG_LAST_DURING_IDLE       = 8'd0,
    AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS  = 8'd1,
    AXI4STREAM_CONFIG_ENABLE_ASSERTION       = 8'd2,
    AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR   = 8'd3,
    AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY = 8'd4,
    AXI4STREAM_CONFIG_SETUP_TIME             = 8'd5,
    AXI4STREAM_CONFIG_HOLD_TIME              = 8'd6
} axi4stream_config_e;

// enum: axi4stream_vhd_if_e
//
// For VHDL use only
typedef enum int
{
    AXI4STREAM_VHD_SET_CONFIG                         = 32'd0,
    AXI4STREAM_VHD_GET_CONFIG                         = 32'd1,
    AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION          = 32'd2,
    AXI4STREAM_VHD_SET_DATA                           = 32'd3,
    AXI4STREAM_VHD_GET_DATA                           = 32'd4,
    AXI4STREAM_VHD_SET_BYTE_TYPE                      = 32'd5,
    AXI4STREAM_VHD_GET_BYTE_TYPE                      = 32'd6,
    AXI4STREAM_VHD_SET_ID                             = 32'd7,
    AXI4STREAM_VHD_GET_ID                             = 32'd8,
    AXI4STREAM_VHD_SET_DEST                           = 32'd9,
    AXI4STREAM_VHD_GET_DEST                           = 32'd10,
    AXI4STREAM_VHD_SET_USER_DATA                      = 32'd11,
    AXI4STREAM_VHD_GET_USER_DATA                      = 32'd12,
    AXI4STREAM_VHD_SET_VALID_DELAY                    = 32'd13,
    AXI4STREAM_VHD_GET_VALID_DELAY                    = 32'd14,
    AXI4STREAM_VHD_SET_READY_DELAY                    = 32'd15,
    AXI4STREAM_VHD_GET_READY_DELAY                    = 32'd16,
    AXI4STREAM_VHD_SET_OPERATION_MODE                 = 32'd17,
    AXI4STREAM_VHD_GET_OPERATION_MODE                 = 32'd18,
    AXI4STREAM_VHD_SET_TRANSFER_DONE                  = 32'd19,
    AXI4STREAM_VHD_GET_TRANSFER_DONE                  = 32'd20,
    AXI4STREAM_VHD_SET_TRANSACTION_DONE               = 32'd21,
    AXI4STREAM_VHD_GET_TRANSACTION_DONE               = 32'd22,
    AXI4STREAM_VHD_EXECUTE_TRANSACTION                = 32'd23,
    AXI4STREAM_VHD_GET_PACKET                         = 32'd24,
    AXI4STREAM_VHD_EXECUTE_TRANSFER                   = 32'd25,
    AXI4STREAM_VHD_GET_TRANSFER                       = 32'd26,
    AXI4STREAM_VHD_EXECUTE_STREAM_READY               = 32'd27,
    AXI4STREAM_VHD_GET_STREAM_READY                   = 32'd28,
    AXI4STREAM_VHD_CREATE_MONITOR_TRANSACTION         = 32'd29,
    AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION           = 32'd30,
    AXI4STREAM_VHD_PUSH_TRANSACTION_ID                = 32'd31,
    AXI4STREAM_VHD_POP_TRANSACTION_ID                 = 32'd32,
    AXI4STREAM_VHD_PRINT                              = 32'd33,
    AXI4STREAM_VHD_DESTRUCT_TRANSACTION               = 32'd34,
    AXI4STREAM_VHD_WAIT_ON                            = 32'd35
} axi4stream_vhd_if_e;


typedef enum bit [7:0]
{
    AXI4STREAM_CLOCK_POSEDGE = 8'd0,
    AXI4STREAM_CLOCK_NEGEDGE = 8'd1,
    AXI4STREAM_CLOCK_ANYEDGE = 8'd2,
    AXI4STREAM_CLOCK_0_TO_1  = 8'd3,
    AXI4STREAM_CLOCK_1_TO_0  = 8'd4,
    AXI4STREAM_RESET_POSEDGE = 8'd5,
    AXI4STREAM_RESET_NEGEDGE = 8'd6,
    AXI4STREAM_RESET_ANYEDGE = 8'd7,
    AXI4STREAM_RESET_0_TO_1  = 8'd8,
    AXI4STREAM_RESET_1_TO_0  = 8'd9
} axi4stream_wait_e;

`ifndef MAX_AXI4_ID_WIDTH
  `define MAX_AXI4_ID_WIDTH 8
`endif

`ifndef MAX_AXI4_USER_WIDTH
  `define MAX_AXI4_USER_WIDTH 8
`endif

`ifndef MAX_AXI4_DEST_WIDTH
  `define MAX_AXI4_DEST_WIDTH 18
`endif

`ifndef MAX_AXI4_DATA_WIDTH
  `define MAX_AXI4_DATA_WIDTH 1024
`endif

// enum: axi4stream_operation_mode_e
//
typedef enum int
{
    AXI4STREAM_TRANSACTION_NON_BLOCKING = 32'd0,
    AXI4STREAM_TRANSACTION_BLOCKING     = 32'd1
} axi4stream_operation_mode_e;

// Global Transaction Class
class axi4stream_transaction;
    // Protocol 
    byte unsigned data[];
    axi4stream_byte_type_e byte_type[];
    bit [((`MAX_AXI4_ID_WIDTH) - 1):0]  id;
    bit [((`MAX_AXI4_DEST_WIDTH) - 1):0]  dest;
    bit [((`MAX_AXI4_USER_WIDTH) - 1):0] user_data [];
    int valid_delay[];
    int ready_delay[];

    // Housekeeping
    axi4stream_operation_mode_e  operation_mode  = AXI4STREAM_TRANSACTION_BLOCKING;
    bit transfer_done[];
    bit transaction_done;

    // This varaible is for printing component name and should not be visible/documented
    string driver_name;

    function void set_data( input byte unsigned ldata, input int index = 0 );
      data[index] = ldata;
    endfunction

    function byte unsigned get_data( input int index = 0 );
      return data[index];
    endfunction

    function void set_byte_type( input axi4stream_byte_type_e lbyte_type, input int index = 0 );
      byte_type[index] = lbyte_type;
    endfunction

    function axi4stream_byte_type_e get_byte_type( input int index = 0 );
      return byte_type[index];
    endfunction

    function void set_id( input bit [((`MAX_AXI4_ID_WIDTH) - 1):0]  lid );
      id = lid;
    endfunction

    function bit [((`MAX_AXI4_ID_WIDTH) - 1):0]   get_id();
      return id;
    endfunction

    function void set_dest( input bit [((`MAX_AXI4_DEST_WIDTH) - 1):0]  ldest );
      dest = ldest;
    endfunction

    function bit [((`MAX_AXI4_DEST_WIDTH) - 1):0]   get_dest();
      return dest;
    endfunction

    function void set_user_data( input bit [((`MAX_AXI4_USER_WIDTH) - 1):0] luser_data, input int index = 0 );
      user_data[index] = luser_data;
    endfunction

    function bit [((`MAX_AXI4_USER_WIDTH) - 1):0]  get_user_data( input int index = 0 );
      return user_data[index];
    endfunction

    function void set_valid_delay( input int lvalid_delay, input int index = 0 );
      valid_delay[index] = lvalid_delay;
    endfunction

    function int get_valid_delay( input int index = 0 );
      return valid_delay[index];
    endfunction

    function void set_ready_delay( input int lready_delay, input int index = 0 );
      ready_delay[index] = lready_delay;
    endfunction

    function int get_ready_delay( input int index = 0 );
      return ready_delay[index];
    endfunction

    function void set_operation_mode( input axi4stream_operation_mode_e loperation_mode );
      operation_mode = loperation_mode;
    endfunction

    function axi4stream_operation_mode_e get_operation_mode();
      return operation_mode;
    endfunction

    function void set_transfer_done( input int ltransfer_done, input int index = 0 );
      transfer_done[index] = ltransfer_done;
    endfunction

    function int get_transfer_done( input int index = 0 );
      return transfer_done[index];
    endfunction

    function void set_transaction_done( input int ltransaction_done );
      transaction_done = ltransaction_done;
    endfunction

    function int get_transaction_done();
      return transaction_done;
    endfunction

    // Function: do_print
    //
    // Prints axi4stream_transaction transaction attributes
    function void print (bit print_delays = 1'b0);
      $display("------------------------------------------------------------------------");
      $display("%0t: %s axi4stream_transaction", $time, driver_name);
      $display("------------------------------------------------------------------------");
      foreach( data[i0_1] )
        $display("data[%0d] : %0d", i0_1, data[i0_1]);
      foreach( byte_type[i0_1] )
        $display("byte_type[%0d] : %s", i0_1, byte_type[i0_1].name());
      $display("id : 'h%h", id);
      $display("dest : 'h%h", dest);
      foreach( user_data[i0_1] )
        $display("user_data[%0d] : 'h%h", i0_1, user_data[i0_1]);
      $display("operation_mode   : %s", operation_mode.name() );
      foreach( transfer_done[i0_1] )
        $display("transfer_done[%0d] : 'b%b", i0_1, transfer_done[i0_1] );
      $display("transaction_done : 'b%b", transaction_done );
      if ( print_delays == 1'b1 )
      begin
        foreach( valid_delay[i0_1] )
          $display("valid_delay[%0d] : %0d", i0_1, valid_delay[i0_1]);
        foreach( ready_delay[i0_1] )
          $display("ready_delay[%0d] : %0d", i0_1, ready_delay[i0_1]);
      end
    endfunction
endclass

`else
// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20160107
// *****************************************************************************

// Title: AXI4STREAM Enumeration Types
//

//------------------------------------------------------------------------------
//
// Enum: axi4stream_byte_type_e
//
//------------------------------------------------------------------------------
//  This is used as the <byte_type> argument to the <axi4stream_master_packet>
//    transaction to indicate the type of the stream.
// 
// AXI4STREAM_DATA_BYTE       - Data byte when TKEEP = 1 and TSTRB = 1
// AXI4STREAM_NULL_BYTE       - Null byte when TKEEP = 0 and TSTRB = 0
// AXI4STREAM_POS_BYTE        - Position byte when TKEEP = 1 and TSTRB = 0
// AXI4STREAM_ILLEGAL_BYTE    - Illegal combination when TKEEP = 0 and TSTRB = 1
//  
typedef enum bit [1:0]
{
    AXI4STREAM_DATA_BYTE    = 2'h0,
    AXI4STREAM_NULL_BYTE    = 2'h1,
    AXI4STREAM_POS_BYTE     = 2'h2,
    AXI4STREAM_ILLEGAL_BYTE = 2'h3
} axi4stream_byte_type_e;



//------------------------------------------------------------------------------
//
// Enum: axi4stream_assertion_e
//
//------------------------------------------------------------------------------
//  Type defining the error messages which can be produced by the <mgc_axi4stream> Questa Verification IP.
// 
// Individual error messages can be disabled using the <config_enable_assertion> array of configuration bits.
// 
// AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_INVALID_LANE -  60000 -  On an invalid byte lane (TSTRB = 0) the value of TDATA has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TDATA_X_ON_INVALID_LANE                     -  60001 -  On an invalid byte lane (TSTRB = 0), TDATA has an X value.
// AXI4STREAM_TDATA_Z_ON_INVALID_LANE                     -  60002 -  On an invalid byte lane (TSTRB = 0), TDATA has a Z value.
// AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_VALID_LANE   -  60003 -  On a valid byte lane (TSTRB = 1) the value of TDATA has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TDATA_X_ON_VALID_LANE                       -  60004 -  On a valid byte lane (TSTRB = 1), TDATA has an X value.
// AXI4STREAM_TDATA_Z_ON_VALID_LANE                       -  60005 -  On a valid byte lane (TSTRB = 1), TDATA has a Z value.
// AXI4STREAM_TDEST_CHANGED_BEFORE_TREADY                 -  60006 -  The value of TDEST has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TDEST_X                                     -  60007 -  TDEST has an X value.
// AXI4STREAM_TDEST_Z                                     -  60008 -  TDEST has a Z value.
// AXI4STREAM_TID_CHANGED_BEFORE_TREADY                   -  60009 -  The value of TID has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TID_X                                       -  60010 -  TID has an X value.
// AXI4STREAM_TID_Z                                       -  60011 -  TID has a Z value.
// AXI4STREAM_TKEEP_CHANGED_BEFORE_TREADY                 -  60012 -  The value of TKEEP has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TKEEP_X                                     -  60013 -  TID has an X value.
// AXI4STREAM_TKEEP_Z                                     -  60014 -  TID has a Z value.
// AXI4STREAM_TLAST_CHANGED_BEFORE_TREADY                 -  60015 -  The value of TLAST has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TLAST_X                                     -  60016 -  TLAST has an X value.
// AXI4STREAM_TLAST_Z                                     -  60017 -  TLAST has a Z value.
// AXI4STREAM_TREADY_X                                    -  60018 -  TREADY has an X value.
// AXI4STREAM_TREADY_Z                                    -  60019 -  TREADY has a Z value.
// AXI4STREAM_TSTRB_CHANGED_BEFORE_TREADY                 -  60020 -  The value of TSTRB has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TSTRB_X                                     -  60021 -  TSTRB has an X value.
// AXI4STREAM_TSTRB_Z                                     -  60022 -  TSTRB has a Z value.
// AXI4STREAM_TUSER_CHANGED_BEFORE_TREADY                 -  60023 -  The value of TUSER has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TUSER_X                                     -  60024 -  TUSER has an X value.
// AXI4STREAM_TUSER_Z                                     -  60025 -  TUSER has a Z value.
// AXI4STREAM_TVALID_HIGH_EXITING_RESET                   -  60026 -  TVALID should have been driven low when exiting reset (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.7.2).
// AXI4STREAM_TVALID_HIGH_ON_FIRST_CLOCK                  -  60027 -  A master interface must only begin driving TVALID at a rising edge of ACLK following a rising edge of ACLK at which TRESETn is de-asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.7.2).
// AXI4STREAM_TVALID_CHANGED_BEFORE_TREADY                -  60028 -  The value of TVALID has changed between TVALID asserted and TREADY asserted (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.2.1).
// AXI4STREAM_TVALID_X                                    -  60029 -  TVALID has an X value.
// AXI4STREAM_TVALID_Z                                    -  60030 -  TVALID has a Z value.
// AXI4STREAM_DATA_WIDTH_VIOLATION                        -  60031 -  The data bus width of axi4 stream interface must be an integer number of bytes. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_TDEST_MAX_WIDTH_VIOLATION                   -  60032 -  The recommended width of TDEST on axi4 stream interface must be less than 4-bits. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_TID_MAX_WIDTH_VIOLATION                     -  60033 -  The recommended width of TID on axi4 stream interface must be less than 8-bits. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_TUSER_MAX_WIDTH_VIOLATION                   -  60034 -  The recommended width of TUSER on axi4 stream interface must be an integer multiplication of data bus width in bytes. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.1)
// AXI4STREAM_AUXM_TID_TDEST_WIDTH                        -  60035 -  The value of AXI4STREAM_ID_WIDTH + AXI4STREAM_DEST_WIDTH must not exceed 24. See ARM AXI4STREAM Protcol Compliance checkers.
// AXI4STREAM_TSTRB_HIGH_WHEN_TKEEP_LOW                   -  60036 -  The combination of TSTRB HIGH and TKEEP LOW is a reserved value. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.3.4)
// AXI4STREAM_TUSER_FIELD_NONZERO_NULL_BYTE               -  60037 -  If a null byte is inserted then appropriate number of user bits must also be inserted, which must be fixed LOW. (see AMBA AXI4 Stream Protocol Specification v1.0 section 2.8)
// AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID            -  60038 -  Once TVALID has been asserted, ARREADY should be asserted within config_max_latency_TVALID_assertion_to_TREADY clock periods
// AXI4STREAM_INTERNAL_RESERVED                           -  60039 -  A value reserved for internal purposes of the BFM.
typedef enum bit [7:0]
{
    AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_INVALID_LANE = 8'h00,
    AXI4STREAM_TDATA_X_ON_INVALID_LANE                     = 8'h01,
    AXI4STREAM_TDATA_Z_ON_INVALID_LANE                     = 8'h02,
    AXI4STREAM_TDATA_CHANGED_BEFORE_TREADY_ON_VALID_LANE   = 8'h03,
    AXI4STREAM_TDATA_X_ON_VALID_LANE                       = 8'h04,
    AXI4STREAM_TDATA_Z_ON_VALID_LANE                       = 8'h05,
    AXI4STREAM_TDEST_CHANGED_BEFORE_TREADY                 = 8'h06,
    AXI4STREAM_TDEST_X                                     = 8'h07,
    AXI4STREAM_TDEST_Z                                     = 8'h08,
    AXI4STREAM_TID_CHANGED_BEFORE_TREADY                   = 8'h09,
    AXI4STREAM_TID_X                                       = 8'h0a,
    AXI4STREAM_TID_Z                                       = 8'h0b,
    AXI4STREAM_TKEEP_CHANGED_BEFORE_TREADY                 = 8'h0c,
    AXI4STREAM_TKEEP_X                                     = 8'h0d,
    AXI4STREAM_TKEEP_Z                                     = 8'h0e,
    AXI4STREAM_TLAST_CHANGED_BEFORE_TREADY                 = 8'h0f,
    AXI4STREAM_TLAST_X                                     = 8'h10,
    AXI4STREAM_TLAST_Z                                     = 8'h11,
    AXI4STREAM_TREADY_X                                    = 8'h12,
    AXI4STREAM_TREADY_Z                                    = 8'h13,
    AXI4STREAM_TSTRB_CHANGED_BEFORE_TREADY                 = 8'h14,
    AXI4STREAM_TSTRB_X                                     = 8'h15,
    AXI4STREAM_TSTRB_Z                                     = 8'h16,
    AXI4STREAM_TUSER_CHANGED_BEFORE_TREADY                 = 8'h17,
    AXI4STREAM_TUSER_X                                     = 8'h18,
    AXI4STREAM_TUSER_Z                                     = 8'h19,
    AXI4STREAM_TVALID_HIGH_EXITING_RESET                   = 8'h1a,
    AXI4STREAM_TVALID_HIGH_ON_FIRST_CLOCK                  = 8'h1b,
    AXI4STREAM_TVALID_CHANGED_BEFORE_TREADY                = 8'h1c,
    AXI4STREAM_TVALID_X                                    = 8'h1d,
    AXI4STREAM_TVALID_Z                                    = 8'h1e,
    AXI4STREAM_DATA_WIDTH_VIOLATION                        = 8'h1f,
    AXI4STREAM_TDEST_MAX_WIDTH_VIOLATION                   = 8'h20,
    AXI4STREAM_TID_MAX_WIDTH_VIOLATION                     = 8'h21,
    AXI4STREAM_TUSER_MAX_WIDTH_VIOLATION                   = 8'h22,
    AXI4STREAM_AUXM_TID_TDEST_WIDTH                        = 8'h23,
    AXI4STREAM_TSTRB_HIGH_WHEN_TKEEP_LOW                   = 8'h24,
    AXI4STREAM_TUSER_FIELD_NONZERO_NULL_BYTE               = 8'h25,
    AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID            = 8'h26,
    AXI4STREAM_INTERNAL_RESERVED                           = 8'h27
} axi4stream_assertion_e;



typedef bit [1023:0] axi4stream_max_bits_t;

// enum: axi4stream_config_e
//
// An enum which fields corresponding to each configuration parameter of the VIP
//    AXI4STREAM_CONFIG_LAST_DURING_IDLE - 
//          Sets the value of TLAST signal during idle.
//         When set to 1'b0 then this indicates that TLAST will be driven 0 during idle.
//         When set to 1'b1 then TLAST will be driven 1 during idle.
//         
//            Default: 0
//         
//    AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS - 
//          Enables all protocol assertions. 
//              
//              Default: 1
//           
//    AXI4STREAM_CONFIG_ENABLE_ASSERTION - 
//         
//             Enables individual protocol assertion.
//             This variable controls whether specific assertion within QVIP (of type <axi4stream_assertion_e>) is enabled or disabled.
//             Individual assertion can be disabled as follows:-
//             //-----------------------------------------------------------------------
//             // < BFM interface>.set_config_enable_assertion_index1(<name of assertion>,1'b0);
//             //-----------------------------------------------------------------------
//             
//             For example, the assertion AXI4STREAM_TLAST_X can be disabled as follows:
//             <bfm>.set_config_enable_assertion_index1(AXI4STREAM_TLAST_X, 1'b0); 
//             
//             Here bfm is the AXI4STREAM interface instance name for which the assertion to be disabled. 
//             
//             Default: All assertions are enabled
//           
//    AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR - 
//          Sets maximum timeout value (in terms of clock) between phases of transaction.
//         
//            Default: 10000 clock cycles.
//         
//    AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY - 
//          
//         Sets maximum timeout period (in terms of clock) from assertion of TVALID to assertion of TREADY.
//         An error message AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID is generated if TREADY is not asserted
//         after assertion of TVALID within this period. 
//         
//         Default: 10000 clock cycles
//         
//    AXI4STREAM_CONFIG_SETUP_TIME - 
//         
//              Sets number of simulation time units from the setup time to the active 
//              clock edge of clock. The setup time will always be less than the time period
//              of the clock. 
//             
//              Default:0
//            
//    AXI4STREAM_CONFIG_HOLD_TIME - 
//         
//              Sets number of simulation time units from the hold time to the active 
//              clock edge of clock. 
//             
//              Default:0
//            

typedef enum bit [7:0]
{
    AXI4STREAM_CONFIG_LAST_DURING_IDLE       = 8'd0,
    AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS  = 8'd1,
    AXI4STREAM_CONFIG_ENABLE_ASSERTION       = 8'd2,
    AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR   = 8'd3,
    AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY = 8'd4,
    AXI4STREAM_CONFIG_SETUP_TIME             = 8'd5,
    AXI4STREAM_CONFIG_HOLD_TIME              = 8'd6
} axi4stream_config_e;

// enum: axi4stream_vhd_if_e
//
// For VHDL use only
typedef enum int
{
    AXI4STREAM_VHD_SET_CONFIG                         = 32'd0,
    AXI4STREAM_VHD_GET_CONFIG                         = 32'd1,
    AXI4STREAM_VHD_CREATE_MASTER_TRANSACTION          = 32'd2,
    AXI4STREAM_VHD_SET_DATA                           = 32'd3,
    AXI4STREAM_VHD_GET_DATA                           = 32'd4,
    AXI4STREAM_VHD_SET_BYTE_TYPE                      = 32'd5,
    AXI4STREAM_VHD_GET_BYTE_TYPE                      = 32'd6,
    AXI4STREAM_VHD_SET_ID                             = 32'd7,
    AXI4STREAM_VHD_GET_ID                             = 32'd8,
    AXI4STREAM_VHD_SET_DEST                           = 32'd9,
    AXI4STREAM_VHD_GET_DEST                           = 32'd10,
    AXI4STREAM_VHD_SET_USER_DATA                      = 32'd11,
    AXI4STREAM_VHD_GET_USER_DATA                      = 32'd12,
    AXI4STREAM_VHD_SET_VALID_DELAY                    = 32'd13,
    AXI4STREAM_VHD_GET_VALID_DELAY                    = 32'd14,
    AXI4STREAM_VHD_SET_READY_DELAY                    = 32'd15,
    AXI4STREAM_VHD_GET_READY_DELAY                    = 32'd16,
    AXI4STREAM_VHD_SET_OPERATION_MODE                 = 32'd17,
    AXI4STREAM_VHD_GET_OPERATION_MODE                 = 32'd18,
    AXI4STREAM_VHD_SET_TRANSFER_DONE                  = 32'd19,
    AXI4STREAM_VHD_GET_TRANSFER_DONE                  = 32'd20,
    AXI4STREAM_VHD_SET_TRANSACTION_DONE               = 32'd21,
    AXI4STREAM_VHD_GET_TRANSACTION_DONE               = 32'd22,
    AXI4STREAM_VHD_EXECUTE_TRANSACTION                = 32'd23,
    AXI4STREAM_VHD_GET_PACKET                         = 32'd24,
    AXI4STREAM_VHD_EXECUTE_TRANSFER                   = 32'd25,
    AXI4STREAM_VHD_GET_TRANSFER                       = 32'd26,
    AXI4STREAM_VHD_EXECUTE_STREAM_READY               = 32'd27,
    AXI4STREAM_VHD_GET_STREAM_READY                   = 32'd28,
    AXI4STREAM_VHD_CREATE_MONITOR_TRANSACTION         = 32'd29,
    AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION           = 32'd30,
    AXI4STREAM_VHD_PUSH_TRANSACTION_ID                = 32'd31,
    AXI4STREAM_VHD_POP_TRANSACTION_ID                 = 32'd32,
    AXI4STREAM_VHD_PRINT                              = 32'd33,
    AXI4STREAM_VHD_DESTRUCT_TRANSACTION               = 32'd34,
    AXI4STREAM_VHD_WAIT_ON                            = 32'd35
} axi4stream_vhd_if_e;


typedef enum bit [7:0]
{
    AXI4STREAM_CLOCK_POSEDGE = 8'd0,
    AXI4STREAM_CLOCK_NEGEDGE = 8'd1,
    AXI4STREAM_CLOCK_ANYEDGE = 8'd2,
    AXI4STREAM_CLOCK_0_TO_1  = 8'd3,
    AXI4STREAM_CLOCK_1_TO_0  = 8'd4,
    AXI4STREAM_RESET_POSEDGE = 8'd5,
    AXI4STREAM_RESET_NEGEDGE = 8'd6,
    AXI4STREAM_RESET_ANYEDGE = 8'd7,
    AXI4STREAM_RESET_0_TO_1  = 8'd8,
    AXI4STREAM_RESET_1_TO_0  = 8'd9
} axi4stream_wait_e;

`ifndef MAX_AXI4_ID_WIDTH
  `define MAX_AXI4_ID_WIDTH 8
`endif

`ifndef MAX_AXI4_USER_WIDTH
  `define MAX_AXI4_USER_WIDTH 8
`endif

`ifndef MAX_AXI4_DEST_WIDTH
  `define MAX_AXI4_DEST_WIDTH 18
`endif

`ifndef MAX_AXI4_DATA_WIDTH
  `define MAX_AXI4_DATA_WIDTH 1024
`endif

// enum: axi4stream_operation_mode_e
//
typedef enum int
{
    AXI4STREAM_TRANSACTION_NON_BLOCKING = 32'd0,
    AXI4STREAM_TRANSACTION_BLOCKING     = 32'd1
} axi4stream_operation_mode_e;

// Global Transaction Class
class axi4stream_transaction;
    // Protocol 
    byte unsigned data[];
    axi4stream_byte_type_e byte_type[];
    bit [((`MAX_AXI4_ID_WIDTH) - 1):0]  id;
    bit [((`MAX_AXI4_DEST_WIDTH) - 1):0]  dest;
    bit [((`MAX_AXI4_USER_WIDTH) - 1):0] user_data [];
    int valid_delay[];
    int ready_delay[];

    // Housekeeping
    axi4stream_operation_mode_e  operation_mode  = AXI4STREAM_TRANSACTION_BLOCKING;
    bit transfer_done[];
    bit transaction_done;

    // This varaible is for printing component name and should not be visible/documented
    string driver_name;

    function void set_data( input byte unsigned ldata, input int index = 0 );
      data[index] = ldata;
    endfunction

    function byte unsigned get_data( input int index = 0 );
      return data[index];
    endfunction

    function void set_byte_type( input axi4stream_byte_type_e lbyte_type, input int index = 0 );
      byte_type[index] = lbyte_type;
    endfunction

    function axi4stream_byte_type_e get_byte_type( input int index = 0 );
      return byte_type[index];
    endfunction

    function void set_id( input bit [((`MAX_AXI4_ID_WIDTH) - 1):0]  lid );
      id = lid;
    endfunction

    function bit [((`MAX_AXI4_ID_WIDTH) - 1):0]   get_id();
      return id;
    endfunction

    function void set_dest( input bit [((`MAX_AXI4_DEST_WIDTH) - 1):0]  ldest );
      dest = ldest;
    endfunction

    function bit [((`MAX_AXI4_DEST_WIDTH) - 1):0]   get_dest();
      return dest;
    endfunction

    function void set_user_data( input bit [((`MAX_AXI4_USER_WIDTH) - 1):0] luser_data, input int index = 0 );
      user_data[index] = luser_data;
    endfunction

    function bit [((`MAX_AXI4_USER_WIDTH) - 1):0]  get_user_data( input int index = 0 );
      return user_data[index];
    endfunction

    function void set_valid_delay( input int lvalid_delay, input int index = 0 );
      valid_delay[index] = lvalid_delay;
    endfunction

    function int get_valid_delay( input int index = 0 );
      return valid_delay[index];
    endfunction

    function void set_ready_delay( input int lready_delay, input int index = 0 );
      ready_delay[index] = lready_delay;
    endfunction

    function int get_ready_delay( input int index = 0 );
      return ready_delay[index];
    endfunction

    function void set_operation_mode( input axi4stream_operation_mode_e loperation_mode );
      operation_mode = loperation_mode;
    endfunction

    function axi4stream_operation_mode_e get_operation_mode();
      return operation_mode;
    endfunction

    function void set_transfer_done( input int ltransfer_done, input int index = 0 );
      transfer_done[index] = ltransfer_done;
    endfunction

    function int get_transfer_done( input int index = 0 );
      return transfer_done[index];
    endfunction

    function void set_transaction_done( input int ltransaction_done );
      transaction_done = ltransaction_done;
    endfunction

    function int get_transaction_done();
      return transaction_done;
    endfunction

    // Function: do_print
    //
    // Prints axi4stream_transaction transaction attributes
    function void print (bit print_delays = 1'b0);
      $display("------------------------------------------------------------------------");
      $display("%0t: %s axi4stream_transaction", $time, driver_name);
      $display("------------------------------------------------------------------------");
      foreach( data[i0_1] )
        $display("data[%0d] : %0d", i0_1, data[i0_1]);
      foreach( byte_type[i0_1] )
        $display("byte_type[%0d] : %s", i0_1, byte_type[i0_1].name());
      $display("id : 'h%h", id);
      $display("dest : 'h%h", dest);
      foreach( user_data[i0_1] )
        $display("user_data[%0d] : 'h%h", i0_1, user_data[i0_1]);
      $display("operation_mode   : %s", operation_mode.name() );
      foreach( transfer_done[i0_1] )
        $display("transfer_done[%0d] : 'b%b", i0_1, transfer_done[i0_1] );
      $display("transaction_done : 'b%b", transaction_done );
      if ( print_delays == 1'b1 )
      begin
        foreach( valid_delay[i0_1] )
          $display("valid_delay[%0d] : %0d", i0_1, valid_delay[i0_1]);
        foreach( ready_delay[i0_1] )
          $display("ready_delay[%0d] : %0d", i0_1, ready_delay[i0_1]);
      end
    endfunction
endclass

`endif // MODEL_TECH
endpackage

import mgc_axi4stream_pkg::*;
`ifdef MODEL_TECH
// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20160107
// *****************************************************************************

import QUESTA_MVC::questa_mvc_reporter;
import QUESTA_MVC::questa_mvc_item_comms_semantic;
import QUESTA_MVC::questa_mvc_edge;
import QUESTA_MVC::QUESTA_MVC_POSEDGE;
import QUESTA_MVC::QUESTA_MVC_NEGEDGE;
import QUESTA_MVC::QUESTA_MVC_ANYEDGE;
import QUESTA_MVC::QUESTA_MVC_0_TO_1_EDGE;
import QUESTA_MVC::QUESTA_MVC_1_TO_0_EDGE;


(* cy_so="libaxi4stream_IN_SystemVerilog_MTI_full" *)
(* on_lib_load="axi4stream_IN_SystemVerilog_load" *)

interface mgc_common_axi4stream #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024)
    (input wire iACLK, input wire iARESETn);

    //-------------------------------------------------------------------------
    //
    // Group: AXI4STREAM Signals
    //
    //-------------------------------------------------------------------------



    //-------------------------------------------------------------------------
    // Private wires
    //-------------------------------------------------------------------------
    wire ACLK;
    wire ARESETn;
    wire TVALID;
    wire [((AXI4_DATA_WIDTH) - 1):0]  TDATA;
    wire [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB;
    wire [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP;
    wire TLAST;
    wire [((AXI4_ID_WIDTH) - 1):0]  TID;
    wire [((AXI4_USER_WIDTH) - 1):0]  TUSER;
    wire [((AXI4_DEST_WIDTH) - 1):0]  TDEST;
    wire TREADY;



    // Propagate global signals onto interface wires
    assign ACLK = iACLK;
    assign ARESETn = iARESETn;

    // Variable: config_last_during_idle
    //
    //  Sets the value of TLAST signal during idle.
    // When set to 1'b0 then this indicates that TLAST will be driven 0 during idle.
    // When set to 1'b1 then TLAST will be driven 1 during idle.
    // 
    //    Default: 0
    // 
    //
    // mentor configurator specification name "TLAST value during idle"
    bit config_last_during_idle;

    // Variable: config_enable_all_assertions
    //
    //  Enables all protocol assertions. 
    //      
    //      Default: 1
    //   
    //
    // mentor configurator specification name "Enable all protocol assertions"
    bit config_enable_all_assertions;

    // Variable: config_enable_assertion
    //
    // 
    //     Enables individual protocol assertion.
    //     This variable controls whether specific assertion within QVIP (of type <axi4stream_assertion_e>) is enabled or disabled.
    //     Individual assertion can be disabled as follows:-
    //     //-----------------------------------------------------------------------
    //     // < BFM interface>.set_config_enable_assertion_index1(<name of assertion>,1'b0);
    //     //-----------------------------------------------------------------------
    //     
    //     For example, the assertion AXI4STREAM_TLAST_X can be disabled as follows:
    //     <bfm>.set_config_enable_assertion_index1(AXI4STREAM_TLAST_X, 1'b0); 
    //     
    //     Here bfm is the AXI4STREAM interface instance name for which the assertion to be disabled. 
    //     
    //     Default: All assertions are enabled
    //   
    //
    // mentor configurator specification name "Enable individual protocol assertion"
    bit [255:0] config_enable_assertion;

    // 
    // //-----------------------------------------------------------------------------
    // Group: Timeout Control
    // //-----------------------------------------------------------------------------
    // 


    // Variable: config_burst_timeout_factor
    //
    //  Sets maximum timeout value (in terms of clock) between phases of transaction.
    // 
    //    Default: 10000 clock cycles.
    // 
    //
    // mentor configurator specification name "Burst timeout between individual phases of a transaction"
    int unsigned config_burst_timeout_factor;

    // Variable: config_max_latency_TVALID_assertion_to_TREADY
    //
    //  
    // Sets maximum timeout period (in terms of clock) from assertion of TVALID to assertion of TREADY.
    // An error message AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID is generated if TREADY is not asserted
    // after assertion of TVALID within this period. 
    // 
    // Default: 10000 clock cycles
    // 
    //
    // mentor configurator specification name "Timeout from TVALID to TREADY assertion"
    int unsigned config_max_latency_TVALID_assertion_to_TREADY;

    // Variable: config_setup_time
    //
    // 
    //      Sets number of simulation time units from the setup time to the active 
    //      clock edge of clock. The setup time will always be less than the time period
    //      of the clock. 
    //     
    //      Default:0
    //    
    //
    // Note - This configuration variable is used in an expression involving time precision.
    //        To ensure its value is correct, use questa_mvc_sv_convert_to_precision API of QUESTA_MVC package.
    //
    longint unsigned config_setup_time;

    // Variable: config_hold_time
    //
    // 
    //      Sets number of simulation time units from the hold time to the active 
    //      clock edge of clock. 
    //     
    //      Default:0
    //    
    //
    // Note - This configuration variable is used in an expression involving time precision.
    //        To ensure its value is correct, use questa_mvc_sv_convert_to_precision API of QUESTA_MVC package.
    //
    longint unsigned config_hold_time;
    //------------------------------------------------------------------------------
    // Group:- Interface ends
    //------------------------------------------------------------------------------
    //
    longint axi4stream_master_end;


    // Function:- get_axi4stream_master_end
    //
    // Returns a handle to the <master> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_master_end();
        return axi4stream_master_end;
    endfunction

    longint axi4stream_slave_end;


    // Function:- get_axi4stream_slave_end
    //
    // Returns a handle to the <slave> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_slave_end();
        return axi4stream_slave_end;
    endfunction

    longint axi4stream_clock_source_end;


    // Function:- get_axi4stream_clock_source_end
    //
    // Returns a handle to the <clock_source> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_clock_source_end();
        return axi4stream_clock_source_end;
    endfunction

    longint axi4stream_reset_source_end;


    // Function:- get_axi4stream_reset_source_end
    //
    // Returns a handle to the <reset_source> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_reset_source_end();
        return axi4stream_reset_source_end;
    endfunction

    longint axi4stream__monitor_end;


    // Function:- get_axi4stream__monitor_end
    //
    // Returns a handle to the <_monitor> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream__monitor_end();
        return axi4stream__monitor_end;
    endfunction


    // Group:- Abstraction Levels
    // 
    // These functions are used set or get the abstraction levels of an interface end.
    // See <Abstraction Levels of Interface Ends> for more details on the meaning of
    // TLM or WLM connected and the valid combinations.


    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_master_abstraction_level
    //
    //     Function to set whether the <master> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_master_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_master_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_master_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <master> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_master_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_master_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_slave_abstraction_level
    //
    //     Function to set whether the <slave> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_slave_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_slave_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_slave_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <slave> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_slave_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_slave_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_clock_source_abstraction_level
    //
    //     Function to set whether the <clock_source> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_clock_source_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_clock_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_clock_source_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <clock_source> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_clock_source_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_clock_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_reset_source_abstraction_level
    //
    //     Function to set whether the <reset_source> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_reset_source_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_reset_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_reset_source_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <reset_source> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_reset_source_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_reset_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    import "DPI-C" context function longint axi4stream_initialise_SystemVerilog
    (
        int    usage_code,
        string iface_version,
        output longint master_end,
        output longint slave_end,
        output longint clock_source_end,
        output longint reset_source_end,
        output longint _monitor_end,
        input int AXI4_ID_WIDTH,
        input int AXI4_USER_WIDTH,
        input int AXI4_DEST_WIDTH,
        input int AXI4_DATA_WIDTH
    );

    `ifndef MVC_axi4stream_VERSION
    `define MVC_axi4stream_VERSION ""
    `endif
    // Handle to the linkage
    (* elab_init *) longint _interface_ref =
                                axi4stream_initialise_SystemVerilog
                                (
                                    18102076,
                                    `MVC_axi4stream_VERSION,
                                    axi4stream_master_end,
                                    axi4stream_slave_end,
                                    axi4stream_clock_source_end,
                                    axi4stream_reset_source_end,
                                    axi4stream__monitor_end,
                                    AXI4_ID_WIDTH,
                                    AXI4_USER_WIDTH,
                                    AXI4_DEST_WIDTH,
                                    AXI4_DATA_WIDTH
                                ); // DPI call to create transactor (called at
                                     // elaboration time as initialiser)

    generate
    begin : questa_mvc_reporting
        bit report_available;

        // Function for getting a message from QUESTA_MVC. Returns 1 if a message was returned, 0 otherwise.
        import "DPI-C" questa_mvc_sv_get_report =  function bit get_report( input longint iface_ref,input longint recipient,
                                     output string category,     output string objectName,
                                     output string instanceName, output string error_no,
                                     output string typ,          output string mess );
        questa_mvc_reporter endPoint[longint];
        initial report_available = 0;

        always @report_available
        begin
            longint recipient;
            string category;
            string objectName;
            string instanceName;
            string severity;
            string mess;
            string error_no;

            if ( endPoint.first( recipient ) )
              begin
                do
                  begin
                      while ( get_report( _interface_ref, recipient, category, objectName, instanceName, error_no, severity, mess ) )
                        begin
                          endPoint[recipient].report_message( category, "axi4stream", 0, objectName, instanceName, error_no, severity, mess );
                        end
                  end
                while (endPoint.next(recipient));
              end
            report_available = 0;
        end

        import "DPI-C" context questa_mvc_register_end_point = function void questa_mvc_register_end_point( input longint iface_ref, input longint as_end, input string name );

        // A function for registering a reporter to capture any reports coming from as_end
        function automatic void register_end_point( input longint as_end, input questa_mvc_reporter rep = null );
            if ( rep != null )
              begin
                if ( ( rep.name == "" ) || ( rep.name == "NULL" ) )
                  begin
                    $display("Error: %m: Reporter passed to register_end_point has a reserved name. Neither an empty string nor the string 'NULL' can be used.");
                  end
                else
                  begin
                    questa_mvc_register_end_point( _interface_ref, as_end, rep.name );
                    endPoint[as_end] = rep;
                  end
              end
            else
              begin
                questa_mvc_register_end_point( _interface_ref, as_end, "NULL" );
                endPoint.delete( as_end );
              end
        endfunction

    end : questa_mvc_reporting
    endgenerate

    //-------------------------------------------------------------------------
    //
    // Group:- Registering Reports
    //
    //
    // The following methods are used to register a custom reporting object as
    // described in the Questa Verification IP base library section, <Customizing Error-Reporting>.
    // 
    //-------------------------------------------------------------------------

    function void register_interface_reporter( input questa_mvc_reporter _rep = null );
        questa_mvc_reporting.register_end_point( _interface_ref, _rep );
    endfunction


    // Support the old API for registering an interface, for backwards compatability.
    // Note that this function is deprecated and may be removed in the future.
    function void interface_register_reporter( input questa_mvc_reporter _rep = null );
        questa_mvc_reporting.register_end_point( _interface_ref, _rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_master_reporter
    //
    // Function used to register a reporter for the <master> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the master end.
    //
    function void register_master_reporter
    (
        input questa_mvc_reporter rep = null
    );
        questa_mvc_reporting.register_end_point( axi4stream_master_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_slave_reporter
    //
    // Function used to register a reporter for the <slave> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the slave end.
    //
    function void register_slave_reporter
    (
        input questa_mvc_reporter rep = null
    );
        questa_mvc_reporting.register_end_point( axi4stream_slave_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_clock_source_reporter
    //
    // Function used to register a reporter for the <clock_source> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the clock_source end.
    //
    function void register_clock_source_reporter
    (
        input questa_mvc_reporter rep = null
    );
        questa_mvc_reporting.register_end_point( axi4stream_clock_source_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_reset_source_reporter
    //
    // Function used to register a reporter for the <reset_source> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the reset_source end.
    //
    function void register_reset_source_reporter
    (
        input questa_mvc_reporter rep = null
    );
        questa_mvc_reporting.register_end_point( axi4stream_reset_source_end, rep );
    endfunction


    // Declare user visible wires variables, for non-continuous assignments.
    logic m_ACLK = 'z;
    logic m_ARESETn = 'z;
    logic m_TVALID = 'z;
    logic [((AXI4_DATA_WIDTH) - 1):0]  m_TDATA = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  m_TSTRB = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  m_TKEEP = 'z;
    logic m_TLAST = 'z;
    logic [((AXI4_ID_WIDTH) - 1):0]  m_TID = 'z;
    logic [((AXI4_USER_WIDTH) - 1):0]  m_TUSER = 'z;
    logic [((AXI4_DEST_WIDTH) - 1):0]  m_TDEST = 'z;
    logic m_TREADY = 'z;

    // Forces a sweep through the wire change checkers at time 0 to get around
    // process kick-off order unknowns
    bit _check_t0_values;
    always_comb _check_t0_values = 1;

    // handle control
    longint last_handle = 0;

    longint last_start_time = 0;

    longint last_end_time = 0;

    export "DPI-C" axi4stream_set_last_handle_and_times = function set_last_handle_and_times;

    function void set_last_handle_and_times(longint _handle, longint _start, longint _end);
        last_handle = _handle;
        last_start_time = _start;
        last_end_time = _end;
    endfunction


    function longint get_last_handle();
        return last_handle;
    endfunction


    function longint get_last_start_time();
        return last_start_time;
    endfunction


    function longint get_last_end_time();
        return last_end_time;
    endfunction


    //-------------------------------------------------------------------------
    // Tasks to wait for a number of specified edges on a wire
    //-------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Function:- wait_for_ACLK
    //     Wait for the specified change on wire <axi4stream::ACLK>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_ACLK( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge ACLK);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge ACLK);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        ACLK);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( ACLK === 0 );
                    @( ACLK );
                end
                while ( ACLK !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( ACLK === 1 );
                    @( ACLK );
                end
                while ( ACLK !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_ARESETn
    //     Wait for the specified change on wire <axi4stream::ARESETn>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_ARESETn( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge ARESETn);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge ARESETn);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        ARESETn);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( ARESETn === 0 );
                    @( ARESETn );
                end
                while ( ARESETn !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( ARESETn === 1 );
                    @( ARESETn );
                end
                while ( ARESETn !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TVALID
    //     Wait for the specified change on wire <axi4stream::TVALID>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TVALID( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TVALID);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TVALID);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TVALID);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TVALID === 0 );
                    @( TVALID );
                end
                while ( TVALID !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TVALID === 1 );
                    @( TVALID );
                end
                while ( TVALID !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDATA
    //     Wait for the specified change on wire <axi4stream::TDATA>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDATA( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDATA);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDATA);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDATA);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDATA === 0 );
                    @( TDATA );
                end
                while ( TDATA !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDATA === 1 );
                    @( TDATA );
                end
                while ( TDATA !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDATA_index1
    //     Wait for the specified change on wire <axi4stream::TDATA>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDATA_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDATA[_this_dot_1] === 0 );
                    @( TDATA[_this_dot_1] );
                end
                while ( TDATA[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDATA[_this_dot_1] === 1 );
                    @( TDATA[_this_dot_1] );
                end
                while ( TDATA[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TSTRB
    //     Wait for the specified change on wire <axi4stream::TSTRB>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TSTRB( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TSTRB);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TSTRB);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TSTRB);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TSTRB === 0 );
                    @( TSTRB );
                end
                while ( TSTRB !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TSTRB === 1 );
                    @( TSTRB );
                end
                while ( TSTRB !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TSTRB_index1
    //     Wait for the specified change on wire <axi4stream::TSTRB>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TSTRB_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TSTRB[_this_dot_1] === 0 );
                    @( TSTRB[_this_dot_1] );
                end
                while ( TSTRB[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TSTRB[_this_dot_1] === 1 );
                    @( TSTRB[_this_dot_1] );
                end
                while ( TSTRB[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TKEEP
    //     Wait for the specified change on wire <axi4stream::TKEEP>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TKEEP( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TKEEP);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TKEEP);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TKEEP);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TKEEP === 0 );
                    @( TKEEP );
                end
                while ( TKEEP !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TKEEP === 1 );
                    @( TKEEP );
                end
                while ( TKEEP !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TKEEP_index1
    //     Wait for the specified change on wire <axi4stream::TKEEP>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TKEEP_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TKEEP[_this_dot_1] === 0 );
                    @( TKEEP[_this_dot_1] );
                end
                while ( TKEEP[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TKEEP[_this_dot_1] === 1 );
                    @( TKEEP[_this_dot_1] );
                end
                while ( TKEEP[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TLAST
    //     Wait for the specified change on wire <axi4stream::TLAST>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TLAST( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TLAST);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TLAST);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TLAST);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TLAST === 0 );
                    @( TLAST );
                end
                while ( TLAST !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TLAST === 1 );
                    @( TLAST );
                end
                while ( TLAST !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TID
    //     Wait for the specified change on wire <axi4stream::TID>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TID( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TID);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TID);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TID);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TID === 0 );
                    @( TID );
                end
                while ( TID !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TID === 1 );
                    @( TID );
                end
                while ( TID !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TID_index1
    //     Wait for the specified change on wire <axi4stream::TID>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TID_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TID[_this_dot_1] === 0 );
                    @( TID[_this_dot_1] );
                end
                while ( TID[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TID[_this_dot_1] === 1 );
                    @( TID[_this_dot_1] );
                end
                while ( TID[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TUSER
    //     Wait for the specified change on wire <axi4stream::TUSER>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TUSER( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TUSER);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TUSER);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TUSER);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TUSER === 0 );
                    @( TUSER );
                end
                while ( TUSER !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TUSER === 1 );
                    @( TUSER );
                end
                while ( TUSER !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TUSER_index1
    //     Wait for the specified change on wire <axi4stream::TUSER>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TUSER_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TUSER[_this_dot_1] === 0 );
                    @( TUSER[_this_dot_1] );
                end
                while ( TUSER[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TUSER[_this_dot_1] === 1 );
                    @( TUSER[_this_dot_1] );
                end
                while ( TUSER[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDEST
    //     Wait for the specified change on wire <axi4stream::TDEST>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDEST( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDEST);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDEST);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDEST);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDEST === 0 );
                    @( TDEST );
                end
                while ( TDEST !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDEST === 1 );
                    @( TDEST );
                end
                while ( TDEST !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDEST_index1
    //     Wait for the specified change on wire <axi4stream::TDEST>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDEST_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDEST[_this_dot_1] === 0 );
                    @( TDEST[_this_dot_1] );
                end
                while ( TDEST[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDEST[_this_dot_1] === 1 );
                    @( TDEST[_this_dot_1] );
                end
                while ( TDEST[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TREADY
    //     Wait for the specified change on wire <axi4stream::TREADY>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TREADY( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TREADY);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TREADY);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TREADY);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TREADY === 0 );
                    @( TREADY );
                end
                while ( TREADY !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TREADY === 1 );
                    @( TREADY );
                end
                while ( TREADY !== 0 );
            end
        end
    endtask

    //-------------------------------------------------------------------------
    // Tasks/functions to set/get wires
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- set_ACLK
    //-------------------------------------------------------------------------
    //     Set the value of wire <ACLK>.
    //
    // Parameters:
    //     ACLK_param - The value to set onto wire <ACLK>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_ACLK( logic ACLK_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_ACLK = ACLK_param;
        else
            m_ACLK <= ACLK_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_ACLK
    //-------------------------------------------------------------------------
    //     Get the value of wire <ACLK>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <ACLK>.
    //
    function automatic logic get_ACLK(  );
        return ACLK;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_ARESETn
    //-------------------------------------------------------------------------
    //     Set the value of wire <ARESETn>.
    //
    // Parameters:
    //     ARESETn_param - The value to set onto wire <ARESETn>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_ARESETn( logic ARESETn_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_ARESETn = ARESETn_param;
        else
            m_ARESETn <= ARESETn_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_ARESETn
    //-------------------------------------------------------------------------
    //     Get the value of wire <ARESETn>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <ARESETn>.
    //
    function automatic logic get_ARESETn(  );
        return ARESETn;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TVALID
    //-------------------------------------------------------------------------
    //     Set the value of wire <TVALID>.
    //
    // Parameters:
    //     TVALID_param - The value to set onto wire <TVALID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TVALID( logic TVALID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TVALID = TVALID_param;
        else
            m_TVALID <= TVALID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TVALID
    //-------------------------------------------------------------------------
    //     Get the value of wire <TVALID>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TVALID>.
    //
    function automatic logic get_TVALID(  );
        return TVALID;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TDATA
    //-------------------------------------------------------------------------
    //     Set the value of wire <TDATA>.
    //
    // Parameters:
    //     TDATA_param - The value to set onto wire <TDATA>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDATA( logic [((AXI4_DATA_WIDTH) - 1):0]  TDATA_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDATA = TDATA_param;
        else
            m_TDATA <= TDATA_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TDATA_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TDATA>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TDATA_param - The value to set onto wire <TDATA>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDATA_index1( int _this_dot_1, logic  TDATA_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDATA[_this_dot_1] = TDATA_param;
        else
            m_TDATA[_this_dot_1] <= TDATA_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TDATA
    //-------------------------------------------------------------------------
    //     Get the value of wire <TDATA>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TDATA>.
    //
    function automatic logic [((AXI4_DATA_WIDTH) - 1):0]   get_TDATA(  );
        return TDATA;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TDATA_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TDATA>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TDATA>.
    //
    function automatic logic   get_TDATA_index1( int _this_dot_1 );
        return TDATA[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TSTRB
    //-------------------------------------------------------------------------
    //     Set the value of wire <TSTRB>.
    //
    // Parameters:
    //     TSTRB_param - The value to set onto wire <TSTRB>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TSTRB( logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TSTRB = TSTRB_param;
        else
            m_TSTRB <= TSTRB_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TSTRB_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TSTRB>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TSTRB_param - The value to set onto wire <TSTRB>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TSTRB_index1( int _this_dot_1, logic  TSTRB_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TSTRB[_this_dot_1] = TSTRB_param;
        else
            m_TSTRB[_this_dot_1] <= TSTRB_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TSTRB
    //-------------------------------------------------------------------------
    //     Get the value of wire <TSTRB>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TSTRB>.
    //
    function automatic logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]   get_TSTRB(  );
        return TSTRB;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TSTRB_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TSTRB>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TSTRB>.
    //
    function automatic logic   get_TSTRB_index1( int _this_dot_1 );
        return TSTRB[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TKEEP
    //-------------------------------------------------------------------------
    //     Set the value of wire <TKEEP>.
    //
    // Parameters:
    //     TKEEP_param - The value to set onto wire <TKEEP>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TKEEP( logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TKEEP = TKEEP_param;
        else
            m_TKEEP <= TKEEP_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TKEEP_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TKEEP>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TKEEP_param - The value to set onto wire <TKEEP>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TKEEP_index1( int _this_dot_1, logic  TKEEP_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TKEEP[_this_dot_1] = TKEEP_param;
        else
            m_TKEEP[_this_dot_1] <= TKEEP_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TKEEP
    //-------------------------------------------------------------------------
    //     Get the value of wire <TKEEP>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TKEEP>.
    //
    function automatic logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]   get_TKEEP(  );
        return TKEEP;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TKEEP_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TKEEP>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TKEEP>.
    //
    function automatic logic   get_TKEEP_index1( int _this_dot_1 );
        return TKEEP[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TLAST
    //-------------------------------------------------------------------------
    //     Set the value of wire <TLAST>.
    //
    // Parameters:
    //     TLAST_param - The value to set onto wire <TLAST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TLAST( logic TLAST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TLAST = TLAST_param;
        else
            m_TLAST <= TLAST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TLAST
    //-------------------------------------------------------------------------
    //     Get the value of wire <TLAST>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TLAST>.
    //
    function automatic logic get_TLAST(  );
        return TLAST;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TID
    //-------------------------------------------------------------------------
    //     Set the value of wire <TID>.
    //
    // Parameters:
    //     TID_param - The value to set onto wire <TID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TID( logic [((AXI4_ID_WIDTH) - 1):0]  TID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TID = TID_param;
        else
            m_TID <= TID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TID_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TID>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TID_param - The value to set onto wire <TID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TID_index1( int _this_dot_1, logic  TID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TID[_this_dot_1] = TID_param;
        else
            m_TID[_this_dot_1] <= TID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TID
    //-------------------------------------------------------------------------
    //     Get the value of wire <TID>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TID>.
    //
    function automatic logic [((AXI4_ID_WIDTH) - 1):0]   get_TID(  );
        return TID;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TID_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TID>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TID>.
    //
    function automatic logic   get_TID_index1( int _this_dot_1 );
        return TID[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TUSER
    //-------------------------------------------------------------------------
    //     Set the value of wire <TUSER>.
    //
    // Parameters:
    //     TUSER_param - The value to set onto wire <TUSER>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TUSER( logic [((AXI4_USER_WIDTH) - 1):0]  TUSER_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TUSER = TUSER_param;
        else
            m_TUSER <= TUSER_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TUSER_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TUSER>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TUSER_param - The value to set onto wire <TUSER>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TUSER_index1( int _this_dot_1, logic  TUSER_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TUSER[_this_dot_1] = TUSER_param;
        else
            m_TUSER[_this_dot_1] <= TUSER_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TUSER
    //-------------------------------------------------------------------------
    //     Get the value of wire <TUSER>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TUSER>.
    //
    function automatic logic [((AXI4_USER_WIDTH) - 1):0]   get_TUSER(  );
        return TUSER;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TUSER_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TUSER>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TUSER>.
    //
    function automatic logic   get_TUSER_index1( int _this_dot_1 );
        return TUSER[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TDEST
    //-------------------------------------------------------------------------
    //     Set the value of wire <TDEST>.
    //
    // Parameters:
    //     TDEST_param - The value to set onto wire <TDEST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDEST( logic [((AXI4_DEST_WIDTH) - 1):0]  TDEST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDEST = TDEST_param;
        else
            m_TDEST <= TDEST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TDEST_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TDEST>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TDEST_param - The value to set onto wire <TDEST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDEST_index1( int _this_dot_1, logic  TDEST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDEST[_this_dot_1] = TDEST_param;
        else
            m_TDEST[_this_dot_1] <= TDEST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TDEST
    //-------------------------------------------------------------------------
    //     Get the value of wire <TDEST>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TDEST>.
    //
    function automatic logic [((AXI4_DEST_WIDTH) - 1):0]   get_TDEST(  );
        return TDEST;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TDEST_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TDEST>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TDEST>.
    //
    function automatic logic   get_TDEST_index1( int _this_dot_1 );
        return TDEST[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TREADY
    //-------------------------------------------------------------------------
    //     Set the value of wire <TREADY>.
    //
    // Parameters:
    //     TREADY_param - The value to set onto wire <TREADY>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TREADY( logic TREADY_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TREADY = TREADY_param;
        else
            m_TREADY <= TREADY_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TREADY
    //-------------------------------------------------------------------------
    //     Get the value of wire <TREADY>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TREADY>.
    //
    function automatic logic get_TREADY(  );
        return TREADY;
    endfunction

    //-------------------------------------------------------------------------
    // Tasks to wait for a change to a global variable with read access
    //-------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_last_during_idle
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_last_during_idle>.
    //
    task automatic wait_for_config_last_during_idle(  );
        begin
            @( config_last_during_idle );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_all_assertions
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_all_assertions>.
    //
    task automatic wait_for_config_enable_all_assertions(  );
        begin
            @( config_enable_all_assertions );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_assertion
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_assertion>.
    //
    task automatic wait_for_config_enable_assertion(  );
        begin
            @( config_enable_assertion );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_assertion_index1
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    task automatic wait_for_config_enable_assertion_index1( input int _this_dot_1 );
        begin
            @( config_enable_assertion[_this_dot_1] );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_burst_timeout_factor
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_burst_timeout_factor>.
    //
    task automatic wait_for_config_burst_timeout_factor(  );
        begin
            @( config_burst_timeout_factor );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_max_latency_TVALID_assertion_to_TREADY
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_max_latency_TVALID_assertion_to_TREADY>.
    //
    task automatic wait_for_config_max_latency_TVALID_assertion_to_TREADY(  );
        begin
            @( config_max_latency_TVALID_assertion_to_TREADY );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_setup_time
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_setup_time>.
    //
    task automatic wait_for_config_setup_time(  );
        begin
            @( config_setup_time );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_hold_time
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_hold_time>.
    //
    task automatic wait_for_config_hold_time(  );
        begin
            @( config_hold_time );
        end
    endtask


    //-------------------------------------------------------------------------
    // Functions to set global variables with write access
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- set_config_last_during_idle
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_last_during_idle>.
    //
    // Parameters:
    //     config_last_during_idle_param - The value to assign to variable <config_last_during_idle>.
    //
    function automatic void set_config_last_during_idle( bit config_last_during_idle_param );
        config_last_during_idle = config_last_during_idle_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_all_assertions
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_enable_all_assertions>.
    //
    // Parameters:
    //     config_enable_all_assertions_param - The value to assign to variable <config_enable_all_assertions>.
    //
    function automatic void set_config_enable_all_assertions( bit config_enable_all_assertions_param );
        config_enable_all_assertions = config_enable_all_assertions_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_assertion
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_enable_assertion>.
    //
    // Parameters:
    //     config_enable_assertion_param - The value to assign to variable <config_enable_assertion>.
    //
    function automatic void set_config_enable_assertion( bit [255:0] config_enable_assertion_param );
        config_enable_assertion = config_enable_assertion_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_assertion_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of variable <config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     config_enable_assertion_param - The value to assign to variable <config_enable_assertion>.
    //
    function automatic void set_config_enable_assertion_index1( int _this_dot_1, bit  config_enable_assertion_param );
        config_enable_assertion[_this_dot_1] = config_enable_assertion_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_burst_timeout_factor
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_burst_timeout_factor>.
    //
    // Parameters:
    //     config_burst_timeout_factor_param - The value to assign to variable <config_burst_timeout_factor>.
    //
    function automatic void set_config_burst_timeout_factor( int unsigned config_burst_timeout_factor_param );
        config_burst_timeout_factor = config_burst_timeout_factor_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_max_latency_TVALID_assertion_to_TREADY
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    // Parameters:
    //     config_max_latency_TVALID_assertion_to_TREADY_param - The value to assign to variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    function automatic void set_config_max_latency_TVALID_assertion_to_TREADY( int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
        config_max_latency_TVALID_assertion_to_TREADY = config_max_latency_TVALID_assertion_to_TREADY_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_setup_time
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_setup_time>.
    //
    // Parameters:
    //     config_setup_time_param - The value to assign to variable <config_setup_time>.
    //
    function automatic void set_config_setup_time( longint unsigned config_setup_time_param );
        config_setup_time = config_setup_time_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_hold_time
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_hold_time>.
    //
    // Parameters:
    //     config_hold_time_param - The value to assign to variable <config_hold_time>.
    //
    function automatic void set_config_hold_time( longint unsigned config_hold_time_param );
        config_hold_time = config_hold_time_param;
    endfunction


    //-------------------------------------------------------------------------
    // Functions to get global variables with read access
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- get_config_last_during_idle
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_last_during_idle>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_last_during_idle>.
    //
    function automatic bit get_config_last_during_idle(  );
        return config_last_during_idle;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_all_assertions
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_enable_all_assertions>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_enable_all_assertions>.
    //
    function automatic bit get_config_enable_all_assertions(  );
        return config_enable_all_assertions;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_assertion
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_enable_assertion>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_enable_assertion>.
    //
    function automatic bit [255:0]  get_config_enable_assertion(  );
        return config_enable_assertion;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_assertion_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of variable <config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the variable <config_enable_assertion>.
    //
    function automatic bit   get_config_enable_assertion_index1( int _this_dot_1 );
        return config_enable_assertion[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_burst_timeout_factor
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_burst_timeout_factor>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_burst_timeout_factor>.
    //
    function automatic int unsigned get_config_burst_timeout_factor(  );
        return config_burst_timeout_factor;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_max_latency_TVALID_assertion_to_TREADY
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    function automatic int unsigned get_config_max_latency_TVALID_assertion_to_TREADY(  );
        return config_max_latency_TVALID_assertion_to_TREADY;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_setup_time
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_setup_time>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_setup_time>.
    //
    function automatic longint unsigned get_config_setup_time(  );
        return config_setup_time;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_hold_time
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_hold_time>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_hold_time>.
    //
    function automatic longint unsigned get_config_hold_time(  );
        return config_hold_time;
    endfunction


    //-------------------------------------------------------------------------
    // Functions to set/get generic interface configuration
    //-------------------------------------------------------------------------

    function void set_interface
    (
        input int what = 0,
        input int arg1 = 0,
        input int arg2 = 0,
        input int arg3 = 0,
        input int arg4 = 0,
        input int arg5 = 0,
        input int arg6 = 0,
        input int arg7 = 0,
        input int arg8 = 0,
        input int arg9 = 0,
        input int arg10 = 0
    );
        axi4stream_set_interface( what, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 );
    endfunction

    function int get_interface
    (
        input int what = 0,
        input int arg1 = 0,
        input int arg2 = 0,
        input int arg3 = 0,
        input int arg4 = 0,
        input int arg5 = 0,
        input int arg6 = 0,
        input int arg7 = 0,
        input int arg8 = 0,
        input int arg9 = 0
    );
        return axi4stream_get_interface( what, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 );
    endfunction

    //-------------------------------------------------------------------------
    // Functions to get the hierarchic name of this interface
    //-------------------------------------------------------------------------
    function string get_full_name();
        return axi4stream_get_full_name();
    endfunction

    //--------------------------------------------------------------------------
    //
    // Group:- Monitor Value Change on Variable
    //
    //--------------------------------------------------------------------------

    function automatic void axi4stream_local_set_config_last_during_idle_from_SystemVerilog( ref bit config_last_during_idle_param );
        axi4stream_set_config_last_during_idle_from_SystemVerilog( _interface_ref, config_last_during_idle );
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_last_during_idle_from_SystemVerilog( config_last_during_idle );
            end
        end
    end

    function automatic void axi4stream_local_set_config_enable_all_assertions_from_SystemVerilog( ref bit config_enable_all_assertions_param );
        axi4stream_set_config_enable_all_assertions_from_SystemVerilog( _interface_ref, config_enable_all_assertions );
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_enable_all_assertions_from_SystemVerilog( config_enable_all_assertions );
            end
        end
    end

    function automatic void axi4stream_local_set_config_enable_assertion_from_SystemVerilog( ref bit [255:0] config_enable_assertion_param );
        axi4stream_set_config_enable_assertion_from_SystemVerilog( _interface_ref, config_enable_assertion );
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_enable_assertion_from_SystemVerilog( config_enable_assertion );
            end
        end
    end

    function automatic void axi4stream_local_set_config_burst_timeout_factor_from_SystemVerilog( ref int unsigned config_burst_timeout_factor_param );
        axi4stream_set_config_burst_timeout_factor_from_SystemVerilog( _interface_ref, config_burst_timeout_factor );
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_burst_timeout_factor_from_SystemVerilog( config_burst_timeout_factor );
            end
        end
    end

    function automatic void axi4stream_local_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( ref int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
        axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( _interface_ref, config_max_latency_TVALID_assertion_to_TREADY );
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( config_max_latency_TVALID_assertion_to_TREADY );
            end
        end
    end

    function automatic void axi4stream_local_set_config_setup_time_from_SystemVerilog( ref longint unsigned config_setup_time_param );
        axi4stream_set_config_setup_time_from_SystemVerilog( _interface_ref, config_setup_time );
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_setup_time_from_SystemVerilog( config_setup_time );
            end
        end
    end

    function automatic void axi4stream_local_set_config_hold_time_from_SystemVerilog( ref longint unsigned config_hold_time_param );
        axi4stream_set_config_hold_time_from_SystemVerilog( _interface_ref, config_hold_time );
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_hold_time_from_SystemVerilog( config_hold_time );
            end
        end
    end

    //-------------------------------------------------------------------------
    // Transaction interface
    //-------------------------------------------------------------------------

    task automatic dvc_put_packet
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        ref byte unsigned data[],
        ref axi4stream_byte_type_e byte_type[],
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        ref bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        ref int valid_delay[],
        ref int ready_delay[],
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to provide sized and unsized params.
            axi4stream_packet_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, data, byte_type, id, dest, user_data, valid_delay, ready_delay, _unit_id); // DPI call to imported task
        end
    endtask

    task automatic dvc_get_packet
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        ref byte unsigned data[],
        ref axi4stream_byte_type_e byte_type[],
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        ref bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        ref int valid_delay[],
        ref int ready_delay[],
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin
            int _trans_id;

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
                automatic int data_DIMS0;
                automatic int byte_type_DIMS0;
                automatic int user_data_DIMS0;
                automatic int valid_delay_DIMS0;
                automatic int ready_delay_DIMS0;
            // Call function to get unsized params sizes.
            axi4stream_packet_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, _trans_id, data_DIMS0, byte_type_DIMS0, user_data_DIMS0, valid_delay_DIMS0, ready_delay_DIMS0, _unit_id, _using); // DPI call to imported task
            // Create each unsized param
            if (data_DIMS0 != 0)
            begin
                data = new [data_DIMS0];
            end
            else
            begin
                data = new [1];  // Create dummy instead of a zero sized array
            end
            if (byte_type_DIMS0 != 0)
            begin
                byte_type = new [byte_type_DIMS0];
            end
            else
            begin
                byte_type = new [1];  // Create dummy instead of a zero sized array
            end
            if (user_data_DIMS0 != 0)
            begin
                user_data = new [user_data_DIMS0];
            end
            else
            begin
                user_data = new [1];  // Create dummy instead of a zero sized array
            end
            if (valid_delay_DIMS0 != 0)
            begin
                valid_delay = new [valid_delay_DIMS0];
            end
            else
            begin
                valid_delay = new [1];  // Create dummy instead of a zero sized array
            end
            if (ready_delay_DIMS0 != 0)
            begin
                ready_delay = new [ready_delay_DIMS0];
            end
            else
            begin
                ready_delay = new [1];  // Create dummy instead of a zero sized array
            end
            // Call function to get the sized and unsized params
            axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog(_comms_semantic,_as_end, _trans_id, data, byte_type, id, dest, user_data, valid_delay, ready_delay, _unit_id, _using); // DPI call to imported task
            if (data_DIMS0 == 0)
                data.delete;  // Delete each zero sized param
            if (byte_type_DIMS0 == 0)
                byte_type.delete;  // Delete each zero sized param
            if (user_data_DIMS0 == 0)
                user_data.delete;  // Delete each zero sized param
            if (valid_delay_DIMS0 == 0)
                valid_delay.delete;  // Delete each zero sized param
            if (ready_delay_DIMS0 == 0)
                ready_delay.delete;  // Delete each zero sized param
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_put_transfer
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        ref axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int valid_delay,
        input int ready_delay,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_transfer_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, data, byte_type, last, id, dest, user_data, valid_delay, ready_delay, _unit_id); // DPI call to imported task
        end
    endtask

    task automatic dvc_get_transfer
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        ref axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        output int valid_delay,
        output int ready_delay,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, data, byte_type, last, id, dest, user_data, valid_delay, ready_delay, _unit_id, _using); // DPI call to imported task
        end
    endtask

    task automatic dvc_put_cycle
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_cycle_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, data, strb, keep, last, id, dest, user_data, _unit_id); // DPI call to imported task
        end
    endtask

    task automatic dvc_get_cycle
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, data, strb, keep, last, id, dest, user_data, _unit_id, _using); // DPI call to imported task
        end
    endtask

    task automatic dvc_put_stream_ready
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit ready,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_stream_ready_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, ready, _unit_id); // DPI call to imported task
        end
    endtask

    task automatic dvc_get_stream_ready
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit ready,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, ready, _unit_id, _using); // DPI call to imported task
        end
    endtask


    //-------------------------------------------------------------------------
    // Generic Interface Configuration Support
    //

    import "DPI-C" context axi4stream_set_interface = function void axi4stream_set_interface
    (
        input int what,
        input int arg1,
        input int arg2,
        input int arg3,
        input int arg4,
        input int arg5,
        input int arg6,
        input int arg7,
        input int arg8,
        input int arg9,
        input int arg10
    );
    import "DPI-C" context axi4stream_get_interface = function int axi4stream_get_interface
    (
        input int what,
        input int arg1,
        input int arg2,
        input int arg3,
        input int arg4,
        input int arg5,
        input int arg6,
        input int arg7,
        input int arg8,
        input int arg9
    );


    //-------------------------------------------------------------------------
    // Functions to get the hierarchic name of this interface
    //
    import "DPI-C" context axi4stream_get_full_name = function string axi4stream_get_full_name();


    //-------------------------------------------------------------------------
    // Abstraction level Support
    //

    import "DPI-C" context axi4stream_set_master_end_abstraction_level =
    function void axi4stream_set_master_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_master_end_abstraction_level =
    function void axi4stream_get_master_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_slave_end_abstraction_level =
    function void axi4stream_set_slave_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_slave_end_abstraction_level =
    function void axi4stream_get_slave_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_clock_source_end_abstraction_level =
    function void axi4stream_set_clock_source_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_clock_source_end_abstraction_level =
    function void axi4stream_get_clock_source_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_reset_source_end_abstraction_level =
    function void axi4stream_set_reset_source_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_reset_source_end_abstraction_level =
    function void axi4stream_get_reset_source_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );

    //-------------------------------------------------------------------------
    // Wire Level Interface Support
    //
    logic internal_ACLK = 'z;
    logic internal_ARESETn = 'z;
    logic internal_TVALID = 'z;
    logic [((AXI4_DATA_WIDTH) - 1):0]  internal_TDATA = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  internal_TSTRB = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  internal_TKEEP = 'z;
    logic internal_TLAST = 'z;
    logic [((AXI4_ID_WIDTH) - 1):0]  internal_TID = 'z;
    logic [((AXI4_USER_WIDTH) - 1):0]  internal_TUSER = 'z;
    logic [((AXI4_DEST_WIDTH) - 1):0]  internal_TDEST = 'z;
    logic internal_TREADY = 'z;

    import "DPI-C" context function void axi4stream_set_ACLK_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit ACLK_param
    );
    import "DPI-C" context function void axi4stream_get_ACLK_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit ACLK_param

    );
    export "DPI-C" function axi4stream_initialise_ACLK_from_CY;

    import "DPI-C" context function void axi4stream_set_ARESETn_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit ARESETn_param
    );
    import "DPI-C" context function void axi4stream_get_ARESETn_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit ARESETn_param

    );
    export "DPI-C" function axi4stream_initialise_ARESETn_from_CY;

    import "DPI-C" context function void axi4stream_set_TVALID_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TVALID_param
    );
    import "DPI-C" context function void axi4stream_get_TVALID_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TVALID_param

    );
    export "DPI-C" function axi4stream_initialise_TVALID_from_CY;

    import "DPI-C" context function void axi4stream_set_TDATA_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic [((AXI4_DATA_WIDTH) - 1):0]  TDATA_param
    );
    import "DPI-C" context function void axi4stream_get_TDATA_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic [((AXI4_DATA_WIDTH) - 1):0]  TDATA_param

    );
    export "DPI-C" function axi4stream_initialise_TDATA_from_CY;

    import "DPI-C" context function void axi4stream_set_TSTRB_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB_param
    );
    import "DPI-C" context function void axi4stream_get_TSTRB_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB_param

    );
    export "DPI-C" function axi4stream_initialise_TSTRB_from_CY;

    import "DPI-C" context function void axi4stream_set_TKEEP_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP_param
    );
    import "DPI-C" context function void axi4stream_get_TKEEP_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP_param

    );
    export "DPI-C" function axi4stream_initialise_TKEEP_from_CY;

    import "DPI-C" context function void axi4stream_set_TLAST_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TLAST_param
    );
    import "DPI-C" context function void axi4stream_get_TLAST_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TLAST_param

    );
    export "DPI-C" function axi4stream_initialise_TLAST_from_CY;

    import "DPI-C" context function void axi4stream_set_TID_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic [((AXI4_ID_WIDTH) - 1):0]  TID_param
    );
    import "DPI-C" context function void axi4stream_get_TID_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic [((AXI4_ID_WIDTH) - 1):0]  TID_param

    );
    export "DPI-C" function axi4stream_initialise_TID_from_CY;

    import "DPI-C" context function void axi4stream_set_TUSER_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic [((AXI4_USER_WIDTH) - 1):0]  TUSER_param
    );
    import "DPI-C" context function void axi4stream_get_TUSER_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic [((AXI4_USER_WIDTH) - 1):0]  TUSER_param

    );
    export "DPI-C" function axi4stream_initialise_TUSER_from_CY;

    import "DPI-C" context function void axi4stream_set_TDEST_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic [((AXI4_DEST_WIDTH) - 1):0]  TDEST_param
    );
    import "DPI-C" context function void axi4stream_get_TDEST_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic [((AXI4_DEST_WIDTH) - 1):0]  TDEST_param

    );
    export "DPI-C" function axi4stream_initialise_TDEST_from_CY;

    import "DPI-C" context function void axi4stream_set_TREADY_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TREADY_param
    );
    import "DPI-C" context function void axi4stream_get_TREADY_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TREADY_param

    );
    export "DPI-C" function axi4stream_initialise_TREADY_from_CY;

    import "DPI-C" context function void axi4stream_set_config_last_during_idle_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit config_last_during_idle_param
    );
    import "DPI-C" context function void axi4stream_get_config_last_during_idle_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit config_last_during_idle_param

    );
    export "DPI-C" function axi4stream_set_config_last_during_idle_from_CY;

    import "DPI-C" context function void axi4stream_set_config_enable_all_assertions_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit config_enable_all_assertions_param
    );
    import "DPI-C" context function void axi4stream_get_config_enable_all_assertions_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit config_enable_all_assertions_param

    );
    export "DPI-C" function axi4stream_set_config_enable_all_assertions_from_CY;

    import "DPI-C" context function void axi4stream_set_config_enable_assertion_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit [255:0] config_enable_assertion_param
    );
    import "DPI-C" context function void axi4stream_get_config_enable_assertion_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit [255:0] config_enable_assertion_param

    );
    export "DPI-C" function axi4stream_set_config_enable_assertion_from_CY;

    import "DPI-C" context function void axi4stream_set_config_burst_timeout_factor_from_SystemVerilog
    (
        input longint _iface_ref,
        input int unsigned config_burst_timeout_factor_param
    );
    import "DPI-C" context function void axi4stream_get_config_burst_timeout_factor_into_SystemVerilog
    (
        input longint _iface_ref,
        output int unsigned config_burst_timeout_factor_param

    );
    export "DPI-C" function axi4stream_set_config_burst_timeout_factor_from_CY;

    import "DPI-C" context function void axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog
    (
        input longint _iface_ref,
        input int unsigned config_max_latency_TVALID_assertion_to_TREADY_param
    );
    import "DPI-C" context function void axi4stream_get_config_max_latency_TVALID_assertion_to_TREADY_into_SystemVerilog
    (
        input longint _iface_ref,
        output int unsigned config_max_latency_TVALID_assertion_to_TREADY_param

    );
    export "DPI-C" function axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_CY;

    import "DPI-C" context function void axi4stream_set_config_setup_time_from_SystemVerilog
    (
        input longint _iface_ref,
        input longint unsigned config_setup_time_param
    );
    import "DPI-C" context function void axi4stream_get_config_setup_time_into_SystemVerilog
    (
        input longint _iface_ref,
        output longint unsigned config_setup_time_param

    );
    export "DPI-C" function axi4stream_set_config_setup_time_from_CY;

    import "DPI-C" context function void axi4stream_set_config_hold_time_from_SystemVerilog
    (
        input longint _iface_ref,
        input longint unsigned config_hold_time_param
    );
    import "DPI-C" context function void axi4stream_get_config_hold_time_into_SystemVerilog
    (
        input longint _iface_ref,
        output longint unsigned config_hold_time_param

    );
    export "DPI-C" function axi4stream_set_config_hold_time_from_CY;

    function void axi4stream_initialise_ACLK_from_CY();
        internal_ACLK = 'z;
        m_ACLK = 'z;
    endfunction

    function void axi4stream_initialise_ARESETn_from_CY();
        internal_ARESETn = 'z;
        m_ARESETn = 'z;
    endfunction

    function void axi4stream_initialise_TVALID_from_CY();
        internal_TVALID = 'z;
        m_TVALID = 'z;
    endfunction

    function void axi4stream_initialise_TDATA_from_CY();
        internal_TDATA = 'z;
        m_TDATA = 'z;
    endfunction

    function void axi4stream_initialise_TSTRB_from_CY();
        internal_TSTRB = 'z;
        m_TSTRB = 'z;
    endfunction

    function void axi4stream_initialise_TKEEP_from_CY();
        internal_TKEEP = 'z;
        m_TKEEP = 'z;
    endfunction

    function void axi4stream_initialise_TLAST_from_CY();
        internal_TLAST = 'z;
        m_TLAST = 'z;
    endfunction

    function void axi4stream_initialise_TID_from_CY();
        internal_TID = 'z;
        m_TID = 'z;
    endfunction

    function void axi4stream_initialise_TUSER_from_CY();
        internal_TUSER = 'z;
        m_TUSER = 'z;
    endfunction

    function void axi4stream_initialise_TDEST_from_CY();
        internal_TDEST = 'z;
        m_TDEST = 'z;
    endfunction

    function void axi4stream_initialise_TREADY_from_CY();
        internal_TREADY = 'z;
        m_TREADY = 'z;
    endfunction

    function void axi4stream_set_config_last_during_idle_from_CY( bit config_last_during_idle_param );
        config_last_during_idle = config_last_during_idle_param;
    endfunction

    function void axi4stream_set_config_enable_all_assertions_from_CY( bit config_enable_all_assertions_param );
        config_enable_all_assertions = config_enable_all_assertions_param;
    endfunction

    function void axi4stream_set_config_enable_assertion_from_CY( bit [255:0] config_enable_assertion_param );
        config_enable_assertion = config_enable_assertion_param;
    endfunction

    function void axi4stream_set_config_burst_timeout_factor_from_CY( int unsigned config_burst_timeout_factor_param );
        config_burst_timeout_factor = config_burst_timeout_factor_param;
    endfunction

    function void axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_CY( int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
        config_max_latency_TVALID_assertion_to_TREADY = config_max_latency_TVALID_assertion_to_TREADY_param;
    endfunction

    function void axi4stream_set_config_setup_time_from_CY( longint unsigned config_setup_time_param );
        config_setup_time = config_setup_time_param;
    endfunction

    function void axi4stream_set_config_hold_time_from_CY( longint unsigned config_hold_time_param );
        config_hold_time = config_hold_time_param;
    endfunction



    //--------------------------------------------------------------------------
    //
    // Group:- TLM Interface Support
    //
    //--------------------------------------------------------------------------
    import "DPI-C" context axi4stream_packet_SendSendingSent_SystemVerilog =
    task axi4stream_packet_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input byte unsigned data[],
        input axi4stream_byte_type_e byte_type[],
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        input int valid_delay[],
        input int ready_delay[],
        input int _unit_id
    );
    import "DPI-C" context axi4stream_packet_START_SendSendingSent_SystemVerilog =
    function int axi4stream_packet_START_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input byte unsigned data[],
        input axi4stream_byte_type_e byte_type[],
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        input int valid_delay[],
        input int ready_delay[],
        input int _unit_id
    );
    import "DPI-C" context axi4stream_packet_END_SendSendingSent_SystemVerilog =
    function int axi4stream_packet_END_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_packet_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_packet_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output int _trans_id,
        inout int data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int byte_type_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int user_data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int valid_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int ready_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog =
    task axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        inout byte unsigned data[],
        inout axi4stream_byte_type_e byte_type[],
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        inout bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        inout int valid_delay[],
        inout int ready_delay[],
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_packet_START_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_packet_START_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_packet_END_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_packet_END_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        inout int data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int byte_type_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int user_data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int valid_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int ready_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int _unit_id
    );
    import "DPI-C" context axi4stream_packet_END_ReceivedReceivingReceive_open_SystemVerilog =
    function int axi4stream_packet_END_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        inout byte unsigned data[],
        inout axi4stream_byte_type_e byte_type[],
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        inout bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        inout int valid_delay[],
        inout int ready_delay[],
        input int _unit_id
    );
    import "DPI-C" context axi4stream_transfer_SendSendingSent_SystemVerilog =
    task axi4stream_transfer_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        input axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int valid_delay,
        input int ready_delay,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_transfer_START_SendSendingSent_SystemVerilog =
    function int axi4stream_transfer_START_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        input axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int valid_delay,
        input int ready_delay,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_transfer_END_SendSendingSent_SystemVerilog =
    function int axi4stream_transfer_END_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        output axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        output int valid_delay,
        output int ready_delay,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_transfer_START_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_transfer_START_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_transfer_END_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_transfer_END_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        output axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        output int valid_delay,
        output int ready_delay,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_cycle_SendSendingSent_SystemVerilog =
    task axi4stream_cycle_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_cycle_START_SendSendingSent_SystemVerilog =
    function int axi4stream_cycle_START_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_cycle_END_SendSendingSent_SystemVerilog =
    function int axi4stream_cycle_END_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_cycle_START_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_cycle_START_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_cycle_END_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_cycle_END_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_stream_ready_SendSendingSent_SystemVerilog =
    task axi4stream_stream_ready_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit ready,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_stream_ready_START_SendSendingSent_SystemVerilog =
    function int axi4stream_stream_ready_START_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit ready,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_stream_ready_END_SendSendingSent_SystemVerilog =
    function int axi4stream_stream_ready_END_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output bit ready,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_stream_ready_START_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_stream_ready_START_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_stream_ready_END_ReceivedReceivingReceive_SystemVerilog =
    function int axi4stream_stream_ready_END_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        output bit ready,
        input int _unit_id
    );
    // Waiter task and control
    reg wait_for_control = 0;

    always @(posedge wait_for_control)
    begin
        disable wait_for;
        wait_for_control = 0;
    end

    export "DPI-C" axi4stream_wait_for = task wait_for;

    task wait_for();
        begin
            wait(0 == 1);
        end
    endtask

    // Drive wires (from Cohesive) 
    assign ACLK = internal_ACLK;
    assign ARESETn = internal_ARESETn;
    assign TVALID = internal_TVALID;
    assign TDATA = internal_TDATA;
    assign TSTRB = internal_TSTRB;
    assign TKEEP = internal_TKEEP;
    assign TLAST = internal_TLAST;
    assign TID = internal_TID;
    assign TUSER = internal_TUSER;
    assign TDEST = internal_TDEST;
    assign TREADY = internal_TREADY;
    // Drive wires (from User) 
    assign ACLK = m_ACLK;
    assign ARESETn = m_ARESETn;
    assign TVALID = m_TVALID;
    assign TDATA = m_TDATA;
    assign TSTRB = m_TSTRB;
    assign TKEEP = m_TKEEP;
    assign TLAST = m_TLAST;
    assign TID = m_TID;
    assign TUSER = m_TUSER;
    assign TDEST = m_TDEST;
    assign TREADY = m_TREADY;

    reg ACLK_changed = 0;
    reg ARESETn_changed = 0;
    reg TVALID_changed = 0;
    reg TDATA_changed = 0;
    reg TSTRB_changed = 0;
    reg TKEEP_changed = 0;
    reg TLAST_changed = 0;
    reg TID_changed = 0;
    reg TUSER_changed = 0;
    reg TDEST_changed = 0;
    reg TREADY_changed = 0;
    reg config_last_during_idle_changed = 0;
    reg config_enable_all_assertions_changed = 0;
    reg config_enable_assertion_changed = 0;
    reg config_burst_timeout_factor_changed = 0;
    reg config_max_latency_TVALID_assertion_to_TREADY_changed = 0;
    reg config_setup_time_changed = 0;
    reg config_hold_time_changed = 0;
    // Timeless transaction monitor
    reg timeless_trans_control= 0;

    // SV wire change monitors

    always @( ACLK or posedge _check_t0_values )
    begin
        axi4stream_set_ACLK_from_SystemVerilog(_interface_ref, ACLK); // DPI call to imported task
    end

    always @( ARESETn or posedge _check_t0_values )
    begin
        axi4stream_set_ARESETn_from_SystemVerilog(_interface_ref, ARESETn); // DPI call to imported task
    end

    always @( TVALID or posedge _check_t0_values )
    begin
        axi4stream_set_TVALID_from_SystemVerilog(_interface_ref, TVALID); // DPI call to imported task
    end

    always @( TDATA or posedge _check_t0_values )
    begin
        axi4stream_set_TDATA_from_SystemVerilog(_interface_ref, TDATA); // DPI call to imported task
    end

    always @( TSTRB or posedge _check_t0_values )
    begin
        axi4stream_set_TSTRB_from_SystemVerilog(_interface_ref, TSTRB); // DPI call to imported task
    end

    always @( TKEEP or posedge _check_t0_values )
    begin
        axi4stream_set_TKEEP_from_SystemVerilog(_interface_ref, TKEEP); // DPI call to imported task
    end

    always @( TLAST or posedge _check_t0_values )
    begin
        axi4stream_set_TLAST_from_SystemVerilog(_interface_ref, TLAST); // DPI call to imported task
    end

    always @( TID or posedge _check_t0_values )
    begin
        axi4stream_set_TID_from_SystemVerilog(_interface_ref, TID); // DPI call to imported task
    end

    always @( TUSER or posedge _check_t0_values )
    begin
        axi4stream_set_TUSER_from_SystemVerilog(_interface_ref, TUSER); // DPI call to imported task
    end

    always @( TDEST or posedge _check_t0_values )
    begin
        axi4stream_set_TDEST_from_SystemVerilog(_interface_ref, TDEST); // DPI call to imported task
    end

    always @( TREADY or posedge _check_t0_values )
    begin
        axi4stream_set_TREADY_from_SystemVerilog(_interface_ref, TREADY); // DPI call to imported task
    end


    // CY wire and variable changed flag monitors

    always @(posedge ACLK_changed or posedge _check_t0_values )
    begin
        while (ACLK_changed == 1'b1)
        begin
            axi4stream_get_ACLK_into_SystemVerilog( _interface_ref, internal_ACLK ); // DPI call to imported task
            ACLK_changed = 1'b0;
            #0 if ( ACLK !== internal_ACLK )
            begin
                axi4stream_set_ACLK_from_SystemVerilog( _interface_ref, ACLK );
            end
        end
    end

    always @(posedge ARESETn_changed or posedge _check_t0_values )
    begin
        while (ARESETn_changed == 1'b1)
        begin
            axi4stream_get_ARESETn_into_SystemVerilog( _interface_ref, internal_ARESETn ); // DPI call to imported task
            ARESETn_changed = 1'b0;
            #0 if ( ARESETn !== internal_ARESETn )
            begin
                axi4stream_set_ARESETn_from_SystemVerilog( _interface_ref, ARESETn );
            end
        end
    end

    always @(posedge TVALID_changed or posedge _check_t0_values )
    begin
        while (TVALID_changed == 1'b1)
        begin
            axi4stream_get_TVALID_into_SystemVerilog( _interface_ref, internal_TVALID ); // DPI call to imported task
            TVALID_changed = 1'b0;
            #0 if ( TVALID !== internal_TVALID )
            begin
                axi4stream_set_TVALID_from_SystemVerilog( _interface_ref, TVALID );
            end
        end
    end

    always @(posedge TDATA_changed or posedge _check_t0_values )
    begin
        while (TDATA_changed == 1'b1)
        begin
            axi4stream_get_TDATA_into_SystemVerilog( _interface_ref, internal_TDATA ); // DPI call to imported task
            TDATA_changed = 1'b0;
            #0 if ( TDATA !== internal_TDATA )
            begin
                axi4stream_set_TDATA_from_SystemVerilog( _interface_ref, TDATA );
            end
        end
    end

    always @(posedge TSTRB_changed or posedge _check_t0_values )
    begin
        while (TSTRB_changed == 1'b1)
        begin
            axi4stream_get_TSTRB_into_SystemVerilog( _interface_ref, internal_TSTRB ); // DPI call to imported task
            TSTRB_changed = 1'b0;
            #0 if ( TSTRB !== internal_TSTRB )
            begin
                axi4stream_set_TSTRB_from_SystemVerilog( _interface_ref, TSTRB );
            end
        end
    end

    always @(posedge TKEEP_changed or posedge _check_t0_values )
    begin
        while (TKEEP_changed == 1'b1)
        begin
            axi4stream_get_TKEEP_into_SystemVerilog( _interface_ref, internal_TKEEP ); // DPI call to imported task
            TKEEP_changed = 1'b0;
            #0 if ( TKEEP !== internal_TKEEP )
            begin
                axi4stream_set_TKEEP_from_SystemVerilog( _interface_ref, TKEEP );
            end
        end
    end

    always @(posedge TLAST_changed or posedge _check_t0_values )
    begin
        while (TLAST_changed == 1'b1)
        begin
            axi4stream_get_TLAST_into_SystemVerilog( _interface_ref, internal_TLAST ); // DPI call to imported task
            TLAST_changed = 1'b0;
            #0 if ( TLAST !== internal_TLAST )
            begin
                axi4stream_set_TLAST_from_SystemVerilog( _interface_ref, TLAST );
            end
        end
    end

    always @(posedge TID_changed or posedge _check_t0_values )
    begin
        while (TID_changed == 1'b1)
        begin
            axi4stream_get_TID_into_SystemVerilog( _interface_ref, internal_TID ); // DPI call to imported task
            TID_changed = 1'b0;
            #0 if ( TID !== internal_TID )
            begin
                axi4stream_set_TID_from_SystemVerilog( _interface_ref, TID );
            end
        end
    end

    always @(posedge TUSER_changed or posedge _check_t0_values )
    begin
        while (TUSER_changed == 1'b1)
        begin
            axi4stream_get_TUSER_into_SystemVerilog( _interface_ref, internal_TUSER ); // DPI call to imported task
            TUSER_changed = 1'b0;
            #0 if ( TUSER !== internal_TUSER )
            begin
                axi4stream_set_TUSER_from_SystemVerilog( _interface_ref, TUSER );
            end
        end
    end

    always @(posedge TDEST_changed or posedge _check_t0_values )
    begin
        while (TDEST_changed == 1'b1)
        begin
            axi4stream_get_TDEST_into_SystemVerilog( _interface_ref, internal_TDEST ); // DPI call to imported task
            TDEST_changed = 1'b0;
            #0 if ( TDEST !== internal_TDEST )
            begin
                axi4stream_set_TDEST_from_SystemVerilog( _interface_ref, TDEST );
            end
        end
    end

    always @(posedge TREADY_changed or posedge _check_t0_values )
    begin
        while (TREADY_changed == 1'b1)
        begin
            axi4stream_get_TREADY_into_SystemVerilog( _interface_ref, internal_TREADY ); // DPI call to imported task
            TREADY_changed = 1'b0;
            #0 if ( TREADY !== internal_TREADY )
            begin
                axi4stream_set_TREADY_from_SystemVerilog( _interface_ref, TREADY );
            end
        end
    end

    always @(posedge config_last_during_idle_changed or posedge _check_t0_values )
    begin
        if (config_last_during_idle_changed == 1'b1)
        begin
            axi4stream_get_config_last_during_idle_into_SystemVerilog( _interface_ref, config_last_during_idle ); // DPI call to imported task
            config_last_during_idle_changed = 1'b0;
        end
    end

    always @(posedge config_enable_all_assertions_changed or posedge _check_t0_values )
    begin
        if (config_enable_all_assertions_changed == 1'b1)
        begin
            axi4stream_get_config_enable_all_assertions_into_SystemVerilog( _interface_ref, config_enable_all_assertions ); // DPI call to imported task
            config_enable_all_assertions_changed = 1'b0;
        end
    end

    always @(posedge config_enable_assertion_changed or posedge _check_t0_values )
    begin
        if (config_enable_assertion_changed == 1'b1)
        begin
            axi4stream_get_config_enable_assertion_into_SystemVerilog( _interface_ref, config_enable_assertion ); // DPI call to imported task
            config_enable_assertion_changed = 1'b0;
        end
    end

    always @(posedge config_burst_timeout_factor_changed or posedge _check_t0_values )
    begin
        if (config_burst_timeout_factor_changed == 1'b1)
        begin
            axi4stream_get_config_burst_timeout_factor_into_SystemVerilog( _interface_ref, config_burst_timeout_factor ); // DPI call to imported task
            config_burst_timeout_factor_changed = 1'b0;
        end
    end

    always @(posedge config_max_latency_TVALID_assertion_to_TREADY_changed or posedge _check_t0_values )
    begin
        if (config_max_latency_TVALID_assertion_to_TREADY_changed == 1'b1)
        begin
            axi4stream_get_config_max_latency_TVALID_assertion_to_TREADY_into_SystemVerilog( _interface_ref, config_max_latency_TVALID_assertion_to_TREADY ); // DPI call to imported task
            config_max_latency_TVALID_assertion_to_TREADY_changed = 1'b0;
        end
    end

    always @(posedge config_setup_time_changed or posedge _check_t0_values )
    begin
        if (config_setup_time_changed == 1'b1)
        begin
            axi4stream_get_config_setup_time_into_SystemVerilog( _interface_ref, config_setup_time ); // DPI call to imported task
            config_setup_time_changed = 1'b0;
        end
    end

    always @(posedge config_hold_time_changed or posedge _check_t0_values )
    begin
        if (config_hold_time_changed == 1'b1)
        begin
            axi4stream_get_config_hold_time_into_SystemVerilog( _interface_ref, config_hold_time ); // DPI call to imported task
            config_hold_time_changed = 1'b0;
        end
    end


// Timeless transaction interface support

    // assocative array of event indexed by unique_id(int)
    event assoc_timeless_comm_array[int];

    // these three functions are used by the timeless_trans_control event loop:
    // 1. initialise the loop
    import "DPI-C" context axi4stream_start_next_timeless_trans = function void axi4stream_start_next_timeless_trans();
    // 2. get next completed timeless transaction, returns null at the end
    import "DPI-C" context axi4stream_get_next_timeless_trans = function int axi4stream_get_next_timeless_trans();
    // 3. reset loop and empty the list
    import "DPI-C" context axi4stream_end_next_timeless_trans = function void axi4stream_end_next_timeless_trans();
    // could do above a little more efficiently by having each 'get' also remove the element so won't need an 'end'?

    // when timeless transaction monitor goes to 1 ..... trigger all the events associated with each transaction
    always @(posedge timeless_trans_control)
    begin
        int _trans_id ;
        // initialise C++ list
        axi4stream_start_next_timeless_trans() ; 
        // loop round the list, triggering all associated events
        for ( _trans_id= axi4stream_get_next_timeless_trans() ;
              _trans_id != 0 ;
              _trans_id= axi4stream_get_next_timeless_trans() )
        begin
            if ( assoc_timeless_comm_array.exists( _trans_id ) )
            begin
                // trigger the event
                -> assoc_timeless_comm_array[_trans_id] ;
                // the _END_ deletes it from the array after checking existance ...
                // - that's two accesses to the array here and two in the END, there must be a more efficient way! (Could do it in C++)
            end
            else
            begin
                // survivable (?) error - a non-null handle returned which isn't in the array!
                $display("Transaction WARNING @ %t: %m - unknown unique_id received from Adaptor.",$time);
            end
        end
        // completed C++ list
        axi4stream_end_next_timeless_trans() ; 
        timeless_trans_control= 0 ;
    end

    //--------------------------------------------------------------------------------
    // Task which blocks and outputs an error if the interface has not initialized properly
    //--------------------------------------------------------------------------------

    task _initialized();
        if (_interface_ref == 0)
        begin
            $display("Error: %m - Questa Verification IP failed to initialise. Please check questa_mvc.log for details");
            wait(_interface_ref!=0);
        end
    endtask

endinterface

`endif // MODEL_TECH
`ifdef INCA
// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20160107
// *****************************************************************************

import QUESTA_MVC::questa_mvc_reporter;
import QUESTA_MVC::questa_mvc_item_comms_semantic;
import QUESTA_MVC::questa_mvc_edge;
import QUESTA_MVC::QUESTA_MVC_POSEDGE;
import QUESTA_MVC::QUESTA_MVC_NEGEDGE;
import QUESTA_MVC::QUESTA_MVC_ANYEDGE;
import QUESTA_MVC::QUESTA_MVC_0_TO_1_EDGE;
import QUESTA_MVC::QUESTA_MVC_1_TO_0_EDGE;


(* cy_so="libaxi4stream_IN_SystemVerilog_MTI_full" *)
(* on_lib_load="axi4stream_IN_SystemVerilog_load" *)

interface mgc_common_axi4stream #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024)
    (input wire iACLK, input wire iARESETn);

    //-------------------------------------------------------------------------
    //
    // Group: AXI4STREAM Signals
    //
    //-------------------------------------------------------------------------



    //-------------------------------------------------------------------------
    // Private wires
    //-------------------------------------------------------------------------
    wire ACLK;
    wire ARESETn;
    wire TVALID;
    wire [((AXI4_DATA_WIDTH) - 1):0]  TDATA;
    wire [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB;
    wire [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP;
    wire TLAST;
    wire [((AXI4_ID_WIDTH) - 1):0]  TID;
    wire [((AXI4_USER_WIDTH) - 1):0]  TUSER;
    wire [((AXI4_DEST_WIDTH) - 1):0]  TDEST;
    wire TREADY;



    // Propagate global signals onto interface wires
    assign ACLK = iACLK;
    assign ARESETn = iARESETn;

    // Variable: config_last_during_idle
    //
    //  Sets the value of TLAST signal during idle.
    // When set to 1'b0 then this indicates that TLAST will be driven 0 during idle.
    // When set to 1'b1 then TLAST will be driven 1 during idle.
    // 
    //    Default: 0
    // 
    //
    // mentor configurator specification name "TLAST value during idle"
    bit config_last_during_idle;

    // Variable: config_enable_all_assertions
    //
    //  Enables all protocol assertions. 
    //      
    //      Default: 1
    //   
    //
    // mentor configurator specification name "Enable all protocol assertions"
    bit config_enable_all_assertions;

    // Variable: config_enable_assertion
    //
    // 
    //     Enables individual protocol assertion.
    //     This variable controls whether specific assertion within QVIP (of type <axi4stream_assertion_e>) is enabled or disabled.
    //     Individual assertion can be disabled as follows:-
    //     //-----------------------------------------------------------------------
    //     // < BFM interface>.set_config_enable_assertion_index1(<name of assertion>,1'b0);
    //     //-----------------------------------------------------------------------
    //     
    //     For example, the assertion AXI4STREAM_TLAST_X can be disabled as follows:
    //     <bfm>.set_config_enable_assertion_index1(AXI4STREAM_TLAST_X, 1'b0); 
    //     
    //     Here bfm is the AXI4STREAM interface instance name for which the assertion to be disabled. 
    //     
    //     Default: All assertions are enabled
    //   
    //
    // mentor configurator specification name "Enable individual protocol assertion"
    bit [255:0] config_enable_assertion;

    // 
    // //-----------------------------------------------------------------------------
    // Group: Timeout Control
    // //-----------------------------------------------------------------------------
    // 


    // Variable: config_burst_timeout_factor
    //
    //  Sets maximum timeout value (in terms of clock) between phases of transaction.
    // 
    //    Default: 10000 clock cycles.
    // 
    //
    // mentor configurator specification name "Burst timeout between individual phases of a transaction"
    int unsigned config_burst_timeout_factor;

    // Variable: config_max_latency_TVALID_assertion_to_TREADY
    //
    //  
    // Sets maximum timeout period (in terms of clock) from assertion of TVALID to assertion of TREADY.
    // An error message AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID is generated if TREADY is not asserted
    // after assertion of TVALID within this period. 
    // 
    // Default: 10000 clock cycles
    // 
    //
    // mentor configurator specification name "Timeout from TVALID to TREADY assertion"
    int unsigned config_max_latency_TVALID_assertion_to_TREADY;

    // Variable: config_setup_time
    //
    // 
    //      Sets number of simulation time units from the setup time to the active 
    //      clock edge of clock. The setup time will always be less than the time period
    //      of the clock. 
    //     
    //      Default:0
    //    
    //
    // Note - This configuration variable is used in an expression involving time precision.
    //        To ensure its value is correct, use questa_mvc_sv_convert_to_precision API of QUESTA_MVC package.
    //
    longint unsigned config_setup_time;

    // Variable: config_hold_time
    //
    // 
    //      Sets number of simulation time units from the hold time to the active 
    //      clock edge of clock. 
    //     
    //      Default:0
    //    
    //
    // Note - This configuration variable is used in an expression involving time precision.
    //        To ensure its value is correct, use questa_mvc_sv_convert_to_precision API of QUESTA_MVC package.
    //
    longint unsigned config_hold_time;
    //------------------------------------------------------------------------------
    // Group:- Interface ends
    //------------------------------------------------------------------------------
    //
    longint axi4stream_master_end;


    // Function:- get_axi4stream_master_end
    //
    // Returns a handle to the <master> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_master_end();
        return axi4stream_master_end;
    endfunction

    longint axi4stream_slave_end;


    // Function:- get_axi4stream_slave_end
    //
    // Returns a handle to the <slave> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_slave_end();
        return axi4stream_slave_end;
    endfunction

    longint axi4stream_clock_source_end;


    // Function:- get_axi4stream_clock_source_end
    //
    // Returns a handle to the <clock_source> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_clock_source_end();
        return axi4stream_clock_source_end;
    endfunction

    longint axi4stream_reset_source_end;


    // Function:- get_axi4stream_reset_source_end
    //
    // Returns a handle to the <reset_source> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_reset_source_end();
        return axi4stream_reset_source_end;
    endfunction

    longint axi4stream__monitor_end;


    // Function:- get_axi4stream__monitor_end
    //
    // Returns a handle to the <_monitor> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream__monitor_end();
        return axi4stream__monitor_end;
    endfunction


    // Group:- Abstraction Levels
    // 
    // These functions are used set or get the abstraction levels of an interface end.
    // See <Abstraction Levels of Interface Ends> for more details on the meaning of
    // TLM or WLM connected and the valid combinations.


    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_master_abstraction_level
    //
    //     Function to set whether the <master> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_master_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_master_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_master_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <master> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_master_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_master_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_slave_abstraction_level
    //
    //     Function to set whether the <slave> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_slave_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_slave_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_slave_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <slave> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_slave_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_slave_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_clock_source_abstraction_level
    //
    //     Function to set whether the <clock_source> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_clock_source_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_clock_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_clock_source_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <clock_source> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_clock_source_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_clock_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_reset_source_abstraction_level
    //
    //     Function to set whether the <reset_source> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_reset_source_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_reset_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_reset_source_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <reset_source> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_reset_source_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_reset_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    import "DPI-C" context function longint axi4stream_initialise_SystemVerilog
    (
        int    usage_code,
        string iface_version,
        output longint master_end,
        output longint slave_end,
        output longint clock_source_end,
        output longint reset_source_end,
        output longint _monitor_end,
        input int AXI4_ID_WIDTH,
        input int AXI4_USER_WIDTH,
        input int AXI4_DEST_WIDTH,
        input int AXI4_DATA_WIDTH
    );

    `ifndef MVC_axi4stream_VERSION
    `define MVC_axi4stream_VERSION ""
    `endif
    // Handle to the linkage
    (* elab_init *) longint _interface_ref =
                                axi4stream_initialise_SystemVerilog
                                (
                                    18102076,
                                    `MVC_axi4stream_VERSION,
                                    axi4stream_master_end,
                                    axi4stream_slave_end,
                                    axi4stream_clock_source_end,
                                    axi4stream_reset_source_end,
                                    axi4stream__monitor_end,
                                    AXI4_ID_WIDTH,
                                    AXI4_USER_WIDTH,
                                    AXI4_DEST_WIDTH,
                                    AXI4_DATA_WIDTH
                                ); // DPI call to create transactor (called at
                                     // elaboration time as initialiser)

        bit report_available;

        // Function for getting a message from QUESTA_MVC. Returns 1 if a message was returned, 0 otherwise.
        import "DPI-C" questa_mvc_sv_get_report =  function bit get_report( input longint iface_ref,input longint recipient,
                                     output string category,     output string objectName,
                                     output string instanceName, output string error_no,
                                     output string typ,          output string mess );
        questa_mvc_reporter endPoint[longint];
        initial report_available = 0;

        always @report_available
        begin
            longint recipient;
            string category;
            string objectName;
            string instanceName;
            string severity;
            string mess;
            string error_no;

            if ( endPoint.first( recipient ) )
              begin
                do
                  begin
                      while ( get_report( _interface_ref, recipient, category, objectName, instanceName, error_no, severity, mess ) )
                        begin
                          endPoint[recipient].report_message( category, "axi4stream", 0, objectName, instanceName, error_no, severity, mess );
                        end
                  end
                while (endPoint.next(recipient));
              end
            report_available = 0;
        end

        import "DPI-C" context questa_mvc_register_end_point = function void questa_mvc_register_end_point( input longint iface_ref, input longint as_end, input string name );

        // A function for registering a reporter to capture any reports coming from as_end
        function automatic void register_end_point( input longint as_end, input questa_mvc_reporter rep = null );
            if ( rep != null )
              begin
                if ( ( rep.name == "" ) || ( rep.name == "NULL" ) )
                  begin
                    $display("Error: %m: Reporter passed to register_end_point has a reserved name. Neither an empty string nor the string 'NULL' can be used.");
                  end
                else
                  begin
                    questa_mvc_register_end_point( _interface_ref, as_end, rep.name );
                    endPoint[as_end] = rep;
                  end
              end
            else
              begin
                questa_mvc_register_end_point( _interface_ref, as_end, "NULL" );
                endPoint.delete( as_end );
              end
        endfunction

    //-------------------------------------------------------------------------
    //
    // Group:- Registering Reports
    //
    //
    // The following methods are used to register a custom reporting object as
    // described in the Questa Verification IP base library section, <Customizing Error-Reporting>.
    // 
    //-------------------------------------------------------------------------

    function void register_interface_reporter( input questa_mvc_reporter _rep = null );
        register_end_point( _interface_ref, _rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_master_reporter
    //
    // Function used to register a reporter for the <master> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the master end.
    //
    function void register_master_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_master_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_slave_reporter
    //
    // Function used to register a reporter for the <slave> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the slave end.
    //
    function void register_slave_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_slave_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_clock_source_reporter
    //
    // Function used to register a reporter for the <clock_source> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the clock_source end.
    //
    function void register_clock_source_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_clock_source_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_reset_source_reporter
    //
    // Function used to register a reporter for the <reset_source> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the reset_source end.
    //
    function void register_reset_source_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_reset_source_end, rep );
    endfunction


    // Declare user visible wires variables, for non-continuous assignments.
    logic m_ACLK = 'z;
    logic m_ARESETn = 'z;
    logic m_TVALID = 'z;
    logic [((AXI4_DATA_WIDTH) - 1):0]  m_TDATA = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  m_TSTRB = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  m_TKEEP = 'z;
    logic m_TLAST = 'z;
    logic [((AXI4_ID_WIDTH) - 1):0]  m_TID = 'z;
    logic [((AXI4_USER_WIDTH) - 1):0]  m_TUSER = 'z;
    logic [((AXI4_DEST_WIDTH) - 1):0]  m_TDEST = 'z;
    logic m_TREADY = 'z;

    // Forces a sweep through the wire change checkers at time 0 to get around
    // process kick-off order unknowns
    bit _check_t0_values;
    always_comb _check_t0_values = 1;

    // handle control
    longint last_handle = 0;

    longint last_start_time = 0;

    longint last_end_time = 0;

    export "DPI-C" axi4stream_set_last_handle_and_times = function set_last_handle_and_times;

    function void set_last_handle_and_times(longint _handle, longint _start, longint _end);
        last_handle = _handle;
        last_start_time = _start;
        last_end_time = _end;
    endfunction


    function longint get_last_handle();
        return last_handle;
    endfunction


    function longint get_last_start_time();
        return last_start_time;
    endfunction


    function longint get_last_end_time();
        return last_end_time;
    endfunction


    //-------------------------------------------------------------------------
    // Tasks to wait for a number of specified edges on a wire
    //-------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Function:- wait_for_ACLK
    //     Wait for the specified change on wire <axi4stream::ACLK>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_ACLK( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge ACLK);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge ACLK);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        ACLK);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( ACLK === 0 );
                    @( ACLK );
                end
                while ( ACLK !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( ACLK === 1 );
                    @( ACLK );
                end
                while ( ACLK !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_ARESETn
    //     Wait for the specified change on wire <axi4stream::ARESETn>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_ARESETn( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge ARESETn);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge ARESETn);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        ARESETn);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( ARESETn === 0 );
                    @( ARESETn );
                end
                while ( ARESETn !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( ARESETn === 1 );
                    @( ARESETn );
                end
                while ( ARESETn !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TVALID
    //     Wait for the specified change on wire <axi4stream::TVALID>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TVALID( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TVALID);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TVALID);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TVALID);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TVALID === 0 );
                    @( TVALID );
                end
                while ( TVALID !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TVALID === 1 );
                    @( TVALID );
                end
                while ( TVALID !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDATA
    //     Wait for the specified change on wire <axi4stream::TDATA>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDATA( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDATA);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDATA);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDATA);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDATA === 0 );
                    @( TDATA );
                end
                while ( TDATA !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDATA === 1 );
                    @( TDATA );
                end
                while ( TDATA !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDATA_index1
    //     Wait for the specified change on wire <axi4stream::TDATA>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDATA_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDATA[_this_dot_1] === 0 );
                    @( TDATA[_this_dot_1] );
                end
                while ( TDATA[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDATA[_this_dot_1] === 1 );
                    @( TDATA[_this_dot_1] );
                end
                while ( TDATA[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TSTRB
    //     Wait for the specified change on wire <axi4stream::TSTRB>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TSTRB( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TSTRB);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TSTRB);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TSTRB);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TSTRB === 0 );
                    @( TSTRB );
                end
                while ( TSTRB !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TSTRB === 1 );
                    @( TSTRB );
                end
                while ( TSTRB !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TSTRB_index1
    //     Wait for the specified change on wire <axi4stream::TSTRB>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TSTRB_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TSTRB[_this_dot_1] === 0 );
                    @( TSTRB[_this_dot_1] );
                end
                while ( TSTRB[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TSTRB[_this_dot_1] === 1 );
                    @( TSTRB[_this_dot_1] );
                end
                while ( TSTRB[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TKEEP
    //     Wait for the specified change on wire <axi4stream::TKEEP>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TKEEP( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TKEEP);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TKEEP);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TKEEP);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TKEEP === 0 );
                    @( TKEEP );
                end
                while ( TKEEP !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TKEEP === 1 );
                    @( TKEEP );
                end
                while ( TKEEP !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TKEEP_index1
    //     Wait for the specified change on wire <axi4stream::TKEEP>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TKEEP_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TKEEP[_this_dot_1] === 0 );
                    @( TKEEP[_this_dot_1] );
                end
                while ( TKEEP[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TKEEP[_this_dot_1] === 1 );
                    @( TKEEP[_this_dot_1] );
                end
                while ( TKEEP[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TLAST
    //     Wait for the specified change on wire <axi4stream::TLAST>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TLAST( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TLAST);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TLAST);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TLAST);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TLAST === 0 );
                    @( TLAST );
                end
                while ( TLAST !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TLAST === 1 );
                    @( TLAST );
                end
                while ( TLAST !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TID
    //     Wait for the specified change on wire <axi4stream::TID>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TID( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TID);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TID);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TID);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TID === 0 );
                    @( TID );
                end
                while ( TID !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TID === 1 );
                    @( TID );
                end
                while ( TID !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TID_index1
    //     Wait for the specified change on wire <axi4stream::TID>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TID_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TID[_this_dot_1] === 0 );
                    @( TID[_this_dot_1] );
                end
                while ( TID[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TID[_this_dot_1] === 1 );
                    @( TID[_this_dot_1] );
                end
                while ( TID[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TUSER
    //     Wait for the specified change on wire <axi4stream::TUSER>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TUSER( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TUSER);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TUSER);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TUSER);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TUSER === 0 );
                    @( TUSER );
                end
                while ( TUSER !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TUSER === 1 );
                    @( TUSER );
                end
                while ( TUSER !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TUSER_index1
    //     Wait for the specified change on wire <axi4stream::TUSER>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TUSER_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TUSER[_this_dot_1] === 0 );
                    @( TUSER[_this_dot_1] );
                end
                while ( TUSER[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TUSER[_this_dot_1] === 1 );
                    @( TUSER[_this_dot_1] );
                end
                while ( TUSER[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDEST
    //     Wait for the specified change on wire <axi4stream::TDEST>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDEST( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDEST);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDEST);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDEST);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDEST === 0 );
                    @( TDEST );
                end
                while ( TDEST !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDEST === 1 );
                    @( TDEST );
                end
                while ( TDEST !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDEST_index1
    //     Wait for the specified change on wire <axi4stream::TDEST>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDEST_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDEST[_this_dot_1] === 0 );
                    @( TDEST[_this_dot_1] );
                end
                while ( TDEST[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDEST[_this_dot_1] === 1 );
                    @( TDEST[_this_dot_1] );
                end
                while ( TDEST[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TREADY
    //     Wait for the specified change on wire <axi4stream::TREADY>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TREADY( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TREADY);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TREADY);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TREADY);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TREADY === 0 );
                    @( TREADY );
                end
                while ( TREADY !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TREADY === 1 );
                    @( TREADY );
                end
                while ( TREADY !== 0 );
            end
        end
    endtask

    //-------------------------------------------------------------------------
    // Tasks/functions to set/get wires
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- set_ACLK
    //-------------------------------------------------------------------------
    //     Set the value of wire <ACLK>.
    //
    // Parameters:
    //     ACLK_param - The value to set onto wire <ACLK>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_ACLK( logic ACLK_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_ACLK = ACLK_param;
        else
            m_ACLK <= ACLK_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_ACLK
    //-------------------------------------------------------------------------
    //     Get the value of wire <ACLK>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <ACLK>.
    //
    function automatic logic get_ACLK(  );
        return ACLK;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_ARESETn
    //-------------------------------------------------------------------------
    //     Set the value of wire <ARESETn>.
    //
    // Parameters:
    //     ARESETn_param - The value to set onto wire <ARESETn>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_ARESETn( logic ARESETn_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_ARESETn = ARESETn_param;
        else
            m_ARESETn <= ARESETn_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_ARESETn
    //-------------------------------------------------------------------------
    //     Get the value of wire <ARESETn>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <ARESETn>.
    //
    function automatic logic get_ARESETn(  );
        return ARESETn;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TVALID
    //-------------------------------------------------------------------------
    //     Set the value of wire <TVALID>.
    //
    // Parameters:
    //     TVALID_param - The value to set onto wire <TVALID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TVALID( logic TVALID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TVALID = TVALID_param;
        else
            m_TVALID <= TVALID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TVALID
    //-------------------------------------------------------------------------
    //     Get the value of wire <TVALID>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TVALID>.
    //
    function automatic logic get_TVALID(  );
        return TVALID;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TDATA
    //-------------------------------------------------------------------------
    //     Set the value of wire <TDATA>.
    //
    // Parameters:
    //     TDATA_param - The value to set onto wire <TDATA>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDATA( logic [((AXI4_DATA_WIDTH) - 1):0]  TDATA_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDATA = TDATA_param;
        else
            m_TDATA <= TDATA_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TDATA_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TDATA>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TDATA_param - The value to set onto wire <TDATA>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDATA_index1( int _this_dot_1, logic  TDATA_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDATA[_this_dot_1] = TDATA_param;
        else
            m_TDATA[_this_dot_1] <= TDATA_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TDATA
    //-------------------------------------------------------------------------
    //     Get the value of wire <TDATA>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TDATA>.
    //
    function automatic logic [((AXI4_DATA_WIDTH) - 1):0]   get_TDATA(  );
        return TDATA;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TDATA_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TDATA>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TDATA>.
    //
    function automatic logic   get_TDATA_index1( int _this_dot_1 );
        return TDATA[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TSTRB
    //-------------------------------------------------------------------------
    //     Set the value of wire <TSTRB>.
    //
    // Parameters:
    //     TSTRB_param - The value to set onto wire <TSTRB>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TSTRB( logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TSTRB = TSTRB_param;
        else
            m_TSTRB <= TSTRB_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TSTRB_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TSTRB>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TSTRB_param - The value to set onto wire <TSTRB>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TSTRB_index1( int _this_dot_1, logic  TSTRB_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TSTRB[_this_dot_1] = TSTRB_param;
        else
            m_TSTRB[_this_dot_1] <= TSTRB_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TSTRB
    //-------------------------------------------------------------------------
    //     Get the value of wire <TSTRB>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TSTRB>.
    //
    function automatic logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]   get_TSTRB(  );
        return TSTRB;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TSTRB_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TSTRB>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TSTRB>.
    //
    function automatic logic   get_TSTRB_index1( int _this_dot_1 );
        return TSTRB[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TKEEP
    //-------------------------------------------------------------------------
    //     Set the value of wire <TKEEP>.
    //
    // Parameters:
    //     TKEEP_param - The value to set onto wire <TKEEP>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TKEEP( logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TKEEP = TKEEP_param;
        else
            m_TKEEP <= TKEEP_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TKEEP_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TKEEP>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TKEEP_param - The value to set onto wire <TKEEP>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TKEEP_index1( int _this_dot_1, logic  TKEEP_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TKEEP[_this_dot_1] = TKEEP_param;
        else
            m_TKEEP[_this_dot_1] <= TKEEP_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TKEEP
    //-------------------------------------------------------------------------
    //     Get the value of wire <TKEEP>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TKEEP>.
    //
    function automatic logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]   get_TKEEP(  );
        return TKEEP;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TKEEP_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TKEEP>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TKEEP>.
    //
    function automatic logic   get_TKEEP_index1( int _this_dot_1 );
        return TKEEP[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TLAST
    //-------------------------------------------------------------------------
    //     Set the value of wire <TLAST>.
    //
    // Parameters:
    //     TLAST_param - The value to set onto wire <TLAST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TLAST( logic TLAST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TLAST = TLAST_param;
        else
            m_TLAST <= TLAST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TLAST
    //-------------------------------------------------------------------------
    //     Get the value of wire <TLAST>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TLAST>.
    //
    function automatic logic get_TLAST(  );
        return TLAST;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TID
    //-------------------------------------------------------------------------
    //     Set the value of wire <TID>.
    //
    // Parameters:
    //     TID_param - The value to set onto wire <TID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TID( logic [((AXI4_ID_WIDTH) - 1):0]  TID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TID = TID_param;
        else
            m_TID <= TID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TID_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TID>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TID_param - The value to set onto wire <TID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TID_index1( int _this_dot_1, logic  TID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TID[_this_dot_1] = TID_param;
        else
            m_TID[_this_dot_1] <= TID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TID
    //-------------------------------------------------------------------------
    //     Get the value of wire <TID>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TID>.
    //
    function automatic logic [((AXI4_ID_WIDTH) - 1):0]   get_TID(  );
        return TID;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TID_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TID>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TID>.
    //
    function automatic logic   get_TID_index1( int _this_dot_1 );
        return TID[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TUSER
    //-------------------------------------------------------------------------
    //     Set the value of wire <TUSER>.
    //
    // Parameters:
    //     TUSER_param - The value to set onto wire <TUSER>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TUSER( logic [((AXI4_USER_WIDTH) - 1):0]  TUSER_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TUSER = TUSER_param;
        else
            m_TUSER <= TUSER_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TUSER_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TUSER>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TUSER_param - The value to set onto wire <TUSER>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TUSER_index1( int _this_dot_1, logic  TUSER_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TUSER[_this_dot_1] = TUSER_param;
        else
            m_TUSER[_this_dot_1] <= TUSER_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TUSER
    //-------------------------------------------------------------------------
    //     Get the value of wire <TUSER>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TUSER>.
    //
    function automatic logic [((AXI4_USER_WIDTH) - 1):0]   get_TUSER(  );
        return TUSER;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TUSER_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TUSER>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TUSER>.
    //
    function automatic logic   get_TUSER_index1( int _this_dot_1 );
        return TUSER[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TDEST
    //-------------------------------------------------------------------------
    //     Set the value of wire <TDEST>.
    //
    // Parameters:
    //     TDEST_param - The value to set onto wire <TDEST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDEST( logic [((AXI4_DEST_WIDTH) - 1):0]  TDEST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDEST = TDEST_param;
        else
            m_TDEST <= TDEST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TDEST_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TDEST>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TDEST_param - The value to set onto wire <TDEST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDEST_index1( int _this_dot_1, logic  TDEST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDEST[_this_dot_1] = TDEST_param;
        else
            m_TDEST[_this_dot_1] <= TDEST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TDEST
    //-------------------------------------------------------------------------
    //     Get the value of wire <TDEST>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TDEST>.
    //
    function automatic logic [((AXI4_DEST_WIDTH) - 1):0]   get_TDEST(  );
        return TDEST;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TDEST_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TDEST>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TDEST>.
    //
    function automatic logic   get_TDEST_index1( int _this_dot_1 );
        return TDEST[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TREADY
    //-------------------------------------------------------------------------
    //     Set the value of wire <TREADY>.
    //
    // Parameters:
    //     TREADY_param - The value to set onto wire <TREADY>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TREADY( logic TREADY_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TREADY = TREADY_param;
        else
            m_TREADY <= TREADY_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TREADY
    //-------------------------------------------------------------------------
    //     Get the value of wire <TREADY>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TREADY>.
    //
    function automatic logic get_TREADY(  );
        return TREADY;
    endfunction

    //-------------------------------------------------------------------------
    // Tasks to wait for a change to a global variable with read access
    //-------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_last_during_idle
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_last_during_idle>.
    //
    task automatic wait_for_config_last_during_idle(  );
        begin
            @( config_last_during_idle );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_all_assertions
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_all_assertions>.
    //
    task automatic wait_for_config_enable_all_assertions(  );
        begin
            @( config_enable_all_assertions );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_assertion
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_assertion>.
    //
    task automatic wait_for_config_enable_assertion(  );
        begin
            @( config_enable_assertion );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_assertion_index1
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    task automatic wait_for_config_enable_assertion_index1( input int _this_dot_1 );
        begin
            @( config_enable_assertion[_this_dot_1] );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_burst_timeout_factor
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_burst_timeout_factor>.
    //
    task automatic wait_for_config_burst_timeout_factor(  );
        begin
            @( config_burst_timeout_factor );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_max_latency_TVALID_assertion_to_TREADY
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_max_latency_TVALID_assertion_to_TREADY>.
    //
    task automatic wait_for_config_max_latency_TVALID_assertion_to_TREADY(  );
        begin
            @( config_max_latency_TVALID_assertion_to_TREADY );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_setup_time
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_setup_time>.
    //
    task automatic wait_for_config_setup_time(  );
        begin
            @( config_setup_time );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_hold_time
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_hold_time>.
    //
    task automatic wait_for_config_hold_time(  );
        begin
            @( config_hold_time );
        end
    endtask


    //-------------------------------------------------------------------------
    // Functions to set global variables with write access
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- set_config_last_during_idle
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_last_during_idle>.
    //
    // Parameters:
    //     config_last_during_idle_param - The value to assign to variable <config_last_during_idle>.
    //
    function automatic void set_config_last_during_idle( bit config_last_during_idle_param );
        config_last_during_idle = config_last_during_idle_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_all_assertions
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_enable_all_assertions>.
    //
    // Parameters:
    //     config_enable_all_assertions_param - The value to assign to variable <config_enable_all_assertions>.
    //
    function automatic void set_config_enable_all_assertions( bit config_enable_all_assertions_param );
        config_enable_all_assertions = config_enable_all_assertions_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_assertion
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_enable_assertion>.
    //
    // Parameters:
    //     config_enable_assertion_param - The value to assign to variable <config_enable_assertion>.
    //
    function automatic void set_config_enable_assertion( bit [255:0] config_enable_assertion_param );
        config_enable_assertion = config_enable_assertion_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_assertion_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of variable <config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     config_enable_assertion_param - The value to assign to variable <config_enable_assertion>.
    //
    function automatic void set_config_enable_assertion_index1( int _this_dot_1, bit  config_enable_assertion_param );
        config_enable_assertion[_this_dot_1] = config_enable_assertion_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_burst_timeout_factor
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_burst_timeout_factor>.
    //
    // Parameters:
    //     config_burst_timeout_factor_param - The value to assign to variable <config_burst_timeout_factor>.
    //
    function automatic void set_config_burst_timeout_factor( int unsigned config_burst_timeout_factor_param );
        config_burst_timeout_factor = config_burst_timeout_factor_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_max_latency_TVALID_assertion_to_TREADY
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    // Parameters:
    //     config_max_latency_TVALID_assertion_to_TREADY_param - The value to assign to variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    function automatic void set_config_max_latency_TVALID_assertion_to_TREADY( int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
        config_max_latency_TVALID_assertion_to_TREADY = config_max_latency_TVALID_assertion_to_TREADY_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_setup_time
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_setup_time>.
    //
    // Parameters:
    //     config_setup_time_param - The value to assign to variable <config_setup_time>.
    //
    function automatic void set_config_setup_time( longint unsigned config_setup_time_param );
        config_setup_time = config_setup_time_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_hold_time
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_hold_time>.
    //
    // Parameters:
    //     config_hold_time_param - The value to assign to variable <config_hold_time>.
    //
    function automatic void set_config_hold_time( longint unsigned config_hold_time_param );
        config_hold_time = config_hold_time_param;
    endfunction


    //-------------------------------------------------------------------------
    // Functions to get global variables with read access
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- get_config_last_during_idle
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_last_during_idle>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_last_during_idle>.
    //
    function automatic bit get_config_last_during_idle(  );
        return config_last_during_idle;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_all_assertions
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_enable_all_assertions>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_enable_all_assertions>.
    //
    function automatic bit get_config_enable_all_assertions(  );
        return config_enable_all_assertions;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_assertion
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_enable_assertion>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_enable_assertion>.
    //
    function automatic bit [255:0]  get_config_enable_assertion(  );
        return config_enable_assertion;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_assertion_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of variable <config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the variable <config_enable_assertion>.
    //
    function automatic bit   get_config_enable_assertion_index1( int _this_dot_1 );
        return config_enable_assertion[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_burst_timeout_factor
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_burst_timeout_factor>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_burst_timeout_factor>.
    //
    function automatic int unsigned get_config_burst_timeout_factor(  );
        return config_burst_timeout_factor;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_max_latency_TVALID_assertion_to_TREADY
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    function automatic int unsigned get_config_max_latency_TVALID_assertion_to_TREADY(  );
        return config_max_latency_TVALID_assertion_to_TREADY;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_setup_time
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_setup_time>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_setup_time>.
    //
    function automatic longint unsigned get_config_setup_time(  );
        return config_setup_time;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_hold_time
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_hold_time>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_hold_time>.
    //
    function automatic longint unsigned get_config_hold_time(  );
        return config_hold_time;
    endfunction


    //-------------------------------------------------------------------------
    // Functions to set/get generic interface configuration
    //-------------------------------------------------------------------------

    function void set_interface
    (
        input int what = 0,
        input int arg1 = 0,
        input int arg2 = 0,
        input int arg3 = 0,
        input int arg4 = 0,
        input int arg5 = 0,
        input int arg6 = 0,
        input int arg7 = 0,
        input int arg8 = 0,
        input int arg9 = 0,
        input int arg10 = 0
    );
        axi4stream_set_interface( what, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 );
    endfunction

    function int get_interface
    (
        input int what = 0,
        input int arg1 = 0,
        input int arg2 = 0,
        input int arg3 = 0,
        input int arg4 = 0,
        input int arg5 = 0,
        input int arg6 = 0,
        input int arg7 = 0,
        input int arg8 = 0,
        input int arg9 = 0
    );
        return axi4stream_get_interface( what, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 );
    endfunction

    //-------------------------------------------------------------------------
    // Functions to get the hierarchic name of this interface
    //-------------------------------------------------------------------------
    function string get_full_name();
        return axi4stream_get_full_name();
    endfunction

    //--------------------------------------------------------------------------
    //
    // Group:- Monitor Value Change on Variable
    //
    //--------------------------------------------------------------------------

    function automatic void axi4stream_local_set_config_last_during_idle_from_SystemVerilog( ref bit config_last_during_idle_param );
            axi4stream_set_config_last_during_idle_from_SystemVerilog( _interface_ref,config_last_during_idle); // DPI call to imported task
        
            axi4stream_propagate_config_last_during_idle_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_last_during_idle_from_SystemVerilog( config_last_during_idle );
            end
        end
    end

    function automatic void axi4stream_local_set_config_enable_all_assertions_from_SystemVerilog( ref bit config_enable_all_assertions_param );
            axi4stream_set_config_enable_all_assertions_from_SystemVerilog( _interface_ref,config_enable_all_assertions); // DPI call to imported task
        
            axi4stream_propagate_config_enable_all_assertions_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_enable_all_assertions_from_SystemVerilog( config_enable_all_assertions );
            end
        end
    end

    function automatic void axi4stream_local_set_config_enable_assertion_from_SystemVerilog( ref bit [255:0] config_enable_assertion_param );
            axi4stream_set_config_enable_assertion_from_SystemVerilog( _interface_ref,config_enable_assertion); // DPI call to imported task
        
            axi4stream_propagate_config_enable_assertion_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_enable_assertion_from_SystemVerilog( config_enable_assertion );
            end
        end
    end

    function automatic void axi4stream_local_set_config_burst_timeout_factor_from_SystemVerilog( ref int unsigned config_burst_timeout_factor_param );
            axi4stream_set_config_burst_timeout_factor_from_SystemVerilog( _interface_ref,config_burst_timeout_factor); // DPI call to imported task
        
            axi4stream_propagate_config_burst_timeout_factor_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_burst_timeout_factor_from_SystemVerilog( config_burst_timeout_factor );
            end
        end
    end

    function automatic void axi4stream_local_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( ref int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
            axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( _interface_ref,config_max_latency_TVALID_assertion_to_TREADY); // DPI call to imported task
        
            axi4stream_propagate_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( config_max_latency_TVALID_assertion_to_TREADY );
            end
        end
    end

    function automatic void axi4stream_local_set_config_setup_time_from_SystemVerilog( ref longint unsigned config_setup_time_param );
            axi4stream_set_config_setup_time_from_SystemVerilog( _interface_ref,config_setup_time); // DPI call to imported task
        
            axi4stream_propagate_config_setup_time_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_setup_time_from_SystemVerilog( config_setup_time );
            end
        end
    end

    function automatic void axi4stream_local_set_config_hold_time_from_SystemVerilog( ref longint unsigned config_hold_time_param );
            axi4stream_set_config_hold_time_from_SystemVerilog( _interface_ref,config_hold_time); // DPI call to imported task
        
            axi4stream_propagate_config_hold_time_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_hold_time_from_SystemVerilog( config_hold_time );
            end
        end
    end

    //-------------------------------------------------------------------------
    // Transaction interface
    //-------------------------------------------------------------------------

    byte unsigned temp_static_packet_data[];
    function void axi4stream_get_temp_static_packet_data( input int _d1, output byte unsigned _value );
        _value = temp_static_packet_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_data( input int _d1, input byte unsigned _value );
        temp_static_packet_data[_d1] = _value;
    endfunction
    axi4stream_byte_type_e temp_static_packet_byte_type[];
    function void axi4stream_get_temp_static_packet_byte_type( input int _d1, output axi4stream_byte_type_e _value );
        _value = temp_static_packet_byte_type[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_byte_type( input int _d1, input axi4stream_byte_type_e _value );
        temp_static_packet_byte_type[_d1] = _value;
    endfunction
    bit [((AXI4_ID_WIDTH) - 1):0]  temp_static_packet_id;
    function void axi4stream_get_temp_static_packet_id( input int _d1, output bit  _value );
        _value = temp_static_packet_id[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_id( input int _d1, input bit  _value );
        temp_static_packet_id[_d1] = _value;
    endfunction
    bit [((AXI4_DEST_WIDTH) - 1):0]  temp_static_packet_dest;
    function void axi4stream_get_temp_static_packet_dest( input int _d1, output bit  _value );
        _value = temp_static_packet_dest[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_dest( input int _d1, input bit  _value );
        temp_static_packet_dest[_d1] = _value;
    endfunction
    bit [((AXI4_USER_WIDTH) - 1):0] temp_static_packet_user_data [];
    function void axi4stream_get_temp_static_packet_user_data( input int _d1, input int _d2, output bit _value );
        _value = temp_static_packet_user_data[_d1][_d2];
    endfunction
    function void axi4stream_set_temp_static_packet_user_data( input int _d1, input int _d2, input bit _value );
        temp_static_packet_user_data[_d1][_d2] = _value;
    endfunction
    int temp_static_packet_valid_delay[];
    function void axi4stream_get_temp_static_packet_valid_delay( input int _d1, output int _value );
        _value = temp_static_packet_valid_delay[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_valid_delay( input int _d1, input int _value );
        temp_static_packet_valid_delay[_d1] = _value;
    endfunction
    int temp_static_packet_ready_delay[];
    function void axi4stream_get_temp_static_packet_ready_delay( input int _d1, output int _value );
        _value = temp_static_packet_ready_delay[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_ready_delay( input int _d1, input int _value );
        temp_static_packet_ready_delay[_d1] = _value;
    endfunction
    bit [((AXI4_DATA_WIDTH) - 1):0]  temp_static_transfer_data;
    function void axi4stream_get_temp_static_transfer_data( input int _d1, output bit  _value );
        _value = temp_static_transfer_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_data( input int _d1, input bit  _value );
        temp_static_transfer_data[_d1] = _value;
    endfunction
    axi4stream_byte_type_e temp_static_transfer_byte_type [((AXI4_DATA_WIDTH / 8) - 1):0];
    function void axi4stream_get_temp_static_transfer_byte_type( input int _d1, output axi4stream_byte_type_e _value );
        _value = temp_static_transfer_byte_type[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_byte_type( input int _d1, input axi4stream_byte_type_e _value );
        temp_static_transfer_byte_type[_d1] = _value;
    endfunction
    bit [((AXI4_ID_WIDTH) - 1):0]  temp_static_transfer_id;
    function void axi4stream_get_temp_static_transfer_id( input int _d1, output bit  _value );
        _value = temp_static_transfer_id[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_id( input int _d1, input bit  _value );
        temp_static_transfer_id[_d1] = _value;
    endfunction
    bit [((AXI4_DEST_WIDTH) - 1):0]  temp_static_transfer_dest;
    function void axi4stream_get_temp_static_transfer_dest( input int _d1, output bit  _value );
        _value = temp_static_transfer_dest[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_dest( input int _d1, input bit  _value );
        temp_static_transfer_dest[_d1] = _value;
    endfunction
    bit [((AXI4_USER_WIDTH) - 1):0]  temp_static_transfer_user_data;
    function void axi4stream_get_temp_static_transfer_user_data( input int _d1, output bit  _value );
        _value = temp_static_transfer_user_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_user_data( input int _d1, input bit  _value );
        temp_static_transfer_user_data[_d1] = _value;
    endfunction
    bit [((AXI4_DATA_WIDTH) - 1):0]  temp_static_cycle_data;
    function void axi4stream_get_temp_static_cycle_data( input int _d1, output bit  _value );
        _value = temp_static_cycle_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_data( input int _d1, input bit  _value );
        temp_static_cycle_data[_d1] = _value;
    endfunction
    bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  temp_static_cycle_strb;
    function void axi4stream_get_temp_static_cycle_strb( input int _d1, output bit  _value );
        _value = temp_static_cycle_strb[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_strb( input int _d1, input bit  _value );
        temp_static_cycle_strb[_d1] = _value;
    endfunction
    bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  temp_static_cycle_keep;
    function void axi4stream_get_temp_static_cycle_keep( input int _d1, output bit  _value );
        _value = temp_static_cycle_keep[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_keep( input int _d1, input bit  _value );
        temp_static_cycle_keep[_d1] = _value;
    endfunction
    bit [((AXI4_ID_WIDTH) - 1):0]  temp_static_cycle_id;
    function void axi4stream_get_temp_static_cycle_id( input int _d1, output bit  _value );
        _value = temp_static_cycle_id[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_id( input int _d1, input bit  _value );
        temp_static_cycle_id[_d1] = _value;
    endfunction
    bit [((AXI4_DEST_WIDTH) - 1):0]  temp_static_cycle_dest;
    function void axi4stream_get_temp_static_cycle_dest( input int _d1, output bit  _value );
        _value = temp_static_cycle_dest[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_dest( input int _d1, input bit  _value );
        temp_static_cycle_dest[_d1] = _value;
    endfunction
    bit [((AXI4_USER_WIDTH) - 1):0]  temp_static_cycle_user_data;
    function void axi4stream_get_temp_static_cycle_user_data( input int _d1, output bit  _value );
        _value = temp_static_cycle_user_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_user_data( input int _d1, input bit  _value );
        temp_static_cycle_user_data[_d1] = _value;
    endfunction
    task automatic dvc_put_packet
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        ref byte unsigned data[],
        ref axi4stream_byte_type_e byte_type[],
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        ref bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        ref int valid_delay[],
        ref int ready_delay[],
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
                automatic int data_DIMS0;
                automatic int byte_type_DIMS0;
                automatic int user_data_DIMS0;
                automatic int valid_delay_DIMS0;
                automatic int ready_delay_DIMS0;
            // Pass to CY the size of each open dimension (assumes rectangular arrays)
            // In addition copy any unsized or flexibly sized parameters to a related static variable which will be accessed element by element from the C
            data_DIMS0 = data.size();
            temp_static_packet_data = data;
            byte_type_DIMS0 = byte_type.size();
            temp_static_packet_byte_type = byte_type;
            temp_static_packet_id = id;
            temp_static_packet_dest = dest;
            user_data_DIMS0 = user_data.size();
            temp_static_packet_user_data = user_data;
            valid_delay_DIMS0 = valid_delay.size();
            temp_static_packet_valid_delay = valid_delay;
            ready_delay_DIMS0 = ready_delay.size();
            temp_static_packet_ready_delay = ready_delay;
            // Call function to provide sized params and ingoing unsized params sizes.
            axi4stream_packet_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, data_DIMS0, byte_type_DIMS0, user_data_DIMS0, valid_delay_DIMS0, ready_delay_DIMS0, _unit_id); // DPI call to imported task
            // Delete the storage allocated for the static variable(s)
            temp_static_packet_data.delete();
            temp_static_packet_byte_type.delete();
            temp_static_packet_user_data.delete();
            temp_static_packet_valid_delay.delete();
            temp_static_packet_ready_delay.delete();
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_get_packet
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        ref byte unsigned data[],
        ref axi4stream_byte_type_e byte_type[],
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        ref bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        ref int valid_delay[],
        ref int ready_delay[],
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin
            int _trans_id;

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
                automatic int data_DIMS0;
                automatic int byte_type_DIMS0;
                automatic int user_data_DIMS0;
                automatic int valid_delay_DIMS0;
                automatic int ready_delay_DIMS0;
            // Call function to get unsized params sizes.
            axi4stream_packet_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, _trans_id, data_DIMS0, byte_type_DIMS0, user_data_DIMS0, valid_delay_DIMS0, ready_delay_DIMS0, _unit_id, _using); // DPI call to imported task
            // Create each unsized param
            if (data_DIMS0 != 0)
            begin
                temp_static_packet_data = new [data_DIMS0];
            end
            else
            begin
                temp_static_packet_data.delete();
            end
            if (byte_type_DIMS0 != 0)
            begin
                temp_static_packet_byte_type = new [byte_type_DIMS0];
            end
            else
            begin
                temp_static_packet_byte_type.delete();
            end
            if (user_data_DIMS0 != 0)
            begin
                temp_static_packet_user_data = new [user_data_DIMS0];
            end
            else
            begin
                temp_static_packet_user_data.delete();
            end
            if (valid_delay_DIMS0 != 0)
            begin
                temp_static_packet_valid_delay = new [valid_delay_DIMS0];
            end
            else
            begin
                temp_static_packet_valid_delay.delete();
            end
            if (ready_delay_DIMS0 != 0)
            begin
                temp_static_packet_ready_delay = new [ready_delay_DIMS0];
            end
            else
            begin
                temp_static_packet_ready_delay.delete();
            end
            // Call function to get the sized params
            axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog(_comms_semantic,_as_end, _trans_id, _unit_id, _using); // DPI call to imported task
            // Copy unsized data from static variable(s) which has/have been set element by element from the C++
            // In addition delete the storage allocated for the static variable(s)
            data = temp_static_packet_data;
            temp_static_packet_data.delete();
            byte_type = temp_static_packet_byte_type;
            temp_static_packet_byte_type.delete();
            id = temp_static_packet_id;
            dest = temp_static_packet_dest;
            user_data = temp_static_packet_user_data;
            temp_static_packet_user_data.delete();
            valid_delay = temp_static_packet_valid_delay;
            temp_static_packet_valid_delay.delete();
            ready_delay = temp_static_packet_ready_delay;
            temp_static_packet_ready_delay.delete();
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_put_transfer
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        ref axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int valid_delay,
        input int ready_delay,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Pass to CY the size of each open dimension (assumes rectangular arrays)
            // In addition copy any unsized or flexibly sized parameters to a related static variable which will be accessed element by element from the C
            temp_static_transfer_data = data;
            temp_static_transfer_byte_type = byte_type;
            temp_static_transfer_id = id;
            temp_static_transfer_dest = dest;
            temp_static_transfer_user_data = user_data;
            // Call function to provide sized params and ingoing unsized params sizes.
            axi4stream_transfer_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, last, valid_delay, ready_delay, _unit_id); // DPI call to imported task
            // Delete the storage allocated for the static variable(s)
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_get_transfer
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        ref axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        output int valid_delay,
        output int ready_delay,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin
            int _trans_id;

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Call function to get unsized params sizes.
            axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, _trans_id, _unit_id, _using); // DPI call to imported task
            // Create each unsized param
            // Call function to get the sized params
            axi4stream_transfer_ReceivedReceivingReceive_open_SystemVerilog(_comms_semantic,_as_end, _trans_id, last, valid_delay, ready_delay, _unit_id, _using); // DPI call to imported task
            // Copy unsized data from static variable(s) which has/have been set element by element from the C++
            // In addition delete the storage allocated for the static variable(s)
            data = temp_static_transfer_data;
            byte_type = temp_static_transfer_byte_type;
            id = temp_static_transfer_id;
            dest = temp_static_transfer_dest;
            user_data = temp_static_transfer_user_data;
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_put_cycle
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Pass to CY the size of each open dimension (assumes rectangular arrays)
            // In addition copy any unsized or flexibly sized parameters to a related static variable which will be accessed element by element from the C
            temp_static_cycle_data = data;
            temp_static_cycle_strb = strb;
            temp_static_cycle_keep = keep;
            temp_static_cycle_id = id;
            temp_static_cycle_dest = dest;
            temp_static_cycle_user_data = user_data;
            // Call function to provide sized params and ingoing unsized params sizes.
            axi4stream_cycle_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, last, _unit_id); // DPI call to imported task
            // Delete the storage allocated for the static variable(s)
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_get_cycle
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin
            int _trans_id;

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Call function to get unsized params sizes.
            axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, _trans_id, _unit_id, _using); // DPI call to imported task
            // Create each unsized param
            // Call function to get the sized params
            axi4stream_cycle_ReceivedReceivingReceive_open_SystemVerilog(_comms_semantic,_as_end, _trans_id, last, _unit_id, _using); // DPI call to imported task
            // Copy unsized data from static variable(s) which has/have been set element by element from the C++
            // In addition delete the storage allocated for the static variable(s)
            data = temp_static_cycle_data;
            strb = temp_static_cycle_strb;
            keep = temp_static_cycle_keep;
            id = temp_static_cycle_id;
            dest = temp_static_cycle_dest;
            user_data = temp_static_cycle_user_data;
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_put_stream_ready
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit ready,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_stream_ready_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, ready, _unit_id); // DPI call to imported task
        end
    endtask

    task automatic dvc_get_stream_ready
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit ready,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, ready, _unit_id, _using); // DPI call to imported task
        end
    endtask


    //-------------------------------------------------------------------------
    // Generic Interface Configuration Support
    //

    import "DPI-C" context axi4stream_set_interface = function void axi4stream_set_interface
    (
        input int what,
        input int arg1,
        input int arg2,
        input int arg3,
        input int arg4,
        input int arg5,
        input int arg6,
        input int arg7,
        input int arg8,
        input int arg9,
        input int arg10
    );
    import "DPI-C" context axi4stream_get_interface = function int axi4stream_get_interface
    (
        input int what,
        input int arg1,
        input int arg2,
        input int arg3,
        input int arg4,
        input int arg5,
        input int arg6,
        input int arg7,
        input int arg8,
        input int arg9
    );


    //-------------------------------------------------------------------------
    // Functions to get the hierarchic name of this interface
    //
    import "DPI-C" context axi4stream_get_full_name = function string axi4stream_get_full_name();


    //-------------------------------------------------------------------------
    // Abstraction level Support
    //

    import "DPI-C" context axi4stream_set_master_end_abstraction_level =
    function void axi4stream_set_master_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_master_end_abstraction_level =
    function void axi4stream_get_master_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_slave_end_abstraction_level =
    function void axi4stream_set_slave_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_slave_end_abstraction_level =
    function void axi4stream_get_slave_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_clock_source_end_abstraction_level =
    function void axi4stream_set_clock_source_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_clock_source_end_abstraction_level =
    function void axi4stream_get_clock_source_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_reset_source_end_abstraction_level =
    function void axi4stream_set_reset_source_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_reset_source_end_abstraction_level =
    function void axi4stream_get_reset_source_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );

    //-------------------------------------------------------------------------
    // Wire Level Interface Support
    //
    logic internal_ACLK = 'z;
    logic internal_ARESETn = 'z;
    logic internal_TVALID = 'z;
    logic [((AXI4_DATA_WIDTH) - 1):0]  internal_TDATA = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  internal_TSTRB = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  internal_TKEEP = 'z;
    logic internal_TLAST = 'z;
    logic [((AXI4_ID_WIDTH) - 1):0]  internal_TID = 'z;
    logic [((AXI4_USER_WIDTH) - 1):0]  internal_TUSER = 'z;
    logic [((AXI4_DEST_WIDTH) - 1):0]  internal_TDEST = 'z;
    logic internal_TREADY = 'z;

    import "DPI-C" context function void axi4stream_set_ACLK_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit ACLK_param
    );
    import "DPI-C" context function void axi4stream_propagate_ACLK_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_ACLK_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit ACLK_param

    );
    export "DPI-C" function axi4stream_initialise_ACLK_from_CY;

    import "DPI-C" context function void axi4stream_set_ARESETn_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit ARESETn_param
    );
    import "DPI-C" context function void axi4stream_propagate_ARESETn_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_ARESETn_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit ARESETn_param

    );
    export "DPI-C" function axi4stream_initialise_ARESETn_from_CY;

    import "DPI-C" context function void axi4stream_set_TVALID_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TVALID_param
    );
    import "DPI-C" context function void axi4stream_propagate_TVALID_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TVALID_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TVALID_param

    );
    export "DPI-C" function axi4stream_initialise_TVALID_from_CY;

    import "DPI-C" context function void axi4stream_set_TDATA_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TDATA_param
    );
    import "DPI-C" context function void axi4stream_propagate_TDATA_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TDATA_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TDATA_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TDATA_from_CY;

    import "DPI-C" context function void axi4stream_set_TSTRB_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TSTRB_param
    );
    import "DPI-C" context function void axi4stream_propagate_TSTRB_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TSTRB_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TSTRB_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TSTRB_from_CY;

    import "DPI-C" context function void axi4stream_set_TKEEP_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TKEEP_param
    );
    import "DPI-C" context function void axi4stream_propagate_TKEEP_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TKEEP_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TKEEP_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TKEEP_from_CY;

    import "DPI-C" context function void axi4stream_set_TLAST_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TLAST_param
    );
    import "DPI-C" context function void axi4stream_propagate_TLAST_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TLAST_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TLAST_param

    );
    export "DPI-C" function axi4stream_initialise_TLAST_from_CY;

    import "DPI-C" context function void axi4stream_set_TID_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TID_param
    );
    import "DPI-C" context function void axi4stream_propagate_TID_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TID_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TID_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TID_from_CY;

    import "DPI-C" context function void axi4stream_set_TUSER_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TUSER_param
    );
    import "DPI-C" context function void axi4stream_propagate_TUSER_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TUSER_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TUSER_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TUSER_from_CY;

    import "DPI-C" context function void axi4stream_set_TDEST_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TDEST_param
    );
    import "DPI-C" context function void axi4stream_propagate_TDEST_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TDEST_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TDEST_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TDEST_from_CY;

    import "DPI-C" context function void axi4stream_set_TREADY_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TREADY_param
    );
    import "DPI-C" context function void axi4stream_propagate_TREADY_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TREADY_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TREADY_param

    );
    export "DPI-C" function axi4stream_initialise_TREADY_from_CY;

    import "DPI-C" context function void axi4stream_set_config_last_during_idle_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit config_last_during_idle_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_last_during_idle_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_last_during_idle_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit config_last_during_idle_param

    );
    export "DPI-C" function axi4stream_set_config_last_during_idle_from_CY;

    import "DPI-C" context function void axi4stream_set_config_enable_all_assertions_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit config_enable_all_assertions_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_enable_all_assertions_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_enable_all_assertions_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit config_enable_all_assertions_param

    );
    export "DPI-C" function axi4stream_set_config_enable_all_assertions_from_CY;

    import "DPI-C" context function void axi4stream_set_config_enable_assertion_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit [255:0] config_enable_assertion_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_enable_assertion_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_enable_assertion_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit [255:0] config_enable_assertion_param

    );
    export "DPI-C" function axi4stream_set_config_enable_assertion_from_CY;

    import "DPI-C" context function void axi4stream_set_config_burst_timeout_factor_from_SystemVerilog
    (
        input longint _iface_ref,
        input int unsigned config_burst_timeout_factor_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_burst_timeout_factor_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_burst_timeout_factor_into_SystemVerilog
    (
        input longint _iface_ref,
        output int unsigned config_burst_timeout_factor_param

    );
    export "DPI-C" function axi4stream_set_config_burst_timeout_factor_from_CY;

    import "DPI-C" context function void axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog
    (
        input longint _iface_ref,
        input int unsigned config_max_latency_TVALID_assertion_to_TREADY_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_max_latency_TVALID_assertion_to_TREADY_into_SystemVerilog
    (
        input longint _iface_ref,
        output int unsigned config_max_latency_TVALID_assertion_to_TREADY_param

    );
    export "DPI-C" function axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_CY;

    import "DPI-C" context function void axi4stream_set_config_setup_time_from_SystemVerilog
    (
        input longint _iface_ref,
        input longint unsigned config_setup_time_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_setup_time_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_setup_time_into_SystemVerilog
    (
        input longint _iface_ref,
        output longint unsigned config_setup_time_param

    );
    export "DPI-C" function axi4stream_set_config_setup_time_from_CY;

    import "DPI-C" context function void axi4stream_set_config_hold_time_from_SystemVerilog
    (
        input longint _iface_ref,
        input longint unsigned config_hold_time_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_hold_time_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_hold_time_into_SystemVerilog
    (
        input longint _iface_ref,
        output longint unsigned config_hold_time_param

    );
    export "DPI-C" function axi4stream_set_config_hold_time_from_CY;

    function void axi4stream_initialise_ACLK_from_CY();
        internal_ACLK = 'z;
        m_ACLK = 'z;
    endfunction

    function void axi4stream_initialise_ARESETn_from_CY();
        internal_ARESETn = 'z;
        m_ARESETn = 'z;
    endfunction

    function void axi4stream_initialise_TVALID_from_CY();
        internal_TVALID = 'z;
        m_TVALID = 'z;
    endfunction

    function void axi4stream_set_TDATA_from_CY_index1( int _this_dot_1, logic  TDATA_param );
        internal_TDATA[_this_dot_1] = TDATA_param;
    endfunction

    function void axi4stream_initialise_TDATA_from_CY();
        internal_TDATA = 'z;
        m_TDATA = 'z;
    endfunction

    function void axi4stream_set_TSTRB_from_CY_index1( int _this_dot_1, logic  TSTRB_param );
        internal_TSTRB[_this_dot_1] = TSTRB_param;
    endfunction

    function void axi4stream_initialise_TSTRB_from_CY();
        internal_TSTRB = 'z;
        m_TSTRB = 'z;
    endfunction

    function void axi4stream_set_TKEEP_from_CY_index1( int _this_dot_1, logic  TKEEP_param );
        internal_TKEEP[_this_dot_1] = TKEEP_param;
    endfunction

    function void axi4stream_initialise_TKEEP_from_CY();
        internal_TKEEP = 'z;
        m_TKEEP = 'z;
    endfunction

    function void axi4stream_initialise_TLAST_from_CY();
        internal_TLAST = 'z;
        m_TLAST = 'z;
    endfunction

    function void axi4stream_set_TID_from_CY_index1( int _this_dot_1, logic  TID_param );
        internal_TID[_this_dot_1] = TID_param;
    endfunction

    function void axi4stream_initialise_TID_from_CY();
        internal_TID = 'z;
        m_TID = 'z;
    endfunction

    function void axi4stream_set_TUSER_from_CY_index1( int _this_dot_1, logic  TUSER_param );
        internal_TUSER[_this_dot_1] = TUSER_param;
    endfunction

    function void axi4stream_initialise_TUSER_from_CY();
        internal_TUSER = 'z;
        m_TUSER = 'z;
    endfunction

    function void axi4stream_set_TDEST_from_CY_index1( int _this_dot_1, logic  TDEST_param );
        internal_TDEST[_this_dot_1] = TDEST_param;
    endfunction

    function void axi4stream_initialise_TDEST_from_CY();
        internal_TDEST = 'z;
        m_TDEST = 'z;
    endfunction

    function void axi4stream_initialise_TREADY_from_CY();
        internal_TREADY = 'z;
        m_TREADY = 'z;
    endfunction

    function void axi4stream_set_config_last_during_idle_from_CY( bit config_last_during_idle_param );
        config_last_during_idle = config_last_during_idle_param;
    endfunction

    function void axi4stream_set_config_enable_all_assertions_from_CY( bit config_enable_all_assertions_param );
        config_enable_all_assertions = config_enable_all_assertions_param;
    endfunction

    function void axi4stream_set_config_enable_assertion_from_CY( bit [255:0] config_enable_assertion_param );
        config_enable_assertion = config_enable_assertion_param;
    endfunction

    function void axi4stream_set_config_burst_timeout_factor_from_CY( int unsigned config_burst_timeout_factor_param );
        config_burst_timeout_factor = config_burst_timeout_factor_param;
    endfunction

    function void axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_CY( int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
        config_max_latency_TVALID_assertion_to_TREADY = config_max_latency_TVALID_assertion_to_TREADY_param;
    endfunction

    function void axi4stream_set_config_setup_time_from_CY( longint unsigned config_setup_time_param );
        config_setup_time = config_setup_time_param;
    endfunction

    function void axi4stream_set_config_hold_time_from_CY( longint unsigned config_hold_time_param );
        config_hold_time = config_hold_time_param;
    endfunction



    //--------------------------------------------------------------------------
    //
    // Group:- TLM Interface Support
    //
    //--------------------------------------------------------------------------
    export "DPI-C" axi4stream_get_temp_static_packet_data = function axi4stream_get_temp_static_packet_data;
    export "DPI-C" axi4stream_set_temp_static_packet_data = function axi4stream_set_temp_static_packet_data;
    export "DPI-C" axi4stream_get_temp_static_packet_byte_type = function axi4stream_get_temp_static_packet_byte_type;
    export "DPI-C" axi4stream_set_temp_static_packet_byte_type = function axi4stream_set_temp_static_packet_byte_type;
    export "DPI-C" axi4stream_get_temp_static_packet_id = function axi4stream_get_temp_static_packet_id;
    export "DPI-C" axi4stream_set_temp_static_packet_id = function axi4stream_set_temp_static_packet_id;
    export "DPI-C" axi4stream_get_temp_static_packet_dest = function axi4stream_get_temp_static_packet_dest;
    export "DPI-C" axi4stream_set_temp_static_packet_dest = function axi4stream_set_temp_static_packet_dest;
    export "DPI-C" axi4stream_get_temp_static_packet_user_data = function axi4stream_get_temp_static_packet_user_data;
    export "DPI-C" axi4stream_set_temp_static_packet_user_data = function axi4stream_set_temp_static_packet_user_data;
    export "DPI-C" axi4stream_get_temp_static_packet_valid_delay = function axi4stream_get_temp_static_packet_valid_delay;
    export "DPI-C" axi4stream_set_temp_static_packet_valid_delay = function axi4stream_set_temp_static_packet_valid_delay;
    export "DPI-C" axi4stream_get_temp_static_packet_ready_delay = function axi4stream_get_temp_static_packet_ready_delay;
    export "DPI-C" axi4stream_set_temp_static_packet_ready_delay = function axi4stream_set_temp_static_packet_ready_delay;
    import "DPI-C" context axi4stream_packet_SendSendingSent_SystemVerilog =
    task axi4stream_packet_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int data_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int byte_type_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int user_data_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int valid_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int ready_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int _unit_id
    );
    import "DPI-C" context axi4stream_packet_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_packet_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output int _trans_id,
        inout int data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int byte_type_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int user_data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int valid_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int ready_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog =
    task axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        input int _unit_id,
        input bit _using
    );
    export "DPI-C" axi4stream_get_temp_static_transfer_data = function axi4stream_get_temp_static_transfer_data;
    export "DPI-C" axi4stream_set_temp_static_transfer_data = function axi4stream_set_temp_static_transfer_data;
    export "DPI-C" axi4stream_get_temp_static_transfer_byte_type = function axi4stream_get_temp_static_transfer_byte_type;
    export "DPI-C" axi4stream_set_temp_static_transfer_byte_type = function axi4stream_set_temp_static_transfer_byte_type;
    export "DPI-C" axi4stream_get_temp_static_transfer_id = function axi4stream_get_temp_static_transfer_id;
    export "DPI-C" axi4stream_set_temp_static_transfer_id = function axi4stream_set_temp_static_transfer_id;
    export "DPI-C" axi4stream_get_temp_static_transfer_dest = function axi4stream_get_temp_static_transfer_dest;
    export "DPI-C" axi4stream_set_temp_static_transfer_dest = function axi4stream_set_temp_static_transfer_dest;
    export "DPI-C" axi4stream_get_temp_static_transfer_user_data = function axi4stream_get_temp_static_transfer_user_data;
    export "DPI-C" axi4stream_set_temp_static_transfer_user_data = function axi4stream_set_temp_static_transfer_user_data;
    import "DPI-C" context axi4stream_transfer_SendSendingSent_SystemVerilog =
    task axi4stream_transfer_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit last,
        input int valid_delay,
        input int ready_delay,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output int _trans_id,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_transfer_ReceivedReceivingReceive_open_SystemVerilog =
    task axi4stream_transfer_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        output bit last,
        output int valid_delay,
        output int ready_delay,
        input int _unit_id,
        input bit _using
    );
    export "DPI-C" axi4stream_get_temp_static_cycle_data = function axi4stream_get_temp_static_cycle_data;
    export "DPI-C" axi4stream_set_temp_static_cycle_data = function axi4stream_set_temp_static_cycle_data;
    export "DPI-C" axi4stream_get_temp_static_cycle_strb = function axi4stream_get_temp_static_cycle_strb;
    export "DPI-C" axi4stream_set_temp_static_cycle_strb = function axi4stream_set_temp_static_cycle_strb;
    export "DPI-C" axi4stream_get_temp_static_cycle_keep = function axi4stream_get_temp_static_cycle_keep;
    export "DPI-C" axi4stream_set_temp_static_cycle_keep = function axi4stream_set_temp_static_cycle_keep;
    export "DPI-C" axi4stream_get_temp_static_cycle_id = function axi4stream_get_temp_static_cycle_id;
    export "DPI-C" axi4stream_set_temp_static_cycle_id = function axi4stream_set_temp_static_cycle_id;
    export "DPI-C" axi4stream_get_temp_static_cycle_dest = function axi4stream_get_temp_static_cycle_dest;
    export "DPI-C" axi4stream_set_temp_static_cycle_dest = function axi4stream_set_temp_static_cycle_dest;
    export "DPI-C" axi4stream_get_temp_static_cycle_user_data = function axi4stream_get_temp_static_cycle_user_data;
    export "DPI-C" axi4stream_set_temp_static_cycle_user_data = function axi4stream_set_temp_static_cycle_user_data;
    import "DPI-C" context axi4stream_cycle_SendSendingSent_SystemVerilog =
    task axi4stream_cycle_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit last,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output int _trans_id,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_cycle_ReceivedReceivingReceive_open_SystemVerilog =
    task axi4stream_cycle_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        output bit last,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_stream_ready_SendSendingSent_SystemVerilog =
    task axi4stream_stream_ready_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit ready,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output bit ready,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_end_of_timestep_VPI_SystemVerilog =
    task axi4stream_end_of_timestep_VPI_SystemVerilog();
    // Waiter task and control
    reg wait_for_control = 0;

    always @(posedge wait_for_control)
    begin
        disable wait_for;
        wait_for_control = 0;
    end

    export "DPI-C" axi4stream_wait_for = task wait_for;

    task wait_for();
        begin
            wait(0 == 1);
        end
    endtask

    // Drive wires (from Cohesive) 
    assign ACLK = internal_ACLK;
    assign ARESETn = internal_ARESETn;
    assign TVALID = internal_TVALID;
    assign TDATA = internal_TDATA;
    assign TSTRB = internal_TSTRB;
    assign TKEEP = internal_TKEEP;
    assign TLAST = internal_TLAST;
    assign TID = internal_TID;
    assign TUSER = internal_TUSER;
    assign TDEST = internal_TDEST;
    assign TREADY = internal_TREADY;
    // Drive wires (from User) 
    assign ACLK = m_ACLK;
    assign ARESETn = m_ARESETn;
    assign TVALID = m_TVALID;
    assign TDATA = m_TDATA;
    assign TSTRB = m_TSTRB;
    assign TKEEP = m_TKEEP;
    assign TLAST = m_TLAST;
    assign TID = m_TID;
    assign TUSER = m_TUSER;
    assign TDEST = m_TDEST;
    assign TREADY = m_TREADY;

    reg ACLK_changed = 0;
    reg ARESETn_changed = 0;
    reg TVALID_changed = 0;
    reg TDATA_changed = 0;
    reg TSTRB_changed = 0;
    reg TKEEP_changed = 0;
    reg TLAST_changed = 0;
    reg TID_changed = 0;
    reg TUSER_changed = 0;
    reg TDEST_changed = 0;
    reg TREADY_changed = 0;
    reg config_last_during_idle_changed = 0;
    reg config_enable_all_assertions_changed = 0;
    reg config_enable_assertion_changed = 0;
    reg config_burst_timeout_factor_changed = 0;
    reg config_max_latency_TVALID_assertion_to_TREADY_changed = 0;
    reg config_setup_time_changed = 0;
    reg config_hold_time_changed = 0;

    reg end_of_timestep_control = 0;

    // Start end_of_timestep timer
    initial
    forever
    begin
        wait_end_of_timestep();
    end


    event non_blocking_end_of_timestep_control;

    export "DPI-C" axi4stream_wait_end_of_timestep = task wait_end_of_timestep;

    task wait_end_of_timestep();
        begin
            @(non_blocking_end_of_timestep_control);
            axi4stream_end_of_timestep_VPI_SystemVerilog();
        end
    endtask

    always @( posedge end_of_timestep_control or posedge _check_t0_values )
    begin
        if ( end_of_timestep_control == 1 )
        begin
            ->> non_blocking_end_of_timestep_control;
            end_of_timestep_control = 0;
        end
    end


    // SV wire change monitors

    function automatic void axi4stream_local_set_ACLK_from_SystemVerilog(  );
            axi4stream_set_ACLK_from_SystemVerilog( _interface_ref, ACLK); // DPI call to imported task
        
        axi4stream_propagate_ACLK_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( ACLK or posedge _check_t0_values )
    begin
        axi4stream_local_set_ACLK_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_ARESETn_from_SystemVerilog(  );
            axi4stream_set_ARESETn_from_SystemVerilog( _interface_ref, ARESETn); // DPI call to imported task
        
        axi4stream_propagate_ARESETn_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( ARESETn or posedge _check_t0_values )
    begin
        axi4stream_local_set_ARESETn_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TVALID_from_SystemVerilog(  );
            axi4stream_set_TVALID_from_SystemVerilog( _interface_ref, TVALID); // DPI call to imported task
        
        axi4stream_propagate_TVALID_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TVALID or posedge _check_t0_values )
    begin
        axi4stream_local_set_TVALID_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TDATA_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_DATA_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TDATA_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TDATA[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TDATA_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TDATA or posedge _check_t0_values )
    begin
        axi4stream_local_set_TDATA_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TSTRB_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( (AXI4_DATA_WIDTH / 8) ); _this_dot_1++)
        begin
            axi4stream_set_TSTRB_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TSTRB[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TSTRB_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TSTRB or posedge _check_t0_values )
    begin
        axi4stream_local_set_TSTRB_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TKEEP_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( (AXI4_DATA_WIDTH / 8) ); _this_dot_1++)
        begin
            axi4stream_set_TKEEP_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TKEEP[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TKEEP_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TKEEP or posedge _check_t0_values )
    begin
        axi4stream_local_set_TKEEP_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TLAST_from_SystemVerilog(  );
            axi4stream_set_TLAST_from_SystemVerilog( _interface_ref, TLAST); // DPI call to imported task
        
        axi4stream_propagate_TLAST_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TLAST or posedge _check_t0_values )
    begin
        axi4stream_local_set_TLAST_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TID_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_ID_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TID_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TID[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TID_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TID or posedge _check_t0_values )
    begin
        axi4stream_local_set_TID_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TUSER_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_USER_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TUSER_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TUSER[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TUSER_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TUSER or posedge _check_t0_values )
    begin
        axi4stream_local_set_TUSER_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TDEST_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_DEST_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TDEST_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TDEST[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TDEST_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TDEST or posedge _check_t0_values )
    begin
        axi4stream_local_set_TDEST_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TREADY_from_SystemVerilog(  );
            axi4stream_set_TREADY_from_SystemVerilog( _interface_ref, TREADY); // DPI call to imported task
        
        axi4stream_propagate_TREADY_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TREADY or posedge _check_t0_values )
    begin
        axi4stream_local_set_TREADY_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end


    // CY wire and variable changed flag monitors

    always @(posedge ACLK_changed or posedge _check_t0_values )
    begin
        while (ACLK_changed == 1'b1)
        begin
            axi4stream_get_ACLK_into_SystemVerilog( _interface_ref, internal_ACLK ); // DPI call to imported task
            ACLK_changed = 1'b0;
            #0  #0 if ( ACLK !== internal_ACLK )
            begin
                axi4stream_local_set_ACLK_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge ARESETn_changed or posedge _check_t0_values )
    begin
        while (ARESETn_changed == 1'b1)
        begin
            axi4stream_get_ARESETn_into_SystemVerilog( _interface_ref, internal_ARESETn ); // DPI call to imported task
            ARESETn_changed = 1'b0;
            #0  #0 if ( ARESETn !== internal_ARESETn )
            begin
                axi4stream_local_set_ARESETn_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TVALID_changed or posedge _check_t0_values )
    begin
        while (TVALID_changed == 1'b1)
        begin
            axi4stream_get_TVALID_into_SystemVerilog( _interface_ref, internal_TVALID ); // DPI call to imported task
            TVALID_changed = 1'b0;
            #0  #0 if ( TVALID !== internal_TVALID )
            begin
                axi4stream_local_set_TVALID_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TDATA_changed or posedge _check_t0_values )
    begin
        while (TDATA_changed == 1'b1)
        begin
            axi4stream_get_TDATA_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TDATA_changed = 1'b0;
            #0  #0 if ( TDATA !== internal_TDATA )
            begin
                axi4stream_local_set_TDATA_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TSTRB_changed or posedge _check_t0_values )
    begin
        while (TSTRB_changed == 1'b1)
        begin
            axi4stream_get_TSTRB_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TSTRB_changed = 1'b0;
            #0  #0 if ( TSTRB !== internal_TSTRB )
            begin
                axi4stream_local_set_TSTRB_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TKEEP_changed or posedge _check_t0_values )
    begin
        while (TKEEP_changed == 1'b1)
        begin
            axi4stream_get_TKEEP_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TKEEP_changed = 1'b0;
            #0  #0 if ( TKEEP !== internal_TKEEP )
            begin
                axi4stream_local_set_TKEEP_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TLAST_changed or posedge _check_t0_values )
    begin
        while (TLAST_changed == 1'b1)
        begin
            axi4stream_get_TLAST_into_SystemVerilog( _interface_ref, internal_TLAST ); // DPI call to imported task
            TLAST_changed = 1'b0;
            #0  #0 if ( TLAST !== internal_TLAST )
            begin
                axi4stream_local_set_TLAST_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TID_changed or posedge _check_t0_values )
    begin
        while (TID_changed == 1'b1)
        begin
            axi4stream_get_TID_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TID_changed = 1'b0;
            #0  #0 if ( TID !== internal_TID )
            begin
                axi4stream_local_set_TID_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TUSER_changed or posedge _check_t0_values )
    begin
        while (TUSER_changed == 1'b1)
        begin
            axi4stream_get_TUSER_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TUSER_changed = 1'b0;
            #0  #0 if ( TUSER !== internal_TUSER )
            begin
                axi4stream_local_set_TUSER_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TDEST_changed or posedge _check_t0_values )
    begin
        while (TDEST_changed == 1'b1)
        begin
            axi4stream_get_TDEST_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TDEST_changed = 1'b0;
            #0  #0 if ( TDEST !== internal_TDEST )
            begin
                axi4stream_local_set_TDEST_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TREADY_changed or posedge _check_t0_values )
    begin
        while (TREADY_changed == 1'b1)
        begin
            axi4stream_get_TREADY_into_SystemVerilog( _interface_ref, internal_TREADY ); // DPI call to imported task
            TREADY_changed = 1'b0;
            #0  #0 if ( TREADY !== internal_TREADY )
            begin
                axi4stream_local_set_TREADY_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge config_last_during_idle_changed or posedge _check_t0_values )
    begin
        if (config_last_during_idle_changed == 1'b1)
        begin
            axi4stream_get_config_last_during_idle_into_SystemVerilog( _interface_ref, config_last_during_idle ); // DPI call to imported task
            config_last_during_idle_changed = 1'b0;
        end
    end

    always @(posedge config_enable_all_assertions_changed or posedge _check_t0_values )
    begin
        if (config_enable_all_assertions_changed == 1'b1)
        begin
            axi4stream_get_config_enable_all_assertions_into_SystemVerilog( _interface_ref, config_enable_all_assertions ); // DPI call to imported task
            config_enable_all_assertions_changed = 1'b0;
        end
    end

    always @(posedge config_enable_assertion_changed or posedge _check_t0_values )
    begin
        if (config_enable_assertion_changed == 1'b1)
        begin
            axi4stream_get_config_enable_assertion_into_SystemVerilog( _interface_ref, config_enable_assertion ); // DPI call to imported task
            config_enable_assertion_changed = 1'b0;
        end
    end

    always @(posedge config_burst_timeout_factor_changed or posedge _check_t0_values )
    begin
        if (config_burst_timeout_factor_changed == 1'b1)
        begin
            axi4stream_get_config_burst_timeout_factor_into_SystemVerilog( _interface_ref, config_burst_timeout_factor ); // DPI call to imported task
            config_burst_timeout_factor_changed = 1'b0;
        end
    end

    always @(posedge config_max_latency_TVALID_assertion_to_TREADY_changed or posedge _check_t0_values )
    begin
        if (config_max_latency_TVALID_assertion_to_TREADY_changed == 1'b1)
        begin
            axi4stream_get_config_max_latency_TVALID_assertion_to_TREADY_into_SystemVerilog( _interface_ref, config_max_latency_TVALID_assertion_to_TREADY ); // DPI call to imported task
            config_max_latency_TVALID_assertion_to_TREADY_changed = 1'b0;
        end
    end

    always @(posedge config_setup_time_changed or posedge _check_t0_values )
    begin
        if (config_setup_time_changed == 1'b1)
        begin
            axi4stream_get_config_setup_time_into_SystemVerilog( _interface_ref, config_setup_time ); // DPI call to imported task
            config_setup_time_changed = 1'b0;
        end
    end

    always @(posedge config_hold_time_changed or posedge _check_t0_values )
    begin
        if (config_hold_time_changed == 1'b1)
        begin
            axi4stream_get_config_hold_time_into_SystemVerilog( _interface_ref, config_hold_time ); // DPI call to imported task
            config_hold_time_changed = 1'b0;
        end
    end


    //--------------------------------------------------------------------------------
    // Task which blocks and outputs an error if the interface has not initialized properly
    //--------------------------------------------------------------------------------

    task _initialized();
        if (_interface_ref == 0)
        begin
            $display("Error: %m - Questa Verification IP failed to initialise. Please check questa_mvc.log for details");
            wait(_interface_ref!=0);
        end
    endtask

endinterface

`endif // INCA
`ifdef VCS
// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// SystemVerilog           Version: 20160107
// *****************************************************************************

import QUESTA_MVC::questa_mvc_reporter;
import QUESTA_MVC::questa_mvc_item_comms_semantic;
import QUESTA_MVC::questa_mvc_edge;
import QUESTA_MVC::QUESTA_MVC_POSEDGE;
import QUESTA_MVC::QUESTA_MVC_NEGEDGE;
import QUESTA_MVC::QUESTA_MVC_ANYEDGE;
import QUESTA_MVC::QUESTA_MVC_0_TO_1_EDGE;
import QUESTA_MVC::QUESTA_MVC_1_TO_0_EDGE;


(* cy_so="libaxi4stream_IN_SystemVerilog_MTI_full" *)
(* on_lib_load="axi4stream_IN_SystemVerilog_load" *)

interface mgc_common_axi4stream #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024)
    (input wire iACLK, input wire iARESETn);

    //-------------------------------------------------------------------------
    //
    // Group: AXI4STREAM Signals
    //
    //-------------------------------------------------------------------------



    //-------------------------------------------------------------------------
    // Private wires
    //-------------------------------------------------------------------------
    wire ACLK;
    wire ARESETn;
    wire TVALID;
    wire [((AXI4_DATA_WIDTH) - 1):0]  TDATA;
    wire [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB;
    wire [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP;
    wire TLAST;
    wire [((AXI4_ID_WIDTH) - 1):0]  TID;
    wire [((AXI4_USER_WIDTH) - 1):0]  TUSER;
    wire [((AXI4_DEST_WIDTH) - 1):0]  TDEST;
    wire TREADY;



    // Propagate global signals onto interface wires
    assign ACLK = iACLK;
    assign ARESETn = iARESETn;

    // Variable: config_last_during_idle
    //
    //  Sets the value of TLAST signal during idle.
    // When set to 1'b0 then this indicates that TLAST will be driven 0 during idle.
    // When set to 1'b1 then TLAST will be driven 1 during idle.
    // 
    //    Default: 0
    // 
    //
    // mentor configurator specification name "TLAST value during idle"
    bit config_last_during_idle;

    // Variable: config_enable_all_assertions
    //
    //  Enables all protocol assertions. 
    //      
    //      Default: 1
    //   
    //
    // mentor configurator specification name "Enable all protocol assertions"
    bit config_enable_all_assertions;

    // Variable: config_enable_assertion
    //
    // 
    //     Enables individual protocol assertion.
    //     This variable controls whether specific assertion within QVIP (of type <axi4stream_assertion_e>) is enabled or disabled.
    //     Individual assertion can be disabled as follows:-
    //     //-----------------------------------------------------------------------
    //     // < BFM interface>.set_config_enable_assertion_index1(<name of assertion>,1'b0);
    //     //-----------------------------------------------------------------------
    //     
    //     For example, the assertion AXI4STREAM_TLAST_X can be disabled as follows:
    //     <bfm>.set_config_enable_assertion_index1(AXI4STREAM_TLAST_X, 1'b0); 
    //     
    //     Here bfm is the AXI4STREAM interface instance name for which the assertion to be disabled. 
    //     
    //     Default: All assertions are enabled
    //   
    //
    // mentor configurator specification name "Enable individual protocol assertion"
    bit [255:0] config_enable_assertion;

    // 
    // //-----------------------------------------------------------------------------
    // Group: Timeout Control
    // //-----------------------------------------------------------------------------
    // 


    // Variable: config_burst_timeout_factor
    //
    //  Sets maximum timeout value (in terms of clock) between phases of transaction.
    // 
    //    Default: 10000 clock cycles.
    // 
    //
    // mentor configurator specification name "Burst timeout between individual phases of a transaction"
    int unsigned config_burst_timeout_factor;

    // Variable: config_max_latency_TVALID_assertion_to_TREADY
    //
    //  
    // Sets maximum timeout period (in terms of clock) from assertion of TVALID to assertion of TREADY.
    // An error message AXI4STREAM_TREADY_NOT_ASSERTED_AFTER_TVALID is generated if TREADY is not asserted
    // after assertion of TVALID within this period. 
    // 
    // Default: 10000 clock cycles
    // 
    //
    // mentor configurator specification name "Timeout from TVALID to TREADY assertion"
    int unsigned config_max_latency_TVALID_assertion_to_TREADY;

    // Variable: config_setup_time
    //
    // 
    //      Sets number of simulation time units from the setup time to the active 
    //      clock edge of clock. The setup time will always be less than the time period
    //      of the clock. 
    //     
    //      Default:0
    //    
    //
    // Note - This configuration variable is used in an expression involving time precision.
    //        To ensure its value is correct, use questa_mvc_sv_convert_to_precision API of QUESTA_MVC package.
    //
    longint unsigned config_setup_time;

    // Variable: config_hold_time
    //
    // 
    //      Sets number of simulation time units from the hold time to the active 
    //      clock edge of clock. 
    //     
    //      Default:0
    //    
    //
    // Note - This configuration variable is used in an expression involving time precision.
    //        To ensure its value is correct, use questa_mvc_sv_convert_to_precision API of QUESTA_MVC package.
    //
    longint unsigned config_hold_time;
    //------------------------------------------------------------------------------
    // Group:- Interface ends
    //------------------------------------------------------------------------------
    //
    longint axi4stream_master_end;


    // Function:- get_axi4stream_master_end
    //
    // Returns a handle to the <master> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_master_end();
        return axi4stream_master_end;
    endfunction

    longint axi4stream_slave_end;


    // Function:- get_axi4stream_slave_end
    //
    // Returns a handle to the <slave> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_slave_end();
        return axi4stream_slave_end;
    endfunction

    longint axi4stream_clock_source_end;


    // Function:- get_axi4stream_clock_source_end
    //
    // Returns a handle to the <clock_source> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_clock_source_end();
        return axi4stream_clock_source_end;
    endfunction

    longint axi4stream_reset_source_end;


    // Function:- get_axi4stream_reset_source_end
    //
    // Returns a handle to the <reset_source> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream_reset_source_end();
        return axi4stream_reset_source_end;
    endfunction

    longint axi4stream__monitor_end;


    // Function:- get_axi4stream__monitor_end
    //
    // Returns a handle to the <_monitor> end of this instance of the <axi4stream> interface.

    function longint get_axi4stream__monitor_end();
        return axi4stream__monitor_end;
    endfunction


    // Group:- Abstraction Levels
    // 
    // These functions are used set or get the abstraction levels of an interface end.
    // See <Abstraction Levels of Interface Ends> for more details on the meaning of
    // TLM or WLM connected and the valid combinations.


    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_master_abstraction_level
    //
    //     Function to set whether the <master> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_master_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_master_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_master_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <master> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_master_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_master_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_slave_abstraction_level
    //
    //     Function to set whether the <slave> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_slave_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_slave_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_slave_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <slave> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_slave_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_slave_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_clock_source_abstraction_level
    //
    //     Function to set whether the <clock_source> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_clock_source_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_clock_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_clock_source_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <clock_source> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_clock_source_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_clock_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_set_reset_source_abstraction_level
    //
    //     Function to set whether the <reset_source> end of the interface is WLM
    //     or TLM connected. See <Abstraction Levels of Interface Ends> for a
    //     description of abstraction levels, how they affect the behaviour of the
    //     QVIP, and guidelines for setting them.
    //
    // Arguments:
    //    wire_level - Set to 1 to be WLM connected.
    //    TLM_level -  Set to 1 to be TLM connected.
    //
    function void axi4stream_set_reset_source_abstraction_level
    (
        input bit          wire_level,
        input bit          TLM_level
    );
        axi4stream_set_reset_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- axi4stream_get_reset_source_abstraction_level
    //
    //     Function to return the Abstraction level setting for the <reset_source> end.
    //     See <Abstraction Levels of Interface Ends> for a description of abstraction
    //     levels and how they affect the behaviour of the Questa Verification IP.
    //
    // Arguments:
    //
    //    wire_level - Value = 1 if this end is WLM connected.
    //    TLM_level -  Value = 1 if this end is TLM connected.
    //------------------------------------------------------------------------------
    function void axi4stream_get_reset_source_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
        axi4stream_get_reset_source_end_abstraction_level( wire_level, TLM_level );
    endfunction

    import "DPI-C" context function longint axi4stream_initialise_SystemVerilog
    (
        int    usage_code,
        string iface_version,
        output longint master_end,
        output longint slave_end,
        output longint clock_source_end,
        output longint reset_source_end,
        output longint _monitor_end,
        input int AXI4_ID_WIDTH,
        input int AXI4_USER_WIDTH,
        input int AXI4_DEST_WIDTH,
        input int AXI4_DATA_WIDTH
    );

    `ifndef MVC_axi4stream_VERSION
    `define MVC_axi4stream_VERSION ""
    `endif
    // Handle to the linkage
    (* elab_init *) longint _interface_ref =
                                axi4stream_initialise_SystemVerilog
                                (
                                    18102076,
                                    `MVC_axi4stream_VERSION,
                                    axi4stream_master_end,
                                    axi4stream_slave_end,
                                    axi4stream_clock_source_end,
                                    axi4stream_reset_source_end,
                                    axi4stream__monitor_end,
                                    AXI4_ID_WIDTH,
                                    AXI4_USER_WIDTH,
                                    AXI4_DEST_WIDTH,
                                    AXI4_DATA_WIDTH
                                ); // DPI call to create transactor (called at
                                     // elaboration time as initialiser)

        bit report_available;

        // Function for getting a message from QUESTA_MVC. Returns 1 if a message was returned, 0 otherwise.
        import "DPI-C" questa_mvc_sv_get_report =  function bit get_report( input longint iface_ref,input longint recipient,
                                     output string category,     output string objectName,
                                     output string instanceName, output string error_no,
                                     output string typ,          output string mess );
        questa_mvc_reporter endPoint[longint];
        initial report_available = 0;

        always @report_available
        begin
            longint recipient;
            string category;
            string objectName;
            string instanceName;
            string severity;
            string mess;
            string error_no;

            if ( endPoint.first( recipient ) )
              begin
                do
                  begin
                      while ( get_report( _interface_ref, recipient, category, objectName, instanceName, error_no, severity, mess ) )
                        begin
                          endPoint[recipient].report_message( category, "axi4stream", 0, objectName, instanceName, error_no, severity, mess );
                        end
                  end
                while (endPoint.next(recipient));
              end
            report_available = 0;
        end

        import "DPI-C" context questa_mvc_register_end_point = function void questa_mvc_register_end_point( input longint iface_ref, input longint as_end, input string name );

        // A function for registering a reporter to capture any reports coming from as_end
        function automatic void register_end_point( input longint as_end, input questa_mvc_reporter rep = null );
            if ( rep != null )
              begin
                if ( ( rep.name == "" ) || ( rep.name == "NULL" ) )
                  begin
                    $display("Error: %m: Reporter passed to register_end_point has a reserved name. Neither an empty string nor the string 'NULL' can be used.");
                  end
                else
                  begin
                    questa_mvc_register_end_point( _interface_ref, as_end, rep.name );
                    endPoint[as_end] = rep;
                  end
              end
            else
              begin
                questa_mvc_register_end_point( _interface_ref, as_end, "NULL" );
                endPoint.delete( as_end );
              end
        endfunction

    //-------------------------------------------------------------------------
    //
    // Group:- Registering Reports
    //
    //
    // The following methods are used to register a custom reporting object as
    // described in the Questa Verification IP base library section, <Customizing Error-Reporting>.
    // 
    //-------------------------------------------------------------------------

    function void register_interface_reporter( input questa_mvc_reporter _rep = null );
        register_end_point( _interface_ref, _rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_master_reporter
    //
    // Function used to register a reporter for the <master> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the master end.
    //
    function void register_master_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_master_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_slave_reporter
    //
    // Function used to register a reporter for the <slave> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the slave end.
    //
    function void register_slave_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_slave_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_clock_source_reporter
    //
    // Function used to register a reporter for the <clock_source> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the clock_source end.
    //
    function void register_clock_source_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_clock_source_end, rep );
    endfunction

    //-------------------------------------------------------------------------
    // Function:- register_reset_source_reporter
    //
    // Function used to register a reporter for the <reset_source> end of the
    // <axi4stream> interface. See <Customizing Error-Reporting> for a
    // description of creating, customising and using reporters.
    //
    // Arguments:
    //    rep - The reporter to be used for the reset_source end.
    //
    function void register_reset_source_reporter
    (
        input questa_mvc_reporter rep = null
    );
        register_end_point( axi4stream_reset_source_end, rep );
    endfunction


    // Declare user visible wires variables, for non-continuous assignments.
    logic m_ACLK = 'z;
    logic m_ARESETn = 'z;
    logic m_TVALID = 'z;
    logic [((AXI4_DATA_WIDTH) - 1):0]  m_TDATA = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  m_TSTRB = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  m_TKEEP = 'z;
    logic m_TLAST = 'z;
    logic [((AXI4_ID_WIDTH) - 1):0]  m_TID = 'z;
    logic [((AXI4_USER_WIDTH) - 1):0]  m_TUSER = 'z;
    logic [((AXI4_DEST_WIDTH) - 1):0]  m_TDEST = 'z;
    logic m_TREADY = 'z;

    // Forces a sweep through the wire change checkers at time 0 to get around
    // process kick-off order unknowns
    bit _check_t0_values;
    always_comb _check_t0_values = 1;

    // handle control
    longint last_handle = 0;

    longint last_start_time = 0;

    longint last_end_time = 0;

    export "DPI-C" axi4stream_set_last_handle_and_times = function set_last_handle_and_times;

    function void set_last_handle_and_times(longint _handle, longint _start, longint _end);
        last_handle = _handle;
        last_start_time = _start;
        last_end_time = _end;
    endfunction


    function longint get_last_handle();
        return last_handle;
    endfunction


    function longint get_last_start_time();
        return last_start_time;
    endfunction


    function longint get_last_end_time();
        return last_end_time;
    endfunction


    //-------------------------------------------------------------------------
    // Tasks to wait for a number of specified edges on a wire
    //-------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Function:- wait_for_ACLK
    //     Wait for the specified change on wire <axi4stream::ACLK>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_ACLK( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge ACLK);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge ACLK);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        ACLK);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( ACLK === 0 );
                    @( ACLK );
                end
                while ( ACLK !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( ACLK === 1 );
                    @( ACLK );
                end
                while ( ACLK !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_ARESETn
    //     Wait for the specified change on wire <axi4stream::ARESETn>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_ARESETn( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge ARESETn);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge ARESETn);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        ARESETn);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( ARESETn === 0 );
                    @( ARESETn );
                end
                while ( ARESETn !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( ARESETn === 1 );
                    @( ARESETn );
                end
                while ( ARESETn !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TVALID
    //     Wait for the specified change on wire <axi4stream::TVALID>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TVALID( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TVALID);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TVALID);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TVALID);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TVALID === 0 );
                    @( TVALID );
                end
                while ( TVALID !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TVALID === 1 );
                    @( TVALID );
                end
                while ( TVALID !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDATA
    //     Wait for the specified change on wire <axi4stream::TDATA>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDATA( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDATA);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDATA);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDATA);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDATA === 0 );
                    @( TDATA );
                end
                while ( TDATA !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDATA === 1 );
                    @( TDATA );
                end
                while ( TDATA !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDATA_index1
    //     Wait for the specified change on wire <axi4stream::TDATA>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDATA_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDATA[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDATA[_this_dot_1] === 0 );
                    @( TDATA[_this_dot_1] );
                end
                while ( TDATA[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDATA[_this_dot_1] === 1 );
                    @( TDATA[_this_dot_1] );
                end
                while ( TDATA[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TSTRB
    //     Wait for the specified change on wire <axi4stream::TSTRB>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TSTRB( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TSTRB);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TSTRB);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TSTRB);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TSTRB === 0 );
                    @( TSTRB );
                end
                while ( TSTRB !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TSTRB === 1 );
                    @( TSTRB );
                end
                while ( TSTRB !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TSTRB_index1
    //     Wait for the specified change on wire <axi4stream::TSTRB>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TSTRB_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TSTRB[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TSTRB[_this_dot_1] === 0 );
                    @( TSTRB[_this_dot_1] );
                end
                while ( TSTRB[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TSTRB[_this_dot_1] === 1 );
                    @( TSTRB[_this_dot_1] );
                end
                while ( TSTRB[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TKEEP
    //     Wait for the specified change on wire <axi4stream::TKEEP>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TKEEP( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TKEEP);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TKEEP);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TKEEP);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TKEEP === 0 );
                    @( TKEEP );
                end
                while ( TKEEP !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TKEEP === 1 );
                    @( TKEEP );
                end
                while ( TKEEP !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TKEEP_index1
    //     Wait for the specified change on wire <axi4stream::TKEEP>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TKEEP_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TKEEP[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TKEEP[_this_dot_1] === 0 );
                    @( TKEEP[_this_dot_1] );
                end
                while ( TKEEP[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TKEEP[_this_dot_1] === 1 );
                    @( TKEEP[_this_dot_1] );
                end
                while ( TKEEP[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TLAST
    //     Wait for the specified change on wire <axi4stream::TLAST>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TLAST( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TLAST);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TLAST);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TLAST);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TLAST === 0 );
                    @( TLAST );
                end
                while ( TLAST !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TLAST === 1 );
                    @( TLAST );
                end
                while ( TLAST !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TID
    //     Wait for the specified change on wire <axi4stream::TID>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TID( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TID);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TID);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TID);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TID === 0 );
                    @( TID );
                end
                while ( TID !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TID === 1 );
                    @( TID );
                end
                while ( TID !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TID_index1
    //     Wait for the specified change on wire <axi4stream::TID>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TID_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TID[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TID[_this_dot_1] === 0 );
                    @( TID[_this_dot_1] );
                end
                while ( TID[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TID[_this_dot_1] === 1 );
                    @( TID[_this_dot_1] );
                end
                while ( TID[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TUSER
    //     Wait for the specified change on wire <axi4stream::TUSER>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TUSER( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TUSER);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TUSER);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TUSER);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TUSER === 0 );
                    @( TUSER );
                end
                while ( TUSER !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TUSER === 1 );
                    @( TUSER );
                end
                while ( TUSER !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TUSER_index1
    //     Wait for the specified change on wire <axi4stream::TUSER>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TUSER_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TUSER[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TUSER[_this_dot_1] === 0 );
                    @( TUSER[_this_dot_1] );
                end
                while ( TUSER[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TUSER[_this_dot_1] === 1 );
                    @( TUSER[_this_dot_1] );
                end
                while ( TUSER[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDEST
    //     Wait for the specified change on wire <axi4stream::TDEST>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDEST( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDEST);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDEST);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDEST);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDEST === 0 );
                    @( TDEST );
                end
                while ( TDEST !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDEST === 1 );
                    @( TDEST );
                end
                while ( TDEST !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TDEST_index1
    //     Wait for the specified change on wire <axi4stream::TDEST>.
    //
    // Arguments:
    //    _this_dot_1 - The array index for dimension 1.
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TDEST_index1( input int _this_dot_1, input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TDEST[_this_dot_1]);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TDEST[_this_dot_1] === 0 );
                    @( TDEST[_this_dot_1] );
                end
                while ( TDEST[_this_dot_1] !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TDEST[_this_dot_1] === 1 );
                    @( TDEST[_this_dot_1] );
                end
                while ( TDEST[_this_dot_1] !== 0 );
            end
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_TREADY
    //     Wait for the specified change on wire <axi4stream::TREADY>.
    //
    // Arguments:
    //     which_edge - The type of edge to wait for, one of <questa_mvc_edge>.
    //     count - The number of edges to wait for.
    //
    task automatic wait_for_TREADY( input questa_mvc_edge which_edge, input int count = 1 );
        int i;
        for ( i=0; i<count; i++ )
        begin
            if      ( which_edge == QUESTA_MVC_POSEDGE     ) @(posedge TREADY);
            else if ( which_edge == QUESTA_MVC_NEGEDGE     ) @(negedge TREADY);
            else if ( which_edge == QUESTA_MVC_ANYEDGE     ) @(        TREADY);
            else if ( which_edge == QUESTA_MVC_0_TO_1_EDGE )
            begin
                do
                begin
                    wait( TREADY === 0 );
                    @( TREADY );
                end
                while ( TREADY !== 1 );
            end
            else if ( which_edge == QUESTA_MVC_1_TO_0_EDGE )
            begin
                do
                begin
                    wait( TREADY === 1 );
                    @( TREADY );
                end
                while ( TREADY !== 0 );
            end
        end
    endtask

    //-------------------------------------------------------------------------
    // Tasks/functions to set/get wires
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- set_ACLK
    //-------------------------------------------------------------------------
    //     Set the value of wire <ACLK>.
    //
    // Parameters:
    //     ACLK_param - The value to set onto wire <ACLK>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_ACLK( logic ACLK_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_ACLK = ACLK_param;
        else
            m_ACLK <= ACLK_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_ACLK
    //-------------------------------------------------------------------------
    //     Get the value of wire <ACLK>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <ACLK>.
    //
    function automatic logic get_ACLK(  );
        return ACLK;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_ARESETn
    //-------------------------------------------------------------------------
    //     Set the value of wire <ARESETn>.
    //
    // Parameters:
    //     ARESETn_param - The value to set onto wire <ARESETn>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_ARESETn( logic ARESETn_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_ARESETn = ARESETn_param;
        else
            m_ARESETn <= ARESETn_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_ARESETn
    //-------------------------------------------------------------------------
    //     Get the value of wire <ARESETn>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <ARESETn>.
    //
    function automatic logic get_ARESETn(  );
        return ARESETn;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TVALID
    //-------------------------------------------------------------------------
    //     Set the value of wire <TVALID>.
    //
    // Parameters:
    //     TVALID_param - The value to set onto wire <TVALID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TVALID( logic TVALID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TVALID = TVALID_param;
        else
            m_TVALID <= TVALID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TVALID
    //-------------------------------------------------------------------------
    //     Get the value of wire <TVALID>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TVALID>.
    //
    function automatic logic get_TVALID(  );
        return TVALID;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TDATA
    //-------------------------------------------------------------------------
    //     Set the value of wire <TDATA>.
    //
    // Parameters:
    //     TDATA_param - The value to set onto wire <TDATA>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDATA( logic [((AXI4_DATA_WIDTH) - 1):0]  TDATA_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDATA = TDATA_param;
        else
            m_TDATA <= TDATA_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TDATA_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TDATA>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TDATA_param - The value to set onto wire <TDATA>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDATA_index1( int _this_dot_1, logic  TDATA_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDATA[_this_dot_1] = TDATA_param;
        else
            m_TDATA[_this_dot_1] <= TDATA_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TDATA
    //-------------------------------------------------------------------------
    //     Get the value of wire <TDATA>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TDATA>.
    //
    function automatic logic [((AXI4_DATA_WIDTH) - 1):0]   get_TDATA(  );
        return TDATA;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TDATA_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TDATA>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TDATA>.
    //
    function automatic logic   get_TDATA_index1( int _this_dot_1 );
        return TDATA[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TSTRB
    //-------------------------------------------------------------------------
    //     Set the value of wire <TSTRB>.
    //
    // Parameters:
    //     TSTRB_param - The value to set onto wire <TSTRB>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TSTRB( logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TSTRB = TSTRB_param;
        else
            m_TSTRB <= TSTRB_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TSTRB_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TSTRB>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TSTRB_param - The value to set onto wire <TSTRB>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TSTRB_index1( int _this_dot_1, logic  TSTRB_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TSTRB[_this_dot_1] = TSTRB_param;
        else
            m_TSTRB[_this_dot_1] <= TSTRB_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TSTRB
    //-------------------------------------------------------------------------
    //     Get the value of wire <TSTRB>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TSTRB>.
    //
    function automatic logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]   get_TSTRB(  );
        return TSTRB;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TSTRB_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TSTRB>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TSTRB>.
    //
    function automatic logic   get_TSTRB_index1( int _this_dot_1 );
        return TSTRB[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TKEEP
    //-------------------------------------------------------------------------
    //     Set the value of wire <TKEEP>.
    //
    // Parameters:
    //     TKEEP_param - The value to set onto wire <TKEEP>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TKEEP( logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TKEEP = TKEEP_param;
        else
            m_TKEEP <= TKEEP_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TKEEP_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TKEEP>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TKEEP_param - The value to set onto wire <TKEEP>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TKEEP_index1( int _this_dot_1, logic  TKEEP_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TKEEP[_this_dot_1] = TKEEP_param;
        else
            m_TKEEP[_this_dot_1] <= TKEEP_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TKEEP
    //-------------------------------------------------------------------------
    //     Get the value of wire <TKEEP>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TKEEP>.
    //
    function automatic logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]   get_TKEEP(  );
        return TKEEP;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TKEEP_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TKEEP>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TKEEP>.
    //
    function automatic logic   get_TKEEP_index1( int _this_dot_1 );
        return TKEEP[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TLAST
    //-------------------------------------------------------------------------
    //     Set the value of wire <TLAST>.
    //
    // Parameters:
    //     TLAST_param - The value to set onto wire <TLAST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TLAST( logic TLAST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TLAST = TLAST_param;
        else
            m_TLAST <= TLAST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TLAST
    //-------------------------------------------------------------------------
    //     Get the value of wire <TLAST>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TLAST>.
    //
    function automatic logic get_TLAST(  );
        return TLAST;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TID
    //-------------------------------------------------------------------------
    //     Set the value of wire <TID>.
    //
    // Parameters:
    //     TID_param - The value to set onto wire <TID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TID( logic [((AXI4_ID_WIDTH) - 1):0]  TID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TID = TID_param;
        else
            m_TID <= TID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TID_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TID>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TID_param - The value to set onto wire <TID>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TID_index1( int _this_dot_1, logic  TID_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TID[_this_dot_1] = TID_param;
        else
            m_TID[_this_dot_1] <= TID_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TID
    //-------------------------------------------------------------------------
    //     Get the value of wire <TID>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TID>.
    //
    function automatic logic [((AXI4_ID_WIDTH) - 1):0]   get_TID(  );
        return TID;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TID_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TID>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TID>.
    //
    function automatic logic   get_TID_index1( int _this_dot_1 );
        return TID[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TUSER
    //-------------------------------------------------------------------------
    //     Set the value of wire <TUSER>.
    //
    // Parameters:
    //     TUSER_param - The value to set onto wire <TUSER>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TUSER( logic [((AXI4_USER_WIDTH) - 1):0]  TUSER_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TUSER = TUSER_param;
        else
            m_TUSER <= TUSER_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TUSER_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TUSER>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TUSER_param - The value to set onto wire <TUSER>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TUSER_index1( int _this_dot_1, logic  TUSER_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TUSER[_this_dot_1] = TUSER_param;
        else
            m_TUSER[_this_dot_1] <= TUSER_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TUSER
    //-------------------------------------------------------------------------
    //     Get the value of wire <TUSER>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TUSER>.
    //
    function automatic logic [((AXI4_USER_WIDTH) - 1):0]   get_TUSER(  );
        return TUSER;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TUSER_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TUSER>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TUSER>.
    //
    function automatic logic   get_TUSER_index1( int _this_dot_1 );
        return TUSER[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TDEST
    //-------------------------------------------------------------------------
    //     Set the value of wire <TDEST>.
    //
    // Parameters:
    //     TDEST_param - The value to set onto wire <TDEST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDEST( logic [((AXI4_DEST_WIDTH) - 1):0]  TDEST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDEST = TDEST_param;
        else
            m_TDEST <= TDEST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- set_TDEST_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of wire <TDEST>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     TDEST_param - The value to set onto wire <TDEST>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TDEST_index1( int _this_dot_1, logic  TDEST_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TDEST[_this_dot_1] = TDEST_param;
        else
            m_TDEST[_this_dot_1] <= TDEST_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TDEST
    //-------------------------------------------------------------------------
    //     Get the value of wire <TDEST>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TDEST>.
    //
    function automatic logic [((AXI4_DEST_WIDTH) - 1):0]   get_TDEST(  );
        return TDEST;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_TDEST_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of wire <TDEST>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the wire <TDEST>.
    //
    function automatic logic   get_TDEST_index1( int _this_dot_1 );
        return TDEST[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_TREADY
    //-------------------------------------------------------------------------
    //     Set the value of wire <TREADY>.
    //
    // Parameters:
    //     TREADY_param - The value to set onto wire <TREADY>.
    //     non_blocking - Set to 1 for a non-blocking assignment.
    //
    task automatic set_TREADY( logic TREADY_param = 'z, bit non_blocking = 1'b0 );
        if ( non_blocking == 1'b0 )
            m_TREADY = TREADY_param;
        else
            m_TREADY <= TREADY_param;
    endtask


    //-------------------------------------------------------------------------
    // Function:- get_TREADY
    //-------------------------------------------------------------------------
    //     Get the value of wire <TREADY>.
    //
    // Parameters:
    //
    // Returns the current value of the wire <TREADY>.
    //
    function automatic logic get_TREADY(  );
        return TREADY;
    endfunction

    //-------------------------------------------------------------------------
    // Tasks to wait for a change to a global variable with read access
    //-------------------------------------------------------------------------


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_last_during_idle
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_last_during_idle>.
    //
    task automatic wait_for_config_last_during_idle(  );
        begin
            @( config_last_during_idle );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_all_assertions
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_all_assertions>.
    //
    task automatic wait_for_config_enable_all_assertions(  );
        begin
            @( config_enable_all_assertions );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_assertion
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_assertion>.
    //
    task automatic wait_for_config_enable_assertion(  );
        begin
            @( config_enable_assertion );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_enable_assertion_index1
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    task automatic wait_for_config_enable_assertion_index1( input int _this_dot_1 );
        begin
            @( config_enable_assertion[_this_dot_1] );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_burst_timeout_factor
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_burst_timeout_factor>.
    //
    task automatic wait_for_config_burst_timeout_factor(  );
        begin
            @( config_burst_timeout_factor );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_max_latency_TVALID_assertion_to_TREADY
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_max_latency_TVALID_assertion_to_TREADY>.
    //
    task automatic wait_for_config_max_latency_TVALID_assertion_to_TREADY(  );
        begin
            @( config_max_latency_TVALID_assertion_to_TREADY );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_setup_time
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_setup_time>.
    //
    task automatic wait_for_config_setup_time(  );
        begin
            @( config_setup_time );
        end
    endtask


    //------------------------------------------------------------------------------
    // Function:- wait_for_config_hold_time
    //------------------------------------------------------------------------------
    //     Wait for a change on variable <axi4stream::config_hold_time>.
    //
    task automatic wait_for_config_hold_time(  );
        begin
            @( config_hold_time );
        end
    endtask


    //-------------------------------------------------------------------------
    // Functions to set global variables with write access
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- set_config_last_during_idle
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_last_during_idle>.
    //
    // Parameters:
    //     config_last_during_idle_param - The value to assign to variable <config_last_during_idle>.
    //
    function automatic void set_config_last_during_idle( bit config_last_during_idle_param );
        config_last_during_idle = config_last_during_idle_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_all_assertions
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_enable_all_assertions>.
    //
    // Parameters:
    //     config_enable_all_assertions_param - The value to assign to variable <config_enable_all_assertions>.
    //
    function automatic void set_config_enable_all_assertions( bit config_enable_all_assertions_param );
        config_enable_all_assertions = config_enable_all_assertions_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_assertion
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_enable_assertion>.
    //
    // Parameters:
    //     config_enable_assertion_param - The value to assign to variable <config_enable_assertion>.
    //
    function automatic void set_config_enable_assertion( bit [255:0] config_enable_assertion_param );
        config_enable_assertion = config_enable_assertion_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_enable_assertion_index1
    //-------------------------------------------------------------------------
    //     Set the value of one element of variable <config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //     config_enable_assertion_param - The value to assign to variable <config_enable_assertion>.
    //
    function automatic void set_config_enable_assertion_index1( int _this_dot_1, bit  config_enable_assertion_param );
        config_enable_assertion[_this_dot_1] = config_enable_assertion_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_burst_timeout_factor
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_burst_timeout_factor>.
    //
    // Parameters:
    //     config_burst_timeout_factor_param - The value to assign to variable <config_burst_timeout_factor>.
    //
    function automatic void set_config_burst_timeout_factor( int unsigned config_burst_timeout_factor_param );
        config_burst_timeout_factor = config_burst_timeout_factor_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_max_latency_TVALID_assertion_to_TREADY
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    // Parameters:
    //     config_max_latency_TVALID_assertion_to_TREADY_param - The value to assign to variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    function automatic void set_config_max_latency_TVALID_assertion_to_TREADY( int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
        config_max_latency_TVALID_assertion_to_TREADY = config_max_latency_TVALID_assertion_to_TREADY_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_setup_time
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_setup_time>.
    //
    // Parameters:
    //     config_setup_time_param - The value to assign to variable <config_setup_time>.
    //
    function automatic void set_config_setup_time( longint unsigned config_setup_time_param );
        config_setup_time = config_setup_time_param;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- set_config_hold_time
    //-------------------------------------------------------------------------
    //     Set the value of variable <config_hold_time>.
    //
    // Parameters:
    //     config_hold_time_param - The value to assign to variable <config_hold_time>.
    //
    function automatic void set_config_hold_time( longint unsigned config_hold_time_param );
        config_hold_time = config_hold_time_param;
    endfunction


    //-------------------------------------------------------------------------
    // Functions to get global variables with read access
    //-------------------------------------------------------------------------


    //-------------------------------------------------------------------------
    // Function:- get_config_last_during_idle
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_last_during_idle>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_last_during_idle>.
    //
    function automatic bit get_config_last_during_idle(  );
        return config_last_during_idle;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_all_assertions
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_enable_all_assertions>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_enable_all_assertions>.
    //
    function automatic bit get_config_enable_all_assertions(  );
        return config_enable_all_assertions;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_assertion
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_enable_assertion>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_enable_assertion>.
    //
    function automatic bit [255:0]  get_config_enable_assertion(  );
        return config_enable_assertion;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_enable_assertion_index1
    //-------------------------------------------------------------------------
    //     Get the value of one element of variable <config_enable_assertion>.
    //
    // Parameters:
    //    _this_dot_1 - The array index for dimension 1.
    //
    // Returns the current value of the variable <config_enable_assertion>.
    //
    function automatic bit   get_config_enable_assertion_index1( int _this_dot_1 );
        return config_enable_assertion[_this_dot_1];
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_burst_timeout_factor
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_burst_timeout_factor>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_burst_timeout_factor>.
    //
    function automatic int unsigned get_config_burst_timeout_factor(  );
        return config_burst_timeout_factor;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_max_latency_TVALID_assertion_to_TREADY
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_max_latency_TVALID_assertion_to_TREADY>.
    //
    function automatic int unsigned get_config_max_latency_TVALID_assertion_to_TREADY(  );
        return config_max_latency_TVALID_assertion_to_TREADY;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_setup_time
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_setup_time>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_setup_time>.
    //
    function automatic longint unsigned get_config_setup_time(  );
        return config_setup_time;
    endfunction


    //-------------------------------------------------------------------------
    // Function:- get_config_hold_time
    //-------------------------------------------------------------------------
    //     Get the value of variable <config_hold_time>.
    //
    // Parameters:
    //
    // Returns the current value of the variable <config_hold_time>.
    //
    function automatic longint unsigned get_config_hold_time(  );
        return config_hold_time;
    endfunction


    //-------------------------------------------------------------------------
    // Functions to set/get generic interface configuration
    //-------------------------------------------------------------------------

    function void set_interface
    (
        input int what = 0,
        input int arg1 = 0,
        input int arg2 = 0,
        input int arg3 = 0,
        input int arg4 = 0,
        input int arg5 = 0,
        input int arg6 = 0,
        input int arg7 = 0,
        input int arg8 = 0,
        input int arg9 = 0,
        input int arg10 = 0
    );
        axi4stream_set_interface( what, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 );
    endfunction

    function int get_interface
    (
        input int what = 0,
        input int arg1 = 0,
        input int arg2 = 0,
        input int arg3 = 0,
        input int arg4 = 0,
        input int arg5 = 0,
        input int arg6 = 0,
        input int arg7 = 0,
        input int arg8 = 0,
        input int arg9 = 0
    );
        return axi4stream_get_interface( what, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 );
    endfunction

    //-------------------------------------------------------------------------
    // Functions to get the hierarchic name of this interface
    //-------------------------------------------------------------------------
    function string get_full_name();
        return axi4stream_get_full_name();
    endfunction

    //--------------------------------------------------------------------------
    //
    // Group:- Monitor Value Change on Variable
    //
    //--------------------------------------------------------------------------

    function automatic void axi4stream_local_set_config_last_during_idle_from_SystemVerilog( ref bit config_last_during_idle_param );
            axi4stream_set_config_last_during_idle_from_SystemVerilog( _interface_ref,config_last_during_idle); // DPI call to imported task
        
            axi4stream_propagate_config_last_during_idle_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_last_during_idle_from_SystemVerilog( config_last_during_idle );
            end
        end
    end

    function automatic void axi4stream_local_set_config_enable_all_assertions_from_SystemVerilog( ref bit config_enable_all_assertions_param );
            axi4stream_set_config_enable_all_assertions_from_SystemVerilog( _interface_ref,config_enable_all_assertions); // DPI call to imported task
        
            axi4stream_propagate_config_enable_all_assertions_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_enable_all_assertions_from_SystemVerilog( config_enable_all_assertions );
            end
        end
    end

    function automatic void axi4stream_local_set_config_enable_assertion_from_SystemVerilog( ref bit [255:0] config_enable_assertion_param );
            axi4stream_set_config_enable_assertion_from_SystemVerilog( _interface_ref,config_enable_assertion); // DPI call to imported task
        
            axi4stream_propagate_config_enable_assertion_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_enable_assertion_from_SystemVerilog( config_enable_assertion );
            end
        end
    end

    function automatic void axi4stream_local_set_config_burst_timeout_factor_from_SystemVerilog( ref int unsigned config_burst_timeout_factor_param );
            axi4stream_set_config_burst_timeout_factor_from_SystemVerilog( _interface_ref,config_burst_timeout_factor); // DPI call to imported task
        
            axi4stream_propagate_config_burst_timeout_factor_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_burst_timeout_factor_from_SystemVerilog( config_burst_timeout_factor );
            end
        end
    end

    function automatic void axi4stream_local_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( ref int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
            axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( _interface_ref,config_max_latency_TVALID_assertion_to_TREADY); // DPI call to imported task
        
            axi4stream_propagate_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog( config_max_latency_TVALID_assertion_to_TREADY );
            end
        end
    end

    function automatic void axi4stream_local_set_config_setup_time_from_SystemVerilog( ref longint unsigned config_setup_time_param );
            axi4stream_set_config_setup_time_from_SystemVerilog( _interface_ref,config_setup_time); // DPI call to imported task
        
            axi4stream_propagate_config_setup_time_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_setup_time_from_SystemVerilog( config_setup_time );
            end
        end
    end

    function automatic void axi4stream_local_set_config_hold_time_from_SystemVerilog( ref longint unsigned config_hold_time_param );
            axi4stream_set_config_hold_time_from_SystemVerilog( _interface_ref,config_hold_time); // DPI call to imported task
        
            axi4stream_propagate_config_hold_time_from_SystemVerilog( _interface_ref ); // DPI call to imported task
    endfunction

    initial
    begin
        begin
            wait(_interface_ref != 0);
            forever
            begin
                @( * ) axi4stream_local_set_config_hold_time_from_SystemVerilog( config_hold_time );
            end
        end
    end

    //-------------------------------------------------------------------------
    // Transaction interface
    //-------------------------------------------------------------------------

    byte unsigned temp_static_packet_data[];
    function void axi4stream_get_temp_static_packet_data( input int _d1, output byte unsigned _value );
        _value = temp_static_packet_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_data( input int _d1, input byte unsigned _value );
        temp_static_packet_data[_d1] = _value;
    endfunction
    axi4stream_byte_type_e temp_static_packet_byte_type[];
    function void axi4stream_get_temp_static_packet_byte_type( input int _d1, output axi4stream_byte_type_e _value );
        _value = temp_static_packet_byte_type[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_byte_type( input int _d1, input axi4stream_byte_type_e _value );
        temp_static_packet_byte_type[_d1] = _value;
    endfunction
    bit [((AXI4_ID_WIDTH) - 1):0]  temp_static_packet_id;
    function void axi4stream_get_temp_static_packet_id( input int _d1, output bit  _value );
        _value = temp_static_packet_id[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_id( input int _d1, input bit  _value );
        temp_static_packet_id[_d1] = _value;
    endfunction
    bit [((AXI4_DEST_WIDTH) - 1):0]  temp_static_packet_dest;
    function void axi4stream_get_temp_static_packet_dest( input int _d1, output bit  _value );
        _value = temp_static_packet_dest[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_dest( input int _d1, input bit  _value );
        temp_static_packet_dest[_d1] = _value;
    endfunction
    bit [((AXI4_USER_WIDTH) - 1):0] temp_static_packet_user_data [];
    function void axi4stream_get_temp_static_packet_user_data( input int _d1, input int _d2, output bit _value );
        _value = temp_static_packet_user_data[_d1][_d2];
    endfunction
    function void axi4stream_set_temp_static_packet_user_data( input int _d1, input int _d2, input bit _value );
        temp_static_packet_user_data[_d1][_d2] = _value;
    endfunction
    int temp_static_packet_valid_delay[];
    function void axi4stream_get_temp_static_packet_valid_delay( input int _d1, output int _value );
        _value = temp_static_packet_valid_delay[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_valid_delay( input int _d1, input int _value );
        temp_static_packet_valid_delay[_d1] = _value;
    endfunction
    int temp_static_packet_ready_delay[];
    function void axi4stream_get_temp_static_packet_ready_delay( input int _d1, output int _value );
        _value = temp_static_packet_ready_delay[_d1];
    endfunction
    function void axi4stream_set_temp_static_packet_ready_delay( input int _d1, input int _value );
        temp_static_packet_ready_delay[_d1] = _value;
    endfunction
    bit [((AXI4_DATA_WIDTH) - 1):0]  temp_static_transfer_data;
    function void axi4stream_get_temp_static_transfer_data( input int _d1, output bit  _value );
        _value = temp_static_transfer_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_data( input int _d1, input bit  _value );
        temp_static_transfer_data[_d1] = _value;
    endfunction
    axi4stream_byte_type_e temp_static_transfer_byte_type [((AXI4_DATA_WIDTH / 8) - 1):0];
    function void axi4stream_get_temp_static_transfer_byte_type( input int _d1, output axi4stream_byte_type_e _value );
        _value = temp_static_transfer_byte_type[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_byte_type( input int _d1, input axi4stream_byte_type_e _value );
        temp_static_transfer_byte_type[_d1] = _value;
    endfunction
    bit [((AXI4_ID_WIDTH) - 1):0]  temp_static_transfer_id;
    function void axi4stream_get_temp_static_transfer_id( input int _d1, output bit  _value );
        _value = temp_static_transfer_id[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_id( input int _d1, input bit  _value );
        temp_static_transfer_id[_d1] = _value;
    endfunction
    bit [((AXI4_DEST_WIDTH) - 1):0]  temp_static_transfer_dest;
    function void axi4stream_get_temp_static_transfer_dest( input int _d1, output bit  _value );
        _value = temp_static_transfer_dest[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_dest( input int _d1, input bit  _value );
        temp_static_transfer_dest[_d1] = _value;
    endfunction
    bit [((AXI4_USER_WIDTH) - 1):0]  temp_static_transfer_user_data;
    function void axi4stream_get_temp_static_transfer_user_data( input int _d1, output bit  _value );
        _value = temp_static_transfer_user_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_transfer_user_data( input int _d1, input bit  _value );
        temp_static_transfer_user_data[_d1] = _value;
    endfunction
    bit [((AXI4_DATA_WIDTH) - 1):0]  temp_static_cycle_data;
    function void axi4stream_get_temp_static_cycle_data( input int _d1, output bit  _value );
        _value = temp_static_cycle_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_data( input int _d1, input bit  _value );
        temp_static_cycle_data[_d1] = _value;
    endfunction
    bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  temp_static_cycle_strb;
    function void axi4stream_get_temp_static_cycle_strb( input int _d1, output bit  _value );
        _value = temp_static_cycle_strb[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_strb( input int _d1, input bit  _value );
        temp_static_cycle_strb[_d1] = _value;
    endfunction
    bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  temp_static_cycle_keep;
    function void axi4stream_get_temp_static_cycle_keep( input int _d1, output bit  _value );
        _value = temp_static_cycle_keep[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_keep( input int _d1, input bit  _value );
        temp_static_cycle_keep[_d1] = _value;
    endfunction
    bit [((AXI4_ID_WIDTH) - 1):0]  temp_static_cycle_id;
    function void axi4stream_get_temp_static_cycle_id( input int _d1, output bit  _value );
        _value = temp_static_cycle_id[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_id( input int _d1, input bit  _value );
        temp_static_cycle_id[_d1] = _value;
    endfunction
    bit [((AXI4_DEST_WIDTH) - 1):0]  temp_static_cycle_dest;
    function void axi4stream_get_temp_static_cycle_dest( input int _d1, output bit  _value );
        _value = temp_static_cycle_dest[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_dest( input int _d1, input bit  _value );
        temp_static_cycle_dest[_d1] = _value;
    endfunction
    bit [((AXI4_USER_WIDTH) - 1):0]  temp_static_cycle_user_data;
    function void axi4stream_get_temp_static_cycle_user_data( input int _d1, output bit  _value );
        _value = temp_static_cycle_user_data[_d1];
    endfunction
    function void axi4stream_set_temp_static_cycle_user_data( input int _d1, input bit  _value );
        temp_static_cycle_user_data[_d1] = _value;
    endfunction
    task automatic dvc_put_packet
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        ref byte unsigned data[],
        ref axi4stream_byte_type_e byte_type[],
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        ref bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        ref int valid_delay[],
        ref int ready_delay[],
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
                automatic int data_DIMS0;
                automatic int byte_type_DIMS0;
                automatic int user_data_DIMS0;
                automatic int valid_delay_DIMS0;
                automatic int ready_delay_DIMS0;
            // Pass to CY the size of each open dimension (assumes rectangular arrays)
            // In addition copy any unsized or flexibly sized parameters to a related static variable which will be accessed element by element from the C
            data_DIMS0 = data.size();
            temp_static_packet_data = data;
            byte_type_DIMS0 = byte_type.size();
            temp_static_packet_byte_type = byte_type;
            temp_static_packet_id = id;
            temp_static_packet_dest = dest;
            user_data_DIMS0 = user_data.size();
            temp_static_packet_user_data = user_data;
            valid_delay_DIMS0 = valid_delay.size();
            temp_static_packet_valid_delay = valid_delay;
            ready_delay_DIMS0 = ready_delay.size();
            temp_static_packet_ready_delay = ready_delay;
            // Call function to provide sized params and ingoing unsized params sizes.
            axi4stream_packet_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, data_DIMS0, byte_type_DIMS0, user_data_DIMS0, valid_delay_DIMS0, ready_delay_DIMS0, _unit_id); // DPI call to imported task
            // Delete the storage allocated for the static variable(s)
            temp_static_packet_data.delete();
            temp_static_packet_byte_type.delete();
            temp_static_packet_user_data.delete();
            temp_static_packet_valid_delay.delete();
            temp_static_packet_ready_delay.delete();
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_get_packet
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        ref byte unsigned data[],
        ref axi4stream_byte_type_e byte_type[],
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        ref bit [((AXI4_USER_WIDTH) - 1):0] user_data [],
        ref int valid_delay[],
        ref int ready_delay[],
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin
            int _trans_id;

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
                automatic int data_DIMS0;
                automatic int byte_type_DIMS0;
                automatic int user_data_DIMS0;
                automatic int valid_delay_DIMS0;
                automatic int ready_delay_DIMS0;
            // Call function to get unsized params sizes.
            axi4stream_packet_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, _trans_id, data_DIMS0, byte_type_DIMS0, user_data_DIMS0, valid_delay_DIMS0, ready_delay_DIMS0, _unit_id, _using); // DPI call to imported task
            // Create each unsized param
            if (data_DIMS0 != 0)
            begin
                temp_static_packet_data = new [data_DIMS0];
            end
            else
            begin
                temp_static_packet_data.delete();
            end
            if (byte_type_DIMS0 != 0)
            begin
                temp_static_packet_byte_type = new [byte_type_DIMS0];
            end
            else
            begin
                temp_static_packet_byte_type.delete();
            end
            if (user_data_DIMS0 != 0)
            begin
                temp_static_packet_user_data = new [user_data_DIMS0];
            end
            else
            begin
                temp_static_packet_user_data.delete();
            end
            if (valid_delay_DIMS0 != 0)
            begin
                temp_static_packet_valid_delay = new [valid_delay_DIMS0];
            end
            else
            begin
                temp_static_packet_valid_delay.delete();
            end
            if (ready_delay_DIMS0 != 0)
            begin
                temp_static_packet_ready_delay = new [ready_delay_DIMS0];
            end
            else
            begin
                temp_static_packet_ready_delay.delete();
            end
            // Call function to get the sized params
            axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog(_comms_semantic,_as_end, _trans_id, _unit_id, _using); // DPI call to imported task
            // Copy unsized data from static variable(s) which has/have been set element by element from the C++
            // In addition delete the storage allocated for the static variable(s)
            data = temp_static_packet_data;
            temp_static_packet_data.delete();
            byte_type = temp_static_packet_byte_type;
            temp_static_packet_byte_type.delete();
            id = temp_static_packet_id;
            dest = temp_static_packet_dest;
            user_data = temp_static_packet_user_data;
            temp_static_packet_user_data.delete();
            valid_delay = temp_static_packet_valid_delay;
            temp_static_packet_valid_delay.delete();
            ready_delay = temp_static_packet_ready_delay;
            temp_static_packet_ready_delay.delete();
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_put_transfer
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        ref axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int valid_delay,
        input int ready_delay,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Pass to CY the size of each open dimension (assumes rectangular arrays)
            // In addition copy any unsized or flexibly sized parameters to a related static variable which will be accessed element by element from the C
            temp_static_transfer_data = data;
            temp_static_transfer_byte_type = byte_type;
            temp_static_transfer_id = id;
            temp_static_transfer_dest = dest;
            temp_static_transfer_user_data = user_data;
            // Call function to provide sized params and ingoing unsized params sizes.
            axi4stream_transfer_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, last, valid_delay, ready_delay, _unit_id); // DPI call to imported task
            // Delete the storage allocated for the static variable(s)
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_get_transfer
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        ref axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0],
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        output int valid_delay,
        output int ready_delay,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin
            int _trans_id;

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Call function to get unsized params sizes.
            axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, _trans_id, _unit_id, _using); // DPI call to imported task
            // Create each unsized param
            // Call function to get the sized params
            axi4stream_transfer_ReceivedReceivingReceive_open_SystemVerilog(_comms_semantic,_as_end, _trans_id, last, valid_delay, ready_delay, _unit_id, _using); // DPI call to imported task
            // Copy unsized data from static variable(s) which has/have been set element by element from the C++
            // In addition delete the storage allocated for the static variable(s)
            data = temp_static_transfer_data;
            byte_type = temp_static_transfer_byte_type;
            id = temp_static_transfer_id;
            dest = temp_static_transfer_dest;
            user_data = temp_static_transfer_user_data;
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_put_cycle
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        input bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        input bit last,
        input bit [((AXI4_ID_WIDTH) - 1):0]  id,
        input bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        input bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Pass to CY the size of each open dimension (assumes rectangular arrays)
            // In addition copy any unsized or flexibly sized parameters to a related static variable which will be accessed element by element from the C
            temp_static_cycle_data = data;
            temp_static_cycle_strb = strb;
            temp_static_cycle_keep = keep;
            temp_static_cycle_id = id;
            temp_static_cycle_dest = dest;
            temp_static_cycle_user_data = user_data;
            // Call function to provide sized params and ingoing unsized params sizes.
            axi4stream_cycle_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, last, _unit_id); // DPI call to imported task
            // Delete the storage allocated for the static variable(s)
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_get_cycle
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit [((AXI4_DATA_WIDTH) - 1):0]  data,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  strb,
        output bit [(((AXI4_DATA_WIDTH / 8)) - 1):0]  keep,
        output bit last,
        output bit [((AXI4_ID_WIDTH) - 1):0]  id,
        output bit [((AXI4_DEST_WIDTH) - 1):0]  dest,
        output bit [((AXI4_USER_WIDTH) - 1):0]  user_data,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin
            int _trans_id;

            wait(_interface_ref != 0);

            // the real code .....
            // Create an array to hold the unsized dims for each param (..._DIMS)
            begin // Block to create unsized data arrays
            // Call function to get unsized params sizes.
            axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, _trans_id, _unit_id, _using); // DPI call to imported task
            // Create each unsized param
            // Call function to get the sized params
            axi4stream_cycle_ReceivedReceivingReceive_open_SystemVerilog(_comms_semantic,_as_end, _trans_id, last, _unit_id, _using); // DPI call to imported task
            // Copy unsized data from static variable(s) which has/have been set element by element from the C++
            // In addition delete the storage allocated for the static variable(s)
            data = temp_static_cycle_data;
            strb = temp_static_cycle_strb;
            keep = temp_static_cycle_keep;
            id = temp_static_cycle_id;
            dest = temp_static_cycle_dest;
            user_data = temp_static_cycle_user_data;
            end // Block to create unsized data arrays
        end
    endtask

    task automatic dvc_put_stream_ready
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        input bit ready,
        input int _unit_id = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_stream_ready_SendSendingSent_SystemVerilog(_comms_semantic,_as_end, ready, _unit_id); // DPI call to imported task
        end
    endtask

    task automatic dvc_get_stream_ready
    (
        input questa_mvc_item_comms_semantic _comms_semantic,
        input longint _as_end,
        output bit ready,
        input int _unit_id = 0,
        input bit _using = 0
    );
        begin

            wait(_interface_ref != 0);

            // the real code .....
            // Call function to set/get the params, all are of known size
            axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog(_comms_semantic,_as_end, ready, _unit_id, _using); // DPI call to imported task
        end
    endtask


    //-------------------------------------------------------------------------
    // Generic Interface Configuration Support
    //

    import "DPI-C" context axi4stream_set_interface = function void axi4stream_set_interface
    (
        input int what,
        input int arg1,
        input int arg2,
        input int arg3,
        input int arg4,
        input int arg5,
        input int arg6,
        input int arg7,
        input int arg8,
        input int arg9,
        input int arg10
    );
    import "DPI-C" context axi4stream_get_interface = function int axi4stream_get_interface
    (
        input int what,
        input int arg1,
        input int arg2,
        input int arg3,
        input int arg4,
        input int arg5,
        input int arg6,
        input int arg7,
        input int arg8,
        input int arg9
    );


    //-------------------------------------------------------------------------
    // Functions to get the hierarchic name of this interface
    //
    import "DPI-C" context axi4stream_get_full_name = function string axi4stream_get_full_name();


    //-------------------------------------------------------------------------
    // Abstraction level Support
    //

    import "DPI-C" context axi4stream_set_master_end_abstraction_level =
    function void axi4stream_set_master_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_master_end_abstraction_level =
    function void axi4stream_get_master_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_slave_end_abstraction_level =
    function void axi4stream_set_slave_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_slave_end_abstraction_level =
    function void axi4stream_get_slave_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_clock_source_end_abstraction_level =
    function void axi4stream_set_clock_source_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_clock_source_end_abstraction_level =
    function void axi4stream_get_clock_source_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );
    import "DPI-C" context axi4stream_set_reset_source_end_abstraction_level =
    function void axi4stream_set_reset_source_end_abstraction_level
    (
        input bit         wire_level,
        input bit         TLM_level
    );
    import "DPI-C" context axi4stream_get_reset_source_end_abstraction_level =
    function void axi4stream_get_reset_source_end_abstraction_level
    (
        output bit         wire_level,
        output bit         TLM_level
    );

    //-------------------------------------------------------------------------
    // Wire Level Interface Support
    //
    logic internal_ACLK = 'z;
    logic internal_ARESETn = 'z;
    logic internal_TVALID = 'z;
    logic [((AXI4_DATA_WIDTH) - 1):0]  internal_TDATA = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  internal_TSTRB = 'z;
    logic [(((AXI4_DATA_WIDTH / 8)) - 1):0]  internal_TKEEP = 'z;
    logic internal_TLAST = 'z;
    logic [((AXI4_ID_WIDTH) - 1):0]  internal_TID = 'z;
    logic [((AXI4_USER_WIDTH) - 1):0]  internal_TUSER = 'z;
    logic [((AXI4_DEST_WIDTH) - 1):0]  internal_TDEST = 'z;
    logic internal_TREADY = 'z;

    import "DPI-C" context function void axi4stream_set_ACLK_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit ACLK_param
    );
    import "DPI-C" context function void axi4stream_propagate_ACLK_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_ACLK_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit ACLK_param

    );
    export "DPI-C" function axi4stream_initialise_ACLK_from_CY;

    import "DPI-C" context function void axi4stream_set_ARESETn_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit ARESETn_param
    );
    import "DPI-C" context function void axi4stream_propagate_ARESETn_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_ARESETn_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit ARESETn_param

    );
    export "DPI-C" function axi4stream_initialise_ARESETn_from_CY;

    import "DPI-C" context function void axi4stream_set_TVALID_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TVALID_param
    );
    import "DPI-C" context function void axi4stream_propagate_TVALID_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TVALID_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TVALID_param

    );
    export "DPI-C" function axi4stream_initialise_TVALID_from_CY;

    import "DPI-C" context function void axi4stream_set_TDATA_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TDATA_param
    );
    import "DPI-C" context function void axi4stream_propagate_TDATA_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TDATA_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TDATA_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TDATA_from_CY;

    import "DPI-C" context function void axi4stream_set_TSTRB_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TSTRB_param
    );
    import "DPI-C" context function void axi4stream_propagate_TSTRB_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TSTRB_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TSTRB_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TSTRB_from_CY;

    import "DPI-C" context function void axi4stream_set_TKEEP_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TKEEP_param
    );
    import "DPI-C" context function void axi4stream_propagate_TKEEP_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TKEEP_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TKEEP_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TKEEP_from_CY;

    import "DPI-C" context function void axi4stream_set_TLAST_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TLAST_param
    );
    import "DPI-C" context function void axi4stream_propagate_TLAST_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TLAST_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TLAST_param

    );
    export "DPI-C" function axi4stream_initialise_TLAST_from_CY;

    import "DPI-C" context function void axi4stream_set_TID_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TID_param
    );
    import "DPI-C" context function void axi4stream_propagate_TID_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TID_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TID_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TID_from_CY;

    import "DPI-C" context function void axi4stream_set_TUSER_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TUSER_param
    );
    import "DPI-C" context function void axi4stream_propagate_TUSER_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TUSER_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TUSER_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TUSER_from_CY;

    import "DPI-C" context function void axi4stream_set_TDEST_from_SystemVerilog_index1
    (
        input longint _iface_ref,
        input int unsigned _this_dot_1,
        input logic  TDEST_param
    );
    import "DPI-C" context function void axi4stream_propagate_TDEST_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TDEST_into_SystemVerilog
    (
        input longint _iface_ref
    );
    export "DPI-C" function axi4stream_set_TDEST_from_CY_index1;
    export "DPI-C" function axi4stream_initialise_TDEST_from_CY;

    import "DPI-C" context function void axi4stream_set_TREADY_from_SystemVerilog
    (
        input longint _iface_ref,
        input logic TREADY_param
    );
    import "DPI-C" context function void axi4stream_propagate_TREADY_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_TREADY_into_SystemVerilog
    (
        input longint _iface_ref,
        output logic TREADY_param

    );
    export "DPI-C" function axi4stream_initialise_TREADY_from_CY;

    import "DPI-C" context function void axi4stream_set_config_last_during_idle_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit config_last_during_idle_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_last_during_idle_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_last_during_idle_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit config_last_during_idle_param

    );
    export "DPI-C" function axi4stream_set_config_last_during_idle_from_CY;

    import "DPI-C" context function void axi4stream_set_config_enable_all_assertions_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit config_enable_all_assertions_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_enable_all_assertions_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_enable_all_assertions_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit config_enable_all_assertions_param

    );
    export "DPI-C" function axi4stream_set_config_enable_all_assertions_from_CY;

    import "DPI-C" context function void axi4stream_set_config_enable_assertion_from_SystemVerilog
    (
        input longint _iface_ref,
        input bit [255:0] config_enable_assertion_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_enable_assertion_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_enable_assertion_into_SystemVerilog
    (
        input longint _iface_ref,
        output bit [255:0] config_enable_assertion_param

    );
    export "DPI-C" function axi4stream_set_config_enable_assertion_from_CY;

    import "DPI-C" context function void axi4stream_set_config_burst_timeout_factor_from_SystemVerilog
    (
        input longint _iface_ref,
        input int unsigned config_burst_timeout_factor_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_burst_timeout_factor_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_burst_timeout_factor_into_SystemVerilog
    (
        input longint _iface_ref,
        output int unsigned config_burst_timeout_factor_param

    );
    export "DPI-C" function axi4stream_set_config_burst_timeout_factor_from_CY;

    import "DPI-C" context function void axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog
    (
        input longint _iface_ref,
        input int unsigned config_max_latency_TVALID_assertion_to_TREADY_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_max_latency_TVALID_assertion_to_TREADY_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_max_latency_TVALID_assertion_to_TREADY_into_SystemVerilog
    (
        input longint _iface_ref,
        output int unsigned config_max_latency_TVALID_assertion_to_TREADY_param

    );
    export "DPI-C" function axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_CY;

    import "DPI-C" context function void axi4stream_set_config_setup_time_from_SystemVerilog
    (
        input longint _iface_ref,
        input longint unsigned config_setup_time_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_setup_time_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_setup_time_into_SystemVerilog
    (
        input longint _iface_ref,
        output longint unsigned config_setup_time_param

    );
    export "DPI-C" function axi4stream_set_config_setup_time_from_CY;

    import "DPI-C" context function void axi4stream_set_config_hold_time_from_SystemVerilog
    (
        input longint _iface_ref,
        input longint unsigned config_hold_time_param
    );
    import "DPI-C" context function void axi4stream_propagate_config_hold_time_from_SystemVerilog
    (
        input longint _iface_ref    );
    import "DPI-C" context function void axi4stream_get_config_hold_time_into_SystemVerilog
    (
        input longint _iface_ref,
        output longint unsigned config_hold_time_param

    );
    export "DPI-C" function axi4stream_set_config_hold_time_from_CY;

    function void axi4stream_initialise_ACLK_from_CY();
        internal_ACLK = 'z;
        m_ACLK = 'z;
    endfunction

    function void axi4stream_initialise_ARESETn_from_CY();
        internal_ARESETn = 'z;
        m_ARESETn = 'z;
    endfunction

    function void axi4stream_initialise_TVALID_from_CY();
        internal_TVALID = 'z;
        m_TVALID = 'z;
    endfunction

    function void axi4stream_set_TDATA_from_CY_index1( int _this_dot_1, logic  TDATA_param );
        internal_TDATA[_this_dot_1] = TDATA_param;
    endfunction

    function void axi4stream_initialise_TDATA_from_CY();
        internal_TDATA = 'z;
        m_TDATA = 'z;
    endfunction

    function void axi4stream_set_TSTRB_from_CY_index1( int _this_dot_1, logic  TSTRB_param );
        internal_TSTRB[_this_dot_1] = TSTRB_param;
    endfunction

    function void axi4stream_initialise_TSTRB_from_CY();
        internal_TSTRB = 'z;
        m_TSTRB = 'z;
    endfunction

    function void axi4stream_set_TKEEP_from_CY_index1( int _this_dot_1, logic  TKEEP_param );
        internal_TKEEP[_this_dot_1] = TKEEP_param;
    endfunction

    function void axi4stream_initialise_TKEEP_from_CY();
        internal_TKEEP = 'z;
        m_TKEEP = 'z;
    endfunction

    function void axi4stream_initialise_TLAST_from_CY();
        internal_TLAST = 'z;
        m_TLAST = 'z;
    endfunction

    function void axi4stream_set_TID_from_CY_index1( int _this_dot_1, logic  TID_param );
        internal_TID[_this_dot_1] = TID_param;
    endfunction

    function void axi4stream_initialise_TID_from_CY();
        internal_TID = 'z;
        m_TID = 'z;
    endfunction

    function void axi4stream_set_TUSER_from_CY_index1( int _this_dot_1, logic  TUSER_param );
        internal_TUSER[_this_dot_1] = TUSER_param;
    endfunction

    function void axi4stream_initialise_TUSER_from_CY();
        internal_TUSER = 'z;
        m_TUSER = 'z;
    endfunction

    function void axi4stream_set_TDEST_from_CY_index1( int _this_dot_1, logic  TDEST_param );
        internal_TDEST[_this_dot_1] = TDEST_param;
    endfunction

    function void axi4stream_initialise_TDEST_from_CY();
        internal_TDEST = 'z;
        m_TDEST = 'z;
    endfunction

    function void axi4stream_initialise_TREADY_from_CY();
        internal_TREADY = 'z;
        m_TREADY = 'z;
    endfunction

    function void axi4stream_set_config_last_during_idle_from_CY( bit config_last_during_idle_param );
        config_last_during_idle = config_last_during_idle_param;
    endfunction

    function void axi4stream_set_config_enable_all_assertions_from_CY( bit config_enable_all_assertions_param );
        config_enable_all_assertions = config_enable_all_assertions_param;
    endfunction

    function void axi4stream_set_config_enable_assertion_from_CY( bit [255:0] config_enable_assertion_param );
        config_enable_assertion = config_enable_assertion_param;
    endfunction

    function void axi4stream_set_config_burst_timeout_factor_from_CY( int unsigned config_burst_timeout_factor_param );
        config_burst_timeout_factor = config_burst_timeout_factor_param;
    endfunction

    function void axi4stream_set_config_max_latency_TVALID_assertion_to_TREADY_from_CY( int unsigned config_max_latency_TVALID_assertion_to_TREADY_param );
        config_max_latency_TVALID_assertion_to_TREADY = config_max_latency_TVALID_assertion_to_TREADY_param;
    endfunction

    function void axi4stream_set_config_setup_time_from_CY( longint unsigned config_setup_time_param );
        config_setup_time = config_setup_time_param;
    endfunction

    function void axi4stream_set_config_hold_time_from_CY( longint unsigned config_hold_time_param );
        config_hold_time = config_hold_time_param;
    endfunction



    //--------------------------------------------------------------------------
    //
    // Group:- TLM Interface Support
    //
    //--------------------------------------------------------------------------
    export "DPI-C" axi4stream_get_temp_static_packet_data = function axi4stream_get_temp_static_packet_data;
    export "DPI-C" axi4stream_set_temp_static_packet_data = function axi4stream_set_temp_static_packet_data;
    export "DPI-C" axi4stream_get_temp_static_packet_byte_type = function axi4stream_get_temp_static_packet_byte_type;
    export "DPI-C" axi4stream_set_temp_static_packet_byte_type = function axi4stream_set_temp_static_packet_byte_type;
    export "DPI-C" axi4stream_get_temp_static_packet_id = function axi4stream_get_temp_static_packet_id;
    export "DPI-C" axi4stream_set_temp_static_packet_id = function axi4stream_set_temp_static_packet_id;
    export "DPI-C" axi4stream_get_temp_static_packet_dest = function axi4stream_get_temp_static_packet_dest;
    export "DPI-C" axi4stream_set_temp_static_packet_dest = function axi4stream_set_temp_static_packet_dest;
    export "DPI-C" axi4stream_get_temp_static_packet_user_data = function axi4stream_get_temp_static_packet_user_data;
    export "DPI-C" axi4stream_set_temp_static_packet_user_data = function axi4stream_set_temp_static_packet_user_data;
    export "DPI-C" axi4stream_get_temp_static_packet_valid_delay = function axi4stream_get_temp_static_packet_valid_delay;
    export "DPI-C" axi4stream_set_temp_static_packet_valid_delay = function axi4stream_set_temp_static_packet_valid_delay;
    export "DPI-C" axi4stream_get_temp_static_packet_ready_delay = function axi4stream_get_temp_static_packet_ready_delay;
    export "DPI-C" axi4stream_set_temp_static_packet_ready_delay = function axi4stream_set_temp_static_packet_ready_delay;
    import "DPI-C" context axi4stream_packet_SendSendingSent_SystemVerilog =
    task axi4stream_packet_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int data_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int byte_type_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int user_data_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int valid_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int ready_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int _unit_id
    );
    import "DPI-C" context axi4stream_packet_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_packet_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output int _trans_id,
        inout int data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int byte_type_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int user_data_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int valid_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        inout int ready_delay_DIMS0, // Array to pass in and/or out the unsized dims of param
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog =
    task axi4stream_packet_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        input int _unit_id,
        input bit _using
    );
    export "DPI-C" axi4stream_get_temp_static_transfer_data = function axi4stream_get_temp_static_transfer_data;
    export "DPI-C" axi4stream_set_temp_static_transfer_data = function axi4stream_set_temp_static_transfer_data;
    export "DPI-C" axi4stream_get_temp_static_transfer_byte_type = function axi4stream_get_temp_static_transfer_byte_type;
    export "DPI-C" axi4stream_set_temp_static_transfer_byte_type = function axi4stream_set_temp_static_transfer_byte_type;
    export "DPI-C" axi4stream_get_temp_static_transfer_id = function axi4stream_get_temp_static_transfer_id;
    export "DPI-C" axi4stream_set_temp_static_transfer_id = function axi4stream_set_temp_static_transfer_id;
    export "DPI-C" axi4stream_get_temp_static_transfer_dest = function axi4stream_get_temp_static_transfer_dest;
    export "DPI-C" axi4stream_set_temp_static_transfer_dest = function axi4stream_set_temp_static_transfer_dest;
    export "DPI-C" axi4stream_get_temp_static_transfer_user_data = function axi4stream_get_temp_static_transfer_user_data;
    export "DPI-C" axi4stream_set_temp_static_transfer_user_data = function axi4stream_set_temp_static_transfer_user_data;
    import "DPI-C" context axi4stream_transfer_SendSendingSent_SystemVerilog =
    task axi4stream_transfer_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit last,
        input int valid_delay,
        input int ready_delay,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_transfer_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output int _trans_id,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_transfer_ReceivedReceivingReceive_open_SystemVerilog =
    task axi4stream_transfer_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        output bit last,
        output int valid_delay,
        output int ready_delay,
        input int _unit_id,
        input bit _using
    );
    export "DPI-C" axi4stream_get_temp_static_cycle_data = function axi4stream_get_temp_static_cycle_data;
    export "DPI-C" axi4stream_set_temp_static_cycle_data = function axi4stream_set_temp_static_cycle_data;
    export "DPI-C" axi4stream_get_temp_static_cycle_strb = function axi4stream_get_temp_static_cycle_strb;
    export "DPI-C" axi4stream_set_temp_static_cycle_strb = function axi4stream_set_temp_static_cycle_strb;
    export "DPI-C" axi4stream_get_temp_static_cycle_keep = function axi4stream_get_temp_static_cycle_keep;
    export "DPI-C" axi4stream_set_temp_static_cycle_keep = function axi4stream_set_temp_static_cycle_keep;
    export "DPI-C" axi4stream_get_temp_static_cycle_id = function axi4stream_get_temp_static_cycle_id;
    export "DPI-C" axi4stream_set_temp_static_cycle_id = function axi4stream_set_temp_static_cycle_id;
    export "DPI-C" axi4stream_get_temp_static_cycle_dest = function axi4stream_get_temp_static_cycle_dest;
    export "DPI-C" axi4stream_set_temp_static_cycle_dest = function axi4stream_set_temp_static_cycle_dest;
    export "DPI-C" axi4stream_get_temp_static_cycle_user_data = function axi4stream_get_temp_static_cycle_user_data;
    export "DPI-C" axi4stream_set_temp_static_cycle_user_data = function axi4stream_set_temp_static_cycle_user_data;
    import "DPI-C" context axi4stream_cycle_SendSendingSent_SystemVerilog =
    task axi4stream_cycle_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit last,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_cycle_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output int _trans_id,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_cycle_ReceivedReceivingReceive_open_SystemVerilog =
    task axi4stream_cycle_ReceivedReceivingReceive_open_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input int _trans_id,
        output bit last,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_stream_ready_SendSendingSent_SystemVerilog =
    task axi4stream_stream_ready_SendSendingSent_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        input bit ready,
        input int _unit_id
    );
    import "DPI-C" context axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog =
    task axi4stream_stream_ready_ReceivedReceivingReceive_SystemVerilog
    (
        input int _comms_semantic,
        input longint _as_end,
        output bit ready,
        input int _unit_id,
        input bit _using
    );
    import "DPI-C" context axi4stream_end_of_timestep_VPI_SystemVerilog =
    task axi4stream_end_of_timestep_VPI_SystemVerilog();
    // Waiter task and control
    reg wait_for_control = 0;

    always @(posedge wait_for_control)
    begin
        disable wait_for;
        wait_for_control = 0;
    end

    export "DPI-C" axi4stream_wait_for = task wait_for;

    task wait_for();
        begin
            wait(0 == 1);
        end
    endtask

    // Drive wires (from Cohesive) 
    assign ACLK = internal_ACLK;
    assign ARESETn = internal_ARESETn;
    assign TVALID = internal_TVALID;
    assign TDATA = internal_TDATA;
    assign TSTRB = internal_TSTRB;
    assign TKEEP = internal_TKEEP;
    assign TLAST = internal_TLAST;
    assign TID = internal_TID;
    assign TUSER = internal_TUSER;
    assign TDEST = internal_TDEST;
    assign TREADY = internal_TREADY;
    // Drive wires (from User) 
    assign ACLK = m_ACLK;
    assign ARESETn = m_ARESETn;
    assign TVALID = m_TVALID;
    assign TDATA = m_TDATA;
    assign TSTRB = m_TSTRB;
    assign TKEEP = m_TKEEP;
    assign TLAST = m_TLAST;
    assign TID = m_TID;
    assign TUSER = m_TUSER;
    assign TDEST = m_TDEST;
    assign TREADY = m_TREADY;

    reg ACLK_changed = 0;
    reg ARESETn_changed = 0;
    reg TVALID_changed = 0;
    reg TDATA_changed = 0;
    reg TSTRB_changed = 0;
    reg TKEEP_changed = 0;
    reg TLAST_changed = 0;
    reg TID_changed = 0;
    reg TUSER_changed = 0;
    reg TDEST_changed = 0;
    reg TREADY_changed = 0;
    reg config_last_during_idle_changed = 0;
    reg config_enable_all_assertions_changed = 0;
    reg config_enable_assertion_changed = 0;
    reg config_burst_timeout_factor_changed = 0;
    reg config_max_latency_TVALID_assertion_to_TREADY_changed = 0;
    reg config_setup_time_changed = 0;
    reg config_hold_time_changed = 0;

    reg end_of_timestep_control = 0;

    // Start end_of_timestep timer
    initial
    forever
    begin
        wait_end_of_timestep();
    end


    event non_blocking_end_of_timestep_control;

    export "DPI-C" axi4stream_wait_end_of_timestep = task wait_end_of_timestep;

    task wait_end_of_timestep();
        begin
            @(non_blocking_end_of_timestep_control);
            axi4stream_end_of_timestep_VPI_SystemVerilog();
        end
    endtask

    always @( posedge end_of_timestep_control or posedge _check_t0_values )
    begin
        if ( end_of_timestep_control == 1 )
        begin
            ->> non_blocking_end_of_timestep_control;
            end_of_timestep_control = 0;
        end
    end


    // SV wire change monitors

    function automatic void axi4stream_local_set_ACLK_from_SystemVerilog(  );
            axi4stream_set_ACLK_from_SystemVerilog( _interface_ref, ACLK); // DPI call to imported task
        
        axi4stream_propagate_ACLK_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( ACLK or posedge _check_t0_values )
    begin
        axi4stream_local_set_ACLK_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_ARESETn_from_SystemVerilog(  );
            axi4stream_set_ARESETn_from_SystemVerilog( _interface_ref, ARESETn); // DPI call to imported task
        
        axi4stream_propagate_ARESETn_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( ARESETn or posedge _check_t0_values )
    begin
        axi4stream_local_set_ARESETn_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TVALID_from_SystemVerilog(  );
            axi4stream_set_TVALID_from_SystemVerilog( _interface_ref, TVALID); // DPI call to imported task
        
        axi4stream_propagate_TVALID_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TVALID or posedge _check_t0_values )
    begin
        axi4stream_local_set_TVALID_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TDATA_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_DATA_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TDATA_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TDATA[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TDATA_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TDATA or posedge _check_t0_values )
    begin
        axi4stream_local_set_TDATA_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TSTRB_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( (AXI4_DATA_WIDTH / 8) ); _this_dot_1++)
        begin
            axi4stream_set_TSTRB_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TSTRB[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TSTRB_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TSTRB or posedge _check_t0_values )
    begin
        axi4stream_local_set_TSTRB_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TKEEP_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( (AXI4_DATA_WIDTH / 8) ); _this_dot_1++)
        begin
            axi4stream_set_TKEEP_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TKEEP[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TKEEP_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TKEEP or posedge _check_t0_values )
    begin
        axi4stream_local_set_TKEEP_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TLAST_from_SystemVerilog(  );
            axi4stream_set_TLAST_from_SystemVerilog( _interface_ref, TLAST); // DPI call to imported task
        
        axi4stream_propagate_TLAST_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TLAST or posedge _check_t0_values )
    begin
        axi4stream_local_set_TLAST_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TID_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_ID_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TID_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TID[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TID_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TID or posedge _check_t0_values )
    begin
        axi4stream_local_set_TID_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TUSER_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_USER_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TUSER_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TUSER[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TUSER_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TUSER or posedge _check_t0_values )
    begin
        axi4stream_local_set_TUSER_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TDEST_from_SystemVerilog(  );
        begin
        for (int _this_dot_1= 0; _this_dot_1 < ( AXI4_DEST_WIDTH ); _this_dot_1++)
        begin
            axi4stream_set_TDEST_from_SystemVerilog_index1( _interface_ref, _this_dot_1,TDEST[_this_dot_1]); // DPI call to imported task
        
        end
        end/* 1 */ 
        axi4stream_propagate_TDEST_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TDEST or posedge _check_t0_values )
    begin
        axi4stream_local_set_TDEST_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end

    function automatic void axi4stream_local_set_TREADY_from_SystemVerilog(  );
            axi4stream_set_TREADY_from_SystemVerilog( _interface_ref, TREADY); // DPI call to imported task
        
        axi4stream_propagate_TREADY_from_SystemVerilog( _interface_ref); // DPI call to imported task
    endfunction

    always @( TREADY or posedge _check_t0_values )
    begin
        axi4stream_local_set_TREADY_from_SystemVerilog(); // Call to local task which flattens data as necessary
    end


    // CY wire and variable changed flag monitors

    always @(posedge ACLK_changed or posedge _check_t0_values )
    begin
        while (ACLK_changed == 1'b1)
        begin
            axi4stream_get_ACLK_into_SystemVerilog( _interface_ref, internal_ACLK ); // DPI call to imported task
            ACLK_changed = 1'b0;
            #0  #0 if ( ACLK !== internal_ACLK )
            begin
                axi4stream_local_set_ACLK_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge ARESETn_changed or posedge _check_t0_values )
    begin
        while (ARESETn_changed == 1'b1)
        begin
            axi4stream_get_ARESETn_into_SystemVerilog( _interface_ref, internal_ARESETn ); // DPI call to imported task
            ARESETn_changed = 1'b0;
            #0  #0 if ( ARESETn !== internal_ARESETn )
            begin
                axi4stream_local_set_ARESETn_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TVALID_changed or posedge _check_t0_values )
    begin
        while (TVALID_changed == 1'b1)
        begin
            axi4stream_get_TVALID_into_SystemVerilog( _interface_ref, internal_TVALID ); // DPI call to imported task
            TVALID_changed = 1'b0;
            #0  #0 if ( TVALID !== internal_TVALID )
            begin
                axi4stream_local_set_TVALID_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TDATA_changed or posedge _check_t0_values )
    begin
        while (TDATA_changed == 1'b1)
        begin
            axi4stream_get_TDATA_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TDATA_changed = 1'b0;
            #0  #0 if ( TDATA !== internal_TDATA )
            begin
                axi4stream_local_set_TDATA_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TSTRB_changed or posedge _check_t0_values )
    begin
        while (TSTRB_changed == 1'b1)
        begin
            axi4stream_get_TSTRB_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TSTRB_changed = 1'b0;
            #0  #0 if ( TSTRB !== internal_TSTRB )
            begin
                axi4stream_local_set_TSTRB_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TKEEP_changed or posedge _check_t0_values )
    begin
        while (TKEEP_changed == 1'b1)
        begin
            axi4stream_get_TKEEP_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TKEEP_changed = 1'b0;
            #0  #0 if ( TKEEP !== internal_TKEEP )
            begin
                axi4stream_local_set_TKEEP_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TLAST_changed or posedge _check_t0_values )
    begin
        while (TLAST_changed == 1'b1)
        begin
            axi4stream_get_TLAST_into_SystemVerilog( _interface_ref, internal_TLAST ); // DPI call to imported task
            TLAST_changed = 1'b0;
            #0  #0 if ( TLAST !== internal_TLAST )
            begin
                axi4stream_local_set_TLAST_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TID_changed or posedge _check_t0_values )
    begin
        while (TID_changed == 1'b1)
        begin
            axi4stream_get_TID_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TID_changed = 1'b0;
            #0  #0 if ( TID !== internal_TID )
            begin
                axi4stream_local_set_TID_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TUSER_changed or posedge _check_t0_values )
    begin
        while (TUSER_changed == 1'b1)
        begin
            axi4stream_get_TUSER_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TUSER_changed = 1'b0;
            #0  #0 if ( TUSER !== internal_TUSER )
            begin
                axi4stream_local_set_TUSER_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TDEST_changed or posedge _check_t0_values )
    begin
        while (TDEST_changed == 1'b1)
        begin
            axi4stream_get_TDEST_into_SystemVerilog( _interface_ref ); // DPI call to imported task
            TDEST_changed = 1'b0;
            #0  #0 if ( TDEST !== internal_TDEST )
            begin
                axi4stream_local_set_TDEST_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge TREADY_changed or posedge _check_t0_values )
    begin
        while (TREADY_changed == 1'b1)
        begin
            axi4stream_get_TREADY_into_SystemVerilog( _interface_ref, internal_TREADY ); // DPI call to imported task
            TREADY_changed = 1'b0;
            #0  #0 if ( TREADY !== internal_TREADY )
            begin
                axi4stream_local_set_TREADY_from_SystemVerilog(  );
            end
        end
    end

    always @(posedge config_last_during_idle_changed or posedge _check_t0_values )
    begin
        if (config_last_during_idle_changed == 1'b1)
        begin
            axi4stream_get_config_last_during_idle_into_SystemVerilog( _interface_ref, config_last_during_idle ); // DPI call to imported task
            config_last_during_idle_changed = 1'b0;
        end
    end

    always @(posedge config_enable_all_assertions_changed or posedge _check_t0_values )
    begin
        if (config_enable_all_assertions_changed == 1'b1)
        begin
            axi4stream_get_config_enable_all_assertions_into_SystemVerilog( _interface_ref, config_enable_all_assertions ); // DPI call to imported task
            config_enable_all_assertions_changed = 1'b0;
        end
    end

    always @(posedge config_enable_assertion_changed or posedge _check_t0_values )
    begin
        if (config_enable_assertion_changed == 1'b1)
        begin
            axi4stream_get_config_enable_assertion_into_SystemVerilog( _interface_ref, config_enable_assertion ); // DPI call to imported task
            config_enable_assertion_changed = 1'b0;
        end
    end

    always @(posedge config_burst_timeout_factor_changed or posedge _check_t0_values )
    begin
        if (config_burst_timeout_factor_changed == 1'b1)
        begin
            axi4stream_get_config_burst_timeout_factor_into_SystemVerilog( _interface_ref, config_burst_timeout_factor ); // DPI call to imported task
            config_burst_timeout_factor_changed = 1'b0;
        end
    end

    always @(posedge config_max_latency_TVALID_assertion_to_TREADY_changed or posedge _check_t0_values )
    begin
        if (config_max_latency_TVALID_assertion_to_TREADY_changed == 1'b1)
        begin
            axi4stream_get_config_max_latency_TVALID_assertion_to_TREADY_into_SystemVerilog( _interface_ref, config_max_latency_TVALID_assertion_to_TREADY ); // DPI call to imported task
            config_max_latency_TVALID_assertion_to_TREADY_changed = 1'b0;
        end
    end

    always @(posedge config_setup_time_changed or posedge _check_t0_values )
    begin
        if (config_setup_time_changed == 1'b1)
        begin
            axi4stream_get_config_setup_time_into_SystemVerilog( _interface_ref, config_setup_time ); // DPI call to imported task
            config_setup_time_changed = 1'b0;
        end
    end

    always @(posedge config_hold_time_changed or posedge _check_t0_values )
    begin
        if (config_hold_time_changed == 1'b1)
        begin
            axi4stream_get_config_hold_time_into_SystemVerilog( _interface_ref, config_hold_time ); // DPI call to imported task
            config_hold_time_changed = 1'b0;
        end
    end


    //--------------------------------------------------------------------------------
    // Task which blocks and outputs an error if the interface has not initialized properly
    //--------------------------------------------------------------------------------

    task _initialized();
        if (_interface_ref == 0)
        begin
            $display("Error: %m - Questa Verification IP failed to initialise. Please check questa_mvc.log for details");
            wait(_interface_ref!=0);
        end
    endtask

endinterface

`endif // VCS
