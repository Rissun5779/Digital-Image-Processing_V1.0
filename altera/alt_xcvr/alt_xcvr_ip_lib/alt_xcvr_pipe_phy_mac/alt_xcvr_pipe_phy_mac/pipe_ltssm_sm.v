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


module pipe_ltssm_sm #(
  parameter mode          = "auto",
  parameter max_rate      = "gen2",
  parameter pld_if_dw     = 16,
  parameter fast_sim      = "true",
  parameter compliance    = "false"
) 
(
  input            pclk,
  input            reset,
  input            rx_status,
  input            rx_elecidle,
  input            phy_status,
  input            data_valid,
  input [1:0]      ts_complete,
  input            data_complete,
  input            polarity,
  input [1:0]      rate,
  input            ext_control,
  input            rx_infer_elecidle,
  output reg       recovery,
  output reg       link_active,
  output reg [3:0] state,
  output reg [3:0] comply_count 
);

reg  [3:0]  prev_state;
reg [22:0]  timeout_counter;
wire        force_elecidle;
wire        manual;
wire        change_data;
wire        wait_12ms_done;
wire        wait_24ms_done;
wire        wait_1ms_done;
wire        wait_counter_done;
wire [1:0]  gen_max_rate;
wire [3:0]  comply_count_reset;
wire [22:0] twelve_counter;
wire [22:0] twentyfour_counter;
wire [22:0] one_counter;
wire [22:0] timeout_counter_compare;

//Declare the States of the stripped down ltssm
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

assign manual = (mode == "manual")? 1'b1 : 1'b0;

//forces electical idle to enter compliance.
assign force_elecidle = (compliance == "true") ? 1'b1 : 1'b0;

//Assign wait_counter_done based upon the value of the timeout and the timeout counter
assign wait_counter_done = (timeout_counter >= timeout_counter_compare);

//selects a max rate based upon what gen the device is capable of.
assign gen_max_rate = (max_rate == "gen3") ? 2'b10 :
                      (max_rate == "gen2") ? 2'b01 :
                      (max_rate == "gen1") ? 2'b00 : 2'b00;

//changes what the timeout value is based upon the state.
assign timeout_counter_compare = (state == SM_POLLING_ACTIVE || state == SM_L0) ? twentyfour_counter : one_counter;
                                //((state == SM_EXIT_POLLING_COMPLY || state == SM_RATE_TIMEOUT) ? one_counter : twelve_counter);

//wait_counter_done is asserted, however since only one counter is used with a variable timeout value
//the assertion of this signal needs to be associated with a particular state.
assign wait_12ms_done = (state == SM_DETECT_QUIET || state == SM_DETECT_ACTIVE)       ? wait_counter_done : 1'b0;
assign wait_24ms_done = (state == SM_POLLING_ACTIVE || state == SM_L0)                ? wait_counter_done : 1'b0;
assign wait_1ms_done  = (state == SM_EXIT_POLLING_COMPLY || state == SM_RATE_TIMEOUT) ? wait_counter_done : 1'b0;

//changes the number of compliance configuration that can be iterated through
assign comply_count_reset = (gen_max_rate == 2'b10) ? 4'd14 :
                           ((gen_max_rate == 2'b01) ? 4'd2 : 4'd0);

//For simulation, timeout the L0 State after a set time limit.  In Hardware, only change data rates on push-button
assign change_data        = (fast_sim == "true") ? wait_24ms_done : ext_control;

//a timeout to count for 12ms.  Also distinction between varying pclk frequencies and fast_sim
assign twelve_counter = (fast_sim == "true") ? ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd1500 :
                                               ((max_rate == "gen3" && rate == 2'b00) ? 23'd750 : 23'd3000)) :
                                               ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd1500000 :
                                               ((max_rate == "gen3" && rate == 2'b00) ? 23'd750000 : 23'd3000000));

//a timeout to count for 24 ms.  Also distinction between varying pclk frequencies and fast_sim
assign twentyfour_counter = (fast_sim == "true") ? ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd3000 :
                                                   ((max_rate == "gen3" && rate == 2'b00) ? 23'd1500 : 23'd6000)) :
                                                   ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd3000000 :
                                                   ((max_rate == "gen3" && rate == 2'b00) ? 23'd1500000 : 23'd6000000));

//timeout to count for 1 ms.  Also distinction between varying pclk frequencies and fast_sim
assign one_counter = (fast_sim == "true") ? ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd1250 :
                                            ((max_rate == "gen3" && rate == 2'b00) ? 23'd625 : 23'd2500)) :
                                            ((max_rate == "gen2" && rate == 2'b00 || max_rate == "gen3" && rate == 2'b01 || pld_if_dw == 16 && max_rate == "gen1") ?   23'd125000 :
                                            ((max_rate == "gen3" && rate == 2'b00) ? 23'd62500 : 23'd250000));

always@(posedge pclk or posedge reset)
begin
  if(reset == 1'b1)
  begin
    state           <= SM_RESET_IDLE;
    link_active     <= 1'b0;
    recovery        <= 1'b0;
    prev_state      <= 4'b0;
  end else begin
    state <= state;
    case (state)
      //rx_elecidle is asynchronou.  Check other status signals for asynchronous
      //All control signals needs to be driven from flop, not through muxes or logic
      //spyglass
      SM_RESET_IDLE:          begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_DETECT_QUIET;
                                    prev_state  <= state;
                                  end
                                end else begin
                                  if(!phy_status && !link_active) begin
                                    state       <= SM_DETECT_QUIET;
                                    prev_state  <= state;
                                  end
                                end
                              end

                              //transtion based off timer, to allow the line to discharge.
      SM_DETECT_QUIET:        begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_DETECT_ACTIVE;
                                    prev_state  <= state;
                                  end
                                end else begin
                                  if(wait_12ms_done) begin
                                    state       <= SM_DETECT_ACTIVE;
                                    prev_state  <= state;
                                  end
                                end
                              end

      SM_DETECT_ACTIVE:       begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_POWER_P0;
                                    prev_state  <= state;
                                  end
                                end else begin
                                  //If phy_status is asserted, and the rx_status indicates a reciever is present,
                                  //go to an intermediate power transition state
                                  if((phy_status && rx_status) || (force_elecidle == 1'b1)) begin
                                    state       <= SM_POWER_P0;
                                    prev_state  <= state;

                                  //if after 12ms, phy_status and rx_status havn't asserted, go back to detect active
                                  //to give the line time to discharge
                                  end else if(wait_12ms_done) begin
                                    state       <= SM_DETECT_QUIET;
                                    prev_state  <= state;
                                  end
                                end
                              end

      SM_POWER_P0:            begin
                                //intermediate state for transitioning power.  Qualifies the phy_status signal
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_POLLING_ACTIVE;
                                    prev_state  <= state;
                                  end
                                end else begin
                                  if(phy_status) begin
                                    state       <= SM_POLLING_ACTIVE;
                                    prev_state  <= state;
                                  end
                                end
                              end

      SM_POLLING_ACTIVE:      begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    if(force_elecidle == 1'b1) begin
                                      state       <= SM_POLLING_COMPLIANCE;
                                      prev_state  <= state;
                                    end else begin
                                      state       <= SM_POLLING_CONFIG;
                                      prev_state  <= state;
                                    end
                                  end
                                end else begin
                                  //If the transceiver never leaves rx_elecidle after 24ms, or we are forced in electical idle,
                                  //transition into polling compliance.  
                                  if((rx_elecidle && wait_24ms_done) || force_elecidle) begin
                                    state       <= SM_POLLING_COMPLIANCE;
                                    prev_state  <= state;

                                  //Else, if we receiver 8-ts1 ordered sets, and at least 1024
                                  //training sequences have been transmitted go to polling compliance
                                  end else if(data_valid && ts_complete == 2'b01) begin
                                    state       <= SM_POLLING_CONFIG;
                                    prev_state  <= state;
                                  end
                                end
                              end 

      SM_POLLING_COMPLIANCE:  begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    if(!force_elecidle) begin
                                      state       <= SM_EXIT_POLLING_COMPLY;
                                      prev_state  <= state;
                                    end else if(comply_count == 4'd1 || rate != 2'b10 && comply_count == 4'd3 || (rate == !2'b00 && comply_count == 2'b00)) begin
                                      state       <= SM_CHANGE_RATE;
                                      prev_state  <= state;
                                    end
                                  end
                                end else begin
                                  //In polling compliance, if the transceiver leaves electical idle, exit polling compliance
                                  if(!rx_elecidle && ~force_elecidle) begin
                                    state       <= SM_EXIT_POLLING_COMPLY;
                                    prev_state  <= state;

                                  //If we are gen 3, go through all 14 different compliance states.  In gen 2, go through the first 3 and 
                                  //in gen 1, stay in the only compliance state. Previous_state is used here to allow the change_rate state 
                                  //to return to the state that called it.  During this state, evertime a ext_control is asserted, a counter
                                  //is incremented, changing the rate and de-emphasis as appropriate.
                                  end else if(comply_count == 4'd1 || rate != 2'b10 && comply_count == 4'd3 || (rate == !2'b00 && comply_count == 2'b00)) begin
                                    state       <= SM_CHANGE_RATE;
                                    prev_state  <= state;
                                  end
                                end
                              end

      SM_EXIT_POLLING_COMPLY: begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    if(rate != 2'b00) begin
                                      state       <= SM_CHANGE_RATE;
                                      prev_state  <= state;
                                    end else begin
                                      state       <= SM_POLLING_ACTIVE;
                                      prev_state  <= state;
                                    end
                                  end
                                end else begin
                                  //If we are not operating at gen1 speeds, then go to rate to configure to gen1
                                  if(rate != 2'b00) begin
                                    state       <= SM_CHANGE_RATE;
                                    prev_state  <= SM_POLLING_ACTIVE;

                                  //If rate is gen 1, then wait one milisecond before transitioning into polling_active
                                  end else if(wait_1ms_done) begin
                                    state       <= SM_POLLING_ACTIVE;
                                    prev_state  <= state;
                                  end
                                end
                              end

                                  //possibly send loopback
                                  //look for ts2 which implys we need to send ts2
      SM_POLLING_CONFIG:      begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_L0;
                                    prev_state  <= state;
                                  end
                                end else begin
                                  if(data_valid && ts_complete == 2'b10 && !polarity) begin
                                    state       <= SM_L0;
                                    prev_state  <= state;
                                  end
                                end
                              end

      SM_L0:                  begin
                                recovery          <= 1'b1;
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    if(rate == gen_max_rate) begin
                                      state       <= SM_POWER_P1;
                                      prev_state  <= state;
                                    end else begin
                                      state       <= SM_CHANGE_RATE;
                                      prev_state  <= SM_RECOVERY_RCVR;
                                    end
                                  end
                                end else begin
                                  //if data is done being sent, then check whether to switch rates, or powerdown
                                  if(change_data && data_valid) begin
                                    //if we operating at the max rate of the configuration, then powerdown
                                    if(rate == gen_max_rate) begin
                                    //  state       <= SM_POWER_P1;
                                    //  prev_state  <= state;
                                      state       <= SM_CHANGE_RATE;
                                      prev_state  <= SM_POWER_P1;

                                    //If we are not at the max rate, then increase the rate
                                    end else begin
                                      state       <= SM_CHANGE_RATE;
                                      prev_state  <= SM_RECOVERY_RCVR;
                                    end
                                  end
                                end
                              end

                              //Does not adhere to any particular state in the LTSSM.  It simply changes the rate to the value of next_rate (check ltssm_control_signal.v
                              //simply because several states can call this function, and each has a different value of what the next state should be.  After phy_status asserts
                              //indicating that the rate has been changed, the fsm will return to the previous state.
      SM_CHANGE_RATE:         begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_RATE_TIMEOUT;
                                  end
                                end else begin
                                  if(data_complete == 1'b1) begin
                                    state       <= SM_RATE_TIMEOUT;
                                  end
                                end
                              end

      SM_RATE_TIMEOUT:        begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_RATE;
                                  end
                                end else begin
                                  if(rx_infer_elecidle == 1'b1 && wait_1ms_done == 1'b1) begin
                                    state       <= SM_RATE;
                                  end
                                end
                              end

      SM_RATE:                begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= prev_state;
                                    prev_state  <= state;
                                  end
                                end else begin
                                  if(phy_status || (max_rate == "gen1")) begin
                                    state       <= prev_state;
                                    prev_state  <= state;
                                  end
                                end
                              end

      SM_RECOVERY_RCVR:       begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_RECOVERY_CONFIG;
                                  end
                                end else begin
                                  if(data_valid && ts_complete == 2'b01) begin
                                    state       <= SM_RECOVERY_CONFIG;
                                  end
                                end
                              end
                                
      SM_RECOVERY_CONFIG:     begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_L0;
                                  end
                                end else begin
                                  if(data_valid && ts_complete == 2'b10) begin
                                    state       <= SM_L0;
                                  end
                                end
                              end

                              //Powers down the transceiver.  After phy_status asserts, will return to idle to allow the user to go through the sequnece again
      SM_POWER_P1:            begin
                                if(manual == 1'b1) begin
                                  if(ext_control == 1'b1) begin
                                    state       <= SM_RESET_IDLE;
                                    link_active <= 1'b1;
                                  end
                                end else begin
                                  if(phy_status) begin
                                    state       <= SM_RESET_IDLE;
                                    link_active <= 1'b1;
                                  end
                                end
                              end

      default:                begin
                                state <= SM_RESET_IDLE;
                              end
    endcase
  end
end

//A generic counter.  The value for the comparison is determined by which state we are in.  
always@(posedge pclk or posedge reset) begin
  if(reset) begin
    timeout_counter   <= 23'b0;
  //If the counter has passed the timeout, then assert the counter done, and reset the counter
  end else if(wait_counter_done) begin
    timeout_counter   <= 23'b0;
  //if we are in one of the states, then increment the timeout counter
  end else if(state == SM_DETECT_QUIET || state == SM_DETECT_ACTIVE || state == SM_POLLING_ACTIVE || state == SM_EXIT_POLLING_COMPLY || state == SM_RATE_TIMEOUT || state == SM_L0) begin
    timeout_counter   <= timeout_counter + 1'b1;
  //If we are not in one of the states, reset leave the counter value at 0
  end else begin
    timeout_counter   <= 23'b0;
  end
end

//A counter for iterating through the various compliance patterns and rates
always@(posedge pclk or posedge reset) begin
  if(reset == 1'b1) begin
    comply_count    <= 4'b0;

  //If we are in Polling Active, then reset the compliance counter
  end else if(state == SM_POLLING_ACTIVE || state == SM_EXIT_POLLING_COMPLY) begin
    comply_count    <= 4'b0;

  //if there is an external control, and we are in the compliance state, then increment through the different compliance modes
  end else if(ext_control && state == SM_POLLING_COMPLIANCE) begin
    //Depending on the max rate, there is a different number of compliance patterns.  The condition sets the max compliance counter value
    if(comply_count == comply_count_reset) begin
      comply_count <= 4'b0;
    end else begin
      comply_count <= comply_count + 1'b1;
    end
  end else begin
    comply_count <= comply_count;
  end
end

endmodule
