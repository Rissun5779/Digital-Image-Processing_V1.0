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


module freq_validate #(
    parameter EXPECTED_LO_FREQ=100,
    parameter EXPECTED_HI_FREQ=100
) (
    input clk,
    input reset,

    input validate,
    input [15:0] freq_val,
    output reg pass
);

always@(posedge clk) begin
    if(reset) begin
        pass <= 1'b0;
    end 
    else begin
        if(validate) begin
            if((freq_val>=EXPECTED_LO_FREQ)&&(freq_val<=EXPECTED_HI_FREQ)) begin
                pass <= 1'b1;
            end
            else begin
                pass <= 1'b0;                
            end
        end
        else
            pass <= 1'b0;
    end
end

endmodule
