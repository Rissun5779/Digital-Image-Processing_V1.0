// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/main/ip/pgm/altera_nd_mailbox_avst_adap/altera_nd_mailbox_avst_adap.sv#2 $
// $Revision: #2 $
// $Date: 2015/10/19 $
// $Author: tgngo $

// altera_nd_mailbox_avst_adap.v


`timescale 1 ps / 1 ps
module altera_nd_mailbox_avst_adap #(
        parameter APPEND_STR_INFO       = 0,
        parameter HAS_STREAM            = 0,
        parameter CLIENT_ID             = 0,
        parameter STR_MUX_SELECT        = 1'b0,
        parameter NUM_STR_ENDPOINTS     = 2,
        parameter CHANNEL_WIDTH         = 1,
        parameter DATA_WIDTH            = 32,
        parameter OUT_DATA_WIDTH        = 32,
        parameter CHANNEL_VALUE_DEC     = 1,
        parameter CHANNEL_VALUE_ONEHOT  = 1'b1,
        parameter IN_USE_PACKET         = 1,
        parameter OUT_USE_PACKET        = 1,
        parameter IN_USE_CHANNEL        = 1,
        parameter OUT_USE_CHANNEL       = 1,
        parameter OVERWRITE_CLIENT_ID   = 0
    ) (
        input                           clk,
        input                           reset,
        // +-----------------------------------------------------
        // | Input ST
        // +-----------------------------------------------------
        input [DATA_WIDTH-1:0]          in_data,
        input                           in_sop,
        input                           in_eop,
        output logic                    in_ready,
        input                           in_valid,
        input [CHANNEL_WIDTH-1:0]       in_channel,
        // +-----------------------------------------------------
        // | Output ST
        // +-----------------------------------------------------
        input                           out_ready,
        output logic                    out_valid,
        output logic [OUT_DATA_WIDTH-1:0]    out_data,
        output logic                    out_sop,
        output logic                         out_eop,
        output logic [CHANNEL_WIDTH-1:0]      out_channel
    );

    wire [15:0]                         client_channel;
    wire [15:0]                         streaming_channel;
    wire [15:0]                         client_id;
    //wire [NUM_STR_ENDPOINTS-1 : 0]      streaming_channel_to_store;
    
    // +-----------------------------------------------------
    // | Output mapping, dont touch these
    // +-----------------------------------------------------
    assign in_ready     = out_ready;
    assign out_valid    = in_valid;
    // in case of streamming client appeared, append some information into the out packet 
    // so that the id remapper can store these stuffs
    assign streaming_channel  = STR_MUX_SELECT;
    assign client_id    = CLIENT_ID;
    /*
    generate
        if (!APPEND_STR_INFO) begin
            assign out_data  = in_data;
        end
        else begin
            if (HAS_STREAM)
                assign out_data  = {streaming_channel[NUM_STR_ENDPOINTS-1 : 0], 1'b1, in_data};
            else
                assign out_data  = {streaming_channel[NUM_STR_ENDPOINTS-1 : 0], 1'b0, in_data};
        end
    endgenerate
    */
    generate
        if (!OVERWRITE_CLIENT_ID) begin
            assign out_data  = in_data;
        end
        else begin
            // if start_of_packet, then overwrite the CLIENT ID (bit: 31:28) at the header of the command
            // for argument, dont touch them
            always_comb begin
                if (in_sop)
                    out_data = {client_id[3:0], in_data[27:0]};
                else
                    out_data = in_data;
            end
        end
    endgenerate
    // +-----------------------------------------------------
    // | Channel mapping:
    // | if cmd path, then write a fixed channel value
    // | if resp path, just do assign but actually the enpoint not use it
    // +-----------------------------------------------------
    assign client_channel     = CHANNEL_VALUE_ONEHOT;
                               
    generate
        if (IN_USE_CHANNEL == 0) begin
            assign out_channel = client_channel[CHANNEL_WIDTH-1:0];
        end 
        else begin
            assign out_channel = in_channel;
        end
    endgenerate
    
    // +-----------------------------------------------------
    // | Packets mapping: 
    // | Mostly used for the urgent, 
    // | no other cases yet
    // +-----------------------------------------------------
    generate
        if (IN_USE_PACKET) begin
            assign out_sop  = in_sop;
            assign out_eop  = in_eop;
            
        end 
        else begin // packet with one word only
            assign out_sop  = 1'b1;
            assign out_eop  = 1'b1;
        end
    endgenerate


endmodule
