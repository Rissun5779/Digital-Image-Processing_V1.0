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



module altera_phylite_cfg_ctrl # (
	parameter STROBE_CONFIG        = "SINGLE_ENDED",
	parameter USE_SEPARATE_STROBES = 0
	) (

	// Clocks and Reset
	core_clk,
	reset_n,

	// Sim Controller Commands
	cfg_ctrl_rdy,
	cfg_start_write,
	cfg_start_read,
	cfg_start_read_en,
	cfg_done,
	cfg_grp,
	cfg_interface,
	cfg_strbs,

	// Sim Controller Read/Write
	sim_ctrl_write_and_readback,
	sim_ctrl_write_and_readback_done,
	sim_ctrl_write_and_readback_success,
	
	sim_ctrl_read,
	sim_ctrl_read_done,
	sim_ctrl_read_success,
	sim_ctrl_read_bit0_success,

	// Avalon MM AVL Controller Interface
	avl_clk,           
	avl_reset_n,       
	avl_read,          
	avl_write,         
	avl_byteenable,    
	avl_writedata,     
	avl_address,       
	avl_readdata,      
	avl_readdata_valid,
	avl_waitrequest
	);

	////////////////////////////////////////////////////////////////////////////
	// Local Params
	////////////////////////////////////////////////////////////////////////////
	// Update wait times
	localparam WRITE_UPDATE_CNT_WIDTH   = 5;
	localparam READ_UPDATE_CNT_WIDTH    = 5;
	localparam READ_EN_UPDATE_CNT_WIDTH = 5;

	// Update increment values
	localparam STROBE_OUTPUT_DELAY_INCR = 13'd10;
	localparam STROBE_INPUT_DELAY_INCR  = 10'd10;
	localparam DATA_INPUT_DELAY_INCR    = 9'd5;

	////////////////////////////////////////////////////////////////////////////
	// Enums
	////////////////////////////////////////////////////////////////////////////
	// Include Avalon Controller OP Codes
	typedef enum bit [7:0] {                          // AVL Access | CSR Access | R/W Data
		AVL_CTRL_REG_NUM_GROUPS          = 8'h00, //     R      |    N/A     | {24'h000000,num_grps[7:0]}
		AVL_CTRL_REG_GROUP_INFO                 , //     R      |    N/A     | {16'h0000,num_lanes[7:0],num_pins[7:0]}
		AVL_CTRL_REG_IDELAY                     , //    R/W     |    N/A     | {23'h000000,dq_delay[8:0]}
		AVL_CTRL_REG_ODELAY                     , //    R/W     |     R      | {19'h00000,output_phase[12:0]}
		AVL_CTRL_REG_DQS_DELAY                  , //    R/W     |    N/A     | {22'h000000,dqs_delay[9:0]}
		AVL_CTRL_REG_DQS_EN_DELAY               , //    R/W     |     R      | {26'h0000000,dqs_en_delay[5:0]}
		AVL_CTRL_REG_DQS_EN_PHASE_SHIFT         , //    R/W     |     R      | {19'h00000,phase[12:0]}
		AVL_CTRL_REG_RD_VALID_DELAY               //    R/W     |     R      | {25'h0000000,rd_vld_delay[6:0]}
		} avl_ctrl_reg_t;
	

	// Main FSM States
	typedef enum reg [0:0] {
		CFG_CTRL_IDLE             = 1'b0,
		CFG_CTRL_BUSY                   
		} cfg_ctrl_main_state_t;

	// Write Path Reconfig FSM States
	typedef enum reg [2:0] {
		CFG_CTRL_WRITE_IDLE                = 3'b000,
		CFG_CTRL_WRITE_READ_ODELAY_CSR_VAL         ,
		CFG_CTRL_WRITE_WRITE_DATA                  ,
		CFG_CTRL_WRITE_INCR_STROBE_DELAY           ,
		CFG_CTRL_WRITE_WAIT_FOR_UPDATE
		} cfg_ctrl_write_state_t;

	// Read Path Strobe Delay Reconfig FSM States
	typedef enum reg [2:0] {
		CFG_CTRL_READ_IDLE                       = 3'b000,
		CFG_CTRL_READ_READ_STROBE_IDELAY_CSR_VAL         ,
		CFG_CTRL_READ_READ_DATA                          ,
		CFG_CTRL_READ_INCR_STROBE_DELAY                  ,
		CFG_CTRL_READ_WAIT_FOR_UPDATE
		} cfg_ctrl_read_delay_state_t;

	// Read Path Strobe Enable Delay Reconfig FSM States
	typedef enum reg [3:0] {
		CFG_CTRL_READ_EN_IDLE                   = 4'h0,
		CFG_CTRL_READ_EN_STROBE_SHIFT_CSR             ,
		CFG_CTRL_READ_EN_READ_DATA0                   ,
		CFG_CTRL_READ_EN_INCR_STROBE_EN_DELAY         ,
		CFG_CTRL_READ_EN_WAIT_FOR_STROBE_UPDATE       ,
		CFG_CTRL_READ_EN_GET_NUM_PINS                 ,
		CFG_CTRL_READ_EN_READ_DATA                    ,
		CFG_CTRL_READ_EN_INCR_DATA_DELAY              ,
		CFG_CTRL_READ_EN_WAIT_FOR_DATA_UPDATE
		} cfg_ctrl_read_enable_delay_state_t;

	////////////////////////////////////////////////////////////////////////////
	// Port Declarations
	////////////////////////////////////////////////////////////////////////////
	// Clocks and Reset
	input core_clk;
	input reset_n;

	// Sim Controller Commands
	output cfg_ctrl_rdy;
	input  cfg_start_write;
	input  cfg_start_read;
	input  cfg_start_read_en;
	output cfg_done;
	input  [4:0] cfg_grp;
	input  [3:0] cfg_interface;
	input  [2:0] cfg_strbs; 

	// Sim Controller Read/Write
	output sim_ctrl_write_and_readback;
	input  sim_ctrl_write_and_readback_done;
	input  sim_ctrl_write_and_readback_success;
	
	output sim_ctrl_read;
	input sim_ctrl_read_done;
	input sim_ctrl_read_success;
	input sim_ctrl_read_bit0_success;

	// Avalon MM AVL Controller Interface
	output        avl_clk;           
	output        avl_reset_n;       
	output        avl_read;          
	output        avl_write;         
	output  [3:0] avl_byteenable;    
	output [31:0] avl_writedata;     
	output [31:0] avl_address; // {interface_id[3:0],grp[4:0],pin[5:0],csr[0],register[7:0]}
	input  [31:0] avl_readdata;      
	input         avl_readdata_valid;
	input         avl_waitrequest;

	////////////////////////////////////////////////////////////////////////////
	// Wire Declarations
	////////////////////////////////////////////////////////////////////////////
	// States
	cfg_ctrl_main_state_t              main_state;
	cfg_ctrl_write_state_t             write_state;
	cfg_ctrl_read_delay_state_t        read_state;
	cfg_ctrl_read_enable_delay_state_t read_en_state;

	// Start/stop signals
	wire cfg_start;
	wire write_cfg_done;
	wire read_cfg_done;
	wire read_en_cfg_done;

	// Cache interface, group to configure, and strobe configuration
	reg [4:0] cfg_grp_r;
	reg [3:0] cfg_interface_r;
	reg [2:0] cfg_strbs_r;

	// Write Path Reconfig FSM
	wire odelay_updated;
	reg [WRITE_UPDATE_CNT_WIDTH - 1 : 0] write_update_cnt;
	reg [12:0] next_strobe_output_phase;
	wire write_cfg_avl_read;
	wire write_cfg_avl_write;
	wire [1:0] out_strb_pin_idx;

	// Read Path Strobe Delay Reconfig FSM
	wire strobe_idelay_updated;
	reg [READ_UPDATE_CNT_WIDTH - 1 : 0] read_update_cnt;
	reg [9:0] next_strobe_input_delay;
	wire read_cfg_avl_read;
	wire read_cfg_avl_write;
	reg dqs_b_r;

	// Read Path Strobe Enable Delay Reconfig FSM
	wire strobe_en_delay_updated;
	reg [READ_EN_UPDATE_CNT_WIDTH - 1 : 0] read_en_update_cnt;
	reg [12:0] next_strobe_en_delay;
	reg  [8:0] next_data_input_delay;
	wire read_en_cfg_avl_read;
	wire read_en_cfg_avl_read_num_pins;
	wire read_en_cfg_avl_write_strobe;
	wire read_en_cfg_avl_write_data;
	reg [5:0] cfg_pin_r;
	reg [5:0] num_pins_in_grp_r;

	////////////////////////////////////////////////////////////////////////////
	// Assignments
	////////////////////////////////////////////////////////////////////////////
	// Start/stop signals
	assign cfg_start        = cfg_start_write | cfg_start_read | cfg_start_read_en;
	assign cfg_done         = write_cfg_done  & read_cfg_done  & read_en_cfg_done ;
	assign write_cfg_done   = (write_state == CFG_CTRL_WRITE_IDLE);
	assign read_cfg_done    = (read_state == CFG_CTRL_READ_IDLE);
	assign read_en_cfg_done = (read_en_state == CFG_CTRL_READ_EN_IDLE);
	assign cfg_ctrl_rdy     = (main_state == CFG_CTRL_IDLE);

	// Write Path Reconfig FSM
	assign odelay_updated      = (write_update_cnt == {WRITE_UPDATE_CNT_WIDTH{1'b0}});
	assign sim_ctrl_write_and_readback  = ((write_state == CFG_CTRL_WRITE_READ_ODELAY_CSR_VAL) & (avl_readdata_valid)) | ((write_state == CFG_CTRL_WRITE_WAIT_FOR_UPDATE) & (odelay_updated));
	assign write_cfg_avl_read  = (((write_state == CFG_CTRL_WRITE_IDLE) & (cfg_start_write)) | (write_state == CFG_CTRL_WRITE_READ_ODELAY_CSR_VAL) & (~avl_readdata_valid));
	assign write_cfg_avl_write = (((write_state == CFG_CTRL_WRITE_WRITE_DATA) & (sim_ctrl_write_and_readback_done & ~sim_ctrl_write_and_readback_success)) | ((write_state == CFG_CTRL_WRITE_INCR_STROBE_DELAY) & (avl_waitrequest)));
	assign out_strb_pin_idx = (!cfg_strbs_r[0]) ? 2'b00 : ((cfg_strbs_r[2:1] == 2'b00) ? 2'b01 : 2'b10);

	// Read Path Strobe Delay Reconfig FSM
	assign strobe_idelay_updated = (read_update_cnt == {READ_UPDATE_CNT_WIDTH{1'b0}});
	assign read_cfg_avl_read     = (((read_state == CFG_CTRL_READ_IDLE) & (cfg_start_read)) | ((read_state == CFG_CTRL_READ_READ_STROBE_IDELAY_CSR_VAL) & (~avl_readdata_valid)));
	assign read_cfg_avl_write    = (((read_state == CFG_CTRL_READ_READ_DATA) & (sim_ctrl_read_done & ~sim_ctrl_read_success))  | ((read_state == CFG_CTRL_READ_WAIT_FOR_UPDATE) & (~dqs_b_r & cfg_strbs_r[2])) | ((read_state == CFG_CTRL_READ_INCR_STROBE_DELAY) & (avl_waitrequest)));
	assign addr_dqs_b            = dqs_b_r | ((read_state == CFG_CTRL_READ_WAIT_FOR_UPDATE) & (~dqs_b_r & cfg_strbs_r[2]));

	// Read Path Strobe Enable Delay Reconfig FSM
	assign strobe_en_delay_updated       = (read_en_update_cnt == {READ_EN_UPDATE_CNT_WIDTH{1'b0}});
	assign read_en_cfg_avl_read          = (((read_en_state == CFG_CTRL_READ_EN_IDLE) & (cfg_start_read_en)) | ((read_en_state == CFG_CTRL_READ_EN_STROBE_SHIFT_CSR) & (~avl_readdata_valid)));
	assign read_en_cfg_avl_read_num_pins = (((read_en_state == CFG_CTRL_READ_EN_READ_DATA0) & (sim_ctrl_read_done &  sim_ctrl_read_bit0_success)) | ((read_en_state == CFG_CTRL_READ_EN_GET_NUM_PINS) & (~avl_readdata_valid)));
	assign read_en_cfg_avl_write_strobe  = (((read_en_state == CFG_CTRL_READ_EN_READ_DATA0) & (sim_ctrl_read_done & ~sim_ctrl_read_bit0_success)) | ((read_en_state == CFG_CTRL_READ_EN_INCR_STROBE_EN_DELAY) & (avl_waitrequest)));
	assign read_en_cfg_avl_write_data    = (((read_en_state == CFG_CTRL_READ_EN_READ_DATA ) & (sim_ctrl_read_done & ~sim_ctrl_read_success)) | ((read_en_state == CFG_CTRL_READ_EN_INCR_DATA_DELAY) & (avl_waitrequest)));

	assign sim_ctrl_read = (((read_state == CFG_CTRL_READ_READ_STROBE_IDELAY_CSR_VAL) | (read_en_state == CFG_CTRL_READ_EN_STROBE_SHIFT_CSR) | (read_en_state == CFG_CTRL_READ_EN_GET_NUM_PINS)) & avl_readdata_valid) |
	                       ((read_state == CFG_CTRL_READ_WAIT_FOR_UPDATE) & strobe_idelay_updated)                      |
	                       ((read_en_state == CFG_CTRL_READ_EN_WAIT_FOR_STROBE_UPDATE) & strobe_en_delay_updated) |
	                       ((read_en_state == CFG_CTRL_READ_EN_WAIT_FOR_DATA_UPDATE  ) & strobe_en_delay_updated) ;

	// Avalon MM AVL Controller Interface
	assign avl_clk        = core_clk;
	assign avl_reset_n    = reset_n;
	assign avl_byteenable = 4'hF;
	assign avl_read       = write_cfg_avl_read | read_cfg_avl_read | read_en_cfg_avl_read | read_en_cfg_avl_read_num_pins;
	assign avl_write      = write_cfg_avl_write | read_cfg_avl_write | read_en_cfg_avl_write_strobe | read_en_cfg_avl_write_data;
	assign avl_writedata  = write_cfg_avl_write          ? {19'h00000 ,next_strobe_output_phase} :
	                        read_cfg_avl_write           ? {22'h000000,next_strobe_input_delay } :
	                        read_en_cfg_avl_write_strobe ? {19'h00000 ,next_strobe_en_delay    } :
	                        read_en_cfg_avl_write_data   ? {23'h000000,next_data_input_delay   } :
	                                                                                32'h00000000 ;
	assign avl_address    = write_cfg_avl_read            ? {8'h00,   cfg_interface,   cfg_grp,      4'h0, out_strb_pin_idx, 1'b1, AVL_CTRL_REG_ODELAY}             :
	                        write_cfg_avl_write           ? {8'h00, cfg_interface_r, cfg_grp_r,      4'h0, out_strb_pin_idx, 1'b0, AVL_CTRL_REG_ODELAY}             :
	                        read_cfg_avl_read             ? {8'h00,   cfg_interface,   cfg_grp,     5'h00,       addr_dqs_b, 1'b1, AVL_CTRL_REG_DQS_DELAY}          :
	                        read_cfg_avl_write            ? {8'h00, cfg_interface_r, cfg_grp_r,     5'h00,       addr_dqs_b, 1'b0, AVL_CTRL_REG_DQS_DELAY}          :
	                        read_en_cfg_avl_read          ? {8'h00,   cfg_interface,   cfg_grp,     6'h00,                   1'b1, AVL_CTRL_REG_DQS_EN_PHASE_SHIFT} :
	                        read_en_cfg_avl_read_num_pins ? {8'h00,   cfg_interface,   cfg_grp,     6'h00,                   1'b0, AVL_CTRL_REG_GROUP_INFO}         :
	                        read_en_cfg_avl_write_strobe  ? {8'h00, cfg_interface_r, cfg_grp_r,     6'h00,                   1'b0, AVL_CTRL_REG_DQS_EN_PHASE_SHIFT} :
	                        read_en_cfg_avl_write_data    ? {8'h00,   cfg_interface,   cfg_grp, cfg_pin_r,                   1'b0, AVL_CTRL_REG_IDELAY}             :
                                                                                                                                                           32'h00000000 ;

	////////////////////////////////////////////////////////////////////////////
	// Main FSM
	////////////////////////////////////////////////////////////////////////////
	always @(posedge core_clk or negedge reset_n) begin
		if (!reset_n) begin
			main_state      <= CFG_CTRL_IDLE;
			cfg_grp_r       <= 5'h00;
			cfg_interface_r <= 4'h0;
			cfg_strbs_r     <= 3'b000;
		end else begin
			case (main_state)
				// wait for command from sim_ctrl
				CFG_CTRL_IDLE: begin
					if (cfg_start) begin
						main_state      <= CFG_CTRL_BUSY;
						cfg_grp_r       <= cfg_grp;
						cfg_interface_r <= cfg_interface;
						cfg_strbs_r     <= cfg_strbs;
					end
				end

				// wait for relevant reconfiguration FSM to finish
				CFG_CTRL_BUSY: begin
					if (cfg_done) begin
						main_state <= CFG_CTRL_IDLE;
					end
				end

				default: main_state <= CFG_CTRL_IDLE;
			endcase
		end
	end

	////////////////////////////////////////////////////////////////////////////
	// Write Path Reconfig FSM
	////////////////////////////////////////////////////////////////////////////
	always @(posedge core_clk or negedge reset_n) begin
		if (!reset_n) begin
			write_state              <= CFG_CTRL_WRITE_IDLE;
			write_update_cnt   <= {WRITE_UPDATE_CNT_WIDTH{1'b1}};
			next_strobe_output_phase <= 13'd0;
		end else begin
			case (write_state)

				// wait for start command and send write/readback command
				CFG_CTRL_WRITE_IDLE: begin
					if (cfg_start_write) begin
						write_state <= CFG_CTRL_WRITE_READ_ODELAY_CSR_VAL;
					end
				end

				// wait for CSR read data on avalon bus
				CFG_CTRL_WRITE_READ_ODELAY_CSR_VAL: begin
					if (avl_readdata_valid) begin
						next_strobe_output_phase <= avl_readdata[12:0] + STROBE_OUTPUT_DELAY_INCR;
						write_state <= CFG_CTRL_WRITE_WRITE_DATA;
					end
				end

				// wait for write/readback results
				CFG_CTRL_WRITE_WRITE_DATA: begin
					if (sim_ctrl_write_and_readback_done) begin
						if (sim_ctrl_write_and_readback_success) begin
							write_state <= CFG_CTRL_WRITE_IDLE; // If write successful we are done
						end else begin
							write_state <= CFG_CTRL_WRITE_INCR_STROBE_DELAY; // Else keep searching for correct delay
						end
					end
				end

				// wait for write to be accepted
				CFG_CTRL_WRITE_INCR_STROBE_DELAY: begin
					if (!avl_waitrequest) begin
						write_state <= CFG_CTRL_WRITE_WAIT_FOR_UPDATE;
					end
					write_update_cnt <= {WRITE_UPDATE_CNT_WIDTH{1'b1}};
				end

				// increment strobe output delay and wait for changes to take effect
				CFG_CTRL_WRITE_WAIT_FOR_UPDATE: begin
					write_update_cnt <= write_update_cnt - {{(WRITE_UPDATE_CNT_WIDTH-1){1'b0}},1'b1};
					if (odelay_updated) begin
						next_strobe_output_phase <= next_strobe_output_phase + STROBE_OUTPUT_DELAY_INCR;
						write_state <= CFG_CTRL_WRITE_WRITE_DATA;
					end
				end

				default: write_state <= CFG_CTRL_WRITE_IDLE;
			endcase
		end
	end

	////////////////////////////////////////////////////////////////////////////
	// Read Path Strobe Delay Reconfig FSM
	////////////////////////////////////////////////////////////////////////////
	always @(posedge core_clk or negedge reset_n) begin
		if (!reset_n) begin
			read_state              <= CFG_CTRL_READ_IDLE;
			read_update_cnt         <= {READ_UPDATE_CNT_WIDTH{1'b1}};
			next_strobe_input_delay <= 10'd0;
			dqs_b_r                   <= 1'b0;
		end else begin
			case (read_state)

				// wait for start command and send read command
				CFG_CTRL_READ_IDLE: begin
					dqs_b_r <= 1'b0;
					if (cfg_start_read) begin
						read_state <= CFG_CTRL_READ_READ_STROBE_IDELAY_CSR_VAL;
					end
				end

				// wait for CSR read data on avalon bus
				CFG_CTRL_READ_READ_STROBE_IDELAY_CSR_VAL: begin
					if (avl_readdata_valid) begin
						next_strobe_input_delay <= avl_readdata[9:0] + STROBE_INPUT_DELAY_INCR;
						read_state <= CFG_CTRL_READ_READ_DATA;
					end
				end

				// wait for read results
				CFG_CTRL_READ_READ_DATA: begin
					if (sim_ctrl_read_done) begin
						if (sim_ctrl_read_success) begin
							read_state <= CFG_CTRL_READ_IDLE; // If read successful we are done
						end else begin
							read_state <= CFG_CTRL_READ_INCR_STROBE_DELAY; // Else keep searching for correct input delay
						end
					end
				end

				// wait for strobe input delay write to be accepted
				CFG_CTRL_READ_INCR_STROBE_DELAY: begin
					if (!avl_waitrequest) begin
						read_state <= CFG_CTRL_READ_WAIT_FOR_UPDATE;
					end
					read_update_cnt <= {READ_UPDATE_CNT_WIDTH{1'b1}};
				end

				// wait for changes to take effect
				CFG_CTRL_READ_WAIT_FOR_UPDATE: begin
					read_update_cnt <= read_update_cnt - {{(READ_UPDATE_CNT_WIDTH-1){1'b0}},1'b1};
					if (!dqs_b_r && cfg_strbs_r[2]) begin
						dqs_b_r <= 1'b1;
						read_state <= CFG_CTRL_READ_INCR_STROBE_DELAY; // need to update B as well in complementary case
					end else if (strobe_idelay_updated) begin
						dqs_b_r <= 1'b0;
						next_strobe_input_delay <= next_strobe_input_delay + STROBE_INPUT_DELAY_INCR;
						read_state <= CFG_CTRL_READ_READ_DATA;
					end
				end

				default: read_state <= CFG_CTRL_READ_IDLE;
			endcase
		end
	end

	////////////////////////////////////////////////////////////////////////////
	// Read Path Strobe Enable Delay Reconfig FSM
	////////////////////////////////////////////////////////////////////////////
	always @(posedge core_clk or negedge reset_n) begin
		if (!reset_n) begin
			read_en_state   <= CFG_CTRL_READ_EN_IDLE;
			read_en_update_cnt    <= {READ_EN_UPDATE_CNT_WIDTH{1'b1}};
			next_strobe_en_delay  <= 13'd0;
			next_data_input_delay <= 9'd0;
			cfg_pin_r             <= 6'd0;
			num_pins_in_grp_r     <= 6'd0;
		end else begin
			case (read_en_state)

				// wait for start command and send read command
				CFG_CTRL_READ_EN_IDLE: begin
					if (cfg_start_read_en) begin
						read_en_state <= CFG_CTRL_READ_EN_STROBE_SHIFT_CSR;
					end
				end

				// wait for CSR read on avalon bus
				CFG_CTRL_READ_EN_STROBE_SHIFT_CSR: begin
					if (avl_readdata_valid) begin
						next_strobe_en_delay <= avl_readdata[12:0] + 13'd10;
						read_en_state <= CFG_CTRL_READ_EN_READ_DATA0;
					end
				end

				// wait for read results
				CFG_CTRL_READ_EN_READ_DATA0: begin
					if (sim_ctrl_read_done) begin
						if (sim_ctrl_read_bit0_success) begin
							read_en_state <= CFG_CTRL_READ_EN_GET_NUM_PINS;
						end else begin
							read_en_state <= CFG_CTRL_READ_EN_INCR_STROBE_EN_DELAY;
						end
					end
				end

				// increment strobe enable delay and wait for changes to take effect
				CFG_CTRL_READ_EN_INCR_STROBE_EN_DELAY: begin
					if (!avl_waitrequest) begin
						read_en_state <= CFG_CTRL_READ_EN_WAIT_FOR_STROBE_UPDATE;
					end
					read_en_update_cnt <= {READ_EN_UPDATE_CNT_WIDTH{1'b1}};
				end

				// wait for strobe enable delay changes to take effect
				CFG_CTRL_READ_EN_WAIT_FOR_STROBE_UPDATE: begin
					read_en_update_cnt <= read_en_update_cnt - {{(READ_EN_UPDATE_CNT_WIDTH-1){1'b0}},1'b1};
					if (strobe_en_delay_updated) begin
						next_strobe_en_delay <= next_strobe_en_delay + 13'd10;
						read_en_state <= CFG_CTRL_READ_EN_READ_DATA0;
					end
				end

				// wait for param table read results
				CFG_CTRL_READ_EN_GET_NUM_PINS: begin
					if (avl_readdata_valid) begin
						num_pins_in_grp_r <= avl_readdata[7:0];
						next_data_input_delay <= DATA_INPUT_DELAY_INCR;
						read_en_state <= CFG_CTRL_READ_EN_READ_DATA;
					end
				end

				// wait for read results
				CFG_CTRL_READ_EN_READ_DATA: begin
					if (sim_ctrl_read_done) begin
						if (sim_ctrl_read_success) begin
							read_en_state <= CFG_CTRL_READ_EN_IDLE;
						end else begin
							read_en_state <= CFG_CTRL_READ_EN_INCR_DATA_DELAY;
						end
					end
					cfg_pin_r <= num_pins_in_grp_r - 6'd1;
				end

				// increment input data delay and wait for changes to take effect
				CFG_CTRL_READ_EN_INCR_DATA_DELAY: begin
					if (!avl_waitrequest) begin
						read_en_state <= CFG_CTRL_READ_EN_WAIT_FOR_DATA_UPDATE;
					end
					read_en_update_cnt <= {READ_EN_UPDATE_CNT_WIDTH{1'b1}};
				end

				// wait for data input changes to take effect
				CFG_CTRL_READ_EN_WAIT_FOR_DATA_UPDATE: begin
					if (cfg_pin_r != 6'h01) begin 
						read_en_state <= CFG_CTRL_READ_EN_INCR_DATA_DELAY;
					end else begin
						read_en_update_cnt <= read_en_update_cnt - {{(READ_EN_UPDATE_CNT_WIDTH-1){1'b0}},1'b1};
						if (strobe_en_delay_updated) begin
							next_data_input_delay <= next_data_input_delay + DATA_INPUT_DELAY_INCR;
							read_en_state <= CFG_CTRL_READ_EN_READ_DATA;
						end
					end
				end

				default: read_en_state <= CFG_CTRL_READ_EN_IDLE;
			endcase
		end
	end

endmodule
