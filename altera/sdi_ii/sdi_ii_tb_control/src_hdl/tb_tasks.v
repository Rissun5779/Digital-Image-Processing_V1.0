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



//--------------------------------------------------------------------------------
// Initialization
//--------------------------------------------------------------------------------
task reset_tx;
begin
  tx_rst = 1'b1;
  tx_phy_mgmt_clk_rst = 1'b1;
  //tx_rst_smpte372 = 1'b1;
  repeat (20) @(negedge tx_ref_clk);
  tx_rst = 1'b0;
  tx_phy_mgmt_clk_rst = 1'b0;
  repeat (5) @(negedge tx_ref_clk);
  //tx_rst_smpte372 = 1'b0;
end
endtask

task reset_tx_long;
begin
  tx_rst = 1'b1;
  tx_phy_mgmt_clk_rst = 1'b1;
  //tx_rst_smpte372 = 1'b1;
  repeat (500) @(negedge tx_ref_clk);
  tx_rst = 1'b0;
  tx_phy_mgmt_clk_rst = 1'b0;
  //tx_rst_smpte372 = 1'b0;
end
endtask

task reset_rx;
begin
  rx_rst = 1'b1;
  rx_phy_mgmt_clk_rst = 1'b1;
  rx_rst_smpte372 = 1'b1;
  repeat (20) @(negedge rx_coreclk);
  rx_rst = (FAMILY == "Arria 10" && (mode_ds | mode_tr))  ? ~tx_ready : 1'b0;
  rx_phy_mgmt_clk_rst = 1'b0;
  rx_rst_smpte372 = 1'b0;
end
endtask

task reset_rxchker;
begin
  rx_chk_rst = 1'b1;
  repeat (20) @(negedge rx_coreclk);
  rx_chk_rst = 1'b0;
end
endtask

task reset_reconfig;
begin
  t_recon_rst = 1'b1;
  repeat (20) @(negedge reconfig_clk);
  t_recon_rst = 1'b0;
end
endtask

task initialize;
begin
  reset_rxchker();
  if (rst_recon_test | FAMILY == "Arria 10") reset_reconfig();
  reset_tx();
  reset_rx();  
  tx_chk_start_chk = 2'b00;
  rx_chk_start_chk = 2'b00;
  rx_chk_start_chk_ch0 = 2'b00;
  dead_data = 1'b0;
  dead_data_b = 1'b0;
  delaydata(0, 0, 0);
  disturb_bit = 1'b0;
  disturb_eav = 1'b0;
  disturb_sav = 1'b0;
  disturb_v = 1'b0;
  t_disturb_after_sav = 1'b0;
  t_disturb_after_eav = 1'b0;
  tx_pll_sel_task = 1'b0;
  tx_start_reconfig_task = 1'b0;  
  gate_tx_refclk = 1'b0;
  gate_tx_refclk_alt = 1'b0;
  gate_rx_refclk = 1'b0;
end
endtask

//--------------------------------------------------------------------------------
// Transmit desired video standard
//--------------------------------------------------------------------------------
task transmit_12G;
  input [3:0]   i_tx_format;
  input [4*8:0] i_12g_std;
  input [2*8:0] i_dl_mapping;  
begin
  tx_format = i_tx_format; 
  // enable_3gb = i_enable_3gb;
  tx_std = (i_12g_std == "12GB") ? 3'b110 : 3'b111;
  dl_mapping = (i_dl_mapping == "DL") ? 1'b1 : 1'b0;
  if (multi_recon) rx_check_multi();
  else             rx_check();
  if (reset_test) begin
    reset_seq_test();
  end
end 
endtask

task transmit_6G;
  input [3:0]   i_tx_format;
  input [3*8:0] i_6g_std;
  input [2*8:0] i_dl_mapping;  
begin
  tx_format = i_tx_format; 
  // enable_3gb = i_enable_3gb;
  tx_std = (i_6g_std == "6GB") ? 3'b100 : 3'b101;
  dl_mapping = (i_dl_mapping == "DL") ? 1'b1 : 1'b0;
  if (multi_recon) rx_check_multi();
  else             rx_check();
  if (reset_test) begin
    reset_seq_test();
  end
end 
endtask 

task transmit_3G;
  input [3:0]   i_tx_format;
  input [3*8:0] i_3g_std;
  input [2*8:0] i_dl_mapping;  
begin
  tx_format = i_tx_format; 
  // enable_3gb = i_enable_3gb;
  tx_std = (i_3g_std == "3GB") ? 3'b010 : 3'b011;
  dl_mapping = (i_dl_mapping == "DL") ? 1'b1 : 1'b0;
  if (multi_recon) rx_check_multi();
  else             rx_check();
  if (reset_test) begin
    reset_seq_test();
  end
end 
endtask 

task transmit_HD;
  input [3:0]   i_tx_format;
  input [2*8:0] i_dl_mapping;
  begin
  tx_format = i_tx_format;
  // enable_3gb = 1'b0;
  tx_std = 3'b001;
  dl_mapping = (i_dl_mapping == "DL") ? 1'b1 : 1'b0;
  if (multi_recon) rx_check_multi();
  else             rx_check();
  if (reset_test) begin
    reset_seq_test();
  end
  end
endtask

task transmit_SD;
  input [3:0]   i_tx_format;
  begin
  tx_format = i_tx_format;
  // enable_3gb = 1'b0;
  tx_std = 3'b000;
  dl_mapping = 1'b0;
  if (multi_recon) rx_check_multi();
  else             rx_check();
  if (reset_test) begin
    reset_seq_test();
  end
  end
endtask

task transmit_HD_recon;
  input [3:0]   i_tx_format;
  input [2*8:0] i_dl_mapping;
  begin
  tx_format = i_tx_format;
  tx_std = 3'b001;
  dl_mapping = (i_dl_mapping == "DL") ? 1'b1 : 1'b0;
end
endtask

task transmit_3G_recon;
  input [3:0]   i_tx_format;
  input [3*8:0] i_3g_std;
  input [2*8:0] i_dl_mapping;  
begin
  tx_format = i_tx_format; 
  tx_std = (i_3g_std == "3GB") ? 3'b010 : 3'b011;
  dl_mapping = (i_dl_mapping == "DL") ? 1'b1 : 1'b0;
end 
endtask

//--------------------------------------------------------------------------------
// Check rx_checker status
//--------------------------------------------------------------------------------
task rx_check;
begin
  
  if(rst_recon_test) begin
    if (~is_first_recon) begin
      if (rst_recon_pre_ow) begin
        @ (posedge pre_mcounter_ow);
        $display ("Resetting core before overwritting m counter...");
        reset_rx();
      end else begin
        @ (posedge post_mcounter_ow);
        $display ("Resetting core after overwritting m counter...");
        reset_rx();
      end
    end 
  end
  
  @(posedge rx_chk_done[1]);
  tx_chk_start_chk = 2'b01;
  @(negedge rx_chk_done[1]);
  rx_chk_start_chk = 2'b01;
  if (txpll_test) tx_pll_test_states();
  if (trs_test) trstest_states();
  if (frame_test) frametest_states();
  if (dl_sync) hddlsync_states();
  if (disturb_serial) begin
    waitforchecker_proceed();
    t_disturb_after_eav = 1'b1;
    @(negedge disturb_bit);
    t_disturb_after_eav = 1'b0;
    waitforchecker_proceed();
    t_disturb_after_sav = 1'b1;
    @(negedge disturb_bit);
    t_disturb_after_sav = 1'b0;
  end
  @(posedge rx_chk_done[1]);
  tx_chk_start_chk = 2'b00;
  rx_chk_start_chk = 2'b00;
end
endtask

task rx_check_multi;
begin
  @(posedge rx_chk_done[1] or posedge rx_chk_done_ch0[1]);
  if (rx_chk_done[1]) begin
    if (~rx_chk_done_ch0[1]) @(posedge  rx_chk_done_ch0[1]);
    tx_chk_start_chk = 2'b01; 
  end else if (rx_chk_done_ch0[1]) begin 
    if (~rx_chk_done[1]) @(posedge  rx_chk_done[1]);
    tx_chk_start_chk = 2'b01;
  end   
 
  @(negedge rx_chk_done[1] or negedge rx_chk_done_ch0[1]);
  if (rx_chk_done[1]) @(negedge rx_chk_done[1]);  
  else if (rx_chk_done_ch0[1]) @(negedge rx_chk_done_ch0[1]); 
  rx_chk_start_chk     = 2'b01;
  rx_chk_start_chk_ch0 = 2'b01;  

  if (disturb_serial) begin
    @(posedge rx_chk_done[1] or posedge rx_chk_done_ch0[1]);
    @(negedge rx_chk_done[1] or negedge rx_chk_done_ch0[1]);
    t_disturb_after_eav = 1'b1;
    @(posedge rx_chk_done[1] or posedge rx_chk_done_ch0[1]);
    @(negedge rx_chk_done[1] or negedge rx_chk_done_ch0[1]);
    t_disturb_after_eav = 1'b0;
    t_disturb_after_sav = 1'b1;
  end

  @(posedge rx_chk_done[1] or  posedge rx_chk_done_ch0[1]);
  t_disturb_after_sav = 1'b0;
  rx_chk_start_chk = 2'b00;
  if (~rx_chk_done_ch0[1]) @(posedge rx_chk_done_ch0[1]);  
  rx_chk_start_chk_ch0 = 2'b00;
  tx_chk_start_chk = 2'b00;
end
endtask

//--------------------------------------------------------------------------------
// HD Dual Link Sync Tasks
//--------------------------------------------------------------------------------
task delaydata;
  input i_dlylinka;
  input i_dlylinkb;
  input i_dlycycle;
begin
  enable_dly = i_dlylinka;
  enable_dly_b = i_dlylinkb;
  update_dly_cycle = i_dlycycle;
end
endtask

task hddlsync_states;
begin
//-----------------------------------------------------------------------
// State 1 : Transmit delayed and non-delayed data in either link
//-----------------------------------------------------------------------
  reset_rx();
  delaydata(1,0,0);
  $display("Transmitting delayed data in link A.");
  waitforchecker_proceed();
  reset_rx();
  delaydata(0,1,0);
  $display("Transmitting delayed data in link B.");
  waitforchecker_proceed();
  reset_rx();
  delaydata(1,1,1);
  $display("Transmitting random delayed data in both links.");
  waitforchecker_proceed();
//-----------------------------------------------------------------------------------------------
// State 2 : Unplug either link when dl_locked is high (fast) and recover with delayed data
//-----------------------------------------------------------------------------------------------
  dead_data_b = 1'b1;
  $display("Link B is unplugged.");
  waitforchecker_proceed();
  dead_data_b = 1'b0;
  delaydata(0,1,0);
  $display("Link B is recovered with delayed data.");
  waitforchecker_proceed();
//-----------------------------------------------------------------------------------------------
// State 3 : Unplug either link until lock signals are deasserted and recover with delayed data
//-----------------------------------------------------------------------------------------------
  delaydata(0,0,0);
  dead_data = 1'b1;
  $display("Link A is unplugged.");
  waitforchecker_proceed();
  dead_data = 1'b0;
  delaydata(1,0,0);
  $display("Link A is recovered with delayed data.");
  waitforchecker_proceed();
  reset_rx();
  delaydata(1,0,1);
  $display("Transmitting delayed data in link A (exceeding FIFO depth)");
  waitforchecker_proceed();
  reset_rx();
  delaydata(0,0,0);
  $display("Recovering back the data...");
  waitforchecker_proceed();
end
endtask

//--------------------------------------------------------------------------------
// Tx PLL Select 
//--------------------------------------------------------------------------------

task tx_pll_test_states;
begin
//--------------------------------------------------
// State 1: Switch from TX_PLL_SEL 0 To TX_PLL_SEL 1
//--------------------------------------------------
waitforchecker_proceed();
$display("Start of TX PLL Select Test");
tx_pll_sel_task = 1'b1;
tx_start_reconfig_task = 1'b1;
$display("State 1: Switch from TX_PLL_SEL 0 To TX_PLL_SEL 1 and waiting for tx_reconfig_done to assert...");

if ((FAMILY != "Arria 10" & DIRECTION == "tx") || FAMILY == "Arria 10") begin
  gate_tx_refclk = 1'b1;
  $display("Gate Off tx_refclk");
end

waitforchecker_proceed();
$display("Reconfig Done and Set Reconfig To Low");
tx_start_reconfig_task = 1'b0;
if (FAMILY != "Arria 10") begin
    $display("Reset Tx");
    reset_tx();
end

if ((FAMILY != "Arria 10" & DIRECTION == "tx") || FAMILY == "Arria 10") begin
  reset_rx();
  $display("Waiting for trs_locked to assert...");
  waitforchecker_proceed();
  $display("trs_locked asserted, ungating rx_refclk");
  gate_tx_refclk = 1'b0;
  $display("State 1 Success: TRS_LOCKED asserted and remain asserted");
end else if (DIRECTION == "du") begin
  $display("Gate Off rx_refclk");
  gate_rx_refclk = 1'b1;
  $display("Checking tx_clkout..");
  tx_clkout_match_posedge();
  $display("tx_clkout is correct, ungating rx_refclk and reset rx");
  gate_rx_refclk = 1'b0;
  reset_rx();
  $display("Waiting for trs_locked to assert...");
  waitforchecker_proceed();
  $display("State 1 Success: TRS_LOCKED remain asserted");
end

//--------------------------------------------------
// State 2: Switch from TX_PLL_SEL 1 To TX_PLL_SEL 0
//--------------------------------------------------
waitforchecker_proceed();
tx_pll_sel_task = 1'b0;
gate_tx_refclk_alt = 1'b1;
tx_start_reconfig_task = 1'b1;
$display("State 2: Switch from TX_PLL_SEL 1 To TX_PLL_SEL 0 and waiting for tx_reconfig_done to assert...");
$display("Gate Off tx_refclk_alt");
waitforchecker_proceed();
$display("Reconfig Done and Set Reconfig To Low");
tx_start_reconfig_task = 1'b0;
$display("Resetting ...");
if (FAMILY != "Arria 10") begin
    reset_tx();
end
reset_rx();
$display("Waiting for trs_locked to assert...");
waitforchecker_proceed();
$display("State 2 Success: TRS_LOCKED asserted and remain asserted.");
gate_tx_refclk_alt = 1'b0;
$display("Resetting ...");
if (FAMILY != "Arria 10") begin
    reset_tx();
end
reset_rx();
$display("Waiting for trs_locked to assert...");
//reset_rx();
end
endtask

//--------------------------------------------------------------------------------
// Rx Format Detect Task
//--------------------------------------------------------------------------------
task trstest_states;
begin
//-----------------------------------------------------------------------------------------------------
// State 1 : Unplug the data link between tx and rx and reconnect with delayed data within single line
//------------------------------------------------------------------------------------------------------
  waitforchecker_proceed();
  $display("Start of TRS locked test.");
  $display("\nState 1: RP168 - Dead data within a single line.");
  dead_data = 1'b1;
  dead_data_b = 1'b1;
  $display("Data link is unplugged...");
  waitforchecker_proceed();
  $display("Recover with delayed data...");
  delaydata(1,1,0);
  dead_data = 1'b0;
  dead_data_b = 1'b0;
  waitforchecker_proceed();

  waitforchecker_proceed();
  dead_data = 1'b1;
  dead_data_b = 1'b1;
  $display("Data link is unplugged...");
  waitforchecker_proceed();
  $display("Recover with non-delayed data...");
  delaydata(0,0,0);
  dead_data = 1'b0;
  dead_data_b = 1'b0;
  waitforchecker_proceed();
//----------------------------------------------------------------------------------------------
// State 2 : Unplug the data link between tx and rx and reconnect with delayed data after 3 us
//----------------------------------------------------------------------------------------------
  waitforchecker_proceed();
  if ( tx_std == 3'b001 ) begin
    $display("\nState 2: RP168 - 6us dead time.");
  end else begin
    $display("\nState 2: RP168 - 3us dead time.");
  end
  dead_data = 1'b1;
  dead_data_b = 1'b1;
  $display("Data link is unplugged...");
  waitforchecker_proceed();
  $display("Recover with delayed data...");
  delaydata(1,1,0);
  dead_data = 1'b0;
  dead_data_b = 1'b0;
  waitforchecker_proceed();

  waitforchecker_proceed();
  dead_data = 1'b1;
  dead_data_b = 1'b1;
  $display("Data link is unplugged...");
  waitforchecker_proceed();
  $display("Recover with non-delayed data...");
  delaydata(0,0,0);
  dead_data = 1'b0;
  dead_data_b = 1'b0;
  //waitforchecker_proceed();

//----------------------------------------------------------------------------------------
// State 3 : Transmit few consecutive lines with missing EAV then SAV 
//----------------------------------------------------------------------------------------
  waitforchecker_proceed();
  $display("\nState 3: Missing EAV/SAV in consecutive lines without exceeding the tolerance level.");  
  $display ("Interrupting bits in EAV for %d times...", err_tolerance[3:0]);
  missing_trs("eav");
  waitforchecker_proceed();
  disturb_eav = 1'b0;
  $display ("Recovering data...");
  waitforchecker_proceed();
  $display ("Interrupting bits in SAV for %d times...", err_tolerance[3:0]);
  missing_trs("sav");
  waitforchecker_proceed();
  disturb_sav = 1'b0;
  $display ("Recovering data...");
//----------------------------------------------------------------------------------------
// State 4 : Continue to pass missing EAV and SAV until err_tolerance is exceeded
//----------------------------------------------------------------------------------------
  waitforchecker_proceed();
  $display("\nState 4: Missing EAV/SAV in consecutive lines exceeding the tolerance level.");  
  $display ("Interrupting bits in both EAV and SAV for %d times...", err_tolerance[3:0] + 1'b1);
  $display ("Trs_locked should be deasserted due to %d missing EAVs", err_tolerance[3:0] + 1'b1);
  missing_trs("sav");
  missing_trs("eav");
  waitforchecker_proceed();
  $display ("Recovering data...");
  disturb_sav = 1'b0;
  disturb_eav = 1'b0;
  waitforchecker_proceed();
  $display ("Interrupting bits in SAV for %d times...", err_tolerance[3:0] + 1'b1);
  missing_trs("sav");
//----------------------------------------------------------------------------------------
// State 5 : Pass missing EAV / SAV or delay / early data to rx when rx is unlocked
//----------------------------------------------------------------------------------------
  waitforchecker_proceed();
  $display ("Recovering data...");
  disturb_sav = 1'b0;
  waitforchecker_proceed();
  repeat (2) begin
    $display ("Missing EAV in every 6 lines");
    missing_trs("eav");
    waitforchecker_proceed();
    disturb_eav = 1'b0;
    $display ("Recovering data...");
    waitforchecker_proceed();
  end
  repeat (2) begin
    $display ("Missing SAV in every 6 lines");
    missing_trs("sav");
    waitforchecker_proceed();
    disturb_sav = 1'b0;
    $display ("Recovering data...");
    waitforchecker_proceed();
  end

  $display ("Transmitting delayed data");
  delaydata(1,1,0);
  waitforchecker_proceed();
  waitforchecker_proceed();
  $display ("Recovering data...");
  delaydata(0,0,0);

  waitforchecker_proceed();
end
endtask

//----------------------------------------------------------------------------------------------------------------------
//This task is only valid for certain tx_format(s)
//----------------------------------------------------------------------------------------------------------------------
task missing_trs;
input [3*8:0] sel_trs;
begin
  if (sel_trs == "eav") begin
    disturb_eav = 1'b1;
    //disturb_sav = 1'b0;
    case (tx_format) 
      4'b0001 : eavword_count = 74;
      4'b1100 : eavword_count = 98;
      4'b1101 : begin
                  if (tx_std == 3'b010) eavword_count = 196;
                  else eavword_count = 98;
                end
      default : eavword_count = 98;
    endcase
  end

  else if (sel_trs == "sav") begin
    disturb_sav = 1'b1;
    //disturb_eav = 1'b0;
    case (tx_format)
      4'b0001 : savword_count = 58;
      4'b1100 : savword_count = 59;
      4'b1101 : begin
                  if (tx_std == 3'b010) savword_count = 294;
                  else savword_count = 147;
                end
      default : savword_count = 147;
    endcase
  end
end
endtask

task waitforchecker_proceed;
begin
  @(posedge rx_chk_done[1]);
  @(negedge rx_chk_done[1]);
end
endtask

task tx_clkout_match_posedge;
begin
  @(posedge tx_clkout_match);
end
endtask

task waitforchecker_posedge_proceed;
begin
  @(posedge rx_check_posedge);
end
endtask

//--------------------------------------------------------------------------------
// Frame Locked Test Task
//--------------------------------------------------------------------------------
task frametest_states;
begin
//----------------------------------------------------------------------------------------
// State 1 : Unplug the data link between tx and rx and reconnect with delayed data
//----------------------------------------------------------------------------------------
  waitforchecker_proceed();
  dead_data = 1'b1;
  $display("Data link is unplugged...");
  waitforchecker_proceed();
  $display("Recover with delayed data...");
  delaydata(1,0,0);
  dead_data = 1'b0;
  waitforchecker_proceed();

  waitforchecker_proceed();
  dead_data = 1'b1;
  $display("Data link is unplugged...");
  waitforchecker_proceed();
  $display("Recover with non-delayed data...");
  delaydata(0,0,0);
  dead_data = 1'b0;
  waitforchecker_proceed();
  reset_rx();
//----------------------------------------------------------------------------------------
// State 2 : Transmit missing EAV in few lines in a frame to check ERR_TOLERANCE lvl
//----------------------------------------------------------------------------------------
  waitforchecker_proceed();
  repeat (err_tolerance) begin
    $display ("Transmitting data with missing EAV in a frame");
    missing_trs("eav");
    waitforchecker_proceed(); 
    disturb_eav = 1'b0;
    waitforchecker_proceed();
    waitforchecker_proceed();
  end
//-------------------------------------------------------------------------------------------------------------------------------
// State 3 : Transmit missing EAV in few lines in a frame exceeding ERR_TOLERANCE lvl and see whether frame locked is deasserted
//-------------------------------------------------------------------------------------------------------------------------------
    $display ("Continue to pass missing EAV after reaching error tolerance level...");
    missing_trs("eav");
    waitforchecker_proceed();
    disturb_eav = 1'b0;
    waitforchecker_proceed();
    reset_rx();
//----------------------------------------------------------------------------------------
// State 4 : Transmit missing EAV in few lines in a frame when frame_locked is low
//----------------------------------------------------------------------------------------
    waitforchecker_proceed();
    $display ("Missing EAV when frame_locked is deasserted...");
    missing_trs("eav");
    waitforchecker_proceed();
    disturb_eav = 1'b0;
    waitforchecker_proceed();
//----------------------------------------------------------------------------------------
// State 5 : For 3G case, switch from 3GA to 3GB or vice versa
//----------------------------------------------------------------------------------------
    if (tx_std[1]) begin
      reset_rx();
      waitforchecker_proceed();
      // enable_3gb = ~enable_3gb;
      tx_std[0] = ~tx_std[0];
      dl_mapping = ~dl_mapping;
      if (tx_std == 3'b010) $display ("Transmitting 3GB standard...");
      else $display ("Transmitting 3GA standard...");
      //waitforchecker_proceed();
    end
    waitforchecker_proceed();
end
endtask


//-----------------------------------------------------------------------
// Reset Sequence Test
//-----------------------------------------------------------------------
task reset_seq_test;
begin
  $display ("Resetting core first followed by resetting xcvr...");
  rx_rst = 1'b1;
  repeat (20) @(negedge rx_coreclk);  
  rx_phy_mgmt_clk_rst = 1'b1;
  repeat (20) @(negedge rx_coreclk);
  rx_rst = 1'b0;
  repeat (20) @(negedge rx_coreclk);
  rx_phy_mgmt_clk_rst = 1'b0;
  tx_rst = 1'b1;
  repeat (20) @(negedge tx_ref_clk);  
  tx_phy_mgmt_clk_rst = 1'b1;
  repeat (20) @(negedge tx_ref_clk);
  tx_rst = 1'b0;
  repeat (20) @(negedge tx_ref_clk);
  tx_phy_mgmt_clk_rst = 1'b0;  
  rx_check();

  $display ("Resetting xcvr first followed by resetting core...");
  rx_phy_mgmt_clk_rst = 1'b1;
  repeat (20) @(negedge rx_coreclk);  
  rx_rst = 1'b1;
  repeat (20) @(negedge rx_coreclk);
  rx_phy_mgmt_clk_rst = 1'b0;
  repeat (20) @(negedge rx_coreclk);
  rx_rst = 1'b0;
  tx_phy_mgmt_clk_rst = 1'b1;
  repeat (20) @(negedge tx_ref_clk);  
  tx_rst = 1'b1;
  repeat (20) @(negedge tx_ref_clk);
  tx_phy_mgmt_clk_rst = 1'b0;
  repeat (20) @(negedge tx_ref_clk);
  tx_rst = 1'b0;  
  rx_check();
  
end
endtask

//--------------------------------------------------------------------------------
// Print final result
//--------------------------------------------------------------------------------
task printresult;
begin
  #(1);
  tx_chk_start_chk = 2'b10;
  #(1);
  rx_chk_start_chk = 2'b10;
  rx_chk_start_chk_ch0 = 2'b10;
end
endtask 

//--------------------------------------------------------------------------------
// End Simulation
//--------------------------------------------------------------------------------
task complete_sim;
begin
  @(posedge rx_chk_completed or posedge rx_chk_completed_ch0);
  if (~rx_chk_completed) @(posedge rx_chk_completed);
  if (multi_recon & ~rx_chk_completed_ch0) @(posedge rx_chk_completed_ch0);
  $stop(0);
end
endtask 

task start_test;
begin
        //------------------------------------------------------------------------------------------
        // Tx PLL test enabled
        // Test was shortened to single resolution only due to Tx PLL switching testbench on multi 
        // rate exceeds Modelsim Intel FPGA Edition recommended capacity, and is taking a long time
        // to complete.
        //------------------------------------------------------------------------------------------
        if (mode_tr & txpll_test) begin
            transmit_3G(4'b1101, "3GA", "--");
        end else if (mode_ds & txpll_test) begin
            transmit_HD(4'b0101, "--");
        end else if (mode_mr & txpll_test) begin
            transmit_12G(4'b1101, "12GA", "--");
        //-------------------------------------------------------
        // B2A enabled
        //-------------------------------------------------------
        end else if (RX_EN_B2A_CONV == 1'b1) begin
            transmit_3G(4'b1101, "3GB", "DL");

        //-------------------------------------------------------
        // Multi rate full sequence
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "full") begin
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_12G(4'b1100, "12GB", "DL");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_12G(4'b1100, "12GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_12G(4'b1101, "12GB", "DL");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_6G(4'b0110, "6GB", "--");
            reset_tx();
            transmit_3G(4'b1001, "3GB", "DL");
            reset_tx();
            transmit_6G(4'b1100, "6GA", "--");
            reset_tx();
            transmit_HD(4'b0100, "--");
            reset_tx();
            transmit_6G(4'b1101, "6GB", "--");
            reset_tx();
            transmit_SD(4'b0000);
            reset_tx();
            transmit_3G(4'b1100, "3GA", "--");
            reset_tx();
            transmit_HD(4'b1010, "--");
            reset_tx();
            transmit_3G(4'b1000, "3GB", "DL");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_HD(4'b1011, "--");
            reset_tx();
            transmit_SD(4'b0000);
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");

        //-------------------------------------------------------
        // Multi rate (Just to run 5 supported standards)
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "half") begin
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GB", "--");
            reset_tx();
            transmit_3G(4'b1100, "3GA", "--");
            reset_tx();
            transmit_HD(4'b1011, "--");
            reset_tx();
            transmit_SD(4'b0000);

        //-------------------------------------------------------
        // Triple rate full sequence
        //-------------------------------------------------------
        end else if (mode_tr & TEST_RECONFIG_SEQ == "full") begin
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_3G(4'b1101, "3GB", "DL");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");

        //-------------------------------------------------------
        // 12GA to 6GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GA6G") begin
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");

        //-------------------------------------------------------
        // 12GB to 6GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GB6G") begin
            transmit_12G(4'b1101, "12GB", "DL");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_12G(4'b1101, "12GB", "DL");

        //-------------------------------------------------------
        // 12GA to 3GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GA3G") begin
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");

        //-------------------------------------------------------
        // 12GB to 3GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GB3G") begin
            transmit_12G(4'b1101, "12GB", "DL");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_12G(4'b1101, "12GB", "DL");

        //-------------------------------------------------------
        // 12GA to HD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GAHD") begin
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");

        //-------------------------------------------------------
        // 12GB to HD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GBHD") begin
            transmit_12G(4'b1101, "12GB", "DL");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_12G(4'b1101, "12GB", "DL");

        //-------------------------------------------------------
        // 12GA to SD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GASD") begin
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");

        //-------------------------------------------------------
        // 12GB to SD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GBSD") begin
            transmit_12G(4'b1101, "12GB", "DL");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_12G(4'b1101, "12GB", "DL");

        //-------------------------------------------------------
        // 6GA to 12GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GA12G") begin
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");

        //-------------------------------------------------------
        // 6GB to 12GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GB12G") begin
            transmit_6G(4'b1101, "6GB", "--");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GB", "--");

        //-------------------------------------------------------
        // 6GA to 3GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GA3G") begin
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");

        //-------------------------------------------------------
        // 6GB to 3GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GB3G") begin
            transmit_6G(4'b1101, "6GB", "--");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GB", "--");

        //-------------------------------------------------------
        // 6GA to HD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GAHD") begin
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");

        //-------------------------------------------------------
        // 6GB to HD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GBHD") begin
            transmit_6G(4'b1101, "6GB", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_6G(4'b1101, "6GB", "--");

        //-------------------------------------------------------
        // 6GA to SD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GASD") begin
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");

        //-------------------------------------------------------
        // 6GB to SD
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GBSD") begin
            transmit_6G(4'b1101, "6GB", "--");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_6G(4'b1101, "6GB", "--");

        //-------------------------------------------------------
        // 3GA to 12GA
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "3GA12G") begin
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
        
        //-------------------------------------------------------
        // 3GB to 12GA
        //------------------------------------------------------- 
        end else if (mode_mr & TEST_RECONFIG_SEQ == "3GB12G") begin
            transmit_3G(4'b1101, "3GB", "DL");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_3G(4'b1101, "3GB", "DL");
        //-------------------------------------------------------
        // 3GA to 6GA
        //------------------------------------------------------- 
        end else if (mode_mr & TEST_RECONFIG_SEQ == "3GA6G") begin
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
        //-------------------------------------------------------
        // 3GB to 6GA
        //------------------------------------------------------- 
        end else if (mode_mr & TEST_RECONFIG_SEQ == "3GB6G") begin
            transmit_3G(4'b1101, "3GB", "DL");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_3G(4'b1101, "3GB", "DL");
        //-------------------------------------------------------
        // HD to 12GA
        //------------------------------------------------------- 
        end else if (mode_mr & TEST_RECONFIG_SEQ == "HD12G") begin
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
        //-------------------------------------------------------
        // HD to 6GA
        //------------------------------------------------------- 
        end else if (mode_mr & TEST_RECONFIG_SEQ == "HD6G") begin
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
        //-------------------------------------------------------
        // SD to 12GA
        //------------------------------------------------------- 
        end else if (mode_mr & TEST_RECONFIG_SEQ == "SD12G") begin
            transmit_SD(4'b0001);
            reset_tx(); 
            transmit_12G(4'b1101, "12GA", "--");
            reset_tx();
            transmit_SD(4'b0001);
        //-------------------------------------------------------
        // SD to 6GA
        //------------------------------------------------------- 
        end else if (mode_mr & TEST_RECONFIG_SEQ == "SD6G") begin
            transmit_SD(4'b0001);
            reset_tx(); 
            transmit_6G(4'b1101, "6GA", "--");
            reset_tx();
            transmit_SD(4'b0001);
        //-------------------------------------------------------
        // 3GA to HD
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "3GAHD" & (mode_mr | mode_tr) ) begin
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");

        //-------------------------------------------------------
        // 3GB to HD
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "3GBHD" & (mode_mr | mode_tr) ) begin
            transmit_3G(4'b1101, "3GB", "DL");
            reset_tx();
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_3G(4'b1101, "3GB", "DL");

        //-------------------------------------------------------
        // 3GA to SD
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "3GASD" & (mode_mr | mode_tr) ) begin
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");

        //-------------------------------------------------------
        // 3GB to SD
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "3GBSD" & (mode_mr | mode_tr) ) begin
            transmit_3G(4'b1101, "3GB", "DL");
            reset_tx();
            transmit_SD(4'b0001);
            reset_tx();
            transmit_3G(4'b1101, "3GB", "DL");

        //-------------------------------------------------------
        // HD to 3GA
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "HD3G" & (mode_mr | mode_tr) ) begin
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_HD(4'b0101, "--");

        //-------------------------------------------------------
        // SD to 3GA
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "SD3G" & (mode_mr | mode_tr) ) begin
            transmit_SD(4'b0001);
            reset_tx(); 
            transmit_3G(4'b1101, "3GA", "--");
            reset_tx();
            transmit_SD(4'b0001);

        //-------------------------------------------------------
        // HD to SD
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "HDSD" & (mode_mr | mode_tr | mode_ds) ) begin
            transmit_HD(4'b0101, "--");
            reset_tx(); 
            transmit_SD(4'b0001);
            reset_tx(); 
            transmit_HD(4'b0101, "--");

        //-------------------------------------------------------
        // SD to HD
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "SDHD" & (mode_mr | mode_tr | mode_ds) ) begin
            transmit_SD(4'b0001);
            reset_tx(); 
            transmit_HD(4'b0101, "--");
            reset_tx();
            transmit_SD(4'b0001);

        //-------------------------------------------------------
        // 12GA 
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GA") begin
            transmit_12G(4'b1101, "12GA", "--");

        //-------------------------------------------------------
        // 12GB 
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "12GB") begin
            transmit_12G(4'b1101, "12GB", "DL");

        //-------------------------------------------------------
        // 6GA 
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GA") begin
            transmit_6G(4'b1101, "6GA", "--");

        //-------------------------------------------------------
        // 6GB 
        //-------------------------------------------------------
        end else if (mode_mr & TEST_RECONFIG_SEQ == "6GB") begin
            transmit_6G(4'b1101, "6GB", "--");

        //-------------------------------------------------------
        // 3GA 
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "3GA" & (mode_mr | mode_tr | mode_3g) ) begin
            transmit_3G(4'b1101, "3GA", "--");

        //-------------------------------------------------------
        // 3GB
        //-------------------------------------------------------
        end else if (TEST_RECONFIG_SEQ == "3GB" & (mode_mr | mode_tr | mode_3g) ) begin
            transmit_3G(4'b1101, "3GB", "DL");

        //-------------------------------------------------------
        // HD Dual Link
        //-------------------------------------------------------
        end else if (mode_dl) begin    
            transmit_HD(4'b1100, "DL");

        //-------------------------------------------------------
        // HD
        //-------------------------------------------------------
        end else if (mode_hd | (TEST_RECONFIG_SEQ == "HD" & (mode_mr | mode_tr | mode_ds))) begin
            transmit_HD(4'b0101, "--");

        //-------------------------------------------------------
        // SD
        //-------------------------------------------------------
        end else if (mode_sd | (TEST_RECONFIG_SEQ == "SD" & (mode_mr | mode_tr | mode_ds)) ) begin
            transmit_SD(4'b0001);
        end
end
endtask



