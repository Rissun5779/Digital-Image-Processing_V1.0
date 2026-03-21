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
   add_interface_port hip_ctrl test_in        test_in   Output 32
   add_interface_port hip_ctrl simu_mode_pipe simu_mode_pipe Output 1

}

####################################################################################################
#
# Pipe interface conduit
#
proc add_tbed_hip_port_pipe {} {

   send_message debug "proc:add_tbed_hip_port_pipe"

   set lane_mask_hwtcl  [ get_parameter_value lane_mask_hwtcl]
   set nlane [ expr [ regexp x8 $lane_mask_hwtcl  ] ? 8 : [ regexp x4 $lane_mask_hwtcl ] ? 4 :  [ regexp x2 $lane_mask_hwtcl ] ? 2 : 1 ]

   add_interface hip_pipe conduit end

   # clock for pipe simulation
   add_interface_port hip_pipe sim_pipe_pclk_in    sim_pipe_pclk_in     Output 1
   add_interface_port hip_pipe sim_pipe_rate       sim_pipe_rate        Input 2
   add_interface_port hip_pipe sim_ltssmstate      sim_ltssmstate       Input 5

   if { $nlane == 1 } {
      add_interface_port hip_pipe eidleinfersel0 eidleinfersel0  Input 3
      add_to_no_connect  eidleinfersel1 3 In
      add_to_no_connect  eidleinfersel2 3 In
      add_to_no_connect  eidleinfersel3 3 In
      add_to_no_connect  eidleinfersel4 3 In
      add_to_no_connect  eidleinfersel5 3 In
      add_to_no_connect  eidleinfersel6 3 In
      add_to_no_connect  eidleinfersel7 3 In
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
   } elseif { $nlane == 2 } {
      add_interface_port hip_pipe eidleinfersel0 eidleinfersel0  Input 3
      add_interface_port hip_pipe eidleinfersel1 eidleinfersel1  Input 3
      add_to_no_connect  eidleinfersel2 3 In
      add_to_no_connect  eidleinfersel3 3 In
      add_to_no_connect  eidleinfersel4 3 In
      add_to_no_connect  eidleinfersel5 3 In
      add_to_no_connect  eidleinfersel6 3 In
      add_to_no_connect  eidleinfersel7 3 In
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
   } elseif { $nlane == 4 } {
      add_interface_port hip_pipe eidleinfersel0 eidleinfersel0  Input 3
      add_interface_port hip_pipe eidleinfersel1 eidleinfersel1  Input 3
      add_interface_port hip_pipe eidleinfersel2 eidleinfersel2  Input 3
      add_interface_port hip_pipe eidleinfersel3 eidleinfersel3  Input 3
      add_to_no_connect  eidleinfersel4 3 In
      add_to_no_connect  eidleinfersel5 3 In
      add_to_no_connect  eidleinfersel6 3 In
      add_to_no_connect  eidleinfersel7 3 In
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
   } else {
     add_interface_port hip_pipe eidleinfersel0 eidleinfersel0  Input 3
     add_interface_port hip_pipe eidleinfersel1 eidleinfersel1  Input 3
     add_interface_port hip_pipe eidleinfersel2 eidleinfersel2  Input 3
     add_interface_port hip_pipe eidleinfersel3 eidleinfersel3  Input 3
     add_interface_port hip_pipe eidleinfersel4 eidleinfersel4  Input 3
     add_interface_port hip_pipe eidleinfersel5 eidleinfersel5  Input 3
     add_interface_port hip_pipe eidleinfersel6 eidleinfersel6  Input 3
     add_interface_port hip_pipe eidleinfersel7 eidleinfersel7  Input 3
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
   }

}

####################################################################################################
#
# Serial interface conduit
#
proc add_tbed_hip_port_serial {} {

   send_message debug "proc:add_tbed_hip_port_serial"

   set lane_mask_hwtcl  [ get_parameter_value lane_mask_hwtcl]
   set nlane [ expr [ regexp x8 $lane_mask_hwtcl  ] ? 8 : [ regexp x4 $lane_mask_hwtcl ] ? 4 :  [ regexp x2 $lane_mask_hwtcl ] ? 2 : 1 ]

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
   } else {
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
