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


module twentynm_hps_interface_security_module (
  input anti_tamper_in,
  output anti_tamper_out,
  output fpga_dbgen_sig,
  output fpga_niden_sig);


  // synthesis translate_off
  import verbosity_pkg::*;

  typedef logic ROLE_anti_tamper_in_t;
  typedef logic ROLE_anti_tamper_out_t;
  typedef logic ROLE_fpga_dbgen_sig_t;
  typedef logic ROLE_fpga_niden_sig_t;

  logic anti_tamper_input;
  logic anti_tamper_local;
  reg anti_tamper_out_temp;
  reg fpga_dbgen_sig_temp;
  reg fpga_niden_sig_temp;

  event signal_input_anti_tamper_in_change;

  // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1" 
  function automatic string get_version();  // public
     string ret_version = "12.1";
     return ret_version;
  endfunction


  // Gets the sda input value.
  function automatic ROLE_anti_tamper_in_t get_anti_tamper_in();
    $sformat(message, "%m: called get_anti_tamper_in");
    print(VERBOSITY_DEBUG, message);
    return anti_tamper_input;
  endfunction

  // Drive the new value to anti_tamper_out.
  function automatic void set_anti_tamper_out(ROLE_anti_tamper_out_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     anti_tamper_out_temp = new_value;
  endfunction

  // Drive the new value to fpga_dbgen_sig.
  function automatic void set_fpga_dbgen_sig(ROLE_fpga_dbgen_sig_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     fpga_dbgen_sig_temp = new_value;
  endfunction

  // Drive the new value to en.
  function automatic void set_fpga_niden_sig(ROLE_fpga_niden_sig_t new_value);
     $sformat(message, "%m: method called arg0 %0d", new_value); 
     print(VERBOSITY_DEBUG, message);
     fpga_niden_sig_temp = new_value;
  endfunction

  assign anti_tamper_input = anti_tamper_in;
  assign anti_tamper_out = anti_tamper_out_temp;
  assign fpga_dbgen_sig = fpga_dbgen_sig_temp;
  assign fpga_niden_sig = fpga_niden_sig_temp;


  always @(anti_tamper_input) begin
    if (anti_tamper_local!=anti_tamper_input)
      -> signal_input_anti_tamper_in_change;
    anti_tamper_local = anti_tamper_input;
  end

// synthesis translate_on

endmodule
