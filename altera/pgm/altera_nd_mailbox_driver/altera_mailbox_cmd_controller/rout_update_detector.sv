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


// +-----------------------------------------------------------
// | ROUT update dectector: check in the last 100 cycles
// |                        is there any activity in ROUT update  
// +-----------------------------------------------------------
module  rout_update_detector
# (
   parameter  COUNTING_CYCLE = 100
)
   (
    input  clk,
    input  reset,
 
    input  rout_upt_req,
    output rout_chng_within_last_100_cycles
     
);

    reg [6 : 0] cnt;
    reg         rout_chng;
    reg         rout_chng_int;
    reg         rout_chng_when_cnt_reaches;
    wire [6 : 0] cnt_max;
    
    assign cnt_max  = COUNTING_CYCLE[6:0];
    
    always_ff @(posedge clk) begin
        if (reset) begin
            cnt <= '0;
        end else begin
            if ((cnt == cnt_max) || (rout_upt_req))
                cnt <= 0;
            else
                cnt <= cnt + 7'h1;
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            rout_chng_int <= '0;
        end else begin
            if (cnt != cnt_max) begin
                if (rout_upt_req)
                    rout_chng_int <= '1;
            end else
                rout_chng_int <= '0;
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            rout_chng_when_cnt_reaches <= '0;
        end else begin
            if (cnt == cnt_max) begin
                if (rout_upt_req)
                    rout_chng_when_cnt_reaches <= '1;
                else
                    rout_chng_when_cnt_reaches <= '0;
            end
        end // else: !if(reset)
    end // always_ff @
    

    assign rout_chng_within_last_100_cycles  = rout_upt_req || rout_chng_int || rout_chng_when_cnt_reaches;
    

endmodule
