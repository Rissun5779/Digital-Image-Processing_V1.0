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


# --------------------------------------------------------------------------------------------------
# --                                                                                               --
# -- _hw.tcl compose file for Component Library Deinterlacer (Deinterlacer 2)                      --
# --                                                                                               --
# ---------------------------------------------------------------------------------------------------

source ../../common_tcl/alt_vip_helper_common.tcl
source ../../common_tcl/alt_vip_files_common.tcl
source ../../common_tcl/alt_vip_parameters_common.tcl

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- General information for the Deinterlacer II component                                        --
# -- The deinterlacer II deinterlace a video stream                                               --
# -- It is highly parameterizable and offers a wide range of features                             --
# --   * Bob, weave or Motion adaptive deinterlacing with optional motion bleed                   --
# --   * Edge dependent interpolation (two modes with different cost/quality trade-off)           --
# --   * 4:2:2 support                                                                            --
# --   * passthrough mode for progressive inputs                                                 --
# --   * Cadence detection                                                                        --
# --   * Parameterizable master interfaces to store/retrieve data from external memory            --
# --------------------------------------------------------------------------------------------------  

 
declare_general_module_info
set_module_property NAME alt_vip_cl_dil
set_module_property DISPLAY_NAME "Deinterlacer II (4K HDR passthrough) Intel FPGA IP"
set_module_property DESCRIPTION "Please refer to the user-guide for details of new CSR registers that now make Deinterlacer II easier to setup and tune for best QOR in non-VOF modes.  Note that 4K passthrough is supported in some modes, but not all, as detailed in the user guide.  For 4K passthrough in unsupported configurations, a pair of Switch II IP cores either side of the Deinterlacer II will provide the 4K passthrough feature. "

set_module_property UPGRADEABLE_FROM {alt_vip_cl_broadcast_dil 16.0 "all" alt_vip_cl_broadcast_dil 15.1 "all" alt_vip_cl_broadcast_dil 15.0 "all"}
set_module_property PARAMETER_UPGRADE_CALLBACK parameter_upgrade 

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Callbacks                                                                                    --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

set_module_property  VALIDATION_CALLBACK  validation_cb
set_module_property COMPOSITION_CALLBACK composition_cb

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Parameters                                                                                   --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

add_device_family_parameters

#Avalon-ST Video support
add_parameter             MAX_WIDTH         INTEGER                  2048
set_parameter_property    MAX_WIDTH         DISPLAY_NAME             "Maximum width of interlaced content"
set_parameter_property    MAX_WIDTH         ALLOWED_RANGES           32:2048
set_parameter_property    MAX_WIDTH         DESCRIPTION              "The maximum width of interlaced fields (maximum progressive width is 4096)"
set_parameter_property    MAX_WIDTH         HDL_PARAMETER            true
set_parameter_property    MAX_WIDTH         AFFECTS_ELABORATION      true

add_parameter             MAX_HEIGHT        INTEGER                  1080
set_parameter_property    MAX_HEIGHT        DISPLAY_NAME             "Maximum height of the generated progressive output"
set_parameter_property    MAX_HEIGHT        ALLOWED_RANGES           64:1080
set_parameter_property    MAX_HEIGHT        DESCRIPTION              "Should be set to twice the height of interlaced fields (maximum progressive height is 2160)"
set_parameter_property    MAX_HEIGHT        HDL_PARAMETER            true
set_parameter_property    MAX_HEIGHT        AFFECTS_ELABORATION      true

add_display_item   "Avalon-ST Video support"    MAX_WIDTH                  parameter
add_display_item   "Avalon-ST Video support"    MAX_HEIGHT                 parameter


add_user_packet_support_parameters

#Video Data Format
add_pixels_in_parallel_parameters
add_bits_per_symbol_parameters 4 20
add_channels_nb_parameters 3

#Customizations
set_parameter_property   USER_PACKET_SUPPORT ALLOWED_RANGES {"PASSTHROUGH:Pass all user packets through to the output"}   
set_parameter_property   USER_PACKET_FIFO_DEPTH   VISIBLE       false

add_parameter INCOMING_VIDEO_IS_YCBCR integer 1  
set_parameter_property   INCOMING_VIDEO_IS_YCBCR   DISPLAY_NAME              "YCbCr"
set_parameter_property   INCOMING_VIDEO_IS_YCBCR   ALLOWED_RANGES            0:1
set_parameter_property   INCOMING_VIDEO_IS_YCBCR   DISPLAY_HINT              boolean
set_parameter_property   INCOMING_VIDEO_IS_YCBCR   DESCRIPTION               "Select for YCbCr incoming video data, de-select for RGB"
set_parameter_property   INCOMING_VIDEO_IS_YCBCR   HDL_PARAMETER             false
set_parameter_property   INCOMING_VIDEO_IS_YCBCR   AFFECTS_ELABORATION       true


add_parameter INCOMING_VIDEO_IS_422 INTEGER 1 
set_parameter_property   INCOMING_VIDEO_IS_422             DISPLAY_NAME              "4:2:2"
set_parameter_property   INCOMING_VIDEO_IS_422             ALLOWED_RANGES            0:1
set_parameter_property   INCOMING_VIDEO_IS_422             DISPLAY_HINT              boolean
set_parameter_property   INCOMING_VIDEO_IS_422             DESCRIPTION               "Select for YCbCr incoming video data with 4:2:2 sub-sampled chroma"
set_parameter_property   INCOMING_VIDEO_IS_422             HDL_PARAMETER             false
set_parameter_property   INCOMING_VIDEO_IS_422             AFFECTS_ELABORATION       true


    
add_parameter SWAP_F0_F1 integer 0 
set_parameter_property   SWAP_F0_F1   DISPLAY_NAME              "Swap f0 and f1 field interpretation"
set_parameter_property   SWAP_F0_F1   ALLOWED_RANGES            0:1
set_parameter_property   SWAP_F0_F1   DISPLAY_HINT              boolean
set_parameter_property   SWAP_F0_F1   DESCRIPTION               "Instructs the deinterlacer to consider F0 labelled fields as F1 and visa-versa"
set_parameter_property   SWAP_F0_F1   HDL_PARAMETER             true
set_parameter_property   SWAP_F0_F1   AFFECTS_ELABORATION       true
set_parameter_property   SWAP_F0_F1   VISIBLE                   false

add_deinterlace_algo_parameters

add_parameter MOTION_BLEED integer 1
set_parameter_property    MOTION_BLEED               DISPLAY_NAME            "Motion bleed"
set_parameter_property    MOTION_BLEED               ALLOWED_RANGES          0:1
set_parameter_property    MOTION_BLEED               DISPLAY_HINT            boolean
set_parameter_property    MOTION_BLEED               DESCRIPTION             "Enable motion bleed during motion adaptive deinterlacing"
set_parameter_property    MOTION_BLEED               HDL_PARAMETER           true
set_parameter_property    MOTION_BLEED               ENABLED                 false
set_parameter_property    MOTION_BLEED               AFFECTS_ELABORATION     true
set_parameter_property    MOTION_BLEED               VISIBLE                 false

add_parameter RUNTIME_CONTROL integer 0
set_parameter_property    RUNTIME_CONTROL           DISPLAY_NAME            "Run-time control"
set_parameter_property    RUNTIME_CONTROL           ALLOWED_RANGES          0:1
set_parameter_property    RUNTIME_CONTROL           DISPLAY_HINT            boolean
set_parameter_property    RUNTIME_CONTROL           DESCRIPTION             "Enable run-time control of cadence detection"
set_parameter_property    RUNTIME_CONTROL           HDL_PARAMETER           true
set_parameter_property    RUNTIME_CONTROL           ENABLED                 true
set_parameter_property    RUNTIME_CONTROL           AFFECTS_ELABORATION     true


add_parameter MOTION_BPS integer 7
set_parameter_property    MOTION_BPS                DISPLAY_NAME            "Most significant bits of motion value computed"
set_parameter_property    MOTION_BPS                ALLOWED_RANGES          {5,6,7,8}
set_parameter_property    MOTION_BPS                DESCRIPTION             "Ensures the motion detect block performs more or less consistently across a range of bps values"
set_parameter_property    MOTION_BPS                HDL_PARAMETER           true
set_parameter_property    MOTION_BPS                ENABLED                 false
set_parameter_property    MOTION_BPS                AFFECTS_ELABORATION     true
set_parameter_property    MOTION_BPS                VISIBLE                 false


add_parameter FIELD_LATENCY integer 1
set_parameter_property    FIELD_LATENCY        DISPLAY_NAME            "Fields buffered prior to output"
set_parameter_property    FIELD_LATENCY        ALLOWED_RANGES          {0,1}
set_parameter_property    FIELD_LATENCY        DESCRIPTION             "The deinterlacer has a latency of 2-4 lines and 0-1 fields depending upon configuration"
set_parameter_property    FIELD_LATENCY        HDL_PARAMETER           false
set_parameter_property    FIELD_LATENCY        ENABLED                 false
set_parameter_property    FIELD_LATENCY        AFFECTS_ELABORATION     true
set_parameter_property    FIELD_LATENCY        VISIBLE                 true


add_parameter BOB_BEHAVIOUR STRING FRAME_FOR_FIELD 
set_parameter_property    BOB_BEHAVIOUR        DISPLAY_NAME            "Vertical interpolation (\"Bob\") deinterlacing behaviour"
set_parameter_property    BOB_BEHAVIOUR        ALLOWED_RANGES          {"F0_SYNCHRONIZED:Produce one frame for every F0 field" "F1_SYNCHRONIZED:Produce one frame for every F1 field" "FRAME_FOR_FIELD:Produce one frame for every field"}
set_parameter_property    BOB_BEHAVIOUR        DISPLAY_HINT            ""
set_parameter_property    BOB_BEHAVIOUR        DESCRIPTION             "Governs the rate at which frames are produced and which incoming fields are used to produce them. Only relevant when \"Deinterlacing Algorithm\" is set to Vertical interpolation \"Bob\" mode"
set_parameter_property    BOB_BEHAVIOUR        HDL_PARAMETER           false
set_parameter_property    BOB_BEHAVIOUR        ENABLED                 true
set_parameter_property    BOB_BEHAVIOUR        AFFECTS_ELABORATION     true
set_parameter_property    BOB_BEHAVIOUR        VISIBLE                 true


add_parameter DISABLE_EMBEDDED_STREAM_CLEANER integer 0
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        DISPLAY_NAME            "Disable embedded Avalon-ST Video stream cleaner"
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        ALLOWED_RANGES          0:1
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        DESCRIPTION             "Only disable protection if the system can guarantee to always supply well-formed control and video packets of the correct length"
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        HDL_PARAMETER           false
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        ENABLED                 true
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        AFFECTS_ELABORATION     true
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        VISIBLE                 true
set_parameter_property    DISABLE_EMBEDDED_STREAM_CLEANER        DISPLAY_HINT            boolean



add_parameter ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO integer 1
set_parameter_property ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO  DESCRIPTION           "True if embedded color space convertors are to be instantiated"
set_parameter_property ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO  HDL_PARAMETER         false
set_parameter_property ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO  DERIVED               true
set_parameter_property ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO  VISIBLE               false


add_parameter ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO integer 1
set_parameter_property ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO  DESCRIPTION           "True if embedded color space convertors are to be instantiated"
set_parameter_property ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO  HDL_PARAMETER         false
set_parameter_property ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO  DERIVED               true
set_parameter_property ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO  VISIBLE               false


    

# This is now a DERIVED param based on INCOMING_VIDEO_IS_422 and other params
add_parameter IS_422 INTEGER 1 
set_parameter_property   IS_422             DESCRIPTION               "Deinterlacer core expects 4:2:2 sub-sampled chroma"
set_parameter_property   IS_422             HDL_PARAMETER             true
set_parameter_property   IS_422             DERIVED                   true
set_parameter_property   IS_422             VISIBLE                   false

    
# cadence detection and choice of a cadence detector
add_cadence_detect_parameters
add_cadence_algo_parameters

# Parameters for the read and write masters
add_common_masters_parameters
set_parameter_property    CLOCKS_ARE_SEPARATE        ENABLED                  true
set_parameter_property    CLOCKS_ARE_SEPARATE        AFFECTS_GENERATION       true

add_bursting_master_parameters   WRITE_MASTER         "Write Master"
add_bursting_master_parameters   EDI_READ_MASTER      "EDI Read Master"
add_bursting_master_parameters   MA_READ_MASTER       "MA Read Master"
add_bursting_master_parameters   MOTION_WRITE_MASTER  "Motion Write Master"
add_bursting_master_parameters   MOTION_READ_MASTER   "Motion Read Master"

add_base_address_parameters
   

# Storing packets in memory (useless with the passthrough mode)   
add_user_packets_mem_storage_parameters
set_parameter_property    USER_PACKETS_MAX_STORAGE   HDL_PARAMETER           false
set_parameter_property    MAX_SYMBOLS_PER_PACKET     HDL_PARAMETER           false
set_parameter_property    USER_PACKETS_MAX_STORAGE   VISIBLE                 false
set_parameter_property    MAX_SYMBOLS_PER_PACKET     VISIBLE                 false
set_parameter_property    USER_PACKETS_MAX_STORAGE   ENABLED                 false
set_parameter_property    MAX_SYMBOLS_PER_PACKET     ENABLED                 false



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Derived parameters                                                                           --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  
add_parameter LINE_BUFFER_SIZE integer 0
set_parameter_property    LINE_BUFFER_SIZE              DESCRIPTION              "The length (in bytes) of a line of pixels stored in memory"
set_parameter_property    LINE_BUFFER_SIZE              VISIBLE                  false
set_parameter_property    LINE_BUFFER_SIZE              HDL_PARAMETER            false
set_parameter_property    LINE_BUFFER_SIZE              DERIVED                  true

add_parameter FIELD_BUFFER_SIZE_IN_BYTES integer 0
set_parameter_property    FIELD_BUFFER_SIZE_IN_BYTES    DESCRIPTION              "The size (in words) of a field buffer"
set_parameter_property    FIELD_BUFFER_SIZE_IN_BYTES    VISIBLE                  false
set_parameter_property    FIELD_BUFFER_SIZE_IN_BYTES    HDL_PARAMETER            false
set_parameter_property    FIELD_BUFFER_SIZE_IN_BYTES    DERIVED                  true

add_parameter MOTION_LINE_BUFFER_SIZE integer 0
set_parameter_property    MOTION_LINE_BUFFER_SIZE       DESCRIPTION              "The length (in bytes) of a line of motion value stored in memory"
set_parameter_property    MOTION_LINE_BUFFER_SIZE       VISIBLE                  false
set_parameter_property    MOTION_LINE_BUFFER_SIZE       HDL_PARAMETER            false
set_parameter_property    MOTION_LINE_BUFFER_SIZE       DERIVED                  true

add_parameter MOTION_BUFFER_SIZE_IN_BYTES integer 0
set_parameter_property    MOTION_BUFFER_SIZE_IN_BYTES   DESCRIPTION              "The size (in words) of the motion buffer"
set_parameter_property    MOTION_BUFFER_SIZE_IN_BYTES   VISIBLE                  false
set_parameter_property    MOTION_BUFFER_SIZE_IN_BYTES   HDL_PARAMETER            false
set_parameter_property    MOTION_BUFFER_SIZE_IN_BYTES   DERIVED                  true



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- GUI                                                                                          --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------  

add_display_item   "Avalon-ST Video support"               DISABLE_EMBEDDED_STREAM_CLEANER              parameter

add_display_item   "Video Data Format"                     INCOMING_VIDEO_IS_YCBCR                      parameter
add_display_item   "Video Data Format"                     INCOMING_VIDEO_IS_422                        parameter

add_display_item   "Deinterlacing Algorithm and Features"  DEINTERLACE_ALGORITHM                        parameter
add_display_item   "Deinterlacing Algorithm and Features"  BOB_BEHAVIOUR                                parameter
add_display_item   "Deinterlacing Algorithm and Features"  RUNTIME_CONTROL                              parameter

add_display_item   "Cadence Detection (Motion adaptive deinterlacing only)"    CADENCE_ALGORITHM_NAME   parameter
add_display_item   "Cadence Detection (Motion adaptive deinterlacing only)"    FIELD_LATENCY            parameter
add_display_item   "Cadence Detection (Motion adaptive deinterlacing only)"    CADENCE_DETECTION        parameter

add_display_item   "Avalon-MM interface to Memory"         MEM_PORT_WIDTH                               parameter
add_display_item   "Avalon-MM interface to Memory"         CLOCKS_ARE_SEPARATE                          parameter
add_display_item   "Avalon-MM interface to Memory"         MEM_BASE_ADDR                                parameter
add_display_item   "Avalon-MM interface to Memory"         MEM_TOP_ADDR                                 parameter
add_display_item   "Avalon-MM interface to Memory"         WRITE_MASTER_FIFO_DEPTH                      parameter
add_display_item   "Avalon-MM interface to Memory"         WRITE_MASTER_BURST_TARGET                    parameter
add_display_item   "Avalon-MM interface to Memory"         EDI_READ_MASTER_FIFO_DEPTH                   parameter
add_display_item   "Avalon-MM interface to Memory"         EDI_READ_MASTER_BURST_TARGET                 parameter
add_display_item   "Avalon-MM interface to Memory"         MA_READ_MASTER_FIFO_DEPTH                    parameter
add_display_item   "Avalon-MM interface to Memory"         MA_READ_MASTER_BURST_TARGET                  parameter
add_display_item   "Avalon-MM interface to Memory"         MOTION_WRITE_MASTER_FIFO_DEPTH               parameter
add_display_item   "Avalon-MM interface to Memory"         MOTION_WRITE_MASTER_BURST_TARGET             parameter
add_display_item   "Avalon-MM interface to Memory"         MOTION_READ_MASTER_FIFO_DEPTH                parameter
add_display_item   "Avalon-MM interface to Memory"         MOTION_READ_MASTER_BURST_TARGET              parameter


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Upgrade callback                                                                             --
# -- This Deinterlacer II is the upgrade path from all previous deinterlacers                     --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------



proc parameter_upgrade {ip_core_type version parameters} {

   set_interface_upgrade_map { av_st_clock av_st_clock av_st_reset av_st_reset av_mm_clock av_mm_clock av_mm_reset av_mm_reset din din dout dout control control write_master write_master edi_read_master edi_read_master ma_read_master ma_read_master motion_write_master motion_write_master motion_read_master motion_read_master}

   if {$ip_core_type == "alt_vip_cl_dil"} {

      if {$version == 16.1} {

         # Most parameters just map directly across :
         foreach { name value } $parameters {

              # These params no longer exists:
              if {$name != "ENABLE_422_PROCESSING_FOR_INTERLACED_VIDEO" && $name != "IS_YCBCR"} {
                   set_parameter_value $name $value                           
              }

         }

         # Get some information so I can set the new parameters :
         set is_422                                     [get_parameter_value IS_422]
         set number_of_color_planes                     [get_parameter_value NUMBER_OF_COLOR_PLANES]
         set motion_bps                                 [get_parameter_value MOTION_BPS ]

         # Setting the derived parameters
         if {$is_422 == 1 && $number_of_color_planes == 2} {
             set_parameter_value   INCOMING_VIDEO_IS_YCBCR     1
             set_parameter_value   INCOMING_VIDEO_IS_422       1
         } else {
             set_parameter_value   INCOMING_VIDEO_IS_YCBCR     0
             set_parameter_value   INCOMING_VIDEO_IS_422       0
         }

      } else {

          # Most parameters just map directly across :
          foreach { name value } $parameters {

                # This param no longer exists, as progressive is always passed through :
                if {$name != "PROGRESSIVE_PASSTHROUGH"} {

                   # Cater for legacy parameters too :
                     if {$name == "SYMBOLS_IN_SEQ"} {
                          if {$value>1} {
                              set_parameter_value COLOR_PLANES_ARE_IN_PARALLEL 0 
                          set_parameter_value NUMBER_OF_COLOR_PLANES       $value
                      } else {
                             set_parameter_value COLOR_PLANES_ARE_IN_PARALLEL 1 
                      }
                   } else { 

                          if {$name == "SYMBOLS_IN_PAR"} {
                              if {$value>1} {
                                  set_parameter_value COLOR_PLANES_ARE_IN_PARALLEL 1 
                              set_parameter_value NUMBER_OF_COLOR_PLANES       $value
                          } else {
                                  set_parameter_value COLOR_PLANES_ARE_IN_PARALLEL 0 
                          }
                      } else {
                          set_parameter_value $name $value
                     }

                   }

              }

         }

         # Get some information so I can set the new parameters :
         set is_422                                     [get_parameter_value IS_422]
         set number_of_color_planes                     [get_parameter_value NUMBER_OF_COLOR_PLANES]
         set motion_bps                                 [get_parameter_value MOTION_BPS ]

         # Setting the derived parameters

         # The dil II sets MOTION_BPS to 7, whereas the BDIL sets it to 6.  This fact is used to discriminate between the two :
         if {$motion_bps == 6} {
             set_parameter_value   FIELD_LATENCY   1
             set_parameter_value   CADENCE_ALGORITHM_NAME  "CADENCE_32_22_VOF"
         } else {
             set_parameter_value   FIELD_LATENCY   0
             #set_parameter_value   CADENCE_ALGORITHM_NAME  "CADENCE_32_22"
         }

         if {$is_422 == 1 && $number_of_color_planes == 2} {
             set_parameter_value   INCOMING_VIDEO_IS_YCBCR     1
             set_parameter_value   INCOMING_VIDEO_IS_422       1
         } else {
             set_parameter_value   INCOMING_VIDEO_IS_YCBCR     0
             set_parameter_value   INCOMING_VIDEO_IS_422       0
         }

         set_parameter_value   USER_PACKET_SUPPORT                           "PASSTHROUGH"
         set_parameter_value   BOB_BEHAVIOUR                                 "FRAME_FOR_FIELD"
         set_parameter_value   DISABLE_EMBEDDED_STREAM_CLEANER               0

      }

   } else {

      # Most parameters just map directly across :
      foreach { name value } $parameters {
          set_parameter_value $name $value           
      }

      # Get some information so I can set the new parameters :
      set is_422                                     [get_parameter_value IS_422]
      set number_of_color_planes                     [get_parameter_value NUMBER_OF_COLOR_PLANES]
      set motion_bps                                 [get_parameter_value MOTION_BPS ]

      # Setting the derived parameters

      if {$is_422 == 1 && $number_of_color_planes == 2} {
          set_parameter_value   INCOMING_VIDEO_IS_YCBCR     1
          set_parameter_value   INCOMING_VIDEO_IS_422       1
      } else {
          set_parameter_value   INCOMING_VIDEO_IS_YCBCR     0
          set_parameter_value   INCOMING_VIDEO_IS_422       0
      }

      set_parameter_value   USER_PACKET_SUPPORT                   "PASSTHROUGH"
      set_parameter_value   BOB_BEHAVIOUR                     "FRAME_FOR_FIELD"
      set_parameter_value   DISABLE_EMBEDDED_STREAM_CLEANER                   0
      set_parameter_value   FIELD_LATENCY                                     1
      set_parameter_value   CADENCE_ALGORITHM_NAME           "CADENCE_32_22_VOF"
   }

}





# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Validation callback                                                                          --
# -- Checking the legality of the parameter set chosen by the user                                --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------




proc validation_cb {} {
    
    # See validation_helpers in common_parameters.tcl to reuse common code ---
    
    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
   
   set family                                     [get_parameter_value FAMILY]
   set pixels_in_parallel                         [get_parameter_value PIXELS_IN_PARALLEL]
   set bits_per_symbol                            [get_parameter_value BITS_PER_SYMBOL]
   set incoming_video_is_422                      [get_parameter_value INCOMING_VIDEO_IS_422]
   set cadence_algorithm_name                     [get_parameter_value CADENCE_ALGORITHM_NAME ]
   set is_ycbcr                                   [get_parameter_value INCOMING_VIDEO_IS_YCBCR ]
   set cadence_detection                          [get_parameter_value CADENCE_DETECTION]
   set number_of_color_planes                     [get_parameter_value NUMBER_OF_COLOR_PLANES]
   set color_planes_are_in_parallel               [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set field_latency                              [get_parameter_value FIELD_LATENCY]
   set deinterlace_algorithm                      [get_parameter_value DEINTERLACE_ALGORITHM]
   set disable_embedded_stream_cleaner            [get_parameter_value DISABLE_EMBEDDED_STREAM_CLEANER]
   
   set max_width_interlaced                       [get_parameter_value MAX_WIDTH]
   set max_height_interlaced                      [get_parameter_value MAX_HEIGHT]
   
   set max_width_progressive                      4096
   set max_height_progressive                     2160
      
   if { [expr $max_height_interlaced % 2] != 0 } {
       send_message error "The maximum frame height must be an even number"
   }
 
    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
   set max_field_height             [expr ($max_height_interlaced+1)/2]

    # --------------------------------------------------------------------------------------------------
    # -- Validation                                                                                   --
    # --------------------------------------------------------------------------------------------------
      
   if { [expr $max_height_interlaced % 2] != 0 } {
       send_message error "The maximum frame height must be an even number"
   }
    # There is an helper for this already. Don't write this code --
    pip_validation_callback_helper
    

    # --------------------------------------------------------------------------------------------------
    # -- GUI constraints and setting derived TCL parameters                                           --
    # --------------------------------------------------------------------------------------------------

 
   if {$cadence_detection == 1 && $cadence_algorithm_name == "CADENCE_32_22_VOF"} {
        set_parameter_property   FIELD_LATENCY               ENABLED   true
   } 
   
   if { ($cadence_detection == 0 || $cadence_algorithm_name != "CADENCE_32_22_VOF") && $field_latency == 0}  {
        set_parameter_property   FIELD_LATENCY               ENABLED   false   
   }      
   
   if {$cadence_detection == 1 && $cadence_algorithm_name == "CADENCE_32_22_VOF" && $field_latency == 0} {
        send_message error "The selected cadence detection mode (3:2 & 2:2 detector) incurs a field latency.  Plese increase \"Fields buffered prior to output\" to 1 or select \"3:2 & 2:2 detector\" cadence detection algorithm"    
   } 
   
   if {($cadence_algorithm_name != "CADENCE_32_22_VOF" || $cadence_detection == 0) && $field_latency == 1} {
        set_parameter_property   FIELD_LATENCY               ENABLED   true   
        send_message error "The selected cadence detection mode (3:2 & 2:2 detector) incurs no field latency.  Plese reduce \"Fields buffered prior to output\" to 0"   
   } 
   
   if {$cadence_detection == 0} {
         set_parameter_property   CADENCE_ALGORITHM_NAME      ENABLED   false
   } else {
         set_parameter_property   CADENCE_ALGORITHM_NAME      ENABLED   true   
   }
   
   if {$is_ycbcr == 0 && $incoming_video_is_422 == 1} {
      send_message error "Select YCbCr format if using 422 video"        
   } 
   
   if {$is_ycbcr == 1 && $incoming_video_is_422 == 0 && $number_of_color_planes == 2 } {
      send_message error "For YCbCr video, 2 color planes, either select 422 support or increase color planes to 3"        
   } 
   
   if {$is_ycbcr == 1 && $incoming_video_is_422 == 1 && $number_of_color_planes != 2 } {
      send_message error "For 422 YCbCr video, select 2 color planes"        
   } 
   
   if {$is_ycbcr == 0 && $number_of_color_planes == 2 && $incoming_video_is_422 == 0} {
      send_message error "For 2 color planes, either select YCbCr 422 support or increase color planes to 3"        
   } 

   if {$incoming_video_is_422 > 0 && $number_of_color_planes != 2 } {
       send_message error "There must be 2 color planes in parallel for the 4:2:2 data configuration"
   }  

   # Check that no advanced features are selected for serial mdoe :
   if {$color_planes_are_in_parallel == 0} {
   
      if {$cadence_detection == 1} {
         send_message error "Cadence detection and reverse pulldown is not supported for color planes in sequence"
      }
   
      if {$deinterlace_algorithm == "MOTION_ADAPTIVE" || $deinterlace_algorithm == "MOTION_ADAPTIVE_HQ"} {
         send_message error "Motion adaptive deinterlacing is not supported for color planes in sequence"
      }    
   
   }
   
   
   if {$deinterlace_algorithm == "MOTION_ADAPTIVE" && $cadence_detection == 1 && $cadence_algorithm_name == "CADENCE_32_22_VOF"  } {   
       send_message error "Motion adaptive mode is unsupported with \"3:2 & 2:2 detector with video over film\" cadence detection algorithm. Either set \"Deinterlacing algorithm\" to \"Motion Adaptive High Quality\" or select \"3:2 & 2:2 detector\" cadence detection algorithm."                 
   } 
   
   if {$deinterlace_algorithm == "WEAVE" && $cadence_detection == 1} {
       send_message error "\"Field weaving\" deinterlacing algorithm is not supported if \"Cadence detection and reverse pulldown\" is enabled. Either set \"Deinterlacing algorithm\" to a \"Motion Adaptive\" mode or de-select \"Cadence detection and reverse pulldown\"."
   }
   
   if {$deinterlace_algorithm == "BOB" && $cadence_detection == 1} {
       send_message error "Selections \"Vertical interpolation (Bob)\" deinterlacing algorithm and \"Cadence detection and reverse pulldown\" are unsupported. Either set \"Deinterlacing algorithm\" to a \"Motion Adaptive\" mode or deselect \"Cadence detection and reverse pulldown\""
   }      
   
   if {$disable_embedded_stream_cleaner && ($deinterlace_algorithm == "MOTION_ADAPTIVE" || $deinterlace_algorithm == "MOTION_ADAPTIVE_HQ")} {
       send_message warning "The embedded Avalon-ST video stream cleaner is disabled.  The deinterlacer under a motion adaptive configuration may lock-up if mismatched control and video packets are received."
   }

   if {($deinterlace_algorithm == "MOTION_ADAPTIVE" || $deinterlace_algorithm == "MOTION_ADAPTIVE_HQ") && !($cadence_detection == 1 && $cadence_algorithm_name == "CADENCE_32_22_VOF")  } {   
       send_message warning "4K passthrough is unsupported in this mode.  If 4K passthrough if needed, either select \"3:2 & 2:2 detector with video over film\" for \"Cadence detection algorithm\", or select \"Bob\" or \"Weave\" for \"Deinterlacing algorithm\".  Alternatively use a pair of \"Switch II\" IP cores either side of the \"Deinterlacer II\" code in your system."                 
   } 

   
   if {$deinterlace_algorithm == "BOB" } {
       set_parameter_property   BOB_BEHAVIOUR         ENABLED   true
   } 
                

   set mem_port_width               [get_parameter_value MEM_PORT_WIDTH]

   # Compute the space reserved for an input line in memory, this is max_line_word_size rounded up to the next multiple of burst
   # target to prevent line starting at an address that would not be a nice starting point for a burst.
   # Deduce the size of a field buffer.
   set bytes_per_word               [expr $mem_port_width / 8]
   set samples_per_word             [expr $mem_port_width / ($number_of_color_planes * $bits_per_symbol)]
   if { $samples_per_word < 1 } {
      set samples_per_word 1
   }
   set max_line_sample_size         [expr $max_width_interlaced]
   set max_line_word_size           [expr ($max_line_sample_size + $samples_per_word - 1) / $samples_per_word]
   
   set write_master_burst           [get_parameter_value WRITE_MASTER_BURST_TARGET]    
   set edi_read_master_burst        [get_parameter_value EDI_READ_MASTER_BURST_TARGET]    
   set ma_read_master_burst         [get_parameter_value MA_READ_MASTER_BURST_TARGET]    
   set max_burst                    [max $write_master_burst [max $edi_read_master_burst $ma_read_master_burst]]
   
   set line_burst_size              [expr ($max_line_word_size + $max_burst-1)/$max_burst]
   set line_length_in_words         [expr $line_burst_size * $max_burst]
   set line_buffer_size             [expr $line_length_in_words * $bytes_per_word]
   set field_buffer_size            [expr $line_length_in_words * $max_field_height * $bytes_per_word]

   
   # Similar stuff for the motion masters (with $samples_per_words == $motion_samples_per_word since VOF&motion value are fixed to 32-bits)
   # If Dil-II the njust have 8 bits per motion value :
   # Compute the space reserved for an motion line in memory, this is max_line_word_size rounded up to the next multiple of burst
   # target to prevent line starting at an address that would not be a nice starting point for a burst.
   # Deduce the size of a motion buffer.


    if {$cadence_algorithm_name == "CADENCE_32_22_VOF" && $cadence_detection == 1 && $deinterlace_algorithm == "MOTION_ADAPTIVE_HQ"} {
   set motion_samples_per_word      [expr $mem_port_width / 32]
      } else {  
         # Set motion_samples_per_word to /16 as we are padding to 16 bits
         set motion_samples_per_word      [expr $mem_port_width / 16] 
      }

   if { $motion_samples_per_word < 1 } {
      set motion_samples_per_word 1
   }
   set max_motion_line_word_size    [expr ($max_width_interlaced + $motion_samples_per_word - 1) / $motion_samples_per_word]

   set motion_write_burst           [get_parameter_value MOTION_WRITE_MASTER_BURST_TARGET]    
   set motion_read_burst            [get_parameter_value MOTION_READ_MASTER_BURST_TARGET]    
   set max_burst                    [max $motion_write_burst $motion_read_burst]
   
   set motion_line_burst_size       [expr ($max_motion_line_word_size + $max_burst-1)/$max_burst]
   set motion_line_length_in_words  [expr $motion_line_burst_size * $max_burst]
   set motion_line_buffer_size      [expr $motion_line_length_in_words * $bytes_per_word]
   set motion_field_size            [expr $motion_line_length_in_words * $max_field_height * $bytes_per_word]

   # Checking that the burst target is smaller that the number of words in the largest possible
   # packet in each packet reader/writer. Otherwise the bursting_master_fifo will say no
   if { $max_line_word_size < $write_master_burst } {
      send_message error "The burst target for the write master is set to a value higher than achievable for the current parameterization. It should be reduced"
   }
   if { $max_line_word_size < $edi_read_master_burst } {
      send_message error "The burst target for the edi read master is set to a value higher than achievable for the current parameterization. It should be reduced"
   }
   if { $max_line_word_size < $ma_read_master_burst } {
      send_message error "The burst target for the ma read master is set to a value higher than achievable for the current parameterization. It should be reduced"
   }
   if { $max_motion_line_word_size < $motion_write_burst } {
      send_message error "The burst target for the motion write master is set to a value higher than achievable for the current parameterization. It should be reduced"
   }
   if { $max_motion_line_word_size < $motion_read_burst } {
      send_message error "The burst target for the motion read master is set to a value higher than achievable for the current parameterization. It should be reduced"
   }


   # Setting the derived parameters
   set_parameter_value            LINE_BUFFER_SIZE                       $line_buffer_size
   set_parameter_value            FIELD_BUFFER_SIZE_IN_BYTES             $field_buffer_size          
   set_parameter_value            MOTION_LINE_BUFFER_SIZE                $motion_line_buffer_size
   set_parameter_value            MOTION_BUFFER_SIZE_IN_BYTES            $motion_field_size
    
   # Set the derived parameter for the top of the memory base address
   set mem_base_addr     [get_parameter_value MEM_BASE_ADDR]
   set mem_top_addr      [expr $mem_base_addr + 4*$field_buffer_size + $motion_field_size]


   set_parameter_value   MEM_TOP_ADDR      $mem_top_addr
            
   
   # RGB
   if {!$is_ycbcr} {
      
      # if vof mode -> Bdil
      if {$deinterlace_algorithm == "MOTION_ADAPTIVE_HQ" && $cadence_detection == 1 && $cadence_algorithm_name == "CADENCE_32_22_VOF"  } {                
         set_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO    true  
         set_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO    true
         set_parameter_value IS_422                                      true                  
         send_message info "Deinterlacer II configured for RGB color space (with video over film detection)"
      # NB. NOT VOf mode, can handle most things   
      } else {
         set_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO    false  
         set_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO    false      
         set_parameter_value IS_422                                      $incoming_video_is_422                  
         send_message info "Deinterlacer II configured for RGB color space"
      }
            
      
   # YCbCr incoming video   
   } else {
   
      # if vof mode -> Bdil
      if {$deinterlace_algorithm == "MOTION_ADAPTIVE_HQ" && $cadence_detection == 1 && $cadence_algorithm_name == "CADENCE_32_22_VOF"} {         
         set_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO    false  
         set_parameter_value IS_422                                      true    
         if {$incoming_video_is_422} {              
            set_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO    false
            send_message info "Deinterlacer II configured for YCbCr 422 color space (with video over film detection)"
         } else {
            set_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO    true
            send_message info "Deinterlacer II configured for YCbCr 444 color space (with video over film detection)"
         }   
      #non-vof -> Dil II                    
      } else {
         set_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO    false  
         set_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO    false  
         set_parameter_value IS_422                                      $incoming_video_is_422    
         if {$incoming_video_is_422} {              
            send_message info "Deinterlacer II configured for YCbCr 422 color space"
         } else {
            send_message info "Deinterlacer II configured for YCbCr 444 color space"
         }
      }
      
   }
   
   
   #send_message info "Debug info - base_addr = [ expr $mem_base_addr] "
   #send_message info "Debug info - motion_line_length_in_words = [ expr $motion_line_length_in_words] "
   #send_message info "Debug info - bytes_per_word = [ expr $bytes_per_word] "
   #send_message info "Debug info - motion_line_burst_size = [ expr $motion_line_burst_size] "
   #send_message info "Debug info - max_burst = [ expr $max_burst] "
   #send_message info "Debug info - max_motion_line_word_size = [ expr $max_motion_line_word_size] "
   #send_message info "Debug info - max_width_interlaced = [ expr $max_width_interlaced] "
   #send_message info "Debug info - motion_samples_per_word = [ expr $motion_samples_per_word] "
   #send_message info "Debug info - mem_port_width = [ expr $mem_port_width] "
   #send_message info "Debug info - motion_line_offset_bytes = [ expr $motion_line_buffer_size] "
   #send_message info "Debug info - motion_buffer_base = [expr $mem_base_addr + 4*$field_buffer_size] "

   
   
   
   
}





# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Composition callback                                                                         --
# -- Instantiating, parameterizing and wiring up the sub-components                               --
# -- Exposing the external interfaces                                                             --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

proc composition_cb {} {
   global isVersion acdsVersion     

   set pixels_in_parallel           [get_parameter_value PIXELS_IN_PARALLEL]
   set bits_per_symbol              [get_parameter_value BITS_PER_SYMBOL]
   set is_422                       [get_parameter_value IS_422]
   set cadence_algorithm_name       [get_parameter_value CADENCE_ALGORITHM_NAME ]
   set is_ycbcr                     [get_parameter_value INCOMING_VIDEO_IS_YCBCR ]
   set cadence_detection            [get_parameter_value CADENCE_DETECTION]
   set number_of_color_planes       [get_parameter_value NUMBER_OF_COLOR_PLANES]   
   set field_latency                [get_parameter_value FIELD_LATENCY] 
   set color_planes_are_in_parallel [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
   set deinterlace_algorithm        [get_parameter_value DEINTERLACE_ALGORITHM]


    #First figure our which of 3 options we are building :
    if {$deinterlace_algorithm == "WEAVE"} {
       weave_composition_callback_instantiation
       weave_composition_callback_connections
    
    } elseif {$deinterlace_algorithm == "BOB"} {
       bob_composition_callback_instantiation
       bob_composition_callback_connections
    
    } elseif {$cadence_algorithm_name == "CADENCE_32_22_VOF" && $cadence_detection == 1 && $deinterlace_algorithm == "MOTION_ADAPTIVE_HQ"} {
       
       #Option 3 - "Broadcast dil"    
       bdil_composition_callback_instantiation
       bdil_composition_callback_connections
          
    } else {
       
       #Option 2 - "Dil II"            
       dil2_composition_callback_instantiation
       dil2_composition_callback_connections                       
                             
    } 

}


#TODO Set source addresses..

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Instantiation of sub-components                                                              --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc bdil_composition_callback_instantiation {} {
   global isVersion acdsVersion

   set pixels_in_parallel           [get_parameter_value PIXELS_IN_PARALLEL]
   set bits_per_symbol              [get_parameter_value BITS_PER_SYMBOL]
   set bits_per_symbol_core         10
   
   set is_422                       [get_parameter_value IS_422]
   set color_planes_are_in_parallel [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL] 
   set number_of_color_planes       [get_parameter_value NUMBER_OF_COLOR_PLANES]
   
   set symbols_in_seq               [expr { $color_planes_are_in_parallel ? 1 : $number_of_color_planes } ] 
   set symbols_in_par               [expr { $color_planes_are_in_parallel ? $number_of_color_planes : 1 } ] 

   set video_data_width             [expr $bits_per_symbol * $symbols_in_par]
   set are_in_par 1   
   
   set base                         [get_parameter_value MEM_BASE_ADDR]
   
   set max_width_interlaced         [get_parameter_value MAX_WIDTH]
   set max_height_interlaced        [get_parameter_value MAX_HEIGHT]
   
   set max_width_progressive        4096
   set max_height_progressive       2160
   
   set base_addr                    [get_parameter_value MEM_BASE_ADDR]
   set field_buffer_size            [get_parameter_value FIELD_BUFFER_SIZE_IN_BYTES]
   set motion_field_buffer_size     [get_parameter_value MOTION_BUFFER_SIZE_IN_BYTES]  
   set line_buffer_size             [get_parameter_value LINE_BUFFER_SIZE] 
   set motion_line_buffer_size      [get_parameter_value MOTION_LINE_BUFFER_SIZE]
   
   # motion_bps is now number of bits required for motion plus VOF state
   #set motion_bps                   32

   set write_master_fifo_depth      [get_parameter_value WRITE_MASTER_FIFO_DEPTH]    
   set write_master_burst_target    [get_parameter_value WRITE_MASTER_BURST_TARGET]    
   set edi_read_master_fifo_depth   [get_parameter_value EDI_READ_MASTER_FIFO_DEPTH]    
   set edi_read_master_burst_target [get_parameter_value EDI_READ_MASTER_BURST_TARGET]    
   set ma_read_master_fifo_depth    [get_parameter_value MA_READ_MASTER_FIFO_DEPTH]    
   set ma_read_master_burst_target  [get_parameter_value MA_READ_MASTER_BURST_TARGET]    
   set motion_write_fifo_depth      [get_parameter_value MOTION_WRITE_MASTER_FIFO_DEPTH]    
   set motion_write_burst_target    [get_parameter_value MOTION_WRITE_MASTER_BURST_TARGET]    
   set motion_read_fifo_depth       [get_parameter_value MOTION_READ_MASTER_FIFO_DEPTH]    
   set motion_read_burst_target     [get_parameter_value MOTION_READ_MASTER_BURST_TARGET]
   set mem_port_width               [get_parameter_value MEM_PORT_WIDTH]    
   set deinterlace_algorithm        [get_parameter_value DEINTERLACE_ALGORITHM]

   set disable_embedded_stream_cleaner      [get_parameter_value DISABLE_EMBEDDED_STREAM_CLEANER]
   
   set enable_embedded_crs_for_interlaced_video             [get_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO]
   set enable_embedded_csc_for_interlaced_video             [get_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO]
   

   set number_of_color_planes_core  2

   set symbols_in_par_core          [expr $number_of_color_planes_core] 
   set video_data_width_core        [expr $bits_per_symbol_core * $symbols_in_par_core]

   set selected_algorithm           alt_vip_dil_low_angle_algorithm
   set selected_scheduler           alt_vip_dil_vof_scheduler           
   set high_quality_line_multiplier 2
  
   set runtime_control              [get_parameter_value RUNTIME_CONTROL]
   set cadence_detect               [get_parameter_value CADENCE_DETECTION]
   set cadence_algo                 CADENCE_22
   set clocks_are_separate          [get_parameter_value CLOCKS_ARE_SEPARATE]

   set swap_f0_f1                   [get_parameter_value SWAP_F0_F1]
 
   set max_line_sample_size         [expr $max_width_interlaced * ($color_planes_are_in_parallel ? 1 : $number_of_color_planes)]
   set max_field_height             [expr ($max_height_interlaced+1)/2]

   set width_modulo                 [expr $is_422 ? 2 : 1]
   
   # --------------------------------------------------------------------------------------------------
   # -- Clocks/reset                                                                                 --
   # --------------------------------------------------------------------------------------------------
   add_instance              av_st_clk_bridge                   altera_clock_bridge $acdsVersion
   add_instance              av_st_reset_bridge                 altera_reset_bridge $acdsVersion
   
   if {$clocks_are_separate} {
     add_instance            av_mm_clk_bridge                   altera_clock_bridge $acdsVersion
     add_instance            av_mm_reset_bridge                 altera_reset_bridge $acdsVersion
   }


   # --------------------------------------------------------------------------------------------------
   # -- Main components                                                                              --
   # --------------------------------------------------------------------------------------------------


   if {$disable_embedded_stream_cleaner} {
   
   } else {
   # Embedded stream cleaner   

   add_instance                   cleaner_video_in         alt_vip_video_input_bridge       $isVersion                    
   set_instance_parameter_value   cleaner_video_in         PIXELS_IN_PARALLEL               $pixels_in_parallel           
   set_instance_parameter_value   cleaner_video_in         BITS_PER_SYMBOL                  $bits_per_symbol              
   set_instance_parameter_value   cleaner_video_in         NUMBER_OF_COLOR_PLANES           $number_of_color_planes       
   set_instance_parameter_value   cleaner_video_in         COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel 
   set_instance_parameter_value   cleaner_video_in         DEFAULT_LINE_LENGTH              $max_width_progressive        
   set_instance_parameter_value   cleaner_video_in         VIB_MODE                         FULL                          
   set_instance_parameter_value   cleaner_video_in         VIDEO_PROTOCOL_NO                1                             
   set_instance_parameter_value   cleaner_video_in         READY_LATENCY_1                  1                             
   set_instance_parameter_value   cleaner_video_in         PIPELINE_READY                   0                             
   set_instance_parameter_value   cleaner_video_in         MULTI_CONTEXT_SUPPORT            0                             
   set_instance_parameter_value   cleaner_video_in         SRC_WIDTH                        8                             
   set_instance_parameter_value   cleaner_video_in         DST_WIDTH                        8                             
   set_instance_parameter_value   cleaner_video_in         CONTEXT_WIDTH                    8                             
   set_instance_parameter_value   cleaner_video_in         TASK_WIDTH                       8                             
   set_instance_parameter_value   cleaner_video_in         RESP_SRC_ADDRESS                 0                             
   set_instance_parameter_value   cleaner_video_in         RESP_DST_ADDRESS                 0                             
   set_instance_parameter_value   cleaner_video_in         DATA_SRC_ADDRESS                 0                             
                                                                                                                                                                                                                                                                                                                                                                        
   add_instance                   cleaner_core             alt_vip_stream_cleaner_alg_core  $isVersion                              
   set_instance_parameter_value   cleaner_core             BITS_PER_SYMBOL                  $bits_per_symbol
   set_instance_parameter_value   cleaner_core             NUMBER_OF_COLOR_PLANES           $number_of_color_planes
   set_instance_parameter_value   cleaner_core             COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel
   set_instance_parameter_value   cleaner_core             PIXELS_IN_PARALLEL               $pixels_in_parallel
   set_instance_parameter_value   cleaner_core             MAX_LINE_LENGTH                  $max_width_progressive
   set_instance_parameter_value   cleaner_core             PIPELINE_READY                   0
   set_instance_parameter_value   cleaner_core             SRC_WIDTH                        8
   set_instance_parameter_value   cleaner_core             DST_WIDTH                        8
   set_instance_parameter_value   cleaner_core             CONTEXT_WIDTH                    8
   set_instance_parameter_value   cleaner_core             TASK_WIDTH                       8
   set_instance_parameter_value   cleaner_core             DATA_SRC_ADDRESS                 0
        
   add_instance                   cleaner_video_out        alt_vip_video_output_bridge      $isVersion          
   set_instance_parameter_value   cleaner_video_out        BITS_PER_SYMBOL                  $bits_per_symbol
   set_instance_parameter_value   cleaner_video_out        PIXELS_IN_PARALLEL               $pixels_in_parallel
   set_instance_parameter_value   cleaner_video_out        NUMBER_OF_COLOR_PLANES           $number_of_color_planes
   set_instance_parameter_value   cleaner_video_out        COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel
   set_instance_parameter_value   cleaner_video_out        READY_LATENCY_1                  1
   set_instance_parameter_value   cleaner_video_out        SOP_PRE_ALIGNED                  0
   set_instance_parameter_value   cleaner_video_out        NO_CONCATENATION                 0
   set_instance_parameter_value   cleaner_video_out        MULTI_CONTEXT_SUPPORT            0
   set_instance_parameter_value   cleaner_video_out        VIDEO_PROTOCOL_NO                1
   set_instance_parameter_value   cleaner_video_out        SRC_WIDTH                        8
   set_instance_parameter_value   cleaner_video_out        DST_WIDTH                        8
   set_instance_parameter_value   cleaner_video_out        CONTEXT_WIDTH                    8
   set_instance_parameter_value   cleaner_video_out        TASK_WIDTH                       8   
                              
   add_instance                   cleaner_scheduler        alt_vip_stream_cleaner_scheduler $isVersion                                     
   set_instance_parameter_value   cleaner_scheduler        ENABLE_CONTROL_SLAVE             0
   set_instance_parameter_value   cleaner_scheduler        EVEN_FRONT_CLIP                  0
   set_instance_parameter_value   cleaner_scheduler        WIDTH_MODULO                     $width_modulo
   set_instance_parameter_value   cleaner_scheduler        MAX_WIDTH                        $max_width_progressive
   set_instance_parameter_value   cleaner_scheduler        MIN_WIDTH                        32
   set_instance_parameter_value   cleaner_scheduler        MAX_HEIGHT                       $max_height_progressive
   set_instance_parameter_value   cleaner_scheduler        MIN_HEIGHT                       32
   set_instance_parameter_value   cleaner_scheduler        PIPELINE_READY                   0
   set_instance_parameter_value   cleaner_scheduler        REMOVE_4KI                       1
   set_instance_parameter_value   cleaner_scheduler        SRC_WIDTH                        8
   set_instance_parameter_value   cleaner_scheduler        DST_WIDTH                        8
   set_instance_parameter_value   cleaner_scheduler        CONTEXT_WIDTH                    8
   set_instance_parameter_value   cleaner_scheduler        TASK_WIDTH                       8   

   # End stream cleaner
   }


   # The video input bridge
   add_instance                   video_in                      alt_vip_video_input_bridge   $isVersion
   set_instance_parameter_value   video_in                      BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_in                      COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_in                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_in                      DEFAULT_LINE_LENGTH          $max_width_progressive
   set_instance_parameter_value   video_in                      PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   video_in                      VIB_MODE                     LEGACY

   # The MA algorithm
   add_instance                   dil_algo                      $selected_algorithm   $isVersion
   set_instance_parameter_value   dil_algo                      BITS_PER_SYMBOL              $bits_per_symbol_core   
   set_instance_parameter_value   dil_algo                      COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   dil_algo                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes_core   
   set_instance_parameter_value   dil_algo                      IS_422                       $is_422
   set_instance_parameter_value   dil_algo                      ENABLE_VOF_SUPPORT           1

   # The motion detection/motion bleed block, used by the MA algorithm
   add_instance                   motion_detect                 alt_vip_video_over_film      $isVersion
   set_instance_parameter_value   motion_detect                 BITS_PER_SYMBOL              $bits_per_symbol_core   
   set_instance_parameter_value   motion_detect                 COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   motion_detect                 NUMBER_OF_COLOR_PLANES       $number_of_color_planes_core   
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_0                [expr 2*$high_quality_line_multiplier]
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_1                1
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_2                2
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_3                1
   set_instance_parameter_value   motion_detect                 MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   motion_detect                 MOTION_BPS                   6   

   # Video output bridge   
   add_instance                   video_out                     alt_vip_video_output_bridge  $isVersion
   set_instance_parameter_value   video_out                     BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_out                     COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_out                     NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_out                     PIXELS_IN_PARALLEL           $pixels_in_parallel

   # The scheduler
   add_instance                   scheduler                     $selected_scheduler        $isVersion
   set_instance_parameter_value   scheduler                     BUFFER0_BASE                 $base_addr
   set_instance_parameter_value   scheduler                     BUFFER1_BASE                 [expr $base_addr + $field_buffer_size]
   set_instance_parameter_value   scheduler                     BUFFER2_BASE                 [expr $base_addr + 2*$field_buffer_size]
   set_instance_parameter_value   scheduler                     BUFFER3_BASE                 [expr $base_addr + 3*$field_buffer_size]
   set_instance_parameter_value   scheduler                     MOTION_BUFFER_BASE           [expr $base_addr + 4*$field_buffer_size]
   set_instance_parameter_value   scheduler                     CADENCE_DETECTION            $cadence_detect
   set_instance_parameter_value   scheduler                     RUNTIME_CONTROL              $runtime_control
   set_instance_parameter_value   scheduler                     LINE_OFFSET_BYTES            $line_buffer_size
   set_instance_parameter_value   scheduler                     MOTION_LINE_OFFSET_BYTES     $motion_line_buffer_size
   set_instance_parameter_value   scheduler                     MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   scheduler                     MAX_FIELD_HEIGHT             $max_field_height
   set_instance_parameter_value   scheduler                     SWAP_F0_F1                   $swap_f0_f1


   # Cadence detector
   # NB. The cadence detector ignores half the lines from the EDI line buffer...
   # NNB. The cadence detect block ONLY handles 22 cadence. The VOF block handles all 32 cadence ...
   if {$cadence_detect} {
      add_instance                   cadence                    alt_vip_cadence_detect       $isVersion
      set_instance_parameter_value   cadence                    BITS_PER_SYMBOL              $bits_per_symbol_core   
      set_instance_parameter_value   cadence                    COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
      set_instance_parameter_value   cadence                    NUMBER_OF_COLOR_PLANES       $number_of_color_planes_core   
      set_instance_parameter_value   cadence                    KERNEL_SIZE_0                [expr 2*$high_quality_line_multiplier]
      set_instance_parameter_value   cadence                    KERNEL_SIZE_1                1
      set_instance_parameter_value   cadence                    KERNEL_SIZE_2                2
      set_instance_parameter_value   cadence                    CADENCE_ALGORITHM_NAME       CADENCE_22
      set_instance_parameter_value   cadence                    MAX_LINE_LENGTH              $max_line_sample_size
      set_instance_parameter_value   cadence                    MAX_FIELD_HEIGHT             $max_height_interlaced
   }

   if {$runtime_control} {
   
      add_instance                   control                    alt_vip_control_slave          $isVersion
      set_instance_parameter_value   control                    NUM_READ_REGISTERS             9
      set_instance_parameter_value   control                    NUM_TRIGGER_REGISTERS          19
      set_instance_parameter_value   control                    NUM_RW_REGISTERS               0 
      set_instance_parameter_value   control                    NUM_INTERRUPTS                 0
      set_instance_parameter_value   control                    MM_CONTROL_REG_BYTES           1
      set_instance_parameter_value   control                    MM_READ_REG_BYTES              4            
      set_instance_parameter_value   control                    DATA_INPUT                     0
      set_instance_parameter_value   control                    DATA_OUTPUT                    0 
      set_instance_parameter_value   control                    FAST_REGISTER_UPDATES          0
      set_instance_parameter_value   control                    USE_MEMORY                     0
      set_instance_parameter_value   control                    PIPELINE_READ                  0
      set_instance_parameter_value   control                    PIPELINE_RESPONSE              0
      set_instance_parameter_value   control                    PIPELINE_DATA                  0
      set_instance_parameter_value   control                    SRC_WIDTH                      8 
      set_instance_parameter_value   control                    DST_WIDTH                      8
      set_instance_parameter_value   control                    CONTEXT_WIDTH                  8
      set_instance_parameter_value   control                    TASK_WIDTH                     8
      set_instance_parameter_value   control                    RESP_SOURCE                    1
      set_instance_parameter_value   control                    RESP_DEST                      1
      set_instance_parameter_value   control                    RESP_CONTEXT                   1
      set_instance_parameter_value   control                    DOUT_SOURCE                    1
      set_instance_parameter_value   control                    NUM_BLOCKING_TRIGGER_REGISTERS 0     
      set_instance_parameter_value   control                    MM_TRIGGER_REG_BYTES           4
      set_instance_parameter_value   control                    MM_RW_REG_BYTES                4
      set_instance_parameter_value   control                    MM_ADDR_WIDTH                  6
 
      add_connection   av_st_reset_bridge.out_reset             control.main_reset
      add_connection   av_st_clk_bridge.out_clk                 control.main_clock
   }

   # --------------------------------------------------------------------------------------------------
   # -- Line buffers                                                                                 --
   # --------------------------------------------------------------------------------------------------   
   
   # The EDI line buffer
   
   # ENABLE_RECEIVE_ONLY_CMD setting is irrelevant as not in "LOCKED" mode
   # NB. Center params here are irrelvant as the line buffer only sends when it is full :
   add_instance                   edi_line_buffer               alt_vip_line_buffer          $isVersion
   set_instance_parameter_value   edi_line_buffer               PIXEL_WIDTH                  $video_data_width_core
   set_instance_parameter_value   edi_line_buffer               SYMBOLS_IN_SEQ               $symbols_in_seq
   set_instance_parameter_value   edi_line_buffer               MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   edi_line_buffer               OUTPUT_PORTS                 2
   set_instance_parameter_value   edi_line_buffer               MODE                         "RATE_MATCHING"
   set_instance_parameter_value   edi_line_buffer               OUTPUT_MUX_SEL               "VARIABLE"
   set_instance_parameter_value   edi_line_buffer               ENABLE_RECEIVE_ONLY_CMD      1
   set_instance_parameter_value   edi_line_buffer               FIFO_SIZE                    16
   set_instance_parameter_value   edi_line_buffer               KERNEL_SIZE_0                [expr 2*$high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_CENTER_0              [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_SIZE_1                1
   set_instance_parameter_value   edi_line_buffer               KERNEL_START_1               [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_CENTER_1              [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               SRC_WIDTH                    8 
   set_instance_parameter_value   edi_line_buffer               DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer               CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer               TASK_WIDTH                   8
 

   # The MA line buffer
   #14.1 todo think i can remove one output
   add_instance                   ma_line_buffer                alt_vip_line_buffer          $isVersion
   set_instance_parameter_value   ma_line_buffer                PIXEL_WIDTH                  $video_data_width_core
   set_instance_parameter_value   ma_line_buffer                SYMBOLS_IN_SEQ               $symbols_in_seq 
   set_instance_parameter_value   ma_line_buffer                MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   ma_line_buffer                OUTPUT_PORTS                 1           
   set_instance_parameter_value   ma_line_buffer                MODE                         "LOCKED"
   set_instance_parameter_value   ma_line_buffer                OUTPUT_MUX_SEL               "OLD"
   set_instance_parameter_value   ma_line_buffer                ENABLE_RECEIVE_ONLY_CMD      1
   set_instance_parameter_value   ma_line_buffer                FIFO_SIZE                    16
   set_instance_parameter_value   ma_line_buffer                KERNEL_SIZE_0                2
   set_instance_parameter_value   ma_line_buffer                KERNEL_CENTER_0              1
   set_instance_parameter_value   ma_line_buffer                KERNEL_SIZE_1                1
   set_instance_parameter_value   ma_line_buffer                KERNEL_START_1               1
   set_instance_parameter_value   ma_line_buffer                KERNEL_CENTER_1              1
   set_instance_parameter_value   ma_line_buffer                SRC_WIDTH                    8 
   set_instance_parameter_value   ma_line_buffer                DST_WIDTH                    8
   set_instance_parameter_value   ma_line_buffer                CONTEXT_WIDTH                8
   set_instance_parameter_value   ma_line_buffer                TASK_WIDTH                   8
     

   # --------------------------------------------------------------------------------------------------
   # -- Packet writers and packet readers                                                            --
   # --------------------------------------------------------------------------------------------------
   
   # New packet transfer !
      add_instance                   packet_writer                    alt_vip_packet_transfer
      set_instance_parameter_value   packet_writer                    DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol_core * $number_of_color_planes_core) : $bits_per_symbol_core]
      set_instance_parameter_value   packet_writer                    SYMBOLS_IN_SEQ                     $symbols_in_seq
      set_instance_parameter_value   packet_writer                    MEM_PORT_WIDTH                     $mem_port_width
      set_instance_parameter_value   packet_writer                    MEM_ADDR_WIDTH                     32
      set_instance_parameter_value   packet_writer                    CLOCKS_ARE_SEPARATE                $clocks_are_separate
      set_instance_parameter_value   packet_writer                    WRITE_ENABLE                       1
      set_instance_parameter_value   packet_writer                    READ_ENABLE                        0
      set_instance_parameter_value   packet_writer                    MAX_CONTEXT_NUMBER_WRITE           1
      set_instance_parameter_value   packet_writer                    CONTEXT_BUFFER_RATIO_WRITE         [expr $write_master_fifo_depth / $write_master_burst_target]
      set_instance_parameter_value   packet_writer                    BURST_TARGET_WRITE                 $write_master_burst_target
      set_instance_parameter_value   packet_writer                    MAX_PACKET_SIZE_WRITE              $max_width_interlaced
      set_instance_parameter_value   packet_writer                    MAX_PACKET_NUM_WRITE               1
      set_instance_parameter_value   packet_writer                    ENABLE_MANY_COMMAND_WRITE          0
      set_instance_parameter_value   packet_writer                    ENABLE_PERIOD_MODE_WRITE           0
      set_instance_parameter_value   packet_writer                    ENABLE_MM_OUTPUT_REGISTER          1
      set_instance_parameter_value   packet_writer                    SUPPORT_BEATS_OVERFLOW_PRETECTION  0
      set_instance_parameter_value   packet_writer                    USE_RESPONSE_WRITE                 0           


   # New packet transfer !
      add_instance                   edi_packet_reader                    alt_vip_packet_transfer
      set_instance_parameter_value   edi_packet_reader                    DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol_core * $number_of_color_planes_core) : $bits_per_symbol_core]
      set_instance_parameter_value   edi_packet_reader                    SYMBOLS_IN_SEQ                     $symbols_in_seq
      set_instance_parameter_value   edi_packet_reader                    MEM_PORT_WIDTH                     $mem_port_width
      set_instance_parameter_value   edi_packet_reader                    MEM_ADDR_WIDTH                     32
      set_instance_parameter_value   edi_packet_reader                    CLOCKS_ARE_SEPARATE                $clocks_are_separate
      set_instance_parameter_value   edi_packet_reader                    WRITE_ENABLE                       0
      set_instance_parameter_value   edi_packet_reader                    READ_ENABLE                        1
      set_instance_parameter_value   edi_packet_reader                    MAX_CONTEXT_NUMBER_READ            1
      set_instance_parameter_value   edi_packet_reader                    CONTEXT_BUFFER_RATIO_READ          [expr $edi_read_master_fifo_depth / $edi_read_master_burst_target]
      set_instance_parameter_value   edi_packet_reader                    BURST_TARGET_READ                  $edi_read_master_burst_target
      set_instance_parameter_value   edi_packet_reader                    MAX_PACKET_SIZE_READ               $max_width_interlaced
      set_instance_parameter_value   edi_packet_reader                    ENABLE_MANY_COMMAND_READ           0
      set_instance_parameter_value   edi_packet_reader                    ENABLE_PERIOD_MODE_READ            0
      set_instance_parameter_value   edi_packet_reader                    ENABLE_MM_OUTPUT_REGISTER          1
      set_instance_parameter_value   edi_packet_reader                    SUPPORT_BEATS_OVERFLOW_PRETECTION  0
  
   # New packet transfer !
      add_instance                   ma_packet_reader                    alt_vip_packet_transfer
      set_instance_parameter_value   ma_packet_reader                    DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol_core * $number_of_color_planes_core) : $bits_per_symbol_core]
      set_instance_parameter_value   ma_packet_reader                    SYMBOLS_IN_SEQ                     $symbols_in_seq
      set_instance_parameter_value   ma_packet_reader                    MEM_PORT_WIDTH                     $mem_port_width
      set_instance_parameter_value   ma_packet_reader                    MEM_ADDR_WIDTH                     32
      set_instance_parameter_value   ma_packet_reader                    CLOCKS_ARE_SEPARATE                $clocks_are_separate
      set_instance_parameter_value   ma_packet_reader                    WRITE_ENABLE                       0
      set_instance_parameter_value   ma_packet_reader                    READ_ENABLE                        1
      set_instance_parameter_value   ma_packet_reader                    MAX_CONTEXT_NUMBER_READ            1
      set_instance_parameter_value   ma_packet_reader                    CONTEXT_BUFFER_RATIO_READ         [expr $ma_read_master_fifo_depth / $ma_read_master_burst_target]
      set_instance_parameter_value   ma_packet_reader                    BURST_TARGET_READ                  $ma_read_master_burst_target
      set_instance_parameter_value   ma_packet_reader                    MAX_PACKET_SIZE_READ               $max_width_interlaced
      set_instance_parameter_value   ma_packet_reader                    ENABLE_MANY_COMMAND_READ           0
      set_instance_parameter_value   ma_packet_reader                    ENABLE_PERIOD_MODE_READ            0
      set_instance_parameter_value   ma_packet_reader                    ENABLE_MM_OUTPUT_REGISTER          1
      set_instance_parameter_value   ma_packet_reader                    SUPPORT_BEATS_OVERFLOW_PRETECTION  0   

   # New packet transfer !
      add_instance                   motion_writer                    alt_vip_packet_transfer
      set_instance_parameter_value   motion_writer                    DATA_WIDTH                         32
      set_instance_parameter_value   motion_writer                    SYMBOLS_IN_SEQ                     1
      set_instance_parameter_value   motion_writer                    MEM_PORT_WIDTH                     $mem_port_width
      set_instance_parameter_value   motion_writer                    MEM_ADDR_WIDTH                     32
      set_instance_parameter_value   motion_writer                    CLOCKS_ARE_SEPARATE                $clocks_are_separate
      set_instance_parameter_value   motion_writer                    WRITE_ENABLE                       1
      set_instance_parameter_value   motion_writer                    READ_ENABLE                        0
      set_instance_parameter_value   motion_writer                    MAX_CONTEXT_NUMBER_WRITE           1
      set_instance_parameter_value   motion_writer                    CONTEXT_BUFFER_RATIO_WRITE         [expr $motion_write_fifo_depth / $motion_write_burst_target]
      set_instance_parameter_value   motion_writer                    BURST_TARGET_WRITE                 $motion_write_burst_target
      set_instance_parameter_value   motion_writer                    MAX_PACKET_SIZE_WRITE              $max_width_interlaced
      set_instance_parameter_value   motion_writer                    MAX_PACKET_NUM_WRITE               1
      set_instance_parameter_value   motion_writer                    ENABLE_MANY_COMMAND_WRITE          0
      set_instance_parameter_value   motion_writer                    ENABLE_PERIOD_MODE_WRITE           0
      set_instance_parameter_value   motion_writer                    ENABLE_MM_OUTPUT_REGISTER          1
      set_instance_parameter_value   motion_writer                    SUPPORT_BEATS_OVERFLOW_PRETECTION  0
      set_instance_parameter_value   motion_writer                    USE_RESPONSE_WRITE                 0      
      
   
   # New packet transfer !
      add_instance                   motion_reader                    alt_vip_packet_transfer
      set_instance_parameter_value   motion_reader                    DATA_WIDTH                         32
      set_instance_parameter_value   motion_reader                    SYMBOLS_IN_SEQ                     1
      set_instance_parameter_value   motion_reader                    MEM_PORT_WIDTH                     $mem_port_width
      set_instance_parameter_value   motion_reader                    MEM_ADDR_WIDTH                     32
      set_instance_parameter_value   motion_reader                    CLOCKS_ARE_SEPARATE                $clocks_are_separate
      set_instance_parameter_value   motion_reader                    WRITE_ENABLE                       0
      set_instance_parameter_value   motion_reader                    READ_ENABLE                        1
      set_instance_parameter_value   motion_reader                    MAX_CONTEXT_NUMBER_READ            1
      set_instance_parameter_value   motion_reader                    CONTEXT_BUFFER_RATIO_READ          [expr $motion_read_fifo_depth / $motion_read_burst_target]
      set_instance_parameter_value   motion_reader                    BURST_TARGET_READ                  $motion_read_burst_target
      set_instance_parameter_value   motion_reader                    MAX_PACKET_SIZE_READ               $max_width_interlaced
      set_instance_parameter_value   motion_reader                    ENABLE_MANY_COMMAND_READ           0
      set_instance_parameter_value   motion_reader                    ENABLE_PERIOD_MODE_READ            0
      set_instance_parameter_value   motion_reader                    ENABLE_MM_OUTPUT_REGISTER          1
      set_instance_parameter_value   motion_reader                    SUPPORT_BEATS_OVERFLOW_PRETECTION  0
   

   # --------------------------------------------------------------------------------------------------
   # -- Routing, duplicator and muxes                                                                --
   # --------------------------------------------------------------------------------------------------

   # The video input duplicator (-> packet writer and -> dil algorithm)
   # 14.1 If >1 PiP, the "non passthru" outputs have a PiP override set :
   add_instance                   video_in_duplicator           alt_vip_packet_duplicator    $isVersion 
   set_instance_parameter_value   video_in_duplicator           DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   video_in_duplicator           USE_COMMAND                  0
   set_instance_parameter_value   video_in_duplicator           DEPTH                        32
   set_instance_parameter_value   video_in_duplicator           DUPLICATOR_FANOUT            4
   set_instance_parameter_value   video_in_duplicator           REGISTER_OUTPUT              1
   set_instance_parameter_value   video_in_duplicator           PIPELINE_READY               1
   set_instance_parameter_value   video_in_duplicator           SRC_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           DST_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_duplicator           TASK_WIDTH                   8
   set_instance_parameter_value   video_in_duplicator           USER_WIDTH                   0
   set_instance_parameter_value   video_in_duplicator           NAME                         "VIDEO_IN_DUPLICATOR"
   set_instance_parameter_value   video_in_duplicator           PIXELS_IN_PARALLEL           $pixels_in_parallel


   add_instance                   video_in_op0_pipNto1          alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   video_in_op0_pipNto1          PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_OUT       1
   set_instance_parameter_value   video_in_op0_pipNto1          FIFO_DEPTH                   32
   set_instance_parameter_value   video_in_op0_pipNto1          PIPELINE_READY               1
   set_instance_parameter_value   video_in_op0_pipNto1          SRC_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          DST_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_op0_pipNto1          TASK_WIDTH                   8

   add_instance                   video_in_op1_pipNto1          alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   video_in_op1_pipNto1          PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   video_in_op1_pipNto1          PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
   set_instance_parameter_value   video_in_op1_pipNto1          PIXELS_IN_PARALLEL_OUT       1
   set_instance_parameter_value   video_in_op1_pipNto1          FIFO_DEPTH                   32
   set_instance_parameter_value   video_in_op1_pipNto1          PIPELINE_READY               1
   set_instance_parameter_value   video_in_op1_pipNto1          SRC_WIDTH                    8
   set_instance_parameter_value   video_in_op1_pipNto1          DST_WIDTH                    8
   set_instance_parameter_value   video_in_op1_pipNto1          CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_op1_pipNto1          TASK_WIDTH                   8

   add_instance                   video_in_op3_pipNto1          alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   video_in_op3_pipNto1          PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par]
   set_instance_parameter_value   video_in_op3_pipNto1          PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
   set_instance_parameter_value   video_in_op3_pipNto1          PIXELS_IN_PARALLEL_OUT       1
   set_instance_parameter_value   video_in_op3_pipNto1          FIFO_DEPTH                   32
   set_instance_parameter_value   video_in_op3_pipNto1          PIPELINE_READY               1
   set_instance_parameter_value   video_in_op3_pipNto1          SRC_WIDTH                    8
   set_instance_parameter_value   video_in_op3_pipNto1          DST_WIDTH                    8
   set_instance_parameter_value   video_in_op3_pipNto1          CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_op3_pipNto1          TASK_WIDTH                   8
   
   if {$enable_embedded_crs_for_interlaced_video} {
      add_instance                 video_in_op0_444to422        alt_vip_crs_h_down_core $isVersion   
      set_instance_parameter_value video_in_op0_444to422        BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_in_op0_444to422        PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op0_444to422        ALGORITHM                           BILINEAR
      
      add_instance                 video_in_op1_444to422        alt_vip_crs_h_down_core $isVersion   
      set_instance_parameter_value video_in_op1_444to422        BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_in_op1_444to422        PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op1_444to422        ALGORITHM                           BILINEAR
      
      add_instance                 video_in_op3_444to422        alt_vip_crs_h_down_core $isVersion   
      set_instance_parameter_value video_in_op3_444to422        BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_in_op3_444to422        PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op3_444to422        ALGORITHM                           BILINEAR
      
            
      add_instance                 video_out_ip1_422to444       alt_vip_crs_h_up_core $isVersion   
      set_instance_parameter_value video_out_ip1_422to444       BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_out_ip1_422to444       PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip1_422to444       ALGORITHM                           BILINEAR
      
      add_instance                 video_out_ip2_422to444       alt_vip_crs_h_up_core $isVersion   
      set_instance_parameter_value video_out_ip2_422to444       BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_out_ip2_422to444       PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip2_422to444       ALGORITHM                           BILINEAR
   }
   
   # BPS convertors come "closer to the outside world" than the CSC/CRS blocks, but further than the PiP convertors
   
   # NB. NUMBER_OF_COLOR_PLANES could still be either 2 or 3 at this point ...
   add_instance                 video_in_op0_10bps_conv        alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_in_op0_10bps_conv        INPUT_BITS_PER_SYMBOL             $bits_per_symbol
   set_instance_parameter_value video_in_op0_10bps_conv        OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol_core
   set_instance_parameter_value video_in_op0_10bps_conv        NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_in_op0_10bps_conv        COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_in_op0_10bps_conv        PIXELS_IN_PARALLEL                1
   
   add_instance                 video_in_op1_10bps_conv        alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_in_op1_10bps_conv        INPUT_BITS_PER_SYMBOL             $bits_per_symbol
   set_instance_parameter_value video_in_op1_10bps_conv        OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol_core
   set_instance_parameter_value video_in_op1_10bps_conv        NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_in_op1_10bps_conv        COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_in_op1_10bps_conv        PIXELS_IN_PARALLEL                1
   
   add_instance                 video_in_op3_10bps_conv        alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_in_op3_10bps_conv        INPUT_BITS_PER_SYMBOL             $bits_per_symbol
   set_instance_parameter_value video_in_op3_10bps_conv        OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol_core
   set_instance_parameter_value video_in_op3_10bps_conv        NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_in_op3_10bps_conv        COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_in_op3_10bps_conv        PIXELS_IN_PARALLEL                1
   
   add_instance                 video_out_ip1_10bps_conv       alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_out_ip1_10bps_conv       INPUT_BITS_PER_SYMBOL             $bits_per_symbol_core
   set_instance_parameter_value video_out_ip1_10bps_conv       OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol
   set_instance_parameter_value video_out_ip1_10bps_conv       NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_out_ip1_10bps_conv       COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_out_ip1_10bps_conv       PIXELS_IN_PARALLEL                1
   
   add_instance                 video_out_ip2_10bps_conv       alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_out_ip2_10bps_conv       INPUT_BITS_PER_SYMBOL             $bits_per_symbol_core
   set_instance_parameter_value video_out_ip2_10bps_conv       OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol
   set_instance_parameter_value video_out_ip2_10bps_conv       NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_out_ip2_10bps_conv       COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_out_ip2_10bps_conv       PIXELS_IN_PARALLEL                1            
              
   
   if {$enable_embedded_csc_for_interlaced_video} {

      if {$bits_per_symbol_core != 10} {
          send_message error "Embedded CSCs are required, but CORE is not processing at 10bps so internal coefficients need re-calculating.  Contact your Intel FAE for advice."            
      }

      # Coefficient sets are for 10bit<->10bit conversions.  Any other input/output BPS requires bps_convertor components
      set rgb2ycbcr_coefficient_a0     112
      set rgb2ycbcr_coefficient_a1     -10
      set rgb2ycbcr_coefficient_a2      16
      set rgb2ycbcr_coefficient_b0     -87
      set rgb2ycbcr_coefficient_b1    -102
      set rgb2ycbcr_coefficient_b2     157
      set rgb2ycbcr_coefficient_c0     -26
      set rgb2ycbcr_coefficient_c1     112
      set rgb2ycbcr_coefficient_c2      47
      
      set rgb2ycbcr_coefficient_s0  131072
      set rgb2ycbcr_coefficient_s1  131072
      set rgb2ycbcr_coefficient_s2   16384

      # RGB to YCbCr convertors  
      add_instance                 video_in_op0_rgbtoycbcr      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_in_op0_rgbtoycbcr      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_in_op0_rgbtoycbcr      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_in_op0_rgbtoycbcr      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_A0                      $rgb2ycbcr_coefficient_a0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_A1                      $rgb2ycbcr_coefficient_a1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_A2                      $rgb2ycbcr_coefficient_a2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_B0                      $rgb2ycbcr_coefficient_b0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_B1                      $rgb2ycbcr_coefficient_b1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_B2                      $rgb2ycbcr_coefficient_b2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_C0                      $rgb2ycbcr_coefficient_c0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_C1                      $rgb2ycbcr_coefficient_c1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_C2                      $rgb2ycbcr_coefficient_c2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_S0                      $rgb2ycbcr_coefficient_s0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_S1                      $rgb2ycbcr_coefficient_s1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_S2                      $rgb2ycbcr_coefficient_s2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFF_SIGNED                        1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFF_INTEGER_BITS                  0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      SUMMAND_SIGNED                      0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      SUMMAND_INTEGER_BITS                10
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_in_op0_rgbtoycbcr      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_in_op0_rgbtoycbcr      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_in_op0_rgbtoycbcr      PIPELINE_READY                      1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      RUNTIME_CONTROL                     0

  
      add_instance                 video_in_op1_rgbtoycbcr      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_in_op1_rgbtoycbcr      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_in_op1_rgbtoycbcr      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_in_op1_rgbtoycbcr      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_A0                      $rgb2ycbcr_coefficient_a0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_A1                      $rgb2ycbcr_coefficient_a1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_A2                      $rgb2ycbcr_coefficient_a2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_B0                      $rgb2ycbcr_coefficient_b0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_B1                      $rgb2ycbcr_coefficient_b1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_B2                      $rgb2ycbcr_coefficient_b2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_C0                      $rgb2ycbcr_coefficient_c0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_C1                      $rgb2ycbcr_coefficient_c1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_C2                      $rgb2ycbcr_coefficient_c2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_S0                      $rgb2ycbcr_coefficient_s0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_S1                      $rgb2ycbcr_coefficient_s1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_S2                      $rgb2ycbcr_coefficient_s2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFF_SIGNED                        1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFF_INTEGER_BITS                  0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      SUMMAND_SIGNED                      0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      SUMMAND_INTEGER_BITS                10
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_in_op1_rgbtoycbcr      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_in_op1_rgbtoycbcr      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_in_op1_rgbtoycbcr      PIPELINE_READY                      1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      RUNTIME_CONTROL                     0

    
      add_instance                 video_in_op3_rgbtoycbcr      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_in_op3_rgbtoycbcr      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_in_op3_rgbtoycbcr      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_in_op3_rgbtoycbcr      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_A0                      $rgb2ycbcr_coefficient_a0
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_A1                      $rgb2ycbcr_coefficient_a1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_A2                      $rgb2ycbcr_coefficient_a2
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_B0                      $rgb2ycbcr_coefficient_b0
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_B1                      $rgb2ycbcr_coefficient_b1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_B2                      $rgb2ycbcr_coefficient_b2
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_C0                      $rgb2ycbcr_coefficient_c0
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_C1                      $rgb2ycbcr_coefficient_c1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_C2                      $rgb2ycbcr_coefficient_c2
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_S0                      $rgb2ycbcr_coefficient_s0
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_S1                      $rgb2ycbcr_coefficient_s1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFFICIENT_S2                      $rgb2ycbcr_coefficient_s2
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFF_SIGNED                        1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFF_INTEGER_BITS                  0
      set_instance_parameter_value video_in_op3_rgbtoycbcr      SUMMAND_SIGNED                      0
      set_instance_parameter_value video_in_op3_rgbtoycbcr      SUMMAND_INTEGER_BITS                10
      set_instance_parameter_value video_in_op3_rgbtoycbcr      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_in_op3_rgbtoycbcr      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_in_op3_rgbtoycbcr      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_in_op3_rgbtoycbcr      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_in_op3_rgbtoycbcr      PIPELINE_READY                      1
      set_instance_parameter_value video_in_op3_rgbtoycbcr      RUNTIME_CONTROL                     0


      set ycbcr2rgb_coefficient_a0      541
      set ycbcr2rgb_coefficient_a1      -55
      set ycbcr2rgb_coefficient_a2        0
      set ycbcr2rgb_coefficient_b0        0
      set ycbcr2rgb_coefficient_b1     -137
      set ycbcr2rgb_coefficient_b2      459
      set ycbcr2rgb_coefficient_c0      298
      set ycbcr2rgb_coefficient_c1      298
      set ycbcr2rgb_coefficient_c2      298    
        
      set ycbcr2rgb_coefficient_s0  -296288
      set ycbcr2rgb_coefficient_s1    78840
      set ycbcr2rgb_coefficient_s2  -254083
      

      # YCbCr to RGBconvertors 
      add_instance                 video_out_ip1_ycbcrtorgb      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_A0                      $ycbcr2rgb_coefficient_a0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_A1                      $ycbcr2rgb_coefficient_a1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_A2                      $ycbcr2rgb_coefficient_a2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_B0                      $ycbcr2rgb_coefficient_b0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_B1                      $ycbcr2rgb_coefficient_b1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_B2                      $ycbcr2rgb_coefficient_b2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_C0                      $ycbcr2rgb_coefficient_c0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_C1                      $ycbcr2rgb_coefficient_c1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_C2                      $ycbcr2rgb_coefficient_c2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_S0                      $ycbcr2rgb_coefficient_s0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_S1                      $ycbcr2rgb_coefficient_s1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_S2                      $ycbcr2rgb_coefficient_s2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFF_SIGNED                        1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFF_INTEGER_BITS                  2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      SUMMAND_SIGNED                      1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      SUMMAND_INTEGER_BITS                11
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      PIPELINE_READY                      1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      RUNTIME_CONTROL                     0

      add_instance                 video_out_ip2_ycbcrtorgb      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_A0                      $ycbcr2rgb_coefficient_a0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_A1                      $ycbcr2rgb_coefficient_a1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_A2                      $ycbcr2rgb_coefficient_a2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_B0                      $ycbcr2rgb_coefficient_b0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_B1                      $ycbcr2rgb_coefficient_b1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_B2                      $ycbcr2rgb_coefficient_b2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_C0                      $ycbcr2rgb_coefficient_c0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_C1                      $ycbcr2rgb_coefficient_c1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_C2                      $ycbcr2rgb_coefficient_c2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_S0                      $ycbcr2rgb_coefficient_s0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_S1                      $ycbcr2rgb_coefficient_s1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_S2                      $ycbcr2rgb_coefficient_s2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFF_SIGNED                        1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFF_INTEGER_BITS                  2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      SUMMAND_SIGNED                      1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      SUMMAND_INTEGER_BITS                11
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      PIPELINE_READY                      1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      RUNTIME_CONTROL                     0

   }


   # Duplicator for the "current" field - routed both to the motion detection and the main algorithmic blocks
   # and optionally the cadence detection block
   add_instance                   edi_line_buffer_duplicator    alt_vip_packet_duplicator           $isVersion
   set_instance_parameter_value   edi_line_buffer_duplicator    DATA_WIDTH                   [expr $video_data_width_core*2*$high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer_duplicator    USE_COMMAND                  0
   set_instance_parameter_value   edi_line_buffer_duplicator    DEPTH                        16
   set_instance_parameter_value   edi_line_buffer_duplicator    DUPLICATOR_FANOUT            [expr $cadence_detect ? 3 : 2]
   set_instance_parameter_value   edi_line_buffer_duplicator    REGISTER_OUTPUT              1
   set_instance_parameter_value   edi_line_buffer_duplicator    PIPELINE_READY               1
   set_instance_parameter_value   edi_line_buffer_duplicator    SRC_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_duplicator    DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_duplicator    CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer_duplicator    TASK_WIDTH                   8
   set_instance_parameter_value   edi_line_buffer_duplicator    USER_WIDTH                   0
   set_instance_parameter_value   edi_line_buffer_duplicator    NAME                         "EDI_LINE_BUFFER_DUPLICATOR"



   add_instance                   edi_line_buffer_pip_convertor    alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   edi_line_buffer_pip_convertor    FIFO_DEPTH                   16
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIPELINE_READY               1
   set_instance_parameter_value   edi_line_buffer_pip_convertor    SRC_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    TASK_WIDTH                   8


   # Duplicator/router for the first frame
   # weave field is routed both to the motion detection and the main algorithmic blocks (and optionally cadence detector)
   # current field may be routed the the edi line buffer in the future
   add_instance                   edi_packet_reader_duplicator  alt_vip_packet_duplicator           $isVersion
   set_instance_parameter_value   edi_packet_reader_duplicator  DATA_WIDTH                   $video_data_width_core
   set_instance_parameter_value   edi_packet_reader_duplicator  DEPTH                        16
   set_instance_parameter_value   edi_packet_reader_duplicator  USE_COMMAND                  0
   set_instance_parameter_value   edi_packet_reader_duplicator  DUPLICATOR_FANOUT            [expr $cadence_detect ? 4 : 3]
   set_instance_parameter_value   edi_packet_reader_duplicator  REGISTER_OUTPUT              1
   set_instance_parameter_value   edi_packet_reader_duplicator  PIPELINE_READY               1
   set_instance_parameter_value   edi_packet_reader_duplicator  SRC_WIDTH                    8
   set_instance_parameter_value   edi_packet_reader_duplicator  DST_WIDTH                    8
   set_instance_parameter_value   edi_packet_reader_duplicator  CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_packet_reader_duplicator  TASK_WIDTH                   8
   set_instance_parameter_value   edi_packet_reader_duplicator  USER_WIDTH                   0
   set_instance_parameter_value   edi_packet_reader_duplicator  NAME                         "EDI_PACKET_READER_DUPLICATOR"


   # Optional duplicator for the ma_line_buffer (->motion detector and ->cadence detector)
   if {$cadence_detect} {
      add_instance                   ma_line_buffer_duplicator     alt_vip_packet_duplicator    $isVersion
      set_instance_parameter_value   ma_line_buffer_duplicator     DATA_WIDTH                   [expr $video_data_width_core* 2]
      set_instance_parameter_value   ma_line_buffer_duplicator     DEPTH                        4
      set_instance_parameter_value   ma_line_buffer_duplicator     USE_COMMAND                  0
      set_instance_parameter_value   ma_line_buffer_duplicator     DUPLICATOR_FANOUT            2
      set_instance_parameter_value   ma_line_buffer_duplicator     REGISTER_OUTPUT              1
      set_instance_parameter_value   ma_line_buffer_duplicator     PIPELINE_READY               1
      set_instance_parameter_value   ma_line_buffer_duplicator     SRC_WIDTH                    8
      set_instance_parameter_value   ma_line_buffer_duplicator     DST_WIDTH                    8
      set_instance_parameter_value   ma_line_buffer_duplicator     CONTEXT_WIDTH                8
      set_instance_parameter_value   ma_line_buffer_duplicator     TASK_WIDTH                   8
      set_instance_parameter_value   ma_line_buffer_duplicator     USER_WIDTH                   0
      set_instance_parameter_value   ma_line_buffer_duplicator     NAME                         "MA_LINE_BUFFER_DUPLICATOR"
   }
   
   # Ouput mux - used to merge user packets/progressive passthrough and the video output from the dil algorithm 
   add_instance                   output_mux                    alt_vip_packet_mux           $isVersion
   set_instance_parameter_value   output_mux                    DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   output_mux                    NUM_INPUTS                   3
   set_instance_parameter_value   output_mux                    REGISTER_OUTPUT              1
   set_instance_parameter_value   output_mux                    PIPELINE_READY               1
   set_instance_parameter_value   output_mux                    SRC_WIDTH                    8
   set_instance_parameter_value   output_mux                    DST_WIDTH                    8
   set_instance_parameter_value   output_mux                    CONTEXT_WIDTH                8
   set_instance_parameter_value   output_mux                    TASK_WIDTH                   8
   set_instance_parameter_value   output_mux                    USER_WIDTH                   0
   set_instance_parameter_value   output_mux                    NAME                         "OUTPUT_MUX"
   set_instance_parameter_value   output_mux                    PIXELS_IN_PARALLEL           $pixels_in_parallel


   # DilAlgo mux - used to route either past or future fields to DilAlgo for cadence weaving or no-motion weaving 
   add_instance                   dil_algo_input_mux            alt_vip_packet_mux           $isVersion
   set_instance_parameter_value   dil_algo_input_mux            DATA_WIDTH                   $video_data_width_core
   set_instance_parameter_value   dil_algo_input_mux            NUM_INPUTS                   2
   set_instance_parameter_value   dil_algo_input_mux            REGISTER_OUTPUT              1
   set_instance_parameter_value   dil_algo_input_mux            PIPELINE_READY               1
   set_instance_parameter_value   dil_algo_input_mux            SRC_WIDTH                    8
   set_instance_parameter_value   dil_algo_input_mux            DST_WIDTH                    8
   set_instance_parameter_value   dil_algo_input_mux            CONTEXT_WIDTH                8
   set_instance_parameter_value   dil_algo_input_mux            TASK_WIDTH                   8
   set_instance_parameter_value   dil_algo_input_mux            USER_WIDTH                   0
   set_instance_parameter_value   dil_algo_input_mux            NAME                         "DIL_ALGO_INPUT_MUX"

   add_instance                   dil_algo_pip_convertor    alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   dil_algo_pip_convertor    PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   dil_algo_pip_convertor    PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   dil_algo_pip_convertor    PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   dil_algo_pip_convertor    FIFO_DEPTH                   16
   set_instance_parameter_value   dil_algo_pip_convertor    PIPELINE_READY               1
   set_instance_parameter_value   dil_algo_pip_convertor    SRC_WIDTH                    8
   set_instance_parameter_value   dil_algo_pip_convertor    DST_WIDTH                    8
   set_instance_parameter_value   dil_algo_pip_convertor    CONTEXT_WIDTH                8
   set_instance_parameter_value   dil_algo_pip_convertor    TASK_WIDTH                   8
   
}



# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Connection of sub-components                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc bdil_composition_callback_connections {} {
   global isVersion acdsVersion        

   set cadence_detect                             [get_parameter_value CADENCE_DETECTION]
   set runtime_control                            [get_parameter_value RUNTIME_CONTROL]
   set clocks_are_separate                        [get_parameter_value CLOCKS_ARE_SEPARATE]
   set disable_embedded_stream_cleaner            [get_parameter_value DISABLE_EMBEDDED_STREAM_CLEANER]
   set number_of_color_planes                     [get_parameter_value NUMBER_OF_COLOR_PLANES]
   
   set number_of_color_planes_core                2

   set enable_embedded_csc_for_interlaced_video   [get_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO]
   set enable_embedded_crs_for_interlaced_video   [get_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO]

   # --------------------------------------------------------------------------------------------------
   # -- Top-level interfaces                                                                         --
   # --------------------------------------------------------------------------------------------------
   add_interface             av_st_clock                   clock             end
   add_interface             av_st_reset                   reset             end
   
   if {$clocks_are_separate} {
     add_interface           av_mm_clock                   clock             end
     add_interface           av_mm_reset                   reset             end
   }

   add_interface             edi_read_master               avalon            master
   add_interface             ma_read_master                avalon            master
   add_interface             motion_read_master            avalon            master
   add_interface             write_master                  avalon            master
   add_interface             motion_write_master           avalon            master
   
   if {$runtime_control} {
      add_interface          control                       avalon            slave
      set_interface_property control                       export_of         control.av_mm_control
   }

   add_interface             din                           avalon_streaming  sink 
   add_interface             dout                          avalon_streaming  source

   set_interface_property    av_st_clock                   export_of         av_st_clk_bridge.in_clk
   set_interface_property    av_st_reset                   export_of         av_st_reset_bridge.in_reset
   set_interface_property    av_st_clock                   PORT_NAME_MAP     {av_st_clock in_clk}
   set_interface_property    av_st_reset                   PORT_NAME_MAP     {av_st_reset in_reset}

   if {$clocks_are_separate} {
     set_interface_property  av_mm_clock                   export_of         av_mm_clk_bridge.in_clk
     set_interface_property  av_mm_reset                   export_of         av_mm_reset_bridge.in_reset
     set_interface_property  av_mm_clock                   PORT_NAME_MAP     {av_mm_clock in_clk}
     set_interface_property  av_mm_reset                   PORT_NAME_MAP     {av_mm_reset in_reset}
   }

   set_interface_property    dout                          export_of         video_out.av_st_vid_dout

   if {$disable_embedded_stream_cleaner} { 
      set_interface_property    din                        export_of         video_in.av_st_vid_din
   } else {
      set_interface_property    din                        export_of         cleaner_video_in.av_st_vid_din   
   }
   
   set_interface_property    write_master                  export_of         packet_writer.av_mm_master
   set_interface_property    edi_read_master               export_of         edi_packet_reader.av_mm_master   
   set_interface_property    ma_read_master                export_of         ma_packet_reader.av_mm_master   
   set_interface_property    motion_write_master           export_of         motion_writer.av_mm_master
   set_interface_property    motion_read_master            export_of         motion_reader.av_mm_master   


   # --------------------------------------------------------------------------------------------------
   # -- Connecting clocks and resets                                                                 --
   # --------------------------------------------------------------------------------------------------

   
   
   add_connection            av_st_clk_bridge.out_clk            av_st_reset_bridge.clk
   
   if {$clocks_are_separate} {
     add_connection          av_mm_clk_bridge.out_clk            av_mm_reset_bridge.clk
   }
   
   if {$disable_embedded_stream_cleaner} { } else {
   add_connection            av_st_clk_bridge.out_clk            cleaner_video_in.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_video_in.main_reset
   add_connection            av_st_clk_bridge.out_clk            cleaner_core.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_core.main_reset
   add_connection            av_st_clk_bridge.out_clk            cleaner_video_out.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_video_out.main_reset
   add_connection            av_st_clk_bridge.out_clk            cleaner_scheduler.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_scheduler.main_reset
   }
   
  # Connect local chroma resampler clocks and resets : 
   if {$enable_embedded_crs_for_interlaced_video} { 
       add_connection        av_st_clk_bridge.out_clk            video_in_op0_444to422.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op0_444to422.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op1_444to422.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op1_444to422.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op3_444to422.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op3_444to422.main_reset
       
       add_connection        av_st_clk_bridge.out_clk            video_out_ip1_422to444.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip1_422to444.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_out_ip2_422to444.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip2_422to444.main_reset
   }       
   
   if {$enable_embedded_csc_for_interlaced_video} { 
       add_connection        av_st_clk_bridge.out_clk            video_in_op0_rgbtoycbcr.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op0_rgbtoycbcr.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op1_rgbtoycbcr.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op1_rgbtoycbcr.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op3_rgbtoycbcr.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op3_rgbtoycbcr.main_reset

       add_connection        av_st_clk_bridge.out_clk            video_out_ip1_ycbcrtorgb.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip1_ycbcrtorgb.main_reset
       
       add_connection        av_st_clk_bridge.out_clk            video_out_ip2_ycbcrtorgb.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip2_ycbcrtorgb.main_reset
   }
   
   # We always have BPS convertors inline
   add_connection        av_st_clk_bridge.out_clk            video_in_op0_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_in_op0_10bps_conv.main_reset

   add_connection        av_st_clk_bridge.out_clk            video_in_op1_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_in_op1_10bps_conv.main_reset

   add_connection        av_st_clk_bridge.out_clk            video_in_op3_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_in_op3_10bps_conv.main_reset

   add_connection        av_st_clk_bridge.out_clk            video_out_ip1_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_out_ip1_10bps_conv.main_reset

   add_connection        av_st_clk_bridge.out_clk            video_out_ip2_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_out_ip2_10bps_conv.main_reset   
   
   
   add_connection            av_st_clk_bridge.out_clk            video_in.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in.main_reset
   add_connection            av_st_clk_bridge.out_clk            dil_algo.main_clock
   add_connection            av_st_reset_bridge.out_reset        dil_algo.main_reset
   add_connection            av_st_clk_bridge.out_clk            motion_detect.main_clock
   add_connection            av_st_reset_bridge.out_reset        motion_detect.main_reset
   add_connection            av_st_clk_bridge.out_clk            video_out.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_out.main_reset
   add_connection            av_st_clk_bridge.out_clk            scheduler.main_clock
   add_connection            av_st_reset_bridge.out_reset        scheduler.main_reset
   
   if {$cadence_detect} {
      add_connection            av_st_clk_bridge.out_clk            ma_line_buffer_duplicator.main_clock
      add_connection            av_st_reset_bridge.out_reset        ma_line_buffer_duplicator.main_reset
      add_connection            av_st_clk_bridge.out_clk            cadence.main_clock
      add_connection            av_st_reset_bridge.out_reset        cadence.main_reset
   }

   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer.main_reset
   add_connection            av_st_clk_bridge.out_clk            ma_line_buffer.main_clock
   add_connection            av_st_reset_bridge.out_reset        ma_line_buffer.main_reset

   add_connection            av_st_clk_bridge.out_clk            packet_writer.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        packet_writer.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            edi_packet_reader.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        edi_packet_reader.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            ma_packet_reader.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        ma_packet_reader.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            motion_writer.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        motion_writer.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            motion_reader.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        motion_reader.av_st_reset

   add_connection            av_st_clk_bridge.out_clk            video_in_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_duplicator.main_reset
   
   add_connection            av_st_clk_bridge.out_clk            video_in_op0_pipNto1.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_op0_pipNto1.main_reset   
   add_connection            av_st_clk_bridge.out_clk            video_in_op1_pipNto1.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_op1_pipNto1.main_reset   
   add_connection            av_st_clk_bridge.out_clk            video_in_op3_pipNto1.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_op3_pipNto1.main_reset
   
   
   add_connection            av_st_clk_bridge.out_clk            edi_packet_reader_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_packet_reader_duplicator.main_reset
   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer_duplicator.main_reset
   add_connection            av_st_clk_bridge.out_clk            output_mux.main_clock
   add_connection            av_st_reset_bridge.out_reset        output_mux.main_reset
   add_connection            av_st_clk_bridge.out_clk            dil_algo_input_mux.main_clock
   add_connection            av_st_reset_bridge.out_reset        dil_algo_input_mux.main_reset

   add_connection            av_st_clk_bridge.out_clk            dil_algo_pip_convertor.main_clock
   add_connection            av_st_reset_bridge.out_reset        dil_algo_pip_convertor.main_reset

   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer_pip_convertor.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer_pip_convertor.main_reset
   
   if ($clocks_are_separate) {
     add_connection          av_mm_clk_bridge.out_clk            edi_packet_reader.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        edi_packet_reader.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            ma_packet_reader.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        ma_packet_reader.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            motion_reader.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        motion_reader.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            packet_writer.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        packet_writer.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            motion_writer.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        motion_writer.av_mm_reset
   } 
   
   # Make connections for new PIP convertors :
   add_connection            video_in_duplicator.av_st_dout_0    video_in_op0_pipNto1.av_st_din
   add_connection            video_in_duplicator.av_st_dout_1    video_in_op1_pipNto1.av_st_din
   add_connection            video_in_duplicator.av_st_dout_3    video_in_op3_pipNto1.av_st_din


   # --------------------------------------------------------------------------------------------------
   # -- Interblocks connections                                                                      --
   # --------------------------------------------------------------------------------------------------

   if {$disable_embedded_stream_cleaner} {    
   } else {
      add_connection            cleaner_video_in.av_st_resp                 cleaner_scheduler.av_st_vib_resp
      
      add_connection            cleaner_scheduler.av_st_vib_cmd             cleaner_video_in.av_st_cmd
      add_connection            cleaner_scheduler.av_st_ac_cmd              cleaner_core.av_st_cmd
      add_connection            cleaner_scheduler.av_st_vob_cmd             cleaner_video_out.av_st_cmd
      
      add_connection            cleaner_video_in.av_st_dout                 cleaner_core.av_st_din
      add_connection            cleaner_core.av_st_dout                     cleaner_video_out.av_st_din
      add_connection            cleaner_video_out.av_st_vid_dout            video_in.av_st_vid_din            
   }   
   
   add_connection            video_in.av_st_dout                         video_in_duplicator.av_st_din         
   add_connection            video_in_duplicator.av_st_dout_2            output_mux.av_st_din_0 
     
   if {$enable_embedded_crs_for_interlaced_video} { 
   
       # Input/output video needs CSC conversion and CRS :
       if {$enable_embedded_csc_for_interlaced_video} { 
   
          #send_message info "connecting pip convertors  + bps convertors to CSC+CRS "

          add_connection        video_in_op0_pipNto1.av_st_dout             video_in_op0_10bps_conv.av_st_din               
          add_connection        video_in_op0_10bps_conv.av_st_dout          video_in_op0_rgbtoycbcr.av_st_din               
          add_connection        video_in_op0_rgbtoycbcr.av_st_dout          video_in_op0_444to422.av_st_din               
          add_connection        video_in_op0_444to422.av_st_dout            packet_writer.av_st_din        

          add_connection        video_in_op1_pipNto1.av_st_dout             video_in_op1_10bps_conv.av_st_din   
          add_connection        video_in_op1_10bps_conv.av_st_dout          video_in_op1_rgbtoycbcr.av_st_din   
          add_connection        video_in_op1_rgbtoycbcr.av_st_dout          video_in_op1_444to422.av_st_din   
          add_connection        video_in_op1_444to422.av_st_dout            dil_algo_input_mux.av_st_din_0   

          add_connection        video_in_op3_pipNto1.av_st_dout             video_in_op3_10bps_conv.av_st_din  
          add_connection        video_in_op3_10bps_conv.av_st_dout          video_in_op3_rgbtoycbcr.av_st_din  
          add_connection        video_in_op3_rgbtoycbcr.av_st_dout          video_in_op3_444to422.av_st_din  
          add_connection        video_in_op3_444to422.av_st_dout            motion_detect.av_st_field3  

          add_connection        edi_line_buffer.av_st_dout_1                video_out_ip1_422to444.av_st_din         
          add_connection        video_out_ip1_422to444.av_st_dout           video_out_ip1_ycbcrtorgb.av_st_din    
          add_connection        video_out_ip1_ycbcrtorgb.av_st_dout         video_out_ip1_10bps_conv.av_st_din    
          add_connection        video_out_ip1_10bps_conv.av_st_dout         edi_line_buffer_pip_convertor.av_st_din    
          add_connection        edi_line_buffer_pip_convertor.av_st_dout    output_mux.av_st_din_1 

          add_connection        dil_algo.dout                               video_out_ip2_422to444.av_st_din  
          add_connection        video_out_ip2_422to444.av_st_dout           video_out_ip2_ycbcrtorgb.av_st_din
          add_connection        video_out_ip2_ycbcrtorgb.av_st_dout         video_out_ip2_10bps_conv.av_st_din
          add_connection        video_out_ip2_10bps_conv.av_st_dout         dil_algo_pip_convertor.av_st_din
          add_connection        dil_algo_pip_convertor.av_st_dout           output_mux.av_st_din_2     

       # Input/output video just needs CRS (no CSC) :
       } else {
          #send_message info "connecting pip convertors + bps convertors to CRS ONLY"
       
          add_connection        video_in_op0_pipNto1.av_st_dout             video_in_op0_10bps_conv.av_st_din               
          add_connection        video_in_op0_10bps_conv.av_st_dout          video_in_op0_444to422.av_st_din               
          add_connection        video_in_op0_444to422.av_st_dout            packet_writer.av_st_din        

          add_connection        video_in_op1_pipNto1.av_st_dout             video_in_op1_10bps_conv.av_st_din   
          add_connection        video_in_op1_10bps_conv.av_st_dout          video_in_op1_444to422.av_st_din   
          add_connection        video_in_op1_444to422.av_st_dout            dil_algo_input_mux.av_st_din_0   

          add_connection        video_in_op3_pipNto1.av_st_dout             video_in_op3_10bps_conv.av_st_din  
          add_connection        video_in_op3_10bps_conv.av_st_dout          video_in_op3_444to422.av_st_din  
          add_connection        video_in_op3_444to422.av_st_dout            motion_detect.av_st_field3  

          add_connection        edi_line_buffer.av_st_dout_1                video_out_ip1_422to444.av_st_din         
          add_connection        video_out_ip1_422to444.av_st_dout           video_out_ip1_10bps_conv.av_st_din    
          add_connection        video_out_ip1_10bps_conv.av_st_dout         edi_line_buffer_pip_convertor.av_st_din    
          add_connection        edi_line_buffer_pip_convertor.av_st_dout    output_mux.av_st_din_1 

          add_connection        dil_algo.dout                               video_out_ip2_422to444.av_st_din  
          add_connection        video_out_ip2_422to444.av_st_dout           video_out_ip2_10bps_conv.av_st_din
          add_connection        video_out_ip2_10bps_conv.av_st_dout         dil_algo_pip_convertor.av_st_din
          add_connection        dil_algo_pip_convertor.av_st_dout           output_mux.av_st_din_2     
                        
       }        
            
   # No CRS or CSC required :             
   } else {
   
       #send_message info "connecting pip convertors  + bps convertors directly to components"
   
       add_connection        video_in_op0_pipNto1.av_st_dout             video_in_op0_10bps_conv.av_st_din               
       add_connection        video_in_op0_10bps_conv.av_st_dout          packet_writer.av_st_din               
       
       add_connection        video_in_op1_pipNto1.av_st_dout             video_in_op1_10bps_conv.av_st_din   
       add_connection        video_in_op1_10bps_conv.av_st_dout          dil_algo_input_mux.av_st_din_0   
       
       add_connection        video_in_op3_pipNto1.av_st_dout             video_in_op3_10bps_conv.av_st_din   
       add_connection        video_in_op3_10bps_conv.av_st_dout          motion_detect.av_st_field3   
         
       add_connection        edi_line_buffer.av_st_dout_1                video_out_ip1_10bps_conv.av_st_din              
       add_connection        video_out_ip1_10bps_conv.av_st_dout         edi_line_buffer_pip_convertor.av_st_din              
       add_connection        edi_line_buffer_pip_convertor.av_st_dout    output_mux.av_st_din_1   
       
       add_connection        dil_algo.dout                               video_out_ip2_10bps_conv.av_st_din
       add_connection        video_out_ip2_10bps_conv.av_st_dout         dil_algo_pip_convertor.av_st_din
       add_connection        dil_algo_pip_convertor.av_st_dout           output_mux.av_st_din_2
                     
   }

   #13.0 Connect 'future' field path from input duplicator to dil algo input mux :
   add_connection            edi_packet_reader.av_st_dout                edi_packet_reader_duplicator.av_st_din
   
   # 13.0 Add connection for field read from memory instead of video input bridge :   
   # 13.0 add_connection            edi_packet_reader_duplicator.av_st_dout_0   dil_algo.din_weave  
   add_connection            edi_packet_reader_duplicator.av_st_dout_0   dil_algo_input_mux.av_st_din_1      
   add_connection            edi_packet_reader_duplicator.av_st_dout_1   motion_detect.av_st_field1 
   add_connection            edi_packet_reader_duplicator.av_st_dout_2   edi_line_buffer.av_st_din        

   add_connection            edi_line_buffer.av_st_dout_0                edi_line_buffer_duplicator.av_st_din                              

                             
   # 13.0 The DilAlgo now has a mux to switch between past and future fields for weave :                      
   add_connection            dil_algo_input_mux.av_st_dout               dil_algo.din_weave
   
   add_connection            edi_line_buffer_duplicator.av_st_dout_0     dil_algo.din_bob
   add_connection            edi_line_buffer_duplicator.av_st_dout_1     motion_detect.av_st_field0  
   
   #add_connection            ma_packet_reader.av_st_dout                 ma_packet_reader_duplicator.av_st_din   
   add_connection            ma_packet_reader.av_st_dout                 ma_line_buffer.av_st_din   
   
   #13.0 no need for duplicator, as motion detect now using the future field :
   #add_connection            ma_packet_reader_duplicator.av_st_dout_0    ma_line_buffer.av_st_din            
   #add_connection            ma_packet_reader_duplicator.av_st_dout_1    motion_detect.av_st_field3            

   if {$cadence_detect} {
      add_connection         ma_line_buffer.av_st_dout_0                 ma_line_buffer_duplicator.av_st_din                           
      add_connection         ma_line_buffer_duplicator.av_st_dout_0      motion_detect.av_st_field2
   } else {
      add_connection         ma_line_buffer.av_st_dout_0                 motion_detect.av_st_field2
   }
   

   add_connection            motion_reader.av_st_dout                    motion_detect.av_st_mem_motion_in
   add_connection            motion_detect.av_st_algo_motion_out         dil_algo.din_motion
   add_connection            motion_detect.av_st_mem_motion_out          motion_writer.av_st_din       

   add_connection            output_mux.av_st_dout                       video_out.av_st_din                   

   if {$cadence_detect} {
      add_connection            edi_line_buffer_duplicator.av_st_dout_2     cadence.av_st_field0         
      add_connection            edi_packet_reader_duplicator.av_st_dout_3   cadence.av_st_field1         
      add_connection            ma_line_buffer_duplicator.av_st_dout_1      cadence.av_st_field2         
   }
   

   # --------------------------------------------------------------------------------------------------
   # -- Scheduler connections                                                                        --
   # --------------------------------------------------------------------------------------------------
   add_connection            scheduler.cmd0                      video_in.av_st_cmd 
   add_connection            scheduler.cmd1                      video_out.av_st_cmd 
   add_connection            scheduler.cmd2                      edi_line_buffer.av_st_cmd 
   add_connection            scheduler.cmd3                      packet_writer.av_st_cmd 
   add_connection            scheduler.cmd4                      edi_packet_reader.av_st_cmd 
   add_connection            scheduler.cmd5                      dil_algo.cmd 
   add_connection            scheduler.cmd6                      ma_line_buffer.av_st_cmd 
   add_connection            scheduler.cmd7                      motion_writer.av_st_cmd 
   add_connection            scheduler.cmd8                      ma_packet_reader.av_st_cmd 
   add_connection            scheduler.cmd9                      motion_reader.av_st_cmd 
   add_connection            scheduler.cmd11                     motion_detect.av_st_cmd
   add_connection            scheduler.cmd13                     output_mux.av_st_cmd
   add_connection            scheduler.cmd14                     dil_algo_input_mux.av_st_cmd

   add_connection            video_in.av_st_resp                 scheduler.resp0 
   add_connection            motion_detect.av_st_resp            scheduler.resp3 

   if {$cadence_detect} {
      add_connection         cadence.resp                        scheduler.resp1
      add_connection         scheduler.cmd10                     cadence.cmd
   } 

   if {$runtime_control} {
      add_connection         scheduler.cmd12                     control.av_st_cmd
      add_connection         control.av_st_resp                  scheduler.resp2    
   } 

}

proc dil2_composition_callback_instantiation {} {
   global isVersion acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol                 [get_parameter_value BITS_PER_SYMBOL]
    set bits_per_symbol_core            [get_parameter_value BITS_PER_SYMBOL]
    
    set is_422                          [get_parameter_value IS_422]
    set color_planes_are_in_parallel    [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set number_of_color_planes          [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set pixels_in_parallel              [get_parameter_value PIXELS_IN_PARALLEL]
   
    set max_width_interlaced            [get_parameter_value MAX_WIDTH]
    set max_height_interlaced           [get_parameter_value MAX_HEIGHT]
   
    set max_width_progressive           4096
    set max_height_progressive          2160
    
    set deinterlace_algorithm           [get_parameter_value DEINTERLACE_ALGORITHM]
    set cadence_detect                  [get_parameter_value CADENCE_DETECTION]
    set cadence_algo                    [get_parameter_value CADENCE_ALGORITHM_NAME]
    set motion_bps                      [get_parameter_value MOTION_BPS]
    set runtime_control                 [get_parameter_value RUNTIME_CONTROL]
    set disable_embedded_stream_cleaner [get_parameter_value DISABLE_EMBEDDED_STREAM_CLEANER]

    set clocks_are_separate             [get_parameter_value CLOCKS_ARE_SEPARATE]   
    set mem_port_width                  [get_parameter_value MEM_PORT_WIDTH]    
    set base_addr                       [get_parameter_value MEM_BASE_ADDR]
    set field_buffer_size               [get_parameter_value FIELD_BUFFER_SIZE_IN_BYTES]
    set motion_field_buffer_size        [get_parameter_value MOTION_BUFFER_SIZE_IN_BYTES]  
    set line_buffer_size                [get_parameter_value LINE_BUFFER_SIZE] 
    set motion_line_buffer_size         [get_parameter_value MOTION_LINE_BUFFER_SIZE]

    set write_master_fifo_depth         [get_parameter_value WRITE_MASTER_FIFO_DEPTH]    
    set write_master_burst_target       [get_parameter_value WRITE_MASTER_BURST_TARGET]    
    set edi_read_master_fifo_depth      [get_parameter_value EDI_READ_MASTER_FIFO_DEPTH]    
    set edi_read_master_burst_target    [get_parameter_value EDI_READ_MASTER_BURST_TARGET]    
    set ma_read_master_fifo_depth       [get_parameter_value MA_READ_MASTER_FIFO_DEPTH]    
    set ma_read_master_burst_target     [get_parameter_value MA_READ_MASTER_BURST_TARGET]    
    set motion_write_fifo_depth         [get_parameter_value MOTION_WRITE_MASTER_FIFO_DEPTH]    
    set motion_write_burst_target       [get_parameter_value MOTION_WRITE_MASTER_BURST_TARGET]    
    set motion_read_fifo_depth          [get_parameter_value MOTION_READ_MASTER_FIFO_DEPTH]    
    set motion_read_burst_target        [get_parameter_value MOTION_READ_MASTER_BURST_TARGET]


    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set symbols_in_seq               [expr $color_planes_are_in_parallel == 0 ? $number_of_color_planes : 1]
    set symbols_in_par               [expr $color_planes_are_in_parallel == 1 ? $number_of_color_planes : 1]
    if { $color_planes_are_in_parallel == 0 } {
       set video_data_width          $bits_per_symbol
    } else {
       set video_data_width         [expr $bits_per_symbol * $symbols_in_par]
    }
   
    set comp [string compare $deinterlace_algorithm "MOTION_ADAPTIVE_HQ"]
    if { $comp == 0 } {
       set selected_algorithm   alt_vip_dil_low_angle_algorithm
       set selected_scheduler   alt_vip_dil_sobel_scheduler
       set selected_vib_mode    "LEGACY"
       set high_quality_line_multiplier 2
       send_message info "Deinterlacer II motion adaptive mode with HQ (Sobel) edge detection configured"
       
    } else {
       set selected_algorithm   alt_vip_dil_algorithm
       set selected_scheduler   alt_vip_dil_scheduler
       set selected_vib_mode    "FULL"
       set high_quality_line_multiplier 1
       send_message info "Deinterlacer II motion adaptive mode configured"
       
    }   
 
    set max_line_sample_size         [expr $max_width_interlaced * ($color_planes_are_in_parallel ? 1 : $number_of_color_planes)]
    set max_field_height             [expr ($max_height_interlaced+1)/2]

    set width_modulo                 [expr $is_422 ? 2 : 1]
   
   set enable_embedded_crs_for_interlaced_video             [get_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO]
   set enable_embedded_csc_for_interlaced_video             [get_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO]
   
   # --------------------------------------------------------------------------------------------------
   # -- Clocks/reset                                                                                 --
   # --------------------------------------------------------------------------------------------------
   add_instance              av_st_clk_bridge                   altera_clock_bridge $acdsVersion
   add_instance              av_st_reset_bridge                 altera_reset_bridge $acdsVersion
   
   if {$clocks_are_separate} {
     add_instance            av_mm_clk_bridge                   altera_clock_bridge $acdsVersion
     add_instance            av_mm_reset_bridge                 altera_reset_bridge $acdsVersion
   }


   # --------------------------------------------------------------------------------------------------
   # -- Main components                                                                              --
   # --------------------------------------------------------------------------------------------------

   if {$disable_embedded_stream_cleaner} {
   
   } else {
   # Embedded stream cleaner   

   add_instance                   cleaner_video_in         alt_vip_video_input_bridge       $isVersion                    
   set_instance_parameter_value   cleaner_video_in         PIXELS_IN_PARALLEL               $pixels_in_parallel           
   set_instance_parameter_value   cleaner_video_in         BITS_PER_SYMBOL                  $bits_per_symbol              
   set_instance_parameter_value   cleaner_video_in         NUMBER_OF_COLOR_PLANES           $number_of_color_planes       
   set_instance_parameter_value   cleaner_video_in         COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel 
   set_instance_parameter_value   cleaner_video_in         DEFAULT_LINE_LENGTH              $max_width_progressive        
   set_instance_parameter_value   cleaner_video_in         VIB_MODE                         FULL                          
   set_instance_parameter_value   cleaner_video_in         VIDEO_PROTOCOL_NO                1                             
   set_instance_parameter_value   cleaner_video_in         READY_LATENCY_1                  1                             
   set_instance_parameter_value   cleaner_video_in         PIPELINE_READY                   0                             
   set_instance_parameter_value   cleaner_video_in         MULTI_CONTEXT_SUPPORT            0                             
   set_instance_parameter_value   cleaner_video_in         SRC_WIDTH                        8                             
   set_instance_parameter_value   cleaner_video_in         DST_WIDTH                        8                             
   set_instance_parameter_value   cleaner_video_in         CONTEXT_WIDTH                    8                             
   set_instance_parameter_value   cleaner_video_in         TASK_WIDTH                       8                             
   set_instance_parameter_value   cleaner_video_in         RESP_SRC_ADDRESS                 0                             
   set_instance_parameter_value   cleaner_video_in         RESP_DST_ADDRESS                 0                             
   set_instance_parameter_value   cleaner_video_in         DATA_SRC_ADDRESS                 0                             
                                                                                                                                                                                                                                                                                                                                                                        
   add_instance                   cleaner_core             alt_vip_stream_cleaner_alg_core  $isVersion                              
   set_instance_parameter_value   cleaner_core             BITS_PER_SYMBOL                  $bits_per_symbol
   set_instance_parameter_value   cleaner_core             NUMBER_OF_COLOR_PLANES           $number_of_color_planes
   set_instance_parameter_value   cleaner_core             COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel
   set_instance_parameter_value   cleaner_core             PIXELS_IN_PARALLEL               $pixels_in_parallel
   set_instance_parameter_value   cleaner_core             MAX_LINE_LENGTH                  $max_width_progressive    
   set_instance_parameter_value   cleaner_core             PIPELINE_READY                   0
   set_instance_parameter_value   cleaner_core             SRC_WIDTH                        8
   set_instance_parameter_value   cleaner_core             DST_WIDTH                        8
   set_instance_parameter_value   cleaner_core             CONTEXT_WIDTH                    8
   set_instance_parameter_value   cleaner_core             TASK_WIDTH                       8
   set_instance_parameter_value   cleaner_core             DATA_SRC_ADDRESS                 0
        
   add_instance                   cleaner_video_out        alt_vip_video_output_bridge      $isVersion          
   set_instance_parameter_value   cleaner_video_out        BITS_PER_SYMBOL                  $bits_per_symbol
   set_instance_parameter_value   cleaner_video_out        PIXELS_IN_PARALLEL               $pixels_in_parallel
   set_instance_parameter_value   cleaner_video_out        NUMBER_OF_COLOR_PLANES           $number_of_color_planes
   set_instance_parameter_value   cleaner_video_out        COLOR_PLANES_ARE_IN_PARALLEL     $color_planes_are_in_parallel
   set_instance_parameter_value   cleaner_video_out        READY_LATENCY_1                  1
   set_instance_parameter_value   cleaner_video_out        SOP_PRE_ALIGNED                  0
   set_instance_parameter_value   cleaner_video_out        NO_CONCATENATION                 0
   set_instance_parameter_value   cleaner_video_out        MULTI_CONTEXT_SUPPORT            0
   set_instance_parameter_value   cleaner_video_out        VIDEO_PROTOCOL_NO                1
   set_instance_parameter_value   cleaner_video_out        SRC_WIDTH                        8
   set_instance_parameter_value   cleaner_video_out        DST_WIDTH                        8
   set_instance_parameter_value   cleaner_video_out        CONTEXT_WIDTH                    8
   set_instance_parameter_value   cleaner_video_out        TASK_WIDTH                       8   
                              
   add_instance                   cleaner_scheduler        alt_vip_stream_cleaner_scheduler $isVersion                                     
   set_instance_parameter_value   cleaner_scheduler        ENABLE_CONTROL_SLAVE             0
   set_instance_parameter_value   cleaner_scheduler        EVEN_FRONT_CLIP                  0
   set_instance_parameter_value   cleaner_scheduler        WIDTH_MODULO                     $width_modulo
   set_instance_parameter_value   cleaner_scheduler        MAX_WIDTH                        $max_width_progressive
   set_instance_parameter_value   cleaner_scheduler        MIN_WIDTH                        32
   set_instance_parameter_value   cleaner_scheduler        MAX_HEIGHT                       $max_height_progressive
   set_instance_parameter_value   cleaner_scheduler        MIN_HEIGHT                       32
   set_instance_parameter_value   cleaner_scheduler        PIPELINE_READY                   0
   set_instance_parameter_value   cleaner_scheduler        REMOVE_4KI                       1
   set_instance_parameter_value   cleaner_scheduler        SRC_WIDTH                        8
   set_instance_parameter_value   cleaner_scheduler        DST_WIDTH                        8
   set_instance_parameter_value   cleaner_scheduler        CONTEXT_WIDTH                    8
   set_instance_parameter_value   cleaner_scheduler        TASK_WIDTH                       8   

   # End stream cleaner
   }


   # The video input bridge
   add_instance                   video_in                      alt_vip_video_input_bridge   $isVersion
   set_instance_parameter_value   video_in                      BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_in                      COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_in                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_in                      DEFAULT_LINE_LENGTH          $max_width_progressive
   set_instance_parameter_value   video_in                      PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   video_in                      VIB_MODE                     $selected_vib_mode

   # The MA algorithm
   add_instance                   dil_algo                      $selected_algorithm          $isVersion
   set_instance_parameter_value   dil_algo                      BITS_PER_SYMBOL              $bits_per_symbol_core  
   set_instance_parameter_value   dil_algo                      COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   dil_algo                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes   
   set_instance_parameter_value   dil_algo                      IS_422                       $is_422

   # The motion detection/motion bleed block, used by the MA algorithm
   add_instance                   motion_detect                 alt_vip_motion_detect        $isVersion
   set_instance_parameter_value   motion_detect                 BITS_PER_SYMBOL              $bits_per_symbol_core   
   set_instance_parameter_value   motion_detect                 COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   motion_detect                 NUMBER_OF_COLOR_PLANES       $number_of_color_planes   
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_0                [expr 2*$high_quality_line_multiplier]
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_1                1
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_2                2
   set_instance_parameter_value   motion_detect                 KERNEL_SIZE_3                1
   set_instance_parameter_value   motion_detect                 MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   motion_detect                 MOTION_BPS                   $motion_bps   

   # Video output bridge   
   add_instance                   video_out                     alt_vip_video_output_bridge  $isVersion
   set_instance_parameter_value   video_out                     BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_out                     COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_out                     NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_out                     PIXELS_IN_PARALLEL           $pixels_in_parallel

   # The scheduler
   add_instance                   scheduler                     $selected_scheduler          $isVersion
   set_instance_parameter_value   scheduler                     BUFFER0_BASE                 $base_addr
   set_instance_parameter_value   scheduler                     BUFFER1_BASE                 [expr $base_addr + $field_buffer_size]
   set_instance_parameter_value   scheduler                     BUFFER2_BASE                 [expr $base_addr + 2*$field_buffer_size]
   set_instance_parameter_value   scheduler                     BUFFER3_BASE                 [expr $base_addr + 3*$field_buffer_size]
   set_instance_parameter_value   scheduler                     MOTION_BUFFER_BASE           [expr $base_addr + 4*$field_buffer_size]
   set_instance_parameter_value   scheduler                     CADENCE_DETECTION            $cadence_detect
   set_instance_parameter_value   scheduler                     RUNTIME_CONTROL              $runtime_control
   set_instance_parameter_value   scheduler                     LINE_OFFSET_BYTES            $line_buffer_size
   set_instance_parameter_value   scheduler                     MOTION_LINE_OFFSET_BYTES     $motion_line_buffer_size
   set_instance_parameter_value   scheduler                     MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   scheduler                     MAX_FIELD_HEIGHT             $max_field_height

   # Cadence detector
   # NB. The cadence detector ignores half the lines from the EDI line buffer...
   if {$cadence_detect} {
      add_instance                   cadence                    alt_vip_cadence_detect       $isVersion
      set_instance_parameter_value   cadence                    BITS_PER_SYMBOL              $bits_per_symbol_core   
      set_instance_parameter_value   cadence                    COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
      set_instance_parameter_value   cadence                    NUMBER_OF_COLOR_PLANES       $number_of_color_planes   
      set_instance_parameter_value   cadence                    KERNEL_SIZE_0                [expr 2*$high_quality_line_multiplier]
      set_instance_parameter_value   cadence                    KERNEL_SIZE_1                1
      set_instance_parameter_value   cadence                    KERNEL_SIZE_2                2
      set_instance_parameter_value   cadence                    CADENCE_ALGORITHM_NAME       $cadence_algo
      set_instance_parameter_value   cadence                    MAX_LINE_LENGTH              $max_line_sample_size
      set_instance_parameter_value   cadence                    MAX_FIELD_HEIGHT             $max_height_interlaced
   }

   if {$runtime_control} {
   
      add_instance                   control                    alt_vip_control_slave          $isVersion
      set_instance_parameter_value   control                    NUM_READ_REGISTERS             0
      set_instance_parameter_value   control                    NUM_TRIGGER_REGISTERS          16
     #9 here was 1 in 11.1 :
      set_instance_parameter_value   control                    NUM_RW_REGISTERS               1 
      set_instance_parameter_value   control                    NUM_INTERRUPTS                 0
      set_instance_parameter_value   control                    MM_CONTROL_REG_BYTES           1
      set_instance_parameter_value   control                    MM_READ_REG_BYTES              4            
      set_instance_parameter_value   control                    DATA_INPUT                     0
      set_instance_parameter_value   control                    DATA_OUTPUT                    0 
      set_instance_parameter_value   control                    FAST_REGISTER_UPDATES          0
      set_instance_parameter_value   control                    USE_MEMORY                     0
      set_instance_parameter_value   control                    PIPELINE_READ                  0
      set_instance_parameter_value   control                    PIPELINE_RESPONSE              0
      set_instance_parameter_value   control                    PIPELINE_DATA                  0
      set_instance_parameter_value   control                    SRC_WIDTH                      8 
      set_instance_parameter_value   control                    DST_WIDTH                      8
      set_instance_parameter_value   control                    CONTEXT_WIDTH                  8
      set_instance_parameter_value   control                    TASK_WIDTH                     8
      set_instance_parameter_value   control                    RESP_SOURCE                    1
      set_instance_parameter_value   control                    RESP_DEST                      1
      set_instance_parameter_value   control                    RESP_CONTEXT                   1
      set_instance_parameter_value   control                    DOUT_SOURCE                    1
      set_instance_parameter_value   control                    NUM_BLOCKING_TRIGGER_REGISTERS 0     
      set_instance_parameter_value   control                    MM_TRIGGER_REG_BYTES           4
      set_instance_parameter_value   control                    MM_RW_REG_BYTES                4
      set_instance_parameter_value   control                    MM_ADDR_WIDTH                  5
 
      add_connection   av_st_reset_bridge.out_reset             control.main_reset
      add_connection   av_st_clk_bridge.out_clk                 control.main_clock
   }

   # --------------------------------------------------------------------------------------------------
   # -- Line buffers                                                                                 --
   # --------------------------------------------------------------------------------------------------   
   
   # The EDI line buffer
   
   # ENABLE_RECEIVE_ONLY_CMD setting is irrelevant as not in "LOCKED" mode
   # NB. Center params here are irrelvant as the line buffer only sends when it is full :
   add_instance                   edi_line_buffer               alt_vip_line_buffer          $isVersion
   set_instance_parameter_value   edi_line_buffer               PIXEL_WIDTH                  $video_data_width
   set_instance_parameter_value   edi_line_buffer               SYMBOLS_IN_SEQ               $symbols_in_seq
   set_instance_parameter_value   edi_line_buffer               MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   edi_line_buffer               OUTPUT_PORTS                 2
   set_instance_parameter_value   edi_line_buffer               MODE                         "RATE_MATCHING"
   set_instance_parameter_value   edi_line_buffer               OUTPUT_MUX_SEL               "VARIABLE"
   set_instance_parameter_value   edi_line_buffer               ENABLE_RECEIVE_ONLY_CMD      1
   set_instance_parameter_value   edi_line_buffer               FIFO_SIZE                    16
   set_instance_parameter_value   edi_line_buffer               KERNEL_SIZE_0                [expr 2*$high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_CENTER_0              [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_SIZE_1                1
   set_instance_parameter_value   edi_line_buffer               KERNEL_START_1               [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_CENTER_1              [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               SRC_WIDTH                    8 
   set_instance_parameter_value   edi_line_buffer               DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer               CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer               TASK_WIDTH                   8
 

   # The MA line buffer
   add_instance                   ma_line_buffer                alt_vip_line_buffer          $isVersion
   set_instance_parameter_value   ma_line_buffer                PIXEL_WIDTH                  $video_data_width
   set_instance_parameter_value   ma_line_buffer                SYMBOLS_IN_SEQ               $symbols_in_seq 
   set_instance_parameter_value   ma_line_buffer                MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   ma_line_buffer                OUTPUT_PORTS                 2           
   set_instance_parameter_value   ma_line_buffer                MODE                         "LOCKED"
   set_instance_parameter_value   ma_line_buffer                OUTPUT_MUX_SEL               "OLD"
   set_instance_parameter_value   ma_line_buffer                ENABLE_RECEIVE_ONLY_CMD      1
   set_instance_parameter_value   ma_line_buffer                FIFO_SIZE                    16
   set_instance_parameter_value   ma_line_buffer                KERNEL_SIZE_0                2
   set_instance_parameter_value   ma_line_buffer                KERNEL_CENTER_0              1
   set_instance_parameter_value   ma_line_buffer                KERNEL_SIZE_1                1
   set_instance_parameter_value   ma_line_buffer                KERNEL_START_1               1
   set_instance_parameter_value   ma_line_buffer                KERNEL_CENTER_1              1
   set_instance_parameter_value   ma_line_buffer                SRC_WIDTH                    8 
   set_instance_parameter_value   ma_line_buffer                DST_WIDTH                    8
   set_instance_parameter_value   ma_line_buffer                CONTEXT_WIDTH                8
   set_instance_parameter_value   ma_line_buffer                TASK_WIDTH                   8
     

   # --------------------------------------------------------------------------------------------------
   # -- Packet writers and packet readers                                                            --
   # --------------------------------------------------------------------------------------------------



   # New packet transfer !
   add_instance                   packet_writer                 alt_vip_packet_transfer
   set_instance_parameter_value   packet_writer                 DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol_core * $number_of_color_planes) : $bits_per_symbol_core]
   set_instance_parameter_value   packet_writer                 SYMBOLS_IN_SEQ                     $symbols_in_seq
   set_instance_parameter_value   packet_writer                 MEM_PORT_WIDTH                     $mem_port_width
   set_instance_parameter_value   packet_writer                 MEM_ADDR_WIDTH                     32
   set_instance_parameter_value   packet_writer                 CLOCKS_ARE_SEPARATE                $clocks_are_separate
   set_instance_parameter_value   packet_writer                 WRITE_ENABLE                       1
   set_instance_parameter_value   packet_writer                 READ_ENABLE                        0
   set_instance_parameter_value   packet_writer                 MAX_CONTEXT_NUMBER_WRITE           1
   set_instance_parameter_value   packet_writer                 CONTEXT_BUFFER_RATIO_WRITE         [expr $write_master_fifo_depth / $write_master_burst_target]
   set_instance_parameter_value   packet_writer                 BURST_TARGET_WRITE                 $write_master_burst_target
   set_instance_parameter_value   packet_writer                 MAX_PACKET_SIZE_WRITE              $max_width_interlaced
   set_instance_parameter_value   packet_writer                 MAX_PACKET_NUM_WRITE               1
   set_instance_parameter_value   packet_writer                 ENABLE_MANY_COMMAND_WRITE          0
   set_instance_parameter_value   packet_writer                 ENABLE_PERIOD_MODE_WRITE           0
   set_instance_parameter_value   packet_writer                 ENABLE_MM_OUTPUT_REGISTER          1
   set_instance_parameter_value   packet_writer                 SUPPORT_BEATS_OVERFLOW_PRETECTION  0
   set_instance_parameter_value   packet_writer                 USE_RESPONSE_WRITE                 0           

   # New packet transfer !
   add_instance                   edi_packet_reader             alt_vip_packet_transfer
   set_instance_parameter_value   edi_packet_reader             DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol_core * $number_of_color_planes) : $bits_per_symbol_core]
   set_instance_parameter_value   edi_packet_reader             SYMBOLS_IN_SEQ                     $symbols_in_seq
   set_instance_parameter_value   edi_packet_reader             MEM_PORT_WIDTH                     $mem_port_width
   set_instance_parameter_value   edi_packet_reader             MEM_ADDR_WIDTH                     32
   set_instance_parameter_value   edi_packet_reader             CLOCKS_ARE_SEPARATE                $clocks_are_separate
   set_instance_parameter_value   edi_packet_reader             WRITE_ENABLE                       0
   set_instance_parameter_value   edi_packet_reader             READ_ENABLE                        1
   set_instance_parameter_value   edi_packet_reader             MAX_CONTEXT_NUMBER_READ            1
   set_instance_parameter_value   edi_packet_reader             CONTEXT_BUFFER_RATIO_READ          [expr $edi_read_master_fifo_depth / $edi_read_master_burst_target]
   set_instance_parameter_value   edi_packet_reader             BURST_TARGET_READ                  $edi_read_master_burst_target
   set_instance_parameter_value   edi_packet_reader             MAX_PACKET_SIZE_READ               $max_width_interlaced
   set_instance_parameter_value   edi_packet_reader             ENABLE_MANY_COMMAND_READ           0
   set_instance_parameter_value   edi_packet_reader             ENABLE_PERIOD_MODE_READ            0
   set_instance_parameter_value   edi_packet_reader             ENABLE_MM_OUTPUT_REGISTER          1
   set_instance_parameter_value   edi_packet_reader             SUPPORT_BEATS_OVERFLOW_PRETECTION  0
  
   # New packet transfer !
   add_instance                   ma_packet_reader              alt_vip_packet_transfer
   set_instance_parameter_value   ma_packet_reader              DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol_core * $number_of_color_planes) : $bits_per_symbol_core]
   set_instance_parameter_value   ma_packet_reader              SYMBOLS_IN_SEQ                     $symbols_in_seq
   set_instance_parameter_value   ma_packet_reader              MEM_PORT_WIDTH                     $mem_port_width
   set_instance_parameter_value   ma_packet_reader              MEM_ADDR_WIDTH                     32
   set_instance_parameter_value   ma_packet_reader              CLOCKS_ARE_SEPARATE                $clocks_are_separate
   set_instance_parameter_value   ma_packet_reader              WRITE_ENABLE                       0
   set_instance_parameter_value   ma_packet_reader              READ_ENABLE                        1
   set_instance_parameter_value   ma_packet_reader              MAX_CONTEXT_NUMBER_READ            1
   set_instance_parameter_value   ma_packet_reader              CONTEXT_BUFFER_RATIO_READ         [expr $ma_read_master_fifo_depth / $ma_read_master_burst_target]
   set_instance_parameter_value   ma_packet_reader              BURST_TARGET_READ                  $ma_read_master_burst_target
   set_instance_parameter_value   ma_packet_reader              MAX_PACKET_SIZE_READ               $max_width_interlaced
   set_instance_parameter_value   ma_packet_reader              ENABLE_MANY_COMMAND_READ           0
   set_instance_parameter_value   ma_packet_reader              ENABLE_PERIOD_MODE_READ            0
   set_instance_parameter_value   ma_packet_reader              ENABLE_MM_OUTPUT_REGISTER          1
   set_instance_parameter_value   ma_packet_reader              SUPPORT_BEATS_OVERFLOW_PRETECTION  0   

   # New packet transfer !
   add_instance                   motion_writer                 alt_vip_packet_transfer
   set_instance_parameter_value   motion_writer                 DATA_WIDTH                         16
   set_instance_parameter_value   motion_writer                 SYMBOLS_IN_SEQ                     1
   set_instance_parameter_value   motion_writer                 MEM_PORT_WIDTH                     $mem_port_width
   set_instance_parameter_value   motion_writer                 MEM_ADDR_WIDTH                     32
   set_instance_parameter_value   motion_writer                 CLOCKS_ARE_SEPARATE                $clocks_are_separate
   set_instance_parameter_value   motion_writer                 WRITE_ENABLE                       1
   set_instance_parameter_value   motion_writer                 READ_ENABLE                        0
   set_instance_parameter_value   motion_writer                 MAX_CONTEXT_NUMBER_WRITE           1
   set_instance_parameter_value   motion_writer                 CONTEXT_BUFFER_RATIO_WRITE         [expr $motion_write_fifo_depth / $motion_write_burst_target]
   set_instance_parameter_value   motion_writer                 BURST_TARGET_WRITE                 $motion_write_burst_target
   set_instance_parameter_value   motion_writer                 MAX_PACKET_SIZE_WRITE              $max_width_interlaced
   set_instance_parameter_value   motion_writer                 MAX_PACKET_NUM_WRITE               1
   set_instance_parameter_value   motion_writer                 ENABLE_MANY_COMMAND_WRITE          0
   set_instance_parameter_value   motion_writer                 ENABLE_PERIOD_MODE_WRITE           0
   set_instance_parameter_value   motion_writer                 ENABLE_MM_OUTPUT_REGISTER          1
   set_instance_parameter_value   motion_writer                 SUPPORT_BEATS_OVERFLOW_PRETECTION  0
   set_instance_parameter_value   motion_writer                 USE_RESPONSE_WRITE                 0      
      
   
   # New packet transfer !
   add_instance                   motion_reader                 alt_vip_packet_transfer
   set_instance_parameter_value   motion_reader                 DATA_WIDTH                         16
   set_instance_parameter_value   motion_reader                 SYMBOLS_IN_SEQ                     1
   set_instance_parameter_value   motion_reader                 MEM_PORT_WIDTH                     $mem_port_width
   set_instance_parameter_value   motion_reader                 MEM_ADDR_WIDTH                     32
   set_instance_parameter_value   motion_reader                 CLOCKS_ARE_SEPARATE                $clocks_are_separate
   set_instance_parameter_value   motion_reader                 WRITE_ENABLE                       0
   set_instance_parameter_value   motion_reader                 READ_ENABLE                        1
   set_instance_parameter_value   motion_reader                 MAX_CONTEXT_NUMBER_READ            1
   set_instance_parameter_value   motion_reader                 CONTEXT_BUFFER_RATIO_READ          [expr $motion_read_fifo_depth / $motion_read_burst_target]
   set_instance_parameter_value   motion_reader                 BURST_TARGET_READ                  $motion_read_burst_target
   set_instance_parameter_value   motion_reader                 MAX_PACKET_SIZE_READ               $max_width_interlaced
   set_instance_parameter_value   motion_reader                 ENABLE_MANY_COMMAND_READ           0
   set_instance_parameter_value   motion_reader                 ENABLE_PERIOD_MODE_READ            0
   set_instance_parameter_value   motion_reader                 ENABLE_MM_OUTPUT_REGISTER          1
   set_instance_parameter_value   motion_reader                 SUPPORT_BEATS_OVERFLOW_PRETECTION  0
  

   # --------------------------------------------------------------------------------------------------
   # -- Routing, duplicator and muxes                                                                --
   # --------------------------------------------------------------------------------------------------

   # The video input duplicator (-> packet writer and -> dil algorithm)
   add_instance                   video_in_duplicator           alt_vip_packet_duplicator    $isVersion
   set_instance_parameter_value   video_in_duplicator           DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   video_in_duplicator           PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   video_in_duplicator           USE_COMMAND                  0
   set_instance_parameter_value   video_in_duplicator           DEPTH                        4
   set_instance_parameter_value   video_in_duplicator           DUPLICATOR_FANOUT            3
   set_instance_parameter_value   video_in_duplicator           REGISTER_OUTPUT              1
   set_instance_parameter_value   video_in_duplicator           PIPELINE_READY               1
   set_instance_parameter_value   video_in_duplicator           SRC_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           DST_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_duplicator           TASK_WIDTH                   8
   set_instance_parameter_value   video_in_duplicator           USER_WIDTH                   0


   add_instance                   video_in_op0_pipNto1          alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   video_in_op0_pipNto1          PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_OUT       1
   set_instance_parameter_value   video_in_op0_pipNto1          FIFO_DEPTH                   32
   set_instance_parameter_value   video_in_op0_pipNto1          PIPELINE_READY               1
   set_instance_parameter_value   video_in_op0_pipNto1          SRC_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          DST_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_op0_pipNto1          TASK_WIDTH                   8

   add_instance                   video_in_op1_pipNto1          alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   video_in_op1_pipNto1          PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   video_in_op1_pipNto1          PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
   set_instance_parameter_value   video_in_op1_pipNto1          PIXELS_IN_PARALLEL_OUT       1
   set_instance_parameter_value   video_in_op1_pipNto1          FIFO_DEPTH                   32
   set_instance_parameter_value   video_in_op1_pipNto1          PIPELINE_READY               1
   set_instance_parameter_value   video_in_op1_pipNto1          SRC_WIDTH                    8
   set_instance_parameter_value   video_in_op1_pipNto1          DST_WIDTH                    8
   set_instance_parameter_value   video_in_op1_pipNto1          CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_op1_pipNto1          TASK_WIDTH                   8
  
   if {$enable_embedded_crs_for_interlaced_video} {
      add_instance                 video_in_op0_444to422        alt_vip_crs_h_down_core $isVersion   
      set_instance_parameter_value video_in_op0_444to422        BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_in_op0_444to422        PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op0_444to422        ALGORITHM                           BILINEAR
      
      add_instance                 video_in_op1_444to422        alt_vip_crs_h_down_core $isVersion   
      set_instance_parameter_value video_in_op1_444to422        BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_in_op1_444to422        PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op1_444to422        ALGORITHM                           BILINEAR
      
            
      add_instance                 video_out_ip1_422to444       alt_vip_crs_h_up_core $isVersion   
      set_instance_parameter_value video_out_ip1_422to444       BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_out_ip1_422to444       PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip1_422to444       ALGORITHM                           BILINEAR
      
      add_instance                 video_out_ip2_422to444       alt_vip_crs_h_up_core $isVersion   
      set_instance_parameter_value video_out_ip2_422to444       BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_out_ip2_422to444       PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip2_422to444       ALGORITHM                           BILINEAR
      
      add_instance                 video_out_ip3_422to444       alt_vip_crs_h_up_core $isVersion   
      set_instance_parameter_value video_out_ip3_422to444       BITS_PER_SYMBOL                     $bits_per_symbol_core
      set_instance_parameter_value video_out_ip3_422to444       PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip3_422to444       ALGORITHM                           BILINEAR
   }

   
   # BPS convertors come "closer to the outside world" than the CSC/CRS blocks, but further than the PiP convertors
   
   # NB. NUMBER_OF_COLOR_PLANES could still be either 2 or 3 at this point ...
   add_instance                 video_in_op0_10bps_conv        alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_in_op0_10bps_conv        INPUT_BITS_PER_SYMBOL             $bits_per_symbol
   set_instance_parameter_value video_in_op0_10bps_conv        OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol_core
   set_instance_parameter_value video_in_op0_10bps_conv        NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_in_op0_10bps_conv        COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_in_op0_10bps_conv        PIXELS_IN_PARALLEL                1
   
   add_instance                 video_in_op1_10bps_conv        alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_in_op1_10bps_conv        INPUT_BITS_PER_SYMBOL             $bits_per_symbol
   set_instance_parameter_value video_in_op1_10bps_conv        OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol_core
   set_instance_parameter_value video_in_op1_10bps_conv        NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_in_op1_10bps_conv        COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_in_op1_10bps_conv        PIXELS_IN_PARALLEL                1
   
   add_instance                 video_out_ip1_10bps_conv       alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_out_ip1_10bps_conv       INPUT_BITS_PER_SYMBOL             $bits_per_symbol_core
   set_instance_parameter_value video_out_ip1_10bps_conv       OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol
   set_instance_parameter_value video_out_ip1_10bps_conv       NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_out_ip1_10bps_conv       COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_out_ip1_10bps_conv       PIXELS_IN_PARALLEL                1
   
   add_instance                 video_out_ip2_10bps_conv       alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_out_ip2_10bps_conv       INPUT_BITS_PER_SYMBOL             $bits_per_symbol_core
   set_instance_parameter_value video_out_ip2_10bps_conv       OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol
   set_instance_parameter_value video_out_ip2_10bps_conv       NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_out_ip2_10bps_conv       COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_out_ip2_10bps_conv       PIXELS_IN_PARALLEL                1            
    
   add_instance                 video_out_ip3_10bps_conv       alt_vip_bps_converter $isVersion  
   set_instance_parameter_value video_out_ip3_10bps_conv       INPUT_BITS_PER_SYMBOL             $bits_per_symbol_core
   set_instance_parameter_value video_out_ip3_10bps_conv       OUTPUT_BITS_PER_SYMBOL            $bits_per_symbol
   set_instance_parameter_value video_out_ip3_10bps_conv       NUMBER_OF_COLOR_PLANES            $number_of_color_planes
   set_instance_parameter_value video_out_ip3_10bps_conv       COLOR_PLANES_ARE_IN_PARALLEL      1
   set_instance_parameter_value video_out_ip3_10bps_conv       PIXELS_IN_PARALLEL                1            
             
             
   
   if {$enable_embedded_csc_for_interlaced_video} {

      # Coefficient sets are for 10bit<->10bit conversions.  Any other input/output BPS requires bps_convertor components
      set rgb2ycbcr_coefficient_a0     112
      set rgb2ycbcr_coefficient_a1     -10
      set rgb2ycbcr_coefficient_a2      16
      set rgb2ycbcr_coefficient_b0     -87
      set rgb2ycbcr_coefficient_b1    -102
      set rgb2ycbcr_coefficient_b2     157
      set rgb2ycbcr_coefficient_c0     -26
      set rgb2ycbcr_coefficient_c1     112
      set rgb2ycbcr_coefficient_c2      47
      
      set rgb2ycbcr_coefficient_s0  131072
      set rgb2ycbcr_coefficient_s1  131072
      set rgb2ycbcr_coefficient_s2   16384

      # RGB to YCbCr convertors  
      add_instance                 video_in_op0_rgbtoycbcr      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_in_op0_rgbtoycbcr      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_in_op0_rgbtoycbcr      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_in_op0_rgbtoycbcr      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_A0                      $rgb2ycbcr_coefficient_a0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_A1                      $rgb2ycbcr_coefficient_a1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_A2                      $rgb2ycbcr_coefficient_a2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_B0                      $rgb2ycbcr_coefficient_b0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_B1                      $rgb2ycbcr_coefficient_b1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_B2                      $rgb2ycbcr_coefficient_b2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_C0                      $rgb2ycbcr_coefficient_c0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_C1                      $rgb2ycbcr_coefficient_c1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_C2                      $rgb2ycbcr_coefficient_c2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_S0                      $rgb2ycbcr_coefficient_s0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_S1                      $rgb2ycbcr_coefficient_s1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFFICIENT_S2                      $rgb2ycbcr_coefficient_s2
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFF_SIGNED                        1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFF_INTEGER_BITS                  0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      SUMMAND_SIGNED                      0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      SUMMAND_INTEGER_BITS                10
      set_instance_parameter_value video_in_op0_rgbtoycbcr      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_in_op0_rgbtoycbcr      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_in_op0_rgbtoycbcr      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_in_op0_rgbtoycbcr      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_in_op0_rgbtoycbcr      PIPELINE_READY                      1
      set_instance_parameter_value video_in_op0_rgbtoycbcr      RUNTIME_CONTROL                     0

  
      add_instance                 video_in_op1_rgbtoycbcr      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_in_op1_rgbtoycbcr      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_in_op1_rgbtoycbcr      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_in_op1_rgbtoycbcr      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_A0                      $rgb2ycbcr_coefficient_a0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_A1                      $rgb2ycbcr_coefficient_a1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_A2                      $rgb2ycbcr_coefficient_a2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_B0                      $rgb2ycbcr_coefficient_b0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_B1                      $rgb2ycbcr_coefficient_b1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_B2                      $rgb2ycbcr_coefficient_b2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_C0                      $rgb2ycbcr_coefficient_c0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_C1                      $rgb2ycbcr_coefficient_c1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_C2                      $rgb2ycbcr_coefficient_c2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_S0                      $rgb2ycbcr_coefficient_s0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_S1                      $rgb2ycbcr_coefficient_s1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFFICIENT_S2                      $rgb2ycbcr_coefficient_s2
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFF_SIGNED                        1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFF_INTEGER_BITS                  0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      SUMMAND_SIGNED                      0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      SUMMAND_INTEGER_BITS                10
      set_instance_parameter_value video_in_op1_rgbtoycbcr      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_in_op1_rgbtoycbcr      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_in_op1_rgbtoycbcr      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_in_op1_rgbtoycbcr      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_in_op1_rgbtoycbcr      PIPELINE_READY                      1
      set_instance_parameter_value video_in_op1_rgbtoycbcr      RUNTIME_CONTROL                     0


      set ycbcr2rgb_coefficient_a0      541
      set ycbcr2rgb_coefficient_a1      -55
      set ycbcr2rgb_coefficient_a2        0
      set ycbcr2rgb_coefficient_b0        0
      set ycbcr2rgb_coefficient_b1     -137
      set ycbcr2rgb_coefficient_b2      459
      set ycbcr2rgb_coefficient_c0      298
      set ycbcr2rgb_coefficient_c1      298
      set ycbcr2rgb_coefficient_c2      298    
        
      set ycbcr2rgb_coefficient_s0  -296288
      set ycbcr2rgb_coefficient_s1    78840
      set ycbcr2rgb_coefficient_s2  -254083
      

      # YCbCr to RGBconvertors 
      add_instance                 video_out_ip1_ycbcrtorgb      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_A0                      $ycbcr2rgb_coefficient_a0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_A1                      $ycbcr2rgb_coefficient_a1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_A2                      $ycbcr2rgb_coefficient_a2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_B0                      $ycbcr2rgb_coefficient_b0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_B1                      $ycbcr2rgb_coefficient_b1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_B2                      $ycbcr2rgb_coefficient_b2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_C0                      $ycbcr2rgb_coefficient_c0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_C1                      $ycbcr2rgb_coefficient_c1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_C2                      $ycbcr2rgb_coefficient_c2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_S0                      $ycbcr2rgb_coefficient_s0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_S1                      $ycbcr2rgb_coefficient_s1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFFICIENT_S2                      $ycbcr2rgb_coefficient_s2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFF_SIGNED                        1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFF_INTEGER_BITS                  2
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      SUMMAND_SIGNED                      1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      SUMMAND_INTEGER_BITS                11
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      PIPELINE_READY                      1
      set_instance_parameter_value video_out_ip1_ycbcrtorgb      RUNTIME_CONTROL                     0

      add_instance                 video_out_ip2_ycbcrtorgb      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_A0                      $ycbcr2rgb_coefficient_a0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_A1                      $ycbcr2rgb_coefficient_a1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_A2                      $ycbcr2rgb_coefficient_a2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_B0                      $ycbcr2rgb_coefficient_b0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_B1                      $ycbcr2rgb_coefficient_b1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_B2                      $ycbcr2rgb_coefficient_b2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_C0                      $ycbcr2rgb_coefficient_c0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_C1                      $ycbcr2rgb_coefficient_c1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_C2                      $ycbcr2rgb_coefficient_c2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_S0                      $ycbcr2rgb_coefficient_s0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_S1                      $ycbcr2rgb_coefficient_s1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFFICIENT_S2                      $ycbcr2rgb_coefficient_s2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFF_SIGNED                        1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFF_INTEGER_BITS                  2
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      SUMMAND_SIGNED                      1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      SUMMAND_INTEGER_BITS                11
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      PIPELINE_READY                      1
      set_instance_parameter_value video_out_ip2_ycbcrtorgb      RUNTIME_CONTROL                     0

      add_instance                 video_out_ip3_ycbcrtorgb      alt_vip_csc_alg_core          $isVersion   
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      BITS_PER_SYMBOL_IN                  10
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      BITS_PER_SYMBOL_OUT                 10
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      NUMBER_OF_COLOR_PLANES              3
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COLOR_PLANES_ARE_IN_PARALLEL        1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      PIXELS_IN_PARALLEL                  1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_A0                      $ycbcr2rgb_coefficient_a0
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_A1                      $ycbcr2rgb_coefficient_a1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_A2                      $ycbcr2rgb_coefficient_a2
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_B0                      $ycbcr2rgb_coefficient_b0
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_B1                      $ycbcr2rgb_coefficient_b1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_B2                      $ycbcr2rgb_coefficient_b2
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_C0                      $ycbcr2rgb_coefficient_c0
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_C1                      $ycbcr2rgb_coefficient_c1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_C2                      $ycbcr2rgb_coefficient_c2
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_S0                      $ycbcr2rgb_coefficient_s0
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_S1                      $ycbcr2rgb_coefficient_s1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFFICIENT_S2                      $ycbcr2rgb_coefficient_s2
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFF_SIGNED                        1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFF_INTEGER_BITS                  2
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      SUMMAND_SIGNED                      1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      SUMMAND_INTEGER_BITS                11
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      COEFF_FRACTION_BITS                 8
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      SUMMAND_FRACTION_BITS               8
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      MOVE_BINARY_POINT_RIGHT             0
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      ROUNDING_METHOD                     ROUND_HALF_UP
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      PIPELINE_READY                      1
      set_instance_parameter_value video_out_ip3_ycbcrtorgb      RUNTIME_CONTROL                     0

   }


   # Duplicator for the "current" field - routed both to the motion detection and the main algorithmic blocks
   # and optionally the cadence detection block
   add_instance                   edi_line_buffer_duplicator    alt_vip_packet_duplicator    $isVersion
   set_instance_parameter_value   edi_line_buffer_duplicator    DATA_WIDTH                   [expr $video_data_width*2*$high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer_duplicator    PIXELS_IN_PARALLEL           1
   set_instance_parameter_value   edi_line_buffer_duplicator    USE_COMMAND                  0
   set_instance_parameter_value   edi_line_buffer_duplicator    DEPTH                        16
   set_instance_parameter_value   edi_line_buffer_duplicator    DUPLICATOR_FANOUT            [expr $cadence_detect ? 3 : 2]
   set_instance_parameter_value   edi_line_buffer_duplicator    REGISTER_OUTPUT              1
   set_instance_parameter_value   edi_line_buffer_duplicator    PIPELINE_READY               1
   set_instance_parameter_value   edi_line_buffer_duplicator    SRC_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_duplicator    DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_duplicator    CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer_duplicator    TASK_WIDTH                   8
   set_instance_parameter_value   edi_line_buffer_duplicator    USER_WIDTH                   0

   add_instance                   edi_line_buffer_pip_convertor    alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   edi_line_buffer_pip_convertor    FIFO_DEPTH                   16
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIPELINE_READY               1
   set_instance_parameter_value   edi_line_buffer_pip_convertor    SRC_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    TASK_WIDTH                   8

   # Duplicator/router for the first frame
   # weave field is routed both to the motion detection and the main algorithmic blocks (and optionally cadence detector)
   # current field may be routed the the edi line buffer in the future
   add_instance                   edi_packet_reader_duplicator  alt_vip_packet_duplicator    $isVersion
   set_instance_parameter_value   edi_packet_reader_duplicator  DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   edi_packet_reader_duplicator  PIXELS_IN_PARALLEL           1
   set_instance_parameter_value   edi_packet_reader_duplicator  DEPTH                        16
   set_instance_parameter_value   edi_packet_reader_duplicator  USE_COMMAND                  0
   set_instance_parameter_value   edi_packet_reader_duplicator  DUPLICATOR_FANOUT            [expr $cadence_detect ? 3 : 2]
   set_instance_parameter_value   edi_packet_reader_duplicator  REGISTER_OUTPUT              1
   set_instance_parameter_value   edi_packet_reader_duplicator  PIPELINE_READY               1
   set_instance_parameter_value   edi_packet_reader_duplicator  SRC_WIDTH                    8
   set_instance_parameter_value   edi_packet_reader_duplicator  DST_WIDTH                    8
   set_instance_parameter_value   edi_packet_reader_duplicator  CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_packet_reader_duplicator  TASK_WIDTH                   8
   set_instance_parameter_value   edi_packet_reader_duplicator  USER_WIDTH                   0

   # Router for the second frame
   # field3 (same as current field) is routed to a line buffer since the motion detection need two lines from it
   # field4 is sent straight to the motion detector 
   add_instance                   ma_packet_reader_duplicator   alt_vip_packet_duplicator    $isVersion
   set_instance_parameter_value   ma_packet_reader_duplicator   DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   ma_packet_reader_duplicator   PIXELS_IN_PARALLEL           1
   set_instance_parameter_value   ma_packet_reader_duplicator   DEPTH                        4
   set_instance_parameter_value   ma_packet_reader_duplicator   USE_COMMAND                  0
   set_instance_parameter_value   ma_packet_reader_duplicator   DUPLICATOR_FANOUT            2
   set_instance_parameter_value   ma_packet_reader_duplicator   REGISTER_OUTPUT              1
   set_instance_parameter_value   ma_packet_reader_duplicator   PIPELINE_READY               1
   set_instance_parameter_value   ma_packet_reader_duplicator   SRC_WIDTH                    8
   set_instance_parameter_value   ma_packet_reader_duplicator   DST_WIDTH                    8
   set_instance_parameter_value   ma_packet_reader_duplicator   CONTEXT_WIDTH                8
   set_instance_parameter_value   ma_packet_reader_duplicator   TASK_WIDTH                   8
   set_instance_parameter_value   ma_packet_reader_duplicator   USER_WIDTH                   0

   # Optional duplicator for the ma_line_buffer (->motion detector and ->cadence detector)
   if {$cadence_detect} {
      add_instance                   ma_line_buffer_duplicator     alt_vip_packet_duplicator    $isVersion
      set_instance_parameter_value   ma_line_buffer_duplicator     DATA_WIDTH                   [expr $video_data_width* 2]
      set_instance_parameter_value   ma_line_buffer_duplicator     PIXELS_IN_PARALLEL           1
      set_instance_parameter_value   ma_line_buffer_duplicator     DEPTH                        4
      set_instance_parameter_value   ma_line_buffer_duplicator     USE_COMMAND                  0
      set_instance_parameter_value   ma_line_buffer_duplicator     DUPLICATOR_FANOUT            2
      set_instance_parameter_value   ma_line_buffer_duplicator     REGISTER_OUTPUT              1
      set_instance_parameter_value   ma_line_buffer_duplicator     PIPELINE_READY               1
      set_instance_parameter_value   ma_line_buffer_duplicator     SRC_WIDTH                    8
      set_instance_parameter_value   ma_line_buffer_duplicator     DST_WIDTH                    8
      set_instance_parameter_value   ma_line_buffer_duplicator     CONTEXT_WIDTH                8
      set_instance_parameter_value   ma_line_buffer_duplicator     TASK_WIDTH                   8
      set_instance_parameter_value   ma_line_buffer_duplicator     USER_WIDTH                   0
   }

   add_instance                   ma_line_buffer_pip_convertor    alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   ma_line_buffer_pip_convertor    PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   ma_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   ma_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   ma_line_buffer_pip_convertor    FIFO_DEPTH                   16
   set_instance_parameter_value   ma_line_buffer_pip_convertor    PIPELINE_READY               1
   set_instance_parameter_value   ma_line_buffer_pip_convertor    SRC_WIDTH                    8
   set_instance_parameter_value   ma_line_buffer_pip_convertor    DST_WIDTH                    8
   set_instance_parameter_value   ma_line_buffer_pip_convertor    CONTEXT_WIDTH                8
   set_instance_parameter_value   ma_line_buffer_pip_convertor    TASK_WIDTH                   8
   
   # Ouput mux - used to merge user packets/progressive passthrough and the video output from the dil algorithm 
   add_instance                   output_mux                    alt_vip_packet_mux           $isVersion
   set_instance_parameter_value   output_mux                    DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   output_mux                    NUM_INPUTS                   4
   set_instance_parameter_value   output_mux                    REGISTER_OUTPUT              1
   set_instance_parameter_value   output_mux                    PIPELINE_READY               1
   set_instance_parameter_value   output_mux                    SRC_WIDTH                    8
   set_instance_parameter_value   output_mux                    DST_WIDTH                    8
   set_instance_parameter_value   output_mux                    CONTEXT_WIDTH                8
   set_instance_parameter_value   output_mux                    TASK_WIDTH                   8
   set_instance_parameter_value   output_mux                    USER_WIDTH                   0
   set_instance_parameter_value   output_mux                    PIXELS_IN_PARALLEL           $pixels_in_parallel
   

   add_instance                   dil_algo_pip_convertor    alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   dil_algo_pip_convertor    PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par] 
   set_instance_parameter_value   dil_algo_pip_convertor    PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   dil_algo_pip_convertor    PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   dil_algo_pip_convertor    FIFO_DEPTH                   16
   set_instance_parameter_value   dil_algo_pip_convertor    PIPELINE_READY               1
   set_instance_parameter_value   dil_algo_pip_convertor    SRC_WIDTH                    8
   set_instance_parameter_value   dil_algo_pip_convertor    DST_WIDTH                    8
   set_instance_parameter_value   dil_algo_pip_convertor    CONTEXT_WIDTH                8
   set_instance_parameter_value   dil_algo_pip_convertor    TASK_WIDTH                   8
   
   
   
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Connection of sub-components                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc dil2_composition_callback_connections {} {

   set cadence_detect                    [get_parameter_value CADENCE_DETECTION]
   set runtime_control                   [get_parameter_value RUNTIME_CONTROL]
   set clocks_are_separate               [get_parameter_value CLOCKS_ARE_SEPARATE]
   set disable_embedded_stream_cleaner   [get_parameter_value DISABLE_EMBEDDED_STREAM_CLEANER]

   set enable_embedded_csc_for_interlaced_video   [get_parameter_value ENABLE_EMBEDDED_CSC_FOR_INTERLACED_VIDEO]
   set enable_embedded_crs_for_interlaced_video   [get_parameter_value ENABLE_EMBEDDED_CRS_FOR_INTERLACED_VIDEO]
    
   # --------------------------------------------------------------------------------------------------
   # -- Top-level interfaces                                                                         --
   # --------------------------------------------------------------------------------------------------
   add_interface             av_st_clock                   clock             end
   add_interface             av_st_reset                   reset             end
   
   if {$clocks_are_separate} {
     add_interface           av_mm_clock                   clock             end
     add_interface           av_mm_reset                   reset             end
   }

   add_interface             edi_read_master               avalon            master
   add_interface             ma_read_master                avalon            master
   add_interface             motion_read_master            avalon            master
   add_interface             write_master                  avalon            master
   add_interface             motion_write_master           avalon            master
   
   if {$runtime_control} {
      add_interface          control                       avalon            slave
      set_interface_property control                       export_of         control.av_mm_control
   }

   add_interface             din                           avalon_streaming  sink 
   add_interface             dout                          avalon_streaming  source

   set_interface_property    av_st_clock                   export_of         av_st_clk_bridge.in_clk
   set_interface_property    av_st_reset                   export_of         av_st_reset_bridge.in_reset
   set_interface_property    av_st_clock                   PORT_NAME_MAP     {av_st_clock in_clk}
   set_interface_property    av_st_reset                   PORT_NAME_MAP     {av_st_reset in_reset}

   if {$clocks_are_separate} {
     set_interface_property  av_mm_clock                   export_of         av_mm_clk_bridge.in_clk
     set_interface_property  av_mm_reset                   export_of         av_mm_reset_bridge.in_reset
     set_interface_property  av_mm_clock                   PORT_NAME_MAP     {av_mm_clock in_clk}
     set_interface_property  av_mm_reset                   PORT_NAME_MAP     {av_mm_reset in_reset}
   }

   set_interface_property    dout                          export_of         video_out.av_st_vid_dout

   if {$disable_embedded_stream_cleaner} { 
      set_interface_property    din                        export_of         video_in.av_st_vid_din
   } else {
      set_interface_property    din                        export_of         cleaner_video_in.av_st_vid_din   
   }
 
   set_interface_property    write_master                  export_of         packet_writer.av_mm_master
   set_interface_property    edi_read_master               export_of         edi_packet_reader.av_mm_master   
   set_interface_property    ma_read_master                export_of         ma_packet_reader.av_mm_master   
   set_interface_property    motion_write_master           export_of         motion_writer.av_mm_master
   set_interface_property    motion_read_master            export_of         motion_reader.av_mm_master   

   # --------------------------------------------------------------------------------------------------
   # -- Connecting clocks and resets                                                                 --
   # --------------------------------------------------------------------------------------------------
   add_connection            av_st_clk_bridge.out_clk            av_st_reset_bridge.clk
   
   if {$clocks_are_separate} {
     add_connection          av_mm_clk_bridge.out_clk            av_mm_reset_bridge.clk
   }
   
   if {$disable_embedded_stream_cleaner} { } else {
   add_connection            av_st_clk_bridge.out_clk            cleaner_video_in.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_video_in.main_reset
   add_connection            av_st_clk_bridge.out_clk            cleaner_core.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_core.main_reset
   add_connection            av_st_clk_bridge.out_clk            cleaner_video_out.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_video_out.main_reset
   add_connection            av_st_clk_bridge.out_clk            cleaner_scheduler.main_clock
   add_connection            av_st_reset_bridge.out_reset        cleaner_scheduler.main_reset
   }
  
  # Connect local chroma resampler clocks and resets : 
   if {$enable_embedded_crs_for_interlaced_video} { 
       add_connection        av_st_clk_bridge.out_clk            video_in_op0_444to422.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op0_444to422.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op1_444to422.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op1_444to422.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op3_444to422.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op3_444to422.main_reset
       
       add_connection        av_st_clk_bridge.out_clk            video_out_ip1_422to444.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip1_422to444.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_out_ip2_422to444.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip2_422to444.main_reset
   }       
   
   if {$enable_embedded_csc_for_interlaced_video} { 
       add_connection        av_st_clk_bridge.out_clk            video_in_op0_rgbtoycbcr.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op0_rgbtoycbcr.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op1_rgbtoycbcr.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op1_rgbtoycbcr.main_reset
       add_connection        av_st_clk_bridge.out_clk            video_in_op3_rgbtoycbcr.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_in_op3_rgbtoycbcr.main_reset

       add_connection        av_st_clk_bridge.out_clk            video_out_ip1_ycbcrtorgb.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip1_ycbcrtorgb.main_reset
       
       add_connection        av_st_clk_bridge.out_clk            video_out_ip2_ycbcrtorgb.main_clock
       add_connection        av_st_reset_bridge.out_reset        video_out_ip2_ycbcrtorgb.main_reset
   }
   
   # We always have BPS convertors inline
   add_connection        av_st_clk_bridge.out_clk            video_in_op0_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_in_op0_10bps_conv.main_reset

   add_connection        av_st_clk_bridge.out_clk            video_in_op1_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_in_op1_10bps_conv.main_reset

   add_connection        av_st_clk_bridge.out_clk            video_out_ip1_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_out_ip1_10bps_conv.main_reset

   add_connection        av_st_clk_bridge.out_clk            video_out_ip2_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_out_ip2_10bps_conv.main_reset   

   add_connection        av_st_clk_bridge.out_clk            video_out_ip3_10bps_conv.main_clock
   add_connection        av_st_reset_bridge.out_reset        video_out_ip3_10bps_conv.main_reset   
   
      
   add_connection            av_st_clk_bridge.out_clk            video_in.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in.main_reset
   add_connection            av_st_clk_bridge.out_clk            dil_algo.main_clock
   add_connection            av_st_reset_bridge.out_reset        dil_algo.main_reset
   add_connection            av_st_clk_bridge.out_clk            motion_detect.main_clock
   add_connection            av_st_reset_bridge.out_reset        motion_detect.main_reset
   add_connection            av_st_clk_bridge.out_clk            video_out.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_out.main_reset
   add_connection            av_st_clk_bridge.out_clk            scheduler.main_clock
   add_connection            av_st_reset_bridge.out_reset        scheduler.main_reset
   
   if {$cadence_detect} {
      add_connection            av_st_clk_bridge.out_clk            ma_line_buffer_duplicator.main_clock
      add_connection            av_st_reset_bridge.out_reset        ma_line_buffer_duplicator.main_reset
      add_connection            av_st_clk_bridge.out_clk            cadence.main_clock
      add_connection            av_st_reset_bridge.out_reset        cadence.main_reset
   }

   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer.main_reset
   add_connection            av_st_clk_bridge.out_clk            ma_line_buffer.main_clock
   add_connection            av_st_reset_bridge.out_reset        ma_line_buffer.main_reset

   add_connection            av_st_clk_bridge.out_clk            packet_writer.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        packet_writer.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            edi_packet_reader.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        edi_packet_reader.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            ma_packet_reader.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        ma_packet_reader.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            motion_writer.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        motion_writer.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            motion_reader.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        motion_reader.av_st_reset

   add_connection            av_st_clk_bridge.out_clk            video_in_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_duplicator.main_reset
   
   add_connection            av_st_clk_bridge.out_clk            video_in_op0_pipNto1.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_op0_pipNto1.main_reset   
   add_connection            av_st_clk_bridge.out_clk            video_in_op1_pipNto1.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_op1_pipNto1.main_reset   

   
   add_connection            av_st_clk_bridge.out_clk            edi_packet_reader_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_packet_reader_duplicator.main_reset
   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer_duplicator.main_reset
   add_connection            av_st_clk_bridge.out_clk            ma_packet_reader_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        ma_packet_reader_duplicator.main_reset
   add_connection            av_st_clk_bridge.out_clk            output_mux.main_clock
   add_connection            av_st_reset_bridge.out_reset        output_mux.main_reset

   add_connection            av_st_clk_bridge.out_clk            ma_line_buffer_pip_convertor.main_clock
   add_connection            av_st_reset_bridge.out_reset        ma_line_buffer_pip_convertor.main_reset

   add_connection            av_st_clk_bridge.out_clk            dil_algo_pip_convertor.main_clock
   add_connection            av_st_reset_bridge.out_reset        dil_algo_pip_convertor.main_reset

   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer_pip_convertor.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer_pip_convertor.main_reset
         
   if ($clocks_are_separate) {
     add_connection          av_mm_clk_bridge.out_clk            edi_packet_reader.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        edi_packet_reader.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            ma_packet_reader.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        ma_packet_reader.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            motion_reader.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        motion_reader.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            packet_writer.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        packet_writer.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            motion_writer.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        motion_writer.av_mm_reset
   } 
   
   # Make connections for new PIP convertors :
   add_connection            video_in_duplicator.av_st_dout_0    video_in_op0_pipNto1.av_st_din
   add_connection            video_in_duplicator.av_st_dout_1    video_in_op1_pipNto1.av_st_din


   # --------------------------------------------------------------------------------------------------
   # -- Interblocks connections                                                                      --
   # --------------------------------------------------------------------------------------------------

   if {$disable_embedded_stream_cleaner} {    
   } else {
      add_connection            cleaner_video_in.av_st_resp                 cleaner_scheduler.av_st_vib_resp

      add_connection            cleaner_scheduler.av_st_vib_cmd             cleaner_video_in.av_st_cmd
      add_connection            cleaner_scheduler.av_st_ac_cmd              cleaner_core.av_st_cmd
      add_connection            cleaner_scheduler.av_st_vob_cmd             cleaner_video_out.av_st_cmd

      add_connection            cleaner_video_in.av_st_dout                 cleaner_core.av_st_din
      add_connection            cleaner_core.av_st_dout                     cleaner_video_out.av_st_din
      add_connection            cleaner_video_out.av_st_vid_dout            video_in.av_st_vid_din            
   }
   
   add_connection            video_in.av_st_dout                         video_in_duplicator.av_st_din         

   # user packet route
   add_connection            video_in_duplicator.av_st_dout_2            output_mux.av_st_din_0
     
   if {$enable_embedded_crs_for_interlaced_video} { 
   
       # Input/output video needs CSC conversion and CRS :
       if {$enable_embedded_csc_for_interlaced_video} { 
   
          #send_message info "connecting pip convertors  + bps convertors to CSC+CRS "

          add_connection        video_in_op0_pipNto1.av_st_dout             video_in_op0_10bps_conv.av_st_din               
          add_connection        video_in_op0_10bps_conv.av_st_dout          video_in_op0_rgbtoycbcr.av_st_din               
          add_connection        video_in_op0_rgbtoycbcr.av_st_dout          video_in_op0_444to422.av_st_din               
          add_connection        video_in_op0_444to422.av_st_dout            packet_writer.av_st_din        

          add_connection        video_in_op1_pipNto1.av_st_dout             video_in_op1_10bps_conv.av_st_din   
          add_connection        video_in_op1_10bps_conv.av_st_dout          video_in_op1_rgbtoycbcr.av_st_din   
          add_connection        video_in_op1_rgbtoycbcr.av_st_dout          video_in_op1_444to422.av_st_din   
          add_connection        video_in_op1_444to422.av_st_dout            edi_line_buffer.av_st_din 


          add_connection        edi_line_buffer.av_st_dout_1                video_out_ip1_422to444.av_st_din         
          add_connection        video_out_ip1_422to444.av_st_dout           video_out_ip1_ycbcrtorgb.av_st_din    
          add_connection        video_out_ip1_ycbcrtorgb.av_st_dout         video_out_ip1_10bps_conv.av_st_din    
          add_connection        video_out_ip1_10bps_conv.av_st_dout         edi_line_buffer_pip_convertor.av_st_din    
          add_connection        edi_line_buffer_pip_convertor.av_st_dout    output_mux.av_st_din_1 

          add_connection        ma_line_buffer.av_st_dout_1                 video_out_ip2_422to444.av_st_din         
          add_connection        video_out_ip2_422to444.av_st_dout           video_out_ip2_ycbcrtorgb.av_st_din    
          add_connection        video_out_ip2_ycbcrtorgb.av_st_dout         video_out_ip2_10bps_conv.av_st_din    
          add_connection        video_out_ip2_10bps_conv.av_st_dout         ma_line_buffer_pip_convertor.av_st_din    
          add_connection        ma_line_buffer_pip_convertor.av_st_dout     output_mux.av_st_din_2 
          
          add_connection        dil_algo.dout                               video_out_ip3_422to444.av_st_din  
          add_connection        video_out_ip3_422to444.av_st_dout           video_out_ip3_ycbcrtorgb.av_st_din
          add_connection        video_out_ip3_ycbcrtorgb.av_st_dout         video_out_ip3_10bps_conv.av_st_din
          add_connection        video_out_ip3_10bps_conv.av_st_dout         dil_algo_pip_convertor.av_st_din
          add_connection        dil_algo_pip_convertor.av_st_dout           output_mux.av_st_din_3     

       # Input/output video just needs CRS (no CSC) :
       } else {
          #send_message info "connecting pip convertors + bps convertors to CRS ONLY"
       
          add_connection        video_in_op0_pipNto1.av_st_dout             video_in_op0_10bps_conv.av_st_din               
          add_connection        video_in_op0_10bps_conv.av_st_dout          video_in_op0_444to422.av_st_din               
          add_connection        video_in_op0_444to422.av_st_dout            packet_writer.av_st_din        

          add_connection        video_in_op1_pipNto1.av_st_dout             video_in_op1_10bps_conv.av_st_din   
          add_connection        video_in_op1_10bps_conv.av_st_dout          video_in_op1_444to422.av_st_din   
          add_connection        video_in_op1_444to422.av_st_dout            edi_line_buffer.av_st_din  

          add_connection        edi_line_buffer.av_st_dout_1                video_out_ip1_422to444.av_st_din         
          add_connection        video_out_ip1_422to444.av_st_dout           video_out_ip1_10bps_conv.av_st_din    
          add_connection        video_out_ip1_10bps_conv.av_st_dout         edi_line_buffer_pip_convertor.av_st_din    
          add_connection        edi_line_buffer_pip_convertor.av_st_dout    output_mux.av_st_din_1 

          add_connection        ma_line_buffer.av_st_dout_1                 video_out_ip2_422to444.av_st_din         
          add_connection        video_out_ip2_422to444.av_st_dout           video_out_ip2_10bps_conv.av_st_din    
          add_connection        video_out_ip2_10bps_conv.av_st_dout         ma_line_buffer_pip_convertor.av_st_din    
          add_connection        ma_line_buffer_pip_convertor.av_st_dout     output_mux.av_st_din_2 

          add_connection        dil_algo.dout                               video_out_ip3_422to444.av_st_din  
          add_connection        video_out_ip3_422to444.av_st_dout           video_out_ip3_10bps_conv.av_st_din
          add_connection        video_out_ip3_10bps_conv.av_st_dout         dil_algo_pip_convertor.av_st_din
          add_connection        dil_algo_pip_convertor.av_st_dout           output_mux.av_st_din_3     
                        
       }        
            
   # No CRS or CSC required :             
   } else {
   
       #send_message info "connecting pip convertors  + bps convertors directly to components"
   
       add_connection        video_in_op0_pipNto1.av_st_dout             video_in_op0_10bps_conv.av_st_din               
       add_connection        video_in_op0_10bps_conv.av_st_dout          packet_writer.av_st_din               
       
       add_connection        video_in_op1_pipNto1.av_st_dout             video_in_op1_10bps_conv.av_st_din   
       add_connection        video_in_op1_10bps_conv.av_st_dout          edi_line_buffer.av_st_din  
       
       add_connection        edi_line_buffer.av_st_dout_1                video_out_ip1_10bps_conv.av_st_din              
       add_connection        video_out_ip1_10bps_conv.av_st_dout         edi_line_buffer_pip_convertor.av_st_din              
       add_connection        edi_line_buffer_pip_convertor.av_st_dout    output_mux.av_st_din_1   

       add_connection        ma_line_buffer.av_st_dout_1                 video_out_ip2_10bps_conv.av_st_din         
       add_connection        video_out_ip2_10bps_conv.av_st_dout         ma_line_buffer_pip_convertor.av_st_din    
       add_connection        ma_line_buffer_pip_convertor.av_st_dout     output_mux.av_st_din_2 
       
       add_connection        dil_algo.dout                               video_out_ip3_10bps_conv.av_st_din
       add_connection        video_out_ip3_10bps_conv.av_st_dout         dil_algo_pip_convertor.av_st_din
       add_connection        dil_algo_pip_convertor.av_st_dout           output_mux.av_st_din_3
                     
   }

   add_connection            edi_packet_reader.av_st_dout                edi_packet_reader_duplicator.av_st_din
   add_connection            edi_packet_reader_duplicator.av_st_dout_0   dil_algo.din_weave         
   add_connection            edi_packet_reader_duplicator.av_st_dout_1   motion_detect.av_st_field1         

   add_connection            edi_line_buffer.av_st_dout_0                edi_line_buffer_duplicator.av_st_din                              
                             
   add_connection            edi_line_buffer_duplicator.av_st_dout_0     dil_algo.din_bob
   add_connection            edi_line_buffer_duplicator.av_st_dout_1     motion_detect.av_st_field0  
   
   add_connection            ma_packet_reader.av_st_dout                 ma_packet_reader_duplicator.av_st_din   
   add_connection            ma_packet_reader_duplicator.av_st_dout_0    ma_line_buffer.av_st_din            
   add_connection            ma_packet_reader_duplicator.av_st_dout_1    motion_detect.av_st_field3            

   if {$cadence_detect} {
      add_connection         ma_line_buffer.av_st_dout_0                 ma_line_buffer_duplicator.av_st_din                           
      add_connection         ma_line_buffer_duplicator.av_st_dout_0      motion_detect.av_st_field2
   } else {
      add_connection         ma_line_buffer.av_st_dout_0                 motion_detect.av_st_field2
   }

   add_connection            motion_reader.av_st_dout                    motion_detect.av_st_mem_motion_in
   add_connection            motion_detect.av_st_algo_motion_out         dil_algo.din_motion
   add_connection            motion_detect.av_st_mem_motion_out          motion_writer.av_st_din       

   add_connection            output_mux.av_st_dout                       video_out.av_st_din                   

   if {$cadence_detect} {
      add_connection            edi_line_buffer_duplicator.av_st_dout_2     cadence.av_st_field0         
      add_connection            edi_packet_reader_duplicator.av_st_dout_2   cadence.av_st_field1         
      add_connection            ma_line_buffer_duplicator.av_st_dout_1      cadence.av_st_field2         
   }
   

   # --------------------------------------------------------------------------------------------------
   # -- Scheduler connections                                                                        --
   # --------------------------------------------------------------------------------------------------
   add_connection            scheduler.cmd0                      video_in.av_st_cmd 
   add_connection            scheduler.cmd1                      video_out.av_st_cmd 
   add_connection            scheduler.cmd2                      edi_line_buffer.av_st_cmd 
   add_connection            scheduler.cmd3                      packet_writer.av_st_cmd 
   add_connection            scheduler.cmd4                      edi_packet_reader.av_st_cmd 
   add_connection            scheduler.cmd5                      dil_algo.cmd 
   add_connection            scheduler.cmd6                      ma_line_buffer.av_st_cmd 
   add_connection            scheduler.cmd7                      motion_writer.av_st_cmd 
   add_connection            scheduler.cmd8                      ma_packet_reader.av_st_cmd 
   add_connection            scheduler.cmd9                      motion_reader.av_st_cmd 
   add_connection            scheduler.cmd11                     motion_detect.av_st_cmd
   add_connection            scheduler.cmd13                     output_mux.av_st_cmd

   add_connection            video_in.av_st_resp                 scheduler.resp0 

   if {$cadence_detect} {
      add_connection         cadence.resp                        scheduler.resp1
      add_connection         scheduler.cmd10                     cadence.cmd
   } 

   if {$runtime_control} {
      add_connection         scheduler.cmd12                     control.av_st_cmd
      add_connection         control.av_st_resp                  scheduler.resp2    
   } 

}

proc bob_composition_callback_instantiation {} {
   global isVersion acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol              [get_parameter_value BITS_PER_SYMBOL]
    set is_422                       [get_parameter_value IS_422]
    set color_planes_are_in_parallel [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set number_of_color_planes       [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set pixels_in_parallel           [get_parameter_value PIXELS_IN_PARALLEL]
   
    set max_width_interlaced         [get_parameter_value MAX_WIDTH]
    set max_height_interlaced        [get_parameter_value MAX_HEIGHT]
   
    set max_width_progressive        4096
    set max_height_progressive       2160
   
    set runtime_control              [get_parameter_value RUNTIME_CONTROL]

    set clocks_are_separate          [get_parameter_value CLOCKS_ARE_SEPARATE]   
    set mem_port_width               [get_parameter_value MEM_PORT_WIDTH]    
    set base_addr                    [get_parameter_value MEM_BASE_ADDR]
    set field_buffer_size            [get_parameter_value FIELD_BUFFER_SIZE_IN_BYTES]
    set line_buffer_size             [get_parameter_value LINE_BUFFER_SIZE] 

    set write_master_fifo_depth      [get_parameter_value WRITE_MASTER_FIFO_DEPTH]    
    set write_master_burst_target    [get_parameter_value WRITE_MASTER_BURST_TARGET]    
    set edi_read_master_fifo_depth   [get_parameter_value EDI_READ_MASTER_FIFO_DEPTH]    
    set edi_read_master_burst_target [get_parameter_value EDI_READ_MASTER_BURST_TARGET]    

    set bob_behaviour                [get_parameter_value BOB_BEHAVIOUR]    

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set symbols_in_seq               [expr { $color_planes_are_in_parallel ? 1 : $number_of_color_planes } ] 
    set symbols_in_par               [expr { $color_planes_are_in_parallel ? $number_of_color_planes : 1 } ] 

    set selected_algorithm   alt_vip_dil_algorithm
    set selected_scheduler   alt_vip_dil_bob_scheduler
    set high_quality_line_multiplier 1
      
 
    set max_field_height             [expr ($max_height_interlaced+1)/2]


    if { $color_planes_are_in_parallel == 0 } {
       set video_data_width          $bits_per_symbol
       set pip_fifo_depth            0
    } else {
       set video_data_width          [expr $bits_per_symbol * $symbols_in_par]
       set pip_fifo_depth            16
    }

    # field_type_to_deinterlace == 2 == binary '10' - Bit 3 will be set and bit 2 of the interlacing nibble will be clear if a field is F0
    # field_type_to_deinterlace == 3 == binary '11' - Bits 3 and 2 of the interlacing nibble will be set if a field is F1

    if { $bob_behaviour == "FRAME_FOR_FIELD" } {
       set field_type_to_deinterlace   0
       set frame_for_field_mode        1
    } elseif { $bob_behaviour == "F1_SYNCHRONIZED" } {
       set field_type_to_deinterlace   3 
       set frame_for_field_mode        0
    } elseif { $bob_behaviour == "F0_SYNCHRONIZED" } {
       set field_type_to_deinterlace   2 
       set frame_for_field_mode        0
    } else {
       set field_type_to_deinterlace   0 
       set frame_for_field_mode        0
    }
   
   # --------------------------------------------------------------------------------------------------
   # -- Clocks/reset                                                                                 --
   # --------------------------------------------------------------------------------------------------
   add_instance              av_st_clk_bridge                   altera_clock_bridge $acdsVersion
   add_instance              av_st_reset_bridge                 altera_reset_bridge $acdsVersion
   
   if {$clocks_are_separate} {
     add_instance            av_mm_clk_bridge                   altera_clock_bridge $acdsVersion
     add_instance            av_mm_reset_bridge                 altera_reset_bridge $acdsVersion
   }


   # --------------------------------------------------------------------------------------------------
   # -- Main components                                                                              --
   # --------------------------------------------------------------------------------------------------

   # The video input bridge
   add_instance                   video_in                      alt_vip_video_input_bridge   $isVersion
   set_instance_parameter_value   video_in                      BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_in                      COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_in                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_in                      DEFAULT_LINE_LENGTH          $max_width_progressive
   set_instance_parameter_value   video_in                      PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   video_in                      VIB_MODE                     FULL

   # The MA algorithm
   add_instance                   dil_algo                      $selected_algorithm          $isVersion
   set_instance_parameter_value   dil_algo                      BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   dil_algo                      COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   dil_algo                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes   
   set_instance_parameter_value   dil_algo                      IS_422                       $is_422

   # Video output bridge   
   add_instance                   video_out                     alt_vip_video_output_bridge  $isVersion
   set_instance_parameter_value   video_out                     BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_out                     COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_out                     NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_out                     PIXELS_IN_PARALLEL           $pixels_in_parallel

   # The scheduler
   add_instance                   scheduler                     $selected_scheduler          $isVersion
   set_instance_parameter_value   scheduler                     RUNTIME_CONTROL              $runtime_control
   set_instance_parameter_value   scheduler                     MAX_LINE_LENGTH              $max_width_progressive
   set_instance_parameter_value   scheduler                     MAX_FIELD_HEIGHT             $max_field_height
   set_instance_parameter_value   scheduler                     FIELD_TYPE_TO_DEINTERLACE    $field_type_to_deinterlace
   set_instance_parameter_value   scheduler                     FRAME_FOR_FIELD_MODE         $frame_for_field_mode


   # --------------------------------------------------------------------------------------------------
   # -- Line buffers                                                                                 --
   # --------------------------------------------------------------------------------------------------   
   
   # The EDI line buffer
   
   # ENABLE_RECEIVE_ONLY_CMD setting is irrelevant as not in "LOCKED" mode
   # NB. Center params here are irrelvant as the line buffer only sends when it is full :
   add_instance                   edi_line_buffer               alt_vip_line_buffer          $isVersion
   set_instance_parameter_value   edi_line_buffer               PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par]
   set_instance_parameter_value   edi_line_buffer               SYMBOLS_IN_SEQ               $symbols_in_seq
   set_instance_parameter_value   edi_line_buffer               MAX_LINE_LENGTH              $max_width_interlaced
   set_instance_parameter_value   edi_line_buffer               OUTPUT_PORTS                 2
   set_instance_parameter_value   edi_line_buffer               MODE                         "RATE_MATCHING"
   set_instance_parameter_value   edi_line_buffer               OUTPUT_MUX_SEL               "VARIABLE"
   set_instance_parameter_value   edi_line_buffer               ENABLE_RECEIVE_ONLY_CMD      1
   set_instance_parameter_value   edi_line_buffer               FIFO_SIZE                    16
   set_instance_parameter_value   edi_line_buffer               KERNEL_SIZE_0                [expr 2*$high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_CENTER_0              [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_SIZE_1                1
   set_instance_parameter_value   edi_line_buffer               KERNEL_START_1               [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               KERNEL_CENTER_1              [expr $high_quality_line_multiplier]
   set_instance_parameter_value   edi_line_buffer               SRC_WIDTH                    8 
   set_instance_parameter_value   edi_line_buffer               DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer               CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer               TASK_WIDTH                   8
   set_instance_parameter_value   edi_line_buffer               CONVERT_TO_1_PIP             0
   set_instance_parameter_value   edi_line_buffer               PIXELS_IN_PARALLEL           1

     

  

   # --------------------------------------------------------------------------------------------------
   # -- Routing, duplicator and muxes                                                                --
   # --------------------------------------------------------------------------------------------------

   # The video input duplicator (-> packet writer and -> dil algorithm)
   add_instance                   video_in_duplicator           alt_vip_packet_duplicator    $isVersion
   set_instance_parameter_value   video_in_duplicator           DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   video_in_duplicator           PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   video_in_duplicator           USE_COMMAND                  0
   set_instance_parameter_value   video_in_duplicator           DEPTH                        4
   set_instance_parameter_value   video_in_duplicator           DUPLICATOR_FANOUT            2
   set_instance_parameter_value   video_in_duplicator           REGISTER_OUTPUT              1
   set_instance_parameter_value   video_in_duplicator           PIPELINE_READY               1
   set_instance_parameter_value   video_in_duplicator           SRC_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           DST_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_duplicator           TASK_WIDTH                   8
   set_instance_parameter_value   video_in_duplicator           USER_WIDTH                   0

   add_instance                   video_in_op0_pipNto1          alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   video_in_op0_pipNto1          PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par]
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_OUT       1
   set_instance_parameter_value   video_in_op0_pipNto1          FIFO_DEPTH                   $pip_fifo_depth
   set_instance_parameter_value   video_in_op0_pipNto1          PIPELINE_READY               1
   set_instance_parameter_value   video_in_op0_pipNto1          SRC_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          DST_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_op0_pipNto1          TASK_WIDTH                   8

   add_instance                   edi_line_buffer_pip_convertor    alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par]
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   edi_line_buffer_pip_convertor    FIFO_DEPTH                   $pip_fifo_depth
   set_instance_parameter_value   edi_line_buffer_pip_convertor    PIPELINE_READY               1
   set_instance_parameter_value   edi_line_buffer_pip_convertor    SRC_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    DST_WIDTH                    8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_line_buffer_pip_convertor    TASK_WIDTH                   8

   # Ouput mux - used to merge user packets/progressive passthrough and the video output from the dil algorithm 
   add_instance                   output_mux                    alt_vip_packet_mux           $isVersion
   set_instance_parameter_value   output_mux                    DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   output_mux                    PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   output_mux                    NUM_INPUTS                   3
   set_instance_parameter_value   output_mux                    REGISTER_OUTPUT              1
   set_instance_parameter_value   output_mux                    PIPELINE_READY               1
   set_instance_parameter_value   output_mux                    SRC_WIDTH                    8
   set_instance_parameter_value   output_mux                    DST_WIDTH                    8
   set_instance_parameter_value   output_mux                    CONTEXT_WIDTH                8
   set_instance_parameter_value   output_mux                    TASK_WIDTH                   8
   set_instance_parameter_value   output_mux                    USER_WIDTH                   0

   add_instance                   dil_algo_pip_convertor    alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   dil_algo_pip_convertor    PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par]
   set_instance_parameter_value   dil_algo_pip_convertor    PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   dil_algo_pip_convertor    PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   dil_algo_pip_convertor    FIFO_DEPTH                   $pip_fifo_depth
   set_instance_parameter_value   dil_algo_pip_convertor    PIPELINE_READY               1
   set_instance_parameter_value   dil_algo_pip_convertor    SRC_WIDTH                    8
   set_instance_parameter_value   dil_algo_pip_convertor    DST_WIDTH                    8
   set_instance_parameter_value   dil_algo_pip_convertor    CONTEXT_WIDTH                8
   set_instance_parameter_value   dil_algo_pip_convertor    TASK_WIDTH                   8
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Connection of sub-components                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc bob_composition_callback_connections {} {
   
   set runtime_control              [get_parameter_value RUNTIME_CONTROL]
   set clocks_are_separate          [get_parameter_value CLOCKS_ARE_SEPARATE]

   # --------------------------------------------------------------------------------------------------
   # -- Top-level interfaces                                                                         --
   # --------------------------------------------------------------------------------------------------
   add_interface             av_st_clock                   clock             end
   add_interface             av_st_reset                   reset             end
   
   if {$clocks_are_separate} {
     add_interface           av_mm_clock                   clock             end
     add_interface           av_mm_reset                   reset             end
   }

   add_interface             edi_read_master               avalon            master
   add_interface             write_master                  avalon            master
   
   if {$runtime_control} {
      add_interface          control                       avalon            slave
      set_interface_property control                       export_of         scheduler.av_mm_control
   }

   add_interface             din                           avalon_streaming  sink 
   add_interface             dout                          avalon_streaming  source

   set_interface_property    av_st_clock                   export_of         av_st_clk_bridge.in_clk
   set_interface_property    av_st_reset                   export_of         av_st_reset_bridge.in_reset
   set_interface_property    av_st_clock                   PORT_NAME_MAP     {av_st_clock in_clk}
   set_interface_property    av_st_reset                   PORT_NAME_MAP     {av_st_reset in_reset}

   if {$clocks_are_separate} {
     set_interface_property  av_mm_clock                   export_of         av_mm_clk_bridge.in_clk
     set_interface_property  av_mm_reset                   export_of         av_mm_reset_bridge.in_reset
     set_interface_property  av_mm_clock                   PORT_NAME_MAP     {av_mm_clock in_clk}
     set_interface_property  av_mm_reset                   PORT_NAME_MAP     {av_mm_reset in_reset}
   }

   set_interface_property    dout                          export_of         video_out.av_st_vid_dout
   set_interface_property    din                           export_of         video_in.av_st_vid_din
 
   # --------------------------------------------------------------------------------------------------
   # -- Connecting clocks and resets                                                                 --
   # --------------------------------------------------------------------------------------------------
   add_connection            av_st_clk_bridge.out_clk            av_st_reset_bridge.clk
   
   if {$clocks_are_separate} {
     add_connection          av_mm_clk_bridge.out_clk            av_mm_reset_bridge.clk
   }

   add_connection            av_st_clk_bridge.out_clk            video_in.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in.main_reset
   add_connection            av_st_clk_bridge.out_clk            dil_algo.main_clock
   add_connection            av_st_reset_bridge.out_reset        dil_algo.main_reset
   add_connection            av_st_clk_bridge.out_clk            video_out.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_out.main_reset
   add_connection            av_st_clk_bridge.out_clk            scheduler.main_clock
   add_connection            av_st_reset_bridge.out_reset        scheduler.main_reset

   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer.main_reset

   add_connection            av_st_clk_bridge.out_clk            video_in_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_duplicator.main_reset
   add_connection            av_st_clk_bridge.out_clk            output_mux.main_clock
   add_connection            av_st_reset_bridge.out_reset        output_mux.main_reset
  
   add_connection            av_st_clk_bridge.out_clk            video_in_op0_pipNto1.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_op0_pipNto1.main_reset
  
   add_connection            av_st_clk_bridge.out_clk            edi_line_buffer_pip_convertor.main_clock
   add_connection            av_st_reset_bridge.out_reset        edi_line_buffer_pip_convertor.main_reset
  
   add_connection            av_st_clk_bridge.out_clk            dil_algo_pip_convertor.main_clock
   add_connection            av_st_reset_bridge.out_reset        dil_algo_pip_convertor.main_reset

   # --------------------------------------------------------------------------------------------------
   # -- Interblocks connections                                                                      --
   # --------------------------------------------------------------------------------------------------
   add_connection            video_in.av_st_dout                         video_in_duplicator.av_st_din         
   add_connection            video_in_duplicator.av_st_dout_0            video_in_op0_pipNto1.av_st_din
   add_connection            video_in_duplicator.av_st_dout_1            output_mux.av_st_din_0
      
   add_connection            video_in_op0_pipNto1.av_st_dout             edi_line_buffer.av_st_din   
               
   add_connection            edi_line_buffer.av_st_dout_0                dil_algo.din_bob                                                           

   add_connection            edi_line_buffer.av_st_dout_1                edi_line_buffer_pip_convertor.av_st_din              
   add_connection            edi_line_buffer_pip_convertor.av_st_dout    output_mux.av_st_din_1              
   
   add_connection            dil_algo.dout                               dil_algo_pip_convertor.av_st_din
   add_connection            dil_algo_pip_convertor.av_st_dout           output_mux.av_st_din_2
   
   add_connection            output_mux.av_st_dout                       video_out.av_st_din                   
   

   # --------------------------------------------------------------------------------------------------
   # -- Scheduler connections                                                                        --
   # --------------------------------------------------------------------------------------------------
   add_connection            scheduler.cmd0                      video_in.av_st_cmd 
   add_connection            scheduler.cmd1                      video_out.av_st_cmd 
   add_connection            scheduler.cmd2                      edi_line_buffer.av_st_cmd 
   add_connection            scheduler.cmd3                      dil_algo.cmd 
   add_connection            scheduler.cmd4                      output_mux.av_st_cmd 

   add_connection            video_in.av_st_resp                 scheduler.resp0 

}

proc weave_composition_callback_instantiation {} {
   global isVersion acdsVersion

    # --------------------------------------------------------------------------------------------------
    # -- Parameters                                                                                   --
    # --------------------------------------------------------------------------------------------------
    set bits_per_symbol              [get_parameter_value BITS_PER_SYMBOL]
    set is_422                       [get_parameter_value IS_422]
    set color_planes_are_in_parallel [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set number_of_color_planes       [get_parameter_value NUMBER_OF_COLOR_PLANES]
    set pixels_in_parallel           [get_parameter_value PIXELS_IN_PARALLEL]
   
    set max_width_interlaced         [get_parameter_value MAX_WIDTH]
    set max_height_interlaced        [get_parameter_value MAX_HEIGHT]
   
    set max_width_progressive        4096
    set max_height_progressive       2160
   
    set deinterlace_algorithm        [get_parameter_value DEINTERLACE_ALGORITHM]
    set runtime_control              [get_parameter_value RUNTIME_CONTROL]

    set clocks_are_separate          [get_parameter_value CLOCKS_ARE_SEPARATE]   
    set mem_port_width               [get_parameter_value MEM_PORT_WIDTH]    
    set base_addr                    [get_parameter_value MEM_BASE_ADDR]
    set field_buffer_size            [get_parameter_value FIELD_BUFFER_SIZE_IN_BYTES]
    set line_buffer_size             [get_parameter_value LINE_BUFFER_SIZE] 

    set write_master_fifo_depth      [get_parameter_value WRITE_MASTER_FIFO_DEPTH]    
    set write_master_burst_target    [get_parameter_value WRITE_MASTER_BURST_TARGET]    
    set edi_read_master_fifo_depth   [get_parameter_value EDI_READ_MASTER_FIFO_DEPTH]    
    set edi_read_master_burst_target [get_parameter_value EDI_READ_MASTER_BURST_TARGET]    

    # --------------------------------------------------------------------------------------------------
    # -- Derived parameters                                                                           --
    # --------------------------------------------------------------------------------------------------
    set symbols_in_seq               [expr { $color_planes_are_in_parallel ? 1 : $number_of_color_planes } ] 
    set symbols_in_par               [expr { $color_planes_are_in_parallel ? $number_of_color_planes : 1 } ]


    if { $color_planes_are_in_parallel == 0 } {
       set video_data_width          $bits_per_symbol
       set pip_fifo_depth            0
    } else {
       set video_data_width          [expr $bits_per_symbol * $symbols_in_par]
       set pip_fifo_depth            16
    }
    
    set selected_scheduler   alt_vip_dil_weave_scheduler 
 
    set max_line_sample_size         [expr $max_width_interlaced * ($color_planes_are_in_parallel ? 1 : $number_of_color_planes)]
    set max_field_height             [expr ($max_height_interlaced+1)/2]

   
   # --------------------------------------------------------------------------------------------------
   # -- Clocks/reset                                                                                 --
   # --------------------------------------------------------------------------------------------------
   add_instance              av_st_clk_bridge                   altera_clock_bridge $acdsVersion
   add_instance              av_st_reset_bridge                 altera_reset_bridge $acdsVersion
   
   if {$clocks_are_separate} {
     add_instance            av_mm_clk_bridge                   altera_clock_bridge $acdsVersion
     add_instance            av_mm_reset_bridge                 altera_reset_bridge $acdsVersion
   }


   # --------------------------------------------------------------------------------------------------
   # -- Main components                                                                              --
   # --------------------------------------------------------------------------------------------------

   # The video input bridge
   add_instance                   video_in                      alt_vip_video_input_bridge   $isVersion
   set_instance_parameter_value   video_in                      BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_in                      COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_in                      NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_in                      DEFAULT_LINE_LENGTH          $max_width_progressive
   set_instance_parameter_value   video_in                      PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   video_in                      VIB_MODE                     FULL

   # Video output bridge   
   add_instance                   video_out                     alt_vip_video_output_bridge  $isVersion
   set_instance_parameter_value   video_out                     BITS_PER_SYMBOL              $bits_per_symbol   
   set_instance_parameter_value   video_out                     COLOR_PLANES_ARE_IN_PARALLEL $color_planes_are_in_parallel
   set_instance_parameter_value   video_out                     NUMBER_OF_COLOR_PLANES       $number_of_color_planes
   set_instance_parameter_value   video_out                     PIXELS_IN_PARALLEL           $pixels_in_parallel

   # The scheduler
   add_instance                   scheduler                     $selected_scheduler          $isVersion
   set_instance_parameter_value   scheduler                     BUFFER0_BASE                 $base_addr
   set_instance_parameter_value   scheduler                     BUFFER1_BASE                 [expr $base_addr + $field_buffer_size]
   set_instance_parameter_value   scheduler                     RUNTIME_CONTROL              $runtime_control
   set_instance_parameter_value   scheduler                     LINE_OFFSET_BYTES            $line_buffer_size
   set_instance_parameter_value   scheduler                     MAX_LINE_LENGTH              $max_line_sample_size
   set_instance_parameter_value   scheduler                     MAX_FIELD_HEIGHT             $max_field_height

     

   # --------------------------------------------------------------------------------------------------
   # -- Packet writers and packet readers                                                            --
   # --------------------------------------------------------------------------------------------------



   # New packet transfer !
   add_instance                   packet_writer                 alt_vip_packet_transfer
   set_instance_parameter_value   packet_writer                 DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol * $number_of_color_planes) : $bits_per_symbol]
   set_instance_parameter_value   packet_writer                 SYMBOLS_IN_SEQ                     $symbols_in_seq
   set_instance_parameter_value   packet_writer                 MEM_PORT_WIDTH                     $mem_port_width
   set_instance_parameter_value   packet_writer                 MEM_ADDR_WIDTH                     32
   set_instance_parameter_value   packet_writer                 CLOCKS_ARE_SEPARATE                $clocks_are_separate
   set_instance_parameter_value   packet_writer                 WRITE_ENABLE                       1
   set_instance_parameter_value   packet_writer                 READ_ENABLE                        0
   set_instance_parameter_value   packet_writer                 MAX_CONTEXT_NUMBER_WRITE           1
   set_instance_parameter_value   packet_writer                 CONTEXT_BUFFER_RATIO_WRITE         [expr $write_master_fifo_depth / $write_master_burst_target]
   set_instance_parameter_value   packet_writer                 BURST_TARGET_WRITE                 $write_master_burst_target
   set_instance_parameter_value   packet_writer                 MAX_PACKET_SIZE_WRITE              $max_width_interlaced
   set_instance_parameter_value   packet_writer                 MAX_PACKET_NUM_WRITE               1
   set_instance_parameter_value   packet_writer                 ENABLE_MANY_COMMAND_WRITE          0
   set_instance_parameter_value   packet_writer                 ENABLE_PERIOD_MODE_WRITE           0
   set_instance_parameter_value   packet_writer                 ENABLE_MM_OUTPUT_REGISTER          1
   set_instance_parameter_value   packet_writer                 SUPPORT_BEATS_OVERFLOW_PRETECTION  0
   set_instance_parameter_value   packet_writer                 USE_RESPONSE_WRITE                 0           

   # New packet transfer !
   add_instance                   edi_packet_reader             alt_vip_packet_transfer
   set_instance_parameter_value   edi_packet_reader             DATA_WIDTH                         [expr $color_planes_are_in_parallel ? ($bits_per_symbol * $number_of_color_planes) : $bits_per_symbol]
   set_instance_parameter_value   edi_packet_reader             SYMBOLS_IN_SEQ                     $symbols_in_seq
   set_instance_parameter_value   edi_packet_reader             MEM_PORT_WIDTH                     $mem_port_width
   set_instance_parameter_value   edi_packet_reader             MEM_ADDR_WIDTH                     32
   set_instance_parameter_value   edi_packet_reader             CLOCKS_ARE_SEPARATE                $clocks_are_separate
   set_instance_parameter_value   edi_packet_reader             WRITE_ENABLE                       0
   set_instance_parameter_value   edi_packet_reader             READ_ENABLE                        1
   set_instance_parameter_value   edi_packet_reader             MAX_CONTEXT_NUMBER_READ            1
   set_instance_parameter_value   edi_packet_reader             CONTEXT_BUFFER_RATIO_READ          [expr $edi_read_master_fifo_depth / $edi_read_master_burst_target]
   set_instance_parameter_value   edi_packet_reader             BURST_TARGET_READ                  $edi_read_master_burst_target
   set_instance_parameter_value   edi_packet_reader             MAX_PACKET_SIZE_READ               $max_width_interlaced
   set_instance_parameter_value   edi_packet_reader             ENABLE_MANY_COMMAND_READ           0
   set_instance_parameter_value   edi_packet_reader             ENABLE_PERIOD_MODE_READ            0
   set_instance_parameter_value   edi_packet_reader             ENABLE_MM_OUTPUT_REGISTER          1
   set_instance_parameter_value   edi_packet_reader             SUPPORT_BEATS_OVERFLOW_PRETECTION  0
 

   # --------------------------------------------------------------------------------------------------
   # -- Routing, duplicator and muxes                                                                --
   # --------------------------------------------------------------------------------------------------

   # The video input duplicator 
   add_instance                   video_in_duplicator           alt_vip_packet_duplicator    $isVersion
   set_instance_parameter_value   video_in_duplicator           DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   video_in_duplicator           PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   video_in_duplicator           USE_COMMAND                  0
   set_instance_parameter_value   video_in_duplicator           DEPTH                        4
   set_instance_parameter_value   video_in_duplicator           DUPLICATOR_FANOUT            2
   set_instance_parameter_value   video_in_duplicator           REGISTER_OUTPUT              1
   set_instance_parameter_value   video_in_duplicator           PIPELINE_READY               1
   set_instance_parameter_value   video_in_duplicator           SRC_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           DST_WIDTH                    8
   set_instance_parameter_value   video_in_duplicator           CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_duplicator           TASK_WIDTH                   8
   set_instance_parameter_value   video_in_duplicator           USER_WIDTH                   0

   
   # Ouput mux - used to merge user packets/progressive passthrough and the video output from the dil algorithm 
   add_instance                   output_mux                    alt_vip_packet_mux           $isVersion
   set_instance_parameter_value   output_mux                    DATA_WIDTH                   $video_data_width
   set_instance_parameter_value   output_mux                    PIXELS_IN_PARALLEL           $pixels_in_parallel
   set_instance_parameter_value   output_mux                    NUM_INPUTS                   2
   set_instance_parameter_value   output_mux                    REGISTER_OUTPUT              1
   set_instance_parameter_value   output_mux                    PIPELINE_READY               1
   set_instance_parameter_value   output_mux                    SRC_WIDTH                    8
   set_instance_parameter_value   output_mux                    DST_WIDTH                    8
   set_instance_parameter_value   output_mux                    CONTEXT_WIDTH                8
   set_instance_parameter_value   output_mux                    TASK_WIDTH                   8
   set_instance_parameter_value   output_mux                    USER_WIDTH                   0

   add_instance                   video_in_op0_pipNto1          alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   video_in_op0_pipNto1          PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par]
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_IN        $pixels_in_parallel
   set_instance_parameter_value   video_in_op0_pipNto1          PIXELS_IN_PARALLEL_OUT       1
   set_instance_parameter_value   video_in_op0_pipNto1          FIFO_DEPTH                   $pip_fifo_depth
   set_instance_parameter_value   video_in_op0_pipNto1          PIPELINE_READY               1
   set_instance_parameter_value   video_in_op0_pipNto1          SRC_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          DST_WIDTH                    8
   set_instance_parameter_value   video_in_op0_pipNto1          CONTEXT_WIDTH                8
   set_instance_parameter_value   video_in_op0_pipNto1          TASK_WIDTH                   8

   add_instance                   edi_packet_reader_pip1toN     alt_vip_pip_converter_core   $isVersion
   set_instance_parameter_value   edi_packet_reader_pip1toN     PIXEL_WIDTH                  [expr $bits_per_symbol * $symbols_in_par]
   set_instance_parameter_value   edi_packet_reader_pip1toN     PIXELS_IN_PARALLEL_IN        1
   set_instance_parameter_value   edi_packet_reader_pip1toN     PIXELS_IN_PARALLEL_OUT       $pixels_in_parallel
   set_instance_parameter_value   edi_packet_reader_pip1toN     FIFO_DEPTH                   $pip_fifo_depth
   set_instance_parameter_value   edi_packet_reader_pip1toN     PIPELINE_READY               1
   set_instance_parameter_value   edi_packet_reader_pip1toN     SRC_WIDTH                    8
   set_instance_parameter_value   edi_packet_reader_pip1toN     DST_WIDTH                    8
   set_instance_parameter_value   edi_packet_reader_pip1toN     CONTEXT_WIDTH                8
   set_instance_parameter_value   edi_packet_reader_pip1toN     TASK_WIDTH                   8

   
}


# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Connection of sub-components                                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------
proc weave_composition_callback_connections {} {

   set runtime_control              [get_parameter_value RUNTIME_CONTROL]
   set clocks_are_separate          [get_parameter_value CLOCKS_ARE_SEPARATE]

   # --------------------------------------------------------------------------------------------------
   # -- Top-level interfaces                                                                         --
   # --------------------------------------------------------------------------------------------------
   add_interface             av_st_clock                   clock             end
   add_interface             av_st_reset                   reset             end
   
   if {$clocks_are_separate} {
     add_interface           av_mm_clock                   clock             end
     add_interface           av_mm_reset                   reset             end
   }

   add_interface             edi_read_master               avalon            master
   add_interface             write_master                  avalon            master
   
   if {$runtime_control} {
      add_interface          control                       avalon            slave
      set_interface_property control                       export_of         scheduler.av_mm_control
   }

   add_interface             din                           avalon_streaming  sink 
   add_interface             dout                          avalon_streaming  source

   set_interface_property    av_st_clock                   export_of         av_st_clk_bridge.in_clk
   set_interface_property    av_st_reset                   export_of         av_st_reset_bridge.in_reset
   set_interface_property    av_st_clock                   PORT_NAME_MAP     {av_st_clock in_clk}
   set_interface_property    av_st_reset                   PORT_NAME_MAP     {av_st_reset in_reset}

   if {$clocks_are_separate} {
     set_interface_property  av_mm_clock                   export_of         av_mm_clk_bridge.in_clk
     set_interface_property  av_mm_reset                   export_of         av_mm_reset_bridge.in_reset
     set_interface_property  av_mm_clock                   PORT_NAME_MAP     {av_mm_clock in_clk}
     set_interface_property  av_mm_reset                   PORT_NAME_MAP     {av_mm_reset in_reset}
   }

   set_interface_property    dout                          export_of         video_out.av_st_vid_dout
   set_interface_property    din                           export_of         video_in.av_st_vid_din
 
 
   set_interface_property    write_master                  export_of         packet_writer.av_mm_master
   set_interface_property    edi_read_master               export_of         edi_packet_reader.av_mm_master   

   # --------------------------------------------------------------------------------------------------
   # -- Connecting clocks and resets                                                                 --
   # --------------------------------------------------------------------------------------------------
   add_connection            av_st_clk_bridge.out_clk            av_st_reset_bridge.clk
   
   if {$clocks_are_separate} {
     add_connection          av_mm_clk_bridge.out_clk            av_mm_reset_bridge.clk
   }

   add_connection            av_st_clk_bridge.out_clk            video_in.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in.main_reset
   add_connection            av_st_clk_bridge.out_clk            video_out.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_out.main_reset
   add_connection            av_st_clk_bridge.out_clk            scheduler.main_clock
   add_connection            av_st_reset_bridge.out_reset        scheduler.main_reset

   add_connection            av_st_clk_bridge.out_clk            packet_writer.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        packet_writer.av_st_reset
   add_connection            av_st_clk_bridge.out_clk            edi_packet_reader.av_st_clock
   add_connection            av_st_reset_bridge.out_reset        edi_packet_reader.av_st_reset

   add_connection            av_st_clk_bridge.out_clk            video_in_duplicator.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_duplicator.main_reset
   add_connection            av_st_clk_bridge.out_clk            output_mux.main_clock
   add_connection            av_st_reset_bridge.out_reset        output_mux.main_reset
   
   if ($clocks_are_separate) {
     add_connection          av_mm_clk_bridge.out_clk            edi_packet_reader.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        edi_packet_reader.av_mm_reset
     add_connection          av_mm_clk_bridge.out_clk            packet_writer.av_mm_clock
     add_connection          av_mm_reset_bridge.out_reset        packet_writer.av_mm_reset
   } 
  
   add_connection            av_st_clk_bridge.out_clk            video_in_op0_pipNto1.main_clock
   add_connection            av_st_reset_bridge.out_reset        video_in_op0_pipNto1.main_reset
  
  
   add_connection            av_st_clk_bridge.out_clk           edi_packet_reader_pip1toN.main_clock
   add_connection            av_st_reset_bridge.out_reset       edi_packet_reader_pip1toN.main_reset
  

   # --------------------------------------------------------------------------------------------------
   # -- Interblocks connections                                                                      --
   # --------------------------------------------------------------------------------------------------
   add_connection            video_in.av_st_dout                         video_in_duplicator.av_st_din            
   
   add_connection            video_in_duplicator.av_st_dout_0            video_in_op0_pipNto1.av_st_din
   add_connection            video_in_op0_pipNto1.av_st_dout             packet_writer.av_st_din               
                 
   add_connection            video_in_duplicator.av_st_dout_1            output_mux.av_st_din_0
   
   add_connection            edi_packet_reader.av_st_dout                edi_packet_reader_pip1toN.av_st_din    
   add_connection            edi_packet_reader_pip1toN.av_st_dout        output_mux.av_st_din_1    
   
   add_connection            output_mux.av_st_dout                       video_out.av_st_din                   

   

   # --------------------------------------------------------------------------------------------------
   # -- Scheduler connections                                                                        --
   # --------------------------------------------------------------------------------------------------
   add_connection            scheduler.cmd0                      video_in.av_st_cmd 
   add_connection            scheduler.cmd1                      video_out.av_st_cmd 
   add_connection            scheduler.cmd2                      packet_writer.av_st_cmd 
   add_connection            scheduler.cmd3                      edi_packet_reader.av_st_cmd 
   add_connection            scheduler.cmd4                      output_mux.av_st_cmd    

   add_connection            video_in.av_st_resp                 scheduler.resp0 

}

## Add documentation links for user guide and/or release notes
add_documentation_link "User Guide" https://documentation.altera.com/#/link/bhc1411020596507/bhc1411019828278
add_documentation_link "Release Notes" https://documentation.altera.com/#/link/hco1421698042087/hco1421697985505/en-us
