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
// Reconfig Refclk Switch Block
// Generates DPRIO address and control signals for a single xcvr interface
//   - Performs RMW for handling logical refclk switch
//**********************************************************************************
`timescale 1 ns / 1 ps

module rcfg_refclk_sw #(
    parameter xcvr_rcfg_if_type     = "channel",  //Reconfig interface type: "fpll", "atx_pll", "channel"
    parameter xcvr_rcfg_addr_width  = 10,
    parameter xcvr_rcfg_data_width  = 32,
    parameter xcvr_dprio_addr_width = 9,
    parameter xcvr_dprio_data_width = 8
) ( 
    input  wire        clk,
    input  wire        reset,
    
    input  wire        refclk_sw_req,
    input  wire        refclk_sel,
    output reg         refclk_sw_busy, 

    //input  wire [1:0]  if_type, 
    
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

  localparam [3:0] TOTAL_OFFSET = (xcvr_rcfg_if_type == "fpll") ? 4'd4 : 4'd3;


  //********************************************************************
  // ATX refclk registers
  //********************************************************************
  // ATX Refclk scratch registers
  localparam [xcvr_dprio_addr_width-1:0] RCFG_ATX_REFCLK0_SCRATCH_REG_OFST = 9'h113;  
  localparam [xcvr_dprio_addr_width-1:0] RCFG_ATX_REFCLK1_SCRATCH_REG_OFST = 9'h114;  
     
  // ATX Refclk mux register
  localparam [xcvr_dprio_addr_width-1:0] RCFG_ATX_REFCLK_MUX_SEL_REG_OFST  = 9'h112;  

  //********************************************************************
  // CDR refclk registers
  //********************************************************************
  // CDR Refclk scratch registers
  localparam [xcvr_dprio_addr_width-1:0] RCFG_CDR_REFCLK0_SCRATCH_REG_OFST = 9'h16A;  
  localparam [xcvr_dprio_addr_width-1:0] RCFG_CDR_REFCLK1_SCRATCH_REG_OFST = 9'h16B;  
     
  // CDR Refclk mux register
  localparam [xcvr_dprio_addr_width-1:0] RCFG_CDR_REFCLK_MUX_SEL_REG_OFST  = 9'h141;   

  //********************************************************************
  // FPLL refclk registers 
  //********************************************************************
  // FPLL Refclk scratch registers - Mux0
  localparam [xcvr_dprio_addr_width-1:0] RCFG_FPLL_MUX0_REFCLK0_SCRATCH_REG_OFST = 9'h117;  
  localparam [xcvr_dprio_addr_width-1:0] RCFG_FPLL_MUX0_REFCLK1_SCRATCH_REG_OFST = 9'h118;  
     
  // FPLL Refclk mux register - Mux0
  localparam [xcvr_dprio_addr_width-1:0] RCFG_FPLL_MUX0_REFCLK_MUX_SEL_REG_OFST  = 9'h114;   

   // FPLL Refclk scratch registers - Mux1
  localparam [xcvr_dprio_addr_width-1:0] RCFG_FPLL_MUX1_REFCLK0_SCRATCH_REG_OFST = 9'h11D;  
  localparam [xcvr_dprio_addr_width-1:0] RCFG_FPLL_MUX1_REFCLK1_SCRATCH_REG_OFST = 9'h11E;  
     
  // FPLL Refclk mux register - Mux1
  localparam [xcvr_dprio_addr_width-1:0] RCFG_FPLL_MUX1_REFCLK_MUX_SEL_REG_OFST  = 9'h11C;   


  //--------------------------------------
  // signals
  //--------------------------------------
  reg [2:0]  next_state = 3'd0; 
  reg [2:0]  state;

  reg  [xcvr_dprio_data_width-1:0] modify_refclk_data;

  wire [xcvr_dprio_addr_width-1:0] refclk_scratch_addr; 
  wire [xcvr_dprio_addr_width-1:0] refclk0_scratch_addr; 
  wire [xcvr_dprio_addr_width-1:0] refclk1_scratch_addr; 
  wire [xcvr_dprio_addr_width-1:0] refclk_mux_sel_addr; 
  reg                              fpll_rmw_count;
  
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
  wire switch_refclk_on_mux1 = (xcvr_rcfg_if_type == "fpll") ? (num_exec == 4'd3) : 1'b0;
  wire switch_refclk_on_mux0 = (num_exec == 4'd2);
  wire return_access = (num_exec == 4'd1);
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
        if (refclk_sw_req)
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
      TRANS: begin
         if (reconfig_done)
            next_state = IDLE;
         else if (return_access)
            next_state = MOD;
         else
            next_state = RD;
      end

      default : next_state = IDLE;
    endcase
  end

  //*********************************************************************
  //************************** fpll_rmw_count ***************************
  always @(posedge clk or posedge reset)
  begin
      if (reset)
        fpll_rmw_count <= 1'd0;
      else begin
        if ((xcvr_rcfg_if_type == "fpll") && (num_exec == 4'd3) && (next_state == TRANS))
          fpll_rmw_count <= fpll_rmw_count + 1'b1; 
        else if (next_state == IDLE) 
          fpll_rmw_count <= 1'd0;
        //else no change
      end
  end

  //*********************************************************************
  //************************** refclk_sw_busy****************************
  always @(posedge clk or posedge reset)
  begin
      if (reset)
        refclk_sw_busy <= 1'd0;
      else begin
        if (refclk_sw_req)
          refclk_sw_busy <= 1'b1; 
        else if (next_state == IDLE) 
          refclk_sw_busy <= 1'b0; 
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
        reconfig_writedata  <= {24'b0,modify_refclk_data};
    end
  end

  //DPRIO address
  always @ (posedge clk or posedge reset)
  begin
    if (reset)
      reconfig_address  <= {xcvr_rcfg_addr_width{1'b0}}; 
    else begin
      if (next_state == RD & (switch_refclk_on_mux1 | switch_refclk_on_mux0)) 
        reconfig_address <= {1'b0,refclk_scratch_addr}; 
      else if (next_state == WR & (switch_refclk_on_mux1 | switch_refclk_on_mux0)) 
        reconfig_address <= {1'b0,refclk_mux_sel_addr};
      else if (next_state == RD | next_state == WR)
        reconfig_address  <= {xcvr_rcfg_addr_width{1'b0}}; 
    end
  end

  // Save readata for modification
  always @ (posedge clk or posedge reset)
  begin
    if (reset)
      modify_refclk_data  <= {8{1'b0}}; 
    else begin
      if (next_state == MOD) begin
        if (request_access)
          modify_refclk_data <= {6'd0, 2'b10};
        else if (return_access)
          modify_refclk_data <= {6'd0, 2'b11};
        else
          // For refclk switching: 
          //  - read from the scratch reg for the logical refclk selection
          //  - write to the mux select reg
          modify_refclk_data  <= reconfig_readdata[7:0];
      end
    end
  end

  //-------------------------------------------- 
  //Generate DPRIO address - refclk
  //-------------------------------------------- 
  // Select the refclk look-up (scratch) offset depending on the interface that this logic is talking to.
  assign refclk0_scratch_addr = (xcvr_rcfg_if_type  == "atx_pll" )                              ? RCFG_ATX_REFCLK0_SCRATCH_REG_OFST       : 
                                ((xcvr_rcfg_if_type == "fpll") && (fpll_rmw_count == 1'b0)) ? RCFG_FPLL_MUX0_REFCLK0_SCRATCH_REG_OFST : 
                                ((xcvr_rcfg_if_type == "fpll") && (fpll_rmw_count == 1'b1)) ? RCFG_FPLL_MUX1_REFCLK0_SCRATCH_REG_OFST : RCFG_CDR_REFCLK0_SCRATCH_REG_OFST;

  assign refclk1_scratch_addr = (xcvr_rcfg_if_type  == "atx_pll" )                              ? RCFG_ATX_REFCLK1_SCRATCH_REG_OFST       : 
                                ((xcvr_rcfg_if_type == "fpll") && (fpll_rmw_count == 1'b0)) ? RCFG_FPLL_MUX0_REFCLK1_SCRATCH_REG_OFST : 
                                ((xcvr_rcfg_if_type == "fpll") && (fpll_rmw_count == 1'b1)) ? RCFG_FPLL_MUX1_REFCLK1_SCRATCH_REG_OFST : RCFG_CDR_REFCLK1_SCRATCH_REG_OFST;

  
  // Select the scratch offset for each of the 5 logical refclks depending on the interface that this logic is
  // talking to.
  // Select the appropriate scratch register offset depending on the logical refclk selection 
  assign refclk_scratch_addr = (refclk_sel == 1'b1) ? refclk1_scratch_addr : refclk0_scratch_addr;

  // Select the refclk mux select offset depending on the interface that this logic is talking to.
  assign refclk_mux_sel_addr = (xcvr_rcfg_if_type == "atx_pll"  )                              ? RCFG_ATX_REFCLK_MUX_SEL_REG_OFST        : 
                               ((xcvr_rcfg_if_type == "fpll") && (fpll_rmw_count == 1'b0)) ? RCFG_FPLL_MUX0_REFCLK_MUX_SEL_REG_OFST  : 
                               ((xcvr_rcfg_if_type == "fpll") && (fpll_rmw_count == 1'b1)) ? RCFG_FPLL_MUX1_REFCLK_MUX_SEL_REG_OFST  : RCFG_CDR_REFCLK_MUX_SEL_REG_OFST;

 
endmodule 
