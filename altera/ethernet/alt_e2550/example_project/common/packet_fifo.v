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


module packet_fifo #(
    parameter WIDTH     = 32,
    parameter SC_DEPTH  = 16,
    parameter DC_DEPTH  = 16
) (
    input               async_reset,

    input               clk_in,
    input  [WIDTH-1:0]  din,
    input               sop_in,
    input               eop_in,
    input  [2:0]        empty_in,
    input               valid_in,
    output              full,
    output reg          block_dropped,

    input               clk_out,
    output [WIDTH-1:0]  dout,
    output              sop_out,
    output              eop_out,
    output [2:0]        empty_out,
    output              valid_out,
    input               accepted
);

    wire resetn_sync_in;
    reset_synchronizer rs_in (
        .clk         (clk_in),
        .resetn      (~async_reset),
        .resetn_sync (resetn_sync_in)
    );

    wire resetn_sync_out;
    reset_synchronizer rs_out (
        .clk         (clk_out),
        .resetn      (~async_reset),
        .resetn_sync (resetn_sync_out)
    );

    wire scfifo_full;
    wire dcfifo_empty;
    wire [WIDTH+5-1:0] fifo_to_fifo_data;
    wire [WIDTH+5-1:0] din_to_fifo = {empty_in, sop_in, eop_in, din};
    wire dcfifo_read = !dcfifo_empty && !scfifo_full;
    wire dcfifo_write = valid_in && !full;

    dual_clock_fifo #(
        .WIDTH      (WIDTH+5),  // two extra bits for eop, eop, and empty
        .DEPTH      (DC_DEPTH)
    ) dcf (
        .areset     (async_reset),
        .write_clk  (clk_in),
        .write_data (din_to_fifo),
        .write      (dcfifo_write),
        .read_clk   (clk_out),
        .read_data  (fifo_to_fifo_data),
        .read       (dcfifo_read),
        .empty      (dcfifo_empty),
        .full       (full)
    );

    // signal to indicate if new dcfifo data has
    // not yet been read by scfifo
    reg dcfifo_data_valid;
    wire scfifo_write = dcfifo_data_valid && !scfifo_full;
    always @(posedge clk_out) begin
        dcfifo_data_valid <= dcfifo_data_valid;
        if (resetn_sync_out == 0) begin
            dcfifo_data_valid <= 1'b0;
        end else begin
            if (dcfifo_read) begin
                dcfifo_data_valid <= 1'b1;
            end else begin
                if (scfifo_write) begin
                    dcfifo_data_valid <= 1'b0;
                end
            end
        end
    end

    localparam STOP = 1'b0, SEND = 1'b1;
    reg mode;

    wire scfifo_empty;
    wire scfifo_half_full;
    wire [WIDTH+5-1:0] scfifo_dout;
    //wire ok_to_send = ((mode_sync == SEND_DATA) || scfifo_half_full);
    wire scfifo_read = accepted && !scfifo_empty && (mode == SEND);
    //wire scfifo_read = accepted && !scfifo_empty && ok_to_send;
    sc_fifo #(
        .WIDTH      (WIDTH+5),  // two extra bits for eop and sop
        .DEPTH      (SC_DEPTH)
    ) scf (
        .clk        (clk_out),
        .reset      (~resetn_sync_out),
        .write      (scfifo_write),
        .write_data (fifo_to_fifo_data),
        .read       (scfifo_read),
        .read_data  (scfifo_dout),
        .empty      (scfifo_empty),
        .half_full  (scfifo_half_full),
        .full       (scfifo_full)
    );

    // signal to indicate if new scfifo data has
    // not yet been read by output
    reg scfifo_data_valid;
    always @(posedge clk_out) begin
        scfifo_data_valid <= scfifo_data_valid;
        if (resetn_sync_out == 0) begin
            scfifo_data_valid <= 1'b0;
        end else begin
            if (scfifo_read) begin
                scfifo_data_valid <= 1'b1;
            end else begin
                if (accepted) begin
                    scfifo_data_valid <= 1'b0;
                end
            end
        end
    end

    assign empty_out = scfifo_dout[WIDTH+4:WIDTH+2];
    assign sop_out   = scfifo_dout[WIDTH+1];
    assign eop_out   = scfifo_dout[WIDTH];
    assign dout      = scfifo_dout[WIDTH-1:0];
    assign valid_out = scfifo_data_valid;


    wire valid_eop_out = eop_out && valid_out && accepted;
    wire valid_eop_in =  fifo_to_fifo_data[WIDTH] && scfifo_write;

    wire [3:0] eop_count;
    ud_counter #(
        .WIDTH(4)
    ) eop_counter (
        .clk    (clk_out),
        .reset  (~resetn_sync_out),
        .incr   (valid_eop_in),
        .dec    (valid_eop_out),
        .count  (eop_count)
    );

    wire next_eop_count_zero = ((eop_count == 'd1) && !valid_eop_in && valid_eop_out);
    always @(posedge clk_out) begin
        mode <= mode;
        if (resetn_sync_out == 0) begin
            mode <= STOP;
        end else begin
            case (mode)
                STOP: begin
                    if (scfifo_half_full || (eop_count > 0)) mode <= SEND;
                end
                SEND: begin
                    if (!scfifo_half_full) begin
                        if (next_eop_count_zero) begin
                            mode <= STOP;
                        end
                    end
                end
            endcase
        end
    end
    
    // Signal goes high when a block is dropped when
    // the DC fifo if full
    always @(posedge clk_in) begin
        block_dropped <= valid_in && full;
    end
endmodule
