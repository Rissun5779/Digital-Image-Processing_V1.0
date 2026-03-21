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



// Example PCIe Target Memory Space implementation for 256-bit Avalon interface.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module altera_pcie_sriov_target_app_hwtcl # (
   parameter MAX_NUM_FUNC_SUPPORT             = 8,
   parameter INTENDED_DEVICE_FAMILY           = "Stratix V",
   parameter use_crc_forwarding_hwtcl         = 0,
   parameter pld_clockrate_hwtcl              = 125000000,
   parameter lane_mask_hwtcl                  = "x8",
   parameter max_payload_size_hwtcl           = 256,
   parameter gen123_lane_rate_mode_hwtcl      = "Gen3 (8.0 Gbps)",
   parameter ast_width_hwtcl                  = "Avalon-ST 64-bit",
   parameter port_width_data_hwtcl            = 256,
   parameter port_width_be_hwtcl              = 32,
   parameter extend_tag_field_hwtcl           = 32,
   parameter avalon_waddr_hwltcl              = 12,
   parameter check_bus_master_ena_hwtcl       = 1,
   parameter check_rx_buffer_cpl_hwtcl        = 1,
   parameter port_type_hwtcl                  = "Native endpoint",
   parameter apps_type_hwtcl                  = 2,
   parameter multiple_packets_per_cycle_hwtcl = 0,
   parameter TOTAL_PF_COUNT                   = 2,    // Number of Physical Functions (1 or 2)
   parameter TOTAL_VF_COUNT                   = 128,  // 0 - 7 when ARI is not supported.
   parameter PF0_VF_COUNT                     = 64, // Number of VFs attached to PF 0
   parameter PF1_VF_COUNT                     = 64, // Number of VFs attached to PF 0
   parameter use_ast_parity                   = 0
                                         )
   (
      // Reset signals
      input                  reset_status,
      input                  serdes_pll_locked,
      input                  pld_clk_inuse,
      output                 pld_core_ready,

      // Clock
      input                  coreclkout_hip,
      output                 pld_clk_hip,
      input                  testin_zero,

      //###################################################################################
      // Legacy and MSI interrupt signals
      //###################################################################################
      output                 app_int_sts_a,
      output                 app_int_sts_b,
      output                 app_int_sts_c,
      output                 app_int_sts_d,
      output                 app_int_sts_fn, // Function Num associated with the Legacy interrupt request
      input                  app_int_ack,

      input [1:0]            app_msi_status, // Execution status of MSI interrupt request, common for all Functions
                             // 00 = MSI message sent, 01 = Pending bit set and no message sent, 10 = error
      output                 app_msi_req,
      input                  app_msi_ack,
      output  [7 : 0]        app_msi_req_fn,
      output  [4 : 0]        app_msi_num,
      output  [2 : 0]        app_msi_tc,
   output                  app_msix_req, // MSIX interrupt request, common for all Functions
   input                   app_msix_ack, // Ack to MSIX interrupt request, common for all Functions
   input                   app_msix_err, // Error status for MSIX interrupt request, common for all Functions
   output [63:0]           app_msix_addr,  // Address to be sent in MSIX interrupt message
   output [31:0]           app_msix_data,  // Data to be sent in MSIX interrupt message
   output [2:0]            app_msix_tc,

   output  [1:0]           app_int_pend_status,  // Interrupt pending stats from Function
   output                  app_msi_pending_bit_write_en, // Write enable for bit in the MSI Pending Bit Register
   output                  app_msi_pending_bit_write_data, // Write data for bit in the MSI Pending Bit Register

   input [TOTAL_PF_COUNT-1:0] app_intx_disable, // INTX Disable from PCI Command Register of PFs
   //========================================================================
   // PF MSI Capability Register Outputs
   //========================================================================
   input [TOTAL_PF_COUNT*64-1:0] app_msi_addr_pf,// MSI Address Register setting of PFs
   input [TOTAL_PF_COUNT*16-1:0] app_msi_data_pf,// MSI Data Register setting of PFs
   input [TOTAL_PF_COUNT*32-1:0] app_msi_mask_pf,// MSI Mask Register setting of PFs
   input [TOTAL_PF_COUNT*32-1:0] app_msi_pending_pf,// MSI Pending Bit Register setting of PFs
   input [TOTAL_PF_COUNT-1:0] app_msi_enable_pf,// MSI Enable setting of PFs
   input [TOTAL_PF_COUNT*3-1:0] app_msi_multi_msg_enable_pf,// MSI Multiple Msg field setting of PFs
   //========================================================================
   // MSIX Capability Register Outputs
   //========================================================================
   input [TOTAL_PF_COUNT-1:0] app_msix_en_pf, // MSIX Enable bit from MSIX Control Reg of PFs
   input [TOTAL_PF_COUNT-1:0] app_msix_fn_mask_pf, // MSIX Function Mask bit from MSIX Control Reg of PFs
   input [TOTAL_VF_COUNT-1:0]  app_msix_en_vf, // MSIX Enable bits from MSIX Control Reg of VFs
   input [TOTAL_VF_COUNT-1:0]  app_msix_fn_mask_vf, // MSIX Function Mask bits from MSIX Control Reg of VFs

      // BAR hit signals
      input [7:0]     rx_st_bar_hit_tlp0, // BAR hit information for first TLP in this cycle
      input [7:0]     rx_st_bar_hit_fn_tlp0, // Target Function for first TLP in this cycle
      input [7:0]     rx_st_bar_hit_tlp1, // BAR hit information for second TLP in this cycle
      input [7:0]     rx_st_bar_hit_fn_tlp1, // Target Function for second TLP in this cycle

      //###################################################################################
      // LMI
      //###################################################################################

      output  [11 : 0]       lmi_addr,
      output  [ 8 : 0]       lmi_func,  // [7:0] =  Function Number,
                                        // [ 8] = 0 => access to Hard IP register
                                        // [ 8] = 1 => access to SR-IOV bridge config space
      output  [31 : 0]       lmi_din,
      output                 lmi_rden,
      output                 lmi_wren,

      // Avalon-ST TX ports
      output  [port_width_data_hwtcl-1  : 0]          tx_st_data,
      output  [1:0]                                   tx_st_empty,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_eop,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_err,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_sop,
      output  [multiple_packets_per_cycle_hwtcl:0]    tx_st_valid,
      output  [port_width_be_hwtcl-1:0]               tx_st_parity,
      input                                           tx_st_ready,
      input                                           tx_fifo_empty,

      // Avalon-ST RX ports
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_sop,
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_eop,
      input [port_width_data_hwtcl-1:0]            rx_st_data,
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_valid,
      input [1:0]                                  rx_st_empty,
      input [multiple_packets_per_cycle_hwtcl:0]   rx_st_err,
      input [port_width_be_hwtcl-1  :0]            rx_st_parity,
      output                                       rx_st_ready,
      output                                       rx_st_mask,

      // hip_sriov_completion
      output  [6 :0]         cpl_err,
      output  [7 :0]         cpl_err_fn,
      output [TOTAL_PF_COUNT-1:0]  cpl_pending_pf, // Completion pending status from PF 0
      output [TOTAL_VF_COUNT-1:0]  cpl_pending_vf,// Completion pending status from VFs
      output  [127:0]        log_hdr,

   //###################################################################################
   // FLR Interface
   //###################################################################################
    input   [TOTAL_PF_COUNT-1:0] flr_active_pf,    // FLR status for PF 0
    input   [TOTAL_VF_COUNT-1:0] flr_active_vf, // FLR status for VFs
    output  [TOTAL_PF_COUNT-1:0] flr_completed_pf, // Indication from user to re-enable PF 0 after FLR
    output  [TOTAL_VF_COUNT-1:0] flr_completed_vf, // Indication from user to re-enable VFs after FLR

   //###################################################################################
      // Input HIP Status signals
      input                derr_cor_ext_rcv,
      input                derr_cor_ext_rpl,
      input                derr_rpl,
      input                rx_par_err ,
      input [1:0]          tx_par_err ,
      input                cfg_par_err,
      input                dlup,
      input                dlup_exit,
      input                ev128ns,
      input                ev1us,
      input                hotrst_exit,
      input [3 : 0]        int_status,
      input                l2_exit,
      input [3:0]          lane_act,
      input [4 : 0]        ltssmstate,
      input [7:0]          ko_cpl_spc_header,
      input [11:0]         ko_cpl_spc_data,
      input                rxfc_cplbuf_ovf,

      input                lmi_ack,
      input [31 : 0]       lmi_dout,

      // Output HIP status signals
      output                derr_cor_ext_rcv_drv,
      output                derr_cor_ext_rpl_drv,
      output                derr_rpl_drv,
      output                dlup_drv,
      output                dlup_exit_drv,
      output                ev128ns_drv,
      output                ev1us_drv,
      output                hotrst_exit_drv,
      output [3 : 0]        int_status_drv,
      output                l2_exit_drv,
      output [3:0]          lane_act_drv,
      output [4 : 0]        ltssmstate_drv,
      output                rx_par_err_drv,
      output [1:0]          tx_par_err_drv,
      output                cfg_par_err_drv,
      output [7:0]          ko_cpl_spc_header_drv,
      output [11:0]         ko_cpl_spc_data_drv,

      input                sim_pipe_pclk_out,

      // HIP control signals
      output  [4 : 0]        hpg_ctrler,

      //==========================
      // Cfg_Status Interface
      //==========================
      input [7:0]          bus_num_f0,       // Captured bus number for Function 0
      input [4:0]          device_num_f0,    // Captured device number for Function 0
      input [7:0]          bus_num_f1,       // Captured bus number for Function 0
      input [4:0]          device_num_f1,    // Captured device number for Function 0
      input [TOTAL_PF_COUNT-1:0] mem_space_en_pf,  // Memory Space Enable for PF 0
      input [TOTAL_PF_COUNT-1:0] bus_master_en_pf, // Bus Master Enable for PF 0
      input [TOTAL_PF_COUNT-1:0] mem_space_en_vf,  // Memory Space Enable for VFs (common for all VFs)
      input [TOTAL_VF_COUNT-1:0] bus_master_en_vf, // Bus Master Enable for VFs
      input [7:0]          pf0_num_vfs,      // Number of enabled VFs for PF0
      input [7:0]          pf1_num_vfs,      // Number of enabled VFs for PF0
      input [2:0]          max_payload_size, // Max payload size from Device Control Register of PF 0
      input [2:0]          rd_req_size,      // Read Request Size from Device Control Register of PF 0

      //==========================
      // tx credits
      //==========================
      input [11 : 0]       tx_cred_datafccp,
      input [11 : 0]       tx_cred_datafcnp,
      input [11 : 0]       tx_cred_datafcp,
      input [5 : 0]        tx_cred_fchipcons,
      input [5 : 0]        tx_cred_fcinfinite,
      input [7 : 0]        tx_cred_hdrfccp,
      input [7 : 0]        tx_cred_hdrfcnp,
      input [7 : 0]        tx_cred_hdrfcp,

      // Arria 10 ports
      input   [11 : 0]       tx_cred_data_fc,
      input   [7 : 0]        tx_cred_hdr_fc,
      output  [1 : 0]        tx_cred_fc_sel,
      output                 tx_cons_cred_sel

      );


reg          derr_cor_ext_rcv_r;
reg          derr_cor_ext_rpl_r;
reg          derr_rpl_r;
reg          rx_par_err_r ;
reg [1:0]    tx_par_err_r ;
reg          cfg_par_err_r;
reg          dlup_r;
reg          dlup_exit_r;
reg          ev128ns_r;
reg          ev1us_r;
reg          hotrst_exit_r;
reg [3 : 0]  int_status_r;
reg          l2_exit_r;
reg [3:0]    lane_act_r;
reg [4 : 0]  ltssmstate_r;
reg [7:0]    ko_cpl_spc_header_r;
reg [11:0]   ko_cpl_spc_data_r;

wire        pld_clk;
wire        reset_status_sync_pldclk;
wire        reset_status_hip;
wire        app_rstn;
wire        app_rstn_dup;

wire [31:0] ZEROS = 32'd0;

wire  [255 : 0]                               rx_st_req_data;
wire  [1:0]                                   rx_st_req_empty;
wire  [multiple_packets_per_cycle_hwtcl:0]    rx_st_req_eop;
wire  [multiple_packets_per_cycle_hwtcl:0]    rx_st_req_err;
wire  [multiple_packets_per_cycle_hwtcl:0]    rx_st_req_sop;
wire  [multiple_packets_per_cycle_hwtcl:0]    rx_st_req_valid;
wire                                          rx_st_req_ready;
wire [7:0]                                    rx_st_req_bar_hit_fn;
wire [7:0]                                    rx_st_req_bar_hit_tlp0;

wire  [255 : 0]                               tx_st_compl_data;
wire  [1:0]                                   tx_st_compl_empty;
wire  [multiple_packets_per_cycle_hwtcl:0]    tx_st_compl_eop;
wire  [multiple_packets_per_cycle_hwtcl:0]    tx_st_compl_err;
wire  [multiple_packets_per_cycle_hwtcl:0]    tx_st_compl_sop;
wire  [multiple_packets_per_cycle_hwtcl:0]    tx_st_compl_valid;
wire                                          tx_st_compl_ready;

wire [255:0] tx_st_data_int;
wire [255:0] rx_st_data_int;

   // Parity is currently not supported in the design example
   assign tx_st_parity =ZEROS[port_width_be_hwtcl-1:0];

   // Reset synchronizer
   altpcie_reset_delay_sync #(
      .ACTIVE_RESET           (1),
      .WIDTH_RST              (1),
      .NODENAME               ("reset_status_altpcie_reset_delay_sync_altera_pcie_sriov_target_app_hwtcl"),
      .LOCK_TIME_CNT_WIDTH    (1)
   ) reset_status_altpcie_reset_delay_sync_altera_pcie_sriov_target_app_hwtcl(
      .clk         (pld_clk),
      .async_rst   (reset_status),
      .sync_rst    (reset_status_sync_pldclk)
   );
   assign nreset_status_hip = ~reset_status_sync_pldclk;
   altpcie_reset_delay_sync #(
      .ACTIVE_RESET           (0),
      .NODENAME               ("apprstn_altpcie_reset_delay_sync_altera_pcie_sriov_target_app_hwtcl"),
      .WIDTH_RST              (2),
      .LOCK_TIME_CNT_WIDTH    (1)
   ) apprstn_altpcie_reset_delay_sync_altera_pcie_sriov_target_app_hwtcl(
      .clk         (pld_clk),
      .async_rst   (nreset_status_hip),
      .sync_rst    ({app_rstn, app_rstn_dup})
   );


   always @(posedge pld_clk or posedge reset_status_sync_pldclk) begin
      if (reset_status_sync_pldclk == 1'b1) begin
          derr_cor_ext_rcv_r  <= 1'b0              ;
          derr_cor_ext_rpl_r  <= 1'b0              ;
          derr_rpl_r          <= 1'b0              ;
          rx_par_err_r        <= 1'b0              ;
          tx_par_err_r        <= ZEROS[1:0]        ;
          cfg_par_err_r       <= 1'b0              ;
          dlup_r              <= 1'b0              ;
          dlup_exit_r         <= 1'b0              ;
          ev128ns_r           <= 1'b0              ;
          ev1us_r             <= 1'b0              ;
          hotrst_exit_r       <= 1'b0              ;
          int_status_r        <= ZEROS[3 : 0]      ;
          l2_exit_r           <= 1'b0              ;
          lane_act_r          <= ZEROS[3:0]        ;
          ltssmstate_r        <= ZEROS[4 : 0]      ;
          ko_cpl_spc_header_r <= ZEROS[7:0]        ;
          ko_cpl_spc_data_r   <= ZEROS[11:0]       ;
      end
      else begin
          derr_cor_ext_rcv_r  <=  derr_cor_ext_rcv ;
          derr_cor_ext_rpl_r  <=  derr_cor_ext_rpl ;
          derr_rpl_r          <=  derr_rpl         ;
          rx_par_err_r        <=  rx_par_err       ;
          tx_par_err_r        <=  tx_par_err       ;
          cfg_par_err_r       <=  cfg_par_err      ;
          dlup_r              <=  dlup             ;
          dlup_exit_r         <=  dlup_exit        ;
          ev128ns_r           <=  ev128ns          ;
          ev1us_r             <=  ev1us            ;
          hotrst_exit_r       <=  hotrst_exit      ;
          int_status_r        <=  int_status       ;
          l2_exit_r           <=  l2_exit          ;
          lane_act_r          <=  lane_act         ;
          ltssmstate_r        <=  ltssmstate       ;
          ko_cpl_spc_header_r <=  ko_cpl_spc_header;
          ko_cpl_spc_data_r   <=  ko_cpl_spc_data  ;
      end
   end

  // Target inbound request FIFO
   altera_pcie_sriov_target_req_fifo #
     (
       .port_width_data_hwtcl  (256),
       .port_width_be_hwtcl    (32),
       .multiple_packets_per_cycle_hwtcl (multiple_packets_per_cycle_hwtcl)
      )
   altera_pcie_sriov_target_req_fifo_mod
     (
      .clk_i         (pld_clk),
      .rstn_i        (app_rstn),

     // HIP side
      .hip_st_data_i     (rx_st_data_int),
      .hip_st_ready_o    (rx_st_ready),
      .hip_st_sop_i      (rx_st_sop),
      .hip_st_valid_i    (rx_st_valid),
      .hip_st_empty_i    (rx_st_empty),
      .hip_st_eop_i      (rx_st_eop),
      .hip_st_err_i      (rx_st_err),
      .hip_st_bar_hit_fn_i(rx_st_bar_hit_fn_tlp0),
      .hip_st_bar_hit_tlp0_i (rx_st_bar_hit_tlp0),

     // APP side
      .app_st_data_o     (rx_st_req_data),
      .app_st_ready_i    (rx_st_req_ready),
      .app_st_sop_o      (rx_st_req_sop),
      .app_st_valid_o    (rx_st_req_valid),
      .app_st_empty_o    (rx_st_req_empty),
      .app_st_eop_o      (rx_st_req_eop),
      .app_st_err_o      (rx_st_req_err),
      .app_st_bar_hit_fn_o(rx_st_req_bar_hit_fn),
      .app_st_bar_hit_tlp0_o (rx_st_req_bar_hit_tlp0)
     );

 // Target memory subsystem
   altera_pcie_sriov_target_mem #
     (
       .port_width_data_hwtcl  (256),
       .port_width_be_hwtcl    (32),
       .multiple_packets_per_cycle_hwtcl (multiple_packets_per_cycle_hwtcl),
       .TOTAL_VF_COUNT                (TOTAL_VF_COUNT),
       .TOTAL_PF_COUNT                (TOTAL_PF_COUNT)
      )
   altera_pcie_sriov_target_mem_mod
     (
      .clk_i         (pld_clk),
      .rstn_i        (app_rstn_dup),

      .bus_num_i     (bus_num_f0),

      .cpl_pending_pf_o (cpl_pending_pf),
      .cpl_pending_vf_o (cpl_pending_vf),

      .rx_st_data_i     (rx_st_req_data),
      .rx_st_ready_o    (rx_st_req_ready),
      .rx_st_sop_i      (rx_st_req_sop),
      .rx_st_valid_i    (rx_st_req_valid),
      .rx_st_empty_i    (rx_st_req_empty),
      .rx_st_eop_i      (rx_st_req_eop),
      .rx_st_err_i      (rx_st_req_err),
      .rx_st_bar_hit_fn_i(rx_st_req_bar_hit_fn),
      .rx_st_req_bar_hit_tlp0_i (rx_st_req_bar_hit_tlp0),

      .tx_st_data_o     (tx_st_compl_data),
      .tx_st_empty_o    (tx_st_compl_empty),
      .tx_st_eop_o      (tx_st_compl_eop),
      .tx_st_err_o      (tx_st_compl_err),
      .tx_st_sop_o      (tx_st_compl_sop),
      .tx_st_valid_o    (tx_st_compl_valid),
      .tx_st_ready_i    (tx_st_compl_ready)
      );

  // Outbound Completion FIFO
   altera_pcie_sriov_target_compl_fifo #
     (
       .port_width_data_hwtcl  (256),
       .port_width_be_hwtcl    (32),
       .multiple_packets_per_cycle_hwtcl (multiple_packets_per_cycle_hwtcl)
      )
   altera_pcie_sriov_target_compl_fifo_mod
     (
      .clk_i         (pld_clk),
      .rstn_i        (app_rstn),

      // APP side
      .app_st_data_i     (tx_st_compl_data),
      .app_st_ready_o    (tx_st_compl_ready),
      .app_st_sop_i      (tx_st_compl_sop),
      .app_st_valid_i    (tx_st_compl_valid),
      .app_st_empty_i    (tx_st_compl_empty),
      .app_st_eop_i      (tx_st_compl_eop),
      .app_st_err_i      (tx_st_compl_err),

     // HIP side
      .hip_st_data_o     (tx_st_data_int),
      .hip_st_ready_i    (tx_st_ready),
      .hip_st_sop_o      (tx_st_sop),
      .hip_st_valid_o    (tx_st_valid),
      .hip_st_empty_o    (tx_st_empty),
      .hip_st_eop_o      (tx_st_eop),
      .hip_st_err_o      (tx_st_err)
     );

  generate
  begin: target_tx_st_data
    if (port_width_data_hwtcl == 128) begin
            assign tx_st_data     = tx_st_data_int[127:0];
      assign rx_st_data_int = {128'h0, rx_st_data};
    end else begin
            assign tx_st_data     = tx_st_data_int[255:0];
      assign rx_st_data_int = rx_st_data[255:0];
    end
  end
  endgenerate

   // Hot plug
   assign hpg_ctrler = 5'h0;

   assign pld_core_ready =  serdes_pll_locked;

  assign pld_clk = coreclkout_hip;
  assign pld_clk_hip   = coreclkout_hip;

  //=========================================
  // Tie undriven output to default values
  //=========================================
   assign flr_completed_pf = {TOTAL_PF_COUNT{1'b1}};   // Indication from user to re-enable PF 0 after FLR
   assign flr_completed_vf = {TOTAL_VF_COUNT{1'b1}};  // Indication from user to re-enable VFs after FLR

   assign app_int_sts_a = 1'b0;
   assign app_int_sts_b = 1'b0;
   assign app_int_sts_c = 1'b0;
   assign app_int_sts_d = 1'b0;
   assign app_int_sts_fn = 1'b0;

   assign app_msi_req = 1'b0;
   assign app_msi_req_fn = 8'd0;
   assign app_msi_num = 5'd0;
   assign app_msi_tc = 3'd0;
   assign app_int_pend_status = 2'h0;

   assign lmi_func = 9'd0;
   assign lmi_addr = 12'd0;
   assign lmi_func = 9'd0;
   assign lmi_din = 32'd0;
   assign lmi_rden = 1'b0;
   assign lmi_wren = 1'b0;

   assign cpl_err = 7'd0;
   assign cpl_err_fn = 8'd0;
   assign log_hdr = 128'd0;

   // MSI new interface (TBD)
   assign   app_msix_req = 0; // MSIX interrupt request, common for all Functions
   assign   app_msix_addr = 64'h0;  // Address to be sent in MSIX interrupt message
   assign   app_msix_data = 32'h0;  // Data to be sent in MSIX interrupt message

   assign   app_msi_pending_bit_write_en = 0; // Write enable for bit in the MSI Pending Bit Register
   assign   app_msi_pending_bit_write_data = 0; // Write data for bit in the MSI Pending Bit Register
   assign   rx_st_mask = 1'b0;

  //=========================================
  // Status HIP
  //=========================================
      assign                derr_cor_ext_rcv_drv = derr_cor_ext_rcv_r;
      assign                derr_cor_ext_rpl_drv = derr_cor_ext_rpl_r;
      assign                derr_rpl_drv = derr_rpl_r;
      assign                dlup_drv = dlup_r;
      assign                dlup_exit_drv = dlup_exit_r;
      assign                ev128ns_drv = ev128ns_r;
      assign                ev1us_drv =  ev1us_r;
      assign                hotrst_exit_drv = hotrst_exit_r;
      assign                int_status_drv = int_status_r;
      assign                l2_exit_drv = l2_exit_r;
      assign                lane_act_drv = lane_act_r;
      assign                ltssmstate_drv = ltssmstate_r;
      assign                rx_par_err_drv = rx_par_err_r;
      assign                tx_par_err_drv = tx_par_err_r;
      assign                cfg_par_err_drv = cfg_par_err_r;
      assign                ko_cpl_spc_header_drv = ko_cpl_spc_header_r;
      assign                ko_cpl_spc_data_drv = ko_cpl_spc_data_r;




endmodule

