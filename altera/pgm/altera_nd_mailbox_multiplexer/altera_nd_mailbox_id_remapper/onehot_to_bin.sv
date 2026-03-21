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


module onehot_to_bin (onehot,bin);

parameter ONEHOT_WIDTH = 16;
parameter BIN_WIDTH = log2ceil(ONEHOT_WIDTH-1);

input [ONEHOT_WIDTH-1:0] onehot;
output [BIN_WIDTH-1:0] bin;

genvar i,j;
generate
    for (j=0; j<BIN_WIDTH; j=j+1)
    begin : jl
        wire [ONEHOT_WIDTH-1:0] tmp_mask;
        for (i=0; i<ONEHOT_WIDTH; i=i+1)
        begin : il
            assign tmp_mask[i] = i[j];
        end 
        assign bin[j] = |(tmp_mask & onehot);
    end
endgenerate

    function integer log2ceil;
        input integer val;
        integer i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule

