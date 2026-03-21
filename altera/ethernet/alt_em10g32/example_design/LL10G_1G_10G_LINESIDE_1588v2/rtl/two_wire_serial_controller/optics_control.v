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


// Copyright 2010 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
// baeckler - 02-02-2010

module optics_control (

	// status register bus
	input clk_status,
    input reset,
	input [15:0] status_addr,
	input status_read,
	input status_write,
	input [31:0] status_writedata,
	output reg [31:0] status_readdata,
	output reg status_readdata_valid,
    output status_waitrequest,
    // output reg status_waitrequest,

	// CFP MDIO controls
	// output cfp_mdc,
	// input  cfp_mdio_in,
	// output cfp_mdio_out,
	// output cfp_mdio_oe, // active high
	// input  cfp_glb_alrm,
	// output [4:0] cfp_prtadr,	
	
	// CFP dedicated controls
	output cfp_mod_lopwr,
	output cfp_mod_rst, // active low
	output cfp_tx_dis,	
	input cfp_mod_abs,
	input cfp_rx_los,		
	input [3:1] cfp_prg_alrm,  // strange numbering from the MSA, sorry
	output [3:1] cfp_prg_cntl,	
	
	// I2C controls
	input xfp_sda_in,
	output xfp_sda_out,
	output xfp_sda_oe,	// active high
	input xfp_scl_in,
	output xfp_scl_out,
	output xfp_scl_oe	// active high
		
);

parameter STATUS_ADDR_PREFIX = 10'h1;

parameter SCL_FREQ = 50000;   // for I2C - note : using >400K may have legal implications
parameter CLK_FREQ = 50000000; 
parameter MDIO_FREQ = 50000;

parameter MDIO_CLOCK_DIVIDE = CLK_FREQ / MDIO_FREQ;

////////////////////////////////////////////
// the CFP active levels are all willy nilly
//  clean them up and set some defaults
////////////////////////////////////////////

assign cfp_prg_cntl[1] = 1'b1; // IC's enabled
assign cfp_prg_cntl[2] = 1'b1; // regular power
assign cfp_prg_cntl[3] = 1'b1; // regular power
assign cfp_tx_dis = 1'b0;  //    TX enabled
assign cfp_mod_lopwr = 1'b0;  // TX power enabled

wire [7:0] i_rdata;
reg [7:0] i_wdata = 8'h0;
reg i_read = 1'b0, i_write = 1'b0;
wire [7:0] i_slave_addr, i_mem_addr;
wire i_ack_failure, i_busy;
wire [3:0] i_ack_history;

reg [6:0] cfp_status;
reg [6:0] sync_cfp_status /* synthesis preserve */;
assign status_waitrequest = i_busy;

always @(posedge clk_status or posedge reset) 
    begin
    if(reset)
        begin
        cfp_status <=0;
        sync_cfp_status <=0;
        end
    else
        begin
        cfp_status[0] <= !cfp_mod_rst;  // reset
        cfp_status[1] <= !cfp_mod_abs;  // module plugged in
        cfp_status[2] <= !cfp_rx_los;   // rx signal detect
        cfp_status[3] <= cfp_prg_alrm[1];  // rx cdr lock
        cfp_status[4] <= cfp_prg_alrm[2];  // high power on
        cfp_status[5] <= cfp_prg_alrm[3];  // module ready
        cfp_status[6] <= 0;    // global alarm
        sync_cfp_status <= cfp_status;
        end
    end

////////////////////////////////////////////
// MDIO host
////////////////////////////////////////////

wire [4:0] m_addr1,m_addr2;
wire [15:0] m_rdata;
reg [15:0] m_wdata = 0;
wire m_rdata_valid, m_busy;
reg m_read = 1'b0, m_write = 1'b0, m_write_address = 1'b0, m_read_post_inc = 1'b0;

// mdio_control mdc (
	// .sys_clk(clk_status),
	// .addr1(m_addr1),
	// .addr2(m_addr2),
	
	// commands
	// .read(m_read),
	// .read_post_inc(m_read_post_inc),  // read and increment addr
	// .write(m_write),
	// .write_address(m_write_address), // write wdata as an address
		
	// .rdata(m_rdata),
	// .rdata_valid(m_rdata_valid),
	// .busy(m_busy),			// when busy R/W will be ignored
	// .wdata(m_wdata),
		
	// to MDIO peripheral
	// .mdio_clk(cfp_mdc),
	// .mdio_out(cfp_mdio_out),
	// .mdio_oe(cfp_mdio_oe),
	// .mdio_in(cfp_mdio_in)		
// );
// defparam mdc .CLOCK_DIVIDE = MDIO_CLOCK_DIVIDE;

////////////////////////////////////////////
// I2C host
////////////////////////////////////////////

reg sda_in_r = 1'b0 /* synthesis preserve */;
reg sda_in_rr = 1'b0 /* synthesis preserve */;
reg scl_in_r = 1'b0 /* synthesis preserve */;
reg scl_in_rr = 1'b0 /* synthesis preserve */;

always @(posedge clk_status) begin
	sda_in_r <= xfp_sda_in;
	sda_in_rr <= sda_in_r;	
	scl_in_r <= xfp_scl_in;
	scl_in_rr <= scl_in_r;	
end



two_wire_control two_wire_control_inst
(
	.clk(clk_status),
	
	.sda_in(sda_in_rr),
	.scl_in(scl_in_rr),
	.sda_out(xfp_sda_out),
	.sda_oe(xfp_sda_oe),
	.scl_out(xfp_scl_out),
	.scl_oe(xfp_scl_oe),
	
	.cmd_rd(i_read),
	.cmd_wr(i_write),
	.slave_addr(i_slave_addr),
	.mem_addr(i_mem_addr),
	.wr_data(i_wdata),
	
	.rd_data(i_rdata),
	.rd_data_valid(),
	.ack_failure(i_ack_failure),
	.ack_history(i_ack_history),
	.busy(i_busy)
);
defparam two_wire_control_inst .SCL_FREQ = SCL_FREQ;
defparam two_wire_control_inst .CLK_FREQ = CLK_FREQ;

////////////////////////////////////////////
// Control port
////////////////////////////////////////////

reg status_addr_sel_r = 0;
reg [5:0] status_addr_r = 0;

reg status_read_r = 0, status_write_r = 0;
reg [31:0] status_writedata_r = 0;
reg [31:0] scratch = 0;

// generally prtadr matches addr1 and addr2 is 00001
// reg [14:0] mdio_addrs = 15'h1;
// assign {cfp_prtadr,m_addr1,m_addr2} = mdio_addrs;

reg [15:0] two_wire_addrs = 16'ha000;
assign {i_slave_addr,i_mem_addr} = two_wire_addrs;

reg cfp_enabled = 1'b0;
assign cfp_mod_rst = cfp_enabled;

initial status_readdata = 0;
initial status_readdata_valid = 0;
	
always @(posedge clk_status) begin
	status_addr_r <= status_addr[5:0];
	status_addr_sel_r <= (status_addr[15:6] == STATUS_ADDR_PREFIX[9:0]);
	
	status_read_r <= status_read;
	status_write_r <= status_write;
	status_writedata_r <= status_writedata;	
	status_readdata_valid <= 1'b0;

	// commands are self clearing
	m_read <= 1'b0;
	m_write <= 1'b0;
	m_read_post_inc <= 1'b0;
	m_write_address <= 1'b0;
	i_read <= 1'b0;
	i_write <= 1'b0;
	
	if (status_read) begin
		// if (status_addr_sel_r) begin
			status_readdata_valid <= 1'b1;
			case (status_addr[5:0])
				6'h0 : status_readdata <= scratch;
				6'h1 : status_readdata <= "OPTs";
				6'h2 : status_readdata <= {25'b0,7'ha};
				6'h3 : status_readdata <= {31'b0,cfp_enabled};
                
				6'h4 : status_readdata <= {25'b0,7'hb};
				6'h5 : status_readdata <= {25'b0,7'hc};         
				6'h6 : status_readdata <= {25'b0,7'hd};        
				6'h7 : status_readdata <= {25'b0,7'he};                
				6'h8 : status_readdata <= {16'b0,m_wdata};
				6'h9 : status_readdata <= {m_busy,15'b0,m_rdata};
                6'ha : status_readdata <= {25'b0,7'hf};
				// 6'ha : status_readdata <= {17'b0,mdio_addrs};
				6'hb : status_readdata <= {28'b0,m_write_address,m_write,m_read_post_inc,m_read};
                6'hc : status_readdata <= {25'b0,7'h18};			
                6'hd : status_readdata <= {25'b0,7'h11};	
                6'he : status_readdata <= {25'b0,7'h12};
                6'hf : status_readdata <= {25'b0,7'h11};	                
				6'h10 : status_readdata <= {24'b0,i_wdata};
				6'h11 : status_readdata <= {i_busy,i_ack_failure,2'b0,i_ack_history,16'b0,i_rdata};
				6'h12 : status_readdata <= {16'b0,two_wire_addrs};
				6'h13 : status_readdata <= {30'b0,i_write,i_read};
				
				default : status_readdata <= 32'h123;
			endcase		
		end
		else begin
			// this read is not for my address prefix - ignore it.
		end
	// end	
	
	if (status_write) begin
		// if (status_addr_sel_r) begin
			case (status_addr)
				6'h0 : scratch <= status_writedata;		
				6'h1 : cfp_enabled <= status_writedata[0];		
				6'h2 : cfp_enabled <= status_writedata[0];	                
				6'h3 : cfp_enabled <= status_writedata[0];
				6'h4 : cfp_enabled <= status_writedata[0];	
				6'h5 : cfp_enabled <= status_writedata[0];		
				6'h6 : cfp_enabled <= status_writedata[0];	                
				6'h7 : cfp_enabled <= status_writedata[0];		
                
				6'h8 : m_wdata <= status_writedata[15:0];	
                
				6'h9 : cfp_enabled <= status_writedata[0];		
				6'ha : cfp_enabled <= status_writedata[0];	                                
				// 6'ha : if (!m_busy) mdio_addrs <= status_writedata[14:0];									
				6'hb : {m_write_address,m_write,m_read_post_inc,m_read} <= status_writedata[3:0];
                
				6'hc : cfp_enabled <= status_writedata[0];		
				6'hd : cfp_enabled <= status_writedata[0];	                
				6'he : cfp_enabled <= status_writedata[0];
				6'hf : cfp_enabled <= status_writedata[0];			
				6'h10 : i_wdata <= status_writedata[7:0];									
				6'h12 : two_wire_addrs <= status_writedata[15:0];									
				6'h13 : {i_write,i_read} <= status_writedata[1:0];
							
			endcase
		// end
	end	  
end

// assign status_waitrequest = i_busy;

endmodule