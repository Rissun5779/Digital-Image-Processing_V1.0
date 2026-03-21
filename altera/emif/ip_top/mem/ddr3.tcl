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


package provide altera_emif::ip_top::mem::ddr3 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::mem::ddr3:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*


   variable m_param_prefix "MEM_DDR3"
}


proc ::altera_emif::ip_top::mem::ddr3::create_parameters {is_top_level_component} {
   variable m_param_prefix

   add_user_param     "${m_param_prefix}_FORMAT_ENUM"                     string    MEM_FORMAT_UDIMM                     [enum_dropdown_entries MEM_FORMAT]
   add_user_param     "${m_param_prefix}_DQ_WIDTH"                        integer   72                                   {4:144}
   add_user_param     "${m_param_prefix}_DQ_PER_DQS"                      integer   8                                    [list 4 8]
   add_user_param     "${m_param_prefix}_DISCRETE_CS_WIDTH"               integer   1                                    [list 1 2 4]
   add_user_param     "${m_param_prefix}_NUM_OF_DIMMS"                    integer   1                                    [list 1 2]
   add_user_param     "${m_param_prefix}_RANKS_PER_DIMM"                  integer   1                                    [list 1 2 4 8]  
   add_user_param     "${m_param_prefix}_CKE_PER_DIMM"                    integer   1                                    [list 1 2]
   add_user_param     "${m_param_prefix}_CK_WIDTH"                        integer   1                                    [list 1 2 3 4]
   add_user_param     "${m_param_prefix}_ROW_ADDR_WIDTH"                  integer   15                                   [list 12 13 14 15 16]
   add_user_param     "${m_param_prefix}_COL_ADDR_WIDTH"                  integer   10                                   [list 10 11 12]
   add_user_param     "${m_param_prefix}_BANK_ADDR_WIDTH"                 integer   3                                    [list 3]
   add_user_param     "${m_param_prefix}_DM_EN"                           boolean   true                                 ""
   add_user_param     "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"   boolean   false                                ""
   add_user_param     "${m_param_prefix}_MIRROR_ADDRESSING_EN"            boolean   true                                 ""
   add_user_param     "${m_param_prefix}_HIDE_ADV_MR_SETTINGS"            boolean   true                                      ""
   add_user_param     "${m_param_prefix}_RDIMM_CONFIG"                    string    "0000000000000000"                   ""
   add_user_param     "${m_param_prefix}_LRDIMM_EXTENDED_CONFIG"          string    "000000000000000000"                 ""
   add_user_param     "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"          string    DDR3_ALERT_N_PLACEMENT_AC_LANES      [enum_dropdown_entries DDR3_ALERT_N_PLACEMENT]
   add_user_param     "${m_param_prefix}_ALERT_N_DQS_GROUP"               integer   0                                    [list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17]


   add_derived_param  "${m_param_prefix}_DQS_WIDTH"                  integer    8         true
   add_derived_param  "${m_param_prefix}_DM_WIDTH"                   integer    1         false
   add_derived_param  "${m_param_prefix}_CS_WIDTH"                   integer    1         false
   add_derived_param  "${m_param_prefix}_CS_PER_DIMM"                integer    1         true
   add_derived_param  "${m_param_prefix}_CKE_WIDTH"                  integer    1         false
   add_derived_param  "${m_param_prefix}_ODT_WIDTH"                  integer    1         false
   add_derived_param  "${m_param_prefix}_ADDR_WIDTH"                 integer    1         false
   add_derived_param  "${m_param_prefix}_RM_WIDTH"                   integer    0         false
   add_derived_param  "${m_param_prefix}_AC_PAR_EN"                  boolean    false     false
   add_derived_param  "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS"      integer    1         false
   add_derived_param  "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"       integer    1         false

   add_derived_param  "${m_param_prefix}_TTL_DQS_WIDTH"              integer    8         false
   add_derived_param  "${m_param_prefix}_TTL_DQ_WIDTH"               integer    72        false
   add_derived_param  "${m_param_prefix}_TTL_DM_WIDTH"               integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_CS_WIDTH"               integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_CK_WIDTH"               integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_CKE_WIDTH"              integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_ODT_WIDTH"              integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_BANK_ADDR_WIDTH"        integer    3         false
   add_derived_param  "${m_param_prefix}_TTL_ADDR_WIDTH"             integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_RM_WIDTH"               integer    0         false
   add_derived_param  "${m_param_prefix}_TTL_NUM_OF_DIMMS"           integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_NUM_OF_PHYSICAL_RANKS"  integer    1         false
   add_derived_param  "${m_param_prefix}_TTL_NUM_OF_LOGICAL_RANKS"   integer    1         false

   add_derived_param  "${m_param_prefix}_MR0"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR1"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR2"                     integer    0         false
   add_derived_param  "${m_param_prefix}_MR3"                     integer    0         false
   add_derived_param  "${m_param_prefix}_ADDRESS_MIRROR_BITVEC"   integer    0         false

   add_user_param     "${m_param_prefix}_BL_ENUM"           string     DDR3_BL_BL8                [enum_dropdown_entries DDR3_BL]
   add_user_param     "${m_param_prefix}_BT_ENUM"           string     DDR3_BT_SEQUENTIAL         [enum_dropdown_entries DDR3_BT]
   add_user_param     "${m_param_prefix}_ASR_ENUM"          string     DDR3_ASR_MANUAL            [enum_dropdown_entries DDR3_ASR]
   add_user_param     "${m_param_prefix}_SRT_ENUM"          string     DDR3_SRT_NORMAL            [enum_dropdown_entries DDR3_SRT]
   add_user_param     "${m_param_prefix}_PD_ENUM"           string     DDR3_PD_OFF                [enum_dropdown_entries DDR3_PD]
   add_user_param     "${m_param_prefix}_DRV_STR_ENUM"      string     DDR3_DRV_STR_RZQ_7         [enum_dropdown_entries DDR3_DRV_STR]
   add_user_param     "${m_param_prefix}_DLL_EN"            boolean    true                       ""
   add_user_param     "${m_param_prefix}_RTT_NOM_ENUM"      string     DDR3_RTT_NOM_ODT_DISABLED  [enum_dropdown_entries DDR3_RTT_NOM]
   add_user_param     "${m_param_prefix}_RTT_WR_ENUM"       string     DDR3_RTT_WR_RZQ_4          [enum_dropdown_entries DDR3_RTT_WR]
   add_user_param     "${m_param_prefix}_WTCL"              integer    10                         [list 5 6 7 8 9 10]
   add_user_param     "${m_param_prefix}_ATCL_ENUM"         string     DDR3_ATCL_DISABLED         [enum_dropdown_entries DDR3_ATCL]
   add_user_param     "${m_param_prefix}_TCL"               integer    14                         [list 5 6 7 8 9 10 11 12 13 14]

   add_user_param     "${m_param_prefix}_USE_DEFAULT_ODT"   boolean        true                                         ""
   add_user_param     "${m_param_prefix}_R_ODTN_1X1"        string_list    [list "Rank 0"]                              ""
   add_user_param     "${m_param_prefix}_R_ODT0_1X1"        string_list    [enum_data DDR3_DEFAULT_RODT_1X1_ODT0 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_1X1"        string_list    [list "Rank 0"]                              ""
   add_user_param     "${m_param_prefix}_W_ODT0_1X1"        string_list    [enum_data DDR3_DEFAULT_WODT_1X1_ODT0 VALUE] [list "off"  "on"]


   add_user_param     "${m_param_prefix}_R_ODTN_2X2"        string_list    [list "Rank 0" "Rank 1"]                     ""
   add_user_param     "${m_param_prefix}_R_ODT0_2X2"        string_list    [enum_data DDR3_DEFAULT_RODT_2X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_2X2"        string_list    [enum_data DDR3_DEFAULT_RODT_2X2_ODT1 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_2X2"        string_list    [list "Rank 0" "Rank 1"]                     ""
   add_user_param     "${m_param_prefix}_W_ODT0_2X2"        string_list    [enum_data DDR3_DEFAULT_WODT_2X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_2X2"        string_list    [enum_data DDR3_DEFAULT_WODT_2X2_ODT1 VALUE] [list "off"  "on"]


   add_user_param     "${m_param_prefix}_R_ODTN_4X2"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_R_ODT0_4X2"        string_list    [enum_data DDR3_DEFAULT_RODT_4X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_4X2"        string_list    [enum_data DDR3_DEFAULT_RODT_4X2_ODT1 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_4X2"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_W_ODT0_4X2"        string_list    [enum_data DDR3_DEFAULT_WODT_4X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_4X2"        string_list    [enum_data DDR3_DEFAULT_WODT_4X2_ODT1 VALUE] [list "off"  "on"]


   add_user_param     "${m_param_prefix}_R_ODTN_4X4"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_R_ODT0_4X4"        string_list    [enum_data DDR3_DEFAULT_RODT_4X4_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_4X4"        string_list    [enum_data DDR3_DEFAULT_RODT_4X4_ODT1 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT2_4X4"        string_list    [enum_data DDR3_DEFAULT_RODT_4X4_ODT2 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT3_4X4"        string_list    [enum_data DDR3_DEFAULT_RODT_4X4_ODT3 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_4X4"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]   ""
   add_user_param     "${m_param_prefix}_W_ODT0_4X4"        string_list    [enum_data DDR3_DEFAULT_WODT_4X4_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_4X4"        string_list    [enum_data DDR3_DEFAULT_WODT_4X4_ODT1 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT2_4X4"        string_list    [enum_data DDR3_DEFAULT_WODT_4X4_ODT2 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT3_4X4"        string_list    [enum_data DDR3_DEFAULT_WODT_4X4_ODT3 VALUE] [list "off"  "on"]

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

   add_user_param     "${m_param_prefix}_SPEEDBIN_ENUM"    string     DDR3_SPEEDBIN_2133 [enum_dropdown_entries DDR3_SPEEDBIN] ""                 ""
   add_user_param     "${m_param_prefix}_TIS_PS"           integer    60                 {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TIS_AC_MV"        integer    135                {175 160 150 135 130 125}             ""                 "mV"
   add_user_param     "${m_param_prefix}_TIH_PS"           integer    95                 {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TIH_DC_MV"        integer    100                {100 90}                              ""                 "mV"
   add_user_param     "${m_param_prefix}_TDS_PS"           integer    53                 {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDS_AC_MV"        integer    135                {175 160 150 135 130}                 ""                 "mV"
   add_user_param     "${m_param_prefix}_TDH_PS"           integer    55                 {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDH_DC_MV"        integer    100                {100 90}                              ""                 "mV"
   add_user_param     "${m_param_prefix}_TDQSQ_PS"         integer    75                 {-5000:5000}                          "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TQH_CYC"          float      0.38               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TDQSCK_PS"        integer    180                {0:5000}                              "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDQSS_CYC"        float      0.27               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TQSH_CYC"         float      0.4                ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TDSH_CYC"         float      0.18               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TWLS_PS"          float      125                ""                                    "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TWLH_PS"          float      125                ""                                    "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDSS_CYC"         float      0.18               ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TINIT_US"         integer    500                ""                                    "Microseconds"     ""
   add_user_param     "${m_param_prefix}_TMRD_CK_CYC"      integer    4                  ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TRAS_NS"          float      33                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRCD_NS"          float      13.09              ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRP_NS"           float      13.09              ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TREFI_US"         float      7.8                ""                                    "Microseconds"     ""
   add_user_param     "${m_param_prefix}_TRFC_NS"          float      160                ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TWR_NS"           float      15                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TWTR_CYC"         integer    8                  {1:8}                                 "Cycles"           ""
   add_user_param     "${m_param_prefix}_TFAW_NS"          float      25                 ""                                    "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRRD_CYC"         integer    6                  ""                                    "Cycles"           ""
   add_user_param     "${m_param_prefix}_TRTP_CYC"         integer    8                  ""                                    "Cycles"           ""


   add_derived_param  "${m_param_prefix}_TINIT_CK"         integer    499       false
   add_derived_param  "${m_param_prefix}_TDQSCK_DERV_PS"   integer    2         false
   add_derived_param  "${m_param_prefix}_TDQSCKDS"         integer    450       false
   add_derived_param  "${m_param_prefix}_TDQSCKDM"         integer    900       false
   add_derived_param  "${m_param_prefix}_TDQSCKDL"         integer    1200      false
   add_derived_param  "${m_param_prefix}_TRAS_CYC"         integer    36        false
   add_derived_param  "${m_param_prefix}_TRCD_CYC"         integer    14        false
   add_derived_param  "${m_param_prefix}_TRP_CYC"          integer    14        false
   add_derived_param  "${m_param_prefix}_TRFC_CYC"         integer    171       false
   add_derived_param  "${m_param_prefix}_TWR_CYC"          integer    16        false
   add_derived_param  "${m_param_prefix}_TFAW_CYC"         integer    27        false
   add_derived_param  "${m_param_prefix}_TREFI_CYC"        integer    8320      false

   add_derived_param  "${m_param_prefix}_CFG_GEN_SBE"      boolean    false     false
   add_derived_param  "${m_param_prefix}_CFG_GEN_DBE"      boolean    false     false

   if {![ini_is_on "emif_show_internal_settings"]} {
      set_parameter_property "${m_param_prefix}_DLL_EN" VISIBLE  false
   }

   return 1
}

proc ::altera_emif::ip_top::mem::ddr3::set_family_specific_defaults {family_enum base_family_enum is_hps} {
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

proc ::altera_emif::ip_top::mem::ddr3::add_display_items {tabs} {
   variable m_param_prefix

   set mem_params_tab [lindex $tabs 0]
   set mem_io_tab     [lindex $tabs 1]
   set mem_timing_tab [lindex $tabs 2]

   set topology_grp [get_string GRP_MEM_TOPOLOGY_NAME]
   set lat_grp      [get_string GRP_MEM_LATENCY_NAME]
   set mrs_grp      [get_string GRP_MEM_MRS_NAME]
   set odt_grp      [get_string GRP_MEM_ODT_NAME]

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
   add_param_to_gui $topology_grp "${m_param_prefix}_DM_EN"
   add_param_to_gui $topology_grp "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"
   add_param_to_gui $topology_grp "${m_param_prefix}_MIRROR_ADDRESSING_EN"
   add_param_to_gui $topology_grp "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"
   add_param_to_gui $topology_grp "${m_param_prefix}_ALERT_N_DQS_GROUP"

   add_param_to_gui $lat_grp "${m_param_prefix}_TCL"
   add_param_to_gui $lat_grp "${m_param_prefix}_WTCL"
   add_param_to_gui $lat_grp "${m_param_prefix}_ATCL_ENUM"
   add_param_to_gui $lat_grp "${m_param_prefix}_BL_ENUM"
   add_param_to_gui $lat_grp "${m_param_prefix}_BT_ENUM"

   add_param_to_gui $mrs_grp "${m_param_prefix}_HIDE_ADV_MR_SETTINGS"
   add_param_to_gui $mrs_grp "${m_param_prefix}_PD_ENUM"
   add_param_to_gui $mrs_grp "${m_param_prefix}_DLL_EN"
   add_param_to_gui $mrs_grp "${m_param_prefix}_ASR_ENUM"
   add_param_to_gui $mrs_grp "${m_param_prefix}_SRT_ENUM"
   add_display_item $mrs_grp [get_string DDR3_RDIMM_TXT_NAME] TEXT "<html><b>RDIMM Configuration</b><br>"
   add_param_to_gui $mrs_grp "${m_param_prefix}_RDIMM_CONFIG"
   add_display_item $mrs_grp [get_string DDR3_LRDIMM_TXT_NAME] TEXT "<html><b>LRDIMM Configuration</b><br>"
   add_param_to_gui $mrs_grp "${m_param_prefix}_LRDIMM_EXTENDED_CONFIG"

   set io_grp       [get_string GRP_MEM_IO_NAME]
   set odt_grp      [get_string GRP_MEM_ODT_NAME]

   add_param_to_gui $io_grp "${m_param_prefix}_DRV_STR_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RTT_NOM_ENUM"
   add_param_to_gui $io_grp "${m_param_prefix}_RTT_WR_ENUM"

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
   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_rtbl_id4" "<html>This matrix is derived based on settings for RTT_DRV, RTT_NOM and the read ODT assertion table."
   add_table_to_gui $odt_grp "${m_param_prefix}_derived_odt_rtbl" [list table fixed_size rows:5]
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODTN"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT0"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT1"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT2"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT3"

   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_wtbl_id5" "<html><b>Derived ODT Matrix for Write Accesses</b>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_rtbl_id6" "<html>This matrix is derived based on settings for RTT_WR, RTT_NOM and the write ODT assertion table."
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
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDS_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDS_AC_MV"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDH_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDH_DC_MV"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSQ_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TQH_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCK_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCKDS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCKDM"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSCKDL"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDQSS_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TQSH_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDSH_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TWLS_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TWLH_PS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TDSS_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TINIT_US"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TMRD_CK_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TRAS_NS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TRCD_NS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TRP_NS"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TWR_NS"

   add_display_item $mem_timing_tab $timing_sb_freq_ps_grp GROUP
   add_text_to_gui  $timing_sb_freq_ps_grp "${m_param_prefix}_id2" "<html>Update the following as you change the operating frequency, even if the device speed bin has not changed."
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TRRD_CYC"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TFAW_NS"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TWTR_CYC"
   add_param_to_gui $timing_sb_freq_ps_grp "${m_param_prefix}_TRTP_CYC"

   add_display_item $mem_timing_tab $timing_d_t_grp GROUP
   add_text_to_gui  $timing_d_t_grp "${m_param_prefix}_id3" "<html>Update the following as you change the physical memory device density.<BR>Incorrect values can cause data corruption."
   add_param_to_gui $timing_d_t_grp "${m_param_prefix}_TRFC_NS"
   add_param_to_gui $timing_d_t_grp "${m_param_prefix}_TREFI_US"

   return 1
}

proc ::altera_emif::ip_top::mem::ddr3::validate {} {

   set odt_grp [get_string GRP_MEM_ODT_NAME]
   set_display_item_property $odt_grp VISIBLE true

   _show_hide_adv_mrs_settings

   _validate_memory_parameters

   _validate_memory_timing_parameters

   _validate_and_derive_ttl_width_parameters

   if {![has_pending_ipgen_e_msg]} {

      _derive_protocol_agnostic_parameters

      _derive_memory_timing_parameters

      _derive_mode_register_parameters

      _derive_odt_parameters
   }

   return 1
}


proc ::altera_emif::ip_top::mem::ddr3::_show_hide_adv_mrs_settings {} {
   variable m_param_prefix
   set show [expr {[get_parameter_value "${m_param_prefix}_HIDE_ADV_MR_SETTINGS"] ? 0 : 1}]

   set_parameter_property    "${m_param_prefix}_ASR_ENUM"  VISIBLE $show
   set_parameter_property    "${m_param_prefix}_SRT_ENUM"  VISIBLE $show
   set_parameter_property    "${m_param_prefix}_PD_ENUM"   VISIBLE $show
}

proc ::altera_emif::ip_top::mem::ddr3::_validate_memory_parameters {} {

   variable m_param_prefix

   set format_enum            [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set is_discrete            [enum_same $format_enum MEM_FORMAT_DISCRETE]
   set is_udimm               [enum_same $format_enum MEM_FORMAT_UDIMM]
   set is_rdimm               [enum_same $format_enum MEM_FORMAT_RDIMM]
   set is_lrdimm              [enum_same $format_enum MEM_FORMAT_LRDIMM]
   set is_sodimm              [enum_same $format_enum MEM_FORMAT_SODIMM]
   set mem_tcl                [get_parameter_value "${m_param_prefix}_TCL"]
   set mem_wtcl               [get_parameter_value "${m_param_prefix}_WTCL"]
   set row_addr_width         [get_parameter_value "${m_param_prefix}_ROW_ADDR_WIDTH"]
   set col_addr_width         [get_parameter_value "${m_param_prefix}_COL_ADDR_WIDTH"]
   set dq_width               [get_parameter_value "${m_param_prefix}_DQ_WIDTH"]
   set dq_per_dqs             [get_parameter_value "${m_param_prefix}_DQ_PER_DQS"]
   set dm_en                  [get_parameter_value "${m_param_prefix}_DM_EN"]
   set discrete_cs_width      [get_parameter_value "${m_param_prefix}_DISCRETE_CS_WIDTH"]
   set num_of_dimms           [get_parameter_value "${m_param_prefix}_NUM_OF_DIMMS"]
   set ranks_per_dimm         [get_parameter_value "${m_param_prefix}_RANKS_PER_DIMM"]
   set rdimm_config           [get_parameter_value "${m_param_prefix}_RDIMM_CONFIG"]
   set lrdimm_extended_config [get_parameter_value "${m_param_prefix}_LRDIMM_EXTENDED_CONFIG"]
   set bl_enum                [get_parameter_value "${m_param_prefix}_BL_ENUM"]
   set nominal_odt_enum       [get_parameter_value "${m_param_prefix}_RTT_NOM_ENUM"]
   set alert_n_placement_enum [get_parameter_value "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"]

   if {$is_discrete} {
      set addr_mirror_applicable [expr {($discrete_cs_width > 1)}]
      set addr_mirror            [expr {[get_parameter_value "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"] && $addr_mirror_applicable}]
   } else {
      set addr_mirror_applicable [expr {($ranks_per_dimm > 1)}]
      set addr_mirror            [expr {[get_parameter_value "${m_param_prefix}_MIRROR_ADDRESSING_EN"] && $addr_mirror_applicable}]
   }

   set_parameter_property "${m_param_prefix}_DISCRETE_CS_WIDTH"                VISIBLE $is_discrete
   set_parameter_property "${m_param_prefix}_NUM_OF_DIMMS"                     VISIBLE [expr {!$is_discrete}]
   set_parameter_property "${m_param_prefix}_RANKS_PER_DIMM"                   VISIBLE [expr {!$is_discrete}]
   set_parameter_property "${m_param_prefix}_RM_WIDTH"                         VISIBLE [expr {$is_lrdimm}]
   set_parameter_property "${m_param_prefix}_CS_PER_DIMM"                      VISIBLE [expr {!$is_discrete}]
   set_parameter_property "${m_param_prefix}_DISCRETE_MIRROR_ADDRESSING_EN"    VISIBLE [expr {$is_discrete && $addr_mirror_applicable}]
   set_parameter_property "${m_param_prefix}_MIRROR_ADDRESSING_EN"             VISIBLE [expr {!$is_discrete && $addr_mirror_applicable}]
   set_display_item_property [get_string DDR3_RDIMM_TXT_NAME]                  VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_parameter_property "${m_param_prefix}_RDIMM_CONFIG"                     VISIBLE [expr {$is_rdimm || $is_lrdimm}]
   set_display_item_property [get_string DDR3_LRDIMM_TXT_NAME]                 VISIBLE $is_lrdimm
   set_parameter_property "${m_param_prefix}_LRDIMM_EXTENDED_CONFIG"           VISIBLE $is_lrdimm
   
   set_parameter_property "${m_param_prefix}_CKE_PER_DIMM"                     VISIBLE false

   set_display_item_property [get_string DDR4_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR4_LRDIMM_TXT_NAME]        VISIBLE false

   set ac_par_en [expr {($is_rdimm || $is_lrdimm) ? true : false}]
   set_parameter_value "${m_param_prefix}_AC_PAR_EN" $ac_par_en

   set_parameter_property "${m_param_prefix}_ALERT_N_PLACEMENT_ENUM"  VISIBLE $ac_par_en
   set_parameter_property "${m_param_prefix}_ALERT_N_DQS_GROUP"       VISIBLE [expr {$ac_par_en && $alert_n_placement_enum == "DDR3_ALERT_N_PLACEMENT_DATA_LANES"}]

   set addr_width     [expr {max($row_addr_width, $col_addr_width)}]
   set max_addr_width [expr {$is_lrdimm ? 18 : 16}]

   if {$addr_width > $max_addr_width} {
      post_ipgen_e_msg MSG_DDRX_MAX_ADDRESS_PINS_EXCEEDED [list $max_addr_width [enum_data $format_enum UI_NAME] $addr_width]
   }
   set_parameter_value "${m_param_prefix}_ADDR_WIDTH" $addr_width

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
   
   if {$is_lrdimm} {
      if {![::altera_emif::util::qini::ini_is_on "emif_show_internal_settings"] && ![get_parameter_value "INTERNAL_TESTING_MODE"]} {
         post_ipgen_e_msg MSG_DDR3_LRDIMM_RESTRICTED
      }
   }

   if {$dm_en} {
      if {$dq_per_dqs == 4} {
         post_ipgen_e_msg MSG_DDR3_NO_DM_FOR_X4_MODE
      }

      if {$dq_per_dqs == 8 && $is_lrdimm} {
         post_ipgen_e_msg MSG_DDR3_NO_DM_FOR_X8_LRDIMM
      }
   }

   if {$dq_per_dqs == 4 && [expr {$dqs_width % 2 == 1}]} {
      post_ipgen_e_msg MSG_DDRX_ODD_DQS_GROUPS_IN_X4_MODE
   }

   set dm_width [expr {$dm_en ? $dqs_width : 0}]
   set_parameter_value "${m_param_prefix}_DM_WIDTH" $dm_width

   if {($is_udimm || $is_rdimm || $is_sodimm) && ($ranks_per_dimm != 1 && $ranks_per_dimm != 2 && $ranks_per_dimm != 4)} {
      post_ipgen_e_msg MSG_DDRX_MAX_RANKS_PER_DIMM_EXCEEDED
   }
   if {$is_lrdimm && $ranks_per_dimm < 2} {
      post_ipgen_e_msg MSG_DDRX_LRDIMM_RANKS_PER_DIMM_TOO_LOW
   }

   set num_of_physical_ranks [expr {$is_discrete ? $discrete_cs_width : ($num_of_dimms * $ranks_per_dimm)}]
   set_parameter_value "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS" $num_of_physical_ranks

   if {$is_lrdimm} {
      set num_of_logical_ranks [expr {$num_of_dimms * 2}]
   } else {
      set num_of_logical_ranks $num_of_physical_ranks
   }
   set_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS" $num_of_logical_ranks

   if {$is_udimm || $is_sodimm} {
      set cs_per_dimm $ranks_per_dimm
   } elseif {$is_rdimm} {
      set cs_per_dimm [expr {$ranks_per_dimm == 1 ? 2 : $ranks_per_dimm}]
   } elseif {$is_lrdimm} {
      set cs_per_dimm 2
   } else {
      set cs_per_dimm 1
   }
   set_parameter_value "${m_param_prefix}_CS_PER_DIMM" $cs_per_dimm

   if {$is_lrdimm} {
      set rank_mult_factor [expr {$num_of_physical_ranks / $num_of_logical_ranks}]
      if {$rank_mult_factor >= 2} {
         set rm_width [expr {int([log2 $rank_mult_factor])}]
      } else {
         set rm_width 0
      }
   } else {
      set rm_width 0
   }
   set_parameter_value "${m_param_prefix}_RM_WIDTH" $rm_width

   if {$is_discrete || $is_sodimm} {
      set cs_width  $num_of_physical_ranks
      set cke_width $num_of_physical_ranks
      set odt_width $num_of_physical_ranks
   } else {
      set cs_width  [expr {$num_of_dimms * $cs_per_dimm}]
      
      if {$is_lrdimm} {
         set cke_width 2
         set odt_width 2
      } else {
         set cke_width [expr {$ranks_per_dimm >= 2 ? 2 * $num_of_dimms : $num_of_dimms}]
         set odt_width [expr {$ranks_per_dimm >= 2 ? 2 * $num_of_dimms : $num_of_dimms}]
      }
   }
   set_parameter_value "${m_param_prefix}_CS_WIDTH"  $cs_width
   set_parameter_value "${m_param_prefix}_CKE_WIDTH" $cke_width
   set_parameter_value "${m_param_prefix}_ODT_WIDTH" $odt_width

   if {$is_rdimm || $is_lrdimm} {
      set rdimm_config_ok 0
      if {([string length $rdimm_config] == 18) && ([regexp -nocase {^0x[0-9ABCDEF]+$} $rdimm_config] == 1)} {
         set rdimm_config_ok 1
      } elseif {([string length $rdimm_config] == 16) && ([regexp -nocase {^[0-9ABCDEF]+$} $rdimm_config] == 1)} {
         set rdimm_config_ok 1
      }

      if {$rdimm_config_ok == 0} {
         post_ipgen_e_msg MSG_DDR3_RDIMM_INVALID_CONFIG
      }
   }

   if {$is_lrdimm} {
      set lrdimm_extended_config_ok 0
      if {([string length $lrdimm_extended_config] == 20) && ([regexp -nocase {^0x[0-9ABCDEF]+$} $lrdimm_extended_config] == 1)} {
         set lrdimm_extended_config_ok 1
      } elseif {([string length $lrdimm_extended_config] == 18) && ([regexp -nocase {^[0-9ABCDEF]+$} $lrdimm_extended_config] == 1)} {
         set lrdimm_extended_config_ok 1
      }

      if {$row_addr_width != 16} {
         post_ipgen_e_msg MSG_DDR3_LRDIMM_ROW_ADDR_WIDTH_NOT_VALID
      }

      if {$lrdimm_extended_config_ok == 0} {
         post_ipgen_e_msg MSG_DDR3_LRDIMM_INVALID_CONFIG
      }
   }

   if {($is_rdimm || $is_lrdimm) && ($rdimm_config == "0000000000000000")} {
      post_ipgen_i_msg MSG_DDRX_RDIMM_IS_USING_DEFAULT_CONFIGURATION
   }

   if {$is_lrdimm && ($lrdimm_extended_config == "000000000000000000")} {
      post_ipgen_i_msg MSG_DDRX_LRDIMM_IS_USING_DEFAULT_CONFIGURATION
   }

   if { [lsearch -exact [get_feature_support_level FEATURE_BURST_LENGTH PROTOCOL_DDR3] $bl_enum] == -1 } {
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

   if {$mem_tcl < $mem_wtcl} {
      post_ipgen_e_msg MSG_DDR3_WTCL_GT_TCL
   }

   set support_sim [get_feature_support_level FEATURE_RTL_SIM PROTOCOL_DDR3 RATE_INVALID]
   set_parameter_value "MEM_HAS_SIM_SUPPORT" $support_sim
}

proc ::altera_emif::ip_top::mem::ddr3::_derive_odt_parameters {} {

   variable m_param_prefix



   set format_enum            [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set is_lrdimm              [enum_same $format_enum MEM_FORMAT_LRDIMM]
   set is_rdimm               [enum_same $format_enum MEM_FORMAT_RDIMM]
   set odt_width              [get_parameter_value "${m_param_prefix}_ODT_WIDTH"]
   set num_of_dimms           [get_parameter_value "${m_param_prefix}_NUM_OF_DIMMS"]
   set ranks_per_dimm         [get_parameter_value "${m_param_prefix}_RANKS_PER_DIMM"]
   set num_of_logical_ranks   [get_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"]
   set ping_pong_en           [get_parameter_value "PHY_PING_PONG_EN"]

   set target_name [list]
   if {$is_lrdimm} {
      set num_odt_targets $num_of_dimms
      for {set target 0} {$target < 4} {incr target} {
         if {$target < $num_of_dimms} {
            lappend target_name "DIMM ${target}"
         } else {
            lappend target_name "-"
         }
      }
   } else {
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

   set use_default_odt [get_parameter_value "${m_param_prefix}_USE_DEFAULT_ODT"]
   if {!$use_default_odt} {
      ::altera_emif::util::hwtcl_utils::update_gui_texts_visibility "${m_param_prefix}_odt" TRUE
      ::altera_emif::util::hwtcl_utils::update_gui_tables_visibility "${m_param_prefix}_odt_${odt_tbl}" TRUE
   } else {
      ::altera_emif::util::hwtcl_utils::update_gui_texts_visibility "${m_param_prefix}_odt" FALSE
   }

   set_parameter_value "${m_param_prefix}_R_DERIVED_ODTN" $target_name
   set_parameter_value "${m_param_prefix}_W_DERIVED_ODTN" $target_name
   set dynamic_odt_enum [get_parameter_value "${m_param_prefix}_RTT_WR_ENUM"]
   set nominal_odt_enum [get_parameter_value "${m_param_prefix}_RTT_NOM_ENUM"]
   set drive_odt_enum   [get_parameter_value "${m_param_prefix}_DRV_STR_ENUM"]
   set dynamic_odt_name [enum_data $dynamic_odt_enum UI_NAME]
   set nominal_odt_name [enum_data $nominal_odt_enum UI_NAME]
   set drive_odt_name   [enum_data $drive_odt_enum UI_NAME]
   set use_dynamic_odt  [expr {![enum_same $dynamic_odt_enum DDR3_RTT_WR_ODT_DISABLED]}]
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
            set odt_tbl_ucase [string toupper $odt_tbl]
            set rd_odt [enum_data "DDR3_DEFAULT_RODT_${odt_tbl_ucase}_ODT${odt_pin}" VALUE]
            set wr_odt [enum_data "DDR3_DEFAULT_WODT_${odt_tbl_ucase}_ODT${odt_pin}" VALUE]
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

               if {$is_rdimm && $ranks_per_dimm == 1} {
                  set target_cs [expr {$target * 2}]
               } else {
                  set target_cs $target
               }

               if {$intersect} {
                  set rd_odt_setting "(Drive) $drive_odt_name"
               } else {
                  switch $rd_odt_val {
                     "on" {
                        set rd_odt_setting $nominal_odt_name
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
                        set rd_odt_setting [enum_data DDR3_RTT_NOM_ODT_DISABLED UI_NAME]
                     }
                  }
               }

               switch $wr_odt_val {
                  "on" {
                     if { $use_dynamic_odt && $intersect } {
                        set wr_odt_setting "(Dynamic) $dynamic_odt_name"
                     } else {
                        set wr_odt_setting $nominal_odt_name
                     }
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
                     set wr_odt_setting [enum_data DDR3_RTT_NOM_ODT_DISABLED UI_NAME]
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

   if { $nominal_odt_enum == "DDR3_RTT_NOM_ODT_DISABLED" && $num_of_logical_ranks > 1} {
      post_ipgen_w_msg MSG_DDRX_MULTIRANK_NOM_ODT_DISABLED
   }

   set_parameter_value "${m_param_prefix}_SEQ_ODT_TABLE_LO"        [bin2num $seq_odt_lo]
   set_parameter_value "${m_param_prefix}_SEQ_ODT_TABLE_HI"        [bin2num $seq_odt_hi]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_READ_ODT_CHIP"  [bin2num $ctrl_odt_rchip]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_WRITE_ODT_CHIP" [bin2num $ctrl_odt_wchip]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_READ_ODT_RANK"  [bin2num $ctrl_odt_rrank]
   set_parameter_value "${m_param_prefix}_CTRL_CFG_WRITE_ODT_RANK" [bin2num $ctrl_odt_wrank]

   return 1
}

proc ::altera_emif::ip_top::mem::ddr3::_validate_memory_timing_parameters {} {

   variable m_param_prefix

   set ok 1

   set mem_clk_freq       [get_parameter_value PHY_DDR3_MEM_CLK_FREQ_MHZ]
   set io_voltage         [get_parameter_value PHY_DDR3_IO_VOLTAGE]
   set tis_ac_mv          [get_parameter_value "${m_param_prefix}_TIS_AC_MV"]
   set tih_dc_mv          [get_parameter_value "${m_param_prefix}_TIH_DC_MV"]
   set tds_ac_mv          [get_parameter_value "${m_param_prefix}_TDS_AC_MV"]
   set tdh_dc_mv          [get_parameter_value "${m_param_prefix}_TDH_DC_MV"]
   set speedbin_enum      [get_parameter_value "${m_param_prefix}_SPEEDBIN_ENUM"]
   set speedbin_ui_name   [enum_data $speedbin_enum UI_NAME]
   set speedbin_value     [enum_data $speedbin_enum VALUE]
   set mem_fmax           [enum_data $speedbin_enum FMAX_MHZ]
   set mem_fmin           [enum_data $speedbin_enum FMIN_MHZ]
   set allowed_voltages   [enum_data $speedbin_enum ALLOWED_VOLTAGES]

   if {$io_voltage == 1.5} {
      set ddr3_acdc_enum        "DDR3_ACDC_DDR3_${speedbin_value}"
      set protocol_display_name [enum_data DDR3_VOLTAGE_DDR3 UI_NAME]
   } elseif {$io_voltage == 1.35} {
      set ddr3_acdc_enum        "DDR3_ACDC_DDR3L_${speedbin_value}"
      set protocol_display_name [enum_data DDR3_VOLTAGE_DDR3L UI_NAME]
   } elseif {$io_voltage == 1.25} {
      set ddr3_acdc_enum        "DDR3_ACDC_DDR3U_${speedbin_value}"
      set protocol_display_name [enum_data DDR3_VOLTAGE_DDR3U UI_NAME]
   } else {
      emif_ie "Unknown voltage $io_voltage for DDR3"
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
      set allowed_tis_ac_mv [enum_data $ddr3_acdc_enum ALLOWED_TIS_AC]
      set allowed_tih_dc_mv [enum_data $ddr3_acdc_enum ALLOWED_TIH_DC]
      set allowed_tds_ac_mv [enum_data $ddr3_acdc_enum ALLOWED_TDS_AC]
      set allowed_tdh_dc_mv [enum_data $ddr3_acdc_enum ALLOWED_TDH_DC]

      foreach user_val [list $tis_ac_mv $tih_dc_mv $tds_ac_mv $tdh_dc_mv] \
              allowed_vals [list $allowed_tis_ac_mv $allowed_tih_dc_mv $allowed_tds_ac_mv $allowed_tdh_dc_mv] \
              param_name [list "${m_param_prefix}_TIS_AC_MV" "${m_param_prefix}_TIH_DC_MV" "${m_param_prefix}_TDS_AC_MV" "${m_param_prefix}_TDH_DC_MV"] {

         if {[lsearch -exact -integer $allowed_vals $user_val] == -1} {
            set param_display_name [get_parameter_property $param_name DISPLAY_NAME]
            post_ipgen_e_msg MSG_DDRX_AC_DC_LEVEL_NOT_SUPPORTED [list $full_speedbin_name $param_display_name [join $allowed_vals " or "]]
            set ok 0
         }
      }
   }

   return $ok
}

proc ::altera_emif::ip_top::mem::ddr3::_derive_memory_timing_parameters {} {

   variable m_param_prefix

   set mem_clk_freq       [get_parameter_value "PHY_DDR3_MEM_CLK_FREQ_MHZ" ]
   set mem_tras_ns        [get_parameter_value "${m_param_prefix}_TRAS_NS"]
   set mem_trcd_ns        [get_parameter_value "${m_param_prefix}_TRCD_NS"]
   set mem_trp_ns         [get_parameter_value "${m_param_prefix}_TRP_NS"]
   set mem_trfc_ns        [get_parameter_value "${m_param_prefix}_TRFC_NS"]
   set mem_twr_ns         [get_parameter_value "${m_param_prefix}_TWR_NS"]
   set mem_tfaw_ns        [get_parameter_value "${m_param_prefix}_TFAW_NS"]
   set mem_trefi_ns       [expr {[get_parameter_value "${m_param_prefix}_TREFI_US"] * 1000}]
   set mem_tinit_ns       [expr {[get_parameter_value "${m_param_prefix}_TINIT_US"] * 1000}]
   set mem_clk_ns         [expr {(1000000.0 / $mem_clk_freq) / 1000.0}]

   set_parameter_value "${m_param_prefix}_TINIT_CK"       [::altera_emif::ip_top::util::ns_to_tck $mem_tinit_ns $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRAS_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_tras_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRCD_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_trcd_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRP_CYC"        [::altera_emif::ip_top::util::ns_to_tck $mem_trp_ns   $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TRFC_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_trfc_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TWR_CYC"        [::altera_emif::ip_top::util::ns_to_tck $mem_twr_ns   $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TFAW_CYC"       [::altera_emif::ip_top::util::ns_to_tck $mem_tfaw_ns  $mem_clk_ns]
   set_parameter_value "${m_param_prefix}_TREFI_CYC"      [::altera_emif::ip_top::util::ns_to_tck $mem_trefi_ns $mem_clk_ns]

   return 1

}
proc ::altera_emif::ip_top::mem::ddr3::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set atcl_enum [enum_data [get_parameter_value "${m_param_prefix}_ATCL_ENUM"] VALUE]
   set atcl_cyc  [expr {($atcl_enum == 0) ? 0 : ([get_parameter_value "${m_param_prefix}_TCL"] - $atcl_enum)}]

   set ddr3_bl_enum [get_parameter_value "${m_param_prefix}_BL_ENUM"]
   if {$ddr3_bl_enum == "DDR3_BL_BL8"} {
      set ddr3_bl_val 8
   } elseif {$ddr3_bl_enum == "DDR3_BL_BC4"} {
      set ddr3_bl_val 4
   } else {
      set ddr3_bl_val -1
   }

   set_parameter_value MEM_FORMAT_ENUM             [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set_parameter_value MEM_READ_LATENCY            [expr {[get_parameter_value "${m_param_prefix}_TCL"] + $atcl_cyc}]
   set_parameter_value MEM_WRITE_LATENCY           [expr {[get_parameter_value "${m_param_prefix}_WTCL"] + $atcl_cyc}]
   set_parameter_value MEM_DATA_MASK_EN            [get_parameter_value "${m_param_prefix}_DM_EN"]
   set_parameter_value MEM_NUM_OF_LOGICAL_RANKS    [get_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"]
   set_parameter_value MEM_BURST_LENGTH            $ddr3_bl_val

   return 1
}

proc ::altera_emif::ip_top::mem::ddr3::_derive_mode_register_parameters {} {

   variable m_param_prefix

   set mem_bl                [get_parameter_value "${m_param_prefix}_BL_ENUM"]
   set mem_bt                [get_parameter_value "${m_param_prefix}_BT_ENUM"]
   set mem_tcl               [get_parameter_value "${m_param_prefix}_TCL"    ]
   set mem_pd                [get_parameter_value "${m_param_prefix}_PD_ENUM"]
   set mem_dll_en            [get_parameter_value "${m_param_prefix}_DLL_EN"]
   set mem_rtt_nom           [get_parameter_value "${m_param_prefix}_RTT_NOM_ENUM"]
   set mem_drv_str           [get_parameter_value "${m_param_prefix}_DRV_STR_ENUM"]
   set mem_atcl              [get_parameter_value "${m_param_prefix}_ATCL_ENUM"]
   set mem_wtcl              [get_parameter_value "${m_param_prefix}_WTCL"]
   set mem_asr               [get_parameter_value "${m_param_prefix}_ASR_ENUM"]
   set mem_srt               [get_parameter_value "${m_param_prefix}_SRT_ENUM"]
   set mem_rtt_wr            [get_parameter_value "${m_param_prefix}_RTT_WR_ENUM"]
   set mem_twr_ns            [get_parameter_value "${m_param_prefix}_TWR_NS"]
   set mem_clk_freq_mhz      [get_parameter_value "PHY_DDR3_MEM_CLK_FREQ_MHZ"]

   set mem_asr_enum          [enum_data $mem_asr MRS]
   set mem_srt_enum          [enum_data $mem_srt MRS]

   set twr_cyc     [expr {int(ceil($mem_twr_ns / (1000.0 / $mem_clk_freq_mhz)))}]
   set twr_cyc_min [enum_data DDR3_TWR_CYC_RANGE_MIN VALUE]
   set twr_cyc_max [enum_data DDR3_TWR_CYC_RANGE_MAX VALUE]

   if { $twr_cyc < $twr_cyc_min } {
      set twr_cyc $twr_cyc_min
   } elseif { $twr_cyc > $twr_cyc_max } {
      set twr_cyc $twr_cyc_max
   }

   set mem_wr_mr 0
   if { $twr_cyc <= 8 } {
      set mem_wr_mr [expr {$twr_cyc - 4}]
   } else {
      set mem_wr_mr [expr {int(ceil(1.0 * $twr_cyc / 2))}]
   }
   set mem_wr_mr  [expr {$mem_wr_mr & 7}]


   set mr0 0
   set mr0 [set_bits $mr0 0 2   [enum_data $mem_bl MRS]]                              
   set mr0 [set_bits $mr0 2 1   [expr {(($mem_tcl - 4) >> 3) & 1}]]                   
   set mr0 [set_bits $mr0 3 1   [enum_data $mem_bt MRS]]                              
   set mr0 [set_bits $mr0 4 3   [expr {$mem_tcl - 4}]]                                
   set mr0 [set_bits $mr0 7 1   0]                                                    
   set mr0 [set_bits $mr0 8 1   0]                                                    
   set mr0 [set_bits $mr0 9 3   $mem_wr_mr]                                           
   set mr0 [set_bits $mr0 12 1  [enum_data $mem_pd MRS]]                              
   set mr1 [set_bits $mr0 16 3  0]                                                    

   set_parameter_value "${m_param_prefix}_MR0"                $mr0

   set mr1 0
   set mr1 [set_bits $mr1 0 1   [expr {$mem_dll_en ? 0 : 1}]]                         
   set mr1 [set_bits $mr1 1 1   [enum_data $mem_drv_str MRS]]                         
   set mr1 [set_bits $mr1 2 1   [expr {[enum_data $mem_rtt_nom MRS] & 1}]]            
   set mr1 [set_bits $mr1 3 2   [enum_data $mem_atcl MRS]]                            
   set mr1 [set_bits $mr1 5 1   [expr {(([enum_data $mem_drv_str MRS]) >> 1) & 1}]]   
   set mr1 [set_bits $mr1 6 1   [expr {(([enum_data $mem_rtt_nom MRS]) >> 1) & 1}]]   
   set mr1 [set_bits $mr1 7 1   0]                                                    
   set mr1 [set_bits $mr1 8 1   0]                                                    
   set mr1 [set_bits $mr1 9 1   [expr {(([enum_data $mem_rtt_nom MRS]) >> 2) & 1}]]   
   set mr1 [set_bits $mr1 10 1  0]                                                    
   set mr1 [set_bits $mr1 11 1  0]                                                    
   set mr1 [set_bits $mr1 12 1  0]                                                    
   set mr1 [set_bits $mr1 16 3  1]                                                    

   set_parameter_value "${m_param_prefix}_MR1"      $mr1

   set mr2 0
   set mr2 [set_bits $mr2 3 3  [expr {$mem_wtcl - 5}]]                                
   set mr2 [set_bits $mr2 6 1  $mem_asr_enum]                                         
   set mr2 [set_bits $mr2 7 1  $mem_srt_enum]                                         
   set mr2 [set_bits $mr2 8 1  0]                                                     
   set mr2 [set_bits $mr2 9 2  [enum_data $mem_rtt_wr MRS]]                           
   set mr2 [set_bits $mr2 16 3 2]                                                     

   set_parameter_value "${m_param_prefix}_MR2"      $mr2

   set mr3 0
   set mr3 [set_bits $mr3 0 2 0]                                                      
   set mr3 [set_bits $mr3 2 1 0]                                                      
   set mr3 [set_bits $mr3 16 3 3]                                                     
   set_parameter_value "${m_param_prefix}_MR3"      $mr3

   if {$mem_asr_enum == 1 && $mem_srt_enum == 1} {
      post_ipgen_e_msg MSG_DDR3_ILLEGAL_SELF_REFRESH_OPERATION
   }
}

proc ::altera_emif::ip_top::mem::ddr3::_validate_and_derive_ttl_width_parameters {} {

   variable m_param_prefix

   set ping_pong_en          [get_parameter_value "PHY_DDR3_PING_PONG_EN"]
   set mult_fact             [expr {$ping_pong_en ? 2 : 1}]

   set ttl_dqs_width             [expr {[get_parameter_value "${m_param_prefix}_DQS_WIDTH"] * $mult_fact}]
   set ttl_dq_width              [expr {[get_parameter_value "${m_param_prefix}_DQ_WIDTH"] * $mult_fact}]
   set ttl_dm_width              [expr {[get_parameter_value "${m_param_prefix}_DM_WIDTH"] * $mult_fact}]
   set ttl_cs_width              [expr {[get_parameter_value "${m_param_prefix}_CS_WIDTH"] * $mult_fact}]
   set ttl_ck_width              [expr {[get_parameter_value "${m_param_prefix}_CK_WIDTH"] }]
   set ttl_cke_width             [expr {[get_parameter_value "${m_param_prefix}_CKE_WIDTH"] * $mult_fact}]
   set ttl_odt_width             [expr {[get_parameter_value "${m_param_prefix}_ODT_WIDTH"] * $mult_fact}]
   set ttl_bank_addr_width       [get_parameter_value "${m_param_prefix}_BANK_ADDR_WIDTH"]
   set ttl_addr_width            [get_parameter_value "${m_param_prefix}_ADDR_WIDTH"]
   set ttl_rm_width              [get_parameter_value "${m_param_prefix}_RM_WIDTH"]
   set ttl_num_of_dimms          [expr {[get_parameter_value "${m_param_prefix}_NUM_OF_DIMMS"] * $mult_fact}]
   set ttl_num_of_physical_ranks [expr {[get_parameter_value "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS"] * $mult_fact}]
   set ttl_num_of_logical_ranks  [expr {[get_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"] * $mult_fact}]

   set_parameter_value "${m_param_prefix}_TTL_DQS_WIDTH"              $ttl_dqs_width
   set_parameter_value "${m_param_prefix}_TTL_DQ_WIDTH"               $ttl_dq_width
   set_parameter_value "${m_param_prefix}_TTL_DM_WIDTH"               $ttl_dm_width
   set_parameter_value "${m_param_prefix}_TTL_CS_WIDTH"               $ttl_cs_width
   set_parameter_value "${m_param_prefix}_TTL_CK_WIDTH"               $ttl_ck_width
   set_parameter_value "${m_param_prefix}_TTL_CKE_WIDTH"              $ttl_cke_width
   set_parameter_value "${m_param_prefix}_TTL_ODT_WIDTH"              $ttl_odt_width
   set_parameter_value "${m_param_prefix}_TTL_BANK_ADDR_WIDTH"        $ttl_bank_addr_width
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


proc ::altera_emif::ip_top::mem::ddr3::_init {} {
}

::altera_emif::ip_top::mem::ddr3::_init
