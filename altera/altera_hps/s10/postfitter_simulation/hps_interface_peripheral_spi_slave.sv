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


module twentynm_hps_interface_peripheral_spi_slave (
   input  wire mosi_i,
   input  wire ss_in_n,
   input  wire clk,
   output wire miso_o,
   output wire miso_oe);

   // synthesis translate_off
   import verbosity_pkg::*;

   typedef logic ROLE_mosi_i_t;
   typedef logic ROLE_ss_in_n_t;

   typedef logic ROLE_clk_t;
   typedef logic ROLE_miso_o_t;
   typedef logic ROLE_miso_oe_t;

   logic mosi_i_in;
   logic ss_in_n_in;
   logic clk_in;

   logic mosi_i_local;
   logic ss_in_n_local;
   logic clk_local;

   reg miso_o_temp;
   reg miso_oe_temp;

   event signal_input_mosi_i_change;
   event signal_input_ss_in_n_change;
   event signal_input_clk_change;


   // Return BFM version string. For example, version 9.1 sp1 is "9.1sp1"
   function automatic string get_version();  // public
      string ret_version = "12.1";
      return ret_version;
   endfunction

   // Gets the mosi_i input value.
   function automatic ROLE_mosi_i_t get_mosi_i();
      $sformat(message, "%m: called get_mosi_i");
      print(VERBOSITY_DEBUG, message);
      return mosi_i_in;
   endfunction

   // Gets the ss_in_n input value.
   function automatic ROLE_ss_in_n_t get_ss_in_n();
      $sformat(message, "%m: called get_ss_in_n");
      print(VERBOSITY_DEBUG, message);
      return ss_in_n_in;
   endfunction

   // Gets the clk input value.
   function automatic ROLE_clk_t get_clk();
      $sformat(message, "%m: called get_clk");
      print(VERBOSITY_DEBUG, message);
      return clk_in;
   endfunction


   // Drive the new value to miso_o.
   function automatic void set_miso_o(ROLE_miso_o_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      miso_o_temp = new_value;
   endfunction

   // Drive the new value to miso_oe.
   function automatic void set_miso_oe(ROLE_miso_oe_t new_value);
      $sformat(message, "%m: method called arg0 %0d", new_value); 
      print(VERBOSITY_DEBUG, message);
      miso_oe_temp = new_value;
   endfunction


   assign mosi_i_in = mosi_i;
   assign ss_in_n_in = ss_in_n;
   assign clk_in = clk;

   assign miso_o = miso_o_temp;
   assign miso_oe = miso_oe_temp;


   always @(mosi_i_in) begin
      if (mosi_i_local != mosi_i_in)
         -> signal_input_mosi_i_change;
      mosi_i_local = mosi_i_in;
   end

   always @(ss_in_n_in) begin
      if (ss_in_n_local != ss_in_n_in)
         -> signal_input_ss_in_n_change;
      ss_in_n_local = ss_in_n_in;
   end

   always @(clk_in) begin
      if (clk_local != clk_in)
         -> signal_input_clk_change;
      clk_local = clk_in;
   end

// synthesis translate_on
endmodule
