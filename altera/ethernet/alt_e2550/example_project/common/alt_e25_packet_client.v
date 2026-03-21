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


module alt_e25_packet_client #(
    parameter WORDS                 = 1,
    parameter WIDTH                 = 64,
    parameter STATUS_ADDR_PREFIX    = 6'b0001_00, //0x1000-0x13ff
    parameter SIM_NO_TEMP_SENSE     = 1'b1,
    parameter DEVICE_FAMILY         = "Arria 10"
)(
    input                           arst,

    // TX to Ethernet
    input                           clk_tx,
    output                          tx_valid,
    input                           tx_ack,
    output     [WIDTH*WORDS-1:0]    tx_data,
    output                          tx_start,
    output                          tx_end,
    output     [2:0]                tx_empty,

    // RX from Ethernet
    input                           clk_rx,
    input                           rx_valid,
    input [WIDTH*WORDS-1:0]         rx_data,
    input                           rx_start,
    input                           rx_end,
    input [2:0]                     rx_empty,

    input                           rx_block_lock,
    input                           rx_am_lock,
    input                           rx_pcs_ready,

    // status register bus
    input                           clk_status,
    input [15:0]                    status_addr,
    input                           status_read,
    input                           status_write,
    input [31:0]                    status_writedata,
    output reg [31:0]               status_readdata,
    output reg                      status_readdata_valid
);

    // tx_ctrl[0] : undefined
    // tx_ctrl[1] : disable packet generate
    // tx_ctrl[2] : undefined
    // tx_ctrl[3] : enable client loopback
    reg [3:0] tx_ctrl = 4'b0010;

    wire rst_tx_syncn;
    reset_synchronizer rs_tx (
        .clk            (clk_tx),
        .resetn         (~arst),
        .resetn_sync    (rst_tx_syncn)
    );

    ///////////////////////////////////////////////////////////////
    // Packet generator
    ///////////////////////////////////////////////////////////////

    wire [WIDTH*WORDS-1:0]  tx_data_pkt_gen;
    wire                    tx_valid_pkt_gen;
    wire [2:0]              tx_empty_pkt_gen;
    wire                    tx_end_pkt_gen;
    wire                    tx_start_pkt_gen;

    wire gen_enable = ~tx_ctrl[1];
    wire gen_enable_sync;
    alt_e2550_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) gen_enable_synchronizer_tx (
        .clk    (clk_tx),
        .din    (gen_enable),
        .dout   (gen_enable_sync)
    );

    avalon_gen_1w pg (
        .clk        (clk_tx),
        .enable     (gen_enable_sync),
        .data       (tx_data_pkt_gen),
        .data_valid (tx_valid_pkt_gen),
        .empty      (tx_empty_pkt_gen),
        .eop        (tx_end_pkt_gen),
        .read_data  (tx_ack),
        .sop        (tx_start_pkt_gen),
        .srst       (~rst_tx_syncn)
    );

    ///////////////////////////////////////////////////////////////
    // Client loopback
    ///////////////////////////////////////////////////////////////
    wire client_loop_en = tx_ctrl[3];

    wire client_loop_en_sync_rx;
    alt_e2550_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) loop_enable_synchronizer_rx (
        .clk    (clk_rx),
        .din    (client_loop_en),
        .dout   (client_loop_en_sync_rx)
    );

    // Packet fifo input mux
    wire [WIDTH*WORDS-1:0] rx_data_loop  = client_loop_en_sync_rx ? rx_data  : {WIDTH*WORDS{1'b0}};
    wire                   rx_start_loop = client_loop_en_sync_rx ? rx_start : 1'b0;
    wire                   rx_end_loop   = client_loop_en_sync_rx ? rx_end   : 1'b0;
    wire [2:0]             rx_empty_loop = client_loop_en_sync_rx ? rx_empty : 3'd0;
    wire                   rx_valid_loop = client_loop_en_sync_rx ? rx_valid : 1'b0;

    wire [WIDTH*WORDS-1:0] tx_data_loop;
    wire                   tx_valid_loop;
    wire [2:0]             tx_empty_loop;
    wire                   tx_end_loop;
    wire                   tx_start_loop;
    wire                   block_dropped;
    packet_fifo #(
        .WIDTH      (64)
    ) client_loop (
        .async_reset         (arst),
        .clk_in              (clk_rx),
        .din                 (rx_data_loop),
        .sop_in              (rx_start_loop),
        .eop_in              (rx_end_loop),
        .empty_in            (rx_empty_loop),
        .valid_in            (rx_valid_loop),
        .full                (/* unused */),
        .block_dropped       (block_dropped),

        .clk_out             (clk_tx),
        .dout                (tx_data_loop),
        .sop_out             (tx_start_loop),
        .eop_out             (tx_end_loop),
        .empty_out           (tx_empty_loop),
        .valid_out           (tx_valid_loop),
        .accepted            (tx_ack)
    );

    wire client_loop_en_sync_tx;
    alt_e2550_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) loop_enable_synchronizer_tx (
        .clk    (clk_tx),
        .din    (client_loop_en),
        .dout   (client_loop_en_sync_tx)
    );

    // TX traffic mux. Switches between client loopback and packet generator
    assign tx_data  = client_loop_en_sync_tx ? tx_data_loop  : tx_data_pkt_gen;
    assign tx_valid = client_loop_en_sync_tx ? tx_valid_loop : tx_valid_pkt_gen;
    assign tx_empty = client_loop_en_sync_tx ? tx_empty_loop : tx_empty_pkt_gen;
    assign tx_end   = client_loop_en_sync_tx ? tx_end_loop   : tx_end_pkt_gen;
    assign tx_start = client_loop_en_sync_tx ? tx_start_loop : tx_start_pkt_gen;

    // Count of dropped blocks
    wire [31:0] dropped_block_count;
    reg clear_dropped_counter;
    stats_counter #(
        .WIDTH      (32),
        .HS_WIDTH   (5)
    ) dropped_counter (
        .csr_clk    (clk_status),
        .csr_clear  (clear_dropped_counter),
        .count      (dropped_block_count),

        .incr_clk   (clk_rx),
        .incr_count (block_dropped)
    );

    ////////////////////////////////////////////
    // Control port
    ////////////////////////////////////////////

    reg         status_addr_sel_r;
    reg [5:0]   status_addr_r;
    reg         status_read_r;
    reg         status_write_r;
    reg [31:0]  status_writedata_r;
    reg [31:0]  scratch = 0;

    wire [31:0] rx_status = {29'd0, rx_block_lock, rx_am_lock, rx_pcs_ready};

    always @(posedge clk_status) begin
        status_addr_r           <= status_addr[5:0];
        status_addr_sel_r       <= (status_addr[15:10] == STATUS_ADDR_PREFIX[5:0]);
        status_read_r           <= status_read;
        status_write_r          <= status_write;
        status_writedata_r      <= status_writedata;
    end

    always @(posedge clk_status) begin
        status_readdata_valid <= 1'b0;
        if (status_read_r) begin
            if (status_addr_sel_r) begin
                status_readdata_valid <= 1'b1;
                case (status_addr_r)
                    6'h0    : status_readdata <= scratch;
                    6'h1    : status_readdata <= "CLNT";
                    6'h3    : status_readdata <= rx_status;
                    6'h7    : status_readdata <= dropped_block_count;
                    6'h10   : status_readdata <= {28'd0, tx_ctrl};
                    default : status_readdata <= 32'h123;
                endcase
            end
        end
    end

    always @(posedge clk_status) begin
        if (status_write_r) begin
            if (status_addr_sel_r) begin
                case (status_addr_r)
                    6'h0  : scratch                 <= status_writedata_r;
                    6'h7  : clear_dropped_counter   <= status_writedata_r[0];
                    6'h10 : tx_ctrl                 <= status_writedata_r[3:0];
                endcase
            end
        end
    end
endmodule
