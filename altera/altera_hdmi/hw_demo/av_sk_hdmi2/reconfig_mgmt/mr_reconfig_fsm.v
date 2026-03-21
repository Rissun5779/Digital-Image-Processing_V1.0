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


module mr_reconfig_fsm #(
    parameter [1:0] CONFIG_TYPE             = 0, // 0=RX only, 1=TX only, 2=RX & TX
    parameter [3:0] RX_STARTING_LOGICAL     = 0, // Indicates starting channel number for RX
    parameter [3:0] TX_STARTING_LOGICAL     = 3, // Indicates starting channel number for TX
    parameter [3:0] TX_PLL_STARTING_LOGICAL = 7  // Indicates starting channel number for TX PLL
) (
    // Clock & reset
    input  wire        sys_clk,
    input  wire        sys_clk_rst,
    output reg         enable,
    output wire        clr_compare_valid,
    output wire [3:0]  bpc_out,	 
    // RX CDR reconfig attributes
    input  wire [3:0]  rx_range,
    input  wire        rx_range_valid,
    input  wire        oversampled,
    // TX channel reconfig attributes
    input  wire [3:0]  tx_range,
    input  wire        tx_range_valid,
    // TX PLL reconfig attributes
    input  wire [3:0]  tx_pll_range,
    input  wire        tx_pll_range_valid,
    // XCVR offset interface
    output wire [1:0]  intf_out,           // 3: RX, 2: TX, 1: TXPLL 0: invalid
    output wire [2:0]  num_exec_out,       // number of offset registers for each interface
    output wire [31:0] readdata_r_out,     // delayed version of readdata
    input  wire [4:0]  offset,             // offset register value
    input  wire [31:0] overriden_data,     // the overriden data that to be written back to the register
    // PLL reconfig attributes
    input  wire [3:0]  pll_range,
    input  wire        pll_range_valid,
    input  wire [17:0] pll_m,
    input  wire [17:0] pll_n,
    input  wire [22:0] pll_c0,
    input  wire [22:0] pll_c1,
    input  wire [22:0] pll_c2,
    //input  wire [22:0] pll_c3,   
    input  wire [1:0]  pll_cp,
    input  wire [6:0]  pll_bw,
    // Signals from/to PHY & PLL 
    input  wire        rx_ready,
    input  wire        tx_ready,
    input  wire        pll_locked,   
    output reg         reset_xcvr,
    output reg         reset_core,
    output reg         reset_pll_reconfig,
    output reg         reset_pll,
    output wire [2:0]  rx_set_locktoref,
    // Signals from RX HDMI core
    input  wire [2:0]  rx_locked,
    input  wire        tmds_bit_clock_ratio,
    input  wire [3:0]  bpc,    
    // Reconfig done to all compare modules     
    output reg         xcvr_reconfig_done,
    output reg         pll_reconfig_done,
    // Interface to alt_xcvr_reconfig
    input  wire        xcvr_reconfig_busy,
    output wire [8:0]  xcvr_reconfig_address,
    output wire        xcvr_reconfig_read,
    input  wire [31:0] xcvr_reconfig_readdata,
    input  wire        xcvr_reconfig_waitrequest,
    output wire        xcvr_reconfig_write,
    output wire [31:0] xcvr_reconfig_writedata,
    // Interface to altera_pll_reconfig
    input  wire        pll_reconfig_waitrequest,    
    output wire [5:0]  pll_reconfig_address,
    output wire        pll_reconfig_write,
    output wire [31:0] pll_reconfig_writedata
);

localparam [6:0] LOGICAL_CHANNEL_REGISTER  = 7'h38;
localparam [6:0] CONTROL_STATUS_REGISTER   = 7'h3a;
localparam [6:0] OFFSET_REGISTER           = 7'h3b;
localparam [6:0] DATA_REGISTER             = 7'h3c;
localparam [2:0] RX_TOTAL_OFFSET           = 4;     // This may increase for HDMI 2.0 when it goes beyond 3.4G
localparam [2:0] TX_TOTAL_OFFSET           = 1;     // This may increase for HDMI 2.0 when it goes beyond 3.4G
localparam [2:0] TX_PLL_TOTAL_OFFSET       = 4;     // This may increase for HDMI 2.0 when it goes beyond 3.4G

// Local parameters for main FSM states   
localparam [2:0]
    RESET      = 3'd0,
    MEASURE    = 3'd1,
    RECONFIG   = 3'd2,
    READY1     = 3'd3,
    READY2     = 3'd4,
    LOCK       = 3'd5,
    LOCKED1    = 3'd6,
    LOCKED2    = 3'd7;
    
// Local parameters for XCVR reconfig FSM states   
localparam [3:0]
    IDLE_1                = 4'd0,
    EXAMINE_PER_INTERFACE = 4'd1,
    ANALYZE_PER_INTERFACE = 4'd2,
    SET_LOG_CH            = 4'd3,
    SET_MIF_MODE          = 4'd4,
    SET_OFFSET            = 4'd5,
    TOGGLE_READ           = 4'd6,
    READ_BUSY_DELAY0      = 4'd7,
    READ                  = 4'd8,
    READ_WAIT_REQUEST     = 4'd9,
    WRITE_DATA            = 4'd10,
    TOGGLE_WRITE          = 4'd11,
    READ_BUSY_DELAY       = 4'd12,
    FINISH                = 4'd13;

// Local parameters for PLL reconfig FSM states   
localparam [2:0]
    IDLE_2 = 3'd0,
    UPDATE = 3'd1,
    NEXT   = 3'd2,
    START  = 3'd3,
    DONE   = 3'd4;

// Registers declaration
reg [3:0]  rx_range_prev;
reg [3:0]  tx_range_prev;
reg [3:0]  tx_pll_range_prev;
reg [3:0]  pll_range_prev;
reg        tmds_bit_clock_ratio_prev;
reg [3:0]  bpc_prev;
reg [3:0]  bpc_temp;
reg [1:0]  intf;               // 3: RX, 2: TX, 1: TXPLL 0: invalid
reg [2:0]  num_exec;           // number of offset registers for each interface
reg        override;           // 0: do read operation, 1: do write operation
reg [8:0]  address_r;          // delayed version of address
reg        write_r;            // delayed version of write
reg [31:0] writedata_r;        // delayed version of writedata
reg        read_r;             // delayed version of read 
reg [31:0] readdata_r;         // delayed version of readdata
reg [29:0] count;              // delay counter
reg [3:0]  log_ch_sel;         // logical channel number for each interface
reg        reconfig_executed;  // assert when reconfig is executed at least once, clear after each iteration
reg        skip_log_ch_sel; 
reg [5:0]  pll_address_r;
reg [5:0]  pll_address_r2;
reg        pll_write_r2;
reg [31:0] pll_writedata_r;
reg [31:0] pll_writedata_r2;
reg [3:0]  pll_register;

// "Registers" declaration
// the wire signals in an combinatorial block needs to be declared as reg      
reg [2:0]  current_state_0;
reg [2:0]  next_state_0;   
reg [3:0]  current_state_1;
reg [3:0]  next_state_1;
reg [2:0]  current_state_2;
reg [2:0]  next_state_2;
reg        init_num_exec;
reg        dec_num_exec;
reg        init_intf;
reg        dec_intf;
reg        init_override;
reg        toggle_override;
reg        init_log_ch_sel;
reg        set_log_ch_sel;
reg        inc_log_ch_sel;   
reg [6:0]  address;
reg [31:0] writedata;
reg        write;
reg        read;
reg        store_readdata;
reg        set_xcvr_reconfig_done;
reg        clr_reconfig_done;
reg        set_reconfig_executed;
reg        clr_reconfig_executed;
reg        set_skip_log_ch_sel;
reg        clr_skip_log_ch_sel;   
reg        init_count;
reg        dec_count;
reg        load_range;
reg        assert_reset_xcvr;
reg        reconfig_req;
reg [5:0]  pll_address_r1;
reg        pll_write_r1;
reg [31:0] pll_writedata_r1;
reg        set_pll_reconfig_done;
reg        clr_pll_register;
reg        inc_pll_register;
reg        enable_measure;
reg        assert_reset_core;
reg        assert_set_locktoref;
reg        clr_set_locktoref;
reg [2:0]  set_locktoref;
reg        assert_reset_pll_reconfig;
reg        assert_reset_pll;
reg        set_ready_count;
reg        set_locked_count;
reg        set_max_count;
reg        set_invalid_range;
reg        ready_to_measure; 
reg        init_ready_drop_count;
reg        dec_ready_drop_count; 
reg [9:0]  ready_drop_count; 
reg        latch_bpc_temp; 
 
// Wires declaration
wire       rx_go_reconfig;
wire       tx_go_reconfig;
wire       tx_pll_go_reconfig;
wire       pll_go_reconfig;
wire       xcvr_go_reconfig;   
wire       valid;
wire       ready_sig;
wire       reconfig_done_sig;
wire       locked_sig;
wire       go_reconfig_sig;
wire       bpc_change;
   
assign intf_out = intf;
assign num_exec_out = num_exec;
assign readdata_r_out = readdata_r;
  
// Increment logical channel number for next channel once 
// the current has been written to the LOGICAL_CHANNEL_REGISTER
// Set the logical channel number directly for next interface (eg. TX) 
// when the current interface (eg. RX) is not needed for reconfig      
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        log_ch_sel <= 4'd0;
    end else begin
        if (init_log_ch_sel) begin
            log_ch_sel <= 4'd0;
        end else if (inc_log_ch_sel) begin
            log_ch_sel <= log_ch_sel + 4'd1;
        end else if (set_log_ch_sel) begin
            if (intf == 2)      log_ch_sel <= TX_STARTING_LOGICAL;
            else if (intf == 1) log_ch_sel <= TX_PLL_STARTING_LOGICAL;
        end 
    end       
end
 
// Register the current ranges that have just been analyzed
// for next iteration when the core is unlocked & reconfig is needed
// as well as the clock measure returned a valid results 
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        rx_range_prev <= 4'b1111;
        tx_range_prev <= 4'b1111;
        tx_pll_range_prev <= 4'b1111;
        pll_range_prev <= 4'b1111;
        tmds_bit_clock_ratio_prev <= 1'b0;		  
        bpc_prev <= 4'b0000;
        bpc_temp <= 4'b0000;
    end else begin
        if (set_invalid_range) begin
            // load all to invalid value when something unexpected happens (eg. reconfig hang etc)
            // so that it forces reconfig for all on next reconfig cycle				
            rx_range_prev <= 4'b1111;
            tx_range_prev <= 4'b1111;
            tx_pll_range_prev <= 4'b1111;
            pll_range_prev <= 4'b1111;
            bpc_prev <= 4'b0000;
            bpc_temp <= 4'b0000;
        end else if (load_range) begin
            // load the comparison/bpc/scdc value to previous value only after the successful reconfiguration		  
            rx_range_prev <= rx_range;
            tx_range_prev <= tx_range;
            tx_pll_range_prev <= tx_pll_range;
            pll_range_prev <= pll_range;
            tmds_bit_clock_ratio_prev <= tmds_bit_clock_ratio;
            bpc_prev <= bpc_temp;				
        end else if (latch_bpc_temp) begin
            // upon detecting HDMI RX core retrieves a valid color depth which differs from the previous
            // latch the value for PLL compare module as the HDMI RX core may gone through reset sequence which
            // indirectly clear the color depth information to 0s				
            bpc_temp <= bpc;
        end
    end       
end

// Synchronizers 
wire rx_locked_sync;
wire pll_locked_sync;
wire pll_reconfig_waitrequest_sync;
altera_std_synchronizer #(.depth(3)) u_rx_locked_sync                (.clk(sys_clk),.reset_n(1'b1),.din(&rx_locked),              .dout(rx_locked_sync));
altera_std_synchronizer #(.depth(3)) u_pll_locked_sync               (.clk(sys_clk),.reset_n(1'b1),.din(pll_locked),              .dout(pll_locked_sync));
altera_std_synchronizer #(.depth(3)) u_pll_reconfig_waitrequest_sync (.clk(sys_clk),.reset_n(1'b1),.din(pll_reconfig_waitrequest),.dout(pll_reconfig_waitrequest_sync));

// Determine if reconfig is needed by comparing the current ranges versus previous registered ranges 
assign bpc_change                  = ((bpc[3:2] == 2'b01) || (bpc[3:2] == 2'b00)) && (bpc_temp[1:0] != bpc[1:0]); // bpc[3:2] qualify if the bpc[1:0] is valid, so bpc_temp and bpc_prev is always valid
assign tmds_bit_clock_ratio_change = (tmds_bit_clock_ratio_prev != tmds_bit_clock_ratio);    
assign rx_go_reconfig              = CONFIG_TYPE == 1 ? 1'b0 : (rx_range_prev != rx_range) || bpc_change || (bpc_prev[1:0] != bpc_temp[1:0]) || tmds_bit_clock_ratio_change;
assign tx_go_reconfig              = CONFIG_TYPE == 0 ? 1'b0 : tx_range_prev != tx_range;
assign tx_pll_go_reconfig          = CONFIG_TYPE == 0 ? 1'b0 : tx_pll_range_prev != tx_pll_range;
assign pll_go_reconfig             = CONFIG_TYPE == 1 ? 1'b0 : (pll_range_prev != pll_range) || bpc_change || (bpc_prev[1:0] != bpc_temp[1:0]) || tmds_bit_clock_ratio_change;

assign xcvr_go_reconfig = CONFIG_TYPE == 2 ? (intf == 3 ? rx_go_reconfig :
                                              intf == 2 ? tx_go_reconfig :
                                              intf == 1 ? tx_pll_go_reconfig :
                                                          1'b0) :
                          CONFIG_TYPE == 1 ? (intf == 2 ? tx_go_reconfig :
                                              intf == 1 ? tx_pll_go_reconfig :
                                                          1'b0) :
                                             rx_go_reconfig;
   
assign valid = CONFIG_TYPE == 2 ? rx_range_valid & tx_range_valid & 
                                  tx_pll_range_valid & pll_range_valid :
               CONFIG_TYPE == 1 ? tx_range_valid & tx_pll_range_valid :
                                  rx_range_valid & pll_range_valid;

assign ready_sig = CONFIG_TYPE == 2 ? pll_locked_sync & tx_ready & rx_ready : 
                   CONFIG_TYPE == 1 ? tx_ready :
                                      pll_locked_sync & rx_ready; 

assign reconfig_done_sig = CONFIG_TYPE == 2 ? xcvr_reconfig_done & pll_reconfig_done : 
                           CONFIG_TYPE == 1 ? xcvr_reconfig_done :
                                              xcvr_reconfig_done & pll_reconfig_done; 

assign locked_sig = CONFIG_TYPE == 2 ? rx_locked_sync : 
                    CONFIG_TYPE == 1 ? tx_ready :
                                       rx_locked_sync; 

assign go_reconfig_sig = CONFIG_TYPE == 2 ? xcvr_go_reconfig | pll_go_reconfig :
                         CONFIG_TYPE == 1 ? xcvr_go_reconfig :
                                            xcvr_go_reconfig | pll_go_reconfig;
    
// Main FSM
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        current_state_0 <= RESET; 
    end else begin
        current_state_0 <= next_state_0;
    end       
end
   
always @ (*)
begin
    next_state_0 = current_state_0;
    assert_reset_xcvr = 1'b0;
    assert_reset_core = 1'b0;
    dec_count = 1'b0;
    enable_measure = 1'b0;
    reconfig_req = 1'b0;
    assert_set_locktoref = 1'b0;
    clr_set_locktoref = 1'b0;
    clr_reconfig_done = 1'b0;
    init_count = 1'b0;
    load_range = 1'b0;
    assert_reset_pll_reconfig = 1'b0;
    assert_reset_pll = 1'b0;
    set_ready_count = 1'b0;
    set_invalid_range = 1'b0;
    ready_to_measure = 1'b0;
    set_locked_count = 1'b0;
    set_max_count = 1'b0;
    init_ready_drop_count = 1'b0;
    dec_ready_drop_count = 1'b0;	 
    latch_bpc_temp = 1'b0;
	 
    case (current_state_0)
        // Reset state      
        RESET: begin
            assert_reset_xcvr = 1'b1;
            assert_reset_core = 1'b1;
            assert_reset_pll = 1'b1;
            init_ready_drop_count = 1'b1;
            dec_count = 1'b1;
            if (count == 0) begin
                // If reconfig has just completed, check if XCVR & PLL has achieved lock	       
                if (reconfig_done_sig) begin
                    set_max_count = 1'b1;
                    next_state_0 = READY1;
                // Upon reset or unlocked, go measure directly		   
                end else begin	       
                    ready_to_measure = 1'b1;					 
                    set_max_count = 1'b1;
                    next_state_0 = MEASURE;
                end	       
            end
        end
	
        // Wait for ready signals from PHY & PLL
        // If this round of reset is after a reconfig, go & check core lock signals
        // else means this round is upon powerup/reset, go & measure incoming hdmi clk 	  
        READY1: begin
            assert_reset_core = 1'b1;
            clr_reconfig_done = 1'b1;	   
            dec_count = 1'b1;
            if (ready_sig) begin	   
                set_ready_count = 1'b1;
                next_state_0 = READY2;
            end else if (count == 0) begin
                // When this happen (either RX, TX or PLL is not ready)
                // set the previous range to an invalid value in order
                // to force reconfig & reset 	       
                set_invalid_range = 1'b1;
                assert_reset_pll_reconfig = 1'b1;
                ready_to_measure = 1'b1;					 
                set_max_count = 1'b1;
                next_state_0 = MEASURE;
            end
        end

        // Check if the PLL locked & XCVR ready signals are stable
        READY2: begin
            assert_reset_core = 1'b1;	   
            if (ready_sig) begin
                dec_count = 1'b1;
                if (count == 0) begin
                    init_ready_drop_count = 1'b1;  
                    set_max_count = 1'b1;
                    next_state_0 = LOCK;
                end
            end else begin
                dec_ready_drop_count = 1'b1;
                if (ready_drop_count == 0) begin
                    set_invalid_range = 1'b1;
                    assert_reset_pll_reconfig = 1'b1;				
                    init_count = 1'b1;
                    next_state_0 = RESET;
                end else begin		  
                    set_max_count = 1'b1;
                    next_state_0 = READY1;
                end						   
            end				
        end
		  
        // Enable the watchdog to measure hdmi clk     
        MEASURE: begin
            //assert_reset_core = 1'b1;
            enable_measure = 1'b1;
            clr_reconfig_done = 1'b1;
            dec_count = 1'b1;
            if (valid) begin
                set_ready_count = 1'b1;	 
                next_state_0 = RECONFIG;
            end else if (count == 0) begin
                set_invalid_range = 1'b1;
                assert_reset_pll_reconfig = 1'b1; 				
                init_count = 1'b1;
                next_state_0 = RESET;
            end
        end

        // Issue reconfig request signal to the other 2 FSMs (PHY & PLL)
        // The other 2 FSMs determine if reconfig is really needed
        // when the reconfig is done, reset again & set the LTR signals accordingly        
        RECONFIG: begin
            assert_reset_xcvr = 1'b1;
            assert_reset_core = 1'b1;				
            reconfig_req = 1'b1;
            dec_count = 1'b1;
            if (reconfig_done_sig) begin	   
                load_range = 1'b1;	
                init_count = 1'b1;
                next_state_0 = RESET;
                if (oversampled) begin
                    assert_set_locktoref = 1'b1;
                end else begin	
                    clr_set_locktoref = 1'b1;
                end
            end else if (count == 0) begin
                set_invalid_range = 1'b1;
                assert_reset_pll_reconfig = 1'b1; 				
                init_count = 1'b1;
                next_state_0 = RESET;
            end
        end
		  
        // Wait for lock signals from the HDMI RX core		  
        LOCK: begin	  
            clr_reconfig_done = 1'b1;
            dec_count = 1'b1;
            if (locked_sig) begin
                set_locked_count = 1'b1;					 
                next_state_0 = LOCKED1;
            end else if (count == 0) begin
                set_invalid_range = 1'b1;
                assert_reset_pll_reconfig = 1'b1;				
                init_count = 1'b1;
                next_state_0 = RESET;
            end   
        end

        // Locked to hdmi signal
        // the watchdog is enabled to continuously monitor the hdmi clk        
        LOCKED1: begin
            enable_measure = 1'b1;
            if (~locked_sig | ~ready_sig) begin	   
                init_count = 1'b1;
                next_state_0 = RESET;
            end else if (valid) begin
                // Watchdog has detected a different tmds clock range
                // Or the color depth/tmds_bit_clock_ratio has changed 					 
                if (go_reconfig_sig) begin				
                    next_state_0 = LOCKED2;
                // Watchdog has detected a same tmds clock range 		   
                end else begin
                    set_locked_count = 1'b1;
                end					 
            end    
        end

        // Watchdog has detected a different tmds clock range or color 
        // depth/tmds_bit_clock_ratio but hdmi unlocked signal has yet 
        // to be detected, check if the threshold is reached. If the new 
        // range has been found same consecutively, force reconfig.
        // Force measure again/reconfig immediately if color depth or
        // tmds_bit_clock_ratio has changed.		  
        LOCKED2: begin
            if (bpc_change || tmds_bit_clock_ratio_change) begin
                latch_bpc_temp = bpc_change;				
                ready_to_measure = 1'b1;					 
                set_max_count = 1'b1;
                next_state_0 = MEASURE; 
            end else if (count == 0) begin
                set_ready_count = 1'b1;	
                next_state_0 = RECONFIG; 
            end else begin
                dec_count = 1'b1;
                ready_to_measure = 1'b1;	
                next_state_0 = LOCKED1;
            end  
        end

        default: begin
            assert_reset_xcvr = 1'b1;
            assert_reset_core = 1'b1;
            dec_count = 1'b0;
            enable_measure = 1'b0;
            reconfig_req = 1'b0;
            assert_set_locktoref = 1'b0;
            clr_set_locktoref = 1'b0;
            clr_reconfig_done = 1'b0;
            init_count = 1'b1;
            set_ready_count = 1'b0;
            set_locked_count = 1'b0;
            set_max_count = 1'b0;
            load_range = 1'b0;
            assert_reset_pll_reconfig = 1'b1;
            assert_reset_pll = 1'b1;
            set_invalid_range = 1'b1;
            ready_to_measure = 1'b1;
            init_ready_drop_count = 1'b0;
            dec_ready_drop_count = 1'b0;
            latch_bpc_temp = 1'b0;				
            next_state_0 = RESET;
        end      
    endcase
end

// Timeout counter
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        count <= 30'h0000000F;
    end else begin
        if (init_count) begin
            count <= 30'h0000000F;
        end else if (set_max_count) begin
            if (tmds_bit_clock_ratio) begin
                count <= 30'h0FFFFFFF;
            end else begin
                count <= 30'h03FFFFFF;
            end
        end else if (set_ready_count) begin
            count <= 30'h00FFFFFF;
        end else if (set_locked_count) begin
            count <= 30'h000001;	   
        end else if (dec_count) begin
            count <= count - 30'h000001;
        end	   
    end       
end 

// The ready from transceiver may toggle for unknown cycles
// before it gets stabilized, this count prevent the state machine
// to go into infinite loop when the ready signal is unstable
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        ready_drop_count <= 10'd1000;
    end else begin
        if (init_ready_drop_count) begin
            ready_drop_count <= 10'd1000;
        end else if (dec_ready_drop_count) begin
            ready_drop_count <= ready_drop_count - 10'd1;
        end				
    end       
end 	 
	 
// XCVR reconfig FSM
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        current_state_1 <= IDLE_1;
    end else begin
        current_state_1 <= next_state_1;
    end       
end

always @ (*)
begin
    next_state_1 = current_state_1;
    init_num_exec = 1'b0;
    dec_num_exec = 1'b0;
    init_intf = 1'b0;
    dec_intf = 1'b0;
    init_override = 1'b0;
    toggle_override = 1'b0;
    init_log_ch_sel = 1'b0;
    set_log_ch_sel = 1'b0;   
    inc_log_ch_sel = 1'b0;
    set_xcvr_reconfig_done = 1'b0;   
    set_reconfig_executed = 1'b0;
    clr_reconfig_executed = 1'b0;
    set_skip_log_ch_sel = 1'b0;
    clr_skip_log_ch_sel = 1'b0;   
    address = 7'd0;
    writedata = 32'd0;
    write = 1'b0;
    read = 1'b0;
    store_readdata = 1'b0;
   
    case (current_state_1)
        // Wait for reconfig_req from main FSM upon valid from compare modules     
        IDLE_1: begin // 0
            init_num_exec = 1'b1;
            init_override = 1'b1;
            init_intf = 1'b1;
            init_log_ch_sel = 1'b1;
            clr_reconfig_executed = 1'b1;
            clr_skip_log_ch_sel = 1'b1;	   
            if (reconfig_req) begin            
                next_state_1 = EXAMINE_PER_INTERFACE;
            end	        
        end

        // Examine every interface in sequence (RX->TX->TX PLL) & see
        // if reconfig is needed. The comparison of current range against
        // previous reconfig'ed range determine the desire.               
        EXAMINE_PER_INTERFACE: begin // 1
            if (xcvr_go_reconfig) begin
                if (skip_log_ch_sel) begin 	       
                    set_log_ch_sel = 1'b1;
                    clr_skip_log_ch_sel = 1'b1;
                end	       
                next_state_1 = SET_LOG_CH;
            end else begin
                if (~reconfig_executed) begin
                    dec_intf = 1'b1;
                end		   
                next_state_1 = ANALYZE_PER_INTERFACE;	       
            end	       
        end        

        // The current interface (eg. RX or TX) is not needed for reconfig,
        // proceed to examine the next channel (eg. TX or TX PLL)        
        ANALYZE_PER_INTERFACE: begin // 2
            // No reconfig has been executed so far
            // & found out that reconfig is not needed for the current interface
            // it's either RX or TX   	       
            if (~reconfig_executed) begin
                // set_log_ch_sel here plays role in selecting the right 
                // starting logical channel number for the next interface
                // it's either TX or TX PLL 		   
                set_log_ch_sel = 1'b1;
                // RX only	       
                if (CONFIG_TYPE == 0) begin 
                    if (intf == 2) begin
                        next_state_1 = FINISH;
                    end
                end 
                // TX only OR RX & TX
                else begin 	       
                    if (intf == 0) begin
                        next_state_1 = FINISH;                 
                    end else begin
                        next_state_1 = EXAMINE_PER_INTERFACE;
                    end			   
                end		   
            end 
            // Reconfig has done at least once for one interface	       
            else begin
                // RX only	       
                if (CONFIG_TYPE == 0) begin
                    if (intf == 2) begin
                        // clr_reconfig_executed here plays role to clear the 
                        // reconfig_executed when all necessary interfaces are 
                        // reconfig'ed or analyzed done 			   
                        clr_reconfig_executed = 1'b1;			       
                        next_state_1 = FINISH;
                    end 
                    // shouldn't happen
                    else begin
                        set_skip_log_ch_sel = 1'b1;		       
                        next_state_1 = EXAMINE_PER_INTERFACE;
                    end
                end 
                // TX only OR RX & TX
                else begin
                    if (intf == 1) begin
                        clr_reconfig_executed = 1'b1;			       
                        next_state_1 = FINISH;
                    end else begin
                        dec_intf = 1'b1;
                        set_skip_log_ch_sel = 1'b1;			   
                        next_state_1 = EXAMINE_PER_INTERFACE;
                    end			   
                end
            end		   
        end	   

        // Write the intended logical channel (eg. 0, 1, 3, 7)      
        SET_LOG_CH: begin // 3
            init_num_exec = 1'b1;	   
            address = LOGICAL_CHANNEL_REGISTER;
            writedata = log_ch_sel;
            write = 1'b1;	   
            if (~xcvr_reconfig_waitrequest) begin
                inc_log_ch_sel = 1'b1;	       
                next_state_1 = SET_MIF_MODE;
            end	       
        end

        // Select MIF mode 1 & write to the CS register      
        SET_MIF_MODE: begin // 4
            address = CONTROL_STATUS_REGISTER;
            writedata = 32'h00000004;
            write = 1'b1;
            if (~xcvr_reconfig_waitrequest) begin
                next_state_1 = SET_OFFSET;
            end	   
        end

        // Write the intended offset (eg. 0xe, 0x10)      
        SET_OFFSET: begin // 5
            address = OFFSET_REGISTER;
            writedata = offset;
            write = 1'b1;
            if (~xcvr_reconfig_waitrequest) begin
                if (~override) begin
                    next_state_1 = TOGGLE_READ;
                end else begin
                    next_state_1 = WRITE_DATA;
                end
            end
        end

        // Write to CS register to inform read is required      
        TOGGLE_READ: begin // 6
            address = CONTROL_STATUS_REGISTER;
            writedata = 32'h00000006;
            write = 1'b1;
            if (~xcvr_reconfig_waitrequest) begin
                next_state_1 = READ_BUSY_DELAY0;
            end	   
        end

        // Wait for reconfig_busy & then only proceed to read or write 
        // the data from the intended logical channel & offset
        // the scheme performs read-modify-write        
        READ_BUSY_DELAY0: begin // 7
            if (xcvr_reconfig_busy) begin
                // Going to perform read	       
                if (~override) begin 
                    next_state_1 = READ;
                end 
                // Just performed write 
                else begin 
                    dec_num_exec = 1'b1;		   
                    if (num_exec == 1) begin
                        set_reconfig_executed = 1'b1;		       
                        if (CONFIG_TYPE == 2) begin // RX & TX		       
                            if (log_ch_sel == RX_STARTING_LOGICAL+3            // 0-2: RX
                             || log_ch_sel == TX_STARTING_LOGICAL+4            // 3-6: TX
                             || log_ch_sel == TX_PLL_STARTING_LOGICAL+1) begin // 7  : TX PLL
                                dec_intf = 1'b1;
                            end
                        end else if (CONFIG_TYPE == 1) begin // TX only
                            if (log_ch_sel == TX_STARTING_LOGICAL+4           
                             || log_ch_sel == TX_PLL_STARTING_LOGICAL+1) begin 
                                dec_intf = 1'b1;
                            end
                        end else begin // RX only
                            if (log_ch_sel == RX_STARTING_LOGICAL+3) begin
                                dec_intf = 1'b1;
                            end
                        end			     
                    end 
                    next_state_1 = READ_BUSY_DELAY;
                end		   
            end          
        end

        // Issue read signal upon deassertion of reconfig_busy signal      
        READ: begin // 8
            if (~xcvr_reconfig_busy) begin
                address = DATA_REGISTER;
                read = 1'b1;
                if (xcvr_reconfig_waitrequest) begin                	        
                    next_state_1 = READ_WAIT_REQUEST;                
                end
            end
        end

        // Hold read signal high until deassertion of waitrequest signal
        // so that the right data is latched from the intended offset       
        READ_WAIT_REQUEST: begin // 9
            address = DATA_REGISTER;
            read = 1'b1;
            if (~xcvr_reconfig_waitrequest) begin
                read = 1'b0;
                store_readdata = 1'b1;
                next_state_1 = READ_BUSY_DELAY;
            end	       
        end

        // Issue write signal with the intended overriden data      
        WRITE_DATA: begin // 10
            address = DATA_REGISTER;
            writedata = overriden_data;
            write = 1'b1;
            if (~xcvr_reconfig_waitrequest) begin
                next_state_1 = TOGGLE_WRITE;
            end	   
        end  

        // Write to CS register to inform write is required     
        TOGGLE_WRITE: begin // 11
            address = CONTROL_STATUS_REGISTER;
            writedata = 32'h00000005;
            write = 1'b1;
            if (~xcvr_reconfig_waitrequest) begin
                next_state_1 = READ_BUSY_DELAY0;
            end	   
        end

        // Determine the next operation upon deassertion of 
        // reconfig_busy signal         
        READ_BUSY_DELAY: begin // 12
            if (~xcvr_reconfig_busy) begin
                toggle_override = 1'b1;

                // Just performed read	       
                if (~override) begin 
                    next_state_1 = SET_OFFSET;
                end 
                // Just perform write
                else begin 
                    if (num_exec == 0) begin
                        // RX only			   
                        if (CONFIG_TYPE == 0) begin 
                            if (intf == 2) next_state_1 = FINISH;
                            else           next_state_1 = EXAMINE_PER_INTERFACE;
                        end 
                        // TX only OR RX & TX
                        else begin		       
                            if (intf == 0) next_state_1 = FINISH;
                            else           next_state_1 = EXAMINE_PER_INTERFACE;
                        end
                    end else begin
                        next_state_1 = SET_OFFSET;
                    end 		       
                end     
            end	       
        end

        // Reconfig is done for all necessary interfaces       
        FINISH: begin // 13
            set_xcvr_reconfig_done = 1'b1;
            if (~reconfig_req) begin
                next_state_1 = IDLE_1;
            end
        end

        default: begin
            init_num_exec = 1'b0;
            dec_num_exec = 1'b0;
            init_intf = 1'b0;
            dec_intf = 1'b0;
            init_override = 1'b0;
            toggle_override = 1'b0;
            init_log_ch_sel = 1'b0;
            set_log_ch_sel = 1'b0;   
            inc_log_ch_sel = 1'b0;
            set_xcvr_reconfig_done = 1'b0;   
            set_reconfig_executed = 1'b0;
            clr_reconfig_executed = 1'b0;
            set_skip_log_ch_sel = 1'b0;
            clr_skip_log_ch_sel = 1'b0;   
            address = 7'd0;
            writedata = 32'd0;
            write = 1'b0;
            read = 1'b0;
            store_readdata = 1'b0;	   
            next_state_1 = IDLE_1;
        end 
    endcase 
end

// Determine number of offset execution for each
// RX channel: 4 offsets need to be reconfig
// TX channel: 1 offset needs to be reconfig
// TX PLL: 4 offsets need to be reconfig   
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        num_exec <= RX_TOTAL_OFFSET;        
    end else begin
        if (init_num_exec) begin
            if      (intf == 3) num_exec <= RX_TOTAL_OFFSET; 	       
            else if (intf == 2) num_exec <= TX_TOTAL_OFFSET;
            else if (intf == 1) num_exec <= TX_PLL_TOTAL_OFFSET;
        end else if (dec_num_exec) begin
            num_exec <= num_exec - 3'd1;
        end	 
    end       
end

// intf == 3 indicates reconfig for RX channels
// intf == 2 indicates reconfig for TX channels
// intf == 1 indicates reconfig for TX PLL
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        intf <= 2'd3;
    end else begin
        if (init_intf) begin
            if (CONFIG_TYPE == 1) begin // TX only	   
                intf <= 2'd2;
            end else begin
                intf <= 2'd3;
            end
        end else if (dec_intf) begin
            intf <= intf - 2'd1;
        end	   
    end       
end

// reconfig_executed = 1 indicates reconfig is completed
// for all offsets for at least one interface (eg. RX)   
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        reconfig_executed <= 1'b0;
    end else begin
        if (clr_reconfig_executed) begin
            reconfig_executed <= 1'b0;
        end else if (set_reconfig_executed) begin
            reconfig_executed <= 1'b1;
        end	   
    end       
end

// skip_log_ch_sel = 1 indicates the logical channel number
// needs to be jumped. For example, RX reconfig is required,
// TX reconfig is not required & TX PLL reconfig is required
// In other words, this signal only assert for the following   
// Eg. reconfig: RX (1), TX (0), TX PLL (1) -- 1 denotes reconfig
// is required. 
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        skip_log_ch_sel <= 1'b0;
    end else begin
        if (clr_skip_log_ch_sel) begin
            skip_log_ch_sel <= 1'b0;
        end else if (set_skip_log_ch_sel) begin
            skip_log_ch_sel <= 1'b1;
        end	   
    end       
end   
   
// Override = 0 means read operation
// override = 1 means write operation    
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        override <= 1'b0;
    end else begin
        if (init_override) begin
            override <= 1'b0;
        end else if (toggle_override) begin
            override <= ~override;
        end	   
    end       
end

// AVMM interface registers   
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        address_r <= 9'h000;
        write_r <= 1'b0;
        writedata_r <= 32'h00000000;
        read_r <= 1'b0;
        readdata_r <= 32'h00000000;
    end else begin
        address_r <= {address, 2'b00};
        write_r <= write;
        writedata_r <= writedata;
        read_r <= read;
        if (store_readdata) begin
            readdata_r <= xcvr_reconfig_readdata;
        end	   
    end       
end

// Reconfig_done signal handling
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        xcvr_reconfig_done <= 1'b0;
    end else begin
        if (clr_reconfig_done) begin
            xcvr_reconfig_done <= 1'b0;
        end else if (set_xcvr_reconfig_done) begin
            xcvr_reconfig_done <= 1'b1;
        end	   
    end       
end

// PLL reconfig FSM
// The PLL reconfig core cannot close timing at 100MHz on Arria V
// Run 50MHz on Arria V    
always @ (posedge sys_clk or posedge sys_clk_rst)   
begin
    if (sys_clk_rst) begin
        current_state_2 <= IDLE_2;
    end else begin
        current_state_2 <= next_state_2;
    end       
end

always @ (*)
begin
    next_state_2 = current_state_2;
    pll_write_r1 = 1'b0;
    pll_address_r1 = 6'd0;
    pll_writedata_r1 = 32'd0;
    set_pll_reconfig_done = 1'b0;
    clr_pll_register = 1'b0;
    inc_pll_register = 1'b0;
   
    case (current_state_2)
        IDLE_2: begin
            clr_pll_register = 1'b1;
            if (reconfig_req) begin 
                if (pll_go_reconfig) begin 
                    next_state_2 = UPDATE;
                end else begin
                    next_state_2 = DONE;
                end		   
            end 	       
        end

        UPDATE: begin
            pll_write_r1 = 1'b1;
            pll_address_r1 = pll_address_r;
            pll_writedata_r1 = pll_writedata_r;
            if (~pll_reconfig_waitrequest_sync) begin
                if (pll_register == 4'b0111) begin
                    clr_pll_register = 1'b1;		   
                    next_state_2 = START;
                end else begin
                    inc_pll_register = 1'b1;	       
                    next_state_2 = NEXT;
                end		   
            end	else if (~reconfig_req) begin
                next_state_2 = IDLE_2;
            end   
        end

        NEXT: begin
            next_state_2 = UPDATE;
        end

        START: begin
            pll_write_r1 = 1'b1;
            pll_address_r1 = 6'b000010;
            pll_writedata_r1 = 32'd0;
            if (~pll_reconfig_waitrequest_sync) begin
                next_state_2 = DONE;	       
            end	else if (~reconfig_req) begin
                next_state_2 = IDLE_2;
            end   
        end

        DONE: begin
            set_pll_reconfig_done = 1'b1;
            if (~reconfig_req) begin
                next_state_2 = IDLE_2;
            end	   
        end

        default: begin
            pll_write_r1 = 1'b0;
            pll_address_r1 = 6'd0;
            pll_writedata_r1 = 32'd0;
            set_pll_reconfig_done = 1'b0;
            clr_pll_register = 1'b0;
            inc_pll_register = 1'b0;	   
            next_state_2 = IDLE_2;
        end 		  
    endcase   
end     

// A counter to selectively decide the reconfig
// address & writedata    
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        pll_register <= 4'b0000;
    end else begin
        if (clr_pll_register) begin       
            pll_register <= 4'b0000;
        end else if (inc_pll_register) begin
            pll_register <= pll_register + 4'd1;
        end 
    end       
end

// Decode the reconfig address for each desired 
// counter value    
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        pll_address_r <= 6'b000000;
        pll_writedata_r <= 32'd0;
    end else begin
        case (pll_register)
            4'b0000: begin
                pll_address_r <= 6'b000000;
                pll_writedata_r <= 32'd0;
            end
	  
            4'b0001: begin
                pll_address_r <= 6'b000011;
                pll_writedata_r <= {14'd0, pll_n};
            end

            4'b0010: begin
                pll_address_r <= 6'b000100;
                pll_writedata_r <= {14'd0, pll_m};
            end

            4'b0011: begin
                pll_address_r <= 6'b000101;
                pll_writedata_r <= {9'd0, pll_c0};
            end

            4'b0100: begin
                pll_address_r <= 6'b000101;
                pll_writedata_r <= {9'd0, pll_c1};
            end

            4'b0101: begin
                pll_address_r <= 6'b000101;
                pll_writedata_r <= {9'd0, pll_c2};
            end

            //4'b0101: begin
            //    pll_address_r <= 6'b000101;
            //    pll_writedata_r <= pll_c3;
            //end

            4'b0110: begin
                pll_address_r <= 6'b001001;
                pll_writedata_r <= {30'd0, pll_cp};
            end

            4'b0111: begin
                pll_address_r <= 6'b001000;
                pll_writedata_r <= {25'd0, pll_bw};
            end

            default: begin
                pll_address_r <= 6'b000000;
                pll_writedata_r <= 32'd0;
            end	       
        endcase	  
    end       
end	    

// AVMM interface registers    
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        pll_address_r2 <= 6'd0;
        pll_write_r2 <= 1'b0;
        pll_writedata_r2 <= 32'd0;
    end else begin
        pll_address_r2 <= pll_address_r1;
        pll_write_r2 <= pll_write_r1;
        pll_writedata_r2 <= pll_writedata_r1;
    end       
end	  

// Reconfig_done signal handling for PLL
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        pll_reconfig_done <= 1'b0;
    end else begin
        if (clr_reconfig_done) begin // was _sync
            pll_reconfig_done <= 1'b0;
        end else if (set_pll_reconfig_done) begin
            pll_reconfig_done <= 1'b1;
        end	   
    end       
end

// Configure RX PHY to LTR mode for oversampled case
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        set_locktoref <= 3'b000;
    end else begin
        if (clr_set_locktoref) begin
            set_locktoref <= 3'b000;
        end else if (assert_set_locktoref) begin
            set_locktoref <= 3'b111;
        end
    end
end

// To reset transceiver
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        reset_xcvr <= 1'b1;
    end else begin
        if (assert_reset_xcvr) begin
            reset_xcvr <= 1'b1;
        end else begin
            reset_xcvr <= 1'b0;
        end
    end
end

// To reset HDMI core
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        reset_core <= 1'b1;
    end else begin
        if (assert_reset_core) begin
            reset_core <= 1'b1;
        end else begin
            reset_core <= 1'b0;
        end
    end
end

// To reset PLL/XCVR reconfig IPs
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        reset_pll_reconfig <= 1'b1;
    end else begin
        if (assert_reset_pll_reconfig) begin
            reset_pll_reconfig <= 1'b1;
        end else begin
            reset_pll_reconfig <= 1'b0;
        end
    end
end

// To reset PLL
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        reset_pll <= 1'b1;
    end else begin
        if (assert_reset_pll) begin
            reset_pll <= 1'b1;
        end else begin
            reset_pll <= 1'b0;
        end
    end
end 

// To enable clock measure
always @ (posedge sys_clk or posedge sys_clk_rst)
begin
    if (sys_clk_rst) begin
        enable <= 1'b0;
    end else begin
        if (enable_measure) begin
            enable <= 1'b1;
        end else begin
            enable <= 1'b0;
        end
    end
end    

assign rx_set_locktoref = set_locktoref;
assign xcvr_reconfig_address = address_r;
assign xcvr_reconfig_write = write_r;
assign xcvr_reconfig_writedata = writedata_r;
assign xcvr_reconfig_read = read_r;
assign pll_reconfig_address = pll_address_r2;
assign pll_reconfig_write = pll_write_r2;
assign pll_reconfig_writedata = pll_writedata_r2;
assign clr_compare_valid = ready_to_measure;
assign bpc_out = bpc_temp;
   
endmodule			   