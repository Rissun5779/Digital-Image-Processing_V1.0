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


`timescale 1 ps / 1 ps
module altera_emif_io_hmc_ecc_interface_fifo
#(
    parameter DATA_WIDTH    = 'd1,
    parameter RESERVE_ENTRY = 0
)
(
    clk,
    reset_n,
    
    in_ready,
    in_valid,
    in_data,
    
    out_ready,
    out_valid,
    out_data
);

localparam ENTRY              = (RESERVE_ENTRY) ? 4 : 2; 
localparam ENTRY_WIDTH        = (RESERVE_ENTRY) ? 2 : 1;
localparam ENTRY_ALMOST_FULL  = (RESERVE_ENTRY) ? 2 : 2;
localparam ENTRY_FULL         = (RESERVE_ENTRY) ? 4 : 2;

integer i;

input                                       clk;
input                                       reset_n;

output                                      in_ready;
input                                       in_valid;
input  [DATA_WIDTH - 1 : 0]                 in_data;

input                                       out_ready;
output                                      out_valid;
output [DATA_WIDTH - 1 : 0]                 out_data;

reg  [DATA_WIDTH  - 1 : 0]                  data_reg [ENTRY - 1 : 0];
reg  [ENTRY       - 1 : 0]                  data_vld;
reg  [ENTRY_WIDTH - 1 : 0]                  write_ptr;
reg  [ENTRY_WIDTH - 1 : 0]                  read_ptr;
reg  [ENTRY_WIDTH     : 0]                  entries;

wire                                        in_ready;
reg                                         full;
reg                                         almost_full;
wire                                        out_valid;
wire [DATA_WIDTH - 1 : 0]                   out_data;
wire                                        read_en;
wire                                        write_en;

assign in_ready  = ~almost_full;
assign read_en   = |data_vld && out_ready;
assign write_en  = in_valid && ~full;
assign out_valid = |data_vld;
assign out_data  = data_reg [read_ptr];

always @(posedge clk or negedge reset_n)
begin
    if (!reset_n)
    begin
        data_vld    <= {ENTRY{1'b0}};
        write_ptr   <= {ENTRY_WIDTH{1'b0}};
        read_ptr    <= {ENTRY_WIDTH{1'b0}};
        entries     <= {(ENTRY_WIDTH + 1){1'b0}};
        
        full        <= 1'b0;
        almost_full <= 1'b0;
    end
    else begin
        for (i = 0; i < ENTRY; i = i + 1)
        begin
            if (write_en && (write_ptr == i))
            begin
                data_vld [i] <= 1'b1;
            end
            else if (read_en && (read_ptr == i))
            begin
                data_vld [i] <= 1'b0;
            end
        end
        
        if (write_en)
        begin
            write_ptr <= write_ptr + 1'b1;
        end
        
        if (read_en)
        begin
            read_ptr <= read_ptr + 1'b1;
        end
        
        if (write_en && !read_en)
        begin
            full        <= (entries >= (ENTRY_FULL                                       - 1)) ? 1'b1 : 1'b0;
            almost_full <= (entries >= ((RESERVE_ENTRY ? ENTRY_ALMOST_FULL : ENTRY_FULL) - 1)) ? 1'b1 : 1'b0;
            
            entries     <= entries + 1'b1;
        end
        else if (read_en && !write_en)
        begin
            full        <= (entries >= (ENTRY_FULL                                       + 1)) ? 1'b1 : 1'b0;
            almost_full <= (entries >= ((RESERVE_ENTRY ? ENTRY_ALMOST_FULL : ENTRY_FULL) + 1)) ? 1'b1 : 1'b0;
            
            entries     <= entries - 1'b1;
        end
    end
end

always @(posedge clk or negedge reset_n)
begin
    if (!reset_n)
    begin
        for (i = 0; i < ENTRY; i = i + 1)
        begin
            data_reg [i] <= {DATA_WIDTH{1'b0}};
        end
    end
    else
    begin
        for (i = 0; i < ENTRY; i = i + 1)
        begin
            if (i == 0)
            begin
                if (write_en && write_ptr == i)
                begin
                    data_reg [i] <= in_data;
                end
            end
            else
            begin
                if (write_en && write_ptr == i)
                begin
                    data_reg [i] <= in_data;
                end
            end
        end
    end
end

endmodule
