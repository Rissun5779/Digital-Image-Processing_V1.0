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


module twentynm_hps_interface_jtag (
  input fake_din,//ignored
  output s2f_fpga_scanman_tdi,
  output s2f_fpga_scanman_tms,
  output s2f_fpga_sysman_nenab_jtag);


  // synthesis translate_off
  import verbosity_pkg::*;

  typedef logic ROLE_tdi_t;
  typedef logic ROLE_tms_t;
  typedef logic ROLE_en_t;

  reg tdi_temp;
  reg tms_temp;
  reg en_temp;

  // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
  function automatic string get_version();  // public
     string ret_version = "12.1";
     return ret_version;
  endfunction


  // Drive the new value to tdi.
  function automatic void set_tdi(ROLE_tdi_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     tdi_temp = new_value;
  endfunction


  // Drive the new value to tms.
  function automatic void set_tms(ROLE_tms_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     tms_temp = new_value;
  endfunction

  // Drive the new value to en.
  function automatic void set_nenab_jtag(ROLE_en_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     en_temp = new_value;
  endfunction

  assign s2f_fpga_scanman_tdi = tdi_temp;
  assign s2f_fpga_scanman_tms = tms_temp;
  assign s2f_fpga_sysman_nenab_jtag = en_temp;

// synthesis translate_on

endmodule
