# (C) 2001-2018 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.



####################################################################################################
#
# Testbench Clock conduit
#
proc add_tbed_hip_port_clk {} {

   send_message debug "proc:add_tbed_hip_port_clk"

   add_interface refclk clock start
   add_interface_port refclk refclk clk Output 1
   set pll_refclk_freq  [ get_parameter_value pll_refclk_freq_hwtcl]
   set refclk_hz        [ expr [ regexp 125 $pll_refclk_freq  ] ? 125000000 :  100000000 ]
   set_interface_property refclk clockRate $refclk_hz

}


####################################################################################################
#
# Power on reset
#
proc add_tbed_hip_port_npor  {} {
   add_interface npor conduit end
   add_interface_port npor npor npor Output  1
   add_interface_port npor pin_perst pin_perst Output 1
}

####################################################################################################
#
# Testbench Control conduit
#
proc add_tbed_hip_port_control {} {

   send_message debug "proc:add_tbed_hip_port_control"

   add_interface hip_ctrl conduit end
   add_interface_port hip_ctrl test_in        test_in   Output 67
   add_interface_port hip_ctrl simu_mode_pipe simu_mode_pipe Output 1

}

####################################################################################################
#
# Pipe interface conduit
#
proc add_tbed_hip_port_pipe {} {

   send_message debug "proc:add_tbed_hip_port_pipe"

   set lane_mask_hwtcl  [ get_parameter_value lane_mask_hwtcl]
   set nlane [ expr [ regexp x16 $lane_mask_hwtcl ] ? 16 : [ regexp x8 $lane_mask_hwtcl ] ? 8 :  [ regexp x4 $lane_mask_hwtcl ] ? 4 : [ regexp x2 $lane_mask_hwtcl ] ? 2 : 1 ]

   add_interface hip_pipe conduit end

   # clock for pipe simulation
   add_interface_port hip_pipe sim_pipe_pclk_in              sim_pipe_pclk_in            Output 1
   add_interface_port hip_pipe sim_pipe_mask_tx_pll_lock     sim_pipe_mask_tx_pll_lock   Output 1
   add_interface_port hip_pipe sim_pipe_rate                 sim_pipe_rate               Input 2
   add_interface_port hip_pipe sim_ltssmstate                sim_ltssmstate              Input 6

   if { $nlane == 1 } {
      add_interface_port hip_pipe dirfeedback0 dirfeedback0  Output 6
      add_to_no_connect  dirfeedback1 6 Out
      add_to_no_connect  dirfeedback2 6 Out
      add_to_no_connect  dirfeedback3 6 Out
      add_to_no_connect  dirfeedback4 6 Out
      add_to_no_connect  dirfeedback5 6 Out
      add_to_no_connect  dirfeedback6 6 Out
      add_to_no_connect  dirfeedback7 6 Out
      add_interface_port hip_pipe rxeqeval0     rxeqeval0      Input 1
      add_to_no_connect  rxeqeval1 1 In
      add_to_no_connect  rxeqeval2 1 In
      add_to_no_connect  rxeqeval3 1 In
      add_to_no_connect  rxeqeval4 1 In
      add_to_no_connect  rxeqeval5 1 In
      add_to_no_connect  rxeqeval6 1 In
      add_to_no_connect  rxeqeval7 1 In
          add_interface_port hip_pipe rxeqinprogress0     rxeqinprogress0      Input 1
      add_to_no_connect  rxeqinprogress1 1 In
      add_to_no_connect  rxeqinprogress2 1 In
      add_to_no_connect  rxeqinprogress3 1 In
      add_to_no_connect  rxeqinprogress4 1 In
      add_to_no_connect  rxeqinprogress5 1 In
      add_to_no_connect  rxeqinprogress6 1 In
      add_to_no_connect  rxeqinprogress7 1 In
          add_interface_port hip_pipe invalidreq0     invalidreq0      Input 1
      add_to_no_connect  invalidreq1 1 In
      add_to_no_connect  invalidreq2 1 In
      add_to_no_connect  invalidreq3 1 In
      add_to_no_connect  invalidreq4 1 In
      add_to_no_connect  invalidreq5 1 In
      add_to_no_connect  invalidreq6 1 In
      add_to_no_connect  invalidreq7 1 In
      add_interface_port hip_pipe powerdown0     powerdown0      Input 2
      add_to_no_connect  powerdown1 2 In
      add_to_no_connect  powerdown2 2 In
      add_to_no_connect  powerdown3 2 In
      add_to_no_connect  powerdown4 2 In
      add_to_no_connect  powerdown5 2 In
      add_to_no_connect  powerdown6 2 In
      add_to_no_connect  powerdown7 2 In
      add_interface_port hip_pipe rxpolarity0    rxpolarity0     Input 1
      add_to_no_connect  rxpolarity1 1 In
      add_to_no_connect  rxpolarity2 1 In
      add_to_no_connect  rxpolarity3 1 In
      add_to_no_connect  rxpolarity4 1 In
      add_to_no_connect  rxpolarity5 1 In
      add_to_no_connect  rxpolarity6 1 In
      add_to_no_connect  rxpolarity7 1 In
      add_interface_port hip_pipe txcompl0       txcompl0        Input 1
      add_to_no_connect  txcompl1 1 In
      add_to_no_connect  txcompl2 1 In
      add_to_no_connect  txcompl3 1 In
      add_to_no_connect  txcompl4 1 In
      add_to_no_connect  txcompl5 1 In
      add_to_no_connect  txcompl6 1 In
      add_to_no_connect  txcompl7 1 In
      add_interface_port hip_pipe txdata0        txdata0         Input 32
      add_to_no_connect  txdata1 32 In
      add_to_no_connect  txdata2 32 In
      add_to_no_connect  txdata3 32 In
      add_to_no_connect  txdata4 32 In
      add_to_no_connect  txdata5 32 In
      add_to_no_connect  txdata6 32 In
      add_to_no_connect  txdata7 32 In
      add_interface_port hip_pipe txdatak0       txdatak0        Input 4
      add_to_no_connect  txdatak1 4 In
      add_to_no_connect  txdatak2 4 In
      add_to_no_connect  txdatak3 4 In
      add_to_no_connect  txdatak4 4 In
      add_to_no_connect  txdatak5 4 In
      add_to_no_connect  txdatak6 4 In
      add_to_no_connect  txdatak7 4 In
      add_interface_port hip_pipe txdetectrx0    txdetectrx0     Input 1
      add_to_no_connect  txdetectrx1 1 In
      add_to_no_connect  txdetectrx2 1 In
      add_to_no_connect  txdetectrx3 1 In
      add_to_no_connect  txdetectrx4 1 In
      add_to_no_connect  txdetectrx5 1 In
      add_to_no_connect  txdetectrx6 1 In
      add_to_no_connect  txdetectrx7 1 In
      add_interface_port hip_pipe txelecidle0    txelecidle0     Input 1
      add_to_no_connect  txelecidle1 1 In
      add_to_no_connect  txelecidle2 1 In
      add_to_no_connect  txelecidle3 1 In
      add_to_no_connect  txelecidle4 1 In
      add_to_no_connect  txelecidle5 1 In
      add_to_no_connect  txelecidle6 1 In
      add_to_no_connect  txelecidle7 1 In
      add_interface_port hip_pipe txdeemph0      txdeemph0       Input 1
      add_to_no_connect  txdeemph1 1 In
      add_to_no_connect  txdeemph2 1 In
      add_to_no_connect  txdeemph3 1 In
      add_to_no_connect  txdeemph4 1 In
      add_to_no_connect  txdeemph5 1 In
      add_to_no_connect  txdeemph6 1 In
      add_to_no_connect  txdeemph7 1 In
      add_interface_port hip_pipe txmargin0      txmargin0       Input 3
      add_to_no_connect  txmargin1 3 In
      add_to_no_connect  txmargin2 3 In
      add_to_no_connect  txmargin3 3 In
      add_to_no_connect  txmargin4 3 In
      add_to_no_connect  txmargin5 3 In
      add_to_no_connect  txmargin6 3 In
      add_to_no_connect  txmargin7 3 In
      add_interface_port hip_pipe txswing0       txswing0        Input 1
      add_to_no_connect  txswing1 1 In
      add_to_no_connect  txswing2 1 In
      add_to_no_connect  txswing3 1 In
      add_to_no_connect  txswing4 1 In
      add_to_no_connect  txswing5 1 In
      add_to_no_connect  txswing6 1 In
      add_to_no_connect  txswing7 1 In
      add_interface_port hip_pipe phystatus0     phystatus0      Output  1
      add_to_no_connect  phystatus1 1 Out
      add_to_no_connect  phystatus2 1 Out
      add_to_no_connect  phystatus3 1 Out
      add_to_no_connect  phystatus4 1 Out
      add_to_no_connect  phystatus5 1 Out
      add_to_no_connect  phystatus6 1 Out
      add_to_no_connect  phystatus7 1 Out
      add_interface_port hip_pipe rxdata0        rxdata0         Output  32
      add_to_no_connect  rxdata1 32 Out
      add_to_no_connect  rxdata2 32 Out
      add_to_no_connect  rxdata3 32 Out
      add_to_no_connect  rxdata4 32 Out
      add_to_no_connect  rxdata5 32 Out
      add_to_no_connect  rxdata6 32 Out
      add_to_no_connect  rxdata7 32 Out
      add_interface_port hip_pipe rxdatak0       rxdatak0        Output  4
      add_to_no_connect  rxdatak1 4 Out
      add_to_no_connect  rxdatak2 4 Out
      add_to_no_connect  rxdatak3 4 Out
      add_to_no_connect  rxdatak4 4 Out
      add_to_no_connect  rxdatak5 4 Out
      add_to_no_connect  rxdatak6 4 Out
      add_to_no_connect  rxdatak7 4 Out
      add_interface_port hip_pipe rxelecidle0    rxelecidle0     Output  1
      add_to_no_connect  rxelecidle1 1 Out
      add_to_no_connect  rxelecidle2 1 Out
      add_to_no_connect  rxelecidle3 1 Out
      add_to_no_connect  rxelecidle4 1 Out
      add_to_no_connect  rxelecidle5 1 Out
      add_to_no_connect  rxelecidle6 1 Out
      add_to_no_connect  rxelecidle7 1 Out
      add_interface_port hip_pipe rxstatus0      rxstatus0       Output  3
      add_to_no_connect  rxstatus1 3 Out
      add_to_no_connect  rxstatus2 3 Out
      add_to_no_connect  rxstatus3 3 Out
      add_to_no_connect  rxstatus4 3 Out
      add_to_no_connect  rxstatus5 3 Out
      add_to_no_connect  rxstatus6 3 Out
      add_to_no_connect  rxstatus7 3 Out
      add_interface_port hip_pipe rxvalid0       rxvalid0        Output  1
      add_to_no_connect  rxvalid1 1 Out
      add_to_no_connect  rxvalid2 1 Out
      add_to_no_connect  rxvalid3 1 Out
      add_to_no_connect  rxvalid4 1 Out
      add_to_no_connect  rxvalid5 1 Out
      add_to_no_connect  rxvalid6 1 Out
      add_to_no_connect  rxvalid7 1 Out
      add_interface_port hip_pipe rxdataskip0    rxdataskip0     Output  1
      add_to_no_connect  rxdataskip1 1 Out
      add_to_no_connect  rxdataskip2 1 Out
      add_to_no_connect  rxdataskip3 1 Out
      add_to_no_connect  rxdataskip4 1 Out
      add_to_no_connect  rxdataskip5 1 Out
      add_to_no_connect  rxdataskip6 1 Out
      add_to_no_connect  rxdataskip7 1 Out
      add_interface_port hip_pipe rxblkst0       rxblkst0        Output  1
      add_to_no_connect  rxblkst1  1 Out
      add_to_no_connect  rxblkst2  1 Out
      add_to_no_connect  rxblkst3  1 Out
      add_to_no_connect  rxblkst4  1 Out
      add_to_no_connect  rxblkst5  1 Out
      add_to_no_connect  rxblkst6  1 Out
      add_to_no_connect  rxblkst7  1 Out
      add_interface_port hip_pipe rxsynchd0      rxsynchd0       Output  2
      add_to_no_connect  rxsynchd1  2 Out
      add_to_no_connect  rxsynchd2  2 Out
      add_to_no_connect  rxsynchd3  2 Out
      add_to_no_connect  rxsynchd4  2 Out
      add_to_no_connect  rxsynchd5  2 Out
      add_to_no_connect  rxsynchd6  2 Out
      add_to_no_connect  rxsynchd7  2 Out
      add_interface_port hip_pipe currentcoeff0  currentcoeff0   Input  18
      add_to_no_connect  currentcoeff1  18 In
      add_to_no_connect  currentcoeff2  18 In
      add_to_no_connect  currentcoeff3  18 In
      add_to_no_connect  currentcoeff4  18 In
      add_to_no_connect  currentcoeff5  18 In
      add_to_no_connect  currentcoeff6  18 In
      add_to_no_connect  currentcoeff7  18 In
      add_interface_port hip_pipe currentrxpreset0       currentrxpreset0       Input  3
      add_to_no_connect  currentrxpreset1  3 In
      add_to_no_connect  currentrxpreset2  3 In
      add_to_no_connect  currentrxpreset3  3 In
      add_to_no_connect  currentrxpreset4  3 In
      add_to_no_connect  currentrxpreset5  3 In
      add_to_no_connect  currentrxpreset6  3 In
      add_to_no_connect  currentrxpreset7  3 In
      add_interface_port hip_pipe txsynchd0      txsynchd0        Input  2
      add_to_no_connect  txsynchd1  2 In
      add_to_no_connect  txsynchd2  2 In
      add_to_no_connect  txsynchd3  2 In
      add_to_no_connect  txsynchd4  2 In
      add_to_no_connect  txsynchd5  2 In
      add_to_no_connect  txsynchd6  2 In
      add_to_no_connect  txsynchd7  2 In
      add_interface_port hip_pipe txblkst0       txblkst0         Input  1
      add_to_no_connect  txblkst1  1 In
      add_to_no_connect  txblkst2  1 In
      add_to_no_connect  txblkst3  1 In
      add_to_no_connect  txblkst4  1 In
      add_to_no_connect  txblkst5  1 In
      add_to_no_connect  txblkst6  1 In
      add_to_no_connect  txblkst7  1 In
      add_interface_port hip_pipe txdataskip0    txdataskip0      Input  1
      add_to_no_connect  txdataskip1  1 In
      add_to_no_connect  txdataskip2  1 In
      add_to_no_connect  txdataskip3  1 In
      add_to_no_connect  txdataskip4  1 In
      add_to_no_connect  txdataskip5  1 In
      add_to_no_connect  txdataskip6  1 In
      add_to_no_connect  txdataskip7  1 In
      add_interface_port hip_pipe rate0          rate0            Input  2
      add_to_no_connect  rate1  2 In
      add_to_no_connect  rate2  2 In
      add_to_no_connect  rate3  2 In
      add_to_no_connect  rate4  2 In
      add_to_no_connect  rate5  2 In
      add_to_no_connect  rate6  2 In
      add_to_no_connect  rate7  2 In
      add_to_no_connect  dirfeedback8  6 Out
      add_to_no_connect  dirfeedback9  6 Out
      add_to_no_connect  dirfeedback10 6 Out
      add_to_no_connect  dirfeedback11 6 Out
      add_to_no_connect  dirfeedback12 6 Out
      add_to_no_connect  dirfeedback13 6 Out
      add_to_no_connect  dirfeedback14 6 Out
      add_to_no_connect  dirfeedback15 6 Out
      add_to_no_connect  rxeqeval8  1 In
      add_to_no_connect  rxeqeval9  1 In
      add_to_no_connect  rxeqeval10 1 In
      add_to_no_connect  rxeqeval11 1 In
      add_to_no_connect  rxeqeval12 1 In
      add_to_no_connect  rxeqeval13 1 In
      add_to_no_connect  rxeqeval14 1 In
      add_to_no_connect  rxeqeval15 1 In
      add_to_no_connect  rxeqinprogress8  1 In
      add_to_no_connect  rxeqinprogress9  1 In
      add_to_no_connect  rxeqinprogress10 1 In
      add_to_no_connect  rxeqinprogress11 1 In
      add_to_no_connect  rxeqinprogress12 1 In
      add_to_no_connect  rxeqinprogress13 1 In
      add_to_no_connect  rxeqinprogress14 1 In
      add_to_no_connect  rxeqinprogress15 1 In
      add_to_no_connect  invalidreq8  1 In
      add_to_no_connect  invalidreq9  1 In
      add_to_no_connect  invalidreq10 1 In
      add_to_no_connect  invalidreq11 1 In
      add_to_no_connect  invalidreq12 1 In
      add_to_no_connect  invalidreq13 1 In
      add_to_no_connect  invalidreq14 1 In
      add_to_no_connect  invalidreq15 1 In
      add_to_no_connect  powerdown8  2 In
      add_to_no_connect  powerdown9  2 In
      add_to_no_connect  powerdown10 2 In
      add_to_no_connect  powerdown11 2 In
      add_to_no_connect  powerdown12 2 In
      add_to_no_connect  powerdown13 2 In
      add_to_no_connect  powerdown14 2 In
      add_to_no_connect  powerdown15 2 In
      add_to_no_connect  rxpolarity8  1 In
      add_to_no_connect  rxpolarity9  1 In
      add_to_no_connect  rxpolarity10 1 In
      add_to_no_connect  rxpolarity11 1 In
      add_to_no_connect  rxpolarity12 1 In
      add_to_no_connect  rxpolarity13 1 In
      add_to_no_connect  rxpolarity14 1 In
      add_to_no_connect  rxpolarity15 1 In
      add_to_no_connect  txcompl8  1 In
      add_to_no_connect  txcompl9  1 In
      add_to_no_connect  txcompl10 1 In
      add_to_no_connect  txcompl11 1 In
      add_to_no_connect  txcompl12 1 In
      add_to_no_connect  txcompl13 1 In
      add_to_no_connect  txcompl14 1 In
      add_to_no_connect  txcompl15 1 In
      add_to_no_connect  txdata8  32 In
      add_to_no_connect  txdata9  32 In
      add_to_no_connect  txdata10 32 In
      add_to_no_connect  txdata11 32 In
      add_to_no_connect  txdata12 32 In
      add_to_no_connect  txdata13 32 In
      add_to_no_connect  txdata14 32 In
      add_to_no_connect  txdata15 32 In
      add_to_no_connect  txdatak8  4 In
      add_to_no_connect  txdatak9  4 In
      add_to_no_connect  txdatak10 4 In
      add_to_no_connect  txdatak11 4 In
      add_to_no_connect  txdatak12 4 In
      add_to_no_connect  txdatak13 4 In
      add_to_no_connect  txdatak14 4 In
      add_to_no_connect  txdatak15 4 In
      add_to_no_connect  txdetectrx8  1 In
      add_to_no_connect  txdetectrx9  1 In
      add_to_no_connect  txdetectrx10 1 In
      add_to_no_connect  txdetectrx11 1 In
      add_to_no_connect  txdetectrx12 1 In
      add_to_no_connect  txdetectrx13 1 In
      add_to_no_connect  txdetectrx14 1 In
      add_to_no_connect  txdetectrx15 1 In
      add_to_no_connect  txelecidle8  1 In
      add_to_no_connect  txelecidle9  1 In
      add_to_no_connect  txelecidle10 1 In
      add_to_no_connect  txelecidle11 1 In
      add_to_no_connect  txelecidle12 1 In
      add_to_no_connect  txelecidle13 1 In
      add_to_no_connect  txelecidle14 1 In
      add_to_no_connect  txelecidle15 1 In
      add_to_no_connect  txdeemph8  1 In
      add_to_no_connect  txdeemph9  1 In
      add_to_no_connect  txdeemph10 1 In
      add_to_no_connect  txdeemph11 1 In
      add_to_no_connect  txdeemph12 1 In
      add_to_no_connect  txdeemph13 1 In
      add_to_no_connect  txdeemph14 1 In
      add_to_no_connect  txdeemph15 1 In
      add_to_no_connect  txmargin8  3 In
      add_to_no_connect  txmargin9  3 In
      add_to_no_connect  txmargin10 3 In
      add_to_no_connect  txmargin11 3 In
      add_to_no_connect  txmargin12 3 In
      add_to_no_connect  txmargin13 3 In
      add_to_no_connect  txmargin14 3 In
      add_to_no_connect  txmargin15 3 In
      add_to_no_connect  txswing8  1 In
      add_to_no_connect  txswing9  1 In
      add_to_no_connect  txswing10 1 In
      add_to_no_connect  txswing11 1 In
      add_to_no_connect  txswing12 1 In
      add_to_no_connect  txswing13 1 In
      add_to_no_connect  txswing14 1 In
      add_to_no_connect  txswing15 1 In
      add_to_no_connect  phystatus8  1 Out
      add_to_no_connect  phystatus9  1 Out
      add_to_no_connect  phystatus10 1 Out
      add_to_no_connect  phystatus11 1 Out
      add_to_no_connect  phystatus12 1 Out
      add_to_no_connect  phystatus13 1 Out
      add_to_no_connect  phystatus14 1 Out
      add_to_no_connect  phystatus15 1 Out
      add_to_no_connect  rxdata8  32 Out
      add_to_no_connect  rxdata9  32 Out
      add_to_no_connect  rxdata10 32 Out
      add_to_no_connect  rxdata11 32 Out
      add_to_no_connect  rxdata12 32 Out
      add_to_no_connect  rxdata13 32 Out
      add_to_no_connect  rxdata14 32 Out
      add_to_no_connect  rxdata15 32 Out
      add_to_no_connect  rxdatak8  4 Out
      add_to_no_connect  rxdatak9  4 Out
      add_to_no_connect  rxdatak10 4 Out
      add_to_no_connect  rxdatak11 4 Out
      add_to_no_connect  rxdatak12 4 Out
      add_to_no_connect  rxdatak13 4 Out
      add_to_no_connect  rxdatak14 4 Out
      add_to_no_connect  rxdatak15 4 Out
      add_to_no_connect  rxelecidle8  1 Out
      add_to_no_connect  rxelecidle9  1 Out
      add_to_no_connect  rxelecidle10 1 Out
      add_to_no_connect  rxelecidle11 1 Out
      add_to_no_connect  rxelecidle12 1 Out
      add_to_no_connect  rxelecidle13 1 Out
      add_to_no_connect  rxelecidle14 1 Out
      add_to_no_connect  rxelecidle15 1 Out
      add_to_no_connect  rxstatus8  3 Out
      add_to_no_connect  rxstatus9  3 Out
      add_to_no_connect  rxstatus10 3 Out
      add_to_no_connect  rxstatus11 3 Out
      add_to_no_connect  rxstatus12 3 Out
      add_to_no_connect  rxstatus13 3 Out
      add_to_no_connect  rxstatus14 3 Out
      add_to_no_connect  rxstatus15 3 Out
      add_to_no_connect  rxvalid8  1 Out
      add_to_no_connect  rxvalid9  1 Out
      add_to_no_connect  rxvalid10 1 Out
      add_to_no_connect  rxvalid11 1 Out
      add_to_no_connect  rxvalid12 1 Out
      add_to_no_connect  rxvalid13 1 Out
      add_to_no_connect  rxvalid14 1 Out
      add_to_no_connect  rxvalid15 1 Out
      add_to_no_connect  rxdataskip8  1 Out
      add_to_no_connect  rxdataskip9  1 Out
      add_to_no_connect  rxdataskip10 1 Out
      add_to_no_connect  rxdataskip11 1 Out
      add_to_no_connect  rxdataskip12 1 Out
      add_to_no_connect  rxdataskip13 1 Out
      add_to_no_connect  rxdataskip14 1 Out
      add_to_no_connect  rxdataskip15 1 Out
      add_to_no_connect  rxblkst8   1 Out
      add_to_no_connect  rxblkst9   1 Out
      add_to_no_connect  rxblkst10  1 Out
      add_to_no_connect  rxblkst11  1 Out
      add_to_no_connect  rxblkst12  1 Out
      add_to_no_connect  rxblkst13  1 Out
      add_to_no_connect  rxblkst14  1 Out
      add_to_no_connect  rxblkst15  1 Out
      add_to_no_connect  rxsynchd8   2 Out
      add_to_no_connect  rxsynchd9   2 Out
      add_to_no_connect  rxsynchd10  2 Out
      add_to_no_connect  rxsynchd11  2 Out
      add_to_no_connect  rxsynchd12  2 Out
      add_to_no_connect  rxsynchd13  2 Out
      add_to_no_connect  rxsynchd14  2 Out
      add_to_no_connect  rxsynchd15  2 Out
      add_to_no_connect  currentcoeff8   18 In
      add_to_no_connect  currentcoeff9   18 In
      add_to_no_connect  currentcoeff10  18 In
      add_to_no_connect  currentcoeff11  18 In
      add_to_no_connect  currentcoeff12  18 In
      add_to_no_connect  currentcoeff13  18 In
      add_to_no_connect  currentcoeff14  18 In
      add_to_no_connect  currentcoeff15  18 In
      add_to_no_connect  currentrxpreset8   3 In
      add_to_no_connect  currentrxpreset9   3 In
      add_to_no_connect  currentrxpreset10  3 In
      add_to_no_connect  currentrxpreset11  3 In
      add_to_no_connect  currentrxpreset12  3 In
      add_to_no_connect  currentrxpreset13  3 In
      add_to_no_connect  currentrxpreset14  3 In
      add_to_no_connect  currentrxpreset15  3 In
      add_to_no_connect  txsynchd8   2 In
      add_to_no_connect  txsynchd9   2 In
      add_to_no_connect  txsynchd10  2 In
      add_to_no_connect  txsynchd11  2 In
      add_to_no_connect  txsynchd12  2 In
      add_to_no_connect  txsynchd13  2 In
      add_to_no_connect  txsynchd14  2 In
      add_to_no_connect  txsynchd15  2 In
      add_to_no_connect  txblkst8   1 In
      add_to_no_connect  txblkst9   1 In
      add_to_no_connect  txblkst10  1 In
      add_to_no_connect  txblkst11  1 In
      add_to_no_connect  txblkst12  1 In
      add_to_no_connect  txblkst13  1 In
      add_to_no_connect  txblkst14  1 In
      add_to_no_connect  txblkst15  1 In
      add_to_no_connect  txdataskip8   1 In
      add_to_no_connect  txdataskip9   1 In
      add_to_no_connect  txdataskip10  1 In
      add_to_no_connect  txdataskip11  1 In
      add_to_no_connect  txdataskip12  1 In
      add_to_no_connect  txdataskip13  1 In
      add_to_no_connect  txdataskip14  1 In
      add_to_no_connect  txdataskip15  1 In
      add_to_no_connect  rate8   2 In
      add_to_no_connect  rate9   2 In
      add_to_no_connect  rate10  2 In
      add_to_no_connect  rate11  2 In
      add_to_no_connect  rate12  2 In
      add_to_no_connect  rate13  2 In
      add_to_no_connect  rate14  2 In
      add_to_no_connect  rate15  2 In
   } elseif { $nlane == 2 } {
      add_interface_port hip_pipe dirfeedback0 dirfeedback0  Output 6
      add_interface_port hip_pipe dirfeedback1 dirfeedback1  Output 6
      add_to_no_connect  dirfeedback2 6 Out
      add_to_no_connect  dirfeedback3 6 Out
      add_to_no_connect  dirfeedback4 6 Out
      add_to_no_connect  dirfeedback5 6 Out
      add_to_no_connect  dirfeedback6 6 Out
      add_to_no_connect  dirfeedback7 6 Out
      add_interface_port hip_pipe rxeqeval0     rxeqeval0      Input 1
      add_interface_port hip_pipe rxeqeval1     rxeqeval1      Input 1
      add_to_no_connect  rxeqeval2 1 In
      add_to_no_connect  rxeqeval3 1 In
      add_to_no_connect  rxeqeval4 1 In
      add_to_no_connect  rxeqeval5 1 In
      add_to_no_connect  rxeqeval6 1 In
      add_to_no_connect  rxeqeval7 1 In
          add_interface_port hip_pipe rxeqinprogress0     rxeqinprogress0      Input 1
          add_interface_port hip_pipe rxeqinprogress1     rxeqinprogress1      Input 1
      add_to_no_connect  rxeqinprogress2 1 In
      add_to_no_connect  rxeqinprogress3 1 In
      add_to_no_connect  rxeqinprogress4 1 In
      add_to_no_connect  rxeqinprogress5 1 In
      add_to_no_connect  rxeqinprogress6 1 In
      add_to_no_connect  rxeqinprogress7 1 In
          add_interface_port hip_pipe invalidreq0     invalidreq0      Input 1
          add_interface_port hip_pipe invalidreq1     invalidreq1      Input 1
      add_to_no_connect  invalidreq2 1 In
      add_to_no_connect  invalidreq3 1 In
      add_to_no_connect  invalidreq4 1 In
      add_to_no_connect  invalidreq5 1 In
      add_to_no_connect  invalidreq6 1 In
      add_to_no_connect  invalidreq7 1 In
      add_interface_port hip_pipe powerdown0     powerdown0      Input 2
      add_interface_port hip_pipe powerdown1     powerdown1      Input 2
      add_to_no_connect  powerdown2 2 In
      add_to_no_connect  powerdown3 2 In
      add_to_no_connect  powerdown4 2 In
      add_to_no_connect  powerdown5 2 In
      add_to_no_connect  powerdown6 2 In
      add_to_no_connect  powerdown7 2 In
      add_interface_port hip_pipe rxpolarity0    rxpolarity0     Input 1
      add_interface_port hip_pipe rxpolarity1    rxpolarity1     Input 1
      add_to_no_connect  rxpolarity2 1 In
      add_to_no_connect  rxpolarity3 1 In
      add_to_no_connect  rxpolarity4 1 In
      add_to_no_connect  rxpolarity5 1 In
      add_to_no_connect  rxpolarity6 1 In
      add_to_no_connect  rxpolarity7 1 In
      add_interface_port hip_pipe txcompl0       txcompl0        Input 1
      add_interface_port hip_pipe txcompl1       txcompl1        Input 1
      add_to_no_connect  txcompl2 1 In
      add_to_no_connect  txcompl3 1 In
      add_to_no_connect  txcompl4 1 In
      add_to_no_connect  txcompl5 1 In
      add_to_no_connect  txcompl6 1 In
      add_to_no_connect  txcompl7 1 In
      add_interface_port hip_pipe txdata0        txdata0         Input 32
      add_interface_port hip_pipe txdata1        txdata1         Input 32
      add_to_no_connect  txdata2 32 In
      add_to_no_connect  txdata3 32 In
      add_to_no_connect  txdata4 32 In
      add_to_no_connect  txdata5 32 In
      add_to_no_connect  txdata6 32 In
      add_to_no_connect  txdata7 32 In
      add_interface_port hip_pipe txdatak0       txdatak0        Input 4
      add_interface_port hip_pipe txdatak1       txdatak1        Input 4
      add_to_no_connect  txdatak2 4 In
      add_to_no_connect  txdatak3 4 In
      add_to_no_connect  txdatak4 4 In
      add_to_no_connect  txdatak5 4 In
      add_to_no_connect  txdatak6 4 In
      add_to_no_connect  txdatak7 4 In
      add_interface_port hip_pipe txdetectrx0    txdetectrx0     Input 1
      add_interface_port hip_pipe txdetectrx1    txdetectrx1     Input 1
      add_to_no_connect  txdetectrx2 1 In
      add_to_no_connect  txdetectrx3 1 In
      add_to_no_connect  txdetectrx4 1 In
      add_to_no_connect  txdetectrx5 1 In
      add_to_no_connect  txdetectrx6 1 In
      add_to_no_connect  txdetectrx7 1 In
      add_interface_port hip_pipe txelecidle0    txelecidle0     Input 1
      add_interface_port hip_pipe txelecidle1    txelecidle1     Input 1
      add_to_no_connect  txelecidle2 1 In
      add_to_no_connect  txelecidle3 1 In
      add_to_no_connect  txelecidle4 1 In
      add_to_no_connect  txelecidle5 1 In
      add_to_no_connect  txelecidle6 1 In
      add_to_no_connect  txelecidle7 1 In
      add_interface_port hip_pipe txdeemph0      txdeemph0       Input 1
      add_interface_port hip_pipe txdeemph1      txdeemph1       Input 1
      add_to_no_connect  txdeemph2 1 In
      add_to_no_connect  txdeemph3 1 In
      add_to_no_connect  txdeemph4 1 In
      add_to_no_connect  txdeemph5 1 In
      add_to_no_connect  txdeemph6 1 In
      add_to_no_connect  txdeemph7 1 In
      add_interface_port hip_pipe txmargin0      txmargin0       Input 3
      add_interface_port hip_pipe txmargin1      txmargin1       Input 3
      add_to_no_connect  txmargin2 3 In
      add_to_no_connect  txmargin3 3 In
      add_to_no_connect  txmargin4 3 In
      add_to_no_connect  txmargin5 3 In
      add_to_no_connect  txmargin6 3 In
      add_to_no_connect  txmargin7 3 In
      add_interface_port hip_pipe txswing0       txswing0        Input 1
      add_interface_port hip_pipe txswing1       txswing1        Input 1
      add_to_no_connect  txswing2 1 In
      add_to_no_connect  txswing3 1 In
      add_to_no_connect  txswing4 1 In
      add_to_no_connect  txswing5 1 In
      add_to_no_connect  txswing6 1 In
      add_to_no_connect  txswing7 1 In
      add_interface_port hip_pipe phystatus0     phystatus0      Output  1
      add_interface_port hip_pipe phystatus1     phystatus1      Output  1
      add_to_no_connect  phystatus2 1 Out
      add_to_no_connect  phystatus3 1 Out
      add_to_no_connect  phystatus4 1 Out
      add_to_no_connect  phystatus5 1 Out
      add_to_no_connect  phystatus6 1 Out
      add_to_no_connect  phystatus7 1 Out
      add_interface_port hip_pipe rxdata0        rxdata0         Output  32
      add_interface_port hip_pipe rxdata1        rxdata1         Output  32
      add_to_no_connect  rxdata2 32 Out
      add_to_no_connect  rxdata3 32 Out
      add_to_no_connect  rxdata4 32 Out
      add_to_no_connect  rxdata5 32 Out
      add_to_no_connect  rxdata6 32 Out
      add_to_no_connect  rxdata7 32 Out
      add_interface_port hip_pipe rxdatak0       rxdatak0        Output  4
      add_interface_port hip_pipe rxdatak1       rxdatak1        Output  4
      add_to_no_connect  rxdatak2 4 Out
      add_to_no_connect  rxdatak3 4 Out
      add_to_no_connect  rxdatak4 4 Out
      add_to_no_connect  rxdatak5 4 Out
      add_to_no_connect  rxdatak6 4 Out
      add_to_no_connect  rxdatak7 4 Out
      add_interface_port hip_pipe rxelecidle0    rxelecidle0     Output  1
      add_interface_port hip_pipe rxelecidle1    rxelecidle1     Output  1
      add_to_no_connect  rxelecidle2 1 Out
      add_to_no_connect  rxelecidle3 1 Out
      add_to_no_connect  rxelecidle4 1 Out
      add_to_no_connect  rxelecidle5 1 Out
      add_to_no_connect  rxelecidle6 1 Out
      add_to_no_connect  rxelecidle7 1 Out
      add_interface_port hip_pipe rxstatus0      rxstatus0       Output  3
      add_interface_port hip_pipe rxstatus1      rxstatus1       Output  3
      add_to_no_connect  rxstatus2 3 Out
      add_to_no_connect  rxstatus3 3 Out
      add_to_no_connect  rxstatus4 3 Out
      add_to_no_connect  rxstatus5 3 Out
      add_to_no_connect  rxstatus6 3 Out
      add_to_no_connect  rxstatus7 3 Out
      add_interface_port hip_pipe rxvalid0       rxvalid0        Output  1
      add_interface_port hip_pipe rxvalid1       rxvalid1        Output  1
      add_to_no_connect  rxvalid2 1 Out
      add_to_no_connect  rxvalid3 1 Out
      add_to_no_connect  rxvalid4 1 Out
      add_to_no_connect  rxvalid5 1 Out
      add_to_no_connect  rxvalid6 1 Out
      add_to_no_connect  rxvalid7 1 Out
      add_interface_port hip_pipe rxdataskip0    rxdataskip0     Output  1
      add_interface_port hip_pipe rxdataskip1    rxdataskip1     Output  1
      add_to_no_connect  rxdataskip2 1 Out
      add_to_no_connect  rxdataskip3 1 Out
      add_to_no_connect  rxdataskip4 1 Out
      add_to_no_connect  rxdataskip5 1 Out
      add_to_no_connect  rxdataskip6 1 Out
      add_to_no_connect  rxdataskip7 1 Out
      add_interface_port hip_pipe rxblkst0       rxblkst0        Output  1
      add_interface_port hip_pipe rxblkst1       rxblkst1        Output  1
      add_to_no_connect  rxblkst2  1 Out
      add_to_no_connect  rxblkst3  1 Out
      add_to_no_connect  rxblkst4  1 Out
      add_to_no_connect  rxblkst5  1 Out
      add_to_no_connect  rxblkst6  1 Out
      add_to_no_connect  rxblkst7  1 Out
      add_interface_port hip_pipe rxsynchd0      rxsynchd0       Output  2
      add_interface_port hip_pipe rxsynchd1      rxsynchd1       Output  2
      add_to_no_connect  rxsynchd2  2 Out
      add_to_no_connect  rxsynchd3  2 Out
      add_to_no_connect  rxsynchd4  2 Out
      add_to_no_connect  rxsynchd5  2 Out
      add_to_no_connect  rxsynchd6  2 Out
      add_to_no_connect  rxsynchd7  2 Out
      add_interface_port hip_pipe currentcoeff0  currentcoeff0   Input  18
      add_interface_port hip_pipe currentcoeff1  currentcoeff1   Input  18
      add_to_no_connect  currentcoeff2  18 In
      add_to_no_connect  currentcoeff3  18 In
      add_to_no_connect  currentcoeff4  18 In
      add_to_no_connect  currentcoeff5  18 In
      add_to_no_connect  currentcoeff6  18 In
      add_to_no_connect  currentcoeff7  18 In
      add_interface_port hip_pipe currentrxpreset0       currentrxpreset0       Input  3
      add_interface_port hip_pipe currentrxpreset1       currentrxpreset1       Input  3
      add_to_no_connect  currentrxpreset2  3 In
      add_to_no_connect  currentrxpreset3  3 In
      add_to_no_connect  currentrxpreset4  3 In
      add_to_no_connect  currentrxpreset5  3 In
      add_to_no_connect  currentrxpreset6  3 In
      add_to_no_connect  currentrxpreset7  3 In
      add_interface_port hip_pipe txsynchd0      txsynchd0        Input  2
      add_interface_port hip_pipe txsynchd1      txsynchd1        Input  2
      add_to_no_connect  txsynchd2  2 In
      add_to_no_connect  txsynchd3  2 In
      add_to_no_connect  txsynchd4  2 In
      add_to_no_connect  txsynchd5  2 In
      add_to_no_connect  txsynchd6  2 In
      add_to_no_connect  txsynchd7  2 In
      add_interface_port hip_pipe txblkst0       txblkst0         Input  1
      add_interface_port hip_pipe txblkst1       txblkst1         Input  1
      add_to_no_connect  txblkst2  1 In
      add_to_no_connect  txblkst3  1 In
      add_to_no_connect  txblkst4  1 In
      add_to_no_connect  txblkst5  1 In
      add_to_no_connect  txblkst6  1 In
      add_to_no_connect  txblkst7  1 In
      add_interface_port hip_pipe txdataskip0    txdataskip0      Input  1
      add_interface_port hip_pipe txdataskip1    txdataskip1      Input  1
      add_to_no_connect  txdataskip2  1 In
      add_to_no_connect  txdataskip3  1 In
      add_to_no_connect  txdataskip4  1 In
      add_to_no_connect  txdataskip5  1 In
      add_to_no_connect  txdataskip6  1 In
      add_to_no_connect  txdataskip7  1 In
      add_interface_port hip_pipe rate0          rate0            Input  2
      add_interface_port hip_pipe rate1          rate1            Input  2
      add_to_no_connect  rate2  2 In
      add_to_no_connect  rate3  2 In
      add_to_no_connect  rate4  2 In
      add_to_no_connect  rate5  2 In
      add_to_no_connect  rate6  2 In
      add_to_no_connect  rate7  2 In
      add_to_no_connect  dirfeedback8  6 Out
      add_to_no_connect  dirfeedback9  6 Out
      add_to_no_connect  dirfeedback10 6 Out
      add_to_no_connect  dirfeedback11 6 Out
      add_to_no_connect  dirfeedback12 6 Out
      add_to_no_connect  dirfeedback13 6 Out
      add_to_no_connect  dirfeedback14 6 Out
      add_to_no_connect  dirfeedback15 6 Out
      add_to_no_connect  rxeqeval8  1 In
      add_to_no_connect  rxeqeval9  1 In
      add_to_no_connect  rxeqeval10 1 In
      add_to_no_connect  rxeqeval11 1 In
      add_to_no_connect  rxeqeval12 1 In
      add_to_no_connect  rxeqeval13 1 In
      add_to_no_connect  rxeqeval14 1 In
      add_to_no_connect  rxeqeval15 1 In
      add_to_no_connect  rxeqinprogress8  1 In
      add_to_no_connect  rxeqinprogress9  1 In
      add_to_no_connect  rxeqinprogress10 1 In
      add_to_no_connect  rxeqinprogress11 1 In
      add_to_no_connect  rxeqinprogress12 1 In
      add_to_no_connect  rxeqinprogress13 1 In
      add_to_no_connect  rxeqinprogress14 1 In
      add_to_no_connect  rxeqinprogress15 1 In
      add_to_no_connect  invalidreq8  1 In
      add_to_no_connect  invalidreq9  1 In
      add_to_no_connect  invalidreq10 1 In
      add_to_no_connect  invalidreq11 1 In
      add_to_no_connect  invalidreq12 1 In
      add_to_no_connect  invalidreq13 1 In
      add_to_no_connect  invalidreq14 1 In
      add_to_no_connect  invalidreq15 1 In
      add_to_no_connect  powerdown8  2 In
      add_to_no_connect  powerdown9  2 In
      add_to_no_connect  powerdown10 2 In
      add_to_no_connect  powerdown11 2 In
      add_to_no_connect  powerdown12 2 In
      add_to_no_connect  powerdown13 2 In
      add_to_no_connect  powerdown14 2 In
      add_to_no_connect  powerdown15 2 In
      add_to_no_connect  rxpolarity8  1 In
      add_to_no_connect  rxpolarity9  1 In
      add_to_no_connect  rxpolarity10 1 In
      add_to_no_connect  rxpolarity11 1 In
      add_to_no_connect  rxpolarity12 1 In
      add_to_no_connect  rxpolarity13 1 In
      add_to_no_connect  rxpolarity14 1 In
      add_to_no_connect  rxpolarity15 1 In
      add_to_no_connect  txcompl8  1 In
      add_to_no_connect  txcompl9  1 In
      add_to_no_connect  txcompl10 1 In
      add_to_no_connect  txcompl11 1 In
      add_to_no_connect  txcompl12 1 In
      add_to_no_connect  txcompl13 1 In
      add_to_no_connect  txcompl14 1 In
      add_to_no_connect  txcompl15 1 In
      add_to_no_connect  txdata8  32 In
      add_to_no_connect  txdata9  32 In
      add_to_no_connect  txdata10 32 In
      add_to_no_connect  txdata11 32 In
      add_to_no_connect  txdata12 32 In
      add_to_no_connect  txdata13 32 In
      add_to_no_connect  txdata14 32 In
      add_to_no_connect  txdata15 32 In
      add_to_no_connect  txdatak8  4 In
      add_to_no_connect  txdatak9  4 In
      add_to_no_connect  txdatak10 4 In
      add_to_no_connect  txdatak11 4 In
      add_to_no_connect  txdatak12 4 In
      add_to_no_connect  txdatak13 4 In
      add_to_no_connect  txdatak14 4 In
      add_to_no_connect  txdatak15 4 In
      add_to_no_connect  txdetectrx8  1 In
      add_to_no_connect  txdetectrx9  1 In
      add_to_no_connect  txdetectrx10 1 In
      add_to_no_connect  txdetectrx11 1 In
      add_to_no_connect  txdetectrx12 1 In
      add_to_no_connect  txdetectrx13 1 In
      add_to_no_connect  txdetectrx14 1 In
      add_to_no_connect  txdetectrx15 1 In
      add_to_no_connect  txelecidle8  1 In
      add_to_no_connect  txelecidle9  1 In
      add_to_no_connect  txelecidle10 1 In
      add_to_no_connect  txelecidle11 1 In
      add_to_no_connect  txelecidle12 1 In
      add_to_no_connect  txelecidle13 1 In
      add_to_no_connect  txelecidle14 1 In
      add_to_no_connect  txelecidle15 1 In
      add_to_no_connect  txdeemph8  1 In
      add_to_no_connect  txdeemph9  1 In
      add_to_no_connect  txdeemph10 1 In
      add_to_no_connect  txdeemph11 1 In
      add_to_no_connect  txdeemph12 1 In
      add_to_no_connect  txdeemph13 1 In
      add_to_no_connect  txdeemph14 1 In
      add_to_no_connect  txdeemph15 1 In
      add_to_no_connect  txmargin8  3 In
      add_to_no_connect  txmargin9  3 In
      add_to_no_connect  txmargin10 3 In
      add_to_no_connect  txmargin11 3 In
      add_to_no_connect  txmargin12 3 In
      add_to_no_connect  txmargin13 3 In
      add_to_no_connect  txmargin14 3 In
      add_to_no_connect  txmargin15 3 In
      add_to_no_connect  txswing8  1 In
      add_to_no_connect  txswing9  1 In
      add_to_no_connect  txswing10 1 In
      add_to_no_connect  txswing11 1 In
      add_to_no_connect  txswing12 1 In
      add_to_no_connect  txswing13 1 In
      add_to_no_connect  txswing14 1 In
      add_to_no_connect  txswing15 1 In
      add_to_no_connect  phystatus8  1 Out
      add_to_no_connect  phystatus9  1 Out
      add_to_no_connect  phystatus10 1 Out
      add_to_no_connect  phystatus11 1 Out
      add_to_no_connect  phystatus12 1 Out
      add_to_no_connect  phystatus13 1 Out
      add_to_no_connect  phystatus14 1 Out
      add_to_no_connect  phystatus15 1 Out
      add_to_no_connect  rxdata8  32 Out
      add_to_no_connect  rxdata9  32 Out
      add_to_no_connect  rxdata10 32 Out
      add_to_no_connect  rxdata11 32 Out
      add_to_no_connect  rxdata12 32 Out
      add_to_no_connect  rxdata13 32 Out
      add_to_no_connect  rxdata14 32 Out
      add_to_no_connect  rxdata15 32 Out
      add_to_no_connect  rxdatak8  4 Out
      add_to_no_connect  rxdatak9  4 Out
      add_to_no_connect  rxdatak10 4 Out
      add_to_no_connect  rxdatak11 4 Out
      add_to_no_connect  rxdatak12 4 Out
      add_to_no_connect  rxdatak13 4 Out
      add_to_no_connect  rxdatak14 4 Out
      add_to_no_connect  rxdatak15 4 Out
      add_to_no_connect  rxelecidle8  1 Out
      add_to_no_connect  rxelecidle9  1 Out
      add_to_no_connect  rxelecidle10 1 Out
      add_to_no_connect  rxelecidle11 1 Out
      add_to_no_connect  rxelecidle12 1 Out
      add_to_no_connect  rxelecidle13 1 Out
      add_to_no_connect  rxelecidle14 1 Out
      add_to_no_connect  rxelecidle15 1 Out
      add_to_no_connect  rxstatus8  3 Out
      add_to_no_connect  rxstatus9  3 Out
      add_to_no_connect  rxstatus10 3 Out
      add_to_no_connect  rxstatus11 3 Out
      add_to_no_connect  rxstatus12 3 Out
      add_to_no_connect  rxstatus13 3 Out
      add_to_no_connect  rxstatus14 3 Out
      add_to_no_connect  rxstatus15 3 Out
      add_to_no_connect  rxvalid8  1 Out
      add_to_no_connect  rxvalid9  1 Out
      add_to_no_connect  rxvalid10 1 Out
      add_to_no_connect  rxvalid11 1 Out
      add_to_no_connect  rxvalid12 1 Out
      add_to_no_connect  rxvalid13 1 Out
      add_to_no_connect  rxvalid14 1 Out
      add_to_no_connect  rxvalid15 1 Out
      add_to_no_connect  rxdataskip8  1 Out
      add_to_no_connect  rxdataskip9  1 Out
      add_to_no_connect  rxdataskip10 1 Out
      add_to_no_connect  rxdataskip11 1 Out
      add_to_no_connect  rxdataskip12 1 Out
      add_to_no_connect  rxdataskip13 1 Out
      add_to_no_connect  rxdataskip14 1 Out
      add_to_no_connect  rxdataskip15 1 Out
      add_to_no_connect  rxblkst8   1 Out
      add_to_no_connect  rxblkst9   1 Out
      add_to_no_connect  rxblkst10  1 Out
      add_to_no_connect  rxblkst11  1 Out
      add_to_no_connect  rxblkst12  1 Out
      add_to_no_connect  rxblkst13  1 Out
      add_to_no_connect  rxblkst14  1 Out
      add_to_no_connect  rxblkst15  1 Out
      add_to_no_connect  rxsynchd8   2 Out
      add_to_no_connect  rxsynchd9   2 Out
      add_to_no_connect  rxsynchd10  2 Out
      add_to_no_connect  rxsynchd11  2 Out
      add_to_no_connect  rxsynchd12  2 Out
      add_to_no_connect  rxsynchd13  2 Out
      add_to_no_connect  rxsynchd14  2 Out
      add_to_no_connect  rxsynchd15  2 Out
      add_to_no_connect  currentcoeff8   18 In
      add_to_no_connect  currentcoeff9   18 In
      add_to_no_connect  currentcoeff10  18 In
      add_to_no_connect  currentcoeff11  18 In
      add_to_no_connect  currentcoeff12  18 In
      add_to_no_connect  currentcoeff13  18 In
      add_to_no_connect  currentcoeff14  18 In
      add_to_no_connect  currentcoeff15  18 In
      add_to_no_connect  currentrxpreset8   3 In
      add_to_no_connect  currentrxpreset9   3 In
      add_to_no_connect  currentrxpreset10  3 In
      add_to_no_connect  currentrxpreset11  3 In
      add_to_no_connect  currentrxpreset12  3 In
      add_to_no_connect  currentrxpreset13  3 In
      add_to_no_connect  currentrxpreset14  3 In
      add_to_no_connect  currentrxpreset15  3 In
      add_to_no_connect  txsynchd8   2 In
      add_to_no_connect  txsynchd9   2 In
      add_to_no_connect  txsynchd10  2 In
      add_to_no_connect  txsynchd11  2 In
      add_to_no_connect  txsynchd12  2 In
      add_to_no_connect  txsynchd13  2 In
      add_to_no_connect  txsynchd14  2 In
      add_to_no_connect  txsynchd15  2 In
      add_to_no_connect  txblkst8   1 In
      add_to_no_connect  txblkst9   1 In
      add_to_no_connect  txblkst10  1 In
      add_to_no_connect  txblkst11  1 In
      add_to_no_connect  txblkst12  1 In
      add_to_no_connect  txblkst13  1 In
      add_to_no_connect  txblkst14  1 In
      add_to_no_connect  txblkst15  1 In
      add_to_no_connect  txdataskip8   1 In
      add_to_no_connect  txdataskip9   1 In
      add_to_no_connect  txdataskip10  1 In
      add_to_no_connect  txdataskip11  1 In
      add_to_no_connect  txdataskip12  1 In
      add_to_no_connect  txdataskip13  1 In
      add_to_no_connect  txdataskip14  1 In
      add_to_no_connect  txdataskip15  1 In
      add_to_no_connect  rate8   2 In
      add_to_no_connect  rate9   2 In
      add_to_no_connect  rate10  2 In
      add_to_no_connect  rate11  2 In
      add_to_no_connect  rate12  2 In
      add_to_no_connect  rate13  2 In
      add_to_no_connect  rate14  2 In
      add_to_no_connect  rate15  2 In
   } elseif { $nlane == 4 } {
      add_interface_port hip_pipe dirfeedback0 dirfeedback0  Output 6
      add_interface_port hip_pipe dirfeedback1 dirfeedback1  Output 6
      add_interface_port hip_pipe dirfeedback2 dirfeedback2  Output 6
      add_interface_port hip_pipe dirfeedback3 dirfeedback3  Output 6
      add_to_no_connect  dirfeedback4 6 Out
      add_to_no_connect  dirfeedback5 6 Out
      add_to_no_connect  dirfeedback6 6 Out
      add_to_no_connect  dirfeedback7 6 Out
      add_interface_port hip_pipe rxeqeval0     rxeqeval0      Input 1
      add_interface_port hip_pipe rxeqeval1     rxeqeval1      Input 1
      add_interface_port hip_pipe rxeqeval2     rxeqeval2      Input 1
      add_interface_port hip_pipe rxeqeval3     rxeqeval3      Input 1
      add_to_no_connect  rxeqeval4 1 In
      add_to_no_connect  rxeqeval5 1 In
      add_to_no_connect  rxeqeval6 1 In
      add_to_no_connect  rxeqeval7 1 In
          add_interface_port hip_pipe rxeqinprogress0     rxeqinprogress0      Input 1
          add_interface_port hip_pipe rxeqinprogress1     rxeqinprogress1      Input 1
          add_interface_port hip_pipe rxeqinprogress2     rxeqinprogress2      Input 1
          add_interface_port hip_pipe rxeqinprogress3     rxeqinprogress3      Input 1
      add_to_no_connect  rxeqinprogress4 1 In
      add_to_no_connect  rxeqinprogress5 1 In
      add_to_no_connect  rxeqinprogress6 1 In
      add_to_no_connect  rxeqinprogress7 1 In
          add_interface_port hip_pipe invalidreq0     invalidreq0      Input 1
          add_interface_port hip_pipe invalidreq1     invalidreq1      Input 1
          add_interface_port hip_pipe invalidreq2     invalidreq2      Input 1
          add_interface_port hip_pipe invalidreq3     invalidreq3      Input 1
      add_to_no_connect  invalidreq4 1 In
      add_to_no_connect  invalidreq5 1 In
      add_to_no_connect  invalidreq6 1 In
      add_to_no_connect  invalidreq7 1 In
          add_interface_port hip_pipe powerdown0     powerdown0      Input 2
      add_interface_port hip_pipe powerdown1     powerdown1      Input 2
      add_interface_port hip_pipe powerdown2     powerdown2      Input 2
      add_interface_port hip_pipe powerdown3     powerdown3      Input 2
      add_to_no_connect  powerdown4 2 In
      add_to_no_connect  powerdown5 2 In
      add_to_no_connect  powerdown6 2 In
      add_to_no_connect  powerdown7 2 In
      add_interface_port hip_pipe rxpolarity0    rxpolarity0     Input 1
      add_interface_port hip_pipe rxpolarity1    rxpolarity1     Input 1
      add_interface_port hip_pipe rxpolarity2    rxpolarity2     Input 1
      add_interface_port hip_pipe rxpolarity3    rxpolarity3     Input 1
      add_to_no_connect  rxpolarity4 1 In
      add_to_no_connect  rxpolarity5 1 In
      add_to_no_connect  rxpolarity6 1 In
      add_to_no_connect  rxpolarity7 1 In
      add_interface_port hip_pipe txcompl0       txcompl0        Input 1
      add_interface_port hip_pipe txcompl1       txcompl1        Input 1
      add_interface_port hip_pipe txcompl2       txcompl2        Input 1
      add_interface_port hip_pipe txcompl3       txcompl3        Input 1
      add_to_no_connect  txcompl4 1 In
      add_to_no_connect  txcompl5 1 In
      add_to_no_connect  txcompl6 1 In
      add_to_no_connect  txcompl7 1 In
      add_interface_port hip_pipe txdata0        txdata0         Input 32
      add_interface_port hip_pipe txdata1        txdata1         Input 32
      add_interface_port hip_pipe txdata2        txdata2         Input 32
      add_interface_port hip_pipe txdata3        txdata3         Input 32
      add_to_no_connect  txdata4 32 In
      add_to_no_connect  txdata5 32 In
      add_to_no_connect  txdata6 32 In
      add_to_no_connect  txdata7 32 In
      add_interface_port hip_pipe txdatak0       txdatak0        Input 4
      add_interface_port hip_pipe txdatak1       txdatak1        Input 4
      add_interface_port hip_pipe txdatak2       txdatak2        Input 4
      add_interface_port hip_pipe txdatak3       txdatak3        Input 4
      add_to_no_connect  txdatak4 4 In
      add_to_no_connect  txdatak5 4 In
      add_to_no_connect  txdatak6 4 In
      add_to_no_connect  txdatak7 4 In
      add_interface_port hip_pipe txdetectrx0    txdetectrx0     Input 1
      add_interface_port hip_pipe txdetectrx1    txdetectrx1     Input 1
      add_interface_port hip_pipe txdetectrx2    txdetectrx2     Input 1
      add_interface_port hip_pipe txdetectrx3    txdetectrx3     Input 1
      add_to_no_connect  txdetectrx4 1 In
      add_to_no_connect  txdetectrx5 1 In
      add_to_no_connect  txdetectrx6 1 In
      add_to_no_connect  txdetectrx7 1 In
      add_interface_port hip_pipe txelecidle0    txelecidle0     Input 1
      add_interface_port hip_pipe txelecidle1    txelecidle1     Input 1
      add_interface_port hip_pipe txelecidle2    txelecidle2     Input 1
      add_interface_port hip_pipe txelecidle3    txelecidle3     Input 1
      add_to_no_connect  txelecidle4 1 In
      add_to_no_connect  txelecidle5 1 In
      add_to_no_connect  txelecidle6 1 In
      add_to_no_connect  txelecidle7 1 In
      add_interface_port hip_pipe txdeemph0      txdeemph0       Input 1
      add_interface_port hip_pipe txdeemph1      txdeemph1       Input 1
      add_interface_port hip_pipe txdeemph2      txdeemph2       Input 1
      add_interface_port hip_pipe txdeemph3      txdeemph3       Input 1
      add_to_no_connect  txdeemph4 1 In
      add_to_no_connect  txdeemph5 1 In
      add_to_no_connect  txdeemph6 1 In
      add_to_no_connect  txdeemph7 1 In
      add_interface_port hip_pipe txmargin0      txmargin0       Input 3
      add_interface_port hip_pipe txmargin1      txmargin1       Input 3
      add_interface_port hip_pipe txmargin2      txmargin2       Input 3
      add_interface_port hip_pipe txmargin3      txmargin3       Input 3
      add_to_no_connect  txmargin4 3 In
      add_to_no_connect  txmargin5 3 In
      add_to_no_connect  txmargin6 3 In
      add_to_no_connect  txmargin7 3 In
      add_interface_port hip_pipe txswing0       txswing0        Input 1
      add_interface_port hip_pipe txswing1       txswing1        Input 1
      add_interface_port hip_pipe txswing2       txswing2        Input 1
      add_interface_port hip_pipe txswing3       txswing3        Input 1
      add_to_no_connect  txswing4 1 In
      add_to_no_connect  txswing5 1 In
      add_to_no_connect  txswing6 1 In
      add_to_no_connect  txswing7 1 In
      add_interface_port hip_pipe phystatus0     phystatus0      Output  1
      add_interface_port hip_pipe phystatus1     phystatus1      Output  1
      add_interface_port hip_pipe phystatus2     phystatus2      Output  1
      add_interface_port hip_pipe phystatus3     phystatus3      Output  1
      add_to_no_connect  phystatus4 1 Out
      add_to_no_connect  phystatus5 1 Out
      add_to_no_connect  phystatus6 1 Out
      add_to_no_connect  phystatus7 1 Out
      add_interface_port hip_pipe rxdata0        rxdata0         Output  32
      add_interface_port hip_pipe rxdata1        rxdata1         Output  32
      add_interface_port hip_pipe rxdata2        rxdata2         Output  32
      add_interface_port hip_pipe rxdata3        rxdata3         Output  32
      add_to_no_connect  rxdata4 32 Out
      add_to_no_connect  rxdata5 32 Out
      add_to_no_connect  rxdata6 32 Out
      add_to_no_connect  rxdata7 32 Out
      add_interface_port hip_pipe rxdatak0       rxdatak0        Output  4
      add_interface_port hip_pipe rxdatak1       rxdatak1        Output  4
      add_interface_port hip_pipe rxdatak2       rxdatak2        Output  4
      add_interface_port hip_pipe rxdatak3       rxdatak3        Output  4
      add_to_no_connect  rxdatak4 4 Out
      add_to_no_connect  rxdatak5 4 Out
      add_to_no_connect  rxdatak6 4 Out
      add_to_no_connect  rxdatak7 4 Out
      add_interface_port hip_pipe rxelecidle0    rxelecidle0     Output  1
      add_interface_port hip_pipe rxelecidle1    rxelecidle1     Output  1
      add_interface_port hip_pipe rxelecidle2    rxelecidle2     Output  1
      add_interface_port hip_pipe rxelecidle3    rxelecidle3     Output  1
      add_to_no_connect  rxelecidle4 1 Out
      add_to_no_connect  rxelecidle5 1 Out
      add_to_no_connect  rxelecidle6 1 Out
      add_to_no_connect  rxelecidle7 1 Out
      add_interface_port hip_pipe rxstatus0      rxstatus0       Output  3
      add_interface_port hip_pipe rxstatus1      rxstatus1       Output  3
      add_interface_port hip_pipe rxstatus2      rxstatus2       Output  3
      add_interface_port hip_pipe rxstatus3      rxstatus3       Output  3
      add_to_no_connect  rxstatus4 3 Out
      add_to_no_connect  rxstatus5 3 Out
      add_to_no_connect  rxstatus6 3 Out
      add_to_no_connect  rxstatus7 3 Out
      add_interface_port hip_pipe rxvalid0       rxvalid0        Output  1
      add_interface_port hip_pipe rxvalid1       rxvalid1        Output  1
      add_interface_port hip_pipe rxvalid2       rxvalid2        Output  1
      add_interface_port hip_pipe rxvalid3       rxvalid3        Output  1
      add_to_no_connect  rxvalid4 1 Out
      add_to_no_connect  rxvalid5 1 Out
      add_to_no_connect  rxvalid6 1 Out
      add_to_no_connect  rxvalid7 1 Out
      add_interface_port hip_pipe rxdataskip0    rxdataskip0     Output  1
      add_interface_port hip_pipe rxdataskip1    rxdataskip1     Output  1
      add_interface_port hip_pipe rxdataskip2    rxdataskip2     Output  1
      add_interface_port hip_pipe rxdataskip3    rxdataskip3     Output  1
      add_to_no_connect  rxdataskip4 1 Out
      add_to_no_connect  rxdataskip5 1 Out
      add_to_no_connect  rxdataskip6 1 Out
      add_to_no_connect  rxdataskip7 1 Out
      add_interface_port hip_pipe rxblkst0       rxblkst0        Output  1
      add_interface_port hip_pipe rxblkst1       rxblkst1        Output  1
      add_interface_port hip_pipe rxblkst2       rxblkst2        Output  1
      add_interface_port hip_pipe rxblkst3       rxblkst3        Output  1
      add_to_no_connect  rxblkst4  1 Out
      add_to_no_connect  rxblkst5  1 Out
      add_to_no_connect  rxblkst6  1 Out
      add_to_no_connect  rxblkst7  1 Out
      add_interface_port hip_pipe rxsynchd0      rxsynchd0       Output  2
      add_interface_port hip_pipe rxsynchd1      rxsynchd1       Output  2
      add_interface_port hip_pipe rxsynchd2      rxsynchd2       Output  2
      add_interface_port hip_pipe rxsynchd3      rxsynchd3       Output  2
      add_to_no_connect  rxsynchd4  2 Out
      add_to_no_connect  rxsynchd5  2 Out
      add_to_no_connect  rxsynchd6  2 Out
      add_to_no_connect  rxsynchd7  2 Out
      add_interface_port hip_pipe currentcoeff0  currentcoeff0   Input  18
      add_interface_port hip_pipe currentcoeff1  currentcoeff1   Input  18
      add_interface_port hip_pipe currentcoeff2  currentcoeff2   Input  18
      add_interface_port hip_pipe currentcoeff3  currentcoeff3   Input  18
      add_to_no_connect  currentcoeff4  18 In
      add_to_no_connect  currentcoeff5  18 In
      add_to_no_connect  currentcoeff6  18 In
      add_to_no_connect  currentcoeff7  18 In
      add_interface_port hip_pipe currentrxpreset0       currentrxpreset0       Input  3
      add_interface_port hip_pipe currentrxpreset1       currentrxpreset1       Input  3
      add_interface_port hip_pipe currentrxpreset2       currentrxpreset2       Input  3
      add_interface_port hip_pipe currentrxpreset3       currentrxpreset3       Input  3
      add_to_no_connect  currentrxpreset4  3 In
      add_to_no_connect  currentrxpreset5  3 In
      add_to_no_connect  currentrxpreset6  3 In
      add_to_no_connect  currentrxpreset7  3 In
      add_interface_port hip_pipe txsynchd0      txsynchd0        Input  2
      add_interface_port hip_pipe txsynchd1      txsynchd1        Input  2
      add_interface_port hip_pipe txsynchd2      txsynchd2        Input  2
      add_interface_port hip_pipe txsynchd3      txsynchd3        Input  2
      add_to_no_connect  txsynchd4  2 In
      add_to_no_connect  txsynchd5  2 In
      add_to_no_connect  txsynchd6  2 In
      add_to_no_connect  txsynchd7  2 In
      add_interface_port hip_pipe txblkst0       txblkst0         Input  1
      add_interface_port hip_pipe txblkst1       txblkst1         Input  1
      add_interface_port hip_pipe txblkst2       txblkst2         Input  1
      add_interface_port hip_pipe txblkst3       txblkst3         Input  1
      add_to_no_connect  txblkst4  1 In
      add_to_no_connect  txblkst5  1 In
      add_to_no_connect  txblkst6  1 In
      add_to_no_connect  txblkst7  1 In
      add_interface_port hip_pipe txdataskip0    txdataskip0      Input  1
      add_interface_port hip_pipe txdataskip1    txdataskip1      Input  1
      add_interface_port hip_pipe txdataskip2    txdataskip2      Input  1
      add_interface_port hip_pipe txdataskip3    txdataskip3      Input  1
      add_to_no_connect  txdataskip4  1 In
      add_to_no_connect  txdataskip5  1 In
      add_to_no_connect  txdataskip6  1 In
      add_to_no_connect  txdataskip7  1 In
      add_interface_port hip_pipe rate0          rate0            Input  2
      add_interface_port hip_pipe rate1          rate1            Input  2
      add_interface_port hip_pipe rate2          rate2            Input  2
      add_interface_port hip_pipe rate3          rate3            Input  2
      add_to_no_connect  rate4  2 In
      add_to_no_connect  rate5  2 In
      add_to_no_connect  rate6  2 In
      add_to_no_connect  rate7  2 In
      add_to_no_connect  dirfeedback8  6 Out
      add_to_no_connect  dirfeedback9  6 Out
      add_to_no_connect  dirfeedback10 6 Out
      add_to_no_connect  dirfeedback11 6 Out
      add_to_no_connect  dirfeedback12 6 Out
      add_to_no_connect  dirfeedback13 6 Out
      add_to_no_connect  dirfeedback14 6 Out
      add_to_no_connect  dirfeedback15 6 Out
      add_to_no_connect  rxeqeval8  1 In
      add_to_no_connect  rxeqeval9  1 In
      add_to_no_connect  rxeqeval10 1 In
      add_to_no_connect  rxeqeval11 1 In
      add_to_no_connect  rxeqeval12 1 In
      add_to_no_connect  rxeqeval13 1 In
      add_to_no_connect  rxeqeval14 1 In
      add_to_no_connect  rxeqeval15 1 In
      add_to_no_connect  rxeqinprogress8  1 In
      add_to_no_connect  rxeqinprogress9  1 In
      add_to_no_connect  rxeqinprogress10 1 In
      add_to_no_connect  rxeqinprogress11 1 In
      add_to_no_connect  rxeqinprogress12 1 In
      add_to_no_connect  rxeqinprogress13 1 In
      add_to_no_connect  rxeqinprogress14 1 In
      add_to_no_connect  rxeqinprogress15 1 In
      add_to_no_connect  invalidreq8  1 In
      add_to_no_connect  invalidreq9  1 In
      add_to_no_connect  invalidreq10 1 In
      add_to_no_connect  invalidreq11 1 In
      add_to_no_connect  invalidreq12 1 In
      add_to_no_connect  invalidreq13 1 In
      add_to_no_connect  invalidreq14 1 In
      add_to_no_connect  invalidreq15 1 In
      add_to_no_connect  powerdown8  2 In
      add_to_no_connect  powerdown9  2 In
      add_to_no_connect  powerdown10 2 In
      add_to_no_connect  powerdown11 2 In
      add_to_no_connect  powerdown12 2 In
      add_to_no_connect  powerdown13 2 In
      add_to_no_connect  powerdown14 2 In
      add_to_no_connect  powerdown15 2 In
      add_to_no_connect  rxpolarity8  1 In
      add_to_no_connect  rxpolarity9  1 In
      add_to_no_connect  rxpolarity10 1 In
      add_to_no_connect  rxpolarity11 1 In
      add_to_no_connect  rxpolarity12 1 In
      add_to_no_connect  rxpolarity13 1 In
      add_to_no_connect  rxpolarity14 1 In
      add_to_no_connect  rxpolarity15 1 In
      add_to_no_connect  txcompl8  1 In
      add_to_no_connect  txcompl9  1 In
      add_to_no_connect  txcompl10 1 In
      add_to_no_connect  txcompl11 1 In
      add_to_no_connect  txcompl12 1 In
      add_to_no_connect  txcompl13 1 In
      add_to_no_connect  txcompl14 1 In
      add_to_no_connect  txcompl15 1 In
      add_to_no_connect  txdata8  32 In
      add_to_no_connect  txdata9  32 In
      add_to_no_connect  txdata10 32 In
      add_to_no_connect  txdata11 32 In
      add_to_no_connect  txdata12 32 In
      add_to_no_connect  txdata13 32 In
      add_to_no_connect  txdata14 32 In
      add_to_no_connect  txdata15 32 In
      add_to_no_connect  txdatak8  4 In
      add_to_no_connect  txdatak9  4 In
      add_to_no_connect  txdatak10 4 In
      add_to_no_connect  txdatak11 4 In
      add_to_no_connect  txdatak12 4 In
      add_to_no_connect  txdatak13 4 In
      add_to_no_connect  txdatak14 4 In
      add_to_no_connect  txdatak15 4 In
      add_to_no_connect  txdetectrx8  1 In
      add_to_no_connect  txdetectrx9  1 In
      add_to_no_connect  txdetectrx10 1 In
      add_to_no_connect  txdetectrx11 1 In
      add_to_no_connect  txdetectrx12 1 In
      add_to_no_connect  txdetectrx13 1 In
      add_to_no_connect  txdetectrx14 1 In
      add_to_no_connect  txdetectrx15 1 In
      add_to_no_connect  txelecidle8  1 In
      add_to_no_connect  txelecidle9  1 In
      add_to_no_connect  txelecidle10 1 In
      add_to_no_connect  txelecidle11 1 In
      add_to_no_connect  txelecidle12 1 In
      add_to_no_connect  txelecidle13 1 In
      add_to_no_connect  txelecidle14 1 In
      add_to_no_connect  txelecidle15 1 In
      add_to_no_connect  txdeemph8  1 In
      add_to_no_connect  txdeemph9  1 In
      add_to_no_connect  txdeemph10 1 In
      add_to_no_connect  txdeemph11 1 In
      add_to_no_connect  txdeemph12 1 In
      add_to_no_connect  txdeemph13 1 In
      add_to_no_connect  txdeemph14 1 In
      add_to_no_connect  txdeemph15 1 In
      add_to_no_connect  txmargin8  3 In
      add_to_no_connect  txmargin9  3 In
      add_to_no_connect  txmargin10 3 In
      add_to_no_connect  txmargin11 3 In
      add_to_no_connect  txmargin12 3 In
      add_to_no_connect  txmargin13 3 In
      add_to_no_connect  txmargin14 3 In
      add_to_no_connect  txmargin15 3 In
      add_to_no_connect  txswing8  1 In
      add_to_no_connect  txswing9  1 In
      add_to_no_connect  txswing10 1 In
      add_to_no_connect  txswing11 1 In
      add_to_no_connect  txswing12 1 In
      add_to_no_connect  txswing13 1 In
      add_to_no_connect  txswing14 1 In
      add_to_no_connect  txswing15 1 In
      add_to_no_connect  phystatus8  1 Out
      add_to_no_connect  phystatus9  1 Out
      add_to_no_connect  phystatus10 1 Out
      add_to_no_connect  phystatus11 1 Out
      add_to_no_connect  phystatus12 1 Out
      add_to_no_connect  phystatus13 1 Out
      add_to_no_connect  phystatus14 1 Out
      add_to_no_connect  phystatus15 1 Out
      add_to_no_connect  rxdata8  32 Out
      add_to_no_connect  rxdata9  32 Out
      add_to_no_connect  rxdata10 32 Out
      add_to_no_connect  rxdata11 32 Out
      add_to_no_connect  rxdata12 32 Out
      add_to_no_connect  rxdata13 32 Out
      add_to_no_connect  rxdata14 32 Out
      add_to_no_connect  rxdata15 32 Out
      add_to_no_connect  rxdatak8  4 Out
      add_to_no_connect  rxdatak9  4 Out
      add_to_no_connect  rxdatak10 4 Out
      add_to_no_connect  rxdatak11 4 Out
      add_to_no_connect  rxdatak12 4 Out
      add_to_no_connect  rxdatak13 4 Out
      add_to_no_connect  rxdatak14 4 Out
      add_to_no_connect  rxdatak15 4 Out
      add_to_no_connect  rxelecidle8  1 Out
      add_to_no_connect  rxelecidle9  1 Out
      add_to_no_connect  rxelecidle10 1 Out
      add_to_no_connect  rxelecidle11 1 Out
      add_to_no_connect  rxelecidle12 1 Out
      add_to_no_connect  rxelecidle13 1 Out
      add_to_no_connect  rxelecidle14 1 Out
      add_to_no_connect  rxelecidle15 1 Out
      add_to_no_connect  rxstatus8  3 Out
      add_to_no_connect  rxstatus9  3 Out
      add_to_no_connect  rxstatus10 3 Out
      add_to_no_connect  rxstatus11 3 Out
      add_to_no_connect  rxstatus12 3 Out
      add_to_no_connect  rxstatus13 3 Out
      add_to_no_connect  rxstatus14 3 Out
      add_to_no_connect  rxstatus15 3 Out
      add_to_no_connect  rxvalid8  1 Out
      add_to_no_connect  rxvalid9  1 Out
      add_to_no_connect  rxvalid10 1 Out
      add_to_no_connect  rxvalid11 1 Out
      add_to_no_connect  rxvalid12 1 Out
      add_to_no_connect  rxvalid13 1 Out
      add_to_no_connect  rxvalid14 1 Out
      add_to_no_connect  rxvalid15 1 Out
      add_to_no_connect  rxdataskip8  1 Out
      add_to_no_connect  rxdataskip9  1 Out
      add_to_no_connect  rxdataskip10 1 Out
      add_to_no_connect  rxdataskip11 1 Out
      add_to_no_connect  rxdataskip12 1 Out
      add_to_no_connect  rxdataskip13 1 Out
      add_to_no_connect  rxdataskip14 1 Out
      add_to_no_connect  rxdataskip15 1 Out
      add_to_no_connect  rxblkst8   1 Out
      add_to_no_connect  rxblkst9   1 Out
      add_to_no_connect  rxblkst10  1 Out
      add_to_no_connect  rxblkst11  1 Out
      add_to_no_connect  rxblkst12  1 Out
      add_to_no_connect  rxblkst13  1 Out
      add_to_no_connect  rxblkst14  1 Out
      add_to_no_connect  rxblkst15  1 Out
      add_to_no_connect  rxsynchd8   2 Out
      add_to_no_connect  rxsynchd9   2 Out
      add_to_no_connect  rxsynchd10  2 Out
      add_to_no_connect  rxsynchd11  2 Out
      add_to_no_connect  rxsynchd12  2 Out
      add_to_no_connect  rxsynchd13  2 Out
      add_to_no_connect  rxsynchd14  2 Out
      add_to_no_connect  rxsynchd15  2 Out
      add_to_no_connect  currentcoeff8   18 In
      add_to_no_connect  currentcoeff9   18 In
      add_to_no_connect  currentcoeff10  18 In
      add_to_no_connect  currentcoeff11  18 In
      add_to_no_connect  currentcoeff12  18 In
      add_to_no_connect  currentcoeff13  18 In
      add_to_no_connect  currentcoeff14  18 In
      add_to_no_connect  currentcoeff15  18 In
      add_to_no_connect  currentrxpreset8   3 In
      add_to_no_connect  currentrxpreset9   3 In
      add_to_no_connect  currentrxpreset10  3 In
      add_to_no_connect  currentrxpreset11  3 In
      add_to_no_connect  currentrxpreset12  3 In
      add_to_no_connect  currentrxpreset13  3 In
      add_to_no_connect  currentrxpreset14  3 In
      add_to_no_connect  currentrxpreset15  3 In
      add_to_no_connect  txsynchd8   2 In
      add_to_no_connect  txsynchd9   2 In
      add_to_no_connect  txsynchd10  2 In
      add_to_no_connect  txsynchd11  2 In
      add_to_no_connect  txsynchd12  2 In
      add_to_no_connect  txsynchd13  2 In
      add_to_no_connect  txsynchd14  2 In
      add_to_no_connect  txsynchd15  2 In
      add_to_no_connect  txblkst8   1 In
      add_to_no_connect  txblkst9   1 In
      add_to_no_connect  txblkst10  1 In
      add_to_no_connect  txblkst11  1 In
      add_to_no_connect  txblkst12  1 In
      add_to_no_connect  txblkst13  1 In
      add_to_no_connect  txblkst14  1 In
      add_to_no_connect  txblkst15  1 In
      add_to_no_connect  txdataskip8   1 In
      add_to_no_connect  txdataskip9   1 In
      add_to_no_connect  txdataskip10  1 In
      add_to_no_connect  txdataskip11  1 In
      add_to_no_connect  txdataskip12  1 In
      add_to_no_connect  txdataskip13  1 In
      add_to_no_connect  txdataskip14  1 In
      add_to_no_connect  txdataskip15  1 In
      add_to_no_connect  rate8   2 In
      add_to_no_connect  rate9   2 In
      add_to_no_connect  rate10  2 In
      add_to_no_connect  rate11  2 In
      add_to_no_connect  rate12  2 In
      add_to_no_connect  rate13  2 In
      add_to_no_connect  rate14  2 In
      add_to_no_connect  rate15  2 In
   } elseif { $nlane == 8 } {
     add_interface_port hip_pipe dirfeedback0 dirfeedback0  Output 6
     add_interface_port hip_pipe dirfeedback1 dirfeedback1  Output 6
     add_interface_port hip_pipe dirfeedback2 dirfeedback2  Output 6
     add_interface_port hip_pipe dirfeedback3 dirfeedback3  Output 6
     add_interface_port hip_pipe dirfeedback4 dirfeedback4  Output 6
     add_interface_port hip_pipe dirfeedback5 dirfeedback5  Output 6
     add_interface_port hip_pipe dirfeedback6 dirfeedback6  Output 6
     add_interface_port hip_pipe dirfeedback7 dirfeedback7  Output 6
      add_interface_port hip_pipe rxeqeval0     rxeqeval0      Input 1
      add_interface_port hip_pipe rxeqeval1     rxeqeval1      Input 1
      add_interface_port hip_pipe rxeqeval2     rxeqeval2      Input 1
      add_interface_port hip_pipe rxeqeval3     rxeqeval3      Input 1
      add_interface_port hip_pipe rxeqeval4     rxeqeval4      Input 1
      add_interface_port hip_pipe rxeqeval5     rxeqeval5      Input 1
      add_interface_port hip_pipe rxeqeval6     rxeqeval6      Input 1
      add_interface_port hip_pipe rxeqeval7     rxeqeval7      Input 1
          add_interface_port hip_pipe rxeqinprogress0     rxeqinprogress0      Input 1
          add_interface_port hip_pipe rxeqinprogress1     rxeqinprogress1      Input 1
          add_interface_port hip_pipe rxeqinprogress2     rxeqinprogress2      Input 1
          add_interface_port hip_pipe rxeqinprogress3     rxeqinprogress3      Input 1
      add_interface_port hip_pipe rxeqinprogress4     rxeqinprogress4      Input 1
          add_interface_port hip_pipe rxeqinprogress5     rxeqinprogress5      Input 1
          add_interface_port hip_pipe rxeqinprogress6     rxeqinprogress6      Input 1
          add_interface_port hip_pipe rxeqinprogress7     rxeqinprogress7      Input 1
      add_interface_port hip_pipe invalidreq0     invalidreq0      Input 1
          add_interface_port hip_pipe invalidreq1     invalidreq1      Input 1
          add_interface_port hip_pipe invalidreq2     invalidreq2      Input 1
          add_interface_port hip_pipe invalidreq3     invalidreq3      Input 1
      add_interface_port hip_pipe invalidreq4     invalidreq4      Input 1
          add_interface_port hip_pipe invalidreq5     invalidreq5      Input 1
          add_interface_port hip_pipe invalidreq6     invalidreq6      Input 1
          add_interface_port hip_pipe invalidreq7     invalidreq7      Input 1
      add_interface_port hip_pipe powerdown0     powerdown0      Input 2
     add_interface_port hip_pipe powerdown1     powerdown1      Input 2
     add_interface_port hip_pipe powerdown2     powerdown2      Input 2
     add_interface_port hip_pipe powerdown3     powerdown3      Input 2
     add_interface_port hip_pipe powerdown4     powerdown4      Input 2
     add_interface_port hip_pipe powerdown5     powerdown5      Input 2
     add_interface_port hip_pipe powerdown6     powerdown6      Input 2
     add_interface_port hip_pipe powerdown7     powerdown7      Input 2
     add_interface_port hip_pipe rxpolarity0    rxpolarity0     Input 1
     add_interface_port hip_pipe rxpolarity1    rxpolarity1     Input 1
     add_interface_port hip_pipe rxpolarity2    rxpolarity2     Input 1
     add_interface_port hip_pipe rxpolarity3    rxpolarity3     Input 1
     add_interface_port hip_pipe rxpolarity4    rxpolarity4     Input 1
     add_interface_port hip_pipe rxpolarity5    rxpolarity5     Input 1
     add_interface_port hip_pipe rxpolarity6    rxpolarity6     Input 1
     add_interface_port hip_pipe rxpolarity7    rxpolarity7     Input 1
     add_interface_port hip_pipe txcompl0       txcompl0        Input 1
     add_interface_port hip_pipe txcompl1       txcompl1        Input 1
     add_interface_port hip_pipe txcompl2       txcompl2        Input 1
     add_interface_port hip_pipe txcompl3       txcompl3        Input 1
     add_interface_port hip_pipe txcompl4       txcompl4        Input 1
     add_interface_port hip_pipe txcompl5       txcompl5        Input 1
     add_interface_port hip_pipe txcompl6       txcompl6        Input 1
     add_interface_port hip_pipe txcompl7       txcompl7        Input 1
     add_interface_port hip_pipe txdata0        txdata0         Input 32
     add_interface_port hip_pipe txdata1        txdata1         Input 32
     add_interface_port hip_pipe txdata2        txdata2         Input 32
     add_interface_port hip_pipe txdata3        txdata3         Input 32
     add_interface_port hip_pipe txdata4        txdata4         Input 32
     add_interface_port hip_pipe txdata5        txdata5         Input 32
     add_interface_port hip_pipe txdata6        txdata6         Input 32
     add_interface_port hip_pipe txdata7        txdata7         Input 32
     add_interface_port hip_pipe txdatak0       txdatak0        Input 4
     add_interface_port hip_pipe txdatak1       txdatak1        Input 4
     add_interface_port hip_pipe txdatak2       txdatak2        Input 4
     add_interface_port hip_pipe txdatak3       txdatak3        Input 4
     add_interface_port hip_pipe txdatak4       txdatak4        Input 4
     add_interface_port hip_pipe txdatak5       txdatak5        Input 4
     add_interface_port hip_pipe txdatak6       txdatak6        Input 4
     add_interface_port hip_pipe txdatak7       txdatak7        Input 4
     add_interface_port hip_pipe txdetectrx0    txdetectrx0     Input 1
     add_interface_port hip_pipe txdetectrx1    txdetectrx1     Input 1
     add_interface_port hip_pipe txdetectrx2    txdetectrx2     Input 1
     add_interface_port hip_pipe txdetectrx3    txdetectrx3     Input 1
     add_interface_port hip_pipe txdetectrx4    txdetectrx4     Input 1
     add_interface_port hip_pipe txdetectrx5    txdetectrx5     Input 1
     add_interface_port hip_pipe txdetectrx6    txdetectrx6     Input 1
     add_interface_port hip_pipe txdetectrx7    txdetectrx7     Input 1
     add_interface_port hip_pipe txelecidle0    txelecidle0     Input 1
     add_interface_port hip_pipe txelecidle1    txelecidle1     Input 1
     add_interface_port hip_pipe txelecidle2    txelecidle2     Input 1
     add_interface_port hip_pipe txelecidle3    txelecidle3     Input 1
     add_interface_port hip_pipe txelecidle4    txelecidle4     Input 1
     add_interface_port hip_pipe txelecidle5    txelecidle5     Input 1
     add_interface_port hip_pipe txelecidle6    txelecidle6     Input 1
     add_interface_port hip_pipe txelecidle7    txelecidle7     Input 1
     add_interface_port hip_pipe txdeemph0      txdeemph0       Input 1
     add_interface_port hip_pipe txdeemph1      txdeemph1       Input 1
     add_interface_port hip_pipe txdeemph2      txdeemph2       Input 1
     add_interface_port hip_pipe txdeemph3      txdeemph3       Input 1
     add_interface_port hip_pipe txdeemph4      txdeemph4       Input 1
     add_interface_port hip_pipe txdeemph5      txdeemph5       Input 1
     add_interface_port hip_pipe txdeemph6      txdeemph6       Input 1
     add_interface_port hip_pipe txdeemph7      txdeemph7       Input 1
     add_interface_port hip_pipe txmargin0      txmargin0       Input 3
     add_interface_port hip_pipe txmargin1      txmargin1       Input 3
     add_interface_port hip_pipe txmargin2      txmargin2       Input 3
     add_interface_port hip_pipe txmargin3      txmargin3       Input 3
     add_interface_port hip_pipe txmargin4      txmargin4       Input 3
     add_interface_port hip_pipe txmargin5      txmargin5       Input 3
     add_interface_port hip_pipe txmargin6      txmargin6       Input 3
     add_interface_port hip_pipe txmargin7      txmargin7       Input 3
     add_interface_port hip_pipe txswing0       txswing0        Input 1
     add_interface_port hip_pipe txswing1       txswing1        Input 1
     add_interface_port hip_pipe txswing2       txswing2        Input 1
     add_interface_port hip_pipe txswing3       txswing3        Input 1
     add_interface_port hip_pipe txswing4       txswing4        Input 1
     add_interface_port hip_pipe txswing5       txswing5        Input 1
     add_interface_port hip_pipe txswing6       txswing6        Input 1
     add_interface_port hip_pipe txswing7       txswing7        Input 1
     add_interface_port hip_pipe phystatus0     phystatus0      Output  1
     add_interface_port hip_pipe phystatus1     phystatus1      Output  1
     add_interface_port hip_pipe phystatus2     phystatus2      Output  1
     add_interface_port hip_pipe phystatus3     phystatus3      Output  1
     add_interface_port hip_pipe phystatus4     phystatus4      Output  1
     add_interface_port hip_pipe phystatus5     phystatus5      Output  1
     add_interface_port hip_pipe phystatus6     phystatus6      Output  1
     add_interface_port hip_pipe phystatus7     phystatus7      Output  1
     add_interface_port hip_pipe rxdata0        rxdata0         Output  32
     add_interface_port hip_pipe rxdata1        rxdata1         Output  32
     add_interface_port hip_pipe rxdata2        rxdata2         Output  32
     add_interface_port hip_pipe rxdata3        rxdata3         Output  32
     add_interface_port hip_pipe rxdata4        rxdata4         Output  32
     add_interface_port hip_pipe rxdata5        rxdata5         Output  32
     add_interface_port hip_pipe rxdata6        rxdata6         Output  32
     add_interface_port hip_pipe rxdata7        rxdata7         Output  32
     add_interface_port hip_pipe rxdatak0       rxdatak0        Output  4
     add_interface_port hip_pipe rxdatak1       rxdatak1        Output  4
     add_interface_port hip_pipe rxdatak2       rxdatak2        Output  4
     add_interface_port hip_pipe rxdatak3       rxdatak3        Output  4
     add_interface_port hip_pipe rxdatak4       rxdatak4        Output  4
     add_interface_port hip_pipe rxdatak5       rxdatak5        Output  4
     add_interface_port hip_pipe rxdatak6       rxdatak6        Output  4
     add_interface_port hip_pipe rxdatak7       rxdatak7        Output  4
     add_interface_port hip_pipe rxelecidle0    rxelecidle0     Output  1
     add_interface_port hip_pipe rxelecidle1    rxelecidle1     Output  1
     add_interface_port hip_pipe rxelecidle2    rxelecidle2     Output  1
     add_interface_port hip_pipe rxelecidle3    rxelecidle3     Output  1
     add_interface_port hip_pipe rxelecidle4    rxelecidle4     Output  1
     add_interface_port hip_pipe rxelecidle5    rxelecidle5     Output  1
     add_interface_port hip_pipe rxelecidle6    rxelecidle6     Output  1
     add_interface_port hip_pipe rxelecidle7    rxelecidle7     Output  1
     add_interface_port hip_pipe rxstatus0      rxstatus0       Output  3
     add_interface_port hip_pipe rxstatus1      rxstatus1       Output  3
     add_interface_port hip_pipe rxstatus2      rxstatus2       Output  3
     add_interface_port hip_pipe rxstatus3      rxstatus3       Output  3
     add_interface_port hip_pipe rxstatus4      rxstatus4       Output  3
     add_interface_port hip_pipe rxstatus5      rxstatus5       Output  3
     add_interface_port hip_pipe rxstatus6      rxstatus6       Output  3
     add_interface_port hip_pipe rxstatus7      rxstatus7       Output  3
     add_interface_port hip_pipe rxvalid0       rxvalid0        Output  1
     add_interface_port hip_pipe rxvalid1       rxvalid1        Output  1
     add_interface_port hip_pipe rxvalid2       rxvalid2        Output  1
     add_interface_port hip_pipe rxvalid3       rxvalid3        Output  1
     add_interface_port hip_pipe rxvalid4       rxvalid4        Output  1
     add_interface_port hip_pipe rxvalid5       rxvalid5        Output  1
     add_interface_port hip_pipe rxvalid6       rxvalid6        Output  1
     add_interface_port hip_pipe rxvalid7       rxvalid7        Output  1
     add_interface_port hip_pipe rxdataskip0    rxdataskip0     Output  1
     add_interface_port hip_pipe rxdataskip1    rxdataskip1     Output  1
     add_interface_port hip_pipe rxdataskip2    rxdataskip2     Output  1
     add_interface_port hip_pipe rxdataskip3    rxdataskip3     Output  1
     add_interface_port hip_pipe rxdataskip4    rxdataskip4     Output  1
     add_interface_port hip_pipe rxdataskip5    rxdataskip5     Output  1
     add_interface_port hip_pipe rxdataskip6    rxdataskip6     Output  1
     add_interface_port hip_pipe rxdataskip7    rxdataskip7     Output  1
     add_interface_port hip_pipe rxblkst0       rxblkst0        Output  1
     add_interface_port hip_pipe rxblkst1       rxblkst1        Output  1
     add_interface_port hip_pipe rxblkst2       rxblkst2        Output  1
     add_interface_port hip_pipe rxblkst3       rxblkst3        Output  1
     add_interface_port hip_pipe rxblkst4       rxblkst4        Output  1
     add_interface_port hip_pipe rxblkst5       rxblkst5        Output  1
     add_interface_port hip_pipe rxblkst6       rxblkst6        Output  1
     add_interface_port hip_pipe rxblkst7       rxblkst7        Output  1
     add_interface_port hip_pipe rxsynchd0      rxsynchd0       Output  2
     add_interface_port hip_pipe rxsynchd1      rxsynchd1       Output  2
     add_interface_port hip_pipe rxsynchd2      rxsynchd2       Output  2
     add_interface_port hip_pipe rxsynchd3      rxsynchd3       Output  2
     add_interface_port hip_pipe rxsynchd4      rxsynchd4       Output  2
     add_interface_port hip_pipe rxsynchd5      rxsynchd5       Output  2
     add_interface_port hip_pipe rxsynchd6      rxsynchd6       Output  2
     add_interface_port hip_pipe rxsynchd7      rxsynchd7       Output  2
     add_interface_port hip_pipe currentcoeff0  currentcoeff0   Input  18
     add_interface_port hip_pipe currentcoeff1  currentcoeff1   Input  18
     add_interface_port hip_pipe currentcoeff2  currentcoeff2   Input  18
     add_interface_port hip_pipe currentcoeff3  currentcoeff3   Input  18
     add_interface_port hip_pipe currentcoeff4  currentcoeff4   Input  18
     add_interface_port hip_pipe currentcoeff5  currentcoeff5   Input  18
     add_interface_port hip_pipe currentcoeff6  currentcoeff6   Input  18
     add_interface_port hip_pipe currentcoeff7  currentcoeff7   Input  18
     add_interface_port hip_pipe currentrxpreset0       currentrxpreset0       Input  3
     add_interface_port hip_pipe currentrxpreset1       currentrxpreset1       Input  3
     add_interface_port hip_pipe currentrxpreset2       currentrxpreset2       Input  3
     add_interface_port hip_pipe currentrxpreset3       currentrxpreset3       Input  3
     add_interface_port hip_pipe currentrxpreset4       currentrxpreset4       Input  3
     add_interface_port hip_pipe currentrxpreset5       currentrxpreset5       Input  3
     add_interface_port hip_pipe currentrxpreset6       currentrxpreset6       Input  3
     add_interface_port hip_pipe currentrxpreset7       currentrxpreset7       Input  3
     add_interface_port hip_pipe txsynchd0      txsynchd0        Input  2
     add_interface_port hip_pipe txsynchd1      txsynchd1        Input  2
     add_interface_port hip_pipe txsynchd2      txsynchd2        Input  2
     add_interface_port hip_pipe txsynchd3      txsynchd3        Input  2
     add_interface_port hip_pipe txsynchd4      txsynchd4        Input  2
     add_interface_port hip_pipe txsynchd5      txsynchd5        Input  2
     add_interface_port hip_pipe txsynchd6      txsynchd6        Input  2
     add_interface_port hip_pipe txsynchd7      txsynchd7        Input  2
     add_interface_port hip_pipe txblkst0       txblkst0         Input  1
     add_interface_port hip_pipe txblkst1       txblkst1         Input  1
     add_interface_port hip_pipe txblkst2       txblkst2         Input  1
     add_interface_port hip_pipe txblkst3       txblkst3         Input  1
     add_interface_port hip_pipe txblkst4       txblkst4         Input  1
     add_interface_port hip_pipe txblkst5       txblkst5         Input  1
     add_interface_port hip_pipe txblkst6       txblkst6         Input  1
     add_interface_port hip_pipe txblkst7       txblkst7         Input  1
     add_interface_port hip_pipe txdataskip0    txdataskip0      Input  1
     add_interface_port hip_pipe txdataskip1    txdataskip1      Input  1
     add_interface_port hip_pipe txdataskip2    txdataskip2      Input  1
     add_interface_port hip_pipe txdataskip3    txdataskip3      Input  1
     add_interface_port hip_pipe txdataskip4    txdataskip4      Input  1
     add_interface_port hip_pipe txdataskip5    txdataskip5      Input  1
     add_interface_port hip_pipe txdataskip6    txdataskip6      Input  1
     add_interface_port hip_pipe txdataskip7    txdataskip7      Input  1
     add_interface_port hip_pipe rate0          rate0            Input  2
     add_interface_port hip_pipe rate1          rate1            Input  2
     add_interface_port hip_pipe rate2          rate2            Input  2
     add_interface_port hip_pipe rate3          rate3            Input  2
     add_interface_port hip_pipe rate4          rate4            Input  2
     add_interface_port hip_pipe rate5          rate5            Input  2
     add_interface_port hip_pipe rate6          rate6            Input  2
     add_interface_port hip_pipe rate7          rate7            Input  2
      add_to_no_connect  dirfeedback8  6 Out
      add_to_no_connect  dirfeedback9  6 Out
      add_to_no_connect  dirfeedback10 6 Out
      add_to_no_connect  dirfeedback11 6 Out
      add_to_no_connect  dirfeedback12 6 Out
      add_to_no_connect  dirfeedback13 6 Out
      add_to_no_connect  dirfeedback14 6 Out
      add_to_no_connect  dirfeedback15 6 Out
      add_to_no_connect  rxeqeval8  1 In
      add_to_no_connect  rxeqeval9  1 In
      add_to_no_connect  rxeqeval10 1 In
      add_to_no_connect  rxeqeval11 1 In
      add_to_no_connect  rxeqeval12 1 In
      add_to_no_connect  rxeqeval13 1 In
      add_to_no_connect  rxeqeval14 1 In
      add_to_no_connect  rxeqeval15 1 In
      add_to_no_connect  rxeqinprogress8  1 In
      add_to_no_connect  rxeqinprogress9  1 In
      add_to_no_connect  rxeqinprogress10 1 In
      add_to_no_connect  rxeqinprogress11 1 In
      add_to_no_connect  rxeqinprogress12 1 In
      add_to_no_connect  rxeqinprogress13 1 In
      add_to_no_connect  rxeqinprogress14 1 In
      add_to_no_connect  rxeqinprogress15 1 In
      add_to_no_connect  invalidreq8  1 In
      add_to_no_connect  invalidreq9  1 In
      add_to_no_connect  invalidreq10 1 In
      add_to_no_connect  invalidreq11 1 In
      add_to_no_connect  invalidreq12 1 In
      add_to_no_connect  invalidreq13 1 In
      add_to_no_connect  invalidreq14 1 In
      add_to_no_connect  invalidreq15 1 In
      add_to_no_connect  powerdown8  2 In
      add_to_no_connect  powerdown9  2 In
      add_to_no_connect  powerdown10 2 In
      add_to_no_connect  powerdown11 2 In
      add_to_no_connect  powerdown12 2 In
      add_to_no_connect  powerdown13 2 In
      add_to_no_connect  powerdown14 2 In
      add_to_no_connect  powerdown15 2 In
      add_to_no_connect  rxpolarity8  1 In
      add_to_no_connect  rxpolarity9  1 In
      add_to_no_connect  rxpolarity10 1 In
      add_to_no_connect  rxpolarity11 1 In
      add_to_no_connect  rxpolarity12 1 In
      add_to_no_connect  rxpolarity13 1 In
      add_to_no_connect  rxpolarity14 1 In
      add_to_no_connect  rxpolarity15 1 In
      add_to_no_connect  txcompl8  1 In
      add_to_no_connect  txcompl9  1 In
      add_to_no_connect  txcompl10 1 In
      add_to_no_connect  txcompl11 1 In
      add_to_no_connect  txcompl12 1 In
      add_to_no_connect  txcompl13 1 In
      add_to_no_connect  txcompl14 1 In
      add_to_no_connect  txcompl15 1 In
      add_to_no_connect  txdata8  32 In
      add_to_no_connect  txdata9  32 In
      add_to_no_connect  txdata10 32 In
      add_to_no_connect  txdata11 32 In
      add_to_no_connect  txdata12 32 In
      add_to_no_connect  txdata13 32 In
      add_to_no_connect  txdata14 32 In
      add_to_no_connect  txdata15 32 In
      add_to_no_connect  txdatak8  4 In
      add_to_no_connect  txdatak9  4 In
      add_to_no_connect  txdatak10 4 In
      add_to_no_connect  txdatak11 4 In
      add_to_no_connect  txdatak12 4 In
      add_to_no_connect  txdatak13 4 In
      add_to_no_connect  txdatak14 4 In
      add_to_no_connect  txdatak15 4 In
      add_to_no_connect  txdetectrx8  1 In
      add_to_no_connect  txdetectrx9  1 In
      add_to_no_connect  txdetectrx10 1 In
      add_to_no_connect  txdetectrx11 1 In
      add_to_no_connect  txdetectrx12 1 In
      add_to_no_connect  txdetectrx13 1 In
      add_to_no_connect  txdetectrx14 1 In
      add_to_no_connect  txdetectrx15 1 In
      add_to_no_connect  txelecidle8  1 In
      add_to_no_connect  txelecidle9  1 In
      add_to_no_connect  txelecidle10 1 In
      add_to_no_connect  txelecidle11 1 In
      add_to_no_connect  txelecidle12 1 In
      add_to_no_connect  txelecidle13 1 In
      add_to_no_connect  txelecidle14 1 In
      add_to_no_connect  txelecidle15 1 In
      add_to_no_connect  txdeemph8  1 In
      add_to_no_connect  txdeemph9  1 In
      add_to_no_connect  txdeemph10 1 In
      add_to_no_connect  txdeemph11 1 In
      add_to_no_connect  txdeemph12 1 In
      add_to_no_connect  txdeemph13 1 In
      add_to_no_connect  txdeemph14 1 In
      add_to_no_connect  txdeemph15 1 In
      add_to_no_connect  txmargin8  3 In
      add_to_no_connect  txmargin9  3 In
      add_to_no_connect  txmargin10 3 In
      add_to_no_connect  txmargin11 3 In
      add_to_no_connect  txmargin12 3 In
      add_to_no_connect  txmargin13 3 In
      add_to_no_connect  txmargin14 3 In
      add_to_no_connect  txmargin15 3 In
      add_to_no_connect  txswing8  1 In
      add_to_no_connect  txswing9  1 In
      add_to_no_connect  txswing10 1 In
      add_to_no_connect  txswing11 1 In
      add_to_no_connect  txswing12 1 In
      add_to_no_connect  txswing13 1 In
      add_to_no_connect  txswing14 1 In
      add_to_no_connect  txswing15 1 In
      add_to_no_connect  phystatus8  1 Out
      add_to_no_connect  phystatus9  1 Out
      add_to_no_connect  phystatus10 1 Out
      add_to_no_connect  phystatus11 1 Out
      add_to_no_connect  phystatus12 1 Out
      add_to_no_connect  phystatus13 1 Out
      add_to_no_connect  phystatus14 1 Out
      add_to_no_connect  phystatus15 1 Out
      add_to_no_connect  rxdata8  32 Out
      add_to_no_connect  rxdata9  32 Out
      add_to_no_connect  rxdata10 32 Out
      add_to_no_connect  rxdata11 32 Out
      add_to_no_connect  rxdata12 32 Out
      add_to_no_connect  rxdata13 32 Out
      add_to_no_connect  rxdata14 32 Out
      add_to_no_connect  rxdata15 32 Out
      add_to_no_connect  rxdatak8  4 Out
      add_to_no_connect  rxdatak9  4 Out
      add_to_no_connect  rxdatak10 4 Out
      add_to_no_connect  rxdatak11 4 Out
      add_to_no_connect  rxdatak12 4 Out
      add_to_no_connect  rxdatak13 4 Out
      add_to_no_connect  rxdatak14 4 Out
      add_to_no_connect  rxdatak15 4 Out
      add_to_no_connect  rxelecidle8  1 Out
      add_to_no_connect  rxelecidle9  1 Out
      add_to_no_connect  rxelecidle10 1 Out
      add_to_no_connect  rxelecidle11 1 Out
      add_to_no_connect  rxelecidle12 1 Out
      add_to_no_connect  rxelecidle13 1 Out
      add_to_no_connect  rxelecidle14 1 Out
      add_to_no_connect  rxelecidle15 1 Out
      add_to_no_connect  rxstatus8  3 Out
      add_to_no_connect  rxstatus9  3 Out
      add_to_no_connect  rxstatus10 3 Out
      add_to_no_connect  rxstatus11 3 Out
      add_to_no_connect  rxstatus12 3 Out
      add_to_no_connect  rxstatus13 3 Out
      add_to_no_connect  rxstatus14 3 Out
      add_to_no_connect  rxstatus15 3 Out
      add_to_no_connect  rxvalid8  1 Out
      add_to_no_connect  rxvalid9  1 Out
      add_to_no_connect  rxvalid10 1 Out
      add_to_no_connect  rxvalid11 1 Out
      add_to_no_connect  rxvalid12 1 Out
      add_to_no_connect  rxvalid13 1 Out
      add_to_no_connect  rxvalid14 1 Out
      add_to_no_connect  rxvalid15 1 Out
      add_to_no_connect  rxdataskip8  1 Out
      add_to_no_connect  rxdataskip9  1 Out
      add_to_no_connect  rxdataskip10 1 Out
      add_to_no_connect  rxdataskip11 1 Out
      add_to_no_connect  rxdataskip12 1 Out
      add_to_no_connect  rxdataskip13 1 Out
      add_to_no_connect  rxdataskip14 1 Out
      add_to_no_connect  rxdataskip15 1 Out
      add_to_no_connect  rxblkst8   1 Out
      add_to_no_connect  rxblkst9   1 Out
      add_to_no_connect  rxblkst10  1 Out
      add_to_no_connect  rxblkst11  1 Out
      add_to_no_connect  rxblkst12  1 Out
      add_to_no_connect  rxblkst13  1 Out
      add_to_no_connect  rxblkst14  1 Out
      add_to_no_connect  rxblkst15  1 Out
      add_to_no_connect  rxsynchd8   2 Out
      add_to_no_connect  rxsynchd9   2 Out
      add_to_no_connect  rxsynchd10  2 Out
      add_to_no_connect  rxsynchd11  2 Out
      add_to_no_connect  rxsynchd12  2 Out
      add_to_no_connect  rxsynchd13  2 Out
      add_to_no_connect  rxsynchd14  2 Out
      add_to_no_connect  rxsynchd15  2 Out
      add_to_no_connect  currentcoeff8   18 In
      add_to_no_connect  currentcoeff9   18 In
      add_to_no_connect  currentcoeff10  18 In
      add_to_no_connect  currentcoeff11  18 In
      add_to_no_connect  currentcoeff12  18 In
      add_to_no_connect  currentcoeff13  18 In
      add_to_no_connect  currentcoeff14  18 In
      add_to_no_connect  currentcoeff15  18 In
      add_to_no_connect  currentrxpreset8   3 In
      add_to_no_connect  currentrxpreset9   3 In
      add_to_no_connect  currentrxpreset10  3 In
      add_to_no_connect  currentrxpreset11  3 In
      add_to_no_connect  currentrxpreset12  3 In
      add_to_no_connect  currentrxpreset13  3 In
      add_to_no_connect  currentrxpreset14  3 In
      add_to_no_connect  currentrxpreset15  3 In
      add_to_no_connect  txsynchd8   2 In
      add_to_no_connect  txsynchd9   2 In
      add_to_no_connect  txsynchd10  2 In
      add_to_no_connect  txsynchd11  2 In
      add_to_no_connect  txsynchd12  2 In
      add_to_no_connect  txsynchd13  2 In
      add_to_no_connect  txsynchd14  2 In
      add_to_no_connect  txsynchd15  2 In
      add_to_no_connect  txblkst8   1 In
      add_to_no_connect  txblkst9   1 In
      add_to_no_connect  txblkst10  1 In
      add_to_no_connect  txblkst11  1 In
      add_to_no_connect  txblkst12  1 In
      add_to_no_connect  txblkst13  1 In
      add_to_no_connect  txblkst14  1 In
      add_to_no_connect  txblkst15  1 In
      add_to_no_connect  txdataskip8   1 In
      add_to_no_connect  txdataskip9   1 In
      add_to_no_connect  txdataskip10  1 In
      add_to_no_connect  txdataskip11  1 In
      add_to_no_connect  txdataskip12  1 In
      add_to_no_connect  txdataskip13  1 In
      add_to_no_connect  txdataskip14  1 In
      add_to_no_connect  txdataskip15  1 In
      add_to_no_connect  rate8   2 In
      add_to_no_connect  rate9   2 In
      add_to_no_connect  rate10  2 In
      add_to_no_connect  rate11  2 In
      add_to_no_connect  rate12  2 In
      add_to_no_connect  rate13  2 In
      add_to_no_connect  rate14  2 In
      add_to_no_connect  rate15  2 In

   } else {
     add_interface_port hip_pipe dirfeedback0 dirfeedback0  Output 6
     add_interface_port hip_pipe dirfeedback1 dirfeedback1  Output 6
     add_interface_port hip_pipe dirfeedback2 dirfeedback2  Output 6
     add_interface_port hip_pipe dirfeedback3 dirfeedback3  Output 6
     add_interface_port hip_pipe dirfeedback4 dirfeedback4  Output 6
     add_interface_port hip_pipe dirfeedback5 dirfeedback5  Output 6
     add_interface_port hip_pipe dirfeedback6 dirfeedback6  Output 6
     add_interface_port hip_pipe dirfeedback7 dirfeedback7  Output 6
      add_interface_port hip_pipe rxeqeval0     rxeqeval0      Input 1
      add_interface_port hip_pipe rxeqeval1     rxeqeval1      Input 1
      add_interface_port hip_pipe rxeqeval2     rxeqeval2      Input 1
      add_interface_port hip_pipe rxeqeval3     rxeqeval3      Input 1
      add_interface_port hip_pipe rxeqeval4     rxeqeval4      Input 1
      add_interface_port hip_pipe rxeqeval5     rxeqeval5      Input 1
      add_interface_port hip_pipe rxeqeval6     rxeqeval6      Input 1
      add_interface_port hip_pipe rxeqeval7     rxeqeval7      Input 1
          add_interface_port hip_pipe rxeqinprogress0     rxeqinprogress0      Input 1
          add_interface_port hip_pipe rxeqinprogress1     rxeqinprogress1      Input 1
          add_interface_port hip_pipe rxeqinprogress2     rxeqinprogress2      Input 1
          add_interface_port hip_pipe rxeqinprogress3     rxeqinprogress3      Input 1
      add_interface_port hip_pipe rxeqinprogress4     rxeqinprogress4      Input 1
          add_interface_port hip_pipe rxeqinprogress5     rxeqinprogress5      Input 1
          add_interface_port hip_pipe rxeqinprogress6     rxeqinprogress6      Input 1
          add_interface_port hip_pipe rxeqinprogress7     rxeqinprogress7      Input 1
      add_interface_port hip_pipe invalidreq0     invalidreq0      Input 1
          add_interface_port hip_pipe invalidreq1     invalidreq1      Input 1
          add_interface_port hip_pipe invalidreq2     invalidreq2      Input 1
          add_interface_port hip_pipe invalidreq3     invalidreq3      Input 1
      add_interface_port hip_pipe invalidreq4     invalidreq4      Input 1
          add_interface_port hip_pipe invalidreq5     invalidreq5      Input 1
          add_interface_port hip_pipe invalidreq6     invalidreq6      Input 1
          add_interface_port hip_pipe invalidreq7     invalidreq7      Input 1
      add_interface_port hip_pipe powerdown0     powerdown0      Input 2
     add_interface_port hip_pipe powerdown1     powerdown1      Input 2
     add_interface_port hip_pipe powerdown2     powerdown2      Input 2
     add_interface_port hip_pipe powerdown3     powerdown3      Input 2
     add_interface_port hip_pipe powerdown4     powerdown4      Input 2
     add_interface_port hip_pipe powerdown5     powerdown5      Input 2
     add_interface_port hip_pipe powerdown6     powerdown6      Input 2
     add_interface_port hip_pipe powerdown7     powerdown7      Input 2
     add_interface_port hip_pipe rxpolarity0    rxpolarity0     Input 1
     add_interface_port hip_pipe rxpolarity1    rxpolarity1     Input 1
     add_interface_port hip_pipe rxpolarity2    rxpolarity2     Input 1
     add_interface_port hip_pipe rxpolarity3    rxpolarity3     Input 1
     add_interface_port hip_pipe rxpolarity4    rxpolarity4     Input 1
     add_interface_port hip_pipe rxpolarity5    rxpolarity5     Input 1
     add_interface_port hip_pipe rxpolarity6    rxpolarity6     Input 1
     add_interface_port hip_pipe rxpolarity7    rxpolarity7     Input 1
     add_interface_port hip_pipe txcompl0       txcompl0        Input 1
     add_interface_port hip_pipe txcompl1       txcompl1        Input 1
     add_interface_port hip_pipe txcompl2       txcompl2        Input 1
     add_interface_port hip_pipe txcompl3       txcompl3        Input 1
     add_interface_port hip_pipe txcompl4       txcompl4        Input 1
     add_interface_port hip_pipe txcompl5       txcompl5        Input 1
     add_interface_port hip_pipe txcompl6       txcompl6        Input 1
     add_interface_port hip_pipe txcompl7       txcompl7        Input 1
     add_interface_port hip_pipe txdata0        txdata0         Input 32
     add_interface_port hip_pipe txdata1        txdata1         Input 32
     add_interface_port hip_pipe txdata2        txdata2         Input 32
     add_interface_port hip_pipe txdata3        txdata3         Input 32
     add_interface_port hip_pipe txdata4        txdata4         Input 32
     add_interface_port hip_pipe txdata5        txdata5         Input 32
     add_interface_port hip_pipe txdata6        txdata6         Input 32
     add_interface_port hip_pipe txdata7        txdata7         Input 32
     add_interface_port hip_pipe txdatak0       txdatak0        Input 4
     add_interface_port hip_pipe txdatak1       txdatak1        Input 4
     add_interface_port hip_pipe txdatak2       txdatak2        Input 4
     add_interface_port hip_pipe txdatak3       txdatak3        Input 4
     add_interface_port hip_pipe txdatak4       txdatak4        Input 4
     add_interface_port hip_pipe txdatak5       txdatak5        Input 4
     add_interface_port hip_pipe txdatak6       txdatak6        Input 4
     add_interface_port hip_pipe txdatak7       txdatak7        Input 4
     add_interface_port hip_pipe txdetectrx0    txdetectrx0     Input 1
     add_interface_port hip_pipe txdetectrx1    txdetectrx1     Input 1
     add_interface_port hip_pipe txdetectrx2    txdetectrx2     Input 1
     add_interface_port hip_pipe txdetectrx3    txdetectrx3     Input 1
     add_interface_port hip_pipe txdetectrx4    txdetectrx4     Input 1
     add_interface_port hip_pipe txdetectrx5    txdetectrx5     Input 1
     add_interface_port hip_pipe txdetectrx6    txdetectrx6     Input 1
     add_interface_port hip_pipe txdetectrx7    txdetectrx7     Input 1
     add_interface_port hip_pipe txelecidle0    txelecidle0     Input 1
     add_interface_port hip_pipe txelecidle1    txelecidle1     Input 1
     add_interface_port hip_pipe txelecidle2    txelecidle2     Input 1
     add_interface_port hip_pipe txelecidle3    txelecidle3     Input 1
     add_interface_port hip_pipe txelecidle4    txelecidle4     Input 1
     add_interface_port hip_pipe txelecidle5    txelecidle5     Input 1
     add_interface_port hip_pipe txelecidle6    txelecidle6     Input 1
     add_interface_port hip_pipe txelecidle7    txelecidle7     Input 1
     add_interface_port hip_pipe txdeemph0      txdeemph0       Input 1
     add_interface_port hip_pipe txdeemph1      txdeemph1       Input 1
     add_interface_port hip_pipe txdeemph2      txdeemph2       Input 1
     add_interface_port hip_pipe txdeemph3      txdeemph3       Input 1
     add_interface_port hip_pipe txdeemph4      txdeemph4       Input 1
     add_interface_port hip_pipe txdeemph5      txdeemph5       Input 1
     add_interface_port hip_pipe txdeemph6      txdeemph6       Input 1
     add_interface_port hip_pipe txdeemph7      txdeemph7       Input 1
     add_interface_port hip_pipe txmargin0      txmargin0       Input 3
     add_interface_port hip_pipe txmargin1      txmargin1       Input 3
     add_interface_port hip_pipe txmargin2      txmargin2       Input 3
     add_interface_port hip_pipe txmargin3      txmargin3       Input 3
     add_interface_port hip_pipe txmargin4      txmargin4       Input 3
     add_interface_port hip_pipe txmargin5      txmargin5       Input 3
     add_interface_port hip_pipe txmargin6      txmargin6       Input 3
     add_interface_port hip_pipe txmargin7      txmargin7       Input 3
     add_interface_port hip_pipe txswing0       txswing0        Input 1
     add_interface_port hip_pipe txswing1       txswing1        Input 1
     add_interface_port hip_pipe txswing2       txswing2        Input 1
     add_interface_port hip_pipe txswing3       txswing3        Input 1
     add_interface_port hip_pipe txswing4       txswing4        Input 1
     add_interface_port hip_pipe txswing5       txswing5        Input 1
     add_interface_port hip_pipe txswing6       txswing6        Input 1
     add_interface_port hip_pipe txswing7       txswing7        Input 1
     add_interface_port hip_pipe phystatus0     phystatus0      Output  1
     add_interface_port hip_pipe phystatus1     phystatus1      Output  1
     add_interface_port hip_pipe phystatus2     phystatus2      Output  1
     add_interface_port hip_pipe phystatus3     phystatus3      Output  1
     add_interface_port hip_pipe phystatus4     phystatus4      Output  1
     add_interface_port hip_pipe phystatus5     phystatus5      Output  1
     add_interface_port hip_pipe phystatus6     phystatus6      Output  1
     add_interface_port hip_pipe phystatus7     phystatus7      Output  1
     add_interface_port hip_pipe rxdata0        rxdata0         Output  32
     add_interface_port hip_pipe rxdata1        rxdata1         Output  32
     add_interface_port hip_pipe rxdata2        rxdata2         Output  32
     add_interface_port hip_pipe rxdata3        rxdata3         Output  32
     add_interface_port hip_pipe rxdata4        rxdata4         Output  32
     add_interface_port hip_pipe rxdata5        rxdata5         Output  32
     add_interface_port hip_pipe rxdata6        rxdata6         Output  32
     add_interface_port hip_pipe rxdata7        rxdata7         Output  32
     add_interface_port hip_pipe rxdatak0       rxdatak0        Output  4
     add_interface_port hip_pipe rxdatak1       rxdatak1        Output  4
     add_interface_port hip_pipe rxdatak2       rxdatak2        Output  4
     add_interface_port hip_pipe rxdatak3       rxdatak3        Output  4
     add_interface_port hip_pipe rxdatak4       rxdatak4        Output  4
     add_interface_port hip_pipe rxdatak5       rxdatak5        Output  4
     add_interface_port hip_pipe rxdatak6       rxdatak6        Output  4
     add_interface_port hip_pipe rxdatak7       rxdatak7        Output  4
     add_interface_port hip_pipe rxelecidle0    rxelecidle0     Output  1
     add_interface_port hip_pipe rxelecidle1    rxelecidle1     Output  1
     add_interface_port hip_pipe rxelecidle2    rxelecidle2     Output  1
     add_interface_port hip_pipe rxelecidle3    rxelecidle3     Output  1
     add_interface_port hip_pipe rxelecidle4    rxelecidle4     Output  1
     add_interface_port hip_pipe rxelecidle5    rxelecidle5     Output  1
     add_interface_port hip_pipe rxelecidle6    rxelecidle6     Output  1
     add_interface_port hip_pipe rxelecidle7    rxelecidle7     Output  1
     add_interface_port hip_pipe rxstatus0      rxstatus0       Output  3
     add_interface_port hip_pipe rxstatus1      rxstatus1       Output  3
     add_interface_port hip_pipe rxstatus2      rxstatus2       Output  3
     add_interface_port hip_pipe rxstatus3      rxstatus3       Output  3
     add_interface_port hip_pipe rxstatus4      rxstatus4       Output  3
     add_interface_port hip_pipe rxstatus5      rxstatus5       Output  3
     add_interface_port hip_pipe rxstatus6      rxstatus6       Output  3
     add_interface_port hip_pipe rxstatus7      rxstatus7       Output  3
     add_interface_port hip_pipe rxvalid0       rxvalid0        Output  1
     add_interface_port hip_pipe rxvalid1       rxvalid1        Output  1
     add_interface_port hip_pipe rxvalid2       rxvalid2        Output  1
     add_interface_port hip_pipe rxvalid3       rxvalid3        Output  1
     add_interface_port hip_pipe rxvalid4       rxvalid4        Output  1
     add_interface_port hip_pipe rxvalid5       rxvalid5        Output  1
     add_interface_port hip_pipe rxvalid6       rxvalid6        Output  1
     add_interface_port hip_pipe rxvalid7       rxvalid7        Output  1
     add_interface_port hip_pipe rxdataskip0    rxdataskip0     Output  1
     add_interface_port hip_pipe rxdataskip1    rxdataskip1     Output  1
     add_interface_port hip_pipe rxdataskip2    rxdataskip2     Output  1
     add_interface_port hip_pipe rxdataskip3    rxdataskip3     Output  1
     add_interface_port hip_pipe rxdataskip4    rxdataskip4     Output  1
     add_interface_port hip_pipe rxdataskip5    rxdataskip5     Output  1
     add_interface_port hip_pipe rxdataskip6    rxdataskip6     Output  1
     add_interface_port hip_pipe rxdataskip7    rxdataskip7     Output  1
     add_interface_port hip_pipe rxblkst0       rxblkst0        Output  1
     add_interface_port hip_pipe rxblkst1       rxblkst1        Output  1
     add_interface_port hip_pipe rxblkst2       rxblkst2        Output  1
     add_interface_port hip_pipe rxblkst3       rxblkst3        Output  1
     add_interface_port hip_pipe rxblkst4       rxblkst4        Output  1
     add_interface_port hip_pipe rxblkst5       rxblkst5        Output  1
     add_interface_port hip_pipe rxblkst6       rxblkst6        Output  1
     add_interface_port hip_pipe rxblkst7       rxblkst7        Output  1
     add_interface_port hip_pipe rxsynchd0      rxsynchd0       Output  2
     add_interface_port hip_pipe rxsynchd1      rxsynchd1       Output  2
     add_interface_port hip_pipe rxsynchd2      rxsynchd2       Output  2
     add_interface_port hip_pipe rxsynchd3      rxsynchd3       Output  2
     add_interface_port hip_pipe rxsynchd4      rxsynchd4       Output  2
     add_interface_port hip_pipe rxsynchd5      rxsynchd5       Output  2
     add_interface_port hip_pipe rxsynchd6      rxsynchd6       Output  2
     add_interface_port hip_pipe rxsynchd7      rxsynchd7       Output  2
     add_interface_port hip_pipe currentcoeff0  currentcoeff0   Input  18
     add_interface_port hip_pipe currentcoeff1  currentcoeff1   Input  18
     add_interface_port hip_pipe currentcoeff2  currentcoeff2   Input  18
     add_interface_port hip_pipe currentcoeff3  currentcoeff3   Input  18
     add_interface_port hip_pipe currentcoeff4  currentcoeff4   Input  18
     add_interface_port hip_pipe currentcoeff5  currentcoeff5   Input  18
     add_interface_port hip_pipe currentcoeff6  currentcoeff6   Input  18
     add_interface_port hip_pipe currentcoeff7  currentcoeff7   Input  18
     add_interface_port hip_pipe currentrxpreset0       currentrxpreset0       Input  3
     add_interface_port hip_pipe currentrxpreset1       currentrxpreset1       Input  3
     add_interface_port hip_pipe currentrxpreset2       currentrxpreset2       Input  3
     add_interface_port hip_pipe currentrxpreset3       currentrxpreset3       Input  3
     add_interface_port hip_pipe currentrxpreset4       currentrxpreset4       Input  3
     add_interface_port hip_pipe currentrxpreset5       currentrxpreset5       Input  3
     add_interface_port hip_pipe currentrxpreset6       currentrxpreset6       Input  3
     add_interface_port hip_pipe currentrxpreset7       currentrxpreset7       Input  3
     add_interface_port hip_pipe txsynchd0      txsynchd0        Input  2
     add_interface_port hip_pipe txsynchd1      txsynchd1        Input  2
     add_interface_port hip_pipe txsynchd2      txsynchd2        Input  2
     add_interface_port hip_pipe txsynchd3      txsynchd3        Input  2
     add_interface_port hip_pipe txsynchd4      txsynchd4        Input  2
     add_interface_port hip_pipe txsynchd5      txsynchd5        Input  2
     add_interface_port hip_pipe txsynchd6      txsynchd6        Input  2
     add_interface_port hip_pipe txsynchd7      txsynchd7        Input  2
     add_interface_port hip_pipe txblkst0       txblkst0         Input  1
     add_interface_port hip_pipe txblkst1       txblkst1         Input  1
     add_interface_port hip_pipe txblkst2       txblkst2         Input  1
     add_interface_port hip_pipe txblkst3       txblkst3         Input  1
     add_interface_port hip_pipe txblkst4       txblkst4         Input  1
     add_interface_port hip_pipe txblkst5       txblkst5         Input  1
     add_interface_port hip_pipe txblkst6       txblkst6         Input  1
     add_interface_port hip_pipe txblkst7       txblkst7         Input  1
     add_interface_port hip_pipe txdataskip0    txdataskip0      Input  1
     add_interface_port hip_pipe txdataskip1    txdataskip1      Input  1
     add_interface_port hip_pipe txdataskip2    txdataskip2      Input  1
     add_interface_port hip_pipe txdataskip3    txdataskip3      Input  1
     add_interface_port hip_pipe txdataskip4    txdataskip4      Input  1
     add_interface_port hip_pipe txdataskip5    txdataskip5      Input  1
     add_interface_port hip_pipe txdataskip6    txdataskip6      Input  1
     add_interface_port hip_pipe txdataskip7    txdataskip7      Input  1
     add_interface_port hip_pipe rate0          rate0            Input  2
     add_interface_port hip_pipe rate1          rate1            Input  2
     add_interface_port hip_pipe rate2          rate2            Input  2
     add_interface_port hip_pipe rate3          rate3            Input  2
     add_interface_port hip_pipe rate4          rate4            Input  2
     add_interface_port hip_pipe rate5          rate5            Input  2
     add_interface_port hip_pipe rate6          rate6            Input  2
     add_interface_port hip_pipe rate7          rate7            Input  2


     add_interface_port hip_pipe dirfeedback8  dirfeedback8                         Output 6
     add_interface_port hip_pipe dirfeedback9  dirfeedback9                         Output 6
     add_interface_port hip_pipe dirfeedback10 dirfeedback10                        Output 6
     add_interface_port hip_pipe dirfeedback11 dirfeedback11                        Output 6
     add_interface_port hip_pipe dirfeedback12 dirfeedback12                        Output 6
     add_interface_port hip_pipe dirfeedback13 dirfeedback13                        Output 6
     add_interface_port hip_pipe dirfeedback14 dirfeedback14                        Output 6
     add_interface_port hip_pipe dirfeedback15 dirfeedback15                        Output 6
     add_interface_port hip_pipe rxeqeval8      rxeqeval8                           Input 1
     add_interface_port hip_pipe rxeqeval9      rxeqeval9                           Input 1
     add_interface_port hip_pipe rxeqeval10     rxeqeval10                          Input 1
     add_interface_port hip_pipe rxeqeval11     rxeqeval11                          Input 1
     add_interface_port hip_pipe rxeqeval12     rxeqeval12                          Input 1
     add_interface_port hip_pipe rxeqeval13     rxeqeval13                          Input 1
     add_interface_port hip_pipe rxeqeval14     rxeqeval14                          Input 1
     add_interface_port hip_pipe rxeqeval15     rxeqeval15                          Input 1
     add_interface_port hip_pipe rxeqinprogress8      rxeqinprogress8               Input 1
     add_interface_port hip_pipe rxeqinprogress9      rxeqinprogress9               Input 1
     add_interface_port hip_pipe rxeqinprogress10     rxeqinprogress10              Input 1
     add_interface_port hip_pipe rxeqinprogress11     rxeqinprogress11              Input 1
     add_interface_port hip_pipe rxeqinprogress12     rxeqinprogress12              Input 1
     add_interface_port hip_pipe rxeqinprogress13     rxeqinprogress13              Input 1
     add_interface_port hip_pipe rxeqinprogress14     rxeqinprogress14              Input 1
     add_interface_port hip_pipe rxeqinprogress15     rxeqinprogress15              Input 1
     add_interface_port hip_pipe invalidreq8      invalidreq8                       Input 1
     add_interface_port hip_pipe invalidreq9      invalidreq9                       Input 1
     add_interface_port hip_pipe invalidreq10     invalidreq10                      Input 1
     add_interface_port hip_pipe invalidreq11     invalidreq11                      Input 1
     add_interface_port hip_pipe invalidreq12     invalidreq12                      Input 1
     add_interface_port hip_pipe invalidreq13     invalidreq13                      Input 1
     add_interface_port hip_pipe invalidreq14     invalidreq14                      Input 1
     add_interface_port hip_pipe invalidreq15     invalidreq15                      Input 1
     add_interface_port hip_pipe powerdown8      powerdown8                         Input 2
     add_interface_port hip_pipe powerdown9      powerdown9                         Input 2
     add_interface_port hip_pipe powerdown10     powerdown10                        Input 2
     add_interface_port hip_pipe powerdown11     powerdown11                        Input 2
     add_interface_port hip_pipe powerdown12     powerdown12                        Input 2
     add_interface_port hip_pipe powerdown13     powerdown13                        Input 2
     add_interface_port hip_pipe powerdown14     powerdown14                        Input 2
     add_interface_port hip_pipe powerdown15     powerdown15                        Input 2
     add_interface_port hip_pipe rxpolarity8     rxpolarity8                        Input 1
     add_interface_port hip_pipe rxpolarity9     rxpolarity9                        Input 1
     add_interface_port hip_pipe rxpolarity10    rxpolarity10                       Input 1
     add_interface_port hip_pipe rxpolarity11    rxpolarity11                       Input 1
     add_interface_port hip_pipe rxpolarity12    rxpolarity12                       Input 1
     add_interface_port hip_pipe rxpolarity13    rxpolarity13                       Input 1
     add_interface_port hip_pipe rxpolarity14    rxpolarity14                       Input 1
     add_interface_port hip_pipe rxpolarity15    rxpolarity15                       Input 1
     add_interface_port hip_pipe txcompl8        txcompl8                           Input 1
     add_interface_port hip_pipe txcompl9        txcompl9                           Input 1
     add_interface_port hip_pipe txcompl10       txcompl10                          Input 1
     add_interface_port hip_pipe txcompl11       txcompl11                          Input 1
     add_interface_port hip_pipe txcompl12       txcompl12                          Input 1
     add_interface_port hip_pipe txcompl13       txcompl13                          Input 1
     add_interface_port hip_pipe txcompl14       txcompl14                          Input 1
     add_interface_port hip_pipe txcompl15       txcompl15                          Input 1
     add_interface_port hip_pipe txdata8         txdata8                            Input 32
     add_interface_port hip_pipe txdata9         txdata9                            Input 32
     add_interface_port hip_pipe txdata10        txdata10                           Input 32
     add_interface_port hip_pipe txdata11        txdata11                           Input 32
     add_interface_port hip_pipe txdata12        txdata12                           Input 32
     add_interface_port hip_pipe txdata13        txdata13                           Input 32
     add_interface_port hip_pipe txdata14        txdata14                           Input 32
     add_interface_port hip_pipe txdata15        txdata15                           Input 32
     add_interface_port hip_pipe txdatak8        txdatak8                           Input 4
     add_interface_port hip_pipe txdatak9        txdatak9                           Input 4
     add_interface_port hip_pipe txdatak10       txdatak10                          Input 4
     add_interface_port hip_pipe txdatak11       txdatak11                          Input 4
     add_interface_port hip_pipe txdatak12       txdatak12                          Input 4
     add_interface_port hip_pipe txdatak13       txdatak13                          Input 4
     add_interface_port hip_pipe txdatak14       txdatak14                          Input 4
     add_interface_port hip_pipe txdatak15       txdatak15                          Input 4
     add_interface_port hip_pipe txdetectrx8     txdetectrx8                        Input 1
     add_interface_port hip_pipe txdetectrx9     txdetectrx9                        Input 1
     add_interface_port hip_pipe txdetectrx10    txdetectrx10                       Input 1
     add_interface_port hip_pipe txdetectrx11    txdetectrx11                       Input 1
     add_interface_port hip_pipe txdetectrx12    txdetectrx12                       Input 1
     add_interface_port hip_pipe txdetectrx13    txdetectrx13                       Input 1
     add_interface_port hip_pipe txdetectrx14    txdetectrx14                       Input 1
     add_interface_port hip_pipe txdetectrx15    txdetectrx15                       Input 1
     add_interface_port hip_pipe txelecidle8     txelecidle8                        Input 1
     add_interface_port hip_pipe txelecidle9     txelecidle9                        Input 1
     add_interface_port hip_pipe txelecidle10    txelecidle10                       Input 1
     add_interface_port hip_pipe txelecidle11    txelecidle11                       Input 1
     add_interface_port hip_pipe txelecidle12    txelecidle12                       Input 1
     add_interface_port hip_pipe txelecidle13    txelecidle13                       Input 1
     add_interface_port hip_pipe txelecidle14    txelecidle14                       Input 1
     add_interface_port hip_pipe txelecidle15    txelecidle15                       Input 1
     add_interface_port hip_pipe txdeemph8       txdeemph8                          Input 1
     add_interface_port hip_pipe txdeemph9       txdeemph9                          Input 1
     add_interface_port hip_pipe txdeemph10      txdeemph10                         Input 1
     add_interface_port hip_pipe txdeemph11      txdeemph11                         Input 1
     add_interface_port hip_pipe txdeemph12      txdeemph12                         Input 1
     add_interface_port hip_pipe txdeemph13      txdeemph13                         Input 1
     add_interface_port hip_pipe txdeemph14      txdeemph14                         Input 1
     add_interface_port hip_pipe txdeemph15      txdeemph15                         Input 1
     add_interface_port hip_pipe txmargin8       txmargin8                          Input 3
     add_interface_port hip_pipe txmargin9       txmargin9                          Input 3
     add_interface_port hip_pipe txmargin10      txmargin10                         Input 3
     add_interface_port hip_pipe txmargin11      txmargin11                         Input 3
     add_interface_port hip_pipe txmargin12      txmargin12                         Input 3
     add_interface_port hip_pipe txmargin13      txmargin13                         Input 3
     add_interface_port hip_pipe txmargin14      txmargin14                         Input 3
     add_interface_port hip_pipe txmargin15      txmargin15                         Input 3
     add_interface_port hip_pipe txswing8        txswing8                           Input 1
     add_interface_port hip_pipe txswing9        txswing9                           Input 1
     add_interface_port hip_pipe txswing10       txswing10                          Input 1
     add_interface_port hip_pipe txswing11       txswing11                          Input 1
     add_interface_port hip_pipe txswing12       txswing12                          Input 1
     add_interface_port hip_pipe txswing13       txswing13                          Input 1
     add_interface_port hip_pipe txswing14       txswing14                          Input 1
     add_interface_port hip_pipe txswing15       txswing15                          Input 1
     add_interface_port hip_pipe phystatus8      phystatus8                         Output  1
     add_interface_port hip_pipe phystatus9      phystatus9                         Output  1
     add_interface_port hip_pipe phystatus10     phystatus10                        Output  1
     add_interface_port hip_pipe phystatus11     phystatus11                        Output  1
     add_interface_port hip_pipe phystatus12     phystatus12                        Output  1
     add_interface_port hip_pipe phystatus13     phystatus13                        Output  1
     add_interface_port hip_pipe phystatus14     phystatus14                        Output  1
     add_interface_port hip_pipe phystatus15     phystatus15                        Output  1
     add_interface_port hip_pipe rxdata8         rxdata8                            Output  32
     add_interface_port hip_pipe rxdata9         rxdata9                            Output  32
     add_interface_port hip_pipe rxdata10        rxdata10                           Output  32
     add_interface_port hip_pipe rxdata11        rxdata11                           Output  32
     add_interface_port hip_pipe rxdata12        rxdata12                           Output  32
     add_interface_port hip_pipe rxdata13        rxdata13                           Output  32
     add_interface_port hip_pipe rxdata14        rxdata14                           Output  32
     add_interface_port hip_pipe rxdata15        rxdata15                           Output  32
     add_interface_port hip_pipe rxdatak8        rxdatak8                           Output  4
     add_interface_port hip_pipe rxdatak9        rxdatak9                           Output  4
     add_interface_port hip_pipe rxdatak10       rxdatak10                          Output  4
     add_interface_port hip_pipe rxdatak11       rxdatak11                          Output  4
     add_interface_port hip_pipe rxdatak12       rxdatak12                          Output  4
     add_interface_port hip_pipe rxdatak13       rxdatak13                          Output  4
     add_interface_port hip_pipe rxdatak14       rxdatak14                          Output  4
     add_interface_port hip_pipe rxdatak15       rxdatak15                          Output  4
     add_interface_port hip_pipe rxelecidle8     rxelecidle8                        Output  1
     add_interface_port hip_pipe rxelecidle9     rxelecidle9                        Output  1
     add_interface_port hip_pipe rxelecidle10    rxelecidle10                       Output  1
     add_interface_port hip_pipe rxelecidle11    rxelecidle11                       Output  1
     add_interface_port hip_pipe rxelecidle12    rxelecidle12                       Output  1
     add_interface_port hip_pipe rxelecidle13    rxelecidle13                       Output  1
     add_interface_port hip_pipe rxelecidle14    rxelecidle14                       Output  1
     add_interface_port hip_pipe rxelecidle15    rxelecidle15                       Output  1
     add_interface_port hip_pipe rxstatus8       rxstatus8                          Output  3
     add_interface_port hip_pipe rxstatus9       rxstatus9                          Output  3
     add_interface_port hip_pipe rxstatus10      rxstatus10                         Output  3
     add_interface_port hip_pipe rxstatus11      rxstatus11                         Output  3
     add_interface_port hip_pipe rxstatus12      rxstatus12                         Output  3
     add_interface_port hip_pipe rxstatus13      rxstatus13                         Output  3
     add_interface_port hip_pipe rxstatus14      rxstatus14                         Output  3
     add_interface_port hip_pipe rxstatus15      rxstatus15                         Output  3
     add_interface_port hip_pipe rxvalid8        rxvalid8                           Output  1
     add_interface_port hip_pipe rxvalid9        rxvalid9                           Output  1
     add_interface_port hip_pipe rxvalid10       rxvalid10                          Output  1
     add_interface_port hip_pipe rxvalid11       rxvalid11                          Output  1
     add_interface_port hip_pipe rxvalid12       rxvalid12                          Output  1
     add_interface_port hip_pipe rxvalid13       rxvalid13                          Output  1
     add_interface_port hip_pipe rxvalid14       rxvalid14                          Output  1
     add_interface_port hip_pipe rxvalid15       rxvalid15                          Output  1
     add_interface_port hip_pipe rxdataskip8     rxdataskip8                      Output  1
     add_interface_port hip_pipe rxdataskip9     rxdataskip9                      Output  1
     add_interface_port hip_pipe rxdataskip10    rxdataskip10                     Output  1
     add_interface_port hip_pipe rxdataskip11    rxdataskip11                     Output  1
     add_interface_port hip_pipe rxdataskip12    rxdataskip12                     Output  1
     add_interface_port hip_pipe rxdataskip13    rxdataskip13                     Output  1
     add_interface_port hip_pipe rxdataskip14    rxdataskip14                     Output  1
     add_interface_port hip_pipe rxdataskip15    rxdataskip15                     Output  1
     add_interface_port hip_pipe rxblkst8        rxblkst8                           Output  1
     add_interface_port hip_pipe rxblkst9        rxblkst9                           Output  1
     add_interface_port hip_pipe rxblkst10       rxblkst10                          Output  1
     add_interface_port hip_pipe rxblkst11       rxblkst11                          Output  1
     add_interface_port hip_pipe rxblkst12       rxblkst12                          Output  1
     add_interface_port hip_pipe rxblkst13       rxblkst13                          Output  1
     add_interface_port hip_pipe rxblkst14       rxblkst14                          Output  1
     add_interface_port hip_pipe rxblkst15       rxblkst15                          Output  1
     add_interface_port hip_pipe rxsynchd8       rxsynchd8                          Output  2
     add_interface_port hip_pipe rxsynchd9       rxsynchd9                          Output  2
     add_interface_port hip_pipe rxsynchd10      rxsynchd10                         Output  2
     add_interface_port hip_pipe rxsynchd11      rxsynchd11                         Output  2
     add_interface_port hip_pipe rxsynchd12      rxsynchd12                         Output  2
     add_interface_port hip_pipe rxsynchd13      rxsynchd13                         Output  2
     add_interface_port hip_pipe rxsynchd14      rxsynchd14                         Output  2
     add_interface_port hip_pipe rxsynchd15      rxsynchd15                         Output  2
     add_interface_port hip_pipe currentcoeff8   currentcoeff8                      Input  18
     add_interface_port hip_pipe currentcoeff9   currentcoeff9                      Input  18
     add_interface_port hip_pipe currentcoeff10  currentcoeff10                     Input  18
     add_interface_port hip_pipe currentcoeff11  currentcoeff11                     Input  18
     add_interface_port hip_pipe currentcoeff12  currentcoeff12                     Input  18
     add_interface_port hip_pipe currentcoeff13  currentcoeff13                     Input  18
     add_interface_port hip_pipe currentcoeff14  currentcoeff14                     Input  18
     add_interface_port hip_pipe currentcoeff15  currentcoeff15                     Input  18
     add_interface_port hip_pipe currentrxpreset8        currentrxpreset8           Input  3
     add_interface_port hip_pipe currentrxpreset9        currentrxpreset9           Input  3
     add_interface_port hip_pipe currentrxpreset10       currentrxpreset10          Input  3
     add_interface_port hip_pipe currentrxpreset11       currentrxpreset11          Input  3
     add_interface_port hip_pipe currentrxpreset12       currentrxpreset12          Input  3
     add_interface_port hip_pipe currentrxpreset13       currentrxpreset13          Input  3
     add_interface_port hip_pipe currentrxpreset14       currentrxpreset14          Input  3
     add_interface_port hip_pipe currentrxpreset15       currentrxpreset15          Input  3
     add_interface_port hip_pipe txsynchd8       txsynchd8                          Input  2
     add_interface_port hip_pipe txsynchd9       txsynchd9                          Input  2
     add_interface_port hip_pipe txsynchd10      txsynchd10                         Input  2
     add_interface_port hip_pipe txsynchd11      txsynchd11                         Input  2
     add_interface_port hip_pipe txsynchd12      txsynchd12                         Input  2
     add_interface_port hip_pipe txsynchd13      txsynchd13                         Input  2
     add_interface_port hip_pipe txsynchd14      txsynchd14                         Input  2
     add_interface_port hip_pipe txsynchd15      txsynchd15                         Input  2
     add_interface_port hip_pipe txblkst8        txblkst8                           Input  1
     add_interface_port hip_pipe txblkst9        txblkst9                           Input  1
     add_interface_port hip_pipe txblkst10       txblkst10                          Input  1
     add_interface_port hip_pipe txblkst11       txblkst11                          Input  1
     add_interface_port hip_pipe txblkst12       txblkst12                          Input  1
     add_interface_port hip_pipe txblkst13       txblkst13                          Input  1
     add_interface_port hip_pipe txblkst14       txblkst14                          Input  1
     add_interface_port hip_pipe txblkst15       txblkst15                          Input  1
     add_interface_port hip_pipe txdataskip8     txdataskip8                      Input  1
     add_interface_port hip_pipe txdataskip9     txdataskip9                      Input  1
     add_interface_port hip_pipe txdataskip10    txdataskip10                     Input  1
     add_interface_port hip_pipe txdataskip11    txdataskip11                     Input  1
     add_interface_port hip_pipe txdataskip12    txdataskip12                     Input  1
     add_interface_port hip_pipe txdataskip13    txdataskip13                     Input  1
     add_interface_port hip_pipe txdataskip14    txdataskip14                     Input  1
     add_interface_port hip_pipe txdataskip15    txdataskip15                     Input  1
     add_interface_port hip_pipe rate8           rate8                              Input  2
     add_interface_port hip_pipe rate9           rate9                              Input  2
     add_interface_port hip_pipe rate10          rate10                             Input  2
     add_interface_port hip_pipe rate11          rate11                             Input  2
     add_interface_port hip_pipe rate12          rate12                             Input  2
     add_interface_port hip_pipe rate13          rate13                             Input  2
     add_interface_port hip_pipe rate14          rate14                             Input  2
     add_interface_port hip_pipe rate15          rate15                             Input  2

      }

}

####################################################################################################
#
# Serial interface conduit
#
proc add_tbed_hip_port_serial {} {

   send_message debug "proc:add_tbed_hip_port_serial"

   set lane_mask_hwtcl  [ get_parameter_value lane_mask_hwtcl]
   set nlane [ expr [ regexp x16 $lane_mask_hwtcl ] ? 16 : [ regexp x8 $lane_mask_hwtcl ] ? 8 :  [ regexp x4 $lane_mask_hwtcl ] ? 4 : [ regexp x2 $lane_mask_hwtcl ] ? 2 : 1 ]

   add_interface hip_serial conduit end

   if { $nlane == 1 } {
      add_interface_port hip_serial rx_in0 rx_in0  Output 1
      add_to_no_connect  rx_in1 1 Out
      add_to_no_connect  rx_in2 1 Out
      add_to_no_connect  rx_in3 1 Out
      add_to_no_connect  rx_in4 1 Out
      add_to_no_connect  rx_in5 1 Out
      add_to_no_connect  rx_in6 1 Out
      add_to_no_connect  rx_in7 1 Out
      add_interface_port hip_serial tx_out0 tx_out0  Input 1
      add_to_no_connect  tx_out1 1 In
      add_to_no_connect  tx_out2 1 In
      add_to_no_connect  tx_out3 1 In
      add_to_no_connect  tx_out4 1 In
      add_to_no_connect  tx_out5 1 In
      add_to_no_connect  tx_out6 1 In
      add_to_no_connect  tx_out7 1 In

      add_to_no_connect  rx_in8  1 Out
      add_to_no_connect  rx_in9  1 Out
      add_to_no_connect  rx_in10 1 Out
      add_to_no_connect  rx_in11 1 Out
      add_to_no_connect  rx_in12 1 Out
      add_to_no_connect  rx_in13 1 Out
      add_to_no_connect  rx_in14 1 Out
      add_to_no_connect  rx_in15 1 Out


      add_to_no_connect  tx_out8  1 In
      add_to_no_connect  tx_out9  1 In
      add_to_no_connect  tx_out10 1 In
      add_to_no_connect  tx_out11 1 In
      add_to_no_connect  tx_out12 1 In
      add_to_no_connect  tx_out13 1 In
      add_to_no_connect  tx_out14 1 In
      add_to_no_connect  tx_out15 1 In


   } elseif { $nlane == 2 } {
      add_interface_port hip_serial rx_in0 rx_in0  Output 1
      add_interface_port hip_serial rx_in1 rx_in1   Output 1
      add_to_no_connect  rx_in2 1 Out
      add_to_no_connect  rx_in3 1 Out
      add_to_no_connect  rx_in4 1 Out
      add_to_no_connect  rx_in5 1 Out
      add_to_no_connect  rx_in6 1 Out
      add_to_no_connect  rx_in7 1 Out
      add_interface_port hip_serial tx_out0 tx_out0  Input 1
      add_interface_port hip_serial tx_out1 tx_out1  Input 1
      add_to_no_connect  tx_out2 1 In
      add_to_no_connect  tx_out3 1 In
      add_to_no_connect  tx_out4 1 In
      add_to_no_connect  tx_out5 1 In
      add_to_no_connect  tx_out6 1 In
      add_to_no_connect  tx_out7 1 In

      add_to_no_connect  rx_in8  1 Out
      add_to_no_connect  rx_in9  1 Out
      add_to_no_connect  rx_in10 1 Out
      add_to_no_connect  rx_in11 1 Out
      add_to_no_connect  rx_in12 1 Out
      add_to_no_connect  rx_in13 1 Out
      add_to_no_connect  rx_in14 1 Out
      add_to_no_connect  rx_in15 1 Out


      add_to_no_connect  tx_out8  1 In
      add_to_no_connect  tx_out9  1 In
      add_to_no_connect  tx_out10 1 In
      add_to_no_connect  tx_out11 1 In
      add_to_no_connect  tx_out12 1 In
      add_to_no_connect  tx_out13 1 In
      add_to_no_connect  tx_out14 1 In
      add_to_no_connect  tx_out15 1 In

   } elseif { $nlane == 4 } {
      add_interface_port hip_serial rx_in0 rx_in0  Output 1
      add_interface_port hip_serial rx_in1 rx_in1  Output 1
      add_interface_port hip_serial rx_in2 rx_in2  Output 1
      add_interface_port hip_serial rx_in3 rx_in3  Output 1
      add_to_no_connect  rx_in4 1 Out
      add_to_no_connect  rx_in5 1 Out
      add_to_no_connect  rx_in6 1 Out
      add_to_no_connect  rx_in7 1 Out
      add_interface_port hip_serial tx_out0 tx_out0  Input 1
      add_interface_port hip_serial tx_out1 tx_out1  Input 1
      add_interface_port hip_serial tx_out2 tx_out2  Input 1
      add_interface_port hip_serial tx_out3 tx_out3  Input 1
      add_to_no_connect  tx_out4 1 In
      add_to_no_connect  tx_out5 1 In
      add_to_no_connect  tx_out6 1 In
      add_to_no_connect  tx_out7 1 In

      add_to_no_connect  rx_in8  1 Out
      add_to_no_connect  rx_in9  1 Out
      add_to_no_connect  rx_in10 1 Out
      add_to_no_connect  rx_in11 1 Out
      add_to_no_connect  rx_in12 1 Out
      add_to_no_connect  rx_in13 1 Out
      add_to_no_connect  rx_in14 1 Out
      add_to_no_connect  rx_in15 1 Out


      add_to_no_connect  tx_out8  1 In
      add_to_no_connect  tx_out9  1 In
      add_to_no_connect  tx_out10 1 In
      add_to_no_connect  tx_out11 1 In
      add_to_no_connect  tx_out12 1 In
      add_to_no_connect  tx_out13 1 In
      add_to_no_connect  tx_out14 1 In
      add_to_no_connect  tx_out15 1 In

   } elseif { $nlane == 8 } {
      add_interface_port hip_serial rx_in0 rx_in0  Output 1
      add_interface_port hip_serial rx_in1 rx_in1  Output 1
      add_interface_port hip_serial rx_in2 rx_in2  Output 1
      add_interface_port hip_serial rx_in3 rx_in3  Output 1
      add_interface_port hip_serial rx_in4 rx_in4  Output 1
      add_interface_port hip_serial rx_in5 rx_in5  Output 1
      add_interface_port hip_serial rx_in6 rx_in6  Output 1
      add_interface_port hip_serial rx_in7 rx_in7  Output 1
      add_interface_port hip_serial tx_out0 tx_out0  Input 1
      add_interface_port hip_serial tx_out1 tx_out1  Input 1
      add_interface_port hip_serial tx_out2 tx_out2  Input 1
      add_interface_port hip_serial tx_out3 tx_out3  Input 1
      add_interface_port hip_serial tx_out4 tx_out4  Input 1
      add_interface_port hip_serial tx_out5 tx_out5  Input 1
      add_interface_port hip_serial tx_out6 tx_out6  Input 1
      add_interface_port hip_serial tx_out7 tx_out7  Input 1

      add_to_no_connect  rx_in8  1 Out
      add_to_no_connect  rx_in9  1 Out
      add_to_no_connect  rx_in10 1 Out
      add_to_no_connect  rx_in11 1 Out
      add_to_no_connect  rx_in12 1 Out
      add_to_no_connect  rx_in13 1 Out
      add_to_no_connect  rx_in14 1 Out
      add_to_no_connect  rx_in15 1 Out


      add_to_no_connect  tx_out8  1 In
      add_to_no_connect  tx_out9  1 In
      add_to_no_connect  tx_out10 1 In
      add_to_no_connect  tx_out11 1 In
      add_to_no_connect  tx_out12 1 In
      add_to_no_connect  tx_out13 1 In
      add_to_no_connect  tx_out14 1 In
      add_to_no_connect  tx_out15 1 In

   } else {
      add_interface_port hip_serial rx_in0  rx_in0   Output 1
      add_interface_port hip_serial rx_in1  rx_in1   Output 1
      add_interface_port hip_serial rx_in2  rx_in2   Output 1
      add_interface_port hip_serial rx_in3  rx_in3   Output 1
      add_interface_port hip_serial rx_in4  rx_in4   Output 1
      add_interface_port hip_serial rx_in5  rx_in5   Output 1
      add_interface_port hip_serial rx_in6  rx_in6   Output 1
      add_interface_port hip_serial rx_in7  rx_in7   Output 1
      add_interface_port hip_serial rx_in8  rx_in8   Output 1
      add_interface_port hip_serial rx_in9  rx_in9   Output 1
      add_interface_port hip_serial rx_in10 rx_in10  Output 1
      add_interface_port hip_serial rx_in11 rx_in11  Output 1
      add_interface_port hip_serial rx_in12 rx_in12  Output 1
      add_interface_port hip_serial rx_in13 rx_in13  Output 1
      add_interface_port hip_serial rx_in14 rx_in14  Output 1
      add_interface_port hip_serial rx_in15 rx_in15  Output 1


      add_interface_port hip_serial tx_out0  tx_out0   Input 1
      add_interface_port hip_serial tx_out1  tx_out1   Input 1
      add_interface_port hip_serial tx_out2  tx_out2   Input 1
      add_interface_port hip_serial tx_out3  tx_out3   Input 1
      add_interface_port hip_serial tx_out4  tx_out4   Input 1
      add_interface_port hip_serial tx_out5  tx_out5   Input 1
      add_interface_port hip_serial tx_out6  tx_out6   Input 1
      add_interface_port hip_serial tx_out7  tx_out7   Input 1
      add_interface_port hip_serial tx_out8  tx_out8   Input 1
      add_interface_port hip_serial tx_out9  tx_out9   Input 1
      add_interface_port hip_serial tx_out10 tx_out10  Input 1
      add_interface_port hip_serial tx_out11 tx_out11  Input 1
      add_interface_port hip_serial tx_out12 tx_out12  Input 1
      add_interface_port hip_serial tx_out13 tx_out13  Input 1
      add_interface_port hip_serial tx_out14 tx_out14  Input 1
      add_interface_port hip_serial tx_out15 tx_out15  Input 1


   }

}

####################################################################################################
#
# add_to_no_connect signal_name:string signal_width:int direction:string
#  tied internal signal to
#     - open (when output of the instance)
#     - GND (input of the instance)
#
proc add_to_no_connect { signal_name signal_width direction } {
#send_message debug "proc add_to_no_connect $signal_name $signal_width $direction"
   if { [ regexp In $direction ] } {
      add_interface_port no_connect $signal_name $signal_name Input $signal_width
      set_port_property $signal_name TERMINATION true
      set_port_property $signal_name TERMINATION_VALUE 0
   } else {
      add_interface_port no_connect $signal_name $signal_name Output $signal_width
      set_port_property  $signal_name TERMINATION true
   }
}
