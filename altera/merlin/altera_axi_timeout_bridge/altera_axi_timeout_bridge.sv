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


`timescale 1ns/1ns

// The AXI timeout bridge acts as a watchdog timer. When an internal timer in
// the bridge times out, it asserts interrupt, reports the burst that caused the
// timeout via CSR, and starts generating AXI error responses back to the
// issuing master. It generates the error responses on behalf of the faulty
// slave to free up the master.
//
// AXI's write and read channels are essentially independent from each and
// other. Note however that once a timeout happens on either channel, the bridge
// will start generating error responses on both channels.
//
// After a timeout, the slave is certified dead. Subsequent commands will be
// accepted immediately by the bridge, and responded to as soon as possible.
// These commands will not be passed through to the slave.
//
// To resume normal operation, the dead slave must be reset and then the bridge
// must be notified of that via CSR.
module altera_axi_timeout_bridge
#(
    int ID_WIDTH               = 1,
    int ADDRESS_WIDTH          = 1,
    int DATA_WIDTH             = 8,
    int USER_WIDTH             = 1,
    int MAX_OUTSTANDING_WRITES = 1,
    int MAX_OUTSTANDING_READS  = 1,
    int MAX_CYCLES             = 256, // The number of cycles within which a burst must complete.

    // Derived.
    int STROBES_WIDTH          = DATA_WIDTH / 8,
    int TIMESTAMP_WIDTH        = $clog2(MAX_CYCLES),
    int CSR_ADDRESS_WIDTH      = 4,
    int CSR_DATA_WIDTH         = 32,
    int CSR_STROBES_WIDTH      = CSR_DATA_WIDTH / 8
)(
    input logic                          clk,
    input logic                          reset,

    // Slave.
    input logic[ID_WIDTH - 1:0]          s_awid,
    input logic[ADDRESS_WIDTH - 1:0]     s_awaddr,
    input logic[7:0]                     s_awlen,
    input logic[2:0]                     s_awsize,
    input logic[1:0]                     s_awburst,
    input logic                          s_awlock,
    input logic[3:0]                     s_awcache,
    input logic[2:0]                     s_awprot,
    input logic[3:0]                     s_awqos,
    input logic[3:0]                     s_awregion,
    input logic[USER_WIDTH - 1:0]        s_awuser,
    input logic                          s_awvalid,
    output logic                         s_awready,

    input logic[DATA_WIDTH - 1:0]        s_wdata,
    input logic[STROBES_WIDTH - 1:0]     s_wstrb,
    input logic                          s_wlast,
    input logic[USER_WIDTH - 1:0]        s_wuser,
    input logic                          s_wvalid,
    output logic                         s_wready,

    output logic[ID_WIDTH - 1:0]         s_bid,
    output logic[1:0]                    s_bresp,
    output logic[USER_WIDTH - 1:0]       s_buser,
    output logic                         s_bvalid,
    input logic                          s_bready,

    input logic[ID_WIDTH - 1:0]          s_arid,
    input logic[ADDRESS_WIDTH - 1:0]     s_araddr,
    input logic[7:0]                     s_arlen,
    input logic[2:0]                     s_arsize,
    input logic[1:0]                     s_arburst,
    input logic                          s_arlock,
    input logic[3:0]                     s_arcache,
    input logic[2:0]                     s_arprot,
    input logic[3:0]                     s_arqos,
    input logic[3:0]                     s_arregion,
    input logic[USER_WIDTH - 1:0]        s_aruser,
    input logic                          s_arvalid,
    output logic                         s_arready,

    output logic[ID_WIDTH - 1:0]         s_rid,
    output logic[DATA_WIDTH - 1:0]       s_rdata,
    output logic[1:0]                    s_rresp,
    output logic                         s_rlast,
    output logic[USER_WIDTH - 1:0]       s_ruser,
    output logic                         s_rvalid,
    input logic                          s_rready,

    // Master.
    output logic[ID_WIDTH - 1:0]         m_awid,
    output logic[ADDRESS_WIDTH - 1:0]    m_awaddr,
    output logic[7:0]                    m_awlen,
    output logic[2:0]                    m_awsize,
    output logic[1:0]                    m_awburst,
    output logic                         m_awlock,
    output logic[3:0]                    m_awcache,
    output logic[2:0]                    m_awprot,
    output logic[3:0]                    m_awqos,
    output logic[3:0]                    m_awregion,
    output logic[USER_WIDTH - 1:0]       m_awuser,
    output logic                         m_awvalid,
    input logic                          m_awready,

    output logic[DATA_WIDTH - 1:0]       m_wdata,
    output logic[STROBES_WIDTH - 1:0]    m_wstrb,
    output logic                         m_wlast,
    output logic[USER_WIDTH - 1:0]       m_wuser,
    output logic                         m_wvalid,
    input logic                          m_wready,

    input logic[ID_WIDTH - 1:0]          m_bid,
    input logic[1:0]                     m_bresp,
    input logic[USER_WIDTH - 1:0]        m_buser,
    input logic                          m_bvalid,
    output logic                         m_bready,

    output logic[ID_WIDTH - 1:0]         m_arid,
    output logic[ADDRESS_WIDTH - 1:0]    m_araddr,
    output logic[7:0]                    m_arlen,
    output logic[2:0]                    m_arsize,
    output logic[1:0]                    m_arburst,
    output logic                         m_arlock,
    output logic[3:0]                    m_arcache,
    output logic[2:0]                    m_arprot,
    output logic[3:0]                    m_arqos,
    output logic[3:0]                    m_arregion,
    output logic[USER_WIDTH - 1:0]       m_aruser,
    output logic                         m_arvalid,
    input logic                          m_arready,

    input logic[ID_WIDTH - 1:0]          m_rid,
    input logic[DATA_WIDTH - 1:0]        m_rdata,
    input logic[1:0]                     m_rresp,
    input logic                          m_rlast,
    input logic[USER_WIDTH - 1:0]        m_ruser,
    input logic                          m_rvalid,
    output logic                         m_rready,

    // CSR.
    input logic[CSR_ADDRESS_WIDTH - 1:0] csr_awaddr,
    input logic[2:0]                     csr_awprot,
    input logic                          csr_awvalid,
    output logic                         csr_awready,

    input logic[CSR_DATA_WIDTH - 1:0]    csr_wdata,
    input logic[CSR_STROBES_WIDTH - 1:0] csr_wstrb,
    input logic                          csr_wvalid,
    output logic                         csr_wready,

    output logic[1:0]                    csr_bresp,
    output logic                         csr_bvalid,
    input logic                          csr_bready,

    input logic[CSR_ADDRESS_WIDTH - 1:0] csr_araddr,
    input logic[2:0]                     csr_arprot,
    input logic                          csr_arvalid,
    output logic                         csr_arready,

    output logic[CSR_DATA_WIDTH - 1:0]   csr_rdata,
    output logic[1:0]                    csr_rresp,
    output logic                         csr_rvalid,
    input logic                          csr_rready,

    // Interrupt.
    output logic                         irq
);
    // In `NORMAL` mode, the bridge passes commands through while respecting
    // `MAX_OUTSTANDING_WRITES` and `MAX_OUTSTANDING_READS`.
    //
    // When a timeout occurs, the bridge switches to `SLAVE_DEAD` mode. In this
    // mode, it acts as a proxy for the assumed dead slave. All outstanding
    // bursts as well as new ones will be completed by the bridge with
    // `SLVERR`s.
    //
    // After the slave has been reset and the bridge notified through its CSR,
    // the bridge switches to `SLAVE_RESURRECTED` mode. It stops accepting new
    // commands (unless they are required to match any imbalance between the
    // write address and data channels).
    //
    // Once all outstanding bursts have been responded too, the bridge goes back
    // to `NORMAL`.
    typedef enum logic[2:0] {
        NORMAL = 3'b001,
        SLAVE_DEAD = 3'b010,
        SLAVE_RESURRECTED = 3'b100
    } state_e;

    state_e                    state;

    logic                      awvalid0;
    logic                      awready0;

    logic                      wvalid0;
    logic                      wready0;

    logic                      arvalid0;
    logic                      arready0;

    logic                      write_response_issued_before_timeout_but_unaccepted;
    logic                      read_data_issued_before_timeout_but_unaccepted;

    logic                      max_oustanding_write_address_unhit;
    logic                      max_oustanding_write_data_unhit;
    logic[1:0]                 error_responder_bresp;
    logic[USER_WIDTH - 1:0]    error_responder_buser;
    logic                      error_responder_bvalid;
    logic                      max_oustanding_read_address_unhit;
    logic[DATA_WIDTH - 1:0]    error_responder_rdata;
    logic[1:0]                 error_responder_rresp;
    logic[USER_WIDTH - 1:0]    error_responder_ruser;
    logic                      error_responder_rvalid;

    logic                      slave_has_been_reset;

    logic                      write_timeout;
    logic[ADDRESS_WIDTH - 1:0] write_watchdog_timer_timed_out_address;

    logic                      read_timeout;
    logic[ADDRESS_WIDTH - 1:0] read_watchdog_timer_timed_out_address;

    logic                      accepted_fewer_write_addresses_than_first_data;
    logic                      accepted_fewer_first_write_data_than_addresses;
    logic                      write_data_in_progress;

    // Slave and master interfaces.

    // `m_awvalid`, `m_wvalid` and `m_arvalid` are deasserted immediately after
    // a timeout. It is acknowledged that this behaviour violates the AXI
    // specification, but only at the interface that is connected to a dead
    // slave at that point in time.
    assign m_awid     = s_awid;
    assign m_awaddr   = s_awaddr;
    assign m_awlen    = s_awlen;
    assign m_awsize   = s_awsize;
    assign m_awburst  = s_awburst;
    assign m_awlock   = s_awlock;
    assign m_awcache  = s_awcache;
    assign m_awprot   = s_awprot;
    assign m_awqos    = s_awqos;
    assign m_awregion = s_awregion;
    assign m_awuser   = s_awuser;
    assign m_awvalid  = state == NORMAL ? awvalid0 : 1'b0;
    assign awready0   = state == NORMAL ? m_awready : 1'b1;

    assign m_wdata    = s_wdata;
    assign m_wstrb    = s_wstrb;
    assign m_wlast    = s_wlast;
    assign m_wuser    = s_wuser;
    assign m_wvalid   = state == NORMAL ? wvalid0 : 1'b0;
    assign wready0    = state == NORMAL ? m_wready : 1'b1;

    assign s_bresp    = (state == NORMAL) | write_response_issued_before_timeout_but_unaccepted ? m_bresp : error_responder_bresp;
    assign s_buser    = (state == NORMAL) | write_response_issued_before_timeout_but_unaccepted ? m_buser : error_responder_buser;
    assign s_bvalid   = state == NORMAL ? m_bvalid : error_responder_bvalid;
    assign m_bready   = state == NORMAL ? s_bready : 1'b0;

    assign m_arid     = s_arid;
    assign m_araddr   = s_araddr;
    assign m_arlen    = s_arlen;
    assign m_arsize   = s_arsize;
    assign m_arburst  = s_arburst;
    assign m_arlock   = s_arlock;
    assign m_arcache  = s_arcache;
    assign m_arprot   = s_arprot;
    assign m_arqos    = s_arqos;
    assign m_arregion = s_arregion;
    assign m_aruser   = s_aruser;
    assign m_arvalid  = state == NORMAL ? arvalid0 : 1'b0;
    assign arready0   = state == NORMAL ? m_arready : 1'b1;

    assign s_rdata    = (state == NORMAL) | read_data_issued_before_timeout_but_unaccepted ? m_rdata : error_responder_rdata;
    assign s_rresp    = (state == NORMAL) | read_data_issued_before_timeout_but_unaccepted ? m_rresp : error_responder_rresp;
    assign s_ruser    = (state == NORMAL) | read_data_issued_before_timeout_but_unaccepted ? m_ruser : error_responder_ruser;
    assign s_rvalid   = state == NORMAL ? m_rvalid : error_responder_rvalid;
    assign m_rready   = state == NORMAL ? s_rready : 1'b0;

    // CSR.
    logic csr_write_address_ready;
    logic csr_read_address_ready;
    assign csr_write_address_ready = csr_awvalid & csr_wvalid & (~csr_bvalid | csr_bready);
    assign csr_read_address_ready = csr_arvalid & (~csr_rvalid | csr_rready);

    assign csr_awready = csr_write_address_ready;
    assign csr_wready = csr_write_address_ready;
    assign csr_arready = csr_read_address_ready;

    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            slave_has_been_reset <= 0;
            csr_bvalid <= 0;
        end else begin
            slave_has_been_reset <= 0;
            if (csr_write_address_ready) begin
                csr_bvalid <= 1;

                csr_bresp <= 2'b10; // SLVERR.
                if (state == SLAVE_DEAD) begin
                    if (csr_awaddr[3:2] == 2'b00) begin // address=0x0.
                        if ((csr_wdata[0] == 1'b1) & (csr_wstrb[0] == 1'b1)) begin
                            slave_has_been_reset <= 1;
                            csr_bresp <= 2'b00;
                        end
                    end
                end
            end else if (csr_bready)
                csr_bvalid <= 0;
        end
    end

    // As soon as a timeout occurs, store the operation and address of the burst
    // that caused the timeout (they may no longer be available from the timers
    // one cycle later).
    logic csr_timed_out_operation; // 1 for write, 0 for read.
    logic[63:0] csr_timed_out_address;
    always_ff @(posedge clk) begin
        if ((state == NORMAL) & write_timeout) begin
            csr_timed_out_operation <= 1;
            csr_timed_out_address <= write_watchdog_timer_timed_out_address;
        end else if ((state == NORMAL) & read_timeout) begin
            csr_timed_out_operation <= 0;
            csr_timed_out_address <= read_watchdog_timer_timed_out_address;
        end else begin
            csr_timed_out_operation <= csr_timed_out_operation;
            csr_timed_out_address <= csr_timed_out_address;
        end
    end

    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            csr_rvalid <= 0;
        else begin
            if (csr_read_address_ready) begin
                csr_rvalid <= 1;

                csr_rresp <= 2'b10; // SLVERR.
                if (state == SLAVE_DEAD) begin
                    if (csr_araddr[3:2] == 2'b01) begin // address=0x4.
                        csr_rdata <= csr_timed_out_operation;
                        csr_rresp <= 2'b00;
                    end else if (csr_araddr[3:2] == 2'b10) begin // address=0x8.
                        csr_rdata <= csr_timed_out_address[31:0];
                        csr_rresp <= 2'b00;
                    end else if (csr_araddr[3:2] == 2'b11) begin // address=0xc.
                        csr_rdata <= csr_timed_out_address[63:32];
                        csr_rresp <= 2'b00;
                    end
                end
            end else if (csr_rready)
                csr_rvalid <= 0;
        end
    end

    // Interrupt.
    assign irq = state == SLAVE_DEAD;

    // State machine.
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            state <= NORMAL;
        else begin
            if ((state == NORMAL) & (write_timeout | read_timeout))
                state <= SLAVE_DEAD;
            else if ((state == SLAVE_DEAD) & slave_has_been_reset)
                state <= SLAVE_RESURRECTED;
            else if ((state == SLAVE_RESURRECTED) & ~s_awready & ~s_wready & ~s_bvalid & ~s_rvalid) // `s_rready` will never be asserted during `SLAVE_RESURRECTED`.
                state <= NORMAL;
            else
                state <= state;
        end
    end

    // Submodules.

    // These gatekeepers not only gate `valid`, but `ready` as well. This is
    // especially important during `SLAVE_RESURRECTED`.
    //
    // During `SLAVE_RESURRECTED`, no new writes commands will be accepted.
    // Write addresses may only be accept during this state if more write data
    // had been accepted before this (i.e. these write data have no matching
    // write addresses yet). The same is true the other way around.
    altera_axi_timeout_bridge_gatekeeper write_address_gatekeeper (
        .sink_valid  (s_awvalid),
        .sink_ready  (s_awready),

        .source_valid(awvalid0),
        .source_ready(awready0),

        .pass_through(state == SLAVE_RESURRECTED ? accepted_fewer_write_addresses_than_first_data : max_oustanding_write_address_unhit)
    );

    altera_axi_timeout_bridge_gatekeeper write_data_gatekeeper (
        .sink_valid  (s_wvalid),
        .sink_ready  (s_wready),

        .source_valid(wvalid0),
        .source_ready(wready0),

        .pass_through(state == SLAVE_RESURRECTED ? accepted_fewer_first_write_data_than_addresses | write_data_in_progress : max_oustanding_write_data_unhit)
    );

    // During `SLAVE_RESURRECTED`, no new read commands will be accepted.
    altera_axi_timeout_bridge_gatekeeper read_address_gatekeeper (
        .sink_valid  (s_arvalid),
        .sink_ready  (s_arready),

        .source_valid(arvalid0),
        .source_ready(arready0),

        .pass_through(state == SLAVE_RESURRECTED ? 1'b0 : max_oustanding_read_address_unhit)
    );

    logic[TIMESTAMP_WIDTH - 1:0] timestamp;
    altera_axi_timeout_bridge_free_running_counter#(
        .NUM_COUNTS(MAX_CYCLES)
    ) free_running_counter (
        .clk  (clk),
        .reset(reset),

        .count(timestamp)
    );

    // A write has started when an address is issued (first cycle of `awvalid`),
    // even if a data of the same burst got issued (first cycle of `wvalid`)
    // before the address.
    logic write_started;
    altera_axi_timeout_bridge_first_valid_cycle_monitor write_started_monitor(
        .clk(clk),
        .reset(reset),

        .valid(awvalid0),
        .ready(awready0),

        .first_valid_cycle(write_started)
    );

    // A write has ended when the response is issued (first cycle of `bvalid`).
    logic write_ended;
    altera_axi_timeout_bridge_first_valid_cycle_monitor write_ended_monitor(
        .clk(clk),
        .reset(reset),

        .valid(s_bvalid),
        .ready(s_bready),

        .first_valid_cycle(write_ended)
    );

    altera_axi_timeout_bridge_watchdog_timer#(
        .ADDRESS_WIDTH         (ADDRESS_WIDTH),
        .MAX_OUTSTANDING_BURSTS(MAX_OUTSTANDING_WRITES),
        .MAX_CYCLES            (MAX_CYCLES)
    ) write_watchdog_timer (
        .clk              (clk),
        .reset            (reset),

        .timestamp        (timestamp),

        .burst_started    (write_started),
        .address          (s_awaddr),

        .burst_ended      (write_ended),

        .timeout          (write_timeout),
        .timed_out_address(write_watchdog_timer_timed_out_address)
    );

    // A read has started when an address is issued (first cycle of `arvalid`).
    logic read_started;
    altera_axi_timeout_bridge_first_valid_cycle_monitor read_started_monitor(
        .clk(clk),
        .reset(reset),

        .valid(arvalid0),
        .ready(arready0),

        .first_valid_cycle(read_started)
    );

    // A read has ended when the last data is issued (first cycle of
    // `rvalid & rlast`).
    logic read_ended;
    altera_axi_timeout_bridge_first_valid_cycle_monitor read_ended_monitor(
        .clk(clk),
        .reset(reset),

        .valid(s_rvalid & s_rlast),
        .ready(s_rready),

        .first_valid_cycle(read_ended)
    );

    altera_axi_timeout_bridge_watchdog_timer#(
        .ADDRESS_WIDTH         (ADDRESS_WIDTH),
        .MAX_OUTSTANDING_BURSTS(MAX_OUTSTANDING_READS),
        .MAX_CYCLES            (MAX_CYCLES)
    ) read_watchdog_timer (
        .clk              (clk),
        .reset            (reset),

        .timestamp        (timestamp),

        .burst_started    (read_started),
        .address          (s_araddr),

        .burst_ended      (read_ended),

        .timeout          (read_timeout),
        .timed_out_address(read_watchdog_timer_timed_out_address)
    );

    // This error responder sees exactly the same bursts as the master interface
    // during `NORMAL` mode. This is so that once a timeout happens, it knows:
    // * How many bursts are outstanding.
    // * The outstanding IDs.
    // * How many transfers of write data are yet to be accepted (if the timeout
    //   occurs halfway between a write burst).
    // * How many transfers of read data are yet to be issued (if the timeout
    //   occurs halfway between a read burst).
    //
    // For discussion's sake, an alternative would be to route commands to the
    // error responder after a timeout (it will be idle during `NORMAL` mode).
    // E.g. a read of length 8 had 2 transfers of data passed through already
    // before a timeout; a read of length 6 should be sent to the error
    // responder, so that it would generate the 6 remaining data transfers. As
    // one can see, there are many more complications like that to be dealt with
    // using this approach, which was why it wasn't chosen.
    altera_axi_timeout_bridge_error_responder#(
        .ID_WIDTH                   (ID_WIDTH),
        .DATA_WIDTH                 (DATA_WIDTH),
        .USER_WIDTH                 (USER_WIDTH),
        .WRITE_ACCEPTANCE_CAPABILITY(MAX_OUTSTANDING_WRITES),
        .READ_ACCEPTANCE_CAPABILITY (MAX_OUTSTANDING_READS)
    ) error_responder (
        .clk    (clk),
        .reset  (reset),

        .awid   (s_awid),
        .awvalid(awvalid0 & awready0),
        .awready(max_oustanding_write_address_unhit),

        .wlast  (s_wlast),
        .wvalid (wvalid0 & wready0),
        .wready (max_oustanding_write_data_unhit),

        .bid    (s_bid),
        .bresp  (error_responder_bresp),
        .buser  (error_responder_buser),
        .bvalid (error_responder_bvalid),
        .bready (s_bvalid & s_bready),

        .arid   (s_arid),
        .arlen  (s_arlen),
        .arvalid(arvalid0 & arready0),
        .arready(max_oustanding_read_address_unhit),

        .rid    (s_rid),
        .rdata  (error_responder_rdata),
        .rresp  (error_responder_rresp),
        .rlast  (s_rlast),
        .ruser  (error_responder_ruser),
        .rvalid (error_responder_rvalid),
        .rready (s_rvalid & s_rready)
    );

    // Helpers.

    // This is needed at the write response channel, during the transition from
    // `NORMAL` to `SLAVE_DEAD`. When a write timed out, a valid write response
    // from the slave should continue to be passed through to the master. We
    // save a few registers for storing `m_bresp` and `m_buser` this way.
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            write_response_issued_before_timeout_but_unaccepted <= 0;
        else begin
            if (s_bready)
                write_response_issued_before_timeout_but_unaccepted <= 0;
            else if ((state == NORMAL) & s_bvalid)
                write_response_issued_before_timeout_but_unaccepted <= 1;
            else
                write_response_issued_before_timeout_but_unaccepted <= write_response_issued_before_timeout_but_unaccepted;
        end
    end

    // This is needed at the read data channel, during the transition from
    // `NORMAL` to `SLAVE_DEAD`. When a read timed out, a valid read data from
    // the slave should continue to be passed through to the master. We
    // save a few registers for storing `m_rdata` `m_rresp` and `m_ruser` this
    // way.
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            read_data_issued_before_timeout_but_unaccepted <= 0;
        else begin
            if (s_rready)
                read_data_issued_before_timeout_but_unaccepted <= 0;
            else if ((state == NORMAL) & s_rvalid)
                read_data_issued_before_timeout_but_unaccepted <= 1;
            else
                read_data_issued_before_timeout_but_unaccepted <= read_data_issued_before_timeout_but_unaccepted;
        end
    end

    logic[$clog2(MAX_OUTSTANDING_WRITES + 1) - 1:0] num_outstanding_write_addresses;
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            num_outstanding_write_addresses <= 0;
        else
            num_outstanding_write_addresses <= num_outstanding_write_addresses + (s_awvalid & s_awready) - (s_bvalid & s_bready);
    end

    logic first_write_data;
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            first_write_data <= 1;
        else begin
            if (s_wvalid & s_wready) begin
                if (s_wlast)
                    first_write_data <= 1;
                else
                    first_write_data <= 0;
            end else
                first_write_data <= first_write_data;
        end
    end

    logic[$clog2(MAX_OUTSTANDING_WRITES + 1) - 1:0] num_outstanding_first_write_data;
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            num_outstanding_first_write_data <= 0;
        else
            num_outstanding_first_write_data <= num_outstanding_first_write_data + (s_wvalid & s_wready & first_write_data) - (s_bvalid & s_bready);
    end

    always_ff @(posedge clk)
        accepted_fewer_write_addresses_than_first_data <= num_outstanding_write_addresses + (s_awvalid & s_awready) < num_outstanding_first_write_data + (s_wvalid & s_wready & first_write_data);

    always_ff @(posedge clk)
        accepted_fewer_first_write_data_than_addresses <= num_outstanding_first_write_data + (s_wvalid & s_wready & first_write_data) < num_outstanding_write_addresses + (s_awvalid & s_awready);

    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            write_data_in_progress <= 0;
        else begin
            if (s_wvalid & s_wready & s_wlast)
                write_data_in_progress <= 0;
            else if (s_wvalid & s_wready & first_write_data)
                write_data_in_progress <= 1;
            else
                write_data_in_progress <= write_data_in_progress;
        end
    end
endmodule

// Much like the AXI error response slave we have today, except with unused
// ports discarded and it supports multiple outstanding bursts.
//
// `awready`, `wready` and `arready` will be asserted as long as their
// respective acceptance capabilities are not hit.
//
// `bvalid` and `rvalid` will be asserted as soon as a response can be issued.
module altera_axi_timeout_bridge_error_responder#(
    int ID_WIDTH                    = 1,
    int DATA_WIDTH                  = 8,
    int USER_WIDTH                  = 1,
    int WRITE_ACCEPTANCE_CAPABILITY = 1,
    int READ_ACCEPTANCE_CAPABILITY  = 1
)(
    input logic                    clk,
    input logic                    reset,

    input logic[ID_WIDTH - 1:0]    awid,
    input logic                    awvalid,
    output logic                   awready,

    input logic                    wlast,
    input logic                    wvalid,
    output logic                   wready,

    output logic[ID_WIDTH - 1:0]   bid,
    output logic[1:0]              bresp,
    output logic[USER_WIDTH - 1:0] buser,
    output logic                   bvalid,
    input logic                    bready,

    input logic[ID_WIDTH - 1:0]    arid,
    input logic[7:0]               arlen,
    input logic                    arvalid,
    output logic                   arready,

    output logic[ID_WIDTH - 1:0]   rid,
    output logic[DATA_WIDTH - 1:0] rdata,
    output logic[1:0]              rresp,
    output logic                   rlast,
    output logic[USER_WIDTH - 1:0] ruser,
    output logic                   rvalid,
    input logic                    rready
);
    // Write channels.
    logic[ID_WIDTH - 1:0] write_address_fifo_source_awid;
    logic write_address_fifo_source_valid;
    altera_axi_timeout_bridge_fifo#(
        .DATA_WIDTH(ID_WIDTH),
        .DEPTH     (WRITE_ACCEPTANCE_CAPABILITY)
    ) write_address_fifo (
        .clk         (clk),
        .reset       (reset),

        .sink_data   (awid),
        .sink_valid  (awvalid),
        .sink_ready  (awready),

        .source_data (write_address_fifo_source_awid),
        .source_valid(write_address_fifo_source_valid),
        .source_ready(bvalid & bready)
    );

    logic[$clog2(WRITE_ACCEPTANCE_CAPABILITY + 1) - 1:0] num_outstanding_last_write_data;
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            num_outstanding_last_write_data <= 0;
        else
            num_outstanding_last_write_data <= num_outstanding_last_write_data + (wvalid & wready & wlast) - (bvalid & bready);
    end

    assign wready = num_outstanding_last_write_data < WRITE_ACCEPTANCE_CAPABILITY;
    assign bvalid = num_outstanding_last_write_data > 0 & write_address_fifo_source_valid;

    assign bid = write_address_fifo_source_awid;
    assign bresp = 2'b10;
    assign buser = '1;

    // Read channels.
    logic[ID_WIDTH - 1:0] read_address_fifo_source_arid;
    logic[7:0] read_address_fifo_source_arlen;
    altera_axi_timeout_bridge_fifo#(
        .DATA_WIDTH(ID_WIDTH + 8),
        .DEPTH     (READ_ACCEPTANCE_CAPABILITY)
    ) read_address_fifo (
        .clk         (clk),
        .reset       (reset),

        .sink_data   ({arid, arlen}),
        .sink_valid  (arvalid),
        .sink_ready  (arready),

        .source_data ({read_address_fifo_source_arid, read_address_fifo_source_arlen}),
        .source_valid(rvalid),
        .source_ready(rvalid & rready & rlast)
    );

    logic first_read_data;
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            first_read_data <= 1;
        else begin
            if (rvalid & rready) begin
                if (rlast)
                    first_read_data <= 1;
                else
                    first_read_data <= 0;
            end else
                first_read_data <= first_read_data;
        end
    end

    logic[7:0] num_outstanding_data;
    logic[7:0] num_outstanding_data_decremented;
    assign num_outstanding_data = first_read_data ? read_address_fifo_source_arlen : num_outstanding_data_decremented;
    always_ff @(posedge clk) begin
        if (rvalid & rready)
            num_outstanding_data_decremented <= num_outstanding_data - 1'b1;
        else
            num_outstanding_data_decremented <= num_outstanding_data_decremented;
    end

    assign rid = read_address_fifo_source_arid;
    assign rdata = '1;
    assign rresp = 2'b10;
    assign rlast = num_outstanding_data == '0;
    assign ruser = '1;
endmodule

// A simple wrapper of the complicated `altera_avalon_sc_fifo`.
module altera_axi_timeout_bridge_fifo#(
    int DATA_WIDTH = 1,
    int DEPTH      = 1
)(
    input logic                    clk,
    input logic                    reset,

    input logic[DATA_WIDTH - 1:0]  sink_data,
    input logic                    sink_valid,
    output logic                   sink_ready,

    output logic[DATA_WIDTH - 1:0] source_data,
    output logic                   source_valid,
    input logic                    source_ready
);
    altera_avalon_sc_fifo#(
        .DATA_WIDTH       (DATA_WIDTH),
        .EMPTY_LATENCY    (1),
        .FIFO_DEPTH       (DEPTH),
        .USE_MEMORY_BLOCKS(0)
    ) fifo (
        .clk              (clk),
        .reset            (reset),

        .in_data          (sink_data),
        .in_valid         (sink_valid),
        .in_ready         (sink_ready),

        .out_data         (source_data),
        .out_valid        (source_valid),
        .out_ready        (source_ready),

        // Terminated.
        .almost_empty_data(),
        .almost_full_data (),
        .csr_address      ('0),
        .csr_read         ('0),
        .csr_readdata     (),
        .csr_write        ('0),
        .csr_writedata    ('0),
        .in_channel       ('0),
        .in_empty         ('0),
        .in_endofpacket   ('0),
        .in_error         ('0),
        .in_startofpacket ('0),
        .out_channel      (),
        .out_empty        (),
        .out_endofpacket  (),
        .out_error        (),
        .out_startofpacket()
    );

// synthesis translate_off
    // These are application specific assertions only. A normal fifo should not
    // have them.
    assert property (@(posedge clk) disable iff (reset) sink_valid |-> sink_ready);
    assert property (@(posedge clk) disable iff (reset) source_ready |-> source_valid);
// synthesis translate_on
endmodule

// Monitors `valid` and `ready`, and asserts `first_valid_cycle` at the first
// cycle of a valid beat.
module altera_axi_timeout_bridge_first_valid_cycle_monitor(
    input logic  clk,
    input logic  reset,

    input logic  valid,
    input logic  ready,

    output logic first_valid_cycle
);
    logic first_valid_cycle_expected;
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            first_valid_cycle_expected <= 1;
        else begin
            if (ready)
                first_valid_cycle_expected <= 1;
            else if (valid)
                first_valid_cycle_expected <= 0;
            else
                first_valid_cycle_expected <= first_valid_cycle_expected;
        end
    end

    assign first_valid_cycle = valid & first_valid_cycle_expected;
endmodule

// Counts 0, 1, ..., `NUM_COUNTS` - 1, 0, 1, ... forever.
module altera_axi_timeout_bridge_free_running_counter#(
    int NUM_COUNTS  = 1,

    // Derived.
    int COUNT_WIDTH = $clog2(NUM_COUNTS)
)(
    input logic                     clk,
    input logic                     reset,

    output logic[COUNT_WIDTH - 1:0] count
);
    typedef logic[COUNT_WIDTH - 1:0] count_t;

    always @(posedge clk, posedge reset) begin
        if (reset)
            count <= 0;
        else begin
            if (count == count_t'(NUM_COUNTS - 1))
                count <= 0;
            else
                count <= count + 1'b1;
        end
    end
endmodule

// Gates the `valid` as well as `ready` signals.
module altera_axi_timeout_bridge_gatekeeper(
    input logic  sink_valid,
    output logic sink_ready,

    output logic source_valid,
    input logic  source_ready,

    input logic  pass_through
);
    assign sink_ready = source_ready & pass_through;
    assign source_valid = sink_valid & pass_through;
endmodule

// This timer is to be notified at the start and end of a burst. When a burst
// has started, the timestamp and its address are recorded. If the burst does
// not end within `MAX_CYCLES` number of cycles (exclusive of the cycle it
// started), the timer times out.
//
// It supports up to `MAX_OUTSTANDING_BURSTS` number of bursts.
//
// Once timed out, it asserts `timeout` and reports the address of the burst
// that caused the timeout with `timed_out_address`. Note: It does that for one
// cycle only.
//
// Assumption: The `timestamp` input is connected to a free running counter that
// counts from 0 up to `MAX_CYCLES` - 1 and then repeats itself. (The right
// thing to do is to instantiate the counter within this module. This is not
// done due to an optimisation - We have two timers that share the same
// counter.)
module altera_axi_timeout_bridge_watchdog_timer#(
    int ADDRESS_WIDTH          = 1,
    int MAX_OUTSTANDING_BURSTS = 1,
    int MAX_CYCLES             = 256,

    // Derived.
    int TIMESTAMP_WIDTH       = $clog2(MAX_CYCLES)
)(
    input logic                        clk,
    input logic                        reset,

    input logic[TIMESTAMP_WIDTH - 1:0] timestamp,

    input logic                        burst_started,
    input logic[ADDRESS_WIDTH - 1:0]   address,

    input logic                        burst_ended,

    output logic                       timeout,
    output logic[ADDRESS_WIDTH - 1:0]  timed_out_address
);
    // Internally, we are using a fifo to store the records - Enqueue at the
    // start of a burst, dequeue at the end of a burst.
    logic[TIMESTAMP_WIDTH - 1:0] fifo_source_timestamp;
    logic fifo_source_valid;
    altera_axi_timeout_bridge_fifo#(
        .DATA_WIDTH(TIMESTAMP_WIDTH + ADDRESS_WIDTH),
        .DEPTH     (MAX_OUTSTANDING_BURSTS)
    ) fifo (
        .clk         (clk),
        .reset       (reset),

        .sink_data   ({timestamp, address}),
        .sink_ready  (), // Terminated.
        .sink_valid  (burst_started),

        .source_data ({fifo_source_timestamp, timed_out_address}),
        .source_valid(fifo_source_valid),
        .source_ready(burst_ended)
    );

    // We are always looking at the front of the queue only (notice how
    // beautifully this works out). If the recorded timestamp equals to the
    // current time (we've looped through the counter once, or in other words,
    // `MAX_CYCLES` number of cycles have gone by), time out!
    assign timeout = fifo_source_valid & fifo_source_timestamp == timestamp & ~burst_ended;
endmodule
