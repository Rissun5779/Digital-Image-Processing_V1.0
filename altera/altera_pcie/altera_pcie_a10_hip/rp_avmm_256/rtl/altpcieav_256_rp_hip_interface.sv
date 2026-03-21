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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module altpcieav_256_rp_hip_interface
  # (
       parameter dma_use_scfifo_ext = 0,
       parameter DEVICE_FAMILY      = "Arria 10",
       parameter SRIOV_EN           = 1,
       parameter RXFIFO_DATA_WIDTH  = 274,
       parameter DMA_WIDTH          = 256,
       parameter DMA_BE_WIDTH       = 32,
       parameter TX_FIFO_WIDTH      = 265,
       parameter PFCNT_WD           = 2,
       parameter VFCNT_WD           = 2
    )

(
    input  logic                                     Clk_i,
    input  logic                                     Rstn_i,

    output logic                                     RxStReady_o,
    input  logic  [DMA_WIDTH-1:0]                    RxStData_i,
    input  logic  [1:0]                              RxStEmpty_i,
    input  logic                                     RxStSop_i,
    input  logic                                     RxStEop_i,
    input  logic                                     RxStValid_i,
    input  logic  [7:0]                              RxStBarDec1_i,
    input  logic  [2:0]                              RxStBar_range_i,
    input  logic  [PFCNT_WD-1:0]                     RxSt_pf_num_i,
    input  logic  [VFCNT_WD-1:0]                     RxSt_vf_num_i,
    input logic                                      RxSt_vf_active_i,

    input  logic                                     TxStReady_i  ,
    output logic   [DMA_WIDTH-1:0]                   TxStData_o   ,
    output logic                                     TxStSop_o    ,
    output logic                                     TxStEop_o    ,
    output logic   [1:0]                             TxStEmpty_o  ,
    output logic                                     TxStValid_o  ,
    output logic  [PFCNT_WD-1:0]                     TxSt_pf_num_o,
    output logic  [VFCNT_WD-1:0]                     TxSt_vf_num_o,
    output logic                                     TxSt_vf_active_o,
          // Rx fifo Interface
    input logic                                      RxFifoRdReq_i,
    output  logic [RXFIFO_DATA_WIDTH-1:0]            RxFifoDataq_o,
    output  logic [3:0]                              RxFifoCount_o,

    input   logic                                    PreDecodeTagRdReq_i,
    output  logic [7:0]                              PreDecodeTag_o,
    output  logic [3:0]                              PreDecodeTagCount_o,

    // Tx fifo Interface
    input logic                                      TxFifoWrReq_i,
    input logic [TX_FIFO_WIDTH-1:0]                  TxFifoData_i,
    output  logic [3:0]                              TxFifoCount_o,
    // Cfg interface
    output  logic  [81:0]                            MsiIntfc_o,
    output  logic  [15:0]                            MsixIntfc_o,
    input   logic  [3:0]                             CfgAddr_i,
    input   logic  [31:0]                            CfgCtl_i,
    output  logic  [12:0]                            CfgBusDev_o,
    output  logic  [31:0]                            DevCsr_o,
    output  logic  [31:0]                            PciCmd_o,
    output  logic  [31:0]                            MsiDataCrl_o,

    // SRIOV I/O
   input  logic [7:0]                                bus_num_f0_i,       // Captured bus number for PF0
   input  logic [4:0]                                device_num_f0_i,    // Captured device number for PF0
   input  logic [2:0]                                max_payload_size_i, // Max payload size from Device Control Register of PF 0
   input  logic [2:0]                                rd_req_size_i,      // Read Request Size from Device Control Register of PF 0
   input  logic                                      bus_master_en_pf_i, // Bus Master Enable for PF 0
   input  logic [VFCNT_WD-1:0]                       bus_master_en_vf_i  // Bus Master Enable for VFs




);

    logic                                            rx_fifo_wrreq;
    logic  [RXFIFO_DATA_WIDTH-1:0]                   rx_fifo_data;
    logic  [RXFIFO_DATA_WIDTH-1:0]                   rx_fifo_dataq;
    logic  [3:0]                                     rx_fifo_count;
    logic                                            tx_fifo_rdreq;
    logic  [3:0]                                     tx_fifo_count;
    logic  [TX_FIFO_WIDTH-1:0]                       tx_fifo_dataq;
    logic  [255:0]                                   tx_tlp_out_reg;
    logic                                            tx_sop_out_reg;
    logic                                            tx_eop_out_reg;
    logic  [1:0]                                     tx_empty_out_reg;
    logic                                            output_valid_reg;
    logic                                            fifo_valid_reg;
    logic                                            output_transmit;
    logic                                            fifo_transmit;
    logic                                            tx_st_ready_reg;
    logic                                            output_fifo_rdempty;
    logic  [12:0]                                    cfg_busdev;
    logic  [31:0]                                    cfg_dev_csr;
    logic  [15:0]                                    msi_ena;
    logic  [15:0]                                    msix_control;
    logic  [15:0]                                    cfg_prmcsr;
    logic  [63:0]                                    msi_addr;
    logic  [15:0]                                    msi_data;
    logic  [63:0]                                    msi_addr_reg;
    logic  [15:0]                                    msi_data_reg;
    logic  [15:0]                                    msi_ena_reg;
    logic  [15:0]                                    msix_control_reg;
    logic                                            rstn_reg;

    logic                                            rstn_rr;

    logic                                            rstn_r;
    logic  [3:0]                                     cfg_addr_reg;
    logic   [31:0]                                   cfg_data_reg;
    logic  [255:0]                                   rx_input_data_reg;
    logic                                            rx_input_valid_reg;
    logic                                            rx_input_sop_reg;
    logic                                            rx_input_eop_reg;
    logic  [1:0]                                     rx_input_empty_reg;
    logic  [5:0]                                     rx_input_bardesc_reg;

    logic  [255:0]                                   rx_input_data_reg2;
    logic                                            rx_input_valid_reg2;
    logic                                            rx_input_sop_reg2;
    logic                                            rx_input_eop_reg2;
    logic  [1:0]                                     rx_input_empty_reg2;
    logic  [5:0]                                     rx_input_bardesc_reg2;

    logic  [7:0]                                     cpl_tag;
    logic                                            is_cpl_wd;
    logic                                            valid_dma_rd_cpl;
    logic                                            tag_predecode_fifo_wrreq;


// ==============================================================================================
// Workaround for 128 AV/CV rx_st_valid being deasserted within single TLP
// Insert an additional FIFO before rx_input_fifo to account for the deassertion of rx_st_valid b/w sop and eop while rx_st_ready is asserted
localparam RX_BUFFER_ENABLE = SRIOV_EN;
localparam DROP_MESSAGE     = 1;
//localparam RX_BUFFER_ENABLE = 1;
logic [RXFIFO_DATA_WIDTH-1:0] rx_buf_fifo_data;
logic [RXFIFO_DATA_WIDTH-1:0] rx_buf_fifo_dataq;
logic [6:0]                   rx_buf_fifo_usedw;
logic                         rx_buf_fifo_rdreq;
logic                         rx_buf_fifo_rdreq_reg;
logic                         rx_buf_fifo_wrreq;
logic                         rx_buf_fifo_dataq_eop; // EOP appears in the output dataq

   localparam  RX_UNDERFLOW_IDLE                = 2'b00;
   localparam  RX_UNDERFLOW_STREAM              = 2'b01;
   localparam  RX_UNDERFLOW_WAIT                = 2'b10;

logic    [1:0]                rx_underflow_state;
logic    [1:0]                rx_underflow_nxt_state;
logic                         underflow_idle_state;
logic                         underflow_stream_state;
logic                         rx_eop_fifo_rdreq;
logic                         rx_eop_fifo_wrreq;
logic    [3:0]                rx_eop_fifo_count;
logic                         rx_eop_fifo_out;
logic                         rx_eop_fifo_wrreq_delay_reg2;
logic                         rx_eop_fifo_wrreq_delay_reg3;
logic                         rxfifo_rdreq;
logic                         msg_type,msg_type_rdreq,rx_fifo_empty;

///////////////////////////////////////////////////////////////////////////////////////////////////////////

generate if (RX_BUFFER_ENABLE) begin


   always @(posedge Clk_i )
        begin
           if (~Rstn_i)
             rx_buf_fifo_rdreq_reg <= 0;
           else
             rx_buf_fifo_rdreq_reg <= rx_buf_fifo_rdreq;
        end


   assign rx_buf_fifo_data = rx_fifo_data;
   assign rx_buf_fifo_wrreq = rx_fifo_wrreq;
   assign rx_buf_fifo_dataq_eop = rx_buf_fifo_dataq[257];
   assign rx_buf_fifo_rdreq = ((underflow_idle_state & rx_eop_fifo_count != 0 & rx_fifo_count <= 4) | (underflow_stream_state & ~ (rx_buf_fifo_dataq_eop & (rx_eop_fifo_count == 0 | rx_fifo_count >= 8)))) ;
   // RX buffer FIFO
   if (dma_use_scfifo_ext==1) begin
      altpcie_a10_scfifo_ext         # (
           .add_ram_output_register    ("ON"              ),
           .intended_device_family     ("Stratix V"       ),
           .lpm_numwords               (80                ),  // Each depth stores 4DW. Max TLP  128DW. TLP header  4DW.
           .lpm_showahead              ("OFF"             ),
           .lpm_type                   ("scfifo"          ),
           .lpm_width                  (RXFIFO_DATA_WIDTH ),
           .lpm_widthu                 (7                 ),
           .overflow_checking          ("ON"              ),
           .underflow_checking         ("ON"              ),
           .use_eab                    ("ON"              )
      ) rx_input_buffer_fifo           (
            .rdreq                     (rx_buf_fifo_rdreq),
            .clock                     (Clk_i),
            .wrreq                     (rx_buf_fifo_wrreq),
            .data                      (rx_buf_fifo_data),
            .usedw                     (rx_buf_fifo_usedw),
            .empty                     (),
            .q                         (rx_buf_fifo_dataq),
            .full                      (),
            .aclr                      (~Rstn_i),
            .almost_empty              (),
            .almost_full               (),
            .sclr                      (1'b0)
      );
   end
   else if (dma_use_scfifo_ext==2) begin
      altpcie_sv_scfifo_ext         # (
           .add_ram_output_register    ("ON"              ),
           .intended_device_family     ("Stratix V"       ),
           .lpm_numwords               (80                ),  // Each depth stores 4DW. Max TLP  128DW. TLP header  4DW.
           .lpm_showahead              ("OFF"             ),
           .lpm_type                   ("scfifo"          ),
           .lpm_width                  (RXFIFO_DATA_WIDTH ),
           .lpm_widthu                 (7                 ),
           .overflow_checking          ("ON"              ),
           .underflow_checking         ("ON"              ),
           .use_eab                    ("ON"              )
      ) rx_input_buffer_fifo           (
            .rdreq                     (rx_buf_fifo_rdreq),
            .clock                     (Clk_i),
            .wrreq                     (rx_buf_fifo_wrreq),
            .data                      (rx_buf_fifo_data),
            .usedw                     (rx_buf_fifo_usedw),
            .empty                     (),
            .q                         (rx_buf_fifo_dataq),
            .full                      (),
            .aclr                      (~Rstn_i),
            .almost_empty              (),
            .almost_full               (),
            .sclr                      (1'b0)
      );
   end
   else begin
      scfifo                          #(
           .add_ram_output_register    ("ON"              ),
           .intended_device_family     ("Stratix V"       ),
           .lpm_numwords               (80                ),  // Each depth stores 4DW. Max TLP  128DW. TLP header  4DW.
           .lpm_showahead              ("OFF"             ),
           .lpm_type                   ("scfifo"          ),
           .lpm_width                  (RXFIFO_DATA_WIDTH ),
           .lpm_widthu                 (7                 ),
           .overflow_checking          ("ON"              ),
           .underflow_checking         ("ON"              ),
           .use_eab                    ("ON"              )
      ) rx_input_buffer_fifo           (
            .rdreq                     (rx_buf_fifo_rdreq),
            .clock                     (Clk_i),
            .wrreq                     (rx_buf_fifo_wrreq),
            .data                      (rx_buf_fifo_data),
            .usedw                     (rx_buf_fifo_usedw),
            .empty                     (),
            .q                         (rx_buf_fifo_dataq),
            .full                      (),
            .aclr                      (~Rstn_i),
            .almost_empty              (),
            .almost_full               (),
            .sclr                      (1'b0)
     );
   end
   
   altpcie_256_rp_fifo
   #(
    .FIFO_DEPTH(10),
    .DATA_WIDTH(RXFIFO_DATA_WIDTH)
    )
 rx_input_fifo
(
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(rx_buf_fifo_rdreq_reg),
      .rdreq(rxfifo_rdreq),
      .data(rx_buf_fifo_dataq),
      .q(rx_fifo_dataq),
      .fifo_count(rx_fifo_count)
);

end
else begin
  assign rx_buf_fifo_usedw = {7{1'b0}};
  assign rx_buf_fifo_wrreq = 1'b0;
  assign rx_buf_fifo_dataq_eop = 1'b0;
  
  altpcie_256_rp_fifo
   #(
    .FIFO_DEPTH(10),
    .DATA_WIDTH(RXFIFO_DATA_WIDTH)
    )
 rx_input_fifo
(
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(rx_fifo_wrreq ),
      .rdreq(rxfifo_rdreq),
      .data(rx_fifo_data),
      .q(rx_fifo_dataq),
      .fifo_count(rx_fifo_count)
);

end
endgenerate
//////////////////////////////////////////////////
/// Drop Message TLP to avoid RX FIFO blocking
//////////////////////////////////////////////////

generate if (DROP_MESSAGE) begin

  assign   rx_fifo_empty  = (rx_fifo_count == 4'h0);
  assign   msg_type       = (rx_fifo_dataq[28:27] == 2'b10) & rx_fifo_dataq[256];

  always_ff @ (posedge Clk_i)  begin
    if(~Rstn_i)
	  msg_type_rdreq <= 1'b0;
	else 
	  msg_type_rdreq <= (~rx_fifo_empty) & msg_type & (~msg_type_rdreq);
     	
  end

end
else begin
  assign msg_type_rdreq = 1'b0;
end
endgenerate

assign rxfifo_rdreq = RxFifoRdReq_i | msg_type_rdreq;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// state machine to dump the data in the Rx buff to Rx FIFO


   always_ff @ (posedge Clk_i )
     begin
       if(~Rstn_i)
         rx_underflow_state <= RX_UNDERFLOW_IDLE;
       else
           rx_underflow_state <= rx_underflow_nxt_state;
       end

  always_comb
    begin
      case(rx_underflow_state)
        RX_UNDERFLOW_IDLE :
          if(rx_eop_fifo_count != 0 & rx_fifo_count <= 4)
            rx_underflow_nxt_state <= RX_UNDERFLOW_STREAM;
          else
            rx_underflow_nxt_state <= RX_UNDERFLOW_IDLE;

        RX_UNDERFLOW_STREAM:
           if(rx_buf_fifo_dataq_eop & (rx_eop_fifo_count == 0 | rx_fifo_count >= 8))
              rx_underflow_nxt_state <= RX_UNDERFLOW_IDLE;
           else if(rx_fifo_count >= 8)
             rx_underflow_nxt_state <= RX_UNDERFLOW_WAIT;
           else
             rx_underflow_nxt_state <= RX_UNDERFLOW_STREAM;

        RX_UNDERFLOW_WAIT:
          if(rx_fifo_count <= 4)
            rx_underflow_nxt_state <= RX_UNDERFLOW_STREAM;
          else
            rx_underflow_nxt_state <= RX_UNDERFLOW_WAIT;

        default:
            rx_underflow_nxt_state <= RX_UNDERFLOW_IDLE;
      endcase
    end

assign underflow_idle_state   =   (rx_underflow_state == RX_UNDERFLOW_IDLE);
assign underflow_stream_state =   (rx_underflow_state == RX_UNDERFLOW_STREAM);



assign rx_eop_fifo_rdreq = (underflow_idle_state & rx_eop_fifo_count != 0 & rx_fifo_count <= 4) |
                           (underflow_stream_state & rx_buf_fifo_dataq_eop & rx_fifo_count < 8 & rx_eop_fifo_count != 0);



  always_ff @ (posedge Clk_i )   /// memory too slow compare to eop flag, delay 2 clocks
     begin
       if(~Rstn_i)
         begin
           rx_eop_fifo_wrreq_delay_reg2 <= 1'b0;
           rx_eop_fifo_wrreq_delay_reg3 <= 1'b0;
         end
       else
         begin
           rx_eop_fifo_wrreq_delay_reg2 <=rx_input_eop_reg2 & rx_buf_fifo_wrreq;
           rx_eop_fifo_wrreq_delay_reg3 <= rx_eop_fifo_wrreq_delay_reg2;
         end
       end



altpcie_256_rp_fifo
   #(
    .FIFO_DEPTH(16),
    .DATA_WIDTH(1)
    )
 rx_eop_fifo
(
      .clk(Clk_i),
      .rstn(Rstn_i),
      .srst(1'b0),
      .wrreq(rx_eop_fifo_wrreq_delay_reg3),
      .rdreq(rx_eop_fifo_rdreq),
      .data(1'b1),
      .q(rx_eop_fifo_out),
      .fifo_count(rx_eop_fifo_count)
);



// ==============================================================================================

/// Rx input FIFO




/// Tag predecode fifo used to look ahead tag array for fmax
assign cpl_tag       = rx_input_data_reg[79:72];
assign is_cpl_wd     = rx_input_data_reg[30] & (rx_input_data_reg[28:24]==5'b01010) & rx_input_sop_reg;
assign valid_dma_rd_cpl = is_cpl_wd & cpl_tag <= 15;
assign tag_predecode_fifo_wrreq = valid_dma_rd_cpl & rx_input_valid_reg;

   altpcie_256_rp_fifo        #(
       .FIFO_DEPTH      (16),
       .DATA_WIDTH      (8)
   ) predecode_tag_fifo (
       .clk             (Clk_i),
       .rstn            (Rstn_i),
       .srst            (1'b0),
       .wrreq           (tag_predecode_fifo_wrreq),
       .rdreq           (PreDecodeTagRdReq_i),
       .data            (cpl_tag),
       .q               (PreDecodeTag_o),
       .fifo_count      (PreDecodeTagCount_o)
   );



/// Tx output FIFO
   generate begin : g_tx_output_fifo
      if (dma_use_scfifo_ext==1) begin
        altpcie_a10_scfifo_ext       # (
           .add_ram_output_register    ("ON"          ),
           .intended_device_family     ("Stratix V"   ),
           .lpm_numwords               (16            ),
           .lpm_showahead              ("OFF"         ),
           .lpm_type                   ("scfifo"      ),
           .lpm_width                  (TX_FIFO_WIDTH ),
           .lpm_widthu                 (4             ),
           .overflow_checking          ("ON"          ),
           .underflow_checking         ("ON"          ),
           .use_eab                    ("ON"          )
         )  tx_output_fifo             (
            .rdreq                     (tx_fifo_rdreq),
            .clock                     (Clk_i),
            .wrreq                     (TxFifoWrReq_i),
            .data                      (TxFifoData_i),
            .usedw                     (tx_fifo_count),
            .empty                     (output_fifo_rdempty),
            .q                         (tx_fifo_dataq),
            .full                      (),
            .aclr                      (~Rstn_i),
            .almost_empty              (),
            .almost_full               (),
            .sclr                      (1'b0)
         );
      end
      else if (dma_use_scfifo_ext==2) begin
        altpcie_sv_scfifo_ext        # (
           .add_ram_output_register    ("ON"          ),
           .intended_device_family     ("Stratix V"   ),
           .lpm_numwords               (16            ),
           .lpm_showahead              ("OFF"         ),
           .lpm_type                   ("scfifo"      ),
           .lpm_width                  (TX_FIFO_WIDTH ),
           .lpm_widthu                 (4             ),
           .overflow_checking          ("ON"          ),
           .underflow_checking         ("ON"          ),
           .use_eab                    ("ON"          )
         )  tx_output_fifo             (
            .rdreq                     (tx_fifo_rdreq),
            .clock                     (Clk_i),
            .wrreq                     (TxFifoWrReq_i),
            .data                      (TxFifoData_i),
            .usedw                     (tx_fifo_count),
            .empty                     (output_fifo_rdempty),
            .q                         (tx_fifo_dataq),
            .full                      (),
            .aclr                      (~Rstn_i),
            .almost_empty              (),
            .almost_full               (),
            .sclr                      (1'b0)
         );
      end
     else begin
         scfifo       # (
           .add_ram_output_register    ("ON"          ),
           .intended_device_family     ("Stratix V"   ),
           .lpm_numwords               (16            ),
           .lpm_showahead              ("OFF"         ),
           .lpm_type                   ("scfifo"      ),
           .lpm_width                  (TX_FIFO_WIDTH ),
           .lpm_widthu                 (4             ),
           .overflow_checking          ("ON"          ),
           .underflow_checking         ("ON"          ),
           .use_eab                    ("ON"          )
         )  tx_output_fifo             (
            .rdreq                     (tx_fifo_rdreq),
            .clock                     (Clk_i),
            .wrreq                     (TxFifoWrReq_i),
            .data                      (TxFifoData_i),
            .usedw                     (tx_fifo_count),
            .empty                     (output_fifo_rdempty),
            .q                         (tx_fifo_dataq),
            .full                      (),
            .aclr                      (~Rstn_i),
            .almost_empty              (),
            .almost_full               (),
            .sclr                      (1'b0)
         );
     end
   end
   endgenerate
   //SRIOV Support
     logic  [4+PFCNT_WD+VFCNT_WD-1:0]       sriov_rx_sideband,sriov_rx_sideband_reg,sriov_rx_sideband_reg2;
     logic  [1+PFCNT_WD+VFCNT_WD-1:0]       sriov_tx_sideband_reg;

   generate 
     if(SRIOV_EN) begin
       assign  sriov_rx_sideband                   = {RxSt_vf_active_i,RxSt_vf_num_i,RxSt_pf_num_i,RxStBar_range_i};
       assign  rx_fifo_data[RXFIFO_DATA_WIDTH-1:0] = {sriov_rx_sideband_reg2, rx_input_bardesc_reg2[5:0], rx_input_empty_reg2,rx_input_eop_reg2, rx_input_sop_reg2, rx_input_data_reg2} ;
       assign  TxSt_vf_active_o                    = sriov_tx_sideband_reg[PFCNT_WD+VFCNT_WD];
       assign  TxSt_vf_num_o                       = sriov_tx_sideband_reg[PFCNT_WD+VFCNT_WD-1:PFCNT_WD];
       assign  TxSt_pf_num_o                       = sriov_tx_sideband_reg[PFCNT_WD-1:0];
       
       always @ (posedge Clk_i) begin
         if (~Rstn_i) begin
           sriov_rx_sideband_reg    <=  {4+PFCNT_WD+VFCNT_WD{1'b0}} ;
           sriov_rx_sideband_reg2   <=  {4+PFCNT_WD+VFCNT_WD{1'b0}} ;
         end
         else begin
           sriov_rx_sideband_reg    <=  sriov_rx_sideband;
           sriov_rx_sideband_reg2   <=  sriov_rx_sideband_reg;
         end
       end

       always @ (posedge Clk_i) begin
         if (~Rstn_i) 
           sriov_tx_sideband_reg <= {1+PFCNT_WD+VFCNT_WD{1'b0}} ;
         else if(fifo_transmit)
           sriov_tx_sideband_reg <= tx_fifo_dataq[TX_FIFO_WIDTH-1:260];
         else if(output_transmit)
           sriov_tx_sideband_reg <= {1+PFCNT_WD+VFCNT_WD{1'b0}} ;
       end    
     end
     else begin
        assign rx_fifo_data[RXFIFO_DATA_WIDTH-1:0] = {rx_input_bardesc_reg2[5:0], rx_input_empty_reg2,rx_input_eop_reg2, rx_input_sop_reg2, rx_input_data_reg2};
        assign  TxSt_vf_active_o                   = 1'b0;
        assign  TxSt_vf_num_o                      = {VFCNT_WD{1'b0}};
        assign  TxSt_pf_num_o                      = {PFCNT_WD{1'b0}};
     end     
   endgenerate   


assign rx_fifo_wrreq = rx_input_valid_reg2;
assign RxStReady_o = (RX_BUFFER_ENABLE == 1)? (rx_buf_fifo_usedw <= 65 & PreDecodeTagCount_o <= 8 & rx_eop_fifo_count <= 4) :
                                              (rx_fifo_count <= 5 );

always @ (posedge Clk_i )
  begin
     if (~Rstn_i)
       begin
         cfg_addr_reg             <= 4'h0;
         rx_input_valid_reg       <= 1'b0;
         rx_input_sop_reg         <= 1'b0;
         rx_input_eop_reg         <= 1'b0;
         rx_input_empty_reg       <= 2'b00;
         rx_input_bardesc_reg     <= 6'h0;
         rx_input_valid_reg2      <= 1'b0;
         rx_input_sop_reg2        <= 1'b0;
         rx_input_eop_reg2        <= 1'b0;
         rx_input_empty_reg2      <= 2'b00;
         rx_input_bardesc_reg2    <= 6'h0;
       end
     else
       begin
         cfg_addr_reg                  <= CfgAddr_i[3:0];
         cfg_data_reg                  <= CfgCtl_i[31:0];
         rx_input_data_reg             <= RxStData_i;
         rx_input_valid_reg            <= RxStValid_i;
         rx_input_sop_reg              <= RxStSop_i;
         rx_input_eop_reg              <= RxStEop_i;
         rx_input_empty_reg            <= RxStEmpty_i;
         rx_input_bardesc_reg          <= RxStBarDec1_i[5:0];
         rx_input_data_reg2            <= rx_input_data_reg;
         rx_input_valid_reg2           <= rx_input_valid_reg;
         rx_input_sop_reg2             <= rx_input_sop_reg;
         rx_input_eop_reg2             <= rx_input_eop_reg;
         rx_input_empty_reg2           <= rx_input_empty_reg;
         rx_input_bardesc_reg2         <= rx_input_bardesc_reg;

      end
end


// Tx fifo interface
always @ (posedge Clk_i)
  begin
     if (~Rstn_i)
       tx_tlp_out_reg <= 256'h0;
     else if(fifo_transmit)
       tx_tlp_out_reg <= tx_fifo_dataq[DMA_WIDTH-1:0];
  end

always @ (posedge Clk_i )
  begin
     if (~Rstn_i)
      begin
       tx_sop_out_reg <= 1'b0;
       tx_eop_out_reg <= 1'b0;
       tx_empty_out_reg <= 1'b0;
      end
     else if(fifo_transmit)
      begin
       tx_sop_out_reg <= (DMA_WIDTH == 256) ? tx_fifo_dataq[256] : tx_fifo_dataq[128];
       tx_eop_out_reg <= (DMA_WIDTH == 256) ? tx_fifo_dataq[257] : tx_fifo_dataq[129];
       tx_empty_out_reg <= (DMA_WIDTH == 256) ? tx_fifo_dataq[259:258] : tx_fifo_dataq[130];
      end
     else if(output_transmit)
      begin
       tx_sop_out_reg <= 1'b0;
       tx_eop_out_reg <= 1'b0;
       tx_empty_out_reg <= 2'b00;
      end
  end

always @ (posedge Clk_i )
  begin
     if (~Rstn_i)
       output_valid_reg <= 1'b0;
     else if(fifo_transmit)
       output_valid_reg <= 1'b1;
     else if (output_transmit)
       output_valid_reg <= 1'b0;
  end

always @ (posedge Clk_i )
  begin
     if (~Rstn_i)
       fifo_valid_reg <= 1'b0;
     else if(tx_fifo_rdreq)
       fifo_valid_reg <= 1'b1;
     else if (fifo_transmit)
       fifo_valid_reg <= 1'b0;
  end

always @ (posedge Clk_i )
  begin
     if (~Rstn_i)
       tx_st_ready_reg <= 1'b0;
     else
       tx_st_ready_reg <= TxStReady_i;
  end


assign output_transmit = output_valid_reg & tx_st_ready_reg;
assign fifo_transmit   = fifo_valid_reg & (~output_valid_reg | output_valid_reg & output_transmit);
assign tx_fifo_rdreq = ~output_fifo_rdempty & (~fifo_valid_reg | fifo_valid_reg & fifo_transmit);

assign TxStData_o =tx_tlp_out_reg;
assign TxStSop_o  = tx_sop_out_reg;
assign TxStEop_o  = tx_eop_out_reg;
assign TxStEmpty_o[1:0] = tx_empty_out_reg[1:0];
assign TxStValid_o = output_transmit;

assign RxFifoCount_o = rx_fifo_count;

assign TxFifoCount_o = tx_fifo_count;


/// Config CTL
    //Configuration Demux logic

generate if (SRIOV_EN == 0)
  begin
    always @(posedge Clk_i )
      begin
            if(~Rstn_i)
              begin
            rstn_r <= 1'b0;
            rstn_rr <= 1'b0;
          end
        else
          begin
            rstn_r <= 1'b1;
            rstn_rr <= rstn_r;
        end
    end

    assign rstn_reg = rstn_rr;

    always @(posedge Clk_i )
      begin
        if (rstn_reg == 0)
          begin
            cfg_busdev  <= 13'h0;
            cfg_dev_csr <= 32'h0;
            msi_ena     <= 16'b0;
            msix_control <= 16'h0;
            msi_data    <= 16'h0;
            msi_addr    <= 64'h0;
            cfg_prmcsr  <= 16'h0;
          end
        else
          begin
            cfg_busdev          <= (cfg_addr_reg[3:0]==4'hF) ? cfg_data_reg[12 : 0]  : cfg_busdev;
            cfg_dev_csr         <= (cfg_addr_reg[3:0]==4'h0) ? {16'h0, cfg_data_reg[31 : 16]}  : cfg_dev_csr;
            msi_ena             <= (cfg_addr_reg[3:0]==4'hD) ? cfg_data_reg[15:0]   :  msi_ena;
            msix_control        <= (cfg_addr_reg[3:0] == 4'hD) ? cfg_data_reg[31:16]  :  msix_control;
            cfg_prmcsr          <= (cfg_addr_reg[3:0]==4'h3) ? cfg_data_reg[23:8]   :  cfg_prmcsr;
            msi_addr[11:0]      <= (cfg_addr_reg[3:0]==4'h5) ? cfg_data_reg[31:20]  :  msi_addr[11:0];
            msi_addr[31:12]     <= (cfg_addr_reg[3:0]==4'h9) ? cfg_data_reg[31:12]  :  msi_addr[31:12];
            msi_addr[43:32]     <= (cfg_addr_reg[3:0]==4'h6) ? cfg_data_reg[31:20]  :  msi_addr[43:32];
            msi_addr[63:44]     <= (cfg_addr_reg[3:0]==4'hB) ? cfg_data_reg[31:12]  :  msi_addr[63:44];
            msi_data[15:0]      <= (cfg_addr_reg[3:0]==4'hF) ? cfg_data_reg[31:16]  :  msi_data[15:0];
          end
      end

    always @(posedge Clk_i )
    begin
      if(~rstn_reg)
        begin
        msi_data_reg      <= 16'h0;
        msi_ena_reg       <= 16'h0;
        msix_control_reg  <= 16'h0;
        msi_addr_reg      <= 64'h0;
        end
      else
        begin
        msi_data_reg      <= msi_data;
        msi_addr_reg      <= msi_addr;
        msi_ena_reg       <= msi_ena;
        msix_control_reg  <= msix_control;
        end
    end
  end // generate
endgenerate

generate if (SRIOV_EN == 1) begin
      assign MsiIntfc_o         = {82{1'b0}};
	  assign MsixIntfc_o[15:0]  = {16{1'b0}};
      assign CfgBusDev_o[12:0]  = {bus_num_f0_i, device_num_f0_i};
      assign DevCsr_o[31:0]     = { 17'h0,                   //[31: 15]
                                    rd_req_size_i[2:0],      //[14:12] = MRRS,
                                    4'h0,                    //[11:;8]
                                    max_payload_size_i[2:0], //[7:5] = MPS
                                    5'h0                     //[4:0]
                                  };
      assign PciCmd_o           = {16'h0,
                                   9'h0,
                                   bus_master_en_vf_i,  //[3:0] MasterEnable for VF0 of PF0 (Borrow this bit to minimize changes)
                                   bus_master_en_pf_i,       //[2] MasterEnable for PF0
                                   2'h0
                                  };
      assign MsiDataCrl_o       = {32{1'b0}};

   end // generate for SRIOV
else begin // Normal non-config bypass for one function
       assign MsiIntfc_o[63:0]     = msi_addr_reg;
       assign MsiIntfc_o[79:64]    = msi_data_reg;
       assign MsiIntfc_o[80]       = msi_ena_reg[0];
       assign MsiIntfc_o[81]       = cfg_prmcsr[2];  // Master Enable
       assign MsixIntfc_o[15:0]    = msix_control_reg;
       assign CfgBusDev_o[12:0]    = cfg_busdev;
       assign DevCsr_o[31:0]       = cfg_dev_csr;
       assign PciCmd_o             = {16'h0, cfg_prmcsr};
       assign MsiDataCrl_o         = {msi_data_reg, msi_ena_reg};
   end
endgenerate

assign RxFifoDataq_o = rx_fifo_dataq;

endmodule
