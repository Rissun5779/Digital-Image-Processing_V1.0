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


`timescale 100 fs / 100 fs
`define tdisplay(MYSTRING) $display("%t:%s \n", $time,  MYSTRING)


module sdi_ii_tb_rx_checker
#(
   // module parameter port list
   parameter
      FAMILY                  = "Stratix V"           ,
      CH_NUMBER               = 0                     ,
      VIDEO_STANDARD          = "Triple_Standard"     ,
      DIRECTION               = "du"                  ,
      RX_CRC_ERROR_OUTPUT     = 0                     ,
      RX_INC_ERR_TOLERANCE    = 0                     ,
      RX_EN_A2B_CONV          = 0                     ,
      RX_EN_B2A_CONV          = 0                     ,
      TX_EN_VPID_INSERT       = 0                     ,
      RX_EN_VPID_EXTRACT      = 0                     ,
      XCVR_TX_PLL_SEL         = 0                     ,
      ED_TXPLL_SWITCH         = 0                     ,
      TEST_LN_CHECK           = 0                     ,
      TEST_LN_OUTPUT          = 1                     ,
      TEST_SYNC_OUTPUT        = 0                     ,
      TEST_DISTURB_SERIAL     = 0                     ,
      TEST_DATA_COMPARE       = 0                     ,
      TEST_DL_SYNC            = 0                     ,
      TEST_TRS_LOCKED         = 0                     ,
      TEST_FRAME_LOCKED       = 0                     ,
      TEST_GEN_ANC            = 0                     ,
      TEST_GEN_VPID           = 0                     ,
      TEST_VPID_PKT_COUNT     = 1                     ,
      TEST_VPID_OVERWRITE     = 1                     ,
      TEST_ERR_VPID           = 0                     ,
      TEST_RESET_RECON        = 0                     ,
      TEST_RST_PRE_OW         = 0                     ,
      TEST_RXSAMPLE_CHK       = 0                     ,
      SD_BIT_WIDTH            = 10
)
(
   // port list
   rx_clk,
   rx_refclk,
   tx_clk,
   ref_rst,
   rx_ln,
   rx_ln_b,
   tx_std,
   rx_std,
   align_locked,
   trs_locked,
   align_locked_b,
   trs_locked_b,
   dl_locked,
   frame_locked,
   frame_locked_b,
   chk_rx,
   rx_crc_error_c,
   rx_crc_error_y,
   rx_crc_error_c_b,
   rx_crc_error_y_b,
   rx_f,
   rx_v,
   rx_h,
   rx_ap,
   rx_trs,
   rx_eav,
   rxdata,
   rxdata_valid,
   rxdata_b,
   rxdata_valid_b,
   rx_sdi_start_reconfig,
   txdata,
   txdata_valid,
   txdata_b,
   txdata_valid_b,
   dl_mapping,
   rx_format,
   tx_format,
   rx_vpid_byte1,
   rx_vpid_byte2,
   rx_vpid_byte3,
   rx_vpid_byte4,
   rx_vpid_valid,
   rx_vpid_checksum_error,
   rx_vpid_byte1_b,
   rx_vpid_byte2_b,
   rx_vpid_byte3_b,
   rx_vpid_byte4_b,
   rx_vpid_valid_b,
   rx_vpid_checksum_error_b,
   rx_line_f0,
   rx_line_f1,
   tx_sdi_reconfig_done,
   tx_sdi_start_reconfig,
   //tx_clkout_match,
   
   rxcheck_done,
   rx_check_posedge,
   chk_completed
);

//--------------------------------------------------------------------------
// local parameter declarations
//--------------------------------------------------------------------------
   localparam TIMEOUT = 150000;
   localparam NUM_FRAME_TO_CHECK = 1;
   localparam MODE_SD = (VIDEO_STANDARD == "sd");
   localparam MODE_HD = (VIDEO_STANDARD == "hd");
   localparam MODE_DL = (VIDEO_STANDARD == "dl");
   localparam MODE_3G = (VIDEO_STANDARD == "threeg");
   localparam MODE_DS = (VIDEO_STANDARD == "ds");   
   localparam MODE_TR = (VIDEO_STANDARD == "tr");
   localparam MODE_MR = (VIDEO_STANDARD == "mr");
   localparam LN_CHECK = (TEST_LN_OUTPUT == 1'b1);
   localparam CRC_CHECK = (RX_CRC_ERROR_OUTPUT == 1'b1);
   localparam SYNC_CHECK = (TEST_SYNC_OUTPUT == 1'b1);
   localparam DISTURB_SERIAL = (TEST_DISTURB_SERIAL == 1'b1);
   localparam DL_SYNC = (MODE_DL && TEST_DL_SYNC == 1'b1);
   localparam TRS_TEST = (TEST_TRS_LOCKED == 1'b1);
   localparam FRAME_TEST = (TEST_FRAME_LOCKED == 1'b1);
   localparam ERR_TOLERANCE = (RX_INC_ERR_TOLERANCE == 1'b1) ? 15 : 4;
   localparam DATA_CMP = (TEST_DATA_COMPARE == 1'b1);
   localparam VPID_CHECK = (RX_EN_VPID_EXTRACT == 1'b1);
   localparam VPID_VALID_EXPECTED = (TEST_VPID_OVERWRITE == 1'b1 && TEST_ERR_VPID == 1'b0);
   localparam EN_VPID_B = (VIDEO_STANDARD == "dl") | (VIDEO_STANDARD == "threeg") | (VIDEO_STANDARD == "tr");
   localparam RST_RECON_TEST = (TEST_RESET_RECON == 1'b1);
   localparam RST_RECON_PRE_OW = (TEST_RST_PRE_OW == 1'b1);   // 1: reset before overwrtting M-Counter, 0: reset after overwrtting M-Counter 
   localparam RXSAMPLE_TEST = (TEST_RXSAMPLE_CHK == 1'b1);
   localparam RX_EN_SD_20 = (SD_BIT_WIDTH == 20);
   localparam TXPLL_TEST = (XCVR_TX_PLL_SEL != 0 | ED_TXPLL_SWITCH != 0 );
   localparam NUM_STREAMS = MODE_MR ? 4 : 1;
   localparam MAX_INDEX   = MODE_MR ? 21 : 7;
//--------------------------------------------------------------------------
// port declaration
//--------------------------------------------------------------------------
   input                        rx_clk;
   input                        rx_refclk;
   input                        tx_clk;
   input                        ref_rst;
   input [11*NUM_STREAMS-1:0]   rx_ln;
   input [11*NUM_STREAMS-1:0]   rx_ln_b;
   input [2:0]                  tx_std;
   input [2:0]                  rx_std;
   input [1:0]                  chk_rx;
   input                        align_locked;
   input [NUM_STREAMS-1:0]      trs_locked;
   input                        align_locked_b;
   input                        trs_locked_b;
   input                        dl_locked;
   input                        frame_locked;
   input                        frame_locked_b;
   input [NUM_STREAMS-1:0]      rx_crc_error_c;
   input [NUM_STREAMS-1:0]      rx_crc_error_y;
   input [NUM_STREAMS-1:0]      rx_crc_error_c_b;
   input [NUM_STREAMS-1:0]      rx_crc_error_y_b;
   input [NUM_STREAMS-1:0]      rx_f;
   input [NUM_STREAMS-1:0]      rx_v;
   input [NUM_STREAMS-1:0]      rx_h;
   input [NUM_STREAMS-1:0]      rx_ap;
   input [NUM_STREAMS-1:0]      rx_trs;
   input [NUM_STREAMS-1:0]      rx_eav;
   input [4*NUM_STREAMS-1:0]    rx_format;
   input [3:0]                  tx_format;
   input [20*NUM_STREAMS-1:0]   rxdata;
   input                        rxdata_valid;
   input [19:0]                 rxdata_b;
   input                        rxdata_valid_b;
   input                        rx_sdi_start_reconfig;
   input [20*NUM_STREAMS-1:0]   txdata;
   input                        txdata_valid;
   input [19:0]                 txdata_b;
   input                        txdata_valid_b;
   input                        dl_mapping;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte1;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte2;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte3;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte4;
   input [NUM_STREAMS-1:0]      rx_vpid_valid;
   input [NUM_STREAMS-1:0]      rx_vpid_checksum_error;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte1_b;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte2_b;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte3_b;
   input [8*NUM_STREAMS-1:0]    rx_vpid_byte4_b;
   input [NUM_STREAMS-1:0]      rx_vpid_valid_b;
   input [NUM_STREAMS-1:0]      rx_vpid_checksum_error_b;
   input [11*NUM_STREAMS-1:0]   rx_line_f0;
   input [11*NUM_STREAMS-1:0]   rx_line_f1;
   input                        tx_sdi_reconfig_done;
   input                        tx_sdi_start_reconfig;

   output [1:0]                 rxcheck_done;
   output                       rx_check_posedge;
   output                       chk_completed;

//--------------------------------------------------------------------------
// signal declaration
//-------------------------------------------------------------------------
   wire   start_check = chk_rx[0];
   wire   checker_rst = ~chk_rx[0];
   wire   print_checker_final_status = chk_rx[1];

//--------------------------------------------------------------------------
// Update result registers and index
//--------------------------------------------------------------------------
   reg [MAX_INDEX-1:0]   result_rx;
   reg [4:0]   index;
   reg         update_result_rx;
   reg         error_detected;

   always @ (posedge update_result_rx or posedge ref_rst)
   begin
      if (ref_rst) begin
         result_rx = {MAX_INDEX{1'b1}};
         index = 5'd0;
      end else if (update_result_rx) begin
         if (~error_detected) begin
            result_rx[index] = 1'b0;
         end
         index = index + 1'b1;
      end
   end

//--------------------------------------------------------------------------
// Define locked condition
//--------------------------------------------------------------------------   
   wire [NUM_STREAMS-1:0] rx_locked;
   genvar i;
   
   generate for (i=0; i<NUM_STREAMS; i=i+1)
   begin : rx_locked_gen
     if (MODE_DL)      assign rx_locked[i] = (trs_locked[i] & trs_locked_b) & dl_locked;
     else              assign rx_locked[i] = trs_locked[i] & align_locked;
   end
   endgenerate 
//--------------------------------------------------------------------------
// Start timer
//--------------------------------------------------------------------------
   integer     timer;
   
   always @ (posedge rx_refclk or posedge ref_rst)
   begin
      if (ref_rst) begin
         timer <= 0;
      end else begin
         if (|rx_locked) begin
            timer <= 0;
         end else begin
            timer <= timer + 1;
         end
      end
   end

//--------------------------------------------------------------------------
// video standard
//--------------------------------------------------------------------------
   reg [2:0]   vid_std;
   reg         rx_std_error;
   always @ (posedge rx_clk or posedge ref_rst)
   begin
      if (ref_rst) begin
         vid_std <= 3'b111;
         rx_std_error <= 1'b1;
      end else begin
         if (|rx_locked) begin
            vid_std <= rx_std;
         
            if (rx_std == tx_std) begin
                rx_std_error <= 1'b0;
            end
         end else begin
            vid_std <= 3'b111;
         end
      end
   end

//--------------------------------------------------------------------------
// create blip to mark rx is locked.
//--------------------------------------------------------------------------
   reg         reset_reconfig_count;
   reg         locked_blip;
   reg [3:0]   locked_dly;
   reg         crc_error;
   reg         chk_crc;
   reg         enable_frame_test;

   always @ (posedge rx_clk or posedge ref_rst)
   begin
      if (ref_rst) begin
         locked_dly <= 3'b0;
         locked_blip <= 1'b0;
      end else begin
         locked_dly <= {locked_dly[2:0], |rx_locked};
         locked_blip <= locked_dly[2] & ~locked_dly[3];

         if (chk_crc && |rx_locked) begin
            if ( (|rx_crc_error_c) || (|rx_crc_error_y) || (|rx_crc_error_c_b) || (|rx_crc_error_y_b)) begin
               crc_error <= 1'b1;
            end
         end
      end
   end

//--------------------------------------------------------------------------
// Print status when locked_blip is acquired.
//--------------------------------------------------------------------------
   reg [3:0]     reconfig_count;
   reg [1:0]     expected_rcfgcount;
   reg [4*8:0]   test_string;
   reg           rcfg_cnt_err;
   reg [1:0]     rxcheck_done;
   integer       ch_num = CH_NUMBER;

   always @ (posedge rx_clk or posedge ref_rst)
   begin
      if (ref_rst) begin
         rcfg_cnt_err <= 1'b1;
      end else if (locked_blip) begin
         if ((MODE_MR || MODE_TR || MODE_DS) && !TXPLL_TEST) begin
            if (reconfig_count == expected_rcfgcount) begin
               rcfg_cnt_err = 1'b0;
            end else begin
              rcfg_cnt_err = 1'b1;
            end
            $display("\n ##### Test %d Channel %d: Locked to %s.  Expected count = %d, actual count = %d", index, ch_num[2:0], test_string, expected_rcfgcount, reconfig_count);
            reset_reconfig_count <= 1'b1;
         end else begin
            $display("\n ##### Test %d: Locked to %s. ", index, test_string);
         end

         if (checker_rst) begin
            rxcheck_done <= 2'b10;
         end
      end else begin
         reset_reconfig_count <= 1'b0;
         rxcheck_done <= 2'b00;
      end
   end

//-------------------------------------------------------------------------------
// Define test_string and compute the reconfig_count and expected reconfig count
//-------------------------------------------------------------------------------
   reg [2:0]   prev_std;

   always @ (vid_std or posedge reset_reconfig_count or posedge ref_rst)
   begin
      case (vid_std)
         3'b000 : test_string <= "SD";
         3'b001 : test_string <= "HD";
         3'b010 : test_string <= "3GB";
         3'b011 : test_string <= "3GA";
         3'b100 : test_string <= "6GB";
         3'b101 : test_string <= "6GA";
         3'b110 : test_string <= "12GB";
         3'b111 : test_string <= "12GA";
      endcase

      if ((MODE_TR || MODE_DS) && !TXPLL_TEST) begin
        if (ref_rst) begin
            expected_rcfgcount <= 2'd1;
        end else if (reset_reconfig_count) begin
            expected_rcfgcount <= 2'd0;
        end else begin
            if ( (FRAME_TEST && enable_frame_test && prev_std == 3'd7) || (prev_std == 3'b001 && vid_std != 3'b001) || (prev_std != 3'b001 && vid_std == 3'b001)) begin
                expected_rcfgcount = expected_rcfgcount + 1'b1;
            end
         
            if (RST_RECON_TEST && (index > 5'd0)) begin
                if (prev_std == 3'b001 && vid_std != 3'b001) begin
                    expected_rcfgcount = expected_rcfgcount + 1'b1;
                end else if (prev_std != 3'b001 && vid_std == 3'b001) begin
                    expected_rcfgcount = expected_rcfgcount + 2'd2;
                end
            end
        end
      end else if (MODE_MR & !TXPLL_TEST) begin
        if (ref_rst) begin
            expected_rcfgcount <= 2'd1;
        end else if (reset_reconfig_count) begin
            expected_rcfgcount <= 2'd0;
        end else begin
            if ((prev_std[2:1] == 2'b11 && vid_std[2:1] != 2'b11) || (prev_std[2:1] != 2'b11 && vid_std[2:1] == 2'b11)) begin
                expected_rcfgcount = expected_rcfgcount + 1'b1;
            end else if ((prev_std[2:1] != 2'b11 && vid_std[2:1] != 2'b11) || (prev_std[2:1] != 2'b11 && vid_std[2:1] != 2'b11)) begin
                expected_rcfgcount = expected_rcfgcount + 2'd2;
            end
        end
      end

      prev_std <= vid_std;
   end

   always @ (posedge rx_sdi_start_reconfig or posedge ref_rst or posedge reset_reconfig_count)
   begin
        if (reset_reconfig_count || ref_rst) begin
            reconfig_count <= 4'b0;
        end else begin
            if ((MODE_MR || MODE_TR || MODE_DS) && !TXPLL_TEST) begin
                if (rx_sdi_start_reconfig) begin
                    reconfig_count <= reconfig_count + 1'b1;
                end
            end
        end
   end

//---------------------------------------------------------------------------
// Check LN output
//---------------------------------------------------------------------------
   reg       chk_ln;
   reg       bad_ln;
   integer   expected_ln;
   integer   prev_ln;
   integer   ln_max;

   always @ (rx_ln or checker_rst)
   begin
      if (checker_rst) begin
         bad_ln = 1'b0;
         expected_ln = 0;
         ln_max = 0;
         prev_ln = 0;
      end
      else if (chk_ln && (rx_ln > 0)) begin

         if (rx_ln == 1 && ln_max == 0) begin
            ln_max = prev_ln;
         end else begin
            if ( vid_std == 3'b010 || MODE_DL ) begin
               if (expected_ln != 0 && (rx_ln != expected_ln || rx_ln_b != expected_ln) ) begin
                  bad_ln = 1'b1;
                  $display("Expected ln = %d, rx_ln = %d, rx_ln_b = %d", expected_ln, rx_ln, rx_ln_b);
               end
            end else begin
               if (rx_ln != expected_ln && expected_ln != 0) begin
                  bad_ln = 1'b1;
                  $display("Expected ln = %d, rx_ln = %d", expected_ln, rx_ln);
               end
            end
         end

         if (rx_ln == ln_max) begin
            expected_ln = 1;
         end else begin
            expected_ln = rx_ln + 1;
         end

         prev_ln = rx_ln;
      end
   end

//---------------------------------------------------------------------------
// Determine whether current format is interlaced or progressive
//---------------------------------------------------------------------------
    wire f_sync;
    wire v_sync;
    wire h_sync;
    wire ap_sync;
    generate if (MODE_MR)
    begin : timing_sync_gen
        assign  f_sync =  (vid_std[2:1] == 2'b11) ? &rx_f[3:0] :
                        (vid_std[2:1] == 2'b10) ? &rx_f[1:0] : rx_f[0];
        assign  v_sync =  (vid_std[2:1] == 2'b11) ? &rx_v[3:0] :
                        (vid_std[2:1] == 2'b10) ? &rx_v[1:0] : rx_v[0];
        assign  h_sync =  (vid_std[2:1] == 2'b11) ? &rx_h[3:0] :
                        (vid_std[2:1] == 2'b10) ? &rx_h[1:0] : rx_h[0];
        assign  ap_sync = (vid_std[2:1] == 2'b11) ? &rx_ap[3:0] :
                        (vid_std[2:1] == 2'b10) ? &rx_ap[1:0] : rx_ap[0];
    end else begin
        assign  f_sync = rx_f;
        assign  v_sync = rx_v;
        assign  h_sync = rx_h;
        assign  ap_sync = rx_ap;
    end
    endgenerate
   reg   f_dly;
   reg   v_dly;
   reg   h_dly;
   reg   ap_dly;

   always @ (posedge rx_clk or posedge ref_rst)
   begin
      if (ref_rst) begin
         f_dly <= 1'b0;
         v_dly <= 1'b0;
         h_dly <= 1'b0;
         ap_dly <= 1'b0;
      end
      else if (rxdata_valid) begin
         f_dly <= f_sync;
         v_dly <= v_sync;
         h_dly <= h_sync;
         ap_dly <= ap_sync;
      end
   end 

   wire diff_f = f_sync ^ f_dly;
   wire rising_v = v_sync & ~v_dly;
   wire rising_h = h_sync & ~h_dly;
   wire rising_ap = ap_sync & ~ap_dly;

//---------------------------------------------------------------------------
// Determine current format is progressive or interlaced
//---------------------------------------------------------------------------
   reg       is_interlaced;
   always @ (posedge diff_f or posedge checker_rst)
   begin
      if (checker_rst) begin
         is_interlaced = 1'b0;
      end
      else begin
         is_interlaced = 1'b1;
      end
   end

//---------------------------------------------------------------------------
// Obtain reference values for line number count and H, AP count
//---------------------------------------------------------------------------
   integer   v_count;
   integer   h_count,h_max;
   integer   ap_count,ap_max;
   reg       start_sync_count;
   reg       chk_sync;
   reg       ref_value_obtained;

   always @ (posedge rising_v or posedge checker_rst)
   begin
      if (checker_rst) begin
         start_sync_count = 1'b0;
         v_count = 0;
         h_max = 0;
         ap_max = 0;
         ref_value_obtained = 1'b0;
      end
      // Wait until chk_sync signal is triggered and start counting
      else if (chk_sync) begin
         start_sync_count = 1'b1;
         v_count = v_count + 1;

         // Interlaced format has 2 rising_v in a frame
         if (is_interlaced) begin
            if (v_count == 3) begin
               h_max = h_count;
               ap_max = ap_count;
               ref_value_obtained = 1'b1;
            end
         end
         else begin
            if (v_count == 2) begin
               h_max = h_count;
               ap_max = ap_count;
               ref_value_obtained = 1'b1;
            end
         end
      end
   end

//---------------------------------------------------------------------------
// Enable compare signal after reference value is obtained
//---------------------------------------------------------------------------
   reg   cmp_sync_output;

   always @ (posedge rising_v or posedge checker_rst)
   begin
      if (checker_rst) begin
         cmp_sync_output = 1'b0;
      end
      else if (ref_value_obtained) begin
         if (is_interlaced) begin
            if (v_count == 5) begin
               cmp_sync_output = 1'b1;
            end
         end
         else if (v_count == 3) begin
            cmp_sync_output = 1'b1;
         end
      end
   end

//---------------------------------------------------------------------------
// Check active lines and H sync output
//---------------------------------------------------------------------------
   reg   sync_error;

   always @ (posedge rx_clk or posedge checker_rst)
   begin
      if (checker_rst) begin
         h_count = 0;
         ap_count = 0;
         sync_error <= 1'b0;
      end
      else if (start_sync_count && rxdata_valid) begin

         // Compare h_count and ap_count obtained from second frame with h_max and ap_max obtained from first frame 
         if (cmp_sync_output) begin
            if ((h_max != h_count) || (ap_max != ap_count)) begin
               sync_error <= 1'b1;
            end
         end
         // Reset h_count and ap_count after one frame
         else if (rising_v) begin
            if (is_interlaced) begin
               if (v_count % 2 == 1) begin
                  h_count = dl_mapping ? 2 : 1;
                  ap_count = 0;
               end
               else begin
                  h_count <= dl_mapping ? h_count + 2 : h_count + 1;
               end
            end
            else begin
               h_count = dl_mapping ? 2 : 1;
               ap_count = 0;
            end
         end
         // Increment h_count and ap_count at respective rising edge
         else begin
            if (rising_h) h_count <= (dl_mapping) ? h_count + 2 : h_count + 1;
            if (rising_ap) ap_count <= (dl_mapping) ? ap_count + 2 : ap_count + 1;
         end
      end
   end


//-------------------
// SD 20 bits
//-------------------
  wire        rx_data_int_valid, rx_data_int_valid_1;
  reg  [9:0]  data_lsb;
  wire [19:0] rx_data_int;
  reg  [19:0] rx_data_temp;
  reg         lsb_msbn;
  reg         trs_dly1;
  
  generate if (RX_EN_SD_20)
    begin : sd_10bit_gen
       
      sdi_ii_tx_ce_gen u_sd10_ce_gen
      (
        .clk          (rx_clk),
        .rst          (ref_rst),
        .tx_std       (3'b000),
        .txdata_valid (rx_data_int_valid_1) 
      );
      defparam u_sd10_ce_gen.EN_SD_20BITS  = 1'b0;
      
      always @ (posedge rx_clk or posedge ref_rst)
      begin
        if (ref_rst) begin
          lsb_msbn <= 1'b0;
          data_lsb <= 10'd0;
          trs_dly1 <= 1'b0;
          rx_data_temp <= 20'd0;
        end else begin
          
          if (rxdata_valid) begin
            rx_data_temp <= rxdata;
          end
          
          if (rxdata_valid) begin
            lsb_msbn <= 1'b1;
          end else if (rx_data_int_valid) begin
            lsb_msbn <= ~lsb_msbn;
          end          
                    
          if (rx_data_int_valid) begin
            if (lsb_msbn) data_lsb <= rx_data_temp[9:0];
            else          data_lsb <= rx_data_temp[19:10];
            trs_dly1   <= rx_trs;
          end
        end
      end
      
      assign rx_data_int       = (vid_std==3'b000) ? {data_lsb, data_lsb} : rxdata;
      assign rx_data_int_valid = (vid_std==3'b000) ? rx_data_int_valid_1 :  rxdata_valid;
       
    end 
    else begin
      assign rx_data_int_valid = 1'b0;
      assign rx_data_int = 20'd0;
    end
  endgenerate


//--------------------------------------------------------------------------------------------------
// Store and compare data
//--------------------------------------------------------------------------------------------------
   wire   data_error_seen;
   wire   data_error_seen_b;
   wire   dcmp_enable;
   wire   dl_notsync;
   wire   dlsync_error;
   reg    dlsync_errflag;
   reg    dl_dlytest_done;
   reg    compare_data;
   reg    watchdog_timeout;
   wire   ones_detected = (rxdata == 20'hfffff || rxdata_b == 20'hfffff);

   assign  dcmp_enable = compare_data & ~rxcheck_done[1];

   generate
   if (DATA_CMP) begin: data_compare
      tb_data_compare #(
         .EN_SD_20BITS (RX_EN_SD_20)
      ) u_compare (
         .tx_clk         (tx_clk),
         .rx_clk         (rx_clk),
         .rst            (rxcheck_done[1]),
         .rx_locked      (rx_locked),
         .txdata         (txdata),
         .txdata_valid   (txdata_valid),
         .rxdata         (rxdata),
         .rxdata_valid   (rxdata_valid),
         .enable         (dcmp_enable),
         .video_std      (vid_std),
         .data_error     (data_error_seen)
      );
   end
   endgenerate

   generate
   if (DATA_CMP & MODE_DL) begin: dl_blk
      tb_data_compare u_compare_b
      (
         .tx_clk         (tx_clk),
         .rx_clk         (rx_clk),
         .rst            (rxcheck_done[1]),
         .rx_locked      (rx_locked),
         .txdata         (txdata_b),
         .txdata_valid   (txdata_valid_b),
         .rxdata         (rxdata_b),
         .rxdata_valid   (rxdata_valid_b),
         .enable         (dcmp_enable),
         .video_std      (vid_std),
         .data_error     (data_error_seen_b)
      );
   end
   endgenerate

//--------------------------------------------------------------------------------------------------
// Dual link sync test
//--------------------------------------------------------------------------------------------------
   generate
   if (DL_SYNC) begin: dual_link_sync
      reg    enable_check;
      reg    dlerror_expected;
      reg    lock_check_fail;
      reg    no_error_detected;

      tb_dual_link_sync u_dl_sync
      (
         .clk       (rx_clk),
         .enable    (enable_check),
         .reset     (~start_check),
         .data_a    (rxdata),
         .data_b    (rxdata_b),
         .rx_eav    (rx_eav),
         .rx_ln     (rx_ln),
         .rx_ln_b   (rx_ln_b),
         .notsync   (dl_notsync),
         .error     (dlsync_error)
      );

      always @ (posedge dlsync_error or posedge watchdog_timeout or posedge lock_check_fail or posedge no_error_detected) begin
         if (~dlerror_expected)   dlsync_errflag <= 1'b1;
         else if (dlerror_expected & no_error_detected) dlsync_errflag <= 1'b1;
      end
 
      always @ (posedge start_check)
      begin
         dl_dlytest_done <= 1'b0;
         dlerror_expected <= 1'b0;
         lock_check_fail <= 1'b0;
         no_error_detected <= 1'b0;
      //-----------------------------------------------------------------------
      // State 1 : Transmit delayed / non-delayed data in either link
      //-----------------------------------------------------------------------
         $display("State 1: Transmit delayed / non-delayed data in either link");
         repeat (2) begin
            @(negedge align_locked);
            wait (align_locked_b && align_locked);
            @ (posedge ones_detected);
            enable_check <= 1'b1;
            wait (dl_notsync | dlsync_error);
            wait (~dl_notsync | dlsync_error);
            @(posedge rx_clk);
            enable_check <= 1'b0;
            watchdog(20); 
            rxcheck_done <= 2'b10;
         end
         // Random delay at this state
         @(negedge align_locked);
         wait (align_locked_b && align_locked);
         @ (posedge ones_detected);
         enable_check <= 1'b1;
         // Since it is random delay, it might not have dl_notsync if the delay between 2 links are too close.
         // Changed to wait for two rx_eav and see if the links are in sync after that.
         repeat (2) @(negedge rx_eav);
         wait (~dl_notsync | dlsync_error);
         @(posedge rx_clk);
         enable_check <= 1'b0;
         watchdog(20); 
         rxcheck_done <= 2'b10;
      //-----------------------------------------------------------------------------------------------
      // State 2 : Unplug either link when dl_locked is high (fast) and recover with delayed data
      //-----------------------------------------------------------------------------------------------
         repeat (2) @ (posedge ones_detected);
         rxcheck_done <= 2'b10;
         //Receiving recovered data
         enable_check <= 1'b1;
         wait (dl_notsync | dlsync_error);
         wait (~dl_notsync | dlsync_error);
         @(posedge rx_clk);
         enable_check <= 1'b0;
         if (~rx_locked) lock_check_fail <= 1'b1;
         rxcheck_done <= 2'b10;
      //-----------------------------------------------------------------------------------------------
      // State 3 : Unplug either link until lock signals are deasserted and recover with delayed data
      //-----------------------------------------------------------------------------------------------
         wait (~(dl_locked || (align_locked_b && align_locked) || (trs_locked_b && trs_locked)));
         $display("Receiver is unlocked.");
         rxcheck_done <= 2'b10;
         wait (align_locked_b & align_locked);
         enable_check <= 1'b1;
         wait (dl_notsync | dlsync_error);
         wait (~dl_notsync | dlsync_error);
         @(posedge rx_clk);
         enable_check <= 1'b0;
         watchdog(20);
         rxcheck_done <= 2'b10;
      //-----------------------------------------------------------------------------------------------
      // State 3 : Unplug either link until lock signals are deasserted and recover with delayed data
      //-----------------------------------------------------------------------------------------------
         repeat (2) @ (posedge ones_detected);
         enable_check <= 1'b1;
         dlerror_expected <= 1'b1;
         wait (dl_notsync | dlsync_error);
         wait (~dl_notsync | dlsync_error);
         if (~dlsync_error) no_error_detected <= 1'b1;
         @(posedge rx_clk);
         enable_check <= 1'b0;
         rxcheck_done <= 2'b10;
         dlerror_expected <= 1'b0;
         @(posedge locked_blip);
         rxcheck_done <= 2'b10;
         @(negedge rxcheck_done[1]);
         if (dlsync_errflag) $display ("Test for RX Dual Link Synchronization Done! Error detected in the test.");
         else                $display ("Test for RX Dual Link Synchronization Done!");
         dl_dlytest_done <= 1'b1;
      end
   end
   
      
   task watchdog;
      input [6:0] timeout_value;   
   begin 
      watchdog_timeout = 1'b0;
      $display(" WATCHDOG : started at %0d ",$time); 
      fork : watch_dog 
      begin 
         wait(locked_blip); 
         $display(" trs_locked / dl_locked is asserted time:%0d",$time); 
         disable watch_dog; 
      end 
      begin 
         repeat(timeout_value)@(posedge ones_detected); 
         $display(" trs_locked / dl_locked is not asserted time:%0d",$time);
         watchdog_timeout = 1'b1;
         disable watch_dog; 
      end 
      join 
   end 
   endtask 
   endgenerate

//---------------------------------------------------------------------------
// Rx Format detect test
//---------------------------------------------------------------------------
   reg    trs_test_done;
   reg    frame_test_done;
   wire   trstest_error;

   generate
   if (TRS_TEST) begin : trs_lck_test
      wire   trstest_done;
      wire   trsproceed;

      tb_trs_locked_test u_trs_test
      (
      .enable       (start_check),
      .clk          (rx_clk),
      .trs_locked   (trs_locked),
      .align_locked (align_locked),
      .rx_eav       (rx_eav),
      .rx_trs       (rx_trs),
      .rxdata       (rxdata),
      .proceed      (trsproceed),
      .complete     (trstest_done),
      .error        (trstest_error)
      );
      defparam u_trs_test.err_tolerance = ERR_TOLERANCE;

      always @ (posedge trsproceed) begin
         rxcheck_done <= 2'b10;
      end

      always @ (posedge trstest_done)
      begin
         @(negedge locked_blip);
         trs_test_done <= 1'b1;
      end
   end
   endgenerate

   wire   frametest_error;
   generate
   if (FRAME_TEST) begin : frame_lck_test
      wire   frmtest_done;
      wire   frmproceed;

      tb_frame_locked_test u_frame_test
      (
         .rst            (ref_rst),
         .enable         (start_check && enable_frame_test),
         .clk            (rx_clk),
         .vid_std        (vid_std),
         .trs_locked     (trs_locked),
         .trs_locked_b   (trs_locked_b),
         .frame_locked   (frame_locked),
         .frame_locked_b (frame_locked_b),
         .align_locked   (align_locked),
         .v              (rx_v[0]),
         .rx_eav         (rx_eav),
         .rx_trs         (rx_trs),
         .tx_format      (tx_format),
         .rx_format      (rx_format),
         .proceed        (frmproceed),
         .complete       (frmtest_done),
         .error          (frametest_error)
      );
      defparam u_frame_test.err_tolerance = ERR_TOLERANCE;
      defparam u_frame_test.mode_dl = MODE_DL;

      always @ (posedge frmproceed) begin
         rxcheck_done <= 2'b10;
      end

      always @ (posedge frmtest_done)
      begin
         repeat (4) @(posedge rx_clk);
         frame_test_done <= 1'b1;
      end
   end
   endgenerate
 
//---------------------------------------------------------------------------
// VPID test
//---------------------------------------------------------------------------
   reg   vpid_test_error;
   reg   vpid_test_done;
   reg   enable_vpid_check;

   generate
   if (VPID_CHECK) begin: vpid_extract
      wire   vpid_error_out;
      wire   vpid_test_complete;

      tb_vpid_check u_vpid_check
      (
         .clk                       (rx_clk),
         .enable                    (start_check && enable_vpid_check),
         .dl_mapping                (dl_mapping),
         .vid_std                   (vid_std),
         .rxdata                    (RX_EN_SD_20 ? rx_data_int : rxdata),
         .rxdata_valid              (RX_EN_SD_20 ? rx_data_int_valid : rxdata_valid),
         .rxdata_b                  (rxdata_b),
         .rxdata_valid_b            (rxdata_valid_b),
         .rx_v                      (rx_v[0]),
         .rx_vpid_byte1             (rx_vpid_byte1),
         .rx_vpid_byte2             (rx_vpid_byte2),
         .rx_vpid_byte3             (rx_vpid_byte3),
         .rx_vpid_byte4             (rx_vpid_byte4),
         .rx_vpid_valid             (rx_vpid_valid),
         .rx_vpid_checksum_error    (rx_vpid_checksum_error),
         .rx_vpid_byte1_b           (rx_vpid_byte1_b),
         .rx_vpid_byte2_b           (rx_vpid_byte2_b),
         .rx_vpid_byte3_b           (rx_vpid_byte3_b),
         .rx_vpid_byte4_b           (rx_vpid_byte4_b),
         .rx_vpid_valid_b           (rx_vpid_valid_b),
         .rx_vpid_checksum_error_b  (rx_vpid_checksum_error_b),
         .tx_format                 (tx_format),
         .rx_line_f0                (rx_line_f0),
         .rx_line_f1                (rx_line_f1),
         .error_out                 (vpid_error_out),
         .test_complete             (vpid_test_complete)
      );
      defparam u_vpid_check.rx_a2b = RX_EN_A2B_CONV;
      defparam u_vpid_check.rx_b2a = RX_EN_B2A_CONV;
      defparam u_vpid_check.vpid_ins = TX_EN_VPID_INSERT;
      defparam u_vpid_check.vpid_ext = RX_EN_VPID_EXTRACT;
      defparam u_vpid_check.vpid_overwrite = TEST_VPID_OVERWRITE;
      defparam u_vpid_check.gen_anc = TEST_GEN_ANC;
      defparam u_vpid_check.gen_vpid = TEST_GEN_VPID;
      defparam u_vpid_check.vpid_gen_count = TEST_VPID_PKT_COUNT;
      defparam u_vpid_check.err_vpid = TEST_ERR_VPID;
      defparam u_vpid_check.en_vpid_b = EN_VPID_B;
      defparam u_vpid_check.mode_sd = MODE_SD;
      defparam u_vpid_check.mode_hd = MODE_HD;
      defparam u_vpid_check.mode_3g = MODE_3G;
      defparam u_vpid_check.mode_dl = MODE_DL;
      defparam u_vpid_check.mode_ds = MODE_DS;
      defparam u_vpid_check.mode_tr = MODE_TR;

      always @ (posedge vpid_test_complete)
      begin
       //  if (vpid_test_complete_msb || vpid_test_complete_lsb) begin
            repeat (4) @(posedge rx_clk);
            if (vpid_error_out) begin
               vpid_test_error = 1'b1;
            end
            else begin
               vpid_test_error = 1'b0;
            end
            if (VPID_VALID_EXPECTED) begin
               if (~rx_vpid_valid && ~rx_vpid_valid_b || vpid_error_out) begin
                  vpid_test_error = 1'b1;
               end
               else begin
                  vpid_test_error = 1'b0;
               end
            end
            vpid_test_done = 1'b1;
         // end
         // else begin
            // vpid_test_done = 1'b0;
         // end
      end  

   end
   endgenerate

//---------------------------------------------------------------------------
// RX Sample test
//---------------------------------------------------------------------------
  wire      rxsample_chk_error;
  wire      rxsample_chk_completed;
  reg       rxsample_chk_done;
  
  generate if (RXSAMPLE_TEST) begin: rx_sample_check
    
    tb_rxsample_test u_rxsample_test
    (
        .rx_clk               (rx_clk),
        .rst                  (ref_rst),
        .enable               (start_check && ~rxsample_chk_done),
        .trs_locked           (trs_locked),
        .rxdata_valid         (rxdata_valid),
        .rx_eav               (rx_eav),
        .rxsample_chk_error   (rxsample_chk_error),
        .rxsample_chk_done    (rxsample_chk_completed)
    );
    
    always @ (posedge rxsample_chk_completed)
    begin
      rxsample_chk_done = 1'b1;
    end
    
  end  
  endgenerate
  
//---------------------------------------------------------------------------
// TX PLL Test (Basic)
//---------------------------------------------------------------------------
   reg    tx_pll_test_done;
   wire   txpll_test_error;

   generate
   if (TXPLL_TEST) begin : tx_pll_test
      wire   txpll_test_done;
      wire   txpllproceed;

      tb_txpll_test u_txpll_test
      (
      .enable           (start_check),
      .clk              (rx_refclk),
      .trs_locked       (trs_locked[0]),
      .tx_reconfig_done (tx_sdi_reconfig_done),
      //.tx_clkout_match  (tx_clkout_match),
      .rxdata           (rxdata[19:0]),
      .proceed          (txpllproceed),
      .complete         (txpll_test_done),
      .error            (txpll_test_error)
      );
      defparam u_txpll_test.FAMILY = FAMILY;

      always @ (posedge txpllproceed) begin
         rxcheck_done <= 2'b10;
      end

      always @ (posedge txpll_test_done)
      begin
         tx_pll_test_done <= 1'b1;
      end
   end
   endgenerate
  
//---------------------------------------------------------------------------
// Timeout
//---------------------------------------------------------------------------
   reg   timeout_occur = 1'b0;

   always @ (timer)
   begin
      if (timer == TIMEOUT) begin
         $display ("-- Rx Checker Timeout. Receiver is not locked");
         rxcheck_done = 2'b01;
         #(1);
         //index = index + 1;
         timeout_occur = 1'b1;
         //timer = 0;
      end
   end

//---------------------------------------------------------------------------
// Check RX status
//---------------------------------------------------------------------------
   integer j;
   reg     dist_error;
   reg     print_status;
   reg     print_disturb_test_status;
   reg     test_state;

   always @ (posedge start_check)
   begin
      crc_error = 1'b0;
      expected_ln = 0;
      dist_error = 1'b0;
      chk_ln = 1'b0;
      chk_sync = 1'b0;
      chk_crc = 1'b0;
      compare_data = 1'b0;
      dlsync_errflag = 1'b0;
      error_detected = 1'b1;
      print_status = 1'b0;
      update_result_rx = 1'b0;
      test_state = 1'b0;
      vpid_test_done = 1'b0;
      rxsample_chk_done = 1'b0;
      enable_vpid_check = 1'b0;
      enable_frame_test = 1'b0;
      tx_pll_test_done = 1'b0;
      #(1);
      if (TXPLL_TEST) wait (tx_pll_test_done & rx_locked);
      if (TRS_TEST) wait (trs_test_done & rx_locked);
      if (DL_SYNC) wait (dl_dlytest_done & rx_locked);
      if (vid_std == 3'b000 && RXSAMPLE_TEST) begin
         $display("Checking rx_dataout_valid signal...");
         wait (rxsample_chk_done & rx_locked);
         $display ("Rx Sample test done...");
      end
      if (VPID_CHECK) begin
         enable_vpid_check = 1'b1;
         $display ("Waiting for Payload ID packet...");
         wait (vpid_test_done & rx_locked);
         $display ("Payload ID test done...");
         enable_vpid_check = 1'b0;
      end
      if (FRAME_TEST) begin
         enable_frame_test = 1'b1;
         $display("\nFrame_locked test started...\n");
         wait (frame_test_done & rx_locked);
         enable_frame_test = 1'b0;
      end

      if (vid_std != 3'b000 && LN_CHECK) begin
         chk_ln = 1'b1;
         $display ("Checking received line number...");
      end
      if (vid_std != 3'b000 && CRC_CHECK) begin
         chk_crc = 1'b1;
         $display("Checking received crc...");
      end
      if (DATA_CMP) begin
         compare_data = 1'b1;
         $display ("Comparing transmitted data and received data...");
      end
      if (SYNC_CHECK) begin
         chk_sync = 1'b1;
         $display("Checking received sync outputs...");
         // @(posedge sync_check_done);
         // if (sync_error) $display ("-- Found sync error in received data.");
      end
      //If no disturb data test is enabled
      if (~DISTURB_SERIAL) begin
         if (chk_ln || compare_data|| chk_sync) begin
            // In certain cases, rx_v deasserted just after start_check goes high. 
            // Hence, we will need to wait two times rx_v here.
            if (rx_v[0]) begin
                repeat (2) @(negedge rx_v[0]);
            end else begin
                @(negedge rx_v[0]);
            end
            if (is_interlaced) begin
               repeat (2 + 2*NUM_FRAME_TO_CHECK) @(negedge rx_v[0]);
            end
            else begin
               repeat (1 + NUM_FRAME_TO_CHECK) @(negedge rx_v[0]);
            end
         end 
         else if (chk_crc) begin
           repeat (2) #(2000000000);
         end
         // Allow some buffer time, in case no additional test is enabled after txpll switching test
         repeat (6) @(posedge rx_clk);
         print_status = 1'b1;
         #(1);
      end
      else if (DISTURB_SERIAL && (chk_crc || compare_data)) begin
         @(negedge rx_v[0]);
         if (is_interlaced) begin
            repeat (2) @(negedge rx_v[0]);
         end
         else begin
            @(negedge rx_v[0]);
         end

         print_status = 1'b1;
         #(1);
         rxcheck_done = 2'b10;

         $display ("Disturbed data after eav...");
         if (is_interlaced) begin
            repeat (2) @(negedge rx_v[0]);
         end
         else begin
            @(negedge rx_v[0]);
         end
         print_disturb_test_status = 1'b1;
         #(1);
         rxcheck_done = 2'b10;

         $display ("Disturbed data after sav...");
         print_disturb_test_status = 1'b0;
         #(1);
         error_detected = error_detected | dist_error;
         test_state = test_state + 1'b1;
         if (is_interlaced) begin
            repeat (2) @(negedge rx_v[0]);
         end
         else begin
            @(negedge rx_v[0]);
         end
         print_disturb_test_status = 1'b1;
         #(1);
         error_detected = error_detected | dist_error;
      end

      update_result_rx = 1'b1;
      @(posedge rx_clk);

      rxcheck_done = 2'b10;
      error_detected = 1'b0;
      chk_ln = 1'b0;
      chk_crc = 1'b0;
      chk_sync = 1'b0;
      compare_data = 1'b0;
      trs_test_done = 1'b0;
      frame_test_done = 1'b0;
      dl_dlytest_done = 1'b0;
      vpid_test_done = 1'b0;
      rxsample_chk_done = 1'b0;
      print_status = 1'b0;
      print_disturb_test_status = 1'b0;
      update_result_rx = 1'b0;
      test_state = 1'b0;
      tx_pll_test_done = 1'b0;
   end

//---------------------------------------------------------------------------
// Print Rx status message
//---------------------------------------------------------------------------
   always @ (posedge print_status)
   begin
      if (bad_ln) begin 
         $display("-- Bad LN detected in received data.");
      end
      if (crc_error) begin
         $display ("-- Found crc_error in received data.");
      end
      if (data_error_seen) begin
         $display ("-- Received data do not match with transmitted data.");
      end
      if (sync_error) begin
         $display ("-- Found sync error in received data.");
      end
      if (vpid_test_error) begin
         $display ("-- Error in Payload ID test.");
      end
      if (frametest_error) begin
         $display ("-- Rx format does not match with Tx format.");
      end
      if (trstest_error) begin
         $display ("-- Found error in Trs_locked test.");
      end
      if (rxsample_chk_error) begin
         $display ("-- Found error in Rx Sample test.");
      end

      error_detected = (bad_ln | crc_error | sync_error);

      if (!MODE_SD & !MODE_HD & !MODE_DL & !RX_EN_B2A_CONV & !RX_EN_A2B_CONV) begin
        if (rx_std_error) begin
            $display ("-- rx_std and tx_std are not matching.");
        end

        error_detected = error_detected | rx_std_error;
      end

      if ((MODE_MR || MODE_TR || MODE_DS) && !TXPLL_TEST) begin
        error_detected = error_detected | rcfg_cnt_err;
      end
      if (compare_data) begin
         error_detected = error_detected | data_error_seen;
      end
      if (VPID_CHECK) begin
         error_detected = error_detected | vpid_test_error;
      end
      if (FRAME_TEST) begin
         error_detected = error_detected | frametest_error;
      end
      if (TRS_TEST) begin
         error_detected = error_detected | trstest_error;
      end
      if (RXSAMPLE_TEST) begin
         error_detected = error_detected | rxsample_chk_error;
      end

      if (MODE_DL) begin
         if (data_error_seen_b) begin
            $display ("-- Received data do not match with transmitted data (link B).");
         end
         error_detected = error_detected | crc_error;

         if (DL_SYNC) begin
            error_detected = error_detected | dlsync_errflag;
         end
         if (compare_data) begin
            error_detected = error_detected | data_error_seen_b;
         end
      end

      if (~error_detected) begin
         $display ("\n ##### Test %d: Channel %d RECEIVE OK \n", index, ch_num[2:0]);
      end
      else begin
         $display ("\n ##### Error in receive test %d Channel %d \n", index, ch_num[2:0]);
      end
   end

//---------------------------------------------------------------------------
// Print disturbed data test status
//---------------------------------------------------------------------------
   reg crc_test_err;
   reg data_test_err;

   always @ (posedge print_disturb_test_status)
   begin
      if (compare_data) begin
         if (data_error_seen) begin
            $display ("-- Received data do not match with transmitted data.");
         end
         else begin
            $display ("-- Received data match with transmitted data.");
         end
         dist_error = test_state ? (dist_error | ~data_error_seen) : (dist_error | data_error_seen);

         if (MODE_DL) begin
            if (data_error_seen_b) begin
               $display ("-- Received data do not match with transmitted data (link B).");
            end
            else begin
               $display ("-- Received data match with transmitted data (link B).");
            end
            dist_error = test_state ? (dist_error | ~data_error_seen_b) : (dist_error | data_error_seen_b);
         end

         if (dist_error) begin
            $display ("\n ##### Test %d: Error in disturbed data test. \n", index);
         end
         else begin
            $display ("\n ##### Test %d: Disturbed data test OK! \n", index);
         end
      end

      if (chk_crc) begin
         if (crc_error) begin
            $display ("-- Detected crc_error in rx.");
         end
         else begin
            $display ("-- crc_error checking passed.");
         end

         crc_test_err = test_state ? ~crc_error : crc_error;
         dist_error = dist_error | crc_test_err;

         if (~crc_test_err) begin
            $display ("\n ##### Test %d: Disturbed data test OK! \n", index);
         end
         else begin
            $display ("\n ##### Test %d: Error in disturbed data test. \n", index);
         end
         #(1);
         crc_test_err = 1'b0;
      end
   end

//---------------------------------------------------------------------------
// Print checker final status
//---------------------------------------------------------------------------
   reg   chk_completed;

   always @ (posedge print_checker_final_status or posedge timeout_occur)
   begin
      chk_completed = 1'b0;
      #(1);
      error_detected = result_rx [0];
      for (j = 1; j < index; j = j + 1) begin
         error_detected = error_detected | result_rx [j];
      end

      //$display ("\n ## Channel %d:",ch_num[2:0]);
      if (~error_detected) begin          
         $display (" ##### Channel %d: RECEIVE TEST COMPLETED SUCCESSFULLY! #####", ch_num[2:0]);
      end
      else begin
         $display (" ##### Channel %d: FAILED: RECEIVE TEST COMPLETED WITH ERROR(S).#####", ch_num[2:0]);
      end
      chk_completed = 1'b1;               
    end

    //--------------------------------------------------------------------------
    // [END] comment
    //--------------------------------------------------------------------------

 endmodule
