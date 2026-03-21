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
module altera_smb #(
    parameter   SMB_SLV_RCV_HOLD_EN         = 0,
    parameter   SMB_PEC_EN                  = 1,
	parameter	SMB_DFLT_IMR				= 8'b11111111,
	parameter 	SMB_DFLT_THDDAT 			= 16'h1e,
	parameter 	SMB_DFLT_TSUDAT		 		= 16'h19,
	parameter 	SMB_DFLT_TCLKLOW_TMOUT 		= 32'h2625a0,
	parameter 	SMB_DFLT_SLV_OA		 		= 7'h55,
	parameter 	DEVICE_FAMILY				= "CYCLONE V",
	parameter 	MEMORY_TYPE					= "RAM_BLOCK_TYPE=MLAB"
) (
    input           clk,
    input           rst_n,
    input [3:0]     addr,
    input           read,
    input           write,
    input [31:0]    writedata,
    input           smb_data_in,
    input           smb_clk_in,

    output [31:0]   readdata,
    output          smb_data_oe,
    output          smb_clk_oe,
    output          smb_intr
);

wire        start_det;
wire        stop_det;
wire        ack_det;
wire        slv_tx_shift_done;
wire        slv_rx_shift_done;
wire        slv_rx_shift_hold;
wire        rx_addr_match;
wire        rx_addr_2_match;
wire        set_clklow_tmout;
wire        slv_rx_en;
wire        slv_tx_en;
wire        slvfsm_b2b_txshift;
wire        slvfsm_b2b_rxshift;
wire        load_tx_shifter;
wire        slvfsm_idle_state;
wire        slvfsm_rx_addr_state;
wire        slvfsm_rx_addr_2_state;
wire        slvfsm_rx_loop_state;
wire        slvfsm_tx_pec_state;
wire        slv_tx_scl_out;
wire        slv_rx_scl_out;
wire [8:0]  tx_shifter;
wire [7:0]	rx_shifter;
wire        scl_edge_hl;
wire        scl_edge_lh;
wire        start_det_dly;
wire        slv_tx_chk_ack;
wire        slv_tx_sda_out;
wire        sda_int;
wire        slv_rx_sda_out;
wire [7:0]	crc_code_out;
wire		wr_to_intr_status_reg;
wire [7:0]	wrdata_to_intr_status_reg;
wire		wr_to_intr_mask_reg;
wire [7:0]	wrdata_to_intr_mask_reg;
wire [7:0]	rddata_from_intr_status_reg;
wire [7:0]	rddata_from_intr_mask_reg;
wire [8:0]	rddata_from_txfifo;
wire [7:0]	rddata_from_rxfifo;
wire 		smben;
wire [15:0] tsudat;
wire [15:0] thddat;
wire [31:0] tclklow_tmout;
wire [6:0]  slv_oa;
wire [1:0]  slv_rsp;
wire        rls_bus_hold_dly;
wire		pec_mismatch;
wire		set_tx_data_req;
wire		set_slv_addr_err;
wire		rx_data_reg_empty;
wire		rx_data_reg_full;
wire		push_rxfifo;
wire		wr_to_txfifo;
wire [8:0]	wrdata_to_txfifo;
wire		rd_from_txfifo;
wire		txfifo_empty;
wire		txfifo_full;
wire 		wr_to_rxfifo;
wire 		rd_from_rxfifo;
wire 		rxfifo_empty;
wire 		rxfifo_full;
wire            update_crc;
wire [7:0]      crc_data_in;
wire            flush_crc;
wire            verify_crc;
wire            update_crc_rx;
wire            update_crc_tx;
wire            dis_verify_crc;
wire            set_nack_by_mst;
wire            set_stop_cond;


altr_smb_slvfsm #(
    .SMB_SLV_RCV_HOLD_EN        (SMB_SLV_RCV_HOLD_EN),
    .SMB_PEC_EN                 (SMB_PEC_EN)
) i_altr_smb_slvfsm (
    // inputs
    .clk                        (clk),
    .rst_n                      (rst_n),
    .smben                      (smben),
    .tsudat                     (tsudat),
    .rls_bus_hold               (slv_rsp[1]),
    .rls_bus_hold_dly           (rls_bus_hold_dly),
    .start_det                  (start_det),
    .stop_det                   (stop_det),
    .ack_det                    (ack_det),
    .slv_tx_shift_done          (slv_tx_shift_done),
    .slv_rx_shift_done          (slv_rx_shift_done),
    .slv_rx_shift_hold          (slv_rx_shift_hold),
    .rx_addr_match              (rx_addr_match),
    .rx_addr_2_match            (rx_addr_2_match),
    .rx_shifter                 (rx_shifter),
    .txfifo_empty               (txfifo_empty),
    .tx_shifter                 (tx_shifter),
    .set_clklow_tmout           (set_clklow_tmout),
    .update_crc_rx              (update_crc_rx),
    .update_crc_tx              (update_crc_tx),
    .dis_verify_crc             (dis_verify_crc),
    // outputs
    .slv_rx_en                  (slv_rx_en),
    .slv_tx_en                  (slv_tx_en),
    .slvfsm_b2b_txshift         (slvfsm_b2b_txshift),
    .slvfsm_b2b_rxshift         (slvfsm_b2b_rxshift),
    .load_tx_shifter            (load_tx_shifter),
    .slvfsm_idle_state          (slvfsm_idle_state),
    .slvfsm_rx_addr_state       (slvfsm_rx_addr_state),
    .slvfsm_rx_addr_2_state     (slvfsm_rx_addr_2_state),
    .slvfsm_rx_loop_state       (slvfsm_rx_loop_state),
    .slvfsm_tx_pec_state        (slvfsm_tx_pec_state),
    .slv_tx_scl_out             (slv_tx_scl_out),
    .slv_rx_scl_out             (slv_rx_scl_out),
    .set_tx_data_req            (set_tx_data_req),
    .set_slv_addr_err           (set_slv_addr_err),
    .set_nack_by_mst            (set_nack_by_mst),
    .set_stop_cond              (set_stop_cond),
    .update_crc                 (update_crc),
    .crc_data_in                (crc_data_in),
    .flush_crc                  (flush_crc),
    .verify_crc                 (verify_crc)
);

altr_smb_txshifter i_altr_smb_txshifter (
    // inputs
    .clk                        (clk),
    .rst_n                      (rst_n),
    .slv_tx_en                  (slv_tx_en),
    .scl_edge_hl                (scl_edge_hl),
    .load_tx_shifter            (load_tx_shifter),
    .txfifo_data_in             (rddata_from_txfifo),
    .slvfsm_b2b_txshift         (slvfsm_b2b_txshift),
    .start_det_dly              (start_det_dly),
    .slvfsm_tx_pec_state        (slvfsm_tx_pec_state),
    .crc_code_out               (crc_code_out),
    // outputs
    .tx_shifter                 (tx_shifter),
    .slv_tx_chk_ack             (slv_tx_chk_ack),
    .slv_tx_shift_done          (slv_tx_shift_done),
    .slv_tx_sda_out             (slv_tx_sda_out),
    .update_crc_tx              (update_crc_tx)
);

altr_smb_rxshifter #(
    .SMB_SLV_RCV_HOLD_EN        (SMB_SLV_RCV_HOLD_EN),
    .SMB_DFLT_SLV_OA            (SMB_DFLT_SLV_OA)
) i_altr_smb_rxshifter (
    // inputs
    .clk                        (clk),
    .rst_n                      (rst_n),
    .slv_oa                     (slv_oa),
    .rls_bus_hold               (slv_rsp[1]),
    .rls_bus_hold_dly           (rls_bus_hold_dly),
    .ack_nack                   (slv_rsp[0]),
    .slv_rx_en                  (slv_rx_en),
    .slvfsm_idle_state          (slvfsm_idle_state),
    .slvfsm_rx_addr_state       (slvfsm_rx_addr_state),
    .slvfsm_rx_addr_2_state     (slvfsm_rx_addr_2_state),
    .slvfsm_rx_loop_state       (slvfsm_rx_loop_state),
    .slvfsm_b2b_rxshift         (slvfsm_b2b_rxshift),
    .sda_int                    (sda_int),
    .scl_edge_hl                (scl_edge_hl),	
    .scl_edge_lh                (scl_edge_lh),
    .start_det                  (start_det),
    .stop_det                   (stop_det),
    .start_det_dly              (start_det_dly),
    .txfifo_empty               (txfifo_empty),
    .rxfifo_full                (rxfifo_full),
    // outputs
    .push_rxfifo                (push_rxfifo),
    .rx_shifter                 (rx_shifter),
    .slv_rx_sda_out             (slv_rx_sda_out),
    .slv_rx_shift_done          (slv_rx_shift_done),
    .slv_rx_shift_hold          (slv_rx_shift_hold),
    .rx_addr_match              (rx_addr_match),
    .rx_addr_2_match            (rx_addr_2_match),
    .update_crc_rx              (update_crc_rx),
    .dis_verify_crc             (dis_verify_crc)

);


altr_smb_condt_det i_altr_smb_condt_det (
    // inputs
    .clk                        (clk),
    .rst_n                      (rst_n),
    .sda_in                     (smb_data_in),
    .scl_in                     (smb_clk_in),
    .slv_tx_chk_ack             (slv_tx_chk_ack),         // from tx shifter
    .tclklow_tmout              (tclklow_tmout),
    .slvfsm_idle_state          (slvfsm_idle_state),
    .smben                      (smben),
    // outputs
    .scl_edge_hl                (scl_edge_hl),
    .scl_edge_lh                (scl_edge_lh),
    .start_det                  (start_det),
    .start_det_dly              (start_det_dly),
    .stop_det                   (stop_det),
    .ack_det                    (ack_det),
    .set_clklow_tmout           (set_clklow_tmout),
    .sda_int                    (sda_int)

);

altr_smb_txout i_altr_smb_txout (
    // inputs
    .clk                        (clk),
    .rst_n                      (rst_n),
    .thddat                     (thddat),    
    .slv_tx_sda_out             (slv_tx_sda_out),
    .slv_rx_sda_out             (slv_rx_sda_out),
    .slv_tx_scl_out             (slv_tx_scl_out),
    .slv_rx_scl_out             (slv_rx_scl_out),
    .scl_edge_hl                (scl_edge_hl),
    // outputs
    .smb_data_oe                (smb_data_oe),
    .smb_clk_oe                 (smb_clk_oe)

);

altr_smb_intr_ctrl	#(
	.SMB_PEC_EN				(SMB_PEC_EN),
	.SMB_DFLT_IMR  	  		  (SMB_DFLT_IMR  			)
) i_altr_smb_intr_ctrl (
	//inputs
	.clk						(clk),
	.rst_n						(rst_n),
	.wr_to_intr_status_reg		(wr_to_intr_status_reg),
	.wrdata_to_intr_status_reg	(wrdata_to_intr_status_reg),
	.wr_to_intr_mask_reg		(wr_to_intr_mask_reg),
	.wrdata_to_intr_mask_reg	(wrdata_to_intr_mask_reg),
	.set_tx_data_req			(set_tx_data_req),
	.rxfifo_empty				(rxfifo_empty),
	.rxfifo_full				(rxfifo_full),
	.pec_mismatch				(pec_mismatch),
	.set_clklow_tmout			(set_clklow_tmout),
	.set_slv_addr_err			(set_slv_addr_err),
	.push_rxfifo				(push_rxfifo),
        .set_nack_by_mst                (set_nack_by_mst),
        .set_stop_cond                  (set_stop_cond),
	//outputs
	.rddata_from_intr_status_reg    (rddata_from_intr_status_reg),
	.rddata_from_intr_mask_reg	(rddata_from_intr_mask_reg),
	.smb_intr					(smb_intr)
);

altr_smb_csr	#(
	.SMB_DFLT_THDDAT 			(SMB_DFLT_THDDAT),
	.SMB_DFLT_TSUDAT		    (SMB_DFLT_TSUDAT),         
	.SMB_DFLT_TCLKLOW_TMOUT      (SMB_DFLT_TCLKLOW_TMOUT),
	.SMB_DFLT_SLV_OA		    (SMB_DFLT_SLV_OA),
        .SMB_SLV_RCV_HOLD_EN                (SMB_SLV_RCV_HOLD_EN)
) i_altr_smb_csr (
	//inputs
	.clk						(clk),
	.rst_n						(rst_n),
	.write						(write),
	.read						(read),
	.addr						(addr),
	.wrdata						(writedata),
	.crc_code_out				(crc_code_out),
	.rddata_from_intr_status_reg    (rddata_from_intr_status_reg),
	.rddata_from_intr_mask_reg	(rddata_from_intr_mask_reg),
	.rddata_from_rxfifo			(rddata_from_rxfifo),
	.slvfsm_idle_state			(slvfsm_idle_state),
	//outputs
	.rddata						(readdata),
	.smben						(smben),
	.tsudat						(tsudat),
	.thddat						(thddat),
	.tclklow_tmout				(tclklow_tmout),
	.slv_oa						(slv_oa),
	.slv_rsp					(slv_rsp),
	.wr_to_intr_status_reg		(wr_to_intr_status_reg),
	.wrdata_to_intr_status_reg	(wrdata_to_intr_status_reg),
	.wr_to_intr_mask_reg		(wr_to_intr_mask_reg),
	.wrdata_to_intr_mask_reg	(wrdata_to_intr_mask_reg),
	.wr_to_txfifo				(wr_to_txfifo),
	.wrdata_to_txfifo			(wrdata_to_txfifo),
	.rd_from_rxfifo				(rd_from_rxfifo),
        .rls_bus_hold_dly               (rls_bus_hold_dly)
);

generate 
if (SMB_PEC_EN) begin
	
altr_smb_pec_gen i_altr_smb_pec_gen (
	//inputs
	.clk						(clk),
	.rst_n						(rst_n),
	.data_in					(crc_data_in),
	.update_crc					(update_crc),
	.verify_crc					(verify_crc),
	.flush_crc					(flush_crc),
	.crc_code_in				(rx_shifter),
	//outputs
	.crc_code_out				(crc_code_out),
	.pec_mismatch				(pec_mismatch)
);

end
else begin
	assign crc_code_out = 8'b00000000;
	assign pec_mismatch = 1'b0;
end
endgenerate

altr_smb_txfifo	#(
	.DEVICE_FAMILY	    		(DEVICE_FAMILY),         
	.MEMORY_TYPE	    		(MEMORY_TYPE)
) i_altr_smb_txfifo (
	//inputs
	.clk						(clk),
	.rst_n						(rst_n),
	.wr_to_txfifo				(wr_to_txfifo),
	.wrdata_to_txfifo			(wrdata_to_txfifo),
	.rd_from_txfifo				(load_tx_shifter),
        .sclr                                   (rddata_from_intr_status_reg[4] | ~smben),
	//outputs
	.txfifo_empty				(txfifo_empty),
	.txfifo_full				(txfifo_full),
	.rddata_from_txfifo			(rddata_from_txfifo)
);

altr_smb_rxfifo	#(
	.DEVICE_FAMILY	    		(DEVICE_FAMILY),         
	.MEMORY_TYPE	    		(MEMORY_TYPE)
) i_altr_smb_rxfifo (
	//inputs
	.clk						(clk),
	.rst_n						(rst_n),
	.wr_to_rxfifo				(push_rxfifo),
	.wrdata_to_rxfifo			(rx_shifter),
	.rd_from_rxfifo				(rd_from_rxfifo),
        .sclr                                   (~smben),
	//outputs
	.rxfifo_empty				(rxfifo_empty),
	.rxfifo_full				(rxfifo_full),
	.rddata_from_rxfifo			(rddata_from_rxfifo)
);

endmodule
