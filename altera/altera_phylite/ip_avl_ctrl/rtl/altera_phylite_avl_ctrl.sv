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



module altera_phylite_avl_ctrl # (

	parameter [31:0] AVL_CTRL_IN_BASE_ADDR = 32'h00000000

	) (

	// Core Controller Avalon MM Interface
	avl_in_clk,           
	avl_in_reset_n,       
	avl_in_read,          
	avl_in_write,         
	avl_in_byteenable,    
	avl_in_writedata,     
	avl_in_address,       
	avl_in_readdata,      
	avl_in_readdata_valid,
	avl_in_waitrequest,
	
	// Avalon MM Dynamic Reconfiguration Interface
	avl_out_clk,           
	avl_out_reset_n,       
	avl_out_read,          
	avl_out_write,         
	avl_out_byteenable,    
	avl_out_writedata,     
	avl_out_address,       
	avl_out_readdata,      
	avl_out_readdata_valid,
	avl_out_waitrequest
	);

	////////////////////////////////////////////////////////////////////////////
	// Local Params
	////////////////////////////////////////////////////////////////////////////
	`include "altera_phylite_avl_ctrl_addr_offsets.iv"

	localparam AVL_CTRL_STATE_WIDTH = 4;
	localparam AVL_CTRL_CMD_OP_CODE_WIDTH =  8;
	localparam AVL_CTRL_CMD_DATA_WIDTH    = 25;
	localparam AVL_CTRL_CMD_WIDTH = AVL_CTRL_CMD_OP_CODE_WIDTH + AVL_CTRL_CMD_DATA_WIDTH;


	////////////////////////////////////////////////////////////////////////////
	// Enums
	////////////////////////////////////////////////////////////////////////////
	`include "altera_phylite_avl_ctrl_registers.iv"

	// FSM States
	typedef enum reg [3:0] {
		AVL_CTRL_IDLE             = 4'h0,
		AVL_CTRL_CMD_DECODE             ,
		AVL_CTRL_SET_INTERFACE_ID       ,
		AVL_CTRL_GET_NUM_GROUPS         ,
		AVL_CTRL_GET_GROUP_INFO         ,
		AVL_CTRL_GET_GROUP_PTRS         ,
		AVL_CTRL_GET_LANE_ADDR          ,
		AVL_CTRL_GET_PIN_ADDR           ,
		AVL_CTRL_WAIT_FOR_CAL_READ      ,
		AVL_CTRL_READ_CACHED_DATA       ,
		AVL_CTRL_WAIT_FOR_CAL_WRITE
		} avl_ctrl_state_t;

	////////////////////////////////////////////////////////////////////////////
	// Port Declarations
	////////////////////////////////////////////////////////////////////////////
	// Avalon MM Dynamic Reconfiguration Interface from Core
	input         avl_in_clk;           
	input         avl_in_reset_n;       
	input         avl_in_read;          
	input         avl_in_write;         
	input   [3:0] avl_in_byteenable;    
	input  [31:0] avl_in_writedata;     
	input  [31:0] avl_in_address;  // {interface_id[3:0],grp[4:0],pin[5:0],csr[0],register[7:0]}
	output [31:0] avl_in_readdata;      
	output        avl_in_readdata_valid;
	output        avl_in_waitrequest;

	// Avalon MM Dynamic Reconfiguration Interface to Column
	output        avl_out_clk;           
	output        avl_out_reset_n;       
	output        avl_out_read;          
	output reg    avl_out_write;         
	output  [3:0] avl_out_byteenable;    
	output [31:0] avl_out_writedata;     
	output [27:0] avl_out_address;       
	input  [31:0] avl_out_readdata;      
	input         avl_out_readdata_valid;
	input         avl_out_waitrequest;

	////////////////////////////////////////////////////////////////////////////
	// Wire Declarations
	////////////////////////////////////////////////////////////////////////////

	// Commands
	wire [AVL_CTRL_CMD_WIDTH - 1 : 0] core_cmd;
	wire                              core_cmd_vld;
	wire                     [31 : 0] ctrl_read_data;
	wire                              ctrl_read_data_vld;
	wire                              ctrl_rdy;

	wire [AVL_CTRL_CMD_OP_CODE_WIDTH - 1 : 0] cmd_op_code;
	wire    [AVL_CTRL_CMD_DATA_WIDTH - 1 : 0] cmd_data;
	wire                                      cmd_set;
	wire                                      cmd_csr;
	wire                                [4:0] cmd_grp;
	wire                                [5:0] cmd_pin;
	wire                                      cmd_dqs_b;
	wire                               [12:0] cmd_value;
	wire                                [3:0] cmd_interface_id;
	
	wire cmd_idelay;
	wire cmd_odelay;
	wire cmd_dqs_delay;
	wire cmd_dqs_en_delay;
	wire cmd_dqs_en_phase_shift;
	wire cmd_rd_valid_delay;

	reg cmd_idelay_r;
	reg cmd_odelay_r;
	reg cmd_dqs_en_phase_shift_r;

	wire lane_cmd;
	wire pin_cmd;

	wire  [1:0] lgc_sel;
	reg   [1:0] lgc_sel_r;
	wire [23:0] lgc_sel_addr;

	reg        cmd_set_r;
	reg        cmd_csr_r;
	reg  [4:0] cmd_grp_r;
	reg  [5:0] cmd_pin_r;
	reg [12:0] cmd_value_r;

	reg [AVL_CTRL_CMD_OP_CODE_WIDTH - 1 : 0] cmd_op_code_r;

	reg lane_cmd_r;
	reg pin_cmd_r;

	wire        pin_upper_half;
	wire  [1:0] lgc_sel_pin;
	wire  [3:0] current_pin;
	wire  [3:0] lane_pin_off;
	wire [12:0] lane_pin_addr;

	// Avalon
	reg  [23:0] avl_out_address_r;
	wire [12:0] intra_lane_addr;
	reg  [12:0] intra_lane_addr_r;
	wire [15:0] write_data;
	reg  [15:0] write_data_r;
	wire        avl_in_select;
	wire [31:0] avl_out_read_mask;
	reg         avl_out_read_r;
	wire  [7:0] avl_out_readdata_byte;
	wire [15:0] avl_out_readdata_halfword;

	// FSM states
	avl_ctrl_state_t state;

	// Cached Interface Info
	reg   [4:0] interface_id_r;
	reg  [15:0] interface_pt_ptr;
	reg   [5:0] interface_num_groups;

	// Cached Group Info
	reg   [4:0] cache_grp;
	reg   [2:0] cache_grp_num_lanes;
	reg   [5:0] cache_grp_num_pins;
	reg  [15:0] cache_grp_lane_addr_ptr;
	reg  [15:0] cache_grp_pin_addr_ptr;
	wire        read_cache_vld;
	wire [31:0] cache_data;

	// Cached Pin/Lane Addresses
	reg  [5:0] last_pin_r;
	reg [15:0] last_pin_addr_r;
	reg  [1:0] curr_lane;

	////////////////////////////////////////////////////////////////////////////
	// Assignments
	////////////////////////////////////////////////////////////////////////////
	// Translate Avalon from Core Addressing into internal commands
	assign avl_in_select         = (avl_in_address[31:24] == AVL_CTRL_IN_BASE_ADDR[31:24]);
	assign core_cmd_vld          = (avl_in_read | avl_in_write) & avl_in_select & ~avl_in_waitrequest;
	assign core_cmd              = {avl_in_address[7:0],avl_in_address[8],avl_in_address[19:15],avl_in_address[14:9],avl_in_writedata[12:0]};
	assign avl_in_readdata       = ctrl_read_data;
	assign avl_in_readdata_valid = ctrl_read_data_vld;
	assign avl_in_waitrequest    = ~ctrl_rdy;

	// Avalon to Column
	assign avl_out_clk            = avl_in_clk;
	assign avl_out_reset_n        = avl_in_reset_n;
	assign avl_out_address        = {interface_id_r[3:0],avl_out_address_r[23:2],2'b00};
	assign avl_out_byteenable     = 4'hF;
	assign avl_out_writedata      = {16'h0000,write_data_r};
	assign avl_out_read           = (((avl_out_read_r | ((avl_out_waitrequest === 1'b1) ? 1'b1 : 1'b0)) & ((avl_out_readdata_valid === 1'b1) ? 1'b0 : 1'b1)) & (~ctrl_rdy));

	assign avl_out_readdata_byte     = (avl_out_address_r[1:0] == 2'b11) ? avl_out_readdata[31:24] :
	                                   (avl_out_address_r[1:0] == 2'b10) ? avl_out_readdata[23:16] :
	                                   (avl_out_address_r[1:0] == 2'b01) ? avl_out_readdata[15:8]  :
	                                                                       avl_out_readdata[7:0]   ;
	assign avl_out_readdata_halfword = avl_out_address_r[1] ? avl_out_readdata[31:16] : avl_out_readdata[15:0];

	// Core
	assign avl_out_read_mask  = cmd_odelay_r ? 32'h00001FFF : 32'h00000FFF;
	assign ctrl_read_data     = read_cache_vld ? cache_data : (avl_out_readdata & avl_out_read_mask);
        assign ctrl_read_data_vld = read_cache_vld | (avl_out_readdata_valid & (state == AVL_CTRL_WAIT_FOR_CAL_READ));
	assign ctrl_rdy           = (state == AVL_CTRL_IDLE);

	// Cache Info Reads
	assign read_cache_vld = (state == AVL_CTRL_READ_CACHED_DATA);
	assign cache_data     = (cmd_op_code_r == AVL_CTRL_REG_NUM_GROUPS) ? {26'd0,interface_num_groups} : {21'd0,cache_grp_num_lanes,2'b00,cache_grp_num_pins};

	// Commands
	assign cmd_op_code = core_cmd[AVL_CTRL_CMD_WIDTH - 1 : AVL_CTRL_CMD_DATA_WIDTH];
	assign cmd_data    = core_cmd[AVL_CTRL_CMD_DATA_WIDTH - 1 : 0];

	// Command Decoding
	assign cmd_set          =  avl_in_write;
	assign cmd_interface_id =  avl_in_address[23:20] ;
	assign cmd_csr          =  cmd_data   [24] ; 
	assign cmd_grp          =  cmd_data[23:19] ; 
	assign cmd_pin          =  cmd_data[18:13] ;
	assign cmd_dqs_b        =  cmd_data   [13] ; 
	assign cmd_value        =  cmd_data [12:0] ; 

	assign cmd_idelay             = (cmd_op_code == AVL_CTRL_REG_IDELAY            );
	assign cmd_odelay             = (cmd_op_code == AVL_CTRL_REG_ODELAY            );
	assign cmd_dqs_delay          = (cmd_op_code == AVL_CTRL_REG_DQS_DELAY         );
	assign cmd_dqs_en_delay       = (cmd_op_code == AVL_CTRL_REG_DQS_EN_DELAY      );
	assign cmd_dqs_en_phase_shift = (cmd_op_code == AVL_CTRL_REG_DQS_EN_PHASE_SHIFT);
	assign cmd_rd_valid_delay     = (cmd_op_code == AVL_CTRL_REG_RD_VALID_DELAY    );

	assign lane_cmd = (cmd_op_code == AVL_CTRL_REG_DQS_DELAY         ) |
	                  (cmd_op_code == AVL_CTRL_REG_DQS_EN_DELAY      ) |
	                  (cmd_op_code == AVL_CTRL_REG_DQS_EN_PHASE_SHIFT) |
	                  (cmd_op_code == AVL_CTRL_REG_RD_VALID_DELAY    ) ;
	assign pin_cmd  = (cmd_op_code == AVL_CTRL_REG_IDELAY            ) |
	                  (cmd_op_code == AVL_CTRL_REG_ODELAY            ) ;

	assign lgc_sel = (cmd_dqs_delay | cmd_dqs_en_phase_shift) ? {cmd_dqs_b,~cmd_dqs_b} : 2'b00;
	assign lgc_sel_addr = (cmd_dqs_en_phase_shift_r & cmd_csr_r) ? {20'h00000,lgc_sel_r,2'b00} : {15'h0000,lgc_sel_r,7'h00};

	assign current_pin = (state == AVL_CTRL_GET_PIN_ADDR) ? avl_out_readdata_halfword[3:0] : last_pin_addr_r[3:0];
	assign pin_upper_half = (current_pin > 4'h5);
	assign lgc_sel_pin = cmd_idelay_r ? {pin_upper_half,~pin_upper_half} : 2'b00;
	assign lane_pin_off  = pin_upper_half ? current_pin - 4'h6 : current_pin;
	assign lane_pin_addr = cmd_odelay_r ? {1'b0,current_pin,8'h00} : {4'h0,lgc_sel_pin,lane_pin_off[2:0],4'h0};

	assign write_data = ((cmd_op_code == AVL_CTRL_REG_IDELAY) | (cmd_op_code == AVL_CTRL_REG_DQS_DELAY)) ? {3'h0,1'b1,cmd_value[11:0]} : {1'b1,2'b00,cmd_value};

	////////////////////////////////////////////////////////////////////////////
	// Intra-Lane Avalon Addressing
	////////////////////////////////////////////////////////////////////////////
	assign intra_lane_addr = (~cmd_set & cmd_csr) ? (cmd_idelay             ? 13'h1FFF               : // CSR read not supported
	                                                 cmd_odelay             ? {5'h00,8'hE8}          : // {pin{4:0],8'E8}
	                                                 cmd_dqs_delay          ? 13'h1FFF               : // CSR read not supported
	                                                 cmd_dqs_en_delay       ? {4'hC,9'h1A8}          :
	                                                 cmd_dqs_en_phase_shift ? {4'hC,9'h190}          : // {5'h19,lgc_sel[1:0],2'b00}
	                                                 cmd_rd_valid_delay     ? {4'hC,9'h1A4}          :
	                                                                          13'h1FFF               ) :
	                                                (cmd_idelay             ? {4'hC,2'b00,3'h0,4'h0} : // {4'hC,lgc_sel[1:0],pin[2:0],4'h0}
	                                                 cmd_odelay             ? {5'h00,8'hD0}          : // {1'b0,pin[3:0],8'D0}
	                                                 cmd_dqs_delay          ? {4'hC,2'b00,3'h6,4'h0} : // {4'hC,lgc_sel[1:0],3'h6,4'h0}
	                                                 cmd_dqs_en_delay       ? {4'hC,9'h008}          :
	                                                 cmd_dqs_en_phase_shift ? {4'hC,2'b00,3'h7,4'h0} : // {4'hC,lgc_sel[1:0],3'h7,4'h0}
	                                                 cmd_rd_valid_delay     ? {4'hC,9'h00C}          :
	                                                                          13'h1FFF               ) ;

	////////////////////////////////////////////////////////////////////////////
	// Command Registers
	////////////////////////////////////////////////////////////////////////////

	always @(posedge avl_in_clk or negedge avl_in_reset_n) begin
		if (!avl_in_reset_n) begin
			cmd_op_code_r            <= {AVL_CTRL_CMD_OP_CODE_WIDTH{1'b0}};
			cmd_set_r                <= 1'b0;
			interface_id_r           <= 5'h1F; // invalidate on reset
			cmd_csr_r                <= 1'b0; 
			cmd_grp_r                <= 5'b0; 
			cmd_pin_r                <= 6'b0; 
			cmd_value_r              <= 13'd0; 
			intra_lane_addr_r        <= 13'h1FFF ;
			lane_cmd_r               <= 1'b0;
			pin_cmd_r                <= 1'b0;
			write_data_r             <= 16'h0000;
			lgc_sel_r                <= 2'b00;
			cmd_idelay_r             <= 1'b0;
			cmd_odelay_r             <= 1'b0;
			cmd_dqs_en_phase_shift_r <= 1'b0;
		end else begin
			cmd_op_code_r            <= core_cmd_vld ? cmd_op_code             : cmd_op_code_r;
			cmd_set_r                <= core_cmd_vld ? cmd_set                 : cmd_set_r                ;
			interface_id_r           <= core_cmd_vld ? {1'b0,cmd_interface_id} : interface_id_r           ;
			cmd_csr_r                <= core_cmd_vld ? (cmd_csr & ~cmd_set)    : cmd_csr_r                ; 
			cmd_grp_r                <= core_cmd_vld ? cmd_grp                 : cmd_grp_r                ; 
			cmd_pin_r                <= core_cmd_vld ? cmd_pin                 : cmd_pin_r                ; 
			cmd_value_r              <= core_cmd_vld ? cmd_value               : cmd_value_r              ; 
			intra_lane_addr_r        <= core_cmd_vld ? intra_lane_addr         : intra_lane_addr_r        ;
			lane_cmd_r               <= core_cmd_vld ? lane_cmd                : lane_cmd_r               ;
			pin_cmd_r                <= core_cmd_vld ? pin_cmd                 : pin_cmd_r                ;
			write_data_r             <= core_cmd_vld ? write_data              : write_data_r             ;
			lgc_sel_r                <= core_cmd_vld ? lgc_sel                 : lgc_sel_r                ;
			cmd_idelay_r             <= core_cmd_vld ? cmd_idelay              : cmd_idelay_r             ;
			cmd_odelay_r             <= core_cmd_vld ? cmd_odelay              : cmd_odelay_r             ;
			cmd_dqs_en_phase_shift_r <= core_cmd_vld ? cmd_dqs_en_phase_shift  : cmd_dqs_en_phase_shift_r ;
		end
	end

	////////////////////////////////////////////////////////////////////////////
	// Avalon Control FSM
	////////////////////////////////////////////////////////////////////////////


	always @(posedge avl_in_clk or negedge avl_in_reset_n) begin
		if (!avl_in_reset_n) begin
			// Avalon outputs
			avl_out_read_r     <= 1'b0;
			avl_out_write      <= 1'b0;
			avl_out_address_r  <= 24'h000000;

			// FSM registers
			state <= AVL_CTRL_IDLE;

			// Cached Interface Info
			interface_pt_ptr     <= 16'h0000;
			interface_num_groups <= 6'h00;

			// Cached Group Info
			cache_grp               <= 5'h1F; // start with invalid group
			cache_grp_num_lanes     <= 3'b000;
			cache_grp_num_pins      <= 6'h00;
			cache_grp_lane_addr_ptr <= 16'h0000;
			cache_grp_pin_addr_ptr  <= 16'h0000;
			
			// Cached Pin/Lane Addresses
			curr_lane       <= 2'b11;
			last_pin_r      <= 6'h3F;
			last_pin_addr_r <= 16'hFFFF;

		end else begin
			case (state)

				// Wait for a core command
				AVL_CTRL_IDLE: begin

					// Check for new valid command and decode
					if (core_cmd_vld) begin
						if ({1'b0,cmd_interface_id} != interface_id_r) begin
							avl_out_read_r <= 1'b1;
							avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + 24'd24; // first interface PT pointer
							state <= AVL_CTRL_SET_INTERFACE_ID;
						end else begin
							state <= AVL_CTRL_CMD_DECODE;
						end
					end
				end

				// Decode core command
				AVL_CTRL_CMD_DECODE: begin
						if (cmd_op_code_r == AVL_CTRL_REG_NUM_GROUPS) begin
							state <= AVL_CTRL_READ_CACHED_DATA;
						end else if (cmd_op_code_r == AVL_CTRL_REG_GROUP_INFO) begin
							if ( cmd_grp_r == cache_grp ) begin
								state <= AVL_CTRL_READ_CACHED_DATA;
							end else begin
								avl_out_read_r <= 1'b1;
								avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + {8'h00,interface_pt_ptr} + 24'd8 + {19'd0,cmd_grp_r}; // group num lanes and num pins
								state <= AVL_CTRL_GET_GROUP_INFO;
							end
						end else begin // GET or SET op_code
							curr_lane <= 2'b11;
							if ( cmd_grp_r == cache_grp ) begin
								if (lane_cmd_r) begin
									curr_lane <= cache_grp_num_lanes - 3'd1;
									avl_out_read_r <= 1'b1;
									avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + {8'h00, cache_grp_lane_addr_ptr} + {21'd0, (cache_grp_num_lanes - 3'd1)};
									state <= AVL_CTRL_GET_LANE_ADDR;
								end else if (pin_cmd_r) begin
									if (cmd_pin == last_pin_r) begin
										avl_out_write <=  cmd_set_r;
										avl_out_read_r  <= ~cmd_set_r;
										avl_out_address_r <= AVL_CTRL_CAL_BUS_BASE_ADDR | {3'h0, last_pin_addr_r[15:8], intra_lane_addr_r} | {11'h000,lane_pin_addr};
										state <= cmd_set_r ? AVL_CTRL_WAIT_FOR_CAL_WRITE : AVL_CTRL_WAIT_FOR_CAL_READ;
									end else begin
										last_pin_r <= cmd_pin_r;
										avl_out_read_r <= 1'b1;
										avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + {8'h00, cache_grp_pin_addr_ptr} + {17'd0, cmd_pin_r, 1'b0};
										state <= AVL_CTRL_GET_PIN_ADDR;
									end
								end
							end else begin
								avl_out_read_r <= 1'b1;
								avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + {8'h00,interface_pt_ptr} + 24'd8 + {19'd0,cmd_grp_r}; // group num lanes and num pins
								state <= AVL_CTRL_GET_GROUP_INFO;
							end
						end
				end

				////////////////////////////////////////////////
				// Interface Info
				////////////////////////////////////////////////

				// Get the interface information based on set ID
				AVL_CTRL_SET_INTERFACE_ID: begin
					avl_out_read_r <= avl_out_waitrequest;
					if (avl_out_readdata_valid) begin
						if (avl_out_readdata[31:24] == {4'h8,interface_id_r[3:0]}) begin
							interface_pt_ptr <= avl_out_readdata[15:0];
							avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + {8'h00,avl_out_readdata[15:0]} + 24'd4; // interface num groups
							state <= AVL_CTRL_GET_NUM_GROUPS;
						end else begin
							avl_out_address_r <= avl_out_address_r + 24'h4;
						end
						avl_out_read_r <= 1'b1;
					end
				end

				// Get the number of groups in the interface
				AVL_CTRL_GET_NUM_GROUPS: begin
					avl_out_read_r <= avl_out_waitrequest;
					if (avl_out_readdata_valid) begin
						interface_num_groups <= avl_out_readdata_byte[5:0];
						state <= AVL_CTRL_CMD_DECODE;
					end
					// Invalidate caches
					cache_grp   <= 5'h1F;
					last_pin_r  <= 6'h3F;
				end

				////////////////////////////////////////////////
				// Group Info
				////////////////////////////////////////////////

				// Get group info from the interface parameter table
				AVL_CTRL_GET_GROUP_INFO: begin
					avl_out_read_r <= avl_out_waitrequest;
					if (avl_out_readdata_valid) begin
						cache_grp_num_lanes <= {1'b0,avl_out_readdata_byte[7:6]} + 3'd1;
						cache_grp_num_pins  <= avl_out_readdata_byte[5:0];

						curr_lane <= {1'b0,avl_out_readdata_byte[7:6]}; // If lane command is the first command run, need to updated the curr_lane here

						avl_out_read_r <= 1'b1;
						avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + {8'h00,interface_pt_ptr} + 24'd12 + {18'd0,interface_num_groups[5:2],2'b00} + {17'd0,cmd_grp_r,2'b00}; // group lane/pin table pointers - 2 16-bit pointers (4-bytes) per group
						state <= AVL_CTRL_GET_GROUP_PTRS;
					end
				end

				// Get group pointers to pin and lane address look-up tables from interface parameter table
				AVL_CTRL_GET_GROUP_PTRS: begin
					avl_out_read_r <= avl_out_waitrequest;
					if (avl_out_readdata_valid) begin
						cache_grp_lane_addr_ptr <= avl_out_readdata[31:16];
						cache_grp_pin_addr_ptr  <= avl_out_readdata[15:0];

						avl_out_read_r      <= (lane_cmd_r | pin_cmd_r);
						avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + (lane_cmd_r ? ({8'h00, avl_out_readdata[31:16]} + curr_lane) : ({8'h00,avl_out_readdata[15:0]} + {17'd0, cmd_pin_r, 1'b0}));

						state <= (cmd_op_code_r == AVL_CTRL_REG_GROUP_INFO) ? AVL_CTRL_READ_CACHED_DATA :
						         (lane_cmd_r)                               ? AVL_CTRL_GET_LANE_ADDR    :
						                                                      AVL_CTRL_GET_PIN_ADDR     ;
					end
					cache_grp <= cmd_grp_r;
					// Invalidate last pin/lane
					last_pin_r  <= 6'h3F;
				end

				////////////////////////////////////////////////
				// Lane R/W
				////////////////////////////////////////////////

				// Wait for valid read data (lane address look-up) on Avalon bus
				AVL_CTRL_GET_LANE_ADDR: begin
					avl_out_read_r <= avl_out_waitrequest;
					if (avl_out_readdata_valid) begin
						avl_out_write <=  cmd_set_r;
						avl_out_read_r  <= ~cmd_set_r;
						avl_out_address_r <= AVL_CTRL_CAL_BUS_BASE_ADDR | {3'h0, avl_out_readdata_byte[7:0],intra_lane_addr_r} | lgc_sel_addr;
						state <= cmd_set_r ? AVL_CTRL_WAIT_FOR_CAL_WRITE : AVL_CTRL_WAIT_FOR_CAL_READ;
					end
				end

				////////////////////////////////////////////////
				// Pin R/W
				////////////////////////////////////////////////

				// Wait for valid read data (pin address look-up) on Avalon bus
				AVL_CTRL_GET_PIN_ADDR: begin
					avl_out_read_r <= avl_out_waitrequest;
					if (avl_out_readdata_valid) begin
						avl_out_write <=  cmd_set_r;
						avl_out_read_r  <= ~cmd_set_r;
						avl_out_address_r <= AVL_CTRL_CAL_BUS_BASE_ADDR | {3'h0, avl_out_readdata_halfword[15:8], intra_lane_addr_r} | {11'h000,lane_pin_addr};
						state <= cmd_set_r ? AVL_CTRL_WAIT_FOR_CAL_WRITE : AVL_CTRL_WAIT_FOR_CAL_READ;
						last_pin_addr_r <= avl_out_readdata_halfword[15:0];
					end
				end

				////////////////////////////////////////////////
				// Reads
				////////////////////////////////////////////////

				// Wait for valid read data on Avalon bus
				AVL_CTRL_WAIT_FOR_CAL_READ: begin
					avl_out_read_r <= avl_out_waitrequest;
					if (avl_out_readdata_valid) begin
						state <= AVL_CTRL_IDLE;
					end
				end

				// Output requested data from cache to core
				AVL_CTRL_READ_CACHED_DATA: begin
					state <= AVL_CTRL_IDLE;
				end

				////////////////////////////////////////////////
				// Writes
				////////////////////////////////////////////////

				// Wait for avl_out_waitrequest to signal write data accepted on Avalon bus
				AVL_CTRL_WAIT_FOR_CAL_WRITE: begin
					if (!avl_out_waitrequest) begin
						avl_out_write <= 1'b0;
						state <= (lane_cmd_r & (curr_lane != 2'b00)) ? AVL_CTRL_GET_LANE_ADDR : AVL_CTRL_IDLE; // must write to all lanes in a group
						curr_lane <= curr_lane - 2'd1;
						avl_out_read_r <= (lane_cmd_r & (curr_lane != 2'b00));
						avl_out_address_r <= AVL_CTRL_GPT_BASE_ADDR + {8'h00, cache_grp_lane_addr_ptr} + {22'd0, (curr_lane - 2'd1)};
					end
				end

				default: state <= AVL_CTRL_IDLE;
			endcase
		end
	end

endmodule
