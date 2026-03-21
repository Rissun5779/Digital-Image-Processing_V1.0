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


module alt_xcvr_sc_debug #(
  parameter scratch_status_reg   = 1,
  parameter num_channels         = 1,
  parameter num_freq_chk         = 2,
  parameter num_ptrn_gen         = 1,
  parameter num_ptrn_ver         = 1,
  parameter num_plls             = 1,
  parameter num_wrd_algn         = 1
) (
  input                         mgmt_clk,
  output                        jtag_reset,

  // Atso Status
  input                         atso_start,
  input                         atso_fail,
  input                         atso_pass,

  // Status signals for the pattern generator and checker.
  input   [num_ptrn_ver-1:0]    pattern_ver_en,
  input   [num_ptrn_ver-1:0]    pattern_ver_lock,
  input   [num_ptrn_ver-1:0]    pattern_ver_err,
  input   [num_ptrn_gen-1:0]    pattern_gen_en,

  // Status signals for the Simple Word Aligner
  input   [num_wrd_algn-1:0]    simple_wa_align,
  input   [num_wrd_algn-1:0]    simple_wa_sync,

  // Status signals for the freq checker
  input   [num_freq_chk-1:0]    freq_measured,
  input   [num_freq_chk-1:0]    freq_start_cnt,
  input   [num_freq_chk*16-1:0] freq_count_value,

  // Status signals for the channels
  input   [num_channels-1:0]    tx_ready,
  input   [num_channels-1:0]    rx_ready,
  input   [num_channels-1:0]    rx_is_lockedtodata,
  input   [num_channels-1:0]    rx_is_lockedtoref,
  input   [num_channels-1:0]    tx_cal_busy,
  input   [num_channels-1:0]    rx_cal_busy,

  // Status signals for the PLLs
  input   [num_plls-1:0]        pll_locked,
  input   [num_plls-1:0]        pll_cal_busy,

  // inputs for scratch registers
  input   [scratch_status_reg*32-1:0]  scratch_input,

  output  [31:0]                atso_output,

  // output for csr-driven resets
  output                        csr_reset
);


/*******************************************************************************/
// Logic for data valid and waitrequest for the ADME
/*******************************************************************************/
// local params for converting ints to strings
localparam str_num_channels = int2str(num_channels);
localparam str_num_freq_chk = int2str(num_freq_chk);
localparam str_num_ptrn_gen = int2str(num_ptrn_gen);
localparam str_num_ptrn_ver = int2str(num_ptrn_ver);
localparam str_num_wrd_algn = int2str(num_wrd_algn);
localparam str_scratch_reg  = int2str(scratch_status_reg);
localparam slave_map_lcl = {"{typeName system_console_debug_block address 0x0 span 131072}"};

// wires and registers for avmm interface
wire          lcl_jtag_reset;
wire  [14:0]  avmm_address;
wire          avmm_read, avmm_write, avmm_waitrequest;
wire  [31:0]  avmm_writedata;
reg           avmm_valid;
reg           avmm_waitrequest_hold;
reg   [1:0]   avmm_valid_sync;
reg   [31:0]  avmm_readdata;
reg   [63:0]  avmm_readdata_sync;


localparam enable_jtag_devices =
`ifdef ALTERA_DISABLE_JTAG_PINS
  0;
`else
  1;
`endif


assign jtag_reset = (lcl_jtag_reset);

generate
if (enable_jtag_devices) begin: g_enable_adme
  `ifdef ALTERA_RESERVED_QIS
    //instantiate embedded debug
    jtag_debug jtag_debug_inst (
      .clk_clk (mgmt_clk),
      .debug_reset_reset (lcl_jtag_reset) // this reset will ONLY get asserted when system console connects to the design.  For user controlled reset use csr_reset
    );

    altera_debug_master_endpoint
    #(
      .ADDR_WIDTH                     ( 15 ),
      .DATA_WIDTH                     ( 32 ),
      .HAS_RDV                        ( 0 ),
      .SLAVE_MAP                      ( slave_map_lcl ),
      .PREFER_HOST                    ( " " ),
      .CLOCK_RATE_CLK                 ( 0 )
    ) adme (
      .clk                                   (mgmt_clk),
      .reset                                 (lcl_jtag_reset),
      .master_write                          (avmm_write),
      .master_read                           (avmm_read),
      .master_address                        (avmm_address),
      .master_writedata                      (avmm_writedata),
      .master_waitrequest                    (avmm_waitrequest),
      .master_readdatavalid                  (1'b0),
      .master_readdata                       (avmm_readdata_sync[63:32])
    );
  `else
    assign lcl_jtag_reset   = 1'b0;
    assign avmm_write       = 1'b0;
    assign avmm_read        = 1'b0;
    assign avmm_writedata   = 32'b0;
    assign avmm_address     = 15'b0;
  `endif
end
endgenerate

// assign waitreqeust
assign avmm_waitrequest   = (avmm_waitrequest_hold || avmm_read) && ~(avmm_valid_sync[1]);

// synchronizer for readdata
always@(posedge mgmt_clk or posedge lcl_jtag_reset) begin
  if(lcl_jtag_reset) begin
    avmm_waitrequest_hold <=  1'b0;
    avmm_valid_sync       <=  2'b0;
    avmm_readdata_sync    <=  64'h0;
  end else begin
    avmm_waitrequest_hold <=  avmm_waitrequest;
    avmm_valid_sync       <=  {avmm_valid_sync[0], avmm_valid};
    avmm_readdata_sync    <=  {avmm_readdata_sync[31:0], avmm_readdata[31:0]};
  end
end

/*******************************************************************************/
// logic for reading and writing the various status signals
/*******************************************************************************/
// local parameters for signal debug
localparam NUM_CHNL_ADDR         = 15'h0000;
localparam NUM_FREQ_CHK_ADDR     = 15'h0001;
localparam NUM_PTRN_VER_ADDR     = 15'h0002;
localparam NUM_PTRN_GEN_ADDR     = 15'h0003;
localparam NUM_WRD_ALGN_ADDR     = 15'h0004;
localparam NUM_SCRATCH_ADDR      = 15'h0005;
localparam NUM_PLLS_ADDR         = 15'h0006;
localparam ATSO_STATUS_ADDR      = 15'h0007;
localparam SYS_CONTROL_ADDR      = 15'h0008;
localparam SOFT_RESET_ADDR       = 15'h0010;
localparam CHNL_BASE_ADDR        = 15'h0100;
localparam FREQ_CHK_BASE_ADDR    = 15'h0200;
localparam PTRN_GEN_BASE_ADDR    = 15'h0300;
localparam PTRN_VER_BASE_ADDR    = 15'h0400;
localparam WRD_ALGN_BASE_ADDR    = 15'h0500;
localparam PLL_BASE_ADDR         = 15'h0600;
localparam SCRATCH_STA_BASE_ADDR = 15'h0700;

// registers and wires for signal debug
reg           atso_fail_int;
reg           r_soft_reset;
reg   [31:0]  r_scratch_control;

// Latch errors to ensure they are captured
always@(posedge atso_fail or posedge jtag_reset) begin
  if(jtag_reset) begin
    atso_fail_int <= 1'b0;
  end else if(atso_fail) begin
    atso_fail_int <= 1'b1;
  end else begin
    atso_fail_int <= atso_fail_int;
  end
end

// assign the reset signal out to the core
assign csr_reset = r_soft_reset;
assign atso_output = r_scratch_control;
int i;
generate 
  always@(posedge mgmt_clk) begin
    if(avmm_read == 1'b0) begin
      avmm_readdata <= 32'b0;
      avmm_valid    <= 1'b0;
    end else begin
      avmm_readdata <= 32'b0;
      avmm_valid    <= (avmm_read & !avmm_valid);

      if(avmm_address == NUM_CHNL_ADDR) begin
        avmm_readdata <= num_channels;
      end else if(avmm_address == NUM_FREQ_CHK_ADDR) begin
        avmm_readdata <= num_freq_chk;
      end else if(avmm_address == NUM_PTRN_VER_ADDR) begin
        avmm_readdata <= num_ptrn_ver;
      end else if(avmm_address == NUM_PTRN_GEN_ADDR) begin
        avmm_readdata <= num_ptrn_gen;
      end else if(avmm_address == NUM_WRD_ALGN_ADDR) begin
        avmm_readdata <= num_wrd_algn;
      end else if(avmm_address == NUM_PLLS_ADDR) begin
        avmm_readdata <= num_plls;
      end else if(avmm_address == NUM_SCRATCH_ADDR) begin
        avmm_readdata <= scratch_status_reg;
      end else if(avmm_address == SOFT_RESET_ADDR) begin
        avmm_readdata <= {31'b0, r_soft_reset};
      end else if(avmm_address == ATSO_STATUS_ADDR) begin
        avmm_readdata <= {29'b0, atso_pass, atso_fail_int, atso_start};
      end

      for(i=0;i<num_channels;i=i+1) begin
        if(avmm_address == (CHNL_BASE_ADDR+i)) begin
          avmm_readdata <= {26'b0, tx_cal_busy[i], rx_cal_busy[i], rx_is_lockedtodata[i], rx_is_lockedtoref[i], tx_ready[i],rx_ready[i]};
        end
      end

      for(i=0;i<num_freq_chk;i=i+1) begin
        if(avmm_address == (FREQ_CHK_BASE_ADDR+i)) begin
          avmm_readdata <= {12'b0,freq_count_value[16*i+:16],2'b0,freq_measured[i],freq_start_cnt[i]};
        end
      end

      for(i=0;i<num_ptrn_ver;i=i+1) begin
        if(avmm_address == (PTRN_VER_BASE_ADDR+i)) begin
          avmm_readdata <= {28'b0,pattern_ver_err[i],pattern_ver_lock[i],pattern_ver_en[i],1'b0};
        end
      end

      for(i=0;i<num_ptrn_gen;i=i+1) begin
        if(avmm_address == (PTRN_GEN_BASE_ADDR+i)) begin
          avmm_readdata[0] <= pattern_gen_en;
        end
      end

      for(i=0;i<num_wrd_algn;i=i+1) begin
        if(avmm_address == (WRD_ALGN_BASE_ADDR+i)) begin
          avmm_readdata <= {30'b0, simple_wa_align[i], simple_wa_sync[i]};
        end
      end

       for(i=0;i<num_plls;i=i+1) begin
        if(avmm_address == (PLL_BASE_ADDR+i)) begin
          avmm_readdata <= {30'b0, pll_cal_busy[i], pll_locked[i]};
        end
      end
      
      for(i=0;i<scratch_status_reg;i=i+1) begin
        if(avmm_address == (SCRATCH_STA_BASE_ADDR+i)) begin
          avmm_readdata <= scratch_input[32*i+:32];
        end
      end

      if(avmm_address == (SYS_CONTROL_ADDR)) begin
        avmm_readdata <= r_scratch_control;
      end
  
    end
  end
endgenerate

always@(posedge mgmt_clk or posedge lcl_jtag_reset) begin
  if(lcl_jtag_reset) begin
    r_soft_reset          <= 1'b0;
    r_scratch_control     <= 32'b0;
  end else begin
    if(avmm_address == SOFT_RESET_ADDR && avmm_write == 1'b1) begin
      r_soft_reset        <= avmm_writedata[0];
    end else if(avmm_address == SYS_CONTROL_ADDR && avmm_write == 1'b1) begin
      r_scratch_control   <= avmm_writedata;
    end else begin
      r_soft_reset        <= r_soft_reset;
      r_scratch_control   <= r_scratch_control;
    end
  end
end

// Function for converting int to strings.
function [30*8-1:0] int2str(
  input integer in_int
);
integer i;
integer this_char;
i = 0;
int2str = "";
do
begin
  this_char = (in_int % 10) + 48;
  int2str[i*8+:8] = this_char[7:0];
  i=i+1;
  in_int = in_int / 10;
end
while(in_int > 0);
endfunction

endmodule
