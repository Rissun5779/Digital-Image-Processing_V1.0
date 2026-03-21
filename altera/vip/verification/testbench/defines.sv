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


`ifndef __DEFINES
`define __DEFINES

// Avalon-ST Video configuration - NB. "CHANNELS" are synonymous with "SYMBOLS"
`define PIXELS_IN_PARALLEL             4
`define CHANNELS_PER_PIXEL             3
`define BITS_PER_CHANNEL               8
`define COLOR_PLANES_ARE_IN_PARALLEL   1
`define BITS_PER_SYMBOL               `BITS_PER_CHANNEL
`define PIXEL_DATA_WIDTH              `CHANNELS_PER_PIXEL*`BITS_PER_SYMBOL
`define SYMBOLS_PER_BEAT              `CHANNELS_PER_PIXEL*`PIXELS_IN_PARALLEL
`define TRANSPORT                      parallel

// BFM defines : 
`define MM_SINK_WR                     testbench.mm_slave_bfm_for_vfb_writes
`define MM_SINK_RD                     testbench.mm_slave_bfm_for_vfb_reads
`define MM_DRV_NAME                    mem
`define USE_LINES                      0
`define TDM_IS_BY_PIXEL                1

// Av-ST and Av-MM readiness :
`define AV_MM_READ_RESPONSE_DELAY      5
`define SOURCE_READINESS              50
`define SINK_READINESS                90

// The test configures the Mixer's background layer to 64x64 to reduce simulation time :
`define MIXER_BACKGROUND_WIDTH_SW     64
`define MIXER_BACKGROUND_HEIGHT_SW    64

// Make sure these match the Mixer's maximum frame configuration :
`define MAX_WIDTH                    560
`define MAX_HEIGHT                   380

// Avalon-ST Video components have a minimum frame size of 32x32 :
`define MIN_WIDTH                     32
`define MIN_HEIGHT                    32

// Test harness defines :
`define MAX_COMPLIANCE_TEST_PKTS      10
`define ENABLE_DUPLICATE_CONTROL_PKTS  1
`define MIXER_NUM_TPG_OUTPUT_FRAMES    2
`define DONT_COPY_TO_SCOREBOARD        0
`define COPY_TO_SCOREBOARD             1

// ticks (ps) with no output frame before aborting simulation (set to 125 * expected max field or frame period)
`define TIMEOUT_LENGTH      (64'd10000 /*10ns cycles*/ * `MAX_HEIGHT * `MAX_WIDTH * 100)

//`define ENABLE_SCOREBOARD_MSGS

`endif