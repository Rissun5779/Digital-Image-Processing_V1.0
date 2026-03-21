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


// ******************************************************************************************************************************** 
// File name: crcerror_counter.v
// 
//
// Development of EDCRC Counter
//

module crcerror_edcrc_counter #(
                       parameter     DAYS_ENABLE = 1'b0,
                       parameter      INCLK_FREQ = 50, 
                       parameter            DAYS = 30,
                       parameter  MAX_COUNT_DAYS = (((INCLK_FREQ * 60 * 60 * 24 * DAYS)/ (2**20))+
                                                   (((INCLK_FREQ * 60 * 60 * 24 * DAYS)% (2**20))==0?0:1)), 
                       parameter       MAX_COUNT = 16,
                       parameter        COUNT_1M = 1000000,
					   parameter MAX_COUNT_WIDTH = 5, 
                       parameter  COUNT_1M_WIDTH = 7 
)
(
input  logic                     clk,
input  logic                     reset,
input  logic                     count_up, 
output logic[MAX_COUNT_WIDTH-1:0] counter_value,
output logic                     done
);

logic [(DAYS_ENABLE? COUNT_1M_WIDTH:MAX_COUNT_WIDTH)-1:0] count_1m_1;
reg [(DAYS_ENABLE? COUNT_1M_WIDTH:MAX_COUNT_WIDTH)-1:0] count_1m_2;
reg [MAX_COUNT_WIDTH-1:0] count_days;
logic [(DAYS_ENABLE? COUNT_1M_WIDTH:MAX_COUNT_WIDTH)-1:0] count_normal;
logic                      normal_done;
reg days_done;

always @(posedge reset or posedge clk) begin
    if (reset) begin
        count_1m_1 <= 0;
		count_1m_2 <= 0;
		count_days <= 0;
	end else if (DAYS_ENABLE && count_1m_2>=COUNT_1M-1 && count_1m_1>=COUNT_1M-1) begin
	    count_days <= count_days + 1'b1;
	    count_1m_2 <= 0;
		count_1m_1 <= 0;
	end else if (count_1m_1>=COUNT_1M-1) begin
        count_1m_2 <= count_1m_2 + 1'b1; 
        count_1m_1 <= 0;
    end else if (count_up) 
        count_1m_1 <= count_1m_1 + 1'b1;
end

always @(posedge reset or posedge clk) begin
    if (reset) begin
        days_done <= 0;
    end else if (count_days>MAX_COUNT_DAYS) begin
        days_done <= 1;
    end else 
        days_done <= days_done;
end

assign normal_done = (count_1m_2>0)? (count_1m_2==MAX_COUNT) : (count_1m_1==MAX_COUNT);  
assign done   = DAYS_ENABLE ? days_done: 
                              normal_done;

assign counter_value =  DAYS_ENABLE ? count_days:  
                                      count_normal[MAX_COUNT_WIDTH-1:0]; 
assign count_normal  =  (count_1m_2>0)? count_1m_2: count_1m_1;
							  
endmodule   