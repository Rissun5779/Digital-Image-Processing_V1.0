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


module mr_xcvr_offset_sv (
   input wire        clock,
   input wire        reset,
   input wire [1:0]  intf,
   input wire [2:0]  num_exec,
   input wire [31:0] readdata_r,
   input wire [3:0]  rx_m,
   input wire [1:0]  rx_lpfd,
   input wire [1:0]  rx_lpd,
   input wire [1:0]  rx_pfd_bwctrl,
   input wire [1:0]  rx_m_sel,
   input wire [7:0]  rx_eye_mon,
   input wire [2:0]  tx_slew,
   input wire [1:0]  tx_pll_lpfd,
   input wire [1:0]  tx_pll_pfd_bwctrl,
   output wire [4:0]  offset_out,
   output wire [31:0] overriden_data_out
);

reg [4:0]  offset;
reg [31:0]  overriden_data;

// Decode the offset & data needed for reconfig
always @ (posedge clock or posedge reset)
begin
    if (reset) begin
        offset <= 5'h00;
        overriden_data <= 32'h00000000;
    end else begin
        case ({intf, num_exec})
            5'b11_011: begin
                offset <= 5'h0c; // RX, 0x0c
                overriden_data <= {readdata_r[31:16],
                                   rx_m,
                                   rx_lpfd,
                                   rx_lpd,
                                   readdata_r[7:0]};
            end

            5'b11_010: begin
                offset <= 5'h0e; // RX, 0x0e
                overriden_data <= {readdata_r[31:8],
                                   rx_pfd_bwctrl,
                                   readdata_r[5],
                                   rx_m_sel,
                                   readdata_r[2:0]};
            end

            5'b11_001: begin
                offset <= 5'h16; // RX, 0x16
                overriden_data <= {readdata_r[31:11],
                                   rx_eye_mon,
                                   readdata_r[2:0]};
            end

            5'b10_001: begin
                offset <= 5'h02; // TX, 0x02
                overriden_data <= {readdata_r[31:9],
                                   tx_slew,
                                   readdata_r[5:0]};
            end

            5'b01_010: begin
                offset <= 5'h0c; // TX PLL (CMU), 0x0c
                overriden_data <= {readdata_r[31:12],
                                   tx_pll_lpfd,
                                   readdata_r[9:0]};
            end

            5'b01_001: begin
                offset <= 5'h0e; // TX PLL (CMU), 0x0e
                overriden_data <= {readdata_r[31:8],
                                   tx_pll_pfd_bwctrl,
                                   readdata_r[5:0]};
            end

            default: begin
                offset <= 5'h00;
                overriden_data <= readdata_r;
            end
        endcase
    end
end

assign offset_out = offset;
assign overriden_data_out = overriden_data;

endmodule
