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


module altpcieav_256_data_qwalign_bridge_tx
#(
     //----------------------------------------------------
     //------------- TOP LEVEL PARAMETERS -----------------
     //----------------------------------------------------
     parameter DEVICE_FAMILY               = "Stratix 10",
     parameter DBUS_WIDTH                  = 256,
     parameter BE_WIDTH                    = 32,
     parameter BURST_COUNT_WIDTH           = 6,
     parameter PF_COUNT                    = 4,
     parameter VF_COUNT                    = 4,
     parameter PFCNT_WD                    = 2,
     parameter VFCNT_WD                    = 2,
     parameter SRIOV_EN                    = 0
)
(

/// System Clock and Reset
   input      logic                                  Clk_i,
   input      logic                                  Rstn_i,

   //Tx application interface
   output   logic                                    App_HipTxStReady_o  ,
   input      logic  [DBUS_WIDTH-1:0]                App_HipTxStData_i   ,
   input      logic                                  App_HipTxStSop_i    ,
   input      logic                                  App_HipTxStEop_i    ,
   input      logic                                  App_HipTxStValid_i  ,
   input      logic                                  App_HipTxStError_i  ,
   input      logic  [PFCNT_WD-1:0]                  App_HipTxSt_pf_num_i,
   input      logic  [VFCNT_WD-1:0]                  App_HipTxSt_vf_num_i,
   input      logic                                  App_HipTxSt_vf_active_i,

   //HIP interface
   input       logic                                 HipTxStReady_i  ,
   output      logic  [DBUS_WIDTH-1:0]               HipTxStData_o   ,
   output      logic                                 HipTxStSop_o    ,
   output      logic                                 HipTxStEop_o    ,
   output      logic                                 HipTxStValid_o  ,
   output      logic                                 HipTxStError_o  ,
   output      logic  [PFCNT_WD-1:0]                 HipTxSt_pf_num_o,
   output      logic  [VFCNT_WD-1:0]                 HipTxSt_vf_num_o,
   output      logic                                 HipTxSt_vf_active_o

  );

    localparam    TXFIFO_DATA_WIDTH    =  SRIOV_EN ? VFCNT_WD+PFCNT_WD+1+260 : 260; //SRIOV-VF Num, PF Num, 1-Bit VF Active, 3-Bit Bar Number //QW Align, err,eop,sop,data[255:0] ;
    localparam    TXFIFO_DATA_PF_NUM_HIGH_INDEX    =  261+PFCNT_WD ;
    localparam    FIFO_COUNT_WIDTH = 4;

    //State Machine states
    localparam    TX_HIPDATA_IDLE   = 3'h0;
    localparam    TX_HIPDATA_WAIT   = 3'h1;
    localparam    TX_HIPDATA_SEND  = 3'h3;
    localparam    TX_HIPDATA_READ_EXTRA = 3'h4;

    logic  [2:0]                         tx_hipdata_state;
    logic  [2:0]                         tx_hipdata_next_state;

    logic                                tx_hip_send;
    logic                                tx_hip_read_extra;
    logic                                tx_hip_idle;
    logic                                tx_hip_wait;


    logic  [DBUS_WIDTH-1:0]              App_HipTxStData_reg        ;
    logic                                App_HipTxStSop_reg           ;
    logic                                App_HipTxStEop_reg           ;
    logic                                App_HipTxStValid_reg         ;
    logic                                App_HipTxStError_reg         ;
    logic  [PFCNT_WD-1:0]                App_HipTxSt_pf_num_reg       ;
    logic  [VFCNT_WD-1:0]                App_HipTxSt_vf_num_reg       ;
    logic                                App_HipTxSt_vf_active_reg  ;

    logic  [DBUS_WIDTH-1:0]              HipTxStData_reg       ;
    logic                                HipTxStSop_reg        ;
    logic                                HipTxStEop_reg        ;
    logic                                HipTxStValid_reg      ;
    logic                                HipTxStError_reg      ;
    logic  [PFCNT_WD-1:0]                HipTxSt_pf_num_reg    ;
    logic  [VFCNT_WD-1:0]                HipTxSt_vf_num_reg    ;
    logic                                HipTxSt_vf_active_reg   ;


    logic                                tx_QW_align;
    logic                                tx_extra_read_needed;
    logic                                tx_QW_align_reg;
    logic                                tx_extra_read_needed_reg;

    logic  [TXFIFO_DATA_WIDTH-1:0]       tx_fifo_dataq_reg;
    logic  [DBUS_WIDTH-1:0]              tx_hip_data    ;
    logic                                tx_hip_sop    ;
    logic                                tx_hip_eop    ;
    logic                                tx_hip_err    ;
    logic                                tx_hip_valid  ;
    logic  [PFCNT_WD-1:0]                tx_hip_pf_num  ;
    logic  [VFCNT_WD-1:0]                tx_hip_vf_num    ;
    logic                                tx_hip_vf_active ;

    //Fifo Signals
    logic                                tx_fifo_wrreq;
    logic                                tx_fifo_rdreq;
    logic  [TXFIFO_DATA_WIDTH-1:0]       tx_fifo_data;
    logic  [TXFIFO_DATA_WIDTH-1:0]       tx_fifo_dataq;
    logic  [FIFO_COUNT_WIDTH-1 :0]       tx_fifo_count;

    logic  [TXFIFO_DATA_WIDTH-1:0]       tx_fifo_dataq1;
    logic  [FIFO_COUNT_WIDTH-1 :0]       tx_fifo_count1;

    //REG ALL INPUTS
    always @(posedge Clk_i or negedge Rstn_i)
    begin
        if (Rstn_i == 1'b0) begin
           App_HipTxStData_reg                 <=        {256{1'b0}}    ;
            App_HipTxStSop_reg                 <=        1'b0    ;
            App_HipTxStEop_reg                 <=        1'b0    ;
            App_HipTxStValid_reg               <=        1'b0    ;
            App_HipTxStError_reg               <=        1'b0    ;
            App_HipTxSt_pf_num_reg             <=        {PFCNT_WD-1{1'b0}}    ;
            App_HipTxSt_vf_num_reg             <=        {VFCNT_WD-1{1'b0}}    ;
            App_HipTxSt_vf_active_reg          <=        1'b0    ;
        end
        else begin
            App_HipTxStData_reg                <=        App_HipTxStData_i       ;
            App_HipTxStSop_reg                 <=        App_HipTxStSop_i        ;
            App_HipTxStEop_reg                 <=        App_HipTxStEop_i        ;
            App_HipTxStValid_reg               <=        App_HipTxStValid_i      ;
            App_HipTxStError_reg               <=        App_HipTxStError_i      ;
            App_HipTxSt_pf_num_reg             <=        App_HipTxSt_pf_num_i    ;
            App_HipTxSt_vf_num_reg             <=        App_HipTxSt_vf_num_i    ;
            App_HipTxSt_vf_active_reg          <=        App_HipTxSt_vf_active_i    ;
        end
     end

    //Pre Calculating
    //QW Align Removed if TLP with Data  -> 3DW Header & QW Address Align  or 4DW Header && Non QW Address Align
    assign tx_QW_align      =  (App_HipTxStData_reg[30]==1'b0) ? 1'b0 : (App_HipTxStData_reg[29] ==1'b0) ? ~App_HipTxStData_reg[66] : App_HipTxStData_reg[98]  ;  // To Indicate if we need to Remove QW Align the data to HIP Side

    //Fifo Control
    assign tx_fifo_wrreq    = App_HipTxStValid_reg && tx_fifo_count < 4'he ;
    assign tx_fifo_rdreq    = ~tx_hip_wait && (tx_fifo_count > 4'h0)  && (tx_hip_read_extra || tx_hip_send || tx_hip_idle) ;

    //Fifo Data
    generate begin : sriov_sideband_signals_fifo
       if (SRIOV_EN==0)
          assign tx_fifo_data     =  {tx_QW_align,App_HipTxStError_reg,App_HipTxStEop_reg,App_HipTxStSop_reg,App_HipTxStData_reg} ;
       else
          assign tx_fifo_data     =  {App_HipTxSt_vf_num_reg,App_HipTxSt_pf_num_reg,App_HipTxSt_vf_active_reg,tx_QW_align,App_HipTxStError_reg,App_HipTxStEop_reg,App_HipTxStSop_reg,App_HipTxStData_reg} ;
       end
    endgenerate


    altpcie_256_rp_fifo
        #(
        .FIFO_DEPTH(16),
        .DATA_WIDTH(TXFIFO_DATA_WIDTH)
        )
    tx_fifo1
    (
            .clk(Clk_i),
            .rstn(Rstn_i),
            .srst(1'b0),
            .wrreq(tx_fifo_wrreq ),
            .rdreq(tx_fifo_rdreq),
            .data(tx_fifo_data),
            .q(tx_fifo_dataq),
            .fifo_count(tx_fifo_count)
    );


    //Assign Outputs
    assign   HipTxStData_o       =  HipTxStData_reg       ;
    assign   HipTxStSop_o        =  HipTxStSop_reg        ;
    assign   HipTxStEop_o        =  HipTxStEop_reg        ;
    assign   HipTxStValid_o      =  HipTxStValid_reg      ;
    assign   HipTxStError_o      =  HipTxStError_reg      ;
    assign   HipTxSt_pf_num_o    =  HipTxSt_pf_num_reg    ;
    assign   HipTxSt_vf_num_o    =  HipTxSt_vf_num_reg    ;
    assign   HipTxSt_vf_active_o =  HipTxSt_vf_active_reg   ;
    assign   App_HipTxStReady_o  =  (tx_fifo_count <=8 );




    //Tx data path state machine
    always @(posedge Clk_i or negedge Rstn_i)
    begin
        if (~Rstn_i )
            tx_hipdata_state <= TX_HIPDATA_IDLE ;
        else
            tx_hipdata_state <= tx_hipdata_next_state;
    end

    always_comb
    begin
        case (tx_hipdata_state)
            TX_HIPDATA_IDLE:
                if ( HipTxStReady_i == 1'b0 )
                    tx_hipdata_next_state <= TX_HIPDATA_WAIT ;
                else if ( tx_fifo_count>0)
                    tx_hipdata_next_state <= TX_HIPDATA_SEND ;
                else
                    tx_hipdata_next_state <= TX_HIPDATA_IDLE ;


            TX_HIPDATA_WAIT:
                if ( HipTxStReady_i == 1'b0 )
                    tx_hipdata_next_state <= TX_HIPDATA_WAIT ;
                else if ( tx_fifo_count>0)
                    tx_hipdata_next_state <= TX_HIPDATA_SEND ;
                else
                    tx_hipdata_next_state <= TX_HIPDATA_IDLE ;


            TX_HIPDATA_SEND :
                if ((tx_extra_read_needed && tx_fifo_dataq[257]== 1'b1) && tx_fifo_count>4'h0)
                    tx_hipdata_next_state <= TX_HIPDATA_READ_EXTRA ;
                else if (HipTxStReady_i == 1'b0 )
                    tx_hipdata_next_state <= TX_HIPDATA_WAIT ;
                else if ( tx_fifo_count>4'h0 )
                    tx_hipdata_next_state <= TX_HIPDATA_SEND ;
                else
                    tx_hipdata_next_state <= TX_HIPDATA_IDLE ;

            TX_HIPDATA_READ_EXTRA :
                if (HipTxStReady_i == 1'b0 )
                    tx_hipdata_next_state <= TX_HIPDATA_WAIT ;
                else if ( tx_fifo_count>0)
                    tx_hipdata_next_state <= TX_HIPDATA_SEND ;
                else
                    tx_hipdata_next_state <= TX_HIPDATA_IDLE ;

            default:
                tx_hipdata_next_state<= TX_HIPDATA_IDLE;
        endcase
    end

    //State Machine Control Signals
    assign tx_hip_idle             = (tx_hipdata_state == TX_HIPDATA_IDLE) ;
    assign tx_hip_wait             = (tx_hipdata_state == TX_HIPDATA_WAIT) ;
    assign tx_hip_send             = (tx_hipdata_state == TX_HIPDATA_SEND) ;
    assign tx_hip_read_extra       = (tx_hipdata_state == TX_HIPDATA_READ_EXTRA) ;

    //assign tx_extra_tlp_needed = SOP ? ((tx_QW_align ==1'b1) ? ((3dw_header ) ? (length %8 ==5  ) :  ( length%8 ==4  ) ) : 1'b0) : tx_extra_read_needed_reg ;
    assign tx_extra_read_needed = (tx_fifo_dataq[256] ==1'b1 ) ? ((tx_fifo_dataq[259] ==1'b1) ? ((tx_fifo_dataq[29] ==1'b0 ) ? (tx_fifo_dataq[2:0] ==3'h5  ) :  (tx_fifo_dataq[2:0] ==3'h4  ) ) : 1'b0) : tx_extra_read_needed_reg ;

    always @(posedge Clk_i)
    begin
        if (~tx_hip_wait ) begin
            tx_fifo_dataq_reg <= tx_fifo_dataq;
        end
    end


    always @ (posedge Clk_i)
    begin
        if (tx_fifo_dataq[256] ==1'b1  && tx_fifo_count>4'h0 && ~tx_hip_wait  ) begin
            tx_QW_align_reg           <= tx_fifo_dataq[259]       ;
            tx_extra_read_needed_reg  <= tx_extra_read_needed;
        end

    end


    always_comb
    begin
        if (tx_QW_align_reg ==1'b0) begin
            tx_hip_data   = tx_fifo_dataq_reg[255:0];
            tx_hip_eop    = tx_fifo_dataq_reg[257];
        end
        else if( tx_fifo_dataq_reg[256] == 1'b1) begin  // SOP =1
             if (tx_fifo_dataq_reg[29]) begin // if(tx_header_4dw_reg) begin
                tx_hip_data   = {tx_fifo_dataq[31:0],tx_fifo_dataq_reg[255:160],tx_fifo_dataq_reg[127:0]};
             end
             else begin
                tx_hip_data   = {tx_fifo_dataq[31:0],tx_fifo_dataq_reg[255:128],tx_fifo_dataq_reg[95:0]};
             end
             if (tx_extra_read_needed && tx_fifo_dataq[257]== 1'b1&& tx_fifo_count>4'h0 )
                tx_hip_eop = 1'b1;
             else
                tx_hip_eop   = tx_fifo_dataq_reg[257] ;
        end
        else begin
          //  if (HipTxStReady_i != 1'b0 )
               tx_hip_data = {tx_fifo_dataq[31:0],tx_fifo_dataq_reg[255:32]};
         //   else
         //      tx_hip_data = tx_fifo_dataq_reg;
            if (tx_extra_read_needed && tx_fifo_dataq[257]== 1'b1&& tx_fifo_count>4'h0 )
               tx_hip_eop = 1'b1;
            else
               tx_hip_eop  = tx_fifo_dataq_reg[257] ;
        end

    end


   assign tx_hip_valid =  tx_hip_send ;
   assign tx_hip_sop   =  tx_fifo_dataq_reg[256];
   assign tx_hip_err   =  tx_fifo_dataq_reg[258];

    generate begin
       if (SRIOV_EN==0)  begin : no_sriov
          assign tx_hip_pf_num    = {PFCNT_WD-1{1'b0}}   ;
          assign tx_hip_vf_num    = {VFCNT_WD-1{1'b0}}   ;
          assign tx_hip_vf_active = 1'b0;
      end
      else begin :sriov
          assign tx_hip_pf_num    = tx_fifo_dataq_reg[TXFIFO_DATA_PF_NUM_HIGH_INDEX-1: 261];
          assign tx_hip_vf_num    = tx_fifo_dataq_reg[TXFIFO_DATA_WIDTH-1:TXFIFO_DATA_PF_NUM_HIGH_INDEX];
          assign tx_hip_vf_active = tx_fifo_dataq_reg[260];
      end
    end
    endgenerate

    always @ (posedge Clk_i or negedge Rstn_i)
    begin
        if (Rstn_i == 1'b0) begin
            HipTxStData_reg           <=   {256{1'b0}}    ;
            HipTxStSop_reg            <=   1'b0    ;
            HipTxStEop_reg            <=   1'b0    ;
            HipTxStValid_reg          <=   1'b0    ;
            HipTxStError_reg          <=   1'b0    ;
            HipTxSt_pf_num_reg        <=   {PFCNT_WD-1{1'b0}}   ;
            HipTxSt_vf_num_reg        <=   {VFCNT_WD-1{1'b0}}   ;
            HipTxSt_vf_active_reg     <=   1'b0       ;
        end
        else begin
            HipTxStData_reg           <=   tx_hip_data    ;
            HipTxStSop_reg            <=   tx_hip_sop && tx_hip_valid        ;
            HipTxStEop_reg            <=   tx_hip_eop && tx_hip_valid        ;
            HipTxStValid_reg          <=   tx_hip_valid    ;
            HipTxStError_reg          <=   tx_hip_err    ;
            HipTxSt_pf_num_reg        <=   tx_hip_pf_num ;
            HipTxSt_vf_num_reg        <=   tx_hip_vf_num ;
            HipTxSt_vf_active_reg     <=   tx_hip_vf_active ;
        end
    end

endmodule



