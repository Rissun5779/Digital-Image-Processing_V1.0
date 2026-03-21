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


package provide altera_emif::ip_top::mem::lpddr3 0.1

package require altera_emif::util::messaging
package require altera_emif::util::qini
package require altera_emif::util::hwtcl_utils
package require altera_emif::util::math
package require altera_emif::util::enums
package require altera_emif::util::device_family

namespace eval ::altera_emif::ip_top::mem::lpddr3:: {

   namespace import ::altera_emif::util::messaging::*
   namespace import ::altera_emif::util::qini::*
   namespace import ::altera_emif::util::enums::*
   namespace import ::altera_emif::util::math::*
   namespace import ::altera_emif::util::hwtcl_utils::*
   namespace import ::altera_emif::util::device_family::*


   variable m_param_prefix "MEM_LPDDR3"
}


proc ::altera_emif::ip_top::mem::lpddr3::create_parameters {is_top_level_component} {

   variable m_param_prefix

   add_user_param     "${m_param_prefix}_DQ_WIDTH"                integer    32                  {16:32}
   add_user_param     "${m_param_prefix}_DISCRETE_CS_WIDTH"       integer    1                   [list 1 2]
   add_user_param     "${m_param_prefix}_CK_WIDTH"                integer    1                   [list 1 2]
   add_user_param     "${m_param_prefix}_DM_EN"                   boolean    true                ""
   add_user_param     "${m_param_prefix}_ROW_ADDR_WIDTH"          integer    15                  [list 14 15]
   add_user_param     "${m_param_prefix}_COL_ADDR_WIDTH"          integer    10                  [list 10 11 12]
   add_user_param     "${m_param_prefix}_BANK_ADDR_WIDTH"         integer    3                   [list 3]
   

   add_derived_param  "${m_param_prefix}_DQS_WIDTH"               integer    1                   true
   add_derived_param  "${m_param_prefix}_DM_WIDTH"                integer    1                   false
   add_derived_param  "${m_param_prefix}_CS_WIDTH"                integer    1                   false
   add_derived_param  "${m_param_prefix}_CKE_WIDTH"               integer    1                   false
   add_derived_param  "${m_param_prefix}_ODT_WIDTH"               integer    1                   false
   add_derived_param  "${m_param_prefix}_ADDR_WIDTH"              integer    10                  false
   add_derived_param  "${m_param_prefix}_DQ_PER_DQS"              integer    8                   false
   add_derived_param  "${m_param_prefix}_FORMAT_ENUM"             string     MEM_FORMAT_DISCRETE false
   
   add_derived_param  "${m_param_prefix}_MR1"                     integer    0                   false
   add_derived_param  "${m_param_prefix}_MR2"                     integer    0                   false
   add_derived_param  "${m_param_prefix}_MR3"                     integer    0                   false
   add_derived_param  "${m_param_prefix}_MR11"                    integer    0                   false

   add_user_param     "${m_param_prefix}_BL"                string     LPDDR3_BL_BL8                [enum_dropdown_entries LPDDR3_BL]
   add_user_param     "${m_param_prefix}_DATA_LATENCY"      string     LPDDR3_DL_RL12_WL6           [enum_dropdown_entries LPDDR3_DL]

   add_user_param     "${m_param_prefix}_DRV_STR"           string     LPDDR3_DRV_STR_40D_40U       [enum_dropdown_entries LPDDR3_DRV_STR]
   add_user_param     "${m_param_prefix}_DQODT"             string     LPDDR3_DQODT_DISABLE         [enum_dropdown_entries LPDDR3_DQODT]
   add_user_param     "${m_param_prefix}_PDODT"             string     LPDDR3_PDODT_DISABLED        [enum_dropdown_entries LPDDR3_PDODT]

   add_derived_param  "${m_param_prefix}_WLSELECT"              string     "Set A"                  true
   add_derived_param  "${m_param_prefix}_NWR"                   string     LPDDR3_NWR_NWR12         false

   add_derived_param  "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"  integer    1                        false
   add_derived_param  "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS" integer    1                        false

   add_user_param     "${m_param_prefix}_USE_DEFAULT_ODT"   boolean        true                                           ""
   add_user_param     "${m_param_prefix}_R_ODTN_1X1"        string_list    [list "Rank 0"]                                ""
   add_user_param     "${m_param_prefix}_R_ODT0_1X1"        string_list    [enum_data LPDDR3_DEFAULT_RODT_1X1_ODT0 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_1X1"        string_list    [list "Rank 0"]                                ""
   add_user_param     "${m_param_prefix}_W_ODT0_1X1"        string_list    [enum_data LPDDR3_DEFAULT_WODT_1X1_ODT0 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_R_ODTN_2X2"        string_list    [list "Rank 0" "Rank 1"]                       ""
   add_user_param     "${m_param_prefix}_R_ODT0_2X2"        string_list    [enum_data LPDDR3_DEFAULT_RODT_2X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_2X2"        string_list    [enum_data LPDDR3_DEFAULT_RODT_2X2_ODT1 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_2X2"        string_list    [list "Rank 0" "Rank 1"]                       ""
   add_user_param     "${m_param_prefix}_W_ODT0_2X2"        string_list    [enum_data LPDDR3_DEFAULT_WODT_2X2_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_2X2"        string_list    [enum_data LPDDR3_DEFAULT_WODT_2X2_ODT1 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_R_ODTN_4X4"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]     ""
   add_user_param     "${m_param_prefix}_R_ODT0_4X4"        string_list    [enum_data LPDDR3_DEFAULT_RODT_4X4_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT1_4X4"        string_list    [enum_data LPDDR3_DEFAULT_RODT_4X4_ODT1 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT2_4X4"        string_list    [enum_data LPDDR3_DEFAULT_RODT_4X4_ODT2 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_R_ODT3_4X4"        string_list    [enum_data LPDDR3_DEFAULT_RODT_4X4_ODT3 VALUE] [list "off"  "on"]

   add_user_param     "${m_param_prefix}_W_ODTN_4X4"        string_list    [list "Rank 0" "Rank 1" "Rank 2" "Rank 3"]     ""
   add_user_param     "${m_param_prefix}_W_ODT0_4X4"        string_list    [enum_data LPDDR3_DEFAULT_WODT_4X4_ODT0 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT1_4X4"        string_list    [enum_data LPDDR3_DEFAULT_WODT_4X4_ODT1 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT2_4X4"        string_list    [enum_data LPDDR3_DEFAULT_WODT_4X4_ODT2 VALUE] [list "off"  "on"]
   add_user_param     "${m_param_prefix}_W_ODT3_4X4"        string_list    [enum_data LPDDR3_DEFAULT_WODT_4X4_ODT3 VALUE] [list "off"  "on"]

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

   add_user_param     "${m_param_prefix}_SPEEDBIN_ENUM"    string     LPDDR3_SPEEDBIN_1600 [enum_dropdown_entries LPDDR3_SPEEDBIN] ""                 ""
   add_user_param     "${m_param_prefix}_TIS_PS"           integer    75                   {0:5000}                                "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TIS_AC_MV"        integer    150                  {150 135}                               ""                 "mV"
   add_user_param     "${m_param_prefix}_TIH_PS"           integer    100                  {0:5000}                                "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TIH_DC_MV"        integer    100                  {100}                                   ""                 "mV"
   add_user_param     "${m_param_prefix}_TDS_PS"           integer    75                   {0:5000}                                "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDS_AC_MV"        integer    150                  {150 135}                               ""                 "mV"
   add_user_param     "${m_param_prefix}_TDH_PS"           integer    100                  {0:5000}                                "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDH_DC_MV"        integer    100                  {100}                                   ""                 "mV"
   add_user_param     "${m_param_prefix}_TDQSQ_PS"         integer    135                  {-5000:5000}                            "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TQH_CYC"          float      0.38                 ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TDQSCKDL"         integer    614                  {0:5000}                                "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDQSS_CYC"        float      1.25                 ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TQSH_CYC"         float      0.38                 ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TDSH_CYC"         float      0.2                  ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TWLS_PS"          float      175                  ""                                      "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TWLH_PS"          float      175                  ""                                      "picoseconds"      ""
   add_user_param     "${m_param_prefix}_TDSS_CYC"         float      0.2                  ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TINIT_US"         integer    500                  ""                                      "Microseconds"     ""
   add_user_param     "${m_param_prefix}_TMRR_CK_CYC"      integer    4                    ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TMRW_CK_CYC"      integer    10                   ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TRAS_NS"          float      42.5                 ""                                      "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRCD_NS"          float      18                   ""                                      "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRP_NS"           float      18                   ""                                      "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TREFI_US"         float      3.9                  ""                                      "Microseconds"     ""
   add_user_param     "${m_param_prefix}_TRFC_NS"          float      210                  ""                                      "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TWR_NS"           float      15                   ""                                      "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TWTR_CYC"         integer    6                    {1:8}                                   "Cycles"           ""
   add_user_param     "${m_param_prefix}_TFAW_NS"          float      50                   ""                                      "Nanoseconds"      ""
   add_user_param     "${m_param_prefix}_TRRD_CYC"         integer    8                    ""                                      "Cycles"           ""
   add_user_param     "${m_param_prefix}_TRTP_CYC"         integer    6                    ""                                      "Cycles"           ""


   add_derived_param  "${m_param_prefix}_TINIT_CK"         integer    499       false
   add_derived_param  "${m_param_prefix}_TDQSCK_DERV_PS"   integer    2         false
   add_derived_param  "${m_param_prefix}_TDQSCKDS"         integer    220       false
   add_derived_param  "${m_param_prefix}_TDQSCKDM"         integer    511       false
   add_derived_param  "${m_param_prefix}_TDQSCK_PS"        integer    5500      false
   add_derived_param  "${m_param_prefix}_TRAS_CYC"         integer    34        false
   add_derived_param  "${m_param_prefix}_TRCD_CYC"         integer    17        false
   add_derived_param  "${m_param_prefix}_TRP_CYC"          integer    17        false
   add_derived_param  "${m_param_prefix}_TRFC_CYC"         integer    168       false
   add_derived_param  "${m_param_prefix}_TWR_CYC"          integer    12        false
   add_derived_param  "${m_param_prefix}_TFAW_CYC"         integer    40        false
   add_derived_param  "${m_param_prefix}_TREFI_CYC"        integer    3120      false
   add_derived_param  "${m_param_prefix}_TRL_CYC"          integer    10        false
   add_derived_param  "${m_param_prefix}_TWL_CYC"          integer    6         false

   return 1
}

proc ::altera_emif::ip_top::mem::lpddr3::set_family_specific_defaults {family_enum base_family_enum is_hps} {
   variable m_param_prefix

   if {$base_family_enum == "FAMILY_ARRIA10"} {
      if {$is_hps} {
         set_param_default "${m_param_prefix}_DQ_WIDTH" 32
      }
   } elseif {$base_family_enum == "FAMILY_STRATIX10"} {
      if {$is_hps} {
         set_param_default "${m_param_prefix}_DQ_WIDTH" 32
      }
   }

   return 1
}

proc ::altera_emif::ip_top::mem::lpddr3::add_display_items {tabs} {
   variable m_param_prefix

   set mem_params_tab [lindex $tabs 0]
   set mem_io_tab     [lindex $tabs 1]
   set mem_timing_tab [lindex $tabs 2]

   set topology_grp [get_string GRP_MEM_TOPOLOGY_NAME]
   set lat_grp      [get_string GRP_MEM_LATENCY_NAME]
   set mrs_grp      [get_string GRP_MEM_MRS_NAME]
   set odt_grp      [get_string GRP_MEM_ODT_NAME]

   add_param_to_gui $topology_grp "${m_param_prefix}_DQ_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_DQS_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_CK_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_DISCRETE_CS_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_ROW_ADDR_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_COL_ADDR_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_BANK_ADDR_WIDTH"
   add_param_to_gui $topology_grp "${m_param_prefix}_DM_EN"
   
   add_param_to_gui $lat_grp "${m_param_prefix}_DATA_LATENCY"
   add_param_to_gui $lat_grp "${m_param_prefix}_BL"
   add_param_to_gui $lat_grp "${m_param_prefix}_WLSELECT"


   
   set io_grp       [get_string GRP_MEM_IO_NAME]
   set odt_grp      [get_string GRP_MEM_ODT_NAME]
   
   add_param_to_gui $io_grp "${m_param_prefix}_DRV_STR"
   add_param_to_gui $io_grp "${m_param_prefix}_DQODT"
   add_param_to_gui $io_grp "${m_param_prefix}_PDODT"
   
   add_display_item $mem_io_tab $odt_grp GROUP
   
   add_param_to_gui $odt_grp "${m_param_prefix}_USE_DEFAULT_ODT"

   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_rtbl_id1" "<html><b>ODT Assertion Table during Read Accesses</b><br>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_rtbl_id2" "<html>Set the value to on to assert a given ODT signal when reading from a specific rank<br>"
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_1x1_rtbl" [list table fixed_size rows:2]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_2x2_rtbl" [list table fixed_size rows:3]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_4x4_rtbl" [list table fixed_size rows:5]

   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_wtbl_id3" "<html><b>ODT Assertion Table during Write Accesses</b><br>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_odt_wtbl_id4" "<html>Set the value to on to assert a given ODT signal when writing to a specific rank<br>"
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_1x1_wtbl" [list table fixed_size rows:2]
   add_table_to_gui $odt_grp "${m_param_prefix}_odt_2x2_wtbl" [list table fixed_size rows:3]
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
   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_rtbl_id4" "<html>This matrix is derived based on settings for DQ ODT and the write ODT assertion table."
   add_table_to_gui $odt_grp "${m_param_prefix}_derived_odt_rtbl" [list table fixed_size rows:5]
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODTN"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT0"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT1"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT2"
   add_param_to_table "${m_param_prefix}_derived_odt_rtbl" "${m_param_prefix}_R_DERIVED_ODT3"

   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_wtbl_id3" "<html><b>Derived ODT Matrix for Write Accesses</b>"
   add_text_to_gui  $odt_grp "${m_param_prefix}_derived_odt_wtbl_id4" "<html>This matrix is derived based on settings for DQ ODT and the write ODT assertion table."
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
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TMRR_CK_CYC"
   add_param_to_gui $timing_sb_grp "${m_param_prefix}_TMRW_CK_CYC"
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

proc ::altera_emif::ip_top::mem::lpddr3::validate {} {

   set odt_grp [get_string GRP_MEM_ODT_NAME]
   set_display_item_property $odt_grp VISIBLE true

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


proc ::altera_emif::ip_top::mem::lpddr3::_validate_memory_parameters {} {

   variable m_param_prefix

   set row_addr_width         [get_parameter_value "${m_param_prefix}_ROW_ADDR_WIDTH"]
   set col_addr_width         [get_parameter_value "${m_param_prefix}_COL_ADDR_WIDTH"]
   set dq_width               [get_parameter_value "${m_param_prefix}_DQ_WIDTH"]
   set dq_per_dqs             [get_parameter_value "${m_param_prefix}_DQ_PER_DQS"]
   set dm_en                  [get_parameter_value "${m_param_prefix}_DM_EN"]
   set discrete_cs_width      [get_parameter_value "${m_param_prefix}_DISCRETE_CS_WIDTH"]

   set addr_width            [expr $row_addr_width + $col_addr_width]

   set_parameter_property "${m_param_prefix}_DISCRETE_CS_WIDTH"       VISIBLE true

   if {[expr {$dq_width % 16}] != 0 || $dq_width <= 0} {
      set dqs_width 1
      post_ipgen_e_msg MSG_LPDDR3_DQ_WIDTH_NOT_DIVISIBLE_BY_SMALLEST_PART_WIDTH [list 16]
   } else {
      set dqs_width [expr {$dq_width / $dq_per_dqs}]
      set_parameter_value "${m_param_prefix}_DQS_WIDTH" $dqs_width
   }

   set dm_width [expr {$dm_en ? $dqs_width : 0}]
   set_parameter_value "${m_param_prefix}_DM_WIDTH" $dm_width

   set_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"  $discrete_cs_width
   set_parameter_value "${m_param_prefix}_NUM_OF_PHYSICAL_RANKS" $discrete_cs_width
   set_parameter_value "${m_param_prefix}_CS_WIDTH"              $discrete_cs_width
   set_parameter_value "${m_param_prefix}_CKE_WIDTH"             $discrete_cs_width
   set_parameter_value "${m_param_prefix}_ODT_WIDTH"             $discrete_cs_width

   set_parameter_value "MEM_HAS_SIM_SUPPORT" true

   set_display_item_property [get_string DDR3_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR3_LRDIMM_TXT_NAME]        VISIBLE false
   set_display_item_property [get_string DDR4_RDIMM_TXT_NAME]         VISIBLE false
   set_display_item_property [get_string DDR4_LRDIMM_TXT_NAME]        VISIBLE false
}

proc ::altera_emif::ip_top::mem::lpddr3::_derive_odt_parameters {} {

   variable m_param_prefix
   
   
   
   set odt_width              [get_parameter_value "${m_param_prefix}_ODT_WIDTH"]
   set num_ranks              [get_parameter_value "${m_param_prefix}_CS_WIDTH"]
   
   set target_name [list]
   set num_odt_targets $num_ranks
   for {set target 0} {$target < 4} {incr target} {
      if {$target < $num_ranks} {
         lappend target_name "Rank ${target}"
      } else {
         lappend target_name "-"
      }
   }

   if { (!(    ($num_odt_targets == 1 && $odt_width == 1) \
            || ($num_odt_targets == 2 && $odt_width == 2) \
            || ($num_odt_targets == 4 && $odt_width == 4)))} {
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
   set nominal_odt_enum   [get_parameter_value "${m_param_prefix}_DQODT"]
   set drive_odt_enum   [get_parameter_value "${m_param_prefix}_DRV_STR"]
   set nominal_odt_name   [enum_data $nominal_odt_enum UI_NAME]
   set drive_odt_name   [enum_data $drive_odt_enum UI_NAME]
   set use_nominal_odt    [expr {![enum_same $nominal_odt_enum LPDDR3_DQODT_DISABLE]}]
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
            set rd_odt [enum_data "LPDDR3_DEFAULT_RODT_${odt_tbl_ucase}_ODT${odt_pin}" VALUE]
            set wr_odt [enum_data "LPDDR3_DEFAULT_WODT_${odt_tbl_ucase}_ODT${odt_pin}" VALUE]
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

               if {$target == $odt_pin} {
                  set intersect 1
               }
               
               set target_cs $target

               if { $intersect } {
                  set rd_odt_setting "(Drive) $drive_odt_name"
               } else {
                  switch $rd_odt_val {
                     "on" {
                        set rd_odt_setting $nominal_odt_name
                        set pos [expr {$target_cs * 4 + $odt_pin}]
                        set ctrl_odt_rchip [string replace $ctrl_odt_rchip end-$pos end-$pos "1"]
                        set pos [expr {$target * 4 + $odt_pin}]
                        set ctrl_odt_rrank [string replace $ctrl_odt_rrank end-$pos end-$pos "1"]
                     }
                     "off" {
                        set rd_odt_setting [enum_data LPDDR3_DQODT_DISABLE UI_NAME]
                     }
                  }
               }

               if {$use_nominal_odt} {
                  switch $wr_odt_val {
                     "on" {
                        set wr_odt_setting "$nominal_odt_name"
                        set pos [expr {$target_cs * 4 + $odt_pin}]
                        set ctrl_odt_wchip [string replace $ctrl_odt_wchip end-$pos end-$pos "1"]
                        set pos [expr {$target * 4 + $odt_pin}]
                        set ctrl_odt_wrank [string replace $ctrl_odt_wrank end-$pos end-$pos "1"]
                     }
                     "off" {
                        set wr_odt_setting [enum_data LPDDR3_DQODT_DISABLE UI_NAME]
                     }
                  }
               } else {
                  set wr_odt_setting [enum_data LPDDR3_DQODT_DISABLE UI_NAME]
               }


               lappend r_target_lst $rd_odt_setting
               lappend w_target_lst $wr_odt_setting

               set seq_odt_enum [enum_data SEQ_ODT_MODE_ALWAYS_LOW VALUE]
               switch "off${wr_odt_val}" {
                  "offoff" { set seq_odt_enum [enum_data SEQ_ODT_MODE_ALWAYS_LOW         VALUE] }
                  "offon"  { set seq_odt_enum [enum_data SEQ_ODT_MODE_HIGH_ON_WRITE      VALUE] }
               }

               if { $target >= 2 } {
                  set spos [expr {16*($target-2) + 4*$odt_pin + 3}]
                  set epos [expr {16*($target-2) + 4*$odt_pin + 0}]
                  set seq_odt_hi [string replace $seq_odt_hi end-$spos end-$epos $seq_odt_enum]
               } else {
                  set spos [expr {16*$target + 4*$odt_pin + 3}]
                  set epos [expr {16*$target + 4*$odt_pin + 0}]
                  set seq_odt_lo [string replace $seq_odt_lo end-$spos end-$epos $seq_odt_enum]
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

proc ::altera_emif::ip_top::mem::lpddr3::_validate_memory_timing_parameters {} {

   variable m_param_prefix

   set ok 1

   set mem_clk_freq       [get_parameter_value PHY_LPDDR3_MEM_CLK_FREQ_MHZ]
   set io_voltage         [get_parameter_value PHY_LPDDR3_IO_VOLTAGE]
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

   set lpddr3_acdc_enum       "LPDDR3_ACDC_LPDDR3_${speedbin_value}"
   set full_speedbin_name     "LPDDR3${speedbin_ui_name}"

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
      set allowed_tis_ac_mv [enum_data $lpddr3_acdc_enum ALLOWED_TIS_AC]
      set allowed_tih_dc_mv [enum_data $lpddr3_acdc_enum ALLOWED_TIH_DC]
      set allowed_tds_ac_mv [enum_data $lpddr3_acdc_enum ALLOWED_TDS_AC]
      set allowed_tdh_dc_mv [enum_data $lpddr3_acdc_enum ALLOWED_TDH_DC]

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

proc ::altera_emif::ip_top::mem::lpddr3::_derive_memory_timing_parameters {} {

   variable m_param_prefix

   set mem_clk_freq       [get_parameter_value "PHY_LPDDR3_MEM_CLK_FREQ_MHZ" ]
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
proc ::altera_emif::ip_top::mem::lpddr3::_derive_protocol_agnostic_parameters {} {
   variable m_param_prefix

   set mem_dl              [get_parameter_value "${m_param_prefix}_DATA_LATENCY"]

   set lpddr3_bl_enum [get_parameter_value "${m_param_prefix}_BL"]
   if {$lpddr3_bl_enum == "LPDDR3_BL_BL8"} {
      set lpddr3_bl_val 8
   } else {
      set lpddr3_bl_val -1
   }

   set_parameter_value MEM_BURST_LENGTH            $lpddr3_bl_val
   set_parameter_value MEM_FORMAT_ENUM             [get_parameter_value "${m_param_prefix}_FORMAT_ENUM"]
   set_parameter_value MEM_READ_LATENCY            [enum_data $mem_dl RL]
   set_parameter_value MEM_WRITE_LATENCY           [enum_data $mem_dl WL]
   set_parameter_value MEM_DATA_MASK_EN            [get_parameter_value "${m_param_prefix}_DM_EN"]
   set_parameter_value MEM_NUM_OF_LOGICAL_RANKS    [get_parameter_value "${m_param_prefix}_NUM_OF_LOGICAL_RANKS"]

   return 1
}

proc ::altera_emif::ip_top::mem::lpddr3::_derive_mode_register_parameters {} {

   variable m_param_prefix

   set mem_bl                [get_parameter_value "${m_param_prefix}_BL"]
   set mem_twr_cyc           [get_parameter_value "${m_param_prefix}_TWR_CYC"]
   set mem_dl                [get_parameter_value "${m_param_prefix}_DATA_LATENCY"]
   set mem_dqodt             [get_parameter_value "${m_param_prefix}_DQODT"]
   set mem_pdodt             [get_parameter_value "${m_param_prefix}_PDODT"]
   set mem_drvstr            [get_parameter_value "${m_param_prefix}_DRV_STR"]
   set mem_clk_freq          [get_parameter_value PHY_LPDDR3_MEM_CLK_FREQ_MHZ]

   if { [enum_data $mem_dl SET_B] } {
      set_parameter_value "${m_param_prefix}_WLSELECT" "Set B"
   } else {
      set_parameter_value "${m_param_prefix}_WLSELECT" "Set A"
   }

   foreach n [list 3 6 8 9 10 11 12 14 16] {
      if {$mem_twr_cyc <= $n || $n == 16} {
         set mem_nwr "LPDDR3_NWR_NWR$n"
         set_parameter_value "${m_param_prefix}_NWR" $mem_nwr 
         break
      }
   }

   set mr1 0
   set mr1 [set_bits $mr1 0  4   0]                              ;
   set mr1 [set_bits $mr1 4  8   1]                              ;
   set mr1 [set_bits $mr1 12 3   [enum_data $mem_bl MRS]]        ;
   set mr1 [set_bits $mr1 15 2   0]                              ;
   set mr1 [set_bits $mr1 17 3   [enum_data $mem_nwr MRS]]       ;

   set_parameter_value "${m_param_prefix}_MR1"  $mr1

   set mr2 0
   set mr2 [set_bits $mr2 0  4   0]                              ;
   set mr2 [set_bits $mr2 4  8   2]                              ;
   set mr2 [set_bits $mr2 12 4   [enum_data $mem_dl MRS]]        ;
   set mr2 [set_bits $mr2 16 1   [enum_data $mem_nwr NWRE]]      ;
   set mr2 [set_bits $mr2 17 1   0]                              ;
   set mr2 [set_bits $mr2 18 1   [enum_data $mem_dl SET_B]]      ;
   set mr2 [set_bits $mr2 19 1   0]                              ;
   
   set_parameter_value "${m_param_prefix}_MR2"  $mr2

   set mr3 0
   set mr3 [set_bits $mr3 0  4   0]                              ;
   set mr3 [set_bits $mr3 4  8   3]                              ;
   set mr3 [set_bits $mr3 12 4   [enum_data $mem_drvstr MRS]]    ;
   set mr3 [set_bits $mr3 16 4   0]                              ;

   set_parameter_value "${m_param_prefix}_MR3"  $mr3

   set mr11 0
   set mr11 [set_bits $mr11 0  4   0]                            ;
   set mr11 [set_bits $mr11 4  8   11]                           ;
   set mr11 [set_bits $mr11 12 2   [enum_data $mem_dqodt MRS]]   ;
   set mr11 [set_bits $mr11 14 1   [enum_data $mem_pdodt MRS]]   ;
   set mr11 [set_bits $mr11 15 5   0]

   set_parameter_value "${m_param_prefix}_MR11"  $mr11

   if {int($mem_clk_freq) > [enum_data $mem_dl FMAX_MHZ]} {
      post_ipgen_e_msg MSG_LPDDR3_FREQ_GT_FMAX_FOR_RL [list [enum_data $mem_dl FMAX_MHZ] [enum_data $mem_dl RL]]
   }
}

proc ::altera_emif::ip_top::mem::lpddr3::_validate_and_derive_ttl_width_parameters {} {

   variable m_param_prefix
   
   set ttl_dq_width              [get_parameter_value "${m_param_prefix}_DQ_WIDTH"]
   set ttl_dqs_width             [get_parameter_value "${m_param_prefix}_DQS_WIDTH"]
  
   set_parameter_value MEM_TTL_DATA_WIDTH           $ttl_dq_width
   set_parameter_value MEM_TTL_NUM_OF_READ_GROUPS   $ttl_dqs_width
   set_parameter_value MEM_TTL_NUM_OF_WRITE_GROUPS  $ttl_dqs_width
}


proc ::altera_emif::ip_top::mem::lpddr3::_init {} {
}

::altera_emif::ip_top::mem::lpddr3::_init
