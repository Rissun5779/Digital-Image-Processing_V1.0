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


package provide altera_emif::ip_top::mem::ddr4 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::mem::ddr4:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*


   variable m_param_prefix "MEM_DDR4"
}


proc ::altera_emif::ip_top::mem::ddr4::create_parameters {is_top_level_component} {
   variable m_param_prefix

   add_user_param     "${m_param_prefix}_FORMAT_ENUM"                     string    MEM_FORMAT_UDIMM                          [enum_dropdown_entries MEM_FORMAT]
   add_user_param     "${m_param_prefix}_DQ_WIDTH"                        integer   72                                        {4:144}
   add_user_param     "${m_param_prefix}_DQ_PER_DQS"                      integer   8                                         [list 4 8]
   add_user_param     "${m_param_prefix}_DISCRETE_CS_WIDTH"               integer   1                                         [list 1 2 4]
   add_user_param     "${m_param_prefix}_NUM_OF_DIMMS"                    integer   1                                         [list 1 2]
   add_user_param     "${m_param_prefix}_RANKS_PER_DIMM"                  integer   1                                         [list 1 2 4 8]  
   add_user_param     "${m_param_prefix}_CKE_PER_DIMM"                    integer   1                                         [list 1 2]
   add_user_param     "${m_param_prefix}_CK_WIDTH"                        integer   1                                         [list 1 2 3 4]
   add_user_param     "${m_param_prefix}_ROW_ADDR_WIDTH"                  integer   15                                        [list 12 13 14 15 16 17 18]
   add_user_param     "${m_param_prefix}_COL_ADDR_WIDTH"                  integer   10                                        [list 10]
   add_user_param     "${m_param_prefix}_BANK_ADDR_WIDTH"                 integer   2                                         [list 2]
   add_user_param     "${m_param_prefix}_BANK_GROUP_WIDTH"                integer   2                                         [list 1 2]
   add_user_param     "${m_param_prefix}_CHIP_ID_WIDTH"                   integer   0                                         [list 0 1 2 3]
   add_user_param     "${m_param_prefix}_DM_EN"                           boolean   true                                      ""
   add_user_param     "${m_param_prefix}_ALERT_PAR_EN"                    boolean   true                                      ""
   add_user_param     "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"          string    DDR4_ALERT_N_PLACEMENT_AUTO               [enum_dropdown_entries DDR4_ALERT_N_PLACEMENT]
   add_user_param     "${m_param_prefix}_ALERT_N_DQS_GROUP"               integer   0                                         [list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17]
   add_user_param     "${m_param_prefix}_ALERT_N_AC_LANE"                 integer   0                                         [list 0 1 2 3]
   add_user_param     "${m_param_prefix}_ALERT_N_AC_PIN"                  integer   0                                         [list 0 1 2 3 4 5 6 7 8 9 10 11]
   add_user_param     "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"   boolean   false                                     ""
   add_user_param     "${m_param_prefix}_MIRROR_ADDRESSING_EN"            boolean   true                                      ""
   add_user_param     "${m_param_prefix}_HIDE_ADV_MR_SETTINGS"            boolean   true                                      ""

   add_user_param     "${m_param_prefix}_BL_ENUM"                         string    DDR4_BL_BL8                               [enum_dropdown_entries DDR4_BL]
   add_user_param     "${m_param_prefix}_BT_ENUM"                         string    DDR4_BT_SEQUENTIAL                        [enum_dropdown_entries DDR4_BT]
   add_user_param     "${m_param_prefix}_TCL"                             integer   18                                        [list 9 10 11 12 13 14 15 16 17 18 19 20 21 22 24]

   add_user_param     "${m_param_prefix}_RTT_NOM_ENUM"                    string    DDR4_RTT_NOM_RZQ_4                        [enum_dropdown_entries DDR4_RTT_NOM]
   add_user_param     "${m_param_prefix}_DLL_EN"                          boolean   true                                      ""
   add_user_param     "${m_param_prefix}_ATCL_ENUM"                       string    DDR4_ATCL_DISABLED                        [enum_dropdown_entries DDR4_ATCL]
   add_user_param     "${m_param_prefix}_DRV_STR_ENUM"                    string    DDR4_DRV_STR_RZQ_7                        [enum_dropdown_entries DDR4_DRV_STR]

   add_user_param     "${m_param_prefix}_ASR_ENUM"                        string    DDR4_ASR_MANUAL_NORMAL                    [enum_dropdown_entries DDR4_ASR]
   add_user_param     "${m_param_prefix}_RTT_WR_ENUM"                     string    DDR4_RTT_WR_ODT_DISABLED                  [enum_dropdown_entries DDR4_RTT_WR]
   add_user_param     "${m_param_prefix}_WTCL"                            integer   12                                        [list 9 10 11 12 14 16 18]
   add_user_param     "${m_param_prefix}_WRITE_CRC"                       boolean   false                                     ""

   add_user_param     "${m_param_prefix}_GEARDOWN"                        string    DDR4_GEARDOWN_HR                          [enum_dropdown_entries DDR4_GEARDOWN]
   add_user_param     "${m_param_prefix}_PER_DRAM_ADDR"                   boolean   false                                     ""
   add_user_param     "${m_param_prefix}_TEMP_SENSOR_READOUT"             boolean   false                                     ""
   add_user_param     "${m_param_prefix}_FINE_GRANULARITY_REFRESH"        string    DDR4_FINE_REFRESH_FIXED_1X                [enum_dropdown_entries DDR4_FINE_REFRESH]
   add_user_param     "${m_param_prefix}_MPR_READ_FORMAT"                 string    DDR4_MPR_READ_FORMAT_SERIAL               [enum_dropdown_entries DDR4_MPR_READ_FORMAT]

   add_user_param     "${m_param_prefix}_MAX_POWERDOWN"                   boolean   false                                     ""
   add_user_param     "${m_param_prefix}_TEMP_CONTROLLED_RFSH_RANGE"      string    DDR4_TEMP_CONTROLLED_RFSH_NORMAL          [enum_dropdown_entries DDR4_TEMP_CONTROLLED_RFSH_RANGE]
   add_user_param     "${m_param_prefix}_TEMP_CONTROLLED_RFSH_ENA"        boolean   false                                     ""
   add_user_param     "${m_param_prefix}_INTERNAL_VREFDQ_MONITOR"         boolean   false                                     ""
   add_user_param     "${m_param_prefix}_CAL_MODE"                        integer   0                                         [list 0 3 4 5 6 8]
   add_user_param     "${m_param_prefix}_SELF_RFSH_ABORT"                 boolean   false                                     ""
   add_user_param     "${m_param_prefix}_READ_PREAMBLE_TRAINING"          boolean   false                                     ""
   add_user_param     "${m_param_prefix}_READ_PREAMBLE"                   integer   2                                         [list 1 2]
   add_user_param     "${m_param_prefix}_WRITE_PREAMBLE"                  integer   1                                         [list 1 2]

   add_user_param     "${m_param_prefix}_AC_PARITY_LATENCY"               string    DDR4_AC_PARITY_LATENCY_DISABLE            [enum_dropdown_entries DDR4_AC_PARITY_LATENCY]
   add_user_param     "${m_param_prefix}_ODT_IN_POWERDOWN"                boolean   true                                      ""
   add_user_param     "${m_param_prefix}_RTT_PARK"                        string    DDR4_RTT_PARK_ODT_DISABLED                [enum_dropdown_entries DDR4_RTT_PARK]
   add_user_param     "${m_param_prefix}_AC_PERSISTENT_ERROR"             boolean   false                                     ""
   add_user_param     "${m_param_prefix}_WRITE_DBI"                       boolean   false                                     ""
   add_user_param     "${m_param_prefix}_READ_DBI"                        boolean   true                                      ""

   add_user_param     "${m_param_prefix}_DEFAULT_VREFOUT"                 boolean   true                                     ""
   add_user_param     "${m_param_prefix}_USER_VREFDQ_TRAINING_VALUE"      float     56.0                                     ""
   add_user_param     "${m_param_prefix}_USER_VREFDQ_TRAINING_RANGE"      string    DDR4_VREFDQ_TRAINING_RANGE_1             [enum_dropdown_entries DDR4_VREFDQ_TRAINING_RANGE]

   add_user_param     "${m_param_prefix}_RCD_CA_IBT_ENUM"                 string    DDR4_RCD_CA_IBT_100                      [enum_dropdown_entries DDR4_RCD_CA_IBT]
   add_user_param     "${m_param_prefix}_RCD_CS_IBT_ENUM"                 string    DDR4_RCD_CS_IBT_100                      [enum_dropdown_entries DDR4_RCD_CS_IBT]
   add_user_param     "${m_param_prefix}_RCD_CKE_IBT_ENUM"                string    DDR4_RCD_CKE_IBT_100                     [enum_dropdown_entries DDR4_RCD_CKE_IBT]
   add_user_param     "${m_param_prefix}_RCD_ODT_IBT_ENUM"                string    DDR4_RCD_ODT_IBT_100                     [enum_dropdown_entries DDR4_RCD_ODT_IBT]

   add_user_param     "${m_param_prefix}_DB_RTT_NOM_ENUM"                 string    DDR4_DB_RTT_NOM_ODT_DISABLED             [enum_dropdown_entries DDR4_DB_RTT_NOM]
   add_user_param     "${m_param_prefix}_DB_RTT_WR_ENUM"                  string    DDR4_DB_RTT_WR_RZQ_3                     [enum_dropdown_entries DDR4_DB_RTT_WR]
   add_user_param     "${m_param_prefix}_DB_RTT_PARK_ENUM"                string    DDR4_DB_RTT_PARK_ODT_DISABLED            [enum_dropdown_entries DDR4_DB_RTT_PARK]
   add_user_param     "${m_param_prefix}_DB_DQ_DRV_ENUM"                  string    DDR4_DB_DRV_STR_RZQ_7                    [enum_dropdown_entries DDR4_DB_DRV_STR]

   add_user_param     "${m_param_prefix}_SPD_137_RCD_CA_DRV"              integer   [expr {0x65}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_138_RCD_CK_DRV"              integer   [expr {0x05}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_140_DRAM_VREFDQ_R0"          integer   [expr {0x1D}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_141_DRAM_VREFDQ_R1"          integer   [expr {0x1D}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_142_DRAM_VREFDQ_R2"          integer   [expr {0x1D}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_143_DRAM_VREFDQ_R3"          integer   [expr {0x1D}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_144_DB_VREFDQ"               integer   [expr {0x25}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_145_DB_MDQ_DRV"              integer   [expr {0x15}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_148_DRAM_DRV"                integer   [expr {0x00}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_149_DRAM_RTT_WR_NOM"         integer   [expr {0x14}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_152_DRAM_RTT_PARK"           integer   [expr {0x27}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]

   add_user_param     "${m_param_prefix}_SPD_133_RCD_DB_VENDOR_LSB"       integer   [expr {0x00}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_134_RCD_DB_VENDOR_MSB"       integer   [expr {0x00}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_135_RCD_REV"                 integer   [expr {0x00}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   add_user_param     "${m_param_prefix}_SPD_139_DB_REV"                  integer   [expr {0x00}]                            "{0:255}"     ""     ""     [list bit_width:8 hexadecimal]
   
   add_user_param     "${m_param_prefix}_LRDIMM_ODT_LESS_BS"              boolean   true                                     ""
   add_user_param     "${m_param_prefix}_LRDIMM_ODT_LESS_BS_PARK_OHM"     integer   240                                      ""
   
   set_parameter_property "${m_param_prefix}_LRDIMM_ODT_LESS_BS"          VISIBLE false
   set_parameter_property "${m_param_prefix}_LRDIMM_ODT_LESS_BS_PARK_OHM" VISIBLE false

   add_derived_param  "${m_param_prefix}_DQS_WIDTH"                   integer    8                                                    true
   add_derived_param  "${m_param_prefix}_CS_WIDTH"                    integer    1                                                    false
   add_derived_param  "${m_param_prefix}_CS_PER_DIMM"                 integer    1                                                    true
   add_derived_param  "${m_param_prefix}_CKE_WIDTH"                   integer    1                                                    false
   add_derived_param  "${m_param_prefix}_ODT_WIDTH"                   integer    1                                                    false
   add_derived_param  "${m_param_prefix}_ADDR_WIDTH"                  integer    1                                                    false
   add_derived_param  "${m_param_prefix}_RM_WIDTH"                    integer    0                                                    false
   add_derived_param  "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS"       integer    1                                                    false
   add_derived_param  "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"        integer    1                                                    false

   add_derived_param  "${m_param_prefix}_VREFDQ_TRAINING_VALUE"       float      56.0                                                 true
   add_derived_param  "${m_param_prefix}_VREFDQ_TRAINING_RANGE"       string     DDR4_VREFDQ_TRAINING_RANGE_1                         false
   add_derived_param  "${m_param_prefix}_VREFDQ_TRAINING_RANGE_DISP"  string     [enum_data DDR4_VREFDQ_TRAINING_RANGE_1 UI_NAME]     true

   add_derived_param  "${m_param_prefix}_TTL_DQS_WIDTH"              integer    8         false
   add_derived_param  "${m_param_prefix}_TTL_DQ_WIDTH"               integer    72        false
   add_derived_param  "${m_param_prefix}_TTL_CS_WIDTH"               integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_CK_WIDTH"               integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_CKE_WIDTH"              integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_ODT_WIDTH"              integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_BANK_ADDR_WIDTH"        integer    2         false
   add_derived_param  "${m_param_prefix}_TTL_BANK_GROUP_WIDTH"       integer    2         false
   add_derived_param  "${m_param_prefix}_TTL_CHIP_ID_WIDTH"          integer    0         false
   add_derived_param  "${m_param_prefix}_TTL_ADDR_WIDTH"             integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_RM_WIDTH"               integer    0         false
   add_derived_param  "${m_param_prefix}_TTL_NUM_OF_DIMMS"           integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_NUM_OF_PHYSICAL_RANKS"  integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_NUM_OF_LOGICAL_RANKS"   integer    1         false

   add_derived_param  "${m_param_prefix}_MR0"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR1"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR2"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR3"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR4"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR5"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR6"                     integer    0         false
   add_derived_param  "${m_param_prefix}_RDIMM_CONFIG"            string     ""        false
   add_derived_param  "${m_param_prefix}_LRDIMM_EXTENDED_CONFIG"  string     ""        false
   add_derived_param  "${m_param_prefix}_ADDRESS_MIRROR_BITVEC"   integer    0         false
   
   
   add_derived_param  "${m_param_prefix}_RCD_PARITY_CONTROL_WORD"  integer    13        false
   
   add_derived_param  "${m_param_prefix}_RCD_COMMAND_LATENCY"      integer    1         false
   
   add_user_param     "${m_param_prefix}_USE_DEFAULT_ODT"   boolean        true                                         ""
   add_user_param     "${m_param_prefix}_R_ODTN_1X1"        string_list    [list "Rank 0"]                              ""
   add_user_param     "${m_param_prefix}_R_ODT0_1X1"        string_list    [enum_data DDR4_DEFAULT_RODT_1X1_ODT0 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_1X1"        string_list    [list "Rank 0"]                              ""
   add_user_param     "${m_param_prefix}_W_ODT0_1X1"        string_list    [enum_data DDR4_DEFAULT_WODT_1X1_ODT0 VALUE] [list "off"  "on"]


   add_user_param     "${m_param_prefix}_R_ODTN_2X2"        string_list    [list "Rank 0" "Rank 1"]                     ""
   add_user_param     "${m_param_prefix}_R_ODT0_2X2"        string_list    [enum_data DDR4_DEFAULT_RODT_2X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_2X2"        string_list    [enum_data DDR4_DEFAULT_RODT_2X2_ODT1 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_2X2"        string_list    [list "Rank 0" "Rank 1"]                     ""
   add_user_param     "${m_param_prefix}_W_ODT0_2X2"        string_list    [enum_data DDR4_DEFAULT_WODT_2X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_2X2"        string_list    [enum_data DDR4_DEFAULT_WODT_2X2_ODT1 VALUE] [list "off"  "on"]


   add_user_param     "${m_param_prefix}_R_ODTN_4X2"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_R_ODT0_4X2"        string_list    [enum_data DDR4_DEFAULT_RODT_4X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_4X2"        string_list    [enum_data DDR4_DEFAULT_RODT_4X2_ODT1 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_4X2"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_W_ODT0_4X2"        string_list    [enum_data DDR4_DEFAULT_WODT_4X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_4X2"        string_list    [enum_data DDR4_DEFAULT_WODT_4X2_ODT1 VALUE] [list "off"  "on"]


   add_user_param     "${m_param_prefix}_R_ODTN_4X4"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_R_ODT0_4X4"        string_list    [enum_data DDR4_DEFAULT_RODT_4X4_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_4X4"        string_list    [enum_data DDR4_DEFAULT_RODT_4X4_ODT1 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT2_4X4"        string_list    [enum_data DDR4_DEFAULT_RODT_4X4_ODT2 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT3_4X4"        string_list    [enum_data DDR4_DEFAULT_RODT_4X4_ODT3 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_4X4"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_W_ODT0_4X4"        string_list    [enum_data DDR4_DEFAULT_WODT_4X4_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_4X4"        string_list    [enum_data DDR4_DEFAULT_WODT_4X4_ODT1 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT2_4X4"        string_list    [enum_data DDR4_DEFAULT_WODT_4X4_ODT2 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT3_4X4"        string_list    [enum_data DDR4_DEFAULT_WODT_4X4_ODT3 VALUE] [list "off"  "on"]

   add_derived_param "${m_param_prefix}_R_DERIVED_ODTN"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_R_DERIVED_ODT0"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_R_DERIVED_ODT1"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_R_DERIVED_ODT2"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_R_DERIVED_ODT3"          string_list    [list "" "" "" ""]                 TRUE

   add_derived_param "${m_param_prefix}_W_DERIVED_ODTN"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_W_DERIVED_ODT0"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_W_DERIVED_ODT1"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_W_DERIVED_ODT2"          string_list    [list "" "" "" ""]                 TRUE
   add_derived_param "${m_param_prefix}_W_DERIVED_ODT3"          string_list    [list "" "" "" ""]                 TRUE

   add_derived_param "${m_param_prefix}_SEQ_ODT_TABLE_LO"        integer        0                                  FALSE
   add_derived_param "${m_param_prefix}_SEQ_ODT_TABLE_HI"        integer        0                                  FALSE
   add_derived_param "${m_param_prefix}_CTRL_CFG_READ_ODT_CHIP"  integer        0                                  FALSE
   add_derived_param "${m_param_prefix}_CTRL_CFG_WRITE_ODT_CHIP" integer        0                                  FALSE
   add_derived_param "${m_param_prefix}_CTRL_CFG_READ_ODT_RANK"  integer        0                                  FALSE
   add_derived_param "${m_param_prefix}_CTRL_CFG_WRITE_ODT_RANK" integer        0                                  FALSE

   add_user_param     "${m_param_prefix}_SPEEDBIN_ENUM"    string     DDR4_SPEEDBIN_2400 [enum_dropdown_entries DDR4_SPEEDBIN] ""
   add_user_param     "${m_param_prefix}_TIS_PS"           integer    60                 {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TIS_AC_MV"        integer    100                {100}                                 ""                 "mV"
   add_user_param     "${m_param_prefix}_TIH_PS"           integer    95                 {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TIH_DC_MV"        integer    75                 {75}                                  ""                 "mV"
   add_user_param     "${m_param_prefix}_TDIVW_TOTAL_UI"   float      0.2                ""                                    ""                 "UI"
   add_user_param     "${m_param_prefix}_VDIVW_TOTAL"      integer    136                ""                                    ""                 "mV"
   add_user_param     "${m_param_prefix}_TDQSQ_UI"         float      0.16               ""                                    ""                 "UI"
   add_user_param     "${m_param_prefix}_TQH_UI"           float      0.76               ""                                    ""                 "UI"
   add_user_param     "${m_param_prefix}_TDVWP_UI"         float      0.72               ""                                    ""                 "UI"
   add_user_param     "${m_param_prefix}_TDQSCK_PS"        integer    165                {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDQSS_CYC"        float      0.27               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TQSH_CYC"         float      0.38               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TDSH_CYC"         float      0.18               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TDSS_CYC"         float      0.18               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TWLS_PS"          float      108                ""                                    "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TWLH_PS"          float      108                ""                                    "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TINIT_US"         integer    500                ""                                    "Microseconds"     ""
   add_user_param     "${m_param_prefix}_TMRD_CK_CYC"      integer    8                  ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TRAS_NS"          float      32                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRCD_NS"          float      15                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRP_NS"           float      15                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TREFI_US"         float      7.8                ""                                    "Microseconds"     ""
   add_user_param     "${m_param_prefix}_TRFC_NS"          float      260                ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TWR_NS"           float      15                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TWTR_L_CYC"       integer    9                  ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TWTR_S_CYC"       integer    3                  ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TFAW_NS"          float      21                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRRD_L_CYC"       integer    6                  ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TRRD_S_CYC"       integer    4                  ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TCCD_L_CYC"       integer    6                  [list 4 5 6 7 8]                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TCCD_S_CYC"       integer    4                  ""                                    "Cycles"           ""
   add_user_param             "${m_param_prefix}_TDIVW_DJ_CYC"     float      0.1                ""                                    "Cycles"           ""
   add_user_param             "${m_param_prefix}_TDQSQ_PS"         integer    66                 {-5000:5000}                          "picoseconds"      ""
   add_user_param             "${m_param_prefix}_TQH_CYC"          float      0.38               ""                                    "Cycles"           ""
   set_parameter_property     "${m_param_prefix}_TDIVW_DJ_CYC"     VISIBLE false
   set_parameter_property     "${m_param_prefix}_TDQSQ_PS"         VISIBLE false
   set_parameter_property     "${m_param_prefix}_TQH_CYC"          VISIBLE false

   add_derived_param  "${m_param_prefix}_TINIT_CK"          integer    499       false
   add_derived_param  "${m_param_prefix}_TDQSCK_DERV_PS"    integer    2         false
   add_derived_param  "${m_param_prefix}_TDQSCKDS"          integer    450       false
   add_derived_param  "${m_param_prefix}_TDQSCKDM"          integer    900       false
   add_derived_param  "${m_param_prefix}_TDQSCKDL"          integer    1200      false
   add_derived_param  "${m_param_prefix}_TRAS_CYC"          integer    36        false
   add_derived_param  "${m_param_prefix}_TRCD_CYC"          integer    14        false
   add_derived_param  "${m_param_prefix}_TRP_CYC"           integer    14        false
   add_derived_param  "${m_param_prefix}_TRFC_CYC"          integer    171       false
   add_derived_param  "${m_param_prefix}_TWR_CYC"           integer    18        false
   add_derived_param  "${m_param_prefix}_TRTP_CYC"          integer    9         false
   add_derived_param  "${m_param_prefix}_TFAW_CYC"          integer    27        false
   add_derived_param  "${m_param_prefix}_TREFI_CYC"         integer    8320      false
   add_derived_param  "${m_param_prefix}_WRITE_CMD_LATENCY" integer    5         false

   add_derived_param  "${m_param_prefix}_CFG_GEN_SBE"      boolean    false     false
   add_derived_param  "${m_param_prefix}_CFG_GEN_DBE"      boolean    false     false

   set_parameter_update_callback "${m_param_prefix}_DEFAULT_VREFOUT"        ::altera_emif::ip_top::mem::ddr4::_trigger_non_default_vrefout
   set_parameter_update_callback "${m_param_prefix}_RTT_NOM_ENUM"           ::altera_emif::ip_top::mem::ddr4::_update_vrefout_default
   set_parameter_update_callback "${m_param_prefix}_RTT_WR_ENUM"            ::altera_emif::ip_top::mem::ddr4::_update_vrefout_default
   set_parameter_update_callback "${m_param_prefix}_RTT_PARK"               ::altera_emif::ip_top::mem::ddr4::_update_vrefout_default
   set_parameter_update_callback "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS"  ::altera_emif::ip_top::mem::ddr4::_update_vrefout_default

   if {![ini_is_on "emif_show_internal_settings"]} {

      set_parameter_property "${m_param_prefix}_GEARDOWN"                 VISIBLE  false
      set_parameter_property "${m_param_prefix}_MAX_POWERDOWN"            VISIBLE  false
      set_parameter_property "${m_param_prefix}_READ_PREAMBLE_TRAINING"   VISIBLE  false
      set_parameter_property "${m_param_prefix}_PER_DRAM_ADDR"            VISIBLE  false
      set_parameter_property "${m_param_prefix}_TEMP_SENSOR_READOUT"      VISIBLE  false
      set_parameter_property "${m_param_prefix}_MPR_READ_FORMAT"          VISIBLE  false
      set_parameter_property "${m_param_prefix}_CAL_MODE"                 VISIBLE  false
      set_parameter_property "${m_param_prefix}_AC_PERSISTENT_ERROR"      VISIBLE  false

      set_parameter_property "${m_param_prefix}_DLL_EN"                   VISIBLE  false

      set_parameter_property "${m_param_prefix}_WRITE_CRC"                VISIBLE  false
      
      set_parameter_property "${m_param_prefix}_ALERT_PAR_EN"             VISIBLE  false
   }
   
   add_user_param "${m_param_prefix}_LRDIMM_VREFDQ_VALUE" string "" ""
   set_parameter_property "${m_param_prefix}_LRDIMM_VREFDQ_VALUE" VISIBLE false


   return 1
}

proc ::altera_emif::ip_top::mem::ddr4::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix

   if {$base_family_enum == "FAMILY_ARRIA10"} {
      if {$is_hps} {
         set_param_default "${m_param_prefix}_DQ_WIDTH" 32
      }
   } elseif {$base_family_enum == "FAMILY_STRATIX10"} {
      if {$is_hps} {
         set_param_default "${m_param_prefix}_DQ_WIDTH" 64
      }
   }

   return 1
}

proc ::altera_emif::ip_top::mem::ddr4::add_display_items {tabs} {
   variable m_param_prefix

   set mem_params_tab [lindex $tabs 0]
   set mem_io_tab     [lindex $tabs 1]
   set mem_timing_tab [lindex $tabs 2]

   set topology_grp [get_string GRP_MEM_TOPOLOGY_NAME]
   set lat_grp      [get_string GRP_MEM_LATENCY_NAME]
   set mrs_grp      [get_string GRP_MEM_MRS_NAME]

   add_param_to_gui $topology_grp "${m_param_prefix}_FORMAT_ENUM"
   add_param_to_gui $topology_grp "${m_param_prefix}_DQ_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_DQ_PER_DQS"
   add_param_to_gui $topology_grp "${m_param_prefix}_DQS_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_CK_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_DISCRETE_CS_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_NUM_OF_DIMMS"
   add_param_to_gui $topology_grp "${m_param_prefix}_RANKS_PER_DIMM"
   add_param_to_gui $topology_grp "${m_param_prefix}_RM_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_CS_PER_DIMM"
   add_param_to_gui $topology_grp "${m_param_prefix}_CKE_PER_DIMM"
   add_param_to_gui $topology_grp "${m_param_prefix}_ROW_ADDR_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_COL_ADDR_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_BANK_ADDR_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_BANK_GROUP_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_CHIP_ID_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_DM_EN"
   add_param_to_gui $topology_grp "${m_param_prefix}_WRITE_DBI"
   add_param_to_gui $topology_grp "${m_param_prefix}_READ_DBI"
   add_param_to_gui $topology_grp "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"
   add_param_to_gui $topology_grp "${m_param_prefix}_MIRROR_ADDRESSING_EN"
   add_param_to_gui $topology_grp "${m_param_prefix}_ALERT_PAR_EN"
   add_param_to_gui $topology_grp "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"
   add_param_to_gui $topology_grp "${m_param_prefix}_ALERT_N_DQS_GROUP"
   add_param_to_gui $topology_grp "${m_param_prefix}_ALERT_N_AC_LANE"
   add_param_to_gui $topology_grp "${m_param_prefix}_ALERT_N_AC_PIN"
   
   add_param_to_gui $lat_grp "${m_param_prefix}_TCL"
   add_param_to_gui $lat_grp "${m_param_prefix}_WTCL"
   add_param_to_gui $lat_grp "${m_param_prefix}_ATCL_ENUM"
   add_param_to_gui $lat_grp "${m_param_prefix}_AC_PARITY_LATENCY"
   add_param_to_gui $lat_grp "${m_param_prefix}_BL_ENUM"
   add_param_to_gui $lat_grp "${m_param_prefix}_BT_ENUM"

   add_param_to_gui $mrs_grp "${m_param_prefix}_HIDE_ADV_MR_SETTINGS"
   add_param_to_gui $mrs_grp "${m_param_prefix}_DLL_EN"
   add_param_to_gui $mrs_grp "${m_param_prefix}_ASR_ENUM"
   add_param_to_gui $mrs_grp "${m_param_prefix}_WRITE_CRC"
   add_param_to_gui $mrs_grp "${m_param_prefix}_GEARDOWN"
   add_param_to_gui $mrs_grp "${m_param_prefix}_PER_DRAM_ADDR"
   add_param_to_gui $mrs_grp "${m_param_prefix}_TEMP_SENSOR_READOUT"
   add_param_to_gui $mrs_grp "${m_param_prefix}_FINE_GRANULARITY_REFRESH"
   add_param_to_gui $mrs_grp "${m_param_prefix}_MPR_READ_FORMAT"
   add_param_to_gui $mrs_grp "${m_param_prefix}_MAX_POWERDOWN"
   add_param_to_gui $mrs_grp "${m_param_prefix}_TEMP_CONTROLLED_RFSH_RANGE"
   add_param_to_gui $mrs_grp "${m_param_prefix}_TEMP_CONTROLLED_RFSH_ENA"
   add_param_to_gui $mrs_grp "${m_param_prefix}_INTERNAL_VREFDQ_MONITOR"
   add_param_to_gui $mrs_grp "${m_param_prefix}_CAL_MODE"
   add_param_to_gui $mrs_grp "${m_param_prefix}_SELF_RFSH_ABORT"
   add_param_to_gui $mrs_grp "${m_param_prefix}_READ_PREAMBLE_TRAINING"
   add_param_to_gui $mrs_grp "${m_param_prefix}_READ_PREAMBLE"
   add_param_to_gui $mrs_grp "${m_param_prefix}_WRITE_PREAMBLE"
   add_param_to_gui $mrs_grp "${m_param_prefix}_ODT_IN_POWERDOWN"
   add_param_to_gui $mrs_grp "${m_param_prefix}_AC_PERSISTENT_ERROR"

   set io_grp           [get_string GRP_MEM_IO_NAME]
   set rlrdimm_spd_grp  [get_string GRP_MEM_RLRDIMM_SPD_NAME]
   set odt_grp          [get_string GRP_MEM_ODT_NAME]

   add_param_to_gui $io_grp "${m_param_prefix}_DRV_STR_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RTT_WR_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RTT_NOM_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RTT_PARK"

   add_param_to_gui $io_grp "${m_param_prefix}_RCD_CA_IBT_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RCD_CS_IBT_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RCD_CKE_IBT_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RCD_ODT_IBT_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_DB_RTT_NOM_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_DB_RTT_WR_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_DB_RTT_PARK_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_DB_DQ_DRV_ENUM"
   
   add_param_to_gui $io_grp "${m_param_prefix}_DEFAULT_VREFOUT"
   add_param_to_gui $io_grp "${m_param_prefix}_VREFDQ_TRAINING_VALUE"
   add_param_to_gui $io_grp "${m_param_prefix}_VREFDQ_TRAINING_RANGE_DISP"
   add_param_to_gui $io_grp "${m_param_prefix}_USER_VREFDQ_TRAINING_VALUE"
   add_param_to_gui $io_grp "${m_param_prefix}_USER_VREFDQ_TRAINING_RANGE"
   
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_137_RCD_CA_DRV"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_138_RCD_CK_DRV"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_140_DRAM_VREFDQ_R0"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_141_DRAM_VREFDQ_R1"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_142_DRAM_VREFDQ_R2"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_143_DRAM_VREFDQ_R3"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_144_DB_VREFDQ"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_145_DB_MDQ_DRV"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_148_DRAM_DRV"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_149_DRAM_RTT_WR_NOM"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_152_DRAM_RTT_PARK"   
   
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_133_RCD_DB_VENDOR_LSB"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_134_RCD_DB_VENDOR_MSB"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_135_RCD_REV"
   add_param_to_gui $rlrdimm_spd_grp "${m_param_prefix}_SPD_139_DB_REV"
   
   add_display_item $mem_io_tab $odt_grp GROUP
   
   add_param_to_gui $odt_grp "${m_param_prefix}_USE_DEFAULT_ODT"

   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_rtbl_id1" "<html><b>ODT Assertion Table during Read Accesses</b><br>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_rtbl_id2" "<html>Set the value to on to assert a given ODT signal when reading from a specific rank<br>"
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_1x1_rtbl" [list table fixed_size rows:2]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_2x2_rtbl" [list table fixed_size rows:3]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_4x2_rtbl" [list table fixed_size rows:5]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_4x4_rtbl" [list table fixed_size rows:5]

   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_wtbl_id3" "<html><b>ODT Assertion Table during Write Accesses</b><br>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_wtbl_id4" "<html>Set the value to on to assert a given ODT signal when writing to a specific rank<br>"
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_1x1_wtbl" [list table fixed_size rows:2]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_2x2_wtbl" [list table fixed_size rows:3]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_4x2_wtbl" [list table fixed_size rows:5]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_4x4_wtbl" [list table fixed_size rows:5]


   add_param_to_table "${m_param_prefix}_odt_1x1_rtbl" "${m_param_prefix}_R_ODTN_1X1"
   add_param_to_table "${m_param_prefix}_odt_1x1_rtbl" "${m_param_prefix}_R_ODT0_1X1"
   add_param_to_table "${m_param_prefix}_odt_1x1_wtbl" "${m_param_prefix}_W_ODTN_1X1"
   add_param_to_table "${m_param_prefix}_odt_1x1_wtbl" "${m_param_prefix}_W_ODT0_1X1"

   set_parameter_property "${m_param_prefix}_R_ODTN_1X1" ENABLED false
   set_parameter_property "${m_param_prefix}_W_ODTN_1X1" ENABLED false

   add_param_to_table "${m_param_prefix}_odt_2x2_rtbl" "${m_param_prefix}_R_ODTN_2X2"
   add_param_to_table "${m_param_prefix}_odt_2x2_rtbl" "${m_param_prefix}_R_ODT0_2X2"
   add_param_to_table "${m_param_prefix}_odt_2x2_rtbl" "${m_param_prefix}_R_ODT1_2X2"
   add_param_to_table "${m_param_prefix}_odt_2x2_wtbl" "${m_param_prefix}_W_ODTN_2X2"
   add_param_to_table "${m_param_prefix}_odt_2x2_wtbl" "${m_param_prefix}_W_ODT0_2X2"
   add_param_to_table "${m_param_prefix}_odt_2x2_wtbl" "${m_param_prefix}_W_ODT1_2X2"

   set_parameter_property "${m_param_prefix}_R_ODTN_2X2" ENABLED false
   set_parameter_property "${m_param_prefix}_W_ODTN_2X2" ENABLED false

   add_param_to_table "${m_param_prefix}_odt_4x2_rtbl" "${m_param_prefix}_R_ODTN_4X2"
   add_param_to_table "${m_param_prefix}_odt_4x2_rtbl" "${m_param_prefix}_R_ODT0_4X2"
   add_param_to_table "${m_param_prefix}_odt_4x2_rtbl" "${m_param_prefix}_R_ODT1_4X2"
   add_param_to_table "${m_param_prefix}_odt_4x2_wtbl" "${m_param_prefix}_W_ODTN_4X2"
   add_param_to_table "${m_param_prefix}_odt_4x2_wtbl" "${m_param_prefix}_W_ODT0_4X2"
   add_param_to_table "${m_param_prefix}_odt_4x2_wtbl" "${m_param_prefix}_W_ODT1_4X2"

   set_parameter_property "${m_param_prefix}_R_ODTN_4X2" ENABLED false
   set_parameter_property "${m_param_prefix}_W_ODTN_4X2" ENABLED false

   add_param_to_table "${m_param_prefix}_odt_4x4_rtbl" "${m_param_prefix}_R_ODTN_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_rtbl" "${m_param_prefix}_R_ODT0_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_rtbl" "${m_param_prefix}_R_ODT1_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_rtbl" "${m_param_prefix}_R_ODT2_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_rtbl" "${m_param_prefix}_R_ODT3_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_wtbl" "${m_param_prefix}_W_ODTN_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_wtbl" "${m_param_prefix}_W_ODT0_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_wtbl" "${m_param_prefix}_W_ODT1_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_wtbl" "${m_param_prefix}_W_ODT2_4X4"
   add_param_to_table "${m_param_prefix}_odt_4x4_wtbl" "${m_param_prefix}_W_ODT3_4X4"

   set_parameter_property "${m_param_prefix}_R_ODTN_4X4" ENABLED false
   set_parameter_property "${m_param_prefix}_W_ODTN_4X4" ENABLED false

   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_rtbl_id3" "<html><b>Derived ODT Matrix for Read Accesses</b>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_rtbl_id4" "<html>This matrix is derived based on settings for RTT_DRV, RTT_NOM, RTT_PARK and the read ODT assertion table."
   add_table_to_gui $odt_grp "${m_param_prefix}_derived_odt_rtbl" [list table fixed_size rows:5]
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODTN"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT0"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT1"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT2"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT3"

   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_wtbl_id5" "<html><b>Derived ODT Matrix for Write Accesses</b>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_rtbl_id6" "<html>This matrix is derived based on settings for RTT_WR, RTT_NOM, RTT_PARK and the write ODT assertion table."
   add_table_to_gui $odt_grp "${m_param_prefix}_derived_odt_wtbl" [list table fixed_size rows:5]
   add_param_to_table "${m_param_prefix}_derived_odt_wtbl" "${m_param_prefix}_W_DERIVED_ODTN"
   add_param_to_table "${m_param_prefix}_derived_odt_wtbl" "${m_param_prefix}_W_DERIVED_ODT0"
   add_param_to_table "${m_param_prefix}_derived_odt_wtbl" "${m_param_prefix}_W_DERIVED_ODT1"
   add_param_to_table "${m_param_prefix}_derived_odt_wtbl" "${m_param_prefix}_W_DERIVED_ODT2"
   add_param_to_table "${m_param_prefix}_derived_odt_wtbl" "${m_param_prefix}_W_DERIVED_ODT3"

   set timing_sb_grp         [get_string GRP_MEM_TIMING_SPEEDBIN]
   set timing_sb_freq_ps_grp [get_string GRP_MEM_TIMING_SPEEDBIN_FREQ_PAGESIZE]
   set timing_d_t_grp        [get_string GRP_MEM_TIMING_DENSITY_TEMP]

   add_text_to_gui  $mem_timing_tab "${m_param_prefix}_id1" "<html>Timing parameters as found in the data sheet of the memory device.<BR>"

   add_display_item $mem_timing_tab $timing_sb_grp GROUP
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_SPEEDBIN_ENUM"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TIS_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TIS_AC_MV"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TIH_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TIH_DC_MV"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDIVW_TOTAL_UI"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_VDIVW_TOTAL"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSQ_UI"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TQH_UI"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDVWP_UI"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCK_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCKDS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCKDM"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCKDL"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSS_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TQSH_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDSH_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDSS_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TWLS_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TWLH_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TINIT_US"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TMRD_CK_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TRAS_NS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TRCD_NS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TRP_NS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TWR_NS"

   add_display_item $mem_timing_tab $timing_sb_freq_ps_grp GROUP
   add_text_to_gui  $timing_sb_freq_ps_grp "${m_param_prefix}_id2" "<html>Update the following as you change the operating frequency, even if the device speed bin has not changed."
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TRRD_S_CYC"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TRRD_L_CYC"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TFAW_NS"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TCCD_S_CYC"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TCCD_L_CYC"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TWTR_S_CYC"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TWTR_L_CYC"

   add_display_item $mem_timing_tab $timing_d_t_grp GROUP
   add_text_to_gui  $timing_d_t_grp "${m_param_prefix}_id3" "<html>Update the following as you change the physical memory device density.<BR>Incorrect values can cause data corruption."
   add_param_to_gui $timing_d_t_grp "${m_param_prefix}_TRFC_NS"
   add_param_to_gui $timing_d_t_grp "${m_param_prefix}_TREFI_US"

   return 1
}

proc ::altera_emif::ip_top::mem::ddr4::validate {} {

   variable m_param_prefix

   set odt_grp [get_string GRP_MEM_ODT_NAME]
   set_display_item_property $odt_grp VISIBLE true

   _show_hide_adv_mrs_settings

   _validate_memory_parameters

   _validate_and_derive_ttl_width_parameters

   _validate_memory_timing_parameters

   if {![has_pending_ipgen_e_msg]} {

      _derive_protocol_agnostic_parameters

      _derive_memory_timing_parameters

      _derive_mode_register_parameters

      _derive_odt_parameters
   }

   return 1
}


proc ::altera_emif::ip_top::mem::ddr4::_show_hide_adv_mrs_settings {} {
   variable m_param_prefix
   set show [expr {[get_parameter_value "${m_param_prefix}_HIDE_ADV_MR_SETTINGS"] ? 0 : 1}]

   set_parameter_property    "${m_param_prefix}_ASR_ENUM"                   VISIBLE $show
   set_parameter_property    "${m_param_prefix}_FINE_GRANULARITY_REFRESH"   VISIBLE $show
   set_parameter_property    "${m_param_prefix}_TEMP_CONTROLLED_RFSH_RANGE" VISIBLE $show
   set_parameter_property    "${m_param_prefix}_TEMP_CONTROLLED_RFSH_ENA"   VISIBLE $show
   set_parameter_property    "${m_param_prefix}_INTERNAL_VREFDQ_MONITOR"    VISIBLE $show
   set_parameter_property    "${m_param_prefix}_SELF_RFSH_ABORT"            VISIBLE $show
   set_parameter_property    "${m_param_prefix}_READ_PREAMBLE"              VISIBLE $show
   set_parameter_property    "${m_param_prefix}_WRITE_PREAMBLE"             VISIBLE $show
   set_parameter_property    "${m_param_prefix}_ODT_IN_POWERDOWN"           VISIBLE $show
}

proc ::altera_emif::ip_top::mem::ddr4::_validate_memory_parameters {} {

   variable m_param_prefix

   set format_enum            [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_discrete            [expr {$format_enum == "MEM_FORMAT_DISCRETE"}]
   set is_udimm               [expr {$format_enum == "MEM_FORMAT_UDIMM"}]
   set is_rdimm               [expr {$format_enum == "MEM_FORMAT_RDIMM"}]
   set is_lrdimm              [expr {$format_enum == "MEM_FORMAT_LRDIMM"}]
   set is_sodimm              [expr {$format_enum == "MEM_FORMAT_SODIMM"}]
   set row_addr_width         [get_parameter_value "${m_param_prefix}_ROW_ADDR_WIDTH"]
   set col_addr_width         [get_parameter_value "${m_param_prefix}_COL_ADDR_WIDTH"]
   set bg_width               [get_parameter_value "${m_param_prefix}_BANK_GROUP_WIDTH"]
   set ck_width               [get_parameter_value "${m_param_prefix}_CK_WIDTH"]
   set cke_width              [get_parameter_value "${m_param_prefix}_CKE_WIDTH"]
   set cs_width               [get_parameter_value "${m_param_prefix}_CS_WIDTH"]
   set odt_width              [get_parameter_value "${m_param_prefix}_ODT_WIDTH"]
   set chip_id_width          [get_parameter_value "${m_param_prefix}_CHIP_ID_WIDTH"]
   set dq_width               [get_parameter_value "${m_param_prefix}_DQ_WIDTH"]
   set dq_per_dqs             [get_parameter_value "${m_param_prefix}_DQ_PER_DQS"]
   set dm_en                  [get_parameter_value "${m_param_prefix}_DM_EN"]
   set discrete_cs_width      [get_parameter_value "${m_param_prefix}_DISCRETE_CS_WIDTH"]
   set num_of_dimms           [get_parameter_value "${m_param_prefix}_NUM_OF_DIMMS"]
   set ranks_per_dimm         [get_parameter_value "${m_param_prefix}_RANKS_PER_DIMM"]
   set bl_enum                [get_parameter_value "${m_param_prefix}_BL_ENUM"]
   set read_dbi               [get_parameter_value "${m_param_prefix}_READ_DBI"]
   set write_dbi              [get_parameter_value "${m_param_prefix}_WRITE_DBI"]
   set vrefdq_training_value  [get_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_VALUE"]
   set vrefdq_training_range  [enum_data [get_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE"] MRS]
   set ac_parity_latency      [get_parameter_value "${m_param_prefix}_AC_PARITY_LATENCY"]
   set alert_par_en           [get_parameter_value "${m_param_prefix}_ALERT_PAR_EN"]
   set crc_en                 [get_parameter_value "${m_param_prefix}_WRITE_CRC"]
   set nominal_odt_enum       [get_parameter_value "${m_param_prefix}_RTT_NOM_ENUM"]
   set alert_n_placement_enum [get_parameter_value "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"]
   set mem_tcl                [get_parameter_value "${m_param_prefix}_TCL"]
   set mem_wtcl               [get_parameter_value "${m_param_prefix}_WTCL"]
   set read_preamble          [get_parameter_value "${m_param_prefix}_READ_PREAMBLE"]
   set write_preamble         [get_parameter_value "${m_param_prefix}_WRITE_PREAMBLE"]
   set default_vrefout        [get_parameter_value "${m_param_prefix}_DEFAULT_VREFOUT"]
   set spd_145_val            [get_parameter_value "${m_param_prefix}_SPD_145_DB_MDQ_DRV"]
   set spd_148_val            [get_parameter_value "${m_param_prefix}_SPD_148_DRAM_DRV"]
   set spd_149_val            [get_parameter_value "${m_param_prefix}_SPD_149_DRAM_RTT_WR_NOM"]
   set spd_152_val            [get_parameter_value "${m_param_prefix}_SPD_152_DRAM_RTT_PARK"]
   set mem_clk_freq           [get_parameter_value PHY_DDR4_MEM_CLK_FREQ_MHZ]
   set mem_data_rate          [expr {$mem_clk_freq * 2}]

   if {$is_discrete} {
      set addr_mirror_applicable [expr {($discrete_cs_width > 1)}]
      set addr_mirror            [expr {[get_parameter_value "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"] && $addr_mirror_applicable}]
   } else {
      set addr_mirror_applicable [expr {($ranks_per_dimm > 1)}]
      set addr_mirror            [expr {[get_parameter_value "${m_param_prefix}_MIRROR_ADDRESSING_EN"] && $addr_mirror_applicable}]
   }

   set chip_id_max_width [get_family_trait FAMILY_TRAIT_HMC_DDR4_CHIP_ID_MAX]
   set_parameter_property "${m_param_prefix}_CHIP_ID_WIDTH"                  VISIBLE [expr {$chip_id_max_width > 0 ? true : false}]

   set_parameter_property "${m_param_prefix}_CKE_PER_DIMM"                   VISIBLE false

   set_parameter_property "${m_param_prefix}_DISCRETE_CS_WIDTH"              VISIBLE $is_discrete
   set_parameter_property "${m_param_prefix}_NUM_OF_DIMMS"                   VISIBLE [expr {!$is_discrete}]
   set_parameter_property "${m_param_prefix}_RANKS_PER_DIMM"                 VISIBLE [expr {!$is_discrete}]
   set_parameter_property "${m_param_prefix}_RM_WIDTH"                       VISIBLE false 
   set_parameter_property "${m_param_prefix}_CS_PER_DIMM"                    VISIBLE [expr {!$is_discrete}]
   set_parameter_property "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"  VISIBLE [expr {$is_discrete && $addr_mirror_applicable}]
   set_parameter_property "${m_param_prefix}_MIRROR_ADDRESSING_EN"           VISIBLE [expr {!$is_discrete && $addr_mirror_applicable}]
   
   set_parameter_property "${m_param_prefix}_RTT_PARK"                       VISIBLE [expr {!$is_lrdimm}]
   set_parameter_property "${m_param_prefix}_RTT_WR_ENUM"                    VISIBLE [expr {!$is_lrdimm}]
   set_parameter_property "${m_param_prefix}_RTT_NOM_ENUM"                   VISIBLE [expr {!$is_lrdimm}]
   set_parameter_property "${m_param_prefix}_DRV_STR_ENUM"                   VISIBLE [expr {!$is_lrdimm}]
   set_parameter_property "${m_param_prefix}_RCD_CA_IBT_ENUM"                VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_parameter_property "${m_param_prefix}_RCD_CS_IBT_ENUM"                VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_parameter_property "${m_param_prefix}_RCD_CKE_IBT_ENUM"               VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_parameter_property "${m_param_prefix}_RCD_ODT_IBT_ENUM"               VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_parameter_property "${m_param_prefix}_DB_RTT_NOM_ENUM"                VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_DB_RTT_WR_ENUM"                 VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_DB_RTT_PARK_ENUM"               VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_DB_DQ_DRV_ENUM"                 VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_137_RCD_CA_DRV"             VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_parameter_property "${m_param_prefix}_SPD_138_RCD_CK_DRV"             VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_parameter_property "${m_param_prefix}_SPD_140_DRAM_VREFDQ_R0"         VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_141_DRAM_VREFDQ_R1"         VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_142_DRAM_VREFDQ_R2"         VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_143_DRAM_VREFDQ_R3"         VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_144_DB_VREFDQ"              VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_145_DB_MDQ_DRV"             VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_148_DRAM_DRV"               VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_149_DRAM_RTT_WR_NOM"        VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_152_DRAM_RTT_PARK"          VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_133_RCD_DB_VENDOR_LSB"      VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_134_RCD_DB_VENDOR_MSB"      VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_135_RCD_REV"                VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_SPD_139_DB_REV"                 VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_USE_DEFAULT_ODT"                VISIBLE [expr {!$is_lrdimm}]
   
   set_parameter_property "${m_param_prefix}_USER_VREFDQ_TRAINING_VALUE"     VISIBLE [expr {!$default_vrefout}]
   set_parameter_property "${m_param_prefix}_VREFDQ_TRAINING_VALUE"          VISIBLE [expr {$default_vrefout}]
   set_parameter_property "${m_param_prefix}_USER_VREFDQ_TRAINING_RANGE"     VISIBLE [expr {!$default_vrefout}]
   set_parameter_property "${m_param_prefix}_VREFDQ_TRAINING_RANGE_DISP"     VISIBLE [expr {$default_vrefout}]

   if {$default_vrefout} {
      _update_vrefout_default
   } else {
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_VALUE"      [get_parameter_value "${m_param_prefix}_USER_VREFDQ_TRAINING_VALUE"]
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE"      [get_parameter_value "${m_param_prefix}_USER_VREFDQ_TRAINING_RANGE"]
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE_DISP" [enum_data [get_parameter_value "${m_param_prefix}_USER_VREFDQ_TRAINING_RANGE"] UI_NAME]
   }   
   
   set_display_item_property [get_string DDR3_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR3_LRDIMM_TXT_NAME]        VISIBLE false

   set_parameter_property "${m_param_prefix}_ALERT_N_DQS_GROUP"       VISIBLE [expr {$alert_n_placement_enum == "DDR4_ALERT_N_PLACEMENT_DATA_LANES"}]
   set_parameter_property "${m_param_prefix}_ALERT_N_AC_LANE"         VISIBLE [expr {$alert_n_placement_enum == "DDR4_ALERT_N_PLACEMENT_AC_LANES"}]
   set_parameter_property "${m_param_prefix}_ALERT_N_AC_PIN"          VISIBLE [expr {$alert_n_placement_enum == "DDR4_ALERT_N_PLACEMENT_AC_LANES"}]
   set_parameter_property "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"  ENABLED $alert_par_en
   set_parameter_property "${m_param_prefix}_ALERT_N_DQS_GROUP"       ENABLED $alert_par_en
   set_parameter_property "${m_param_prefix}_ALERT_N_AC_LANE"         ENABLED $alert_par_en
   set_parameter_property "${m_param_prefix}_ALERT_N_AC_PIN"          ENABLED $alert_par_en

   set addr_width [expr {max($row_addr_width, $col_addr_width, 17)}]
   set_parameter_value "${m_param_prefix}_ADDR_WIDTH" $addr_width

   if {$chip_id_width > 0} {
      post_ipgen_w_msg MSG_DDR4_CHIP_ID_SUPPORT_PRELIMINARY
      
      if {$chip_id_width > $chip_id_max_width} {
         post_ipgen_e_msg MSG_DDR4_CHIP_ID_WIDTH_OUT_OF_RANGE [list $chip_id_max_width $chip_id_width]
      }

      if {$ck_width > 2} {
         post_ipgen_e_msg MSG_DDR4_3DS_MAX_CK_WIDTH_EXCEEDED
      }
   }

   if {[expr {$dq_width % $dq_per_dqs}] != 0 || $dq_width <= 0} {
      set dqs_width 1
      post_ipgen_e_msg MSG_DDRX_DQ_WIDTH_NOT_DIVISIBLE_BY_DQ_PER_DQS
   } else {
      set dqs_width [expr {$dq_width / $dq_per_dqs}]
      set_parameter_value "${m_param_prefix}_DQS_WIDTH" $dqs_width
   }

   set valid_dqs_groups [list]
   for {set i 0} {$i < $dqs_width} {incr i} {
      lappend valid_dqs_groups $i
   }
   set_parameter_property "${m_param_prefix}_ALERT_N_DQS_GROUP" ALLOWED_RANGES $valid_dqs_groups

   if {($dm_en || $read_dbi || $write_dbi) && $dq_per_dqs == 4} {
      post_ipgen_e_msg MSG_DDR4_NO_DM_DBI_FOR_X4_MODE
   }

   if {!$read_dbi && $mem_clk_freq >= 1200 && $dq_per_dqs == 8} {
      post_ipgen_w_msg MSG_RECOMMEND_DDR4_RDBI_EN
   }

   if {$dq_per_dqs == 4 && [expr {$dqs_width % 2 == 1}]} {
      post_ipgen_e_msg MSG_DDRX_ODD_DQS_GROUPS_IN_X4_MODE
   }

   if {$dq_per_dqs == 4 && $crc_en} {
      post_ipgen_e_msg MSG_DDR4_NO_CRC_IN_X4_MODE
   }

   if {$crc_en} {
      post_ipgen_e_msg MSG_DDR4_NO_CRC
   }

   if {($is_rdimm || $is_lrdimm) && ($bg_width != 2)} {
      post_ipgen_e_msg MSG_DDR4_RDIMM_LRDIMM_BANK_GROUP_WIDTH_TOO_LOW
   }

   if {($is_udimm || $is_rdimm || $is_sodimm) && ($ranks_per_dimm != 1 && $ranks_per_dimm != 2 && $ranks_per_dimm != 4)} {
      post_ipgen_e_msg MSG_DDRX_MAX_RANKS_PER_DIMM_EXCEEDED
   }
   if {$is_lrdimm && $ranks_per_dimm != 2 && $ranks_per_dimm != 4} {
      post_ipgen_e_msg MSG_DDR4_LRDIMM_RANKS_PER_DIMM_UNSUPPORTED
   }

   if {$is_lrdimm && ($dq_per_dqs != 4)} {
      post_ipgen_e_msg MSG_DDR4_LRDIMM_ONLY_4_DQ_PER_DQS
   }

   set num_of_physical_ranks [expr {$is_discrete ? $discrete_cs_width : ($num_of_dimms * $ranks_per_dimm)}]
   set_parameter_value "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS" $num_of_physical_ranks

   set num_of_logical_ranks $num_of_physical_ranks
   set_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS" $num_of_logical_ranks

   if {$is_udimm || $is_sodimm || $is_rdimm || $is_lrdimm} {
      set cs_per_dimm $ranks_per_dimm
   } else {
      set cs_per_dimm 1
   }
   set_parameter_value "${m_param_prefix}_CS_PER_DIMM" $cs_per_dimm

   set_parameter_value "${m_param_prefix}_RM_WIDTH" 0

   if {$is_discrete || $is_sodimm} {
      set cs_width  $num_of_physical_ranks
      set cke_width $num_of_physical_ranks
      set odt_width $num_of_physical_ranks
   } else {
      set cs_width  [expr {$num_of_dimms * $cs_per_dimm}]
      set cke_width [expr {$ranks_per_dimm >= 2 ? 2 * $num_of_dimms : $num_of_dimms}]
      
      if {$is_lrdimm && [get_family_trait FAMILY_TRAIT_DDR4_LRDIMM_PINOUT_BUG]} {
         set odt_width $num_of_dimms
      } else {
         set odt_width [expr {$ranks_per_dimm >= 2 ? 2 * $num_of_dimms : $num_of_dimms}]
      }
   }
   set_parameter_value "${m_param_prefix}_CS_WIDTH"  $cs_width
   set_parameter_value "${m_param_prefix}_CKE_WIDTH" $cke_width
   set_parameter_value "${m_param_prefix}_ODT_WIDTH" $odt_width

   if { [lsearch -exact [get_feature_support_level FEATURE_BURST_LENGTH PROTOCOL_DDR4] $bl_enum] == -1 } {
      post_ipgen_e_msg MSG_DDRX_BURST_LENGTH_NOT_SUPPORTED [list [enum_data $bl_enum UI_NAME]]
   }

   set addr_mirror_bitvec 0
   if {$addr_mirror} {
      for {set i 0} {$i < $num_of_logical_ranks} {incr i} {
         if {[expr {$i % 2}] == 1} {
            set addr_mirror_bitvec [expr {$addr_mirror_bitvec | (1 << $i)}]
         }
      }
   }
   set_parameter_value "${m_param_prefix}_ADDRESS_MIRROR_BITVEC" $addr_mirror_bitvec

   if {$write_dbi && $dm_en} {
      post_ipgen_e_msg MSG_DDR4_WRITE_DBI_AND_DM_ARE_INCOMPATIBLE
   }

   if {$crc_en && !$alert_par_en} {
      post_ipgen_e_msg MSG_DDR4_CRC_REQUIRES_ALERT_N_PIN
   }

   if {$ac_parity_latency != "DDR4_AC_PARITY_LATENCY_DISABLE" && !$alert_par_en} {
      post_ipgen_e_msg MSG_DDR4_AC_PARITY_REQUIRES_ALERT_N_PIN
   }
   if {!$alert_par_en} {
      post_ipgen_w_msg MSG_DDR4_NO_ALERT_N_PIN_FOR_AC_DESKEW
   }

   if { $vrefdq_training_range == 0 && ($vrefdq_training_value < 60.0 || $vrefdq_training_value > 92.5) ||
        $vrefdq_training_range == 1 && ($vrefdq_training_value < 45   || $vrefdq_training_value > 77.5) } {
      post_ipgen_e_msg MSG_DDR4_VREFDQ_TRAINING_VALUE_OUT_OF_RANGE
   }

   if {$mem_wtcl > $mem_tcl} {
      post_ipgen_e_msg MSG_DDR4_WTCL_GT_TCL
   }

   if {$odt_width > 1} {
      if {[expr {($mem_tcl - $mem_wtcl) + ($write_preamble - $read_preamble)}] < 0} {
         post_ipgen_e_msg MSG_DDR4_IMPOSSIBLE_READ_ODT_TIMING
      }
   }
   
   set db_mdq_rtt [expr {$spd_145_val & 7}]
   set db_mdq_drv [expr {($spd_145_val >> 4) & 7}]
   if {[enum_find_by_field DDR4_SPD_145_RTT SETTING $db_mdq_rtt] == "" ||
       [enum_find_by_field DDR4_SPD_145_DRV_STR SETTING $db_mdq_drv] == ""} {
      post_ipgen_e_msg MSG_DDR4_INVALID_SPD [list 145]
   }
   
   set shift [expr {($mem_data_rate <= 1866) ? 0 : \
                    ($mem_data_rate <= 2400) ? 2 : \
                                               4}]
   set mem_drv_str [expr {($spd_148_val >> $shift) & 3}]
   if {[enum_find_by_field DDR4_DRV_STR MRS $mem_drv_str] == ""} {
      post_ipgen_e_msg MSG_DDR4_INVALID_SPD [list 148]
   }
   
   set dram_rtt_nom [expr {$spd_149_val & 7}]
   set dram_rtt_wr  [expr {($spd_149_val >> 3) & 7}]
   if {[enum_find_by_field DDR4_RTT_NOM MRS $dram_rtt_nom] == "" ||
       [enum_find_by_field DDR4_RTT_WR MRS $dram_rtt_wr] == ""} {
      post_ipgen_e_msg MSG_DDR4_INVALID_SPD [list 149]
   }
   
   set dram_rtt_park_01 [expr {$spd_152_val & 3}]
   set dram_rtt_park_23 [expr {($spd_152_val >> 3) & 3}]
   if {[enum_find_by_field DDR4_RTT_PARK MRS $dram_rtt_park_01] == "" ||
       [enum_find_by_field DDR4_RTT_PARK MRS $dram_rtt_park_23] == ""} {
      post_ipgen_e_msg MSG_DDR4_INVALID_SPD [list 152]
   }
   
   set support_sim [get_feature_support_level FEATURE_RTL_SIM PROTOCOL_DDR4 RATE_INVALID]
   set_parameter_value "MEM_HAS_SIM_SUPPORT" $support_sim
}

proc ::altera_emif::ip_top::mem::ddr4::_derive_odt_parameters {} {



   variable m_param_prefix

   set format_enum            [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set is_lrdimm              [enum_same $format_enum MEM_FORMAT_LRDIMM]
   set num_of_dimms           [get_parameter_value "${m_param_prefix}_NUM_OF_DIMMS"]
   set num_of_logical_ranks   [get_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"]
   set ping_pong_en           [get_parameter_value "PHY_PING_PONG_EN"]

   set target_name [list]
   if {$is_lrdimm} {
      set park_odt_enum    [get_parameter_value "${m_param_prefix}_DB_RTT_PARK_ENUM"]
      set dynamic_odt_enum [get_parameter_value "${m_param_prefix}_DB_RTT_WR_ENUM"]
      set nominal_odt_enum [get_parameter_value "${m_param_prefix}_DB_RTT_NOM_ENUM"]
      set drive_odt_enum   [get_parameter_value "${m_param_prefix}_DB_DQ_DRV_ENUM"]
      
      set odt_width        $num_of_dimms
      
      set num_odt_targets $num_of_dimms
      for {set target 0} {$target < 4} {incr target} {
         if {$target < $num_of_dimms} {
            lappend target_name "DIMM ${target}"
         } else {
            lappend target_name "-"
         }
      }
   } else {
      set park_odt_enum    [get_parameter_value "${m_param_prefix}_RTT_PARK"]
      set dynamic_odt_enum [get_parameter_value "${m_param_prefix}_RTT_WR_ENUM"]
      set nominal_odt_enum [get_parameter_value "${m_param_prefix}_RTT_NOM_ENUM"]
      set drive_odt_enum   [get_parameter_value "${m_param_prefix}_DRV_STR_ENUM"]
      set odt_width        [get_parameter_value "${m_param_prefix}_ODT_WIDTH"]
      
      set num_odt_targets $num_of_logical_ranks
      for {set target 0} {$target < 4} {incr target} {
         if {$target < $num_of_logical_ranks} {
            lappend target_name "Rank ${target}"
         } else {
            lappend target_name "-"
         }
      }
   }

   if { (!(    ($num_odt_targets == 1 && $odt_width == 1) \
            || ($num_odt_targets == 2 && $odt_width == 2) \
            || ($num_odt_targets == 4 && ($odt_width == 2 || $odt_width == 4))))} {
      set odt_tbl "4x4"
   } else {
      set odt_tbl "${num_odt_targets}x${odt_width}"
   }

   ::altera_emif::util::hwtcl_utils::update_gui_tables_visibility "${m_param_prefix}_odt" FALSE

   set use_default_odt [expr {$is_lrdimm || [get_parameter_value "${m_param_prefix}_USE_DEFAULT_ODT"]}]
   if {!$use_default_odt} {
      ::altera_emif::util::hwtcl_utils::update_gui_texts_visibility "${m_param_prefix}_odt" TRUE
      ::altera_emif::util::hwtcl_utils::update_gui_tables_visibility "${m_param_prefix}_odt_${odt_tbl}" TRUE
   } else {
      ::altera_emif::util::hwtcl_utils::update_gui_texts_visibility "${m_param_prefix}_odt" FALSE
   }

   set_parameter_value "${m_param_prefix}_R_DERIVED_ODTN" $target_name
   set_parameter_value "${m_param_prefix}_W_DERIVED_ODTN" $target_name
   set park_odt_name    [enum_data $park_odt_enum UI_NAME]
   set dynamic_odt_name [enum_data $dynamic_odt_enum UI_NAME]
   set nominal_odt_name [enum_data $nominal_odt_enum UI_NAME]
   set drive_odt_name   [enum_data $drive_odt_enum UI_NAME]
   set use_dynamic_odt  [expr { ($dynamic_odt_enum != "DDR4_RTT_WR_ODT_DISABLED"  && $dynamic_odt_enum != "DDR4_DB_RTT_WR_ODT_DISABLED")  ? 1 : 0}]
   set use_park_odt     [expr { ($park_odt_enum != "DDR4_RTT_PARK_ODT_DISABLED"   && $park_odt_enum != "DDR4_DB_RTT_PARK_ODT_DISABLED")   ? 1 : 0}]
   set use_nom_odt      [expr { ($nominal_odt_enum != "DDR4_RTT_NOM_ODT_DISABLED" && $nominal_odt_enum != "DDR4_DB_RTT_NOM_ODT_DISABLED") ? 1 : 0}]
   set seq_odt_lo       "00000000000000000000000000000000"
   set seq_odt_hi       "00000000000000000000000000000000"
   set ctrl_odt_wchip   "0000000000000000"
   set ctrl_odt_rchip   "0000000000000000"
   set ctrl_odt_wrank   "0000000000000000"
   set ctrl_odt_rrank   "0000000000000000"

   for {set odt_pin 0} {$odt_pin < 4} {incr odt_pin} {
      if {$odt_pin >= $odt_width} {
         set_parameter_value "${m_param_prefix}_R_DERIVED_ODT${odt_pin}" [list "-" "-" "-" "-"]
         set_parameter_value "${m_param_prefix}_W_DERIVED_ODT${odt_pin}" [list "-" "-" "-" "-"]
      } else {

         set r_target_lst [list]
         set w_target_lst [list]

         if {$use_default_odt} {
            if {$is_lrdimm} {
               set rd_odt [enum_data "DDR4_LRDIMM_DEFAULT_ODT_RODT" VALUE]
               set wr_odt [enum_data "DDR4_LRDIMM_DEFAULT_ODT_WODT" VALUE]
            } else {
               set odt_tbl_ucase [string toupper $odt_tbl]
               set rd_odt [enum_data "DDR4_DEFAULT_RODT_${odt_tbl_ucase}_ODT${odt_pin}" VALUE]
               set wr_odt [enum_data "DDR4_DEFAULT_WODT_${odt_tbl_ucase}_ODT${odt_pin}" VALUE]
            }
         } else {
            set rd_odt [get_parameter_value "${m_param_prefix}_R_ODT${odt_pin}_${odt_tbl}"]
            set wr_odt [get_parameter_value "${m_param_prefix}_W_ODT${odt_pin}_${odt_tbl}"]
         }

         for {set target 0} {$target < 4} {incr target} {
            if {$target >= $num_odt_targets} {
               lappend r_target_lst "-"
               lappend w_target_lst "-"
            } else {
               set rd_odt_val [lindex $rd_odt $target]
               set wr_odt_val [lindex $wr_odt $target]

               set intersect  0
               set rd_odt_setting ""
               set wr_odt_setting ""

               if {$num_odt_targets != $odt_width} {
                  if {$odt_pin == 0 && $target == 0} {
                     set intersect 1
                  } elseif {$odt_pin == 1 && $target == 3} {
                     set intersect 1
                  }
               } elseif {$target == $odt_pin} {
                  set intersect 1
               }

               set target_cs $target

               if {$intersect} {
                  set rd_odt_setting "(Drive) $drive_odt_name"
               } else {
                  switch $rd_odt_val {
                     "on" {
                        if { !$use_nom_odt } {
                           set rd_odt_setting "(Park) $park_odt_name"
                        } else {
                           set rd_odt_setting "(Nominal) $nominal_odt_name"
                        }
                        set pos [expr {$target_cs * 4 + $odt_pin}]
                        set ctrl_odt_rchip [string replace $ctrl_odt_rchip end-$pos end-$pos "1"]
                        set pos [expr {$target * 4 + $odt_pin}]
                        set ctrl_odt_rrank [string replace $ctrl_odt_rrank end-$pos end-$pos "1"]

                        if {$ping_pong_en} {
                           set pos [expr {($target_cs + 2) * 4 + ($odt_pin + 2)}]
                           set ctrl_odt_rchip [string replace $ctrl_odt_rchip end-$pos end-$pos "1"]
                           set pos [expr {($target + 2) * 4 + ($odt_pin + 2)}]
                           set ctrl_odt_rrank [string replace $ctrl_odt_rrank end-$pos end-$pos "1"]
                        }
                     }
                     "off" {
                        if {$use_park_odt} {
                           set rd_odt_setting "(Park) $park_odt_name"
                        } else {
                           set rd_odt_setting [enum_data DDR4_RTT_NOM_ODT_DISABLED UI_NAME]
                        }
                     }
                  }
               }

               if {$intersect && $use_dynamic_odt } {
                  set wr_odt_setting "(Dynamic) $dynamic_odt_name"
               } else {
                  switch $wr_odt_val {
                     "on" {
                        set wr_odt_setting "(Nominal) $nominal_odt_name"
                        set pos [expr {$target_cs * 4 + $odt_pin}]
                        set ctrl_odt_wchip [string replace $ctrl_odt_wchip end-$pos end-$pos "1"]
                        set pos [expr {$target * 4 + $odt_pin}]
                        set ctrl_odt_wrank [string replace $ctrl_odt_wrank end-$pos end-$pos "1"]

                        if {$ping_pong_en} {
                           set pos [expr {($target_cs + 2) * 4 + ($odt_pin + 2)}]
                           set ctrl_odt_wchip [string replace $ctrl_odt_wchip end-$pos end-$pos "1"]
                           set pos [expr {($target + 2) * 4 + ($odt_pin + 2)}]
                           set ctrl_odt_wrank [string replace $ctrl_odt_wrank end-$pos end-$pos "1"]
                        }
                     }
                     "off" {
                        if {$use_park_odt} {
                           set wr_odt_setting "(Park) $park_odt_name"
                        } else {
                           set wr_odt_setting [enum_data DDR4_RTT_NOM_ODT_DISABLED UI_NAME]
                        }
                     }
                  }
               }

               lappend r_target_lst $rd_odt_setting
               lappend w_target_lst $wr_odt_setting

               set seq_odt_enum [enum_data SEQ_ODT_MODE_ALWAYS_LOW VALUE]
               switch "${rd_odt_val}${wr_odt_val}" {
                  "offoff" { set seq_odt_enum [enum_data SEQ_ODT_MODE_ALWAYS_LOW         VALUE] }
                  "offon"  { set seq_odt_enum [enum_data SEQ_ODT_MODE_HIGH_ON_WRITE      VALUE] }
                  "onoff"  { set seq_odt_enum [enum_data SEQ_ODT_MODE_HIGH_ON_READ       VALUE] }
                  "onon"   { set seq_odt_enum [enum_data SEQ_ODT_MODE_HIGH_ON_READ_WRITE VALUE] }
               }

               if { $target >= 2 } {
                  set spos [expr {16*($target-2) + 4*$odt_pin + 3}]
                  set epos [expr {16*($target-2) + 4*$odt_pin + 0}]
                  set seq_odt_hi [string replace $seq_odt_hi end-$spos end-$epos $seq_odt_enum]

                  emif_assert {!$ping_pong_en}
               } else {
                  set spos [expr {16*$target + 4*$odt_pin + 3}]
                  set epos [expr {16*$target + 4*$odt_pin + 0}]
                  set seq_odt_lo [string replace $seq_odt_lo end-$spos end-$epos $seq_odt_enum]

                  if {$ping_pong_en} {
                     set spos [expr {16*$target + 4*($odt_pin + $num_odt_targets) + 3}]
                     set epos [expr {16*$target + 4*($odt_pin + $num_odt_targets) + 0}]
                     set seq_odt_lo [string replace $seq_odt_lo end-$spos end-$epos $seq_odt_enum]
                  }
               }
            }
         }
         set_parameter_value "${m_param_prefix}_R_DERIVED_ODT${odt_pin}" $r_target_lst
         set_parameter_value "${m_param_prefix}_W_DERIVED_ODT${odt_pin}" $w_target_lst
      }
   }

   set_parameter_value "${m_param_prefix}_SEQ_ODT_TABLE_LO"        [bin2num $seq_odt_lo]
   set_parameter_value "${m_param_prefix}_SEQ_ODT_TABLE_HI"        [bin2num $seq_odt_hi]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_READ_ODT_CHIP"  [bin2num $ctrl_odt_rchip]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_WRITE_ODT_CHIP" [bin2num $ctrl_odt_wchip]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_READ_ODT_RANK"  [bin2num $ctrl_odt_rrank]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_WRITE_ODT_RANK" [bin2num $ctrl_odt_wrank]
   

   return 1
}

proc ::altera_emif::ip_top::mem::ddr4::_validate_memory_timing_parameters {} {

   variable m_param_prefix

   set ok 1

   set mem_clk_freq       [get_parameter_value PHY_DDR4_MEM_CLK_FREQ_MHZ]
   set io_voltage         [get_parameter_value PHY_DDR4_IO_VOLTAGE]
   set tis_ac_mv          [get_parameter_value "${m_param_prefix}_TIS_AC_MV"]
   set tih_dc_mv          [get_parameter_value "${m_param_prefix}_TIH_DC_MV"]
   set speedbin_enum      [get_parameter_value "${m_param_prefix}_SPEEDBIN_ENUM"]
   set speedbin_ui_name   [enum_data $speedbin_enum UI_NAME]
   set speedbin_value     [enum_data $speedbin_enum VALUE]
   set mem_fmax           [enum_data $speedbin_enum FMAX_MHZ]
   set mem_fmin           [enum_data $speedbin_enum FMIN_MHZ]
   set allowed_voltages   [enum_data $speedbin_enum ALLOWED_VOLTAGES]

   if {$io_voltage == 1.2} {
      set ddr4_acdc_enum        "DDR4_ACDC_DDR4_${speedbin_value}"
      set protocol_display_name [enum_data DDR4_VOLTAGE_DDR4 UI_NAME]
   } else {
      emif_ie "Unknown voltage $io_voltage for DDR4"
   }
   set full_speedbin_name "${protocol_display_name}${speedbin_ui_name}"

   if {$ok} {
      if {[lsearch -exact -real $allowed_voltages $io_voltage] == -1} {
         emif_ie "Memory device speed bin $full_speedbin_name is not supported. Specify a lower speed bin or an I/O standard with higher voltage."
      }
   }

   if {$ok} {
      if {$mem_clk_freq < $mem_fmin || $mem_clk_freq > $mem_fmax} {
         post_ipgen_e_msg MSG_DDRX_FREQ_OUT_OF_RANGE [list $mem_fmin $mem_fmax $full_speedbin_name]
         set ok 0
      }
   }

   if {$ok} {
      set allowed_tis_ac_mv [enum_data $ddr4_acdc_enum ALLOWED_TIS_AC]
      set allowed_tih_dc_mv [enum_data $ddr4_acdc_enum ALLOWED_TIH_DC]

      foreach user_val [list $tis_ac_mv $tih_dc_mv] \
              allowed_vals [list $allowed_tis_ac_mv $allowed_tih_dc_mv] \
              param_name [list "${m_param_prefix}_TIS_AC_MV" "${m_param_prefix}_TIH_DC_MV"] {

         if {[lsearch -exact -integer $allowed_vals $user_val] == -1} {
            set param_display_name [get_parameter_property $param_name DISPLAY_NAME]
            post_ipgen_e_msg MSG_DDRX_AC_DC_LEVEL_NOT_SUPPORTED [list $full_speedbin_name $param_display_name [join $allowed_vals " or "]]
            set ok 0
         }
      }
   }

   return $ok
}

proc ::altera_emif::ip_top::mem::ddr4::_derive_memory_timing_parameters {} {

   variable m_param_prefix

   set mem_clk_freq       [get_parameter_value "PHY_DDR4_MEM_CLK_FREQ_MHZ" ]
   set mem_tras_ns        [get_parameter_value "${m_param_prefix}_TRAS_NS"]
   set mem_trcd_ns        [get_parameter_value "${m_param_prefix}_TRCD_NS"]
   set mem_trp_ns         [get_parameter_value "${m_param_prefix}_TRP_NS"]
   set mem_trfc_ns        [get_parameter_value "${m_param_prefix}_TRFC_NS"]
   set mem_tfaw_ns        [get_parameter_value "${m_param_prefix}_TFAW_NS"]
   set mem_trefi_ns       [expr {[get_parameter_value "${m_param_prefix}_TREFI_US"] * 1000}]
   set mem_tinit_ns       [expr {[get_parameter_value "${m_param_prefix}_TINIT_US"] * 1000}]
   set mem_clk_ns         [expr {(1000000.0 / $mem_clk_freq) / 1000.0}]

   set_parameter_value "${m_param_prefix}_TINIT_CK"       [::altera_emif::ip_top::util::ns_to_tck $mem_tinit_ns $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRAS_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_tras_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRCD_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_trcd_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRP_CYC"        [::altera_emif::ip_top::util::ns_to_tck $mem_trp_ns   $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRFC_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_trfc_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TFAW_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_tfaw_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TREFI_CYC"      [::altera_emif::ip_top::util::ns_to_tck $mem_trefi_ns $mem_clk_ns]

   return 1
}

proc ::altera_emif::ip_top::mem::ddr4::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set atcl_enum [enum_data [get_parameter_value "${m_param_prefix}_ATCL_ENUM"] VALUE]
   set atcl_cyc  [expr {($atcl_enum == 0) ? 0 : ([get_parameter_value "${m_param_prefix}_TCL"] - $atcl_enum)}]
   set tpl_cyc   [enum_data [get_parameter_value "${m_param_prefix}_AC_PARITY_LATENCY"] VALUE]

   set format_enum [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_rdimm    [expr {$format_enum == "MEM_FORMAT_RDIMM"}]
   set is_lrdimm   [expr {$format_enum == "MEM_FORMAT_LRDIMM"}]

   if {$is_rdimm || $is_lrdimm} {
      
      set rcd_tpdm_cyc 1
      set rcd_cmd_latency [expr {$rcd_tpdm_cyc + [get_parameter_value ${m_param_prefix}_RCD_COMMAND_LATENCY]}]
   } else {
      set rcd_cmd_latency 0
   }
   
   set ddr4_bl_enum [get_parameter_value "${m_param_prefix}_BL_ENUM"]
   if {$ddr4_bl_enum == "DDR4_BL_BL8"} {
      set ddr4_bl_val 8
   } elseif {$ddr4_bl_enum == "DDR4_BL_BC4"} {
      set ddr4_bl_val 4
   } else {
      set ddr4_bl_val -1
   }
   
   set_parameter_value MEM_FORMAT_ENUM             [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set_parameter_value MEM_READ_LATENCY            [expr {[get_parameter_value "${m_param_prefix}_TCL"] + $atcl_cyc + $tpl_cyc + $rcd_cmd_latency}]
   set_parameter_value MEM_WRITE_LATENCY           [expr {[get_parameter_value "${m_param_prefix}_WTCL"] + $atcl_cyc + $tpl_cyc + $rcd_cmd_latency}]
   set_parameter_value MEM_DATA_MASK_EN            [get_parameter_value "${m_param_prefix}_DM_EN"]
   set_parameter_value MEM_NUM_OF_LOGICAL_RANKS    [get_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"]
   set_parameter_value MEM_BURST_LENGTH            $ddr4_bl_val

   return 1
}

proc ::altera_emif::ip_top::mem::ddr4::_derive_mode_register_parameters {} {

   variable m_param_prefix

   set format_enum                [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_discrete                [expr {$format_enum == "MEM_FORMAT_DISCRETE"}]
   set is_udimm                   [expr {$format_enum == "MEM_FORMAT_UDIMM"}]
   set is_rdimm                   [expr {$format_enum == "MEM_FORMAT_RDIMM"}]
   set is_lrdimm                  [expr {$format_enum == "MEM_FORMAT_LRDIMM"}]
   set mem_clk_freq               [get_parameter_value PHY_DDR4_MEM_CLK_FREQ_MHZ]
   set mem_data_rate              [expr {$mem_clk_freq * 2}]
   set io_voltage                 [get_parameter_value PHY_DDR4_IO_VOLTAGE]
   set speedbin_enum              [get_parameter_value "${m_param_prefix}_SPEEDBIN_ENUM"]
   set mem_bl                     [get_parameter_value "${m_param_prefix}_BL_ENUM"]
   set mem_bt                     [get_parameter_value "${m_param_prefix}_BT_ENUM"]
   set mem_tcl                    [get_parameter_value "${m_param_prefix}_TCL"]
   set mem_dll_en                 [get_parameter_value "${m_param_prefix}_DLL_EN"]
   set mem_atcl                   [get_parameter_value "${m_param_prefix}_ATCL_ENUM"]
   set mem_wtcl                   [get_parameter_value "${m_param_prefix}_WTCL"]
   set mem_asr                    [get_parameter_value "${m_param_prefix}_ASR_ENUM"]
   set mem_twr_ns                 [get_parameter_value "${m_param_prefix}_TWR_NS"]
   set mem_tccd_l_cyc             [get_parameter_value "${m_param_prefix}_TCCD_L_CYC"]
   set mem_clk_freq_mhz           [get_parameter_value "PHY_DDR4_MEM_CLK_FREQ_MHZ"]
   set write_crc                  [get_parameter_value "${m_param_prefix}_WRITE_CRC"]
   set mem_geardown               [get_parameter_value "${m_param_prefix}_GEARDOWN"]
   set per_dram_addr              [get_parameter_value "${m_param_prefix}_PER_DRAM_ADDR"]
   set temp_sensor_readout        [get_parameter_value "${m_param_prefix}_TEMP_SENSOR_READOUT"]
   set fine_granularity_refresh   [get_parameter_value "${m_param_prefix}_FINE_GRANULARITY_REFRESH"]
   set mpr_read_format            [get_parameter_value "${m_param_prefix}_MPR_READ_FORMAT"]
   set max_power_down             [get_parameter_value "${m_param_prefix}_MAX_POWERDOWN"]
   set temp_controlled_rfsh_range [get_parameter_value "${m_param_prefix}_TEMP_CONTROLLED_RFSH_RANGE"]
   set temp_controlled_rfsh_ena   [get_parameter_value "${m_param_prefix}_TEMP_CONTROLLED_RFSH_ENA"]
   set internal_vrefdq_monitor    [get_parameter_value "${m_param_prefix}_INTERNAL_VREFDQ_MONITOR"]
   set cal_mode                   [get_parameter_value "${m_param_prefix}_CAL_MODE"]
   set self_rfsh_abort            [get_parameter_value "${m_param_prefix}_SELF_RFSH_ABORT"]
   set read_preamble_traning_mode [get_parameter_value "${m_param_prefix}_READ_PREAMBLE_TRAINING"]
   set read_preamble              [get_parameter_value "${m_param_prefix}_READ_PREAMBLE"]
   set write_preamble             [get_parameter_value "${m_param_prefix}_WRITE_PREAMBLE"]
   set ac_parity_latency          [get_parameter_value "${m_param_prefix}_AC_PARITY_LATENCY"]
   set odt_in_powerdown           [get_parameter_value "${m_param_prefix}_ODT_IN_POWERDOWN"]
   set dm_en                      [get_parameter_value "${m_param_prefix}_DM_EN"]
   set ac_persistent_error        [get_parameter_value "${m_param_prefix}_AC_PERSISTENT_ERROR"]
   set write_dbi                  [get_parameter_value "${m_param_prefix}_WRITE_DBI"]
   set read_dbi                   [get_parameter_value "${m_param_prefix}_READ_DBI"]
   set vrefdq_training_value      [get_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_VALUE"]
   set vrefdq_training_range      [get_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE"]
   set num_physical_ranks         [get_parameter_value "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS"]

   if {$read_preamble == 1} {
      post_ipgen_w_msg MSG_DDR4_READ_PREAMBLE_1CK_NOT_RECOMMENDED
   }

   if {$speedbin_enum == "DDR4_SPEEDBIN_1600"} {
      set write_cmd_latency 4
      set write_cmd_latency_mr 0
   } elseif {$speedbin_enum == "DDR4_SPEEDBIN_1866" || $speedbin_enum == "DDR4_SPEEDBIN_2133" || $speedbin_enum == "DDR4_SPEEDBIN_2400"} {
      set write_cmd_latency 5
      set write_cmd_latency_mr 1
   } else {
      set write_cmd_latency 6
      set write_cmd_latency_mr 2
   }
   set_parameter_value "${m_param_prefix}_WRITE_CMD_LATENCY" $write_cmd_latency

   set twr_cyc     [expr {int(ceil($mem_twr_ns / (1000.0 / $mem_clk_freq_mhz)))}]
   set twr_cyc_min [enum_data DDR4_TWR_CYC_RANGE_MIN VALUE]
   set twr_cyc_max [enum_data DDR4_TWR_CYC_RANGE_MAX VALUE]

   if { $twr_cyc < $twr_cyc_min } {
      set twr_cyc $twr_cyc_min
   } elseif { $twr_cyc > $twr_cyc_max } {
      set twr_cyc $twr_cyc_max
   }

   set mem_wr_mr 0
   if { $twr_cyc <= 10 } {
      set twr_cyc 10
      set mem_wr_mr 0
   } elseif { $twr_cyc <= 12 } {
      set twr_cyc 12
      set mem_wr_mr 1
   } elseif { $twr_cyc <= 14 } {
      set twr_cyc 14
      set mem_wr_mr 2
   } elseif { $twr_cyc <= 16 } {
      set twr_cyc 16
      set mem_wr_mr 3
   } elseif { $twr_cyc <= 18 } {
      set twr_cyc 18
      set mem_wr_mr 4
   } elseif { $twr_cyc <= 20 } {
      set twr_cyc 20
      set mem_wr_mr 5
   } elseif { $twr_cyc <= 24 } {
      set twr_cyc 24
      set mem_wr_mr 6
   } else {
      emif_ie "Unsupported DDR4 write recovery time $twr_cyc"
   }
   set_parameter_value "${m_param_prefix}_TWR_CYC" $twr_cyc
   set_parameter_value "${m_param_prefix}_TRTP_CYC" [expr {$twr_cyc / 2}]

   set mem_tcl_mr 0
   if { $mem_tcl <= 16 } {
      set mem_tcl_mr [expr {$mem_tcl - 9}]
   } elseif { $mem_tcl == 17 } {
      set mem_tcl_mr 13
   } elseif { $mem_tcl == 18 } {
      set mem_tcl_mr 8
   } elseif { $mem_tcl == 19 } {
      set mem_tcl_mr 14
   } elseif { $mem_tcl == 20 } {
      set mem_tcl_mr 9
   } elseif { $mem_tcl == 21 } {
      set mem_tcl_mr 15
   } elseif { $mem_tcl == 22 } {
      set mem_tcl_mr 10
   } elseif { $mem_tcl == 24 } {
      set mem_tcl_mr 11
   } else {
      emif_ie "Unsupported DDR4 cas read latency $mem_tcl"
   }

   set mem_wtcl_mr 0
   if { $mem_wtcl <= 12 } {
      set mem_wtcl_mr [expr {$mem_wtcl - 9}]
   } else {
      set mem_wtcl_mr [expr {($mem_wtcl / 2) - 3}]
   }

   set mem_tccd_l_mr 0
   if {$mem_tccd_l_cyc == 4} {
      set mem_tccd_l_mr 0
   } elseif {$mem_tccd_l_cyc == 5} {
      set mem_tccd_l_mr 1
   } elseif {$mem_tccd_l_cyc == 6} {
      set mem_tccd_l_mr 2
   } elseif {$mem_tccd_l_cyc == 7} {
      set mem_tccd_l_mr 3
   } elseif {$mem_tccd_l_cyc == 8} {
      set mem_tccd_l_mr 4
   }

   
   if {$is_lrdimm} {
      set odt_less_backside_odt_scheme   [get_parameter_value MEM_DDR4_LRDIMM_ODT_LESS_BS]
      set odt_less_backside_rtt_park_ohm [get_parameter_value MEM_DDR4_LRDIMM_ODT_LESS_BS_PARK_OHM]
      set ranks_per_dimm                 [get_parameter_value "${m_param_prefix}_RANKS_PER_DIMM"]
   
      set tmp [get_parameter_value "${m_param_prefix}_SPD_148_DRAM_DRV"]
      set shift [expr {($mem_data_rate <= 1866) ? 0 : \
                       ($mem_data_rate <= 2400) ? 2 : \
                                                  4}]
      set mem_drv_str_mrs [expr {($tmp >> $shift) & 3}]
      
      set spd_149_val [get_parameter_value "${m_param_prefix}_SPD_149_DRAM_RTT_WR_NOM"]
      
      if {$odt_less_backside_odt_scheme} {
         set mem_rtt_nom_mrs   0
         set mem_rtt_wr_mrs    [expr {($spd_149_val >> 3) & 7}]
         
         set mem_rtt_wr_enum [enum_find_by_field DDR4_RTT_WR MRS $mem_rtt_wr_mrs]
         set mem_rtt_wr_ohm  [enum_data $mem_rtt_wr_enum OHM]
         
         set mem_rtt_park_enum [enum_find_by_field DDR4_RTT_PARK OHM $odt_less_backside_rtt_park_ohm]
         set mem_rtt_park_mrs  [enum_data $mem_rtt_park_enum MRS]
         set mem_rtt_park_ohm  [enum_data $mem_rtt_park_enum OHM]
         set mem_rodt_loads    [lrepeat [expr {$ranks_per_dimm - 1}] $mem_rtt_park_ohm]
         
         set spd_145_val [get_parameter_value "${m_param_prefix}_SPD_145_DB_MDQ_DRV"]
         set db_ron_mrs  [expr {$spd_145_val >> 4}]
         set db_ron_enum [enum_find_by_field DDR4_SPD_145_DRV_STR SETTING $db_ron_mrs]
         set db_ron_ohm  [enum_data $db_ron_enum OHM]
      
         set val_lst [_get_ideal_vref $io_voltage $db_ron_ohm $mem_rtt_wr_ohm $mem_rodt_loads]
         set vrefdq_training_range_mrs [lindex $val_lst 0]
         set vrefdq_training_value_mrs [lindex $val_lst 1]
         
      } else {
         set mem_rtt_nom_mrs   [expr {$spd_149_val & 7}]
         set mem_rtt_wr_mrs    [expr {($spd_149_val >> 3) & 7}]
      
         set spd_152_val       [get_parameter_value "${m_param_prefix}_SPD_152_DRAM_RTT_PARK"]
         set mem_rtt_park_mrs  [expr {$spd_152_val & 7}]
         
         set tmp 0
         for {set r 0} {$r < $ranks_per_dimm} {incr r} {
            incr tmp [get_parameter_value "${m_param_prefix}_SPD_14${r}_DRAM_VREFDQ_R${r}"]
         }
         set vrefdq_training_value_mrs [expr {int(ceil($tmp / $ranks_per_dimm)) & 63}]
         
         set vrefdq_training_range_mrs 1         
      }
   } else {
   
      set mem_drv_str_mrs   [enum_data [get_parameter_value "${m_param_prefix}_DRV_STR_ENUM"] MRS]
      set mem_rtt_nom_mrs   [enum_data [get_parameter_value "${m_param_prefix}_RTT_NOM_ENUM"] MRS]
      set mem_rtt_wr_mrs    [enum_data [get_parameter_value "${m_param_prefix}_RTT_WR_ENUM"] MRS]
      set mem_rtt_park_mrs  [enum_data [get_parameter_value "${m_param_prefix}_RTT_PARK"] MRS]
      
      set vrefdq_training_value_mrs 0
      set vrefdq_training_range_mrs [enum_data $vrefdq_training_range MRS]
      if { $vrefdq_training_range == "DDR4_VREFDQ_TRAINING_RANGE_0" } {
         set vrefdq_training_value_mrs [expr {int(($vrefdq_training_value - 60.0) / 0.65)}]
      } else {
         set vrefdq_training_value_mrs [expr {int(($vrefdq_training_value - 45.0) / 0.65)}]
      }      
   }

   set mr0 0
   set mr0 [set_bits $mr0 0 2   [enum_data $mem_bl MRS]]                              
   set mr0 [set_bits $mr0 2 1   [expr {$mem_tcl_mr & 1}]]                             
   set mr0 [set_bits $mr0 3 1   [enum_data $mem_bt MRS]]                              
   set mr0 [set_bits $mr0 4 3   [expr {$mem_tcl_mr >> 1}]]                            
   set mr0 [set_bits $mr0 7 1   0]                                                    
   set mr0 [set_bits $mr0 8 1   0]                                                    
   set mr0 [set_bits $mr0 9 3   $mem_wr_mr]                                           
   set mr0 [set_bits $mr0 12 4  0]                                                    
   set mr0 [set_bits $mr0 16 4  0]                                                    

   set_parameter_value "${m_param_prefix}_MR0"                $mr0

   set mr1 0
   set mr1 [set_bits $mr1 0 1   [expr {$mem_dll_en ? 1 : 0}]]                         
   set mr1 [set_bits $mr1 1 2   $mem_drv_str_mrs]                                     
   set mr1 [set_bits $mr1 3 2   [enum_data $mem_atcl MRS]]                            
   set mr1 [set_bits $mr1 5 2   0]                                                    
   set mr1 [set_bits $mr1 7 1   0]                                                    
   set mr1 [set_bits $mr1 8 3   $mem_rtt_nom_mrs]                                     
   set mr1 [set_bits $mr1 11 1  0]                                                    
   set mr1 [set_bits $mr1 12 1  0]                                                    
   set mr1 [set_bits $mr1 13 3  0]                                                    
   set mr1 [set_bits $mr1 16 4  1]                                                    

   set_parameter_value "${m_param_prefix}_MR1"      $mr1

   set mr2 0
   set mr2 [set_bits $mr2 3 3  $mem_wtcl_mr]                                           
   set mr2 [set_bits $mr2 6 2  [enum_data $mem_asr MRS]]                               
   set mr2 [set_bits $mr2 8 1  0]                                                      
   set mr2 [set_bits $mr2 9 3  $mem_rtt_wr_mrs]                                        
   set mr2 [set_bits $mr2 12 1 [expr {$write_crc ? 1 : 0}]]                            
   set mr2 [set_bits $mr2 13 3 0]                                                      
   set mr2 [set_bits $mr2 16 4 2]                                                      

   set_parameter_value "${m_param_prefix}_MR2"      $mr2

   set mr3 0
   set mr3 [set_bits $mr3 0 2 0]                                                      
   set mr3 [set_bits $mr3 2 1 0]                                                      
   set mr3 [set_bits $mr3 3 1 [enum_data $mem_geardown MRS]]                          
   set mr3 [set_bits $mr3 4 1 [expr {$per_dram_addr ? 1 : 0}]]                        
   set mr3 [set_bits $mr3 5 1 [expr {$temp_sensor_readout ? 1 : 0}]]                  
   set mr3 [set_bits $mr3 6 3 [enum_data $fine_granularity_refresh MRS]]              
   set mr3 [set_bits $mr3 9 2 $write_cmd_latency_mr]                                  
   set mr3 [set_bits $mr3 11 2 [enum_data $mpr_read_format MRS]]                      
   set mr3 [set_bits $mr3 13 3 0]                                                     
   set mr3 [set_bits $mr3 16 4 3]                                                     

   set_parameter_value "${m_param_prefix}_MR3"      $mr3

   set mr4 0
   set mr4 [set_bits $mr4 1 1 [expr {$max_power_down ? 1 : 0}]]                       
   set mr4 [set_bits $mr4 2 1 [enum_data $temp_controlled_rfsh_range MRS]]            
   set mr4 [set_bits $mr4 3 1 [expr {$temp_controlled_rfsh_ena ? 1 : 0}]]             
   set mr4 [set_bits $mr4 4 1 [expr {$internal_vrefdq_monitor ? 1 : 0}]]              
   set mr4 [set_bits $mr4 6 3 $cal_mode]                                              
   set mr4 [set_bits $mr4 9 1 [expr {$self_rfsh_abort ? 1 : 0}]]                      
   set mr4 [set_bits $mr4 10 1 [expr {$read_preamble_traning_mode ? 1 : 0}]]          
   set mr4 [set_bits $mr4 11 1 [expr {$read_preamble - 1}]]                           
   set mr4 [set_bits $mr4 12 1 [expr {$write_preamble - 1}]]                          
   set mr4 [set_bits $mr4 13 3 0]                                                     
   set mr4 [set_bits $mr4 16 4 4]                                                     

   set_parameter_value "${m_param_prefix}_MR4"      $mr4

   set mr5 0
   set mr5 [set_bits $mr5 0 3 [enum_data $ac_parity_latency MRS]]                     
   set mr5 [set_bits $mr5 5 1 [expr {$odt_in_powerdown ? 1 : 0}]]                     
   set mr5 [set_bits $mr5 6 3 $mem_rtt_park_mrs]                                      
   set mr5 [set_bits $mr5 9 1 [expr {$ac_persistent_error ? 1 : 0}]]                  
   set mr5 [set_bits $mr5 10 1 [expr {$dm_en ? 1 : 0}]]                               
   set mr5 [set_bits $mr5 11 1 [expr {$write_dbi ? 1 : 0}]]                           
   set mr5 [set_bits $mr5 12 1 [expr {$read_dbi ? 1 : 0}]]                            
   set mr5 [set_bits $mr5 13 3 0]                                                     
   set mr5 [set_bits $mr5 16 4 5]                                                     

   set_parameter_value "${m_param_prefix}_MR5"      $mr5

   set mr6 0
   set mr6 [set_bits $mr6 0 6 $vrefdq_training_value_mrs]                             
   set mr6 [set_bits $mr6 6 1 $vrefdq_training_range_mrs]                             
   set mr6 [set_bits $mr6 10 3 $mem_tccd_l_mr]                                        
   set mr6 [set_bits $mr6 13 3 0]                                                     
   set mr6 [set_bits $mr6 16 4 6]                                                     

   set_parameter_value "${m_param_prefix}_MR6"      $mr6
   
   if {$is_rdimm || $is_lrdimm} {
      set_parameter_value "${m_param_prefix}_RDIMM_CONFIG" [_derive_rcd_config_word]
   } else {
      set_parameter_value "${m_param_prefix}_RDIMM_CONFIG" ""
   }

   if {$is_lrdimm} {
      set_parameter_value "${m_param_prefix}_LRDIMM_EXTENDED_CONFIG" [_derive_db_config_word]
   } else {
      set_parameter_value "${m_param_prefix}_LRDIMM_EXTENDED_CONFIG" ""
   }
}

proc ::altera_emif::ip_top::mem::ddr4::_validate_and_derive_ttl_width_parameters {} {

   variable m_param_prefix

   set ping_pong_en              [get_parameter_value "PHY_DDR4_PING_PONG_EN"]
   set mult_fact                 [expr {$ping_pong_en ? 2 : 1}]

   set format_enum               [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_discrete               [expr {$format_enum == "MEM_FORMAT_DISCRETE"}]

   set ttl_dqs_width             [expr {[get_parameter_value "${m_param_prefix}_DQS_WIDTH"] * $mult_fact}]
   set ttl_dq_width              [expr {[get_parameter_value "${m_param_prefix}_DQ_WIDTH"] * $mult_fact}]
   set ttl_cs_width              [expr {[get_parameter_value "${m_param_prefix}_CS_WIDTH"] * $mult_fact}]
   set ttl_ck_width              [expr {[get_parameter_value "${m_param_prefix}_CK_WIDTH"] }]
   set ttl_cke_width             [expr {[get_parameter_value "${m_param_prefix}_CKE_WIDTH"] * $mult_fact}]
   set ttl_odt_width             [expr {[get_parameter_value "${m_param_prefix}_ODT_WIDTH"] * $mult_fact}]
   set ttl_bank_addr_width       [get_parameter_value "${m_param_prefix}_BANK_ADDR_WIDTH"]
   set ttl_bank_group_width      [get_parameter_value "${m_param_prefix}_BANK_GROUP_WIDTH"]
   set ttl_chip_id_width         [get_parameter_value "${m_param_prefix}_CHIP_ID_WIDTH"]
   set ttl_addr_width            [get_parameter_value "${m_param_prefix}_ADDR_WIDTH"]
   set ttl_rm_width              [get_parameter_value "${m_param_prefix}_RM_WIDTH"]
   set ttl_num_of_dimms          [expr {[get_parameter_value "${m_param_prefix}_NUM_OF_DIMMS"] * $mult_fact}]
   set ttl_num_of_physical_ranks [expr {[get_parameter_value "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS"] * $mult_fact}]
   set ttl_num_of_logical_ranks  [expr {[get_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"] * $mult_fact}]

   set_parameter_value "${m_param_prefix}_TTL_DQS_WIDTH"              $ttl_dqs_width
   set_parameter_value "${m_param_prefix}_TTL_DQ_WIDTH"               $ttl_dq_width
   set_parameter_value "${m_param_prefix}_TTL_CS_WIDTH"               $ttl_cs_width
   set_parameter_value "${m_param_prefix}_TTL_CK_WIDTH"               $ttl_ck_width
   set_parameter_value "${m_param_prefix}_TTL_CKE_WIDTH"              $ttl_cke_width
   set_parameter_value "${m_param_prefix}_TTL_ODT_WIDTH"              $ttl_odt_width
   set_parameter_value "${m_param_prefix}_TTL_BANK_ADDR_WIDTH"        $ttl_bank_addr_width
   set_parameter_value "${m_param_prefix}_TTL_BANK_GROUP_WIDTH"       $ttl_bank_group_width
   set_parameter_value "${m_param_prefix}_TTL_CHIP_ID_WIDTH"          $ttl_chip_id_width
   set_parameter_value "${m_param_prefix}_TTL_ADDR_WIDTH"             $ttl_addr_width
   set_parameter_value "${m_param_prefix}_TTL_RM_WIDTH"               $ttl_rm_width
   set_parameter_value "${m_param_prefix}_TTL_NUM_OF_DIMMS"           $ttl_num_of_dimms
   set_parameter_value "${m_param_prefix}_TTL_NUM_OF_PHYSICAL_RANKS"  $ttl_num_of_physical_ranks
   set_parameter_value "${m_param_prefix}_TTL_NUM_OF_LOGICAL_RANKS"   $ttl_num_of_logical_ranks

   set_parameter_value MEM_TTL_DATA_WIDTH           $ttl_dq_width
   set_parameter_value MEM_TTL_NUM_OF_READ_GROUPS   $ttl_dqs_width
   set_parameter_value MEM_TTL_NUM_OF_WRITE_GROUPS  $ttl_dqs_width

   if {$ttl_cs_width > 4} {
      post_ipgen_e_msg MSG_DDRX_MAX_CS_EXCEEDED [list 4 $ttl_cs_width]
   }
   if {$ttl_ck_width > 4} {
      post_ipgen_e_msg MSG_DDRX_MAX_CK_EXCEEDED [list 4 $ttl_ck_width]
   }
}

proc ::altera_emif::ip_top::mem::ddr4::_get_vrefout_default_range {} {
   variable m_param_prefix
   
   set format_enum [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_lrdimm   [expr {$format_enum == "MEM_FORMAT_LRDIMM"}]
   
   if {$is_lrdimm} {
      set num_loads [get_parameter_value "${m_param_prefix}_NUM_OF_DIMMS"]
   } else {
      set num_loads [get_parameter_value "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS"]
   }
   return [expr {$num_loads == 1 ? "DDR4_VREFDQ_TRAINING_RANGE_1" : "DDR4_VREFDQ_TRAINING_RANGE_0"}]
}

proc ::altera_emif::ip_top::mem::ddr4::_get_vrefout_default_value {vrefout_range} {
   variable m_param_prefix
   
   set io_voltage  [get_parameter_value PHY_DDR4_IO_VOLTAGE]
   set format_enum [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_lrdimm   [expr {$format_enum == "MEM_FORMAT_LRDIMM"}]

   if {$is_lrdimm} {
      set mem_rtt_wr     [get_parameter_value "${m_param_prefix}_DB_RTT_WR_ENUM"]
      set mem_rtt_nom    [get_parameter_value "${m_param_prefix}_DB_RTT_NOM_ENUM"]
      set mem_rtt_park   [get_parameter_value "${m_param_prefix}_DB_RTT_PARK_ENUM"]
      set rtt_wr_ohm     [enum_data $mem_rtt_wr OHM]
      set rtt_nom_ohm    [enum_data $mem_rtt_nom OHM]
      set rtt_park_ohm   [enum_data $mem_rtt_park OHM]
   } else {
      set mem_rtt_wr     [get_parameter_value "${m_param_prefix}_RTT_WR_ENUM"]
      set mem_rtt_nom    [get_parameter_value "${m_param_prefix}_RTT_NOM_ENUM"]
      set mem_rtt_park   [get_parameter_value "${m_param_prefix}_RTT_PARK"]
      set rtt_wr_ohm     [enum_data $mem_rtt_wr OHM]
      set rtt_nom_ohm    [enum_data $mem_rtt_nom OHM]
      set rtt_park_ohm   [enum_data $mem_rtt_park OHM]
   }
   
   if {$mem_rtt_wr != "DDR4_RTT_WR_ODT_DISABLED" && $mem_rtt_wr != "DDR4_DB_RTT_WR_ODT_DISABLED"} {
      set odt $rtt_wr_ohm
   } elseif {$mem_rtt_nom != "DDR4_RTT_NOM_ODT_DISABLED" && $mem_rtt_nom != "DDR4_DB_RTT_NOM_ODT_DISABLED"} {
      set odt $rtt_nom_ohm
   } else {
      set odt $rtt_park_ohm
   }
   
   set ron 34
   set val_lst [_get_ideal_vref $io_voltage $ron $odt [list]]
   return [lindex $val_lst 2]
}

proc ::altera_emif::ip_top::mem::ddr4::_get_ideal_vref {vcc ron rodt_target odt_loads} {
   set tmp 0
   foreach r [concat $rodt_target $odt_loads] {
      if {$r > 0} {
         set tmp [expr {$tmp + (1.0 / $r)}]
      }
   }
   if {$tmp == 0} {
      set rtop "High-Z"
      set vdc0 0
   } else {
      set rtop [expr {1.0 / $tmp}]
   
      if {$ron <= 0} {
         set ron 34
      }
      set vdc0 [expr {$vcc * $ron / ($ron + $rtop)}]
   }
   
   set vref [expr {($vcc + $vdc0) / 2.0}]
   
   set vref_pct_ideal [expr {int($vref * 1000.0 / $vcc) / 10.0}]
   
   set vref_pct [expr {($vref_pct_ideal > 92.5) ? 92.5 : $vref_pct_ideal}]
   set vref_pct [expr {($vref_pct < 45.0) ? 45.0 : $vref_pct}]
   
   set range_1_left  [expr {abs($vref_pct - 60.0)}]
   set range_1_right [expr {abs(92.5 - $vref_pct)}]
   set range_1_max   [expr {max($range_1_left, $range_1_right)}]
   
   set range_2_left  [expr {abs($vref_pct - 45.0)}]
   set range_2_right [expr {abs(77.5 - $vref_pct)}]
   set range_2_max   [expr {max($range_2_left, $range_2_right)}]

   if {$range_1_max < $range_2_max} {
      set vref_range_mrs 0
      set vref_val_mrs [expr {int(($vref_pct - 60.0) / 0.65)}]
   } else {
      set vref_range_mrs 1
      set vref_val_mrs [expr {int(($vref_pct - 45.0) / 0.65)}]
   }
   
   
   return [list $vref_range_mrs $vref_val_mrs $vref_pct]
}

proc ::altera_emif::ip_top::mem::ddr4::_trigger_non_default_vrefout {} {

   variable m_param_prefix

   set default_vref  [get_parameter_value "${m_param_prefix}_DEFAULT_VREFOUT"]
   set vrefout_range [_get_vrefout_default_range]
   set vrefout_value [_get_vrefout_default_value $vrefout_range]

   if {!$default_vref} {
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_VALUE" $vrefout_value
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE" $vrefout_range
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE_DISP" [enum_data $vrefout_range UI_NAME]
   }
}

proc ::altera_emif::ip_top::mem::ddr4::_update_vrefout_default {} {
   variable m_param_prefix

   set default_vref  [get_parameter_value "${m_param_prefix}_DEFAULT_VREFOUT"]

   if {$default_vref} {
      set vrefout_range [_get_vrefout_default_range]
      set vrefout_value [_get_vrefout_default_value $vrefout_range]
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_VALUE"      $vrefout_value
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE"      $vrefout_range
      set_parameter_value "${m_param_prefix}_VREFDQ_TRAINING_RANGE_DISP" [enum_data $vrefout_range UI_NAME]
   }
}

proc ::altera_emif::ip_top::mem::ddr4::_derive_rcd_config_word {} {
   variable m_param_prefix

   set format_enum         [get_parameter_value MEM_DDR4_FORMAT_ENUM]
   set is_rdimm            [expr {$format_enum == "MEM_FORMAT_RDIMM"}]
   set is_lrdimm           [expr {$format_enum == "MEM_FORMAT_LRDIMM"}]
   set ranks_per_dimm      [get_parameter_value "${m_param_prefix}_RANKS_PER_DIMM"]
   set mem_clk_freq        [get_parameter_value PHY_DDR4_MEM_CLK_FREQ_MHZ]
   set mem_data_rate       [expr {$mem_clk_freq * 2}]
   
   set retval ""
   
   if {$is_lrdimm} {
      set io_voltage                     [get_parameter_value PHY_DDR4_IO_VOLTAGE]
      set odt_less_backside_odt_scheme   [get_parameter_value MEM_DDR4_LRDIMM_ODT_LESS_BS]
      set odt_less_backside_rtt_park_ohm [get_parameter_value MEM_DDR4_LRDIMM_ODT_LESS_BS_PARK_OHM]

      set vrefdq_training_value     [get_parameter_value "MEM_DDR4_VREFDQ_TRAINING_VALUE"]
      set vrefdq_training_range     [get_parameter_value "MEM_DDR4_VREFDQ_TRAINING_RANGE"]
      set vrefdq_training_range_mrs [enum_data $vrefdq_training_range MRS]
      if { $vrefdq_training_range == "DDR4_VREFDQ_TRAINING_RANGE_0" } {
         set vrefdq_training_value_mrs [expr {int(($vrefdq_training_value - 60.0) / 0.65)}]
      } else {
         set vrefdq_training_value_mrs [expr {int(($vrefdq_training_value - 45.0) / 0.65)}]
      }
      set tmp [expr {($vrefdq_training_value_mrs & 63) | ($vrefdq_training_range_mrs << 7)}]
      append retval [bin2hex [num2bin $tmp 8]] 
      
      if {!$odt_less_backside_odt_scheme} {
         set tmp [get_parameter_value MEM_DDR4_SPD_144_DB_VREFDQ]
         set tmp [expr {$tmp | (0 << 7)}]
         append retval [bin2hex [num2bin $tmp 8]]
      } else {
         
         set spd_145_val [get_parameter_value "${m_param_prefix}_SPD_145_DB_MDQ_DRV"]
         set db_rtt_mrs  [expr {$spd_145_val & 7}]
         set db_rtt_enum [enum_find_by_field DDR4_SPD_145_RTT SETTING $db_rtt_mrs]
         set db_rtt_ohm  [enum_data $db_rtt_enum OHM]
         
         set rtt_park_ohm  $odt_less_backside_rtt_park_ohm
         set rodt_loads    [lrepeat [expr {$ranks_per_dimm - 1}] $rtt_park_ohm]
         
         set tmp [get_parameter_value "${m_param_prefix}_SPD_148_DRAM_DRV"]
         set shift [expr {($mem_data_rate <= 1866) ? 0 : \
                          ($mem_data_rate <= 2400) ? 2 : \
                                                     4}]
         set mem_drv_str_mrs  [expr {($tmp >> $shift) & 3}]
         set mem_drv_str_enum [enum_find_by_field DDR4_DRV_STR MRS $mem_drv_str_mrs]
         set mem_drv_str_ohm  [enum_data $mem_drv_str_enum OHM]
         
         set val_lst [_get_ideal_vref $io_voltage $mem_drv_str_ohm $db_rtt_ohm $rodt_loads]
         set vrefdq_training_range_mrs [lindex $val_lst 0]
         set vrefdq_training_value_mrs [lindex $val_lst 1]
         
         
         set tmp [expr {$vrefdq_training_value_mrs | ($vrefdq_training_range_mrs << 7)}]
         append retval [bin2hex [num2bin $tmp 8]]
      }
   }
   

   set val "00"
   append retval $val
   
   set val "00"
   append retval $val
   
   set val "00"
   append retval $val
   
   set tmp [expr {($is_lrdimm ? 192 : 0) | (1 << 5)}]
   set val [bin2hex [num2bin $tmp 8]]
   append retval $val
   
   set ca_ibt  [enum_data [get_parameter_value "${m_param_prefix}_RCD_CA_IBT_ENUM" ] SETTING]
   set cs_ibt  [enum_data [get_parameter_value "${m_param_prefix}_RCD_CS_IBT_ENUM" ] SETTING]
   set cke_ibt [enum_data [get_parameter_value "${m_param_prefix}_RCD_CKE_IBT_ENUM"] SETTING]
   set odt_ibt [enum_data [get_parameter_value "${m_param_prefix}_RCD_ODT_IBT_ENUM"] SETTING]
   set tmp     [expr {$ca_ibt | ($cs_ibt << 2) | ($cke_ibt << 4) | ($odt_ibt << 6)}]
   set val     [bin2hex [num2bin $tmp 8]]
   append retval $val
   
   set val "00"
   append retval $val
   
   set val "00"
   append retval $val
   
   set val "00"
   append retval $val
   
   set tmp $mem_data_rate
   set tmp [expr {$tmp < 1260 ? 1260 : $tmp}]
   set tmp [expr {$tmp > 3200 ? 3200 : $tmp}]
   set tmp [expr {int(ceil(($tmp - 1260.0) / 20.0)) & 127}]
   set val [bin2hex [num2bin $tmp 8]]
   append retval $val
   
   set val "00"
   append retval $val
   
   set val "00"
   append retval $val


   set rcd_parity_control_word [get_parameter_value "${m_param_prefix}_RCD_PARITY_CONTROL_WORD"]
   if {[expr $rcd_parity_control_word & 1]} {
      set rcd_command_latency [expr {$mem_data_rate <= 2400 ? 1 : 2}]
   } else {
      set rcd_command_latency 0
   }
   
   set_parameter_value "${m_param_prefix}_RCD_COMMAND_LATENCY" $rcd_command_latency
   
   set rcd_command_latency_word [expr {($rcd_command_latency == 0) ? 4 : ($rcd_command_latency - 1)}]
   set val [bin2hex [num2bin $rcd_command_latency_word 4]]
   append retval $val
   
   set val [bin2hex [num2bin $rcd_parity_control_word 4]]
   append retval $val
   
   set ranks_per_dimm         [get_parameter_value "${m_param_prefix}_RANKS_PER_DIMM"]
   set addr_mirr_en           [get_parameter_value "${m_param_prefix}_MIRROR_ADDRESSING_EN"]
   emif_assert {$is_rdimm || $is_lrdimm}
   emif_assert {$ranks_per_dimm == 1 || $ranks_per_dimm == 2 || $ranks_per_dimm == 4}
   set tmp [expr {($ranks_per_dimm <= 2 ? 0 : 1) | ($is_rdimm ? 4 : 0) | ($addr_mirr_en ? 8 : 0)}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set val "0"
   append retval $val
   
   set val "0"
   append retval $val
   
   set tmp $mem_data_rate
   set tmp [expr {$tmp < 1600 ? 1600 : $tmp}]
   set tmp [expr {$tmp > 3200 ? 3200 : $tmp}]
   set tmp [expr {($tmp <= 1600) ? 0 : \
                  ($tmp <= 1867) ? 1 : \
                  ($tmp <= 2134) ? 2 : \
                  ($tmp <= 2400) ? 3 : \
                  ($tmp <= 2667) ? 4 : \
                  ($tmp <= 2933) ? 5 : \
                                   6}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val

   set val "0"
   append retval $val
   
   set addr_width     [get_parameter_value "${m_param_prefix}_ADDR_WIDTH"]
   set tmp [expr {($ranks_per_dimm == 1) ? 3 : \
                  ($ranks_per_dimm == 2) ? 3 : \
                                           1}]
   set tmp [expr {$tmp | ($addr_width < 18 ? (1 << 3) : 0)}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set val "0"
   append retval $val
   
   set val "F"
   append retval $val
   
   set spd_138_val [get_parameter_value "${m_param_prefix}_SPD_138_RCD_CK_DRV"]
   set tmp [expr {(($spd_138_val & 3) << 2) | ($spd_138_val >> 2)}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set spd_137_val [get_parameter_value "${m_param_prefix}_SPD_137_RCD_CA_DRV"]
   set tmp [expr {$spd_137_val & 15}]
   set tmp [expr {(($tmp & 3) << 2) | ($tmp >> 2)}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set tmp [expr {$spd_137_val >> 4}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set val "0"
   append retval $val
   
   set val "0"
   append retval $val
   
   set val "0"
   append retval $val
   
   return $retval
}

proc ::altera_emif::ip_top::mem::ddr4::_derive_db_config_word {} {
   variable m_param_prefix
   
   set retval ""
   
   set val "0"
   append retval $val
   
   set val "F"
   append retval $val
   
   set val "0"
   append retval $val
   
   set val "0"
   append retval $val
   
   set val "0"
   append retval $val
   
   set mem_clk_freq  [get_parameter_value PHY_DDR4_MEM_CLK_FREQ_MHZ]
   set mem_data_rate [expr {$mem_clk_freq * 2}]
   set tmp $mem_data_rate
   set tmp [expr {$tmp < 1600 ? 1600 : $tmp}]
   set tmp [expr {$tmp > 3200 ? 3200 : $tmp}]
   set tmp [expr {($tmp <= 1600) ? 0 : \
                  ($tmp <= 1867) ? 1 : \
                  ($tmp <= 2134) ? 2 : \
                  ($tmp <= 2400) ? 3 : \
                  ($tmp <= 2667) ? 4 : \
                                   5}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set val "0"
   append retval $val
   
   set val "0"
   append retval $val
   
   set ranks_per_dimm [get_parameter_value "${m_param_prefix}_RANKS_PER_DIMM"]
   set tmp [expr {$ranks_per_dimm == 1 ? 14 : \
                  $ranks_per_dimm == 2 ? 12 : \
                                         0}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set val "0"
   append retval $val
   
   set spd_145_val [get_parameter_value "${m_param_prefix}_SPD_145_DB_MDQ_DRV"]
   set tmp [expr {$spd_145_val >> 4}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set tmp [expr {$spd_145_val & 7}]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set tmp [enum_data [get_parameter_value "${m_param_prefix}_DB_DQ_DRV_ENUM"] SETTING]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set tmp [enum_data [get_parameter_value "${m_param_prefix}_DB_RTT_PARK_ENUM"] SETTING]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val
   
   set tmp [enum_data [get_parameter_value "${m_param_prefix}_DB_RTT_WR_ENUM"] SETTING]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val 
   
   set tmp [enum_data [get_parameter_value "${m_param_prefix}_DB_RTT_NOM_ENUM"] SETTING]
   set val [bin2hex [num2bin $tmp 4]]
   append retval $val

   return $retval
}


proc ::altera_emif::ip_top::mem::ddr4::_init {} {
}

::altera_emif::ip_top::mem::ddr4::_init
