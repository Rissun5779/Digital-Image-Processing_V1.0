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

module altr_smb_rxshifter #(
    parameter SMB_SLV_RCV_HOLD_EN = 0,
    parameter SMB_DFLT_SLV_OA = 7'h0
) (
    input               clk,
    input               rst_n,
    input [6:0]         slv_oa,
    input               rls_bus_hold,
    input               rls_bus_hold_dly,
    input               ack_nack,
    input               slv_rx_en,
    input               slvfsm_idle_state,
    input               slvfsm_rx_addr_state,
    input               slvfsm_rx_addr_2_state,
    input               slvfsm_rx_loop_state,
    input               slvfsm_b2b_rxshift,
    input               sda_int,
    input               scl_edge_hl,	
    input               scl_edge_lh,
    input               start_det,
    input               stop_det,
    input               start_det_dly,
    input               txfifo_empty,
    input               rxfifo_full,

    output              push_rxfifo,
    output reg [7:0]    rx_shifter,
    output reg          slv_rx_sda_out,
    output              slv_rx_shift_done,
    output              slv_rx_shift_hold,
    output              rx_addr_match,
    output              rx_addr_2_match,
    output              update_crc_rx,
    output reg          dis_verify_crc

);


localparam IDLE          = 2'b00;
localparam RX_HOLD       = 2'b01; 
localparam RX_SLV_SHIFT  = 2'b10;
localparam RX_DONE       = 2'b11;


// wires & registers declaration
reg [1:0]           rx_shiftfsm_state, rx_shiftfsm_nx_state;
reg [3:0]	    rx_shiftbit_counter;
reg [3:0]	    rx_shiftbit_counter_nxt;
reg                 push_rxfifo_en_flp;
reg                 slv_rx_shift_done_gen;
reg                 slv_rx_shift_done_gen_dly;
//reg                 cmd_hold_phase;
reg                 ack_nack_flp;
//reg                 cmd_rcvd;
reg [6:0]	    sevenbit_addr;
reg                 rx_addr_2_mismatch_sw;

wire [3:0]	    rx_shiftbit_counter_init;
wire 		    rx_idle_state;
wire 		    rx_done_state;
//wire 		    rx_done_nx_state;
wire 		    not_rx_done_nx_state;
wire                rx_slv_shift_state;
wire                rx_slv_shift_nx_state;
wire 		    rx_hold_state;
wire 		    rx_hold_nx_state;
wire                arc_rx_done_rx_slv_shift;
wire                arc_rx_slv_shift_rx_hold;
wire                arc_rx_hold_rx_slv_shift;
//wire                arc_rx_slv_shift_rx_done;
wire                arc_out_of_rx_done;
wire 		    load_cnt;
wire 		    decr_cnt;
wire                push_rxfifo_en;
wire                rx_shiftbit_counter_notzero;
wire                slv_rcv_hold_en;

wire		    sevenbit_addr_matched;

wire                slv_rx_ack_nack;
wire                slv_rx_data_ack;
wire                address_phase;
//wire                ack_nack_mux;

assign slv_rcv_hold_en          = (SMB_SLV_RCV_HOLD_EN == 1) ? 1'b1 : 1'b0;
assign slv_rx_shift_hold        = rx_hold_state;

assign rx_idle_state            = (rx_shiftfsm_state == IDLE);
assign rx_done_state            = (rx_shiftfsm_state == RX_DONE);
assign rx_slv_shift_state       = (rx_shiftfsm_state == RX_SLV_SHIFT);
assign rx_hold_state            = (rx_shiftfsm_state == RX_HOLD);

//assign rx_done_nx_state         = (rx_shiftfsm_nx_state == RX_DONE);
assign not_rx_done_nx_state     = (rx_shiftfsm_nx_state != RX_DONE);
assign rx_slv_shift_nx_state    = (rx_shiftfsm_nx_state == RX_SLV_SHIFT);
assign rx_hold_nx_state         = (rx_shiftfsm_nx_state == RX_HOLD);

assign arc_rx_done_rx_slv_shift = rx_done_state & rx_slv_shift_nx_state;
assign arc_rx_slv_shift_rx_hold = rx_slv_shift_state & rx_hold_nx_state;
assign arc_rx_hold_rx_slv_shift = rx_hold_state & rx_slv_shift_nx_state;
//assign arc_rx_slv_shift_rx_done = rx_slv_shift_state & rx_done_nx_state;
assign arc_out_of_rx_done       = rx_done_state & not_rx_done_nx_state;

assign load_cnt                 = rx_idle_state | arc_rx_done_rx_slv_shift | start_det_dly; // dly version is used to handle timing different between start_det and !rx_idle_state (1 clk cycle different)
assign decr_cnt                 = slv_rx_en & scl_edge_hl & rx_shiftbit_counter_notzero;

assign rx_shiftbit_counter_notzero = | rx_shiftbit_counter;

assign push_rxfifo		= slv_rx_en & slvfsm_rx_loop_state & push_rxfifo_en_flp;

assign push_rxfifo_en           = (rx_shiftbit_counter == 4'b0001) & (rx_shiftbit_counter_nxt == 4'b0000);

assign update_crc_rx            = push_rxfifo_en_flp; // Intend to update the crc calculation when full 8 bit is received 

assign rx_shiftbit_counter_init = start_det_dly ? 4'b1001 : 4'b1000; // for slave mode, number of sclk_edge_hl is different between during start condition and during full byte transfer complete transition

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        push_rxfifo_en_flp <= 1'b0;
    else
        push_rxfifo_en_flp <= push_rxfifo_en;
end

always @* begin
    if (load_cnt)
        rx_shiftbit_counter_nxt = rx_shiftbit_counter_init;
    else if (decr_cnt)
        rx_shiftbit_counter_nxt = rx_shiftbit_counter - 4'b0001;
    else
        rx_shiftbit_counter_nxt = rx_shiftbit_counter;
end


// bit number counter
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        rx_shiftbit_counter <= 4'b1000;
    else
        rx_shiftbit_counter <= rx_shiftbit_counter_nxt;
end




// TX shifter fsm 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
       rx_shiftfsm_state <= IDLE;
    else
       rx_shiftfsm_state <= rx_shiftfsm_nx_state;
end

always @* begin
    case(rx_shiftfsm_state)
        IDLE	: begin
	    if (slv_rx_en)
	    	rx_shiftfsm_nx_state = RX_SLV_SHIFT;
	    else 
	    	rx_shiftfsm_nx_state = IDLE;
	end

	RX_HOLD	: begin
            if (~slv_rx_en)
	    	rx_shiftfsm_nx_state = IDLE;
	    else if (rls_bus_hold_dly)
		rx_shiftfsm_nx_state = RX_SLV_SHIFT; 
	    else 
		rx_shiftfsm_nx_state = RX_HOLD;
	end 

	RX_SLV_SHIFT : begin
	    if (~slv_rx_en)
		rx_shiftfsm_nx_state = IDLE;
	    //else if ((rx_shiftbit_counter == 4'b0001) & scl_edge_hl & cmd_hold_en & ~cmd_rcvd)
	    else if ((rx_shiftbit_counter == 4'b0001) & scl_edge_hl & slv_rcv_hold_en & (slvfsm_rx_loop_state | (slvfsm_rx_addr_2_state & ~rx_addr_2_match)))
		rx_shiftfsm_nx_state = RX_HOLD;
	    else if ((rx_shiftbit_counter == 4'b0000) & scl_edge_hl)
		rx_shiftfsm_nx_state = RX_DONE;
	    else
		rx_shiftfsm_nx_state = RX_SLV_SHIFT;
	end

	RX_DONE	: begin
	    if (~slv_rx_en)
		rx_shiftfsm_nx_state = IDLE;
            else if (slv_rx_en & slvfsm_b2b_rxshift)
		rx_shiftfsm_nx_state = RX_SLV_SHIFT;
	    else
		rx_shiftfsm_nx_state = RX_DONE;
	end

	default: rx_shiftfsm_nx_state = 3'bx;
      endcase
  end



always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
	slv_rx_sda_out              <= 1'b1;
	slv_rx_shift_done_gen       <= 1'b0;
    end
    else begin
	case(rx_shiftfsm_nx_state)
            IDLE : begin
                slv_rx_sda_out              <= 1'b1;
                slv_rx_shift_done_gen       <= 1'b0;
	    end

            RX_HOLD : begin
                slv_rx_sda_out              <= 1'b1;
                slv_rx_shift_done_gen       <= 1'b0;
	    end

            RX_SLV_SHIFT : begin
                if (rx_shiftbit_counter_nxt == 4'b0000) begin
		    slv_rx_sda_out          <= slv_rx_ack_nack;
		    slv_rx_shift_done_gen   <= 1'b0;
		end
		else if ((rx_shiftbit_counter_nxt != 4'b0000) & scl_edge_lh) begin // Not sure why this branch is needed. Leave it here until reason found
		    slv_rx_sda_out          <= 1'b1;
		    slv_rx_shift_done_gen   <= 1'b0;
		end
		else begin
		    slv_rx_sda_out          <= 1'b1;
		    slv_rx_shift_done_gen   <= 1'b0;
		end
            end

	    RX_DONE : begin
                slv_rx_shift_done_gen   <= 1'b1;
                slv_rx_sda_out          <= slv_rx_ack_nack;
	    end

	    default: begin
		 slv_rx_sda_out             <= 1'bx;
		 slv_rx_shift_done_gen      <= 1'bx;
	    end
	  endcase
	end
  end


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        rx_shifter <= 8'h0;
    else if (slv_rx_en & scl_edge_lh)
        rx_shifter[rx_shiftbit_counter - 1] <= sda_int;
end

// case:186657
// Internal slave address is locked during address phase to prevent SDA from toggling during high period of SCL in ack_nack phase due to changing of slv_oa register value.
// This is to prevent false STOP/START condition.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sevenbit_addr   <= SMB_DFLT_SLV_OA;
    else if (address_phase)
        sevenbit_addr   <= sevenbit_addr;
    else
        sevenbit_addr   <= slv_oa[6:0];
end

assign address_phase            = slvfsm_rx_addr_state | slvfsm_rx_addr_2_state;

assign sevenbit_addr_matched	= (rx_shifter[7:1] == sevenbit_addr);

assign rx_addr_match	        = sevenbit_addr_matched;

assign rx_addr_2_match	        = (rx_shifter[7:0] == {sevenbit_addr, 1'b1}); // 2nd address phase must be a read operation in order to be considered matched.

////////////////////////////////////////////////////////////////////////////////////////////////////// 
// ACK/NACK generation

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        ack_nack_flp   <= 1'b0;
    else if (rls_bus_hold)
        ack_nack_flp   <= ack_nack;
end

//always @(posedge clk or negedge rst_n) begin
//    if (!rst_n)
//        cmd_hold_phase  <= 1'b0;
//    else if (rx_hold_state)
//        cmd_hold_phase  <= 1'b1;
//    else if (arc_out_of_rx_done | rx_idle_state)
//        cmd_hold_phase  <= 1'b0;
//end

// Software control 2nd addr mismatch
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        rx_addr_2_mismatch_sw   <= 1'b0;
    else if (arc_rx_slv_shift_rx_hold & slvfsm_rx_addr_2_state)
        rx_addr_2_mismatch_sw   <= 1'b1;
    else if (arc_out_of_rx_done | rx_idle_state)
        rx_addr_2_mismatch_sw   <= 1'b0;
end


//assign slv_rx_data_ack  = cmd_hold_phase ? cmd_ack_nack_flp : 1'b0;
assign slv_rx_data_ack  = slv_rcv_hold_en ? ack_nack_flp : 1'b0;
			  
// case:186631 DUT should nack a mismatch 2nd slave address as well when SMB_SLV_RCV_HOLD_EN = 0 
//assign ack_nack_mux     = slvfsm_rx_addr_state | (slvfsm_rx_addr_2_state & ~slv_rcv_hold_en);
//assign ack_nack_mux     = slvfsm_rx_addr_state | (slvfsm_rx_addr_2_state & ~rx_addr_2_mismatch_sw);
//assign slv_rx_ack_nack  = (ack_nack_mux) ? ~rx_addr_match : slv_rx_data_ack; 

assign slv_rx_ack_nack  = slvfsm_rx_addr_state ? ~rx_addr_match : 
                              (slvfsm_rx_addr_2_state & ~rx_addr_2_mismatch_sw) ? ~rx_addr_2_match : slv_rx_data_ack; 

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Control bit to indicate whether command has been received

//always @(posedge clk or negedge rst_n) begin
//    if (!rst_n)
//        cmd_rcvd    <= 1'b0;
//    else if (slvfsm_idle_state)
//        cmd_rcvd    <= 1'b0;
//    else if (slvfsm_rls_rx_hold)
//        cmd_rcvd    <= 1'b1;
//end

/////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        slv_rx_shift_done_gen_dly   <= 1'b0;
    else
        slv_rx_shift_done_gen_dly   <= slv_rx_shift_done_gen;
end

assign slv_rx_shift_done    = slv_rx_shift_done_gen & ~slv_rx_shift_done_gen_dly;

/////////////////////////////////////////////////////////////////////////////////////////////////////
// case:188889 PEC_ERR assert after DUT send NACK
// disable verify crc when DUT is not acknowledge

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        dis_verify_crc   <= 1'b0;
    else if (arc_rx_hold_rx_slv_shift)
        dis_verify_crc   <= ack_nack;
    else if (start_det | stop_det)
        dis_verify_crc   <= 1'b0;
end

endmodule





