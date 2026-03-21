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


// $Id: //acds/prototype/mm_s10/ip/merlin/altera_merlin_burst_adapter/new_source/altera_wrap_burst_converter.sv#2 $
// $Revision: #2 $
// $Date: 2015/06/11 $
// $Author: nkrueger $

// ------------------------------------------------------
// This component is specially for Wrapping Avalon slave.
// It converts burst length of input packet
// to match slave burst.
// ------------------------------------------------------

`timescale 1 ns / 1 ns
`default_nettype none

module alt_wrap_burst_converter
#(
  parameter
    // ----------------------------------------
    // Burst length Parameters
    // (real burst length value, not bytecount)
    // ----------------------------------------
    MAX_IN_LEN              = 16,
    MAX_OUT_LEN             = 4,
    ADDR_WIDTH              = 12,
    BNDRY_WIDTH             = 12,
    NUM_SYMBOLS             = 4,
    OPTIMIZE_WRITE_BURST    = 0,
    ADDR_HAS_4K_BOUNDARIES  = 0,
    
    // Will this converter process only uncompressed write bursts?
    // Optimization for preventing generation of unused logic in
    // the AXI slave case.
    CONVERT_UNCOMP_TRANS  = 1,
    CONVERT_COMP_TRANS    = 1,
    
    // ------------------
    // Derived Parameters
    // ------------------
    LEN_WIDTH       = log2ceil(MAX_IN_LEN) + 1,
    OUT_LEN_WIDTH   = log2ceil(MAX_OUT_LEN) + 1,
    LOG2_NUMSYMBOLS = log2ceil(NUM_SYMBOLS)
)
(
    input wire                           clk,
    input wire                           reset,
    input wire                           enable_uncompressed,
    input wire                           enable_compressed,

    input wire [LEN_WIDTH   - 1 : 0]     in_len,
    input wire [LEN_WIDTH   - 1 : 0]     first_len,
    input wire                           in_sop,

    input wire [ADDR_WIDTH  - 1 : 0]     in_addr,
    input wire [ADDR_WIDTH  - 1 : 0]     in_addr_reg,
    input wire [BNDRY_WIDTH - 1 : 0]     in_boundary,
    input wire [BNDRY_WIDTH - 1 : 0]     in_burstwrap,
    input wire [BNDRY_WIDTH - 1 : 0]     in_burstwrap_reg,

    // converted output length
    // out_len         : compressed burst, read
    // uncompressed_len: uncompressed, write
    output reg [LEN_WIDTH - 1 : 0]  out_len,
    output reg [LEN_WIDTH - 1 : 0]  uncompr_out_len,

    // Compressed address output
    output reg [ADDR_WIDTH - 1 : 0] out_addr,
    output reg                      new_burst_export
);

    // ------------------------------
    // Local parameters
    // ------------------------------
    localparam
        OUT_BOUNDARY        = MAX_OUT_LEN * NUM_SYMBOLS,
        ADDR_SEL            = log2ceil(OUT_BOUNDARY);

    localparam ADDR_LSBS_W = ADDR_HAS_4K_BOUNDARIES ? 12 : ADDR_WIDTH;
    
    // This function returns 0 if (num1 - num2) is negative,
    // otherwise it returns (num1 - num2)
    function integer diff_gt_zero;
        input integer num1;
        input integer num2;

        diff_gt_zero = ((num1 - num2) > 0) ? (num1 - num2) : 0;
    endfunction

    // ----------------------------------------
    // Signals for wrapping support
    // ----------------------------------------
    reg [LEN_WIDTH - 1 : 0]        remaining_len;
    reg [LEN_WIDTH - 1 : 0]        next_out_len;
    reg [LEN_WIDTH - 1 : 0]        next_rem_len;
    reg [LEN_WIDTH - 1 : 0]        uncompr_remaining_len;
    reg                            new_burst;
    reg                            uncompr_sub_burst;
    reg [LEN_WIDTH - 1 : 0]        next_uncompr_out_len;
    reg [LEN_WIDTH - 1 : 0]        next_uncompr_sub_len;

    // Avoid QIS warning
    wire [OUT_LEN_WIDTH - 1 : 0]   max_out_length;
    assign max_out_length  = MAX_OUT_LEN[OUT_LEN_WIDTH - 1 : 0];

    // ----------------------------------------
    // Calculate aligned length for WRAP burst
    // ----------------------------------------
    reg [ADDR_LSBS_W - 1 : 0]       extended_burstwrap;
    reg [ADDR_LSBS_W - 1 : 0]       extended_burstwrap_reg;

    always_comb begin
        extended_burstwrap      = {{diff_gt_zero(ADDR_LSBS_W, BNDRY_WIDTH) {in_burstwrap[BNDRY_WIDTH - 1]}}, in_burstwrap};
        extended_burstwrap_reg  = {{diff_gt_zero(ADDR_LSBS_W, BNDRY_WIDTH) {in_burstwrap_reg[BNDRY_WIDTH - 1]}}, in_burstwrap_reg};
        new_burst_export        = new_burst;
    end

    // Synchronous reset
    reg internal_sclr;
   
    always @(posedge clk) begin
        internal_sclr <= reset;
    end

    // compressed transactions
    generate
        if(CONVERT_COMP_TRANS) begin : cmp_read_logic
            always_comb begin : proc_compressed_read
                remaining_len  = in_len;
                if (!new_burst)
                    remaining_len = next_rem_len;
            end
            
            // Compressed transaction: Always try to send MAX out_len then remaining length.
            // Separate it as the main difference is the first out len.
            // For a WRAP burst, the first beat is the aligned length, then similar to INCR.
            always_comb begin
                if (new_burst) begin
                    next_out_len = first_len;
                end
                else begin
                    next_out_len = max_out_length;
                    if (remaining_len < max_out_length) begin
                        next_out_len = remaining_len;
                    end
                end
            end // always_comb
            
            // --------------------------------------------------
            // Length remaining calculation : Compressed
            // --------------------------------------------------
            // length remaining for compressed transaction
            // for wrap, need special handling for first out length

            always_ff @(posedge clk) begin
                if (internal_sclr)
                    next_rem_len <= 0;
                else if (enable_compressed) begin
                    if (new_burst)
                        next_rem_len <= in_len - first_len;
                    else
                        next_rem_len <= next_rem_len - max_out_length;
                end
            end // always_ff @
                    
            // --------------------------------------------------
            // Output length
            // --------------------------------------------------
            // register out_len for compressed trans
            always_ff @(posedge clk) begin
                if (internal_sclr) begin
                    out_len <= 0;
                end
                else if (enable_compressed) begin
                    out_len <= next_out_len;
                end
            end
            
            // --------------------------------------------------
            // Address calculation
            // --------------------------------------------------
            reg [ADDR_LSBS_W - 1 : 0] addr_incr;
            localparam [ADDR_LSBS_W - 1 : 0] ADDR_INCR = MAX_OUT_LEN << LOG2_NUMSYMBOLS;
            assign addr_incr  = ADDR_INCR[ADDR_LSBS_W - 1 : 0];

            reg [ADDR_LSBS_W - 1 : 0]    next_out_addr;
            reg [ADDR_LSBS_W - 1 : 0]    incremented_addr;

            // 4K boundary optimization -- only use 12-bit address incrementing logic
            if (ADDR_HAS_4K_BOUNDARIES == 1) begin : use_4k_addr_reg
                always_ff @(posedge clk) begin
                    if (enable_compressed) begin
                        out_addr <= {(new_burst ? in_addr[ADDR_WIDTH-1 : ADDR_LSBS_W] : in_addr_reg[ADDR_WIDTH-1 : ADDR_LSBS_W]), next_out_addr};
                    end
                end // always_ff @
            end else begin : use_full_addr_reg
                always_ff @(posedge clk) begin
                    if (enable_compressed) begin
                        out_addr <= next_out_addr;
                    end
                end // always_ff @
            end

            // use burstwrap/burstwrap_reg to calculate address incrementing
            always_ff @(posedge clk) begin
                if (internal_sclr) begin
                    incremented_addr <= '0;
                end
                else if (enable_compressed) begin
                    incremented_addr <= ((next_out_addr + addr_incr) & extended_burstwrap_reg);
                    if (new_burst) begin
                        incremented_addr <= ((next_out_addr + (first_len << LOG2_NUMSYMBOLS)) & extended_burstwrap); //byte address
                    end
                end
            end // always_ff @

            always_comb begin
                next_out_addr  = in_addr[ADDR_LSBS_W-1 : 0];
                if (!new_burst) begin
                    next_out_addr = in_addr_reg[ADDR_LSBS_W-1 : 0] & ~extended_burstwrap_reg | incremented_addr;
                end
            end
            
            // --------------------------------------------------
            // Control signals
            // --------------------------------------------------
            wire end_compressed_sub_burst;
            assign end_compressed_sub_burst = (remaining_len == next_out_len);

            // new_burst:
            //  the converter takes in_len for new calculation
            always_ff @(posedge clk) begin
                if (internal_sclr) begin
                    new_burst <= 1;
                end
                else if (enable_compressed) begin
                    new_burst <= end_compressed_sub_burst;
                end
            end 
        end
    endgenerate
    
    // uncompressed transactions
    generate
        if(CONVERT_UNCOMP_TRANS) begin : ucmp_trans_logic
            // -------------------------------------------
            // length calculation
            // -------------------------------------------
            reg [LEN_WIDTH -1 : 0] next_uncompr_remaining_len;
            always_comb begin
                // Signals name
                // *_uncompr_* --> uncompressed transaction
                // -------------------------------------------
                // Always use max_out_length as possible.
                // Else use the remaining length.
                // If in length smaller and not cross boundary or same, pass thru.

                if (in_sop) begin
                    uncompr_remaining_len = in_len;
                end
                else begin
                    uncompr_remaining_len = next_uncompr_remaining_len;
                end
            end // always_comb
        
            always_comb begin
                next_uncompr_out_len = first_len;
                if (in_sop) begin
                    next_uncompr_out_len = first_len;
                end
                else begin
                    if (uncompr_sub_burst)
                        next_uncompr_out_len = next_uncompr_sub_len;
                    else begin
                        if (uncompr_remaining_len < max_out_length)
                            next_uncompr_out_len = uncompr_remaining_len;
                        else
                            next_uncompr_out_len = max_out_length;
                    end
                end
            end
            
            // --------------------------------------------------
            // Length remaining calculation : Uncompressed
            // --------------------------------------------------
            always_ff @(posedge clk) begin
                if (internal_sclr) begin
                    next_uncompr_remaining_len <= 0;
                end
                else if (enable_uncompressed) begin
                    if (in_sop)
                        next_uncompr_remaining_len <= in_len - first_len;
                    else if (!uncompr_sub_burst)
                        next_uncompr_remaining_len <= next_uncompr_remaining_len - max_out_length;
                end
            end // always_ff @

            // length for each sub-burst if it needs to chop the burst
            always_ff @(posedge clk) begin
                if (internal_sclr) begin
                    next_uncompr_sub_len <= 0;
                end
                else if (enable_uncompressed) begin
                    next_uncompr_sub_len <= next_uncompr_out_len - 1'b1; // in term of length, it just reduces 1
                end
            end

            // the sub-burst still active
            always_ff @(posedge clk) begin
                if (internal_sclr) begin
                    uncompr_sub_burst <= 0;
                end
                else if (enable_uncompressed) begin
                    uncompr_sub_burst <= (next_uncompr_out_len > 1'b1);
                end
            end
            
            // register uncompr_out_len for uncompressed trans
            if (OPTIMIZE_WRITE_BURST) begin : optimized_write_burst_len
                always_ff @(posedge clk) begin
                    if (enable_compressed) begin
                        uncompr_out_len <= first_len;
                    end
                end
            end
            else begin : unoptimized_write_burst_len
                always_ff @(posedge clk) begin
                    if (enable_uncompressed) begin
                        uncompr_out_len <= next_uncompr_out_len;
                    end
                end
            end

            // --------------------------------------------------
            // Control signals
            // --------------------------------------------------
            if(!CONVERT_COMP_TRANS) begin : new_burst_uncomp_write_only
                assign new_burst = 1'b1;
            end
        end
    endgenerate

    // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        reg[31:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i[30:0] << 1;
            end
        end
    endfunction

endmodule

`default_nettype wire
