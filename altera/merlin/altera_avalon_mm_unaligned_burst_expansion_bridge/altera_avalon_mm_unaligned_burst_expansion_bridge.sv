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


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

`timescale 1 ns / 1 ns
module altera_avalon_mm_unaligned_burst_expansion_bridge
#(
    parameter DATA_WIDTH                    = 32,
    parameter ADDRESS_WIDTH                 = 29,
    parameter BURSTCOUNT_WIDTH              = 7,
    parameter MAX_PENDING_RESPONSES         = 8,
    parameter RATIO                         = 2,
    parameter PIPELINE_COMMAND              = 1,
    // --------------------------------------
    // Derived parameters
    // --------------------------------------
    parameter BYTEEN_WIDTH = DATA_WIDTH / 8,
    parameter OUT_BURSTCOUNT_WIDTH  = ((2**(BURSTCOUNT_WIDTH-1)) > RATIO) ? BURSTCOUNT_WIDTH + 1: log2(2*RATIO)+1
)
(
    input                               clk,
    input                               reset,

    output                              s0_waitrequest,
    output [DATA_WIDTH-1:0]             s0_readdata,
    output                              s0_readdatavalid,
    input  [BURSTCOUNT_WIDTH-1:0]       s0_burstcount,
    input  [DATA_WIDTH-1:0]             s0_writedata,
    input  [ADDRESS_WIDTH-1:0]          s0_address, 
    input                               s0_write,  
    input                               s0_read,  
    input  [BYTEEN_WIDTH-1:0]           s0_byteenable,  
    input                               s0_debugaccess,

    input                               m0_waitrequest,
    input  [DATA_WIDTH-1:0]             m0_readdata,
    input                               m0_readdatavalid,
    output [OUT_BURSTCOUNT_WIDTH-1:0]   m0_burstcount,
    output [DATA_WIDTH-1:0]             m0_writedata,
    output [ADDRESS_WIDTH-1:0]          m0_address, 
    output                              m0_write,  
    output                              m0_read,  
    output [BYTEEN_WIDTH-1:0]           m0_byteenable,
    output                              m0_debugaccess
);
    localparam COUNTER_WIDTH = log2(RATIO);
    
    typedef enum reg [3:0]
    {
        EMPTY       = 4'b0001,
        PRE_COUNT   = 4'b0010,
        BURST_COUNT = 4'b0100,
        POST_COUNT  = 4'b1000
        
    } state_e;
    
    state_e current_state;
    state_e next_state;
    
    function integer log2;
        input integer value;
        
        value = value - 1;        
        for(log2 = 0; value > 0; log2 = log2 + 1)
            value = value >> 1;
        
    endfunction
    
    // --------------------------------------
    // Registers & signals
    // --------------------------------------   
    wire [ADDRESS_WIDTH-1:0]        aligned_address;
    wire [COUNTER_WIDTH-1:0]        pre_count_value;    
    wire [BURSTCOUNT_WIDTH-1:0]     burst_count_value;
    
    reg                             rsp_readdatavalid;
    reg [DATA_WIDTH-1:0]            rsp_readdata;                             
    reg [COUNTER_WIDTH-1:0]         cmd_pre_count;
    reg [OUT_BURSTCOUNT_WIDTH-1:0]  aligned_burst_count;
    reg [COUNTER_WIDTH-1:0]         post_count_counter;
    reg [COUNTER_WIDTH-1:0]         next_post_count_counter;
    reg [OUT_BURSTCOUNT_WIDTH-1:0]  current_counter;
    reg [OUT_BURSTCOUNT_WIDTH-1:0]  next_counter;
        
    // Wires connect to FIFO
    wire fifo_out_valid;
    wire fifo_in_valid;
    wire fifo_ready;
    reg  next_pop_fifo;
    wire [BURSTCOUNT_WIDTH+COUNTER_WIDTH-1:0] fifo_out_data;
    wire [BURSTCOUNT_WIDTH+COUNTER_WIDTH-1:0] fifo_in_data;
        
    assign fifo_in_data = {s0_burstcount, cmd_pre_count};
    assign fifo_in_valid = !s0_waitrequest && s0_read;
    
    assign pre_count_value = fifo_out_data[COUNTER_WIDTH-1:0]; 
    assign burst_count_value = fifo_out_data[BURSTCOUNT_WIDTH+COUNTER_WIDTH-1:COUNTER_WIDTH];
        
    // synthesis translate_off
    ERROR_read_transaction_occurs_when_fifo_is_full:
    assert property ( @(posedge clk)
        disable iff (reset) !fifo_ready && s0_read |-> s0_waitrequest
    );
    // synthesis translate_on
    
    altera_avalon_sc_fifo 
        #(
        .SYMBOLS_PER_BEAT    (1),
        .BITS_PER_SYMBOL     (BURSTCOUNT_WIDTH+COUNTER_WIDTH),
        .FIFO_DEPTH          (MAX_PENDING_RESPONSES),
        .CHANNEL_WIDTH       (0),
        .ERROR_WIDTH         (0),
        .USE_PACKETS         (0),
        .USE_FILL_LEVEL      (0),
        .EMPTY_LATENCY       (1),
        .USE_MEMORY_BLOCKS   (0),
        .USE_STORE_FORWARD   (0),
        .USE_ALMOST_FULL_IF  (0),
        .USE_ALMOST_EMPTY_IF (0)
        ) state_fifo 
        (
        .clk               (clk),
        .reset             (reset),
        .in_data           (fifo_in_data),
        .in_valid          (fifo_in_valid),
        .in_ready          (fifo_ready),   // use this as full signal   
        .out_data          (fifo_out_data),
        .out_valid         (fifo_out_valid),
        .out_ready         (next_pop_fifo),
        .csr_address       (2'b00),                                // (terminated)
        .csr_read          (1'b0),                                 // (terminated)
        .csr_write         (1'b0),                                 // (terminated)
        .csr_readdata      (),                                     // (terminated)
        .csr_writedata     (32'b00000000000000000000000000000000), // (terminated)
        .almost_full_data  (),                                     // (terminated)
        .almost_empty_data (),                                     // (terminated)
        .in_startofpacket  (1'b0),                                 // (terminated)
        .in_endofpacket    (1'b0),                                 // (terminated)
        .out_startofpacket (),                                     // (terminated)
        .out_endofpacket   (),                                     // (terminated)
        .in_empty          (1'b0),                                 // (terminated)
        .out_empty         (),                                     // (terminated)
        .in_error          (1'b0),                                 // (terminated)
        .out_error         (),                                     // (terminated)
        .in_channel        (1'b0),                                 // (terminated)
        .out_channel       ()                                      // (terminated)
        );
            
    // --------------------------------------
    // Command pipeline
    //
    // Registers all command signals, including waitrequest
    // --------------------------------------
    generate if (PIPELINE_COMMAND == 1) begin
        reg [OUT_BURSTCOUNT_WIDTH-1:0]  cmd_burstcount;
        reg [DATA_WIDTH-1:0]            cmd_writedata;
        reg [ADDRESS_WIDTH-1:0]         cmd_address; 
        reg                             cmd_write;  
        reg                             cmd_read;  
        reg [BYTEEN_WIDTH-1:0]          cmd_byteenable;
        wire                            cmd_waitrequest;
        reg                             cmd_debugaccess;
        
        reg [OUT_BURSTCOUNT_WIDTH-1:0]  wr_burstcount;
        reg [DATA_WIDTH-1:0]            wr_writedata;
        reg [ADDRESS_WIDTH-1:0]         wr_address; 
        reg                             wr_write;  
        reg                             wr_read;  
        reg [BYTEEN_WIDTH-1:0]          wr_byteenable;
        reg                             wr_debugaccess;
        reg [OUT_BURSTCOUNT_WIDTH-1:0]  reg_burstcount;
        reg [DATA_WIDTH-1:0]            reg_writedata;
        reg [ADDRESS_WIDTH-1:0]         reg_address; 
        reg                             reg_write;  
        reg                             reg_read;  
        reg [BYTEEN_WIDTH-1:0]          reg_byteenable;
        reg                             reg_waitrequest;
        reg                             reg_debugaccess;
    
        reg                             use_reg;
        wire                            wait_rise;
        
        // --------------------------------------
        // Waitrequest Pipeline Stage
        //
        // Output waitrequest is delayed by one cycle, which means
        // that a master will see waitrequest assertions one cycle 
        // too late.
        //
        // Buffer the command when waitrequest transitions
        // from low->high.
        // --------------------------------------
        assign s0_waitrequest = (!fifo_ready && s0_read)? 1'b1 : reg_waitrequest;
        assign wait_rise      = ~reg_waitrequest & cmd_waitrequest;
        
        always @(posedge clk, posedge reset) begin
            if (reset) begin
                reg_waitrequest  <= 1'b1;
                use_reg             <= 1'b1;
                reg_burstcount   <= 1'b1;
                reg_writedata    <= {DATA_WIDTH{1'b0}};
                reg_byteenable   <= {BYTEEN_WIDTH{1'b1}};
                reg_address      <= {ADDRESS_WIDTH{1'b0}};
                reg_write        <= 1'b0;
                reg_read         <= 1'b0;
                reg_debugaccess  <= 1'b0;
            end else begin
                reg_waitrequest  <= cmd_waitrequest;
                // --------------------------------------
                // On the first cycle after reset, the pass-through
                // must not be used or downstream logic may sample
                // the same command twice because of the delay in
                // transmitting a falling waitrequest.
                //
                // Using the registered command works on the condition
                // that downstream logic deasserts waitrequest
                // immediately after reset, which is true of the 
                // next stage in this bridge.
                // --------------------------------------
                
                if (wait_rise) begin
                    reg_writedata    <= s0_writedata;
                    reg_byteenable   <= s0_byteenable;
                    reg_address      <= (s0_read)? aligned_address : s0_address;
                    reg_write        <= s0_write;
                    reg_read         <= (fifo_ready)? s0_read : 1'b0;
                    reg_burstcount   <= (s0_read)? aligned_burst_count : s0_burstcount;
                    reg_debugaccess  <= s0_debugaccess;
                end
    
                // stop using the buffer when waitrequest is low
                if (~cmd_waitrequest)
                    use_reg <= 1'b0;
                else if (wait_rise) begin
                    use_reg <= 1'b1;
                end     
            end
        end
        
        always_comb begin
            wr_burstcount  =  (s0_read)? aligned_burst_count : s0_burstcount;
            wr_writedata   =  s0_writedata;
            wr_address     =  (s0_read)? aligned_address : s0_address;
            wr_write       =  s0_write;
            wr_read        =  (fifo_ready)? s0_read : 1'b0;
            wr_byteenable  =  s0_byteenable;
            wr_debugaccess =  s0_debugaccess;
        
            if (use_reg) begin
                wr_burstcount  =  reg_burstcount;
                wr_writedata   =  reg_writedata;
                wr_address     =  reg_address;
                wr_write       =  reg_write;
                wr_read        =  reg_read;
                wr_byteenable  =  reg_byteenable;
                wr_debugaccess =  reg_debugaccess;
            end
        end
    
        // --------------------------------------
        // Master-Slave Signal Pipeline Stage 
        // --------------------------------------
        wire has_command;
        assign has_command      = (cmd_read || cmd_write);
        assign cmd_waitrequest = m0_waitrequest & has_command;
    
        always @(posedge clk, posedge reset) begin
            if (reset) begin
                cmd_burstcount <= 1'b1;
                cmd_writedata  <= {DATA_WIDTH{1'b0}};
                cmd_byteenable <= {BYTEEN_WIDTH{1'b1}};
                cmd_address    <= {ADDRESS_WIDTH{1'b0}};
                cmd_write      <= 1'b0;
                cmd_read       <= 1'b0;
                cmd_debugaccess <= 1'b0;
            end 
            else begin 
                if (~cmd_waitrequest) begin
                    cmd_writedata  <= wr_writedata;
                    cmd_byteenable <= wr_byteenable;
                    cmd_address    <= wr_address;
                    cmd_write      <= wr_write;
                    cmd_read       <= wr_read;
                    cmd_burstcount <= wr_burstcount;
                    cmd_debugaccess <= wr_debugaccess;
                end
            end
        end
        assign m0_burstcount    = cmd_burstcount;
        assign m0_writedata     = cmd_writedata;
        assign m0_address       = cmd_address;
        assign m0_write         = cmd_write;
        assign m0_read          = cmd_read;
        assign m0_byteenable    = cmd_byteenable;
        assign m0_debugaccess   = cmd_debugaccess;
        
    end else begin
        assign m0_burstcount    = (s0_read)? aligned_burst_count : s0_burstcount;
        assign m0_writedata     = s0_writedata;
        assign m0_address       = (s0_read)? aligned_address : s0_address;
        assign m0_write         = s0_write;
        assign m0_read          = (fifo_ready)? s0_read : 1'b0;
        assign m0_byteenable    = s0_byteenable;
        assign m0_debugaccess   = s0_debugaccess;
        assign s0_waitrequest   = (!fifo_ready && s0_read)? 1'b1 : m0_waitrequest;
    end
    endgenerate
    
    // Example: RATIO = 2
    //  Input transaction   |    Output Transaction
    // =====================|=========================
    //  | - | x |           |     | B | x |
    //  | x | x |           |     | x | x |
    //  | x | x |           |     | x | x |  
    //  | x | - |           |     | x | A |
    //  
    //  input burstcount    = sum(number of x's)
    //  pre_count           = A
    //  post count          = B
    //  output burstcount   = A + B + sum(number of x's)
    //  output address      = aligned to slave 
    
    assign aligned_address = { s0_address[ADDRESS_WIDTH-1:log2(RATIO)], {log2(RATIO){1'b0}} };
    assign cmd_pre_count = s0_address[log2(RATIO)-1:0];
    // --------------------------------------
    // Aligned burst count calculation
    //
    // First, determine how many beats from the slave will be needed: beats=pre_count + s0_burst_count -1
    // Then, determine how many lines from the slave will be needed for that many beats: beats/beatsPerLine, where beatsPerLine=RATIO
    // so division is beats >> log2(ratio). Finally we add 1 more line to lines_require to account for line wraps,
    // and then multiply required lines by beatsPerLine. required_lines*beatsPerLine = required_lines << log2(RATIO)
    // --------------------------------------
    assign aligned_burst_count = (((s0_burstcount + cmd_pre_count - 1'b1) >> log2(RATIO))+1'b1)<<log2(RATIO); 
    
    // --------------------------------------
    // Response pipeline
    //
    // Registers all response signals
    // --------------------------------------
    assign s0_readdatavalid = (current_state == BURST_COUNT) && rsp_readdatavalid;
    assign s0_readdata      = rsp_readdata;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rsp_readdatavalid <= 1'b0;
            rsp_readdata      <= 0;
        end else begin
            rsp_readdatavalid <= m0_readdatavalid;
            rsp_readdata      <= m0_readdata;
        end 
    end

    // Response Handling
    // Drop additional readdatavalid in PRE_COUNT and POST_COUNT state
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= EMPTY;
            current_counter <= 0;
            post_count_counter <= 0;
        end else begin
            current_state <= next_state;
            current_counter <= next_counter;
            post_count_counter <= next_post_count_counter;
        end
    end
    
    always_comb begin
        case(current_state)
            EMPTY: begin
                if (fifo_out_valid) begin
                    if (pre_count_value != 0) begin
                        next_state = PRE_COUNT;
                        next_pop_fifo = 1'b0;
                        next_counter = pre_count_value;  
                        next_post_count_counter = 1'b1;
                    end else begin
                        next_state = BURST_COUNT;
                        next_pop_fifo = 1'b1;
                        next_counter = burst_count_value;
                        next_post_count_counter = 1'b1;
                    end
                end else begin
                    next_state = current_state;
                    next_pop_fifo = 1'b0;
                    next_counter = current_counter;
                    next_post_count_counter = post_count_counter;
                end
            end
            PRE_COUNT: begin
                if (!rsp_readdatavalid) begin
                    next_state = current_state;
                    next_pop_fifo = 1'b0;
                    next_counter = current_counter;
                    next_post_count_counter = post_count_counter;
                end else begin 
                    next_post_count_counter = post_count_counter + 1'b1;
                    if (current_counter > 1) begin
                        next_state = PRE_COUNT;
                        next_pop_fifo = 1'b0;
                        next_counter = current_counter - 1'b1;
                    end else begin
                        next_state = BURST_COUNT;
                        next_pop_fifo = 1'b1;
                        next_counter = burst_count_value;
                    end
                end
            end
            BURST_COUNT: begin
                if (!rsp_readdatavalid) begin
                    next_state = current_state;
                    next_pop_fifo = 1'b0;
                    next_counter = current_counter;
                    next_post_count_counter = post_count_counter;
                end else begin
                    if (current_counter > 1) begin
                        next_state = BURST_COUNT;
                        next_pop_fifo = 1'b0;
                        next_counter = current_counter - 1'b1;
                        next_post_count_counter = post_count_counter + 1'b1;
                    end else begin                        
                        if (post_count_counter != 0) begin
                            next_state = POST_COUNT;
                            next_pop_fifo = 1'b0;
                            next_counter = RATIO[OUT_BURSTCOUNT_WIDTH-1:0] - post_count_counter; // avoid synthesis warning
                            next_post_count_counter = post_count_counter + 1'b1;
                        end else begin
                            if (fifo_out_valid) begin                     
                                if (pre_count_value != 0) begin
                                    next_state = PRE_COUNT;
                                    next_pop_fifo = 1'b0;
                                    next_counter = pre_count_value;
                                    next_post_count_counter = 1'b1;
                                end else begin
                                    next_state = BURST_COUNT;
                                    next_pop_fifo = 1'b1;
                                    next_counter = burst_count_value;
                                    next_post_count_counter = 1'b1;
                                end
                            end else begin
                                next_state = EMPTY;
                                next_pop_fifo = 1'b0;
                                next_counter = current_counter;
                                next_post_count_counter = post_count_counter;
                            end
                        end
                    end
                end
            end
            POST_COUNT: begin
                if (!rsp_readdatavalid) begin
                    next_state = current_state;
                    next_pop_fifo = 1'b0;
                    next_counter = current_counter;
                    next_post_count_counter = post_count_counter;
                end else begin
                    if (current_counter > 1) begin
                        next_state = POST_COUNT;
                        next_pop_fifo = 1'b0;
                        next_counter = current_counter - 1'b1;
                        next_post_count_counter = post_count_counter;
                    end else begin
                        if (fifo_out_valid) begin
                            next_post_count_counter = 1'b1;
                            if (pre_count_value != 0) begin
                                next_state = PRE_COUNT;
                                next_pop_fifo = 1'b0;
                                next_counter = pre_count_value;
                            end else begin
                                next_state = BURST_COUNT;
                                next_pop_fifo = 1'b1;
                                next_counter = burst_count_value;
                            end
                        end else begin
                            next_state = EMPTY;
                            next_pop_fifo = 1'b0;
                            next_counter = current_counter;
                            next_post_count_counter = post_count_counter;
                        end
                    end
                end
            end
            default: begin 
                next_state = current_state;
                next_pop_fifo = 1'b0;
                next_counter = current_counter;
                next_post_count_counter = post_count_counter;
            end
        endcase
    end
endmodule 
