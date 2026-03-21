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


# package: altera_phylite::util::enum_defs
#
# The package contains enum definitions.
#
package provide altera_phylite::util::enum_defs 0.1

################################################################################
###                          TCL INCLUDES                                   ###
################################################################################
package require altera_emif::util::enums

# Load all required properties files
load_strings common_gui.properties

################################################################################
###                          TCL NAMESPACE                                   ###
################################################################################
namespace eval ::altera_phylite::util::enum_defs:: {
   # Import functions into namespace
   namespace import ::altera_emif::util::enums::*

   # Export functions

   # Package variables
}

################################################################################
###                          TCL PROCEDURES                                  ###
################################################################################

# proc: def_enums
#
# Define enums
#
# parameters:
#
# returns:
#
proc ::altera_phylite::util::enum_defs::def_enums {} {


   #############################
   # Families
   #############################
   def_enum_type PHYLITE_FAMILY                                        {     UI_NAME         ARCH_COMPONENT            BASE_FAMILY_ENUM     QSYS_NAMES         MEGAFUNC_NAME    DEFAULT_PART_FOR_ED  }
   def_enum      PHYLITE_FAMILY      PHYLITE_FAMILY_INVALID                   [list ""              ""                        FAMILY_INVALID       [list ]            ""               ""                   ]
   def_enum      PHYLITE_FAMILY      PHYLITE_FAMILY_ARRIA10                   [list "Arria 10"      "altera_phylite_arch_nf"  FAMILY_ARRIAVI       [list ARRIA10]     "ARRIA 10"       "10AX115N1F40I1SGES"]
   def_enum      PHYLITE_FAMILY      PHYLITE_FAMILY_STRATIX10                 [list "Stratix 10"    "altera_phylite_arch_nd"  FAMILY_STRATIX10     [list STRATIX10]   "STRATIX 10"     "ND_REAL_LAB_PART1"]        
   
   #############################
   # Core Rate
   #############################
   def_enum_type RATE_IN                                                   {     UI_NAME    AFI_RATIO}
   def_enum      RATE_IN                  RATE_IN_INVALID                     [list ""         0        ]   
   def_enum      RATE_IN                  RATE_IN_FULL                        [list "Full"     1        ]
   def_enum      RATE_IN                  RATE_IN_HALF                        [list "Half"     2        ]
   def_enum      RATE_IN                  RATE_IN_QUARTER                     [list "Quarter"  4        ] 

   #############################
   # Pin Configurations
   #############################
   def_enum_type PIN_TYPE                             {     UI_NAME                       }
   def_enum      PIN_TYPE               INPUT         [list "Input"                       ]
   def_enum      PIN_TYPE               OUTPUT        [list "Output"                      ]
   def_enum      PIN_TYPE               BIDIR         [list "Bidirectional"               ]
      
   #############################
   # DDR mode
   #############################
   def_enum_type DDR_SDR_MODE                         {     UI_NAME           }
   def_enum      DDR_SDR_MODE           DDR           [list "DDR"]
   def_enum      DDR_SDR_MODE           SDR           [list "SDR"]

   #############################
   # Strobe Configurations
   #############################
   def_enum_type STROBE_CONFIG               {     UI_NAME                       }
   def_enum      STROBE_CONFIG SINGLE_ENDED  [list "Single ended"                ]
   def_enum      STROBE_CONFIG DIFFERENTIAL  [list "Differential"                ]
   def_enum      STROBE_CONFIG COMPLEMENTARY [list "Complementary"               ]
      
   #############################
   # Data Configurations
   #############################
   def_enum_type DATA_CONFIG               {     UI_NAME                       }
   def_enum      DATA_CONFIG SGL_ENDED     [list "Single ended"                ]
   def_enum      DATA_CONFIG DIFF  	   [list "Differential"                ]
  
   #############################
   # Strobe Configurations
   #############################
   def_enum_type IOAUX_CONST                               {     VALUE }
   def_enum      IOAUX_CONST IOAUX_CONST_INTERFACE_PAR_VER [list     1 ]

   #############################
   # I/O Standards
   #############################
   # copied subset from IO_STD in emif/util/enum_defs.tcl
   def_enum_type PHYLITE_IO_STD                                                        {     QSF_NAME                             DF_IO_STD            	REF_IO_STD}
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_INVALID                   [list ""                                   IO_STD_INVALID       ""]

   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_12                   [list "SSTL-12"                            IO_STD_DF_SSTL_12    "1.2-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_125                  [list "SSTL-125"                           IO_STD_DF_SSTL_125   "SSTL-125"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_135                  [list "SSTL-135"                           IO_STD_DF_SSTL_135   "SSTL-135"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_15                   [list "SSTL-15"                            IO_STD_DF_SSTL_15    "1.5-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_15_C1                [list "SSTL-15 Class I"                    IO_STD_DF_SSTL_15_C1 "1.5-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_15_C2                [list "SSTL-15 Class II"                   IO_STD_DF_SSTL_15_C2 "1.5-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_18_C1                [list "SSTL-18 Class I"                    IO_STD_DF_SSTL_18_C1 "1.8-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_SSTL_18_C2                [list "SSTL-18 Class II"                   IO_STD_DF_SSTL_18_C2 "1.8-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_HSTL_12_C1                [list "1.2-V HSTL Class I"                 IO_STD_DF_HSTL_12_C1 "1.2-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_HSTL_12_C2                [list "1.2-V HSTL Class II"                IO_STD_DF_HSTL_12_C2 "1.2-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_HSTL_15_C1                [list "1.5-V HSTL Class I"                 IO_STD_DF_HSTL_15_C1 "1.5-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_HSTL_15_C2                [list "1.5-V HSTL Class II"                IO_STD_DF_HSTL_15_C2 "1.5-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_HSTL_18_C1                [list "1.8-V HSTL Class I"                 IO_STD_DF_HSTL_18_C1 "1.8-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_HSTL_18_C2                [list "1.8-V HSTL Class II"                IO_STD_DF_HSTL_18_C2 "1.8-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_POD_12                    [list "1.2-V POD"                          IO_STD_DF_POD_12     "1.2-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_CMOS_12                   [list "1.2-V"                              IO_STD_INVALID       "1.2-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_CMOS_15                   [list "1.5-V"                              IO_STD_INVALID       "1.5-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_CMOS_18                   [list "1.8-V"                              IO_STD_INVALID       "1.8-V"]
   def_enum      PHYLITE_IO_STD               PHYLITE_IO_STD_NONE                      [list "None"                               IO_STD_NONE          "None"]

   ##################################################################################################
   # The following entries describe the default I/O assignment settings associated with each I/O std
   # This information may be family-specific.
   # Note that IN_OCT of 0 is used to denote "No termination"
   ##################################################################################################
   def_enum_type PHYLITE_OCT_IO_STD                                      {     RZQ   RANGE_IN_OCT                               DEFAULT_IN_OCT RANGE_OUT_OCT               DEFAULT_OUT_OCT  RANGE_CURRENT_ST       }
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_125        [list 240   [list                   60    120      ]   60             [list    34 40           ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_135        [list 240   [list                   60    120      ]   60             [list    34 40           ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_15         [list 240   [list                   60    120      ]   60             [list    34 40           ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_15_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_15_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_18_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_18_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_HSTL_12_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_HSTL_12_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_HSTL_15_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_HSTL_15_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_HSTL_18_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_HSTL_18_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_SSTL_12         [list 240   [list                   60    120      ]   60             [list       40       60  ]  40               [list               ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_POD_12          [list 240   [list    34    40 48    60 80 120 240  ]   60             [list    34 40 48    60  ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_CMOS_12         [list   0   [list                                 0]    0             [list 25          50    0]   0               [list               ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_CMOS_15         [list   0   [list                                 0]    0             [list 25          50    0]   0               [list               ]  ]
   def_enum      PHYLITE_OCT_IO_STD   PHYLITE_OCT_IO_STD_CMOS_18         [list   0   [list                                 0]    0             [list 25          50    0]   0               [list               ]  ]

   def_enum_type PHYLITE_OCT_ND_IO_STD                                      {     RZQ   RANGE_IN_OCT                               DEFAULT_IN_OCT RANGE_OUT_OCT               DEFAULT_OUT_OCT  RANGE_CURRENT_ST       }
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_125        [list 240   [list       30 40       60    120      ]   60             [list    34 40           ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_135        [list 240   [list       30 40       60    120      ]   60             [list    34 40           ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_15         [list 240   [list       30 40       60    120      ]   60             [list    34 40           ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_15_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_15_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_18_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_18_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_HSTL_12_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_HSTL_12_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_HSTL_15_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_HSTL_15_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_HSTL_18_C1      [list 100   [list                50               0]    0             [list             50    0]   0               [list 4 6 8 10 12   ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_HSTL_18_C2      [list 100   [list                50               0]    0             [list 25                0]   0               [list     8       16]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_SSTL_12         [list 240   [list                   60    120      ]   60             [list       40       60  ]  40               [list               ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_POD_12          [list 240   [list    34    40 48    60 80 120 240  ]   34             [list    34 40 48    60  ]  34               [list               ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_CMOS_12         [list   0   [list                                 0]    0             [list 25          50    0]   0               [list               ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_CMOS_15         [list   0   [list                                 0]    0             [list 25          50    0]   0               [list               ]  ]
   def_enum      PHYLITE_OCT_ND_IO_STD   PHYLITE_OCT_ND_IO_STD_CMOS_18         [list   0   [list                                 0]    0             [list 25          50    0]   0               [list               ]  ]
   
   # Note: additional OCT_IO_STD enums will need to be added if/when addional I/O Standards are added

   #############################
   # Deskew Configurations
   #############################
   def_enum_type DESKEW_TYPE                             {     UI_NAME                       }
   def_enum      DESKEW_TYPE               PER_BIT_DESKEW         [list "DQ Per-Bit Deskew"          ]
   def_enum      DESKEW_TYPE               DQ_GROUP               [list "DQ Group Deskew"            ]
   def_enum      DESKEW_TYPE               CUSTOM                 [list "Custom Deskew"              ]
}

################################################################################
###                       PRIVATE FUNCTIONS                                  ###
################################################################################

# proc: _init
#
# Private function to initialize internal constants
#
# parameters:
#
# returns:
#
proc ::altera_phylite::util::enum_defs::_init {} {
   ::altera_phylite::util::enum_defs::def_enums
}

################################################################################
###                   AUTO RUN CODE AT STARTUP                               ###
################################################################################
# Run the initialization
::altera_phylite::util::enum_defs::_init



