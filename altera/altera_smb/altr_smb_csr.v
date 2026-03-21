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
module altr_smb_csr #(
  parameter SMB_DFLT_THDDAT 		= 16'h1e,
  parameter SMB_DFLT_TSUDAT		 	= 16'h19,
  parameter SMB_DFLT_TCLKLOW_TMOUT 	= 32'h2625a0,
  parameter SMB_DFLT_SLV_OA		 	= 7'h00,
  parameter SMB_SLV_RCV_HOLD_EN         = 1 
)(
	input	wire		  	clk,
	input	wire		  	rst_n,
	input 	wire			write,
	input 	wire		  	read,
	input 	wire 	[3:0] 	addr,
	input 	wire 	[31:0] 	wrdata,
	input	wire	[7:0]	crc_code_out,
	input	wire	[7:0]	rddata_from_intr_status_reg,
	input	wire	[7:0]	rddata_from_intr_mask_reg,
	input	wire	[7:0]	rddata_from_rxfifo,
	input	wire			slvfsm_idle_state,
	output 	wire 	[31:0] 	rddata,
	output	wire			smben,
	output	wire	[15:0]  tsudat,
	output	wire	[15:0]  thddat,
	output	wire	[31:0]  tclklow_tmout,
	output	wire	[6:0]  	slv_oa,
	output	wire	[1:0]  	slv_rsp,
	output	wire			wr_to_intr_status_reg,
	output	wire	[7:0]	wrdata_to_intr_status_reg,
	output	wire			wr_to_intr_mask_reg,
	output	wire	[7:0]	wrdata_to_intr_mask_reg,
	output 	wire			wr_to_txfifo,
	output	wire	[8:0]	wrdata_to_txfifo,
	output	wire			rd_from_rxfifo,
    output  reg             rls_bus_hold_dly
);
	reg [31:0]	rddata_reg;
	reg	[0:0]	smb_ena;
	reg	[15:0]	smb_thddat;
	reg [15:0]	smb_tsudat;
	reg [31:0]	smb_tclklow_tmout;
	reg [6:0]	smb_slv_oa;
	
	wire [0:0]	smb_ena_combi;
	wire [15:0]	smb_thddat_combi;
	wire [15:0]	smb_tsudat_combi;
	wire [31:0]	smb_tclklow_tmout_combi;
	wire [6:0]	smb_slv_oa_combi;
	wire [31:0]	rddata_out;
	wire [31:0] rddata_combi;

        // case:186600 smb_slv_rsp does not exist when SMB_SLV_RCV_HOLD_EN = 0
        generate
            if (SMB_SLV_RCV_HOLD_EN) begin

	        reg [1:0]	smb_slv_rsp;
	        wire [1:0]	smb_slv_rsp_combi;

                always @(posedge clk or negedge rst_n) begin
		    if (~rst_n) begin
		        smb_slv_rsp <= {2{1'b0}};
		    end
		    else begin
		        smb_slv_rsp <= smb_slv_rsp_combi;				
		    end
	        end

	        assign smb_slv_rsp_combi[0] = (write && (addr == 4'b0101)) ? wrdata[0] 	: smb_slv_rsp[0];
	        assign smb_slv_rsp_combi[1] = (write && (addr == 4'b0101)) ? wrdata[1] 	: 1'b0;
	        assign slv_rsp		    = smb_slv_rsp;

            end
            else begin

	        assign slv_rsp	= 2'h0;

            end
        endgenerate

	assign smben 			= smb_ena;
	assign tsudat			= smb_tsudat;
	assign thddat			= smb_thddat;
	assign tclklow_tmout 	= smb_tclklow_tmout;
	assign slv_oa			= smb_slv_oa;
	assign rddata			= rddata_reg;
	assign rddata_combi		= (rd_from_rxfifo) ? {{(24){1'b0}}, rddata_from_rxfifo} : rddata_out;

	
	always @(posedge clk or negedge rst_n) begin
		  if (~rst_n) begin
			  smb_ena			<= 1'b0;
			  smb_thddat		<= SMB_DFLT_THDDAT;
			  smb_tsudat		<= SMB_DFLT_TSUDAT;
			  smb_tclklow_tmout	<= SMB_DFLT_TCLKLOW_TMOUT;
			  smb_slv_oa		<= SMB_DFLT_SLV_OA;
			  rddata_reg		<= {32{1'b0}};
		  end
		  else begin
			  smb_ena			<= smb_ena_combi;
			  rddata_reg		<= rddata_combi;
			  
			  if (!smb_ena) begin
				  smb_thddat		<= smb_thddat_combi;		
				  smb_tsudat		<= smb_tsudat_combi;		
				  smb_tclklow_tmout	<= smb_tclklow_tmout_combi;	
				  smb_slv_oa		<= smb_slv_oa_combi;
			  end
		  end
	end
	
	// csr write operation
	assign smb_ena_combi 				= (write && (addr == 4'b0000)) ? wrdata[0] 		: smb_ena;
	assign smb_thddat_combi 			= (write && (addr == 4'b0001)) ? wrdata[15:0] 	: smb_thddat;
	assign smb_tsudat_combi				= (write && (addr == 4'b0010)) ? wrdata[15:0] 	: smb_tsudat;
	assign smb_tclklow_tmout_combi 		= (write && (addr == 4'b0011)) ? wrdata 		: smb_tclklow_tmout;
	assign smb_slv_oa_combi 			= (write && (addr == 4'b0100)) ? wrdata[6:0] 	: smb_slv_oa;
	                                	
	assign wr_to_intr_mask_reg			= (write && (addr == 4'b0110)) ? 1'b1 	: 1'b0;
	assign wr_to_intr_status_reg		= (write && (addr == 4'b0111)) ? 1'b1 	: 1'b0;
	assign wr_to_txfifo					= (write && (addr == 4'b1010)) ? 1'b1 	: 1'b0;
	assign wrdata_to_intr_status_reg	= wrdata[7:0];
	assign wrdata_to_intr_mask_reg		= wrdata[7:0];
	assign wrdata_to_txfifo				= wrdata[8:0];
	                                	
	// csr read operation           	
	assign rd_from_rxfifo				= (read && (addr == 4'b1011)) ? 1'b1 	: 1'b0;
	
	assign rddata_out					= (read && (addr == 4'b0000)) ? {{(31){1'b0}}, smb_ena}			:
											(read && (addr == 4'b0001)) ? {{(16){1'b0}}, smb_thddat}	:
											(read && (addr == 4'b0010)) ? {{(16){1'b0}}, smb_tsudat}	:
											(read && (addr == 4'b0011)) ? smb_tclklow_tmout 				:
											(read && (addr == 4'b0100)) ? {{(25){1'b0}}, smb_slv_oa}	:
											(read && (addr == 4'b0101)) ? {{(30){1'b0}}, slv_rsp} 	:
											(read && (addr == 4'b0110)) ? {{(24){1'b0}}, rddata_from_intr_mask_reg}	:
											(read && (addr == 4'b0111)) ? {{(24){1'b0}}, rddata_from_intr_status_reg} :
											(read && (addr == 4'b1000)) ? {{(31){1'b0}}, ~slvfsm_idle_state} :
											(read && (addr == 4'b1001)) ? crc_code_out 					: {32{1'b0}};

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            rls_bus_hold_dly <= 1'b0;
        else
            rls_bus_hold_dly <= slv_rsp[1];
    end

endmodule
