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


module twentynm_hps_interface_peripheral_spi_master (
   input  miso_i,
   input  ss_in_n,
   output mosi_o,
   output mosi_oe,
   output ss0_n_o,
   output ss1_n_o,
   output ss2_n_o,
   output ss3_n_o,
   output s2f_clk,
   output sclk_out);

   // synthesis translate_off
   import verbosity_pkg::*;

   typedef logic ROLE_miso_t;
   typedef logic ROLE_ss_in_n_t;

   typedef logic ROLE_mosi_o_t;
   typedef logic ROLE_mosi_oe_t;
   typedef logic ROLE_ss0_n_o_t;
   typedef logic ROLE_ss1_n_o_t;
   typedef logic ROLE_ss2_n_o_t;
   typedef logic ROLE_ss3_n_o_t;
   typedef logic ROLE_s2f_clk_t;
   typedef logic ROLE_sclk_out_t;

   logic miso_i_input;
   logic ss_in_n_input;

   logic miso_i_local;
   logic ss_in_n_local;

   event signal_input_miso_i_change;
   event signal_input_ss_in_n_change;

   reg mosi_o_temp;
   reg mosi_oe_temp;
   reg ss0_n_o_temp;
   reg ss1_n_o_temp;
   reg ss2_n_o_temp;
   reg ss3_n_o_temp;
   reg s2f_clk_temp;
   reg sclk_out_temp;


   // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1"
   function automatic string get_version();  // public
      string ret_version = "12.1";
      return ret_version;
   endfunction


   // Gets the miso_i input value
   function automatic ROLE_miso_t get_miso_i();
      $sformat(message, "%m: called get_miso_i");
      print(VERBOSITY_DEBUG, message);
      return miso_i_input;
   endfunction

   // Gets the ss_in_n input value
   function automatic ROLE_miso_t get_ss_in_n();
      $sformat(message, "%m: called get_ss_in_n");
      print(VERBOSITY_DEBUG, message);
      return ss_in_n_input;
   endfunction


   // Drive the new value to mosi_o.
   function automatic void set_mosi_o(ROLE_mosi_o_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      mosi_o_temp = new_value;
   endfunction

   // Drive the new value to mosi_oe.
   function automatic void set_mosi_oe(ROLE_mosi_oe_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      mosi_oe_temp = new_value;
   endfunction

   // Drive the new value to ss0_n_o.
   function automatic void set_ss0_n_o(ROLE_ss0_n_o_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      ss0_n_o_temp = new_value;
   endfunction

   // Drive the new value to ss1_n_o.
   function automatic void set_ss1_n_o(ROLE_ss1_n_o_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      ss1_n_o_temp = new_value;
   endfunction

   // Drive the new value to ss2_n_o.
   function automatic void set_ss2_n_o(ROLE_ss2_n_o_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      ss2_n_o_temp = new_value;
   endfunction

   // Drive the new value to ss3_n_o.
   function automatic void set_ss3_n_o(ROLE_ss3_n_o_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      ss3_n_o_temp = new_value;
   endfunction

   // Drive the new value to s2f_clk.
   function automatic void set_s2f_clk(ROLE_s2f_clk_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      s2f_clk_temp = new_value;
   endfunction

   // Drive the new value to sclk_out.
   function automatic void set_sclk_out(ROLE_sclk_out_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value);
      print(VERBOSITY_DEBUG, message);
      sclk_out_temp = new_value;
   endfunction


   assign miso_i_input = miso_i;
   assign ss_in_n_input = ss_in_n;

   assign mosi_o = mosi_o_temp;
   assign mosi_oe = mosi_oe_temp;
   assign ss0_n_o = ss0_n_o_temp;
   assign ss1_n_o = ss1_n_o_temp;
   assign ss2_n_o = ss2_n_o_temp;
   assign ss3_n_o = ss3_n_o_temp;
   assign s2f_clk = s2f_clk_temp;
   assign sclk_out = sclk_out_temp;


   always @(miso_i_input) begin
      if (miso_i_local!=miso_i)
         -> signal_input_miso_i_change;
      miso_i_local = miso_i;
   end

   always @(ss_in_n_input) begin
      if (ss_in_n_local!=ss_in_n)
         -> signal_input_ss_in_n_change;
      ss_in_n_local = ss_in_n;
   end

// synthesis translate_on
endmodule
