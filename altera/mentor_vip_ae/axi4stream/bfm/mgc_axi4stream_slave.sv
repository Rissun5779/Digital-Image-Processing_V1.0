// *****************************************************************************
//
// Copyright 2007-2016 Mentor Graphics Corporation
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//
// *****************************************************************************
// dvc           Version: 20120717_Questa_10.1b
// *****************************************************************************
//
// Title: axi4stream_slave_module
//

// import package for the axi4stream interface
import mgc_axi4stream_pkg::*;

interface mgc_axi4stream_slave #(int AXI4_ID_WIDTH = 8, int AXI4_USER_WIDTH = 8, int AXI4_DEST_WIDTH = 18, int AXI4_DATA_WIDTH = 1024, int index = 0)
(
    input  ACLK,
    input  ARESETn,
    input  TVALID,
    input  [((AXI4_DATA_WIDTH) - 1):0]  TDATA,
    input  [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TSTRB,
    input  [(((AXI4_DATA_WIDTH / 8)) - 1):0]  TKEEP,
    input  TLAST,
    input  [((AXI4_ID_WIDTH) - 1):0]  TID,
    input  [((AXI4_USER_WIDTH) - 1):0]  TUSER,
    input  [((AXI4_DEST_WIDTH) - 1):0]  TDEST,
    output TREADY
`ifdef _MGC_VIP_VHDL_INTERFACE
    // VHDL application interface.
    // Parallel path 0
  , input  bit [AXI4STREAM_VHD_WAIT_ON:0] req_p0,
    input  int transaction_id_in_p0,
    input  int value_in0_p0,
    input  int value_in1_p0,
    input  int value_in2_p0,
    input  int value_in3_p0,
    input  axi4stream_max_bits_t value_in_max_p0,
    output bit [AXI4STREAM_VHD_WAIT_ON:0] ack_p0,
    output int transaction_id_out_p0,
    output int value_out0_p0,
    output int value_out1_p0,
    output axi4stream_max_bits_t value_out_max_p0
`endif
);

`ifdef MODEL_TECH
  `ifdef _MGC_VIP_VHDL_INTERFACE
    `include "mgc_axi4stream_slave.mti.svp"
  `endif
`endif

`define call_for_axi4stream_bfm(XXX) axi4stream.XXX

    // Interface instance
    mgc_common_axi4stream #(AXI4_ID_WIDTH, AXI4_USER_WIDTH, AXI4_DEST_WIDTH, AXI4_DATA_WIDTH) axi4stream ( ACLK, ARESETn );
    assign axi4stream.TVALID = TVALID;
    assign axi4stream.TDATA = TDATA;
    assign axi4stream.TSTRB = TSTRB;
    assign axi4stream.TKEEP = TKEEP;
    assign axi4stream.TLAST = TLAST;
    assign axi4stream.TID = TID;
    assign axi4stream.TUSER = TUSER;
    assign axi4stream.TDEST = TDEST;
    assign TREADY = axi4stream.TREADY;

    // Set this end to be TLM connected
    initial
    begin
        `call_for_axi4stream_bfm(axi4stream_set_slave_abstraction_level)(0, 1);
    end

`ifdef _MGC_VIP_VHDL_INTERFACE
    // Port-signal assignment
    bit [AXI4STREAM_VHD_WAIT_ON:0] req_p[1];
    int transaction_id_in_p[1];
    int value_in0_p[1];
    int value_in1_p[1];
    int value_in2_p[1];
    int value_in3_p[1];
    axi4stream_max_bits_t value_in_max_p[1];
    bit [AXI4STREAM_VHD_WAIT_ON:0] ack_p[1];
    int transaction_id_out_p[1];
    int value_out0_p[1];
    int value_out1_p[1];
    axi4stream_max_bits_t value_out_max_p[1];

    // Parallel path 0
    assign req_p[0]               = req_p0;
    assign transaction_id_in_p[0] = transaction_id_in_p0;
    assign value_in0_p[0]         = value_in0_p0;
    assign value_in1_p[0]         = value_in1_p0;
    assign value_in2_p[0]         = value_in2_p0;
    assign value_in3_p[0]         = value_in3_p0;
    assign value_in_max_p[0]      = value_in_max_p0;
    assign ack_p0                 = ack_p[0];
    assign transaction_id_out_p0  = transaction_id_out_p[0];
    assign value_out0_p0          = value_out0_p[0];
    assign value_out1_p0          = value_out1_p[0];
    assign value_out_max_p0       = value_out_max_p[0];

    // Transaction ID and array 
    bit unsigned [7:0] circular_id;
    axi4stream_transaction transaction_array[256];
    bit unsigned [7:0]  axi4stream_transaction_id_queue[1][$];

   // API call starts here
   generate
    genvar gg;
    for(gg = 0; gg < 1; ++gg)
    begin

    //------------------------------------------------------------------------------
    //
    // destruct_transaction hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_DESTRUCT_TRANSACTION]);
        ack_p[gg][AXI4STREAM_VHD_DESTRUCT_TRANSACTION] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          if(transaction_array[transaction_id_in_p[gg]].transaction_done == 1)
          begin
            $display("%0t: %m (%d): Warning: Destructing a transaction with ID = %d which is not finished yet", $time, index, transaction_id_in_p[gg]);
          end
          transaction_array[transaction_id_in_p[gg]] = null;
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_DESTRUCT_TRANSACTION", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_DESTRUCT_TRANSACTION] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // push_transaction_id hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_PUSH_TRANSACTION_ID]);
        ack_p[gg][AXI4STREAM_VHD_PUSH_TRANSACTION_ID] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          axi4stream_transaction_id_queue[value_in0_p[gg]].push_back(transaction_id_in_p[gg]); 
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_PUSH_TRANSACTION_ID", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_PUSH_TRANSACTION_ID] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // pop_transaction_id hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_POP_TRANSACTION_ID]);
        ack_p[gg][AXI4STREAM_VHD_POP_TRANSACTION_ID] = 1;
        wait(axi4stream_transaction_id_queue[value_in0_p[gg]].size > 0);
        transaction_id_out_p[gg]  = axi4stream_transaction_id_queue[value_in0_p[gg]].pop_front(); 
        ack_p[gg][AXI4STREAM_VHD_POP_TRANSACTION_ID] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // print hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_PRINT]);
        ack_p[gg][AXI4STREAM_VHD_PRINT] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].print(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_PRINT", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_PRINT] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_data hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_DATA]);
        ack_p[gg][AXI4STREAM_VHD_SET_DATA] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_data(value_in0_p[gg], value_in1_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_DATA", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_DATA] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_data hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_DATA]);
        ack_p[gg][AXI4STREAM_VHD_GET_DATA] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out0_p[gg] = transaction_array[transaction_id_in_p[gg]].get_data(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_DATA", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_DATA] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_byte_type hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_BYTE_TYPE]);
        ack_p[gg][AXI4STREAM_VHD_SET_BYTE_TYPE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_byte_type(axi4stream_byte_type_e'(value_in0_p[gg]), value_in1_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_BYTE_TYPE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_BYTE_TYPE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_byte_type hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_BYTE_TYPE]);
        ack_p[gg][AXI4STREAM_VHD_GET_BYTE_TYPE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out0_p[gg] = transaction_array[transaction_id_in_p[gg]].get_byte_type(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_BYTE_TYPE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_BYTE_TYPE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_id hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_ID]);
        ack_p[gg][AXI4STREAM_VHD_SET_ID] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_id(value_in_max_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_ID", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_ID] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_id hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_ID]);
        ack_p[gg][AXI4STREAM_VHD_GET_ID] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out_max_p[gg] = transaction_array[transaction_id_in_p[gg]].get_id();
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_ID", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_ID] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_dest hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_DEST]);
        ack_p[gg][AXI4STREAM_VHD_SET_DEST] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_dest(value_in_max_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_DEST", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_DEST] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_dest hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_DEST]);
        ack_p[gg][AXI4STREAM_VHD_GET_DEST] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out_max_p[gg] = transaction_array[transaction_id_in_p[gg]].get_dest();
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_DEST", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_DEST] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_user_data hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_USER_DATA]);
        ack_p[gg][AXI4STREAM_VHD_SET_USER_DATA] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_user_data(value_in_max_p[gg], value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_USER_DATA", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_USER_DATA] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_user_data hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_USER_DATA]);
        ack_p[gg][AXI4STREAM_VHD_GET_USER_DATA] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out_max_p[gg] = transaction_array[transaction_id_in_p[gg]].get_user_data(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_USER_DATA", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_USER_DATA] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_valid_delay hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_VALID_DELAY]);
        ack_p[gg][AXI4STREAM_VHD_SET_VALID_DELAY] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_valid_delay(value_in0_p[gg], value_in1_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_VALID_DELAY", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_VALID_DELAY] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_valid_delay hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_VALID_DELAY]);
        ack_p[gg][AXI4STREAM_VHD_GET_VALID_DELAY] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out0_p[gg] = transaction_array[transaction_id_in_p[gg]].get_valid_delay(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_VALID_DELAY", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_VALID_DELAY] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_ready_delay hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_READY_DELAY]);
        ack_p[gg][AXI4STREAM_VHD_SET_READY_DELAY] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_ready_delay(value_in0_p[gg], value_in1_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_READY_DELAY", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_READY_DELAY] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_ready_delay hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_READY_DELAY]);
        ack_p[gg][AXI4STREAM_VHD_GET_READY_DELAY] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out0_p[gg] = transaction_array[transaction_id_in_p[gg]].get_ready_delay(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_READY_DELAY", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_READY_DELAY] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_operation_mode hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_OPERATION_MODE]);
        ack_p[gg][AXI4STREAM_VHD_SET_OPERATION_MODE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_operation_mode(axi4stream_operation_mode_e'(value_in0_p[gg]));
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_OPERATION_MODE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_OPERATION_MODE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_operation_mode hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_OPERATION_MODE]);
        ack_p[gg][AXI4STREAM_VHD_GET_OPERATION_MODE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out0_p[gg] = transaction_array[transaction_id_in_p[gg]].get_operation_mode();
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_OPERATION_MODE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_OPERATION_MODE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_transfer_done hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_TRANSFER_DONE]);
        ack_p[gg][AXI4STREAM_VHD_SET_TRANSFER_DONE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_transfer_done(value_in0_p[gg], value_in1_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_TRANSFER_DONE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_TRANSFER_DONE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_transfer_done hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_TRANSFER_DONE]);
        ack_p[gg][AXI4STREAM_VHD_GET_TRANSFER_DONE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out0_p[gg] = transaction_array[transaction_id_in_p[gg]].get_transfer_done(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_TRANSFER_DONE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_TRANSFER_DONE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_transaction_done hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_TRANSACTION_DONE]);
        ack_p[gg][AXI4STREAM_VHD_SET_TRANSACTION_DONE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          transaction_array[transaction_id_in_p[gg]].set_transaction_done(value_in0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_SET_TRANSACTION_DONE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_SET_TRANSACTION_DONE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_transaction_done hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_TRANSACTION_DONE]);
        ack_p[gg][AXI4STREAM_VHD_GET_TRANSACTION_DONE] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          value_out0_p[gg] = transaction_array[transaction_id_in_p[gg]].get_transaction_done();
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_TRANSACTION_DONE", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_TRANSACTION_DONE] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // set_config hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_SET_CONFIG]);
        ack_p[gg][AXI4STREAM_VHD_SET_CONFIG] = 1;
        set_config(axi4stream_config_e'(value_in0_p[gg]), value_in_max_p[gg]);
        ack_p[gg][AXI4STREAM_VHD_SET_CONFIG] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_config hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_CONFIG]);
        ack_p[gg][AXI4STREAM_VHD_GET_CONFIG] = 1;
        value_out_max_p[gg] = get_config(axi4stream_config_e'(value_in0_p[gg]));
        ack_p[gg][AXI4STREAM_VHD_GET_CONFIG] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // create_slave_transaction hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION]);
        ack_p[gg][AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION] = 1;
        if((transaction_array[circular_id] != null) && (transaction_array[circular_id].transaction_done == 0))
        begin
          $display("%0t: %m (%d): Warning: Trying to create slave_transaction id %d which is previously incomplete", $time, index, circular_id);
        end
        transaction_array[circular_id] = create_slave_transaction();
        transaction_id_out_p[gg] = circular_id;
        ++circular_id;
        ack_p[gg][AXI4STREAM_VHD_CREATE_SLAVE_TRANSACTION] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_packet hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_PACKET]);
        ack_p[gg][AXI4STREAM_VHD_GET_PACKET] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          get_packet(transaction_array[transaction_id_in_p[gg]]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_PACKET", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_PACKET] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // get_transfer hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_GET_TRANSFER]);
        ack_p[gg][AXI4STREAM_VHD_GET_TRANSFER] = 1;
        if(transaction_array[transaction_id_in_p[gg]] != null)
        begin
          get_transfer(transaction_array[transaction_id_in_p[gg]], value_in0_p[gg], value_out0_p[gg]);
        end
        else
        begin
          $display("%0t: %m (%d): Error: Transaction with ID = %d is not created before AXI4STREAM_VHD_GET_TRANSFER", $time, index, transaction_id_in_p[gg]);
        end
        ack_p[gg][AXI4STREAM_VHD_GET_TRANSFER] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // execute_stream_ready hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_EXECUTE_STREAM_READY]);
        ack_p[gg][AXI4STREAM_VHD_EXECUTE_STREAM_READY] = 1;
        execute_stream_ready(value_in0_p[gg], value_in1_p[gg]);
        ack_p[gg][AXI4STREAM_VHD_EXECUTE_STREAM_READY] <= 0;
    end

    //------------------------------------------------------------------------------
    //
    // wait_on hook for VHDL environment.
    //
    //------------------------------------------------------------------------------
    initial forever begin
    @(posedge req_p[gg][AXI4STREAM_VHD_WAIT_ON]);
        ack_p[gg][AXI4STREAM_VHD_WAIT_ON] = 1;
        wait_on(axi4stream_wait_e'(value_in0_p[gg]), value_in1_p[gg]);
        ack_p[gg][AXI4STREAM_VHD_WAIT_ON] <= 0;
    end

    end   // for loop
    endgenerate
`endif    // _MGC_VIP_VHDL_INTERFACE

    //------------------------------------------------------------------------------
    //
    // Function: set_config
    //
    //------------------------------------------------------------------------------
    // This function sets the configuration of the BFM.
    //------------------------------------------------------------------------------
    function void set_config(input axi4stream_config_e config_name, input axi4stream_max_bits_t config_val);
        case ( config_name )
            AXI4STREAM_CONFIG_SETUP_TIME                                  : `call_for_axi4stream_bfm(set_config_setup_time                                 )(config_val);
            AXI4STREAM_CONFIG_HOLD_TIME                                   : `call_for_axi4stream_bfm(set_config_hold_time                                  )(config_val);
            AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR                        : `call_for_axi4stream_bfm(set_config_burst_timeout_factor                       )(config_val);
            AXI4STREAM_CONFIG_LAST_DURING_IDLE                            : `call_for_axi4stream_bfm(set_config_last_during_idle                           )(config_val);
            AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY      : `call_for_axi4stream_bfm(set_config_max_latency_TVALID_assertion_to_TREADY     )(config_val);
            AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS                       : `call_for_axi4stream_bfm(set_config_enable_all_assertions                      )(config_val);
            AXI4STREAM_CONFIG_ENABLE_ASSERTION                            : `call_for_axi4stream_bfm(set_config_enable_assertion                           )(config_val);
            default : $display("%0t: %m: Config %s not a valid option to set_config().", $time, config_name.name());
        endcase
    endfunction

    //------------------------------------------------------------------------------
    //
    // Function: get_config
    //
    //------------------------------------------------------------------------------
    // This function gets the configuration of the BFM.
    //------------------------------------------------------------------------------
    function axi4stream_max_bits_t get_config( input axi4stream_config_e config_name );
        case ( config_name )
            AXI4STREAM_CONFIG_SETUP_TIME                                  : return `call_for_axi4stream_bfm(get_config_setup_time)();
            AXI4STREAM_CONFIG_HOLD_TIME                                   : return `call_for_axi4stream_bfm(get_config_hold_time)();
            AXI4STREAM_CONFIG_BURST_TIMEOUT_FACTOR                        : return `call_for_axi4stream_bfm(get_config_burst_timeout_factor)();
            AXI4STREAM_CONFIG_LAST_DURING_IDLE                            : return `call_for_axi4stream_bfm(get_config_last_during_idle)();
            AXI4STREAM_CONFIG_MAX_LATENCY_TVALID_ASSERTION_TO_TREADY      : return `call_for_axi4stream_bfm(get_config_max_latency_TVALID_assertion_to_TREADY)();
            AXI4STREAM_CONFIG_ENABLE_ALL_ASSERTIONS                       : return `call_for_axi4stream_bfm(get_config_enable_all_assertions)();
            AXI4STREAM_CONFIG_ENABLE_ASSERTION                            : return `call_for_axi4stream_bfm(get_config_enable_assertion)();
            default : $display("%0t: %m: Config %s not a valid option to get_config().", $time, config_name.name());
        endcase
    endfunction

    //------------------------------------------------------------------------------
    //
    // Function: create_slave_transaction
    //
    //------------------------------------------------------------------------------
    // This function creates a slave transaction.
    //------------------------------------------------------------------------------
    function automatic axi4stream_transaction create_slave_transaction();
      axi4stream_transaction trans   = new();
      trans.driver_name.itoa(index);
      trans.driver_name                    = {"Slave: index = ", trans.driver_name, ":"};
      return trans;
    endfunction

    //------------------------------------------------------------------------------
    //
    // Task: get_packet()
    //
    //-------------------------------------------------------------------------------------------------
    // This task waits for a complete packet and copies the information
    // back to the axi4stream_transaction.
    //-------------------------------------------------------------------------------------------------
    task automatic get_packet(axi4stream_transaction trans);
      bit last;
      for(int i = 0; !last; ++i)
      begin
        get_transfer(trans, i, last);
      end
    endtask

    //------------------------------------------------------------------------------
    //
    // Task: get_transfer()
    //
    //-------------------------------------------------------------------------------------------------
    // This task waits for a complete transfer and copies the information
    // back to the axi4stream_transaction.
    // On completion, this task sets the transfer_done[index] to 1.
    //-------------------------------------------------------------------------------------------------
    task automatic get_transfer(axi4stream_transaction trans, int index = 0, output bit last);
      int byte_count = AXI4_DATA_WIDTH/8;
      int transfer_count= trans.data.size()/byte_count;
      bit [((AXI4_DATA_WIDTH) - 1):0]  data;
      axi4stream_byte_type_e byte_type [((AXI4_DATA_WIDTH / 8) - 1):0];
      bit [((AXI4_USER_WIDTH) - 1):0]  user_data;
      int tmp_valid_delay;
      int tmp_ready_delay;

      `call_for_axi4stream_bfm(dvc_get_transfer)(
                QUESTA_MVC::QUESTA_MVC_COMMS_RECEIVED,
                `call_for_axi4stream_bfm(get_axi4stream_slave_end)(),
                data,
                byte_type,
                last,
                trans.id,
                trans.dest,
                user_data,
                tmp_valid_delay,
                tmp_ready_delay,
                0,
                1
              );
     if(transfer_count <= index)
     begin
       trans.data = new[(index+1)*byte_count](trans.data);
       trans.byte_type = new[(index+1)*byte_count](trans.byte_type);
       trans.user_data = new[index+1](trans.user_data);
       trans.transfer_done = new[index+1](trans.transfer_done);
       trans.valid_delay = new[index+1](trans.valid_delay);
     end  

     trans.transfer_done[index] = 1'b1;         
     trans.transaction_done = last;         
     trans.valid_delay[index] = tmp_valid_delay;

     for(int i = 0; i < byte_count; ++i)
     begin
       trans.data[i + (byte_count*index)] = data[i*8+:8];
       trans.byte_type[i + (byte_count*index)] = byte_type[i]; 
     end
     trans.user_data[index] = user_data; 
    endtask

    //------------------------------------------------------------------------------
    //
    // Task: execute_stream_ready()
    //
    //-------------------------------------------------------------------------------------------------
    // This task initiates the stream_ready transaction with ~axi4stream_transaction~ class handle as input.
    // Based on operation_mode, this task initiates the transaction in blocking or non blocking mode.
    // Default operation mode is AXI4STREAM_TRANSACTION_BLOCKING.
    // On completion of transaction onto bus, this task sets the transaction_done to 1.
    //-------------------------------------------------------------------------------------------------
    task automatic execute_stream_ready(input bit ready, input bit non_blocking_mode = 0);
      if(non_blocking_mode)
      begin
        fork
        begin
          `call_for_axi4stream_bfm(dvc_put_stream_ready)(
            QUESTA_MVC::QUESTA_MVC_COMMS_SENT,
            `call_for_axi4stream_bfm(get_axi4stream_slave_end)(),
            ready
            ); 
        end
        join_none
      end
      else
      begin
        `call_for_axi4stream_bfm(dvc_put_stream_ready)(
          QUESTA_MVC::QUESTA_MVC_COMMS_SENT,
          `call_for_axi4stream_bfm(get_axi4stream_slave_end)(),
          ready
          ); 
      end
    endtask

    //------------------------------------------------------------------------------
    //
    // Task: wait_on()
    //
    //------------------------------------------------------------------------------
    // This task waits for particular event from the BFM.
    //------------------------------------------------------------------------------
    task automatic wait_on( axi4stream_wait_e phase, input int count = 1 );
        case( phase )
            AXI4STREAM_CLOCK_POSEDGE : `call_for_axi4stream_bfm(wait_for_ACLK)( QUESTA_MVC::QUESTA_MVC_POSEDGE,     count );
            AXI4STREAM_CLOCK_NEGEDGE : `call_for_axi4stream_bfm(wait_for_ACLK)( QUESTA_MVC::QUESTA_MVC_NEGEDGE,     count );
            AXI4STREAM_CLOCK_ANYEDGE : `call_for_axi4stream_bfm(wait_for_ACLK)( QUESTA_MVC::QUESTA_MVC_ANYEDGE,     count );
            AXI4STREAM_CLOCK_0_TO_1  : `call_for_axi4stream_bfm(wait_for_ACLK)( QUESTA_MVC::QUESTA_MVC_0_TO_1_EDGE, count );
            AXI4STREAM_CLOCK_1_TO_0  : `call_for_axi4stream_bfm(wait_for_ACLK)( QUESTA_MVC::QUESTA_MVC_1_TO_0_EDGE, count );
            AXI4STREAM_RESET_POSEDGE : `call_for_axi4stream_bfm(wait_for_ARESETn)( QUESTA_MVC::QUESTA_MVC_POSEDGE,     count );
            AXI4STREAM_RESET_NEGEDGE : `call_for_axi4stream_bfm(wait_for_ARESETn)( QUESTA_MVC::QUESTA_MVC_NEGEDGE,     count );
            AXI4STREAM_RESET_ANYEDGE : `call_for_axi4stream_bfm(wait_for_ARESETn)( QUESTA_MVC::QUESTA_MVC_ANYEDGE,     count );
            AXI4STREAM_RESET_0_TO_1  : `call_for_axi4stream_bfm(wait_for_ARESETn)( QUESTA_MVC::QUESTA_MVC_0_TO_1_EDGE, count );
            AXI4STREAM_RESET_1_TO_0  : `call_for_axi4stream_bfm(wait_for_ARESETn)( QUESTA_MVC::QUESTA_MVC_1_TO_0_EDGE, count );
            default : $display("%0t: %m: Phase %s not supported in wait_on().", $time, phase.name());
        endcase
    endtask

endinterface

