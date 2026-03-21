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


// $Id: //acds/prototype/mm_s10/ip/merlin/altera_merlin_axi_master_ni/altera_merlin_axi_master_ni.sv#2 $
// $Revision: #2 $
// $Date: 2015/05/26 $    
// $Author: jyeap $

// -----------------------------------------
// AXI Master Agent
//
// Converts AXI master transactions into network packets.
//
// Supports AXI3, AXI4 and AXI4-Lite (see the AXI_VERSION parameter).
// This will eventually support a modified valid-ready handshake 
// scheme that is similar to Avalon-ST's ready latency.
// -----------------------------------------
`timescale 1 ns / 1 ns

module alt_hiconnect_axi_mstr_agent
#( 
    // -------------------------
    // AXI interface parameters
    // -------------------------
   parameter AXI_VERSION = "AXI3",
             ID_WIDTH = 2,
             ADDR_WIDTH = 32,
             RDATA_WIDTH = 32,
             WDATA_WIDTH = 32,
             ADDR_USER_WIDTH = 8,
             DATA_USER_WIDTH = 8,
             LOCK_WIDTH = 2,
             BURST_LENGTH_WIDTH = 4,
             WRITE_ISSUING_CAPABILITY = 16,
             READ_ISSUING_CAPABILITY = 16,
                           
    // -------------------------
    // Packet format parameters
    // -------------------------
             PKT_THREAD_ID_H = 109,
             PKT_THREAD_ID_L = 108,
             PKT_QOS_H = 113,
             PKT_QOS_L = 110,
             PKT_CACHE_H = 103,
             PKT_CACHE_L = 100,
             PKT_ADDR_SIDEBAND_H = 99,
             PKT_ADDR_SIDEBAND_L = 92,
             PKT_DATA_SIDEBAND_H = 124,
             PKT_DATA_SIDEBAND_L = 118,
             PKT_PROTECTION_H = 89,
             PKT_PROTECTION_L = 87,
             PKT_BURST_SIZE_H = 84, 
             PKT_BURST_SIZE_L = 82,
             PKT_BURST_TYPE_H = 86,
             PKT_BURST_TYPE_L = 85, 
             PKT_RESPONSE_STATUS_L = 106,
             PKT_RESPONSE_STATUS_H = 107,
             PKT_BURSTWRAP_H = 79,
             PKT_BURSTWRAP_L = 77,
             PKT_BYTE_CNT_H = 76,
             PKT_BYTE_CNT_L = 74,
             PKT_ADDR_H = 73,
             PKT_ADDR_L = 42,
             PKT_TRANS_EXCLUSIVE = 80,
             PKT_TRANS_LOCK = 105,
             PKT_TRANS_COMPRESSED_READ = 41,
             PKT_TRANS_POSTED = 40,
             PKT_TRANS_WRITE = 39,
             PKT_TRANS_READ = 38,
             PKT_DATA_H = 37,
             PKT_DATA_L = 6,
             PKT_BYTEEN_H = 5,
             PKT_BYTEEN_L = 2,
             PKT_SRC_ID_H = 1,
             PKT_SRC_ID_L = 1,
             PKT_DEST_ID_H = 0,
             PKT_DEST_ID_L = 0,
			 PKT_ORI_BURST_SIZE_H = 127,
			 PKT_ORI_BURST_SIZE_L = 125,
             ST_DATA_W = 128,
                           
    // -------------------------
    // Agent parameters
    // -------------------------
             ID = 1,
    // -------------------------
    // Derived parameters
    // -------------------------
             PKT_BURSTWRAP_W = PKT_BURSTWRAP_H - PKT_BURSTWRAP_L + 1,
             PKT_BYTE_CNT_W = PKT_BYTE_CNT_H - PKT_BYTE_CNT_L + 1,
             PKT_ADDR_W = PKT_ADDR_H - PKT_ADDR_L + 1,
             PKT_DATA_W = PKT_DATA_H - PKT_DATA_L + 1,
             PKT_BYTEEN_W = PKT_BYTEEN_H - PKT_BYTEEN_L + 1,
             PKT_SRC_ID_W = PKT_SRC_ID_H - PKT_SRC_ID_L + 1,
             PKT_DEST_ID_W = PKT_DEST_ID_H - PKT_DEST_ID_L + 1
)
(
    // -------------------------
    // Global signals
    // -------------------------
    input                            aclk,
    input                            aresetn,

    // -------------------------
    // AXI slave-side channels
    // -------------------------

    // Write Address Channel
    input [ID_WIDTH-1:0]             awid,
    input [ADDR_WIDTH-1:0]           awaddr,
    input [BURST_LENGTH_WIDTH - 1:0] awlen, 
    input [2:0]                      awsize,
    input [1:0]                      awburst,
    input [LOCK_WIDTH-1:0]           awlock,
    input [3:0]                      awcache,
    input [2:0]                      awprot,
    input [3:0]                      awqos,
    input [3:0]                      awregion, 
    input [ADDR_USER_WIDTH-1:0]      awuser,
    input                            awvalid,
    output reg                       awready,

    // Write Data Channel
    input [ID_WIDTH-1:0]             wid,
    input [PKT_DATA_W-1:0]           wdata,
    input [(PKT_DATA_W/8)-1:0]       wstrb,
    input                            wlast,
    input                            wvalid,
    input [DATA_USER_WIDTH-1:0]      wuser,
    output reg                       wready,

    // Write Response Channel
    output reg [ID_WIDTH-1:0]        bid,
    output reg [1:0]                 bresp,
    output                           bvalid,
    input                            bready,
    output reg [DATA_USER_WIDTH-1:0] buser, 

    // Read Address Channel
    input [ID_WIDTH-1:0]             arid,
    input [ADDR_WIDTH-1:0]           araddr,
    input [BURST_LENGTH_WIDTH - 1:0] arlen,
    input [2:0]                      arsize,
    input [1:0]                      arburst,
    input [LOCK_WIDTH-1:0]           arlock,
    input [3:0]                      arcache,
    input [2:0]                      arprot,
    input [3:0]                      arqos,
    input [3:0]                      arregion,
    input [ADDR_USER_WIDTH-1:0]      aruser,
    input                            arvalid,
    output                           arready,

    // Read Data Channel
    output reg [ID_WIDTH-1:0]        rid,
    output reg [PKT_DATA_W-1:0]      rdata,
    output reg [1:0]                 rresp,
    output                           rlast,
    output                           rvalid,
    input                            rready,
    output reg [DATA_USER_WIDTH-1:0] ruser,

    // -------------------------
    // Network-side interfaces
    // -------------------------

    // Write Request Source
    output wire                      write_req_valid,
    output wire [ST_DATA_W-1:0]      write_req_data,
    output wire                      write_req_startofpacket,
    output wire                      write_req_endofpacket,

    // Write Command Source
    output reg                       write_cp_valid,
    output reg [ST_DATA_W-1:0]       write_cp_data,
    output wire                      write_cp_startofpacket,
    output wire                      write_cp_endofpacket,
    input                            write_cp_ready,

    // Write Response Sink
    input                            write_rp_valid,
    input [ST_DATA_W-1 : 0]          write_rp_data,
    input                            write_rp_startofpacket,
    input                            write_rp_endofpacket,
    output reg                       write_rp_ready,

    // Read Request Source
    output wire                      read_req_valid,
    output wire [ST_DATA_W-1:0]      read_req_data,
    output wire                      read_req_startofpacket,
    output wire                      read_req_endofpacket,

    // Read Command Source
    output reg                       read_cp_valid,
    output reg [ST_DATA_W-1:0]       read_cp_data,
    output wire                      read_cp_startofpacket,
    output wire                      read_cp_endofpacket,
    input                            read_cp_ready,

    // Read Response Sink
    input                            read_rp_valid,
    input [ST_DATA_W-1 : 0]          read_rp_data,
    input                            read_rp_startofpacket,
    input                            read_rp_endofpacket,
    output reg                       read_rp_ready
);

    // --------------------------------------
    // Local parameters
    // --------------------------------------
    localparam BITS_PER_SYMBOL = 8;
    localparam NUMSYMBOLS = PKT_DATA_W / BITS_PER_SYMBOL;

    // --------------------------------------
    // Useful functions
    // --------------------------------------
    typedef enum bit [1:0] 
    {
        FIXED    = 2'b00,
        INCR     = 2'b01,
        WRAP     = 2'b10,
        RESERVED = 2'b11
    } AxiBurstType;

    function AxiBurstType burst_type_decode 
    (
        input [1:0] axburst
    );
        AxiBurstType burst_type;
        begin
            case (axburst)
                2'b00    : burst_type = FIXED;
                2'b01    : burst_type = INCR;
                2'b10    : burst_type = WRAP;
                2'b11    : burst_type = RESERVED;
                default  : burst_type = INCR;
            endcase
            return burst_type;
        end
    endfunction

    // Turns the AXI size value into the actual number of bytes
    // being transferred.
    function reg[7:0] bytes_in_transfer;
        input [2:0] axsize;

        case (axsize)
            3'b000: bytes_in_transfer = 8'b00000001;
            3'b001: bytes_in_transfer = 8'b00000010;
            3'b010: bytes_in_transfer = 8'b00000100;
            3'b011: bytes_in_transfer = 8'b00001000;
            3'b100: bytes_in_transfer = 8'b00010000;
            3'b101: bytes_in_transfer = 8'b00100000;
            3'b110: bytes_in_transfer = 8'b01000000;
            3'b111: bytes_in_transfer = 8'b10000000;
            default:bytes_in_transfer = 8'b00000001;
        endcase

    endfunction

    function integer log2ceil;
        input reg[63:0] val;
        reg [63:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

    function reg [PKT_BURSTWRAP_W - 2:0] burstwrap_boundary_calculation
    (
        input [31:0] burstwrap_boundary_width,
        input int    width = PKT_BURSTWRAP_W - 1
    );
        integer i;

        burstwrap_boundary_calculation = 0;
        for (i = 0; i < width; i++) begin
            if (burstwrap_boundary_width > i)
                burstwrap_boundary_calculation[i] = 1;
        end

    endfunction

    // --------------------------------------------------
    // Sync clear pipeline
    // --------------------------------------------------
    reg internal_sclr_n;

    always @(posedge aclk) begin
        internal_sclr_n <= aresetn;
    end

    // --------------------------------------------------
    // Convert the two-bit burst type signal into an enum 
    // for readability
    // --------------------------------------------------
    AxiBurstType write_burst_type;
    AxiBurstType read_burst_type;

    always_comb begin
        write_burst_type = burst_type_decode(awburst);
        read_burst_type  = burst_type_decode(arburst);
    end

    // --------------------------------------------------
    // Command alignment stage
    //
    // We align the AW and W channels so that we can present
    // beats with valid address and data, as required by the
    // unserialized packet format.
    // 
    // This stage also converts the valid-ready handshake of
    // the AXI command channels into a ready-valid handshake, 
    // where ready must be asserted before valid can be 
    // asserted.
    //
    // Other stages will make use of the handshake conversion
    // to easily add pipeline stages (ready latency > 0).
    //
    // The aligned_* valid and ready control signals from this
    // stage are still on the same cycle as the AXI interface 
    // (the logic here is combinational).
    // --------------------------------------------------
    wire aligned_aw_w_valid;
    wire aligned_aw_w_ready;

    wire aligned_ar_valid;
    wire aligned_ar_ready;

    assign aligned_aw_w_valid = awvalid && wvalid && aligned_aw_w_ready;
    assign aligned_aw_w_ready = write_cp_ready;

    always_comb begin
        awready = aligned_aw_w_ready && wvalid && wlast;
        wready = aligned_aw_w_ready && awvalid;
    end
        
    assign aligned_ar_valid = arvalid && aligned_ar_ready;
    assign aligned_ar_ready = read_cp_ready;
    assign arready = aligned_ar_ready;

    // --------------------------------------------------
    // Write request stage
    // --------------------------------------------------
    assign write_req_valid = write_cp_valid;
    assign write_req_data = write_cp_data;
    assign write_req_startofpacket = write_cp_startofpacket;
    assign write_req_endofpacket = write_cp_endofpacket;

    // --------------------------------------------------
    // Write command packet stage
    //
    // This stage assigns the various AXI signals to the
    // fields in the packet, with modifications where
    // necessary.
    // --------------------------------------------------
    reg is_sop;
    reg [31:0] total_bytecount_left_wire;   // to eliminate QIS warning
    reg [31:0] total_write_bytecount_wire;  // to eliminate QIS warning
    reg [PKT_BYTE_CNT_W - 1:0] total_bytecount_left;
    reg [PKT_BYTE_CNT_W - 1:0] write_burst_bytecount;
    reg [PKT_BYTE_CNT_W - 1:0] total_write_bytecount;
    reg [PKT_BYTE_CNT_W - 1:0] burst_bytecount;

    reg  [31:0]                  burstwrap_value_write;
    reg  [PKT_BURSTWRAP_W - 2:0] burstwrap_boundary_write;
    wire [31:0]                  burstwrap_boundary_width_write;

    wire [31:0] bytes_in_transfer_minusone_write_wire;  // eliminates synthesis warning

    reg [PKT_ADDR_W - 1:0] address_aligned;

    wire [31:0] id_int = ID;

    assign write_cp_valid = aligned_aw_w_valid;
    assign write_cp_startofpacket = is_sop;

    always_ff @(posedge aclk) begin
        if (!internal_sclr_n) begin
            is_sop <= 1'b1;
        end else if (aligned_aw_w_valid) begin
            is_sop <= wlast;
        end
    end

    assign write_cp_endofpacket = wlast;

    always_comb begin
        write_cp_data                                    = '0;
        write_cp_data[PKT_BYTE_CNT_H:PKT_BYTE_CNT_L]     = write_burst_bytecount;
        write_cp_data[PKT_TRANS_EXCLUSIVE]               = awlock[0];
        write_cp_data[PKT_TRANS_LOCK]                    = 1'b0;
        write_cp_data[PKT_TRANS_COMPRESSED_READ]         = 1'b0;
        write_cp_data[PKT_TRANS_READ]                    = 1'b0;
        write_cp_data[PKT_TRANS_WRITE]                   = 1'b1;
        write_cp_data[PKT_TRANS_POSTED]                  = 1'b0;
        write_cp_data[PKT_BURSTWRAP_H:PKT_BURSTWRAP_L]   = burstwrap_value_write[PKT_BURSTWRAP_W - 1:0];
        write_cp_data[PKT_ADDR_H:PKT_ADDR_L]             = awaddr;
        write_cp_data[PKT_DATA_H:PKT_DATA_L]             = wdata;
        write_cp_data[PKT_BYTEEN_H:PKT_BYTEEN_L]         = wstrb;
        write_cp_data[PKT_BURST_SIZE_H:PKT_BURST_SIZE_L] = awsize;
        write_cp_data[PKT_BURST_TYPE_H:PKT_BURST_TYPE_L] = awburst;
        write_cp_data[PKT_SRC_ID_H:PKT_SRC_ID_L]         = id_int[PKT_SRC_ID_W - 1:0];
        write_cp_data[PKT_PROTECTION_H:PKT_PROTECTION_L] = awprot;
        write_cp_data[PKT_THREAD_ID_H:PKT_THREAD_ID_L]   = awid;
        write_cp_data[PKT_CACHE_H:PKT_CACHE_L]           = awcache;
        write_cp_data[PKT_ADDR_SIDEBAND_H:PKT_ADDR_SIDEBAND_L]   = awuser;
        write_cp_data[PKT_ORI_BURST_SIZE_H:PKT_ORI_BURST_SIZE_L] = awsize;
        
        if (AXI_VERSION == "AXI4") begin
            write_cp_data[PKT_QOS_H:PKT_QOS_L]                     = awqos;
            write_cp_data[PKT_DATA_SIDEBAND_H:PKT_DATA_SIDEBAND_L] = wuser;
        end else begin
            write_cp_data[PKT_QOS_H:PKT_QOS_L]                     = '0;
            write_cp_data[PKT_DATA_SIDEBAND_H:PKT_DATA_SIDEBAND_L] = '0;
        end
    end

    always_comb begin
        if (is_sop) begin
            write_burst_bytecount = total_write_bytecount;
        end else begin
            write_burst_bytecount = burst_bytecount;
        end
    end

    always_comb begin
        total_write_bytecount_wire = (awlen + 1) << log2ceil(NUMSYMBOLS);
        total_write_bytecount = total_write_bytecount_wire[PKT_BYTE_CNT_W-1:0];
    end

    assign total_bytecount_left_wire = write_burst_bytecount - NUMSYMBOLS;
    assign total_bytecount_left = total_bytecount_left_wire[PKT_BYTE_CNT_W-1:0];

    always_ff @(posedge aclk) begin
        if (aligned_aw_w_valid) begin
            burst_bytecount <= total_bytecount_left;
        end
    end

    always_comb begin
        burstwrap_value_write = 0;
        case (write_burst_type)
            INCR: begin
                burstwrap_value_write[PKT_BURSTWRAP_W - 1:0] = {PKT_BURSTWRAP_W {1'b1}};
            end 
            WRAP: begin
                burstwrap_value_write[PKT_BURSTWRAP_W - 1:0] = {1'b0, burstwrap_boundary_write};
            end
            FIXED: begin
                burstwrap_value_write[PKT_BURSTWRAP_W - 1:0] = bytes_in_transfer_minusone_write_wire[PKT_BURSTWRAP_W - 1:0];
            end
            default: begin
                burstwrap_value_write[PKT_BURSTWRAP_W - 1:0] = {PKT_BURSTWRAP_W {1'b1}};
            end
        endcase
    end

    // The following algorithm figures out the width of the burstwrap 
    // boundary, and uses that to set a bit mask for burstwrap.
    //
    // This should synthesize to a small adder, followed by a 
    // per-bit comparator (which gets folded into the adder).
    assign burstwrap_boundary_width_write = awsize + log2ceil(awlen + 1);
    assign burstwrap_boundary_write = burstwrap_boundary_calculation(burstwrap_boundary_width_write, PKT_BURSTWRAP_W - 1);

    assign bytes_in_transfer_minusone_write_wire = bytes_in_transfer(awsize) - 1;

    // --------------------------------------------------
    // Read request stage
    // --------------------------------------------------
    assign read_req_valid = read_cp_valid;
    assign read_req_data = read_cp_data;
    assign read_req_startofpacket = read_cp_startofpacket;
    assign read_req_endofpacket = read_cp_endofpacket;

    // --------------------------------------------------
    // Read command packet stage
    //
    // This stage assigns the various AXI signals to the
    // fields in the packet, with modifications where
    // necessary.
    // --------------------------------------------------
    reg [PKT_BYTE_CNT_W - 1:0] total_read_bytecount;
    reg [31:0] total_read_bytecount_wire;   // to eliminate QIS warning

    reg  [31:0]                  burstwrap_value_read;
    reg  [PKT_BURSTWRAP_W - 2:0] burstwrap_boundary_read;
    wire [31:0]                  burstwrap_boundary_width_read;

    wire [31:0] bytes_in_transfer_minusone_read_wire;   // eliminates synthesis warning 

    assign read_cp_startofpacket = 1'b1;
    assign read_cp_endofpacket = 1'b1;   
    assign read_cp_valid = aligned_ar_valid;

    always_comb begin
        read_cp_data                                    = '0;
        read_cp_data[PKT_BYTE_CNT_H:PKT_BYTE_CNT_L]     = total_read_bytecount;
        read_cp_data[PKT_TRANS_EXCLUSIVE]               = arlock[0];
        read_cp_data[PKT_TRANS_LOCK]                    = 1'b0;
        if (AXI_VERSION != "AXI4Lite") begin
            read_cp_data[PKT_TRANS_COMPRESSED_READ]     = 1'b1;
        end else begin
            read_cp_data[PKT_TRANS_COMPRESSED_READ]     = 1'b0;
        end
        read_cp_data[PKT_TRANS_READ]                    = 1'b1;
        read_cp_data[PKT_TRANS_WRITE]                   = 1'b0;
        read_cp_data[PKT_TRANS_POSTED]                  = 1'b0;
        read_cp_data[PKT_BURSTWRAP_H:PKT_BURSTWRAP_L]   = burstwrap_value_read[PKT_BURSTWRAP_W - 1 : 0]; 
        read_cp_data[PKT_ADDR_H:PKT_ADDR_L]             = araddr;
        read_cp_data[PKT_DATA_H:PKT_DATA_L]             = '0;
        read_cp_data[PKT_BYTEEN_H:PKT_BYTEEN_L]         = {PKT_BYTEEN_W{1'b1}};
        read_cp_data[PKT_SRC_ID_H:PKT_SRC_ID_L]         = id_int[PKT_SRC_ID_W-1:0];
        read_cp_data[PKT_BURST_SIZE_H:PKT_BURST_SIZE_L] = arsize;
        read_cp_data[PKT_BURST_TYPE_H:PKT_BURST_TYPE_L] = arburst;
        read_cp_data[PKT_PROTECTION_H:PKT_PROTECTION_L] = arprot;
        read_cp_data[PKT_THREAD_ID_H:PKT_THREAD_ID_L]   = arid;
        read_cp_data[PKT_CACHE_H:PKT_CACHE_L]           = arcache;
        read_cp_data[PKT_ORI_BURST_SIZE_H:PKT_ORI_BURST_SIZE_L] = arsize;

        read_cp_data[PKT_ADDR_SIDEBAND_H:PKT_ADDR_SIDEBAND_L] = aruser;
        // AXI4 signals: receive from translator
        if (AXI_VERSION == "AXI4") begin
            read_cp_data[PKT_QOS_H:PKT_QOS_L]                     = arqos;
            read_cp_data[PKT_DATA_SIDEBAND_H:PKT_DATA_SIDEBAND_L] = '0;
        end else begin
            read_cp_data[PKT_QOS_H:PKT_QOS_L]                     = '0;
            read_cp_data[PKT_DATA_SIDEBAND_H:PKT_DATA_SIDEBAND_L] = '0;
        end
    end

    always_comb begin
        total_read_bytecount_wire = (arlen + 1) << log2ceil(NUMSYMBOLS);
        total_read_bytecount = total_read_bytecount_wire[PKT_BYTE_CNT_W-1:0];
    end

    assign burstwrap_boundary_width_read = arsize + log2ceil(arlen + 1);
    assign burstwrap_boundary_read = burstwrap_boundary_calculation(burstwrap_boundary_width_read, PKT_BURSTWRAP_W - 1);

    always_comb begin
        burstwrap_value_read = '0;
        case (read_burst_type)
            INCR: begin
                burstwrap_value_read[PKT_BURSTWRAP_W - 1:0] = {PKT_BURSTWRAP_W {1'b1}};
            end 
            WRAP: begin
                burstwrap_value_read[PKT_BURSTWRAP_W - 1:0] = {1'b0, burstwrap_boundary_read};
            end
            FIXED: begin
                burstwrap_value_read[PKT_BURSTWRAP_W - 1:0] = bytes_in_transfer_minusone_read_wire[PKT_BURSTWRAP_W -1:0];    
            end
            default: begin
                burstwrap_value_read[PKT_BURSTWRAP_W - 1:0] = {PKT_BURSTWRAP_W {1'b1}};
            end
        endcase
    end

    assign bytes_in_transfer_minusone_read_wire  = bytes_in_transfer(arsize) - 1;

    // --------------------------------------------------
    // Read response stage. This operates independently of 
    // other logic in this component
    // --------------------------------------------------
    assign rvalid = read_rp_valid;
    assign rlast = read_rp_endofpacket;
    assign read_rp_ready = rready;

    always_comb begin
        rdata = read_rp_data[PKT_DATA_H     :PKT_DATA_L];
        rresp = read_rp_data[PKT_RESPONSE_STATUS_H : PKT_RESPONSE_STATUS_L];
        rid   = read_rp_data[PKT_THREAD_ID_H : PKT_THREAD_ID_L];
        ruser = read_rp_data[PKT_DATA_SIDEBAND_H : PKT_DATA_SIDEBAND_L];
    end

    // --------------------------------------------------
    // Write response stage. This operates independently of 
    // other logic in this component
    // --------------------------------------------------
    assign bvalid = write_rp_valid;
    assign write_rp_ready = bready;

    always_comb begin
        bresp = write_rp_data[PKT_RESPONSE_STATUS_H : PKT_RESPONSE_STATUS_L];
        bid   = write_rp_data[PKT_THREAD_ID_H : PKT_THREAD_ID_L];
        buser = write_rp_data[PKT_DATA_SIDEBAND_H : PKT_DATA_SIDEBAND_L];
    end


// synthesis translate_off
    // --------------------------------------------------
    // Assertions
    // --------------------------------------------------
    generate if (WRITE_ISSUING_CAPABILITY == 1) begin
        wire write_cmd_accepted;
        wire write_response_accepted;
        wire write_response_count_is_1;
        reg [log2ceil(WRITE_ISSUING_CAPABILITY+1)-1:0] pending_write_response_count;
        reg [log2ceil(WRITE_ISSUING_CAPABILITY+1)-1:0] next_pending_write_response_count;
    
        assign write_cmd_accepted = aligned_aw_w_valid && write_cp_endofpacket;
        assign write_response_accepted = write_rp_valid && write_rp_ready && write_rp_endofpacket;
    
        always_comb begin
            next_pending_write_response_count = pending_write_response_count;
            if (write_cmd_accepted)
                next_pending_write_response_count = pending_write_response_count + 1'b1;
            if (write_response_accepted)
                next_pending_write_response_count = pending_write_response_count - 1'b1;
            if (write_cmd_accepted && write_response_accepted)
                next_pending_write_response_count = pending_write_response_count;
        end

        always_ff @(posedge aclk) begin
            if (!aresetn) begin
                pending_write_response_count <= '0;
            end else begin
                pending_write_response_count <= next_pending_write_response_count;
            end
        end
        
        assign write_response_count_is_1  = (pending_write_response_count == 1);
        // assertion
        ERROR_WRITE_ISSUING_CAPABILITY_equal_1_but_master_sends_more_commands_or_switch_slave_before_response_back_please_visit_the_parameter:
            assert property (@(posedge aclk)
                disable iff (!aresetn) !(write_response_count_is_1 && write_cmd_accepted));
    end // if (WRITE_ISSUING_CAPABILITY == 1)
        
    if (READ_ISSUING_CAPABILITY == 1) begin
        wire read_cmd_accepted;
        wire read_response_accepted;
        wire read_response_count_is_1;
    
        reg [log2ceil(READ_ISSUING_CAPABILITY+1)-1:0]  pending_read_response_count;
        reg [log2ceil(READ_ISSUING_CAPABILITY+1)-1:0]  next_pending_read_response_count;
    
        assign read_cmd_accepted = aligned_ar_valid && read_cp_endofpacket;
        assign read_response_accepted = read_rp_valid && read_rp_ready && read_rp_endofpacket;
    
        always_comb begin
            next_pending_read_response_count   = pending_read_response_count;
            if (read_cmd_accepted)
                next_pending_read_response_count  = pending_read_response_count + 1'b1;
            if (read_response_accepted)
                next_pending_read_response_count  = pending_read_response_count - 1'b1;
            if (read_cmd_accepted && read_response_accepted)
                next_pending_read_response_count  = pending_read_response_count;
        end

        always_ff @(posedge aclk) begin
            if (!aresetn) begin
                pending_read_response_count  <= '0;
            end else begin
                pending_read_response_count  <= next_pending_read_response_count;
            end
        end

        assign read_response_count_is_1 = (pending_read_response_count == 1);
        ERROR_READ_ISSUING_CAPABILITY_equal_1_but_master_sends_more_commands_or_switch_slave_before_response_back_please_visit_the_parameter:
            assert property (@(posedge aclk)
                disable iff (!aresetn) !(read_response_count_is_1 && read_cmd_accepted));

    end // if (READ_ISSUING_CAPABILITY == 1)
    endgenerate
    
    ERROR_awlock_reserved_value:
        assert property (@(posedge aclk)
            disable iff (!aresetn) ( !(awvalid && awlock == 2'b11) ));

    ERROR_arlock_reserved_value:
        assert property (@(posedge aclk)
            disable iff (!aresetn) ( !(arvalid && arlock == 2'b11) ));

// synthesis translate_on
endmodule
