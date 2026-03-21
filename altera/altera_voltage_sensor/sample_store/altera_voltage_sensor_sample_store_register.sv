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


// $Id: //acds/main/ip/altera_remote_update/altera_remote_update.sv#3 $
// $Revision: #3 $
// $Date: 2014/09/26 $
// $Author: tgngo $



// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module altera_voltage_sensor_sample_store_register 
#(
  parameter DEPTH  = 8,
  parameter DATA_W = 16,
  parameter ADDR_W = 3
)
   (
    input             clk,
    input             reset,
    input [15:0]      in_data,
    input [2:0]       rdaddress,
    input             rden,
    input [2:0]       wraddress,
    input             wren,
    output reg [15:0] out_data
    );

    reg [DATA_W - 1 : 0] mem [DEPTH - 1 :0];
    
    // Write data to register bank
    genvar               i;
    generate
        for (i = 0; i < DEPTH; i = i + 1) begin : regsiter_banks
            always_ff @(posedge clk or posedge reset) begin
                if (reset)
                    mem[i] <= '0;
                else begin 
                    if (wren & (wraddress == i))
                        mem[i] <= in_data;
                end
            end // always_ff @
        end // block: regsiter_banks
    endgenerate
    
    // Read data from register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            out_data <= '0;
        else begin
            if (rden)
                out_data <= mem[rdaddress];
        end
    end
    
endmodule


