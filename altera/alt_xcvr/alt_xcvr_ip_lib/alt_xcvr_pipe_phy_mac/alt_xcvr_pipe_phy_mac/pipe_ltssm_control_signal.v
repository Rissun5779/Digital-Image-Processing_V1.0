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


module pipe_ltssm_control_signal #(
  parameter           max_rate = "gen2" 
) 
(
  input               pclk,
  input               reset,
  input [3:0]         state,
  input [3:0]         comply_count,
  input               detect_polarity,
  output reg          tx_detectrx,
  output reg          tx_elecidle,
  output reg          tx_swing,
  output reg          rx_polarity,
  output reg [1:0]    rx_preset_hint,
  output reg [1:0]    powerdown,
  output reg [1:0]    rate,
  output reg [1:0]    tx_margin,
  output reg [17:0]   tx_deemphasis,
  output reg [1:0]    send_ts,
  output reg          send_data
);

//state decode
localparam [3:0]  SM_RESET_IDLE            = 4'd0,
                  SM_DETECT_QUIET          = 4'd1,
                  SM_DETECT_ACTIVE         = 4'd2,
                  SM_POWER_P0              = 4'd3,
                  SM_POLLING_ACTIVE        = 4'd4,
                  SM_POLLING_COMPLIANCE    = 4'd5,
                  SM_EXIT_POLLING_COMPLY   = 4'd6,
                  SM_POLLING_CONFIG        = 4'd7,
                  SM_L0                    = 4'd8,
                  SM_CHANGE_RATE           = 4'd9,
                  SM_RATE_TIMEOUT          = 4'd10,
                  SM_RATE                  = 4'd11,
                  SM_RECOVERY_RCVR         = 4'd12,
                  SM_RECOVERY_CONFIG       = 4'd13,
                  SM_POWER_P1              = 4'd14;

//Registers for driving the various control signals
//All data signals (tx_data, tx_datak, tx_compliance, tx_dataskip, tx_blkstart, tx_sync_hdr,
//rx_data, rx_datak, rx_dataskip, rx_blkstart, rx_synchdr, rx_valid and rx_status) are 
//are handled by the data block.
reg [1:0]  next_rate;
reg        buffer_polarity;
wire [1:0] gen_max_rate;

//determin the max rate based upon the parameter
assign gen_max_rate = (max_rate == "gen3") ? 2'b10 :
                      (max_rate == "gen2") ? 2'b01 :
                      (max_rate == "gen1") ? 2'b00 : 2'b00;


always@(posedge pclk or posedge reset)
begin
  if(reset == 1'b1) begin
    //Set starting values for various control signals
    tx_detectrx     <= 1'b0;  
    powerdown       <= 2'b10; 
    tx_elecidle     <= 1'b1;  
    rx_polarity     <= 1'b0;  
    buffer_polarity <= 1'b0;
    rate            <= 2'b0;  
    next_rate       <= 2'b0;  
    rx_preset_hint  <= 2'b0;  
    send_data       <= 1'b0;
    send_ts         <= 2'b0;
    tx_deemphasis   <= 18'd1;
  end else begin
    case (state) 
      SM_RESET_IDLE:          begin
                                tx_detectrx     <= 1'b0;  
                                powerdown       <= 2'b10; 
                                tx_elecidle     <= 1'b1;  
                                rx_polarity     <= 1'b0;  
                                buffer_polarity <= 1'b0;
                                rate            <= 2'b0;  
                                next_rate       <= 2'b0;  
                                rx_preset_hint  <= 2'b0;  
                                send_data       <= 1'b0;
                                send_ts         <= 2'b0;
                                tx_deemphasis   <= 18'd1;
                              end

                              //Deassert tx_detectrx to allow the line to discharge
      SM_DETECT_QUIET:        begin
                               tx_detectrx <= 1'b0;
                              end
                          
      SM_DETECT_ACTIVE:       begin
                                tx_detectrx <= 1'b1;
                              end

                              //deassert tx_detectrx and change the powerstate
      SM_POWER_P0:            begin
                                tx_detectrx <= 1'b0;
                                powerdown   <= 2'b00;
                              end

                              //Send Data and deassert tx electical Idle.  Also buffers the value of polarity. During this state
                              //polarity is determined, and if the analog p and n are reversed, then polarity will be asserted.  
                              //If this is the case, then buffer the value, so that when we enter polling_configuration we can assert
                              //it.  If we used the value of polarity from the data checker, then when the normal polarity is found
                              //the polarity flag will deassert, which will turn off polarity on the next cycle.  Essentially, the detect_polarity
                              //indicate that there is polarity, and an action should be taken to rectify this.
      SM_POLLING_ACTIVE:      begin
                                send_ts         <= 2'b01;
                                send_data       <= 1'b0;
                                tx_elecidle     <= 1'b0;
                                buffer_polarity <= detect_polarity;
                              end

      SM_POLLING_COMPLIANCE:  begin
                                //depending on the compliance counter, change the rate and the various tap settings.
                                send_ts       <= 2'b11;
                                send_data     <= 1'b0;
                                tx_elecidle   <= 1'b0;
                                next_rate     <= (comply_count == 4'b0) ? 2'b00 :
                                                ((comply_count > 4'b0 && comply_count < 4'd3) ? 2'b01 : 2'b10);
                                tx_deemphasis <= (comply_count <= 4'd1) ? 18'b1 :
                                                ((comply_count == 4'd2) ? 18'b10 :
                                                ((comply_count == 4'd3) ? 18'b11 :
                                                ((comply_count == 4'd4) ? 18'b100 :
                                                ((comply_count == 4'd5) ? 18'b101 :
                                                ((comply_count == 4'd6) ? 18'b110 :
                                                ((comply_count == 4'd7) ? 18'b111 :
                                                ((comply_count == 4'd8) ? 18'b1000 :
                                                ((comply_count == 4'd9) ? 18'b1001 :
                                                ((comply_count == 4'd10) ? 18'b1010 :
                                                ((comply_count == 4'd11) ? 18'b1011 :
                                                ((comply_count == 4'd12) ? 18'b1100 :
                                                ((comply_count == 4'd13) ? 18'b1101 :
                                                ((comply_count == 4'd14) ? 18'b1110 : 18'b1111)))))))))))));
                              end

                              //Return the rate back to gen 1 and put the transceiver into electical idle for at least 1ms
      SM_EXIT_POLLING_COMPLY: begin
                                next_rate   <= 2'b00;
                                if(rate == 2'b00) begin
                                  send_data <= 1'b0;
                                  send_ts   <= 2'b0;
                                end
                              end
                                
                              //Assert the polarity to the phy and start transmitting ts2 sequences
      SM_POLLING_CONFIG:      begin
                                send_data   <= 1'b0;
                                send_ts     <= 2'b10;
                                rx_polarity <= buffer_polarity;
                                tx_elecidle <= 1'b0;
                              end

                              //Sends a data pattern to be checked for errors. In the future, this will also produce a BER
      SM_L0:                  begin
                                if (rate == gen_max_rate) begin
                                  next_rate   <= 2'b00;
                                end else begin
                                  next_rate   <= rate + 1'b1;
                                end
                                send_data   <= 1'b1;
                                send_ts     <= 2'b00;
                                tx_elecidle <= 1'b0;
                              end

                              //Stops Sending all Data Types, which indicates to the Data generator to stop sending Data, and transmit EIOS
      SM_CHANGE_RATE:         begin
                                send_data   <= 1'b0;
                                send_ts     <= 2'b00;
                                tx_elecidle <= 1'b0;
                                rate        <= rate;
                              end

                              //Assert Electical Idle, and wait for the 1ms Timeout
      SM_RATE_TIMEOUT:        begin
                                send_data   <= 1'b0;
                                send_ts     <= 2'b00;
                                tx_elecidle <= 1'b1;
                                rate        <= rate;
                              end

                              //Change Rates
      SM_RATE:                begin
                                send_data   <= 1'b0;
                                send_ts     <= 2'b00;
                                tx_elecidle <= 1'b1;
                                rate <= next_rate;
                              end

      SM_RECOVERY_RCVR:       begin
                                tx_elecidle <= 1'b0;
                                send_ts     <= 2'b01;
                              end
                                
      SM_RECOVERY_CONFIG:     begin
                                tx_elecidle <= 1'b0;
                                send_ts     <= 2'b10;
                              end

                              //Powerdown the transceiver
      SM_POWER_P1:           begin
                                tx_elecidle <= 1'b1;
                                powerdown   <= 2'b10;
                              end

      default:                begin
                              end
    endcase
  end
end

endmodule
