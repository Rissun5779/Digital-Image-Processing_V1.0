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

module altr_smb_slvfsm #(
    parameter SMB_SLV_RCV_HOLD_EN = 0,
    parameter SMB_PEC_EN = 1
) (
    input           clk,
    input           rst_n,
    input           smben,
    input [15:0]    tsudat,
    input           rls_bus_hold,
    input           rls_bus_hold_dly,
    input	    start_det,
    input	    stop_det,
    input	    ack_det,
    input	    slv_tx_shift_done,
    input	    slv_rx_shift_done,
    input           slv_rx_shift_hold,
    input	    rx_addr_match,
    input	    rx_addr_2_match,
    input [7:0]     rx_shifter,
    input	    txfifo_empty,
    input [8:0]     tx_shifter,
    input           set_clklow_tmout,
    input           update_crc_rx,
    input           update_crc_tx,
    input           dis_verify_crc,

    output reg	    slv_rx_en,
    output reg	    slv_tx_en,
    output          slvfsm_b2b_txshift,
    output reg      slvfsm_b2b_rxshift,
    output	    load_tx_shifter,
    output reg      slvfsm_idle_state,
    output reg	    slvfsm_rx_addr_state,
    output reg	    slvfsm_rx_addr_2_state,
    output reg	    slvfsm_rx_loop_state,
    output reg	    slvfsm_tx_pec_state,
    output reg	    slv_tx_scl_out,
    output reg	    slv_rx_scl_out,
    output          set_tx_data_req,
    output          set_slv_addr_err,
    output          set_nack_by_mst,
    output          set_stop_cond,
    output          update_crc,
    output [7:0]    crc_data_in,
    output          flush_crc,
    output          verify_crc


);


reg [2:0]   slv_fsm_state;
reg [2:0]   slv_fsm_state_nxt;
reg         slvfsm_idle_state_nxt;
reg	    slvfsm_rx_addr_state_nxt;
reg	    slvfsm_rx_addr_2_state_nxt;
reg	    slvfsm_wait_data_state_nxt;
reg	    slvfsm_wait_data_state;
reg         slvfsm_rx_loop_state_nxt;
reg	    slvfsm_tx_loop_state;
reg	    slvfsm_tx_loop_state_nxt;
reg	    slvfsm_rx_hold_state;
reg	    slvfsm_rx_hold_state_nxt;
reg	    slvfsm_tx_pec_state_nxt;
reg         slv_tx_scl_out_nxt;
reg         slv_rx_scl_out_nxt;
reg	    slv_tx_en_nxt;
reg	    slv_rx_en_nxt;
reg [15:0]  sda_setup_cnt;
reg [15:0]  sda_setup_cnt_nxt;
reg         arc_wait_data_tx_loop_flp;
reg         arc_idle_rx_addr_flp;
reg         arc_rx_hold_rx_loop_flp;
reg         arc_rx_hold_rx_addr_2_flp;
reg         arc_tx_loop_tx_pec_flp;
reg         slvfsm_b2b_txshift_ld;
reg         rx_addr_2_flag;
reg         core_sel;

wire	    arc_wait_data_tx_loop;
wire	    arc_rx_hold_rx_loop;
wire	    arc_rx_hold_rx_addr_2;
wire        arc_rx_addr_wait_data;
wire        arc_rx_addr_rx_loop;
wire        arc_rx_addr_2_wait_data;
wire        arc_tx_loop_wait_data;
wire        arc_tx_loop_tx_pec;
wire        arc_idle_rx_addr;
wire        arc_rx_addr_2_rx_hold;
wire	    sda_setup_scl_out;
wire        slvfsm_b2b_txshift_ld_pre_flp; // load_tx_shifter version
wire        slvfsm_b2b_rxshift_pre_flp;
wire        rx_shifter_rw;
wire        tx_shifter_last_byte;
wire        tx_shifter_last_byte_pec;

localparam [2:0]    IDLE	= 3'b000;
localparam [2:0]    RX_ADDR	= 3'b001;
localparam [2:0]    RX_ADDR_2	= 3'b010;
localparam [2:0]    RX_LOOP     = 3'b011;
localparam [2:0]    RX_HOLD	= 3'b100;
localparam [2:0]    WAIT_DATA	= 3'b101;
localparam [2:0]    TX_LOOP	= 3'b110;
localparam [2:0]    TX_PEC	= 3'b111;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        slv_fsm_state <= IDLE;
    else
        slv_fsm_state <= slv_fsm_state_nxt;
end


always @* begin
    case (slv_fsm_state)
        IDLE: begin
            if (smben & start_det)
                slv_fsm_state_nxt = RX_ADDR;
            else
                slv_fsm_state_nxt = IDLE;
        end

	RX_ADDR:  begin
            if (stop_det | set_clklow_tmout | (slv_rx_shift_done & ~rx_addr_match))
                slv_fsm_state_nxt = IDLE;
	    else if (slv_rx_shift_done & rx_addr_match & rx_shifter_rw)
		slv_fsm_state_nxt = WAIT_DATA;
            else if (slv_rx_shift_done & rx_addr_match & ~rx_shifter_rw)
                slv_fsm_state_nxt = RX_LOOP;
	    else  
		slv_fsm_state_nxt = RX_ADDR;
	end

	RX_ADDR_2:  begin
            if (stop_det | set_clklow_tmout | (slv_rx_shift_done & ~rx_addr_2_match))
                slv_fsm_state_nxt = IDLE;
	    //else if (slv_rx_shift_done & rx_addr_match & rx_shifter_rw)
	    else if (slv_rx_shift_done & rx_addr_2_match)
		slv_fsm_state_nxt = WAIT_DATA;
	    else if (slv_rx_shift_hold)
                slv_fsm_state_nxt = RX_HOLD;
            else
		slv_fsm_state_nxt = RX_ADDR_2;
	end

	RX_LOOP: begin
	    if (stop_det | set_clklow_tmout | (slv_rx_shift_done & ~smben))
		slv_fsm_state_nxt = IDLE;
	    else if (start_det)
		slv_fsm_state_nxt = RX_ADDR_2;
	    else if (slv_rx_shift_hold)
		slv_fsm_state_nxt = RX_HOLD;
	    else
		slv_fsm_state_nxt = RX_LOOP;
	end
	
        RX_HOLD: begin
	    if (stop_det | set_clklow_tmout | ~smben)
		slv_fsm_state_nxt = IDLE;
	    else if (rls_bus_hold_dly & rx_addr_2_flag)
		slv_fsm_state_nxt = RX_ADDR_2;
	    else if (rls_bus_hold_dly & ~rx_addr_2_flag)
		slv_fsm_state_nxt = RX_LOOP;
	    else
		slv_fsm_state_nxt = RX_HOLD;
	end

        WAIT_DATA: begin
	    if (stop_det | set_clklow_tmout | ~smben)
		slv_fsm_state_nxt = IDLE;
	    else if (~txfifo_empty)
		slv_fsm_state_nxt = TX_LOOP;
	    else
		slv_fsm_state_nxt = WAIT_DATA;
	end

	TX_LOOP: begin
	     if (stop_det | set_clklow_tmout | (slv_tx_shift_done & (~ack_det | ~smben)))
		slv_fsm_state_nxt = IDLE;
	     else if (slv_tx_shift_done & ack_det & tx_shifter_last_byte_pec)
		slv_fsm_state_nxt = TX_PEC;
	     else if (slv_tx_shift_done & ack_det & txfifo_empty)
		slv_fsm_state_nxt = WAIT_DATA;
	     else
		slv_fsm_state_nxt = TX_LOOP;
	end	
	
        TX_PEC: begin
	     //if (stop_det | set_clklow_tmout | (slv_tx_shift_done & (~ack_det | ~smben)))
	     if (stop_det | set_clklow_tmout | slv_tx_shift_done) // Transition to idle no matter ack is received or not
		slv_fsm_state_nxt = IDLE;
	     else
		slv_fsm_state_nxt = TX_PEC;
	end	

        default: begin
            slv_fsm_state_nxt = 3'bxxx;
        end

    endcase
end
 

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        slv_tx_en                   <= 1'b0;
        slv_rx_en                   <= 1'b0;
	slvfsm_idle_state	    <= 1'b1;
	slvfsm_rx_addr_state	    <= 1'b0;
	slvfsm_rx_addr_2_state	    <= 1'b0;
	slvfsm_wait_data_state	    <= 1'b0;
	slvfsm_rx_loop_state	    <= 1'b0;
	slvfsm_tx_loop_state	    <= 1'b0;
	slvfsm_rx_hold_state	    <= 1'b0;
	slvfsm_tx_pec_state	    <= 1'b0;
	slv_tx_scl_out              <= 1'b1;
	slv_rx_scl_out              <= 1'b1;

    end
    else begin
	slv_tx_en		    <= slv_tx_en_nxt;
        slv_rx_en		    <= slv_rx_en_nxt;
	slvfsm_idle_state	    <= slvfsm_idle_state_nxt;
	slvfsm_rx_addr_state	    <= slvfsm_rx_addr_state_nxt;
	slvfsm_rx_addr_2_state	    <= slvfsm_rx_addr_2_state_nxt;
	slvfsm_wait_data_state	    <= slvfsm_wait_data_state_nxt;
	slvfsm_rx_loop_state	    <= slvfsm_rx_loop_state_nxt;
	slvfsm_tx_loop_state	    <= slvfsm_tx_loop_state_nxt;
	slvfsm_rx_hold_state	    <= slvfsm_rx_hold_state_nxt;
	slvfsm_tx_pec_state	    <= slvfsm_tx_pec_state_nxt;
	slv_tx_scl_out              <= slv_tx_scl_out_nxt;
	slv_rx_scl_out              <= slv_rx_scl_out_nxt;
    end
end


always @* begin
    slv_tx_en_nxt                = 1'b0;
    slv_rx_en_nxt		 = 1'b0;
    slvfsm_idle_state_nxt	 = 1'b0;
    slvfsm_rx_addr_state_nxt	 = 1'b0;
    slvfsm_rx_addr_2_state_nxt	 = 1'b0;
    slvfsm_wait_data_state_nxt	 = 1'b0;
    slvfsm_rx_loop_state_nxt	 = 1'b0;
    slvfsm_tx_loop_state_nxt	 = 1'b0;
    slvfsm_rx_hold_state_nxt	 = 1'b0;
    slvfsm_tx_pec_state_nxt	 = 1'b0;
    slv_tx_scl_out_nxt           = 1'b1;
    slv_rx_scl_out_nxt           = 1'b1;

    case (slv_fsm_state_nxt)
	IDLE: begin
	    slvfsm_idle_state_nxt = 1'b1;
	end

	RX_ADDR: begin
	    slv_rx_en_nxt	        = 1'b1;
	    slvfsm_rx_addr_state_nxt    = 1'b1;
	end 

	RX_ADDR_2: begin
	    slv_rx_en_nxt	        = 1'b1;
	    slvfsm_rx_addr_2_state_nxt  = 1'b1;
	    slv_rx_scl_out_nxt          = sda_setup_scl_out;
	end

	RX_LOOP: begin
	    slvfsm_rx_loop_state_nxt	= 1'b1;
	    slv_rx_en_nxt	        = 1'b1;
	    slv_rx_scl_out_nxt          = sda_setup_scl_out;
	end

	RX_HOLD: begin
	    slvfsm_rx_hold_state_nxt	= 1'b1;
	    slv_rx_scl_out_nxt          = 1'b0;	// to hold SCL low
	    slv_rx_en_nxt	        = 1'b1;
	end

	WAIT_DATA: begin
	    slvfsm_wait_data_state_nxt	= 1'b1;
	    slv_tx_scl_out_nxt          = 1'b0;	// to hold SCL low
	end

	TX_LOOP: begin
	    slvfsm_tx_loop_state_nxt	= 1'b1;
	    slv_tx_en_nxt	        = 1'b1;
	    slv_tx_scl_out_nxt          = sda_setup_scl_out;
	end	    
	
        TX_PEC: begin
	    slvfsm_tx_pec_state_nxt	= 1'b1;
	    slv_tx_en_nxt	        = 1'b1;
	    slv_tx_scl_out_nxt          = sda_setup_scl_out;
	end	    

        default: begin
	    slv_tx_en_nxt  		 = 1'bx;
	    slv_rx_en_nxt  		 = 1'bx;
	    slvfsm_idle_state_nxt	 = 1'bx;
	    slvfsm_rx_addr_state_nxt	 = 1'bx;
	    slvfsm_rx_addr_2_state_nxt	 = 1'bx;
	    slvfsm_wait_data_state_nxt	 = 1'bx;
	    slvfsm_rx_loop_state_nxt	 = 1'bx;
            slvfsm_tx_loop_state_nxt	 = 1'bx;
            slvfsm_rx_hold_state_nxt	 = 1'bx;
            slvfsm_tx_pec_state_nxt	 = 1'bx;
	    slv_tx_scl_out_nxt           = 1'bx;
	    slv_rx_scl_out_nxt           = 1'bx;
	end

    endcase
end


assign arc_wait_data_tx_loop    = slvfsm_wait_data_state & slvfsm_tx_loop_state_nxt;
assign arc_rx_hold_rx_loop      = slvfsm_rx_hold_state & slvfsm_rx_loop_state_nxt;
assign arc_rx_hold_rx_addr_2    = slvfsm_rx_hold_state & slvfsm_rx_addr_2_state_nxt;
assign arc_rx_addr_wait_data    = slvfsm_rx_addr_state & slvfsm_wait_data_state_nxt;
assign arc_rx_addr_rx_loop      = slvfsm_rx_addr_state & slvfsm_rx_loop_state_nxt;
assign arc_rx_addr_2_wait_data  = slvfsm_rx_addr_2_state & slvfsm_wait_data_state_nxt;
assign arc_rx_addr_2_rx_hold    = slvfsm_rx_addr_2_state & slvfsm_rx_hold_state_nxt;
assign arc_tx_loop_wait_data    = slvfsm_tx_loop_state & slvfsm_wait_data_state_nxt;
assign arc_tx_loop_tx_pec       = slvfsm_tx_loop_state & slvfsm_tx_pec_state_nxt;
assign arc_idle_rx_addr         = slvfsm_idle_state & slvfsm_rx_addr_state_nxt;

assign set_tx_data_req          = arc_rx_addr_wait_data | arc_tx_loop_wait_data | arc_rx_addr_2_wait_data;

//assign set_slv_addr_err         = (SMB_SLV_RCV_HOLD_EN == 1) ? arc_rx_addr_2_rx_hold : (slvfsm_rx_addr_2_state & slv_rx_shift_done & ~rx_addr_match);
assign set_slv_addr_err         = (SMB_SLV_RCV_HOLD_EN == 1) ? arc_rx_addr_2_rx_hold : (slvfsm_rx_addr_2_state & slv_rx_shift_done & ~rx_addr_2_match);

assign set_nack_by_mst          = slvfsm_tx_loop_state & slv_tx_shift_done & ~ack_det & ~tx_shifter_last_byte; 

assign slvfsm_b2b_txshift       = slvfsm_b2b_txshift_ld | arc_tx_loop_tx_pec_flp;

//assign load_tx_shifter          = arc_wait_data_tx_loop_flp | slvfsm_b2b_txshift_ld;
// case:186298
// Root cause: load_tx_shifter should be asserted one clock earlier to avoid txshifter module from driving an old tx_shift_data
assign load_tx_shifter          = arc_wait_data_tx_loop | slvfsm_b2b_txshift_ld_pre_flp;

assign slvfsm_b2b_txshift_ld_pre_flp    = slvfsm_tx_loop_state & slv_tx_shift_done & ack_det & ~txfifo_empty & ~stop_det & ~set_clklow_tmout & ~tx_shifter_last_byte_pec & smben;

assign slvfsm_b2b_rxshift_pre_flp   = (slvfsm_rx_loop_state & slv_rx_shift_done & smben & ~stop_det & ~set_clklow_tmout & ~start_det & ~slv_rx_shift_hold) | 
                                        (slvfsm_rx_addr_state & slvfsm_rx_loop_state_nxt);

assign rx_shifter_rw            = rx_shifter[0];
assign tx_shifter_last_byte     = tx_shifter[8];

assign tx_shifter_last_byte_pec = (SMB_PEC_EN == 1) ? tx_shifter_last_byte : 1'b0;

// Register arc_wait_data_tx_loop to improve timing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        arc_wait_data_tx_loop_flp   <= 1'b0;
        arc_rx_hold_rx_loop_flp     <= 1'b0;
        arc_rx_hold_rx_addr_2_flp   <= 1'b0;
        arc_tx_loop_tx_pec_flp      <= 1'b0;
    end
    else begin
        arc_wait_data_tx_loop_flp   <= arc_wait_data_tx_loop;
        arc_rx_hold_rx_loop_flp     <= arc_rx_hold_rx_loop;
        arc_rx_hold_rx_addr_2_flp   <= arc_rx_hold_rx_addr_2;
        arc_tx_loop_tx_pec_flp      <= arc_tx_loop_tx_pec;
    end
end



// sda_setup counter
assign sda_setup_scl_out  = ((sda_setup_cnt_nxt != 16'h0) | arc_wait_data_tx_loop | arc_rx_hold_rx_loop | arc_rx_hold_rx_addr_2) ? 1'b0 : 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sda_setup_cnt <= 16'h0;
    else
        sda_setup_cnt <= sda_setup_cnt_nxt;
end

always @* begin
    if (arc_wait_data_tx_loop_flp | arc_rx_hold_rx_loop_flp | arc_rx_hold_rx_addr_2_flp)
        sda_setup_cnt_nxt = tsudat;
    else if (sda_setup_cnt != 16'h0)
        sda_setup_cnt_nxt = sda_setup_cnt - 16'h1;
    else
        sda_setup_cnt_nxt = sda_setup_cnt;
end



always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        slvfsm_b2b_txshift_ld <= 1'b0;
        slvfsm_b2b_rxshift <= 1'b0;
    end
    else begin
        slvfsm_b2b_txshift_ld <= slvfsm_b2b_txshift_ld_pre_flp;
        slvfsm_b2b_rxshift <= slvfsm_b2b_rxshift_pre_flp;
    end
end

// Qualifier for RX_CMD_AVAIL interrupt
//always @(posedge clk or negedge rst_n) begin
//    if (!rst_n)
//        rx_cmd_avail_en <= 1'b1;
//    else if (slvfsm_idle_state)
//        rx_cmd_avail_en <= 1'b1;
//    else if (slvfsm_rx_loop_state & slv_rx_shift_done)
//        rx_cmd_avail_en <= 1'b0;
//end

// rx_addr_2_flag indicates whether rx_hold to move to rx_loop/rx_addr_2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        rx_addr_2_flag <= 1'b0;
    else if (slvfsm_idle_state | arc_rx_hold_rx_addr_2)
        rx_addr_2_flag <= 1'b0;
    else if (arc_rx_addr_2_rx_hold)
        rx_addr_2_flag <= 1'b1;
end


// CRC control

assign update_crc       = update_crc_tx | update_crc_rx;
assign crc_data_in      = update_crc_tx ? tx_shifter[7:0] : rx_shifter[7:0];
assign flush_crc        = arc_idle_rx_addr_flp;
assign verify_crc       = slvfsm_rx_loop_state & stop_det & ~dis_verify_crc;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        arc_idle_rx_addr_flp <= 1'b0;
    else
        arc_idle_rx_addr_flp <= arc_idle_rx_addr;
end

// Stop condition interrupt generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        core_sel <= 1'b0;
    else if (arc_rx_addr_rx_loop | arc_rx_addr_wait_data)
        core_sel <= 1'b1;
    else if (stop_det)
        core_sel <= 1'b0;
end

assign set_stop_cond = stop_det & core_sel;

endmodule


