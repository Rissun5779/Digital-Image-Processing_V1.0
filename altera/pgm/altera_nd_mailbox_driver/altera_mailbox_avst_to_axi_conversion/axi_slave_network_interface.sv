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


`timescale 1ns / 1ns

// -----------------------------------------------
// AXI slave network interface
//
// Converts incoming packets into AXI transactions
// -----------------------------------------------

module axi_slave_network_interface
#(
// -----------------------------------------------
    // Packet format parameters
    // -----------------------------------------------
    parameter PKT_BYTE_CNT_H              = 80,
    parameter PKT_BYTE_CNT_L              = 78,
    parameter PKT_ADDR_H                  = 77,
    parameter PKT_ADDR_L                  = 46,
    parameter PKT_TRANS_EXCLUSIVE         = 45,
    parameter PKT_DATA_H                  = 39,
    parameter PKT_DATA_L                  = 8,
    parameter PKT_BYTEEN_H                = 7,
    parameter PKT_BYTEEN_L                = 4,

    // -----------------------------------------------
    // Component parameters
    // -----------------------------------------------
    parameter USER_W                      = 5,
    parameter ST_DATA_W                   = 121,
    parameter ADDR_WIDTH                  = 32,
    parameter RDATA_WIDTH                 = 64,
    parameter WDATA_WIDTH                 = 64,
    parameter ST_CHANNEL_W                = 1,
    parameter AXI_SLAVE_ID_W              = 4,  
    // -----------------------------------------------
    // Derived parameters 
    // -----------------------------------------------
    parameter RESPONSE_W                  = 2,
    parameter AXI_WSTRB_W                 = PKT_BYTEEN_H - PKT_BYTEEN_L + 1,
    parameter PKT_DATA_W                  = PKT_DATA_H - PKT_DATA_L + 1,
    parameter NUMSYMBOLS                  = PKT_DATA_W / 8,
    parameter AXI_LOCK_WIDTH              = 1,
    parameter AXI_BURST_LENGTH_WIDTH      = 8

)
(
    input                                   clk,
    input                                   reset,

    // AXI write channels
    output reg [AXI_SLAVE_ID_W-1:0]         awid,
    output [ADDR_WIDTH-1:0]                 awaddr,
    output reg [AXI_BURST_LENGTH_WIDTH-1:0] awlen, 
    output [2:0]                            awsize,
    output [1:0]                            awburst,
    output [AXI_LOCK_WIDTH-1:0]             awlock,
    output [3:0]                            awcache,
    output [2:0]                            awprot,
    output [3:0]                            awqos,
    //output [3:0]                            awregion,
    output                                  awvalid,
    output [USER_W-1:0]                     awuser,
    input                                   awready,

    //output reg [AXI_SLAVE_ID_W-1:0]         wid,
    output [PKT_DATA_W-1:0]                 wdata,
    output [AXI_WSTRB_W-1:0]                wstrb,
    //output [USER_W-1:0]                     wuser,
    output                                  wlast,
    output                                  wvalid,
    input                                   wready,

    input [AXI_SLAVE_ID_W-1:0]              bid,
    input [1:0]                             bresp,
    //input [USER_W-1:0]                      buser,
    input                                   bvalid,
    output                                  bready,

    // Av-st write sink command packet interface
    output reg                              write_cp_ready,
    input                                   write_cp_valid,
    input [ST_DATA_W-1:0]                   write_cp_data,
    input                                   write_cp_startofpacket,
    input                                   write_cp_endofpacket,
    
    // Av-st write source response packet interface
    input                                   write_rp_ready,
    output                                  write_rp_valid,
    output reg [ST_DATA_W-1:0]              write_rp_data,
    output reg                              write_rp_startofpacket,
    output reg                              write_rp_endofpacket
	 
);

    // --------------------------------------------------
    // Bunch-o-local parameters
    // --------------------------------------------------
    localparam  BYTECOUNT_W     = PKT_BYTE_CNT_H - PKT_BYTE_CNT_L + 1;
    localparam  BYTEEN_W        = PKT_BYTEEN_H - PKT_BYTEEN_L + 1;

    localparam PKT_AXPROT_L     = 0;
    localparam PKT_AXPROT_H     = PKT_AXPROT_L + 3 - 1;
    localparam PKT_AXCACHE_L    = PKT_AXPROT_H + 1;
    localparam PKT_AXCACHE_H    = PKT_AXCACHE_L + 4 -1;
    localparam PKT_AXLOCK_L     = PKT_AXCACHE_H + 1;
    localparam PKT_AXLOCK_H     = PKT_AXLOCK_L + 1 - 1;
    localparam PKT_AXBURST_L    = PKT_AXLOCK_H + 1;
    localparam PKT_AXBURST_H    = PKT_AXBURST_L + 2 -1;
    localparam PKT_AXSIZE_L     = PKT_AXBURST_H + 1;
    localparam PKT_AXSIZE_H     = PKT_AXSIZE_L + 3 -1;
    localparam PKT_AXLEN_L      = PKT_AXSIZE_H + 1;
    localparam PKT_AXLEN_H      = PKT_AXLEN_L + 8 -1;
    localparam PKT_AXADDR_L     = PKT_AXLEN_H + 1;
    localparam PKT_AXADDR_H     = PKT_AXADDR_L + ADDR_WIDTH -1;
    localparam PKT_AXID_L       = PKT_AXADDR_H + 1;
    localparam PKT_AXID_H       = PKT_AXID_L + AXI_SLAVE_ID_W -1;
    localparam PKT_AXUSER_L     = PKT_AXID_H + 1;
    localparam PKT_AXUSER_H     = PKT_AXUSER_L + USER_W -1;
    //localparam PKT_AXREGION_L   = PKT_AXUSER_H + 1;
    //localparam PKT_AXREGION_H   = PKT_AXREGION_L + 4 -1;
    //localparam PKT_AXQOS_L      = PKT_AXREGION_H + 1;
    //localparam PKT_AXQOS_H      = PKT_AXQOS_L + 4 - 1; 
    localparam PKT_AXQOS_L      = PKT_AXUSER_H + 1;
    localparam PKT_AXQOS_H      = PKT_AXQOS_L + 4 - 1; 

    localparam PKT_WLAST_L      = 0;
    localparam PKT_WLAST_H      = PKT_WLAST_L +1 -1;
    localparam PKT_WSTRB_L      = PKT_WLAST_H + 1;
    localparam PKT_WSTRB_H      = PKT_WSTRB_L + AXI_WSTRB_W -1;
    localparam PKT_WDATA_L      = PKT_WSTRB_H + 1;
    localparam PKT_WDATA_H      = PKT_WDATA_L + WDATA_WIDTH -1;
    localparam PKT_WID_L        = PKT_WDATA_H + 1;
    localparam PKT_WID_H        = PKT_WID_L + AXI_SLAVE_ID_W -1;
    localparam PKT_WUSER_L      = PKT_WID_H + 1;
    localparam PKT_WUSER_H      = PKT_WUSER_L + USER_W -1;

    //localparam AX_WIDTH         = AXI_SLAVE_ID_W+ADDR_WIDTH+8+3+2+1+4+3+USER_W+4+4 ;
    localparam AX_WIDTH         = AXI_SLAVE_ID_W+ADDR_WIDTH+8+3+2+1+4+3+USER_W+4 ;
    //localparam W_WIDTH          = AXI_SLAVE_ID_W+WDATA_WIDTH+ADDR_WIDTH+AXI_WSTRB_W+1+USER_W ;
    localparam W_WIDTH          = AXI_SLAVE_ID_W+WDATA_WIDTH+ADDR_WIDTH+AXI_WSTRB_W+1;

    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
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

    // ------------------------------------------------
    // Internal signals
    // ------------------------------------------------
        
	wire                     s0_pipe_awvalid;
    reg [AXI_SLAVE_ID_W-1:0] s0_pipe_awid;
    reg [ADDR_WIDTH-1:0]     s0_pipe_awaddr;
    reg [7:0]                s0_pipe_awlen;
    reg [2:0]                s0_pipe_awsize;
    reg [1:0]                s0_pipe_awburst;
    reg [AXI_LOCK_WIDTH-1:0] s0_pipe_awlock;
    reg [3:0]                s0_pipe_awcache;
    reg [2:0]                s0_pipe_awprot;
    reg [USER_W-1 : 0]       s0_pipe_awuser;
    reg [3:0]                s0_pipe_awqos;
    wire                     s0_pipeout_awvalid;
    wire                     s0_pipe_awready;   
    
    //reg [AXI_SLAVE_ID_W-1:0] s0_pipe_wid;
    reg [WDATA_WIDTH-1:0]    s0_pipe_wdata;
    reg [AXI_WSTRB_W-1:0]    s0_pipe_wstrb;
    reg [0:0]                s0_pipe_wlast;
    reg [USER_W-1:0]         s0_pipe_wuser;
    reg                      s0_pipeout_wvalid;
    reg                      s0_pipe_wvalid;
    reg                      s0_pipe_wready;
    
    reg [AX_WIDTH-1:0]       pipein_aw;
    reg [AX_WIDTH-1:0]       pipeout_aw;
    reg [W_WIDTH-1:0]        pipein_w;
    reg [W_WIDTH-1:0]        pipeout_w;

    wire [PKT_DATA_W-1:0]    write_cmd_data;
    wire [AXI_WSTRB_W-1:0]   write_cmd_byteen;
    reg [ADDR_WIDTH-1:0]     write_cmd_addr;
    reg [BYTECOUNT_W-1:0]    write_cmd_bytecount;
    wire [1:0]               write_cmd_lock;
    reg [1:0]                write_cmd_bursttype;
    wire [2 :0]              write_cmd_size;
    wire [2:0]               write_cmd_protection;
    wire [3:0]               write_cmd_cache;
    wire [USER_W-1:0]        write_cmd_user;
    reg [AXI_SLAVE_ID_W-1:0] write_cmd_id;
    
    reg                      internal_write_cp_endofburst;
    reg                      internal_read_cp_startofburst;
    reg                      internal_read_cp_endofburst;  
    
    logic                    write_cp_start_of_burst;
    logic                    write_cp_end_of_burst;
    logic                    previous_address_accepted;
    logic                    current_address_accepted;
    logic                    data_accepted;
    
    wire                     awvalid_suppress; 
    wire                     wvalid_suppress;
  
    reg                      read_sop_enable;
    reg                      address_taken;
    reg                      data_taken;
    reg [BYTECOUNT_W-1:0]    minimum_bytecount;
    wire [31:0]              awlen_wire; // to solve qis warnings
    wire [31:0]              arlen_wire; // to solve qis warnings
    
    typedef enum  bit [1:0] 
    {
      FIXED       = 2'b00,
      INCR        = 2'b01,
      WRAP        = 2'b10,
      RESERVED    = 2'b11
    } AxiBurstType;

    //------------------------------------
    // Write Command Packet -> AXI Transaction
    //------------------------------------
    // DATA PATH START
    assign write_cmd_data        = write_cp_data[PKT_DATA_H : PKT_DATA_L];
    assign write_cmd_byteen      = write_cp_data[PKT_BYTEEN_H : PKT_BYTEEN_L];
    assign write_cmd_size        = 3'b010; // sending full 4 byte now
    assign write_cmd_lock        = '0;
    assign write_cmd_addr        = write_cp_data[PKT_ADDR_H : PKT_ADDR_L];
    assign write_cmd_bytecount   = write_cp_data[PKT_BYTE_CNT_H : PKT_BYTE_CNT_L]; 
    assign write_cmd_protection  = '0;
    assign write_cmd_cache       = '0;
    assign write_cmd_bursttype   = 2'b01; //INCR
    assign write_cmd_user        = '0;
    assign awlen_wire            = (write_cmd_bytecount >> log2ceil(PKT_DATA_W / 8)) - 1;
    // assign all signals to pass through to AXI AW* and W* channels, except for last, valid and ready 
    always_comb begin
        // need somethign to do with ID from command packet???
        //s0_pipe_wid   = {AXI_SLAVE_ID_W{1'b0}};
        s0_pipe_awid  = {AXI_SLAVE_ID_W{1'b0}};
    end
    assign s0_pipe_awaddr        = write_cmd_addr;
    assign s0_pipe_awlen         = awlen_wire[AXI_BURST_LENGTH_WIDTH-1:0];
    assign s0_pipe_awsize        = write_cmd_size[2:0];
    assign s0_pipe_awcache       = write_cmd_cache;
    assign s0_pipe_awprot        = write_cmd_protection;
    assign s0_pipe_awlock        = write_cmd_lock[AXI_LOCK_WIDTH-1:0];
    assign s0_pipe_awuser        = write_cmd_user;
    assign s0_pipe_awburst       = write_cmd_bursttype;
    assign s0_pipe_wuser         = '0;
    assign s0_pipe_awqos         = '0;
    //assign s0_pipe_awregion      = 4'b0;
	assign s0_pipe_wdata         = write_cmd_data;
    assign s0_pipe_wstrb         = write_cmd_byteen;
    assign s0_pipe_wlast         = internal_write_cp_endofburst;
    // DATA PATH END

    // CONTROL LOGIC START
    assign internal_write_cp_endofburst = write_cp_endofpacket;

    //------------------------------------
    // Control logic for awvalid, wvalid, write_cp_ready suppression
    // awvalid and wvalid suprression:  At the first transaction within a burst, a merlin packet will contain both address and data with valid asserted.
    //                                  the slave may accept the data and address by asserting wready / awready respectively. If awready is asserted before wready is asserted, the NI
    //                                  will need to suppress awvalid into the slave until wready is asserted, in order to avoid taking in unused addresses. 
    //                                  This is also true if wready is asserted, wvalid will be suppressed until awready is asserted.
    //                                  For subsequent transaction within a burst, awvalid should continue to be suppressed because only data contains valid information.
    //                                  No suppression is needed for wvalid.
    //  write_cp_ready assertion:       At first burst transaction, write_cp_ready is asserted when both awready and wready is asserted. on subsequent transaction, write_cp_ready
    //                                  is asserted depending on when wready is asserted.
    //  backpressure mechanism:         write_cp_ready will be deasserted whenever write rsp fifo is full. this will cause write_cp_valid to be held high, and my cause the slave to
    //                                  continuously taking in new write commands errornously, if the write acceptance capability of the slave is > fifo depth.
    //                                  Hence awvalid and wvalid needs to be held low to prevent this from happening.
    //------------------------------------
    assign  write_cp_ready = (s0_pipe_awready && s0_pipe_wready ) || (address_taken && s0_pipe_wready) || (data_taken && s0_pipe_awready);
    
    assign  s0_pipe_awvalid = write_cp_valid && !address_taken ;  // awvalid suppression
    assign  s0_pipe_wvalid  = write_cp_valid && !data_taken ;     // wvalid suppression

    always_ff @(posedge clk) begin
        if (reset) begin
            address_taken <= '0;
        end
        else begin
            if (s0_pipe_awvalid && s0_pipe_awready)
                address_taken <= '1;
            if (write_cp_valid && write_cp_ready && internal_write_cp_endofburst) // address is considered taken until end of packet
                address_taken <= '0;
        end
    end // always_ff @
    
    always_ff @(posedge clk) begin
        if  (reset) begin
            data_taken  <= '0;
        end
        else begin
            if (s0_pipe_wvalid && s0_pipe_wready)
                data_taken  <= '1;
            if (write_cp_valid && write_cp_ready)
                data_taken  <= '0;
        end
    end

    //------------------------------------
    // bready and bvalid
    //------------------------------------
    assign bready                 = write_rp_ready;  
    assign write_rp_valid         = bvalid;
    // CONTROL LOGIC END
    
    //assign pipein_aw = {s0_pipe_awqos,s0_pipe_awregion,s0_pipe_awuser,s0_pipe_awid,s0_pipe_awaddr,s0_pipe_awlen,s0_pipe_awsize,s0_pipe_awburst,s0_pipe_awlock,s0_pipe_awcache,s0_pipe_awprot};
    assign pipein_aw = {s0_pipe_awqos,s0_pipe_awuser,s0_pipe_awid,s0_pipe_awaddr,s0_pipe_awlen,s0_pipe_awsize,s0_pipe_awburst,s0_pipe_awlock,s0_pipe_awcache,s0_pipe_awprot};
    st_pipeline_base #(
            .SYMBOLS_PER_BEAT (1),
            .BITS_PER_SYMBOL  (AX_WIDTH),
            .PIPELINE_READY (1)
        ) aw_channel_pipeline (
            .clk (clk),
            .reset (reset),
            .in_valid (s0_pipe_awvalid),
            .in_ready (s0_pipe_awready),
            .in_data  (pipein_aw),
            .out_valid (s0_pipeout_awvalid),
            .out_ready (awready),
            .out_data (pipeout_aw)
        );
        assign awvalid   = s0_pipeout_awvalid;
        assign awuser    = pipeout_aw[PKT_AXUSER_H:PKT_AXUSER_L];
        assign awid      = pipeout_aw[PKT_AXID_H:PKT_AXID_L];
        assign awaddr    = pipeout_aw[PKT_AXADDR_H:PKT_AXADDR_L];
        assign awlen     = pipeout_aw[PKT_AXLEN_H:PKT_AXLEN_L];
        assign awsize    = pipeout_aw[PKT_AXSIZE_H:PKT_AXSIZE_L];
        assign awburst   = pipeout_aw[PKT_AXBURST_H:PKT_AXBURST_L];
        assign awlock    = pipeout_aw[PKT_AXLOCK_H:PKT_AXLOCK_L];
        assign awcache   = pipeout_aw[PKT_AXCACHE_H:PKT_AXCACHE_L];
        assign awprot    = pipeout_aw[PKT_AXPROT_H:PKT_AXPROT_L];
        assign awqos     = pipeout_aw[PKT_AXQOS_H:PKT_AXQOS_L];
        //assign awregion  = pipeout_aw[PKT_AXREGION_H:PKT_AXREGION_L];

        //assign pipein_w = {s0_pipe_wuser,s0_pipe_wid,s0_pipe_wdata,s0_pipe_wstrb,s0_pipe_wlast};
        assign pipein_w = {s0_pipe_wdata,s0_pipe_wstrb,s0_pipe_wlast};

        st_pipeline_base #(
            .SYMBOLS_PER_BEAT (1),
            .BITS_PER_SYMBOL  (W_WIDTH),
            .PIPELINE_READY (1)
        ) w_channel_pipeline (
            .clk (clk),
            .reset (reset),
            .in_valid (s0_pipe_wvalid),
            .in_ready (s0_pipe_wready),
            .in_data  (pipein_w),
            .out_valid (s0_pipeout_wvalid),
            .out_ready (wready),
            .out_data (pipeout_w)
        );
    
    assign wvalid = s0_pipeout_wvalid;
    //assign wid  = pipeout_w[PKT_WID_H:PKT_WID_L];
    assign wdata  = pipeout_w[PKT_WDATA_H:PKT_WDATA_L];
    assign wstrb  = pipeout_w[PKT_WSTRB_H:PKT_WSTRB_L];
    assign wlast  = pipeout_w[PKT_WLAST_H:PKT_WLAST_L];
    //assign wuser  = pipeout_w[PKT_WUSER_H:PKT_WUSER_L];

    // Dummy output, shall clear them as we dont need response packet at this side, thinking is it good
    // to use for debug purpose when the driver send a write but return error
    always_comb begin
        write_rp_data           = '0;
        write_rp_startofpacket  = '0;
        write_rp_endofpacket    = '0;
    end
    
    
endmodule
