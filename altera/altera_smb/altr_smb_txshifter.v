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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altr_smb_txshifter (
    input               clk,
    input               rst_n,
    input               slv_tx_en,
    input               scl_edge_hl,
    input               load_tx_shifter,
    input [8:0]         txfifo_data_in,
    input               slvfsm_b2b_txshift,
    input               start_det_dly,
    input               slvfsm_tx_pec_state,
    input [7:0]         crc_code_out,
  
    output reg [8:0]    tx_shifter,
    output reg          slv_tx_chk_ack,                 // to ack detector
    output              slv_tx_shift_done,
    output reg          slv_tx_sda_out,
    output reg          update_crc_tx

);


parameter TX_IDLE       = 2'b00;
parameter TX_SLV_SHIFT  = 2'b01;
parameter TX_DONE       = 2'b10;


// wires & registers declaration
reg [1:0]       tx_shiftfsm_state; 
reg [1:0]       tx_shiftfsm_nx_state;
reg [3:0]       tx_shiftbit_counter;
reg [3:0]       tx_shiftbit_counter_nxt;
reg             slv_tx_shift_done_gen;
reg             slv_tx_shift_done_gen_dly;

wire            tx_idle_state;
wire            tx_done_state;
wire            load_cnt;
wire            decr_cnt;
wire            tx_slv_shift_nx_state;
wire [3:0]      tx_shiftbit_counter_init;
wire            arc_tx_done_slv_shift; 

wire [7:0]      tx_shift_data;

wire [7:0]      write_7bit_addr;
wire            tx_shiftbit_counter_notzero;
wire            update_crc_tx_preflp;

assign tx_idle_state            = (tx_shiftfsm_state == TX_IDLE);
assign tx_done_state            = (tx_shiftfsm_state == TX_DONE);

assign tx_slv_shift_nx_state    = (tx_shiftfsm_nx_state == TX_SLV_SHIFT);

assign arc_tx_done_slv_shift    = tx_done_state & tx_slv_shift_nx_state; 

assign load_cnt                 = tx_idle_state | arc_tx_done_slv_shift | start_det_dly;
assign decr_cnt                 = slv_tx_en & scl_edge_hl & tx_shiftbit_counter_notzero;

assign tx_shiftbit_counter_notzero  = | tx_shiftbit_counter;

assign tx_shiftbit_counter_init     = start_det_dly ? 4'b1001 : 4'b1000;

assign update_crc_tx_preflp         = (tx_shiftbit_counter == 4'b0001) & (tx_shiftbit_counter_nxt == 4'b0000);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        update_crc_tx <= 1'b0;
    else
        update_crc_tx <= update_crc_tx_preflp;
end



always @* begin
    if (load_cnt)
        tx_shiftbit_counter_nxt = tx_shiftbit_counter_init;
    else if (decr_cnt)
        tx_shiftbit_counter_nxt = tx_shiftbit_counter - 4'b0001;
    else
        tx_shiftbit_counter_nxt = tx_shiftbit_counter;
end

// bit number counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        tx_shiftbit_counter <= 4'b1000;
    else
        tx_shiftbit_counter <= tx_shiftbit_counter_nxt;
end




// TX shifter fsm 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        tx_shiftfsm_state <= TX_IDLE;
    else
        tx_shiftfsm_state <= tx_shiftfsm_nx_state;
end

always @* begin
    case(tx_shiftfsm_state)
        TX_IDLE	: begin
            if (slv_tx_en)
                tx_shiftfsm_nx_state = TX_SLV_SHIFT;
            else 
                tx_shiftfsm_nx_state = TX_IDLE;
        end

        TX_SLV_SHIFT : begin 
            if (~slv_tx_en)
                tx_shiftfsm_nx_state = TX_IDLE;
            else if ((tx_shiftbit_counter == 4'b0000) & scl_edge_hl)
                tx_shiftfsm_nx_state = TX_DONE;
            else
                tx_shiftfsm_nx_state = TX_SLV_SHIFT;
        end

        TX_DONE	: begin
            if (~slv_tx_en)
                tx_shiftfsm_nx_state = TX_IDLE;
            else if (slv_tx_en & slvfsm_b2b_txshift)
                tx_shiftfsm_nx_state = TX_SLV_SHIFT;
            else
                tx_shiftfsm_nx_state = TX_DONE;
        end

	default: tx_shiftfsm_nx_state = 3'bx;

    endcase
end



always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        slv_tx_chk_ack              <= 1'b0;
        slv_tx_shift_done_gen       <= 1'b0;
        slv_tx_sda_out              <= 1'b1;
    end
    else begin
        case(tx_shiftfsm_nx_state)
            TX_IDLE : begin
                slv_tx_chk_ack              <= 1'b0;
                slv_tx_shift_done_gen       <= 1'b0;
                slv_tx_sda_out              <= 1'b1;
            end

            TX_SLV_SHIFT : begin
                slv_tx_shift_done_gen       <= 1'b0;

                if (tx_shiftbit_counter_nxt == 4'b0000) begin	//4'b0000 is bit-8 ACK waiting
                    slv_tx_chk_ack          <= 1'b1;
                    slv_tx_sda_out          <= 1'b1;
                end
                else begin
                    slv_tx_chk_ack          <= 1'b0;
                    slv_tx_sda_out          <= tx_shift_data[tx_shiftbit_counter_nxt-1];
                end
            end

	    TX_DONE	: begin
                slv_tx_chk_ack              <= 1'b1;
                slv_tx_sda_out              <= 1'b1;
                slv_tx_shift_done_gen   <= 1'b1;
	    end

	    default: begin
                slv_tx_chk_ack              <= 1'bx;
                slv_tx_shift_done_gen       <= 1'bx;
                slv_tx_sda_out              <= 1'bx;
	    end
        endcase
    end
end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        tx_shifter  <= 9'h0;
    else if (load_tx_shifter) // change to delay version due to scfifo take one clock to output the read data
        tx_shifter  <= txfifo_data_in;
    else
        tx_shifter  <= tx_shifter;
end

assign tx_shift_data        = slvfsm_tx_pec_state ? crc_code_out : tx_shifter[7:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        slv_tx_shift_done_gen_dly   <= 1'b0;
    end
    else begin
        slv_tx_shift_done_gen_dly   <= slv_tx_shift_done_gen;
    end
end

assign slv_tx_shift_done    = slv_tx_shift_done_gen & ~slv_tx_shift_done_gen_dly;

endmodule



