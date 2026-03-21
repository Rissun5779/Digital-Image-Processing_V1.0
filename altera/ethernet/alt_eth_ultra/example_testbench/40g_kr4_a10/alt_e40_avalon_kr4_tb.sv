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




`timescale 1 ps / 1 ps

`include "dynamic_parameters.v"

module alt_e40_avalon_kr4_tb ();

parameter WORDS = 4;//Don't change

localparam NUM_LANES = 4;
localparam NUM_VLANES = 4;


localparam RST_CNTR = 6;		 // 6 for sim
localparam AM_CNT_BITS = 6;		 // 6 for sim
localparam CREATE_TX_SKEW = 1'b0; // debug skew the TX lanes
localparam SYNOPT_FULL_SKEW = 1'b0; // enable support for large lane skews

reg fail = 1'b0;

// no domain
reg arst = 1'b0;

wire clk_din;
wire clk_txmac_1, clk_txmac_2;
wire clk_rxmac_1, clk_rxmac_2;
reg clk_ref = 1'b0;

// status register bus
reg clk_status = 1'b0;
reg [15:0] status_addr = 16'h0;
reg status_read_1 = 1'b0;
reg status_read_2 = 1'b0;
reg status_write_1 = 1'b0;
reg status_write_2 = 1'b0;
reg [31:0] status_writedata = 32'b0;
reg [31:0] request_writedata = 32'b0;
wire [31:0] status_readdata_1;
wire [31:0] status_readdata_2;
wire status_readdata_valid_1;
wire status_readdata_valid_2;
wire status_read_timeout_1;
wire status_read_timeout_2;
wire status_waitrequest_1;
wire status_waitrequest_2;
reg status_waitrequest_1_d;
reg status_waitrequest_2_d;

always @(posedge clk_status) begin
    status_waitrequest_1_d <= status_waitrequest_1;
    status_waitrequest_2_d <= status_waitrequest_2;
end

// input domain (from user toward pins)
wire   [WORDS*64-1:0] l4_tx_data_1;
wire   [4  :0]        l4_tx_empty_1;
wire                  l4_tx_startofpacket_1;
wire                  l4_tx_endofpacket_1;
wire                  l4_tx_ready_1;
reg                   l4_tx_valid_1 = 1'b1;

wire   [WORDS*64-1:0] l4_tx_data_2;
wire   [4  :0]        l4_tx_empty_2;
wire                  l4_tx_startofpacket_2;
wire                  l4_tx_endofpacket_2;
wire                  l4_tx_ready_2;
reg                   l4_tx_valid_2 = 1'b1;

// output domain (from pins toward user)
wire   [WORDS*64-1:0] l4_rx_data_1;
wire   [4  :0]        l4_rx_empty_1;
wire                  l4_rx_startofpacket_1;
wire                  l4_rx_endofpacket_1;
wire                  l4_rx_error_1;
wire                  l4_rx_valid_1;
wire                  l4_rx_fcs_valid_1;
wire                  l4_rx_fcs_error_1;

wire   [WORDS*64-1:0] l4_rx_data_2;
wire   [4  :0]        l4_rx_empty_2;
wire                  l4_rx_startofpacket_2;
wire                  l4_rx_endofpacket_2;
wire                  l4_rx_error_2;
wire                  l4_rx_valid_2;
wire                  l4_rx_fcs_valid_2;
wire                  l4_rx_fcs_error_2;

//serdes
wire [NUM_LANES-1:0] rx_serial_1;
wire [NUM_LANES-1:0] tx_serial_1;

wire [NUM_LANES-1:0] rx_serial_2;
wire [NUM_LANES-1:0] tx_serial_2;

// pause generation
reg         pause_insert_tx_1 = 1'b0;      // generate pause

reg         pause_insert_tx_2 = 1'b0;      // generate pause

/////////////////////////////////
// Memory Map Register R/W Handler
/////////////////////////////////

localparam ST_INIT            = 2'b00;
localparam ST_REGULAR_POLLING = 2'b01;
localparam ST_REFRESH_CNTR    = 2'b10;
localparam ST_WRITE_REQUEST   = 2'b11;

reg [1:0] handler_state = ST_INIT;
reg handler_start = 1'b0;

reg refresh_cntr  = 1'b0;
wire refreshing_cntr = (handler_state == ST_REFRESH_CNTR);

reg write_request_1 = 1'b0;
reg write_request_2 = 1'b0;
wire handling_write_request = (handler_state == ST_WRITE_REQUEST);

// regular polling registers
wire [10*12-1:0] rp_addr_lst = {
					12'hd2,     // LT status
					12'hc2,     // AN status
					12'hb1,     // KR statuss
					12'h837,    //CNTR_TX_ST_HI
					12'h836,    //CNTR_TX_ST_LO
					12'h326,	//fully aligned
					12'h323,	//frame err
					12'h322,	//core plls locked
					12'h321,	//rx pll locked
					12'h320		//tx pll locked
					};
reg [10*32-1:0] rp_data_lst_1 = 0;
reg [10*32-1:0] rp_data_lst_2 = 0;
int rp_index = 0;

wire [NUM_LANES-1:0] lt_failure_1;
wire [NUM_LANES-1:0] lt_start_up_1;
wire [NUM_LANES-1:0] lt_frame_lock_1;
wire [NUM_LANES-1:0] lt_trained_1;

assign lt_failure_1[3]                = rp_data_lst_1[ 9*32 + 27];
assign lt_start_up_1[3]               = rp_data_lst_1[ 9*32 + 26];
assign lt_frame_lock_1[3]             = rp_data_lst_1[ 9*32 + 25];
assign lt_trained_1[3]                = rp_data_lst_1[ 9*32 + 24];

assign lt_failure_1[2]                = rp_data_lst_1[ 9*32 + 19];
assign lt_start_up_1[2]               = rp_data_lst_1[ 9*32 + 18];
assign lt_frame_lock_1[2]             = rp_data_lst_1[ 9*32 + 17];
assign lt_trained_1[2]                = rp_data_lst_1[ 9*32 + 16];

assign lt_failure_1[1]                = rp_data_lst_1[ 9*32 + 11];
assign lt_start_up_1[1]               = rp_data_lst_1[ 9*32 + 10];
assign lt_frame_lock_1[1]             = rp_data_lst_1[ 9*32 + 9];
assign lt_trained_1[1]                = rp_data_lst_1[ 9*32 + 8];

assign lt_failure_1[0]                = rp_data_lst_1[ 9*32 + 3];
assign lt_start_up_1[0]               = rp_data_lst_1[ 9*32 + 2];
assign lt_frame_lock_1[0]             = rp_data_lst_1[ 9*32 + 1];
assign lt_trained_1[0]                = rp_data_lst_1[ 9*32 + 0];
wire [5:0] an_link_mode_1             = rp_data_lst_1[ 8*32 + 12 +:6];
wire an_failure_1                     = rp_data_lst_1[ 8*32 + 9];
wire an_fec_neg_1                     = rp_data_lst_1[ 8*32 + 8];
wire an_lp_able_1                     = rp_data_lst_1[ 8*32 + 7];
wire an_link_up_1                     = rp_data_lst_1[ 8*32 + 6];
wire an_able_1                        = rp_data_lst_1[ 8*32 + 5];
wire an_rx_idle_1                     = rp_data_lst_1[ 8*32 + 4];
wire an_adv_rf_1                      = rp_data_lst_1[ 8*32 + 3];
wire an_complete_1                    = rp_data_lst_1[ 8*32 + 2];
wire an_page_recv_1                   = rp_data_lst_1[ 8*32 + 1];
wire kr_fec_err_ind_abl_1             = rp_data_lst_1[ 7*32 + 17];
wire kr_fec_abl_1                     = rp_data_lst_1[ 7*32 + 16];
wire [5:0] kr_reco_mode_1             = rp_data_lst_1[ 7*32 + 8 +:6];
wire kr_an_timeout_1                  = rp_data_lst_1[ 7*32 + 1];
wire kr_link_ready_1                  = rp_data_lst_1[ 7*32 + 0];
wire [63:0] tx_start_cnt_rp_1         = rp_data_lst_1[ 5*32 +:64];   // number of frame starts sent
wire lanes_deskewed_1                 = rp_data_lst_1[ 4*32 + 0 ];   // lane to lane skew corrected
wire hi_ber_1                         = rp_data_lst_1[ 4*32 + 1 ];
wire [NUM_VLANES-1:0] framing_error_1 = rp_data_lst_1[ 3*32 +: NUM_VLANES]; 
wire rx_fpll_lock_1                   = rp_data_lst_1[ 2*32 + 2 ];
wire tx_fpll_lock_1                   = rp_data_lst_1[ 2*32 + 1 ];
wire pma_tx_ready_1                   = rp_data_lst_1[ 2*32 + 0 ];
wire [NUM_VLANES-1:0] rx_cdr_lock_1   = rp_data_lst_1[ 1*32 +: NUM_VLANES];  
wire [NUM_VLANES-1:0] tx_pll_lock_1   = rp_data_lst_1[ 0*32 +: NUM_VLANES];  

wire [NUM_LANES-1:0] lt_failure_2;
wire [NUM_LANES-1:0] lt_start_up_2;
wire [NUM_LANES-1:0] lt_frame_lock_2;
wire [NUM_LANES-1:0] lt_trained_2;

assign lt_failure_2[3]                = rp_data_lst_2[ 9*32 + 27];
assign lt_start_up_2[3]               = rp_data_lst_2[ 9*32 + 26];
assign lt_frame_lock_2[3]             = rp_data_lst_2[ 9*32 + 25];
assign lt_trained_2[3]                = rp_data_lst_2[ 9*32 + 24];

assign lt_failure_2[2]                = rp_data_lst_2[ 9*32 + 19];
assign lt_start_up_2[2]               = rp_data_lst_2[ 9*32 + 18];
assign lt_frame_lock_2[2]             = rp_data_lst_2[ 9*32 + 17];
assign lt_trained_2[2]                = rp_data_lst_2[ 9*32 + 16];

assign lt_failure_2[1]                = rp_data_lst_2[ 9*32 + 11];
assign lt_start_up_2[1]               = rp_data_lst_2[ 9*32 + 10];
assign lt_frame_lock_2[1]             = rp_data_lst_2[ 9*32 + 9];
assign lt_trained_2[1]                = rp_data_lst_2[ 9*32 + 8];

assign lt_failure_2[0]                = rp_data_lst_2[ 9*32 + 3];
assign lt_start_up_2[0]               = rp_data_lst_2[ 9*32 + 2];
assign lt_frame_lock_2[0]             = rp_data_lst_2[ 9*32 + 1];
assign lt_trained_2[0]                = rp_data_lst_2[ 9*32 + 0];
wire [5:0] an_link_mode_2             = rp_data_lst_2[ 8*32 + 12 +:6];
wire an_failure_2                     = rp_data_lst_2[ 8*32 + 9];
wire an_fec_neg_2                     = rp_data_lst_2[ 8*32 + 8];
wire an_lp_able_2                     = rp_data_lst_2[ 8*32 + 7];
wire an_link_up_2                     = rp_data_lst_2[ 8*32 + 6];
wire an_able_2                        = rp_data_lst_2[ 8*32 + 5];
wire an_rx_idle_2                     = rp_data_lst_2[ 8*32 + 4];
wire an_adv_rf_2                      = rp_data_lst_2[ 8*32 + 3];
wire an_complete_2                    = rp_data_lst_2[ 8*32 + 2];
wire an_page_recv_2                   = rp_data_lst_2[ 8*32 + 1];
wire kr_fec_err_ind_abl_2             = rp_data_lst_2[ 7*32 + 17];
wire kr_fec_abl_2                     = rp_data_lst_2[ 7*32 + 16];
wire [5:0] kr_reco_mode_2             = rp_data_lst_2[ 7*32 + 8 +:6];
wire kr_an_timeout_2                  = rp_data_lst_2[ 7*32 + 1];
wire kr_link_ready_2                  = rp_data_lst_2[ 7*32 + 0];
wire [63:0] tx_start_cnt_rp_2         = rp_data_lst_2[ 5*32 +:64];   // number of frame starts sent
wire lanes_deskewed_2                 = rp_data_lst_2[ 4*32 + 0 ];   // lane to lane skew corrected
wire hi_ber_2                         = rp_data_lst_2[ 4*32 + 1 ];
wire [NUM_VLANES-1:0] framing_error_2 = rp_data_lst_2[ 3*32 +: NUM_VLANES]; 
wire rx_fpll_lock_2                   = rp_data_lst_2[ 2*32 + 2 ];
wire tx_fpll_lock_2                   = rp_data_lst_2[ 2*32 + 1 ];
wire pma_tx_ready_2                   = rp_data_lst_2[ 2*32 + 0 ];
wire [NUM_VLANES-1:0] rx_cdr_lock_2   = rp_data_lst_2[ 1*32 +: NUM_VLANES];  
wire [NUM_VLANES-1:0] tx_pll_lock_2   = rp_data_lst_2[ 0*32 +: NUM_VLANES];  


// refreshing counters
wire [6*12-1:0] rc_addr_lst = {
					12'h906,	//CNTR_RX_FCS
					12'h934,	//CNTR_RX_RUNT
					12'h937,	//CNTR_RX_ST_HI
					12'h936,	//CNTR_RX_ST_LO
					12'h837,    //CNTR_TX_ST_HI
					12'h836     //CNTR_TX_ST_LO
					};
reg [6*32-1:0] rc_data_lst_1 = 0;
reg [6*32-1:0] rc_data_lst_2 = 0;
int rc_index = 0;

wire [31:0] fcs_error_cnt_1    = rc_data_lst_1[ 6*32 -1 -:32];   // CRC 32 errors
wire [31:0] runt_cnt_1         = rc_data_lst_1[ 5*32 -1 -:32];   // packets < 64 byte long
wire [63:0] rx_start_cnt_1     = rc_data_lst_1[ 4*32 -1 -:64];   // number of fram starts received
wire [63:0] tx_start_cnt_1     = rc_data_lst_1[ 2*32 -1 -:64];   // number of frame starts sent

wire [31:0] fcs_error_cnt_2    = rc_data_lst_2[ 6*32 -1 -:32];   // CRC 32 errors
wire [31:0] runt_cnt_2         = rc_data_lst_2[ 5*32 -1 -:32];   // packets < 64 byte long
wire [63:0] rx_start_cnt_2     = rc_data_lst_2[ 4*32 -1 -:64];   // number of fram starts received
wire [63:0] tx_start_cnt_2     = rc_data_lst_2[ 2*32 -1 -:64];   // number of frame starts sent

reg [15:0] wr_addr = 16'h0;
reg print_cntr_value = 1'b0;
reg clr_history = 1'b0;
reg done_1, done_2;

// handler FSM
always @ (negedge clk_status) begin
print_cntr_value <= 1'b0;
case (handler_state)
	ST_INIT:
	if (handler_start)
		begin
			status_addr <= {4'h0, rp_addr_lst[rp_index*12+11 -: 12]};
			status_read_1 <= 1'b1;
			status_read_2 <= 1'b1;
			done_1 <= 1'b0;
			done_2 <= 1'b0;
			handler_state <= ST_REGULAR_POLLING;
		end
	ST_REGULAR_POLLING:
	begin
		if ( status_readdata_valid_1 ) begin
			// $display ("status_addr: %h, status_readdata_1; %h", status_addr, status_readdata_1);
			rp_data_lst_1 [rp_index*32+31 -: 32] <= status_readdata_1;
			done_1 <= 1'b1;
		end else if (status_read_timeout_1) begin
            done_1 <= 1'b1;
		end else begin
			status_read_1 <= 1'b0;
		end
		
		if ( status_readdata_valid_2 ) begin
			// $display ("status_addr: %h, status_readdata_2; %h", status_addr, status_readdata_2);
			rp_data_lst_2 [rp_index*32+31 -: 32] <= status_readdata_2;
			done_2 <= 1'b1;
		end else if (status_read_timeout_2) begin
            done_2 <= 1'b1;
		end else begin
			status_read_2 <= 1'b0;
		end
        	
		status_write_1 <= 1'b0;
		status_write_2 <= 1'b0;
		
		if(done_1 && done_2 && !status_read_timeout_1 && !status_read_timeout_2
           && !status_waitrequest_1 && !status_waitrequest_2
           && !status_waitrequest_1_d && !status_waitrequest_2_d) begin
			done_1 <= 1'b0;
			done_2 <= 1'b0;
			rp_index = (rp_index == 9) ? 0 : (rp_index + 1);
			if (write_request_1) begin
				handler_state <= ST_WRITE_REQUEST;
				status_write_1  <= 1'b1;
				status_writedata <= request_writedata;
				status_addr   <= wr_addr;
			end
			else if (write_request_2) begin
				handler_state <= ST_WRITE_REQUEST;
				status_write_2  <= 1'b1;
				status_writedata <= request_writedata;
				status_addr   <= wr_addr;
			end
			else if (refresh_cntr) begin
				handler_state <= ST_REFRESH_CNTR;
				status_read_1   <= 1'b1;
				status_read_2   <= 1'b1;
				status_addr   <= {4'h0, rc_addr_lst[rc_index*12+11 -: 12]};
			end
			else begin
				status_read_1   <= 1'b1;
				status_read_2   <= 1'b1;
				status_addr   <= {4'h0, rp_addr_lst[rp_index*12+11 -: 12]};
			end
		end

		
	end
	ST_REFRESH_CNTR:
	begin
		if ( status_readdata_valid_1 ==1 ) begin
			rc_data_lst_1 [rc_index*32+31 -: 32] <= status_readdata_1;
			done_1 <= 1'b1;
		end else if (status_read_timeout_1) begin
            done_1 <= 1'b1;
		end else begin
			status_read_1 <= 1'b0;
		end
		
		if ( status_readdata_valid_2 ==1 ) begin
			rc_data_lst_2 [rc_index*32+31 -: 32] <= status_readdata_2;
			done_2 <= 1'b1;
		end else if (status_read_timeout_2) begin
            done_2 <= 1'b1;
		end else begin
			status_read_2 <= 1'b0;
		end
		
		status_write_1 <= 1'b0;
		status_write_2 <= 1'b0;
		
		if(done_1 && done_2 && !status_read_timeout_1 && !status_read_timeout_2
           && !status_waitrequest_1 && !status_waitrequest_2) begin
			done_1 <= 1'b0;
			done_2 <= 1'b0;
			if (rc_index == 5) begin
				print_cntr_value <= 1'b1;
				if (write_request_1) begin
					handler_state <= ST_WRITE_REQUEST;
					status_write_1  <= 1'b1;
					status_writedata <= request_writedata;
					status_addr   <= wr_addr;
				end
				else if (write_request_2) begin
					handler_state <= ST_WRITE_REQUEST;
					status_write_2  <= 1'b1;
					status_writedata <= request_writedata;
					status_addr   <= wr_addr;
				end
				else if (refresh_cntr) begin
					status_read_1   <= 1'b1;
					status_read_2   <= 1'b1;
					status_addr   <= {4'h0, rc_addr_lst[ 11: 0]};
				end
				else begin
					handler_state <= ST_REGULAR_POLLING;
					status_read_1   <= 1'b1;
					status_read_2   <= 1'b1;
					status_addr   <= {4'h0, rp_addr_lst[rp_index*12+11 -: 12]};
				end
				rc_index = 0;
			end
			else begin
				rc_index 	   = rc_index + 1;
				status_read_1   <= 1'b1;
				status_read_2   <= 1'b1;
				status_addr   <= {4'h0, rc_addr_lst[rc_index*12+11 -: 12]};
			end
		end

	end
	ST_WRITE_REQUEST:
	begin
		if (clr_history) begin // clr_history will always assert if the handler it's writing 1 to statistics cntr clear
			rp_data_lst_1 [127 :64] <= 0;	// clear framing_err and bip_err in rp_data_lst_1
			rp_data_lst_2 [127 :64] <= 0;	// clear framing_err and bip_err in rp_data_lst_2
		end
		status_write_1  <= 1'b0;
		status_write_2  <= 1'b0;
		if (write_request_1 && !status_waitrequest_1) begin
			handler_state <= ST_WRITE_REQUEST;
			status_write_1  <= 1'b1;
			status_writedata <= request_writedata;
			status_addr   <= wr_addr;
		end
		else if (write_request_2 && !status_waitrequest_2) begin
			handler_state <= ST_WRITE_REQUEST;
			status_write_2  <= 1'b1;
			status_writedata <= request_writedata;
			status_addr   <= wr_addr;
		end
		else if (refresh_cntr) begin
			handler_state <= ST_REFRESH_CNTR;
			status_read_1   <= 1'b0;
			status_read_2   <= 1'b0;
			done_1 <= 1'b1;
			done_2 <= 1'b1;
			status_addr   <= {4'h0, rc_addr_lst[rc_index*12+11 -: 12]};
		end
		else begin
			handler_state <= ST_REGULAR_POLLING;
			status_read_1   <= 1'b0;
			status_read_2   <= 1'b0;
			done_1 <= 1'b1;
			done_2 <= 1'b1;
			status_addr   <= {4'h0, rp_addr_lst[rp_index*12+11 -: 12]};
		end
	end
endcase
end

// display cntr
always @ (posedge clk_status)
if (print_cntr_value) begin
	$display ("Counters Refreshed, dut 1:");
	$display ("\t fcs_error_cnt_1: %d", fcs_error_cnt_1);
	$display ("\t runt_cnt_1: %d", runt_cnt_1);
	$display ("\t rx_start_cnt_1: %d", rx_start_cnt_1);
	$display ("\t tx_start_cnt_1: %d", tx_start_cnt_1);
	$display ("Counters Refreshed, dut 2:");
	$display ("\t fcs_error_cnt_2: %d", fcs_error_cnt_2);
	$display ("\t runt_cnt_2: %d", runt_cnt_2);
	$display ("\t rx_start_cnt_2: %d", rx_start_cnt_2);
	$display ("\t tx_start_cnt_2: %d", tx_start_cnt_2);
end

//Simulation Monitor
reg [8:0] monitor=0;
reg reset_monitor_cnt = 0;  // assert when wiping stats. Display the monitor values 0x30 cycles after stats_clr is written to csr.

always @ (posedge clk_status) begin
	if (reset_monitor_cnt)
		monitor <= 9'h1cf;
	else
		monitor <= monitor + 1;
	
	if (clr_history) begin

	end
	
	if (&monitor) begin
		$display ("\t+------------------------------------------------------------");
		$display ("\t| Simulation Monitor at time %d (dut 1):", $time);
		$display ("\t|\t lanes_deskewed_1: %h", lanes_deskewed_1);
		$display ("\t|\t framing_error_1:%h", framing_error_1[NUM_VLANES-1:0]);
		$display ("\t|\t pma_tx_ready_1:%b", pma_tx_ready_1);
		$display ("\t|\t kr_link_ready_1: %b \tkr_an_timeout_1:%b  kr_reco_mode_1:%h", kr_link_ready_1, kr_an_timeout_1, kr_reco_mode_1);
		$display ("\t|\t an_complete_1: %b \tan_rx_idle_1:%b  an_link_up_1:%b", an_complete_1, an_rx_idle_1, an_link_up_1);
		$display ("\t|\t an_fec_neg_1: %b \tan_failure_1:%b  an_link_mode_1:%h", an_fec_neg_1, an_failure_1, an_link_mode_1);
		$display ("\t|\t lt_trained_1: %h \tlt_frame_lock_1: %h \tlt_failure_1:%h", lt_trained_1, lt_frame_lock_1, lt_failure_1);
		$display ("\t|\t Number of packets sent: %d", tx_start_cnt_rp_1[63:0] );
		$display ("\t+------------------------------------------------------------");
		$display ("\t| Simulation Monitor at time %d (dut 2):", $time);
		$display ("\t|\t lanes_deskewed_2: %h", lanes_deskewed_2);
		$display ("\t|\t framing_error_2:%h", framing_error_2[NUM_VLANES-1:0]);
		$display ("\t|\t pma_tx_ready_2:%b", pma_tx_ready_2);
		$display ("\t|\t kr_link_ready_2: %b \tkr_an_timeout_2:%b  kr_reco_mode_2:%h", kr_link_ready_2, kr_an_timeout_2, kr_reco_mode_2);
		$display ("\t|\t an_complete_2: %b \tan_rx_idle_2:%b  an_link_up_2:%b", an_complete_2, an_rx_idle_2, an_link_up_2);
		$display ("\t|\t an_fec_neg_2: %b \tan_failure_2:%b  an_link_mode_2:%h", an_fec_neg_2, an_failure_2, an_link_mode_2);
		$display ("\t|\t lt_trained_2: %h \tlt_frame_lock_2: %h \tlt_failure_2:%h", lt_trained_2, lt_frame_lock_2, lt_failure_2);
		$display ("\t|\t Number of packets sent: %d", tx_start_cnt_rp_2[63:0] );
		$display ("\t+------------------------------------------------------------");
		
	end
end

assign rx_serial_1 = tx_serial_2;
assign rx_serial_2 = tx_serial_1;


/////////////////////////////////
// monitor lane locking
/////////////////////////////////

genvar i;

always @(posedge pma_tx_ready_1) begin
	$display ("DUT 1 TX interface is ready at time %d",$time);
end
always @(posedge pma_tx_ready_2) begin
	$display ("DUT 2 TX interface is ready at time %d",$time);
end

always @(posedge (lanes_deskewed_1 === 1'b1)) begin
	$display ("DUT 1 Lanes deskewed at time %d",$time);
end
always @(posedge (lanes_deskewed_2 === 1'b1)) begin
	$display ("DUT 2 Lanes deskewed at time %d",$time);
end

always @(posedge an_complete_1) begin
    $display ("DUT 1 AN complete at time %d",$time);
end
always @(posedge an_complete_2) begin
    $display ("DUT 2 AN complete at time %d",$time);
end

generate 
	for (i=0; i<NUM_LANES; i=i+1) begin : monlt
		always @(posedge lt_frame_lock_1[i]) begin
			$display ("DUT 1 Lane %d LT frame lock at time %d",i,$time);
		end
		always @(posedge lt_frame_lock_2[i]) begin
			$display ("DUT 2 Lane %d LT frame lock at time %d",i,$time);
		end

		always @(posedge lt_trained_1[i]) begin
			$display ("DUT 1 Lane %d LT done at time %d",i,$time);
		end		
		always @(posedge lt_trained_2[i]) begin
			$display ("DUT 2 Lane %d LT done at time %d",i,$time);
		end
		
		always @(posedge lt_failure_1[i]) begin
			$display ("DUT 1 Lane %d LT failure (timeout) at time %d",i,$time);
		end		
		always @(posedge lt_failure_2[i]) begin
			$display ("DUT 2 Lane %d LT failure (timeout) at time %d",i,$time);
		end
	end
endgenerate

///////////////////////////////////
// generate some simple data to send
///////////////////////////////////

reg packet_gen_idle_1 = 1'b1;

wire [WORDS*64-1:0] din_1, din_tr_1,din_ps_1;	// regular left to right
wire [WORDS-1:0] din_start_1, din_start_tr_1,din_start_ps_1;  // first of any 8 bytes
wire [WORDS*8-1:0] din_end_pos_1, din_end_pos_tr_1,din_end_pos_ps_1; // any byte

alt_e40_avalon_tb_packet_gen ps_1 (
	.clk(clk_txmac_1),
	.ena(din_ack_1),
	.idle(packet_gen_idle_1),
		
	.sop(din_start_ps_1),
	.eop(din_end_pos_ps_1),
	.dout(din_ps_1),
	.sernum()
);
defparam ps_1 .WORDS = WORDS;

assign din_start_1 = din_start_ps_1;
assign din_end_pos_1 = din_end_pos_ps_1;
assign din_1 = din_ps_1;

reg packet_gen_idle_2 = 1'b1;

wire [WORDS*64-1:0] din_2, din_tr_2,din_ps_2;	// regular left to right
wire [WORDS-1:0] din_start_2, din_start_tr_2,din_start_ps_2;  // first of any 8 bytes
wire [WORDS*8-1:0] din_end_pos_2, din_end_pos_tr_2,din_end_pos_ps_2; // any byte

alt_e40_avalon_tb_packet_gen ps_2 (
	.clk(clk_txmac_2),
	.ena(din_ack_2),
	.idle(packet_gen_idle_2),
		
	.sop(din_start_ps_2),
	.eop(din_end_pos_ps_2),
	.dout(din_ps_2),
	.sernum()
);
defparam ps_2 .WORDS = WORDS;

assign din_start_2 = din_start_ps_2;
assign din_end_pos_2 = din_end_pos_ps_2;
assign din_2 = din_ps_2;

// monitor the input traffic
reg [WORDS*64-1:0] tmp_din_1 = 0;
reg [WORDS*64-1:0] tmp_din_2 = 0;
reg pending_1 = 1'b0;
reg pending_2 = 1'b0;
reg [WORDS*8-1:0] tmp_eop_1 = 0;
reg [WORDS*8-1:0] tmp_eop_2 = 0;
integer r;

always @(posedge clk_din) begin
	if (din_ack_1) begin
		tmp_din_1 = din_1;
		tmp_eop_1 = din_end_pos_1;

		for (r=0; r<WORDS; r=r+1) begin
			if (!pending_1) begin
				if (|tmp_eop_1[WORDS*8-1:(WORDS-1)*8]) begin
					$display ("DUT1: Sending an EOP not during pending packet");
					fail = 1'b1;
				end
				if (din_start_1[WORDS-1-r]) begin
					pending_1 = 1'b1;
				end
			end
			else begin
				// pending_1
				if (din_start_1[WORDS-1-r]) begin
					$display ("DUT1: Sending an SOP during pending packet");
					fail = 1'b1;
				end	
				if (|tmp_eop_1[WORDS*8-1:(WORDS-1)*8]) begin
					pending_1 = 1'b0;
				end
			end
			tmp_din_1 = tmp_din_1 << 8*8;
			tmp_eop_1 = tmp_eop_1 << 8;
		end
	end
	if (din_ack_2) begin
		tmp_din_2 = din_2;
		tmp_eop_2 = din_end_pos_2;

		for (r=0; r<WORDS; r=r+1) begin
			if (!pending_2) begin
				if (|tmp_eop_2[WORDS*8-1:(WORDS-1)*8]) begin
					$display ("DUT2: Sending an EOP not during pending packet");
					fail = 1'b1;
				end
				if (din_start_2[WORDS-1-r]) begin
					pending_2 = 1'b1;
				end
			end
			else begin
				// pending_2
				if (din_start_2[WORDS-1-r]) begin
					$display ("DUT2: Sending an SOP during pending packet");
					fail = 1'b1;
				end	
				if (|tmp_eop_2[WORDS*8-1:(WORDS-1)*8]) begin
					pending_2 = 1'b0;
				end
			end
			tmp_din_2 = tmp_din_2 << 8*8;
			tmp_eop_2 = tmp_eop_2 << 8;
		end
	end
end

///////////////////////////////////
// simple RX packet sanity check
///////////////////////////////////

reg clr_sanity = 1'b1;
wire [31:0] bad_term_cnt_1, bad_serial_cnt_1, bad_dest_cnt_1;
reg  [8*WORDS-1 :0] sanity_eop_1 = 0;

always @(*) begin
	for (r=0; r<8*WORDS; r=r+1) begin
		if (r==l4_rx_empty_1 && l4_rx_endofpacket_1)
			sanity_eop_1[r] = 1'b1;
		else
			sanity_eop_1[r] = 1'b0;
	end
end

alt_e40_avalon_tb_packet_gen_sanity_check psc_1 (
	.clk(clk_rxmac_1),
	.clr_cntrs(clr_sanity),
	.sop({l4_rx_startofpacket_1,3'b0}),
	.eop(sanity_eop_1),
	.din(l4_rx_data_1),
	.din_valid(l4_rx_valid_1),
	
	.bad_term_cnt(bad_term_cnt_1),
	.bad_serial_cnt(bad_serial_cnt_1),
	.bad_dest_cnt(bad_dest_cnt_1),
	
	.sernum()
);
defparam psc_1 .WORDS = WORDS;

wire [31:0] bad_term_cnt_2, bad_serial_cnt_2, bad_dest_cnt_2;
reg  [8*WORDS-1 :0] sanity_eop_2 = 0;

always @(*) begin
	for (r=0; r<8*WORDS; r=r+1) begin
		if (r==l4_rx_empty_2 && l4_rx_endofpacket_2)
			sanity_eop_2[r] = 1'b1;
		else
			sanity_eop_2[r] = 1'b0;
	end
end

alt_e40_avalon_tb_packet_gen_sanity_check psc_2 (
	.clk(clk_rxmac_2),
	.clr_cntrs(clr_sanity),
	.sop({l4_rx_startofpacket_2,3'b0}),
	.eop(sanity_eop_2),
	.din(l4_rx_data_2),
	.din_valid(l4_rx_valid_2),
	
	.bad_term_cnt(bad_term_cnt_2),
	.bad_serial_cnt(bad_serial_cnt_2),
	.bad_dest_cnt(bad_dest_cnt_2),
	
	.sernum()
);
defparam psc_2 .WORDS = WORDS;

function [4:0] one_hot_to_binary;
input [WORDS*8-1:0] one_hot;
integer i;
begin
	if (|one_hot) begin
		for (i=0; i<WORDS*8; i=i+1) if (one_hot[i]) one_hot_to_binary = i;
	end else
		one_hot_to_binary = 5'b0;
	end
endfunction

   reg [3:0] tx_serial_clk = 0;
   
   always begin
	tx_serial_clk <= {4{~tx_serial_clk[0]}};
	#97;
   end

//////////////////////////////////////////
// DUTS
//////////////////////////////////////////
assign l4_tx_startofpacket_1 = |din_start_1;
assign l4_tx_empty_1 = one_hot_to_binary(din_end_pos_1);
assign l4_tx_endofpacket_1 = |din_end_pos_1;
assign l4_tx_data_1 = din_1;
assign din_ack_1 = l4_tx_ready_1;

ex_40g dut_1 (
    .reset_async		(arst),
    .reset_status		(arst),

    .clk_txmac(clk_txmac_1),    // MAC + PCS clock - at least 312.5Mhz
    .clk_rxmac(clk_rxmac_1),    // MAC + PCS clock - at least 312.5Mhz
    .clk_ref(clk_ref),      // GX PLL reference
    
    // status register bus
    .clk_status(clk_status),
    .status_addr(status_addr),
    .status_read(status_read_1),
    .status_write(status_write_1),
    .status_writedata(status_writedata),
    .status_readdata(status_readdata_1),
    .status_read_timeout(status_read_timeout_1),
    .status_readdata_valid(status_readdata_valid_1),
    .status_waitrequest(status_waitrequest_1),
    
    .l4_tx_data(l4_tx_data_1),
    .l4_tx_empty(l4_tx_empty_1),
    .l4_tx_startofpacket(l4_tx_startofpacket_1),
    .l4_tx_endofpacket(l4_tx_endofpacket_1),
    .l4_tx_ready(l4_tx_ready_1),
    .l4_tx_valid(l4_tx_valid_1),
    .l4_tx_error(1'b0),
    .l4_rx_data(l4_rx_data_1),
    .l4_rx_empty(l4_rx_empty_1),
    .l4_rx_startofpacket(l4_rx_startofpacket_1),
    .l4_rx_endofpacket(l4_rx_endofpacket_1),
    .l4_rx_error(l4_rx_error_1),
    .l4_rx_valid(l4_rx_valid_1),
    .l4_rx_fcs_valid(l4_rx_fcs_valid_1),
    .l4_rx_fcs_error(l4_rx_fcs_error_1),

    .tx_serial(tx_serial_1),
    .rx_serial(rx_serial_1),

       	`ifdef SYNOPT_PAUSE
	   .pause_insert_tx		(pause_insert_tx_1),
	   .pause_receive_rx             (),
		`endif
	
		.reconfig_clk(clk_status),
		.reconfig_reset(arst),
		.reconfig_write(1'b0),
		.reconfig_read(1'b0),
		.reconfig_address(14'b0),
		.reconfig_writedata(32'b0),
	    .tx_serial_clk(tx_serial_clk),
	    .tx_pll_locked(1'b1)
);

   //These parameters are simulation settings:
   defparam dut_1.ex_40g_inst.AM_CNT_BITS 			 = AM_CNT_BITS;
   defparam dut_1.ex_40g_inst.RST_CNTR 			 = RST_CNTR;
   defparam dut_1.ex_40g_inst.CREATE_TX_SKEW 	      = CREATE_TX_SKEW;
   defparam dut_1.ex_40g_inst.SYNOPT_FULL_SKEW 	      = SYNOPT_FULL_SKEW;

assign l4_tx_startofpacket_2 = |din_start_2;
assign l4_tx_empty_2 = one_hot_to_binary(din_end_pos_2);
assign l4_tx_endofpacket_2 = |din_end_pos_2;
assign l4_tx_data_2 = din_2;
assign din_ack_2 = l4_tx_ready_2;

ex_40g dut_2 (
    .reset_async		(arst),
    .reset_status		(arst),

    .clk_txmac(clk_txmac_2),    // MAC + PCS clock - at least 312.5Mhz
    .clk_rxmac(clk_rxmac_2),    // MAC + PCS clock - at least 312.5Mhz
    .clk_ref(~clk_ref),      // GX PLL reference
    
    // status register bus
    .clk_status(clk_status),
    .status_addr(status_addr),
    .status_read(status_read_2),
    .status_write(status_write_2),
    .status_writedata(status_writedata),
    .status_readdata(status_readdata_2),
    .status_read_timeout(status_read_timeout_2),
    .status_readdata_valid(status_readdata_valid_2),
    .status_waitrequest(status_waitrequest_2),
    
    .l4_tx_data(l4_tx_data_2),
    .l4_tx_empty(l4_tx_empty_2),
    .l4_tx_startofpacket(l4_tx_startofpacket_2),
    .l4_tx_endofpacket(l4_tx_endofpacket_2),
    .l4_tx_ready(l4_tx_ready_2),
    .l4_tx_valid(l4_tx_valid_2),
    .l4_tx_error(1'b0),
    .l4_rx_data(l4_rx_data_2),
    .l4_rx_empty(l4_rx_empty_2),
    .l4_rx_startofpacket(l4_rx_startofpacket_2),
    .l4_rx_endofpacket(l4_rx_endofpacket_2),
    .l4_rx_error(l4_rx_error_2),
    .l4_rx_valid(l4_rx_valid_2),
    .l4_rx_fcs_valid(l4_rx_fcs_valid_2),
    .l4_rx_fcs_error(l4_rx_fcs_error_2),

    .tx_serial(tx_serial_2),
    .rx_serial(rx_serial_2),

       	`ifdef SYNOPT_PAUSE
	   .pause_insert_tx		(pause_insert_tx_2),
	   .pause_receive_rx             (),
		`endif
	
		.reconfig_clk(clk_status),
		.reconfig_reset(arst),
		.reconfig_write(1'b0),
		.reconfig_read(1'b0),
		.reconfig_address(14'b0),
		.reconfig_writedata(32'b0),
	    .tx_serial_clk(tx_serial_clk),
	    .tx_pll_locked(1'b1)
);

   //These parameters are simulation settings:
   defparam dut_2.ex_40g_inst.AM_CNT_BITS 			 = AM_CNT_BITS;
   defparam dut_2.ex_40g_inst.RST_CNTR 			 = RST_CNTR;
   defparam dut_2.ex_40g_inst.CREATE_TX_SKEW 	      = CREATE_TX_SKEW;
   defparam dut_2.ex_40g_inst.SYNOPT_FULL_SKEW 	      = SYNOPT_FULL_SKEW;
/////////////////////////////////
// watchdogs
/////////////////////////////////

// write initial values to registers
int skip_cnt=0;

initial begin
	#1500000000 if (!lanes_deskewed_1) begin
		$display ("DUT 1 Failed to align and deskew in a reasonable time");
		fail = 1'b1;
		$stop();
	end
end
initial begin
	#1500000000 if (!lanes_deskewed_2) begin
		$display ("DUT 2 Failed to align and deskew in a reasonable time");
		fail = 1'b1;
		$stop();
	end
end

reg expecting_loss_of_lock_1 = 0;
initial begin
	#100
	@(negedge lanes_deskewed_1) begin
		if (expecting_loss_of_lock_1 == 1) begin
			$display ("\t+-----------------------------------------------");
			$display ("\t|  DUT 1 Expected loss of lock");
			$display ("\t+-----------------------------------------------");
		end else begin
			$display ("\t+-----------------------------------------------");
			$display ("\t|  DUT 1 Unexpected loss of lock");
			$display ("\t+-----------------------------------------------");
			//fail = 1'b1;
			//$stop();
		end
	end
end
reg expecting_loss_of_lock_2 = 0;
initial begin
	#100
	@(negedge lanes_deskewed_2) begin
		if (expecting_loss_of_lock_2 == 1) begin
			$display ("\t+-----------------------------------------------");
			$display ("\t|  DUT 2 Expected loss of lock");
			$display ("\t+-----------------------------------------------");
		end else begin
			$display ("\t+-----------------------------------------------");
			$display ("\t|  DUT 2 Unexpected loss of lock");
			$display ("\t+-----------------------------------------------");
			//fail = 1'b1;
			//$stop();
		end
	end
end

/////////////////////////////////
// stimulus
/////////////////////////////////

reg enough_starts_1 = 1'b0;
reg enough_starts_2 = 1'b0;

always @(posedge clk_din) begin
	enough_starts_1 <= (tx_start_cnt_rp_1 >= 64'h100);
	enough_starts_2 <= (tx_start_cnt_rp_2 >= 64'h100);
end
 
integer cw = 0;

initial begin
	arst = 1'b1;

	repeat (10) begin
			@(negedge clk_status);
	end

	arst = 1'b0;
	
	repeat (10) @(negedge clk_status);
	
	handler_start = 1;
	
    wait(pma_tx_ready_1 & rx_fpll_lock_1 & &rx_cdr_lock_1 & (lanes_deskewed_1 === 1'b1) &
	     pma_tx_ready_2 & rx_fpll_lock_2 & &rx_cdr_lock_2 & (lanes_deskewed_2 === 1'b1));

	$display ("\n#########################\n#########################");
	$display ("\nnormal traffic - switch to packet generator");
	$display ("OK.  Wiping stats...");
	@(negedge clk_din);
	clr_sanity = 1'b1;
	clr_history = 1'b1;
	// reset stats counters and start normal operation
	reset_monitor_cnt = 1'b1;
    
    // tx stats
	@(negedge clk_status);
    wr_addr = 16'h845;	request_writedata = 32'b0001; write_request_1 = 1;
	@(negedge handling_write_request);
	@(negedge clk_status);
    wr_addr = 16'h845;	request_writedata = 32'b0001; write_request_1 = 0;
    
	@(negedge clk_status);
    wr_addr = 16'h845;	request_writedata = 32'b0001; write_request_2 = 1;
	@(negedge handling_write_request);
	@(negedge clk_status);
    wr_addr = 16'h845;	request_writedata = 32'b0001; write_request_2 = 0;
    
    // rx stats
	@(negedge clk_status);
    wr_addr = 16'h945;	request_writedata = 32'b0001; write_request_1 = 1;
	@(negedge handling_write_request);
	@(negedge clk_status);
    wr_addr = 16'h945;	request_writedata = 32'b0001; write_request_1 = 0;
    
	@(negedge clk_status);
    wr_addr = 16'h945;	request_writedata = 32'b0001; write_request_2 = 1;
	@(negedge handling_write_request);
	@(negedge clk_status);
    wr_addr = 16'h945;	request_writedata = 32'b0001; write_request_2 = 0;
    
    // frame error
	@(negedge clk_status);
    wr_addr = 16'h324;	request_writedata = 32'b0001; write_request_1 = 1;
	@(negedge handling_write_request);
	@(negedge clk_status);
    wr_addr = 16'h324;	request_writedata = 32'b0001; write_request_1 = 0;
    
	@(negedge clk_status);
    wr_addr = 16'h324;	request_writedata = 32'b0001; write_request_2 = 1;
	@(negedge handling_write_request);
	@(negedge clk_status);
    wr_addr = 16'h324;	request_writedata = 32'b0001; write_request_2 = 0;
    
    wait(!handling_write_request);

	repeat (2) @(negedge clk_status);
	reset_monitor_cnt = 1'b0;
	clr_history = 1'b0;
	clr_sanity = 1'b0;
	
	$display ("Starting packet generator traffic...");
	packet_gen_idle_1 = 1'b0;
	packet_gen_idle_2 = 1'b0;

	@(posedge enough_starts_1 && enough_starts_2);
	@(negedge clk_din) begin packet_gen_idle_1 = 1'b1; packet_gen_idle_2 = 1'b1; end
	for (cw=0; cw<1000; cw=cw+1'b1) begin : stl3
		if (|din_start_1 || |din_start_2) cw = 0; // oops - still going
		@(negedge clk_din);
	end
	
	@(negedge clk_status) refresh_cntr = 1'b1;
	@(posedge refreshing_cntr) refresh_cntr = 1'b0;
	@(negedge print_cntr_value);	// counter refresh done
	
	$display ("DUT 1 Sent %d packets",tx_start_cnt_1);
	$display ("DUT 2 Received %d packets",rx_start_cnt_2);
	if (tx_start_cnt_1 !== rx_start_cnt_2) begin
		$display ("Count mismatch");
		fail = 1'b1;
	end
	if (runt_cnt_2 !== 0) begin
		$display ("Runts in RX data");
		fail = 1'b1;
	end
	if (fcs_error_cnt_2 !== 0) begin
		$display ("FCS errors in RX data");
		fail = 1'b1;
	end
	if (framing_error_2 != 0) begin
		$display ("framing errors detected during normal operation");
		fail = 1'b1;	
	end
	if (bad_term_cnt_2 !== 0 || bad_serial_cnt_2 !== 0 || bad_dest_cnt_2 !== 0) begin
		$display ("Errors detected by packet gen sanity check");
		fail = 1'b1;		
	end
	
	$display ("DUT 2 Sent %d packets",tx_start_cnt_2);
	$display ("DUT 1 Received %d packets",rx_start_cnt_1);
	if (tx_start_cnt_2 !== rx_start_cnt_1) begin
		$display ("Count mismatch");
		fail = 1'b1;
	end
	if (runt_cnt_1 !== 0) begin
		$display ("Runts in RX data");
		fail = 1'b1;
	end
	if (fcs_error_cnt_1 !== 0) begin
		$display ("FCS errors in RX data");
		fail = 1'b1;
	end
	if (framing_error_1 != 0) begin
		$display ("framing errors detected during normal operation");
		fail = 1'b1;	
	end
	if (bad_term_cnt_1 !== 0 || bad_serial_cnt_1 !== 0 || bad_dest_cnt_1 !== 0) begin
		$display ("Errors detected by packet gen sanity check");
		fail = 1'b1;		
	end
	
	clr_sanity = 1'b1;
	
	if (fail) $stop();

//////////////////////////////////
// Finishing
	if (!fail) begin
		$display ("PASS");
	end
//UNCOMMENT FOLLOWING FOR WAVEFORM DUMPING   -- ncsim
//   $dumpall;
//   $dumpflush;
        $finish();
   
end

/////////////////////////////////
// clock drivers
/////////////////////////////////

assign clk_din = clk_txmac_1;

always begin
	#5000 clk_status = ~clk_status;
end
   always begin
	  `ifdef REFCLK_644 
      #776 clk_ref = ~clk_ref;
	  `endif
      `ifdef REFCLK_322 
      #1552 clk_ref = ~clk_ref;
	  `endif
   end

endmodule
