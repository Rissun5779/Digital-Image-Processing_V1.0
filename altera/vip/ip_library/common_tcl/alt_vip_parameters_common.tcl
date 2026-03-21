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


package require -exact qsys 16.1

# --------------------------------------------------------------------------------------------------
# --                                                                                              --
# -- Declaration for the common parameters used by the VIP cores and component;                   --
# -- includes default valid range and description                                                 --
# --                                                                                              --
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# -- Port/Pixel/Color Sample dimension parameters                                                 --
# --------------------------------------------------------------------------------------------------
# -- add_bits_per_symbol_parameters           BITS_PER_SYMBOL                                     --
# -- add_in_out_bits_per_symbol_parameters    INPUT_BITS_PER_SYMBOL/OUTPUT_BITS_PER_SYMBOL        --
# -- add_data_width_parameters                DATA_WIDTH                                          --
# -- add_channels_nb_parameters               NUMBER_OF_COLOR_PLANES/COLOR_PLANES_ARE_IN_PARALLEL --
# -- add_pixels_in_parallel_parameters        PIXELS_IN_PARALLEL                                  --
# -- add_in_out_pixels_in_parallel_parameters PIXELS_IN_PARALLEL_IN/PIXELS_IN_PARALLEL_OUT        --



proc add_bits_per_symbol_parameters {{bits_per_symbol_min 4} {bits_per_symbol_max 20}} {
    add_parameter BITS_PER_SYMBOL INTEGER 8
    set_parameter_property    BITS_PER_SYMBOL   DISPLAY_NAME            "Bits per color sample"
    set_parameter_property    BITS_PER_SYMBOL   ALLOWED_RANGES          $bits_per_symbol_min:$bits_per_symbol_max
    set_parameter_property    BITS_PER_SYMBOL   DESCRIPTION             "The number of bits used per color plane sample"
    set_parameter_property    BITS_PER_SYMBOL   HDL_PARAMETER           true
    set_parameter_property    BITS_PER_SYMBOL   AFFECTS_ELABORATION     true

    add_display_item   "Video Data Format"     BITS_PER_SYMBOL         parameter
}

proc add_in_out_bits_per_symbol_parameters {{bits_per_symbol_min 4} {bits_per_symbol_max 20}} {
    add_parameter INPUT_BITS_PER_SYMBOL INTEGER 8
    set_parameter_property    INPUT_BITS_PER_SYMBOL   DISPLAY_NAME            "Input bits per color sample"
    set_parameter_property    INPUT_BITS_PER_SYMBOL   ALLOWED_RANGES          $bits_per_symbol_min:$bits_per_symbol_max
    set_parameter_property    INPUT_BITS_PER_SYMBOL   DESCRIPTION             "The number of bits used per color plane sample for input streams"
    set_parameter_property    INPUT_BITS_PER_SYMBOL   HDL_PARAMETER           true
    set_parameter_property    INPUT_BITS_PER_SYMBOL   AFFECTS_ELABORATION     true

    add_parameter OUTPUT_BITS_PER_SYMBOL INTEGER 8
    set_parameter_property    OUTPUT_BITS_PER_SYMBOL   DISPLAY_NAME            "Output bits per color sample"
    set_parameter_property    OUTPUT_BITS_PER_SYMBOL   ALLOWED_RANGES          $bits_per_symbol_min:$bits_per_symbol_max
    set_parameter_property    OUTPUT_BITS_PER_SYMBOL   DESCRIPTION             "The number of bits used per color plane sample for output streams"
    set_parameter_property    OUTPUT_BITS_PER_SYMBOL   HDL_PARAMETER           true
    set_parameter_property    OUTPUT_BITS_PER_SYMBOL   AFFECTS_ELABORATION     true
}

proc add_data_width_parameters {{data_width_min 4} {data_width_max 1024}} {
   # DATA_WIDTH parameter used for non-processing 'utility' components e.g. mux, duplicator that don't care about pixel formats
   add_parameter DATA_WIDTH INTEGER 8
   set_parameter_property DATA_WIDTH         ALLOWED_RANGES       $data_width_min:$data_width_max
   set_parameter_property DATA_WIDTH         DISPLAY_NAME         "Width of payload data"
   set_parameter_property DATA_WIDTH         DESCRIPTION          "Total width of the data payload on the Avalon-ST Message interfaces"
   set_parameter_property DATA_WIDTH         AFFECTS_ELABORATION  true
   set_parameter_property DATA_WIDTH         HDL_PARAMETER        true
}

proc add_channels_nb_parameters {{max_nb_channels 4}} {
    # NUMBER_OF_COLOR_PLANES (with default 1-4 range) and boolean COLOR_PLANES_ARE_IN_PARALLEL parameters,
    add_parameter NUMBER_OF_COLOR_PLANES INTEGER [min 2 $max_nb_channels]
    set_parameter_property   NUMBER_OF_COLOR_PLANES           DISPLAY_NAME           "Number of color planes"
    set_parameter_property   NUMBER_OF_COLOR_PLANES           ALLOWED_RANGES         1:$max_nb_channels
    set_parameter_property   NUMBER_OF_COLOR_PLANES           DESCRIPTION            "The number of color planes transmitted"
    set_parameter_property   NUMBER_OF_COLOR_PLANES           HDL_PARAMETER          true
    set_parameter_property   NUMBER_OF_COLOR_PLANES           AFFECTS_ELABORATION    true

    add_parameter COLOR_PLANES_ARE_IN_PARALLEL INTEGER 1
    set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    DISPLAY_NAME           "Color planes transmitted in parallel"
    set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    ALLOWED_RANGES         0:1
    set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    DISPLAY_HINT           boolean
    set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    DESCRIPTION            "Whether color planes are transmitted in parallel"
    set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    HDL_PARAMETER          true
    set_parameter_property   COLOR_PLANES_ARE_IN_PARALLEL    AFFECTS_ELABORATION    true

    add_display_item   "Video Data Format"     NUMBER_OF_COLOR_PLANES     parameter
    add_display_item   "Video Data Format"     COLOR_PLANES_ARE_IN_PARALLEL  parameter
}

proc add_pixels_in_parallel_parameters {{allowed_values {}}} {
    global vipsuite_allowed_pip_ranges

    #apply default if no args used
    if {[llength $allowed_values] == 0} {
       set allowed_values $vipsuite_allowed_pip_ranges
    }

    add_parameter PIXELS_IN_PARALLEL INTEGER 1
    set_parameter_property    PIXELS_IN_PARALLEL   DISPLAY_NAME            "Number of pixels in parallel"
    set_parameter_property    PIXELS_IN_PARALLEL   ALLOWED_RANGES          $allowed_values
    set_parameter_property    PIXELS_IN_PARALLEL   DESCRIPTION             "The number of pixels transmitted every clock cycle."
    set_parameter_property    PIXELS_IN_PARALLEL   HDL_PARAMETER           true
    set_parameter_property    PIXELS_IN_PARALLEL   AFFECTS_ELABORATION     true

    add_display_item   "Video Data Format"     PIXELS_IN_PARALLEL         parameter
}

proc add_in_out_pixels_in_parallel_parameters {{allowed_values {}}} {
    global vipsuite_allowed_pip_ranges

    #apply default if no args used
    if {[llength $allowed_values] == 0} {
       set allowed_values $vipsuite_allowed_pip_ranges
    }

    add_parameter PIXELS_IN_PARALLEL_IN INTEGER 1
    set_parameter_property    PIXELS_IN_PARALLEL_IN    DISPLAY_NAME            "Number of input pixels in parallel"
    set_parameter_property    PIXELS_IN_PARALLEL_IN    ALLOWED_RANGES          $allowed_values
    set_parameter_property    PIXELS_IN_PARALLEL_IN    DESCRIPTION             "The number of input pixels transmitted every clock cycle."
    set_parameter_property    PIXELS_IN_PARALLEL_IN    HDL_PARAMETER           true
    set_parameter_property    PIXELS_IN_PARALLEL_IN    AFFECTS_ELABORATION     true

    add_parameter PIXELS_IN_PARALLEL_OUT INTEGER 1
    set_parameter_property    PIXELS_IN_PARALLEL_OUT   DISPLAY_NAME            "Number of output pixels in parallel"
    set_parameter_property    PIXELS_IN_PARALLEL_OUT   ALLOWED_RANGES          $allowed_values
    set_parameter_property    PIXELS_IN_PARALLEL_OUT   DESCRIPTION             "The number of output pixels transmitted every clock cycle."
    set_parameter_property    PIXELS_IN_PARALLEL_OUT   HDL_PARAMETER           true
    set_parameter_property    PIXELS_IN_PARALLEL_OUT   AFFECTS_ELABORATION     true
}

# --------------------------------------------------------------------------------------------------
# -- Image dimension parameters                                                                   --
# --------------------------------------------------------------------------------------------------
# -- add_max_dim_parameters                    MAX_WIDTH/MAX_HEIGHT                               --
# -- add_max_in_dim_parameters                 MAX_IN_WIDTH/MAX_IN_HEIGHT                         --
# -- add_max_out_dim_parameters                MAX_OUT_WIDTH/MAX_OUT_HEIGHT                       --
# -- add_max_line_length_parameters            MAX_LINE_LENGTH                                    --
# -- add_max_field_height_parameters           MAX_FIELD_HEIGHT                                   --

proc add_max_dim_parameters {{x_min 32} {x_max -99} {y_min 32} {y_max -99}} {

    global vipsuite_max_width
    global vipsuite_max_height

    #apply default if no args used
    if {$x_max == -99} {
       set x_max $vipsuite_max_width
    }

    if {$y_max == -99} {
       set y_max $vipsuite_max_height
    }


    add_parameter             MAX_WIDTH         INTEGER                  [min $x_max [max $x_min 1920]]
    set_parameter_property    MAX_WIDTH         DISPLAY_NAME             "Maximum frame width"
    set_parameter_property    MAX_WIDTH         ALLOWED_RANGES           $x_min:$x_max
    set_parameter_property    MAX_WIDTH         DESCRIPTION              "The maximum width of images / video frames"
    set_parameter_property    MAX_WIDTH         HDL_PARAMETER            true
    set_parameter_property    MAX_WIDTH         AFFECTS_ELABORATION      true

    add_parameter             MAX_HEIGHT        INTEGER                  [min $y_max [max $y_min 1080]]
    set_parameter_property    MAX_HEIGHT        DISPLAY_NAME             "Maximum frame height"
    set_parameter_property    MAX_HEIGHT        ALLOWED_RANGES           $y_min:$y_max
    set_parameter_property    MAX_HEIGHT        DESCRIPTION              "The maximum height of images / video frames"
    set_parameter_property    MAX_HEIGHT        HDL_PARAMETER            true
    set_parameter_property    MAX_HEIGHT        AFFECTS_ELABORATION      true

    add_display_item   "Avalon-ST Video support"    MAX_WIDTH                  parameter
    add_display_item   "Avalon-ST Video support"    MAX_HEIGHT                 parameter
}

proc add_max_in_dim_parameters {{x_min 32} {x_max -99} {y_min 32} {y_max -99}} {

    global vipsuite_max_width
    global vipsuite_max_height

    #apply default if no args used
    if {$x_max == -99} {
       set x_max $vipsuite_max_width
    }

    if {$y_max == -99} {
       set y_max $vipsuite_max_height
    }

    add_parameter             MAX_IN_WIDTH      INTEGER                  [min $x_max [max $x_min 1920]]
    set_parameter_property    MAX_IN_WIDTH      DISPLAY_NAME             "Maximum input frame width"
    set_parameter_property    MAX_IN_WIDTH      ALLOWED_RANGES           $x_min:$x_max
    set_parameter_property    MAX_IN_WIDTH      DESCRIPTION              "The maximum width of input images / video frames"
    set_parameter_property    MAX_IN_WIDTH      HDL_PARAMETER            true
    set_parameter_property    MAX_IN_WIDTH      AFFECTS_ELABORATION      false

    add_parameter             MAX_IN_HEIGHT     INTEGER                  [min $y_max [max $y_min 1080]]
    set_parameter_property    MAX_IN_HEIGHT     DISPLAY_NAME             "Maximum input frame height"
    set_parameter_property    MAX_IN_HEIGHT     ALLOWED_RANGES           $y_min:$y_max
    set_parameter_property    MAX_IN_HEIGHT     DESCRIPTION              "The maximum height of input images / video frames"
    set_parameter_property    MAX_IN_HEIGHT     HDL_PARAMETER            true
    set_parameter_property    MAX_IN_HEIGHT     AFFECTS_ELABORATION      false
}

proc add_max_out_dim_parameters {{x_min 32} {x_max -99} {y_min 32} {y_max -99}} {

    global vipsuite_max_width
    global vipsuite_max_height

    #apply default if no args used
    if {$x_max == -99} {
       set x_max $vipsuite_max_width
    }

    if {$y_max == -99} {
       set y_max $vipsuite_max_height
    }

    add_parameter             MAX_OUT_WIDTH     INTEGER                  [min $x_max [max $x_min 1920]]
    set_parameter_property    MAX_OUT_WIDTH     DISPLAY_NAME             "Maximum output frame width"
    set_parameter_property    MAX_OUT_WIDTH     ALLOWED_RANGES           $x_min:$x_max
    set_parameter_property    MAX_OUT_WIDTH     DESCRIPTION              "The maximum width of output images / video frames"
    set_parameter_property    MAX_OUT_WIDTH     HDL_PARAMETER            true
    set_parameter_property    MAX_OUT_WIDTH     AFFECTS_ELABORATION      false

    add_parameter             MAX_OUT_HEIGHT    INTEGER                  [min $y_max [max $y_min 1080]]
    set_parameter_property    MAX_OUT_HEIGHT    DISPLAY_NAME             "Maximum output frame height"
    set_parameter_property    MAX_OUT_HEIGHT    ALLOWED_RANGES           $y_min:$y_max
    set_parameter_property    MAX_OUT_HEIGHT    DESCRIPTION              "The maximum height of output images / video frames"
    set_parameter_property    MAX_OUT_HEIGHT    HDL_PARAMETER            true
    set_parameter_property    MAX_OUT_HEIGHT    AFFECTS_ELABORATION      false
}

proc add_max_line_length_parameters {{min_length 32} {max_length -99} } {

    global vipsuite_max_width

    #apply default if no args used
    if {$max_length == -99} {
       set max_length $vipsuite_max_width
    }

    add_parameter            MAX_LINE_LENGTH    INTEGER                           [min $max_length [max $min_length 1920]]
    set_parameter_property   MAX_LINE_LENGTH    ALLOWED_RANGES                    $min_length:$max_length
    set_parameter_property   MAX_LINE_LENGTH    DISPLAY_NAME                      "Maximum line length"
    set_parameter_property   MAX_LINE_LENGTH    HDL_PARAMETER                     true
    set_parameter_property   MAX_LINE_LENGTH    AFFECTS_GENERATION                false
    set_parameter_property   MAX_LINE_LENGTH    AFFECTS_ELABORATION               false
}

proc add_max_field_height_parameters { {min_length 16} {max_length -99 }} {
    global vipsuite_max_width

    #apply default if no args used
    if {$max_length == -99} {
       set max_length $vipsuite_max_width
    }

    add_parameter            MAX_FIELD_HEIGHT    INTEGER                           [min $max_length [max $min_length 540]]
    set_parameter_property   MAX_FIELD_HEIGHT    ALLOWED_RANGES                    $min_length:$max_length
    set_parameter_property   MAX_FIELD_HEIGHT    DISPLAY_NAME                      "Maximum field height"
    set_parameter_property   MAX_FIELD_HEIGHT    HDL_PARAMETER                  true
    set_parameter_property   MAX_FIELD_HEIGHT    AFFECTS_GENERATION                false
    set_parameter_property   MAX_FIELD_HEIGHT    AFFECTS_ELABORATION               false
}


# --------------------------------------------------------------------------------------------------
# -- Master/Slave parameters                                                                      --
# --------------------------------------------------------------------------------------------------
# -- add_common_masters_parameters            CLOCKS_ARE_SEPARATE/MEM_PORT_WIDTH                  --
# -- add_base_address_parameters              MEM_BASE_ADDR/MEM_TOP_ADDR                          --
# -- add_burst_align_parameters               BURST_ALIGNMENT                                     --
# -- add_bursting_master_parameters           {master}_FIFO_DEPTH/{master}_BURST_TARGET           --
# -- add_packet_transfer_master_parameters    {master}_BUFFER_RATIO/{master}_BURST_TARGET         --
# -- add_runtime_control_parameters           RUNTIME_CONTROL/LIMITED_READBACK                    --

proc add_common_masters_parameters {} {
    # CLOCKS_ARE_SEPARATE parameter, master bus clock rate is not the same as the core
    add_parameter CLOCKS_ARE_SEPARATE INTEGER 1
    set_parameter_property   CLOCKS_ARE_SEPARATE   DISPLAY_NAME           "Use separate clock for the Avalon-MM master interface(s)"
    set_parameter_property   CLOCKS_ARE_SEPARATE   ALLOWED_RANGES         0:1
    set_parameter_property   CLOCKS_ARE_SEPARATE   DISPLAY_HINT           boolean
    set_parameter_property   CLOCKS_ARE_SEPARATE   DESCRIPTION            "Use separate clock for the Avalon-MM master interface(s)"
    set_parameter_property   CLOCKS_ARE_SEPARATE   HDL_PARAMETER          true
    set_parameter_property   CLOCKS_ARE_SEPARATE   AFFECTS_ELABORATION    true

    add_parameter MEM_PORT_WIDTH INTEGER 256
    set_parameter_property   MEM_PORT_WIDTH        DISPLAY_NAME           "Avalon-MM master(s) local ports width"
    set_parameter_property   MEM_PORT_WIDTH        ALLOWED_RANGES         {16 32 64 128 256 512}
    set_parameter_property   MEM_PORT_WIDTH        DESCRIPTION            "The width in bits of the Avalon-MM master port(s)"
    set_parameter_property   MEM_PORT_WIDTH        HDL_PARAMETER          true
    set_parameter_property   MEM_PORT_WIDTH        AFFECTS_ELABORATION    true
}

proc add_base_address_parameters {} {
    # MEM_BASE_ADDR parameter, start address of the memory space allocated to the core
    # MEM_TOP_ADDR parameter,  top address of the memory space allocated to the core (derived)
    add_parameter MEM_BASE_ADDR INTEGER 0
    set_parameter_property   MEM_BASE_ADDR         DISPLAY_NAME           "Base address of storage space in memory"
    set_parameter_property   MEM_BASE_ADDR         ALLOWED_RANGES         0:'h7FFFFFFF
    set_parameter_property   MEM_BASE_ADDR         DISPLAY_HINT           hexadecimal
    set_parameter_property   MEM_BASE_ADDR         DESCRIPTION            "The base address for the storage space used in memory"
    set_parameter_property   MEM_BASE_ADDR         HDL_PARAMETER          true
    set_parameter_property   MEM_BASE_ADDR         AFFECTS_ELABORATION    true

    add_parameter MEM_TOP_ADDR INTEGER 0
    set_parameter_property   MEM_TOP_ADDR          DISPLAY_NAME           "Top of address space"
    set_parameter_property   MEM_TOP_ADDR          ALLOWED_RANGES         0:'h7FFFFFFF
    set_parameter_property   MEM_TOP_ADDR          DISPLAY_HINT           hexadecimal
    set_parameter_property   MEM_TOP_ADDR          DESCRIPTION            "Top of deinterlacer address space. Memory above this address is available for other components."
    set_parameter_property   MEM_TOP_ADDR          DERIVED                true
    set_parameter_property   MEM_TOP_ADDR          HDL_PARAMETER          false
    set_parameter_property   MEM_TOP_ADDR          ENABLED                false
    set_parameter_property   MEM_TOP_ADDR          AFFECTS_ELABORATION    false
}

proc add_bursting_master_parameters {master_name master_gui_name} {
    # Parameters to set the burst size and how much storage is allocated to prepare MM bursts
    set FIFO_DEPTH ${master_name}_FIFO_DEPTH
    set BURST_TARGET ${master_name}_BURST_TARGET
    add_parameter $FIFO_DEPTH INTEGER 64
    set_parameter_property   $FIFO_DEPTH                 DISPLAY_NAME              "FIFO depth $master_gui_name"
    set_parameter_property   $FIFO_DEPTH                 ALLOWED_RANGES            {8 16 32 64 128 256 512}
    set_parameter_property   $FIFO_DEPTH                 DESCRIPTION               "The depth of the $master_gui_name FIFO"
    set_parameter_property   $FIFO_DEPTH                 HDL_PARAMETER             true
    set_parameter_property   $FIFO_DEPTH                 AFFECTS_ELABORATION       true

    add_parameter $BURST_TARGET INTEGER 32
    set_parameter_property   $BURST_TARGET               DISPLAY_NAME              "Av-MM burst target $master_gui_name"
    set_parameter_property   $BURST_TARGET               ALLOWED_RANGES            {2 4 8 16 32 64}
    set_parameter_property   $BURST_TARGET               DESCRIPTION               "The target burst size of the Av-MM $master_gui_name"
    set_parameter_property   $BURST_TARGET               HDL_PARAMETER             true
    set_parameter_property   $BURST_TARGET               AFFECTS_ELABORATION       true
}

proc add_packet_transfer_master_parameters {master_name master_gui_name} {
    # Parameters to set the burst size and how much storage is allocated to prepare MM bursts
    set BUFFER_RATIO CONTEXT_BUFFER_RATIO_${master_name}
    set BURST_TARGET BURST_TARGET_${master_name}
    add_parameter $BUFFER_RATIO INTEGER 4
    set_parameter_property   $BUFFER_RATIO               DISPLAY_NAME              "$master_gui_name Buffer depth (in number of burst word)"
    set_parameter_property   $BUFFER_RATIO               ALLOWED_RANGES            {2 4 8 16 32 64 128 256}
    set_parameter_property   $BUFFER_RATIO               DESCRIPTION               "Buffer depth of $master_gui_name in number of burst word"
    set_parameter_property   $BUFFER_RATIO               HDL_PARAMETER             true
    set_parameter_property   $BUFFER_RATIO               AFFECTS_ELABORATION       true

    add_parameter $BURST_TARGET INTEGER 8
    set_parameter_property   $BURST_TARGET               DISPLAY_NAME              "$master_gui_name FIFO burst target"
    set_parameter_property   $BURST_TARGET               ALLOWED_RANGES            {2 4 8 16 32 64 128 256 512}
    set_parameter_property   $BURST_TARGET               DESCRIPTION               "The target burst size of the $master_gui_name"
    set_parameter_property   $BURST_TARGET               HDL_PARAMETER             true
    set_parameter_property   $BURST_TARGET               AFFECTS_ELABORATION       true
}

proc add_burst_align_parameters {} {
    # BURST_ALIGNMENT boolean parameter, used to prevent the core from issuing a burst that cross defined boundaries
    add_parameter BURST_ALIGNMENT INTEGER 1
    set_parameter_property   BURST_ALIGNMENT             DISPLAY_NAME              "Align read/write bursts on read boundaries"
    set_parameter_property   BURST_ALIGNMENT             ALLOWED_RANGES            0:1
    set_parameter_property   BURST_ALIGNMENT             DISPLAY_HINT              boolean
    set_parameter_property   BURST_ALIGNMENT             DESCRIPTION               "Prevent memory transactions across memory row boundaries"
    set_parameter_property   BURST_ALIGNMENT             HDL_PARAMETER             true
    set_parameter_property   BURST_ALIGNMENT             AFFECTS_ELABORATION       false
}


proc add_runtime_control_parameters { {with_readback_param 0} } {
    add_parameter            RUNTIME_CONTROL       INTEGER                 0
    set_parameter_property   RUNTIME_CONTROL       DISPLAY_NAME            "Run-time control"
    set_parameter_property   RUNTIME_CONTROL       ALLOWED_RANGES          0:1
    set_parameter_property   RUNTIME_CONTROL       DISPLAY_HINT            boolean
    set_parameter_property   RUNTIME_CONTROL       DESCRIPTION             "Enables run-time control of alpha channels"
    set_parameter_property   RUNTIME_CONTROL       HDL_PARAMETER           true
    set_parameter_property   RUNTIME_CONTROL       AFFECTS_ELABORATION     true

    if {$with_readback_param == 1} {
        add_parameter            LIMITED_READBACK      INTEGER                 0
        set_parameter_property   LIMITED_READBACK      DISPLAY_NAME            "Reduced control register readback"
        set_parameter_property   LIMITED_READBACK      DESCRIPTION             "Disable read back on control register other than control, status and interrupt."
        set_parameter_property   LIMITED_READBACK      ALLOWED_RANGES          0:1
        set_parameter_property   LIMITED_READBACK      DISPLAY_HINT            boolean
        set_parameter_property   LIMITED_READBACK      AFFECTS_ELABORATION     true
        set_parameter_property   LIMITED_READBACK      HDL_PARAMETER           true
    }
}

# --------------------------------------------------------------------------------------------------
# -- User packets handling parameters                                                             --
# --------------------------------------------------------------------------------------------------
# -- add_user_packet_support_parameters       USER_PACKET_SUPPORT/USER_PACKET_FIFO_DEPTH          --
# -- add_user_packets_mem_storage_parameters  USER_PACKETS_MAX_STORAGE/MAX_SYMBOLS_PER_PACKET     --
# -- add_conversion_mode_parameters           CONVERSION_MODE                                     --
proc add_user_packet_support_parameters { {default_support PASSTHROUGH} {with_fifo 1} } {

    add_parameter            USER_PACKET_SUPPORT      STRING                    $default_support
    set_parameter_property   USER_PACKET_SUPPORT      DISPLAY_NAME              "How user packets are handled"
    set_parameter_property   USER_PACKET_SUPPORT      ALLOWED_RANGES            {"NONE_ALLOWED:No user packets allowed" "DISCARD:Discard all user packets received" "PASSTHROUGH:Pass all user packets through to the output"}
    set_parameter_property   USER_PACKET_SUPPORT      DISPLAY_HINT              radio
    set_parameter_property   USER_PACKET_SUPPORT      DESCRIPTION               "Define how user packets are handled by the block"
    set_parameter_property   USER_PACKET_SUPPORT      HDL_PARAMETER             true
    set_parameter_property   USER_PACKET_SUPPORT      AFFECTS_ELABORATION       true

    add_display_item   "Avalon-ST Video support"    USER_PACKET_SUPPORT           parameter

    if {$with_fifo == 1} {
        add_parameter            USER_PACKET_FIFO_DEPTH   INTEGER                   0
        set_parameter_property   USER_PACKET_FIFO_DEPTH   DISPLAY_NAME              "User packet processing path FIFO depth"
        set_parameter_property   USER_PACKET_FIFO_DEPTH   ALLOWED_RANGES            {0 8 16 32 64 128 256 512}
        set_parameter_property   USER_PACKET_FIFO_DEPTH   DESCRIPTION               "The depth of the FIFO in the bypass path used for user packets."
        set_parameter_property   USER_PACKET_FIFO_DEPTH   HDL_PARAMETER             true
        set_parameter_property   USER_PACKET_FIFO_DEPTH   AFFECTS_ELABORATION       true
    }
}

proc add_user_packets_mem_storage_parameters {} {
    # Paramers to reserve space for buffering user packets in memory
    add_parameter            USER_PACKETS_MAX_STORAGE    INTEGER                   0
    set_parameter_property   USER_PACKETS_MAX_STORAGE    DISPLAY_NAME              "Storage space for user packets"
    set_parameter_property   USER_PACKETS_MAX_STORAGE    ALLOWED_RANGES            0:32
    set_parameter_property   USER_PACKETS_MAX_STORAGE    DESCRIPTION               "The number of packets that can be buffered before being overwritten"
    set_parameter_property   USER_PACKETS_MAX_STORAGE    HDL_PARAMETER             true
    set_parameter_property   USER_PACKETS_MAX_STORAGE    AFFECTS_ELABORATION       false

    add_parameter            MAX_SYMBOLS_PER_PACKET      INTEGER                   10
    set_parameter_property   MAX_SYMBOLS_PER_PACKET      DISPLAY_NAME              "Maximum packet length"
    set_parameter_property   MAX_SYMBOLS_PER_PACKET      ALLOWED_RANGES            1:16384
    set_parameter_property   MAX_SYMBOLS_PER_PACKET      DESCRIPTION               "The maximum allowed length in symbols for user-defined packets (header included)"
    set_parameter_property   MAX_SYMBOLS_PER_PACKET      HDL_PARAMETER             true
    set_parameter_property   MAX_SYMBOLS_PER_PACKET      AFFECTS_ELABORATION       false
}

proc add_conversion_mode_parameters {} {
    add_parameter            CONVERSION_MODE             STRING                    LSB
    set_parameter_property   CONVERSION_MODE             DISPLAY_NAME              "Conversion method"
    set_parameter_property   CONVERSION_MODE             ALLOWED_RANGES            {MSB LSB}
    set_parameter_property   CONVERSION_MODE             DESCRIPTION               "truncation or padding method"
    set_parameter_property   CONVERSION_MODE             HDL_PARAMETER             true
    set_parameter_property   CONVERSION_MODE             AFFECTS_ELABORATION       true
}

# --------------------------------------------------------------------------------------------------
# -- Misc parameters                                                                              --
# --------------------------------------------------------------------------------------------------
# -- add_rate_control_parameters              RATE_CONTROL                                        --
# -- add_is_422_parameters                    IS_422                                              --
# -- add_cadence_detect_parameters            CADENCE_DETECTION                                   --
# -- add_cadence_algo_parameters              CADENCE_ALGORITHM_NAME                              --
# -- add_deinterlace_algo_parameters          DEINTERLACE_ALGORITHM                               --
# -- add_pipeline_ready_parameters            PIPELINE_READY                                      --
proc add_rate_control_parameters {} {
    # boolean RATE_CONTROL parameter for the core that allows for user-selected frame rate conversion
    add_parameter RATE_CONTROL INTEGER 0
    set_parameter_property   RATE_CONTROL       DISPLAY_NAME           "Controlled frame rate conversion"
    set_parameter_property   RATE_CONTROL       ALLOWED_RANGES         0:1
    set_parameter_property   RATE_CONTROL       DISPLAY_HINT           boolean
    set_parameter_property   RATE_CONTROL       DESCRIPTION            "Run-time control interface to control the frame rate"
    set_parameter_property   RATE_CONTROL       HDL_PARAMETER          true
    set_parameter_property   RATE_CONTROL       AFFECTS_ELABORATION    true
}

proc add_is_422_parameters {} {
    # IS_422 parameter for the cases where the algorithm needs to know it is handling 422 data
    add_parameter            IS_422             INTEGER                   1
    set_parameter_property   IS_422             DISPLAY_NAME              "4:2:2 support"
    set_parameter_property   IS_422             ALLOWED_RANGES            0:1
    set_parameter_property   IS_422             DISPLAY_HINT              boolean
    set_parameter_property   IS_422             DESCRIPTION               "Adapt the processing algorithm for 4:2:2 subsampled data"
    set_parameter_property   IS_422             HDL_PARAMETER             true
    set_parameter_property   IS_422             AFFECTS_ELABORATION       true

    add_display_item   "Video Data Format"     IS_422                     parameter
}

proc add_deinterlace_algo_parameters {} {
    add_parameter            DEINTERLACE_ALGORITHM      STRING                    MOTION_ADAPTIVE_HQ
    set_parameter_property   DEINTERLACE_ALGORITHM      DISPLAY_NAME              "Deinterlacing algorithm"
    set_parameter_property   DEINTERLACE_ALGORITHM      ALLOWED_RANGES            {"BOB:Vertical interpolation (\"Bob\")" "WEAVE:Field weaving (\"Weave\")" "MOTION_ADAPTIVE:Motion Adaptive" "MOTION_ADAPTIVE_HQ:Motion Adaptive High Quality (Sobel edge interpolation)"}
    set_parameter_property   DEINTERLACE_ALGORITHM      DISPLAY_HINT              ""
    set_parameter_property   DEINTERLACE_ALGORITHM      DESCRIPTION               "Selects the deinterlacing algorithm"
    set_parameter_property   DEINTERLACE_ALGORITHM      HDL_PARAMETER             true
    set_parameter_property   DEINTERLACE_ALGORITHM      AFFECTS_ELABORATION       true
}

proc add_cadence_detect_parameters {} {
    # CADENCE_DETECTION parameter to enable cadence detection in the deinterlacer
    add_parameter CADENCE_DETECTION INTEGER 1
    set_parameter_property    CADENCE_DETECTION          DISPLAY_NAME             "Cadence detection and reverse pulldown"
    set_parameter_property    CADENCE_DETECTION          ALLOWED_RANGES           0:1
    set_parameter_property    CADENCE_DETECTION          DISPLAY_HINT             boolean
    set_parameter_property    CADENCE_DETECTION          DESCRIPTION              "Enable automatic cadence detection and reverse pulldown."
    set_parameter_property    CADENCE_DETECTION          HDL_PARAMETER            true
    set_parameter_property    CADENCE_DETECTION          ENABLED                  true
    set_parameter_property    CADENCE_DETECTION          AFFECTS_ELABORATION      true
}

proc add_cadence_algo_parameters {} {
    # Parameterize the cadence detection algorithm
    add_parameter            CADENCE_ALGORITHM_NAME      STRING                    CADENCE_32_22_VOF
    set_parameter_property   CADENCE_ALGORITHM_NAME      DISPLAY_NAME              "Cadence detection algorithm"
    set_parameter_property   CADENCE_ALGORITHM_NAME      ALLOWED_RANGES            {"CADENCE_32:3:2 detector" "CADENCE_22:2:2 detector" "CADENCE_32_22:3:2 & 2:2 detector" "CADENCE_32_22_VOF:3:2 & 2:2 detector with video over film"}
    set_parameter_property   CADENCE_ALGORITHM_NAME      DISPLAY_HINT              ""
    set_parameter_property   CADENCE_ALGORITHM_NAME      DESCRIPTION               "Selects the cadence detection algorithm used"
    set_parameter_property   CADENCE_ALGORITHM_NAME      HDL_PARAMETER             true
    set_parameter_property   CADENCE_ALGORITHM_NAME      AFFECTS_ELABORATION       true
}

proc add_pipeline_ready_parameters {} {
    add_parameter PIPELINE_READY INTEGER 0
    set_parameter_property PIPELINE_READY DISPLAY_NAME "Register Avalon-ST ready signals"
    set_parameter_property PIPELINE_READY ALLOWED_RANGES 0:1
    set_parameter_property PIPELINE_READY DISPLAY_HINT boolean
    set_parameter_property PIPELINE_READY DESCRIPTION "Whether Avalon-ST ready signals are registered "
    set_parameter_property PIPELINE_READY HDL_PARAMETER true
    set_parameter_property PIPELINE_READY AFFECTS_ELABORATION false
}

# --------------------------------------------------------------------------------------------------
# -- Avalon-ST message parameters                                                                 --
# --------------------------------------------------------------------------------------------------
# -- add_av_st_event_parameters               {name}_SRC_WIDTH/{name}_DST_WIDTH/                  --
# --                                          {name}_CONTEXT_WIDTH/{name}_TASK_WIDTH              --
# -- add_av_st_event_user_width_parameters    {name}_USER_WIDTH                                   --

proc add_av_st_event_parameters {{connection_name ""}} {
    if {$connection_name != ""} {
        set SRC_WIDTH         ${connection_name}_SRC_WIDTH
        set DST_WIDTH         ${connection_name}_DST_WIDTH
        set CONTEXT_WIDTH     ${connection_name}_CONTEXT_WIDTH
        set TASK_WIDTH        ${connection_name}_TASK_WIDTH
    } else {
        set SRC_WIDTH         SRC_WIDTH
        set DST_WIDTH         DST_WIDTH
        set CONTEXT_WIDTH     CONTEXT_WIDTH
        set TASK_WIDTH        TASK_WIDTH
    }

    add_parameter $SRC_WIDTH INTEGER 8
    set_parameter_property    $SRC_WIDTH        ALLOWED_RANGES        0:32
    set_parameter_property    $SRC_WIDTH        AFFECTS_ELABORATION   true
    set_parameter_property    $SRC_WIDTH        AFFECTS_GENERATION    true
    set_parameter_property    $SRC_WIDTH        HDL_PARAMETER         true

    add_parameter $DST_WIDTH INTEGER 8
    set_parameter_property    $DST_WIDTH        ALLOWED_RANGES        0:32
    set_parameter_property    $DST_WIDTH        AFFECTS_ELABORATION   true
    set_parameter_property    $DST_WIDTH        AFFECTS_GENERATION    true
    set_parameter_property    $DST_WIDTH        HDL_PARAMETER         true

    add_parameter $CONTEXT_WIDTH INTEGER 8
    set_parameter_property    $CONTEXT_WIDTH        ALLOWED_RANGES        0:32
    set_parameter_property    $CONTEXT_WIDTH        AFFECTS_ELABORATION   true
    set_parameter_property    $CONTEXT_WIDTH        AFFECTS_GENERATION    true
    set_parameter_property    $CONTEXT_WIDTH        HDL_PARAMETER         true

    add_parameter $TASK_WIDTH INTEGER 8
    set_parameter_property    $TASK_WIDTH    ALLOWED_RANGES        0:32
    set_parameter_property    $TASK_WIDTH    AFFECTS_ELABORATION   true
    set_parameter_property    $TASK_WIDTH    AFFECTS_GENERATION    true
    set_parameter_property    $TASK_WIDTH    HDL_PARAMETER         true

    if {$connection_name != ""} {
       set_parameter_property    $SRC_WIDTH        DISPLAY_NAME          "$connection_name Source ID width"
       set_parameter_property    $SRC_WIDTH        DESCRIPTION           "Width of the Source ID signal in $connection_name interface"
       set_parameter_property    $DST_WIDTH        DISPLAY_NAME          "$connection_name Destination ID width"
       set_parameter_property    $DST_WIDTH        DESCRIPTION           "Width of the Destination ID signal in $connection_name interface"
       set_parameter_property    $CONTEXT_WIDTH    DISPLAY_NAME          "$connection_name Context ID width"
       set_parameter_property    $CONTEXT_WIDTH    DESCRIPTION           "Width of the Context ID signal in $connection_name interface"
       set_parameter_property    $TASK_WIDTH       DISPLAY_NAME          "$connection_name Task ID width"
       set_parameter_property    $TASK_WIDTH       DESCRIPTION           "Width of the Task ID signal in $connection_name interface"
    } else {
       set_parameter_property    $SRC_WIDTH        DISPLAY_NAME          "Source ID width"
       set_parameter_property    $SRC_WIDTH        DESCRIPTION           "Width of the Source ID signal"
       set_parameter_property    $DST_WIDTH        DISPLAY_NAME          "Destination ID width"
       set_parameter_property    $DST_WIDTH        DESCRIPTION           "Width of the Destination ID signal"
       set_parameter_property    $CONTEXT_WIDTH    DISPLAY_NAME          "Context ID width"
       set_parameter_property    $CONTEXT_WIDTH    DESCRIPTION           "Width of the Context ID signal"
       set_parameter_property    $TASK_WIDTH       DISPLAY_NAME          "Task ID width"
       set_parameter_property    $TASK_WIDTH       DESCRIPTION           "Width of the Task ID signal"
    }
}

proc add_av_st_event_user_width_parameters {{connection_name ""} {default_width 0}} {

    if {$connection_name != ""} {
        set USER_WIDTH        ${connection_name}_USER_WIDTH
    } else {
        set USER_WIDTH        USER_WIDTH
    }

    add_parameter $USER_WIDTH INTEGER $default_width
    set_parameter_property    $USER_WIDTH       ALLOWED_RANGES        0:32
    set_parameter_property    $USER_WIDTH       AFFECTS_ELABORATION   true
    set_parameter_property    $USER_WIDTH       AFFECTS_GENERATION    true
    set_parameter_property    $USER_WIDTH       HDL_PARAMETER         true
    if {$connection_name != ""} {
       set_parameter_property    $USER_WIDTH       DISPLAY_NAME          "$connection_name User width"
       set_parameter_property    $USER_WIDTH       DESCRIPTION           "Width of the User signal in $connection_name interface"
    } else {
       set_parameter_property    $USER_WIDTH       DISPLAY_NAME          "User width"
       set_parameter_property    $USER_WIDTH       DESCRIPTION           "Width of the User signal"
    }
}


# --------------------------------------------------------------------------------------------------
# -- Device parameters                                                                            --
# --------------------------------------------------------------------------------------------------
# -- add_device_family_parameters              FAMILY                                             --

proc add_device_family_parameters {{family_name "Cyclone IV"}} {
    add_parameter          FAMILY string       $family_name
    set_parameter_property FAMILY DISPLAY_NAME "Device family"
    set_parameter_property FAMILY DESCRIPTION  "Currently selected device family"
    set_parameter_property FAMILY SYSTEM_INFO  {DEVICE_FAMILY}
    set_parameter_property FAMILY VISIBLE false
}



# --------------------------------------------------------------------------------------------------
# -- Callbacks helpers                                                                            --
# --------------------------------------------------------------------------------------------------
# -- pip_validation_callback_helper                                                               --
# -- user_packet_support_validation_callback_helper                                               --
# -- conversion_mode_validation_callback_helper                                                   --
# -- runtime_control_validation_callback_helper                                                   --
proc pip_validation_callback_helper { } {
    set cpip    [get_parameter_value COLOR_PLANES_ARE_IN_PARALLEL]
    set pip     [get_parameter_value PIXELS_IN_PARALLEL]
    if { $pip > 1 && $cpip == 0 } {
        send_message error   "Color planes must be transmitted in parallel to enable more than 1 pixel in parallel"
    }
}

proc user_packet_support_validation_callback_helper { } {
    set user_packet_support   [get_parameter_value USER_PACKET_SUPPORT]
    if {[string equal $user_packet_support "PASSTHROUGH"]} {
        set_parameter_property   USER_PACKET_FIFO_DEPTH   ENABLED  true
    } else {
        set_parameter_property   USER_PACKET_FIFO_DEPTH   ENABLED  false
    }
}

proc conversion_mode_validation_callback_helper { } {
    set input_bits_per_symbol            [get_parameter_value INPUT_BITS_PER_SYMBOL]
    set output_bits_per_symbol           [get_parameter_value OUTPUT_BITS_PER_SYMBOL]
    set conversion_enabled               [expr $input_bits_per_symbol != $output_bits_per_symbol]
    if { [lsearch [get_parameters] USER_PACKET_SUPPORT] >= 0 } {
        set user_packet_support              [get_parameter_value USER_PACKET_SUPPORT]
        set passthrough                      [string equal $user_packet_support PASSTHROUGH]
        set conversion_enabled               [expr $passthrough && $conversion_enabled]
    }
    set_parameter_property   CONVERSION_MODE   ENABLED   $conversion_enabled
}


proc runtime_control_validation_callback_helper { } {
    set runtime_control    [get_parameter_value RUNTIME_CONTROL]
    if {$runtime_control} {
        set_parameter_property LIMITED_READBACK  ENABLED  true
    } else {
        set_parameter_property LIMITED_READBACK  ENABLED  false
    }
}


# --------------------------------------------------------------------------------------------------
# -- Assignment helpers (for embedded SW flows)                                                   --
# -- Make sure the functions are called from the generation/compose section                       --
# -- The selected parameters must have affects_[elaboration|generation] set to true               --
# -- set_dts_assignments  create dts assigments to build a linux driver                           --
# -- set_nios_assignments create macro assigments in system.h                                     --
# --------------------------------------------------------------------------------------------------
proc set_dts_assignments {dts_params} {
    set module_name          [get_module_property NAME]

    set_module_assignment embeddedsw.dts.vendor          "altr"
    set_module_assignment embeddedsw.dts.group           "vip"
    set_module_assignment embeddedsw.dts.name            "$module_name"
    set_module_assignment embeddedsw.dts.compatible      "altr,$module_name"

    foreach param $dts_params {
        set_module_assignment     embeddedsw.dts.params.$param       [get_parameter_value  $param]
    }
}

proc set_nios_assignments {nios_params} {
    set module_name          [get_module_property NAME]
    set uc_module_name       [string toupper $module_name]

    foreach param $nios_params {
        set macro_name            {$uc_module_name}_{$param}
        set_module_assignment     embeddedsw.CMacro.$macro_name      [get_parameter_value  $param]
    }
}
