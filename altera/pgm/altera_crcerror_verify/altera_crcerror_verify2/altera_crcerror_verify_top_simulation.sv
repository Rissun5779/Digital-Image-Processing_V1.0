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
// File name: altera_crcerror_verify_top.v
// This file instantiates crcerror_verify component for Stratix IV and Arria II GZ. 
//
//  Include false failure checks at no-shift frames for all Stratix IV devices and Arria II GZ devices
// 
// ******************************************************************************************************************************** 

(* altera_attribute = "-name IP_TOOL_NAME altera_crcerror_verify2; -name IP_TOOL_VERSION 18.1" *)
module altera_crcerror_verify_top (
  err_verify_in_clk
, reset
, crc_error
, emr_real_seu
, crcerror_raw
, emr_reg_raw
, emr_valid	
);

input err_verify_in_clk;
input reset;
output crc_error;
output [45:0] emr_real_seu;
output crcerror_raw;	
output [45:0] emr_reg_raw; 
output emr_valid; 

wire crcerror;
wire emr_clk;
wire emr_out;
wire shiftnld;
wire crcerror_raw;
wire [45:0] emr_reg_raw;
wire emr_valid;
wire crc_error_core;

assign crcerror_raw = crcerror;

assign crc_error = crc_error_core ? 1'bz : 1'b0;

// following constants are defined in crcerror_verify_define.iv
parameter error_check_frequency_divisor	= 2 ;
parameter in_clk_frequency    		    = 50 ;
parameter ed_cycle_time_div256 		    = 160 ;

crcerror_verify_wrapper crcerror_verify_component (
  .inclk(err_verify_in_clk)
, .reset(reset)
, .crcerror(crcerror)
, .crc_error(crc_error_core)
, .emr_out(emr_out)
, .emr_clk(emr_clk)
, .shiftnld(shiftnld)
, .emr_reg_raw (emr_reg_raw)
, .emr_valid (emr_valid)
, .emr_out_o(emr_real_seu)
);
defparam crcerror_verify_component.ED_CYCLE_TIME_DIV256 = ed_cycle_time_div256;
defparam crcerror_verify_component.CRC_DIVISOR 		    = error_check_frequency_divisor;
defparam crcerror_verify_component.INCLK_FREQ 		    = in_clk_frequency;

stratixiv_crcblock_wrapper my_crc
(
.clk(emr_clk),
.shiftnld(shiftnld),
.crcerror(crcerror),
.regout(emr_out)
);
defparam my_crc.CRC_DIVISOR = error_check_frequency_divisor;

endmodule   

module crcerror_verify_wrapper (
  inclk
, reset
, crcerror
, emr_out
, crc_error
,  emr_clk
, shiftnld
, emr_reg_raw
, emr_valid
, emr_out_o
);

input inclk;
input reset;
input crcerror;
input emr_out;

output crc_error;
output emr_clk;
output shiftnld;
output [45:0] emr_reg_raw;
output emr_valid;
output [45:0] emr_out_o;

reg reset1;
reg reset_sync;
reg crcerror_sync1;
reg crcerror_sync;

wire crcerror;
wire crc_error;
wire emr_clk;
wire shiftnld;
wire emr_out;
wire emr_done;

   parameter CRC_DIVISOR = -1;
   parameter INCLK_FREQ = -1;
   parameter ED_CYCLE_TIME_DIV256 = -1;

always @(posedge inclk or posedge reset)
begin
    if (reset == 1'b1)
    begin
       reset1 <= 1'b1;
       reset_sync <= 1'b1;
    end
    else 
    begin
       reset1 <= 1'b0;
       reset_sync <= reset1;
    end
end

always @(posedge inclk or posedge reset_sync)
begin
    if (reset_sync == 1'b1)
    begin
       crcerror_sync1 <= 1'b0;
       crcerror_sync <= 1'b0;
    end
    else 
    begin
       crcerror_sync1 <= crcerror;
       crcerror_sync <= crcerror_sync1;
    end
end

// Collect error message register information
crcerror_read_emr crcerror_read_emr_component
    (
    .clk(inclk),
    .reset(reset_sync),
    .start_write(crcerror_sync),
    .emr_done(emr_done),
    .emr_clk(emr_clk),
    .shiftnld(shiftnld)
    );

crcerror_verify_core crccheck0
(
.inclk(inclk),
.reset(reset_sync),
.emr_in(emr_out),
.emr_done(emr_done),
.emr_reg_en(emr_clk),
.crcerror_in(crcerror_sync),
.emr_reg_raw (emr_reg_raw),
.emr_valid (emr_valid),
.emr_out(emr_out_o),
.crcerror_out(crc_error)
);
defparam crccheck0.ED_CYCLE_TIME_DIV256 = ED_CYCLE_TIME_DIV256;
defparam crccheck0.CRC_DIVISOR = CRC_DIVISOR;
defparam crccheck0.INCLK_FREQ = INCLK_FREQ;

endmodule   

module stratixiv_crcblock_wrapper
(
clk,
shiftnld,
crcerror,
regout
);
input clk;
input shiftnld;
output crcerror;
output regout;

wire clk;
wire regout;

parameter CRC_DIVISOR = -1;

	stratixiv_crcblock_model stratixiv_crcblock(
		.clk(clk),
		.shiftnld(shiftnld),
		.crcerror(crcerror),
		.regout(regout)
	);
endmodule   

