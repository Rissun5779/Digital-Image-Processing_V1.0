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


module pipe_ltssm_adapter #(
  parameter max_rate        = "gen2", 
  parameter lanes           = 1, 
  parameter phy_control     = "mac"
) (
  input                  pclk,
  input                  reset,

  //input control signals from the control block
  input                  cs_tx_detectrx,
  input                  cs_tx_elecidle,
  input                  cs_tx_swing,
  input                  cs_rx_polarity,
  input [1:0]            cs_preset_hint,
  input [1:0]            cs_powerdown,
  input [1:0]            cs_rate,
  input [1:0]            cs_tx_margin,
  input [17:0]           cs_tx_deemphasis,

  //inputs signals from the top-level wrapper for unit-test like control
  input                  top_tx_detectrx,
  input                  top_tx_elecidle,
  input                  top_tx_swing,
  input                  top_rx_polarity,
  input [1:0]            top_preset_hint,
  input [1:0]            top_powerdown,
  input [1:0]            top_rate,
  input [1:0]            top_tx_margin,
  input [17:0]           top_tx_deemphasis,

  //input signals from the PHY
  input [lanes-1:0]      phy_phy_status,
  input [lanes-1:0]      phy_rx_elecidle,
  input [lanes-1:0]      phy_data_valid,
  input [lanes*3-1:0]    phy_rx_status,

  //inputs signals from the Data Generator
  input [1:0]            ts_complete,

  //input data_complete,
  input [lanes-1:0]      data_polarity,

  //output signals to the LTSSM
  output                 phy_status,
  output                 rx_elecidle,
  output                 data_valid,
  output                 rx_status,
  output                 polarity,

  //output polarity signal to the PHY
  output reg [lanes-1:0]     phy_rx_polarity,
  output reg [lanes-1:0]     phy_tx_detectrx,
  output reg [lanes-1:0]     phy_tx_elecidle,
  output reg [lanes-1:0]     phy_tx_swing,
  output reg [lanes*2-1:0]   phy_rx_preset_hint,
  output reg [lanes*2-1:0]   phy_powerdown,
  output reg [lanes*2-1:0]   phy_rate,
  output reg [lanes*2-1:0]   phy_tx_margin,
  output reg [lanes*18-1:0]  phy_tx_deemphasis
);

//local registers for synchronizing control signals accross channels
reg [lanes-1:0] phy_status_latch;
reg [lanes-1:0] elecidle_latch;
reg [lanes-1:0] data_valid_latch;
reg [lanes-1:0] rx_status_latch;
reg [lanes-1:0] rx_polarity;

//integers and wires for various for-loops and generates
integer i;
wire sm_control;
wire gen3_deemphasis;

//Assign the polarity flag if any of the data polarity bits were set
//This is a loop, but it is staged to synchronize the assertion of the polarity bits
//with the state.  the local reg for polarity gets set once the data
//is finished. This asserts the control signal to the two ltssms, and sets the
//begin polarity signal in the control signal ltssm back to the phy, which sets the phy
//polarity
assign polarity = (|rx_polarity);
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    rx_polarity <= {lanes{1'b0}};
    phy_rx_polarity <= {lanes{1'b0}};
  end else begin
    if(cs_rx_polarity == 1'b1) begin
      phy_rx_polarity <= (phy_rx_polarity | rx_polarity);
    end
    if(ts_complete == 2'b00) begin
      rx_polarity <= data_polarity;
    end
  end
end

//Sets phy_status when all the bits in the local reg get set.  As soon as phy_status is asserted
//the reg gets reset.  It will recycle the individual bits of the phy_status until all are set.
assign phy_status = (&phy_status_latch);
always@(posedge pclk or posedge reset) begin
  if (reset == 1'b1) begin
    phy_status_latch <= {lanes{1'b1}};
  end else begin
    if((|phy_phy_status) == 1'b0) begin
      phy_status_latch <= {lanes{1'b0}};
    end else begin
      for(i = 0; i<lanes; i=i+1) begin
        phy_status_latch[i] <= (phy_phy_status[i] || phy_status_latch[i]);
      end
    end
  end
end

//when all bits of electical idle go low, deassert electrical idle
assign rx_elecidle = (|elecidle_latch);
always@(posedge pclk or posedge reset) begin
  if (reset == 1'b1) begin
    elecidle_latch <= {lanes{1'b0}};
  end else begin
    elecidle_latch <= phy_rx_elecidle;
  end
end

//when all channels are receiving valid data, assert valid data high
assign data_valid = (&data_valid_latch);
always@(posedge pclk or posedge reset) begin
  if (reset == 1'b1) begin
    data_valid_latch <= {lanes{1'b0}};
  end else begin
    data_valid_latch <= phy_data_valid;
  end
end

//checks each channel's rx_status for the receiver detect.  If a receiver is detected, it will set
//the bit for that reg to 1'b1, so signify that there is a channel.  These bits get or'd together
//to produce one signal signifing that all channels detected a receiver
assign rx_status = (&rx_status_latch);
always@(posedge pclk or posedge reset) begin
  if (reset == 1'b1) begin
    rx_status_latch<= {lanes{1'b0}};
  end else begin
    for(i = 0; i<lanes; i=i+1) begin
      rx_status_latch[i] <= ((phy_rx_status[i*3+:3] == 3'b011) || rx_status_latch[i]);
    end
  end
end

//Loops to assign all the signals.  If thy phy control is set to ltssm, the control
//signals will be assigned from the top wrapper, which provides unit-test like control 
//over the phy in hardware
assign sm_control = (phy_control == "mac") ? 1'b1 : 1'b0;
always@(*) begin
  for (i=0; i<lanes; i=i+1) begin
    phy_tx_detectrx[i]           = (sm_control == 1'b1) ? cs_tx_detectrx   : top_tx_detectrx;
    phy_tx_elecidle[i]           = (sm_control == 1'b1) ? cs_tx_elecidle   : top_tx_elecidle;
    phy_tx_swing[i]              = (sm_control == 1'b1) ? cs_tx_swing      : top_tx_swing;
    phy_rx_preset_hint[i*2+:2]   = (sm_control == 1'b1) ? cs_preset_hint   : top_preset_hint;
    phy_powerdown[i*2+:2]        = (sm_control == 1'b1) ? cs_powerdown     : top_powerdown;
    phy_rate[i*2+:2]             = (sm_control == 1'b1) ? cs_rate          : top_rate;
    phy_tx_margin[i*2+:2]        = (sm_control == 1'b1) ? cs_tx_margin     : top_tx_margin;
    phy_tx_deemphasis[i*18+:18]  = (max_rate == "gen3") ? ((sm_control == 1'b1) ? cs_tx_deemphasis : top_tx_deemphasis) :
                                                          ((sm_control == 1'b1) ? cs_tx_deemphasis : top_tx_deemphasis);
  end
end

endmodule
