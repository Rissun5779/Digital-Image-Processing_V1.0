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
// Filename    : alt_xcvr_basic_custom_tester_top.v
//
// Description : Tester for Basic/Custom 8G protocol
//
// In your system, you must interface the tester IP with
// - Native PHY configured in Basic/Custom 8G protocol
// - a PLL IP
// - a PRBS generator IP
// - a PRBS checker IP
// - a Bit slipper IP 
// - a frequency checker for TX
// - a frequency checker for RX
// 
// Test procedure:
//
// - On global reset (test_reset=1), assert PLL resets (mcgb_rst)
// - Wait for tx_ready and rx_ready to go high 
// - Initialize the channel alignment block for the configuration (bitslip,manual,sync sm)
// - Wait for channel alignment (channel_aligned=1)
// - Start PRBS generators, checkers, frequency checkers
// - Count verifier errors, frequency errors
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

module alt_xcvr_basic_custom_tester_top #(
    parameter CHANNELS=1,
    parameter DATA_WIDTH=16,
    parameter EN_SERIAL_LOOPBACK=1,
    parameter EXPECTED_TX_LO_FREQ=310,
    parameter EXPECTED_TX_HI_FREQ=315,
    parameter EXPECTED_RX_LO_FREQ=310,
    parameter EXPECTED_RX_HI_FREQ=315,
    parameter UNUSED_TX_DATA_WIDTH=1,
    parameter UNUSED_RX_DATA_WIDTH=1,
    parameter BYTE_SERIALIZE_X2_EN=0,
    parameter EN_8B10B=0,
    parameter TEST_TIMEOUT=100000 //test timeout in mgmt clock cycles
) (
    input                         clock,
    input                         reset,
    output                        mcgb_rst,
    output [UNUSED_TX_DATA_WIDTH-1:0] unused_tx_parallel_data,
    input  [UNUSED_RX_DATA_WIDTH-1:0] unused_rx_parallel_data,
    input  [CHANNELS-1:0]         prbs_data_gen_clk,
    input  [CHANNELS-1:0]         prbs_data_check_clk,
    output [CHANNELS-1:0]         start_freq_check_tx,
    output [CHANNELS-1:0]         start_freq_check_rx,
    output [CHANNELS-1:0]         start_bit_slip, 
    input  [CHANNELS-1:0]         channel_aligned,
    output [CHANNELS-1:0]         rx_set_locktodata,
    output [CHANNELS-1:0]         rx_set_locktoref,
    input  [CHANNELS-1:0]         rx_is_lockedtoref,
    input  [CHANNELS-1:0]         rx_is_lockedtodata,
    output [CHANNELS-1:0]         rx_seriallpbken,
    output [CHANNELS-1:0]         prbs_gen_insert_error,
    output [CHANNELS-1:0]         prbs_gen_insert_pause,
    output [CHANNELS-1:0]         prbs_gen_start,
    output [CHANNELS-1:0]         prbs_check_start,
    output [CHANNELS-1:0]         prbs_gen_reset,
    output [CHANNELS-1:0]         prbs_check_reset,
    input  [CHANNELS-1:0]         verifier_lock,
    input  [CHANNELS-1:0]         verifier_error,
    input  [CHANNELS-1:0]         txclkout_freq_measured,
    input  [CHANNELS-1:0]         rxclkout_freq_measured,
    input  [(16*CHANNELS)-1:0]    txclkout_freq,
    input  [(16*CHANNELS)-1:0]    rxclkout_freq,
    input  [CHANNELS-1:0]         tx_ready,
    input  [CHANNELS-1:0]         rx_ready,
    output [CHANNELS-1:0]         tx_enh_data_valid,
    output [(7*CHANNELS)-1:0]     tx_enh_bitslip,
    output [(5*CHANNELS)-1:0]     tx_std_bitslipboundarysel,
    output [(CHANNELS * DATA_WIDTH)-1:0]  ext_data_pattern,
    
    output pass 
);

function integer log2;
    input integer number;
    begin
        log2=0;
        while(2**log2<number) begin
            log2=log2+1;
        end
    end
endfunction // log2

reg test_finish;
reg [log2(TEST_TIMEOUT)-1:0] timeout;
wire [15:0] txclkout_freq_ch[CHANNELS-1:0];
wire [15:0] rxclkout_freq_ch[CHANNELS-1:0];
wire [CHANNELS-1:0] txfreq_pass;
wire [CHANNELS-1:0] rxfreq_pass;
wire [CHANNELS-1:0] int_pass;
reg [3:0] error_cnt = 4'b0000;   

wire [CHANNELS-1:0]  int_data_gen_check_reset;

assign mcgb_rst = reset; //for bonded PLL configurations

assign unused_tx_parallel_data = {UNUSED_TX_DATA_WIDTH{1'b0}};

genvar i;
generate
    for(i=0;i<CHANNELS;i=i+1) begin: ch_split
        assign txclkout_freq_ch[i] = txclkout_freq[16*(i+1)-1:(16*i)];
        assign rxclkout_freq_ch[i] = rxclkout_freq[16*(i+1)-1:(16*i)];
        assign txfreq_pass[i] = txclkout_freq_measured[i] ? (txclkout_freq_ch[i] >= EXPECTED_TX_LO_FREQ && txclkout_freq_ch[i] <= EXPECTED_TX_HI_FREQ) ? 1'b1 : 1'b0 : 1'b0; //LEEPING-HACK
        assign rxfreq_pass[i] = rxclkout_freq_measured[i] ? (rxclkout_freq_ch[i] >= EXPECTED_RX_LO_FREQ && rxclkout_freq_ch[i] <= EXPECTED_RX_HI_FREQ) ? 1'b1 : 1'b0 : 1'b0; //LEEPING-HACK  
        assign start_bit_slip[i] = tx_ready[i]&rx_ready[i];  
        assign int_pass[i] =  tx_ready[i] && rx_ready[i] && verifier_lock[i] && (!verifier_error[i]) && txfreq_pass[i] && rxfreq_pass[i];
        assign prbs_gen_start[i] = 1;
        assign prbs_check_start[i] = 1;
        assign prbs_gen_insert_error[i] = 0;
        assign prbs_gen_insert_pause[i] = 0;
        assign start_freq_check_tx[i] = tx_ready[i];
        assign start_freq_check_rx[i] = rx_ready[i];
        assign tx_enh_data_valid[i] = 1;
        //Static slip amount for testing std word aligner
        assign tx_std_bitslipboundarysel[i*5 +: 5] = 5'd5;
        //Static slip amount for testing enh bitslip
        assign tx_enh_bitslip[i*7 +: 7] = 7'd5;
        //Static data pattern for testing bitslip
        if (BYTE_SERIALIZE_X2_EN==1) begin
          if (EN_8B10B) begin
            assign ext_data_pattern[i*DATA_WIDTH +: DATA_WIDTH*8/9] = {(DATA_WIDTH*8/9){1'b1}} & 32'hBCBCBCBC;
            assign ext_data_pattern[(i*DATA_WIDTH + DATA_WIDTH*8/9) +:(DATA_WIDTH/9)] = {(DATA_WIDTH/9){1'b1}} & 4'hF;
          end else begin
            assign ext_data_pattern[i*DATA_WIDTH +: DATA_WIDTH/2] = {(DATA_WIDTH/2){1'b0}} | 20'hBC;
            assign ext_data_pattern[(i*DATA_WIDTH + DATA_WIDTH/2) +: (DATA_WIDTH/2)] = {(DATA_WIDTH/2){1'b0}} | 20'hBC;
          end
        end else begin
          assign ext_data_pattern[i*DATA_WIDTH +: DATA_WIDTH] = {DATA_WIDTH{1'b0}} | 8'hBC;
        end
        
        assign int_data_gen_check_reset[i] = tx_ready[i] && rx_ready[i];
        resync #(
           .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
           .INIT_VALUE        (1)
        ) wa_reset_txsync_inst(
           .clk                       (prbs_data_gen_clk[i]),
           .reset                     (!int_data_gen_check_reset[i]),
           .d                         (1'b0),
           .q                         (prbs_gen_reset[i])
        );
 
        resync #(
           .SYNC_CHAIN_LENGTH (2),  // Number of flip-flops for retiming
           .INIT_VALUE        (1)
        ) wa_reset_sync_inst(
           .clk                       (prbs_data_check_clk[i]),
           .reset                     (!int_data_gen_check_reset[i]),
           .d                         (1'b0),
           .q                         (prbs_check_reset[i])
        );
    end
endgenerate


generate
endgenerate

assign rx_set_locktodata = {CHANNELS{1'b0}};
assign rx_set_locktoref = {CHANNELS{1'b0}};
assign rx_seriallpbken = {CHANNELS{1'b0}};


assign pass = &int_pass && (error_cnt==0);


always @(verifier_lock) begin
   if (&verifier_lock)
   begin
      $display("Info: verifier lock is detected at %t\n", $realtime);
      //$fdisplay(reg_out_file, "Info: verifier lock is detected\n");		  
   end
end // always @ (verifier_lock)


always @(verifier_error) begin
    if (&verifier_lock) begin
        if (|verifier_error) begin	
            $display("Error: data_error is detected at %t, PRBS Checker detected the error\n", $realtime);
            //$fdisplay(reg_out_file,"Error: data_error is detected, PRBS Checker detected the error\n", $realtime);
 	            error_cnt = error_cnt +1;
          end	     				    
    end
end


//always @(posedge pass) begin
//    if (pass && error_cnt == 4'b0000) begin
//        $display ("Test case passed\nSimulation passed");
//        $finish;
//        //$fdisplay(reg_out_file, "Test case passed\nSimulation passed");
//    end
//end


//always @(posedge test_finish) begin
//    if (test_finish && !pass) begin
//        $display ("Test case failed");
//        $finish;
//        //$fdisplay(reg_out_file, "Test case failed");
//    end
//end

always@(posedge clock) begin
    if (reset) begin
        timeout <= 0;
        test_finish <= 0;
    end
    else begin
        if (timeout==TEST_TIMEOUT) begin
            test_finish <= 1;
            timeout <= timeout;
        end 
        else begin
            test_finish <= 0;
            timeout <= timeout+1;
        end
    end
end


endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Module: resync
//
// Description:
//  A general purpose resynchronization module.
//  
//  Parameters:
//    SYNC_CHAIN_LENGTH
//      - Specifies the length of the synchronizer chain for metastability
//        retiming.
//    WIDTH
//      - Specifies the number of bits you want to synchronize. Controls the width of the
//        d and q ports.
//    SLOW_CLOCK - USE WITH CAUTION. 
//      - Leaving this setting at its default will create a standard resynch circuit that
//        merely passes the input data through a chain of flip-flops. This setting assumes
//        that the input data has a pulse width longer than one clock cycle sufficient to
//        satisfy setup and hold requirements on at least one clock edge.
//      - By setting this to 1 (USE CAUTION) you are creating an asynchronous
//        circuit that will capture the input data regardless of the pulse width and 
//        its relationship to the clock. However it is more difficult to apply static
//        timing constraints as it ties the data input to the clock input of the flop.
//        This implementation assumes the data rate is slow enough
//    INIT_VALUE
//      - Specifies the initial values of the synchronization registers.

// Apply embedded false path timing constraint
(* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -to [get_registers *resync*resync_chains*.sync_r[0]]\"" *)
// (* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -to [get_pins -compatibility_mode -no_duplicates *sync_r*\|clrn]\"" *)

`timescale 1ps/1ps 

module resync #(
    parameter SYNC_CHAIN_LENGTH = 2,  // Number of flip-flops for retiming
    parameter WIDTH             = 1,  // Number of bits to resync
    parameter SLOW_CLOCK        = 0,  // See description above
    parameter INIT_VALUE        = 0
  ) (
  input   wire              clk,
  input   wire              reset,
  input   wire  [WIDTH-1:0] d,
  output  wire  [WIDTH-1:0] q
  );

localparam  INT_LEN       = (SYNC_CHAIN_LENGTH > 0) ? SYNC_CHAIN_LENGTH : 1;
localparam  [INT_LEN-1:0] L_INIT_VALUE = (INIT_VALUE == 1) ? {INT_LEN{1'b1}} : {INT_LEN{1'b0}};

genvar ig;

// Generate a synchronizer chain for each bit
generate begin
  for(ig=0;ig<WIDTH;ig=ig+1) begin : resync_chains
    wire                d_in;   // Input to sychronization chain.
    reg   [INT_LEN-1:0] sync_r = L_INIT_VALUE;
    wire  [INT_LEN  :0] next_r; // One larger than real chain

    assign  q[ig]   = sync_r[INT_LEN-1]; // Output signal
    assign  next_r  = {sync_r,d_in};

    always @(posedge clk or posedge reset)
      if(reset)
        sync_r  <= L_INIT_VALUE;
      else
        sync_r  <= next_r[INT_LEN-1:0];

    // Generate asynchronous capture circuit if specified.
    if(SLOW_CLOCK == 0) begin
      assign  d_in = d[ig];
    end else begin
      wire  d_clk;
      reg   d_r = L_INIT_VALUE[0];
      wire  clr_n;

      assign  d_clk = d[ig];
      assign  d_in  = d_r;
      assign  clr_n = ~q[ig] | d_clk; // Clear when output is logic 1 and input is logic 0

      // Asynchronously latch the input signal.
      always @(posedge d_clk or negedge clr_n)
        if(!clr_n)      d_r <= 1'b0;
        else if(d_clk)  d_r <= 1'b1;
    end // SLOW_CLOCK
  end // for loop
end // generate
endgenerate

endmodule
