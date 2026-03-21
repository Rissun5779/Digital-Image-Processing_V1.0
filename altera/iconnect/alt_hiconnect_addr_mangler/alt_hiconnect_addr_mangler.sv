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


// $Id: //acds/main/ip/merlin/altera_merlin_axi_master_ni/address_alignment.sv#3 $
// $Revision: #3 $
// $Date: 2012/07/11 $    
// $Author: tgngo $

// -----------------------------------------
// A temporary measure that does the incrementing address
// nonsense for write bursts.
// -----------------------------------------
`timescale 1 ns / 1 ns

module alt_hiconnect_addr_mangler
#( 
    parameter PKT_ADDR_H                   = 73,
              PKT_ADDR_L                   = 42,
              PKT_BURSTWRAP_H              = 79,
              PKT_BURSTWRAP_L              = 77,
              PKT_BURST_TYPE_H             = 86,
              PKT_BURST_TYPE_L             = 85, 
              PKT_BURST_SIZE_H             = 84, 
              PKT_BURST_SIZE_L             = 82,
              PKT_BYTEEN_H                 = 5,
              PKT_BYTEEN_L                 = 2,

              ST_DATA_W                    = 128,
              ST_CHANNEL_W                 = 1,

              INCREMENT_ADDRESS            = 1,
              ADDR_HAS_4K_BOUNDARIES       = 0,
              
              IN_FIXED_OR_RESERVED_BURST   = 1,
              IN_WRAP_BURST                = 1,
              IN_INCR_BURST                = 1
)
(
    input                         clk,
    input                         reset,
                                  
    input                         sink_valid,
    input [ST_DATA_W-1 : 0]       sink_data,
    input [ST_CHANNEL_W-1 : 0]    sink_channel,
    input                         sink_startofpacket,
    input                         sink_endofpacket,
    output reg                    sink_ready,

    output reg                    src_valid,
    output reg [ST_DATA_W-1:0]    src_data,
    output reg [ST_CHANNEL_W-1:0] src_channel,
    output wire                   src_startofpacket,
    output wire                   src_endofpacket,
    input                         src_ready
);

    localparam ADDR_W      = PKT_ADDR_H - PKT_ADDR_L + 1;
    localparam ADDR_LSBS_W = ADDR_HAS_4K_BOUNDARIES ? 12 : ADDR_W;
    localparam BURSTWRAP_W = PKT_BURSTWRAP_H - PKT_BURSTWRAP_L + 1;
    localparam TYPE_W      = PKT_BURST_TYPE_H - PKT_BURST_TYPE_L + 1;
    localparam SIZE_W      = PKT_BURST_SIZE_H - PKT_BURST_SIZE_L + 1;
    localparam NUMSYMBOLS  = PKT_BYTEEN_H - PKT_BYTEEN_L + 1;
    localparam SELECT_BITS = log2(NUMSYMBOLS);
    localparam IN_DATA_W   = ADDR_W + (BURSTWRAP_W-1) + TYPE_W + SIZE_W;
    localparam OUT_DATA_W  = ADDR_W + SELECT_BITS;

    typedef enum bit [1:0] 
    {
        FIXED       = 2'b00,
        INCR        = 2'b01,
        WRAP        = 2'b10,
        RESERVED    = 2'b11
    } AxiBurstType;

    function reg[9:0] bytes_in_transfer;
        input [SIZE_W-1:0] axsize;
        case (axsize)
            4'b0000: bytes_in_transfer = 10'b0000000001;
            4'b0001: bytes_in_transfer = 10'b0000000010;
            4'b0010: bytes_in_transfer = 10'b0000000100;
            4'b0011: bytes_in_transfer = 10'b0000001000;
            4'b0100: bytes_in_transfer = 10'b0000010000;
            4'b0101: bytes_in_transfer = 10'b0000100000;
            4'b0110: bytes_in_transfer = 10'b0001000000;
            4'b0111: bytes_in_transfer = 10'b0010000000;
            4'b1000: bytes_in_transfer = 10'b0100000000;
            4'b1001: bytes_in_transfer = 10'b1000000000;
            default: bytes_in_transfer = 10'b0000000001;
        endcase
    endfunction

    AxiBurstType write_burst_type;

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

    function integer log2;
        input integer value;

        value = value - 1;
        for (log2 = 0; value > 0; log2 = log2 + 1)
            value = value >> 1;

    endfunction

    function reg[SELECT_BITS-1:0] get_mask_for_aligning_address;
        input [SIZE_W-1:0] size; // size is AXI-encoded: 001 -> 2 bytes
        
        integer i;
        reg [SELECT_BITS-1:0] mask_address;

        mask_address = '1;
        for (i = 0; i < SELECT_BITS; i=i+1) begin
            if (i < size) begin
                mask_address[i] = 1'b0;
            end 
        end
        get_mask_for_aligning_address = mask_address;
    endfunction

    // This function returns 0 if (num1 - num2) is negative,
    // otherwise it returns (num1 - num2)
    function integer diff_gt_zero;
        input integer num1;
        input integer num2;

        diff_gt_zero = ((num1 - num2) > 0) ? (num1 - num2) : 0;
    endfunction

    wire [ADDR_W-1 : 0]      in_address;
    wire [SIZE_W-1 : 0]      in_size;
    reg  [SELECT_BITS-1 : 0] address_mask;
    reg  [ADDR_W-1 : 0]      first_address_aligned;

    assign in_address = sink_data[PKT_ADDR_H : PKT_ADDR_L];
    assign in_size    = sink_data[PKT_BURST_SIZE_H : PKT_BURST_SIZE_L];
    
    always_comb begin
        address_mask = get_mask_for_aligning_address(in_size);
    end
    
    generate
        // SELECT_BITS == 0: input packet has 1 symbol, it is aligned
        if (SELECT_BITS == 0)
            assign first_address_aligned = in_address;
        else begin
            // SELECT_BITS == 1: input packet has 2 symbols
            wire [SELECT_BITS-1 : 0] aligned_address_bits;
            if (SELECT_BITS == 1)
                assign aligned_address_bits = in_address[0] & address_mask[0];
            else
                assign aligned_address_bits = in_address[SELECT_BITS-1:0] & address_mask[SELECT_BITS-1:0];
            assign first_address_aligned = {in_address[ADDR_W-1 : SELECT_BITS], aligned_address_bits};
        end
    endgenerate
    
    // Increment address base on size, first address keep the same
    generate if (INCREMENT_ADDRESS) begin
        reg [ADDR_LSBS_W-1 : 0] increment_address;
        reg [ADDR_W-1 : 0] out_aligned_address_burst;
        reg [ADDR_W-1 : 0] address_burst;
        reg [ADDR_LSBS_W-1 : 0] base_address;
        reg [9 : 0]        number_bytes_transfer;
        reg [ADDR_LSBS_W-1 : 0] burstwrap_mask;
        reg [ADDR_LSBS_W-1 : 0] burst_address_high;
        reg [ADDR_LSBS_W-1 : 0] burst_address_low;

        reg [TYPE_W-1 : 0] in_type;
        reg [BURSTWRAP_W-2 :0] in_burstwrap_boundary;
        
        wire [ADDR_LSBS_W-1 : 0] fixed_burst_inc;
        wire [ADDR_LSBS_W-1 : 0] wrap_and_res_burst_inc;
        wire [ADDR_LSBS_W-1 : 0] incr_burst_inc;
        //------------------------------------------------
        // Use the extended burstwrap value to split the high (constant) and
        // low (changing) part of the address
        //-----------------------------------------------
        assign in_type               = sink_data[PKT_BURST_TYPE_H : PKT_BURST_TYPE_L];
        assign in_burstwrap_boundary = sink_data[PKT_BURSTWRAP_H : PKT_BURSTWRAP_L];
        assign burstwrap_mask        = {{diff_gt_zero(ADDR_LSBS_W, BURSTWRAP_W){1'b0}}, in_burstwrap_boundary};
        assign burst_address_high    = out_aligned_address_burst[ADDR_LSBS_W-1 : 0] & ~burstwrap_mask;
        assign burst_address_low     = out_aligned_address_burst[ADDR_LSBS_W-1 : 0];
        assign number_bytes_transfer = bytes_in_transfer(in_size);
        assign write_burst_type      = burst_type_decode(in_type);

        always_comb begin
            if (sink_startofpacket) begin
                out_aligned_address_burst = in_address;
                base_address = first_address_aligned[ADDR_LSBS_W-1 : 0];
            end else begin
                out_aligned_address_burst = address_burst;
                base_address = out_aligned_address_burst[ADDR_LSBS_W-1 : 0];
            end
        end
        
        // Only FIXED uses this
        if (IN_FIXED_OR_RESERVED_BURST == 1) begin
            assign fixed_burst_inc = out_aligned_address_burst;
        end
        // RESERVED and WRAP both use this calculation
        if ((IN_WRAP_BURST == 1) || (IN_FIXED_OR_RESERVED_BURST == 1)) begin
            assign wrap_and_res_burst_inc = ((burst_address_low + number_bytes_transfer) & burstwrap_mask) | burst_address_high;
        end
        // Only INCR uses this caclulation
        if (IN_INCR_BURST == 1) begin
            assign incr_burst_inc = base_address + number_bytes_transfer;
        end
        
        // Don't build a mux if we don't need one!
        if(IN_FIXED_OR_RESERVED_BURST == 0 && IN_WRAP_BURST == 0) begin : incr_only_addr_mux
            assign increment_address = incr_burst_inc;
        end else begin
            always_comb begin
                case (write_burst_type)
                    INCR:
                        increment_address = incr_burst_inc;
                    WRAP:
                        increment_address = wrap_and_res_burst_inc;
                    FIXED:
                        increment_address = fixed_burst_inc;
                    RESERVED:
                        increment_address = wrap_and_res_burst_inc;
                    default:
                        increment_address = incr_burst_inc;
                endcase // case (write_burst_type)
            end // always_comb
        end
        
        // 4K boundary optimization -- only use 12-bit address incrementing logic
        if (ADDR_HAS_4K_BOUNDARIES) begin : four_k_addr_incr_reg
            always_ff @(posedge clk) begin
                if (sink_valid & src_ready)
                    address_burst <= {in_address[ADDR_W-1 : ADDR_LSBS_W], increment_address};
            end
        end else begin : full_addr_incr_reg
            always_ff @(posedge clk) begin
                if (sink_valid & src_ready)
                    address_burst <= increment_address;
            end
        end

        always_comb begin
            src_data = sink_data;
            src_data[PKT_ADDR_H : PKT_ADDR_L] = out_aligned_address_burst;
        end

    end // if (INCREMENT_ADDRESS)
    else begin

        always_comb begin
            src_data = sink_data;
            src_data[PKT_ADDR_H : PKT_ADDR_L] = first_address_aligned;
        end

    end // else: !if(INCREMENT_ADDRESS)
        
    endgenerate

    always_comb begin
        src_valid   = sink_valid;
        src_channel = sink_channel;
        sink_ready  = src_ready;
    end

    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket = sink_endofpacket;

endmodule
