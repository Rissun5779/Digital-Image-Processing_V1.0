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



module dfe_nios_top #(
	parameter NUM_LN = 6, // NOTE : change log below to match !
    parameter LOG_NUM_LN = 3, // enough bits to describe 0..NUM_LN-1
	parameter RST_CNTR = 16,	// nominal 16, less for fast sim
    parameter PLL_PER_LCHAN = 1, // pll channels to skip between each xcvr channel
	parameter PROG_MEM_INIT = "dyn_rx_iram.hex",
	parameter SCRATCH_MEM_INIT = "dyn_rx_dram.hex",
	parameter PROG_MEM_ADDR_WIDTH = 12,
	parameter SCRATCH_MEM_ADDR_WIDTH = 10
)(
    input clk100,
    input rst100,
    
    input [NUM_LN-1:0] ena_train, // if any are high, cpu must have exclusive access to reconfig
    input [NUM_LN-1:0] data_mode, // lane in 10g/fec data mode
    
    input [31:0] ctrain_ctrl,
    input [31:0] train_dly, // pause between training cycles. 1s = ~500,000 @100mhz clk
    input [31:0] ctrain_setpoints,
    
    output reg reco_lock = 0, // cpu is claiming access to reconfig, don't interfere.
    output reg [6:0]     reconfig_mgmt_address = 0,
    output reg           reconfig_mgmt_read = 0,
    input      [31:0]    reconfig_mgmt_readdata,
    input                reconfig_mgmt_waitrequest,
    output reg           reconfig_mgmt_write = 0,
    output reg [31:0]    reconfig_mgmt_writedata = 0,
    input reconfig_busy,
    
    input  [7:0] reco_testbus, // need reco mod to bring out testbus
    
    output reg [NUM_LN-1:0] kr_done, // training done, ready for 10g mode
    output reg [32-1:0] tsd_vals,
    
    // temperature input (degrees c)
    input [7:0] tsd_in,
    
    // on clk100 - CPU backdoor program load port (optional)
    input [15:0] prg_addr,
    input [31:0] prg_din,
    input prg_wr,
    
    // on clk100 - CPU debug IO port (optional)
    input [7:0] byte_to_cpu,		// non-zero bytes are valid
    output reg byte_to_cpu_ack = 1'b0,
    output reg [7:0] byte_from_cpu = 8'h0,
    output reg byte_from_cpu_valid = 1'b0,
    input from_cpu_pfull
);

//////////////////////////////////////////////////////////////
// NIOS state machine helper

wire ext_read,ext_write;
wire [15:0] ext_addr;
wire [31:0] ext_wdata;
reg [31:0] ext_rdata = 0;
wire cpu_rstn;

reset_delay rd (
    .clk(clk100),
    .ready_in(!rst100),
    .ready_out(cpu_rstn)
);
defparam rd .CNTR_BITS = RST_CNTR;
	
nios2_smg smg (
	.clk(clk100),
	.sclr_n(cpu_rstn),

	// processor external bus
	.ext_address(ext_addr),
	.ext_read(ext_read),
	.ext_write(ext_write),
	.ext_writedata(ext_wdata),
	.ext_readdata(ext_rdata),

	// back door program load port (optional)
	.prg_addr(prg_addr),
	.prg_din(prg_din),
	.prg_wr(prg_wr)
);
defparam smg .PROG_MEM_INIT = PROG_MEM_INIT;
defparam smg .SCRATCH_MEM_INIT = SCRATCH_MEM_INIT;
defparam smg .PROG_MEM_ADDR_WIDTH = PROG_MEM_ADDR_WIDTH;
defparam smg .SCRATCH_MEM_ADDR_WIDTH = SCRATCH_MEM_ADDR_WIDTH;		


// the testbus timing is strange - harden it 
wire [7:0] testbus;
sync_regs_m2 sr_tb (
	.clk(clk100),
	.din(reco_testbus),
	.dout(testbus)
);
defparam sr_tb .WIDTH = 8;


/////////////////////////////////////////////////////
// Service reads issued by the NIOS

// handle kr_done
reg [NUM_LN-1:0] set_kr_done;
always @(posedge clk100 or posedge rst100) begin
   if(rst100) begin
      kr_done <= 0;
   end else begin
      // clear kr_done when not in data mode, set it when the nios is done
      kr_done <= (set_kr_done | kr_done) & data_mode;
   end
end		


reg byte_to_cpu_ack_i = 1'b0;
wire dis_adj_ctle = 1'b0;
wire dis_extra_dfe = 1'b0;

always @(posedge clk100) begin
	byte_to_cpu_ack_i <= 1'b0;
	if (ext_read & ext_addr[15]) begin
        case (ext_addr[6:2])
            5'h0 : ext_rdata <= 32'h0 | reconfig_mgmt_address;
            5'h1 : ext_rdata <= 32'h0 | {reconfig_mgmt_read,reconfig_mgmt_write};
            5'h2 : ext_rdata <= 32'h0 | reconfig_mgmt_writedata;
			5'h3 : ext_rdata <= 32'h0 | reconfig_mgmt_readdata;
			5'h4 : ext_rdata <= 32'h0 | {reconfig_busy,reconfig_mgmt_waitrequest};

            5'h5 : ext_rdata <= 32'h0 | kr_done;
            5'h6 : ext_rdata <= 32'h0 | {dis_adj_ctle, dis_extra_dfe};

			5'h7 : ext_rdata <= 32'h0 | testbus;
			5'h9 : ext_rdata <= 32'h0 | ena_train;
			5'ha : ext_rdata <= 32'h0 | reco_lock;

            5'hb : ext_rdata <= 32'h0 | tsd_in;

			5'hc : ext_rdata <= 32'h0 | train_dly;
			5'hd : ext_rdata <= 32'h0 | PLL_PER_LCHAN[7:0];
			5'he : ext_rdata <= 32'h0 | {from_cpu_pfull,8'h0,NUM_LN[7:0]};
			5'hf : begin
					ext_rdata <= 32'h0 | byte_to_cpu;
					byte_to_cpu_ack_i <= 1'b1;
				end
			5'h10 : ext_rdata <= 32'h0 | ctrain_ctrl;
			5'h11 : ext_rdata <= 32'h0 | ctrain_setpoints;
            default : ext_rdata <= 32'h0;
        endcase
    end
end

// the read pulse is kind of long for some reason - make it single
// to not lose bytes
initial byte_to_cpu_ack = 1'b0;
reg last_byte_to_cpu_ack_i = 1'b0;
always @(posedge clk100) begin
	last_byte_to_cpu_ack_i <= byte_to_cpu_ack_i;
	byte_to_cpu_ack <= byte_to_cpu_ack_i && !last_byte_to_cpu_ack_i;
end


/////////////////////////////////////////////////////
// Service writes issued by the NIOS

always @(posedge clk100) begin
	byte_from_cpu_valid <= 1'b0;
    set_kr_done <= 0;
    if (ext_write & ext_addr[15]) begin
        case (ext_addr[6:2])
            5'h0 : reconfig_mgmt_address <= ext_wdata[6:0];
            5'h1 : {reconfig_mgmt_read,reconfig_mgmt_write} <= ext_wdata[1:0];
            5'h2 : reconfig_mgmt_writedata <= ext_wdata;
            
            5'h5 : set_kr_done <= ext_wdata[NUM_LN-1:0];
            
            5'ha : reco_lock <= ext_wdata[0];
			
			5'hf : begin
					byte_from_cpu <= ext_wdata[7:0];
					byte_from_cpu_valid <= 1'b1;
				end
            5'h12 : tsd_vals <= ext_wdata[31:0];
        endcase
    end
end


endmodule 

