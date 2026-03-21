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


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1 ps / 1 ps
`define Tref 50

module altera_oct_driver(
	rzqin,
	s2pload,
	calibration_request,
	clock,
	reset,
	octcalcode_0,
	octload_0,
	octcalcode_1,
	octload_1,
	octcalcode_2,
	octload_2,
	octcalcode_3,
	octload_3,
	octcalcode_4,
	octload_4,
	calibration_shift_busy,
	calibration_busy
);

parameter OCT_CAL_NUM = 1;
parameter OCT_INTERNAL_SIM = 0;
parameter OCT_CKBUF_MODE = "false";
parameter OCT_USER_MODE = "A_OCT_USER_OCT_OFF";
parameter OCT_CAL_MODE_DER_0 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_1 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_2 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_3 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_4 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_5 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_6 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_7 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_8 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_9 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_10 = "A_OCT_CAL_X2_DIS";
parameter OCT_CAL_MODE_DER_11 = "A_OCT_CAL_X2_DIS";

localparam PWRUP_TEST = (OCT_USER_MODE == "A_OCT_USER_OCT_OFF");

output	[OCT_CAL_NUM-1:0] rzqin;
output	s2pload;
output	[OCT_CAL_NUM-1:0] calibration_request;
output	clock;
output	reset;
input	[OCT_CAL_NUM-1:0] calibration_shift_busy;
input	[OCT_CAL_NUM-1:0] calibration_busy;
input [31:0] octcalcode_0[47:0];
input [31:0] octcalcode_1[47:0];
input [31:0] octcalcode_2[47:0];
input [31:0] octcalcode_3[47:0];
input [31:0] octcalcode_4[47:0];

input [31:0] octload_0;
input [31:0] octload_1;
input [31:0] octload_2;
input [31:0] octload_3;
input [31:0] octload_4;

reg [OCT_CAL_NUM-1:0] calibration_request_reg;
reg clock_reg;
reg reset_reg;
reg s2pload_reg;
reg rzqin_reg;
//reg [31:0] data_correct;
//reg [31:0] data_wrong;

reg [31:0] octcalcode_0_w[47:0];
reg [31:0] octcalcode_1_w[47:0];
reg [31:0] octcalcode_2_w[47:0];
reg [31:0] octcalcode_3_w[47:0];
reg [31:0] octcalcode_4_w[47:0];

reg [31:0] octload_0_w;
reg [31:0] octload_1_w;
reg [31:0] octload_2_w;
reg [31:0] octload_3_w;
reg [31:0] octload_4_w;

assign octload_0_w = octload_0;
assign octload_1_w = (OCT_CAL_NUM > 1) ? octload_1 : 0;
assign octload_2_w = (OCT_CAL_NUM > 2) ? octload_2 : 0;
assign octload_3_w = (OCT_CAL_NUM > 3) ? octload_3 : 0;
assign octload_4_w = (OCT_CAL_NUM > 4) ? octload_4 : 0;

generate
	genvar pin_num, pin_idx;
		for (pin_num = 0; pin_num < 48; pin_num = pin_num + 1) begin : pin_assignment_gen
			assign octcalcode_0_w[pin_num] = octcalcode_0[pin_num];
			assign octcalcode_1_w[pin_num] = (OCT_CAL_NUM > 1) ? octcalcode_1[pin_num] : 0;
			assign octcalcode_2_w[pin_num] = (OCT_CAL_NUM > 2) ? octcalcode_2[pin_num] : 0;
			assign octcalcode_3_w[pin_num] = (OCT_CAL_NUM > 3) ? octcalcode_3[pin_num] : 0;
			assign octcalcode_4_w[pin_num] = (OCT_CAL_NUM > 4) ? octcalcode_4[pin_num] : 0;
		end
endgenerate

reg [15:0] watchdog;

// wire [11:0] calibration_request_test_pattern = 12'b110010101011;
wire [11:0] calibration_request_test_pattern = 12'b111111111111;

initial begin
	// Initialize
	calibration_request_reg = {OCT_CAL_NUM{1'b0}};
	clock_reg = 0;
	reset_reg = 0;
	s2pload_reg = 0;
	rzqin_reg = 0;

	sleep(10);

	// Reset
	reset_reg = 1;
	// Wait for powerup calibration
	sleep(2200);

	// Release Reset
	reset_reg = 0;
	sleep(5);

	// Request Calibration
	$display("Issued calibration request: %t", $time);
	calibration_request_reg = calibration_request_test_pattern[OCT_CAL_NUM-1:0];
	wait(|calibration_busy || PWRUP_TEST);

	reset_reg = 0;
	sleep(2);

	calibration_request_reg = {OCT_CAL_NUM{1'b0}};
	wait(~|calibration_busy || PWRUP_TEST);
	$display("Done calibrating: %t", $time);
	wait(~|calibration_shift_busy || PWRUP_TEST);
	$display("Done shifting: %t", $time);
	sleep(100);
	
	// set s2pload
	s2pload_reg = 1;
	sleep(1);
	s2pload_reg = 0;
	sleep(1);

	print_report_and_finish;
end

// Clock
always begin 
	#(`Tref) clock_reg = ~clock_reg;
end
assign clock = clock_reg;

// control signals
//assign s2pload = s2pload_reg;
assign calibration_request = calibration_request_reg;
assign reset = reset_reg;
assign rzqin = rzqin_reg;

wire watchdog_error = (watchdog == 16'h0000);

always @(clock_reg or reset) begin
	if(reset) begin
		watchdog <= 16'hFFFF;
	end
	else begin
		if(watchdog_error) begin
			$display("ERROR: simulation timeout!");
			$finish;
		end
		else begin
			watchdog <= watchdog - 1'b1;
		end
	end
end

// TASK: print_report_and_finish
task print_report_and_finish;
	int data_wrong;
	int data_correct;
	int check_data;

	data_wrong = 0;
	data_correct = 0;

	for(int i = 0; i < 48; i = i + 1) begin: gen_i
		check_data = (  (octcalcode_0_w[i][31:0] === octload_0_w[31:0]) && 
				(octcalcode_1_w[i][31:0] === octload_1_w[31:0]) && 
				(octcalcode_2_w[i][31:0] === octload_2_w[31:0]) && 
				(octcalcode_3_w[i][31:0] === octload_3_w[31:0]) && 
				(octcalcode_4_w[i][31:0] === octload_4_w[31:0]) );
		if (check_data == 1) begin
			data_correct = data_correct + 1;
		end else begin
			data_wrong = data_wrong + 1;
		end
	end

	if(((data_correct > 0) && (data_wrong == 0)) || (OCT_INTERNAL_SIM == 0)) begin
		$display("");
		$display("SIMULATION COMPLETED: SUCCESS ! ! !");
		$display("");
	end
	else begin
		$display("");
		$display("SIMULATION COMPLETED: FAILED ! ! !");
		$display("");
	end
	$display("Stats:");
	$display("   Correct Data: %d", data_correct);
	$display("   Wrong Data: %d", data_wrong);
	
	$finish;
endtask

// TASK: sleep
task sleep(reg [15:0] cycles);
	repeat(cycles) begin
		@(posedge clock_reg);
	end
endtask

endmodule


