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


(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF" *)

module altera_emif_arch_nd_oct #(
   parameter OCT_CONTROL_WIDTH = 1,
   parameter PHY_CALIBRATED_OCT = 1,
   parameter PHY_CONFIG_ENUM = "CONFIG_PHY_AND_HARD_CTRL",
   parameter IS_HPS = 0
) (
   input  logic                          afi_clk,
   input  logic                          afi_reset_n,
   input  logic                          emif_usr_clk,
   input  logic                          emif_usr_reset_n,
   input  logic                          pll_ref_clk_int,
   input  logic                          phy_reset_n,

   input  logic                          oct_rzqin,  
   output logic [OCT_CONTROL_WIDTH-1:0]  oct_stc,    
   output logic [OCT_CONTROL_WIDTH-1:0]  oct_ptc     
);
   timeunit 1ns;
   timeprecision 1ps;

   typedef enum
   {
      ST_OCTFSM_RESET,           
      ST_OCTFSM_WAIT_IDLE,       
      ST_OCTFSM_WAIT_REQ_HI,     
      ST_OCTFSM_WAIT_BUSY_HI,    
      ST_OCTFSM_WAIT_BUSY_LO,    
      ST_OCTFSM_WAIT_REQ_LO,     
      ST_OCTFSM_DONE             
   } ST_OCTFSM;

   localparam OCT_CAL_MODE = "A_OCT_CAL_MODE_AUTO";
   localparam OCT_USER_OCT = "A_OCT_USER_OCT_OFF";

   generate
   if (PHY_CALIBRATED_OCT) begin : cal_oct
   
      logic oct_ser_data;
      logic oct_nclrusr;
      logic oct_enserusr;
      logic oct_clkenusr;
      logic oct_clkusr;
      logic oct_s2pload;

      assign oct_nclrusr  = 1'b0;
      assign oct_clkenusr = 1'b0;
      assign oct_clkusr   = 1'b0;
      assign oct_s2pload  = 1'b0;
      assign oct_enserusr = 1'b0;
      
      fourteennm_termination #(
         .a_oct_cal_mode(OCT_CAL_MODE),
         .a_oct_user_oct(OCT_USER_OCT)
      )
      termination_inst (
         .rzqin(oct_rzqin),
         .enserusr(oct_enserusr),
         .serdataout(oct_ser_data),
         .nclrusr(oct_nclrusr),
         .clkenusr(oct_clkenusr),
         .clkusr(oct_clkusr)
      );

      fourteennm_termination_logic termination_logic_inst (
         .s2pload(oct_s2pload),
         .serdata(oct_ser_data),
         .seriesterminationcontrol(oct_stc),
         .parallelterminationcontrol(oct_ptc)
      );

   end else begin : non_cal_oct
      assign oct_stc = '0;
      assign oct_ptc = '0;
   end
   endgenerate
   
endmodule

