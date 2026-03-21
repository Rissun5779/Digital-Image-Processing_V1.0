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

module xcvr_reconfig_mif_master #(
    // ROM initialization MIF file
    parameter COMBINED_INIT_FILE        = "combined.mif",
    parameter MODE_0_INIT_FILE          = "mode_0.mif",
    parameter MODE_1_INIT_FILE          = "mode_1.mif",
    
    // Use combined MIF file
    parameter USE_COMBINED_MIF          = 0,
    
    // MIF data format
    parameter MIF_DATA_OFFSET_LSB       = 0,
    parameter MIF_DATA_OFFSET_MSB       = 7,
    parameter MIF_DATA_WIDTH            = MIF_DATA_OFFSET_MSB - MIF_DATA_OFFSET_LSB + 1,
    parameter MIF_BIT_MASK_OFFSET_LSB   = 8,
    parameter MIF_BIT_MASK_OFFSET_MSB   = 15,
    parameter MIF_BIT_MASK_WIDTH        = MIF_BIT_MASK_OFFSET_MSB - MIF_BIT_MASK_OFFSET_LSB + 1,
    parameter MIF_DPRIO_ADDR_OFFSET_LSB = 16,
    parameter MIF_DPRIO_ADDR_OFFSET_MSB = 25,
    parameter MIF_DPRIO_ADDR_WIDTH      = MIF_DPRIO_ADDR_OFFSET_MSB - MIF_DPRIO_ADDR_OFFSET_LSB + 1,
    
    // ROM size
    parameter MIF_PER_CONFIG_SIZE       = 20,
    parameter MIF_ADDR_WIDTH            = 5,
    
    // Index of MIF to be read from ROM and write to registers
    parameter MIF_READ_START_OFFSET     = 5'd0,
    parameter MIF_READ_NUM              = 5'd1,
    
    // Avalon-MM interface
    parameter AVM_ADDR_WIDTH            = MIF_DPRIO_ADDR_WIDTH,
    parameter DEVICE_FAMILY             = "Arria 10"
)
(
    input                       clk, // mgmt_clk freq 100MHz
    input                       rst_n,
    
    input                       reconfig_start,
    output                      reconfig_busy,
    
    input                       mif_select, // Latched when reconfig start
    
    output [AVM_ADDR_WIDTH-1:0] reconfig_mgmt_address,
    output                      reconfig_mgmt_read,
    input  [31:0]               reconfig_mgmt_readdata,
    input                       reconfig_mgmt_waitrequest,
    output                      reconfig_mgmt_write,
    output [31:0]               reconfig_mgmt_writedata
);

//
// Local parameters declaration
//
// State definition
localparam STM_IDLE             = 4'b0001;
localparam STM_READ_DATA        = 4'b0010;
localparam STM_WAIT_DATA        = 4'b0100;
localparam STM_WRITE_DATA       = 4'b1000;

// State machine
reg   [3:0]                         state;
reg   [3:0]                         next_state;

// Avalon-MM master control
wire  [AVM_ADDR_WIDTH-1:0]          reconfig_address;
wire  [31:0]                        reconfig_writedata;

reg                                 reconfig_read_r;
reg                                 reconfig_write_r;
reg   [AVM_ADDR_WIDTH-1:0]          reconfig_address_r;
reg   [31:0]                        reconfig_writedata_r;

// Reconfig flow control
reg                                 mif_select_r;
reg                                 reconfig_busy_r;
reg                                 reconfig_last_addr;
reg   [MIF_ADDR_WIDTH-1:0]          write_count;

// ROM related signals
wire                                rom_mode_0_clken;
wire  [MIF_ADDR_WIDTH-1:0]          rom_mode_0_addr_ptr;
wire  [31:0]                        rom_mode_0_data_out;

wire                                rom_mode_1_clken;
wire  [MIF_ADDR_WIDTH-1:0]          rom_mode_1_addr_ptr;
wire  [31:0]                        rom_mode_1_data_out;

wire                                rom_combined_clken;
wire  [MIF_ADDR_WIDTH-1:0]          rom_combined_addr_ptr;
wire  [31:0]                        rom_combined_data_out;

wire  [31:0]                        rom_data_out;

// Processed memory content
wire  [MIF_DPRIO_ADDR_WIDTH-1:0]    dprio_addr;
wire  [MIF_BIT_MASK_WIDTH-1:0]      dprio_bit_mask;
wire  [MIF_DATA_WIDTH-1:0]          dprio_data;
wire  [MIF_DATA_WIDTH-1:0]          dprio_writedata;

// ROM address counter
wire  [MIF_ADDR_WIDTH-1:0]          rom_addr_ptr_init;
reg   [MIF_ADDR_WIDTH-1:0]          rom_addr_ptr;
reg                                 rom_data_valid_p1;
reg                                 rom_data_valid_p2;
wire                                rom_data_valid;

//
// State machine
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        state <= STM_IDLE;
    end
    else begin
        state <= next_state;
    end
end

always @(*)
begin
    case(state)
        
        STM_IDLE: begin
            if(reconfig_start) begin
                next_state = STM_READ_DATA;
            end
            else begin
                next_state = STM_IDLE;
            end
        end
        
        STM_READ_DATA: begin
            next_state = STM_WAIT_DATA;
        end
        
        STM_WAIT_DATA: begin
            if(rom_data_valid) begin
                next_state = STM_WRITE_DATA;
            end
            else begin
                next_state = STM_WAIT_DATA;
            end
        end
        
        STM_WRITE_DATA: begin
            if(~reconfig_mgmt_waitrequest) begin
                if(reconfig_last_addr) begin
                    next_state = STM_IDLE;
                end
                else begin
                    next_state = STM_READ_DATA;
                end
            end
            else begin
                next_state = STM_WRITE_DATA;
            end
        end
        
        default: begin
            next_state = STM_IDLE;
        end
        
    endcase
end

//
// Reconfiguration flow control
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        mif_select_r <= 1'b0;
        reconfig_busy_r <= 1'b0;
        reconfig_last_addr <= 1'b0;
        write_count <= {MIF_ADDR_WIDTH{1'b0}};
    end
    else begin
        
        // Store the MIF selection index when reconfig start during idle
        // The value will hold during other states
        if(state == STM_IDLE) begin
            mif_select_r <= mif_select;
        end
        
        // Set status to busy when reconfig start
        if(state == STM_IDLE) begin
            if(reconfig_start) begin
                reconfig_busy_r <= 1'b1;
            end
            else begin
                reconfig_busy_r <= 1'b0;
            end
        end
        else begin
            reconfig_busy_r <= 1'b1;
        end
        
        // Indicates last data to configure
        reconfig_last_addr <= (write_count >= MIF_READ_NUM - 1);
        
        // Count number of successful write
        if(state == STM_IDLE) begin
            write_count <= {MIF_ADDR_WIDTH{1'b0}};
        end
        else if(state == STM_WRITE_DATA) begin
            if(~reconfig_mgmt_waitrequest) begin
                write_count <= write_count + {{(MIF_ADDR_WIDTH-1){1'b0}}, 1'b1};
            end
        end
        
    end
end

assign reconfig_busy = reconfig_busy_r;

//
// ROM access control
//
generate if(USE_COMBINED_MIF == 0)
    begin: SEPARATE_MIF
        assign rom_mode_0_clken = reconfig_busy_r & ~mif_select_r;
        assign rom_mode_1_clken = reconfig_busy_r & mif_select_r;
        
        assign rom_mode_0_addr_ptr = rom_addr_ptr;
        assign rom_mode_1_addr_ptr = rom_addr_ptr;
        
        assign rom_data_out = mif_select_r ? rom_mode_1_data_out : rom_mode_0_data_out;
        
        assign rom_addr_ptr_init = MIF_READ_START_OFFSET;
        
        //
        // ROM: Mode 0
        //
        rom_1port #(
            .INIT_FILE  (MODE_0_INIT_FILE),
            .ADDR_WIDTH (MIF_ADDR_WIDTH),
            .DEVICE_FAMILY (DEVICE_FAMILY)
        ) u_rom_mode_0 (
            .clock      (clk),
            .clken      (rom_mode_0_clken),
            .address    (rom_mode_0_addr_ptr),
            .q          (rom_mode_0_data_out)
        );
        
        //
        // ROM: Mode 1
        //
        rom_1port #(
            .INIT_FILE  (MODE_1_INIT_FILE),
            .ADDR_WIDTH (MIF_ADDR_WIDTH),
            .DEVICE_FAMILY (DEVICE_FAMILY)
        ) u_rom_mode_1 (
            .clock      (clk),
            .clken      (rom_mode_1_clken),
            .address    (rom_mode_1_addr_ptr),
            .q          (rom_mode_1_data_out)
        );
    end
else begin: COMBINED_MIF
        assign rom_combined_clken = reconfig_busy_r;
        assign rom_combined_addr_ptr = rom_addr_ptr;
        
        assign rom_data_out = rom_combined_data_out;
        
        assign rom_addr_ptr_init = mif_select ? (MIF_READ_START_OFFSET + MIF_PER_CONFIG_SIZE) : MIF_READ_START_OFFSET;
        
        //
        // ROM: Combined
        //
        rom_1port #(
            .INIT_FILE  (COMBINED_INIT_FILE),
            .ADDR_WIDTH (MIF_ADDR_WIDTH),
            .DEVICE_FAMILY (DEVICE_FAMILY)
        ) u_rom_mode_1 (
            .clock      (clk),
            .clken      (rom_combined_clken),
            .address    (rom_combined_addr_ptr),
            .q          (rom_combined_data_out)
        );
    end
endgenerate

//
// Processing of memory content
//
assign dprio_data       = rom_data_out[MIF_DATA_OFFSET_MSB       : MIF_DATA_OFFSET_LSB];
assign dprio_bit_mask   = rom_data_out[MIF_BIT_MASK_OFFSET_MSB   : MIF_BIT_MASK_OFFSET_LSB];
assign dprio_addr       = rom_data_out[MIF_DPRIO_ADDR_OFFSET_MSB : MIF_DPRIO_ADDR_OFFSET_LSB];
assign dprio_writedata  = dprio_data & dprio_bit_mask;

assign reconfig_address = dprio_addr;
assign reconfig_writedata = dprio_writedata;

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        rom_addr_ptr <= {MIF_ADDR_WIDTH{1'b0}};
        rom_data_valid_p1 <= 1'b0;
        rom_data_valid_p2 <= 1'b0;
    end
    else begin
        // Read from start index when reconfig start during idle
        if(state == STM_IDLE) begin
            rom_addr_ptr <= rom_addr_ptr_init;
        end
        else if(state == STM_WRITE_DATA) begin
            // Count up whenever Avalon-MM not busy, which indicates success of write
            if(~reconfig_mgmt_waitrequest) begin
                rom_addr_ptr <= rom_addr_ptr + {{(MIF_ADDR_WIDTH-1){1'b0}}, 1'b1};
            end
        end
        
        // Read latency of the ROM is 2 clock cycles
        if(state == STM_READ_DATA) begin
            rom_data_valid_p1 <= 1'b1;
        end
        else begin
            rom_data_valid_p1 <= 1'b0;
        end
        
        rom_data_valid_p2 <= rom_data_valid_p1;
        
    end
end

assign rom_data_valid = rom_data_valid_p2;

//
// Avalon MM master interface
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        reconfig_read_r <= 1'b0;
        reconfig_write_r <= 1'b0;
        reconfig_address_r <= {AVM_ADDR_WIDTH{1'b0}};
        reconfig_writedata_r <= 32'd0;
    end
    else begin
        reconfig_read_r <= 1'b0;
        reconfig_address_r <= reconfig_address;
        reconfig_writedata_r <= reconfig_writedata;
        
        if(state == STM_WAIT_DATA) begin
            reconfig_write_r <= rom_data_valid;
        end
        else if(state == STM_WRITE_DATA) begin
            reconfig_write_r <= reconfig_mgmt_waitrequest;
        end
        else begin
            reconfig_write_r <= 1'b0;
        end
    end
end

assign reconfig_mgmt_read = reconfig_read_r;
assign reconfig_mgmt_write = reconfig_write_r;
assign reconfig_mgmt_address = reconfig_address_r;
assign reconfig_mgmt_writedata = reconfig_writedata_r;

endmodule
