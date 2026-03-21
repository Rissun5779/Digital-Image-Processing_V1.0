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


// $Id: //acds/main/ip/altera_voltage_sensor/control/altera_voltage_sensor_control.sv#3 $
// $Revision: #3 $
// $Date: 2015/01/18 $
// $Author: tgngo $


// +-----------------------------------------------------------
// | Nadder SDM mailbox scheduler: select which command to send
// |  to SDM
// +-----------------------------------------------------------
`timescale 1 ns/ 1 ns

module altera_mailbox_scheduler
#(
    parameter IN_CMD_DATA_W   = 64,
    parameter IN_URG_DATA_W   = 32,
    parameter IN_RD_DATA_W    = 6,
    parameter IN_REQ_DATA_W   = 6,
    parameter OUT_DATA_W      = 75
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                           clk,
    input                           reset,
    
    // +--------------------------------------------------
    // | Avl ST command packet signals
    // +--------------------------------------------------
    input [IN_CMD_DATA_W-1 : 0]     cmd_data,
    input                           cmd_valid,
    input                           cmd_startofpacket,
    input                           cmd_endofpacket,
    output                          cmd_ready,

    input [IN_URG_DATA_W-1 : 0]     urg_data,
    input                           urg_valid,
    input                           urg_startofpacket,
    input                           urg_endofpacket,
    output                          urg_ready,

    // +--------------------------------------------------
    // | Avl ST output packet signals
    // +--------------------------------------------------
    output reg [OUT_DATA_W-1 : 0]   src_data,
    output reg                      src_valid,
    output reg                      src_startofpacket,
    output reg                      src_endofpacket,
    input                           src_ready,

    // +--------------------------------------------------
    // | Request packet signals
    // +--------------------------------------------------
    input reg [IN_REQ_DATA_W-1 : 0] cmd_req_data,
    input                           cmd_req_valid,
    output                          cmd_req_ready,

    input reg [IN_RD_DATA_W-1 : 0]  rd_req_data,
    input                           rd_req_valid,
    output                          rd_req_ready,
        
    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    input                           gpo_write,
    input [7:0]                     gpo_data
 );
    
    wire [OUT_DATA_W-1 : 0]         pck_req_data;
    wire                            pck_req_valid;
    wire                            pck_req_ready;
    wire                            pck_req_startofpacket;
    wire                            pck_req_endofpacket;



    altera_mailbox_scheduler_controller #(
        .IN_CMD_DATA_W (IN_CMD_DATA_W),
        .IN_REQ_DATA_W (IN_REQ_DATA_W),
        .IN_RD_DATA_W  (IN_RD_DATA_W),
        .IN_URG_DATA_W (IN_URG_DATA_W),
        .OUT_DATA_W    (OUT_DATA_W)
    ) mailbox_scheduler_ctrl (
        .clk                    (clk),            
        .reset                  (reset),          
        .src_endofpacket        (src_endofpacket),       
        .src_valid              (src_valid),              
        .src_startofpacket      (src_startofpacket),      
        .src_ready              (src_ready),              
        .src_data               (src_data),               
        .gpo_write              (gpo_write),          
        .gpo_data               (gpo_data),           
        .cmd_valid              (cmd_valid),         
        .cmd_startofpacket      (cmd_startofpacket), 
        .cmd_endofpacket        (cmd_endofpacket),   
        .cmd_ready              (cmd_ready),         
        .cmd_data               (cmd_data),          
        .urg_valid              (urg_valid),         
        .urg_startofpacket      (urg_startofpacket), 
        .urg_endofpacket        (urg_endofpacket),   
        .urg_ready              (urg_ready),         
        .urg_data               (urg_data),          
        .cmd_req_valid          (cmd_req_valid),          
        .cmd_req_ready          (cmd_req_ready),          
        .cmd_req_data           (cmd_req_data),           
        .rd_req_valid           (rd_req_valid),           
        .rd_req_ready           (rd_req_ready),           
        .rd_req_data            (rd_req_data),
        .pck_req_data           (pck_req_data),
        .pck_req_valid          (pck_req_valid),
        .pck_req_ready          (pck_req_ready),
        .pck_req_startofpacket  (pck_req_startofpacket),
        .pck_req_endofpacket    (pck_req_endofpacket)             
    );

    sheduler_default_reset #(
        .IN_CMD_DATA_W (IN_CMD_DATA_W),
        .IN_REQ_DATA_W (IN_REQ_DATA_W),
        .IN_RD_DATA_W  (IN_RD_DATA_W),
        .IN_URG_DATA_W (IN_URG_DATA_W),
        .OUT_DATA_W    (OUT_DATA_W)
    ) reset_default_cmd (
        .clk                    (clk),            
        .reset                  (reset),
        .pck_req_data           (pck_req_data),
        .pck_req_valid          (pck_req_valid),
        .pck_req_ready          (pck_req_ready),
        //.pck_req_ready          (1'b1),
        .pck_req_startofpacket  (pck_req_startofpacket),
        .pck_req_endofpacket    (pck_req_endofpacket)
        );
    
    
    
    
    
endmodule


module altera_mailbox_scheduler_controller
#(
    parameter IN_CMD_DATA_W   = 64,
    parameter IN_URG_DATA_W   = 32,
    parameter IN_RD_DATA_W    = 6,
    parameter IN_REQ_DATA_W   = 6,
    parameter OUT_DATA_W      = 75
  )    
   (
    // +--------------------------------------------------
    // | Clock and reset
    // | Note reset will be synchronous
    // +--------------------------------------------------
    input                           clk,
    input                           reset,
    
    // +--------------------------------------------------
    // | Avl ST command packet signals
    // +--------------------------------------------------
    input [IN_CMD_DATA_W-1 : 0]     cmd_data,
    input                           cmd_valid,
    input                           cmd_startofpacket,
    input                           cmd_endofpacket,
    output                          cmd_ready,

    input [IN_URG_DATA_W-1 : 0]     urg_data,
    input                           urg_valid,
    input                           urg_startofpacket,
    input                           urg_endofpacket,
    output                          urg_ready,

    // +--------------------------------------------------
    // | Avl ST output packet signals
    // +--------------------------------------------------
    output reg [OUT_DATA_W-1 : 0]   src_data,
    output reg                      src_valid,
    output reg                      src_startofpacket,
    output reg                      src_endofpacket,
    input                           src_ready,

    // +--------------------------------------------------
    // | Request packet signals
    // +--------------------------------------------------
    input reg [IN_REQ_DATA_W-1 : 0] cmd_req_data,
    input                           cmd_req_valid,
    output                          cmd_req_ready,

    input reg [IN_RD_DATA_W-1 : 0]  rd_req_data,
    input                           rd_req_valid,
    output                          rd_req_ready,


    input [OUT_DATA_W-1 : 0]        pck_req_data,
    input                           pck_req_valid,
    output                          pck_req_ready,
    input                           pck_req_startofpacket,
    input                           pck_req_endofpacket,
        
    // +--------------------------------------------------
    // | GPIO signals
    // +--------------------------------------------------
    input                           gpo_write,
    input [7:0]                     gpo_data
 );
    // Out data width, sop and eop
    localparam PAYLOAD_W  = OUT_DATA_W + 2;
    localparam IRQ_DATA_W = 32;
    // +--------------------------------------------------
    // | Internal signals
    // +--------------------------------------------------
    wire [31 : 0]                    cmd_cin;
        
    wire [4 : 0]                     request;
    wire [5 : 0]                     valid;
    reg [5 : 0]                      grant;
    
    wire [PAYLOAD_W - 1 : 0]         rst_payload;
    wire [PAYLOAD_W - 1 : 0]         cmd_payload;
    wire [PAYLOAD_W - 1 : 0]         urg_payload;
    wire [PAYLOAD_W - 1 : 0]         rd_payload;
    wire [PAYLOAD_W - 1 : 0]         cin_payload;
    wire [PAYLOAD_W - 1 : 0]         irq_payload;
    reg [PAYLOAD_W - 1 : 0]          src_payload;

    wire [4 : 0]                     cmd_length_req;
    reg                              cin_valid;
    wire [4 : 0]                     cin_value;
    reg                              irq_valid;
    reg [4 : 0]                      cmd_words_counter;
    reg [4 : 0]                      next_cmd_words_counter;
    reg                              cmd_counter_done;
    reg [6 : 0]                      bytecount;
    reg [6 : 0]                      total_bytecount;
    
    // For command packet, recalcute sop and eop as they are not same from client anymore
    reg                              cmd_startofpacket_int;
    reg                              cmd_endofpacket_int;
    wire                             src_accepted;
    
    reg [31 : 0]                     cin_data;
    reg [63 : 0]                     irq_data;
    reg [31 : 0]                     rout_data;
    
    wire [OUT_DATA_W - 1 : 0]        cmd_out_packet;
    wire [OUT_DATA_W - 1 : 0]        urg_out_packet;
    wire [OUT_DATA_W - 1 : 0]        rd_out_packet;
    wire [OUT_DATA_W - 1 : 0]        cin_out_packet;
    wire [OUT_DATA_W - 1 : 0]        irq_out_packet;

    
    // State machine
    typedef enum bit [6:0]
    {
     ST_IDLE            = 7'b0000001,
     ST_SEND_RESET      = 7'b0000010,
     ST_SEND_URG        = 7'b0000100,
     ST_SEND_RD         = 7'b0001000,
     ST_SEND_CMD        = 7'b0010000,
     ST_SEND_CIN        = 7'b0100000,
     ST_SEND_IRQ        = 7'b1000000
     } t_state;
    t_state state, next_state;
    

    // +--------------------------------------------------
    // | Load input
    // +--------------------------------------------------
    assign cin_value          = cmd_req_data[4 : 0];
    assign cmd_length_req     = cmd_req_data[4:0];
    always_comb begin
        total_bytecount = cmd_length_req << 2'b10;
    end

    // +--------------------------------------------------
    // | State Machine: update state
    // +--------------------------------------------------
    // |
    always_ff @(posedge clk) begin
        if (reset)
            state <= ST_IDLE;
        else
            state <= next_state;
    end
    // +--------------------------------------------------
    // | State Machine: next state condition
    // +--------------------------------------------------
    // the machine works in a way that when send cmd out, it expects cin update is following
    // so the cmd controller must work that way, we want send command as soon as we can.
    // so the scheduler finish CIN update after that
    
    always_comb begin
        next_state  = ST_IDLE;
        case (state)
            ST_IDLE: begin
                next_state  = ST_IDLE;
                // it has priority: reset , urg, rd and cmd
                if (pck_req_valid)
                    next_state = ST_SEND_RESET;
                else if (urg_valid)
                    next_state  = ST_SEND_URG;
                else if (rd_req_valid)
                    next_state  = ST_SEND_RD;
                else if (cmd_req_valid)
                    next_state  = ST_SEND_CMD;
            end

            ST_SEND_RESET: begin 
                next_state = ST_SEND_RESET;
                if (src_accepted && pck_req_endofpacket)
                    next_state = ST_IDLE;
            end

            ST_SEND_URG: begin
                next_state  = ST_SEND_URG;
                if (src_accepted) begin
                    if (rd_req_valid)
                        next_state  = ST_SEND_RD;
                    else if (cmd_req_valid)
                        next_state  = ST_SEND_CMD;
                    else
                        next_state  = ST_SEND_IRQ;
                end
            end

            ST_SEND_RD: begin
                next_state  = ST_SEND_RD;
                if (src_accepted) begin
                    if (cmd_req_valid)
                        next_state  = ST_SEND_CMD;
                    else
                        next_state  = ST_SEND_IRQ;
                end
            end
                        
            ST_SEND_CMD: begin
                next_state  = ST_SEND_CMD;
                if (cmd_endofpacket && src_accepted)
                    next_state  = ST_SEND_CIN;
            end
            
            ST_SEND_CIN: begin
                next_state  = ST_SEND_CIN;
                if (src_accepted)
                    next_state  = ST_SEND_IRQ;
            end

            ST_SEND_IRQ: begin
                next_state  = ST_SEND_IRQ;
                if (src_ready)
                    next_state  = ST_IDLE;
            end

        endcase // case (state)
    end // always_comb
    
    // +--------------------------------------------------
    // | State Machine: state outputs
    // +--------------------------------------------------
    // note grant signal here
    // grant[0]  : reset packet whic hto clear CIN, URG and ROUT to zeor
    // grant[1]  : urgent packet
    // grant[2]  : read update (ROUT) packet
    // grant[3]  : command packet
    // grant[4]  : cin_update packet
    // grant[5]  : interrupt packet
    
    always_comb begin
        grant                 = 6'b000000;
        cin_valid             = '0;
        irq_valid             = '0;
        case (state)
            ST_IDLE: begin
                grant                 = 6'b000000;
                cin_valid             = '0;
                irq_valid             = '0;
            end
            
            ST_SEND_RESET: begin
                grant                 = 6'b000001;
                cin_valid             = '0;
                irq_valid             = '0;
            end

            ST_SEND_URG: begin
                grant                 = 6'b000010;
                cin_valid             = '0;
                irq_valid             = '0;
            end
            
            ST_SEND_RD: begin
                grant                 = 6'b000100;
                cin_valid             = '0;
                irq_valid             = '0;
            end
            
            ST_SEND_CMD: begin
                grant                 = 6'b001000;
                cin_valid             = '0;
                irq_valid             = '0;
            end
            
            ST_SEND_CIN: begin
                grant                 = 6'b010000;
                cin_valid             = cmd_req_valid;
                irq_valid             = '0;
            end
            
            ST_SEND_IRQ: begin
                grant                 = 6'b100000;
                cin_valid             = 0;
                irq_valid             = '1;
            end
        endcase // case (state)
    end
    // | 
    // +--------------------------------------------------
    
    // +--------------------------------------------------
    // | Bytecount: the number of byte for this burst
    // +--------------------------------------------------
    reg [6 : 0] burst_bytecount;
    wire [6 : 0] bytecount_left;

    assign bytecount_left = bytecount - 7'h4;
    always_comb begin
        //if (cmd_words_counter == '0)
        if (cmd_startofpacket)
            bytecount  = total_bytecount;
        else
            bytecount  = burst_bytecount;
    end
    
    always_ff @(posedge clk) begin
        if (reset)
            burst_bytecount <= '0;
        else begin
            if (src_accepted)
                burst_bytecount <= bytecount_left;
        end
    end
    
    // ------------------------------------------
    // ------------------------------------------
    // Mux and output signals
    //
    // Implemented as a sum of products.
    // ------------------------------------------
    // ------------------------------------------
    // grant[0]  : urgent packet
    // grant[1]  : read update (ROUT) packet
    // grant[2]  : command packet
    // grant[3]  : cin_update packet
    // grant[4]  : interrupt packet
    assign valid[0] = pck_req_valid;
    assign valid[1] = urg_valid;
    assign valid[2] = rd_req_valid;
    assign valid[3] = cmd_valid;
    assign valid[4] = cin_valid;
    assign valid[5] = irq_valid;

    always_comb begin
        src_payload =
                     rst_payload & {PAYLOAD_W {grant[0]} } |
                     urg_payload & {PAYLOAD_W {grant[1]} } |
                     rd_payload  & {PAYLOAD_W {grant[2]} } |
                     cmd_payload & {PAYLOAD_W {grant[3]} } |
                     cin_payload & {PAYLOAD_W {grant[4]} } |
                     irq_payload & {PAYLOAD_W {grant[5]} };
    end

    assign src_accepted   = src_valid && src_ready;    
    assign src_valid      = |(grant & valid);
    assign cmd_ready      = src_ready && grant[3];
    assign urg_ready      = src_ready && grant[1];
    assign rd_req_ready   = src_ready && grant[2];          
    assign cmd_req_ready  = (((state == ST_SEND_CMD) && cmd_endofpacket) || (state == ST_SEND_CIN)) && src_accepted;
    assign pck_req_ready  = src_ready && grant[0];
    // ------------------------------------------
    // Mux Payload Mapping
    // ------------------------------------------
    // Register address mapping
    // 0x0	CIN	    to SDM	Command valid offset
    // 0x4	ROUT	to SDM	Response output offset
    // 0x8	URG	    to SDM 	Urgent command
    // 0x0C	RESERVED		
    // 0x10	BASE	To SDM	Holds the base address and size of the circular buffer
    // 0x14
    // ..
    // 0x3C	RESERVED		
    // 0x40
    //      COMMAND FIFO	to SDM	
    // 0x7C	
    // 0x80
    //      RESPONSE FIFO	from SDM	
    // 0xFC	
    // 0x400 IRQ	    R/W1(S|C)	
    // 0x500 STREAM	W	Values written to this register when enabled go to the configuration system

    // the offset of SDM mailbox address???? see from axi interface

    assign cin_data  = {27'h0, cin_value};
    assign rout_data = {26'h0, rd_req_data};
    // IRQ packet is address of IRQ (update FD), and value to be written is 1 R/W1(S|C)
    assign irq_data  = {32'h400, 32'h1};
    
    // Construct the ouput packet by assing soome needed field
    // {bytecount, byteenable, address, data}
    // bytecount: it just stand for burst length, use by the width adapter later
    // byteenable: need this to shift the byte to correct location by width adapter when
    //             we go from narrow to wide
    // Note that for normal packet, CIN update, ROUT update, IRQ: the address is written here
    // but for command packet, it comes from the commmand controller.
    //
    assign cmd_out_packet  = {7'h4, 4'hF,cmd_data};
    assign urg_out_packet  = {7'h4, 4'hF,32'h8, urg_data};
    assign cin_out_packet  = {7'h4, 4'hF,32'h0, cin_data};
    assign irq_out_packet  = {7'h4, 4'hF, irq_data};
    assign rd_out_packet   = {7'h4, 4'hF,32'h4, rout_data};
    
    // note that we are using "generated" sop and eop for command packet, not the 
    // original from the command controller.
    //assign cmd_payload = {cmd_out_packet, cmd_startofpacket_int, cmd_endofpacket_int};
    assign cmd_payload = {cmd_out_packet, cmd_startofpacket, cmd_endofpacket};
    assign urg_payload = {urg_out_packet, urg_startofpacket, urg_endofpacket};
    assign rd_payload = {rd_out_packet, 1'b1, 1'b1};
    assign cin_payload = {cin_out_packet, 1'b1, 1'b1};
    assign irq_payload = {irq_out_packet, 1'b1, 1'b1};
    assign rst_payload = {pck_req_data, 1'b1, 1'b1};
    // overwrite some field in our data
    always_comb begin
        {src_data,src_startofpacket,src_endofpacket}  = src_payload;
        if (state == ST_SEND_CMD) begin
            src_data[74 : 68]  = bytecount;
        end
    end

endmodule // altera_mailbox_cmd_controller

module sheduler_default_reset
    #(
        parameter IN_CMD_DATA_W   = 64,
        parameter IN_URG_DATA_W   = 32,
        parameter IN_RD_DATA_W    = 6,
        parameter IN_REQ_DATA_W   = 6,
        parameter OUT_DATA_W      = 75
    )    
    (
    // +-----------------------
    // | Clock and reset
    // +-----------------------
    input                           clk,
    input                           reset,
     // +----------------------
     // | Output signals
     // +----------------------

    output reg [OUT_DATA_W-1 : 0]   pck_req_data,
    output                          pck_req_valid,
    input                           pck_req_ready,
    output                          pck_req_startofpacket,
    output                          pck_req_endofpacket
    );


    // +-------------------------------------------------------
    // | Internal signals
    // +-------------------------------------------------------
    //assign urg_out_packet  = {7'h4, 4'hF,32'h8, urg_data};
    //assign cin_out_packet  = {7'h4, 4'hF,32'h0, cin_data};
    //assign irq_out_packet  = {7'h4, 4'hF, irq_data};
    //assign rd_out_packet   = {7'h4, 4'hF,32'h4, rout_data};
    // Builder pre-defined data of CIN, URG and ROUT packet 
    // to update the register inside mailbox when reset happen
    reg [OUT_DATA_W-1 : 0] data_internal [2 : 0];
    // order: 0: CIN, 1: URG, 2: ROUT
    always_comb begin
        data_internal[0]  = {7'h4, 4'hF,32'h0, 32'h0};
        data_internal[1]  = {7'h4, 4'hF,32'h8, 32'h0};
        data_internal[2]  = {7'h4, 4'hF,32'h4, 32'h0};
    end

    // +-------------------------------------------------------
    // | Reset trigger: detect when reset has been asserted
    // +-------------------------------------------------------
    reg reset_trigger;
    reg reset_trigger_dly;
    wire reset_trigger_pulse;
    reg rff;
    reg valid_req;
    always_ff @(posedge clk)
    begin
        if (reset)
            {reset_trigger, rff} <= 2'b11;
        else
        {reset_trigger, rff} <= {rff, 1'b0};
    end
    always_ff @(posedge clk)
    begin
        reset_trigger_dly <= reset_trigger;
    end
    // 1 -> 0 reset trigger detection
    assign reset_trigger_pulse = !reset_trigger && reset_trigger_dly;
    
    // +-------------------------------------------------------
    // | counter to read that packet data out from the register set
    // +-------------------------------------------------------
    reg [1:0] counter;
    wire [1:0] next_counter;
    always_ff @(posedge clk)
    begin
        if (reset)
            counter <= '0;
        else begin
            if (valid_req) begin
                counter <= next_counter;
                if (pck_req_endofpacket && pck_req_ready)
                    counter <= '0;
            end

        end
    end
    assign next_counter = (valid_req && pck_req_ready) ? counter + 2'b01 : counter;


    always_ff @(posedge clk)
    begin
        if (reset)
            valid_req <= '0;
        else begin
            if (reset_trigger_pulse)
                valid_req <= 1'b1;
            else if (pck_req_endofpacket && pck_req_ready)
                valid_req <= 1'b0;
        end
    end
    
    // +-------------------------------------------------------
    // | Output mapping
    // +-------------------------------------------------------
    always_comb begin
        pck_req_data = data_internal[counter];
    end
    assign pck_req_startofpacket    = (counter == 2'h0);
    assign pck_req_endofpacket      = (counter == 2'h2);
    assign pck_req_valid            = valid_req;

    /*
    
    enum
    {
    IDLE,
    CIN_UPT,
    URG_UPT,
    ROUT_UPT
    } state, next_state;

    // +-------------------------------------------------------
    // | State machine: updates state
    // +-------------------------------------------------------
    always_ff @(posedge clk)
    begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // +-------------------------------------------------------
    // | State machine: next state conditions
    // +-------------------------------------------------------
    always_comb
    begin
        case (state)
            IDLE: begin
                if (reset_trigger_pulse)
                    next_state = CIN_UPT;
                else
                    next_state  = IDLE;
            end
            CIN_UPT: begin 
                if (pck_req_ready)
                    next_state = URG_UPT;
                else
                    next_state = CIN_UPT;

            end
            URG_UPT: begin
                if (pck_req_ready)
                    next_state  = ROUT_UPT;
                else
                    next_state = URG_UPT;
            end
            ROUT_UPT: begin
                if (pck_req_ready)
                    next_state  = IDLE;
                else
                    next_state = ROUT_UPT;
            end
            endcase
        end

        // +-------------------------------------------------------
    // | State machine: state outputs
    // +-------------------------------------------------------
    always_comb
    begin
        case (state)
            IDLE: begin
                pck_req_startofpacket   = 1'b0;
                pck_req_endofpacket   = 1'b0;
                pck_req_valid           = 1'b0;
            end

            CIN_UPT: begin
                pck_req_startofpacket   = 1'b1;
                pck_req_endofpacket   = 1'b0;
                pck_req_valid           = 1'b1;
            end
            URG_UPT: begin
                pck_req_startofpacket   = 1'b0;
                pck_req_endofpacket   = 1'b0;
                pck_req_valid           = 1'b1;
            end
            ROUT_UPT: begin
                pck_req_startofpacket   = 1'b0;
                pck_req_endofpacket   = 1'b1;
                pck_req_valid           = 1'b1;
            end
        endcase
    end
    */

endmodule
