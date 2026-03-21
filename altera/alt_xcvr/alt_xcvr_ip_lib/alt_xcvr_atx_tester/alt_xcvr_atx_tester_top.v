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


//-------------------------------------------------------------------
// Filename    : alt_xcvr_atx_tester_top.v
//
// Description : Tester for ATX PLL
//
// In your system, you must interface the tester IP with an ATX PLL and a 
// standard frequency checker. 
// 
// Test procedure:
//
// - On global test reset (test_reset=1), reset the PLL under test
//   (pll_powerdown=1).
// - Wait for the PLL to lock (pll_locked=1)
// - Start the frequency checker (start_freq_check=1)
// - Wait for the frequency checker to complete frequency measurement
//   (freq_measured=1)
// - Compare measured frequency against the golden frequency
//   (EXPECTED_FREQUENCY)  
// - Assert pass=1 on success, pass=0 on failure.
//
// Limitation  : None
//
// Authors     : dunnikri
//
//
// Copyright (c) Altera Corporation 1997-2013
// All rights reserved
//
//-------------------------------------------------------------------

module alt_xcvr_atx_tester_top #(
    parameter EXPECTED_TX_SERIAL_CLOCK_FREQ=100, //expected measured frequency on PLL lock
    parameter TOLERANCE=2,             //expected measured frequency tolerance (MHz)
    parameter MEASURE_TX_SERIAL=0,
    parameter MEASURE_TX_BONDED=0,
    parameter TEST_PCIE_SW=0,
    parameter PMA_WIDTH=8,
    parameter MCGB_DIV=1
) (
    input         test_clk,
    input         test_reset,        // global test reset
    output reg    pll_powerdown,     // pll powerdown (connect to PLL under test)
    output reg    mcgb_rst,          // master CGB reset
    output reg    pcie_sw,           // to test pcie switching
    input         pll_locked,        // pll locked signal (connect to PLL under test)
    output reg    start_freq_check,  // initiate frequency check (connect to frequency checker)
    input [1:0]   pcie_sw_done,      // status from pcie switching
    input [15:0]  clkout_freq_tx_serial, // measured frequency (connect to frequency checker)
    input [(16*6)-1:0] clkout_freq_tx_bonded,
    input         freq_measured_tx_serial,     // status that indicates frequency measurement complete (connect to frequency checker)
    input [5:0]   freq_measured_tx_bonded,  
    output reg    pass               // pass signal
);

//calculate log2
function integer log2;
    input integer number;
    begin
        log2=0;
        while(2**log2<number) begin
            log2=log2+1;
        end
    end
endfunction // log2

localparam EXPECTED_TX_SERIAL_LO_CLOCK_FREQ=EXPECTED_TX_SERIAL_CLOCK_FREQ-TOLERANCE;
localparam EXPECTED_TX_SERIAL_HI_CLOCK_FREQ=EXPECTED_TX_SERIAL_CLOCK_FREQ+TOLERANCE;

//bonded clock 5
localparam EXPECTED_TX_BONDED_5_CLOCK_FREQ = EXPECTED_TX_SERIAL_CLOCK_FREQ/MCGB_DIV;
localparam EXPECTED_TX_BONDED_5_LO_CLOCK_FREQ=EXPECTED_TX_BONDED_5_CLOCK_FREQ-TOLERANCE;
localparam EXPECTED_TX_BONDED_5_HI_CLOCK_FREQ=EXPECTED_TX_BONDED_5_CLOCK_FREQ+TOLERANCE;

//bonded clock 4
localparam EXPECTED_TX_BONDED_4_CLOCK_FREQ = EXPECTED_TX_BONDED_5_CLOCK_FREQ; 
localparam EXPECTED_TX_BONDED_4_LO_CLOCK_FREQ=EXPECTED_TX_BONDED_4_CLOCK_FREQ-TOLERANCE;
localparam EXPECTED_TX_BONDED_4_HI_CLOCK_FREQ=EXPECTED_TX_BONDED_4_CLOCK_FREQ+TOLERANCE;

//lfclk0
localparam EXPECTED_TX_BONDED_3_CLOCK_FREQ = PMA_WIDTH == 64  ?  (EXPECTED_TX_BONDED_5_CLOCK_FREQ/2) :
                                             PMA_WIDTH == 40  ?  (EXPECTED_TX_BONDED_5_CLOCK_FREQ/2) :
                                             PMA_WIDTH == 32  ?  (EXPECTED_TX_BONDED_5_CLOCK_FREQ/2) :
                                             PMA_WIDTH == 20  ?  (EXPECTED_TX_BONDED_5_CLOCK_FREQ/2) :
                                             PMA_WIDTH == 16  ?  (EXPECTED_TX_BONDED_5_CLOCK_FREQ/2) :
                                             PMA_WIDTH == 10  ?  (EXPECTED_TX_BONDED_5_CLOCK_FREQ/1) :
                                             PMA_WIDTH == 8   ?  (EXPECTED_TX_BONDED_5_CLOCK_FREQ/1) :
                                                                 (EXPECTED_TX_BONDED_5_CLOCK_FREQ/4) ; // default is selected for failure
localparam EXPECTED_TX_BONDED_3_LO_CLOCK_FREQ=EXPECTED_TX_BONDED_3_CLOCK_FREQ-TOLERANCE;
localparam EXPECTED_TX_BONDED_3_HI_CLOCK_FREQ=EXPECTED_TX_BONDED_3_CLOCK_FREQ+TOLERANCE;

//lfclk1
localparam EXPECTED_TX_BONDED_2_CLOCK_FREQ = PMA_WIDTH == 64  ?  ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(2)) :
                                             PMA_WIDTH == 40  ?  ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(2)) :
                                             PMA_WIDTH == 32  ?  ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(2)) :
                                             PMA_WIDTH == 20  ?  ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(1)) :
                                             PMA_WIDTH == 16  ?  ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(1)) :
                                             PMA_WIDTH == 10  ?  ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(1)) :
                                             PMA_WIDTH == 8   ?  ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(1)) :
                                                                 ((EXPECTED_TX_BONDED_3_CLOCK_FREQ)/(4)) ; // default is selected for failure
localparam EXPECTED_TX_BONDED_2_LO_CLOCK_FREQ=EXPECTED_TX_BONDED_2_CLOCK_FREQ-TOLERANCE;
localparam EXPECTED_TX_BONDED_2_HI_CLOCK_FREQ=EXPECTED_TX_BONDED_2_CLOCK_FREQ+TOLERANCE;

//cpulse
localparam EXPECTED_TX_BONDED_1_CLOCK_FREQ = PMA_WIDTH == 64  ?  (EXPECTED_TX_BONDED_2_CLOCK_FREQ/4) :
                                             PMA_WIDTH == 40  ?  (EXPECTED_TX_BONDED_2_CLOCK_FREQ/5) :
                                             PMA_WIDTH == 32  ?  (EXPECTED_TX_BONDED_2_CLOCK_FREQ/4) :
                                             PMA_WIDTH == 20  ?  (EXPECTED_TX_BONDED_2_CLOCK_FREQ/5) :
                                             PMA_WIDTH == 16  ?  (EXPECTED_TX_BONDED_2_CLOCK_FREQ/4) :
                                             PMA_WIDTH == 10  ?  (EXPECTED_TX_BONDED_2_CLOCK_FREQ/5) :
                                             PMA_WIDTH == 8   ?  (EXPECTED_TX_BONDED_2_CLOCK_FREQ/4) :
                                                                 (EXPECTED_TX_BONDED_2_CLOCK_FREQ/6) ; // default is selected for failure
localparam EXPECTED_TX_BONDED_1_LO_CLOCK_FREQ=EXPECTED_TX_BONDED_1_CLOCK_FREQ-TOLERANCE;
localparam EXPECTED_TX_BONDED_1_HI_CLOCK_FREQ=EXPECTED_TX_BONDED_1_CLOCK_FREQ+TOLERANCE;

//pclk
localparam EXPECTED_TX_BONDED_0_CLOCK_FREQ = PMA_WIDTH == 64  ?  ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/2)) :
                                             PMA_WIDTH == 40  ?  ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/1)) :
                                             PMA_WIDTH == 32  ?  ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/1)) :
                                             PMA_WIDTH == 20  ?  ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/1)) :
                                             PMA_WIDTH == 16  ?  ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/1)) :
                                             PMA_WIDTH == 10  ?  ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/1)) :
                                             PMA_WIDTH == 8   ?  ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/1)) :
                                                                 ((EXPECTED_TX_BONDED_1_CLOCK_FREQ/2)) ; // default is selected for failure
localparam EXPECTED_TX_BONDED_0_LO_CLOCK_FREQ=EXPECTED_TX_BONDED_0_CLOCK_FREQ-TOLERANCE;
localparam EXPECTED_TX_BONDED_0_HI_CLOCK_FREQ=EXPECTED_TX_BONDED_0_CLOCK_FREQ+TOLERANCE;

localparam NUM_STATES       =3;
localparam IDLE             =0;
localparam PLL_LOCK         =1;
localparam DONE             =2;

reg pll_powerdown_next;
reg mcgb_rst_next;
reg start_freq_check_next;
reg pass_next;
reg [log2(NUM_STATES)-1:0] state, state_next;
wire pass_condition_met;
wire pass_tx_serial;
wire [5:0] pass_tx_bonded;



freq_validate #(
    .EXPECTED_LO_FREQ(EXPECTED_TX_SERIAL_LO_CLOCK_FREQ),
    .EXPECTED_HI_FREQ(EXPECTED_TX_SERIAL_HI_CLOCK_FREQ)
) freq_validate_tx_serial (
    .clk(test_clk),
    .reset(test_reset),
    .validate(freq_measured_tx_serial),
    .freq_val(clkout_freq_tx_serial),
    .pass(pass_tx_serial)
);

genvar i;
generate
    if(MEASURE_TX_BONDED) begin
        freq_validate #(
            .EXPECTED_LO_FREQ(EXPECTED_TX_BONDED_0_LO_CLOCK_FREQ),
            .EXPECTED_HI_FREQ(EXPECTED_TX_BONDED_0_HI_CLOCK_FREQ)
        ) freq_validate_tx_bonded_0 (
            .clk(test_clk),
            .reset(test_reset),
            .validate(freq_measured_tx_bonded[0]),
            .freq_val(clkout_freq_tx_bonded[(1*16)-1:0*16]),
            .pass(pass_tx_bonded[0])
        );

        freq_validate #(
            .EXPECTED_LO_FREQ(EXPECTED_TX_BONDED_1_LO_CLOCK_FREQ),
            .EXPECTED_HI_FREQ(EXPECTED_TX_BONDED_1_HI_CLOCK_FREQ)
        ) freq_validate_tx_bonded_1 (
            .clk(test_clk),
            .reset(test_reset),
            .validate(freq_measured_tx_bonded[1]),
            .freq_val(clkout_freq_tx_bonded[(2*16)-1:1*16]),
            .pass(pass_tx_bonded[1])
        );

        freq_validate #(
            .EXPECTED_LO_FREQ(EXPECTED_TX_BONDED_2_LO_CLOCK_FREQ),
            .EXPECTED_HI_FREQ(EXPECTED_TX_BONDED_2_HI_CLOCK_FREQ)
        ) freq_validate_tx_bonded_2 (
            .clk(test_clk),
            .reset(test_reset),
            .validate(freq_measured_tx_bonded[2]),
            .freq_val(clkout_freq_tx_bonded[(3*16)-1:2*16]),
            .pass(pass_tx_bonded[2])
        );

        freq_validate #(
            .EXPECTED_LO_FREQ(EXPECTED_TX_BONDED_3_LO_CLOCK_FREQ),
            .EXPECTED_HI_FREQ(EXPECTED_TX_BONDED_3_HI_CLOCK_FREQ)
        ) freq_validate_tx_bonded_3 (
            .clk(test_clk),
            .reset(test_reset),
            .validate(freq_measured_tx_bonded[3]),
            .freq_val(clkout_freq_tx_bonded[(4*16)-1:3*16]),
            .pass(pass_tx_bonded[3])
        );

        freq_validate #(
            .EXPECTED_LO_FREQ(EXPECTED_TX_BONDED_4_LO_CLOCK_FREQ),
            .EXPECTED_HI_FREQ(EXPECTED_TX_BONDED_4_HI_CLOCK_FREQ)
        ) freq_validate_tx_bonded_4 (
            .clk(test_clk),
            .reset(test_reset),
            .validate(freq_measured_tx_bonded[4]),
            .freq_val(clkout_freq_tx_bonded[(5*16)-1:4*16]),
            .pass(pass_tx_bonded[4])
        );

        freq_validate #(
            .EXPECTED_LO_FREQ(EXPECTED_TX_BONDED_5_LO_CLOCK_FREQ),
            .EXPECTED_HI_FREQ(EXPECTED_TX_BONDED_5_HI_CLOCK_FREQ)
        ) freq_validate_tx_bonded_5 (
            .clk(test_clk),
            .reset(test_reset),
            .validate(freq_measured_tx_bonded[5]),
            .freq_val(clkout_freq_tx_bonded[(6*16)-1:5*16]),
            .pass(pass_tx_bonded[5])
        );
    end
endgenerate

generate
    if(MEASURE_TX_SERIAL&MEASURE_TX_BONDED) begin
        assign pass_condition_met = pass_tx_serial&(&pass_tx_bonded);
    end 
    else if (MEASURE_TX_SERIAL) begin
        assign pass_condition_met = pass_tx_serial;
    end
    else if (MEASURE_TX_BONDED) begin
        assign pass_condition_met = &pass_tx_bonded;
    end
    else begin
       assign pass_condition_met = 1'b0; 
    end
endgenerate

always@(*) begin
    state_next = state;
    pll_powerdown_next = pll_powerdown;
    start_freq_check_next = start_freq_check;
    pass_next = pass;

    case(state)
        IDLE: begin
            if(test_reset) begin
                pll_powerdown_next = 1'b1;
                start_freq_check_next = 1'b0;
                mcgb_rst_next = 1'b1;
            end
            else begin
                $monitor ("@%d: PLL powerdown =%b", $realtime, pll_powerdown_next);                
                pll_powerdown_next = 1'b0;
                mcgb_rst_next = 1'b0;
                state_next = PLL_LOCK;
            end
        end

        PLL_LOCK: begin
            if(pll_locked) begin
                $monitor ("@%d: PLL lock =%b", $realtime, pll_locked);                
                start_freq_check_next = 1'b1;
                state_next = DONE;
            end 
        end

        DONE:begin
            if(pass_condition_met) begin
                 $monitor ("@%d: Pass condition met =%b", $realtime, pass_condition_met);                
                pass_next = 1'b1;
                state_next = IDLE;
            end
        end
    endcase
end

always@(posedge test_clk) begin
    if(test_reset) begin
        state <= IDLE;
        pll_powerdown <= 1'b1;
        mcgb_rst <= 1'b1;
        start_freq_check <= 1'b0;
        pass <= 1'b0;
    end
    else begin
        state <= state_next;
        pll_powerdown <= pll_powerdown_next;
        mcgb_rst <= mcgb_rst_next;
        start_freq_check <= start_freq_check_next;
        pass <= pass_next;
    end
end
endmodule
