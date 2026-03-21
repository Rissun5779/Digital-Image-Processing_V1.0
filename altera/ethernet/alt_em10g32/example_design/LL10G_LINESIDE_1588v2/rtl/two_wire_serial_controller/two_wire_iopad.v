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


/*
Created by : Cher Jier
Description: Open Drain I2C interface, Pull up resister is a must
*/

// module i2c_iopad (
	// scl,
	// scl_out,
	// scl_oe_h,
    // scl_in,
	// sda,
	// sda_out,
	// sda_oe_h,
    // sda_in
// );

  // inout  scl;
  // input scl_out;
  // input	 scl_oe_h;	
  // output  sda_in;

  // output  scl_in;
  // inout  sda;
  // input sda_out;
  // input  sda_oe_h;

  // I2C interface
  // assign	scl_in    	= scl;
  // assign    scl			= scl_oe_h ? scl_out : 1'bz;	
  
  // assign	sda_in    	= sda;
  // assign	sda       	= sda_oe_h ? sda_out : 1'bz;
  
// endmodule
/*
Created by : Cher Jier
Description: Open Drain I2C interface, Pull up resister is a must
*/

module two_wire_iopad (
	scl,
	scl_out,
	scl_oe_h,
    scl_in,
	sda,
	sda_out,
	sda_oe_h,
    sda_in
);

  inout  scl;
  input scl_out;
  input	 scl_oe_h;	
  output  sda_in;

  output  scl_in;
  inout  sda;
  input sda_out;
  input  sda_oe_h;

  // 2 wire interface
  assign	scl_in    	= scl_oe_h ? scl_out : scl;
  assign    scl			= scl_oe_h ? scl_out : 1'bz;	
  
  assign	sda_in    	= sda_oe_h ? sda_out : sda;
  assign	sda       	= sda_oe_h ? sda_out : 1'bz;


endmodule 
