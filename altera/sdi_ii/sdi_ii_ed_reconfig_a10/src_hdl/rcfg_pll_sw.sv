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


//**********************************************************************************
// Reconfig PLL Switch Block
// Generates DPRIO address and control signals for a single xcvr interface
//   - Performs RMW for handling logical PLL switch
//**********************************************************************************
`timescale 1 ns / 1 ps

module rcfg_pll_sw #(
    parameter xcvr_rcfg_if_type    = "channel",  
    parameter xcvr_rcfg_addr_width = 10,
    parameter xcvr_rcfg_data_width = 32,
    parameter xcvr_dprio_addr_width = 9,
    parameter xcvr_dprio_data_width = 8
) ( 
    input  wire        clk,
    input  wire        reset,

    input  wire        pll_sw_req,
    input  wire        pll_sel,
    output reg         pll_sw_busy, 
    input  wire        tx_cal_busy_negedge, 

    output  reg                             reconfig_write,
    output  reg                             reconfig_read,
    output  reg  [xcvr_rcfg_addr_width-1:0] reconfig_address, 
    output  reg  [xcvr_rcfg_data_width-1:0] reconfig_writedata, 
    input   wire [xcvr_rcfg_data_width-1:0] reconfig_readdata,
    input   wire                            reconfig_waitrequest
);

  //--------------------------------------
  // state assignments
  //--------------------------------------
  localparam [2:0] IDLE = 3'd0;
  localparam [2:0] RD   = 3'd1;
  localparam [2:0] MOD  = 3'd2;
  localparam [2:0] WR   = 3'd3;
  localparam [2:0] TRANS = 3'd4;
  localparam [2:0] RECAL_WAIT = 3'd5;

  //Interface types
  localparam [0:0] CHANNEL = 1'd0;
  localparam [3:0] TOTAL_OFFSET = 4'd5;

  //--------------------------------------
  // localparams - offsets 
  //--------------------------------------
  // PLL switching is supported only in the channel CGB
  // Refer to A10 PHY UG Transmitter PLL Switching Section for the parameter value
  localparam [xcvr_dprio_addr_width-1:0] CGB_MUX_SEL_REG_OFST  = 9'h111;

  // Select the appropriate scratch register offset depending on the logical PLL(CGB) selection:
  // RCFG_CH_CGB_PLL_0_1_SCRATCH_REG_OFST = 9'h117 and RCFG_CH_CGB_PLL_2_3_SCRATCH_REG_OFST = 9'h118
  localparam [xcvr_dprio_addr_width-1:0] PLL_0_1_REG_OFST  = 9'h117;
  localparam [xcvr_dprio_addr_width-1:0] PLL_2_3_REG_OFST  = 9'h118;
  localparam [xcvr_dprio_addr_width-1:0] RATE_SW_FLG_OFST  = 9'h166;
  localparam [xcvr_dprio_addr_width-1:0] PMA_CAL_ENA_OFST  = 9'h100;

  //--------------------------------------
  // signals
  //--------------------------------------
  reg [2:0]  next_state = 3'd0; 
  reg [2:0]  state;

  reg  [xcvr_dprio_data_width-1:0] modify_cgb_data;

  //*********************************************************************
  //******Number of execution required ************
  reg [3:0] num_exec;
  always @(posedge clk or posedge reset)
  begin
     if (reset) begin
        num_exec <= TOTAL_OFFSET;
     end else begin
        if (next_state == IDLE) begin
           num_exec <= TOTAL_OFFSET;
        end else if (next_state == TRANS) begin
           num_exec <= num_exec - 4'd1;
        end
     end
  end

  wire request_access = (num_exec == TOTAL_OFFSET);
  wire switch_pll = (num_exec == 4'd4);
  wire enable_recal = (num_exec == 4'd3);
  wire rate_switch_flag = (num_exec == 6'd2);
  wire return_access_with_cal = (num_exec == 4'd1);
  wire reconfig_done = (num_exec == 4'd0);

  //***********************************************************************************
  //***************************Control State Machine***********************************
  // state register
  always @(posedge clk or posedge reset)
  begin
   if (reset) 
     state <= IDLE;
   else
     state <= next_state;
  end   

  // next state logic
  always @ (*) begin
    case(state)
      IDLE: begin
        if (pll_sw_req)
          next_state = MOD;
        else    
          next_state = IDLE;
      end
      RD: begin
        if (reconfig_waitrequest)
          next_state = RD;
        else
          next_state = MOD;
      end
      MOD: begin
        next_state = WR;
      end
      WR: begin
        if (reconfig_waitrequest)
          next_state = WR;
        else
          next_state = TRANS;
      end
      TRANS : begin
         if (reconfig_done)
            next_state = RECAL_WAIT;
         else if (return_access_with_cal)
            next_state = MOD;
         else
            next_state = RD;
      end
      RECAL_WAIT: begin
         if (tx_cal_busy_negedge)
          next_state = IDLE;
         else
          next_state = RECAL_WAIT;
      end

      default : next_state = IDLE;
    endcase
  end
  
  //*********************************************************************
  //************************** pll_sw_busy****************************
  always @(posedge clk or posedge reset)
  begin
      if (reset)
        pll_sw_busy <= 1'd0;
      else begin
        if (pll_sw_req)
          pll_sw_busy <= 1'b1; 
        else if (next_state == IDLE) 
          pll_sw_busy <= 1'b0; 
      end
  end

  //********************************************************************************
  //*****************Generate DPRIO signals for single XCVR Interface***************
  //DPRIO read
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      reconfig_read  <= 1'b0; 
    else begin
      if(next_state == RD)
        reconfig_read  <= 1'b1; 
      else
        reconfig_read  <= 1'b0; 
    end
  end

  //DPRIO write
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      reconfig_write  <= 1'b0; 
    else begin
      if(next_state == WR)
        reconfig_write  <= 1'b1; 
      else 
        reconfig_write  <= 1'b0; 
    end
  end

  //DPRIO writedata
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      reconfig_writedata  <= {xcvr_rcfg_data_width{1'b0}}; 
    else begin
      if(next_state == WR)
        reconfig_writedata  <= {24'b0,modify_cgb_data};
    end
  end

  //DPRIO address
  always @ (posedge clk or posedge reset)
  begin
    if (reset)
      reconfig_address  <= {xcvr_rcfg_addr_width{1'b0}};
    else begin
      if (next_state == RD & switch_pll)
        reconfig_address <= {1'b0,PLL_0_1_REG_OFST};
      else if (next_state == WR & switch_pll)
        reconfig_address <= {1'b0,CGB_MUX_SEL_REG_OFST};
      else if (next_state == RD | next_state == WR) begin
        if (enable_recal)
          reconfig_address <= {1'b0,PMA_CAL_ENA_OFST};
        else if (rate_switch_flag)
          reconfig_address  <= {1'b0,RATE_SW_FLG_OFST};
        else if (request_access | return_access_with_cal)
          reconfig_address  <= {xcvr_rcfg_addr_width{1'b0}}; 
      end
    end
  end

  // Save readata for modification
  always @ (posedge clk or posedge reset)
  begin
    if (reset)
      modify_cgb_data  <= {8{1'b0}}; 
    else begin
      if (next_state == MOD) begin
        if (switch_pll) begin
          // For PLL switching: 
          //  - read from the upper or lower 4-bits of the scratch reg for the logical PLL selection
          //  - do a simple data translation from 4-bits to 8-bits
          //  - write to the CGB mux select reg
          if (pll_sel == 1'b0)
            modify_cgb_data <= {~reconfig_readdata[3],reconfig_readdata[1:0],reconfig_readdata[3],reconfig_readdata[3:0]};
          else
            modify_cgb_data <= {~reconfig_readdata[7],reconfig_readdata[5:4],reconfig_readdata[7],reconfig_readdata[7:4]};
        end else if (request_access)
          modify_cgb_data  <= {6'd0, 2'b10};
        else if (return_access_with_cal)
          modify_cgb_data  <= {6'd0, 2'b01};
        else if (rate_switch_flag)
          modify_cgb_data  <= {1'b1, reconfig_readdata[6:0]};
        else if (enable_recal)
          // For recalibrating PMA, set 1 to enable calibration. Bit[1] for CDR/CMU PLL calibration,
          // Bit[5] for Tx termination and Vod calibration
          modify_cgb_data <= {reconfig_readdata[7], 2'b01, reconfig_readdata[4:0]};
      end        
    end
  end

endmodule 
