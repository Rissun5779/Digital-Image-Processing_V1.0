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


module mr_clock_sync #(
    parameter DEVICE_FAMILY = "Arria V"
) (
    input  wire        wrclk,
    input  wire        rdclk,
    input  wire        aclr,    
    input  wire        wrreq,
    input  wire [19:0] data,
    input  wire        rdreq,
    output wire [19:0] q
);

reg        rd;
wire [7:0] rdusedw;
wire       rdempty;
wire       rdreq_i;
wire       wrfull;
wire       wrreq_i;
always @ (posedge rdclk or posedge aclr)
begin
    if (aclr) begin
        rd <= 1'b0;
    end else begin
        if (rdusedw[7]) begin
            rd <= 1'b1;
        end	    
    end       
end 

assign rdreq_i = rd & ~rdempty & rdreq;
assign wrreq_i = ~wrfull & wrreq; // extra safe apart from the DCFIFO overflow checking circuitry (although doing same thing)
   
dcfifo #(
    .acf_disable_embedded_timing_constraint("true"),
    .intended_device_family (DEVICE_FAMILY),
    .lpm_numwords (256),
    .lpm_showahead ("OFF"),
    .lpm_type ("dcfifo"),
    .lpm_width (20),
    .lpm_widthu (8),
    .overflow_checking ("ON"),
    .rdsync_delaypipe (4),
    .read_aclr_synch ("ON"),
    .underflow_checking ("ON"),
    .use_eab ("ON"),
    .write_aclr_synch ("ON"), // Synchronize the aclr signal with the wrclk to eliminate the potential race 
                              // condition between the falling edge of the aclr signal and the rising edge of wrclk 
                              // if the wrreq port is high
    .wrsync_delaypipe (4)		   
) dcfifo_inst (
    .rdclk (rdclk), 
    .wrclk (wrclk),
    .wrreq (wrreq_i),
    .aclr (aclr), 
    .data (data),
    .rdreq (rdreq_i),
    .q (q),
    .rdempty (rdempty),
    .rdusedw (rdusedw),
    .rdfull (),
    .wrempty (),
    .wrfull (wrfull),
    .wrusedw ()		   
);
   
endmodule		