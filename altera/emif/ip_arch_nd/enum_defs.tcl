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


package provide altera_emif::ip_arch_nd::enum_defs 0.1

package require altera_emif::util::enums

namespace eval ::altera_emif::ip_arch_nd::enum_defs:: {
   namespace import ::altera_emif::util::enums::*


}


proc ::altera_emif::ip_arch_nd::enum_defs::def_enums {} {

   def_enum_type ARCH_ND_IF                                                           {      IF_ENUM                         NUM_IN_RTL  }
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_GLOBAL_RESET               [list  IF_GLOBAL_RESET                 1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_PLL_REF_CLK                [list  IF_PLL_REF_CLK                  1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_OCT                        [list  IF_OCT                          1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_MEM                        [list  IF_MEM                          1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_STATUS                     [list  IF_STATUS                       1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_VID_CAL_DONE               [list  IF_VID_CAL_DONE                 1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_AFI_RESET                  [list  IF_AFI_RESET                    1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_AFI_CLK                    [list  IF_AFI_CLK                      1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_AFI_HALF_CLK               [list  IF_AFI_HALF_CLK                 1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_EMIF_USR_RESET             [list  IF_EMIF_USR_RESET               1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_EMIF_USR_CLK               [list  IF_EMIF_USR_CLK                 1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_EMIF_USR_HALF_CLK          [list  IF_EMIF_USR_HALF_CLK            1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_EMIF_USR_RESET_SEC         [list  IF_EMIF_USR_RESET_SEC           1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_EMIF_USR_CLK_SEC           [list  IF_EMIF_USR_CLK_SEC             1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_EMIF_USR_HALF_CLK_SEC      [list  IF_EMIF_USR_HALF_CLK_SEC        1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_MASTER_RESET           [list  IF_CAL_MASTER_RESET             1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_MASTER_CLK             [list  IF_CAL_MASTER_CLK               1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_SLAVE_RESET            [list  IF_CAL_SLAVE_RESET              1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_SLAVE_CLK              [list  IF_CAL_SLAVE_CLK                1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_SLAVE_RESET_IN         [list  IF_CAL_SLAVE_RESET_IN           1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_SLAVE_CLK_IN           [list  IF_CAL_SLAVE_CLK_IN             1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_DEBUG_RESET            [list  IF_CAL_DEBUG_RESET              1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_DEBUG_CLK              [list  IF_CAL_DEBUG_CLK                1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_DEBUG_OUT_RESET        [list  IF_CAL_DEBUG_OUT_RESET          1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_DEBUG_OUT_CLK          [list  IF_CAL_DEBUG_OUT_CLK            1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CLKS_SHARING_MASTER_OUT    [list  IF_CLKS_SHARING_MASTER_OUT      1           ]   
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CLKS_SHARING_SLAVE_IN      [list  IF_CLKS_SHARING_SLAVE_IN        1           ]   
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_AFI                        [list  IF_AFI                          1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_AST_CMD               [list  IF_CTRL_AST_CMD                 2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_AST_WR                [list  IF_CTRL_AST_WR                  2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_AST_RD                [list  IF_CTRL_AST_RD                  2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_AMM                   [list  IF_CTRL_AMM                     2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_USER_PRIORITY         [list  IF_CTRL_USER_PRIORITY           2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_AUTO_PRECHARGE        [list  IF_CTRL_AUTO_PRECHARGE          2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_USER_REFRESH          [list  IF_CTRL_USER_REFRESH            1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_SELF_REFRESH          [list  IF_CTRL_SELF_REFRESH            1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_WILL_REFRESH          [list  IF_CTRL_WILL_REFRESH            1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_DEEP_POWER_DOWN       [list  IF_CTRL_DEEP_POWER_DOWN         1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_POWER_DOWN            [list  IF_CTRL_POWER_DOWN              1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_ZQ_CAL                [list  IF_CTRL_ZQ_CAL                  1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_ECC                   [list  IF_CTRL_ECC                     2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CTRL_MMR                   [list  IF_CTRL_MMR_SLAVE               2           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_HPS_EMIF                   [list  IF_HPS_EMIF                     1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_DEBUG                  [list  IF_CAL_DEBUG                    1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_DEBUG_OUT              [list  IF_CAL_DEBUG_OUT                1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_CAL_MASTER                 [list  IF_CAL_MASTER                   1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_DFT_ND                     [list  IF_DFT_ND                       1           ]
   def_enum      ARCH_ND_IF                     ARCH_ND_IF_VJI                        [list  IF_VJI                          1           ]
   
   def_enum_type DQS_BUS_MODE                                                    {      UNUSED }
   def_enum      DQS_BUS_MODE                   DQS_BUS_MODE_X4                  [list      "" ]
   def_enum      DQS_BUS_MODE                   DQS_BUS_MODE_X8_X9               [list      "" ]
   def_enum      DQS_BUS_MODE                   DQS_BUS_MODE_X16_X18             [list      "" ]
   def_enum      DQS_BUS_MODE                   DQS_BUS_MODE_X32_X36             [list      "" ]
   
   
   def_enum_type DB_PIN_TYPE                                                      {      UNUSED }
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_AC                    [list      "" ]
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_ALERT_N               [list      "" ]
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_DQ                    [list      "" ]
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_Q                     [list      "" ]
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_DQ_WITH_DBI_CRC       [list      "" ]
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_DM                    [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_CK                    [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_CK_N                  [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_DQS                   [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_DQS_N                 [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_DDR4_DQS              [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_DDR4_DQS_N            [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_RCLK                  [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_RCLK_N                [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_WCLK                  [list      "" ]      
   def_enum      DB_PIN_TYPE                    DB_PIN_TYPE_WCLK_N                [list      "" ]      

   

   def_enum_type LANE_USAGE                                                         {      BITSTR }
   def_enum      LANE_USAGE                      LANE_USAGE_UNUSED                  [list    "000" ]
   def_enum      LANE_USAGE                      LANE_USAGE_AC_HMC                  [list    "001" ]
   def_enum      LANE_USAGE                      LANE_USAGE_AC_CORE                 [list    "010" ]
   def_enum      LANE_USAGE                      LANE_USAGE_RDATA                   [list    "011" ]
   def_enum      LANE_USAGE                      LANE_USAGE_WDATA                   [list    "100" ]
   def_enum      LANE_USAGE                      LANE_USAGE_WRDATA                  [list    "101" ]

   def_enum_type PIN_USAGE                                                          {      BITSTR }
   def_enum      PIN_USAGE                       PIN_USAGE_UNUSED                   [list     "0" ]
   def_enum      PIN_USAGE                       PIN_USAGE_USED                     [list     "1" ]
   
   def_enum_type PIN_RATE                                                           {      BITSTR }
   def_enum      PIN_RATE                        PIN_RATE_NOT_APPLICABLE            [list     "0" ]
   def_enum      PIN_RATE                        PIN_RATE_DDR                       [list     "0" ]
   def_enum      PIN_RATE                        PIN_RATE_SDR                       [list     "1" ]

   def_enum_type DB_PIN_PROC_MODE                                                           {       BITSTR  }
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_NOT_APPLICABLE            [list   "00000" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_AC_CORE                   [list   "00000" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_WDB_AC                    [list   "00001" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_WDB_DQ                    [list   "00010" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_WDB_DM                    [list   "00011" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_WDB_CLK                   [list   "00100" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_WDB_CLKB                  [list   "00101" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_WDB_DQS                   [list   "00110" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_WDB_DQSB                  [list   "00111" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_DQS                       [list   "01000" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_DQSB                      [list   "01001" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_DQ                        [list   "01010" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_DM                        [list   "01011" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_DBI                       [list   "01100" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_CLK                       [list   "01101" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_CLKB                      [list   "01110" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_DQS_DDR4                  [list   "01111" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_DQSB_DDR4                 [list   "10000" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_RDQ                       [list   "10001" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_RDQS                      [list   "10010" ]
   def_enum      DB_PIN_PROC_MODE                DB_PIN_PROC_MODE_GPIO                      [list   "11111" ]
  
                                                 
   def_enum_type PIN_DATA_IN_MODE                                                       {      BITSTR }
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_DISABLED              [list   "000" ]
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_SSTL_IN               [list   "001" ]
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_LOOPBACK_IN           [list   "010" ]
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_XOR_LOOPBACK_IN       [list   "011" ]
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_DIFF_IN               [list   "100" ]  
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_DIFF_IN_AVL_OUT       [list   "101" ]  
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_DIFF_IN_X12_OUT       [list   "110" ]  
   def_enum      PIN_DATA_IN_MODE                PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT   [list   "111" ]  
   
   def_enum_type PIN_OCT_MODE                                                        {      BITSTR }
   def_enum      PIN_OCT_MODE                    PIN_OCT_STATIC_OFF                  [list    "0" ]
   def_enum      PIN_OCT_MODE                    PIN_OCT_DYNAMIC                     [list    "1" ]
}


proc ::altera_emif::ip_arch_nd::enum_defs::_init {} {
   def_enums
}

::altera_emif::ip_arch_nd::enum_defs::_init



