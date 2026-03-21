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


//===============================================
// The following modules has two goals:
// 1. Provide mailbox register to LMI interface
// 2. Trigger MSI interrupt
//===============================================

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
//
module altpcied_sriov_mbox_hw

#(
   // SR-IOV 
   parameter TOTAL_PF_COUNT         = 2,   // Number of Physical Functions (1 or 2) 
   parameter TOTAL_VF_COUNT         = 128, // 0 - 7 when ARI is not supported.
                                           // 4 - 128 in steps of 4 when ARI is supported.
   parameter AVALON_WADDR           = 5,  // Claim 32B of memory space per function 
   parameter avmm_width_hwtcl       = 256

)
  ( 
   // clock, reset inputs
      input                                 Clk_i,
      input                                 Rstn_i,

      input                                 RxmChipSelect_i,             
      input                                 RxmWrite_i,  
      input [AVALON_WADDR-1:0]              RxmAddress_i,
      input [avmm_width_hwtcl-1:0]          RxmWriteData_i,
      input [3:0]                           RxmByteEnable_i,
      output                                RxmWaitRequest_o,
      input                                 RxmRead_i,
      output  [avmm_width_hwtcl-1:0]        RxmReadData_o,          
      output                                RxmReadDataValid_o,     

      //###################################################################################
      // Legacy and MSI interrupt signals
      //###################################################################################
      // Legacy interrupts
      output                  app_int_sts_a_o,
      output                  app_int_sts_b_o,
      output                  app_int_sts_c_o,
      output                  app_int_sts_d_o,
      output                  app_int_sts_fn_o, // Function Num associated with the Legacy interrupt request
      output  [1:0]           app_int_pend_status_o,  // Interrupt pending stats from Function
      input                   app_int_ack_i,

      output                  app_msi_req_o,
      input                   app_msi_ack_i,
      output   [7 : 0]        app_msi_req_fn_o,
      output   [4 : 0]        app_msi_num_o,
      output   [2 : 0]        app_msi_tc_o,
      input [1:0]             app_msi_status_i, // Execution status of MSI interrupt request, common for all Functions
                             // 00 = MSI message sent, 01 = Pending bit set and no message sent, 10 = error 

      output                  app_msix_req_o, // MSIX interrupt request, common for all Functions
      input                   app_msix_ack_i, // Ack to MSIX interrupt request, common for all Functions
      input                   app_msix_err_i, // Error status for MSIX interrupt request, common for all Functions
      output [63:0]           app_msix_addr_o,  // Address to be sent in MSIX interrupt message
      output [31:0]           app_msix_data_o,  // Data to be sent in MSIX interrupt message
      output                  app_msi_pending_bit_write_en_o, // Write enable for bit in the MSI Pending Bit Register
      output                  app_msi_pending_bit_write_data_o, // Write data for bit in the MSI Pending Bit Register

      input [TOTAL_PF_COUNT-1:0]    app_intx_disable_i,     // INTX Disable from PCI Command Register of PFs

   //===============================================================================
   // PF MSI Capability Register Outputs for generating MWR request for MSI message
   //===============================================================================
      input [TOTAL_PF_COUNT*64-1:0] app_msi_addr_pf_i,      // MSI Address Register setting of PFs
      input [TOTAL_PF_COUNT*16-1:0] app_msi_data_pf_i,      // MSI Data Register setting of PFs
      input [TOTAL_PF_COUNT*32-1:0] app_msi_mask_pf_i,      // MSI Mask Register setting of PFs
      input [TOTAL_PF_COUNT*32-1:0] app_msi_pending_pf_i,   // MSI Pending Bit Register setting of PFs
      input [TOTAL_PF_COUNT-1:0]    app_msi_enable_pf_i,    // MSI Enable setting of PFs
      input [TOTAL_PF_COUNT*3-1:0]  app_msi_multi_msg_enable_pf_i,   // MSI Multiple Msg field setting of PFs
   //========================================================================
   // MSIX Capability Register Outputs
   //========================================================================
      input [TOTAL_PF_COUNT-1:0]    app_msix_en_pf_i,             // MSIX Enable bit from MSIX Control Reg of PFs
      input [TOTAL_PF_COUNT-1:0]    app_msix_fn_mask_pf_i,        // MSIX Function Mask bit from MSIX Control Reg of PFs
      input [TOTAL_VF_COUNT-1:0]    app_msix_en_vf_i,             // MSIX Enable bits from MSIX Control Reg of VFs
      input [TOTAL_VF_COUNT-1:0]    app_msix_fn_mask_vf_i,        // MSIX Function Mask bits from MSIX Control Reg of VFs

    //========================================================================
    // LMI Interface
    //========================================================================

      output   [11 : 0]   lmi_addr_o,
      output   [ 8 : 0]   lmi_func_o,  // [7:0] =  Function Number,
                                     // [ 8] = 0 => access to Hard IP register
                                     // [ 8] = 1 => access to SR-IOV bridge config space
      output   [31 : 0]   lmi_din_o,
      output              lmi_rden_o,
      output              lmi_wren_o,
      input               lmi_ack_i,
      input    [31 : 0]   lmi_dout_i

  );

  //==========================================
  // Mail Box registes: 
  // The starting byte addr offset = 0x400 
  // Ending address                = 0x7FF;
  //==========================================
  //
  // Memory register dword addresses 
  //
  localparam      LMI_CTL_STATUS_ADDR = 3'h0; 
  localparam      LMI_RDATA_ADDR      = 3'h1;
  localparam      LMI_WDATA_ADDR      = 3'h2;
  localparam      INT_CTL_STATUS_ADDR = 3'h3; // DW address

// Interrupts state
  localparam IDLE                = 5'h1;  
  localparam MSI_INT             = 5'h2; 
  localparam ASSERT_LEGACY_INT   = 5'h4;
  localparam WAIT4CLR            = 5'h8;
  localparam DEASSERT_LEGACY_INT = 5'h10;
  reg [4:0]  int_st, n_int_st;  // One hot state

  wire            rxm_rden, rxm_wren;
  wire   [31:0]   rxm_wdata;  
  wire   [AVALON_WADDR-1:0]   rxm_addr; 
  reg    [31:0]   rxm_rdata_r;
  wire   [ 3:0]   rxm_be;
  reg             rxm_rddatavalid_r;

// Mailbox registers
  wire   [AVALON_WADDR-1 :2]   tgt_dw_addr; // MSB bit is for func1 access: Double the target address size for func1
  reg    [11:0]   lmi_addr;
  reg    [31:0]   lmi_rdata, lmi_wdata;
  reg             int_req, int_req_r, lmi_req, lmi_busy, lmi_cmd, lmi_src;
  wire            lmi_rden, lmi_wren, lmi_start, int_start, clr_legacy_int;
  reg             lmi_req_r;
  reg    [ 7:0]   lmi_func;
  reg    [ 7:0]   int_func;
  reg    [ 4:0]   msi_num;
  //reg    [ 4:0]   msi_data;
  reg    [ 3:0]   int_type; //[0] = INTA, [1]=INTB, [2]=INTC, [3]=INTD
  wire            int_pending;
  reg             inta_req, intb_req, intc_req, intd_req;

  // Interrupt 
  wire       pf_msi_req, pf_legacy_int_req;

  // LMI

///========================================== 
/// CFG control derived from inputs
///========================================== 
  assign rxm_addr    = RxmAddress_i; //byte address
  assign rxm_rden    = RxmRead_i  & RxmChipSelect_i & !RxmWaitRequest_o;
  assign rxm_wren    = RxmWrite_i & RxmChipSelect_i & !RxmWaitRequest_o;
  assign rxm_wdata   = RxmWriteData_i[31:0];
  assign rxm_be      = RxmByteEnable_i;
  
//========================================
// Matching target address with PF0 BAR0 
//========================================
assign tgt_dw_addr = rxm_addr[AVALON_WADDR-1: 2]; 

//==================================
// LMI Control registers
// [31]   = Start LMI access
// [30]   = LMI_busy
// [29:25]= Reserved
// [24]   = LMI_src: 0 = HIP, 1 = SRIOV bridge
// [23:16]= target function number
// [15:13]= Reserved
// [12]   = lmi_cmd: 0  => read, 1 => Write
// [11:0] = lmi_addr
//==================================
always @(posedge Clk_i or negedge Rstn_i) begin
    if(~Rstn_i) begin
       lmi_req <= 1'b0;
    end else if (rxm_wren & (tgt_dw_addr[AVALON_WADDR-1:2] == LMI_CTL_STATUS_ADDR)) begin
       if (rxm_be[3] )    lmi_req <= rxm_wdata[31] ;

       lmi_src          <= rxm_be[3] ? rxm_wdata[24]     : lmi_src;
       lmi_func         <= rxm_be[2] ? rxm_wdata[23:16]  : lmi_func[7:0];
       lmi_cmd          <= rxm_be[1] ? rxm_wdata[12]     : lmi_cmd;
       lmi_addr[11:8]   <= rxm_be[1] ? rxm_wdata[11: 8]  : lmi_addr[11:8];
       lmi_addr[7:0]    <= rxm_be[0] ? rxm_wdata[ 7: 0]  : lmi_addr[7:0];
    end else if (lmi_busy)
       lmi_req <= 1'b0;
end

//==================================
// LMI write data
//==================================
always @(posedge Clk_i or negedge Rstn_i) begin
    if(~Rstn_i) begin
       lmi_wdata         <= 32'h0;
    end else if (rxm_wren & (tgt_dw_addr[AVALON_WADDR-1:2] == LMI_WDATA_ADDR)) begin
       lmi_wdata[31:24]  <= rxm_be[3] ? rxm_wdata[31:24] : lmi_wdata[31:24];
       lmi_wdata[23:16]  <= rxm_be[2] ? rxm_wdata[23:16] : lmi_wdata[23:16];
       lmi_wdata[15: 8]  <= rxm_be[1] ? rxm_wdata[15: 8] : lmi_wdata[15: 8];
       lmi_wdata[ 7: 0]  <= rxm_be[0] ? rxm_wdata[ 7: 0] : lmi_wdata[ 7: 0];
    end
end

//=================================
// Interrupt control and status
//
// [31]    = Start interrupt
// [30]    = Interrupt pending 
// [29]    = clear legacy_int 
// [28:20] = N/A => 9bits
// [19:16] = legacy interrupt type: [16] = intA,[17]=intB,[18]=intC,[19]=INTD
// [15:13] = 3'h0 => reserved
// [12: 8] = msi_number => Must be <= msi_multiple_msg_cable
// [ 7: 0] = int_func => interrupt function number
//
//=================================
always @(posedge Clk_i or negedge Rstn_i) begin
    if(~Rstn_i) begin
       int_req        <= 1'b0;
       int_func       <= 8'h0;
    end else if (rxm_wren & (tgt_dw_addr[AVALON_WADDR-1:2] == INT_CTL_STATUS_ADDR)) begin
       if (rxm_be[3])    int_req        <= rxm_wdata[31] ;
       int_type       <= rxm_be[2] ? rxm_wdata[19:16]  : int_type;
       msi_num        <= rxm_be[1] ? rxm_wdata[12: 8]  : msi_num;
       int_func       <= rxm_be[0] ? rxm_wdata[ 7: 0]  : int_func;
    end else if (int_pending) begin
       int_req <= 1'b0;
    end    
end

assign clr_legacy_int = rxm_wren & (tgt_dw_addr[AVALON_WADDR-1:2] == INT_CTL_STATUS_ADDR) & rxm_wdata[29];

//=========================
// Read data on Avalon-MM bus 
//=========================
always @(posedge Clk_i or negedge Rstn_i) begin
    if(~Rstn_i)   rxm_rddatavalid_r <= 1'b0;
    else          rxm_rddatavalid_r <= rxm_rden; 
end

always @(posedge Clk_i or negedge Rstn_i) begin
    if(~Rstn_i)            rxm_rdata_r <= 32'b0;
    else if (rxm_rden) begin
         case (tgt_dw_addr[AVALON_WADDR-1:2])
            LMI_CTL_STATUS_ADDR: rxm_rdata_r <= { lmi_req, lmi_busy, 5'h0, lmi_src, lmi_func[7:0], 3'h0, lmi_cmd, lmi_addr[11:0]}; //[15:0]
            LMI_WDATA_ADDR:      rxm_rdata_r <= lmi_wdata;
            LMI_RDATA_ADDR:      rxm_rdata_r <= lmi_rdata;
            INT_CTL_STATUS_ADDR: rxm_rdata_r <= {int_req , int_pending, 10'h0, int_type, 2'h0, msi_num[4:0], int_func[7:0]}; 
            default:             rxm_rdata_r <= 32'h0;
         endcase
    end  
end

//=========================
// LMI interface
//=========================

  always @(posedge Clk_i or negedge Rstn_i) begin
    if(~Rstn_i) begin
      lmi_req_r <= 1'b0;
    end else begin
      lmi_req_r <= lmi_req;
    end
  end

  assign lmi_start = lmi_req   & !lmi_req_r;
  assign lmi_rden  = lmi_start & !lmi_cmd;
  assign lmi_wren  = lmi_start &  lmi_cmd;

  always @(posedge Clk_i or negedge Rstn_i) begin
    if(~Rstn_i) begin
      lmi_busy <= 1'b0;
    end else if (lmi_ack_i) begin
      lmi_rdata <= lmi_dout_i;
      lmi_busy <= 1'b0;
    end else if (lmi_req) begin
      lmi_busy <= 1'b1;
    end
  end

//=========================
// Generate Interrupt 
//=========================
  always @(posedge Clk_i or negedge Rstn_i) begin // state machine registers
    if(~Rstn_i) int_req_r <= 1'b0;
    else        int_req_r <= int_req;
  end

  assign int_start = int_req & !int_req_r;

  assign pf_msi_req = app_intx_disable_i[0] & app_msi_enable_pf_i[0] & (int_func == 8'h0) & int_start;
  assign pf_legacy_int_req = !app_intx_disable_i[0] & (int_func == 8'h0) & int_start;


  always @(posedge Clk_i or negedge Rstn_i) begin // state machine registers
    if(~Rstn_i)
      int_st  <= IDLE;
    else
      int_st   <= n_int_st;
  end

  always @(*) begin
    n_int_st  <= int_st;

    case(int_st)
      IDLE : begin
          if( pf_msi_req) begin
            n_int_st <= MSI_INT;
          end else if ( pf_legacy_int_req) begin
            n_int_st <= ASSERT_LEGACY_INT;
          end
      end  
      MSI_INT: begin
          if(app_msi_ack_i) begin
            n_int_st <= IDLE;
          end  
      end  
      ASSERT_LEGACY_INT: begin
          if(app_int_ack_i) begin
            n_int_st <= WAIT4CLR;
          end  
      end  
      WAIT4CLR: begin
          if(clr_legacy_int) begin
            n_int_st <= DEASSERT_LEGACY_INT;
          end  
      end  
      DEASSERT_LEGACY_INT: begin
          if(app_int_ack_i) begin
            n_int_st <= IDLE;
          end  
      end

      default:
          n_int_st <= IDLE;
    endcase
  end
      
  wire  idle_st, msi_int_, assert_legacy_int_st;

  assign idle_st                =  int_st[0];
  assign msi_int_st             =  int_st[1];
  assign assert_legacy_int_st   =  int_st[2];
  assign wait4clr_st            =  int_st[3];
  assign deassert_legacy_int_st =  int_st[4];
  assign int_pending          = msi_int_st |assert_legacy_int_st | deassert_legacy_int_st;


//======================
// Legacy interrupt req
//======================

  always @(posedge Clk_i or negedge Rstn_i) begin // state machine registers
    if(~Rstn_i) begin
      inta_req  <= 1'b0; 
      intb_req  <= 1'b0; 
      intc_req  <= 1'b0; 
      intd_req  <= 1'b0; 
    end else if (idle_st & pf_legacy_int_req) begin  
      inta_req  <= int_type[0]; 
      intb_req  <= int_type[1]; 
      intc_req  <= int_type[2]; 
      intd_req  <= int_type[3]; 
    end else if (wait4clr_st & clr_legacy_int) begin  
      inta_req  <= 1'b0; 
      intb_req  <= 1'b0; 
      intc_req  <= 1'b0; 
      intd_req  <= 1'b0; 
    end  
  end

//=========================
// Output registers
//=========================
   assign RxmWaitRequest_o     = lmi_busy | int_pending;
   assign RxmReadData_o        = {{(avmm_width_hwtcl-32){1'b0}}, rxm_rdata_r[31:0]};          
   assign RxmReadDataValid_o   = rxm_rddatavalid_r;     

  // LMI interface
   assign lmi_addr_o             = {lmi_addr[11:2], 2'h0};
   assign lmi_func_o             = {lmi_src, lmi_func} ;
   assign lmi_din_o              = lmi_wdata;
   assign lmi_wren_o             = lmi_wren;
   assign lmi_rden_o             = lmi_rden;

  // MSI
   assign app_msi_req_o          = int_st[1];
   assign app_msi_req_fn_o       = int_func[7:0];
   assign app_msi_num_o          = msi_num[4:0] ;
   assign app_msi_tc_o           = 3'h0;

  // Legacy 
   assign app_int_sts_a_o          = inta_req;
   assign app_int_sts_b_o          = intb_req;
   assign app_int_sts_c_o          = intc_req;
   assign app_int_sts_d_o          = intd_req;
   assign app_int_sts_fn_o         = int_func[2:0];
   assign app_int_pend_status_o    = int_pending;

endmodule
