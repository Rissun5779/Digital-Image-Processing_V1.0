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


module altpcieav_256_data_qwalign_bridge_rx
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
   input  logic                               Clk_i,
   input  logic                               Rstn_i,

//Rx port interface of PCI Exp HIP
   input  logic  [DBUS_WIDTH-1:0]             HipRxStData_i,
   input  logic  [2:0]                        HipRxStEmpty_i,
   input  logic                               HipRxStSop_i,
   input  logic                               HipRxStEop_i,
   input  logic                               HipRxStValid_i,
   input  logic  [2:0]                        HipRxStBarRange_i,
   input  logic  [2:0]                        HipRxStBar_range_i,   //SRIOV Signal
   input  logic  [PFCNT_WD-1:0]               HipRxSt_pf_num_i,     //SRIOV Signal
   input  logic  [VFCNT_WD-1:0]               HipRxSt_vf_num_i,     //SRIOV Signal
   input  logic                               HipRxSt_vf_active_i,  //SRIOV Signal
   output  logic                              HipRxStReady_o,

//Rx Port Interface of the APP
   output  logic  [DBUS_WIDTH-1:0]            App_HipRxStData_o,
   output  logic  [1:0]                       App_HipRxStEmpty_o,
   output  logic                              App_HipRxStSop_o,
   output  logic                              App_HipRxStEop_o,
   output  logic                              App_HipRxStValid_o,
   output  logic  [7:0]                       App_HipRxStBarDec1_o,
   output  logic  [2:0]                       App_HipRxStBar_range_o,  //SRIOV Signal
   output  logic  [PFCNT_WD-1:0]              App_HipRxSt_pf_num_o,    //SRIOV Signal
   output  logic  [VFCNT_WD-1:0]              App_HipRxSt_vf_num_o,    //SRIOV Signal
   output  logic                              App_HipRxSt_vf_active_o, //SRIOV Signal
   input  logic                               App_HipRxStReady_i


  );

   localparam RXFIFO_DATA_WIDTH    =  SRIOV_EN ? VFCNT_WD+PFCNT_WD+1+3+268 : 268; //SRIOV - VF Num, PF Num, 1-Bit VF Active, 3-Bit Bar Number// QW_align , Bar_decode[6:0], Empty[1:0], EOP , SOP , Data [255:0]
   localparam RXFIFO_DATA_PF_NUM_HIGH_INDEX = 272+PFCNT_WD;
   localparam FIFO_COUNT_WIDTH = 4;
   //State Machine states
   localparam RX_APPDATA_IDLE  = 2'h0;
   localparam RX_APPDATA_WAIT  = 2'h1;
   localparam RX_APPDATA_SEND  = 2'h2;
   localparam RX_APPDATA_SEND_EXTRA  = 2'h3;

   logic  [1:0]                        rx_appdata_state;
   logic  [1:0]                        rx_appdata_next_state;

   logic                               rx_app_send;
   logic                               rx_app_send_extra;
   logic                               rx_app_idle;
   logic                               rx_app_wait;
   logic                               rx_app_send_extra_reg;

   logic  [DBUS_WIDTH-1:0]             HipRxStData_reg;
   logic  [1:0]                        HipRxStEmpty_reg;
   logic                               HipRxStSop_reg;
   logic                               HipRxStEop_reg;
   logic                               HipRxStValid_reg;
   logic  [2:0]                        HipRxStBarRange_reg;
   logic  [7:0]                        HipRxStBarDec1;

   logic  [2:0]                        HipRxStBar_range_reg;
   logic  [PFCNT_WD-1:0]               HipRxSt_pf_num_reg;
   logic  [VFCNT_WD-1:0]               HipRxSt_vf_num_reg;
   logic                               HipRxSt_vf_active_reg;


   logic  [DBUS_WIDTH-1:0]             App_HipRxStData_reg;
   logic  [1:0]                        App_HipRxStEmpty_reg;
   logic                               App_HipRxStSop_reg;
   logic                               App_HipRxStEop_reg;
   logic                               App_HipRxStValid_reg;
   logic  [7:0]                        App_HipRxStBarDec1_reg;
   logic  [2:0]                        App_HipRxStBar_range_reg;
   logic  [PFCNT_WD-1:0]               App_HipRxSt_pf_num_reg;
   logic  [VFCNT_WD-1:0]               App_HipRxSt_vf_num_reg;
   logic                               App_HipRxSt_vf_active_reg;
   logic                               App_HipRxStReady_reg;


   logic                               rx_QW_align;
   logic                               rx_extra_tlp_needed;
   logic                               rx_QW_align_reg;
   logic                               rx_extra_tlp_needed_reg;

   logic  [RXFIFO_DATA_WIDTH-1:0]      rx_fifo_dataq_reg;
   logic  [RXFIFO_DATA_WIDTH-1:0]      rx_fifo_dataq_reg2;
   logic  [DBUS_WIDTH-1:0]             rx_app_data;
   logic                               rx_app_sop;
   logic                               rx_app_eop;
   logic                               rx_app_valid;
   logic  [1:0]                        rx_app_empty;
   logic  [6:0]                        rx_app_bardecode;
   logic  [2:0]                        rx_app_barrange;
   logic  [PFCNT_WD-1:0]               rx_app_pf_num;
   logic  [VFCNT_WD-1:0]               rx_app_vf_num;
   logic                               rx_app_vf_active;

//Fifo Signals
   logic                               rx_fifo_wrreq;
   logic                               rx_fifo_rdreq;
   logic  [RXFIFO_DATA_WIDTH-1:0]      rx_fifo_data;
   logic  [RXFIFO_DATA_WIDTH-1:0]      rx_fifo_dataq;
   logic  [FIFO_COUNT_WIDTH-1 :0]      rx_fifo_count;


    //Reg all inputs
   always @(posedge Clk_i or negedge Rstn_i)
   begin
       if (Rstn_i == 1'b0) begin
           HipRxStData_reg            <={256{1'b0}};
           HipRxStEmpty_reg           <=2'h0;
           HipRxStSop_reg             <=1'b0;
           HipRxStEop_reg             <=1'b0;
           HipRxStValid_reg           <=1'b0;
           HipRxStBarRange_reg        <=3'h0;
           HipRxStBar_range_reg       <=3'h0;
           HipRxSt_pf_num_reg         <={PFCNT_WD-1{1'b0}};
           HipRxSt_vf_num_reg         <={VFCNT_WD-1{1'b0}};
           HipRxSt_vf_active_reg      <=1'b0;
           App_HipRxStReady_reg       <=1'b0;
       end
       else begin
           HipRxStData_reg            <=HipRxStData_i;
           HipRxStEmpty_reg           <=HipRxStEmpty_i[2:1];   //Only two bit Error Interface in A10
           HipRxStSop_reg             <=HipRxStSop_i;
           HipRxStEop_reg             <=HipRxStEop_i;
           HipRxStValid_reg           <=HipRxStValid_i;
           HipRxStBarRange_reg        <=HipRxStBarRange_i;
           HipRxStBar_range_reg       <=HipRxStBar_range_i;
           HipRxSt_pf_num_reg         <=HipRxSt_pf_num_i;
           HipRxSt_vf_num_reg         <=HipRxSt_vf_num_i;
           HipRxSt_vf_active_reg      <=HipRxSt_vf_active_i;
           App_HipRxStReady_reg       <=App_HipRxStReady_i ;
       end
   end


   //Pre Calculating
   //QW Align Needed if TLP with Data  - > 3DW Header & QW Address or 4DW Header && Non QW Address
   //assign rx_QW_align     = SOP ? ( TLP without Data? 1'b0 : (3dw_header) ? ~addr[2] : addr[2] ) : rx_QW_align_reg;
   assign rx_QW_align       =  ( (HipRxStData_reg[30]==1'b0) ? 1'b0 : (HipRxStData_reg[29] ==1'b0) ? ~HipRxStData_reg[66] : HipRxStData_reg[98] ) & HipRxStSop_reg ;

   //Fifo Control
   assign rx_fifo_wrreq    = (HipRxStValid_reg && rx_fifo_count < 4'he );
   assign rx_fifo_rdreq    =  ~rx_app_wait &&  (rx_fifo_count >4'h0)  && ( rx_app_idle ||  (rx_app_send && ~(rx_extra_tlp_needed && rx_fifo_dataq[257]) ||rx_app_send_extra ));

   //Fifo Data
   generate begin : sriov_sideband_signals_fifo
      if (SRIOV_EN==0)
         assign rx_fifo_data     =  {rx_QW_align,HipRxStBarDec1[6:0],HipRxStEmpty_reg,HipRxStEop_reg,HipRxStSop_reg,HipRxStData_reg} ;
      else
         assign rx_fifo_data     =  {HipRxSt_vf_num_reg,HipRxSt_pf_num_reg,HipRxSt_vf_active_reg,HipRxStBar_range_reg,rx_QW_align,HipRxStBarDec1[6:0],HipRxStEmpty_reg,HipRxStEop_reg,HipRxStSop_reg,HipRxStData_reg} ;
      end
   endgenerate


   //Calculate Bar Decode from Bar Range
   always_comb
   begin
      case (HipRxStBarRange_reg)
         3'b000 : HipRxStBarDec1 = 8'b00000001;
         3'b001 : HipRxStBarDec1 = 8'b00000010;
         3'b010 : HipRxStBarDec1 = 8'b00000100;
         3'b011 : HipRxStBarDec1 = 8'b00001000;
         3'b100 : HipRxStBarDec1 = 8'b00010000;
         3'b101 : HipRxStBarDec1 = 8'b00100000;
         3'b110 : HipRxStBarDec1 = 8'b10000000;
         3'b111 : HipRxStBarDec1 = 8'b01000000;
      endcase
   end


   // Rx Fifo
   altpcie_256_rp_fifo
       #(
       .FIFO_DEPTH(16),
       .DATA_WIDTH(RXFIFO_DATA_WIDTH)
       )
   rx_input_fifo
   (
           .clk(Clk_i),
           .rstn(Rstn_i),
           .srst(1'b0),
           .wrreq(rx_fifo_wrreq ),
           .rdreq(rx_fifo_rdreq),
           .data(rx_fifo_data),
           .q(rx_fifo_dataq),
           .fifo_count(rx_fifo_count)
    );


     // Assigning Outputs

   assign            App_HipRxStData_o         =  App_HipRxStData_reg;
   assign            App_HipRxStEmpty_o        =  App_HipRxStEmpty_reg;
   assign            App_HipRxStSop_o          =  App_HipRxStSop_reg;
   assign            App_HipRxStEop_o          =  App_HipRxStEop_reg;
   assign            App_HipRxStValid_o        =  App_HipRxStValid_reg;
   assign            App_HipRxStBarDec1_o      =  App_HipRxStBarDec1_reg;
   assign            App_HipRxStBar_range_o    =  App_HipRxStBar_range_reg;
   assign            App_HipRxSt_pf_num_o      =  App_HipRxSt_pf_num_reg;
   assign            App_HipRxSt_vf_num_o      =  App_HipRxSt_vf_num_reg;
   assign            App_HipRxSt_vf_active_o   =  App_HipRxSt_vf_active_reg;
   assign            HipRxStReady_o            =  (rx_fifo_count <4'h8);





    //Rx data path state machine
    always @(posedge Clk_i or negedge Rstn_i)  // state machine registers
    begin
        if(~Rstn_i)
            rx_appdata_state <= RX_APPDATA_IDLE;
        else
            rx_appdata_state <= rx_appdata_next_state;
    end



    always_comb
    begin
        case (rx_appdata_state)
            RX_APPDATA_IDLE:
                if ( App_HipRxStReady_i == 1'b0 )
                    rx_appdata_next_state <= RX_APPDATA_WAIT ;
                else if (rx_extra_tlp_needed && rx_fifo_dataq[257] && ( rx_fifo_count>4'h0) )
                    rx_appdata_next_state <= RX_APPDATA_SEND_EXTRA ;
                else if ( rx_fifo_count>4'h0)
                    rx_appdata_next_state <= RX_APPDATA_SEND ;
                else
                    rx_appdata_next_state <= RX_APPDATA_IDLE ;


            RX_APPDATA_WAIT:
                if ( App_HipRxStReady_i  == 1'b0 )
                    rx_appdata_next_state <= RX_APPDATA_WAIT ;
                else if (rx_extra_tlp_needed && rx_fifo_dataq[257] && ( rx_fifo_count>4'h0)  )
                    rx_appdata_next_state <= RX_APPDATA_SEND_EXTRA ;
                else if ( rx_fifo_count>4'h0)
                    rx_appdata_next_state <= RX_APPDATA_SEND ;
                else
                    rx_appdata_next_state <= RX_APPDATA_IDLE ;


            RX_APPDATA_SEND :
                if (App_HipRxStReady_i  == 1'b0 )
                    rx_appdata_next_state <= RX_APPDATA_WAIT ;
                else if (rx_extra_tlp_needed && rx_fifo_dataq[257] && ( rx_fifo_count>4'h0) )
                    rx_appdata_next_state <= RX_APPDATA_SEND_EXTRA ;
                else if ( rx_fifo_count>4'h0 )
                    rx_appdata_next_state <= RX_APPDATA_SEND ;
                else
                    rx_appdata_next_state <= RX_APPDATA_IDLE ;

            RX_APPDATA_SEND_EXTRA : // Send Extra TLP due to QW Align
                if (App_HipRxStReady_i  == 1'b0 )
                    rx_appdata_next_state <= RX_APPDATA_WAIT ;
                else
                    rx_appdata_next_state <= RX_APPDATA_SEND ;

            default:
                rx_appdata_next_state<= RX_APPDATA_IDLE;
        endcase
    end





    always @ (posedge Clk_i)
    begin
        if (~rx_app_wait ) begin
            rx_fifo_dataq_reg <= rx_fifo_dataq;
            rx_fifo_dataq_reg2 <= rx_fifo_dataq_reg;
        end
    end

    //State Machine Control Signals
    assign rx_app_send       = (rx_appdata_state == RX_APPDATA_SEND );
    assign rx_app_send_extra = (rx_appdata_state == RX_APPDATA_SEND_EXTRA );
    assign rx_app_idle       = (rx_appdata_state == RX_APPDATA_IDLE );
    assign rx_app_wait       = (rx_appdata_state == RX_APPDATA_WAIT );

    //assign rx_extra_tlp_needed = SOP ? ((rx_QW_align ==1'b1) ? ((3dw_header ) ? (length %8 ==5  ) :  ( length%8 ==4  ) ) : 1'b0) : rx_extra_tlp_needed_reg ;
    assign  rx_extra_tlp_needed = (rx_fifo_dataq[256] ==1'b1 ) ? ((rx_fifo_dataq[267] ==1'b1) ? ((rx_fifo_dataq[29] ==1'b0 ) ? (rx_fifo_dataq[2:0] ==3'h5  ) :  (rx_fifo_dataq[2:0] ==3'h4  ) ) : 1'b0) : rx_extra_tlp_needed_reg ;

    always @ (posedge Clk_i)
    begin
        if (rx_fifo_dataq[256] ==1'b1 & ( rx_fifo_count>4'h0) & App_HipRxStReady_reg ) begin
            rx_QW_align_reg     <= rx_fifo_dataq[267]  ;
            rx_extra_tlp_needed_reg <= rx_extra_tlp_needed;
        end
        if (rx_app_wait ==1'b0 ) begin
            rx_app_send_extra_reg <= rx_app_send_extra;
        end
    end



    always_comb
    begin
        if (rx_QW_align_reg == 1'b0) begin
            rx_app_data      = rx_fifo_dataq_reg[255:0];
            rx_app_sop       = rx_fifo_dataq_reg[256];
            rx_app_eop       = rx_fifo_dataq_reg[257];
            rx_app_empty     = rx_fifo_dataq_reg[259:258];
            rx_app_bardecode = rx_fifo_dataq_reg[266:260];
        end
        else if ( rx_app_send_extra_reg) begin
            rx_app_data      = {rx_fifo_dataq_reg[223:0],rx_fifo_dataq_reg2[255:224]};
            rx_app_sop       = 1'b0;
            rx_app_eop       = 1'b1;
            rx_app_empty     = 2'h3;
            rx_app_bardecode = rx_fifo_dataq_reg2[266:260];

        end
        else  begin
            if( rx_fifo_dataq_reg[256] == 1'b1) begin  // SOP =1
                if (rx_fifo_dataq_reg[29]) begin // if(4dw_header) begin
                    rx_app_data   = {rx_fifo_dataq_reg[223:128],32'h0000_0000,rx_fifo_dataq_reg[127:0]};
                end
                else begin // (3dw_header) begin
                    rx_app_data   = {rx_fifo_dataq_reg[223:96],32'h0000_0000,rx_fifo_dataq_reg[95:0]};
                end
            end
            else
                rx_app_data = {rx_fifo_dataq_reg[223:0],rx_fifo_dataq_reg2[255:224]};

            rx_app_sop       = rx_fifo_dataq_reg[256];
            rx_app_eop       = rx_fifo_dataq_reg[257] && ~rx_app_send_extra ;
            rx_app_empty     = rx_fifo_dataq_reg[259:258];
            rx_app_bardecode = rx_fifo_dataq_reg[266:260];
        end
    end
    assign    rx_app_valid = rx_app_send || rx_app_send_extra;

    generate begin
       if (SRIOV_EN==0)  begin : no_sriov
           always_comb
           begin
                  rx_app_barrange  = 3'b000;
                  rx_app_vf_active = 1'b0;
                  rx_app_pf_num    = {PFCNT_WD-1{1'b0}};
                  rx_app_vf_num    = {VFCNT_WD-1{1'b0}};
           end
       end
       else begin : sriov
           always_comb
           begin
              if (rx_QW_align_reg == 1'b0) begin
                  rx_app_barrange  = rx_fifo_dataq_reg[270:268];
                  rx_app_vf_active = rx_fifo_dataq_reg[271];
                  rx_app_pf_num    = rx_fifo_dataq_reg[RXFIFO_DATA_PF_NUM_HIGH_INDEX-1:272];
                  rx_app_vf_num    = rx_fifo_dataq_reg[RXFIFO_DATA_WIDTH-1:RXFIFO_DATA_PF_NUM_HIGH_INDEX];
              end
              else if ( rx_app_send_extra_reg) begin
                  rx_app_barrange  = rx_fifo_dataq_reg2[270:268];
                  rx_app_vf_active = rx_fifo_dataq_reg2[271];
                  rx_app_pf_num    = rx_fifo_dataq_reg2[RXFIFO_DATA_PF_NUM_HIGH_INDEX-1:272];
                  rx_app_vf_num    = rx_fifo_dataq_reg2[RXFIFO_DATA_WIDTH-1:RXFIFO_DATA_PF_NUM_HIGH_INDEX];
              end
              else  begin
                  rx_app_barrange  = rx_fifo_dataq_reg[270:268];
                  rx_app_vf_active = rx_fifo_dataq_reg[271];
                  rx_app_pf_num    = rx_fifo_dataq_reg[RXFIFO_DATA_PF_NUM_HIGH_INDEX-1:272];
                  rx_app_vf_num    = rx_fifo_dataq_reg[RXFIFO_DATA_WIDTH-1:RXFIFO_DATA_PF_NUM_HIGH_INDEX];
              end
           end
       end
    end
    endgenerate

    always @ (posedge Clk_i or negedge Rstn_i)
    begin
        if (Rstn_i == 1'b0) begin
            App_HipRxStData_reg            <={256{1'b0}};
            App_HipRxStEmpty_reg           <=2'h0;
            App_HipRxStSop_reg             <=1'b0;
            App_HipRxStEop_reg             <=1'b0;
            App_HipRxStValid_reg           <=1'b0;
            App_HipRxStBarDec1_reg         <=8'h00;
            App_HipRxStBar_range_reg       <=3'h0;
            App_HipRxSt_pf_num_reg         <={PFCNT_WD-1{1'b0}};
            App_HipRxSt_vf_num_reg         <={VFCNT_WD-1{1'b0}};
            App_HipRxSt_vf_active_reg      <=1'b0;
        end
        else begin
            App_HipRxStData_reg            <=rx_app_data;
            App_HipRxStEmpty_reg           <=rx_app_empty;
            App_HipRxStSop_reg             <=rx_app_sop && rx_app_valid;
            App_HipRxStEop_reg             <=rx_app_eop && rx_app_valid;
            App_HipRxStValid_reg           <=rx_app_valid;
            App_HipRxStBarDec1_reg         <={1'b0,rx_app_bardecode};
            App_HipRxStBar_range_reg       <=rx_app_barrange;
            App_HipRxSt_pf_num_reg         <=rx_app_pf_num;
            App_HipRxSt_vf_num_reg         <=rx_app_vf_num;
            App_HipRxSt_vf_active_reg      <=rx_app_vf_active;
        end
    end

endmodule





