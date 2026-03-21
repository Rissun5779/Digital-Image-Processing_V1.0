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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module altr_smb_intr_ctrl #(
  parameter SMB_PEC_EN					= 1,
  parameter SMB_DFLT_IMR				= 8'b11111111
)(
	input	wire		clk,
	input	wire		rst_n,
	input	wire		wr_to_intr_status_reg,
	input	wire	[7:0]	wrdata_to_intr_status_reg,
	input	wire		wr_to_intr_mask_reg,
	input	wire	[7:0]	wrdata_to_intr_mask_reg,
	input	wire		set_tx_data_req,
	input	wire		rxfifo_empty,
	input	wire		rxfifo_full,
	input	wire		pec_mismatch,
	input	wire		set_clklow_tmout,
	input	wire		set_slv_addr_err,
	input	wire		push_rxfifo,
        input   wire            set_nack_by_mst,
        input   wire            set_stop_cond,
	output  wire [7:0]      rddata_from_intr_status_reg,
	output  wire [7:0]      rddata_from_intr_mask_reg,
	output  reg		smb_intr  
);

	wire			smb_intr_combi;
        wire    [7:0]           smb_imr_reset_value;
	wire 	[7:0]		intr_status;
	wire 	[7:0]		intr_mask;

        wire                    tx_data_req_combi;
        wire                    slv_addr_err_combi;
        wire                    pec_err_combi;
        wire                    clklow_tmout_combi;
        wire                    rx_ovf_combi;
        wire                    nack_by_mst_combi;
        wire                    stop_cond_combi;

        wire                    m_tx_data_req_combi;
        wire                    m_rx_data_avail_combi;
        wire                    m_slv_addr_err_combi;
        wire                    m_pec_err_combi;
        wire                    m_clklow_tmout_combi;
        wire                    m_rx_ovf_combi;
        wire                    m_nack_by_mst_combi;
        wire                    m_stop_cond_combi;

        wire                    rx_data_avail;

        reg                     tx_data_req;
        reg                     slv_addr_err;
        reg                     pec_err;
        reg                     clklow_tmout;
        reg                     rx_ovf;
        reg                     nack_by_mst;
        reg                     stop_cond;

        reg                     m_tx_data_req;
        reg                     m_rx_data_avail;
        reg                     m_slv_addr_err;
        reg                     m_pec_err;
        reg                     m_clklow_tmout;
        reg                     m_rx_ovf;
        reg                     m_nack_by_mst;
        reg                     m_stop_cond;

        assign smb_imr_reset_value = SMB_DFLT_IMR;

        always @(posedge clk or negedge rst_n) begin
	    if (~rst_n) begin
		tx_data_req     <= 1'b0;
                slv_addr_err    <= 1'b0;
                clklow_tmout    <= 1'b0;
                rx_ovf          <= 1'b0;
                nack_by_mst     <= 1'b0;
                stop_cond       <= 1'b0;
                m_tx_data_req   <= smb_imr_reset_value[0];
                m_rx_data_avail <= smb_imr_reset_value[1];
                m_slv_addr_err  <= smb_imr_reset_value[2];
                m_clklow_tmout  <= smb_imr_reset_value[4];
                m_rx_ovf        <= smb_imr_reset_value[5];
                m_nack_by_mst   <= smb_imr_reset_value[6];
                m_stop_cond     <= smb_imr_reset_value[7];
	    end
	    else begin
		tx_data_req     <= tx_data_req_combi;
                slv_addr_err    <= slv_addr_err_combi;
                clklow_tmout    <= clklow_tmout_combi;
                rx_ovf          <= rx_ovf_combi;
                nack_by_mst     <= nack_by_mst_combi;
                stop_cond       <= stop_cond_combi;
                m_tx_data_req   <= m_tx_data_req_combi;
                m_rx_data_avail <= m_rx_data_avail_combi;
                m_slv_addr_err  <= m_slv_addr_err_combi;
                m_clklow_tmout  <= m_clklow_tmout_combi;
                m_rx_ovf        <= m_rx_ovf_combi;
                m_nack_by_mst   <= m_nack_by_mst_combi;
                m_stop_cond     <= m_stop_cond_combi;
	    end
	end


	always @(posedge clk or negedge rst_n) begin
	    if (~rst_n) begin
                    pec_err     <= 1'b0;
                    m_pec_err   <= smb_imr_reset_value[3];
	    end
	    else begin
                    pec_err     <= pec_err_combi;
                    m_pec_err   <= m_pec_err_combi;
	    end
	end

	generate 
	    if (SMB_PEC_EN) begin

	        assign pec_err_combi    = pec_mismatch ? 1'b1 :
				            (wr_to_intr_status_reg && wrdata_to_intr_status_reg[3]) ? 1'b0 :
					        pec_err;

            assign m_pec_err_combi  = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[3] : m_pec_err;
	    end
	    else begin

            assign pec_err_combi    = 1'b0;
            assign m_pec_err_combi  = 1'b0;
	    end
	endgenerate

    assign intr_status      = {stop_cond, nack_by_mst, rx_ovf, clklow_tmout, pec_err, slv_addr_err, rx_data_avail, tx_data_req};
    assign intr_mask        = {m_stop_cond, m_nack_by_mst, m_rx_ovf, m_clklow_tmout, m_pec_err, m_slv_addr_err, m_rx_data_avail, m_tx_data_req};

	assign smb_intr_combi               = |(intr_status & intr_mask);
	assign rddata_from_intr_status_reg  = intr_status;
	assign rddata_from_intr_mask_reg    = intr_mask;

	always @(posedge clk or negedge rst_n) begin
	    if (~rst_n) begin
		smb_intr    <= 1'b0;
	    end
	    else begin
		smb_intr    <= smb_intr_combi;
	    end
	end
	
	
	assign tx_data_req_combi    = set_tx_data_req ?  1'b1 : 
				        (wr_to_intr_status_reg && wrdata_to_intr_status_reg[0]) ? 1'b0 :
					    tx_data_req;
	
        assign rx_data_avail        = (rxfifo_empty) ? 1'b0 : 1'b1;
	
        assign slv_addr_err_combi   = set_slv_addr_err ? 1'b1 :
                                        (wr_to_intr_status_reg && wrdata_to_intr_status_reg[2]) ? 1'b0 :
                                            slv_addr_err;
	
        assign clklow_tmout_combi   = set_clklow_tmout ? 1'b1 :
				        (wr_to_intr_status_reg && wrdata_to_intr_status_reg[4]) ? 1'b0 :
					    clklow_tmout;

	assign rx_ovf_combi         = (rxfifo_full && push_rxfifo) ? 1'b1 :
				        (wr_to_intr_status_reg && wrdata_to_intr_status_reg[5]) ? 1'b0 :
				            rx_ovf;

	assign nack_by_mst_combi    = set_nack_by_mst ? 1'b1 :
				        (wr_to_intr_status_reg && wrdata_to_intr_status_reg[6]) ? 1'b0 :
				            nack_by_mst;

	assign stop_cond_combi      = set_stop_cond ? 1'b1 :
				        (wr_to_intr_status_reg && wrdata_to_intr_status_reg[7]) ? 1'b0 :
				            stop_cond;

        assign m_tx_data_req_combi      = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[0] : m_tx_data_req;
        assign m_rx_data_avail_combi    = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[1] : m_rx_data_avail;
        assign m_slv_addr_err_combi     = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[2] : m_slv_addr_err;
        assign m_clklow_tmout_combi     = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[4] : m_clklow_tmout;
        assign m_rx_ovf_combi           = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[5] : m_rx_ovf;
        assign m_nack_by_mst_combi      = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[6] : m_nack_by_mst;
        assign m_stop_cond_combi        = (wr_to_intr_mask_reg) ? wrdata_to_intr_mask_reg[7] : m_stop_cond;
	
endmodule
