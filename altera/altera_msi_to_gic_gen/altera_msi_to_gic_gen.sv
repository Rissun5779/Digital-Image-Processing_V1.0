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


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_msi_to_gic_gen #(
  parameter DEVICE_FAMILY 		= "CYCLONE V",
  parameter MEMORY_TYPE			= "RAM_BLOCK_TYPE=MLAB",
  parameter MSG_DATA_WORD 		= 32,
  parameter ADDR_WIDTH			= 5,
  parameter FIFO_DEPTH			= 4,
  parameter DATA_ENTRY_DEPTH 	= 1
)(
	input 	wire		  								clk,
	input 	wire		  								reset_n,
	                                        			
	// csr interface                        			
	input 	wire										csr_write,
	input 	wire		  								csr_read,
	input 	wire 	[1:0] 								csr_addr,
	input 	wire 	[31:0] 								csr_wrdata,
	output 	reg 	[31:0] 								csr_rddata,
	                                        			
	// ports to access data register        			
	input	wire		  								avmm_write,
	input	wire										avmm_read,
	input	wire  	[ADDR_WIDTH-1:0]					avmm_addr,			
	input	wire	[31:0]								avmm_wrdata,
	output	reg		[31:0]								avmm_rddata,
	output	wire										irq
	
);

	// ------------------------------------------------------------------
    // Ceil(log2()) function log2ceil of 4 = 2
    // ------------------------------------------------------------------
    function integer log2ceil;
      input reg[63:0] val;
      reg [63:0] i;
      begin
        i = 1;
        log2ceil = 0;
        while (i < val) begin
          log2ceil = log2ceil + 1;
          i = i << 1;
        end
      end
    endfunction
   
	localparam DATA_WIDTH 		 = 32;
	localparam MAX_MSG_DATA_WORD = 32;
	localparam WIDTHU = log2ceil(FIFO_DEPTH);
	genvar i, j, m;
	
	reg		[MSG_DATA_WORD-1:0]			status_reg;
	reg		[MSG_DATA_WORD-1:0]			error_reg; 
	reg		[MSG_DATA_WORD-1:0]			irq_mask_reg;
	
	wire	[31:0]						rddata_out;
	wire	[MSG_DATA_WORD-1:0]			rddata_combi;
	wire 	[MSG_DATA_WORD-1:0] 		data_to_status_reg_combi;
	wire	[MSG_DATA_WORD-1:0] 		data_to_error_reg_combi;
	wire	[MSG_DATA_WORD-1:0]			csr_to_irq_mask_reg_combi;
	
	wire	[MSG_DATA_WORD-1:0]			full;
	wire	[MSG_DATA_WORD-1:0] 		empty;
	wire	[MSG_DATA_WORD-1:0]			irq_bus;
	
	always @(posedge clk or negedge reset_n) begin
		if (~reset_n) begin
			status_reg		<= {(MSG_DATA_WORD){1'b0}};
			error_reg		<= {(MSG_DATA_WORD){1'b0}};
			irq_mask_reg	<= {(MSG_DATA_WORD){1'b0}};
		end
		else begin
			status_reg		<= data_to_status_reg_combi;
			error_reg		<= data_to_error_reg_combi;
			irq_mask_reg	<= csr_to_irq_mask_reg_combi;
		end
	end
	
	// Processor write to CSR registers
	assign csr_to_irq_mask_reg_combi 	= (csr_write && (csr_addr == 2'b10))  ? (csr_wrdata[MSG_DATA_WORD-1:0]) : irq_mask_reg;
	
	// Processor read from CSR registers
	assign rddata_combi					= (csr_addr == 2'b00) ? status_reg 		:
										  (csr_addr == 2'b01) ? error_reg  		:
										  (csr_addr == 2'b10) ? irq_mask_reg	: {(MSG_DATA_WORD){1'b0}};	  
	assign rddata_out 					= {{(MAX_MSG_DATA_WORD - MSG_DATA_WORD){1'b0}} , {(MSG_DATA_WORD){csr_read}} & rddata_combi};
							  
	// interrupt request generation logic
	// interrupt is masked if irq_mask bit is '0'
	assign irq_bus						= (status_reg & (irq_mask_reg));
	assign irq							= |irq_bus;
	
	reg 		[4:0]	avmm_read_addr_reg;
	
	always @(posedge clk or negedge reset_n) begin
		if (~reset_n) begin
			csr_rddata			<= 32'd0;
			avmm_read_addr_reg 	<= 5'd0;
		end
		else begin
			csr_rddata					<= rddata_out;
			if (avmm_read) begin
				avmm_read_addr_reg		<= avmm_addr;
			end
		end
	end

	generate
		if (DATA_ENTRY_DEPTH > 1) begin : ifblk1

			wire		[DATA_WIDTH-1:0]	data_reg[MSG_DATA_WORD-1:0];
			
			// to read from data register
			assign avmm_rddata = data_reg[avmm_read_addr_reg];

			for (m=0; m<MSG_DATA_WORD; m=m+1) begin : loopblk1
				altera_msi_to_gic_gen_fifo #(
					.DEVICE_FAMILY	(DEVICE_FAMILY),
					.MEMORY_TYPE	(MEMORY_TYPE),
					.DEPTH		  	(DATA_ENTRY_DEPTH),
					.FIFO_DEPTH		(FIFO_DEPTH),
					.WIDTH		  	(DATA_WIDTH),
					.WIDTHU			(WIDTHU)
				) fifo (
					.clock	(clk),
					.data	(avmm_wrdata),
					.rdreq	(avmm_read && (avmm_addr == m) && ~empty[m]),		
					.wrreq	(avmm_write && (avmm_addr == m) && ~full[m]),		
					.empty	(empty[m]),				                            
					.full	(full[m]),					
					.q		(data_reg[m])
				);
				
				assign data_to_status_reg_combi[m] 	= empty[m] ? 1'b0 : 1'b1;	
				assign data_to_error_reg_combi[m]	= (avmm_write && (avmm_addr == m) && full[m]) ? 1'b1 : 
														(csr_write && (csr_addr == 2'b01)) && csr_wrdata[m] ? 1'b0 :  // Error bit is cleared by HP writing '1'
															error_reg[m];
				
			end
		end
		else begin

			reg		[DATA_WIDTH-1:0]	data_reg[(MSG_DATA_WORD)-1:0];
			reg		[MSG_DATA_WORD-1:0]	full_reg;
			
			// register full signal to make sure that it behave the same as during DATA_ENTRY_DEPTH > 1
			always @(posedge clk or negedge reset_n) begin
				for (int k=0; k<MSG_DATA_WORD; k=k+1) begin : loopblk6
					if (~reset_n) begin
						full_reg[k]		<= 1'b0;
					end
					else begin
						if (avmm_write && (avmm_addr == k)) begin
							full_reg[k]		<= 1'b1;
						end
						else if (avmm_read && (avmm_addr == k)) begin
							full_reg[k]		<= 1'b0;
						end
					end
				end
			end
			
			for (i=0; i<MSG_DATA_WORD; i=i+1) begin : loopblk3
				assign full[i] 	= full_reg[i];
				assign empty[i] = ~full_reg[i];
				
				assign data_to_status_reg_combi[i] 	= empty[i] ? 1'b0 : 1'b1;
				assign data_to_error_reg_combi[i]   = (avmm_write && (avmm_addr == i) && full[i]) ? 1'b1 : 
														(csr_write && (csr_addr == 2'b01)) && csr_wrdata[i] ? 1'b0 :  // Error bit is cleared by HP writing '1'
															error_reg[i];
			end
			
			// to read from data register
			assign avmm_rddata = data_reg[avmm_read_addr_reg];

			always @(posedge clk or negedge reset_n) begin
				for (int k=0; k<MSG_DATA_WORD; k=k+1) begin : loopblk5
					if (~reset_n) begin
						data_reg[k]		<= {(DATA_WIDTH){1'b0}};
					end
					else begin
						if (avmm_write && (avmm_addr == k) && ~full[k]) begin
							data_reg[k]		<= avmm_wrdata;
						end
					end
				end
			end
		end
		
	endgenerate

endmodule					  
	

