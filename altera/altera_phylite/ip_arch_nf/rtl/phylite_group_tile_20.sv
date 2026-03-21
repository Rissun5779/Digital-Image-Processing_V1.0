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



// synthesis translate_off
`define _get_dll_ctlsel                                  ( "ctl_dynamic" )
`define _get_dll_ctl_static                              ( 10'd0 )
// synthesis translate_on
// synthesis read_comments_as_HDL on
// `define _get_dll_ctlsel          ( DIAG_SYNTH_FOR_SIM ? "ctl_dynamic" : DLL_MODE )
// `define _get_dll_ctl_static      ( DIAG_SYNTH_FOR_SIM ? 10'd0         : DLL_CODEWORD[9:0] )
// synthesis read_comments_as_HDL off   

/////////////////////////////////////////////////////////////////////////////
// Data/Strobe Group Tile of 20nm PHYLite component.
//
/////////////////////////////////////////////////////////////////////////////
module phylite_group_tile_20 #(
        parameter [6:0]   TILE_ID                       = 7'd0             ,
	parameter integer USE_DYNAMIC_RECONFIGURATION   = 0                ,
	parameter string  CORE_RATE                     = "RATE_IN_QUARTER",
	parameter integer PLL_VCO_TO_MEM_CLK_FREQ_RATIO = 1                ,
	parameter integer PLL_VCO_FREQ_MHZ_INT          = 1067             ,
	parameter string  PIN_TYPE                      = "BIDIR"          ,
	parameter integer PIN_WIDTH                     = 9                ,
	parameter string  DDR_SDR_MODE                  = "DDR"            ,
	parameter string  STROBE_CONFIG                 = "SINGLE_ENDED"   ,
	parameter string  DATA_CONFIG                   = "SGL_ENDED"   ,
	parameter [5:0]   READ_LATENCY                  = 6'd4             ,
	parameter integer USE_INTERNAL_CAPTURE_STROBE   = 0                ,
	parameter integer CAPTURE_PHASE_SHIFT           = 90               ,
	parameter integer WRITE_LATENCY                 = 0                ,
	parameter integer USE_OUTPUT_STROBE             = 1                ,
	parameter integer USE_SEPARATE_STROBES          = 0                ,
	parameter integer SWAP_CAPTURE_STROBE_POLARITY  = 0                ,
	parameter integer OUTPUT_STROBE_PHASE           = 90               ,
	parameter string  OCT_MODE                      = "STATIC_OFF"     ,
	parameter integer OCT_SIZE                      = 1		   ,
	parameter integer ENABLE_DFT                    = 0		   ,
	parameter DLL_MODE                              = ""		   ,
	parameter DLL_CODEWORD                          = 0		   ,
	parameter DIAG_SYNTH_FOR_SIM			= 0		   ,
	parameter SILICON_REV				= "20NM5"	   

	) (
	// Clocks and Reset
	input  [1:0] phy_clk            ,
	input  [7:0] phy_clk_phs        ,
	input        pll_locked         ,
	input        dll_ref_clk        ,
	input        reset_n            ,
	output       lanes_locked       ,
	output       pa_locked          ,
	output       pa_core_clk_out    ,
	input        pa_core_clk_in     ,
	input        phy_fb_clk_to_tile ,

	// Avalon Interface
	output [54:0] cal_avl_out         ,
	input  [31:0] cal_avl_readdata_in ,
	input  [54:0] cal_avl_in          ,
	output [31:0] cal_avl_readdata_out,

	// Core Interface
	input  [191:0] oe_from_core  ,
	input  [383:0] data_from_core,
	output [383:0] data_to_core  ,
	input    [3:0] rdata_en      ,
	output   [3:0] rdata_valid   ,

	// I/Os
	output [47:0] data_oe   ,
	output [47:0] data_out  ,
	input  [47:0] data_in   ,
	output [47:0] oct_enable,

	// Inter-Tile Daisy Chains
	input  broadcast_in_top ,
	output broadcast_out_top,
	input  broadcast_in_bot ,
	output broadcast_out_bot,

	input  [1:0] sync_top_in ,
	output [1:0] sync_top_out,
	input  [1:0] sync_bot_in ,
	output [1:0] sync_bot_out,

	// DFT Ports
	input        [20:0] dft_dprio_in ,
	output        [8:0] dft_dprio_out,
	input   [(4*3)-1:0] core_to_dft  ,
	output [(4*15)-1:0] dft_to_core
	);
	timeunit 1ns;
	timeprecision 1ns;

	//////////////////////////////////////////////////////////////////////////
	// Local Parameters
	//////////////////////////////////////////////////////////////////////////
	// Top Level Lane Params
	localparam MODE_DDR = (DDR_SDR_MODE == "DDR") ? "mode_ddr" : "mode_sdr";
	localparam IN_RATE  = (CORE_RATE == "RATE_IN_QUARTER") ? "in_rate_1_4" :
	                      (CORE_RATE == "RATE_IN_HALF")    ? "in_rate_1_2" :
	                                                         "in_rate_full";
	localparam OUT_RATE = (PLL_VCO_TO_MEM_CLK_FREQ_RATIO == 8) ? "out_rate_1_8" :
	                      (PLL_VCO_TO_MEM_CLK_FREQ_RATIO == 4) ? "out_rate_1_4" :
	                      (PLL_VCO_TO_MEM_CLK_FREQ_RATIO == 2) ? "out_rate_1_2" :
	                                                             "out_rate_full";
	localparam ENABLE_COMPLEMENTARY_STROBE = (STROBE_CONFIG == "COMPLEMENTARY") ? "true" : "false";
	localparam ENABLE_AVALON = (USE_DYNAMIC_RECONFIGURATION == 1) ? "true" : "false";
	localparam IN_RATE_MULT  = (CORE_RATE == "RATE_IN_QUARTER") ? 4:
	                           (CORE_RATE == "RATE_IN_HALF")    ? 2:
	                                                              1;
	localparam SWAP_DQS_A_B = (SWAP_CAPTURE_STROBE_POLARITY == 1) ? "true" : "false";
	localparam ENABLE_DQS_A_INTERPOLATOR_CAPTURE = (USE_INTERNAL_CAPTURE_STROBE == 1) ? "true" : "false";
	localparam ENABLE_DQS_B_INTERPOLATOR_CAPTURE = ((USE_INTERNAL_CAPTURE_STROBE == 1) && (ENABLE_COMPLEMENTARY_STROBE == "true")) ? "true" : "false";
	localparam LANE_OCT_MODE = (OCT_MODE == "DYNAMIC")   ? "dynamic" : "static_off" ;

	// Lane write delay params
	localparam [12:0] MIN_OFFSET = (OUT_RATE == "out_rate_full") ? ((IN_RATE == "in_rate_1_4")  ? 13'h0180   :
	                                                                (IN_RATE == "in_rate_1_2")  ? 13'h0280   :
	                                                                                              13'h0100 ) :
	                               (OUT_RATE == "out_rate_1_2")  ? ((IN_RATE == "in_rate_1_4")  ? 13'h0380   :
	                                                                (IN_RATE == "in_rate_1_2")  ? 13'h0100   :
	                                                                                              13'h0180 ) :
	                               (OUT_RATE == "out_rate_1_4")  ? ((IN_RATE == "in_rate_1_4")  ? 13'h0280   :
	                                                                (IN_RATE == "in_rate_1_2")  ? 13'h0100   :
	                                                                                              13'h0200 ) :
	                                                               ((IN_RATE == "in_rate_1_4")  ? 13'h0380   :
	                                                                (IN_RATE == "in_rate_1_2")  ? 13'h0000   :
	                                                                                              13'h0200 ) ;
	localparam [12:0] ONE_EXT_MEM_PHASE_CLOCK_CYCLE = (OUT_RATE == "out_rate_full") ? 13'h0080 :
	                                                  (OUT_RATE == "out_rate_1_2")  ? 13'h0100 :
	                                                  (OUT_RATE == "out_rate_1_4")  ? 13'h0200 :
	                                                                                  13'h0400 ;
	localparam [12:0] OUTPUT_LATENCY_OFFSET = WRITE_LATENCY * ONE_EXT_MEM_PHASE_CLOCK_CYCLE;
	localparam [12:0] DATA_PHASE_OFFSET     = MIN_OFFSET + OUTPUT_LATENCY_OFFSET;
	localparam bit [63:0] STROBE_PHASE_OFFSET_INT = DATA_PHASE_OFFSET + ((OUTPUT_STROBE_PHASE / 360.0) * ONE_EXT_MEM_PHASE_CLOCK_CYCLE);
	localparam [12:0] STROBE_PHASE_OFFSET   = STROBE_PHASE_OFFSET_INT[12:0];
	// Lane read/read valid delay params
	localparam [12:0] DQS_ENABLE_PHASE_SHIFT_A = MIN_OFFSET; // assuming addr/cmd group always uses minimum output latency
	localparam [12:0] DQS_ENABLE_PHASE_SHIFT_B = MIN_OFFSET + {1'b0, ONE_EXT_MEM_PHASE_CLOCK_CYCLE[12:1]}; // negative strobe enable requires 180 degree phase offset from positive strobe enable
	localparam ONE_CAPTURE_PHASE_SHIFT_CLOCK_CYCLE = (OUT_RATE == "out_rate_full") ?  256.0 :
	                                                 (OUT_RATE == "out_rate_1_2")  ?  512.0 :
	                                                 (OUT_RATE == "out_rate_1_4")  ? 1024.0 :
	                                                                                 2048.0 ;
	localparam DQS_DELAY_CALC = (CAPTURE_PHASE_SHIFT / 360.0) * ONE_CAPTURE_PHASE_SHIFT_CLOCK_CYCLE;
	localparam bit [63:0] DQS_DELAY_INT = (DQS_DELAY_CALC > 1023) ? 1023 : DQS_DELAY_CALC; // cap DQS_DELAY at 10-bit maximum value
	localparam [9:0] DQS_DELAY = DQS_DELAY_INT[9:0];
	// Set the read valid and FIFO read delays to a safe value aligned to the core clock
	localparam [6:0] READ_VALID_DELAY = READ_LATENCY + 4;
	localparam [6:0] READ_VALID_DELAY_ALIGNED = READ_VALID_DELAY + (((READ_VALID_DELAY % IN_RATE_MULT) != 0) ? (IN_RATE_MULT - (READ_VALID_DELAY % IN_RATE_MULT)) : 0);

	// Lane pin usage params
	localparam NUM_STROBES = (((PIN_TYPE == "OUTPUT") && (USE_OUTPUT_STROBE == 0))                                      ? 0 :
	                          ((PIN_TYPE == "INPUT") && (USE_INTERNAL_CAPTURE_STROBE == 1))                             ? 0 :
	                          ((PIN_TYPE == "BIDIR") && (USE_INTERNAL_CAPTURE_STROBE == 1) && (USE_OUTPUT_STROBE == 0)) ? 0 :
				   (STROBE_CONFIG == "SINGLE_ENDED")                                                        ? 1 : 
	                                                                                                                      2 )
	                         * ((USE_SEPARATE_STROBES == 1) ? 2 : 1);
	localparam integer TOTAL_PIN_WIDTH = (DATA_CONFIG == "SGL_ENDED") ? PIN_WIDTH + NUM_STROBES : (2 * PIN_WIDTH) + NUM_STROBES;
	localparam integer NUM_LANES_USED = (TOTAL_PIN_WIDTH / 12) + 1;
	localparam integer DIFF_OR_COMP_STROBES = (STROBE_CONFIG != "SINGLE_ENDED") ? 1 : 0;
	localparam integer DIFF_DATA 	= (DATA_CONFIG != "SGL_ENDED") ? 1 : 0;

	// Tile Ctrl Params
	localparam [2:0] PA_EXPONENT = ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 1  ) ? 3'b000 :
	                               ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 2  ) ? 3'b001 :
	                               ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 4  ) ? 3'b010 : 
	                               ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 8  ) ? 3'b011 : 
	                               ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 16 ) ? 3'b100 : 
	                               ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 32 ) ? 3'b101 : 
	                               ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 64 ) ? 3'b110 : 
	                               ((IN_RATE_MULT * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 128) ? 3'b111 : 
	                                                                                         3'b000 ;
	// DQS x4 Selection Params
	localparam PIN_0_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_1_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_2_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_3_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_4_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_5_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_6_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_7_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_8_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_9_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_10_DQS_X4_MODE = "dqs_x4_not_used";
	localparam PIN_11_DQS_X4_MODE = "dqs_x4_not_used";
	
	//////////////////////////////////////////////////////////////////////////
	// Wire Declarations
	//////////////////////////////////////////////////////////////////////////
	// PHY Clocks
	wire [1:0] phy_clk_lane[0:3];
	wire [7:0] phy_clk_phs_lane[0:3];
	wire       dll_clk_out[0:3];

	// Avalon Bus
	wire [54:0] cal_avl      [0:5];
	wire [31:0] cal_avl_rdata[0:5];

	// DQS input
	wire [1:0] dqs_in_x8_0     ;
	wire [1:0] dqs_in_x18_0    ;
	wire [1:0] dqs_in_x36      ;
	wire [1:0] dqs_out_x8 [0:3];
	wire [1:0] dqs_out_x18[0:3];
	wire [1:0] dqs_out_x36[0:3];
	wire       dqs             ;
	wire       dqs_n           ;

	// DQS Broadcast Daisy-Chain
	wire broadcast_dn[0:4];
	wire broadcast_up[0:4];

	// CPA
	wire [1:0] sync_dn[0:5];
	wire [1:0] sync_up[0:5];

	// Read Data Valid from Lanes
	wire [3:0] rdata_valid_lane [0:3];

	// Lock Signals from Lanes
	wire [3:0] ioereg_locked_lane;

	// CPA clock output
	wire [1:0] pa_locks;
	wire [1:0] pa_core_clks;

	//////////////////////////////////////////////////////////////////////////
	// Assignments and Tie-offs
	//////////////////////////////////////////////////////////////////////////
	// Avalon Bus
	assign cal_avl[0] = cal_avl_in;
	assign cal_avl_readdata_out = cal_avl_rdata[0];
	assign cal_avl_out = cal_avl[5];
	assign cal_avl_rdata[5] = cal_avl_readdata_in;

	// DQS input
	assign dqs   = (USE_INTERNAL_CAPTURE_STROBE == 1) ? 1'b0 : data_in[0];
	assign dqs_n = (USE_INTERNAL_CAPTURE_STROBE == 1) ? 1'b0 : ((ENABLE_COMPLEMENTARY_STROBE == "true") ? data_in[1] : 1'b0);
	assign dqs_in_x8_0  = (TOTAL_PIN_WIDTH <= 12)					? {dqs_n,dqs} : 2'b00;
	assign dqs_in_x18_0 = ((TOTAL_PIN_WIDTH > 12) && ((TOTAL_PIN_WIDTH <= 24))) 	? {dqs_n,dqs} : 2'b00;
	assign dqs_in_x36   = (TOTAL_PIN_WIDTH > 24)                                	? {dqs_n,dqs} : 2'b00;

	// DQS Broadcast Daisy-Chain
	assign broadcast_up[0]   = broadcast_in_bot;
	assign broadcast_out_top = broadcast_up[4];
	assign broadcast_dn[4]   = broadcast_in_top;
	assign broadcast_out_bot = broadcast_dn[0];

	// CPA Sync Daisy-Chain
	assign sync_up[0]   = sync_bot_in;
	assign sync_top_out = sync_up[5];
	assign sync_dn[5]   = sync_top_in;
	assign sync_bot_out = sync_dn[0];

	// All rdata valid outputs are aligned, so just use the first lane's
	assign rdata_valid = rdata_valid_lane[0];

	// And together locked signals from each lane if group has output or bidirectional data
	assign lanes_locked = ioereg_locked_lane[0]; // Safe to assume all lanes in a tile will lock together

	// CPA clock output
	assign pa_locked       = pa_locks[0];
	assign pa_core_clk_out = pa_core_clks[0];
	
	//////////////////////////////////////////////////////////////////////////
	// Tile Control Atom instantiation
	//////////////////////////////////////////////////////////////////////////
	twentynm_tile_ctrl #(
		.pa_filter_code         (PLL_VCO_FREQ_MHZ_INT),
		.pa_phase_offset_0      (12'b0               ),       // Output clock phase degree = phase_offset / 128 * 360
		.pa_phase_offset_1      (12'b0               ),       // Output clock phase degree = phase_offset / 128 * 360
		.pa_exponent_0          (PA_EXPONENT         ),       // CPA output 0 - matches phy_clk
		.pa_exponent_1          (3'b0                ),       // CPA output 1 - unused
		.pa_mantissa_0          (5'b0                ),       // Output clock freq = VCO Freq / ( 1.mantissa * 2^exponent)
		.pa_mantissa_1          (5'b0                ),       // Output clock freq = VCO Freq / ( 1.mantissa * 2^exponent)
		.pa_feedback_divider_c0 ("div_by_1_c0"       ),       // Core clock 0 divider (always 1)
		.pa_feedback_divider_c1 ("div_by_1_c1"       ),       // Core clock 1 divider (always 1)
		.pa_feedback_divider_p0 ("div_by_1_p0"       ),       // PHY clock 0 divider (always 1)
		.pa_feedback_divider_p1 ("div_by_1_p1"       ),       // PHY clock 1 divider (always 1)
		.pa_feedback_mux_sel_0  ("fb0_p_clk_0"       ),       // Use phy_clk[0] as feedback
		.pa_feedback_mux_sel_1  ("fb0_p_clk_1"       ),       // Use phy_clk[0] as feedback
		.pa_freq_track_speed    (4'hd                ),
		.pa_track_speed         (5'h0c               ),                                         
		.pa_sync_control        ("no_sync"           ),
		.pa_sync_latency        (4'b0000             ),
		.silicon_rev	   (SILICON_REV)
		) u_twentynm_tile_ctrl (
		// Reset
		.global_reset_n    (reset_n),
		
		// PLL Clocks
		.pll_locked_in     (pll_locked                            ),
		.pll_vco_in        (phy_clk_phs                           ),
		.phy_clk_in        (phy_clk                               ),
		.phy_clk_out0      ({phy_clk_lane[0], phy_clk_phs_lane[0]}),
		.phy_clk_out1      ({phy_clk_lane[1], phy_clk_phs_lane[1]}),
		.phy_clk_out2      ({phy_clk_lane[2], phy_clk_phs_lane[2]}),
		.phy_clk_out3      ({phy_clk_lane[3], phy_clk_phs_lane[3]}),

		// DLL Clocks
		.dll_clk_in        (dll_ref_clk   ),
		.dll_clk_out0      (dll_clk_out[0]),
		.dll_clk_out1      (dll_clk_out[1]),
		.dll_clk_out2      (dll_clk_out[2]),
		.dll_clk_out3      (dll_clk_out[3]),
		
		// Avalon Bus
		.cal_avl_in        (cal_avl      [2]),
		.cal_avl_rdata_out (cal_avl_rdata[2]),
		.cal_avl_out       (cal_avl      [3]),
		.cal_avl_rdata_in  (cal_avl_rdata[3]),
		
		// Clock Phase Alignment Output
		.pa_core_clk_in      ({1'b0,pa_core_clk_in}),  // Input to CPA through feedback path
		.pa_core_clk_out     (pa_core_clks         ),  // Output from CPA to core clock networks
		.pa_locked           (pa_locks             ),  // Lock signal from CPA to core
		.pa_reset_n          (),                       // Not used - CPA is reset by frzreg
		.pa_core_in          (12'b000000000000     ),  // Control code word
		.pa_fbclk_in         (phy_fb_clk_to_tile   ),  // PLL signal going into PHY feedback clock
		.pa_sync_data_bot_in (sync_up[2][0]),
		.pa_sync_data_top_in (sync_dn[3][0]),
		.pa_sync_clk_bot_in  (sync_up[2][1]),
		.pa_sync_clk_top_in  (sync_dn[3][1]),
		.pa_sync_data_bot_out(sync_dn[2][0]),
		.pa_sync_data_top_out(sync_up[3][0]),
		.pa_sync_clk_bot_out (sync_dn[2][1]),
		.pa_sync_clk_top_out (sync_up[3][1]),

		// DQS Clock Tree
		.dqs_in_x8_0       	(dqs_in_x8_0   	),
		.dqs_in_x8_1       	(2'b0          	),
		.dqs_in_x8_2       	(2'b0          	),
		.dqs_in_x8_3       	(2'b0          	),
		.dqs_in_x18_0      	(dqs_in_x18_0  	),
		.dqs_in_x18_1      	(2'b0          	),
		.dqs_in_x36        	(dqs_in_x36    	),
		.dqs_out_x8_lane0  	(dqs_out_x8 [0]	),
		.dqs_out_x18_lane0 	(dqs_out_x18[0]	),
		.dqs_out_x36_lane0 	(dqs_out_x36[0]	),
		.dqs_out_x8_lane1  	(dqs_out_x8 [1]	),
		.dqs_out_x18_lane1 	(dqs_out_x18[1]	),
		.dqs_out_x36_lane1 	(dqs_out_x36[1]	),
		.dqs_out_x8_lane2  	(dqs_out_x8 [2]	),
		.dqs_out_x18_lane2 	(dqs_out_x18[2]	),
		.dqs_out_x36_lane2 	(dqs_out_x36[2]	),
		.dqs_out_x8_lane3  	(dqs_out_x8 [3]	),
		.dqs_out_x18_lane3 	(dqs_out_x18[3]	),
		.dqs_out_x36_lane3 	(dqs_out_x36[3]	),

		// DFT Ports
		.pa_dprio_clk          (dft_dprio_in[0]    ),
		.pa_dprio_read         (dft_dprio_in[1]    ),
		.pa_dprio_reg_addr     (dft_dprio_in[10:2] ),
		.pa_dprio_rst_n        (dft_dprio_in[11]   ),
		.pa_dprio_write        (dft_dprio_in[12]   ),
		.pa_dprio_writedata    (dft_dprio_in[20:13]),
		.pa_dprio_block_select (dft_dprio_out[0]   ),
		.pa_dprio_readdata     (dft_dprio_out[8:1] )
	);

	//////////////////////////////////////////////////////////////////////////
	// Lane instantiation generate loop - create all lanes regardless of usage
	//////////////////////////////////////////////////////////////////////////
	generate 
		genvar lane_num;
		for(lane_num = 0; lane_num < 4; lane_num = lane_num + 1) begin : lane_gen

			// Lane specific local parameters
                        localparam [1:0] LANE_ID      = lane_num;
			localparam PIN_0_IS_STROBE    = ((lane_num == 0) && (NUM_STROBES > 0))  ;
			localparam PIN_1_IS_STROBE    = ((lane_num == 0) && ((NUM_STROBES >= 2) || (DATA_CONFIG == "DIFF" && NUM_STROBES == 1))) ;
			localparam PIN_2_IS_STROBE    = ((lane_num == 0) && (NUM_STROBES == 4)) ;
			localparam PIN_3_IS_STROBE    = ((lane_num == 0) && (NUM_STROBES == 4)) ;
			localparam PIN_0_PHASE_OFFSET = PIN_0_IS_STROBE ? STROBE_PHASE_OFFSET  : DATA_PHASE_OFFSET ;
			localparam PIN_1_PHASE_OFFSET = PIN_1_IS_STROBE ? STROBE_PHASE_OFFSET  : DATA_PHASE_OFFSET ;
			localparam PIN_2_PHASE_OFFSET = PIN_2_IS_STROBE ? STROBE_PHASE_OFFSET  : DATA_PHASE_OFFSET ;
			localparam PIN_3_PHASE_OFFSET = PIN_3_IS_STROBE ? STROBE_PHASE_OFFSET  : DATA_PHASE_OFFSET ;
			localparam PIN_0_DDR_MODE     = PIN_0_IS_STROBE ? "mode_ddr" : MODE_DDR ;
			localparam PIN_1_DDR_MODE     = PIN_1_IS_STROBE ? "mode_ddr" : MODE_DDR ;
			localparam PIN_2_DDR_MODE     = PIN_2_IS_STROBE ? "mode_ddr" : MODE_DDR ;
			localparam PIN_3_DDR_MODE     = PIN_3_IS_STROBE ? "mode_ddr" : MODE_DDR ;
			localparam PIN_0_DATA_IN_MODE = PIN_0_IS_STROBE 	? ( DIFF_OR_COMP_STROBES ? "differential_in_avl_out" : "disabled" ) : 
							DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_1_DATA_IN_MODE = PIN_1_IS_STROBE 	? ( DIFF_OR_COMP_STROBES ? "differential_in_avl_out" : "disabled" ) : 
							DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_2_DATA_IN_MODE = PIN_2_IS_STROBE 	? ( DIFF_OR_COMP_STROBES ? "differential_in_avl_out" : "disabled" ) : 
							DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_3_DATA_IN_MODE = PIN_3_IS_STROBE 	? ( DIFF_OR_COMP_STROBES ? "differential_in_avl_out" : "disabled" ) : 
							DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_4_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_5_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_6_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_7_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_8_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_9_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_10_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";
			localparam PIN_11_DATA_IN_MODE = DIFF_DATA 	?  "differential_in" : "sstl_in";

			localparam LANE_USED          = (lane_num < NUM_LANES_USED);

			localparam integer DAISY_CHAIN_OFFSET = lane_num / 2;
			localparam integer DAISY_CHAIN_IDX    = lane_num + DAISY_CHAIN_OFFSET;

			// Lane specific wires
			wire [1:0] dqs_in;
			wire [5:0] ioereg_locked;

			// Lane specific assignments
			assign dqs_in = (TOTAL_PIN_WIDTH <= 12) 				?	dqs_out_x8 [lane_num] :
				        ((TOTAL_PIN_WIDTH > 12) && ((TOTAL_PIN_WIDTH <= 24)))  	?	dqs_out_x18[lane_num] :
			                                                                        	dqs_out_x36[lane_num] ;
			assign ioereg_locked_lane[lane_num] = LANE_USED ? |ioereg_locked : 1'b1; // If lane is used, get locked signal from used data pin
			
			logic [2:0] core2dll;
			if (ENABLE_DFT) begin : core2dll_hps
				assign core2dll = core_to_dft[((lane_num+1)*3)-1:(lane_num*3)];
			end else begin : core2dll_non_hps
				assign core2dll = {reset_n, 1'b0, 1'b0};
			end


			twentynm_io_12_lane #(
				// Top level params
				.phy_clk_phs_freq (PLL_VCO_FREQ_MHZ_INT       ),
				.mode_rate_in     (IN_RATE                    ),
				.mode_rate_out    (OUT_RATE                   ),
				.pipe_latency     (8'd0                       ),
				.dqs_enable_delay (READ_LATENCY               ),
				.rd_valid_delay   (READ_VALID_DELAY_ALIGNED   ),
				.phy_clk_sel      (0                          ),
				
				// PHY params
				.pin_0_initial_out    ("initial_out_z"   ),
				.pin_0_mode_ddr       (PIN_0_DDR_MODE    ),
				.pin_0_output_phase   (PIN_0_PHASE_OFFSET),
				.pin_0_oct_mode       (LANE_OCT_MODE     ),
				.pin_0_data_in_mode   (PIN_0_DATA_IN_MODE),
				.pin_0_dqs_x4_mode    (PIN_0_DQS_X4_MODE ),
				.pin_1_initial_out    ("initial_out_z"   ),
				.pin_1_mode_ddr       (PIN_1_DDR_MODE    ),
				.pin_1_output_phase   (PIN_1_PHASE_OFFSET),
				.pin_1_oct_mode       (LANE_OCT_MODE     ),
				.pin_1_data_in_mode   (PIN_1_DATA_IN_MODE),
				.pin_1_dqs_x4_mode    (PIN_1_DQS_X4_MODE ),
				.pin_2_initial_out    ("initial_out_z"   ),
				.pin_2_mode_ddr       (PIN_2_DDR_MODE    ),
				.pin_2_output_phase   (PIN_2_PHASE_OFFSET),
				.pin_2_oct_mode       (LANE_OCT_MODE     ),
				.pin_2_data_in_mode   (PIN_2_DATA_IN_MODE),
				.pin_2_dqs_x4_mode    (PIN_2_DQS_X4_MODE ),
				.pin_3_initial_out    ("initial_out_z"   ),
				.pin_3_mode_ddr       (PIN_3_DDR_MODE    ),
				.pin_3_output_phase   (PIN_3_PHASE_OFFSET),
				.pin_3_oct_mode       (LANE_OCT_MODE     ),
				.pin_3_data_in_mode   (PIN_3_DATA_IN_MODE),
				.pin_3_dqs_x4_mode    (PIN_3_DQS_X4_MODE ),
				.pin_4_initial_out    ("initial_out_z"   ),
				.pin_4_mode_ddr       (MODE_DDR          ),
				.pin_4_output_phase   (DATA_PHASE_OFFSET ),
				.pin_4_oct_mode       (LANE_OCT_MODE     ),
				.pin_4_data_in_mode   (PIN_4_DATA_IN_MODE),
				.pin_4_dqs_x4_mode    (PIN_4_DQS_X4_MODE ),
				.pin_5_initial_out    ("initial_out_z"   ),
				.pin_5_mode_ddr       (MODE_DDR          ),
				.pin_5_output_phase   (DATA_PHASE_OFFSET ),
				.pin_5_oct_mode       (LANE_OCT_MODE     ),
				.pin_5_data_in_mode   (PIN_5_DATA_IN_MODE),
				.pin_5_dqs_x4_mode    (PIN_5_DQS_X4_MODE ),
				.pin_6_initial_out    ("initial_out_z"   ),
				.pin_6_mode_ddr       (MODE_DDR          ),
				.pin_6_output_phase   (DATA_PHASE_OFFSET ),
				.pin_6_oct_mode       (LANE_OCT_MODE     ),
				.pin_6_data_in_mode   (PIN_6_DATA_IN_MODE),
				.pin_6_dqs_x4_mode    (PIN_6_DQS_X4_MODE ),
				.pin_7_initial_out    ("initial_out_z"   ),
				.pin_7_mode_ddr       (MODE_DDR          ),
				.pin_7_output_phase   (DATA_PHASE_OFFSET ),
				.pin_7_oct_mode       (LANE_OCT_MODE     ),
				.pin_7_data_in_mode   (PIN_7_DATA_IN_MODE),
				.pin_7_dqs_x4_mode    (PIN_7_DQS_X4_MODE ),
				.pin_8_initial_out    ("initial_out_z"   ),
				.pin_8_mode_ddr       (MODE_DDR          ),
				.pin_8_output_phase   (DATA_PHASE_OFFSET ),
				.pin_8_oct_mode       (LANE_OCT_MODE     ),
				.pin_8_data_in_mode   (PIN_8_DATA_IN_MODE),
				.pin_8_dqs_x4_mode    (PIN_8_DQS_X4_MODE ),
				.pin_9_initial_out    ("initial_out_z"   ),
				.pin_9_mode_ddr       (MODE_DDR          ),
				.pin_9_output_phase   (DATA_PHASE_OFFSET ),
				.pin_9_oct_mode       (LANE_OCT_MODE     ),
				.pin_9_data_in_mode   (PIN_9_DATA_IN_MODE),
				.pin_9_dqs_x4_mode    (PIN_9_DQS_X4_MODE ),
				.pin_10_initial_out   ("initial_out_z"   ),
				.pin_10_mode_ddr      (MODE_DDR          ),
				.pin_10_output_phase  (DATA_PHASE_OFFSET ),
				.pin_10_oct_mode      (LANE_OCT_MODE     ),
				.pin_10_data_in_mode  (PIN_10_DATA_IN_MODE),
				.pin_10_dqs_x4_mode   (PIN_10_DQS_X4_MODE ),
				.pin_11_initial_out   ("initial_out_z"   ),
				.pin_11_mode_ddr      (MODE_DDR          ),
				.pin_11_output_phase  (DATA_PHASE_OFFSET ),
				.pin_11_oct_mode      (LANE_OCT_MODE     ),
				.pin_11_data_in_mode  (PIN_11_DATA_IN_MODE),
				.pin_11_dqs_x4_mode   (PIN_11_DQS_X4_MODE ),
				
				// Avalon params
				.avl_base_addr ({TILE_ID,LANE_ID}),
				.avl_ena       (ENABLE_AVALON),
				
				// Data Buffer params
				.db_hmc_or_core                ("core"              ),
				.db_dbi_sel                    (0                   ),
				.db_dbi_wr_en                  ("false"             ),
				.db_dbi_rd_en                  ("false"             ),
				.db_crc_dq0                    (0                   ),
				.db_crc_dq1                    (0                   ),
				.db_crc_dq2                    (0                   ),
				.db_crc_dq3                    (0                   ),
				.db_crc_dq4                    (0                   ),
				.db_crc_dq5                    (0                   ),
				.db_crc_dq6                    (0                   ),
				.db_crc_dq7                    (0                   ),
				.db_crc_dq8                    (0                   ),
				.db_crc_x4_or_x8_or_x9         ("x8_mode"           ),
				.db_crc_en                     ("crc_disable"       ),
				.db_rwlat_mode                 ("csr_vlu"           ),
				.db_afi_wlat_vlu               (6'd0                ),
				.db_afi_rlat_vlu               (6'd0                ),
				.db_ptr_pipeline_depth         (0                   ),
				.db_preamble_mode              ("preamble_one_cycle"),
				.db_reset_auto_release         ("auto_release"      ),
				.db_data_alignment_mode        ("align_disable"     ),
				.db_db2core_registered         ("false"             ),
				.db_core_or_hmc2db_registered  ("false"             ),
				.dbc_core_clk_sel              (0                   ),
				
				.db_pin_0_ac_hmc_data_override_ena ("false"  ),
				.db_pin_0_in_bypass                ("true"   ),
				.db_pin_0_mode                     ("dq_mode"),
				.db_pin_0_oe_bypass                ("true"   ),
				.db_pin_0_oe_invert                ("false"  ),
				.db_pin_0_out_bypass               ("true"   ),
				.db_pin_0_wr_invert                ("false"  ),
				.db_pin_1_ac_hmc_data_override_ena ("false"  ),
				.db_pin_1_in_bypass                ("true"   ),
				.db_pin_1_mode                     ("dq_mode"),
				.db_pin_1_oe_bypass                ("true"   ),
				.db_pin_1_oe_invert                ("false"  ),
				.db_pin_1_out_bypass               ("true"   ),
				.db_pin_1_wr_invert                ("false"  ),
				.db_pin_2_ac_hmc_data_override_ena ("false"  ),
				.db_pin_2_in_bypass                ("true"   ),
				.db_pin_2_mode                     ("dq_mode"),
				.db_pin_2_oe_bypass                ("true"   ),
				.db_pin_2_oe_invert                ("false"  ),
				.db_pin_2_out_bypass               ("true"   ),
				.db_pin_2_wr_invert                ("false"  ),
				.db_pin_3_ac_hmc_data_override_ena ("false"  ),
				.db_pin_3_in_bypass                ("true"   ),
				.db_pin_3_mode                     ("dq_mode"),
				.db_pin_3_oe_bypass                ("true"   ),
				.db_pin_3_oe_invert                ("false"  ),
				.db_pin_3_out_bypass               ("true"   ),
				.db_pin_3_wr_invert                ("false"  ),
				.db_pin_4_ac_hmc_data_override_ena ("false"  ),
				.db_pin_4_in_bypass                ("true"   ),
				.db_pin_4_mode                     ("dq_mode"),
				.db_pin_4_oe_bypass                ("true"   ),
				.db_pin_4_oe_invert                ("false"  ),
				.db_pin_4_out_bypass               ("true"   ),
				.db_pin_4_wr_invert                ("false"  ),
				.db_pin_5_ac_hmc_data_override_ena ("false"  ),
				.db_pin_5_in_bypass                ("true"   ),
				.db_pin_5_mode                     ("dq_mode"),
				.db_pin_5_oe_bypass                ("true"   ),
				.db_pin_5_oe_invert                ("false"  ),
				.db_pin_5_out_bypass               ("true"   ),
				.db_pin_5_wr_invert                ("false"  ),
				.db_pin_6_ac_hmc_data_override_ena ("false"  ),
				.db_pin_6_in_bypass                ("true"   ),
				.db_pin_6_mode                     ("dq_mode"),
				.db_pin_6_oe_bypass                ("true"   ),
				.db_pin_6_oe_invert                ("false"  ),
				.db_pin_6_out_bypass               ("true"   ),
				.db_pin_6_wr_invert                ("false"  ),
				.db_pin_7_ac_hmc_data_override_ena ("false"  ),
				.db_pin_7_in_bypass                ("true"   ),
				.db_pin_7_mode                     ("dq_mode"),
				.db_pin_7_oe_bypass                ("true"   ),
				.db_pin_7_oe_invert                ("false"  ),
				.db_pin_7_out_bypass               ("true"   ),
				.db_pin_7_wr_invert                ("false"  ),
				.db_pin_8_ac_hmc_data_override_ena ("false"  ),
				.db_pin_8_in_bypass                ("true"   ),
				.db_pin_8_mode                     ("dq_mode"),
				.db_pin_8_oe_bypass                ("true"   ),
				.db_pin_8_oe_invert                ("false"  ),
				.db_pin_8_out_bypass               ("true"   ),
				.db_pin_8_wr_invert                ("false"  ),
				.db_pin_9_ac_hmc_data_override_ena ("false"  ),
				.db_pin_9_in_bypass                ("true"   ),
				.db_pin_9_mode                     ("dq_mode"),
				.db_pin_9_oe_bypass                ("true"   ),
				.db_pin_9_oe_invert                ("false"  ),
				.db_pin_9_out_bypass               ("true"   ),
				.db_pin_9_wr_invert                ("false"  ),
				.db_pin_10_ac_hmc_data_override_ena("false"  ),
				.db_pin_10_in_bypass               ("true"   ),
				.db_pin_10_mode                    ("dq_mode"),
				.db_pin_10_oe_bypass               ("true"   ),
				.db_pin_10_oe_invert               ("false"  ),
				.db_pin_10_out_bypass              ("true"   ),
				.db_pin_10_wr_invert               ("false"  ),
				.db_pin_11_ac_hmc_data_override_ena("false"  ),
				.db_pin_11_in_bypass               ("true"   ),
				.db_pin_11_mode                    ("dq_mode"),
				.db_pin_11_oe_bypass               ("true"   ),
				.db_pin_11_oe_invert               ("false"  ),
				.db_pin_11_out_bypass              ("true"   ),
				.db_pin_11_wr_invert               ("false"  ),
				
				// DLL params
				.dll_rst_en      ("dll_rst_en"  ),
				.dll_en          ("dll_en"       ),
				.dll_core_updnen ("core_updn_dis"),
				.dll_ctlsel      (`_get_dll_ctlsel),
				.dll_ctl_static  (`_get_dll_ctl_static),
				
				// DQS params
				.dqs_lgc_dqs_b_en          (ENABLE_COMPLEMENTARY_STROBE      ),
				.dqs_lgc_swap_dqs_a_b      (SWAP_DQS_A_B                     ),
				.dqs_lgc_dqs_a_interp_en   (ENABLE_DQS_A_INTERPOLATOR_CAPTURE),
				.dqs_lgc_dqs_b_interp_en   (ENABLE_DQS_B_INTERPOLATOR_CAPTURE),
				.dqs_lgc_pvt_input_delay_a (DQS_DELAY                        ),
				.dqs_lgc_pvt_input_delay_b (DQS_DELAY                        ),
				.dqs_lgc_enable_toggler    ("preamble_track_dqs_enable"      ),
				.dqs_lgc_phase_shift_a     (DQS_ENABLE_PHASE_SHIFT_A         ),
				.dqs_lgc_phase_shift_b     (DQS_ENABLE_PHASE_SHIFT_B         ),
				.dqs_lgc_pack_mode         ("packed"                         ),
				.dqs_lgc_pst_preamble_mode ("ddr3_preamble"                  ),
				.dqs_lgc_pst_en_shrink     ("shrink_0_1"                     ),
				.dqs_lgc_broadcast_enable  ("disable_broadcast"              ),
				.dqs_lgc_burst_length      ("burst_length_2"                 ),
				.dqs_lgc_ddr4_search       ("ddr3_search"                    ),
				.dqs_lgc_count_threshold   (7'h73                            ),
				.oct_size		   (OCT_SIZE			     ),
				.silicon_rev	   	   (SILICON_REV   	             )

			) u_lane(
				// Clocks and Resets
				.reset_n      (reset_n                   ),
				.pll_locked   (pll_locked                ),
				.phy_clk      (phy_clk_lane    [lane_num]),
				.phy_clk_phs  (phy_clk_phs_lane[lane_num]),
				.dll_ref_clk  (dll_clk_out     [lane_num]),
				.ioereg_locked(ioereg_locked             ),
				    
				// Core interface
				.oe_from_core      (oe_from_core  [((lane_num + 1) * 48) - 1 : lane_num * 48]),
				.data_from_core    (data_from_core[((lane_num + 1) * 96) - 1 : lane_num * 96]),
				.data_to_core      (data_to_core  [((lane_num + 1) * 96) - 1 : lane_num * 96]),
				.rdata_en_full_core(rdata_en                                                 ),
				.mrnk_read_core    (16'd0                                                    ),
				.mrnk_write_core   (16'd0                                                    ),
				.rdata_valid_core  (rdata_valid_lane[lane_num]                               ),
				
				// DBC interface
				.core2dbc_rd_data_rdy  (1'b0 ),
				.core2dbc_wr_data_vld0 (1'b0 ),
				.core2dbc_wr_data_vld1 (1'b0 ),
				.core2dbc_wr_ecc_info  (13'b0),
				.dbc2core_rd_data_vld0 (),
				.dbc2core_rd_data_vld1 (),
				.dbc2core_rd_type      (),
				.dbc2core_wb_pointer   (),
				.dbc2core_wr_data_rdy  (),
				
				// HMC interface
				.ac_hmc       (96'b0),
				.afi_rlat_core(),
				.afi_wlat_core(),
				.cfg_dbc      (17'b0),
				.ctl2dbc0     (51'b0),
				.ctl2dbc1     (51'b0),
				.dbc2ctl      (),
				
				//Avalon interface
				.cal_avl_in          (cal_avl      [DAISY_CHAIN_IDX]    ),
				.cal_avl_readdata_out(cal_avl_rdata[DAISY_CHAIN_IDX]    ),
				.cal_avl_out         (cal_avl      [DAISY_CHAIN_IDX + 1]),
				.cal_avl_readdata_in (cal_avl_rdata[DAISY_CHAIN_IDX + 1]),
				
				// DQS interface
				.dqs_in           (dqs_in),
				.broadcast_in_bot (broadcast_up[lane_num    ]),
				.broadcast_out_bot(broadcast_dn[lane_num    ]),
				.broadcast_in_top (broadcast_dn[lane_num + 1]),
				.broadcast_out_top(broadcast_up[lane_num + 1]),
				
				// IO interface
				.data_oe   (data_oe   [((lane_num + 1) * 12) - 1 : lane_num * 12]),
				.data_out  (data_out  [((lane_num + 1) * 12) - 1 : lane_num * 12]),
				.data_in   (data_in   [((lane_num + 1) * 12) - 1 : lane_num * 12]),
				.oct_enable(oct_enable[((lane_num + 1) * 12) - 1 : lane_num * 12]),
				
				// DLL/PVT interface
				.core_dll(core2dll),
				.dll_core(dft_to_core[(lane_num*15)+14:(lane_num*15)+2]),
				
				// Clock Phase Alignment daisy chain
				.sync_clk_bot_in  (sync_up[DAISY_CHAIN_IDX][1]    ),
				.sync_clk_bot_out (sync_dn[DAISY_CHAIN_IDX][1]    ),
				.sync_data_bot_in (sync_up[DAISY_CHAIN_IDX][0]    ),
				.sync_data_bot_out(sync_dn[DAISY_CHAIN_IDX][0]    ),
				.sync_clk_top_in  (sync_dn[DAISY_CHAIN_IDX + 1][1]),
				.sync_clk_top_out (sync_up[DAISY_CHAIN_IDX + 1][1]),
				.sync_data_top_in (sync_dn[DAISY_CHAIN_IDX + 1][0]),
				.sync_data_top_out(sync_up[DAISY_CHAIN_IDX + 1][0]),

				// DFT Ports
				.dft_phy_clk (dft_to_core[(lane_num*15)+1:(lane_num*15)])
			);

		end 
	endgenerate

endmodule
