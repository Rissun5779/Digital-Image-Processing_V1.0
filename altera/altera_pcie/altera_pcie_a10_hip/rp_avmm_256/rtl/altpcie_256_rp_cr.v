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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpcie_256_rp_cr
  (
   // All ports on this module are synchronous to CraClk_i
   input             CraClk_i,           // Clock for register access port
   input             CraRstn_i,          // Reset signal
   // Broadcast Avalon signals
   input [13:2]      IcrAddress_i,       // Address
   input [31:0]      IcrWriteData_i,     // Write Data
   input [3:0]       IcrByteEnable_i,    // Byte Enables
   // Modified Avalon signals to/from specific internal modules
   // Local to Pci Mailbox
   input             RpWriteReqVld_i,    // Valid Write Cycle in
   input             RpReadReqVld_i,     // Read Valid in
   output [31:0]     RpReadData_o,       // Read Data out
   output            RpReadDataVld_o,    // Read Valid out
   // Mailbox specific Interrupt Request pulses
   output   [7:0]    RpRuptReq_o,        // Interrupt Requests

   input             TxRpFifoRdReq_i,
   output    [259:0] TxRpFifoData_o,
   output            RpTLPReady_o,
   input             RxRpFifoWrReq_i,
   input     [259:0] RxRpFifoWrData_i

   ) ;

// The RP TX Flow
// Write data from HOST to specific slice location to create 256 Bit wide streaming packet
// Set txs_empty to 2'b01 if number of writes from HOSt are greater than 3 else set it to 2'b10
// Set SOP and EOP always 1
// Detect EOP write from HOST and Write 256 bit into fifo

    wire               reg0_wrena;
    wire               reg1_wrena;
    reg  [2:0]         tx_reg_wr_cnt_reg;
    reg  [5:0]         tx_reg_slice_sel;
    wire [2:0]         tx_reg_wr_cnt;
    reg  [195:0]       tx_temp_data_reg = {196{1'b0}};
    wire [1:0]         txs_empty;
    reg                tx_fifo_wren;
    wire               txrp_fifo_empty;
    reg                rptlpready_reg;
    wire  [195:0]      txrp_fifo_dout;
    wire               tx_ctl_wrena;
    wire               tx_eop_detect;



    assign reg0_wrena   = ((IcrAddress_i[13:2] == 12'h800) & RpWriteReqVld_i);
    assign reg1_wrena   = ((IcrAddress_i[13:2] == 12'h801) & RpWriteReqVld_i);
    assign tx_ctl_wrena = ((IcrAddress_i[13:2] == 12'h802) & RpWriteReqVld_i);

   //196 Bit (2-Empty,1-EOP,1-SOP,192-Data)Register to Hold TX Data temporarily before writing into TXFIFO
   //D-Mux to select specific slice of register
   //D-Mux select lines are controlled by counter
   //Counter Increments with write to reg0 and reg1
   //Resets to Zero with detection of EOP write to tx_control register

    assign tx_eop_detect = tx_ctl_wrena & IcrWriteData_i[1];
    assign tx_reg_wr_cnt = (tx_reg_wr_cnt_reg + (reg0_wrena | reg1_wrena)) & {3{~tx_eop_detect}};

   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
        tx_reg_wr_cnt_reg    <= 3'b000;
       else
         tx_reg_wr_cnt_reg <= tx_reg_wr_cnt;
     end

   //Clock Enable for temporary TX register
   always @ *
     begin
       case (tx_reg_wr_cnt_reg)
         3'b001  : tx_reg_slice_sel <= 6'b000010;
         3'b010  : tx_reg_slice_sel <= 6'b000100;
         3'b011  : tx_reg_slice_sel <= 6'b001000;
         3'b100  : tx_reg_slice_sel <= 6'b010000;
         3'b101  : tx_reg_slice_sel <= 6'b100000;
         default : tx_reg_slice_sel <= 6'b000001;
       endcase
     end

   //Temporary TX register
    always @(posedge CraClk_i)
     begin
       if (tx_reg_slice_sel[0] & reg0_wrena)
         tx_temp_data_reg[31:0]    <= IcrWriteData_i;
       if (tx_reg_slice_sel[1] & reg1_wrena)
         tx_temp_data_reg[63:32]   <= IcrWriteData_i;
       if (tx_reg_slice_sel[2] & reg0_wrena)
         tx_temp_data_reg[95:64]   <= IcrWriteData_i;
       if (tx_reg_slice_sel[3] & reg1_wrena)
         tx_temp_data_reg[127:96]  <= IcrWriteData_i;
       if (tx_reg_slice_sel[4] & reg0_wrena)
         tx_temp_data_reg[159:128] <= IcrWriteData_i;
       if (tx_reg_slice_sel[5] & reg1_wrena)
         tx_temp_data_reg[191:160] <= IcrWriteData_i;
     end

   //Tx empty creation for 256 bit Streaming Interface
   //For 256 bit Interface SOP and EOP will be always 1

   assign txs_empty = (tx_reg_wr_cnt_reg > 3'b100) ? 2'b01 : 2'b10;

   always @(posedge CraClk_i)
     begin
       tx_temp_data_reg[195:194] <= txs_empty;
       tx_temp_data_reg[193:192] <= 2'b11;
     end

    //TX Fifo Write Enable
   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i ) begin
         tx_fifo_wren    <= 1'b0;
         rptlpready_reg  <= 1'b0;
       end
       else begin
         tx_fifo_wren    <=  tx_eop_detect;
         rptlpready_reg  <=  ~txrp_fifo_empty;
       end
     end

    assign RpTLPReady_o               = rptlpready_reg;
    assign TxRpFifoData_o[191:0]      = txrp_fifo_dout[191:0];
    assign TxRpFifoData_o[255:192]    = {64{1'b0}};
    assign TxRpFifoData_o[259:256]    = txrp_fifo_dout[195:192];
// Tx FIFO
        scfifo  # (
               .add_ram_output_register("ON"),
                     .intended_device_family("Stratix V"),
                     .lpm_numwords(16),
                     .lpm_showahead("OFF"),
                     .lpm_type("scfifo"),
                     .lpm_width(196),
                     .lpm_widthu(4),
                     .overflow_checking("ON"),
                     .underflow_checking("ON"),
                     .use_eab("ON")
                  )

       txrp_fifo (
                     .rdreq (TxRpFifoRdReq_i),
                     .clock (CraClk_i),
                     .wrreq (tx_fifo_wren),
                     .data  (tx_temp_data_reg),
                     .usedw (),
                     .empty (txrp_fifo_empty),
                     .q     (txrp_fifo_dout),
                     .full  (),
                     .aclr  (~CraRstn_i),
                     .almost_empty (),
                     .almost_full (),
                     .sclr ()
);

// The RP Completion Flow
// Check if data is present in RX FIFO, If yes move out of IDLE state
// Read RX Fifo and set TLP available indicator
// Calculate number of read operation HOST need to perform to set EOP indicator
// Calculate number of read operation HOST need to perform to set TLP read completion indicator
// Reset TLP available indicator once read by HOST
// Return appropriate DWORD to HOST using data mux
// Return either status register or data from DWORD mux to HOST
// Reset EOP indicator once read by HOST
// Move to IDLE state back if all the DWORDs are read by HOST


    wire [195:0]   rxrp_fifo_din;
    wire [195:0]   rxrp_fifo_dataout;
    wire           rxrp_fifo_empty;
    wire [3:0]     rxrp_fifo_usedw;
    reg  [3:0]     rxrp_fifo_usedw_reg;

    reg            idle_reg;
    wire           rxrp_fifo_rdreq;
    reg            rxrp_fifo_rdreq_reg;
    wire           rxtlp_available;
    reg            rxtlp_available_reg;

    wire           reg0_rdena;
    wire           reg1_rdena;
    wire           rx_status_rdena;
    reg            rx_status_rdena_reg;
    reg            rp_dvalid_reg;

    wire [1:0]     rx_s_empty;
    reg            rxtlp_eop_gen_en;
    wire [2:0]     eop_cycles;
    wire           rxtlp_eop;
    reg            rxtlp_eop_reg;
    wire           rxtlp_eop_read;

    reg  [2:0]     num_payload_rd_reg;
    wire [2:0]     num_payload_rd;
    reg  [31:0]    rxrp_reg_dout;

    wire [2:0]     num_payload_cycles;
    wire           end_of_tlp_read;
    reg            end_of_tlp_read_reg;


    assign rxrp_fifo_din[195:192] = RxRpFifoWrData_i[259:256];
    assign rxrp_fifo_din[191:0]   = RxRpFifoWrData_i[191:0]  ;

        scfifo  # (
               .add_ram_output_register("ON"),
                     .intended_device_family("Stratix V"),
                     .lpm_numwords(16),
                     .lpm_showahead("OFF"),
                     .lpm_type("scfifo"),
                     .lpm_width(196),
                     .lpm_widthu(4),
                     .overflow_checking("ON"),
                     .underflow_checking("ON"),
                     .use_eab("ON")
                  )

       rxrp_fifo (
                     .rdreq (rxrp_fifo_rdreq_reg),
                     .clock (CraClk_i),
                     .wrreq (RxRpFifoWrReq_i),
                     .data (rxrp_fifo_din),
                     .usedw (rxrp_fifo_usedw),
                     .empty (rxrp_fifo_empty),
                     .q (rxrp_fifo_dataout),
                     .full (),
                     .aclr (~CraRstn_i),
                     .almost_empty (),
                     .almost_full (),
                     .sclr ()
);
   //Set idle_reg flop with reset
   //And with detection of end of tlp read
   //De-assert this flop when there is TLP available for read in RX Fifo
   assign rxrp_fifo_rdreq = ~rxrp_fifo_empty & idle_reg;

   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         idle_reg    <= 1'b1;
       else
         idle_reg    <= end_of_tlp_read_reg | (idle_reg & !rxrp_fifo_rdreq);
     end

   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         rxrp_fifo_rdreq_reg    <= 1'b0;
       else
         rxrp_fifo_rdreq_reg    <= rxrp_fifo_rdreq;
     end

   //RX TLP  available for read
   //Assert with read tlp from RX FIFO
   //De-assert with read of control register
   assign rxtlp_available = rxrp_fifo_rdreq_reg | (rxtlp_available_reg & !rp_dvalid_reg );
   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         rxtlp_available_reg    <= 1'b0;
       else
         rxtlp_available_reg    <= rxtlp_available;
     end
   // RX completion fifo word status
   always @(posedge CraClk_i)
     begin
       rxrp_fifo_usedw_reg    <= rxrp_fifo_usedw;
     end
   //as data is always available,generate valid immediately
   assign RpReadDataVld_o  =  rp_dvalid_reg;
   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         rp_dvalid_reg    <= 1'b0;
       else
         rp_dvalid_reg    <= RpReadReqVld_i;
     end
   //This is to get around HIP rx_sempty issue...rx_sempty is not behaving as per spec
   //empty is "00" even when upper 64 bit section is empty in received TLP. Ideally it should be "01"   
   assign rx_s_empty = (rxrp_fifo_dataout[195:194] == 2'b10) ? 2'b10 : 2'b01;
   //RX TLP EOP Generation
   //Generate EOP Enable signal which will assert with TLP available state and and de-asserts after
   //EOP status is read by HOST

   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         rxtlp_eop_gen_en    <= 1'b0;
       else
         rxtlp_eop_gen_en    <= rxrp_fifo_rdreq_reg | ( rxtlp_eop_gen_en & !rxtlp_eop_read) ;
     end

   //calculate number of words need to be read before EOP can be set
   assign eop_cycles         = (rx_s_empty == 2'b10) ? 3'b010 : 3'b100 ;
   //Generate EOP signal when HOST has read the Dword just before EOP Dword
   assign rxtlp_eop          = (eop_cycles == num_payload_rd_reg) & rxtlp_eop_gen_en;

   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         rxtlp_eop_reg    <= 1'b0;
       else
         rxtlp_eop_reg    <= rxtlp_eop;
     end
   // RX status register read indicator
   assign rx_status_rdena   = ((IcrAddress_i[13:2] == 12'h804) & RpReadReqVld_i);
   // RX EOP status read indicator
   assign rxtlp_eop_read = rxtlp_eop_reg & rx_status_rdena;

   //This registered version selects input to RpReadData_o from payload data and control register
   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         rx_status_rdena_reg    <= 1'b0;
       else
         rx_status_rdena_reg    <= rx_status_rdena;
     end

   assign RpReadData_o    = rx_status_rdena_reg ? {{20{1'b0}},rxrp_fifo_usedw_reg,{6{1'b0}},rxtlp_eop_reg,rxtlp_available_reg} : rxrp_reg_dout;

   // RX register-0 and register-1 read indicator
   assign reg0_rdena = ((IcrAddress_i[13:2] == 12'h805) & RpReadReqVld_i);
   assign reg1_rdena = ((IcrAddress_i[13:2] == 12'h806) & RpReadReqVld_i);
   //calculates number of words need to be read for setting TLP read completion from HOST
   //assign num_payload_cycles = (rxrp_fifo_dataout[195:194] == 2'b01) ? 3'b101 : 3'b011;
   assign num_payload_cycles = {~rx_s_empty,1'b1} ;
   assign end_of_tlp_read = ( num_payload_cycles == num_payload_rd_reg ) & (reg0_rdena | reg1_rdena);

   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
        end_of_tlp_read_reg    <= 1'b0;
       else
         end_of_tlp_read_reg  <= end_of_tlp_read;
     end
   //Counter Logic to create select input to RX data selector mux
   //Increments with read to reg0 and reg1
   //Resets to Zero with detection of EOP read
   assign num_payload_rd  = (num_payload_rd_reg + (reg0_rdena | reg1_rdena)) & {3{~idle_reg}};
   always @(posedge CraClk_i)
     begin
       if (!CraRstn_i )
         num_payload_rd_reg <= 3'b000;
       else
         num_payload_rd_reg <= num_payload_rd;
     end

    always @ *
      begin
        case (num_payload_rd_reg)
          3'b001  : rxrp_reg_dout <= rxrp_fifo_dataout[31:0];
          3'b010  : rxrp_reg_dout <= rxrp_fifo_dataout[63:32];
          3'b011  : rxrp_reg_dout <= rxrp_fifo_dataout[95:64];
          3'b100  : rxrp_reg_dout <= rxrp_fifo_dataout[127:96];
          3'b101  : rxrp_reg_dout <= rxrp_fifo_dataout[159:128];
          3'b110  : rxrp_reg_dout <= rxrp_fifo_dataout[191:160];
          default : rxrp_reg_dout <= {32{1'b0}};
        endcase
      end


    assign RpRuptReq_o = {8{1'b0}};  // tied to GND for now
endmodule

