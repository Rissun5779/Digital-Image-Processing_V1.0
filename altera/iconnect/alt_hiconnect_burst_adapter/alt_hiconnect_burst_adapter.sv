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


`timescale 1 ns / 1 ns
`default_nettype none

// -----------------------------------------------------
// Top level for the burst adapter. This first generates an
// incrementing address sequence for write bursts and then
// selects the implementation for the adapter, based on the
// parameterization.
// -----------------------------------------------------
module alt_hiconnect_burst_adapter
#(
    parameter 
    // Indicates the implementation to instantiate:
    //    "new" means the fast, expensive per-burst converter.
    ADAPTER_VERSION             = "new",

    // Indicates if this adapter needs to support read bursts
    // (almost always true).
    COMPRESSED_READ_SUPPORT     = 1,

    // Standard Merlin packet parameters that indicate
    // field position within the packet
    PKT_BEGIN_BURST             = 81,
    PKT_ADDR_H                  = 79,
    PKT_ADDR_L                  = 48,
    PKT_BYTE_CNT_H              = 5,
    PKT_BYTE_CNT_L              = 0,
    PKT_BURSTWRAP_H             = 11,
    PKT_BURSTWRAP_L             = 6,
    PKT_TRANS_COMPRESSED_READ   = 14,
    PKT_TRANS_WRITE             = 13,
    PKT_TRANS_READ              = 12,
    PKT_BYTEEN_H                = 83,
    PKT_BYTEEN_L                = 80,
    PKT_BURST_TYPE_H            = 88,
    PKT_BURST_TYPE_L            = 87,
    PKT_BURST_SIZE_H            = 86,
    PKT_BURST_SIZE_L            = 84,
    ST_DATA_W                   = 89,
    ST_CHANNEL_W                = 8,

    // Component-specific parameters. Explained
    // in the implementation.
    IN_NARROW_SIZE              = 0,
    INCOMPLETE_WRAP_SUPPORT     = 1,
    BURSTWRAP_CONST_MASK        = 0,
    BURSTWRAP_CONST_VALUE       = -1,
                                
    OUT_NARROW_SIZE             = 0,
    OUT_FIXED                   = 0,
    OUT_COMPLETE_WRAP           = 0,
    BYTEENABLE_SYNTHESIS        = 0,
    PIPE_INPUTS                 = 0,
    PIPE_INTERNAL               = 0,
                                
    OUT_BYTE_CNT_H              = 5,
    OUT_BURSTWRAP_H             = 11,
                                
    INCREMENT_ADDRESS           = 1,
    ADDR_HAS_4K_BOUNDARIES      = 0,
    CONVERT_UNCOMP_TRANS        = 1,
    CONVERT_COMP_TRANS          = 1,

    DISABLE_DEFAULT_CONVERTER   = 0,
    DISABLE_WRAP_CONVERTER      = 0,
    DISABLE_INCR_CONVERTER      = 0
)
(
    input wire                    clk,
    input wire                    reset,
                                  
    // -------------------        
    // Command Sink (Input)       
    // -------------------        
    input wire                    sink0_valid,
    input wire [ST_DATA_W-1 : 0]  sink0_data,
    input wire                    sink0_startofpacket,
    input wire                    sink0_endofpacket,
    output reg                    sink0_ready,
                                  
    // -------------------        
    // Command Source (Output)    
    // -------------------        
    output wire                   source0_valid,
    output wire [ST_DATA_W-1 : 0] source0_data,
    output wire                   source0_startofpacket,
    output wire                   source0_endofpacket,
    input wire                    source0_ready
);

    localparam
    NUM_SYMBOLS           = PKT_BYTEEN_H - PKT_BYTEEN_L + 1,
    LOG2_NUM_SYMBOLS      = log2ceil(NUM_SYMBOLS),
    OUT_BYTE_CNT_W        = OUT_BYTE_CNT_H - PKT_BYTE_CNT_L + 1,
    PKT_BURSTWRAP_W       = PKT_BURSTWRAP_H - PKT_BURSTWRAP_L + 1,
    OUT_BURSTWRAP_W       = OUT_BURSTWRAP_H - PKT_BURSTWRAP_L + 1;
    
    // We try to keep everything in terms of words (transfers) instead of
    // bytes in this implementation. Cognitive ease!
    localparam
    OUT_LEN_W             = OUT_BYTE_CNT_W - LOG2_NUM_SYMBOLS,
    MAX_OUT_LEN           = 1 << (OUT_LEN_W - 1);
    
    // Determines the protocol from the features that are enabled or disabled.
    // Should be moved to the code that parameterizes this adapter.
    localparam
    AXI_SLAVE             = OUT_FIXED & OUT_NARROW_SIZE & OUT_COMPLETE_WRAP,
    IS_WRAP_AVALON_SLAVE  = !AXI_SLAVE & (PKT_BURSTWRAP_H != OUT_BURSTWRAP_H),
    IS_INCR_SLAVE         = !AXI_SLAVE & !IS_WRAP_AVALON_SLAVE,
    NON_BURSTING_SLAVE    = (MAX_OUT_LEN == 1),
    // This parameter indicates that the system is purely INCR avalon master/slave
    INCR_AVALON_SYS       = (IS_INCR_SLAVE && (PKT_BURSTWRAP_W == 1) && (OUT_BURSTWRAP_W == 1) && (IN_NARROW_SIZE == 0)),
    ONLY_INCR_CONVERTER   = (DISABLE_DEFAULT_CONVERTER == 1) && (DISABLE_WRAP_CONVERTER == 1) && (DISABLE_INCR_CONVERTER == 0),
    INCR_ONLY_SYS         = INCR_AVALON_SYS || ONLY_INCR_CONVERTER;
    
    // Control the instantiation of the
    // per-burst converters.
    localparam INSTANTIATE_DEFAULT_CONVERTER  = DISABLE_DEFAULT_CONVERTER ? 1'b0 : (!INCR_ONLY_SYS);
    localparam INSTANTIATE_WRAP_CONVERTER     = DISABLE_WRAP_CONVERTER ? 1'b0 : (!NON_BURSTING_SLAVE && !INCR_ONLY_SYS);
    localparam INSTANTIATE_INCR_CONVERTER     = DISABLE_INCR_CONVERTER ? 1'b0 : (!NON_BURSTING_SLAVE && !IS_WRAP_AVALON_SLAVE);
    
    // Parameters to define what kind of logic needs to be built in the address mangler
    localparam IN_FIXED_OR_RESERVED_BURST     = INSTANTIATE_DEFAULT_CONVERTER;  // Need to double check correctness here...
    localparam IN_WRAP_BURST                  = INSTANTIATE_WRAP_CONVERTER || NON_BURSTING_SLAVE;
    localparam IN_INCR_BURST                  = INSTANTIATE_INCR_CONVERTER || (INSTANTIATE_WRAP_CONVERTER && IS_WRAP_AVALON_SLAVE) || NON_BURSTING_SLAVE;

    generate if (COMPRESSED_READ_SUPPORT == 0) begin : altera_hiconnect_burst_adapter_uncompressed_only

        // -------------------------------------------------------------------
        // The reduced version of the adapter is only meant to be used on
        // non-bursting wide to narrow links.
        // -------------------------------------------------------------------
        alt_hiconnect_burst_adapter_uncompressed_only #(
            .PKT_BYTE_CNT_H        (PKT_BYTE_CNT_H),
            .PKT_BYTE_CNT_L        (PKT_BYTE_CNT_L),
            .PKT_BYTEEN_H          (PKT_BYTEEN_H),
            .PKT_BYTEEN_L          (PKT_BYTEEN_L),
            .ST_DATA_W             (ST_DATA_W),
            .ST_CHANNEL_W          (ST_CHANNEL_W)
        ) burst_adapter (
            .clk                   (clk),
            .reset                 (reset),
            .sink0_valid           (sink0_valid),
            .sink0_data            (sink0_data),
            .sink0_channel         (),
            .sink0_startofpacket   (sink0_startofpacket),
            .sink0_endofpacket     (sink0_endofpacket),
            .sink0_ready           (sink0_ready),
            .source0_valid         (source0_valid),
            .source0_data          (source0_data),
            .source0_channel       (),
            .source0_startofpacket (source0_startofpacket),
            .source0_endofpacket   (source0_endofpacket),
            .source0_ready         (source0_ready)
        );

    end
    else begin : alt_hiconnect_burst_adapter_new_gen

        wire                          sink0_valid_internal;
        wire [ST_DATA_W-1 : 0]        sink0_data_internal;
        wire                          sink0_startofpacket_internal;
        wire                          sink0_endofpacket_internal;
        wire                          sink0_ready_internal;
        
        wire                          sink0_valid_mangled;
        wire [ST_DATA_W-1 : 0]        sink0_data_mangled;
        wire                          sink0_startofpacket_mangled;
        wire                          sink0_endofpacket_mangled;
        wire                          sink0_ready_mangled;
    
        // --------------------------------------------------------------------------------------------
        // Address incrementing logic to satisfy the Merlin packet format specification -- that the
        // packet address is accurate on every cycle of an uncompressed transaction.
        // --------------------------------------------------------------------------------------------
        if(INCREMENT_ADDRESS == 1) begin : address_increment
            
            alt_hiconnect_addr_mangler #(
                .PKT_ADDR_H                    (PKT_ADDR_H),
                .PKT_ADDR_L                    (PKT_ADDR_L),
                .PKT_BURSTWRAP_H               (PKT_BURSTWRAP_H),
                .PKT_BURSTWRAP_L               (PKT_BURSTWRAP_L),
                .PKT_BURST_TYPE_H              (PKT_BURST_TYPE_H),
                .PKT_BURST_TYPE_L              (PKT_BURST_TYPE_L),
                .PKT_BURST_SIZE_H              (PKT_BURST_SIZE_H),
                .PKT_BURST_SIZE_L              (PKT_BURST_SIZE_L),
                .PKT_BYTEEN_H                  (PKT_BYTEEN_H),
                .PKT_BYTEEN_L                  (PKT_BYTEEN_L),
                .ST_DATA_W                     (ST_DATA_W),
                .ST_CHANNEL_W                  (ST_CHANNEL_W),
                .INCREMENT_ADDRESS             (1),
                .ADDR_HAS_4K_BOUNDARIES        (ADDR_HAS_4K_BOUNDARIES),
                .IN_FIXED_OR_RESERVED_BURST    (IN_FIXED_OR_RESERVED_BURST),
                .IN_WRAP_BURST                 (IN_WRAP_BURST),
                .IN_INCR_BURST                 (IN_INCR_BURST)
            ) address_mangler (
                .clk(clk),
                .reset(reset),
                .sink_valid(sink0_valid),
                .sink_data(sink0_data),
                .sink_channel(),
                .sink_startofpacket(sink0_startofpacket),
                .sink_endofpacket(sink0_endofpacket),
                .sink_ready(sink0_ready_mangled),
                .src_valid(sink0_valid_mangled),
                .src_data(sink0_data_mangled),
                .src_channel(),
                .src_startofpacket(sink0_startofpacket_mangled),
                .src_endofpacket(sink0_endofpacket_mangled),
                .src_ready(sink0_ready_internal)
            );
            
            assign sink0_valid_internal = sink0_valid_mangled;
            assign sink0_data_internal = sink0_data_mangled;
            assign sink0_startofpacket_internal = sink0_startofpacket_mangled;
            assign sink0_endofpacket_internal = sink0_endofpacket_mangled;
            assign sink0_ready = sink0_ready_mangled;
            
        end
        else begin : no_address_increment
        
            assign sink0_valid_internal = sink0_valid;
            assign sink0_data_internal = sink0_data;
            assign sink0_startofpacket_internal = sink0_startofpacket;
            assign sink0_endofpacket_internal = sink0_endofpacket;
            assign sink0_ready = sink0_ready_internal;
            
        end
    
        // -----------------------------------------------------
        // This is the per-burst-type converter implementation. This attempts
        // to convert bursts with specialized functions for each burst
        // type. This typically results in higher area, but higher fmax.
        // -----------------------------------------------------
        alt_hiconnect_burst_adapter_new #(
            .PKT_BEGIN_BURST               (PKT_BEGIN_BURST),
            .PKT_ADDR_H                    (PKT_ADDR_H ),
            .PKT_ADDR_L                    (PKT_ADDR_L),
            .PKT_BYTE_CNT_H                (PKT_BYTE_CNT_H),
            .PKT_BYTE_CNT_L                (PKT_BYTE_CNT_L ),
            .PKT_BURSTWRAP_H               (PKT_BURSTWRAP_H),
            .PKT_BURSTWRAP_L               (PKT_BURSTWRAP_L),
            .PKT_TRANS_COMPRESSED_READ     (PKT_TRANS_COMPRESSED_READ),
            .PKT_TRANS_WRITE               (PKT_TRANS_WRITE),
            .PKT_TRANS_READ                (PKT_TRANS_READ),
            .PKT_BYTEEN_H                  (PKT_BYTEEN_H),
            .PKT_BYTEEN_L                  (PKT_BYTEEN_L),
            .PKT_BURST_TYPE_H              (PKT_BURST_TYPE_H),
            .PKT_BURST_TYPE_L              (PKT_BURST_TYPE_L),
            .PKT_BURST_SIZE_H              (PKT_BURST_SIZE_H),
            .PKT_BURST_SIZE_L              (PKT_BURST_SIZE_L),
            .IN_NARROW_SIZE                (IN_NARROW_SIZE),
            .BYTEENABLE_SYNTHESIS          (BYTEENABLE_SYNTHESIS),
            .OUT_NARROW_SIZE               (OUT_NARROW_SIZE),
            .OUT_FIXED                     (OUT_FIXED),
            .OUT_COMPLETE_WRAP             (OUT_COMPLETE_WRAP),
            .ST_DATA_W                     (ST_DATA_W),
            .ST_CHANNEL_W                  (ST_CHANNEL_W),
            .BURSTWRAP_CONST_MASK          (BURSTWRAP_CONST_MASK),
            .BURSTWRAP_CONST_VALUE         (BURSTWRAP_CONST_VALUE),
            .INCOMPLETE_WRAP_SUPPORT       (INCOMPLETE_WRAP_SUPPORT),
            .PIPE_INPUTS                   (PIPE_INPUTS),
            .PIPE_INTERNAL                 (PIPE_INTERNAL),
            .AXI_SLAVE                     (AXI_SLAVE),
            .IS_WRAP_AVALON_SLAVE          (IS_WRAP_AVALON_SLAVE),
            .IS_INCR_SLAVE                 (IS_INCR_SLAVE),
            .NON_BURSTING_SLAVE            (NON_BURSTING_SLAVE),
            .INCR_ONLY_SYS                 (INCR_ONLY_SYS),
            .INCR_AVALON_SYS               (INCR_AVALON_SYS),
            .OUT_BYTE_CNT_H                (OUT_BYTE_CNT_H),
            .OUT_BURSTWRAP_H               (OUT_BURSTWRAP_H),
            .ADDR_HAS_4K_BOUNDARIES        (ADDR_HAS_4K_BOUNDARIES),
            .CONVERT_UNCOMP_TRANS          (CONVERT_UNCOMP_TRANS),
            .CONVERT_COMP_TRANS            (CONVERT_COMP_TRANS),
            .INSTANTIATE_DEFAULT_CONVERTER (INSTANTIATE_DEFAULT_CONVERTER),
            .INSTANTIATE_WRAP_CONVERTER    (INSTANTIATE_WRAP_CONVERTER),
            .INSTANTIATE_INCR_CONVERTER    (INSTANTIATE_INCR_CONVERTER)
        ) burst_adapter (
            .clk                   (clk),
            .reset                 (reset),
            .sink0_valid           (sink0_valid_internal),
            .sink0_data            (sink0_data_internal),
            .sink0_channel         (),
            .sink0_startofpacket   (sink0_startofpacket_internal),
            .sink0_endofpacket     (sink0_endofpacket_internal),
            .sink0_ready           (sink0_ready_internal),
            .source0_valid         (source0_valid),
            .source0_data          (source0_data),
            .source0_channel       (),
            .source0_startofpacket (source0_startofpacket),
            .source0_endofpacket   (source0_endofpacket),
            .source0_ready         (source0_ready)
        );

    end 
    endgenerate
    
    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function unsigned[63:0] log2ceil;
        input reg [63:0] val;
        reg [63:0]       i;
        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

    // synthesis translate_off
     
    // -----------------------------------------------------
    // Simulation-only check for incoming burstwrap values inconsistent with 
    // BURSTWRAP_CONST_MASK, which would indicate a paramerization error. 
    //
    // Should be turned into an assertion, really.
    // -----------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (~reset && sink0_valid &&
          BURSTWRAP_CONST_MASK[PKT_BURSTWRAP_W - 1:0] &
          (BURSTWRAP_CONST_VALUE[PKT_BURSTWRAP_W - 1:0] ^ sink0_data[PKT_BURSTWRAP_H : PKT_BURSTWRAP_L])
        ) begin
            $display("%t: %m: Error: burstwrap value %X is inconsistent with BURSTWRAP_CONST_MASK value %X", $time(), sink0_data[PKT_BURSTWRAP_H : PKT_BURSTWRAP_L], BURSTWRAP_CONST_MASK[PKT_BURSTWRAP_W - 1:0]);
        end
    end

    // synthesis translate_on

endmodule

`default_nettype wire
