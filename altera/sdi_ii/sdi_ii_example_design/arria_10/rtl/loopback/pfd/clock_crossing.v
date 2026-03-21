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


module clock_crossing 
(
  in, 
  in_clk,  // Used for W > 1
  in_reset, 

  out, 
  out_clk, 
  out_reset
);

parameter W=2;

input wire [W-1:0] in;
input wire in_clk, in_reset, out_clk, out_reset;
output wire [W-1:0] out;

//------------------------------------------------------
// N-bit clock crossing using an handshake synchronizer
// Input NOT sampled @ every out_clk cycle
// Sampling period depends on in_clk/out_clk ratio
//------------------------------------------------------

(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON; -name SDC_STATEMENT \"set_false_path -from [get_keepers {*clock_crossing:*|in_ready}] -to [all_registers]\" "} *) reg in_ready /* synopsys translate_off */ = 0 /* synopsys translate_on */;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON; -name SDC_STATEMENT \"set_false_path -from [get_keepers {*clock_crossing:*|in_ack}] -to [all_registers]\" "} *) reg in_ack /* synopsys translate_off */ = 0 /* synopsys translate_on */;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg [1:0] in_ack_r;   
(* altera_attribute = {"-name SDC_STATEMENT \"set_false_path -from [get_keepers {*clock_crossing:*|in_r[*]}] -to [all_registers]\" "} *) reg [W-1:0] in_r;
always @ (posedge in_clk or posedge in_reset)
begin
    if(in_reset) begin
        in_ready <= 1'b0;
        in_ack_r <= 2'b00;
        in_r <= {W{1'b0}};
    end else begin        
        in_ack_r <= {in_ack_r[0],in_ack};

        if(~in_ready & ~in_ack_r[1]) begin
            in_ready <= 1'b1;
            in_r <= in;
        end else if(in_ack_r[1])
            in_ready <= 1'b0;
    end
end

(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) reg [1:0] in_ready_r;   
reg [W-1:0] data_out /* synthesis ALTERA_ATTRIBUTE = "disable_da_rule=\"D101,D102\"" */;
always @ (posedge out_clk or posedge out_reset)
begin
    if(out_reset) begin
        in_ack <= 1'b0;
        in_ready_r <= 2'b00;
        data_out <= {W{1'b0}};
    end else begin
        in_ready_r <= {in_ready_r[0],in_ready};

        if(in_ack & ~in_ready_r[1])
            in_ack <= 1'b0;
        else if(~in_ack & in_ready_r[1]) begin
            in_ack <= 1'b1;
            data_out <= in_r;
        end
    end
end

assign  out = data_out;

endmodule
